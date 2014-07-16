/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!                             DADOS DO PROGRAMA                              !
+------------------+---------------------------------------------------------+
!Modulo            ! FIN - Financeiro                                        !
+------------------+---------------------------------------------------------+
!Nome              ! NHEST098.PRW                                            !
+------------------+---------------------------------------------------------+
!Descricao         ! Cadastro de Aprovadores dos d้bitos no sistema          +
+------------------+---------------------------------------------------------+
!Autor             ! Fabio Nico                                              !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 07/10/2005                                              !
+------------------+---------------------------------------------------------+
!   ATUALIZACOES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+
*/
#include "rwmake.ch"                   	
#include "topconn.CH"
#include "colors.ch"
#include "font.ch"  
#include "eec.ch"
#include "ap5mail.ch" 

User Function nhest098()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CRIACAO DE VARIAVEIS ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SetPrvt("cQuery,_aFields,aCampos,cMarca,cARQEXP ,cARQ,_auxdoc,_auxforno")   
SetPrvt("nMax,aCols,oMultiline,oDialog,nI,_cForno,_cLiga,lMsErroAuto,_TOTLIN")
SetPrvt("aMatriz,_Insere,_qtde,_SolNor,_lPar")
SetPrvt("CCADASTRO,AROTINA,_aCabec,_soma,TOT_HORAS,_aComba1,_cTipo,_dDtDeb,cNFOri")

aCols    	:= {}
aTotal 	 	:= {}
_Insere 	:= 0                                   
_soma 		:= 0
_aCabec  	:= {}
_cTipo    	:= Space(02)
_cAcao  	:= Space(100)
_cFil		:= ""
cNFOri      := ""
_dDtDeb     := Ctod("//")

DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
DEFINE FONT oBol16 NAME "Arial" SIZE 0, -16 BOLD

TOT_HORAS	:= 0     //  TOTAL DE MINUTOS UTILIZADOS -  GRAVA NO SD4
Private nOpc   := 0
Private bOk    := {||nOpc:=1,_SolNor:End()}
Private bCancel:= {||nOpc:=0,_SolNor:End()}

cCadastro := OemToAnsi("Controle de Debitos ")
aRotina := {{ "Pesquisa"	 ,'AxPesqui     ',0,1},;
            { "Visualizar"	 ,'AxVisual'	  ,0,2},;
            { "Analisar"	 ,'U_Result1()'  ,0,2},;
            { "Aprovar"	    ,'U_Aprova1()'  ,0,3},;
            { "Alterar"     ,'U_EST98ALT()' ,0,4},;
            { "Classificar" ,'U_EST98STS()' ,0,4},;
            { "Relatorio"   ,'U_Relato1()'  ,0,3},;
            { "Responsแveis",'U_NHEST146()' ,0,3},;
            { "Legenda" 	 ,'U_FLegOrd2()' ,0,4}}
DbSelectArea("ZA8")

SA2->(DbSetOrder(1)) //FILIAL + COD + LOJA
ZA8->(DbGotop())

//Filtra o browse de acordo com o grupo de quem acessa a rotina
DbSelectArea("ZAY")
DbSetOrder(2)//Filial + LOGIN
If DbSeek(xFilial("ZAY")+Alltrim(Upper(cUserName)))
	
	WHILE !ZAY->(EOF()) .AND. Alltrim(ZAY->ZAY_LOGIN) == Alltrim(Upper(cUserName))
		_cFil += ALLTRIM(ZAY->ZAY_GRUPO)+"/"
		ZAY->(DBSKIP())
	ENDDO
	DbSelectArea("ZA8")          
	Set Filter To ZA8->ZA8_GRUPO $ _cFil
	
Else
	If !Alltrim(Upper(cUsername))$"JOAOFR/ADMIN/ADMINISTRADOR/EDENILSONAS"
		MsgBox("Usuario sem permissao para acessar esta rotina!","Atencao","ALERT")
		Return .F.
	EndIf
EndIf

mBrowse( 6, 1,22,75, "ZA8" ,,,,,,DebCor())

Return(nil)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ ANALISE DO DEBITO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
User Function Result1()
Local nZA8Rec := ZA8->(RECNO())

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+ZA8->ZA8_CLIENT+ZA8->ZA8_LOJA))
	
	If ZA8->ZA8_PROCED$"P/N"
	   MsgBox( "Item ja Aprovado/Reprovado", "Verificar o STATUS", "ALERT" )
	   Return .F.
	endif
	
	_cDesCli := SA1->A1_NOME
	_aComba1 := {'A'}
	
	DbSelectArea("ZA8")
	
	@ 001,005 TO 395,560 DIALOG oResult TITLE "Resultado de Debitos "                                                
	
	@ 010,010 say "Cliente.........:"  Color CLR_BLUE Size 050,8 object oCliente 
	oCliente:SetFont(oBold)
	@ 025,010 say "Documento..:"  Color CLR_BLUE Size 050,8 object oDocum
	oDocum:SetFont(oBold)
	@ 040,010 SAY "Motivos........:"  Color CLR_BLUE Size 050,8 object oMotivo
	oMotivo:SetFont(oBold)
	
	@ 010,060 say ZA8->ZA8_CLIENT + '-'+_cDesCli object _zClient
	_zClient:SetFont(oBol16)
	@ 025,060 say ZA8->ZA8_DOC object _zDoc
	@ 040,060 SAY ZA8->ZA8_MOT1 object _zMot1
	@ 050,060 SAY ZA8->ZA8_MOT2 object _zMot2
	@ 060,060 SAY ZA8->ZA8_MOT3 object _zMot3
	                                           
	@ 080,010 Say "A็ใo/Resultado da Analise:" Color CLR_BLUE Size 120,8 object oAcao
	oAcao:SetFont(oBold)
	
	_nLinha = MlCount(Lower(Alltrim(ZA8->ZA8_RESULT)))
	for i:= 1 to _nLinha
	    _cAcao +=  OemToAnsi(MemoLine(ZA8->ZA8_RESULT,90,i))
	next i 
	@ 090,010 Get ocAcao VAR _cAcao MEMO Size 260,080 PIXEL OF oDialog
	
	@ 177,210 BMPBUTTON TYPE 01 ACTION fGrvRes()
	@ 177,240 BMPBUTTON TYPE 02 ACTION Close(oResult)
	
	ACTIVATE MsDialog oResult CENTER
	_cAcao := " "

	ZA8->(dbgoto(nZA8Rec))
	
Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGRAVA O RESULTADO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function fGrvRes()

	If empty(_cAcao)
	   MsgBox( "ษ obrigatorio a digitacao da acao!", "Verificar digitacao de campo", "ALERT" )
	   Return .F.
	EndIf
 
	DBSELECTAREA('ZA8')

	RecLock("ZA8",.F.)
		ZA8->ZA8_PROCED		:= 'A'
		ZA8->ZA8_ANALIS     := Alltrim(Upper(cUserName))
		ZA8->ZA8_DTANAL     := Date()
		ZA8->ZA8_RESULT		:= ALLTRIM(_cAcao)
	MsUnLock("ZA8")

	U_fEmailNDC("Analise","1")

	Close(oResult)  

Return                                                    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ ENVIA EMAIL DE DEBITO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
User Function fEmailNDC(cParam)
Local _aGrupo   := {"PCP","QUALIDADE","FISCAL","COMERCIAL"}
Local _cEndArq  := ""
Private cProced := cParam
Private cFornece
Private cLoja
Private cRazao
Private cDoc
Private cSerie
Private cVencto
Private cValBrut
Private cNFOri   := ""
Private _cNivel	 := ""
Private _cStatus := ""
Private _mot1	 := ZA8->ZA8_MOT1
Private _mot2	 := ZA8->ZA8_MOT2
Private _mot3	 := ZA8->ZA8_MOT3
Private cEmpresa := ZA8->ZA8_EMPRES
Private _cLanc   := Subs(EMBARALHA(ZA8->ZA8_USERGI,1),1,AT(" ",EMBARALHA(ZA8->ZA8_USERGI,1)))
Private _cAssunt := ""
Private cTo      := ""	
Private cMsg     := ""
Private _cAprova := "-pendente-"
Private _cAnalis := ""  
    
    If cParam=="Inclusao"
    	cFornece := SF1->F1_FORNECE
    	cLoja    := SF1->F1_LOJA
    	cDoc     := SF1->F1_DOC
    	cSerie   := SF1->F1_SERIE
    	cVencto  := DtoC(SE1->E1_VENCREA)
    	_cAnalis := "-pendente-"
    	_cGrupo  := ZA8->ZA8_GRUPO
      	_dDtDeb  := SF1->F1_EMISSAO
    	cValBrut := "R$ " +Transform(ZA8->ZA8_VALOR,"@e 999,999,999.99")
    ElseIf cParam$"Analise/Aprovacao/Estorno"
	    cFornece := ZA8->ZA8_CLIENT
		cLoja    := ZA8->ZA8_LOJA
		cDoc     := ZA8->ZA8_DOC
		cSerie   := ZA8->ZA8_SERIE
		cVencto  := DTOC(ZA8->ZA8_VENCTO)
    	_cAnalis := ZA8->ZA8_ANALIS
    	_cGrupo  := ZA8->ZA8_GRUPO
    EndIf
    
    If !Empty(ZA8->ZA8_APROVA)
    	_cAprova := Alltrim(ZA8->ZA8_APROVA)
    EndIf

	_cEstorn := "-pendente-"
	If !Empty(ZA8->ZA8_ESTORN)
		_cEstorn := Alltrim(ZA8->ZA8_ESTORN)
	EndIf

    If  cProced$"Aprovacao/Estorno"
	    If ZA8->ZA8_PROCED == 'P'
	    	_cStatus := "PROCEDE"
	    ElseIf ZA8->ZA8_PROCED == 'N'
	     	_cStatus := "NรO PROCEDE"
	    ElseIf ZA8->ZA8_PROCED == 'E'
	    	_cStatus := "ESTORNADO"
	    ElseIf ZA8->ZA8_PROCED == 'R'
	    	_cStatus := "REPASSADO AO CLIENTE"
	    EndIf
	EndIf

	If cProced$"Analise/Aprovacao/Estorno"
		SF1->(dbSetOrder(1)) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
    	SF1->(dbSeek(xFilial("SF1")+cDoc+cSerie+cFornece+cLoja))
    	cValBrut := "R$ "+Transform(SF1->F1_VALBRUT,"@e 999,999,999.99")
      	_dDtDeb := SF1->F1_EMISSAO
    EndIf

   	If SF1->F1_TIPO == 'N'
		SA2->(DBSETORDER(1))
		SA2->(DbSeek(xFilial("SA2") + cFornece + cLoja))
		If SA2->(Found())
			cRazao := SA2->A2_NOME
		Endif
   	Else
		SA1->(DBSETORDER(1))
		SA1->(DbSeek(xFilial("SA1") + cFornece + cLoja))
		If SA1->(Found())
			cRazao := SA1->A1_NOME
		Endif
   	endif                        
 
   	SD1->(DBSETORDER(1))//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
   	IF SD1->(DBSEEK(XFILIAL("SD1")+cDoc+cSerie+cFornece+cLoja))
      	cNFOri  := SD1->D1_NFORI
	ENDIF

	//MENSAGEM
	
	cMsg := '<html>'
	cMsg += '<head>'
   	cMsg += '<title>NOTA FISCAL DE DEBITO</title>'
   	cMsg += '</head>'
   	cMsg += '<body style="font-family:Arial">'
   	cMsg += '<strong>'
    cMsg += '<span style="font-size:20px">Registro de Ocorrencia de Debitos ('+cProced+')</span><br /><br />'
    cMsg += '<span style="font-size:18px">'
    
	_cEndArq := "\\server_whb\usinagem\debitos\"+StrZero(Year(_dDtDeb),4)
			
    IF SM0->M0_CODIGO == "NH" //empresa Usinagem
    	cMsg += 'WHB COMPONENTES'
	   _cEndArq += "\usinagem\"
	    
	ELSEIF SM0->M0_CODIGO == "FN" //empresa FUNDICAO
    	cMsg += 'WHB FUNDICAO'
    	_cEndArq += "\fundicao\"
	ENDIF

	cMsg += '<br /><br />'
	cMsg += 'Grupo: '+_aGrupo[VAL(ZA8->ZA8_GRUPO)]+' </span></strong><br /><br />'
	cMsg += '<span style="font-size:14px">'   
    cMsg += 'Codigo Cliente  : ' + cFornece      + '-' 		+ cLoja + '<br />'
    cMsg += 'Razao Social    : ' + cRazao 	     + '<br />'
    cMsg += 'Nota de Debito  : ' + cDoc 	     + '<br />'
    cMsg += 'Data Entrega    : ' + DtoC(_dDtDeb) + '<br />'
    cMsg += 'Total da NF     : ' + cValBrut      + '<br />'
    cMsg += 'NF Origem       : ' + cNFOri	     + '<br />'
    cMsg += 'Data Vencimento : ' + cVencto       + '<br /><br />'

    cMsg += 'Motivo(s):' + '<br />'
    cMsg += _mot1 + '<br />'
    If !Empty(_mot2)
	    cMsg += _mot2 + '<br />'
	EndIf
	If !Empty(_mot3)
	    cMsg += _mot3 + '<br />'
	EndIF
	
    cMsg += '<br />'

    If cProced$"Analise/Aprovacao/Estorno"
    	
    	cMsg += 'Anแlise :' + '<br />'
    	cMsg += _cAcao + '<br /><br />'
    	
    EndIf
   	
   	If ZA8->ZA8_PROCED=="N"

	   	cMsg += 'DษBITO NรO PROCEDE' + '<br />'
   		cMsg += 'Data do Reembolso: '+DtoC(ZA8->ZA8_DTREEM)+'<br />'
   		cMsg += 'Responsแvel pelo Reembolso: '+ZA8->ZA8_RESPCL+'<br />'
   		cMsg += 'มrea do Cliente: '+ZA8->ZA8_AREACL+'<br /><br />'
   	
   	ElseIf ZA8->ZA8_PROCED=="P"

   		cMsg += 'DษBITO PROCEDE' + '<br /><br />'

   	EndIf
   	
   	cMsg += '*** O DOCUMENTO DE DษBITO ESTม DISPONอVEL EM <a href="'+_cEndArq+'">'+_cEndArq+'</a> ***'
	cMsg += '<br />'
    cMsg += 'Lan็ado Por   : ' + Upper(_cLanc) + '<br />'
    cMsg += 'Analisado Por : ' + _cAnalis      + '<br />'
    cMsg += 'Aprovado Por  : ' + _cAprova      + '<br />'

	If cProced$"Estorno"
		cMsg += 'Estornado Por : ' + _cEstorn + '<br />'
    EndIf

	cMsg += '<br />'
	
	//ASSINATURA
	cMsg += '<table width="100%" cellpadding="0" cellspacing="0" align="center">'
	cMsg += '<tr><td width="100%" align="center">__________________________________</td></tr>'
    
    If ZA8->ZA8_GRUPO=="1"
    	IF SM0->M0_CODIGO == "NH"
	    	cMsg += '<tr><td width="100%" align="center">Ivanildo A. Beneciuti</td></tr>'
	   	ElseIf SM0->M0_CODIGO == "FN"
	   		cMsg += '<tr><td width="100%" align="center">Ivanildo A. Beneciuti / Roderjan Busato</td></tr>'
	   	EndIf
    ELSEIF ZA8->ZA8_GRUPO=="2" //QUALIDADE
	    cMsg += '<tr><td width="100%" align="center">Silvio Sevciuc</td></tr>'
    ELSEIF ZA8->ZA8_GRUPO=="3"
	    cMsg += '<tr><td width="100%" align="center">Hilderley Lopes de Oliveira</td></tr>'
    ELSEIF ZA8->ZA8_GRUPO=="4"
  	    cMsg += '<tr><td width="100%" align="center">Jos้ Kaiser / Murillo Di Cicco</td></tr>'
    ENDIF

	cMsg += '</table>'

	cMsg += '</body>'// + CRLF
	cMsg += '</html>'// + CRLF   
		                  
	DbSelectArea("ZAY")
	DbSetOrder(1)//FILIAL + GRUPO + NIVEL
	QAA->(DbSetOrder(6)) // LOGIN
		
	If cProced$"Aprovacao/Estorno"
		_cNivel := "3"
	ElseIf cProced == "Analise"
		_cNivel := "1"
	EndIf
	
	//DESTINATมRIOS
	
	//NIVEL 1 SOMENTE PARA APROVADORES
	//NIVEL 3 PARA INFORMAวรO DA APROVAวรO
	cTo := ""
	
	//A pedido do setor de qualidade, quando for anแlise e do grupo qualidade
	//Todos os responsaveis deverao receber e-mail
	If Substr(_cGrupo,1,1)=="2" .and. cProced == "Analise" 
	
		cQuery := "SELECT QAA.QAA_EMAIL FROM "
		
		If Subs(cEmpresa,1,1) == "1"
			cQuery += "QAANH0 QAA, ZAYNH0 ZAY " //deve ser fixo
		ElseIf Subs(cEmpresa,1,1) == "2"
			cQuery += "QAAFN0 QAA, ZAYFN0 ZAY " //deve ser fixo
		Else
			cQuery += RetSqlName("QAA")+" QAA, "+RetSqlName("ZAY")+" ZAY "
		EndIf
		
		cQuery += " WHERE QAA.QAA_LOGIN = ZAY.ZAY_LOGIN "
		cQuery += " AND ZAY.ZAY_GRUPO = '"+SUBSTR(_cGrupo,1,1)+"'"
		cQuery += " AND ZAY.D_E_L_E_T_ = ' '"
		cQuery += " AND QAA.D_E_L_E_T_ = ' '"
		cQuery += " GROUP BY QAA.QAA_EMAIL"
		
		TCQUERY cQuery NEW ALIAS "TRA1"
			
		TRA1->(DBGOTOP())
		While TRA1->(!EOF()) //ZAY->ZAY_GRUPO == SUBSTR(_cGrupo,1,1)
				If !Empty(TRA1->QAA_EMAIL)
					cTo += ALLTRIM(TRA1->QAA_EMAIL) + ';'
				EndIf
			TRA1->(DbSkip())
		EndDo
		
		TRA1->(DbCloseArea())
	Else

		cTo := "adayaber@whbbrasil.com.br;dayanacs@whbusinagem.com.br;thiagosi@whbbrasil.com.br"
			
		//se o usuแrio logado for o LucasP, ou o lan็amento for feito por LucasP envia para ele a pedido da OS: 003569
		If "LUCASP"$AllTrim(Upper(cUserName)) .OR. ;
	       "LUCASP"$AllTrim(Upper(_cLanc))
	
			cTo += "lucaspc@whbbrasil.com.br;"
		EndIf
				
	EndIF
	
	// ASSUNTO
    IF SM0->M0_CODIGO == "NH"  //empresa Usinagem
	    _cAssunt := " *** AVISO DE DษBITO WHB COMPONENTES - "+_aGrupo[VAL(ZA8->ZA8_GRUPO)]+" - "+cDoc+" *** "
	ElseIf SM0->M0_CODIGO == "FN"  //empresa Usinagem
		_cAssunt := " *** AVISO DE DษBITO WHB FUNDICAO - "+_aGrupo[VAL(ZA8->ZA8_GRUPO)]+" - "+cDoc+" *** "
	EndIf

	oMail          := Email():New()
	oMail:cMsg     := cMsg
	oMail:cAssunto := _cAssunt

	oMail:cTo      := cTo

	oMail:Envia()

Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ APROVACAO DO DEBITO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
User Function Aprova1()
_cGrupo  := ZA8->ZA8_GRUPO
_lAprova := .F.
cValBrut := ""
_cTipo
_aComba1 := {'Procede','Nao Procede','Estornado','Repassado ao Cliente'} 
dDtReemb := CtoD("  /  /  ")
cRespCli := Space(50)
cAreaCli := Space(50)

	_nRecZA8 := ZA8->(Recno())    // guarda o recno  do ZA8
	_nOrdZA8 := ZA8->(IndexOrd()) // guarda o indice do ZA8
	
	If ZA8->ZA8_PROCED == 'P'
		_cTipo := 'Sim'
	ElseIf ZA8->ZA8_PROCED == 'N'
		_cTipo := 'Nao'
	ElseIf ZA8->ZA8_PROCED == 'E'
		_cTipo := 'Estornado'
	ElseIf ZA8->ZA8_PROCED == 'R'
		_cTipo := 'Repassado ao Cliente'
	EndIf
	
	SF1->(DBSETORDER(1))
	If SF1->(DBSEEK(XFILIAL('SF1')+ZA8->ZA8_DOC+ZA8->ZA8_SERIE+ZA8->ZA8_CLIENT+ZA8->ZA8_LOJA))
		cValBrut := STR(SF1->F1_VALBRUT)			
	EndIf
	
	DbSelectArea("ZAY")
	DbSetOrder(2)//FILIAL + LOGIN
			
	If !DbSeek(xFilial("ZAY")+Alltrim(Upper(cUserName)))
		MsgBox("Usuario sem permissao para aprovar.","Atencao","ALERT")	
		Return .F.
	Else
		WHILE !ZAY->(EOF()) .AND. Alltrim(ZAY->ZAY_LOGIN) == AllTrim(Upper(cUserName))
			If ZAY->ZAY_GRUPO == _cGrupo .AND. ZAY->ZAY_NIVEL == "1" //ษ APROVADOR
				_lAprova := .T. 
				EXIT
			Else
				ZAY->(DBSKIP())
			EndIf
		ENDDO
		
		If !_lAprova 
			MsgBox("Usuario sem permissao para aprovar.","Atencao","ALERT")	
			Return .F.
		EndIf
	EndIf
	
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+ZA8->ZA8_CLIENT+ZA8->ZA8_LOJA))
	_cDesCli := SA1->A1_NOME
	
	DbSelectArea("ZA8")
	
	_nLinha = MlCount(Lower(Alltrim(ZA8->ZA8_RESULT)))
	for i:= 1 to _nLinha
	    _cAcao +=  OemToAnsi(MemoLine(ZA8->ZA8_RESULT,90,i))
	next i 
	
	oDlg  := MsDialog():New(000,000,430,560,"Resultado da Anแlise D้bitos",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	@ 010,010 say "Cliente"  Color CLR_BLUE Size 050,8 object oCliente 
	oCliente:SetFont(oBold)
	@ 020,010 say "Documento"  Color CLR_BLUE Size 050,8 object oDocum
	oDocum:SetFont(oBold)
	@ 020,100 SAY "Valor"  Color CLR_BLUE Size 050,8 object oValor
	oValor:SetFont(oBold)
	@ 020,200 SAY "Data"  Color CLR_BLUE Size 050,8 object oData
	oData:SetFont(oBold)
	
	@ 030,010 SAY "Motivos"  Color CLR_BLUE Size 050,8 object oMotivo
	oMotivo:SetFont(oBold)
	@ 060,010 SAY "Status"  Color CLR_BLUE Size 050,8 object oProcede
	oProcede:SetFont(oBold)
	
	@ 008,060 say ZA8->ZA8_CLIENT +'-'+ZA8->ZA8_LOJA+" - "+_cDesCli object _zClient
	_zClient:SetFont(oBol16)
	@ 020,060 say ZA8->ZA8_DOC object _zDoc
	
	@ 020,140 say ZA8->ZA8_VALOR PICTURE  "@E 9,999,999.99" Size 040,8 object _zValor
	@ 020,240 say DTOC(ZA8->ZA8_EMISSA) PICTURE "99/99/9999" Size 040,8 object _zData
	
	@ 030,060 SAY ZA8->ZA8_MOT1 object _zMot1
	@ 040,060 SAY ZA8->ZA8_MOT2 object _zMot2
	@ 050,060 SAY ZA8->ZA8_MOT3 object _zMot3
	
	@ 058,060 COMBOBOX _cTipo  ITEMS _aComba1 SIZE 80,10 object oComba1
	
    oSay1 := TSay():New(60,160,{||"Data Reembolso"},oDlg,,,,,,.T.,CLR_BLUE,)
	oGet1 := tGet():New(58,225,{|u| if(Pcount() > 0, dDtReemb := u,dDtReemb)},oDlg,45,8,"99/99/99",{||.T.},;
		,,,,,.T.,,,{||Substr(_cTipo,1,1)=="N"},,,,,,,"dDtReemb")
	oSay1:SetFont(oBold)
	
    oSay2 := TSay():New(72,10,{||"Responsแvel no Cliente"},oDlg,,,,,,.T.,CLR_BLUE,)
	oGet2 := tGet():New(70,100,{|u| if(Pcount() > 0, cRespCli := u,cRespCli)},oDlg,170,8,"@!",{||.T.},;
		,,,,,.T.,,,{||Substr(_cTipo,1,1)=="N"},,,,,,,"cRespCli")
	oSay2:SetFont(oBold)
	
    oSay3 := TSay():New(84,10,{||"มrea Cliente"},oDlg,,,,,,.T.,CLR_BLUE,)
	oGet3 := tGet():New(82,100,{|u| if(Pcount() > 0, cAreaCli := u,cAreaCli)},oDlg,170,8,"@!",{||.T.},;
		,,,,,.T.,,,{||Substr(_cTipo,1,1)=="N"},,,,,,,"cAreaCli")
	oSay3:SetFont(oBold)
	
	@ 100,010 Say "A็ใo/Resultado da Anแlise :" Color CLR_BLUE Size 200,8 object oAcao
	oAcao:SetFont(oBold)
	@ 110,010 Get ocAcao VAR _cAcao MEMO Size 260,080 PIXEL OF oDialog
	
	@ 197,210 BMPBUTTON TYPE 01 ACTION fGrvApr()
	@ 197,240 BMPBUTTON TYPE 02 ACTION oDlg:End()
	
	ACTIVATE MsDialog oDlg CENTER

	_cAcao := " "

	ZA8->(dbSetOrder(_nOrdZA8))
	ZA8->(dbGoTo(_nRecZA8))

Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ GRAVA A APROVACAO OU ESTORNO DO DEBITO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function fGrvApr()

	If(Substr(_cTipo,1,1)$"N")
	    If Empty(dDtReemb)
	    	Alert("Obrigat๓rio informar a data do reembolso quando o d้bito Nใo Procede!")
	    	Return .F.
	    Else
	    	If dDtReemb < Date()
	    		alert("Data do reembolso nใo pode ser inferior ao dia de hoje!")
	    		Return .F.
	    	EndIf
	    EndIf
		
	    If Empty(cRespCli)
	    	Alert("Obrigat๓rio informar o Responsแvel no Cliente quando o d้bito Nใo Procede!")
	    	Return .F.
	    EndIf
	
	    If Empty(cAreaCli)
	    	Alert("Obrigat๓rio informar a มrea do Cliente quando o d้bito Nใo Procede!")
	    	Return .F.
	    EndIf
	EndIf
	
	If Empty(_cAcao)
	   MsgBox( "ษ obrigatorio a digitacao da acao", "Verificar digitacao de campo", "ALERT" )
	   Return(.f.)
	Endif
	
	RecLock("ZA8",.F.)
		ZA8->ZA8_PROCED		:= Substr(_cTipo,1,1)
		ZA8->ZA8_RESULT		:= ALLTRIM(_cAcao)
	
		If Substr(_cTipo,1,1)$"P/N" //APROVACAO
			ZA8->ZA8_APROVA     := Alltrim(Upper(cUserName))
			ZA8->ZA8_DTAPRV     := Date()
			ZA8->ZA8_DTREEM     := dDtReemb
			ZA8->ZA8_RESPCL     := cRespCli
			ZA8->ZA8_AREACL     := cAreaCli
		Else //ESTORNO
			ZA8->ZA8_ESTORN     := Alltrim(Upper(cUserName))
			ZA8->ZA8_DTAEST     := Date()
		EndIf
		
		If EMPTY(ZA8->ZA8_ANALIS) .AND. EMPTY(ZA8->ZA8_DTANAL)
			ZA8->ZA8_ANALIS := Alltrim(Upper(cUserName))
			ZA8->ZA8_DTANAL := Date()
		ENDIF
	
	MsUnLock("ZA8")
	
	oDlg:End()

	If Substr(_cTipo,1,1)$"P/N" //APROVACAO
		U_fEmailNDC("Aprovacao")
	Else //ESTORNO
		U_fEmailNDC("Estorno")
	EndIf
 
Return  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ ALTERACAO DOS DEBITOS ณ
//ณ Autor: JOAO FELIPE    ณ
//ณ Data: 28/11/2008      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
User Function EST98ALT()
Local _cNum      := ZA8->ZA8_DOC
Local _cCli      := ZA8->ZA8_CLIENT
Local _cLoja     := ZA8->ZA8_LOJA
Local _cDesCli   := ""
Local _cEmissao  := DtoC(ZA8->ZA8_EMISSA)
Local aChkFin    := {"N=Nใo","S=Sim"}
Local _aGrupo    := {"1-PCP","2-QUALIDADE","3-FISCAL","4-COMERCIAL"}
Private cChkFin  := ZA8->ZA8_DEVOLV
Private _cGrupo  := VAL(ZA8->ZA8_GRUPO)
Private cObsFin  := ZA8->ZA8_OBSFIN

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+_cCli+_cLoja))

	_cDesCli := SA1->A1_NOME

	Define MsDialog oDialog Title OemToAnsi("D้bito de Cliente") From 000,000 To 250,505 Pixel 

	@ 005,005 To 105,250 Object otitle //Title OemToAnsi(" Digite os Dados ")
	@ 015,010 Say "N๚mero: " Size 030,8 Object olNum
	@ 015,050 GET _cNum    Size 035,10 When .F. Object oNum 
	
	@ 015,190 Say "Data: "  Size 030,8 Object olData
	@ 015,209 GET _cEmissao Size 035,10 When .F. Object oData

	@ 030,010 Say "Cliente: " Size 30,8 Object olCli
	@ 030,050 Get _cCli    Size 035,10 When .F. Object oCli
	@ 030,085 Get _cLoja   Size 005,10 When .F. Object oLoja	
	@ 030,105 Get _cDesCli Size 140,10 When .F. Object oDesCli

	@ 045,010 Say "Grupo: "  Size 030,8 Object olGrupo
    @ 045,050 COMBOBOX _cGrupo ITEMS _aGrupo SIZE 47,10 object oGrupo

	@ 045,110 Say "Analisado pelo Financeiro: "  Size 100,8 Object olChkFin
    @ 045,209 COMBOBOX cChkFin ITEMS aChkFin SIZE 35,10 object oChkFin

	@ 060,010 Say "Obs. Financ.: "  Size 030,8 Object olObsFin
	@ 060,050 Get oObsFin VAR cObsFin MEMO When Size 195,40 PIXEL OF oDialog

	@ 110,194 BMPBUTTON TYPE 01 ACTION fGrvAlt() object oBtn1
	@ 110,224 BMPBUTTON TYPE 02 ACTION Close(oDialog) object oBtn2
		
	Activate MsDialog oDialog Center

Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ GRAVA ALTERACAO DOS DEBITOS ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function fGrvAlt()

	If ZA8->ZA8_PROCED <> " " .AND. !Alltrim(Upper(cUserName))$"DAYANAC/ADAYANER/JOAOFR/ADMIN/ADMINISTRADOR/THIAGOSI"
		Alert("Permitido apenas para D้bitos em aberto!")
		Close(oDialog)
		Return .F.
	EndIf
	
	If !AllTrim(Upper(cUserName))$"DAYANAC/LUCASPC/ADAYANER/JOAOFR/ADMIN/ADMINISTRADOR/THIAGOSI"
		Alert("Opera็ใo nใo permitida, somente pessoas autorizadas!")
		Close(oDialog)
		Return .F.
	EndIf
	
	RecLock("ZA8",.F.)
		ZA8->ZA8_GRUPO  := Iif(ValType(_cGrupo) =="N",StrZero(_cGrupo,1) ,Substr(_cGrupo,1,1))
		ZA8->ZA8_CHKFIN := Iif(ValType(cChkFin) =="N",StrZero(cChkFin,1) ,Substr(cChkFin,1,1))
		ZA8->ZA8_OBSFIN := cObsFin
	MsUnlock("ZA8")

	Close(oDialog)

Return

//ฺฤฤฤฤฤฤฤฤฤฤฟ
//ณ LEGENDAS ณ
//ภฤฤฤฤฤฤฤฤฤฤู
User Function FLegOrd2()       

Local aLegenda :=	{ {"BR_VERDE"    , "Aberto"  },;
                      {"BR_PRETO"    , "Nao Procede" },;                      
                      {"BR_AMARELO"  , "Aguarda" },;                                            
  					  {"BR_VERMELHO" , "Procede"   },;
  					  {"BR_AZUL"     , "Estornado"},;
  					  {"BR_LARANJA"  , "Repassado ao Cliente" } }

BrwLegenda(OemToAnsi("Ordem de Libera็ใo de Materiais"), "Legenda", aLegenda)

Return  

Static Function DebCor()       

Local aLegenda :=	{ {"BR_VERDE"    , "Aberto"  },;
                      {"BR_PRETO"    , "Nao Procede" },;                      
                      {"BR_AMARELO"  , "Aguarda" },;                                            
  					  {"BR_VERMELHO" , "Procede"   },;
  					  {"BR_AZUL"     , "Estornado"},;
  					  {"BR_LARANJA"  , "Repassado ao Cliente"} }
  					  
Local uRetorno := {}
Aadd(uRetorno, { 'ZA8_PROCED = " "  ' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZA8_PROCED = "N"  ' , aLegenda[2][1] } )
Aadd(uRetorno, { 'ZA8_PROCED = "A"  ' , aLegenda[3][1] } )
Aadd(uRetorno, { 'ZA8_PROCED = "P"  ' , aLegenda[4][1] } )
Aadd(uRetorno, { 'ZA8_PROCED = "E"  ' , aLegenda[5][1] } )
Aadd(uRetorno, { 'ZA8_PROCED = "R"  ' , aLegenda[6][1] } )
Return(uRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Relato1   บAutor ณJoใo Felipe         บ Data ณ  13/06/2008 บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ RELATORIO DE DEBITOS PENDENTES				              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESTOQUE CUSTOS                                             บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Relato1()

cString   := "ZA8"
cDesc1    := OemToAnsi("Este   relatorio   tem   como   objetivo  Imprimir ")
cDesc2    := OemToAnsi("a rela็ใo dos debitos dos clientes.")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST098"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("DEBITOS DOS CLIENTES")
cabec1    := " Cliente      Descricao                        N.F.      Emissao    Vencimento     Valor        Digitador       Analista         Aprovador     Status"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHEST098"
_cPerg    := "EST098"
 
// mv_par01 de cliente
// mv_par02 at้ cliente
// mv_par03 de nf 
// mv_par04 at้ nf
// mv_par05 de data
// mv_par06 at้ data
// mv_par07 status
// mv_par08 de vencimento
// mv_par09 ate vencimento
// mv_par10 de grupo
// mv_par11 ate grupo
// mv_par12 somente Estornados

Pergunte(_cPerg,.T.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]      

Processa( {|| Gerando()   },"Gerando Dados para a Impressao") 
Processa( {|| RptDetail()   },"Imprimindo...") 

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function Gerando()
Local _cFiltro
Local _cStatus

	DO CASE
		CASE mv_par07 == 1
			_cStatus := "' '"
		CASE mv_par07 == 2
			_cStatus := "'P'"
		CASE mv_par07 == 3
			_cStatus := "'N'"
		CASE mv_par07 == 4
			_cStatus := "'A'"
//		CASE mv_par07 == 5
//			_cStatus := "'R'"
	ENDCASE

	If mv_par12 == 1
		_cStatus := "'E'"
	EndIf

/*
	If mv_par13 == 1
		_cStatus := "'R'"
	EndIf
*/
	
_cFiltro := " ZA8->ZA8_CLIENT >= mv_par01 .And. "
_cFiltro += " ZA8->ZA8_CLIENT <= mv_par02 .And. "
_cFiltro += " ZA8->ZA8_DOC >= mv_par03 .And. "
_cFiltro += " ZA8->ZA8_DOC <= mv_par04 .And. "
_cFiltro += " ZA8->ZA8_EMISSA >= mv_par05 .And. "
_cFiltro += " ZA8->ZA8_EMISSA <= mv_par06 .and. "
_cFiltro += " ZA8->ZA8_VENCTO >= mv_par08 .And. "
_cFiltro += " ZA8->ZA8_VENCTO <= mv_par09 .And. "
_cFiltro += " ZA8->ZA8_GRUPO >= '"+StrZero(mv_par10,1)+"' .And. "
_cFiltro += " ZA8->ZA8_GRUPO <= '"+StrZero(mv_par11,1)+"'"

If mv_par07 <> 5 .OR. mv_par12 == 1 //todos
	_cFiltro += " .And. ZA8->ZA8_PROCED = "+_cStatus
EndIF

DbSelectArea("ZA8")
Set Filter To &(_cFiltro)
DbgoTop()

Return

Static Function RptDetail()
Local _nTVal := 0

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

While !Eof() 

	If Prow() > 60
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	Endif

	@Prow()+1, 001 psay ZA8->ZA8_CLIENT+" - "+ZA8->ZA8_LOJA                                  
	
	SA1->(DbSetOrder(1)) //FILIAL + COD + LOJA
	SA1->(DBSEEK(xFilial("SA1")+ALLTRIM(ZA8->ZA8_CLIENT+ZA8->ZA8_LOJA)))
	
	@Prow()  , 014 Psay SUBSTR(SA1->A1_NOME,1,30)
	
    @Prow()  , 046 Psay ZA8->ZA8_DOC
	@Prow()  , 056 psay ZA8->ZA8_EMISSA
	@Prow()  , 068 psay ZA8->ZA8_VENCTO
    @Prow()  , 080 Psay ZA8->ZA8_VALOR Picture("@e 999,999.99")
   	_nTVal += ZA8->ZA8_VALOR
   	
   	@Prow()  , 096 Psay Subs(EMBARALHA(ZA8->ZA8_USERGI,1),1,AT(" ",EMBARALHA(ZA8->ZA8_USERGI,1)))
   	@Prow()  , 112 Psay Alltrim(ZA8->ZA8_ANALIS)
   	@Prow()  , 129 Psay Alltrim(ZA8->ZA8_APROVA)
    @Prow()  , 146 Psay ZA8->ZA8_PROCED 

	If !Empty(ZA8->ZA8_MOT1)
 		@Prow()  , 152 psay "Motivo 01: "+ZA8->ZA8_MOT1
	EndIf
	If !Empty(ZA8->ZA8_MOT2)
	    @Prow()+1, 152 Psay "Motivo 02: "+ZA8->ZA8_MOT2
	EndIf
	If !Empty(ZA8->ZA8_MOT3)
		@Prow()+1, 152 psay "Motivo 03: "+ZA8->ZA8_MOT3
	EndIf
	
	_nLinMemo := MLCOUNT(ZA8->ZA8_RESULT,50)

	For LinhaCorrente := 1 To _nLinMemo
		If !Empty((MemoLine(ZA8->ZA8_RESULT,50,LinhaCorrente)))		
			If LinhaCorrente == 1
				@Prow()+1, 152 Psay "Resultado: "+(MemoLine(ZA8->ZA8_RESULT,50,LinhaCorrente))	
			else
				@Prow()+1, 152 Psay "           "+(MemoLine(ZA8->ZA8_RESULT,50,LinhaCorrente))	
			endif
        EndIf
	Next
	
	@ Prow()+1,000 PSAY __PrtThinLine()
	
	ZA8->(DbSkip())

EndDo

@ Prow()+1,000 PSAY __PrtThinLine()
@ Prow()+1,001 Psay "Total: -->"
@ Prow()  ,044 Psay _nTVal Picture("@e 999,999,999.99")

ZA8->(DbCloseArea())          
//--teste 2
Return(nil)