
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A261TOK  ºAutor  ³ João Felipe da Rosaº Data ³  19/03/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ VALIDA A ROTINA MATA261 (TRANSF. MOD. 2)                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESTOQUE / CUSTOS                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
               
User Function A261TOK()
Local nProd    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_COD"})
Local nQuant   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_QUANT"}) 
Local nLocal   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOCAL"}) 
Local nLote    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOTECTL"}) 
Local nLocDest := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOCAL"},nLocal+1)
Local nSaldo   := 0
Local aAreaSB2 := SB2->(GetArea()) //Guarda a posiçao inicial
Local lMail := .F.  
Local _aMail := {}


	// VERIFICA SE EXISTE SALDO DO PRODUTO
	SB2->(dbSetOrder(1)) // FILIAL + COD + LOCAL 
	For x:=1 to Len(aCols)
	
	    If !aCols[x][len(aHeader)+1]
		 
			If (aCols[x][nLocal]$"32/33" .AND. aCols[x][nLocDest]$"3F")
		
			   	Aadd(_aMail,{x,; // Item - 1
							Alltrim(Acols[x][nProd]),;   // produto	- 2				
							Acols[x][nQuant],;           // quantidade - 3
							Acols[x][nLote],;           // Lote - 4
							Acols[x][nLocal]})           // Armazem - 5			
				lMail := .T. 									 
	   		EndIf
		
			If SB2->(dbSeek(xFilial("SB2")+Acols[x][nProd]+Acols[x][nLocal]))
				nSaldo := SB2->B2_QATU - SB2->B2_QEMPSA
			
				If nSaldo - Acols[x][nQuant] < 0
					Alert("Saldo insuficiente no armazém "+Acols[x][nLocal]+"!")
					Return .F.
				EndIf				 
			EndIf    
			
		EndIf
	Next
    RestArea(aAreaSB2) // Volta a posicaodo arquivo   
	
	If lMail
		U_NHEST224(_aMail)
	EndiF
      
    // Fim 075131  
	
Return .T.