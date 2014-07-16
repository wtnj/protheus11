/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE090  ºAutor  ³Marcos R Roquitski  º Data ³  03/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Movimento mensal de terceiros (Pagamento e PPR).           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"  
#include "topconn.ch"

User Function Nhgpe090()

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
titulo    := "Pagamento de Terceiros"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "SRC"
nTipo     := 0
nomeprog  := "NHGPE090"
cPerg     := "NHGP80"
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
wnrel:= "NHGPE090"

SetPrint("ZRD",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

rptStatus({||Gerando()},"Gerando Base para o Relatorio...")

If Empty(TMP->ZRD_MAT)
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

If mv_par03 == 2
	cQuery := "SELECT * " 
	cQuery += "FROM " + RetSqlName( 'ZRD' ) + " ZRD " 
	cQuery += "WHERE ZRD.D_E_L_E_T_ <> '*' " 
	cQuery += "AND SUBSTRING(ZRD.ZRD_DATA,1,6) = '"+ Mv_par01 + "' "
	cQuery += "AND ZRD.ZRD_TIPO2 = 'P' "
	cQuery += "ORDER BY 2,4	"
	TCQUERY cQuery NEW ALIAS "TMP" 
	TcSetField("TMP","ZRD_DATA","D") // Muda a data de string para date.
Else
	cQuery := "SELECT * " 
	cQuery += "FROM " + RetSqlName( 'ZRD' ) + " ZRD " 
	cQuery += "WHERE ZRD.D_E_L_E_T_ <> '*' " 
	cQuery += "AND SUBSTRING(ZRD.ZRD_DATA,1,6) = '"+ Mv_par01 + "' "
	cQuery += "AND ZRD.ZRD_TIPO2 <> 'P' "
	cQuery += "ORDER BY 2,4	"
	TCQUERY cQuery NEW ALIAS "TMP" 
	TcSetField("TMP","ZRD_DATA","D") // Muda a data de string para date.
Endif
DbSelectArea("TMP")
Return


Static Function Imprime()
Local _nTotPro := _nTotDes := _nTotLiq := 0,_cZrc_Mat := Space(06) 
Local _nTogPro := _nTogDes := _nTogLiq := 0
TMP->(Dbgotop())

titulo    := "Pagamento de Terceiros " + IIF(mv_par03==1,"Folha Mensal","PPR")
Cabec1    := ""
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

While !TMP->(eof())
	If Prow() > 56
		nPag := nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif
	DbSelectArea("ZRA")
	ZRA->(DbSeek(xFilial("ZRA") +TMP->ZRD_MAT))
	If ZRA->(Found())
		If !Empty(Alltrim(ZRA->ZRA_SITFOLH))
			TMP->(DbSkip())
			Loop
		Endif	
		@ Prow() + 1, 000 Psay "C.CUSTO  : " + ZRA->ZRA_CCUSTO+SPACE(05)+"MATR.:"+TMP->ZRD_MAT+SPACE(05)+"NOME: "+TMP->ZRD_NOME+SPACE(05)+"ADMISSAO: "+DTOC(ZRA->ZRA_INICIO)
		@ Prow() + 1, 000 Psay "P R O V E N T O S"
		@ Prow()    , 045 Psay "D E S C O N T O S"
		@ Prow() + 1,000 Psay __PrtThinLine()
	Endif
    _cZrc_Mat  := TMP->ZRD_MAT

	While !TMP->(Eof()) .AND. TMP->ZRD_MAT == _cZrc_Mat
		If Prow() > 56
			nPag := nPag + 1
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
		Endif
		ZRV->(DbSeek(xFilial("ZRV") + TMP->ZRD_PD))
		If ZRV->(Found())
			If ZRV->ZRV_TIPOCO == "1" .AND. TMP->ZRD_PD <> "799"
				@ Prow() + 1, 000 Psay TMP->ZRD_PD
				@ Prow()    , 005 Psay TMP->ZRD_DESCP
				@ Prow()    , 030 Psay TMP->ZRD_VALOR  Picture "@E 9,999,999.99"
				_nTotpro += TMP->ZRD_VALOR
				_nTogpro += TMP->ZRD_VALOR
			Elseif ZRV->ZRV_TIPOCO == "2" .AND. TMP->ZRD_PD <> "799" 
				@ Prow() + 1, 045 Psay TMP->ZRD_PD
				@ Prow()    , 050 Psay TMP->ZRD_DESCP
				@ Prow()    , 080 Psay TMP->ZRD_VALOR  Picture "@E 9,999,999.99"
				_nTotdes += TMP->ZRD_VALOR
				_nTogdes += TMP->ZRD_VALOR
			Endif
		Endif				
		If TMP->ZRD_PD == "799"
			_nTotLiq += TMP->ZRD_VALOR
			_nTogLiq += TMP->ZRD_VALOR
		Endif
		TMP->(DbSkip())
	Enddo

    @ Prow() + 1,000 Psay __PrtThinLine()
    @ Prow() + 1,001 Psay "T O T A L: "
	@ Prow()    ,030 Psay _nTotPro Picture "@E 9,999,999.99"
	@ Prow()    ,080 Psay _nTotDes Picture "@E 9,999,999.99"
	@ Prow()    ,100 PSAY "Liquido: "+TRANSFORM(_nTotLiq,"@E 9,999,999.99")
	_nTotPro := _nTotDes := _nTotLiq := 0
	@ Prow() + 1,000 Psay __PrtThinLine()
	@ Prow() + 2,000 Psay ""
Enddo
@ Prow() + 1,001 Psay "TOTAL GERAL:"
@ Prow()    ,030 Psay _nTogPro Picture "@E 9,999,999.99"
@ Prow()    ,080 Psay _nTogDes Picture "@E 9,999,999.99"
@ Prow()    ,100 PSAY "Liquido: "+TRANSFORM(_nTogLiq,"@E 9,999,999.99")
@ Prow() + 1,000 Psay __PrtThinLine()

Return
