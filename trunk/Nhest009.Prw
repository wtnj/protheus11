/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST009 ³ Autor ³ Alexandre R. Bento    ³ Data ³ 02/05/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Alteração da hora e data de chegada da NF de entrda         ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Fiscal Digitação de NF de entrada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Arquivos ³ SF1                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


#include "rwmake.ch"      
#include "Font.ch"
#include "Colors.ch"

User Function Nhest009()   

DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD                                           
SetPrvt("cCadastro,aRotina,cHorChe,dDatChe,cNota")

cCadastro := OemToAnsi("Alteração da Data e Hora de Chegada")

aRotina := {{ "Pesquisar"  ,"AxPesqui",0,1},;
            { "Altera"   ,'U_fAltera()',0,2}}

DbSelectArea("SF1")
SF1->(DbSetOrder(1))
DbGoTop()
            
mBrowse(06,01,22,75,"SF1",,)                           

Return(nil)    

User Function fAltera()

   cHorChe := SF1->F1_HORACHE
   dDatChe := SF1->F1_DATACHE
   cNota   := "Nota : " +SF1->F1_DOC + " - " +SF1->F1_SERIE

	@ 96,42 TO 250,405 DIALOG oDlg6 TITLE OemToAnsi("Alteração da Data e Hora de Chegada")
   @ 10,14 Say OemToAnsi(cNota) Color CLR_BLUE Size 100,10 object oNota 
     oNota:SetFont(oFont)
	@ 25,14 Say OemToAnsi("Data de Chegada :") Size 60,10
	@ 37,14 Say OemToAnsi("Hora de Chegada :") Size 60,10
	@ 24,64 Get dDatChe Picture "99/99/99" Size 40,10 Valid NaoVazio(dDatche) Object oDatChe
	@ 36,64 Get cHorChe Picture "99:99"    Size 30,10 Valid fHora() Object oHorChe
	@ 55,110 BUTTON "Altera" Size 50,15  ACTION fGrava()
	ACTIVATE DIALOG oDlg6 CENTERED
Return

Static Function fHora()

If Subs(cHorChe,1,2) == "  " .Or. Val(Subs(cHorChe,1,2)) > 24  .Or.;
   Subs(cHorChe,4,2) == "  " .Or. Val(Subs(cHorChe,4,2)) > 59 
   Msgbox("Hora Invalida Redigite ","Atencao","STOP")                                                            
   Return(.F.)
Endif

Return(.T.)


Static Function fGrava()

   RecLock("SF1",.f.)
     SF1->F1_HORACHE := cHorChe
     SF1->F1_DATACHE := dDatChe     
    MsUnLock("SF1")
    Close(oDlg6)

Return 

