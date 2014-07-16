#Include "ofiom020.ch"
#Include "FiveWin.ch"
#Include "Fileio.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ORDBUSCA  ºAutor  ³Fabio               º Data ³  07/16/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime ordem de busca                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Oficina                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ORDBUSCA() 

SetPrvt("cAlias , cNomRel , cGPerg , cTitulo , cDesc1 , cDesc2 , cDesc3 , aOrdem , lHabil , cTamanho , aReturn , ")
SetPrvt("titulo,cabec1,cabec2,nLastKey,wnrel,tamanho")

aReturn  := { OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 2, 2, 2,,1 }

cAlias := "VO3"
cNomRel:= "ORDBUSCA"
cGPerg := ""
cTitulo:= STR0001
cDesc1 := STR0045
cDesc2 := cDesc3 := ""
aOrdem := {"Nosso Numero","Codigo do Item"}
lHabil := .f.
cTamanho:= "P"
nLastKey:=0

NomeRel := SetPrint(cAlias,cNomRel,,@cTitulo,cDesc1,cDesc2,cDesc3,lHabil,,,cTamanho)

If nlastkey == 27
   Return(Allwaystrue())
EndIf

SetDefault(aReturn,cAlias)

RptStatus({|lEnd| FS_IMPORDBUSC(@lEnd,wnRel,'VO3')},Titulo)

Return(Allwaystrue())

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FS_IMPORDBºAutor  ³Fabio               º Data ³  07/07/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime relatorio de ordem de busca para pecas requisitadas.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Oficina                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function FS_IMPORDBUSC()

SetPrvt("nLin , i , nTotal ")
SetPrvt("cbTxt , cbCont , cString , Li , m_Pag , wnRel , cTitulo , cabec1 , cabec2 , nomeprog , tamanho , nCaracter ")

nCaracter := 0 

nLin := 0 
i := 0 
nTotal := 0

Set Printer to &NomeRel
Set Printer On
Set device to Printer

cbTxt    := Space(10)
cbCont   := 0
cString  := "VO3"
Li       := 80
m_Pag    := 1

wnRel    := "OFIM020"

cTitulo:= STR0046+M->VO2_NUMOSV+STR0047+M->VO2_NOSNUM+STR0048+M->VO2_FUNREQ+" - "+M->VO2_NOMREQ
cabec1 := STR0049+M->VO2_PROVEI+"  "+M->VO2_LJPVEI+" - "+M->VO2_NOMPRO+Space(09)+STR0050+M->VO2_CHASSI+Space(13)+STR0051+M->VO2_CODFRO+Space(13)+If(cReqDev=="1",STR0052,STR0053)
cabec2 := STR0054
//cabec2 := "--- -- ---- --------------------------- ---------------------------- ----- ------- --------- -------------- -------------- ------"
nomeprog:="ORDBUSCA"
tamanho:="M"
nCaracter:=15
nTotal := 0

SetRegua( Len( aCols ) )

nLin := cabec(ctitulo,cabec1,cabec2,nomeprog,tamanho,nCaracter) + 1

For i:=1 to Len(aCols)             

   If !( aCols[i,Len(aCols[i])] )                                                                                                                                                                                                  

      DbSelectArea("SB1")
      DbSetOrder(7)
      DbSeek( xFilial("SB1") + aCols[i,FG_POSVAR("VO3_GRUITE")] + aCols[i,FG_POSVAR("VO3_CODITE")] )

      DbSelectArea("SB5")
      DbSetOrder(1)
      DbSeek( xFilial("SB5") + SB1->B1_COD )
      
      @ nLin++,1 PSAY StrZero(i,2)+"  "+aCols[i,FG_POSVAR("VO3_TIPTEM")]+" "+aCols[i,FG_POSVAR("VO3_GRUITE")]+" "+aCols[i,FG_POSVAR("VO3_CODITE")]+" "+Substr( aCols[i,FG_POSVAR("VO3_DESITE")] , 1 , 25 )+" "+SB1->B1_LOCPAD+" "+SB5->B5_LOCALIZ+" "+Transform(aCols[i,FG_POSVAR("VO3_QTDREQ")],"@E 9,999,999")+" "+Transform(aCols[i,FG_POSVAR("VO3_VALPEC")],"@E 999,999,999.99")+" "+Transform((aCols[i,FG_POSVAR("VO3_QTDREQ")]*aCols[i,FG_POSVAR("VO3_VALPEC")]),"@E 999,999,999.99")+" "+aCols[i,FG_POSVAR("VO3_PROREQ")]

      nTotal := nTotal + (aCols[i,FG_POSVAR("VO3_QTDREQ")]*aCols[i,FG_POSVAR("VO3_VALPEC")])

      IncRegua()
      
   EndIf
   
Next

@ nLin++,109 PSAY Repl("_",15)
@ nLin++,95  PSAY STR0055 + Transform(nTotal,"999,999,999.99")

nLin := nLin + 3

@ nLin++,0 PSAY Repl("_",32)+Space(18)+Repl("_",32)+Space(18)+Repl("_",32)
@ nLin,10 PSAY STR0056+Space(42)+STR0057+Space(40)+STR0058

Eject

Set Printer to
Set device to Screen

MS_FLUSH()
OurSpool(NomeRel)
Return
