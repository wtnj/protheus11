/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE184  ºAutor  ³Marcos R Roquitski  º Data ³  17/05/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera arquivo Visa Vale por Lote.                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"                                                                     
#include "topconn.ch" 

User Function Nhgpe184()

SetPrvt("CARQTXT,CCONTA,CDIGIT,NPONTO,X,NLIN")
SetPrvt("NTOT,CNRCOB,NVALOR,CDATVEN,CCODNH,CCODFN")
SetPrvt("nHdl,cLin,cFnl,_cOrigem,lEnd")

lEnd   := .T.

fImpArq()

If !File(_cOrigem)
   MsgBox("Arquivo Lote nao Localizado: " + _cOrigem,"Arquivo Retorno","INFO")
   Return
Endif

If SM0->M0_CODIGO == "FN"	
	cArqTed  := "VISA_FN" + Substr(Dtos(dDataBase),5,4) + ".TXT" // TED
	cCodVisa := "00000144410"   
Else
	cArqTed  := "VISA_NH" + Substr(Dtos(dDataBase),5,4) + ".TXT" // TED
	cCodVisa := "00000061410"   
Endif	

// Arquivo a ser trabalhado
_aStruct:={{ "LINHA","C",20,0} }

_cTr1 := CriaTrab(_aStruct,.t.)
USE &_cTr1 Alias TRB0 New Exclusive
Append From (_cOrigem) SDF

cFnl    := CHR(13)+CHR(10)
nHdl    := fCreate(cArqTed)
lEnd    := .F.

MsAguarde ( {|lEnd| fArqVisa() },"Aguarde","Gerando arquivo...",.T.)

DbSelectArea("TRB0")
DbCloseArea("TRB0")

Return


// Layout Visa Vale.
Static Function fArqVisa()
Local nSega := 3
Local _nTotsa := 0
Local nReg5 := 0
Local nValor := 0
Local nTotVlr := 0
Local _nVlrVale := 0

	nlin := 0
	
	** Header
	cLin := "0"
	cLin := cLin + Substr(Dtos(dDataBase),7,2)+Substr(Dtos(dDataBase),5,2)+Substr(Dtos(dDataBase),1,4)
	cLin := cLin + "A001"
	cLin := cLin + Substr(SM0->M0_NOMECOM,1,35)
	cLin := cLin + Substr(SM0->M0_CGC,1,14)
	cLin := cLin + "00000000000"
	cLin := cLin + cCodVisa // Numero do contrato
	cLin := cLin + "000000" // Numero do pedido do cliente	
	cLin := cLin + "07052010"
	cLin := cLin + "1"		
	cLin := cLin + "1"		
	cLin := cLin + Substr(Dtos(dDataBase),5,2)+Substr(Dtos(dDataBase),1,4)
	cLin := cLin + Space(18)
	cLin := cLin + "007"		
	cLin := cLin + Space(267)			
	cLin := cLin + "000001"

	cLin := cLin + cFnl
	fWrite(nHdl,cLin,Len(cLin))


	** REGISTRO FILIAL OU POSTO DE PESSOA JURIDICA
	cLin := "1"
	cLin := cLin + Substr(SM0->M0_CGC,1,14)
	cLin := cLin + "0000000000"
	cLin := cLin + Substr(SM0->M0_NOMECOM,1,35)
	cLin := cLin + "0041"
	
	// Primeiro interlocutor
	cLin := cLin + "MARCIO LIZEIKO                     " 
	cLin := cLin + "RUA WIEGANO OLSEN, 1000                 "
	cLin := cLin + "000033411236"
	cLin := cLin + "001236"
	
	 // Segundo interlocutor	
	cLin := cLin + Space(35)
	cLin := cLin + Space(40)
	cLin := cLin + "000000000000"
	cLin := cLin + "000000"    
	
	 // Terceiro interlocutor
	cLin := cLin + Space(35)
	cLin := cLin + Space(40)
	cLin := cLin + "000000000000"
	cLin := cLin + "000000"    

	cLin := cLin + Space(20)
	cLin := cLin + Space(31) // Brancos
	cLin := cLin + "000002" // Sequencial

	cLin := cLin + cFnl 
	fWrite(nHdl,cLin,Len(cLin)) 


DbselectArea("TRB0")
TRB0->(DbGotop())
While !TRB0->(Eof())

	SRA->(DbSeek(xFilial("SRA")+Substr(TRB0->LINHA,1,6)))
	If SRA->(Found())

		_nVlrVale := Val(Substr(TRB0->LINHA,7,20))

		** REGISTRO DE USUARIOS (FUNCIONARIOS)
		cLin := "5"
		cLin := cLin + StrZero((_nVlrVale * 100),11)
		cLin := cLin + Space(01)
		cLin := cLin + SRA->RA_MAT + Space(7)
		cLin := cLin + Space(54)
		cLin := cLin + Substr(Dtos(SRA->RA_NASC),7,2)+Substr(Dtos(SRA->RA_NASC),5,2)+Substr(Dtos(SRA->RA_NASC),1,4)
		cLin := cLin + SRA->RA_CIC
		cLin := cLin + "1"
		cLin := cLin + Substr(SRA->RA_RG,1,13)
		cLin := cLin + Space(20)
		cLin := cLin + Space(06)	
		cLin := cLin + StrZero(Val(SRA->RA_PIS),15) // + Space(04)
		cLin := cLin + SRA->RA_SEXO
		cLin := cLin + Space(01) 
		cLin := cLin + SRA->RA_ENDEREC + SRA->RA_COMPLEM
		cLin := cLin + "00000"
		cLin := cLin + STRZERO(VAL(SRA->RA_CEP),8)
		cLin := cLin + SRA->RA_MUNICIP + Space(08)
		cLin := cLin + SRA->RA_BAIRRO + Space(15)
		cLin := cLin + SRA->RA_ESTADO	
		cLin := cLin + Substr(SRA->RA_MAE,1,35)
		cLin := cLin + "R"
		cLin := cLin + "0041"
		cLin := cLin + "33411900"	
		cLin := cLin + "1900"	
		cLin := cLin + "0000"	
		cLin := cLin + "00000000"	
		cLin := cLin + Space(01)
		cLin := cLin + Substr(Dtos(SRA->RA_ADMISSA),7,2)+Substr(Dtos(SRA->RA_ADMISSA),5,2)+Substr(Dtos(SRA->RA_ADMISSA),1,4)
		cLin := cLin + Space(01)

		If Empty(SRA->RA_NOMECMP)
			cLin := cLin + SRA->RA_NOME + Space(10)
		Else
			cLin := cLin + Substr(SRA->RA_NOMECMP,1,40)
		Endif
		cLin := cLin + Space(06)
		cLin := cLin + StrZero(nSega,6) 
	
		nReg5++
		nSega++
	    nTotVlr += _nVlrVale
		cLin := cLin + cFnl 
		fWrite(nHdl,cLin,Len(cLin)) 

    Endif
	TRB0->(DbSkip())

Enddo
cLin := "9"
cLin := cLin + StrZero(nReg5,6) 
cLin := cLin + StrZero((nTotVlr*100),15) 
cLin := cLin + Space(372) 
cLin := cLin + StrZero(nSega,6) 
cLin := cLin + cFnl 
fWrite(nHdl,cLin,Len(cLin)) 

fClose(nHdl) 

Return(nil)


Static Function fImpArq()
_lSai     := .T.
_cOrigem  := Space(50)

@ 010,133 To 180,600 Dialog oDialogos Title "Importacao de Arquivo de Lote"

@ 021,005 Say "Origem" Size  15,8
@ 021,030 Get _cOrigem Size 130,8 When .F. 

@ 021,180 Button    "_Localizar" Size 36,16 Action Origem()
@ 060,070 BmpButton Type 2 Action fFecha()
@ 060,120 BmpButton Type 1 Action fConfArq()

Activate Dialog oDialogos CENTERED

Return(.t.)

Static Function Origem()
	_cTipo :="Arquivo Tipo (*.TXT)       | *.TXT | "
	_cOrigem := cGetFile(_cTipo,,0,,.T.,49)     	 
Return

Static Function fFecha()
	Close(oDialogos)
Return

Static Function fConfArq()
	If Empty(_cOrigem)
		MsgBox("Arquivo para Processamento nao Informado","Atencao","INFO")
	Else
		Close(oDialogos)
	Endif
Return
