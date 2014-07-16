User Function Teste()
MATA185() 
/*
Static Function fImporta(cArquivo)
	Local aCabec  := {}  
	Local aItens  := {}
	Local aCliente:= {}
	Local aFornece:= {}
	Local nCont   := 0	
	LOCAL nHdl:= nHdlA := 0
	Local nX
	Local nTamFile, nTamLin, cBuffer, nBtLidos
	Local lExiste := .T.
	Local lHabil  := .F.
	Private nHdl  := 0
	Private cEOL  := "CHR(8)"
	*/
	/*
	ESSE AQUI JA TAVA COMENTADO
	If Empty(cEOL)
		cEOL := CHR(8)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif
	*/	
	
	/*
	If Empty(Alltrim(cArquivo))
		Alert("Nao existem arquivos para importar. Processo ABORTADO")
		Return.F.	
	EndIf
   */
	//+---------------------------------------------------------------------+
	//| Abertura do arquivo texto                                           |
	//+---------------------------------------------------------------------+
   /*
	cArqTxt := cArquivo

	nHdl := fOpen(cArqTxt,0 )
	IF nHdl == -1
		IF FERROR()== 516
			ALERT("Feche o programa que gerou o arquivo.")
		EndIF
	EndIf
	*/
	//+---------------------------------------------------------------------+
	//| Verifica se foi possível abrir o arquivo                            |
	//+---------------------------------------------------------------------+
   /*
	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArquivo+" nao pode ser aberto! Verifique os parametros.","Atencao!" )
		Return
	Endif


	FSEEK(nHdl,0,0 )
	nTamArq:=FSEEK(nHdl,0,2 )
	FSEEK(nHdl,0,0 )
	fClose(nHdl)

	FT_FUse(cArquivo )  //abre o arquivo
	FT_FGoTop()         //posiciona na primeira linha do arquivo
	//nTamLinha := AT(cEOL,cBuffer )
   	nTamLinha := Len(FT_FREADLN() ) //Ve o tamanho da linha
	FT_FGOTOP()
	*/	
	//+---------------------------------------------------------------------+
	//| Verifica quantas linhas tem o arquivo                               |
	//+---------------------------------------------------------------------+
   /*
	nLinhas := FT_FLastRec() 

	ProcRegua(nLinhas)

	While !FT_FEOF()
		IF nCont > nLinhas
			exit
		endif   
		IncProc("Lendo arquivo texto...Linha "+Alltrim(str(nCont)))
		cLinha := Alltrim(FT_FReadLn())
		nRecno := FT_FRecno() // Retorna a linha corrente

		if !empty(cLinha )
			if Substr(cLinha,1,1 )=="1"
				//aFornece[1][1] = PEDIDO 	//POSICAO:  3 A 12	//TAM: 10
				//aFornece[1][2] = DATA		//POSICAO: 13 A 20	//TAM:  8
				//aFornece[1][3] = FORNECEDOR	//POSICAO: 31 A 65	//TAM: 35
				aadd(aFornece,{Substr(cLinha,3,10 ),Substr(cLinha,13,8 ),Substr(cLinha,31,35 )})
			Elseif Substr(cLinha,1,1 )=="2"
				//aItens[1][1] = ITEM		//POSICAO:   2 A   6 //TAM:  5
				//aItens[1][2] = QTDE		//POSICAO:   7 A  22 //TAM: 16
				//aItens[1][3] = CODIGO		//POSICAO:  26 A  43 //TAM: 18
				//aItens[1][4] = DESCRICAO	//POSICAO:  44 A  83 //TAM: 40
				//aItens[1][5] = VAL UNIT	//POSICAO:  97 A 113 //TAM: 17
				//aItens[1][6] = VAL TOTAL	//POSICAO: 114 A 130 //TAM: 17
				aadd(aItens,{Substr(cLinha,2,5 )  ,;
				             Substr(cLinha,7,16 ) ,;
				             Substr(cLinha,26,18 ),;
				             Substr(cLinha,44,40 ),;
				             Substr(cLinha,97,17 ),;
				             Substr(cLinha,114,17 )})			
			Elseif Substr(cLinha,1,1 )=="4"
				//aCliente[1][1] = EMPRESA		//POSICAO:   2 A  31 //TAM: 30
				//aCliente[1][2] = CNPJ  		//POSICAO: 100 A 117 //TAM: 18
				//aCliente[1][3] = CIDADE		//POSICAO: 166 A 190 //TAM: 25
				//aCliente[1][4] = ESTADO		//POSICAO: 191 A 196 //TAM:  3
				aadd(aCliente,{Substr(cLinha,2,30 ),Substr(cLinha,100,18 ),Substr(cLinha,166,25 ),Substr(cLinha,191,3 )})
			Endif
		endif
		FT_FSKIP()  
		nCont++
	EndDo		
	FT_FUSE()
	fClose(nHdl )*/
Return