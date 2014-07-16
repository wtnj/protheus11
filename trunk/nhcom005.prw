/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHCOM005 ºAutor  ³Marcos R. Roquitski º Data ³  29/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Anexar desenhos ao produto.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico WHB.                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhcom005()

   SetPrvt("_cArquivo,_Tipo")

   _cArquivo := Space(50)
   _cArquivo := SB1->B1_ANEXO
	
	@ 200,050 To 350,500 Dialog DlgArquivo Title OemToAnsi("Anexar Desenhos ao Produto")

   @ 025,020 Say OemToAnsi("Local") Size 20,8

   @ 024,055 Get _cArquivo PICTURE "@!"  Size 110,8 When .F.

	@ 021,180 Button  "Localizar" Size 36,16 Action RunDlg()      
   @ 058,080 BMPBUTTON TYPE 01 ACTION GravaDados()
   @ 058,120 BMPBUTTON TYPE 02 ACTION Close(DlgArquivo)
   Activate Dialog DlgArquivo CENTERED

Return


Static Function GravaDados()
   RecLock("SB1",.F.)
   SB1->B1_ANEXO := _cArquivo
   MsUnlock("SB1")
   Close(DlgArquivo)
Return


Static Function RunDlg()

	_cTipo :=          "Todos os Arquivos (*.*)    | *.*   | "
	_cTipo := _cTipo + "Arquivos tipo     (*.DWG)  | *.DWG | "
	_cTipo := _cTipo + "Desenhos          (*.BMP)  | *.BMP   "
    
	// cFile := cGetFile(cTipo,"Dialogo de Selecao de Arquivos")
	_cArquivo := cGetFile(_cTipo,,0,,.T.,49)

Return


