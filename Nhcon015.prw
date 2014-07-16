/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCON015  ºAutor  ³Marcos R. Roquitski º Data ³  17/07/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao de lancamentos contabeis, ALLStrategy.             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function Nhcon015()

SetPrvt("CLOTE,CARQTXT,CCARAC,CAGENC,X,CCONTA,CQUERY")
SetPrvt("NLIN,NTOT,CNRCOB,NVALOR,CDATVEN,_cCfop")  
SetPrvt("nHdl,cLin,cFnl,_Datai,_Dataf,lEnd,_cCgc")


AjustaSx1()

If !Pergunte('CON011',.T.)
   Return(nil)
Endif   


If MsgBox("Confirme geracao arquivo","Arquivo ALLFINANCE","YESNO")

	DbSelectArea("SD1")
	SD1->(DbSetOrder(1))

	lEnd    := .T.
	cArqTxt := "C:\CTB" + Substr(Dtos(dDataBase),1,4) + ".TXT"
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

		If TMP->CT2_DC == '1' // Contas debito
			If Substr(TMP->CT2_DEBITO,1,1) >= '3' .AND. Substr(TMP->CT2_DEBITO,1,1) <= '4'
				cLin := Substr(Dtos(TMP->CT2_DATA),7,2) + Substr(Dtos(TMP->CT2_DATA),5,2) + Substr(Dtos(TMP->CT2_DATA),1,4)+"|" // Data
				If TMP->CT2_DC == '1'
					cLin := cLin + TMP->CT2_CCD + SPACE(21)+"|" // Centro de Custo DEBITO
					cLin := cLin + TMP->CT2_DEBITO + SPACE(10)+"|" // Conta contabil DEBITO
				Elseif TMP->CT2_DC == '2'
					cLin := cLin + TMP->CT2_CCC + SPACE(21)+"|" // Centro de Custo CREDITO
					cLin := cLin + TMP->CT2_CREDIT + SPACE(10)+"|" // Conta contabil CREDITO
				Endif
				cLin := cLin + TMP->CT2_LOTE + TMP->CT2_SBLOTE + TMP->CT2_DOC + TMP->CT2_LINHA + SPACE(02) +"|" // Documento

				If TMP->CT2_DC == '1' 
					cLin := cLin + "D"+"|" //  Natureza DEBITO
				Elseif TMP->CT2_DC == '2'
					cLin := cLin + "C"+"|" // Natureza CREDITO
				Endif
				cLin := cLin + Space(50)+"|"
				cLin := cLin + Str(TMP->CT2_VALOR,12,2)+"|"  // Valor
				cLin := cLin + TMP->CT2_HIST // Historico

				cLin := cLin + cFnl
				fWrite(nHdl,cLin,Len(cLin))
				nlin := nlin+1
			Endif	
		Elseif TMP->CT2_DC == '2' // Contas credito
			If Substr(TMP->CT2_CREDIT,1,1) >= '3' .AND. Substr(TMP->CT2_CREDIT,1,1) <= '4'
				cLin := Substr(Dtos(TMP->CT2_DATA),7,2) + Substr(Dtos(TMP->CT2_DATA),5,2) + Substr(Dtos(TMP->CT2_DATA),1,4) +"|"// Data
				If TMP->CT2_DC == '1'
					cLin := cLin + TMP->CT2_CCD + SPACE(21) +"|" // Centro de Custo DEBITO
					cLin := cLin + TMP->CT2_DEBITO + SPACE(10) +"|" // Conta contabil DEBITO
				Elseif TMP->CT2_DC == '2'
					cLin := cLin + TMP->CT2_CCC + SPACE(21) +"|" // Centro de Custo CREDITO
					cLin := cLin + TMP->CT2_CREDIT + SPACE(10) +"|" // Conta contabil CREDITO
				Endif
				cLin := cLin + TMP->CT2_LOTE + TMP->CT2_SBLOTE + TMP->CT2_DOC + TMP->CT2_LINHA + SPACE(02) +"|" // Documento

				If TMP->CT2_DC == '1' 
					cLin := cLin + "D" + "|" //  Natureza DEBITO
				Elseif TMP->CT2_DC == '2'
					cLin := cLin + "C" + "|" // Natureza CREDITO
				Endif
				cLin := cLin + Space(50) + "|"
				cLin := cLin + Str(TMP->CT2_VALOR,12,2) + "|" // Valor
				cLin := cLin + TMP->CT2_HIST // Historico

				cLin := cLin + cFnl
				fWrite(nHdl,cLin,Len(cLin))
				nlin := nlin+1
			Endif	

		Elseif TMP->CT2_DC == '3' // Contas partida dobrada
			If Substr(TMP->CT2_DEBITO,1,1) $ '3/4' .AND. Substr(TMP->CT2_CREDIT,1,1) $ '3/4'

				cLin := Substr(Dtos(TMP->CT2_DATA),7,2) + Substr(Dtos(TMP->CT2_DATA),5,2) + Substr(Dtos(TMP->CT2_DATA),1,4) + "|"// Data
				cLin := cLin + TMP->CT2_CCC + SPACE(21) + "|"// Centro de Custo CREDITO
				cLin := cLin + TMP->CT2_CREDIT + SPACE(10) +"|"// Conta contabil CREDITO
				cLin := cLin + TMP->CT2_LOTE + TMP->CT2_SBLOTE + TMP->CT2_DOC + TMP->CT2_LINHA + SPACE(02) +"|"// Documento
				cLin := cLin + "C" +"|"// Natureza CREDITO
				cLin := cLin + Space(50) +"|"
				cLin := cLin + Str(TMP->CT2_VALOR,12,2) +"|" // Valor
				cLin := cLin + TMP->CT2_HIST // Historico
				cLin := cLin + cFnl
				fWrite(nHdl,cLin,Len(cLin))
				nlin := nlin+1

				nlin := 0
				cLin := Substr(Dtos(TMP->CT2_DATA),7,2) + Substr(Dtos(TMP->CT2_DATA),5,2) + Substr(Dtos(TMP->CT2_DATA),1,4) +"|"// Data
				cLin := cLin + TMP->CT2_CCD + SPACE(21) +"|"// Centro de Custo DEBITO
				cLin := cLin + TMP->CT2_DEBITO + SPACE(10) +"|"// Conta contabil DEBITO
				cLin := cLin + TMP->CT2_LOTE + TMP->CT2_SBLOTE + TMP->CT2_DOC + TMP->CT2_LINHA + SPACE(02) +"|"// Documento
				cLin := cLin + "D" +"|"//  Natureza DEBITO
				cLin := cLin + Space(50) +"|"
				cLin := cLin + Str(TMP->CT2_VALOR,12,2) +"|" // Valor
				cLin := cLin + TMP->CT2_HIST +"|" // Historico
				cLin := cLin + cFnl
				fWrite(nHdl,cLin,Len(cLin))
				nlin := nlin+1

			Elseif Substr(TMP->CT2_DEBITO,1,1) $ '3/4' .AND. !Substr(TMP->CT2_CREDIT,1,1) $ '3/4'

				cLin := Substr(Dtos(TMP->CT2_DATA),7,2) + Substr(Dtos(TMP->CT2_DATA),5,2) + Substr(Dtos(TMP->CT2_DATA),1,4) +"|"// Data
				cLin := cLin + TMP->CT2_CCD + SPACE(21) +"|"// Centro de Custo DEBITO
				cLin := cLin + TMP->CT2_DEBITO + SPACE(10) +"|"// Conta contabil DEBITO
				cLin := cLin + TMP->CT2_LOTE + TMP->CT2_SBLOTE + TMP->CT2_DOC + TMP->CT2_LINHA + SPACE(02) +"|"// Documento
				cLin := cLin + "D" +"|"//  Natureza DEBITO
				cLin := cLin + Space(50) +"|"
				cLin := cLin + Str(TMP->CT2_VALOR,12,2)  +"|"// Valor
				cLin := cLin + TMP->CT2_HIST // Historico
				cLin := cLin + cFnl
				fWrite(nHdl,cLin,Len(cLin))
				nlin := nlin+1

			Elseif Substr(TMP->CT2_CREDIT,1,1) $ '3/4' .AND. !Substr(TMP->CT2_DEBITO,1,1) $ '3/4'

				cLin := Substr(Dtos(TMP->CT2_DATA),7,2) + Substr(Dtos(TMP->CT2_DATA),5,2) + Substr(Dtos(TMP->CT2_DATA),1,4) +"|"// Data
				cLin := cLin + TMP->CT2_CCC + SPACE(21) +"|"// Centro de Custo CREDITO
				cLin := cLin + TMP->CT2_CREDIT + SPACE(10) +"|"// Conta contabil CREDITO
				cLin := cLin + TMP->CT2_LOTE + TMP->CT2_SBLOTE + TMP->CT2_DOC + TMP->CT2_LINHA + SPACE(02) +"|"// Documento
				cLin := cLin + "C" +"|"// Natureza CREDITO
				cLin := cLin + Space(50) +"|"
				cLin := cLin + Str(TMP->CT2_VALOR,12,2) +"|" // Valor
				cLin := cLin + TMP->CT2_HIST // Historico
				cLin := cLin + cFnl
				fWrite(nHdl,cLin,Len(cLin))
				nlin := nlin+1

			Endif

		Endif
		TMP->(DbSkip())
	Enddo
	fClose(nHdl)
	
Return(nil)


Static Function Gerando()
	_dDatai := mv_par01
	_dDataf := mv_par02

	cQuery  := " SELECT T2.CT2_FILIAL,T2.CT2_DATA,T2.CT2_CCD,T2.CT2_CCC,T2.CT2_DEBITO,T2.CT2_CREDIT,T2.CT2_LOTE,T2.CT2_SBLOTE,T2.CT2_DOC,"
	cQuery  += " T2.CT2_LINHA,T2.CT2_DC,T2.CT2_VALOR,T2.CT2_HIST"
	cQuery  += " FROM " + RetSqlName( 'CT2' ) + " T2 "
    cQuery  += " WHERE T2.CT2_FILIAL = '" + xFilial("CT2")+ "'"	
    cQuery  += " AND T2.CT2_DATA BETWEEN '" + Dtos(_dDatai) + "' AND '" + Dtos(_dDataf) + "' AND T2.D_E_L_E_T_ = ' ' "
	TCQUERY cQuery NEW ALIAS "TMP"  

	TcSetField("TMP","CT2_DATA","D")  // Muda a data de string para date    

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
