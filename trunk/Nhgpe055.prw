/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE055  ºAutor  ³Marcos R. Roquitski º Data ³  06/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera arquivo TXT, para URBS                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function Nhgpe055()

SetPrvt("CLOTE,CARQTXT,CCARAC,CAGENC,X,CCONTA,CQUERY")
SetPrvt("NLIN,NTOT,CNRCOB,NVALOR,CDATVEN,_cCfop,_cCgc")
SetPrvt("nHdl,cLin,cFnl,_Datai,_Dataf,lEnd")

AjustaSX1()
If !Pergunte('GPE055',.T.)
   Return(nil)

Endif


If MsgBox("Confirme geracao arquivo","Arquivo TXT Urbs","YESNO")

	DbSelectArea("SRA")
	SRA->(DbSetOrder(1))

	lEnd    := .T.
	cArqTxt := "URBS" + Substr(Dtos(dDataBase),1,4) + ".TXT"
	cFnl    := CHR(13)+CHR(10)
	nHdl    := fCreate(cArqTxt)
	lEnd    := .F.
             
	Processa( {|| Gerando()   },"Criando arquivo temporario")
	MsAguarde ( {|lEnd| Processo() },"Aguarde","Gerando arquivo...",.T.)

	DbSelectArea("TMP")
    DbCloseArea()

Endif

Return


Static Function Processo()
	DbSelectArea("TMP")
	TMP->(DbGotop())

	While !TMP->(Eof())
		nlin := 0
		cLin := Alltrim(TMP->RA_NOME) + ";"
		cLin := cLin + IIF(Empty(Alltrim(TMP->RA_MAE)),"MARIA",Alltrim(TMP->RA_MAE)) + ";"
		cLin := cLin + Alltrim(TMP->RA_SEXO) + ";"
		cLin := cLin + StrZero(DAY(TMP->RA_NASC),2) + "/" + StrZero(MONTH(TMP->RA_NASC),2)+ "/" + StrZero(YEAR(TMP->RA_NASC),4)
		cLin := cLin + ";"
		cLin := cLin + IIF(Empty(TMP->RA_CIC),"999999",TMP->RA_CIC) + ";"
		cLin := cLin + fLimpa(TMP->RA_RG) + ";"
		cLin := cLin + IIF(Empty(Alltrim(TMP->RA_UFCP)),"PR",TMP->RA_UFCP) + ";"
		cLin := cLin + "(41)3411900;"
		cLin := cLin + TMP->RA_CEP + ";"
		cLin := cLin + alltrim(TMP->RA_ENDEREC) + ";"
		cLin := cLin + StrZero(Val(fLimpa(TMP->RA_ENDEREC)),5) + ";"
		cLin := cLin + Alltrim(TMP->RA_COMPLEM) + ";"
		cLin := cLin + Alltrim(TMP->RA_BAIRRO) + ";"
		cLin := cLin + Alltrim(TMP->RA_MUNICIP) + ";"
		cLin := cLin + Alltrim(TMP->RA_ESTADO) + ";"
		cLin := cLin + '8' + ";"
		cLin := cLin + Alltrim(TMP->RA_EMAIL)
		cLin := cLin + cFnl
		fWrite(nHdl,cLin,Len(cLin))
		nlin := nlin+1

		TMP->(DbSkip())
	
	Enddo
	fClose(nHdl)
	
Return(nil)


Static Function Gerando()
	cQuery  := " SELECT *  FROM SRANH0"
	cQuery  := cQuery + " WHERE RA_SITFOLH <> 'D'"
	cQuery  := cQuery + "AND RA_MAT BETWEEN '" + Mv_par01 + "' AND '" + Mv_par02 + "' "
	TCQUERY cQuery NEW ALIAS "TMP"
	TcSetField("TMP","RA_NASC","D")  // Muda a data de string para date
Return

Static Function fLimpa(_cVar)
Local i:=1,_cRetVar := ""
	For i := 1 To Len(Alltrim(_cVar))
		If Entre("0","9",Substr(_cVar,i,1))
			_cRetVar += Substr(_cVar,i,1)
		Endif
	Next
Return(Alltrim(_cRetVar)) 



Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "GPE055"
aRegs   := {}

aadd(aRegs,{cPerg,"01","Matricula de     ?","Matricula de     ?","Matricula de     ?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aadd(aRegs,{cPerg,"02","Matricula Ate    ?","Matricula Ate    ?","Matricula Ate    ?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})

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
