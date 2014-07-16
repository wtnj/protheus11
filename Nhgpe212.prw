/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE212  ºAutor  ³Marcos R Roquitski  º Data ³  24/05/2012 º±±
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

User Function Nhgpe212()

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
nomeprog  := "NHGPE212"
aLinha    := {}
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "Folha de pagamento Conferencia"
Cabec1    := " Matr.  Nome                  C.Custo   Descricao               Planta         Liquido       INSS      INSS      FGTS     Total    PENSAO     IR  SENAI/SESI    LIQUIDO               13o.          "
Cabec2    := "                                                                               Salario     Funcio   Empresa             H.Extra                    SINDICATO    RCT/FER            Abo/PPR          "  
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13
Cabec3    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHGPE212"
cPerg     := "GPE105"
cSrc      := "TMP_SRC" 
cSrd2     := "TMP_SRD"
cSrd3     := "TMP_SRE" 
cSrr      := "TMP_SRR"
cZrd      := "TMP_ZRD"
cSe2      := "TMP_SE2"

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
Local _nV799 := _nV716 := _nV750 := _nV124 := _nSal := _nV735 := _nV401 :=  _nV718 :=  _nV719 := _nV403 := _nV405 := 0
Local _nV407 := 0 
Local _nV409 := 0 
Local _nV411 := 0 
Local _nV723 := 0 
Local _nV442 := 0 
Local _nV736 := 0 
Local _nV144 := 0
Local _nV739 := 0
Local _nV401 := 0  
Local _nV105 := 0 
Local _nV112 := 0  
Local _nV101 := 0 
Local _nV102 := 0 
Local _nV103 := 0  
Local _nV122 := 0 
Local _nV425 := 0  
Local _nV427 := 0 
Local _nV428 := 0 
Local _nV429 := 0 
Local _nV401 := 0 
Local _nV736 := 0 
Local _nV440 := 0
Local _nV715 := 0
Local _nV723 := 0
Local _nV100 := 0 
Local _nV422 := 0
Local _nV460 := 0
Local _nV403 := 0
Local _nV409 := 0 
Local _nV715f := 0
Local _nT799 := 0

Local _cMat  := Space(06)
Local _cFunc := Space(04)
Local lIr    := .t.

_nV715 := 0
_nV716 := 0

Titulo := "Conferencia Folha / "+MesExtenso(Substr(mv_par06,5,2))+" de "+Substr(mv_par06,1,4)

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
	@ Prow()   , 030 Psay Substr((cSrc)->RD_CC,1,8)
	//@ Prow()   , 040 Psay Substr((cSrc)->CTT_DESC01,1,15)

	If (cSrc)->RA_CATFUNC = 'H'
		_nSal := ((cSrc)->RA_SALARIO * 200)
	Else
		_nSal := (cSrc)->RA_SALARIO
	Endif	
	_cZemp := (cSrc)->RA_ZEMP
	                                                                                                                                   		
	_cMat := (cSrc)->RD_MAT
	While !(cSrc)->(Eof()) .and. (cSrc)->RD_MAT == _cMat


		// Processo I.R de pagamento mes anterior
		If lIr
			(cSrd2)->(dbgotop())
			While !(cSrd2)->(Eof()) 
				If (cSrd2)->RD_MAT == _cMat
					_nV407 += (cSrd2)->RD_VALOR
				Endif	
				(cSrd2)->(DbSkip())
			Enddo

			(cSrd3)->(dbgotop())
			While !(cSrd3)->(Eof()) 
				If (cSrd3)->RD_MAT == _cMat
					_nV407 += (cSrd3)->RD_VALOR
				Endif	
				(cSrd3)->(DbSkip())
			Enddo

			// Processa Ferias liquido/ir/inss			
			(cSrr)->(dbgotop())
			While !(cSrr)->(Eof()) 
				If (cSrr)->RR_MAT == _cMat  
					

					If (cSrr)->RR_TIPO3 $ 'F' //Ferias
						If (cSrr)->RR_PD == '460' // Liquido				
							_nV460 += (cSrr)->RR_VALOR
						ElseIf (cSrr)->RR_PD == '409' // I.R
							_nV409 += (cSrr)->RR_VALOR
						Endif	
					Endif	

					If (cSrr)->RR_TIPO3 $ 'R' //Rescisao

						If (cSrr)->RR_PD == '476' // Liquido				
							_nV460 += (cSrr)->RR_VALOR

						ElseIf (cSrr)->RR_PD == '409' // I.R
							_nV409 += (cSrr)->RR_VALOR

						ElseIf (cSrr)->RR_PD == '407' // I.R RESCISAO
							_nV409 += (cSrr)->RR_VALOR

						ElseIf (cSrr)->RR_PD == '411' // I.R RESCISAO 13. SAL
							_nV409 += (cSrr)->RR_VALOR

						Elseif 	(cSrc)->RD_PD == '744' // Fgts RCT/
							_nV736   += (cSrc)->RD_VALOR

						Elseif 	(cSrc)->RD_PD == '746' // Fgts RCT/
							_nV736   += (cSrc)->RD_VALOR

						Elseif 	(cSrc)->RD_PD == '747' // Fgts RCT/
							_nV736   += (cSrc)->RD_VALOR

						Endif	

					Endif	

				
				Endif	
				(cSrr)->(DbSkip())
			Enddo
			
			
			
			
			lIr := .f.

		Endif	


		// Folha e Pensao	

		If (cSrc)->RD_PD == '799' // Liquido
			_nV799 += (cSrc)->RD_VALOR

		Elseif (cSrc)->RD_PD == '442' // Adto.
			_nV799  += (cSrc)->RD_VALOR

		Elseif (cSrc)->RD_PD == '723' // IRPFAdto (-)
			_nV799  -= (cSrc)->RD_VALOR

		Elseif (cSrc)->RD_PD == '825' // Taxa estagiario
			_nV799  += (cSrc)->RD_VALOR

		Elseif (cSrc)->RD_PD == '492' // Consignado
			_nV799  += (cSrc)->RD_VALOR

		Elseif (cSrc)->RD_PD == '490' // Consignado
			_nV799  += (cSrc)->RD_VALOR

		Elseif (cSrc)->RD_PD == '440' // Pensao
			_nV440  += (cSrc)->RD_VALOR

		// compoem INSS
		Elseif (cSrc)->RD_PD == '425' // Faltas
			_nV425  += (cSrc)->RD_VALOR

		Elseif 	(cSrc)->RD_PD == '427' // Atrasos
			_nV427   += (cSrc)->RD_VALOR
			
		Elseif 	(cSrc)->RD_PD == '428' // Saida antecipada
			_nV428   += (cSrc)->RD_VALOR
			
		Elseif 	(cSrc)->RD_PD == '429' // DSR
			_nV429   += (cSrc)->RD_VALOR

		Elseif 	(cSrc)->RD_PD == '401' // ISS funcionario
			_nV401   += (cSrc)->RD_VALOR

		Elseif 	(cSrc)->RD_PD == '405' // ISS funcionario
			_nV401   += (cSrc)->RD_VALOR

		Elseif 	(cSrc)->RD_PD == '736' // Fgts funcionario
			_nV736   += (cSrc)->RD_VALOR

		Elseif 	(cSrc)->RD_PD == '723' // I.R adiantamento
			_nV723   += (cSrc)->RD_VALOR

		Elseif 	(cSrc)->RD_PD == '422' // SINDICATO
			_nV422   += (cSrc)->RD_VALOR

		// compoem Base INSS
		Elseif (cSrc)->RD_PD == '715' // 
			_nV715  += (cSrc)->RD_VALOR

		Elseif 	(cSrc)->RD_PD == '716' // 
			_nV715   += (cSrc)->RD_VALOR
			
		Elseif 	(cSrc)->RD_PD == '718' // 
			_nV715   += (cSrc)->RD_VALOR
			
		Elseif 	(cSrc)->RD_PD == '719' // DSR
			_nV715   += (cSrc)->RD_VALOR


		// Horas extras
		Elseif (cSrc)->RD_PD == '122' // DSR HORISTA         
			_nV122   += (cSrc)->RD_VALOR
						
		Elseif 	(cSrc)->RD_PD $ '105/106/107/108/109/110/111/116'
			_nV105   += (cSrc)->RD_VALOR

		Elseif 	(cSrc)->RD_PD == '112' // DIFERENCA HE VALOR  
			_nV112   += (cSrc)->RD_VALOR
			
		Elseif 	(cSrc)->RD_PD == '101' // Horas normais
			_nV101   += (cSrc)->RD_VALOR

		Elseif 	(cSrc)->RD_PD == '102' // Horas normais
			_nV102   += (cSrc)->RD_VALOR

		Elseif 	(cSrc)->RD_PD == '103' // Horas extras
			_nV103   += (cSrc)->RD_VALOR

		Endif	

		(cSrc)->(DbSkip())

	Enddo
	//_nBInss := (_nV122+_nV105+_nV112+_nV101+_nV102+_nV103) - (_nV425+_nV427+_nV428+_nV429)
	_nHextr := (_nV122+_nV105+_nV112)


	//@ Prow()   , 056 Psay _nV750   Picture "99"		
	//@ Prow()   , 059 Psay _nV124   Picture "99"		
	@ Prow()   , 064 Psay _cZemp
	//@ Prow()   , 070 Psay _nSal    Picture "@E 99,999.99"

	@ Prow()   , 080 Psay _nV799   Picture "@E 99,999.99"		
	@ Prow()   , 090 Psay _nV401   Picture "@E 99,999.99"
	@ Prow()   , 100 Psay ((_nV715*26.8844)/100)   Picture "@E 99,999.99"

	@ Prow()   , 110 Psay _nV736   Picture "@E 99,999.99"	
	@ Prow()   , 120 Psay _nHextr  Picture "@E 99,999.99"
	@ Prow()   , 130 Psay _nV440   Picture "@E 99,999.99"	// pensao
	@ Prow()   , 140 Psay _nv407   Picture "@E 99,999.99"	// i.r
	@ Prow()   , 150 Psay ((_nV715*2.5)/100)+_nV422  Picture "@E 99,999.99"

	@ Prow()   , 160 Psay _nV460   Picture "@E 99,999.99"	
	@ Prow()   , 170 Psay _nV403   Picture "@E 99,999.99"	
	//@ Prow()   , 180 Psay _nV409   Picture "@E 99,999.99"	
	@ Prow()   , 190 Psay ((_nV715f*26.8844)/100)  Picture "@E 99,999.99"	

    /*
	@ Prow()   , 200 Psay _nV442   Picture "@E 99,999.99"					
	@ Prow()   , 210 Psay _nV736   Picture "@E 99,999.99"					
	@ Prow()   , 220 Psay _nV144   Picture "@E 99,999.99"					
	@ Prow()   , 230 Psay _nV739   Picture "@E 99,999.99"					
    */
	
	_nT799 += _nV799
	
	_nHextr  := 0	   
	_nBInss  := 0
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
	_nV799   := 0
	_nV425   := 0
	_nV427   := 0
	_nV428   := 0
	_nV429   := 0
	_nV401   := 0
	_nV736   := 0
	_nV122   := 0
	_nV105   := 0
	_nV112   := 0
	_nV101   := 0
	_nV102   := 0
	_nV103   := 0 
	_nV105   := 0
	_nV440   := 0
	_nV715   := 0
	_nV723   := 0 
	_nV422   := 0	
	_nV460   := 0	
	_nV403   := 0	
	_nV409   := 0	
	_nV715f  := 0				

	lIr    := .t.
				
Enddo

_nV799   := 0	
DbSelectArea(cZrd) 
(cZrd)->(dbgotop())
While (cZrd)->(!eof())

	If Prow() > 64
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
	Endif
	@ Prow() +1, 001 Psay (cZrd)->ZRD_MAT
	@ Prow()   , 008 Psay Substr((cZrd)->ZRD_NOME,1,20)
	@ Prow()   , 030 Psay Substr((cZrd)->ZRD_CC,1,8)


	// Folha terceiros
	_nV799 += (cZrd)->ZRD_VALOR
	@ Prow()   ,080 Psay _nV799   Picture "@E 99,999.99"		
	
	(cZrd)->(DbSkip())
	
	_nT799   += _nV799
	_nV799   := 0	
Enddo

// Despesas Financeiros
_nV799   := 0	
DbSelectArea(cSe2) 
(cSe2)->(dbgotop())
While (cSe2)->(!eof())

	If Prow() > 64
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
	Endif
	@ Prow() +1, 001 Psay 'ZZZZZZ'
	@ Prow()   , 008 Psay Substr((cSe2)->E2_NOMFOR,1,20)
	@ Prow()   , 030 Psay (cSe2)->E2_XNAT

	// Folha terceiros
	_nV799 += (cSe2)->E2_VALOR
	@ Prow()   ,077 Psay _nV799   Picture "@E 9,999,999.99"		
	
	(cSe2)->(DbSkip())
	
	_nT799   += _nV799
	_nV799   := 0	
Enddo

@ Prow() +1, 000 PSAY __PrtThinLine() 
@ Prow() +1, 077 Psay _nT799   Picture "@E 9,999,999.99"		
@ Prow() +1, 000 PSAY __PrtThinLine() 
@ Prow() +2, 000 PSAY "" 

dbSelectArea(cSrc)
dbCloseArea()

Return

// 
static Function abreLanc(cSrc)
Local _cMesi,_cMesf
Local _dUdm, _cAno, _cMes, _cDia

_cDia := "01"
_cAno := Substr(mv_par06,1,4)
_cMes := Substr(mv_par06,5,2)
_dUdm := UltimoDia( Ctod(_cDia+"/"+_cMes+"/"+_cAno) )

_cMesi := mv_par06 + '01' // aaaammdd
_cMesf := Dtos(_dUdm)

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
	       SRA.RA_CODFUNC, 
	       SRA.RA_ZEMP,	       
	       SRD.RD_PD,
	       SRD.RD_VALOR,
	       SRD.RD_HORAS,
	       SRD.RD_CC
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
		SRD.RD_FILIAL  = %xFilial:SRC%
	and SRD.D_E_L_E_T_ = ' '
	and SRD.RD_DATPGT BETWEEN %Exp:_cMesi% AND %Exp:_cMesf%
	order by
		SRD.RD_MAT
endSql

Processa( {|| abreSe2(cSe2) },"Gerando Dados SRD.......") 
Processa( {|| abreSrd2(cSrd2) },"Gerando Dados SRD.......") 
Processa( {|| abreSrd3(cSrd3) },"Gerando Dados SRD.......") 
Processa( {|| abreSrr(cSrr) },  "Gerando Dados SRR.......")  
Processa( {|| abreZrd(cZrd) },  "Gerando Dados ZRD.......") 
Processa( {|| RptTmp() },"Imprimindo...")

Return 


// 
static Function abreSrd2(cSrd2)
Local _cMesi,_cMesf
Local _dUdm, _cAno, _cMes, _cDia

_cDia := "01"
_cAno := Substr(mv_par06,1,4)
_cMes := Substr(mv_par06,5,2)


If _cMes == '01'
	_cAno := StrZero(Val(Substr(mv_par06,1,4)) - 1,4)
	_cMes := '12'
Else
	_cAno := Substr(mv_par06,1,4) 
	_cMes := StrZero(Val(Substr(mv_par06,5,2)) - 1,4)
Endif

_cDia  := "01"
_dUdm  := UltimoDia( Ctod(_cDia+"/"+_cMes+"/"+_cAno) )
_cMesi := Dtos(Ctod(_cDia+"/"+_cMes+"/"+_cAno))
_cMesf := Dtos(_dUdm)


//_cMesi := Substring(mv_par06,1,4) + StrZero( Val( Substring(mv_par06,5,2)) - 1,2) + '01'
//_cMesf := Substring(mv_par06,1,4) + StrZero( Val( Substring(mv_par06,5,2)) - 1,2) + '30'

//--Fecha Alias Temporario se estiver aberto
If Select(cSrd2) > 0
	dbSelectArea(cSrd2)
	dbCloseArea()
Endif


//
beginSql Alias cSrd2
	select SRD.RD_MAT,
	       SRA.RA_NOME,
	       SRA.RA_CC,
	       SRA.RA_SALARIO,
	       SRA.RA_CATFUNC,
	       SRA.RA_CODFUNC, 
	       SRA.RA_ZEMP,	       
	       SRD.RD_PD,
	       SRD.RD_VALOR,
	       SRD.RD_HORAS,
	       SRD.RD_CC
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
	
	where              
		SRD.RD_FILIAL  = %xFilial:SRC%
	and SRD.D_E_L_E_T_ = ' '
	and SRD.RD_DATPGT BETWEEN %Exp:_cMesi% AND %Exp:_cMesf%
	and SRD.RD_PD IN ('723','409')
	order by
		SRD.RD_MAT
endSql

Return


// 
static Function abreSrd3(cSrd3)
Local _cMesi,_cMesf

_cDia := "01"
_cAno := Substr(mv_par06,1,4)
_cMes := Substr(mv_par06,5,2)

If _cMes == '01'
	_cAno := StrZero(Val(Substr(mv_par06,1,4)) - 1,4)
	_cMes := '12'
Else
	_cAno := Substr(mv_par06,1,4) 
	_cMes := StrZero(Val(Substr(mv_par06,5,2)) - 1,4)
Endif

_cDia  := "01"
_dUdm  := UltimoDia( Ctod(_cDia+"/"+_cMes+"/"+_cAno) )
_cMesi := Dtos(Ctod(_cDia+"/"+_cMes+"/"+_cAno))
_cMesf := Dtos(_dUdm)

//_cMesi := Substring(mv_par06,1,4) + StrZero( Val( Substring(mv_par06,5,2)) - 1,2) + '01'
//_cMesf := Substring(mv_par06,1,4) + StrZero( Val( Substring(mv_par06,5,2)) - 1,2) + '30'

//--Fecha Alias Temporario se estiver aberto
If Select(cSrd3) > 0
	dbSelectArea(cSrd3)
	dbCloseArea()
Endif

//
beginSql Alias cSrd3
	select SRD.RD_MAT,
	       SRA.RA_NOME,
	       SRA.RA_CC,
	       SRA.RA_SALARIO,
	       SRA.RA_CATFUNC,
	       SRA.RA_CODFUNC, 
	       SRA.RA_ZEMP,	       
	       SRD.RD_PD,
	       SRD.RD_VALOR,
	       SRD.RD_HORAS,
	       SRD.RD_CC
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
	
	where              
		SRD.RD_FILIAL  = %xFilial:SRC%
	and SRD.D_E_L_E_T_ = ' '
	and SRD.RD_DATPGT BETWEEN %Exp:_cMesi% AND %Exp:_cMesf%
	and SRD.RD_PD = '407'
	order by
		SRD.RD_MAT
endSql

Return

// 
static Function abreSrr(cSrr)
Local _cMesi,_cMesf
Local _dUdm, _cAno, _cMes, _cDia

_cDia  := "01"
_cAno  := Substr(mv_par06,1,4)
_cMes  := Substr(mv_par06,5,2)
_dUdm  := UltimoDia( Ctod(_cDia+"/"+_cMes+"/"+_cAno) )
_cMesi := mv_par06 + '01' // aaaammdd
_cMesf := Dtos(_dUdm)

//--Fecha Alias Temporario se estiver aberto
If Select(cSrr) > 0
	dbSelectArea(cSrr)
	dbCloseArea()
Endif

//--Consulta as Previsões de venda
beginSql Alias cSrr
	select SRR.RR_MAT,
	       SRR.RR_DATA,
	       SRR.RR_TIPO3,
	       SRR.RR_PD,
	       SRR.RR_VALOR
	from 
		%table:SRR% SRR
	where              
		SRR.RR_FILIAL  = %xFilial:SRR%
	and SRR.D_E_L_E_T_ = ' '
	and SRR.RR_DATA BETWEEN %Exp:_cMesi% AND %Exp:_cMesf%
	order by
		SRR.RR_MAT
endSql

Return 

// 
static Function abreZrd(cZrd)
Local _cMesi,_cMesf
Local _dUdm, _cAno, _cMes, _cDia

_cDia  := "01"
_cAno  := Substr(mv_par06,1,4)
_cMes  := Substr(mv_par06,5,2)
_dUdm  := UltimoDia( Ctod(_cDia+"/"+_cMes+"/"+_cAno) )
_cMesi := mv_par06 + '01' // aaaammdd
_cMesf := Dtos(_dUdm)

//--Fecha Alias Temporario se estiver aberto
If Select(cZrd) > 0
	dbSelectArea(cZrd)
	dbCloseArea()
Endif

//--Consulta as Previsões de venda
beginSql Alias cZrd
	select ZRD.ZRD_MAT,
	       ZRD.ZRD_DATA,
	       ZRD.ZRD_NOME,
	       ZRD.ZRD_VALOR,
	       ZRD.ZRD_CC,  
	       ZRD.ZRD_PD
	from 
		%table:ZRD% ZRD
	where              
		ZRD.ZRD_FILIAL  = %xFilial:ZRD%
	and ZRD.D_E_L_E_T_ = ' '
	and ZRD.ZRD_PD     = '799'
	and ZRD.ZRD_DATA BETWEEN %Exp:_cMesi% AND %Exp:_cMesf%
	order by
		ZRD.ZRD_MAT
endSql

Return 

 
// 
static Function abreSe2(cSe2)
Local _cMesi,_cMesf
Local _dUdm, _cAno, _cMes, _cDia

_cDia  := "01" 
_cAno  := Substr(mv_par06,1,4) 
_cMes  := Substr(mv_par06,5,2) 
_dUdm  := UltimoDia( Ctod(_cDia+"/"+_cMes+"/"+_cAno) ) 
_cMesi := mv_par06 + '01' // aaaammdd 
_cMesf := Dtos(_dUdm) 

//--Fecha Alias Temporario se estiver aberto
If Select(cSe2) > 0 
	dbSelectArea(cSe2) 
	dbCloseArea() 
Endif 

//--Consulta as Previsões de venda
beginSql Alias cSe2 
	select SE2.E2_NOMFOR,  
	  	   SE2.E2_FORNECE, 
	       SE2.E2_VENCREA, 
	       SE2.E2_VALOR, 
	       SE2.E2_XNAT 
	from  
		%table:SE2% SE2 
	where 
		SE2.E2_FILIAL  = %xFilial:SE2% 
	and SE2.D_E_L_E_T_ = ' '  
	and SE2.E2_XRH = 'S'
	and SE2.E2_VENCREA BETWEEN %Exp:_cMesi% AND %Exp:_cMesf% 
	order by
		SE2.E2_XNAT
endSql

Return 
