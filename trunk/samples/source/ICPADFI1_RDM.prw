#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 24/05/00
#INCLUDE "Average.ch"
/*
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o   � ICPADFI1  � Autor � REGINA H. PEREZ      � Data �  25/05/00  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o� Rdmake padr�o para o programa HOUSE NAO CONTRATADOS          ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe  � No menu : #CPADFI1                                           ���
��������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������Ĵ��
��� Uso     � SIGAEIC                                                      ���
��������������������������������������������������������������������������Ĵ��
��� Cliente � MERCK                                                        ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ICPADFI1()        // incluido pelo assistente de conversao do AP5 IDE em 24/05/00
*-------------------*
LOCAL TB_Campos :={ {"WKHAWB" ,"" ,AVSX3("W6_HAWB",5)     } , ;
                     {"WKDT_EMB","" , "Embarque"  } , ;       
                     {"WKMOEDA", "" , "Moeda"},;
                     {"WKFOBT" ,"", "Fob Total" ,'@E 9,999,999,999.9999'} }

LOCAL TB_Funcoes:={ {"-2", {||(cSV:=SAVESCREEN(),TBF_Pesq(),RESTSCREEN(,,,,cSV))} , "F3:" ,"Busca"  } ,;
                    {"-4", {|| APERelHawb() } , "F5:", "Relatorio" } }

LOCAL T_DBF := { { "WKHAWB"  , "C" , 17 , 0 } , ;
                { "WKDT_EMB", "D" , 08 , 0 } , ;
                { "WKMOEDA", "C",  03,   0},;
                { "WKFOBT"  , "N" , 15 , 4 } }

LOCAL cSaveMenuh, nColIni, oDlg , oPanel ,cTitulo  := OemToAnsi("PROCESSOS NAO CONTRATADOS")

LOCAL aDados :={"Work",;
                cTitulo,; 
                "",; 
                "",;
                "M",;
                132,;
                "",;
                "",;
                "",;
                { "Zebrado", 1,"Importacao", 1, 2, 1, "",1 },;
                "ICPA001",;
                { {||.T.} , {||.T.} }  }
LOCAL nColu := 1
PRIVATE cCadastro:= OemtoAnsi("Processos Nao Contratados")

PRIVATE R_Campos:={}, R_Funcoes

Private aHeader[0],nUsado:=0, cPictTotal:='@E 9,999,999,999,999,999.999'
nOldArea:= SELECT()
WorkFile:=E_Create(T_DBF,.T.)
DBUSEAREA(.T.,,WorkFile,"Work",.F.)

IF ! USED()
   Msg("NAO HA AREA DISPONIVEL PARA ABERTURA DO ARQUIVO TEMPORARIO",20)
   RETURN NIL
ENDIF                        
IndRegua("Work",WorkFile+OrdBagExt(),"WKHAWB",;
         "AllwaysTrue()",;
         "AllwaysTrue()",;
         "Processando Arquivo Temporario...")    
                                                     	
R_Campos:=E_CriaRCampos(TB_Campos,"E",1)

ncont:=0
DO WHILE .T.

  Work->(__DBZAP())
  SW6->(DBSEEK(xFilial("SW6")))
  SW6->(DBEVAL({||nCont++},,{|| W6_FILIAL == xFilial("SW6")}))
  SW6->(DBSEEK(xFilial("SW6")))
  Processa({||ProcRegua(nCont),;
              SW6->(DBEVAL({||IncProc("Processo "+SW6->W6_HAWB),;
                              GravaW()},,{|| W6_FILIAL==xFilial("SW6")} )) },"Processando")

  IF Work->(Bof()) .And. Work->(Eof())
     MsgInfo("N�o h� Registros a serem listados","Informa��o" )
     EXIT
  ENDIF

  aDados[09]:=cCadastro
  aDados[12]:=R_Funcoes
  aDados[05]:='P'
  nTam      :=LEN(cCadastro)

  oMainWnd:ReadClientCoors()
  DEFINE MSDIALOG oDlg TITLE cCadastro;
         FROM oMainWnd:nTop+125,oMainWnd:nLeft+5 TO oMainWnd:nBottom-60,oMainWnd:nRight-10 ;
 	           OF oMainWnd PIXEL  
  @00,00 MsPanel oPanel Prompt " " Size 60,20 of oDlg //LRL 23/04/04 Painel para alinhemento MDI.
  nColu := (oDlg:nClientWidth-4)/2-100
    @4,nColu BUTTON "Gera Arquivo" SIZE 40,11 ACTION (TR350Arquivo("Work")) of oPanel Pixel

  DEFINE SBUTTON FROM 4,(oDlg:nClientWidth-4)/2-50 TYPE 6 ACTION ;
            E_Report(aDados,R_Campos) ENABLE OF oPanel
  Work->(DBGOTOP())
  IF Work->(EOF())
    Help(" ",1,"REGNOIS")
    EXIT
  Endif   
  oMark:= MsSelect():New("Work",,,TB_Campos,.F.,"",{35,1,(oDlg:nHeight-30)/2,(oDlg:nClientWidth-4)/2})
  nOpcA:=0

  ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||nOpcA:=0,oDlg:End()},{||oDlg:End()}),;
    oPanel:Align:=CONTROL_ALIGN_TOP, oMark:oBrowse:Align:=CONTROL_ALIGN_ALLCLIENT) //LRL 23/04/04 - Alinhamento MDI

  If nOpcA = 0 
     Exit
  Endif

ENDDO

Work->(E_EraseArq(WorkFile))
DBSELECTAREA(nOldArea)

Return(.T.)        // incluido pelo assistente de conversao do AP5 IDE em 22/11/99

*-------------------*
// Substituido pelo assistente de conversao do AP5 IDE em 24/05/00 ==> STATIC FUNCTION GravaW()
Static FUNCTION GravaW()
*-------------------*
LOCAL cHawbDI:="",Cont:=0,cCondPa,nDias,nFOB,cMoeda,I

SW9->(DBSETORDER(3))//W9_FILIAL+W9_HAWB
SW6->(DBSEEK(xFilial("SW6")))
nTotRec:=SW6->(LASTREC())

WHILE ! SW6->(EOF()) .AND. SW6->W6_FILIAL == xFilial("SW6")

   Incproc(++Cont,nTotRec)
   
   IF cHawbDI==SW6->W6_HAWB .OR. SWB->(DBSEEK(xFilial("SWB")+SW6->W6_HAWB))
      SW6->(DBSKIP())
      LOOP
   ENDIF
   
   cHawbDI := SW6->W6_HAWB
            
   IF !EMPTY(SW6->W6_COND_PA)
      cCondPa := SW6->W6_COND_PA
      nDias   := SW6->W6_DIAS_PA
   ELSE
      SW7->(DBSEEK(xFILIAL("SW7")+SW6->W6_HAWB))
      IF SW4->(DBSEEK(xFILIAL("SW4")+SW7->W7_PGI_NUM)) .AND. !EMPTY(SW4->W4_COND_PA)
         cCondPa := SW4->W4_COND_PA
         nDias   := SW4->W4_DIAS_PA
      ELSEIF SW2->(DBSEEK(xFILIAL("SW2")+SW7->W7_PO_NUM)).AND. !EMPTY(SW2->W2_COND_PA)
         cCondPa := SW2->W2_COND_PA
         nDias   := SW2->W2_DIAS_PA
      ENDIF
   ENDIF
   
   nFOB := 0
      
   IF SY6->(DBSEEK(xFILIAL("SY6")+cCondPa+STR(nDias,3,0)))
      IF SY6->Y6_DIAS_PA == 901
         FOR I:= 1 TO 10 //Para apurar as Parcelas da Condic�o de Pagto.
            _Dias:= "Y6_DIAS_" + STRZERO(I,2) 
            _Perc:= "Y6_PERC_" + STRZERO(I,2)
            _Dias:= SY6->(FIELDGET( FIELDPOS(_Dias) ))
            _Perc:= SY6->(FIELDGET( FIELDPOS(_Perc) ))/ 100
            IF _Dias > 0
               nFoB += SW6->W6_FOB_TOT * _Perc
            ENDIF
         NEXT
      ELSE
         nFOB := SW6->W6_FOB_TOT
      ENDIF
   ENDIF
   
   cMoeda:=""   
   IF nFOB > 0
      IF SW9->(DBSEEK(xFilial()+SW6->W6_HAWB))
         cMoeda:=SW9->W9_MOE_FOB
      ELSEIF  SW7->(DBSEEK(xFILIAL("SW7")+SW6->W6_HAWB)) .AND. ;
              SW2->(DBSEEK(xFILIAL("SW2")+SW7->W7_PO_NUM))
         cMoeda:=SW2->W2_MOEDA
      ENDIF         
         
      Work->(DBAPPEND())
      Work->WKHAWB   := SW6->W6_HAWB
      Work->WKDT_EMB := SW6->W6_DT_EMB
      Work->WKMOEDA  := cMoeda
      Work->WKFOBT   := nFOB
   ENDIF
   
   
   SW6->(DBSKIP())

END
RETURN

SW9->(DBSETORDER(1))
Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 24/05/00

