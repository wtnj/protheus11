#INCLUDE "rwmake.ch" 
#include "JPEG.CH"

/*----------+-----------+-------+--------------------+------+----------------+
! Programa  ! TPPAR010  ! Autor ! GUSTAVO RIBEIRO    ! Data !  17/02/09      !
+-----------+-----------+-------+--------------------+------+----------------+
! Descricao ! IMPRESSÃO POKA YOKE                                            !
!           ! REFERENTE AO FONTE TPPAC013                                    !
+----------------------------------------------------------------------------+
! Uso       ! WHB MSQL e MP10 1.2                                            !
+---------------------------------------------------------------------------*/

//============================ PROGRAMA PRINCIPAL ============================
user function TPPAR010 ( )

	private cBmpLogo	:= "\system\logo_whb.bmp"
	private cBmpLinha	:= "\system\LinhaVerde.bmp"
		
	private oFnt06		:= TFont():New("Arial",,06,,.f.,,,,,.f.)
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
	private aAreaZC4	:=	ZC4->(GetArea())
	private nRecno		:=	0
	private cPKYK		:=	ZC4->ZC4_PKYK 
	 
	dbSelectArea("ZC4")
	
	ZC4->(dbGoTop())
	ZC4->(dbSetOrder(1)) //ZC4_FILIAL, ZC4_PKYK, ZC4_REV, R_E_C_N_O_, D_E_L_E_T_
	ZC4->(dbSeek(xFilial("ZC4") + cPKYK))
	
	while ZC4->(!eof()) .and. (ZC4->ZC4_FILIAL + ZC4->ZC4_PKYK) == (xFilial("ZC4") + cPKYK)

		if ZC4->ZC4_STAREV .and. ZC4->ZC4_STATUS == "S"
			nRecno := ZC4->(recno())
		endif

		ZC4->(dbSkip())

	enddo
	
	ZC4->(dbGoTo(nRecno))
	
	oPrn := TMSPrinter():New("Poka Yoke") //Cria Objeto para impressao Grafica

	oPrn:Setup()                          //Chama a rotina de Configuracao da impressao
	oPrn:SetPortrait()					  //Seta o relatório como retrato
	oPrn:StartPage()                      //Cria nova Pagina 

	if ZC4->ZC4_STAREV .and. ZC4->ZC4_STATUS == "S"
		sfCabec()                         //Impressao do Cabecalho			
		sfbox01()                         //box de dados 01
		sfbox02()                         //box de dados 02
		sfbox03()                         //box de dados 03
		sfbox04()                         //box de dados 04
		sfbox05()                         //box de dados 05
		sfbox06()                         //box de dados 06
		sfBoxIMG()                        //box da imagem de melhoria
	endif														
	
	oPrn:EndPage()
	
	oPrn:Preview()

	RestArea(aAreaZC4) 

Return ( )
//================================= FIM DO PROGRAMA PRINCIPAL ===============================

//================================== IMPRESSÃO DO CABEÇALHO =================================
Static function sfCabec()
	
	local nLin:= 20
	local nCol:= 20
	local cDescProd:= posicione("QK1", 1, xFilial("QK1") + ZC4->(ZC4_NUMPC + ZC4_REVPC), "QK1_DESC")
	local cEmitente:= posicione("QAA", 1, xFilial("QAA") + ZC4->ZC4_EMITEN, "QAA_APELID")
	
	oPrn:box(nLinInc, nColInc, nLin*21, nCol*114)                               //box do Cabeçalho 
	oPrn:say(nLin*08, nCol*45, "POKA YOKE", oFnt22n, 100) 
   	oPrn:say(nLin*10, nCol*70, AllTrim(ZC4->ZC4_PKYK), oFnt11n, 100)
	oPrn:say(nLin*10, nCol*81, "/", oFnt11n, 100)
	oPrn:say(nLin*10, nCol*82, AllTrim(ZC4->ZC4_REV), oFnt11n, 100)
		
	oPrn:box(nLinInc, nColInc, nLin*15, nCol*26)                                //box Logo
	oPrn:sayBitmap(nLinInc + nLin, nColInc + nCol, cBmpLogo, nCol*18, nLin*7)
    
	oPrn:box(nLin*05, nCol*090, nLin*09, nCol*114)                               //box emissão
	oPrn:say(nLin*06, nCol*091, "EMISSÃO:", oFnt08, 100) 
	oPrn:say(nLin*07, nCol*101, dToc(ZC4->ZC4_EMISSA), oFnt09n, 100)
	
	oPrn:box(nLin*09, nCol*90, nLin*15, nCol*114)                               //box da introdução
	oPrn:say(nLin*10, nCol*91, "NºDOCUMENTO:", oFnt08, 100) 
	oPrn:say(nLin*12, nCol*95, AllTrim(ZC4->ZC4_PKYK) +"-"+ AllTrim(ZC4->ZC4_REV), oFnt09n, 100)
	
	oPrn:box(nLin*15, nColInc, nLin*21, nCol*47)                                //box descrição do produto
	oPrn:say(nLin*16, nColInc + nCol, "DESCRIÇÃO DO PRODUTO:", oFnt08, 100)
	oPrn:say(nLin*18, nColInc + nCol, AllTrim(cDescProd), oFnt09n, 100)

	oPrn:box(nLin*15, nCol*47, nLin*21, nCol*90)                                //box código do produto
	oPrn:say(nLin*16, nCol*48, "CÓDIGO DO PRODUTO:", oFnt08, 100) 
	oPrn:say(nLin*18, nCol*48, AllTrim(ZC4->ZC4_NUMPC) +"-"+ AllTrim(ZC4->ZC4_REVPC), oFnt09n, 100) 

	oPrn:box(nLin*15, nCol*90, nLin*21, nCol*114)                               //box da emitente
	oPrn:say(nLin*16, nCol*91, "EMITENTE:", oFnt08, 100) 
	oPrn:say(nLin*18, nCol*91, AllTrim(cEmitente), oFnt09n, 100) 

return ( )
//=========================== FIM DA IMPRESSÃO DO CABEÇALHO ==========================

//=============================== BOX01 =================================
static function sfbox01()
	
	local nLin:= 20
	local nCol:= 20
	
	oPrn:box(nLin*22, nColInc, nLin*30, nCol*114)               //box principal
	oPrn:say(nLin*23, nCol*50, "POKA YOKE DE:", oFnt16n, 100) 
	
	oPrn:box(nLin*26, nColInc, nLin*30, nCol*23)
	oPrn:say(nLin*27, nColInc + nCol, "PREVENÇÃO", oFnt08, 100)
	oPrn:box(nLin*27, nCol*20, nLin*29, nCol*22)
	
	oPrn:box(nLin*26, nCol*23, nLin*30, nCol*46)
	oPrn:say(nLin*27, nCol*24, "DETECÇÃO", oFnt08, 100) 
	oPrn:box(nLin*27, nCol*43, nLin*29, nCol*45)
	
	oPrn:box(nLin*26, nCol*46, nLin*30, nCol*69)
	oPrn:say(nLin*27, nCol*47, "INTERRUPÇÃO", oFnt08, 100) 
	oPrn:box(nLin*27, nCol*66, nLin*29, nCol*68)
	
	oPrn:box(nLin*26, nCol*69, nLin*30, nCol*92)
	oPrn:say(nLin*27, nCol*70, "CONTROLE", oFnt08, 100) 
	oPrn:box(nLin*27, nCol*89, nLin*29, nCol*91)

	oPrn:box(nLin*26, nCol*092, nLin*30, nCol*114)
	oPrn:say(nLin*27, nCol*093, "AVISO", oFnt08, 100) 
	oPrn:box(nLin*27, nCol*111, nLin*29, nCol*113)
	                  
	//1=PREVENCAO; 2=DETECCAO; 3=INTERRUPCAO; 4=CONTROLE; 5=AVISO
	if ZC4->ZC4_TIPOPY == '1'							
		oPrn:say(nLin*27, nCol*020, "X", oFnt14n, 100)
	elseif ZC4->ZC4_TIPOPY == '2'
		oPrn:say(nLin*27, nCol*043, "X", oFnt14n, 100)
	elseif ZC4->ZC4_TIPOPY == '3'
		oPrn:say(nLin*27, nCol*066, "X", oFnt14n, 100)
	elseif ZC4->ZC4_TIPOPY == '4'
		oPrn:say(nLin*27, nCol*089, "X", oFnt14n, 100)
	elseif ZC4->ZC4_TIPOPY == '5'
		oPrn:say(nLin*27, nCol*111, "X", oFnt14n, 100)
	endif

return ( )                                                                                                       
//=============================== FIM DO BOX01 =============================== 

//=============================== BOX02 =================================
static function sfbox02()
	
	local nLin:= 20
	local nCol:= 20
	
	oPrn:box(nLin*31, nColInc, nLin*39, nCol*114)               //box principal
	oPrn:say(nLin*32, nCol*54, "EQUIPE", oFnt16n, 100) 
	
	oPrn:box(nLin*35, nColInc, nLin*39, nCol*23)
	oPrn:say(nLin*36, nColInc + nCol, "1." + alltrim(ZC4->ZC4_EQUI1), oFnt08, 100)
		
	oPrn:box(nLin*35, nCol*23, nLin*39, nCol*46)
	oPrn:say(nLin*36, nCol*24, "2." + alltrim(ZC4->ZC4_EQUI2), oFnt08, 100) 
	
	oPrn:box(nLin*35, nCol*46, nLin*39, nCol*69)
	oPrn:say(nLin*36, nCol*47, "3." + alltrim(ZC4->ZC4_EQUI3), oFnt08, 100) 
	
	oPrn:box(nLin*35, nCol*69, nLin*39, nCol*92)
	oPrn:say(nLin*36, nCol*70, "4." + alltrim(ZC4->ZC4_EQUI4), oFnt08, 100) 

	oPrn:box(nLin*35, nCol*092, nLin*39, nCol*114)
	oPrn:say(nLin*36, nCol*093, "5." + alltrim(ZC4->ZC4_EQUI5), oFnt08, 100) 

return ( )
//=============================== FIM DO BOX02 =============================== 

//=============================== BOX03 =================================
static function sfbox03()
	
	local nLin:= 20
	local nCol:= 20
	local nCont:= 0
	
	oPrn:box(nLin*40, nColInc, nLin*70, nCol*114)               //box principal
	oPrn:say(nLin*41, nColInc + nCol, "DESCRIÇÃO DO PROCESSO:", oFnt08n, 100) 
	
	for nM := 1 to 13
		cLinhaObs:= memoline(ZC4->ZC4_DESCR, 140, nM ) 
		oPrn:say(nLin*(43 + nCont), nColInc + nCol, cLinhaObs, oFnt08, 100) 	       	
		nCont+=2	
	next nM

return ( )
//=============================== FIM DO BOX03 =============================== 

//=============================== BOX04 =================================
static function sfbox04()
	
	local nLin:= 20
	local nCol:= 20
	
	oPrn:box(nLin*71, nColInc, nLin*101, nCol*57)               //box principal
	oPrn:box(nLin*71, nColInc, nLin*075, nCol*57)               //Antes da melhoria
	oPrn:say(nLin*72, nCol*15, "ANTES DA MELHORIA", oFnt16n, 100) 
	
	oPrn:say(nLin*76, nColInc + nCol, substr(ZC4->ZC4_TXANTE,001, 50), oFnt08, 100) 
	oPrn:say(nLin*78, nColInc + nCol, substr(ZC4->ZC4_TXANTE,051, 50), oFnt08, 100) 
	oPrn:say(nLin*80, nColInc + nCol, substr(ZC4->ZC4_TXANTE,101, 50), oFnt08, 100) 
	
	oPrn:box(nLin*71, nCol*57, nLin*101, nCol*114)               //box principal
	oPrn:box(nLin*71, nCol*57, nLin*075, nCol*114)               //Após melhoria
	oPrn:say(nLin*72, nCol*74, "APÓS MELHORIA", oFnt16n, 100) 
	
	oPrn:say(nLin*76, nCol*58, substr(ZC4->ZC4_TXAPOS,001, 50), oFnt08, 100) 
	oPrn:say(nLin*78, nCol*58, substr(ZC4->ZC4_TXAPOS,051, 50), oFnt08, 100)
	oPrn:say(nLin*80, nCol*58, substr(ZC4->ZC4_TXAPOS,101, 50), oFnt08, 100)

return ( )
//=============================== FIM DO BOX04 =============================== 

//=============================== BOX05 =================================
static function sfbox05()
	
	local nLin := 20
	local nCol := 20
	local nCont:= 0
	
	oPrn:box(nLin*102, nColInc, nLin*122, nCol*114)               //box principal
	oPrn:box(nLin*102, nColInc, nLin*106, nCol*114)               //Antes da melhoria
	oPrn:say(nLin*103, nCol*51, "EFICÁCIA", oFnt16n, 100) 
	
	for nM := 1 to 7
		cLinhaObs:= memoline(ZC4->ZC4_EFICA, 140, nM ) 
		oPrn:say(nLin*(107 + nCont), nColInc + nCol, cLinhaObs, oFnt08, 100) 	       	
		nCont+=2	
	next nM

return ( )
//=============================== FIM DO BOX05 =============================== 

//=============================== BOX06 =================================
static function sfbox06()
	
	local nLin     := 20
	local nCol     := 20
	local nCont    := 0
	local cCoordena:= posicione("QAA", 1, xFilial("QAA") + ZC4->ZC4_EMITEN, "QAA_NOME")
	
	oPrn:box(nLin*124, nColInc, nLin*128, nCol*114)                                //Data eficácia
	oPrn:say(nLin*125, nColInc + nCol, "DATA DE VERIFICAÇÃO DA EFICÁCIA:", oFnt08, 100) 
	oPrn:say(nLin*125, nCol*34, dToc(ZC4->ZC4_EMISSA), oFnt09n, 100)

	oPrn:box(nLin*128, nColInc, nLin*132, nCol*114)                                //Coordenador
	oPrn:say(nLin*129, nColInc + nCol, "COORDENADOR DO PROJETO:", oFnt08, 100) 
	oPrn:say(nLin*129, nCol*30, cCoordena, oFnt09n, 100)

	oPrn:box(nLin*128, nCol*095, nLin*132, nCol*114)                                //Coordenador
	oPrn:say(nLin*129, nCol*096, "DATA:", oFnt08, 100) 
	oPrn:say(nLin*129, nCol*100, dToc(ZC4_APCOR), oFnt09n, 100)

return ( )
//=============================== FIM DO BOX06 =============================== 

//=============================== BoxIMG =================================
static Function sfBoxIMG()

	local nLin		:=	20
	local nCol		:=	20
	local aDimensao	:=	{}
	local cBmpPict	:= ""
	local cPath		:= GetSrvProfString("Startpath", "")
	local lFile     := .T.
	local oDlg8
	local oBmp  
	
	
	/*-----------------------------------------------------------+
	! Carrega a Foto 								             !
	+-----------------------------------------------------------*/
	cBmpPict := upper(alltrim(ZC4->ZC4_BITMAP)) 
	cPathPict:= iif(file(cPath + cBmpPict+".JPG"), (cPath + cBmpPict+".JPG"), (cPath + cBmpPict+".BMP"))
	
	/*-------------------------------------------------------------+
	! Para impressao da foto eh necessario abrir um dialogo para   !
	! extracao da foto do repositorio.No entanto na impressao,nao  !
	! ha a necessidade de visualiza-lo( o dialogo).Por esta razao  !
	! ele sera montado nestas coordenadas fora da Tela             !
	+-------------------------------------------------------------*/ 
	define msdialog oDlg8 from -1000000,-4000000 to -10000000,-8000000 pixel
	@ -10000000, -1000000000000 repository oBmp size -6000000000, -7000000000 of oDlg8  

	oBmp:LoadBmp(cBmpPict)
		
	if !empty(cBmpPict := upper(alltrim(ZC4->ZC4_BITMAP)))
		if !file(cPathPict)
			lFile:= oBmp:Extract(cBmpPict, cPathPict, .F.)
		endif
		
		if lFile
			oBmp:lAutoSize 	:= .T. 
			oBmp:lStretch	:= .F.
			aDimensao		:=	sfImagem(nLin*18, nCol*53, oBmp:nClientHeight, oBmp:nClientWidth)
			
			if ZC4->ZC4_POSICA == '1'
				oPrn:sayBitmap(nLin*82, nColInc + nCol, cPathPict, aDimensao[2], aDimensao[1], ,.T.)
			else
				oPrn:sayBitmap(nLin*82, nCol*59, cPathPict, aDimensao[2], aDimensao[1], ,.T.)
			endif
		endif	
	endif

	activate msdialog oDlg8 on init (oBmp:lStretch:= .T., oDlg8:end())

return ( )
//=============================== FIM DO BoxIMG =============================== 

//=============================== AJUSTA DE IMAGEM =================================
static function sfImagem(nAltDesej, nLarDesej, nAltBMP, nLarBMP)
	
	local aRet    := {0,0} //{Altura da Imagem, Largura da Imagem}
	local nPerAlt := 0
	local nPerLar := 0
	
	do case
		case nAltDesej>=nAltBMP .AND. nLarDesej>=nLarBMP //Imagem com dimensões dentro das desejadas
			aRet[1]:=nAltBMP
			aRet[2]:=nLarBMP
		case nAltDesej < nAltBMP                         //Altura fora da desejada
			nPerAlt:=(nAltDesej/nAltBMP)
			aRet[1]:=nAltBMP*nPerAlt
			aRet[2]:=nLarBMP*nPerAlt
		case nLarDesej < nLarBMP                         //Largura fora da desejada			
			nPerLar:=(nLarDesej/nLarBMP)
			aRet[1]:=nAltBMP*nPerLar
			aRet[2]:=nLarBMP*nPerLar
	endcase
	
return(aRet)   
//=============================== FIM DO AJUSTE DE IMAGEM =============================== 
