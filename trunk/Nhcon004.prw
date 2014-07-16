/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHCON004        ³ Marcos R. Roquitski   ³ Data ³ 09/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera uma Nova Conta, com Base na conta Origem IB_CCC.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SigaCon                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NhCon004()

  SetPrvt("cQuery,lEnd")

   lEnd := .F.   
   AjustaSx1()

   Pergunte('CON004',.T.)

   Processa({|| Gerando() },"Criando Arquivo Temporario")

	If MsgBox("Confirme o Processamento !","Criando Nova Conta","YESNO")
		MsAguarde ( {|lEnd| fGravaDb() },"Aguarde", "Gravando Dados", .T.)
	Endif
    DbSelectArea("TMP")
    DbCloseArea()

	
Return(nil)


Static Function Gerando()
LOCAL nTotReg := 0

	cQuery := "SELECT * FROM SIBNH0"
	cQuery := cQuery + " WHERE IB_CCC  = '" + mv_par01 + "'"
   cQuery := cQuery + " AND D_E_L_E_T_ <> '*' "

   //Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"  

Return


Static Function fGravaDb()
Local nReg := 0

   DBSELECTAREA("TMP")
   TMP->(DbGotop())

	While !Eof()

		nReg++
		MsProcTxt(" Processando ..: " + mv_par02 + "/"+Transform(nReg,"999999"))

	   DBSELECTAREA("SIB")
		RecLock("SIB",.T.)
		SIB->IB_FILIAL  := TMP->IB_FILIAL
		SIB->IB_TIPO    := TMP->IB_TIPO
		SIB->IB_ORIGEM  := TMP->IB_ORIGEM
		SIB->IB_SEQUENC := TMP->IB_SEQUENC
		SIB->IB_CREDITO := TMP->IB_CREDITO
		SIB->IB_DEBITO  := TMP->IB_DEBITO
		SIB->IB_CCC     := mv_par02
		SIB->IB_CCD     := TMP->IB_CCD
		SIB->IB_PORC    := TMP->IB_PORC
		SIB->IB_ORIGEMC := mv_par02
		SIB->IB_NUM     := TMP->IB_NUM
		MsUnlock("SIB")
	   DBSELECTAREA("TMP")
		TMP->(DbSkip())
	Enddo

Return(nil)


Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "CON004"
aRegs   := {}

//               G        O    P                     P                     P                     V        T   T  D P G   V  V          D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  F  G
//               R        R    E                     E                     E                     A        I   A  E R S   A  A          E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  3  R
//               U        D    R                     R                     R                     R        P   M  C E C   L  R          F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  |  P
//               P        E    G                     S                     E                     I        O   A  I S |   I  0          0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  |  S
//               O        M    U                     P                     N                     A        |   N  M E |   D  1          1  P  N  1  2  2  P  N  2  3  3  P  N  3  4  4  P  N  4  5  5  P  N  5  |  X
//               |        |    N                     A                     G                     V        |   H  A L |   |  |          |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  G
//               |        |    T                     |                     |                     L        |   O  L | |   |  |          |  1  1  |  |  |  2  2  |  |  |  3  3  |  |  |  4  4  |  |  |  5  5  |  |  |
//               |        |    |                     |                     |                     |        |   |  | | |   |  |          |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
/*
aadd(aRegs,{cPerg,"01","C. Custo Debito  ?","C. Custo Debito  ?","C. Custo Debito  ?","mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SI3",""})
aadd(aRegs,{cPerg,"02","Percentual Atual ?","Percentual Atual ?","Percentual Atual ?","mv_ch2","N",06,2,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","Percentual Novo  ?","Percentual Novo  ?","Percentual Novo  ?","mv_ch3","N",06,2,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","ate Serie        ?","ate Serie        ?","ate Serie        ?","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"05","de Emissao       ?","de Emissao       ?","de Emissao       ?","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"06","ate Emissao      ?","ate Emissao      ?","ate Emissao      ?","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"07","de Fornecedor    ?","de Fornecedor    ?","de Fornecedor    ?","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})        
aadd(aRegs,{cPerg,"08","ate Fornecedor   ?","ate Fornecedor   ?","ate Fornecedor   ?","mv_ch8","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
*/

aadd(aRegs,{cPerg,"01","C. Custo Base    ?","C. Custo Base    ?","C. Custo Base    ?","mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SI3",""})
aadd(aRegs,{cPerg,"02","C. Custo Novo    ?","C. Custo Novo    ?","C. Custo Novo    ?","mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SI3",""})

cUltPerg := aRegs[Len(aRegs)][2]

If SX1->(!DbSeek(cPerg + cUltPerg))

   SX1->(DbSeek(cPerg))

   While SX1->X1_Grupo == cPerg
      RecLock('SX1')
      SX1->(DbDelete())
   	SX1->(DbSkip())
      MsUnLock('SX1')
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
                           

