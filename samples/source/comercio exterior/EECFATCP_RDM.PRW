/*
Programa        : EECFATCP
Objetivo        : Nota Fiscal Despesa/Nota Complemento Embarque
Autor           : Cristiano A. Ferreira `
Data/Hora       : 23/06/2000 14:50
Obs.            :
 Define Array contendo as Rotinas a executar do programa  
 ----------- Elementos contidos por dimensao ------------ 
 1. Nome a aparecer no cabecalho                          
 2. Nome da Rotina associada                              
 3. Usado pela rotina                                     
 4. Tipo de Transacao a ser efetuada                      
    1 - Pesquisa e Posiciona em um Banco de Dados         
    2 - Simplesmente Mostra os Campos                     
    3 - Inclui registros no Bancos de Dados               
    4 - Altera o registro corrente                        
    5 - Remove o registro corrente do Banco de Dados      
    6 - Altera determinados campos sem incluir novos Regs 
*/
*--------------------------------------------------------------------
#INCLUDE "EECFATCP.ch"
#include "EECRDM.CH"
#define TITULO STR0001 //"Solicitação de N.F. Complementar"
*--------------------------------------------------------------------
USER FUNCTION EECFATCP
LOCAL aCORES  := {{"EMPTY(EEC_DTEMBA)  .OR.  EEC_STATUS =  '"+ST_PC+"'","DISABLE" },;  //PROCESSO NAO EMBARCADO OU CANCELADO
                  {"!EMPTY(EEC_DTEMBA) .AND. EEC_STATUS <> '"+ST_PC+"'","ENABLE"}}     //PROCESSO EMBARCADO
PRIVATE cCADASTRO := STR0030,; //"Nota Fiscal Complementar"
          aROTINA := {{STR0031        ,"AxPesqui"   ,0, 1},; //"Pesquisar"
                      {"NFC &Despesas","U_FATCPNFC", 0, 2},;
                      {"NFC Embarque" ,"U_FATCPNFC", 0, 2},;
                      {STR0019        ,"U_FATCPLEG", 0, 2}} //"Legenda"
DBSELECTAREA("EEC")
EEC->(DBSETORDER(1))
MBROWSE(6,01,22,75,"EEC",,,,,,aCORES)
RETURN(NIL)
*--------------------------------------------------------------------
USER FUNCTION FATCPNFC(cP_ALIAS,nP_REG,nP_OPC)
LOCAL oDLG,oBTNOK,oBTNCANCEL,I,;
      aORDANT := SaveOrd({"EE9","SA1","SA2","EEM","EE7","SD2"}),;
      cTITULO := cCADASTRO+IF(nP_OPC=3," - Embarque",STR0032),; //" - Despesas"
      bOK     := {||nOpc:=1,oDlg:End()},;
      bCANCEL := {||nOpc:=0,oDlg:End()},;
      nOPC    := 0
PRIVATE aCab,aReg,aItens,;
        lEstEmb     := .f., lEstDes  := .f., lEstorna := .f.,;
        cTIPOOPC    := STR(nP_OPC-1,1,0),;
        INCLUI      := .T.,;
        lMSErroAuto := .F.,;
        lMSHelpAuto := .F.,;  // para mostrar os erros na tela
        cPedFat     := "",;
        cMSGCONF    := ""
*
BEGIN SEQUENCE
   EEC->(RECLOCK("EEC",.F.))
   FOR I := 1 TO EEC->(FCOUNT())
       M->&(EEC->(FIELDNAME(I))) := EEC->(FIELDGET(I))
   NEXT   
   IF EMPTY(M->EEC_DTEMBA) .OR. M->EEC_STATUS = ST_PC
      MSGINFO(STR0033,STR0034) //"Processo não foi embarcado ou está cancelado."###"Atenção"
      BREAK
   ELSEIF FATCVLDESP() = 0 .AND. nP_OPC # 3  //3.CAMBIO
          MSGINFO(STR0035,STR0034) //"Processo não possui despesas."###"Atenção"
          BREAK
   ELSEIF FATCVLDESP() < 0 .AND. nP_OPC = 2  //2.DESPESA
          MSGINFO(STR0036,STR0009) //"Processo com variação de despesas negativa."###"Aviso"
          BREAK
   ENDIF
   EE9->(dbSetOrder(2))
   SA1->(dbSetOrder(1))
   SA2->(dbSetOrder(1))
   EEM->(dbSetOrder(1))
   EE7->(dbSetOrder(1))
   LOADGETS()
   DEFINE MSDIALOG oDLG TITLE cTITULO FROM 0,0 TO 255,240 OF oMainWnd PIXEL
      @ 05,02 TO 100,110 PIXEL
      *    
      @ 15,05 SAY AVSX3("EEC_PREEMB",AV_TITULO) PIXEL
      @ 15,50 MSGET EEC->EEC_PREEMB PICTURE AVSX3("EEC_PREEMB",AV_PICTURE) WHEN(.F.) SIZE 53,08 PIXEL
      *
      @ 26,05 SAY AVSX3("EEC_DTEMBA",AV_TITULO) PIXEL
      @ 26,50 MSGET EEC->EEC_DTEMBA PICTURE AVSX3("EEC_DTEMBA",AV_PICTURE) WHEN(.F.) SIZE 30,08 PIXEL
      *
      @ 37,05 SAY AVSX3("EEC_SEGPRE",AV_TITULO) PIXEL
      @ 37,50 MSGET EEC->EEC_SEGPRE PICTURE AVSX3("EEC_SEGPRE",AV_PICTURE) WHEN(.F.) SIZE 50,08 PIXEL
      *
      @ 48,05 SAY AVSX3("EEC_FRPREV",AV_TITULO) PIXEL
      @ 48,50 MSGET EEC->EEC_FRPREV PICTURE AVSX3("EEC_FRPREV",AV_PICTURE) WHEN(.F.) SIZE 50,08 PIXEL
      *
      @ 59,05 SAY AVSX3("EEC_FRPCOM",AV_TITULO) PIXEL
      @ 59,50 MSGET EEC->EEC_FRPCOM PICTURE AVSX3("EEC_FRPCOM",AV_PICTURE) WHEN(.F.) SIZE 50,08 PIXEL
      *
      @ 70,05 SAY AVSX3("EEC_DESPIN",AV_TITULO) PIXEL
      @ 70,50 MSGET EEC->EEC_DESPIN PICTURE AVSX3("EEC_DESPIN",AV_PICTURE) WHEN(.F.) SIZE 50,08 PIXEL
      *
      @ 81,05 SAY AVSX3("EEC_DESCON",AV_TITULO) PIXEL
      @ 81,50 MSGET EEC->EEC_DESCON PICTURE AVSX3("EEC_DESCON",AV_PICTURE) WHEN(.F.) SIZE 50,08 PIXEL
      *
      @ 103,05 SAY cMSGCONF PIXEL
      DEFINE SBUTTON oBtnOk     FROM 113,040 TYPE 1 ACTION Eval(bOk)     ENABLE OF oDlg
      DEFINE SBUTTON oBtnCancel FROM 113,080 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlg
      *
   ACTIVATE MSDIALOG oDlg CENTERED
   IF nOPC = 0
      BREAK
   ENDIF
   // processamento principal
   Begin Transaction
      if Left(cTipoOpc,1) == "1"
         lEstorna := lEstDes
         IF lEstorna
            cPedFat := EEC->EEC_PEDDES
         Endif
         bAction := {|| lRet := GrvNF_Desp() }
         cTitle  := STR0002 //"N.Fiscal Despesa"
      elseif Left(cTipoOpc,1) == "2"
             lEstorna := lEstEmb
             IF lEstorna
                cPedFat := EEC->EEC_PEDEMB
             Endif
             bAction := {|| lRet := GrvComplEmbarq() }
             cTitle  := STR0003 //"N.F. Compl. Cambial"
      endif
      IF lEstorna
         SD2->(dbSetOrder(8))
         IF SD2->(dbSeek(xFilial()+cPedFat))
            aDados := {}
            aAdd(aDados,{"EEM_TIPOCA","N"            ,nil}) // Nota Fiscal (obrigatorio)
            aAdd(aDados,{"EEM_PREEMB",EEC->EEC_PREEMB,nil}) // Nro.do Embarque (obrigatorio)
            aAdd(aDados,{"EEM_TIPONF","2"            ,nil}) // Tipo de Nota 2-Complementar (obrigatorio)
            aAdd(aDados,{"EEM_NRNF"  ,SD2->D2_DOC    ,nil}) // (obrigatorio)
            aAdd(aDados,{"EEM_SERIE" ,SD2->D2_SERIE  ,nil})
            ExecBlock("EECFATNF",.F.,.F.,{aDados,5})
            aCab := {}
            aAdd(aCab,{"F2_DOC"  ,SD2->D2_DOC  ,nil})
            aAdd(aCab,{"F2_SERIE",SD2->D2_SERIE,nil})
            Mata520(aCab)
         Endif
      Endif
      MsAguarde(bAction,cTitle)
      IF ! lMSErroAuto .AND. ! lEstorna
         cSerieNF := GetMv("MV_EECSERI")
         // by CAF 06/03/2003 IncNota(SC5->C5_NUM,cSerieNF,EEC->EEC_PREEMB)
         IncNota(aCAB[1,2],cSerieNF,EEC->EEC_PREEMB)         
         // LCS - 20/09/2002 - SEEK NO SD2 E SF2
         SD2->(DBSETORDER(8))
         SD2->(DBSEEK(XFILIAL("SD2")+AVKEY(cPEDFAT,"D2_PEDIDO")))
         SF2->(DBSETORDER(1))
         SF2->(DBSEEK(XFILIAL("SF2")+AVKEY(SD2->D2_DOC,"F2_DOC")+AVKEY(SD2->D2_SERIE,"F2_SERIE")))
         aDados := {}
         aAdd(aDados,{"EEM_TIPOCA","N"            ,nil}) // Nota Fiscal (obrigatorio)
         aAdd(aDados,{"EEM_PREEMB",EEC->EEC_PREEMB,nil}) // Nro.do Embarque (obrigatorio)
         aAdd(aDados,{"EEM_TIPONF","2"            ,nil}) // Tipo de Nota 2-Complementar (obrigatorio)
         aAdd(aDados,{"EEM_NRNF"  ,SF2->F2_DOC    ,nil}) // (obrigatorio)
         aAdd(aDados,{"EEM_SERIE" ,SF2->F2_SERIE  ,nil})
         aAdd(aDados,{"EEM_DTNF"  ,SF2->F2_EMISSAO,nil})
         aAdd(aDados,{"EEM_VLNF"  ,SF2->F2_VALBRUT,nil}) // (obrigatorio)
         aAdd(aDados,{"EEM_VLMERC",SF2->F2_VALMERC,nil}) // (obrigatorio)
         aAdd(aDados,{"EEM_VLFRET",SF2->F2_FRETE  ,nil})
         aAdd(aDados,{"EEM_VLSEGU",SF2->F2_SEGURO ,nil})
         aAdd(aDados,{"EEM_OUTROS",SF2->F2_DESPESA,nil})
         ExecBlock("EECFATNF",.F.,.F.,{aDados,3})
         MsgInfo(STR0008+SF2->F2_DOC,STR0009) //"Número da Nota Fiscal de Complemento de Preço: "###"Aviso"
      Endif
   End Transaction
End Sequence
RestOrd(aORDANT)
DBSELECTAREA("EEC")
RETURN(NIL)
*--------------------------------------------------------------------
USER FUNCTION FATCPLEG(cP_ALIAS,nP_REG,nP_OPC)
BRWLEGENDA(cCADASTRO,STR0019,{{"ENABLE" ,STR0020},; //"Legenda"###"Processos embarcados"
                                {"DISABLE",STR0021}}) //"Processos não embarcados"
RETURN(NIL)
*--------------------------------------------------------------------
Static Function LoadGets()
Local lRet := .t.,WVLDES := 0
WVLDES := FATCVLDESP()
*** CONFIGURA BOTAO DA NFC CAMBIO ***
IF cTIPOOPC = "2"
   IF ! Empty(M->EEC_PEDEMB)
      cMSGCONF := STR0022 //"Confirma o estorno da NFC Cambial ?"
      lEstEmb  := .t.
   Else
      cMSGCONF := STR0023 //"Confirma a geração da NFC Cambial ?"
      lEstEmb  := .f.
   Endif
ENDIF
*** CONFIGURA BOTAO DA NFC DESPESAS ***
IF cTIPOOPC = "1"
   IF EMPTY(M->EEC_PEDDES)
      cMSGCONF := STR0024 //"Confirma a geração da NFC de despesas ?"
      lEstDes  := .F.      
   ELSE
      cMSGCONF := STR0025 //"Confirma o estorno da NFC de despesas ?"
      lEstDes  := .T.
   ENDIF
ENDIF
Return(lRet)
*--------------------------------------------------------------------
/*
Funcao      : GrvNF_Desp
Parametros  : Nenhum
Retorno     : NIL
Objetivos   : Gravacao da Nota Fiscal de Despesa
Autor       : Cristiano A. Ferreira
Data/Hora   : 03/03/2000 10:20
Revisao     :
Obs.        :
*/
Static Function GrvNF_Desp
Local nDespTot := FATCVLDESP(),;
      nTotal   := nDesp := 0,;
      cItem, cCondPag, nLen, nPosRec, nPosTot

Local aOrd := SaveOrd({"EE8"})

MsProcTxt(STR0016) //"Em Processamento ..."
// aCab por dimensao:
// aCab[n][1] := Nome do Campo
// aCab[n][2] := Valor a ser gravado no campo
// aCab[n][3] := Regra de Validacao, se NIL considera do dicionario
aCab   := {}
aItens := {}
aReg   := {}
Begin Sequence
   IF nDespTot <= 0
      HELP(" ",1,"AVG0005027") //MsgInfo("Não há despesas cadastradas !","Aviso")
      Break
   Endif
   SD2->(dbSetOrder(8))
   IF ! lEstorna
      aAdd(aCab,{"C5_NUM",GetSXENum("SC5"),nil}) // Nro.do Pedido
   Else
      IF SD2->(dbSeek(xFilial()+AvKey(EEC->EEC_PEDDES,"D2_PEDIDO")))
         MsgInfo(STR0017+Transf(EEC->EEC_PEDDES,AVSX3("C6_NUM",6))+STR0018,STR0009) //"Pedido Nro. "###" já Faturado !"###"Aviso"
         Break
      Endif
      aAdd(aCab,{"C5_NUM",EEC->EEC_PEDDES,nil})
   Endif
   aAdd(aCab,{"C5_PEDEXP",EEC->EEC_PREEMB,nil}) // Nro.Embarque
   aAdd(aCab,{"C5_TIPO","C",nil}) //Tipo de Pedido - "C"-Compl.Preco
   IF !Empty(EEC->EEC_CLIENT)
      IF ! SA1->(dbSeek(xFilial()+EEC->EEC_CLIENT+EEC->EEC_CLLOJA))
         HELP(" ",1,"AVG0005022") //MsgInfo("Cliente não cadastrado !","Aviso")
         Break
      Endif
   ElseIF ! SA1->(dbSeek(xFilial()+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))
          HELP(" ",1,"AVG0005023") //MsgInfo("Importador não cadastrado !","Aviso")
          Break
   Endif
   aAdd(aCab,{"C5_CLIENTE",SA1->A1_COD,nil})  //Cod. Cliente
   aAdd(aCab,{"C5_LOJACLI",SA1->A1_LOJA,nil}) //Loja Cliente
   aAdd(aCab,{"C5_TIPOCLI","X",nil}) //Tipo Cliente
   cCondPag := Posicione("SY6",1,xFilial("SY6")+EEC->EEC_CONDPA+AvKey(EEC->EEC_DIASPA,"Y6_DIAS_PA"),"Y6_SIGSE4")
   IF Empty(cCondPag)
      HELP(" ",1,"AVG0005028") //MsgInfo("O campo Cond.Pagto no SIGAFAT não foi preenchido !","Aviso")
      Break
   Endif
   aAdd(aCab,{"C5_CONDPAG",cCondPag,nil})
   ///aAdd(aCab,{"C5_TABELA","1",nil}) // Tabela de preco - Tabela 1
   aAdd(aCab,{"C5_MOEDA",POSICIONE("SYF",1,XFILIAL("SYF")+EEC->EEC_MOEDA,"YF_MOEFAT"),nil}) 
   aItens := {}
   cItem  := "01"
   //efetuar rateio da despesa total
   EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))
   DO While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And.;
      EE9->EE9_PREEMB == EEC->EEC_PREEMB
      *
      nTotal := nTotal+(EE9->EE9_SLDINI*EE9->EE9_PRECO)
      EE9->(dbSkip())    
   Enddo
   EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))
   DO While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And.;
      EE9->EE9_PREEMB == EEC->EEC_PREEMB
      *
      nFator   := (EE9->EE9_SLDINI*EE9->EE9_PRECO)/nTotal // CALCULA PERCENTUAL DO PRODUTO EM RELACAO A DESPESA
      nValorIt := nFator*nDespTot                         // CALCULA O VALOR EM DOLAR DO PRODUTO
      nDesp    := nDesp+nValorIt                          // TOTAL DAS DESPESAS EM DOLAR
      If ( GetMV("MV_ARREFAT")=="S" )      
         nVALORIT := ROUND(nVALORIT,AVSX3("C6_VALOR",AV_DECIMAL))
      Else
         nVALORIT := NOROUND(nVALORIT,AVSX3("C6_VALOR",AV_DECIMAL))
      EndIf       
      IF SB1->(dbSeek(xFilial()+EE9->EE9_COD_I)) .AND. ! SB2->(dbSeek(xFilial()+SB1->B1_COD+SB1->B1_LOCPAD))
         CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD)
      Endif
      aReg := {}
      aAdd(aReg,{"C6_NUM"    ,aCab[1][2],nil}) // Pedido
      aAdd(aReg,{"C6_ITEM"   ,cItem,nil}) // Item sequencial
      aAdd(aReg,{"C6_PRODUTO",EE9->EE9_COD_I ,nil}) // Cod.Item
      aAdd(aReg,{"C6_UM"     ,EE9->EE9_UNIDAD,nil}) // Unidade
      aAdd(aReg,{"C6_QTDVEN" ,1              ,nil}) // Quantidade
      aAdd(aReg,{"C6_PRCVEN" ,nValorIt       ,nil}) // Preco Unit.
      aAdd(aReg,{"C6_PRUNIT" ,nValorIt       ,nil}) // Preco Unit.
      aAdd(aReg,{"C6_VALOR"  ,nValorIt       ,nil}) // Valor Tot.

      // ** JBJ 08/10/01 - Gravação dos campos Tipo de Saida e Codigo Fiscal ... (Inicio)
      
      EE8->(DbSetOrder(1))      
      EE8->(Dbseek(xFilial()+EE9->EE9_PEDIDO+EE9->EE9_SEQUEN))      
      aAdd(aReg,{"C6_TES" ,EE8->EE8_TES ,Nil})  // Tipo de Saida ...      
      aAdd(aReg,{"C6_CF"  ,EE8->EE8_CF  ,Nil})  // Codigo Fiscal ...                  
      // aAdd(aReg,{"C6_TES"    ,"501"          ,nil}) // Tipo de Saida
      // aAdd(aReg,{"C6_CF"     ,"663"          ,nil})  // Classificacao Fiscal
      // ** (Fim) 
 
      aAdd(aReg,{"C6_LOCAL"  ,SB1->B1_LOCPAD ,nil})  // Almoxarifado
      aAdd(aReg,{"C6_ENTREG" ,dDataBase      ,nil})  // Dt.Entrega
      
 
      aAdd(aItens,aClone(aReg))
         
      cItem := SomaIt(cItem)
      
      IF cItem > "Z9"
         HELP(" ",1,"AVG0005026") //MsgStop("Excedeu o limite de itens do SIGAFAT !")
         Exit
      Endif
      
      EE9->(dbSkip())    
   Enddo
   
   IF nDesp <> nDespTot
      IF !Empty(aItens)
         nLen    := Len(aItens)
         nPosPrc := aScan(aItens[nLen],{|x| x[1] == "C6_PRCVEN"})
         nPosTot := aScan(aItens[nLen],{|x| x[1] == "C6_VALOR"})
         nPOSPRU := aScan(aItens[nLen],{|x| x[1] == "C6_PRUNIT"})
         
         aItens[nLen][nPosPrc][2] := aItens[nLen][nPosPrc][2]+(nDespTot-nDesp)
         aItens[nLen][nPosTot][2] := aItens[nLen][nPosPrc][2]
         aItens[nLen][nPosPrU][2] := aItens[nLen][nPosPrU][2]+(nDespTot-nDesp)
      Endif
   Endif
   
   lMSErroAuto := .f.
   lMSHelpAuto := .F. // para mostrar os erros na tela

   ASORT(aItens,,, { |x, y| x[2,2] < y[2,2] })

   IF lEstorna
      Estorna_PV(EEC->EEC_PEDDES,aCab,aItens)
      MsgInfo(STR0037,STR0029)  //"Nota Fiscal Complementar de Despesa estornada !"###"Aviso !" // ** BY JBJ - 06/09/01 - 16:40
   Else
      //MSExecAuto({|x,y,z|Mata410(x,y,z)},aCab,aItens,3)
      AVMata410(aCab, aItens, 3)
   Endif

   IF !lMSErroAuto 
      IF !lEstorna
         EEC->(RecLock("EEC",.F.))
         EEC->EEC_PEDDES := aCAB[1,2]  // PEDIDO NO FAT
         // LCS - 20/09/2002 - SUBSTITUIDO PELA LINHA ACIMA
         //EEC->EEC_PEDDES := SC5->C5_NUM
         EEC->(MsUnlock())
      Else
         EEC->(RecLock("EEC",.F.))
         EEC->EEC_PEDDES := " "
         EEC->(MsUnlock())
      Endif
   Endif
   
   IF !lEstorna
      cPedFat := EEC->EEC_PEDDES
   Endif
   
End Sequence

RestOrd(aOrd)

Return(NIL)
*--------------------------------------------------------------------
/*
Funcao      : GrvComplEmbarq
Parametros  : Nenhum
Retorno     : NIL
Objetivos   : Gravacao do Complemento de Embarque
Autor       : Cristiano A. Ferreira
Data/Hora   : 03/03/2000 10:23
*/
Static Function GrvComplEmbarq
Local nTxEmb := BuscaTaxa(EEC->EEC_MOEDA,M->EEC_DTEMBA),;
      cCondPag, nTaxaNF, nValorIT, cItem,;
      nTxDesp := nTotDesp := nTotal := 0,;
      lTEVEVAR := .F.

Local aOrd := SaveOrd({"EE8"})

MsProcTxt(STR0016) //"Em Processamento ..."
// aCab por dimensao:
// aCab[n][1] := Nome do Campo
// aCab[n][2] := Valor a ser gravado no campo
// aCab[n][3] := Regra de Validacao, se NIL considera do dicionario
aCab   := {}
aItens := {}
aReg   := {}
Begin Sequence
      SD2->(dbSetOrder(8))
      IF ! lEstorna
         aAdd(aCab,{"C5_NUM",GetSXENum("SC5"),nil}) // Nro.do Pedido
      ELSEIF SD2->(dbSeek(xFilial()+AvKey(EEC->EEC_PEDEMB,"D2_PEDIDO")))
             MsgInfo(STR0017+Transf(EEC->EEC_PEDEMB,AVSX3("C6_NUM",6))+STR0018,STR0009) //"Pedido Nro. "###" já Faturado !"###"Aviso"
             Break
      ELSE
         AAdd(aCab,{"C5_NUM",EEC->EEC_PEDEMB,nil})
      Endif
      aAdd(aCab,{"C5_PEDEXP",EEC->EEC_PREEMB,nil})  // Nro.Embarque
      aAdd(aCab,{"C5_TIPO"  ,"C"            ,nil})  //Tipo de Pedido - "C"-Compl.Preco
      IF !Empty(EEC->EEC_CLIENT)
         IF ! SA1->(dbSeek(xFilial()+EEC->EEC_CLIENT+EEC->EEC_CLLOJA))
            HELP(" ",1,"AVG0005022") //MsgInfo("Cliente não cadastrado !","Aviso")
            Break
         Endif
      ElseIF ! SA1->(dbSeek(xFilial()+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))
             HELP(" ",1,"AVG0005023") //MsgInfo("Importador não cadastrado !","Aviso")
             Break
      Endif
      aAdd(aCab,{"C5_CLIENTE",SA1->A1_COD, nil}) //Cod. Cliente
      aAdd(aCab,{"C5_LOJACLI",SA1->A1_LOJA,nil}) //Loja Cliente
      aAdd(aCab,{"C5_TIPOCLI","X"         ,nil}) //Tipo Cliente
      cCondPag := Posicione("SY6",1,xFilial("SY6")+EEC->EEC_CONDPA+AvKey(EEC->EEC_DIASPA,"Y6_DIAS_PA"),"Y6_SIGSE4")
      IF Empty(cCondPag)
         HELP(" ",1,"AVG0005028") //MsgInfo("O campo Cond.Pagto no SIGAFAT não foi preenchido !","Aviso")
         BREAK
      Endif
      aAdd(aCab,{"C5_CONDPAG",cCondPag,nil})
      ///aAdd(aCab,{"C5_TABELA" ,"1"     ,nil}) // Tabela de preco - Tabela 1
      aItens := {}
      cItem := "01"
      lMSErroAuto := .f.
      lMSHelpAuto := .F. // para mostrar os erros na tela
      EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))
      DO While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And. EE9->EE9_PREEMB == EEC->EEC_PREEMB
         SD2->(dbSetOrder(3))
         SD2->(dbSeek(xFilial()+AvKey(EE9->EE9_NF,"D2_DOC")+AvKey(EE9->EE9_SERIE,"D2_SERIE")))
         nTaxaNF := BuscaTaxa(EEC->EEC_MOEDA,SD2->D2_EMISSAO)
         IF !lEstorna .And. (nTxEmb-nTaxaNF) <= 0  
            EE9->(dbSkip())    
            Loop
         Endif
         lTEVEVAR := .T.
         NVALORIT := EE9->(EE9_SLDINI*EE9_PRECO)                              // VALOR FOB DO ITEM
         NVALORIT := (NVALORIT*NTXEMB)-(NVALORIT*NTAXANF)  // VALOR DA DIF. POR ITEM
         If ( GetMV("MV_ARREFAT")=="S" )      
            nVALORIT := ROUND(nVALORIT,AVSX3("C6_VALOR",AV_DECIMAL))
         Else
            nVALORIT := NOROUND(nVALORIT,AVSX3("C6_VALOR",AV_DECIMAL))
         EndIf       
         IF SB1->(dbSeek(xFilial()+EE9->EE9_COD_I)) .AND. ! SB2->(dbSeek(xFilial()+SB1->B1_COD+SB1->B1_LOCPAD))
            CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD)
         Endif
         aReg := {}
         aAdd(aReg,{"C6_NUM"    ,aCab[1][2]     ,NIL}) // Pedido
         aAdd(aReg,{"C6_ITEM"   ,cItem          ,NIL}) // Item sequencial
         aAdd(aReg,{"C6_PRODUTO",EE9->EE9_COD_I ,nil})    // Cod.Item
         aAdd(aReg,{"C6_UM"     ,EE9->EE9_UNIDAD,nil})    // Unidade
         aAdd(aReg,{"C6_QTDVEN" ,1,nil})                  // Quantidade
         aAdd(aReg,{"C6_PRCVEN" ,nValorIt       ,nil})    // Preco Unit.
         aAdd(aReg,{"C6_PRUNIT" ,nValorIt       ,nil})    // Preco Unit.
         aAdd(aReg,{"C6_VALOR"  ,nValorIt       ,nil})    // Valor Tot.

         // ** JBJ 08/10/01 - Gravação dos campos Tipo de Saida e Codigo Fiscal ... (Inicio)
         EE8->(DbSetOrder(1))
         EE8->(Dbseek(xFilial()+EE9->EE9_PEDIDO+EE9->EE9_SEQUEN))      
         aAdd(aReg,{"C6_TES" ,EE8->EE8_TES ,Nil})  // Tipo de Saida ...      
         aAdd(aReg,{"C6_CF"  ,EE8->EE8_CF  ,Nil})  // Codigo Fiscal ...                  
         // aAdd(aReg,{"C6_TES"    ,"501"          ,nil})    // Tipo de Saida
         // aAdd(aReg,{"C6_CF"     ,"663"          ,nil})    // Classificacao Fiscal
         // ** (Fim) 

         aAdd(aReg,{"C6_LOCAL"  ,SB1->B1_LOCPAD ,nil})    // Almoxarifado
         aAdd(aReg,{"C6_ENTREG" ,dDataBase      ,nil})    // Dt.Entrega
        
         aAdd(aItens,aClone(aReg))
         cItem := SomaIt(cItem)
         IF cItem > "Z9"
            HELP(" ",1,"AVG0005026") //MsgStop("Excedeu o limite de itens do SIGAFAT !")
            lMSErroAuto := .T.
            Exit
         Endif
         EE9->(dbSkip())
      Enddo
      
      // ** JBJ - 06/09/01 - 15:56      
      If ! lTEVEVAR .And. (nTxEmb-nTaxaNF) < 0 
          MsgInfo(STR0026+ENTER+STR0027,STR0009)  //"Variação Cambial negativa !"###"Nota Fiscal Complementar não pode ser gerada!"###"Aviso"
          lMSErroAuto := .T.                                                                                 
          Break
      EndIf
      // ** 
      
      IF ! lTEVEVAR
         HELP(" ",1,"AVG0005029") //MsgInfo("Não Houve Diferença Cambial !","Aviso")
         lMSErroAuto := .T.
      ELSEIF Empty(aItens)
             lMSErroAuto := .T.
      Endif
      
      ASORT(aItens,,, { |x, y| x[2,2] < y[2,2] })

      IF lMSErroAuto
         Break
      ELSEIF lEstorna
             Estorna_PV(EEC->EEC_PEDEMB,aCab,aItens)
             MsgInfo (STR0028,STR0029)    //"Nota Fiscal Estornada !"###"Aviso !"  // BY JBJ 06/09/01 - 16:04
      Else
         //MSExecAuto({|x,y,z|Mata410(x,y,z)},aCab,aItens,3)
         AVMata410(aCab, aItens, 3)
      Endif
      IF !lMSErroAuto 
         EEC->(RecLock("EEC",.F.))
         EEC->EEC_PEDEMB := IF(!LESTORNA,aCAB[1,2]," ")
         // LCS - 20/09/2002 -SUBSTITUIDO PELA LINHA ACIMA
         //EEC->EEC_PEDEMB := IF(!LESTORNA,SC5->C5_NUM," ")
         EEC->(MsUnlock())
      Endif
      IF ! lEstorna
         cPedFat := EEC->EEC_PEDEMB
      Endif
End Sequence

RestOrd(aOrd)

Return(NIL)
*--------------------------------------------------------------------
STATIC FUNCTION FATCVLDESP
RETURN(EEC->((EEC_FRPREV+EEC_FRPCOM+EEC_SEGPRE+EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"))-EEC_DESCON))
*--------------------------------------------------------------------
