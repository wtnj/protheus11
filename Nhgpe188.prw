/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE188  ºAutor  ³Marcos R Roquitski  º Data ³  05/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Estabilidade.                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³AP                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#Include 'Protheus.ch'
#Include 'dbTree.ch'

User Function Nhgpe188()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave,nTipo,aReturn,NOMEPROG,ALINHA,NLASTKEY,LEND")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,CCOMPAC,CNORMAL,CQUERY,TITULO,CABEC1")                                       	
SetPrvt("dDataRef,cFilDe,cFilAte,cCcDe,cCcAte,cMatDe,cMatAte,cNomeDe,cNomeAte,nAnaSin,nGerRes,lImpNiv,cCateg")

cString   := "SRD"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir")
cDesc2    := OemToAnsi("Funcionarios com estabilidade")
cDesc3    := OemToAnsi("")
tamanho   := "M"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHGPE188"
aLinha    := {}
nLastKey  := 0
nQtde     := 0
lEnd      := .F.
lDivPed   := .F.
titulo    := "E S T A B I L I D A D E"
Cabec1    := " Matr.  Nome                                        Admissao                                        Estabilidade Até"              
Cabec2    := ""
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13
Cabec3    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHGPE188"
cPerg     := "NHGPE188"

If !Pergunte("NHGPE188",.T.)
	Return 
Endif

SetPrint("SRA",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")
If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
    Set Filter To
    Return
Endif

// inicio do processamento do relatório
Processa( {|| RptTmp() },"Imprimindo...") 
    
Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool


Return


Static Function RptTmp()
Local doData := doDatai := doDataf := Ctod(Space(08)), coTipo := space(01)
Local dfData := dfDatai := dfDataf := Ctod(Space(08)), cfTipo := space(01)
Local _nAno  := 0
Local _nDias := 30
                 
TNO->(DbSetOrder(2))

Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

If SRA->(DbSeek(xFilial("SRA") + MV_PAR01))

	If Prow() > 64
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
	Endif
	_nAno := Year(dDataBase) - Year(SRA->RA_ADMISSA)

	If _nAno == 2
		_nDias := 35

	Elseif _nAno == 3
		_nDias := 40		

	Elseif _nAno == 4
		_nDias := 45		

	Elseif _nAno == 5
		_nDias := 50		

	Elseif _nAno == 6
		_nDias := 55

	Elseif _nAno >= 7
		_nDias := 60
	
	Endif

	@ Prow() +1, 001 Psay SRA->RA_MAT
	@ Prow()   , 008 Psay SRA->RA_NOME
	@ Prow()   , 052 Psay SRA->RA_ADMISSA

	// Afastamentos	
	If SR8->(DbSeek(xFilial("SR8") + SRA->RA_MAT))	
		@ Prow() +1, 000 PSAY __PrtThinLine() 
		@ Prow() +1, 001 Psay "Afastamento"
		@ Prow() +1, 001 Psay "==========="

		@ Prow() +1, 001 Psay "Dt.Inicio"
		@ Prow()   , 012 Psay "Dt.Final"
		@ Prow()   , 040 Psay "Tipo"    

	
		While !SR8->(Eof()) .AND. SR8->R8_MAT == SRA->RA_MAT
			If SR8->R8_TIPO == 'O'
				doData  := SR8->R8_DATA
				doDatai := SR8->R8_DATAINI
				doDataf := SR8->R8_DATAFIM 
				coTipo  := SR8->R8_TIPO
			Elseif SR8->R8_TIPO == 'F'
				dfData  := SR8->R8_DATA 
				dfDatai := SR8->R8_DATAINI 
				dfDataf := SR8->R8_DATAFIM 
				cfTipo  := SR8->R8_TIPO 
			Endif
			
			SR8->(DbSkip())			
		Enddo

		If !Empty(doDatai)
			@ Prow() +1, 001 Psay doDatai
			@ Prow()   , 012 Psay doDataf
			@ Prow()   , 040 Psay coTipo 
			@ Prow()   , 045 Psay "Afastamento Temporario por Acidente de trabalho"
		
			If (doDataf - doDatai) > 15
				@ Prow()   , 100 Psay (doDataf + 365)
			Endif	
		Endif	

		If !Empty(dfDatai)		
			@ Prow() +1, 001 Psay dfDatai
			@ Prow()   , 012 Psay dfDataf
			@ Prow()   , 040 Psay cfTipo
			@ Prow()   , 045 Psay "Ferias"
			@ Prow()   , 100 Psay (dfDataf + _nDias)
		Endif
	Endif
	
	TNQ->(DbSetOrder(2))
	// CIPA
	If TNQ->(DbSeek(xFilial("TNQ") + SRA->RA_MAT))	
		@ Prow() +2, 000 PSAY __PrtThinLine() 
		@ Prow() +1, 001 Psay "Mandato Cipa"
		@ Prow() +1, 001 Psay "============"

		@ Prow() +1, 001 Psay "Inicio"
		@ Prow()   , 012 Psay "Final"
		@ Prow()   , 024 Psay "Indicacao"
		@ Prow()   , 040 Psay "Descricao"

		While !TNQ->(Eof()) .AND. TNQ->TNQ_MAT == SRA->RA_MAT
			If TNN->(DbSeek(xFilial("TNN") + TNQ->TNQ_MANDAT))	
				@ Prow() +1, 001 Psay TNN->TNN_DTINIC
				@ Prow()   , 012 Psay TNN->TNN_DTTERM
				@ Prow()   , 024 Psay IIF(TNQ->TNQ_INDICA=='1',"Empresa  ","Empregado")
				@ Prow()   , 040 Psay TNN->TNN_DESCRI
				@ Prow()   , 100 Psay (TNN->TNN_DTINIC + 730)
			Endif
			TNQ->(DbSkip())			
		Enddo
	Endif
	@ Prow() +2, 000 PSAY __PrtThinLine() 
	@ Prow() +1, 001 Psay "Medicina do Trabalho" 
	@ Prow() +1, 001 Psay "====================" 

    If 	SRA->RA_XRESMED == 'S' 
		@ Prow() +2, 001 Psay "Em tratamento Medico" 
    
	Else
 		@ Prow() +2, 001 Psay "Apto" 
	    
    Endif

	If SRA->RA_ZTIPOAP $ '1/3' 

		@ Prow() +2, 000 PSAY __PrtThinLine() 
		@ Prow() +1, 001 Psay "Processo de Aposentadoria" 
		@ Prow() +1, 001 Psay "=========================" 

		If SRA->RA_ZTIPOAP $ '1' 
			@ Prow() +2, 001 Psay "Aposentado     Inicio: "+Dtoc(SRA->RA_ZDTAPI) 
    
		Elseif SRA->RA_ZTIPOAP $ '3'
			@ Prow() +2, 001 Psay "Em processo    Inicio: "+Dtoc(SRA->RA_ZDTAPI) 
	    
	    Endif

	Endif	    

Endif
@ Prow() +2, 000 PSAY __PrtThinLine() 
@ Prow() +1, 000 PSAY "" 

Return
