#INCLUDE "LibrTik.ch"
#INCLUDE "SIGAWIN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 09/09/99
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³LIBRTIK   ºAutor  ³Fernando Machima    º Data ³  13/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Livro Fiscal de Vendas para Tickets e Faturas (Loc.        º±±
±±º          ³ Venezuela)                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaLoja                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LibrTik()        // incluido pelo assistente de conversao do AP5 IDE em 09/09/99

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cPerg    := "LIBTIK"

PRIVATE cString      := "SF3"
PRIVATE nPagina      := 0
PRIVATE Limite       := 220
PRIVATE Tamanho      := "G"
PRIVATE NomeProg     :="LIBRTIK"
PRIVATE Titulo	:= OemToAnsi(STR0001) // "Emision del Libro de Tickets"
PRIVATE cDesc1  := OemToAnsi(STR0002) //"Seran solicitadas la fecha inicial y la fecha final para la emision "
PRIVATE cDesc2 	:= OemToAnsi(STR0003) //"del libro de tickets de IVA Ventas"
PRIVATE cDesc3 	:= ""
PRIVATE M_Pag   := 1
PRIVATE wnrel   := "LIBRTIK"
PRIVATE aReturn := { OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 1, 2, 1, "",1 }  //"Especial"###"Administracion"
PRIVATE aDriver

Private lSeries
PRIVATE cNomeArq     := ""
PRIVATE cPictVals    := PesqPict("SF3","F3_VALCONT")
PRIVATE lFinRel      := .F.
PRIVATE nLastKey     := 0
PRIVATE lContinua    := .T.

AjustaSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis utilizadas para parametros      ³
//³mv_par01             // Data De           ³
//³mv_par02             // Data Ate          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica Posicao do Formulario na Impressora³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

VerImp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio do Processamento do Relatorio. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> 	RptStatus({|| Execute(RptDetail)})
RptStatus({|| RptDetail()})

dbSelectArea("TRB1")
dbCloseArea()
dbSelectArea("TRB2")
dbCloseArea()

If File(cNomeArq+".DBF")
   Ferase(cNomeArq+".DBF")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³RptDetail ºAutor  ³Fernando Machima    º Data ³  13/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Executa o processamento de leitura e impressao dos         º±±
±±º          ³ registros do Livro de Vendas                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRTIK		                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==>  Function RptDetail
Static Function RptDetail()

Local  cTikIni     := ""
Local  cTikAtu     := ""
Local  dDataAnt    := ""

Local cSerieT
Local aSeries := {}
Local cCpoValImp, cCpoBasImp, cCpoAlqImp

Local aStruTRB1   := {}
Local aStruTRB2   := {}
Local aCpoQuery   := {}
Local nPosCpo     := 0
Local nI          := 0
Local cArqTRB1
Local cArqTRB2
Local cChave
Local aImps       := {}
Local cNome       := ""
Local cRif        := ""

Local nTotDiaTik  := 0   //Total das vendas diarias de tickets
Local nTotDiaFat  := 0   //Total das vendas diarias de faturas

Local nBasImpF    := 0   //Base do imposto da fatura
Local nValImpF    := 0   //Valor do imposto da fatura
Local nAlqImpF    := 0   //Aliquota do imposto da fatura

Local nSigno      := 1   //Controle para notas fiscais(+) e notas de credito(-)
Local dEntAnt            //Data de referencia para impressao de tickets agrupados por data 
Local cFiltro
Local dDtIni, dDtFim
Local lVazio      := .T.   //Verifica se tem registros com os parametros passados

//Tickets
Private nValImpTik  := 0   //Total diario do valor do imposto dos tickets
Private nBasImpTik  := 0   //Total diario da base do imposto dos tickets
Private nTotVlImpT  := 0   //Total do valor do imposto dos tickets
Private nTotBsImpT  := 0   //Total da base do imposto dos tickets
Private nTotalTik   := 0   //Total das vendas de tickets                
//Faturas
Private nTotVlImpF  := 0   //Total do valor do imposto das faturas
Private nTotBsImpF  := 0   //Total da base do imposto das faturas
Private nTotalFat   := 0   //Total das vendas de faturas
Private nLin        := 80

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Prepara o SF3 para extracao dos dados  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dDtIni := mv_par01
dDtFim := mv_par02

//Busca a serie do ticket
dbSelectArea("SX5")  
DbSetOrder(1)
If dbSeek(xFilial("SX5")+"SE")
   While !Eof() .And. SX5->X5_FILIAL+SX5->X5_TABELA == xFilial("SX5")+"SE"
	  AAdd( aSeries,{SX5->X5_CHAVE,Substr(X5Descri(),1,1)})	  
	  If Substr(X5Descri(),1,1) == "T"   
	     cSerieT := AllTrim(X5_CHAVE)	  
	  EndIf   
	  DbSkip()
   EndDo
EndIf   

#IFNDEF TOP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criar aquivo temporario com as movimentacoes de SF3(Tickets)... ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF3")
	aStruTRB1 := dbStruct()

	cNomeArq:=CriaTrab( aStruTRB1, .T. )
	
	dbUseArea(.T.,,cNomeArq,"TRB1",.T.,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Varrer o SF3 respeitando filtrando com base nas perguntas ³
	//³ temporarias.                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF3")
	dbSetOrder(1)
	dbSeek(xFilial("SF3") + Dtoc(dDtIni),.T.)
	
    //Filtro para os tickets
    cFiltro :="F3_FILIAL=='"+xFilial("SF3")+"'.AND. DTOS(F3_ENTRADA)>='"+DTOS(dDtIni)+"'.AND. DTOS(F3_ENTRADA)<='"+DTOS(dDtFim)+"'.AND. F3_SERIE=='"+cSerieT+"'"
    cFiltro := cFiltro + ".And.F3_TIPOMOV == 'V'" 

	While !Eof() .and. F3_FILIAL == xFilial("SF3");
			.and. F3_ENTRADA <= dDtFim

		If !(&cFiltro)
			dbSkip()
			Loop
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravar campos no arquivo TRB, Registros temporarios...           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("TRB1")
		RecLock("TRB1",.T.)
		For nI := 1 To FCount()
			nPosCpo := TRB1->(FieldPos(TRB1->(Field(nI))))
			TRB1->( FieldPut( nPosCpo , SF3->( FieldGet(nPosCpo) ) ) )
		Next nI
		MsUnLock()         
		lVazio := .F.
		dbSelectArea("SF3")		
		dbSkip()
	EndDo


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criar aquivo temporario com as movimentacoes de SF3(Faturas)... ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF3")
	aStruTRB2 := dbStruct()

	cNomeArq:=CriaTrab( aStruTRB2, .T. )
	
	dbUseArea(.T.,,cNomeArq,"TRB2",.T.,.F.)

	dbSelectArea("SF3")
	dbSetOrder(1)
	dbSeek(xFilial("SF3") + DToc(dDtIni),.T.)
	   
    //Filtro para as faturas, notas de credito etc.
    cFiltro :="F3_FILIAL=='"+xFilial("SF3")+"'.AND. DTOS(F3_ENTRADA)>='"+DTOS(dDtIni)+"'.AND. DTOS(F3_ENTRADA)<='"+DTOS(dDtFim)+"'.AND. F3_SERIE<>'"+cSerieT+"'"
    cFiltro := cFiltro + ".And.F3_TIPOMOV == 'V'" 

	While !Eof() .and. F3_FILIAL == xFilial("SF3");
			.and. F3_ENTRADA <= dDtFim

		If !(&cFiltro)
			dbSkip()
			Loop
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravar campos no arquivo TRB, Registros temporarios...           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("TRB2")
		RecLock("TRB2",.T.)
		For nI := 1 To FCount()
			nPosCpo := TRB2->(FieldPos(TRB2->(Field(nI))))
			TRB2->( FieldPut( nPosCpo , SF3->( FieldGet(nPosCpo) ) ) )
		Next nI
		MsUnLock()
		lVazio := .F.		
		dbSelectArea("SF3")
		dbSkip()
	EndDo
	
#ELSE 
      //TOP CONNECT
      
#ENDIF

If lVazio
   MsgStop(OemToAnsi(STR0040))  //"No hay datos para los parametros ingresados"                
   Return
EndIf

//*****IMPRESSAO DE TICKETS*****

//Ordenacao dos registros do TRB1(Tickets) de acordo com a data de emissao para a impressao
cChave:="F3_FILIAL+DTOS(F3_ENTRADA)"

cArqTRB1:=CriaTrab(NIL,.F.)
IndRegua("TRB1",cArqTRB1,cChave,,,OemToAnsi(STR0006)) //"Filtrando registros..."
                         
//Ordenacao dos registros do TRB2(Faturas) de acordo com a data de emissao e serie da fatura para a impressao                        
cChave:="F3_FILIAL+DTOS(F3_ENTRADA)+F3_SERIE"

cArqTRB2:=CriaTrab(NIL,.F.)
IndRegua("TRB2",cArqTRB2,cChave,,,OemToAnsi(STR0006)) //"Filtrando registros..."

dbSelectArea("TRB1")
dbGoTop()
                   
If lAbortPrint
   @ 00,01 PSAY OemToAnsi(STR0007) //"** CANCELADO PELO OPERADOR **"
   lContinua := .F.
Endif
    
nPagina := 0
lFinRel := .T.          
	
//Impressao de vendas com tickets
If nLin > 55
   R020CabT()    
EndIf   
dEntAnt := TRB1->F3_ENTRADA	      	        
While xFilial("SF3") == TRB1->F3_FILIAL .And. !Eof()
       nBasImpTik  := 0
       nValImpTik  := 0       
       nTotDiaTik  := 0              
              
       If Empty(TRB1->F3_DTCANC)
          cTikIni := TRB1->F3_NFISCAL        
          @ nLin,003 PSAY TRB1->F3_ENTRADA   
          @ nLin,015 PSAY cSerieT        
          @ nLin,022 PSAY cTikIni                     PICTURE PesqPict("SF3","F3_NFISCAL")
       Else
          DbSkip()
          Loop   
       EndIf   
       
       While xFilial("SF3") == TRB1->F3_FILIAL .And. dEntAnt == TRB1->F3_ENTRADA
       
	      cTikAtu  := TRB1->F3_NFISCAL	   	      	   
	   
          //Busca os impostos do TES 
          aImps := TesImpInf(TRB1->F3_TES)
          If Len(aImps) > 0
             cCpoValImp := "TRB1->F3"+Substr(aImps[1][2],3,10)        //Campo de gravacao do valor do imposto no arq. de Livros Fiscais
             cCpoBasImp := "TRB1->F3"+Substr(aImps[1][7],3,10)        //Campo de gravacao da base do imposto no arq. de Livros Fiscais  
          EndIf
	      
	      If Empty(TRB1->F3_DTCANC)
             If Len(aImps) > 0	         
                nBasImpTik += &(cCpoBasImp)       //Soma da base dos impostos por dia
                nValImpTik += &(cCpoValImp)       //Soma do valor dos impostos por dia             
	         EndIf
             nTotDiaTik += TRB1->F3_VALCONT	//Valor total de venda dos tickets por dia
	      EndIf   
				
	      dbSkip()
	   
	      If TRB1->F3_ENTRADA != dEntAnt .Or. Eof()
	         
	         //Imprime o intervalo de tickets do dia com os totalizadores(total de venda, base e valor do imposto)
             @ nLin,034 PSAY cTikAtu                   PICTURE PesqPict("SF3","F3_NFISCAL")
	         @ nLin,058 PSAY nTotDiaTik                PICTURE cPictVals	
             @ nLin,081 PSAY nBasImpTik                PICTURE cPictVals
             @ nLin,104 PSAY nValImpTik                PICTURE cPictVals
          
             nTotBsImpT += nBasImpTik          //Valor total da base de imposto dos tickets
             nTotVlImpT += nValImpTik          //Valor total do valor de imposto dos tickets 
             nTotalTik  += nTotDiaTik          //Valor total de venda dos tickets 
             
	         nLin := nLin + 1          
	         dEntAnt := TRB1->F3_ENTRADA
	         //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	         //³Dispara a funcao para impressao do Rodape. ³
	         //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	         If nLin > 55
		        R020RodT()
	         EndIf	      	         
	         Exit
	      EndIf
	   EndDo   	
EndDo   

//Rodape dos tickets
R020RodT()


//*****IMPRESSAO DE FATURAS*****
dbSelectArea("TRB2")
dbGoTop()

If !(Bof() .And. Eof())  //Verifica se ha faturas para a impressao
                   
   If lAbortPrint
      @ 00,01 PSAY OemToAnsi(STR0007) //"** CANCELADO PELO OPERADOR **"
      lContinua := .F.
   Endif

   nLin    := 80    
   lFinRel := .T.          
	
   //Impressao de vendas com FATURAS
   If nLin > 55
      R020CabF()    
   EndIf   
               
   While xFilial("SF3") == TRB2->F3_FILIAL .And. !Eof()
      If Empty(TRB2->F3_DTCANC)              
         nBasImpF := 0
         nValImpF := 0         
         nAlqImpF := 0         
         //Busca os impostos incidentes no TES
         aImps := TesImpInf(TRB2->F3_TES)
         If Len(aImps) > 0
            cCpoValImp := "TRB2->F3"+Substr(aImps[1][2],3,10)  //Campo de gravacao do valor do imposto no arq. de Livros Fiscais
            cCpoBasImp := "TRB2->F3"+Substr(aImps[1][7],3,10) //Campo de gravacao da base do imposto no arq. de Livros Fiscais           
            cCpoAlqImp := "TRB2->F3_ALQIMP"+Substr(aImps[1][7],10,1) //Campo de gravacao da aliquota do imposto no arq. de Livros Fiscais  
         
            nBasImpF  := &(cCpoBasImp)
            nValImpF  := &(cCpoValImp)
            nAlqImpF  := &(cCpoAlqImp)
         EndIf
                
         If AllTrim(TRB2->F3_ESPECIE) == "NCC"
            nSigno := -1
         Else 
            nSigno := 1
         EndIf   
       
         SA1->(DbSetOrder(1))
         If SA1->(DbSeek(xFilial("TRB2")+TRB2->F3_CLIEFOR+TRB2->F3_LOJA))
            cNome  := Substr(SA1->A1_NOME,1,30)
            cRif   := SA1->A1_CGC
         EndIf
                  
         @ nLin,003 PSAY TRB2->F3_ENTRADA    
         @ nLin,014 PSAY TRB2->F3_SERIE
         @ nLin,019 PSAY TRB2->F3_NFISCAL              PICTURE PesqPict("SF3","F3_NFISCAL")
         @ nLin,034 PSAY TRB2->F3_ESPECIE         
         @ nLin,041 PSAY cNome
         @ nLin,072 PSAY cRif                           PICTURE PesqPict("SA1","A1_CGC")
         @ nLin,093 PSAY TRB2->F3_VALCONT              PICTURE cPictVals	
         @ nLin,115 PSAY nBasImpF                       PICTURE cPictVals	
         @ nLin,142 PSAY nAlqImpF                       PICTURE "@E 999.99"
         @ nLin,159 PSAY nValImpF                       PICTURE cPictVals	       

         nTotBsImpF += nBasImpF           * nSigno     //Valor total da base de imposto das faturas
         nTotVlImpF += nValImpF           * nSigno   //Valor total do valor de imposto das faturas
         nTotalFat  += TRB2->F3_VALCONT  * nSigno    //Valor total de venda das faturas         
      Else                                                                
         @ nLin,003 PSAY TRB2->F3_ENTRADA    
         @ nLin,014 PSAY TRB2->F3_SERIE
         @ nLin,019 PSAY TRB2->F3_NFISCAL              PICTURE PesqPict("SF3","F3_NFISCAL")
         @ nLin,034 PSAY TRB2->F3_ESPECIE               
         @ nLin,041 PSAY OemToAnsi(STR0008)  //"** A N U L A D A **"			
      EndIf
      DbSkip()
      
       //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³Dispara a funcao para impressao do Rodape. ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	  If nLin > 55
	     R020RodF()
	  EndIf	      	                
   EndDo
   R020RodF()   
EndIf

lFinRel := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dispara a funcao para impressao do Rodape.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
R020RdpG()  //Rodape geral com totalizadores de tickets e faturas

Set Device To Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³R020CabT  ºAutor  ³Fernando Machima    º Data ³  13/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cabecalho do Livro de Tickets de IVA ( Ventas ).           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRTIK                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function R020Cab
Static Function R020CabT()

LOCAL cabec1       := OemToAnsi(STR0034) //"    Fecha     Serie    Rango de Tickets                                                                                                                                                                                          "
LOCAL cabec2       := OemToAnsi(STR0035) //"                       Del n.       Al n.                    Total Ventas          Base Impuesto          Valor Impuesto                                                                             "   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cabecalho para o Relatorio.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPagina := nPagina + 1
cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,18)

nLin := 10

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³R020RodT  ºAutor  ³Fernando Machima    º Data ³  13/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rodape do Livro de Tickets de IVA ( Ventas ).              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRTIK	                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function R020Rod
Static Function R020RodT()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dispara a funcao para impressao do Rodape.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLin := nLin + 2
@ nLin,010 PSAY OemToAnsi(STR0039) //"T O T A L E S : "   
@ nLin,058 PSAY Trans(nTotalTik,cPictVals)
@ nLin,081 PSAY Trans(nTotBsImpT,cPictVals)
@ nLin,104 PSAY Trans(nTotVlImpT,cPictVals)

If  !(lFinRel)
	R020CabT()
	@ nLin,000 PSAY OemToAnsi(STR0028) //"Transporte :"
	nLin:= nlin+1
EndIf
lFinRel := .F.

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³R020CabF  ºAutor  ³Fernando Machima    º Data ³  13/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cabecalho do Livro de Faturas de IVA ( Ventas ).           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRTIK                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function R020CabF
Static Function R020CabF()

LOCAL cabec1       := OemToAnsi(STR0037) //"   Fecha    Serie   Factura       Docto.   Razon Social                       RIF                Total Ventas         Base Impuesto         Alic. Imp.(%)      Valor Impuesto                        "
LOCAL cabec2       := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cabecalho para o Relatorio.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPagina := nPagina + 1
cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,18)

nLin := 10

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³R020RodF  ºAutor  ³Fernando Machima    º Data ³  13/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rodape do Libro de Faturas de IVA ( Ventas ).              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRTIK		                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function R020RodF
Static Function R020RodF()

nLin := nLin + 2

@ nLin,010 PSAY OemToAnsi(STR0039)   //"T O T A L E S : "   
@ nLin,093 PSAY nTotalFat  PICTURE cPictVals
@ nLin,115 PSAY nTotBsImpF PICTURE cPictVals
@ nLin,159 PSAY nTotVlImpF PICTURE cPictVals

If  !(lFinRel)
	R020CabF()
	@ nLin,000 PSAY OemToAnsi(STR0028) //"Transporte :"
	nLin:= nlin+1
EndIf
lFinRel := .F.

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³R020RdpG  ºAutor  ³Fernando Machima    º Data ³  13/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rodape Geral do Livro de IVA ( Ventas ).                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRTIK		                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function R020RdpG
Static Function R020RdpG()

nLin	:=	nLin + 2

@ nLin,003 PSAY OemToAnsi(STR0027) //"Resumen :"
nLin := nLin + 2
@ nLin,010 PSAY OemToAnsi(STR0029)  //"Facturas           :" 
@ nLin,093 PSAY Trans(nTotalFat,cPictVals)
@ nLin,115 PSAY Trans(nTotBsImpF,cPictVals)
@ nLin,159 PSAY Trans(nTotVlImpF,cPictVals)

nLin := nLin + 1
@ nLin,010 PSAY OemToAnsi(STR0030)  //"Tickets            :"
@ nLin,093 PSAY Trans(nTotalTik,cPictVals)
@ nLin,115 PSAY Trans(nTotBsImpT,cPictVals)
@ nLin,159 PSAY Trans(nTotVlImpT,cPictVals)

nLin := nLin + 3
@ nLin,010 PSAY OemToAnsi(STR0039) //"T O T A L E S : "   
@ nLin,093 PSAY Trans(nTotalFat  + nTotalTik,cPictVals)
@ nLin,115 PSAY Trans(nTotBsImpF + nTotBsImpT,cPictVals)
@ nLin,159 PSAY Trans(nTotVlImpF + nTotVlImpT,cPictVals)

Return
 
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AjustaSX1  ºAutor  ³Fernando Machima   º Data ³  13/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica as perguntas incluíndo-as caso näo existam        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³LIBRTIK - Livro de Ventas.                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()
Local _sAlias := Alias()
Local cPerg := PADR("LIBTIK",6)
Local aRegs :={}
Local nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Campos a serem grav. no SX1³
//³aRegs[nx][01] - x1_pergunte³
//³aRegs[nx][02] - x1_perspa  ³
//³aRegs[nx][03] - x1_pereng  ³
//³aRegs[nx][04] - x1_variavl ³
//³aRegs[nx][05] - x1_tipo    ³
//³aRegs[nx][06] - x1_tamanho ³
//³aRegs[nx][07] - x1_decimal ³
//³aRegs[nx][08] - x1_presel  ³
//³aRegs[nx][09] - x1_gsc     ³
//³aRegs[nx][10] - x1_valid   ³
//³aRegs[nx][11] - x1_var01   ³
//³aRegs[nx][12] - x1_def01   ³
//³aRegs[nx][13] - x1_defspa1 ³
//³aRegs[nx][14] - x1_defeng1 ³
//³aRegs[nx][15] - x1_cnt01   ³
//³aRegs[nx][16] - x1_var02   ³
//³aRegs[nx][17] - x1_def02   ³
//³aRegs[nx][18] - x1_defspa2 ³
//³aRegs[nx][19] - x1_defeng2 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aAdd(aRegs,{"Data De            ?","¨De Fecha          ?","From Date         ?","mv_ch1","D",8,0,0,"G","","mv_par01","","","","01/01/00","","","",""})
aAdd(aRegs,{"Data Ate           ?","¨Hasta Fecha       ?","To Date           ?","mv_ch2","D",8,0,0,"G","","mv_par02","","","","31/12/00","","","",""})
dbSelectArea("SX1")
dbSetOrder(1)

For nX:=1 to Len(aRegs)
	If !(dbSeek(cPerg+StrZero(nx,2)))
		RecLock("SX1",.T.)
		Replace X1_GRUPO	with cPerg
		Replace X1_ORDEM   	with StrZero(nx,2)
		Replace X1_PERGUNTE	with aRegs[nx][01]
		Replace X1_PERSPA	with aRegs[nx][02]
		Replace X1_PERENG	with aRegs[nx][03]
		Replace X1_VARIAVL	with aRegs[nx][04]
		Replace X1_TIPO		with aRegs[nx][05]
		Replace X1_TAMANHO	with aRegs[nx][06]
		Replace X1_DECIMAL	with aRegs[nx][07]
		Replace X1_PRESEL	with aRegs[nx][08]
		Replace X1_GSC		with aRegs[nx][09]
		Replace X1_VALID	with aRegs[nx][10]
		Replace X1_VAR01	with aRegs[nx][11]
		Replace X1_DEF01	with aRegs[nx][12]
		Replace X1_DEFSPA1	with aRegs[nx][13]
		Replace X1_DEFENG1	with aRegs[nx][14]
		Replace X1_CNT01	with aRegs[nx][15]
		Replace X1_VAR02	with aRegs[nx][16]
		Replace X1_DEF02	with aRegs[nx][17]
		Replace X1_DEFSPA2	with aRegs[nx][18]
		Replace X1_DEFENG2	with aRegs[nx][19]
		MsUnlock()
	Endif
Next nX
dbSelectArea(_sAlias)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ VerImp   ºAutor  ³Marcos Simidu       º Data ³  20/12/95   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica posicionamento de papel na Impressora             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRTIK                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da Funcao   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function VerImp
Static Function VerImp()

Local nOpc

nLin:= 0                // Contador de Linhas
aDriver:=ReadDriver()
If aReturn[5]==2
	
	nOpc       := 1
	While .T.
		
		SetPrc(0,0)
		dbCommitAll()
		
		@ 00   ,000	PSAY &aDriver[5]
		@ nLin ,000 PSAY " "
		@ nLin ,004 PSAY "*"
		@ nLin ,022 PSAY "."
		
		IF MsgYesNo(OemToAnsi(STR0032)) //"¿Fomulario esta en posicion? "
		   nOpc := 1
		ElseIF MsgYesNo(OemToAnsi(STR0033)) //"¿Intenta Nuevamente? "
		   nOpc := 2
		Else
		   nOpc := 3
		Endif

		Do Case
		Case nOpc==1
			lContinua := .T.
			Exit
		Case nOpc==2
			Loop
		Case nOpc==3
			lContinua := .F.
			Return
		EndCase
	End
Endif
Return
