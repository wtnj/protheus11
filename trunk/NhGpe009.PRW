/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ NHgpe009 บAutor  ณAlexandre R. Bento  บ Data ณ  24/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gatilho p/ puxar a verba de assistencia medica de rateio p/บฑฑ
ฑฑบ          ณ DIRF.                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#include "rwmake.ch"      

User Function NhGpe009()

Local _nReg   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "RB_COD"})  
Local _nAsme  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "RB_ASMEDIC"})  
Local _nAsod  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "RB_ASODONT"})  
Local _nVbme  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "RB_VBDESAM"})  
Local _nVbod  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "RB_VBDESAO"})  
Local _cVerba := Space(03)

//Codigo da verba para assistencia medica p/ rateio da DIRF
If !Empty(Acols[n][_nAsme]) .and.  Acols[n][_nReg] == '01'
    _cVerba := "827"                             
ElseIf !Empty(Acols[n][_nAsme]) .and.  Acols[n][_nReg] == '02'    
    _cVerba := "829"                             
ElseIf !Empty(Acols[n][_nAsme]) .and.  Acols[n][_nReg] == '03'    
    _cVerba := "830"
ElseIf !Empty(Acols[n][_nAsme]) .and.  Acols[n][_nReg] == '04'    
    _cVerba := "831"
ElseIf !Empty(Acols[n][_nAsme]) .and.  Acols[n][_nReg] == '05'    
    _cVerba := "832"
ElseIf !Empty(Acols[n][_nAsme]) .and.  Acols[n][_nReg] == '06'    
    _cVerba := "833"
ElseIf !Empty(Acols[n][_nAsme]) .and.  Acols[n][_nReg] == '07'    
    _cVerba := "839"
ElseIf !Empty(Acols[n][_nAsme]) .and.  Acols[n][_nReg] == '08'    
    _cVerba := "840"
Endif

/*
//Codigo da verba para assistencia odontologica p/ rateio da DIRF
If !Empty(Acols[n][_nAsod]) .and.  Acols[n][_nReg] == '01'
    _cVerba := "828"                             
ElseIf !Empty(Acols[n][_nAsod]) .and.  Acols[n][_nReg] == '02'    
    _cVerba := "834"                             
ElseIf !Empty(Acols[n][_nAsod]) .and.  Acols[n][_nReg] == '03'    
    _cVerba := "835"
ElseIf !Empty(Acols[n][_nAsod]) .and.  Acols[n][_nReg] == '04'    
    _cVerba := "836"
ElseIf !Empty(Acols[n][_nAsod]) .and.  Acols[n][_nReg] == '05'    
    _cVerba := "837"
ElseIf !Empty(Acols[n][_nAsod]) .and.  Acols[n][_nReg] == '06'    
    _cVerba := "838"
ElseIf !Empty(Acols[n][_nAsod]) .and.  Acols[n][_nReg] == '07'    
    _cVerba := "841"
ElseIf !Empty(Acols[n][_nAsod]) .and.  Acols[n][_nReg] == '08'    
    _cVerba := "842"
Endif
  */
Return(_cVerba)
