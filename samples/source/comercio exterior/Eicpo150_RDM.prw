#INCLUDE "Eicpo150.ch"  
#INCLUDE "AvPrint.ch"  
#INCLUDE "Average.ch"  
#INCLUDE "rwmake.ch"       
#DEFINE INGLES                     1
#DEFINE PORTUGUES                  2    
#DEFINE DLG_CHARPIX_H   15.1
#DEFINE DLG_CHARPIX_W    7.9
#DEFINE LITERAL_PEDIDO             IF( nIdioma == INGLES, "PURCHASE ORDER NR: ", STR0001 ) //"NR. PEDIDO: "
#DEFINE LITERAL_ALTERACAO          IF( nIdioma == INGLES, "ALTERATION Number: ", STR0002 ) //"ALTERAÃ+O N·mero: "
#DEFINE LITERAL_DATA               IF( nIdioma == INGLES, "Date: "             , STR0003 ) //"Data: "
#DEFINE LITERAL_PAGINA             IF( nIdioma == INGLES, "Page: "             , STR0004 ) //"Pßgina: "
#DEFINE LITERAL_FORNECEDOR         IF( nIdioma == INGLES, "SUPPLIER........: " , STR0005 ) //"FORNECEDOR......: "
#DEFINE LITERAL_ENDERECO           IF( nIdioma == INGLES, "ADDRESS.........: " , STR0006 ) //"ENDEREÃO........: "
#DEFINE LITERAL_REPRESENTANTE      IF( nIdioma == INGLES, "REPRESENTATIVE..: " , STR0007 ) //"REPRESENTANTE...: "
#DEFINE LITERAL_REPR_TEL           IF( nIdioma == INGLES, "TEL.: "             , STR0008 ) //"FONE: "
#DEFINE LITERAL_COMISSAO           IF( nIdioma == INGLES, "COMMISSION......: " , STR0009 ) //"COMISS+O........: "
#DEFINE LITERAL_CONTATO            IF( nIdioma == INGLES, "CONTACT.........: " , STR0010 ) //"CONTATO.........: "
#DEFINE LITERAL_IMPORTADOR         IF( nIdioma == INGLES, "IMPORTER........: " , STR0011 ) //"IMPORTADOR......: "
#DEFINE LITERAL_CONDICAO_PAGAMENTO IF( nIdioma == INGLES, "TERMS OF PAYMENT: " , STR0012 ) //"COND. PAGAMENTO.: "
#DEFINE LITERAL_VIA_TRANSPORTE     IF( nIdioma == INGLES, "MODE OF DELIVERY: " , STR0013 ) //"VIA TRANSPORTE..: "
#DEFINE LITERAL_DESTINO            IF( nIdioma == INGLES, "DESTINATION.....: " , STR0014 ) //"DESTINO.........: "
#DEFINE LITERAL_AGENTE             IF( nIdioma == INGLES, "FORWARDER.......: " , STR0015 ) //"AGENTE..........: "
#DEFINE LITERAL_QUANTIDADE         IF( nIdioma == INGLES, "Quantity"           , STR0016 ) //"Quantidade"
#DEFINE LITERAL_DESCRICAO          IF( nIdioma == INGLES, "Description"        , STR0017 ) //"DescriþÒo"
#DEFINE LITERAL_FABRICANTE         IF( nIdioma == INGLES, "Manufacturer"       , STR0018 ) //"Fabricante"
#DEFINE LITERAL_PRECO_UNITARIO1    IF( nIdioma == INGLES, "Unit"               , STR0019 ) //"Preþo"
#DEFINE LITERAL_PRECO_UNITARIO2    IF( nIdioma == INGLES, "Price"              , STR0020 ) //"Unitßrio"
#DEFINE LITERAL_TOTAL_MOEDA        IF( nIdioma == INGLES, "Amount"             , STR0021 ) //"   Total"
#DEFINE LITERAL_DATA_PREVISTA1     IF( nIdioma == INGLES, "Req. Ship"          , STR0022 ) //"Data Prev."
#DEFINE LITERAL_DATA_PREVISTA2     IF( nIdioma == INGLES, "Date"               , STR0023 ) //"Embarque"
#DEFINE LITERAL_OBSERVACOES        IF( nIdioma == INGLES, "REMARKS"            , STR0024 ) //"OBSERVAÃiES"
#DEFINE LITERAL_INLAND_CHARGES     IF( nIdioma == INGLES, "INLAND CHARGES"     , STR0025 ) //"Despesas Internas"
#DEFINE LITERAL_PACKING_CHARGES    IF( nIdioma == INGLES, "PACKING CHARGES"    , STR0026 ) //"Despesas Embalagem"
#DEFINE LITERAL_INTL_FREIGHT       IF( nIdioma == INGLES, "INT'L FREIGHT"      , STR0027 ) //"Frete Internacional"
#DEFINE LITERAL_DISCOUNT           IF( nIdioma == INGLES, "DISCOUNT"           , STR0028 ) //"Desconto"

Static aMarcados:={},nMarcados  

User Function Eicpo150()        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPOINT1P,LPOINT1P,CPOINT2P,LPOINT2P,CMARCA,LINVERTE")
SetPrvt("APOS,AROTINA,BFUNCAO,NCONT")
SetPrvt("NTOTAL,NTOTALGERAL,NIDIOMA,CCADASTRO,NPAGINA,ODLGIDIOMA")
SetPrvt("NVOLTA,ORADIO1,LEND,OPRINT>,LINHA,PTIPO")
SetPrvt("CINDEX,CCOND,NINDEX,NOLDAREA,OFONT1")
SetPrvt("OFONT2,OFONT3,OFONT4,OFONT5,OFONT6,OFONT7")
SetPrvt("OFONT8,OFONT9,OPRN,AFONTES,CCLICOMP,ACAMPOS")
SetPrvt("CNOMARQ,AHEADER,LCRIAWORK,CPICTQTDE,CPICT1TOTAL")
SetPrvt("CPICT2TOTAL,CQUERY,OFONT10,OFNT,C2ENDSM0,C2ENDSA2")
SetPrvt("CCOMMISSION,C2ENDSYT,CTERMS,CDESTINAT,CREPR,CCGC")
SetPrvt("CNR,CPOINTS,I,N1,N2,NNUMERO")
SetPrvt("BACUMULA,BWHILE,LPULALINHA,NTAM,CDESCRITEM,CREMARKS")
SetPrvt("XLINHA,")

// Para imprimir um BitMap
// Ex: oSend(oPrn, "SayBitmap", nLin, 100, "SEAL.BMP" , 400, 200 )

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    ¦EICPO150  ¦ Autor ¦ Cristiano A. Ferreira ¦ Data ¦09/11/1998¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦Emissao do Pedido                                           ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sintaxe   ¦#EICPO150                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

Private _PictPo:=ALLTRIM(X3Picture("W2_PO_NUM"))
aMarcados:={}  

cPoint1P := "EICPO1P"
lPoint1P := ExistBlock(cPoint1P)

cPoint2P := "EICPOPIC"
lPoint2P := ExistBlock(cPoint2P)

cMarca := Nil; lInverte:=.F.
aPos:= {  8,  4, 11, 74 }

aRotina := {{ STR0029,"AxPesqui"  , 0 , 1},; //"Pesquisar"
            { STR0030,"Eval(bFuncao)", 0 , 0}} //"Emissao"###"ReEmissao"

bFuncao := {|| PO150Impr() }
nCont := 0; nTotal:=0; nTotalGeral:=0; nIdioma:=INGLES

cCadastro := STR0032 //"Seleção de Purchase Order"
nPagina:=0

SA5->(DBSETORDER(2))
cMarca := GetMark()
                         

//+--------------------------------------------------------------+
//¦ Pega picture especifica para Unisys ( Qtde e Total )         ¦
//+--------------------------------------------------------------+

IF lPoint1P
   ExecBlock( cPoint1P,.F.,.F.,"1" )
ENDIF
//+-----------------------------------------------------------------+
//¦ Pega picture especifica para Deda Behring  Qtde e Preco unitario¦
//+-----------------------------------------------------------------+

IF lPoint2P
   ExecBlock( cPoint2P ,.F.,.F. )
ENDIF

dbSelectArea("SW2")  
SW2->(MarkBrow("SW2","W2_OK",,,,cMarca,,,,,"U_PO150Marca()")) //EMISSAO

SA5->(DBSETORDER(1))

Return(NIL)        

*----------------------------------------------
User Function PO150Marca()
*----------------------------------------------
Local nPos:=aScan(aMarcados,SW2->(RecNo()))

If SoftLock("SW2")
   If SW2->W2_OK == cMarca
      SW2->W2_OK := ""    
      If nPos > 0
         aDel(aMarcados,nPos)
         aSize(aMarcados,Len(aMarcados)-1)
      Endif                               
   Else
      SW2->W2_OK := cMarca
      If nPos = 0
         aAdd(aMarcados,SW2->(Recno()))
      Endif                               
   Endif
Endif   
Return
*--------------------------*
Static FUNCTION PO150Impr()
*--------------------------*
oDlgIdioma := nVolta := oRadio1 := Nil
lEnd := nil

@ (9*DLG_CHARPIX_H),(10*DLG_CHARPIX_W) TO (17*DLG_CHARPIX_H),(45*DLG_CHARPIX_W) DIALOG oDlgIdioma TITLE AnsiToOem(STR0033) //"Seleção"

@  8,10 TO 48,80 TITLE STR0034 //"Selecione o Idioma"

nVolta:=0

//oRadio1 := oSend( TRadMenu(), "New", 18, 13, {STR0035,STR0036},{|u| If(PCount() == 0, nIdioma, nIdioma := u)}, oDlgIdioma,,,,,, .F.,, 45, 13,, .F., .T., .T. ) //"Inglês"###"Idioma Corrente"
oRadio1 := oSend( TRadMenu(), "New", 17, 13, {STR0035,STR0036},{|u| If(PCount() == 0, nIdioma, nIdioma := u)}, oDlgIdioma,,,,,, .F.,, 55, 13,, .F., .T., .T. ) //"Inglês"###"Idioma Corrente"

oSend( SButton(), "New", 10, 90,1, {|| nVolta:=1, oSend(oDlgIdioma, "End")}, oDlgIdioma, .T.,,)
oSend( SButton(), "New", 37, 90,2, {|| oSend(oDlgIdioma,"End")}, oDlgIdioma, .T.,,)

ACTIVATE DIALOG oDlgIdioma CENTERED

IF nVolta == 1
   PO150Report()
Endif

Return(NIL)        


*----------------------------*
Static FUNCTION PO150Report()
*----------------------------*

#xtranslate :TIMES_NEW_ROMAN_18_NEGRITO    => \[1\]
#xtranslate :TIMES_NEW_ROMAN_12            => \[2\]
#xtranslate :TIMES_NEW_ROMAN_12_NEGRITO    => \[3\]
#xtranslate :COURIER_08_NEGRITO            => \[4\]
#xtranslate :TIMES_NEW_ROMAN_08_NEGRITO    => \[5\]
#xtranslate :COURIER_12_NEGRITO            => \[6\]
#xtranslate :COURIER_20_NEGRITO            => \[7\]
#xtranslate :TIMES_NEW_ROMAN_10_NEGRITO    => \[8\]
#xtranslate :TIMES_NEW_ROMAN_08_UNDERLINE  => \[9\]
#xtranslate :COURIER_NEW_10_NEGRITO        => \[10\]

#COMMAND    TRACO_NORMAL                   => oSend(oPrn,"Line", Linha  ,  50, Linha  , 2300 ) ;
                                           ;  oSend(oPrn,"Line", Linha+1,  50, Linha+1, 2300 )

#COMMAND    TRACO_REDUZIDO                 => oSend(oPrn,"Line", Linha  ,1200, Linha  , 2300 ) ;
                                           ;  oSend(oPrn,"Line", Linha+1,1200, Linha+1, 2300 )

#COMMAND    ENCERRA_PAGINA                 => oSend(oPrn,"oFont",aFontes:COURIER_20_NEGRITO) ;
                                           ;  TRACO_NORMAL


#COMMAND    COMECA_PAGINA                  => AVNEWPAGE                    ;
                                           ;  Linha := 180                 ;
                                           ;  nPagina := nPagina+ 1        ;
                                           ;  pTipo := 2                   ;
                                           ;  PO150Cabec()                 ;
                                           ;  PO150Cab_Itens()


#xTranslate  DATA_MES(<x>) =>              SUBSTR(DTOC(<x>)  ,1,2)+ " " + ;
                                           IF( nIdioma == INGLES,;
                                               SUBSTR(CMONTH(<x>),1,3),;
                                               SUBSTR(Nome_Mes(MONTH(<x>)),1,3) ) +; 
                                           " " + LEFT(DTOS(<x>)  ,4)


cIndex := cCond := nIndex := Nil; nOldArea:=ALIAS()
oFont1:=oFont2:=oFont3:=oFont4:=oFont5:=oFont6:=oFont7:=oFont8:=oFont9:=Nil
oPrn:= Linha:= aFontes:= Nil; cCliComp:=""
aCampos:={}; cNomArq:=Nil; aHeader:={}
lCriaWork:=.T.

cPictQtde:='@E 999,999,999.999'; cPict1Total:='@E 999,999,999,999.99999'
cPict2Total:='@E 99,999,999,999,999.99999'

nMarcados:=Len(aMarcados)

IF nMarcados == 0
   MsgInfo(STR0037,STR0038) //"NÒo existem registros marcados para a impressÒo !"###"AtenþÒo"

ELSE
   dbSelectArea("SW2")

   AVPRINT oPrn NAME STR0039 //"EmissÒo do Pedido"
      //                              Font            W  H  Bold          Device
      oFont1 := oSend(TFont(),"New","Times New Roman",0,18,,.T.,,,,,,,,,,,oPrn )
      oFont2 := oSend(TFont(),"New","Times New Roman",0,12,,.F.,,,,,,,,,,,oPrn )
      oFont3 := oSend(TFont(),"New","Times New Roman",0,12,,.T.,,,,,,,,,,,oPrn )
      oFont4 := oSend(TFont(),"New","Courier New"    ,0,10,,.T.,,,,,,,,,,,oPrn )
      oFont5 := oSend(TFont(),"New","Times New Roman",0,08,,.T.,,,,,,,,,,,oPrn )
      oFont6 := oSend(TFont(),"New","Courier New"    ,0,12,,.T.,,,,,,,,,,,oPrn )
      oFont7 := oSend(TFont(),"New","Courier New"    ,0,26,,.T.,,,,,,,,,,,oPrn )
      oFont8 := oSend(TFont(),"New","Times New Roman",0,10,,.T.,,,,,,,,,,,oPrn )
      //                                                            Underline
      oFont9 := oSend(TFont(),"New","Times New Roman",0,10,,.T.,,,,,.T.,,,,,,oPrn )
      oFont10:= oSend(TFont(),"New","Courier New"    ,0,10,,.T.,,,,,,,,,,,oPrn )

      aFontes := { oFont1, oFont2, oFont3, oFont4, oFont5, oFont6, oFont7, oFont8, oFont9, oFont10 }

      AVPAGE

         Processa({|X| lEnd := X, PO150Det() })

      AVENDPAGE

      oSend(oFont1,"End")
      oSend(oFont2,"End")
      oSend(oFont3,"End")
      oSend(oFont4,"End")
      oSend(oFont5,"End")
      oSend(oFont6,"End")
      oSend(oFont7,"End")
      oSend(oFont8,"End")
      oSend(oFont9,"End")

   AVENDPRINT

   dbSelectArea("SW2")
   dbGoTop()
ENDIF
aMarcados:={}
Return .T.

*--------------------------*
Static Function PO150Det()
*--------------------------*
Local nMarcados
ProcRegua(Len(aMarcados))  //LRL 11/02/04 - ProcRegua(nMarcados))

For nMarcados:=1 To Len(aMarcados)

   SW2->(dbGoTo(aMarcados[nMarcados]))
   IncProc("Imprimindo...") // Atualiza barra de progresso

   Linha := 180
   nTotal:=nTotalGeral:=0
   nPagina:=1
   nCont := 0

   pTipo := 1
   PO150Cabec()

   dbSelectArea("SW3")
   SW3->(dbSetOrder(1))
   SW3->(dbSeek(xFilial()+SW2->W2_PO_NUM))

   While SW3->(!Eof()) .AND.;
         SW3->W3_FILIAL == XFILIAL("SW3") .AND. ;
         SW3->W3_PO_NUM == SW2->W2_PO_NUM

      If SW3->W3_SEQ #0
         SW3->(dbSkip())
         LOOP
      Endif

      If Linha >= 3000
         ENCERRA_PAGINA
         COMECA_PAGINA
      Endif

      PO150Item()

      oFnt := aFontes:COURIER_20_NEGRITO
      pTipo := 5
      PO150BateTraco()
      Linha := Linha + 50

      SW3->(dbSkip())
   Enddo //loop dos itens SW3

   cCliComp:=IF(GetMv("MV_ID_CLI")='S',SA1->A1_NOME,SY1->Y1_NOME)
   PO150Remarks()
   PO150Totais()

   oSend(oPrn,"Line", Linha, 50, Linha, 1200 )
   oSend(oPrn,"Line", Linha+1, 50, Linha+1, 1200 )

   Linha := Linha + 70
   oSend(oPrn,"Say", Linha, 50, cCliComp, aFontes:TIMES_NEW_ROMAN_12 )

   //+---------------------------------------------------------+
   //¦ Atualiza FLAG de EMITIDO                                ¦
   //+---------------------------------------------------------+
   dbSelectArea("SW2")

   RecLock("SW2",.F.)
   SW2->W2_EMITIDO := "S" //PO Impresso
   SW2->W2_OK      := ""  //PO Desmarcado
   MsUnLock()

   If nMarcados+1 <= Len(aMarcados)
      AVNEWPAGE
   Endif

Next // LOOP DO PO/SW2

Return nil

*---------------------------*
Static FUNCTION PO150Cabec()
*---------------------------*

c2EndSM0:=""; c2EndSA2:=""; cCommission:=""; c2EndSYT:=""; cTerms:=""
cDestinat:=""; cRepr:=""; cCGC:=""; cNr:=""

IF GetMv("MV_ID_CLI") == 'S'
   //-----------> Cliente.
   SA1->( DBSETORDER( 1 ) )
   SA1->( DBSEEK( xFilial("SA1")+SW2->W2_CLIENTE ) )
ELSE
   // --------->  Comprador.
   SY1->( DBSETORDER(1) )
   SY1->( DBSEEK( xFilial("SY1")+SW2->W2_COMPRA ) )
ENDIF
//----------->  Fornecedor.
SA2->( DBSETORDER( 1 ) )
SA2->( DBSEEK( xFilial()+SW2->W2_FORN ) )
//----------->  Paises.
SYA->( DBSETORDER( 1 ) )
SYA->( DBSEEK( xFilial()+SA2->A2_PAIS ) )
c2EndSA2 := c2EndSA2 + IF( !EMPTY(SA2->A2_MUN   ), ALLTRIM(SA2->A2_MUN   )+' - ', "" )
c2EndSA2 := c2EndSA2 + IF( !EMPTY(SA2->A2_BAIRRO), ALLTRIM(SA2->A2_BAIRRO)+' - ', "" )
c2EndSA2 := c2EndSA2 + IF( !EMPTY(SA2->A2_ESTADO), ALLTRIM(SA2->A2_ESTADO)+' - ', "" )
c2EndSA2 := c2EndSA2 + IF( !EMPTY(SYA->YA_DESCR ), ALLTRIM(SYA->YA_DESCR )+' - ', "" )
c2EndSA2 := LEFT( c2EndSA2, LEN(c2EndSA2)-2 )

//-----------> Pedidos.
IF SW2->W2_COMIS $ cSim
   cCommission :=SW2->W2_MOEDA+" "+TRANS(SW2->W2_VAL_COM,E_TrocaVP(nIdioma,'@E 9,999,999,999.9999'))
   IF( SW2->W2_TIP_COM == "1", cCommission:=TRANS(SW2->W2_PER_COM,E_TrocaVP(nIdioma,'@E 999.99'))+"%", )
   IF( SW2->W2_TIP_COM == "4", cCommission:=SW2->W2_OUT_COM, )
ENDIF

//-----------> Importador.
SYT->( DBSETORDER( 1 ) )
SYT->( DBSEEK( xFilial()+SW2->W2_IMPORT ) )

c2EndSYT := c2EndSYT + IF( !EMPTY(SYT->YT_CIDADE), ALLTRIM(SYT->YT_CIDADE)+' - ', "" )
c2EndSYT := c2EndSYT + IF( !EMPTY(SYT->YT_ESTADO), ALLTRIM(SYT->YT_ESTADO)+' - ', "" )
c2EndSYT := c2EndSYT + IF( !EMPTY(SYT->YT_PAIS  ), ALLTRIM(SYT->YT_PAIS  )+' - ', "" )
c2EndSYT := LEFT( c2EndSYT, LEN(c2EndSYT)-2 )
cCgc     := ALLTRIM(SYT->YT_CGC)

IF GetMv("MV_ID_EMPR") == 'S'
   c2EndSM0 := c2EndSM0 +IF( !EMPTY(SM0->M0_CIDCOB), ALLTRIM(SM0->M0_CIDCOB)+' - ', "" )
   c2EndSM0 := c2EndSM0 +IF( !EMPTY(SM0->M0_ESTCOB), ALLTRIM(SM0->M0_ESTCOB)+' - ', "" )
   c2EndSM0 := c2EndSM0 +IF( !EMPTY(SM0->M0_CEPCOB), TRANS(SM0->M0_CEPCOB,"@R 99999-999")+' - ', "" )
   c2EndSM0 := LEFT( c2EndSM0, LEN(c2EndSM0)-2 )
   //acd   cCgc:=ALLTRIM(SM0->M0_CGC)
ELSE
   c2EndSM0 := c2EndSM0 +IF( !EMPTY(SYT->YT_CIDADE), ALLTRIM(SYT->YT_CIDADE)+' - ', "" )
   c2EndSM0 := c2EndSM0 +IF( !EMPTY(SYT->YT_ESTADO), ALLTRIM(SYT->YT_ESTADO)+' - ', "" )
   c2EndSM0 := c2EndSM0 +IF( !EMPTY(SYT->YT_CEP), TRANS(SYT->YT_CEP,"@R 99999-999")+' - ', "" )
   c2EndSM0 := LEFT( c2EndSM0, LEN(c2EndSM0)-2 )
   //acd   cCgc:=ALLTRIM(SYT->YT_CGC)
ENDIF

//-----------> Condicoes de Pagamento.
SY6->( DBSETORDER( 1 ) )
SY6->( DBSEEK( xFilial()+SW2->W2_COND_PA+STR(SW2->W2_DIAS_PA,3,0) ) )
      
IF nIdioma == INGLES
   cTerms := MSMM(SY6->Y6_DESC_I,48)
ELSE
   cTerms := MSMM(SY6->Y6_DESC_P,48)
ENDIF
STRTRAN(cTerms, CHR(13)+CHR(10), " ")

//-----------> Portos.
//acd   SY9->( DBSETORDER( 1 ) )
SY9->( DBSETORDER( 2 ) )
SY9->( DBSEEK( xFilial()+SW2->W2_DEST ) )

cDestinat := ALLTRIM(SW2->W2_DEST) + " - " + ALLTRIM(SY9->Y9_DESCR)

//-----------> Agentes Embarcadores.
SY4->( DBSETORDER( 1 ) )
SY4->( DBSEEK( xFilial()+SW2->W2_FORWARD ) )

//-----------> Agentes Embarcadores.
SYQ->( DBSEEK( xFilial()+SW2->W2_TIPO_EMB ) )

//-----------> Agentes Compradores.
SY1->(DBSEEK(xFilial()+SW2->W2_COMPRA))


oSend( oPrn, "oFont", aFontes:COURIER_20_NEGRITO )
TRACO_NORMAL
Linha := Linha+70

IF GetMv("MV_ID_EMPR") == 'S'
   oSend( oPrn, "Say", Linha    , 1150, ALLTRIM(SM0->M0_NOME)  , aFontes:TIMES_NEW_ROMAN_18_NEGRITO,,,, 2 )
   Linha:=Linha+150
   oSend( oPrn, "Say", Linha    , 1150, ALLTRIM(SM0->M0_ENDCOB), aFontes:TIMES_NEW_ROMAN_12,,,, 2 )
ELSE
   cNr:=IF(!EMPTY(SYT->YT_NR_END),", "+ALLTRIM(STR(SYT->YT_NR_END,6)),"")
   oSend( oPrn, "Say", Linha    , 1150, ALLTRIM(SYT->YT_NOME)    , aFontes:TIMES_NEW_ROMAN_18_NEGRITO,,,, 2 )
   Linha:=Linha+150
   oSend( oPrn, "Say", Linha    , 1150, ALLTRIM(SYT->YT_ENDE)+cNr, aFontes:TIMES_NEW_ROMAN_12,,,, 2 )
ENDIF

oSend( oPrn, "Say", Linha:= Linha+50, 1150, ALLTRIM(c2EndSM0), aFontes:TIMES_NEW_ROMAN_12,,,, 2 )

IF GetMv("MV_ID_CLI") == 'S'  // Cliente.

   IF ! EMPTY( ALLTRIM(SA1->A1_TEL) )
      oSend( oPrn, "Say", Linha := Linha+50, 1150, "Tel: " + ALLTRIM(SA1->A1_TEL), aFontes:TIMES_NEW_ROMAN_12,,,, 2 )
   ENDIF
   IF ! EMPTY( ALLTRIM(SA1->A1_FAX) )
      oSend( oPrn, "Say", Linha := Linha+50, 1150, "Fax: " + ALLTRIM(SA1->A1_FAX), aFontes:TIMES_NEW_ROMAN_12,,,, 2 )
   ENDIF

ELSE                         // Comprador.

   IF ! EMPTY( ALLTRIM(SY1->Y1_TEL) )
      oSend( oPrn, "Say", Linha := Linha+50, 1150, "Tel: " + ALLTRIM(SY1->Y1_TEL), aFontes:TIMES_NEW_ROMAN_12,,,, 2 )
   ENDIF
   IF ! EMPTY( ALLTRIM(SY1->Y1_FAX) )
      oSend( oPrn, "Say", Linha := Linha+50, 1150, "Fax: " + ALLTRIM(SY1->Y1_FAX), aFontes:TIMES_NEW_ROMAN_12,,,, 2 )
   ENDIF

ENDIF
Linha := Linha+100

oSend( oPrn, "oFont", aFontes:COURIER_20_NEGRITO )
TRACO_NORMAL
Linha := Linha+30

oSend( oPrn, "Say", Linha, 1150, LITERAL_PEDIDO + ALLTRIM(TRANS(SW2->W2_PO_NUM,_PictPo)), aFontes:TIMES_NEW_ROMAN_12,,,,2 )
Linha := Linha+100

IF ! EMPTY(SW2->W2_NR_ALTE)
   oSend( oPrn, "Say", Linha, 400 , LITERAL_ALTERACAO + STRZERO(SW2->W2_NR_ALTE,2) , aFontes:TIMES_NEW_ROMAN_12 )
   oSend( oPrn, "Say", Linha, 1770, LITERAL_DATA + DATA_MES( SW2->W2_DT_ALTE )     , aFontes:TIMES_NEW_ROMAN_12 )
   Linha:=Linha+100
ENDIF

oSend( oPrn, "Say", Linha, 400 , LITERAL_DATA + DATA_MES( dDataBase ) , aFontes:TIMES_NEW_ROMAN_12 )
oSend( oPrn, "Say", Linha, 1770, LITERAL_PAGINA + STRZERO(nPagina,3)  , aFontes:TIMES_NEW_ROMAN_12 )
Linha := Linha+100

If pTipo == 2  // A partir da 2o. página.
   Return
Endif

oSend( oPrn, "oFont", aFontes:COURIER_20_NEGRITO )
TRACO_NORMAL

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 3
PO150BateTraco()
Linha := Linha+20

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 1
PO150BateTraco()

oSend( oPrn, "Say",  Linha, 100, LITERAL_FORNECEDOR, aFontes:COURIER_12_NEGRITO )
oSend( oPrn, "Say",  Linha, 630, SA2->A2_NOME      , aFontes:TIMES_NEW_ROMAN_12 )
Linha := Linha+50

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 1
PO150BateTraco()

oSend( oPrn, "Say",  Linha, 100, LITERAL_ENDERECO, aFontes:COURIER_12_NEGRITO )
oSend( oPrn, "Say",  Linha, 630, ALLTRIM(SA2->A2_END)+" "+ALLTRIM(SA2->A2_NR_END), aFontes:TIMES_NEW_ROMAN_12 )
Linha := Linha+50

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 1
PO150BateTraco()

oSend( oPrn, "Say",  Linha, 630, c2EndSA2              , aFontes:TIMES_NEW_ROMAN_12 )
Linha := Linha+50

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 1
PO150BateTraco()

oSend( oPrn, "Say",  Linha, 630, SA2->A2_CEP           , aFontes:TIMES_NEW_ROMAN_12 )
Linha := Linha+50

cRepr:=IF(nIdioma==INGLES,"NONE","NAO HA")

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 1
PO150BateTraco()

oSend( oPrn, "Say",  Linha, 100, LITERAL_REPRESENTANTE, aFontes:COURIER_12_NEGRITO )
oSend( oPrn, "Say",  Linha, 630, IF(EMPTY(SA2->A2_REPRES),cRepr,SA2->A2_REPRES)       , aFontes:TIMES_NEW_ROMAN_12 )
Linha := Linha+50

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 1
PO150BateTraco()

oSend( oPrn, "Say",  Linha, 100, LITERAL_ENDERECO, aFontes:COURIER_12_NEGRITO )
oSend( oPrn, "Say",  Linha, 630, SA2->A2_REPR_EN , aFontes:TIMES_NEW_ROMAN_12 )
Linha := Linha+50

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 1
PO150BateTraco()

oSend( oPrn, "Say",  Linha, 100, LITERAL_COMISSAO, aFontes:COURIER_12_NEGRITO )
oSend( oPrn, "Say",  Linha, 630, cCommission     , aFontes:TIMES_NEW_ROMAN_12 )

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 1
PO150BateTraco()

oSend( oPrn, "Say",  Linha,1750, LITERAL_REPR_TEL, aFontes:COURIER_12_NEGRITO )
oSend( oPrn, "Say",  Linha,1910, ALLTRIM(IF(!EMPTY(SA2->A2_REPRES),SA2->A2_REPRTEL,SA2->A2_TEL)), aFontes:TIMES_NEW_ROMAN_12 )
Linha := Linha+50

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 1
PO150BateTraco()

oSend( oPrn, "Say",  Linha, 100, LITERAL_CONTATO, aFontes:COURIER_12_NEGRITO )
oSend( oPrn, "Say",  Linha, 630, SA2->A2_CONTATO, aFontes:TIMES_NEW_ROMAN_12 )

oSend( oPrn, "Say",  Linha,1750, "FAX.: "           , aFontes:COURIER_12_NEGRITO )
oSend( oPrn, "Say",  Linha,1910, ALLTRIM(IF(!EMPTY(SA2->A2_REPRES),SA2->A2_REPRFAX,SA2->A2_FAX)), aFontes:TIMES_NEW_ROMAN_12 )
Linha := Linha+50

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 3
PO150BateTraco()

Linha := Linha+20
oSend( oPrn, "oFont", aFontes:COURIER_20_NEGRITO )
TRACO_NORMAL
Linha := Linha+20

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 1
PO150BateTraco()

oSend( oPrn, "Say",  Linha, 100, LITERAL_IMPORTADOR, aFontes:COURIER_12_NEGRITO )
oSend( oPrn, "Say",  Linha, 630, SYT->YT_NOME      , aFontes:TIMES_NEW_ROMAN_12 )
Linha := Linha+50

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 1
PO150BateTraco()

cNr:=IF(!EMPTY(SYT->YT_NR_END),", "+ALLTRIM(STR(SYT->YT_NR_END,6)),"")

oSend( oPrn, "Say",  Linha, 630, ALLTRIM(SYT->YT_ENDE)+cNr, aFontes:TIMES_NEW_ROMAN_12 )
Linha := Linha+50

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 1
PO150BateTraco()

oSend( oPrn, "Say",  Linha, 630, c2EndSYT           , aFontes:TIMES_NEW_ROMAN_12 )
Linha := Linha+50

IF ! EMPTY(cCGC)
   oFnt := aFontes:COURIER_20_NEGRITO
   pTipo := 1
   PO150BateTraco()

   oSend( oPrn, "Say",  Linha, 630, "C.N.P.J. " + Trans(cCGC,"@R 99.999.999/9999-99") , aFontes:TIMES_NEW_ROMAN_12 )
   Linha := Linha+50
ENDIF

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 3
PO150BateTraco()

Linha := Linha+20
oSend( oPrn, "oFont", aFontes:COURIER_20_NEGRITO)
TRACO_NORMAL
Linha := Linha+20

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 1
PO150BateTraco()

oSend( oPrn, "Say",  Linha, 100 , STR0040, aFontes:COURIER_12_NEGRITO ) //"PROFORMA INVOICE: "
oSend( oPrn, "Say",  Linha, 630 , SW2->W2_NR_PRO      , aFontes:TIMES_NEW_ROMAN_12 )

oSend( oPrn, "Say",  Linha, 1720, LITERAL_DATA            , aFontes:COURIER_12_NEGRITO )
oSend( oPrn, "Say",  Linha, 1920, DATA_MES(SW2->W2_DT_PRO), aFontes:TIMES_NEW_ROMAN_12 )
Linha := Linha+50

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 3
PO150BateTraco()

Linha := Linha+20
oSend(oPrn,"oFont",aFontes:COURIER_20_NEGRITO)
TRACO_NORMAL

oSend(oPrn,"Line", Linha-50,   50, (Linha+150),   50 ) ; oSend(oPrn,"Line", Linha-50,   51, (Linha+150),   51 )
oSend(oPrn,"Line", Linha-50, 2300, (Linha+150), 2300 ) ; oSend(oPrn,"Line", Linha-50, 2301, (Linha+150), 2301 )

Linha := Linha+50

oSend( oPrn, "Say",  Linha, 100, LITERAL_CONDICAO_PAGAMENTO , aFontes:COURIER_12_NEGRITO )
oSend( oPrn, "Say",  Linha, 630, MEMOLINE(cTerms,48,1)      , aFontes:TIMES_NEW_ROMAN_12 )
Linha := Linha+50

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 3
PO150BateTraco()

Linha := Linha+20
oSend( oPrn, "oFont", aFontes:COURIER_20_NEGRITO )

oSend( oPrn, "Line",  Linha  ,  50, Linha  , 2300 )
oSend( oPrn, "Line",  Linha+1,  50, Linha+1, 2300 )
Linha := Linha+20

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 1
PO150BateTraco()

oSend( oPrn, "Say",  Linha, 100, STR0041 , aFontes:COURIER_12_NEGRITO ) //"INCOTERMS.......: "
oSend( oPrn, "Say",  Linha, 630, ALLTRIM(SW2->W2_INCOTERMS)+" "+ALLTRIM(SW2->W2_COMPL_I), aFontes:TIMES_NEW_ROMAN_12 )
Linha := Linha+50

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 1
PO150BateTraco()

oSend( oPrn, "Say",  Linha, 100, LITERAL_VIA_TRANSPORTE , aFontes:COURIER_12_NEGRITO )
oSend( oPrn, "Say",  Linha, 630, SYQ->YQ_DESCR          , aFontes:TIMES_NEW_ROMAN_12 )
Linha := Linha+50

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 1
PO150BateTraco()

oSend( oPrn, "Say",  Linha, 100, LITERAL_DESTINO , aFontes:COURIER_12_NEGRITO )
oSend( oPrn, "Say",  Linha, 630, cDestinat       , aFontes:TIMES_NEW_ROMAN_12 )
Linha := Linha+50

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 1
PO150BateTraco()

oSend( oPrn, "Say",  Linha, 100, LITERAL_AGENTE, aFontes:COURIER_12_NEGRITO )
oSend( oPrn, "Say",  Linha, 630, SY4->Y4_NOME  , aFontes:TIMES_NEW_ROMAN_12 )
Linha := Linha+50

PO150Cab_Itens()

Return

*--------------------------------*
Static FUNCTION PO150Cab_Itens()
*--------------------------------*

Linha := Linha+20

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 4
PO150BateTraco()

oSend(oPrn,"oFont", aFontes:COURIER_20_NEGRITO)  // Define fonte padrao
TRACO_NORMAL

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 2
PO150BateTraco()

Linha := Linha+20

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 4
PO150BateTraco()

oSend( oPrn, "Say",  Linha,  065, STR0042                , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) //"IT"
oSend( oPrn, "Say",  Linha,  200, LITERAL_QUANTIDADE     , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say",  Linha,  470, LITERAL_DESCRICAO      , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say",  Linha, 1500, LITERAL_FABRICANTE     , aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,,1 )
oSend( oPrn, "Say",  Linha, 1570, LITERAL_PRECO_UNITARIO1, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say",  Linha, 1840, LITERAL_TOTAL_MOEDA    , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say",  Linha, 2130, LITERAL_DATA_PREVISTA1 , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Linha := Linha+50

pTipo := 5
oFnt := aFontes:COURIER_20_NEGRITO
PO150BateTraco()

oSend( oPrn, "Say",  Linha,   65, STR0043                   , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) //"Nb"
oSend( oPrn, "Say",  Linha, 1570, LITERAL_PRECO_UNITARIO2, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say",  Linha, 1870, SW2->W2_MOEDA          , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say",  Linha, 2130, LITERAL_DATA_PREVISTA2 , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )

Linha := Linha+50

oSend(oPrn,"oFont", aFontes:COURIER_20_NEGRITO) // Define fonte padrao

TRACO_NORMAL

RETURN NIL

*-------------------------*
Static FUNCTION PO150Item()
*-------------------------*
Local i
cPointS :="EICPOOLI"
i := n1 := n2 := nil
nNumero := 1
bAcumula := bWhile := lPulaLinha := nil
nTam := 36
cDescrItem := "" //Esta variavel é Private por causa do Rdmake "EICPOOLI"

//-----------> Unidade Requisitante (C.Custo).
SY3->( DBSETORDER( 1 ) )
SY3->( DBSEEK( xFilial()+SW3->W3_CC ) )

//-----------> Fornecedores.
SA2->( DBSETORDER( 1 ) )
SA2->( DBSEEK( xFilial()+SW3->W3_FABR ) )

//-----------> Reg. Ministerio.
SYG->( DBSETORDER( 1 ) )
SYG->( DBSEEK( xFilial()+SW2->W2_IMPORT+SW3->W3_FABR+SW3->W3_COD_I ) )

//-----------> Produtos (Itens) e Textos.
SB1->( DBSETORDER( 1 ) )
SB1->( DBSEEK( xFilial()+SW3->W3_COD_I ) )


If ExistBlock(cPointS)
   ExecBlock(cPointS,.f.,.f.)
Endif

cDescrItem := MSMM(IF( nIdioma==INGLES, SB1->B1_DESC_I, SB1->B1_DESC_P ),36)
STRTRAN(cDescrItem,CHR(13)+CHR(10), " ")

IF(lPoint1P,ExecBlock(cPoint1P,.F.,.F.,"2"),)

//-----------> Produtos X Fornecedor.
SA5->( DBSETORDER( 3 ) )
SA5->( DBSEEK( xFilial()+SW3->W3_COD_I+SW3->W3_FABR+SW3->W3_FORN ) )

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 5
PO150BateTraco()

Linha := Linha + 50
oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 5
PO150BateTraco()

nCont:=nCont+1
oSend( oPrn, "Say",  Linha,  65, STRZERO(nCont,3),aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
oSend( oPrn, "Say",  Linha, 370, TRANS(SW3->W3_QTDE,E_TrocaVP(nIdioma,cPictQtde)),aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
/*
   If !Empty(SA5->A5_UNID)
      oSend( oPrn, "Say",  Linha, 400, SA5->A5_UNID, aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
   Else
      oSend( oPrn, "Say",  Linha, 400, SB1->B1_UM,   aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
   Endif
*/                                               
//SO.:0022/02 OS.:0148/02
oSend( oPrn, "Say",  Linha, 400, BUSCA_UM(SW3->W3_COD_I+SW3->W3_FABR +SW3->W3_FORN,SW3->W3_CC+SW3->W3_SI_NUM),   aFontes:TIMES_NEW_ROMAN_08_NEGRITO )  

IF MLCOUNT(cDescrItem,nTam) == 1 .OR. lPoint1P
   oSend( oPrn, "Say",  Linha, 480, MEMOLINE( cDescrItem,nTam ,1 ),aFontes:COURIER_NEW_10_NEGRITO )
ELSE
// oSend( oPrn, "Say",  Linha, 480, AV_Justifica(MEMOLINE( cDescrItem,nTam ,1 )),aFontes:COURIER_NEW_10_NEGRITO )
   oSend( oPrn, "Say",  Linha, 480, MEMOLINE( cDescrItem,nTam ,1 ),aFontes:COURIER_NEW_10_NEGRITO )
ENDIF

oSend( oPrn, "Say",  Linha,1500, LEFT(SA2->A2_NREDUZ,10),aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
oSend( oPrn, "Say",  Linha,1740, TRANS(SW3->W3_PRECO,E_TrocaVP(nIdioma,'@E 999,999,999.99999')),aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
oSend( oPrn, "Say",  Linha,2100, TRANS(SW3->W3_QTDE*SW3->W3_PRECO,E_TrocaVP(nIdioma,cPict1Total )),aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
oSend( oPrn, "Say",  Linha,2130, DATA_MES(SW3->W3_DT_EMB),aFontes:TIMES_NEW_ROMAN_08_NEGRITO )

nTotal := nTotal + SW3->W3_QTDE*SW3->W3_PRECO
Linha  := Linha + 50

// Part. Number + Part. Number Opc. + Reg. Minis. - 1o. Linha Descr. ja batida.
n1 := ( MlCount( cDescrItem, nTam ) + 1 + 2 + 1 ) - 1
n2 := 0   //acd   MLCOUNT( SUBSTR(ALLTRIM(SY3->Y3_DESC),1,LEN(SY3->Y3_DESC)-12), 12 )
n1 := IF( n1 > n2, n1, n2 )

FOR i:=2 TO n1 + 1   // Soma um para bater o ultimo.

    lPulaLinha := .F.

    IF Linha >= 3000
       ENCERRA_PAGINA
       COMECA_PAGINA

       oFnt := aFontes:COURIER_20_NEGRITO
       pTipo := 5
       PO150BateTraco()

       Linha := Linha+50
    ENDIF

    IF !EMPTY( MEMOLINE( cDescrItem,nTam, i ) )
       IF MLCOUNT(cDescrItem,nTam) == i .OR. lPoint1P
          oSend( oPrn, "Say",  Linha, 480,MEMOLINE( cDescrItem,nTam,i ), aFontes:COURIER_NEW_10_NEGRITO )
       ELSE
//        oSend( oPrn, "Say",  Linha, 480,AV_Justifica( MEMOLINE( cDescrItem,nTam,i ) ), aFontes:COURIER_NEW_10_NEGRITO )
          oSend( oPrn, "Say",  Linha, 480,MEMOLINE( cDescrItem,nTam,i  ), aFontes:COURIER_NEW_10_NEGRITO )
       ENDIF
       lPulaLinha := .T.
    ENDIF

    IF EMPTY( MEMOLINE( cDescrItem,nTam, i ) )
       IF nNumero == 1
           If !Empty( SA5->A5_CODPRF )
              oSend( oPrn, "Say",  Linha, 480 , SA5->A5_CODPRF,  aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
              lPulaLinha := .T.
           Endif
           nNumero := nNumero+1

        ELSEIF nNumero == 2
           If !Empty( MEMOLINE(SA5->A5_PARTOPC,24,1) )
              oSend( oPrn, "Say",  Linha, 480 , MEMOLINE(SA5->A5_PARTOPC,24,1),  aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
              lPulaLinha := .T.
           Endif
           nNumero := nNumero+1

        ELSEIF nNumero == 3
           If !Empty( MEMOLINE(SA5->A5_PARTOPC,24,2) )
              oSend( oPrn, "Say",  Linha, 480 , MEMOLINE(SA5->A5_PARTOPC,24,2),  aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
              lPulaLinha := .T.
           Endif
           nNumero := nNumero+1

        ELSEIF nNumero == 4
           If !Empty( SYG->YG_REG_MIN )
              oSend( oPrn, "Say",  Linha, 480 , SYG->YG_REG_MIN,  aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
              lPulaLinha := .T.
           Endif
           nNumero := nNumero+1

        ENDIF
    ENDIF

    IF !EMPTY( RIGHT(SA2->A2_NREDUZ, 10 ) )  .AND.  i == 2
       oSend( oPrn, "Say",  Linha,1500, RIGHT(SA2->A2_NREDUZ,10), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
       lPulaLinha := .T.
    ENDIF

    oFnt := aFontes:COURIER_20_NEGRITO
    pTipo := 5
    PO150BateTraco()

    If lPulaLinha
       Linha := Linha+50
    Endif

NEXT


Return

*----------------------------*
Static FUNCTION PO150Remarks()
*----------------------------*
Local i
i := bWhile := bAcumula := nil
cRemarks:=""

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 5
PO150BateTraco()

Linha := Linha+50

If Linha >= 3000
   ENCERRA_PAGINA
   COMECA_PAGINA

   oFnt := aFontes:COURIER_20_NEGRITO
   pTipo := 2
   PO150BateTraco()
   Linha := Linha+50
Endif

oSend( oPrn, "Say",  Linha, 750, LITERAL_OBSERVACOES, aFontes:TIMES_NEW_ROMAN_08_UNDERLINE )

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 5
PO150BateTraco()

Linha := Linha+50

cRemarks := MSMM(SW2->W2_OBS,60)
STRTRAN(cRemarks,CHR(13)+CHR(10), " ")

FOR i:=1 TO MLCOUNT( cRemarks, 40 )

   IF Linha >= 3000
      ENCERRA_PAGINA
      COMECA_PAGINA

      oFnt := aFontes:COURIER_20_NEGRITO
      pTipo := 5
      PO150BateTraco()
      Linha := Linha+50

      oSend( oPrn, "Say",  Linha, 750, LITERAL_OBSERVACOES, aFontes:TIMES_NEW_ROMAN_08_UNDERLINE )

      oFnt := aFontes:COURIER_20_NEGRITO
      pTipo := 2
      PO150BateTraco()
      Linha := Linha+50
   ENDIF

   IF !EMPTY(MEMOLINE( cRemarks,40, i ))
      oSend( oPrn, "Say",  Linha, 700 , MEMOLINE( cRemarks,40, i ),  aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
   ENDIF

   oFnt := aFontes:COURIER_20_NEGRITO
   pTipo := 5
   PO150BateTraco()
   Linha := Linha+50
NEXT

RETURN NIL

*---------------------------*
Static FUNCTION PO150Totais()
*---------------------------*

oFnt  := aFontes:COURIER_20_NEGRITO
pTipo := 5
PO150BateTraco()
Linha := Linha+50

If Linha >= 3000
   ENCERRA_PAGINA
   COMECA_PAGINA

   oFnt  := aFontes:COURIER_20_NEGRITO
   pTipo := 6
   PO150BateTraco()
   Linha := Linha+50
Else
   oFnt  := aFontes:COURIER_20_NEGRITO
   pTipo := 6
   PO150BateTraco()
   TRACO_NORMAL
   Linha := Linha+50
Endif

oFnt  := aFontes:COURIER_20_NEGRITO
pTipo := 6
PO150BateTraco()

oSend( oPrn, "Say",  Linha, 1250 , STR0044                                   , aFontes:COURIER_08_NEGRITO ) //"TOTAL "
oSend( oPrn, "Say",  Linha,2100, TRANS(nTotal,E_TrocaVP(nIdioma,cPict2Total))  , aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )

Linha := Linha+50

If Linha >= 3000
   ENCERRA_PAGINA
   COMECA_PAGINA

   oFnt  := aFontes:COURIER_20_NEGRITO
   pTipo := 6
   PO150BateTraco()
   Linha := Linha+50
else
   oFnt  := aFontes:COURIER_20_NEGRITO
   pTipo := 6
   PO150BateTraco()
   TRACO_REDUZIDO
   Linha := Linha+50
Endif

oFnt  := aFontes:COURIER_20_NEGRITO
pTipo := 6
PO150BateTraco()

oSend( oPrn, "Say",  Linha, 1250 , LITERAL_INLAND_CHARGES , aFontes:COURIER_08_NEGRITO )
oSend( oPrn, "Say",  Linha,2100, TRANS(SW2->W2_INLAND,E_TrocaVP(nIdioma,'@E 999,999,999,999.99')), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
Linha := Linha + 50

If Linha >= 3000
   ENCERRA_PAGINA
   COMECA_PAGINA

   oFnt  := aFontes:COURIER_20_NEGRITO
   pTipo := 6
   PO150BateTraco()
   Linha := Linha+50

else
   oFnt  := aFontes:COURIER_20_NEGRITO
   pTipo := 6
   PO150BateTraco()
   TRACO_REDUZIDO
   Linha := Linha+50
Endif

oFnt  := aFontes:COURIER_20_NEGRITO
pTipo := 6
PO150BateTraco()

oSend( oPrn, "Say",  Linha, 1250 , LITERAL_PACKING_CHARGES , aFontes:COURIER_08_NEGRITO )
oSend( oPrn, "Say",  Linha,2100, TRANS(SW2->W2_PACKING,E_TrocaVP(nIdioma,'@E 999,999,999,999.99')), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
Linha := Linha+50

If Linha >= 3000
   ENCERRA_PAGINA
   COMECA_PAGINA

   oFnt  := aFontes:COURIER_20_NEGRITO
   pTipo := 6
   PO150BateTraco()
   Linha := Linha+50
else
   oFnt  := aFontes:COURIER_20_NEGRITO
   pTipo := 6
   PO150BateTraco()
   TRACO_REDUZIDO
   Linha := Linha+50
Endif

oFnt  := aFontes:COURIER_20_NEGRITO
pTipo := 6
PO150BateTraco()

oSend( oPrn, "Say",  Linha, 1250 , LITERAL_INTL_FREIGHT , aFontes:COURIER_08_NEGRITO )
oSend( oPrn, "Say",  Linha,2100, TRANS(SW2->W2_FRETEINT,E_TrocaVP(nIdioma,'@E 999,999,999,999.99')), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
Linha := Linha+50

If Linha >= 3000
   ENCERRA_PAGINA
   COMECA_PAGINA

   oFnt  := aFontes:COURIER_20_NEGRITO
   pTipo := 6
   PO150BateTraco()
   Linha := Linha+50
else
   oFnt  := aFontes:COURIER_20_NEGRITO
   pTipo := 6
   PO150BateTraco()
   TRACO_REDUZIDO
   Linha := Linha+50
Endif

oFnt  := aFontes:COURIER_20_NEGRITO
pTipo := 6
PO150BateTraco()
oSend( oPrn, "Say",  Linha, 1250 , LITERAL_DISCOUNT , aFontes:COURIER_08_NEGRITO )
oSend( oPrn, "Say",  Linha,2100, TRANS(SW2->W2_DESCONT,E_TrocaVP(nIdioma,'@E 999,999,999,999.99')), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
Linha := Linha+50

If Linha >=2730
   ENCERRA_PAGINA
   COMECA_PAGINA
   oFnt  := aFontes:COURIER_20_NEGRITO
   pTipo := 6
   PO150BateTraco()
   Linha := Linha+50
Else
   oFnt  := aFontes:COURIER_20_NEGRITO
   pTipo := 6
   PO150BateTraco()
   TRACO_REDUZIDO
   Linha := Linha+50
Endif

nTotalGeral := (nTotal+SW2->W2_INLAND+SW2->W2_PACKING+SW2->W2_FRETEINT)-SW2->W2_DESCONT

oFnt  := aFontes:COURIER_20_NEGRITO
pTipo := 6
PO150BateTraco()

oSend( oPrn, "Say",  Linha, 1250 , STR0044 + ALLTRIM( SW2->W2_INCOTER )         , aFontes:COURIER_08_NEGRITO ) //"TOTAL "
oSend( oPrn, "Say",  Linha, 1675 , SW2->W2_MOEDA,aFontes:COURIER_08_NEGRITO )
oSend( oPrn, "Say",  Linha,2100, TRANS(nTotalGeral,E_TrocaVP(nIdioma,cPict2Total)), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )

Linha := Linha+50

oSend( oPrn, "oFont", aFontes:COURIER_20_NEGRITO )
TRACO_NORMAL
Linha := Linha+200

RETURN NIL

*------------------------------*
Static FUNCTION PO150BateTraco()
*------------------------------*

xLinha := nil

If pTipo == 1      .OR.  pTipo == 2  .OR. pTipo == 7
   xLinha := 100

ElseIf pTipo == 3  .OR.  pTipo == 4
   xLinha := 20

ElseIf pTipo == 5  .OR.  pTipo == 6
   xLinha := 50

Endif


oSend(oPrn,"oFont",oFnt)

DO CASE

   CASE pTipo == 1  .OR.  pTipo == 3
        oPrn:Box( Linha,  50, (Linha+xLinha),  51)
        oPrn:Box( Linha,2300, (Linha+xLinha),2301)

   CASE pTipo == 2  .OR.  pTipo == 4  .OR.  pTipo == 5
        oPrn:Box( Linha,  50, (Linha+xLinha),  51)
        oPrn:Box( Linha, 120, (Linha+xLinha), 121)
        oPrn:Box( Linha, 460, (Linha+xLinha), 461)
        oPrn:Box( Linha,1510, (Linha+xLinha),1511)        
        oPrn:Box( Linha,1750, (Linha+xLinha),1751)
        oPrn:Box( Linha,2110, (Linha+xLinha),2111)
        oPrn:Box( Linha,2300, (Linha+xLinha),2301)

   CASE pTipo == 6  .OR.  pTipo == 7
        oPrn:Box( Linha,  50, (Linha+xLinha),  51)
        oPrn:Box( Linha,1200, (Linha+xLinha),1201)
        oPrn:Box( Linha,2300, (Linha+xLinha),2301)


ENDC

RETURN NIL


