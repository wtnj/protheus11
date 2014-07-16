/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE087  ºAutor  ³Marcos R Roquitski  º Data ³  22/05/07   º±±
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

User Function Nhgpe087()

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
titulo    := "FOLGAS DO PERIODO"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "SRC"
nTipo     := 0
nomeprog  := "NHGPE087"
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
wnrel:= "NHGPE087"

SetPrint("ZRI",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

rptStatus({||Gerando()},"Gerando Base para o Relatorio...")

If Empty(TMP->ZRI_MAT)
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
cQuery += "FROM " + RetSqlName( 'ZRI' ) + " ZRI " 
cQuery += "WHERE ZRI.D_E_L_E_T_ <> '*' " 
cQuery += "AND ZRI.ZRI_MAT BETWEEN '"+ Mv_par01 + "' AND '"+ Mv_par02 + "' "
cQuery += "ORDER BY 2,3,4"
TCQUERY cQuery NEW ALIAS "TMP" 
TcSetField("TMP","ZRI_DTINI","D") // Muda a data de string para date.
TcSetField("TMP","ZRI_DTFIM","D")

DbSelectArea("TMP")
Return


Static Function Imprime()
Local _nTotferia := 0
TMP->(Dbgotop())
                          
Cabec1    := ""
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

While !TMP->(eof())
	If Prow() > 56
		nPag := nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif
	DbSelectArea("ZRA")
	ZRA->(DbSeek(xFilial("ZRA") +TMP->ZRI_MAT))
	If ZRA->(Found())
		If !Empty(Alltrim(ZRA->ZRA_SITFOLH))
			TMP->(DbSkip())
			Loop
		Endif	
		@ Prow() + 1, 000 Psay "MATR.:"+ZRA->ZRA_MAT+SPACE(05)+"NOME: "+ZRA->ZRA_NOME+SPACE(05)+"ADMISSAO: "+DTOC(ZRA->ZRA_INICIO)
		@ Prow() + 1, 000 Psay "Data Inicio   Data final   Nr.Dias  Observacao"
		@ Prow() + 1,000 Psay __PrtThinLine()
	Endif
    _cZrc_Mat  := TMP->ZRI_MAT


	While !TMP->(Eof()) .AND. TMP->ZRI_MAT == _cZrc_Mat

		If Prow() > 56
			nPag := nPag + 1
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
		Endif
		
		@ Prow() + 1, 000 Psay TMP->ZRI_DTINI 
		@ Prow()    , 014 Psay TMP->ZRI_DTFIM 		 
		@ Prow()    , 030 Psay TMP->ZRI_DFOL   Picture "999"
		@ Prow()    , 037 Psay TMP->ZRI_OBS    
		_nTotferia += TMP->ZRI_DFOL

		TMP->(DbSkip())

	Enddo
    @ Prow() + 1,000 Psay __PrtThinLine()
	@ Prow() + 1,001 Psay "T O T A L"
	@ Prow()    ,030 Psay _nTotferia Picture "999"
    @ Prow() + 1,000 Psay __PrtThinLine()
	@ Prow() + 2,000 Psay ""
	_nTotferia := 0

Enddo
@ Prow() + 1,000 Psay __PrtThinLine()
                                                                            
Return
