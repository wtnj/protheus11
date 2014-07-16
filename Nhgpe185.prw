/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE185  ºAutor  ³Marcos R Roquitski  º Data ³  18/05/11   º±±
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

User Function Nhgpe185()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave,nTipo,aReturn,NOMEPROG,ALINHA,NLASTKEY,LEND")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,CCOMPAC,CNORMAL,CQUERY,TITULO,CABEC1")                                       	
SetPrvt("dDataRef,cFilDe,cFilAte,cCcDe,cCcAte,cMatDe,cMatAte,cNomeDe,cNomeAte,nAnaSin,nGerRes,lImpNiv,cCateg")

cString   := "SRD"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir")
cDesc2    := OemToAnsi("Verbas do movimento do mes para conferencia")
cDesc3    := OemToAnsi("")
tamanho   := "G"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHGPE185"
aLinha    := {}
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "Folha de pagamento Conferencia"
Cabec1    := " Matr.  Nome                  C.Custo   Descricao       Funcao                        Salario                  Dsr H.Extras                  Dif. Horas                     H. Extras                     T o t a l"
Cabec2    := "                                                                                                            Valor       Horas             Valor       Horas              Valor      Horas             Valor       Horas
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13
Cabec3    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHGPE185"
cPerg     := "GPE105"
cSrd      := "TMP_SRD"

If !Pergunte("GPE105",.T.) 
	Return 
Endif


SetPrint("SRD",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")
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
Processa( {||  abreLanc(cSrd) },"Gerando Dados para a Impressao")

    
Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool


Return


Static Function RptTmp()
Local _lRet := .F.,	_nTotho := _nTotval := _nTotGeh := _nTotGev := 0
Local _nV103  := 0 
Local _nV112  := 0 
Local _nVExt  := 0 
Local _cMat   := Space(06)
Local _cFunc  := Space(04)
Local _cDescf := Space(20)	
Local _nV103h := 0
Local _nV112h := 0
Local _nVExth  := 0

Titulo := "Horas Extras Folha / "+MesExtenso(Val(Substr(mv_par06,5,2)))+" de "+Substr(mv_par06,1,4)

cCusto := Space(10)
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
DbSelectArea(cSrd) 
(cSrd)->(dbgotop())

While (cSrd)->(!eof())

	If Prow() > 64
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
	Endif

	@ Prow() +1, 001 Psay (cSrd)->RD_MAT
	@ Prow()   , 008 Psay Substr((cSrd)->RA_NOME,1,20)
	@ Prow()   , 030 Psay Substr((cSrd)->RA_CC,1,8)
	@ Prow()   , 040 Psay Substr((cSrd)->CTT_DESC01,1,15)

	If (cSrd)->RA_CATFUNC = 'H'
		_nSal := ((cSrd)->RA_SALARIO * 200)
	Else
		_nSal := (cSrd)->RA_SALARIO
	Endif	
	_cFunc := (cSrd)->RA_CODFUNC
	                                                                                                                                   		
	_cMat := (cSrd)->RD_MAT
	While !(cSrd)->(Eof()) .and. (cSrd)->RD_MAT == _cMat

		If (cSrd)->RD_PD == '122' // DSR HORISTA         
			_nV103   += (cSrd)->RD_VALOR
			_nV103h  += (cSrd)->RD_HORAS

			_nTotval += (cSrd)->RD_VALOR
			_nTotho  += (cSrd)->RD_HORAS
						
		Elseif 	(cSrd)->RD_PD $ '105/106/107/108/109/110/111/116'
			_nVExt   += (cSrd)->RD_VALOR
			_nVExth  += (cSrd)->RD_HORAS
			
			_nTotval += (cSrd)->RD_VALOR
			_nTotho  += (cSrd)->RD_HORAS


		Elseif 	(cSrd)->RD_PD == '112' // DIFERENCA HE VALOR  
			_nV112   += (cSrd)->RD_HORAS
			_nV112h  += (cSrd)->RD_HORAS
						
			_nTotval += (cSrd)->RD_VALOR
			_nTotho  += (cSrd)->RD_HORAS

						
		Endif	

		(cSrd)->(DbSkip())

	Enddo
	@ Prow()   , 056	 Psay _cFunc   

	_cDescf := Space(20)	
	If SRJ->(DbSeek(xFilial("SRJ")+ _cFunc))
		_cDescf := SRJ->RJ_DESC
	Endif		
	@ Prow()   , 062	 Psay _cDescf		
	@ Prow()   , 084 Psay _nSal    Picture "@E 99,999.99"
	@ Prow()   , 100 Psay _nV103   Picture "@E 99,999,999.99"		
	@ Prow()   , 115 Psay _nV103h  Picture "@E 999,999.99"		
               	
	@ Prow()   , 130 Psay _nV112   Picture "@E 99,999,999.99"
	@ Prow()   , 145 Psay _nV112h  Picture "@E 999,999.99"		

	@ Prow()   , 160 Psay _nVExt   Picture "@E 99,999,999.99"
	@ Prow()   , 175 Psay _nVExth  Picture "@E 999,999.99"		

	@ Prow()   , 190 Psay _nTotval Picture "@E 99,999,999.99"
	@ Prow()   , 205 Psay _nTotho  Picture "@E 999,999.99"		

	_nTotgev += _nTotval        
	_nTotgeh += _nTotho          

	_nTotLiq := 0
	_nV103   := 0
	_nV112   := 0
	_nVExt   := 0
	_nSal    := 0
	_nV103h  := 0
	_nV112h  := 0
	_nVExth  := 0
	_nTotval := 0
	_nTotho  := 0

Enddo
@ Prow() +1, 000 PSAY __PrtThinLine() 
@ Prow() +1, 190 Psay _nTotgev Picture "@E 99,999,999.99"
@ Prow()   , 205 Psay _nTotgeh Picture "@E 999,999.99"		
@ Prow() +1, 000 PSAY __PrtThinLine() 
@ Prow() +2, 000 PSAY "" 

dbSelectArea(cSrd)
dbCloseArea()

Return

// 
static Function abreLanc(cSrd)
Local _cAnomesi := mv_par06
Local _cAnomesf := mv_par06
//Local _cAnomesf := Substr(mv_par06,1,4) + StrZero(Val(Substr(mv_par06,5,2))+2,2)

If Val(Substr(mv_par06,5,2)) == 11 
	_cAnomesf := StrZero(Val(Substr(mv_par06,1,4))+1,4) + '01'
Endif

If Val(Substr(mv_par06,5,2)) == 12 
	_cAnomesf := StrZero(Val(Substr(mv_par06,1,4))+1,4) + '02'
Endif

//--Fecha Alias Temporario se estiver aberto
If Select(cSrd) > 0
	dbSelectArea(cSrd)
	dbCloseArea()
Endif

//--Consulta as Previsões de venda
beginSql Alias cSrd
	select SRD.RD_MAT,
	       SRA.RA_NOME,
	       SRA.RA_CC,
	       CTT.CTT_DESC01,
	       SRA.RA_SALARIO,
	       SRA.RA_CATFUNC,
	       SRA.RA_CODFUNC,
	       SRD.RD_PD,
	       SRD.RD_VALOR,
	       SRD.RD_HORAS
	from 
		%table:SRD% SRD
	inner join
			%table:SRA% SRA
	on
		SRA.RA_FILIAL  = %xFilial:SRA%					
	and SRD.RD_MAT     = SRA.RA_MAT
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
		SRD.RD_FILIAL  = %xFilial:SRD%
	and SRD.RD_DATARQ  BETWEEN %Exp:_cAnomesi% AND %Exp:_cAnomesf%		
	and SRD.D_E_L_E_T_ = ' '		
	order by
		SRD.RD_MAT
endSql

Processa( {|| RptTmp() },"Imprimindo...")

Return