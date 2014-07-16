#INCLUDE "INKEY.CH"
#IFNDEF CRLF
#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GPER030  � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao de Recibos de Pagamento                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GPER030(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
��� Mauro      �14/03/01�------� Colocado DbsetOrder Src,causava erro Top ���
��� J. Ricardo �16/02/01�------� Utilizacao da data base como parametro   ���
���            �        �      � para impressao.                          ���
��� Emerson    �27/04/01�------�Ajustes para tratar a pensao alimenticia a���
���            �--------�------�partir do cadastro de beneficiarios(novo) ���
��� Natie      �24/08/01�------� Inclusao PrnFlush()-Descarrega Spool     ���
��� Natie      �24/08/01�ver609�fSendDPagto()-Envio de E-mail Demont.Pagto���
��� Natie      �29/08/01�009963�PrnFlush-Descarrega spool impressao teste ���
��� Marinaldo  �20/09/01�Melhor�Geracao de Demonstrativo de Pagamento   pa���
���            �--------�------�ra o Terminal de Consulta.                ���
��� Marinaldo  �26/09/01�Melhor�Passagem de dDataRef para OpenSRC() por re���
���            �--------�------�ferencia.                               ���
��� Marinaldo  �08/10/01�Melhor�Inclusao de Regua de Processamento  Quando���
���            �--------�------�geracao de e-mail                       ���
��� Mauro      �05/11/01�010528�Verificar a Sit.de Demitido no mes de ref.���
���            �        �      �nao listava demitido posterior a dt.ref.  ���
��� Marinaldo  �21/12/01�Acerto�O Programa devera sempre retornar caracter���
���            �        �      �Qdo. Chamada atraves do Terminal para  evi���
     pr�ximo            pesquisar
��� Marinaldo  �21/12/01�Acerto�O Programa devera sempre retornar caracter���
���            �        �      �Qdo. Chamada atraves do Terminal para  evi���
���            �        �      �tar erro de comparacao de tipo            ���
��� Natie      �11/12/01�009963� Acerto Impressao-Teste                   ���
���            �11/12/01�011547� Quebra pag.qdo func. tem mais de 2 recibo���
��� Mauro      �14/01/02�012282�Acerto na compar. d Mes Aniv. Dezembro.   ���
��� Silvia     �20/02/02�013293�Acerto nos Dias Trabalhados para Paraguai ���
��� Mauro      �20/03/02�------�Inicializar o Li com _prow() estava pulan-���
���            �        �      �do pag.na prim.Impr. Epson 1170           ���
��� Natie      �05/04/02�------�Quebra de pagina - pre impresso           ���
��� Emerson    �06/01/03�------�Buscar o codigo CBO no cadastro de funcoes���
���            �        �------�de acordo com os novos codigos CBO/2002.  ���
��� Silvia     �23/01/03�Locali�Localizacao do relatorio para utilizacao  ���
���            �        �zacao �no Uruguai e Argentina                    ���
��� Priscila   �10/02/03�------�Ajuste na Quebra de pagina - pre impresso ���
��� Andreia    �31/03/03�------�Quando a impressao for em disco e o modelo���
���            �        �      �for "Pre-Impresso" zerar variavel LI para ���
���            �        �      �imprimir paginas em branco.               ���
��� Marcos R   �15/12/03�      �Mostra na linha de mensagem o IR do       ���
���            �        �      �ADIANTAMENTO                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

User Function NHGPE050(lTerminal,cFilTerminal,cMatTerminal,cMesAnoRef,nRecTipo,cSemanaTerminal)

//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Basicas)                            �
//����������������������������������������������������������������
Local cString:="SRA"        // alias do arquivo principal (Base)
//Local aOrd   := {STR0001,STR0002,STR0003,STR0004,STR0005} //
Local aOrd   := {"Matricula","C.Custo","Nome","Chapa","C.Custo + Nome"} //"Matricula"###"C.Custo"###"Nome"###"Chapa"###"C.Custo + Nome"
Local cDesc1 := "Emissao de Recibos de Pagamento."
Local cDesc2 := "Ser impresso de acordo com os parametros solicitados pelo"
Local cDesc3 := "usuario."

//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Programa)                           �
//����������������������������������������������������������������
Local nExtra,cIndCond,cIndRc
Local Baseaux := "S", cDemit := "N"
Local cHtml := ""

//��������������������������������������������������������������Ŀ
//� Define o numero da linha de impress�o como 0                 �
//����������������������������������������������������������������

//����������������������������������������������������������������
SetPrc(0,0)

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Basicas)                            �
//����������������������������������������������������������������
Private aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }  //"Zebrado"###"Administra��o"
Private nomeprog :="GPER030"
Private aLinha   := { },nLastKey := 0
Private cPerg    :="GPR030"
Private cSem_De  := "  /  /    "
Private cSem_Ate := "  /  /    "
Private nAteLim , nBaseFgts , nFgts , nBaseIr , nBaseIrFe
Private cCompac , cNormal
Private aDriver 

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Programa)                           �
//����������������������������������������������������������������
Private aLanca := {}
Private aProve := {}
Private aDesco := {}
Private aBases := {}
Private aInfo  := {}
Private aCodFol:= {}
Private li     := _PROW()
Private Titulo := "EMISSAO DE RECIBOS DE PAGAMENTOS"
Private lEnvioOk := .F.
Private nIrAdt := 0
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="GPER030"            //Nome Default do relatorio em Disco
IF !lTerminal
  wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)
EndIF 
                 
//��������������������������������������������������������������Ŀ
//� Verifica se o programa foi chamado do terminal - TCF         �
//����������������������������������������������������������������
lTerminal := If( lTerminal == Nil, .F., lTerminal )

//��������������������������������������������������������������Ŀ
//� Define a Ordem do Relatorio                                  �
//����������������������������������������������������������������
nOrdem := IF( !lTerminal, aReturn[8] , 1 )

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Pergunte("GPR030",.F.)

//��������������������������������������������������������������Ŀ 
//� Carregando variaveis mv_par?? para Variaveis do Sistema.     �
//����������������������������������������������������������������
cSemanaTerminal := IF( Empty( cSemanaTerminal ) , Space( Len( SRC->RC_SEMANA ) ) , cSemanaTerminal )
dDataRef   := IF( !lTerminal, mv_par01 , Stod(Substr(cMesAnoRef,-4)+SubStr(cMesAnoRef,1,2)+"01"))//Data de Referencia para a impressao
nTipRel    := IF( !lTerminal, mv_par02 , 3                    )   //Tipo de Recibo (Pre/Zebrado/EMail)
Esc        := IF( !lTerminal, mv_par03 , nRecTipo         )   //Emitir Recibos(Adto/Folha/1�/2�/V.Extra)
Semana     := IF( !lTerminal, mv_par04 , cSemanaTerminal  )   //Numero da Semana
cFilDe     := IF( !lTerminal,mv_par05,cFilTerminal            )   //Filial De
cFilAte    := IF( !lTerminal,mv_par06,cFilTerminal            )   //Filial Ate
cCcDe      := IF( !lTerminal,mv_par07,SRA->RA_CC          )   //Centro de Custo De
cCcAte     := IF( !lTerminal,mv_par08,SRA->RA_CC          )   //Centro de Custo Ate
cMatDe     := IF( !lTerminal,mv_par09,cMatTerminal            )   //Matricula Des
cMatAte    := IF( !lTerminal,mv_par10,cMatTerminal            )   //Matricula Ate
cNomDe     := IF( !lTerminal,mv_par11,SRA->RA_NOME            )   //Nome De
cNomAte    := IF( !lTerminal,mv_par12,SRA->RA_NOME            )   //Nome Ate
ChapaDe    := IF( !lTerminal,mv_par13,SRA->RA_CHAPA       )   //Chapa De
ChapaAte   := IF( !lTerminal,mv_par14,SRA->RA_CHAPA       )   //Chapa Ate
Mensag1    := mv_par15                                            //Mensagem 1
Mensag2    := mv_par16                                            //Mensagem 2
Mensag3    := mv_par17                                            //Mensagem 3
cSituacao  := IF( !lTerminal,mv_par18, fSituacao( NIL , .F. ) )   //Situacoes a Imprimir
cCategoria := IF( !lTErminal,mv_par19, fCategoria( NIL , .F. ))   //Categorias a Imprimir
cBaseAux   := If(mv_par20 == 1,"S","N")                           //Imprimir Bases

If aReturn[5] == 1 .and. nTipRel == 1
  li  :=  0
EndIf




IF !lTerminal
  cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
  //��������������������������������������������������������������Ŀ
  //� Inicializa Impressao                                         �
  //����������������������������������������������������������������
  If ! fInicia(cString,nTipRel)
      Return
  Endif                                                             

EndIF

IF nTipRel==3
  IF lTerminal
      cHtml := R030Imp(.F.,wnRel,cString,cMesAnoRef,lTerminal)
  Else
      ProcGPE({|lEnd| R030IMP(@lEnd,wnRel,cString,cMesAnoRef)},,,.T.)  // Chamada do Processamento
  EndIF
Else
  RptStatus({|lEnd| R030Imp(@lEnd,wnRel,cString,cMesAnoRef)},Titulo)  // Chamada do Relatorio
EndIF

Return( IF( lTerminal , cHtml , NIL ) )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R030IMP  � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processamento Para emissao do Recibo                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � R030Imp(lEnd,WnRel,cString,cMesAnoRef,lTerminal)             ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

Static Function R030Imp(lEnd,WnRel,cString,cMesAnoRef,lTerminal)
//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Basicas)                            �
//����������������������������������������������������������������
Local lIgual                 //Vari vel de retorno na compara�ao do SRC
Local cArqNew                //Vari vel de retorno caso SRC # SX3
Local tamanho     := "P"
Local limite      := 80
Local aOrdBag     := {}
Local cMesArqRef  
Local cArqMov     := ""
Local aCodBenef   := {}
Local cAcessaSR1  := &("{ || " + ChkRH("GPER030","SR1","2") + "}")
Local cAcessaSRA  := &("{ || " + ChkRH("GPER030","SRA","2") + "}")
Local cAcessaSRC  := &("{ || " + ChkRH("GPER030","SRC","2") + "}")
Local cAcessaSRI  := &("{ || " + ChkRH("GPER030","SRI","2") + "}")
Local cHtml         := "" 
Local nHoras      := 0
Local nMes, nAno
Private cAliasMov := ""
Private Desc_Est,Desc_Comp,Desc_Cid
Private cDtPago

If cPaisLoc $ "URU|ARG"  
  If Esc == 3
      cMesArqRef := "13" + Right(cMesAnoRef,4)    
  ElseIf Esc == 4
      cMesArqRef := "23" + Right(cMesAnoRef,4)        
  Else
      cMesArqRef := cMesAnoRef
  Endif       
Else
  If Esc == 4  
      cMesArqRef := "13" + Right(cMesAnoRef,4)
  Else
      cMesArqRef := cMesAnoRef
  Endif                 
Endif         

//��������������������������������������������������������������Ŀ
//| Verifica se existe o arquivo de fechamento do mes informado  |
//����������������������������������������������������������������
If !OpenSrc( cMesArqRef, @cAliasMov, @aOrdBag, @cArqMov, @dDataRef , NIL ,lTerminal )
  Return( IF( lTerminal , cHtml , NIL ) )
Endif

If cPaisLoc == "ARG"
  nMes := Month(dDataRef) - 1
  nAno := Year(dDataRef)
  If nMes == 0
      nMes := 1
      nAno := nAno - 1
  Endif
  If nMes < 0
      nMes := 12 - ( nMes * -1 )
      nAno := nAno - 1
  Endif
  If Esc == 1 .or. Esc == 2
      cAnoMesAnt := StrZero(nAno,4)+StrZero(nMes,2)
  ElseIf Esc == 3 .or. Esc == 4
      cAnoMesAnt := Right(cMesAnoRef,4)-1 +"13" 
  Endif       
Endif 

//��������������������������������������������������������������Ŀ
//� Selecionando a Ordem de impressao escolhida no parametro.    �
//����������������������������������������������������������������
dbSelectArea( "SRA")
IF !lTerminal
  If nOrdem == 1
      dbSetOrder(1)
  ElseIf nOrdem == 2
      dbSetOrder(2)
  ElseIf nOrdem == 3
      dbSetOrder(3)
  Elseif nOrdem == 4
      cArqNtx  := CriaTrab(NIL,.f.)
      cIndCond :="RA_Filial + RA_Chapa + RA_Mat"
      IndRegua("SRA",cArqNtx,cIndCond,,,"Selecionando Registros...")      //"Selecionando Registros..."
  ElseIf nOrdem == 5
      dbSetOrder(8)
  Endif

  dbGoTop()
  
  If nTipRel == 2
      aDriver := LEDriver()
      cCompac := aDriver[1]
      cNormal := aDriver[2]
      @ LI,00 PSAY &cCompac
  Endif   
EndIF
  
//��������������������������������������������������������������Ŀ
//� Selecionando o Primeiro Registro e montando Filtro.          �
//����������������������������������������������������������������
If nOrdem == 1 .or. lTerminal
  cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
  IF !lTerminal
      dbSeek(cFilDe + cMatDe,.T.)
      cFim    := cFilAte + cMatAte
  Else
      cFim    := &(cInicio)
  EndIF   
ElseIf nOrdem == 2
  dbSeek(cFilDe + cCcDe + cMatDe,.T.)
  cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
  cFim     := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 3
  dbSeek(cFilDe + cNomDe + cMatDe,.T.)
  cInicio := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
  cFim    := cFilAte + cNomAte + cMatAte
ElseIf nOrdem == 4
  dbSeek(cFilDe + ChapaDe + cMatDe,.T.)
  cInicio := "SRA->RA_FILIAL + SRA->RA_CHAPA + SRA->RA_MAT"
  cFim    := cFilAte + ChapaAte + cMatAte
ElseIf nOrdem == 5
  dbSeek(cFilDe + cCcDe + cNomDe,.T.)
  cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
  cFim     := cFilAte + cCcAte + cNomAte
Endif

dbSelectArea("SRA")
//��������������������������������������������������������������Ŀ
//� Carrega Regua Processamento                                  �
//����������������������������������������������������������������
IF nTipRel # 3
  SetRegua(RecCount())    // Total de elementos da regua
Else
  IF !lTerminal
      GPProcRegua(RecCount())// Total de elementos da regua
  EndIF
EndIF

TOTVENC:= TOTDESC:= FLAG:= CHAVE := 0

Desc_Fil   := Desc_End := DESC_CC:= DESC_FUNC:= ""
DESC_MSG1  := DESC_MSG2:= DESC_MSG3:= Space(01)
cFilialAnt := "  "
cFuncaoAnt := "    "
cCcAnt     := Space(9)
Vez        := 0
OrdemZ     := 0

While SRA->( !Eof() .And. &cInicio <= cFim )
  
  //��������������������������������������������������������������Ŀ
  //� Movimenta Regua Processamento                                �
  //����������������������������������������������������������������
  IF !lTerminal
  
      IF nTipRel # 3
          IncRegua()  // Anda a regua
      ElseIF !lTerminal
          GPIncProc(SRA->RA_FILIAL+" - "+SRA->RA_MAT+" - "+SRA->RA_NOME)
      EndIF
                    
      If lEnd
          @Prow()+1,0 PSAY cCancel
          Exit
      Endif    
      //��������������������������������������������������������������Ŀ
      //� Consiste Parametrizacao do Intervalo de Impressao            �
      //����������������������������������������������������������������
      If (SRA->RA_CHAPA < ChapaDe) .Or. (SRA->Ra_CHAPa > ChapaAte) .Or. ;
          (SRA->RA_NOME < cNomDe)    .Or. (SRA->Ra_NOME > cNomAte)    .Or. ;
          (SRA->RA_MAT < cMatDe)     .Or. (SRA->Ra_MAT > cMatAte)     .Or. ;
          (SRA->RA_CC < cCcDe)       .Or. (SRA->Ra_CC > cCcAte)
          SRA->(dbSkip(1))
          Loop
      EndIf
  
  EndIF
  
  aLanca:={}         // Zera Lancamentos
  aProve:={}         // Zera Lancamentos
  aDesco:={}         // Zera Lancamentos
  aBases:={}         // Zera Lancamentos
  nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00
  
  Ordem_rel := 1     // Ordem dos Recibos
  nIrAdt := 0

  //��������������������������������Ŀ
  //� Verifica Data Demissao         �
  //����������������������������������
  cSitFunc := SRA->RA_SITFOLH
  dDtPesqAf:= CTOD("01/" + Left(cMesAnoRef,2) + "/" + Right(cMesAnoRef,4))
  If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
      cSitFunc := " "
  Endif   

    IF !lTerminal

      //��������������������������������������������������������������Ŀ
      //� Consiste situacao e categoria dos funcionarios               |
      //����������������������������������������������������������������
      If !( cSitFunc $ cSituacao ) .OR.  ! ( SRA->RA_CATFUNC $ cCategoria )
          dbSkip()
          Loop
      Endif

      If cSitFunc $ "D" .And. Mesano(SRA->RA_DEMISSA) # Mesano(dDataRef)
          dbSkip()
          Loop
      Endif
      
      //��������������������������������������������������������������Ŀ
      //� Consiste controle de acessos e filiais validas               |
      //����������������������������������������������������������������
      If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
         dbSkip()
         Loop
      EndIf
    
    EndIF 
  
  If SRA->RA_CODFUNC # cFuncaoAnt           // Descricao da Funcao
      DescFun(Sra->Ra_Codfunc,Sra->Ra_Filial)
      cFuncaoAnt:= Sra->Ra_CodFunc
  Endif
  
  If SRA->RA_CC # cCcAnt                   // Centro de Custo
      DescCC(Sra->Ra_Cc,Sra->Ra_Filial)
      cCcAnt:=SRA->RA_CC
  Endif
  
  If SRA->RA_Filial # cFilialAnt
      If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. ! fInfo(@aInfo,Sra->Ra_Filial)
          Exit
      Endif
      Desc_Fil := aInfo[3]
      Desc_End := aInfo[4]                // Dados da Filial
      Desc_CGC := aInfo[8]
      DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
      Desc_Est := Substr(fDesc("SX5","12"+aInfo[6],"X5DESCRI()"),1,12)
      Desc_Comp:= aInfo[14]                   // Complemento Cobranca
      Desc_Cid := aInfo[05]
      // MENSAGENS
      If MENSAG1 # SPACE(1)
          If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG1)
              DESC_MSG1 := Left(SRX->RX_TXT,30)
              DESC_MSG1 := Left(SRX->RX_TXT,30)
          ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG1)
              DESC_MSG1 := Left(SRX->RX_TXT,30)
          Endif
      Endif

      If MENSAG2 # SPACE(1)
          If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG2)
              DESC_MSG2 := Left(SRX->RX_TXT,30)
          ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG2)
              DESC_MSG2 := Left(SRX->RX_TXT,30)
          Endif
      Endif

      If MENSAG3 # SPACE(1)
          If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG3)
              DESC_MSG3 := Left(SRX->RX_TXT,30)
          ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG3)
              DESC_MSG3 := Left(SRX->RX_TXT,30)
          Endif
      Endif
      dbSelectArea("SRA")
      cFilialAnt := SRA->RA_FILIAL
  Endif
  
  Totvenc := Totdesc := 0
  
  If Esc == 1 .OR. Esc == 2
      dbSelectArea("SRC")
      dbSetOrder(1)
      If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
          While !Eof() .And. SRC->RC_FILIAL+SRC->RC_MAT == SRA->RA_FILIAL+SRA->RA_MAT
              If SRC->RC_SEMANA # Semana
                  dbSkip()
                  Loop
              Endif
              If !Eval(cAcessaSRC)
                 dbSkip()
                 Loop
              EndIf
              If (Esc == 1) .And. (Src->Rc_Pd == aCodFol[7,1])      // Desconto de Adto
                  fSomaPd("P",aCodFol[6,1],SRC->RC_HORAS,SRC->RC_VALOR)
                  TOTVENC += Src->Rc_Valor
              Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[12,1])
                  fSomaPd("D",aCodFol[9,1],SRC->RC_HORAS,SRC->RC_VALOR)
                  TOTDESC += SRC->RC_VALOR
              Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[8,1])
                  fSomaPd("P",aCodFol[8,1],SRC->RC_HORAS,SRC->RC_VALOR)
                  TOTVENC += SRC->RC_VALOR
              Else
                  If PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
                      If (Esc # 1) .Or. (Esc == 1 .And. PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_ADIANTA" ) == "S")
                          If cPaisLoc == "PAR" .and. SRC->RC_HORAS == 30
                             LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)), Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Strzero(Month(dDataRef),2)+"/"+right(str(Year(dDataRef)),2)),@nHoras)
                          Else
                             nHoras := SRC->RC_HORAS
                          Endif
                          fSomaPd("P",SRC->RC_PD,nHoras,SRC->RC_VALOR)
                          TOTVENC += Src->Rc_Valor
                      Endif
                  Elseif PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "2"
                      If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
                          fSomaPd("D",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
                          TOTDESC += Src->Rc_Valor
                      Endif
                  Elseif PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "3"
                      If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
                          fSomaPd("B",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
                      Endif
                  Endif
              Endif
              If ESC = 1
                  If SRC->RC_PD == aCodFol[10,1]
                      nBaseIr := SRC->RC_VALOR
                  Endif
              ElseIf SRC->RC_PD == aCodFol[13,1]
                  nAteLim += SRC->RC_VALOR
              Elseif SRC->RC_PD$ aCodFol[108,1]+'*'+aCodFol[17,1]
                  nBaseFgts += SRC->RC_VALOR
              Elseif SRC->RC_PD$ aCodFol[109,1]+'*'+aCodFol[18,1]
                  nFgts += SRC->RC_VALOR
              Elseif SRC->RC_PD == aCodFol[15,1]
                  nBaseIr += SRC->RC_VALOR
              Elseif SRC->RC_PD == aCodFol[16,1]
                  nBaseIrFe += SRC->RC_VALOR
              Endif

              If SRC->RC_PD == "723"
                 nIrAdt := SRC->RC_VALOR
              Endif    

              dbSelectArea("SRC")
              dbSkip()
          Enddo
      Endif
  Elseif Esc == 3 .And. !(cPaisLoc $ "URU|ARG")
      //��������������������������������������������������������������Ŀ
      //� Busca os codigos de pensao definidos no cadastro beneficiario�
      //����������������������������������������������������������������
      fBusCadBenef(@aCodBenef, "131",{aCodfol[172,1]})
      dbSelectArea("SRC")
      dbSetOrder(1)
      If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
          While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT == SRC->RC_FILIAL + SRC->RC_MAT
              If !Eval(cAcessaSRC)
                 dbSkip()
                 Loop
              EndIf
              If SRC->RC_PD == aCodFol[22,1]
                  fSomaPd("P",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
                  TOTVENC += SRC->RC_VALOR
              Elseif Ascan(aCodBenef, { |x| x[1] == SRC->RC_PD }) > 0
                  fSomaPd("D",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
                  TOTDESC += SRC->RC_VALOR
              Elseif SRC->RC_PD == aCodFol[108,1] .Or. SRC->RC_PD == aCodFol[109,1] .Or. SRC->RC_PD == aCodFol[173,1] 
                  fSomaPd("B",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
              Endif
              
              If SRC->RC_PD == aCodFol[108,1]
                  nBaseFgts := SRC->RC_VALOR
              Elseif SRC->RC_PD == aCodFol[109,1]
                  nFgts     := SRC->RC_VALOR
              Endif

              If SRC->RC_PD == "723"
                 nIrAdt := SRC->RC_VALOR
              Endif    

              dbSelectArea("SRC")
              dbSkip()
          Enddo
      Endif
  Elseif Esc == 4 .or. If(cPaisLoc $ "URU|ARG", Esc ==3,.F.)
      dbSelectArea("SRI")
      dbSetOrder(2)
      If dbSeek(SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT)
          While !Eof() .And. SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT == SRI->RI_FILIAL + SRI->RI_CC + SRI->RI_MAT
              If !Eval(cAcessaSRI)
                 dbSkip()
                 Loop
              EndIf
              If PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
                  fSomaPd("P",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
                  TOTVENC = TOTVENC + SRI->RI_VALOR
              Elseif PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "2"
                  fSomaPd("D",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
                  TOTDESC = TOTDESC + SRI->RI_VALOR
              Elseif PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "3"
                  fSomaPd("B",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
              Endif

              If SRI->RI_PD == aCodFol[19,1]
                  nAteLim += SRI->RI_VALOR
              Elseif SRI->RI_PD$ aCodFol[108,1]
                  nBaseFgts += SRI->RI_VALOR
              Elseif SRI->RI_PD$ aCodFol[109,1]
                  nFgts += SRI->RI_VALOR
              Elseif SRI->RI_PD == aCodFol[27,1]
                  nBaseIr += SRI->RI_VALOR
              Endif

              If SRC->RC_PD == "723"
                 nIrAdt := SRC->RC_VALOR
              Endif    

              dbSkip()
          Enddo
      Endif
  Elseif Esc == 5
      dbSelectArea("SR1")
      dbSetOrder(1)
      If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
          While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT ==  SR1->R1_FILIAL + SR1->R1_MAT
              If Semana # "99"            
                  If SR1->R1_SEMANA # Semana
                      dbSkip()
                      Loop
                  Endif
              Endif                   
              If !Eval(cAcessaSR1)
                 dbSkip()
                 Loop
              EndIf
              If PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
                  fSomaPd("P",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
                  TOTVENC = TOTVENC + SR1->R1_VALOR
              Elseif PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "2"
                  fSomaPd("D",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
                  TOTDESC = TOTDESC + SR1->R1_VALOR
              Elseif PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "3"
                  fSomaPd("B",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
              Endif
              dbskip()
          Enddo
      Endif
  Endif  
  If cPaisLoc == "ARG"
      dbSelectArea("SRD")
      If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
         While !Eof() .And. (SRA->RA_FILIAL+SRA->RA_MAT == SRD->RD_FILIAL+SRD->RD_MAT)
            If (SRA->RA_FILIAL+SRA->RA_MAT == SRD->RD_FILIAL+SRD->RD_MAT).And. SRD->RD_DATARQ == cAnoMesAnt
              If Esc == 1 .Or. Esc == 2
                      cDtPago := dtoc(SRD->RD_DATPGT)
                  ElseIf Esc == 3
                      If SRD->RD_TIPO2 == "P"   
                          cDtPago := dtoc(SRD->RD_DATPGT)
                      Endif
                  ElseIf Esc == 4
                      If SRD->RD_TIPO2 == "S"   
                          cDtPago := dtoc(SRD->RD_DATPGT)
                  Endif
                 Endif    
              Endif   
            dbSkip()
        Enddo   
     Endif   
  Endif   
  dbSelectArea("SRA")
  
  If TOTVENC = 0 .And. TOTDESC = 0
      dbSkip()
      Loop
  Endif
  
  If Vez == 0  .And.  Esc == 2 //--> Verifica se for FOLHA.
      PerSemana() // Carrega Datas referentes a Semana.
  EndIf
  
  If nTipRel == 1 .and. !lTerminal
      fImpressao()   // Impressao do Recibo de Pagamento
      IF !lTerminal
          If Vez = 0  .and. nTipRel # 3  .and. aReturn[5] # 1
              //��������������������������������������������������������������Ŀ
              //� Descarrega teste de impressao                                �
              //����������������������������������������������������������������
              fImpTeste(cString) 
              TotDesc := TotVenc := 0
              If mv_par01 = 2
                  Loop
              Endif   

          ENDIF
      EndIF
  ElseIf nTipRel == 2 .and. !lTerminal
      For nX := 1 to If(cPaisLoc <> "ARG",1,2)
          fImpreZebr()
      Next        
      ASize(AProve,0)
      ASize(ADesco,0)
      ASize(aBases,0)
  ElseIf nTipRel == 3 .or. lTerminal
      cHtml := fSendDPgto(lTerminal)   //Monta o corpo do e-mail e envia-o
  Endif

  dbSelectArea("SRA")
  SRA->( dbSkip() )
  TOTDESC := TOTVENC := 0

EndDo

//��������������������������������������������������������������Ŀ
//� Seleciona arq. defaut do Siga caso Imp. Mov. Anteriores      �
//����������������������������������������������������������������
If !Empty( cAliasMov )
  fFimArqMov( cAliasMov , aOrdBag , cArqMov )
EndIf

IF !lTerminal

  //��������������������������������������������������������������Ŀ
  //� Termino do relatorio                                         �
  //����������������������������������������������������������������
  dbSelectArea("SRC")
  dbSetOrder(1)          // Retorno a ordem 1
  dbSelectArea("SRI")
  dbSetOrder(1)          // Retorno a ordem 1
  dbSelectArea("SRA")
  SET FILTER TO
  RetIndex("SRA")
  
  If !(Type("cArqNtx") == "U")
      fErase(cArqNtx + OrdBagExt())
  Endif
  
  Set Device To Screen
  
  If lEnvioOK
      APMSGINFO(" ") // (STR0042)  
  ElseIf nTipRel== 3
      APMSGINFO(" ") // (STR0043)
  EndIf                                                                 
  If aReturn[5] = 1 .and. nTipRel # 3
      Set Printer To
      Commit
      ourspool(wnrel)
  Endif
  MS_FLUSH()

EndIF 

Return( cHtml )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fImpressao� Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO DO RECIBO FORMULARIO CONTINUO                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fImpressao()                                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fImpressao()

Local nConta  := nContr := nContrT:=0
Local aDriver := LEDriver()
Private nLinhas:=16              // Numero de Linhas do Miolo do Recibo

Private cCompac := aDriver[1]
Private cNormal := aDriver[2]

Ordem_Rel := 1

If cPaisLoc == "ARG"
  fCabecArg()
Else  
  fCabec()
Endif 

For nConta = 1 To Len(aLanca)
  fLanca(nConta)
  nContr ++
  nContrT ++
  If nContr = nLinhas .And. nContrT < Len(aLanca)
      nContr:=0
      Ordem_Rel ++
      fContinua()
      If cPaisLoc == "ARG"
          fCabecArg()
      Else    
          fCabec()
      Endif   
  Endif
Next

Li+=(nLinhas-nContr)
If cPaisLoc == "ARG"
  @ ++LI,01 PSAY TRANS(TOTVENC,"@E 999,999,999.99") 
  @ LI,44 PSAY TRANS(TOTDESC,"@E 999,999,999.99")
  @ LI,88 PSAY TRANS((TOTVENC-TOTDESC),"@E 999,999,999.99")
  Li +=2
  @ Li,01 PSAY MesExtenso(MONTH(dDataRef)) + " de "+ STR(YEAR(dDataRef),4)
  @ ++Li,01 PSAY EXTENSO(TOTVENC-TOTDESC,,,)+REPLICATE("*",130-LEN(EXTENSO(TOTVENC-TOTDESC,,,)))
  @ ++Li,01 PSAY StrZero(Day(dDataRef),2) + " de " + MesExtenso(MONTH(dDataRef)) + " de "+STR(YEAR(dDataRef),4)
  @ ++Li,01 PSAY TRANS((TOTVENC-TOTDESC),"@E 999,999,999.99")
Else
  fRodape()
Endif 
//Li+=3

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fImpreZebr� Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
or            pr�ximo            pesquisar
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO DO RECIBO FORMULARIO ZEBRADO                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fImpreZebr()                                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fImpreZebr()

Local nConta    := nContr := nContrT:=0

If li >= 60 
  li := 0
Endif
If cPaisLoc == "ARG"
  fCabecZAr()
Else  
  fCabecZ()
Endif 
fLancaZ(nConta)

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fCabec    � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO Cabe�alho Form Continuo                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fCabec()                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
or            pr�ximo            pesquisar
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fCabec()   // Cabecalho do Recibo


@ LI,01 PSAY &cNormal+DESC_Fil
LI ++
@ LI,01 PSAY DESC_END
LI ++
@ LI,01 PSAY DESC_CGC

If !Empty(Semana) .And. Semana # '99' .And.  Upper(SRA->RA_TIPOPGT) == 'S'
  @ Li,37 pSay "Semana " + ' (' + cSem_De + " a " + ;    //'Semana '###' a '
  cSem_Ate + ')'
Else
  @ LI,55 PSAY MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4)
EndIf 

LI +=3
@ LI,01 PSAY SRA->RA_Mat
@ LI,08 PSAY Left(SRA->RA_NOME,28)
@ LI,37 PSAY fCodCBO(SRA->RA_FILIAL,SRA->RA_CODFUNC,dDataRef)
@ LI,44 PSAY SRA->RA_Filial
@ LI,54 PSAY SRA->RA_CC
@ LI,65 PSAY ORDEM_REL PICTURE "9999"
LI ++


/* 
cDet := 'FUNCAO: ' + SRA->RA_CODFUNC + ' '       //'FUNCAO: '
cDet += DescFun(SRA->RA_CODFUNC,SRA->RA_FILIAL) + ' '
cDet += DescCc(SRA->RA_CC,SRA->RA_FILIAL) + ' '
cDet += 'CHAPA: ' + SRA->RA_CHAPA                   //'CHAPA: '
*/

cDet := 'SETOR: '+DescCc(SRA->RA_CC,SRA->RA_FILIAL) + ' '
cDet += 'CHAPA: ' + SRA->RA_CHAPA                   //'CHAPA: '



@ Li,01 pSay cDet



Li += 2
Return Nil


/*
�����������������������������������������������������������������������������
or            pr�ximo            pesquisar
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fCabecz   � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO Cabe�alho Form ZEBRADO                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fCabecz()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fCabecZ()   // Cabecalho do Recibo Zebrado

LI ++
@ LI,00 PSAY "*"+REPLICATE("=",130)+"*"

LI ++
@ LI,00  PSAY  "|"
@ LI,46  PSAY "RECIBO DE PAGAMENTO  "
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

LI ++
@ LI,00  PSAY "| Empresa   : " +  DESC_Fil         //"| Empresa   : "
@ LI,92  PSAY " Local : " + SRA->RA_FILIAL    //" Local : "
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "| C Custo   : " + SRA->RA_CC + " - " + DescCc(SRA->RA_CC,SRA->RA_FILIAL) //"| C Custo   : "
If !Empty(Semana) .And. Semana # "99" .And.  Upper(SRA->RA_TIPOPGT) == "S"
  @ Li,92 pSay "Sem. " + Semana + " (" + cSem_De + " a " + ;   //'Sem.'###' a '
  cSem_Ate + ")"
Else
  @ LI,92 PSAY MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4)
EndIf 
@ LI,131 PSAY "|" 

LI ++
ORDEMZ ++
@ LI,00  PSAY "| Matricula : " + SRA->RA_MAT       //"| Matricula : "
@ LI,30  PSAY "Nome  : " + SRA->RA_NOME  //"Nome  : "
@ LI,92  PSAY "Ordem : "
@ LI,100 PSAY StrZero(ORDEMZ,4) Picture "9999"
@ LI,131 PSAY "|"

LI ++
@ LI,00  PSAY "| Funcao    : "+SRA->RA_CODFUNC+" - "+DescFun(SRA->RA_CODFUNC,SRA->RA_FILIAL)   //"| Funcao    : "
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

LI ++
@ LI,000 PSAY "| P R O V E N T O S "
@ LI,044 PSAY "  D E S C O N T O S"
@ LI,088 PSAY "  B A S E S"
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
LI++

Return Nil
                     

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fCabecArg �Autor  �Silvia Taguti       � Data �  02/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Impressao do Cabecalho - Argentina                          ���
���          �Pre Impresso                                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
or            pr�ximo            pesquisar
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fCabecArg()


@ ++LI,01 PSAY DESC_Fil
@ ++LI,01 PSAY Alltrim(Desc_End)+" "+Alltrim(Desc_Comp)+" "+Desc_Cid
@ ++LI,01 PSAY DESC_CGC
@ ++LI,01 PSAY cDtPago
@ LI,40 PSAY Alltrim(SRA->RA_BCDEPSAL) + "-" + DescBco(SRA->RA_BCDEPSAL,SRA->RA_FILIAL)
Li +=2 
@ Li,01 PSAY SRA->RA_NOME 
@ Li,45 PSAY SRA->RA_CIC 
@ ++Li,01 PSAY SRA->RA_ADMISSA
@ Li,12 PSAY Substr(DescFun(SRA->RA_CODFUNC,SRA->RA_FILIAL),1,15)
@ Li,30 PSAY Substr(fDesc("SQ3",SRA->RA_CARGO,"SQ3->Q3_DESCSUM"),1,10)
Li += 2

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fCabecZAr �Autor  �Microsiga           � Data �  02/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Impressao do Cabecalho - Argentina                         ���
���          � Zebrado                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fCabecZAr()

@ ++LI,00 PSAY "*"+REPLICATE("=",130)+"*"

@ ++LI,00  PSAY  "|"
@ LI,46    PSAY "RECIBO DE PAGAMENTO  "
@ LI,131   PSAY "|"
@ ++LI,00  PSAY "|"+REPLICATE("-",130)+"|"
@ ++LI,00  PSAY "| Empregador   : " + DESC_Fil        //"| Empregador   : "
@ LI,131   PSAY "|"
@ ++LI,00  PSAY " Domicilio : " + Alltrim(Desc_End)+" "+Alltrim(Desc_Comp)+"-"+Desc_Est   //" Domicilio : "
@ LI,131   PSAY "|"
@ ++Li,00  PSAY " " + DESC_CGC
@ LI,131   PSAY "|"
@ ++LI,00  PSAY " " + cDtPago
@ LI,35    PSAY " "
@ LI,70    PSAY " " + Alltrim(SRA->RA_BCDEPSAL) + "-" + DescBco(SRA->RA_BCDEPSAL,SRA->RA_FILIAL)
@ LI,131   PSAY "|"
@ ++LI,00  PSAY "|"+REPLICATE("-",130)+"|"
@ ++Li,00  PSAY " " + SRA->RA_NOME
@ Li,45    PSAY " "  + SRA->RA_CIC
@ LI,130   PSAY "|"
@ ++Li,00  PSAY " " + DTOC(SRA->RA_ADMISSA)
@ Li,30    PSAY " " + Substr(DescFun(SRA->RA_CODFUNC,SRA->RA_FILIAL),1,15)
@ Li,80    PSAY " "  + Substr(fDesc("SQ3",SRA->RA_CARGO,"SQ3->Q3_DESCSUM"),1,6)
@ LI,131   PSAY "|"
LI ++
@ LI,00    PSAY "|"+REPLICATE("-",130)+"|"
LI ++
@ LI,000   PSAY "| H A B E R E S "
@ LI,046   PSAY "  D E D U C C I O N E S"
@ LI,090   PSAY "  B A S E S "
@ LI,131   PSAY "|"
LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
LI++

Return Nil
                     


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fLanca    � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao das Verbas (Lancamentos) Form. Continuo          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fLanca()                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fLanca(nConta)   // Impressao dos Lancamentos

Local cString := Transform(aLanca[nConta,5],"@E 99,999,999.99")
Local nCol := If(aLanca[nConta,1]="P",43,If(aLanca[nConta,1]="D",57,27))

@ LI,01 PSAY aLanca[nConta,2]
@ LI,05 PSAY aLanca[nConta,3]
If aLanca[nConta,1] # "B"        // So Imprime se nao for base
    @ LI,36 PSAY TRANSFORM(aLanca[nConta,4],"999.99")
Endif
@ LI,nCol PSAY cString
Li ++

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fLancaZ   � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao das Verbas (Lancamentos) Zebrado                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fLancaZ()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fLancaZ(nConta)   // Impressao dos Lancamentos

Local nTermina  := 0
Local nCont     := 0
Local nCont1    := 0
Local nValidos  := 0

nTermina := Max(Max(LEN(aProve),LEN(aDesco)),LEN(aBases))

For nCont := 1 To nTermina
   @ LI,00 PSAY "|"
  IF nCont <= LEN(aProve)
      @ LI,02 PSAY aProve[nCont,1]+TRANSFORM(aProve[nCont,2],'999.99')+TRANSFORM(aProve[nCont,3],"@E 999,999.99")
  ENDIF
  @ LI,44 PSAY "|"
  IF nCont <= LEN(aDesco)
      @ LI,46 PSAY aDesco[nCont,1]+TRANSFORM(aDesco[nCont,2],'999.99')+TRANSFORM(aDesco[nCont,3],"@E 999,999.99")
  ENDIF
  @ LI,88 PSAY "|"
  IF nCont <= LEN(aBases)
      @ LI,90 PSAY aBases[nCont,1]+TRANSFORM(aBases[nCont,2],'999.99')+TRANSFORM(aBases[nCont,3],"@E 999,999.99")
  ENDIF
  @ LI,131 PSAY "|"
  
  //---- Soma 1 nos nValidos e Linha
  nValidos ++
  Li ++
  
  If nValidos = If(cPaisLoc <> "ARG",12,10)
      @ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
      LI ++
      @ LI,00 PSAY "|"
      @ LI,05 PSAY "CONTINUA !!!"
//        @ LI,76 PSAY "|"+&cCompac
      @ Li,131 PSAY "|"
      LI ++
      @ LI,00 PSAY "*"+REPLICATE("=",130)+"*"
      LI += 8
      If li >= 60 
          li := 0
      Endif
      If cPaisLoc == "ARG"
          fCabecZAr()
      Else    
          fCabecZ()
      Endif   
      nValidos := 0
    ENDIF
Next

For nCont1 := nValidos+1 To If(cPaisLoc <> "ARG",12,10)
    @ Li,00  PSAY "|"
    @ Li,44  PSAY "|"
    @ Li,88  PSAY "|"
    @ Li,131 PSAY "|"
Li++
Next 
If cPaisLoc <> "ARG"
  @ LI,131 PSAY "|"
  @ +Li,00 PSAY "|"                      
  @ LI,131 PSAY "|"

   @ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
   LI ++
   @ LI,000 PSAY "|"
   @ LI,005 PSAY DESC_MSG1
   @ LI,044 PSAY "| TOTAL BRUTO     "+SPACE(10)+TRANS(TOTVENC,"@E 999,999,999.99") //"| TOTAL BRUTO     "
   @ LI,088 PSAY "|"+" TOTAL DESCONTOS     "+SPACE(07)+TRANS(TOTDESC,"@E 999,999,999.99") //" TOTAL DESCONTOS     "
   @ LI,131 PSAY "|"
   LI ++
   @ LI,000 PSAY "|"
   @ LI,005 PSAY DESC_MSG2
   @ LI,044 PSAY "|"+REPLICATE("-",86)+"|"

  LI ++
  @ LI,000 PSAY "|"
  @ LI,005 PSAY DESC_MSG3
  @ LI,044 PSAY "| CREDITO:"+SRA->RA_BCDEPSAL+"-"+DescBco(SRA->RA_BCDEPSAL,SRA->RA_FILIAL) //"| CREDITO:"
  @ LI,089 PSAY "| LIQUIDO A RECEBER     "+SPACE(05)+TRANS((TOTVENC-TOTDESC),"@E 999,999,999.99")            //"| LIQUIDO A RECEBER     "
  @ LI,132 PSAY "|"

  LI ++
  @ LI,000 PSAY "|"+REPLICATE("-",130)+"|"

  LI ++
  @ LI,000 PSAY "|"
  @ LI,044 PSAY "| CONTA:" + SRA->RA_CTDEPSAL        //"| CONTA:"
  @ LI,088 PSAY "|"
  @ LI,131 PSAY "|"

  LI ++
  @ LI,000 PSAY "|"+REPLICATE("-",130)+"|"

  LI ++
  @ LI,00  PSAY "| Recebi o valor acima em ___/___/___ " + Replicate("_",40)       //"| Recebi o valor acima em ___/___/___ "
  @ li,131 PSAY "|"

  LI ++
  @ LI,00 PSAY "*"+REPLICATE("=",130)+"*"
Else
  fRodapeAr()
Endif 

Li += 1

//Quebrar pagina
If LI > 63
  LI := 0
EndIf
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fContinua � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressap da Continuacao do Recibo                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fContinua()                                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fContinua()    // Continuacao do Recibo

Li+=1
   @ LI,05 PSAY &cNormal + "CONTINUA !!!"
Li+=8

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fRodape   � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao do Rodape                                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fRodape()                                                  ���
���Sintaxe   � fRodape()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fRodape()    // Rodape do Recibo

Local cMesComp

@ LI,05 PSAY DESC_MSG1
LI ++
@ LI,01 PSAY 'FUNCAO: ' + SRA->RA_CODFUNC + ' ' + DescFun(SRA->RA_CODFUNC,SRA->RA_FILIAL)
@ LI,42 PSAY TOTVENC PICTURE "@E 999,999,999.99"
@ LI,56 PSAY TOTDESC PICTURE "@E 999,999,999.99"

LI ++
If nIrAdt > 0 .AND. Esc == 2
	@ LI,01 PSAY "I.R. ADIANTAMENTO: "+Transform(nIrAdt,"@E 9,999.99") // DESC_MSG3
Endif	
LI ++
IF MONTH(dDataRef) = MONTH(SRA->RA_NASC)
    @ LI, 01 PSAY "F E L I Z   A N I V E R S A R I O  ! !"
ENDIF
@ LI,56 PSAY TOTVENC - TOTDESC PICTURE "@E 999,999,999.99"
LI +=2

If !Empty( cAliasMov )
  nValSal := 0
  fBuscaSlr(@nValSal,MesAno(dDataRef))
  If nValSal ==0
      nValSal := SRA->RA_SALARIO
  EndIf
Else
  nValSal := SRA->RA_SALARIO
EndIf
@ LI,05 PSAY &cCompac+Transform(nValSal,"@E 99,999,999.99")

If Esc = 1  // Bases de Adiantamento
    If cBaseAux = "S" .And. nBaseIr # 0
        @ LI,89 PSAY nBaseIr PICTURE "@E 999,999,999.99"
    Endif
ElseIf Esc = 2 .Or. Esc = 4  // Bases de Folha e 13o. 2o.Parc.
  If cBaseAux = "S"
      @ LI,23 PSAY Transform(nAteLim,"@E 999,999,999.99")
      If nBaseFgts # 0
          @ LI,46 PSAY nBaseFgts PICTURE "@E 999,999,999.99"
      Endif
      If nFgts # 0
          @ LI,66 PSAY nFgts PICTURE "@E 99,999,999.99"
      Endif
      If nBaseIr # 0
          @ LI,89 PSAY nBaseIr PICTURE "@E 999,999,999.99"
      Endif
      @ LI,103 PSAY Transform(nBaseIrfE,"@E 999,999,999.99")
  Endif
ElseIf Esc = 3 // Bases de FGTS e FGTS Depositado da 1� Parcela 
  If cBaseAux = "S"
      If nBaseFgts # 0
          @ LI,46 PSAY nBaseFgts PICTURE "@E 999,999,999.99"
      Endif
      If nFgts # 0
          @ LI,66 PSAY nFgts PICTURE "@E 99,999,999.99"
      Endif
  Endif
Endif

@ LI,Pcol() Psay &cNormal

Li ++
IF SRA->RA_BCDEPSAL # SPACE(8)
  Desc_Bco := DescBco(Sra->Ra_BcDepSal,Sra->Ra_Filial)
    @ LI,01 PSAY "CRED:"
    @ LI,06 PSAY SRA->RA_BCDEPSAL
    @ LI,14 PSAY "-"
    @ LI,15 PSAY DESC_BCO
    @ LI,60 PSAY "CONTA:" + SRA->RA_CTDEPSAL   //"CONTA:"
ENDIF                
LI += 3
@ LI,05 PSAY " "
Return Nil
                      

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fRodapeAr �Autor  �Silvia Taguti       � Data �  02/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Impressao Rodape-Argentina                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fRodapeAr()

Local cMesComp

@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
@ ++LI,00 PSAY "| " + " " + TRANS(TOTVENC,"@E 999,999,999.99") 
@ LI,44 PSAY TRANS(TOTDESC,"@E 999,999,999.99")
@ LI,88 PSAY TRANS((TOTVENC-TOTDESC),"@E 999,999,999.99")
@ LI,131 PSAY "|"
@ ++LI,00 PSAY "|" + REPLICATE("-",130)+"|"
Li ++
@ Li,00 PSAY MesExtenso(MONTH(dDataRef)) + " " + STR(YEAR(dDataRef),4)
@ LI,131 PSAY "|"
@ ++LI,00 PSAY "|" + REPLICATE("-",130) + "|"
@ ++Li,00 PSAY EXTENSO(TOTVENC-TOTDESC,,,"-")+REPLICATE("*",95-LEN(EXTENSO(TOTVENC-TOTDESC,,,"-")))
@ LI,131 PSAY "|"
@ ++Li,00 PSAY "" // STR0082
@ LI,131 PSAY "|"
@ ++Li,00 PSAY "" // STR0083 
@ LI,131 PSAY "|"
@ ++Li,00 PSAY "|"                      
@ LI,131 PSAY "|"
@ ++Li,00 PSAY StrZero(Day(dDataRef),2) + " " + MesExtenso(MONTH(dDataRef)) +" "+STR(YEAR(dDataRef),4)
@ Li,070 PSAY + REPLICATE("_",40) 
@ LI,131 PSAY "|"
@ ++Li,00 PSAY TRANS((TOTVENC-TOTDESC),"@E 999,999,999.99")
@ LI,131 PSAY "|"
@ ++Li,00 PSAY ""
@ LI,131 PSAY "|"
@ ++Li,00 PSAY "|"                      
@ LI,131 PSAY "|"
@ ++LI,00 PSAY "*"+REPLICATE("-",130)+"*"

Return Nil

********************
Static Function PerSemana() // Pesquisa datas referentes a semana.
********************

If !Empty(Semana) 
  cChaveSem := StrZero(Year(dDataRef),4)+StrZero(Month(dDataRef),2)+SRA->RA_TNOTRAB
  If !Srx->(dbSeek(If(cFilial=="  ","  ",SRA->RA_FILIAL) + "01" + cChaveSem + Semana , .T. )) .And. ;
      !Srx->(dbSeek(If(cFilial=="  ","  ",SRA->RA_FILIAL) + "01" + Subs(cChaveSem,3,9) + Semana , .T. )) .And. ;
      !Srx->(dbSeek(If(cFilial=="  ","  ",SRA->RA_FILIAL) + "01" + Left(cChaveSem,6)+"999"+ Semana , .T. )) .And. ;
      !Srx->(dbSeek(If(cFilial=="  ","  ",SRA->RA_FILIAL) + "01" + Subs(cChaveSem,3,4)+"999"+ Semana , .T. )) .And. ;
      HELP( " ",1,"SEMNAOCAD" )
      Return Nil
  Endif
  
  If Len(AllTrim(SRX->RX_COD)) == 9
      cSem_De  := Transforma(CtoD(Left(SRX->RX_TXT,8)))
      cSem_Ate := Transforma(CtoD(Subs(SRX->RX_TXT,10,8)))
  Else
     cSem_De  := Transforma(If("/" $ SRX->RX_TXT , CtoD(SubStr( SRX->RX_TXT, 1,10)) , StoD(SubStr( SRX->RX_TXT, 1,8 ))))
     cSem_Ate := Transforma(If("/" $ SRX->RX_TXT , CtoD(SubStr( SRX->RX_TXT, 12,10)), StoD(SubStr( SRX->RX_TXT,12,8 ))))
  EndIf
EndIf 

Return Nil

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fSomaPd   � Autor � R.H. - Mauro          � Data � 24.09.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Somar as Verbas no Array                                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fSomaPd(Tipo,Verba,Horas,Valor)                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fSomaPd(cTipo,cPd,nHoras,nValor)

Local Desc_paga

Desc_paga := DescPd(cPd,Sra->Ra_Filial)  // mostra como pagto

If cTipo # 'B'
    //--Array para Recibo Pre-Impresso
    nPos := Ascan(aLanca,{ |X| X[2] = cPd })
    If nPos == 0
        Aadd(aLanca,{cTipo,cPd,Desc_Paga,nHoras,nValor})
    Else
       aLanca[nPos,4] += nHoras
       aLanca[nPos,5] += nValor
    Endif
Endif

//--Array para o Recibo Pre-Impresso
If cTipo = 'P'
   cArray := "aProve"
Elseif cTipo = 'D'
   cArray := "aDesco"
Elseif cTipo = 'B'
   cArray := "aBases"
Endif

nPos := Ascan(&cArray,{ |X| X[1] = cPd })
If nPos == 0
    Aadd(&cArray,{cPd+" "+Desc_Paga,nHoras,nValor })
Else
    &cArray[nPos,2] += nHoras
    &cArray[nPos,3] += nValor
Endif
Return

*-------------------------------------------------------
Static Function Transforma(dData) //Transforma as datas no formato DD/MM/AAAA
*-------------------------------------------------------
Return(StrZero(Day(dData),2) +"/"+ StrZero(Month(dData),2) +"/"+ Right(Str(Year(dData)),4))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fSendDPgto| Autor � R.H.-Natie            � Data � 15.08.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Envio de E-mail -Demonstrativo de Pagamento                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico :Envio Demonstrativo de Pagto atraves de eMail  ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fSendDPgto(lTerminal)

Local aFiles      := {}
Local cEmail      := If(SRA->RA_RECMAIL=="S",SRA->RA_EMAIL,"    ")  
Local cHtml       := ""
Local cSubject    := " DEMONSTRATIVO DE PAGAMENTO "
Local cAlias      := Alias()
Local cMesComp    := IF( Month(dDataRef) + 1 > 12 , 01 , Month(dDataRef) )
Local cTipo       := ""
Local nZebrado    := 0.00
Local nResto  := 0.00 

Private cMailConta    := NIL
Private cMailServer   := NIL
Private cMailSenha    := NIL

lTerminal := IF( lTerminal == NIL .or. ValType( lTerminal ) != "L" , .F. , lTerminal )

IF Esc == 1
  cTipo := "Adiantamento"
ElseIF Esc == 2
  cTipo := "Folha"
ElseIF Esc == 3 
  cTipo := "1a. Parcela do 13o."
ElseIF Esc == 4
  cTipo := "2a. Parcela do 13o."
ElseIF Esc == 5
  cTipo := "Valores Extras"
EndIF             

IF !lTerminal
  
  //��������������������������������������������������������������Ŀ
  //� Busca parametros                                             �
  //����������������������������������������������������������������
  cMailConta  :=If(cMailConta == NIL,GETMV("MV_EMCONTA"),cMailConta)             //Conta utilizada p/envio do email
  cMailServer :=If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer)           //Server 
  cMailSenha  :=If(cMailSenha == NIL,GETMV("MV_EMSENHA"),cMailSenha)
  
  If Empty(cEmail)
      Return
  Endif   
  
  //��������������������������������������������������������������Ŀ
  //� Verifica se existe o SMTP Server                             �
  //����������������������������������������������������������������
  If  Empty(cMailServer)
      Help(" ",1,"SEMSMTP")//"O Servidor de SMTP nao foi configurado !!!" ,"Atencao"
      Return(.F.)
  EndIf
  
  //��������������������������������������������������������������Ŀ
  //� Verifica se existe a CONTA                                   �
  //����������������������������������������������������������������
  If  Empty(cMailServer)
      Help(" ",1,"SEMCONTA")//"A Conta do email nao foi configurado !!!" ,"Atencao"
      Return(.F.)
  EndIf
  
  //��������������������������������������������������������������Ŀ
  //� Verifica se existe a Senha                                   �
  //����������������������������������������������������������������
  If  Empty(cMailServer)
      Help(" ",1,"SEMSENHA")  //"A Senha do email nao foi configurado !!!" ,"Atencao"
      Return(.F.)
  EndIf                                              

EndIF

cHtml +=  '<html>'
cHtml +=  '<head>'
IF !lTerminal
  cHtml +=    '<title>DEMONSTRATIVO DE PAGAMENTO</title>'
  cHtml +=    '<style>'
  cHtml +=    'th { text-align:left; background-color:#4B87C2; line-height:01; line-width:400; border-left:0px solid  #FF9B06; border-right:0px solid #FF9B06; border-bottom:0px solid #FF9B06 ; border-top:0px solid #FF9B06 }'
  cHtml +=    '.tdPrinc { text-align:left; line-height:1; line-width:340 ; border-left:0px solid #FF9B06; border-right:0px solid #FF9B06; border-bottom:0px solid #FF9B06 ; border-top:0px solid #FF9B06 > }'
  cHtml +=    '.td18_94_AlignR { text-align:right ; line-height:1; line-width:94 }'
  cHtml +=    '.td18_95_AlignR { text-align:right ; line-height:1; line-width:95 }'
  cHtml +=    '.td26_94_AlignR { text-align:right ; line-height:1; line-width:94 }'
  cHtml +=    '.td26_95_AlignR { text-align:right ; line-height:1; line-width:95 }'
  cHtml +=    '.td26_18_AlignL { lext-align:left ; line-height:1; line:width:18 ; border-left:0px solid #FF9B06; border-right:0px solid #FF9B06; border-bottom:0px solid #FF9B06 ; border-top:0px solid #FF9B06 bgcolor=#6F9ECE" }'
  cHtml +=    '.pStyle1 { line-height:100% ; margin-top:15 ; margin-bottom:0 }'
  cHtml +=    '</style>'
  cHtml +=    '</head>'
  cHtml +=    '<body bgcolor="#FFFFFF"  topmargin="0" leftmargin="0">'
  cHtml +=    '<center>'
  cHtml +=    '<table  border="1" cellpadding="0" cellspacing="0" bordercolor="#FF9B06" bgcolor="#000082" width=598 height="637">'
  cHtml +=    '<td width="598" height="181" bgcolor="FFFFFF">'
  cHtml +=    '<center>'
  cHtml +=    '<font color="#000000">'
  cHtml +=    '<b>'
  cHtml +=    '<h4 size="03">'
  cHtml +=    '<br>'
  cHtml +=    " DEMONSTRATIVO DE PAGAMENTO "
  cHtml +=    '<br>'
Else
  cHtml += '<title>RH Online</title>' + CRLF
  cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">' + CRLF
  cHtml += '<link rel="stylesheet" href="../rhonline/css/rhonline.css" type="text/css">' + CRLF
  cHtml += '</head>' + CRLF
  cHtml += '<body bgcolor="#FFFFFF" text="#000000">' + CRLF
  cHtml += '<table width="515" border="0" cellspacing="0" cellpadding="0">' + CRLF
  cHtml += '<tr>' + CRLF
  cHtml += '<td class="titulo">' + CRLF
  cHtml += '<p><img src="../rhonline/imagens/icone_titulo.gif" width="7" height="9"> <span class="titulo_opcao">' + Capital( "DEMONSTRATIVO DE PAGAMENTO " ) + '</span><br>' + CRLF //DEMONSTRATIVO DE PAGAMENTO 
  cHtml += '<br>' + CRLF
  cHtml += '</p>' + CRLF
  cHtml += '</td>' + CRLF 
  cHtml += '</tr>' + CRLF
  cHtml += '<tr>' + CRLF
  cHtml += '<td>' + CRLF 
  cHtml += '<p><img src="../rhonline/imagens/tabela_conteudo.gif" width="515" height="12"></p>' + CRLF
  cHtml += '</td>' + CRLF
  cHtml += '</tr>' + CRLF
  cHtml += '<tr>' + CRLF 
  cHtml += '<td>' + CRLF
  cHtml += '<table width="515" border="0" cellspacing="0" cellpadding="0">' + CRLF
  cHtml += '<tr>' + CRLF
  cHtml += '<td background="../rhonline/imagens/tabela_conteudo_1.gif" width="10"> </td>' + CRLF
  cHtml += '<td width="498">' + CRLF
  cHtml += '<table width="498" border="0" cellspacing="0" cellpadding="0">' + CRLF
  cHtml += '<tr>' + CRLF
EndIF    

If !Empty(Semana) .And. Semana # "99" .And.  Upper(SRA->RA_TIPOPGT) == "S" 
  //��������������������������������������������������������������Ŀ
  //� Carrega Datas Referente a semana                             �
  cHtml +=    '<table  border="1" cellpadding="0" cellspacing="0" bordercolor="#FF9B06" bgcolor="#000082" width=598 height="637">'
  cHtml +=    '<td width="598" height="181" bgcolor="FFFFFF">'
  cHtml +=    '<center>'
  cHtml +=    '<font color="#000000">'
  cHtml +=    '<b>'
  cHtml +=    '<h4 size="03">'
  cHtml +=    '<br>'
  cHtml +=    " DEMONSTRATIVO DE PAGAMENTO "
  cHtml +=    '<br>'
Else
  cHtml += '<title>RH Online</title>' + CRLF
  cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">' + CRLF
  cHtml += '<link rel="stylesheet" href="../rhonline/css/rhonline.css" type="text/css">' + CRLF
  cHtml += '</head>' + CRLF
  cHtml += '<body bgcolor="#FFFFFF" text="#000000">' + CRLF
  cHtml += '<table width="515" border="0" cellspacing="0" cellpadding="0">' + CRLF
  cHtml += '<tr>' + CRLF
  cHtml += '<td class="titulo">' + CRLF
  cHtml += '<p><img src="../rhonline/imagens/icone_titulo.gif" width="7" height="9"> <span class="titulo_opcao">' + Capital( "DEMONSTRATIVO DE PAGAMENTO" ) + '</span><br>' + CRLF //DEMONSTRATIVO DE PAGAMENTO 
  cHtml += '<br>' + CRLF
  cHtml += '</p>' + CRLF
  cHtml += '</td>' + CRLF 
  cHtml += '</tr>' + CRLF
  cHtml += '<tr>' + CRLF
  cHtml += '<td>' + CRLF 
  cHtml += '<p><img src="../rhonline/imagens/tabela_conteudo.gif" width="515" height="12"></p>' + CRLF
  cHtml += '</td>' + CRLF
  cHtml += '</tr>' + CRLF
  cHtml += '<tr>' + CRLF 
  cHtml += '<td>' + CRLF
  cHtml += '<table width="515" border="0" cellspacing="0" cellpadding="0">' + CRLF
  cHtml += '<tr>' + CRLF
  cHtml += '<td background="../rhonline/imagens/tabela_conteudo_1.gif" width="10"> </td>' + CRLF
  cHtml += '<td width="498">' + CRLF
  cHtml += '<table width="498" border="0" cellspacing="0" cellpadding="0">' + CRLF
  cHtml += '<tr>' + CRLF
EndIF    

If !Empty(Semana) .And. Semana # "99" .And.  Upper(SRA->RA_TIPOPGT) == "S" 
  //��������������������������������������������������������������Ŀ
  //� Carrega Datas Referente a semana                             �
  //����������������������������������������������������������������
    PerSemana()
  IF !lTerminal
      cHtml += "Semana  " + "(" + cSem_De + ' a ' + cSem_Ate + ")"  
  Else
      cHtml += '<td><span class="dados">' + "Semana " + Semana + " (" + cSem_De + ' Ate ' + cSem_Ate + ")" + '</span></td>' + CRLF
  EndIF   
Else
  IF !lTerminal
      cHtml += MesExtenso(Month(dDataRef))+"/"+STR(YEAR(dDataRef),4) + " - ( " + cTipo + " )"
  Else
      cHtml += '<td><span class="dados">' + MesExtenso(Month(dDataRef))+"/"+STR(YEAR(dDataRef),4) + " - ( " + cTipo + " )" + '</span></td>' + CRLF
  EndIF   
EndIf                     

IF !lTerminal

  cHtml += '</b></h4></font></center>'
  cHtml += '<hr whidth = 100% align=right color="#FF812D">'
  //��������������������������������������������������������������Ŀ
  //� Dados do funcionario                                         �
  //����������������������������������������������������������������
  cHtml += '<!Dados do Funcionario>'
  cHtml += '<p align=left  style="margin-top: 0">'
  cHtml +=   '<font color="#000082" face="Courier New"><i><b>'
  cHtml +=    '   ' + SRA->RA_NOME + "-" + SRA->RA_MAT+'</i><br>'
  cHtml +=    '   ' + "Funcao    - " + SRA->RA_CODFUNC+ "  "+DescFun(SRA->RA_CODFUNC,SRA->RA_FILIAL) +'<br>' //"Funcao    - "
  cHtml +=    '   ' + "C.Custo   - " + SRA->RA_CC + " - " + DescCc(SRA->RA_CC,SRA->RA_FILIAL) +'<br>' //"C.Custo   - "
  cHtml +=    '   ' + "Bco/Conta - " + SRA->RA_BCDEPSAL+"-"+DescBco(SRA->RA_BCDEPSAL,SRA->RA_FILIAL)+ ' '+  SRA->RA_CTDEPSAL //"Bco/Conta - "
  cHtml += '</b></p></font>'
  cHtml += '<!Proventos e Desconto>'
  cHtml += '<div align="center">'
  cHtml += '<Center>'
  cHtml += '<Table bgcolor="#6F9ECE" border="0" cellpadding ="1" cellspacing="0" width="553" height="296">'
  cHtml += '<TBody><Tr>'
  cHtml +=    '<font face="Courier New" size="02" color="#000082"><b>'
  cHtml +=    '<th>' + "Cod  Descricao " + '</th>' //"Cod  Descricao "
  cHtml +=    '<th>' + "Referencia" + '</th>' //"Referencia"
  cHtml +=    '<th>' + "Valores" + '</th>' //"Valores"
  cHtml +=    '</b></font></tr>'
  cHtml += '<font color=#000082 face="Courier new"  size=2">'

  //��������������������������������������������������������������Ŀ
  //� Espacos Entre os Cabecalho e os Proventos/Descontos          �
  //����������������������������������������������������������������
  cHtml +=  '<tr>'
  cHtml +=        '<td class="tdPrinc"></td>'
  cHtml +=        '<td class="td18_94_AlignR">  </td>'
  cHtml +=        '<td class="td18_95_AlignR">  </td>'
  cHtml +=        '<td class="td18_18_AlignL"></td>'
  cHtml +=    '</tr>'
Else
    cHtml += '</tr>' + CRLF
    cHtml += '<tr>' + CRLF
    cHtml += '<td> </td>' + CRLF
    cHtml += '</tr>' + CRLF
    cHtml += '<tr>' + CRLF
    cHtml += '<td>' + CRLF
    cHtml += '<table width="490" border="0" cellspacing="0" cellpadding="0">' + CRLF
    cHtml += '<tr align="center">' + CRLF
    cHtml += '<td width="45" height="16">' + CRLF
    cHtml += '<div align="Left"><span class="etiquetas">'+ "C�digo" + '</span></div>' + CRLF //C�digo
    cHtml += '</td>' + CRLF
    cHtml += '<td width="219" valign="top">' + CRLF
    cHtml += '<div align="left"><span class="etiquetas">' + "Descri��o" + '</span></div>' + CRLF //Descri��o
    cHtml += '</td>' + CRLF
    cHtml += '<td width="127" valign="top">' + CRLF
    cHtml += '<div align="right"><span class="etiquetas">' + "Refer�ncia" + '</span></div>' + CRLF //Refer�ncia
    cHtml += '</td>' + CRLF
    cHtml += '<td width="107" valign="top">' + CRLF
    cHtml += '<div align="right"><span class="etiquetas">' + "Valores" + '</span></div>' + CRLF //Valores
    cHtml += '<td width="107" valign="top">' + CRLF
    cHtml += '<div align="center"><span class="etiquetas"> (+/-) </span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '</tr>' + CRLF
EndIF

//��������������������������������������������������������������Ŀ
//� Proventos                                                    �
//����������������������������������������������������������������
For nProv:=1 to  LEN(aProve)
  nResto := ( ++nZebrado % 2 )
  IF !lTerminal
      cHtml += '<tr>'
      cHtml +=    '<td class="tdPrinc">' + aProve[nProv,1] + '</td>'
      cHtml +=    '<td class="td18_94_AlignR">' + Transform(aProve[nProv,2],'999.99')+'</td>'
      cHtml +=    '<td class="td18_95_AlignR">' + Transform(aProve[nProv,3],'@E 999,999.99') + '</td>'
      cHtml +=    '<td class="td18_18_AlignL"></td>'
      cHtml += '</tr>'
  Else
      cHtml += '<tr>' + CRLF
        IF nResto > 0.00 
          cHtml += '<td width="45" align="center" height="19" bgcolor="#FAFBFC">' 
        Else
          cHtml += '<td width="45" align="center" height="19">' + CRLF
        EndIF 
        cHtml += '<div align="left"><span class="dados">'  + Substr( aProve[nProv,1] , 1 , 3 ) + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
      IF nResto > 0.00         
          cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else  
          cHtml += '<td valign="top">' + CRLF           
        EndIF 
        cHtml += '<div align="Left"><span class="dados">'  + Capital( AllTrim( Substr( aProve[nProv,1] , 4 ) ) ) + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
      IF nResto > 0.00         
          cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else  
          cHtml += '<td valign="top">' + CRLF           
        EndIF 
        cHtml += '<div align="right"><span class="dados">' + Transform(aProve[nProv,2],'999.99') + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
      IF nResto > 0.00         
          cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else  
          cHtml += '<td valign="top">' + CRLF           
        EndIF 
        cHtml += '<div align="right"><span class="dados">' + Transform(aProve[nProv,3],'@E 999,999.99') + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
      IF nResto > 0.00         
          cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else  
          cHtml += '<td valign="top">' + CRLF           
        EndIF 
        cHtml += '<div align="center"><span class="dados"> (+) </span></div>' + CRLF
        cHtml += '</td>' + CRLF
        cHtml += '</tr>' + CRLF
  EndIF
Next nProv            

//��������������������������������������������������������������Ŀ
//� Descontos                                                    �
//����������������������������������������������������������������
For nDesco:=1 to Len(aDesco)
  nResto := ( ++nZebrado % 2 )
  IF !lTerminal
      cHtml += '<tr>'
      cHtml +=    '<td class="tdPrinc">' + aDesco[nDesco,1] + '</td>'
      cHtml +=    '<td class="td18_94_AlignR">' + Transform(aDesco[nDesco,2],'999.99') + '</td>'
      cHtml +=    '<td class="td18_95_AlignR">' + Transform(aDesco[nDesco,3],'@E 999,999.99') + '</td>'
      cHtml +=    '<td class="td18_18_AlignL">-</td>'
      cHtml += '</tr>'
  Else
      cHtml += '<tr>' + CRLF
        IF nResto > 0.00 
          cHtml += '<td width="45" align="center" height="19" bgcolor="#FAFBFC">' 
        Else
          cHtml += '<td width="45" align="center" height="19">' + CRLF
        EndIF 
        cHtml += '<div align="left"><span class="dados">'  + Substr( aDesco[nDesco,1] , 1 , 3 ) + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
      IF nResto > 0.00         
          cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else  
          cHtml += '<td valign="top">' + CRLF           
        EndIF 
        cHtml += '<div align="Left"><span class="dados">'  + Capital( AllTrim( Substr( aDesco[nDesco,1] , 4 ) ) ) + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
          IF nResto > 0.00         
          cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else  
          cHtml += '<td valign="top">' + CRLF           
        EndIF 
        cHtml += '<div align="right"><span class="dados">' + Transform(aDesco[nDesco,2],'999.99') + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
      IF nResto > 0.00         
          cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else  
          cHtml += '<td valign="top">' + CRLF           
        EndIF 
        cHtml += '<div align="right"><span class="dados">' + Transform(aDesco[nDesco,3],'@E 999,999.99') + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
        IF nResto > 0.00         
          cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else  
          cHtml += '<td valign="top">' + CRLF           
        EndIF 
        cHtml += '<div align="center"><span class="dados"> (-) </span></div>' + CRLF
        cHtml += '</td>' + CRLF
        cHtml += '</tr>' + CRLF
  EndIF   
Next nDesco      

IF !lTerminal

  //��������������������������������������������������������������Ŀ
  //� Espacos Entre os Proventos e Descontos e os Totais           �
  //����������������������������������������������������������������
  cHtml +=    '<tr>'
  cHtml +=        '<td class="tdPrinc"></td>'
  cHtml +=        '<td class="td18_94_AlignR">  </td>'
  cHtml +=        '<td class="td18_95_AlignR">  </td>'
  cHtml +=        '<td class="td18_18_AlignL"></td>'
  cHtml +=    '</tr>'
  
  //��������������������������������������������������������������Ŀ
  //� Totais                                                       �
  //����������������������������������������������������������������
  cHtml += '<!Totais >'
  cHtml +=    '<b><i>'
  cHtml +=    '<tr>'
  cHtml +=        '<td class="tdPrinc">' + "Total Bruto " + '</td>' //"Total Bruto "
  cHtml +=        '<td class="td18_94_AlignR"></td>'
  cHtml +=        '<td class="td18_95_AlignR">' + Transform(TOTVENC,"@E 999,999.99") + '</td>'
  cHtml +=        '<td class="td18_18_AlignL"></td>'
  cHtml +=    '</tr>'
  cHtml +=    '<tr>'
  cHtml +=        '<td class="tdPrinc">' + "Total Descontos " + '</td>' //"Total Descontos "
  cHtml +=        '<td class="td18_94_AlignR"></Td>'
  cHtml +=        '<td class="td18_95_AlignR">' + Transform(TOTDESC,"@E 999,999.99") + '</td>'
  cHtml +=        '<td class="td18_18_AlignL">-</td>'
  cHtml +=    '</tr>'
  cHtml +=    '<tr>'
  cHtml +=        '<td class="tdPrinc">' + "Liquido a Receber " + '</td>' //"Liquido a Receber "
  cHtml +=        '<td class="td18_94_AlignR"></td>'
  cHtml +=        '<td align=right height="18" width="95" Style="border-left:0px solid #FF812D; border-right:0px solid #FF9B06; border-bottom:0px solid #FF9B06 ; border-top:1px solid #FF9B06 bgcolor=#4B87C2">'
  cHtml +=        Transform((TOTVENC-TOTDESC),"@E 999,999.99") +'</td>'
  cHtml +=    '</tr>'
  cHtml += '<!Bases>'
  cHtml +=    '<tr>'
Else
  cHtml += '</table><br>' + CRLF
    cHtml += '<table width="490" border="0" cellspacing="0" cellpadding="0">' + CRLF
    cHtml += '<tr align="center">' + CRLF 
    cHtml += '<td width="219" valign="top">' + CRLF 
    cHtml += '<div align="left"><span class="etiquetas"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td width="45" height="16">' + CRLF
    cHtml += '<div align="left"><span class="etiquetas"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td width="127" valign="top">' + CRLF
    cHtml += '<div align="left"><span class="etiquetas"></span></div>' + CRLF
  cHtml += '</td>'
  cHtml += '<td width="107" valign="top">'
  cHtml += '<div align="right"><span class="etiquetas"></span></div>' + CRLF
  cHtml += '</td>'
  cHtml += '<td width="107" valign="top">' 
  cHtml += '<div align="center"><span class="etiquetas"></span></div>' + CRLF
  cHtml += '</td>'
  cHtml += '</td>'
  cHtml += '</tr>'
  cHtml += '<tr>' + CRLF
      cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="left" class="etiquetas"> ' + "Total Bruto: " + '</div>' + CRLF //"Total Bruto: "
    cHtml += '</td>' + CRLF
      cHtml += '<td width="45" align="center" height="19" bgcolor="#FAFBFC">' 
    cHtml += '<div align="left"><span class="dados"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
      cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="right"><span class="dados"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
      cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="right"><span class="dados">' + Transform(TOTVENC,"@E 999,999.99") + '</span></div>' + CRLF
    cHtml += '</td>' + CRLF
      cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="center"><span class="dados"> (+) </span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '</tr>' + CRLF
  
  cHtml += '<tr>' + CRLF
    cHtml += '<td valign="top">' + CRLF 
    cHtml += '<div align="left" class="etiquetas">' + "Total de Descontos: " + '</div>' + CRLF //"Total de Descontos: "
    cHtml += '</td>' + CRLF
    cHtml += '<td width="45" align="center" height="19">' 
    cHtml += '<div align="left"><span class="dados"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td valign="top">' + CRLF 
    cHtml += '<div align="right"><span class="dados"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td valign="top">' + CRLF 
    cHtml += '<div align="right"><span class="dados">' + Transform(TOTDESC,"@E 999,999.99") + '</span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td valign="top">' + CRLF
    cHtml += '<div align="center"><span class="dados"> (-) </span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '</tr>' + CRLF
  
  cHtml += '<tr>' + CRLF
    cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="left" class="etiquetas">' + "L�quido a Receber: " + '</div>' + CRLF //"L�quido a Receber: "
    cHtml += '</td>' + CRLF
    cHtml += '<td width="45" align="center" height="19" bgcolor="#FAFBFC">' 
    cHtml += '<div align="left"><span class="dados"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="right"><span class="dados"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="right"><span class="dados">' + Transform((TOTVENC-TOTDESC),"@E 999,999.99") + '</span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="center"><span class="dados"> (=) </span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '</tr>' + CRLF
    cHtml += '</table>' + CRLF
    cHtml += '<br>' + CRLF
EndIF 

//��������������������������������������������������������������Ŀ
//� Espacos Entre os Totais e as Bases                           �
//����������������������������������������������������������������
IF !lTerminal
  cHtml +=    '<tr>'
  cHtml +=        '<td class="tdPrinc"></td>'
  cHtml +=        '<td class="td18_94_AlignR">  </td>'
  cHtml +=        '<td class="td18_95_AlignR">  </td>'
  cHtml +=        '<td class="td18_18_AlignL"></td>'
  cHtml +=    '</tr>'
Else
  cHtml += '<table width="498" border="0" cellspacing="0" cellpadding="0">' + CRLF
EndIF 

//��������������������������������������������������������������Ŀ
//� Base de Adiantamento                                         �
//����������������������������������������������������������������
If Esc = 1  
  If cBaseAux = "S" .And. nBaseIr # 0
      IF !lTerminal
          cHtml +=    '<tr>'
          cHtml +=        '<td class="tdPrinc"><p class="pStyle1"><font color=#000082 face="Courier new" size=2><i>'+"Base IR Adiantamento"+'</i></p></td></font>' //"Base IR Adiantamento"
          cHtml +=        '<td class="td26_94_AlignR"><p></td>'
          cHtml +=        '<td class="td26_95_AlignR"><p>'+ Transform(nBaseIr,"@E 999,999,999.99")+'</td>'
          cHtml +=        '<td class="td26_18_AlignL"><p></td>'
          cHtml +=    '</tr>'
      Else
          cHtml += '<tr>'
          cHtml += '<td width="304" class="etiquetas">' + "  " + ' + </td>' + CRLF
          cHtml += '<td width="103" class="dados"><div align="center">' + Transform(nBaseIr,"@E 999,999.99") + '</div></td>' + CRLF
          cHtml += '<td width="91"  class="dados"><div align="center">' + Transform(0.00   ,"@E 999,999.99") + '</div></td>' + CRLF
          cHtml += '</tr>'
      EndIF   
    Endif
//��������������������������������������������������������������Ŀ
//� Base de Folha e de 13o 20 Parc.                              �
//����������������������������������������������������������������
ElseIf Esc = 2 .Or. Esc = 4  
  IF cBaseAux = "S"
      IF !lTerminal
          cHtml += '<tr>'
          cHtml +=    '<td class="tdPrinc">'
          cHtml +=    '<p class="pStyle1">'+ "Base FGTS/Valor FGTS" +'</p></td>'//"Base FGTS/Valor FGTS"
          cHtml +=    '<td class="td26_94_AlignR">' + Transform(nBaseFgts,"@E 999,999.99")+'</td>'
          cHtml +=    '<td class="td26_95_AlignR">' + Transform(nFgts    ,"@E 999,999.99")+'</td>'
          cHtml += '</tr>'
          cHtml += '<tr>'
          cHtml +=    '<td class="tdPrinc">'
          cHtml +=    '<p class="pStyle1">'+ "Base IRRF Folha/Ferias" +'</p></td>'//"Base IRRF Folha/Ferias"
          cHtml +=    '<td class="td26_94_AlignR">' + Transform(nBaseIr,"@E 999,999.99")+'</td>'
          cHtml +=    '<td class="td26_95_AlignR">' + Transform(nBaseIrfe,"@E 999,999.99")+'</td>'
          cHtml += '</tr>'
      Else
          cHtml += '<tr>'
          cHtml += '<td width="304" class="etiquetas">' + "Base FGTS/Valor FGTS" + '</td>' + CRLF //"Base FGTS/Valor FGTS"
          cHtml += '<td width="103" class="dados"><div align="center">' + Transform(nBaseFgts,"@E 999,999.99") + '</div></td>' + CRLF
          cHtml += '<td width="91"  class="dados"><div align="center">' + Transform(nFgts    ,"@E 999,999.99") + '</div></td>' + CRLF
          cHtml += '</tr>'
          cHtml += '<tr>'
          cHtml += '<td width="304" class="etiquetas">' + "Base IRRF Folha/Ferias" + '</td>' + CRLF //"Base IRRF Folha/Ferias"
          cHtml += '<td width="103" class="dados"><div align="center">' + Transform(nBaseIr,"@E 999,999.99") + '</div></td>' + CRLF
          cHtml += '<td width="91"  class="dados"><div align="center">' + Transform(nBaseIrFe,"@E 999,999.99") + '</div></td>' + CRLF
          cHtml += '<td width="91"  class="dados"><div align="center">' + Transform(nBaseIrFe,"@E 999,999.99") + '</div></td>' + CRLF
          cHtml += '</tr>'
      EndIF   
  EndIF
//��������������������������������������������������������������Ŀ
//� Bases de FGTS e FGTS Depositado da 1� Parcela                �
//����������������������������������������������������������������
ElseIf Esc = 3  
  If cBaseAux = "S"
      IF !lTerminal
          cHtml +=    '<tr>'
          cHtml +=        '<td class="tdPrinc">' 
          cHtml +=        '<p class="pStyle1">'+ "Base FGTS / Valor FGTS" +'</td>' //"Base FGTS / Valor FGTS"
          cHtml +=        '<td class="td26_94_AlignL">' + Transform(nBaseFgts,"@E 999,999,999.99") +'</td>'
          cHtml +=        '<td class="td26_95_AlignL">' + Transform(nFgts,"@E 99,999,999.99")+'</td>'
          cHtml +=        '<td align=right height="26" width="95"  style="border-left: 0px solid #FF9B06; border-right:0px solid #FF9B06; border-bottom:1px solid #FF9B06 ; border-top: 0px solid #FF9B06 bgcolor=#6F9ECE"></td>'
          cHtml +=    '</tr>'
      Else
          cHtml += '<tr>'
          cHtml += '<td width="304" class="etiquetas">' + "Base FGTS/Valor FGTS" + ' + </td>' + CRLF //"Base FGTS/Valor FGTS"
              cHtml += '<td width="103" class="dados"><div align="center">' + Transform(nBaseFgts,"@E 999,999.99") + '</div></td>' + CRLF
              cHtml += '<td width="91"  class="dados"><div align="center">' + Transform(nFgts    ,"@E 999,999.99") + '</div></td>' + CRLF
            cHtml += '</tr>'
      EndIF
  Endif
Endif
  
IF !lTerminal
  cHtml += '</font></i></b>'
  cHtml += '</TBody>'
  cHtml += '</table>'
  cHtml += '</center>'
  cHtml += '</div>'
  cHtml += '<hr whidth = 100% align=right color="#FF812D">'
  //��������������������������������������������������������������Ŀ
  //� Espaco para Observacoes/mensagens                            �
  //����������������������������������������������������������������
  cHtml += '<!Mensagem>'
  cHtml += '<Table bgColor=#6F9ECE border=0 cellPadding=0 cellSpacing=0 height=100 width=598>'
  cHtml +=    '<TBody>'
  cHtml +=    '<tr>'
  cHtml +=    '<td align=left height=18 width=574 style="border-left:1px solid #FF9B06; border-right:1px solid #FF9B06; border-bottom: 0px solid #FF9B06 ; border-top:1px solid #FF9B06 bgcolor=#6F9ECE"><i><font face="Courier New" size="2" color="#000082">'+DESC_MSG1+ '</font></td></tr>'
  cHtml +=    '<tr>'
  cHtml +=    '<td align=left height=18 width=574 style="border-left:1px solid #FF9B06; border-right:1px solid #FF9B06; border-bottom: 0px solid #FF9B06 ; border-top: 0px solid #FF9B06 bgcolor=#6F9ECE"><i><font face="Courier New" size="2" color="#000082">'+DESC_MSG2+ '</font></td></tr>'
  cHtml +=    '<tr>'
  cHtml +=    '<td align=left height=18 width=574 style="border-left:1px solid #FF9B06; border-right:1px solid #FF9B06; border-bottom:1px solid #FF9B06 ; border-top: 0px solid #FF9B06 bgcolor=#6F9ECE"><i><font face="Courier New" size="2" color="#000082">'+DESC_MSG3+ '</font></td></tr>'
  IF cMesComp == Month(SRA->RA_NASC)
      cHtml += '<TD align=left height=18 width=574 bgcolor="#FFFFFF"><EM><B><CODE>      <font face="Courier New" size="4" color="#000082">'
      cHtml += '<MARQUEE align="middle" bgcolor="#FFFFFF">' + "F E L I Z     A N I V E R S A R I O !!!! " + '</marquee><code></b></font></td></tr>' //"F E L I Z     A N I V E R S A R I O !!!! "
  EndIF
  cHtml += '</TBody>'
  cHtml += '</Table>'
  cHtml += '</table>'
  cHtml += '</body>'
  cHtml += '</html>'
Else
  cHtml += '</table>' + CRLF
  cHtml += '<p> </p>' + CRLF
  cHtml += '</td>' + CRLF
  cHtml += '</tr>' + CRLF
  cHtml += '</table>' + CRLF
  cHtml += '</td>' + CRLF
  cHtml += '<td background="../rhonline/imagens/tabela_conteudo_2.gif" width="7"> </td>' + CRLF
  cHtml += '</tr>' + CRLF
  cHtml += '</table>' + CRLF
  cHtml += '</td>' + CRLF
  cHtml += '</tr>' + CRLF
  cHtml += '<tr>' + CRLF  
  cHtml += '<td><img src="../rhonline/imagens/tabela_conteudo_3.gif" width="515" height="14"></td>' + CRLF
  cHtml += '</tr>' + CRLF  
  cHtml += '</table>' + CRLF
  cHtml += '<p align="right"><a href="javascript:self.print()"><img src="../rhonline/imagens/imprimir.gif" width="90" height="28" hspace="20" border="0"></a></p>' + CRLF
  cHtml += '</body>' + CRLF
  cHtml += '</html>' + CRLF
EndIF

//��������������������������������������������������������������Ŀ
//� Envia e-mail p/funcionario                                   �
//����������������������������������������������������������������
IF !lTerminal
  GPEMail(cSubject,cHtml,cEMail)
EndIF 

Return( IF( lTerminal , cHtml , NIL ) ) 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fImpTeste �Autor  �R.H. - Natie        � Data �  11/29/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Testa impressao de Formulario Teste                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static function fImpTeste(cString,nTipoRel)

//��������������������������������������������������������������Ŀ
//� Descarrega teste de impressao                                � 
//����������������������������������������������������������������
MS_Flush()
fInicia(cString,nTipoRel)

//����������������������������������������������������������������������������������Ŀ
//� Define o Li com a a linha de impress�o correten para n�o saltar linhas no teste  �
//������������������������������������������������������������������������������������
li := _Prow()

If nTipoRel == 2
  cCompac := aDriver[1]
    cNormal := aDriver[2]
  @ LI,00 PSAY &cCompac
Endif 

Pergunte("GPR30A",.T.)
Vez := If(mv_par01 = 1,1,0)


Return Vez

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fInicia   �Autor  �Natie               � Data �  04/12/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inicializa parametros para impressao                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function  fInicia(cString,nTipoRel)

aDriver := LEDriver()

If LastKey() = 27 .Or. nLastKey = 27
  Return  .F. 
Endif 

If nTipoRel# 3
  SetDefault(aReturn,cString)
Endif

If LastKey() = 27 .OR. nLastKey = 27
  Return .F.
Endif

Return .T. 


