/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE204  ºAutor  ³Marcos R. Roquitski º Data ³  23/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Liberacao de usuario para alteracao no SRC.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"

User Function Nhgpe204()

SetPrvt("ORDDEMO2,OTIMER,CMSG,NPOSMSG,BTIMER,CTOPBAR")
SetPrvt("NSOURCE,ASOURCE,NTARGET,ATARGET,CCAMINHO,_CAREA")
SetPrvt("_NREC,_CALIAS,_ALIASOK,NNEWTAM,NDEMO,CDEMO")
SetPrvt("_CPATH,NREC,NCOP,ASTRU,I,_CAMPO")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do programa                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oRDDEMO2 := NIL
oTimer   := NIL
cMsg     := Space(10)
cMsg     := cMsg + "Selecionar Usuario para Alteracao nos lancamentos mensais."
cMsg     := OemToAnsi(cMsg)
nPosMsg  := 1
bTimer   := {|| cTopBar := Substr(cMsg,nPosMsg,30)            , ;
                nPosMsg := If(nPosMsg>Len(cMsg),1,nPosMsg + 1), ;
                ObjectMethod(oGt,"Refresh()")                     }
cTopBar  := Space(30)
nSource  := 0
aSource  := {}
_cNome   := ''
nTarget  := 0
aTarget  := {}
cCaminho := ""
_cArea   := Select()
_nRec    := RecNo()
_cAlias  := Space(3)
_AliasOk := .F.

              
_cMvGpe202c := Alltrim(GETMV("MV_GPE202C")) // Sequencial 
_cMvGpe203c := Alltrim(GETMV("MV_GPE203C")) // Sequencial 

For i := 1 TO len(_cMvGpe203c)
	If Substr(_cMvGpe203c,i,1) <> ';'
		_cNome += Substr(_cMvGpe203c,i,1)
	Else
		Aadd(aSource,_cNome) 
		_cNome := ''
	Endif	
Next

For z := 1 TO len(_cMvGpe202c)
	If Substr(_cMvGpe202c,z,1) <> ';'
		_cNome += Substr(_cMvGpe202c,z,1)
	Else
		Aadd(aTarget,_cNome)
		_cNome := ''
	Endif	
Next


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao do dialogo principal                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 400,500 To 700,1200 Dialog oRDDEMO2 Title "Autorizacao de Alteracao"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o timer que ira executar por detras do dialogo               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oTimer := IW_Timer(100,bTimer)
ObjectMethod(oTimer,"Activate()")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Objetos do dialogo principal                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//@ 015,003 Say OemToAnsi("Caminho  :")
//@ 015,030 Get cCaminho Size 90,08 Object oCaminho When .F.
@ 030,003 Say OemToAnsi("Usuarios")
@ 030,133 Say OemToAnsi("Usuarios Autorizados")
@ 039,133 ListBox nTarget Items aTarget Size 85,65 Object oTarget
@ 040,004 ListBox nSource Items aSource Size 86,65 Object oSource
@ 040,093 Button OemToAnsi("_Adicionar >>") Size 36,16 Action AddDemo()    Object oBtnAdd
@ 058,093 Button OemToAnsi("<< _Remover")   Size 36,16 Action RemoveDemo() Object oBtnRem


@ 050,250 BmpButton Type 1 Action RunDemos()      
@ 070,250 BmpButton Type 2 Action Close(oRDDEMO2)

Activate Dialog oRDDEMO2

Return

//
Static Function AddDemo()
    If nSource != 0
        aAdd(aTarget,aSource[nSource])
        ObjectMethod(oTarget,"SetItems(aTarget)")
    Endif
Return

//
Static function RemoveDemo()
    If nTarget != 0
        nNewTam := Len(aTarget) - 1
        aTarget := aSize(aDel(aTarget,nTarget), nNewTam)
        ObjectMethod(oTarget,"SetItems(aTarget)")
    Endif
Return

//
Static Function RunDemos()
   _cNome := ''
                              	
	For b := 1 TO len(aTarget)
		_cNome += aTarget[b]+';'
	Next
	SX6->(DbSeek(xFilial("SRA")+"MV_GPE202C"))
	If SX6->(Found())
		RecLock("SX6",.F.)
		SX6->X6_CONTEUD := _cNome
		MsUnlock("SX6")
	Else
		alert("Parametro MV_GPE202C Nao cadastrado. Verifique no cadastro de parametros!")	
	Endif	
	Close(oRDDEMO2)
Return
