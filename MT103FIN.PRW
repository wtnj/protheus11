/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103FIN  ºAutor  ³Marcos R. Roquitski º Data ³  20/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada, Antes de gravar a N.F verifica se        º±±
±±º          ³ existe vencimento menor que a data do sistema.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function MT103Fin()
    Local _Dp := 1,_lRet := .T.
    Local _nVlrTot := 0
    Local _aVenc := {}     


	_lRet := .T.   
//	ALERT(" MT103FIN  "+FUNNAME() )
	If Alltrim(GETMV("MV_FINDUP")) == "S"   
	
        If !SF4->F4_DUPLIC$"S"
	       Return(.T.)
        Endif
	
	    For _Dp := 1 To Len(paramixb[2]) //Array contendo as parcelas
			If paramixb[2][_Dp][3] > 0 .And. paramixb[2][_Dp][2] < (Date() + 2)
					MsgBox("Existe Duplicatas com Vencimento MENOR que a Data Atual ! " +Chr(13) + " " +Chr(13) + ;
					       "Verificar com o Depto FINANCEIRO","Duplicatas","INFO")
					_lRet := .F.
			Endif
		    _nVlrTot +=paramixb[2][_Dp][3] //somente pega o valor total da nota
		Next
		_aVenc := Condicao(_nVlrTot,cCondicao,,dDataBase)  
		If Len(_aVenc) > 0 //se gerou duplicatas
	       For _Dp := 1 To Len(paramixb[2]) //Array contendo as parcelas
		       If paramixb[2][_Dp][2] <> _aVenc[_Dp][1] //Faz uma Comparação das datas de vencimento p/ verificar se o usuario nao alterou a mesma
      		      paramixb[2][_Dp][2] := _aVenc[_Dp][1]  // atribui a data de vencimento calculada pela da de entrada, pois esta sendo calculada pela data emissao
				    /*
						MsgBox("Nao Pode Alterar a Data de Vencimento das Duplicatas ! " +Chr(13) + " " +Chr(13) + ;
					       "Verificar com o Depto FINANCEIRO","Duplicatas","INFO")
					_lRet := .F. 
					*/

			   EndIf
	    
	       Next _Dp
	    Endif   
	Endif		
	
Return(_lRet)
                                                  
