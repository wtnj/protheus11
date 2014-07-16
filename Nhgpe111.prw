/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE111  ºAutor  ³Marcos R. Roquitski º Data ³  21/10/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera arquivo TXT Vale mercado, para CONDOR SUPER CENTER.   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function Nhgpe111()

SetPrvt("CLOTE,CARQTXT,CCARAC,CAGENC,X,CCONTA,CQUERY")
SetPrvt("NLIN,NTOT,CNRCOB,NVALOR,CDATVEN,_cCfop,_cCgc")
SetPrvt("nHdl,cLin,cFnl,_Datai,_Dataf,lEnd")
SetPrvt("_cArquivo,_aStruct,_cTr1,lEnd")

If !Pergunte('GPE055',.T.)
   Return(nil)

Endif


If MsgBox("Confirme geracao arquivo","Vale mercado","YESNO")


	If SM0->M0_CODIGO == 'NH'
		_cArquivo := "NHCONDOR.TXT"
	Elseif SM0->M0_CODIGO == 'FN'
		_cArquivo := "FNCONDOR.TXT"	
	Endif		
	lEnd      := .T.

	If !File(_cArquivo)
	   MsgBox("Arquivo de Entrada nao Localizado: " + _cArquivo,"Arquivo Retorno","INFO")
  	 Return
	Endif

	// Arquivo a ser trabalhado
	_aStruct:={{ "MATR","C",06,0},;
  	         { "FALTAS","N",02,0}}

	_cTr1 := CriaTrab(_aStruct,.t.)
	USE &_cTr1 Alias TRB New Exclusive
	Append From (_cArquivo) SDF


	DbSelectArea("SRA")
	SRA->(DbSetOrder(1))

	lEnd    := .T.
	cArqTxt := "V"+SM0->M0_CODIGO+Substr(Dtos(dDataBase),3,4) + ".txt"
	cFnl    := CHR(13)+CHR(10)
	nHdl    := fCreate(cArqTxt)
	lEnd    := .F.
             
	Processa( {|| Gerando()   },"Criando arquivo temporario")
	MsAguarde ( {|lEnd| ProcSrc() },"Aguarde","Gerando arquivo...",.T.)

	DbSelectArea("TMP")
  DbCloseArea()


	DbSelectArea("TRB")
	DbCloseArea()
	
	Ferase(_cTr1)

Endif

Return

// Processa SRC
Static Function ProcSrc()
Local lVlr := .T.

	SRD->(DbsetOrder(1))	
	DbSelectArea("TMP")
	TMP->(DbGotop())
	nlin := 0
	While !TMP->(Eof())

		SRC->(DbSeek(xFilial("SRC")+TMP->RA_MAT+"457"))
		If SRC->(Found())

			cLin := Strzero(VAL(TMP->RA_MAT),15)
			cLin := cLin + TMP->RA_NOME + Space(15)
			cLin := cLin + StrZero(Val(TMP->RA_CIC),15) 

			DbSelectArea("TRB")
			TRB->(DbgoTop())
			While !TRB->(Eof())
				If SRC->RC_MAT == TRB->MATR
					cLin := cLin + "00000007800"
					lVlr := .F.
				Endif
				TRB->(Dbskip())
			Enddo	

			If lVlr
				cLin := cLin + "00000011100"
			Endif
			lVlr := .T.

			cLin := cLin + cFnl
			fWrite(nHdl,cLin,Len(cLin))
			nlin := nlin+1
	
		Endif	
		TMP->(DbSkip())
	
	Enddo
	cLin := "999999999999999"
	cLin := cLin + Strzero(nLin,15)
	cLin := cLin + cFnl
	fWrite(nHdl,cLin,Len(cLin))
	fClose(nHdl)
	
Return(nil)

Static Function Gerando()
	cQuery  := "SELECT * FROM " + RetSqlName( 'SRA' ) + " RA " 
	cQuery  := cQuery + " WHERE RA.RA_SITFOLH <> 'D'"
	cQuery  := cQuery + "AND RA.RA_MAT BETWEEN '" + Mv_par01 + "' AND '" + Mv_par02 + "' "
	TCQUERY cQuery NEW ALIAS "TMP"
Return
