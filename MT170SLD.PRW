/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT170SLD   ºAutor ³João Felipe         º Data ³  14/02/2008º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ 							                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESTOQUE / CUSTOS                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºArray: O parâmetro tem a seguinte estrutura:                           º±±
±±º{nSaldo,SB2->B2_COD,SB2->B2_LOCAL}                                     º±±
±±ºnSaldo -> Saldo calculado pelo sistema                                 º±±
±±ºSB2->B2_COD -> Códido do produto                                       º±±
±±ºSB2->B2_LOCAL -> Armazém do produto                                    º±±
±±ºRetorno                                           					  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºLOCALIZAÇÃO   : Localizado na função A170Point  (Geração  das  		  º±±
±±ºsolicitações  de  compra).								              º±±
±±ºEM QUE PONTO : É executado dentro do laço onde  é feito o cálculo  do  º±±
±±ºsaldo  do  produto                                                     º±±
±±ºde todos os almoxarifados. O resultado do cálculo do saldo é guardado  º±±
±±ºna variável nSaldo.                                                    º±±
±±ºO ponto de entrada é executado após a  atualização  desta  variável,   º±±
±±ºproduto  a  produto 					                                  º±±
±±º(todos os almoxarifados) .                                             º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "topconn.ch"

User Function MT170SLD( )

Local nQuant:= PARAMIXB[1]
Local cProd := PARAMIXB[2]
Local cLocal:= PARAMIXB[3]
Local nNewSaldo := nQuant
Local B2Reg := SB2->(RecNo()) //Guarda o registro do SB2


If GetMv('MV_REAFI')

	//Se for ferramenta NOVA
	If Substr(cProd,1,4)$"FE01/FE02/FE03"
	
		//Verifica o saldo da FE REAFIADA no SB2
		DbSelectArea("SB2")
		DbSetOrder(1)
		If DbSeek(xFilial("SB2")+"FE05"+Substr(cProd,5,7))
			While "FE05"+Substr(cProd,5,7)$SB2->B2_COD
				If SB2->B2_LOCAL <> '50' //descarta o almox 50 -> antigo preset
					nNewSaldo += SB2->B2_QATU
				EndIf
				SB2->(DbSkip())
			EndDo
			
		EndIf
	EndIf
	
EndIf

SB2->(DbGoTo(B2Reg))//Volta o registro do SB2

Return (nNewSaldo)



