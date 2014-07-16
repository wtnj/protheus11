/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE257  ºAutor  ³Marcos R Roquitski  º Data ³  14/06/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio quantidade de funcionarios no mes base.          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"                                                                     
#include "protheus.ch"

User Function Nhgpe257()

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
nomeprog  := "NHGPE257"
cPerg     := ""
nPag      := 1
m_pag     := 1
wnrel	  := "NHGPE257"
aOrd 	  := {"Matricula","Centro de Custo","Nome"}

If !Pergunte("NHGPE257",.T.)
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

Local _nFun     := 0, _cNumero, _cNmbanco := Space(40)
Local _nVlrTot  := 0
Local _cDesccc  := Space(25)
Local _cDescfu  := Space(25)
Local _cPerBase := Substr(Dtos(dDataBase),1,6)	
Local _nAfast   := 0
Local _nFerias  := 0
Local _nFem     := 0
Local _nMas     := 0
Local _nDefi    := 0
Local _cSitFol  := Space(01)   
Local _nDir     := 0
Local _nInd     := 0
Local _nAdm     := 0
Local _nAf2     := 0
DbSelectArea("SRA")
Set Filter to ((SRA->RA_CC >= mv_par01 .AND. SRA->RA_CC <= mv_par02) .AND. (SRA->RA_MAT >= mv_par03 .AND. SRA->RA_MAT <= mv_par04))
SRA->(Dbgotop())	
SRJ->(DbSetOrder(1))
CTT->(DbSetOrder(1))
SR8->(DbSetOrder(1))

Cabec1    := "Unid.  Empresa      Categoria           C\Custo   Descricao                     Mat.  Nome                                                  Admissao       Funcao Descricao                 Salario  Sit. MO    Def.  Sexo"
cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)                                                                                                    

While !SRA->(eof())

	If SRA->RA_FILIAL <> SM0->M0_CODFIL
		SRA->(DbSkip())
		Loop
	Endif	
		
	    
	If SRA->RA_CATFUNC $ 'H/M/E/G' .AND. Empty(SRA->RA_DEMISSA) 


		If Prow() > 60
			nPag := nPag + 1
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
		Endif
	
		If CTT->(DbSeek(xFilial("CTT")+SRA->RA_CC),Found())
			_cDesccc := SUBSTR(CTT->CTT_DESC01,1,25)
		Endif

		If SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC),Found())
			_cDescfu := SRJ->RJ_DESC
		Endif 

		@ Prow() + 1, 000 Psay 	SM0->M0_CODIGO
                                                   
		If SM0->M0_CODIGO == 'IT'
			@ Prow()    , 007 Psay 	'ITESAPAR    '

		Else


			If 	Alltrim(SRA->RA_CC) == '54002001'
				@ Prow()    , 007 Psay 	'USINAGEM    '

			Elseif Alltrim(SRA->RA_CC) == '54002002'
				@ Prow()    , 007 Psay 	'USINAGEM    '			
			
			Else

				If SRA->RA_ZEMP == '2'
					@ Prow()    , 007 Psay 	'FUNDICAO F. '

				Elseif 	SRA->RA_ZEMP == '3'
					@ Prow()    , 007 Psay 	'USINAGEM    '
				
				Elseif 	SRA->RA_ZEMP == '4'
					@ Prow()    , 007 Psay 	'FORJARIA    '

				Elseif 	SRA->RA_ZEMP == '5'
					@ Prow()    , 007 Psay 	'VIRABREQUIM '

				Elseif 	SRA->RA_ZEMP == '6'
					@ Prow()    , 007 Psay 	'FUNDICAO A. '

				Elseif 	SRA->RA_ZEMP == '7'
					@ Prow()    , 007 Psay 	'PERNAMBUCO  '
	
				Endif			

			Endif				
				
				
		Endif	
			
		If    SRA->RA_CATFUNC == 'A' 
			@ Prow()    , 020 Psay 'AUTONOMO      '

		Elseif	SRA->RA_CATFUNC == 'C' 
			@ Prow()    , 020 Psay 'COMISSIONADO  '

		Elseif SRA->RA_CATFUNC == 'D' 
			@ Prow()    , 020 Psay 'DIARISTA      '

		Elseif SRA->RA_CATFUNC == 'E' 
			@ Prow()    , 020 Psay 'ESTAG. MENSAL '
			
		Elseif SRA->RA_CATFUNC == 'G' 
			@ Prow()    , 020 Psay 'ESTAG. HORISTA'

		Elseif SRA->RA_CATFUNC == 'H' 

			If SRA->RA_CODFUNC = '1193'
				@ Prow()    , 020 Psay 'APRENDIZ      '
			Else
				@ Prow()    , 020 Psay 'HORISTA       '
			Endif	

		Elseif SRA->RA_CATFUNC == 'I' 
				@ Prow()    , 020 Psay 'PROF. MENSAL  '
			
		Elseif SRA->RA_CATFUNC == 'J' 
				@ Prow()    , 020 Psay 'PROF. AULISTA '

		Elseif SRA->RA_CATFUNC == 'M' 
			If SRA->RA_CODFUNC = '1193'
				@ Prow()    , 020 Psay 'APRENDIZ      '
			Else
				@ Prow()    , 020 Psay 'MENSALISTA    '
			Endif	
			
		Elseif SRA->RA_CATFUNC == 'P' 
				@ Prow()    , 020 Psay 'PRO-LABORE    '

		Elseif SRA->RA_CATFUNC == 'S' 
				@ Prow()    , 020 Psay 'SEMANALISTA   '

		Elseif SRA->RA_CATFUNC == 'T' 
				@ Prow()    , 020 Psay 'TAREFEIRO     '

		Endif	
		
		@ Prow()    , 040 Psay 	SRA->RA_CC
		@ Prow()    , 050 Psay 	_cDesccc
		@ Prow()    , 080 Psay 	SRA->RA_MAT
		@ Prow()    , 087 Psay 	SRA->RA_NOME

		@ Prow()    , 140 Psay 	SRA->RA_ADMISSA
		@ Prow()    , 155 Psay 	SRA->RA_CODFUNC
		@ Prow()    , 160 Psay 	_cDescfu               

		If 	   SRA->RA_CATFUNC == 'M'
			@ Prow()    , 185 Psay 	SRA->RA_SALARIO Picture "@E 999,999.99"
				
		Elseif SRA->RA_CATFUNC == 'H'
			@ Prow()    , 185 Psay 	(SRA->RA_SALARIO * SRA->RA_HRSMES) Picture "@E 999,999.99"
			
		Else
			@ Prow()    , 185 Psay 	SRA->RA_SALARIO Picture "@E 999,999.99"
								
		Endif	

			//
		_cSitFol  := Space(01)
	
		If SRA->RA_SITFOLH == 'A' 

			SR8->(Dbseek(xFilial("SR8")+SRA->RA_MAT)) 
			While !SR8->(Eof()) .AND. SR8->R8_MAT == SRA->RA_MAT 
				If SR8->R8_TIPO <> 'F' 
					If Empty(SR8->R8_DATAFIM) 
						_cSitFol  := SRA->RA_SITFOLH 

					Elseif Substr(Dtos(SR8->R8_DATAFIM),1,6) == Substr(Dtos(dDataBase),1,6) 
						_cSitFol  := ' ' 

					Elseif Substr(Dtos(SR8->R8_DATAFIM),1,6) <> Substr(Dtos(dDataBase),1,6) 
						_cSitFol  := ' ' 
							
					Endif 

				Endif 
				SR8->(DbSkip()) 
			Enddo 

		Elseif SRA->RA_SITFOLH == 'F' 

			SR8->(Dbseek(xFilial("SR8")+SRA->RA_MAT)) 
			While !SR8->(Eof()) .AND. SR8->R8_MAT == SRA->RA_MAT
				If SR8->R8_TIPO == 'F'
					If Substr(Dtos(SR8->R8_DATAFIM),1,6) == Substr(Dtos(dDataBase),1,6) 
						_cSitFol  := ' ' 

					Elseif Substr(Dtos(SR8->R8_DATAFIM),1,6) <> Substr(Dtos(dDataBase),1,6)
						_cSitFol  := 'F'
							
					Endif

				Endif
				SR8->(DbSkip())
			Enddo

		Endif

		If     _cSitFol == 'F'
			_nFerias++                     
		Elseif _cSitFol == 'A'
			_nAfast++                     
		Else
			_nFun++
		Endif	

		@ Prow()    , 198 Psay _cSitFol
			
		If Substr(SRA->RA_CC,6,3) == "999"
			@ Prow()    , 201 Psay "AFASTADO"
			If _cSitFol == 'A'
				_nAf2++
			Endif	

		Elseif Substr(SRA->RA_CC,2,1) $ "1/2"

			@ Prow()    , 201 Psay "ADM     "
			_nAdm++ 

		Elseif 	Substr(SRA->RA_CC,2,1) == "3"

			If 		Alltrim(SRA->RA_CC) $ '23001002' // ADM
				@ Prow()    , 201 Psay "ADM     "
				_nAdm++ 

			Elseif Alltrim(SRA->RA_CC) $ '23006002/23006005' // DIRETO
				@ Prow()    , 201 Psay "DIRETO  "	
				_nDir++ 

			Else			
				@ Prow()    , 201 Psay "INDIRETO"
				_nInd++

			Endif

			// 23001002 - ADM
			// 23002002 - DIRETO
			// 23006002 - DIRETO
			// 23006005 - DIRETO
			// 13001001 - INDIRETO - EMRPESA = 2
			// 13001002 - INDIRETO

		Elseif 	Substr(SRA->RA_CC,2,1) == "4" 
			@ Prow()    , 201 Psay "DIRETO  "	
			_nDir++ 

		Endif 
		

		// 23008001 - ADM
		// 23001002 - ADM
		// 23002002 - DIRETO
		// 23006002 - DIRETO
		// 23006005 - DIRETO
		// 13001001 - INDIRETO - EMRPESA = 2
		// 13001002 - INDIRETO


		@ Prow()    , 210 Psay IIF(SRA->RA_DEFIFIS=="1","SIM","NAO")

		If 	SRA->RA_DEFIFIS == "1";_nDefi++
		Endif
		
		@ Prow()    , 215 Psay SRA->RA_SEXO

		If     SRA->RA_SEXO = 'F'
			_nFem++
		
		Elseif SRA->RA_SEXO = 'M'
			_nMas++	
		
		Endif
	Endif	

	SRA->(DbSkip())

Enddo
@ Prow() + 1,000 Psay __PrtThinLine()
@ Prow() + 1,000 Psay "Funcionarios ATIVOS   : "+TRANSFORM(_nFun,"99999")
@ Prow() + 1,000 Psay "             FERIAS   : "+TRANSFORM(_nFerias,"99999")
@ Prow() + 1,000 Psay "             AFASTADOS: "+TRANSFORM(_nAfast,"99999")
@ Prow() + 1,000 Psay "=============================="
@ Prow() + 1,000 Psay "TOTAL GERAL           : "+TRANSFORM(_nFun + _nFerias + _nAfast,"99999")
@ Prow() + 1,000 Psay __PrtThinLine()
@ Prow() + 1,000 Psay "Funcionarios FEMININO : "+TRANSFORM(_nFem,"99999")
@ Prow() + 1,000 Psay "             MASCULINO: "+TRANSFORM(_nMas,"99999")
@ Prow() + 1,000 Psay __PrtThinLine()
@ Prow() + 1,000 Psay "Funcionarios D. Fisico: "+TRANSFORM(_nDefi,"99999")
@ Prow() + 1,000 Psay __PrtThinLine()
@ Prow() + 1,000 Psay "Funcionarios Direto   : "+TRANSFORM(_nDir,"99999")
@ Prow() + 1,000 Psay "             Indireto : "+TRANSFORM(_nInd,"99999")
@ Prow() + 1,000 Psay "             Adm      : "+TRANSFORM(_nAdm,"99999")
@ Prow() + 1,000 Psay "             Afastados: "+TRANSFORM(_nAf2,"99999")
@ Prow() + 1,000 Psay __PrtThinLine()





DbSelectArea("SRA")
Set Filter to
SRA->(Dbgotop())	

Return
