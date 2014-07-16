/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Nhcom013  º Autor ³ Alexandre R. Bento º Data ³  17/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Emissao de Pedidos em Abertos                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±  
±±ºUso       ³ SC3                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±                                                                        ¼±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±                                                                        ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#INCLUDE "rwmake.ch"
#include "Topconn.ch"

User Function nhcom013()
                       
//Private _nNumRev := 0
Private _nPcoQt  := 0
Private _nPreco  := 0
//Private _nQuje   := 0
Private _nIpiQT  := 0
//Private _nIpiJE  := 0
Private _TpFret
Private _Transp
Private _lFim	 := .F.

wnrel      := "NHCOM013"
Titulo     := "Emissao de Pedidos em Aberto"
cDesc1     := "Emissão de Pedidos em Abertos"
cDesc2     := ""
cDesc3     := ""
aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
nomeprog   := "NHCOM013"
cPerg      := "COM013"
cString    := "SC3"
Tamanho    := "G"
nPagina    := 0
nLin       := 01
lAbortPrint:= .F.
limite     := 220
nLastKey   := 0
m_pag      := 01
nTotNota   := nTotDesc:=nTotIpi:=nDescProd:=nTotal:=0
nLargMax   := 220
nLin       := 0
uData      := "  /  /  "
nReg       := 0
_cObsGeral := " "
_cEntreg   := " "
nDespesa   := 0
                      
	Pergunte(cPerg,.f.)
	
	wnrel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.T.)

	If nLastKey == 27
	 	dbClearFilter() 	
		Return
	Endif

	SetDefault(aReturn,cString)
		
	RptStatus({|| fProcessa() },"Gerando...")

	TMP->(DbGoTop())
	If Empty(TMP->C3_NUM)
	   MsgBox("Pedido em Aberto nao Encontrado","Atencao","STOP")
	   DbSelectArea("TMP")
	   DbCloseArea()
	   Return
	Endif
	
	RptStatus({|| Detalhe1() },"Imprimindo...")
	TMP->(DbCloseArea())

	// Set Device To Screen
	If aReturn[5] == 1
		Set Printer To
		ourspool(wnrel) //Chamada do Spool de Impressao
	Endif
	MS_FLUSH() //Libera fila de relatorios em spool
	
Return
                       
//ÚÄÄÄÄÄÄÄÄÄÄ¿
//³ Detalhes ³
//ÀÄÄÄÄÄÄÄÄÄÄÙ
Static Function Detalhe1()

Local  uCodCli := space(15)
Local  uDtaRev := Ctod(" / / ")
Local  uRevDes := space(02)  
Local _nx 

   nLinItem   := 0
   nPagina    := 0
   nLin       := 01
   lAbortPrint:= .F.
   nLastKey   := 0
   m_pag      := 01                        
   nTotNota   := nTotDesc:=nTotIpi:=nDescProd:=nTotal:=0
   nFrete     := nDespesa := 0   
   nLargMax   := 220
   nLin       := 0
   _cObsGeral := " "
	aAprov := {}

    // caso seja cancelado o relatório durante a impressao
    If lAbortPrint
       @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
    Endif
             
	setregua(0)
	
	TMP->(dbgotop())
	SZU->(DbSetOrder(3))//Filial + num contrato + item contrato + nivel  + revisao
	
	//-- gera array de aprovadores
	While TMP->(!EOF())
	
		incregua('Verificando aprovação')
	
		IF SZU->(DbSeek(xFilial("SZU")+TMP->C3_NUM)) //Sempre pega o primeiro item p/ impressao
			While !SZU->(Eof()) .And. SZU->ZU_NUMCT==TMP->C3_NUM
	    	  	If SZU->ZU_ORIGEM$"SC3" .And. SZU->ZU_NUMCT+SZU->ZU_NUMREV == TMP->C3_NUM+TMP->C3_NUMREV         //SC3 = Pedido em aberto / contrato de parceria
	        		
	        		_n:=aScan(aAprov,{|x| ALLTRIM(x[1])==ALLTRIM(SZU->ZU_LOGIN)})
	        		
					If _n==0
		        		aAdd(aAprov,{SZU->ZU_LOGIN,ALLTRIM(SZU->ZU_STATUS),SZU->ZU_DATAPR,SZU->ZU_HORAPR})
					Else
						If aAprov[_n][2]=="A" .and. SZU->ZU_STATUS<>"A"
							aAprov[_n][2] := SZU->ZU_STATUS
							aAprov[_n][3] := SZU->ZU_DATAPR
							aAprov[_n][4] := SZU->ZU_HORAPR
						Endif
					EndIf
	
				Endif
				
				SZU->(DBSKIP())
			Enddo
		Endif
	
		TMP->(dbskip())
	Enddo

	TMP->(dbgotop())
       
	//-- impressao
	While TMP->(!Eof())
	
		incregua()

		If nLinItem == 0
	    	ImpCabec1() //IMPRIME cabeçalho
	    	//nLinItem := 0
	    Endif
	
	    @ pRow()+1,001 pSay "|"+TMP->C3_ITEM
	    @ pRow()  ,006 pSay "|"+TMP->C3_PRODUTO
	    @ pRow()  ,022 pSay "|"+alltrim(oemtoansi(StrTran(TMP->C3_DESCRI,chr(9),'')))
	    @ pRow()  ,125 pSay "|"+TMP->B1_UM
	    @ pRow()  ,128 pSay "|  "+Transform(Iif(Empty(TMP->C3_NUMREV),TMP->C3_QUANT,TMP->C3_QUANT-TMP->C3_QUJE),"999999999.99")
	    @ pRow()  ,146 pSay "| "+Transform(TMP->C3_PRECO,"@E 9,999,999.99999")
	    @ pRow()  ,163 pSay "| "+alltrim(str(TMP->C3_IPI))
	    @ pRow()  ,168 pSay "%|" 

	    uCodCli := space(15)
	    uDtaRev := Ctod(" / / ")
	    uRevDes := space(02)
	    
	    If (Alltrim(TMP->B1_TIPO)$"MP/CP")//Materia prima e componente comprado
	        QDH->(DbSetOrder(7)) //QDH_FILIAL+QDH_PRODUT
		    QDH->(DbSeek(xFilial("QDH")+TMP->C3_PRODUTO))	        
			If QDH->(Found())
				_cDocto := QDH->QDH_DOCTO
		        QDH->(DbSetOrder(1)) // Ultima revisao
			    QDH->(DbSeek(xFilial("QDH")+_cDocto))	        
				While !QDH->(Eof()) .and. QDH->QDH_DOCTO == _cDocto
					If Alltrim(QDH->QDH_CODTP) == "DC"
					    uCodCli := TMP->B1_CODAP5
					    uDtaRev := QDH->QDH_DTREDE
	    				uRevDes := QDH->QDH_INRENO
	    			Endif	
					QDH->(DbSkip())
	    		Enddo	
			Else
			    uCodCli := TMP->B1_CODAP5
			    uDtaRev := TMP->B1_REDEDOC
		    	uRevDes := TMP->B1_REVDES
	        Endif
	    Endif
	
	    @ pRow()  ,170 pSay Subs(uCodCli,1,15)
	    @ pRow()  ,186 pSay "|"+Subs(uRevDes,1,2)      
	    @ pRow()  ,189 pSay "|"+Iif(Empty(uDtaRev)," ",Dtoc(uDtaRev))
	    @ pRow()  ,200 pSay "| "+TMP->C3_NUMSC
	    @ pRow()  ,208 pSay "| "+TMP->C3_ITEMSC
	    @ pRow()  ,219 pSay "|"                 

	    nLinItem += 1 // adiciona um item impresso p/ controle de qtde de itens impressos
	    nFrete += TMP->C3_VALFRE //Soma o valor de frete
	    nTotal:=0
	    _cObsGeral := TMP->C3_OBS
	    _cCond     := TMP->C3_COND
	    _cEntreg   := TMP->C3_ENTREGA
//	    _nNumRev := TMP->C3_NUMREV // NUMERO DE REVISAO
		_nPreco	 += TMP->C3_PRECO // PRECO UNITARIO DO ITEM
	    _nPcoQt  += TMP->C3_QUANT*TMP->C3_PRECO // QUANTIDADE PEDIDA * PRECO UNITARIO
//	    _nQuje   += (TMP->C3_QUANT)-(TMP->C3_QUJE) // QUANTIDADE PEDIDA - QUANTIDADE JA ENTREGUE
//	    _nIpiJE	 += _nQuje*((TMP->C3_IPI)/100) // ALIQUOTA DE IPI
	    _nIpiQT  += (TMP->C3_QUANT*TMP->C3_PRECO*(TMP->C3_IPI))/100 // ALIQUOTA DE IPI
	    _TpFrete := TMP->C3_TPFRETE // TIPO DE FRETE
	    _Transp  := TMP->C3_TRANSP // TRANSPORTADO
	    //(_nPcoQt +_nVipi),((_nQuje*_nPreco)+_nVipi))

	    TMP->(DbSkip())
	    If nLinItem == 15 .AND. TMP->(!Eof())
	    	FinalPed() //imprime rodape do pedido    
	    	_lFim := .F. 
	    	//if TMP->(!Eof())
	     	nLinItem := 0
	        //Endif
	    Endif

	Enddo

    For _nx := (nLinItem + 1)  to 15
	    @ pRow()+1,001 pSay "|"
        @ pRow()  ,006 pSay "|"
	    @ pRow()  ,022 pSay "|"            
	    @ pRow()  ,125 pSay "|"            
	    @ pRow()  ,128 pSay "|"            
	    @ pRow()  ,146 pSay "|"
	    @ pRow()  ,163 pSay "|"
	    @ pRow()  ,169 pSay "|"
	    @ pRow()  ,186 pSay "|"          
	    @ pRow()  ,189 pSay "|"          
	    @ pRow()  ,200 pSay "|"              
        @ pRow()  ,208 pSay "|"      
	    @ pRow()  ,219 pSay "|"
    Next _nx

	If nLinItem != 0
		_lFim := .T.
		FinalPed()
		_lFim := .F.
	Endif
//_nQuant  := 0
_nPreco  := 0
//_nQuje   := 0
//_nIpiJE	 := 0
_nIpiQT	 := 0
_nPcoQt	 := 0
                                                                                     
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Final do pedido ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function FinalPed()
Local  _cDescStatus := Space(10)
Local  _cDescFuncao := Space(20)
Local  _cNotas      := Space(20)
Local _nLin         := 0
Local _nVipi        := 0
Local cCepEntr      := ""
Local cEndEntr      := ""
//   nValor := Iif(Empty(TMP->C3_NUMREV),TMP->C3_TOTAL,(TMP->C3_QUANT-TMP->C3_QUJE)*TMP->C3_PRECO) 


nk := 1
@ pRow()+1,001 pSay "+----+---------------+------------------------------------------------------------------------------------------------------+--+-----------------+----------------+-----+----------------+--+----------+-------+----------+"
If _lFim
	@ pRow()+1,001 pSay "|                           Valor IPI:" + Transform(_nIpiQT,"@E 999,999,999,999,999.99")
//	@ pRow()  ,170 pSay "     Total Geral:" + Transform(Iif(Empty(_nNumRev),(_nPcoQt +_nVipi),((_nQuje*_nPreco)+_nVipi)), "@E 999,999,999,999,999.99")
	@ pRow()  ,170 pSay "     Total Geral:" + Transform((_nPcoQt +_nIpiQT), "@E 999,999,999,999,999.99")
Else
	@ pRow()+1,001 pSay "| "+Space(25)+"Continua..."
Endif
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|"

If mv_par01==1
	cEndEntr := "RUA CYRO CORREIA PEREIRA  1780"
	cCepEntr := "81460050"
ElseIf mv_par01==2
	cEndEntr := "RUA WIEGANDO OLSEN  1600"
	cCepEntr := "81460070"
Else
	cEndEntr := ALLTRIM(SM0->M0_ENDENT)
	cCepEntr := Alltrim(SM0->M0_CEPENT)
EndIf

@ pRow()  ,003 pSay "Local de Entrega  : " +cEndEntr
@ pRow()  ,057 pSay "-"
@ pRow()  ,061 pSay ALLTRIM(SM0->M0_CIDENT)
@ pRow()  ,083 pSay "-"
@ pRow()  ,085 pSay ALLTRIM(SM0->M0_ESTENT)
@ pRow()  ,088 pSay "-"
@ pRow()  ,090 pSay "CEP :"
@ pRow()  ,096 pSay cCepEntr
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "Local de Cobranca : " + ALLTRIM(SM0->M0_ENDCOB)
@ pRow()  ,057 pSay "-"
@ pRow()  ,061 pSay ALLTRIM(SM0->M0_CIDCOB)
@ pRow()  ,083 pSay "-"
@ pRow()  ,085 pSay ALLTRIM(SM0->M0_ESTCOB)
@ pRow()  ,088 pSay "-"
@ pRow()  ,090 pSay "CEP :"
@ pRow()  ,096 pSay Alltrim(SM0->M0_CEPCOB)
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+-----------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|"

SE4->(DbSeek(xFilial("SE4")+_cCOND)) //Pesquisa a condição de pagamento
//@ pRow()  ,003 pSay + OemToAnsi("Condição de Pagamento : ")+ Alltrim(SubStr(SE4->E4_COND,1,20)) +'  '+Subs(SE4->E4_DESCRI,1,50)
@ pRow()  ,003 pSay + OemToAnsi("Condição de Pagamento : ")+ Subs(SE4->E4_DESCRI,1,50)
@ pRow()  ,115 pSay + OemToAnsi("| Tipo do Frete : ")+ Iif(_TpFrete$"F","FOB","CIF") 
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+-----------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay + OemToAnsi("Condição de Entrega : ")+AllTrim(_cEntreg)

@ pRow() ,115 pSay "| Transportadora :"

If !Empty(_Transp)
   	SA4->(DbSetOrder(1))
   	If SA4->(DbSeek(xFilial("SA4")+_Transp))
   		@ pRow() ,134 pSay AllTrim(SA4->A4_NREDUZ) + " - " + Alltrim(SA4->A4_MUN) + " - " +SA4->A4_EST + "    CEP : "+Alltrim(SA4->A4_CEP) + "   ("+Alltrim(SA4->A4_TEL)+")"
   	EndIf
Endif

@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+-----------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------+"
@ pRow()+1,001 pSay "| E-MAIL  Comprador: "+Subs(UsrRetMail( __cUserID ),1,40) //traz o email do  do usuario
@ pRow()  ,115 pSay "| Fornecedor: " + Subs(SA2->A2_EMAIL,1,70) 
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+-----------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------+"
@ pRow()+1,001 pSay "| OBSERVAÇOES: " + Subs(_cObsGeral,1,50)	
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+-----------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "Aprovador         |"
@ pRow()  ,023 pSay "Função                    |"
@ pRow()  ,053 pSay "Data Aprovação    |"
@ pRow()  ,073 pSay "Hora          |"
@ pRow()  ,093 pSay "Status"
@ pRow()  ,115 pSay "| NOTAS"
@ pRow()  ,219 pSay "|"      

//SZU->(DbSetOrder(3))//Filial + num contrato + item contrato + nivel  + revisao
//IF SZU->(DbSeek(xFilial("SZU")+TMP->C3_NUM)) //Sempre pega o primeiro item p/ impressao

//	While !SZU->(Eof()) .And. SZU->ZU_NUMCT+SZU->ZU_ITEMCT == TMP->C3_NUM+TMP->C3_ITEM
If len(aAprov)>0

	For xA:=1 to len(aAprov)
	
      	//If SZU->ZU_ORIGEM$"SC3" .And. SZU->ZU_NUMCT+SZU->ZU_NUMREV == TMP->C3_NUM+TMP->C3_NUMREV         //SC3 = Pedido em aberto / contrato de parceria
	    _cDescStatus := Space(10)
	    _cDescFuncao := Space(20)

	    /*
	      If SZU->ZU_STATUS == "A"
	    	  _cDescStatus :=  "Aprovado  "
	      Elseif SZU->ZU_STATUS == "B"
	    	  _cDescStatus :=  "Aguardando"
	      Elseif SZU->ZU_STATUS == "C"
	     	  _cDescStatus :=  "Rejeitado "
	      Endif	
       */
	    If aAprov[xA][2] == "A"
	     	_cDescStatus :=  "Aprovado  "
	    Elseif aAprov[xA][2] == "B"
	    	_cDescStatus :=  "Aguardando"
	    Elseif aAprov[xA][2] == "C"
	    	_cDescStatus :=  "Rejeitado "
	    Endif	

	    QAA->(DbSetOrder(6))
		If QAA->(DbSeek(aAprov[xA][1]))
           	If SM0->M0_CODIGO$"NH" 	     	 
   	     	    SRJ->(DbSeek(xFilial("SRJ")+"1"+SUBS(QAA->QAA_CODFUN,2,3)))
   	     	Else   
	     	   	SRJ->(DbSeek(xFilial("SRJ")+QAA->QAA_CODFUN))
            Endif
	  
	   	  	If SRJ->(Found())
	   	 	 	_cDescFuncao := SRJ->RJ_DESC
	   	  	Endif
	   	Endif
	     
     	_nLin++

	    If _nLin = 1 
	        _cNotas := OemToAnsi("- A MERCADORIA SOMENTE SERÁ ACEITA COM O NUMERO DO PEDIDO DE COMPRA ABERTO E O ")           
	    Elseif _nLin = 2
	        _cNotas := OemToAnsi("  NUMERO DA AUTORIZAÇÃO DE ENTREGA/RELEASE NA NOTA FISCAL.")      
	    Else
	        _cNotas := Space(80)     
	    Endif
	          
        @ pRow()+1,001 pSay + OemToAnsi("+-------------------+---------------------------+---------------------+---------------+---------------------------|                                                                                                       |")
	    @ pRow()+1,001 pSay + OemToAnsi("|"+ALLTRIM(aAprov[xA][1])) 
	    @ pRow()  ,021 pSay + OemToAnsi("|"+ ALLTRIM(_cDescFuncao))
	    @ pRow()  ,049 pSay + OemToAnsi("|  "+ Dtoc(aAprov[xA][3]))
	    @ pRow()  ,071 pSay + OemToAnsi("|  "+ aAprov[xA][4])
	    @ pRow()  ,087 pSay + OemToAnsi("|  "+ _cDescStatus)
	    @ pRow()  ,115 pSay + OemToAnsi("| " +_cNotas)     
	    @ pRow()  ,219 pSay + OemToAnsi("|")
	  
	  	SZU->(Dbskip())
	
	NEXT
	
   	If  _nLin = 2                   
	   	@ pRow()+1,001 pSay + OemToAnsi("+-------------------+---------------------------+---------------------+---------------+---------------------------|                                                                                                       |")	  
	   	@ pRow()+1,001 pSay + OemToAnsi("|                   |                           |                     |               |                           |                                                                                                       |")
   	Endif
   
   	@ pRow()+1,001 pSay + OemToAnsi("+-------------------+---------------------------+---------------------+---------------+---------------------------+-------------------------------------------------------------------------------------------------------+")   
Else
	@ pRow()+1,001 pSay + OemToAnsi("+-------------------+---------------------------+---------------------+---------------+---------------------------|                                                                                                       |")
	@ pRow()+1,001 pSay + OemToAnsi("|                   |                           |                     |               |                           |                                                                                                       |")
	@ pRow()+1,001 pSay + OemToAnsi("+-------------------+---------------------------+---------------------+---------------+---------------------------| - A MERCADORIA SOMENTE SERÁ ACEITA COM O NUMERO DO PEDIDO DE COMPRA ABERTO E O                        |")
	@ pRow()+1,001 pSay + OemToAnsi("|                   |                           |                     |               |                           |   NUMERO DA AUTORIZAÇÃO DE ENTREGA/RELEASE NA NOTA FISCAL.                                            |")
	@ pRow()+1,001 pSay + OemToAnsi("+-------------------+---------------------------+---------------------+---------------+---------------------------|                                                                                                       |")
	@ pRow()+1,001 pSay + OemToAnsi("|                   |                           |                     |               |                           |                                                                                                       |")
	@ pRow()+1,001 pSay + OemToAnsi("+-------------------+---------------------------+---------------------+---------------+---------------------------+-------------------------------------------------------------------------------------------------------+")
Endif   

@ pRow()+1,001 pSay "|   FORMA DE PAGAMENTO: Credito em Conta Corrente Exclusivamente do Fornecedor"
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|   OBS : 1 -> NAO EMITIR BOLETO BANCARIO"
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|         2 -> ADEQUAR OS VENCIMENTOS PARA AS SEGUNDAS, QUARTAS E SEXTAS-FEIRAS"
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|         3 -> A CONDICAO DE PAGAMENTO SERA INICIADA A PARTIR DA DATA DE ENTREGA DA MERCADORIA NA WHB."
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|         4 -> COM A IMPLANTAÇÃO DO SISTEMA DE GESTÃO AMBIENTAL DA WHB, O FORNECEDOR DEVE ATENDER OS REQUISITOS" 
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|              AMBIENTAIS AO DISPONIBILIZAR PRODUTOS E SERVIÇOS."
@ pRow()  ,219 pSay "|" 
@ pRow()+1,001 pSay "|         5 -> EM CASO DE NOTA FISCAL ELETRONICA ENCAMINHAR ARQUIVO XML P/: " +Iif(SM0->M0_CODIGO=="NH","nfe@whbusinagem.com.br","nfe@whbfundicao.com.br")
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|   A T E N Ç Ã O:"              
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|   A WHB não pratica e tem como  princípio não  estabelecer  relações  comerciais  de  qualquer  natureza com  empresas"
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|   que façam uso de trabalho escravo, exploração de trabalho infantil, bem como aquisição de material extraído de forma"
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|   ilegal. A WHB reserva-se o direito de descontinuar qualquer relação comercial diante da constatação dessas praticas,"
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|   tanto nas atividades diretas, quanto na cadeia de suprimentos dos mesmos."
@ pRow()  ,219 pSay "|" 

@ pRow()+1,001 pSay "+"
@ pRow()  ,002 pSay Replicate("-",217)
@ pRow()  ,219 pSay "+"

Return .T.

//************************************************************************************************************//
Static Function ImpCabec1()

Private aDriver := ReadDriver()
Private cCompac := aDriver[1]
Private cNormal := aDriver[2] 

If nPagina > 0
	eject
Endif

nPagina++

@ pRow()+1,001 pSay "+-------------------------------------------+---------------------------------------------+---------------------+---------------------------------+-----------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,045 pSay "| P E D I D O  D E  C O M P R A  A B E R T O"
@ pRow()  ,091 pSay "|"
@ pRow()  ,093 pSay " Numero: " +TMP->C3_NUM
//@ pRow()  ,088 pSay "/"+Str(nOrdem,1)+ " - "+ IIf(TMP->C3_EMITIDO=="S",Str(SC7->C7_QTDREEM+1,2)+"a. VIA","")
@ pRow()  ,113 pSay "| Data Rev:"+ Dtoc(TMP->C3_DATAREV)
@ pRow()  ,135 pSay "Num.Rev:"+ TMP->C3_NUMREV
@ pRow()  ,147 pSay "| Data Emissao:"
@ pRow()  ,163 pSay Dtoc(TMP->C3_EMISSAO)
@ pRow()  ,180 pSay " Validade: "+Dtoc(TMP->C3_DATPRF) //Data final de validade do contrato
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay AllTrim(SM0->M0_NOMECOM)
@ pRow()  ,045 pSay "+---------------------------------------------+---------------------+---------------------------------+-----------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay + ALLTRIM(SM0->M0_ENDENT)
SA2->(DbGotop())
SA2->(DbSeek(xFilial("SA2")+TMP->C3_FORNECE+TMP->C3_LOJA))
@ pRow()  ,045 pSay "|"
@ pRow()  ,047 pSay Left(SA2->A2_NOME,40)+"  -  "+SA2->A2_COD+" I.E.: "+Alltrim(SA2->A2_INSCR)
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "CEP: "+Trans(SM0->M0_CEPENT,"@R 99999-999")+" - "+Trim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT
@ pRow()  ,045 pSay "|"
@ pRow()  ,047 pSay SA2->A2_END Picture PesqPict("SA2","a2_end")
@ pRow()  ,089 pSay "-  "+Trim(SA2->A2_BAIRRO) Picture "@!"
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "TEL: "+SM0->M0_TEL
@ pRow()  ,022 pSay "FAX: "+SM0->M0_FAX
@ pRow()  ,045 pSay "|"
@ pRow()  ,047 pSay Trim(SA2->A2_MUN)   Picture "@!"
@ pRow()  ,069 pSay SA2->A2_EST            Picture PesqPict("SA2","a2_est")
@ pRow()  ,074 pSay "CEP: "
@ pRow()  ,081 pSay SA2->A2_CEP            Picture PesqPict("SA2","a2_cep")
@ pRow()  ,093 pSay "CGC: "
@ pRow()  ,098 pSay SA2->A2_CGC            Picture PesqPict("SA2","A2_CGC")
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "CGC: "+ transform(sm0->m0_cgc,"@R 99.999.999/9999-99")
@ pRow()  ,028 pSay "IE:"+ SM0->M0_INSC
@ pRow()  ,045 pSay "|"
@ pRow()  ,047 pSay TMP->C3_CONTATO
@ pRow()  ,069 pSay "FONE: "
@ pRow()  ,075 pSay Left(SA2->A2_TEL,17)
@ pRow()  ,093 pSay "FAX: "
@ pRow()  ,098 pSay Left(SA2->A2_FAX,24)
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+----+---------------+------------------------------------------------------------------------------------------------------+--+-----------------+----------------+-----+----------------+--+----------+-------+----------+"
@ pRow()+1,001 pSay "|Item| Codigo WHB    |   Descricao do Material                                                                              |UM|    Quantidade   | Valor Unitario | IPI | Desenho/Norma  |Rv| Dat.Rev  |  S.C. |Item SC.  |"
@ pRow()+1,001 pSay "+----+---------------+------------------------------------------------------------------------------------------------------+--+-----------------+----------------+-----+----------------+--+----------+-------+----------+"

Return .T.

Static Function fProcessa()
	
	Procregua(0)
	
	incproc()
	
	cQuery := "SELECT SC3.*,SB1.B1_UM,SB1.B1_TIPO,SB1.B1_CODAP5,SB1.B1_REDEDOC,SB1.B1_REVDES "
	cQuery += "FROM "+RetSqlName("SC3")+" SC3 (NOLOCK),"+RetSqlName("SB1")+" SB1 (NOLOCK) "
	cQuery += "WHERE SC3.C3_FILIAL='"+xFilial("SC3")+"' AND SC3.D_E_L_E_T_ = ' ' "
	cQuery += " AND SB1.B1_FILIAL='"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " AND SC3.C3_NUM = '"+SC3->C3_NUM+"' "
	cQuery += " AND SC3.C3_PRODUTO = SB1.B1_COD "
	cQuery += "ORDER BY "+SqlOrder(SC3->(IndexKey()))

	TCQUERY cQuery NEW ALIAS "TMP"  	

	TcSetField("TMP","C3_EMISSAO","D")  // Muda a data de string para date    	
	TcSetField("TMP","C3_DATPRF" ,"D")  // Muda a data de string para date    		
	TcSetField("TMP","C3_DATAREV","D")  // Muda a data de string para date  
	TcSetField("TMP","B1_REDEDOC","D")  // Muda a data de string para date  
	  			
Return(.T.)