/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHMDT003  บAutor  ณMicrosiga           บ Data ณ  06/01/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Laudos e Locais.                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NhMdt003()

SetPrvt("NQTDE1,NQTDE2,NQTDE3,nEtq")

cString   := "TO5"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir ")
cDesc2    := OemToAnsi("Laudos e Riscos")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMDT003"
aLinha    := { }
nLastKey  := 0
titulo    := "Relatorio Laudos e Locais"
Cabec1    := "Laudo          Cod.   Descricao do Ambiente                             Cod. Descricao Da Funcao                        Descricao                                                         Qtde     Unidade"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1  
wnrel     := "NHMDT003"
_cPerg    := "" 

AjustaSx1()

If !Pergunte('MDT003',.T.)
    Return(nil)
Endif

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho)

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

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")

DbSelectArea("TMP")
DbCloseArea()


Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


Static Function Gerando()
	cQuery :="SELECT * "
   cQuery += " FROM TO5NH0 "
   cQuery += " WHERE D_E_L_E_T_ <> '*' "
   cQuery += " AND TO5_FILIAL = '" + xFilial("TO5")+ "'"
   cQuery += " AND TO5_LAUDO BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
   cQuery += " AND TO5_CODFUN BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
   cQuery += " AND TO5_CODAMB BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"
   cQuery += " ORDER BY TO5_LAUDO, TO5_CODFUN, TO5_CODAMB ASC"
 
	TCQUERY cQuery NEW ALIAS "TMP"  
  
Return                                   


Static Function RptDetail()

NQTDE1 := 0
NQTDE2 := 0
NQTDE3 := 0 
nEtq   := 0
       

DBSELECTAREA("TMP")

TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))

Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
While TMP->(!Eof())

   If Prow() > 60
      _nPag := _nPag + 1
      Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
   Endif
   @ Prow() + 1, 000 Psay TMP->TO5_LAUDO
   @ Prow()    , 015 Psay TMP->TO5_CODAMB
	If EXISTCPO("TNE",TMP->TO5_CODAMB)
   	@ Prow()    , 022 Psay TNE->TNE_NOME
	Endif
   @ Prow()    , 072 Psay TMP->TO5_CODFUN
	If EXISTCPO("SRJ",TMP->TO5_CODFUN)
   	@ Prow()    , 077 Psay SRJ->RJ_DESC
	Endif   	
   @ Prow()    , 120 Psay TMP->TO5_DESCRI
   @ Prow()    , 180 Psay TMP->TO5_QTD1    Picture "@E 999,999.99"
   @ Prow()    , 195 Psay TMP->TO5_UNIME1
	_cLaudo := TMP->TO5_LAUDO
	TMP->(DbSkip())  

	If TMP->TO5_LAUDO <> _cLaudo
	   @ Prow() + 1, 000 Psay Replicate("-",limite)
	Endif

Enddo

// IMPRIME

@ Prow() +2 , 060 Psay " "
    
Return(nil) 


Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "MDT003"
aRegs   := {}

aadd(aRegs,{cPerg,"01","Do Laudo         ?","Do Laudo         ?","Do Laudo         ?","mv_ch1","C",12,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","TO0",""})
aadd(aRegs,{cPerg,"02","At้ Laudo        ?","at้ Laudo        ?","at้ laudo        ?","mv_ch2","C",12,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","TO0",""})
aadd(aRegs,{cPerg,"03","Da Funcao        ?","Da Funcao        ?","Da Funcao        ?","mv_ch3","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRJ",""})
aadd(aRegs,{cPerg,"04","Ate Funcao       ?","Ate Funcao       ?","Ate Funcao       ?","mv_ch4","C",04,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRJ",""})
aadd(aRegs,{cPerg,"05","Do Ambiente      ?","Do Ambiente      ?","Do Ambiente      ?","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","TNE",""})
aadd(aRegs,{cPerg,"06","At้ Ambiente     ?","At้ Ambiente     ?","At้ Ambiente     ?","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","TNE",""})
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

