#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "colors.ch"
#include "font.ch"
#INCLUDE "protheus.ch"        

                                                                                                                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                                                             
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHEST208 ºAutor ³Douglas de S. Douradoº Data ³ XX/XX/XXXXº  ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±                            
±±ºDesc.     ³ RNC 			  				                              º±±                                     
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP11 - ESTOQUE E CUSTOS                                    º±±
±±º	         ³ TABELAS:  ZF4FN0(CABEÇALHO) E ZF5FN0(ITEMS)   			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                   

/*************************/
/******** BROWSE *********/
/*************************/

User Function NHEST208
Private oDlg
Private aRotina, cCadastro // variaveis do Mbrowse


cCadastro := "RNC"
aRotina   := {}
aAdd(aRotina,{ "Visualizar"	    ,"U_EST208(1)"   , 0 , 2})
aAdd(aRotina,{ "Incluir"		,"U_EST208(2)" 	 , 0 , 3})
aAdd(aRotina,{ "Destinar Saldo" ,"U_EST208(5)"   , 0 , 4})
aAdd(aRotina,{ "Estornar"       ,"U_EST208(4)"   , 0 , 4}) 
aAdd(aRotina,{ "Relatório"	    ,"U_EST208REL(3)" , 0 , 2})
aAdd(aRotina,{ "Legenda"        ,"U_E208Legenda()" , 0 , 1}) 
  
mBrowse(6,1,22,75,"ZF4",,,,,,fCriaCor())                   

Return

/*********************************************************/
/****************** Função Principal *********************/
/*********************************************************/

User Function EST208(nParam)
Local bOk         := {||}
Local bCanc       := {||oDlg:End()}
Local bEnchoice   := {||}
Private cNumRnc   := space(09), aCols := {}, _cDocRNC := ""
Private nPar 	  := nParam, cTitle, aHeader := {}, cResp := space(25), cProduto := space(15), dData := CtoD('  /  /  '),dDtRef := CtoD('  /  /  '), cDescProd := space(150), cDescDef := space(150)
Private cHorario  := space(05), cDefeito := space(03), cCarDef := space(03),cDescCarDef := space(150), cOperacao := space(03), cDescForn := space(100)
Private aSize     := MsAdvSize(), cAlmOri1 := space(02), cAlmDes1 := space(02), nSuspeito := 0, nRefugo := 0, nTotal := 0 , _lTransf := .T.
Private nAprovado := 0 , cForn := space(06) , cLoja := space(02), lArm := .F. , cLote := space(10), cEndereco := space(50) , lLote := .F., lEnd := .F.
Private aSize     := MsAdvSize(), VK_F4 := 115, cAlmOri2 := space(02), cAlmDes2 := space(02) , nSaldo := 0 , lDef := .F. 
Private aObjects  := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }} , cObs := space(70), cAlmDAp := space(02), cAlmDRe := space(02) 
Private aInfo     := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}, lTrans := .T. , cNrFis := space(08)
Private aPosObj   := MsObjSize( aInfo, aObjects, .T.) , lSus := .T. , lRef := .T. , lChkDev := .F. , cOp := space(13), lChkTry := .F.
Private nQtAp := 0, nQtRj := 0 , nTotal := 0, nSaldoAt := 0 , aRelato := {}, nPesoT := 0            
 
/************************************************************************/
/****************** Construindo o cabeçalho do ACols ********************/
/************************************************************************/
						
	Aadd(aHeader,{"Item" 	   , "D3_ITEM"      ,"@E 9999"            ,04,0,".F.","","C","SD3"})
	Aadd(aHeader,{"Motivo" 	   , "ZF5_MOTIVO"   , PesqPict("ZF5","ZF5_MOTIVO")  , 15,00, ".F.","","C","ZF5"})
	Aadd(aHeader,{"Produto"    , "D3_COD"       ,"@!"	              ,15,0,"","","C","SD3"})
	Aadd(aHeader,{"Descricao"  , "B1_DESC"      ,"@!"	              ,30,0,".F.","","C","SB1"})
	Aadd(aHeader,{"Quantidade" , "D3_QUANT"     ,"@E 999999999.99"    ,14,3,"","","N","SD3"})   
	Aadd(aHeader,{"Lote"       , "D3_LOTECTL"   ,"@!"                 ,10,0,"","","N","SD3"})   
	Aadd(aHeader,{"Endereco"   , "D3_LOCALIZ"   ,"@!"                 ,15,0,"","","N","SD3"}) 
	Aadd(aHeader,{"Documento"  , "ZF5_DOC"      , PesqPict("ZF5","ZF5_DOC")    , 09,00, ".F.","","C","ZF5"})
	Aadd(aHeader,{"Data"  	   , "ZF5_DATA"     , PesqPict("ZF5","ZF5_DATA")   , 10,00, "","","C","ZF5"})
	Aadd(aHeader,{"Horario"    , "ZF5_HOR"      , PesqPict("ZF5","ZF5_HOR")    , 05,00, ".F.","","C","ZF5"})
	Aadd(aHeader,{"Login"      , "ZF5_LOGIN"    , PesqPict("ZF5","ZF5_LOGIN")  , 25,00, ".F.","","C","ZF5"})
	aAdd(aHeader,{"Local Origem", "ZF5_ALMORI"  , PesqPict("ZF5","ZF5_ALMORI") , 02,00, ".F.","","C","ZF5"})
	aAdd(aHeader,{"Local Destino", "ZF5_ALMDES" , PesqPict("ZF5","ZF5_ALMDES") , 02,00, ".F.","","C","ZF5"})	

/************************************************************************/
/************* Identifica a operação que será realizada *****************/
/************************************************************************/
  
If nPar==1      //visualizar
    
	aCols := {}
    fCarrega()
    cTitle   := 'Visualizar RNC'  	 
    
ElseIf nPar==2  //incluir

    cTitle   := 'Inclusão de RNC'
	cNumRnc  := GetSxeNum("ZF4","ZF4_COD")
	cResp    := cUserName
	dData    := Ddatabase
	dDtRef   := Ddatabase
	aCols := {}
	cHorario := Substr(Time(),1,5)	     	     	 	 
	
ElseIf nPar==4  // estornar
    
	aCols := {}

	fCarrega()
	
    If ZF4->ZF4_EXT == 'S'
   	   MsgBox("Esta RNC já está estornada.","Atenção","STOP")
   	   Return .F.
   	EndIf 
   		
   	If ZF4->ZF4_EXTOK == 'N'
   	   MsgBox("Impossível estornar esta RNC, já houve destinação de saldo depois que ela foi criada.","Atenção","STOP")
   	   Return .F.
   	EndIf     
				
   	cTitle := 'Estornar'
   	
ElseIf nPar==5 // Destinar Saldo pendente

	aCols := {} 
    
    fCarrega()       
	cTitle := 'Destinar saldo pendente'
	
	If nSaldo == 0
	   MsgBox('Esta RNC já esta encerrada !','Todo o saldo de suspeitos já foi destinado','STOP')
	   Return		
	EndIf	

EndIf 	

/*****************************************************************************/
/********************** Inicialização dos Say's e Get's **********************/ 
/*****************************************************************************/

Define MsDialog oDlg Title (cTitle) From aSize[7],00 To aSize[6],aSize[5] Pixel

	@ 08,10  Say "Código da RNC:" PIXEL OF oDlg    	      
	@ 18,10  Get cNumRnc SIZE 35,10 WHEN .F. PIXEL OF oDlg     
	
	@ 08,60  Say "Ordem de Produção: " PIXEL OF oDlg
	@ 18,60 MSGet oOP VAR cOp SIZE 45,10 WHEN (nPar == 2) F3 "SC2" VALID fValOp() PIXEL OF oDlg
	
	@ 08,120  Say "Produto: " PIXEL OF oDlg
	@ 18,120  MSGet oProduto VAR cProduto SIZE 57,10 WHEN (nPar == 2) F3 "SB1" VALID fDesc(1) PIXEL OF oDlg 
	@ 18,180 Get cDescProd SIZE 110,10 WHEN (.F.) PIXEL OF oDlg 
		
	@ 08,300 Say "Responsável: " PIXEL OF oDlg    	      
	@ 18,300 Get cResp WHEN (.F.) SIZE 046,10 PIXEL OF oDlg
					
	@ 08,356 Say "Data: " PIXEL OF oDlg
	@ 18,356 Get dData WHEN (.F.) SIZE 50,10 PIXEL OF oDlg
	
	@ 08,416 Say "Horário: " PIXEL OF oDlg
	@ 18,416 Get cHorario WHEN (.F.) SIZE 17,10 PIXEL OF oDlg
	
	/****************************************************************/ 
	
	@ 37,10 Say "Característica do defeito: " PIXEL OF oDlg
	@ 46,10 MSGet oCarDef VAR cCarDef SIZE 15,10 WHEN (nPar == 2) F3 "SZ8" VALID fDesc(3) PIXEL OF oDlg  	
	@ 46,40 Get cDescCarDef SIZE 100,10 WHEN (.F.) PIXEL OF oDlg

	@ 37,146  Say "Observação: " PIXEL OF oDlg 
	@ 46,146  MsGet oObs VAR cObs SIZE 85,10 VALID fMinimo() WHEN (lDef) PIXEL OF oDlg 
	
	@ 37,240  Say "Defeito: " PIXEL OF oDlg
	@ 46,240  MSGet oDefeito VAR cDefeito SIZE 15,10 WHEN (nPar == 2) F3 "SZ6" VALID fDesc(2) PIXEL OF oDlg
	@ 46,270  MsGet oDescDef VAR cDescDef SIZE 72,10 WHEN (.F.) PIXEL OF oDlg 

	@ 37,350 Say "Operação: " PIXEL OF oDlg
	@ 46,350 Get cOperacao SIZE 15,10 WHEN (nPar == 2) PIXEL OF oDlg		
	
	@ 37,380 Say "Fornecedor: " PIXEL OF oDlg    	      
	@ 46,380 MSGet oForn VAR cForn SIZE 35,10 WHEN (nPar == 2) VALID fDesc(4) F3 "SA2" PIXEL OF oDlg  
	
	@ 37,420 Say "Loja: " PIXEL OF oDlg    	      
	@ 46,420 Get cLoja SIZE 15,10 WHEN (nPar == 2) VALID fDesc(5) PIXEL OF oDlg 	
	
	@ 37,441 Say "Descrição Fornecedor: " PIXEL OF oDlg    	      
	@ 46,441 Get cDescForn SIZE 150,10 WHEN (.F.) PIXEL OF oDlg
   
	/*****************************************************************/	

	@ 68,10 Say "Data de Referencia: " PIXEL OF oDlg
	@ 77,10 Get dDtRef WHEN (nPar == 2) SIZE 50,10 PIXEL OF oDlg  
		
	@ 68,75 Say "Nº Rnc Física: " PIXEL OF oDlg
	@ 77,75 Get cNrFis WHEN (nPar == 2) SIZE 30,10 PIXEL OF oDlg  
			
	@ 68,130 Say "Refugo: " PIXEL OF oDlg      
	@ 77,130 Get nRefugo SIZE 20,10 WHEN (nPar == 2) PICTURE "999999999" VALID fTotal() PIXEL OF oDlg 
	
	@ 68,170 Say "Alm. de Origem: " PIXEL OF oDlg    	      
	@ 77,170 MsGet oAlmOri2 VAR cAlmOri2 SIZE 20,10 WHEN (nPar == 2) VALID fValAlm(3) F3 "ALM" PIXEL OF oDlg
	
	@ 68,212 Say "Alm. de Destino: " PIXEL OF oDlg    	      
	@ 77,212 MsGet oAlmDes2 VAR cAlmDes2 SIZE 20,10 WHEN (nPar == 2) VALID fValAlm(4) F3 "ALM" PIXEL OF oDlg
	
	// Refugo	
	@ 077,238 BUTTON "Adicionar" Size 30,12 WHEN (nPar == 2) PIXEL OF oDlg action fGerar(2,.F.)
	@ 077,270 BUTTON "Estrutura" Size 30,12 WHEN (nPar == 2)  PIXEL OF oDlg action fGerar(2,.T.)	
		
	@ 68,312 Say "Quant. Total: " PIXEL OF oDlg    	      
	@ 77,312 Get nTotal SIZE 20,10 WHEN (.F.) PICTURE "999999999" PIXEL OF oDlg 
	
	@ 68,360 Say "Saldo Atual de Suspeitos: " PIXEL OF oDlg    	      
	@ 77,360 Get nSaldo SIZE 45,10 WHEN (.F.) PICTURE "999999999" PIXEL OF oDlg    		
	
	@ 96,10  Say "Suspeito: " PIXEL OF oDlg    	      
	@ 105,10  Get nSuspeito SIZE 20,10 WHEN (nPar == 2 ) PICTURE "999999999" VALID fTotal(1) PIXEL OF oDlg 
	
	@ 96,50  Say "Alm. de Origem: " PIXEL OF oDlg    	      
	@ 105,50  MsGet oAlmOri1 VAR cAlmOri1 SIZE 20,10 WHEN (nPar == 2) VALID fValAlm(1) F3 "ALM" PIXEL OF oDlg
	                                                                                                                          
	@ 96,93  Say "Alm. de Destino: " PIXEL OF oDlg    	      
	@ 105,93  MsGet oAlmDes1 VAR cAlmDes1 SIZE 20,10 WHEN (nPar == 2) VALID fValAlm(2) F3 "ALM" PIXEL OF oDlg
	
	// Suspeito
	@ 105,118 BUTTON "Adicionar" Size 30,12 WHEN (nPar == 2)  PIXEL OF oDlg action fGerar(1,.F.)
	@ 105,150 BUTTON "Estrutura" Size 30,12 WHEN (nPar == 2)  PIXEL OF oDlg action fGerar(1,.T.)	
	
	// Limpa o ACols
	@ 105,210 BUTTON "Limpar Tudo" Size 45,12 WHEN (nPar == 2) PIXEL OF oDlg action fLimpa() 
	
	// Check de Try-Out
	@ 108,285 CHECKBOX oChk2 VAR lChkTry PROMPT "Try-Out ?" WHEN (nPar == 2) SIZE 040,008 PIXEL OF oDlg  
	
	
	@ 96,360  Say "Peso total: " PIXEL OF oDlg    	      
	@ 105,360 Get nPesoT SIZE 50,10 WHEN (.F.) PICTURE "@e 999,999,999.99999" PIXEL OF oDlg 
	
    IF nPar == 5
    	@ 075,485 BUTTON "Destinar Saldo" Size 45,15 WHEN (nPar == 5) PIXEL OF oDlg action fDestinar()		
	ENDIF 
			
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)} // Enchoice Bar      
	    
    DbSelectArea("ZF5")	    
	@ 124,aPosObj[2,2] TO aPosObj[2,3],aPosObj[2,4] MULTILINE MODIFY DELETE OBJECT oMultiline 
    
		// Se for visualização ou extorno
		
		If nPar == 2 .OR. nPar == 4
			oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline
		EndIf
	    
	
Activate MsDialog oDlg ON INIT EnchoiceBar(oDlg,{||Confirmar(),.T.},{||Cancelar()})      

Return 

/*******************************************************************************************/
/************************ Dialogo da destinação de saldo da RNC ****************************/  
/*******************************************************************************************/

Static Function fDestinar()  
Local _cProd2 := cProduto
Local cAlmO2  := cAlmDes1 

aRelato := {}
nSaldoAt := nSaldo
      
oDlgDest := MsDialog():New(0,0,300,400,"Destinar Saldo Pendente da RNC",,,,,,,,,.T.)
	
	@ 010,010 Say "Produto:"  SIZE 040,010 Object olProd
	@ 008,035 Get _cProd2     SIZE 060,010 When .F. Object oProd
	
	@ 010,105 Say "Local Atual:" SIZE 070,010 Object olLocal
	@ 008,135 Get cAlmO2 SIZE 015,010 When .F. Object oLocal
	
	@ 027,005 Say "Saldo Atual:" SIZE 040,010 Object olLocal
	@ 025,035 Get nSaldoAt   SIZE 020,010 When .F. Object oLocal	
	
	/*************************************************************/                                                          
	@ 045,005 Say "APROVADO  _________________________________________________";
	SIZE 300,008 Object olLocal 
	
	@ 065,005 Say "Quantidade:" SIZE 040,010 PIXEL OF oDlgDest
	@ 063,035 Get nQtAp	SIZE 030,010 PICTURE "9999999999" Valid fSaldo(1) PIXEL OF oDlgDest
	
	@ 065,080 Say "Local Destino:" SIZE 060,010 Object olLocal
	@ 063,115 MsGet oAlmDAp Var cAlmDAp SIZE 030,010 VALID fValAlm(5) F3 "ALM" PIXEL OF oDlgDest  
	/*************************************************************/ 
	
	/*************************************************************/                                                          
	@ 085,005 Say "REFUGO   _________________________________________________";
	SIZE 300,010 Object olLocal 
	
	@ 105,005 Say "Quantidade:" SIZE 060,010 PIXEL OF oDlgDest 
	@ 103,035 Get nQtRj	SIZE 030,010 PICTURE "9999999999" Valid fSaldo(2) PIXEL OF oDlgDest
	
	@ 105,080 Say "Local Destino:" SIZE 060,010 Object olLocal
	@ 103,115 MsGet oAlmDRe Var cAlmDRe SIZE 030,010 VALID fValAlm(6) F3 "ALM" PIXEL OF oDlgDest 
   
	/*************************************************************/
    
	@ 130,132 BUTTON "OK" Size 30,13 PIXEL OF oDlgDest action fTransSald(nQtAp,nQtRj,cAlmO2,) //Close(oDlgDest)
	@ 130,168 BUTTON "Cancelar" Size 30,13 PIXEL OF oDlgDest action Close(oDlgDest)	
   
	oDlgDest:Activate(,,,.T.,{||.T.},,)

Return    

/*******************************************************************************************/
/**************************** Transferencia de saldo da RNC ********************************/  
/*******************************************************************************************/

Static Function fTransSald(nRet,nRef,cLocOrig)  // Quant para Retrabalho e Quant para Refugar  

Local aArray := {} 
Local cAl, dDataDis := dDataBase , _cHoraRel
Local nQt , nNewItem := space(04), lNewItem := .T.
Local cHor := Substr(Time(),1,5) , lTranApr , lTranRef 
Local cLoteVal := space(10), cUni
Private lMsErroAuto := .F.  
     
	If (nRet + nRef) > nSaldo .OR. nRet > nSaldo .OR. nRef > nSaldo
	   MsgBox("Quantidade para destinar é maior que o saldo atual, verifique","Saldo","Alert")		 	   
	   Return .F.
	EndIF          
	
	If cLocOrig == cAlmDAp .OR. cLocOrig == cAlmDRe
	   MsgBox("Impossível transferir para o mesmo almoxarifado","Almoxarifado de origem está igual ao de destino","Alert")		 	   
	   Return .F.
	EndIF          

	If nRet == 0 .AND. nRef == 0
	   MsgBox("Informe algum valor para retrabalho ou para refugar, para destinar o saldo","Campos em branco","Alert")		 	   
	   Return .F. 
	EndIf	

	If nRet <> 0 .AND. Empty(cAlmDAp)
	   MsgBox("Favor preencher o almoxarifado de destino dos produtos para retrabalho","Local em branco","Alert")	
	   Return .F.
 	EndIF
    
	If nRef <> 0 .AND. Empty(cAlmDRe)
	   MsgBox("Favor preencher o almoxarifado de destino dos refugos","Local em branco","Alert")	
	   Return .F.
 	EndIF

	If (nSaldo - (nRet + nRef)) == 0
	    If !MsgYesNo("Os valores informados irão zerar o saldo e encerrar a RNC, deseja continuar ?","Finalização da RNC","INFO")
	       Return 
	    EndIF
	EndIF
	
	//Pedido da Andrea 09/11/12	
	If !Empty(cAlmDRe) .AND. !cAlmDRe$'20/29/30/39/40/49/50/59' .AND. SM0->M0_CODIGO == "FN"
	   MsgBox("Impossível transferir refugo para este armazem ! Coloque um armazem de refugo válido ! (20,29,30,39,40,49,50,59)","Almoxarifado de refugo não é valido.","Alert")		 	   
	   Return .F.
	EndIF
        
	/******************************************************/
	/*************** Transf. de Aprovadas *****************/
	/******************************************************/
		
    If  nPar == 5 .AND. nRet <> 0 
    
    	lTranApr := .F.     	
    		
		DbSelectArea("SD3")
		
		aArray := {{_cDocRNC,;	 	 // 01. Numero do Documento
					dDataDis}}	 // 02. Data da Transferencia	
		
	    SB1->(DBSETORDER(1)) // FILIAL + COD
		
		For xC:=1 to Len(aCols)
			If !aCols[xC][len(aheader)+1] .AND. AllTrim(Acols[xC][2]) == 'SUSPEITO'  // Não pega deletados e só pega o suspeito
    
		  		SB1->(DbSeek(xFilial("SB1")+Acols[xC][3]))	// Busca o prod. no SB1
		  		
		  		// Adicionado em 26/11/12 visando controlar produtos com quantidade quebrada ou inteira
		  		cUni := SB1->B1_UM
				
			    //-- DETALHE
			    // Pega a quantidade relativa à quantidade parcial informada.
			    nQt := ((aCols[xC][5] / nSuspeito) * nQtAp)
			    
			    // Busca um Lote	    	
				 					
				aAdd(aArray,{   SB1->B1_COD,;					// 01.Produto Origem
								SB1->B1_DESC,;  				// 02.Descricao
								SB1->B1_UM,; 	                // 03.Unidade de Medida
								cLocOrig,; 						// 04.Local Origem
								aCols[xC][7],;					// 05.Endereco Origem
								SB1->B1_COD,;					// 06.Produto Destino
								SB1->B1_DESC,;					// 07.Descricao
								SB1->B1_UM,;					// 08.Unidade de Medida
						    	cAlmDAp,; 						// 09.Armazem Destino
								aCols[xC][7],;        			// 10.Endereco Destino
								CriaVar("D3_NUMSERI",.F.),;		// 11.Numero de Serie
								aCols[xC][6] , ;           		// 10.Lote Origem
								CriaVar("D3_NUMLOTE",.F.),;		// 13.Sublote
								CriaVar("D3_DTVALID",.F.),;		// 14.Data de Validade
								CriaVar("D3_POTENCI",.F.),;		// 15.Potencia do Lote
								Iif(cUni == 'KG',nQt,Ceiling(nQt)),; // 16.Quantidade  
								CriaVar("D3_QTSEGUM",.F.),;		// 17.Quantidade na 2 UM
								CriaVar("D3_ESTORNO",.F.),;		// 18.Estorno
								CriaVar("D3_NUMSEQ",.F.),;		// 19.NumSeq  
							    aCols[xC][6],;	   	    	    // 10.Lote Destino								
								CRIAVAR("D3_DTVALID",.F.),;     // 21.Data Validade
								CRIAVAR("D3_ITEMGRD",.F.),;     // 22.Item da grade
								AllTrim(cCarDef),;				// caracteristica do defeito
								AllTrim(cDefeito),;				// Defeito 		  
								AllTrim(cOperacao),;			// Operação
								AllTrim("002159"),;	//(cForn),;                // Fornecedor 
								AllTrim("01"),;				//(cLoja),;				// Loja
								CRIAVAR("D3_LOCORIG",.F.),;
								SB1->B1_CC,;                    // Centro de Custo
								CRIAVAR("D3_TURNO",.F.),;       // Turno
								CRIAVAR("D3_MAQUINA",.F.),;     
								CRIAVAR("D3_LINHA",.F.),;		  
								cProduto,;	   // Cod Pa - Adicionado em 13/12/12									
								dDtRef,;
								CRIAVAR("D3_CORRID",.F.),;	   // Data de Referencia da RNC - 26-04-13 			 
								CRIAVAR("D3_CORRIDA",.F.),;	   // Data de Referencia da RNC - 11/03/14 			 								
								CRIAVAR("D3_OP",.F.)})	       // ADIDIONADO 21/10/2013 - OEE X OP
															
								If lNewItem
								   nNewItem := VAL(STRZERO(Len(aCols)+1,4))
								   lNewItem := .F.
								EndIf 
								
								//Aadd(Acols,{STRZERO(Len(aCols)+1,4),"Retrabalhado", SB1->B1_COD, SB1->B1_DESC,_nQuant, ;
								Aadd(Acols,{STRZERO(Len(aCols)+1,4),"APROVADO", SB1->B1_COD, SB1->B1_DESC,Int(nQt), ;              
								     aCols[xC][6],aCols[xC][7],_cDocRNC,dDataDis,cHor,cUserName,cLocOrig,cAlmDAp,.F.})
						    																										    			
			EndIf
		Next
	    
		dbSelectArea("SD3")
		 
		aArray[1][1] := _cDocRNC := NextNumero("SD3",2,"D3_DOC",.T.) //pega o proximo numero do documento do d3_doc 
		
		// Verifica se gerou um número de documento no D3
		If Empty(aArray[1][1]) 
		   aArray[1][1] := _cDocRNC := NextNumero("SD3",2,"D3_DOC",.T.)		
			 If Empty(aArray[1][1])
			   MsgBox("Verifique se existe saldo suficiente no sistema para fazer a transferencia !","DOC NÃO GERADO (SUSPEITO)","ALERT")	
			   Return .F.
			 EndIf
		EndIf	
		
		Processa({|| MSExecAuto({|x| MATA261(x)},aArray)},"Aguarde. Transferindo peças aprovadas...") // processamento da transf.
		
		// Caso tenha erros      		
		If  lMsErroAuto		
			mostraerro()                                
			DisarmTransaction()
			Return .F. 					
		Else 		
		// VERIFICA SE EXISTE A MOVIMENTACAO NO D3 POR PRECAUCAO
			cAl := getnextalias()
			beginSql Alias cAl
				SELECT D3_DOC FROM %Table:SD3% 
				WHERE D3_DOC = %Exp:_cDocRNC%
			endSql	
			
			//-- SE EXISTIR, ENCERRA A TRANSFERENCIA
			If (cAl)->(!Eof())				
								
				For x := nNewItem to Len(aCols)
					
					aCols[x][8] := _cDocRNC
							     
					RecLock("ZF5",.T.) 	     	    
			   			ZF5->ZF5_FILIAL  := xFilial("ZF5")		
						ZF5->ZF5_CODRNC	 := cNumRnc			
						ZF5->ZF5_ITEM	 := aCols[x][1]						
						ZF5->ZF5_MOTIVO	 := AllTrim(aCols[x][2])
						ZF5->ZF5_PROD	 := aCols[x][3]
						ZF5->ZF5_DESC	 := AllTrim(aCols[x][4])					
						ZF5->ZF5_QUANT   := aCols[x][5]
						ZF5->ZF5_LOTE    := aCols[x][6]
						ZF5->ZF5_END     := aCols[x][7]
						ZF5->ZF5_DOC     := aCols[x][8]
						ZF5->ZF5_DATA    := aCols[x][9]
						ZF5->ZF5_HOR     := aCols[x][10]
						ZF5->ZF5_LOGIN   := aCols[x][11]					
						ZF5->ZF5_ALMORI  := aCols[x][12]
						ZF5->ZF5_ALMDES  := aCols[x][13]
					MsUnlock("ZF5")
									
		   		Next 
		   		
		   		RecLock("ZF4",.F.) 
		  		   ZF4->ZF4_SALDO := nSaldo - nRet
		  		   ZF4_EXTOK := 'N'
				MsUnLock("ZF4")				
				
				nSaldo := ZF4->ZF4_SALDO
		   		
		   		lTranApr := .T.
		   		
		   		lNewItem := .T. 
		   		
		   		_cDocRNC := ""
		   		 
				(cAl)->(dbclosearea())				

			Else 
			
				(cAl)->(dbclosearea())
				DisarmTransaction()
				lTranApr := .F.
				
			EndIf    

		EndIf	
			
	EndIf
	
	/****************************************************/
	/*************** Transf. de Refugo  *****************/
	/****************************************************/
		
    If  nPar == 5 .AND. nRef <> 0 // Op. Destinar Saldo 
    	
    	lTranRef := .F.
    		
		DbSelectArea("SD3")
		
		aArray := {{_cDocRNC,;	 	 // 01. Numero do Documento
					dDataDis}}	 // 02. Data da Transferencia	
		
	    SB1->(DBSETORDER(1)) // FILIAL + COD
		
		For xC:=1 to Len(aCols)
			If !aCols[xC][len(aheader)+1] .AND. AllTrim(Acols[xC][2]) == 'SUSPEITO'  // Não pega deletados e só pega o suspeito(primeira inclusão)
    
		  		SB1->(DbSeek(xFilial("SB1")+Acols[xC][3]))	// Busca o prod. no SB1			
				
			    //--DETALHE
			    // Pega a quantidade parcial referente à quantidade informada.			    
			    nQt := ((aCols[xC][5] / nSuspeito) * nQtRj)
				 					
				aAdd(aArray,{   SB1->B1_COD,;					// 01.Produto Origem
								SB1->B1_DESC,;  				// 02.Descricao
								SB1->B1_UM,; 	                // 03.Unidade de Medida
								cLocOrig,; 						// 04.Local Origem
								aCols[xC][7],;					// 05.Endereco Origem
								SB1->B1_COD,;					// 06.Produto Destino
								SB1->B1_DESC,;					// 07.Descricao
								SB1->B1_UM,;					// 08.Unidade de Medida
						    	cAlmDRe,; 						// 09.Armazem Destino
								aCols[xC][7],;        			// 10.Endereco Destino
								CriaVar("D3_NUMSERI",.F.),;		// 11.Numero de Serie
								aCols[xC][6],;					// 10.Lote Origem
								CriaVar("D3_NUMLOTE",.F.),;		// 13.Sublote
								CriaVar("D3_DTVALID",.F.),;		// 14.Data de Validade
								CriaVar("D3_POTENCI",.F.),;		// 15.Potencia do Lote
								Iif(cUni == 'KG',nQt,Ceiling(nQt)),; // 16.Quantidade  
								CriaVar("D3_QTSEGUM",.F.),;		// 17.Quantidade na 2 UM
								CriaVar("D3_ESTORNO",.F.),;		// 18.Estorno
								CriaVar("D3_NUMSEQ",.F.),;		// 19.NumSeq  
								aCols[xC][6],;					// 10.Lote Destino								
								CRIAVAR("D3_DTVALID",.F.),;     // 21.Data Validade
								CRIAVAR("D3_ITEMGRD",.F.),;     // 22.Item da grade
								cCarDef,;						// caracteristica do defeito
								cDefeito,;						// Defeito 		  
								cOperacao,;						// Operação
								cForn,;                         // Fornecedor 
								cLoja,;							// Loja
								CRIAVAR("D3_LOCORIG",.F.),;
								SB1->B1_CC,;                    // Centro de Custo
								CRIAVAR("D3_TURNO",.F.),;       // Turno
								CRIAVAR("D3_MAQUINA",.F.),;     
								CRIAVAR("D3_LINHA",.F.),;								
								cProduto,;
								dDtRef,;
								CRIAVAR("D3_CORRID",.F.),;	   // Data de Referencia da RNC - 26-04-13     
								CRIAVAR("D3_CORRIDA",.F.),;	   
								CRIAVAR("D3_OP",.F.)})	       // ADIDIONADO 21/10/2013 - OEE X OP															
								If lNewItem
								   nNewItem := VAL(STRZERO(Len(aCols)+1,4))
								   lNewItem := .F.
								EndIf
								
								Aadd(Acols,{STRZERO(Len(aCols)+1,4),"REFUGO", SB1->B1_COD, SB1->B1_DESC,Int(nQt), ;
								     aCols[xC][6],aCols[xC][7],_cDocRNC,dDataDis,cHor,cUserName,cLocOrig,cAlmDRe,.F.})	 															  																										    				
			EndIf
		Next
	    
		dbSelectArea("SD3")
		 
		aArray[1][1] := _cDocRNC := NextNumero("SD3",2,"D3_DOC",.T.) // pega o proximo numero do documento do d3_doc
		
		// Verifica se gerou um número de documento no D3
		If Empty(aArray[1][1]) 
		   aArray[1][1] := _cDocRNC := NextNumero("SD3",2,"D3_DOC",.T.)		
			 If Empty(aArray[1][1])
			   MsgBox("Verifique se existe saldo suficiente para fazer a transferencia.","DOC NÃO GERADO (REFUGO)","ALERT")	
			   Return .F.
			 EndIf
		EndIf			
		
		Processa({|| MSExecAuto({|x| MATA261(x)},aArray)},"Aguarde. Transferindo peças refugadas...") // processamento da transf.
		
		// Caso tenha erros      		
		If  lMsErroAuto		
			mostraerro()                                                   
			DisarmTransaction()
			Return .F. 					
		Else 		
			//-- VERIFICA SE EXISTE A MOVIMENTACAO NO D3 POR PRECAUCAO
			cAl := getnextalias()
			beginSql Alias cAl
				SELECT D3_DOC FROM %Table:SD3% 
				WHERE D3_DOC = %Exp:_cDocRNC%
			endSql	
			
			//-- SE EXISTIR, ENCERRA A TRANSFERENCIA
			If  (cAl)->(!Eof())				
				
				RecLock("ZF4",.F.) 
		  		   ZF4->ZF4_SALDO := nSaldo - nRef
		  		   ZF4_EXTOK := 'N'
				MsUnLock("ZF4")  
								
				For x := nNewItem to Len(aCols)
				
					aCols[x][8] := _cDocRNC
							     
					RecLock("ZF5",.T.) 	     	    
			   			ZF5->ZF5_FILIAL  := xFilial("ZF5")		
						ZF5->ZF5_CODRNC	 := cNumRnc			
						ZF5->ZF5_ITEM	 := aCols[x][1]						
						ZF5->ZF5_MOTIVO	 := AllTrim(aCols[x][2])
						ZF5->ZF5_PROD	 := aCols[x][3]
						ZF5->ZF5_DESC	 := AllTrim(aCols[x][4])					
						ZF5->ZF5_QUANT   := aCols[x][5]
						ZF5->ZF5_LOTE    := aCols[x][6]
						ZF5->ZF5_END     := aCols[x][7]
						ZF5->ZF5_DOC     := aCols[x][8]
						ZF5->ZF5_DATA    := aCols[x][9]
						ZF5->ZF5_HOR     := aCols[x][10]
						ZF5->ZF5_LOGIN   := aCols[x][11]					
						ZF5->ZF5_ALMORI  := aCols[x][12]
						ZF5->ZF5_ALMDES  := aCols[x][13]
					MsUnlock("ZF5")
					
				     	_cHoraRel :=  aCols[x][10]
							
		   		Next  
		   		
		   		lTranRef := .T. 
		   		
		   		lNewItem := .T.	   	     
				
				nSaldo := ZF4->ZF4_SALDO

				(cAl)->(dbclosearea())				

			Else 
			
				(cAl)->(dbclosearea())
				DisarmTransaction()
				lTranRef := .F.
				
			EndIf    

		EndIf	
			
	EndIf	
	
	// Alert informando o resultado da(s) transferencia(s)
	
	If nRet <> 0 .AND. nRef <> 0
	   If lTranApr .AND. lTranRef		 
	      MsgBox("Transferencia dos suspeitos e refugos foi feita com sucesso ! ","OK","INFO")
	   Else 
	   	  MsgBox(" Não foi possível executar a transferência! ","OK","ALERT")      
	   EndIF
	EndIF	   
	
	If nRet <> 0 .AND. nRef == 0
	   If lTranApr 
	       MsgBox("Transferencia de retrabalhos foi feita com sucesso ! ","OK","INFO")
	   Else
	   	   MsgBox(" Não foi possível executar a transferência! ","Destina Saldo (639)","ALERT")	
	   EndIf
	EndIf    
          
    If nRet == 0 .AND. nRef <> 0
	   If lTranRef 
	       MsgBox("Transferencia de refugos foi feita com sucesso ! ","OK","INFO")
	   Else 
	   	   MsgBox(" Não foi possível executar a transferência! ","OK","ALERT")	
	   EndIf
	EndIf  
	
	If nSaldo == 0	   
	  
	   // Dados p/ o relatorio de movimentação
	   If lTranApr
	      Aadd(aRelato,{cNumRnc,cProduto,cDescProd,AllTrim(cLocOrig),AllTrim(cAlmDAp),nQtAp,dDataBase,cHor,AllTrim(cUserName),"APROVADO"})
	   EndIF 
	   
	   If lTranRef
		   Aadd(aRelato,{cNumRnc,cProduto,cDescProd,AllTrim(cLocOrig),AllTrim(cAlmDRe),nQtRj,dDataBase,cHor,AllTrim(cUserName),"REFUGO"})
	   EndIF 
	   
	   oDlgDest:End()
	   oDlg:End()			 	   
	   
	Else
	   
	   MsgBox("Saldo atual depois das transferencias: "+AllTrim(STR(nSaldo)),"RNC em aberto","INFO")

	   // Dados p/ o relatorio de movimentação
	   If lTranApr
	      Aadd(aRelato,{cNumRnc,cProduto,cDescProd,cLocOrig,cAlmDAp,nQtAp,dDataBase,cHor,AllTrim(cUserName),"APROVADO"})
	   EndIF 
	   
	   If lTranRef
		   Aadd(aRelato,{cNumRnc,cProduto,cDescProd,cLocOrig,cAlmDRe,nQtRj,dDataBase,cHor,AllTrim(cUserName),"REFUGO"})
	   EndIF 
	   	   	   	   
	   oDlgDest:End()
	   oDlg:End()
	   
	EndIf	    
	
	nQtAp := 0
	cAlmDAp := SPACE(02)
	nQtRj := 0 
	cAlmDRe := SPACE(02)
	nTotal := 0
	nSaldoAt := nSaldo
	aRelato := {}

Return                                                                               

/*******************************************************************************************/
/**************************** Limpa todos os itens do Acols ********************************/  
/*******************************************************************************************/
Static Function fLimpa()

	aCols := {}
	lSus := .T.
	lRef := .T.

Return

/*******************************************************************************************/
/**************************** Valida o armazem digitado ************************************/  
/*******************************************************************************************/
Static Function fValAlm(Alm)

	SX5->(Dbgotop())       
	SX5->(DbSetOrder(1)) //filial+cod	

	If Alm == 1 .AND. !SX5->(DbSeek(xFilial("SX5")+'ZA'+cAlmOri1)) .AND. AllTrim(cAlmOri1) <> '' //tabela de almoxarifados
	    MsgBox( "Este Armazem não existe! Favor verificar.", "Validação Alm. Origem - Suspeito", "ALERT" ) 
	    Return .F.
	EndIf

	If Alm == 2 .AND. !SX5->(DbSeek(xFilial("SX5")+'ZA'+cAlmDes1)) .AND. AllTrim(cAlmDes1) <> '' //tabela de almoxarifados
	    MsgBox( "Este Armazem não existe! Favor verificar.", "Validação Alm. Destino - Suspeito", "ALERT" ) 
	    Return .F.
	EndIf
	
	If Alm == 3 .AND. !SX5->(DbSeek(xFilial("SX5")+'ZA'+cAlmOri2)) .AND. AllTrim(cAlmOri2) <> '' //tabela de almoxarifados
	    MsgBox( "Este Armazem não existe! Favor verificar.", "Validação Alm. Origem - Refugo", "ALERT" ) 
	    Return .F.
	EndIf
	
	If Alm == 4 .AND. !SX5->(DbSeek(xFilial("SX5")+'ZA'+cAlmDes2)) .AND. AllTrim(cAlmDes2) <> '' //tabela de almoxarifados
	    MsgBox( "Este Armazem não existe! Favor verificar.", "Validação Alm. Origem - Refugo", "ALERT" ) 
	    Return .F.
	EndIf
	
	If Alm == 5 .AND. !SX5->(DbSeek(xFilial("SX5")+'ZA'+cAlmDAp)) .AND. AllTrim(cAlmDAp) <> ''  //tabela de almoxarifados
	    MsgBox( "Este Armazem não existe! Favor verificar.", "Validação Alm. Destino - Aprovado", "ALERT" ) 
	    Return .F.
	EndIf
	
	If Alm == 6 .AND. !SX5->(DbSeek(xFilial("SX5")+'ZA'+cAlmDRe)) .AND. AllTrim(cAlmDRe) <> ''//tabela de almoxarifados
	    MsgBox( "Este Armazem não existe! Favor verificar.", "Validação Alm. Destino - Refugo", "ALERT" ) 
	    Return .F.
	EndIf
	

Return .T.

/*******************************************************************************************/
/************************* Validação de quantidade para destinar ***************************/  
/*******************************************************************************************/

Static Function fSaldo(tipo)
Local nTot := nQtAp + nQtRj

	If tipo == 1
	   If nQtAp > nSaldoAt
	   	  Alert("Quantidade para aprovação é maior que o saldo atual, favor corrigir.","Atenção!","STOP")
	   	  Return .F.
	   EndIF
	ElseIf tipo == 2
	   If nQtRj > nSaldoAt
	   	  Alert("Quantidade para rejeitar é maior que o saldo atual, favor corrigir.","Atenção!","STOP")
	   	  Return .F.
	   EndIF 
	EndIF
    
    // Confere se quantidades excedem o saldo
    If nTot > nSaldoAt 
	    Alert("Quantidade para aprovação é maior que o saldo atual, favor corrigir.","Atenção!","STOP")
	   	Return .F.
    EndIF

Return .T.

/*******************************************************************************************/
/***************************** Validação do campo observação *******************************/  
/*******************************************************************************************/

Static Function fMinimo() 

If Len(AllTrim(cObs)) < 10
	Alert("Favor Preencher corretamente a observação! (Mínimo 10 caracteres)")
	Return .F.
EndIF

Return  .T.                                                                     


// ADICIONADO EM 12/12/13 PARA OEE PERNAMBUCO

/*******************************************************************************************/
/***************************** Validação do campo OP ***************************************/  
/*******************************************************************************************/

Static Function fValOp() 

If Empty(AllTrim(cOp)) .AND. SM0->M0_CODFIL$"02" .AND. SM0->M0_CODIGO$"FN"
   Alert("Favor Preencher o campo Ordem de Produção !")
   Return .F.
EndIF

If !Empty(AllTrim(cOp)) .AND. SM0->M0_CODFIL$"02" .AND. SM0->M0_CODIGO$"FN"

	SC2->(DbSetOrder(1)) //C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN   

	If SC2->( DbSeek(xFilial("SC2") + AllTrim(cOp) ))
	   cProduto	:= SC2->C2_PRODUTO
	EndIf  
	
EndIF


Return  .T.                                                                     

/*******************************************************************************************/
/************************* Validação do total refugo + suspeito ****************************/  
/*******************************************************************************************/
                                                                       
Static Function fTotal(tipo)  

	nTotal := nRefugo + nSuspeito // Preenche o campo "quantidade total" 
	
	If tipo == 1 // Atualiza o campo saldo atual para retrabalho
	   nSaldo := nSuspeito
	EndIF   
		
Return  .T.

/*******************************************************************************************/
/********** Preenche o campo descrição de um determinado campo *****************************/  
/*******************************************************************************************/

Static Function fDesc(tipo)

DO CASE 

	CASE tipo == 1 // Preenche descrição do produto
 
		DbSelectArea("SB1")
		DbSetOrder(1)
		If DbSeek(xFilial("SB1")+cProduto)
			cDescProd := SB1->B1_DESC	
		Else
			MsgBox("Produto não encontrado ! Digite um produto válido.","Atenção","Alert")
			Return .F.
		EndIf
		
	CASE tipo == 2 // Preenche descrição do defeito
	    
	    IF nPar == 2 .AND. cDefeito == '016' .AND. cCarDef == '410'  // Caso de Inclusão            	  
	       	  lDef := .T.	       	  
	   		  oObs:Refresh()
	    EndIF  	  
	   
	   If nPar == 2
		   SZ6->(DbSetOrder(1)) //filial+cod  
		   
		   If SM0->M0_CODIGO <> 'IT' // Adicionado em 21/03/14 a pedido da silvana.moreira			   
		       If SZ6->(Dbseek(xfilial("SZ6")+cDefeito))
			      cDescDef := SZ6->Z6_DESC
			   ElseIf AllTrim(cDefeito) == ''	    
			   	  MsgBox( "Codigo do defeito nao pode ficar em branco! ", "Validação Campo Defeito", "ALERT" )      
		          Return .F. 
		       Else
		          MsgBox( "Codigo do defeito nao existe!", "Validação Campo Defeito", "ALERT" )      
		          Return .F.
			   EndIF	        		
		   EndIf
		   		   
 	   EndIf
 	   
 	   If nPar == 1 .OR. nPar == 4 .OR. nPar == 5
  	 	  	DbSelectArea("SZ6")
			DbSetOrder(1)
			DbSeek(xFilial("SZ6")+cDefeito)
			cDescDef := SZ6->Z6_DESC
	   EndIF
	
	CASE tipo == 3   // Preenche descrição da "Caracteristica do Defeito"           
	   
	    If nPar == 2
		    SZ8->(DbSetOrder(1)) //filial+cod	
			If SZ8->(DbSeek(xFilial("SZ8")+cCarDef))
			   cDescCarDef := SZ8->Z8_DESC 
			Else
	          MsgBox( "Caracteristica do defeito nao existe!", "Validação Campo Caracteristica do Defeito", "ALERT" )      
	          Return .F.
		    EndIF 
	    EndIf
	    
	    If nPar == 1 .OR. nPar == 4 .OR. nPar == 5
  	 	  	DbSelectArea("SZ8")
			DbSetOrder(1)                                    
			DbSeek(xFilial("SZ8")+cCarDef)
			cDescCarDef := SZ8->Z8_DESC
	    EndIF
		
	CASE tipo == 4  // Preenche descrição do "Fornecedor"
	
		DbSelectArea("SA2")
		DbSetOrder(1)
		
		If DbSeek(xFilial("SA2")+cForn)
		   cDescForn := SA2->A2_NOME   
		   Return .T.				      
		Else
		   MsgBox("Fornecedor não encontrado ! Digite um fornecedor válido !","Fornecedor não encontrado","ALERT")
		   Return .F.
		Endif   
		
	CASE tipo == 5   
	
	    DbSelectArea("SA2")
		DbSetOrder(1)
		
   		If DbSeek(xFilial("SA2")+cForn+cLoja)	    
     	   cDescForn := SA2->A2_NOME 				      
  	   	   Return .T.
		Else
		   MsgBox("Loja não encontrada para este fornecedor ! Digite uma loja válida !","Loja não encontrada","ALERT")
		   Return .F.
		Endif   
		
ENDCASE  	    	 	

Return .T.

/*******************************************************************************************/
/***************************** Carrega os campos do dialog *********************************/  
/*******************************************************************************************/
Static Function fCarrega()  	
Local cQuery

	cNumRnc      := ZF4->ZF4_COD 
	cProduto	 := ZF4->ZF4_PROD
	cResp   	 := ZF4->ZF4_LOGIN	
	dData        := ZF4->ZF4_DATA
	cHorario     := ZF4->ZF4_HORA	
	dData 		 := ZF4->ZF4_DATA
	cAlmOri1	 := ZF4->ZF4_ARMORT // Al. Origem de Retrabalho
	cAlmDes1	 := ZF4->ZF4_ARMDRT // Al. Destino de Retrabalho
	cAlmOri2	 := ZF4->ZF4_ARMORJ // Al. Origem de Rejeitado
	cAlmDes2	 := ZF4->ZF4_ARMDRJ // Al. Destino de Rejeitado
	cCarDef      := ZF4->ZF4_CADEF	
	cDefeito     := ZF4->ZF4_DEF 	
    cObs 	 	 := ZF4->ZF4_OBS	
	cOperacao	 := ZF4->ZF4_OPER
	nSuspeito    := ZF4->ZF4_RETRAB
	nRefugo	     := ZF4->ZF4_REJET    
	cForn		 := ZF4->ZF4_FORN
   	cLoja		 := ZF4->ZF4_LOJA
   	nTotal 		 := nRefugo + nSuspeito 
    nSaldo 		 := ZF4->ZF4_SALDO
    cNrFis	     := ZF4->ZF4_NRFIS
    dDtRef		 := ZF4->ZF4_DTREF 
    cOp			 := ZF4->ZF4_OP
    nPesoT		 := ZF4->ZF4_PESO
    lChkTry		 := iif(ZF4->ZF4_TRYOUT == 'S',.T.,.F.)	 
    fDesc(1)     // Carrega Descrição do Produto
    fDesc(2)   	 // Carrega Descrição do Defeito  
    fDesc(3)	 // Carrega Descrição da Caracteristica do Def.
   	fDesc(4)	 // Carrega Descrição do Fornecedor
                                  
 		cQuery := " SELECT ZF5_FILIAL, ZF5_ITEM, ZF5_MOTIVO, ZF5_PROD, ZF5_DESC, ZF5_QUANT, "
 	    cQuery += " ZF5_LOTE, ZF5_END, ZF5_DOC, ZF5_DATA, ZF5_HOR, ZF5_LOGIN, ZF5_ALMORI, ZF5_ALMDES "
		cQuery += " FROM "+RetSqlName("ZF5")+" ZF5, " +RetSqlName("ZF4")+" ZF4 " 
		cQuery += " WHERE ZF4.ZF4_COD = '"+cNumRnc+"' "		
		cQuery += " AND ZF5.ZF5_CODRNC = ZF4.ZF4_COD "		
		cQuery += " AND ZF5.ZF5_FILIAL = '"+xFilial("ZF5")+"' "
		cQuery += " ORDER BY ZF5.ZF5_ITEM"		
		
		TcQuery cQuery NEW ALIAS "ITENS" 	
			
		ITENS->(dbGoTop())  
		
		//ITENS DO ACOLS
		While !ITENS->(Eof())   
		    aAdd(aCols,{AllTrim(ITENS->ZF5_ITEM),;  		    	
				AllTrim(ITENS->ZF5_MOTIVO),;    // Motivo
			    ITENS->ZF5_PROD  ,;				// Produto
				AllTrim(ITENS->ZF5_DESC)  ,;    // Descricao
				ITENS->ZF5_QUANT,;     		    // Quantidade
				ITENS->ZF5_LOTE,;			    // Lote
				ITENS->ZF5_END,; 			    // Endereço 
				ITENS->ZF5_DOC,;       			// Documento
				StoD(ITENS->ZF5_DATA),; 	    // Data
				ITENS->ZF5_HOR,;                // Hora
				ITENS->ZF5_LOGIN,;              // Login
				ITENS->ZF5_ALMORI,;             // Local Orig.
				ITENS->ZF5_ALMDES,;             // Local Dest.
				.F.}) 								
				ITENS->(DbSkip())					    						
    	EndDo   
    	   	
    	ITENS->(DbCloseArea())     			
Return

/*******************************************************************************************/
/***************************** Inclui, Destina, ou Estorna *********************************/  
/*******************************************************************************************/

Static Function Confirmar() 
Local aAuto := {}, _dDataEst := dDataBase , _cHorEst := Substr(Time(),1,5)
Local aDocEst := {}, cDocAt := space(09)
Private lMsErroAuto := .F.
 
 DO CASE // Verifica a operação que será feita
  
	CASE nPar == 2    // Inclui um novo registro 
	    
		IF !Validar()
			Return  
   		EndIf
   		
   		If _lTransf // Falso se for o mesmo alm. de origem e destino, então não precisa transferir.             
   		
   		   Begin Transaction
   			If fTransfere() // Se Transferencia der certo...
   			
   			    // Verifica Cod da RNC 
   			       		   		
				DbSelectArea("ZF4")
				
				ZF4->(DBSETORDER(1))
				
				// Validacao mais forte em cima do cod. da RNC, afim de não obter RNC's com cod. iguais
				While ZF4->(DBSEEK(xFilial("ZF4")+cNumRnc)) // FILIAL + COD DA RNC
				   	  cNumRnc  := GetSxeNum("ZF4","ZF4_COD")
				Enddo  
				                   
				// Validacao mais forte na gravacao do documento				
				If Empty(_cDocRNC)				   
				   For xP:=1 to Len(aCols)
               		  If !aCols[xP][len(aHeader)+1] // Nao pega quando estiver deletado
               		  				   
						cAl1 := getnextalias()
						
						beginSql alias cAl1
							SELECT D3_DOC FROM %Table:SD3%
							WHERE D3_COD = %Exp:aCols[xP][3]%
							AND D3_EMISSAO = %Exp:DtoS(aCols[xP][9])%
							AND D3_QUANT = %Exp:aCols[xP][5]%
							AND ((D3_LOCAL = %Exp:aCols[xP][12]% AND D3_TM > '500') OR (D3_LOCAL = %Exp:aCols[xP][13]% AND D3_TM < '500' ))
							AND D3_FILIAL = %xFilial:SD3%
							AND %NotDel%
							AND D3_ESTORNO <> 'S'   							
						endsql
					
							If (cAl1)->(eof())
								MsgBox("Não foi possível concluir a RNC","Erro na autenticação da Transferencia","ALERT")
								RollBackSx8()
								oDlg:End()
							Else
								_cDocRNC := (cAl1)->D3_DOC
							Endif
					
					    	(cAl1)->(dbclosearea())	
						
					  EndIf						    
				   Next
				EndIf
			    
			    If AllTrim(_cDocRNC) == '' 
			       MsgBox("Saldo insuficiente ou falta endereçar, verifique.","Valida Documento","INFO")
 				   RollBackSx8()
			       oDlg:End()   	   					 	    
				Else
					RecLock("ZF4",.T.) 	     	    
						ZF4->ZF4_FILIAL := xFilial("ZF4")		
						ZF4->ZF4_COD 	:= cNumRnc			
						ZF4->ZF4_PROD  	:= cProduto
						ZF4->ZF4_DATA   := dData
						ZF4->ZF4_HORA   := cHorario
						ZF4->ZF4_CADEF  := cCarDef
						ZF4->ZF4_DEF    := cDefeito
						ZF4->ZF4_OPER   := cOperacao
						ZF4->ZF4_RETRAB := nSuspeito
						ZF4->ZF4_REJET  := nRefugo				
						ZF4->ZF4_FORN   := cForn
						ZF4->ZF4_LOJA   := cLoja
						ZF4->ZF4_LOGIN  := cResp 
						ZF4->ZF4_SALDO  := nSuspeito
						ZF4->ZF4_EXTOK  := 'S'
						ZF4->ZF4_EXT    := 'N'
						ZF4->ZF4_ARMORT := cAlmOri1	// Al. Origem de Retrabalho
					 	ZF4->ZF4_ARMDRT := cAlmDes1 // Al. Destino de Retrabalho
						ZF4->ZF4_ARMORJ := cAlmOri2 // Al. Origem de Rejeitado
						ZF4->ZF4_ARMDRJ := cAlmDes2 // Al. Destino de Rejeitado		
						ZF4->ZF4_OBS    := cObs	    // Se Defeito for 999, existe uma observação
						ZF4->ZF4_NRFIS	:= cNrFis						    		
						ZF4->ZF4_TRYOUT := iif(lChkTry == .F.,'N','S')	  
						ZF4->ZF4_DTREF  := dDtRef
						ZF4->ZF4_OP		:= cOp
						ZF4->ZF4_PESO	:= nPesoT
					MsUnlock("ZF4")
						
					ConfirmSX8() 
				     
					// ITENS DO ACOLS
			   		For x:=1 to Len(aCols)
				   		If !aCols[x][len(aHeader)+1] // Nao pega quando estiver deletado	   		    
				   		    If AllTrim(aCols[x][8]) <> '' .OR. !Empty(aCols[x][8])				   		
								RecLock("ZF5",.T.) 	     	    
						   			ZF5->ZF5_FILIAL  := xFilial("ZF5")		
									ZF5->ZF5_CODRNC	 := cNumRnc			
									ZF5->ZF5_ITEM	 := aCols[x][1]						
									ZF5->ZF5_MOTIVO	 := AllTrim(aCols[x][2])
									ZF5->ZF5_PROD	 := aCols[x][3]
									ZF5->ZF5_DESC	 := AllTrim(aCols[x][4])					
									ZF5->ZF5_QUANT   := aCols[x][5]
									ZF5->ZF5_LOTE    := aCols[x][6]
									ZF5->ZF5_END     := aCols[x][7]
									ZF5->ZF5_DOC     := iif(Empty(aCols[x][8]),'SEM DOC',aCols[x][8]) // Modificado em 28/02/13 afim de tentar solucionar problema de documento em branco
									ZF5->ZF5_DATA    := aCols[x][9]
									ZF5->ZF5_HOR     := aCols[x][10]
									ZF5->ZF5_LOGIN   := aCols[x][11]					
									ZF5->ZF5_ALMORI  := aCols[x][12]
									ZF5->ZF5_ALMDES  := aCols[x][13]
								MsUnlock("ZF5") 											
							Else 
							    MsgBox("Saldo insuficiente ou falta endereçar, verifique.","Documento em branco","INFO")
   							    DisarmTransaction()
							    oDlg:End()
							    Return
							Endif										
					    EndIf
					Next
					
					cNumRnc := ''       					    	
		   			oDlg:End()   	   					 	    
		   		
		   		EndIf
   		
   		    EndIF
   		   End Transaction 
   		    
   		Else
   		 // Se _lTransf for falso, somente grava a RNC, não fazendo a transferencia    		
 		   	If ((cAlmOri1 == cAlmDes1) .OR. (cAlmOri2 == cAlmDes2))		
   			   
   				DbSelectArea("ZF4")
			
				RecLock("ZF4",.T.) 	     	    
					ZF4->ZF4_FILIAL := xFilial("ZF4")		
					ZF4->ZF4_COD 	:= cNumRnc			
					ZF4->ZF4_PROD  	:= cProduto
					ZF4->ZF4_DATA   := dData
					ZF4->ZF4_HORA   := cHorario
					ZF4->ZF4_CADEF  := cCarDef
					ZF4->ZF4_DEF    := cDefeito
					ZF4->ZF4_OPER   := cOperacao
					ZF4->ZF4_RETRAB := nSuspeito
					ZF4->ZF4_REJET  := nRefugo				
					ZF4->ZF4_FORN   := cForn
					ZF4->ZF4_LOJA   := cLoja
					ZF4->ZF4_LOGIN  := cResp 
					ZF4->ZF4_SALDO  := 0
					ZF4->ZF4_EXTOK  := 'S'
					ZF4->ZF4_EXT    := 'N'
					ZF4->ZF4_ARMORT := cAlmOri1	// Al. Origem de Retrabalho
				 	ZF4->ZF4_ARMDRT := cAlmDes1 // Al. Destino de Retrabalho
					ZF4->ZF4_ARMORJ := cAlmOri2 // Al. Origem de Rejeitado
					ZF4->ZF4_ARMDRJ := cAlmDes2 // Al. Destino de Rejeitado		
					ZF4->ZF4_OBS    := cObs	    // Se Defeito for 999, existe uma observação							    		
					ZF4->ZF4_TRYOUT := iif(lChkTry == .F.,'N','S')
					ZF4->ZF4_DTREF  := dDtRef
					ZF4->ZF4_OP		:= cOp
					ZF4->ZF4_PESO   := nPesoT					
				MsUnlock("ZF4")
				
				ConfirmSX8() 
				     
				// ITENS DO ACOLS
		   		For x:=1 to Len(aCols)
			   		If !aCols[x][len(aHeader)+1] // Nao pega quando estiver deletado	   		    
						RecLock("ZF5",.T.) 	     	    
				   			ZF5->ZF5_FILIAL  := xFilial("ZF5")		
							ZF5->ZF5_CODRNC	 := cNumRnc			
							ZF5->ZF5_ITEM	 := aCols[x][1]						
							ZF5->ZF5_MOTIVO	 := AllTrim(aCols[x][2])
							ZF5->ZF5_PROD	 := aCols[x][3]
							ZF5->ZF5_DESC	 := AllTrim(aCols[x][4])					
							ZF5->ZF5_QUANT   := aCols[x][5]
							ZF5->ZF5_LOTE    := aCols[x][6]
							ZF5->ZF5_END     := aCols[x][7]
							ZF5->ZF5_DOC     := aCols[x][8]
							ZF5->ZF5_DATA    := aCols[x][9]
							ZF5->ZF5_HOR     := aCols[x][10]
							ZF5->ZF5_LOGIN   := aCols[x][11]					
							ZF5->ZF5_ALMORI  := aCols[x][12]
							ZF5->ZF5_ALMDES  := aCols[x][13]
						MsUnlock("ZF5") 				
				    EndIf
				Next       				
			EndIf	    	
		   		oDlg:End() 
    	EndIf
    			
    CASE nPar == 4  // Extorna o Registro
    
    	SD3->(DbSetOrder(8) ) // D3_FILIAL+D3_DOC+D3_NUMSEQ      		
    
    	If MsgYesNo("Tem certeza de que deseja estornar a RNC ?")     		  			  
	   		
	   		// Percorre o aCols, estornando todos registros
   			For x:=1 to Len(aCols)		   
   			      			
		   		If !aCols[x][len(aHeader)+1] .AND. cDocAt <> aCols[x][8]   // Nao pega quando estiver deletado 		   		
		   		
		   			Aadd( aDocEst,{ aCols[x][8] } )
		   			cDocAt := aCols[1][8]	
		   					   		
				EndIf
				
			Next 			
			       
				For x:=1 to Len(aDocEst)
							
					SD3->(DbSeek(xFilial("SD3") + aDocEst[x][1]))  // procura na SD3 passando o documento da Transferência realizada			
					Processa( {|| MSExecAuto({|x,y| mata261(x,y)},aAuto,6)}, "Estornando Transferências... ") // Estorna as transferências					
					
				Next					
			
				If lMsErroAuto
					lTransOk := .f.
					mostraerro()
					DisarmTransaction()
					oDlg:End()
				Else		   		
					RecLock("ZF4",.F.) 
			  		   ZF4->ZF4_EXT := 'S'
			  		   ZF4->ZF4_SALDO := 0
				 	MsUnLock("ZF4")	 		
				 	MsgBox('RNC estornada com sucesso','RNC estornada',"INFO")
				 	
				 	For x:=1 to Len(aCols)
							
				 		Aadd(Acols,{STRZERO(Len(aCols)+1,4),"ESTORNADO",aCols[x][3],aCols[x][4],aCols[x][5], ;
		      				aCols[x][6],aCols[x][7],aCols[x][8],_dDataEst,_cHorEst,cUserName,aCols[x][12],aCols[x][13],.F.})
		      				
	      				RecLock("ZF5",.T.)
		      				ZF5->ZF5_FILIAL  := xFilial("ZF5")		
							ZF5->ZF5_CODRNC	 := cNumRnc			
							ZF5->ZF5_ITEM	 := aCols[x][1]						
							ZF5->ZF5_MOTIVO	 := "ESTORNADO"
							ZF5->ZF5_PROD	 := aCols[x][3]
							ZF5->ZF5_DESC	 := AllTrim(aCols[x][4])					
							ZF5->ZF5_QUANT   := aCols[x][5]
							ZF5->ZF5_LOTE    := aCols[x][6]
							ZF5->ZF5_END     := aCols[x][7]
							ZF5->ZF5_DOC     := _cDocRNC
							ZF5->ZF5_DATA    := _dDataEst
							ZF5->ZF5_HOR     := _cHorEst
							ZF5->ZF5_LOGIN   := cUserName					
							ZF5->ZF5_ALMORI  := aCols[x][13]
							ZF5->ZF5_ALMDES  := aCols[x][12]
	      				MsUnLock("ZF5") 					
					
					Next 
									 	 	 		
				EndIf
								
 			oDlg:End()	 	 		
 			
	 	ENDIF
	 	        
    OTHERWISE  		// No caso de uma operação de "Visualizar"         
    	oDlg:end()   
		
  ENDCASE  		 		  
	
Return     

/*******************************************************************************************/
/************************************** Legenda ********************************************/  
/*******************************************************************************************/ 

USER Function E208Legenda()       

	Local aLegenda :=	{ {"BR_VERMELHO" , "RNC Fechada"},;
	  				 	  {"BR_VERDE"    , "RNC Aberta"}  ,;
				 	      {"BR_CINZA"    , "RNC Estornada"}	}
	
	BrwLegenda(OemToAnsi("Status RNC"), "Legenda", aLegenda)
	
	Return           
	
Static Function fCriaCor()       
	
	Local aLegenda :=	{ {"BR_VERMELHO" , "RNC Fechada"  },;
	  				      {"BR_VERDE"    , "RNC Aberta"}	   ,;
	  				      {"BR_CINZA"    , "RNC Estornada" }}
	Local uRetorno := {}
	
	Aadd(uRetorno, { "ZF4_SALDO == 0 .AND. ZF4_EXT == 'N' ",aLegenda[1][1] }) // Fechada
	Aadd(uRetorno, { "ZF4_SALDO <> 0 .AND. ZF4_EXT == 'N' ",aLegenda[2][1] }) // Aberta
	Aadd(uRetorno, { "ZF4_EXT == 'S'",aLegenda[3][1] }) // Extornada
	
Return(uRetorno)

/*******************************************************************************************/
/************************************** Validações *****************************************/  
/*******************************************************************************************/

Static Function Validar()

	If Len(aCols) < 1
	  Alert("Ao menos um produto deve ser informado!")
	  Return .F.
	EndIf
	
	If Empty(cProduto) 
	  Alert('Favor informar o produto!')          // Valida o campo "Produto"
	  Return .F.
	EndIf  
	
	If Empty(cDefeito)
	  Alert('Favor informar o defeito!') 		  // Valida o campo "Defeito"
	  Return .F.
	EndIf 
	
	If Empty(cCarDef)
	  Alert('Favor informar a característica do defeito!')   // Valida o campo "Caracteristica do defeito"
	  Return .F.
	EndIf
	
	If (nSuspeito + nRefugo) <= 0
	  Alert('Não é possível criar uma RNC sem quantidade !') 
	  Return .F.
	EndIf
	
	If Empty(AllTrim(cOperacao)) 
	   Alert("Favor informar a operação !")	
	   Return .F.
	EndIF                        
	
	If AllTrim(cOperacao) == '000'
	   Alert("Favor informar uma operação válida !")	
	   Return .F.
	EndIF                        
      
Return .T. 

/*******************************************************************************************/
/********************************** Gera a estrutura no aCols ******************************/  
/*******************************************************************************************/

Static Function fGerar(tipo,lEstrutura) // Gera as estruturas
Local _cLote   := Space(10)
Local cAlmOrig := iif(tipo == 1,cAlmOri1,cAlmOri2) 
Local cAlmDest := iif(tipo == 1,cAlmDes1,cAlmDes2)
Local _nQuant  := iif(tipo == 1,nSuspeito,nRefugo)
Local _cMotivo := iif(tipo == 1,"SUSPEITO","REFUGO")
Local _dData   := dDatabase, _nSaldoB8 := 0, _aLote := {}, _lSaldoOK := .F. , _nSaldoBF
Local _cHor    := Substr(Time(),1,5), cQueryFor, lFornOk := .F. , cQryPeso := ''

   If cAlmOrig == cAlmDest  
   	  _lTransf := .F.
   EndiF 
   
   If tipo == 1 .AND. lSus == .F.
      MsgBox("Você já adicionou peças suspeitas nesta RNC !","TOTVS","ALERT")
      Return
   EndIf
   
   If tipo == 2 .AND. lRef == .F.
      MsgBox("Você já adicionou peças refugadas nesta RNC !","TOTVS","ALERT")
      Return
   EndIf
   
   // Validacao para somente ser possivel fazer o DESMONTE pela Estrutura de REFUGO
   If (lChkDev == .T. .AND. tipo == 1) .OR. (lChkDev == .T. .AND. lEstrutura == .F.)
   	  MsgBox("Só é permitido fazer o desmonte utilizando um produto com estrutura e sendo refugo !","VALIDA_DESMONTE","ALERT")
      Return
   EndIF					
   
   // Pedido da Andrea 09/11/12 // Reformulado para atender a empresa Usinagem em 20/12/2012
	IF SM0->M0_CODIGO == 'FN'   
	   If tipo == 2 .AND. !cAlmDest$'20/29/30/39/40/49/50/59'
		   MsgBox("Impossível transferir refugo para este armazem ! Coloque um armazem de refugo válido ! (20,29,30,39,40,49,50,59) ","Almoxarifado Refugo não é valido !","Alert")		 	   
		   Return .F.
	   EndIF
	ELSEIF SM0->M0_CODIGO == 'NH'    
		If tipo == 2 .AND. !cAlmDest$'00/99'
		   MsgBox("Impossível transferir refugo para este armazem ! Coloque um armazem de refugo válido ! (00 ou 99) ","Almoxarifado Refugo não é valido !","Alert")		 	   
		   Return .F.
	    EndIF 
    ENDIF
    
    // Adicionado em 20/12/2012
    IF SM0->M0_CODIGO == 'NH'
       	If tipo == 2 .AND. !cAlmOrig$'10'
		   MsgBox("Impossível retirar peças que não estejam no armazem 10 ! ","Almoxarifado de origem não é valido !","Alert")		 	   
		   Return .F.
		EndIF   
	ENDIF    	   

   If AllTrim(cProduto) == '' 
   	  MsgBox("Campo do produto vazio!","Campo Obrigatorio","Alert")
   	  Return
   EndIF 
   
   // Adicionado em 12/11/12 ( Não estava trazendo o produto correto, pois estavam preenchendo errado a operacao )
   If Len(AllTrim(cOperacao)) < 3 
   	  MsgBox("Preencha corretamente o campo 'OPERACAO' ! O campo deve ter obrigatoriamente 3 dígitos.","Campo Obrigatorio de 3 digitos","Alert")
   	  Return
   EndIF	

   If AllTrim(cAlmOrig) == '' .OR. AllTrim(cAlmDest) == ''
   	  MsgBox("Campo armazem de origem ou destino não estão completos!","Campo Obrigatorio","Alert")
   	  Return
   EndIF
   
   SB2->(DbSetOrder(1))
   
   // Verifica saldo no armazem digitado
   If lEstrutura == .F. .AND. !SB2->(DbSeek(xFilial("SB2") + cProduto + cAlmOrig))
   	  MsgBox("Não foi encontrado o produto "+Alltrim(cProduto)+" para o armazem "+cAlmOrig+" na tabela de produtos x armazem, Verifique!","Armazem Inválido","Alert")
   	  Return  
   EndIf	
   
   // Se escolhido o botão "Estrutura" entao segue abaixo. 
   If lEstrutura   
      
		   cQuery := "SELECT SB1.B1_TIPO,SB1.B1_RASTRO,SB1.B1_LOCPAD,SB1.B1_LOCALIZ,SB1.B1_DESC,SG1.G1_COD,SG1.G1_COMP,"+STRZERO(_nQuant,10) +"*SG1.G1_QUANT AS G1_QUANT"
		   cQuery += " FROM " + RetSqlName( 'SG1' ) +" SG1 (NOLOCK),"+ RetSqlName( 'SB1' ) +" SB1 (NOLOCK)"
		   cQuery += " WHERE G1_FILIAL = '" + xFilial("SG1")+ "'"   
		   cQuery += " AND B1_FILIAL = '" + xFilial("SB1")+ "'"         

			If Substr(cOperacao,3,1)=="X"
				cQuery += " AND SG1.G1_OPERACA <= '" + Substr(cOperacao,1,2)+"0" +"'"     	
			Else
			   cQuery += " AND SG1.G1_OPERACA <= '" + cOperacao + "'"     
			Endif

		   cQuery += " AND SG1.G1_INI <='" + Dtos(Ddatabase) + "' AND SG1.G1_FIM >= '"+Dtos(Ddatabase)+ "'"
		   cQuery += " AND SG1.G1_COD = '" + cProduto + "'"       
		   cQuery += " AND SG1.G1_COMP = SB1.B1_COD"  
		   cQuery += " AND SB1.B1_DESC NOT LIKE '%CUSTO%'"                		
		   cQuery += " AND SUBSTRING(SG1.G1_COMP,7,1) <> '6'"
		   cQuery += " AND SUBSTRING(SG1.G1_COMP,1,3) <> 'MOD'"        
		   cQuery += " AND SG1.D_E_L_E_T_ = ' ' "   
		   cQuery += " AND SB1.D_E_L_E_T_ = ' ' "      
		   cQuery += " ORDER BY SG1.G1_COMP ASC" 
		   MemoWrit('C:\TEMP\NHEST208.SQL',cQuery)
		   TCQUERY cQuery NEW ALIAS "TMPA"  		                                                   
		   
		   TMPA->(Dbgotop())
		   
   		   // Caso não traga nenhum componente
   		   If TMPA->(Eof())
   		   	  Alert("Produto não contem estrutura, favor utilizar o botão 'ADICIONAR' ")
   		   	  aCols := {}
   		   	  TMPA->(DbCloseArea())
   		   	  Return .F.		
   		   EndIf
   		   
   		   // Validação do Fornecedor - pedido da Andrea em 28/01/13
   		   
   		   If tipo == 2 .AND. SUBSTR(TMPA->G1_COMP,7,1) == '1' .AND. SM0->M0_CODIGO == "FN" 
   		   	  
   		   	   SA5->(DBSETORDER(1))  // FORN + LOJA + PRODUTO		   	     
   		   	   If !SA5->(DBSEEK(xFilial("SA5") + cForn + cLoja + TMPA->G1_COMP))
   		   	      Msgbox("O fornecedor não é válido para o produto " + TMPA->G1_COMP + " , favor cadastrar o fornecedor no 'Fornecedor X Produto' !","Validação de fornecedor x produto - Estrutura","ALERT")
	   		   	  aCols := {}    
	   	          TMPA->(DbCloseArea())  
	   	          Return .F.		   	        
   		   	   EndIf
   		   	   
   		   EndIf
   		   // ------------------------------------------------------
   		   
			   While TMPA->(!Eof())                             
			   
				  // ---------------------------------------------- //
				  // TEM CONTROLE POR LOTE E NAO POR ENDERECO (SB8) //
				  // ---------------------------------------------- //
				  
			  	  If TMPA->B1_RASTRO$"L" .AND. TMPA->B1_LOCALIZ <> 'S' 
			
					 lLote := .F.
				     _nSaldoB8 := 0
				     _lSaldoOK := .F.
				     _aLote := {}
				     
				     SB8->(DbSetOrder(1)) // B8_FILIAL+B8_PRODUTO+B8_LOCAL+DTOS(B8_DTVALID)+B8_LOTECTL+B8_NUMLOTE  
					 
					 // Adicionado em 08/01/13 p/ atender função de desmonte
					 If lChkDev == .F.					
						SB8->(DbSeek(xFilial("SB8")+TMPA->G1_COMP+cAlmOrig)) // Filial + produto + almox origem - P/ MATA 261
						cAlmOrig := iif(tipo == 1,cAlmOri1,cAlmOri2)
					 Else 
					    SB8->(DbSeek(xFilial("SB8")+TMPA->G1_COMP+TMPA->B1_LOCPAD)) // Filial + produto + almox origem - P/ MATA 242
					    cAlmOrig := TMPA->B1_LOCPAD
					 EndIf
					 
					 If SB8->(Found())		 
			
						While SB8->(!EOF()) .AND. SB8->B8_PRODUTO==TMPA->G1_COMP .AND. SB8->B8_LOCAL == cAlmOrig
						
						  // Verifica se o SB8 (lote) tem qtde maior ou igual a qtde p/ transferir
						  If (SB8->B8_SALDO - SB8->B8_EMPENHO) > 0 .or. _lSaldoOK .and. dDataBase >= SB8->B8_DATA// Se Saldo maior que 0 (ganho de desempenho)					   	  
                             
 							  // Caso a quant pedida tenha saldo em lote(s)   					      						 	
						   	  If _nSaldoB8 >= TMPA->G1_QUANT 
	
						         lLote := .T. // Valor .T. se entende como saldo para quantidade encontrado com sucesso
						         				                 
				                 If Len(aCols) == 1 .and. AllTrim(aCols[1,1]) == ''
				    				aCols := {}	  
								 EndIf
								 
								 // Preenche o aCols com a quantidade de lotes que foram necessarios para atingir a quantidade inserida
								 For _nx:=1 to len(_aLote)   
								     Aadd(Acols,{STRZERO(Len(aCols)+1,4),_cMotivo,TMPA->G1_COMP,TMPA->B1_DESC,_aLote[_nx][2], ;
						  	         Iif(lChkDev == .T. ,"", _aLote[_nx][1]),Iif(TMPA->B1_LOCALIZ$"S","01",Space(15)),'',_dData,_cHor,cUserName,Iif(lChkDev == .T. ,cAlmOri2, cAlmOrig),cAlmDest,.F.})  			       
								 Next _nx
								 
								 Exit //força a saida do while							  	      
	                          
							  // Caso ainda não foi encontrado saldo, pega mais um lote...	
							  Else
						          					          
						          If (_nSaldoB8 + (SB8->B8_SALDO - SB8->B8_EMPENHO)) >= TMPA->G1_QUANT
						          	 Aadd(_aLote,{ SB8->B8_LOTECTL, TMPA->G1_QUANT - _nSaldoB8} )						          	 
						          Else
						          	 Aadd(_aLote,{ SB8->B8_LOTECTL, SB8->B8_SALDO - SB8->B8_EMPENHO })   	    	 
						          EndIF
						          
						          _nSaldoB8 += (SB8->B8_SALDO - SB8->B8_EMPENHO)
						          
						          If _nSaldoB8 >= TMPA->G1_QUANT
						          	 _lSaldoOk := .T.
						          EndIF
						          
						      Endif
					   
					      EndIf // Se saldo selecionado não for > 0, passa para o proximo.							         
					   	  
					   	  SB8->(DBskip())
                         
					      // Adicionado em 26/11/2012
						  // Caso pego saldo sufiente e caso não entre novamente no while para confirmar, entao grava agora. 						   	  
					   	  If _lSaldoOK .AND. ( SB8->B8_PRODUTO <> TMPA->G1_COMP .OR. SB8->B8_LOCAL <> cAlmOrig )
		 					     
		 					     lLote := .T. // Valor .T. se entende como saldo para quantidade encontrado com sucesso
						         				                 
				                 If Len(aCols) == 1 .and. AllTrim(aCols[1,1]) == ''
				    				aCols := {}	  
								 EndIf
								 
								 // Preenche o aCols com a quantidade de lotes que foram necessarios para atingir a quantidade inserida
								 For _nx:=1 to len(_aLote)   
								     Aadd(Acols,{STRZERO(Len(aCols)+1,4),_cMotivo,TMPA->G1_COMP,TMPA->B1_DESC,_aLote[_nx][2], ;
						  	         Iif(lChkDev == .T. ,"", _aLote[_nx][1]),Iif(TMPA->B1_LOCALIZ$"S","01",Space(15)),'',_dData,_cHor,cUserName,Iif(lChkDev == .T. ,cAlmOri2, cAlmOrig),cAlmDest,.F.})  			       
								 Next _nx                                           
								 
								 Exit //força a saida do while				
						  EndIf
						   
					    EndDo
						
				     EndIf   
					 
					    If !lLote .and. lChkDev == .F.
				  			MsgBox("O Produto "+AllTrim(TMPA->G1_COMP)+" não possui saldo em nenhum lote, nenhum produto da estrutura será adicionado. Verifique!","ESTRUTURA - SB8","ALERT")
				  			aCols := {}				
							TMPA->(DbCloseArea())
							Return .F.							 
					 	EndIf		
					 	
				  // -------------------------------------------- //
				  // TEM CONTROLE POR LOTE E POR ENDERECO (SBF)   //
				  // -------------------------------------------- //	 				 	
					 	
				  ElseIf TMPA->B1_LOCALIZ$"S"
				  
				  	 lLote := .F.
				     _nSaldoBF := 0
				     _lSaldoOK := .F.
				     _aLote := {}        
				     
				     SBF->(DbSetOrder(2)) // Filial + produto + almox origem - P/ MATA 261
					 
					 // Adicionado em 08/01/13 p/ atender função de desmonte
					 If lChkDev == .F.					
						SBF->(DbSeek(xFilial("SBF")+TMPA->G1_COMP+cAlmOrig)) // Filial + produto + almox origem - P/ MATA 261
						cAlmOrig := iif(tipo == 1,cAlmOri1,cAlmOri2)
					 Else 
					    SB8->(DbSeek(xFilial("SBF")+TMPA->G1_COMP+TMPA->B1_LOCPAD)) // Filial + produto + almox origem - P/ MATA 242
					    cAlmOrig := TMPA->B1_LOCPAD
					 EndIf
					 
					 If SBF->(Found())		 
			
						While SBF->(!EOF()) .AND. SBF->BF_PRODUTO==TMPA->G1_COMP .AND. SBF->BF_LOCAL == cAlmOrig
						
						  // Verifica se o SBF (lote) tem qtde maior ou igual a qtde p/ transferir
						  If (SBF->BF_QUANT - SBF->BF_EMPENHO) > 0 .or. _lSaldoOK .and. dDataBase >= SBF->BF_DATAVEN //.and. DataLote(SBF->LOTECTL,TMPA->G1_COMP,cAlmOrig,SBF->(Recno()) )// Se Saldo maior que 0 (ganho de desempenho) // VERIFICAR DATA					   	  
                             
 							  // Caso a quant pedida tenha saldo em lote(s)   					      						 	
						   	  If _nSaldoBF >= TMPA->G1_QUANT 
	
						         lLote := .T. // Valor .T. se entende como saldo para quantidade encontrado com sucesso
						         				                 
				                 If Len(aCols) == 1 .and. AllTrim(aCols[1,1]) == ''
				    				aCols := {}	  
								 EndIf
								 
								 // Preenche o aCols com a quantidade de lotes que foram necessarios para atingir a quantidade inserida
								 For _nx:=1 to len(_aLote)   
								     Aadd(Acols,{STRZERO(Len(aCols)+1,4),_cMotivo,TMPA->G1_COMP,TMPA->B1_DESC,_aLote[_nx][2], ;
						  	         Iif(lChkDev == .T. ,"", _aLote[_nx][1]),_aLote[_nx][3],'',_dData,_cHor,cUserName,Iif(lChkDev == .T. ,cAlmOri2, cAlmOrig),cAlmDest,.F.})  			       
								 Next _nx
								 
								 Exit //força a saida do while							  	      
	                          
							  // Caso ainda não foi encontrado saldo, pega mais um lote...	
							  Else
						          					          
						          If (_nSaldoBF + (SBF->BF_QUANT - SBF->BF_EMPENHO)) >= TMPA->G1_QUANT
						          	 Aadd(_aLote,{ SBF->BF_LOTECTL, TMPA->G1_QUANT - _nSaldoBF , SBF->BF_LOCALIZ} )						          	 
						          Else
						          	 Aadd(_aLote,{ SBF->BF_LOTECTL, SBF->BF_QUANT - SBF->BF_EMPENHO , SBF->BF_LOCALIZ })   	    	 
						          EndIF
						          
						          _nSaldoBF += (SBF->BF_QUANT - SBF->BF_EMPENHO)
						          
						          If _nSaldoBF >= TMPA->G1_QUANT
						          	 _lSaldoOk := .T.
						          EndIF
						          
						      Endif
					   
					      EndIf // Se saldo selecionado não for > 0, passa para o proximo.							         
					   	  
					   	  SBF->(DBskip())
                         
					      // Adicionado em 26/11/2012
						  // Caso pego saldo sufiente e caso não entre novamente no while para confirmar, entao grava agora. 						   	  
					   	  If _lSaldoOK .AND. ( SBF->BF_PRODUTO <> TMPA->G1_COMP .OR. SBF->BF_LOCAL <> cAlmOrig )
		 					     
		 					     lLote := .T. // Valor .T. se entende como saldo para quantidade encontrado com sucesso
						         				                 
				                 If Len(aCols) == 1 .and. AllTrim(aCols[1,1]) == ''
				    				aCols := {}	  
								 EndIf
								 
								 // Preenche o aCols com a quantidade de lotes que foram necessarios para atingir a quantidade inserida
								 For _nx:=1 to len(_aLote)   
								     Aadd(Acols,{STRZERO(Len(aCols)+1,4),_cMotivo,TMPA->G1_COMP,TMPA->B1_DESC,_aLote[_nx][2], ;
						  	         Iif(lChkDev == .T. ,"", _aLote[_nx][1]),_aLote[_nx][3],'',_dData,_cHor,cUserName,Iif(lChkDev == .T. ,cAlmOri2, cAlmOrig),cAlmDest,.F.})  			       
								 Next _nx
								 
								 Exit //força a saida do while				
						  EndIf
						   
					    EndDo
						
				     EndIf   
					 
					    If !lLote .and. lChkDev == .F.
				  			MsgBox("O Produto "+AllTrim(TMPA->G1_COMP)+" não possui saldo em nenhum lote, nenhum produto da estrutura será adicionado. Verifique!","ESTRUTURA - SBF","ALERT")
				  			aCols := {}				
							TMPA->(DbCloseArea())
							Return .F.							 
					 	EndIf	
				  
				  // ----------------------------------------------- //
				  // 		NÃO CONTROLA LOTE E NEM ENDEREÇO         //
				  // ----------------------------------------------- //	 
					 	 	
				  Else  // Busca saldo na SB2
				        
				  		IF lChkDev == .F.
					  		aSaldo := CalcEst(TMPA->G1_COMP,cAlmOrig,dDatabase+1)   
					  	Else
					  		aSaldo := CalcEst(TMPA->G1_COMP,TMPA->B1_LOCPAD,dDatabase+1)   
					  	EndIf
					  					  	
				  		IF  aSaldo[1] < TMPA->G1_QUANT
		                    MsgBox("Produto "+AllTrim(TMPA->G1_COMP)+" não possui saldo. nenhum produto da estrutura será adicionado.","Produto sem saldo na SB2 - Estrutura","ALERT")                        
		                    aCols := {}
		                    TMPA->(DbCloseArea())
          			        Return .F.
          				Else 
          					 // Caso seja a primeira inclusão no aCols
						   	 If Len(aCols) == 1 .and. AllTrim(aCols[1,1]) == ''
						   	    aCols := {}	  
						 	 EndIf	 	  	  
			             
				             Aadd(Acols,{STRZERO(Len(aCols)+1,4),_cMotivo,TMPA->G1_COMP,TMPA->B1_DESC,TMPA->G1_QUANT, ;
						         '',Iif(TMPA->B1_LOCALIZ$"S","01",Space(15)),'',_dData,_cHor,cUserName,cAlmOrig,cAlmDest,.F.})			               				
             			ENDIF
			
				  EndIf
				  
				  TMPA->(Dbskip())
			      
			   Enddo
			   
			   TMPA->(DbCloseArea())
	
    // Adiciona o produto em si (sem estrutura)     	
	Else
	
	  // VALIDACAO - PEDIDO DO ROGERIO EM 28/01/13
	  IF tipo == 2 .AND. cAlmDest$"30/39" .AND. SM0->M0_CODIGO == "FN" // Adicionado PSA04.1.0049.00 a pedido TiagoMS
	     IF !cProduto$'VWB01.1.0211.01/IVE18.1.0313.00/IVE31.1.0320.00/GMO24.1.0066.01/PSA01.1.0374.00/PSA01.1.0375.00/PSA04.1.0049.00/VWB01.1.0397.00' // Adicionado o 'SOTO' a pedido da ANAP em 14/02/13 // Adicionado IVE31.1.0320.00 em 25/02/13 , Adicionado GMO24.1.0066.01 em 05/07/13 pedido do TiagoMS' // Adicionado o 'SOTO' a pedido da ANAP em 14/02/13 // Adicionado IVE31.1.0320.00 em 25/02/13 , Adicionado GMO24.1.0066.01 em 05/07/13 pedido do TiagoMS
	        IF SUBSTR(cProduto,7,1) == '1'	  
	           MsgBox("Não é permitido utilizar o 'ADICIONAR' para este produto, digite o produto acabado (PA), determinada operacão, e use o botão 'ESTRUTURA' para inserir um componente ","OPERACAO NEGADA","INFO")  
	           aCols := {}
	           Return .F.
	        ENDIF
	     ENDIF
	  ENDIF
	  	
 	  _cLote := Space(10)
	  
	  SB1->(DbSetOrder(1)) // Filial + Produto
  	    	  
  	  SB1->(DbSeek(xFilial("SB1") + cProduto))
  	    	  
		  If SB1->B1_RASTRO$"L" // TEM CONTROLE POR LOTE	    
		  
		     DbSelectArea("SB8")		
		     SB8->(DbSeek(xFilial("SB8")+cProduto+cAlmOrig))//Filial + produto + almox origem
		     
		     lLote := .F.
		     _nSaldoB8 := 0
		     _lSaldoOK := .F.
		     _aLote := {}
		  
			 If SB8->(Found())		 
		
				  While SB8->(!EOF()) .AND. SB8->B8_PRODUTO == cProduto .AND. SB8->B8_LOCAL == cAlmOrig
					
                       // Verifica se o SB8 (lote) tem qtde maior ou igual a qtde p/ transferir
					   If (SB8->B8_SALDO - SB8->B8_EMPENHO) > 0 .or. _lSaldoOK .and. dDataBase <= SB8->B8_DATA // Se Saldo maior que 0 (ganho de desempenho)					   	  
                             
 							  // Caso a quant pedida tenha saldo em lote(s)   					      						 	
						   	  If _nSaldoB8 >= _nQuant 
	
						         lLote := .T. // Valor .T. se entende como saldo para quantidade encontrado com sucesso
						         				                 
				                 If Len(aCols) == 1 .and. AllTrim(aCols[1,1]) == ''
				    				aCols := {}	  
								 EndIf
								 
								 // Preenche o aCols com a quantidade de lotes que foram necessarios para atingir a quantidade inserida
								 For _nx:=1 to len(_aLote)   
								     Aadd(Acols,{STRZERO(Len(aCols)+1,4),_cMotivo,cProduto,cDescProd,_aLote[_nx][2], ;
						  	         _aLote[_nx][1],Iif(SB1->B1_LOCALIZ$"S","01",Space(15)),'',_dData,_cHor,cUserName,cAlmOrig,cAlmDest,.F.})  
								 Next _nx
								 
								 Exit //força a saida do while							  	      
	                          
							  // Caso ainda não foi encontrado saldo, pega mais um lote...	
							  Else
						          					          
						          If (_nSaldoB8 + (SB8->B8_SALDO - SB8->B8_EMPENHO)) >= _nQuant
						          	 Aadd(_aLote,{ SB8->B8_LOTECTL, _nQuant - _nSaldoB8} )						          	 
						          Else
						          	 Aadd(_aLote,{ SB8->B8_LOTECTL, SB8->B8_SALDO - SB8->B8_EMPENHO })   	    	 
						          EndIF
						          
						          _nSaldoB8 += (SB8->B8_SALDO - SB8->B8_EMPENHO)
						          
						          If _nSaldoB8 >= _nQuant
						          	 _lSaldoOk := .T.
						          EndIF
						          
						      Endif
					   
					   EndIf // Se saldo selecionado não for > 0, passa para o proximo.							         
					   
					   SB8->(DBskip())
					   
					   // Adicionado em 04/02/2013 - Para fixar a funcao ADICIONAR
						  
						  // Caso pego saldo sufiente e caso não entre novamente no while para confirmar, entao grava agora. 						   	  
					   	  If _lSaldoOK .AND. ( SB8->B8_PRODUTO <> cProduto .OR. SB8->B8_LOCAL <> cAlmOrig )
		 					     
		 					     lLote := .T. // Valor .T. se entende como saldo para quantidade encontrado com sucesso
						         				                 
				                 If Len(aCols) == 1 .and. AllTrim(aCols[1,1]) == ''
				    				aCols := {}	  
								 EndIf
								 
								 // Preenche o aCols com a quantidade de lotes que foram necessarios para atingir a quantidade inserida
								 For _nx:=1 to len(_aLote)   
								     Aadd(Acols,{STRZERO(Len(aCols)+1,4),_cMotivo,cProduto,cDescProd,_aLote[_nx][2], ;
						  	         _aLote[_nx][1],Iif(SB1->B1_LOCALIZ$"S","01",Space(15)),'',_dData,_cHor,cUserName,cAlmOrig,cAlmDest,.F.})  			       
								 Next _nx
								 
								 Exit //força a saida do while				
						  EndIf
					      // ------------------------	  
					   
				  EndDo  
				
		     EndIf
		     
		     If !lLote
	  			MsgBox("O Produto "+AllTrim(cProduto)+" não possui saldo em nenhum lote, nenhum produto será adicionado. Verifique!","Alert","ALERT")
	  			aCols := {}				
				Return .F.							 
		 	 EndIf
	
		  Else  // Caso não controle lote, busca saldo na SB2
				  
		  		aSaldo := CalcEst(cProduto,cAlmOrig,dDatabase+1)
		  		
		  		SB1->(DbSetOrder(1)) // Filial + Produto  	    	  
		  	    SB1->(DbSeek(xFilial("SB1") + cProduto))		  	       
		  	
		  		IF  aSaldo[1] < _nQuant
                    MsgBox("Produto "+AllTrim(cProduto)+" não possui saldo. Nenhum produto será adicionado.","Produto sem saldo na SB2 - Adicionar","ALERT")                        
                    aCols := {}                   
          		    Return .F.
          		Else 
          			 // Caso seja a primeira inclusão no aCols
				   	 If Len(aCols) == 1 .and. AllTrim(aCols[1,1]) == ''
				   	    aCols := {}	  
				 	 EndIf	 	  	                      
				 	 
				 	 
	             
		             Aadd(Acols,{STRZERO(Len(aCols)+1,4),_cMotivo,cProduto,cDescProd,_nQuant, ;
				         '',Iif(SB1->B1_LOCALIZ$"S","01",Space(15)),'',_dData,_cHor,cUserName,cAlmOrig,cAlmDest,.F.})			               				
             	ENDIF				
		  EndIf
		
   EndIf   
   
   // Busca o Peso total - base para fazer o retorno de aluminio na Itesapar
   
   cQryPeso := " SELECT TOP 1  ((SELECT TOP 1 G1_QUANT FROM " + RetSqlName( 'SG1' ) +" WHERE G1_COD ='"+cProduto+"' AND G1_COMP LIKE 'MP06%' AND D_E_L_E_T_ = '') + (SELECT TOP 1 G1_QUANT FROM " + RetSqlName( 'SG1' )
   cQryPeso += " WHERE G1_COD ='"+cProduto+"' AND G1_COMP LIKE 'RT06%' AND D_E_L_E_T_ = '')) AS 'PESO' "
   cQryPeso += " FROM " + RetSqlName( 'SG1' ) +" (NOLOCK) "
   cQryPeso += " WHERE G1_FILIAL = '" + xFilial("SG1")+ "' "   
   cQryPeso += " AND D_E_L_E_T_ = ' ' "      
   MemoWrit('C:\TEMP\PESOEST208.SQL',cQryPeso)
   TCQUERY cQryPeso NEW ALIAS "PESOTT"  		                                                   
   
   PESOTT->(Dbgotop())
   
   // Caso não encontre um peso
   If PESOTT->(Eof())   	  
   	  nPesoT := 0 
   Else
	  nPesoT := (PESOTT->PESO * _nQuant)	    	  	
   EndIf      
   
   PESOTT->(DbCloseArea())
   
   // ---------------  
           
   oMultiline:Refresh()
   
   If tipo == 1   	  	
      lSus := .F.
   EndIF	   
   
   If tipo == 2
      lRef := .F.
   EndIF	   
   
   // Preenche o array base para gerar relatorio ------------------------------------------------------------------
      Aadd(aRelato,{cNumRnc,cProduto,cDescProd,cAlmOrig,cAlmDest,_nQuant,_dData,_cHor,AllTrim(cUserName),_cMotivo})
   // -------------------------------------------------------------------------------------------------------------

Return 

/*******************************************************************************************/
/************************************* Transferencia ***************************************/  
/*******************************************************************************************/ 

Static Function fTransfere()
Local aArray := {} , nDife := 0 , cLoteAux, cEndAux// Transf 
Local cAl, _cAlmxo, _cAlmxd, cEndOrig, cEndDes, aAutoTemp := {}, aAutoItens := {} , aAutoCab := {}, _nRateio , nRaTotal := 0, _lLote , _lDev := .F., __cLoteP
Private lMsErroAuto := .F.        


	If nPar == 2 // Inclusão
		
			/***********************************/
			// 	Caso seja Devolução (Mata242)  //
			/***********************************/			
			If lChkDev == .T. // - MATA 242 -
			
					DbSelectArea("SD3")
				
					_cDocRNC := NextNumero("SD3",2,"D3_DOC",.T.) // pega o proximo numero do documento do d3_doc
					
					__cLoteP := fBuscLotePA()
					
					If __cLoteP == 'NOK'
					   Return
					EndIf  
					
					SB1->(DBSETORDER(1))
					SB1->(DbSeek(xFilial("SB1")+cProduto))
				  
				    // Cabeçalho		
			   	    aAutoCab :=    {{"cProduto"   , cProduto	    	 , Nil},;
						   			{"cLocOrig"   , cAlmOri2			 , Nil},;
				   					{"nQtdOrig"   , nRefugo	    	     , Nil},;				   		
				   					{"nQtdOrigSe" , CriaVar("D3_QTSEGUM",.F.), Nil},;
				   					{"cDocumento" , _cDocRNC   		     , Nil},;
				   					{"cNumLote"   , CriaVar("D3_NUMLOTE"), Nil},;
				   					{"cLoteDigi"  , __cLoteP			 , Nil},;
				   					{"dDtValid"   , CriaVar("D3_DTVALID"), Nil},;
									{"nPotencia"  , CriaVar("D3_POTENCI"), Nil},;
									{"cLocaliza"  , CriaVar("D3_LOCALIZ"), Nil},;
									{"cNumSerie"  , CriaVar("D3_NUMSERI"), Nil}} 
									
				    SB1->(DBGOTOP())									
					
		    	    SB1->(DBSETORDER(1)) // FILIAL + COD 
		    	    	    	    
		    	    aRateio:= fBuscaRateio(cProduto)
								
					For xC:=1 to Len(aCols)
						If !aCols[xC][len(aheader)+1] // Não pega deletados	
						
							SB1->(DbSeek(xFilial("SB1")+Acols[xC][3]))
							
							    _nRateio := aScan(aRateio,{|x| x[1] == SB1->B1_COD}) // busca o custo total do produto na matriz
							    							
							    // Alimenta um array com 1 item
							    If  SB1->B1_LOCALIZ == 'S' .AND. SB1->B1_RASTRO == 'L'							    	
								    aAutoTemp:= { {"D3_COD"    , SB1->B1_COD	     , Nil}, ;			
												  {"D3_LOCAL"  , Acols[xC][13]		 , Nil}, ;	
												  {"D3_QUANT"  , Acols[xC][5]	     , Nil}, ;			
												  {"D3_QTSEGUM", CriaVar("D3_QTSEGUM",.F.), Nil}, ;											
												  {"D3_LOTECTL", /*aCols[xC][6]*/CriaVar("D3_LOTECTL",.F.) , Nil}, ; 
												  {"D3_LOCALIZ", aCols[xC][7]		 , Nil}, ; 									  	 					  
												  {"D3_CARDEF" , cCarDef             , Nil}, ;
												  {"D3_DEFEITO", cDefeito            , Nil}, ; 		  
											      {"D3_OPERACA", cOperacao           , Nil}, ;
											  	  {"D3_FORNECE", cForn 	             , Nil}, ;
										  	      {"D3_LOJA"   , cLoja 	             , Nil}, ; 
										  	      {"D3_CODPA"  , cProduto            , Nil}, ;
	  									  	      {"D3_UM"     , SB1->B1_UM          , Nil}, ;
									  	          {"D3_RATEIO" , Round(aRateio[_nRateio][2],2), Nil}}
									  	          
									aAdd(aAutoItens,aAutoTemp) 										
									nRaTotal += Round(aRateio[_nRateio][2],2)												
									aAutoTemp := {}   								  	          								  	        											  
								ELSEIF  SB1->B1_LOCALIZ == 'S' .AND. SB1->B1_RASTRO == 'N'								
									aAutoTemp :={ {"D3_COD"    , SB1->B1_COD		 , Nil}, ;			
												  {"D3_LOCAL"  , Acols[xC][13]		 , Nil},;	
												  {"D3_QUANT"  , Acols[xC][5]		 , Nil}, ;			
												  {"D3_QTSEGUM", CriaVar("D3_QTSEGUM",.F.), Nil}, ;											 																			  											  
												  {"D3_LOCALIZ", aCols[xC][7]        , Nil}, ; 									  	 					  
												  {"D3_CARDEF" , cCarDef             , Nil}, ;
												  {"D3_DEFEITO", cDefeito            , Nil}, ; 		  
											      {"D3_OPERACA", cOperacao           , Nil}, ;
											  	  {"D3_FORNECE", cForn 	             , Nil}, ;
										  	      {"D3_LOJA"   , cLoja 	             , Nil}, ; 
									  	          {"D3_CODPA"  , cProduto            , Nil}, ; 
	   									  	      {"D3_UM"     , SB1->B1_UM          , Nil}, ;								  	         											
												  {"D3_RATEIO" , Round(aRateio[_nRateio][2],2), Nil}}                                   
												  
	  								aAdd(aAutoItens,aAutoTemp) 										                                                             
									nRaTotal += Round(aRateio[_nRateio][2],2)												
									aAutoTemp := {}											  
								ELSE								
									aAutoTemp :={ {"D3_COD"    , SB1->B1_COD	, Nil}, ;			
												  {"D3_LOCAL"  , Acols[xC][13]	, Nil}, ;	
												  {"D3_QUANT"  , Acols[xC][5]	, Nil}, ;			
												  {"D3_QTSEGUM", CriaVar("D3_QTSEGUM",.F.), Nil}, ;																					 																  
												  {"D3_CARDEF" , cCarDef             , Nil}, ;
												  {"D3_DEFEITO", cDefeito            , Nil}, ; 										  
											      {"D3_OPERACA", cOperacao           , Nil}, ;
											  	  {"D3_FORNECE", cForn 	             , Nil}, ;
										  	      {"D3_LOJA"   , cLoja 	             , Nil}, ; 
									  	          {"D3_CODPA"  , cProduto            , Nil}, ;											
												  {"D3_RATEIO" , Round(aRateio[_nRateio][2],2), Nil}} 
												  
									aAdd(aAutoItens,aAutoTemp) 										
									nRaTotal += Round(aRateio[_nRateio][2],2)												
									aAutoTemp := {}									
								ENDIF
						EndIf
					Next
	
					// Trata o valor total do rateio								
					If nRaTotal > 100									
					   nDife := nRaTotal - 100				   
					   aAutoItens[1][14][2] := aAutoItens[1][14][2] - nDife                                					   				   			   
					ElseIf nRaTotal < 100					
					   nDife := 100 - nRaTotal				   
					   aAutoItens[1][14][2] := aAutoItens[1][14][2] + nDife  					
					EndIF
	
					Processa({|| MSExecAuto({|v,x,y,z| Mata242(v,x,y,z)},aAutoCab,aAutoItens,3,.T.)},"Aguarde. Fazendo Desmonte...") 
					
					SD3->(DbSetOrder(2))
			
					If SD3->(DbSeek(xFilial("SD3") + _cDocRNC + cProduto ))	
						// Preenche no aCols o D3_Doc gerado
						For x:=1 to Len(aCols)	
				   			If !aCols[x][len(aHeader)+1] // Nao preenche quando deletado
					   			aCols[x][8] := _cDocRNC					
							EndIf                                 
				   		Next 		                
						MsgBox(" Numero de Documento Gerado : "+_cDocRNC,"Desmonte feito com Sucesso","INFO")			
						Return .T.						
					Else											
						If  lMsErroAuto	
							mostraerro()                                
							DisarmTransaction()					
						EndIF						
						MsgBox("Não foi possível fazer o desmonte! ","alert")			
						Return .F.														
					EndIF
				
	        ELSE // - MATA 261 - 		
			
				/**********************************************************************/
			 	//	 Transferencia Normal (Mata261)  						    	  //
				/**********************************************************************/
				DbSelectArea("SD3")
				
				aArray := {{_cDocRNC,;	 // 01. Numero do Documento
							dData}}	     // 02. Data da Transferencia	
				
			    SB1->(DBSETORDER(1)) // FILIAL + COD
				
				For xC:=1 to Len(aCols)
					If !aCols[xC][len(aheader)+1] // Não pega deletados	    
				  		SB1->(DbSeek(xFilial("SB1")+Acols[xC][3]))		// Busca o prod. no SB1				  		
					    //-- DETALHE				 					
						aAdd(aArray,{   SB1->B1_COD,;					// 01.Produto Origem
										SB1->B1_DESC,;  				// 02.Descricao
										SB1->B1_UM,; 	                // 03.Unidade de Medida
										_cAlmxo := iif(AllTrim(Acols[xC][2]) == 'SUSPEITO',cAlmOri1,cAlmOri2),; // 04.Local Origem
										aCols[xC][7],;					// 05.Endereco Origem
										SB1->B1_COD,;					// 06.Produto Destino
										SB1->B1_DESC,;					// 07.Descricao
										SB1->B1_UM,;					// 08.Unidade de Medida
										_cAlmxd := iif(AllTrim(Acols[xC][2]) == 'SUSPEITO',cAlmDes1,cAlmDes2),; // 09.Armazem Destino
										'01',;		        			// 10.Endereco Destino
										CriaVar("D3_NUMSERI",.F.),;		// 11.Numero de Serie
										aCols[xC][6],;					// 10.Lote Origem
										CriaVar("D3_NUMLOTE",.F.),;		// 13.Sublote
										CriaVar("D3_DTVALID",.F.),;		// 14.Data de Validade
										CriaVar("D3_POTENCI",.F.),;		// 15.Potencia do Lote
										Acols[xC][5],; 					// 16.Quantidade
										CriaVar("D3_QTSEGUM",.F.),;		// 17.Quantidade na 2 UM
										CriaVar("D3_ESTORNO",.F.),;		// 18.Estorno
										CriaVar("D3_NUMSEQ",.F.),;		// 19.NumSeq  
										aCols[xC][6],;					// 10.Lote Destino								
										CRIAVAR("D3_DTVALID",.F.),;     // 21.Data Validade
										CRIAVAR("D3_ITEMGRD",.F.),;     // 22.Item da grade
										cCarDef,;						// 23.caracteristica do defeito
										cDefeito,;						// 24.Defeito 		  
										cOperacao,;						// 25.Operação
										cForn,;                         // 26.Fornecedor 
										cLoja,;							// 27.Loja
										CRIAVAR("D3_LOCORIG",.F.),;     
										SB1->B1_CC,;                    // 29.Centro de Custo
										CRIAVAR("D3_TURNO",.F.),;       // 30.Turno
										CRIAVAR("D3_MAQUINA",.F.),;     // 31.Maquina
										CRIAVAR("D3_LINHA",.F.),;       // 32.Linha	
										cProduto,;				        // 32.Linha	
										dDtRef,;
										CRIAVAR("D3_CORRID",.F.),;      // 33.Codigo PA - Adicionado em 12/12/12	
										CRIAVAR("D3_CORRIDA",.F.),;	   // Data de Referencia da RNC - 26-04-13     										
										CRIAVAR("D3_OP",.F.)})	        // ADIDIONADO 21/10/2013 - OEE X OP
				    EndIf
				Next
		    
				dbSelectArea("SD3")
				 
				aArray[1][1] := _cDocRNC := NextNumero("SD3",2,"D3_DOC",.T.) // pega o proximo numero do documento do d3_doc
								  		
				// Verifica se gerou um número de documento no D3
				If Empty(_cDocRNC)
				   aArray[1][1] := _cDocRNC := NextNumero("SD3",2,"D3_DOC",.T.)		
					 If Empty(_cDocRNC)
					    MsgBox("Saldo insuficiente ou falta endereçar, verifique.","DOC NÃO GERADO","ALERT")	
					    Return .F.
					 EndIf
				EndIf
			
				Processa({|| MSExecAuto({|x| MATA261(x)},aArray)},"Aguarde. Transferindo...") // processamento da transf.
			
				// Verifica se existe uma transferencia igual na SD3 - 27/02/2013  
				
				// Analisar um modo de pegar o ultimo doc gerado
				For x1:=2 TO LEN(aArray)			
					cAl3 := getnextalias()						
					beginSql alias cAl3
						SELECT D3_DOC FROM %Table:SD3%
							WHERE D3_COD = %Exp:aArray[x1][1]%    
							AND D3_EMISSAO = %Exp:DtoS(aArray[1][2])%
							AND D3_QUANT = %Exp:aArray[x1][16]%
							AND ((D3_LOCAL = %Exp:aArray[x1][4]% AND D3_TM > '500') OR (D3_LOCAL = %Exp:aArray[x1][9]% AND D3_TM < '500' ))
							AND D3_FILIAL = %xFilial:SD3%
							AND %NotDel%
							AND D3_ESTORNO <> 'S'
							ORDER BY R_E_C_N_O_ DESC
						endsql
				
					If (cAl3)->(eof())			
						MsgBox("Saldo insuficiente ou falta endereçar, verifique.","Documento em branco","ALERT")
						DisarmTransaction()
						Return .F.
					Else
						_cDocRNC := (cAl3)->D3_DOC
					Endif				
					(cAl3)->(dbclosearea())						
				Next
		  	    
		  	    // ------------------------------------- // 	
			    // Verifica se Transferencia gerou erros //
			    // ------------------------------------- //
	        		
				If  lMsErroAuto			
					mostraerro()                                
					DisarmTransaction()
					Return .F. 						
				Else 		
					//-- VERIFICA SE EXISTE A MOVIMENTACAO NO D3 POR PRECAUCAO
					cAl := getnextalias()
					beginSql Alias cAl
						SELECT D3_DOC FROM %Table:SD3% 
						WHERE D3_DOC = %Exp:_cDocRNC%
					endSql	
			
						//-- SE EXISTIR, ENCERRA A TRANSFERENCIA
					If (cAl)->(!Eof())					   					
						// Preenche no aCols o D3_Doc gerado
						For x:=1 to Len(aCols)	
				   			If !aCols[x][len(aHeader)+1] // Nao preenche quando deletado
					   			aCols[x][8] := _cDocRNC					
							EndIf
				   		Next                 
						MsgBox(" Numero de Documento Gerado : "+_cDocRNC,"Transferencia feita com Sucesso","INFO")
						(cAl)->(dbclosearea())
						Return .T.							
					Else
						MsgBox("Não foi possível executar a transferência!","Erro","STOP")			
						(cAl)->(dbclosearea())           
						DisarmTransaction()
						Return .F.				
					EndIf    
	   			EndIf
	   				   			
	   	    EndIF		
	EndIf	   

Return .T.

/*******************************************************************************************/
/************************************* Busca Rateio ****************************************/  
/*******************************************************************************************/

Static Function fBuscaRateio(__cProd)
Local cQuery1, __cDoc, _aProd := {}, _nMes

_nMes := MONTH(dDatabase)-1

// Caso seja janeiro, coloca o mes anterior como dezembro, pq senao ele atribui o mês como 0
If _nMes = 0
   _nMes := 12
EndIF

cQuery := " SELECT TOP 1 D3_DOC FROM "+ RetSqlName("SD3")+" SD3 "
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND D3_COD = '"+ __cProd +"'  "
cQuery += " AND D3_CF = 'PR0' "
cQuery += " AND MONTH(D3_EMISSAO) = "+STR(_nMes)+" "
cQuery += " ORDER BY R_E_C_N_O_ DESC "

TCQUERY cQuery NEW ALIAS "TEMP1"  

__cDoc := TEMP1->D3_DOC

TEMP1->(DbCloseArea())		

cQuery := ''

cQuery := " SELECT D3_COD,D3_QUANT,D3_CUSTO1,D3_QUANT*D3_CUSTO1 AS CUSTO, "
cQuery += " (SELECT SUM(D3_QUANT*D3_CUSTO1) FROM "+RetSqlName("SD3")+" SD3 "
cQuery += " WHERE D_E_L_E_T_ = ''  "
cQuery += " AND D3_DOC = '"+__cDoc+"' "
cQuery += " AND SUBSTRING(D3_COD,1,3) <> 'MOD' "
cQuery += " AND D3_CF <> 'PR0'"
cQuery += " ) AS TOTAL, "
cQuery += " (D3_QUANT*D3_CUSTO1)/(SELECT SUM(D3_QUANT*D3_CUSTO1) FROM "+RetSqlName("SD3")+" SD3 "
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND D3_DOC = '"+__cDoc+"' "
cQuery += " AND SUBSTRING(D3_COD,1,3) <> 'MOD' "
cQuery += " AND D3_CF <> 'PR0' "
cQuery += " ) AS PERC "
cQuery += " FROM "+RetSqlName("SD3")+" SD3 "
cQuery += " WHERE D_E_L_E_T_ = ''"
cQuery += " AND D3_DOC = '"+__cDoc+"' "
cQuery += " AND SUBSTRING(D3_COD,1,3) <> 'MOD' "
cQuery += " AND D3_CF <> 'PR0' "
cQuery += " GROUP BY D3_COD,D3_QUANT,D3_CUSTO1,D3_QUANT*D3_CUSTO1 "

TCQUERY cQuery NEW ALIAS "TEMP1" 

While !TEMP1->(Eof())  

   aAdd(_aProd,{TEMP1->D3_COD,TEMP1->PERC*100})  
   
   TEMP1->(DBSKIP())

EndDo

TEMP1->(DbCloseArea())

cQuery := ''		

Return (_aProd)

/*******************************************************************************************/
/**************************************** Relatorio ****************************************/  
/*******************************************************************************************/

User Function EST208REL(tipo)

cString   := "STJ"
cDesc1    := "Este   relatorio   tem   como   objetivo  a visualização"
cDesc2    := "das movimentações da RNC para fins de transferencia."
cDesc3    := ""
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "EST208REL"
nLastKey  := 0
titulo    := "RNC   -   MOVIMENTAÇÃO" // Título do relatório
cabec1    := " COD. RNC   Produto           Descrição                     Orig  Dest     Quant     Data       Hora   Resp.         Motivo     Oper." 
cabec2    := ""
cabec3    := "" 
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "EST208REL"  
_cPerg	  := "EST208"
 

//-----------------------/
// 		 PERGUNTAS
//-----------------------/ 
// mv_par01 "COD RNC"
// mv_par02 "DE DATA"
// mv_par03 "ATE DATA"
// mv_par04 "DE HORA"
// mv_par05 "ATE HORA" 
//-----------------------/ 
If SM0->M0_CODIGO == "IT"
	cabec1 := " COD. RNC   Produto           Descrição                      Def.  C.Def.   Quant     Data       Tur.   Resp.           Peso    Oper." 
EndIF

// Se for relatorio por parâmetros (Açoes Relacionadas)
If tipo == 3 .or. tipo == 6
   Pergunte("EST208",.T.) // <-- Chama a função responsável pela inicialização das "perguntas" do relatório, valor em "TRUE" força o usuário a entrar com os parâmetros primeiro. 
EndIf

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]      

If tipo == 2   			   // Relatório da Criação da Rnc 
	Processa( {|| RptDetail(2)   },"Gerando Relatório...") 	
ElseIf tipo == 3  		   // Relatório com base nos parâmetros
	Processa( {|| Gerando(2)   },"Gerando Dados do Relatório...") 
	Processa( {|| RptDetail(1)   },"Gerando Relatório...") 
Else                       // Relatório da Destinação
	Processa( {|| Gerando(1)   },"Gerando Dados do Relatório...") 
	Processa( {|| RptDetail(1)   },"Gerando Relatório...") 
EndIf

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) // Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() // Libera fila de relatorios em spool

Return

Static Function Gerando(tipo) // FUNÇÃO RESPONSAVEL POR GERAR A QUERY
Local _cProdRel
Default tipo := 0
Private cQuery 

	If tipo == 1
	   mv_par01  := cNumRnc
   	   _cProdRel := aCols[1][3]
	EndIf
	
	ProcRegua(2)

	IncProc()         
	
	ZF5->(DBSETORDER(1)) // Filial + Codigo da RNC (QI....)
	
	If tipo <> 1
	
		ZF5->(DbSeek(xFilial("ZF5") + AllTrim(mv_par01)))
	
		_cProdRel := AllTrim(ZF5->ZF5_PROD)
		
	EndIf

    //---------------//
    // MONTA A QUERY //
    //---------------//
    
    // Gera relatorio com base nos parametros
		
	    // Melhorado em 30/11/12 a pedido do RogerioS (Inserido parâmetro de produtos)

	    If mv_par11 == 1   
	    	If mv_par12 == 1
	    	   titulo    := "RNC   -   MOVIMENTAÇÃO (Prod. Acabado)" // Título do relatório	
		       cQuery := " SELECT ZF4_COD,ZF4_PROD, B1_DESC, ZF4_LOGIN, ZF4_DATA, ZF4_HORA, ZF4_ARMORJ, ZF4_ARMDRJ, ZF4_REJET, ZF4_OPER, ZF4_DEF, ZF4_CADEF, ZF4_PESO, ZF4_DTREF "      
		    Else
   	    	   titulo    := "RNC   -   MOVIMENTAÇÃO (Prod. Acabado)" // Título do relatório	
			   cQuery := " SELECT ZF4_COD,ZF4_PROD, B1_DESC, ZF4_LOGIN, ZF4_DATA, ZF4_HORA, ZF4_ARMORT, ZF4_ARMDRT, ZF4_RETRAB , ZF4_OPER, ZF4_DEF, ZF4_CADEF, ZF4_PESO, ZF4_DTREF "      			    
		    EndIf
		Else		
			   titulo    := "RNC   -   MOVIMENTAÇÃO (Componente - Bruto)" // Título do relatório	
			   cQuery := " SELECT ZF5_CODRNC,ZF5_PROD, B1_DESC, ZF5_LOGIN, ZF5_DATA, ZF5_HOR, ZF5_ALMORI, ZF5_ALMDES, ZF5_QUANT, ZF5_MOTIVO, ZF4_EXT , ZF4_OPER, ZF4_DEF, ZF4_CADEF, ZF4_PESO, ZF4_DTREF"      					
		EndIf                   
		
		
	    // Caso seja por PA
	    If mv_par11 == 1
		   cQuery += " FROM " + RetSqlName("SB1") + " B1, " + RetSqlName("ZF4") + " ZF4 "	      
		   cQuery += " WHERE ZF4_COD BETWEEN '" + AllTrim(mv_par01) + "' AND '" + AllTrim(mv_par02) + "' "
	       cQuery += " AND ZF4_PROD = B1_COD " 	
	       // TESTE
	       //cQuery += " AND ZF4_COD BETWEEN '"+ AllTrim(mv_par01) + "' AND '" + AllTrim(mv_par02) + "' "    		    
	       // -----	       
		   cQuery += " AND ZF4_PROD BETWEEN '"+ AllTrim(mv_par07) + "' AND '" + AllTrim(mv_par08) + "' " 

		   // A pedido da Silvana.Moreira, relatorio da Itesapar deve considerar a data de referencia			   
		   If SM0->M0_CODIGO == "IT"		      		    
			   cQuery += " AND ZF4_DTREF BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"' "  
		   Else	
			   cQuery += " AND ZF4_DATA BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"' "  
		   Endif		   		   
			   
		   cQuery += " AND ZF4_HORA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "       
		   cQuery += " AND ZF4.D_E_L_E_T_ = '' AND ZF4_FILIAL = '" +xFilial("ZF4") + "' "
		   cQuery += " AND ZF4_EXT = 'N' " 
		   //cQuery += " AND ZF4_COD = ZF5_CODRNC " 	
		   // Caso seja Refugos	 
		   If mv_par12 == 1
   			  cQuery += " AND ZF4_ARMORJ BETWEEN '"+mv_par13+"' AND '"+mv_par14+"' "
			  cQuery += " AND ZF4_ARMORJ <> '' "
			  cQuery += " AND ZF4_ARMDRJ BETWEEN '"+mv_par15+"' AND '"+mv_par16+"' "
			  cQuery += " AND ZF4_ARMDRJ <> '' "
		   Else
		      cQuery += " AND ZF4_ARMORT BETWEEN '"+mv_par13+"' AND '"+mv_par14+"' "
			  cQuery += " AND ZF4_ARMORT <> '' "
  			  cQuery += " AND ZF4_ARMDRT BETWEEN '"+mv_par15+"' AND '"+mv_par16+"' "     
  			  cQuery += " AND ZF4_ARMDRT <> '' "
		   EndIf    	  		        
	    Else	    	
   	       // Caso seja por Componentes		
   	       cQuery += " FROM " + RetSqlName("SB1") + " B1, " + RetSqlName("ZF4") + " ZF4, " + RetSqlName("ZF5") + " ZF5 "	      
   	       cQuery += " WHERE ZF5_CODRNC BETWEEN '" + AllTrim(mv_par01) + "' AND '" + AllTrim(mv_par02) + "' "
	       cQuery += " AND ZF5_PROD = B1_COD "
	       cQuery += " AND ZF5_CODRNC = ZF4_COD "
	       cQuery += " AND ZF4_EXT = 'N' "
		   cQuery += " AND ZF5_PROD BETWEEN '" + AllTrim(mv_par07) + "' AND '" + AllTrim(mv_par08) + "' "    
  		   cQuery += " AND ZF5_DATA BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"' "  
  		   cQuery += " AND ZF5_HOR BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "     
   		   cQuery += " AND ZF5_ALMORI BETWEEN '"+mv_par13+"' AND '"+mv_par14+"' " // Adicionado em 18/02/13     		                  
   		   cQuery += " AND ZF5_ALMDES BETWEEN '"+mv_par15+"' AND '"+mv_par16+"' "     		                  
  		   cQuery += " AND ZF5.D_E_L_E_T_ = '' AND ZF5_FILIAL = '" +xFilial("ZF5") + "' "

		   // Caso seja Refugos	 
		   If mv_par12 == 1
		      cQuery += " AND ZF5_MOTIVO = 'REFUGO         ' "
		   Else
		   	  cQuery += " AND ZF5_MOTIVO = 'SUSPEITO       ' "	   			   	  
		   EndIf    	   		   
		EndIF	    
        
		cQuery += " AND ZF4_LOGIN BETWEEN '" + AllTrim(mv_par09) + "' AND '" + AllTrim(mv_par10) + "' "    
		cQuery += " AND ZF4_FORN BETWEEN '" + AllTrim(mv_par17) + "' AND '" + AllTrim(mv_par18) + "' "    
	    cQuery += " AND B1.D_E_L_E_T_ = '' AND B1_FILIAL = '" +xFilial("SB1") + "' "
	    
	    // Caso seja PA
	    If mv_par11 == 1	
		   cQuery += " ORDER BY ZF4_COD, ZF4_PROD "  	   
		Else 
  		   cQuery += " ORDER BY ZF5_CODRNC, ZF5_PROD "  	   		
		EndIF
		
		IF SELECT("TRA1") > 0
			TRA1->(dbclosearea())
		Endif

		TCQUERY cQuery NEW ALIAS "TRA1"  // Criando o ALIAS
		MemoWrit("C:\Temp\EST208REL.SQL",cQuery)		
		
		TRA1->(DbGoTop())  
		
		If mv_par11 == 1
		   TcSetField("TRA1","ZF4_DATA","D")  // Muda a data de string para date   	
 		   TcSetField("TRA1","ZF4_DTREF","D")  // Muda a data de string para date   	
		Else 
		   TcSetField("TRA1","ZF5_DATA","D")  // Muda a data de string para date   				
		EndIf
	
		IncProc()		

Return

// MONTA O RELATÓRIO (FÍSICO) 

Static Function RptDetail(op)  

Local _dData := dDataBase, nTotal := 0, nTotPeso := 0 //Variavel que recebe a data que vai junto do Título

ProcRegua(0)

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) //Monta o Cabeçalho do Relatório 

If op == 1
		
		// Escrevendo os dados no relatório 
		
		While TRA1->(!Eof())  
		
		  If SM0->M0_CODIGO == "FN" .OR. SM0->M0_CODIGO == "NH"
			
			If Prow() > 75  // Limite de linhas por página
				Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) // <--  Se for maior que o limite, escreve um cabeçalho
			Endif  				
			    
			       @Prow()+1, 001 psay OemtoAnsi(iif(mv_par11 == 1,TRA1->ZF4_COD,TRA1->ZF5_CODRNC))
     			   @Prow()  , 012 psay OemtoAnsi(iif(mv_par11 == 1,TRA1->ZF4_PROD,TRA1->ZF5_PROD))  	 
     			   @Prow()  , 030 psay OemtoAnsi(AllTrim(TRA1->B1_DESC))     			                                                     
     			   
     			   If mv_par11 == 1
     			   	  @Prow()  , 061 psay OemtoAnsi(iif(mv_par12 == 1,TRA1->ZF4_ARMORJ,TRA1->ZF4_ARMORT))
     			      @Prow()  , 067 psay OemtoAnsi(iif(mv_par12 == 1,TRA1->ZF4_ARMDRJ,TRA1->ZF4_ARMDRT))
     			   Else 
				      @Prow()  , 061 psay OemtoAnsi(TRA1->ZF5_ALMORI)
				      @Prow()  , 067 psay OemtoAnsi(TRA1->ZF5_ALMDES)     			   
     			   EndIf
     			   
     			   If mv_par11 == 1
				      @Prow()  , 070 psay iif(mv_par12 == 1,TRA1->ZF4_REJET,TRA1->ZF4_RETRAB) picture("@e 999,999.99")
				      nTotal += iif(mv_par12 == 1,TRA1->ZF4_REJET,TRA1->ZF4_RETRAB)
				   Else
				      @Prow()  , 070 psay TRA1->ZF5_QUANT picture("@e 999,999.99")
    				  nTotal += TRA1->ZF5_QUANT 
				   EndIf			   
     			   	  
     			   @Prow()  , 083 psay iif(mv_par11 == 1,TRA1->ZF4_DATA,TRA1->ZF5_DATA)     			   	  
     			   @Prow()  , 096 psay OemtoAnsi(iif(mv_par11 == 1, TRA1->ZF4_HORA, TRA1->ZF5_HOR))
     			   @Prow()  , 103 psay OemtoAnsi(iif(mv_par11 == 1, AllTrim(TRA1->ZF4_LOGIN), AllTrim(TRA1->ZF5_LOGIN)))
     			   
     			   If mv_par11 == 1
     			   	  @Prow()  , 117 psay iif(mv_par12 == 1,'REFUGO','SUSPEITO')    			   	   
     			   Else
     			      @Prow()  , 116 psay SUBSTR(OemtoAnsi(AllTrim(TRA1->ZF5_MOTIVO)),1,8)
     			   EndIf       
     			   
     			   @Prow()  , 129 psay OemtoAnsi(AllTrim(TRA1->ZF4_OPER))
     			   
				   TRA1->(DbSkip()) 
				   
		 else // Itesapar
		 
		 	If Prow() > 75  // Limite de linhas por página
				Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) // <--  Se for maior que o limite, escreve um cabeçalho
			Endif  				
			    
			       @Prow()+1, 001 psay OemtoAnsi(iif(mv_par11 == 1,TRA1->ZF4_COD,TRA1->ZF5_CODRNC))
     			   @Prow()  , 012 psay OemtoAnsi(iif(mv_par11 == 1,TRA1->ZF4_PROD,TRA1->ZF5_PROD))  	 
     			   @Prow()  , 030 psay OemtoAnsi(AllTrim(TRA1->B1_DESC))     			                                                     
     			   
     			   @Prow()  , 061 psay OemtoAnsi(TRA1->ZF4_DEF)
				   @Prow()  , 068 psay OemtoAnsi(TRA1->ZF4_CADEF)     			   
     			        			   
     			   If mv_par11 == 1
				      @Prow()  , 071 psay iif(mv_par12 == 1,TRA1->ZF4_REJET,TRA1->ZF4_RETRAB) picture("@e 999,999.99")
				      nTotal += iif(mv_par12 == 1,TRA1->ZF4_REJET,TRA1->ZF4_RETRAB)
				   Else
				      @Prow()  , 071 psay TRA1->ZF5_QUANT picture("@e 999,999.99")
    				  nTotal += TRA1->ZF5_QUANT 
				   EndIf			   
     			   
     			   	  
     			   @Prow()  , 084 psay iif(mv_par11 == 1,TRA1->ZF4_DTREF,TRA1->ZF4_DTREF)     	
     			   
     			   If mv_par11 == 1  
     			   		If TRA1->ZF4_HORA >= '07:06' .AND. TRA1->ZF4_HORA <= '15:19' // 1 Turno
							@Prow()  , 097 psay OemtoAnsi('1° T')     			   		
						elseif TRA1->ZF4_HORA >= '15:20' .AND. TRA1->ZF4_HORA <= '23:18' // 2 Turno
							@Prow()  , 097 psay OemtoAnsi('2° T')     			   								
						else
							@Prow()  , 097 psay OemtoAnsi('3° T') // 3 Turno    			   								
     			   		EndIF
     		       else
	     		       If TRA1->ZF5_HORA >= '07:06' .AND. TRA1->ZF5_HORA <= '15:19' // 1 Turno
							@Prow()  , 097 psay OemtoAnsi('1° T')     			   		
						elseif TRA1->ZF5_HORA >= '15:20' .AND. TRA1->ZF5_HORA <= '23:18' // 2 Turno
							@Prow()  , 097 psay OemtoAnsi('2° T')     			   								
						else
							@Prow()  , 097 psay OemtoAnsi('3° T')    // 3 Turno 			   								
     			   		EndIF     		       	
     			   EndIf
     			   
     			   @Prow()  , 104 psay OemtoAnsi(iif(mv_par11 == 1, AllTrim(TRA1->ZF4_LOGIN), AllTrim(TRA1->ZF5_LOGIN)))
     			   
      			   @Prow()  , 120 psay TRA1->ZF4_PESO
      			   
      			   nTotPeso += TRA1->ZF4_PESO
     			   
     			   @Prow()  , 129 psay OemtoAnsi(AllTrim(TRA1->ZF4_OPER))
     			   
				   TRA1->(DbSkip()) 		 
		  endif

		EndDo	
		
				TRA1->(DbCloseArea()) 
			
				@Prow()+1, 000 PSAY __PrtThinLine() //  <-- linha fina na tela
				
				
				@Prow()+1, 071 PSAY nTotal picture("@e 999,999.999") 
				@Prow()  , 002 PSAY 'Total:'
				
				@Prow(), 115 PSAY nTotPeso picture("@e 999,999.99999") 
                 
				If SM0->M0_CODIGO <> 'IT'  

					@Prow()+6 , 012 PSAY '____________________________________' 
					@Prow()   , 074 PSAY '____________________________________' 
					@Prow()+1 , 012 PSAY '        Responsável Qualidade' 
					@Prow()   , 074 PSAY '        Responsável Logística'          
					
				EndIf
			      			  
Else 

		For x:=1 to Len(aRelato)
		   
			If Prow() > 75  // Limite de linhas por página
			   Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) // <--  Se for maior que o limite, escreve um cabeçalho
			Endif  
			   		
				@Prow()+1, 001 psay OemtoAnsi(AllTrim(aRelato[x][1]))  
			    @Prow()  , 012 psay OemtoAnsi(AllTrim(aRelato[x][2]))  
				@Prow()  , 030 psay OemtoAnsi(AllTrim(aRelato[x][3])) 
				@Prow()  , 062 psay OemtoAnsi(AllTrim(aRelato[x][4]))
				@Prow()  , 071 psay OemtoAnsi(AllTrim(aRelato[x][5])) 
				@Prow()  , 074 psay aRelato[x][6] picture("@e 999,999.99")
				@Prow()  , 087 psay aRelato[x][7]
				@Prow()  , 099 psay OemtoAnsi(aRelato[x][8])
				@Prow()  , 107 psay OemtoAnsi(AllTrim(aRelato[x][9]))
			   	@Prow()  , 119 psay SUBSTR(OemtoAnsi(AllTrim(aRelato[x][10])),1,8)
			   	
		Next 
		
		   		@Prow()+1, 000 PSAY __PrtThinLine() //  <-- linha fina na tela

				@Prow()+7 , 012 PSAY '____________________________________' 
				@Prow()   , 074 PSAY '____________________________________' 
				@Prow()+1 , 074 PSAY '        Responsável Logística' 
				@Prow()   , 012 PSAY '        Responsável Qualidade' 
		
EndIF
  
Return(nil)   

/*******************************************************************************************/
/******************************* BUSCA LOTE PA (DESMONTE) **********************************/  
/*******************************************************************************************/

Static Function fBuscLotePA()
Local _cLotePA

	  _cLotePA := Space(10)
	  
	  SB1->(DbSetOrder(1)) // Filial + Produto
  	    	  
  	  SB1->(DbSeek(xFilial("SB1") + cProduto))
  	    	  
		  If SB1->B1_RASTRO$"L" // TEM CONTROLE POR LOTE	    
		  
		     DbSelectArea("SB8")		
		     SB8->(DbSeek(xFilial("SB8")+cProduto+cAlmOri2)) //Filial + produto + almox origem
		     
			 If SB8->(Found())		 
		
				  While SB8->(!EOF()) .AND. SB8->B8_PRODUTO == cProduto .AND. SB8->B8_LOCAL == cAlmOri2
					
                       // Verifica se o SB8 (lote) tem qtde maior ou igual a qtde p/ transferir
					   If (SB8->B8_SALDO - SB8->B8_EMPENHO) > 0 //.AND. dDataBase <= SB8->B8_DATA
					      IF (SB8->B8_SALDO - SB8->B8_EMPENHO) >= nRefugo  // Se Saldo maior que 0 (ganho de desempenho)					   	                            

                          	 _cLotePA  := SB8->B8_LOTECTL                                       					          
							 Return _cLotePA						  
							  
						  EndIF					   
					   EndIf 
					   
					   // Se saldo selecionado não for > 0, passa para o proximo.							         					   					   
					   SB8->(DBskip())
					   
				  EndDo  
				
		     EndIf
		     
		     If Empty(AllTrim(_cLotePA))
	  			MsgBox("O Produto "+AllTrim(cProduto)+" não possui saldo no almx. "+cAlmOri2+", nenhum produto será adicionado. Verifique!","Alert","ALERT")
	  			aCols := {}				
				Return 'NOK'							 
		 	 EndIf
	
		  Else  // Caso não controle lote, busca saldo na SB2
				  
		  		aSaldo := CalcEst(cProduto,cAlmOri2,dDatabase+1)
		  		
		  		SB1->(DbSetOrder(1)) // Filial + Produto  	    	  
		  	    SB1->(DbSeek(xFilial("SB1") + cProduto))		  	       
		  	
		  		IF  aSaldo[1] < nRefugo
                    MsgBox("Produto "+AllTrim(cProduto)+" não possui saldo. Nenhum produto será adicionado.","Produto sem saldo na SB2 - Adicionar","ALERT")                        
                    aCols := {}                   
          		    Return 'NOK'
          		Else 
          			Return  ''	             		             
             	EndIf				
             	
		  EndIf
Return

/*******************************************************************************************/
/************************** Verifica Data Lote vindo da SBF ********************************/  
/*******************************************************************************************/
/*                        FAZER MAIS TESTES ANTES DE LIBERAR ESTA FUNCAO
Static Function DataLote(str_lote,str_prod,str_alm,recnumber)

if Empty(str_lote)
	 return .T.
else
	 SB8->(DbSetOrder(6)) // Filial + lote + produto + alm 
	 SB8->(DBSEEK(xFilial("SBF")+str_lote+str_prod+str_alm))
 
	 if SB8->(Found())
		if dDataBase >= SB8->B8_DATA	   	
		   Return .T. 	
	    else
		   Return .F. 			    	
		endif		
	 endif
 
endif

Return
*/
/*******************************************************************************************/
/**************************************** Cancelar *****************************************/  
/*******************************************************************************************/

Static Function Cancelar() 
	
	RollBackSX8()
	oDlg:end()      

Return