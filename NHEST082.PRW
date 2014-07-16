/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST082         ³ Alexandre R. Bento    ³ Data ³ 10.01.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³  Gatilho para trazer o lote automaticamente no internos   ´±± 
±±³          ³  modelo II.                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#INCLUDE "rwmake.ch"

User Function NHEST082() 

//Local _numseq 
//Local _doc 	
//Local _produto

//Local _n  := PARAMIXB //Posicao do acols (item)
// posicao do campo no aHeader
Local _nCod   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_COD"})
Local _nLote  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOTECTL"})
Local _nDtVal := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_DTVALID"})
Local _nQtde  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_QUANT"})
Local _cAlmox := Alltrim(GETMV("MV_LOCPROC"))//almox de processo


//Gravando os novos campos de Destino

If Alltrim(FUNNAME())$"MATA241" .And. SB1->B1_RASTRO$"L" .And. CTM$"002"

	SB8->(DbSetOrder(1))
	IF SB8->(DbSeek(xFilial("SB8")+aCols[n,_nCod]+_cAlmox)+'20050101') 
	   Alert(" encontrei o LOTE")
	   While SB8->(!EOF()) .And. SB8->B8_PRODUTO ==  aCols[n,_nCod] .And. SB8->B8_LOCAL == _cAlmox
	      If (SB8->B8_SALDO - SB8->B8_EMPENHO) >= Acols[n][_nQtde]
	         Acols[n][_nLote]  := SB8->B8_LOTECTL
   	         Acols[n][_nDtVal] := SB8->B8_DTVALID   
   	      Else
   	         Alert(" A Quantidade Digitada eh Maior que o Saldo "+ StrZero(SB8->B8_SALDO-SB8->B8_EMPENHO,2)+ " Do Lote FIFO")
   	         Return(.F.)
   	      Endif   
   	      SB8->(Dbskip())
	   Enddo
   	Else
	  Alert("Nao existe saldo no almoxarifado de processo")
	Endif
Endif	

//ALERT(SB1->B1_RASTRO)
//RecLock("SD3",.F.)

//	_doc := SD3->D3_DOC
//	_numseq := SD3->D3_NUMSEQ
//	_produto := SD3->D3_COD

//    SD3->D3_CARDEF    :=  aCols[_n,_nCarDef]
//	SD3->D3_DEFEITO   :=  aCols[_n,_nDefeito]
//	SD3->D3_OPERACA   :=  aCols[_n,_nOper]
//	SD3->D3_FORNECE   :=  aCols[_n,_nForne]
//	SD3->D3_LOJA      :=  aCols[_n,_nLoja] 
//	SD3->D3_LOCORIG   :=  aCols[_n,_nLocOri]
//	SD3->D3_CC        :=  aCols[_n,_nCC]
  //	SD3->D3_LOTECTL   :=  aCols[_n,12]
//MsUnLock("SD3")
  
/*
SD3->(DbGotop())
SD3->(DbSetOrder(8))
if SD3->(DbSeek(xFilial("SD3")+_doc+_numseq,.F.))
    While  !Eof() .and. SD3->D3_NUMSEQ = _Numseq
	reclock("SD3",.F.)
	SD3->D3_LOTECTL   :=  aCols[_n,12]
	MsUnlock("SD3")
	SD3->(DbSkip())
   enddo
Endif
  
DbSelectArea("SDB")
SDB->(DbSetOrder(15))
IF SDB->(DbSeek(xFilial("SDB")+_produto+_doc,.F.))
	While !Eof() .and. SDB->DB_DOC = _doc
		RecLock("SDB",.F.)                
		SDB->DB_LOTECTL := aCols[_n,12]
		MsUnlock("SDB")
		SDB->(DbSkip())
	Enddo
ENDIF

DbSelectArea("SBF")
SBF->(DbSetOrder(5))
IF SBF->(DbSeek(xFilial("SBF")+aCols[_n,6]+"      "+aCols[_n,5],.F.))
		RecLock("SBF",.F.)                
		SBF->BF_QUANT := SBF->BF_QUANT - aCols[_n,16]
		MsUnlock("SBF")
Endif
*/
Return(.T.)