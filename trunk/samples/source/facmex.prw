#include "rwmake.ch"        
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ FACMEX   ³ Autor ³ Marcello Gabriel      ³ Data ³ 10.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripcion Impresion de Facturas   (Mexico)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Faturamento                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FacMex()
local cAreaA:=alias(),nNotas
FACPerg()
cPerg:="FAC010"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variables utilizadas para parametros                         ³
//³ mv_par01             // Del Factura                          ³
//³ mv_par02             // Hasta el Factura                     ³
//³ mv_par03             // Serie                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aDRIVER := READDRIVER()
cString:="SF2"
titulo :=PADC("Emisi¢n de las Facturas." ,74)
cDesc1 :=PADC("Ser  solicitado el Intervalo para la emisi¢n de las",74)
cDesc2 :=PADC("Facturas generadas",74)
cDesc3 :=""
aReturn := { OemToAnsi("Especial"), 1,OemToAnsi("Administraci¢n"), 1, 2, 1,"",1 }
nomeprog:="FACMEX" 
nLin:=0
wnrel:= "FACMEX"     
cFatFin:=""
cFatIni:=""
cSer:=""
if type("ParamIxb")=="A"
   wnrel:=SetPrint(cString,wnrel,"",Titulo,cDesc1,cDesc2,cDesc3,.T.,"",.T.,"G","",.F.)
   cFatIni:=ParamIxb[1,1]
   cFatFin:=ParamIxb[Len(ParamIxb),1]
   cSer:=ParamIxb[1,2]
else   
    PERGUNTE(cPerg,.F.)
    wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,"",.T.,"G","",.F.)
    cFatIni:=mv_par01
    cFatFin:=mv_par02
    cSer:=mv_par03
endif   
If nLastKey!=27
   SetDefault(aReturn,cString)
   If nLastKey!=27
      VerImp()       
      RptStatus({|| RptNota()})
   endif
endif   
dbselectarea(cAreaA)
Return

Static Function RptNota()
local nLin,nTotImp,nTotItem,cLin,nIndSF2,nIndSD2
dbselectarea("SD2")
nIndSD2:=indexord()
dbsetorder(3)
dbSelectArea("SF2")         
nIndSF2:=indexord()
dbSetOrder(1)               
if val(cFatFin)==0
   dbgobottom()
   cFatFin:=F2_DOC
endif
if val(cFatIni)==0
   dbgotop()
else 
    dbSeek(xFilial("SF2")+cFatIni,.T.)
endif    
cFatIni:=F2_DOC
nNotas:=0
SetRegua(Val(cFatFin)-Val(cFatIni)+1)
while val(F2_DOC)>=val(cFatIni) .and. val(F2_DOC)<=val(cFatFin) .and. !eof()
      if F2_SERIE==cSer .And. If(Type("PARAMIXB")=="A",ASCAN(ParamIxb,{|x| x[1]==SF2->F2_DOC}) > 0,.T.)
         SA1->(dbseek(xFILIAL("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
         SE4->(dbseek(xFILIAL("SE4")+SF2->F2_COND))
         @006,111 psay F2_DOC picture pesqpict("SF2","F2_DOC")
         @008,000 psay SA1->A1_COD picture pesqpict("SA1","A1_COD")
         @008,pcol()+2 psay trim(SA1->A1_NOME) picture pesqpict("SA1","A1_NOME")
         @008,pcol()+3 psay "RFC "+transf(SA1->A1_CGC,pesqpict("SA1","A1_CGC"))
         @008,107 psay F2_EMISSAO
         @010,000 psay SA1->A1_END
         @011,000 psay trim(SA1->A1_MUN)+" - "+trim(SA1->A1_EST)
         @011,109 psay trim(SE4->E4_DESCRI)
         dbselectarea("SD2")
         dbseek(xFILIAL("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
         nLin:=17
         nTotImp:=(nTotItem:=0)
         while D2_DOC==SF2->F2_DOC .and. D2_SERIE==SF2->F2_SERIE .and. D2_CLIENTE==SF2->F2_CLIENTE .and. D2_LOJA==SF2->F2_LOJA .and. !eof()
               @nLin,000 psay D2_COD picture pesqpict("SD2","D2_COD")
               @nLin,016 psay D2_QUANT picture "9999999.999"
               @nLin,028 psay D2_UM picture pesqpict("SD2","D2_UM")
               if (SC6->(dbseek(xFILIAL("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)))
                  @nLin,031 psay SC6->C6_DESCRI picture pesqpict("SC6","C6_DESCRI")
               else   
                   SB1->(dbseek(xFILIAL("SB1")+SD2->D2_COD))
                   @nLin,031 psay SB1->B1_DESC picture pesqpict("SB1","B1_DESC")
               endif    
               @nLin,062 psay D2_PEDIDO picture pesqpict("SD2","D2_PEDIDO")
               @nLin,069 psay D2_ITEMPV picture pesqpict("SD2","D2_ITEMPV")
               @nLin,072 psay D2_REMITO picture pesqpict("SD2","D2_REMITO")
               @nLin,079 psay D2_ITEMREM picture pesqpict("SD2","D2_ITEMREM")
               @nLin,082 psay D2_PRCVEN picture "99,999,999,999.99"
               @nLin++,100 psay D2_TOTAL picture "99,999,999,999.99"
               nTotImp+=D2_VALIMP1
               nTotItem+=D2_TOTAL
               dbskip()
         enddo     
         dbselectarea("SF2")         
         cLin:=Extenso(nTotItem+nTotImp,.F.,F2_MOEDA,"","2")
         @052,000 psay cLin
         @054,100 psay nTotItem picture "99,999,999,999.99"
         @056,100 psay nTotImp picture "99,999,999,999.99"
         @058,100 psay nTotItem+nTotImp picture "99,999,999,999.99"
         nNotas++
      endif
      dbselectarea("SF2")         
      dbskip()
      incregua()
enddo
If nNotas>0
   Eject
   SetPrc(0,0)
Endif
Set Device To Screen
If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(wnrel)
Endif
MS_FLUSH()
dbselectarea("SF2")
dbsetorder(nIndSF2)
dbselectarea("SD2")
dbsetorder(nIndSD2)
Return

Static Function VerImp()
nLin:= 0                
If aReturn[5]==2
   nOpc:= 1
   While .T.
      Eject
      dbCommitAll()
      SETPRC(0,0)
      IF MsgYesNo("Fomulario esta posicionado ? ")
         nOpc := 1
      ElseIF MsgYesNo("Intenta Nuevamente ? ")
             nOpc := 2
      Else
          nOpc := 3
      Endif
      Do Case
         Case nOpc==1
            lContinua:=.T.
            IF UPPER(ALLTRIM(aDRIVER[5])) <> "CHR(32)"
               @ PROW(),000 PSAY aDRIVER[5]
            END   
            Exit
         Case nOpc==2
            Loop
         Case nOpc==3
            lContinua:=.F.
            Return
      EndCase
   End
Endif
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FACPerg  ³ Autor ³ Jose Lucas            ³ Data ³ 22/02/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam...     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 				                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FACPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("FAC010",6)
aRegs:={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Factura De                           ³
//³ mv_par02             // Factura hasta                        ³
//³ mv_par03             // Tipo                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aRegs,{cPerg,"01","¨Factura de         ?","mv_ch1","C",12,0,0,"G","","mv_par01","","            ","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","¨FActura hasta      ?","mv_ch2","C",12,0,0,"G","","mv_par02","","999999999999","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","¨Serie              ?","mv_ch3","C",03,0,0,"G","","mv_par03","","A"           ,"","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next
dbSelectArea(_sAlias)
Return