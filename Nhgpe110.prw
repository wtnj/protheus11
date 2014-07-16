/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE110  ºAutor  ³Marcos R Roquitski  º Data ³  25/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Provisao de Ferias.                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"  
#include "topconn.ch"

User Function Nhgpe110()

SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC")
SetPrvt("CNORMAL,LPRIMEIRO,CQUERY,_CCUSTO")

cSavCur1  := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont    := "";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem    := 0
tamanho   := "G"
limite    := 210
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "Provisao: Ferias, 13o. e  PPR"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "SRC"
nTipo     := 0
nomeprog  := "NHGPE110"
cPerg     := "GPE110"
nPag      := 1
M_PAG     := 1 
tot01     := 0 
tot02     := 0 
tot03     := 0 
tot04     := 0 

If !Pergunte(cPerg,.T.) //ativa os parametros
	Return(nil)
Endif
							

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= "NHGPE110"

SetPrint("ZRA",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

rptStatus({||Gerando()},"Gerando Base para o Relatorio...")

If Empty(TMP->ZRA_MAT)
   MsgBox("Nenhum Ocorrencia ","Atençao","ALERT")  
   DbSelectArea("TMP")
   DbCloseArea("TMP")
   Return
Endif

If mv_par01 = 1
	RptStatus({||ImpGrupo()},"Imprimindo...")

Elseif mv_par01 = 2
	RptStatus({||ImpCusto()},"Imprimindo...")

Elseif mv_par01 = 3
	If cUserName $ 'CARLOSEC/MARCOSR/MARCIOTS'

		RptStatus({||ImpInd()},"Imprimindo...")

	Else
	
		Alert("Relatorio exclusivo do RH !")
		 	
	Endif

Endif

//	RptStatus({||ImpInd()},"Imprimindo...")



Set Filter To
If aReturn[5] == 1

	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
DbSelectArea("TMP")
DbCloseArea("TMP")
MS_FLUSH() //Libera fila de relatorios em spool

Return


//
Static Function Gerando()

cQuery := "SELECT * " 
cQuery += "FROM " + RetSqlName( 'ZRA' ) + " ZRA " 
cQuery += "WHERE ZRA.D_E_L_E_T_ <> '*' " 
cQuery += "AND ZRA.ZRA_FILIAL = '" + xFilial("ZRA")+ "'" 
cQuery += "AND ZRA.ZRA_FIM  = '' "

If mv_par02 == 1 //Palmeira
	cQuery += "AND ZRA.ZRA_TIPOFJ  = '7' "

Elseif mv_par02 == 2 // Curitiba
	cQuery += "AND ZRA.ZRA_TIPOFJ  = '8' "

Elseif mv_par02 == 3 // Gloria de Goita
	cQuery += "AND ZRA.ZRA_TIPOFJ  = '9' "

Endif


If mv_par01 == 1
	cQuery += "ORDER BY ZRA.ZRA_GRUPO "
Elseif mv_par01 == 2
	cQuery += "ORDER BY ZRA.ZRA_CCUSTO,ZRA.ZRA_TIPOFJ"
Elseif mv_par01 == 3
	cQuery += "ORDER BY ZRA.ZRA_MAT"
Else
	cQuery += "ORDER BY ZRA.ZRA_MAT"
Endif	


TCQUERY cQuery NEW ALIAS "TMP" 
TcSetField("TMP","ZRA_INICIO","D") // Muda a data de string para date.
TcSetField("TMP","ZRA_FIM","D")

DbSelectArea("TMP")
Return
MARCOSR	

Static Function ImpGrupo()
Local  _nSalario :=_nSalFer := _nUmTerco := _nTotFer := _nMeses := _nSalFto := _nTotTer := 0
Local  _cDescd := Space(30)
Local  _Grupo  := Space(03)
Local  _nSalDec := _nValDec := _nTotDec := _nValPpr := 0
Local _nGer1 := _nGer2 := _nGer3 := _nGer4 := _nGer5 := _nGer6 := 0
TMP->(Dbgotop())
                          
Cabec1    := "Centro de Custo                                Salarios         Ferias           13o.            PPR          Total"
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

While !TMP->(eof())

	If Prow() > 56
		nPag := nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif

    _cGrupo := TMP->ZRA_GRUPO 
    
	While !TMP->(Eof()) .AND. TMP->ZRA_GRUPO == _cGrupo
        

		_nSalFer := TMP->ZRA_SALARI
		_nSalDec := TMP->ZRA_SALARI

		_nTotDec  +=  (TMP->ZRA_SALARI / 12)
		_nUmTerco += (_nSalFer / 3)
	   	_nTotTer  += _nUmTerco
		_nTotFer  += ((_nSalFer /3) / 12)
		_nSalFto  += _nSalfer
		_nSalario += TMP->ZRA_SALARI
		_nSalFer  := _nMeses := _nUmTerco := _nValDec := 0
		_nValPpr  += (((TMP->ZRA_SALARI * TMP->ZRA_PPR ) / 100)/12)

		/////////////

		If     TMP->ZRA_GRUPO == 'ADM'
			_cDescd := 'ADMINISTRATIVO'
        
		Elseif TMP->ZRA_GRUPO == 'PRD'
			_cDescd := 'PRODUTIVO'

		Endif

		TMP->(DbSkip())
		
	Enddo

	_nGer1 += _nSalario
	_nGer2 += _nTotFer
	_nGer3 += _nTotDec
	_nGer4 += _nValPpr 
	_nGer5 += (_nSalario + _nTotFer + _nTotDec + _nValPpr) 
	_nGer6 += _nGer5
		
	@ Prow() + 1,001 Psay _cDescd
	@ Prow()    ,045 Psay _nSalario Picture "@E 999,999.99"
	@ Prow()    ,060 Psay _nTotFer  Picture "@E 999,999.99"
	@ Prow()    ,075 Psay _nTotDec  Picture "@E 999,999.99"
	@ Prow()    ,090 Psay _nValPpr  Picture "@E 999,999.99"
	@ Prow()    ,105 Psay _nGer5    Picture "@E 999,999.99"

    @ Prow() + 1,000 Psay __PrtThinLine()
	@ Prow() + 2,000 Psay ""

	_nUmTerco := _nTotFer := _nSalario := _nSalFer := _nMeses := _nSalFto := _nTotTer := _nTotDec := _nValPpr := _nGer5 := 0

Enddo
@ Prow() + 1,001 Psay "Total Geral"
@ Prow()    ,045 Psay _nGer1    Picture "@E 999,999.99"
@ Prow()    ,060 Psay _nGer2    Picture "@E 999,999.99"
@ Prow()    ,075 Psay _nGer3    Picture "@E 999,999.99"
@ Prow()    ,090 Psay _nGer4    Picture "@E 999,999.99"
//@ Prow()    ,102 Psay _nGer6    Picture "@E 99,999,999.99"
@ Prow() + 1,000 Psay __PrtThinLine()
@ Prow() + 2,000 Psay ""
                                                                       
Return
 


Static Function ImpCusto()
Local  _nSalario :=_nSalFer := _nUmTerco := _nTotFer := _nMeses := _nSalFto := _nTotTer := 0
Local  _cDescd := Space(30)
Local  _Grupo  := Space(03)
Local  _nSalDec := _nValDec := _nTotDec := _nValPpr := 0
Local _nGer1 := _nGer2 := _nGer3 := _nGer4 := _nGer5 := _nGer6 := 0
TMP->(Dbgotop())
                                             
If mv_par02 == 1 //Palmeira
	titulo    += " Filial: Palmeira"

Elseif mv_par02 == 2 // Curitiba
	titulo    += " Filial: Curitiba"

Elseif mv_par02 == 3 // Gloria de Goita
	titulo    += " Filial: Gloria de Goita"

Endif


Cabec1    := "C. Custo       Descricao                                                               Salarios         Ferias           13o.            PPR          Total"
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

While !TMP->(eof())

	If Prow() > 56
		nPag := nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif

    _cCusto := TMP->ZRA_CCUSTO 
    
	While !TMP->(Eof()) .AND. TMP->ZRA_CCUSTO == _cCusto
        
		_nSalFer := TMP->ZRA_SALARI
		_nSalDec := TMP->ZRA_SALARI

		_nTotDec  +=  (TMP->ZRA_SALARI / 12)
		_nUmTerco += (_nSalFer / 3)
	   	_nTotTer  += _nUmTerco
		_nTotFer  += ((_nSalFer /3) / 12)
		_nSalFto  += _nSalfer
		_nSalario += TMP->ZRA_SALARI
		_nSalFer  := _nMeses := _nUmTerco := _nValDec := 0
		_nValPpr  += (((TMP->ZRA_SALARI * TMP->ZRA_PPR ) / 100)/12)


		_cDesc2 := Space(30)
		CTT->(DbSeek(xFilial("CTT")+TMP->ZRA_CCUSTO))
		If CTT->(Found())
			_cDesc2 := TMP->ZRA_CCUSTO + " " + Substr(CTT->CTT_DESC01,1,25)
		Endif	
		TMP->(DbSkip())
		
	Enddo

	_nGer1 += _nSalario
	_nGer2 += _nTotFer
	_nGer3 += _nTotDec
	_nGer4 += _nValPpr 
	_nGer5 += (_nSalario + _nTotFer + _nTotDec + _nValPpr) 
	_nGer6 += _nGer5
		
	@ Prow() + 1,001 Psay _cDesc2
	@ Prow()    ,085 Psay _nSalario Picture "@E 999,999.99"
	@ Prow()    ,100 Psay _nTotFer  Picture "@E 999,999.99"
	@ Prow()    ,115 Psay _nTotDec  Picture "@E 999,999.99"
	@ Prow()    ,130 Psay _nValPpr  Picture "@E 999,999.99"
	@ Prow()    ,145 Psay _nGer5    Picture "@E 999,999.99"

	/*
	If 		TMP->ZRA_TIPOFJ == '7'
		@ Prow()    ,156 Psay "Palmeira"
	Elseif	TMP->ZRA_TIPOFJ == '8'
		@ Prow()    ,156 Psay "Curitiba"	
	Elseif	TMP->ZRA_TIPOFJ == '9'
		@ Prow()    ,156 Psay "Gloria de Goita"		
	Endif
    */
    
   // @ Prow() + 1,000 Psay __PrtThinLine()
	@ Prow() + 2,000 Psay ""

	_nUmTerco := _nTotFer := _nSalario := _nSalFer := _nMeses := _nSalFto := _nTotTer := _nTotDec := _nValPpr := _nGer5 := 0

Enddo
@ Prow() + 1,001 Psay "Total Geral"
@ Prow()    ,083 Psay _nGer1    Picture "@E 9,999,999.99"
@ Prow()    ,098 Psay _nGer2    Picture "@E 9,999,999.99"
@ Prow()    ,113 Psay _nGer3    Picture "@E 9,999,999.99"
@ Prow()    ,128 Psay _nGer4    Picture "@E 9,999,999.99"
@ Prow()    ,143 Psay _nGer6    Picture "@E 9,999,999.99"
@ Prow() + 1,000 Psay __PrtThinLine()
@ Prow() + 2,000 Psay ""
                                                                       
Return
 

Static Function ImpInd()
Local  _nSalario :=_nSalFer := _nUmTerco := _nTotFer := _nMeses := _nSalFto := _nTotTer := 0
Local  _cDescd := Space(30)
Local  _Grupo  := Space(03)
Local  _nSalDec := _nValDec := _nTotDec := _nValPpr := 0
Local _nGer1 := _nGer2 := _nGer3 := _nGer4 := _nGer5 := _nGer6 := 0
Local _cLocal := Space(20)
TMP->(Dbgotop())
                          
Cabec1    := "Mat. Nome                                                                              Salarios         Ferias           13o.            PPR          Total Unidade"
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

While !TMP->(eof())

	If Prow() > 56
		nPag := nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif

    _cCusto := TMP->ZRA_MAT
    
	While !TMP->(Eof()) .AND. TMP->ZRA_MAT == _cCusto
        
		_nSalFer := TMP->ZRA_SALARI
		_nSalDec := TMP->ZRA_SALARI

		_nTotDec  +=  (TMP->ZRA_SALARI / 12)
		_nUmTerco += (_nSalFer / 3)
	   	_nTotTer  += _nUmTerco
		_nTotFer  += ((_nSalFer /3) / 12)
		_nSalFto  += _nSalfer
		_nSalario += TMP->ZRA_SALARI
		_nSalFer  := _nMeses := _nUmTerco := _nValDec := 0
		_nValPpr  += (((TMP->ZRA_SALARI * TMP->ZRA_PPR ) / 100)/12)


		_cDesc2 := Space(30)
		CTT->(DbSeek(xFilial("CTT")+TMP->ZRA_CCUSTO))
		If CTT->(Found())
			_cDesc2 := TMP->ZRA_CCUSTO + " " + Substr(CTT->CTT_DESC01,1,25)
		Endif	
		_cDescd := TMP->ZRA_MAT + " " + Substr(TMP->ZRA_NOME,1,30) + '  ' + _cDesc2


		If 		TMP->ZRA_TIPOFJ == '7'
			_cLocal := "Palmeira"
		Elseif	TMP->ZRA_TIPOFJ == '8'
			_cLocal := "Curitiba"	
		Elseif	TMP->ZRA_TIPOFJ == '9'
			_cLocal := "Gloria de Goita"		
		Endif

		TMP->(DbSkip())

		
	Enddo

	_nGer1 += _nSalario
	_nGer2 += _nTotFer
	_nGer3 += _nTotDec
	_nGer4 += _nValPpr 
	_nGer5 += (_nSalario + _nTotFer + _nTotDec + _nValPpr) 
	_nGer6 += _nGer5
		
	@ Prow() + 1,001 Psay _cDescd
	@ Prow()    ,085 Psay _nSalario Picture "@E 999,999.99"
	@ Prow()    ,100 Psay _nTotFer  Picture "@E 999,999.99"
	@ Prow()    ,115 Psay _nTotDec  Picture "@E 999,999.99"
	@ Prow()    ,130 Psay _nValPpr  Picture "@E 999,999.99"
	@ Prow()    ,145 Psay _nGer5    Picture "@E 999,999.99"
	@ Prow()    ,156 Psay _cLocal
	_cLocal := Space(20)		

   // @ Prow() + 1,000 Psay __PrtThinLine()
	@ Prow() + 2,000 Psay ""

	_nUmTerco := _nTotFer := _nSalario := _nSalFer := _nMeses := _nSalFto := _nTotTer := _nTotDec := _nValPpr := _nGer5 := 0

Enddo
@ Prow() + 1,001 Psay "Total Geral"
@ Prow()    ,082 Psay _nGer1    Picture "@E  99,999,999.99"
@ Prow()    ,097 Psay _nGer2    Picture "@E  99,999,999.99"
@ Prow()    ,113 Psay _nGer3    Picture "@E  9,999,999.99"
@ Prow()    ,128 Psay _nGer4    Picture "@E  9,999,999.99"
@ Prow()    ,141 Psay _nGer6    Picture "@E 999,999,999.99"
@ Prow() + 1,000 Psay __PrtThinLine()
@ Prow() + 2,000 Psay ""
                                                                       
Return



