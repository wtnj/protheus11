/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCOM063  ºAutor  ³Microsiga           º Data ³  10/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GERA SC E PC PARA REAFIAÇÃO TROY                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include 'rwmake.ch'

User Function NHCOM063()
Private aRotina, cCadastro

cCadastro := "Lançamento de Refugo"
aRotina   := {}
aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"     , 0 , 1})
aAdd(aRotina,{ "Encerrar"		,"U_COM63ENC()" , 0 , 3})
aAdd(aRotina,{ "Gerar"			,"U_COM63GER()" , 0 , 3})
aAdd(aRotina,{ "Legenda"		,"U_COM63LEG()" , 0 , 3})

DBSELECTAREA("SF2")

If SM0->M0_CODIGO=='FN'
	SET FILTER TO SF2->F2_TIPO=="B" .AND. ALLTRIM(SF2->F2_CLIENTE)$"002700/008805"
ELSEIF SM0->M0_CODIGO=='IT'
	SET FILTER TO SF2->F2_TIPO=="B" .AND. ALLTRIM(SF2->F2_CLIENTE)$"002074"
ENDIF

mBrowse(6,1,22,75,"SF2",,,,,,fCriaCor())
                              
DBSELECTAREA("SF2")

SET FILTER TO

Return

User Function com63leg()       

Local aLegenda :=	{ {"BR_VERDE"    , "Aberta"  },;
  					  {"BR_VERMELHO" , "PC Gerado"     }}

BrwLegenda(OemToAnsi("SCe PC Reafiação"), "Legenda", aLegenda)

Return  


Static Function fCriaCor()       

Local aLegenda :=	{ {"BR_VERDE"    , "Aberta"  },;
  					  {"BR_VERMELHO" , "PC Gerado"     }}

Local uRetorno := {}
Aadd(uRetorno, { 'F2_PEDPEND  = " "' , aLegenda[1][1] } )
Aadd(uRetorno, { 'F2_PEDPEND <> " "' , aLegenda[2][1] } )

Return(uRetorno)

//ÚÄÄÄÄÄÄÄÄÄ¿
//³ ENCERRA ³
//ÀÄÄÄÄÄÄÄÄÄÙ
User Function COM63ENC()

	//-- GRAVA O PEDIDO DE COMPRAS NA NOTA FISCAL
	IF EMPTY(SF2->F2_PEDPEND)
		RecLock("SF2",.F.)
			SF2->F2_PEDPEND := '-'
		MsUnlock("SF2")
	ENDIF
			
RETURN

//ÚÄÄÄÄÄÄ¿
//³ GERA ³
//ÀÄÄÄÄÄÄÙ
User Function COM63GER()
	//-- Somente sendo COMPRADOR
	SY1->(dbSetOrder(3)) // Y1_FILIAL+Y1_USER                                                                                                                                               
	If !SY1->(dbSeek(xFilial('SY1')+__cUserID)) .AND. !UPPER(ALLTRIM(CUSERNAME))$"JOAOFR/ADMIN"
		ALERT("Somente Comprador")
		Return .F.
	Endif

	//-- VALIDA SE JA TIVER PEDIDO
	IF !EMPTY(SF2->F2_PEDPEND)
		If !msgyesno("SC e PC já gerado! Deseja continuar?")
		    return
		endif
	Endif

	Processa({|| fGeraOSG() },'Gerando SC e PC de reafiação para TROY')
Return

Static function fGeraOSG()

	aM110Itens := {}
	aM110Cab   := {}
	aM120Itens := {}
	aM120Cab   := {}
	
	_nRecSd2 := SD2->(Recno())    // guarda o recno  do SD2
	_nOrdSd2 := SD1->(IndexOrd()) // guarda o indice do SD2
	
	SB1->(dbsetorder(1)) // filial + cod
	SD2->(dbsetorder(3)) // filial + doc + serie + cli + loja
	SC1->(dbSetOrder(1)) // C1_FILIAL+C1_NUM+C1_ITEM                                                                                                                                        
	SC7->(dbSetOrder(1)) // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN                                                                                                                              
		
	If SD2->(dbseek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
	
		Procregua(3)

		While SD2->(!EOF()) .AND. SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)==SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
		
			If SD2->D2_TES$"593" //TES DE INDUSTRIALIZACAO				

				SB1->(dbseek(xFilial("SB1")+SD2->D2_COD))
                    
                cVunit :=  SD2->D2_PRCVEN
                
                IF cVunit == 0
                
	                //-- OS Nº: 021298 
	                //-- data : 10/08/2011
	                //-- autor: João Felipe da Rosa
	                //-- desc : pega o preço do histórico do último pedido de compras
	                
	                cAl := getnextalias()
	                
					beginSql Alias cAl
						SELECT TOP 1 C7_PRECO
						FROM %Table:SC7% C7 (NOLOCK)
						WHERE C7_PRODUTO = %Exp:SB1->B1_COD%
						AND C7_FORNECE = %Exp:SF2->F2_CLIENTE%
						AND C7_LOJA = %Exp:SF2->F2_LOJA%
						AND C7.%NotDel%
						ORDER BY C7_EMISSAO DESC
					endSql

					cVUnit := Iif( (cAl)->(!eof()) , (cAl)->C7_PRECO , 1 )
				
					(cAl)->(dbclosearea())
					//-- fim OS Nº 021298
				
				Endif

				//--Itens
				//--Muito cuidado ao mexer na estrutura do vetor abaixo
				//--adicionar campos, coloque no final, depois do campo C1_TOTAL
				aAdd(aM110Itens,{{"C1_ITEM"    ,strZero(Len(aM110Itens)+1,tamSx3("C1_ITEM")[1]),Nil},;
								 {"C1_PRODUTO" ,SB1->B1_COD                    ,Nil},;
								 {"C1_UM"      ,SB1->B1_UM                     ,Nil},;
								 {"C1_QUANT"   ,SD2->D2_QUANT                  ,Nil},;
								 {"C1_OBS"     ,''                             ,Nil},;
								 {"C1_CC"      ,Iif(empty(SD2->D2_CCUSTO),'ALMOXARI',SD2->D2_CCUSTO) ,Nil},;
								 {"C1_DATPRF"  ,date()		                   ,Nil},;//							 {"C1_CCU"     ,cPadCst                        ,Nil},;
				                 {"C1_LOCAL"   ,SB1->B1_LOCPAD                 ,Nil},;
								 {"C1_VUNIT"   ,Iif(cVUnit==0,1,cVUnit)        ,Nil},;
								 {"C1_PRCUNI"  ,Iif(cVUnit==0,1,cVUnit)        ,Nil},;
								 {"C1_TOTAL"   ,SD2->D2_QUANT*cVUnit           ,Nil}})
			EndIf
			
			SD2->(dbskip())
		EndDo
		
		incproc()
		
		//-- SOLICITACAO DE COMPRAS
		If Len(aM110Itens)>0
		
			//--Controle de transação
			begin Transaction
	
			//--Pega próximo numero da SC
			cNumero := GetSxeNum("SC1","C1_NUM")// NextNumero("SC1",1,"C1_NUM",.T.)
			
			While SC1->(dbSeek(xFilial("SC1")+cNumero))
				ConfirmSX8()
				cNumero := GetSxeNum("SC1","C1_NUM")// NextNumero("SC1",1,"C1_NUM",.T.)			
			Enddo
	
			//--Cabeçalho
			aAdd(aM110Cab,{"C1_NUM"    ,cNumero  ,Nil})
			aAdd(aM110Cab,{"C1_EMISSAO",dDataBase,Nil})
			aAdd(aM110Cab,{"C1_SOLICIT",'CRISVALDOM' }) //cUserName})
	
			lMsErroAuto := .f.
	
			//-- Executa ExecAuto para gravação da solicitação de compras
			msExecAuto({|x,y| Mata110(x,y)},aM110Cab,aM110Itens)
	
			//--Erro
			If lMsErroAuto

				//--Grava o erro no diretório
				//--Cria o diretório se não existir
				MontaDir("Erro OSG\")
				//--Grava o erro no diretório
				MostraErro("\Erro OSG\","["+dtoS(dDataBase)+"]["+strTran(Time(),":",".")+"]["+allTrim(cNumero)+"].txt")
		
				Aviso("SCs não geradas","Não foi possivel fazer a gravação das SCs de Reafiação para OSG/TROY.",{"Ok"},2)

		      	cMsg := 'Não foi possivel fazer a gravação das SCs de Reafiação para OSG/TROY.'+CHR(13)+CHR(10)+;
		      		    'Nota Fiscal: '+SF2->F2_DOC+', Serie: '+SF2->F2_SERIE+', Fornecedor: '+SF2->F2_CLIENTE+'/'+SF2->F2_LOJA+;
		      		    ' - '+Posicione("SA2",1,xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA),"A2_NOME")+chr(13)+chr(10)+;
		      		    'Funname: '+upper(funname())+chr(13)+chr(10)+;
		      			'Log: '+"\\protheus\protheus11\protheus_data\Erro OSG\["+dtoS(dDataBase)+"]["+strTran(Time(),":",".")+"]["+allTrim(cNumero)+"].txt"
		      	
				oMail          := Email():New()
				oMail:cTo      := 'joaofr@whbbrasil.com.br;crisvaldo@whbbrasil.com.br;flaviars@whbusinagem.com.br'
				oMail:cAssunto := '****** Erro SC OSG/TROY ******'
				oMail:cMsg     := cMsg
				oMail:Envia()
				
				Rollbacksx8()
				
				lSC := .F.
				//DisarmTransaction()
			Else 
				lSC := .T.
				ConfirmSx8()
			EndIf

			//--Controle de transação
			end Transaction
		    
		aAuxPC := {}    
		
			If lSC
				SC1->(dbsetorder(1)) //filial + cod + item
				
				//-- PEDIDO DE COMPRAS
			  	For xA:=1 to len(aM110Itens)
			  	
			  		If SC1->(dbseek(xFilial("SC1")+cNumero+aM110Itens[xA][1][2]))
			  		
			  			//-- Remove a marcacao de cotacao para que fique legenda verde e nao azul
			  			RecLock("SC1",.F.)
			  				SC1->C1_COTACAO := SPACE(LEN(SC1->C1_COTACAO))
			  			MsUnlock("SC1")

				    	Aadd(aM120Itens,{{"C7_ITEM"   ,StrZero(Len(aM120Itens)+1,4),Nil},; // Numero do Item
									     {"C7_PRODUTO",SC1->C1_PRODUTO             ,Nil},; // Codigo do Produto                             
									     {"C7_QUANT"  ,SC1->C1_QUANT               ,Nil},; // Quantidade 
									     {"C7_PRECO"  ,100                         ,Nil},; // Preco
									     {"C7_NUMSC"  ,SC1->C1_NUM                 ,Nil},; // numero da sc
								    	 {"C7_ITEMSC" ,SC1->C1_ITEM                ,Nil},; // item da sc 
	 								     {"C7_DATPRF" ,SC1->C1_DATPRF              ,Nil},; // Data De Entrega
									     {"C7_SIGLA"  ,'ALM'                       ,Nil},; // sigla								  
						        	     {"C7_CC"     ,SC1->C1_CC                  ,Nil},; // centro de custo							  	           	           								  								  
	        					     	 {"C7_CONTA"  ,SC1->C1_CONTA               ,Nil},; // conta contabil							  							  								  
	        					     	 {"C7_TOTAL"  ,(SC1->C1_QUANT * 100),Nil } ,;
									     {"C7_LOCAL"  ,SC1->C1_LOCAL               ,Nil}}) // Local

						aAdd(aAuxPC,{StrZero(Len(aM120Itens)+1,4),;
									 Iif(SC1->C1_VUNIT==0,1,SC1->C1_VUNIT),;
									 (SC1->C1_QUANT * Iif(SC1->C1_VUNIT==0,1,SC1->C1_VUNIT))})
									 
					EndIf
				Next

				incproc()				
		
				If len(aM120Itens)>0				

			    	cNumPC := GetSXENum("SC7","C7_NUM")
			    	
					While SC7->(dbSeek(xFilial("SC7")+cNumPC))
						ConfirmSX8()
						cNumPC := GetSXENum("SC7","C7_NUM")
					Enddo

			    	//-- VERIFICA SE O NUMERO JA EXISTE
			    	SC7->(dbsetorder(1))
			    	While .t.
			    		If !SC7->(dbSeek(xFilial('SC7')+cNumPC))
							exit			    		
			    		Endif
			    	
			    		ConfirmSX8()
			    	
			    		cNumPC    := GetSXENum("SC7","C7_NUM")
			    	enddo
			    	
					aM120Cab := {  {"C7_NUM"     ,cNumPC           ,Nil},;  // Data de Emissao
								   {"C7_EMISSAO" ,dDataBase        ,Nil},;  // Data de Emissao
								   {"C7_FORNECE" ,SF2->F2_CLIENTE  ,Nil},;  // Fornecedor
								   {"C7_LOJA"    ,SF2->F2_LOJA     ,Nil},;  // Loja do Fornecedor
								   {"C7_CONTATO" ,''               ,Nil},;  // Contato
								   {"C7_COND"    ,'035'            ,Nil},;  // Condicao de pagamento
								   {"C7_FILENT"  ,"01"             ,Nil}}   // Filial Entrega
			
			  		MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,aM120Cab,aM120Itens,3) // AUTORIZACAO DE ENTREGA = 2, PEDIDO DE COMPRA = 1 
			  		
				   	If lMsErroAuto 

						//--Grava o erro no diretório
						//--Cria o diretório se não existir
						MontaDir("Erro OSG\")
						//--Grava o erro no diretório
						MostraErro("\Erro OSG\","["+dtoS(dDataBase)+"]["+strTran(Time(),":",".")+"]["+allTrim(cNumPC)+"].txt")
				
						Aviso("PC não gerado","Não foi possivel fazer a gravação do PC de Reafiação para OSG/TROY.",{"Ok"},2)
	
				      	cMsg := 'Não foi possivel fazer a gravação do PC de Reafiação para OSG/TROY.'+CHR(13)+CHR(10)+;
				      		    'Nota Fiscal: '+SF2->F2_DOC+', Serie: '+SF2->F2_SERIE+', Fornecedor: '+SF2->F2_CLIENTE+'/'+SF2->F2_LOJA+' - '+Posicione("SA2",1,xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA),"A2_NOME")+CHR(13)+CHR(10)+;
				      		    'SC Nº: '+cNumero+chr(13)+chr(10)+;
				      		    'Funname: '+upper(funname())+chr(13)+chr(10)+;
				      		    'Log: '+"\\protheus\protheus11\protheus_data\Erro OSG\["+dtoS(dDataBase)+"]["+strTran(Time(),":",".")+"]["+allTrim(cNumPC)+"].txt"
				      	
						oMail          := Email():New()
						oMail:cTo      := 'crisvaldo@whbbrasil.com.br;flaviars@whbusinagem.com.br;joaofr@whbbrasil.com.br'
						oMail:cAssunto := '****** Erro PC OSG/TROY ******'
						oMail:cMsg     := cMsg
						oMail:Envia()
	
				      	RollBackSx8() //volta a numeração do SC7
				      	mostraerro()
				      	DisarmTransaction()
				      	break
				   	Else
				      	ConfirmSX8() //confirma a numeração SC7
				      	
				      	SC7->(dbsetorder(1)) // filial + num + item

				      	For xPC := 1 to Len(aAuxPC)

					      	If SC7->(dbseek(xFilial("SC7")+cNumPC +aAuxPC[Xpc][1]))
//						      	While SC7->(!EOF()) .AND. SC7->C7_NUM==cNumPC
						      		
						      		RecLock("SC7",.F.)
						      			SC7->C7_PRECO := aAuxPC[xPC][2]
						      			SC7->C7_TOTAL := aAuxPC[xPC][3]
						      			SC7->C7_USER  := '000019' // Permite alteração pelo CRISVALDO
						      		MsUnlock("SC7")
						      		
//						      		SC7->(dbskip())
//						      	EndDo
					      	Endif 
					      	
				      	NEXT
				      	
						
						//-- ENCERRA SC CONFORME SOLIC. CRISVALDO				      	
				      	SC1->(dbSetOrder(1)) // C1_FILIAL+C1_NUM+C1_ITEM                                                                                                                                        
				      	For xC:=1 to len(aM110Itens)
				      		IF SC1->(dbseek(xFilial("SC1") +  aM110Cab[1][2] + aM110Itens[xC][1][2]))
				      			Reclock('SC1',.F.)
				      				SC1->C1_QUJE := SC1->C1_QUANT
				      			MsUnlock('SC1')
				      		Endif
				      	Next
				      	  
				      	//-- GRAVA O PEDIDO DE COMPRAS NA NOTA FISCAL
				      	RecLock("SF2",.F.)
				      		SF2->F2_PEDPEND := cNumPC
				      	MsUnlock("SF2")
				      	
				      	cMsg := 'A Nota Fiscal: '+SF2->F2_DOC+', Serie: '+SF2->F2_SERIE+', Fornecedor: '+SF2->F2_CLIENTE+'/'+SF2->F2_LOJA+' - '+Posicione("SA2",1,xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA),"A2_NOME")+;
				      			'Gerou a SC Nº: '+cNumero+' e o PC Nº: '+cNumPC+'.'
				      	
						oMail          := Email():New()
						oMail:cTo      := 'crisvaldo@whbbrasil.com.br;flaviars@whbusinagem.com.br;joelmamb@whbbrasil.com.br;eneiasc@whbbrasil.com.br;luisrs@whbbrasil.com.br'
						oMail:cAssunto := '****** SC e PC Gerado por NF ******'
						oMail:cMsg     := cMsg
						//oMail:Envia()
				      	
				      	msgbox(cMsg,"SC e PC Gerados!","info")

				      	SF2->(dbgotop())				      	
				      	
					Endif      
				EndIf
			EndIf	
		EndIf

		incproc()

	Endif

Return(NIL)  