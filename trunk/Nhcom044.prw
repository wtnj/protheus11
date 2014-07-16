/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCOM044  ºAutor  ³Marcos R Roquitski  º Data ³  04/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consultas pendencias por aprovadores.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³WHB                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"  
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

User function Nhcom044()
Local aButtons := {}
Private aSize     := MsAdvSize()
Private aObjects  := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo     := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5 } 
Private aPosObj   := MsObjSize( aInfo, aObjects, .T.)
Private cMarca    := getmark()

_dUltApr  := Ctod(Space(08))

_cArqDBF  := CriaTrab(NIL,.f.)
_aDBF := {}

AADD(_aDBF,{"OK",          "C",02,0})
AADD(_aDBF,{"DT_MARCA",    "C",10,0})
AADD(_aDBF,{"DT_NUM",      "C",06,0})
AADD(_aDBF,{"DT_ITEM",     "C",04,0})
AADD(_aDBF,{"DT_NUMCT",    "C",06,0})
AADD(_aDBF,{"DT_ITEMCT",   "C",04,0})
Aadd(_aDBF,{"DT_NUMPED",   "C",06,0})    
Aadd(_aDBF,{"DT_ITEMPED",  "C",04,0})
AADD(_aDBF,{"DT_TIPO",     "C",03,0})
AADD(_aDBF,{"DT_DESCRI",   "C",48,0})
AADD(_aDBF,{"DT_PRODUTO",  "C",15,0})
AADD(_aDBF,{"DT_LOGIN",    "C",15,0})
AADD(_aDBF,{"DT_SOLICIT",  "C",15,0})
AADD(_aDBF,{"DT_QUANT",    "N",14,4})
AADD(_aDBF,{"DT_VUNIT",    "N",16,2})
AADD(_aDBF,{"DT_VALOR",    "N",16,2})
AADD(_aDBF,{"DT_VLRPC",    "N",16,2})
AADD(_aDBF,{"DT_EMISSAO",  "D",08,0})
AADD(_aDBF,{"DT_ATENCAO",  "C",10,0})
AADD(_aDBF,{"DT_ANEXO",    "C",03,0})
AADD(_aDBF,{"DT_ANEXO1",  "C",100,0})
AADD(_aDBF,{"DT_ANEXO2",  "C",100,0})
AADD(_aDBF,{"DT_ANEXO3",  "C",100,0})
AADD(_aDBF,{"DT_STATUS",   "C",01,0})
AADD(_aDBF,{"DT_OBS",     "C",240,0})
AADD(_aDBF,{"DT_ULTAPR",   "D",08,0})
AADD(_aDBF,{"DT_QUANTP",    "N",14,4})
AADD(_aDBF,{"DT_VUNITP",    "N",16,2})
AADD(_aDBF,{"DT_VALORP",    "N",16,2})


DbCreate(_cArqDBF,_aDBF)
DbUseArea(.T.,,_cArqDBF,"XDET",.F.) 

index ON XDET->DT_NUM TO (_cArqDBF)

Processa( {|| fDetalhes()})

DbSelectArea("XDET")
XDET->(DbGotop())

If Reccount() <=0
	MsgBox("Nao ha registro Selecionados !","Atencao !","INFO")
	DbCloseArea("XDET")
	Return
Endif

aFields := {}
Aadd(aFields,{"OK"           ,"C",""})
Aadd(aFields,{"DT_MARCA"     ,"C",OemToAnsi("Situacao")})

Aadd(aFields,{"DT_ANEXO"     ,"C",OemToAnsi("Anexo") })    
Aadd(aFields,{"DT_NUM"       ,"C",OemToAnsi("Numero") })    
Aadd(aFields,{"DT_ITEM"      ,"C",OemToAnsi("Item") })
Aadd(aFields,{"DT_NUMCT"     ,"C",OemToAnsi("Ped. Aberto") })    
Aadd(aFields,{"DT_ITEMCT"    ,"C",OemToAnsi("Item PA") })
Aadd(aFields,{"DT_NUMPED"    ,"C",OemToAnsi("Aut.Entrega") })    
Aadd(aFields,{"DT_ITEMPED"   ,"C",OemToAnsi("Item A.E.") })

Aadd(aFields,{"DT_PRODUTO"   ,"C",OemToAnsi("Produto") })   
Aadd(aFields,{"DT_DESCRI"    ,"C",OemToAnsi("Descricao") })
Aadd(aFields,{"DT_QUANT"     ,"N",OemToAnsi("Qtde"),"@E 999999999.9999"})
Aadd(aFields,{"DT_VUNIT"     ,"N",OemToAnsi("Vlr. Estimado"),"@E 999,999,999.99"})
Aadd(aFields,{"DT_VALOR"     ,"N",OemToAnsi("Total"),"@E 999,999,999.99"})
Aadd(aFields,{"DT_VLRPC"     ,"N",OemToAnsi("Vl.Ult.PC"),"@E 999,999,999.99"})
Aadd(aFields,{"DT_SOLICIT"   ,"C",OemToAnsi("Solicitante")  })
Aadd(aFields,{"DT_EMISSAO"   ,"D",OemToAnsi("Emissao") })
Aadd(aFields,{"DT_ULTAPR"    ,"D",OemToAnsi("Ult.Aprov.") })
Aadd(aFields,{"DT_OBS"       ,"D",OemToAnsi("Observacao") })
Aadd(aFields,{"DT_LOGIN"     ,"C",OemToAnsi("Responsavel")})
Aadd(aFields,{"DT_ATENCAO"   ,"C",OemToAnsi("Status") })

Aadd(aFields,{"DT_QUANTP"     ,"N",OemToAnsi("Qtde PA"),"@E 999999999.9999"})
Aadd(aFields,{"DT_VUNITP"     ,"N",OemToAnsi("Vlr. Ped. Aberto"),"@E 999,999,999.99"})
Aadd(aFields,{"DT_VALORP"     ,"N",OemToAnsi("Total PA"),"@E 999,999,999.99"})

	aAdd(aButtons,{"CRITICA",{||U_fAnexodet(1)},"anexo 1"  ,"Anexo 1"})  
	aAdd(aButtons,{"CRITICA",{||U_fAnexodet(2)},"anexo 2"  ,"Anexo 2"})  
	aAdd(aButtons,{"CRITICA",{||U_fAnexodet(3)},"anexo 3"  ,"Anexo 3"})  
	aAdd(aButtons,{"CRITICA",{||U_fImpPend()}  ,"imprimir" ,"Imprimir"})  
	aAdd(aButtons,{"CRITICA",{||U_fFilPend()}  ,"filtro"   ,"Filtrar"})  

	bEnchoice := {||EnchoiceBar(oDialog,{||fOK()},{||oDialog:End()},,aButtons)}

	oDialog := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Consulta status da Aprovação",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oBtn1 := tButton():New(05,05,"Marcar Todos"    ,oDialog,{||fTdSc(.t.)},50,10,,,,.T.)
	oBtn2 := tButton():New(05,60,"Desmarcar Todos" ,oDialog,{||fTdSc(.f.)},50,10,,,,.T.)

	oMark := MsSelect():New("XDET","OK",nil,aFields,.F.,@cMarca,{20, aPosObj[2,2] ,aPosObj[2,3],aPosObj[2,4]})

	oDialog:Activate(,,,.F.,{||.T.},,bEnchoice)

XDET->(DbCloseArea())

Return

Static Function fOk()
	If MsgYesNo("Deseja fechar?")
		oDialog:End()
	Endif
Return

Static Function fDetalhes()
Local nRecno,_cNumSc,_cNivel,_cOk

DbSelectArea("SC1")
SET FILTER TO 
SC1->(DbGotop())

_cNivel  := Space(01)
_cOk     := 'S'
_cLogin2 := Space(15)
_dUltApr := Ctod(Space(08))

DbSelectArea("XDET")
Zap

clll := Alltrim(upper(cUserName))//'SILMARACD'

//If MsgYesNo('Executa rapido?')
 
	//--
	cAl := getnextalias()
	
	cQuery := "	SELECT *, "+;
			  "  (SELECT MAX(ZU_DATAPR) FROM "+RetSqlName("SZU")+" ZUX (NOLOCK)"+;
			  " WHERE ZU1.ZU_FILIAL=ZUX.ZU_FILIAL "+;
			  " AND   ZU1.ZU_NUM=ZUX.ZU_NUM "+;
			  " AND   ZU1.ZU_ITEM=ZUX.ZU_ITEM "+; 
			  " AND ZUX.ZU_STATUS='A' AND ZUX.D_E_L_E_T_ = '') AS DTULTAP "+;
			  " FROM "+RetSqlName("SZU")+" ZU1  (NOLOCK)" +;
			  " WHERE ZU1.ZU_LOGIN IN ( "+;
			  "     SELECT '"+Alltrim(clll)+"' "+;
			  "   UNION ALL "+;
			  "     SELECT ZV_LOGOR FROM "+RetSqlName("SZV") +" ZV  (NOLOCK)"+; 
			  "		WHERE ZV_LOGDE = '"+Alltrim(clll)+"' " +;
			  "		AND ZV_DATDE <= '"+dtos(DATE())+"' " +;
			  "		AND ZV_DATAT >= '"+dtos(DATE())+"' " +;
			  "     AND ZV.D_E_L_E_T_ = ''  "+;
			  "     AND ZV.ZV_FILIAL = '"+xFilial("SZV")+"' ) " +;
			  "	    AND ZU1.D_E_L_E_T_ = ' ' "+;
			  "     AND ZU1.ZU_FILIAL = '"+xFilial("SZU")+"' " +;
			  "	  AND NOT EXISTS (" +;
			  "		SELECT ZU2.ZU_NUM" +;
			  "		FROM "+RetSqlName("SZU")+" ZU2  (NOLOCK)" +;
			  "		WHERE ZU2.ZU_NUM+ZU2.ZU_ITEM = ZU1.ZU_NUM+ZU1.ZU_ITEM" +;
			  "		AND ZU2.D_E_L_E_T_ = ' '" +;
			  "		AND	(" +;
			  "			(ZU2.ZU_LOGIN <> ZU1.ZU_LOGIN" +;
			  "		AND ZU2.ZU_STATUS IN ('B','C'))" +;
			  "			OR" +;
			  "			(ZU2.ZU_STATUS = ' ' AND ZU2.ZU_NIVEL < ZU1.ZU_NIVEL )" +;
			  "	    )" +;
			  "	)  "
			
	TCQUERY cQuery NEW ALIAS "TMP1"
	
	While TMP1->(!eof())
	   
	    Incproc()
	    
		SC1->(DbSeek(xFilial("SC1")+TMP1->ZU_NUM+TMP1->ZU_ITEM))
		If SC1->(Found()) .AND. Empty(SC1->C1_RESIDUO) .AND. Empty(SC1->C1_PEDIDO)
			ApTitulo(UPPER(TMP1->(ZU_LOGIN)))
		Endif
		
		TMP1->(dbskip())
	Enddo
	
	TMP1->(dbclosearea())

Return(.T.)


Static Function ApTitulo(cLoginGrv)
Local _nUltPrc := 0

	RecLock("XDET",.T.)
	If TMP1->ZU_STATUS=="A"
		XDET->DT_MARCA := "Aprovado"
	Elseif TMP1->ZU_STATUS=="B"
		XDET->DT_MARCA := "Aguardar"
	Elseif TMP1->ZU_STATUS=="C"
		XDET->DT_MARCA := "Rejeitado"
	Elseif TMP1->ZU_STATUS==" "
		XDET->DT_MARCA := "Pendente"
	Endif	
	XDET->DT_NUM       := SC1->C1_NUM
	XDET->DT_ITEM      := SC1->C1_ITEM
	XDET->DT_NUMCT     := TMP1->ZU_NUMCT //numero do contrato
	XDET->DT_ITEMCT    := TMP1->ZU_ITEMCT	 //item do contrato
	XDET->DT_NUMPED    := TMP1->ZU_NUMPED //numero da autorizacao de entrga
	XDET->DT_ITEMPED   := TMP1->ZU_ITEMPED //item da autorizacao de entrga

	XDET->DT_PRODUTO   := SC1->C1_PRODUTO
	XDET->DT_DESCRI    := SC1->C1_DESCRI
	XDET->DT_QUANT     := SC1->C1_QUANT
	XDET->DT_VUNIT     := SC1->C1_VUNIT
	XDET->DT_LOGIN     := UPPER(cLoginGrv)
	XDET->DT_SOLICIT   := SC1->C1_SOLICIT
	XDET->DT_VALOR     := (SC1->C1_VUNIT * SC1->C1_QUANT)
	XDET->DT_EMISSAO   := SC1->C1_EMISSAO
	XDET->DT_ATENCAO   := IIF(TMP1->ZU_STATUS == 'B',"Aguardando",Space(10))
	XDET->DT_ANEXO     := Iif(!EMPTY(SC1->C1_ANEXO1),"Sim","  ")
	XDET->DT_ANEXO1    := SC1->C1_ANEXO1
	XDET->DT_ANEXO2    := SC1->C1_ANEXO2
	XDET->DT_ANEXO3    := SC1->C1_ANEXO3		
	XDET->DT_STATUS    := TMP1->ZU_STATUS			
	XDET->DT_OBS       := SC1->C1_OBS     	
	XDET->DT_ULTAPR    := STOD(TMP1->DTULTAP) //StoD(TMP1->ZU_DATAPR) //_dUltApr
	
	  //Dados do pedido de compra em aberto para aprovacao         
    If !Empty(TMP1->ZU_NUMCT)
       SC3->(DbSetOrder(1))
	   SC3->(DbSeek(xFilial("SC3")+TMP1->ZU_NUMCT + TMP1->ZU_ITEMCT ))
	   If SC3->(Found())
	      XDET->DT_QUANTP     := SC3->C3_QUANT
	      XDET->DT_VUNITP     := SC3->C3_PRECO
	      XDET->DT_VALORP     := (SC3->C3_PRECO * SC3->C3_QUANT)
       Endif
    Endif   
	
	SB1->(DbSeek(xFilial("SB1")+SC1->C1_PRODUTO))
	If SB1->(Found())
		If SB1->B1_GENERIC == '1'
			XDET->DT_VLRPC := SB1->B1_UPRC
		Endif	
	Endif
	MsUnlock("XDET")

Return

User Function fImpPend()

cabec1    := ""
cabec2    := ""
tamanho   := "G"
limite    := 220
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
titulo    := "Historico Aprovacao/Pendencias de Solicitacoes de Compras"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "SZ4"
nTipo     := 0
wnrel     := "NHCOM044"
nomeprog  := "NHCOM044"
cPerg     := "NHCO44"
nPag      := 1
m_pag     := 1

U_fFilPend()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrint("SZ3",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

rptStatus({||Imprime()},"Imprimindo...")

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif

MS_FLUSH() //Libera fila de relatorios em spool

XDET->(Dbgotop())

Return


Static Function Imprime()
Local _nVlrTot   := 0

XDET->(Dbgotop())
                        
Cabec1    := "Situacao       Nr.Sc    Item  Produto     Descricao do produto                                Quantidade V.Unit.Estimado         Total Solicit.   Emissao    Ult.Aprov.   Anexo Observacao"
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

While !XDET->(eof())
	
	If Prow() > 56
		nPag := nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif

	If (mv_par01 == 2 .AND. XDET->DT_STATUS <> " ") .or. ; // Pendente
	   (mv_par01 == 3 .AND. XDET->DT_STATUS <> "A") .or. ; // Aprovada
	   (mv_par01 == 4 .AND. XDET->DT_STATUS <> "B") .or. ; // Aguardando
	   (mv_par01 == 5 .AND. XDET->DT_STATUS <> "C") .or. ; // Rejeitada
	   (XDET->DT_NUM < mv_par02 .or. XDET->DT_NUM > mv_par03) .or. ; // filtra por numero
	   (XDET->DT_EMISSAO < mv_par04 .or. XDET->DT_EMISSAO > mv_par05) // filtra por data
		XDET->(DbSkip())	
		Loop
	Endif		

    _nVlrTot += XDET->DT_VALOR // Soma o total das pendencias
	@ Prow() + 1, 000 Psay 	XDET->DT_MARCA
	@ Prow()    , 015 Psay 	XDET->DT_NUM
	@ Prow()    , 024 Psay 	XDET->DT_ITEM
	@ Prow()    , 030 Psay 	Substr(XDET->DT_PRODUTO,1,10)
	@ Prow()    , 042 Psay 	XDET->DT_DESCRI
	@ Prow()    , 090 Psay 	XDET->DT_QUANT Picture "@E 9,999,999.9999"
	@ Prow()    , 106 Psay 	XDET->DT_VUNIT Picture "@E 999,999,999.99"
	@ Prow()    , 120 Psay 	XDET->DT_VALOR Picture "@E 999,999,999.99"

	@ Prow()    , 135 Psay 	Substr(XDET->DT_SOLICIT,1,10)
	@ Prow()    , 146 Psay 	XDET->DT_EMISSAO
	@ Prow()    , 157 Psay 	XDET->DT_ULTAPR 

	@ Prow()    , 170 Psay 	XDET->DT_ANEXO
	@ Prow()    , 176 Psay 	XDET->DT_OBS     
	
	XDET->(DbSkip())

Enddo
@ Prow() + 1,000 Psay __PrtThinLine()  
@ Prow() + 1,001 Psay "Total Geral :"
@ Prow()    ,120 Psay _nVlrTot Picture "@E 999,999,999.99"
@ Prow() + 1,000 Psay __PrtThinLine()  
Return


User Function fFilPend()
Local cCondic := ""
Local aStatus := {"",;
                  "XDET->DT_STATUS = ' '" ,; // Pendentes
				  "XDET->DT_STATUS = 'A'" ,; // Aprovada
				  "XDET->DT_STATUS = 'B'" ,; // Aguardando
				  "XDET->DT_STATUS = 'C'"}   // Rejeitada 
				
	If Pergunte("NHCO44",.T.) //ativa os parametros
        
        DBSELECTAREA("XDET")	

		cCondic := aStatus[mv_par01]
		cCondic += Iif(mv_par01>1,' .AND. ','')
		cCondic += " XDET->DT_NUM >= '"+mv_par02+"' .AND. XDET->DT_NUM <= '"+mv_par03+"'"
		cCondic += " .AND. DTOS(XDET->DT_EMISSAO) >= '"+DTOS(mv_par04)+"' .AND. DTOS(XDET->DT_EMISSAO) <= '"+DTOS(mv_par05)+"'"
		
		SET FILTER TO &(cCondic)

	Endif 
			
	XDET->(Dbgotop())
	
Return

//Marca todas as notas
Static Function fTdSc(lMarca)

   XDET->(DbGoTop())
   While !XDET->(eof())     
      
      RecLock("XDET")
         XDET->OK := Iif(lMarca,cMarca,space(2))
      MsUnlock("XDET")
      XDET->(Dbskip())
   Enddo   
   
   XDET->(dbgotop())
   
   oMark:oBrowse:Refresh()
Return