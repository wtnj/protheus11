
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST153  ºAutor  ³João Felipe da Rosa º Data ³  28/10/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ VALIDA O CAMPO CP_ORDEM                                    º±±
±±º          ³ REQUISICAO ELETRONICA DE MATERIAIS                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHEST153()
Local nCCSCP   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_CC"})  

	//Traz o C.Custo da OS de Manutencao para a Requisição
	If !Empty(M->CP_ORDEM)        
	   	STJ->(DbSetOrder(1)) //filial + cod
   		STJ->(DbSeek(xFilial("STJ")+M->CP_ORDEM))
	   	If STJ->(Found())
   			If STJ->TJ_TERMINO=="N"  
   				If upper(FUNNAME())$"MATA105"
   					Acols[n][nCCSCP] := STJ->TJ_CCUSTO //puxa o centro de custo da OS.
				ElseIf upper(FUNNAME())$"NHEST105"
					M->CP_CC := STJ->TJ_CCUSTO //puxa o centro de custo da OS.
				EndIf   		
			Else
				alert("Ordem de Serviço já Finalizada!")
				Return .F.
			EndIf
		Else
   			alert("Ordem de Serviço não encontrada!")
   			Return .F.
	   	Endif
	Endif

Return .T.