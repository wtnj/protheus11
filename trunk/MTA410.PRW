/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³MTA410 º Autor ³ Alexandre R. Bento     º Data ³  01/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para bloquear o faturamento da data       º±±
±±º          ³ Retroativa                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB Usinagem / Fundição                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#INCLUDE "rwmake.ch" 

User Function MTA410
Local _lFat := .T.
Local _x
Local _nPosPro := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C6_PRODUTO"})  
Local _nPosLoc := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C6_LOCAL"}) 
Local _nPosNcm := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_NCM" })  
Local _nPruni  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_PRUNIT" })  //preco de lista
Local _nPrVen  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_PRCVEN" })  //preco de venda
Local _nDesc   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_DESCRI" })  //preco de venda
Local _nNFOri  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_NFORI" })  //preco de venda
Local _nPosTes := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_TES" }) //Tes


//			AADD(xNUM_NFDV ,IIF(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI))
//			AADD(xNUM_NFDV ,IIF(Empty(SD1->D1_NFORI),"",SD1->D1_NFORI))			


If Getmv('MV_FATURA') == 'N' //Não Pode faturar
   If Ddatabase < date() // Nao permite faturar com data retroativa 
      If Day(date()) == 1 .And. Val(Subs(Time(),1,2)) == 0 //Pode Faturar
         _lFat := .T.                                                      
      Else // Não pode faturar     
         Msgbox("Atencao Não é Permitido Faturar com Data Retroativa","Pedido","STOP" )  

         _lfat := .F. 
      Endif   
   Endif
Endif 


If Empty(M->C5_TRANSP) // Invalida o pedido se não houver transportadora 
	MsgBox("Não há transportadora cadastrada para o pedido","Atencao","STOP")
    _lFat := .F.
Endif 
                    
For _x:= 1 to len(Acols)

   If !Acols[_x][len(aHeader)+1]  //nao pega quando a linha esta deletada
	   SB1->(DbSetOrder(1))
	   If SB1->(DbSeek(xFilial("SB1")+aCols[_x][_nPosPro]))   
	      If Empty(SB1->B1_POSIPI)
	      	 RecLock("SB1",.F.)
	            SB1->B1_POSIPI := Acols[_x][_nPosNcm]  //grava o NCM no casdastro do produto
		     MsUnLock("SB1")
	      Endif                    
		  SF4->(Dbseek(xFilial("SF4")+Acols[_x][_nPosTes]))
		  If SF4->F4_ESTOQUE == 'S'

			 If SM0->M0_CODIGO == "FN"		
			   	IF !Acols[_x][_nPosLoc]$"27/37/47/57/67/3T/50/59" .And. SB1->B1_TIPO == 'PA' 
			   	   MsgBox("Produto Acabado nao pode ser faturado neste Almoxarifado Somente para 27 ou 37 ou 47 ou 57 ou 67 ou 3T","Atencao (P.E MTA410)","STOP")
			       _lFat := .F.
			    Endif   
		     ElseIf SM0->M0_CODIGO == "NH"		
			        If SB1->B1_TIPO$"PA" .And. !aCols[_x][_nPosLoc]$'04/05'
					    MsgBox("Produto Acabado so Pode ser Faturado no Almoxarifado 04","Atencao","STOP")
					    _lFat := .F.
			        Endif
			 Endif       
		  Endif 	 

        If  SM0->M0_CODIGO == "FN"
           If SF4->F4_DUPLIC == 'S' .and. M->C5_CLIENTE+M->C5_LOJACLI $ '90002201/90011802/90002501/90002502/90002503/90006401/90000302'
              M->C5_MENPAD:= '002'
           ElseIf SF4->F4_DUPLIC == 'N' .and. M->C5_CLIENTE+M->C5_LOJACLI $ '90002201/90011802/90002501/90002502/90002503/90006401/90000302'
              M->C5_MENPAD:= ''
           Endif
        Endif
	   EndIf
	   
	   If Acols[_x][_nPruni] > Acols[_x][_nPrVen]  //verifica se o preco de lista é maior que o preco de venda
	      Acols[_x][_nPruni] := Acols[_x][_nPrVen]   
	   Endif

       If !Empty(Acols[_x] [_nNFOri]) .And. !Acols[_x][_nDesc]$Acols[_x][_nNFOri] //Grava a referencia da nf de origem na descricao do produto
	   	  Acols[_x][_nDesc] :=  AllTrim(SubStr(Acols[_x][_nDesc],1,24)) + " S/NF:" + Alltrim(Acols[_x][_nNFOri])   
	   Endif	  
   Endif	   
Next _x


Return(_lFat)
