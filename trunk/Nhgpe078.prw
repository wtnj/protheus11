/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE078  ºAutor  ³Marcos R Roquitski  º Data ³  21/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Movimento mensal de terceiros.                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"  
#include "topconn.ch"

User Function Nhgpe078()   

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
titulo    := "Pagamento de Terceiros "
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "SRC"
nTipo     := 0
nomeprog  := "NHGPE078"
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
wnrel:= "NHGPE078"

SetPrint("ZRC",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

rptStatus({||Gerando()},"Gerando Base para o Relatorio...")

If Empty(TMP->ZRC_MAT)
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
cQuery += "FROM " + RetSqlName( 'ZRC' ) + " ZRC " 
cQuery += "WHERE ZRC.D_E_L_E_T_ <> '*' " 
cQuery += "AND ZRC.ZRC_MAT BETWEEN '"+ Mv_par01 + "' AND '"+ Mv_par02 + "' "
cQuery += "ORDER BY 2,4		 "
TCQUERY cQuery NEW ALIAS "TMP" 
TcSetField("TMP","ZRC_DATA","D") // Muda a data de string para date.


DbSelectArea("TMP")
Return


Static Function Imprime()
Local _nTotPro := _nTotDes := _nTotLiq := 0,_cZrc_Mat := Space(06) 
Local _nTogPro := _nTogDes := _nTogLiq := 0
TMP->(Dbgotop())
  
Titulo += "do periodo: "+MesExtenso(MONTH(Ddatabase))+"/"+STRZERO(YEAR(Ddatabase),4)
//Titulo += "do periodo: "+MesExtenso(MONTH(TMP->ZRC_DATA))+"/"+STRZERO(YEAR(TMP->ZRC_DATA),4)
Cabec1 := ""
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

While !TMP->(eof())
	If Prow() > 56
		nPag := nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif
	DbSelectArea("ZRA")
	ZRA->(DbSeek(xFilial("ZRA") +TMP->ZRC_MAT))
	If ZRA->(Found())
		If !Empty(Alltrim(ZRA->ZRA_SITFOLH))
			TMP->(DbSkip())
			Loop
		Endif	
		@ Prow() + 1, 000 Psay "C.CUSTO  : " + ZRC->ZRC_CC+SPACE(05)+"MATR.:"+TMP->ZRC_MAT+SPACE(05)+"NOME: "+TMP->ZRC_NOME+SPACE(05)+"ADMISSAO: "+DTOC(ZRA->ZRA_INICIO)
		@ Prow() + 1, 000 Psay "P R O V E N T O S"
		@ Prow()    , 045 Psay "D E S C O N T O S"
		@ Prow() + 1,000 Psay __PrtThinLine()
	Endif
    _cZrc_Mat  := TMP->ZRC_MAT


	While !TMP->(Eof()) .AND. TMP->ZRC_MAT == _cZrc_Mat
		If Prow() > 56
			nPag := nPag + 1
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
		Endif
		ZRV->(DbSeek(xFilial("ZRV") + TMP->ZRC_PD))
		If ZRV->(Found())
			If ZRV->ZRV_TIPOCO == "1" .AND. TMP->ZRC_PD <> "799"
				@ Prow() + 1, 000 Psay TMP->ZRC_PD
				@ Prow()    , 005 Psay TMP->ZRC_DESCPD
				@ Prow()    , 030 Psay TMP->ZRC_VALOR  Picture "@E 9,999,999.99"
				_nTotpro += TMP->ZRC_VALOR
				_nTogpro += TMP->ZRC_VALOR
			Elseif ZRV->ZRV_TIPOCO == "2" .AND. TMP->ZRC_PD <> "799"
				@ Prow() + 1, 045 Psay TMP->ZRC_PD
				@ Prow()    , 050 Psay TMP->ZRC_DESCPD
				@ Prow()    , 080 Psay TMP->ZRC_VALOR  Picture "@E 9,999,999.99"
				_nTotdes += TMP->ZRC_VALOR
				_nTogdes += TMP->ZRC_VALOR
			Endif
		Endif				
		If TMP->ZRC_PD == "799"
			_nTotLiq += TMP->ZRC_VALOR
			_nTogLiq += TMP->ZRC_VALOR
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
