/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE162  ºAutor  ³Marcos R Roquitski  º Data ³  14/06/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio cadastro de funcionarios.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"                                                                     
#include "protheus.ch"

User Function Nhgpe162()

SetPrvt("aRotina,cCadastro,_cCustod,_cCustoa,_cMat,_cNome,_cCustc,_cCuste,_cCuston")
SetPrvt("mStruct,mArqTrab,aFields,aRotina,cDelFunc,cCadastro,cMarca,cCoord,_aGrupo,_cLogin,_cLogin2")
SetPrvt("_dDatade,_dDatate,_cSitu,CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM,_dUltApr,aOrd")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR,TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC,CNORMAL,LPRIMEIRO,CQUERY")

cabec1    := ""
cabec2    := ""
cabec3    := ""
wnrel     := ""
nOrdem    := 0
tamanho   := "G"
limite    := 220
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "** Funcionarios **"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "SRA"
nTipo     := 0
nomeprog  := "NHGPE162"
cPerg     := ""
nPag      := 1
m_pag     := 1
wnrel	  := "NHGPE162"
aOrd 	  := {"Matricula","Centro de Custo","Nome"}

If !Pergunte("GPE105",.T.) 
	Return 
Endif

SetPrint("SRA",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

rptStatus({||Imprime()},"Imprimindo...")

If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


Static Function Imprime()

Local _nFun := 0, _cNumero, _cNmbanco := Space(40)
Local _nVlrTot := 0
Local _cDesccc := Space(25)
Local _cDescfu := Space(25)

DbSelectArea("SRA")
Set Filter to ((SRA->RA_CC >= mv_par01 .AND. SRA->RA_CC <= mv_par02) .AND. (SRA->RA_MAT >= mv_par03 .AND. SRA->RA_MAT <= mv_par04))
SRA->(Dbgotop())	
SRJ->(DbSetOrder(1))
CTT->(DbSetOrder(1))
                        
Cabec1    := "Matr.  Nome                             C\Custo   Descricao                               Admissao       Funcao  Descricao                  Dt. Nasc.      CPF          H/M           R.G"
cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

While !SRA->(eof())

	If Prow() > 60
		nPag := nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif

	If SRA->RA_SITFOLH <> 'D'

		If CTT->(DbSeek(xFilial("CTT")+SRA->RA_CC),Found())
			_cDesccc := CTT->CTT_DESC01
		Endif

		If SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC),Found())
			_cDescfu := SRJ->RJ_DESC
		Endif

		@ Prow() + 1, 000 Psay 	SRA->RA_MAT
		@ Prow()    , 007 Psay 	SRA->RA_NOME
		@ Prow()    , 040 Psay 	SRA->RA_CC
		@ Prow()    , 050 Psay 	_cDesccc

		@ Prow()    , 090 Psay 	SRA->RA_ADMISSA
		@ Prow()    , 105 Psay 	SRA->RA_CODFUNC
		@ Prow()    , 110 Psay 	_cDescfu               
		@ Prow()    , 140 Psay 	SRA->RA_NASC
		@ Prow()    , 155 Psay 	SRA->RA_CIC
		@ Prow()    , 170 Psay 	SRA->RA_CATFUNC
		@ Prow()    , 182 Psay 	SRA->RA_RG
		_nFun++
	Endif
	SRA->(DbSkip())

Enddo
@ Prow() + 1,000 Psay __PrtThinLine()
@ Prow() + 1,000 Psay "Qtde Funcionarios: "+TRANSFORM(_nFun,"99999")
@ Prow() + 1,000 Psay __PrtThinLine()
DbSelectArea("SRA")
Set Filter to
SRA->(Dbgotop())	

Return
