/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST003 ³Autor  ³ Alexandre R. Bento    ³ Data ³ 26/02/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera o arquivo P/ Importacao no Quality                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Estoque                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NHEST003(cPar01) // Recebe parametro qdo é chamada pelo pto de entrada SF1100I

SetPrvt("_cArqDbf, cQuery,cNova,cARQEXP ,cARQ, _aDBF,cDoc,cLoja,cFornece,cSerie,cControl,nQtdeReg,cErro,dData")

cControl   := cPar01  // Pega a passagem do parametro
_cArqDBF   := SPACE(12) 
cNova      := Chr(13) +" "+ Chr(10)
cARQEXP    := "\SIGAADV\QUALITY\IMPORT.TXT"
                                                           
If !Empty(cControl)
   cDoc     := SF1->F1_DOC
   cSerie   := SF1->F1_SERIE 
   cFornece := SF1->F1_FORNECE 
   cLoja    := SF1->F1_LOJA          
   dData    := Dtos(SF1->F1_DTDIGIT)
Endif

Processa({|| Gerando() }, "Selecionando Dados p/ Importacao no Quality")
Processa({|| fGera() }, "Gerando Dados p/ Importacao no Quality")


If File( _cArqDBF )   
//   fErase(_cArqDBF)  // Deleta arquivo de dados temporario
   Ferase(_cArqDBF+GetDBExtension())
   Ferase(_cArqDBF+OrdBagExt())
Endif   

QIEA183() // Chama função do siga p/ importação no Quality

cQuery := "UPDATE SD1NH0"
cQuery := cQuery + " SET D1_EXPORT = 'S'" 
cQuery := cQuery + " FROM " +  RetSqlName( 'SD1' ) +" D1, " 
cQuery := cQuery + RetSqlName( 'SF4' ) +" F4"

If !Empty(cControl)                                          
   cQuery := cQuery + " WHERE D1.D1_DOC = '" + cDoc + "' AND  D1.D1_LOJA = '" + cLoja + "' AND"
	cQuery := cQuery + " D1.D1_SERIE = '" + cSerie + "' AND D1.D1_FORNECE = '" + cFornece + "' AND" 
	cQuery := cQuery + " D1.D1_DTDIGIT = '" + dData + "' AND F4.F4_CODIGO = D1.D1_TES " 
Else // Entra nesta quando é executado apartir do MENU 
	cQuery := cQuery + " WHERE F4.F4_CODIGO = D1.D1_TES" 
Endif
	 
cQuery := cQuery + " AND F4.F4_ESTOQUE = 'S' AND F4.D_E_L_E_T_ <> '*' AND F4.F4_CODIGO <> '193'"        
cQuery := cQuery + " AND D1.D_E_L_E_T_ <> '*' AND  D1.D1_EXPORT <> 'S'"


//CSQLExec(cQuery) //Executa a query	

If TCSQLExec(cQuery) < 0 //Executa a query
   cErro := TCSQLERROR()
   ALERT(cErro)
Endif  


// Rotina para atualizar o lote no inspecao de entrada, pois o mesmo esta gerando
// LOTE + PARAMETRO MV_PRXLOTE

cQuery := "UPDATE QEKNH0"
cQuery := cQuery + " SET QEK_LOTE = D1.D1_LOTECTL" 
cQuery := cQuery + " FROM " +  RetSqlName( 'SD1' ) +" D1, " + RetSqlName( 'QEK' ) +" QEK "
If !Empty(cControl)                                          
   cQuery := cQuery + " WHERE D1.D1_DOC = '" + cDoc + "' AND  D1.D1_LOJA = '" + cLoja + "' AND"
	cQuery := cQuery + " D1.D1_SERIE = '" + cSerie + "' AND D1.D1_FORNECE = '" + cFornece + "' AND" 
	cQuery := cQuery + " D1.D1_DTDIGIT = '" + dData + "' AND D1.D1_EMISSAO > '20030501' AND"     
Else // Entra nesta quando é executado apartir do MENU 
	cQuery := cQuery + " WHERE D1.D1_EMISSAO > '20030501' AND"     
Endif

cQuery := cQuery + " LEN(QEK.QEK_LOTE) > 6  AND D1.D1_LOTECTL <> ' ' "     
cQuery := cQuery + " AND D1.D_E_L_E_T_ <> '*' AND D1.D1_LOTECTL <> QEK.QEK_LOTE"
cQuery := cQuery + "	AND D1.D1_DOC = QEK.QEK_NTFISC AND D1.D1_SERIE = QEK.QEK_SERINF"
cQuery := cQuery + " AND D1.D1_COD = QEK.QEK_PRODUT AND D1.D1_FORNECE = QEK.QEK_FORNEC" 
cQuery := cQuery + " AND D1.D1_LOJA = QEK.QEK_LOJFOR AND D1.D1_DTDIGIT = QEK.QEK_DTENTR"
cQuery := cQuery + " AND D1.D1_QUANT = QEK.QEK_TAMLOT"
cQuery := cQuery + " AND QEK.D_E_L_E_T_ <> '*' " 	

If TCSQLExec(cQuery) < 0 //Executa a query
   cErro := TCSQLERROR()
   ALERT(cErro)
Endif   

		
Return

Static Function Gerando()
                          
cQuery := "SELECT D1.D1_DOC,D1.D1_FORNECE,D1.D1_LOJA,D1.D1_COD,D1.D1_DTDIGIT,D1.D1_LOTECTL,"
cQuery := cQuery + "D1.D1_QUANT,D1.D1_PEDIDO,D1.D1_SERIE,D1.D1_EMISSAO,D1.D1_TOTAL,D1.D1_EXPORT," 
cQuery := cQuery + "D1.D1_TES,F4.F4_CODIGO,F4.F4_ESTOQUE,D1.D1_VUNIT,"
cQuery := cQuery + "F1.F1_TIPO,F1.F1_HORA,C7.C7_NUM,C7.C7_DATPRF,B1.B1_TIPO"
cQuery := cQuery + " FROM " +  RetSqlName( 'SD1' ) +" D1, " +  RetSqlName( 'SF1' ) +" F1, "
cQuery := cQuery + RetSqlName( 'SC7' ) +" C7, "+ RetSqlName( 'SF4' ) +" F4, "+ RetSqlName( 'SB1' ) +" B1 "
If !Empty(cControl)   // Entra nesta quando é executado apartir do ponto de entrada SF1100I                              
   cQuery := cQuery + " WHERE D1.D1_DOC = '" + cDoc + "' AND  D1.D1_LOJA = '" + cLoja + "' AND"
	cQuery := cQuery + " D1.D1_SERIE = '" + cSerie + "' AND D1.D1_FORNECE = '" + cFornece + "' AND" 
   cQuery := cQuery + " D1.D1_DTDIGIT = '" + dData + "' AND " 	
	cQuery := cQuery + " D1.D1_DOC = F1.F1_DOC AND F4.F4_CODIGO = D1.D1_TES AND B1.B1_TIPO IN ('CC','MC') AND " 
Else  // Entra nesta quando é executado apartir do MENU 
	cQuery := cQuery + " WHERE D1.D1_DOC = F1.F1_DOC AND F4.F4_CODIGO = D1.D1_TES AND B1.B1_TIPO IN ('CC','MC','CP','MP') AND"
Endif	

cQuery := cQuery + " F4.F4_ESTOQUE = 'S' AND F4.D_E_L_E_T_ <> '*' AND "  
cQuery := cQuery + " B1.B1_COD = D1.D1_COD AND B1.D_E_L_E_T_ <> '*' AND F4.F4_CODIGO <> '193' AND"     
cQuery := cQuery + " D1.D1_SERIE = F1.F1_SERIE  AND D1.D1_FORNECE = F1.F1_FORNECE AND"
cQuery := cQuery + " D1.D1_LOJA = F1.F1_LOJA AND F1.D_E_L_E_T_ <> '*' AND"   
cQuery := cQuery + " D1.D_E_L_E_T_ <> '*' AND C7.D_E_L_E_T_ <> '*' AND D1.D1_EXPORT <> 'S' AND"
cQuery := cQuery + " D1.D1_PEDIDO *= C7.C7_NUM AND D1.D1_FORNECE *= C7.C7_FORNECE AND"
cQuery := cQuery + " D1.D1_LOJA *= C7.C7_LOJA"
cQuery := cQuery + " ORDER BY D1.D1_DOC ASC"    

//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"
TcSetField("TMP","D1_DTDIGIT","D")  // Muda a data de digitaçao de string para date    
TcSetField("TMP","C7_DATPRF","D") // Muda a data de preferencia de string para date

DbSelectArea("TMP")

TMP->(DBGotop())            
If Empty(TMP->D1_DOC)
   MsgBox("Atencao Nao Existem Registros p/ Serem Importados","Atencao","STOP")   
   DbSelectArea("TMP")
   DbCloseArea()
   Return
Endif
fCriaDBF()  // Cria arquivo temporarios para importacao do quality
While !TMP->(EOF())
   RecLock("DBF",.T.)
   DBF->FORNEC := TMP->D1_FORNECE
	DBF->LOJFOR := TMP->D1_LOJA  
	DBF->PRODUT := TMP->D1_COD
	DBF->DTENT  := DTOS(TMP->D1_DTDIGIT)
	DBF->HRENTR := TMP->F1_HORA
	DBF->LOTE   := TMP->D1_LOTECTL
	DBF->DOCENT := TMP->D1_DOC
	DBF->TAMLOT := Transform(TMP->D1_QUANT,"@e 99999999")
	DBF->TAMAMO := Transform(TMP->D1_QUANT,"@e 99999999")
	DBF->PEDIDO := TMP->D1_PEDIDO
	DBF->NTFISC := TMP->D1_DOC
	DBF->SERINF := TMP->D1_SERIE
	DBF->DTNFIS := TMP->D1_EMISSAO
	DBF->TIPDOC := TMP->F1_TIPO
  	DBF->CERFOR := Space(12)
  	If Empty(TMP->C7_DATPRF)
    	DBF->DIASAT := SPACE(04)
   Else 
    	DBF->DIASAT := STRZERO(TMP->D1_DTDIGIT  - TMP->C7_DATPRF,4)   
   Endif 	
  	DBF->SOLIC  := Space(06)
	DBF->PRECO  := Transform(TMP->D1_VUNIT,"@e 9999999999.99")
  	DBF->EXCLUI := Space(01)
   MsUnlock("DBF")
     
   TMP->(DbSkip())
Enddo

Return
      

Static Function fGera()
    cARQ := FCreate(cARQEXP)
	ProcRegua(DBF->(RecCount()))
	DBF->(DbGoTop())
	While !DBF->(eof())     
     
		IncProc("Gerando Arquivo para Importacao")
	   // Gera arquivo texto para importacao no quality
	   FWrite(cArq,(DBF->(FORNEC+LOJFOR+PRODUT+DTENT+HRENTR+LOTE+DOCENT+TAMLOT+TAMAMO+PEDIDO+NTFISC+SERINF+DTNFIS+TIPDOC+CERFOR+DIASAT+SOLIC+PRECO+EXCLUI)+cNova))
      DBF->(Dbskip())
	EndDo    

	FClose(cARQ)         
    DbSelectArea("TMP")
    DbCloseArea()
    DbSelectArea("DBF")
    DbCloseArea()
Return


Static Function fCriaDBF()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando Arquivo Temporario para posterior impressao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cArqDBF  := CriaTrab(NIL,.f.)
_cArqDBF += ".DBF"
_aDBF := {}

AADD(_aDBF,{"FORNEC"     ,"C", 06,0})         // Fornecedor
AADD(_aDBF,{"LOJFOR"     ,"C", 02,0})         // Loja
AADD(_aDBF,{"PRODUT"     ,"C", 15,0})         // Produto
AADD(_aDBF,{"DTENT"      ,"C", 08,0})         // Data Entrada
AADD(_aDBF,{"HRENTR"     ,"C", 05,0})         // Hora de Entrada
AADD(_aDBF,{"LOTE"       ,"C", 16,0})         // LOTE
AADD(_aDBF,{"DOCENT"     ,"C", 16,0})         // Documento de Entrada
AADD(_aDBF,{"TAMLOT"     ,"C", 08,0})         // Tamanho do Lote
AADD(_aDBF,{"TAMAMO"     ,"C", 08,0})         // Tamanho da Amostra
AADD(_aDBF,{"PEDIDO"     ,"C", 10,0})         // Pedido
AADD(_aDBF,{"NTFISC"     ,"C", 06,0})         // Nota Fiscal
AADD(_aDBF,{"SERINF"     ,"C", 03,0})         // Serie da Nota Fiscal
AADD(_aDBF,{"DTNFIS"     ,"C", 08,0})         // Data da Nota Fiscal
AADD(_aDBF,{"TIPDOC"     ,"C", 06,0})         // Tipo de Documento
AADD(_aDBF,{"CERFOR"     ,"C", 12,0})         // Numero de Certificado
AADD(_aDBF,{"DIASAT"     ,"C", 04,0})         // Dias em Atraso
AADD(_aDBF,{"SOLIC"      ,"C", 06,0})         // Codigo do Solicitante
AADD(_aDBF,{"PRECO"      ,"C", 12,2})         // Preco
AADD(_aDBF,{"EXCLUI"     ,"C", 01,0})         // Indica se a entrada sera excluida ou nao

DbCreate(_cArqDBF,_aDBF)
DbUseArea(.T.,,_cArqDBF,"DBF",.F.) 

Return