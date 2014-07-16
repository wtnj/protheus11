/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE001  ºAutor  ³Marcos R. Roquitski º Data ³  27/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Backup arquivos da Folha de Pagamento.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico para WHB.                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"

User Function Nhgpe001()

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
cMsg     := cMsg + "Selecionar arquivos para geracao de copia "
cMsg     := cMsg + "em formato DBF. "
cMsg     := OemToAnsi(cMsg)
nPosMsg  := 1
bTimer   := {|| cTopBar := Substr(cMsg,nPosMsg,30)            , ;
                nPosMsg := If(nPosMsg>Len(cMsg),1,nPosMsg + 1), ;
                ObjectMethod(oGt,"Refresh()")                     }
cTopBar  := Space(30)
nSource  := 0
aSource  := {"TODOS","SR1NH0 VAL EXTRAS","SRANH0 FUNCIONAR","SRBNH0 DEPENDEN",;
"SRCNH0 FOLHA","SRENH0 TRANSFER","SRGNH0 CAB RESC","SRHNH0 CAB FERIAS",;
"SRKNH0 VAL FUTUROS","SRRNH0 ITENS FER/RESC","SRVNH0 VERBAS","SRZNH0 RESUMO",;
"SRNNH0 MEIOS TRANSP","SR0NH0 ITENS VT","SRMNH0 ROT CALCULO",;
"SR8NH0 AFASTA","SR3NH0 H VAL SAL.","SR7NH0 H ALT SAL.",;
"SR9NH0 HIST FUNC", "SRONH0 TAREFAS","SRFNH0 PROVISOES","SRINH0 13SAL",;
"SR2NH0 RAIS","SRLNH0 DIRF","SR4NH0 ITENS DIRF"}

nTarget  := 0
aTarget  := {}
cCaminho := "\Relato\Rh\Arquivos\"
_cArea   := Select()
_nRec    := RecNo()
_cAlias  := Space(3)
_AliasOk := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao do dialogo principal                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 105,074 To 404,716 Dialog oRDDEMO2 Title "BACKUP DE ARQUIVOS"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o timer que ira executar por detras do dialogo               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oTimer := IW_Timer(100,bTimer)
ObjectMethod(oTimer,"Activate()")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Objetos do dialogo principal                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 015,003 Say OemToAnsi("Caminho  :")
@ 015,030 Get cCaminho Size 90,08 Object oCaminho When .F.
@ 030,003 Say OemToAnsi("Arquivos disponiveis:")
@ 030,133 Say OemToAnsi("Arquivos para copia:")
@ 039,133 ListBox nTarget Items aTarget Size 85,65 Object oTarget
@ 040,004 ListBox nSource Items aSource Size 86,65 Object oSource
@ 040,093 Button OemToAnsi("_Adicionar >>") Size 36,16 Action AddDemo()    Object oBtnAdd// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> @ 040,093 Button OemToAnsi("_Adicionar >>") Size 36,16 Action Execute(AddDemo)    Object oBtnAdd
@ 058,093 Button OemToAnsi("<< _Remover")   Size 36,16 Action RemoveDemo() Object oBtnRem// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> @ 058,093 Button OemToAnsi("<< _Remover")   Size 36,16 Action Execute(RemoveDemo) Object oBtnRem
@ 050,250 Button OemToAnsi("_Executar")  Size 36,16 Action RunDemos2()

@ 102,250 BmpButton Type 2 Action Close(oRDDEMO2)

Activate Dialog oRDDEMO2

Return

Static Function AddDemo()
    If nSource != 0
        aAdd(aTarget,aSource[nSource])
        ObjectMethod(oTarget,"SetItems(aTarget)")
    Endif
Return

Static function RemoveDemo()
    If nTarget != 0
        nNewTam := Len(aTarget) - 1
        aTarget := aSize(aDel(aTarget,nTarget), nNewTam)
        ObjectMethod(oTarget,"SetItems(aTarget)")
    Endif
Return

Static Function RunDemos()
If Len(aTarget) != 0
    For nDemo := 1 To Len(aTarget)
        cDemo := AllTrim(Upper(aTarget[nDemo]))
        cDemo := substr(cDemo,1,6)
        _cAlias := SUBSTR(cDemo,1,3)
        If _cAlias == "TOD"
           DbSelectArea("SX2")
           SX2->(DbGoTop())
           While SX2->(!Eof())
              If SubStr(AllTrim(SX2->X2_CHAVE),1,2) == 'SR'
                 If AllTrim(SX2->X2_CHAVE) <> "SR5"
                    _cAlias := SX2->X2_CHAVE
                    cDemo := SX2->X2_ARQUIVO
                    _cPath  :=  AllTrim(cCaminho) + cDemo
                    DbSelectArea(_cAlias)
                    DbSetOrder(1)
                    DbGotop()
                    nrec:=LastRec()
                    ncop:=0
                    astru:=dbstruct()
                    DbCreate(_cPath,astru)
                    Use (_cPath) new alias newdbf shared
                    Processa({|lend| copiadbf()},"Gerando "+_cAlias+".dbf")
                    newdbf->(DbCloseArea())
                 Endif
              Endif
              SX2->(DbSkip())
           Enddo
        Else
           DbSelectArea(_cAlias)
           DbSetOrder(1)
           DbGotop()
           nrec  := LastRec()
           ncop  := 0
           astru := dbstruct()
           DbCreate(_cPath,astru)
           Use (_cPath) new alias newdbf shared
           Processa({|lend| copiadbf()},"Gerando "+_cAlias+".dbf")
           newdbf->(DbCloseArea())
        Endif
    Next nDemo
Endif

Return


Static Function copiadbf()
	ProcRegua(nrec)
	DbSelectarea(_cAlias)
	While !Eof()
		ncop:=ncop+1
		IncProc('Copiando registro '+alltrim(str(ncop,7,0))+' de '+Trim(str(nrec,7,0)))
		newdbf->(DbAppend())
		For i:=1 to Len(astru)
			_campo:=FieldGet(i)
			newdbf->(FieldPut(i,_campo))
			Next
		DbSkip()
	Enddo
Return(nil)


Static Function RunDemos2()
nCop := 0
If Len(aTarget) != 0
    For nDemo := 1 To Len(aTarget)
        cDemo := AllTrim(Upper(aTarget[nDemo]))
        cDemo := Substr(cDemo,1,6)
        _cAlias := Substr(cDemo,1,3)
        If _cAlias == "TOD"
           DbSelectArea("SX2")
           SX2->(DbGoTop())
           While SX2->(!Eof())
              If SubStr(AllTrim(SX2->X2_CHAVE),1,2) == 'SR'
                 If AllTrim(SX2->X2_CHAVE) <> "SR5"
                 		If  AllTrim(SX2->X2_CHAVE) <> "SRD"
		               	_cAlias := SX2->X2_CHAVE
		               	cDemo := SX2->X2_ARQUIVO
	   	              	_cPath  :=  AllTrim(cCaminho) + cDemo
	      	           	DbSelectArea(_cAlias)
	         	        	DbSetOrder(1)
			      	     	Processa({|lend| fCopDbf()},"Gerando "+_cAlias+".dbf")
			      	   Endif
                 Endif
              Endif
              SX2->(DbSkip())
           Enddo
        Else
           _cPath  :=  AllTrim(cCaminho) + cDemo
           cMsg := AllTrim(_cPath)
           DbSelectArea(_cAlias)
           DbSetOrder(1)
           Processa({|lend| fCopDbf()},"Gerando "+_cAlias+".dbf")
        Endif
    Next nDemo
Endif
Close(oRDDEMO2)
Return


Static Function fCopDbf()
	ncop:=ncop+1
	IncProc('Copiando arquivo '+_cPath)
	Copy to &_cPath
Return



