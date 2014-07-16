#include "rwmake.ch"        
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ REMCOLCM ³ Autor ³ Humberto M. Kasai     ³ Data ³ 31.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao | Impresion de Remision   (Colombia)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Compras                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RemColCM()
local cAreaA:=alias()
RemPerg()
cPerg:="REMMEX"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variables utilizadas para parametros                         ³
//³ mv_par01             // Del Factura                          ³
//³ mv_par02             // Hasta el Factura                     ³
//³ mv_par03             // Serie                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aDRIVER := READDRIVER()
cString:="SCM"
titulo :=PADC("Emisi¢n de las Remisiones." ,74)
cDesc1 :=PADC("Ser  solicitado el Intervalo para la emisi¢n de las",74)
cDesc2 :=PADC("Remisiones generadas",74)
cDesc3 :=""
aReturn := { OemToAnsi("Especial"), 1,OemToAnsi("Administraci¢n"), 1, 2, 1,"",1 }
nomeprog:="REMCOLCM" 
nLin:=0
wnrel:= "REMCOLCM"     
cRemFin:=""
cRemIni:=""
if type("ParamIxb")=="A"
   wnrel:=SetPrint(cString,wnrel,"",Titulo,cDesc1,cDesc2,cDesc3,.T.,"",.T.,"G","",.F.)
   cRemIni:=ParamIxb[1]
   cRemFin:=ParamIxb[1]
else   
    PERGUNTE(cPerg,.F.)
    wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,"",.T.,"G","",.F.)
    cRemIni:=mv_par01
    cRemFin:=mv_par02
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
local nLin,nTotImp,nTotItem,cLin,nIndSF2,nIndSCM,cRemAux
dbselectarea("SCM")
nIndSD2:=indexord()
dbsetorder(1)        
if val(cRemFin)==0
   dbgobottom()
   cRemFin:=CM_REMITO
endif
if val(cRemIni)==0
   dbgotop()
else 
    dbSeek(xFilial("SCM")+cRemIni,.T.)
endif    
cRemIni:=CM_REMITO
SetRegua(Val(cRemFin)-Val(cRemIni)+1)
while val(CM_REMITO)>=val(cRemIni) .and. val(CM_REMITO)<=val(cRemFin) .and. !eof()
      SA1->(dbseek(xFILIAL("SA1")+SCM->CM_FORNECE+SCM->CM_LOJA))
      @006,092 psay CM_REMITO picture pesqpict("SCM","CM_REMITO")
      @008,000 psay SA1->A1_COD picture pesqpict("SA1","A1_COD")
      @008,pcol()+2 psay trim(SA1->A1_NOME) picture pesqpict("SA1","A1_NOME")
      @008,pcol()+3 psay "RFC "+transf(SA1->A1_CGC,pesqpict("SA1","A1_CGC"))
      @008,079 psay CM_EMISSAO
      @010,000 psay SA1->A1_ENDENT
      @011,000 psay trim(SA1->A1_MUNE)+" - "+trim(SA1->A1_ESTE)
      nLin:=17
      nTotImp:=(nTotItem:=0)
      cRemAux:=CM_REMITO
      while CM_REMITO==cRemAux .and. CM_FILIAL==cFilial
            @nLin,000 psay CM_PRODUTO picture pesqpict("SCM","CM_PRODUTO")
            @nLin,016 psay CM_QUANT picture "9999999.999"
            @nLin,028 psay CM_UM picture pesqpict("SCM","CM_UM")
            if (SC6->(dbseek(xFILIAL("SC6")+SCM->CM_PEDIDO+SCM->CM_ITEMPED)))
               @nLin,031 psay SC6->C6_DESCRI picture pesqpict("SC6","C6_DESCRI")
            else   
                SB1->(dbseek(xFILIAL("SB1")+SCM->CM_PRODUTO))
                @nLin,031 psay SB1->B1_DESC picture pesqpict("SB1","B1_DESC")
            endif    
            @nLin,062 psay CM_PEDIDO picture pesqpict("SCM","CM_PEDIDO")
            @nLin,069 psay CM_ITEMPED picture pesqpict("SCM","CM_ITEMPED")
            @nLin++,72 psay CM_TOTAL picture "99,999,999,999.99"
            nTotItem+=CM_TOTAL
            dbskip()
            incregua()
      enddo     
      @054,072 psay nTotItem picture "99,999,999,999.99"
      @056,072 psay nTotItem+nTotImp picture "99,999,999,999.99"
enddo
Set Device To Screen
If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(wnrel)
Endif
MS_FLUSH()
dbselectarea("SCM")
dbsetorder(nIndSCM)
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
Static Function RemPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg :="REMMEX"
aRegs:={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Factura De                           ³
//³ mv_par02             // Factura hasta                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aRegs,{cPerg,"01","¨Remison de         ?","mv_ch1","C",tamsx3("CM_REMITO")[1],0,0,"G","","mv_par01","","            ","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","¨Remison hasta      ?","mv_ch2","C",tamsx3("CM_REMITO")[1],0,0,"G","","mv_par02","","999999999999","","","","","","","","","","","","",""})
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