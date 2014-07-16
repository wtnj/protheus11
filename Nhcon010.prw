/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCON010  ºAutor  ³Marcos R. Roquitski º Data ³  17/07/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao de arquivo texto, Notas Fiscais de Exportacao.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function Nhcon010()

SetPrvt("CLOTE,CARQTXT,CCARAC,CAGENC,X,CCONTA,CQUERY")
SetPrvt("NTOT,CNRCOB,NVALOR,CDATVEN,_cCfop,_cCgc")  
SetPrvt("nHdl,cLin,cFnl,_Datai,_Dataf,lEnd")

If !Pergunte('CON007',.T.)
   Return(nil)
Endif   

If MsgBox("Confirma geração arquivo?","Notas Fiscais de Exportacao","YESNO")

	DbSelectArea("SF3")
	SF3->(DbSetOrder(1))

	lEnd    := .T.
	cArqTxt := "C:\IPI" + Substr(Dtos(dDataBase),1,4) + ".TXT"
	cFnl    := CHR(13)+CHR(10)
	nHdl    := fCreate(cArqTxt)
	lEnd    := .F.
             
	Processa( {|| Gerando()   },"Criando arquivo temporario")
	MsAguarde ({|lEnd| Processo() },"Aguarde","Gerando arquivo...",.T.)

    DbSelectArea("TMP")
    DbCloseArea()

Endif	

Return


Static Function Processo()

	DbSelectArea("TMP")
	TMP->(DbGotop())
	
	While !TMP->(Eof())

		cLin := Substr(SM0->M0_CGC,1,14)+";"
		cLin += Substr(Dtos(TMP->F3_ENTRADA),1,6)+";"
		cLin += alltrim(TMP->F3_NFISCAL)+";"
		cLin += TMP->F3_SERIE+";"
		cLin += DTOC(TMP->F3_EMISSAO)+";"
		//Substr(Dtos(TMP->F3_EMISSAO),7,2)+"/"+Substr(Dtos(TMP->F3_EMISSAO),5,2)+"/"+Substr(Dtos(TMP->F3_EMISSAO),1,4)
		cLin += Strzero((TMP->F3_VALCONT * 100),14)+";"
	    cLin += cFnl
	    
	    fWrite(nHdl,cLin,Len(cLin))

		TMP->(DbSkip())
	
	Enddo
	
	MsgBox("Arquivo gerado em C:\","Gerado","INFO")
	
	fClose(nHdl)
	
Return(nil)


Static Function Gerando()
	_dDatai := mv_par01
	_dDataf := mv_par02

	cQuery := " SELECT F3.F3_ENTRADA,F3.F3_NFISCAL,F3.F3_SERIE,"
	cQuery += " F3.F3_EMISSAO,F3.F3_VALCONT,F3.F3_CLIEFOR,F3.F3_CFO,F3.F3_LOJA"
	cQuery += " FROM " + RetSqlName( 'SF3' ) + " F3 "
	cQuery += " WHERE F3_FILIAL = '" + xFilial("SF3") +"' "
	cQuery += " AND F3.F3_CFO >= '701' " 
	cQuery += " AND F3.F3_ENTRADA BETWEEN '" + Dtos(_dDatai) + "' AND '" + Dtos(_dDataf) + "'"
	cQuery += " AND F3.D_E_L_E_T_ = ''"

	TCQUERY cQuery NEW ALIAS "TMP"

	TcSetField("TMP","F3_EMISSAO","D")  // Muda a data de string para date
	TcSetField("TMP","F3_ENTRADA","D")  // Muda a data de string para date

Return
