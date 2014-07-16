/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE160  ºAutor  ³Marcos R Roquitski  º Data ³  27/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio conferencia Folha de Pagamento.                   º±±
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



//#INCLUDE "TOPCONN.CH"

User Function Nhgpe160()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave,nTipo,aReturn,NOMEPROG,ALINHA,NLASTKEY,LEND")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,CCOMPAC,CNORMAL,CQUERY,TITULO,CABEC1")                                       	
SetPrvt("dDataRef,cFilDe,cFilAte,cCcDe,cCcAte,cMatDe,cMatAte,cNomeDe,cNomeAte,nAnaSin,nGerRes,lImpNiv,cCateg")


cString   := "SRC"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir")
cDesc2    := OemToAnsi("Verbas do movimento do mes para conferencia")
cDesc3    := OemToAnsi("")
tamanho   := "G"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHGPE160"
aLinha    := {}
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "Folha de pagamento Conferencia"
Cabec1    := " Matr.  Nome                  C.Custo   Descricao                       Salario         Faltas             Atrasos              Saida Ant.           D.S.R     "
Cabec2    := "                                                                                     Qtde     Valor      Qtde     Valor      Qtde     Valor      Qtde     Valor"
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13
Cabec3    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHGPE160"
cPerg     := "GPE105"
cSrc      := "TMP_SRC"

If !Pergunte("GPE105",.T.) 
	Return 
Endif


SetPrint("SRC",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")
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
Processa( {||  abreLanc(cSrc) },"Gerando Dados para a Impressao")

    
Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool


Return


Static Function RptTmp()
Local _lRet   := .F.
Local _nV425  := 0 
Local _nV427  := 0 
Local _nV428  := 0 
Local _nV429  := 0 
Local _nV425h := 0
Local _nV427h := 0
Local _nV428h := 0 
Local _nV429h := 0 

Local _cMat  := Space(06)

Titulo := "Conferencia Folha / "+MesExtenso(Month(dDataBase))+" de "+Alltrim(Str(Year(dDataBase)))

cCusto := Space(10)
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
DbSelectArea(cSrc) 
(cSrc)->(dbgotop())

While (cSrc)->(!eof())

	If Prow() > 64
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
	Endif

	@ Prow() +1, 001 Psay (cSrc)->RC_MAT
	@ Prow()   , 008 Psay Substr((cSrc)->RA_NOME,1,20)
	@ Prow()   , 030 Psay Substr((cSrc)->RA_CC,1,8)
	@ Prow()   , 040 Psay Substr((cSrc)->CTT_DESC01,1,15)

	If (cSrc)->RA_CATFUNC = 'H'
		_nSal := ((cSrc)->RA_SALARIO * 200)
	Else
		_nSal := (cSrc)->RA_SALARIO
	Endif	
	                                                                                                                                   		
	_cMat := (cSrc)->RC_MAT
	While !(cSrc)->(Eof()) .and. (cSrc)->RC_MAT == _cMat

		If		(cSrc)->RC_PD == '425' // Faltas
			_nV425  += (cSrc)->RC_VALOR
			_nV425h += (cSrc)->RC_HORAS
			
		Elseif 	(cSrc)->RC_PD == '427' // Atrasos
			_nV427   += (cSrc)->RC_VALOR
			_nV427h  += (cSrc)->RC_HORAS
			
		Elseif 	(cSrc)->RC_PD == '428' // Saida antecipada
			_nV428   += (cSrc)->RC_VALOR
			_nV428h  += (cSrc)->RC_HORAS
			
		Elseif 	(cSrc)->RC_PD == '429' // DSR
			_nV429   += (cSrc)->RC_VALOR
			_nV429h  += (cSrc)->RC_HORAS	
		Endif	
		(cSrc)->(DbSkip())
	Enddo

	@ Prow()   , 070 Psay _nSal    Picture "@E 99,999.99"
	@ Prow()   , 080 Psay _nV425h  Picture "@E 99,999.99"		
	@ Prow()   , 090 Psay _nV425   Picture "@E 99,999.99"		
	@ Prow()   , 100 Psay _nV427h  Picture "@E 99,999.99"
	@ Prow()   , 110 Psay _nV427   Picture "@E 99,999.99"
	@ Prow()   , 120 Psay _nV428h  Picture "@E 99,999.99"
	@ Prow()   , 130 Psay _nV428   Picture "@E 99,999.99"
	@ Prow()   , 140 Psay _nV429h  Picture "@E 99,999.99"	
	@ Prow()   , 150 Psay _nV429   Picture "@E 99,999.99"	

	_nSal   := 0
	_nV425  := 0
	_nV427  := 0
	_nV428  := 0 
	_nV429  := 0 
	_nV425h := 0
	_nV427h := 0
	_nV428h := 0 
	_nV429h := 0 


Enddo
@ Prow() +1, 000 PSAY __PrtThinLine() 
@ Prow() +1, 000 PSAY __PrtThinLine() 
@ Prow() +2, 000 PSAY "" 

dbSelectArea(cSrc)
dbCloseArea()

Return

// 
static Function abreLanc(cSrc)

//--Fecha Alias Temporario se estiver aberto
If Select(cSrc) > 0
	dbSelectArea(cSrc)
	dbCloseArea()
Endif

//--Consulta as Previsões de venda
beginSql Alias cSrc
	select SRC.RC_MAT,
	       SRA.RA_NOME,
	       SRA.RA_CC,
	       CTT.CTT_DESC01,
	       SRA.RA_SALARIO,
	       SRA.RA_CATFUNC,
	       SRC.RC_PD,
	       SRC.RC_VALOR,
	       SRC.RC_HORAS
	from 
		%table:SRC% SRC
	inner join
			%table:SRA% SRA
	on
		SRA.RA_FILIAL  = %xFilial:SRA%					
	and SRC.RC_MAT     = SRA.RA_MAT
	and SRA.D_E_L_E_T_ = ' '
	and SRA.RA_CC  BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
	and SRA.RA_MAT BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
	inner join
			%table:CTT% CTT
	on
		CTT.CTT_FILIAL  = %xFilial:CTT%					
	and CTT.CTT_CUSTO = SRA.RA_CC
	and CTT.D_E_L_E_T_ = ' '	
	
	
	where              
		SRC.RC_FILIAL  = %xFilial:SRC%
	and SRC.D_E_L_E_T_ = ' '		
	order by
		SRC.RC_MAT
endSql

Processa( {|| RptTmp() },"Imprimindo...") 

Return