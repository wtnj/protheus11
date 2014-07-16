/*
+---------------------------------------------------------------------------------+
!                          FICHA TECNICA DO PROGRAMA                              !
+---------------------------------------------------------------------------------+
!DADOS DO PROGRAMA                                                                !
+------------------+--------------------------------------------------------------+
!Modulo            ! Estoque/Custos                                               !
+------------------+--------------------------------------------------------------+
!Nome              ! NHEST021.PRW                                                 !
+------------------+--------------------------------------------------------------+
!Descricao         ! Controle de Ordem de Liberação.                              !
+------------------+--------------------------------------------------------------+
!Autor             ! Alexandre Rodizo Bento                                       !
+------------------+--------------------------------------------------------------+
!Data de Criacao   ! 28/06/2005                                                   !
+------------------+--------------------------------------------------------------+
!   ATUALIZACOES                                                                  !
+----------------------------------------------+-----------+-----------+----------+
!   Descricao detalhada da atualizacao         !Nome do    ! Analista  !Data da   !
!                                              !Solicitante! Respons.  !Atualiz.  !
+----------------------------------------------+-----------+-----------+----------+
!                                              !           !           !          !
!                                              !           !           !          !
+----------------------------------------------+-----------+-----------+----------+ 
*/
#include "rwmake.ch"
#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"

User Function nhest021()

SetPrvt("CCADASTRO,AROTINA")

cCadastro := OemToAnsi("Ordem de Liberação de Materiais")
aRotina := {{ "Pesquisa"      ,"AxPesqui"      , 0 , 1},;
{ "Visualizar"    ,'U_NHEST039(2)' , 0 , 2},;
{ "Incluir"       ,'U_fOrdem()'    , 0 , 3},;
{ "Excluir"       ,'U_NHEST039(5)' , 0 , 4},;
{ "Imprimir"      ,'U_NHEST039(6)' , 0 , 5},;
{ "Frete/Entrega" ,'U_NHEST039(9)' , 0 , 5},;
{ "Rot. Entrega"  ,"U_EST021ROT()" , 0 , 5},;
{ "Emails"        ,"U_EST21MAIL()" , 0 , 5},;
{ "Legenda"       ,"U_FLegOrd1"    , 0 , 2}}

mBrowse( 6, 1,22,75,"SZM",,,,,,fCriaCor())

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PRINCIPAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function fOrdem()

SetPrvt("_cDoc,_cCli,_dData,_cHora,_cTransp,_cMot,_cRG,_cPCam,_cPCar,_x,_cPed,oDialog,_cHoraen,_dDataen,_cObs")
SetPrvt("_cSerial,_cDesc,_cProd,_dData,_cHora,_cOper,_cNomeOp,_cHrJan,_cHrJanF")
SetPrvt("nMax,aHeader,aCols,oMultiline,cQuery,cQuery1,oDialog,nI,_cOrdCar")
SetPrvt("_aPri,_cPri,_cArqDbf,_aFields,aCampos,cMarca,cARQ,cARQEXP,i,nqtde,netiq,aNota,_cObsexp")
SetPrvt("_cTPCarg,_aTPCarg,_cFrete,_nValPed,_nValICM,_nValFre,_dDtEntr,_cHrEntr,_cLacre,cQuery2,_cArqNtx,_nOrder,_cTraTel")
SetPrvt("_lMail,_aMail,cAssunto,lMailFor")

DEFINE FONT oFont NAME "Arial" SIZE 12, -12
DEFINE FONT oFont10 NAME "Arial" SIZE 10, -10

lMailFor := .F.
_lMail   := .F.
_aMail   := {}
nMax    := 1
_cDoc   := Space(06)
_cCli    := Space(37)
_dData   := date()
_cHora   := time()
_cTransp := Space(30)
_cMot    := Space(30)
_cRG     := Space(10)
_cPCam   := Space(08)
_cPCar   := Space(08)
_cDesc   := Space(30)
_cProd   := Space(15)
_cHoraen := Space(05)
_dDataen := Space(08)
_cObs    := Space(100)
_cObsexp := Space(100)
_cLacre  := Space(50)
_cHrJan  := Space(05)
_cHrJanF := Space(05)
_aPri    := {"1","2" ,"3","4","5","6","7","8","9","10","11","12"}
aNota    := {}
_cPri    := "1"
_aTPCarg := {"Total","Parcial","Especial",OemToAnsi("Baudiação")}
_cTPCarg := "1"
_cArqNtx := Space(08)
_cArqDBF := Space(12)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // Da Nota ?                                    ³
//³ mv_par02     // Ate a Nota ?                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Pergunte("EST021",.T.)
	Processa({|| Gerando() }, OemToAnsi("Ordem de Liberação"))
Else
	Return
EndIf

If File( _cArqDBF )
	fErase(_cArqDBF)  // Deleta arquivo de dados temporario
Endif

If File(_cArqNtx+OrdBagExt())
	Ferase(_cArqNtx+OrdBagExt())
Endif

If Select("TMP") > 0
	TMP->(dbCloseArea())
Endif

If Select("XETQ") > 0
	XETQ->(dbCloseArea())
Endif

Return

Static Function Gerando()
Local cQuery

cQuery := "SELECT SD2.D2_DOC,SD2.D2_COD,SD2.D2_EMISSAO,SD2.D2_SERIE,SD2.D2_QUANT,SD2.D2_CLIENTE,SD2.D2_LOJA,SD2.R_E_C_N_O_,SD2.D2_TOTAL,"
cQuery += " SC5.C5_VOLUME1,SC5.C5_TRANSP, SC5.C5_PEDCOM,SC6.C6_DESCRI, SA4.A4_NOME, SA4.A4_TEL,SD2.D2_NFORI,SD2.D2_SERIORI,"
cQuery += " 'CLIENTE' ="
cQuery += " CASE"
cQuery += "   WHEN SF2.F2_TIPO = 'B' THEN"
cQuery += "        (SELECT SA2.A2_NOME FROM " +  RetSqlName( 'SA2' ) +" SA2 "
cQuery += "         WHERE SA2.D_E_L_E_T_ = ' ' AND SA2.A2_COD = SF2.F2_CLIENTE"
cQuery += "         AND SA2.A2_LOJA = SF2.F2_LOJA) "
cQuery += "   ELSE"
cQuery += "        (SELECT SA1.A1_NOME FROM " +  RetSqlName( 'SA1' ) +" SA1 "
cQuery += "         WHERE SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SF2.F2_CLIENTE"
cQuery += "         AND SA1.A1_LOJA = SF2.F2_LOJA)"
cQuery += " END"
cQuery += " FROM " +  RetSqlName( 'SD2' ) +" SD2, " +  RetSqlName( 'SC5' ) +" SC5, "+ RetSqlName( 'SC6' ) +" SC6, "+ RetSqlName( 'SB1' ) +" SB1, "
cQuery += RetSqlName( 'SA4' ) +" SA4, "  + RetSqlName( 'SF2' ) +" SF2""
cQuery += " WHERE SF2.F2_DOC =  SD2.D2_DOC "
cQuery += " AND SF2.F2_SERIE =  SD2.D2_SERIE "
cQuery += " AND SF2.F2_CLIENTE =  SD2.D2_CLIENTE "
cQuery += " AND SF2.F2_LOJA =  SD2.D2_LOJA "
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2")+ "'"
cQuery += " AND SD2.D2_FILIAL = '" + xFilial("SD2")+ "'"
cQuery += " AND SC5.C5_FILIAL = '" + xFilial("SC5")+ "'"
cQuery += " AND SC6.C6_FILIAL = '" + xFilial("SC6")+ "'"
cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "'"
cQuery += " AND SA4.A4_FILIAL = '" + xFilial("SA4")+ "'"
cQuery += " AND SD2.D2_DOC BETWEEN '" + Mv_par01 + "' AND '" + Mv_par02 + "' "
cQuery += " AND SC6.C6_NOTA = SD2.D2_DOC AND SC6.C6_SERIE = SD2.D2_SERIE"
cQuery += " AND SC5.C5_CLIENTE = SC6.C6_CLI AND SC5.C5_LOJACLI = SC6.C6_LOJA"
cQuery += " AND SD2.D2_CLIENTE = SC6.C6_CLI AND SD2.D2_LOJA = SC6.C6_LOJA"
cQuery += " AND SD2.D2_ORDLIB = ' '" //traz somente notas que não foram geradas a ordem de liberação
cQuery += " AND SD2.D2_ITEMPV = SC6.C6_ITEM"
cQuery += " AND SC5.C5_NUM = SC6.C6_NUM"
cQuery += " AND SB1.B1_COD = SD2.D2_COD"
cQuery += " AND SB1.B1_COD = SC6.C6_PRODUTO"
cQuery += " AND SA4.A4_COD = SC5.C5_TRANSP"
cQuery += " AND SD2.D2_TES NOT IN ('694')"
cQuery += " AND SF2.D_E_L_E_T_ = ' ' AND SA4.D_E_L_E_T_ = ' '"
cQuery += " AND SD2.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' '"
cQuery += " AND SC6.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' '"
cQuery += " ORDER BY SD2.D2_DOC,SD2.D2_CLIENTE,SD2.D2_LOJA ASC"

//MemoWrit('C:\TEMP\EST021.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"
TcSetField("TMP","D2_EMISSAO","D")  // Muda a data de string para date
DbSelectArea("TMP")

Processa( {|| fRptDet() }, "Aguarde Pesquisando...")

Return

Static Function fRptDet()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando Arquivo Temporario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cArqDBF := "T_"+CriaTrab(NIL,.f.)
_aFields := {}

AADD(_aFields,{"OK"       ,"C",02,0})        // Controle do browse
AADD(_aFields,{"NOTA"     ,"C",13,0})        // Numero da Nota + Serie
AADD(_aFields,{"NOMCLI"   ,"C",20,0})        // Cliente + Loja + Nome
AADD(_aFields,{"CLIENTE"  ,"C",40,0})        // Cliente + Loja + Nome
AADD(_aFields,{"NFDATA"   ,"C",10,0})        // Emissao
AADD(_aFields,{"EMISSAO"  ,"C",08,0})        // Emissao
AADD(_aFields,{"PRODUTO"  ,"C",45,0})        // Cod. + Nome do Produto
AADD(_aFields,{"TRANSP"   ,"C",36,0})        // Cod. + Nome da transportadora
AADD(_aFields,{"NFORI"    ,"C",10,0})        // Nota de retorno + serie de retorno
AADD(_aFields,{"PED"      ,"C",41,0})        // Pedido de retorno simples
AADD(_aFields,{"QUANT"    ,"C",12,0})        // Quantidade do Produto
AADD(_aFields,{"VOLUME"   ,"C",02,0})        // Volume das notas
AADD(_aFields,{"SD2RECNO" ,"C",10,0})        // Recno do registro SD2
AADD(_aFields,{"TOTAL"    ,"N",14,2})        // Total por Item da NF

DbCreate(_cArqDBF,_aFields)
DbUseArea(.T.,,_cArqDBF,"XETQ",.F.)

//-- MsCreate(_cArqDBF,_aFields,"DBFXETQ")
//-- Sleep(1000)
//-- dbUseArea(.T.,"DBFXETQ",_cArqDbf,"XETQ",.T.,.F.)

//INDEX ON XETQ->SD2RECNO TO (_cArqDBF)
//XETQ->(dbsetorder(1))

TMP->(DBGotop())

ProcRegua(TMP->(RecCount()))

_cTraTel = Iif(Empty(TMP->A4_TEL),"s/n",TMP->A4_TEL) //telefone da transportadora

While !TMP->(EOF())
	_cPed := Space(41)
	
	IncProc("Gerando Arquivo de Ordem de Liberação")
	
	If !Empty(TMP->C5_PEDCOM) // Verifica se existe pedido de retorno
		cQuery1 := "SELECT C6_NOTA"
		cQuery1 += " FROM " +  RetSqlName( 'SC6' )
		cQuery1 += " WHERE C6_FILIAL = '" + xFilial("SC6")+ "'"
		cQuery1 += " AND C6_NUM = '" + TMP->C5_PEDCOM + "'"
		cQuery1 += " AND D_E_L_E_T_ = ' '"
		cQuery1 += " GROUP BY C6_NOTA"  //  MemoWrit('C:\TEMP\ESTPED.SQL',cQuery1)
		
		//TCQuery Abre uma workarea com o resultado da query
		TCQUERY cQuery1 NEW ALIAS "TRB"
		TRB->(DBGotop())
		While !TRB->(EOF())
			If !Empty(TRB->C6_NOTA)
				If Empty(_cPed)
					_cPed := Alltrim(TRB->C6_NOTA)
				Else
					_cPed := _cPed +"/"+Alltrim(TRB->C6_NOTA)
				Endif
			Endif
			TRB->(Dbskip())
		Enddo
		
		TRB->(dbCloseArea())//fecha o arq. temporario TRB
		
	Endif
	
	RecLock("XETQ",.T.)
	XETQ->OK       := Space(02)
	XETQ->NOTA     := TMP->D2_DOC+"-"+TMP->D2_SERIE
	XETQ->CLIENTE  := TMP->D2_CLIENTE+"-"+TMP->D2_LOJA+"-"+TMP->CLIENTE
	XETQ->NOMCLI   := Alltrim(TMP->CLIENTE)
	XETQ->NFDATA   := DTOC(TMP->D2_EMISSAO)
	XETQ->PRODUTO  := " "+Subs(TMP->D2_COD,1,15)+"-"+Subs(TMP->C6_DESCRI,1,28)
	XETQ->TRANSP   := TMP->C5_TRANSP+"-"+TMP->A4_NOME
	XETQ->PED      := Alltrim(_cPed)
	XETQ->VOLUME   := Alltrim(StrZero(TMP->C5_VOLUME1,2))
	XETQ->QUANT    := Transform(TMP->D2_QUANT,"@E 9999999.99")
	XETQ->SD2RECNO := STRZERO(TMP->R_E_C_N_O_,10)
	XETQ->TOTAL    := TMP->D2_TOTAL
	MsUnlock("XETQ")
	
	TMP->(DbSkip())
	
EndDo

TMP->(dbclosearea())

cMarca  := GetMark()
aCampos := {}

Aadd(aCampos,{"OK"        ,"C", ""               				,"@!"})
Aadd(aCampos,{"NOTA"      ,"C", Space(2)+"Nota"+Space(2) 		,"@!"})
Aadd(aCampos,{"NFDATA"    ,"C", Space(1)+"Data"+Space(1)		,"@!"})
Aadd(aCampos,{"NOMCLI"    ,"C", SPACE(11)+"Cliente"+Space(11)   ,"@!"})
Aadd(aCampos,{"PRODUTO"   ,"C", Space(11)+"Produto"+Space(11)	,"@!"})
Aadd(aCampos,{"QUANT"     ,"C", Space(1)+"Quant"+Space(1)       ,"@!"})
Aadd(aCampos,{"VOLUME"    ,"C", "Volume"         ,"@!"})
Aadd(aCampos,{"PED"       ,"C", "NF Simples"     ,"@!"})

XETQ->(DbGoTop())

aOldRot := aRotina //-- GUARDA O ARRAY
cOldCad := cCadastro //-- GUARDA A VARIAVEL

cCadastro := OemToAnsi("Selecione a Nota - <ENTER> Marca/Desmarca")
aRotina := { {"Ordem Liberação" ,'U_fOrdLib()' , 0 , 3 },;
{"Marca Tudo"      ,'U_fMark()'   , 0 , 4 },;
{"Desmarca Tudo"   ,'U_fDesmark()', 0 , 1 },;
{"Legenda"         ,'U_fLeg()'    , 0 , 1 } }

MarkBrow("XETQ","OK" ,,aCampos,,cMarca) // Retirado 1 parametro, pois deu problema apos uma atualizacao
//MarkBrow( 'TRB', 'A1_OK',,_afields,, cMark,'u_MarkAll()',,,,'u_Mark()',{|| u_MarkAll()},,,,,,,.F.)
aRotina := aOldRot //-- RECUPERA O ARRAY
cCadastro := cOldCad //-- RECUPERA A VARIAVEL

Return

/*******************************************************
* VERIFICA SE O NÚMERO DA ORDEM DE LIBERAÇÃO JÁ EXISTE *
*******************************************************/
Static Function fVerifSeq(_doc)
Local cQuery

cQuery := "SELECT SZM.ZM_DOC FROM "+RetSqlName("SZM")+" SZM (NOLOCK)"
cQuery += " WHERE SZM.ZM_DOC = '"+_doc+"'"
cQuery += " AND SZM.D_E_L_E_T_ = ''"
cQuery += " AND SZM.ZM_FILIAL = '"+xFilial("SZM")+"' "

TCQUERY cQuery NEW ALIAS "TRA1"

TRA1->(DbGoTop())

If TRA1->(!EOF()) .AND. !EMPTY(TRA1->ZM_DOC)
	TRA1->(DbCloseArea())
	Return .F.
EndIf

TRA1->(DbCloseArea())

Return .T.

//***********************************************************
User Function fOrdLib()
PRocessa({|| fOrdLib2() },"Aguarde ... ")
Return

Static function fOrdLib2()
Local lFlag := .F.
Local _cNF  := Space(06)
aHeader     := {}
aCols       := {}
_cCli       := Space(40)
_cDoc   := Space(06)
_dData   := date()
_cHora   := time()
_cTransp := Space(30)
_cMot    := Space(30)
_cRG     := Space(10)
_cPCam   := Space(08)
_cPCar   := Space(08)
_cDesc   := Space(30)
_cProd   := Space(15)
//_cTPCarg := Space(10)
_cFrete  := Space(06)
_nValFre := 0
_nValPed := 0
_nValICM := 0
_dDtEntr := Space(08)
_cHrEntr := Space(05)
_cLacre  := Space(50)
_cHrJan  := Space(05)
_cHrJanF := Space(05)
_cJanCli := Space(05)
_cModTrans := ""
_aModTrans := {"","1=Carreta","2=Truck","3=Bug","4=Outro"}
_cOrdCar   := Space(100)

procregua(3)

DbSelectArea("SZM")
_cDoc       := GetSXENum("SZM","ZM_DOC")   // Variaveis do Cabecalho do Cadastro
DbCloseArea()

While !fVerifSeq(_cDoc)
	_cDoc := GetSXENum("SZM","ZM_DOC")
EndDo

incproc('1/3')

Aadd(aHeader,{"Nota"       , "UM",  "@!"                ,13,0,".F.","","C","SZN"}) //1
Aadd(aHeader,{"Emissao"    , "ZN_EMISSAO" ,"99/99/9999" ,10,0,".F.","","C","SZN"}) //2
Aadd(aHeader,{"Produto"    , "UM"  ,Repli("!",40)       ,40,0,".F.","","C","SZN"}) //3
Aadd(aHeader,{"Quantidade" , "UM"  ,Repli("!",12)       ,12,0,".F.","","C","SZN"}) //4
Aadd(aHeader,{"Volume"     , "UM"  ,"!!"                ,02,0,".F.","","C","SZN"}) //5
Aadd(aHeader,{"NF Remessa" , "ZN_NFRET",  "@!"          ,41,0,".F.","","C","SZN"}) //6
Aadd(aHeader,{"Data de Fusão*" , "ZN_DTFUSAO",  "99/99/9999" ,13,0,"","","D","SZN"}) //7

aNota    := {}
// Carrega os campos da ordem de liberação selecionada
XETQ->(DbGoTop())
DbSelectArea("XETQ")
While !XETQ->(eof())
	
	If MARKED("OK") //Pega as notas selecionadas
		If _cCli <> XETQ->CLIENTE
			If lFlag
				MsgBox("Favor Selecionar Somente Clientes Iguais ","Atencao","STOP")
				XETQ->(DbGoTop())
				MarkBRefresh()
				Return(.F.)
			Endif
			lFlag    := .T.
			_cCli    := XETQ->CLIENTE
			_cTransp := XETQ->TRANSP
			
		Endif
		
		If _cNF <> XETQ->NOTA
			_cNF := XETQ->NOTA
			Aadd(aCols,{XETQ->NOTA,XETQ->NFDATA,XETQ->PRODUTO,XETQ->QUANT,XETQ->VOLUME,XETQ->PED,CTOD('//'),XETQ->TOTAL,XETQ->SD2RECNO}) //Carrega o Acols
		Else
			Aadd(aCols,{XETQ->NOTA,XETQ->NFDATA,XETQ->PRODUTO,XETQ->QUANT,"0",XETQ->PED,CTOD('//'),XETQ->TOTAL,XETQ->SD2RECNO}) //Carrega o Acols
		Endif
		Aadd(aNota,{XETQ->NOTA,XETQ->SD2RECNO}) //Carrega a nota p/ verificação das mesmas marcadas
		
	Endif
	XETQ->(DbSkip())
Enddo

incproc('2/3')

// Para verificar se o usuario marcou todos os produtos da mesma nota na ordem de liberação
XETQ->(DbGoTop())
While !XETQ->(eof())
	
	If Ascan(aNota,{|X|X[1] == XETQ->NOTA}) <> 0
		If Ascan(aNota,{|X|X[2] == XETQ->SD2RECNO}) == 0
			Aadd(aCols,{XETQ->NOTA,XETQ->NFDATA,XETQ->PRODUTO,XETQ->QUANT,"0",XETQ->PED,CTOD('//'),XETQ->TOTAL,XETQ->SD2RECNO}) //Carrega o Acols
		Endif
	Endif
	XETQ->(DbSkip())
Enddo

incproc('3/3')

aCols := Asort(aCols,,, { |x,y| x[1] < y[1] }) // Orderna as notas no acols p/mostrar p/ usuario
nMax := Len(aCols)

If nMax == 0 //verifica se o usuario selecionou alguma nota fiscal
	MsgBox("Nao foi Selecionada Nenhuma Nota Fiscal","Atencao","STOP")
	XETQ->(DbGoTop())
	MarkBRefresh()
	RollBackSx8() //Volta a numeração da Ordem de Liberação Qdo nenhuma NF foi marcada.
	Return(.F.)
Endif

Define MsDialog oDialog Title OemToAnsi("Ordem de Liberação de Materiais") From 020,030 To 490,790 Pixel
@ 013,007 To 115,372 Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE
@ 027,010 Say "Numero :" Size 030,8
@ 027,032 Say _cDoc Size 035,8 Object oDoc
oDoc:Setfont(oFont)

@ 027,070 Say "Cliente:" Size 30,8
@ 025,090 Get _cCli  Picture "@!" When .F.  Size 170,8 Object oCli

@ 027,270 Say "Data:" Size 30,8
@ 025,285 Get _dData Picture "99/99/9999" When .F. Size 35,8 Object oData
@ 025,335 Get _cHora Picture "99:99:99" When .F. Size 25,8 Object oHora

@ 040,010 Say "Transportadora:" Size 045,8
@ 038,050 Get _cTransp Picture "@!" When .F. Size 120,8 Object oTransp

@ 040,175 Say "Dt Entrada:" Size 030,8 object oDtEntrada
@ 038,205 Get _dDataEn Picture "@!" When .F. Size 25,8 Object oDataEn
@ 040,240 Say "Hr Entrada:" Size 030,8 object oHrEntrada
@ 038,270 Get _cHoraEn Picture "@!" When .F. Size 25,8 Object oHoraEn

@ 040,315 Say "Jan. Cli:" Size 030,8 object olJanCli
@ 038,340 Get _cJanCli Picture "99:99" Size 25,8 Object oJanCli

@ 053,010 Say OemToAnsi("Placa Caminhão:") Color CLR_HBLUE  Size 050,8
@ 051,050 Get _cPCam Picture "!!!-!!!!" Size 030,8 Valid fPlaca(_cPCam) Object oPCam
oPCam:SetFocus(oPCam)
@ 053,095 Say OemToAnsi("Placa Carreta :") Size 050,8
@ 051,135 Get _cPCar Picture "!!!-!!!!" Size 030,8 Valid fPlaca(_cPCar) Object oPCar

@ 053,175 Say "Hr.Jan. Ini:" Color CLR_HBLUE Size 025,8  object oHrja
@ 051,205 Get _cHrJan Picture "!!:!!" Size 10,8 Valid .T. Object oHrJan

@ 053,240 Say "Hr.Jan.Fim:" Color CLR_HBLUE Size 030,8  object oHrjafim
@ 051,270 Get _cHrJanF Picture "!!:!!" Size 10,8 Valid fHrJan() Object oHrJanfim

@ 053,310 Say "Prioridade:" Size 040,8 object oTPri
oTPri:Setfont(oFont10)

@ 051,355 Get _cPri Picture "@!" Size 7,8 Object oPri

@ 065,010 Say "Motorista :" Color CLR_HBLUE  Size 050,8
@ 063,050 Get _cMot Picture "@!" Size 100,8 Object oMot
@ 065,153 Say "RG :" Color CLR_HBLUE  Size 010,8
@ 063,163 Get _cRG Picture "@!" Size 050,8 Object oRG

@ 065,218 Say "Tipo Carga:" Size 050,8
@ 063,248 COMBOBOX _cTPCarg ITEMS _aTPCarg SIZE 40,10 object oTPCarg

@ 065,293 Say "Mod. Transp.:" Color CLR_HBLUE Size 050,8
@ 063,330 COMBOBOX _cModTrans ITEMS _aModTrans SIZE 40,10 object oModTrans

@ 077,010 Say OemToAnsi("Num Frete :")  Size 050,8
@ 075,050 Get _cFrete Picture "@!" Size 035,8 Object oFrete

@ 077,95 Say OemToAnsi("Valor Frete :") Size 050,8
@ 075,125 Get _nValFre Picture "999,999.99" Size 050,8 Object oValFre

@ 077,185 Say OemToAnsi("Valor Pedagio :") Size 050,8
@ 075,220 Get _nValPed Picture "999,999.99" Size 050,8 Object oValPed

@ 077,280 Say OemToAnsi("Valor ICMS :") Size 050,8
@ 075,320 Get _nValICM Picture "999,999.99" Size 050,8 Object oValICM

@ 089,010 Say OemToAnsi("Num Lacre :") Size 050,8
@ 087,050 Get _cLacre Picture "@!" Size 125,8 Object oLacre

@ 089,190 Say OemToAnsi("Obs Exp:") Size 050,8
@ 087,220 Get _cObsexp Picture "@!" Size 150,8 Object oObsexp

@ 101,010 Say OemToAnsi("Ordem Entrega:") Color CLR_HBLUE Size 050,8
@ 099,050 Get _cOrdCar Picture "@!" Size 320,8 Object oOrdCar

//******************************************************************************
@ 117,006 To 212,372 Title OemToAnsi(" Informações ")

@ 127,008 TO 210,370 MULTILINE MODIFY OBJECT oMultiline

@ 217,305 BMPBUTTON TYPE 01 ACTION fGrvOrd()
@ 217,345 BMPBUTTON TYPE 02 ACTION fEnd() //FCancela()
oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline
Activate MsDialog oDialog Center

XETQ->(DbGoTop())
MarkBRefresh()

Return

Static Function fHrJan()
Local lRet := .T.
If Empty(_cHrJan) .OR. Empty(_cHrJanF)
	Msgbox("Horario de Janela  nao Foi Digitado, Verifique !!!" ,"Atencao Campo em Branco","ALERT" )
	lRet := .F.
Endif
Return(lRet)

Static Function fEnd()

RollBackSx8() //Volta a numeração da Ordem de Liberação
Close(oDialog)

Return

Static Function fMotori()
Local lRet := .T.
If Empty(cMot)
	Msgbox("Fornecedor nao Foi Digitado, Verifique !!!" ,"Atencao Campo em Branco","ALERT" )
	lRet := .F.
Endif
Return(lRet)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVA A ORDEM ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fGrvOrd()
_aMail   := {} //LIMPA O ARRAY DOS ITENS QUE VAO SER ENVIADOS POR EMAIL
_vNotas  := ''
_vSerie  := ''
cCodProd := ""

If !Empty(_cMot) .And. !Empty(_cRG) .And. !Empty(_cHrJan) .And. !Empty(_cModTrans) .And. !Empty(_cOrdCar)
	
	Reclock("SZM",.T.)
	SZM->ZM_FILIAL  := xFilial("SZM")
	SZM->ZM_DOC     := _cDoc
	SZM->ZM_CLIENTE := Substr(_cCli,1,6)
	SZM->ZM_LOJA    := Substr(_cCli,8,2)
	SZM->ZM_TRANSP  := Substr(_cTransp,1,6)
	SZM->ZM_PLACACM := _cPCam
	SZM->ZM_PLACACR := _cPCar
	SZM->ZM_MOTORIS := _cMot
	SZM->ZM_RGMOTOR := _cRG
	SZM->ZM_EXPEDI  := __cUserID
	SZM->ZM_HORAEXP := Time()
	SZM->ZM_DATAEXP := Date()
	SZM->ZM_PRIORI  := _cPri
	SZM->ZM_HORAENT := _cHoraen
	SZM->ZM_DATAENT := Iif(Empty(_dDataen),Ctod("//"),_dDataen)
	SZM->ZM_OBS     := _cObs
	SZM->ZM_TPCARGA := _cTPCarg
	SZM->ZM_FRETE   := _cFrete
	SZM->ZM_VALFRET := _nValFre
	SZM->ZM_VALPED  := _nValPed
	SZM->ZM_VALICM  := _nValICM
	SZM->ZM_DTENTRE := Iif(Empty(_dDtEntr ),Ctod("//"),_dDtEntr )
	SZM->ZM_HRENTRE := _cHrEntr
	SZM->ZM_LACRE   := _cLacre
	SZM->ZM_OBSEXP  := _cObsexp
	SZM->ZM_HRJANEL := _cHrJan
	SZM->ZM_HRJAFIM := _cHrJanF
	SZM->ZM_MODTRAN := SUBSTR(_cModTrans,1,1)
	SZM->ZM_ORDCARR := _cOrdCar
	SZM->ZM_JANCLI  := _cJanCli
	MsUnlock("SZM")
	
	For _x:=1 to Len(aCols)
		If !Empty(Acols[_x][1])
			Reclock("SZN",.T.)
			SZN->ZN_FILIAL  := xFilial("SZN")
			SZN->ZN_DOC     := _cDoc
			SZN->ZN_NFISCAL := Substr(Acols[_x][1],1,9) //nota fiscal
			SZN->ZN_SERIE   := Substr(Acols[_x][1],11,3) //serie da nota fiscal
			SZN->ZN_COD     := Substr(Acols[_x][3],2,15) //codigo do produto
			SZN->ZN_QUANT   := Val(Acols[_x][4])  //quantidade
			SZN->ZN_VOLUME  := Val(Acols[_x][5])  //volume
			SZN->ZN_NFRET   := Alltrim(Acols[_x][6]) //notas fiscais de retorno
			SZN->ZN_VALFRET := Acols[_x][8] //Valor por item da NF
			SZN->ZN_DTFUSAO := Acols[_x][7] //Valor por item da NF
			MsUnlock("SZN")
			
			_vNotas+= "'"+Substr(Acols[_x][1],1,9)+"'," //notas fiscais seleconadas
			_vSerie:= Substr(Acols[_x][1],11,3) //serie da nota fiscal
			
			SD2->(DbGoto(VAL(Acols[_x][9])))//posiciona o registro SD2 para gravar o numero da ordem de liberação ref. a nota de saida
			
			lMailFor := Iif(SD2->D2_TIPO=="B",.T.,.F.) //variavel usada para saber se a liberação é para fornecedor ou cliente
			
			Reclock("SD2",.F.)
			SD2->D2_ORDLIB  := _cDoc //numero da ord. de liberação
			MsUnlock("SD2")
			
			XETQ->(dbgotop())
			
			While XETQ->(!EOF())
				If XETQ->SD2RECNO==Acols[_x][9]
					Reclock("XETQ",.F.)
					XETQ->(DbDelete())
					MsUnlock("XETQ")
					
					Exit
				Endif
				
				XETQ->(dbskip())
			Enddo
			
			If SB1->(Dbseek(xFilial("SB1")+Substr(Acols[_x][3],2,15))) //B1_FILIAL+B1_COD
				If SB1->B1_TIPO$"PA" .Or. ; //Produto acabado, Embalagem
					(SM0->M0_CODIGO=="NH" .AND. ALLTRIM(SB1->B1_COD)$"GM01.3.258.00/VW01.3.183.00/VW01.3.216.01/VW01.3.216.05") .or. ;//Produtos que também fazem parte do processo.
					(SM0->M0_CODIGO=="FN" .AND. ALLTRIM(SB1->B1_COD)$"GMO24.5.0007.01") .OR. ; //pedido do heloir hitner do pcp
					(SM0->M0_CODIGO=="FN" .AND. ALLTRIM(SB1->B1_COD)$"EC01.000118/EC01.000123" .AND. Substr(_cCli,1,6)$"900025" .and. Substr(_cCli,8,2)=="03") .or. ; // CHAMADO 040607 - Lupercio
					(SM0->M0_CODIGO=="IT") .or. ;
					(SB1->B1_TIPO$"EB/EC" .AND. lMailFor)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ ZDF - Cadastro de e-mails do aviso de embarque                 ³
					//³ Se posicionar nesta tabela é porque existem e-mails cadastrados³
					//³ para envio de aviso de embarque para cliente ou fornecedor     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ZDF->(dbSetOrder(1)) //FILIAL + CLI + LOJA + TIPO
					If ZDF->(dbSeek(xFilial("ZDF")+Substr(_cCli,1,6)+Substr(_cCli,8,2)))
						
						cCodProd := " - "
						
						If lMailFor
							cCodProd := Substr(Acols[_x][3],2,15)
						Else
							SA7->(dbSetOrder(1)) //A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_PRODUTO
							If SA7->(Dbseek(xFilial("SA7")+ Substr(_cCli,1,6) + Substr(_cCli,8,2) +Substr(Acols[_x][3],2,15)))
								cCodProd := SA7->A7_CODCLI
							EndIf
						EndIf
						
						Aadd(_aMail,{Substr(Acols[_x][3],18,28),; // Descricao do produto
						Substr(Acols[_x][1],1,9),;   // nota fiscal
						Substr(Acols[_x][1],11,3),;  // serie
						Acols[_x][4],;               // quantidade
						Substr(Acols[_x][3],2,15),;  // código do produto whb
						cCodProd,;      	          // código do produto cliente/fornecedor
						Acols[_x][7]})               // data fusao
						
						_lMail := .T. //Verifica se gera email
					EndIf
				Endif
			Endif
		Endif
	Next _x
	
	If _lMail
		If Msgbox("Enviar aviso de embarque?" ,"Enviar ", "YESNO")
			fEMail()
		Endif
	EndIf
	
	ConfirmSX8()

	if Substr(_cCli,1,6)+Substr(_cCli,8,2) $ '00000501'
		Processa({|| fnSCANIA(_vNotas,_vSerie) }, "Aguarde, gerando aviso de embarque para Scania...")
	EndIf

	Close(oDialog)
Else
	Msgbox("Campos Obrigatorios Nao Foram Digitados, Verifique !!!" ,"Atencao Campo em Branco","ALERT" )
Endif

MarkBRefresh()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ENVIA EMAIL DE AVISO DE EMBARQUE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fEmail()
Local CRLF      := chr(13)+chr(10)   // PULA LINHA
Local cMSG      := ""
Local cCliNome  := "Aviso de embarque p/ "
Local _cResp    := ""
Local _cResp1   := ""
Local _cResp2   := ""
Local _cResp3   := ""
Local lAdd      := .F.
Local cGrupo    := ""
Local cAssunto  := '***** AVISO DE EMBARQUE - '
Local aResp     := {}
Local aCli      := {}
Local cObs      := ""

If Msgbox("Deseja digitar uma Observação para a mensagem?" ,"Enviar ", "YESNO")
	//abre uma janela para digitacao da observacao
	oDlgObs := MsDialog():New(0,0,210,400,"Observação",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	oSay1 := TSay():New(10,10,{||"Observação"},oDlgObs,,,,,,.T.,,)
	
	oMemo1 := tMultiget():New(22,10,{|u|if(Pcount()>0,cObs:=u,cObs)},;
	oDlgObs,183,60,,,,,,.T.,,,{||.T.})
	
	oBtn1 := tButton():New(88,153,"Ok" ,oDlgObs,{||oDlgObs:End()},40,10,,,,.T.)
	
	oDlgObs:Activate(,,,.T.,{||.T.},,{||})
EndIf
/*
Responsáveis WHB FN/NH
*/
aAdd(aResp,"João Gruczkowski - joaog@whbusinagem.com.br - 55 41 3341-1327")                 //01
aAdd(aResp,"Lupercio de Carvalho - lupercioc@whbusinagem.com.br - 55 41 3341-1325")         //02
aAdd(aResp,"Mario Carvalho Pietrzak - mariocp@whbusinagem.com.br - 55 41 3341-1838")        //03
aAdd(aResp,"Lilian Esther Martinez Gimenez - lilianeg@whbfundicao.com.br - 55 41 3341-1838")//04
aAdd(aResp,"Erica de Lima Pires - ericalp@whbusinagem.com.br - 55 41 3341-1323")            //05
aAdd(aResp,"Elenita de Oliveira Urbano - elenitaou@whbusinagem.com.br - 55 41 3341-1330")   //06
aAdd(aResp,"Anderson dos Santos Counto - andersonsc@whbbrasil.com.br - 55 41 3341-1215")    //07
/*
Responsáveis Itesapar
*/
aAdd(aResp,"Dilmar Franca - dilmar.franca@itesapar.com.br - 55 42 3252-8514")               //08
aAdd(aResp,"Emanuele Plodek - emanuelle.plodek@itesapar.com.br - 55 42 3252-8510")          //09
aAdd(aResp,"Fabricio Gurski -fabricio.gurski@itesapar.com.br - 55 42 3252-8531")            //10
aAdd(aResp,"Antonio Polo - antonio.polo@itesapar.com.br - 55 42 3252-8514")                 //11
aAdd(aResp,"Evandro Jose Iachinski - evandro.iachinski@itesapar.com.br - 55 42 3252-8514")  //12
aAdd(aResp,"Jose Montes - jose.montes@itesapar.com.br - 55 42 3252-8531")                   //13
aAdd(aResp,"Andressa do Valle - andressa.valle@itesapar.com.br - 55 42 3252-8514")          //14
aAdd(aResp,"Sergio Sevciuc Junior - sergiosj@whbusinagem.com.br - 55 42 3252-8514")         //15
aAdd(aResp,"Ilário Schmoller - ilario.schmoller@itesapar.com.br - 55 42 3252-8531")         //16
aAdd(aResp,"Carlos Roberto Alves dos Reis - carlosar@whbusinagem.com.br - 55 42 3252-8514") //17
aAdd(aResp,"Luiz Ripka - luiz.ripka@itesapar.com.br - 55 42 3252-8514")                     //18
aAdd(aResp,"Marcelo Ferreira Mendes - marcelo.mendes@itesapar.com.br - 55 42 3252-8514")    //19

If lMailFor
	SA2->(dbSetOrder(1))//FILIAL + COD + LOJA
	If SA2->(dbSeek(xFilial("SA2")+Substr(_cCli,1,6)+Substr(_cCli,8,2)))
		cCliNome := AllTrim(SA2->A2_NOME)
		cAssunto += AllTrim(SA2->A2_NREDUZ)
	EndIf
Else
	SA1->(dbSetOrder(1))//FILIAL + COD + LOJA
	If SA1->(dbSeek(xFilial("SA1")+Substr(_cCli,1,6)+Substr(_cCli,8,2)))
		cCliNome := AllTrim(SA1->A1_NOME)
		cAssunto += AllTrim(SA1->A1_NREDUZ)
	EndIf
EndIf

IF SM0->M0_CODIGO == "NH"  //empresa USINAGEM
	If lMailFor
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ NH - FORNECEDORES ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cResp  := aResp[6]
		_cResp1 := aResp[7]
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ NH - CLIENTES ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Substr(_cCli,1,6) == '900182' .And. Substr(_cCli,8,2) == '01'//Wabco 900182 e loja 01
			_cResp   := aResp[3]
			_cResp1  := ''
		ElseIf Substr(_cCli,1,6) == '900183' .And. Substr(_cCli,8,2) == '01'//Iveco 900183 e loja 01
			_cResp   := aResp[2]
			_cResp1  := aResp[3]
		ElseIf Substr(_cCli,1,6) == '900004' .And. Substr(_cCli,8,2) == '02'//GM 900004 e LOJA 02
			_cResp   := aResp[1]
			_cResp1  := ''
		ElseIf Substr(_cCli,1,6) == '900193'.And. Substr(_cCli,8,2) == '01'//TEDRIVE 900193 e LOJA 01
			_cResp   := aResp[1]
			_cResp1  := ''
		ElseIf Substr(_cCli,1,6) == '900141' .And. Substr(_cCli,8,2) == '03'//PSA 900141 e loja 03
			_cResp   := aResp[2]
			_cResp1  := aResp[1]
		ElseIf Substr(_cCli,1,6) == '900186' .AND. (Substr(_cCli,8,2) == '01' .OR. Substr(_cCli,8,2) == '02')//FIAT 900186
			_cResp   := aResp[2]
			_cResp1  := aResp[3]
		ElseIf Substr(_cCli,1,6) == '900171' .AND. Substr(_cCli,8,2) == '01' //CNH 900171
			_cResp   := aResp[1]
			_cResp1  := ''
		ElseIf Substr(_cCli,1,6) == '900009' .AND. Substr(_cCli,8,2) == '01'//SM 900009
			_cResp   := aResp[1]
			_cResp1  := ''
		ElseIf Substr(_cCli,1,6) == '900001' .AND. Substr(_cCli,8,2) == '03'//VW 900001
			_cResp   := aResp[3]
			_cResp1  := ''
		ElseIf Substr(_cCli,1,6) == '900164' .AND. (Substr(_cCli,8,2) == '01' .OR. Substr(_cCli,8,2) == '02')//JTEKT 900164
			_cResp   := aResp[3]
			_cResp1  := ''
		EndIf
	EndIf
Elseif SM0->M0_CODIGO == "FN" //empresa FUNDICAO
	If lMailFor //Liberacao de nota para fornecedor
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ FN - FORNECEDORES ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Substr(_cCli,1,6) == '000284' .AND. Substr(_cCli,8,2) == '01' //ELETROLAK
			_cResp  := aResp[4]
			_cResp1 := aResp[5]
		ElseIf Substr(_cCli,1,6) == '000956' .AND. Substr(_cCli,8,2) == '01'//TECNOPO
			_cResp  := aResp[4]
			_cResp1 := aResp[5]
		ElseIf Substr(_cCli,1,6) == '003817' .AND. Substr(_cCli,8,2) == '01' //FF PINTURAS
			_cResp  := aResp[4]
			_cResp1 := aResp[5]
		Else
			_cResp  := aResp[6]
			_cResp1 := aResp[7]
		EndIf
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ FN - CLIENTES ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Substr(_cCli,1,6) == '000005'// SCANIA
			_cResp   := aResp[3]
			_cResp1  := ''
		elseIf Substr(_cCli,1,6) == '000001' .And. Substr(_cCli,8,2) == '01' //WHB USINAGEM
			_cResp   := aResp[4]
			_cResp1  := aResp[5]
		elseIf Substr(_cCli,1,6) == '900040' .And. Substr(_cCli,8,2) == '02' //BREMBO
			_cResp   := aResp[4]
			_cResp1  := aResp[5]
		elseIf Substr(_cCli,1,6) == '000065' .And. Substr(_cCli,8,2) == '01' //MBB
			_cResp   := aResp[4]
			_cResp1  := aResp[5]
		elseIf Substr(_cCli,1,6) == '900015' .And. Substr(_cCli,8,2) == '01' //WABCO
			_cResp   := aResp[4]
			_cResp1  := aResp[5]
		elseIf Substr(_cCli,1,6) == '000007' .And. Substr(_cCli,8,2) == '01' //DAIMLERCHRYLSER 000007 e loja 01
			_cResp   := aResp[1]
			_cResp1  := ''
		elseIf Substr(_cCli,1,6) == '900024' // GM
			_cResp   := aResp[2]
			_cResp1  := aResp[3]
		ElseIf Substr(_cCli,1,6) == '900022' // IVECO
			_cResp   := aResp[2]
			_cResp1  := aResp[3]
		ElseIf Substr(_cCli,1,6) == '900003' //PSA
			_cResp   := aResp[2]
			_cResp1  := aResp[3]
		ElseIf Substr(_cCli,1,6) == '900025'// FIAT
			_cResp   := aResp[2]
			_cResp1  := aResp[3]
		ElseIf Substr(_cCli,1,6) == '000002' .AND. Substr(_cCli,8,2) == '01' //ROBERT BOSCH
			_cResp   := aResp[4]
			_cResp1  := aResp[5]
		ElseIf Substr(_cCli,1,6) == '000003' .AND. Substr(_cCli,8,2) == '01' //MASTER
			_cResp   := aResp[4]
			_cResp1  := aResp[5]
		ElseIf Substr(_cCli,1,6) == '900014' .AND. Substr(_cCli,8,2) == '01' //BASSO
			_cResp   := aResp[4]
			_cResp1  := aResp[5]
		ElseIf Substr(_cCli,1,6) == '000008' .AND. Substr(_cCli,8,2) == '01' //DORMA
			_cResp   := aResp[4]
			_cResp1  := aResp[5]
		ElseIf Substr(_cCli,1,6) == '000012' .AND. Substr(_cCli,8,2) == '02' //VOLKSWAGEN DO BRASIL LTDA 000012 LOJA 02
			SB1->(Dbseek(xFilial("SB1")+ _aMail[1][5])) //verifica o item se é PA01=Fundicao ou PA02-Usinagem
			If SB1->B1_GRUPO$"PA01" //envia email para fundicao
				_cResp   := aResp[4]
				_cResp1  := aResp[5]
			Else //envia email para usinagem
				_cResp   := aResp[3]
				_cResp1  := ''
			Endif
		ElseIf Substr(_cCli,1,6) == '900109' .AND. Substr(_cCli,8,2) == '02' //WHB PERNAMBUCO
			SB1->(Dbseek(xFilial("SB1")+ _aMail[1][5])) //verifica o item se é PA01=Fundicao ou PA02-Usinagem
			If SB1->B1_GRUPO$"PA01" //envia email para fundicao
				_cResp   := aResp[4]
				_cResp1  := aResp[5]
			ElseIF SB1->B1_GRUPO$"PA03" //envia email para forjaria
				_cResp   := aResp[8]
				_cResp1  := ''
			Else //envia email para usinagem
				_cResp   := aResp[3]
				_cResp1  := ''
			Endif
		ElseIf Substr(_cCli,1,6) == '000012' .AND. Substr(_cCli,8,2) == '03' //VOLKSWAGEN DO BRASIL LTDA 000012 LOJA 03
			_cResp   := aResp[3]
			_cResp1  := ''
		ElseIf Substr(_cCli,1,6) == '900048' .AND. Substr(_cCli,8,2) == '02'//SM SISTEMAS MODULARES LTDA 900048 LOJA 02
			_cResp    := aResp[3]
			_cResp1   := ''
		ElseIf Substr(_cCli,1,6) == '900048' .AND. Substr(_cCli,8,2) == '01'//SM SISTEMAS MODULARES LTDA 900048 LOJA 01
			_cResp    := aResp[3]
			_cResp1   := ''
		ElseIf Substr(_cCli,1,6) == '900063' .AND. Substr(_cCli,8,2) == '01'//TEDRIVE
			_cResp    := aResp[1]
			_cResp1   := ''
		EndIf
	EndIf
Elseif SM0->M0_CODIGO == "IT" //empresa ITESAPAR
	If lMailFor //Liberacao de nota para fornecedor
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ IT - FORNECEDORES ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		/*
		If Substr(_cCli,1,6) == '' .AND. Substr(_cCli,8,2) == '' //
		_cResp  := ''
		_cResp1 := ''
		_cResp2 := ''
		_cResp3 := ''
		ElseIf Substr(_cCli,1,6) == '' .AND. Substr(_cCli,8,2) == ''//
		_cResp  := ''
		_cResp1 := ''
		_cResp2 := ''
		_cResp3 := ''
		ElseIf Substr(_cCli,1,6) == '' .AND. Substr(_cCli,8,2) == '' //
		_cResp  := ''
		_cResp1 := ''
		_cResp2 := ''
		_cResp3 := ''
		Else
		_cResp  := ''
		_cResp1 := ''
		_cResp2 := ''
		_cResp3 := ''
		EndIf
		*/
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ IT - CLIENTES ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Substr(_cCli,1,6) == '900044' .And. Substr(_cCli,8,2) == '01'                //ZF
			_cResp   := aResp[8]
			_cResp1  := aResp[9]
			_cResp2  := aResp[10]
			_cResp3  := aResp[11]
		elseIf Substr(_cCli,1,6) == '900080' .And. Substr(_cCli,8,2) == '01'            // CONTINENTAL
			_cResp   := aResp[8]
			_cResp1  := aResp[9]
			_cResp2  := aResp[10]
			_cResp3  := aResp[11]
		elseIf Substr(_cCli,1,6) == '900286' .And. Substr(_cCli,8,2) == '01'            //  EATON
			_cResp   := aResp[8]
			_cResp1  := aResp[9]
			_cResp2  := aResp[10]
			_cResp3  := aResp[11]
		elseIf Substr(_cCli,1,6)$'900115/900118/900122' .And. Substr(_cCli,8,2)$'01/02' // TRW
			_cResp   := aResp[9]
			_cResp1  := aResp[10]
			_cResp2  := aResp[11]
			_cResp3  := aResp[12]
		elseIf Substr(_cCli,1,6)$'900131/900072' .And. Substr(_cCli,8,2) == '01'        // VOLKSWAGEN
			_cResp   := aResp[9]
			_cResp1  := aResp[10]
			_cResp2  := aResp[11]
			_cResp3  := aResp[12]
		elseIf Substr(_cCli,1,6) == '900061' .And. Substr(_cCli,8,2) == '01'            //  PERKINS
			_cResp   := aResp[9]
			_cResp1  := aResp[10]
			_cResp2  := aResp[11]
			_cResp3  := ''
		elseIf Substr(_cCli,1,6) == '900085' .And. Substr(_cCli,8,2) == '01'            //  LITENS
			_cResp   := aResp[9]
			_cResp1  := aResp[10]
			_cResp2  := aResp[14]
			_cResp3  := aResp[15]
		elseIf Substr(_cCli,1,6) == '900047' .And. Substr(_cCli,8,2) == '01'            //  WEB
			_cResp   := aResp[9]
			_cResp1  := aResp[10]
			_cResp2  := aResp[14]
			_cResp3  := aResp[16]
		elseIf Substr(_cCli,1,6) == '900075' .And. Substr(_cCli,8,2) == '01'            //  AETHRA
			_cResp   := aResp[9]
			_cResp1  := aResp[10]
			_cResp2  := aResp[14]
			_cResp3  := aResp[17]
		elseIf Substr(_cCli,1,6) == '900077' .And. Substr(_cCli,8,2) == '01'            //  BOSCH
			_cResp   := aResp[9]
			_cResp1  := aResp[10]
			_cResp2  := aResp[15]
			_cResp3  := aResp[18]
		elseIf Substr(_cCli,1,6) == '900086' .And. Substr(_cCli,8,2) == '01'            //  VALEO
			_cResp   := aResp[9]
			_cResp1  := aResp[10]
			_cResp2  := aResp[11]
			_cResp3  := aResp[15]
		elseIf Substr(_cCli,1,6) == '900123' .And. Substr(_cCli,8,2) == '01'            //  DENSO
			_cResp   := aResp[9]
			_cResp1  := aResp[10]
			_cResp2  := aResp[11]
			_cResp3  := aResp[17]
		elseIf Substr(_cCli,1,6) == '900068' .And. Substr(_cCli,8,2) == '01'            //  HENGST
			_cResp   := aResp[9]
			_cResp1  := aResp[10]
			_cResp2  := aResp[16]
			_cResp3  := aResp[19]
		elseIf Substr(_cCli,1,6) == '900114' .And. Substr(_cCli,8,2) == '01'            //  KNORR
			_cResp   := aResp[9]
			_cResp1  := aResp[10]
			_cResp2  := aResp[13]
			_cResp3  := aResp[16]
		elseIf Substr(_cCli,1,6) == '900289' .And. Substr(_cCli,8,2) == '01'            //  BORGWARNER
			_cResp   := aResp[9]
			_cResp1  := aResp[10]
			_cResp2  := aResp[13]
			_cResp3  := aResp[15]
		EndIf
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BUSCA QUAIS OS ENDERECOS DE EMAIL IRAO RECEBER O AVISO DE EMBARQUE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cTo := ""
If SM0->M0_CODIGO$"FN/NH"
	For x:=1 to Len(_aMail)
		SB1->(Dbseek(xFilial("SB1")+ _aMail[x][5])) //verifica o item se é PA01=Fundicao ou PA02-Usinagem
		If AllTrim(SB1->B1_GRUPO)$"PA01/PA02/PA03"
			cGrupo := Alltrim(SB1->B1_GRUPO)
			exit
		EndIf
	Next
	cGrupo := Iif(cGrupo$"PA02/PA03","PA02","PA01")
Endif

//encontra os e-mails para enviar
ZDF->(dbSetOrder(1)) //FILIAL + CLI + LOJA + TIPO
ZDF->(dbSeek(xFilial("ZDF")+Substr(_cCli,1,6)+Substr(_cCli,8,2)))
While ZDF->ZDF_CLI==Substr(_cCli,1,6) .AND. ZDF->ZDF_LOJA==Substr(_cCli,8,2)
	lAdd := .F.
	If SM0->M0_CODIGO=="FN"
		If ZDF->ZDF_TIPO=='1' .AND. ;
			(ZDF->ZDF_WHB=="1" .Or. ;  //ambos
			(ZDF->ZDF_WHB=="2" .and. cGrupo=="PA01") .Or. ; //whb 2
			(ZDF->ZDF_WHB=="3" .and. cGrupo=="PA02")) .Or. ; //whb 3
			ZDF->ZDF_TIPO=="2" .AND. lMailFor
			lAdd := .T.
		EndIf
	Else
		lAdd := .T.
	EndIf
	
	If lAdd
		cTo += AllTrim(ZDF->ZDF_EMAIL) + ";"
	EndIf
	ZDF->(dbSkip())
EndDo

cAssunto += ' - *****'

cMsg := '<html><head><title>Aviso de Embarque</title></head><body>'
cMsg += '<TABLE WIDTH="100%" style="font-family:arial" border="1">'
cMsg += '<TR style="background:#666666;color:#eeeeee">'
cMsg += '<TD colspan="6" align="center">'+cCliNome+'</TD>'
cMsg += '</TR>'

cMsg += '<TR style="background:#aabbcc;font-size:12px;font-weight:bold">'
cMsg += '<TD width="20%" align="center">Nº. Controle</TD>'
cMsg += '<TD width="15%" align="center">Placa do Caminhão</TD>'
cMsg += '<TD width="20%" align="center">Motorista</TD>'
cMsg += '<TD width="15%" align="center">Data da Saída</TD>'
cMsg += '<TD width="15%" align="center">Hora de Saída</TD>'
cMsg += '<TD width="15%" align="center">Janela Entrega</TD>'
cMsg += '</TR>'

cMsg += '<TR style="background:#cccccc;font-size:12px">'
cMsg += '<TD align="center">'+_cDoc+'</TD>'
cMsg += '<TD align="center">'+_cPCam+'</TD>'
cMsg += '<TD align="center">'+_cMot+'</TD>'
cMsg += '<TD align="center">'+DtoC(Date())+'</TD>'
cMsg += '<TD align="center">'+time()+'</TD>'
cMsg += '<TD align="center">'+_cJanCli+'</TD>'
cMsg += '</TR>'

cMsg += '<TR style="background:#aabbcc;font-size:12px;font-weight:bold">'
cMsg += '<TD width="20%" align="center">Código da Peça</TD>'
cMsg += '<TD width="40%" align="center" colspan="2">Descrição da Peça</TD>'
cMsg += '<TD width="20%" align="center">Quantidade Embarcada</TD>'
cMsg += '<TD width="20%" align="center">Nota Fiscal</TD>'
cMsg += '<TD width="20%" align="center">Data Fusão</TD>'
cMsg += '</TR>'

For _x:=1 to Len(_aMail)
	
	cMsg += '<TR style="background:'+Iif(_x%2==0,'#eeeeee','#ffffff')+';font-size:12">'
	cMsg += '<TD align="center">'+_aMail[_x][6]+'</TD>'
	
	/*
	If SA7->(Dbseek(xFilial("SA7")+ Substr(_cCli,1,6) + Substr(_cCli,8,2) +_aMail[_x][5])) //A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_PRODUTO
	cMsg += '<TD align="center">' + SA7->A7_CODCLI + '</TD>' //codigo do produto para o cliente
	Else
	cMsg += '<TD align="center"> - </TD>' //Nao encontrou o codigo do produto do cliente
	EndIf
	*/
	cMsg += '<TD align="center" colspan="2">'+ _aMail[_x][1] + '</TD>' //nome do produto
	
	cMsg += '<TD align="center">'+ _aMail[_x][4] + '</TD>'  //quantidade
	cMsg += '<TD align="center">'+ _aMail[_x][2] + '-' + _aMail[_x][3] + '</TD>' //nota fiscal + serie
	cMsg += '<TD align="center">'+ DtoC(_aMail[_x][7]) + '</TD></TR>' //data fusao
	
Next

cMsg += '</TABLE>'
cMsg += CRLF

If(!Empty(cObs))
	cMsg += '<table width="100%" style="font-family:arial" border="1">'
	cMsg += '<tr><td style="background:#aabbcc;">Obs.:</td>'
	cMsg += '<td>' + cObs + '</td></tr>'
	cMsg += '</table>'
EndIf

cMsg += CRLF
cMsg += '<font size="2"> Para informações adicionais entrar em contato com:</font>' + CRLF
cMsg += '<font size="2">'+ _cResp  + '</font>' + CRLF
cMsg += '<font size="2">'+ _cResp1 + '</font>' + CRLF
cMsg += '<font size="2">'+ _cResp2 + '</font>' + CRLF
cMsg += '<font size="2">'+ _cResp3 + '</font>' + CRLF


cMsg += '</body></html>'

oMail          := Email():New()
oMail:cMsg     := cMsg
oMail:cAssunto := cAssunto
oMail:cTo      := cTo

oMail:Envia()

Return(.T.)


//ÚÄÄÄÄÄÄÄÄÄ¿
//³ LEGENDA ³
//ÀÄÄÄÄÄÄÄÄÄÙ
User Function fLeg()

Private aCores := {{ "ENABLE"  , "Nota nao Selecionada" },;
{ "DISABLE" , "Nota Selecionada" }}

BrwLegenda(cCadastro,"Legenda",aCores)

Return


//marca todas as notas
User Function fMark()

XETQ->(DbGoTop())
While !XETQ->(eof())
	
	RecLock("XETQ")
	XETQ->OK := cMarca
	MsUnlock("XETQ")
	XETQ->(Dbskip())
Enddo

MarkBRefresh()
Return

//desmarca todas as notas
User Function fDesMark()
XETQ->(DbGoTop())
While !XETQ->(eof())
	
	RecLock("XETQ")
	XETQ->OK := " "
	MsUnlock("XETQ")
	XETQ->(Dbskip())
Enddo

MarkBRefresh()
Return

Static Function fPlaca(_cPl)

Local _nNum  := 1
Local _lFlag := .T.
Local _cPlaca:= _cPl
_cPri        := "1"

If !Empty(_cPCam) .And. Empty(_cPCar)
	//   _cHoraen := Space(05)
	//   _dDataen := Space(08)
	SO5->(DbSetOrder(4))
	SO5->(Dbseek(xFilial("SO5")+_cPlaca))
	While !SO5->(EOF()) .And. _cPlaca == SO5->O5_PLACA
		//ARRUMAR HORA CHEGADA
		If Empty(SO5->O5_HORASAI)
			_cMot      := SO5->O5_DESCRI
			_cRG       := SO5->O5_CHASSI
			_cPCam     := SO5->O5_PLACA
			_cPCar     := SO5->O5_PLACACA
			_cHoraen   := SO5->O5_HORAENT // Hora de Entrada do veiculo na empresa
			_dDataen   := SO5->O5_EMISSAO // Data de Entrada do veiculo na empresa
			_cModTrans := SO5->O5_MODTRAN // modalidade de transporte
			
			oHoraEn:Refresh()
			oDataen:Refresh()
			oMot:Refresh()
			oRG:Refresh()
			oPCam:Refresh()
			oPCar:Refresh()
			oModTrans:Refresh()
			
			oHrJan:SetFocus(oHrJan)
			fPriori() //verifica a prioridade se já existe acrescenta um
			exit //se achou força a saida do loop
		Endif
		SO5->(Dbskip())
	Enddo
Endif

If !Empty(_cPCar)
	If Len(Alltrim(_cPlaca)) <> 8
		Msgbox("Placa Digitada Errada, Verifique !!!" +chr(13)+;
		"A Placa so Pode conter LETRAS E NUMEROS.","Atencao","ALERT" )
		Return(.F.)
		
	Endif
	
	For _nNum:= 1 to 3
		
		_lFlag := Entre("A","Z",Subs(_cPlaca,_nNum,1))
		If !_lFlag
			Msgbox("Placa Digitada Errada, Verifique !!!" +chr(13)+;
			"A Placa so Pode conter LETRAS E NUMEROS.","Atencao Letras","ALERT" )
			Return(.F.)
		Endif
	Next
	
	For _nNum:=5 to 8
		
		_lFlag := Entre("0","9",Subs(_cPlaca,_nNum,1))
		If !_lFlag
			Msgbox("Placa Digitada Errada, Verifique !!!" +chr(13)+;
			"A Placa so Pode conter LETRAS E NUMEROS.","Atencao Numeros","ALERT" )
			Return(.F.)
		Endif
	Next
Endif

If Empty(_cPCam)
	Msgbox("A Placa do Caminhao Nao Foi Digitada , Verifique !!!" ,"Atencao Placa","ALERT" )
	Return(.F.)
Endif

Return

User Function FLegOrd1()

Local aLegenda :=	{ {"BR_VERDE"    , "Conferente"  },;
{"BR_AMARELO"  , "Portaria"    },;
{"BR_VERMELHO" , "Fechada"     }}

BrwLegenda(OemToAnsi("Ordem de Liberação de Materiais"), "Legenda", aLegenda)

Return


Static Function fCriaCor()

Local aLegenda :=	{ {"BR_VERDE"     , "Conferente"  },;
{"BR_AMARELO"   , "Portaria"    },;
{"BR_VERMELHO"  , "Fechada"     }}

Local uRetorno := {}
Aadd(uRetorno, { 'ZM_EXPEDI <> " " .And. ZM_CONFERE = " "' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZM_EXPEDI <> " " .And. ZM_CONFERE <> " " .And. ZM_PORTARI = " "' , aLegenda[2][1] } )
Aadd(uRetorno, { 'ZM_EXPEDI <> " " .And. ZM_CONFERE <> " " .And. ZM_PORTARI <> " "' , aLegenda[3][1] } )
Return(uRetorno)

Static Function fPriori()

cQuery2 := "SELECT MAX(ZM_PRIORI) AS PRIORI"
cQuery2 += " FROM " +  RetSqlName( 'SZM' )
cQuery2 += " WHERE ZM_FILIAL = '" + xFilial("SZM")+ "'"
cQuery2 += " AND ZM_PLACACM = '" + _cPCam + "'"
cQuery2 += " AND ZM_PORTARI = ' '"
cQuery2 += " AND D_E_L_E_T_ = ' '"
//MemoWrit('C:\TEMP\ESTPED.SQL',cQuery1)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery2 NEW ALIAS "PRI"
// DbSelectArea("PRI")
PRI->(DBGotop())
If !Empty(PRI->PRIORI) // Verifica se existe alguma ordem de liberação de materiais
	_cPri := StrZero(Val(PRI->PRIORI)+1,1)
Else
	_cPri := "1"
Endif
ObjectMethod(oPri, "Refresh()")
DbSelectArea("PRI")
DbCloseArea()//fecha o arq. temporario PRI

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ IMPRIME O ROTEIRO DE ENTREGA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function EST021ROT()
Local   lSai    := .F.
Private cPlaca
Private cData   := Space(10)
Private aPlacas := {}
Private aRecSZM := {}
Private nRecSZM := ""
Private cObs    := Space(100)

oDlg  := MsDialog():New(0,0,122,370,"Parâmetros",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

oSay1 := tSay():New(10,10,{||"Data"},oDlg,,,,,,.T.,,)
oGet1 := tGet():New(08,30,{|u| if(Pcount()>0,cData := u, cData)},oDlg,;
35,8,"99/99/9999",{||fTrazPlc(cData)},,,,,,.T.,,,{||.T.},,,,,,,"cData")

oSay2 := tSay():New(22,10,{||"Placa"},oDlg,,,,,,.T.,,)
//combobox

oCombo := TComboBox():New(20,30,{|u| if(Pcount() > 0,cPlaca := u,cPlaca)},;
aPlacas,90,20,oDlg,,{||},,,,.T.,,,,{||.T.},,,,,"cPlaca")

oSay2 := tSay():New(34,10,{||"Obs."},oDlg,,,,,,.T.,,)
oGet2 := tGet():New(32,30,{|u| if(Pcount()>0,cObs := u, cObs)},oDlg,;
150,8,"@!",{||.T.},,,,,,.T.,,,{||.T.},,,,,,,"cObs")

oBtn3 := tButton():New(46,95,"Ok",oDlg,{||nRecSZM := aRecSZM[oCombo:nAt],oDlg:End()},40,10,,,,.T.)
oBtn4 := tButton():New(46,140,"Cancelar",oDlg,{||lSai := .T., oDlg:End()},40,10,,,,.T.)

oDlg:Activate(,,,.T.,{||.T.},,{||})

If lSai
	Return
EndIf

oRelato          := Relatorio():New()

oRelato:cString  := "SO5"
oRelato:cPerg    := "ROT021"
oRelato:cNomePrg := "NHEST021"
oRelato:wnrel    := oRelato:cNomePrg

//descricao
oRelato:cDesc1   := "Este   relatório   apresenta  o  roteiro"
oRelato:cDesc2   := "de entrega."

//titulo
oRelato:cTitulo  := "ROTEIRO DE ENTREGA"

//cabecalho
oRelato:cCabec1  := ""
oRelato:cCabec2  := ""

oRelato:Run({||Imprime()})

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO DE IMPRESSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Imprime()
aModTrans := {"Carreta","Truck","Bug","Outro"}

SZM->(DbGoTo(nRecSZM))

oRelato:Cabec()

@Prow()+1 , 001 psay "Ord. Liberação: "+SZM->ZM_DOC
@Prow()+1 , 001 psay "Placa: "+SZM->ZM_PLACACM
@Prow()   , 050 psay "Motorista: "+ALLTRIM(SZM->ZM_MOTORIS)
@Prow()   , 100 psay "RG: "+SZM->ZM_RGMOTOR
@Prow()+1 , 001 psay "Modalidade: "+aModTrans[Val(SZM->ZM_MODTRAN)]
@Prow()   , 050 psay "Hora Exped.: "+ALLTRIM(SZM->ZM_HORAEXP)
@Prow()   , 100 psay "Jan. Entrega: "+SZM->ZM_JANCLI
@Prow()+1 , 000 psay __PrtThinLine()

cQuery := " SELECT ZM.ZM_CLIENTE, ZM.ZM_LOJA, ZN.ZN_COD, B1.B1_DESC, F2.F2_TIPO,"
cQuery += " ZN.ZN_VOLUME, ZN.ZN_QUANT, ZN.ZN_NFISCAL, ZN.ZN_SERIE, ZM.ZM_PRIORI"
cQuery += " FROM "+RetSqlName("SZN")+" ZN, "+RetSqlName("SZM")+" ZM, "
cQuery += RetSqlName("SB1")+" B1, "+RetSqlName("SF2")+" F2"
cQuery += " WHERE ZM.ZM_DOC = ZN.ZN_DOC"
cQuery += " AND F2.F2_DOC = ZN.ZN_NFISCAL"
cQuery += " AND F2.F2_SERIE = ZN.ZN_SERIE"

If mv_par01==1 //Abertas
	cQuery += " AND ZM.ZM_PORTARI = ''"
ElseIf mv_par01==2 //Fechadas
	cQuery += " AND ZM.ZM_PORTARI != ''"
EndIf

cQuery += " AND B1.B1_COD = ZN.ZN_COD"
cQuery += " AND ZM.ZM_PLACACM = '"+SZM->ZM_PLACACM+"'"
cQuery += " AND ZM.ZM_DATAEXP = '"+DtoS(SZM->ZM_DATAEXP)+"'"
cQuery += " AND ZN.ZN_FILIAL = '"+xFilial("SZN")+"' AND ZN.D_E_L_E_T_ = ''"
cQuery += " AND ZM.ZM_FILIAL = '"+xFilial("SZM")+"' AND ZM.D_E_L_E_T_ = ''"
cQuery += " AND B1.B1_FILIAL = '"+xFilial("SB1")+"' AND B1.D_E_L_E_T_ = ''"
cQuery += " ORDER BY ZM.ZM_PRIORI "

TCQUERY cQuery NEW ALIAS "TRC"

TRC->(DbGoTop())

While TRC->(!EOF())
	
	If Prow() > 65
		oRelato:Cabec()
	EndIf
	
	@Prow()+1, 001 psay TRC->ZM_PRIORI+" ª ENTREGA"
	@Prow()+1, 001 psay "CLIENTE/LOJA      DESCRIÇÃO"
	
	If TRC->F2_TIPO=="B"
		SA2->(DbSetOrder(1)) // FILIAL + COD + LOJA
		SA2->(DbSeek(xFilial("SA2")+TRC->ZM_CLIENTE+TRC->ZM_LOJA))
		
		@Prow()+1, 001 psay TRC->ZM_CLIENTE+" - "+TRC->ZM_LOJA+"     "+SA2->A2_NOME
		@Prow()+1, 001 psay "Endereço: "+Alltrim(SA2->A2_END)+Space(5)+"Bairro: "+Alltrim(SA2->A2_BAIRRO)+Space(5)+"Cidade: "+Alltrim(SA2->A2_MUN)+Space(5)+"Estado: "+Alltrim(SA2->A2_EST)
		@Prow()+1, 001 psay "Telefone: "+SA2->A2_TEL
	Else
		SA1->(DbSetOrder(1)) //FILIAL + COD + LOJA
		SA1->(DbSeek(xFilial("SA1")+TRC->ZM_CLIENTE+TRC->ZM_LOJA))
		
		@Prow()+1, 001 psay TRC->ZM_CLIENTE+" - "+TRC->ZM_LOJA+"     "+SA1->A1_NOME
		@Prow()+1, 001 psay "Endereço: "+Alltrim(SA1->A1_END)+Space(5)+"Bairro: "+Alltrim(SA1->A1_BAIRRO)+Space(5)+"Cidade: "+Alltrim(SA1->A1_MUN)+Space(5)+"Estado: "+Alltrim(SA1->A1_EST)
		@Prow()+1, 001 psay "Telefone: "+SA1->A1_TEL
	EndIf
	
	@Prow()+2, 001 psay "CÓDIGO          DESCRIÇÃO                                               VOLUME           QUANT          NF"
	
	@Prow()+1, 001 psay ""
	
	cCli  := TRC->ZM_CLIENTE
	cLoja := TRC->ZM_LOJA
	
	nTotVol := 0
	
	While TRC->ZM_CLIENTE==cCli .AND. TRC->ZM_LOJA==cLoja
		
		@Prow()+1, 001 psay TRC->ZN_COD
		@Prow()  , 017 psay SUBSTR(TRC->B1_DESC,1,50)
		@Prow()  , 070 psay TRC->ZN_VOLUME Picture "@e 9,999.99"
		@Prow()  , 085 psay TRC->ZN_QUANT  Picture "@e 999,999.99"
		@Prow()  , 100 psay TRC->ZN_NFISCAL+" - "+TRC->ZN_SERIE
		
		SD2->(DbSetOrder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		SD2->(DbSeek(xFilial("SD2")+TRC->ZN_NFISCAL+TRC->ZN_SERIE+cCli+cLoja+TRC->ZN_COD))
		
		If SD2->(Found()) .AND. SD2->D2_TES$"503/542" //se for sacaria ou embalagem
			nTotVol += TRC->ZN_VOLUME
		EndIf
		
		TRC->(DbSkip())
	EndDo
	@Prow()+1, 001 psay "Total: "
	@Prow()  , 068 psay nTotVol Picture "@e 999,999.99"
	
	@Prow() +1,000 psay __PrtThinLine()
	
ENDDO

@Prow()+1, 001 psay "Obs.: "+cObs

@Prow()+3, 010 psay "__________________________________"
@Prow()  , 080 psay "__________________________________"
@Prow()+1, 020 psay UPPER(cUserName)
@Prow()  , 090 psay "RESP. TRANSPORTE"

@Prow()+3, 000 psay "OBS.: OBRIGATÓRIO QUE SEJA PREENCHIDO NO CONHECIMENTO DE FRETE RG, NOME LEGÍVEL E/OU CARIMBO COM NOME DO RESPONSÁVEL"
@Prow()+1, 000 psay "      PELO RECEBIMENTO DA MERCADORIA."

TRC->(DbCloseArea())
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ AS PLACAS DO DIA PASSADO COMO PARAMETRO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fTrazPlc(cData)
Local cQuery  := ""

If Empty(cData)
	Return .T.
EndIf

cQuery := " SELECT ZM_PLACACM, R_E_C_N_O_ AS ZM_RECNO "
cQuery += " FROM "+RetSqlName("SZM")+" ZM"
cQuery += " WHERE ZM_DATAEXP = '"+DtoS(CtoD(cData))+"'"
cQuery += " AND D_E_L_E_T_ = ''"
cQuery += " AND ZM_FILIAL = '"+xFilial("SZM")+"'"

TCQUERY cQuery NEW ALIAS "TRB"

TRB->(DbGoTop())

aPlacas := {}

While TRB->(!EOF())
	aAdd(aPlacas,TRB->ZM_PLACACM+" - "+ALLTRIM(Str(TRB->ZM_RECNO)))
	aAdd(aRecSZM,TRB->ZM_RECNO)
	TRB->(Dbskip())
ENDDO

oCombo:Refresh()
oCombo:aItems := {}
oCombo:aItems := aPlacas

TRB->(DbCloseArea())

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EST21MAIL ºAutor  ³João Felipe da Rosa º Data ³  16/11/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de e-mails do aviso de embarque                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESTOQUE / CUSTOS - PCP                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EST21MAIL()

aRotOld := aClone(aRotina)

SetPrvt("CCADASTRO,AROTINA,")

cCadastro := OemToAnsi("Email da Ordem de Liberação")
aRotina := {{ "Pesquisa"      ,"AxPesqui"      , 0 , 1},;
{ "Visualizar"    ,'U_E21M(2)'     , 0 , 2},;
{ "Incluir"       ,'U_E21M(3)'     , 0 , 3},;
{ "Alterar"       ,'U_E21M(4)'     , 0 , 4},;
{ "Excluir"       ,'U_E21M(5)'     , 0 , 5}}

mBrowse( 6, 1,22,75,"ZDF",,,,,,)

aRotina := aClone(aRotOld)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PRINCIPAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function E21M(nParam)
Local bOk         := {||}
Local bCanc       := {||oDlg:End()}
Local bEnchoice   := {||}
Private nPar 	  := nParam
Private aSize     := MsAdvSize()

Private cCliFor   := Space(6)
Private cLoja     := Space(2)
Private cDesc     := ""
Private cEmail    := Space(40)
Private cTipo     := ""
Private aTipo     := {"1=Cliente","2=Fornecedor"}
Private cWHB      := ""
Private aWHB      := Iif(SM0->M0_CODIGO == "NH" .or. SM0->M0_CODIGO == "FN",{"1=Ambos","2=WHBII","3=WHBIII"},{"1=Ambos","2=WHBII","3=WHBIII"})

If nPar==2     //visualizar
	fCarrega()
	bOk := {|| oDlg:End()}
ElseIf nPar==3 //incluir
	bOk := {|| fInclui()}
ElseIf nPar==4 //alterar
	fCarrega()
	bOk := {|| fAltera()}
ElseIf nPar==5 //excluir
	fCarrega()
	bOk := {|| fExclui()}
EndIf

bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}

oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)

oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Email Ordem de Liberação",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

oSay1 := TSay():New(20,10,{||"Cli. / Fornec."},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet1 := tGet():New(18,50,{|u| if(Pcount() > 0, cCliFor := u,cCliFor)},oDlg,40,8,"@!",{||fVCliFor(.T.)},;
,,,,,.T.,,,{||nPar==3},,,,,,"SA1","cCliFor")

oSay2 := TSay():New(20,160,{||"Loja"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet2 := tGet():New(18,200,{|u| if(Pcount() > 0, cLoja := u,cLoja)},oDlg,20,8,"@!",{||fVCliFor(.F.)},;
,,,,,.T.,,,{||nPar==3},,,,,,,"cLoja")

oSay3 := TSay():New(31,10,{||"Nome"},oDlg,,,,,,.T.,,)
oGet3 := tGet():New(29,50,{|u| if(Pcount() > 0, cDesc := u,cDesc)},oDlg,180,8,"@!",,;
,,,,,.T.,,,{||.F.},,,,,,,"cDesc")

oSay4 := TSay():New(42,10,{||"Email"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet4 := tGet():New(40,50,{|u| if(Pcount() > 0, cEmail := u,cEmail)},oDlg,180,8,"@!",{||fValEmail()},;
,,,,,.T.,,,{|| nPar==3 .or. nPar==4},,,,,,,"cEmail")

oSay5 := TSay():New(53,10,{||"Tipo"},oDlg,,,,,,.T.,CLR_HBLUE,)
oCombo1 := TComboBox():New(51,50,{|u| if(Pcount() > 0,cTipo := u,cTipo)},;
aTipo,40,10,oDlg,,{||fAltF3()},,,,.T.,,,,{||nPar==3},,,,,"cTipo")

If SM0->M0_CODIGO=="FN"
	oSay6 := TSay():New(64,10,{||"WHB"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oCombo2 := TComboBox():New(62,50,{|u| if(Pcount() > 0,cWHB := u,cWHB)},;
	aWHB,40,10,oDlg,,{||},,,,.T.,,,,{||nPar==3 .or. nPar==4},,,,,"cWHB")
EndIf

oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return

Static Function fValEmail()

if !isEmail(ALLTRIM(cEmail))
	Alert('Informe o e-mail corretamente!')
	return .f.
Endif

Return .t.

static function fAltF3()
oGet1:cF3 := Iif(Substr(cTipo,1,1)=="1","SA1","SA2")
cCliFor   := Space(6)
cLoja     := Space(2)
cDesc     := ""
oGet1:Refresh()
oGet2:Refresh()
oGet3:Refresh()
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CLIENTE OU O FORNECEDOR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fVCliFor(lCli)

If lCli
	cLoja := Space(2)
	oGet2:Refresh()
EndIf

If oGet1:cF3=="SA1"
	SA1->(dbSetOrder(1)) //FILIAL + COD + LOJA
	If !SA1->(dbSeek(xFilial("SA1")+AllTrim(cCliFor)+AllTrim(cLoja)))
		Alert("Cliente/Fornecedor não encontrado!")
		Return .F.
	Else
		If !lCli
			cDesc := SA1->A1_NOME
		EndIf
	EndIf
Else
	SA2->(dbSetOrder(1)) //FILIAL + COD + LOJA
	If !SA2->(dbSeek(xFilial("SA2")+AllTrim(cCliFor)+AllTrim(cLoja)))
		Alert("Cliente/Fornecedor não encontrado!")
		Return .F.
	Else
		If !lCli
			cDesc := SA2->A2_NOME
		EndIf
	EndIf
EndIf

oGet3:Refresh()

Return .T.

//ÚÄÄÄÄÄÄÄÄ¿
//³ VALIDA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fValida()

If Empty(cCliFor) .or. Empty(cLoja)
	Alert("Cliente / Fornecedor ou Loja não informados!")
	Return .F.
EndIf

If Empty(cEmail)
	Alert("Informe o e-mail!")
	Return .F.
EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄ¿
//³ INCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fInclui()

If !fValida()
	Return
EndIf

RecLock("ZDF",.T.)
ZDF->ZDF_FILIAL := xFilial("ZDF")
ZDF->ZDF_CLI    := cCliFor
ZDF->ZDF_LOJA   := cLoja
ZDF->ZDF_EMAIL  := cEmail
ZDF->ZDF_TIPO   := Substr(cTipo,1,1)
If SM0->M0_CODIGO=="FN"
	ZDF->ZDF_WHB := substr(cWHB,1,1)
EndIf
MsUnLock("ZDF")

oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ ALTERA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fAltera()

If !fValida()
	Return
EndIf

RecLock("ZDF",.F.)
ZDF->ZDF_EMAIL  := cEmail
If SM0->M0_CODIGO=="FN"
	ZDF->ZDF_WHB := substr(cWHB,1,1)
EndIf
MsUnLock("ZDF")

oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ EXCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fExclui()

If MsgYesNo("Tem certeza de que deseja excluir?")
	RecLock("ZDF",.F.)
	ZDF->(dbDelete())
	MsUnlock("ZDF")
EndIf

oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ OS DADOS PARA VISUALIZACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCarrega()

cCliFor := ZDF->ZDF_CLI
cLoja   := ZDF->ZDF_LOJA
cEmail  := ZDF->ZDF_EMAIL
cTipo   := ZDF->ZDF_TIPO

If ZDF->ZDF_TIPO=="1"
	cDesc := Posicione("SA1",1,xFilial("SA1")+cCliFor+cLoja,"A1_NOME")
Else
	cDesc := Posicione("SA2",1,xFilial("SA2")+cCliFor+cLoja,"A2_NOME")
EndIf

Return
Static Function NewDlg1()
/*
A tag abaixo define a criação e ativação do novo diálogo. Você pode colocar esta tag
onde quer que deseje em seu código fonte. A linha exata onde esta tag se encontra, definirá
quando o diálogo será exibido ao usuário.
Nota: Todos os objetos definidos no diálogo serão declarados como Local no escopo da
função onde a tag se encontra no código fonte.
*/

Return

Static Function fnSCANIA()
	SetPrvt("_cArqDbf, cQuery,_aFields,aCampos,cMarca,cNovaLinha,nPbruto,x,_cNotas")   
	SetPrvt("_cArqITP,_cArqAE1,_cArqNF2,_cArqAE2,_cArqAE4,_cArqAE3,_cArqTE1,_cArqFTP,cDtaHor ")
	SetPrvt("_aITP,_aAE1,_aNF2,_caAE2,_aAE4,_aAE3,_aFTP,_aTE1, _aDBF,nAux,cCod,nFTP,cIPI,cICM,cDesc,CRLF")
	
	_cNotas :=SPACE(200) 	

cNovaLinha := Chr(13) + Chr(10)
CRLF := chr(13)+chr(10)   // PULA LINHA  
//cARQEXP    := "V:\VOLKS\OUT\VLK"+Subs(Dtos(dDatabase),7,2)+Subs(Dtos(dDatabase),5,2)+"1.TXT"
_cEdi      := Alltrim(GETMV("MV_EDI")) //caminho para envio do EDI   // "V:\mdicom\Parceiro\WHBCOMP\Out\"
_cCam     := "SCA"+Subs(Dtos(dDatabase),7,2)+Subs(Dtos(dDatabase),5,2)+"1.TXT"
             // "V:\mdicom\Parceiro\WHBCOMP\Out\VLK"
               

cARQEXP    := _cEDI + _cCam            
//alert(cARQEXP)

While File(cARQEXP)        
   _cCam   := SUBS(_cCam,1,7) +  StrZero(Val(SUBS(_cCam,8,1))+1,1)+".TXT" 
   cARQEXP := _cEDI + _cCam
Enddo

_cCliente := "000005"
_cLoja    := "01"

cQuery := "SELECT D2.D2_DOC,D2.D2_COD,D2.D2_EMISSAO,D2.D2_QUANT,D2.D2_CLIENTE,D2.D2_LOJA,B1.B1_PESO,B1.B1_POSIPI,C5.C5_PBRUTO,C5.C5_VOLUME1,C6.C6_DESCRI,"
cQuery += "D2.D2_SERIE,D2.D2_ITEM,D2.D2_TOTAL,D2.D2_TES,D2.D2_VALICM,D2.D2_VALIPI,D2.D2_UM,D2.D2_IPI,D2.D2_PRCVEN,D2.D2_PICM,D2.D2_BASEICM,D2.D2_DESC,D2.D2_DESCON,"
cQuery += "A7.A7_CLIENTE,A7.A7_LOJA,A7.A7_PRODUTO,A7.A7_PCCLI,A7.A7_CODCLI"
cQuery += " FROM " +  RetSqlName( 'SD2' ) +" D2, " +  RetSqlName( 'SC5' ) +" C5, "+ RetSqlName( 'SC6' ) +" C6, "+ RetSqlName( 'SB1' ) +" B1, " + RetSqlName( 'SA7' ) +" A7, " + RetSqlName( 'SF4' ) +" F4 "
cQuery += " WHERE D2.D2_DOC IN (" + left(_vNotas,len(_vNotas)-1) + ") AND D2.D2_SERIE = '"+ _vSerie + "' "
cQuery += " AND D2.D2_CLIENTE = '" + _cCliente + "' AND D2.D2_LOJA = '" + _cLoja + "' "
cQuery += " AND C5.C5_NOTA = D2.D2_DOC AND C5.C5_SERIE = D2.D2_SERIE "
cQuery += " AND C6.C6_NOTA = D2.D2_DOC AND C6.C6_SERIE = D2.D2_SERIE"
cQuery += " AND D2.D2_CLIENTE = A7.A7_CLIENTE AND D2.D2_LOJA = A7.A7_LOJA"
cQuery += " AND B1.B1_COD = D2.D2_COD AND A7.A7_PRODUTO = D2.D2_COD"
cQuery += " AND SUBSTRING(B1.B1_COD,1,2) NOT IN ('EC','EB')"
cQuery += " AND D2.D2_TES = F4.F4_CODIGO "
cQuery += " AND D2.D2_TIPO = 'N' "
cQuery += " AND F4.F4_FILIAL = D2.D2_FILIAL "
cQuery += " AND C5.C5_FILIAL = D2.D2_FILIAL "
cQuery += " AND C6.C6_FILIAL = D2.D2_FILIAL "
cQuery += " AND C6.C6_ITEM   = D2.D2_ITEMPV "
cQuery += " AND A7.A7_FILIAL = D2.D2_FILIAL "
cQuery += " AND D2. D_E_L_E_T_ = ' ' AND C5. D_E_L_E_T_ = ' ' AND C6. D_E_L_E_T_ = ' ' AND B1. D_E_L_E_T_ = ' ' AND A7. D_E_L_E_T_ = ' ' AND F4. D_E_L_E_T_ = ' '"
cQuery += " ORDER BY D2.D2_DOC,D2.D2_SERIE ASC"
TCQUERY cQuery NEW ALIAS "TMP"
DbSelectArea("TMP")

cARQ  := FCreate(cARQEXP) //So cria o arquivo se tiver dados para enviar
fCriaDBF()  // Cria arquivos temporarios de aviso de embarque para volks

TMP->(DBGotop())
If Empty(TMP->D2_DOC)
Alert("Atencao nao foi Selecionada nenhuma Nota Fiscal 1")
FClose(cARQ)
fErase(cArQEXP)  // Deleta arquivo de dados pois não foi selecionado nenhuma nota
TMP->(DbCloseArea())
//XDBF->(DbCloseArea())
AE1->(DbCloseArea())
AE2->(DbCloseArea())
AE3->(DbCloseArea())
AE4->(DbCloseArea())
TE1->(DbCloseArea())
NF2->(DbCloseArea())
FTP->(DbCloseArea())
Return
Endif

/*
While !TMP->(EOF())
RecLock("XDBF",.T.)
XDBF->Nota    := TMP->D2_DOC
XDBF->Serie   := TMP->D2_SERIE
XDBF->Dta     := Subs(TMP->D2_EMISSAO,7,2)+"/"+Subs(TMP->D2_EMISSAO,5,2)+"/"+Subs(TMP->D2_EMISSAO,1,4)
XDBF->Prodcli := TMP->A7_CODCLI
XDBF->Prodwhb := TMP->D2_COD
XDBF->Total   := TMP->D2_TOTAL
//Transform(TMP->D2_TOTAL,"@e 999,999,999,999.99")
MsUnlock("XDBF")

TMP->(DbSkip())
Enddo
*/

ProcRegua(TMP->(RecCount()))

TMP->(DbGoTop())
//XDBF->(DbGoTop())
nFTP := 1
_lEmb := .F. //verifica se gerou o aviso de embarque                                   
While !TMP->(eof()) // .And. !XDBF->(eof())     

   
   //If !EMPTY(XDBF->OK)
      
	  IncProc("Gerando Aviso de Embarque" )

      //---------------  SEGMENTO AE1v0 - COMPLEMENTO DADOS DA NF 
       _lEmb := .T. //verifica se gerou o aviso de embarque                                                                      
       _cNotas := ALLTRIM(_cNotas) +" "+ TMP->D2_DOC + CRLF                 
       
	   RecLock("AE1",.T.)               
	   AE1->IdentSeg   := "AE1"
	   AE1->NumNF      := StrZero(Val(Alltrim(TMP->D2_DOC)),6)
	   AE1->SerNF      := Subs(TMP->D2_SERIE,1,2)
	   AE1->DataNF     := Subs(TMP->D2_EMISSAO,3,6)
	   AE1->QItNf      := StrZero(Val(TMP->D2_ITEM),3)                             
	   
	   AE1->VlToNF     := StrZero(TMP->D2_TOTAL,17,2)
	   AE1->VlToNF     := Stuff(AE1->VlToNF,AT(".",AE1->VlToNF),1,"") //elimina o ponto
  	   AE1->VlToNF     := Stuff(AE1->VlToNF,1,0,"0")  // Insere o primeiro caracter
  	   
	   AE1->QCDec      := "0"  // QTDE de casas decimais
	   AE1->CFO        := TMP->D2_TES   // Alterado D2_CF
//	   AE1->VlToICM    := Transform(TMP->D2_VALICM,"@e 99999999999999999.99")            
	   
	   AE1->VlToICM    := StrZero(TMP->D2_VALICM,17,2)
	   AE1->VlToICM    := Stuff(AE1->VlToICM,AT(".",AE1->VlToICM),1,"") //elimina o ponto
  	   AE1->VlToICM    := Stuff(AE1->VlToICM,1,0,"0")  // Insere o primeiro caracter
  
	   AE1->DataVen    := Subs(Dtos(dDatabase+7),3,6)
	   AE1->EspNF      := Iif(Alltrim(TMP->D2_TES) == "613","02","00")

//  AE1->VlIPI      := Transform(TMP->D2_VALIPI, "@e 99999999999999999.99")
  	   AE1->VlIPI      := StrZero(TMP->D2_VALIPI,17,2)
	   AE1->VlIPI      := Stuff(AE1->VlIPI,AT(".",AE1->VlIPI),1,"") //elimina o ponto
  	   AE1->VlIPI      := Stuff(AE1->VlIPI,1,0,"0")  // Insere o primeiro caracter

   // Codigo da fabrica    
       AE1->CodFabEn   := ""	           
	   
	   AE1->DataPrNF   := Iif((Val(Time())+14) > 24,Subs(Dtos(dDatabase+1),3,6),Subs(Dtos(dDatabase),3,6)) // verificar
	   AE1->IdentPer   := "0000"
	   
	   SF4->(DbSetOrder(1))
   	   SF4->(Dbseek(xFilial("SF4")+TMP->D2_TES )) //F4_FILIAL+F4_CODIGO
	   AE1->DescNat    := Subs(SF4->F4_TEXTO,1,20)
   
	   AE1->Espaco     := Space(10)
	   MsUnlock("AE1")

       FWrite(cArq,(AE1->(IdentSeg+NumNF+SerNF+DataNF+QItNf+VlToNF+QCDec+CFO+VlToICM+DataVen+EspNF+VlIPI+CodFabEn+DataPrNF+IdentPer+DescNat+Espaco)+cNovaLinha))    
       nFTP += 1  //Controle de qtde de segmentos
       
//---------------- SEGMENTO AE2v1 - DADOS DO ITEM                         
    
      // Retira os espacos do codigo do produto
       cCod := TMP->A7_CODCLI //Codigo da amarracao prod x cliente
     /*
       nAux := AT(" ",cCod)
       While nAux <> 0
       
          cCod := Stuff(cCod,nAux,1,"")   
          nAux := AT(" ",cCod)
           
       Enddo
       */
	   Reclock("AE2",.T.)
	   AE2->IdentSeg    := "AE2"
	   AE2->NumItNF     := StrZero(Val(TMP->D2_ITEM),3)                             
	   AE2->NumPed      := TMP->A7_PCCLI           
	   AE2->CodItem     := cCod
  	   AE2->QINF        := StrZero(TMP->D2_QUANT,9,0)
//	   AE2->QINF        := Stuff(AE2->QINF,AT(".",AE2->QINF),1,"") //elimina o ponto
 
	   AE2->UnMedNF     := TMP->D2_UM
	   AE2->CodClasF    := TMP->B1_POSIPI

       cIPI              := StrZero(TMP->D2_IPI,5,2)
	   AE2->AliIPI      := Stuff(cIPI,AT(".",cIPI),1,"") //elimina o ponto
   
  	   AE2->VlItem      := StrZero(TMP->D2_PRCVEN,12,5)
	   AE2->VlItem      := Stuff(AE2->VlItem,AT(".",AE2->VlItem),1,"") //elimina o ponto
  	   AE2->VlItem      := Stuff(AE2->VlItem,1,0,"0")  // Insere o primeiro caracter
	   
	   AE2->QItEst      := StrZero(TMP->D2_QUANT,9,0)
	   
	   AE2->UnMedEs     := TMP->D2_UM
	   AE2->QtUniCom    := StrZero(TMP->D2_QUANT,9,0)
	   AE2->UnMedCo     := TMP->D2_UM
	   AE2->CodTpFo     := "P"  // P= Producao
//	   AE2->QtPerDe     := Transform(TMP->D2_DESC,"@e 99.99")

  	   cDesc             := StrZero(TMP->D2_DESC,4,2)
	   AE2->QtPerDe     := Stuff(cDesc,AT(".",cDesc),1,"") //elimina o ponto
//  	   AE2->QtPerDe     := Stuff(AE2->QtPerDe,1,0,"0")  // Insere o primeiro caracter
   
  	   AE2->VlToDes     := StrZero(TMP->D2_DESCON,11,2)
	   AE2->VlToDes     := Stuff(AE2->VlToDes,AT(".",AE2->VlToDes),1,"") //elimina o ponto
  	   AE2->VlToDes     := Stuff(AE2->VlToDes,1,0,"0")  // Insere o primeiro caracter
	   AE2->Espaco      := Space(05)    	   

	   
	   MsUnlock("AE2")

       FWrite(cArq,(AE2->(IdentSeg+NumItNF+NumPed+CodItem+QINF+UnMedNF+CodClasF+AliIPI+VlItem+QItEst+UnMedEs+QtUniCom+UnMedCo+CodTpFo+QtPerDe+VlToDes+Espaco)+cNovaLinha))      
       nFTP += 1  //Controle de qtde de segmentos


//-------------  SEGMENTO AE4v1 - DADOS COMPLEMENTARES DO ITEM                  


	   RecLock("AE4",.T.)             
	   AE4->IdentSeg  := "AE4"

//  	   cICM            := StrZero(TMP->D2_PICM,2)+"00"
	   AE4->AlICM     := StrZero(TMP->D2_PICM,2)+"00"
  	   AE4->BasICM    := StrZero(TMP->D2_BASEICM,17,2)
	   AE4->BasICM    := Stuff(AE4->BasICM,AT(".",AE4->BasICM),1,"0") //troca ponto por zero
//  	   AE4->BasICM    := Stuff(AE4->BasICM,1,0,"0")  // Insere o primeiro caracter
  	   AE4->VlICMAp    := StrZero(TMP->D2_VALICM,17,2)
	   AE4->VlICMAp    := Stuff(AE4->VlICMAp,AT(".",AE4->VlICMAp),1,"0") //elimina o ponto
//  	   AE4->VlICMAp    := Stuff(AE4->VlICMAp,1,0,"0")  // Insere o primeiro caracter
  	   AE4->VlIPIAp    := StrZero(TMP->D2_VALIPI,17,2)
	   AE4->VlIPIAp    := Stuff(AE4->VlIPIAp,AT(".",AE4->VlIPIAp),1,"0") //elimina o ponto
//  	   AE4->VlIPIAp    := Stuff(AE4->VlIPIAp,1,0,"0")  // Insere o primeiro caracter
	   AE4->CodSiTr   := "00"
	   AE4->NumDesIt  := Space(30)
	   AE4->DatValDe  := Space(06)
	   AE4->PedRev    := Space(13)
	   AE4->Espaco    := Space(19)  
	   MsUnlock("AE4") 

       FWrite(cArq,(AE4->(IdentSeg+AlICM+BasICM+VlICMAp+VlIPIAp+CodSiTr+NumDesIt+DatValDe+PedRev+Espaco)+cNovaLinha))          
       nFTP += 1  //Controle de qtde de segmentos




//------------  SEGMENTO AE3v0 - DADOS ADICIONAIS DE COMERCIAL.                 


/*	   RecLock("AE3",.T.)
	   AE3->IdentSeg := "AE3"
	   AE3->IdentFat := "57290355001585"
	   AE3->IdentCob := "57290355001585"
	   AE3->IdentEnt := Space(14)
	   AE3->Espaco   := Space(30)
	   MsUnlock("AE3")
       
       FWrite(cArq,(AE3->(IdentSeg+IdentFat+IdentCob+IdentEnt+Espaco)+cNovaLinha))             
       nFTP += 1  //Controle de qtde de segmentos    */
 
      RecLock("TE1",.T.)
	   TE1->IdentSeg := "TE1"
	   TE1->Texto1   := Space(40)
	   TE1->Texto2   := Space(40)
	   TE1->Texto3   := Space(40)
	   TE1->Espaco   := Space(05)
	   MsUnlock("TE1")
       
      FWrite(cArq,(TE1->(IdentSeg+Texto1+Texto2+Texto3+Espaco)+cNovaLinha))             
      nFTP += 1  //Controle de qtde de segmentos                                                
 
            
  // EndIf
   //XDBF->(DbSkip())
   TMP->(DbSkip())
EndDo    

If nFTP > 1
//-------------  SEGMENTO FTPv0 - Segmento Final Mensagem                    
   nFTP += 1  //Controle de qtde de segmentos
   RecLock("FTP",.T.)
   FTP->IdentSeg := "FTP"
   FTP->NumCont  := "00000"
   FTP->QtdeSeg  :=StrZero(nFTP,9)
   FTP->NumToVl  :="00000000000000000"
   FTP->CatOper  := Space(01)
   FTP->Espaco   := Space(36)
   MsUnlock("FTP")          
    
   FWrite(cArq,(FTP->(IdentSeg+NumCont+QtdeSeg+NumToVl+CatOper+ Espaco)+cNovaLinha))                
   FClose(cARQ)            
 Else
    Alert("Atencao nao foi Selecionada nenhuma Nota Fiscal 2")
    FClose(cARQ)         
    fErase(cArQEXP)  // Deleta arquivo de dados pois não foi selecionado nenhuma nota
 Endif  


//Close(oDlg)
TMP->(DbCloseArea())
//XDBF->(DbCloseArea())
AE1->(DbCloseArea())
AE2->(DbCloseArea())
AE3->(DbCloseArea())
AE4->(DbCloseArea())
TE1->(DbCloseArea())
NF2->(DbCloseArea())
FTP->(DbCloseArea())

return

Static Function fCriaDBF()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando Arquivo Temporario para posterior impressao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cArqITP  := CriaTrab(NIL,.f.)
_cArqITP += ".DBF"
_aITP := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aITP,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aITP,{"NumComu"    ,"C", 03,0})         // Numero Mensagem Comunicacao     M    A       3    0    4    6
AADD(_aITP,{"NumVer"     ,"C", 02,0})         // Numero da Versao da Mensagem    M    N       2    0    7    8
AADD(_aITP,{"NumCont"    ,"C", 05,0})         // Numero de Controle Movimento    O    N       5    0    9   13
AADD(_aITP,{"IdentMov"   ,"C", 12,0})         // Ident. Geracao Movimento        M    N      12    0   14   25
AADD(_aITP,{"IdentTra"   ,"C", 14,0})         // Identificacao do Transmissor    M    N      14    0   26   39
AADD(_aITP,{"IdentRec"   ,"C", 14,0})         // Identificacao do Receptor       M    N      14    0   40   53
AADD(_aITP,{"CodIntTr"   ,"C", 08,0})         // Codigo Interno Transmissor      O    A       8    0   54   61
AADD(_aITP,{"CodIntRe"   ,"C", 08,0})         // Codigo Interno Receptor         O    A       8    0   62   69
AADD(_aITP,{"NomTrans"   ,"C", 25,0})         // Nome do Transmissor             O    A      25    0   70   94
AADD(_aITP,{"NomRece"    ,"C", 25,0})         // Nome do Receptor                O    A      25    0   95  119
AADD(_aITP,{"Espaco"     ,"C", 09,0})         // Espaco                          M    A       9    0  120  128

DbCreate(_cArqITP,_aITP)
DbUseArea(.T.,,_cArqITP,"ITP",.F.) 


RecLock("ITP",.T.)             
   ITP->IdentSeg  := "ITP"
   ITP->NumComu   := "004"
   ITP->NumVer    := "06"
   ITP->NumCont   := "00001" // Fazer este numero sequencia atraves de MV_VOLKS
   cDtaHor         := Subs(Dtos(dDatabase),3,6)+Stuff(TIME(),AT(":",TIME()),1,"")  // DATA+HHMMSS
   ITP->IdentMov  := Stuff(cDtaHor,AT(":",cDtaHor),1,"")  // DATA+HHMMSS tira o segundo :
   ITP->IdentTra  := "01261681000104"  //cgc empresa Fundicao
   ITP->IdentRec  := "59104901000176" //CGC scania
   ITP->CodIntTr  := Space(08)
   ITP->CodIntRe  := "ALL"                                      
   ITP->NomTrans  := "01261681000104"  //empresa Fundicao
   ITP->NomRece   := "AMERICA LATINA LOGISTICA"
   ITP->Espaco    := Space(09)


MsUnlock("ITP")

  FWrite(cArq,(ITP->(IdentSeg+NumComu+NumVer+NumCont+IdentMov+IdentTra+IdentRec+CodIntTr+CodIntRe+NomTrans+NomRece+Espaco)+cNovaLinha)) 
  DbSelectArea("ITP")
  DbCloseArea()
  
// Close ITP
// ------- Segmento AE1 -----------
_cArqAE1  := CriaTrab(NIL,.f.)
_cArqAE1 += ".DBF"
_aAE1 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aAE1,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aAE1,{"NumNF"      ,"C", 06,0})         //  NUMERO DA NF ORIGEM            M    N       6    0    4    9
AADD(_aAE1,{"SerNF"      ,"C", 04,0})         // SERIE DA NOTA FISCAL ORIGEM     M    A       4    0   10   13
AADD(_aAE1,{"DataNF"     ,"C", 06,0})         // DATA DA NOTA FISCAL             M    D       6    0   14   19
AADD(_aAE1,{"QItNf"      ,"C", 03,0})         // QTDE ITENS POR NOTA FISCAL      M    N       3    0   20   22
AADD(_aAE1,{"VlToNF"     ,"C", 17,2})         // VALOR TOTAL DA NOTA FISCAL      M    N      17    2   23   39
AADD(_aAE1,{"QCDec"      ,"C", 01,0})         // QUANTIDADE DE CASAS DECIMAIS    M    N       1    0   40   40
AADD(_aAE1,{"CFO"        ,"C", 03,0})         // CODIGO FISCAL DE OPERACAO       M    N       3    0   41   43
AADD(_aAE1,{"VlToICM"    ,"C", 17,2})         // VALOR TOTAL DO ICMS APLICADO    M    N      17    2   44   60
AADD(_aAE1,{"DataVen"    ,"C", 06,0})         // DATA VENCIMENTO DO DOCUMENTO    M    D       6    0   61   66
AADD(_aAE1,{"EspNF"      ,"C", 02,0})         // ESPECIE DA NOTA FISCAL          M    N       2    0   67   68
AADD(_aAE1,{"VlIPI"      ,"C", 17,2})         // VALOR IPI APLICADO              M    N      17    2   69   85
AADD(_aAE1,{"CodFabEn"   ,"C", 03,0})         // CODIGO DA FABRICA ENTREGA       O    A       3    0   86   88
AADD(_aAE1,{"DataPrNF"   ,"C", 06,0})         // DATA PREVISAO ENTREGA DA NF     O    D       6    0   89   94
AADD(_aAE1,{"IdentPer"   ,"C", 04,0})         // IDENT. DO PERIODO DE ENTREGA    O    N       4    0   95   98
AADD(_aAE1,{"DescNat"    ,"C", 20,0})         // DESCRICAO DA NATUREZA OPERACAO  O    A      20    0   99  118
AADD(_aAE1,{"Espaco"     ,"C", 10,0})         // Espaco                          M    A      19    0  119  128

DbCreate(_cArqAE1,_aAE1)
DbUseArea(.T.,,_cArqAE1,"AE1",.F.) 
    
//---------------  SEGMENTO NF2v0 - COMPLEMENTO DADOS DA NF                    


_cArqNF2  := CriaTrab(NIL,.f.)
_cArqNF2 += ".DBF"
_aNF2 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aNF2,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aNF2,{"VlDesAc"    ,"C", 17,2})         // VALOR DESPESAS ACESSORIAS       O    N      17    2    4   20
AADD(_aNF2,{"VlFrete"    ,"C", 17,2})         // VALOR DO FRETE                  O    N      17    2   21   37
AADD(_aNF2,{"VlSegu"     ,"C", 17,2})         // VALOR DO SEGURO                 O    N      17    2   38   54
AADD(_aNF2,{"VlDesc"     ,"C", 17,2})         // VALOR DO DESCONTO DA NF         O    N      17    2   55   71
AADD(_aNF2,{"Espaco"     ,"C", 57,0})         // Espaco                          M    A      57    0   72  128

DbCreate(_cArqNF2,_aNF2)
DbUseArea(.T.,,_cArqNF2,"NF2",.F.) 


/*               SEGMENTO NF3v0 - ALTERNATIVAS VCTO C/ DESC. NF                 

   Seq  Elem  Nome                            Uso  Tipo  Tam  Dec  Posicao
   ---  ----  ------------------------------  ---  ----  ---  ---  --------

     1  0001  Identificacao Tipo de Segmento  M    A       3    0    1    3
     2  0085  DATA VENCIMENTO DO DOCUMENTO    O    D       6    0    4    9
     3  0086  QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2   10   13
     4  0085  DATA VENCIMENTO DO DOCUMENTO    O    D       6    0   14   19
     5  0086  QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2   20   23
     6  0085  DATA VENCIMENTO DO DOCUMENTO    O    D       6    0   24   29
     7  0086  QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2   30   33
     8  0085  DATA VENCIMENTO DO DOCUMENTO    O    D       6    0   34   39
     9  0086  QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2   40   43
    10  0085  DATA VENCIMENTO DO DOCUMENTO    O    D       6    0   44   49
    11  0086  QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2   50   53
    12  0085  DATA VENCIMENTO DO DOCUMENTO    O    D       6    0   54   59
    13  0086  QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2   60   63
    14  9999  Espaco                          M    A      65    0   64  128

*/



//---------------- SEGMENTO AE2v1 - DADOS DO ITEM                         

_cArqAE2  := CriaTrab(NIL,.f.)
_cArqAE2 += ".DBF"
_aAE2 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aAE2,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aAE2,{"NumItNF"    ,"C", 03,0})         // NUMERO DO ITEM NA NOTA FISCAL   M    N       3    0    4    6
AADD(_aAE2,{"NumPed"     ,"C", 12,0})         // NUMERO DO PEDIDO DE COMPRA      M    A      12    0    7   18
AADD(_aAE2,{"CodItem"    ,"C", 30,0})         // CODIGO DO ITEM                  M    A      30    0   19   48
AADD(_aAE2,{"QINF"       ,"C", 09,0})         // QTDE ITEM UNIDADE NOTA FISCAL   M    N       9    0   49   57
AADD(_aAE2,{"UnMedNF"    ,"C", 02,0})         // UNIDADE MEDIDA NOTA FISCAL      M    A       2    0   58   59
AADD(_aAE2,{"CodClasF"   ,"C", 10,0})         // CODIGO DE CLASSIFICACAO FISCAL  M    N      10    0   60   69
AADD(_aAE2,{"AliIPI"     ,"C", 04,2})         // ALIQUOTA IPI                    M    N       4    2   70   73
AADD(_aAE2,{"VlItem"     ,"C", 12,5})         // VALOR DO ITEM                   M    N      12    5   74   85
AADD(_aAE2,{"QItEst"     ,"C", 09,0})         // QTDE ITEM UNIDADE ESTOQUE       O    N       9    0   86   94
AADD(_aAE2,{"UnMedEs"    ,"C", 02,0})         // UNIDADE MEDIDA ESTOQUE          O    A       2    0  095  096
AADD(_aAE2,{"QtUniCom"   ,"C", 09,0})         // QTDE UNIDADE DE COMPRA          O    N       9    0  097  105
AADD(_aAE2,{"UnMedCo"    ,"C", 02,0})         // UNIDADE MEDIDA COMPRA           O    A       2    0  105  107
AADD(_aAE2,{"CodTpFo"    ,"C", 01,0})         // CODIGO DO TIPO DE FORNECIMENTO  O    A       1    0  108  108
AADD(_aAE2,{"QtPerDe"    ,"C", 04,2})         // QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2  109  112
AADD(_aAE2,{"VlToDes"    ,"C", 11,2})         // VALOR TOTAL DESCONTO ITEM       O    N      11    2  113  123
AADD(_aAE2,{"Espaco"     ,"C", 05,0})         // Espaco                          M    A      05    0  124  128

DbCreate(_cArqAE2,_aAE2)
DbUseArea(.T.,,_cArqAE2,"AE2",.F.) 


//-------------  SEGMENTO AE4v1 - DADOS COMPLEMENTARES DO ITEM                  

_cArqAE4  := CriaTrab(NIL,.f.)
_cArqAE4 += ".DBF"
_aAE4 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aAE4,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aAE4,{"AlICM"      ,"C", 04,2})         // ALIQUOTA ICMS                   M    N       4    2    4    7
AADD(_aAE4,{"BasICM"     ,"C", 17,2})         // BASE DE CALCULO DO ICMS         M    N      17    2    8   24
AADD(_aAE4,{"VlICMAp"    ,"C", 17,2})         // VALOR DO ICMS APLICADO          M    N      17    2   25   41
AADD(_aAE4,{"VlIPIAp"    ,"C", 17,2})         // VALOR DO IPI APLICADO           M    N      17    2   42   58
AADD(_aAE4,{"CodSiTr"    ,"C", 02,0})         // CODIGO DE SITUACAO TRIBUTARIA   M    A       2    0   59   60
AADD(_aAE4,{"NumDesIt"   ,"C", 30,0})         // NUMERO DESENHO DO ITEM          O    A      30    0   61   90
AADD(_aAE4,{"DatValDe"   ,"C", 06,0})         // DATA DE VALIDADE DESENHO        O    D       6    0   91   96
AADD(_aAE4,{"PedRev"     ,"C", 13,0})         // PEDIDO DA REVENDA               O    A      13    0   97  109
AADD(_aAE4,{"Espaco"     ,"C", 19,0})         // Espaco                          M    A      19    0  110  128


DbCreate(_cArqAE4,_aAE4)
DbUseArea(.T.,,_cArqAE4,"AE4",.F.) 
  
 
//------------  SEGMENTO AE3v0 - DADOS ADICIONAIS DE COMERCIAL.                 


_cArqAE3  := CriaTrab(NIL,.f.)
_cArqAE3 += ".DBF"
_aAE3 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aAE3,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aAE3,{"IdentFat"   ,"C", 14,0})         // IDENT. LOCAL FATURAMENTO        M    N      14    0    4   17
AADD(_aAE3,{"IdentCob"   ,"C", 14,0})         // IDENT. DO LOCAL DE COBRANCA     M    N      14    0   18   31
AADD(_aAE3,{"IdentEnt"   ,"C", 14,0})         // IDENT. LOCAL DE ENTREGA         M    A      14    0   32   45
AADD(_aAE3,{"Espaco"     ,"C", 83,0})         // Espaco                          M    A      83    0   46  128

DbCreate(_cArqAE3,_aAE3)
DbUseArea(.T.,,_cArqAE3,"AE3",.F.)       
    
 

//--------------- SEGMENTO TE1v0 - TEXTO LIVRE                          

_cArqTE1  := CriaTrab(NIL,.f.)
_cArqTE1 += ".DBF"
_aTE1 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aTE1,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aTE1,{"Texto1"     ,"C", 40,0})         // TEXTO LIVRE INFORMATIVO         M    A      40    0    4   43
AADD(_aTE1,{"Texto2"     ,"C", 40,0})         // TEXTO LIVRE INFORMATIVO         M    A      40    0   44   83
AADD(_aTE1,{"Texto3"     ,"C", 40,0})         // TEXTO LIVRE INFORMATIVO         M    A      40    0   84  123
AADD(_aTE1,{"Espaco"     ,"C", 05,0})         // Espaco                          M    A       5    0  124  128

DbCreate(_cArqTE1,_aTE1)
DbUseArea(.T.,,_cArqTE1,"TE1",.F.) 
   

//-------------  SEGMENTO FTPv0 - Segmento Final Mensagem                    
                    
                    
_cArqFTP  := CriaTrab(NIL,.f.)
_cArqFTP += ".DBF"
_aFTP := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aFTP,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aFTP,{"NumCont"    ,"C", 05,0})         // Numero de Controle Movimento    O    N       5    0    4    8
AADD(_aFTP,{"QtdeSeg"    ,"C", 09,0})         // Quantidade de Segmentos         M    N       9    0    9   17
AADD(_aFTP,{"NumToVl"    ,"C", 17,0})         // Numero Total de Valores         O    N      17    2   18   34
AADD(_aFTP,{"CatOper"    ,"C", 01,0})         // Categoria da Operacao           O    A       1    0   35   35
AADD(_aFTP,{"Espaco"     ,"C", 93,0})         // Espaco                          M    A      93    0   36  128

DbCreate(_cArqFTP,_aFTP)
DbUseArea(.T.,,_cArqFTP,"FTP",.F.) 
  

// ------- Segmento para mostrar no browse -----------
/*
_cArqDBF  := CriaTrab(NIL,.f.)
_aDBF := {}
                                                  // Nome              
AADD(_aDBF,{"OK"         ,"C", 02,0})         // Identificacao Marca
AADD(_aDBF,{"Nota"       ,"C", 09,0})         //  NUMERO DA NF 
AADD(_aDBF,{"Serie"      ,"C", 03,0})         // SERIE DA NOTA FISCAL 
AADD(_aDBF,{"Dta"        ,"C", 10,0})         // DATA DA NOTA FISCAL 
AADD(_aDBF,{"Prodcli"    ,"C", 15,2})         // Codigo do produto cliente
AADD(_aDBF,{"Prodwhb"    ,"C", 15,2})         // Codigo do produto new hubner
AADD(_aDBF,{"Total"      ,"N", 17,2})         // VALOR TOTAL DA NOTA FISCAL 
AADD(_aDBF,{"Espaco"     ,"C", 63,0})         // ESPACO

DbCreate(_cArqDBF,_aDBF)
DbUseArea(.T.,,_cArqDBF,"XDBF",.F.) 

INDEX ON XDBF->NOTA TO (_cArqDBF)
*/

Return                                