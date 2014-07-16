#include "rwmake.ch"
#include "TOPCONN.CH"
#include "colors.ch"
#include "font.ch"
#include "protheus.ch"
#include "FIVEWIN.Ch"
#INCLUDE "mdtr700.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHMNT059 ºAutor  ³Douglas de S. Douradoº Data ³  03/08/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PLANO DE PREVENTIVAS                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP11 - MANUTENCAO DE ATIVOS                                º±±
±±º	         ³ TABELA DE CADASTRO:  ZEYFN0		                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHMNT059
Private oDlg
Private aRotina, cCadastro // Obrigatorio iniciar estas variaveis do Mbrowse
/*********BROWSE*********/
cCadastro := "Plano de Preventiva"
aRotina   := {}
aAdd(aRotina,{ "Visualizar"	    ,"U_MNT059(1)" 	, 0 , 2})
aAdd(aRotina,{ "Incluir"		,"U_MNT059(2)" 	, 0 , 3})
aAdd(aRotina,{ "Gerar Plano"    ,"U_MNT059(5)"  , 0 , 4})
aAdd(aRotina,{ "Alterar"        ,"U_MNT059(3)"  , 0 , 4})
aAdd(aRotina,{ "Excluir"        ,"U_MNT059(4)"  , 0 , 5})    
aAdd(aRotina,{ "Legenda"        ,"U_MNT059(6)"  , 0 , 1})
aAdd(aRotina,{ "Layout"        ,"U_MNT059(7)"  , 0 , 1}) 
mBrowse(6,1,22,75,"ZEY",,,,,,fCriaCor())   
/*************************/         
Return   

User Function MNT059(nParam) // Função Principal do Fonte
Private nPar := nParam, cTitle , cGerado , _aMat2 := {} , oFont2                  
Private cDeDisp := space(15) , cAteDisp := space(15) , dDeData := CtoD('  /  /  ') , dAteData := CtoD('  /  /  ') , cDescricao := space(50) ,  cGetPrev:= space(06) 
Private cDePreventiva := space(06), cAtePreventiva := space(06), cNumPlano
Private dData := CtoD('  /  /  ') , cDescDisp1 := '', cDescDisp2 := '' , cDeLetra:=space(01) , cAteLetra:=space(01)
Private cPeriod := space(04), cDescPrev1 := space(80) ,cDescPrev2 := space(80), cGetSeque := space(02) , mDesc := space(300), cDeTrabalho :=space(06) , cAteTrabalho :=space(06)
Private aSize := MsAdvSize() , aCombo:={"N=Nao","S=Sim"}, cComboAtra := " " , cDeCusto := space(09), cAteCusto := space(09) 


/************* Identifica a operação que será realizada *****************/
  
If nPar==1      //visualizar
    fCarrega()
    cTitle := 'Visualizar'  	 
ElseIf nPar==2  //incluir	
	cTitle := 'Incluir'
	cNumPlano := GetSxENum("ZEY","ZEY_NUM")	
ElseIf nPar==3  //alterar              
	fCarrega()		
	cTitle := 'Alterar'
ElseIf nPar==4  //excluir
	fCarrega()			
   	cTitle := 'Excluir'
ElseIf nPar==5  //gerar
	fCarrega()
   	fVerifStatus()  
ElseIf nPar==6
	fLegenda() // Legenda
EndIf 	

/************** Inicialização dos Say's e Get's ************************/ 

Define MsDialog oDlg Title (cTitle) From aSize[7],00 To aSize[6],aSize[5] Pixel

	@ 08,10  Say "Número do Plano: " PIXEL OF oDlg    	      
	@ 18,10  Get cNumPlano SIZE 50,10 WHEN .F. PIXEL OF oDlg

	@ 08,65  Say "Descrição: " PIXEL OF oDlg    	      
	@ 18,65  Get cDescricao WHEN (nPar == 2 .or. nPar == 3) SIZE 200,10 PIXEL OF oDlg 
	
	@ 08,275 Say "Data: " PIXEL OF oDlg    	      
	@ 18,275 Get dData WHEN (nPar == 2 .or. nPar == 3) SIZE 50,10 PIXEL OF oDlg 
			
	@ 37,10  Say "De Data: " PIXEL OF oDlg
	@ 46,10  Get dDeData WHEN (nPar == 2 .or. nPar == 3) SIZE 50,10 PIXEL OF oDlg
	
	@ 37,65  Say "Ate Data: " PIXEL OF oDlg
	@ 46,65  Get dAteData WHEN (nPar == 2 .or. nPar == 3) SIZE 50,10 PIXEL OF oDlg
		
	@ 63,10  Say "De Dispositivo: " PIXEL OF oDlg    	      
	@ 72,10  Get cDeDisp SIZE 50,10 F3 "ZBN" WHEN (nPar == 2 .or. nPar == 3) VALID fDisp(.T.)
	
	@ 63,65  Say "De Letra: " PIXEL OF oDlg    	      
	@ 72,65  Get cDeLetra SIZE 08,10 WHEN (nPar == 2 .or. nPar == 3)  PIXEL OF oDlg VALID fDisp(.T.) 	
		
	@ 090,10 Say "Ate Dispositivo: " PIXEL OF oDlg    	      
	@ 100,10 Get cAteDisp SIZE 50,10 F3 "ZBN" WHEN (nPar == 2 .or. nPar == 3) VALID fDisp(.F.)
	
	@ 090,65 Say "Ate Letra: " PIXEL OF oDlg    	      
	@ 100,65 Get cAteLetra WHEN (nPar == 2 .or. nPar == 3) SIZE 08,10 PIXEL OF oDlg VALID fDisp(.F.)
	
	@ 63,97  Say "Descrição do dispositivo: " PIXEL OF oDlg
	@ 72,97  Get oDescDisp1 VAR cDescDisp1  SIZE 285,10 WHEN .F. PIXEL OF oDlg	 
	
	@ 090,97 Say "Descrição do dispositivo: " PIXEL OF oDlg
	@ 100,97 Get oDescDisp2 VAR cDescDisp2  SIZE 285,10 WHEN .F. PIXEL OF oDlg		
		
	@ 120,10 Say "De Centro Custo: " PIXEL OF oDlg	
	@ 130,10 GET cDeCusto SIZE 35,10 F3 "CTT" WHEN (nPar == 2 .or. nPar == 3)
	
	@ 120,65 Say "Ate Centro Custo: " PIXEL OF oDlg	
	@ 130,65 GET cAteCusto SIZE 35,10 F3 "CTT" WHEN (nPar == 2 .or. nPar == 3)
			
	@ 150,10 Say "De Centro de Trabalho: " PIXEL OF oDlg	
	@ 160,10 GET cDeTrabalho SIZE 35,10 F3 "SHB" WHEN (nPar == 2 .or. nPar == 3)
	
	@ 150,75 Say "Ate Centro de Trabalho: " PIXEL OF oDlg	
	@ 160,75 GET cAteTrabalho SIZE 35,10 F3 "SHB" WHEN (nPar == 2 .or. nPar == 3)
	
	@ 180,10 Say "De Preventiva: " PIXEL OF oDlg	
	@ 190,10 GET cDePreventiva SIZE 35,10 F3 "ZEE" WHEN (nPar == 2 .or. nPar == 3) Valid fPrev(.T.)
	
	@ 210,10 Say "Ate Preventiva: " PIXEL OF oDlg	
	@ 220,10 GET cAtePreventiva SIZE 35,10 F3 "ZEE" WHEN (nPar == 2 .or. nPar == 3) Valid fPrev(.F.)			
	
	@ 180,65 Say "Descrição Preventiva: " PIXEL OF oDlg	
	@ 190,65 Msget oDescPrev1 VAR cDescPrev1 SIZE 250,10 WHEN .F. PIXEL OF oDlg 
	
	@ 210,65 Say "Descrição Preventiva: " PIXEL OF oDlg	
	@ 220,65 Msget oDescPrev2 VAR cDescPrev2 SIZE 250,10 WHEN .F. PIXEL OF oDlg 
	
	@ 235,10 Say "Considera atrasadas ? " PIXEL OF oDlg		
	@ 245,10 Combobox cComboAtra ITEMS aCombo SIZE 40,10 WHEN (nPar == 2 .or. nPar == 3) PIXEL OF oDlg
	 		  	
	@ 270,10 BUTTON "Confirmar" Size 30,20 PIXEL OF oDlg action Confirmar()		  
	@ 270,45 BUTTON "Cancelar"  Size 30,20 PIXEL OF oDlg action Cancelar()	
	

Activate MsDialog oDlg Centered      

Return
/**********************************************************************/


/*********** Gera as OS a partir do plano de preventiva **************/
Static Function fGerar() 

Processa( {|| fQuery()  }, "Gerando Plano..." ) 

Return
/**********************************************************************/ 


/*********** Gera uma OS de preventiva ********************************/
Static Function fGeraOS(posZEW,posZBN) 
Local dDtIni, cNumOs, cTipo, cCC, cCTrab, tHoraIni,  ;
cCodDisp, cLetraDisp , cStatDisp, cBem, cStatBem, cDesc, cProblema, cTerminado, cAprovado, cConRel, ;
cNumPlanPrev, cNumPrev , cQueryZBN, cQueryZEW 

// Pega os dados do dispositivo para fazer a OS
cQueryZBN := " SELECT * "
cQueryZBN += " FROM " + RetSqlName("ZBN") + " ZBN " 
cQueryZBN += " WHERE R_E_C_N_O_ = '" + AllTrim(Str(posZBN)) +"' " 

TCQUERY cQueryZBN NEW ALIAS "TMPZBN" 

// Pegando dados da ZBN e também preenchendo com valores fixos
cNumPlanPrev := cNumPlano 					 // Pega o numero do Plano de Preventiva
dDtIni       := Date()                       // Preenche Data Inicial
cCC          := TMPZBN->ZBN_CC               // Preenche o Centro de Custo
cCTrab       := TMPZBN->ZBN_CTRAB			 // Preenche o Centro de Trabalho
cHoraIni     := Time()                       // Preenche a hora inicial
cBem         := TMPZBN->ZBN_CODBEM           // Preenche o código do Bem
cCodDisp     := TMPZBN->ZBN_COD				 // Preenche o código do dispositivo
cLetraDisp   := TMPZBN->ZBN_LETRA            // Preenche a letra do dispositivo
cTipo        := '2'                          // Preenche o tipo de manutenção como "Preventiva"
cStatDisp    := '5'                          // Preenche o status do dispositivo como "Preventiva"
cStatBem     := '3'                          
cDesc        := '3'                          
cTerminado   := 'N' 
cConRel      := 'N'
nOldZewRec := ZEW->(Recno()) // guarda a posicao da tabela zew

TMPZBN->(DbCloseArea())

ZEW->(dbgoto(posZEW))

_nLinha = MlCount(Lower(Alltrim(ZEW->ZEW_DESC)))
cProblema := ''
for i:=1  to _nLinha                                           
	cProblema += OemToAnsi(MemoLine(ZEW->ZEW_DESC,100,i)) 
next i 	 		 	

cNumPrev  := ZEW->ZEW_PRE

ZEW->(dbgoto(nOldZewRec)) // retorna posicao zew

cNumOs := GetSxeNum("ZBO","ZBO_ORDEM")

RecLock("ZBO",.T.)
		ZBO->ZBO_FILIAL := xFilial("ZBO")
		ZBO->ZBO_ORDEM  := cNumOs
		ZBO->ZBO_TIPO   := cTipo
		ZBO->ZBO_CC     := cCC
		ZBO->ZBO_CTRAB  := cCTrab
		ZBO->ZBO_HORINI	:= cHoraIni
		ZBO->ZBO_DATINI	:= dDtIni			
		ZBO->ZBO_RESP	:= cRespon
		ZBO->ZBO_DISP	:= cCodDisp
		ZBO->ZBO_LETRA	:= cLetraDisp
		ZBO->ZBO_STSDIS	:= cStatDisp
		ZBO->ZBO_CODBEM	:= cBem
		ZBO->ZBO_STSBEM	:= cStatBem
		ZBO->ZBO_DESC	:= cDesc		
		ZBO->ZBO_PROBLE	:= cProblema
		ZBO->ZBO_TERMIN := cTerminado	
		ZBO->ZBO_CONREL := cConRel
		ZBO->ZBO_PLANO  := cNumPlanPrev
		ZBO->ZBO_CDPREV := cNumPrev   
MsUnlock("ZBO")	 
		
		ConfirmSX8()	
				
		Aadd(_aMat,{cNumOs, cCodDisp, cLetraDisp, cTipo, cNumPrev, ;
			 cNumPlanPrev, cHoraIni, cRespon, cStatDisp, cBem, ;
			 cStatBem, cCTrab,cCC})   
			 
		nContaOS++

Return
/**********************************************************************/


/********** Gera a Query de Dispositivos no plano de preventivas ***********/
Static Function fQuery()  
Local cQuery, oFont
Local dDtUltMan, dDtVenc, nPeriodo, lGera := .F.
Local nZEW, nZBN
Private nContaOs := 0, nI := 0, nI2 := 0 , cRespon, _aMat := {}

oFont := TFont():New("Arial",,18,,.T.)

IF !ValidarGeraOs() 
	Return
EndIf

IF !fVerificaMat() // Verifica se o usuário está com o login cadastrado no QAA
	Return
EndIf

ProcRegua(0)    
    
	// Gera Alias com somente os dispositivos pretendidos no plano
	cQuery := " SELECT * "
	cQuery += " FROM " + RetSqlName("ZBN") + " ZBN " 
	cQuery += " WHERE ZBN_COD BETWEEN '" +cDeDisp+ "' AND '" +cAteDisp+"' "
	cQuery += " AND ZBN_LETRA BETWEEN '" +cDeLetra+ "' AND '" +cAteLetra+"' "
	cQuery += " AND ZBN_CTRAB BETWEEN '" +cDeTrabalho+ "' AND '" +cAteTrabalho+"' "
	cQuery += " AND ZBN_CC BETWEEN '" +cDeCusto+ "' AND '" +cAteCusto+"' "
	cQuery += " AND ZBN.D_E_L_E_T_ = '' AND ZBN_FILIAL = '" +xFilial("ZBN") + "' " 
		
	TCQUERY cQuery NEW ALIAS "DISP"  // Criando alias com dispositivos x preventiva que se encaixam nos parâmetros
	
	DISP->(DbGoTop()) 
	
	ZEW->(DBSETORDER(3))  // Filial + Codigo + Letra
	
	ZEW->(DbGoTop()) 	
	
	While !DISP->(Eof()) // Loop para percorrer os disp. selecionados da tabela ZBN
	  	
	   	nZBN := DISP->R_E_C_N_O_   // Recebe a posição atual na ZBN   	  
	  	
	  	IncProc()	
	   
	    IF ZEW->(DbSeeK(xFilial("ZEW") + DISP->ZBN_COD + DISP->ZBN_LETRA)) //Pré-Filtro - Confere se existe na ZEW o atual disp da ZBN   
	    	
	    	nI:=0
	        nI2++               
            
            While !ZEW->(Eof()) .and. ZEW->(ZEW_COD + ZEW_LETRA) == (DISP->(ZBN_COD + ZBN_LETRA))  // Caso se encaixe nos parametros, encaminha para a função fGerarOS.			 	  
				nI++
				nZEW := ZEW->(RecNo()) //Mapeando a atual posicao na tabela ZEW (Debug)			 	 
				 	 
		 	 	// Verifica se existe uma manutenção cadastrada para esse disp. na ZEW (Dispositivo x Manutenção) e a Preventiva se encaixa nos parametros do plano						 
		 	 	IF  ( (ZEW->ZEW_PRE >= cDePreventiva) .AND. (ZEW->ZEW_PRE <= cAtePreventiva) ) 
		 	   	 
		 	   	 	lGera := .F.  			         
		         	
		         	// Verifica se a data do disp. encontrado se encaixa no periodo solicitado 			  	 		  	 		  	 
        			nPeriodo  := ZEW->ZEW_PERIOD           // Periodo de dias 	     
 					dDtUltMan := ZEW->ZEW_DTUM			   // Data da Ultima Manutenção		 
				 	dDtVenc   := DtoS(dDtUltMan+nPeriodo)  // Data de Vencimento = (Data Ult. Man. + Periodo)		           
				 	dDtVenc   := StoD(dDtVenc)			   // Transformando de String para Data 
				 					 	     
				    // Verifica se vencimento se encaixa no periodo solicitado, se sim, gera OS
				 	IF (dDtVenc > dDeData) .AND. (dDtVenc <= dAteData)  
						lGera := .T.				     
					EndIf					     	 
	 					 
 					// Verifica se manutenção com data atrasada (Antes da data Inicial)
				 	IF dDtVenc < dDeData 
				   		IF AllTrim(cComboAtra) == 'S'        // Se aceitar atrasadas, gera OS
			      	 		lGera := .T.			      	 
			       		EndIf
			     	EndIf  				 			 	        
             
	 			 	// Se Data foi aprovada, pode ser gerada a OS.
				 	IF  lGera .AND. fVerificaOs( ZEW->ZEW_COD, ZEW->ZEW_LETRA, ZEW->ZEW_PRE, ZEW->(RecNo()) )
				 	 	fGeraOS(nZEW,nZBN)	   		    	// Passa a posição na ZEW e na ZBN, para auxiliar na inclusão da OS				  	 							  	 						  	 						  	 
				 	 	RecLock("ZEW",.F.)                  // Atualiza o campo: "Data Ultima Manutenção" com a data atual
    	          	  		ZEW->ZEW_DTUM := Date()
				 	 	MsUnlock("ZEW")
			 	 	ENDIF 			  			
			 	 
				ENDIF
				 				 
				ZEW->(DbSkip()) 					 	 
			EndDo 					   	 	
		ELSE 
		 	DISP->(DbSkip())
		EndIf   
	
	  DISP->(DbSkip())	  
		 	 		 				
	EndDo 
	
	//Da baixa no plano gerado
	RecLock("ZEY",.F.)  
 		ZEY->ZEY_GERADO  :=  'S'	
	MsUnlock("ZEY") 
	
	DISP->(DbCloseArea())
	
	IF nContaOS == 0
	    Alert('Não foi gerada nenhuma OS de manutenção preventiva para este plano')
	   RETURN
	ENDIF 
    
	DEFINE MSDIALOG oDlg2 TITLE ("Plano de Preventiva Nº "+cNumPlano) FROM 0,0 TO 480,800 PIXEL 
    
	@ 048,005 LISTBOX oLbx FIELDS HEADER ;
	"Nº OS","COD. DISP","LETRA DISP.","TIPO DE MAN.","COD. PREV.","Nº PLANO","HR INICIAL",;
	"MAT. RESP.","STATUS DISP","COD. BEM","STATUS DO BEM","CENTRO DE TRAB.","CENTRO C.";
	SIZE 392,185 OF oDlg2 PIXEL //ON DBLCLICK( u_fDet(oLbx:nAt))

	oLbx:SetArray( _aMat )
	oLbx:bLine := {|| {_aMat[oLbx:nAt,1],;  // Nº DA OS 
                   	   _aMat[oLbx:nAt,2],;  // CÓD. DISP
                       _aMat[oLbx:nAt,3],;  // LETRA DISP
                       _aMat[oLbx:nAt,4],;  // TIPO
                       _aMat[oLbx:nAt,5],;  // COD. DA PREVENTIVA
                       _aMat[oLbx:nAt,6],;  // Nº DO PLANO
                       _aMat[oLbx:nAt,7],;  // HORA INICIAL
                       _aMat[oLbx:nAt,8],;  // RESPONSAVEL
                       _aMat[oLbx:nAt,9],;  // STATUS DISP
                       _aMat[oLbx:nAt,10],; // CÓD. DO BEM
                       _aMat[oLbx:nAt,11],; // STATUS DO BEM                                                                 
                       _aMat[oLbx:nAt,12],; // CENTRO DE TRABALHO
                       _aMat[oLbx:nAt,13]}} // CENTRO DE CUSTO                       
	oLbx:Refresh() 
	@ 032,005 Say "Foram geradas as seguintes ordens de serviço: " object oMsg
	 oMsg:SetFont(oFont)	 	

	ACTIVATE MSDIALOG oDlg2 CENTERED
		 	
Return
/**********************************************************************/

/*************** Carrega os Dados para Visualização *******************/
Static Function fCarrega()  
	
	ZEY->(DBSETORDER(1))
	cNumPlano    	:= 	ZEY->ZEY_NUM
	cDescricao  	:= 	ZEY->ZEY_DESC
	dData			:= 	ZEY->ZEY_DATA
	dDeData			:=	ZEY->ZEY_DEDATA
	dAteData		:=	ZEY->ZEY_ATEDAT
	cDeDisp			:= 	ZEY->ZEY_DEDISP
	cAteDisp		:= 	ZEY->ZEY_ATDISP
	cDeLetra		:= 	ZEY->ZEY_DLETRA	
	cAteLetra		:= 	ZEY->ZEY_ALETRA
	cDeCusto		:= 	ZEY->ZEY_DECC
	cAteCusto		:= 	ZEY->ZEY_ATECC
	cDeTrabalho 	:= 	ZEY->ZEY_DECTRAB
	cAteTrabalho	:= 	ZEY->ZEY_ATECTR
	cDePreventiva	:= 	ZEY->ZEY_DEPREV
	cAtePreventiva	:= 	ZEY->ZEY_ATEPREV
	cComboAtra 		:= 	ZEY->ZEY_ATRAS
	cGerado			:=  ZEY->ZEY_GERADO
	
	// Campo de Descrição de Preventiva		
	ZEE->(DBSETORDER(1))      	   
    IF ZEE->(DBSEEK(xFilial("ZEE") + cDePreventiva))
      cDescPrev1 := ZEE->ZEE_DESC
    ENDIF
    
    ZEE->(DBSETORDER(1))      	   
    IF ZEE->(DBSEEK(xFilial("ZEE") + cAtePreventiva))
      cDescPrev2 := ZEE->ZEE_DESC
    ENDIF
    
	// Campo de Descrição do Dispositivo 
	ZBN->(DBSETORDER(1))      	   	
	IF ZBN->( DBSEEK(xFilial("ZBN") + cDeDisp + cDeLetra) )
  	  cDescDisp1 := ZBN->ZBN_DESC	
	ENDIF
	
	ZBN->(DBSETORDER(1))      	   	
	IF ZBN->( DBSEEK(xFilial("ZBN") + cAteDisp + cAteLetra) )
  	  cDescDisp2 := ZBN->ZBN_DESC	
	ENDIF
			
Return	
/**********************************************************************/


/************* Grava, Altera, ou Exclui o Registro no BD **************/
Static Function Confirmar()
    
  DO CASE // Verfica a operação que será feita
  
	CASE nPar == 2    // Inclui um novo registro --------
	   
		IF !Validar()
			Return
   		EndIf 		
   				 		  		 		
	    RecLock("ZEY",.T.)  
	    	ZEY->ZEY_FILIAL  :=  xFilial("ZEY")
	        ZEY->ZEY_NUM 	 :=  cNumPlano
			ZEY->ZEY_DESC 	 :=  cDescricao
			ZEY->ZEY_DATA    :=  dData
			ZEY->ZEY_DEDATA	 :=	 dDeData
			ZEY->ZEY_ATEDAT  :=  dAteData
			ZEY->ZEY_DEDISP  :=  cDeDisp		
			ZEY->ZEY_ATDISP  :=  cAteDisp
			ZEY->ZEY_DLETRA  :=  cDeLetra	
			ZEY->ZEY_ALETRA  :=  cAteLetra	
			ZEY->ZEY_DECC    :=  cDeCusto	
			ZEY->ZEY_ATECC   :=  cAteCusto
    		ZEY->ZEY_DECTRAB :=  cDeTrabalho
			ZEY->ZEY_ATECTR  :=  cAteTrabalho
			ZEY->ZEY_DEPREV  :=  cDePreventiva
    		ZEY->ZEY_ATEPREV :=  cAtePreventiva
    		ZEY->ZEY_ATRAS	 :=  cComboAtra
    		ZEY->ZEY_GERADO  :=  'N'	
		MsUnlock("ZEY") 
		
		ConfirmSX8()
    	
    	MsgBox('Dados Cadastrados com sucesso !', 'Dados Cadastrados', 'INFO')
    	
    	oDlg:End()   		
    
    CASE nPar == 3  // Altera o registro --------------      
   	   
   		IF !Validar()
			Return
   		EndIf 		
	   
	    RecLock("ZEY",.F.)	    	  
	        ZEY->ZEY_DESC 	 :=  cDescricao
			ZEY->ZEY_DATA    :=  dData
			ZEY->ZEY_DEDATA	 :=	 dDeData
			ZEY->ZEY_ATEDAT  :=  dAteData
			ZEY->ZEY_DEDISP  :=  cDeDisp		
			ZEY->ZEY_ATDISP  :=  cAteDisp
			ZEY->ZEY_DLETRA  :=  cDeLetra	
			ZEY->ZEY_ALETRA  :=  cAteLetra	
			ZEY->ZEY_DECC    :=  cDeCusto	
			ZEY->ZEY_ATECC   :=  cAteCusto
    		ZEY->ZEY_DECTRAB :=  cDeTrabalho
			ZEY->ZEY_ATECTR  :=  cAteTrabalho
			ZEY->ZEY_DEPREV  :=  cDePreventiva
    		ZEY->ZEY_ATEPREV :=  cAtePreventiva
    		ZEY->ZEY_ATRAS	 :=  cComboAtra		
		MsUnlock("ZEY") 
    	
    	MsgBox('Dados Alterados com sucesso !', 'Dados Alterados', 'INFO')
   		
   		oDlg:End()
    			
    CASE nPar == 4   // Exclui o Registro ------
      
    	If MsgYesNo("Tem certeza de que deseja excluir?")		
	  		RecLock("ZEY",.F.)
	  			ZEY->(dbDelete())
	 		MsUnLock("ZEY")
	
	 		MsgBox('Dados Excluidos com Sucesso','Registro Excluido') 
 	
 			oDlg:End()	 	 		
	
	 	ENDIF
	 	        
    OTHERWISE  // No caso de uma operação de "Visualizar"         
    	
    	oDlg:end()   
		
  ENDCASE  		 		

	
Return    
/********************************************************************/        

//*** FUNÇÃO DE VALIDAÇÃO DOS CAMPOS **************************
Static Function Validar()

If Empty(cDescricao) 
  Alert('Favor informar a descrição do plano de preventiva') // Valida o código do dispositivo
  Return .F.
EndIf 

If Empty(dData) 
  Alert('Favor informar a data do plano de preventiva') // Valida o código do dispositivo
  Return .F.
EndIf
    
Return .T. 
/******************************************************************/

//*** FUNÇÃO DE VALIDAÇÃO DOS CAMPOS **************************
Static Function ValidarGeraOs()

If Empty(cAteDisp)
  Alert('Não foi possível gerar o plano! Campo "Ate Dispositivo" está em branco.')
  Return .F.
EndIf 

If Empty(cAteLetra) 
  Alert('Não foi possível gerar o plano! Campo "Ate Letra" está em branco.')
  Return .F.
EndIf

If Empty(cAteTrabalho)
  Alert('Não foi possível gerar o plano! Campo "Ate Centro Trablaho" está em branco.')
  Return .F.
EndIf

If Empty(cAteCusto) 
  Alert('Não foi possível gerar o plano! Campo "Ate Centro Custo" está em branco.')
  Return .F.
EndIf
    
Return .T. 
/******************************************************************/

/************** VALIDA PREVENTIVA E PREENCHE A DESCRIÇÃO **********/
Static Function fPrev(lNuPrev)

ZEE->(DBSETORDER(1)) // FILIAL + CODIGO

DO CASE // Verfica a operação que será feita
  
CASE lNuPrev == .T.
	IF !ZEE->(DBSEEK(xFilial("ZEE") + cDePreventiva))
		Alert('Preventiva não encontrada')
	Else
		cDescPrev1 := ZEE->ZEE_DESC
		oDescPrev1:Refresh() 
	ENDIF	
	
CASE lNuPrev == .F.

	IF !ZEE->(DBSEEK(xFilial("ZEE") + cAtePreventiva))
		Alert('Preventiva não encontrada')
	Else
		cDescPrev2 := ZEE->ZEE_DESC
		oDescPrev2:Refresh() 
	ENDIF	 

ENDCASE		

Return .T.                       
/********************************************************************/
    
/************** VALIDA DISPOSITIVO + LETRA **************************/
Static Function fDisp(lValLetra)

ZBN->(DBSETORDER(1)) // Filial + Codigo + Letra

DO CASE 

CASE lValLetra == .T.
	IF !ZBN->(DBSEEK(xFilial("ZBN") + cDeDisp + cDeLetra ) )
		cDescDisp1 := ''	
		oDescDisp1:Refresh()	
	Else
		cDescDisp1 := ZBN->ZBN_DESC
		oDescDisp1:refresh()		
	ENDIF
	
CASE lValLetra == .F.
	IF !ZBN->(DBSEEK(xFilial("ZBN") + cAteDisp + cAteLetra ) )
		cDescDisp2 := ''	
		oDescDisp2:Refresh()	
	Else
		cDescDisp2 := ZBN->ZBN_DESC
		oDescDisp2 :refresh()		
 	ENDIF
 	
ENDCASE
		

Return .T.
//******************************************************************/ 

/****** Preenche a Descrição da Preventiva *************************/
Static Function fPreDesc()                                           

	ZEE->(DBSETORDER(1))      	   
    IF ZEE->(DBSEEK(xFilial("ZEE") + cDePreventiva))
      cDescPrev1 := ZEE->ZEE_DESC
      oDescPrev1:Refresh()
    ENDIF
    
    ZEE->(DBSETORDER(1))      	   
    IF ZEE->(DBSEEK(xFilial("ZEE") + cAtePreventiva))
      cDescPrev2 := ZEE->ZEE_DESC
      oDescPrev2:Refresh()
    ENDIF
    

Return
/*******************************************************************/

// Busca a matrícula do responsavel pela inclusão do Plano de Preventiva
Static Function fVerificaMat()
	
	// ------------------------------------------------------------------
	QAA->(DBSETORDER(6))
	IF QAA->( DBSEEK( UPPER(Alltrim(cUserName) ) ) )
	   cRespon := QAA->QAA_MAT
	ELSE
	   Alert("Favor cadastrar o login do usuário "+UPPER(ALLTRIM(cUserName))+" no cadastro de usuários!")
	   RETURN .F.
	EndIf 
	QAA->(DbCloseArea()) 
	// -------------------------------------------------------------------   
	
Return .T.


/******* Verifica se já tem um OS de preventiva em aberto **********/
Static Function fVerificaOS(cCodigo,cLetra,cPreventiva,posicao)	   

	ZBO->(DBSETORDER(2))  
	
	IF ZBO->(DbSeek(xFilial("ZBO") + cCodigo + cLetra + cPreventiva + 'N')) 	    
   			 ZBO->(DBGOTO(posicao))   	  
			 ZBO->(DbCloseArea())		  	
		   	 RETURN .F.      	  
	ENDIF
	
	ZBO->(DBGOTO(posicao))   	  
	ZBO->(DbCloseArea())
	
Return .T.
/************************** Legendas *******************************/
Static Function fLegenda()       

Local aLegenda :=	{ {"BR_VERDE"    , "Não Gerado"  },;
  					  {"BR_VERMELHO" , "Gerado"   }}

BrwLegenda(OemToAnsi("Plano de Controle"), "Legenda", aLegenda)

Return  


Static Function fCriaCor()       

Local aLegenda :=	{ {"BR_VERDE"   , "Não Gerado"  },;
  					  {"BR_VERMELHO" , "Gerado"   }}

Local uRetorno := {}

Aadd(uRetorno, { 'ZEY_GERADO = "N"' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZEY_GERADO = "S"' , aLegenda[2][1] } )

Return(uRetorno)
/******************************************************************/

/******** Verifica se plano já foi gerado******* ******************/
Static Function fVerifStatus()

IF cGerado = 'N'	
   fGerar()         
ELSE
   Alert("Este plano de preventiva já foi gerado!")
ENDIF

Return 
/******************************************************************/
                          
/***** Evento do botão cancelar **************/
Static Function Cancelar() 
	
	RollBackSX8()
	oDlg:end()      

Return