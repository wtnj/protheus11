#INCLUDE "rwmake.ch" 
#include "JPEG.CH"

/*----------+-----------+-------+--------------------+------+----------------+
! Programa  ! TPPAR012  ! Autor ! GUSTAVO RIBEIRO    ! Data !  20/02/09      !
+-----------+-----------+-------+--------------------+------+----------------+
! Descricao ! IMPRESSÃO HISTÓRICO DE PROCESSO                                !
!           ! REFERENTE AO FONTE TPPAC014                                    !
+----------------------------------------------------------------------------+
! Uso       ! WHB MSQL e MP10 1.2                                            !
+---------------------------------------------------------------------------*/

//============================ PROGRAMA PRINCIPAL ============================
user function TPPAR012 ( )

	private cBmpLogo	:= "\system\logo_whb.bmp"
		
	private oFnt06		:= TFont():New("Arial",,06,,.f.,,,,,.f.)
	private oFnt06n		:= TFont():New("Arial",,06,,.t.,,,,,.f.)
	private oFnt08		:= TFont():New("Arial",,08,,.f.,,,,,.f.)
	private oFnt08n		:= TFont():New("Arial",,08,,.t.,,,,,.f.)
	private oFnt09		:= TFont():New("Arial",,09,,.f.,,,,,.f.)
	private oFnt09n		:= TFont():New("Arial",,09,,.t.,,,,,.f.)
	private oFnt10		:= TFont():New("Arial",,10,,.f.,,,,,.f.)
	private oFnt10n		:= TFont():New("Arial",,10,,.t.,,,,,.f.)
	private oFnt11		:= TFont():New("Arial",,11,,.f.,,,,,.f.)
	private oFnt11n		:= TFont():New("Arial",,11,,.t.,,,,,.f.)
	private oFnt14		:= TFont():New("Arial",,14,,.f.,,,,,.f.)
	private oFnt14n		:= TFont():New("Arial",,14,,.t.,,,,,.f.)
	private oFnt16		:= TFont():New("Arial",,16,,.f.,,,,,.f.)
	private oFnt16n		:= TFont():New("Arial",,16,,.t.,,,,,.f.)
	private oFnt18		:= TFont():New("Arial",,18,,.f.,,,,,.f.)
	private oFnt18n		:= TFont():New("Arial",,18,,.t.,,,,,.f.)
	private oFnt22		:= TFont():New("Arial",,22,,.f.,,,,,.f.)
	private oFnt22n		:= TFont():New("Arial",,22,,.t.,,,,,.f.)
	private nLinInc		:=	20*5
	private nColInc		:=	20*6
	private aAreaZC9	:=	ZC9->(GetArea())
	private nRecno		:=	0
	private cNumHist	:=	ZC9->ZC9_NUMHIS 
	 
	dbSelectArea("ZC9")
	
	ZC9->(dbGoTop())
	ZC9->(dbSetOrder(1)) //ZC9_FILIAL, ZC9_PKYK, ZC9_REV, R_E_C_N_O_, D_E_L_E_T_
	ZC9->(dbSeek(xFilial("ZC9") + cNumHist))
	
	while ZC9->(!eof()) .and. (ZC9->ZC9_FILIAL + ZC9->ZC9_NUMHIS) == (xFilial("ZC9") + cNumHist)

		if ZC9->ZC9_STATUS == "S"
			nRecno := ZC9->(recno())
		endif

		ZC9->(dbSkip())

	enddo
	
	ZC9->(dbGoTo(nRecno))
	
	oPrn := TMSPrinter():New("HISTORICO DE PROCESSO") //Cria Objeto para impressao Grafica

	oPrn:Setup()                          //Chama a rotina de Configuracao da impressao
	oPrn:SetPortrait()					  //Seta o relatório como retrato
	oPrn:StartPage()                      //Cria nova Pagina 

	if ZC9->ZC9_STATUS == "S"
		sfCabec()                         //Impressao do Cabecalho			
		sfbox01()                         //box de dados 01
		sfbox02()                         //box de dados 02
		sfbox03()                         //box de dados 03
		sfbox04()                         //box de dados 04
		//sfbox05()                         //box de dados 05
		//sfbox06()                         //box de dados 06
		//sfBoxIMG()                        //box da imagem de melhoria
	endif														
	
	oPrn:EndPage()
	
	oPrn:Preview()

	RestArea(aAreaZC9) 

Return ( )
//================================= FIM DO PROGRAMA PRINCIPAL ===============================

//================================== IMPRESSÃO DO CABEÇALHO =================================
Static function sfCabec()
	
	local nLin:= 20
	local nCol:= 20
	local cNReduz  := posicione("SA1", 1, xFilial("SA1") + ZC9->ZC9_CLIENT + ZC9->ZC9_LOJA, "A1_NREDUZ")
	
	oPrn:box(nLinInc, nColInc, nLin*10, nCol*114)                                //box do Cabeçalho 

	oPrn:sayBitmap(nLinInc + nLin, nColInc + nCol, cBmpLogo, nCol*9, nLin*3.5)
	
	oPrn:say(nLinInc + nLin, nCol*40, "HISTÓRICO DE PROCESSO Nº", oFnt14n, 100)
	oPrn:say(nLinInc + nLin, nCol*73, alltrim(ZC9->ZC9_NUMHIS), oFnt14n, 100)
	  
	oPrn:say(nLinInc + nLin*2, nCol*094, "CLIENTE: " + cNReduz, oFnt08, 100) 

return ( )
//=========================== FIM DA IMPRESSÃO DO CABEÇALHO ==========================

//=============================== BOX01 =================================
static function sfbox01()
	
	local nLin    := 20
	local nCol    := 20
	local cFornece:= posicione("SA2", 1, xFilial("SA2") + ZC9->ZC9_FORN + ZC9->ZC9_LOJAF, "A2_NREDUZ")
	
	oPrn:box(nLin*11, nColInc, nLin*19, nCol*114)               //box principal
	oPrn:say(nLin*12, nCol*50, "IDENTIFICAÇÃO DA MODIFICAÇÃO", oFnt08n, 100) 
	
	oPrn:box(nLin*13.1, nCol*7, nLin*14.1, nCol*8)
	oPrn:say(nLin*13  , nCol*9, "PROCESSO", oFnt08, 100)
	
	oPrn:box(nLin*15.1, nCol*7, nLin*16.1, nCol*8)
	oPrn:say(nLin*15  , nCol*9, "DESENHO", oFnt08, 100)

	oPrn:box(nLin*17.1, nCol*7, nLin*18.1, nCol*8)
	oPrn:say(nLin*17  , nCol*9, "OUTROS", oFnt08, 100)
	oPrn:say(nLin*17.2, nCol*15, "Especifique: " + ZC9->ZC9_ESPEC, oFnt06n, 100)

	//1=PROCESSO; 2=DESENHO; 3=OUTROS
	if ZC9->ZC9_IDENT == '1'							
		oPrn:say(nLin*13, nCol*7.1, "X", oFnt08n, 100)
	elseif ZC9->ZC9_IDENT == '2'
		oPrn:say(nLin*15, nCol*7.1, "X", oFnt08n, 100)
	elseif ZC9->ZC9_IDENT == '3'
		oPrn:say(nLin*17, nCol*7.1, "X", oFnt08n, 100)
	endif
	
	oPrn:box(nLin*13.1, nCol*91, nLin*14.1, nCol*92)
	oPrn:say(nLin*13  , nCol*93, "ALTERAÇÃO", oFnt08, 100)
	
	oPrn:box(nLin*15.1, nCol*91, nLin*16.1, nCol*92)
	oPrn:say(nLin*15  , nCol*93, "MELHORIA", oFnt08, 100)
	
	//1=ALTERAÇÃO; 2=MELHORIA
	if ZC9->ZC9_TIPO == '1'							
		oPrn:say(nLin*13, nCol*91.1, "X", oFnt08n, 100)
	elseif ZC9->ZC9_TIPO == '2'
		oPrn:say(nLin*15, nCol*91.1, "X", oFnt08n, 100)
	endif
	
	oPrn:box(nLin*19  , nCol*6  , nLin*22, nCol*38)                 //Box Fornecedor
	oPrn:say(nLin*19.2, nCol*6.2, "Fornecedor:", oFnt06n, 100)
	oPrn:say(nLin*19.7, nCol*14 , cFornece     , oFnt08, 100)

	oPrn:box(nLin*19  , nCol*38  , nLin*22, nCol*76)                //Denominação
	oPrn:say(nLin*19.2, nCol*38.2, "Denominação:", oFnt06n, 100)
  //	oPrn:say(nLin*19.7, nCol*46  , ZC9->ZC9_DESPEC , oFnt08, 100)
  	oPrn:say(nLin*19  , nCol*46  , alltrim(ZC9->ZC9_DESPEC), oFnt08, 100)
	
	oPrn:box(nLin*19  , nCol*76  , nLin*22, nCol*114)               //Data Rev.Desenho
	oPrn:say(nLin*19.2, nCol*76.2, "Data Rev.Desenho:", oFnt06n, 100)
	oPrn:say(nLin*19.7, nCol*86  , dToc(ZC9->ZC9_DATA), oFnt08, 100)
	
	oPrn:box(nLin*22  , nCol*6  , nLin*25, nCol*38)                 //Nº Fornecedor
	oPrn:say(nLin*22.2, nCol*6.2, "Nº Fornecedor:" , oFnt06n, 100)
	oPrn:say(nLin*22.7, nCol*14 , ZC9->ZC9_NUMFOR, oFnt08, 100)

	oPrn:box(nLin*22  , nCol*38  , nLin*25, nCol*76)                //Código Cliente
	oPrn:say(nLin*22.2, nCol*38.2, "Código Cliente:", oFnt06n, 100)
	oPrn:say(nLin*22.7, nCol*46  , ZC9->ZC9_CODCLI  , oFnt08, 100)
	
	oPrn:box(nLin*22  , nCol*76  , nLin*25, nCol*114)               //Código WHB / Rev
	oPrn:say(nLin*22.2, nCol*76.2, "Código WHB / Rev.:"                             , oFnt06n, 100)
	oPrn:say(nLin*22.7, nCol*86  , alltrim(ZC9->ZC9_CODWHB) + " / " + ZC9->ZC9_REVPC, oFnt08, 100)

return ( )                                                                                                       
//=============================== FIM DO BOX01 =============================== 

//=============================== BOX02 =================================
static function sfbox02()
	
	local nLin := 20
	local nCol := 20
	local nCont:= 0
	local cCoordena:= posicione("QAA", 1, xFilial("QAA") + ZC9->ZC9_COOR, "QAA_NOME")
	
	oPrn:box(nLin*26  , nCol*6  , nLin*40, nCol*114)                       //box principal
	oPrn:say(nLin*26.2, nCol*6.2, "Análise da Modificação:", oFnt08n, 100) 

	for nM := 1 to 6
		cTexto:= memoline(ZC9->ZC9_ANAMOD, 160, nM ) 
		oPrn:say(nLin*(28 + nCont), nColInc + nCol, cTexto, oFnt08, 100) 	       	
		nCont+=1.7
	next nM

	oPrn:say(nLin*38.7, nCol*070, "Coordenador Projeto: ", oFnt06n, 100)
	oPrn:say(nLin*38.4, nCol*081, cCoordena, oFnt08, 100)
	
	oPrn:say(nLin*38.7, nCol*100, "Data da Análise: "  , oFnt06n, 100)
	oPrn:say(nLin*38.4, nCol*108, dToc(ZC9->ZC9_ANALIS), oFnt08, 100)
		
return ( )
//=============================== FIM DO BOX02 =============================== 

//=============================== BOX03 =================================
static function sfbox03()
	
	local nLin:= 20
	local nCol:= 20
	
	oPrn:box(nLin*41, nCol*6 , nLin*51, nCol*114)                                //Box principal
	oPrn:say(nLin*41.3, nCol*50, "IMPACTOS NA DOCUMENTAÇÃO APQP/PAPP:", oFnt06n, 100) 

	oPrn:box(nLin*43.2, nCol*7, nLin*44.2, nCol*8)                               //Exequibilidade
	oPrn:say(nLin*43  , nCol*9, "Exequibilidade", oFnt08, 100)
	iif(ZC9->ZC9_EXIB == '1', oPrn:say(nLin*43, nCol*7.1, "X", oFnt08n, 100),.t.);
	
	oPrn:box(nLin*45.2, nCol*7, nLin*46.2, nCol*8)                               //Pedido Interno
	oPrn:say(nLin*45  , nCol*9, "Pedido Interno", oFnt08, 100)
	iif(ZC9->ZC9_PEDINT == '1', oPrn:say(nLin*45, nCol*7.1, "X", oFnt08n, 100),.t.);

	oPrn:box(nLin*47.2, nCol*7, nLin*48.2, nCol*8)                               //Cronogramas
	oPrn:say(nLin*47  , nCol*9, "Cronogramas", oFnt08, 100)
	iif(ZC9->ZC9_CRON == '1', oPrn:say(nLin*47, nCol*7.1, "X", oFnt08n, 100),.t.);
	
	oPrn:box(nLin*49.2, nCol*7, nLin*50.2, nCol*8)                               //Controle de Qual. Processo
	oPrn:say(nLin*49  , nCol*9, "Controle de Qual. Processo", oFnt08, 100)
	iif(ZC9->ZC9_CONTRO == '1', oPrn:say(nLin*49, nCol*7.1, "X", oFnt08n, 100),.t.);
	
	oPrn:box(nLin*43.2, nCol*28.5, nLin*44.2, nCol*29.5)                         //PWS
	oPrn:say(nLin*43  , nCol*30.5, "PSW", oFnt08, 100)
	iif(ZC9->ZC9_PSW == '1', oPrn:say(nLin*43, nCol*28.6, "X", oFnt08n, 100),.t.);
	
	oPrn:box(nLin*45.2, nCol*28.5, nLin*46.2, nCol*29.5)                         //FMEA / AMDEQ
	oPrn:say(nLin*45  , nCol*30.5, "FMEA / AMDEQ", oFnt08, 100)
	iif(ZC9->ZC9_FMEA == '1', oPrn:say(nLin*45, nCol*28.6, "X", oFnt08n, 100),.t.);

	oPrn:box(nLin*47.2, nCol*28.5, nLin*48.2, nCol*29.5)                         //Fluxograma
	oPrn:say(nLin*47  , nCol*30.5, "Fluxograma", oFnt08, 100)
	iif(ZC9->ZC9_FLUXO == '1', oPrn:say(nLin*47, nCol*28.6, "X", oFnt08n, 100),.t.);
	
	oPrn:box(nLin*49.2, nCol*28.5, nLin*50.2, nCol*29.5)                         //Ensaio Dimensional
	oPrn:say(nLin*49  , nCol*30.5, "Ensaio Dimensional", oFnt08, 100)
	iif(ZC9->ZC9_ENSAIO == '1', oPrn:say(nLin*49, nCol*28.6, "X", oFnt08n, 100),.t.);
	
	oPrn:box(nLin*43.2, nCol*57, nLin*44.2, nCol*58)                             //Lista Crítica
	oPrn:say(nLin*43  , nCol*59, "Lista Crítica", oFnt08, 100)
	iif(ZC9->ZC9_LISTA == '1', oPrn:say(nLin*43, nCol*57.1, "X", oFnt08n, 100),.t.);
	
	oPrn:box(nLin*45.2, nCol*57, nLin*46.2, nCol*58)                             //Matriz de Correlação
	oPrn:say(nLin*45  , nCol*59, "Matriz de Correlação", oFnt08, 100)
	iif(ZC9->ZC9_MATRIZ == '1', oPrn:say(nLin*45, nCol*57.1, "X", oFnt08n, 100),.t.);

	oPrn:box(nLin*47.2, nCol*57, nLin*48.2, nCol*58)                             //Lay-out
	oPrn:say(nLin*47  , nCol*59, "Lay-out", oFnt08, 100)
	iif(ZC9->ZC9_LAYOUT == '1', oPrn:say(nLin*47, nCol*57.1, "X", oFnt08n, 100),.t.);
	
	oPrn:box(nLin*49.2, nCol*57, nLin*50.2, nCol*58)                             //Capabilidade
	oPrn:say(nLin*49  , nCol*59, "Capabilidade", oFnt08, 100)
	iif(ZC9->ZC9_CAPAB == '1', oPrn:say(nLin*49, nCol*57.1, "X", oFnt08n, 100),.t.);
	
	oPrn:box(nLin*43.2, nCol*85.5, nLin*44.2, nCol*86.5)                         //Método de Trabalho
	oPrn:say(nLin*43  , nCol*87.5, "Método de Trabalho", oFnt08, 100)
	iif(ZC9->ZC9_METODO == '1', oPrn:say(nLin*43, nCol*85.6, "X", oFnt08n, 100),.t.);
	
	oPrn:box(nLin*45.2, nCol*85.5, nLin*46.2, nCol*86.5)                         //Plano de Controle
	oPrn:say(nLin*45  , nCol*87.5, "Plano de Controle", oFnt08, 100)
	iif(ZC9->ZC9_PLANO == '1', oPrn:say(nLin*45, nCol*85.6, "X", oFnt08n, 100),.t.);

	oPrn:box(nLin*47.2, nCol*85.5, nLin*48.2, nCol*86.5)                         //Estudos MSA
	oPrn:say(nLin*47  , nCol*87.5, "Estudos MSA", oFnt08, 100)
	iif(ZC9->ZC9_MSA == '1', oPrn:say(nLin*47, nCol*85.6, "X", oFnt08n, 100),.t.);
	
	oPrn:box(nLin*49.2, nCol*85.5, nLin*50.2, nCol*86.5)                         //Outros
	oPrn:say(nLin*49  , nCol*87.5, "Outros", oFnt08, 100)
	iif(ZC9->ZC9_OUTROS == '1', oPrn:say(nLin*49, nCol*85.6, "X", oFnt08n, 100),.t.);

return ( )
//=============================== FIM DO BOX03 =============================== 

//=============================== BOX04 =================================
static function sfbox04()
	
	local nLin  := 20
	local nCol  := 20
	local nCont := 0
	local cAprov:= dToc(ZC9->ZC9_APPRO)   
	local cResp := posicione("QAA", 1, xFilial("QAA") + ZC9->ZC9_EMITEN, "QAA_NOME")
	local cSup  := posicione("QAA", 1, xFilial("QAA") + ZC9_RESP, "QAA_NOME")
	               
	oPrn:box(nLin*52, nCol*6 , nLin*55, nCol*114)                                //Box principal

	oPrn:box(nLin*52  , nCol*6   , nLin*55, nCol*12)                             //Box Item nº coluna 1
	oPrn:say(nLin*52.3, nCol*6.3 , "Item nº", oFnt06n, 100) 
	oPrn:box(nLin*52  , nCol*12  , nLin*55, nCol*37)                             //Box Modificação / Documento
	oPrn:say(nLin*52.3, nCol*12.3, "Modificação / Documento", oFnt06n, 100) 
	oPrn:box(nLin*52  , nCol*37  , nLin*55, nCol*50)                             //Box Identificação Folha/Quad./Item
	oPrn:say(nLin*52.3, nCol*37.3, "Identificação", oFnt06n, 100) 
	oPrn:say(nLin*53.3, nCol*37.3, "Folha/Quad./Item", oFnt06n, 100) 
	oPrn:box(nLin*52  , nCol*50  , nLin*55, nCol*60)                             //Box Data Implementeção
	oPrn:say(nLin*52.3, nCol*50.3, "Data Implementação", oFnt06n, 100) 
	oPrn:box(nLin*55  , nCol*6   , nLin*58, nCol*60)                             //Box Assunto
	oPrn:say(nLin*55.3, nCol*6.3 , "Assunto:", oFnt06n, 100)
	oPrn:say(nLin*56  , nCol*12  , alltrim(ZC9->ZC9_ASSUN1), oFnt08, 100)

	oPrn:box(nLin*52  , nCol*60   , nLin*55, nCol*66)                             //Box Item nº coluna 2
	oPrn:say(nLin*52.3, nCol*60.3 , "Item nº", oFnt06n, 100) 
	oPrn:box(nLin*52  , nCol*66   , nLin*55, nCol*91)                             //Box Modificação / Documento
	oPrn:say(nLin*52.3, nCol*66.3 , "Modificação / Documento", oFnt06n, 100) 
	oPrn:box(nLin*52  , nCol*91   , nLin*55, nCol*104)                            //Box Identificação Folha/Quad./Item
	oPrn:say(nLin*52.3, nCol*91.3 , "Identificação", oFnt06n, 100) 
	oPrn:say(nLin*53.3, nCol*91.3 , "Folha/Quad./Item", oFnt06n, 100) 
	oPrn:box(nLin*52  , nCol*104  , nLin*55, nCol*114)                            //Box Data Implementeção
	oPrn:say(nLin*52.3, nCol*104.3, "Data Implementação", oFnt06n, 100) 
	oPrn:box(nLin*55  , nCol*60   , nLin*58, nCol*114)                            //Box Assunto
	oPrn:say(nLin*55.3, nCol*60.3 , "Assunto:", oFnt06n, 100)
	oPrn:say(nLin*56  , nCol*66   , alltrim(ZC9->ZC9_ASSUN2), oFnt08, 100)
	
	dbSelectArea("ZCK")
	
	ZCK->(dbGoTop())
	ZCK->(dbSetOrder(1)) //ZCK_FILIAL + ZCK_NUMHIS + ZCK_ITEM
	ZCK->(dbSeek(xFilial("ZCK") + ZC9->ZC9_NUMHIS))

	nColuna := 1
	
	nCont := 58
		
	while ZCK->(!eof()) .and. (ZCK->ZCK_FILIAL + ZCK->ZCK_NUMHIS) == (xFilial("ZCK") + ZC9->ZC9_NUMHIS)
		
		if nColuna == 1
			oPrn:box(nLin*nCont, nCol*6  , nLin*(nCont+3), nCol*12)       //Box coluna 1 Item nº
			oPrn:box(nLin*nCont, nCol*12 , nLin*(nCont+3), nCol*37)       //Box coluna 1 Modificação / Documento
			oPrn:box(nLin*nCont, nCol*37 , nLin*(nCont+3), nCol*50)       //Box coluna 1 Identificação Folha/Quad./Item
			oPrn:box(nLin*nCont, nCol*50 , nLin*(nCont+3), nCol*60)       //Box coluna 1 Data Implementeção
		
			oPrn:box(nLin*nCont, nCol*60 , nLin*(nCont+3), nCol*066)     //Box coluna 2 Item nº
			oPrn:box(nLin*nCont, nCol*66 , nLin*(nCont+3), nCol*091)     //Box coluna 2 Modificação / Documento
			oPrn:box(nLin*nCont, nCol*91 , nLin*(nCont+3), nCol*104)     //Box coluna 2 Identificação Folha/Quad./Item
			oPrn:box(nLin*nCont, nCol*104, nLin*(nCont+3), nCol*114)     //Box coluna 2 Data Implementeção

			oPrn:say(nLin*(nCont+1), nCol*7    , ZCK->ZCK_ITEM           , oFnt08, 100) 
			oPrn:say(nLin*(nCont+1), nCol*12.3 , alltrim(ZCK->ZCK_MODDOC), oFnt06, 100) 
			oPrn:say(nLin*(nCont+1), nCol*37.3 , alltrim(ZCK->ZCK_FOLHA) , oFnt06, 100) 
			oPrn:say(nLin*(nCont+1), nCol*52.5 , dtoc(ZCK->ZCK_DTIMP)    , oFnt08, 100) 
			
			nCont += 3
			nColuna := 2
		else
			oPrn:say(nLin*(nCont-2), nCol*61   , ZCK->ZCK_ITEM           , oFnt08, 100) 
			oPrn:say(nLin*(nCont-2), nCol*66.3 , alltrim(ZCK->ZCK_MODDOC), oFnt06, 100) 
			oPrn:say(nLin*(nCont-2), nCol*91.3 , alltrim(ZCK->ZCK_FOLHA) , oFnt06, 100) 
			oPrn:say(nLin*(nCont-2), nCol*106.5, dtoc(ZCK->ZCK_DTIMP)    , oFnt08, 100) 
			
			nColuna := 1
		endif
		
		ZCK->(dbSkip())

	enddo
	
	oPrn:box(nLin*nCont      , nCol*6  , nLin*(nCont+3), nCol*114)
	oPrn:say(nLin*(nCont+1)  , nCol*6.3, "Data de Aprovação: ", oFnt06n, 100) 
	oPrn:say(nLin*(nCont+0.8), nCol*16 , cAprov, oFnt08, 100) 
	oPrn:say(nLin*(nCont+1)  , nCol*36 , "Resp. Análise: ", oFnt06n, 100) 
	oPrn:say(nLin*(nCont+0.8), nCol*44 , cResp, oFnt08, 100) 
	oPrn:say(nLin*(nCont+1) , nCol*72 , "Ass. Supervisor: " , oFnt06n, 100) 
	oPrn:say(nLin*(nCont+0.8), nCol*81 , cSup, oFnt08, 100) 
	
return ( )
//=============================== FIM DO BOX04 =============================== 

