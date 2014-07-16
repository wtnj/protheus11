/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Nhfat0023 ³ Autor ³ Marcos R. Roquitski   ³ Data ³ 14.04.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±  
±±³Descricao ³Altera Peso.                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico New Hubner.                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
#include "rwmake.ch"  

User Function Nhfat023()   

SetPrvt("CCADASTRO,AROTINA,")

cCadastro := 'Notas Fiscais'

aRotina := {{ "Pesquisar"    ,"AxPesqui",0,1},;
            { "Altera Pesos" ,"U_fnhfat023()",0,2}}

DbSelectArea("SF2")
SF2->(DbSetOrder(1))
DbGoTop()
            
mBrowse(,,,,"SF2",,)

Return(nil)    


User Function fNhfat023()  


  SetPrvt("_nPliqui,_nPbruto")


   _nPliqui  := SF2->F2_PLIQUI 
   _nPbruto  := SF2->F2_PBRUTO   
	
	@ 200,050 To 400,500 Dialog DlgArquivo Title OemToAnsi("Altera Peso Bruto/Peso Liquido")

   @ 025,020 Say OemToAnsi("Peso Liquido") Size 20,8
   @ 045,020 Say OemToAnsi("Peso   Bruto") Size 20,8

   @ 024,055 Get _nPliqui  PICTURE "@E 999,999.99"  Size 110,8 
   @ 044,055 Get _nPbruto  PICTURE "@E 999,999.99"  Size 110,8 

   @ 068,080 BMPBUTTON TYPE 01 ACTION GravaDados()
   @ 068,120 BMPBUTTON TYPE 02 ACTION Close(DlgArquivo)
   Activate Dialog DlgArquivo CENTERED

Return


Static Function GravaDados()
   RecLock("SF2",.F.)
   SF2->F2_PLIQUI := _nPliqui
   SF2->F2_PBRUTO := _nPbruto
   MsUnlock("SF2")
   Close(DlgArquivo)
Return
