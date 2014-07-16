/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHFIN083  บAutor  ณMarcos R Roquitski  บ Data ณ  25/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza campo E1_RETIMP, retencao de imposto pelo cliente บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#include "rwmake.ch"

User Function Nhfin083()
Local aCores
SetPrvt("aRotina,cCadastro,")

aCores := {{'E1_RETIMP=="N"','BR_PRETO'},;
	       {'E1_RETIMP<>"N"','BR_VERDE'} }

aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Retencao","U_fRet083a",0,2} ,;
             {"Legenda","U_fLegf083()",0,6} }
             
cCadastro := "Retencao de Impostos"

SE1->(DbGotop())

mBrowse(,,,,"SE1",,,,,,aCores)
Return
          

//
User Function fLegf083()

Private aCores := {{ "BR_PRETO" , "Titulo SEM Impostos retidos" },;
                   { "BR_VERDE" , "Titulo COM  Impostos Retido" } }
				   
BrwLegenda(cCadastro,"Legenda",aCores)

Return


//
User Function fRet083a()
If MsgBox(" (*) Cliente efetuou Retencao dos Impostos?","Retencao de Impostos","YESNO")
	RecLock("SE1",.F.)
	SE1->E1_RETIMP := 'S'
	MsUnlock("SE1")
Else
	RecLock("SE1",.F.)
	SE1->E1_RETIMP := 'N'
	MsUnlock("SE1")
Endif

Return
