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

SetPrvt("CCADASTRO,AROTINA,_cEdiTest,_cCamTest,cArqTeste,cTeste")

SetPrvt("cServer2,cAcc,cPass,lConect,lEnvia,cMens,cMsg2,a_mail2")

cServer2	  := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.4"
cAcc  := Alltrim(GETMV("MV_RELACNT")) //'protheus'
cPass := Alltrim(GETMV("MV_RELPSW"))  //'siga'
lConect
lEnvia
cMsg2 := ''
cMens := 'Erro ao se conectar no servidor: '

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

if(SM0->M0_CODIGO<>"IT")
	#Include "fileio.ch"
	_cEdiTest     := alltrim(getmv("MV_EDI"))
	//_cEdiTest   := "\\agamedes\Edi\mdicom2\PARCEIRO\WHB.COM2\OUT\"
	_cCamTest     := Substr(Upper(cUserName),1,8) + ".TXT"
	cArqTeste     := _cEdiTest + _cCamTest
	cTeste	      := fCreate(cArqTeste, FC_NORMAL)
	
	if ferror()#0
		msgalert("O Arquivo não foi criado. Erro: " + str(ferror()))
	else
		fWrite(cTeste,"Teste Conexão WHB",17)
		fclose(cTeste)
	endif
	
	If !file(cArqTeste)
		
		MsgBox("Você não possui permissão para enviar ASN para o cliente, favor contatar a informatica !","Atencao","ALERT")
		
		CONNECT SMTP SERVER cServer2 ACCOUNT cAcc PASSWORD cPass Result lConect
		
		cMsg2 := '<html>' + CHR(13)+CHR(10)
		cMsg2 += '<head>' + CHR(13)+CHR(10)
		cMsg2 += '<title> E X E M P L O </title>' + CHR(13)+CHR(10)
		cMsg2 += '</head>' + CHR(13)+CHR(10)
		cMsg2 += '<body>' + CHR(13)+CHR(10)
		cMsg2 += 'Usuario: '+ Upper(cUserName) + " não possui acesso de leitura e gravação na pasta do EDI, ou espaço insuficiente !" + CHR(13)+CHR(10)
		cMsg2 += '</body>' + CHR(13)+CHR(10)
		cMsg2 += '</html>' + CHR(13)+CHR(10)
		
		a_mail2 := 'douglassd@whbbrasil.com.br;'
		a_mail2 += 'edenilsonas@whbbrasil.com.br'
		//a_email += 'marcosvs@whbbrasil.com.br'
		//a_email += 'alexandrerb@whbbrasil.com.br'
		
		If lConect
			
			Send Mail from 'protheus@whbbrasil.com.br' To a_mail2;
			SUBJECT '***** USUARIO SEM PERMISSAO DE GRAVAÇÃO NO EDI ***** ';
			BODY cMsg2;
			RESULT lEnvia
			If !lEnvia
				Get mail error cMens
				Alert(cMens)
			EndIf
		else
			Alert("Erro ao se conectar no servidor: " + cServer2)
		Endif
		
	else
		ferase(cArqTeste)
	EndIf
	
EndIf

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
nMax     := 1
_cDoc    := Space(06)
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
* Verifica se o número da ordem de liberação já existe *
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
	Processa({|| fOrdLib2() },"Aguarde... ")
return

Static function fOrdLib2()
Local lFlag := .F.
Local _cNF  := Space(06)
cCodPlac      := ""
aPlaca      := {""}
aHeader     := {}
aCols       := {}
_cCli       := Space(40)
_cDoc       := Space(06)
_dData      := date()
_cHora      := time()
_cTransp    := Space(30)
_cMot       := Space(30)
_cRG        := Space(10)
_cPCam      := Space(08)
_cPCar      := Space(08)
_cDesc      := Space(30)
_cProd      := Space(15)
//_cTPCarg    := Space(10)
_cFrete     := Space(06)
_nValFre    := 0
_nValPed    := 0
_nValICM    := 0
_dDtEntr    := Space(08)
_cHrEntr    := Space(05)
_cLacre     := Space(50)
_cHrJan     := Space(05)
_cHrJanF    := Space(05)
_cJanCli    := Space(05)
_cModTrans  := ""
_aModTrans  := {"","1=Carreta","2=Truck","3=Bug","4=Outro"}
_cOrdCar    := Space(100)

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

	//-- MELHORIA 13/01/2014
	//-- JOAOFR, PUXAR PLACA DO CADASTRO DE VEICULOS
	//-- QUE DERAM ENTRADA E NAO SAIRAM
	
	IF SELECT("TRASO5") > 0
		TRASO5->(DbCloseArea())
	EndIf
	                                    
	cQuery := " SELECT O5_CODIGO, O5_PLACA, O5_EMPRESA FROM "+RetSqlName("SO5")
	cQuery += " WHERE O5_HORASAI = '' AND O5_DTSAIDA = ''"
	cQuery += " AND D_E_L_E_T_ = '' AND O5_FILIAL = '"+xFilial("SO5")+"'"    
	cQuery += " ORDER BY O5_PLACA"
	
	TCQUERY cQuery NEW ALIAS "TRASO5"
	                               
    TRASO5->(DbGoTop())
    While TRASO5->(!EOF())
    	aAdd(aPlaca,ALLTRIM(TRASO5->O5_CODIGO)+"="+TRASO5->O5_PLACA+" - "+alltrim(TRASO5->O5_EMPRESA))
    	TRASO5->(DbSkip())
    Enddo
    
    TRASO5->(dbclosearea())

	//---- DIALOGO
	
	Define MsDialog oDialog Title OemToAnsi("Ordem de Liberação de Materiais") From 020,030 To 490,790 Pixel
	@ 005,007 To 115,372 Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE
	@ 015,010 Say "Numero :" Size 030,8
	@ 015,032 Say _cDoc Size 035,8 Object oDoc
	oDoc:Setfont(oFont)
	
	@ 015,070 Say "Cliente:" Size 30,8
	@ 013,090 Get _cCli  Picture "@!" When .F.  Size 170,8 Object oCli
	
	@ 015,270 Say "Data:" Size 30,8
	@ 013,285 Get _dData Picture "99/99/9999" When .F. Size 45,8 Object oData
	@ 013,335 Get _cHora Picture "99:99:99" When .F. Size 25,8 Object oHora
	
	@ 028,010 Say "Transportadora:" Size 045,8
	@ 026,050 Get _cTransp Picture "@!" When .F. Size 120,8 Object oTransp
	
	@ 028,175 Say "Dt Entrada:" Size 030,8 object oDtEntrada
	@ 026,205 Get _dDataEn Picture "@!" When .F. Size 25,8 Object oDataEn
	@ 028,240 Say "Hr Entrada:" Size 030,8 object oHrEntrada
	@ 026,270 Get _cHoraEn Picture "@!" When .F. Size 25,8 Object oHoraEn
	
	@ 028,315 Say "Jan. Cli:" Size 030,8 object olJanCli
	@ 026,340 Get _cJanCli Picture "99:99" Size 25,8 Object oJanCli
	
   	@ 040,010 Say "Informe a Placa do Veículo" Size 80,8

	oCombo1 := TComboBox():New(38,090,{|u| if(Pcount() > 0,cCodPlac := u,cCodPlac)},;
		aPlaca,200,20,oDialog,,{||fPlcChg()},,,,.T.,,,,{||.T.},,,,,"cCodPlac")

	oCombo1:SetFocus(oCombo1)
	
	@ 053,010 Say OemToAnsi("Placa Caminhão:") Color CLR_HBLUE  Size 050,8
	@ 051,050 Get _cPCam Picture "!!!-!!!!" Size 030,8 Valid fPlaca(_cPCam) Object oPCam
	
	@ 053,095 Say OemToAnsi("Placa Carreta :") Size 050,8
	@ 051,135 Get _cPCar Picture "!!!-!!!!" Size 030,8 Valid fPlaca(_cPCar) Object oPCar
	
	@ 053,175 Say "Hr.Jan. Ini:" Color CLR_HBLUE Size 025,8  object oHrja
	@ 051,205 Get _cHrJan Picture "!!:!!" Size 10,8 Valid .T. Object oHrJan
	
	@ 053,240 Say "Hr.Jan.Fim:" Color CLR_HBLUE Size 030,8  object oHrjafim
	@ 051,270 Get _cHrJanF Picture "!!:!!" Size 10,8 Object oHrJanfim
	
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
	
	dbselectarea("SZN")
	
	@ 127,008 TO 210,370 MULTILINE MODIFY OBJECT oMultiline
	
	@ 217,305 BMPBUTTON TYPE 01 ACTION fGrvOrd()
	@ 217,345 BMPBUTTON TYPE 02 ACTION fEnd() //FCancela()
	oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline
	Activate MsDialog oDialog Center
	
XETQ->(DbGoTop())
MarkBRefresh()

Return

Static Function fEnd()

RollBackSx8() //Volta a numeração da Ordem de Liberação
Close(oDialog)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVA A ORDEM ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fGrvOrd()
_aMail   := {} //LIMPA O ARRAY DOS ITENS QUE VAO SER ENVIADOS POR EMAIL
_vNotas  := ''
_vSerie  := ''
cCodProd := ""

If Empty(cCodPlac)
	Msgbox("Placa do veículo não selecionada, Verifique!!!" ,"Atencao Campo em Branco","ALERT" )
	return .f.
Endif

If Empty(_cHrJan) .OR. Empty(_cHrJanF)
	Msgbox("Horario de Janela  nao Foi Digitado, Verifique !!!" ,"Atencao Campo em Branco","ALERT" )
	return .f.
Endif

If Empty(_cPCam)
	Msgbox("A Placa do Caminhao Nao Foi Digitada , Verifique !!!" ,"Atencao Placa","ALERT" )
	Return(.F.)
Endif

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
	SZM->ZM_CODPLAC := cCodPlac
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
				If SB1->B1_TIPO$"PA/PW" .Or. ; //Produto acabado, Embalagem
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
	Close(oDialog)  
	
	// ***********  ASN GM *************************************************************************
	
	// ASN Automatico GM (Fundicao) Loja 02
	IF SM0->M0_CODIGO == "FN" .AND. Substr(_cCli,1,6)+Substr(_cCli,8,2) $ '90002402'
		Processa({|| AsnGM(_vNotas,_vSerie,1) }, "Aguarde, gerando aviso de embarque para GM...")
	EndIf
	
	// ASN Automatico GM (Fundicao) Loja 07
	IF SM0->M0_CODIGO == "FN" .AND. Substr(_cCli,1,6)+Substr(_cCli,8,2) $ '90002407'
		Processa({|| AsnGM(_vNotas,_vSerie,2) }, "Aguarde, gerando aviso de embarque para GM...")
	EndIf
	
	// ASN Automatico GM (Usinagem)
	IF SM0->M0_CODIGO == "NH" .AND. Substr(_cCli,1,6)+Substr(_cCli,8,2) $ '90000402'
		Processa({|| AsnGM(_vNotas,_vSerie,3) }, "Aguarde, gerando aviso de embarque para GM...")
	EndIf  
	
	// Na filial PE não se deve mandar o ASN, solicitado por LUIZWJ e de conhecimento de HESSLERR - 10/03/2014
	if( !Alltrim(upper(cUsername))$"JONESTONBM/RUBENSSR/EMANUELBM/SEVERINOBJ/JOSETM/CARLOSPJ" )
	
		// ASN Automatico Scania
		if SM0->M0_CODIGO == "FN" .AND. Substr(_cCli,1,6)+Substr(_cCli,8,2) $ '00000501'
			Processa({|| AsnScania(_vNotas,_vSerie) }, "Aguarde, gerando aviso de embarque para Scania...")
		EndIf
		
		// ASN Automatico Master
		if SM0->M0_CODIGO == "FN" .AND. Substr(_cCli,1,6)+Substr(_cCli,8,2) $ '00000301'
			Processa({|| AsnMaster(_vNotas,_vSerie) }, "Aguarde, gerando aviso de embarque para Master...")
		EndIf
		
		// ******************* VW - Fundicao ************************************************************
		
		// ASN Automatico VW // Sao Bernardo
		if SM0->M0_CODIGO == "FN" .AND. Substr(_cCli,1,6)+Substr(_cCli,8,2) $ '00001201'
			Processa({|| AsnVW(_vNotas,_vSerie) }, "Aguarde, gerando aviso de embarque para Volks...")
		EndIf
		
		// ASN Automatico VW // Sao Carlos
		if SM0->M0_CODIGO == "FN" .AND. Substr(_cCli,1,6)+Substr(_cCli,8,2) $ '00001202'
			Processa({|| AsnVW(_vNotas,_vSerie) }, "Aguarde, gerando aviso de embarque para Volks...")
		EndIf
		
		// ASN Automatico VW // AUDI
		if SM0->M0_CODIGO == "FN" .AND. Substr(_cCli,1,6)+Substr(_cCli,8,2) $ '00001203'
			Processa({|| AsnVW(_vNotas,_vSerie) }, "Aguarde, gerando aviso de embarque para Volks...")
		EndIf
		
		// ASN Automatico VW // Taubate
		if SM0->M0_CODIGO == "FN" .AND. Substr(_cCli,1,6)+Substr(_cCli,8,2) $ '00001204'
			Processa({|| AsnVW(_vNotas,_vSerie) }, "Aguarde, gerando aviso de embarque para Volks...")
		EndIf
		
		// ******************** VW - USINAGEM ***********************************************************
		
		// ASN Automatico VW // Sao Bernardo
		if SM0->M0_CODIGO == "NH" .AND. Substr(_cCli,1,6)+Substr(_cCli,8,2) $ '90000101'
			Processa({|| AsnVW(_vNotas,_vSerie) }, "Aguarde, gerando aviso de embarque para Volks...")
		EndIf
		
		// ASN Automatico VW // Taubate
		if SM0->M0_CODIGO == "NH" .AND. Substr(_cCli,1,6)+Substr(_cCli,8,2) $ '90000102'
			Processa({|| AsnVW(_vNotas,_vSerie) }, "Aguarde, gerando aviso de embarque para Volks...")
		EndIf
		
		// ASN Automatico VW // Sao carlos
		if SM0->M0_CODIGO == "NH" .AND. Substr(_cCli,1,6)+Substr(_cCli,8,2) $ '90000103'
			Processa({|| AsnVW(_vNotas,_vSerie) }, "Aguarde, gerando aviso de embarque para Volks...")
		EndIf
		
		// ASN Automatico VW // AUDI
		if SM0->M0_CODIGO == "NH" .AND. Substr(_cCli,1,6)+Substr(_cCli,8,2) $ '90000201'
			Processa({|| AsnVW(_vNotas,_vSerie) }, "Aguarde, gerando aviso de embarque para Volks...")
		EndIf
	
	EndIF
	
	// **********************************************************************************************
	
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
		If AllTrim(SB1->B1_GRUPO)$"PA01/PA02/PA03/PA04/PA06"
			cGrupo := Iif(Alltrim(SB1->B1_GRUPO)$"PA02/PA03","PA02",Alltrim(SB1->B1_GRUPO))
			exit
		EndIf
	Next
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
			(ZDF->ZDF_WHB=="3" .and. cGrupo=="PA02") .Or. ; //whb 3
			(ZDF->ZDF_WHB=="4" .AND. cGrupo=="PA04") .OR. ; // WHB FORJARIA
			(ZDF->ZDF_WHB=="6" .AND. cGrupo=="PA06")) .OR. ;// ALUMINIO
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

//Analista de Transporte WHB - Deve receber todos os e-mails de carregamento
if SM0->M0_CODIGO <> "IT"
	cTo += "wagnerlf@whbbrasil.com.br;"
endif

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
oMail:cMsg     := cMsg  //+'<br><br>'+cto
oMail:cAssunto := cAssunto
oMail:cTo      := cTo//'douglassd@whbbrasil.com.br'//

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CHAMADO AO SELECIONAR A PLACA DO CAD DE VEICULO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
static function fPlcChg()                            

	If Empty(cCodPlac)
		_cMot    := Space(30)
		_cRG     := Space(10)
		_cPCam   := Space(08)
		_cPCar   := Space(08)
		_cHoraen := Space(05)
		_dDataen := Space(08)
		_cModTrans := "" // modalidade de transporte
	Else
		SO5->(dbsetorder(1)) // O5_FILIAL+O5_CODIGO
		If SO5->(dbseek(xFilial("SO5")+cCodPlac))	
			_cMot      := SO5->O5_DESCRI
			_cRG       := SO5->O5_CHASSI
			_cPCam     := SO5->O5_PLACA
			_cPCar     := SO5->O5_PLACACA
			_cHoraen   := SO5->O5_HORAENT // Hora de Entrada do veiculo na empresa
			_dDataen   := SO5->O5_EMISSAO // Data de Entrada do veiculo na empresa
			_cModTrans := SO5->O5_MODTRAN // modalidade de transporte
		Endif
	Endif

	oHoraEn:Refresh()
	oDataen:Refresh()
	oMot:Refresh()
	oRG:Refresh()
	oPCam:Refresh()
	oPCar:Refresh()
	oModTrans:Refresh()
	
	oHrJan:SetFocus(oHrJan)
	fPriori() //verifica a prioridade se já existe acrescenta um

Return

Static Function fPlaca(_cPl)

Local _nNum  := 1
Local _lFlag := .T.
Local _cPlaca:= _cPl
_cPri        := "1"

If !Empty(_cPCam) .AND. ALLTRIM(_cPCam)<>'-' .And. Empty(_cPCar)
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

If !Empty(_cPCar) .AND. ALLTRIM(_cPcar)<>'-'
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
Private aWHB      := {"1=Ambos","2=WHBII","3=WHBIII","4=WHBIV","6=WHBVI"}

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

Static Function AsnScania(vNotas,vSerie)
setprvt("_cArqDbf, cQuery,_aFields,aCampos,cMarca,cNovaLinha,nPbruto,x,_cNotas")
setprvt("_cArqITP,_cArqAE1,_cArqNF2,_cArqAE2,_cArqAE4,_cArqAE3,_cArqTE1,_cArqFTP,cDtaHor ")
setprvt("_aITP,_aAE1,_aNF2,_caAE2,_aAE4,_aAE3,_aFTP,_aTE1, _aDBF,nAux,cCod,nFTP,cIPI,cICM,cDesc")
setprvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cNome,_aFile,_cEdi,_cCam")

cServer	 := alltrim(getmv("MV_RELSERV")) //"192.168.1.4"
cAccount  := alltrim(getmv("MV_RELACNT")) //'protheus'
cPassword := alltrim(getmv("MV_RELPSW"))  //'siga'
lConectou
lEnviado
cMSG      := ""
cMensagem := 'Erro ao se conectar no servidor: '
_cNome    := UsrFullName(__cUserID)
_aFile    := {}
_cNotas   := space(200)
cNovaLinha:= chr(13) + chr(10)
CRLF      := chr(13)+chr(10)   																 // PULA LINHA
_cEdi     := alltrim(getmv("MV_EDI")) 														 // Caminho para envio do EDI -> V:\mdicom\Parceiro\WHBCOMP\Out\
_cCam     := "SCA"+subs(dtos(ddatabase),7,2)+subs(dtos(ddatabase),5,2)+"1.TXT"
cARQEXP   := _cEDI + _cCam

while file(cARQEXP)
	_cCam  := subs(_cCam,1,7) +  strzero(val(SUBS(_cCam,8,1))+1,1)+".TXT"
	cARQEXP:= _cEDI + _cCam
enddo

_cCliente := "000005"
_cLoja    := "01"

cQuery := "SELECT D2.D2_DOC,D2.D2_COD,D2.D2_EMISSAO,D2.D2_QUANT,D2.D2_CLIENTE,D2.D2_LOJA,B1.B1_PESO,B1.B1_POSIPI,C5.C5_PBRUTO,C5.C5_VOLUME1,C6.C6_DESCRI,"
cQuery += "D2.D2_SERIE,D2.D2_ITEM,D2.D2_TOTAL,D2.D2_TES,D2.D2_VALICM,D2.D2_VALIPI,D2.D2_UM,D2.D2_IPI,D2.D2_PRCVEN,D2.D2_PICM,D2.D2_BASEICM,D2.D2_DESC,D2.D2_DESCON,"
cQuery += "A7.A7_CLIENTE,A7.A7_LOJA,A7.A7_PRODUTO,A7.A7_PCCLI,A7.A7_CODCLI"
cQuery += " FROM " +  RetSqlName( 'SD2' ) +" D2, " +  RetSqlName( 'SC5' ) +" C5, "+ RetSqlName( 'SC6' ) +" C6, "+ RetSqlName( 'SB1' ) +" B1, " + RetSqlName( 'SA7' ) +" A7, " + RetSqlName( 'SF4' ) +" F4 "
cQuery += " WHERE D2.D2_DOC IN (" + left(vNotas,len(vNotas)-1) + ") AND D2.D2_SERIE = '"+vSerie + "' "
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
cQuery += " AND D2.D_E_L_E_T_ = ' ' AND C5.D_E_L_E_T_ = ' ' AND C6.D_E_L_E_T_ = ' ' AND B1.D_E_L_E_T_ = ' ' AND A7.D_E_L_E_T_ = ' ' AND F4.D_E_L_E_T_ = ' '"
cQuery += " ORDER BY D2.D2_DOC,D2.D2_SERIE ASC"
TCQUERY cQuery NEW ALIAS "TMP"
dbselectarea("TMP")

cARQ  := FCreate(cARQEXP) //So cria o arquivo se tiver dados para enviar

/*+-----------------------------------+
! Parametros para fCriaAsn(nPadrao) !
! 1: Scania                         !
! 2: General Motors                 !
+-----------------------------------+
*/
U_fCriaAsn(1)  			  // Cria arquivos temporarios de aviso de embarque para Scania

TMP->(dbgotop())
if empty(TMP->D2_DOC)
	fclose(cARQ)
	ferase(cArQEXP)  // Deleta arquivo de dados pois não foi selecionado nenhuma nota
	XDBF->(dbclosearea())
	TMP->(dbclosearea())
	AE1->(DbCloseArea())
	AE2->(DbCloseArea())
	AE3->(DbCloseArea())
	AE4->(DbCloseArea())
	TE1->(DbCloseArea())
	NF2->(DbCloseArea())
	FTP->(DbCloseArea())
	return
endif

procregua(TMP->(reccount()))

TMP->(dbgotop())
nFTP := 1
_lEmb:= .F.                //verifica se gerou o aviso de embarque
while !TMP->(eof())
	incproc("Gerando Aviso de Embarque" )
	
	//** Segmento AE1v0 - Complemento dados da NFe **//
	_lEmb  := .T.                                                                                      // Verifica se gerou o aviso de embarque
	_cNotas:= alltrim(_cNotas) +" "+ TMP->D2_DOC + CRLF
	RecLock("AE1",.T.)
	AE1->IdentSeg   := "AE1"
	AE1->NumNF      := strzero(val(Alltrim(TMP->D2_DOC)),6)
	AE1->SerNF      := subs(TMP->D2_SERIE,1,2)
	AE1->DataNF     := subs(TMP->D2_EMISSAO,3,6)
	AE1->QItNf      := strzero(val(TMP->D2_ITEM),3)
	AE1->VlToNF     := strzero(TMP->D2_TOTAL,17,2)
	AE1->VlToNF     := stuff(AE1->VlToNF,AT(".",AE1->VlToNF),1,"")                                      // elimina o ponto
	AE1->VlToNF     := stuff(AE1->VlToNF,1,0,"0")                                                       // Insere o primeiro caracter
	AE1->QCDec      := "0"                                                                              // QTDE de casas decimais
	AE1->CFO        := TMP->D2_TES                                                                      // Alterado D2_CF
	AE1->VlToICM    := strzero(TMP->D2_VALICM,17,2)
	AE1->VlToICM    := stuff(AE1->VlToICM,at(".",AE1->VlToICM),1,"")                                    // elimina o ponto
	AE1->VlToICM    := stuff(AE1->VlToICM,1,0,"0")                                                      // Insere o primeiro caracter
	AE1->DataVen    := subs(dtos(dDatabase+7),3,6)
	AE1->EspNF      := iif(alltrim(TMP->D2_TES) == "613","02","00")
	AE1->VlIPI      := strzero(TMP->D2_VALIPI,17,2)
	AE1->VlIPI      := Stuff(AE1->VlIPI,at(".",AE1->VlIPI),1,"")                                        //elimina o ponto
	AE1->VlIPI      := Stuff(AE1->VlIPI,1,0,"0")                                                        // Insere o primeiro caracter
	AE1->CodFabEn   := ""
	AE1->DataPrNF   := iif((val(time())+14) > 24,subs(dtos(ddatabase+1),3,6),subs(dtos(ddatabase),3,6)) // verificar
	AE1->IdentPer   := "0000"
	SF4->(dbsetorder(1))
	SF4->(dbseek(xFilial("SF4")+TMP->D2_TES ))                                                          // F4_FILIAL+F4_CODIGO
	AE1->DescNat    := Subs(SF4->F4_TEXTO,1,20)
	AE1->Espaco     := Space(10)
	msunlock("AE1")
	fwrite(cArq,(AE1->(IdentSeg+NumNF+SerNF+DataNF+QItNf+VlToNF+QCDec+CFO+VlToICM+DataVen+EspNF+VlIPI+CodFabEn+DataPrNF+IdentPer+DescNat+Espaco)+cNovaLinha))
	nFTP += 1                                                                                           //Controle de qtde de segmentos
	
	//** Segmento AE2v1 - Dados do item **//
	//cCod := TMP->A7_CODCLI //Codigo da amarracao prod x cliente
	Reclock("AE2",.T.)
	AE2->IdentSeg    := "AE2"
	AE2->NumItNF     := strzero(val(TMP->D2_ITEM),3)
	AE2->NumPed      := TMP->A7_PCCLI
	AE2->CodItem     := TMP->A7_CODCLI                                // Codigo da amarracao prod x clientecCod
	AE2->QINF        := strzero(TMP->D2_QUANT,9,0)
	AE2->UnMedNF     := TMP->D2_UM
	AE2->CodClasF    := TMP->B1_POSIPI
	cIPI             := strzero(TMP->D2_IPI,5,2)
	AE2->AliIPI      := stuff(cIPI,AT(".",cIPI),1,"")                 // elimina o ponto
	AE2->VlItem      := strzero(TMP->D2_PRCVEN,12,5)
	AE2->VlItem      := stuff(AE2->VlItem,at(".",AE2->VlItem),1,"")   // elimina o ponto
	AE2->VlItem      := stuff(AE2->VlItem,1,0,"0")                    // Insere o primeiro caracter
	AE2->QItEst      := strzero(TMP->D2_QUANT,9,0)
	AE2->UnMedEs     := TMP->D2_UM
	AE2->QtUniCom    := strzero(TMP->D2_QUANT,9,0)
	AE2->UnMedCo     := TMP->D2_UM
	AE2->CodTpFo     := "P"                                           // P= Producao
	cDesc            := strzero(TMP->D2_DESC,4,2)
	AE2->QtPerDe     := stuff(cDesc,AT(".",cDesc),1,"")               // Elimina o ponto
	AE2->VlToDes     := strzero(TMP->D2_DESCON,11,2)
	AE2->VlToDes     := stuff(AE2->VlToDes,AT(".",AE2->VlToDes),1,"") // Elimina o ponto
	AE2->VlToDes     := stuff(AE2->VlToDes,1,0,"0")                   // Insere o primeiro caracter
	AE2->Espaco      := space(05)
	msunlock("AE2")
	fwrite(cArq,(AE2->(IdentSeg+NumItNF+NumPed+CodItem+QINF+UnMedNF+CodClasF+AliIPI+VlItem+QItEst+UnMedEs+QtUniCom+UnMedCo+CodTpFo+QtPerDe+VlToDes+Espaco)+cNovaLinha))
	nFTP += 1                                                         //Controle de qtde de segmentos
	
	//** Segmento AE4v1 - Dados complementares do item
	reclock("AE4",.T.)
	AE4->IdentSeg  := "AE4"
	AE4->AlICM     := strzero(TMP->D2_PICM,2)+"00"
	AE4->BasICM    := strzero(TMP->D2_BASEICM,17,2)
	AE4->BasICM    := stuff(AE4->BasICM,at(".",AE4->BasICM),1,"0") //troca ponto por zero
	AE4->VlICMAp   := strzero(TMP->D2_VALICM,17,2)
	AE4->VlICMAp   := stuff(AE4->VlICMAp,at(".",AE4->VlICMAp),1,"0") //elimina o ponto
	AE4->VlIPIAp   := strzero(TMP->D2_VALIPI,17,2)
	AE4->VlIPIAp   := stuff(AE4->VlIPIAp,at(".",AE4->VlIPIAp),1,"0") //elimina o ponto
	AE4->CodSiTr   := "00"
	AE4->NumDesIt  := space(30)
	AE4->DatValDe  := space(06)
	AE4->PedRev    := space(13)
	AE4->Espaco    := space(19)
	msunlock("AE4")
	fwrite(cArq,(AE4->(IdentSeg+AlICM+BasICM+VlICMAp+VlIPIAp+CodSiTr+NumDesIt+DatValDe+PedRev+Espaco)+cNovaLinha))
	nFTP += 1  //Controle de qtde de segmentos
	
	//** Segmento TE1v0 **//
	reclock("TE1",.T.)
	TE1->IdentSeg := "TE1"
	TE1->Texto1   := space(40)
	TE1->Texto2   := space(40)
	TE1->Texto3   := space(40)
	TE1->Espaco   := space(05)
	msunlock("TE1")
	fwrite(cArq,(TE1->(IdentSeg+Texto1+Texto2+Texto3+Espaco)+cNovaLinha))
	nFTP  += 1  // Controle de qtde de segmentos
	TMP->(dbskip())
Enddo

If nFTP > 1
	//** Segmento FTPv0 - Segmento Final Mensagem **//
	nFTP += 1  									//Controle de qtde de segmentos
	reclock("FTP",.T.)
	FTP->IdentSeg := "FTP"
	FTP->NumCont  := "00000"
	FTP->QtdeSeg  :=StrZero(nFTP,9)
	FTP->NumToVl  :="00000000000000000"
	FTP->CatOper  := Space(01)
	FTP->Espaco   := Space(36)
	msunlock("FTP")
	fwrite(cArq,(FTP->(IdentSeg+NumCont+QtdeSeg+NumToVl+CatOper+ Espaco)+cNovaLinha))
	fclose(cARQ)
	Aviso("ASN - Scania | Atenção","Aviso(s) de embarque(s) gerado(s) com sucesso."+CRLF+CRLF+;
	"Total de Registros Processados: "+StrZero(nFTP-2,3), {"OK"},2)
else
	fclose(cARQ)
	ferase(cArQEXP)  						// Deleta arquivo de dados pois não foi selecionado nenhuma nota
endif

XDBF->(dbclosearea())
TMP->(dbclosearea())
AE1->(dbclosearea())
AE2->(dbclosearea())
AE3->(dbclosearea())
AE4->(dbclosearea())
TE1->(dbclosearea())
NF2->(dbclosearea())
FTP->(dbclosearea())

if file( _cArqDBF )  // Deleta arquivo de dados temporario
	fErase(_cArqDBF)
	fErase(_cArqITP)
	fErase(_cArqAE1)
	fErase(_cArqAE2)
	fErase(_cArqAE3)
	fErase(_cArqAE4)
	fErase(_cArqTE1)
	fErase(_cArqNF2)
	fErase(_cArqFTP)
endif

//Manda e-mail de confirmação da geração do aviso de embarque da Scania
if _lEmb 																												//verifica se gerou o aviso de embarque
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
	cMsg += '<html>' + CRLF
	cMsg += '<head>' + CRLF
	cMsg += '<title> E X E M P L O </title>' + CRLF
	cMsg += '</head>' + CRLF
	cMsg += ' <P><IMG SRC="WHBL.BMP" ALIGN=BOTTOM><b><font size="5" face="Times New Roman">'+CRLF+'          Aviso de Embarque</font></b></P>'+ CRLF
	cMsg += '<b><font size="3" face="Arial"> Email Enviado Atraves do Sistema Protheus</font></b>' + CRLF+CRLF
	cMsg += '<font size="2" face="Arial">Aviso de Embarque Enviado para Scania as '+time() +' na data: '+Dtoc(ddatabase)+'</font>' + CRLF
	cMsg += CRLF
	cMsg += '<font size="2" face="Arial"> Notas enviadas  '+CRLF
	cMsg += _cNotas+'</font>' + CRLF
	cMsg += CRLF
	cMsg += CRLF
	cMsg += '<font size="2" face="Arial"> Aviso de Embarque Gerado Por '+_cNome+'</font>' + CRLF
	cMsg += '</body>' + CRLF
	cMsg += '</html>' + CRLF
	
	if SM0->M0_CODIGO == "FN"  //empresa Fundicao
		a_email := 'lista-fiscal@whbbrasil.com.br;'
		a_email += 'edenilsonas@whbbrasil.com.br'
	endif
	
	_aFile := { "\System\WHBL.BMP" }
	
	if lConectou
		Send Mail from 'protheus@whbbrasil.com.br' To a_email;
		SUBJECT '*** AVISO DE EMBARQUE PARA SCANIA AUTOMATIZADO NA ORDEM DE LIBERAÇÃO ***';
		BODY cMsg;
		ATTACHMENT _aFile[1];
		RESULT lEnviado
		if !lEnviado
			get mail error cMensagem
			Alert(cMensagem)
		endif
	else
		Alert("Erro ao se conectar no servidor: " + cServer)
	endif
endif

if file(cARQEXP)
	fclose(cARQ)
	if !_lEmb
		ferase(cArQEXP)  // Deleta arquivo de dados pois não foi selecionado nenhuma nota
	endif
endif

return


//********************************************************************************************************
//***************************** AVISO DE EMBARQUE AUTOMATICO PARA A MASTER *******************************
//********************************************************************************************************

Static Function AsnMaster(vNotas,vSerie)
setprvt("_cArqDbf, cQuery,_aFields,aCampos,cMarca,cNovaLinha,nPbruto,x,_cNotas")
setprvt("_cArqITP,_cArqAE1,_cArqNF2,_cArqAE2,_cArqAE4,_cArqAE3,_cArqTE1,_cArqFTP,cDtaHor ")
setprvt("_aITP,_aAE1,_aNF2,_caAE2,_aAE4,_aAE3,_aFTP,_aTE1, _aDBF,nAux,cCod,nFTP,cIPI,cICM,cDesc")
setprvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cNome,_aFile,_cEdi,_cCam")

cServer	  := alltrim(getmv("MV_RELSERV")) //"192.168.1.4"
cAccount  := alltrim(getmv("MV_RELACNT")) //'protheus'
cPassword := alltrim(getmv("MV_RELPSW"))  //'siga'
lConectou
lEnviado
cMSG      := ""
cMensagem := 'Erro ao se conectar no servidor: '
_cNome    := UsrFullName(__cUserID)
_aFile    := {}
_cNotas   := space(200)
cNovaLinha:= chr(13) + chr(10)
CRLF      := chr(13)+chr(10)   																 // PULA LINHA
_cEdi     := alltrim(getmv("MV_EDI")) 														 // Caminho para envio do EDI -> V:\mdicom\Parceiro\WHBCOMP\Out\
_cCam     := "MAS"+Subs(Dtos(dDatabase),7,2)+Subs(Dtos(dDatabase),5,2)+"1.TXT"
cARQEXP   := _cEDI + _cCam

while file(cARQEXP)
	_cCam  := subs(_cCam,1,7) +  strzero(val(SUBS(_cCam,8,1))+1,1)+".TXT"
	cARQEXP:= _cEDI + _cCam
enddo

_cCliente := "000003"
_cLoja    := "01"
/*
cQuery := "SELECT D2.D2_DOC,D2.D2_COD,D2.D2_EMISSAO,D2.D2_QUANT,D2.D2_CLIENTE,D2.D2_LOJA,B1.B1_PESO,B1.B1_POSIPI,C5.C5_PBRUTO,C5.C5_VOLUME1,C6.C6_DESCRI,"
cQuery += "D2.D2_SERIE,D2.D2_ITEM,D2.D2_TOTAL,D2.D2_TES,D2.D2_CF,D2.D2_VALICM,D2.D2_VALIPI,D2.D2_UM,D2.D2_IPI,D2.D2_PRCVEN,D2.D2_PICM,D2.D2_BASEICM,D2.D2_DESC,D2.D2_DESCON,"
cQuery += "A7.A7_CLIENTE,A7.A7_LOJA,A7.A7_PRODUTO,A7.A7_PCCLI,A7.A7_CODCLI,F4.F4_TEXTO"
cQuery += " FROM " +  RetSqlName( 'SD2' ) +" D2, " +  RetSqlName( 'SC5' ) +" C5, "+ RetSqlName( 'SC6' ) +" C6, "+ RetSqlName( 'SB1' ) +" B1, " + RetSqlName( 'SA7' ) +" A7, " + RetSqlName( 'SF4' ) +" F4 "
cQuery += " WHERE D2.D2_DOC IN (" + left(vNotas,len(vNotas)-1) + ") AND D2.D2_SERIE = '"+vSerie + "' "
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
cQuery += " AND D2.D_E_L_E_T_ = ' ' AND C5.D_E_L_E_T_ = ' ' AND C6.D_E_L_E_T_ = ' ' AND B1.D_E_L_E_T_ = ' ' AND A7.D_E_L_E_T_ = ' ' AND F4.D_E_L_E_T_ = ' '"
cQuery += " ORDER BY D2.D2_DOC,D2.D2_SERIE ASC"
*/
cQuery := "SELECT D2.D2_DOC,D2.D2_COD,D2.D2_EMISSAO,D2.D2_QUANT,D2.D2_CLIENTE,D2.D2_LOJA,B1.B1_PESO,B1.B1_POSIPI,C5.C5_PBRUTO,C5.C5_VOLUME1,C6.C6_DESCRI,"
cQuery += "D2.D2_SERIE,D2.D2_ITEM,D2.D2_TOTAL,D2.D2_TES,D2.D2_CF,D2.D2_VALICM,D2.D2_VALIPI,D2.D2_UM,D2.D2_IPI,D2.D2_PRCVEN,D2.D2_PICM,D2.D2_BASEICM,D2.D2_DESC,D2.D2_DESCON,"
cQuery += "A7.A7_CLIENTE,A7.A7_LOJA,A7.A7_PRODUTO,A7.A7_PCCLI,A7.A7_CODCLI,F4.F4_TEXTO"
cQuery += " FROM " +  RetSqlName( 'SD2' ) +" D2, " +  RetSqlName( 'SC5' ) +" C5, "+ RetSqlName( 'SC6' ) +" C6, "+ RetSqlName( 'SB1' ) +" B1, " + RetSqlName( 'SA7' ) +" A7 ," + RetSqlName( 'SF4' ) +" F4 "
cQuery += " WHERE D2.D2_DOC IN (" + left(vNotas,len(vNotas)-1) + ") AND D2.D2_SERIE = '"+vSerie + "' "
cQuery += " AND C5.C5_FILIAL = '" + xFilial("SC5")+ "' "
cQuery += " AND C6.C6_FILIAL = '" + xFilial("SC6")+ "' "
cQuery += " AND F4.F4_FILIAL = '" + xFilial("SF4")+ "' "
cQuery += " AND D2.D2_FILIAL = '" + xFilial("SD2")+ "' "
cQuery += " AND A7.A7_FILIAL = '" + xFilial("SA7")+ "' "
cQuery += " AND B1.B1_FILIAL = '" + xFilial("SB1")+ "' "
cQuery += " AND D2.D2_CLIENTE = '" + _cCliente + "' AND D2.D2_LOJA = '" + _cLoja + "' "
cQuery += " AND D2.D2_CLIENTE= '000003' AND D2.D2_LOJA= '01' "
cQuery += " AND D2.D2_TES = F4.F4_CODIGO"
cQuery += " AND C5.C5_NOTA = D2.D2_DOC AND C5.C5_SERIE = D2.D2_SERIE AND D2.D2_TES IN ('576')"
cQuery += " AND C6.C6_NOTA = D2.D2_DOC AND C6.C6_SERIE = D2.D2_SERIE AND D2.D2_TIPO = 'N' "
cQuery += " AND C6.C6_ITEM = D2.D2_ITEMPV "
cQuery += " AND D2.D2_CLIENTE = A7.A7_CLIENTE AND D2.D2_LOJA = A7.A7_LOJA"
cQuery += " AND B1.B1_COD = D2.D2_COD AND A7.A7_PRODUTO = D2.D2_COD"
cQuery += " AND D2. D_E_L_E_T_ = ' ' AND C5. D_E_L_E_T_ = ' ' AND C6. D_E_L_E_T_ = ' ' AND B1. D_E_L_E_T_ = ' ' "
cQuery += " AND F4. D_E_L_E_T_ = ' ' AND A7. D_E_L_E_T_ = ' '"
cQuery += " ORDER BY D2.D2_DOC ASC"

TCQUERY cQuery NEW ALIAS "TMP"
MemoWrit('C:\TEMP\NHEST021MASTER.SQL',cQuery)
dbselectarea("TMP")

cARQ  := FCreate(cARQEXP) //So cria o arquivo se tiver dados para enviar
U_fCriaDBF()  			  // Cria arquivos temporarios de aviso de embarque para Master (NHFAT017)

TMP->(dbgotop())
if empty(TMP->D2_DOC)
	fclose(cARQ)
	ferase(cArQEXP)  // Deleta arquivo de dados pois não foi selecionado nenhuma nota
	XDBF->(dbclosearea())
	TMP->(dbclosearea())
	AE1->(DbCloseArea())
	AE2->(DbCloseArea())
	AE3->(DbCloseArea())
	AE4->(DbCloseArea())
	TE1->(DbCloseArea())
	NF2->(DbCloseArea())
	FTP->(DbCloseArea())
	return
endif

procregua(TMP->(reccount()))

TMP->(dbgotop())
nFTP := 1
_lEmb:= .F.                //verifica se gerou o aviso de embarque
while !TMP->(eof())
	incproc("Gerando Aviso de Embarque" )
	
	//** Segmento AE1v0 - Complemento dados da NFe **//
	_lEmb := .T. //verifica se gerou o aviso de embarque
	_cNotas := ALLTRIM(_cNotas) +" "+ TMP->D2_DOC + CRLF
	RecLock("AE1",.T.)
	AE1->IdentSeg   := "AE1"
	AE1->NumNF      := SUBS(TMP->D2_DOC,4,6)
	AE1->SerNF      := Space(02) // Subs(TMP->D2_SERIE,1,2)
	AE1->DataNF     := Subs(TMP->D2_EMISSAO,3,6)
	AE1->QItNf      := StrZero(Val(TMP->D2_ITEM),3)
	AE1->VlToNF     := StrZero(TMP->D2_TOTAL,17,2)
	AE1->VlToNF     := Stuff(AE1->VlToNF,AT(".",AE1->VlToNF),1,"") //elimina o ponto
	AE1->VlToNF     := Stuff(AE1->VlToNF,1,0,"0")  // Insere o primeiro caracter
	AE1->QCDec      := "0"  // QTDE de casas decimais
	AE1->CFO        := TMP->D2_CF
	AE1->VlToICM    := StrZero(TMP->D2_VALICM,17,2)
	AE1->VlToICM    := Stuff(AE1->VlToICM,AT(".",AE1->VlToICM),1,"") //elimina o ponto
	AE1->VlToICM    := Stuff(AE1->VlToICM,1,0,"0")  // Insere o primeiro caracter
	AE1->DataVen    := Subs(Dtos(dDatabase+7),3,6)
	AE1->EspNF      := Iif(Alltrim(TMP->D2_TES) == "576","02","00")
	AE1->VlIPI      := StrZero(TMP->D2_VALIPI,17,2)
	AE1->VlIPI      := Stuff(AE1->VlIPI,AT(".",AE1->VlIPI),1,"") //elimina o ponto
	AE1->VlIPI      := Stuff(AE1->VlIPI,1,0,"0")  // Insere o primeiro caracter
	AE1->CodFabEn   := Space(03)
	AE1->DataPrNF   := Iif((Val(Time())+14) > 24,Subs(Dtos(dDatabase+1),3,6),Subs(Dtos(dDatabase),3,6)) // verificar
	AE1->IdentPer   := "0000"
	
	AE1->DescNat    := Subs(TMP->F4_TEXTO,1,15)
	AE1->DataEmb    := Subs(TMP->D2_EMISSAO,3,6)
	// AE1->VlToNF     := Stuff(AE1->VlToNF,AT(".",AE1->VlToNF),1,"") //elimina o ponto
	//     alert(" hora  "+Subs(time(),1,5))
	AE1->HoraSai    := Stuff(Subs(time(),1,5),AT(":",Subs(time(),1,5)),1,"") //elimina o ponto
	//	   alert ( " hora certa  " + AE1->HoraSai)
	AE1->Espaco     := Space(03)
	MsUnlock("AE1")
	
	FWrite(cArq,(AE1->(IdentSeg+NumNF+SerNF+DataNF+QItNf+VlToNF+QCDec+CFO+VlToICM+DataVen+EspNF+VlIPI+CodFabEn+DataPrNF+IdentPer+DescNat+DataEmb+VlToNF+Espaco)+cNovaLinha))
	nFTP += 1  //Controle de qtde de segmentos
	
	//** Segmento AE2v1 - Dados do item **//
	//cCod := TMP->A7_CODCLI //Codigo da amarracao prod x cliente
	Reclock("AE2",.T.)
	AE2->IdentSeg    := "AE2"
	AE2->NumItNF     := StrZero(Val(TMP->D2_ITEM),3)
	AE2->NumPed      := TMP->A7_PCCLI
	// AE2->CodItem     := Subs(Alltrim(cCod),1,3)+Space(03)+Subs(Alltrim(cCod),4,6)+Space(01)+Subs(Alltrim(cCod),10,10)
	AE2->CodItem     := strtran(TMP->A7_CODCLI,' ','')
	AE2->QINF        := StrZero(TMP->D2_QUANT,9,0)
	AE2->UnMedNF     := TMP->D2_UM
	AE2->CodClasF    := TMP->B1_POSIPI
	cIPI             := StrZero(TMP->D2_IPI,4,2)
	AE2->AliIPI      := Stuff(cIPI,AT(".",cIPI),1,"") //elimina o ponto
	AE2->VlItem      := StrZero(TMP->D2_PRCVEN,12,5)
	AE2->VlItem      := Stuff(AE2->VlItem,AT(".",AE2->VlItem),1,"") //elimina o ponto
	AE2->VlItem      := Stuff(AE2->VlItem,1,0,"0")  // Insere o primeiro caracter
	AE2->QItEst      := StrZero(TMP->D2_QUANT,9,0)
	AE2->UnMedEs     := TMP->D2_UM
	AE2->QtUniCom    := StrZero(TMP->D2_QUANT,9,0)
	AE2->UnMedCo     := TMP->D2_UM
	AE2->CodTpFo     := "P"  // P= Producao
	cDesc            := StrZero(TMP->D2_DESC,4,2)
	AE2->QtPerDe     := Stuff(cDesc,AT(".",cDesc),1,"") //elimina o ponto
	AE2->QtPerDe     := Stuff(AE2->QtPerDe,1,0,"0")  // Insere o primeiro caracter
	AE2->VlToDes     := StrZero(TMP->D2_DESCON,11,2)
	AE2->VlToDes     := Stuff(AE2->VlToDes,AT(".",AE2->VlToDes),1,"") //elimina o ponto
	AE2->VlToDes     := Stuff(AE2->VlToDes,1,0,"0")  // Insere o primeiro caracter
	AE2->QtPerDes    := "0000"
	AE2->Espaco      := Space(01)
	MsUnlock("AE2")
	
	FWrite(cArq,(AE2->(IdentSeg+NumItNF+NumPed+CodItem+QINF+UnMedNF+CodClasF+AliIPI+VlItem+QItEst+UnMedEs+QtUniCom+UnMedCo+CodTpFo+QtPerDe+VlToDes+QtPerDes+Espaco)+cNovaLinha))
	nFTP += 1  //Controle de qtde de segmentos
	
	//** Segmento AE4v1 - Dados complementares do item
	RecLock("AE4",.T.)
	AE4->IdentSeg  := "AE4"
	cICM            := StrZero(TMP->D2_PICM,5,2)
	AE4->AlICM     := Stuff(cICM,AT(".",cICM),1,"") //elimina o ponto
	// 	   AE2->QtPerDe     := Stuff(AE2->QtPerDe,1,0,"0")  // Insere o primeiro caracter
	AE4->BasICM    := StrZero(TMP->D2_BASEICM,17,2)
	AE4->BasICM    := Stuff(AE4->BasICM,AT(".",AE4->BasICM),1,"") //elimina o ponto
	AE4->BasICM    := Stuff(AE4->BasICM,1,0,"0")  // Insere o primeiro caracter
	AE4->VlICMAp    := StrZero(TMP->D2_VALICM,17,2)
	AE4->VlICMAp    := Stuff(AE4->VlICMAp,AT(".",AE4->VlICMAp),1,"") //elimina o ponto
	AE4->VlICMAp    := Stuff(AE4->VlICMAp,1,0,"0")  // Insere o primeiro caracter
	AE4->VlIPIAp    := StrZero(TMP->D2_VALIPI,17,2)
	AE4->VlIPIAp    := Stuff(AE4->VlIPIAp,AT(".",AE4->VlIPIAp),1,"") //elimina o ponto
	AE4->VlIPIAp    := Stuff(AE4->VlIPIAp,1,0,"0")  // Insere o primeiro caracter
	AE4->CodSiTr   := "00"
	AE4->NumDesIt  := Space(30)
	AE4->DatValDe  := Space(06)
	AE4->PedRev    := Space(13)
	AE4->PeItem    := Space(05)
	AE4->MuPreco   := Space(01)
	AE4->PreMer    := Strzero(TMP->D2_TOTAL,12,2)
	AE4->PreMer    := Stuff(AE4->PreMer,AT(".",AE4->PreMer),1,"") //elimina o ponto
	AE4->PreMer    := Stuff(AE4->PreMer,1,0,"0")  // Insere o primeiro caracter
	AE4->SitTrib   := Space(01)
	
	MsUnlock("AE4")
	
	FWrite(cArq,(AE4->(IdentSeg+AlICM+BasICM+VlICMAp+VlIPIAp+CodSiTr+NumDesIt+DatValDe+PedRev+PeItem+MuPreco+PreMer+SitTrib)+cNovaLinha))
	nFTP += 1  //Controle de qtde de segmentos
	
	TMP->(dbskip())
Enddo

If nFTP > 1
	//** Segmento FTPv0 - Segmento Final Mensagem **//
	nFTP += 1  									//Controle de qtde de segmentos
	reclock("FTP",.T.)
	FTP->IdentSeg := "FTP"
	FTP->NumCont  := "00000"
	FTP->QtdeSeg  := StrZero(nFTP,9)
	FTP->NumToVl  := "00000000000000000"
	FTP->CatOper  := Space(01)
	FTP->Espaco   := Space(36)
	msunlock("FTP")
	
	fwrite(cArq,(FTP->(IdentSeg+NumCont+QtdeSeg+NumToVl+CatOper+ Espaco)+cNovaLinha))
	fclose(cARQ)
	Aviso("ASN - Master | Atenção","Aviso(s) de embarque(s) gerado(s) com sucesso."+CRLF+CRLF+;
	"Total de Registros Processados: "+StrZero(nFTP-2,3), {"OK"},2)
else
	fclose(cARQ)
	ferase(cArQEXP)  						// Deleta arquivo de dados pois não foi selecionado nenhuma nota
endif

XDBF->(dbclosearea())
TMP->(dbclosearea())
AE1->(dbclosearea())
AE2->(dbclosearea())
AE3->(dbclosearea())
AE4->(dbclosearea())
TE1->(dbclosearea())
NF2->(dbclosearea())
FTP->(dbclosearea())

if file( _cArqDBF )  // Deleta arquivo de dados temporario
	fErase(_cArqDBF)
	fErase(_cArqITP)
	fErase(_cArqAE1)
	fErase(_cArqAE2)
	fErase(_cArqAE3)
	fErase(_cArqAE4)
	fErase(_cArqTE1)
	fErase(_cArqNF2)
	fErase(_cArqFTP)
endif

//Manda e-mail de confirmação da geração do aviso de embarque da volks
If _lEmb //verifica se gerou o aviso de embarque
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
	
	cMsg += '<html>' + CRLF
	cMsg += '<head>' + CRLF
	cMsg += '<title> E X E M P L O </title>' + CRLF
	cMsg += '</head>' + CRLF
	cMsg += ' <P><IMG SRC="WHBL.BMP" ALIGN=BOTTOM><b><font size="5" face="Times New Roman">'+CRLF+'          Aviso de Embarque</font></b></P>'+ CRLF
	cMsg += '<b><font size="3" face="Arial"> Email Enviado Atraves do Sistema AP11</font></b>' + CRLF+CRLF
	cMsg += '<font size="2" face="Arial">Aviso de Embarque Automatico Enviado para Master as '+time() +' na data: '+Dtoc(ddatabase)+'</font>' + CRLF
	cMsg += CRLF
	cMsg += '<font size="2" face="Arial"> Notas enviadas  '+CRLF
	cMsg += _cNotas+'</font>' + CRLF
	cMsg += CRLF
	cMsg += CRLF
	cMsg += '<font size="2" face="Arial"> Aviso de Embarque Gerado Por '+_cNome+'</font>' + CRLF
	cMsg += '</body>' + CRLF
	cMsg += '</html>' + CRLF
	
	a_email := 'lista-fiscal@whbbrasil.com.br;'
	a_email += 'douglassd@whbbrasil.com.br;'
	a_email += 'edenilsonas@whbbrasil.com.br'
	
	_aFile := { "\System\WHBM.BMP" }
	
	If lConectou
		Send Mail from 'protheus@whbbrasil.com.br' To a_email;
		SUBJECT '***** AVISO DE EMBARQUE AUTOMATICO PARA MASTER ***** ';
		BODY cMsg;
		ATTACHMENT _aFile[1];
		RESULT lEnviado
		If !lEnviado
			Get mail error cMensagem
			Alert(cMensagem)
		EndIf
	else
		Alert("Erro ao se conectar no servidor: " + cServer)
	Endif
	
Endif

if file(cARQEXP)
	fclose(cARQ)
	if !_lEmb
		ferase(cArQEXP)  // Deleta arquivo de dados pois não foi selecionado nenhuma nota
	endif
endif

return



//********************************************************************************************************
//************************************** ASN GM **********************************************************
//********************************************************************************************************

Static Function AsnGM(vNotas,vSerie,_ctipo)
SetPrvt("_cArqDbf,cQuery,_aFields,aCampos,cMarca,cNovaLinha,cARQEXP ,cARQ,nPbruto,x ")
SetPrvt("_cArqITP,_cArqgAE1,_cArqgAE2,_cArqAE3,_cArqFTP,cDtaHor ")
SetPrvt("_aITP,_gAE1,_caAE2,_aAE3,_aFTP,_aDBF,nAux,cCod,nFTP,cIPI,cICM,cDesc")
SetPrvt("aRotina,cCadastro,_cCliente,_cLoja,_cPlanta,_cCGC,_cNotas,_cNotasP,_clEmb,a_email,cPerg,_aGMs")
SetPrvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cNome,_aFile,_cEdi,_cCam,_cDoc,_nCont")
SetPrvt("_cArqGM1,_cArqGM2,_cArqGM3,aGM1,aGM2")

cServer	 := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.4"
cAccount := Alltrim(GETMV("MV_RELACNT")) //'protheus'
cPassword:= Alltrim(GETMV("MV_RELPSW"))  //'siga'
lConectou
lEnviado
cMensagem := 'Erro ao se conectar no servidor: '
CRLF      := chr(13)+chr(10)   // PULA LINHA
cMSG      := ""
_lEmb     := .F. //verifica se gerou o aviso de embarque
nPbruto   := 0
nFTP      := 0
_nCont    := 1
_cArqDBF  := SPACE(12)
_cArqFTP  := SPACE(12)
_cArqITP  := SPACE(12)
_cArqgAE1 := SPACE(12)
_cArqgAE2 := SPACE(12)
_cArqAE3  := SPACE(12)
_cNotas   := SPACE(200)
_cNotasP  := SPACE(200)
_cNome    := UsrFullName(__cUserID)
_aFile    := {}
_aGMs     := {}
cNovaLinha:= Chr(13) + Chr(10)
aMes      := {"1","2","3","4","5","6","7","8","9","A","B","C"}
_cEdi     := Alltrim(GETMV("MV_EDI")) //caminho para envio do EDI   // "V:\mdicom\Parceiro\WHBCOMP\Out\"
_cCam     := "GM"+Subs(Dtos(dDatabase),7,2)+aMes[(Month(dDatabase))]+"001.TXT"
cARQEXP   := _cEDI + _cCam

If File( _cArqDBF )
	
	fErase(_cArqDBF)  // Deleta arquivo de dados temporario
	fErase(_cArqITP)
	fErase(_cArqgGM1)
	fErase(_cArqgGM2)
	fErase(_cArqgAE1)
	fErase(_cArqgAE2)
	fErase(_cArqgAE1)
	fErase(_cArqgGM3)
	fErase(_cArqAE3)
	fErase(_cArqFTP)
	
Endif

cQuery := "SELECT D2.D2_DOC,D2.D2_COD,D2.D2_EMISSAO,D2.D2_QUANT,D2.D2_CLIENTE,D2.D2_LOJA,B1.B1_PESO,B1.B1_POSIPI,C5.C5_PESOL,C5.C5_PBRUTO,C5.C5_VOLUME1,C6.C6_DESCRI,"
cQuery := cQuery + "D2.D2_SERIE,D2.D2_ITEM,D2.D2_TOTAL,D2.D2_TES,D2.D2_CF,D2.D2_VALICM,D2.D2_VALIPI,D2.D2_UM,D2.D2_IPI,D2.D2_PRCVEN,D2.D2_PICM,D2.D2_BASEICM,D2.D2_DESC,D2.D2_DESCON,"
cQuery := cQuery + "A7.A7_CLIENTE,A7.A7_LOJA,A7.A7_PRODUTO,A7.A7_PCCLI,A7.A7_CODCLI"
cQuery := cQuery + " FROM " +  RetSqlName( 'SD2' ) +" D2, " +  RetSqlName( 'SC5' ) +" C5, "+ RetSqlName( 'SC6' ) +" C6, "+ RetSqlName( 'SB1' ) +" B1, " + RetSqlName( 'SA7' ) +" A7 "
cQuery := cQuery + " WHERE D2.D2_FILIAL = '" + xFilial('SD2')+ "' AND C5.C5_FILIAL = '" + xFilial('SC5')+ "' AND B1.B1_FILIAL = '" + xFilial('SB1')+ "' AND C6.C6_FILIAL = '" + xFilial('SC6')+ "' AND A7.A7_FILIAL = '" + xFilial('SA7')+ "'"
cQuery := cQuery + " AND D2.D2_DOC IN (" + left(vNotas,len(vNotas)-1) + ") AND D2.D2_SERIE = '"+vSerie + "' "
cQuery := cQuery + " AND D2.D2_CLIENTE = '" + Substr(_cCli,1,6) + "' AND D2.D2_LOJA = '" + Substr(_cCli,8,2) + "' "
cQuery := cQuery + " AND C5.C5_NOTA = D2.D2_DOC AND C5.C5_SERIE = D2.D2_SERIE AND D2.D2_TES IN ('542','503','573','613','605','576','526')"
cQuery := cQuery + " AND C6.C6_NOTA = D2.D2_DOC AND C6.C6_SERIE = D2.D2_SERIE"
cQuery := cQuery + " AND D2.D2_CLIENTE = A7.A7_CLIENTE AND D2.D2_LOJA = A7.A7_LOJA"
cQuery := cQuery + " AND B1.B1_COD = D2.D2_COD AND A7.A7_PRODUTO = D2.D2_COD"
cQuery := cQuery + " AND C6.C6_PRODUTO = D2.D2_COD AND D2.D2_COD NOT LIKE 'E%' "
cQuery := cQuery + " AND C6.C6_ITEM = D2.D2_ITEMPV"
cQuery := cQuery + " AND D2. D_E_L_E_T_ = ' ' AND C5. D_E_L_E_T_ = ' ' AND C6. D_E_L_E_T_ = ' ' AND B1. D_E_L_E_T_ = ' ' AND A7. D_E_L_E_T_ = ' '"
cQuery := cQuery + " ORDER BY D2.D2_DOC ASC"
TCQUERY cQuery NEW ALIAS "TRA1"
MemoWrit('C:\TEMP\NHEST021GM.SQL',cQuery)
DbSelectArea("TRA1")

U_CriaDBFG()  // Cria arquivos temporarios de aviso de embarque para GM

TRA1->(DBGotop())
If Empty(TRA1->D2_DOC)
	
	Aviso("ASN - General Motors | Atenção","Não foi encontrado nenhuma nota fiscal neste periodo.", {"OK"},2)
	FClose(cARQ)
	fErase(cArQEXP)       // Deleta arquivo de dados pois não foi selecionado nenhuma nota
	TRA1->(DbCloseArea())
	XDBF->(DbCloseArea())
	ITP->(DbCloseArea())
	GM1->(DbCloseArea())
	GM2->(DbCloseArea())
	AE1->(DbCloseArea())
	AE2->(DbCloseArea())
	GM3->(DbCloseArea())
	AE3->(DbCloseArea())
	FTP->(DbCloseArea())
	
	Return
	
Endif

ProcRegua(TRA1->(RecCount()))

TRA1->(DbGoTop())

While !TRA1->(eof())
	
	IncProc("Gerando Aviso de Embarque ")
	
	_nx := Ascan(_aGMs, {|x| x[1]+x[2]+x[3]+x[4]+x[5] == TRA1->D2_DOC+TRA1->D2_SERIE+TRA1->D2_CLIENTE+TRA1->D2_LOJA+TRA1->D2_COD})
	
	If _nx <> 0
		_aGMs[_nx][08]:= _aGMs[_nx][08] + TRA1->D2_TOTAL
		_aGMs[_nx][10]:= _aGMs[_nx][10] + TRA1->D2_VALICM
		_aGMs[_nx][12]:= _aGMs[_nx][12] + TRA1->D2_VALIPI
		_aGMs[_nx][15]:= _aGMs[_nx][15] + TRA1->D2_QUANT
		_aGMs[_nx][20]:= _aGMs[_nx][20] + TRA1->D2_DESC
		_aGMs[_nx][21]:= _aGMs[_nx][21] + TRA1->D2_DESCON
		_aGMs[_nx][23]:= _aGMs[_nx][23] + TRA1->D2_BASEICM
	Else
		Aadd(_aGMs,{TRA1->D2_DOC,;
		TRA1->D2_SERIE,;
		TRA1->D2_CLIENTE,;
		TRA1->D2_LOJA,;
		TRA1->D2_COD,;
		TRA1->D2_EMISSAO,;
		TRA1->D2_ITEM,;
		TRA1->D2_TOTAL,;
		TRA1->D2_CF,;
		TRA1->D2_VALICM,;
		TRA1->D2_TES,;
		TRA1->D2_VALIPI,;
		TRA1->A7_CODCLI,;
		TRA1->A7_PCCLI,;
		TRA1->D2_QUANT,;
		TRA1->D2_UM,;
		TRA1->B1_POSIPI,;
		TRA1->D2_IPI,;
		TRA1->D2_PRCVEN,;
		TRA1->D2_DESC,;
		TRA1->D2_DESCON,;
		TRA1->D2_PICM,;
		TRA1->D2_BASEICM,;
		TRA1->C5_PBRUTO,;
		TRA1->C5_PESOL})
	Endif
	
	TRA1->(DbSkip())
	
EndDo

nFTP  := 1
_lEmb := .F. //verifica se gerou o aviso de embarque
_cDoc := Space(06)

For _nx:= 1 to len(_aGMs)
	
	_lEmb := .T. //verifica se gerou o aviso de embarque
	_cCam     := "GM"+Subs(Dtos(dDatabase),7,2)+aMes[(Month(dDatabase))]+StrZero(_nx,3)+".TXT"
	cARQEXP:= _cEDI + _cCam
	nFTP   := 0
	
	While File(cARQEXP)
		_cCam     := "GM"+Subs(Dtos(dDatabase),7,2)+aMes[(Month(dDatabase))]+StrZero(_nx+_nCont,3)+".TXT"
		cARQEXP := _cEDI + _cCam
		_nCont++
	Enddo
	
	cARQ   := FCreate(cARQEXP)
	
	// VERIFICA DOCA -----------
	
	IF SM0->M0_CODIGO == "NH"  //empresa Usinagem
		If _ctipo  == 3
			_cCliente:= "900004"
			_cLoja   := "02"
			_cPlanta := "Sao Jose dos Campos"
			_cFabri  := "4J "
			_cCGC    := "59275792000150"
			_cDoca 	 := "D50"
		EndIf
	ElseIF SM0->M0_CODIGO == "FN"  //empresa Fundicao
		
		If _ctipo  == 1  // Sao Jose dos Campos e Sorocaba
			
			SA7->(DbSetOrder(1))  //filial+cliente+loja+produto
			
			IF SA7->(DbSeek(xFilial("SA7")+Substr(_cCli,1,6)+Substr(_cCli,8,2)+_aGMs[_nx][5]))
				IF SA7->A7_DOCA == "D30 " // Sao Jose dos Campos
					_cCliente:= "900024"
					_cLoja   := "02"
					_cPlanta := "Sao Jose dos Campos"
					_cFabri  := "4J "
					_cCGC    := "59275792000150"
					_cDoca 	 := "D30"
				ELSEIF SA7->A7_DOCA == "A215" // Sorocaba
					_cCliente:= "900024"
					_cLoja   := "02"
					_cPlanta := "Sorocaba"
					_cFabri  := "09 "
					_cCGC    := "59275792008991"
					_cDoca 	 := "A215"
				ELSEIF SA7->A7_DOCA == "D45 " // Sao Jose dos Campos
					_cCliente:= "900024"
					_cLoja   := "02"
					_cPlanta := "Sao Jose dos Campos"
					_cFabri  := "4J "
					_cCGC    := "59275792000150"
					_cDoca 	 := "D45"
				ELSEIF SA7->A7_DOCA == "D40 " // Sao Jose dos Campos
					_cCliente:= "900024"
					_cLoja   := "02"
					_cPlanta := "Sao Jose dos Campos"
					_cFabri  := "4J "
					_cCGC    := "59275792000150"
					_cDoca 	 := "D40"
				ELSE
					alert('Favor gerar o ASN manualmente, pois o campo DOCA desse produto está em branco (Produto x Cliente)')
					return
				ENDIF
			ELSE
				return
			ENDIF
			
		Elseif _ctipo == 2 // Joinvile
			_cCliente:= "900024"
			_cLoja   := "07"
			_cPlanta := "Joinville"
			_cFabri  := "HB "
			_cCGC    := "59275792002012"
			_cDoca 	 := "JV1 "
		Endif
	Endif
	
	// Gravação do Segmento do ITP
	fWrite(cArq,(ITP->(IdentSeg+NumComu+NumVer+NumCont+IdentGer+IdentTra+_cCGC+CodIntTr+CodIntRe+NomTrans+NomRece+Espaco)+cNovaLinha))
	nFtp += 1
	
	/* Gravação do Segmento GM1 */
	RecLock("GM1",.T.)
	GM1->IdentSeg  := "GM1"
	//GM1->NumAsn    := StrZero(Val(Subs(_aGMs[_nx][1],4,6)),6) + StrZero(Val(Subs(_aGMs[_nx][2],1,2)),1) // Número do ASN
	//GM1->NumAsn    := StrZero(Val(Subs(_aGMs[_nx][1],4,6)),6) + StrZero(Val(Subs(_aGMs[_nx][2],1,3)),3) // Número do ASN
	GM1->NumAsn    := StrZero(Val(Subs(_aGMs[_nx][1],4,6)),6) + Subs(_aGMs[_nx][2],1,3)                   // Número do ASN
	GM1->FuncMen   := "9" 				  					                    	    	                                // Função da Mensagem
	GM1->PeBru 	   := StrZero(_aGMs[_nx][24],12)   					        	                                    // Peso Bruto
	GM1->UnMePeBr  := _aGMs[_nx][16]	                									                                  // Unidade de Medida Peso Bruto
	GM1->PeLi 	   := StrZero(_aGMs[_nx][25],12)                                                          // Peso Líquido
	GM1->UnMePeLi  := _aGMs[_nx][16]                  			    		                                      // Unidade de Medida Peso líquido
	GM1->TotEmb    := StrZero(_aGMs[_nx][15],9)     					    		                                    // Qtde total do embarque
	//GM1->NumTrans  := StrZero(Val(Subs(_aGMs[_nx][1],4,6)),6) + StrZero(Val(Subs(_aGMs[_nx][2],1,2)),1) // Número da Transportador
	//GM1->NumTrans  := StrZero(Val(Subs(_aGMs[_nx][1],4,6)),6) + StrZero(Val(Subs(_aGMs[_nx][2],1,3)),3)   // Número da Transportador
	GM1->NumTrans  := StrZero(Val(Subs(_aGMs[_nx][1],4,6)),6) + Subs(_aGMs[_nx][2],1,3)                   // Número da Transportador
	GM1->UnMeQem   := _aGMs[_nx][16]                   						                                        // Unidade de Medida da quantidade embarcada
	GM1->Esp 	   := Space(58)
	MsUnlock("BGM")
	
	fWrite(cArq,(GM1->(IdentSeg+NumAsn+FuncMen+PeBru+UnMePeBr+PeLi+UnMePeLi+TotEmb+NumTrans+UnMeQem+Esp)+cNovaLinha))
	nFtp += 1
	
	/* Gravação do Segmento GM1 */
	RecLock("GM2",.T.)
	GM2->IdentSeg  	:= "GM2"
	GM2->QualEqui 	:= "TE"
	GM2->IdentEquip := "RODOVIARIO"
	GM2->Esp 		:= space(105)
	MsUnlock("GM2")
	
	fWrite(cArq,(GM2->(IdentSeg+QualEqui+IdentEquip+Esp)+cNovaLinha))
	nFtp += 1
	
	// Segmento AE1v0 - Complemento Dados da NF
	_cNotas := ALLTRIM(_cNotas) +" "+ _aGMs[_nx] [1] + CRLF                // documento
	_cNotasP := ALLTRIM(_cNotasP) +" "+ _aGMs[_nx] [1] + " - General Motors " + _cPlanta + " - Doca: " + _cDoca + CRLF      // NF do corpo do e-mail
	
	If _cDoc <> _aGMs[_nx][1]                                              // Para não gerar o Segmento AE1 quando for a mesma nota fiscal
		
		RecLock("AE1",.T.)
		AE1->IdentSeg   := "AE1"
		AE1->NumNF      := Subs(_aGMs[_nx][1],4,6)
		//AE1->SerNF      := Subs(_aGMs[_nx][2],1,2)
		AE1->SerNF      := Subs(_aGMs[_nx][2],1,3)
		AE1->DataNF     := Subs(_aGMs[_nx][6],3,6)
		AE1->QItNf      := StrZero(Val(_aGMs[_nx][7]),3)
		
		AE1->VlToNF     := StrZero(_aGMs[_nx][8],17,2)
		AE1->VlToNF     := Stuff(AE1->VlToNF,AT(".",AE1->VlToNF),1,"")     // elimina o ponto
		AE1->VlToNF     := Stuff(AE1->VlToNF,1,0,"0")                      // Insere o primeiro caracter
		
		AE1->QCDec      := "0"                                             // QTDE de casas decimais
		AE1->CFO        := _aGMs[_nx][9]                                   // Alterado D2_CF
		AE1->VlToICM    := StrZero(_aGMs[_nx][10],17,2)
		AE1->VlToICM    := Stuff(AE1->VlToICM,AT(".",AE1->VlToICM),1,"")   // elimina o ponto
		AE1->VlToICM    := Stuff(AE1->VlToICM,1,0,"0")                     // Insere o primeiro caracter
		AE1->DataVen    := Subs(Dtos(dDatabase+7),3,6)
		AE1->EspNF      := iif(Alltrim(_aGMs[_nx][11]) == "613","02","00")
		AE1->VlIPI      := StrZero(_aGMs[_nx][12],17,2)
		AE1->VlIPI      := Stuff(AE1->VlIPI,AT(".",AE1->VlIPI),1,"")       // elimina o ponto
		AE1->VlIPI      := Stuff(AE1->VlIPI,1,0,"0")                       // Insere o primeiro caracter
		AE1->CodFabEn   := _cFabri
		
		If     _aGMs[_nx][3]+_aGMs[_nx][4] == "90000402"
		ElseIf _aGMs[_nx][3]+_aGMs[_nx][4] == "90002402"
		ElseIf _aGMs[_nx][3]+_aGMs[_nx][4] == "90002403"
		ElseIf _aGMs[_nx][3]+_aGMs[_nx][4] == "90002407"
		Else
			
			Aviso("ASN - General Motors | Atenção","Foi Selecionada uma Nota Fiscal que nao e da GM, Favor Rodar Novamente o Aviso de Embarque.", {"OK"},2)
			nFTP := 0
			exit                                                           // forca a saida do programa
			
		Endif
		
		AE1->DataPrNF   := iif((Val(Time())+14) > 24,Subs(Dtos(dDatabase+1),3,6),Subs(Dtos(dDatabase),3,6)) // verificar
		AE1->IdentPer   := "0000"
		AE1->DescCfop   := Space(20)
		AE1->Espaco     := Space(10)
		MsUnlock("AE1")
		
		FWrite(cArq,(AE1->(IdentSeg+NumNF+SerNF+DataNF+QItNf+VlToNF+QCDec+CFO+VlToICM+DataVen+EspNF+VlIPI+CodFabEn+DataPrNF+IdentPer+Espaco)+cNovaLinha))
		nFTP += 1  //Controle de qtde de segmentos
		
	Endif
	
	_cDoc := _aGMs[_nx][1]                                              // armazena a NF para controle do Segmento AE1 nao gerar repetido no arquivo EDI
	
	// Retira os espacos do codigo do produto
	cCod := _aGMs[_nx][13]                                              //Codigo da amarracao prod x cliente
	nAux := AT(" ",cCod)
	
	While nAux <> 0
		
		cCod := Stuff(cCod,nAux,1,"")
		nAux := AT(" ",cCod)
		
	Enddo
	
	// Segmento AE2v0 - Dados do Item
	Reclock("AE2",.T.)
	AE2->IdentSeg    := "AE2"
	AE2->NumItNF     := StrZero(Val(_aGMs[_nx][7]),3)
	AE2->NumPed      := _aGMs[_nx][14]
	
	AE2->CodItem     := Alltrim(cCod)
	
	AE2->QINF        := StrZero(_aGMs[_nx][15],9,0)
	AE2->UnMedNF     := _aGMs[_nx][16]
	AE2->CodClasF    := _aGMs[_nx][17]
	
	cIPI             := StrZero(_aGMs[_nx][18],5,2)
	AE2->AliIPI      := Stuff(cIPI,AT(".",cIPI),1,"")                   //elimina o ponto
	
	AE2->VlItem      := StrZero(_aGMs[_nx][19],17,2)                    //preco unitario
	AE2->VlItem      := Stuff(AE2->VlItem,AT(".",AE2->VlItem),1,"")     //elimina o ponto
	AE2->VlItem      := Stuff(AE2->VlItem,1,0,"0")                      // Insere o primeiro caracter
	
	AE2->QItEst      := StrZero(_aGMs[_nx][15],9,0)
	
	AE2->UnMedEs     := _aGMs[_nx][16]
	AE2->QtUniCom    := StrZero(_aGMs[_nx][15],9,0)
	AE2->UnMedCo     := _aGMs[_nx][16]
	AE2->CodTpFo     := "P"                                             // P= Producao
	
	cDesc             := StrZero(_aGMs[_nx][20],5,2)
	AE2->QtPerDe     := Stuff(cDesc,AT(".",cDesc),1,"")                 //elimina o ponto
	
	AE2->VlToDes     := StrZero(_aGMs[_nx][21],17,2)
	AE2->VlToDes     := Stuff(AE2->VlToDes,AT(".",AE2->VlToDes),1,"")   //elimina o ponto
	AE2->VlToDes     := Stuff(AE2->VlToDes,1,0,"0")                     // Insere o primeiro caracter
	AE2->Espaco      := Space(01)
	
	MsUnlock("AE2")
	
	FWrite(cArq,(AE2->(IdentSeg+NumItNF+NumPed+CodItem+QINF+UnMedNF+CodClasF+AliIPI+VlItem+QItEst+UnMedEs+QtUniCom+UnMedCo+CodTpFo+QtPerDe+VlToDes+Espaco)+cNovaLinha))
	nFTP += 1                                                           //Controle de qtde de segmentos
	
	// Segmento GM3v0 - Dados Adicionais do Item GM
	RecLock("GM3",.T.)
	GM3->IdentSeg:= "GM3"
	GM3->UnAcu   := "UN "
	GM3->QtdeEmb := StrZero(_aGMs[_nx][15],12)
	GM3->AnoReg  := Subs(Dtos(dDatabase),1,4)                           //Str(Year(Database))
	GM3->Espaco  := Space(106)
	MsUnlock("GM3")
	
	FWrite(cArq,(GM3->(IdentSeg+UnAcu+QtdeEmb+AnoReg+Espaco)+cNovaLinha))
	nFTP += 1                                                           //Controle de qtde de segmentos
	
	// Segmento AE3v0 - Dados Adicionais de Comercial
	RecLock("AE3",.T.)
	AE3->IdentSeg := "AE3"
	AE3->IdentFat := Repl("0",14)
	AE3->IdentCob := Repl("0",14)
	AE3->IdentEnt := _cDoca //Space(14)
	AE3->TipTrans := "RODO"
	AE3->Espaco   := Space(79)
	MsUnlock("AE3")
	
	FWrite(cArq,(AE3->(IdentSeg+IdentFat+IdentCob+IdentEnt+TipTrans+Espaco)+cNovaLinha))
	nFTP += 1                                                           //Controle de qtde de segmentos
	
	RecLock("FTP",.T.)
	FTP->IdentSeg := "FTP"
	FTP->NumCont  := "00000"
	FTP->QtdeSeg  :=StrZero(nFTP,9)
	FTP->NumToVl  :="00000000000000000"
	FTP->CatOper  := Space(01)
	FTP->Espaco   := Space(93)
	MsUnlock("FTP")
	
	FWrite(cArq,(FTP->(IdentSeg+NumCont+QtdeSeg+NumToVl+CatOper+ Espaco)+cNovaLinha))
	FClose(cArq)
	
Next _nx

If nFTP > 1
	
	Aviso("ASN - General Motors | Atenção","Aviso(s) de embarque(s) gerado(s) com sucesso."+CRLF+CRLF+;
	"Total de Arquivos Processados: "+StrZero(_nx-1,3), {"OK"},2)
	
Else
	
	FClose(cARQ)
	fErase(cArQEXP)                                                     // Deleta arquivo de dados pois não foi selecionado nenhuma nota
	
Endif

TRA1->(DbCloseArea())
ITP->( DbCloseArea())
XDBF->(DbCloseArea())
GM1->(DbCloseArea())
GM2->(DbCloseArea())
AE1->(DbCloseArea())
AE2->(DbCloseArea())
GM3->(DbCloseArea())
AE3->(DbCloseArea())
FTP->(DbCloseArea())

If _lEmb //verifica se gerou o aviso de embarque
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
	
	cMsg += '<html>' + CRLF
	cMsg += '<head>' + CRLF
	cMsg += '<title> Aviso de Embarque Automatico p/ General Motors </title>' + CRLF
	cMsg += '</head>' + CRLF
	cMsg += ' <P><IMG SRC="WHBL.BMP" ALIGN=BOTTOM><b><font size="5" face="Times New Roman">'+CRLF+'          Aviso de Embarque</font></b></P>'+ CRLF
	cMsg += '<b><font size="3" face="Arial"> Email Enviado Atraves do Sistema Protheus</font></b>' + CRLF+CRLF
	cMsg += '<font size="2" face="Arial">Aviso de Embarque Automatico Enviado para General Motors as '+time() +' na data: '+Dtoc(ddatabase)+'</font>' + CRLF
	cMsg += CRLF
	cMsg += '<font size="2" face="Arial"> Notas enviadas  '+CRLF
	cMsg += _cNotasP+'</font>' + CRLF
	cMsg += CRLF
	cMsg += CRLF
	cMsg += '<font size="2" face="Arial"> Aviso de Embarque Automatico Gerado Por '+_cNome+'</font>' + CRLF
	cMsg += '</body>' + CRLF
	cMsg += '</html>' + CRLF
	
	IF SM0->M0_CODIGO == "NH"  //empresa Usinagem
		
		a_email := 'lista-fiscal@whbbrasil.com.br;'
		a_email += 'douglassd@whbbrasil.com.br;'
		a_email += 'edenilsonas@whbbrasil.com.br'
		
	ElseIF SM0->M0_CODIGO == "FN"  //empresa Fundicao
		
		a_email := 'lista-fiscal@whbbrasil.com.br;'
		a_email += 'douglassd@whbbrasil.com.br;'
		a_email += 'edenilsonas@whbbrasil.com.br;'
		
		// Se Pernambuco
		If SM0->M0_CODFIL == '02'       
			a_email += 'hesslerr@whbbrasil.com.br'						
		EndIF
		
	Endif
	
	_aFile := { "\System\WHBL.BMP" }
	
	If lConectou
		
		Send Mail from 'protheus@whbbrasil.com.br' To a_email;
		SUBJECT '*** AVISO DE EMBARQUE AUTOMATICO PARA GENERAL MOTORS ***';
		BODY cMsg;
		ATTACHMENT _aFile[1];
		RESULT lEnviado
		
		If !lEnviado
			
			Get mail error cMensagem
			Alert(cMensagem)
			
		EndIf
		
	else
		Alert("Erro ao se conectar no servidor: " + cServer)
		
	Endif
	
Endif

If File(cARQEXP)
	FClose(cARQ)
	if !_lEmb
		fErase(cArQEXP)  // Deleta arquivo de dados pois não foi selecionado nenhuma nota
	Endif
Endif

return

//********************************************************************************************************
//************************************** ASN VW **********************************************************
//********************************************************************************************************

Static Function AsnVW(vNotas,vSerie)
SetPrvt("_cArqDbf, cQuery,_aFields,aCampos,cMarca,cNovaLinha,cARQEXP ,cARQ,nPbruto,x ")
SetPrvt("_cArqITP,_cArqAE1,_cArqNF2,_cArqAE2,_cArqAE4,_cArqAE3,_cArqTE1,_cArqFTP,cDtaHor ")
SetPrvt("_aITP,_aAE1,_aNF2,_caAE2,_aAE4,_aAE3,_aFTP,_aTE1, _aDBF,nAux,cCod,nFTP,cIPI,cICM,cDesc")
SetPrvt("aRotina,cCadastro,_cCliente,_cLoja,_cPlanta,_cCGC,_cNotas,_clEmb,a_email,cPerg,_aVolks")
SetPrvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cNome,_aFile,_cEdi,_cCam,_cDoc")

cServer	  := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.4"
cAccount  := Alltrim(GETMV("MV_RELACNT")) //'protheus'
cPassword := Alltrim(GETMV("MV_RELPSW"))  //'siga'
lConectou
lEnviado
cMensagem := 'Erro ao se conectar no servidor: '
CRLF := chr(13)+chr(10)   // PULA LINHA
cMSG := ""
cPerg   := "ETQ   "
_lEmb   := .F. //verifica se gerou o aviso de embarque
nPbruto :=  0
nFTP    := 0
_cArqDBF:=SPACE(12)
_cArqFTP:=SPACE(12)
_cArqITP:=SPACE(12)
_cArqAE1:=SPACE(12)
_cArqNF2:=SPACE(12)
_cArqAE2:=SPACE(12)
_cArqAE4:=SPACE(12)
_cArqAE3:=SPACE(12)
_cArqTE1:=SPACE(12)
_cNotas :=SPACE(200)
_cNome  := UsrFullName(__cUserID)
_aFile  := {}
_aVolks := {}

cNovaLinha := Chr(13) + Chr(10)

//cARQEXP  := "V:\VOLKS\OUT\VLK"+Subs(Dtos(dDatabase),7,2)+Subs(Dtos(dDatabase),5,2)+"1.TXT"
_cEdi      := Alltrim(GETMV("MV_EDI")) //caminho para envio do EDI   // "V:\mdicom\Parceiro\WHBCOMP\Out\"
_cCam      := "VLK"+Subs(Dtos(dDatabase),7,2)+Subs(Dtos(dDatabase),5,2)+"1.TXT"
cARQEXP    := _cEDI + _cCam

While File(cARQEXP)
	_cCam   := SUBS(_cCam,1,7) +  StrZero(Val(SUBS(_cCam,8,1))+1,1)+".TXT"
	cARQEXP := _cEDI + _cCam
Enddo

cARQ := FCreate(cARQEXP)

If File( _cArqDBF )
	fErase(_cArqDBF)  // Deleta arquivo de dados temporario
	fErase(_cArqITP)
	fErase(_cArqAE1)
	fErase(_cArqAE2)
	fErase(_cArqAE3)
	fErase(_cArqAE4)
	fErase(_cArqTE1)
	fErase(_cArqNF2)
	fErase(_cArqFTP)
Endif

// Gerando
IF SM0->M0_CODIGO == "NH"  //empresa Usinagem
	If Substr(_cCli,1,6) == "900001" .AND. Substr(_cCli,8,2) == "03"  // Sao carlos
		_cCliente := "900001"
		_cLoja    := "03"
		_cPlanta  := " Sao carlos"
		_cCGC     := "59104422009882"
	Elseif Substr(_cCli,1,6) == "900001" .AND. Substr(_cCli,8,2) == "02"  // Taubate
		_cCliente := "900001"
		_cLoja    := "02"
		_cPlanta  := " Taubate"
		_cCGC     := "59104422002446"
	Elseif Substr(_cCli,1,6) == "900002" .AND. Substr(_cCli,8,2) == "01"  // AUDI
		_cCliente := "900002"
		_cLoja    := "01"
		_cPlanta  := " AUDI"
		_cCGC     := "59104422010384"
	Elseif Substr(_cCli,1,6) == "900001" .AND. Substr(_cCli,8,2) == "01"  // Sao Bernardo
		_cCliente := "900001"
		_cLoja    := "01"
		_cPlanta  := " Sao Bernardo"
		_cCGC     := "59104422005704"
	Endif
	
ElseIF SM0->M0_CODIGO == "FN"  //empresa Fundicao
	
	If Substr(_cCli,1,6) == "000012" .AND. Substr(_cCli,8,2) == "01"  // Sao Bernardo
		_cCliente := "000012"
		_cLoja    := "01"
		_cPlanta  := " Sao Bernardo"
		_cCGC     := "59104422005704"
	Elseif Substr(_cCli,1,6) == "000012" .AND. Substr(_cCli,8,2) == "02"  // Sao Carlos
		_cCliente := "000012"
		_cLoja    := "02"
		_cPlanta  := " Sao Carlos"
		_cCGC     := "59104422009882"
	Elseif Substr(_cCli,1,6) == "000012" .AND. Substr(_cCli,8,2) == "03"  // Audi
		_cCliente := "000012"
		_cLoja    := "03"
		_cPlanta  := " AUDI"
		_cCGC     := "59104422010384"
	Elseif Substr(_cCli,1,6) == "000012" .AND. Substr(_cCli,8,2) == "04"  // Taubate
		_cCliente := "000012"
		_cLoja    := "04"
		_cPlanta  := " Taubate"
		_cCGC     := "59104422002446"
	Endif
	
Endif

cQuery := "SELECT D2.D2_DOC,D2.D2_COD,D2.D2_EMISSAO,D2.D2_QUANT,D2.D2_CLIENTE,D2.D2_LOJA,B1.B1_PESO,B1.B1_POSIPI,C5.C5_PBRUTO,C5.C5_VOLUME1,C6.C6_DESCRI,"
cQuery := cQuery + "D2.D2_SERIE,D2.D2_ITEM,D2.D2_TOTAL,D2.D2_TES,D2.D2_CF,D2.D2_VALICM,D2.D2_VALIPI,D2.D2_UM,D2.D2_IPI,D2.D2_PRCVEN,D2.D2_PICM,D2.D2_BASEICM,D2.D2_DESC,D2.D2_DESCON,"
cQuery := cQuery + "A7.A7_CLIENTE,A7.A7_LOJA,A7.A7_PRODUTO,A7.A7_PCCLI,A7.A7_CODCLI"
cQuery := cQuery + " FROM " +  RetSqlName( 'SD2' ) +" D2, " +  RetSqlName( 'SC5' ) +" C5, "+ RetSqlName( 'SC6' ) +" C6, "+ RetSqlName( 'SB1' ) +" B1, " + RetSqlName( 'SA7' ) +" A7 "
cQuery := cQuery + " WHERE D2.D2_FILIAL = '" + xFilial('SD2')+ "' AND C5.C5_FILIAL = '" + xFilial('SC5')+ "' AND B1.B1_FILIAL = '" + xFilial('SB1')+ "' AND C6.C6_FILIAL = '" + xFilial('SC6')+ "' AND A7.A7_FILIAL = '" + xFilial('SA7')+ "'"
cQuery := cQuery + " AND D2.D2_DOC IN (" + left(vNotas,len(vNotas)-1) + ") AND D2.D2_SERIE = '"+vSerie + "' "
cQuery := cQuery + " AND D2.D2_CLIENTE = '" + _cCliente + "' AND D2.D2_LOJA = '" + _cLoja + "' "
cQuery := cQuery + " AND C5.C5_NOTA = D2.D2_DOC AND C5.C5_SERIE = D2.D2_SERIE AND D2.D2_TES IN ('542','503','573','579','613','605','576','526','596')"
cQuery := cQuery + " AND C6.C6_NOTA = D2.D2_DOC AND C6.C6_SERIE = D2.D2_SERIE"
cQuery := cQuery + " AND D2.D2_CLIENTE = A7.A7_CLIENTE AND D2.D2_LOJA = A7.A7_LOJA"
cQuery := cQuery + " AND B1.B1_COD = D2.D2_COD AND A7.A7_PRODUTO = D2.D2_COD "
cQuery := cQuery + " AND C6.C6_PRODUTO = D2.D2_COD"
cQuery := cQuery + " AND C6.C6_ITEM = D2.D2_ITEMPV"
cQuery := cQuery + " AND D2. D_E_L_E_T_ = ' ' AND C5. D_E_L_E_T_ = ' ' AND C6. D_E_L_E_T_ = ' ' AND B1. D_E_L_E_T_ = ' ' AND A7. D_E_L_E_T_ = ' '"
cQuery := cQuery + " ORDER BY D2.D2_DOC ASC"
MemoWrit('C:\TEMP\EST021VW.SQL',cQuery)

//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"
DbSelectArea("TMP")

// NHFAT011
U_CriaDBFV()  // Cria arquivos temporarios de aviso de embarque para volks

TMP->(DBGotop())
If Empty(TMP->D2_DOC)
	Alert("Atencao nao foi Selecionada nenhuma Nota Fiscal")
	FClose(cARQ)
	fErase(cArQEXP)  // Deleta arquivo de dados pois não foi selecionado nenhuma nota
	TMP->(DbCloseArea())
	XDBF->(DbCloseArea())
	AE1->(DbCloseArea())
	AE2->(DbCloseArea())
	AE3->(DbCloseArea())
	AE4->(DbCloseArea())
	TE1->(DbCloseArea())
	NF2->(DbCloseArea())
	FTP->(DbCloseArea())
	Return
Endif

ProcRegua(TMP->(RecCount()))

TMP->(DbGoTop())

While !TMP->(eof())
	IncProc("Gerando Aviso de Embarque " + _cPlanta)
	
	_nx := Ascan(_aVolks, {|x| x[1]+x[2]+x[3]+x[4]+x[5] == TMP->D2_DOC+TMP->D2_SERIE+TMP->D2_CLIENTE+TMP->D2_LOJA+TMP->D2_COD})
	
	If _nx <> 0
		_aVolks[_nx][08]:= _aVolks[_nx][08] + TMP->D2_TOTAL
		_aVolks[_nx][10]:= _aVolks[_nx][10] + TMP->D2_VALICM
		_aVolks[_nx][12]:= _aVolks[_nx][12] + TMP->D2_VALIPI
		_aVolks[_nx][15]:= _aVolks[_nx][15] + TMP->D2_QUANT
		_aVolks[_nx][20]:= _aVolks[_nx][20] + TMP->D2_DESC
		_aVolks[_nx][21]:= _aVolks[_nx][21] + TMP->D2_DESCON
		_aVolks[_nx][23]:= _aVolks[_nx][23] + TMP->D2_BASEICM
	Else
		Aadd(_aVolks,{TMP->D2_DOC,TMP->D2_SERIE,TMP->D2_CLIENTE,TMP->D2_LOJA,TMP->D2_COD,TMP->D2_EMISSAO,TMP->D2_ITEM,TMP->D2_TOTAL,TMP->D2_CF,TMP->D2_VALICM,TMP->D2_TES,TMP->D2_VALIPI,;
		TMP->A7_CODCLI,TMP->A7_PCCLI,TMP->D2_QUANT,TMP->D2_UM,TMP->B1_POSIPI,TMP->D2_IPI,TMP->D2_PRCVEN,TMP->D2_DESC,TMP->D2_DESCON,TMP->D2_PICM,TMP->D2_BASEICM})
	Endif
	
	TMP->(DbSkip())
EndDo

nFTP  := 1
_lEmb := .F. // verifica se gerou o aviso de embarque
_cDoc := Space(06)

For _nx:= 1 to len(_aVolks)
	
	//---------------  SEGMENTO AE1v0 - COMPLEMENTO DADOS DA NF
	_lEmb := .T. //	 verifica se gerou o aviso de embarque
	
	_cNotas := ALLTRIM(_cNotas) +" "+ _aVolks[_nx] [1] + CRLF  //documento
	If _cDoc <> _aVolks[_nx][1] // Para não gerar o Segmento AE1 quando for a mesma nota fiscal
		RecLock("AE1",.T.)
		AE1->IdentSeg   := "AE1"
		AE1->NumNF      := Subs(_aVolks[_nx][1],4,6)
		AE1->SerNF      := Subs(_aVolks[_nx][2],1,2)
		AE1->DataNF     := Subs(_aVolks[_nx][6],3,6)
		AE1->QItNf      := StrZero(Val(_aVolks[_nx][7]),3)
		
		AE1->VlToNF     := StrZero(_aVolks[_nx][8],17,2)
		AE1->VlToNF     := Stuff(AE1->VlToNF,AT(".",AE1->VlToNF),1,"") //elimina o ponto
		AE1->VlToNF     := Stuff(AE1->VlToNF,1,0,"0")  // Insere o primeiro caracter
		
		AE1->QCDec      := "0"  // QTDE de casas decimais
		AE1->CFO        := _aVolks[_nx][9]   // Alterado D2_CF
		//	   AE1->VlToICM    := Transform(TMP->D2_VALICM,"@e 99999999999999999.99")
		
		AE1->VlToICM    := StrZero(_aVolks[_nx][10],17,2)
		AE1->VlToICM    := Stuff(AE1->VlToICM,AT(".",AE1->VlToICM),1,"") //elimina o ponto
		AE1->VlToICM    := Stuff(AE1->VlToICM,1,0,"0")  // Insere o primeiro caracter
		
		AE1->DataVen    := Subs(Dtos(dDatabase+7),3,6)
		AE1->EspNF      := Iif(Alltrim(_aVolks[_nx][11]) == "613","02","00")
		
		//  AE1->VlIPI      := Transform(TMP->D2_VALIPI, "@e 99999999999999999.99")
		AE1->VlIPI      := StrZero(_aVolks[_nx][12],17,2)
		AE1->VlIPI      := Stuff(AE1->VlIPI,AT(".",AE1->VlIPI),1,"") //elimina o ponto
		AE1->VlIPI      := Stuff(AE1->VlIPI,1,0,"0")  // Insere o primeiro caracter
		
		// Codigo da fabrica *  011 = Sao Bernardo (anchieta)  013-Taubate  017=Sao Carlos 018-Resende  057-Curitiba
		If _aVolks[_nx][3]+_aVolks[_nx][4] == "90000103" .Or. _aVolks[_nx][3]+_aVolks[_nx][4] == "00001202"// sao carlos
			AE1->CodFabEn   := "017"
		ElseIf _aVolks[_nx][3]+_aVolks[_nx][4] == "90000101" .Or. _aVolks[_nx][3]+_aVolks[_nx][4] == "00001201" // sao bernardo
			AE1->CodFabEn   := "011"
		ElseIf _aVolks[_nx][3]+_aVolks[_nx][4] == "90000201" .Or. _aVolks[_nx][3]+_aVolks[_nx][4] == "00001203" // audi sao jose dos pinhais
			AE1->CodFabEn   := "057"
		ElseIf _aVolks[_nx][3]+_aVolks[_nx][4] == "90000104"  .Or. _aVolks[_nx][3]+_aVolks[_nx][4] == "00001204" // taubate
			AE1->CodFabEn   := "013"
		Else
			Alert("Atencao foi Selecionada uma Nota Fiscal que nao é da VOLKS, Favor Rodar Novamente o Aviso de Embarque")
			nFTP := 0
			exit //forca a saida do programa
		Endif
		
		AE1->DataPrNF   := Iif((Val(Time())+14) > 24,Subs(Dtos(dDatabase+1),3,6),Subs(Dtos(dDatabase),3,6)) // verificar
		AE1->IdentPer   := "0000"
		AE1->IdentFor   := Iif( Subs(_aVolks[_nx][5],1,2)$"EC/EB","REMESSA",Space(15))  //Para os codigo de embalagem colocar REMESSA
		AE1->PlVeiTr    := Space(06)
		AE1->HoEmb      := Space(04)
		AE1->Espaco     := Space(03)
		MsUnlock("AE1")
		
		FWrite(cArq,(AE1->(IdentSeg+NumNF+SerNF+DataNF+QItNf+VlToNF+QCDec+CFO+VlToICM+DataVen+EspNF+VlIPI+CodFabEn+DataPrNF+IdentPer+IdentFor+PlVeiTr+HoEmb+Espaco)+cNovaLinha))
		nFTP += 1  //Controle de qtde de segmentos
	Endif
	_cDoc := _aVolks[_nx][1] // armazena a NF para controle do Segmento AE1 nao gerar repetido no arquivo EDI
	
	//---------------- SEGMENTO AE2v0 - DADOS DO ITEM
	
	// Retira os espacos do codigo do produto
	cCod := _aVolks[_nx][13] //TMP->A7_CODCLI //Codigo da amarracao prod x cliente
	nAux := AT(" ",cCod)
	While nAux <> 0
		
		cCod := Stuff(cCod,nAux,1,"")
		nAux := AT(" ",cCod)
		
	Enddo
	
	Reclock("AE2",.T.)
	AE2->IdentSeg    := "AE2"
	AE2->NumItNF     := StrZero(Val(_aVolks[_nx][7]),3)
	AE2->NumPed      := _aVolks[_nx][14]
	
	// R030103041R deve gerar o aviso de embarque c/ o seguinte código R030 103041 R e não R030 103041R passado pelo Luiz em 09/04/2010
	//												R03   0103041R                330392                        R030   103041R
	If Subs(_aVolks[_nx][5],1,2)$"EC/EB"  //os codigo de embalagem nao tem espaco entre o codigo
		AE2->CodItem     := Alltrim(cCod)
	Else
		AE2->CodItem     := Iif(Alltrim(cCod)=="3055011171USI",Subs(Alltrim(cCod),1,3)+Space(03)+Subs(Alltrim(cCod),4,7)+Space(01)+Subs(Alltrim(cCod),11,10),Iif(Alltrim(cCod)$"R030103041R/R030103021CR",Subs(Alltrim(cCod),1,4)+Space(03)+Subs(Alltrim(cCod),5,6)+Subs(Alltrim(cCod),11,2),Subs(Alltrim(cCod),1,3)+Space(03)+Subs(Alltrim(cCod),4,10)))
	Endif
	
	//	   AE2->CodItem     := Iif(Alltrim(cCod)=="3055011171USI",Subs(Alltrim(cCod),1,3)+Space(03)+Subs(Alltrim(cCod),4,7)+Space(01)+Subs(Alltrim(cCod),11,10),Iif(Alltrim(cCod)=="R030103041R",Subs(Alltrim(cCod),1,4)+Space(03)+Subs(Alltrim(cCod),5,6)+Space(01)+Subs(Alltrim(cCod),11,1),Subs(Alltrim(cCod),1,3)+Space(03)+Subs(Alltrim(cCod),4,10)))
	
	AE2->QINF        := StrZero(_aVolks[_nx][15],9,0)
	//	   AE2->QINF        := Stuff(AE2->QINF,AT(".",AE2->QINF),1,"") //elimina o ponto
	//  	   AE2->QINF        := Stuff(AE2->QINF,1,0,"0")  // Insere o primeiro caracter
	
	AE2->UnMedNF     := _aVolks[_nx][16]
	AE2->CodClasF    := _aVolks[_nx][17] //TMP->B1_POSIPI
	
	cIPI              := StrZero(_aVolks[_nx][18],5,2)
	AE2->AliIPI      := Stuff(cIPI,AT(".",cIPI),1,"") //elimina o ponto
	
	AE2->VlItem      := StrZero(_aVolks[_nx][19],17,2) //preco unitario
	AE2->VlItem      := Stuff(AE2->VlItem,AT(".",AE2->VlItem),1,"") //elimina o ponto
	AE2->VlItem      := Stuff(AE2->VlItem,1,0,"0")  // Insere o primeiro caracter
	
	AE2->QItEst      := StrZero(_aVolks[_nx][15],9,0)
	
	AE2->UnMedEs     := _aVolks[_nx][16] //TMP->D2_UM
	AE2->QtUniCom    := StrZero(_aVolks[_nx][15],9,0)
	AE2->UnMedCo     := _aVolks[_nx][16] //TMP->D2_UM
	AE2->CodTpFo     := "P"  // P= Producao
	//	   AE2->QtPerDe     := Transform(TMP->D2_DESC,"@e 99.99")
	
	cDesc            := StrZero(_aVolks[_nx][20],5,2)
	AE2->QtPerDe     := Stuff(cDesc,AT(".",cDesc),1,"") //elimina o ponto
	//  	   AE2->QtPerDe     := Stuff(AE2->QtPerDe,1,0,"0")  // Insere o primeiro caracter
	
	AE2->VlToDes     := StrZero(_aVolks[_nx][21],17,2)
	AE2->VlToDes     := Stuff(AE2->VlToDes,AT(".",AE2->VlToDes),1,"") //elimina o ponto
	AE2->VlToDes     := Stuff(AE2->VlToDes,1,0,"0")  // Insere o primeiro caracter
	AE2->AlItem      := Space(04)
	AE2->Espaco      := Space(01)
	
	MsUnlock("AE2")
	
	FWrite(cArq,(AE2->(IdentSeg+NumItNF+NumPed+CodItem+QINF+UnMedNF+CodClasF+AliIPI+VlItem+QItEst+UnMedEs+QtUniCom+UnMedCo+CodTpFo+QtPerDe+VlToDes+AlItem+Espaco)+cNovaLinha))
	nFTP += 1  //Controle de qtde de segmentos
	
	
	//-------------  SEGMENTO AE4v3 - DADOS COMPLEMENTARES DO ITEM
	
	RecLock("AE4",.T.)
	AE4->IdentSeg  := "AE4"
	
	cICM           := StrZero(_aVolks[_nx][22],5,2)
	AE4->AlICM     := Stuff(cICM,AT(".",cICM),1,"") //elimina o ponto
	//  	   AE2->QtPerDe     := Stuff(AE2->QtPerDe,1,0,"0")  // Insere o primeiro caracter
	
	AE4->BasICM    := StrZero(_aVolks[_nx][23],17,2)
	AE4->BasICM    := Stuff(AE4->BasICM,AT(".",AE4->BasICM),1,"") //elimina o ponto
	AE4->BasICM    := Stuff(AE4->BasICM,1,0,"0")  // Insere o primeiro caracter
	
	AE4->VlICMAp    := StrZero(_aVolks[_nx][10],17,2)
	AE4->VlICMAp    := Stuff(AE4->VlICMAp,AT(".",AE4->VlICMAp),1,"") //elimina o ponto
	AE4->VlICMAp    := Stuff(AE4->VlICMAp,1,0,"0")  // Insere o primeiro caracter
	
	AE4->VlIPIAp    := StrZero(_aVolks[_nx][12],17,2)
	AE4->VlIPIAp    := Stuff(AE4->VlIPIAp,AT(".",AE4->VlIPIAp),1,"") //elimina o ponto
	AE4->VlIPIAp    := Stuff(AE4->VlIPIAp,1,0,"0")  // Insere o primeiro caracter
	
	AE4->CodSiTr   := "00"
	AE4->NumDesIt  := Space(30)
	AE4->DatValDe  := Space(06)
	
	AE4->PedRev   := Space(13)
	AE4->PesoLiq  := Space(05)
	AE4->MulPreco := Space(01)
	AE4->PrecoTot := Space(12)
	
	MsUnlock("AE4")
	
	FWrite(cArq,(AE4->(IdentSeg+AlICM+BasICM+VlICMAp+VlIPIAp+CodSiTr+NumDesIt+DatValDe+PedRev+PesoLiq+MulPreco+PrecoTot)+cNovaLinha))
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
	
Next _nx

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
	Alert("Atencao nao foi Selecionada nenhuma Nota Fiscal")
	FClose(cARQ)
	fErase(cArQEXP)  // Deleta arquivo de dados pois não foi selecionado nenhuma nota
Endif

TMP->(DbCloseArea())
XDBF->(DbCloseArea())
AE1->(DbCloseArea())
AE2->(DbCloseArea())
AE3->(DbCloseArea())
AE4->(DbCloseArea())
TE1->(DbCloseArea())
NF2->(DbCloseArea())
FTP->(DbCloseArea())

If _lEmb //verifica se gerou o aviso de embarque
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
	
	cMsg += '<html>' + CRLF
	cMsg += '<head>' + CRLF
	cMsg += '<title> E X E M P L O </title>' + CRLF
	cMsg += '</head>' + CRLF
	cMsg += ' <P><IMG SRC="WHBL.BMP" ALIGN=BOTTOM><b><font size="5" face="Times New Roman">'+CRLF+'          Aviso de Embarque Automatico</font></b></P>'+ CRLF
	cMsg += '<b><font size="3" face="Arial"> Email Enviado Atraves do Sistema Protheus</font></b>' + CRLF+CRLF
	cMsg += '<font size="2" face="Arial">Aviso de Embarque Automatico Enviado para VOLKS as '+time() +' na data: '+Dtoc(ddatabase)+'</font>' + CRLF
	cMsg += CRLF
	cMsg += '<font size="2" face="Arial"> Notas enviadas  '+CRLF
	cMsg += _cNotas+'</font>' + CRLF
	cMsg += CRLF
	cMsg += CRLF
	cMsg += '<font size="2" face="Arial"> Aviso de Embarque Automatico Gerado Por '+_cNome+'</font>' + CRLF
	cMsg += '</body>' + CRLF
	cMsg += '</html>' + CRLF
	
	IF SM0->M0_CODIGO == "NH"  //empresa Usinagem
		a_email := 'lista-fiscal@whbbrasil.com.br;'
		a_email += 'HesslerR@whbusinagem.com.br;EloirH@whbbrasil.com.br;oliveira@whbusinagem.com.br;'
		a_email += 'jeova.silva@volkswagen.com.br;claudio.rogerio@volkswagen.com.br;'
	ElseIF SM0->M0_CODIGO == "FN"  //empresa Fundicao
		a_email := 'lista-fiscal@whbbrasil.com.br;'
	Endif
	
	// Retirar depois de pronto ....
	a_email += 'douglassd@whbbrasil.com.br;'
	a_email += 'edenilsonas@whbbrasil.com.br'
	
	_aFile := { "\System\WHBL.BMP" }
	If lConectou
		Send Mail from 'protheus@whbbrasil.com.br' To a_email;
		SUBJECT '***** AVISO DE EMBARQUE AUTOMATICO PARA VOLKS '+Upper(_cPlanta)+' ***** ';
		BODY cMsg;
		ATTACHMENT _aFile[1];
		RESULT lEnviado
		If !lEnviado
			Get mail error cMensagem
			Alert(cMensagem)
		EndIf
	else
		Alert("Erro ao se conectar no servidor: " + cServer)
	Endif
	
Endif

If File(cARQEXP)
	FClose(cARQ)
	if !_lEmb
		fErase(cArQEXP)  // Deleta arquivo de dados pois não foi selecionado nenhuma nota
	Endif
Endif

return       