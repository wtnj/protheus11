#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function Rhgp30()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("ORDDEMO2,OTIMER,CMSG,NPOSMSG,BTIMER,CTOPBAR")
SetPrvt("NSOURCE,ASOURCE,NTARGET,ATARGET,NNEWTAM,_CPATH")
SetPrvt("NDEMO,CDEMO,_CALIAS,_CPROCESSA,LEND,")

/*/
------------------------------------------------ MANER INFORMATICA
LEILA MARUO EM 04/08/2000
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do programa                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oRDDEMO2 := NIL
oTimer   := NIL

cMsg     := Space(20)
cMsg     := cMsg + "Selecionar arquivos para geracao de copia "
cMsg     := cMsg + "em formato DBF. "
cMsg     := OemToAnsi(cMsg)

nPosMsg  := 1

bTimer   := {|| cTopBar := Substr(cMsg,nPosMsg,65)            , ;
                nPosMsg := If(nPosMsg>Len(cMsg),1,nPosMsg + 1), ;
                ObjectMethod(oGt,"Refresh()")                     }

cTopBar  := Space(65)

nSource  := 0
aSource  := {"SRANH0","SRBNH0","SRCNH0","SRDNH0","SRENH0","SRFNH0"}
nTarget  := 0
aTarget  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao do dialogo principal                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 105,074 To 304,716 Dialog oRDDEMO2 Title "BACKUP DE ARQUIVOS"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o timer que ira executar por detras do dialogo               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oTimer := IW_Timer(100,bTimer)
ObjectMethod(oTimer,"Activate()")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Objetos do dialogo principal                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 020,003 Say OemToAnsi("Arquivos dispon¡veis:")
@ 020,133 Say OemToAnsi("Arquivos para copia:")
@ 060,250 Button OemToAnsi("_Carregar")  Size 36,16 Action _Verifica()// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> @ 060,250 Button OemToAnsi("_Carregar")  Size 36,16 Action Execute(_Verifica)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nova clausula disponivel para todos os comandos -> OBJECT <NOME>    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 004,000 Get cTopBar     When .F.                 Object oGt
@ 030,004 ListBox nSource Items aSource Size 86,65 Object oSource
@ 029,133 ListBox nTarget Items aTarget Size 85,65 Object oTarget

@ 030,093 Button OemToAnsi("_Adicionar >>") Size 36,16 Action AddDemo()    Object oBtnAdd// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> @ 030,093 Button OemToAnsi("_Adicionar >>") Size 36,16 Action Execute(AddDemo)    Object oBtnAdd
@ 048,093 Button OemToAnsi("<< _Remover")   Size 36,16 Action RemoveDemo() Object oBtnRem// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> @ 048,093 Button OemToAnsi("<< _Remover")   Size 36,16 Action Execute(RemoveDemo) Object oBtnRem

@ 030,250 Button OemToAnsi("_Executar")  Size 36,16 Action RunDemos()// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> @ 030,250 Button OemToAnsi("_Executar")  Size 36,16 Action Execute(RunDemos)

@ 082,277 BmpButton Type 1 Action Close(oRDDEMO2)

Activate Dialog oRDDEMO2

#IFNDEF PROTHEUS
	ObjectMethod(oTimer,"DeActivate()")
	ObjectMethod(oTimer,"Release()")
#ENDIF

Return

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function AddDemo
Static Function AddDemo()
    If nSource != 0
        aAdd(aTarget,aSource[nSource])
        ObjectMethod(oTarget,"SetItems(aTarget)")
//        nNewTam := Len(aSource) - 1
//        aSource := aSize(aDel(aSource,nSource),nNewTam)
//        ObjectMethod(oSource,"SetItems(aSource)")
    Endif
Return

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> function RemoveDemo
Static function RemoveDemo()
    If nTarget != 0
//        aAdd(aSource,aTarget[nTarget])
//        ObjectMethod(oSource,"SetItems(aSource)")
        nNewTam := Len(aTarget) - 1
        aTarget := aSize(aDel(aTarget,nTarget), nNewTam)
        ObjectMethod(oTarget,"SetItems(aTarget)")
    Endif
Return

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function RunDemos
Static Function RunDemos()
//   _cPath  := 'C:' +  AllTrim(SX2->X2_PATH)
_cPath  := 'C:\' 

If Len(aTarget) != 0
    For nDemo := 1 To Len(aTarget)

        cDemo := AllTrim(Upper(aTarget[nDemo]))
        _cAlias := SUBSTR(cDemo,1,3)
//         _cPath  := 'C:' +  AllTrim(SX2->X2_PATH) + AllTrim(SX2->X2_ARQUIVO)
         _cPath  := 'C:\'  + cDemo
         DbSelectArea(_cAlias)
         DbSetOrder(1)
         Copy to  &_cPath
//         GPIncProc(SX2->X2_CHAVE+" - "+AllTrim(SX2->X2_NOME) + ' ' + _cPath)         
         GPIncProc(_cAlias+" - "+cDemo + ' ' + _cPath)         
    Next nDemo
Endif

Return

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function f_Gera
Static Function f_Gera()
   DbSelectArea("SX2")
   SX2->(DbGoTop())
   _cPath  := 'C:' +  AllTrim(SX2->X2_PATH) 
   DbSelectArea("SX2")
   GPProcRegua(SX2->(RecCount()))        
   SX2->(DbGoTop())
   While SX2->(!Eof())
      If SubStr(AllTrim(SX2->X2_CHAVE),1,2) == 'SR'
         If AllTrim(SX2->X2_CHAVE) == "SR5"
            SX2->(DbSkip())
            Loop
         EndIf
         _cAlias := AllTrim(SX2->X2_CHAVE)
         _cPath  := 'C:' +  AllTrim(SX2->X2_PATH) + AllTrim(SX2->X2_ARQUIVO)
         DbSelectArea(_cAlias)
         DbSetOrder(1)
         Copy to  &_cPath
         GPIncProc(SX2->X2_CHAVE+" - "+AllTrim(SX2->X2_NOME) + ' ' + _cPath)         
      EndIf
      SX2->(DbSkip())
   End
   
Return


// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function _Verifica
Static Function _Verifica()
   _cProcessa := 'Selecionando Arquivos'
   lEnd := .F.
   DbSelectArea("SX2")
   nSource := 0
   SX2->(DbGoTop())
   While SX2->(!Eof())
      If SubStr(AllTrim(SX2->X2_CHAVE),1,2) == 'SR'
         If AllTrim(SX2->X2_CHAVE) == "SR5"
            SX2->(DbSkip())
            Loop
         EndIf
         nSource := nSource +1
//         AADD(aSource,{AllTrim(SX2->X2_ARQUIVO)})
       //AADD(aCampos,{"X6_FIL","Filial do SX6","@!"})
//         ObjectMethod(oSource,"SetItems(aSource)")
      EndIf
      SX2->(DbSkip())
   End

Return
