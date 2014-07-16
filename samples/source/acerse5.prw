#INCLUDE "PROTHEUS.CH"
                        
User function Acertase5()
//Acertado a chave de pesquisa no momento da exclusao de uma compensação Desc.
// Qualidade : Fazer a compensacao de 3 titulo apartir do PA 
//- Fazer a eclusao de uma compensacao posicionado no titulo de NF
//- Fazer uma nova exclusao posicionado no RA e verificar se a anterior nao aparece mais Fontes modificados: FINA340.PRX ; 

Local nOpc:=4
Private aTitulos:={}
Private lExecute:=.T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While nOpc<>3 .And. nOpc<>0
	nOpc:= Aviso("Acerto SE5","Esta rotina tem como objetivo acertos os registros que ficaram pendentes na exclusao da compensacao",{"Listar", "Acertar","Sair"})
	
	If nOpc== 1
		If Len(aTitulos) ==0
			Processa ({||GeraArq()})	
		EndIf   
			If Len(aTitulos) ==0	
			MsgAlert(" Nao foram encontrados registros com problema", "Verificacao")
		Else	 
			Processa ({||FA995REL()})	
		EndIf	
		
	ElseIf nOpc== 2
		If Len(aTitulos) ==0
			Processa ({||GeraArq()})	
		EndIf 
		If Len(aTitulos) ==0	
			MsgAlert(" Nao foram encontrados registros com problema", "Verificacao")
		Else	 
			Processa ({||ATUARQSE5()})	
		EndIf	
	EndIf
EndDo

Return


Static Function FA995REL()

LOCAL titulo     := Iif(lExecute,"Registros que serao deletados ","Registros que foram deletados ")
LOCAL cDesc1     := "Listagem de registros"
LOCAL cDesc2     :="que tiveram problemas na exclusao da compensacao "
LOCAL cDesc3     :=" "
LOCAL cString    := "SE5"
LOCAL wnrel      := "ACERSE5"
LOCAL nomeprog   := "ACERSE5"

PRIVATE Tamanho  := "P"
PRIVATE limite   := 80
PRIVATE aReturn  := {OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }	
PRIVATE lEnd     := .F.
PRIVATE m_pag    := 1
PRIVATE li       := 80
PRIVATE nLastKey := 0

wnrel:=SetPrint(cString,wnrel,,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If ( nLastKey == 27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Return
Endif

SetDefault(aReturn,cString)

If ( nLastKey == 27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Return
Endif

RptStatus({|lEnd| AcerRel(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AcerRel  ³ Autor ³ Paulo Augusto         ³ Data ³12/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ACERSE5			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AcerRel(lEnd,WnRel,cString,nomeprog,Titulo)

LOCAL cabec1	:= ""
LOCAL cabec2	:= ""
Local lImp 		:=.F.
Local nTotFor	:=0
Local nI:=1
PRIVATE nTipo	:= IIF(aReturn[4]=1,15,18)
cabec1 :="Prefixo   Num Titulo        Parcela    Tipo          Valor          Recno"

// "    Codigo         Loja      Nome                               CUIT"
//12345678901234567890123456789012345678901234567890123456789012345678901234567890
//0        1         2         3         4         5         6         7         8     

If Len(aTitulos) ==0
		Processa ({||GeraArq()})	
EndIf

SetRegua(Len(aTitulos))

li:= cabec(Titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
li++
For nI:=1 to Len(aTitulos)
	If lEnd
		@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se cancelado pelo usuario                            	     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If li > 56
		li:= cabec(Titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
		li++
	Endif                                                          
	@li,005 PSAY aTitulos[nI][1]  
	@li,010 PSAY aTitulos[nI][2]  
	@li,030 PSAY aTitulos[nI][3]
	@li,040 PSAY aTitulos[nI][4]
	@li,045 PSAY aTitulos[nI][5]  Picture PesqPict("SE5","E5_VALOR")
	@li,070 PSAY aTitulos[nI][6]  
	
//"Prefixo     Num Titulo      Parcela      Tipo     Valor        Recno"

//12345678901234567890123456789012345678901234567890123456789012345678901234567890
//         1         2         3         4         5         6         7
	li++                                                                                 
	
	nTotFor++
	lImp:=.T.
	
Next
				
If lImp
	li++
	
	If li > 56
		cabec(Titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
	Endif
	
	@li,000  PSAY "Total de Titulos: "+ Alltrim(str(nTotFor)) //"Total de Fornecedores: "
	
	roda()
Endif

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ATUARQSE5³ Autor ³ Paulo Augusto         ³ Data ³12/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Acerto do SE5                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ACERSE5			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static function ATUARQSE5()
Local nTit:=0
Local nI:=1

If lExecute
	ProcRegua(Len(aTitulos))
	DbSelectArea("SE5")
	For nI:=1 to Len(aTitulos)
		DbGoto(aTitulos[nI][6])
		Reclock("SE5",.F.)
		dbDelete()
		MsUnlock()
		nTit:=nTit +1
	Next
	lExecute:=.F.
	MsgAlert(" Foram acertados: "+ str(nTit)+ " registros", "Acerto") 
Else
	MsgAlert(" Rotina de acerto já foi executada")
EndIf                                  
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GeraArq  ³ Autor ³ Paulo Augusto         ³ Data ³12/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera array com os registros que tiveram problemas          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ACERSE5			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraArq()
Local nTamTit := TamSX3("E2_PREFIXO")[1]+TamSX3("E2_NUM")[1]+TamSX3("E2_PARCELA")[1]+ TamSX3("E2_TIPO")[1]
lOCAL cDocumento :=""
lOCAL nRecno:=0   

lOCAL cIndexSe5 :=""
       
DBSelectArea("SE5")
cIndexSe5 := CriaTrab(nil,.f.)
IndRegua("SE5",cIndexSe5,"E5_FILIAL+E5_PREFIXO+E5_NUMERO + E5_PARCELA+E5_TIPO+E5_SEQ",,'E5_MOTBX=="CMP".and.E5_TIPODOC $("CP|BA") ',"Selecionanto Registros...") // "Selecionanto Registros..."

nIndexSE5 := RetIndex("SE5")
#IFNDEF TOP
	dbSetIndex(cIndexSe5+OrdBagExt())
#ENDIF
dbSetOrder(nIndexSe5+1)
ProcRegua(Reccount())
DbGotop()
While !SE5->(EOF()) .And. SE5->E5_FILIAL ==xFilial("SE5")
	cDocumento := Substr(SE5->E5_DOCUMEN,1,nTamTit)+SE5->E5_SEQ
	nRecno:=Recno()
	If !dbSeek(xFilial("SE5")+ cDocumento)
	    DbGoto(nRecno)
			Aadd(aTitulos,{SE5->E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_TIPO,E5_VALOR,SE5->(RECNO())})
	EndIf
	DbGoto(nRecno)
	IncProc()
	DbSkip()
EndDO	

#IFNDEF TOP
	dbSelectArea("SE5")
	dbClearFil()
	RetIndex( "SE5" )
	If !Empty(cIndexSE5)
		FErase (cIndexSE5+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	dbSelectArea("SE5")
	dbCloseArea()
	ChKFile("SE2")
	dbSelectArea("SE5")
	dbSetOrder(1)
#ENDIF


Return()	

