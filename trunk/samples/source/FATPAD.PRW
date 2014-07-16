/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FatPad   ³ Autor ³ Joao  Alberto         ³ Data ³ 31/03/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria o arq de Faturamento e Pedido Padrao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RDMake Interpretado                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER FUNCTION FATPAD

cPerg := "JE010"
ValidPerg()
Pergunte(cPerg,.T.)

If mv_par01 < 1
    mv_par01 := 1
Endif
If mv_par01 > 12
    mv_par01 := 12
Endif
If mv_par02 < 1
    mv_par02 := 1
Endif
dData := CTOD('01/'+STRZERO(mv_par01,2)+'/'+Substr(STRZERO(Year(dDataBase),4),3,2))
dDataAux := dData + 30
While Month(dData) != Month(dDataAux)
    dDataAux := dDataAux - 1
EndDo
nDiaMax := Day(dDataAux)

If mv_par02 > nDiaMax
    mv_par02 := nDiaMax
Endif
If mv_par02 < 1
    mv_par02 := 1
Endif

dbcreate("FATPED",{{"Grupo","C",4,0},{"Data","C",8,0},{"Clientes","C",6,0},{"FatVal","N",14,2},{"FatQtd","N",14,0},{"PedVal","N",14,2},{"PedQtd","N",14,0}})
Use FATPED Alias FP Exclusive New
cIndexSD2 := CriaTrab(nil,.f.)
DbSelectArea("SD2")
dIndexSD2 :="D2_Grupo+D2_Cliente"
IndRegua("SD2",cIndexSD2,dIndexSD2,,'Month(D2_Emissao)== '+StrZero(mv_par01,2,0),"Selecionando faturamento..." )
nIndexSD2 := RetIndex("SD2")
dbSetIndex(cIndexSD2+OrdBgExt())
dbSetOrder(nIndexSD2+1)
SetRegua(RecCount())
 
DBGoTop()

aCampos:={}
aQ:={}
aV:={}
aPQ:={}
aPV:={}

* cria no array um grupo 9999 para cada cliente
DBSelectArea("SX5")
DBSeek(xFilial()+"91",.t.)
Do While .not. eof() .and. X5_tabela=="91"
   AADD(aCampos,"9999"+substr(X5_chave,1,6)+"01")
   AADD(aQ,0)
   AADD(aV,0)
   AADD(aPQ,0)
   AADD(aPV,0)

   AADD(aCampos,"9999"+substr(X5_chave,1,6)+strzero(mv_par02,2))
   AADD(aQ,0)
   AADD(aV,0)
   AADD(aPQ,0)
   AADD(aPV,0)

   DBSkip()
Enddo

* cria no array um Cliente 999999 para cada grupo
DBSelectArea("SX5")
DBSeek(xFilial()+"90",.t.)
Do While .not. eof() .and. X5_tabela=="90"
   AADD(aCampos,substr(X5_chave,1,4)+"999999"+"01")
   AADD(aQ,0)
   AADD(aV,0)
   AADD(aPQ,0)
   AADD(aPV,0)
   AADD(aCampos,substr(X5_chave,1,4)+"999999"+StrZero(mv_par02,2))
   AADD(aQ,0)
   AADD(aV,0)
   AADD(aPQ,0)
   AADD(aPV,0)

   DBSkip()
Enddo
AADD(aCampos,"999999999901")
AADD(aQ,0)
AADD(aV,0)
AADD(aPQ,0)
AADD(aPV,0)

AADD(aCampos,"9999999999"+strzero(mv_par02,2))
AADD(aQ,0)
AADD(aV,0)
AADD(aPQ,0)
AADD(aPV,0)

DBSelectArea("SD2")
Do While .not. eof()

 DBSelectArea("SD2")
 Grupant := D2_Grupo
 Cliant  := D2_Cliente
 FatVal01:=0
 FatQtd01:=0
 FatValhj:=0
 FatQtdhj:=0

 Do While .not. eof() .and. D2_Grupo == Grupant .and. D2_Cliente == Cliant

* Verifica se a Nota gera duplicata

   DbSelectArea("SF4")
   DbSeek(xFilial()+SD2->D2_Tes)
   If eof() .or. F4_Duplic # "S"
     DbSelectArea("SD2")
     Dbskip()
     Loop
   EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Alterado Por Luiz Carlos Vieira                                          ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   DbSelectArea("SD2")

   If day(D2_Emissao) == mv_par02
      If SD2->D2_TIPO!="D" // Devolucao
          FatValhj := FatValhj + D2_Total
          FatQtdhj := FatQtdhj + D2_Quant
      Else
          FatValhj := FatValhj - D2_Total
          FatQtdhj := FatQtdhj - D2_Quant
      Endif
   else 
      If SD2->D2_TIPO!="D"
          FatVal01 := FatVal01 + D2_Total
          FatQtd01 := FatQtd01 + D2_Quant
      Else
          FatVal01 := FatVal01 - D2_Total
          FatQtd01 := FatQtd01 - D2_Quant
      Endif
   Endif
   DbSkip()

 Enddo

* verifica se grupo ou cliente est  no SX5
 DbSelectArea("SX5")
 DbSeek(xFilial()+"90"+Grupant,.F.)
 If eof()
   Grupant:='9999'
 Endif
 DbSeek(xFilial()+"91"+Cliant,.F.)
 If eof()
   Cliant := '999999'
 Endif

* soma no array
If FatVal01 # 0
 n := Ascan(aCampos,Grupant+Cliant+'01')
 If n==0
    AADD(aCampos,Grupant+Cliant+'01')
    AADD(aQ,FatQtd01)
    AADD(aV,FatVal01)
    AADD(aPQ,0)
    AADD(aPV,0)
 else
    aQ[n] := aQ[n] + FatQtd01
    aV[n] := aV[n] + FatVal01
 endif
Endif
If FatValhj # 0
 n := Ascan(aCampos,Grupant+Cliant+strzero(mv_par02,2))
 If n==0
    AADD(aCampos,Grupant+Cliant+strzero(mv_par02,2))
    AADD(aQ,FatQtdhj)
    AADD(aV,FatValhj)
    AADD(aPQ,0)
    AADD(aPV,0)
 else
    aQ[n] := aQ[n] + FatQtdhj
    aV[n] := aV[n] + FatValhj
 endif
Endif

DBSelectArea("SD2")
Enddo

dbSelectArea("SD2")
Set Filter To
RetIndex("SD2")
Ferase(cIndexSD2+".NTX")


* VAI TRATAR OS PEDIDOS

DbSelectArea("SC6")
cIndexSC6 := CriaTrab(nil,.f.)
IndRegua("SC6",cIndexSC6,"C6_Produto+C6_Cli",,'month(C6_Entreg)== '+StrZero(mv_par01,2,0),"Selecionando Pedidos..." )
nIndexSC6 := RetIndex("SC6")
dbSetIndex(cIndexSC6+OrdBagExt())
dbSetOrder(nIndexSC6+1)
SetRegua(RecCount())
DbSelectArea("SC6") 
DBGoTop()

Do While .not. eof()
 DBSelectArea("SB1")
 DBSeek(xFilial() + SC6->C6_PRODUTO,.f.)
 Grupo:="    "
 If .not. eof()
    grupo:=B1_grupo
 endif

 DBSelectArea("SC6")
 Grupant := Grupo
 Cliant  := C6_Cli
 PedVal01:=0
 PedQtd01:=0
 PedValhj:=0
 PedQtdhj:=0

 Do While .not. eof() .and. Grupo == Grupant .and. C6_Cli == Cliant

     DBSelectArea("SF4")
     DBSeek(xFilial() + SC6->C6_TES,.f.)
     If eof() .or. F4_Duplic # "S"
       DbSelectArea("SC6")
       Dbskip()
       Loop
     EndIf

     DBSelectArea("SC6")
     Valor:=C6_Valor    // TES isento

     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Alterado por Luiz Carlos Vieira                                          ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

     dbSelectArea("SC5")
     dbSetOrder(1)
     dbSeek(xFilial("SC5")+SC6->C6_NUM)
     dbSelectArea("SC6")

     DIA:=day(C6_ENTREG)
     If dia == mv_par02
       If SC5->C5_TIPO!="D"
           PedValhj := PedValhj + Valor
           PedQtdhj := PedQtdhj + C6_QTDVEN
       Else
           PedValhj := PedValhj - Valor
           PedQtdhj := PedQtdhj - C6_QTDVEN
       Endif
     else 
       If SC5->C5_TIPO!="D"
           PedVal01 := PedVal01 + Valor
           PedQtd01 := PedQtd01 + C6_QTDVEN
       Else
           PedVal01 := PedVal01 - Valor
           PedQtd01 := PedQtd01 - C6_QTDVEN
       Endif
     Endif

     DbSkip()
     DBSelectArea("SB1")
     DBSeek(xFilial() + SC6->C6_PRODUTO,.f.)
     Grupo:="    "
     If .not. eof()
       grupo:=B1_Grupo

     endif
   DBSelectArea("SC6")
 Enddo

 * QUEBRA
 DbSelectArea("SX5")
 DbSeek(xFilial()+"90"+Grupant,.F.)
 If eof()
   Grupant:='9999'
 Endif
 DbSeek(xFilial()+"91"+Cliant,.F.)
 If eof()
   Cliant := '999999'
 Endif

* soma no array
If PedVal01 # 0
 n := Ascan(aCampos,Grupant+Cliant+'01')
 If n==0
    AADD(aCampos,Grupant+Cliant+'01')
    AADD(aQ,0)
    AADD(aV,0)
    AADD(aPQ,PedQtd01)
    AADD(aPV,PedVal01)
 else
    aPQ[n] := aPQ[n] + PedQtd01
    aPV[n] := aPV[n] + PedVal01
 Endif
Endif

If PedValhj # 0
 n := Ascan(aCampos,Grupant+Cliant+strzero(mv_par02,2))
 If n==0
    AADD(aCampos,Grupant+Cliant+strzero(mv_par02,2))
    AADD(aQ,0)
    AADD(aV,0)
    AADD(aPQ,PedQtdhj)
    AADD(aPV,PedValhj)
 else
    aPQ[n] := aPQ[n] + PedQtdhj
    aPV[n] := aPV[n] + PedValhj
 Endif
Endif
DBSelectArea("SC6")
Enddo

AADD(aCampos,"   ")

* grava‡Æo do arquivo EstPed
DBSelectArea("FP")
i := 1
j := 0
Do while ! empty(substr(aCampos[i],1,4))
   If aV[i]==0 .and. aQ[i]==0 .and. aPV[i]==0 .and. aPQ[i]==0
      i:= i+1
      loop
   Endif
   RecLock("FP",.T.)
   FieldPut(FieldPos("Grupo"),substr(aCampos[i],1,4))
   FieldPut(FieldPos("Clientes"),substr(aCampos[i],5,6))
   FieldPut(FieldPos("DATA"),substr(aCampos[i],11,2)+"/"+strzero(mv_par01,2)+"/97")
   FieldPut(FieldPos("FatVal"),aV[i])
   FieldPut(FieldPos("FatQtd"),aQ[i])
   FieldPut(FieldPos("PedVal"),aPV[i])
   FieldPut(FieldPos("PedQtd"),aPQ[i])
   i:=i+1
   j:=j+1
Enddo

dbSelectArea("SC6")
Set Filter To
RetIndex("SC6")
Ferase(cIndexSC6+".NTX")
 
dbSelectArea("FP")
dbCloseArea()

MsgBox("Finalizou OK"+str(j,4),"Mensagem","Info")
*@ 20,10 say "Finalizou OK"+str(j,4)

return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³VALIDPERG ³ Autor ³  Luiz Carlos Vieira	³ Data ³ 03/07/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas incluindo-as caso nao existam		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Especifico - Figrot.prx									  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValidPerg()
Local j,i
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)
aRegs:={}
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Do Mes             ?","mv_ch1","N",2,0,0,"G","","mv_par01","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Do Dia             ?","mv_ch2","N",2,0,0,"G","","mv_par02","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
        dbCommit()
	Endif
Next

dbSelectArea(_sAlias)

Return


