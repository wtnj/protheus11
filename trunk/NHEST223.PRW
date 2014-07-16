#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "colors.ch"
#include "font.ch"
#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ E223 ºAutor  ³Douglas de S. Douradoº    Data ³ 21/01/2014º  ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica o limite mensal de requisicao por produto		  º±±
±±º															         	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHEST223(cProd,cCC,nQtSol,dtSolic,cTurno)
Private cQuery1 := "", cQuery2 := "", cMes := Subs(Dtos(dtSolic),5,2), cAno := Subs(Dtos(dtSolic),1,4) , espace := "", cMsg := "", lTurno := .F.


// Verifica se existe limite de requisição, COM restrição de turno (valor 4 = todos)

cQuery1 := " SELECT ZSB_LIMITE, ZSB_TURNO "     
cQuery1 += " FROM " + RetSqlName("ZSB") + " ZSB (NOLOCK) " 
cQuery1 += " WHERE ZSB_PROD = '" + cProd + "' " 
cQuery1 += " AND ZSB_CC = '" + cCC + "' "
cQuery1 += " AND ZSB_TURNO = '" + Alltrim(cTurno) + "' "
cQuery1 += " AND ZSB.D_E_L_E_T_ = '' "
cQuery1 += " AND ZSB_FILIAL = '" +xFilial("ZSB") + "' " 

TCQUERY cQuery1 NEW ALIAS "TRBZSB"  // Criando ALIAS

IF  TRBZSB->(Eof()) 		
	TRBZSB->(DbCloseArea())
ELSE
	lTurno := .T.
ENDIF  

// Verifica se existe limite de requisição, SEM restrição de turno (valor 4 = todos)
If !lTurno

	cQuery1 := " SELECT ZSB_LIMITE, ZSB_TURNO "     
	cQuery1 += " FROM " + RetSqlName("ZSB") + " ZSB (NOLOCK) " 
	cQuery1 += " WHERE ZSB_PROD = '" + cProd + "' " 
	cQuery1 += " AND ZSB_CC = '" + cCC + "' "
	cQuery1 += " AND ZSB_TURNO = '4' "
	cQuery1 += " AND ZSB.D_E_L_E_T_ = '' "
	cQuery1 += " AND ZSB_FILIAL = '" +xFilial("ZSB") + "' " 
	
	TCQUERY cQuery1 NEW ALIAS "TRBZSB"  // Criando ALIAS
	
	IF  TRBZSB->(Eof()) 		
		TRBZSB->(DbCloseArea()) 
		Return .F.
	ENDIF  

EndIf

//Se passou, quer dizer que o produto controla limite mensal

// Agora verifica a quantidade solicitado por este CC no mes
cQuery2 := " SELECT SUM(D3_QUANT) AS 'REQUISICOES' "     
cQuery2 += " FROM " + RetSqlName("SD3") + " SD3 (NOLOCK) " 
cQuery2 += " WHERE D3_COD = '" + cProd + "' " 
cQuery2 += " AND D3_CC = '" + cCC + "' "
cQuery2 += " AND MONTH(D3_EMISSAO) = '" + cMes + "' " 

// Se controla Turno, então adiciona na query
if lTurno
	cQuery2 += " AND D3_TURNO = '" + Alltrim(cTurno) + "' "
endif

cQuery2 += " AND YEAR(D3_EMISSAO) =  '" + cAno + "' "
cQuery2 += " AND SD3.D_E_L_E_T_ = '' "
cQuery2 += " AND D3_FILIAL = '" +xFilial("SD3") + "' " 
cQuery2 += " AND D3_ESTORNO <> 'S'  "
cQuery2 += " AND D3_TM = '501' "

TCQUERY cQuery2 NEW ALIAS "TRBSD3"  // Criando ALIAS
    
	// Caso o select traga algum produto
	IF  TRBSD3->(Eof())
		TRBZSB->(DbCloseArea())
		TRBSD3->(DbCloseArea()) 		
		Return .F.
	ELSE
		// Se o limite tem controle por turno...
		If lTurno		
			If (TRBSD3->REQUISICOES + nQtSol) <= TRBZSB->ZSB_LIMITE .AND. (Alltrim(cTurno) == Alltrim(TRBZSB->ZSB_TURNO))
				TRBZSB->(DbCloseArea())
				TRBSD3->(DbCloseArea()) 
				RETURN .F.
			ELSE			 
				
				cMsg := "Quantidade por mês e por turno para o centro de custo "+ cCC+ " referente ao produto " + cProd + " ultrapassa o limite mensal !" +CHR(13)+CHR(10)+;
				CHR(13)+CHR(10)+"Quantidade requisitada no mês atual: " + Alltrim(str(TRBSD3->REQUISICOES)) + CHR(13)+CHR(10)+;
			    "Quantidade limite por mês para o "+Alltrim(TRBZSB->ZSB_TURNO)+"º Turno : " + Alltrim(str(TRBZSB->ZSB_LIMITE)) 
				
				TRBZSB->(DbCloseArea())
				TRBSD3->(DbCloseArea())
				
				
				MsgBox(cMsg,"Limite atingido, contato o Almox. para maiores informações. (MTA105LIN)","ALERT")
				RETURN .T.
			EndIF
		Else		
			// Verifica se a quantidade solicitada no mes + a quantidade da solicitação, é menor ou igual o limite mensal
			If (TRBSD3->REQUISICOES + nQtSol) <= TRBZSB->ZSB_LIMITE
				TRBZSB->(DbCloseArea())
				TRBSD3->(DbCloseArea()) 
				RETURN .F.
			ELSE			 
				
				cMsg := "Quantidade por mês para o centro de custo "+ cCC+ " referente ao produto " + cProd + " ultrapassa o limite mensal !" +CHR(13)+CHR(10)+;
				CHR(13)+CHR(10)+"Quantidade requisitada no mês atual: " + Alltrim(str(TRBSD3->REQUISICOES)) + CHR(13)+CHR(10)+;
			    "Quantidade limite por mês: " + Alltrim(str(TRBZSB->ZSB_LIMITE)) 
				
				TRBZSB->(DbCloseArea())
				TRBSD3->(DbCloseArea())
				
				
				MsgBox(cMsg,"Limite atingido, contato o Almox. para maiores informações. (MTA105LIN)","ALERT")
				RETURN .T.
			EndIF						
		EndIf	
			
	EndIf

RETURN