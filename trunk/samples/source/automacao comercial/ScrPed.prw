#INCLUDE "RWMAKE.CH"

User Function SCRPED()
Local nOrcam
Local sTexto                      
Local nCheques
Local nCartao
Local nConveni
Local nVales
Local nFinanc
Local nOutros
Local cQuant 		:= ""
Local cVrUnit		:= ""
Local cDesconto		:= ""
Local cVlrItem		:= ""
Local nVlrIcmsRet	:= 0			// Valor do icms retido (Substituicao tributaria)


	sTexto:= 'Codigo         Descricao'+Chr(13)+Chr(10)
	sTexto:= sTexto+ 'Qtd             VlrUnit                 VlrTot'+Chr(13)+Chr(10)
	sTexto:= sTexto+'-----------------------------------------------'+Chr(13)+Chr(10)
	dbSelectArea("SL1")                                                                  
	dbSetOrder(1)  
	nOrcam	:= L1_NUM
	nDinheir	:= L1_DINHEIR
	nCheques	:= L1_CHEQUES
	nCartao 	:= L1_CARTAO
	nConveni	:= L1_CONVENI
	nVales  	:= L1_VALES  	
	nFinanc	:= L1_FINANC
	nOutros	:= L1_OUTROS
           
	dbSelectArea("SL2")
	dbSetOrder(1)  
	dbSeek(cFilial + nOrcam)
	
	While L2_NUM == nOrcam 
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Faz o tratamento do valor do ICMS ret.                       �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		If SL2->(FieldPos("L2_ICMSRET")) > 0 
			nVlrIcmsRet		:= SL2->L2_ICMSRET
		Endif
	
		cQuant 			:= StrZero(SL2->L2_QUANT,8,3)
		cVrUnit			:= Str(((SL2->L2_QUANT*SL2->L2_PRCTAB)+SL2->L2_VALDESC+SL2->L2_VALIPI+nVlrIcmsRet)/SL2->L2_QUANT,15,2)
		cDesconto		:= Str(SL2->L2_VALDESC,TamSx3("L2_VALDESC")[1],TamSx3("L2_VALDESC")[2])
		cVlrItem		:= Str(Val(cVrUnit)*SL2->L2_QUANT,15,2)
	
		sTexto:= sTexto + L2_Produto + L2_Descri +Chr(13)+Chr(10)
		sTexto:= sTexto + cQuant +'  '+ cVrUnit +'      '+ cVlrItem + Chr(13) + Chr(10)
		If L2_ValDesc > 0 
			sTexto:= sTexto + 'Desconto no Item:              '+Str(L2_ValDesc,15,2)+Chr(13)+Chr(10)
		EndIf
		DbSkip()
	Enddo                      

	If SL1->L1_DESCONTO > 0 
		sTexto:= sTexto+'Desconto no Total:             '+Str(SL1->L1_DESCONTO,15,2)+Chr(13)+Chr(10)
	EndIf                                                                              
	If SL1->L1_JUROS > 0 
		sTexto:= sTexto+'Acrescimo no Total:            '+Transform(SL1->L1_JUROS,"@R 99.99%")+Chr(13)+Chr(10)
	EndIf

	sTexto:= sTexto+'-----------------------------------------------'+Chr(13)+Chr(10)
	sTexto:= sTexto+'TOTAL                         '+Str(SL1->L1_VLRLIQ,15,2)+Chr(13)+Chr(10)

	If nDinheir > 0 
		sTexto:= sTexto + 'DINHEIRO'+'                       '+Str(nDinheir,15,2)+Chr(13)+Chr(10)
	EndIf
	If nCheques > 0 
		sTexto:= sTexto + 'CHEQUE'+'                         '+Str(nCheques,15,2)+Chr(13)+Chr(10)
	EndIf
	If nCartao > 0 
		sTexto:= sTexto + 'CARTAO'+'                          '+Str(nCartao,15,2)+Chr(13)+Chr(10)
	EndIf
	If nConveni > 0 
		sTexto:= sTexto + 'CONVENIO'+'                        '+Str(nConveni,15,2)+Chr(13)+Chr(10)
	EndIf
	If nVales > 0 
		sTexto:= sTexto + 'VALES'+'                           '+Str(nVales,15,2)+Chr(13)+Chr(10)
	EndIf
	If nFinanc > 0 
		sTexto:= sTexto + 'FINANCIADO'+'                      '+Str(nFinanc,15,2)+Chr(13)+Chr(10)
	EndIf

	sTexto:= sTexto+'-----------------------------------------------'+Chr(13)+Chr(10)

Return sTexto