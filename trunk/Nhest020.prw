/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST020        ³ Luciane de P Correia  ³ Data ³ 03.01.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relacao de EPI'S.                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"   
#INCLUDE "TOPCONN.CH"
#IFNDEF WINDOWS
#DEFINE PSAY SAY
#ENDIF

User Function nhest020() 

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO,LRET")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC,_CMATR")
SetPrvt("CNORMAL,LPRIMEIRO,CQUERY,_CCCUSTO,_CPRODUTO,_NTOTALPROD")

cSavCur1 := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont   := "";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem   := 0
tamanho  := "M"
limite   := 132
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey := 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Ficha de Entrega de EPI"
cDesc1   := " "
cDesc2   := " "
cDesc3   := " "
cString  := "SZ7"
nTipo    := 15
nomeprog := "NHEST020"
cPerg    := "NHES31"
nPag     := 1
M_Pag    := 1
Msg1	   := "   Declaro estar ciente de que o material abaixo especificado é de exclusiva propriedade da New Hubner Componentes Automotivos"
Msg2	   := "Ltda., bem como, de que é obrigatório o seu uso se o serviço assim o exigir."
Msg3     := "   Pelo qual comprometo-me:"
Msg4     := "1º - A fazer uso dos equipamentos de proteção recomendados pela empresa."
Msg5	   := "2º - Zelar pela guarda e boa conservação dos mesmos."
Msg6	   := "3º - Restituí-los, ou seu valor correspondente, a empresa no caso de:"
Msg7	   := "   - Transferência de função ou setor que não mais necessite o seu uso.
Msg8	   := "   - Na eventualidade de me afastar do trabalho."
Msg9	   := "   - No caso de extravio ou dano causado pelo mau uso."
Msg10	   := "4º - A recusa em usar os EPIs gerará punição prevista em lei (CLT art. 482)."
Msg11	   := "   Declaro, ainda, que recebi treinamento sobre o uso do EPI e estou de pleno acordo com as normas dos equipamentos de proteção"
Msg12	   := "individual, descritos abaixo."
cabec1   := " ITEM      CODIGO                              DESCRIMINAÇÃO                               DATA        QTDE             VISTO       "
cabec2   := "------   ----------   ---------------------------------------------------------------   ----------   --------   --------------------"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros:                                                  ³
//³ mv_par01     Da Ficha                                        ³
//³ mv_par02     Ate a Ficha                                     ³
//³ mv_par03     Do Funcionario                                  ³
//³ mv_par04     Ate Funcionario                                 ³
//³ mv_par05     Da Data                                         ³
//³ mv_par06     Ate a Data                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Abertura dos Arquivos
SZ7->(DbSetOrder(1)) // Filial + Numero + Item

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= "NHEST020"
Pergunte(cPerg,.f.)
SetPrint(cString,NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se deve comprimir ou nao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ntipo     := IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))
nRos      := SM0->M0_CGC
aDriver   := ReadDriver()
cCompac   := aDriver[1]
cNormal   := aDriver[2]
lPrimeiro := .T.

rptStatus({||Gerando()},"Gerando Base para o Relatorio...")

TZ7->(DbCloseArea())
Return


Static Function Gerando()

	cQuery := "SELECT * "
	cQuery := cQuery + " FROM  "+RETSQLNAME("SZ7")
	cQuery := cQuery + " WHERE Z7_FILIAL = '" + xFilial("SZ7")+ "' AND" 
	cQuery := cQuery + " Z7_NUMERO BETWEEN '" + Mv_par01 + "' AND '" + Mv_par02 + "' AND"
	cQuery := cQuery + " Z7_MATR BETWEEN '" + Mv_par03 + "' AND '" + Mv_par04 + "' AND"
	cQuery := cQuery + " Z7_DATA BETWEEN '" + DtoS(Mv_par05) + "' AND '" + DtoS(Mv_par06) + "' AND"
	cQuery := cQuery + " Z7_PRODUTO BETWEEN '" + Mv_par07 + "' AND '" + Mv_par08 + "' AND"
	cQuery := cQuery + " D_E_L_E_T_ = '' "
	cQuery := cQuery + " ORDER BY Z7_MATR+Z7_DATA+Z7_ITEM+Z7_PRODUTO"

	//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TZ7"
	DbSelectArea("TZ7")

Processa( {|| Imprime() } )

Return

Static Function Imprime()

// SetRegua(TRB->(RecCount()))
TZ7->(DbGoTop())

lPrimeiro := .T.

Cabec(Titulo,Cabec1,Cabec2,Nomeprog,Tamanho,nTipo)
// Imprime mensagem inicial

lRet := .T.

While TZ7->(!Eof())

	If Prow() > 55
		Cabec(Titulo,Cabec1,Cabec2,Nomeprog,Tamanho,nTipo)
	Endif

	If lRet
		If !Empty(TZ7->Z7_NOMETER) 
			@ prow()+1,00 Psay "Matricula: "+TZ7->Z7_MATR+" "+TZ7->Z7_NOME+" "+TZ7->Z7_NOMETER + " Depto: "+TZ7->Z7_DESCRCC
		Else
			@ prow()+1,00 Psay "Matricula: "+TZ7->Z7_MATR+" "+TZ7->Z7_NOME + " Depto: "+TZ7->Z7_DESCRCC
		EndIf
		@ prow()+1,00 Psay " "
	   lRet := .F.
	Endif

   // Imprime os dados
	@ Prow() + 1, 002 Psay TZ7->Z7_ITEM
	@ Prow()    , 010 Psay TZ7->Z7_PRODUTO
	@ Prow()    , 024 Psay TZ7->Z7_DESC
	@ Prow()    , 088 Psay Stod(TZ7->Z7_DATA)
	@ Prow()    , 104 Psay TZ7->Z7_QUANT Picture "@E999999"
	@ Prow()    , 112 Psay Replicate("_",18) 

	_cMATR := TZ7->Z7_MATR + TZ7->Z7_NOMETER

	TZ7->(DbSkip())

	If _cMATR <> TZ7->Z7_MATR + TZ7->Z7_NOMETER
	   @ Prow()+1,00 Psay Replicate("-",132)
		@ prow()+1,00 Psay " "
		lRet := .T.
	Endif			

Enddo
@ prow()+1,00 Psay " "


If aReturn[5] == 1
   Set Printer To
   Commit
   Ourspool(wnrel) //Chamada do Spool de Impressao
Endif

MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function Cabecalho()

aDriver := ReadDriver()

If ( Tamanho == 'P' )
    @ 0,0 PSAY &(aDriver[1])
ElseIf ( Tamanho == 'G' )
    @ 0,0 PSAY &(aDriver[5])
ElseIf ( Tamanho == 'M' ) .And. ( aReturn[4] == 1 ) 
    @ 0,0 PSAY &(aDriver[3])
ElseIf ( Tamanho == 'M' ) .And. ( aReturn[4] == 2 ) 
    @ 0,0 PSAY &(aDriver[4])
EndIf 
cabec1 := ""
cabec2 := "ITEM   CODIGO   DESCRIMINAÇÃO                              DATA       QTDE   VISTO      "    
cabec3 := "----   ------   ----------------------------------------   --------   ----   -----------"
@ prow()+1,00 Psay Repli("*",132)
@ prow()+1,00 Psay "*"+SM0->M0_NOMECOM
@ prow(),112 Psay "Folha : "                                                                                                    
@ prow(),124 Psay StrZero(nPag,5,0)+"  *"
@ prow()+1,00 Psay "*S.I.G.A. / "+nomeprog
@ prow(),20 Psay PadC(titulo,82)
@ prow(),112 Psay "DT.Ref.: "+Dtoc(dDataBase)+"  *"
@ prow()+1,00 Psay "*Hora...: "+Time()
@ prow(),112 Psay "Emissao: "+Dtoc(Date())+"  *"
@ prow()+1,00 Psay Repli("*",132)
@ prow()+1,00 Psay " "
@ prow()+1,00 Psay cabec1
@ prow()+1,00 Psay cabec2
@ prow()+1,00 Psay cabec3
Return


