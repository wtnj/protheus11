/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Nhcom014  � Autor � Alexandre R. Bento � Data �  17/07/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Emissao de autoriza�ao de entrega pelo compras             ���
�������������������������������������������������������������������������͹��
���Uso       � SC3                                                        ���
�������������������������������������������������������������������������ͼ��
��                                                                        ���
�������������������������������������������������������������������������ͼ��
��                                                                        ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#INCLUDE "rwmake.ch"
#include "Topconn.ch"

User Function NHCOM014()

SetPrvt("TAMANHO,TITULO,CDESC1,CDESC2,CDESC3,CPERG")
SetPrvt("ARETURN,NOMEPROG,NLASTKEY,NBEGIN")
SetPrvt("NTOTGER,NTOTNOTA,NTOTDESC,NTOTIPI,NDESCPROD")
SetPrvt("CSTRING,NUMPED,NREG,ADRIVER,CCOMPAC")
SetPrvt("CNORMAL,XTRANSP,NORDEM,COBS01,COBS02,COBS03")
SetPrvt("COBS04,LIMPRIME,NVALOR,_COBSGERAL,CRO,NK")
SetPrvt("NDESCNF,CFIL,NREGISTRO,_CNOMEUSER,COBS,NX")
SetPrvt("CVAR,NTOTGERAL,CLIBERADOR,CDESC,NLINREF,CDESCRI")
SetPrvt("MV_PAR06,CUNID,NQUANT,NPRECO,WNREL,uCodCli, uDtaRev,uRevDes")  
SetPrvt("nLargMax,nLin,uData,nFrete,nDespesa,_cNumSC,_nLin,_cNotas")

If !Upper(Alltrim(Funname()))$"MATA122" // Pedido de compras
   U_Nhcom002() //pedido de ocmpras
Else// Autoriza��o de entrega
	wnrel      := "NHCOM014"
	Titulo     := "Emissao de Autorizacao de entrega"
	cDesc1     := "Emissao de Autorizacao de entrega"
	cDesc2     := ""
	cDesc3     := ""
	aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	nomeprog   := "NHCOM014"
	cPerg      := " "
	cString    := "SC7"
	Tamanho    := "G"
	
	nPagina    := 0
	nLin       := 01
	imprime    := .T.
	aOrd       := {}
	lEnd       := .F.
	lAbortPrint:= .F.
	CbTxt      := ""
	limite     := 220
	nLastKey   := 0
	CONTFL     := 01
	m_pag      := 01
	nTotNota   := nTotGer:=nTotDesc:=nTotIpi:=nDescProd:=nTotal:=0
	NumPed     := Space(6)
	nLargMax   := 220
	nLin       := 0
	uData      := "  /  /  "
	nReg       := 0
	_cObsGeral := " "
	nDespesa   := 0
	_nLin      := 0
	Tamanho  := "G"
	nLargMax := 220
	
	wnrel := SetPrint(cString,wnrel,,Titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.T.)
	
	SetDefault(aReturn,cString)
	If nLastKey == 27
	 	dbClearFilter() 	
		Return
	Endif
	
	RptStatus({|| fProcessa() },"Gerando...")
	TMP->(DbGoTop())
	If Empty(TMP->C7_NUM)
	   MsgBox("Autorizacao de Entrega nao Encontrada","Atencao","STOP")
	   DbSelectArea("TMP")
	   DbCloseArea()
	   Return
	Endif
	
	RptStatus({|| Detalhe1() },"Imprimindo...")
	TMP->(DbCloseArea())
Endif

Return                         
//***************************************************************************************************************//
Static Function Detalhe1()

// set device to print         

   Local  uCodCli := space(15)
   Local  uDtaRev := Ctod(" / / ")
   Local  uRevDes := space(02)  
   Local  nLinItem:= 0
   Local _nx 

   nPagina    := 0
   nLin       := 01
   imprime    := .T.
   aOrd       := {}
   lEnd       := .F.
   lAbortPrint:= .F.
   CbTxt      := ""
   limite     := 220
   nLastKey   := 0
   CONTFL     := 01
   m_pag      := 01
   nTotNota   := nTotGer:=nTotDesc:=nTotIpi:=nDescProd:=nTotal:=0
   nFrete     := nDespesa := 0   
   NumPed     := Space(6)
   nLargMax   := 220
   nLin       := 0
   uData      := "  /  /  "
   nReg       := 0
   nValor     := 0

   _cObsGeral := " "


   // caso seja cancelado o relat�rio durante a impressao
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
//      Exit
   Endif

//  nOrdem   := 1
//  cObs01   := cObs02 := cObs03  := cObs04   := " "
//  lImprime := .f.
//  DbSelectArea("SC7")
//  If SC7->C7_EMITIDO == "S" .And. mv_par05 == 1
//     SC7->(DbSkip())
//     Loop
//  Endif

  ImpCabec1() //IMPRIME cabe�alho
  SB1->(DbSetOrder(1))
  SC3->(DbSetOrder(1))  
  While TMP->(!Eof())


    SB1->(DbSeek(xFilial("SB1")+TMP->C7_PRODUTO))

    @ pRow()+1,001 pSay "|"
    @ pRow()  ,002 pSay TMP->C7_ITEM
    @ pRow()  ,006 pSay "|"
    @ pRow()  ,007 pSay TMP->C7_PRODUTO
    @ pRow()  ,022 pSay "|"            
    @ pRow()  ,023 pSay Subs(TMP->C7_DESCRI,1,50)
    @ pRow()  ,095 pSay "|"            
    @ pRow()  ,096 pSay TMP->C7_UM
    @ pRow()  ,098 pSay "|"            
    @ pRow()  ,100 pSay TMP->C7_QUANT   Picture "999999.9999"
    @ pRow()  ,112 pSay "|"
    @ pRow()  ,114 pSay TMP->C7_PRECO   Picture "@E 9,999,999.9999"
    @ pRow()  ,129 pSay "|"
    @ pRow()  ,130 pSay Iif(TMP->C7_MOEDA==1,"REAL","DOLAR")
    @ pRow()  ,135 pSay "|"
    @ pRow()  ,136 pSay SC7->C7_IPI     Picture "99"
    @ pRow()  ,138 pSay "%"
    @ pRow()   ,139 pSay "|"
  
    @ pRow()  ,140 pSay Dtoc(TMP->C7_DATPRF)
    @ pRow()  ,150 pSay "|"          

    If (Alltrim(SB1->B1_TIPO) $ "MP/CP")//Materia prima e componente comprado
        QDH->(DbSetOrder(7))
	    QDH->(DbSeek(xFilial("QDH")+SB1->B1_COD))	        
		If QDH->(Found())
			_cDocto := QDH->QDH_DOCTO
	        QDH->(DbSetOrder(1)) // Ultima revisao
		    QDH->(DbSeek(xFilial("QDH")+_cDocto))	        
			While !QDH->(Eof()) .and. QDH->QDH_DOCTO == _cDocto
				If Alltrim(QDH->QDH_CODTP) == "DC"
				    uCodCli := SB1->B1_CODAP5
				    uDtaRev := QDH->QDH_DTREDE
    				uRevDes := QDH->QDH_INRENO
    			Endif	
				QDH->(DbSkip())
    		Enddo	
		Else
		    uCodCli := SB1->B1_CODAP5
		    uDtaRev := SB1->B1_REDEDOC
	    	uRevDes := SB1->B1_REVDES
        Endif
    Endif

    @ pRow()  ,151 pSay Subs(uCodCli,1,15)
    @ pRow()  ,167 pSay "|"          
    @ pRow()  ,168 pSay Subs(uRevDes,1,2)
    @ pRow()  ,170 pSay "|"              
    @ pRow()  ,171 pSay Dtoc(uDtaRev)
    @ pRow()  ,181 pSay "|"          
    
	SC3->(DbSeek(xFilial("SC3")+TMP->C7_NUMSC + TMP->C7_ITEMSC)) // Pesquisa o numero do SC no contrato							
    @ pRow()  ,182 pSay SC3->C3_NUMSC //numero da solicita�ao de compras do contrato
    @ pRow()  ,189 pSay "|"              
    @ pRow()  ,190 pSay SC3->C3_ITEMSC //item da solicita�ao de compras do contrato   
    @ pRow()  ,219 pSay "|"                 
    
    nLinItem += 1 // adiciona um item impresso p/ controle de qtde de itens impressos
    nValor += TMP->C7_TOTAL
    nFrete += TMP->C7_VALFRE //Soma o valor de frete
    nTotal:=0
//    RecLock("SC3",.F.)  //Atualizacao do flag de Impressao
//      SC3->C3_EMITIDO := "S"
//      SC3->C3_QTDREEM := SC3->C3_QTDREEM + 1
//    MsUnLock("SC3")
//    nReg := SC3->(Recno())
    _cObsGeral += Alltrim(TMP->C7_OBS) +" "
    _cCond     := TMP->C7_COND
    _cNumSC    := TMP->C7_NUM+TMP->C7_ITEM // So ira imprimir um produto por autorizacao conforme contrato
    TMP->(DbSkip())
  Enddo
// Set Device To Screen
For _nx :=nLinItem  to 20
	    @ pRow()+1,001 pSay "|"
        @ pRow()  ,006 pSay "|"
	    @ pRow()  ,022 pSay "|"            
	    @ pRow()  ,095 pSay "|"            
	    @ pRow()  ,098 pSay "|"            
	    @ pRow()  ,112 pSay "|"
	    @ pRow()  ,129 pSay "|"
	    @ pRow()  ,135 pSay "|"	    
	    @ pRow()  ,139 pSay "|"
	    @ pRow()  ,150 pSay "|"          
	    @ pRow()  ,167 pSay "|"          
	    @ pRow()  ,170 pSay "|"              
        @ pRow()  ,181 pSay "|"          
        @ pRow()  ,189 pSay "|"                      
	    @ pRow()  ,219 pSay "|"      
Next _nx 
FinalPed() //imprime rodape do pedido

If aReturn[5] == 1
	Set Printer To
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


//****************************************************************************************************************//
Static Function FinalPed()
nk := 1                                                                                                                                                                
@ pRow()+1,001 pSay "+----+---------------+------------------------------------------------------------------------+--+-------------+----------------+-----+---+----------+----------------+--+----------+-------+-----------------------------+"
@ pRow()+1,001 pSay "|"
SE4->(DbSeek(xFilial("SE4")+_cCOND)) //Pesquisa a condi��o de pagamento
@ pRow()  ,003 pSay + OemToAnsi("Condi��o de Pagamento : ")+ Alltrim(SubStr(SE4->E4_COND,1,20)) +'  '+Subs(SE4->E4_DESCRI,1,50)
@ pRow()  ,112 pSay "| IPI:"
@ pRow()  ,139 pSay "| Total Geral:" + transform(nValor,"@E 9,999,999,999.9999")
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "Local de Entrega  : " +SM0->M0_ENDENT
@ pRow()  ,057 pSay "-"
@ pRow()  ,061 pSay SM0->M0_CIDENT
@ pRow()  ,083 pSay "-"
@ pRow()  ,085 pSay SM0->M0_ESTENT
@ pRow()  ,088 pSay "-"
@ pRow()  ,090 pSay "CEP :"
@ pRow()  ,096 pSay Alltrim(SM0->M0_CEPENT)
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay "Local de Cobranca : " + SM0->M0_ENDCOB
@ pRow()  ,057 pSay "-"
@ pRow()  ,061 pSay SM0->M0_CIDCOB
@ pRow()  ,083 pSay "-"
@ pRow()  ,085 pSay SM0->M0_ESTCOB
@ pRow()  ,088 pSay "-"
@ pRow()  ,090 pSay "CEP :"
@ pRow()  ,096 pSay Alltrim(SM0->M0_CEPCOB)
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+"
//@ pRow()+1,001 pSay "|"

//SE4->(DbSeek(xFilial("SE4")+_cCOND)) //Pesquisa a condi��o de pagamento
//@ pRow()  ,003 pSay + OemToAnsi("Condi��o de Pagamento : ")+ Alltrim(SubStr(SE4->E4_COND,1,20)) +'  '+Subs(SE4->E4_DESCRI,1,50)
//@ pRow()  ,219 pSay "|"
//@ pRow()+1,001 pSay "+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay + OemToAnsi("Condi��o de Entrega : ") 
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay + OemToAnsi("Transportadora : ") 
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+----------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay + OemToAnsi("E-MAIL  Comprador:")+Subs(UsrRetMail( __cUserID ),1,40) //traz o email do  do usuario
@ pRow()  ,120 pSay "|  Fornecedor: " + Subs(SA2->A2_EMAIL,1,70) 
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+----------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay + OemToAnsi("OBSERVA�OES:                                                                                                         |") 
@ pRow()  ,219 pSay "|"      
@ pRow()+1,001 pSay "|"+ Subs(_cObsGeral,1,50)
@ pRow()  ,120 pSay "|"      
@ pRow()  ,219 pSay "|"      
@ pRow()+1,001 pSay "|"      
@ pRow()  ,120 pSay "|"      
@ pRow()  ,219 pSay "|"      
@ pRow()+1,001 pSay "+----------------------------------------------------------------------------------------------------------------------+                                                                                                  |"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay + OemToAnsi("Aprovador         |")
@ pRow()  ,023 pSay + OemToAnsi("Fun��o                    |")
@ pRow()  ,053 pSay + OemToAnsi("Data Aprova��o    |")
@ pRow()  ,073 pSay + OemToAnsi("Hora          |")
@ pRow()  ,093 pSay + OemToAnsi("Status                     |")
@ pRow()  ,123 pSay + OemToAnsi("NOTAS")
@ pRow()  ,219 pSay "|"      
SZU->(DbSetOrder(4)) // filial + numero do contrato + item do contrato
SZU->(DbSeek(xFilial("SZU")+_cNumSC))
If SZU->(Found())
 
   While !SZU->(Eof()) .And. SZU->ZU_NUMPED+SZU->ZU_ITEMPED == _cNumSC
      _cDescStatus := Space(10)
      _cDescFuncao := Space(20)
      If SZU->ZU_STATUS == "A"
    	  _cDescStatus :=  "Aprovado  "
      Elseif SZU->ZU_STATUS == "B"			
    	  _cDescStatus :=  "Aguardando"
      Elseif SZU->ZU_STATUS == "C"			
     	  _cDescStatus :=  "Rejeitado "
      Endif	
      QAA->(DbSetOrder(6))
      QAA->(DbSeek(SZU->ZU_LOGIN))
      If QAA->(Found())
     	  SRJ->(DbSeek(xFilial("SRJ")+QAA->QAA_CODFUN))
    	  If SRJ->(Found())
    	 	 _cDescFuncao := SRJ->RJ_DESC
    	  Endif
      Endif
     _nLin++
    

     If _nLin = 1 
        _cNotas := OemToAnsi("- A MERCADORIA SOMENTE SER� ACEITA SE NA NOTA FISCAL CONSTAR O N�MERO DA AUTORIZA��O")
     Elseif _nLin = 2
        _cNotas := OemToAnsi("  DE ENTREGA E DO PEDIDO DE COMPRA ABERTO.")           
     Elseif _nLin = 3                   
        _cNotas := OemToAnsi("- A CONDI��O DE PAGAMENTO SER� INICIADA A PARTIR DA DATA DE ENTREGA DA MERCADORIA NA WHB.")      
     Elseif _nLin = 4                   
        _cNotas := OemToAnsi("- N�O EMITIR BOLETO BANC�RIO.")      
     Elseif _nLin = 5                   
        _cNotas := OemToAnsi("- CR�DITO EM CONTA CORRENTE EXCLUSIVAMENTE DO FORNECEDOR.")      
     Elseif _nLin = 6                   
        _cNotas := OemToAnsi("- ADEQUAR OS VENCIMENTOS PARA SEGUNDAS, QUARTAS E SEXTAS.")      
     Else
        _cNotas := Space(80)     
     Endif
          
     @ pRow()+1,001 pSay + OemToAnsi("+-------------------+---------------------------+---------------------+---------------+--------------------------------|                                                                                                  |")
     @ pRow()+1,001 pSay + OemToAnsi("|"+SZU->ZU_LOGIN) 
     @ pRow()  ,021 pSay + OemToAnsi("|"+ _cDescFuncao)
     @ pRow()  ,049 pSay + OemToAnsi("|  "+ Dtoc(SZU->ZU_DATAPR))
     @ pRow()  ,071 pSay + OemToAnsi("|  "+ SZU->ZU_HORAPR)
     @ pRow()  ,087 pSay + OemToAnsi("|  "+ _cDescStatus)
     @ pRow()  ,120 pSay + OemToAnsi("| " +_cNotas)     
     @ pRow()  ,219 pSay + OemToAnsi("|")
     SZU->(Dbskip())
   Enddo
     @ pRow()+1,001 pSay + OemToAnsi("+-------------------+---------------------------+---------------------+---------------+--------------------------------|                                                                                                  |")
   _nLin++
   For _nLin := _nLin to 6  // Feito para imprimir todas as Notas para o fornecedor
      If _nLin = 1 
        _cNotas := OemToAnsi("- A MERCADORIA SOMENTE SER� ACEITA SE NA NOTA FISCAL CONSTAR O N�MERO DA AUTORIZA��O")
      Elseif _nLin = 2
        _cNotas := OemToAnsi("  DE ENTREGA E DO PEDIDO DE COMPRA ABERTO.")           
      Elseif _nLin = 3                   
        _cNotas := OemToAnsi("- A CONDI��O DE PAGAMENTO SER� INICIADA A PARTIR DA DATA DE ENTREGA DA MERCADORIA NA WHB.")      
      Elseif _nLin = 4                   
        _cNotas := OemToAnsi("- N�O EMITIR BOLETO BANC�RIO.")      
      Elseif _nLin = 5                   
        _cNotas := OemToAnsi("- CR�DITO EM CONTA CORRENTE EXCLUSIVAMENTE DO FORNECEDOR.")      
      Elseif _nLin = 6                   
        _cNotas := OemToAnsi("- ADEQUAR OS VENCIMENTOS PARA SEGUNDAS, QUARTAS E SEXTAS.")      
      Else
        _cNotas := Space(80)     
      Endif
   
      @ pRow()+1,001 pSay + OemToAnsi("|                   |                           |                     |               |                                | ") +_cNotas
      @ pRow()  ,219 pSay + OemToAnsi("|")
      @ pRow()+1,001 pSay + OemToAnsi("+-------------------+---------------------------+---------------------+---------------+--------------------------------|                                                                                                  |")      
  
   Next _nLin   
   @ pRow()+1,001 pSay + OemToAnsi("|                   |                           |                     |               |                                | ") 
   @ pRow()  ,219 pSay + OemToAnsi("|")
   @ pRow()+1,001 pSay + OemToAnsi("+-------------------+---------------------------+---------------------+---------------+--------------------------------+--------------------------------------------------------------------------------------------------+")   
   //@ pRow()+1,001 pSay + OemToAnsi("+-------------------+---------------------------+---------------------+---------------+--------------------------------+--------------------------------------------------------------------------------------------------+")   
Else
   @ pRow()+1,001 pSay + OemToAnsi("+-------------------+---------------------------+---------------------+---------------+--------------------------------|                                                                                                  |")
   @ pRow()+1,001 pSay + OemToAnsi("|                   |                           |                     |               |                                | - A MERCADORIA SOMENTE SER� ACEITA SE NA NOTA FISCAL CONSTAR O N�MERO DA AUTORIZA��O             |")
   @ pRow()+1,001 pSay + OemToAnsi("+-------------------+---------------------------+---------------------+---------------+--------------------------------|   DE ENTREGA E DO PEDIDO DE COMPRA ABERTO.                                                       |")
   @ pRow()+1,001 pSay + OemToAnsi("|                   |                           |                     |               |                                |                                                                                                  |")
   @ pRow()+1,001 pSay + OemToAnsi("+-------------------+---------------------------+---------------------+---------------+--------------------------------| - A CONDI��O DE PAGAMENTO SER� INICIADA A PARTIR DA DATA DE ENTREGA DA MERCADORIA NA WHB.        |")
   @ pRow()+1,001 pSay + OemToAnsi("|                   |                           |                     |               |                                |                                                                                                  |")
   @ pRow()+1,001 pSay + OemToAnsi("+-------------------+---------------------------+---------------------+---------------+--------------------------------| - N�O EMITIR BOLETO BANC�RIO.                                                                    |")
   @ pRow()+1,001 pSay + OemToAnsi("|                   |                           |                     |               |                                |                                                                                                  |")
   @ pRow()+1,001 pSay + OemToAnsi("+-------------------+---------------------------+---------------------+---------------+--------------------------------| - CR�DITO EM CONTA CORRENTE EXCLUSIVAMENTE DO FORNECEDOR.                                        |")
   @ pRow()+1,001 pSay + OemToAnsi("|                   |                           |                     |               |                                |                                                                                                  |")
   @ pRow()+1,001 pSay + OemToAnsi("+-------------------+---------------------------+---------------------+---------------+--------------------------------| - ADEQUAR OS VENCIMENTOS PARA SEGUNDAS, QUARTAS E SEXTAS.                                        |")
   @ pRow()+1,001 pSay + OemToAnsi("|                   |                           |                     |               |                                |                                                                                                  |")
   @ pRow()+1,001 pSay + OemToAnsi("+-------------------+---------------------------+---------------------+---------------+--------------------------------+--------------------------------------------------------------------------------------------------+")
Endif   
Return .T.

//************************************************************************************************************//
Static Function ImpCabec1()
FmtLin(,AvalImp(nLargMax),,,@nLin)
@ pRow()+1,001 pSay "+-------------------------------------------+---------------------------------------------+---------------------+---------------------------------+-----------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,045 pSay OemToAnsi("| A U T O R I Z A � � O  D E  E N T R E G A")
@ pRow()  ,091 pSay "|"
@ pRow()  ,093 pSay " Numero: " +TMP->C7_NUM
//@ pRow()  ,088 pSay "/"+Str(nOrdem,1)+ " - "+ IIf(TMP->C3_EMITIDO=="S",Str(SC7->C7_QTDREEM+1,2)+"a. VIA","")
@ pRow()  ,113 pSay "| Data Emissao: "+ Dtoc(TMP->C7_EMISSAO) 
@ pRow()  ,147 pSay "| Num Pedido:" + TMP->C7_NUMSC+"-"+TMP->C7_ITEMSC
@ pRow()  ,173 pSay "| Data Rev:             Num.Rev:"     
//@ pRow()  ,130 pSay Dtoc(TMP->C7_EMISSAO)
//@ pRow()  ,171 pSay "  Validade:"
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay SM0->M0_NOMECOM
@ pRow()  ,045 pSay "+---------------------------------------------+---------------------+---------------------------------+-----------------------------------------------------------------------+"
@ pRow()+1,001 pSay "|"
@ pRow()  ,003 pSay + SM0->M0_ENDENT
SA2->(DbGotop())
SA2->(DbSeek(xFilial("SA2")+TMP->C7_FORNECE+TMP->C7_LOJA))
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
@ pRow()  ,047 pSay TMP->C7_CONTATO
@ pRow()  ,069 pSay "FONE: "
@ pRow()  ,075 pSay Left(SA2->A2_TEL,17)
@ pRow()  ,093 pSay "FAX: "
@ pRow()  ,098 pSay Left(SA2->A2_FAX,24)
@ pRow()  ,219 pSay "|"
@ pRow()+1,001 pSay "+----+---------------+------------------------------------------------------------------------+--+-------------+----------------+-----+---+----------+----------------+--+----------+-------+-----------------------------+"
@ pRow()+1,001 pSay "|Item| Codigo WHB    |   Descricao do Material                                                |UM|  Quantidade | Valor Unitario |Moeda|IPI| Entrega  | Desenho/Norma  |Rv| Dat.Rev  |  S.C. |Item SC                      |"
@ pRow()+1,001 pSay "+----+---------------+------------------------------------------------------------------------+--+-------------+----------------+-----+---+----------+----------------+--+----------+-------+-----------------------------+"
numPed:=TMP->C7_NUM

Return .T.

Static Function fProcessa()
	cQuery := "SELECT * "
	cQuery += "FROM "+RetSqlName("SC7")+" "
	cQuery += "WHERE C7_FILIAL='"+xFilial("SC7")+"' AND "
	cQuery += "C7_EMISSAO>='"+Dtos(SC7->C7_EMISSAO)+"' AND "
	cQuery += "C7_EMISSAO<='"+Dtos(SC7->C7_EMISSAO)+"' AND "	
	cQuery += "C7_NUM>='"+SC7->C7_NUM+"' AND "
	cQuery += "C7_NUM<='"+SC7->C7_NUM+"' AND "	
	cQuery += "C7_FORNECE>='"+SC7->C7_FORNECE+"' AND "
	cQuery += "C7_FORNECE<='"+SC7->C7_FORNECE+"' AND "	
	cQuery += "C7_LOJA>='"+SC7->C7_LOJA+"' AND "
	cQuery += "C7_LOJA<='"+SC7->C7_LOJA+"' AND "	
//	cQuery += "C3_PRODUTO>='"+SC3->C3_PRODUTO+"' AND "
//	cQuery += "C3_PRODUTO<='"+SC3->C3_PRODUTO+"' AND "	
//	cQuery += "C3_LOCAL>='"+SC3->C3_LOCAL+"' AND "
//	cQuery += "C3_LOCAL<='"+SC3->C3_LOCAL+"' AND "	
//	If mv_par13 == 2 
//		cQuery += "C3_QUJE = 0 AND "	
//	ElseIf mv_par13 == 3
//		cQuery += "(C3_QUJE > 0 AND C3_QUANT > C3_QUJE) AND "	
//	ElseIf mv_par13 == 4
//		cQuery += "C3_QUJE = C3_QUANT AND "	
//	Endif
	cQuery += "D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY "+SqlOrder(SC7->(IndexKey()))
//    MemoWrit('C:\TEMP\COM012.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TMP"  	
	TcSetField("TMP","C7_EMISSAO","D")  // Muda a data de string para date    	
	TcSetField("TMP","C7_DATPRF","D")  // Muda a data de string para date    		
//	cQuery := ChangeQuery(cQuery)
//	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC3)
	
Return(.T.)

/*
GRPRetName(c�digo do grupo) 
UsrRetGRP(<c�digo do usu�rio>).Retorna um array contendo os c�digos dos grupos que o usu�rio pertence (default usu�rio corrente).. .
RetCodUsr()Retorna o c�digo do usu�rio corrente.. .
UsrFullName(<c�digo do usu�rio>).Retorna o nome completo do usu�rio informado no par�metro (default usu�rio corrente).. .
UsrExist(c�digo do usu�rio).Retorna .T. ou .F. conforme a exist�ncia do usu�rio. Mostra um help, caso o usu�rio n�o exista.. .
UsrRetMail(c�digo do usu�rio).Retorna o email do usu�iro informado.. . ...
Function MATA125(xAutoCab,xAutoItens,nOpcAuto)
/*
