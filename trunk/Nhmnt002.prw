#Include "mntr675.ch"
#Include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MNTR675  � Autor � NG Informatica        � Data �   /06/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ordem de Servico de Manutencao  (REFEITO 07/08/02 - In�cio)���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
User Function Nhmnt002()
Local cString := "STJ"
Local cdesc1  := STR0001 //"Emissao de Ordem de Servico de Manutencao. O Usuario pode selecionar"
Local cdesc2  := STR0002 //"quais os campos que deverao ser mostrados na O.S., bem como informar"
Local cdesc3  := STR0003 //"parametros de selecao para a impressao."
Local wnrel   := "NHMNT002"
Local _aMat := {}
Local _x := 1

//Private aReturn  := { STR0004, 1,STR0005, 2, 2, 1, "",1 } //"Zebrado"###"Administracao"
Private aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
Private nLastKey := 0
Private cPerg    := "MNT002"
Private Titulo   := STR0006 //"Ordem De Servico De Manutencao"
Private Tamanho  := "P"
Private lRodape := .F.
Private li := 80 ,m_pag := 1
Private nomeprog := "NHMNT002"
Private ntipo   // := IIF(aReturn[4]==1,15,18)
//Private nTipo    := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))


/*
  ��������������������������������������������������������������Ŀ
  � Variaveis utilizadas para parametros                         �
  � mv_par01     // Numero do Plano de Manutencao                �
  � mv_par02     // Lista Descricao do Bem   S/N                 �
  � mv_par03     // Lista Detalhes do Bem    S/N                 �
  � mv_par04     // Lista Descricao Manut.   S/N                 �
  � mv_par05     // Lista Descricao Etapas   S/N                 �
  � mv_par06     // De  Centro de Custo                          �
  � mv_par07     // Ate Centro de Custo                          �
  � mv_par08     // De  Centro de Trabalho                       �
  � mv_par09     // Ate Centro de Trabalho                       �
  � mv_par10     // De  Area de Manutencao                       �
  � mv_par11     // Ate Area de Manutencao                       �
  � mv_par12     // De  Ordem de Servico                         �
  � mv_par13     // Ate Ordem de Servico                         �
  � mv_par14     // De  Data de Manutencao                       �
  � mv_par15     // Ate Data de manutencao                       �
  � mv_par16     // Classificacao (Ordem/Plano, Plano/Ordem,     |
  �                                Servico/Bem, Centro Custos,   |
  |                                Data da O.S,                  |
  � mv_par17     // Lista descr. da O.S  (Nao, Sim)              �
  ����������������������������������������������������������������
*/ 

//TRECHO ABAIXO COMENTADO POR FELIPE 23/09/2008 MIGRACAO AP10
/*
DbSelectArea("SX1")
DbSetOrder(1)
If !Dbseek("MNT675"+"17")
   RecLock("SX1",.T.)
   SX1->X1_GRUPO   := "MNT675"
   SX1->X1_ORDEM   := "17"
   SX1->X1_PERGUNT := "Lista descr. da O.S?"
   SX1->X1_VARIAVL := "mv_chh"
   SX1->X1_TIPO    := "N"
   SX1->X1_TAMANHO := 01
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "naovazio()"
   SX1->X1_DEF01   := "Nao"
   SX1->X1_DEF02   := "Sim"
   SX1->X1_VAR01   := "mv_par17"
   MsUnLock("SX1")
Endif
If DbSeek("MNT675"+"17")
   If ALLTRIM(SX1->X1_VARIAVL) <> "mv_chh"
      RECLOCK("SX1",.F.) 
      SX1->X1_VARIAVL := "mv_chh"
      MSUNLOCK("SX1")              
   EndIf
EndIf 
*/
If UPPER(FUNNAME())$"MNTC730()"
//	wnrel:=SetPrint(cString,wnrel,.F.,titulo,cDesc1,cDesc2,cDesc3,.t.,"") 
ELSE
	Pergunte(cPerg,.F.)
//	wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.t.,"") 
	wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho)
ENDIF

If UPPER(FUNNAME())$"MNTC730()"
    aAdd(_aMat,{ STJ->TJ_PLANO,;
    			1,1,1,1,;
    			STJ->TJ_CCUSTO,;
    			STJ->TJ_CCUSTO,;
    			STJ->TJ_CENTRAB,;
    			STJ->TJ_CENTRAB,;
    			STJ->TJ_CODAREA,;
    			STJ->TJ_CODAREA,;
    			STJ->TJ_ORDEM,;	
    			STJ->TJ_ORDEM,;
    			DtoS(STJ->TJ_DTMPINI),;
    			DtoS(STJ->TJ_DTMPINI),;
    			1,2,2,2})	
	
	mv_par01 := _aMat[1][1]         
	mv_par02 := _aMat[1][2]
	mv_par03 := _aMat[1][3]	
	mv_par04 := _aMat[1][4]	
	mv_par05 := _aMat[1][5]	
	mv_par06 := _aMat[1][6]	
	mv_par07 := _aMat[1][7]	
	mv_par08 := _aMat[1][8]	
	mv_par09 := _aMat[1][9]	
	mv_par10 := _aMat[1][10]	
	mv_par11 := _aMat[1][11]         
	mv_par12 := _aMat[1][12]
	mv_par13 := _aMat[1][13]	
	mv_par14 := _aMat[1][14]	
	mv_par15 := _aMat[1][15]	
	mv_par16 := _aMat[1][16]	
	mv_par17 := _aMat[1][17]	
	mv_par18 := _aMat[1][18]	
	mv_par19 := _aMat[1][19]		

ENDIF

If nLastKey == 27
   Set Filter To
   DbSelectArea("STI")
   Return
EndIf

SetDefault(aReturn,cString) 

ntipo := IIF(aReturn[4]==1,15,18)

RptStatus({|| R675Imp()},"Imprimindo...")

RetIndex("SA1")
Set Filter To
Set device to Screen

If aReturn[5] = 1
   Set Printer To
//   dbCommitAll()
	COMMIT
   OurSpool(wnrel)
Endif
MS_FLUSH()

DbSelectArea("STI")
Return NIL

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R675Imp  � Autor � Waldemiro L. Lustosa  � Data � 13.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relat�rio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MNTR675                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function R675Imp()
Local cRodaTxt  := ""
Local nCntImpr  := 0
Local cCONDICAO, cFiltro
Local nInsumo := 0
Local lCabProd := .T.

If UPPER(FUNNAME())$"MNTC730()"
	cCondicao := ".T."
Else
	cCondicao := ''; //stj->tj_situaca == "L" .And. ';
                +'stj->tj_ccusto >= MV_PAR06 .And. stj->tj_ccusto <= MV_PAR07 .And. ';
                +'stj->tj_centrab >= MV_PAR08 .And. stj->tj_centrab <= MV_PAR09 .And. ';
                +'stj->tj_ordem >= MV_PAR12 .And. stj->tj_ordem <= MV_PAR13 .And. ';
                +'stj->tj_dtORIGI >= MV_PAR14 .And. stj->tj_dtORIGi <= MV_PAR15'
                
 	IF MV_PAR24 == 1 //ABERTAS
 		cCondicao += ".And. stj->tj_termino = 'N'"
 	ELSEIF MV_PAR24 == 2 //ENCERRADAS
 		cCondicao += ".And. stj->tj_termino = 'S'"
 	ENDIF
 	
EndIf

Store " " To Cabec1,Cabec2

DbSelectArea("STI")
DbSetOrder(01)
DbSeek(xFilial('STI')+MV_PAR01)
DbSelectArea("STJ")
DbSetOrder(03)
DbSeek(xFilial('STJ')+MV_PAR01)
SetRegua(RECCOUNT())

If !(UPPER(FUNNAME())$"MNTC730()")
	cFiltro := "STJ->TJ_ORDEM >= MV_PAR12 .AND. STJ->TJ_ORDEM <= MV_PAR13"
ENDIF

set filter to &cFiltro

While !Eof() .And. STJ->TJ_FILIAL == xFilial('STJ') .And. STJ->TJ_PLANO = MV_PAR01
   
   	IncRegua()
      
   	IF STJ->TJ_ORDEM   < MV_PAR12 .OR. STJ->TJ_ORDEM   > MV_PAR13 .OR.; //FILTRA POR NUMERO DA OS.
       STJ->TJ_CODBEM  < MV_PAR20 .OR. STJ->TJ_CODBEM  > MV_PAR21 .OR.; //FILTRA POR BEM
       STJ->TJ_SERVICO < MV_PAR22 .OR. STJ->TJ_SERVICO > MV_PAR23       //FILTRA POR SERVICO
      
   		STJ->(DBSKIP())
   		LOOP

   	ENDIF

   	If &(cCONDICAO)
   		
		If !UPPER(FUNNAME())$"MNTC730()"
	      	DbSelectArea("STF")
    	  	DbSetOrder(01) //FILIAL + SERVICO + CODBEM
	      	DbSeek(xFilial('STF')+STJ->TJ_CODBEM+STJ->TJ_SERVICO+STR(STJ->TJ_SEQUENC,3))
	      	If STF->TF_CODAREA < MV_PAR10 .OR. STF->TF_CODAREA > MV_PAR11
	         	DbSelectArea("STJ")
	         	DbSkip()
	         	Loop
	      	EndIf 
	  	 ELSE
	 		DbSelectArea("STJ")	
	 		IF STJ->TJ_ORDEM < MV_PAR12 .OR. STJ->TJ_ORDEM > MV_PAR13
		 		DBSKIP()
		 		LOOP
		 	ENDIF
   		ENDIF

      	Cabecalho()
      	@ Li,000 Psay STR0008 //"|------------------------------------Bem---------------------------------------|"
      	Somalinha()
      	@ Li,000 Psay "|Ident....:"
      	@ Li,012 Psay STJ->TJ_CODBEM
      	@ Li,029 Psay NGSEEK('ST9',STJ->TJ_CODBEM,1,'ST9->T9_NOME') Picture "@!S(39)"
      	@ Li,069 Psay STR0009 //"Prior:"
      	@ Li,076 Psay NGSEEK('ST9',STJ->TJ_CODBEM,1,'ST9->T9_PRIORID')
      	@ Li,079 Psay "|"
      
      	// Verifica se o Bem tem Bem Pai
      	DbSelectArea("STC")
      	DbSetOrder(03)
      	cChave := STJ->TJ_CODBEM
      	While .T.
         	DbSeek(xFilial('STC')+cChave)
         	If found()
            	cChave := STC->TC_CODBEM
            	Dbskip()
            	Loop
         	EndIf
         	Exit
      	End

      	nAtual  := ST9->(Recno())

      	If STJ->TJ_CODBEM != cChave
         	SomaLinha()
         	@ Li,000 Psay STR0010 //"|Pai......:"
         	@ Li,012 Psay cChave
         	@ Li,029 Psay NGSEEK('ST9',cChave,1,'ST9->T9_NOME') Picture "@!S(39)"
         	@ Li,079 Psay "|"
      	EndIf

      	DbGoTo(nAtual)

      	// Linha do Centro de Custo
      	SomaLinha()
      	@ Li,000 Psay STR0011 //"|C.Custo..:"
      	@ Li,012 Psay STJ->TJ_CCUSTO
      	@ Li,022 Psay NGSEEK('SI3',STJ->TJ_CCUSTO,1,'SI3->I3_DESC')
      	@ Li,079 Psay "|"
      
      	// Linha do Centro de Trabalho
      	SomaLinha()
      	@ Li,000 Psay STR0012 //"|C.Trab...:"
      	@ Li,012 Psay STJ->TJ_CENTRAB
      	@ Li,022 Psay NGSEEK('SHB',STJ->TJ_CENTRAB,1,'SHB->HB_NOME')
      	@ Li,079 Psay "|"
     
     	// Impressao da Linha de Detalhes
      	If mv_par03 = 1
         	lPrimeiro := .F.
         	DbSelectArea("STB")
         	DbSetOrder(01)
         	DbSeek(xFilial('STB')+ST9->T9_CODBEM)
         	While !EOF() .AND. STB->TB_CODBEM = ST9->T9_CODBEM  .And.;
            	STB->TB_FILIAL == xFilial('STB')
              
            	SomaLinha()
            	@ Li,000 Psay "|"
            	If !lPrimeiro
            		@ Li,001 Psay STR0013 //"Detalhes.:"
            	Endif
            	lPrimeiro = .T.
            	@ Li,012 Psay Substr(NGSEEK('TPR',STB->TB_CARACTE,1,'TPR->TPR_NOME'),1,25)
            	@ Li,043 Psay STB->TB_DETALHE
            	@ Li,061 Psay STB->TB_UNIDADE
            	@ Li,079 Psay "|"
            	DbSelectArea("STB")
            	DbSkip()
         	End
      	EndIf

      	// Impressao da Linha de Descricao
	    If mv_par02 = 1
	    	NGMEMOR675(STR0014,ST9->T9_DESCRIC,12,56,.T.)
	    EndIf
	      
	    SomaLinha()
	    @ Li,000 Psay STR0015 //"|---------------------------------Manutencao-----------------------------------|"
	      
	    // Linha do Servico
    	SomaLinha()
	    @ Li,000 Psay STR0016 //"|Servico..:"
	    @ Li,012 Psay STJ->TJ_SERVICO
	    If ALLTRIM(STJ->TJ_SERVICO)$"000007/000010/000011/000012/000023/000024"
	    	lRodape := .T.
      	EndIf
      	@ Li,020 Psay NGSEEK('ST4',STJ->TJ_SERVICO,1,'ST4->T4_NOME')
      	@ Li,058 Psay STR0017 //"Man.Ant.:"
      	@ Li,068 Psay STF->TF_DTULTMA Picture '99/99/99'
      	@ Li,080 Psay "|"
 
      	SomaLinha()
      	@ Li,000 Psay STR0018 //"|Sequencia:"
      	@ Li,012 Psay STJ->TJ_SEQUENC  Picture "@E 999"
      	@ Li,018 Psay STR0019 //"Nome Manut..:"
      	@ Li,032 Psay STF->TF_NOMEMAN
      	@ Li,079 Psay "|"

      	// Linha da Area de Manutencao
      	SomaLinha()
      	@ Li,000 Psay STR0020 //"|Area.....:"
      	@ Li,012 Psay STF->TF_CODAREA
      	@ Li,020 Psay NGSEEK('STD',STJ->TJ_CODAREA,1,'STD->TD_NOME')
      	If STF->TF_TIPACOM = "C" .OR. STF->TF_TIPACOM = "A" .OR. STF->TF_TIPACOM = "F"
         	@ Li,061 Psay STR0021 //"Contador:"
         	@ Li,071 Psay STF->TF_CONMANU Picture "@E 999999"
      	EndIf
      	@ Li,079 Psay "|"

      	// Linha de Tipo de Manutencao
      	SomaLinha()
      	@ Li,000 Psay STR0022 //"|Tipo.....:"
      	@ Li,012 Psay STF->TF_TIPO
      	@ Li,020 Psay NGSEEK('STE',STF->TF_TIPO,1,'STE->TE_NOME')
      	@ Li,079 Psay "|"
      
      	// linha de informacao das paradas necessarias
      	/*
      	@ Li,000 Psay STR0023 //"|Parada...: Antes:"
      	@ Li,019 Psay STF->TF_TEPAANT Picture "@E 999"
      	@ Li,023 Psay STF->TF_UNPAANT
      	@ Li,025 Psay STJ->TJ_DTPPINI
      	@ Li,036 Psay STJ->TJ_HOPPINI
      	@ Li,046 Psay STR0024 //"Depois:"
      	@ Li,054 Psay STF->TF_TEPADEP Picture "@E 999"
      	@ Li,058 Psay STF->TF_UNPADEP
      	@ Li,060 Psay STJ->TJ_DTPPFIM
      	@ Li,071 Psay STJ->TJ_HOPPFIM
      	@ Li,079 Psay "|"
      	*/
      
      	// Linha da descricao da manutencao
      	If mv_par04 == 1
      		NGMEMOR675(STR0014,STF->TF_DESCRIC,12,56,.T.)
      	EndIf

      	aARETAPAS := {}
      	DbSelectArea("STQ")
      	DbSetOrder(01)
      	DbSeek(XFILIAL('STQ')+STJ->TJ_ORDEM+STJ->TJ_PLANO)
      	While !Eof() .And. STQ->TQ_ORDEM == STJ->TJ_ORDEM .And.;
         	STQ->TQ_PLANO == STJ->TJ_PLANO
         	Aadd(aARETAPAS,{stq->tq_tarefa,stq->tq_etapa})
         	DbSkip()
      	End

      	aARTAREFAS := {}
      	DbSelectArea("STL")
      	DbSetOrder(03)
      	DbSeek(XFILIAL('STL')+STJ->TJ_ORDEM+STJ->TJ_PLANO+STR(0,2))
      	While !Eof() .And. STL->TL_FILIAL == STJ->TJ_FILIAL .And.;
         	STJ->TJ_ORDEM == STL->TL_ORDEM .And. STJ->TJ_PLANO == STL->TL_PLANO;
         	.And. STL->TL_SEQUENC == 0
         	nPOS := Ascan(aARTAREFAS,{|x| x[1] == stl->tl_tarefa})
         	If nPOS = 0
            	Aadd(aARTAREFAS,{stl->tl_tarefa,stl->tl_dtinici,stl->tl_hoinici,;
                             stl->tl_dtfim,stl->tl_hofim})
         	Else
            	If stl->tl_dtinici < aARTAREFAS[nPOS][2]
               		aARTAREFAS[nPOS][2] := stl->tl_dtinici
               		aARTAREFAS[nPOS][3] := stl->tl_hoinici
            	ElseIf stl->tl_dtinici == aARTAREFAS[nPOS][2] .And. stl->tl_hoinici < aARTAREFAS[nPOS][3]
               		aARTAREFAS[nPOS][3] := stl->tl_hoinici
           	 	EndIf

            	If STL->TL_DTFIM > aARTAREFAS[nPOS][4]
               		aARTAREFAS[nPOS][4] := stl->tl_dtfim
               		aARTAREFAS[nPOS][5] := stl->tl_hofim
            	ElseIf stl->tl_dtfim == aARTAREFAS[nPOS][4] .And. stl->tl_hofim > aARTAREFAS[nPOS][5]
               		aARTAREFAS[nPOS][5] := stl->tl_hofim
            	EndIf
         	Endif
         	DbSelectArea("STL")
         	Dbskip()
      	End

      	For xk := 1 To Len(aARTAREFAS)
         	Somalinha()
         	@ Li,000 Psay STR0025 //"|----------------------------------Tarefa--------------------------------------|"
	        Somalinha()
	        @ Li,000 Psay STR0026 //"|Codigo:"
	        @ Li,009 Psay aARTAREFAS[xk][1]    Picture "@!"
	        @ Li,017 Psay STR0027 //"Previsao Inicio..:"
	        @ Li,035 Psay aARTAREFAS[xk][2]    Picture '99/99/99'
	        @ Li,045 Psay aARTAREFAS[xk][3]    Picture '99:99'
	        @ Li,055 Psay STR0028  //"Fim..:"
	        @ Li,061 Psay aARTAREFAS[xk][4]    Picture '99/99/99'
	        @ Li,071 Psay aARTAREFAS[xk][5]    Picture '99:99'
	        @ Li,079 Psay "|"
	        Somalinha()
	        @ Li,000 Psay "|"
	        @ Li,017 Psay STR0029 //"Real     Inicio..:"
	        @ Li,055 Psay STR0028 //"Fim..:"
	        @ Li,079 Psay "|"
	
         	If Val(aARTAREFAS[xk][1]) == 0
            	Somalinha()
            	@ Li,000 Psay "|"
            	@ Li,001 Psay STR0030 //"Sem Especificacao De Tarefa"
            	@ Li,079 Psay "|"
         	Else
            	Somalinha()
            	@ Li,000 Psay "|"
            	@ Li,002 Psay NGSEEK('ST5',STJ->TJ_CODBEM+STJ->TJ_SERVICO+STR(STJ->TJ_SEQUENC,3)+aARTAREFAS[xk][1],;
                                  1,'ST5->T5_DESCRIC') Picture "!@"
            	@ Li,079 Psay "|"
         	EndIf

         	If MV_PAR05 == 1      // mostra etapas da tarefa
            	DbSelectArea("STQ")
            	DbSetOrder(01)
            	DbSeek(XFILIAL('STQ')+STJ->TJ_ORDEM+STJ->TJ_PLANO+aARTAREFAS[xk][1])
            	If Found()
               		Somalinha()
               		@ Li,000 Psay STR0031 //"|   -------------------------------Etapas-----------------------------------   |"
            	EndIf

            	While !Eof() .AND. STQ->TQ_ORDEM == STJ->TJ_ORDEM .And.;
               		STQ->TQ_PLANO == STJ->TJ_PLANO .And.;
               		STQ->TQ_TAREFA == aARTAREFAS[xk][1]

               		NGIMPETAPA(stq->tq_ok,stq->tq_etapa)

               		// Deletar as etapas da array aARETAPAS
               		nPOS2 := Ascan(aARETAPAS,{|x| x[1] == stq->tq_tarefa .And. x[2] == stq->tq_etapa})
               		If nPOS2 > 0
                  		Adel(aARETAPAS,nPOS2)
                  		Asize(aARETAPAS,Len(aARETAPAS)-1)
               		Endif
               		DbSelectArea("STQ")
               		DbSkip()
            	End
         	EndIf

//         	Somalinha()
//         	@ Li,000 Psay "|"
//         	@ Li,079 Psay "|"
         	Somalinha()
         	@ Li,000 Psay STR0032 //"|   -------------------------------Insumos----------------------------------   |"
         	Somalinha()
         	@ Li,000 Psay STR0033 //"|Nome     Codigo         Descricao                                             |"
         	Somalinha()
         	@ Li,000 Psay STR0034 //"|                      Dt.Prev.  hora    Qtd  Consumo  Uni  Qtd  Consumo  Uni  |"

         	DbSelectArea("STL")
         	DbSetOrder(03)
         	DbSeek(XFILIAL('STL')+STJ->TJ_ORDEM+STJ->TJ_PLANO+STR(0,2)+aARTAREFAS[xk][1])
         	While !Eof() .And. STL->TL_FILIAL == STJ->TJ_FILIAL .And.;
            	STJ->TJ_ORDEM == STL->TL_ORDEM .And. STJ->TJ_PLANO == STL->TL_PLANO;
            	.And. STL->TL_SEQUENC == 0 .And. STL->TL_TAREFA == aARTAREFAS[xk][1]

            	Somalinha()
            	@ Li,000 Psay "|"
            	aTIPNOM := NGNOMINSUM(stl->tl_tiporeg,stl->tl_codigo,30)
            	If Len(aTIPNOM) > 0
               		@ Li,001 Psay Substr(aTIPNOM[1][1],1,4)
            	Endif

            	@ Li,006 Psay stl->tl_codigo Picture '@!'
            	If Len(aTIPNOM) > 0
               		@ Li,021 Psay aTIPNOM[1][2]
            	Endif
            		@ Li,079 Psay "|"
            		Somalinha()
           	 		@ Li,000 Psay "|"
            		@ Li,021 Psay STL->TL_DTINICI Picture '99/99/99'
            		@ Li,031 Psay STL->TL_HOINICI Picture '99:99'
            		@ Li,039 Psay STL->TL_QUANREC Picture '999'
           	 		@ Li,043 Psay STL->TL_QUANTID Picture '@E 999999.99'
            		@ Li,054 Psay STL->TL_UNIDADE
            		@ Li,079 Psay "|"
            		DbSelectArea("STL")
           	 	DbSkip()
         	End
      	Next xk
      
      	// Imprime as etapas nao relacionadas com insumos
      	If MV_PAR05 == 1      // mostra etapas da tarefa
         	If Len(aARETAPAS) > 0
            	Somalinha()
  //	            @ Li,000 Psay "|"
//	            @ Li,079 Psay "|"
//	            Somalinha()
	            @ Li,000 Psay STR0050
	            aARCLASS := Asort(aARETAPAS,,,{|x,y| x[1]+x[2] < y[1]+y[2]})
	            //aARCLASS := Asort(aARETAPAS,,,{|x,y| x[1] < y[1]})
	            cAUXTAR  := 'XXXXXX'
	            For xz := 1 To Len(aARCLASS)
	            	If cAUXTAR <> aARCLASS[xz][1]
                  		Somalinha()
                  		@ Li,000 Psay "|"
  	 	                @ Li,001 Psay STR0051
         		        @ Li,008 Psay aARCLASS[xz][1]

                  		ST5->(DBSETORDER(1))//T5_FILIAL+T5_CODBEM+T5_SERVICO+T5_SEQRELA+T5_TAREFA
				  		ST5->(DbSeek(xFilial("ST5")+STJ->TJ_CODBEM+STJ->TJ_SERVICO+STJ->TJ_SEQRELA+aARCLASS[xz][1]))	
				  		If ST5->(Found())
	                  		@ Li,015 Psay ST5->T5_DESCRIC
	              		Else
		              		@ Li,015 Psay STR0030
	              		EndIf

                  		@ Li,079 Psay "|"
               		Endif
               		cAUXTAR := aARCLASS[xz][1]
               		NGIMPETAPA("  ",aARCLASS[xz][2])
            	Next xz
         	Endif
      	Endif
      	
      	// Impressao da Linha de Descricao da O.S
      	If mv_par17 = 2  
         	Somalinha()
//         	@ Li,000 Psay "|"
//         	@ Li,079 Psay "|"
//         	Somalinha()                            			
         	@ Li,000 Psay "|------------------------------------------------------------------------------|"
         	NGMEMOR675(STR0052,STJ->TJ_OBSERVA,19,58,.T.)  //"Descricao da O.S:"
      	EndIf
     
//      	Somalinha()
//      	@ Li,000 Psay "|"
//      	@ Li,079 Psay "|"
      	SomaLinha()
//      @ Li,000 Psay STR0040 //"|-------------------------------Orcamento Previsto-----------------------------|"
        
		IF SM0->M0_CODIGO == "NH"  //empresa USINAGEM

			If lRodape
	      		@ Li,000 Psay "|---------------------------- ORCAMENTO PREVISTO ------------------------------|"
	      		SomaLinha()
		  		@ Li,000 Psay "|     TIPO                         QTD                          CUSTO          |"
	      		SomaLinha()
	      		@ Li,000 Psay "|                                                                              | "
	      		SomaLinha()
	      		@ Li,000 Psay "| M.O ELETRICISTA           __________________            __________________   |" 
	      		SomaLinha()
	      		@ Li,000 Psay "|                                                                              |"
	      		SomaLinha()
	      		@ Li,000 Psay "| M.O AJUDANTE              __________________            __________________   |" 
	      		SomaLinha()
	      		@ Li,000 Psay "|                                                                              |" 
	      		SomaLinha()      
	      		@ Li,000 Psay "| MATERIAIS                 __________________            __________________   |"
	      		SomaLinha()      
	      		@ Li,000 Psay "|                                                                              |" 
	      		SomaLinha()      
	      		@ Li,000 Psay "| TOTAL                     __________________            __________________   |"
	      		SomaLinha()      
	      		@ Li,000 Psay "|                                                                              |"
	      		SomaLinha()      
	      		@ Li,000 Psay "| Data de Execu��o :  ____/____/____                                           |"
	      		SomaLinha()      
	      		@ Li,000 Psay "|------------------------------- OR�AMENTO REAL -------------------------------|"
	      		SomaLinha()
		  		@ Li,000 Psay "|     TIPO                         QTD                          CUSTO          |"
	      		SomaLinha()
	      		@ Li,000 Psay "|                                                                              | " 
	      		SomaLinha()      
	      		@ Li,000 Psay "| M.O ELETRICISTA           __________________            __________________   |" 
	      		SomaLinha()      
	      		@ Li,000 Psay "|                                                                              |" 
	      		SomaLinha()      
	      		@ Li,000 Psay "| M.O AJUDANTE              __________________            __________________   |" 
	      		SomaLinha()
	      		@ Li,000 Psay "|                                                                              |" 
	      		SomaLinha()      
	      		@ Li,000 Psay "| MATERIAIS                 __________________            __________________   |"
	      		SomaLinha()      
	      		@ Li,000 Psay "|                                                                              |" 
	      		SomaLinha()      
	      		@ Li,000 Psay "| TOTAL                     __________________            __________________   |"
	      		SomaLinha()      
	      		@ Li,000 Psay "|                                                                              |"
	      		SomaLinha()      
	      		@ Li,000 Psay "| Data de Execu��o :  ____/____/____                                           |"
	      		SomaLinha()
			EndIf


      		@ Li,000 Psay "|--------------------------------- APROVACOES ---------------------------------|"
      		SomaLinha()
     		@ Li,000 Psay "|                                                                              |"
      		SomaLinha() 
      		@ Li,000 Psay "|                                                                              |" 
      		SomaLinha()      
      		@ Li,000 Psay "|___________________________                           ________________________|"
      		SomaLinha()      
      		@ Li,000 Psay "|  RESPONS�VEL PELO SETOR                                 ENTREGA DO SERVI�O   |"
      		SomaLinha() 
      		@ Li,000 Psay "|                                                                              |" 
      		SomaLinha() 
      		@ Li,000 Psay "| Data.......: ____/____/____                                                  |"
      		SomaLinha()   
      		@ Li,000 Psay "|------------------------------------------------------------------------------|"
      		SomaLinha()            
      		li := 80

		ElseIf SM0->M0_CODIGO == "FN"  //empresa FUNDICAO
			
			lCabProd := .T.
			
			STL->(DbSetOrder(1))
			IF STL->(DbSeek(xFilial("STL")+STJ->TJ_ORDEM))
				While STL->TL_ORDEM == STJ->TJ_ORDEM .AND. STL->TL_TIPOREG = "P"

      				
      				If lCabProd
	      				@ Li,000 Psay "|-----------------+-----------+------------------------------------------------|"
    	  				SomaLinha()
    			 		@ Li,000 Psay "| C�DIGO DA PE�A  |  QUANT.   |                  DESCRI��O                     |"
		    	  		SomaLinha() 
		    	  		
		    	  		lCabProd := .F.
		    	  	EndIf

					@ Li,000 Psay "|-----------------|-----------|------------------------------------------------|"
					SomaLinha()                                
					
					@ Li,000 Psay "|"
					@ Li,002 Psay ALLTRIM(STL->TL_CODIGO)
					@ Li,018 Psay "|"
					@ Li,021 Psay Transform(STL->TL_QUANTID,"@E 9,999.99")
					@ Li,030 Psay "|"
					
					SB1->(DbSetOrder(1))
					If SB1->(DbSeek(xFilial("SB1")+STL->TL_CODIGO))
						@ Li,032 Psay SUBSTR(SB1->B1_DESC,1,45)
					EndIf

					@ Li,079 Psay "|"
	
					SomaLinha()                    
					
					STL->(DbSkip())
					 	
				EndDo
		    EndIf
			
			@ Li,000 Psay "|------------------------------------------------------------------------------|"
			SomaLinha()
			@ Li,000 Psay "|                |        |       IN�CIO       |      T�RMINO       |          |"			
			SomaLinha()
			@ Li,000 Psay "|   EXECUTANTE   | MATR.  |------------+-------|------------+-------|  TOTAL   |"			
			SomaLinha()
			@ Li,000 Psay "|                |        |    DATA    | HORA  |    DATA    | HORA  |          |"
			SomaLinha()

//INICOMENT           
			STL->(DbGoTop())
			IF STL->(DbSeek(xFilial("STL")+STJ->TJ_ORDEM))
				While STL->TL_ORDEM == STJ->TJ_ORDEM .AND. STL->TL_TIPOREG = "M"
                                                          
					nInsumo++
					
					@ Li,000 Psay "|----------------|--------|------------|-------|------------|-------|----------|
					SomaLinha()

					@ Li,000 Psay "|"
					ST1->(DbSetOrder(1))
					IF ST1->(DbSeek(xFilial("ST1")+STL->TL_CODIGO))	
						@ Li,002 Psay SUBSTR(ST1->T1_NOME,1,14)
					EndIf
					
					@ Li, 017 Psay "| "+STL->TL_CODIGO
					@ Li, 027 Psay "| "+DTOC(STL->TL_DTINICI)
					@ Li, 040 Psay "| "+STL->TL_HOINICI
					@ Li, 048 Psay "| "+DTOC(STL->TL_DTFIM)
					@ Li, 061 Psay "| "+STL->TL_HOFIM
					
					_nDias  := STL->TL_DTFIM - STL->TL_DTINICI
					_nHoras := HORATOINT(STL->TL_HOFIM) - HORATOINT(STL->TL_HOINICI)
					          
					IF _nHoras < 0
						_nHoras := 24 + _nHoras
						_nDias--
					EndIf
					                  
					_nHoras := _nHoras + (24*_nDias)
					
					@ Li, 069 Psay "| "+ INTTOHORA(_nHoras)
					                                                            
					@ Li, 080 Psay "|"
					
					SomaLinha()
								
					STL->(DbSkip())
			     
				EndDo
			EndIf
//FIM COMENT                                                                                                          
			For x:=1 to 5-nInsumo
				@ Li,000 Psay "|----------------|--------|------------|-------|------------|-------|----------|
				SomaLinha()
				@ Li,000 Psay "|                |        |            |       |            |       |          |"
				SomaLinha()
			Next
	
			@ Li,000 Psay "+----------------+--------+------------+-------+------------+-------+----------+"
	
		EndIf

	Endif
   	DbSelectArea("STJ")
   	DbSkip()
End

Return NIL

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   �NGIMPETAPA� Autor � NG Informatica Ltda   � Data �   /06/97 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o�Imprime a etapas                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MNTR675                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function NGIMPETAPA(cVOK,cVETAPA)
Local cOpcoes := "|"
Local nOpcoes := 0

	If Empty(cVOK)
	   Somalinha()
	
	//Chamado 005831 - helpdesk
	//Usamos a tabela TPC - Opcoes da Etapa Generica
	TPC->(dbSetOrder(1)) //TPC_FILIAL+TPC_ETAPA+TPC_OPCAO
	If TPC->(dbSeek(xFilial("TPC")+cVETAPA))
		While TPC->(!EOF()) .AND. TPC->TPC_ETAPA==cVETAPA .AND. nOpcoes <= 3
			cOpcoes += "( )"+Substr(TPC->TPC_OPCAO,1,1)+" "
			nOpcoes ++
			TPC->(dbSkip())
		EndDo
	Else
	   		cOpcoes += "( )S ( )N "
	EndIf
	
	   @ Li,000 Psay cOpcoes
	   @ Li,017 Psay cVETAPA
	   
	   TPA->(dbSetOrder(1))
	   TPA->(dbSeek(xFilial('TPA')+cVETAPA))
	   NGMEMOR675(' ',TPA->TPA_DESCRI,24,55,.F.)
	   
	EndIf

Return .T.

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   �NGMEMOR675� Autor �In�cio Luiz Kolling    � Data �13/08/2002���
�������������������������������������������������������������������������Ĵ��
��� Descri��o�Imprime campo memo ( especifica p/ mntr675 )                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MNTR675                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function NGMEMOR675(cTITULO,cDESCRI,nCOLU,nTAM,lSOMLI)
Local lPrimeiro := .T.
Local lSOMEILI  := lSOMLI
nLinhasMemo := MLCOUNT(cDESCRI,nTAM)
For LinhaCorrente := 1 To nLinhasMemo
   If !Empty((MemoLine(cDESCRI,nTAM,LinhaCorrente)))
      If lSOMEILI
         SomaLinha()
         @ Li,000 Psay "|"
      Endif
      If lPrimeiro
         If !Empty(cTITULO)
            @ Li,001 Psay cTITULO
         Endif
         lPrimeiro := .F.
      EndIf
      @ Li,nCOLU Psay (MemoLine(cDESCRI,nTAM,LinhaCorrente))
      @ Li,079 Psay "|"
      lSOMEILI := .t.
    EndIf
Next
Return .t.

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � SomaLinha� Autor � NG Informatica Ltda   � Data �   /06/97 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Incrementa Linha e Controla Salto de Pagina                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MNTR675                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function Somalinha()
   Li++
   If Li > 58
      Cabecalho()
   EndIf
Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � Cabecalho� Autor � NG Informatica Ltda   � Data �   /06/97 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Cabecalho da Ordem de Servico                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MNTR675                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function Cabecalho()

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

@ 006,000 Psay "+------------------------------------------------------------------------------+"
@ 007,000 Psay "| Ordem De Servico De Manutencao: "+STJ->TJ_ORDEM// +cNomFil


TQB->(dbSetOrder(4)) //TQB_FILIAL+TQB_ORDEM
If TQB->(dbSeek(xFilial("TQB")+STJ->TJ_ORDEM))
	@ 007,060 Psay "SS:  "+TQB->TQB_SOLICI
EndIf


//@ 002,001 Psay cNomFil
//@ 002,012 Psay STR0006 //"Ordem De Servico De Manutencao"
//@ 007,001 Psay "Ordem De Servico De Manutencao"
//@ 007,032 Psay STJ->TJ_ORDEM
@ 007,079 Psay "|"
@ 008,000 Psay "|------------------------------------------------------------------------------|"
@ 009,000 Psay "|"
@ 009,001 Psay STR0044 //"Inicio:"
@ 009,009 Psay STJ->TJ_DTMPINI Picture '99/99/99'
@ 009,020 Psay STJ->TJ_HOMPINI Picture '99:99'
@ 009,033 Psay STR0045 //"Fim:"
@ 009,037 Psay STJ->TJ_DTMPFIM Picture '99/99/99'
@ 009,048 Psay STJ->TJ_HOMPFIM Picture '99:99'
@ 009,059 Psay STR0046 //"Emi:"
@ 009,065 Psay dDataBase
@ 009,079 Psay "|"
//@ 003,079 Psay "|"
//@ 004,000 Psay STR0047 //"|Execucao: Inicio: ____/____/____ __:__ Plano:"
@ 010,000 Psay "|"+STJ->TJ_PLANO
@ 010,010 Psay STR0048 //"Prioridade Manut.:"
@ 010,029 Psay STJ->TJ_PRIORID
@ 010,079 Psay "|"

//@ 005,000 Psay STR0049 //"|          Fim...: ____/____/____ __:__"

@ 011,000 Psay "|"+SubStr(STI->TI_DESCRIC,1,39)
@ 011,079 Psay "|"
Li := 012

Return

/*/
              1         2         3         4         5         6         7     8
012345678901234567890123456789012345678901234567890123456789012345678901234567890
������������������������������������������������������������������������������Ŀ
�<XXXXXXXXXXXXXXX>             ORDEM DE SERVICO DE MANUTENCAO xxxxxx           �
�SIGA/MNTR675       Data da Ordem dd/mm/aaaa hh:mm    Emissao: dd/mm/aaaa hh:mm�
������������������������������������������������������������������������������Ĵ
�Execucao: Inicio: ____/____/____ __:__ Plano: xxx.xxx Prioridade Manut.: xxx  �
�          Fim...: ____/____/____ __:__ xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx�
�������������������������������������Bem��������������������������������������Ĵ
�Ident....: xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx Prior: xxx�
�Pai......: xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx           �
�C.Custo..: xxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                 �
�C.Trab...: xxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                 �
�Detalhes.: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxx xxxxxxxxxx�
�           xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxx xxxxxxxxxx�
�Descricao: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                 �
�           xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                 �
�           xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                 �
����������������������������������Manutencao����������������������������������Ĵ
�Servico..: xxx.xxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx Man.Ant.: xx/xx/xx�
�Sequencia: 999   Nome Manut..: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    �
�Area.....: xxx.xxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx Contador: xxxxxx  �
�Tipo.....: xxx     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                   �
�Parada...: Antes: xxx x xx/xx/xxxx xx:xx     Depois: xxx x xx/xx/xxxx xx:xx   �
�Descricao: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                 �
�           xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                 �
�           xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                 �
�����������������������������������Tarefa�������������������������������������Ĵ
�Codigo: xxxxxx  Previsao Inicio..: dd/mm/aaaa hh:mm   Fim..: dd/mm/aaaa hh:mm �
�                Real     Inicio..: dd/mm/aaaa hh:mm   Fim..: dd/mm/aaaa hh:mm �
�xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx�
�   �������������������������������Etapas�����������������������������������   �
�   xxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   �
�   xxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   �
�   �������������������������������Insumos����������������������������������   �
�Nome Codigo          Descricao                                                �
�                     Dt.Prev.  hora    Qtd   Consumo  Uni  Qtd  Consumo  Uni  �
�xxxx xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                  �
�                     99/99/99  99:99   xxx xxxxxx,xx  xxx  xxx xxxxxx,xx xxx  �
�xxxx xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                  �
�                     99/99/99  99:99   xxx xxxxxx,xx  xxx  xxx xxxxxx,xx xxx  �
�xxxx xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                  �
�                     99/99/99  99:99   xxx xxxxxx,xx  xxx  xxx xxxxxx,xx xxx  �
|                                                                              |
�   ������������������Etapas Nao Relacionado a Insumos�����������������������  �
�Tarefa xxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx �
�xxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx �
|______________________________________________________________________________|
|Descricao da O.S: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx |
|                  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx |
|                  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx |
|                                                                              |                                                                      �
���������������������������������Ocorrencias����������������������������������Ĵ
�Tarefa   Ocorrencia            Causa                  Solucao                 �
�                                                                              �
� �����    �������������������   ��������������������   �������������������    �
� �����    �������������������   ��������������������   �������������������    �
� �����    �������������������   ��������������������   �������������������    �
� �����    �������������������   ��������������������   �������������������    �
� �����    �������������������   ��������������������   �������������������    �
������������������������������������������������������������������������������Ĵ
�  Manutencao.: ____/____/____           Contador..:   ______________ Fim.:    �
�                                                                              �
�  Data.......: ____/____/____           Assinatura: _______________________   �
�                                                                              �
��������������������������������������������������������������������������������
/*/
