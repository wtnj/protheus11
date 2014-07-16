/*                                     
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHPCP013  ³ Autor ³ João Felipe da Rosa    Data ³ 13/08/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Release X Entrega                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PCP			                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
//#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"    
#include "protheus.ch"  

User Function nhpcp013() 

//AXCADASTRO("ZAO")
//AXCADASTRO("ZA9")

SetPrvt("CCADASTRO,AROTINA,_nDif, _cClie,_nTotalE")
Private aSize     := MsAdvSize()
Private aObjects  := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo     := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5 } 
Private aPosObj   := MsObjSize( aInfo, aObjects, .T.)
Private _nDif     := 0
Private _nTotalE  := 0         
Public cOrigem := ''  
aRadio := {} 
nRadio := 1


Processa({||fAtualiza()},"Abrindo release ...")

cCadastro := OemToAnsi("Programação de Entregas")
aRotina := {{ "Pesquisa"		,"AxPesqui"     , 0 , 1},;
            { "Visualizar"		,'U_fPCP13(1)' 	, 0 , 2},;
            { "Incluir"   		,'U_fPCP13(2)'  , 0 , 3},;
            { "Alterar"   		,'U_fPCP13(3)'  , 0 , 5},;
            { "Excluir"   		,'U_fPCP13(4)'	, 0 , 4},;
            { "Imprimir"   		,'U_fPCP13(6)'	, 0 , 3},;
            { "Documento"       ,'U_fDOC13()'   , 0,  4},;
            { "Rel. Geral" 		,'U_NHPCP021()'	, 0 , 3},;
            { "Rel. Obs"        ,'U_NHPCP014()' , 0 , 3}}
            
mBrowse( 6, 1,22,75,"ZAO",,,,,,fCriaCor())
Return

//Abre a funcao base de conhecimento
User Function fDOC13()
   MsDocument('ZAO',ZAO->(RECNO()), 4)
return


Static Function fAtualiza()

	DbSelectArea("ZAP")
	DbSetOrder(1) // filial + num + item
	
	DbSelectArea("ZAO")
	Set Filter to ZAO->ZAO_STATUS = "P"
	DbGoTop()
	
	While !EoF()
		If ZAO->ZAO_DTFIM < Date() //verifica se o release já está finalizado
			IF ZAP->(DbSeek(xFilial("ZAP")+ZAO->ZAO_NUM))

				_cClie := ZAO->ZAO_CLIENT
				_cLoja := ZAO->ZAO_LOJA

                While ZAP->ZAP_NUM == ZAO->ZAO_NUM
					fCalcDif() //Traz a diferenca de entragas (em _nDif) considerando entregas anteriores		    
					If EMPTY(ZAP->ZAP_ATRASO) //verifica se está encerrado
						RecLock("ZAP",.F.)
							ZAP->ZAP_ATRASO := _nDif //grava a diferença em cada item do release
						MsUnLock("ZAP")
					EndIf
					ZAP->(DbSkip())
				EndDo

				RecLock("ZAO",.F.)
					ZAO->ZAO_STATUS := "E" // grava o status encerrado
				MsUnLock("ZAO")				
			EndIf
		EndIf			
		ZAO->(DbSkip())
	EndDo 
	
	Set Filter To
	DbGoTop()

Return

//------------------------//
// Funcao principal       //
//------------------------//

User Function fPCP13(_cPar)

Local bOk         := {||fOk()}
Local bCanc       := {||fEnd()}
Local bEnchoice   := {||}
Local aButtons    := {}

_nTotalE	:= 0
_nTotalR	:= 0 
_aNF		:= {}
_cParam 	:= _cPar
_cClie		:= Space(6)
_cRel		:= Space(20)
_cCliDesc	:= Space(20)
_cLoja		:= "  "
_aProd		:= {}
_cContat	:= ""
_cTel		:= ""
_cEmail		:= ""
//_cSemIni	:= ""
//_cSemFim	:= "" 
//_cSI	    := ""
//_cSF		:= ""
_cCod		:= ""
_cItem		:= Space(4)
aHeader     := {}
aCols		:= {}
_aMeses		:= {}
_aQtdEntr	:= {}
_cMes		:= ""
_cDtRel		:= Date()
_cAnoRel    := Strzero(YEAR(DATE()),4)
_cObsGer    := Space(100)

// Inicializa o Aheader
Aadd(aHeader,{"Item"     , "ZAP_ITEM"	,"@!"          , 4,0,".F.","","C","ZAP"}) //1
Aadd(aHeader,{"Produto"  , "ZAP_PROD"	,"@!"          ,15,0,".T.","","C","ZAP"}) //2
Aadd(aHeader,{"Descricao", "ZAP_DESC" 	,Repli("!",30) ,30,0,".T.","","C","ZAP"}) //3
Aadd(aHeader,{"Diferenca", "ZAP_PREVM1"	,"999999999"   , 9,0,".F.","","N","ZAP"}) //4
Aadd(aHeader,{"Preço Un.", "ZAP_PRECUN" ,"@E 9,999.99" , 5,2,".T.","","N","ZAP"}) //5
Aadd(aHeader,{"Dia 01" 	 , "ZAP_PREV01"	,"999999999"   , 9,0,"U_PCP13TOT(1)","","N","ZAP"}) //6
Aadd(aHeader,{"Dia 02" 	 , "ZAP_PREV02"	,"999999999"   , 9,0,"U_PCP13TOT(2)","","N","ZAP"}) //7
Aadd(aHeader,{"Dia 03" 	 , "ZAP_PREV03"	,"999999999"   , 9,0,"U_PCP13TOT(3)","","N","ZAP"}) //8
Aadd(aHeader,{"Dia 04" 	 , "ZAP_PREV04"	,"999999999"   , 9,0,"U_PCP13TOT(4)","","N","ZAP"}) //9
Aadd(aHeader,{"Dia 05" 	 , "ZAP_PREV05"	,"999999999"   , 9,0,"U_PCP13TOT(5)","","N","ZAP"}) //10
Aadd(aHeader,{"Dia 06" 	 , "ZAP_PREV06"	,"999999999"   , 9,0,"U_PCP13TOT(6)","","N","ZAP"}) //11
Aadd(aHeader,{"Dia 07" 	 , "ZAP_PREV07"	,"999999999"   , 9,0,"U_PCP13TOT(7)","","N","ZAP"}) //12
Aadd(aHeader,{"Dia 08" 	 , "ZAP_PREV08"	,"999999999"   , 9,0,"U_PCP13TOT(8)","","N","ZAP"}) //13
Aadd(aHeader,{"Dia 09" 	 , "ZAP_PREV09"	,"999999999"   , 9,0,"U_PCP13TOT(9)","","N","ZAP"}) //14
Aadd(aHeader,{"Dia 10" 	 , "ZAP_PREV10"	,"999999999"   , 9,0,"U_PCP13TOT(10)","","N","ZAP"}) //15
Aadd(aHeader,{"Dia 11" 	 , "ZAP_PREV11"	,"999999999"   , 9,0,"U_PCP13TOT(11)","","N","ZAP"}) //16
Aadd(aHeader,{"Dia 12" 	 , "ZAP_PREV12"	,"999999999"   , 9,0,"U_PCP13TOT(12)","","N","ZAP"}) //17
Aadd(aHeader,{"Dia 13" 	 , "ZAP_PREV13"	,"999999999"   , 9,0,"U_PCP13TOT(13)","","N","ZAP"}) //18
Aadd(aHeader,{"Dia 14" 	 , "ZAP_PREV14"	,"999999999"   , 9,0,"U_PCP13TOT(14)","","N","ZAP"}) //19
Aadd(aHeader,{"Dia 15" 	 , "ZAP_PREV15"	,"999999999"   , 9,0,"U_PCP13TOT(15)","","N","ZAP"}) //20
Aadd(aHeader,{"Dia 16" 	 , "ZAP_PREV16"	,"999999999"   , 9,0,"U_PCP13TOT(16)","","N","ZAP"}) //21
Aadd(aHeader,{"Dia 17" 	 , "ZAP_PREV17"	,"999999999"   , 9,0,"U_PCP13TOT(17)","","N","ZAP"}) //22
Aadd(aHeader,{"Dia 18" 	 , "ZAP_PREV18"	,"999999999"   , 9,0,"U_PCP13TOT(18)","","N","ZAP"}) //23
Aadd(aHeader,{"Dia 19" 	 , "ZAP_PREV19"	,"999999999"   , 9,0,"U_PCP13TOT(19)","","N","ZAP"}) //24
Aadd(aHeader,{"Dia 20" 	 , "ZAP_PREV20"	,"999999999"   , 9,0,"U_PCP13TOT(20)","","N","ZAP"}) //25
Aadd(aHeader,{"Dia 21" 	 , "ZAP_PREV21"	,"999999999"   , 9,0,"U_PCP13TOT(21)","","N","ZAP"}) //26
Aadd(aHeader,{"Dia 22" 	 , "ZAP_PREV22"	,"999999999"   , 9,0,"U_PCP13TOT(22)","","N","ZAP"}) //27
Aadd(aHeader,{"Dia 23" 	 , "ZAP_PREV23"	,"999999999"   , 9,0,"U_PCP13TOT(23)","","N","ZAP"}) //28
Aadd(aHeader,{"Dia 24" 	 , "ZAP_PREV24"	,"999999999"   , 9,0,"U_PCP13TOT(24)","","N","ZAP"}) //29
Aadd(aHeader,{"Dia 25" 	 , "ZAP_PREV25"	,"999999999"   , 9,0,"U_PCP13TOT(25)","","N","ZAP"}) //30
Aadd(aHeader,{"Dia 26" 	 , "ZAP_PREV26"	,"999999999"   , 9,0,"U_PCP13TOT(26)","","N","ZAP"}) //31
Aadd(aHeader,{"Dia 27" 	 , "ZAP_PREV27"	,"999999999"   , 9,0,"U_PCP13TOT(27)","","N","ZAP"}) //32
Aadd(aHeader,{"Dia 28" 	 , "ZAP_PREV28"	,"999999999"   , 9,0,"U_PCP13TOT(28)","","N","ZAP"}) //33
Aadd(aHeader,{"Dia 29" 	 , "ZAP_PREV29"	,"999999999"   , 9,0,"U_PCP13TOT(29)","","N","ZAP"}) //34
Aadd(aHeader,{"Dia 30" 	 , "ZAP_PREV30"	,"999999999"   , 9,0,"U_PCP13TOT(30)","","N","ZAP"}) //35
Aadd(aHeader,{"Dia 31" 	 , "ZAP_PREV31"	,"999999999"   , 9,0,"U_PCP13TOT(31)","","N","ZAP"}) //36 
Aadd(aHeader,{"Total" 	 , "ZAP_PREVM1"	,"999999999"   , 9,0,".F.","","N","ZAP"}) //37 
Aadd(aHeader,{"Mes 1 " 	 , "ZAP_PREVM1"	,"999999999"   , 9,0,".T.","","N","ZAP"}) //38 
Aadd(aHeader,{"Mes 2 " 	 , "ZAP_PREVM2"	,"999999999"   , 9,0,".T.","","N","ZAP"}) //39 
Aadd(aHeader,{"Mes 3 " 	 , "ZAP_PREVM3"	,"999999999"   , 9,0,".T.","","N","ZAP"}) //40 
Aadd(aHeader,{"Mes 4 " 	 , "ZAP_PREVM4"	,"999999999"   , 9,0,".T.","","N","ZAP"}) //41
Aadd(aHeader,{"Mes 5 " 	 , "ZAP_PREVM5"	,"999999999"   , 9,0,".T.","","N","ZAP"}) //42
Aadd(aHeader,{"Mes 6 " 	 , "ZAP_PREVM6"	,"999999999"   , 9,0,".T.","","N","ZAP"}) //43
Aadd(aHeader,{"Ped. Cliente" , "ZAP_PEDCLI"	,"@!"      ,20,0,".T.","","C","ZAP"}) //44

DEFINE FONT oFont NAME "Arial" SIZE 12, -12                                                                  

If _cParam == 1 .Or. _cParam == 3 .Or. _cParam == 4 .Or. _cParam == 6//visualiza, altera ou exclui
	
	_cCod    := ZAO->ZAO_NUM
    _cClie   := ZAO->ZAO_CLIENT
    _cLoja   := ZAO->ZAO_LOJA
    _cMes    := ZAO->ZAO_MES
	_cRel    := ZAO->ZAO_RELCLI
    _cDtRel  := ZAO->ZAO_DTREL
    _cObsGer := ZAO->ZAO_OBSGER
	_cAnoRel := STRZERO(Year(ZAO->ZAO_DTINI),4)
	 
	DbSelectArea('SA1')
	SA1->(DbSetOrder(1)) //Filial + Cod + loja
	If SA1->(DbSeek(xFilial('SA1')+AllTrim(_cClie)+AllTrim(_cLoja)))
		_cCliDesc := SA1->A1_NOME
    EndIf

	// Adiciona os dados no multiline 
	DbSelectArea("ZAP")
	ZAP->(DbSetOrder(1)) //filial + cod + item	
 	If ZAP->(DbSeek(xFilial("ZAP")+ZAO->ZAO_NUM))
		While ZAP->(!EoF()) .AND. ZAP->ZAP_NUM == ZAO->ZAO_NUM

		   	If EMPTY(ZAP->ZAP_ATRASO) .AND. ZAO->ZAO_STATUS <> "E"
		   		fCalcDif() //Traz a diferenca de entragas (em _nDif) considerando entregas anteriores		    
			Else
				_nDif := ZAP->ZAP_ATRASO
			EndIf		 
	  	    
	  	    _nZAPTot := ZAP->ZAP_PREV01 + ZAP->ZAP_PREV02 + ZAP->ZAP_PREV03 + ZAP->ZAP_PREV04 + ZAP->ZAP_PREV05 +;
		       		    ZAP->ZAP_PREV06 + ZAP->ZAP_PREV07 + ZAP->ZAP_PREV08 + ZAP->ZAP_PREV09 + ZAP->ZAP_PREV10 +;
					    ZAP->ZAP_PREV11 + ZAP->ZAP_PREV12 + ZAP->ZAP_PREV13 + ZAP->ZAP_PREV14 + ZAP->ZAP_PREV15 +;
		    		    ZAP->ZAP_PREV16 + ZAP->ZAP_PREV17 + ZAP->ZAP_PREV18 + ZAP->ZAP_PREV19 + ZAP->ZAP_PREV20 +;
					    ZAP->ZAP_PREV21 + ZAP->ZAP_PREV22 + ZAP->ZAP_PREV23 + ZAP->ZAP_PREV24 + ZAP->ZAP_PREV25 +;
		    		    ZAP->ZAP_PREV26 + ZAP->ZAP_PREV27 + ZAP->ZAP_PREV28 + ZAP->ZAP_PREV29 + ZAP->ZAP_PREV30 +;
		    		    ZAP->ZAP_PREV31
	  	    
	  	    aAdd(Acols,{ZAP->ZAP_ITEM, ZAP->ZAP_PROD, ZAP->ZAP_DESC,_nDif,ZAP->ZAP_PRECUN,;
		    			ZAP->ZAP_PREV01, ZAP->ZAP_PREV02, ZAP->ZAP_PREV03,ZAP->ZAP_PREV04, ZAP->ZAP_PREV05,;
		    			ZAP->ZAP_PREV06, ZAP->ZAP_PREV07,ZAP->ZAP_PREV08, ZAP->ZAP_PREV09, ZAP->ZAP_PREV10,;
						ZAP->ZAP_PREV11, ZAP->ZAP_PREV12,ZAP->ZAP_PREV13, ZAP->ZAP_PREV14, ZAP->ZAP_PREV15,;
		    			ZAP->ZAP_PREV16, ZAP->ZAP_PREV17,ZAP->ZAP_PREV18, ZAP->ZAP_PREV19, ZAP->ZAP_PREV20,;
						ZAP->ZAP_PREV21, ZAP->ZAP_PREV22,ZAP->ZAP_PREV23, ZAP->ZAP_PREV24, ZAP->ZAP_PREV25,;
		    			ZAP->ZAP_PREV26, ZAP->ZAP_PREV27,ZAP->ZAP_PREV28, ZAP->ZAP_PREV29, ZAP->ZAP_PREV30,;
		    			ZAP->ZAP_PREV31, _nZAPTot,ZAP->ZAP_PREVM1,ZAP->ZAP_PREVM2, ZAP->ZAP_PREVM3, ZAP->ZAP_PREVM4, ;
		    			ZAP->ZAP_PREVM5, ZAP->ZAP_PREVM6,ZAP->ZAP_PEDCLI,.F.})
			
			ZAP->(DbSkip())
		EndDo
	EndIf	
EndIf

If _cParam == 1 .Or. _cParam == 4 //visualiza ou exclui              

	//define os campos como inalteráveis
	For x:= 2 to len(aHeader)
		aHeader[x][8]  := ".F."
	Next x

EndIf

If _cParam == 6 //imprimir
	fPCPimp2()
	Return
EndIf

If _cParam == 2  //inclui
	DbSelectArea('ZAO')
	_cCod := GetSXENum("ZAO","ZAO_NUM")
	_aMeses := {}
EndIf
	
If _cParam == 3 .Or. _cParam == 2 //altera ou inclui
	// Cria um array com os valores {"Janeiro","Fevereiro",...}
	For x:=1 to 12
		aAdd(_aMeses,MesExtenso(x))
	Next
EndIf

//------------------------------------------
// CONSTRÓI A TELA
//------------------------------------------

	If _cPar == 2//incluir
		aAdd(aButtons,{"MENURUN",{||Processa({||fCarreg()},"Carregando ítens... Aguarde")},"Carrega ítens do último release","Carrega"})
	EndIf

	aAdd(aButtons,{"RECALC",{||Processa({||recalcDif()},"Calculando a diferença... Aguarde")},"Calcula a diferença","Diferença"})
	aAdd(aButtons,{"CRITICA",{||fObs()},"Inclui observação","Observação"})

	bEnchoice := {||EnchoiceBar(oDialog,bOk,bCanc,,aButtons)}

//	@ aPosObj[2,3]+5,(aSize[5]/2)-178 BUTTON "Diferenca" size 40,15 ACTION recalcDif() object oRecDif
//	@ aPosObj[2,3]+5,(aSize[5]/2)-133 BUTTON "Observacao" size 40,15 ACTION fObs() object oObs

//	Define MsDialog oDialog Title OemToAnsi("Release x Entregas") FROM aSize[7],000 TO aSize[6],aSize[5] PIXEL
	oDialog := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Release x Entregas",,,,,CLR_BLACK,CLR_WHITE,,,.T.)	

	@ 020,005 Say "Release: " Size 040,8 Object olCod
	@ 020,035 Say _cCod Size 040,8 Object oCod
	oCod:Setfont(oFont) 
	@ 020,100 Say "Cliente: " Size 040,8 Object olCli
	@ 018,120 Get _cClie Picture "@!" F3 "SA1" When(_cPar == 2 .OR. _cPar == 3) Size 40,8 Valid fClie() object oCli
	@ 018,162 Get _cLoja Picture "@!" When(_cPar == 2 .OR. _cPar == 3) Size 10,8 Valid fLoja() Object oLoja
	@ 018,180 Get _cCliDesc Picture "@!" When .F. Size 160,8 Object oCliDesc

	@ 032,005 Say OemtoAnsi("Nº Release: ") Size 040,8 object olnum
	@ 030,035 Get _cRel Picture "@!" When(_cPar == 2 .or. _cPar == 3) Size 40,8 Valid(naovazio()) object onum
	@ 032,100 Say OemtoAnsi("Data Receb.: ") Size 040,8 object oldata
	@ 030,150 Get _cDtRel Picture "99/99/99" When(_cPar == 2 .OR. _cPar == 3) Size 40,8	Object odata
		
	@ 032,200 Say "Mes:" Size 040,8 object olmes

	If _cParam == 1 .Or. _cParam == 4  //visualiza ou exclui
   	 	@ 032,215 Say _cMes SIZE 60,10 object omes
	EndIf

	@ 032,310 Say OemtoAnsi("Ano: ") Size 040,8 object oldata
	@ 030,325 Get _cAnoRel Picture "@e 9999" Size 40,8	Object odata

	If _cParam == 2 .Or. _cParam == 3 //inclui ou altera
    	@ 030,225 COMBOBOX _cMes ITEMS _aMeses SIZE 80,10 object ocombo
	EndIF
	
	@ 044,005 Say OemtoAnsi("Obs. Geral") Size 040,8 object olnum
	@ 042,035 Get _cObsGer Picture "@!" When(_cPar == 2 .OR. _cPar == 3) Size 300,8	Object oobsger

	//--- Multiline ---
	
	DbSelectArea('ZAO')
	
	@ 56,aPosObj[2,2] TO aPosObj[2,3],aPosObj[2,4] MULTILINE MODIFY DELETE OBJECT oMultiline

	If _cPar == 1 .Or. _cPar == 4  //visualiza ou exclui 
   		oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline
	Endif  

//	If _cPar == 2//incluir
//		@ aPosObj[2,3]+5,(aSize[5]/2)-223 BUTTON "Carregar" size 40,15 ACTION fCarreg() object oCarreg
//	EndIf

//	@ aPosObj[2,3]+5,(aSize[5]/2)-178 BUTTON "Diferenca" size 40,15 ACTION recalcDif() object oRecDif
//	@ aPosObj[2,3]+5,(aSize[5]/2)-133 BUTTON "Observacao" size 40,15 ACTION fObs() object oObs
//	@ aPosObj[2,3]+5,(aSize[5]/2)-88  BUTTON "Ok" size 40,15  ACTION fOk() object obtok
//	@ aPosObj[2,3]+5,(aSize[5]/2)-43  BUTTON "Cancelar" size 40,15 ACTION fEnd() object obtcanc

	oDialog:Activate(,,,.F.,{||.T.},,bEnchoice)
	
	//Activate MsDialog oDialog Center// Valid fValida()

Return

//******************************************//
// fCalcDif()                               //   
// Calcula a diferenca dos itens do release //
//******************************************//

Static Function fCalcDif()                         

Local _nPlanej := 0
Local _nEntreg := 0
Local _x := 1

	While _x <= 31
		cCAMPO   := "ZAP->ZAP_PREV" + STRZERO(_x,2)
	    _nPlanej += &(cCampo)
	    _nEntreg += fEntr(CtoD(StrZero(_x,2)+"/"+StrZero(ZAO->ZAO_MES,2)+"/"+StrZero(Year(ZAO->ZAO_DTINI),4)))
		_x++
	EndDo

	_nDif := (_nEntreg - _nPlanej)// + ZAP->ZAP_ATRASO

	If Select("TRB") > 1
		TRB->(DbCloseArea())
	EndIf
	
	cQuery := "SELECT TOP 1 ZAP_ATRASO FROM "+RetSqlName("ZAP")
	cQuery += " WHERE ZAP_PROD = '"+ZAP->ZAP_PROD+"'"
	cQuery += " AND D_E_L_E_T_ = ' ' AND ZAP_FILIAL = '"+xFilial("ZAP")+"'"
	cQuery += " AND ZAP_NUM <> '"+ZAO->ZAO_NUM+"'"
	cQuery += " ORDER BY R_E_C_N_O_ DESC"

	TCQUERY cQuery New Alias "TRB"

	If !Empty(TRB->ZAP_ATRASO)
		_nDif += TRB->ZAP_ATRASO
	EndIf

Return
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcao para recalcular a diferenca do atrazo dos produtos.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function recalcDif()

Local _nNewDif
Local _cNRel 
Local _cIRel 
Local _cPrdt := Acols[n][2]

//release encerrado
iF ZAO->ZAO_STATUS == 'E'
	MsgBox('Release encerrado!'+chr(13)+chr(10)+'Não é possível atualizar o atraso!','Atraso','INFO')
	Return .F.
EndIf

If !fValAlt()
	Return .F.
EndIf

//Traz o atraso do release anterior
cQueryA := "SELECT TOP 1 ZAP_NUM,ZAP_ITEM, ZAP_ATRASO FROM "+RetSqlName("ZAP")
cQueryA += " WHERE ZAP_PROD = '"+Acols[n][2]+"'"
cQueryA += " AND D_E_L_E_T_ = ' ' AND ZAP_FILIAL = '"+xFilial("ZAP")+"'"
cQueryA += " AND ZAP_NUM <> '"+ZAO->ZAO_NUM+"'" 
cQueryA += " ORDER BY R_E_C_N_O_ DESC"

TCQUERY cQueryA New Alias "NDF"

If !Empty(NDF->ZAP_NUM)
	_nNewDif := NDF->ZAP_ATRASO
	_cNRel   := NDF->ZAP_NUM
	_cIRel   := NDF->ZAP_ITEM
ELSE
	MsgBox('Release não possui Atraso!','Atraso','INFO')
	Return .F.
EndIf

NDF->(DBCLOSEAREA())

//------------------------------------------
// CONSTRÓI A TELA
//------------------------------------------

	Define MsDialog oDialogDif Title OemToAnsi("Diferença") From 000,000 To 120,200 Pixel 
	
	@ 010,005 Say "Produto: "+_cPrdt Size 060,8 Object olCodp
	@ 025,005 Say "Dif. Anterior: " Size 040,8 Object oldif
	@ 025,040 Get _nNewDif Picture "@e 999999999" Size 40,8 object onewdif

	@ 040,005 BMPBUTTON TYPE 01 ACTION grvNewDif(_cNRel,_cIRel,_nNewDif)
	@ 040,035 BMPBUTTON TYPE 02 ACTION Close(oDialogDif) 

	Activate MsDialog oDialogDif Center// Valid fValida()

Return 
     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava informacoes da alteracao do atraso³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function grvNewDif(_numrelease,_itemrelease,_newdif)

	//grava o novo atraso a recalcula o atraso no multiline
	ZAP->(DBSETORDER(1)) //FILIAL + NUM + ITEM
	IF ZAP->(DBSEEK(XFILIAL('ZAP')+_numrelease+_itemrelease))
		RECLOCK('ZAP',.F.)
			ZAP->ZAP_ATRASO := _newdif
		MSUNLOCK('ZAP')
		
	 	If ZAP->(DbSeek(xFilial("ZAP")+ZAO->ZAO_NUM+Acols[n][1]))

		   	If EMPTY(ZAP->ZAP_ATRASO)
		   		fCalcDif() //Traz a diferenca de entragas (em _nDif) considerando entregas anteriores
	   		ENDIF

			Acols[n][4] := _nDif

			oMultiline:Refresh()
		ENDIF
	ELSE
		ALERT('ERRO, CONSULTE A INFORMATICA')
		RETURN
	ENDIF
	
	Close(oDialogDif) 
Return

//-----------------------------------------------------//
//  Funcao que verifica se é a primeira semana do ano  //
//  se for, verifica se existem valores em campos  do  //
//	acols que não existem na primeira semana do ano.   //
//-----------------------------------------------------//
/*
Static Function fSemana() 
Local _dDia	
	If Val(Substr(_cSemIni,8,2)) == 1          
		_dDia := StoD(STR(YEAR(Date()),4)+"0101")
        For _j := 1 to len(Acols)
			For _x := 1 to 7
				If Dow(_dDia) == _x 
					Return(.T.)
				Elseif Acols[_j][_x+3] <> 0
					MsgBox("Dia "+Str(_x,1)+" não existe na semana 1 do ano. Deixe o campo zerado.")
					Return(.F.)
				EndIf
			Next _x
		Next _j
	EndIf	
Return(.T.)
*/

//-----------------------------------------------------//
//Funcao que incrementa o campo loja                   //
//-----------------------------------------------------//

Static Function fClie()
	SA1->(DbSetOrder(1)) //filial + cod + loja
	SA1->(DbSeek(xFilial("SA1")+_cClie))
	If !SA1->(Found())
		MsgAlert("Cliente não cadastrado.Verifique")
		Return .F.
	EndIf
Return(.T.)

//-----------------------------------------------------//
// Funcao que complementa a descricao do cliente       //
//-----------------------------------------------------//

Static Function fLoja()
	DbSelectArea('SA1')
	SA1->(DbSetOrder(1)) //Filial + Cod + loja
	SA1->(DbSeek(xFilial('SA1')+AllTrim(_cClie)+AllTrim(_cLoja)))
	If SA1->(Found())
		_cCliDesc := SA1->A1_NOME
		oCliDesc:Refresh()
	Else
		MsgAlert("Loja não cadastrada. Verifique.")
		Return.F.
	EndIf
Return(.T.)

//------------------------------------------------------------//
// Funcao que complementa a descricao do produto no multiline //
//------------------------------------------------------------//

User Function fProd3()

Local _nProd  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZAP_PROD"}) 
Local _nDescri:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZAP_DESC"})
Local _aCompl := {}
Local _cDesc := ""

If !Acols[n][len(aHeader)+1]  //nao pega quando a linha esta deletada
   	
    SB1->(DbSetOrder(1))
    If SB1->(DbSeek(xFilial("SB1")+Acols[n][_nProd]))
		Acols[n][_nDescri] := SB1->B1_DESC
	Else 
		Alert("Produto nao cadastrado.")
	Endif
	
	If Select("TRB") > 1
		TRB->(DbCloseArea())
	EndIF
	
	DbSelectArea("SX7")
	
Endif

_cDesc := Acols[n][_nDescri] 

oMultiline:Refresh()                                    

Return(_cDesc)

//-----------------------------------------------------//
// Funcao de confirmacao da tela                       //
//-----------------------------------------------------//

Static Function fOK()
Local n := Len(Acols)

Local _n 
Local _aGrupo  := pswret()  // retorna vetor com dados do usuario
Local _cNome   := _agrupo[1,4] // Nome completo
Local _lGravou := .F.
	If _cParam == 1 //visualiza
		Close(oDialog)
	EndIf

	If _cParam == 2 //inclui
		If fValida()

			RecLock('ZAO',.T.)
				ZAO->ZAO_FILIAL 	:= xFilial('ZAO')
				ZAO->ZAO_NUM		:= _cCod
				ZAO->ZAO_CLIENT		:= _cClie 
				ZAO->ZAO_DESCLI     := _cCliDesc
				ZAO->ZAO_LOJA		:= _cLoja
				ZAO->ZAO_DTDIGI		:= Date()
				ZAO->ZAO_DTINI 		:= CtoD("01/"+StrZero(Ascan(_aMeses,{|x| x == _cMes}),2)+"/"+_cAnoRel)
				ZAO->ZAO_DTFIM  	:= ULTIMODIA(CtoD("01/"+StrZero(Ascan(_aMeses,{|x| x == _cMes}),2)+"/"+_cAnoRel ))
				ZAO->ZAO_STATUS 	:= "P"
				ZAO->ZAO_MES        := Ascan(_aMeses,{|x| x == _cMes})
				ZAO->ZAO_RELCLI		:= _cRel
				ZAO->ZAO_DTREL		:= _cDtRel
				ZAO->ZAO_RESP       := cUserName //Substr(_cNome,1,30)
				ZAO->ZAO_OBSGER     := _cObsGer
			MsUnLock('ZAO')       
		
			For x:=1 to len(Acols)
				RecLock('ZAP',.T.)
					ZAP->ZAP_FILIAL := xFilial('ZAP')
					ZAP->ZAP_NUM	:= _cCod
					ZAP->ZAP_ITEM   := Acols[x][1]
					ZAP->ZAP_PROD   := Acols[x][2]
					ZAP->ZAP_DESC   := Acols[x][3]
					ZAP->ZAP_ATRASO := 0
					ZAP->ZAP_PRECUN := Acols[x][5]
                   	ZAP->ZAP_PREV01 := Acols[x][6]
                   	ZAP->ZAP_PREV02 := Acols[x][7]
					ZAP->ZAP_PREV03 := Acols[x][8]
					ZAP->ZAP_PREV04 := Acols[x][9]
					ZAP->ZAP_PREV05 := Acols[x][10]
					ZAP->ZAP_PREV06 := Acols[x][11]
					ZAP->ZAP_PREV07 := Acols[x][12]
					ZAP->ZAP_PREV08 := Acols[x][13]
					ZAP->ZAP_PREV09 := Acols[x][14]
					ZAP->ZAP_PREV10 := Acols[x][15]
                   	ZAP->ZAP_PREV11 := Acols[x][16]
                   	ZAP->ZAP_PREV12 := Acols[x][17]
					ZAP->ZAP_PREV13 := Acols[x][18]
					ZAP->ZAP_PREV14 := Acols[x][19]
					ZAP->ZAP_PREV15 := Acols[x][20]
					ZAP->ZAP_PREV16 := Acols[x][21]
					ZAP->ZAP_PREV17 := Acols[x][22]
					ZAP->ZAP_PREV18 := Acols[x][23]
					ZAP->ZAP_PREV19 := Acols[x][24]
					ZAP->ZAP_PREV20 := Acols[x][25]                   						                   	
                   	ZAP->ZAP_PREV21 := Acols[x][26]
                   	ZAP->ZAP_PREV22 := Acols[x][27]
					ZAP->ZAP_PREV23 := Acols[x][28]
					ZAP->ZAP_PREV24 := Acols[x][29]
					ZAP->ZAP_PREV25 := Acols[x][30]
					ZAP->ZAP_PREV26 := Acols[x][31]
					ZAP->ZAP_PREV27 := Acols[x][32]
					ZAP->ZAP_PREV28 := Acols[x][33]
					ZAP->ZAP_PREV29 := Acols[x][34]
					ZAP->ZAP_PREV30 := Acols[x][35]                   						                   	
					ZAP->ZAP_PREV31 := Acols[x][36]                   						                   	
					
					ZAP->ZAP_PREVM1 := Acols[x][38]                   						                   	
					ZAP->ZAP_PREVM2 := Acols[x][39]                   						                   	
					ZAP->ZAP_PREVM3 := Acols[x][40]                   						                   						
					ZAP->ZAP_PREVM4 := Acols[x][41]                   						                   						
					ZAP->ZAP_PREVM5 := Acols[x][42]                   						                   						
					ZAP->ZAP_PREVM6 := Acols[x][43]
					ZAP->ZAP_PEDCLI := Acols[x][44]

				MsUnLock('ZAP')
				_lGravou := .T.
			Next
		EndIf	
		If _lGravou
			ConfirmSX8()
			Close(oDialog)
		EndIf
	EndIf
		
	If _cParam == 3 //altera

		If !fValAlt()
			Return .F.
		EndIf

		If fValida()
			ZAP->(DbSetOrder(1)) //filial + num + ITEM
			For x:=1 to len(Acols) 
				If !Acols[x][len(aHeader)+1]
					
				RecLock('ZAO',.F.)
					ZAO->ZAO_CLIENT		:= _cClie 
					ZAO->ZAO_DESCLI     := _cCliDesc
					ZAO->ZAO_LOJA		:= _cLoja
					ZAO->ZAO_DTINI 		:= CtoD("01/"+StrZero(Ascan(_aMeses,{|x| x == _cMes}),2)+"/"+_cAnoRel )
					ZAO->ZAO_DTFIM  	:= ULTIMODIA(CtoD("01/"+StrZero(Ascan(_aMeses,{|x| x == _cMes}),2)+"/"+_cAnoRel ))
					ZAO->ZAO_STATUS 	:= "P"
					ZAO->ZAO_MES        := Ascan(_aMeses,{|x| x == _cMes})
					ZAO->ZAO_RELCLI		:= _cRel
					ZAO->ZAO_DTREL		:= _cDtRel
					ZAO->ZAO_OBSGER     := _cObsGer
				MsUnLock('ZAO')       
					
					ZAP->(DbSeek(xFilial("ZAP")+_cCod+Acols[x][1]))
					If ZAP->(Found())  
					 	RecLock('ZAP',.F.)
						 	ZAP->ZAP_FILIAL := xFilial('ZAP')
						 	ZAP->ZAP_NUM	:= _cCod
							ZAP->ZAP_ITEM   := Acols[x][1]
							ZAP->ZAP_PROD   := Acols[x][2]
							ZAP->ZAP_DESC   := Acols[x][3]
							ZAP->ZAP_ATRASO := 0//Acols[x][4]
							ZAP->ZAP_PRECUN := Acols[x][5]
		                   	ZAP->ZAP_PREV01 := Acols[x][6]
		                   	ZAP->ZAP_PREV02 := Acols[x][7]
							ZAP->ZAP_PREV03 := Acols[x][8]
							ZAP->ZAP_PREV04 := Acols[x][9]
							ZAP->ZAP_PREV05 := Acols[x][10]
							ZAP->ZAP_PREV06 := Acols[x][11]
							ZAP->ZAP_PREV07 := Acols[x][12]
							ZAP->ZAP_PREV08 := Acols[x][13]
							ZAP->ZAP_PREV09 := Acols[x][14]
							ZAP->ZAP_PREV10 := Acols[x][15]
		                   	ZAP->ZAP_PREV11 := Acols[x][16]
		                   	ZAP->ZAP_PREV12 := Acols[x][17]
							ZAP->ZAP_PREV13 := Acols[x][18]
							ZAP->ZAP_PREV14 := Acols[x][19]
							ZAP->ZAP_PREV15 := Acols[x][20]
							ZAP->ZAP_PREV16 := Acols[x][21]
							ZAP->ZAP_PREV17 := Acols[x][22]
							ZAP->ZAP_PREV18 := Acols[x][23]
							ZAP->ZAP_PREV19 := Acols[x][24]
							ZAP->ZAP_PREV20 := Acols[x][25]                   						                   	
		                   	ZAP->ZAP_PREV21 := Acols[x][26]
		                   	ZAP->ZAP_PREV22 := Acols[x][27]
							ZAP->ZAP_PREV23 := Acols[x][28]
							ZAP->ZAP_PREV24 := Acols[x][29]
							ZAP->ZAP_PREV25 := Acols[x][30]
							ZAP->ZAP_PREV26 := Acols[x][31]
							ZAP->ZAP_PREV27 := Acols[x][32]
							ZAP->ZAP_PREV28 := Acols[x][33]
							ZAP->ZAP_PREV29 := Acols[x][34]
							ZAP->ZAP_PREV30 := Acols[x][35]
							ZAP->ZAP_PREV31 := Acols[x][36]
							ZAP->ZAP_PREVM1 := Acols[x][38]
							ZAP->ZAP_PREVM2 := Acols[x][39]
							ZAP->ZAP_PREVM3 := Acols[x][40]
							ZAP->ZAP_PREVM4 := Acols[x][41]
							ZAP->ZAP_PREVM5 := Acols[x][42]
							ZAP->ZAP_PREVM6 := Acols[x][43]
							ZAP->ZAP_PEDCLI := Acols[x][44]
						MsUnLock('ZAP')    
						_lGravou := .T.
					Else
	//					fVerifi()
						If fValida()
							RecLock("ZAP",.T.)
								ZAP->ZAP_FILIAL := xFilial('ZAP')
								ZAP->ZAP_NUM	:= _cCod
								ZAP->ZAP_ITEM   := Acols[x][1]
								ZAP->ZAP_PROD   := Acols[x][2]
								ZAP->ZAP_DESC   := Acols[x][3]
								ZAP->ZAP_ATRASO := 0//
								ZAP->ZAP_PRECUN := Acols[x][5]
		                   		ZAP->ZAP_PREV01 := Acols[x][6]
			                   	ZAP->ZAP_PREV02 := Acols[x][7]
								ZAP->ZAP_PREV03 := Acols[x][8]
								ZAP->ZAP_PREV04 := Acols[x][9]
								ZAP->ZAP_PREV05 := Acols[x][10]
								ZAP->ZAP_PREV06 := Acols[x][11]
								ZAP->ZAP_PREV07 := Acols[x][12]
								ZAP->ZAP_PREV08 := Acols[x][13]
								ZAP->ZAP_PREV09 := Acols[x][14]
								ZAP->ZAP_PREV10 := Acols[x][15]
			                   	ZAP->ZAP_PREV11 := Acols[x][16]
			                   	ZAP->ZAP_PREV12 := Acols[x][17]
								ZAP->ZAP_PREV13 := Acols[x][18]
								ZAP->ZAP_PREV14 := Acols[x][19]
								ZAP->ZAP_PREV15 := Acols[x][20]
								ZAP->ZAP_PREV16 := Acols[x][21]
								ZAP->ZAP_PREV17 := Acols[x][22]
								ZAP->ZAP_PREV18 := Acols[x][23]
								ZAP->ZAP_PREV19 := Acols[x][24]
								ZAP->ZAP_PREV20 := Acols[x][25]                   						                   	
		        	           	ZAP->ZAP_PREV21 := Acols[x][26]
		            	       	ZAP->ZAP_PREV22 := Acols[x][27]
								ZAP->ZAP_PREV23 := Acols[x][28]
								ZAP->ZAP_PREV24 := Acols[x][29]
								ZAP->ZAP_PREV25 := Acols[x][30]
								ZAP->ZAP_PREV26 := Acols[x][31]
								ZAP->ZAP_PREV27 := Acols[x][32]
								ZAP->ZAP_PREV28 := Acols[x][33]
								ZAP->ZAP_PREV29 := Acols[x][34]
								ZAP->ZAP_PREV30 := Acols[x][35]
								ZAP->ZAP_PREV31 := Acols[x][36]
								ZAP->ZAP_PREVM1 := Acols[x][38]
								ZAP->ZAP_PREVM2 := Acols[x][39]
								ZAP->ZAP_PREVM3 := Acols[x][40]
								ZAP->ZAP_PREVM4 := Acols[x][41]
								ZAP->ZAP_PREVM5 := Acols[x][42]
								ZAP->ZAP_PREVM6 := Acols[x][43]
								ZAP->ZAP_PEDCLI := Acols[x][44]
								
							MsUnLock("ZAP")
							_lGravou := .T.
						EndIf
					EndIf
				Else 
					ZAP->(DbSeek(xFilial("ZAP")+_cCod+Acols[x][1]))
					RecLock("ZAP",.F.)
						ZAP->(DbDelete())
					MsUnLock("ZAP")
					_lGravou := .T.
				EndIf
			Next
			If _lGravou
				Close(oDialog)
			EndIf
		EndIf
	EndIf
	
	If _cParam == 4 //exclui
		
		If !fValAlt()
			Return .F.
		EndIf
		
	    If MsgYesNo("Tem certeza que deseja excluir a programação?")
			RecLock("ZAO",.F.)
				ZAO->(DbDelete())
			MsUnLock("ZAO")
			ZAP->(DbSetOrder(1))//filial + num + item
			ZAP->(DbSeek(xFilial('ZAP')+_cCod))
			While ZAP->ZAP_NUM == _cCod
				RecLock("ZAP",.F.)
					ZAP->(DbDelete())
				MsUnLock("ZAP")
				ZAP->(DbSkip())
			EndDo
		EndIf			
		Close(oDialog)		
	EndIf 
Return

Static Function fValAlt()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Para o cliente WHB INTERNACIONAL liberado realizar alterações por  ³
	//³ MARIOCP/CASSIANORS/LILIANEG                                        ³
	//³ Solicitado através do chamado 006247 do helpdesk                   ³
	//³                                                                    ³
	//³ Liberado acesso a MARCIOLT para alteração de qualquer release      ³
	//³ conforme chamado 011938 do portal                                  ³ 
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If AllTrim(ZAO->ZAO_RESP)$Upper(AllTrim(cUserName)) .or. ;
	   Upper(Alltrim(cUserName))$"MARIOCP/EMERSONDP/MARCIOLT" .or. ; //usuarios liberados para alterar qualquer release
	   (ZAO->ZAO_CLIENT=="000147" .AND. ZAO->ZAO_LOJA=="01") .AND. Upper(Alltrim(cUserName))$"MARIOCP/CASSIANORS/LILIANEG" //usuarios liberados para alterar este cliente
		Return .T.
	Else
		Alert("Usuário não autorizado para alterar o release.")
		Return(.F.)
	EndIf
	
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ENCERRA A TELA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fEnd() 

	RollBackSx8()
   	Close(oDialog) 
   	lDialog := .T.

Return 

//---------------------------------------------------
// Funcao de Validacao
//---------------------------------------------------
Static Function fValida()

	If _cParam == 2 .or. _cParam == 3  //inclui e altera

   	    If Empty(_cClie)  .or. Empty(_cLoja)
	    	MsgAlert("Digite o Cliente e Loja.")
	    	Return(.F.)
	    EndIf 

		If Valtype(_cMes) == "N"
			_cMes := _aMeses[_cMes]
		EndIf 
		
		For _x:= 1 to Len(Acols)

			If Select('TMX') > 0
				TMX->(DbCloseArea())
			EndIF

			cQuery := " SELECT ZAO.ZAO_NUM, ZAO.ZAO_MES, ZAP.ZAP_PROD FROM "+RetSqlName("ZAO")+" ZAO,"+RetSqlName("ZAP")+" ZAP"
			cQuery += " WHERE ZAO.ZAO_CLIENT = '"+_cClie+"'"
			cQuery += " AND ZAO.ZAO_LOJA = '"+_cLoja+"'"
			cQuery += " AND ZAP.ZAP_PROD = '"+ACOLS[_x][2]+"'"
			cQuery += " AND ZAP.ZAP_NUM = ZAO.ZAO_NUM"
			If _cParam == 3
				cQuery += " AND ZAO.ZAO_NUM <> '"+_cCod+"'"
			EndIf
			cQuery += " AND ZAO.D_E_L_E_T_ = ' ' AND ZAO.ZAO_FILIAL = '"+xFilial('ZAO')+"'"
			cQuery += " AND ZAO.D_E_L_E_T_ = ' ' AND ZAO.ZAO_FILIAL = '"+xFilial('ZAP')+"'"
			cQuery += " AND SUBSTRING(ZAO.ZAO_DTINI,1,4) = '"+_cAnoRel+"'"
			cQuery += " AND ZAO.ZAO_MES = '"+StrZero(Ascan(_aMeses,{|x| x == _cMes}),2)+"'"
			
			TCQUERY cQuery NEW ALIAS "TMX"     
		
			If !Empty(TMX->ZAO_NUM)
				MsgAlert("Release ja existe no mes para este fornecedor e produto. Verifique!")
				Return(.F.)
			EndIf
		Next
   	EndIF
Return(.T.)
             
//---------------------------------------------------
// funcao que cria as cores de legenda
//---------------------------------------------------

Static Function fCriaCor()       

		Local aLegenda :=	{ {"BR_VERDE"    , "Aprovada"  },;
 		  					  {"BR_VERMELHO" , "Encerrada" },;
	   						  {"BR_AMARELO"  , "Pendente"  }}

	Local uRetorno := {}
	Aadd(uRetorno, { 'ZAO_STATUS = "A"' , aLegenda[1][1] } )
	Aadd(uRetorno, { 'ZAO_STATUS = "E"' , aLegenda[2][1] } )
	Aadd(uRetorno, { 'ZAO_STATUS = "P"' , aLegenda[3][1] } )
	
Return(uRetorno)



//-------------------------------------------------------
// FUNCAO PARA IMPRESSAO DO RELATORIO DO RELEASE
//-------------------------------------------------------
// D
Static Function fPCPimp2()   

cString   := "ZAP"
cDesc1    := OemToAnsi("Este   relatorio   tem   como   objetivo  Imprimir")
cDesc2    := OemToAnsi("a relação dos saldos  dos  Releases  de  Clientes.")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHPCP013"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("PROGRAMACAO DE ENTREGAS")
cabec1    := ""
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHPCP013"
_cPerg    := "PCP013" 
_nMes	  := 0
_nTotPerf := 0 
_nItens   := 0

Pergunte(_cPerg,.F.)

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]      

//Processa( {|| Gerando()   },"Gerando Dados para a Impressao") 
Processa( {|| RptDetail()   },"Imprimindo...") 

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function RptDetail() 
            


	TITULO   := OemToAnsi("PROGRAMACAO DE ENTREGAS DO MES "+UPPER(MESEXTENSO(STR(ZAO->ZAO_MES,2)))+" / "+Str(Year(Date()),4))
	_dDia	 := date()
	_aGrupo  := pswret()  // retorna vetor com dados do usuario
	_cNome   := _agrupo[1,4 ] // Nome completo
	_cEmail  := _agrupo[1,14] // e-mail
	_nSaldo  := 0
	_nTotEnt := 0
	_nTotRel := 0
		
	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criando Arquivo Temporario para posterior impressao          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cArqDBF  := CriaTrab(NIL,.f.)
	_cArqDBF += ".DBF"
	_aFields := {}
	
	AADD(_aFields,{"OK"      ,"C", 02,0})         // Controle do browse
	AADD(_aFields,{"ITEM"    ,"C", 04,0})         // Item do Release
	
	DbCreate(_cArqDBF,_aFields)
	DbUseArea(.T.,,_cArqDBF,"ITM",.F.)
	
	For _x:= 1 to Len(aCols)
	    RecLock("ITM",.T.)
	      ITM->OK        := Space(02)     
	   	  ITM->ITEM      := Acols[_x][1]
	    MsUnlock("ITM")
	Next
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Constrói tela para seleção de ítens ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	aCampos := {}   
	
	Aadd(aCampos,{"OK"    ,"OK"     ,"@!"})
	Aadd(aCampos,{"ITEM"  ,"Item"   ,"@!"})
	
	ITM->(DbGoTop())
	
	@ 50,1 TO 300,200 DIALOG oDlg TITLE "Impressao de Release"
	
	@ 06,05 TO 100,97 BROWSE "ITM" FIELDS aCampos MARK "OK"
	@ 105,05 BUTTON "_Imprimir" SIZE 40,15 ACTION Close(oDlg) Object oBtn
	
	ACTIVATE DIALOG oDlg CENTERED
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ 	Origem das informações    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// OS 069227 - Alteração feita por Douglassd

	@ 50,1 TO 190,300 DIALOG oDlg TITLE "Origem dos dados"
	
	@ 06,05 Say OemtoAnsi("Escolha a origem das informações: ") Size 200,300 Object olOrig
	
	@ 20,05 RADIO aRadio VAR nRadio //Pixel Of oDlg
	
	//@ 20,05 Radio oRadio Var nRadio Items "1000", "2000", "3000" Size 50,9 Pixel Of oDlg
	@ 20,05 Radio oRadio Var nRadio Items "Notas Fiscais de faturamento","Ordens de liberação" Size 100,9 Pixel Of oDlg

	@ 50,05 BUTTON "_Imprimir" SIZE 40,15 ACTION Close(oDlg) Object oBtn
	
	ACTIVATE DIALOG oDlg CENTERED  
	
	if nRadio==1
		cOrigem := 'NF'     	
	endif
	
	if nRadio==2
		cOrigem := 'OL'     	
	endif
	
	ITM->(DbGoTop())
		
	ImpCabec()
    
	If mv_par01 == 2
		ImpDiadia()
	Else
		ImpSemana()
	EndIf
	
	ITM->(DbCloseArea())

Return

//*****************************************************//
//													   //
// Funcao que imprime o relatório diário  do release   //
//													   //
//*****************************************************//
//D
Static Function ImpDiadia()
Local cCampo := ""
	_nMes := Ascan(_aMeses,{|x| x == _cMes})		

	ZAP->(DBSETORDER(1)) //FILIAL + NUM + ITEM
	ZAP->(DBSEEK(XFILIAL("ZAP")+ZAO->ZAO_NUM))
	SB1->(DbSetOrder(1)) //filial + produto
	
    WHILE ZAP->(!EOF()) .And. ZAP->ZAP_NUM == ZAO->ZAO_NUM
		
		If ITM->(MARKED("OK"))
			If Prow() > 55
				Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
			Endif
			
			@Prow()+2, 001 psay "Ítem"
			@Prow()  , 006 psay "Cód. WHB"
			@Prow()  , 027 psay "Cód. Cliente"	
			@Prow()  , 049 psay "Descrição"
			@Prow()  , 084 psay "Última N.F."
			@Prow()  , 100 psay OemToAnsi("Total Diferença")
			@Prow()  , 130 psay OemToAnsi("Preço Un.")
	
			@Prow()+1, 001 psay ZAP->ZAP_ITEM // item
			@Prow()  , 006 psay ZAP->ZAP_PROD // produto
			SB1->(DbSeek(xFilial("SB1")+ZAP->ZAP_PROD))
			If SB1->(Found())
				@Prow()  , 027 psay SB1->B1_CODAP5
			EndIf
			@Prow()  , 049 psay ZAP->ZAP_DESC // desc
			@Prow()  , 086 psay fNota(ZAP->ZAP_PROD)
	
		   	If EMPTY(ZAP->ZAP_ATRASO) .AND. ZAO->ZAO_STATUS <> "E"
		   		fCalcDif() //Traz a diferenca de entragas (em _nDif) considerando entregas anteriores		    
			Else
				_nDif := ZAP->ZAP_ATRASO
			EndIf	
	
			@Prow()  , 104 psay _nDif
			@Prow()  , 134 psay ZAP->ZAP_PRECUN PICTURE("@E 9,999.99")
			
			@Prow()+1, 000 psay __PrtThinLine()
			
			//******************************************//
			// Imprime o cabeçalho dos dias de 1 até 16 //
			//******************************************//
			@Prow()+1, 001 psay "Dia: -------->"
			For x:= 1 to 16
				@Prow()  , (x*11)+16 psay StrZero(x,2)
			Next
			@Prow()+1, 019 psay Repli("_",180)
	
			//**********************************************//
			// Imprime o que foi programado do dia 01 ao 16 //
			//**********************************************//
			@Prow()+1, 001 psay "Release:----->"
			For x:= 1 to 16
				cCampo := "ZAP->ZAP_PREV"+StrZero(x,2)
				@Prow()  , (X*11)+8 psay &(cCampo) PICTURE("@E 9999999999")// prev DIA			
			Next
	
			//********************************************//
			// Imprime o que foi entregue do dia 01 ao 16 //
			//********************************************//
			@Prow()+1, 001 psay "Entregue:---->"                                                                       
			For x:= 1 to 16
			
			   if cOrigem=='NF'
				 @Prow()  , (X*11)+8 psay fEntr(CtoD(StrZero(x,2)+"/"+StrZero(ZAO->ZAO_MES,2)+"/"+StrZero(Year(ZAO->ZAO_DTINI),4))) PICTURE("@E 9999999999")// entr dia01
			   else 
				 @Prow()  , (X*11)+8 psay fEntr2(CtoD(StrZero(x,2)+"/"+StrZero(ZAO->ZAO_MES,2)+"/"+StrZero(Year(ZAO->ZAO_DTINI),4))) PICTURE("@E 9999999999")// entr dia01					   
			   endif
				
			Next
	
			//*************************************************//
			// Imprime a diferença de entregas do dia 01 ao 16 //
			//*************************************************//
			@Prow()+1, 001 psay "Diferenca:--->"
			For x:= 1 to 16
				cCampo  := "ZAP->ZAP_PREV"+STRZERO(X,2)
				
				if cOrigem=='NF'
					_nSaldo += fEntr(CtoD(StrZero(x,2)+"/"+StrZero(ZAO->ZAO_MES,2)+"/"+StrZero(Year(ZAO->ZAO_DTINI),4))) - &(cCampo)
				else					
					_nSaldo += fEntr2(CtoD(StrZero(x,2)+"/"+StrZero(ZAO->ZAO_MES,2)+"/"+StrZero(Year(ZAO->ZAO_DTINI),4))) - &(cCampo)				
				endif
				
				@Prow()  , (x*11)+8 psay _nSaldo PICTURE("@E 9999999999")// entr dia
			Next
		
			//******************************************//
			// Imprime o cabeçalho dos dias de 1 até 16 //
			//******************************************//
			@Prow()+2, 001 psay "Dia: -------->"
			For x:= 1 to 15
				@Prow()  , (x*11)+16 psay StrZero(x+16,2)
			Next
			@Prow()+1, 019 psay Repli("_",180)
	
			//**********************************************//
			// Imprime o que foi programado do dia 17 ao 31 //
			//**********************************************//
			@Prow()+1, 001 psay "Release:----->"
			For x:= 17 to 31
				cCampo := "ZAP->ZAP_PREV"+STRZERO(X,2)
				@Prow()  , ((x-16)*11)+8 psay &(cCampo) PICTURE("@E 9999999999")// prev DIA
			Next
	
			//********************************************//
			// Imprime o que foi entregue do dia 17 ao 31 //
			//********************************************//
			@Prow()+1, 001 psay "Entregue:---->"
			For x:= 17 to 31 

			  if cOrigem=='NF'			
				@Prow()  , ((X-16)*11)+8 psay fEntr(CtoD(StrZero(x,2)+"/"+StrZero(ZAO->ZAO_MES,2)+"/"+StrZero(Year(ZAO->ZAO_DTINI),4))) PICTURE("@E 9999999999")// entr dia01
			  else					
				@Prow()  , ((X-16)*11)+8 psay fEntr2(CtoD(StrZero(x,2)+"/"+StrZero(ZAO->ZAO_MES,2)+"/"+StrZero(Year(ZAO->ZAO_DTINI),4))) PICTURE("@E 9999999999")// entr dia01			  
		   	  endif
				
			Next
	
			//*************************************************//
			// Imprime a diferença de entregas do dia 01 ao 16 //
			//*************************************************//
			@Prow()+1, 001 psay "Diferenca:--->"
			For x:= 17 to 31
				cCampo  := "ZAP->ZAP_PREV"+STRZERO(X,2)
				
				if cOrigem=='NF'
				   _nSaldo += fEntr(CtoD(StrZero(x,2)+"/"+StrZero(ZAO->ZAO_MES,2)+"/"+StrZero(Year(ZAO->ZAO_DTINI),4))) - &(cCampo)
				else
				   _nSaldo += fEntr2(CtoD(StrZero(x,2)+"/"+StrZero(ZAO->ZAO_MES,2)+"/"+StrZero(Year(ZAO->ZAO_DTINI),4))) - &(cCampo)				                                                                                                                    
				endif				   
				
				@Prow()  , ((x-16)*11)+8 psay _nSaldo PICTURE("@E 9999999999")// entr dia
			Next
			
			For x:=1 to 31
			    
				if cOrigem=='NF'
					_nTotalE += fEntr(CtoD(StrZero(x,2)+"/"+StrZero(ZAO->ZAO_MES,2)+"/"+StrZero(Year(ZAO->ZAO_DTINI),4)))
				else
					_nTotalE += fEntr2(CtoD(StrZero(x,2)+"/"+StrZero(ZAO->ZAO_MES,2)+"/"+StrZero(Year(ZAO->ZAO_DTINI),4)))
				endif
				
				cCampo := "ZAP->ZAP_PREV"+STRZERO(X,2)
				_nTotalR += &(cCampo)
			Next
			
			@Prow() +2, 001 psay "Total Release: "      + Alltrim(Transform (_nTotalR,"@e 9999999999"))
			@Prow()   , 050 psay "Total Entregue: "     + Alltrim(Transform (_nTotalE,"@e 9999999999"))
			@Prow()   , 100 psay OemToAnsi("Difererença: ")  + Alltrim(Transform (_nTotalE - _nTotalR,"@e 9999999999"))
			@Prow()   , 150 psay "Performance: "        + Transform(((_nTotalE*100) / _nTotalR),"@e 999") + "%"
					
			_nTotEnt += _nTotalE
			_nTotRel += _nTotalR
			
			@ Prow()+1,000 PSAY __PrtThinLine()  
	
			_nSaldo  := 0
			_nTotalE := 0
			_nTotalR := 0
	        
		EndIf
		ITM->(DBSKIP())
		ZAP->(DBSKIP())
		
	EndDo

	@ Prow()+2,000 PSAY __PrtThinLine()
	@ Prow()+1,001 Psay "Performance Geral: " + Transform(((_nTotEnt*100)/_nTotRel),"@e 9999")+"%"

Return(nil) 

//*****************************************************//
//													   //
// Funcao que imprime o relatório semanal de release   //
//													   //
//*****************************************************//

Static Function ImpSemana()

Local _dData := dATE()
Local _nCol := 1	 //coluna da semana em que vai somada a previsao do dia
Local _aPrev := {}
Local _aSPrev := {0,0,0,0,0,0}
Local _aSEntr := {0,0,0,0,0,0}
Local _nMes := Ascan(_aMeses,{|x| x == _cMes})		
lOCAL _X := 1
	
	ZAP->(DBSETORDER(1)) //FILIAL + NUM + ITEM
	ZAP->(DBSEEK(XFILIAL("ZAP")+ZAO->ZAO_NUM))

    WHILE ZAP->(!EOF()) .And. ZAP->ZAP_NUM == ZAO->ZAO_NUM
		
		If ITM->(MARKED("OK"))
		
			If Prow() > 70
				Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
			Endif
			
			@Prow()+2, 001 psay "Item"
			@Prow()  , 006 psay "Cód. WHB"
			@Prow()  , 027 psay "Cód. Cliente"	
			@Prow()  , 049 psay "Descrição"
			@Prow()  , 084 psay "Ultima N.F."
			@Prow()  , 100 psay OemToAnsi("Total Diferença")
			@Prow()  , 130 psay OemToAnsi("Preço Un.")
	
			@Prow()+1, 001 psay ZAP->ZAP_ITEM // item
			@Prow()  , 006 psay ZAP->ZAP_PROD // produto
			SB1->(DbSetOrder(1)) //filial + produto
			SB1->(DbSeek(xFilial("SB1")+ZAP->ZAP_PROD))
			If SB1->(Found())
				@Prow()  , 027 psay SB1->B1_CODAP5
			EndIf
			@Prow()  , 049 psay ZAP->ZAP_DESC // desc
			@Prow()  , 086 psay fNota(ZAP->ZAP_PROD)
	
		   	If EMPTY(ZAP->ZAP_ATRASO) .AND. ZAO->ZAO_STATUS <> "E"
		   		fCalcDif() //Traz a diferenca de entragas (em _nDif) considerando entregas anteriores		    
			Else
				_nDif := ZAP->ZAP_ATRASO
			EndIf	
	
			@Prow()  , 104 psay _nDif
			@Prow()  , 134 psay ZAP->ZAP_PRECUN PICTURE("@E 9,999.99")
			
			@Prow()  , 158 psay OemToAnsi("PREVISÃO DOS PRÓXIMOS 6 MESES")		
			@Prow()+1, 000 psay __PrtThinLine()
			
			@Prow()+1, 001 psay "Semana: ----->"
	 		@Prow()  , 030 psay fCalcSem(ZAO->ZAO_DTINI)    PICTURE("@E 9999999999")
			@Prow()  , 045 psay fCalcSem(ZAO->ZAO_DTINI+7)  PICTURE("@E 9999999999")
			@Prow()  , 060 psay fCalcSem(ZAO->ZAO_DTINI+14) PICTURE("@E 9999999999")
			@Prow()  , 075 psay fCalcSem(ZAO->ZAO_DTINI+21) PICTURE("@E 9999999999")
			@Prow()  , 090 psay fCalcSem(ZAO->ZAO_DTINI+28) PICTURE("@E 9999999999")
			@Prow()  , 105 psay fCalcSem(ZAO->ZAO_DTINI+35) PICTURE("@E 9999999999")
			
			@Prow()  , 130 Psay Mesextenso(CtoD("01/"+StrZero(Month(ZAO->ZAO_DTFIM)+1,2)+"/"+StrZero(Year(ZAO->ZAO_DTFIM),4))) 		
			@Prow()  , 145 Psay Mesextenso(CtoD("01/"+StrZero(Month(ZAO->ZAO_DTFIM)+2,2)+"/"+StrZero(Year(ZAO->ZAO_DTFIM),4)))		
			@Prow()  , 160 Psay Mesextenso(CtoD("01/"+StrZero(Month(ZAO->ZAO_DTFIM)+3,2)+"/"+StrZero(Year(ZAO->ZAO_DTFIM),4)))		
			@Prow()  , 175 Psay Mesextenso(CtoD("01/"+StrZero(Month(ZAO->ZAO_DTFIM)+4,2)+"/"+StrZero(Year(ZAO->ZAO_DTFIM),4)))		
			@Prow()  , 190 Psay Mesextenso(CtoD("01/"+StrZero(Month(ZAO->ZAO_DTFIM)+5,2)+"/"+StrZero(Year(ZAO->ZAO_DTFIM),4)))		
			@Prow()  , 205 Psay Mesextenso(CtoD("01/"+StrZero(Month(ZAO->ZAO_DTFIM)+6,2)+"/"+StrZero(Year(ZAO->ZAO_DTFIM),4)))		
	
			@Prow()+1, 025 psay Repli("_",200)
	
			@Prow()+1, 001 psay "Release:----->"
	        
			_aPrev := {ZAP->ZAP_PREV01,ZAP->ZAP_PREV02,ZAP->ZAP_PREV03,ZAP->ZAP_PREV04,ZAP->ZAP_PREV05,;
						 ZAP->ZAP_PREV06,ZAP->ZAP_PREV07,ZAP->ZAP_PREV08,ZAP->ZAP_PREV09,ZAP->ZAP_PREV10,;
			  			 ZAP->ZAP_PREV11,ZAP->ZAP_PREV12,ZAP->ZAP_PREV13,ZAP->ZAP_PREV14,ZAP->ZAP_PREV15,;
						 ZAP->ZAP_PREV16,ZAP->ZAP_PREV17,ZAP->ZAP_PREV18,ZAP->ZAP_PREV19,ZAP->ZAP_PREV20,;
						 ZAP->ZAP_PREV21,ZAP->ZAP_PREV22,ZAP->ZAP_PREV23,ZAP->ZAP_PREV24,ZAP->ZAP_PREV25,;
						 ZAP->ZAP_PREV26,ZAP->ZAP_PREV27,ZAP->ZAP_PREV28,ZAP->ZAP_PREV29,ZAP->ZAP_PREV30,ZAP->ZAP_PREV31}
	
	    	_dData := ZAO->ZAO_DTINI
	
			While _dData <= ZAO->ZAO_DTFIM //percorre o mes inteiro
			
				//**se for domingo e nao for o primeiro dia do mes incrementa uma semana (coluna) e soma a previsao**//
				If Dow(_dData) == 1 .And. _dData<>ZAO->ZAO_DTFIM
					_nCol++
					_aSPrev[_nCol] += _aPrev[_x]
					_aSEntr[_nCol] += fEntr(_dData)
				Else 
					_aSPrev[_nCol] += _aPrev[_x]
					_aSEntr[_nCol] += fEntr(_dData)
				EndIf                                                                                                 	
				_X++ 
				_dData++
			EndDo 
			
	//		_aSPrev[_nCol] += _aPrev[_x] //ADICIONA O ÚLTIMO DIA DO MES NA ÚLTIMA SEMANA
	//		_aSEntr[_nCol] += fEntr(_dData)	//adiciona a última entrada do mês na última semana do mês
	
			_X := 1
			_nCol := 1
			_dData := ZAO->ZAO_DTINI
	
			@Prow()  , 030 psay _aSPrev[1] PICTURE("@E 9999999999")// prev Semana1
			@Prow()  , 045 psay _aSPrev[2] PICTURE("@E 9999999999")// prev Semana2
			@Prow()  , 060 psay _aSPrev[3] PICTURE("@E 9999999999")// prev Semana3
			@Prow()  , 075 psay _aSPrev[4] PICTURE("@E 9999999999")// prev Semana4
			@Prow()  , 090 psay _aSPrev[5] PICTURE("@E 9999999999")// prev Semana5
			@Prow()  , 105 psay _aSPrev[6] PICTURE("@E 9999999999")// prev Semana6
			
			@Prow()  , 125 psay ZAP->ZAP_PREVM1 PICTURE("@E 9999999999")// prev MES1
			@Prow()  , 140 psay ZAP->ZAP_PREVM2 PICTURE("@E 9999999999")// prev MES2
			@Prow()  , 155 psay ZAP->ZAP_PREVM3 PICTURE("@E 9999999999")// prev MES3
			@Prow()  , 170 psay ZAP->ZAP_PREVM4 PICTURE("@E 9999999999")// prev MES4
			@Prow()  , 185 psay ZAP->ZAP_PREVM5 PICTURE("@E 9999999999")// prev MES5
			@Prow()  , 200 psay ZAP->ZAP_PREVM6 PICTURE("@E 9999999999")// prev MES6
	
			@Prow()+1, 001 psay "Entregue:---->"
			@Prow()  , 030 psay _aSEntr[1] PICTURE("@E 9999999999")// entregue Semana1
			@Prow()  , 045 psay _aSEntr[2] PICTURE("@E 9999999999")// entregue Semana2
			@Prow()  , 060 psay _aSEntr[3] PICTURE("@E 9999999999")// entregue Semana3
			@Prow()  , 075 psay _aSEntr[4] PICTURE("@E 9999999999")// entregue Semana4
			@Prow()  , 090 psay _aSEntr[5] PICTURE("@E 9999999999")// entregue Semana5
			@Prow()  , 105 psay _aSEntr[6] PICTURE("@E 9999999999")// entregue Semana6
	
//			_nTotalR := 0
//			_nTotalE := 0
			
			For x := 1 to 6
				_nTotalR += _aSPrev[x]
				_nTotalE += _aSEntr[x]
			Next
			
//			_nTotPerf += (_nTotalR / _nTotalE)
			
			@ Prow()+1,000 PSAY __PrtThinLine()
	
			_aSPrev := {0,0,0,0,0,0}
			_aSEntr := {0,0,0,0,0,0}
			
		EndIf
		ITM->(DBSKIP())
		ZAP->(DBSKIP())		
	EndDo

@ Prow()+2,000 PSAY __PrtThinLine()
@ Prow()+1,001 Psay "Performance Geral: " + Transform(((_nTotalE*100)/_nTotalR) ,"@e 9999")+"%"


Return

//*****************************************************//
//													   //
// Funcao que traz o número da semana dentro do ano    //
// usando a data como parametro             		   //
//													   //
//*****************************************************//

Static Function fCalcSem(_dDt)
Local _nSem := 1
Local _dData := CtoD("01/01/"+Strzero(Year(Date()),4))

	While _dData < _dDt
		If DoW(_dData) == 1 .And. _dData<>CtoD("01/01/"+Strzero(Year(Date()),4))
			_nSem ++
		EndIf
		_dData++
	EndDo

Return(_nSem)

//*****************************************************//
//													   //
// Funcao que traz a quantidade  de  pecas  que  foram //
// entregues E acumula o total de pecas entregues,     //
// usando a data da entrega como parametro             //
//													   //
//*****************************************************//

Static Function fEntr(_dData)
Local _dData
Local cQuery
Local _nQuant := 0
	
	If Select("TMR") > 0 
		TMR->(DbCloseArea())
	EndIf
	
	cQuery := " SELECT D2.D2_DOC, SUM(D2_QUANT) AS QUANT "//FROM "+RetSqlName("SD2")+" D2 "
	cQuery += " FROM "+RetSqlName("SD2")+" D2, "+RetSqlName("SF2")+" F2 "
	cQuery += " WHERE F2.F2_DOC = D2.D2_DOC "
	cQuery += " AND F2.F2_SERIE = D2.D2_SERIE "
	cQuery += " AND F2.F2_CLIENTE = D2.D2_CLIENTE "
	cQuery += " AND F2.F2_LOJA = D2.D2_LOJA "
	cQuery += " AND D2.D2_CLIENTE = '"+ZAO->ZAO_CLIENT+"'"
	cQuery += " AND D2.D2_LOJA = '"+_cLoja+"'"
	cQuery += " AND D2.D2_COD = '"+ZAP->ZAP_PROD+"'"
	
	If !Empty(ALLTRIM(ZAP->ZAP_PEDCLI))
		cQuery += " AND F2.F2_PCCLI = '"+ZAP->ZAP_PEDCLI+"'"
	EndIf
	
	cQuery += " AND D2.D2_EMISSAO = '"+DTOS(_dData)+"'"
	cQuery += " AND D2.D2_FILIAL = '"+xFilial("SD2")+"'"
	cQuery += " AND D2.D_E_L_E_T_ = ''"
	cQuery += " AND F2.D_E_L_E_T_ = ''"
	cQuery += "	GROUP BY D2.D2_DOC "

	TCQUERY cQuery NEW ALIAS "TMR"
	  
	TMR->(DBGOTOP())
	
	WHILE TMR->(!EOF())
		
		_nQuant += TMR->QUANT
        
    	IF SM0->M0_CODIGO == "FN"  //empresa fundicao
    		
			IF !(_cClie$"900004" .AND. _cLoja$"02") .AND. ;
			   !(_cClie$"900003" .AND. _cLoja$"02") .AND. ;
			   !(_cClie$"900025" .AND. _cLoja$"02") .AND. ;
			   !(_cClie$"900022" .AND. _cLoja$"01") .AND. ;
			   !(_cClie$"000012" .AND. (_cLoja$"02" .OR. _cLoja$"03"))
			
				IF Select("TMT") > 0
					TMT->(DbCloseArea("TMT"))
				ENDIF

				//VERIFICA O QUE HOUVE DE DEVOLUÇÃO DO PRODUTO	
				cQuery2 := " SELECT SUM(D1_QUANT) AS QUANT FROM "+RetSqlName("SD1")+" D1 "
				cQuery2 += " WHERE D1.D1_TIPO = 'D' "//DEVOLUCAO 
				cQuery2 += " AND D1.D1_FORMUL = 'S' "// ENTRADA COM A PRÓPRIA NOTA
				cQuery2 += " AND D1.D1_FORNECE = '"+_cClie+"'"
				cQuery2 += " AND D1.D1_LOJA = '"+_cLoja+"'"
				cQuery2 += " AND D1.D1_COD = '"+ZAP->ZAP_PROD+"'"
				cQuery2 += " AND D1.D1_NFORI = '"+TMR->D2_DOC+"'"
				cQuery2 += " AND D1.D1_FILIAL = '"+xFilial("SD1")+"'"
				cQuery2 += " AND D1.D_E_L_E_T_ = ' '"
			
				TCQUERY cQuery2 NEW ALIAS "TMT"
		
				If !Empty(TMT->QUANT)
					_nQuant -= TMT->QUANT
				EndIf	
				
	        ENDIF
		ENDIF		
	
		TMR->(DBSKIP())
	ENDDO

Return(_nQuant)

//*****************************************************//
//													   //
// Funcao que traz a quantidade  de  pecas  que  foram //
// entregues E acumula o total de pecas entregues,     //
// usando a data da entrega como parametro             //
//													   //
//*****************************************************//

Static Function fEntr2(_dData)
Local _dData
Local cQuery
Local _nQuant := 0
	
	If Select("TMR") > 0 
		TMR->(DbCloseArea())
	EndIf
	
	cQuery := " SELECT ZN_DOC,SUM(ZN_QUANT) AS QUANT "//FROM "+RetSqlName("SD2")+" D2 "
	cQuery += " FROM "+RetSqlName("SZN")+" (NOLOCK), "+RetSqlName("SZM")
	cQuery += " (NOLOCK) WHERE ZN_COD = '"+ZAP->ZAP_PROD+"'"
	cQuery += " AND ZN_DOC = ZM_DOC "
	cQuery += " AND ZM_DATAEXP = '"+DTOS(_dData)+"'"	
	cQuery += " AND ZM_CLIENTE = '"+ZAO->ZAO_CLIENT+"'"
	cQuery += " AND ZM_LOJA = '"+_cLoja+"'"	
	cQuery += " AND SZNFN0.D_E_L_E_T_ = '' "
	cQuery += " AND SZMFN0.D_E_L_E_T_ = '' "
	cQuery += " AND ZN_FILIAL = '"+xFilial("SZN")+"'"
	cQuery += " AND ZN_FILIAL = ZM_FILIAL "
	cQuery += " GROUP BY ZN_DOC "	

	TCQUERY cQuery NEW ALIAS "TMR"
	  
	TMR->(DBGOTOP())
	
	WHILE TMR->(!EOF())
		
		_nQuant += TMR->QUANT        
	
		TMR->(DBSKIP())
	ENDDO

Return(_nQuant)


//***********************************************************//
//													         //
//	FUNCAO QUE RETORNA O NÚMERO DA ÚLTIMA NF PARA O PRODUTO  //
//													         //
//***********************************************************//

Static Function fNota(_cProd)
Local _cNF
Local cQuery
                         
	If Select("TMS") > 0 
	TMS->(DbCloseArea())
EndIf

cQuery := "SELECT TOP 1 D2.D2_DOC FROM "+RETSQLNAME("SD2")+" D2"
cQuery += " WHERE D2.D2_COD = '"+AllTrim(_cProd)+"'"
cQuery += " AND D2.D_E_L_E_T_ = ' '"
cQuery += " AND D2.D2_FILIAL = '"+xFilial("SD2")+"'"
cQuery += " ORDER BY R_E_C_N_O_ DESC"

TCQUERY cQuery NEW ALIAS "TMS"

_cNF := TMS->D2_DOC

Return(_cNF)


//*****************************************************//
//													   //
//	FUNCAO PARA IMPRESSÃO DO CABEÇALHO DOS RELEASES    //
//													   //
//*****************************************************//


Static Function ImpCabec()

	@Prow()+1, 001 psay "RI-WHB: "+ZAO->ZAO_NUM

	IF SM0->M0_CODIGO == "NH"  //empresa USINAGEM
		@Prow()  , 035 psay "WHB COMPONENTES AUTOMOTIVOS S\A"
	ElseIf SM0->M0_CODIGO == "FN"  //empresa FUNDICAO
		@Prow()  , 035 psay "WHB FUNDICAO S\A"       
	ElseIf SM0->M0_CODIGO == "IT"  //empresa ITESAPAR
		@Prow()  , 035 psay "ITESAPAR S\A"
	EndIf

	QAA->(DBSETORDER(6))//LOGIN
	IF QAA->(DBSEEK(CUSERNAME))
		@Prow()  ,  075 psay "Enviado Por: "+QAA->QAA_NOME // NOME DO CRIADOR DO RELEASE
	EndIf

	@Prow()+1, 001 psay "Release nº: "+ZAO->ZAO_RELCLI	
	@Prow()  , 035 psay "Data Receb.: "+DTOC(ZAO->ZAO_DTREL)
	@Prow()	 , 065 psay "Cliente: "+ZAO->ZAO_CLIENT+" - "+ZAO->ZAO_LOJA
	SA1->(DBSETORDER(1))//FILIAL + COD + LOJA
	IF SA1->(DBSEEK(XFILIAL("SA1")+ZAO->(ZAO_CLIENT+ZAO_LOJA)))
		@Prow()	 , 088 psay SA1->A1_NOME
		@Prow()+1, 001 psay "Contato: "+SA1->A1_CONTATO
		@Prow()	 , 040 psay "Telefone: "+SA1->A1_TEL
		@Prow()	 , 100 psay "E-mail: "+SA1->A1_EMAIL 

	EndIf
	@Prow()+1, 001 psay "Obs. Geral: "+ZAO->ZAO_OBSGER

Return

//*****************************************************//
//													   //
//	FUNCAO PARA INSERÇÃO DE OBSERVAÇÕES NO RELEASE     //
//													   //
//*****************************************************//

Static Function fObs()
Private _aDia  := {""}
Private _cDia  := StrZero(oMultiline:OBrowse:ColPos - 4,2) //retorna a coluna em que o cursor está focando
Private _cObs  := sPACE(100)
Private _cPrdt := ACOLS[N][aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZAP_PROD"})]

  	oFont16 := TFont():New("Arial",,16,,.T.)                  
	
	//Só trás a tela de observação quando o cursor estiver sobre um campo de dia 
	If oMultiline:OBrowse:ColPos > 4 .And. oMultiline:OBrowse:ColPos <= 35
		ZAR->(DbSetOrder(1)) //filial + numrel + produto + dia
		ZAR->(DbSeek(xFilial("ZAR")+_cCod+_cPrdt+_cDia))
		If ZAR->(Found())
			_cObs := ZAR->ZAR_OBSERV
		Else
			_cObs := Space(100)
		EndIf
	Else
		Alert("Posicione o cursor sobre um campo de Dia do Release.")	
		Return
    EndIf

	Define MsDialog oDialog2 Title OemToAnsi("Observacao") From 000,000 To 170,245 Pixel 

	@ 010,005 Say aHeader[oMultiline:OBrowse:ColPos][1] Size 040,8 Object olDia	
	olDia:Setfont(oFont16)		

	@ 025,005 Say "Obs: " Size 040,8 Object olObs
	@ 025,020 Get ocObs Var _cObs MEMO Size 100,40 pixel of oDialog2

	@ 070,060 BMPBUTTON TYPE 01 ACTION fGrvObs()
	@ 070,092 BMPBUTTON TYPE 02 ACTION Close(oDialog2)

	Activate MsDialog oDialog2 Center
		
Return

//*****************************************************//
//													   //
//	FUNCAO PARA GRAVAÇÃO DAS OBSERVAÇÕES DO RELEASE    //
//													   //
//*****************************************************//

Static Function fGrvObs()
                        
	If _cParam == 3//alterar
		ZAR->(DbSetOrder(1)) //filial + numrel + Produto + dia
		ZAR->(DbSeek(xFilial("ZAR")+_cCod+_cPrdt+_cDia))
	
		If ZAR->(!Found()) //inserção
			RecLock("ZAR",.T.)
				ZAR->ZAR_FILIAL := xFilial("ZAR")
				ZAR->ZAR_PROD   := _cPrdt			
				ZAR->ZAR_NUMREL := _cCod
				ZAR->ZAR_DIA	:= _cDia
				ZAR->ZAR_OBSERV := Substr(_cObs,1,100)
			MsUnlock("ZAR")
		Else //alteracao
			RecLock("ZAR",.F.)
				ZAR->ZAR_OBSERV := Substr(_cObs,1,100)
			MsUnlock("ZAR")
		
		EndIf
	EndIf
	Close(oDialog2)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ATUALIZA O CAMPO TOTAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function PCP13TOT(_nMem)
Local _nTotal := 0
Local _cField  

	For _x:= 6 to 36
		IF(_x != _nMem+4)
			_nTotal += aCols[n][_x]
		EndIf
	Next
	_cField := "M->ZAP_PREV"+STRZERO(_nMem,2)
	_nTotal += &(_cField)
	
	aCols[n][37] := _nTotal
	oMultiline:Refresh()
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CARREGA OS ITENS DO ULTIMO RELEASE PARA O MESMO CLIENTE + LOJA (FEITO DIA 10/06/2009 - JOAOFR)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCarreg()
Local cQuery
Local nZAORec := ZAO->(Recno())
Local nItem

	//verifica se foi digitado o fornecedor e a loja
	If Empty(_cClie)
		Alert("Digite o cliente!")
		Return
	EndIf
	
	If Empty(_cLoja)
		Alert("Digite a Loja!")
		Return
	EndIf
	
	//Localiza o último release deste fornecedor e loja	
	ZAO->(DbSetOrder(2)) //ZAO_FILIAL+ZAO_CLIENT+ZAO_LOJA+DTOS(ZAO_DTINI)
	ZAO->(DbSeek(xFilial("ZAO")+_cClie+_cLoja))
	While ZAO->(!EOF()) .AND. ZAO->ZAO_CLIENT==_cClie .AND. ZAO->ZAO_LOJA == _cLoja
	    nZAORec := ZAO->(RecNo())
		ZAO->(DBSKIP())
	EndDo
	
	//Posiciona a tabela ZAO no registro do último release deste fornecedor e loja
	ZAO->(DbGoTo(nZAORec))
	                    
	ZAP->(DbSetOrder(1)) //ZAP_FILIAL+ZAP_NUM+ZAP_ITEM 
	ZAP->(DbSeek(xFilial("ZAP")+ZAO->ZAO_NUM))
	    
	SB1->(DbSetOrder(1)) // filial + cod
	
	nItem := 0      
	aCols := {}
	
	WHILE ZAP->(!EOF()) .AND. ZAP->ZAP_NUM == ZAO->ZAO_NUM
		
		nItem++

		fCalcDif()
		
		SB1->(DbSeek(xFilial("SB1")+ZAP->ZAP_PROD))
		
  	    aAdd(Acols,{StrZero(nItem,4),; //item   
   					ZAP->ZAP_PROD,;    //prod
					SB1->B1_DESC,;     //desc
  	    			_nDif,;            //diferenca
  	    			0,;
  	    			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,; //31 zeros
  	    			0,;//total
    				0,0,0,0,0,0,;
    				ZAP->ZAP_PEDCLI,.F.}) //6 MESES + .F.

		ZAP->(DBSKIP())

	ENDDO
	
	oMultiline:Refresh()

Return