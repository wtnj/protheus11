/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE183  ºAutor  ³Marcos R Roquitski  º Data ³  24/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio media ultimos 3 meses Liquido(799)+Adt.(442).     º±±
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

User Function Nhgpe183()

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
nomeprog  := "NHGPE183"
aLinha    := {}
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "Folha de pagamento Conferencia"
Cabec1    := " Matr.  Nome                  C.Custo   Descricao        Salario M/H Admissao                     Mes 1                 Mes 2             Mes 3"
Cabec2    := "                                                                                                     Desc.          Desc.          Desc.               Med/Desc   Sal-Media     Margem"
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13
Cabec3    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHGPE183"
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
Local _lRet   := .F.
Local _nV799  := 0 
Local _nV442  := 0 

Local _nDia   := 0
Local _cMat   := Space(06)
Local _dDatai := _dDataf := Ctod(Space(08))
Local _cTipo  := Space(01)
Local _nCol   := 0
Local _nMedia := 0
Local _nMes1  := Val(Substr(mv_par06,5,2))
Local _nVdes  := 0
Local _nSomed := 0
Local _nMarge := 0
Local _dAdmiss

Titulo := "Media Folha / "+MesExtenso(Val(Substr(mv_par06,5,2)))+" de "+Substr(mv_par06,1,4)

cCusto := Space(10)
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
DbSelectArea(cSrd) 
(cSrd)->(dbgotop())

While (cSrd)->(!eof())

	If Prow() > 64
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
	Endif

	_cMat := (cSrd)->RD_MAT

	@ Prow() +1, 001 Psay (cSrd)->RD_MAT
	@ Prow()   , 008 Psay Substr((cSrd)->RA_NOME,1,30)
	//@ Prow()   , 030 Psay Substr((cSrd)->RA_CC,1,8)
	//@ Prow()   , 040 Psay Substr((cSrd)->CTT_DESC01,1,15)
	@ Prow()   , 040 Psay (cSrd)->RA_CIC Picture '@R 999.999.999-99'                                     

	If (cSrd)->RA_CATFUNC = 'H'
		_nSal := ((cSrd)->RA_SALARIO * 200)
	Else
		_nSal := (cSrd)->RA_SALARIO
	Endif	

	@ Prow()   , 055 Psay _nSal    Picture "@E 99,999.99"
	@ Prow()   , 066 Psay (cSrd)->RA_CATFUNC
	@ Prow()   , 069 Psay Substr((cSrd)->RA_ADMISSA,7,2) + '/' + Substr((cSrd)->RA_ADMISSA,5,2) + '/' + Substr((cSrd)->RA_ADMISSA,1,4)
	@ Prow()   , 082 Psay (cSrd)->RA_SITFOLH
	_dAdmiss := Ctod( Substr((cSrd)->RA_ADMISSA,7,2) + '/' + Substr((cSrd)->RA_ADMISSA,5,2) + '/' + Substr((cSrd)->RA_ADMISSA,1,4) )
	@ Prow()   , 087 Psay IIF ( (_dAdmiss + 90) > dDataBase, 'E',' ')
	@ Prow()   , 092 Psay IIF((cSrd)->RA_CODFUNC $ '0321/1193','S',' ')


	
	While !(cSrd)->(Eof()) .and. (cSrd)->RD_MAT == _cMat

		If Val(Substr((cSrd)->RD_DATARQ,5,2)) == _nMes1
			_cMes := (cSrd)->RD_DATARQ
			While !(cSrd)->(Eof()) .and. (cSrd)->RD_MAT == _cMat .and. (cSrd)->RD_DATARQ == _cMes 

				If		(cSrd)->RD_PD $ '401/403/407/409/438/447/451/437/439/443/440/466/480/494/492/490'
					_nVdes  += (cSrd)->RD_VALOR
			
				Endif
				
				If 	(cSrd)->RD_PD == '442' // Liquido Adiantamento
					_nV442   += (cSrd)->RD_VALOR                                                                                    	

				Endif
			
				(cSrd)->(DbSkip())

			Enddo
	
			If _nVdes > 0
				@ Prow()   ,  97 + _nCol  Psay _nVdes   Picture "@E 99,999.99"		
				_nSomed += _nVdes
			Endif
		Endif
		_nCol   += 15
		_nVdes  := 0
		_nV442  := 0
		_nMes1++
		If _nMes1  == 13
			_nMes1 := 1
		Endif	
	Enddo
	_nMes1   := Val(Substr(mv_par06,5,2))
	_nMedia  := (_nSomed / 3)
	_nMarge := (((_nSal - _nMedia) * 30) / 100)
	@ Prow()   , 150 Psay _nMedia   		 Picture "@E 99,999.99"
	@ Prow()   , 162 Psay (_nSal - _nMedia)  Picture "@E 99,999.99"
	@ Prow()   , 173 Psay _nMarge            Picture "@E 99,999.99"
	_nMedia  := 0
	_nCol    := 0
	_nSal    := 0
	_nSomed  := 0
	_nMarge  := 0
Enddo
@ Prow() +1, 000 PSAY __PrtThinLine() 
@ Prow() +1, 000 PSAY __PrtThinLine() 
@ Prow() +2, 000 PSAY "" 

dbSelectArea(cSrd)
	dbCloseArea()

Return

// 
static Function abreLanc(cSrd)
Local _cAnomesi := mv_par06

Local _cAnomesf := Substr(mv_par06,1,4) + StrZero(Val(Substr(mv_par06,5,2))+2,2)
Local _cNomM1 := MesExtenso( Str(Val(Substr(mv_par06,5,2))))
Local _cNomM2 := MesExtenso( Str(Val(Substr(mv_par06,5,2))+1))
Local _cNomM3 := MesExtenso( Str(Val(Substr(mv_par06,5,2))+2))

If Val(Substr(mv_par06,5,2)) == 11 
	_cAnomesf := StrZero(Val(Substr(mv_par06,1,4))+1,4) + '01'
	_cNomM2 := MesExtenso('12')
	_cNomM3 := MesExtenso('01')
Endif

If Val(Substr(mv_par06,5,2)) == 12 
	_cAnomesf := StrZero(Val(Substr(mv_par06,1,4))+1,4) + '02'
	_cNomM2 := MesExtenso('01')
	_cNomM3 := MesExtenso('02')
Endif
           

Cabec1  := " Matr.  Nome                            C.P.F            Salario M/H Admissao   St.  Exp.  Menor   "+_cNomM1 + Space(10) + _cNomM2 + Space(10) + _cNomM3
//--Consulta as Previsões de venda
beginSql Alias cSrd
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
	       SRA.RA_ADMISSA,
	       SRA.RA_CIC,
	       SRA.RA_SITFOLH,
	       SRA.RA_CODFUNC

	from 
		%table:SRD% SRD
	inner join
			%table:SRA% SRA
	on
		SRA.RA_FILIAL  = %xFilial:SRA%					
	and SRD.RD_MAT     = SRA.RA_MAT
	and SRA.D_E_L_E_T_ =  ' '
	and SRA.RA_DEMISSA =  ' '
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
	and SRD.D_E_L_E_T_ = ' '		
	and SRD.RD_DATARQ  BETWEEN %Exp:_cAnomesi% AND %Exp:_cAnomesf%
	and SRD.RD_PD IN ('401','403','407','409','438','447','451','437','439','443','440','466','401','480','494','492','490')
	order by
		SRD.RD_MAT,SRD.RD_DATARQ
endSql

Processa( {|| RptTmp() },"Imprimindo...") 

Return 
