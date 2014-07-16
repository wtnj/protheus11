#include "PROTHEUS.ch"
#include "DIALOG.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FINR490	³ Autor ³ Paulo Boschetti	    ³ Data ³ 23.04.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ C¢pia de Cheques						         			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FINR490(void)						    			   	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	 Uso	 ³ Generico 										       	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function NhFin022()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 														  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL cDesc1  := "Este programa ir  imprimir as copias dos cheques emitidos."
LOCAL cDesc2  := "Ser  impresso 1 ou 2 cheques for folha."
LOCAL cDesc3  := ""
LOCAL cString := "SEF"
 
PRIVATE titulo   := "Copias de Cheques"
PRIVATE aReturn  := { OemToAnsi("zebrado"), 1,OemToAnsi("Administracao"), 4, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nLastKey :=0
PRIVATE nomeprog :="FINR490"
PRIVATE cPerg	 :="FIN490"
PRIVATE li		 :=1

 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN490",.F.)
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros
//³ mv_par01			// Codigo Do Banco
//³ mv_par02			// Da Agencia
//³ mv_par03			// Da Conta
//³ mv_par04			// Do Cheque
//³ mv_par05			// Ate o Cheque
//³ mv_par06			// Imprime composicao do cheque
//³ mv_par07			// Copias p/ pagina (1/2)
//³ mv_par08			// Imprime Numeracao Sequencial
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "NHFIN022"           //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,"P")
  
If nLastKey == 27
 	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
  	Return
Endif

RptStatus({|lEnd| Fa490Imp(@lEnd,wnRel,cString)},titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FA490Imp ³ Autor ³ Wagner Xavier 	    ³ Data ³ 13.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Copia de cheques						        			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA490Imp(lEnd,wnRel,cString)						      	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd	  - A‡Æo do CodeBlock			  		              ³±±
±±³Parametros³ lEnd	  - A‡Æo do CodeBlock			     		      	  ³±±
±±³			 ³ wnRel   - T¡tulo do relat¢rio 			    	          ³±±
±±³Parametros³ cString - Mensagem							         	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 							  					  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function FA490Imp(lEnd,wnRel,cString)

LOCAL cExtenso := ""
LOCAL j,nTipo:=18,nRec,nContador:=0,cDocto

// Retirada a comparacao abaixo uma vez que o Protheus nao mais trabalha com normal e comprimido,
// mas com retradoe paisagem.
// nTipo   :=IIF(aReturn[4]==1,15,18)
mv_par01:=mv_par01+Space( 3-Len(mv_par01))
mv_par02:=mv_par02+Space( 5-Len(mv_par02))
mv_par03:=mv_par03+Space(10-Len(mv_par03))
mv_par04:=mv_par04+Space(15-Len(mv_par04))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe o Banco							         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SA6")
DbSeek(cFilial+mv_par01+mv_par02+mv_par03)
IF !Found()
 	Set Device To Screen
  	Help(" ",1,"BCONOEXIST")
 	Return
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Localiza o 1.Cheque a ser impresso 								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SEF")
dbSeek(cFilial+mv_par01+mv_par02+mv_par03+mv_par04,.T.)

SetRegua(RecCount())
fa490Cabec(nTipo)
fa490Cabec(nTipo)

While !Eof() .And. EF_FILIAL+EF_BANCO=cFilial+mv_par01 .And. ;
 	EF_AGENCIA=mv_par02 .And. EF_CONTA=mv_par03 .And. ;
 	EF_NUM<=mv_par05

 	If lEnd
  		@Prow()+1,1 PSAY OemToAnsi("Cancelado pelo operador")
  		Exit
 	EndIF

 	IncRegua()

 	IF EF_IMPRESS $ "AC" .or. SubStr(EF_TIPO,1,2) == "TB"
  		dbSkip()
  		Loop
  	EndIF

  	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	//³Validacao da carteira³
 	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If EF_CART = "R"
     	DbSkip()
 		Loop
   EndIf

 	IF mv_par07 == 1		//uma copia por folha
  		  li:=1
 	Elseif li > 32 		//so coube uma copia
  		  li:=1
 	Else				//2 copias por folha
  		IF nContador == 0
  				li:=1
  		Else
   			li:=33
		Endif
 	EndIF

 	nContador++

 	IF nContador>2;nContador:=1;li:=1;EndIF

	__LogPages()
	__LogPages()
  	@li, 1 PSAY Alltrim(SM0->M0_NOMECOM) + " - " + Alltrim(SM0->M0_FILIAL) + OemToAnsi("  -  COPIA DE CHEQUE")  //"  -  COPIA DE CHEQUE"
 	li++
  	@li, 0 PSAY Replicate("-",80)
 	li++
  	@li, 0 PSAY OemToAnsi("|  Numero Cheque ") +EF_NUM  //"|  Numero Cheque "
  	@li,35 PSAY OemToAnsi("Data da Emissao ")  +Dtoc(EF_DATA)  //"Data da Emissao "
  	@li,79 PSAY "|"
  	li++
  	@li, 0 PSAY OemToAnsi("|  Banco ")+EF_BANCO+  "     "    +SA6->A6_NREDUZ  //"|  Banco "
  	@li,35 PSAY OemToAnsi("Agencia ")+EF_AGENCIA+OemToAnsi(" Conta ")+EF_CONTA  //"Agencia###"   Conta "
  	@li,79 PSAY "|"
  	li++
 	@li, 0 PSAY OemToAnsi("|  Valor Cheque ")+Transform(EF_VALOR,"@E 99,999,999.99")  //"|  Valor Cheque "
  	@li,35 PSAY OemToAnsi("Data do Cheque  ")+Dtoc(EF_DATA)  //"Data do Cheque  "
 	@li,79 PSAY "|"
  	li++
  	@li, 0 PSAY OemToAnsi("|  Favorecido ")+EF_BENEF  //"|  Favorecido "
  	@li,79 PSAY "|"
  	li++
  	@li, 0 PSAY OemToAnsi("|  Historico  ")+EF_HIST  //"|  Historico  "
  	@li,79 PSAY "|"
  	li++

  	If mv_par08 == 1
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Pegar e gravar o proximo numero da Copia do Cheque 	   ³
      //³ Posicionar no sx6 utilizando GetMv. N"o Utilize Seek !!! ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   	cDocto := STRZERO(VAL(Getmv("MV_NUMCOP"))+1,6)
	   	dbSelectArea("SX6")
	   	GetMv("MV_NUMCOP")
	   	RecLock("SX6",.F.)
	   	Replace X6_CONTEUD With cDocto
	   	MsUnlock()
	   	dbSelectArea("SEF")
	   	@li, 0 PSAY OemToAnsi("|  Copia de Cheque No. ")+cDocto  //"|  Copia de Cheque No. "
	    @li,79 PSAY "|"
    Else
	    @li, 0 PSAY "|"
	   	@li,79 PSAY "|"
 	Endif

 	li++
  	@li, 0 PSAY OemToAnsi("|  Vistos")  //"|  Vistos"
  	@li,79 PSAY "|"
  	li++
  	@li, 0 PSAY "|"+Replicate("-",78)+"|"
  	li++
 	@li, 0 PSAY OemToAnsi("|Observacoes      |Contas a Pagar|Tesouraria    |Contabilidade |Assinado por   |")
  	li++
  	@li, 0 PSAY "|-----------------|--------------|--------------|--------------|---------------|"
  	li++
  	For j:=1 to 3
 		@li, 0 PSAY "|"
  		@li,18 PSAY "|"
  		@li,33 PSAY "|"
  		@li,48 PSAY "|"
  		@li,63 PSAY "|"
  		@li,79 PSAY "|"
  		li++
  	Next j
 	@li, 0 PSAY Replicate("-",80)
  	nRec:=RecNo()
  	IF mv_par06 == 1
  		fr490Cpos(SEF->EF_NUM)
  	EndIF
  	dbGoTo(nRec)
  	dbSkip()
End

Set Device To Screen
Set Filter To

If aReturn[5] = 1
  	Set Printer To
  	dbCommit()
  	ourspool(wnrel)
Endif

MS_FLUSH()
MS_FLUSH()


Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ fr490Cpos³ Autor ³ Wagner Xavier 		³ Data ³ 13.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Copia de cheques								              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR490(void)							  			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±³Parametros³ 											                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	     ³Generico 						  			                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

STATIC Function fr490Cpos(cCheque)
   LOCAL nFirst:=0,lAglut:=.F.
   Local aColu	:= {}
   Local aTam := TamSX3("E2_FORNECE")
   Local aTam2 := TamSX3("EF_TITULO")
   Local cCabeca := ""
   Local cCabecb := ""
   Local _cDescNat  := Space(09)
   
   SED->(DbSetOrder(1))
   
   DbSelectArea("SEF")
   dbSeek (cFilial+mv_par01+mv_par02+mv_par03+cCheque)
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Definicao das colunas de impressao                           ³
   //³ aTam[1] = Tamanho do codigo do fornecedor (6 ou 20)          ³
   //³ aTam2[1]= Tamanho do nro de titulo (6 ou 12)                 ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

 	aColu := {001,008,026,037,042,046,053,062}
  	cCabeca	:= OemToAnsi("|Fornec Nome Fornec.  Natureza        Tip/Prf Numero P Vencto     Vlr do Titulo|")
  	cCabecb	:= ""                              

   While !Eof() .And. EF_FILIAL+EF_BANCO=cFilial+mv_par01 .And. ;
    	EF_AGENCIA=mv_par02 .And. EF_CONTA=mv_par03 .And. ;
    	EF_NUM==cCheque

    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   	//³Validacao da carteira³
    	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      If EF_CART = "R"
         DbSkip()
   		Loop
      EndIf
    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   	//³ Verifica se nao ‚ principal o cancelado					 	 ³
   	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	IF EF_IMPRESS == "C"
   		dbSkip()
  	   	Loop
   	Endif

   	IF li > 58
         li:=1
    		@li,0 PSAY OemToAnsi("COPIA DO CHEQUE : ")+ cCheque + OemToAnsi(" - Continuacao")  //"COPIA DO CHEQUE : "###" - Continuacao"
   		li++
   	EndIF

   	IF nFirst == 0
    		IF EF_IMPRESS = "A"
   			lAglut:=.T.
   		Endif
   	
   	   IF !lAglut .and. Empty(SEF->EF_TITULO)
	   	   dbSkip()
      		Loop
       	Endif
   	Endif

   	li++
   	@li,0 PSAY OemToAnsi("|- Composicao do Cheque ")+Replicate("-",55)+"|"  //"|- Composicao do Cheque "
   	li++
   	@li,0 PSAY cCabeca

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   	//³ Verifica se sera necess rio imprimir em duas linhas os deta- ³
   	//³ lhes. Isso ocorre qdo E2_FORNECE ou EF_TITULO forem > 6 pos. ³
   	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    	IF aTam[1] > 6 .or. aTam2[1] > 6
	    	li++
   		@li,0 PSAY cCabecb
   	Endif
   	li++
   	@li,0 PSAY Replicate("-",80)

 	   IF Empty(SEF->EF_TITULO)
    		dbSkip()
   		Loop
   	End

   	If aTam[1] == 6 .and. aTam2[1] == 6
   		nTam := 13
   	Else
   		nTam := 30
   	Endif
   	nFirst++
   	li++

	_cDescNat := Space(15)
   	dbSelectArea("SE2")
   	dbSeek(cFilial+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA)
	If SE2->(Found())
		SED->(DbSeek(xFilial("SED")+SE2->E2_NATUREZ))
		If SED->(Found())
			_cDescNat := Substr(SED->ED_DESCRIC,1,15)
		Endif
	Endif

   	@li, 00 PSAY "|"
   	@li, 01 PSAY E2_FORNECE
   	@li, 08 PSAY SubStr(E2_NOMFOR,1,12)
   	@li, 22 PSAY _cDescNat
   	@li, 38 PSAY SE2->E2_TIPO
   	dbSelectArea("SEF")
 
   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   	//³ Verifica se sera necess rio imprimir em duas linhas os deta- ³
   	//³ lhes. Isso ocorre qdo E2_FORNECE ou EF_TITULO forem > 6 pos. ³
   	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	IF aTam[1] > 6 .or. aTam2[1] > 6
   		@li,79 PSAY "|"
   		li++
   		li++
   		@li, 0 PSAY "|"
   	Endif
   	// aColu := {001,008,026,037,042,046,053,062}
   	@li, 42 PSAY EF_PREFIXO
   	@li, 46 PSAY EF_TITULO
   	@li, 53 PSAY EF_PARCELA
   	@li, 55 PSAY SE2->E2_VENCREA
   	@li, 67 PSAY EF_VALOR PicTure tm(EF_VALOR,12)
   	@li, 79 PSAY "|"
   	dbSkip()
   EndDO
   
   IF nFirst>0
   	li++
   	@li, 0 PSAY Replicate("-",80)
   End

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Fa490Cabec³ Autor ³ Alessandro B. Freire  ³ Data ³ 18.12.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de leitura do driver correto de impressao		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA490cabec(nchar) 									      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nChar . 15-Comprimido , 18-Normal						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	     ³Finr490													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa490cabec(nChar)
  
LOCAL cTamanho := "P"
LOCAL aDriver := ReadDriver()
 
If !( "DEFAULT" $ Upper( __DRIVER ) )
  	SetPrc(000,000)
 	SetPrc(000,000)
Endif

if nChar == NIL
  	@ pRow(),pCol() PSAY &(if(cTamanho=="P",aDriver[1],if(cTamanho=="G",aDriver[5],aDriver[3])))
else
  	if nChar == 15
  	   @pRow(),pCol() PSAY &(if(cTamanho=="P",aDriver[1],if(cTamanho=="G",aDriver[5],aDriver[3])))
  	else
      @pRow(),pCol() PSAY &(if(cTamanho=="P",aDriver[2],if(cTamanho=="G",aDriver[6],aDriver[4])))
  	endif
endif
Return(.T.)
