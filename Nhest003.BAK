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
#include "AP5MAIL.CH"
User Function NHEST003(cPar01) // Recebe parametro qdo é chamada pelo pto de entrada SF1100I

SetPrvt("_cArqDbf, cQuery, _aDBF,cDoc,cLoja,cFornece,cSerie,cControl,cErro,dData")
SetPrvt("lFlag,_cArqNtx,_cOrdem,_lArq,_cFor,_cLoja,aVetTmp")

cControl    := cPar01  // Pega a passagem do parametro
_cArqDBF    := SPACE(12) 
lFlag       := .F.
_lArq       := .F.
aVetTmp     := {}
lMsErroAuto := .F.                                                           
_cUsr       := ALLTRIM(CUSERNAME)
_cSolic     := "999999"
_cArqNtx    := ""

If !Empty(cControl)

	If !INCLUI
		Return
	EndIf


   cDoc     := SF1->F1_DOC
   cSerie   := SF1->F1_SERIE 
   cFornece := SF1->F1_FORNECE 
   cLoja    := SF1->F1_LOJA          
   dData    := Dtos(SF1->F1_DTDIGIT)
Endif

Processa({|| Gerando() }, "Selecionando Dados p/ Importacao no Quality")

/*
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
	/*
	cQuery := "UPDATE "+  RetSqlName( 'SD1' ) 
	cQuery += " SET D1_EXPORT = 'S'" 
	cQuery += " FROM " +  RetSqlName( 'SD1' ) +" D1, " 
	cQuery += RetSqlName( 'SF4' ) +" F4"
	
	If !Empty(cControl)                                          
	   cQuery += " WHERE D1.D1_DOC = '" + cDoc + "' AND  D1.D1_LOJA = '" + cLoja + "' AND"
		cQuery += " D1.D1_SERIE = '" + cSerie + "' AND D1.D1_FORNECE = '" + cFornece + "' AND" 
		cQuery += " D1.D1_DTDIGIT = '" + dData + "' AND F4.F4_CODIGO = D1.D1_TES " 
	Else // Entra nesta quando é executado apartir do MENU 
		cQuery += " WHERE F4.F4_CODIGO = D1.D1_TES" 
	Endif
	cQuery += " AND  F4.D_E_L_E_T_ =  ' ' AND F4.F4_CODIGO <> '193'"        
	cQuery += " AND D1.D_E_L_E_T_ = ' ' AND  D1.D1_EXPORT <> 'S'"
	cQuery += " AND EXISTS (SELECT * FROM " + RetSqlName( 'QEK' ) +" QEK " 
	cQuery += " WHERE QEK.D_E_L_E_T_ = ' '"
	cQuery += " AND QEK.QEK_NTFISC = D1.D1_DOC"
	cQuery += " AND QEK.QEK_SERINF = D1.D1_SERIE"
	cQuery += " AND QEK.QEK_FORNEC = D1.D1_FORNECE"
	cQuery += " AND QEK.QEK_LOJFOR = D1.D1_LOJA"
	cQuery += " AND QEK.QEK_PRODUT = D1.D1_COD"
	cQuery += " AND QEK.QEK_DTENTR = D1.D1_DTDIGIT"
	cQuery += " AND QEK.QEK_LOTE   = D1.D1_LOTECTL"
	cQuery += " AND QEK.QEK_TAMLOT = D1.D1_QUANT)"	
	
	TCSQLExec(cQuery) //Executa a query	
	
	If TCSQLExec(cQuery) < 0 //Executa a query
	   cErro := TCSQLERROR()
	   ALERT(cErro)
	Endif  
	
	// Rotina para atualizar o lote no inspecao de entrada, pois o mesmo esta gerando
	// LOTE + PARAMETRO MV_PRXLOTE
	
	cQuery := "UPDATE QEKNH0"
	cQuery += " SET QEK_LOTE = D1.D1_LOTECTL" 
	cQuery += " FROM " +  RetSqlName( 'SD1' ) +" D1, " + RetSqlName( 'QEK' ) +" QEK "
	If !Empty(cControl)                                          
	   cQuery += " WHERE D1.D1_DOC = '" + cDoc + "' AND  D1.D1_LOJA = '" + cLoja + "' AND"
		cQuery += " D1.D1_SERIE = '" + cSerie + "' AND D1.D1_FORNECE = '" + cFornece + "' AND" 
		cQuery += " D1.D1_DTDIGIT = '" + dData + "' AND D1.D1_EMISSAO > '20030501' AND"     
	Else // Entra nesta quando é executado apartir do MENU 
		cQuery += " WHERE D1.D1_EMISSAO > '20070801' AND"     
	Endif
	
	cQuery += " LEN(QEK.QEK_LOTE) > 6  AND D1.D1_LOTECTL <> ' ' "     
	cQuery += " AND D1.D_E_L_E_T_ = ' ' AND D1.D1_LOTECTL <> QEK.QEK_LOTE"
	cQuery += " AND D1.D1_DOC = QEK.QEK_NTFISC AND D1.D1_SERIE = QEK.QEK_SERINF"
	cQuery += " AND D1.D1_COD = QEK.QEK_PRODUT AND D1.D1_FORNECE = QEK.QEK_FORNEC" 
	cQuery += " AND D1.D1_LOJA = QEK.QEK_LOJFOR AND D1.D1_DTDIGIT = QEK.QEK_DTENTR"
	cQuery += " AND D1.D1_QUANT = QEK.QEK_TAMLOT"
	cQuery += " AND QEK.D_E_L_E_T_ = ' ' " 	
	
	If TCSQLExec(cQuery) < 0 //Executa a query
	   cErro := TCSQLERROR()
	   ALERT(cErro)
	Endif   


Else
   TMP->(DbCloseArea())
Endif
*/	

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

Static Function Gerando()
Local _lErro := .F.
                          
/*
cQuery := "SELECT D1.D1_DOC,D1.D1_FORNECE,D1.D1_LOJA,D1.D1_COD,D1.D1_DTDIGIT,D1.D1_LOTECTL,"
cQuery += "D1.D1_QUANT,D1.D1_PEDIDO,D1.D1_SERIE,D1.D1_EMISSAO,D1.D1_TOTAL,D1.D1_EXPORT," 
cQuery += "D1.D1_TES,D1.D1_ITEM,F4.F4_CODIGO,F4.F4_ESTOQUE,"
cQuery += "F1.F1_TIPO,F1.F1_HORA,C7.C7_NUM,C7.C7_DATPRF,B1.B1_TIPO,F1.F1_ESPECIE"
cQuery += " FROM " +  RetSqlName( 'SD1' ) +" D1 (NOLOCK), " +  RetSqlName( 'SF1' ) +" F1 (NOLOCK), "
cQuery += RetSqlName( 'SC7' ) +" C7 (NOLOCK), "+ RetSqlName( 'SF4' ) +" F4 (NOLOCK), "+ RetSqlName( 'SB1' ) +" B1 (NOLOCK)"
cQuery += " WHERE "

If !Empty(cControl)   // Entra nesta quando é executado apartir do ponto de entrada SF1100I                              
   cQuery += " D1.D1_DOC = '" + cDoc + "' AND  D1.D1_LOJA = '" + cLoja + "' "
   cQuery += " AND D1.D1_SERIE = '" + cSerie + "' AND D1.D1_FORNECE = '" + cFornece + "' " 
   cQuery += " AND D1.D1_DTDIGIT = '" + dData + "' AND "
Endif	

cQuery += " D1.D1_DOC = F1.F1_DOC AND F4.F4_CODIGO = D1.D1_TES AND B1.B1_TIPO IN ('CC','MC','CP','MP','MA','BN','PW') "
cQuery += " AND F4.D_E_L_E_T_ = ' ' AND F4.F4_FILIAL = '"+xFilial("SF4")+"'"
cQuery += " AND B1.D_E_L_E_T_ = ' ' AND B1.B1_FILIAL = '"+xFilial("SB1")+"'"
cQuery += " AND F1.D_E_L_E_T_ = ' ' AND F1.F1_FILIAL = '"+xFilial("SF1")+"'"
cQuery += " AND C7.D_E_L_E_T_ = ' ' AND C7.C7_FILIAL = '"+xFilial("SC7")+"'"
cQuery += " AND D1.D_E_L_E_T_ = ' ' AND D1.D1_FILIAL = '"+xFilial("SD1")+"'"
cQuery += " AND F1.F1_TIPO <> 'C' "  
cQuery += " AND B1.B1_COD = D1.D1_COD AND F4.F4_CODIGO <> '193' "
cQuery += " AND D1.D1_SERIE = F1.F1_SERIE  AND D1.D1_FORNECE = F1.F1_FORNECE "
cQuery += " AND D1.D1_LOJA = F1.F1_LOJA "
cQuery += " AND D1.D_E_L_E_T_ = ' ' AND D1.D1_EXPORT <> 'S' "
cQuery += " AND D1.D1_PEDIDO *= C7.C7_NUM AND D1.D1_FORNECE *= C7.C7_FORNECE "
cQuery += " AND D1.D1_LOJA *= C7.C7_LOJA"
cQuery += " AND D1.D1_COD *= C7.C7_PRODUTO AND D1.D1_ITEM *= C7.C7_ITEM"
cQuery += " ORDER BY D1.D1_DOC ASC"    
*/

cQuery := "SELECT D1.D1_DOC,D1.D1_FORNECE,D1.D1_LOJA,D1.D1_COD,D1.D1_DTDIGIT,D1.D1_LOTECTL, "
cQuery += " D1.D1_QUANT,D1.D1_PEDIDO,D1.D1_SERIE,D1.D1_EMISSAO,D1.D1_TOTAL,D1.D1_EXPORT, "
cQuery += " D1.D1_TES,D1.D1_ITEM,F4.F4_CODIGO,F4.F4_ESTOQUE, "
cQuery += " F1.F1_TIPO,F1.F1_HORA,C7.C7_NUM,C7.C7_DATPRF,B1.B1_TIPO,F1.F1_ESPECIE "
cQuery += " FROM "+RetSqlName("SD1")+" D1 (NOLOCK) " 

cQuery += " INNER JOIN "+RetSqlName("SF1")+" F1 (NOLOCK) ON "
cQuery += " 	D1.D1_FILIAL = F1.F1_FILIAL "
cQuery += " AND D1.D1_DOC = F1.F1_DOC "
cQuery += " AND D1.D1_SERIE = F1.F1_SERIE "
cQuery += " AND D1.D1_FORNECE = F1.F1_FORNECE " 
cQuery += " AND D1.D1_LOJA = F1.F1_LOJA  "
cQuery += " AND F1.F1_TIPO <> 'C' "
cQuery += " AND F1.D_E_L_E_T_ = ' ' "

cQuery += " INNER JOIN "+RetSqlName("SF4")+" F4 (NOLOCK) ON "
cQuery += " 	F4.F4_FILIAL = D1.D1_FILIAL  "
cQuery += " AND F4.F4_CODIGO = D1.D1_TES "
cQuery += " AND F4.F4_CODIGO <> '193'  "
cQuery += " AND F4.D_E_L_E_T_ = ' ' "

cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 (NOLOCK) ON "
cQuery += " 	B1.B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery += " AND D1.D1_COD = B1.B1_COD "
cQuery += " AND B1.D_E_L_E_T_ = ' ' "
cQuery += " AND B1.B1_TIPO IN ('CC','MC','CP','MP','MA','BN','PW') "

cQuery += " LEFT JOIN "+RetSqlName("SC7")+" C7 (NOLOCK) ON "
cQuery += " 	D1.D1_FILIAL  = C7.C7_FILIAL "
cQuery += " AND D1.D1_PEDIDO  = C7.C7_NUM "
cQuery += " AND D1.D1_FORNECE = C7.C7_FORNECE "
cQuery += " AND D1.D1_LOJA = C7.C7_LOJA "
cQuery += " AND D1.D1_COD  = C7.C7_PRODUTO "
cQuery += " AND D1.D1_ITEM = C7.C7_ITEM "
cQuery += " AND C7.D_E_L_E_T_ = ' ' "

cQuery += " WHERE  "
cQuery += "     D1.D_E_L_E_T_ = ' ' "
cQuery += " AND D1.D1_FILIAL = '"+xFilial("SD1")+"' "
cQuery += " AND D1.D1_EXPORT <> 'S' "

If !Empty(cControl)   // Entra nesta quando é executado apartir do ponto de entrada SF1100I                              
   cQuery += " AND D1.D1_DOC = '" + cDoc + "' AND  D1.D1_LOJA = '" + cLoja + "' "
   cQuery += " AND D1.D1_SERIE = '" + cSerie + "' AND D1.D1_FORNECE = '" + cFornece + "' " 
   cQuery += " AND D1.D1_DTDIGIT = '" + dData + "' "
Endif	

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
QAA->(DBSETORDER(6))//LOGIN
QE6->(DbSetOrder(1))//filial+PRODUTO +REV
While !TMP->(EOF())                              
    
   If SM0->M0_CODIGO == 'NH' .And. TMP->D1_FORNECE$"000184" .And. TMP->D1_LOJA$"01"
      _cFor  := "000666" //fornecedor whb fundicao
      _cLoja := "01" //loja
   Else
      _cFor  := TMP->D1_FORNECE //fornecedor whb fundicao
      _cLoja := TMP->D1_LOJA   //loja
	      
   Endif    
    
    // verifica se o produto tem amarraca produto x fornecedor                
   SA5->(DbSeek(xFilial("SA5")+_cFor+_cLoja+TMP->D1_COD))
   If !SA5->(Found())
        fEnviaQ(2)//2 = EMAIL DE FALTA AMARRAÇÃO PRODUTO X FORNECEDOR
   	    TMP->(DBSKIP())
   	    LOOP
   ELSE
		//VERIFICA SE A VALIDADE DO RIAI ESTÁ EXPIRADA
		IF SA5->A5_VALRIAI < Date()
			RECLOCK("SA5",.F.)
				SA5->A5_VALRIAI := CTOD('01/01/2050')
			MSUNLOCK("SA5") 
			 //fEnviaQ(1)//EMAIL DE VALIDADE DO RIAI EXPIRADA
		ENDIF
		
		//VERIFICA SE EXISTE SITUACAO CADASTRADA NA AMARRACAO PRODUTO X FORNECEDOR
		IF EMPTY(SA5->A5_SITU)
			fEnviaQ(1) //1 = informa da falta de situacao
			TMP->(DBSKIP())
			LOOP
		ENDIF
		
   Endif        
   
   QE6->(DbSeek(xFilial("QE6")+TMP->D1_COD))
   If !QE6->(Found())
       	fEnviaQ(3) //3 = FALTA ESPECIFICACAO
		TMP->(DBSKIP())
		LOOP
   Endif        
   
   If DBF->(DbSeek(TMP->D1_DOC+TMP->D1_SERIE+TMP->D1_COD))
	   
      RecLock("DBF",.F.)
		DBF->TAMLOT := Transform(Val(DBF->TAMLOT)+TMP->D1_QUANT,"@e 99999999")
		DBF->TAMAMO := Transform(val(DBF->TAMAMO)+TMP->D1_QUANT,"@e 99999999")
	  MsUnlock("DBF")   
   Else
      _lArq := .T.
      
      If Empty(TMP->D1_LOTECTL)
      	_cD1Lote := "SEMLOTE"
      Else
      	_cD1Lote := TMP->D1_LOTECTL
      EndIf
	          
      RecLock("DBF",.T.)
        DBF->FORNEC := _cFor
		DBF->LOJFOR := _cLoja
		DBF->PRODUT := TMP->D1_COD
		DBF->DTENT  := DTOS(TMP->D1_DTDIGIT)
		DBF->HRENTR := TMP->F1_HORA
		DBF->LOTE   := _cD1Lote
		DBF->DOCENT := TMP->D1_DOC
		DBF->TAMLOT := Transform(TMP->D1_QUANT,"@e 99999999")
		DBF->TAMAMO := Transform(TMP->D1_QUANT,"@e 99999999")
		DBF->PEDIDO := TMP->D1_PEDIDO
		DBF->NTFISC := TMP->D1_DOC
		DBF->SERINF := TMP->D1_SERIE
		DBF->DTNFIS := TMP->D1_EMISSAO
		DBF->TIPDOC := TMP->F1_ESPECIE // especie da nota NF
		DBF->TIPONF := TMP->F1_TIPO //Tipo da nota n=normal, b=beneficiamento		

	  	DBF->CERFOR := "N/A" //TMP->D1_DOC+TMP->D1_ITEM  //VERIFICAR?
	  	If Empty(TMP->C7_DATPRF)
	    	DBF->DIASAT := SPACE(04)
	    Else 
	    	DBF->DIASAT := STRZERO(TMP->D1_DTDIGIT  - TMP->C7_DATPRF,4)   
	    Endif 	
	    
		If QAA->(DbSeek(_cUsr))
			_cSolic := QAA->QAA_MAT
		EndIf
	    
	  	DBF->SOLIC  := _cSolic
		DBF->PRECO  := Transform(TMP->D1_TOTAL,"@e 999999999.99")
	  	DBF->EXCLUI := Space(01)
	  	DBF->ITEMNF := TMP->D1_ITEM
	   MsUnlock("DBF")
   Endif
   
   TMP->(DbSkip())
Enddo

If _lArq //se encontrou algum registro
   	ProcRegua(DBF->(RecCount()))
   	DBF->(DbGoTop())
	While !DBF->(eof())     
     
		IncProc("Importando arquivos p/ Quality")

		//VERIFICA O SKIPLOTE SE INSPECIONA OU NAO. TRAZ NA VARIAVEL nVerifi
		cFornece := DBF->FORNEC      //aVetTmp[_x][2][2]
		cLoja    := DBF->LOJFOR      //aVetTmp[_x][3][2]
		cProduto := DBF->PRODUT      //aVetTmp[_x][4][2]

		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+ALLTRIM(cProduto)))
		
		cGrupo   := SB1->B1_GRUPO
		
		dEntrada := STOD(DBF->DTENT) //aVetTmp[_x][8][2]
		cLote    := DBF->LOTE        //aVetTmp[_x][5][2]
		cDocEnt  := DBF->DOCENT      //aVetTmp[_x][10][2]
		aMsg     := {}

		nVerifi  := QieSkipLote(cFornece,cLoja,cProduto,cGrupo,dEntrada,cLote,cDocEnt,aMsg)    	

		//ADICIONA O VETOR PARA IMPORTACAO AUTOMATICA NO QUALITY	
	 	aAdd(aVetTmp,{{"QEK_TIPONF",ALLTRIM(DBF->TIPONF),NIL},;
					  {"QEK_FORNEC",DBF->FORNEC,NIL},;
					  {"QEK_LOJFOR",DBF->LOJFOR,NIL},;
					  {"QEK_PRODUT",DBF->PRODUT,NIL},; 
					  {"QEK_LOTE"  ,DBF->LOTE,NIL},;
					  {"QEK_TAMLOT",ALLTRIM(DBF->TAMLOT),NIL},; 
					  {"QEK_TAMAMO",ALLTRIM(DBF->TAMAMO),NIL},;
					  {"QEK_DTENTR",STOD(DBF->DTENT),NIL},;
					  {"QEK_DTNFIS",STOD(DBF->DTNFIS),NIL},;
					  {"QEK_DOCENT",DBF->DOCENT,NIL},;
					  {"QEK_HRENTR",DBF->HRENTR,NIL},;
					  {"QEK_TIPDOC",ALLTRIM(DBF->TIPDOC),NIL},;
					  {"QEK_PRECO" ,VAL(DBF->PRECO),NIL},;
					  {"QEK_CERFOR",DBF->CERFOR,NIL},;
					  {"QEK_VERIFI",nVerifi,NIL},;//1 = INSPEÇÃO
				      {"QEK_SOLIC",DBF->SOLIC,NIL},;
				      {"QEK_NTFISC",DBF->NTFISC,NIL},;
				      {"QEK_SERINF",DBF->SERINF,NIL},;
					  {"QEK_SITENT",'2',NIL}})
	
      DBF->(Dbskip())
   EndDo    

	For _x := 1 to Len(aVetTmp)

	 	Processa({|| MSExecAuto({|x,y| QIEA200(x,y)},aVetTmp[_X],3)},"Gerando Quality...") //Inclusao
		
		If lMsErroAuto 
			MostraErro()
//			DisarmTransaction()
//			Return
		Endif

		//QEK->(DbSetOrder(1))
        //QEK->(DbSeek(xFilial("QEK")+ ))
	    //RecLock("QEF",.F.)
        //  QEK->QEK_VERIFI := QieSkipLote(cFornece,cLoja,cProduto,cGrupo,dEntrada,cLote,cDocEnt,aMsg)    
	    //MsUnlock("QEK")   
	Next     

Endif

DbSelectArea("TMP")
DbCloseArea()

If	Select("DBF") > 0
   DbSelectArea("DBF")
   DbCloseArea()
Endif

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
AADD(_aDBF,{"NTFISC"     ,"C", 09,0})         // Nota Fiscal
AADD(_aDBF,{"SERINF"     ,"C", 03,0})         // Serie da Nota Fiscal
AADD(_aDBF,{"ITEMNF"     ,"C", 04,0})         // Item da nota fiscal
AADD(_aDBF,{"DTNFIS"     ,"C", 08,0})         // Data da Nota Fiscal
AADD(_aDBF,{"TIPDOC"     ,"C", 06,0})         // especie da nf
AADD(_aDBF,{"TIPONF"     ,"C", 01,0})         // Tipo de Documento
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

//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³           ³
//³ E M A I L ³
//³           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fEnviaQ(_NMAIL)
Local cMSG := ""        
Local cTo  := ""
Local cAssunto

	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2")+_cFor+_cLoja))
	   
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+TMP->D1_COD))

	cMsg := '<html>'
	cMsg += '<body style="font-family:arial">'
	cMsg += '<p>O produto abaixo não foi importado para o quality devido a falta de '

	IF _NMAIL == 1       
 		cMsg += 'SITUAÇÃO cadastrada na amarração Produto x Fornecedor'
		cAssunto := 'FALTA SITUAÇÃO NO CADASTRO PRODUTO X FORNECEDOR'
	ELSEIF _NMAIL == 2
		cMsg += 'AMARRAÇÃO PRODUTO X FORNECEDOR' 		
 		cAssunto := 'FALTA AMARRAÇÃO PRODUTO X FORNECEDOR'
 	ELSEIF _NMAIL == 3
		cMsg += 'ESPECIFICAÇÃO DO PRODUTO'
		cAssunto := 'FALTA ESPECIFICAÇÃO DO PRODUTO'
	ENDIF

 	cMsg += ' no módulo de Inspeção de Entradas</p><br />'
	cMsg += '<table width="100%" border="1">'
	cMsg += '<tr style="background:#aabbcc"><td>Produto</td><td>Descrição</td>'
	cMsg += '<td>Fornecedor/Loja</td><td>Descrição Fornecedor</td></tr>
	cMsg += '<tr><td>'+TMP->D1_COD+'</td><td>'+SB1->B1_DESC+'</td>'
	cMsg += '<td>'+_cFor+' - '+_cLoja+'</td><td>'+SA2->A2_NOME+'</td>'
	cMsg += '</tr>'
	cMsg += '</table>'
	cMsg += '<p>Mensagem automática, favor não responder<p>'
	cMsg += '</body>'
	cMsg += '</html>
	
	If SM0->M0_CODIGO == 'NH'
		cTo := 'samuelc@whbbrasil.com.br'
	Else
		IF ALLTRIM(SB1->B1_TIPO)$'MP/MA' .AND. ALLTRIM(SB1->B1_GRUPO)!='MP04'
			cTo := 'JairoM@whbbrasil.com.br;ValdeciZ@whbbrasil.com.br;RodrigoPT@whb.interno;MoacirMW@whbbrasil.com.br;SamuelC@whbbrasil.com.br;'+;
				   'eversonco@whbfundicao.com.br;'+;
				   'ezequieltr@whbbrasil.com.br'
		ELSEIF ALLTRIM(SB1->B1_GRUPO)=='MP04'
			cTo := 'ronaldop@whbbrasil.com.br'
		ENDIF
	Endif
	
	oMail          := Email():New()
	oMail:cTo      := cTo
	oMail:cAssunto := '****** '+cAssunto+' ******'
	oMail:cMsg     := cMsg
	IF !eMPTY(cTO)
		oMail:Envia()
	Endif
	
Return .T.