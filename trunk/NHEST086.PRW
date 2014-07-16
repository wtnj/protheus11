/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST086  ³ Autor ³ FABIO NICO             Data ³ 28/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±                                              
±±³Descri‡…o ³ FICHA DE CONTROLE E AVARIA DE FERRAMENTA                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ESTOQUE / ESPECIFICOS WHB                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"  
#include "protheus.ch"  

User Function nhest086()
                  
SetPrvt("_aCombZh")
SetPrvt("_cDesc,_cDesc2,_cDesc3,_cOper")
SetPrvt("CCADASTRO,AROTINA,")

_cDocu		:= Space(06)
_cOper	 	:= space(06)
_dData   	:= date()
_cHora   	:= time()   
_cTurno  	:= space(1)
_cFerr		:= space(15)
_cDefe	 	:= space(10)
_cCC		:= space(15)  
_cDesc     	:= Space(30)
_cBroca		:= 0
_cQU		:= 0
_cFuso		:= 0
_cFornec    := space(6)
_cMaqui		:= space(15)  
_cDesc2    	:= Space(30)
_cDesc3    	:= Space(30)
_cDesc4    	:= Space(30)
_cDesc5     := Space(30)
_aCombZh 	:= {}
DEFINE FONT oFont NAME "Arial" SIZE 12, -12
//---------------------------------------------------------------
// BUSCA OS PROBLEMAS NA TABELA SX5
//---------------------------------------------------------------
SX5->(DbSetOrder(1))
SX5->(DbSeek(xFilial("SX5")+"Z3")) 

While !SX5->(Eof())  .And. SX5->X5_TABELA == "Z3"
	AADD(_aCombZh,Alltrim(SX5->X5_CHAVE)+" - "+SX5->X5_DESCRI)
	SX5->(DbSkip())
Enddo

//---------------------------------------------------------------
//  PEGA O ULTIMO NUMERO 
//---------------------------------------------------------------

DbSelectArea("ZA4")
_cDocu       := GetSXENum("ZA4","ZA4_DOC")   // Variaveis do Cabecalho do Cadastro
DbCloseArea()


cCadastro := OemToAnsi("Ficha de Controle de Avaria")
aRotina := {{ "Pesquisa"	,"AxPesqui"      , 0 , 1},;
            { "Visualizacao",'U_VControle()' , 0 , 2},;
            { "Inclui"   	,'U_IControle(3)' , 0 , 3},;
            { "Exclui"   	,'U_CExclui(3)'  , 0 , 3},; 
            { "Legenda" ,"U_FLegVei",0,5}}

           
DbSelectArea("ZA4")
ZA4->(DbSetOrder(1))
//mBrowse( 6, 1,22,75,"ZA4",,,,,,fCriacor())
mBrowse( 6, 1,22,75,"ZA4",,,,,,)
Return

//-----------------------------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------------------------
User Function IControle()
DbSelectArea("ZA4")
_cDocu       := GetSXENum("ZA4","ZA4_DOC")   // Variaveis do Cabecalho do Cadastro
//DbCloseArea()
Processa( {|| DDados() } )
return



//-----------------------------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------------------------
Static Function DDados()
Define MsDialog oDialog Title OemToAnsi("Ficha de Controle e Avaria de Ferramenta") From 020,030 To 465,770 Pixel 
@ 013,007 To 180,362 Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE

@ 027,010 Say "Documento :" Size 030,8  Object ocDoc
@ 027,040 Say _cDocu Size 035,8 Object oDocu
oDocu:Setfont(oFont)
 
@ 027,170 Say "Data:" Size 30,86
@ 025,185 Get _dData Picture "99/99/9999" Size 40,8 Object oData            
@ 025,235 Get _cHora Picture "99:99:99"   Size 25,8 Object oHora
  
@ 040,010 Say "Operador:" Size 30,8  OBJECT ioperador
@ 038,040 Get _cOper	  Picture "@!" F3 "QAA" Valid fOpe() Size 55,8 Object oOper
@ 038,120 Get _cDesc      Picture "@!" When .F. Size 120,8 Object oDesc

@ 053,010 Say "Turno:" Size 050,8 Object iturno
@ 051,040 Get _cTurno Picture "@!" Valid fNTurno() Size 10,8 Object oTurno

@ 066,010 Say "Ferramenta:" Size 030,8 Object iFerra
@ 063,040 Get _cFerr 	  Picture "@!" F3 "SB1" Valid fFerra() Size 70,8 Object oFerr
@ 063,120 Get _cDesc2     Picture "@!" When .F. Size 120,8 Object oDesc2

@ 079,010 Say "Maquina:" Size 050,8 object oTMaq
@ 076,040 Get _cMaqui Picture "@!" F3 "ST9" Valid fMaqui() Size 70,8 Object oMaqui
@ 076,120 Get _cDesc4     Picture "@!" When .F. Size 120,8 Object oDesc4

@ 092,010 Say "Defeito:" Size 030,8 Object iDefeito
@ 089,040 COMBOBOX _cDefe  ITEMS _aCombZh  SIZE 170,10 object oCombZh 

@ 105,010 Say "C.C.:" Size 050,8 object oTCC
@ 105,040 Get _cCC Picture "@!" F3 "CTT" Valid fCC() Size 70,8 Object oCC
@ 105,120 Get _cDesc3     Picture "@!" When .F. Size 120,8 Object oDesc3

@ 118,010 Say "Broca Canhao Nº :" Size 050,8 object oTBroca
@ 118,060 Get _cBroca Picture "9999" Size 70,8 Object oBroca

@ 131,010 Say "Qtde. Usinada:" Size 050,8 object oTQU
@ 131,060 Get _cQU Picture "9999" Size 70,8 Object oQU
                                                                      
@ 144,010 Say "Fuso :" Size 050,8 object oTFuso
@ 144,060 Get _cFuso Picture "9999" Size 70,8 Object oFuso

@ 157,010 Say "Fornecedor :" Size 050,8 object oTFornec
@ 157,060 Get _cFornec Picture "@!" F3 "SA2" Valid fFornec() Size 70,8 Object oFornec
@ 157,130 Get _cDesc5     Picture "@!" When .F. Size 120,8 Object oDesc5

@ 195,255 BMPBUTTON TYPE 01 ACTION fGrvFic()
@ 195,300 BMPBUTTON TYPE 02 ACTION fEnd() //FCancela()
Activate MsDialog oDialog Center 


Return

//----------------------------------------------------------
//   valida operador
//----------------------------------------------------------
Static Function fOpe()
Local lReturn := .T.
QAA->(dbSetOrder(1)) //Filial+ matricula
If !QAA->(dbSeek(xFilial("QAA")+_cOper ))
	MsgBox(OemToAnsi("Operador Não Encontrado"),OemToAnsi("Atenção"),"INFO")
    _cOper := Space(06)              
    ObjectMethod(oOper ,"Refresh()")
    lReturn := .F.
Else
   _cDesc := QAA->QAA_NOME
   ObjectMethod(oOper,"Refresh()")
EndIf   
Return (lReturn)

//----------------------------------------------------------
//   valida FERRAMENTA
//----------------------------------------------------------
Static Function fFerra()
Local lReturn := .T.
DbSelectArea("SB1")
SB1->(dbSetOrder(1)) //Filial+ matricula
If !SB1->(dbSeek(xFilial("SB1")+_cFerr ))
	MsgBox(OemToAnsi("Ferramenta nao Encontrada"),OemToAnsi("Atenção"),"INFO")
    _cFerr := Space(15)              
    ObjectMethod(oFerr ,"Refresh()")
    lReturn := .F.
Else
   _cDesc2 := SB1->B1_DESC
   ObjectMethod(oFerr,"Refresh()")
EndIf   
Return (lReturn)

//----------------------------------------------------------
//   valida CC
//----------------------------------------------------------

Static Function fCC()
Local lReturn := .T.                                                                         
DbSelectArea("CTT")
CTT->(dbSetOrder(1))
If !CTT->(dbSeek(xFilial("CTT")+_cCC ))
	MsgBox(OemToAnsi("Centro de Custo nao Encontrada"),OemToAnsi("Atenção"),"INFO")
    _cCC := Space(15)              
    ObjectMethod(oCC,"Refresh()")
    lReturn := .F.
Else
   _cDesc3 := CTT->CTT_DESC01
   ObjectMethod(oCC,"Refresh()")
EndIf   
Return (lReturn)

//----------------------------------------------------------
//   valida MAQUINA
//----------------------------------------------------------
Static Function fMaqui()
Local lReturn := .T.
DbSelectArea("ST9")
ST9->(dbSetOrder(1)) 
If !ST9->(dbSeek(xFilial("ST9")+_cMaqui ))
	MsgBox(OemToAnsi("Maquina nao Encontrada"),OemToAnsi("Atenção"),"INFO")
    _cMaqui := Space(15)              
    ObjectMethod(oMaqui,"Refresh()")
    lReturn := .F.
Else
   _cDesc4 := ST9->T9_NOME
   ObjectMethod(oMaqui,"Refresh()")
EndIf   
Return (lReturn)

//----------------------------------------------------------
//   valida FORNECEDORES
//----------------------------------------------------------
Static Function fFornec()
Local lReturn := .T.
DbSelectArea("SA2")
ST9->(dbSetOrder(1)) 
If !SA2->(dbSeek(xFilial("SA2")+_cFornec ))
	MsgBox(OemToAnsi("Fornecedor nao Encontrada"),OemToAnsi("Atenção"),"INFO")
    _cFornec := Space(6)              
    ObjectMethod(oMaqui,"Refresh()")
    lReturn := .F.
Else
   _cDesc5 := SA2->A2_NOME
   ObjectMethod(oMaqui,"Refresh()")
EndIf   
Return (lReturn)



//----------------------------------------------------------
//   valida turno
//----------------------------------------------------------
Static Function fNTurno()
   If !_cTurno$"1/2/3"
       MsgBox(OemToAnsi("Atenção Numero do Turno Não Existe"),OemToAnsi("Alteração de Turno"),"INFO")   
       Return(.F.)
   Endif
Return



//------------------------------------------------------------------------------
//  FINALIZA E RETORNA O SEQUENCIAL DO DOCUMENTO
//------------------------------------------------------------------------------
Static Function fEnd() 
   RollBackSx8() //Volta a numeração da Ordem de Liberação
   Close(oDialog) 
Return
        
//-----------------------------------------------------------------------
//    GRAVA A FICHA
//-----------------------------------------------------------------------
Static Function fGrvFic()
	Reclock("ZA4",.T.)
    	ZA4->ZA4_FILIAL  := xFilial("SZ4")
	    ZA4->ZA4_DOC	 := _cDocu
	    ZA4->ZA4_DATA	 := _dData
	    ZA4->ZA4_FUNCIO  := _cOper
	    ZA4->ZA4_TURNO	 := _cTurno
	    ZA4->ZA4_CC	 	 := _cCC 
	    ZA4->ZA4_MAQUIN	 := _cMaqui
   	    ZA4->ZA4_FERRAM  := _cFerr
		ZA4->ZA4_DEFEIT  := substr(_cDefe,0,3)
		ZA4->ZA4_BROCA   := _cBroca
		ZA4->ZA4_QTDUSA  := _cQU
		ZA4->ZA4_FUSO    := _cFuso
		ZA4->ZA4_FORNEC  := _cFornec
				
   	MsUnlock("ZA4")
	ConfirmSX8()  


	_cDocu		:= Space(06)
	_cOper	 	:= space(06)
	_dData   	:= date()
	_cHora   	:= time()   
	_cTurno  	:= space(1)
	_cFerr		:= space(15)
	_cDefe	 	:= space(10)
	_cCC		:= space(15)  
	_cMaqui		:= space(15)  
	_cDesc     	:= Space(30)
	_cDesc2    	:= Space(30)
	_cDesc3    	:= Space(30)

	Close(oDialog)



Return

//-------------------------------------------------------------------------------
//  exclusao da ficha de controle
//-------------------------------------------------------------------------------

User Function CExclui(cPar)
If MsgBox("Tem Certeza que Deseja Excluir","Confirmacao","YESNO")
	RecLock("ZA4",.F.)
	ZA4->(Dbdelete())
	MsUnlock("ZA4")   
endif
Return
                                   

