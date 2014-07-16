#include "rwmake.ch"  
#INCLUDE "TOPCONN.CH"

/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103IPC  ºAutor  ³Alexandre R.Bento   º Data ³  15/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para preenchimento do campo descricao na entrada de NF   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo para WHB Usinagem e Fundição S.A.                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//SC7 ESTA POSICIONADO QUANDO FUNÇÃO É CHAMADA PARA CADA ITEM

User Function MT103IPC()

SetPrvt("CQUERY,_cNCM,_Col,_lSair,aux_c7cond2")
    
     // Trata o preenchimento do campo descricao 
     aux_c7cond2 := Space(03)
	 _lSair  := .T.
     _lin    := paramixb[1]
     _Ped    := Ascan(aHeader,{|x| Alltrim(x[2])=="D1_PEDIDO"})
     _Ite    := Ascan(aHeader,{|x| Alltrim(x[2])=="D1_ITEMPC"})
     _Col    := Ascan(aHeader,{|x| Alltrim(x[2])=="D1_DESCRI"})
     _cNCM   := Ascan(aHeader,{|x| Alltrim(x[2])=="D1_NCM"})
     _nOrdSer:= Ascan(aHeader,{|x| Alltrim(x[2])=="D1_ORDEM"})
     _nLote  := Ascan(aHeader,{|x| Alltrim(x[2])=="D1_LOTECTL"})
     _nSigla := Ascan(aHeader,{|x| Alltrim(x[2])=="D1_SIGLA"})     

     // verifica a pendencia de aprovacao do pedido de compras (alteracao)
	 SZU->(dbSetOrder(4))     
	 If SZU->(DbSeek(xFilial("SZU")+SC7->C7_NUM+SC7->C7_ITEM))
	    While !SZU->(Eof()) .And. SZU->ZU_NUMPED+SZU->ZU_ITEMPED == SC7->C7_NUM+SC7->C7_ITEM
	       
	       If SZU->ZU_ORIGEM$"C77" .And. (Empty(SZU->ZU_STATUS) .OR. SZU->ZU_STATUS=='B')
	          MsgBox(" Nao é Permitido a Entrada Deste Pedido "+SC7->C7_NUM+", pois o mesmo encontra-se "+Chr(13)+;
                     " em Aprovacao Pelo Compras","Depto de Compras","STOP")
              Acols[_Lin][_Ped] := Space(06)
              Acols[_Lin][_Ite] := Space(04)              
                
              //O código abaixo foi comentado para ver
              //se é por este motivo que algumas notas fiscais
              //estão entrando sem a descrição do produto
              //na fundição. Dúvidas falar com Jhonny(Custos) ou Robson(Fiscal)

              //_lSair := .F.
              
              Exit
	       Endif
	       SZU->(Dbskip())
	    Enddo
	 Endif
     
     If !_lSair
        Return(_lSair)
     Endif   
	 
	/****************************************************
	* TRAZ O NUMERO DA OS DE MANUTENCAO INFORMADO NA SC *
	****************************************************/
	SC1->(dbSetOrder(1)) //C1_FILIAL+C1_NUM+C1_ITEM
	SC1->(dbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC))
	
	If SC1->(Found()) .AND. !Empty(SC1->C1_OS)
        aCols[_lin, _nOrdSer]:= SC1->C1_OS
	EndIf
     
     //P/ Desbloquear as condicoes de pgto que estao bloqueadas c/ pedidos em abertos
	 SE4->(DbSeek(xFilial("SE4")+SC7->C7_COND))
	 If SE4->(Found())
	    If SE4->E4_MSBLQL$"1"
	       RecLock("SE4",.F.)
	          SE4->E4_MSBLQL := "2" //Desbloqueia a condição de pgto para entrar a nota fiscal depois bloqueia denovo      
	          SE4->E4_STATUS := "2" // CONTROLE de bloqueio                        
	       MsUnlock("SE4")
      
	    Endif
	 Endif     


     If Acols[_Lin][_Ped] == SC7->C7_NUM .and. Acols[_Lin][_Ite] == SC7->C7_ITEM
	    aCols[_lin,_col]   := SC7->C7_DESCRI
 	    aCols[_lin,_nSigla]:= SC7->C7_SIGLA
	 else
	    aCols[_lin,_col]:= SB1->B1_DESC
     Endif
     
     If SC7->C7_DATPRF > dDatabase
	    MsgBox("Atencao a Data de Entrega do Pedido e Maior que a Data de Recebimento da Nota","Atencao","ALERT")
	 Endif   

     aCols[_lin,_cNCM]  := SB1->B1_POSIPI
     
     aCols[_lin,_nLote] := U_NHEST002() //GERA O LOTE AUTOMATICAMENTE
     
	 _cAlias := Alias()   
	 
	 _nOrdSB1 := SB1->(DbSetOrder())
	 _nRecSB1 := SB1->(Recno())
	 _nOrdSC7 := SC7->(DbSetOrder())
	 _nRecSC7 := SC7->(Recno())
                                        
//    _OP      := alltrim(SC7->C7_OP)
                                   
    aux_produto = SC7->C7_PRODUTO
    aux_fornece = SC7->C7_FORNECE
    aux_datprf  = SC7->C7_DATPRF

    aux_pedido  = SC7->C7_NUM


	cQuery := "SELECT  C7.C7_PRODUTO,C7.C7_NUM,C7.C7_ITEM,C7.C7_SEQUEN,C7.C7_RESIDUO,C7.C7_DATPRF "
	cQuery += "FROM " + RetSqlName( 'SC7' ) +" C7 "
	cQuery += "WHERE C7.C7_FILIAL = '" + xFilial("SC7")+ "' "
	cQuery += "AND C7.C7_ENCER <> 'E' "
	cQuery += "AND C7.D_E_L_E_T_  = ' ' "
    cQuery += "AND C7.C7_RESIDUO <> 'S' "	
	cQuery += "AND C7.C7_PRODUTO = '" + aux_produto + "' "
	cQuery += "AND C7.C7_FORNECE = '" + aux_fornece + "' "  
	cQuery += "AND C7.C7_DATPRF < '" + DTOS(aux_datprf) + "' "  
	cQuery += "ORDER BY C7.C7_DATPRF "

   // MemoWrit('C:\TEMP\MT103IPC.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TMP"
	TcSetField("TMP","C7_DATPRF","D")  // Muda a data de string para date    
    
    if !empty(TMP->C7_PRODUTO)
       ALERT("EXISTE PEDIDO MAIS ANTIGO !!!!  Data: " + Strzero(day(TMP->C7_DATPRF),2) +"/"+Strzero(Month(TMP->C7_DATPRF),2)+"/"+Strzero(Year(TMP->C7_DATPRF),4)+"   Numero: " + TMP->C7_NUM)
    endif

	// Pedidos de compras
    aux_pedido  = SC7->C7_NUM
	cQuery := "SELECT  C7.C7_PRODUTO,C7.C7_NUM,C7.C7_ITEM,C7.C7_SEQUEN,C7.C7_COND,C7.C7_COND2 "
	cQuery += "FROM " + RetSqlName( 'SC7' ) +" C7 "
	cQuery += "WHERE C7.C7_FILIAL = '" + xFilial("SC7")+ "' "
	cQuery += "AND C7.C7_ENCER <> 'E' "
	cQuery += "AND C7.D_E_L_E_T_  = ' ' "
    cQuery += "AND C7.C7_RESIDUO <> 'S' "	
    cQuery += "AND C7.C7_COND2 <> ' ' "    
	cQuery += "AND C7.C7_NUM = '" + aux_pedido + "' "
	TCQUERY cQuery NEW ALIAS "TMP2"


	If Alltrim(GETMV("MV_PED001")) == "S"	
       TMP2->(DbGoTop())
       If !Empty(TMP2->C7_NUM)
		  While !TMP2->(Eof())
		     If !Empty(TMP2->C7_COND2)
		        If Empty(aux_c7cond2)		     
        		   aux_c7cond2 := TMP2->C7_COND2	
		        Endif
			    If TMP2->C7_COND2 <> aux_c7cond2

		           ALERT("EXISTE CONDICAO DE PAGAMENTO DIFERENTE ENTRE OS ITENS AVISE A INFORMATICA !!!!")
			       aCols[_lin,_Ped]:= Space(06)      

	               //O código abaixo foi comentado para ver
	               //se é por este motivo que algumas notas fiscais
	               //estão entrando sem a descrição do produto
	               //na fundição. Dúvidas falar com Jhonny(Custos) ou Robson(Fiscal)
	               
	               //_lSair := .F.

			    Endif   
		     Endif
		     TMP2->(Dbskip())
		  Enddo	     
	   	  If !Empty(aux_c7cond2)
		     CCONDICAO := aux_c7cond2 //atribui a condicao de pagto encontrada
	      Endif    
	   Endif   
	Endif
	// Restauro posicao dos arquivos utilizados
   
	 SB1->(dbSetOrder(_nOrdSB1))
	 SB1->(dbGoto(_nRecSB1))
 	 SC7->(dbSetOrder(_nOrdSC7))
	 SC7->(dbGoto(_nRecSC7))

	 dbSelectArea(_cAlias)
     
     TMP->(DbCloseArea())                                
     TMP2->(DbCloseArea())                                 
     
Return(_lSair)
