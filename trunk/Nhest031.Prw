/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST031        ³ Luciane de P Correia  ³ Data ³ 03.01.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ficha de Entrega de EPI                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"   
#INCLUDE "TOPCONN.CH"

User Function nhest031() 

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC")
SetPrvt("CNORMAL,LPRIMEIRO,CQUERY,_CCCUSTO,_CPRODUTO,_NTOTALPROD")



cSavCur1   := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont     := "";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem     := 0
tamanho    := "M"
limite     := 132
aReturn    := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey   := 0
cRodaTxt   := ""
nCntImpr   := 0
titulo     := "Ficha de Entrega de EPI"
cDesc1     := " "
cDesc2     := " "
cDesc3     := " "
cString    := "SZ7"
nTipo      := 15
nomeprog   := "NHEST031"
cPerg      := "NHES31"
nPag       := 1
M_Pag      := 1
Msg1	   := "   Declaro estar ciente de que o material abaixo especificado é de exclusiva propriedade da "+SM0->M0_NOMECOM
Msg2	   := "   bem como, de que é obrigatório o seu uso se o serviço assim o exigir."
Msg3       := "   Pelo qual comprometo-me:"
Msg4       := "1º - A fazer uso dos equipamentos de proteção recomendados pela empresa."
Msg5	   := "2º - Zelar pela guarda e boa conservação dos mesmos."
Msg6	   := "3º - Restituí-los, ou seu valor correspondente, a empresa no caso de:"
Msg7	   := "   - Transferência de função ou setor que não mais necessite o seu uso.
Msg8	   := "   - Na eventualidade de me afastar do trabalho."
Msg9	   := "   - No caso de extravio ou dano causado pelo mau uso."
Msg10	   := "4º - A recusa em usar os EPIs gerará punição prevista em lei (CLT art. 482)."
Msg11	   := "   Declaro, ainda, que recebi treinamento sobre o uso do EPI e estou de pleno acordo com as normas dos equipamentos de proteção"
Msg12	   := "individual, descritos abaixo."
cabec1     := ""
cabec2     := "ITEM    CODIGO                    DESCRIMINAÇÃO                                                 DATA      QTDE          VISTO       "
cabec3     := "----  -----------  ------------------------------------------------------------------------   ---------   -----   -------------------"

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
SRA->(DbSetOrder(1))
SI3->(DbSetOrder(1))
SB5->(DbSetOrder(1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= "NHEST031"
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
	cQuery := cQuery + " FROM " + RetSqlName( 'SZ7' ) + " SZ7 "
	cQuery := cQuery + " WHERE Z7_FILIAL = '" + xFilial("SZ7")+ "' AND" 
	cQuery := cQuery + " Z7_NUMERO BETWEEN '" + Mv_par01 + "' AND '" + Mv_par02 + "' AND"
	cQuery := cQuery + " Z7_MATR BETWEEN '" + Mv_par03 + "' AND '" + Mv_par04 + "' AND"
	cQuery := cQuery + " Z7_DATA BETWEEN '" + DtoS(Mv_par05) + "' AND '" + DtoS(Mv_par06) + "' AND"
	cQuery := cQuery + " Z7_PRODUTO BETWEEN '" + Mv_par07 + "' AND '" + Mv_par08 + "' AND" 
	cQuery := cQuery + " Z7_CC      BETWEEN '" + Mv_par09 + "' AND '" + Mv_par10 + "' AND"	
	cQuery := cQuery + " D_E_L_E_T_ <> '*' "
	cQuery := cQuery + " ORDER BY Z7_MATR+Z7_DATA+Z7_ITEM+Z7_PRODUTO"

	//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TZ7"
	DbSelectArea("TZ7")

Processa( {|| Imprime() } )

Return

Static Function Imprime()
Local _cDescc, _cMat
// SetRegua(TRB->(RecCount()))
TZ7->(DbGoTop())

lPrimeiro := .T.

While TZ7->(!Eof())

	Cabec(Titulo,Cabec1,Cabec2,Nomeprog,Tamanho,nTipo)

	// Imprime mensagem inicial
	@ prow()+1,00 Psay Msg1
	@ prow()+1,00 Psay Msg2
	@ prow()+1,00 Psay Msg3
	@ prow()+1,00 Psay Msg4
	@ prow()+1,00 Psay Msg5
	@ prow()+1,00 Psay Msg6
	@ prow()+1,00 Psay Msg7
	@ prow()+1,00 Psay Msg8
	@ prow()+1,00 Psay Msg9
	@ prow()+1,00 Psay Msg10
	@ prow()+1,00 Psay Msg11
	@ prow()+1,00 Psay Msg12

	_cDescc := SPACE(30)
	If QAA->(Dbseek(xFilial("QAA") + TZ7->Z7_MATR))
		If CTT->(DbSeek(xFilial("CTT") + QAA->QAA_CC))
			_cDescc := ALLTRIM(QAA->QAA_CC) + ' - ' + CTT->CTT_DESC01
		Endif
	Endif	

	Msg13	 := "Ficha Nº:    "+TZ7->Z7_NUMERO
	Msg14	 := "Matrícula:   "+TZ7->Z7_MATR+"                                   Nome:  "+TZ7->Z7_NOME
	Msg15	 := "Depto:       "+_cDescc

	cabec1 := ""
	cabec2 := "ITEM    CODIGO                    DESCRIMINAÇÃO                                                 DATA      QTDE          VISTO       "
	cabec3 := "----  -----------  ------------------------------------------------------------------------   ---------   -----   -------------------"

	@ prow()+2,00 Psay Msg13
	@ prow()+1,00 Psay Msg14
	@ prow()+1,00 Psay Msg15
	@ Prow()+2,00 Psay Replicate("*",132)
	@ prow()+1,00 Psay cabec1
	@ prow()+1,00 Psay cabec2
	@ prow()+1,00 Psay cabec3

	_cMat := TZ7->Z7_MATR
	While TZ7->(!Eof()) .AND. TZ7->Z7_MATR == _cMat

		If Prow() > 70
			Cabec(Titulo,Cabec1,Cabec2,Nomeprog,Tamanho,nTipo)
		Endif
	
	   // Imprime os dados
		@ Prow() + 1, 001 Psay TZ7->Z7_ITEM 
		@ Prow()    , 006 Psay ALLTRIM(TZ7->Z7_PRODUTO)    
		If SB5->(DbSeek(xFilial("SB5") + TZ7->Z7_PRODUTO))	
		   @ Prow()    , 019 Psay Subs(SB5->B5_CEME,1,72)  
		Else
	       @ Prow()    , 019 Psay Subs(TZ7->Z7_DESC,1,72)	
		Endif
	   
		@ Prow()    , 094 Psay StoD(TZ7->Z7_DATA)
		@ Prow()    , 108 Psay TZ7->Z7_QUANT Picture "@E9999"
		@ Prow()    , 114 Psay Replicate("_",18) 
		TZ7->(DbSkip())

	Enddo

Enddo
@ prow()+1,00 Psay " "


If aReturn[5] == 1
   Set Printer To
   Commit
   Ourspool(wnrel) //Chamada do Spool de Impressao
Endif

MS_FLUSH() //Libera fila de relatorios em spool

Return

