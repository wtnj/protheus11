#INCLUDE 'topconn.ch'       
#INCLUDE 'RWMAKE.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST133    ºAutor  ³João Felipe da Rosaº Data ³  11/11/08  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ IMPORTA NOTA DE ENTRADA P/ QUALITY MANUALMENTE             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHEST133()

SetPrvt("cCadastro,aRotina,_cArqDbf,cARQEXP,cDoc,cLoja,cFornece,cSerie,dData,_lArq")
SetPrvt("_cFor,_cLoja,cQuery,cNovaLinha,lFlag,_cArqNtx")

cARQEXP    := "\SYSTEM\IMPORT.TXT"
_cArqDBF   := SPACE(12) 
_lArq      := .F.     
lFlag      := .F.
cNovaLinha := Chr(13) + Chr(10)

cCadastro := OemToAnsi("Importa NF Quality")
aRotina := {{ "Pesquisa"   ,"Axpesqui",0,1},;
            { "Importa NF" ,'U_fImportNF()',0,2}}

DbSelectArea("SF1")
("SF1")->(DbSetOrder(1))
DbGoTop()
	            
mBrowse(06,01,22,75,"SF1",,)    

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PARA IMPORTACAO DA NOTA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function fImportNF()

cDoc     := SF1->F1_DOC
cSerie   := SF1->F1_SERIE 
cFornece := SF1->F1_FORNECE 
cLoja    := SF1->F1_LOJA          
dData    := Dtos(SF1->F1_DTDIGIT)
   
Processa({|| Gerando() }, "Selecionando Dados p/ Importacao no Quality")

// Retorna qdo oTES nao atualiza estqoue
If lFlag
   Return
Endif

If _lArq
	dbSelectArea("QEK")
	dbSelectArea("QEP")
  	QIEA183() // Chama função do siga p/ importação no Quality
	dbSelectArea("QEP")
	dbCloseArea()
	
	dbSelectArea("QEK")
	DbCloseArea()

Else
   TMP->(DbCloseArea())
Endif
	
If File(_cArqNtx+OrdBagExt())
   Ferase(_cArqNtx+OrdBagExt())
Endif   

If File( _cArqDBF )   
   Ferase(_cArqDBF+GetDBExtension())
   Ferase(_cArqDBF+OrdBagExt())
Endif   

// Rotina para deletar a tabela QEP, pois se trata de uma tabela temporaria
cQuery := "DELETE " +  RetSqlName( 'QEP' )
If TCSQLExec(cQuery) < 0 //Executa a query
   cErro := TCSQLERROR()
   ALERT(cErro)
Endif   

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÌ2Ü¿
//³ FUNCAO COPIADA DE NHEST003 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÌ2ÜÙ
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
AADD(_aDBF,{"NTFISC"     ,"C", 09,0})         // Nota Fiscal
AADD(_aDBF,{"SERINF"     ,"C", 03,0})         // Serie da Nota Fiscal
AADD(_aDBF,{"ITEMNF"     ,"C", 04,0})         // Item da nota fiscal
AADD(_aDBF,{"DTNFIS"     ,"C", 08,0})         // Data da Nota Fiscal
AADD(_aDBF,{"TIPDOC"     ,"C", 06,0})         // Tipo de Documento
AADD(_aDBF,{"CERFOR"     ,"C", 12,0})         // Numero de Certificado
AADD(_aDBF,{"DIASAT"     ,"C", 04,0})         // Dias em Atraso
AADD(_aDBF,{"SOLIC"      ,"C", 10,0})         // Codigo do Solicitante
AADD(_aDBF,{"PRECO"      ,"C", 12,0})         // Preco
AADD(_aDBF,{"EXCLUI"     ,"C", 01,0})         // Indica se a entrada sera excluisa ou nao

DbCreate(_cArqDBF,_aDBF)
DbUseArea(.T.,,_cArqDBF,"DBF",.F.)           

// Criacao de Indice Temporario
_cArqNtx := CriaTrab(NIL,.f.)
_cOrdem  := "DBF->NTFISC+DBF->SERINF+DBF->PRODUT"
IndRegua("DBF",_cArqNtx,_cOrdem) //"Selecionando Registros..."

Return  


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO QUE GERA O ARQUIVO TXT ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Gerando()
Local _lErro := .F.

/*                          
cQuery := "SELECT D1.D1_DOC,D1.D1_FORNECE,D1.D1_LOJA,D1.D1_COD,D1.D1_DTDIGIT,D1.D1_LOTECTL,"
cQuery += "D1.D1_QUANT,D1.D1_PEDIDO,D1.D1_SERIE,D1.D1_EMISSAO,D1.D1_TOTAL,D1.D1_EXPORT," 
cQuery += "D1.D1_TES,D1.D1_ITEM,F4.F4_CODIGO,F4.F4_ESTOQUE,"
cQuery += "F1.F1_TIPO,F1.F1_HORA,C7.C7_NUM,C7.C7_DATPRF,B1.B1_TIPO"
cQuery += " FROM " +  RetSqlName( 'SD1' ) +" D1, " +  RetSqlName( 'SF1' ) +" F1, "
cQuery += RetSqlName( 'SC7' ) +" C7, "+ RetSqlName( 'SF4' ) +" F4, "+ RetSqlName( 'SB1' ) +" B1 "
cQuery += " WHERE D1.D1_DOC = '" + cDoc + "' AND  D1.D1_LOJA = '" + cLoja + "' AND"
cQuery += " D1.D1_SERIE = '" + cSerie + "' AND D1.D1_FORNECE = '" + cFornece + "' AND" 
cQuery += " D1.D1_DTDIGIT = '" + dData + "' AND " 	
cQuery += " D1.D1_DOC = F1.F1_DOC AND F4.F4_CODIGO = D1.D1_TES AND B1.B1_TIPO IN ('CC','MC','CP','MP','MA') AND " 
cQuery += " F4.D_E_L_E_T_ =  ' ' AND F1.F1_TIPO <> 'C' AND"  
cQuery += " B1.B1_COD = D1.D1_COD AND B1.D_E_L_E_T_ = ' ' AND F4.F4_CODIGO <> '193' AND"     
cQuery += " D1.D1_SERIE = F1.F1_SERIE  AND D1.D1_FORNECE = F1.F1_FORNECE AND"
cQuery += " D1.D1_LOJA = F1.F1_LOJA AND F1.D_E_L_E_T_ = ' ' AND"   
cQuery += " D1.D_E_L_E_T_ = ' ' AND C7.D_E_L_E_T_ = ' ' AND D1.D1_EXPORT <> 'S' AND"
cQuery += " D1.D1_PEDIDO *= C7.C7_NUM AND D1.D1_FORNECE *= C7.C7_FORNECE AND"
cQuery += " D1.D1_LOJA *= C7.C7_LOJA"
cQuery += " AND D1.D1_COD *= C7.C7_PRODUTO AND D1.D1_ITEM *= C7.C7_ITEM"
cQuery += " ORDER BY D1.D1_DOC ASC"    
*/

cQuery := " SELECT D1.D1_DOC,D1.D1_FORNECE,D1.D1_LOJA,D1.D1_COD,D1.D1_DTDIGIT,D1.D1_LOTECTL, D1.D1_QUANT,D1.D1_PEDIDO,D1.D1_SERIE,D1.D1_EMISSAO,D1.D1_TOTAL,D1.D1_EXPORT, " 
cQuery += " D1.D1_TES,D1.D1_ITEM,F4.F4_CODIGO,F4.F4_ESTOQUE, F1.F1_TIPO,F1.F1_HORA,C7.C7_NUM,C7.C7_DATPRF,B1.B1_TIPO "

cQuery += " FROM " +  RetSqlName( 'SD1' ) +" D1 (NOLOCK)"

cQuery += " INNER JOIN " +RetSqlName('SF1') + " F1 (NOLOCK) "
cQuery += " ON  F1.F1_FILIAL  = '" + xFilial('SF1') + "' "
cQuery += " AND F1.F1_TIPO    <> 'C' "
cQuery += " AND F1.F1_DOC     = D1.D1_DOC "
cQuery += " AND F1.F1_SERIE   = D1.D1_SERIE "
cQuery += " AND F1.F1_FORNECE = D1.D1_FORNECE "
cQuery += " AND F1.F1_LOJA    = D1.D1_LOJA "
cQuery += " AND F1.D_E_L_E_T_ = '' "

cQuery += " INNER JOIN " + RetSqlName('SF4')+ " F4 (NOLOCK) "
cQuery += " ON  F4.F4_FILIAL  = '" + xFilial('SF4')+ "' "
cQuery += " AND F4.F4_CODIGO  = D1.D1_TES "
cQuery += " AND F4.F4_CODIGO  <> '193' "
cQuery += " AND F4.D_E_L_E_T_ = '' "

cQuery += " INNER JOIN " + RetSqlName('SB1')+ " B1 (NOLOCK) "
cQuery += " ON  B1.B1_FILIAL  = '" + xFilial('SB1') + "' "
cQuery += " AND B1.B1_TIPO    IN ( 'CC', 'MC', 'CP', 'MP', 'MA' ) "
cQuery += " AND B1.B1_COD     = D1.D1_COD "
cQuery += " AND B1.D_E_L_E_T_ = '' "

cQuery += " LEFT JOIN " + RetSqlName('SC7') + " C7 (NOLOCK) "
cQuery += " ON  C7.C7_FILIAL  = '" + xFilial('SC7') + "' "
cQuery += " AND C7.C7_NUM     = D1.D1_PEDIDO "
cQuery += " AND C7.C7_FORNECE = D1.D1_FORNECE "
cQuery += " AND C7.C7_LOJA    = D1.D1_LOJA "
cQuery += " AND C7.C7_PRODUTO = D1.D1_COD "
cQuery += " AND C7.C7_ITEM    = D1.D1_ITEM "
cQuery += " AND C7.D_E_L_E_T_ = '' "

cQuery += " WHERE D1.D1_FILIAL  = '" + xFilial('SD1') + "' "
cQuery += " AND   D1.D1_DOC     = '" + cDoc + "' "
cQuery += " AND   D1.D1_LOJA    = '" + cLoja + "' "
cQuery += " AND   D1.D1_SERIE   = '" + cSerie + "' "
cQuery += " AND   D1.D1_FORNECE = '" + cFornece + "' " 
cQuery += " AND   D1.D1_DTDIGIT = '" + dData + "' " 	
cQuery += " AND   D1.D_E_L_E_T_ = '' "
cQuery += " AND   D1.D1_EXPORT  <> 'S' "

cQuery += " ORDER BY D1.D1_DOC ASC "    


//MemoWrit('C:\TEMP\EST003.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"
TcSetField("TMP","D1_DTDIGIT","D")  // Muda a data de digitaçao de string para date    
TcSetField("TMP","C7_DATPRF","D") // Muda a data de preferencia de string para date

TMP->(DBGotop())            
If Empty(TMP->D1_DOC)
   MsgBox("Atencao Nao Existem Registros p/ Serem Importados","Atencao","STOP")   
   lFlag := .T.
   DbSelectArea("TMP")
   DbCloseArea()
   Return
Endif
fCriaDBF()  // Cria arquivo temporarios para importacao do quality


SA5->(DbSetOrder(1))//filial+fornece+loja+produto
QE6->(DbSetOrder(1))//filial+PRODUTO +REV
While !TMP->(EOF())                              
    _lErro := .T.                                                             
    
   If SM0->M0_CODIGO == 'NH' .And. TMP->D1_FORNECE$"000184" .And. TMP->D1_LOJA$"01"
      _cFor  := "000666" //fornecedor whb fundicao
      _cLoja := "01"     //loja
   Else
      _cFor  := TMP->D1_FORNECE //fornecedor whb fundicao
      _cLoja := TMP->D1_LOJA    //loja
	      
   Endif    
    
   // verifica se o produto tem amarraca produto x fornecedor                
   SA5->(DbSeek(xFilial("SA5")+_cFor+_cLoja+TMP->D1_COD))
   If !SA5->(Found())
       alert("O arquivo não foi gerado. Produto não tem amarração com fornecedor")             
       _lErro := .F.
   Endif        
   
   QE6->(DbSeek(xFilial("QE6")+TMP->D1_COD))
   If !QE6->(Found())
       alert("O arquivo não foi gerado. Produto não tem amarração com fornecedor")             
       _lErro := .F.                
   Endif        
   
   If _lErro
	   If DBF->(DbSeek(TMP->D1_DOC+TMP->D1_SERIE+TMP->D1_COD))
	   
	      RecLock("DBF",.F.)
			DBF->TAMLOT := Transform(Val(DBF->TAMLOT)+TMP->D1_QUANT,"@e 99999999")
			DBF->TAMAMO := Transform(val(DBF->TAMAMO)+TMP->D1_QUANT,"@e 99999999")
		  MsUnlock("DBF")   
	   Else
          _lArq := .T.
	          
	      RecLock("DBF",.T.)
	        DBF->FORNEC := _cFor
			DBF->LOJFOR := _cLoja
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
		  	DBF->CERFOR := "N/A" //TMP->D1_DOC+TMP->D1_ITEM  //VERIFICAR?
		  	If Empty(TMP->C7_DATPRF)
		    	DBF->DIASAT := SPACE(04)
		    Else 
		    	DBF->DIASAT := STRZERO(TMP->D1_DTDIGIT  - TMP->C7_DATPRF,4)   
		    Endif 	
		  	DBF->SOLIC  := Space(06)
			DBF->PRECO  := Transform(TMP->D1_TOTAL,"@e 999999999.99")
		  	DBF->EXCLUI := Space(01)
		  	DBF->ITEMNF := TMP->D1_ITEM
		   MsUnlock("DBF")
	   Endif
   Endif //fim do SA5     
   
   TMP->(DbSkip())
Enddo

If _lArq //se encontrou algum registro
   cARQ  := FCreate(cARQEXP)
   ProcRegua(DBF->(RecCount()))
   DBF->(DbGoTop())
   While !DBF->(eof())     
     
      IncProc("Gerando Arquivo para Importacao")
	  // Gera arquivo texto para importacao no quality
	  FWrite(cArq,(DBF->(FORNEC+LOJFOR+PRODUT+DTENT+HRENTR+LOTE+DOCENT+TAMLOT+TAMAMO+PEDIDO+NTFISC+SERINF+ITEMNF+DTNFIS+TIPDOC+CERFOR+DIASAT+SOLIC+PRECO+EXCLUI)+cNovaLinha))
      DBF->(Dbskip())
   EndDo    
   
	Alert("Arquivo gerado")

   FClose(cARQ)         
   DbSelectArea("TMP")
   DbCloseArea()
Endif

If	Select("DBF") > 0
   DbSelectArea("DBF")
   DbCloseArea()
Endif      


If	Select("TMP") > 0
   DbSelectArea("TMP")
   DbCloseArea()
Endif      

Return