
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410LIOK  ºAutor  ³Alexandre R. Bento  º Data ³  13/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para verificar se o almoxarifado digitado º±±
±±º          ³ é o 04 para produto Acabado                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
User Function M410LIOK()

Local _nPosLocal:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_LOCAL" })
Local _nPosTes  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_TES" })
Local _nPosCF   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_CF" })
Local _nPosNcm  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_NCM" })  
Local _nPosCod  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_PRODUTO" })
Local _nPosUM   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_UM" })
Local _nPosCli  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_CLI" })
Local _nIPI     := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_PIPI" })   
Local _nPrcVe   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_PRCVEN" })   
Local _nPrcUn   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_PRUNIT" })   
Local _nPrcTo   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_VALOR" })   
Local _nQtdeV   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_QTDVEN" })   

Local _lOk      := .T.
Public oDlg    

/************* TESTE: INVENTARIO *******************/
//Verifica se produto está bloqueado para inventário 
If !aCols[n][len(aHeader)+1]	
	If !U_E205BLQ(Acols[n][_nPosCod],Acols[n][_nPosLocal])				
	    Return .F. 	
	EndIF
EndIf
/**************************************************/

If !Acols[n][len(aHeader)+1]
	SB1->(DbSeek(xFilial("SB1")+Acols[n][_nPosCod],.F.))                              
	If SB1->B1_UM <> Acols[n][_nPosUM]
	   MsgBox("Atencao a Unidade de Medida esta Diferente do Cadastro do Produto Verifique","Atencao","ALERT")
	   _lOk := .F.
	                    
	Endif
	
    If SB1->B1_GRUPO$"PA02" .And. Acols[n][_nPosLocal]$"27/23"	
	   MsgBox("Atencao Este Produto nao pode ser Faturado para este Almoxarifado Verifique","Atencao","ALERT")
	   _lOk := .F.
    Endif

   	If Acols[n][_nPosTes]$"513/572"
	   SA1->(DbSetOrder(1))
       If SA1->(DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))
          If !SA1->A1_EST$"PR"
             MsgBox("Atencao não Pode Faturar com Esta TES Para Estado Diferentes de PR Verifique","Atencao","ALERT")
         	 _lOk := .F.
          Endif
       Endif       
   	Endif 

	// os: 063262
	If aCols[n][_nPosTes]$"648/650/651/652/653/657" .and. M->C5_CLIENTE<>"900109"
		Alert("Utilizar as TES de transferencia somente entre matriz x filial!!!!")
		Return .f.
	Endif         
	// fim os 063262
	
	//-- os nº.: 020176, 038778
	//-- data: 06/02/2012
	//-- autor: João Felipe da Rosa
   	If Acols[n][_nPosTes]$"613/576"
	   SA1->(DbSetOrder(1))
       If SA1->(DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))
          If SA1->A1_EST$"PR"
             MsgBox("Atencao não Pode Faturar com Esta TES Para Estado do PR! Verifique!","Atencao","ALERT")
         	 _lOk := .F.
          Endif
       Endif
   	Endif
	//-- fim os nº: 020176,038778
    
    If SB1->B1_TIPO$"PA/SU/PW" 
	   SA7->(DbSetOrder(1))
       If SA7->(DbSeek(xFilial("SA7")+M->C5_CLIENTE+M->C5_LOJACLI+Acols[n][_nPosCod] )) 
          If !Empty(SA7->A7_COND)
         	 MsgBox("Foi Alterada a Condição de Pagamento de "+ M->C5_CONDPAG + "  Para " + SA7->A7_COND,"Atencao","ALERT")
             M->C5_CONDPAG := SA7->A7_COND //Pega a condicao de pagamento por produto	
          Endif

          If SA7->A7_PRECO01 > 0
           //  Alert(" Quantidade Total : "+ Transform(_nQuant,"@E 999,999,999.999"))//soma da qtde          
         	 MsgBox("Foi Alterado o Preco do produto de "+ Transform(Acols[n][_nPrcVe],"@E 99,999,999.9999") + "  Para " + Transform(SA7->A7_PRECO01,"@E 99,999,999.9999"),"Atencao","ALERT")
         	 Acols[n][_nPrcVe] := SA7->A7_PRECO01 //Pega o preco por produto	
         	 Acols[n][_nPrcUn] := SA7->A7_PRECO01 //Pega o preco por produto	
         	 Acols[n][_nPrcTo] := Acols[n][_nQtdeV]*  SA7->A7_PRECO01 //Pega o preco por produto	
       
          Endif  

          If !Empty(SA7->A7_TES)
           //  Alert(" Quantidade Total : "+ Transform(_nQuant,"@E 999,999,999.999"))//soma da qtde          
         	 MsgBox("Foi Alterada da TES "+ Acols[n][_nPosTes] + "  Para " + SA7->A7_TES,"Atencao","ALERT")
         	 Acols[n][_nPosTes] := SA7->A7_TES  //Pega a TES por produto	
          	 If SF4->(Dbseek(xFilial("SF4")+Acols[n][_nPosTes]))         	 
         	    Acols[n][_nPosCF] := SF4->F4_CF  //Pega a CF por produto	         	 
         	 Endif   
          Endif  
          
	   Endif			    
    Endif
    
	If empty(Acols[n][_nPosNcm])           
       Acols[n][_nPosNcm] := SB1->B1_POSIPI
       If empty(Acols[n][_nPosNcm])           	   
	      MsgBox("Atencao Numero do NCM é Obrigatório Favor Digitar","Atencao","ALERT")
	      _lOk := .F.
	   Endif   
	Else
	    If Empty(SB1->B1_POSIPI) //grava somente qdo vazio
	       RecLock("SB1")
	          SB1->B1_POSIPI := Acols[n][_nPosNcm] //grava o NCM no cadastro de produto
	       MsUnlock("SB1")
	    Endif   
   	Endif   

    If SM0->M0_CODIGO == "NH"		
        // Inserido a pedido do Mauricio Faria Orlowski do compras pela Ordem de serviço 002156
	   If Acols[n][_nPosCod]$"SU02.000006/SU02.000004" .And. Acols[n][_nPosCli]$"900205/000184" 

		  MsgBox("Atencao Nao Pode Faturar Nota Para Este Cliente, Verifique Com Mauricio-Compras","Atencao","ALERT")
	      _lOk := .F.
	   
	   Endif
    Endif
	
//	If !Alltrim(Upper(cusername))$"LUIZWJ"
	  If !empty(Acols[n][_nPosTes]) .And. !empty(Acols[n][_nPosLocal])
		SF4->(Dbseek(xFilial("SF4")+Acols[n][_nPosTes]))
		
	    If SF4->F4_CREDIPI == 'S' .And. Acols[n][_nIPI] == 0
	   	   MsgBox("Produto sem IPI Cadastrado Utilize uma TES que nao CREDITA IPI","Atencao","STOP")
	       _lOk := .F.
	    Endif

	    If SF4->F4_DUPLIC == 'S' .And. M->C5_TIPO$"N" 
	       If Acols[n][_nPrcUn]== 1
	   	      MsgBox("Valor do Produto Divergente, Confirmar com o Depto de Custo ","Atencao","STOP")
	          _lOk := .F.
	       Endif   
	    Endif	    
	    
	    If SF4->F4_DUPLIC == 'S' .And. Acols[n][_nPosNcm]$"00000000/99999999"
	   	   MsgBox("Cadastrar o NCM Correta ","Atencao","STOP")
	       _lOk := .F.
	    Endif	    
	    
	    If SF4->F4_DUPLIC$"S" .And. M->C5_TIPO$"B" 
	   	   MsgBox("Nao Utilizar Fornecedores p/ Efetuar Venda, Altere o Tipo da Nota","Atencao","STOP")
	       _lOk := .F.
	    Endif
	    
	    
		If SF4->F4_ESTOQUE == 'S'

            If SM0->M0_CODIGO == "NH"		
			   	IF !Acols[n][_nPosLocal]$'04/05' .And. SB1->B1_TIPO == 'PA'
			   	   MsgBox("Produto Acabado nao pode ser faturado neste Almoxarifado Somente para 04","Atencao","STOP")
			       _lOk := .F.
			    Endif   
		     	IF Acols[n][_nPosLocal] == '10' //.And. SB1->B1_TIPO == 'PA'
			   	   MsgBox("Produto nao pode ser faturado neste Almoxarifado ","Atencao","STOP")
			       _lOk := .F.
			    Endif   	    
			ElseIf SM0->M0_CODIGO == "FN"		
			    //verifica de é importacao e atribui o almox 37 ou 27 padrao p/ faturamento da fundicao
   			    IF UPPER(FUNNAME())$"EECAP100" .And. SB1->B1_GRUPO$"PA02" 
                   Acols[n][_nPosLocal] := "37"
   			    ElseIf UPPER(FUNNAME())$"EECAP100" 
                   Acols[n][_nPosLocal] := "27"   			    
   			    Endif
			   
			   	IF !Acols[n][_nPosLocal]$"27/37/47/57/67/3T/50/59" .And. SB1->B1_TIPO == 'PA' 
			   	   MsgBox("Produto Acabado nao pode ser faturado neste Almoxarifado Somente para 27 ou 37 ou 47 ou 57 ou 67 ou 3T","Atencao (P.E. M410LIOK)","STOP")
			       _lOk := .F.
			    Endif   
		     	IF Acols[n][_nPosLocal] == '24/32' //.And. SB1->B1_TIPO == 'PA'
			   	   MsgBox("Produto nao pode ser faturado neste Almoxarifado ","Atencao","STOP")
			       _lOk := .F.
			    Endif   	    
			EndIf
		Endif	
	  EndIf
	//Endif
Endif
	
Return(_lOk)
