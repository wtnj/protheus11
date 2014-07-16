/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE177  ºAutor  ³Marcos R Roquitski  º Data ³  24/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio Inovacao tecnologica Acumulado por Verbas         º±±
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

User Function Nhgpe177()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave,nTipo,aReturn,NOMEPROG,ALINHA,NLASTKEY,LEND")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,CCOMPAC,CNORMAL,CQUERY,TITULO,CABEC1,cSrt,_cMat,_cDat")                                       	
SetPrvt("dDataRef,cFilDe,cFilAte,cCcDe,cCcAte,cMatDe,cMatAte,cNomeDe,cNomeAte,nAnaSin,nGerRes,lImpNiv,cCateg")

cString   := "SRC"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir")
cDesc2    := OemToAnsi("Verbas do movimento do mes base Inovacao Tecnologica")
cDesc3    := OemToAnsi("")
tamanho   := "G"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHGPE177"
aLinha    := {}
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "Folha de pagamento Conferencia"
Cabec1    := " Matr.  Nome                  C.Custo   Descricao        Salario M/H                 Salario Mensal                                    P R O V I S A O                            Beneficios              TOTAL       TAXA" 
Cabec2    := "                                                                         Salario    H.Extras        INSS        FGTS     13o.Sal      Ferias        INSS        FGTS     MEDICA REF/V.TRA       PPR       MENSAL      MEDIA" 
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13
Cabec3    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHGPE177"
cPerg     := "GPE105"
cSrc      := "TMP_SRC"
cSrt      := "TMP_SRT"

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
Local _nV101  := 0 
Local _nV105  := 0 
Local _nV778  := 0 
Local _nV736  := 0 
Local _nV816  := 0
Local _nV758  := 0 
Local _nV759  := 0
Local _nV760  := 0
                  
Local _nV794  := 0
Local _nV788  := 0
Local _nV435  := 0

Local _cMat   := Space(06)
Local _dDatai := _dDataf := Ctod(Space(08))
Local _cTipo  := Space(01)
Local _nTMes  := 0
Local _lSret := .T.                                                                   	

Titulo := "Mao de Obra - Inovacao Tecnologica: Folha / "+MesExtenso(Val(Substr(MV_PAR06,5,2)))+" de "+Substr(MV_PAR06,1,4)


SRT->(DbSetOrder(1))
cCusto := Space(10)
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
DbSelectArea(cSrc) 
(cSrc)->(dbgotop())

While (cSrc)->(!eof())

	If Prow() > 64
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
	Endif

	@ Prow() +1, 001 Psay (cSrc)->RD_MAT
	@ Prow()   , 008 Psay Substr((cSrc)->RA_NOME,1,20)
	@ Prow()   , 030 Psay Substr((cSrc)->RA_CC,1,8)
	@ Prow()   , 040 Psay Substr((cSrc)->CTT_DESC01,1,14)

	If (cSrc)->RA_CATFUNC = 'H'
		_nSal := ((cSrc)->RA_SALARIO * 200)
	Else
		_nSal := (cSrc)->RA_SALARIO
	Endif	

	@ Prow()   , 055 Psay _nSal    Picture "@E 99,999.99"
	@ Prow()   , 067 Psay (cSrc)->RA_CATFUNC

	                                                                                                                                   		
	_cMat := (cSrc)->RD_MAT
	While !(cSrc)->(Eof()) .and. (cSrc)->RD_MAT == _cMat

		If		(cSrc)->RD_PD $ '101/102/103/113/120/121/128/129/130/217/220/425/427/428/429' // Salarios
			_nV101  += (cSrc)->RD_VALOR
			
		Elseif 	(cSrc)->RD_PD $ '105/107/110/111/112/116/122' // Horas extras
			_nV105   += (cSrc)->RD_VALOR
			
		Elseif 	(cSrc)->RD_PD $ '715/716' // INSS
			_nV778   += (((cSrc)->RD_VALOR * 27.8)/100)
			
		Elseif 	(cSrc)->RD_PD == '736' // FGTS
			_nV736   += (cSrc)->RD_VALOR

 		Elseif 	(cSrc)->RD_PD == '794' // MEDICA
			_nV794   += (cSrc)->RD_VALOR

		Elseif 	(cSrc)->RD_PD == '788/435' // REFEICAO/VALE TRANSPORTE
			_nV788   += (cSrc)->RD_VALOR

        Endif
	
		(cSrc)->(DbSkip())

	Enddo
	_nV816   := ((_nV101 *  8.33)/100) // 13o. Sal. Provisao
	_nV758   := ((_nV101 * 11.11)/100) // Ferias Provisao
	_nV759   := (((_nV816 + _nV758) * 27.8) / 100) // INSS Provisao
	_nV760   := (((_nV816 + _nV758) * 8) / 100) // FGTS Provisao


	_nTMes := (_nV101 + _nV105 + _nV778 + _nV736 + _nV816 + _nV758 + _nV759 + _nV760 + _nV794 + _nV788 + _nV435 + ((_nV101 * 8.33)/100) )
		
	@ Prow()   ,  70 Psay _nV101   Picture "@E 999,999.99"		
	@ Prow()   ,  82 Psay _nV105   Picture "@E 999,999.99"
	@ Prow()   ,  94 Psay _nV778   Picture "@E 999,999.99"
	@ Prow()   , 106 Psay _nV736   Picture "@E 999,999.99"

	@ Prow()   , 118 Psay _nV816   Picture "@E 999,999.99"
	@ Prow()   , 130 Psay _nV758   Picture "@E 999,999.99"
	@ Prow()   , 142 Psay _nV759   Picture "@E 999,999.99"
	@ Prow()   , 154 Psay _nV760   Picture "@E 999,999.99"

	@ Prow()   , 166 Psay _nV794   Picture "@E 99,999.99"
	@ Prow()   , 176 Psay _nV788   Picture "@E 99,999.99"
	@ Prow()   , 186 Psay ((_nV101 * 8.33)/100)   Picture "@E 99,999.99"

	@ Prow()   , 198 Psay _nTmes       Picture "@E 999,999.99"	
	@ Prow()   , 210 Psay (_nTmes/200)  Picture "@E 99,999.99"	
	

	_nSal   := 0
	_nV101  := 0
	_nV105  := 0
	_nV778  := 0 
	_nV736  := 0 
	_nV816  := 0  
	_nV758  := 0 	
	_nV759  := 0 	
	_nV760  := 0 	
	_nV794  := 0 	
	_nV788  := 0 		
	_nV435  := 0 		
	_nTmes  := 0
	_cTipo  := Space(01)
	_lSret  := .T.
		
Enddo
@ Prow() +1, 000 PSAY __PrtThinLine() 
@ Prow() +1, 000 PSAY __PrtThinLine() 
@ Prow() +2, 000 PSAY "" 

dbSelectArea(cSrc)
dbCloseArea()

Return

// 
static Function abreLanc(cSrc)
Local _cZempde  := mv_par05
Local _cZempAte := mv_par05

If mv_par05 <> '7'

	If mv_par05 == '6'
		_cZempde  := ' '
		_cZempAte := 'Z'
	Endif	

	//--Fecha Alias Temporario se estiver aberto
	If Select(cSrc) > 0
		dbSelectArea(cSrc)
		dbCloseArea()
	Endif

	//--Consulta as Previsões de venda
	beginSql Alias cSrc
		select SRD.RD_MAT,
	       SRA.RA_NOME,
	       SRA.RA_CC,
	       CTT.CTT_DESC01,
	       SRA.RA_SALARIO,
	       SRA.RA_CATFUNC,
	       SRD.RD_PD,
	       SRD.RD_VALOR,
	       SRD.RD_HORAS,
	       SRD.RD_DATARQ,
	       SRA.RA_ZEMP
		from 
			%table:SRD% SRD
		inner join
				%table:SRA% SRA
		on
			SRA.RA_FILIAL  = %xFilial:SRA%					
		and SRD.RD_MAT     = SRA.RA_MAT
		and SRA.RA_CATFUNC IN ('M','H')
		and SRA.D_E_L_E_T_ =  ' '
		and SRA.RA_CC   BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		and SRA.RA_MAT  BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		and SRA.RA_ZEMP BETWEEN %Exp:_cZempde% AND %Exp:_cZempAte%
		inner join
				%table:CTT% CTT
		on
			CTT.CTT_FILIAL  = %xFilial:CTT%					
		and CTT.CTT_CUSTO = SRA.RA_CC
		and CTT.D_E_L_E_T_ = ' '	

		where              
			SRD.RD_FILIAL  = %xFilial:SRC%
		and SRD.RD_DATARQ  = %Exp:mv_par06%
		and SRD.D_E_L_E_T_ = ' '		
		order by
			SRD.RD_MAT
	endSql

Else

	//--Fecha Alias Temporario se estiver aberto
	If Select(cSrc) > 0
		dbSelectArea(cSrc)
		dbCloseArea()
	Endif

	//--Consulta as Previsões de venda
	beginSql Alias cSrc
		select SRD.RD_MAT,
	       SRA.RA_NOME,
	       SRA.RA_CC,
	       CTT.CTT_DESC01,
	       SRA.RA_SALARIO,
	       SRA.RA_CATFUNC,
	       SRD.RD_PD,
	       SRD.RD_VALOR,
	       SRD.RD_HORAS,
	       SRD.RD_DATARQ,
	       SRA.RA_ZEMP
		from 
			%table:SRD% SRD
		inner join
				%table:SRA% SRA
		on
			SRA.RA_FILIAL  = %xFilial:SRA%					
		and SRD.RD_MAT     = SRA.RA_MAT
		and SRA.RA_CATFUNC IN ('M','H')
		and SRA.D_E_L_E_T_ =  ' '
		and SRA.RA_CC   BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		and SRA.RA_MAT  BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		and SRA.RA_ZEMP IN ('2','4','5')
		inner join
				%table:CTT% CTT
		on
			CTT.CTT_FILIAL  = %xFilial:CTT%					
		and CTT.CTT_CUSTO = SRA.RA_CC
		and CTT.D_E_L_E_T_ = ' '	

		where              
			SRD.RD_FILIAL  = %xFilial:SRC%
		and SRD.RD_DATARQ  = %Exp:mv_par06%
		and SRD.D_E_L_E_T_ = ' '		
		order by
			SRD.RD_MAT
	endSql

Endif

Processa( {|| RptTmp() },"Imprimindo...") 

Return 


static Function abreProv(cSrt)

//--Fecha Alias Temporario se estiver aberto
If Select(cSrt) > 0
	dbSelectArea(cSrt)
	dbCloseArea()
Endif
