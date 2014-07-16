#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 15/06/00

User Function resfac()        // incluido pelo assistente de conversao do AP5 IDE em 15/06/00
resfacp()
return
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NVLMERC,NVLIMP1,NVLGAST,NTOTAL,CBTXT,CFILTRO")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,ARETURN,NOMEPROG,ALINHA,NLASTKEY,CPERG")
SetPrvt("CBCONT,LI,M_PAG,WNREL,NCT,DDATANT")
SetPrvt("NTEMP,LCONTINUA,NREG,NTOTNETONOTA,NTOTNETOGERAL,NTOTNETODIA")
SetPrvt("NTOTQUANT,NU,LNOVODIA,NACN1,NACN2,NACN3")
SetPrvt("NACG1,NACG2,NACG3,NACD1,NACD2,NACD3")
SetPrvt("AIMPOSTOS,NACIMPINC,NACDIMPINC,NACGIMPINC,NACIMPNOINC,NACDIMPNOINC")
SetPrvt("NACGIMPNOINC,IMPRIME,CABEC1,CABEC2,CINDEX,CKEY")
SetPrvt("CCONDICAO,NINDEX,CINDEX1,LEND,CALIASPRT,DEMISANT")
SetPrvt("NDESP,DDIA,_SALIAS,AREGS,I,J")
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ResFacp  ³ Autor ³ Paulo Augusto         ³ Data ³ 15.06.00  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Notas Fiscais                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Resfac (void)                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Resfacp()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nvlmerc:= 0
nvlimp1:= 0
nvlgast:= 0
nTotal := 0
CbTxt:=""
cFiltro := ""
tamanho:= "G"
limite := 220
titulo := "Relacion de las Facturas  "
cDesc1 := "Este programa emitira la relacion de las Facturas.  "
cDesc2 := ""
cDesc3 := ""
cString:= "SF2"

aReturn := {"", 1,"Administracion", 1, 2, 1, "",1 }	
nomeprog:="RESFAC"
aLinha  := { }
nLastKey := 0
cPerg   :="RESFAC"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt := SPACE(10)
cbcont := 0
li := 80
m_pag := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RESFACPERG()
pergunte("RESFAC",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // De Nota                              ³
//³ mv_par02             // Ate a Nota                           ³
//³ mv_par03             // De Data                              ³
//³ mv_par04             // Ate a Data                           ³
//³ mv_par05             // Da Serie                             ³
//³ mv_par06             // Da Serie                             ³
//³ mv_par07             // Qual Moeda                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="RESFAC"

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey==27
	Set Filter to
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
   Return
Endif


RptStatus({|lEnd| ResfacImp(@lEnd,wnRel,cString)},Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Resfacimp ³ Autor ³ Paulo Augusto         ³ Data ³ 16.06.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RESFAC                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 15/06/00 ==> Static Function ResfacImp(lEnd,WnRel,cString)
Static Function ResfacImp(lEnd,WnRel,cString)

nCt := 0
nTemp  := 0
lContinua := .T.
nReg     :=0
tamanho:= "G"
limite := 220

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Imporessao do Cabecalho e Rodape   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := Space(10)
cbcont   := 00
li       := 80
m_pag    := 01
imprime  := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Cabecalho de acordo com o tipo de emissao            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := "INFORME DE LAS FACTURAS     "
//           12345678901234567890123456789012345678901234567890123456789012345678901234567890
//                    1         2         3         4         5         6         7         8
Cabec1   :="CODIGO    NOMBRE                                          FECHA        TIPO FACTURA          NUMERO FACTURA                   VALOR MERCADERIA            VALOR DEL            OTROS GASTOS               TOTAL                      "
Cabec2   :="                                                                                                                                  SIN IVA                    IVA                                         CON IVA "
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice de Trabalho                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SF2")
cIndex := CriaTrab("",.F.)
cKey := 'F2_FILIAL+DTOS(F2_EMISSAO)+F2_DOC+F2_SERIE'

cCondicao := 'F2_FILIAL=="'+xFilial("SF2")+'".And.F2_DOC>="'+mv_par01+'"'
cCondicao += '.And.F2_DOC<="'+mv_par02+'".And.DTOS(F2_EMISSAO)>="'+DTOS(mv_par03)+'"'
cCondicao += '.And.DTOS(F2_EMISSAO)<="'+DTOS(mv_par04)+'".And. F2_SERIE>="'+mv_par05
cCondicao += '".And.F2_SERIE<= "'+mv_par06+'".And.F2_TIPO <> "C"'

IF !Empty(aReturn[7])   // Coloca expressao do filtro
   cCondicao += '.And.'+aReturn[7]
Endif

IndRegua("SF2",cIndex,cKey,,cCondicao)
nIndex := RetIndex("SF2")
dbSelectArea("SF2")
#IFNDEF TOP
  	 dbSetIndex(cIndex+OrdBagExt())
#ENDIF
dbSetOrder(nIndex+1)
dbGoTop()

dbSelectArea("SF2")
cIndex1  := CriaTrab("",.F.)
cKey     := 'F1_FILIAL+DTOS(F1_DTDIGIT)+F1_DOC+F1_SERIE'

cCondicao := 'F1_FILIAL=="'+xFilial("SF1")+'".And.F1_DOC>="'+mv_par01+'"'
cCondicao += '.And.F1_DOC<="'+mv_par02+'".And.DTOS(F1_DTDIGIT)>="'+DTOS(mv_par03)+'"'
cCondicao += '.And.DTOS(F1_DTDIGIT)<="'+DTOS(mv_par04)+'".And. F1_SERIE>="'+mv_par05
cCondicao += '".And.F1_SERIE<= "'+mv_par06+'".And.F1_TIPO == "D"'


IF !Empty(aReturn[7])   // Coloca expressao do filtro
   cCondicao += '.And.'+aReturn[7]
Endif
IndRegua("SF1",cIndex1,cKey,,cCondicao)
nIndex := RetIndex("SF1")
dbSelectArea("SF1")
#IFNDEF TOP
    dbSetIndex(cIndex1+OrdBagExt())
#ENDIF
dbSetOrder(nIndex+1)
dbGoTop()

dbSelectArea("SF2")

SetRegua(RecCount())    // Total de Elementos da regua

While (!SF1->(Eof()) .Or. !SF2->(Eof()) ).And. lContinua

	#IFNDEF WINDOWS
		If LastKey() = 286    //ALT_A
			lEnd := .t.
		End
	#ENDIF

	IF lEnd
		@Prow()+1,001 PSAY "CANCELADO POR EL OPERADOR" 
		lContinua := .F.
		Exit
	Endif

	IncRegua()

   nCt := 1

   If ! SF1->(eof()) .And. SF2->F2_EMISSAO > SF1->F1_DTDIGIT
      dbSelectArea("SD1")
      dbSetOrder(1)
      dbSeek(cFilial+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
      cAliasPrt   := "SF1"
      dEmisAnt    := SF1->F1_DTDIGIT
   ElseIf  !SF2->(Eof())
      dbSelectArea("SD2")
      dbSetOrder(3)
      dbSeek(cFilial+SF2->F2_DOC+SF2->F2_SERIE)
      cAliasPrt   := "SF2"
      dEmisAnt    := SF2->F2_EMISSAO
   Endif
   If li > 55
      cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
   EndIf

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se nota tem ICMS Solidario, imprime.			                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If cAliasPrt  == "SF2"
      ndesp:= SF2->F2_FRETE+SF2->F2_SEGURO+SF2->F2_DESPESA
   Else
      ndesp:= SF1->F1_FRETE+SF1->F1_SEGURO+SF1->F1_DESPESA
   Endif
     
		
      If cAliasPrt  == "SF2"
      	dbSelectArea("SA1")
      	dbSetOrder(1)
      	dbSeek(xFilial()+Sf2->f2_CLIENTE+Sf2->f2_LOJA)
      	ccabecc:= A1_COD+"       "+A1_LOJA+"  -  "+subs(a1_NOME,1,30)+"      "+DTOC(SF2->F2_EMISSAO)+"          "+if(SD2->D2_TIPO=="C","NOTA DE CREDITO ","FACTURA ") 
       	dbselectarea("SF2")
        ccabecc:=ccabecc +"       " +SF2->F2_DOC+" / "+SF2->F2_SERIE+" ---->"      
 
      Else
        dbSelectArea("SA2")
      	dbSetOrder(1)
      	dbSeek(xFilial()+Sf1->f1_CLIENTE+Sf1->f1_LOJA)
      	ccabecc:= A2_COD+" "+A2_LOJA+"  -  "+subs(a2_NOME,1,30)+"      "+ DTOC(SF2->F1_EMISSAO)+"          "+if(SD2->D1_TIPO=="C","NOTA DE CREDITO ","FACTURA ") 
       	dbselectarea("SF2")
        ccabecc:=ccabecc +"       "+SF1->F1_DOC+"  /  "+SF1->F1_SERIE+" ---->"      
      Endif
	  @Li ,   0 PSAY  ccabecc      	      
      @li,120 psay xmoeda(sf2->f2_valmerc,1,MV_PAR07,IIf(cAliasPrt=="SF2",Sf2->f2_EMISSAO,SD1->D1_DTDIGIT))   picture "@e 999,999,999,999"
      @li,145 psay xMoeda(sf2->f2_valimp1,1,MV_PAR07,IIf(cAliasPrt=="SF2",Sf2->f2_EMISSAO,SD1->D1_DTDIGIT))   picture "@e 999,999,999,999"
	  @li,170 psay xMoeda(ndesp,1,MV_PAR07,IIf(cAliasPrt=="SF2",Sf2->f2_EMISSAO,SD1->D1_DTDIGIT)           )   picture "@e 999,999,999,999"
      @li,195 psay xMoeda(sf2->f2_valbrut,1,MV_PAR07,IIf(cAliasPrt=="SF2",Sf2->f2_EMISSAO,SD1->D1_DTDIGIT) )  picture "@e 999,999,999,999"
	
	   li:=li+1
      @Li ,  0 PSAY REPLICATE('-',220)
		Li++
      If cAliasPrt   == "SF2"
         nvlmerc:= nvlmerc+sf2->f2_valmerc
         nvlimp1:= sf2->f2_valimp1 + nvlimp1
         nvlgast:= ndesp + nvlgast
         nTotal := sf2->f2_valbrut + nTotal
      Else
         nvlmerc:= nvlmerc+sf1->f1_valmerc
         nvlimp1:= sf1->f1_valimp1 + nvlimp1
         nvlgast:= ndesp + nvlgast
         nTotal := sf1->f1_valbrut + nTotal
      Endif
   dbSelectArea(cAliasPrt)
	dbSkip()
End

IF li != 80
   	Li++
	@Li ,  0 PSAY "TOTALES GENERALES     ------->"
	@li, 120 psay xMoeda(nvlmerc ,1,MV_PAR07,IIf(cAliasPrt=="SF2",Sf2->f2_EMISSAO,SD1->D1_DTDIGIT)) picture "@e 999,999,999,999
   	@Li ,145 PSAY xMoeda(nvlimp1 ,1,MV_PAR07,IIf(cAliasPrt=="SF2",Sf2->f2_EMISSAO,SD1->D1_DTDIGIT))  picture "@e 999,999,999,999
   	@Li ,170  PSAY xMoeda(nvlgast,1,MV_PAR07,IIf(cAliasPrt=="SF2",Sf2->f2_EMISSAO,SD1->D1_DTDIGIT)) picture "@e 999,999,999,999
   	@Li ,195 PSAY xMoeda(ntotal  ,1,MV_PAR07,IIf(cAliasPrt=="SF2",Sf2->f2_EMISSAO,SD1->D1_DTDIGIT) ) picture "@e 999,999,999,999
   	Li++
	roda(cbcont,cbtxt,tamanho)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve condicao original ao SF2 e apaga arquivo de trabalho.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SF2")
dbSelectArea("SF2")
Set Filter To
dbSetOrder(1)

RetIndex("SF1")
dbSelectArea("SF1")
Set Filter To
dbSetOrder(1)

#IFNDEF TOP
	cIndex += OrdBagExt()
	If File(cIndex)
		Ferase(cIndex)
	Endif
   cIndex1 += OrdBagExt()
   If File(cIndex1)
      Ferase(cIndex1)
	Endif
#ENDIF

dbSelectArea("SD2")
dbSetOrder(1)

dbSelectArea("SD1")
dbSetOrder(1)

Set Device To Screen

If aReturn[5] = 1
     Set Printer TO
     dbcommitAll()
     ourspool(wnrel)
Endif

MS_FLUSH()

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RESFACPERG³ Autor ³ Jose Lucas           ³ Data ³ 22/02/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam...     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA467                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 15/06/00 ==> Function RESFACPERG()
Static Function RESFACPERG()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("RESFAC",6)
aRegs:={}

aAdd(aRegs,{cPerg,"01","¨ De Factura        ?","mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","¨ A Factura         ?","mv_ch2","C",09,0,1,"G","","mv_par02","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","¨ De Fecha          ?","mv_ch3","D",08,0,2,"G","","mv_par03","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","¨ A Fecha           ?","mv_ch4","D",08,0,2,"G","","mv_par04","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","¨ De Serie          ?","mv_ch5","C",03,0,2,"G","","mv_par05","","","","","","","","","","","","","","","01"})
aAdd(aRegs,{cPerg,"06","¨ A Serie           ?","mv_ch6","C",03,0,2,"G","","mv_par06","","","","","","","","","","","","","","","01"})
aAdd(aRegs,{cPerg,"07","¨ Cual Moneda       ?","mv_ch7","N",01,0,2,"C","","","Moneda1","","","Moneda2","","","Moneda3","","","Moneda4","","","Moneda5","",""})

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
dbSelectArea(_sAlias)
Return
