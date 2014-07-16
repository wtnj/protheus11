/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE085  ºAutor  ³Marcos R Roquitski  º Data ³  22/05/07   º±±
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

User Function Nhgpe085()

SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC")
SetPrvt("CNORMAL,LPRIMEIRO,CQUERY,")

cSavCur1  := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont    := "";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem    := 0
tamanho   := "P"
limite    := 85
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "FERIAS VENCIDAS"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "SRC"
nTipo     := 0
nomeprog  := "NHGPE085"
cPerg     := "GPE074"
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
wnrel:= "NHGPE085"

SetPrint("ZRH",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

rptStatus({||Gerando()},"Gerando Base para o Relatorio...")

If Empty(TMP->ZRH_MAT)
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

cQuery := "SELECT * " 
cQuery += "FROM " + RetSqlName( 'ZRH' ) + " ZRH " 
cQuery += "WHERE ZRH.D_E_L_E_T_ <> '*' " 
cQuery += "AND ZRH.ZRH_MAT BETWEEN '"+ Mv_par01 + "' AND '"+ Mv_par02 + "' "
cQuery += "ORDER BY 2,7,8	 "
TCQUERY cQuery NEW ALIAS "TMP" 
TcSetField("TMP","ZRH_DATABA","D") // Muda a data de string para date.
TcSetField("TMP","ZRH_DBASEA","D")
TcSetField("TMP","ZRH_DATAIN","D")
TcSetField("TMP","ZRH_DATAFI","D")
TcSetField("TMP","ZRH_ADMISS","D")

DbSelectArea("TMP")
Return


Static Function Imprime()
Local _nTotferve := _nTotferia := _nTotdfol := 0
TMP->(Dbgotop())
                          
Cabec1    := ""
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

While !TMP->(eof())
	If Prow() > 56
		nPag := nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif
	DbSelectArea("ZRA")
	ZRA->(DbSeek(xFilial("ZRA") +TMP->ZRH_MAT))
	If ZRA->(Found())
		If !Empty(Alltrim(ZRA->ZRA_SITFOLH))
			TMP->(DbSkip())
			Loop
		Endif	
		@ Prow() + 1, 000 Psay "MATR.:"+TMP->ZRH_MAT+SPACE(05)+"NOME: "+TMP->ZRH_NOME+SPACE(05)+"ADMISSAO: "+DTOC(ZRA->ZRA_INICIO)
		@ Prow() + 1, 000 Psay "Periodo Aquisitivo   F.Vencidas  Periodo de Ferias         F.Pagas      A Pagar"
		@ Prow() + 1,000 Psay __PrtThinLine()
	Endif
    _cZrc_Mat  := TMP->ZRH_MAT


	While !TMP->(Eof()) .AND. TMP->ZRH_MAT == _cZrc_Mat

		If Prow() > 56
			nPag := nPag + 1
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
		Endif
		
		If  TMP->ZRH_DFERIA < 30
		
			@ Prow() + 1, 000 Psay TMP->ZRH_DATABA
			@ Prow()    , 012 Psay TMP->ZRH_DBASEA		 
			@ Prow()    , 025 Psay TMP->ZRH_DFERVE Picture "@E 999.99"
			@ Prow()    , 033 Psay TMP->ZRH_DATAIN
			@ Prow()    , 045 Psay TMP->ZRH_DATAFI
			@ Prow()    , 060 Psay TMP->ZRH_DFERIA Picture "@E 999.99"
			_nTotferve += TMP->ZRH_DFERVE
			_nTotferia += TMP->ZRH_DFERIA

		Endif					
		TMP->(DbSkip())

	Enddo


    @ Prow() + 1,000 Psay __PrtThinLine()
	@ Prow() + 1,001 Psay "T O T A L"
	@ Prow()    ,025 Psay _nTotferve Picture "@E 999.99"
	@ Prow()    ,060 Psay _nTotferia Picture "@E 999.99"
	@ Prow()    ,073 Psay (_nTotferve - _nTotferia) Picture "@E 999.99"
    @ Prow() + 1,000 Psay __PrtThinLine()
	@ Prow() + 2,000 Psay ""
	_nTotferve := _nTotferia := _nTotdfol := 0
Enddo
@ Prow() + 1,000 Psay __PrtThinLine()
                                                                            
Return
