/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE093  ºAutor  ³Marcos R Roquitski  º Data ³  24/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Inclusao ao Plano AMIL.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"  
#include "topconn.ch"

User Function Nhgpe093()

SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC")
SetPrvt("CNORMAL,LPRIMEIRO,CQUERY,")

cSavCur1  := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont    := "";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem    := 0
tamanho   := "M"
limite    := 132
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "Funcionarios/Dependentes Plano de Saude"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "SRA"
nTipo     := 0
nomeprog  := "NHGPE093"
cPerg     := "GPE093"
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
//³ Parametros:                                                  ³
//³ mv_par01     Codigo do Funcionario                           ³
//³ mv_par02     Periodo de                                      ³
//³ mv_par03     Periodo ate                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= "NHGPE093"

SetPrint("SRA",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

rptStatus({||Gerando()},"Gerando Base para o Relatorio...")

If Empty(TMP->RA_MAT)
   MsgBox("Nenhum Ocorrencia ","Atençao","ALERT")  
   DbSelectArea("TMP")
   DbCloseArea("TMP")
   Return
Endif

rptStatus({||Imprime()},"Imprimindo...")

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
DbSelectArea("TMP")
DbCloseArea("TMP")
MS_FLUSH() //Libera fila de relatorios em spool

Return


Static Function Gerando()

	cQuery  := " SELECT * FROM " + RetSqlName( 'SRA' ) + " RA "
    cQuery  += " WHERE RA.RA_FILIAL = '" + xFilial("SRA")+ "'"
    cQuery  += " AND RA.RA_ADMISSA BETWEEN '" + Dtos(mv_par01) + "' AND '" + Dtos(mv_par02) + "' "
    cQuery  += " AND RA.RA_CC BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
    cQuery  += " AND RA.RA_MAT BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
    cQuery  += " AND RA.RA_DTASME BETWEEN '" + Dtos(mv_par07) + "' AND '" + Dtos(mv_par08) + "' "

	If mv_par11 == 1
	    cQuery  += " AND RA.RA_ASMEDIC <> ' ' "
	Endif	    

    cQuery  += " AND RA.RA_SITFOLH <> 'D' "
    cQuery  += " AND RA.D_E_L_E_T_ = ' ' "
    
	TCQUERY cQuery NEW ALIAS "TMP"  
	TcSetField("TMP","RA_ADMISSA","D") // Muda a data de string para date.
	TcSetField("TMP","RA_DTASME","D") // Muda a data de string para date.
	TcSetField("TMP","RA_NASC","D") // Muda a data de string para date.
	DbSelectArea("TMP")

Return


Static Function Imprime()
Local lRet := .t.
TMP->(Dbgotop())
Cabec1 := "Mat.      Nome                            Dt.Nasc.  Sexo  Plano Grau          Dt.Inclusao" 
SRB->(DbSetOrder(1))                        
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
While !TMP->(eof())

	If Prow() > 56
		nPag := nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif

	@ Prow() + 1, 000 Psay TMP->RA_MAT 
	@ Prow()    , 010 Psay TMP->RA_NOME
	@ Prow()    , 042 Psay TMP->RA_NASC  
	@ Prow()    , 055 Psay TMP->RA_SEXO
	@ Prow()    , 058 Psay TMP->RA_ASMEDIC
	@ Prow()    , 078 Psay TMP->RA_DTASME 
	@ Prow() + 1,000 Psay __PrtThinLine()

	SRB->(DbSeek(xFilial("SRB") + TMP->RA_MAT))
	While !SRB->(Eof()) .AND. SRB->RB_MAT == TMP->RA_MAT

		If mv_par11 == 1 .AND. Empty(SRB->RB_ASMEDIC)
			SRB->(DbSkip())
			Loop
		Endif

		If     mv_par12 == 1 .AND. SRB->RB_GRAUPAR <> "C"
			SRB->(DbSkip())
			Loop

		Elseif mv_par12 == 2 .AND. SRB->RB_GRAUPAR <> "F"
			SRB->(DbSkip())
			Loop
		
		Elseif mv_par12 == 3 .AND. SRB->RB_GRAUPAR <> "E"
			SRB->(DbSkip())
			Loop

		Elseif mv_par12 == 4 .AND. SRB->RB_GRAUPAR <> "P"
			SRB->(DbSkip())
			Loop


		Endif

		
		_nIdade := (Year(DATE()) - Year(SRB->RB_DTNASC))

		If Month(SRB->RB_DTNASC) > Month(Date())
			_nIdade--

		Elseif Month(SRB->RB_DTNASC) == Month(Date()) .AND. Day(SRB->RB_DTNASC) > Day(Date())
			_nIdade--
			
		Endif
		
		If _nIdade >= mv_par09 .AND. _nIdade <= mv_par10

			@ Prow() + 1, 000 Psay SRB->RB_MAT 		
			@ Prow()    , 010 Psay SRB->RB_NOME
			@ Prow()    , 042 Psay SRB->RB_DTNASC
			@ Prow()    , 055 Psay SRB->RB_SEXO
			@ Prow()    , 058 Psay SRB->RB_ASMEDIC

			If SRB->RB_GRAUPAR == "C"
				@ Prow()    , 064 Psay "Conjuge     "

			Elseif SRB->RB_GRAUPAR == "F"
				@ Prow()    , 064 Psay "Filho       "
		
			Elseif SRB->RB_GRAUPAR == "E"
				@ Prow()    , 064 Psay "Enteado     "
	
			Elseif SRB->RB_GRAUPAR == "P"
				@ Prow()    , 064 Psay "Companheiro "
	
			Else  
				@ Prow()    , 064 Psay "Outros      "

			Endif	
			@ Prow()    , 078 Psay Transform(_nIdade,"999")+ " Anos"
			lRet := .F.

		Endif
		SRB->(DbSkip())
			
	Enddo
	If !lRet
		@ Prow() + 2 , 000 Psay ''
		lRet := .T.
	Endif
	TMP->(Dbskip())

Enddo
@ Prow() + 1,000 Psay __PrtThinLine()

Return
