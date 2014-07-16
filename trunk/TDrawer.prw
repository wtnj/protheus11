#include 'TOTVS.CH'
User Function TDrawer
Private isText := .F.
Private colors := {CLR_HRED, -1} // Linha Vermelha / Fundo Transparente

 DEFINE DIALOG oDlg TITLE "Exemplo TDrawer" FROM 180,180 TO 550,700 PIXEL
 
  // Menu de Opções
  oMenu := TMenu():New()
  oMenu:Add(TMenuItem():New(oMenu:Owner(),'Abre',,,,{||isText:=.F.,openFile()}))   
  oMenu:Add(TMenuItem():New(oMenu:Owner(),'Salva',,,,{||isText:=.F.,saveFile()}))   
  oMenu:Add(TMenuItem():New(oMenu:Owner(),'Texto',,,,{||isText:=.T.}))   
  oMenu:Add(TMenuItem():New(oMenu:Owner(),'Selecao',,,,{||isText:=.F.,oDrawer:SetType(0)}))
  oMenu:Add(TMenuItem():New(oMenu:Owner(),'Traço',,,,{||isText:=.F.,oDrawer:SetType(1)}))
  oMenu:Add(TMenuItem():New(oMenu:Owner(),'Livre',,,,{||isText:=.F.,oDrawer:SetType(2)}))
  oMenu:Add(TMenuItem():New(oMenu:Owner(),'Circulo',,,,{||isText:=.F.,oDrawer:SetType(3)}))
  oMenu:Add(TMenuItem():New(oMenu:Owner(),'Retang.',,,,{||isText:=.F.,oDrawer:SetType(4)}))
  oMenu:Add(TMenuItem():New(oMenu:Owner(),'Oval',,,,{||isText:=.F.,oDrawer:SetType(5)}))
  oMenu:Add(TMenuItem():New(oMenu:Owner(),'Fonte',,,,;
           {||oDrawer:SetFontText(TFont():New('Verdana',0,-30)),alert('Fonte alterada')}))
  oMenu:Add(TMenuItem():New(oMenu:Owner(),'Cores',,,,{||defineColor()}))
  oMenu:Add(TMenuItem():New(oMenu:Owner(),'Desfaz',,,,{||oDrawer:Undo()}))
  oMenu:Add(TMenuItem():New(oMenu:Owner(),'Recorta',,,,{||oDrawer:Crop()}))
  oMenu:Add(TMenuItem():New(oMenu:Owner(),'Cola',,,,{||oDrawer:Paste()}))
  oMenu:Add(TMenuItem():New(oMenu:Owner(),'Limpa',,,,{||oDrawer:ClearImage()}))

  // Cria Scroll e TDrawer para a imagem
  oTScrollBox :=  TScrollBox():New(oDlg,02,80,184,180,.T.,.T.,.T.)
  oDrawer := tDrawer():New(0,0,oTScrollBox,900,550)
   
  // Define cores iniciais
  oDrawer:SetColors(colors[1], colors[2])

  // Blocos de código do mouse
  oDrawer:blClicked := {|o,x,y| click(x,y)}
  oDrawer:brClicked := {|o,x,y| Alert('Click direito do mouse')}
 
 ACTIVATE MSDIALOG oDlg CENTERED  
Return

//------------------------------
// Funções de apoio
//------------------------------
Static Function click(x,y)
  if (isText)
    text := 'Digite o texto'
    inputQuery('Adiciona texto','Digite texto - "|" para pulo de linha',@text)
    oDrawer:AddText(x,y,text)
  endif
Return     
               
Static Function saveFile()
Local cFile := 'C:\Dir\imagem.JPG'
  inputQuery('Salva imagem','Arquivo (JPG, PNG ou BMP)',@cFile)
  oDrawer:SaveImage( cFile, 'JPG' )
Return

Static Function openFile()
  cFile := AllTrim( cGetFile( 'Arquivo JPG|*.Jpg|Arquivo PNG|*.Png|Arquivo BMP|*.Bmp',;
          'Selecione arquivo', 0, 'C:\Dir\', .T.,;
          GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ) )

  if ( file(cFile) )
    oDrawer:OpenImage(cFile)
  endif
Return

Static Function inputQuery(cTitulo,cDescr,cResult)
Local cGet1 := PadR(cResult,200)
Local oGet1                        
Local oDlgInput
  DEFINE MSDIALOG oDlgInput TITLE cTitulo FROM 178,181 TO 270,443 PIXEL

    @ 002,002 Say cDescr Size 131,008 of oDlgInput Pixel
    @ 014,002 Get oTGet VAR cGet1 SIZE 130,009 PIXEL OF oDlgInput
    oBtn1 := TButton():New( 30,002, 'Ok'     , oDlgInput,;
       {|| cResult:=Trim(cGet1),oDlgInput:End() },25,15,,,.F.,.T.,.F.,,.F.,,,.F. )
    oBtn2 := TButton():New( 30,034, 'Cancela', oDlgInput,;
       {|| cResult:='',oDlgInput:End() },25,15,,,.F.,.T.,.F.,,.F.,,,.F. )

 ACTIVATE MSDIALOG oDlgInput CENTERED 
Return

Static Function defineColor()
Local oDlgColor
  DEFINE MSDIALOG oDlgColor TITLE 'Escolhe as Cores Linha/Fundo' FROM 01,01 TO 450,450 PIXEL

    oColorPen   := tColorTriangle():New(001,02,oDlgColor,200,100)
    oColorBrush := tColorTriangle():New(102,02,oDlgColor,200,100)
    oBtn1 := TButton():New( 202,006, 'Ok', oDlgColor,{|| colors[1]:=oColorPen:retColor(),;
           colors[2]:=oColorBrush:retColor(),oDlgColor:End() },; 
           25,15,,,.F.,.T.,.F.,,.F.,,,.F. )

ACTIVATE MSDIALOG oDlgColor CENTERED 
 
// Define cores para a pintura
oDrawer:SetColors(colors[1], colors[2])
Return
