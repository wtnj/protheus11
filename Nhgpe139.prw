/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE139  ºAutor  ³Marcos R Roquitski  º Data ³  23/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Total de Funcionarios + Dependentes.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"  
#include "topconn.ch"

User Function Nhgpe139()

SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM,TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO,NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC,CNORMAL,LPRIMEIRO,CQUERY,")

cSavCur1  := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont    := "";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem    := 0
tamanho   := "P"
limite    := 80 
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "Funcionario+Dependente no Plano de Saude"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "SRA"
nTipo     := 0
nomeprog  := "NHGPE139"
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
wnrel:= "NHGPE139"

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
    cQuery  += " AND RA.RA_CC BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
    cQuery  += " AND RA.RA_MAT BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
    cQuery  += " AND RA.RA_ASMEDIC <> ' ' "
    cQuery  += " AND RA.RA_SITFOLH <> 'D' "
    cQuery  += " AND RA.D_E_L_E_T_ = ' ' "
    
	TCQUERY cQuery NEW ALIAS "TMP"  
	TcSetField("TMP","RA_ADMISSA","D") // Muda a data de string para date.
	TcSetField("TMP","RA_DTASME","D") // Muda a data de string para date.
	TcSetField("TMP","RA_NASC","D") // Muda a data de string para date.
	DbSelectArea("TMP")

Return


Static Function Imprime()
Local _nSoma := _nSomap1 := _nSomap2 := _nTotal := 0
TMP->(Dbgotop())
Cabec1 := "Mat.      Nome                                         Plano (Titular+Dependente)" 
SRB->(DbSetOrder(1))                        
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
While !TMP->(eof())
	If Prow() > 56
		nPag := nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif

	@ Prow() + 1, 000 Psay TMP->RA_MAT 
	@ Prow()    , 010 Psay TMP->RA_NOME
	@ Prow()    , 058 Psay TMP->RA_ASMEDIC

	If TMP->RA_ASMEDIC == '01'
		_nSomap1++
		_nSoma++
	Elseif TMP->RA_ASMEDIC == '02'
		_nSomap2++	
		_nSoma++		
	Endif	
	
	SRB->(DbSeek(xFilial("SRB") + TMP->RA_MAT))
	While !SRB->(Eof()) .AND. SRB->RB_MAT == TMP->RA_MAT

		If !Empty(SRB->RB_ASMEDIC)
			If SRB->RB_ASMEDIC == '01'
				_nSomap1++		
				_nSoma++				
			Elseif SRB->RB_ASMEDIC == '02'
				_nSomap2++					
				_nSoma++
			Endif	
		Endif
		SRB->(DbSkip())
			
	Enddo
	@ Prow() , 076 Psay _nSoma Picture "9999"
	_nTotal += _nSoma
	_nSoma := 0
	TMP->(Dbskip())

Enddo
@ Prow() + 1,000 Psay __PrtThinLine()
@ Prow() + 1,050 Psay "Total    Plano 01:
@ Prow()    ,076 Psay _nSomap1 Picture "9999"

@ Prow() + 1,050 Psay "         Plano 02:
@ Prow()    ,076 Psay _nSomap2 Picture "9999"

@ Prow() + 1,000 Psay __PrtThinLine()
@ Prow() + 1,050 Psay "Geral Plano 01+02:
@ Prow()    ,076 Psay _nTotal  Picture "9999"
@ Prow() + 1,000 Psay __PrtThinLine()
	
Return
