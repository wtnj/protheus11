/*
+--------------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                              !
+--------------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                            !
+------------------+-------------------------------------------------------------+
!Modulo            ! FAT - Faturamento                                           !
+------------------+-------------------------------------------------------------+
!Nome              ! NHFAT040.PRW                                                !
+------------------+-------------------------------------------------------------+
!Descricao         ! Imprime Etiquetas de Identificação Nissan do Brasil         !
+------------------+-------------------------------------------------------------+
!Autor             ! Edenilson Santos                                            !
+------------------+-------------------------------------------------------------+
!Data de Criacao   ! 16/10/2013                                                  !
+------------------+-------------------------------------------------------------!
!  Parametros: 01 cTypeBar String com o tipo do codigo de barras                 !
!              	       "EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"              !
!                 		 "INT25","MAT25,"IND25","CODABAR" ,"CODE3_9"             !
!              02 nRow	  Numero da Linha em centimentros                        !
!              03 nCol	  Numero da coluna em centimentros	                     !
!              04 cCode	  String com o conteudo do codigo                        !
!              05 oPr	  Objeto Printer                                         !
!              06 lcheck   Se calcula o digito de controle                       !
!              07 Cor 	  Numero  da Cor, utilize a "common.ch"                  !
!              08 lHort	  Se imprime na Horizontal                               !
!              09 nWidth   Num do Tamanho da largura da barra em centimet        !
!              10 nHeigth  Numero da Altura da barra em milimetros               !
!              11 lBanner  Se imprime o linha em baixo do codigo                 !
!              12 cFont	  String com o tipo de fonte                             !
!              13 cMode	  String com o modo do codigo de barras CODE128          !
+------------------+-------------------------------------------------------------+
!   ATUALIZACOES                                                                 !
+-------------------------------------------+-----------+------------+-----------+
!   Descricao detalhada da atualizacao      !Nome do    ! Analista   !Data da    !
!                                           !Solicitante! Responsavel!Atualizacao!
+-------------------------------------------+-----------+------------+-----------+
!Atualização da impressão do código de barra!           !            !           !
!que estava desposicionando dependendo do lo!           !            !           !
!cal de impressão selecionado               !Adir       !Edenilson   ! 25/04/2014! 
+-------------------------------------------+-----------+------------+-----------+
*/
#include "rwmake.ch"
#include "topconn.ch"

User Function NHFAT040()
SetPrvt("_cArqDbf, cQuery,_aFields,aCampos,cMarca,cNovaLinha,cARQEXP ,cARQ,nPbruto,i,nqtde,netiq,nVol")

//-----------------------------------------------------------------------------------------------------
//  verifica se tem o bmp para impressao.
//-----------------------------------------------------------------------------------------------------
/*
Private cStartPath 	:= GetSrvProfString("Startpath","")

If Right(cStartPath,1) <> "\"
	cStartPath += "\"
Endif

If !File(cStartPath+"IMG003.BMP")
	MsgAlert("Bitmaps nao encontrados, baixar arquivo do FTP !","Atencao !")
	Return Nil
Endif
*/
_cArqDBF:=SPACE(12)
nPbruto  :=  0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // Da Nota ?                                    ³
//³ mv_par02     // Ate a Nota ?                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AjustaSx1("FAT040")

/*
+----------------------------------------------------------+
! Variaveis utilizadas para parametros                     !
! mv_par01            // da data da baixa                  !
! mv_par02            // ate a data da baixa               !
! mv_par03            // do fornecedor                     !
! mv_par04            // ate o fornecedor                  !
! mv_par05            // da loja                           !
! mv_par06            // ate a loja                        !
! mv_par07            // considera filiais abaixo          !
! mv_par08            // da filial                         !
! mv_par09            // ate a filial                      !
+----------------------------------------------------------+
*/

If Pergunte('FAT040',.T.)
	
	Processa({|| MontaQuery() }, "Aguarde, Reunindo informações...")
	
	If File( _cArqDBF )
		fErase(_cArqDBF)  // Deleta arquivo de dados temporario
	Endif
	
	DbSelectArea("TMP")
	DbCloseArea()
	
	DbSelectArea("ETQ")
	DbCloseArea()
	
Endif

Return

Static Function MontaQuery()

cQuery := "SELECT D2.D2_DOC,D2.D2_COD,D2.D2_EMISSAO,D2.D2_QUANT,D2.D2_CLIENTE,D2.D2_LOJA,B1.B1_PESO,C5.C5_PBRUTO,C5.C5_VOLUME1,C6.C6_DESCRI,B1.B1_CODAP5,B5.B5_EMB1,"
cQuery += "A1.A1_NOME,A1.A1_END,A1.A1_MUN,A7.A7_CODCLI,A7.A7_PRODUTO,A7.A7_DESCCLI, A7.A7_PCCLI "
cQuery += "FROM " +  RetSqlName( 'SD2' ) +" D2 (NOLOCK) "

cQuery += "INNER JOIN " + RetSqlName('SC5')  + " C5 (NOLOCK) ON "
cQuery += "           C5.C5_FILIAL  = '"+ xFilial('SC5')+ "' "
cQuery += "       AND C5.C5_NOTA    = D2.D2_DOC "
cQuery += "       AND C5.C5_SERIE   = D2.D2_SERIE "
cQuery += "       AND C5.D_E_L_E_T_ = '' "

cQuery += "INNER JOIN " + RetSqlName('SC6') + " C6 (NOLOCK) ON "
cQuery += "           C6.C6_FILIAL  = '"+ xFilial('SC6')+ "' "
cQuery += "       AND C6.C6_NOTA    = D2.D2_DOC "
cQuery += "       AND C6.C6_SERIE   = D2.D2_SERIE "
cQuery += "       AND C6.C6_PRODUTO = D2.D2_COD "
cQuery += "       AND C6.D_E_L_E_T_ = '' "

cQuery += "INNER JOIN " + RetSqlName('SB1') + " B1 (NOLOCK) ON "
cQuery += "           B1.B1_FILIAL  = '" + xFilial('SB1') + "' "
cQuery += "       AND B1.B1_COD     = D2.D2_COD "
cQuery += "       AND B1.D_E_L_E_T_ = '' "

cQuery += "INNER JOIN " + RetSqlName('SB5') + " B5 (NOLOCK) ON "
cQuery += "           B5.B5_FILIAL  = '" + xFilial('SB5') + "' "
cQuery += "       AND B5.B5_COD     = D2.D2_COD "
cQuery += "       AND B5.D_E_L_E_T_ = '' "

cQuery += "INNER JOIN " + RetSqlName('SA1') + " A1 (NOLOCK) ON "
cQuery += "           A1.A1_FILIAL = '" + xFilial("SA1")+ "' "
cQuery += "       AND A1.A1_COD  = D2.D2_CLIENTE "
cQuery += "       AND A1.A1_LOJA = D2.D2_LOJA "
cQuery += "       AND A1.D_E_L_E_T_ = '' "

cQuery += "INNER JOIN " + RetSqlName('SA7') + " A7 (NOLOCK) ON "
cQuery += "           A7.A7_PRODUTO = D2.D2_COD "
cQuery += "       AND A7.A7_CLIENTE = D2.D2_CLIENTE "
cQuery += "       AND A7.A7_LOJA    = D2.D2_LOJA "
cQuery += "       AND A7.D_E_L_E_T_ = '' "

cQuery += " WHERE D2.D2_DOC BETWEEN '" + Mv_par01 + "' AND '" + Mv_par02 + "' "
cQuery += " AND D2.D2_FILIAL  = '"+ xFilial('SD2')+ "' "
cQuery += " AND D2.D2_CLIENTE = '900287' "
cQuery += " AND D2.D2_LOJA    IN ('01','02') "
cQuery += " AND D2.D_E_L_E_T_ = '' "
cQuery += " ORDER BY D2.D2_DOC ASC"

MemoWrit('C:\TEMP\fat021.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"
DbSelectArea("TMP")

Processa( {|| RptDe2() }, "Aguarde, Gerando arquivo de etiquetas...")

Return

Static Function RptDe2()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando Arquivo Temporario para posterior impressao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cArqDBF  := CriaTrab(NIL,.f.)
_cArqDBF += ".DBF"
_aFields := {}

AADD(_aFields,{"OK"      ,"C",02,00})        // Controle do browse
AADD(_aFields,{"LOCAL"   ,"C",12,00})        // Local de Utilizacao
AADD(_aFields,{"NOTA"    ,"C",09,00})        // Numero da Nota
AADD(_aFields,{"EMITENTE","C",32,00})        // Nome do Emitente
AADD(_aFields,{"PLIQUI"  ,"C",06,00})        // Peso Liquido
AADD(_aFields,{"PBRUTO"  ,"C",06,00})        // Peso Bruto
AADD(_aFields,{"CAIXA",   "C",05,00})        // Qtde de caixas em palletes ou rack = UM = Unidade de Manuseio
AADD(_aFields,{"PRODUTO", "C",20,00})        // Codigo do Produto
AADD(_aFields,{"QUANT",   "C",09,00})        // Quantidade do Produto
AADD(_aFields,{"DESC",    "C",22,00})        // Descricao do Produto
AADD(_aFields,{"REFFOR",  "C",10,00})        // Referencia do Fornecedor
AADD(_aFields,{"FORNECE", "C",30,00})        // Codigo do fornecedor
AADD(_aFields,{"DTA",     "C",10,00})        // Data
AADD(_aFields,{"MODIFI",  "C",14,00})        // Indice de modificacao do produto ex. Versao 004
AADD(_aFields,{"ETIQ",    "C",09,00})        // Numero da etiqueta tem que ser seguqncial por um ano (MV_ETQ)
AADD(_aFields,{"LOTE",    "C",12,00})        // Numero do Lote
AADD(_aFields,{"DESTINO", "C",20,00})        // Nome do destinatario
AADD(_aFields,{"EMBALA",  "C",02,00})        // Embalagem = UC = unidade de condicionamento
AADD(_aFields,{"SEGU",    "C",01,00})        // Peca de seguranca
AADD(_aFields,{"NOME",    "C",30,00})        // Peca de seguranca
AADD(_aFields,{"ENDE",    "C",30,00})        // Peca de seguranca
AADD(_aFields,{"MUN",     "C",30,00})        // Peca de seguranca
AADD(_aFields,{"CODEMB",  "C",08,00})        // Código da Embalagem
AADD(_aFields,{"NUMRAM",  "C",20,00})        // Numero do Ran

DbCreate(_cArqDBF,_aFields)
DbUseArea(.T.,,_cArqDBF,"ETQ",.F.)

TMP->(DBGotop())
ProcRegua(TMP->(RecCount()))

While !TMP->(EOF())
	
	nEtiq := Val(GetMv("MV_ETQ")) //Pega o qtde de etq que já foram enviadas
	nQtde := TMP->D2_QUANT        //Pega a qtde do item para calculo do peso
	nVol  := mv_par06 * mv_par07  //TMP->C5_VOLUME1 * 2 //qtde de volumes de cx p/ frança
	
	//   For i := 1 to nVol //qtde de volumes
	For i := 1 to mv_par07  //qtde de volumes
		nEtiq++
		IncProc("Processando...")
		RecLock("ETQ",.T.)
		ETQ->OK        := Space(02)
		ETQ->LOCAL     := "  " //Doca de entrega                                *
		ETQ->NOTA      := TMP->D2_DOC
		ETQ->CODEMB    := Substr(Alltrim(TMP->B5_EMB1),1,8)
		ETQ->EMITENTE  := "ITESAPAR FUND. S/A PALMEIRA-PR"
		ETQ->NOME      := TMP->A1_NOME
		ETQ->ENDE      := TMP->A1_END
		ETQ->MUN       := TMP->A1_MUN
		ETQ->CAIXA     := Transform(1,"@E 99999")
		ETQ->PRODUTO   := TMP->A7_PRODUTO
		ETQ->DESC      := TMP->A7_DESCCLI
		ETQ->REFFOR    := Alltrim(TMP->A7_CODCLI)
		ETQ->FORNECE   := 'ITESAPAR FUND. S/A PALMEIRA-PR'
		ETQ->DTA       := Subs(TMP->D2_EMISSAO,7,2)+"/"+Subs(TMP->D2_EMISSAO,5,2)+"/"+Subs(TMP->D2_EMISSAO,1,4)
		ETQ->MODIFI    := Substr(Alltrim(TMP->A7_PCCLI),1,7) //Space(14)
		ETQ->LOTE      := Space(12)
		ETQ->DESTINO   := 'NISSAN DO BRASIL'
		ETQ->QUANT     := Transform(TMP->D2_QUANT,"@E 999999999")                 //Transform(mv_par06,"@E 999999999")
		ETQ->PLIQUI    := Transform(TMP->B1_PESO * TMP->D2_QUANT, "@e 9999.9999") //Transform(TMP->B1_PESO * mv_par06     , "@e 9999.9999")
		ETQ->PBRUTO    := Transform(Val(ETQ->PLIQUI) + mv_par05 , "@e 9999.9999")
		ETQ->EMBALA    := Space(02)
		ETQ->SEGU      := Space(01)
		//ETQ->ETIQ      := StrZero(nEtiq,9) //,"@e 999999999")		
		//ETQ->ETIQ      := StrZero(TMP->D2_DOC,9) //,"@e 999999999")				// Número do Lote = Número da Nota fiscal 
		//ETQ->NUMRAN    := Alltrim(TMP->A7_PCCLI)
		
		MsUnlock("ETQ")
		
	Next i
	
	SX6->(DbSeek(xFilial()+"MV_ETQ"))
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD:= ETQ->ETIQ
	MsUnlock()
	
	TMP->(DbSkip())
	
EndDo

cMarca  := GetMark()
aCampos := {}

Aadd(aCampos,{"OK"        ,"OK"                      ,"@!"})
//Aadd(aCampos,{"ETIQ"      ,"Nº.Etiq"                 , "@!"})
Aadd(aCampos,{"NOTA"      ,"Nota"                    , "@!"})
Aadd(aCampos,{"DTA"       ,"Data"                    , "@!"})
Aadd(aCampos,{"PRODUTO"   ,"Cód.Prod. (Interno)"     , "@!"})
Aadd(aCampos,{"REFFOR"    ,"Cód. Produto (NBA)"      , "@!"})
Aadd(aCampos,{"DESC"      ,"Decricao do Produto(NBA)", "@!"})
Aadd(aCampos,{"QUANT"     ,"Quantidade"              , "@!"})
Aadd(aCampos,{"FORNECE"   ,"Fornecedor"              , "@!"})
Aadd(aCampos,{"DESTINO"   ,"Destinatario"            , "@!"})
//Aadd(aCampos,{"NOTA"      ,"Nº.Lote"                 , "@!"})

ETQ->(DbGoTop())

@ 050,001 to 400,1000 dialog oDlg title 'Emissao de Etiquetas de Identificação NISSAN DO BRASIL'
@ 006,005 to 150,500 browse "ETQ"
@ 006,005 to 150,500 browse "ETQ" FIELDS aCampos mark "OK"
@ 155,230 button "_Imprimir" size 40,15 action ImpEtiq()
@ 155,275 button "_Cancelar" size 40,15 action Close(oDlg)
activate dialog oDlg centered

Return

*-----------------------*
Static Function ImpEtiq()
*-----------------------*
Local aEtiq := {}
Local nWidth  := 0.0330 //Comprimento do cod.de barras (centimetros)
Local nHeigth := 0.991  //Largura do cod.de barras (milimetros)
//Local nLinBar := 3.0  //Linha inicial do cod. de barras da etiqueta
//Local nWidth  := 9.7  //Comprimento do cod.de barras (centimetros)
//Local nHeigth := 1.3  //Largura do cod.de barras (milimetros)//

Local nLinBar := 1.0   //Linha inicial do cod. de barras da etiqueta
Local nLinTex := 200   //240
Local nColBar := 1     //Coluna Inicial do cod. de barras
Local nColTex := 0     //Coluna Inicial do texto da etiqueta
Local nColAtu := 1     //Numero de colunas da impressas
Local nLinAtu := 1     //Numero de linhas impressas
Local nAjust  := 1

oFont08  := TFont():New("Helvetica",,08,,.F.)
oFont10  := TFont():New("Helvetica",,10,,.F.)
oFont12  := TFont():New("Helvetica",,12,,.F.)
oFont14  := TFont():New("Helvetica",,14,,.F.)
oFont16  := TFont():New("Helvetica",,16,,.F.)
oFont18  := TFont():New("Helvetica",,18,,.F.)
oFont20  := TFont():New("Helvetica",,20,,.F.)
oFont22  := TFont():New("Helvetica",,22,,.F.)
oFont24  := TFont():New("Helvetica",,24,,.F.)
oFont28  := TFont():New("Helvetica",,28,,.F.)
oFont34  := TFont():New("Helvetica",,34,,.F.)
oFont44  := TFont():New("Helvetica",,44,,.F.)
oFont80  := TFont():New("Helvetica",,80,,.F.)

oFont08N := TFont():New("Helvetica",,08,,.T.)
oFont10N := TFont():New("Helvetica",,10,,.T.)
oFont12N := TFont():New("Helvetica",,12,,.T.)
oFont14N := TFont():New("Helvetica",,14,,.T.)
oFont16N := TFont():New("Helvetica",,16,,.T.)
oFont18N := TFont():New("Helvetica",,18,,.T.)
oFont20N := TFont():New("Helvetica",,20,,.T.)
oFont22N := TFont():New("Helvetica",,22,,.T.)
oFont24N := TFont():New("Helvetica",,24,,.T.)
oFont28N := TFont():New("Helvetica",,28,,.T.)
oFont34N := TFont():New("Helvetica",,34,,.T.)
oFont44N := TFont():New("Helvetica",,44,,.T.)
oFont80N := TFont():New("Helvetica",,80,,.T.)

//oPr:= tAvPrinter():New("Protheus")
oPr:= TMSPrinter():New(OemToAnsi('Emissao de Etiquetas de Identificação NISSAN DO BRASIL'))
oPr:StartPage()

ProcRegua(ETQ->(RecCount()))

ETQ->(DbGoTop())

While !ETQ->(eof())
	
	If MARKED("OK")
		
		IncProc("Imprimindo Etiqueta Nissan")
		
		oPr:Line(0020,0020,0020,2350) // Horizontal 1ª linha
		oPr:Line(0125,0020,0125,2350) // Horizontal 2ª linha
		oPr:Line(0215,1200,0215,2350) // Horizontal 3ª Linha
		oPr:Line(0305,0020,0305,2350) // Horizontal 4ª Linha
		oPr:Line(0605,0020,0605,2350) // Horizontal 5º linha
		oPr:Line(0720,1200,0720,2350) // Horizontal 6º linha
		oPr:Line(0840,0020,0840,2350) // Horizontal 7º linha
		oPr:Line(1080,0020,1080,2350) // Horizontal 8º linha
		oPr:Line(1330,0020,1330,2350) // Horizontal 9º linha
		
		oPr:Line(0020,0020,1330,0020) // Vertical 1ª Linha
		oPr:Line(0825,0600,1330,0600) // Vertical 2ª Linha
		oPr:Line(0020,1200,1330,1200) // Vertical 3ª Linha
		oPr:Line(0215,1625,0605,1625) // Vertical 4ª Linha
		oPr:Line(0720,1650,0840,1650) // Vertical 5ª Linha
		oPr:Line(0215,2030,0305,2030) // Vertical 6ª Linha
		oPr:Line(0020,2350,1330,2350) // Vertical 7ª Linha
		
		oPr:Say(0030,0030,OemtoAnsi("Destinatario")                          , oFont08)
		oPr:Say(0060,0030,OemtoAnsi('NISSAN DO BRASIL')                      , oFont16)
		
		oPr:Say(0030,1210,OemtoAnsi("Endereço do Fornecedor")                , oFont08)
		oPr:Say(0060,1210,OemtoAnsi(ETQ->EMITENTE)                           , oFont12)
		
		oPr:Say(0130,0030,OemtoAnsi("Coleta - Entrega")                      , oFont08)
		//oPr:Say(0160,0030,OemtoAnsi(Alltrim('25/04 08:00 - 26/04 08:00'))   , oFont20)
		oPr:Say(0160,0030,Subs(Dtos(dDatabase),7,2) + '/' + Subs(Dtos(dDatabase),5,2) + ' ' + Substr(Time(),1,5) + ' - ' + Subs(Dtos(dDatabase+1),7,2) + '/' +Subs(Dtos(dDatabase),5,2) + ' ' + Substr(Time(),1,5) , oFont20)
		
		oPr:Say(0315,0030,OemtoAnsi("Nº Produto (P)")                        , oFont08)
		oPr:Say(0335,0030,OemtoAnsi(Alltrim(ETQ->REFFOR))                    , oFont28)
		
		if mv_par08 = 1
			//Utilizado no momento.
			MSBAR("CODE3_9", 3.65, 0.4,UPPER("P")+OemToAnsi(Alltrim(ETQ->REFFOR)),oPr    , .F. , ,.T., 0.0390,1.000,NIL,NIL,NIL,.F.,,,.F.)
		Else
			//Utilizado anteriormente.
			MSBAR("CODE3_9",1.8 ,0.2 ,UPPER("P")+OemToAnsi(Alltrim(ETQ->REFFOR)),oPr    , .F., ,.T., 0.0200,0.500,NIL,NIL,NIL,.F.,,,.F.)
		Endif
		
		oPr:Say(0130,1210,OemtoAnsi("Cód. Embalagem")                        , oFont08)
		oPr:Say(0150,1610,OemtoAnsi(ETQ->CODEMB)                             , oFont16)
		
		oPr:Say(0225,1210,OemtoAnsi("Peso Liquido (Kg)")                     , oFont08)
		oPr:Say(0255,1350,Transform(OemtoAnsi(ETQ->PLIQUI),"@e 9999,9999")   , oFont14)
		
		oPr:Say(0225,1635,OemtoAnsi("Peso Bruto (Kg)")                       , oFont08)
		oPr:Say(0255,1780,OemtoAnsi(ETQ->PBRUTO)                             , oFont14)
		
		oPr:Say(0225,2040,OemtoAnsi("Nº Caixas")                             , oFont08)
		oPr:Say(0255,2100,OemtoAnsi(ETQ->CAIXA)                              , oFont14)
		
		oPr:Say(0315,1210,OemtoAnsi("Simbolo VP")                            , oFont08)
		//oPr:SayBitmap(345,1300,cStartPath+"IMG003.BMP",220,220)   // verificar com a nissan o simbolo vp
		
		oPr:Say(0315,1635,OemtoAnsi("Semana")                                , oFont08)
		oPr:Say(0300,1750,OemtoAnsi('S'+U_SemanaAno(ctod(ETQ->DTA)))         , oFont80)
		
		oPr:Say(0615,0030,OemtoAnsi("Nº RAN(M)")                             , oFont08)
		oPr:Say(0620,0190,OemtoAnsi(Alltrim(Substr(ETQ->MODIFI,1,7)))        , oFont18N)
		
		if mv_par08 = 1
			//Utilizado no momento.
			MSBAR("CODE3_9",5.70,0.4,UPPER("M")+OemToAnsi(Alltrim(Substr(ETQ->MODIFI,1,7))),oPr,.F., ,.T.,0.0390,1.000,NIL,NIL,NIL,.F.,,,.F.)
		Else
			//Utilizado anteriormente.
			MSBAR("CODE3_9",2.85,0.2,UPPER("M")+OemToAnsi(Alltrim(Substr(ETQ->MODIFI,1,7))),oPr,.F., ,.T.,0.0200,0.500,NIL,NIL,NIL,.F.,,,.F.)
		Endif
		
		oPr:Say(0615,1210,OemtoAnsi("Nome do Produto")                       , oFont08)
		oPr:Say(0640,1210,OemtoAnsi(left(ETQ->DESC,20))                      , oFont16)
		
		oPr:Say(0730,1210,OemtoAnsi("Data")                                  , oFont08)
		oPr:Say(0760,1210,OemtoAnsi('P'+ETQ->DTA)                            , oFont16)
		/*
		Parametros precedentes a data padrão NISSAN
		P: Data de Produção
		E: Data de Expedição
		U: Data de Utilização
		*/
		
		oPr:Say(0730,1660,OemtoAnsi("Modificação")                           , oFont08)
		//oPr:Say(0760,1830,OemtoAnsi('B')                                   , oFont16)
		
		oPr:Say(0850,0030,OemtoAnsi("SNP (Q)")                               , oFont08)
		oPr:Say(0860,0150,OemtoAnsi(Alltrim(ETQ->QUANT))                     , oFont18N)
		if mv_par08 = 1
			//Utilizado no momento
			MSBAR("CODE3_9",7.70,0.4,UPPER("Q")+OemToAnsi(Alltrim(ETQ->QUANT)),oPr,.F., ,.T.,0.0390,1.000,NIL,NIL,NIL,.F.,,,.F.)
		Else
			//Utilizado anteriormente.
			MSBAR("CODE3_9",3.85,0.2,UPPER("Q")+OemToAnsi(Alltrim(ETQ->QUANT)),oPr,.F., ,.T.,0.0200,0.500,NIL,NIL,NIL,.F.,,,.F.)
		Endif
		
		oPr:Say(0850,0615,OemtoAnsi("Fornecedor - Deposito")                 , oFont08)
		oPr:Say(0910,0710,OemtoAnsi(Alltrim('7AY9 - ZZ'))                    , oFont22N)
		
		oPr:Say(0850,1210,OemtoAnsi("Nº Produto Fornecedor (S)")             , oFont08)
		oPr:Say(0870,1550,OemtoAnsi(Alltrim(strtran(ETQ->PRODUTO,'.','')))   , oFont18)
		if mv_par08 = 1
			//Utilizado no momento
			MSBAR("CODE3_9",7.70,10.2,UPPER("S")+OemToAnsi(Alltrim(strtran(ETQ->PRODUTO,'.',''))),oPr,.F., ,.T.,0.0370,1.000,NIL,NIL,NIL,.F.,,,.F.)
		Else
			//Utilizado anteriormente.
			MSBAR("CODE3_9",3.85,5.1,UPPER("S")+OemToAnsi(Alltrim(strtran(ETQ->PRODUTO,'.',''))),oPr,.F., ,.T.,0.0180,0.500,NIL,NIL,NIL,.F.,,,.F.)
		Endif
		
		oPr:Say(1090,0030,OemtoAnsi("Cód. Armazém - Local Entrega")          , oFont08)
		oPr:Say(1170,0125,OemtoAnsi(Alltrim('320T - 300'))                   , oFont22N)
		//oPr:Say(1000,1230,OemtoAnsi(ETQ->DESC), oFont08N)
		
		oPr:Say(1090,0615,OemtoAnsi("Estoque - Produto Uso")                 , oFont08)
		oPr:Say(1170,0720,OemtoAnsi(Alltrim('TAA'))                          , oFont22N)
		
		oPr:Say(1090,1210,OemtoAnsi("Nº Lote (H)")                           , oFont08)
		//oPr:Say(1100,1550,OemtoAnsi(ETQ->ETIQ)                               , oFont18N)
		oPr:Say(1100,1550,OemtoAnsi(ETQ->NOTA)                               , oFont18N)		
		if mv_par08 = 1
			//Utilizado no momento
			//MSBAR("CODE3_9",9.6,10.2,UPPER("H")+OemToAnsi(Alltrim(ETQ->ETIQ)),oPr,.F., ,.T.,0.0390,1.000,NIL,NIL,NIL,.F.,,,.F.)			
			MSBAR("CODE3_9",9.6,10.2,UPPER("H")+OemToAnsi(Alltrim(ETQ->NOTA)),oPr,.F., ,.T.,0.0390,1.000,NIL,NIL,NIL,.F.,,,.F.)
		Else
			//Utilizado anteriormente
			//MSBAR("CODE3_9",4.8,5.1,UPPER("H")+OemToAnsi(Alltrim(ETQ->ETIQ)),oPr,.F., ,.T.,0.0200,0.500,NIL,NIL,NIL,.F.,,,.F.)			
			MSBAR("CODE3_9",4.8,5.1,UPPER("H")+OemToAnsi(Alltrim(ETQ->NOTA)),oPr,.F., ,.T.,0.0200,0.500,NIL,NIL,NIL,.F.,,,.F.)
		Endif
	Endif
	
	ETQ->(DbSkip())
	
	If !Empty(ETQ->NOTA)
		oPr:EndPage()
		oPr:StartPage()
	Endif
EndDo

oPr:Preview()
oPr:End()

Close(oDlg)

MS_FLUSH()

Return

*------------------------*
Static Function AlterQtd()
*------------------------*
cProd := ETQ->ETQ_CODIGO
nQTDE := ETQ->ETQ_QUANT

@ 050,001 to 190,390 dialog oDlg1 title "Alteracao de Quantidade"

@ 006,005 to 040,90 title 'Produto'
@ 020,010 say cProd
@ 006,100 to 040,190 title 'Quantidade'
@ 020,120 get nQTDE picture "@E 999,999,999" SIZE 50,80 OBJECT oEdit
@ 056,060 bmpbutton type 1 action (close(oDlg1),AtuEst())
@ 056,100 bmpbutton type 2 action close(oDlg1)
oEdit:Refresh()

activate dialog oDlg1 centered

Return

*------------------------------*
Static Function AjustaSX1(cPerg)
*------------------------------*
SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

cPerg   :=PadR(cPerg,10)

aRegs   := {}

//              G   O          P                     P                     P                      V   T   T D P  G   V         V   D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  F  G
//              R   R          E                     E                     E                      A   I   A E R  S   A         A   E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  3  R
//              U   D          R                     R                     R                      R   P   M C E  C   L         R   F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  |  P
//              P   E          G                     S                     E                      I   O   A I S  |   I         0   0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  |  S
//              O   M          U                     P                     N                      A   |   N M E  |   D         1   1  P  N  1  2  2  P  N  2  3  3  P  N  3  4  4  P  N  4  5  5  P  N  5  |  X
//              |   |          N                     A                     G                      V   |   H A L  |   |         |   |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  G
//              |   |          T                     |                     |                      E   |   O L |  |   |         |   |  1  1  |  |  |  2  2  |  |  |  3  3  |  |  |  4  4  |  |  |  5  5  |  |  |
//              |   |          |                     |                     |                      |   |   | | |  |   |         |   |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
aadd(aRegs,{cPerg,"01","Nota Inicial ?        ","Nota Inicial ?        ","Nota Inicial ?        ","mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Nota Final   ?        ","Nota Final   ?        ","Nota Final   ?        ","mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","Serie Inicial  ?      ","Serie Inicial ?       ","Serie Inicial ?       ","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","Serie Final    ?      ","Serie Final   ?       ","Serie Final ?         ","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"05","Peso Bruto Embalagem ?","Peso Bruto Embalagem ?","Peso Bruto Embalagem ?","mv_ch5","N",07,3,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"06","Qtde por Pallet   ?   ","Qtde por Pallet  ?    ","Qtde por Pallet   ?   ","mv_ch6","N",04,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"07","Qtde de Etiquetas ?   ","Qtde de Etiquetas ?   ","Qtde de Etiquetas ?   ","mv_ch7","N",04,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"08","Local de Impressão?   ","Local de Impressão?   ","Local de Impressão?   ","mv_ch8","C",01,0,0,"C","","mv_par08","Local","Local","Local","","","Servidor","Servidor","Servidor","","","","","","","","","","","","","","","","","",""})
cUltPerg := aRegs[Len(aRegs)][2]

dbSelectArea("SX1")
dbSetOrder(1)
If !SX1->(DbSeek(cPerg + cUltPerg))
	
	SX1->(DbSeek(cPerg))
	While SX1->X1_Grupo == cPerg
		RecLock('SX1')
		SX1->(DbDelete())
		SX1->(DbSkip())
		MsUnLock('SX1')
	End
	
	For i := 1 To Len(aRegs)
		RecLock("SX1", .T.)
		
		For j := 1 to Len(aRegs[i])
			FieldPut(j, aRegs[i, j])
		Next
		MsUnlock()
		
		DbCommit()
	Next
EndIf

dbSelectArea(_sAlias)

Return

*---------------------------*
User Function SemanaAno(dDat)
*---------------------------*
Local dAno     := year(dDat)
Local dIniAno  := stod(alltrim(str(dAno))+"0101")
Local dDataAtu := 0
Local dDiaSema := dow(dIniAno)
Local nSemanAno:= 1
Local nSemana  := 7 - dDiaSema
Local cRet

if dDat >= dIniAno .and. dDat <= (dIniAno+nSemana)
	* Número da Semana com Ano com dois digitos
	* cRet := strzero(nSemanAno,2)+"/"+substr(Alltrim(Str(dAno)),3,2)
	* Número da Semana sem o Ano com dois digitos
	cRet := strzero(nSemanAno,2)
	return(cRet)
elseif nSemana > 0
	dDataAtu  := dIniAno+nSemana
	nSemanAno += 1
	if dDat > dDataAtu .AND. dDat <= (dDataAtu+7)
		* Número da Semana com Ano com dois digitos
		* cRet:= strzero(nSemanAno,2)+"/"+substr(Alltrim(Str(dAno)),3,2)
		* Número da Semana sem o Ano com dois digitos
		cRet:= strzero(nSemanAno,2)
		return(cRet)
	else
		for nD := 1 to 100
			dDataAtu += 7
			nSemanAno += 1
			if dDat > dDataAtu .AND. dDat <= (dDataAtu+7)
				* Número da Semana com Ano com dois digitos
				* cRet := strzero(nSemanAno,2)+"/"+subStr(Alltrim(Str(dAno)),3,2)
				* Número da Semana sem o Ano com dois digitos
				cRet := strzero(nSemanAno,2)
				return (cRet)
			endif
		next
	endif
else
	for nD := 1 to 100
		dDataAtu += 7
		nSemanAno += 1
		if dDat > dDataAtu .AND. dDat <= (dDataAtu+7)
			* Número da Semana com Ano com dois digitos
			* cRet := strzero(nSemanAno,2)+"/"+subStr(Alltrim(Str(dAno)),3,2)
			* Número da Semana sem o Ano com dois digitos
			cRet := strzero(nSemanAno,2)
			return(cRet)
		endIf
	next
endIf

return