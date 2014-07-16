/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE191  ºAutor  ³Marcos R Roquitski  º Data ³  19/08/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcionarios em  tratamento medico.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#include "protheus.ch"

User Function Nhgpe191()

SetPrvt("_cNatureza, _dVencto, _nValor,_cTitulo,")
SetPrvt("_cXResMed, _cXDesMed")

_cXResMed   := IIF(SRA->RA_XRESMED=='S','Sim','Nao')
_cXDesMed   := SRA->RA_XDESMED
_aCombo     := {"Nao","Sim"}

@ 150,050 To 350,600 Dialog oDlgGpe Title "Medicina do Trabalho"

@ 010,020 Say OemToAnsi("Tratamento Medico") Size 35,8  OBJECT oResMed
@ 030,020 Say OemToAnsi("Descricao      ") Size 35,8 OBJECT oDesMed

@ 009,070 COMBOBOX _cXResMed  ITEMS _aCombo Size 35,8 OBJECT oXresMed
@ 029,070 Get _cXDesMed  PICTURE "@!" Size 200,8 OBJECT oXdesMed
      
@ 060,100 BMPBUTTON TYPE 01 ACTION GravaDados()
@ 060,150 BMPBUTTON TYPE 02 ACTION Close(oDlgGpe)
Activate Dialog oDlgGpe CENTERED

Return
         
//
Static Function GravaDados()
	RecLock("SRA",.F.)
	SRA->RA_XRESMED := _cXResMed
	SRA->RA_XDESMED := _cXDesMed
	MsUnlock("SRA")
	Close(oDlgGpe)
Return(.T.)


//
User Function Nhgp191a()
Local _aGrupo  := pswret()  // retorna vetor com dados do usuario
SetPrvt("_cxEstabi")
	
_cxEstabi := Time() + " " + Dtoc(dDataBase) + " " + _aGrupo[1,2]

@ 150,050 To 350,600 Dialog oDlgGpe2 Title "Processo Inicial"

@ 020,020 Say OemToAnsi("Descricao      ") Size 35,8 OBJECT oDesMed

@ 019,070 Get _cxEstabi  PICTURE "@!" Size 200,8 WHEN .F. OBJECT oXestabi
      
@ 060,100 BMPBUTTON TYPE 01 ACTION GrvXestab()
@ 060,150 BMPBUTTON TYPE 02 ACTION Close(oDlgGpe2)
Activate Dialog oDlgGpe2 CENTERED

Return
         
//
Static Function GrvXestab()
Local _aGrupo  := pswret()  // retorna vetor com dados do usuario

	RecLock("SRA",.F.)
	SRA->RA_XESTABI := _cxEstabi 
	SRA->RA_XESTABF := ''
	MsUnlock("SRA")
	U_NhGpe192(1)	
	Close(oDlgGpe2)
	

Return(.T.)

 
//
User Function Nhgp191b()
Local _aGrupo  := pswret()  // retorna vetor com dados do usuario
SetPrvt("_cxEstabf")

	
_cxEstabf := Time() + " " + Dtoc(dDataBase) + " " + _aGrupo[1,2]

@ 150,050 To 350,600 Dialog oDlgGpe3 Title "Processo Final"

@ 020,020 Say OemToAnsi("Descricao      ") Size 35,8 OBJECT oDesMed

@ 019,070 Get _cxEstabf  PICTURE "@!" Size 200,8 WHEN .F. OBJECT oXestabf
      
@ 060,100 BMPBUTTON TYPE 01 ACTION GrvXestaf()
@ 060,150 BMPBUTTON TYPE 02 ACTION Close(oDlgGpe3)
Activate Dialog oDlgGpe3 CENTERED

Return
         
//
Static Function GrvXestaf()
Local _aGrupo  := pswret()  // retorna vetor com dados do usuario

	RecLock("SRA",.F.)
	SRA->RA_XESTABF := _cxEstabf 
	MsUnlock("SRA")
	Close(oDlgGpe3)
	U_NhGpe192(2)

Return(.T.)
