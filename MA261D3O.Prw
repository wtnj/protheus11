/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M261D3O         ³ Alexandre R. Bento    ³ Data ³ 15.01.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³  Ponto de Entrada que grava origem dos novos campos adi-  ´±± 
±±³          ³  cionados no browse da transferencias modelo II (MATA261) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


#INCLUDE "rwmake.ch"

User Function M261D3O() 

Local _n  := PARAMIXB //Posicao do acols (item)
// posicao do campo no aHeader
Local _nCarDef  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_CARDEF"})
Local _nDefeito := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_DEFEITO"})
Local _nOper    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_OPERACA"})
Local _nForne   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_FORNECE"})
Local _nLoja    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOJA"})
Local _nLocOri  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOCORIG"})
Local _nCC      := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_CC"})
Local _nTur     := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_TURNO"})
Local _nMaq     := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_MAQUINA"})
Local _nLinha   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LINHA"})
Local _nCodPa   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_CODPA"}) // Adicionado em 13/12/12
Local _dDtRef   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_DTREF"}) // ADICIONADO EM 29/04/13 - RNC
Local _nCorrid  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_CORRID"}) // Adicionado em 30/09/13 - P/ RASTREAMENTO DA CORRIDA
Local _nCorGer  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_CORRIDA"}) // Adicionado em 30/09/13 - P/ RASTREAMENTO DA CORRIDA
Local _nOP      := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_OP"}) // Adicionado em 21/10/2013 - OEE X OP

//Gravando os novos campos de Origem

RecLock("SD3",.F.)
    SD3->D3_CARDEF  := aCols[_n,_nCarDef]
	SD3->D3_DEFEITO := aCols[_n,_nDefeito]
	SD3->D3_OPERACA := aCols[_n,_nOper]
	SD3->D3_FORNECE := aCols[_n,_nForne]
	SD3->D3_LOJA    := aCols[_n,_nLoja] 
	SD3->D3_LOCORIG := aCols[_n,_nLocOri]
	SD3->D3_CC      := aCols[_n,_nCC]
	SD3->D3_TURNO   := aCols[_n,_nTur]
	SD3->D3_MAQUINA := aCols[_n,_nMaq]		
	SD3->D3_LINHA   := aCols[_n,_nLinha]
	SD3->D3_CODPA   := aCols[_n,_nCodPa] // Adicionado em 13/12/12						
	SD3->D3_ORIGEM  := UPPER(ALLTRIM(FUNNAME()))	
	SD3->D3_HORA    := SUBSTR(Time(),1,5)       
	SD3->D3_DTREF   :=  aCols[_n,_dDtRef]  // Adicionado em 29/04/13	
	SD3->D3_CORRID  :=  aCols[_n,_nCorrid] // Adicionado em 30/09/13 - P/ RASTREAMENTO DA CORRIDA 
	SD3->D3_CORRIDA  :=  aCols[_n,_nCorGer] // Adicionado em 30/09/13 - P/ RASTREAMENTO DA CORRIDA 	
	SD3->D3_OP      := aCols[_n][_nOP]	 // Adicionado em 21/10/2013 - OEE X OP 
MsUnLock("SD3")

Return
