/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHMNT038  บAutor  ณ Joใo Felipe da Rosaบ Data ณ  01/15/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ INATIVA MANUTENCAO DOS BENS                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANUTENCAO DE ATIVOS                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"

User Function NHMNT038()

SetPrvt("_cBem, aHeader, aCols,_CATV")

aHeader := {}
aCols   := {}
_cBem   := Space(15)
_aAtv   := {"Sim","Nao"}

aAdd(aCols,{"","","","","S"})

aAdd(aHeader,{"Ponto"           , "TF_CODBEM"   ,  "@!"               ,15,0 ,".F.","","C","STF"})
aAdd(aHeader,{"Descri็ใo"       , "TF_NOME"     ,  "@!"               ,40,0 ,".F.","","C","STF"})
aAdd(aHeader,{"Servi็o"         , "TF_SERVICO"  ,  "@!"               ,06,0 ,".F.","","C","STF"})
aAdd(aHeader,{"Sequencia"       , "TF_SEQRELA"  ,  "@!"               ,03,0 ,".F.","","C","STF"})
aAdd(aHeader,{"Man. Ativa"      , "TF_ATIVO"    ,  "@!"               ,01,0 ,".T.","","C","STF"})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤi
//ณ CONSTROI A TELA ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤi
DEFINE MSDIALOG oDlg FROM 0,0 TO 250,435 PIXEL TITLE "Inativa็ใo de Manuten็ใo de Bens"

   	@ 005,005 TO 030,215 LABEL "" OF oDlg PIXEL
   	@ 015,010 Say "Bem: " Size 030,8
   	@ 013,028 Get _cBem  Picture "@!" F3 "ST9" Size 50,8 object oBem valid ExistCpo("ST9",_cBem)
   	@ 013,080 BUTTON ">>" Size 015,10 Action fChamaBem(_cBem)
   	@ 015,112 Say "Ativa: " Size 030,8
	@ 013,130 COMBOBOX _cAtv ITEMS _aAtv SIZE 50,8 object oCombo
	@ 013,182 BUTTON ">>" Size 015,10 Action fTodos(_cAtv)   


	@ 035,005 TO 100, 215 MULTILINE MODIFY OBJECT oMultiline 
    oMultiline:nMax := Len(aCols) //nใo deixa o usuario adicionar mais uma linha no multiline
   
   	@ 105,150 BUTTON "Ok"        Size 030,015 ACTION fGrv()
   	@ 105,185 BUTTON "Cancelar"  Size 030,015 ACTION oDlg:End()
   
ACTIVATE MSDIALOG oDlg CENTER


Return

/**************************************************
* TRAZ OS PONTOS DE LUBRIFICACAO DO BEM ESCOLHIDO *
**************************************************/
Static Function fChamaBem(_cMaq)

	DbSelectArea("STF")
	DbSetOrder(1)
	If DbSeek(xFilial("STF")+_cBem)
	    
		aCols := {}
	
		While STF->(!Eof()) .AND. Substr(STF->TF_CODBEM,1,7) == AllTrim(_cBem)
			
			If Substr(STF->TF_CODBEM,8,1) == "." .AND. STF->TF_SERVICO == "000003"//so pega ponto de lubrificacao
				aAdd(aCols,{STF->TF_CODBEM, STF->TF_NOMEMAN, STF->TF_SERVICO, STF->TF_SEQRELA, STF->TF_ATIVO,.F.})
			EndIf
		
			STF->(DbSkip())
	    EndDo 
	    
	    oMultiline:Refresh()
	Else
		Alert("Bem nใo encontrado")
    EndIf
Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGRAVA A INATIVACAO DOS BENSณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function fGrv()
    
	STF->(DbSetOrder(1))
	For _x := 1 to Len(aCols)
		If STF->(DbSeek(xFilial("STF")+aCols[_x][1]+aCols[_x][3]+aCols[_x][4]))
			RecLock("STF",.F.)
				STF->TF_ATIVO := aCols[_x][5]				
			MSUnLock("STF")
	    EndIf
	Next
	
	aCols := {}
	_cBem := Space(15)
	oDlg:Refresh()
	oBem:SetFocus()
	
Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณATIVA / INATIVA TODOS OS PONTOSณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function fTodos(_cAtiva)

	For _x := 1 to Len(aCols)
		If _cAtiva == "Sim"
			aCols[_x][5] := "S"
    	Else 
			aCols[_x][5] := "N"    		                           
    	EndIf
	Next

Return