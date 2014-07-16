/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHSGA001  ºAutor  ³Alexandre R. Bento  º Data ³  04/01/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório para imprimir certificaçoes vencidas             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB usinagem / Fundição                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºAlteração ³                                                            º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhsga001()


cString   := "TA0"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir as  ")
cDesc2    := OemToAnsi("Certificações a Vencer")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHSGA001"
aLinha    := { }
nLastKey  := 0
titulo    := "RELATÓRIO DE CERTIFICADOS A VENCER"
Cabec1    := "  CODIGO     NOME LEI                                            CERTIFICADO                              DATA"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1  
wnrel     := "NHSGA001"
_cPerg    := "SGA001" 


AjustaSx1()                                                               

Pergunte(_cPerg,.F.)
/*
If !Pergunte(_cPerg,.T.)
    Return(nil)
Endif   
*/
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]


Processa( {|| RptDetail() },"Imprimindo...")
DbSelectArea("TA0")
DbCloseArea()

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return



Static Function RptDetail()
Local _aDocto := {}


DBSELECTAREA("TA0")

TA0->(DbGoTop())
ProcRegua(TA0->(RecCount()))

While TA0->(!Eof())


   If Prow() > 60
      _nPag := _nPag + 1
      Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
   Endif
   
   If TA0->TA0_CODLEG >= mv_par01 .and. TA0->TA0_CODLEG <= mv_par02
	   //verifica se os doctos estao com data vencida
	   If TA0->TA0_DTVENC <= date() //>= mv_par01 .And. TA0->TA0_DTVENC <= mv_par02
	      Aadd(_aDocto,{Subs(TA0->TA0_CODLEG,1,10),Subs(TA0->TA0_EMENTA,1,40),Subs(TA0->TA0_DOCTO1,1,30),Dtos(TA0->TA0_DTVENC)})
	   Endif   
	
	   If TA0->TA0_DTVEN2 <= date() //>= mv_par01 .And. TA0->TA0_DTVENC <= mv_par02
	      Aadd(_aDocto,{Subs(TA0->TA0_CODLEG,1,10),Subs(TA0->TA0_EMENTA,1,40),Subs(TA0->TA0_DOCTO2,1,30),Dtos(TA0->TA0_DTVEN2)})      
	   Endif   
	
	   If TA0->TA0_DTVEN3 <= date() //>= mv_par01 .And. TA0->TA0_DTVENC <= mv_par02
	      Aadd(_aDocto,{Subs(TA0->TA0_CODLEG,1,10),Subs(TA0->TA0_EMENTA,1,40),Subs(TA0->TA0_DOCTO3,1,30),Dtos(TA0->TA0_DTVEN3)})      
	   Endif   
	
	   If TA0->TA0_DTVEN4 <= date() //>= mv_par01 .And. TA0->TA0_DTVENC <= mv_par02
	      Aadd(_aDocto,{Subs(TA0->TA0_CODLEG,1,10),Subs(TA0->TA0_EMENTA,1,40),Subs(TA0->TA0_DOCTO4,1,30),Dtos(TA0->TA0_DTVEN4)})      
	   Endif   
   Endif
   	 	
   TA0->(DbSkip())  
 
Enddo

_aDocto := ASort(_aDocto,,, { |x, y| x[4] < y[4]})  //orderna decrecente por data de vencimento 

Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
For _x:=1 to len(_aDocto)

   If !Empty(_aDocto[_x][4])
   
      If Prow() > 60
         _nPag := _nPag + 1
         Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
      Endif
   
      @ Prow() + 1, 001 Psay _aDocto[_x][1]
      @ Prow()    , 012 Psay _aDocto[_x][2]
      @ Prow()    , 063 Psay _aDocto[_x][3]
      @ ProW()    , 105 Psay Dtoc(StoD(_aDocto[_x][4]))
   Endif   

Next _x
     
Return(nil) 


Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "SGA001"+Space(04)
aRegs   := {}

aadd(aRegs,{cPerg,"01","Codigo inicial   ?","Codigo inicial   ?","Codigo inicial   ?","mv_ch1","C",12,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Codigo Final     ?","Codigo Final     ?","Codigo Final     ?","mv_ch2","C",12,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

cUltPerg := aRegs[Len(aRegs)][2]

If SX1->(!DbSeek(cPerg + cUltPerg))

   SX1->(DbSeek(cPerg))

   While SX1->X1_Grupo == cPerg
      RecLock('SX1')
      SX1->(DbDelete())
      MsUnLock('SX1')
      SX1->(DbSkip())
   End

   For i := 1 To Len(aRegs)
       RecLock("SX1", .T.)

	 For j := 1 to Len(aRegs[i])
	     FieldPut(j, aRegs[i, j])
	 Next
       MsUnlock()

       DbCommit()
   Next
EndIf                   

 

dbSelectArea(_sAlias)

Return
                           

