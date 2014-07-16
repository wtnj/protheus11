#INCLUDE "QPPR130.CH"
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"
#include "tbiconn.ch"    
#include "rwmake.ch"
#include "JPEG.CH"


/*
+----------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Programa                                                !
+------------------+---------------------------------------------------------+
!Modulo            ! PPAP                                                    !
+------------------+---------------------------------------------------------+
!Nome              ! QPPR013                                                 !
+------------------+---------------------------------------------------------+
!Descricao         ! Plano de Controle.                                      !
+------------------+---------------------------------------------------------+
!Autor             ! Hugo                                                    !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 20/02/09                                                !
+------------------+---------------------------------------------------------+
!   ATUALIZACOES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
*/

User Function QPPR013(lBrow,cPecaAuto,cJPEG)

Local oPrint
Local lPergunte := .F.   

Private cPecaRev 	:= ""
Private cStartPath 	:= GetSrvProfString("Startpath","")
Private	lQLGREL		:= GetMv("MV_QLGREL")    
Private nTamPapel

Default lBrow 		:= .F.
Default cPecaAuto	:= ""
Default cJPEG       := "" 

If Right(cStartPath,1) <> "\"
	cStartPath += "\"
Endif

If !Empty(cPecaAuto)
	cPecaRev := cPecaAuto
Endif

oPrint := TMSPrinter():New("PLANO DE CONTROLE") //"FMEA de Processo"
oPrint:SetUp()
oPrint:SetLandscape()  


AjusteSx1()
lPergunte := Pergunte("PPR130",.T.)

If lPergunte 
	cPecaRev := mv_par01 + mv_par02	
Endif
		
nTamPapel	:= Mv_Par04
//nTamPapel	:= 1  

If nTamPapel == 1   
	oPrint:SetPaperSize(9)
Else
	oPrint:SetPaperSize(8)
EndIf 

DbSelectArea("QK1")
DbSetOrder(1)
DbSeek(xFilial()+cPecaRev)

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1") + QK1->QK1_CODCLI + QK1->QK1_LOJCLI)

DbSelectArea("QK7") 
DbSetOrder(1)
If DbSeek(xFilial()+cPecaRev)

	If Empty(cPecaAuto)
		MsgRun(STR0002,"",{|| CursorWait(), fMontaRel(oPrint) ,CursorArrow()}) //"Gerando Visualizacao, Aguarde..."
	Else
		fMontaRel(oPrint)
	Endif

	If lPergunte .and. mv_par03 == 1 .or. !Empty(cPecaAuto)
		If !Empty(cJPEG)
   			oPrint:SaveAllAsJPEG(cStartPath+cJPEG,1120,840,140)
        Else
			oPrint:Print()
		EndIF
	Else
		oPrint:Preview()  		// Visualiza antes de imprimir
	Endif
Endif

Return Nil

 
/*
+----------------------------------------------------------------------------+
!                             fMontaRel()                                    !
+----------------------------------------------------------------------------+
!Descricao         ! Monta o Relatório.                                      !
+------------------+---------------------------------------------------------+
!Autor             ! Hugo                                                    !
+------------------+---------------------------------------------------------+
*/

Static Function fMontaRel(oPrint)

Local i 	:= 1, nCont := 0
Local x 	:= 0, lin, nPos
Local aTxt, nx
Local cTexto
Local cOpe
Local cItem		:= ""
Local cItemAnt	:= ""
Local nNPRMAX	:= GetMv("MV_NPRMAX")
Local axTextos  := {}
Local nxCont    := 0, nLinha := 0   
Local cNOPEAnt	:= ""

Private oFont08, oFont08B, oFont10, oFont16, oFont16B, oFontCou32B, oFont32, oFontCou08, oFontCou16, oFontNPR  
Private aTxt := {}

oFont06		:= TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
oFont08		:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
oFont10		:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont12		:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
oFont16		:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
oFont24		:= TFont():New("Arial",24,24,,.F.,,,,.T.,.F.)

oFont08B	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
oFont12B	:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
oFont16B	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
oFont24B	:= TFont():New("Arial",24,24,,.T.,,,,.T.,.F.)

oFontCou06	:= TFont():New("Courier New",06,06,,.F.,,,,.T.,.F.)
oFontCou08	:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
oFontCou12	:= TFont():New("Courier New",12,12,,.F.,,,,.T.,.F.)
oFontCou16	:= TFont():New("Courier New",16,16,,.F.,,,,.T.,.F.)

oFontNPR	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)

	
	cQuery := "	SELECT "
	cQuery += "		*  "
	cQuery += "	FROM   "
	cQuery += 	 		RetSQLName("QKL")+" QKL, " + RetSQLName("QKM")+" QKM, " + RetSQLName("QKK")+" QKK, " + RetSQLName("QK2")+" QK2 "
	cQuery += "	WHERE  "
	cQuery += "		QKL_FILIAL = QKM_FILIAL AND "
	cQuery += "		QKL_FILIAL = QK2_FILIAL AND "
	cQuery += "		QKL_FILIAL = QKK_FILIAL AND "
	cQuery += "		QKL_PECA = '" + mv_par01 + "' AND "
	cQuery += "		QKL_REV = '" + mv_par02 + "' AND "
	cQuery += "		QKL_PECA = QKM_PECA AND     "
	cQuery += "		QKL_PECA = QK2_PECA AND     "
	cQuery += "		QKL_PECA = QKK_PECA AND     "
	cQuery += "		QKL_REV = QKM_REV AND       "
	cQuery += "		QKL_REV = QK2_REV AND       "
	cQuery += "		QKL_REV = QKK_REV AND       "
	cQuery += "		QKM_ITEM = QK2_ITEM AND     " 
	cQuery += "		QKM_NOPE = QKK_NOPE         "
	cQuery += "		ORDER BY                    "
	cQuery += "			QKM_NOPE, QKM_ITEM      "
	
	   //	memowrit("f:\totvs\sqldump\tppr013.sql", cQuery)
			
	TCQuery cQuery Alias '_QRY' NEW
	dbSelectArea('_QRY')
	DbGoTop()

DbSelectArea("QK1")
DbSetOrder(1)
DbSeek(xFilial()+cPecaRev)

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1") + QK1->QK1_CODCLI + QK1->QK1_LOJCLI) 
	
Cabecalho(oPrint,i)  	// Funcao que monta o cabecalho
lin := 790  

//cNOPEAnt := _QRY->QKM_NOPE

While !_QRY->(EOF())
	nLinha := 1
	For nxCont := 1 To Len(_QRY->QK2_ITEM) Step 4
		If Len(aTxt) <> 0
			nPos := aScan( aTxt, { |x| x[1] == nLinha })
		Else
			nPos := 0
		Endif

		If !Empty(Subs(_QRY->QK2_ITEM,nxCont,4))
			If nPos == 0
				aAdd( aTxt,{	nLinha, Subs(_QRY->QK2_ITEM,nxCont,4), Space(19), Space(19), Space(08),;
								Space(19), Space(14), Space(14), Space(05) })
      		Else
				aTxt[nPos,2] := Subs(_QRY->QK2_ITEM,nxCont,4)
   			Endif
   		Endif		
   		nLinha++   		
	Next nxCont  
	

    aTexto := JustificaTXT(_QRY->QK2_DESC,19) // Na situacao de quebra ele gera + 1
	nLinha := 1
	For nxCont := 1 To Len(aTexto)
		If Len(aTxt) <> 0
			nPos := aScan( aTxt, { |x| x[1] == nLinha })
		Else
			nPos := 0
		Endif

		If nPos == 0
			aAdd( aTxt,{	nLinha, Space(06), aTexto[nxCont], Space(19), Space(08),;
							Space(19), Space(14), Space(14), Space(05) })
   		Else
			aTxt[nPos,3] := aTexto[nxCont]
		Endif
   		nLinha++   		
	Next nxCont 
	

	nLinha := 1
	For nxCont := 1 To Len(_QRY->QK2_TPCAR) Step 4
		If Len(aTxt) <> 0
			nPos := aScan( aTxt, { |x| x[1] == nLinha })
		Else
			nPos := 0
		Endif

		If !Empty(Subs(_QRY->QK2_TPCAR,nxCont,4))
			If nPos == 0
				aAdd( aTxt,{	nLinha, Space(19), Subs(_QRY->QK2_TPCAR,nxCont,4), Space(19), Space(08),;
								Space(19), Space(14), Space(14), Space(05) })
      		Else
				aTxt[nPos,4] := Subs(_QRY->QK2_TPCAR,nxCont,4)
   			Endif
   		Endif		
   		nLinha++   		
	Next nxCont  

	nLinha := 1
	For nxCont := 1 To Len(_QRY->QK2_ESPE) Step 4
		If Len(aTxt) <> 0
			nPos := aScan( aTxt, { |x| x[1] == nLinha })
		Else
			nPos := 0
		Endif

		If !Empty(Subs(_QRY->QK2_ESPE,nxCont,4))
			If nPos == 0
				aAdd( aTxt,{	nLinha, Space(06), Space(19), Space(19), Subs(_QRY->QK2_ESPE,nxCont,4),;
								Space(19), Space(14), Space(14), Space(05) })
			Else
				aTxt[nPos,5] := Subs(_QRY->QK2_ESPE,nxCont,4)
			Endif
		Endif
		nLinha++
	Next nxCont 	

    aTexto := JustificaTXT(_QRY->QKM_TECAVA,16) // Na situacao de quebra ele gera + 1
	nLinha := 1
	For nxCont := 1 To Len(aTexto) 
		If Len(aTxt) <> 0
			nPos := aScan( aTxt, { |x| x[1] == nLinha })
		Else
			nPos := 0
		Endif

		If nPos == 0
			aAdd( aTxt,{	nLinha, Space(06), Space(19), Space(19), Space(08),;
							aTexto[nxCont], Space(14), Space(14), Space(05) })
      		Else
			aTxt[nPos,6] := aTexto[nxCont]
		Endif

   				
   		nLinha++
	Next nxCont

    aTexto := JustificaTXT(_QRY->QKM_FREQ,8) // Na situacao de quebra ele gera + 1
	nLinha := 1
	For nxCont := 1 To Len(aTexto) 
		If Len(aTxt) <> 0
			nPos := aScan( aTxt, { |x| x[1] == nLinha })
		Else
			nPos := 0
		Endif

		If nPos == 0
			aAdd( aTxt,{	nLinha, Space(06), Space(19), Space(19), Space(08),;
							Space(19), 	aTexto[nxCont], Space(14), Space(05) })
      		Else
			aTxt[nPos,7] := aTexto[nxCont]
		Endif

   				
   		nLinha++
	Next nxCont

    aTexto := JustificaTXT(_QRY->QKM_METCON,19) // Na situacao de quebra ele gera + 1
	nLinha := 1
	For nxCont := 1 To Len(aTexto) 
		If Len(aTxt) <> 0
			nPos := aScan( aTxt, { |x| x[1] == nLinha })
		Else
			nPos := 0
		Endif

		If nPos == 0
			aAdd( aTxt,{	nLinha, Space(06), Space(19), Space(19), Space(08),;
							Space(19), Space(18), aTexto[nxCont], Space(05) })
      		Else
			aTxt[nPos,8] := aTexto[nxCont]
		Endif

   				
   		nLinha++
	Next nxCont

    aTexto := JustificaTXT(_QRY->QKM_PLREA,19) // Na situacao de quebra ele gera + 1
	nLinha := 1
	For nxCont := 1 To Len(aTexto) 
		If Len(aTxt) <> 0
			nPos := aScan( aTxt, { |x| x[1] == nLinha })
		Else
			nPos := 0
		Endif

		If nPos == 0
			aAdd( aTxt,{	nLinha, Space(06), Space(19), Space(19), Space(08),;
							Space(19), Space(18), Space(18), aTexto[nxCont] })
      		Else
			aTxt[nPos,9] := aTexto[nxCont]
		Endif

   				
   		nLinha++
	Next nxCont
	
	IIF(nTamPapel == 1, nLinha1	:= 700, nLinha1	:= 1100)
	
	If Len(aTxt) > 0
		
	If _QRY->QKM_NOPE <> cNOPEAnt .AND. !Empty(cNOPEAnt)
		IIF(nTamPapel == 1, nLinha1	:= 700, nLinha1	:= 1100)	          
		oPrint:EndPage()  
		i++
		Cabecalho(oPrint,i)  
//		MostraFoto()
	EndIf 

		PPAPBMP(_QRY->QK2_SIMB+".BMP", cStartPath)
		IIF(nTamPapel == 1, oPrint:SayBitmap(nLinha1,1820, _QRY->QK2_SIMB+".BMP",40,40),;
							oPrint:SayBitmap(nLinha1,2730, _QRY->QK2_SIMB+".BMP",60,60))
		
		For nxCont := 1 To Len(aTxt)
	   		IIF(nTamPapel == 1, oPrint:Say(nLinha1,1310,aTxt[nxCont,2],oFont08 ),	oPrint:Say(nLinha1,2000,aTxt[nxCont,2],oFont12 )) 
	   		IIF(nTamPapel == 1, oPrint:Say(nLinha1,1390,aTxt[nxCont,3],oFont08 ),	oPrint:Say(nLinha1,2130,aTxt[nxCont,3],oFont12 )) 
//			IIF(nTamPapel == 1, oPrint:Say(nLinha1,1820,aTxt[nxCont,4],oFont08 ),	oPrint:Say(nLinha1,2730,aTxt[nxCont,4],oFont12 )) 		
			IIF(nTamPapel == 1, oPrint:Say(nLinha1,1890,aTxt[nxCont,5],oFont08 ),	oPrint:Say(nLinha1,2830,aTxt[nxCont,5],oFont12 )) 
			
			IIF(nTamPapel == 1, oPrint:Say(nLinha1,2190,aTxt[nxCont,6],oFont08 ),	oPrint:Say(nLinha1,3250,aTxt[nxCont,6],oFont12 )) 		
			IIF(nTamPapel == 1, oPrint:Say(nLinha1,2490,aTxt[nxCont,7],oFont08 ),	oPrint:Say(nLinha1,3670,aTxt[nxCont,7],oFont12 )) 
//	   		IIF(nTamPapel == 1, oPrint:Say(nLinha1,2670,_QRY->QKM_,oFont08 ),		oPrint:Say(nLinha1,3850,"WHB",oFont12 )) 
			IIF(nTamPapel == 1, oPrint:Say(nLinha1,2740,aTxt[nxCont,8],oFont08 ),	oPrint:Say(nLinha1,3930,aTxt[nxCont,8],oFont12 )) 
			If _QRY->QKM_NOPE <> cNOPEAnt
				IIF(nTamPapel == 1, oPrint:Say(nLinha1,3000,aTxt[nxCont,9],oFont08 ),	oPrint:Say(nLinha1,4370,aTxt[nxCont,9],oFont12 ))
			EndIf
	
   			IIF(nTamPapel == 1, nLinha1+=70, nLinha1+=100) 
		Next
	EndIf 
	
	cNOPEAnt := _QRY->QKM_NOPE  
	_QRY->(DbSkip())    
	
	IIF(nTamPapel == 1, oPrint:Line( nLinha1, 1300, nLinha1, 2980 ), oPrint:Line( nLinha1, 2000, nLinha1, 4350 )) // horizontal 
   	IIF(nTamPapel == 1, nLinha1+=70, nLinha1+=130) 
	
End 

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Cabecalho³ Autor ³ Robson Ramiro A. Olive³ Data ³ 19.06.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³FMEA de Processo                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Cabecalho(ExpO1,ExpN1)                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oPrint                                      ³±±
±±³          ³ ExpN1 = Contador de paginas                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QPPR013                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Cabecalho(oPrint,i)    

Local cFileLogo  := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial
Local nWeight, nWidth
Local nLinIni1	:= 250
Local nLinFim1	:= 860 

/*Local nLinIni2	:= 890
Local nLinFim2	:= 3200 

Local nColIni	:= 30
Local nColFim	:= 4300  

Local nTamLinha	:= 120   
Local nTamCol2	:= 450   */

Local aDimensao	:=	{}
Local lFile		
Local cBmpPict	:= ""
Local cPath		:= GetSrvProfString("Startpath","")
Local oDlg8
Local oBmp  
//Local aFotos	{}                                                   

oPrint:StartPage() 		// Inicia uma nova pagina  
 
/*
+----------------------------------------------------------------------------+
!                             Carrega a Foto                                 !
+----------------------------------------------------------------------------+*/
cBmpPict 	:= Upper( AllTrim( _QRY->QKK_BITMAP)) 
cPathPict 	:= IIF(File( cPath + cBmpPict+".JPG" ),( cPath + cBmpPict+".JPG" ), ( cPath + cBmpPict+".BMP" ))   

IF nTamPapel == 1
	nLargura	:= 1200
	nAltura		:= 1400 
Else
	nLargura	:= 1900
	nAltura		:= 2000
EndIf

DEFINE MSDIALOG oDlg8   FROM -1000000,-4000000 TO -10000000,-8000000  PIXEL 
@ -10000000, -1000000000000 REPOSITORY oBmp SIZE -6000000000, -7000000000 OF oDlg8  
	oBmp:LoadBmp(cBmpPict)
	IF !Empty( cBmpPict := Upper( AllTrim( _QRY->QKK_BITMAP ) ) )
		IF !File( cPathPict)
			lFile:=oBmp:Extract(cBmpPict  ,cPathPict,.F.)
			If lFile 
				oBmp:lAutoSize 	:= .T. 
				oBmp:lStretch	:= .F. 				
				aDimensao		:=	sfImagem (nAltura, nLargura,oBmp:nClientHeight,oBmp:nClientWidth)                                                                                        
				IIF(nTamPapel == 1, oPrint:SayBitmap(680,30,cPathPict,aDimensao[2],aDimensao[1],,.T.), ;
									oPrint:SayBitmap(1080,30,cPathPict,aDimensao[2],aDimensao[1],,.T.))//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha)									
			Endif	
		Else 	
			oBmp:lAutoSize 	:= .T. 
			oBmp:lStretch	:= .F. 							
			aDimensao		:=	sfImagem (nAltura, nLargura,oBmp:nClientHeight,oBmp:nClientWidth)                                                                                        
			IIF(nTamPapel == 1, oPrint:SayBitmap(680,30,cPathPict,aDimensao[2],aDimensao[1],,.T.),;
								oPrint:SayBitmap(1080,30,cPathPict,aDimensao[2],aDimensao[1],,.T.))				
		EndIF
	EndIF
//	aAdd(aFotos,cPathPict)
ACTIVATE MSDIALOG oDlg8 ON INIT (oBmp:lStretch := .T., oDlg8:End())    

// Box Cabecalho
IIF(nTamPapel == 1, oPrint:Box( 50, 30, 450, 3350 ), oPrint:Box( 50, 30, 850, 4800 ))

// Construcao da Grade
IIF(nTamPapel == 1, oPrint:Line( 150, 30, 150, 3350 ), oPrint:Line( 250, 30, 250, 4800 ))   	// horizontal
IIF(nTamPapel == 1, oPrint:Line( 200, 30, 200, 3350 ), oPrint:Line( 350, 30, 350, 4800 ))   	// horizontal
IIF(nTamPapel == 1, oPrint:Line( 250, 30, 250, 3350 ), oPrint:Line( 450, 30, 450, 4800 ))  		// horizontal
IIF(nTamPapel == 1, oPrint:Line( 350, 30, 350, 3350 ), oPrint:Line( 650, 30, 650, 4800 ))   	// horizontal

IIF(nTamPapel == 1, oPrint:Line( 50, 240, 150, 240 ), oPrint:Line( 50, 350, 250, 350 ))  // vertical
IIF(nTamPapel == 1, oPrint:Line( 50, 900, 150, 900 ), oPrint:Line( 50, 1450, 250, 1450 )) // vertical


IIF(nTamPapel == 1, oPrint:Line( 100, 900, 100, 3350 ), oPrint:Line( 150, 1450, 150, 4800))   	// horizontal

IIF(nTamPapel == 1, oPrint:Line( 50, 1200, 150, 1200 ), oPrint:Line( 50, 1830, 250, 1830 ))   	// vertical  
IIF(nTamPapel == 1, oPrint:Line( 50, 1500, 150, 1500 ), oPrint:Line( 50, 2210, 250, 2210 ))   	// vertical
IIF(nTamPapel == 1, oPrint:Line( 50, 1900, 250, 1900 ), oPrint:Line( 50, 2600, 450, 2600 ))  // vertical
IIF(nTamPapel == 1, oPrint:Line( 50, 2500, 250, 2500 ), oPrint:Line( 50, 3650, 450, 3650 ))  // vertical
IIF(nTamPapel == 1, oPrint:Line( 50, 3000, 150, 3000 ), oPrint:Line( 50, 4420, 250, 4420 )) // vertical
 
//Segunda linha
IIF(nTamPapel == 1, oPrint:Line( 150, 0400, 250, 0400 ), oPrint:Line( 250, 600, 450, 600 ))   	 // vertical  
IIF(nTamPapel == 1, oPrint:Line( 150, 0700, 250, 0700 ), oPrint:Line( 250, 1050, 450, 1050 )) 	 // vertical
IIF(nTamPapel == 1, oPrint:Line( 150, 1300, 250, 1300 ), oPrint:Line( 250, 1700, 450, 1700 )) 	 // vertical
IIF(nTamPapel == 1, oPrint:Line( 150, 2250, 250, 2250 ), oPrint:Line( 250, 3100, 450, 3100 )) 	 // vertical
IIF(nTamPapel == 1, oPrint:Line( 150, 2850, 450, 2850 ), oPrint:Line( 250, 4000, 850, 4000 )) 	 // vertical

IIF(nTamPapel == 1, oPrint:Line( 250, 2400, 450, 2400 ), oPrint:Line( 450, 3300, 850, 3300 ))	 // vertical
IIF(nTamPapel == 1, oPrint:Line( 290, 2400, 290, 3350 ), oPrint:Line( 550, 3300, 550, 4800 ))    // horizontal

IIF(nTamPapel == 1, oPrint:Line( 350, 0320, 450, 0320 ), oPrint:Line( 650, 600, 850, 600 ))  // vertical
IIF(nTamPapel == 1, oPrint:Line( 350, 1920, 450, 1920 ), oPrint:Line( 650, 2600, 850, 2600 )) // vertical
IIF(nTamPapel == 1, oPrint:Line( 390, 1920, 390, 3350 ), oPrint:Line(750, 2600, 750, 4800 ))   	// horizontal

// Descricao cabecalho
IIF(nTamPapel == 1, oPrint:Say(070,0060,"WHB",oFont16B ), oPrint:Say(070,0070,"WHB",oFont24B )) 
IIF(nTamPapel == 1, oPrint:Say(070,0250,"PLANO DE CONTROLE",oFont16B ), oPrint:Say(070,0370,"PLANO DE CONTROLE",oFont24B ))

IIF(nTamPapel == 1, oPrint:Say(060,0950,"PROTOTIPO",oFontCou08 ), oPrint:Say(070,1460,"PROTOTIPO",oFontCou16 ))   
IIF(nTamPapel == 1, oPrint:Say(110,1050,Iif(_QRY->QKL_TPPRO == "1","(X)","( )"),oFont08 ),;		
					oPrint:Say(170,1460,Iif(_QRY->QKL_TPPRO == "1","(X)","( )"),oFont16 )) 
					 
IIF(nTamPapel == 1, oPrint:Say(060,1250,"PRÉ-SÉRIE",oFontCou08 ),	oPrint:Say(070,1840,"PRÉ-SÉRIE",oFontCou16 )) 
IIF(nTamPapel == 1, oPrint:Say(110,1350,Iif(_QRY->QKL_TPPRO == "2","(X)","( )"),oFont08 ),; 		
					oPrint:Say(170,1840,Iif(_QRY->QKL_TPPRO == "2","(X)","( )"),oFont16 )) 
					
IIF(nTamPapel == 1, oPrint:Say(060,1550,"PRODUÇÃO",oFontCou08 ), 	oPrint:Say(070,2220,"PRODUÇÃO",oFontCou16 ))  
IIF(nTamPapel == 1, oPrint:Say(110,1650,Iif(_QRY->QKL_TPPRO == "3","(X)","( )"),oFont08 ),; 		
					oPrint:Say(170,2220,Iif(_QRY->QKL_TPPRO == "3","(X)","( )"),oFont16 )) 

IIF(nTamPapel == 1, oPrint:Say(060,2000,"N.   DOC.:",oFontCou08 ), 			oPrint:Say(070,2610,"N.   DOC.:",oFontCou16 )) 
IIF(nTamPapel == 1, oPrint:Say(110,2000,_QRY->QKL_PLAN,oFont08 ), 			oPrint:Say(170,2610,_QRY->QKL_PLAN,oFont16 )) 
IIF(nTamPapel == 1, oPrint:Say(060,2650,"PROCESSISTA/RAMAL:",	oFontCou08 ), 	oPrint:Say(070,3660,"PROCESSISTA/RAMAL:",oFontCou16 )) 
IIF(nTamPapel == 1, oPrint:Say(110,2650,_QRY->QKL_PROC +  " / " + _QRY->QKL_RAMAL,	oFont08 ),oPrint:Say(170,3660,_QRY->QKL_PROC +  " / " + _QRY->QKL_RAMAL,oFont16 )) 
IIF(nTamPapel == 1, oPrint:Say(060,3050,"FOLHA:",oFontCou08 ), 				oPrint:Say(070,4430,"FOLHA:",oFontCou16 )) 
IIF(nTamPapel == 1, oPrint:Say(110,3050,STR(i),oFont08 ), 					oPrint:Say(170,4430,STR(i),oFont16 )) 

//Segunda Linha
IIF(nTamPapel == 1, oPrint:Say(160,0070,"CÓDIGO WHB/REV.",oFontCou08 ),oPrint:Say(260,0055,"CÓDIGO WHB/REV.",oFontCou16 )) 
IIF(nTamPapel == 1, oPrint:Say(210,0070,Alltrim(QK1->QK1_PECA)+" / "+QK1->QK1_REV,oFont08 ),;
					oPrint:Say(360,0070,Alltrim(QK1->QK1_PECA)+" / "+QK1->QK1_REV,oFont16 )) 
IIF(nTamPapel == 1, oPrint:Say(160,0420,"N. PEÇA CLIENTE:",oFontCou08 ), oPrint:Say(260,610,"N. PEÇA CLIENTE:",oFontCou12 ))
IIF(nTamPapel == 1, oPrint:Say(210,0420,QK1->QK1_PCCLI,oFont08 ), oPrint:Say(360,610,QK1->QK1_PCCLI,oFont16 )) 
IIF(nTamPapel == 1, oPrint:Say(160,0800,"DENOMINAÇÃO:",oFontCou08 ), 	oPrint:Say(260,1060,"DENOMINAÇÃO:",oFontCou16 )) 
IIF(nTamPapel == 1, oPrint:Say(210,0800,Subs(QK1->QK1_DESC,1,60),oFont08 ), 	oPrint:Say(360,1060,Subs(QK1->QK1_DESC,1,60),oFont16 ))
IIF(nTamPapel == 1, oPrint:Say(160,1400,"CLIENTE:",oFontCou08 ), 		oPrint:Say(260,1710,"CLIENTE:",oFontCou16 )) 
IIF(nTamPapel == 1, oPrint:Say(210,1400,Subs(SA1->A1_NOME,1,22),oFont08 ), 		oPrint:Say(360,1710,Subs(SA1->A1_NOME,1,22),oFont16 ))
 
IIF(nTamPapel == 1, oPrint:Say(160,1900,"MAQUINA:",oFontCou08 ), 		oPrint:Say(260,2610,"MAQUINA:",oFontCou16 )) 
IIF(nTamPapel == 1, oPrint:Say(210,1900,_QRY->QKK_MAQ,oFont08 ), 		oPrint:Say(360,2610,_QRY->QKK_MAQ,oFont16 ))  
IIF(nTamPapel == 1, oPrint:Say(160,2300,"OPERAÇÃO:",oFontCou08 ), 		oPrint:Say(260,3110,"OPERAÇÃO:",oFontCou16 )) 
IIF(nTamPapel == 1, oPrint:Say(210,2300,_QRY->QKK_NOPE,oFont08 ), 		oPrint:Say(360,3110,_QRY->QKK_NOPE,oFont16 )) 
IIF(nTamPapel == 1, oPrint:Say(160,2550,"DATA   EMISSÃO:",oFontCou08 ),oPrint:Say(260,3660,"DATA EMISSÃO:",oFontCou12 )) 
IIF(nTamPapel == 1, oPrint:Say(210,2550,"",oFont08 ),oPrint:Say(360,3660,"",oFont16 )) 
cQKL_DTAFOR	:= SubStr(_QRY->QKL_DTAFOR,7,2) +"/"+ SubStr(_QRY->QKL_DTAFOR,5,2) +"/"+ SubStr(_QRY->QKL_DTAFOR,1,4)
IIF(nTamPapel == 1, oPrint:Say(160,2870,"APROV.   ENGENHARIA/DATA:",oFontCou08 ), oPrint:Say(260,4020,"APROV. ENGENHARIA/DATA:",oFontCou12 )) 
IIF(nTamPapel == 1, oPrint:Say(210,2870,Subs(Alltrim(_QRY->QKL_APRFOR),1,20)+" / "+cQKL_DTAFOR,oFont08 ),; 
					oPrint:Say(360,4010,Subs(Alltrim(_QRY->QKL_APRFOR),1,20)+" / "+cQKL_DTAFOR,oFont16 )) 

IIF(nTamPapel == 1, oPrint:Say(260,0060,"EQUIPE   DE   APQP:",oFontCou08 ),		oPrint:Say(460,0060,"EQUIPE DE APQP:",oFontCou16 ))
IIF(nTamPapel == 1, oPrint:Say(310,0060,_QRY->QKL_EQPRIN,oFont08 ),		oPrint:Say(460,3310,_QRY->QKL_EQPRIN,oFont16 )) 
IIF(nTamPapel == 1, oPrint:Say(260,2410,"APROVAÇÃO   CLIENTE/DATA:", oFontCou08 ), oPrint:Say(460,3310,"APROVAÇÃO CLIENTE/DATA:",oFontCou12 )) 
IIF(nTamPapel == 1, oPrint:Say(310,2410,_QRY->QKL_APQUCL + " / " + _QRY->QKL_DTAQUA,oFont08 ), oPrint:Say(560,3310,_QRY->QKL_APQUCL + " / " + _QRY->QKL_DTAQUA,oFont16 )) 
IIF(nTamPapel == 1, oPrint:Say(260,2860,"APROVAÇÃO   QUALIDADE/DATA:", oFontCou08 ), oPrint:Say(460,4010,"APROVAÇÃO QUALIDADE/DATA:",oFontCou12 )) 
IIF(nTamPapel == 1, oPrint:Say(310,2860,_QRY->QKL_APRFOR + " / " + _QRY->QKL_DTAFOR,oFont08 ), oPrint:Say(560,4010,_QRY->QKL_APRFOR + " / " +  _QRY->QKL_DTAFOR,oFont16 )) 


IIF(nTamPapel == 1, oPrint:Say(360,0060,"DESCRIÇÃO   DA",	oFontCou08 ), oPrint:Say(660,0060,"DESCRIÇÃO   DA",oFontCou16 ))
IIF(nTamPapel == 1, oPrint:Say(410,0060,"	OPERAÇÃO:",	oFontCou08 ), oPrint:Say(760,0060,"	OPERAÇÃO:",oFontCou16 )) 
IIF(nTamPapel == 1, oPrint:Say(410,0360,_QRY->QKK_DESC,	oFont08 ), oPrint:Say(660,0610,_QRY->QKK_DESC,oFont16 ))  

cQKL_RVDESUS	:= SubStr(_QRY->QKL_RVDESUS,7,2) +"/"+ SubStr(_QRY->QKL_RVDESUS,5,2) +"/"+ SubStr(_QRY->QKL_RVDESUS,1,4)
IIF(nTamPapel == 1, oPrint:Say(360,1930,"N. DESENHO USINADO/REVISAO:",oFontCou08 ), 	oPrint:Say(660,2610,"N. DESENHO USINADO/REVISAO:",oFontCou12 )) 
IIF(nTamPapel == 1, oPrint:Say(410,1930,_QRY->QKL_DESUSI + " / " + cQKL_RVDESUS,oFont08 ), 	oPrint:Say(760,2610,_QRY->QKL_DESUSI + " / " + cQKL_RVDESUS,oFont16 )) 

cQKL_RVDESBR	:= SubStr(_QRY->QKL_RVDESBR,7,2) +"/"+ SubStr(_QRY->QKL_RVDESBR,5,2) +"/"+ SubStr(_QRY->QKL_RVDESBR,1,4)
IIF(nTamPapel == 1, oPrint:Say(360,2410,"N. DESENHO BRUTO/REVISÃO:",	oFontCou08 ), oPrint:Say(660,3310,"N. DESENHO BRUTO/REVISÃO:",oFontCou12 )) 
IIF(nTamPapel == 1, oPrint:Say(410,2410,_QRY->QKL_DESBRU + " / " + cQKL_RVDESBR,	oFont08 ), oPrint:Say(760,3310,_QRY->QKL_DESBRU + " / " + cQKL_RVDESBR,oFont16 ))

cQKL_RVDESMO	:= SubStr(_QRY->QKL_RVDESMO,7,2) +"/"+ SubStr(_QRY->QKL_RVDESMO,5,2) +"/"+ SubStr(_QRY->QKL_RVDESMO,1,4) 
IIF(nTamPapel == 1, oPrint:Say(360,2860,"N. DESENHO MONTADO/REVISAO:",oFontCou08 ), 	oPrint:Say(660,4010,"N. DESENHO MONTADO/REVISAO:",oFontCou12 ))
IIF(nTamPapel == 1, oPrint:Say(410,2860,_QRY->QKL_DESMON + " / " + cQKL_RVDESMO,oFont08 ), 	oPrint:Say(760,4010,_QRY->QKL_DESMON + " / " + cQKL_RVDESMO,oFont16 )) 

 

// Box itens
IIF(nTamPapel == 1, oPrint:Box( 530, 30, 2000, 3350 ), oPrint:Box( 880, 30, 2900, 4800 ))

IIF(nTamPapel == 1, oPrint:Line( 680, 30, 680, 3350 ), oPrint:Line( 1080, 30, 1080, 4800 ))   	// horizontal

IIF(nTamPapel == 1, oPrint:Line( 0630, 1800, 0630, 2170 ), oPrint:Line( 990, 2700, 990, 3220 )) // horizontal
 

// Construcao da grade itens
IIF(nTamPapel == 1, oPrint:Line( 530, 1300, 2000, 1300 ), oPrint:Line( 880, 2000, 2900, 2000 ))   	// vertical 
IIF(nTamPapel == 1, oPrint:Line( 530, 1370, 2000, 1370 ), oPrint:Line( 880, 2100, 2900, 2100 ))   	// vertical
IIF(nTamPapel == 1, oPrint:Line( 530, 1800, 2000, 1800 ), oPrint:Line( 880, 2700, 2900, 2700 ))   	// vertical
IIF(nTamPapel == 1, oPrint:Line( 630, 1870, 2000, 1870 ), oPrint:Line( 980, 2800, 2900, 2800 ))   	// vertical
IIF(nTamPapel == 1, oPrint:Line( 530, 2170, 2000, 2170 ), oPrint:Line( 880, 3220, 2900, 3220 ))   	// vertical
IIF(nTamPapel == 1, oPrint:Line( 530, 2470, 2000, 2470 ), oPrint:Line( 880, 3640, 2900, 3640 ))   	// vertical
IIF(nTamPapel == 1, oPrint:Line( 530, 2650, 2000, 2650 ), oPrint:Line( 880, 3820, 2900, 3820 ))   	// vertical
IIF(nTamPapel == 1, oPrint:Line( 530, 2720, 2000, 2720 ), oPrint:Line( 880, 3920, 2900, 3920 ))   	// vertical
IIF(nTamPapel == 1, oPrint:Line( 530, 2980, 2000, 2980 ), oPrint:Line( 880, 4350, 2900, 4350 ))   	// vertical

 
// Descricao itens  

IIF(nTamPapel == 1, oPrint:Say(560,600,"DESENHO DO PRODUTO",oFontCou08), oPrint:Say(900,800,"DESENHO DO PRODUTO",oFontCou16))
IIF(nTamPapel == 1, oPrint:Say(560,1310,"ITEM",oFontCou06), oPrint:Say(900,2005,"ITEM",oFontCou12)) 

IIF(nTamPapel == 1, oPrint:Say(560,1550,"DESCRIÇÃO",oFontCou08), oPrint:Say(900,2120,"DESCRIÇÃO",oFontCou16)) 

IIF(nTamPapel == 1, oPrint:Say(540,1830,"CARACTEREISTICA   E",oFontCou08), oPrint:Say(890,2710,"CARACTEREISTICA E",oFontCou12))
IIF(nTamPapel == 1, oPrint:Say(590,1830,"ESPECIFICAÇÃO",oFontCou08), oPrint:Say(930,2710,"ESPECIFICAÇÃO",oFontCou12)) 
IIF(nTamPapel == 1, oPrint:Say(650,1805,"CAR.",oFontCou08), oPrint:Say(1000,2710, "CAR.",oFontCou12)) 
IIF(nTamPapel == 1, oPrint:Say(650,2000,"ESP.",oFontCou08), oPrint:Say(1000,3000, "ESP.",oFontCou12)) 

IIF(nTamPapel == 1, oPrint:Say(560,2200,"TÉCNICA   DE",oFontCou08), oPrint:Say(900,3230,"TÉCNICA DE",oFontCou16)) 
IIF(nTamPapel == 1, oPrint:Say(620,2200,"AVALIAÇÃO",oFontCou08), oPrint:Say(950,3230,"AVALIAÇÃO",oFontCou16)) 

IIF(nTamPapel == 1, oPrint:Say(560,2500,"FREQ.",oFontCou08), oPrint:Say(900,3650,"FREQ.",oFontCou16)) 

IIF(nTamPapel == 1, oPrint:Say(560,2645,"CLASSE",oFontCou06), oPrint:Say(900,3822,"CLAS",oFontCou12)) 
IIF(nTamPapel == 1, "", oPrint:Say(940,3835,"SE",oFontCou12)) 

IIF(nTamPapel == 1, oPrint:Say(560,2750,"MÉTODO   DE",oFontCou08), oPrint:Say(900,3930,"MÉTODO DE",oFontCou16)) 
IIF(nTamPapel == 1, oPrint:Say(620,2750,"CONTROLE",oFontCou08), oPrint:Say(950,3930,"CONTROLE",oFontCou16)) 

IIF(nTamPapel == 1, oPrint:Say(560,3010,"PLANO DE REAÇÃO",oFontCou08), oPrint:Say(900,4360,"PLANO DE",oFontCou16)) 
IIF(nTamPapel == 1, "", oPrint:Say(950,4360,"REAÇÃO",oFontCou16)) 
          

IIF(nTamPapel == 1, oPrint:Box( 2100, 30, 2300, 3350 ), oPrint:Box( 2950, 30, 3250, 4800 ))  

IIF(nTamPapel == 1, oPrint:Line( 2150, 30, 2150, 3350 ), oPrint:Line( 3025, 30, 3025, 4800 ))   	// horizontal
IIF(nTamPapel == 1, oPrint:Line( 2200, 30, 2200, 3350 ), oPrint:Line( 3100, 30, 3100, 4800 ))   	// horizontal
IIF(nTamPapel == 1, oPrint:Line( 2250, 30, 2250, 3350 ), oPrint:Line( 3175, 30, 3175, 4800 ))   	// horizontal

IIF(nTamPapel == 1, oPrint:Line( 2100, 0200, 2300, 0200 ), oPrint:Line( 2950, 0400, 3250, 0400 ))   	// Vertical
IIF(nTamPapel == 1, oPrint:Line( 2100, 1200, 2300, 1200 ), oPrint:Line( 2950, 1400, 3250, 1400 ))   	// Vertical
IIF(nTamPapel == 1, oPrint:Line( 2100, 1500, 2300, 1500 ), oPrint:Line( 2950, 1850, 3250, 1850 ))   	// Vertical
IIF(nTamPapel == 1, oPrint:Line( 2100, 2000, 2300, 2000 ), oPrint:Line( 2950, 2600, 3250, 2600 ))   	// Vertical

IIF(nTamPapel == 1, oPrint:Say(2110,0700,"REVISÕES", oFont08), oPrint:Say(2960,0700,"REVISÕES", oFont12)) 
IIF(nTamPapel == 1, oPrint:Say(2110,2010,"CLASSES:", oFont08), oPrint:Say(2960,2620,"CLASSES:", oFont12))

IIF(nTamPapel == 1, oPrint:Say(2160,0040,"IND.", oFont08), oPrint:Say(3035,0040,"IND.", oFont12))
IIF(nTamPapel == 1, oPrint:Say(2160,0210,"MOTIVO", oFont08), oPrint:Say(3035,0410,"MOTIVO", oFont12))
IIF(nTamPapel == 1, oPrint:Say(2160,1210,"DATA", oFont08), oPrint:Say(3035,1410,"DATA", oFont12))
IIF(nTamPapel == 1, oPrint:Say(2160,1510,"NOME", oFont08), oPrint:Say(3035,1860,"NOME", oFont12)) 

IIF(nTamPapel == 1, oPrint:Say(2210,2010,"CARACTERISTICAS:", oFont08),  oPrint:Say(3110,2620,"CARACTERISTICAS:", oFont12))  

IIF(nTamPapel == 1, oPrint:Say(2110,2350,"MP - ", oFont08B), oPrint:Say(2960,3200,"MP - ", oFont12B))
IIF(nTamPapel == 1, oPrint:Say(2110,2430,"MONITORAMENTO DE PROCESSO", oFont08), oPrint:Say(2960,3350,"MONITORAMENTO DE PROCESSO", oFont12))
IIF(nTamPapel == 1, oPrint:Say(2160,2350,"CP - ", oFont08B), oPrint:Say(3035,3200,"CP - ", oFont12B))
IIF(nTamPapel == 1, oPrint:Say(2160,2430,"CRITICO DE PROCESSO",	oFont08), oPrint:Say(3035,3350,"CRITICO DE PROCESSO",	oFont12)) 
IIF(nTamPapel == 1, oPrint:Say(2210,2350,"PD - ", oFont08B), oPrint:Say(3110,3200,"PD - ", oFont12B))
IIF(nTamPapel == 1, oPrint:Say(2210,2430,"CARACTERISTICA DO PRODUTO", oFont08), oPrint:Say(3110,3350,"CARACTERISTICA DO PRODUTO", oFont12))
IIF(nTamPapel == 1, oPrint:Say(2260,2350,"PC - ", oFont08B), oPrint:Say(3185,3200,"PC - ", oFont12B))
IIF(nTamPapel == 1, oPrint:Say(2260,2430,"CARACTERISTICA DE PROCESSO", oFont08), oPrint:Say(3185,3350,"CARACTERISTICA DE PROCESSO", oFont12))        

               
Return Nil 
 

//===============================FIM DO BOX05 FOTO/CROQUI DA EMBALAGEM    ================================================ 
//===============================Ajuste de Imagem ========================================================================
//Altura Desejada, Largura Desejada , Altura da Imagem , Largura da Imagem 
Static Function sfImagem (nAltDesej,nLarDesej,nAltBMP,nLarBMP)
Local aRet	:={0,0}//{ Altura da Imagem , Largura da Imagem }
Local nPerAlt:=0
Local nPerLar:=0
Do Case
	Case nAltDesej>=nAltBMP .AND. nLarDesej>=nLarBMP //Imagem com dimensões dentro das desejadas
		aRet[1]:=nAltBMP
		aRet[2]:=nLarBMP		
	Case nAltDesej < nAltBMP //Altura fora da desejada
		nPerAlt:=(nAltDesej/nAltBMP)				
		aRet[1]:=nAltBMP*nPerAlt
		aRet[2]:=nLarBMP*nPerAlt		
	Case nLarDesej < nLarBMP  //Largura fora da desejada			
		nPerLar:=(nLarDesej/nLarBMP)
		aRet[1]:=nAltBMP*nPerLar
		aRet[2]:=nLarBMP*nPerLar
EndCase				
Return (aRet)   
//==================================================Fim do Ajuste de Imagem =======================================================

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjusteSx1 ºAutor  ³Leandro Souza       º Data ³15/01/07     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria perguntas para impressao de Codigo / Descricao de      º±±
±±º          ³Caracteristicas.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QPPR013                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjusteSx1()

PutSx1("PPR130","01","Numero da Peca?"     ,"¨Num. de Pieza?"     ,"Part Number?"  ,"mv_ch1","C",40,0,0,"G","ExistCpo('QK1',mv_par01,1) .and. NaoVazio()","QPM","" ,"S","mv_par01")
PutSx1("PPR130","02","Revisao?"            ,"¨Revision?"          ,"Revision?"     ,"mv_ch2","C",2,0,0,"G","ExistCpo('QK1',mv_par01+mv_par02,1)"         ,"","","S","mv_par02")
PutSx1("PPR130","03","Tipo de Impressao?"  ,"¨Tipo de Impresion?" ,"Printing Type?","mv_ch3","N",1,0,0,"C","","","","N","mv_par03","Impressora","Impresora","Printer"," ","Tela","Pantalla" ,"Screen")
PutSx1("PPR130","04","Tam da Impressao?"  ," "                    ,""              ,"mv_ch4","N",1,0,0,"C","","","","N","mv_par04","A4","A4","A4"," ","A3","A3" ,"A3")

Return Nil
