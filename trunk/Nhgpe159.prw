/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE159  ºAutor  ³Marcos R Roquitski  º Data ³  27/04/09   º±±
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

User Function Nhgpe159()

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
nomeprog  := "NHGPE159"
aLinha    := {}
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "Folha de pagamento Conferencia"
Cabec1    := " Matr.  Nome                  C.Custo   Descricao      Dep Dep. Funcao  Salario  Base     Base INSS  Base 13o  Base 13o      Base      INSS      INSS      INSS        IR        IR        IR        IR      Adto      FGTS  1a.Pac      FGTS"
Cabec2    := "                                                       I.R Sal                   INSS ate     acima    Ate       Acima       FGTS              Ferias      13o.              Ferias      13o.      Adto                     13o.Sal   13o.Sal"
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13
Cabec3    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "GPE105"
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
Local _lRet := .F.,	_nTotG0 := _nTotLiq := _nTotGer := _nTot825 := _nTot799 := 0
Local _nV715 := _nV716 := _nV750 := _nV124 := _nSal := _nV735 := _nV401 :=  _nV718 :=  _nV719 := _nV403 := _nV405 := 0
Local _nV407 := 0 
Local _nV409 := 0 
Local _nV411 := 0 
Local _nV723 := 0 
Local _nV442 := 0 
Local _nV736 := 0 
Local _nV144 := 0
Local _nV739 := 0
Local _cMat  := Space(06)
Local _cFunc := Space(04)

_nV715 := 0
_nV716 := 0

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
	_cFunc := (cSrc)->RA_CODFUNC
	                                                                                                                                   		
	_cMat := (cSrc)->RC_MAT
	While !(cSrc)->(Eof()) .and. (cSrc)->RC_MAT == _cMat

		If (cSrc)->RC_PD == '715'
			_nV715 += (cSrc)->RC_VALOR

		Elseif 	(cSrc)->RC_PD == '716'
			_nV716   += (cSrc)->RC_VALOR

		Elseif 	(cSrc)->RC_PD == '750' // No. Dep. IR
			_nV750   += (cSrc)->RC_HORAS
			
		Elseif 	(cSrc)->RC_PD == '124' // Salario familila
			_nV124   += (cSrc)->RC_HORAS	

		Elseif 	(cSrc)->RC_PD == '735' // Base FGTS
			_nV735   += (cSrc)->RC_VALOR

		Elseif 	(cSrc)->RC_PD == '401' // Base INSS
			_nV401   += (cSrc)->RC_VALOR

		Elseif 	(cSrc)->RC_PD == '718' // Base 13o. Ate
			_nV718   += (cSrc)->RC_VALOR

		Elseif 	(cSrc)->RC_PD == '719' // Base 13o. Acima
			_nV719   += (cSrc)->RC_VALOR

		Elseif 	(cSrc)->RC_PD == '403' // INSS Ferias    
			_nV403   += (cSrc)->RC_VALOR

		Elseif 	(cSrc)->RC_PD == '405' // INSS 13o.       
			_nV405   += (cSrc)->RC_VALOR

		Elseif 	(cSrc)->RC_PD == '407' // IR 
			_nV407   += (cSrc)->RC_VALOR

		Elseif 	(cSrc)->RC_PD == '409' // IR Ferias
			_nV409   += (cSrc)->RC_VALOR
			
		Elseif 	(cSrc)->RC_PD == '411' // IR 13o. Sal
			_nV411   += (cSrc)->RC_VALOR
			
		Elseif 	(cSrc)->RC_PD == '723' // IR Adto Sal
			_nV723   += (cSrc)->RC_VALOR

		Elseif 	(cSrc)->RC_PD == '442' // Adto
			_nV442   += (cSrc)->RC_VALOR

		Elseif 	(cSrc)->RC_PD == '736' // Fgts
			_nV736   += (cSrc)->RC_VALOR

		Elseif 	(cSrc)->RC_PD == '144' // 1o. Parc. 13o.
			_nV144   += (cSrc)->RC_VALOR

		Elseif 	(cSrc)->RC_PD == '739' // Fgts 13o. 
			_nV739   += (cSrc)->RC_VALOR

		Endif	
		(cSrc)->(DbSkip())
	Enddo

	@ Prow()   , 056 Psay _nV750   Picture "99"		
	@ Prow()   , 059 Psay _nV124   Picture "99"		
	@ Prow()   , 064 Psay _cFunc   
	@ Prow()   , 070 Psay _nSal    Picture "@E 99,999.99"
	@ Prow()   , 080 Psay _nV715   Picture "@E 99,999.99"		
	@ Prow()   , 090 Psay _nV716   Picture "@E 99,999.99"
	@ Prow()   , 100 Psay _nV718   Picture "@E 99,999.99"
	@ Prow()   , 110 Psay _nV719   Picture "@E 99,999.99"	
	@ Prow()   , 120 Psay _nV735   Picture "@E 99,999.99"
	@ Prow()   , 130 Psay _nV401   Picture "@E 99,999.99"	
	@ Prow()   , 140 Psay _nV403   Picture "@E 99,999.99"	
	@ Prow()   , 150 Psay _nV405   Picture "@E 99,999.99"	
	@ Prow()   , 160 Psay _nV407   Picture "@E 99,999.99"	
	@ Prow()   , 170 Psay _nV409   Picture "@E 99,999.99"	
	@ Prow()   , 180 Psay _nV411   Picture "@E 99,999.99"	
	@ Prow()   , 190 Psay _nV723   Picture "@E 99,999.99"	
	@ Prow()   , 200 Psay _nV442   Picture "@E 99,999.99"					
	@ Prow()   , 210 Psay _nV736   Picture "@E 99,999.99"					
	@ Prow()   , 220 Psay _nV144   Picture "@E 99,999.99"					
	@ Prow()   , 230 Psay _nV739   Picture "@E 99,999.99"					

	_nTotLiq := 0
	_nV715   := 0
	_nV716   := 0
	_nV124   := 0
	_nV750   := 0
	_nSal    := 0
	_nV735   := 0
	_nV401   := 0 
	_nV718   := 0
	_nV719   := 0
	_nV403   := 0
	_nV405   := 0
	_nV407   := 0 
	_nV409   := 0 
	_nV411   := 0 
	_nV723   := 0 
	_nV442   := 0 
	_nV736   := 0 
	_nV144   := 0
	_nV739   := 0
	
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
	       SRA.RA_CODFUNC,
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