/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE160  ºAutor  ³Marcos R Roquitski  º Data ³  24/05/10   º±±
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

User Function Nhgpe161()

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
nomeprog  := "NHGPE161"
aLinha    := {}
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "Folha de pagamento Conferencia"
Cabec1    := " Matr.  Nome                  C.Custo   Descricao        Salario M/H Tipo            Periodo             Qtde              Sal. Hr.           DSR Hr.              Sal. Mens.         Enfermidade          Acidente    "                                             
Cabec2    := "                                                                                Inicio      Final        Dias           Qtde     Valor      Qtde     Valor      Qtde     Valor      Qtde     Valor      Qtde     Valor"
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13
Cabec3    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHGPE161"
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
Local _nV102  := 0 
Local _nV102h := 0 

Local _nV103  := 0 
Local _nV103h := 0 

Local _nV101  := 0 
Local _nV101h := 0 

Local _nV128  := 0 
Local _nV128h := 0

Local _nV129  := 0
Local _nV129h := 0 

Local _nDia   := 0
Local _cMat   := Space(06)
Local _dDatai := _dDataf := Ctod(Space(08))
Local _cTipo  := Space(01)

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

	// Pesquisa afastamento
	SR8->(DbSeek(xFilial("SR8")+(cSrc)->RC_MAT))
	While !SR8->(Eof()) .and. SR8->R8_MAT == (cSrc)->RC_MAT
		If  Substr(Dtos(SR8->R8_DATAFIM),1,6) >= Substr(Dtos(dDataBase),1,6)
			_nDia   := Day(SR8->R8_DATAFIM)
			_dDatai := SR8->R8_DATAINI
			_dDataf := SR8->R8_DATAFIM
			_cTipo  := SR8->R8_TIPO
		Elseif SR8->R8_DATAFIM == Ctod(Space(08))
			_nDia   := 30 // Ultimodia(dDataBase)
			_dDatai := SR8->R8_DATAINI
			_dDataf := SR8->R8_DATAFIM
			_cTipo  := SR8->R8_TIPO			
		Endif
		SR8->(DbSkip())
	Enddo
	@ Prow()   , 055 Psay _nSal    Picture "@E 99,999.99"
	@ Prow()   , 067 Psay (cSrc)->RA_CATFUNC
	@ Prow()   , 072 Psay _cTipo

	                                                                                                                                   		
	_cMat := (cSrc)->RC_MAT
	While !(cSrc)->(Eof()) .and. (cSrc)->RC_MAT == _cMat

		If		(cSrc)->RC_PD == '102' // Salario Hora
			_nV102  += (cSrc)->RC_VALOR
			_nV102h += (cSrc)->RC_HORAS
			
		Elseif 	(cSrc)->RC_PD == '103' // Dsr
			_nV103   += (cSrc)->RC_VALOR
			_nV103h  += (cSrc)->RC_HORAS
			
		Elseif 	(cSrc)->RC_PD == '101' // Salario Mes      
			_nV101   += (cSrc)->RC_VALOR
			_nV101h  += (cSrc)->RC_HORAS
			
		Elseif 	(cSrc)->RC_PD == '128' // Enfermidade
			_nV128   += (cSrc)->RC_VALOR
			_nV128h  += (cSrc)->RC_HORAS	

		Elseif 	(cSrc)->RC_PD == '129' // Acidente
			_nV129   += (cSrc)->RC_VALOR
			_nV129h  += (cSrc)->RC_HORAS	
		Endif	
	
		(cSrc)->(DbSkip())

	Enddo
	
	@ Prow()   , 080 Psay _dDatai 
	@ Prow()   , 092 Psay _dDataf 
	
	@ Prow()   , 105 Psay _nDia    Picture "@E 9999"    
	
	@ Prow()   , 115 Psay _nV102h  Picture "@E 99,999.99"		
	@ Prow()   , 125 Psay _nV102   Picture "@E 99,999.99"		

	@ Prow()   , 135 Psay _nV103h  Picture "@E 99,999.99"
	@ Prow()   , 145 Psay _nV103   Picture "@E 99,999.99"

	@ Prow()   , 155 Psay _nV101h  Picture "@E 99,999.99"
	@ Prow()   , 165 Psay _nV101   Picture "@E 99,999.99"

	@ Prow()   , 175 Psay _nV128h  Picture "@E 99,999.99"	
	@ Prow()   , 185 Psay _nV128   Picture "@E 99,999.99"	

	@ Prow()   , 195 Psay _nV129h  Picture "@E 99,999.99"	
	@ Prow()   , 205 Psay _nV129   Picture "@E 99,999.99"	

	
	_nSal   := 0
	_nV101  := 0
	_nV101h := 0

	_nV102  := 0 
	_nV102h := 0 

	_nV103  := 0
	_nV103h := 0

	_nV128  := 0 
	_nV128h := 0 

	_nV129  := 0 
	_nV129h := 0 

	_nDia   := 0
	_dDatai := Ctod(Space(08))
	_dDataf := Ctod(Space(08))
	_cTipo  := Space(01)
		
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
	and SRA.D_E_L_E_T_ =  ' '
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