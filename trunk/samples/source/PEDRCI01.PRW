/*
    Programa : PEDRCI01.PRW
    Autor    : Heder M Oliveira    
    Data     : 15/09/99
    Revisao  : 15/09/99
    Uso      : Impressao de Pedido Recebido no AVGLTT.RPT
*/
/*
considera que estah posicionado no registro de processo de
embarque (EE7)
*/

#DEFINE ENTER CHR(13)+CHR(10)
#DEFINE INSERE_LINHA CHR(13)+CHR(10)

//armazena situacao atual
nRECNO:=EE7->(RECNO())


//processamento principal

   //inicializa retorno
   lRETr:=.F.

   //regras para carregar dados
   IF !EMPTY(EE7->EE7_EXPORT) .AND. ;
       SA2->(DBSEEK(xFilial("SA2")+EE7->EE7_EXPORT+EE7->EE7_EXLOJA))
      cEXP_NOME    :=Posicione("SA2",1,xFilial("SA2")+EE7->EE7_EXPORT+EE7->EE7_EXLOJA,"A2_NOME")
      cEXP_CONTATO :=EECCONTATO("X",EE7->EE7_EXPORT+EE7->EE7_EXLOJA,"1",1)  //nome do contato seq 1
      cEXP_FONE    :=EECCONTATO("X",EE7->EE7_EXPORT+EE7->EE7_EXLOJA,"1",4)  //fone do contato seq 1
      cEXP_FAX     :=EECCONTATO("X",EE7->EE7_EXPORT+EE7->EE7_EXLOJA,"1",7)  //fax do contato seq 1
   ELSE
      SA2->(DBSEEK(xFilial("SA2")+EE7->EE7_FORN+EE7->EE7_FOLOJA))
      cEXP_NOME    := SA2->A2_NOME
      cEXP_CONTATO :=EECCONTATO("X",EE7->EE7_FORN+EE7->EE7_FOLOJA,"1",1)  //nome do contato seq 1
      cEXP_FONE    :=EECCONTATO("X",EE7->EE7_FORN+EE7->EE7_FOLOJA,"1",4)  //fone do contato seq 1
      cEXP_FAX     :=EECCONTATO("X",EE7->EE7_FORN+EE7->EE7_FOLOJA,"1",7)  //fax do contato seq 1
   ENDIF

   //TO
   cPEDIDO:=AVKey(EE7->EE7_PEDIDO,"EEB_PEDIDO")
   cTO_NOME:=""
   cTO_ATTN:=""
   cTO_FAX:=""
   //tentar 1. o agente recebedor documentos
   IF EEB->(dbSeek(xFilial("EEB")+"P"+cPEDIDO))
      nRECEEB:=EEB->(RECNO())
      While EEB->(!Eof() .And. EEB_FILIAL == xFilial("EEB") .AND.;
                   EEB_PEDIDO==cPEDIDO)
         SysRefresh()
         IF EEB->EEB_TIPOAG == "2" // Agente Recebedor Documentos
            cTO_NOME:=EEB->EEB_NOME
            cTO_ATTN:=EECCONTATO("E",EEB->EEB_CODAGE,"1",1) //nome do contato seq 1
            cTO_FAX :=EECCONTATO("E",EEB->EEB_CODAGE,"1",7) //fax do contato seq 1
         Endif
         EEB->(dbSkip())
      Enddo
      //se 1 falhou, 2 tentar agente comissao
      IF EMPTY(cTO_NOME)
         EEB->(DBGOTO(nRECEEB))
         While EEB->(!Eof() .And. EEB_FILIAL == xFilial("EEB") .AND.;
                      EEB_PEDIDO==cPEDIDO)
            SysRefresh()
            IF EEB->EEB_TIPOAG == "3" // Agente Comissao
               cTO_NOME:=EEB->EEB_NOME
               cTO_ATTN:=EECCONTATO("E",EEB->EEB_CODAGE,"1",1) //nome do contato seq 1
               cTO_FAX :=EECCONTATO("E",EEB->EEB_CODAGE,"1",7) //fax do contato seq 1
            Endif
            EEB->(dbSkip())
         Enddo
      ENDIF
   ENDIF
   //se 2 falhou, 3 tentar importador
   IF EMPTY(cTO_NOME)
      cTO_NOME := EE7->EE7_IMPODE //nome importador no processo
      cTO_ATTN := EECCONTATO("I",EE7->EE7_IMPORT+EE7->EE7_IMLOJA,"1",1) //nome do contato seq 1
      cTO_FAX  := EECCONTATO("I",EE7->EE7_IMPORT+EE7->EE7_IMLOJA,"1",7) //fax do contato seq 1
   ENDIF

   cEXP_NOME    :=ALLTRIM(cEXP_NOME)
   cEXP_CONTATO :=ALLTRIM(cEXP_CONTATO)
   cEXP_FONE    :=ALLTRIM(cEXP_FONE)
   cEXP_FAX     :=ALLTRIM(cEXP_FAX)
   cTO_NOME     :=ALLTRIM(cTO_NOME)
   cTO_ATTN     :=ALLTRIM(cTO_ATTN)
   cTO_FAX      :=ALLTRIM(cTO_FAX)

   //gerar arquivo padrao de edicao de carta
IF ( E_AVGLTT("G") )
   //adicionar registro no AVGLTT
   AVGLTT->(DBAPPEND())

   //gravar dados a serem editados
   AVGLTT->AVG_CHAVE :=EE7->EE7_PEDIDO //nr. do processo
   AVGLTT->AVG_C01_60:=cEXP_NOME

      //carregar detalhe
   mDETALHE:="DATE: "+DTOC(dDATABASE)+ENTER //data logada no sistema
   mDETALHE:=mDETALHE+INSERE_LINHA
   mDETALHE:=mDETALHE+"FAC SIMILE NUMBER: "+cTO_FAX+ENTER
   mDETALHE:=mDETALHE+"TO: "+cTO_NOME+ENTER
   mDETALHE:=mDETALHE+INSERE_LINHA
   mDETALHE:=mDETALHE+"ATTN: "+cTO_ATTN+ENTER
   mDETALHE:=mDETALHE+INSERE_LINHA
   mDETALHE:=mDETALHE+"FROM: "+cEXP_CONTATO+ENTER
   mDETALHE:=mDETALHE+INSERE_LINHA
   
   mDETALHE:=mDETALHE+"TOTAL NUMBER PAGES INCLUDING THIS COVER: 1"+ENTER
   mDETALHE:=mDETALHE+INSERE_LINHA
   mDETALHE:=mDETALHE+"ADVICE OF ORDER RECEIPT AS FOLLOWS"+ENTER
   mDETALHE:=mDETALHE+INSERE_LINHA
   mDETALHE:=mDETALHE+"YOUR REF NBR:"+EE7->EE7_REFIMP+ENTER // Referencia Importador   C 40
   mDETALHE:=mDETALHE+INSERE_LINHA
   mDETALHE:=mDETALHE+"CUSTOMER:"+EE7->EE7_IMPODE+ENTER // Importador C 30
   mDETALHE:=mDETALHE+INSERE_LINHA
   mDETALHE:=mDETALHE+"OUR ORDER NBR WILL BE:"+EE7->EE7_PEDIDO+ENTER // Nr. Pedido        C 20
   mDETALHE:=mDETALHE+INSERE_LINHA
   mDETALHE:=mDETALHE+INSERE_LINHA
   mDETALHE:=mDETALHE+"ACCEPTANCE REGARDING ALL ORDER DETAILS WILL BE SENT SOON."+ENTER
   
   mDETALHE:=mDETALHE+INSERE_LINHA
 
   mDETALHE:=mDETALHE+INSERE_LINHA
   
   mDETALHE:=mDETALHE+INSERE_LINHA
   mDETALHE:=mDETALHE+INSERE_LINHA
   mDETALHE:=mDETALHE+INSERE_LINHA
   mDETALHE:=mDETALHE+INSERE_LINHA
   
   mDETALHE:=mDETALHE+"BEST REGARDS"+ENTER
   mDETALHE:=mDETALHE+INSERE_LINHA
   
   mDETALHE:=mDETALHE+"REMARKS: OUR FAX NUMBER "+cEXP_FAX+ENTER
   mDETALHE:=mDETALHE+INSERE_LINHA
   mDETALHE:=mDETALHE+"IF YOU NOT RECEIVE ALL PAGES, PLEASE CALL US"+ENTER
   mDETALHE:=mDETALHE+INSERE_LINHA
   mDETALHE:=mDETALHE+"PHONE "+cEXP_FONE+ENTER
 
	 //gravar detalhe
   AVGLTT->WK_DETALHE := mDETALHE

   cSEQREL :=GETSX8NUM("SY0","Y0_SEQREL")
   CONFIRMSX8()
   //executar rotina de manutencao de caixa de texto
   lRETr:=E_AVGLTT("M",WORKID->WKDESCR)
ENDIF
//retorna a situacao anterior ao processamento
EE7->(DBGOTO(nRECNO))
__RETURN(lRETr)

