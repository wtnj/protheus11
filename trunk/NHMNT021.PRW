#INCLUDE "MNTR385.ch"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MNTR385   ³ Autor ³ Marcos Wagner Junior  ³ Data ³ 10/10/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio de indisponibilidade do equipamento               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/      
User Function NHMNT021()  

WNREL      := "NHMNT021"
LIMITE     := 150
cDESC1     := STR0001 //"O relatorio de indisponibilidade do equipamento apresentará informações "
cDESC2     := STR0002 //"referentes ao percentual de indisponibilidade em relação ao tempo "
cDESC3     := STR0003 //"total de disponibilidade do equipamento"
cSTRING    := "ST9"       
 
                                 
Private NOMEPROG := "NHMNT021"
Private TAMANHO  := "G"
Private aRETURN  := {STR0004,1,STR0005,1,2,1,"",1} //"Zebrado"###"Administracao"
Private TITULO   := STR0006 //"Relatório de Indisponibilidade do Equipamento"
Private nTIPO    := 0
Private nLASTKEY := 0
Private CABEC1,CABEC2 
Private aVETINR := {}    
Private cPERG := "MNR385"   
Private aPerg :={}     


DbSelectArea("SX1")
DbSetOrder(01)
If !DbSeek("MNR385"+"01")   
   aPerg := {} 
   AAdd(aPerg, {STR0007,"C",02,0,"MNR385FL(1)","DLB","G"}) //"De Filial           ?"
   AAdd(aPerg, {STR0008,"C",02,0,"MNR385FL(2)","DLB","G"}) //"Até Filial          ?"
   AAdd(aPerg, {STR0009,"C",06,0,"MNR385CD(1,mv_par03,mv_par04,'ST6')",'ST6',"G"}) //"De Família          ?"
	AAdd(aPerg, {STR0010,"C",06,0,"MNR385CD(2,mv_par03,mv_par04,'ST6')",'ST6',"G"}) //"Até Família         ?"
	AAdd(aPerg, {STR0011,"C",10,0,"MNR385CD(1,mv_par05,mv_par06,'TQR')",'TQR',"G"}) //"De Modelo           ?"
   AAdd(aPerg, {STR0012,"C",10,0,"MNR385CD(2,mv_par05,mv_par06,'TQR')",'TQR',"G"}) 	 //"Até Modelo          ?"
 	AAdd(aPerg, {STR0013,"C",16,0,"MNR385CD(1,mv_par07,mv_par08,'ST9')",'ST9',"G"}) //"De Bem              ?"
	AAdd(aPerg, {STR0014,"C",16,0,"MNR385CD(2,mv_par07,mv_par08,'ST9')",'ST9',"G"}) //"Até Bem             ?"
	AAdd(aPerg, {STR0015,"D",08,0,"Naovazio() .AND. MNR385PE(mv_par09,mv_par10)","","G"})  //"De Período          ?"
	AAdd(aPerg, {STR0016,"D",08,0,"Naovazio() .AND. MNR385PE(mv_par09,mv_par10)","","G"}) //"Até Período         ?"
   AAdd(aPerg, {STR0017,"N",02,0,"MNR385DD","","G"}) //"Dias úteis mês      ?"
   AAdd(aPerg, {STR0018,"N",02,0,"MNR385HR","","G"}) //"Qtde Hr. Úteis Dia  ?"

   NgChkSx1("MNR385",aPerg)  
Else 
	DbSelectArea("SX1")
	DbSetOrder(1) 
   If DbSeek("MNR385"+"09")
   	RecLock("SX1",.f.)   
		SX1->X1_CNT01 := Space(10)
		MsUnLock("SX1")
  	Endif        
  	If DbSeek("MNR385"+"10")   
  		RecLock("SX1",.f.)
		SX1->X1_CNT01 := Space(10)
		MsUnLock("SX1")
	Endif    
EndIf   


Pergunte(cPERG,.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
WNREL:=SetPrint(cSTRING,WNREL,cPERG,TITULO,cDESC1,cDESC2,cDESC3,.F.,"")
If nLASTKEY = 27
   Set Filter To
   DbSelectArea("ST9")  
   Return
EndIf     
SetDefault(aReturn,cSTRING)
RptStatus({|lEND| MNTR385IMP(@lEND,WNREL,TITULO,TAMANHO)},STR0019,STR0020) //"Aguarde..."###"Processando Registros..."
Dbselectarea("ST9")  

Return .T.    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    |MNR385IMP | Autor ³ Marcos Wagner Junior  ³ Data ³26/09/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Chamada do Relat¢rio                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MNTR385                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MNTR385IMP(lEND,WNREL,TITULO,TAMANHO)
Private cRODATXT := ""
Private nCNTIMPR := 0     
Private li := 80 ,m_pag := 1    
Private cNomeFil, cNomFam, cDesmod, cFabric
Private nTempoIn, nVaria, nPulaLi, nCont                        



nTIPO  := IIf(aReturn[4]==1,15,18)                                                                                                                                                                                               
            
CABEC1 := STR0021 //"Bem               Nome do Bem                               Familia               Tipo Modelo           Fabricante            Tempo Indisp.  % Variacao"
CABEC2 := ""   

/*
          1         2         3         4         5         6         7         8         9         0         1         2         3         4         5
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*******************************************************************************************************************************************************
            Relatorio do cadastro de Ocorrências    
*******************************************************************************************************************************************************

Bem               Nome do Bem                               Familia               Tipo Modelo           Fabricante            Tempo Indisp.  % Variacao

Filial: xx - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                 							Tempo Disponivel em horas: 999.999 

xxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxx  		999.999     999.999
xxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxx  		999.999     999.999
xxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxx  		999.999     999.999

					   Total Filial:                          							Horas Disponiveis: 9.999.999       Indisponiveis:    		999.999     999.999
*/   
                        
                                                        
cAliasQry := GetNextAlias()
cQuery := " SELECT ST9.T9_FILIAL, ST9.T9_CODBEM"
cQuery += " FROM " + RetSqlName("ST9")+" ST9 "
cQuery += " WHERE ST9.T9_FILIAL  >= '"+MV_PAR01+"' AND ST9.T9_FILIAL   <= '" +MV_PAR02+"'
cQuery += " AND   ST9.T9_CODFAMI >= '"+MV_PAR03+"' AND ST9.T9_CODFAMI  <= '" +MV_PAR04+"'
cQuery += " AND   ST9.T9_MODELO  >= '"+MV_PAR05+"' AND ST9.T9_MODELO   <= '" +MV_PAR06+"'
cQuery += " AND   ST9.T9_CODBEM  >= '"+MV_PAR07+"' AND ST9.T9_CODBEM   <= '" +MV_PAR08+"'
cQuery += " AND ST9.D_E_L_E_T_ <> '*' "    
cQuery += " ORDER BY ST9.T9_FILIAL, ST9.T9_CODFAMI, ST9.T9_MODELO"              

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .T.)                                 
                                                                
SetRegua(LastRec()) 
      
   
aPos1 := {15,1,95,315 }
aDBFR385 := {{"FILIAL" ,"C", 02,0},;
             {"CODBEM" ,"C", 16,0},;
             {"INDISP" ,"N", 08,3}}
          
vINDR385  := {"FILIAL+CODBEM"}
cARQTR385 := NGCRIATRB(aDBFR385,vINDR385,"TRBB") 

aTRBB := {{"Filial" 				 ,"FILIAL" ,"C",02,0,"@!"},;
 			 {STR0022 	 ,"CODBEM" ,"C",16,0,"@!" },; //"Código do Bem"
          {STR0023,"INDISP" ,"N",08,3,"@E 9999.999" }} //"Tempo Indisponível"


DbselectArea(cAliasQry)                                                                 
DbGoTop()       
Private Teste := 0
While !Eof()         
	IncRegua()
   Dbselectarea("STJ")
   DbsetOrder(15)
   //If Dbseek(xFilial("STJ")+"B"+(cAliasQry)->T9_CODBEM)  
   If Dbseek((cAliasQry)->T9_FILIAL+"B"+(cAliasQry)->T9_CODBEM)
      //While !Eof() .And. STJ->TJ_FILIAL = xFilial("STJ") .And.; 
      While !Eof() .And. STJ->TJ_FILIAL = (cAliasQry)->T9_FILIAL .And.;
         STJ->TJ_TIPOOS = "B" .And. STJ->TJ_CODBEM = (cAliasQry)->T9_CODBEM
         
         If STJ->TJ_TERMINO = "S" .And. STJ->TJ_SITUACA = "L" .And. STJ->TJ_SERVICO == "000000" .And. STJ->TJ_MAQSIT = "P" .And. ;
            (STJ->TJ_DTMRFIM >= MV_PAR09 .And. STJ->TJ_DTMRFIM <= MV_PAR10)

            DbselectArea("TRBB")
            If !Dbseek((cAliasQry)->T9_FILIAL+(cAliasQry)->T9_CODBEM)
               Reclock("TRBB",.T.)
               TRBB->FILIAL := (cAliasQry)->T9_FILIAL
               TRBB->CODBEM := (cAliasQry)->T9_CODBEM

               TRBB->INDISP := NGCALCH100(STJ->TJ_DTMRINI,;
            	                           STJ->TJ_HOMRINI,;
               	                        STJ->TJ_DTMRFIM,;
                  	                     STJ->TJ_HOMRFIM)  
            Else
            	Reclock("TRBB",.F.)
            	TRBB->INDISP += NGCALCH100(STJ->TJ_DTMRINI,;
            	                           STJ->TJ_HOMRINI,;
               	                        STJ->TJ_DTMRFIM,;
                  	                     STJ->TJ_HOMRFIM)      
            Endif
            MsUnlock("TRBB")
         Endif
         DbselectArea("STJ")
         DbSkip()
      End
   Endif

  /* Dbselectarea("STS")
   DbsetOrder(8)
   If Dbseek(xfilial("STS")+"B"+(cAliasQry)->T9_CODBEM)
      While !Eof() .And. STS->TS_FILIAL = Xfilial("STS") .And.;
         STS->TS_TIPOOS = "B" .And. STS->TS_CODBEM = (cAliasQry)->T9_CODBEM
         If STS->TS_TERMINO = "S" .And. STS->TS_SITUACA = "L" .And.;
            (STS->TS_DTMPINI >= MV_PAR09 .And. STS->TS_DTMPINI <= MV_PAR10)

            DbselectArea("TRBB")
            If !Dbseek((cAliasQry)->T9_FILIAL+(cAliasQry)->T9_CODBEM)
               Reclock("TRBB",.T.)
               TRBB->FILIAL := (cAliasQry)->T9_FILIAL
               TRBB->CODBEM := (cAliasQry)->T9_CODBEM
               TRBB->INDISP := NGCALCH100(STS->TS_DTMRINI,;
           		 								   STS->TS_HOMRINI,;
               	                        STS->TS_DTMRFIM,;
                  	                     STS->TS_HOMRFIM)
             Endif
            MsUlock("TRBB")
         Endif
         DbselectArea("STS")
         DbSkip()
      End
   Endif                */

   DbselectArea(cAliasQry)
   DbSkip()        
   Teste += 1
End       
   
   
nTempoIn := 000.000
nVaria	:= 000.000 
nPulaLi := 1  
nCont := 0                                                                 
DbselectArea("TRBB")                                                               
DbGoTop()
While !Eof()
	
	If nPulaLi = 1 
  		NgSomaLi(58)
  		nPulaLi += 1
  	Endif 
  	NgSomaLi(58)
	
	If lEnd
      @ Prow()+1,001 PSay STR0024 //"CANCELADO PELO OPERADOR"
      Exit
  	EndIf  
  	
   If	cNomeFil <> TRBB->FILIAL
      DbSelectArea("SM0")
		SM0->(DbSetOrder(1))	
		If MsSeek(SM0->M0_CODIGO+TRBB->FILIAL)   
			@ Li,000   Psay STR0025+TRBB->FILIAL+" - "+SM0->M0_FILIAL //"Filial: "
			@ Li,090   Psay STR0026 //"Tempo Disponivel em horas:"
			@ Li,117   Psay (MV_PAR11 * MV_PAR12)
			NgSomaLi(58)  
			NgSomaLi(58)   
			nCont := 0
		Endif	
   EndIf
  	cNomeFil := TRBB->FILIAL 
  	
	@ Li,000 	 Psay TRBB->CODBEM   
	dbSelectArea("ST9")
	dbSetOrder(1)
	dbSeek(TRBB->FILIAL+TRBB->CODBEM)  
	@ Li,018		 PSay ST9->T9_NOME  
	cNomFam := NGSEEK("ST6",ST9->T9_CODFAMI,1,"ST6->T6_NOME")
	cDesmod := ST9->T9_MODELO //NGSEEK("TQR",ST9->T9_MODELO ,1,"TQR->TQR_DESMOD")
	cFabric := NGSEEK("ST7",ST9->T9_FABRICA,1,"ST7->T7_NOME")
	@ Li,060 	 Psay SubStr(cNomFam,1,20)
	@ Li,082		 PSay SubStr(cDesmod,1,20)
	@ Li,104 	 Psay SubStr(cFabric,1,20)
  	@ Li,132		 PSay TRBB->INDISP Picture "@E 9999.999"     
  	@ Li,144 	 Psay (TRBB->INDISP * 100)/(MV_PAR11 * MV_PAR12) Picture "@E 9999.999" 
  	nTempoIn += TRBB->INDISP
  	nVaria   += (TRBB->INDISP * 100)/(MV_PAR11 * MV_PAR12) 
    
   nCont += 1   
   DbSelectArea("TRBB")
   DbSkip()	 

   If /*Eof() .Or.*/cNomeFil <> TRBB->FILIAL  
   	NgSomaLi(58)
   	NgSomaLi(58) 
   	@ Li,018 	 Psay STR0027        //"Total Filial:"
   	@ Li,078 	 Psay STR0028 //"Horas Disponiveis:"
   	@ Li,097 	 Psay (MV_PAR11 * MV_PAR12) * nCont
   	@ Li,110 	 Psay STR0029      //"Indisponiveis:"
   	@ Li,132 	 Psay nTempoIn Picture "@E 9999.999"
   	@ Li,144 	 Psay nVaria Picture "@E 9999.999"
     	nTempoIn := 000.000
     	nVaria	:= 000.000   
     	If !Eof()
     		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)     
     	Endif
   Endif      
   
   
End                   
        
(cALIASQRY)->(dbCloseArea()) 

NGDELETRB("TRBB",cARQTR385)  

RODA(nCNTIMPR,cRODATXT,TAMANHO)       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original do arquivo principal             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex('ST9')
Set Filter To
Set Device To Screen
If aReturn[5] == 1
   Set Printer To
   dbCommitAll()
   OurSpool(WNREL)
EndIf
MS_FLUSH()


Return Nil        

                
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    |MNR385FL  | Autor ³Marcos Wagner Junior   ³ Data ³ 10/10/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o |Valida codigos de Filial, Ate Filial 					        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MNTR385                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function MNR385FL(nOpc)

If (Empty(mv_par01) .AND. nOpc == 1) .OR. (mv_par02 == 'ZZ' .AND. nOpc == 2)
	Return .t.
Else
	If nOpc == 1
		lRet := IIf(Empty(Mv_Par01),.t.,ExistCpo('SM0',SM0->M0_CODIGO+Mv_par01))
	   If !lRet
	      Return .f.
	   EndIf
	EndIf

	If nOpc == 2 
	      lRet := IIF(ATECODIGO('SM0',SM0->M0_CODIGO+Mv_par01,SM0->M0_CODIGO+Mv_Par02,17),.T.,.F.)
	      If !lRet
	         Return .f.
	      EndIf 
	EndIf
EndIf          
 
Return .t.                
       
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    | MNR385CD | Autor ³Marcos Wagner Junior   ³ Data ³ 26/09/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o |Valida codigos De... Ate  											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MNTR385                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MNR385CD(nOpc,cParDe,cParAte,cTabela)  
      
If (Empty(cParDe) .AND. nOpc == 1) .OR. (cParAte == 'ZZZZZZ' .AND. nOpc == 2) .OR.;
	      (cParAte == 'ZZZZZZZZZZ' .AND. nOpc == 2) .OR. (cParAte == 'ZZZZZZZZZZZZZZZZ' .AND. nOpc == 2)
	Return .t.
Else
	If nOpc == 1
		If Empty(cParDe)
			Return .t.
		Else		
			lRet := IIf(Empty(cParDe),.t.,ExistCpo(cTabela,cParDe))
		   If !lRet
		      Return .f.
		   EndIf 
		Endif 
	ElseIf nOpc == 2      
		If (cParAte == 'ZZZZZZ') .OR. (cParAte == 'ZZZZZZZZZZ') .OR. (cParAte == 'ZZZZZZZZZZZZZZZZ') 
			Return .t.
		Else
	      lRet := IIF(ATECODIGO(cTabela,cParDe,cParAte,12),.T.,.F.)
	      If !lRet 
	         Return .f.
	      EndIf  
	   EndIf
	EndIf    
Endif

Return .t.                                                

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MNR385DD  ³ Autor ³Marcos Wagner Junior   ³ Data ³ 10/10/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida o parametro Dias Uteis no Mes                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MNTR385                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MNR385DD()

If (MV_PAR11 < 1) .OR. (MV_PAR11 >= 32)
	MsgStop(STR0030)  //"Dias úteis no mês deve ser maior/igual a 1 e menor do que 32"
   Return .F.  
EndIf

Return .T.     


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MNR385PE  ³ Autor ³Marcos Wagner Junior   ³ Data ³ 10/10/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida as datas do parametro                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MNTR385                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MNR385PE(dIni,dFim)

If (Empty(dIni) .OR. Empty(dFim)) 
	Return .T.                   
Else
	If (SubStr(DTOS(dIni),1,4) != SubStr(DTOS(dFim),1,4)) .OR. (SubStr(DTOS(dIni),5,2) != SubStr(DTOS(dFim),5,2))
		MsgStop(STR0031)  //"Mês e Ano devem ser iguais entre as datas De Período e Até Período"
   	Return .F.
   Endif  	
Endif

Return .T.


            
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MNR385HR  ³ Autor ³Marcos Wagner Junior   ³ Data ³ 10/10/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida o parametro Qtde Hr. Uteis Dia                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MNTR385                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MNR385HR()

If (MV_PAR12 > 24) .OR. (MV_PAR12 < 1) 
	MsgStop(STR0032)  //"Qtde hr. úteis dia deve ser maior/igual a 1 e menor/igual a 24"
   Return .F.  
EndIf

Return .T.