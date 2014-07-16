/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA105LIN ºAutor  ³Alexandre R. Bento  º Data ³  04/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada apos confirmacao da inclusao da solicitacaoº±±
±±º          ³e antes de gravar os dados no SCP.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"

USER FUNCTION MTA105LIN()

Local _lRet    := .T.
Local nCCSCP   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_CC"})  
Local nPRODSCP := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_PRODUTO"})  
Local nQTDSCP  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_QUANT"})  
Local _nLoc    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_LOCAL"})  
Local nPeca    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_PECA"})  
Local nCTSCP   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_CONTA"})
Local nOrdem   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_ORDEM"})
Local nMaquina := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_MAQUINA"})
Local nTurnRet := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_TURNRET"})
//Local _aGrupo  := pswret()

Local nD       := 0

Local cCC,cProd

If UPPER(ALLTRIM(FUNNAME()))$"NHEST151"
	cCC    := M->CP_CC
	cProd  := M->CP_PRODUTO
	cLoc   := M->CP_LOCAL
	nQuant := M->CP_QUANT
	cCTSCP := M->CP_CONTA
	cOrdem := M->CP_ORDEM
Else
	cCC    := Acols[n][nCCSCP]
	cProd  := Acols[N][nPRODSCP]
	cLoc   := Acols[N][_nLoc]
	nQuant := Acols[N][nQTDSCP]		
	cCTSCP := ACOLS[N][nCTSCP]	
	cOrdem := Acols[n][nOrdem]
		
	If Acols[n][len(aHeader)+1]  //nao pega quando a linha esta deletada
		Return .T.
	EndIf
	
EndIf

If SM0->M0_CODIGO$"FN/NH"
// Validação feita por: José Henrique Medeiros Felipetto 
	If n == 1
		If Alltrim(cLoc) == "31"
			If Substr(time(),1,5) > "19:00" .AND. Substr(time(),1,5 ) <= "20:00"
				Alert("Almoxarifado fechado para Balanço das 19:00 às 20:00 ")
			EndIf
		Endif 
		
		//-- 048691
		If Alltrim(cLoc)$"31/41"
			If Substr(time(),1,5 ) > "10:30" .AND. Substr(time(),1,5 ) < "11:30"
				Alert("Almoxarifado fechado para Balanço das 10:30 às 11:30")
				 
				
				// OS 068893
				If Alltrim(cLoc)$"41"
				   Return .F.	
				EndIf

				
			EndIf
		EndIf
	EndIf
	
	// Validação feita por: José Henrique Medeiros Felipetto 
	SB1->(DbSetOrder(1) )
	SB1->(DbSeek(xFilial("SB1") + aCols[n][nPRODSCP]))
	If SB1->B1_TIPO $ "FM/MM"
		If Empty(aCols[n][nMaquina]) 
			alert("Campo máquina deve ser preenchido! ")
		EndIf
	EndIf
	
	//-- OS Nº: 032449
	If ALLTRIM(SB1->B1_GRUPO)$"MM32"
		If Empty(cOrdem) 
			alert("Campo Ordem Servic deve ser preenchido! ")
			Return .f.
		EndIf
		If Empty(aCols[n][nMaquina]) 
			alert("Campo máquina deve ser preenchido! ")
			Return .f.
		EndIf
	EndIf
	//-- FIM OS Nº: 032449
	
	
	//-- OS Nº: 027359
	
	If Alltrim(cLoc)$"31/21/61/62"
		SB5->(DbSetOrder(1))
		If SB5->(DbSeek(xFilial("SB5")+ aCols[n][nPRODSCP] ))
			If SB5->B5_QPA <> 0
				If aCols[n][nQTDSCP]%SB5->B5_QPA <> 0
					Alert('Quantidade solicitada não é multipla da quantidade padrão do produto!'+chr(13)+chr(10)+'Digite uma quantidade múltipla de: '+(alltrim(str(SB5->B5_QPA)))+'!')
					Return .F.
				Endif
			Endif			
		Endif	
	EndIf 

   If Alltrim(cProd)$"MS02.000530"              
      SB2->(DbSeek(xFilial("SB2")+"MS02.000247    "+cLoc))
      If (SB2->B2_QATU-SB2->B2_QEMPSA) > 0 //saldo atual - qtde empenhada de S.A.(solicitacao ao almoxarifado)
         MSGBOX('Favor Solicitar o Produto MS02.000247 a Quantidade Disponivel é : ' + Transform((SB2->B2_QATU-SB2->B2_QEMPSA),"@E 999,999.99"),OemToAnsi('Atenção'),'ALERT')
         Return(.F.)
      Endif         
   Endif   
	
Endif	
//-- fim OS Nº: 027359

	
   If Alltrim(cCC)$"ALMOXI/ALMOXARI" // Centro de custo   
      MSGBOX('Esse Centro de Custo nao pode ser Utilizado, Favor Verifique !!!!','Centro Custo','ALERT')
      return .f.
   Endif  


If SM0->M0_CODIGO$"FN/NH"
	//Verifica se o usuario tem acesso ao centro de custo p/ fazer solicitacao ao almoxarifado
	ZRJ->(DbSetOrder(1))
	ZRJ->(DbSeek(xFilial("ZRJ")+upper(ALLTRIM(cUsername))))
	_lRet := .F.
	While !ZRJ->(Eof()) .AND. upper(Alltrim(ZRJ->ZRJ_LOGIN)) == upper(ALLTRIM(cUsername))
	
		If lower(Alltrim(ZRJ->ZRJ_CC)) == "<todos>"
			_lRet := .T.
			Exit
		Endif
	
		If Alltrim(ZRJ->ZRJ_CC) == Alltrim(cCC)
			_lRet := .T.
			Exit
		Endif
		ZRJ->(DbSkip())
	
	Enddo
	
	//verifica o C.Custo do funcionario na tabela qaa
	
	If !_lRet
	   QAA->(DbsetOrder(6))
	   QAA->(DbSeek(upper(ALLTRIM(cUsername))))
	   If QAA->(Found())
	   	  If Alltrim(cCC) <> Alltrim(QAA->QAA_CC) .AND. !ALLTRIM(UPPER(CUSERNAME))$"JOAOFR"
		     MsgBox("ATENÇÃO: O Solicitante não tem acesso a solicitar material neste Centro de Custo "+ Alltrim(cCC) +"!"+chr(13)+chr(10)+;
		     	    "Está autorizado apenas a solicitar material no Centro de Custo " +Alltrim(QAA->QAA_CC)+" do Cadastro do funcionario!!!","Centro de Custo","ALERT")
	
			 If upper(FUNNAME())$"MATA105"
				Acols[n][nCCSCP] := Space(09) //limpa campo de centro de custo
			 ElseIf upper(FUNNAME())$"NHEST105"
				M->CP_CC := Space(09) //limpa campo de centro de custo     
			 EndIf
	
			 cCC := Space(09)
	         Return(_lRet)
		  Else
			 _lRet := .T.	  
		  Endif  
		  
		  //-- CHAMADO 038798
		  If ALLTRIM(cProd)$"MD25.000735" .AND. !ALLTRIM(QAA->QAA_CC)$"33003003"
		  	Alert("Usuário sem permissão para solicitar este material, somente autorizado para funcionários do CC. 33003003!")
		  	Return .f.
		  Endif
		  //-- FIM CHAMADO 038798
		  
	   Else
	      MsgBox("Nao existe Centro de Custo para este Login, Avisar o almoxarifado p/ cadastrar !","Centro de Custo","ALERT")
	      Return(_lRet)
	   Endif   
	Endif 
Endif

                                   
If SM0->M0_CODIGO=="NH" //EMPRESA USINAGEM

	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(xFilial("SB1")+cProd))
		
		If !ALLTRIM(UPPER(FUNNAME()))$"NHEST151"
			//-- chamado 013835 do portal
			//-- bloqueia os produtos MS02
		    If ALLTRIM(SB1->B1_GRUPO)$"MS02" .AND. !ALLTRIM(UPPER(cUserName))$"ALMIRRR/PAULORR/MARCILIOM/ADMIN/ADMINISTRADOR/LEANDROJS/LUCASF/JACQUELINENV/CARLOSAS"
		    	Alert("A requisição de E.P.I é somente pela rotina de Solicitação de E.P.I.!")
		    	Return .f.
		    EndIf
		EndIf
		
		//-- bloqueia os produtos MM
		If SB1->B1_TIPO=="MM"
			Alert("Não é possível solicitar produtos do tipo MM!"+chr(13)+chr(10)+" Entre em contato com o ALMOXARIFADO!")
			Return .F.
		EndIf
	Else
		Alert("Produto não encontrado!")
		Return .F.
	EndIf

EndIf	

If SM0->M0_CODIGO=="IT" //EMPRESA ITESAPAR

	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(xFilial("SB1")+cProd))
		
		If !ALLTRIM(UPPER(FUNNAME()))$"NHEST151"
			//-- chamado 013835 do portal
			//-- bloqueia os produtos MS02
		    If ALLTRIM(SB1->B1_GRUPO)$"MS01/MS03/MS04/MS32" .AND. !ALLTRIM(UPPER(cUserName))$"ADMIN/ADMINISTRADOR/ELISANDRA.HANKE/ROGINALDO.VASCO/JULIANE.SANTOS/NERY.WALTRICK/JOAOFR"
		    	Alert("A requisição de E.P.I é somente pela rotina de Solicitação de E.P.I.!")
		    	Return .f.
		    EndIf
		EndIf
	Else
		Alert("Produto não encontrado!")
		Return .F.
	EndIf

EndIf	


If SM0->M0_CODIGO=="FN"

	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+cProd))


	If !ALLTRIM(UPPER(FUNNAME()))$"NHEST151"
		//-- bloqueia os produtos MS32
	    If ALLTRIM(SB1->B1_GRUPO)$"MS32" .AND. !ALLTRIM(UPPER(cUserName))$"ALMIRRR/PAULORR/MARCILIOM/ADMIN/ADMINISTRADOR/LUCASF/JACQUELINENV/CARLOSAS/RAFAELB/JOAOFR"
	    	Alert("A requisição de E.P.I é somente pela rotina de Solicitação de E.P.I.!")
	    	Return .f.
	    EndIf
	EndIf  
	
	If !ALLTRIM(UPPER(FUNNAME()))$"NHEST151" .AND. SM0->M0_CODFIL=='02'
		//-- bloqueia os produtos MS52
	    If ALLTRIM(SB1->B1_GRUPO)$"MS52" .AND. !ALLTRIM(UPPER(cUserName))$"EMANUELBM"
	    	Alert("A requisição de E.P.I. é somente pela rotina de Solicitação de E.P.I.!")
	    	Return .f.
	    EndIf
	EndIf  
	
	//-- VALIDAÇÃO LIMITE DE REQUISICAO
	//-- O.S.: 063000 - Marcos V / 057889 - LeandroJs
	//-- Autor: Douglas Dourado

                   //Produto					Centro de Custo            Quant Solic.      Data
	If  U_NHEST223( AllTrim(aCols[n][nPRODSCP]) , AllTrim(aCols[n][nCCSCP]) , aCols[n][nQTDSCP] ,Da105data, aCols[n][nTurnRet]) 
		return .f.
	EndIf	 
		
	//-- VALIDAÇÃO PRODUTO ML01.000003 (COPO PLASTICO) 
	//-- O.S.: 055880 - LucianoDB
	//-- Autor: Douglas Dourado
	
	IF SM0->M0_CODFIL=='01'
		If (AllTrim(aCols[n][nPRODSCP])$"ML01.000003") .and. (aCols[n][nQTDSCP] > 3) .and. (alltrim(cLoc)$"21") .AND. !ALLTRIM(UPPER(cUserName))$"LUCIANODB/REGINALDOAR/DOUGLASSD/JOAOFR/ADMIN"
			MsgBox("Este produto é requisitado por pacote com 100 unidades !","MTA105LIN","ALERT")
			return .f.
		EndIf
	EndIF
	
	//-- VALIDAÇÃO CENTRO DE CUSTO DA FORJARIA
	//-- Data: 11/11/2013
	//-- O.S.: 056754 - MARIOCP
	//-- Autor: Douglas Dourado
	
	IF SM0->M0_CODFIL=='01'
		If substr(Alltrim(cLoc),1,1)$"4" .AND. !substr(Alltrim(cCC),1,1)$"4"
			MsgBox("Somente funcionarios de centro de custo da planta FORJARIA podem requisitar no almoxarifado da FORJARIA (41) !","MTA105LIN","ALERT")
			return .f.
		EndIf
	EndIF

	//-- OS Nº: 024647
	//-- Data : 08/11/2011
	//-- Autor: João Felipe da Rosa
	//-- desc : limitar solic. de prod. MM somente p/ pessoal da manutenção 
	//-- Adicionado em 19/02/2013: SHIRLEYPS, RODRIGOCO e ROMULODB - OS 047033
 	If alltrim(cLoc)$"31" .and. AllTrim(SB1->B1_GRUPO)$"MM30/MM32" .AND. !Alltrim(upper(cUserName))$"LUIZFE/JHONYRC/ANDERSONG/GERALDOF/ROGERIOJS/GUILHERMEO/"+;
 		"CRISTIANEM/CLAUDIOSA/JOSEFH/JOSIASAS/LEANDROJS/CLODOALDERS/MARCIOAF/JASONS/JODINEIMR/JASONJ/RODRIGOCO/ROMULODB/MARLONBS/ANDERSONCC/FABIOFM/GILBERTOFB/MARLONCC/SIDNEIF/DANIELRD"
		MsgBox("Somente pessoal da Manutenção está autorizado a retirar produtos do grupo "+SB1->B1_GRUPO+"! Favor entrar em contato com Manutenção!","MTA105","ALERT")
		return .f.
	EndIf
	//-- Fim OS Nº: 024647 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida o centro de custo da requisicao de ferramenta com o cadastro Ferramenta x Peças (NHEST160) ³
	//³ Solicitado por Edson Hoffelder - Preset - 18/11/2010                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If AllTrim(SB1->B1_TIPO)=="FE"
		
		//-- OS Portal N.: 020388
		//-- desc: verifica se o solicitante faz parte do grupo que pode solicitar ferramentas
		//-- data: 14/07/2011
		//-- autor: João Felipe da Rosa
		If alltrim(cLoc)$"31" .and. !Alltrim(upper(cUserName))$"JAIRB/IVANF/DIOGOAN/CRISTOPHERVW/JOELMAMB/FLAVIARS/PAULOHP/SAMUELDO/RICARDOS/DARCIF/ANDRESG/"+;
									  "GEAZISP/KLEBERSONO/JEFERSONP/MARCELOPS/VALDINEIX/DIEGOOC/FABIOC/JOSUEV/FRANCISCOF/PAULOCK/OSIELCS/"+;
									  "EDISONLC/FRANCOAA/CLAUDEMIRPR/OZIELCS/MAICONPS/ADRIANOS/ENEIASC/EDSONH/ADMIN/ADMINISTRADOR/JOAOFR/JHONYRC/DEIVIDL/"+;
									  "VANDERLEIC/DEANGELISCC/GUILHERMEBG/JOSESF/ANTONIOMR/CICEROBF/MARCELOAR/VICTORNZ/IZAIASGS/FILIPERC/LUCASGS/LEONARDOBA/PAULOCK/JEANCH/"+;
									  "IVANJM/ALDOAF/AMARILDOGB/JEFERSONP/CLAUDEMIRPR/AMARILDOGB/JOSUEV/MAICONPS/LUISC/SAMUELDO/LUISRS"
									
			Alert("Somente pessoal do Preset está autorizado a retirar Ferramentas! Favor entrar em contato com Preset!")
			return .f.
		Endif
		//-- fim OS N.: 020388
		
		//-- OS N.: 038772
		If alltrim(cLoc)$"31" .and. SUBSTR(SB1->B1_COD,1,8)$"FE33.065/FE33.066" .AND. !Alltrim(upper(cUserName))$;
"ALCIONEL/FRANCOAA/PAULOK/CRISTOPHERVW/CICEROBF/"+;
				   					         "JAIRB/IVANF/DIOGOAN/CRISTOPHERVW/JOELMAMB/FLAVIARS/PAULOHP/SAMUELDO/RICARDOS/DARCIF/ANDRESG/"+;
									  "GEAZISP/KLEBERSONO/JEFERSONP/MARCELOPS/VALDINEIX/DIEGOOC/FABIOC/JOSUEV/FRANCISCOF/PAULOCK/OSIELCS/"+;
									  "EDISONLC/FRANCOAA/CLAUDEMIRPR/OZIELCS/MAICONPS/ADRIANOS/ENEIASC/EDSONH/ADMIN/ADMINISTRADOR/JOAOFR/JHONYRC/DEIVIDL/"+;
									  "VANDERLEIC/DEANGELISCC/GUILHERMEBG/JOSESF/ANTONIOMR/CICEROBF/MARCELOAR/VICTORNZ/IZAIASGS/FILIPERC/LUCASGS/LEONARDOBA/PAULOCK/JEANCH/"+;
									  "IVANJM/ALDOAF/AMARILDOGB/JEFERSONP/CLAUDEMIRPR/AMARILDOGB/JOSUEV/MAICONPS/LUISC/SAMUELDO/LUISRS"
			Alert("Somente preset estão autorizados a retirar "+SUBSTR(SB1->B1_COD,1,8)+"! Favor entrar em contato com Preset!")
			return .f.
		Endif
		//-- fim OS 038772
		
		
		cAl := getNextAlias()
		
		beginSql Alias cAl
				SELECT DISTINCT
					ZDJ_CC
				FROM
					%Table:ZDJ% ZDJ (NOLOCK)
				WHERE
					ZDJ_FERRAM = %Exp:cProd%
					AND ZDJ_FILIAL = %xFilial:ZDJ%
					AND ZDJ.%NotDel%
					
		endSql
		
		If (cAl)->(Eof())
		   	If !MsgYesNo("A ferramenta "+AllTrim(cProd)+" não está cadastrada para ser usada no Centro de Custo "+ Alltrim(cCC) +". Deseja continuar?")
			  //  alert("A ferramenta "+AllTrim(cProd)+" não está cadastrada para ser usada no Centro de Custo "+ Alltrim(cCC)+"!")
				(cAl)->(dbCloseArea())
				Return .F.
			EndIf
		Else
			lCCOk := .F.
			While (cAl)->(!eof())
			
				If AllTrim(SUBSTR((cAl)->ZDJ_CC,1,1)+'4'+SUBSTR((cAl)->ZDJ_CC,3,6)) == AllTrim(cCC) //-- troca o segundo digito do cc para 4
					lCCOk := .T.
				Endif
			
				(cAl)->(dbSkip())
			Enddo
			
			If !lCCOk
				//Alert('Ferramenta não cadastrada para este C.Custo! Favor entrar em contato com Preset!')
				If !MsgYesNo("A ferramenta "+AllTrim(cProd)+" não está cadastrada para ser usada no Centro de Custo "+ Alltrim(cCC) +". Deseja continuar?")
					(cAl)->(dbCloseArea())
					Return .f.
				EndIf
			EndIF
			
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ VERIFICA SE A FERRAMENTA ESTÁ SENDO REQUISITADA A MAIS DO QUE O PREVISTO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//-- A T E N C A O !!! Alterar também os CC's no fonte MT241GRV       
		IF SM0->M0_CODFIL=='01
			If ALLTRIM(cCC)$'34002003/34001002/34005001/34004002/34003005' // CARCAÇA GM a pedido de edsonh
				If !Upper(AllTrim(cUsername))$"ALCIONEL/FRANCOAA/PAULOK/CRISTOPHERVW/CICEROBF/"+;
				   					         "JAIRB/IVANF/DIOGOAN/CRISTOPHERVW/JOELMAMB/FLAVIARS/PAULOHP/SAMUELDO/RICARDOS/DARCIF/ANDRESG/"+;
									  "GEAZISP/KLEBERSONO/JEFERSONP/MARCELOPS/VALDINEIX/DIEGOOC/FABIOC/JOSUEV/FRANCISCOF/PAULOCK/OSIELCS/"+;
									  "EDISONLC/FRANCOAA/CLAUDEMIRPR/OZIELCS/MAICONPS/ADRIANOS/ENEIASC/EDSONH/ADMIN/ADMINISTRADOR/JOAOFR/JHONYRC/DEIVIDL/"+;
									  "VANDERLEIC/DEANGELISCC/GUILHERMEBG/JOSESF/ANTONIOMR/CICEROBF/MARCELOAR/VICTORNZ/IZAIASGS/FILIPERC/LUCASGS/LEONARDOBA/PAULOCK/JEANCH/"+;
									  "IVANJM/ALDOAF/AMARILDOGB/JEFERSONP/CLAUDEMIRPR/AMARILDOGB/JOSUEV/MAICONPS/LUISC/SAMUELDO/LUISRS" .AND. !U_FE241PRV(cProd,cCC,'',.f.)
				   												          
					Alert("Limite de Consumo da Ferramenta ultrapassado!"+chr(13)+chr(10)+;
					      "Por favor, entre em contato com  o Preset!")   
					      
					(cAl)->(dbCloseArea())				      
					Return .F.
				EndIf
			EndIf
	      ENDIF
		(cAl)->(dbCloseArea())
	EndIf   
	

	
	
         
    //-- VALIDACAO DE EMBALAGEM X C.CUSTO
    // OS.: 017615 do portal
	If AllTrim(SB1->B1_TIPO)=="EB"
	
		//-- OS: 047044
		ZEN->(dbsetorder(1)) //ZEN_FILIAL+ZEN_CC
		If ZEN->(dbseek(xFilial('ZEN')+ALLTRIM(cCC)))
	
//		If ALLTRIM(cCC)$'34001004' //teste inicialmente com centro de custo tambor de freio vw
		
			cAl := getNextAlias()
			
		    //-- verifica se a embalagem está liberada para o c.custo, tabela ZEN	
			beginSql alias cAl
				SELECT ZEN_EMBAL 
				FROM %Table:ZEN%
				WHERE %Notdel%
				AND ZEN_FILIAL = %xFilial:ZEN%
				AND ZEN_EMBAL = %Exp:SB1->B1_COD%
				AND ZEN_CC = %Exp:cCC%
			endSql
		
			If (cAl)->(Eof())

				Alert('A embalagem '+alltrim(SB1->B1_COD)+'-'+ALLTRIM(SB1->B1_DESC)+;
					  ' não pode ser solicitada para o C.Custo '+alltrim(cCC)+'-'+Alltrim(Posicione('CTT',1,xFilial('CTT')+cCC,'CTT_DESC01'))+'!'+ chr(13)+chr(10)+;
					  'Favor entrar em contato com o responsável por embalagens do setor de Logística!')
				
				(cAl)->(dbclosearea())
				Return .f.
			Endif

			(cAl)->(dbclosearea())		
			
		Endif
		//-- FIM OS 047044
	Endif

EndIf

//Traz o C.Custo da OS de Manutencao para a Requisição
If !Empty(cOrdem)        
   	STJ->(DbSetOrder(1)) //filial + cod
   	
   	STJ->(DbSeek(xFilial("STJ")+cOrdem))
   	If STJ->(Found())
   		If STJ->TJ_TERMINO=="N" 
   		
   			If STJ->TJ_SITUACA <> "C"
	   			If upper(FUNNAME())$"MATA105"
	   				Acols[n][nCCSCP] := STJ->TJ_CCUSTO //puxa o centro de custo da OS.
				ElseIf upper(FUNNAME())$"NHEST105"
					M->CP_CC := STJ->TJ_CCUSTO //puxa o centro de custo da OS.
				EndIf   		
				cCC := STJ->TJ_CCUSTO //puxa o centro de custo da OS.
				_lRet := .T.
			Else
				alert("Ordem de Serviço Cancelada!")
				Return .F.
			Endif
		Else
			alert("Ordem de Serviço já Finalizada!")
			Return .F.
		EndIf
   	Else
   		alert("Ordem de Serviço não encontrada!")
   		Return .F.
   	Endif
Endif  


SB2->(DbsetOrder(1))
//SRG->(DbsetOrder(1))
//QAA->(DbsetOrder(6))

	If SM0->M0_CODIGO == "NH"   
	   If Subs(cCC,1,1)$"5" //Usinagem cc inicando com 5          
	      MsgBox("Este Centro de Custo não Pode ser Utilizado, Favor entrar em Contato com o Depto de Custos","Atencao","ALERT")
	      _lRet   := .F.         
	   Endif
	ElseIf SM0->M0_CODIGO == "FN"   
	   If Subs(cCC,2,1)$"5" //fundicao cc iniciando na segunda casa com 4 ou 5           
	      MsgBox("Este Centro de Custo não Pode ser Utilizado, Favor entrar em Contato com o Depto de Custos","Atencao","ALERT")
	      _lRet   := .F.         
	   Endif
	Endif
	


	/*
    QAA->(DbSeek(Alltrim(cSolic)))    
	ZRG->(DbSeek(xFilial("ZRG")+QAA->QAA_MAT))
	If ZRG->(Found())
	   If !Alltrim(UPPER(cUsername))$"ALDERICOB/MARCIOS/OSNEISL/ANTONIORF/EURIDESCC/ROMEUHB/OTAVIOF/AGUINALDOAS/ANTONIOCO/JOSEFG/VALMIRJS/JOSELP/CELSOC/SIDERLEIC/AMAURIRR/ENEIASJR/JOSEST/GELSONTF/RICARDORS/JOAORB/GELSONTF/RICARDORS/TONIR/SIDNEIC/SILVANOAS/JOSEMS"
	      If Alltrim(cCC) <> Alltrim(ZRG->ZRG_CC)
	         MsgBox("ATENCAO: Centro de Custo "+ Alltrim(cCC) +" é Diferente do Centro de Custo " +Alltrim(ZRG->ZRG_CC)+" Do Cadastro do funcionario !!!!!!!!")
		     cCC:= Space(09) //limpa campo de centro de custo     
		     _lRet := .f.
		  Endif   
	   Endif   
	Else
	   QAA->(DbSeek(xFilial("QAA")+Alltrim(cSolic)))
	   If QAA->(Found())
	      If !Alltrim(UPPER(cUsername))$"ALDERICOB/MARCIOS/OSNEISL/ANTONIORF/EURIDESCC/ROMEUHB/OTAVIOF/AGUINALDOAS/ANTONIOCO/JOSEFG/VALMIRJS/JOSELP/CELSOC/SIDERLEIC/AMAURIRR/ENEIASJR/JOSEST/GELSONTF/RICARDORS/JOAORB/GELSONTF/RICARDORS/TONIR/SIDNEIC/SILVANOAS/JOSEMS"	   
    	     If Alltrim(cCC) <> Alltrim(QAA->QAA_CC)
	            MsgBox("ATENCAO: Centro de Custo "+ Alltrim(cCC) +" é Diferente do Centro de Custo " +Alltrim(QAA->QAA_CC)+" Do Cadastro do funcionario !!!!!!!!")
		        cCC := Space(09) //limpa campo de centro de custo     
			    _lRet := .f.
			 Endif  
		  Endif   
//	   Else
//		   MsgBox("ATENCAO: LOGIN nao Encontrado no Cadastrado de Usuarios (QAA) !!!!!!!!")
//		   cCC := Space(09) //limpa campo de centro de custo     
//		   _lRet := .f.
	   Endif             
    Endif		
    */
      
   If Da105data > dDatabase
      MsgBox( "Impossivel Fazer a Requisicao Com Data Maior que a Database do sistema! - P.E. - MTA105LIN", "Requisicao Almoxarifado", "ALERT" )
      _lRet := .F.
   Endif                 

   If SB2->(DbSeek(xFilial("SB2")+cProd+cLoc)) 
   
      //-- pega o saldo do produto
      nSaldo := SB2->B2_QATU-SB2->B2_QEMPSA
      
      //-- decrementa o saldo de um possivel produto igual no acols
      For xS:=1 to Len(aCols)
      	If n <> xS .and. aCols[xS][nPRODSCP]==aCols[n][nPRODSCP]
      		nSaldo -= aCols[xS][nQTDSCP]
      	EndIf
      Next
      
      If nQuant > nSaldo //saldo atual - qtde empenhada de S.A.(solicitacao ao almoxarifado)
         MSGBOX('A Quantidade Solicitada é Maior que a Disponivel no Estoque, Favor Verifique!!',OemToAnsi('Atenção'),'ALERT')
         _lRet:=.F.
      Endif
   Else 
      MSGBOX(OemToAnsi('Não Existe o cadastro deste Produto no Estoque, Favor Verifique !!!!'),'Estoque','ALERT')
      _lRet:=.F.
   Endif

	If Len(Alltrim(cCTSCP)) <= 5
		MSGBOX('Esta conta contabil incorreta .','Digitacao invalida','ALERT')
		_lRET:=.F.	  
	Endif         


	SB1->(dbSetOrder(1))
	SBM->(dbSetOrder(1))	
	If SB1->(dbSeek(xFilial("SB1")+cProd))
	
	   SBM->(DbSeek(xFilial("SBM")+SB1->B1_GRUPO,.T.))		// Procura no SBM o grupo digitado na solicitacao

		Do Case 
      			//edenilson
				   Case SM0->M0_CODIGO == "NH"  //empresa new hubner	
		         If substr(cCC,1,1) $ "1/2"
			        ACOLS[N][nCTSCP] := SBM->BM_CTAADM
			     Else // Empresa Fundição
                    ACOLS[N][nCTSCP] := SBM->BM_CTADIR			     
			     Endif                                       
		   Case SM0->M0_CODIGO == "FN"  //empresa new hubner				     
		         If substr(cCC,2,1) $ "3/4"
				    ACOLS[N][nCTSCP] := SBM->BM_CTADIR
				 ElseIf substr(cCC,2,1) $ "7"
					ACOLS[N][nCTSCP] := SBM->BM_CTAINOV				 
				 Else // Empresa Fundição
			        ACOLS[N][nCTSCP] := SBM->BM_CTAADM
				 Endif	   
			Case SM0->M0_CODIGO == "IT"
		         If substr(cCC,1,2) $ "13/33/63/34/64
			    	ACOLS[N][nCTSCP] := SBM->BM_CTADIR
				 ElseIF substr(cCC,1,2) $ "11/12"
			        ACOLS[N][nCTSCP] := SBM->BM_CTAADM
			   	 ElseIF substr(cCC,1,2) $ "65/35"
			        Alert("Centro de Custo de resultado, não pode ser utilizado começando com 65/35!")
			        Return .f.
				 Endif	   
		EndCase
		
	/*
		//-- M R P Ferramentas - Verifica se o que já foi solicitado até o momento
		//-- é maior do que o consumo planejado para a semana
		//-- levando em consideração a semana da solicitação
		If AllTrim(SB1->B1_GRUPO)$"FE31/FE32/FE33/FE35"
			
			dDt1 := StoD(StrZero(Year(date()),4)+StrZero(Month(date()),2)+"01")
			dDt2 := StoD(StrZero(Year(date()),4)+StrZero(Month(date()),2)+StrZero(UltimoDia(date()),2))
			nD   := Ceiling(day(date()) / 7) //arredonda para cima
			nCP  := U_MRPFCons(SB1->B1_COD,dDt1,dDt2)
			nQJS :=  fQtdJaSol(SB1->B1_COD,dDt1,dDt2)
			
			If(nQJS+aCols[n][nQTDSCP] > ((nCP/4) * nD))
				MsgBox("O Consumo Planejado mensal para esta ferramenta é de: " + AllTrim(Str(nCP)) +"."+chr(13)+chr(10)+;
					   "Até o momento já foram retiradas " + AllTrim(Str(nQJS)) + " ferramentas!","Aviso","INFO")
			EndIf
		EndIf
	*/
	Endif

Return(_lRet)  

/*
Static Function fQtdJaSol(cProd,dDt1,dDt2)
Local cAl := 'QJASOL'
Local nQuant := 0

	beginSql Alias cAl
		SELECT
			SUM(D3_QUANT) as quant
		from
			%table:SD3% SD3
		where
			SD3.D3_FILIAL = %xFilial:SD3%
			and SD3.D3_TM > 500
			and SD3.D3_COD = %Exp:cProd%
			and SD3.D3_LOCAL = '31'
			and SD3.D_E_L_E_T_ = ' '
			and SD3.D3_ESTORNO <> 'S'
			and SD3.D3_EMISSAO BETWEEN %Exp:DtoS(dDt1)% AND %Exp:DtoS(dDt2)%
	endSql

   	If !(cAl)->(Eof())
  	 	nQuant := (cAl)->quant //-- media de consumo por mes dos ultimos 180 dias
	EndIf
          
	(cAl)->(dbCloseArea())

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICA SE A FERRAMENTA ESTÁ SENDO REQUISITADA A MAIS DO QUE O PREVISTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fPrevisto(cProd,cCC)
Local cAl := GetNextAlias()
Local dti := StrZero(year(date()),4)+StrZero(Month(date()),2)+'01'
Local dtf := DtoS(ultimodia(StoD(dti)))
Local nPrv    := 0
Local nPrvDia := 0
Local aSemana := {}
Local xAux    := 1
Local dPrim   := StoD(dti)
Local dUlt    := CtoD('  /  /  ')
Local nDias   := 0

	//-- Este For monta um array contendo as semanas do mes, cada posicao com a data inicial e final de cada semana.
	For xD := StoD(dti) to StoD(dtf)
		
		nDias++

		//-- guarda a posicao do array que está o dia de hoje
		If xD == date()
			nAux := len(aSemana) + 1
		EndIf
		
		If Dow(xD) == 1 //se for o primeiro dia da semana
			dPrim := xD
		ElseIf DoW(xD) == 7 .or. xD==StoD(dtf)// se for o ultimo dia da semana
			dUlt := xD
			aAdd(aSemana,{dPrim,dUlt,nDias})
			nDias := 0
		EndIf
		
	Next

	beginSql Alias cAl
	
		SELECT 
			ZDJ_FERRAM fer,
			SUBSTRING(ZDJ_CC,1,1)+'4'+SUBSTRING(ZDJ_CC,3,6) cc,
			prev = SUM(ROUND (
				CASE
					WHEN SUBSTRING(ZDJ.ZDJ_FERRAM,1,4)='FE33' THEN
						quant / ROUND((ZDJ.ZDJ_VUMONT * (ZDJ.ZDJ_QTREAF+1) * ZDJ.ZDJ_ARESTA) / ZDJ.ZDJ_FMONT ,2)
					ELSE
						quant / ROUND((ZDJ.ZDJ_VUMONT * (ZDJ.ZDJ_QTREAF+1)),2)
				END
			,2))
		
			, consumon = (
				SELECT 
					SUM(D3_QUANT)
				FROM 
					SD3FN0 D3 (NOLOCK)
				WHERE
					D3.D_E_L_E_T_ = ' '
					AND D3.D3_COD = ZDJ.ZDJ_FERRAM	
					AND D3.D3_CC = SUBSTRING(ZDJ_CC,1,1)+'4'+SUBSTRING(ZDJ_CC,3,6)
					AND D3.D3_EMISSAO BETWEEN %Exp:dti% and %Exp:DtoS(aSemana[nAux][2])%
					AND D3.D3_TM > 500
					AND D3.D3_ESTORNO != 'S'
			) 
			, consumor = (
				SELECT 
					SUM(D3_QUANT)
				FROM 
					SD3FN0 D3 (NOLOCK)
				WHERE
					D3.D_E_L_E_T_ = ' '
					AND D3.D3_COD = SUBSTRING(ZDJ.ZDJ_FERRAM,1,3)+'5'+SUBSTRING(ZDJ.ZDJ_FERRAM,5,11)
					AND D3.D3_CC = SUBSTRING(ZDJ_CC,1,1)+'4'+SUBSTRING(ZDJ_CC,3,6)
					AND D3.D3_EMISSAO BETWEEN %Exp:dti% and %Exp:DtoS(aSemana[nAux][2])%
					AND D3.D3_TM > 500
					AND D3.D3_ESTORNO != 'S'
			) 
		
		FROM
			ZDJFN0 ZDJ (NOLOCK),
			(
				SELECT
					HC_PRODUTO prod,
					SUM(HC_QUANT) quant
				FROM
					SHCFN0 HC (NOLOCK)
				WHERE
					HC_DATA BETWEEN %Exp:dti% AND %Exp:dtf%
					AND HC.D_E_L_E_T_ = ' '
				GROUP BY HC_PRODUTO
			) QTD
		
		WHERE QTD.prod = ZDJ_PROD
			and ZDJ.D_E_L_E_T_ = ' '
			and ZDJ.ZDJ_FERRAM = %Exp:cProd%
			and ZDJ.ZDJ_CC = %Exp:cCC%
		GROUP BY 
			ZDJ_FERRAM,
			SUBSTRING(ZDJ_CC,1,1)+'4'+SUBSTRING(ZDJ_CC,3,6)
	
	endSql
	
	nPrvDia := (cAl)->prev / Day(StoD(dtf))
	nPrv := Round(nPrvDia * Day(aSemana[nAux][2]),0)
	
	If (cAl)->(!Eof())
	
		alert('Consumo até '+dtoc(date())+': '+str(((cAl)->consumon + (cAl)->consumor))+chr(13)+chr(10)+;
		      'Previsão até '+dtoc(date())+': '+str( nPrv))
		      
	   	If ((cAl)->consumon + (cAl)->consumor) >= nPrv
			(cAl)->(dbCloseArea())
			Return .F.
	  	EndIf
	
	EndIf

	(cAl)->(dbCloseArea())
	
Return .T.
*/