#INCLUDE "LIBRPAR2.CH"
//#Include "FIVEWIN.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LIBRpar2³ Autor ³ Lucas             ³ Data ³ 02.08.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Livro de Entradas e Saidas para Paraguay - Ley 125/91-92  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ LIBR012(void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Localizacoes Paraguay...                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function LIBRPar2()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cDesc1  := STR0001
LOCAL cDesc2  := STR0002
LOCAL cDesc3  := STR0003
LOCAL wnrel
LOCAL limite  := 132
LOCAL Tamanho := "M"
LOCAL cString := "SF3"

PRIVATE titulo := STR0004
PRIVATE cabec1 := ""
PRIVATE cabec2 := ""
PRIVATE aReturn := { STR0005, 1, STR0006 , 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:= "LIBRPAR2"
PRIVATE aLinha := {},nLastKey := 0
PRIVATE cPerg := "LIB012"

AjustaSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("LIB012",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "LIBRPAR2"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho,"",.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| LF012Imp(@lEnd,wnRel,cString)},If(mv_par03==1,STR0008,STR0009))

Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
Endif
MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LF012Imp ³ Autor ³ Lucas                 ³ Data ³ 11.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Razonete de Cliente/Fornecedores                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ LF012Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LF012Imp( lEnd,wnRel,cString )

LOCAL CbCont,CbTxt
LOCAL tamanho :="M"
LOCAL nImpostos := 0
LOCAL nGravadas := 0
LOCAL nExentas := 0
LOCAL nTotal := 0
LOCAL aResumo := {{0.00, 0.00, 0.00},;
						{0.00, 0.00, 0.00},;
						{0.00, 0.00, 0.00},;
						{0.00, 0.00, 0.00}}

LOCAL aTotal  := {{0.00, 0.00, 0.00, 0.00},;
				   {0.00, 0.00, 0.00, 0.00}}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

cabec1   := "PERIODO  DE  "+DTOC(mv_par01)+"  AL  "+DTOC(mv_par02)
cabec1   := Space((132-Len(cabec1))/2) + cabec1

If mv_par03 == 1
	Titulo := STR0008
	cabec2 := STR0010
else
	Titulo := STR0009
	cabec2 := STR0011
Endif
//	             012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
//              0         1         2         3         4         5         6         7         8         9        10        11        12        13
//              NUMERO         FECHA      RAZON SOCIAL/APELLIDOS     R.U.C                GRAVADAS       IMPUESTOS         EXENTAS             TOTAL
//              999999999 XXX 99/99/99 D  XXXXXXXXXXXXXXXXXXXXXXXXXX XXXX-99999999 999.999.999.999 999.999.999.999 999.999.999.999 9.999.999.999.999
//              999999999 XXX 99/99/99 In XXXXXXXXXXXXXXXXXXXXXXXXXX XXXX-99999999 999.999.999.999 999.999.999.999 999.999.999.999 9.999.999.999.999
//              999999999 XXX 99/99/99 In XXXXXXXXXXXXXXXXXXXXXXXXXX XXXX-99999999 999.999.999.999 999.999.999.999 999.999.999.999 9.999.999.999.999
//              999999999 XXX 99/99/99 In XXXXXXXXXXXXXXXXXXXXXXXXXX XXXX-99999999 999.999.999.999 999.999.999.999 999.999.999.999 9.999.999.999.999
//              999999999 XXX 99/99/99 D  XXXXXXXXXXXXXXXXXXXXXXXXXX XXXX-99999999 999.999.999.999 999.999.999.999 999.999.999.999 9.999.999.999.999

//	             012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
//              0         1         2         3         4         5         6         7         8         9        10        11        12        13
//              NUMERO        TIPO     FECHA   RAZON SOCIAL/APELLIDOS     R.U.C            GRAVADAS       IMPUESTOS         EXENTAS             TOTAL
//              999999999 XXX Xxxxxxx 99/99/99 XXXXXXXXXXXXXXXXXXXXXX XXXX-99999999 999.999.999.999 999.999.999.999 999.999.999.999 9.999.999.999.999
//              999999999 XXX Xxxxxxx 99/99/99 XXXXXXXXXXXXXXXXXXXXXX XXXX-99999999 999.999.999.999 999.999.999.999 999.999.999.999 9.999.999.999.999
//              999999999 XXX Xxxxxxx 99/99/99 XXXXXXXXXXXXXXXXXXXXXX XXXX-99999999 999.999.999.999 999.999.999.999 999.999.999.999 9.999.999.999.999
//              999999999 XXX Xxxxxxx 99/99/99 XXXXXXXXXXXXXXXXXXXXXX XXXX-99999999 999.999.999.999 999.999.999.999 999.999.999.999 9.999.999.999.999

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cKeySF3 := "F3_FILIAL+DTOS(F3_ENTRADA)+F3_SERIE+F3_NFISCAL"
cFiltro	:=	IIf(MV_PAR06==1,'F3_FILIAL=="'+xFilial("SF3")+'".AND.','')
If mv_par03 == 1
   cFiltro += 'DTOS(F3_ENTRADA)>="'+DTOS(mv_par01)+'".AND.DTOS(F3_ENTRADA)<="'+DTOS(mv_par02)+'".AND.F3_TIPOMOV == "C"'
Else
   cFiltro += 'DTOS(F3_ENTRADA)>="'+DTOS(mv_par01)+'".AND.DTOS(F3_ENTRADA)<="'+DTOS(mv_par02)+'".AND.F3_TIPOMOV == "V"'
EndIf

aInd := {}
cIndexSF3 := CriaTrab(Nil,.F.)
AADD(aInd,cIndexSF3)
dbSelectArea("SF3")

IndRegua("SF3",cIndexSF3,cKeySF3,,cFiltro,If(mv_par03==1,OemToAnsi(STR0008),OemToAnsi(STR0009)))

nIndexSF3 := RetIndex("SF3")
dbSelectArea("SF3")

#IFNDEF TOP
	dbSetIndex(cIndexSF3+OrdBagExt())
	dbSetOrder(nIndexSF3+1)
	dbGoTop()
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia rotina de impressao                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua( RecCount() )

While ! Eof()

		If li > 50
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
			li:=09
      EndIf

		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4")+SF3->F3_TES)
		dbSelectArea("SF3")

      cRUC := CriaVar("A2_CGC")
      cNombre := CriaVar("A2_NOME")

		If mv_par03 == 1 .and. Alltrim(F3_ESPECIE) $ "NF.NCP"
			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek(xFilial("SA2")+SF3->F3_CLIEFOR+SF3->F3_LOJA)
			cRUC := SA2->A2_CGC
			cNombre := Subs(SA2->A2_NOME,1,25)

       	dbSelectArea("SF1")
       	dbSetOrder(1)
			dbSeek(xFilial("SF1")+SF3->F3_NFISCAL+SF3->F3_SERIE)
		    If Found()
		       dbSelectArea("SF3")
		       RecLock("SF3",.F.)
		       Replace F3_CANCEL	With " "
		       MsUnLock()
		    EndIf
		Else
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA)
			cRUC := SA1->A1_CGC
			cNombre := Subs(SA1->A1_NOME,1,25)

	     	dbSelectArea("SF2")
	     	dbSetOrder(1)
         dbSeek(xFilial("SF2")+SF3->F3_NFISCAL+SF3->F3_SERIE)
         If Found()
            dbSelectArea("SF3")
            RecLock("SF3",.F.)
            Replace F3_CANCEL   With " "
            MsUnLock()
         EndIf
		EndIf

		dbSelectArea("SF3")
      If mv_par04 == 1 .And. SF3->F3_CANCEL == "S"
         @ li, 000 PSAY F3_NFISCAL
         @ li, 010 PSAY F3_SERIE
         @ li, 014 PSAY F3_ENTRADA
         @ li, 023 PSAY If(SF4->F4_INDIRET=="S","In","D" )
         @ li, 026 PSAY "C A N C E L A D A"
			li++
      ElseIf Empty(F3_CANCEL)
         nExentas  := F3_EXENTAS
         nImpostos := F3_VALIMP1+F3_VALIMP2+F3_VALIMP3+F3_VALIMP4+F3_VALIMP5+F3_VALIMP6
         nGravadas := F3_BASIMP1+F3_BASIMP2+F3_BASIMP3+F3_BASIMP4+F3_BASIMP5+F3_BASIMP6
         nTotal := ( nGravadas + nImpostos + nExentas )

         If mv_par03 == 1
            @ li, 000 PSAY F3_NFISCAL
            @ li, 010 PSAY F3_SERIE
            @ li, 014 PSAY F3_ENTRADA
            @ li, 023 PSAY If(SF4->F4_INDIRET=="S","In","D" )
            @ li, 026 PSAY cNombre
         Else
            cTipo := ""
            If AllTrim(F3_ESPECIE) == "NF"
               If LF012Cond( SF2->F2_COND )
                  cTipo := "Contad"
               Else
                  cTipo := "Credito"
               EndIf
            ElseIf AllTrim(F3_ESPECIE) == "NCC"
               cTipo := "Nota Cr"
            Else
               cTipo := "Nota D "
            EndIf
            @ li, 000 PSAY F3_NFISCAL
            @ li, 010 PSAY F3_SERIE
            @ li, 014 PSAY cTipo
            @ li, 022 PSAY F3_ENTRADA
            @ li, 031 PSAY Subs(cNombre,1,19)
         EndIf

         @ li, 053 PSAY cRUC        Picture "!!!!-!!!!!!!!"
         @ li, 067 PSAY nGravadas   Picture PesqPict("SF3","F3_VALCONT",15,1)
         @ li, 083 PSAY nImpostos   Picture PesqPict("SF3","F3_VALIMP1",15,1)
         @ li, 099 PSAY nExentas    Picture PesqPict("SF3","F3_EXENTAS",15,1)
         @ li, 117 PSAY nTotal      Picture PesqPict("SF3","F3_VALCONT",15,1)

         aTotal[1][1] := aTotal[1][1] + nGravadas
         aTotal[1][2] := aTotal[1][2] + nImpostos
         aTotal[1][3] := aTotal[1][3] + nExentas
         aTotal[1][4] := aTotal[1][4] + nTotal

         If mv_par03 == 1
            If AllTrim(F3_ESPECIE) $ "NF"
               If SF4->F4_INDIRET != "S"
                  aResumo[1][1] := aResumo[1][1] + nGravadas
                  aResumo[1][2] := aResumo[1][2] + nImpostos
                  aResumo[1][3] := aResumo[1][3] + nExentas
               Else
                  aResumo[3][1] := aResumo[3][1] + nGravadas
                  aResumo[3][2] := aResumo[3][2] + nImpostos
                  aResumo[3][3] := aResumo[3][3] + nExentas
               Endif
            ElseIf AllTrim(F3_ESPECIE) $ "NCP"
               If SF4->F4_INDIRET != "S"
                  aResumo[2][1] := aResumo[2][1] + nGravadas
                  aResumo[2][2] := aResumo[2][2] + nImpostos
                  aResumo[2][3] := aResumo[2][3] + nExentas
               Else
                  aResumo[4][1] := aResumo[4][1] + nGravadas
                  aResumo[4][2] := aResumo[4][2] + nImpostos
                  aResumo[4][3] := aResumo[4][3] + nExentas
               Endif
            EndIf
         Else
            If AllTrim(F3_ESPECIE) == "NF"
               dbSelectArea("SF2")
               dbSetOrder(1)
               dbSeek(xFilial("SF2")+SF3->F3_NFISCAL+SF3->F3_SERIE)
               If LF012Cond( SF2->F2_COND )
                  aResumo[1][1] := aResumo[1][1] + nGravadas
                  aResumo[1][2] := aResumo[1][2] + nImpostos
                  aResumo[1][3] := aResumo[1][3] + nExentas
               Else
                  aResumo[2][1] := aResumo[2][1] + nGravadas
                  aResumo[2][2] := aResumo[2][2] + nImpostos
                  aResumo[2][3] := aResumo[2][3] + nExentas
               Endif
            ElseIf AllTrim(F3_ESPECIE) == "NCC"
               aResumo[3][1] := aResumo[3][1] + nGravadas
               aResumo[3][2] := aResumo[3][2] + nImpostos
               aResumo[3][3] := aResumo[3][3] + nExentas
            Else
               aResumo[4][1] := aResumo[4][1] + nGravadas
               aResumo[4][2] := aResumo[4][2] + nImpostos
               aResumo[4][3] := aResumo[4][3] + nExentas
            EndIf
         EndIf
			li++
      EndIf
		dbSelectArea("SF3")
		dbSkip()
End

If aTotal[1][1] > 0 .or. aTotal[2][1] > 0
	li++
	li++
	@ li, 000 PSAY OemToAnsi(STR0013)
	@ li, 067 PSAY aTotal[1][1]-aTotal[2][1]  	Picture PesqPict("SF3","F3_VALCONT",15,1)
	@ li, 083 PSAY aTotal[1][2]-aTotal[2][2]  	Picture PesqPict("SF3","F3_VALIMP1",15,1)
	@ li, 099 PSAY aTotal[1][3]-aTotal[2][3]		Picture PesqPict("SF3","F3_EXENTAS",15,1)
	@ li, 117 PSAY aTotal[1][4]-aTotal[2][4]		Picture PesqPict("SF3","F3_VALCONT",15,1)
	li++
	li++
EndIf

If li != 80
	Roda( cbCont, cbTxt, Tamanho )
EndIf

If mv_par05 == 1
	LF012Res(aResumo,aTotal)
EndIf

dbSelectArea("SF3")
RetIndex("SF3")

FErase(cIndexSF3+OrdBagExt())

dbSelectArea("SF3")
dbSetOrder(1)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LF012Res ³ Autor ³ Lucas                 ³ Data ³ 11.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Resumo do Livro de Compras/Ventas                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ LF012Res(ExpA1,ExpA2)    		                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 := 							                             ³±±
±±³          ³ ExpA2 := 								                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LF012Res(aResumo,aTotal)

LOCAL CbCont,CbTxt
LOCAL tamanho:="M"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

cabec1   := "PERIODO  DE  "+DTOC(mv_par01)+"  AL  "+DTOC(mv_par02)
cabec1   := Space((132-Len(cabec1))/2) + cabec1

If mv_par03 == 1
	Titulo := STR0014
else
	Titulo := STR0015
Endif

cabec2 := STR0016
//	         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
//          0         1         2         3         4         5         6         7         8
//          DIRECTO          FACTURA DE CREDITO               999.999.999.999    999.999.999.999    999.999.999.999

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If li > 50
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	li:=09
EndIf

If mv_par03 == 1
	@ Li, 000 PSAY STR0017
	@ Li, 017 PSAY If(mv_par03==1, STR0019, STR0020)
Else
	@ Li, 000 PSAY "Contado"
EndIf
@ Li, 050 PSAY aResumo[1][1]		Picture PesqPict("SF3","F3_VALCONT",15,1)
@ Li, 070 PSAY aResumo[1][2]		Picture PesqPict("SF3","F3_VALIMP1",15,1)
@ Li, 090 PSAY aResumo[1][3]		Picture PesqPict("SF3","F3_EXENTAS",15,1)
li := li + 2
If mv_par03 == 1
	@ Li, 017 PSAY STR0021
Else
	@ Li, 000 PSAY "Credito"
EndIf
@ Li, 050 PSAY aResumo[2][1]		Picture PesqPict("SF3","F3_VALCONT",15,1)
@ Li, 070 PSAY aResumo[2][2]		Picture PesqPict("SF3","F3_VALIMP1",15,1)
@ Li, 090 PSAY aResumo[2][3]		Picture PesqPict("SF3","F3_EXENTAS",15,1)
li := li + 2

If mv_par03 == 1
	@ li, 000 PSAY STR0018
	@ li, 017 PSAY If(mv_par03==1, STR0019, STR0020)
Else
	@ li, 000 PSAY "Nota Credito"
EndIf
@ Li, 050 PSAY aResumo[3][1]		Picture PesqPict("SF3","F3_VALCONT",15,1)
@ Li, 070 PSAY aResumo[3][2]		Picture PesqPict("SF3","F3_VALIMP1",15,1)
@ Li, 090 PSAY aResumo[3][3]		Picture PesqPict("SF3","F3_EXENTAS",15,1)

If mv_par03 == 1
   If (aResumo[4][1]+aResumo[4][2]+aResumo[4][3]) > 0
		li := li + 2
		@ Li, 000 PSAY STR0021
		@ Li, 050 PSAY aResumo[4][1]		Picture PesqPict("SF3","F3_VALCONT",15,1)
		@ Li, 070 PSAY aResumo[4][2]		Picture PesqPict("SF3","F3_VALIMP1",15,1)
		@ Li, 090 PSAY aResumo[4][3]		Picture PesqPict("SF3","F3_EXENTAS",15,1)
	EndIf
Else
	li := li + 2
	@ Li, 000 PSAY "Nota de Debito"
	@ Li, 050 PSAY aResumo[4][1]		Picture PesqPict("SF3","F3_VALCONT",15,1)
	@ Li, 070 PSAY aResumo[4][2]		Picture PesqPict("SF3","F3_VALIMP1",15,1)
	@ Li, 090 PSAY aResumo[4][3]		Picture PesqPict("SF3","F3_EXENTAS",15,1)
EndIf

Li := li + 3
If aTotal[1][1] > 0 .or. aTotal[2][1] > 0
	@ li, 000 PSAY STR0022
	@ li, 050 PSAY aTotal[1][1]-aTotal[2][1]  	Picture PesqPict("SF3","F3_VALCONT",15,1)
	@ li, 070 PSAY aTotal[1][2]-aTotal[2][2]  	Picture PesqPict("SF3","F3_VALIMP1",15,1)
	@ li, 090 PSAY aTotal[1][3]-aTotal[2][3]		Picture PesqPict("SF3","F3_EXENTAS",15,1)
EndIf
If li != 80
	Roda( cbCont, cbTxt, Tamanho )
EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1³ Autor ³ Lucas                 ³ Data ³ 30/07/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA900.PRX - Acertos Fiscais Paraguay (Localizacoes)...   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()
Local aAreaAnt := GetArea()
Local i := 0, j := 0
Local aRegs := {}
Local cPerg := "LIB012"

aAdd(aRegs,{cPerg,"01","¨Fecha Inicio       ?","mv_ch1","D",8,0,0,"G","","mv_par01",""       ,"01/01/80","",""           ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","¨Fecha Fin          ?","mv_ch2","D",8,0,0,"G","","mv_par02",""       ,"31/12/99","",""           ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","¨Libro de           ?","mv_ch3","N",1,0,0,"C","","mv_par03","IVA Compras",""        ,"","IVA Ventas"     ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","¨Considera Anuladas ?","mv_ch4","N",1,0,0,"C","","mv_par04","Si",""        ,"","No"     ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","¨Imprimir Resumen   ?","mv_ch5","N",1,0,0,"C","","mv_par05","Si",""        ,"","No"     ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","¨Imprimir Sucursal  ?","mv_ch6","N",1,0,0,"C","","mv_par06","Actual",""        ,"","Todas"     ,"","","","","","","","","","",""})

dbSelectArea("SX1")
dbSetOrder(1)

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
RestArea( aAreaAnt )
Return( NIL )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LF012Cond³ Autor ³ Lucas                 ³ Data ³ 11.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retornar .T. se Condicao de Pagamento for a vista.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ LF012Cond()				    		                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 := 							                             ³±±
±±³          ³ ExpA2 := 								                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LF012Cond(cCond)
LOCAL aAreaAnt := GetArea()
LOCAL lRet := .F.

dbSelectArea("SE4")
dbSetOrder(1)
If dbSeek(xFilial("SE4")+cCond)
	If SE4->E4_TIPO == "1" .and. AllTrim(SE4->E4_COND) $ "0³00³000"
		lRet := .T.
	EndIf
EndIf
RestArea( aAreaAnt )
Return( lRet )