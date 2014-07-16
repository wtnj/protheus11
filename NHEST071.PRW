/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST071  ³ Autor ³ FABIO NICO             Data ³ 28/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Digitação de TICKET DA BALANCA                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FISCAL / PORTARIA                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "colors.ch"
#include "font.ch"

User Function nhest071()

SetPrvt("CCADASTRO,AROTINA,")

//AXCADASTRO("SO5","SO5")
cCadastro := OemToAnsi("Cadastramento de Ticket da Balanca")
aRotina := {{ "Pesquisa"	,'AxPesqui'  , 0,1},;
            { "Ticket"   	,'U_fTick(2)', 0,2},;
            { "Legenda"  	,"U_FLegTick", 0,2}}

DbSelectArea("SF1")
SF1->(DbSetOrder(1))
mBrowse( 6, 1,22,75,"SF1",,,,,,fCriaCor())

Return(nil)


User Function fTick(cpar)
DEFINE FONT oFont NAME "Arial" SIZE 12, -12                                                                  
SetPrvt("_cDoc,_dData,_cHora,_cMot,_cRG,_cPCam,_cEmp_cPCar,oDialog,_nPar,cQuery, _aMotiv, _cMotiv,_cPeso,")  

_nPar    := cpar
_aMotiv  := {"Coleta","Entrega","Funcionario" ,"Servico"," Visita"}
_cMotiv  := " "


If  _nPar == 2
    DbSelectArea("SF1")
   _cDoc    := space(8)
   _dData   := date()
   _cHora   := time()   
   _cPCam   := Space(08)
   _cPeso   := 0
   
Endif   
                 
Define MsDialog oDialog Title OemToAnsi("Digitacao de TICKET Balanca") From 020,030 To 250,555 Pixel 
@ 013,007 To 095,255 Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE
@ 027,010 Say "Numero :" Size 030,8 
@ 027,030 Get _cDoc Valid !empty(_cDoc)
@ 027,120 Say "Data:" Size 30,8            
@ 025,135 Get _dData Picture "99/99/99" When .F. Size 25,8 Object oData            
@ 027,200 Say "Hora:" Size 30,8            
@ 025,215 Get _cHora Picture "99:99:99" When .F. Size 25,8 Object oHora            
@ 055,010 Say "Peso Balanca :" Color CLR_HBLUE  Size 050,8
@ 055,050 Get _cPeso Picture "@e 999,999.9999" When(_nPar == 2) Size 120,8 

@ 100,180 BMPBUTTON TYPE 02 ACTION fEnd() //FCancela()
@ 100,225 BMPBUTTON TYPE 01 ACTION fGrVei()
Activate MsDialog oDialog Center //On Init EnchoiceBar(oDialog,bOk,bCancel,,) Centered valid fMot()

Return           

Static Function fEnd() 
   RollBackSx8() 
   Close(oDialog) 
Return


//  gravacao do ticket e peso no SF1

Static Function fGrVei()
DbSelectArea("SF1")
RecLock("SF1",.F.)
SF1->F1_TICKET  := _cDoc
SF1->F1_PESOTIC := _cPeso
MsUnLock("SF1")
Close(oDialog)
Return



User Function FLegTick()       
Local aLegenda :=	{ {"BR_VERMELHO", "Aberto" },;
  					  {"BR_VERDE"   , "Digitado"   }}

BrwLegenda("Tickets Digitados", "Legenda", aLegenda)
Return  


Static Function fCriaCor()       

Local aLegenda :=	{	{"BR_VERMELHO", "Aberto"  },;
  						{"BR_VERDE"   , "Digitado"  }}

Local uRetorno := {}
Aadd(uRetorno, { 'F1_TICKET = "0"', aLegenda[1][1] } )
Aadd(uRetorno, { 'F1_TICKET <>  "0"', aLegenda[2][1] } )

Return(uRetorno)



                                           
