/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCON011  ºAutor  ³Marcos R. Roquitski º Data ³  17/07/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao de arquivo texto, IPI destacado.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function Nhcon011()

SetPrvt("CLOTE,CARQTXT,CCARAC,CAGENC,X,CCONTA,CQUERY")
SetPrvt("NLIN,NTOT,CNRCOB,NVALOR,CDATVEN,_cCfop")  
SetPrvt("nHdl,cLin,cFnl,_Datai,_Dataf,lEnd,_cCgc")


If !Pergunte('CON011',.T.)
   Return(nil)
Endif   


If MsgBox("Confirme geracao arquivo","Arquivo de IPI","YESNO")

	DbSelectArea("SD1")
	SD1->(DbSetOrder(1))

	lEnd    := .T.
	cArqTxt := "C:\IPI\IPI" + Substr(Dtos(dDataBase),1,4) + ".TXT"
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

		_cCfop := Space(04)
		SD1->(DbSeek(xFilial("SD1") + TMP->F1_DOC + TMP->F1_SERIE + TMP->F1_FORNECE + TMP->F1_LOJA))
		If SD1->(Found())
			_cCfop := SD1->D1_CF
		Endif			

		_cCgc := space(14)
		SA2->(DbSeek(xFilial("SA2") + TMP->F1_FORNECE + TMP->F1_LOJA))
		If SA2->(Found())
			_cCgc := SA2->A2_CGC
		Endif

		nlin := 0
		cLin := 'R13' // Tipo
		cLin := cLin + SM0->M0_CGC // CNPJ do declarante
		cLin := cLin + Space(14) // CNPJ da Sucedida
		cLin := cLin + SM0->M0_CGC // CNPJ do Estabelecimento detentor do credito		
		cLin := cLin + Substr(_cCgc,1,14) // CNPJ do Emitente
		cLin := cLin + RIGHT(alltrim(TMP->F1_DOC),9) // Numero da Nota Fiscal
		cLin := cLin + TMP->F1_SERIE // Serie da Nota Fiscal
		cLin := cLin + Substr(Dtos(TMP->F1_EMISSAO),7,2) + Substr(Dtos(TMP->F1_EMISSAO),5,2) + Substr(Dtos(TMP->F1_EMISSAO),1,4)
		cLin := cLin + Substr(Dtos(TMP->F1_DTDIGIT),7,2) + Substr(Dtos(TMP->F1_DTDIGIT),5,2) + Substr(Dtos(TMP->F1_DTDIGIT),1,4)
		cLin := cLin + Substr(_cCfop,1,4)
		cLin := cLin + Strzero((TMP->F1_VALBRUT * 100),14)
		cLin := cLin + Strzero((TMP->F1_VALIPI * 100),14)		
		cLin := cLin + Strzero((TMP->F1_VALIPI * 100),14)				
  	    cLin := cLin + cFnl
	   fWrite(nHdl,cLin,Len(cLin))
	   nlin := nlin+1
	   TMP->(DbSkip())
	End
   fClose(nHdl)   
   
   alert('Arquivo gerado em: ' +cArqTxt)
	
Return(nil)


Static Function Gerando()
	_dDatai := mv_par01
	_dDataf := mv_par02

	cQuery  := " SELECT F1.F1_DOC,F1.F1_SERIE,F1.F1_EMISSAO,F1.F1_DTDIGIT,F1.F1_VALBRUT,F1.F1_VALIPI,F1.F1_FORNECE,F1.F1_LOJA"
	cQuery  += " FROM " + RetSqlName( 'SF1' ) + " F1 "
    cQuery  += " WHERE F1.F1_FILIAL = '" + xFilial("SF1")+ "'"	
	cQuery  += " AND F1.F1_VALIPI > 0 "
    cQuery  += " AND F1.F1_DTDIGIT BETWEEN '" + Dtos(_dDatai) + "' AND '" + Dtos(_dDataf) + "' AND F1.D_E_L_E_T_ <> '*' "
	TCQUERY cQuery NEW ALIAS "TMP"  

	TcSetField("TMP","F1_EMISSAO","D")  // Muda a data de string para date    
	TcSetField("TMP","F1_DTDIGIT","D")  // Muda a data de string para date    


Return                                   


Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "CON011"
aRegs   := {}

aadd(aRegs,{cPerg,"01","Dt. Inicial      ?","Dt. Inicial      ?","Dt. Inicial      ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"01","Dt. Final        ?","Dt. Final        ?","Dt. Final        ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
 