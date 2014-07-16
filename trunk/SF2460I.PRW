/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³P.ENTRADA ³SF2460I   ³ Autor ³ Geandre G. Oliveira   ³ Data ³ 13.12.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Get para mensagem do pedido                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

#include "rwmake.ch"       

User Function SF2460I()

SetPrvt("_CTS,_CTMP,_CSX1,_CCLIENTE,_CPEDIDO,_PEDCLI")
SetPrvt("_CVAR1,_CVAR2,_CVAR3,_CVAR4,_cDoc,_cOrdLib,_nRecSD2,_nOrdSD2,_nRecSD1,_nOrdSD1, _cNumSol")

_cTS     := GetMv("MV_MSGT01")
_cDoc    := SD2->D2_DOC+SD2->D2_SERIE
_cOrdLib := Space(06)
_cNumSol := Space(06)

SZN->(DbSetOrder(2))//filial + Nota fiscal + SERIE
If SZN->(Dbseek(xFilial("SZN")+SD2->D2_DOC+SD2->D2_SERIE))
   _cOrdLib := SZN->ZN_DOC
   While !SZN->(EOF()) .And. SZN->ZN_NFISCAL == SD2->D2_DOC .And. SZN->ZN_SERIE == SD2->D2_SERIE
	  RecLock("SZN",.F.)
         SZN->ZN_OBS := ""
      MsUnLock("SZN")
      SZN->(Dbskip())
   Enddo   
   Aviso("Atençäo","Esta Nota, Já Possui a Ordem de Liberação "+_cOrdLib+ " Que Vai Ser Amarrada Novamente pelo Sistema.",{"Ok"})

   _nRecSD2 := SD2->(Recno())//Guarda posição do registro
   _nOrdSD2 := SD2->(IndexOrd()) //Guarda posição do index
   SD2->(DbSetOrder(3))
   SC6->(DbSetOrder(4)) //filial + doc + serie     
   SZR->(DbSetOrder(2)) //filial + numero do pedido     
   SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.))
   SC6->(DbSeek(xFilial("SC6")+SF2->F2_DOC+SF2->F2_SERIE))//filial + doc + serie   
   IF SZR->(DbSeek(xFilial("SZR")+SC6->C6_NUM))//filial+num pedido                 
      _cNumSol := SZR->ZR_NUM
   Endif
   
   While !SD2->(EOF()) .And. _cDoc == SD2->D2_DOC+SD2->D2_SERIE            
      RecLock("SD2",.F.)
   //      SD2->D2_ORDLIB := _cOrdLib //Amarra a nota a ordem de liberação já existente
         SD2->D2_NUMSOL :=  _cNumSol //amarra a nota a solicitacao de NF de saida
      MsUnlock("SD2")       
   
      SD2->(Dbskip())
   Enddo                        
   SD2->(Dbgoto(_nRecSD2)) //volta a posição do registro do SD2
   SD2->(DbSetOrder(_nOrdSD2))//volta a posição do index do SD2
    
Endif

IF SF2->F2_TIPO$"D"

   _nRecSD2 := SD2->(Recno())//Guarda posição do registro
   _nOrdSD2 := SD2->(IndexOrd()) //Guarda posição do index
   _nRecSD1 := SD1->(Recno())//Guarda posição do registro
   _nOrdSD1 := SD1->(IndexOrd()) //Guarda posição do index   
   SD2->(DbSetOrder(3))
   SD1->(DbSetOrder(1))   //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
   SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.))
   While !SD2->(EOF()) .And. SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA            
      
      SD1->(DbSeek(xFilial("SD1")+SD2->D2_NFORI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SD2->D2_ITEMORI))
     
      RecLock("SD2",.F.)
         SD2->D2_CCUSTO := SD1->D1_CC //Centro de custo
         SD2->D2_CONTA  := SD1->D1_CONTA //Conta
      MsUnlock("SD2")       
   
      SD2->(Dbskip())
   Enddo                        
   SD2->(Dbgoto(_nRecSD2)) //volta a posição do registro do SD2
   SD2->(DbSetOrder(_nOrdSD2))//volta a posição do index do SD2
   SD1->(Dbgoto(_nRecSD1)) //volta a posição do registro do SD1
   SD1->(DbSetOrder(_nOrdSD1))//volta a posição do index do SD1


Endif

If SD2->D2_TES $ (_cTS)
   _cTMP := SC5->C5_MENNOTA
   _cSX1 := SX1->(GetArea())
   DbSelectArea("SX1")
   SX1->(DbSetOrder(1))
   SX1->(DbSeek("NH410A03",.T.))
   If SX1->X1_PRESEL == 1
      If SD2->D2_TES == GetMv("MV_TESREME")
         _Caso1()      // 694
      ElseIf SD2->D2_TES $ GetMv("MV_TESSERV") 
         _Caso3()      // 699
      Else
         _Caso2()
      EndIf
   Else
      _Caso3()
   EndIf
   RestArea(_cSX1)
EndIf

//If !Empty(SC5->C5_PESOL) //Grava peso liquido e peso bruto

//  RecLock("SF2")
//     SF2->F2_PLIQUI :=SC5->C5_PESOL
//     SF2->F2_PBRUTO := SC5->C5_PBRUTO
//  MsUnLock("SF2")
//Endif   

//Chamado 005668 - helpdesk
If ALLTRIM(SF2->F2_SERIE)$"DEB/DBI"
	U_FAT031(3) //Inclusão da rotina NHFAT031()
EndIf

//-- OS Nº: 015420
//-- desc: quando é emitida uma nf de material para industrializacao para o fornec 002700 (OSG, Afiação), 
//-- desc: seja automaticamente criada a soliictacao de compras para a nf e tambem o pedido de compras
//-- data: 02/08/2011
//-- autor: João Felipe da Rosa
If GetMv("MV_NHSCSF2")
          
	If SF2->F2_TIPO=="B"
		If (SM0->M0_CODIGO=='FN' .AND. ALLTRIM(SF2->F2_CLIENTE)$"002700/008805") .OR. ; // NF tipo Beneficiamento e Fornecedor OSG 002700 E FERRAMENTAS TROY 008805
		   (SM0->M0_CODIGO=='IT' .AND. ALLTRIM(SF2->F2_CLIENTE)$"002074") // NF tipo Beneficiamento e Fornecedor FERRAMENTAS TROY 
			Processa({|| fGeraOSG() },'Gerando SC e PC de reafiação para TROY')
		Endif
	Endif

Endif

//-- fim OS Nº: 015420
	
Return NIL

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
									     {"C7_PRECO"  ,100               ,Nil},; // Preco
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
				      	
				      	
				      	cMsg := 'A Nota Fiscal: '+SF2->F2_DOC+', Serie: '+SF2->F2_SERIE+', Fornecedor: '+SF2->F2_CLIENTE+'/'+SF2->F2_LOJA+' - '+Posicione("SA2",1,xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA),"A2_NOME")+;
				      			'Gerou a SC Nº: '+cNumero+' e o PC Nº: '+cNumPC+'.'
				      	
						oMail          := Email():New()
						oMail:cTo      := 'crisvaldo@whbbrasil.com.br;flaviars@whbusinagem.com.br'
						oMail:cAssunto := '****** SC e PC Gerado por NF ******'
						oMail:cMsg     := cMsg
						oMail:Envia()
				      	
					Endif      
				EndIf
			EndIf	
		EndIf

		incproc()

	Endif

Return(NIL)  

Static Function _Caso1()
   _cCliente := SA1->(GetArea())
   _cPedido  := SC5->(GetArea())
   DbSelectArea("SC5")
   SC5->(DbSetOrder(5))
   SC5->(DbSeek(xFilial("SC5")+SF2->F2_DOC+SF2->F2_SERIE,.T.))
   _PedCli := SC5->C5_NUM
   // SC5->(DbSkip())
   DbSelectAreA("SA1")
   SA1->(DbSetOrder(1))
   SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,.T.))
   RestArea(_cPedido)
   _cTmp  := "REMESSA QUE SEGUE PARA " 
   _cTmp  := _cTmp + " NOME DO CLIENTE  E SEU ENDERECO " 
   _cTmp  := _cTmp + " MINICIPIO ESTADO E CGC "
   _cTmp  := _cTmp + " INCRICAO IE "
   _cTmp  := _cTmp + "CFME N/NF. " 
   _cTmp  := _cTmp + StrZero(Val(SF2->F2_DOC)+1,6) + Space(1) + "SERIE xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" 
   _cTmp  := _cTmp + AllTrim(SF2->F2_SERIE) + " DIA "  + DTOC(SF2->F2_EMISSAO) +  "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
   RestArea(_cCliente)
   
   _cVar1 := SubStr(_cTMP,001,50) 
   _cVar2 := SubStr(_cTMP,051,50) 
   _cVar3 := SubStr(_cTMP,101,50) 
   _cVar4 := SubStr(_cTMP,151,50)    
   
   @ 000,000 TO 250,415 DIALOG oDlg1 TITLE "Altera Mensagem nf..."   
   @ 010,010 TO 120,198 TITLE "Mensagens da NF: " + SF2->F2_DOC + " TS: " + SD2->D2_TES + " Pedido: " + SC5->C5_NUM
   @ 025,020 GET _cVar1 Picture "@S100"
   @ 045,020 GET _cVar2 Picture "@S100"
   @ 065,020 GET _cVar3 Picture "@S100"
   @ 085,020 GET _cVar4 Picture "@S100"
   @ 100,025 BUTTON "_Limpar" SIZE 35,15 ACTION _Refresh()
   @ 100,085 BUTTON "_Ok" SIZE 35,15 ACTION _Confirm()
   @ 100,145 BUTTON "_Sair" SIZE 35,15 ACTION Close(oDlg1)   
   ACTIVATE DIALOG oDlg1 CENTER
Return


Static Function _Caso2()
   _cCliente := SA1->(GetArea())
   _cPedido  := SC5->(GetArea())
   DbSelectArea("SC5")
   SC5->(DbSetOrder(5))
   SC5->(DbSeek(xFilial("SC5")+SF2->F2_DOC+SF2->F2_SERIE,.T.))
   _PedCli := SC5->C5_NUM
   // SC5->(DbSkip())
   DbSelectAreA("SA1")
   SA1->(DbSetOrder(1))
   SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,.T.))
   RestArea(_cPedido)
   _cTmp  := "REMESSA QUE SEGUE POR CONTA E ORDEM PARA " 
   _cTmp  := _cTmp + "NOME  E EENDERECO "
   _cTmp  := _cTmp + "CIDADE ESTADO E CGC "
   _cTmp  := _cTmp + "IE "  
   _cTmp  := _cTmp + "REF N/NF. " 
   _cTmp  := _cTmp + StrZero(Val(SF2->F2_DOC)-1,6) + Space(1) + "SERIExxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx " 
   _cTmp  := _cTmp + AllTrim(SF2->F2_SERIE) + " DIA "  + DTOC(SF2->F2_EMISSAO) + " xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
   _cTmp  := _cTmp + " E NF. FATURAMENTO " + StrZero(Val(SF2->F2_DOC)-2,6) + Space(1) + "SERIExxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx " 
   RestArea(_cCliente)
   
   _cVar1 := SubStr(_cTMP,001,50) 
   _cVar2 := SubStr(_cTMP,051,50) 
   _cVar3 := SubStr(_cTMP,101,50) 
   _cVar4 := SubStr(_cTMP,151,50)    
   
   @ 000,000 TO 250,415 DIALOG oDlg1 TITLE "Altera Mensagem nf..."   
   @ 010,010 TO 120,198 TITLE "Mensagens da NF: " + SF2->F2_DOC + " TS: " + SD2->D2_TES + " Pedido: " + SC5->C5_NUM
   @ 025,020 GET _cVar1 Picture "@S100"
   @ 045,020 GET _cVar2 Picture "@S100"
   @ 065,020 GET _cVar3 Picture "@S100"
   @ 085,020 GET _cVar4 Picture "@S100"
   @ 100,025 BUTTON "_Limpar" SIZE 35,15 ACTION _Refresh()
   @ 100,085 BUTTON "_Ok" SIZE 35,15 ACTION _Confirm()
   @ 100,145 BUTTON "_Sair" SIZE 35,15 ACTION Close(oDlg1)   
   ACTIVATE DIALOG oDlg1 CENTER
Return


Static Function _Caso3()
   _cVar1 := Space(50) // SubStr(_cTMP,001,50) 
   _cVar2 := Space(50) // SubStr(_cTMP,051,50) 
   _cVar3 := Space(50) // SubStr(_cTMP,101,50) 
   _cVar4 := Space(50) // SubStr(_cTMP,151,50)    
   
   @ 000,000 TO 250,415 DIALOG oDlg1 TITLE "Altera Mensagem NF..."   
   @ 010,010 TO 120,198 TITLE "Mensagens da NF: " + SF2->F2_DOC + " TS: " + SD2->D2_TES + " Pedido: " + SC5->C5_NUM
   @ 025,020 GET _cVar1 Picture "@S100"
   @ 045,020 GET _cVar2 Picture "@S100"
   @ 065,020 GET _cVar3 Picture "@S100"
   @ 085,020 GET _cVar4 Picture "@S100"
   @ 100,025 BUTTON "_Limpar" SIZE 35,15 ACTION _Refresh()
   @ 100,085 BUTTON "_Ok" SIZE 35,15 ACTION _Confirm()
   @ 100,145 BUTTON "_Sair" SIZE 35,15 ACTION Close(oDlg1)   
   ACTIVATE DIALOG oDlg1 CENTER
Return


Static Function _Refresh()
   _cVar1 := _cVar2 := _cVar3 := _cVar4 := Space(50)
   dlgRefresh(oDlg1)
Return


Static Function _Confirm()
   _cTMP := _cVar1 + _cVar2 + _cVar3 + _cVar4
   RecLock("SC5")
      SC5->C5_MENNOTA := AllTrim(_cTMP)
   MsUnLock("SC5")
   Close(oDlg1)
Return
