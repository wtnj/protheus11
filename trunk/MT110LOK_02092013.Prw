/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT110LOK        ³ Alexandre R. Bento    ³ Data ³ 11/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto de entrada q traz lead time do produto e soma na data³±±
±±³          ³ Entrega prevista e o usuario não pode alterar p/ baixo    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto de entrada para validação da linha do acols         ³±±
±±³          ³ na abertura de SC.								         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "topconn.ch"
#include "rwmake.ch"   

User Function MT110LOK()

Local _nCod   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C1_PRODUTO"})  
Local _nData  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C1_DATPRF"})  
Local _nCC    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C1_CC"})  
Local _nCCU   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C1_CCU"})  
Local _nConta := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C1_CONTA"})  
Local _nOS    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C1_NUMOS"})     
Local _nVlr   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C1_VUNIT"})  
Local _nQtd   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C1_QUANT"})
Local _nNF    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C1_NFSAIDA"})
Local _nSer   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C1_SERSAI"})
Local _nLocal := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C1_LOCAL"})

Local _lOK    := .T.  
Local _dData  := Ddatabase

Local lin 			:= 500
Local _cDescSe
Local _nLinha
Local _nx
Local _aOSAtiv      := {}
Local _nVlrCon      := 0
Local _cOk          := .T.
Local _lPri         := .F.
Local _nTotA  := 0
Local _nTotC  := 0  
Local _nTotG  := 0  
Local _nGTotA := 0
Local _nGTotC := 0
Local _nGTotG := 0
Local _nVlrPed := 0
Local _nVlrGas := 0
Local _nVGasIt := 0
Local _nVlrGTo := 0 
Local _cTipo   := Space(01)
Local _nTotAprv := 0
Local cBloqAlm  := ""

//Se for executado a partir da rotina de MRP, não considera esta validação
If AllTrim(Upper(FunName()))$"MATA710/PWHBM001"
	Return .T.
EndIf

If !Acols[n][len(aHeader)+1]  //nao pega quando a linha esta deletada
              
	SB1->(dbsetorder(1)) //filial + cod
	If !SB1->(Dbseek(xFilial("SB1")+Acols[n][_nCod] ))
		Alert('Produto não encontrado!')
	Endif

	IF SM0->M0_CODIGO$"IT"
	
		/*
		_lOK := .F.
	
		If SB1->B1_GRUPO$"MM60/MM61/MM62/MM30/MM31/MM32/SA09/SA36" .AND.  Upper(AllTrim(cUserName))$"LUIZ.SANTOS/ISABELLE.DELIGA/JEFFERSON.CHAFRANSKI"
			_lOK := .T.
		ElseIf Substr(SB1->B1_GRUPO,1,2)$"MS" .AND. Upper(AllTrim(cUserName))$"CRISTINA.ROCHINSKI/LUCIANOC"
			_lOK := .T.
		ElseIf Substr(SB1->B1_GRUPO,1,2)$"MF" .AND. Upper(AllTrim(cUserName))$"EMANUELE.RIBAS/MURILO.ARAUJO/JOAOFR"
			_lOK := .T.
		ElseIf Substr(SB1->B1_GRUPO,1,2)$"FE" .AND. Upper(AllTrim(cUserName))$"NILSON.RENOSTO/EMANUELE.RIBAS"
			_lOK := .T.
		ElseIf Substr(SB1->B1_GRUPO,1,2)$"ML/PQ/MS/MG/MM/MX/MK/MF/OL/PQ/EB" .AND. Upper(AllTrim(cUserName))$"CRISTINA.ROCHINSKI/WAGNER.FERREIRA/PRISCILA.PRINZ"
			_lOK := .T.
		ElseIf Substr(SB1->B1_GRUPO,1,2)$"EB" .AND. Upper(AllTrim(cUserName))$"WILIAN.BLAGINSKI/LUCIANOC"
			_lOK := .T.
		ElseIf Substr(SB1->B1_GRUPO,1,2)$"MK/SA" .AND. Upper(AllTrim(cUserName))$"CLEVERSON.ANTUNES"			
			_lOK := .T.
		Endif

		If !_lOK
			Alert("Usuário sem permissão para solicitar produtos do grupo "+SB1->B1_GRUPO+"!")
			Return .f.

		endif
        */
        
	ENDIF
	

    //--OS Nº 047979
	//-- nao permite realizar SC para produtos que possuem contrato de parceria (pedido em aberto) pendente
                           
	//-- CHAMADO: 048643
	//-- exceção para os tipos
	If !SB1->B1_TIPO$"MP/CP/BN/EB"

	    SC3->(dbsetorder(3))//C3_FILIAL+C3_PRODUTO+C3_NUM+C3_ITEM
		SY1->(dbSetOrder(3)) // Y1_FILIAL+Y1_USER                                                                                                                                               
	
	    If SC3->(dbseek(xFilial('SC3')+aCols[n][_nCod]))
	    	While SC3->(!EOF()) .AND. Alltrim(SC3->C3_PRODUTO)==Alltrim(aCols[n][_nCod])
	    	
	    		If Empty(SC3->C3_RESIDUO) .AND. SC3->C3_CONAPRO<>"B" .AND. SC3->C3_QUJE<SC3->C3_QUANT
	
					If !SY1->(dbSeek(xFilial('SY1')+__cUserID))
		    			Alert('Produto não pode ser comprado através de SC, pois é comprado através de Pedido em Aberto (Contrato)!')
    					Return .F.
    				Endif

	    		Endif
	    
	    		SC3->(dbskip())
	        Enddo
		Endif
	Endif
	//-- FIM OS 048643
	//-- FIM OS 047979
            
    //-- Validação adicional para verificar se a conta contábil está bloqueada
    CT1->(dbSetOrder(1)) //-- CT1_FILIAL+CT1_CONTA 
    If CT1->(dbSeek(xFilial("CT1")+aCols[n][_nConta]))
    	If ALLTRIM(CT1->CT1_BLOQ)$"1"
			Alert('Conta Contábil encontra-se bloqueada para uso. Favor entrar em contato com o setor de Controladoria!')
			Return .F.    		
    	Endif
    Else
    	Alert('Conta Contábil não encontrada!')
    	Return .F.
    Endif

    /**
     * Chamado 007916 do helpdesk
     */   
    //-- valida conta contábil
    If !U_NHEST165(aCols[n][_nCC],aCols[n][_nConta],aCols[n][_nCod])
    	Return .F.
	EndIf
     
    If Subs(Acols[n][_nCod],1,3)$"MOD"
	   Msgbox(" O Produto Selecionado Nao Pode ser Comprado!","Usuário não autorizado","ALERT")
       _lOk := .F.    
    Endif

	//-- EMPRESA FUNDIÇÃO

	If SM0->M0_CODIGO=='FN'
   		
   		//CHAMADO 016382
   		/* Tirado por Alexandre, pois todas as plantas utilizam estes codigos, assim não é exclusividade tal uso.
   		If AllTrim(SB1->B1_GRUPO)$"MM30/MM31/MM32"
   			If !Upper(AllTrim(cUserName))$"ALINEBM/CLAUDIOSA/DERLIKD/GUILHERMEO/LEONARDOJB/FABRICIOCP/GERALDOF/JOSEFH/ROGERIOJS/LUISC/ANDRELA/FERNANDOP/LEANDROJS"
   				Msgbox(" Usuário sem permissão para solicitar produto desse grupo (MM30,MM31,MM32)! ","Usuário não autorizado","ALERT")
   				_lOk := .F.
   			EndIf
   		EndIf
   		//CHAMADO 016382
   		If AllTrim(Acols[n][_nCod])$"SA09.000011/SA36.000002"
   			If !Upper(AllTrim(cUserName))$"ALINEBM/CLAUDIOSA/DERLIKD/GUILHERMEO/LEONARDOJB/FABRICIOCP/GERALDOF/JOSEFH/ROGERIOJS/LUISC/ANDRELA/FERNANDOP/LEANDROJS/JEFERSONAV"
   				Msgbox(" Usuário sem permissão para solicitar produto desse código! ","Usuário não autorizado","ALERT")
   				_lOk := .F.
   			EndIf
   		EndIf
   		 */
		
		//-- CONFORME SOLICITAÇÃO DE VEIGA, BRAGA, FREDERICH E E-MAIL ENVIADO AO MARCOSVS
		If AllTrim(aCols[n][_nLocal])$"21/22/2E" .and. ;
			ALLTRIM(SB1->B1_TIPO)$"MA/MP" .AND. !Upper(AllTrim(cUserName))$"LUCIANODB/REGINALDOAR/EVALDOMC/MARLONCM/ADMIN/JOAOFR"
			
			Msgbox("Usuário sem permissão para solicitar produto do tipo "+ALLTRIM(SB1->B1_TIPO)+"! Somente Almoxarifado!",;
			"Usuário não autorizado, Somente Almoxarifado!","ALERT")
			RETURN .F.
		EndIf
		//-- Fim

	    If SM0->M0_CODIGO$"IT"
		   If SUBSTR(SB1->B1_COD,1,2)$'FE' .AND. !Upper(AllTrim(cUserName))$"NILSON.RENOSTO/MAXWEL.ROCHA/ADMINISTRADOR"
		      Msgbox("Usuário sem permissão para solicitar produto FE, Somente o depto Central de Ferramentas esta autorizado!",;
			  "Usuário não autorizado, Somente Central de Ferramentas!","ALERT")
			   RETURN .F.
		   Endif   
		EndIf
		
		//-- OS Nº: 042863
		If AllTrim(aCols[n][_nLocal])$"41" .and. ;
			SUBSTR(SB1->B1_GRUPO,1,2)$'MM' .AND. !ALLTRIM(SB1->B1_GRUPO)$"MM15/MM14/MM50" .AND. !Upper(AllTrim(cUserName))$"JOSIASAS/ADMIN/JOAOFR/EDINAPN"
			
			Msgbox("Usuário sem permissão para solicitar produto do grupo "+ALLTRIM(SB1->B1_GRUPO)+"! Somente Manutenção Forjaria!",;
			"Usuário não autorizado, Somente Manutenção Forjaria!","ALERT")
			RETURN .F.
		EndIf
		//-- Fim OS Nº: 042863
					   		 
		//-- OS Nº: 034146
		If AllTrim(aCols[n][_nLocal])$"21" .and. ;
			ALLTRIM(SB1->B1_COD)$"SA09.000006/"+;
			"SA09.000007/"+;
			"SA09.000008/"+;
			"SA09.000009/"+;
			"SA09.000010/"+;
			"SA09.000011/"+;
			"SA09.000012/"+;
			"SA09.000013/"+;
			"SA09.000014/"+;
			"SA09.000015/"+;
			"SA09.000016/"+;
			"SA09.000017/"+;
			"SA09.000018/"+;
			"SA09.000019" .AND. !Upper(AllTrim(cUserName))$"THIAGOL/VILMARTW/LUCIANODB/REGINALDOAR/NERBALBJ/FABIOWC/ALINEBM/DOUGLASG/KELLYTB/CRISTIANOS/RUICR/FRANCISVB/DIOGOAS/IGORJC/RODRIGOBR/ISMAELP/EDINAPN/THIAGOL/CAMILATS"
			
			Msgbox("Usuário sem permissão para solicitar produto "+ALLTRIM(SB1->B1_COD)+"! Somente Manutenção!",;
			"Usuário não autorizado, Somente Manutenção!","ALERT")
			_lOk := .F.
		EndIf
		//-- Fim OS Nº: 034146
		
		//-- chamado 031001
		//-- data: 14/05/2012
		If AllTrim(SB1->B1_GRUPO)$'MM01/MM02/MM03/MM04/MM05/MM06/MM07/MM08/MM09/MM10/MM11/MM12/MM13/MM14/MM15/MM16/MM17/MM18/MM19'.OR. ALLTRIM(SB1->B1_COD)$"SA09.000011"
			If AllTrim(aCols[n][_nLocal])$"21" .AND. !Upper(AllTrim(cUserName))$"JONATHAGS/VILMARTW/LUCIANODB/REGINALDOAR/ANTONIOFS/NERBALBJ/FABIOWC/ALINEBM/DOUGLASG/KELLYTB/CRISTIANOS/RUICR/FRANCISVB/DIOGOAS/IGORJC/THIAGODS/THIAGOMS/THIAGOL/RODRIGOBR/EDINAPN/ISMAELP/RUICR/CAMILATS"
					Msgbox("Usuário sem permissão para solicitar produto "+Iif(ALLTRIM(SB1->B1_COD)$"SA09.000011",ALLTRIM(SB1->B1_COD),"do grupo "+alltrim(SB1->B1_GRUPO))+"!",;
				"Usuário não autorizado, Somente Manutenção!","ALERT")
				_lOk := .F.
			EndIf
		EndIf
		//-- fim chamado 031001
		
		//-- OS 11092
		If !ALLTRIM(SB1->B1_GRUPO)$"FE31/FE32/FE33/FE35"
			If SB1->B1_LT > 0
				_dData :=  _dData + SB1->B1_LT
				If Acols[n][_nData] < _dData //Verifica se o usuario alterou a data a baixo do lead time
					Msgbox("Atencao A Data de Necessidade nao Pode ser Menor que a Data Atual"+CHR(13)+;
					" mais o Lead Time do Produto ","Solicitação de Compra","ALERT" )
					//	Acols[n][_nData] := _dData
				Endif
			Endif
		EndIf
		//-- FIM OS 11092
		 
		If ALLTRIM(SB1->B1_GRUPO)$"SA98"
			Msgbox("Produto Destinado a Venda e Nao pode ser Comprado!","Usuário não autorizado","ALERT")
			_lOk := .F.
		EndIf
		
		If Alltrim(Acols[n][_nCC])$"ALMOXARI" .And. SB1->B1_TIPO$"SA"
			MsgBox("Informe o Centro de Custo onde Será Efetuado o Servico, pois Servicos não Podem ser Estocados no Almoxarifado","Atencao","ALERT")
			_lOK := .F.
		Endif

	  	//-- CHAMADO 019853 do portal
   	  	If !Alltrim(cUserName)$"TIAGOJ/DIOGOBA/GLEBERG/FABIOJF/PETERSONAP" .and. ALLTRIM(SB1->B1_TIPO)$"MM" .AND. Alltrim(Acols[n][_nCC])$"54001001"
	   	 	Alert("Para produtos do tipo MM e C.Custo 54001001, somente autorizado para pessoal da Manutenção!")
   	  	 	Return .F.
      	EndIf

  	  	//-- CHAMADO 030034 PORTAL WHB
  	  	//-- ALTERADO PELO CHAMADO 036304
   	  	If !Alltrim(cUserName)$"PATRICIAFF/MARCELOP" .AND. Alltrim(Acols[n][_nCC])$"33005002"
	   	 	Alert("Para C.Custo 33005002, somente autorizado para PATRICIAFF / MARCELOP!")
   	  	 	Return .F.
      	EndIf
      	
      	//-- CHAMADO  PORTAL WHB  	
      	//-- exceto produto de serviços de informatica - 05/08/2013 - joaofr
   	  	If !Alltrim(cUserName)$"VILMARTW/JONATHAGS/KELLYTB/NERBALBJ" .AND. Alltrim(Acols[n][_nCC])$"23005001"  .and. !ALLTRIM(SB1->B1_COD)$"SA08.000001"
	   	 	Alert("Para C.Custo 23005001, somente autorizado para VILMARTW / JONATHAGS / KELLYTB / NERBALBJ !")
   	  	 	Return .F.
      	EndIf

   	  	If !Alltrim(cUserName)$"LUCIANODB/REGINALDOAR/PAULORG/BRUNORF/JOAOFS/OSNIRZ/GUILHERMEMB/JOAOFR" .and. AllTrim(aCols[n][_nLocal])$"21" .AND. (ALLTRIM(SUBSTR(SB1->B1_GRUPO,1,2))$"MX" .OR. ALLTRIM(SB1->B1_GRUPO)$"MS01")
	   		Alert("Para produtos do tipo MX ou grupo MS01, e armazém 21, somente autorizado para pessoal do Almoxarifado!")
   	  	 	Return .F.
      	EndIf

   	  	If Alltrim(cUserName)$"LUCIANODB/REGINALDOAR/PAULORG/BRUNORF/JOAOFS" .and. !AllTrim(aCols[n][_nLocal])$"21" .AND. (ALLTRIM(SB1->B1_TIPO)$"MX" .or. ALLTRIM(SB1->B1_GRUPO)$"MS01") 
	 	 	Alert("Usuário só permitido para requisitar este produto para armazém 21!")
   	 	 	Return .F.
      	EndIf

      	If Subs(AllTrim(Acols[n,_nCC]),1,1)$"2" .AND. !Subs(AllTrim(Acols[n,_nLocal]),1,1)$"2" 
         	MsgBox("Para Este Centro de Custo, Favor Informar Almoxarifado Começando com 2","Atencao","ALERT")
	     	_lOK := .F.   
      	ElseIf Subs(AllTrim(Acols[n,_nCC]),1,1)$"3" .AND. !Subs(AllTrim(Acols[n,_nLocal]),1,1)$"3" 	     
         	MsgBox("Para Este Centro de Custo, Favor Informar Almoxarifado Começando com 3","Atencao","ALERT")
	     	_lOK := .F.                                                                   
      	ElseIf Subs(AllTrim(Acols[n,_nCC]),1,1)$"4" .AND. !Subs(AllTrim(Acols[n,_nLocal]),1,1)$"4" 	     
         	MsgBox("Para Este Centro de Custo, Favor Informar Almoxarifado Começando com 4","Atencao","ALERT")
	     	_lOK := .F.                                                                   
      	ElseIf Subs(AllTrim(Acols[n,_nCC]),1,1)$"5" .AND. !Subs(AllTrim(Acols[n,_nLocal]),1,1)$"5" 	     
        	MsgBox("Para Este Centro de Custo, Favor Informar Almoxarifado Começando com 5","Atencao","ALERT")
	     	_lOK := .F.                                                                   
      	Endif

	    //OS: 004204
	    //C.C. IMOBILIZ só deverá estar liberado para produtos IM19
	    If AllTrim(Acols[n,_nCC])$"IMOBILIZ" .AND. !AllTrim(SB1->B1_GRUPO)$"IM19"
	    	Alert("Somente produtos do grupo IM19 podem ser solicitados no C.Custo IMOBILIZ!")
	      	Return .F.
	    EndIF
		  	  
		//OS:003797
		//Bloqueia os produtos genérico e imobilizado para o C.Custo ALMOXI
		If Alltrim(Acols[n][_nCC])$"ALMOXARI"
			If AllTrim(SB1->B1_TIPO)=="IM"
				Alert("C.Custo não pode ser ALMOXARI para produtos do tipo IMOBILIZADO!")
				_lOk := .F.
			EndIf
			
			If "GENERICO"$SB1->B1_DESC
				Alert("C.Custo não pode ser ALMOXARI para produtos GENÉRICOS!")
				_lOk := .f.
			EndIf
		EndIf       
		             
		// -----------------------------------------------------------------------------------------------------------------------------------------------
						
		// OS 053354
		// Bloqueio de CC da qualidade em Pernambuco
		If SM0->M0_CODFIL=='02' .AND. Alltrim(Acols[n][_nCC])$"53006001" .AND. !Alltrim(UPPER(cusername))$"MARCOMA/JOAOCM/DOUGLASSD/VALMIRP/JOAOFR"
		   Alert('Este Centro de Custo não Pode ser Utilizado, Favor entrar em Contato com o Depto da Qualidade Pernambuco')
		   _lOK := .F.	
		EndIf		
		
		If Subs(Acols[n][_nCC],2,1)$"5" .And. !SB1->B1_TIPO$"PA/BN/FR" .And. !Alltrim(Acols[n][_nCod])$"SA10.000005/SA10.000001" //fundicao cc iniciando com 4 ou 5
			MsgBox("Este Centro de Custo não Pode ser Utilizado, Favor entrar em Contato com o Depto de Custos","Atencao","ALERT")
			_lOK := .F.
		Endif
		
		If Subs(Alltrim(Acols[n][_nCod]),1,2)$"FE"
			If Empty(Acols[n][_nCCU]) .and. !Alltrim(upper(FunName()))$"MATA410/MATA460/MATA461/MATA460A"
				MsgBox("O Centro de Custo onde é Usada a Ferramenta deve ser Preenchido !!!","Atencao","ALERT")
				_lOK := .F.
			Endif
		Endif
		
		//-- solicitado por rogerio contabilidade
		If (Subs(Alltrim(Acols[n][_nConta]),1,8)$"10302013" .Or. Subs(Alltrim(Acols[n][_nConta]),1,5)$"10402") .And. Empty(Alltrim(Acols[n][_nOS]))
			Msgbox(OemToAnsi("Para Esta Conta Contabil é Obrigatório o Preenchimento do Campo com o Numero da O.S. do Ativo"),"Solicitação de Compra","ALERT" )
			_lOK := .F.
		Endif 
		
		//-- solicitado por PatriciaFF
		If (!Empty(Alltrim(Acols[n][_nOS])) .AND. Subs(Alltrim(Acols[n][_nOS]),1,2)$'DF' .AND. !Alltrim(UPPER(cusername))$"PATRICIAFF")
			Msgbox(OemToAnsi("Somente o login PATRICIAFF está autorizado a emitir SC de novos projetos (DF)"),"Solicitação de Compra","ALERT" )
			_lOK := .F.
		Endif
		
		If !Subs(Alltrim(Acols[n][_nConta]),1,5)$"10302" .And. Subs(Alltrim(Acols[n][_nCod]),1,2)$"IM" .And. !Alltrim(Acols[n][_nCod])$"IM09.000001/IM99.000001" //software (lei protecao intelectual)
			Msgbox(OemToAnsi("Para Esta Conta Contabil é Obrigatório Colocar o Produto Iniciando com IM"),"Solicitação de Compra","ALERT" )
			_lOK := .F.
		Endif
		
		If Subs(Alltrim(Acols[n][_nCod]),1,2)$"IM" .And. Alltrim(Acols[n][_nCC])==Iif(SM0->M0_CODIGO$"FN/IT","DIFERIDO","DIFERI")
			Msgbox("Para Este Produto nao Pode-se Utilizar Este Centro de Custo ","Solicitação de Compra","ALERT" )
			_lOK := .F.
		Endif
		
		If  !Alltrim(UPPER(cusername))$"LUISC/ADACIRD/HESSLERH/LUPERCIOC/ADMINISTRADOR/DIOGOBA/ANDERSONSC"  .And. Alltrim(Acols[n][_nCod])$"SA51.000016"
			Msgbox("Este Produto Só pode ser Utilizado pela Logistica, Favor Verificar!!! ","Solicitação de Compra","ALERT" )
			_lOK := .F.
		Endif
		
		If  AllTrim(aCols[n][_nLocal])$"31" .And. !Alltrim(UPPER(cusername))$"JOSEAM/ADACIRD/ANTONIORL/REJIANEPL/ADMINISTRADOR/DOUGLASSD/ANDERSONSC"  .And. Subs(Alltrim(Acols[n][_nCod]),1,4)$"MX01/MG01"
			Msgbox("Este Produto Somente Almox. podem Utilizar ","Solicitação de Compra","ALERT" )
			_lOK := .F.
		Endif
		
		If  AllTrim(aCols[n][_nLocal])$"31" .And. !Alltrim(cusername)$"LEANDROJS/LUISC/BEATRIZMS/ANDERSONSC/ALEXANDRERB/ADMINISTRADOR/JOAOFR"  .And. Subs(Alltrim(Acols[n][_nCod]),1,4)$"MX02"
			Msgbox("Este Produto e Almoxarifado Somente a Informatica podem Utilizar ","Solicitação de Compra","ALERT" )
			_lOK := .F.
		Endif
		
	Endif		

	//EMPRESA USINAGEM

	If SM0->M0_CODIGO=="NH"
		
	    /*
	    
	    -- COMENTADO POR JOAOFR, POIS NÃO EXISTE ARMAZEM 51 NA USINAGEM OU CCUSTO ALMOXI NA FUNDICAO
	    
	    //SOLICITADO PELO DIOGOBA PARA BLOQUEAR SOLICITAÇÃO DE COMPRA FEITA AO ALMOXARIFADO DO ARMAZEM 51
	    If Alltrim(aCols[n][_nCC])$"ALMOXI" .AND. AllTrim(aCols[n][_nLocal])$"51"
	  		If !ALLTRIM(UPPER(cUserName))$"DIOGOBA/ANDERSONSC/DANILOCS/CARLOSPS/CUSTODIOFS"
	   			Alert("Usuario nao permitido para fazer solicitação de compra para ALMOXI do Armazem 51!")
	   			_lOk := .F.
	   		EndIf
	    EndIf

        */

   		If ALLTRIM(SB1->B1_GRUPO)$"MA01"
   			If !ALLTRIM(UPPER(cUserName))$"LEANDROJS/LUISC"
   				Msgbox("Produtos MA01 somente permitido para o almoxarifado!","Usuário não autorizado","ALERT")
   				_lOk := .F.
   			EndIf
   		EndIf
	
	    If Alltrim(Acols[n][_nCC])$"ALMOXI" .And. SB1->B1_TIPO$"SA"  
		    MsgBox("Informe o Centro de Custo onde Será Efetuado o Servico, pois Servicos não Podem ser Estocados no Almoxarifado","Atencao","ALERT")
	   		_lOK := .F.
	   	Endif

	  	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  	//³ LIBERA SC PARA DETERMINADOS TIPOS DO PRODUTO OU DETERMINADOS USUARIOS ³
	  	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If !Alltrim(cUserName)$"DERLIKD/ANDREAG/BEATRIZMS/DIEGONB/SILMARAMC/ANGELAPS/MARCOSR/ADMINISTRADOR/ROBERTOSE/JUCINEIAT/MARCOSD/ERICALP/ANAPM/ALEXANDRERB/LUPERCIOC/GLEISONJP/LEANDRAAS" .and. ;
			!ALLTRIM(SB1->B1_TIPO)$"MS/SA/PQ/MD" .AND. ;
			!AllTrim(SB1->B1_COD)$"ME01.000004/ME01.000006/ME01.000021/ME01.000008"
			Alert("Não é permitido fazer S.C. pela Usinagem, exceto exceções definidas pelo setor de Compras!")
			Return .F.
		EndIf
		   
      	//OS: 004204
      	//C.C. IMOBIL só deverá estar liberado para produtos IM15
      	If AllTrim(Acols[n,_nCC])$"IMOBIL" .AND. !AllTrim(SB1->B1_GRUPO)$"IM15"
      		Alert("Somente produtos do grupo IM15 podem ser solicitados no C.Custo IMOBIL!")
      		Return .F.
      	EndIF
      
      	//OS: 002651 
      	// BLOQUEIA OS ITENS GENERICOS PARA O C.CUSTO ALMOXI
		cBloqAlm := "ML01.000013/" //ACUCAR CRISTAL
		cBloqAlm += "ML01.000012/" //CHA NESTEA
		cBloqAlm += "MS02.000051/" //PLACAS DE SINALIZAÇÃO
		cBloqAlm += "MX01.000033/" //cartões de visita
		cBloqAlm += "FE01.000000/"
		cBloqAlm += "MX01.000207/" //genérico
		cBloqAlm += "MA01.000001/"
		cBloqAlm += "MX01.000087/"
		cBloqAlm += "MX02.000039/"
		cBloqAlm += "MM02.003263/"
		cBloqAlm += "MS02.000001/"
		cBloqAlm += "MX02.000047/" //memoria
		cBloqAlm += "MX02.000053/" //materiais aplicados
		cBloqAlm += "MM02.003263/" //SERVIÇOS
		cBloqAlm += "FE01.000000"
		
		If Alltrim(Acols[n][_nCC])$"ALMOXI" .AND. ALLTRIM(SB1->B1_COD)$cBloqAlm
			Alert("C.Custo não pode ser ALMOXI para este produto!")
			_lOk := .F.
		EndIf
		
		If Subs(Acols[n][_nCC],1,1)$"5" .And. !SB1->B1_TIPO$"PA/BN"  //Usinagem cc inicando com 5
			MsgBox("Este Centro de Custo não Pode ser Utilizado, Favor entrar em Contato com o Depto de Custos","Atencao","ALERT")
			_lOK := .F.
		Endif
		
	  	If !Subs(Alltrim(Acols[n][_nConta]),1,5)$"10302" .And. Subs(Alltrim(Acols[n][_nCod]),1,2)$"IM" .And. !Alltrim(Acols[n][_nCod])$"IM10.000001" //software (lei protecao intelectual)
		    Msgbox(OemToAnsi("Para Esta Conta Contabil é Obrigatório Colocar o Produto Iniciando com IM"),"Solicitação de Compra","ALERT" )  
		    _lOK := .F.
		Endif
	
		/*----------------------------------*
		* Incluído por João Felipe da Rosa *
		* Desc: Valida N.F. e Série        *
		* Data: 09/07/2008                 *
		*----------------------------------*/
	  	SF2->(DbSetOrder(1)) // filial + doc + serie
	  	If !Empty(Acols[n][_nNF])
	     	If !SF2->(DbSeek(xFilial("SF2")+Acols[n][_nNF]+Acols[n][_nSer]))
	    		MsgBox(OemToAnsi("Nota Fiscal de Saida nao encontrada. Favor Verificar!"),"Nota Fiscal","ALERT")
	    		_lOK := .F.
	     	EndIf
	  	EndIf
	
	Endif

	//-- EMPRESAS USINAGEM E FUNDICAO
   	If ALLTRIM(UPPER(SM0->M0_CODIGO))$"FN/NH/IT"

   		If Alltrim(Acols[n][_nCC])==Iif(SM0->M0_CODIGO=="FN/IT","DIFERIDO","DIFERI")
   		
   			If !Alltrim(cusername)$"Administrador/ANDREACP/PATRICIAFF/ALINEBM/JULIANAGY/GLEISONJP/SAMUELCF/CRISVALDOM/SILMARAM/EDINAPN"
	      		Msgbox("Para o Centro de Custo DIFERI Somente a PATRICIAFF Pode Incluir Solicitacao ","Solicitação de Compra","ALERT" )
    	  		_lOK := .F.
   			Endif

	   		//foi inserido a pedido do rogerio da contabilidade em 02/08/07
	   		If Subs(Alltrim(Acols[n][_nCod]),1,2)$"IM"
		      	Msgbox("Para Este Produto nao Pode-se Utilizar Este Centro de Custo ","Solicitação de Compra","ALERT" )  
		      	_lOK := .F.
	   		Endif   

	    Endif    
		
  		//foi inserido a pedido do rogerio da contabilidade em 23/11/07
   		If !Subs(Alltrim(Acols[n][_nCod]),1,2)$"IM" .And. Alltrim(Acols[n][_nCC])==Iif(SM0->M0_CODIGO=="FN/IT","IMOBILIZ","IMOBIL") .And. Empty(Alltrim(Acols[n][_nOS]))
      		Msgbox("Para Este Produto nao Pode-se Utilizar Este Centro de Custo ","Solicitação de Compra","ALERT" )  
      		_lOK := .F.
   		Endif      

   	Endif

	//-- RETIRADO MOMENTANEAMENTE
	/*
	   If Acols[n][_nData] < _dData //Verifica se o usuario alterou a data a baixo do lead time   
	      Msgbox("Atencao A Data de Necessidade nao Pode ser Menor que a Data Atual ","Solicitação de Compra","ALERT" )  
	      Acols[n][_nData] := _dData 
	   Endif 
	*/
	
   	//foi inserido a pedido do rogerio da contabilidade em 31/05/07
   	If Alltrim(Acols[n][_nConta])$"103020050001" .And. Subs(Alltrim(Acols[n][_nCod]),1,2)$"MX"
      	Msgbox("Para Este Produto nao Pode-se Utilizar Esta Conta de IMOBILIZADO ","Solicitação de Compra","ALERT" )  
      	_lOK := .F.
   	Endif
   
   	If (Subs(Alltrim(Acols[n][_nConta]),1,8)$"10302015" .Or. Subs(Alltrim(Acols[n][_nConta]),1,5)$"10402") .And. Empty(Alltrim(Acols[n][_nOS])) 
      	Msgbox(OemToAnsi("Para Esta Conta Contabil é Obrigatório o Preenchimento do Campo com o Numero da O.S. do Ativo"),"Solicitação de Compra","ALERT" )  
      	_lOK := .F.
   	Endif

   	If Subs(Alltrim(Acols[n][_nConta]),1,5)$"10302" .And. Empty(Alltrim(Acols[n][_nOS])) .And. !Subs(Alltrim(Acols[n][_nCod]),1,2)$"IM/EB"
      	Msgbox(OemToAnsi("Para Esta Conta Contabil é Obrigatório Colocar o Produto Iniciando com IM"),"Solicitação de Compra","ALERT" )  
      	_lOK := .F.
   	Endif

   	If Empty(Acols[n][_nVlr]) .AND. !ALLTRIM(UPPER(FUNNAME()))$"MATA410"
   	  	Msgbox(OemToAnsi("Favor Digitar o Preço Estimado para o Produto ")+Alltrim(Acols[n][_nCod]) +CHR(13)+;
             OemToAnsi(" Pois é campo Obrigatório"),"Solicitação de Compra","ALERT" )  
   	  	return .F.
   	Endif           

   	If Subs(Alltrim(Acols[n][_nCod]),1,4)$"IM15" .And. !Empty(Alltrim(Acols[n][_nOS])) .And.;
      	Right(Alltrim(Acols[n][_nCod]),4) <>  Right(Alltrim(Acols[n][_nOS]),4)
      	Msgbox("O Produto "+Alltrim(Acols[n][_nCod]) +OemToAnsi(" não é da O.S. do Ativo Numero ")+Alltrim(Acols[n][_nOS]),"Solicitação de Compra","ALERT" )  
      	return .F.
   	Endif              

	//-- OS ATIVO

   	If !Empty(Alltrim(Acols[n][_nOS])) // Se foi preenchido o campo OS Ativo pega a conta e CC da O.S.
      
       	ZA1->(DbsetOrder(1))
       	If ZA1->(DbSeek(xFilial("ZA1")+Subs(Acols[n][_nOS],1,6)))
	
			//-- VERIFICA SE A CONTA ESTÁ ENCERRADA
           	If ZA1->ZA1_ENCERA$"S"
           		Msgbox(OemToAnsi("O.S. Ja esta Encerrada, Nao Pode ser Utilizada "),"Solicitação de Compra","ALERT" )  
           		return .F.

    		//-- SENAO PEGA O CC E A CONTA        
            Else 
           		Acols[n][_nCC]    := ZA1->ZA1_CC
           		Acols[n][_nConta] := U_NHCOM059() // ZA1->ZA1_CONTA
           	Endif   

			//-- VERIFICA SE A OS POSSUI ITENS
           	ZA2->(DbsetOrder(1))      
           	If !ZA2->(DbSeek(xFilial("ZA2")+Subs(Acols[n][_nOS],1,6)))
           		Msgbox(OemToAnsi("Esta O.S. não Existe, a OS Deve Conter Código de Controle, Favor Verificar !!! "),"Solicitação de Compra","ALERT" )  
           		return .F.
           	Endif
       	Endif
                
       	//-- TRAZ O VALOR GASTO
       	_nVlrGst := U_GastoDif(Acols[n][_nOs])
       	
       	If !Empty(_nVlrGst)

	       	//pega o total aprovado da OS
	       	//-- OS N:054875 (26/08/2013) VALDELENEMS
	       	//-- PEGAR O VALOR APROVADO POR ITEM E NAO TOTAL APROVADO DA OS
    	   	ZA2->(DBSETORDER(1))//ZA2_FILIAL+ZA2_NUM+ZA2_ITEM
      		If ZA2->(DbSeek(xFilial('ZA2')+ALLTRIM(Acols[n][_nOS]))) //Subs(Acols[n][_nOS],1,6)+"0001"))
	      	//WHILE ZA2->ZA2_NUM == Subs(Acols[n][_nOS],1,6)
	   	   		_nTotAprv += ZA2->ZA2_AVTOT
       		//	ZA2->(DBSKIP())
	       	//ENDDO
	       	ENDIF

	       	//pega também o total aprovado das OS's complementares
    	   	ZAD->(dbSetOrder(1)) //ZAD_FILIAL+ZAD_NUM+ZAD_ITEM
    	   	//-- PEGA SOMENTE O ITEM COMPLEMENTAR DO ITEM DA OS
       		IF ZAD->(dbSeek(xFilial("ZAD")+ALLTRIM(Acols[n][_nOS])))  //Subs(Acols[n][_nOS],1,6)+"0001"))
	       	//WHILE ZAD->ZAD_NUM == Subs(Acols[n][_nOS],1,6)
    	   		_nTotAprv += ZAD->ZAD_AVTOT
       			//ZAD->(DBSKIP())
	       	//ENDDO
	       	ENDIF
    	     
     		If ((Acols[n][_nVlr] * Acols[n][_nQtd])+_nVlrGst) > _nTotAprv   
				
				If date() <= stod('20131030')
					Msgbox("A partir de 01/09/2013 será considerado o valor aprovado por Item da OS do ativo!" ,"Solicitação de Compra","INFO" )
				Endif
				
				Msgbox(OemToAnsi("Saldo da Conta "+ALLTRIM(Acols[n][_nOS])+" Insuficiente!"+CHR(10)+CHR(13)+;
			                 	 "Total Aprovado: R$ "+alltrim(str(_nTotAprv))+chr(10)+chr(13)+;
	    		             	 "Total Gasto: R$ "+alltrim(str(_nVlrGst))+chr(10)+chr(13)+;
	        		         	 "Total Saldo: R$ "+alltrim(str(_nTotAprv-_nVlrGst))),"Solicitação de Compra","ALERT" )
				return .f.
	 		EndIf
		Endif
	Endif
Endif	
		
Return(_lOK)
      
User Function GastoDif(_cOrdSrv)

Local _nItem   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C1_ITEM"})  

Local _nx      := 0
Local _aOSAtiv := {}
Local _cOk     := .T.
Local _lPri    := .F.
Local _nTotA   := 0
Local _nGTotA  := 0
Local _nVlrPed := 0
Local _aOSGer  := {}

   cQuery := "SELECT ZA1.R_E_C_N_O_,ZA2.*,ZA1.*,QAA.QAA_NOME,CTT.CTT_DESC01,SC1.C1_MOEDA, SC1.C1_NUMOS,SC1.C1_NUM,SC1.C1_ITEM,SC1.C1_FORNECE,SC1.C1_LOJA,SC1.C1_EMISSAO,SC1.C1_QUANT,SC1.C1_VUNIT,SC1.C1_RESIDUO "
   cQuery += " FROM " +  RetSqlName( 'ZA1' ) +" ZA1, " +  RetSqlName( 'ZA2' ) +" ZA2, " +   RetSqlName( 'QAA' ) +" QAA,"  +   RetSqlName( 'SC1' ) +" SC1, "  +   RetSqlName( 'CTT' ) +" CTT "
   cQuery += " WHERE ZA1.ZA1_FILIAL = '" + xFilial("ZA1")+ "'"    
   cQuery += " AND ZA2.ZA2_FILIAL = '" + xFilial("ZA2")+ "'" 
   cQuery += " AND QAA.QAA_FILIAL = '" + xFilial("QAA")+ "'"    
   cQuery += " AND SC1.C1_FILIAL = '" + xFilial("SC1")+ "'"       
   cQuery += " AND CTT.CTT_FILIAL = '" + xFilial("CTT")+ "'"

	//-- incluida por joaofr 29/05/2013
 	if altera
		cQuery += " AND SC1.C1_NUM+SC1.C1_ITEM <> '"+SC1->C1_NUM+acols[n][_nItem]+"' "
	ENDIF

   cQuery += " AND ZA1.ZA1_NUM = '" + _cOrdSrv +"' " 
   cQuery += " AND ZA1.ZA1_CC  = CTT.CTT_CUSTO "
   cQuery += " AND ZA1.ZA1_NUM = ZA2.ZA2_NUM "
   cQuery += " AND ZA1.ZA1_RESP = QAA.QAA_MAT "   
   cQuery += " AND ZA1.ZA1_NUM = SUBSTRING(SC1.C1_NUMOS,1,6) "      
   cQuery += " AND ZA2.ZA2_ITEM = SUBSTRING(SC1.C1_NUMOS,7,4) "         
   cQuery += " AND ZA1. D_E_L_E_T_ = ' ' AND ZA2. D_E_L_E_T_ = ' ' AND SC1. D_E_L_E_T_ = ' ' "
   cQuery += " AND CTT. D_E_L_E_T_ = ' ' AND QAA. D_E_L_E_T_ = ' ' "               
   cQuery += " ORDER BY ZA1.ZA1_NUM, SC1.C1_FILIAL,SC1.C1_NUM,SC1.C1_ITEM ASC"    

   MemoWrit('C:\TEMP\EST081C.SQL',cQuery)
   //TCQuery Abre uma workarea com o resultado da query
   TCQUERY cQuery NEW ALIAS "TMB"      
   TcSetField("TMB","ZA1_DATA","D")  // Muda a data de string para date    
   TcSetField("TMB","ZA1_CDATA","D")  // Muda a data de string para date    
   TcSetField("TMB","ZA1_DTINI","D")  // Muda a data de string para date    
   TcSetField("TMB","ZA1_DTFIM","D")  // Muda a data de string para date    
   TcSetField("TMB","ZA2_DATA","D")  // Muda a data de string para date    
   TcSetField("TMB","C1_EMISSAO","D")  // Muda a data de string para date       

TMB->(Dbgotop())
If TMB->(Eof()) //Verifica se não encontrou a solicitação de nota na visualização
   TMB->(DbCloseArea())
   return 0
Endif

SC7->(DbsetOrder(22)) //C7_FILIAL+C7_NUMSC+C7_ITEMSC
SD1->(DbsetOrder(14)) //D1_FILIAL+D1_PEDIDO+D1_ITEMPC

While TMB->(!EOF())

    If Empty(TMB->C1_NUM)
    	TMB->(dbskip())
    	Loop
    Endif
    
   	_cOk := .T.
	   
   	//VERIFICA APROVACAO
   	SZU->(DbSetOrder(2)) //ZU_FILIAL+ZU_LOGIN
   	SZU->(DbSeek(xFilial("SZU")+TMB->C1_NUM+TMB->C1_ITEM))

	While !SZU->(Eof()) .And. SZU->ZU_NUM+SZU->ZU_ITEM == TMB->C1_NUM+TMB->C1_ITEM
		If SZU->ZU_STATUS $ "C"
			_cOk := .F.
			Exit
	   	ElseIf (Empty(SZU->ZU_STATUS) .And. Val(SZU->ZU_NIVEL) < 9) // ITEM NAO APROVADO E NIVEL < 9 = NAO É PENDENCIA DE COMPRADOR
			_cOk := .F.
			Exit
		Endif

	   	SZU->(DbSkip())
   	Enddo

    If _cOK
           
    	If SC7->(Dbseek(xFilial("SC7")+TMB->C1_NUM+TMB->C1_ITEM)) //filial + num SC + Item SC
             
        	While !SC7->(Eof()) .And. TMB->C1_NUM+TMB->C1_ITEM == SC7->C7_NUMSC+SC7->C7_ITEMSC
              	//nao pega qdo o pedido esta c/ eliminação de residuo, mas pode pegar qdo tiver qtde já entregue e c/ eliminacao de residuo parcial
             	If Empty(SC7->C7_RESIDUO) .Or. (!Empty(SC7->C7_RESIDUO) .And. SC7->C7_QUJE > 0 )

	             	If SD1->(Dbseek(xFilial("SD1")+SC7->C7_NUM+SC7->C7_ITEM)) //Filial + num pedido + item pedido       
	                
	                	//Inclui o que não foi entregue dos pedidos que foram atendidos parcialmente, sem eliminacao de residuo
	                	If (SC7->C7_QUANT - SC7->C7_QUJE) > 0 .And. (SC7->C7_QUJE > 0 ) .And. Empty(SC7->C7_RESIDUO)
		                	
		                	_nx := Ascan(_aOSAtiv, {|x| x[1]+x[5]== SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA+TMB->C1_NUMOS})
			                
			                // Saldo a entregar  *   (preco unitario * aliq de ipi)  //traz valor de ipi unitario
			                If SC7->C7_IPI > 0  
			                   _nVlrPed := (SC7->C7_QUANT - SC7->C7_QUJE) * xMoeda( (SC7->C7_PRECO + ((SC7->C7_PRECO*SC7->C7_IPI)/100)) , SC7->C7_MOEDA, 1 , SC7->C7_EMISSAO )
			                Else
	      		                // Saldo a entregar  * preco unitario 
			                   _nVlrPed := (SC7->C7_QUANT - SC7->C7_QUJE)* xMoeda( SC7->C7_PRECO , SC7->C7_MOEDA , 1 , SC7->C7_EMISSAO ) 
			                Endif
			                   
			          	    If _nx <> 0
			                   _aOSAtiv[_nx][4] +=  _nVlrPed
			                Else 
			                   Aadd(_aOSAtiv,{SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA,Dtoc(SC7->C7_EMISSAO),"P",( _nVlrPed),TMB->C1_NUMOS,.F.})          	 
			                Endif 
			                      
			                _nx := Ascan(_aOSGer, {|x| x[1]== TMB->C1_NUMOS})         
			           	    If _nx <> 0
			                   _aOSGer[_nx][7] +=  _nVlrPed
			                Else 
			                   Aadd(_aOSGer,{TMB->C1_NUMOS,TMB->ZA2_ITEM,TMB->ZA2_CODCON,TMB->ZA2_DESCRI,TMB->ZA2_VTOT,TMB->ZA2_AVTOT,_nVlrPed,.F.})                                  
			                Endif   
			                
			            Endif
	                        
						//verifica a existencia de varias notas p/ o mesmo pedido
                        While !SD1->(Eof()) .And. SC7->C7_NUM+SC7->C7_ITEM == SD1->D1_PEDIDO+SD1->D1_ITEMPC
	            
		             		// inclui as notas fiscais
		                	_nx := Ascan(_aOSAtiv, {|x| x[1]+x[5]== SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+TMB->C1_NUMOS})
		          	    	If _nx <> 0
		                   		_aOSAtiv[_nx][4] += SD1->D1_TOTAL // (SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM
		                	Else 
		                   		Aadd(_aOSAtiv,{SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA,Dtoc(SD1->D1_DTDIGIT),"N",;
		                   					SD1->D1_TOTAL,; //(SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM,
		                   					TMB->C1_NUMOS,.F.})
		                	Endif
		                
		                	_nx := Ascan(_aOSGer, {|x| x[1]== TMB->C1_NUMOS})             
			          		If _nx <> 0
		                   		_aOSGer[_nx][7] += SD1->D1_TOTAL//CUSTO // (SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM
		                	Else 
		                   		Aadd(_aOSGer,{TMB->C1_NUMOS,TMB->ZA2_ITEM,TMB->ZA2_CODCON,TMB->ZA2_DESCRI,TMB->ZA2_VTOT,TMB->ZA2_AVTOT,;
						                   SD1->D1_TOTAL,;//CUSTO,;//(SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM,
						                   .F.})
		                	Endif   
		                
		                	SD1->(Dbskip())
		                
		            	Enddo
		            
	             	Else // inclui os pedidos de compras
	                	If Empty(SC7->C7_RESIDUO)		             
		                	_nx := Ascan(_aOSAtiv, {|x| x[1]+x[5]== SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA+TMB->C1_NUMOS})
		          	    	If _nx <> 0
		                   		_aOSAtiv[_nx][4] +=  xMoeda( (SC7->C7_TOTAL+SC7->C7_VALIPI) , SC7->C7_MOEDA , 1 , SC7->C7_EMISSAO ) 
		               	 	Else 
		                   		Aadd(_aOSAtiv,{SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA,Dtoc(SC7->C7_EMISSAO),"P", xMoeda((SC7->C7_TOTAL+SC7->C7_VALIPI),SC7->C7_MOEDA,1,SC7->C7_EMISSAO),TMB->C1_NUMOS,.F.})          	 
		                	Endif       
		               
		               		//Para imprimir a primeira pagina c/ resumo da OS
		                	_nx := Ascan(_aOSGer, {|x| x[1]== TMB->C1_NUMOS})             
		           	    	If _nx <> 0
		                   		_aOSGer[_nx][7] += xMoeda( (SC7->C7_TOTAL+SC7->C7_VALIPI)  , SC7->C7_MOEDA , 1 , SC7->C7_EMISSAO )
		                	Else 
		                   		Aadd(_aOSGer,{TMB->C1_NUMOS,TMB->ZA2_ITEM,TMB->ZA2_CODCON,TMB->ZA2_DESCRI,TMB->ZA2_VTOT,TMB->ZA2_AVTOT,xMoeda( (SC7->C7_TOTAL+SC7->C7_VALIPI),SC7->C7_MOEDA , 1 , SC7->C7_EMISSAO ),.F.})                                  
		               	 	Endif   
		            	Endif
	             	Endif
	         	Endif
	         
	         	SC7->(Dbskip())
	     
	     	Enddo    
      	Else // inclui a requisicao de compras somente as já aprovadas
         	If Empty(TMB->C1_RESIDUO)
             	_nx := Ascan(_aOSAtiv, {|x| x[1]+x[5]== TMB->C1_NUM+TMB->C1_FORNECE+TMB->C1_LOJA+TMB->C1_NUMOS})
 	      	 	If _nx <> 0
                	_aOSAtiv[_nx][4] += xMoeda( (TMB->C1_QUANT * TMB->C1_VUNIT) , TMB->C1_MOEDA , 1 , TMB->C1_EMISSAO )
             	Else 
                	Aadd(_aOSAtiv,{TMB->C1_NUM+TMB->C1_FORNECE+TMB->C1_LOJA,Dtoc(TMB->C1_EMISSAO),"S",xMoeda( (TMB->C1_QUANT * TMB->C1_VUNIT) , TMB->C1_MOEDA , 1 , TMB->C1_EMISSAO ),TMB->C1_NUMOS,.F.})               
             	Endif   
             	
             	//Para imprimir a primeira pagina c/ resumo da OS
             	_nx := Ascan(_aOSGer, {|x| x[1]== TMB->C1_NUMOS})             
	      	 	If _nx <> 0
                	_aOSGer[_nx][7] +=  xMoeda( (TMB->C1_QUANT * TMB->C1_VUNIT) , TMB->C1_MOEDA , 1 , TMB->C1_EMISSAO )
            	Else 
                	Aadd(_aOSGer,{TMB->C1_NUMOS,TMB->ZA2_ITEM,TMB->ZA2_CODCON,TMB->ZA2_DESCRI,TMB->ZA2_VTOT,TMB->ZA2_AVTOT,xMoeda( (TMB->C1_QUANT * TMB->C1_VUNIT) , TMB->C1_MOEDA , 1 , TMB->C1_EMISSAO ),.F.})               
             	Endif

         	Endif
		Endif 
          
    Endif
    
	TMB->(DbSkip())

Enddo      

If Len(_aOSAtiv)==0 .Or.  Len(_aOSGer)==0 //Verifica se não encontrou a solicitação de nota na visualização
   TMB->(DbCloseArea())
   return
Endif 

_aOSAtiv := ASort(_aOSAtiv,,, { |x, y| x[5]+x[3] < y[5]+y[3]})  //Ordena a matriz pelo numero da O.S.

TMB->(Dbgotop())

ZA2->(DbsetOrder(1))//Filial + numero + item
If ZA2->(Dbseek(xFilial("ZA2")+Subs(_aOSGer[1][1],1,6))) //filial + num OS + Item OS
   While !ZA2->(EOF()) .And. Subs(_aOSGer[1][1],1,6) == ZA2->ZA2_NUM
       _nx := Ascan(_aOSGer, {|x| x[1]== ZA2->ZA2_NUM+ZA2->ZA2_ITEM})             
       If _nx == 0
          Aadd(_aOSGer,{ZA2->ZA2_NUM+ZA2->ZA2_ITEM,ZA2->ZA2_ITEM,ZA2->ZA2_CODCON,ZA2->ZA2_DESCRI,ZA2->ZA2_VTOT,ZA2->ZA2_AVTOT,0,.F.})                      
       Endif
      
      ZA2->(Dbskip())
   Enddo   
Endif        
_aOSGer  := ASort(_aOSGer,,, { |x, y| x[2] < y[2]})  //Ordena a matriz pelo Item da O.S.
_lPri  := .F.

For _ni:= 1 to Len(_aOSGer)

       If Val(_aOSGer[_ni][3]) >= 20 .And. !_lPri //Imprime mao de obra
          _nGTotA := _nTotA           
   	      _lPri  := .T.
   	      _nTotA := 0
       Endif
       _nTotA += _aOSGer[_ni][7]
Next _ni

  _nGTotA += _nTotA //soma valor total aprovado da mao de obra    
  
  TMB->(DbCloseArea())                    

Return(_nGTotA)