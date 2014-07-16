#Include "Protheus.Ch"
#include "rwmake.ch"
#include "topconn.ch" 
#include "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHMNT037  ºAutor  ³João Felipe da Rosa º Data ³  07/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ SOLICITAÇÃO DE MOVIMENTAÇÃO DE BENS                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHMNT037()

Private cAlias    := "ZB3"
Private aRotina   := {}
Private cCadastro := OemToAnsi("Solicitação de Movimentação de Bens")
Private aButtons  := {}
Private aIndST9   := {}
Private condST9   := 'ST9->T9_FILIAL = Xfilial("ST9") .And. ST9->T9_MOVIBEM = "S"'

aAdd( aRotina, {"Pesquisar" ,"AxPesqui"    ,0,1} )
aAdd( aRotina, {"Visualizar","U_fMNT37(2)" ,0,2} )
aAdd( aRotina, {"Incluir"   ,"U_fMNT37(3)" ,0,3} )
aAdd( aRotina, {"Alterar"   ,"U_fMNT37(4)" ,0,4} )
aAdd( aRotina, {"Excluir"   ,"U_fMNT37(5)" ,0,5} ) 
//aAdd( aRotina, {"Movimentar","U_MNT37MOV()"     ,0,1} )

//Fontes
DEFINE FONT oFont NAME "Arial" SIZE 12, -12

dbSelectArea(cAlias)
dbSetOrder(1)

mBrowse(,,,,cAlias,,,,,,fCriaCor())

Return Nil 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SOLICITACAO DE MOVIMENTAÇÕES ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function fMNT37(_cParam)

SetPrvt("_cNum,_cCCDesc,_cMatSolic,_cNome,_CCCORI")
SetPrvt("_dDtLim,_cMotivo,_aOpcoes,_nPos")

Private aIndTPN    := {}
Private bFiltraBrw := {|| Nil}

_cPar      := _cParam
_cMatSolic := Space(6) //matricula do solicitante
_dData     := Date()
_cMotivo   := Space(40)
_dDtLim    := CtoD("  /  /  ")  
_cCCOri    := Space(6)
aCols      := {}
aHeader    := {}
_aOpcoes   := {"Maq. Retirada do local","Maq. Rotacionada no Local","Mudança de Centro de Custo/Linha"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA O AHEADER ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aHeader,{"Item"           , "ZB4_ITEM"  ,  "@!" 		 ,04,0 ,".F.","","C","ZB4"}) //01
aAdd(aHeader,{"Bem  "          , "ZB4_CODBEM",  "@!"		 ,15,0 ,"U_fMNT037A()","","C","ZB4"}) //02
aAdd(aHeader,{"Nome"           , "T9_NOME"   ,  "@!" 		 ,40,0 ,".F.","","C","ST9"}) //03
aAdd(aHeader,{"CC. Origem"     , "ZB4_CCORIG",  "@!" 		 ,06,0 ,".F.","","C","ZB4"}) //04
aAdd(aHeader,{"CC. Destino"    , "ZB4_CCDEST",  "@!"  		 ,06,0 ,"U_fMNT037B()","","C","ZB4"}) //05
aAdd(aHeader,{"Pos. X Origem"  , "ZB4_POSXOR",  "@E 999.99"  ,06,0 ,".F.","","N","ZB4"}) //06
aAdd(aHeader,{"Pos. Y Origem"  , "ZB4_POSYOR",  "@E 999.99"  ,06,0 ,".F.","","N","ZB4"}) //07
aAdd(aHeader,{"Pos. X Destino" , "ZB4_POSXDE",  "@E 999.99"  ,06,0 ,".T.","","N","ZB4"}) //08
aAdd(aHeader,{"Pos. Y Destino" , "ZB4_POSYDE",  "@E 999.99"  ,06,0 ,".T.","","N","ZB4"}) //09
aAdd(aHeader,{"Ordem"          , "ZB4_ORDEM" ,  "@!"  	     ,06,0 ,".F.","","C","ZB4"}) //10

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ IMPEDE EDICAO NO ACOLS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _cPar == 2 .OR. _cPar == 5 //visualiza e exclui
	For _x := 1 to len(aHeader)
		aHeader[_x][6] := ".F."
	Next
EndIf

If _cPar == 3 //incluir
	_cNum := GetSxENum("ZB3","ZB3_NUM")
EndIf

//visualizar, alterar ou excluir
If _cPar == 2 .OR. _cPar == 4 .OR. _cPar == 5 
	_cNum      := ZB3->ZB3_NUM
	_dData     := ZB3->ZB3_DATA
	_cMatSolic := ZB3->ZB3_MATSOL 
	_nPos      := ZB3->ZB3_ACAO

   	SRA->(DbSetOrder(1)) //filial + mat
	IF SRA->(DbSeek(xFilial('SRA')+_cMatSolic))
		_cNome := SRA->RA_NOME	
	EndIf

	_dDtLim    := ZB3->ZB3_DTLIM
	_cMotivo   := ZB3->ZB3_MOTIVO
	                                   
	ZB4->(DbSetOrder(1))//filial + num + item
	If ZB4->(DbSeek(xFilial("ZB4")+_cNum))
		ST9->(DBSETORDER(1))
		While ZB4->(!EOF()) .AND. ZB4->ZB4_NUM == _cNum
			ST9->(DBSEEK(XFILIAL('ST9')+ZB4->ZB4_CODBEM))
			aAdd(aCols,{ZB4->ZB4_ITEM,;	
						ZB4->ZB4_CODBEM,;
						ST9->T9_NOME,;
						ZB4->ZB4_CCORIG,;
						ZB4->ZB4_CCDEST,;
						ZB4->ZB4_POSXOR,;
						ZB4->ZB4_POSYOR,;
						ZB4->ZB4_POSXDE,;
						ZB4->ZB4_POSYDE,;
						ZB4->ZB4_ORDEM,;
						.F.})
			ZB4->(DBSKIP())
		ENDDO
	ENDIF
		
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Constrói a tela do CADASTRO DE ATIVIDADES ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg1 TITLE "Solicitação de Movimentação de Bem" FROM 0,0 TO 430,595 PIXEL

@ 005,010 TO 195,290 LABEL "Dados da Solicitação" OF oDlg1 PIXEL

@ 020,015 SAY "Num. Solicitação: " Size 060,008 Object olNum
@ 020,065 SAY _cNum Size 040,008 Object oNum
oNum:Setfont(oFont)

@ 020,225 SAY "Data: " Size 040,008 Object olData
@ 020,245 GET _dData Picture "99/99/99" When .F. Size 040,008 Object oData
/*
@ 035,015 SAY "C.Custo Origem: " Size 040,008 Object olCCOri
@ 035,052 GET _cCCOri  Picture "@!" F3 "CTT" Size 065,008 Object oCCOri Valid fCCOri()
@ 035,120 GET _cCCDesc Picture "@!"  When .F. Size 140,008 Object oCCDesc
*/
@ 035,015 SAY "Responsável: " Size 040,008 Object olResp
@ 035,055 GET _cMatSolic Picture "@!" F3 "SRA" When(_cPar==3 .Or. _cPar==4) Size 040,008 Object oMat Valid fMat()
@ 035,100 GET _cNome Picture "@!"  When .F. Size 140,008 Object oNome

@ 050,020 RADIO _aOpcoes VAR _nPos

@ 085,015 SAY "Data Limite: " Size 040,008 Object olDtLim
@ 085,055 GET _dDtLim Picture "99/99/99" When(_cPar==3 .Or. _cPar==4) Size 040,008 Object oDtLim

@ 085,110 SAY "Motivo: " Size 040,008 Object olObs
@ 085,145 GET _cMotivo Picture "@!" When(_cPar==3 .Or. _cPar==4) Size 140,008 Object oObs

@ 100,010 TO 195,290 MULTILINE MODIFY DELETE OBJECT oMultiline

If _cPar != 3 .and. _cPar != 4 
	oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline
EndIf

If _cPar == 4 //alterar
	If ALLTRIM(Upper(CUSERNAME))$"CLAUDIOSA/VILSONJ/JOAOFR/ADMINISTRADOR/ALTEVIRMS"
		@ 200,165 BUTTON "_Movimentar" SIZE 30,11 ACTION MNT37MOV()
		@ 200,200 BUTTON "_Gerar OS" SIZE 30,11 ACTION geraOrdem(aCols[n])
	EndIf
EndIf

@ 200,235 BMPBUTTON TYPE 1 ACTION fOk()
@ 200,265 BMPBUTTON TYPE 2 ACTION fEnd()

ACTIVATE MSDIALOG oDlg1 CENTER

Return Nil  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CONFIRMA SOLICITACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fOk()

	If _cPar == 3 // incluir
		fIncAlt(.T.)
	ElseIf _cPar == 4 //alterar
		fIncAlt(.F.)
	ElseIf _cPar == 5 //excluir
		fExcl()
	EndIf		

    Close(oDlg1)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ INCLUIR OU ALTERAR UMA SOLICITACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fIncAlt(_lP)
_cStatus := "O"
_nOrd    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB4_ORDEM"})

	For _x := 1 to Len(aCols)
		If empty(aCols[_x][_nOrd])
			_cStatus := "P"
		EndIf	
	Next
	
	RecLock("ZB3",_lP)
		ZB3->ZB3_FILIAL := xFilial("ZB3")
		ZB3->ZB3_NUM    := _cNum
		ZB3->ZB3_MATSOL := _cMatSolic
		ZB3->ZB3_ACAO   := _nPos
		ZB3->ZB3_DATA   := _dData
		ZB3->ZB3_STATUS := _cStatus
		ZB3->ZB3_DTLIM  := _dDtLim
		ZB3->ZB3_MOTIVO := _cMotivo
	MsUnlock("ZB3")
	
	ZB4->(DbSetOrder(1)) //Filial + num + item
	
	For _x := 1 to Len(aCols)
		If !Acols[_x][len(aHeader)+1] //nao pega quando a linha esta deletada
			If !_lP .AND. ZB4->(DbSeek(xFilial("ZB4")+_cNum+aCols[_x][1]))
                If ZB4->ZB4_STATUS == "E"
					Alert("O ítem "+Acols[_x][1]+" não pode ser alterado pois já está finalizado!")                
				Else                
                
	                RecLock("ZB4",.F.)
	    	        	ZB4->ZB4_CODBEM := aCols[_x][2] //CODBEM
	    	        	ZB4->ZB4_CCORIG := aCols[_x][4] //CC ORIGEM
	    	        	ZB4->ZB4_CCDEST := aCols[_x][5] //CC DESTINO
	    	        	ZB4->ZB4_POSXOR := aCols[_x][6] //POS X ORIGEM
	    	        	ZB4->ZB4_POSYOR := aCols[_x][7] //POS Y ORIGEM
	    	        	ZB4->ZB4_POSXDE := aCols[_x][8] //POS X DESTINO
	    	        	ZB4->ZB4_POSYDE := aCols[_x][9] //POS Y DESTINO
	    	        	ZB4->ZB4_ORDEM  := aCols[_x][10] //ORDEM
	        	    MsUnlock("ZB4")	    

	   			EndIf
			Else

                RecLock("ZB4",.T.)

	               	ZB4->ZB4_FILIAL := xFilial("ZB4")
    	        	ZB4->ZB4_NUM    := _cNum
    	        	ZB4->ZB4_ITEM   := aCols[_x][1] //ITEM
    	        	ZB4->ZB4_CODBEM := aCols[_x][2] //CODBEM
    	        	ZB4->ZB4_CCORIG := aCols[_x][4] //CC ORIGEM
    	        	ZB4->ZB4_CCDEST := aCols[_x][5] //CC DESTINO
    	        	ZB4->ZB4_POSXOR := aCols[_x][6] //POS X ORIGEM
    	        	ZB4->ZB4_POSYOR := aCols[_x][7] //POS Y ORIGEM
    	        	ZB4->ZB4_POSXDE := aCols[_x][8] //POS X DESTINO
    	        	ZB4->ZB4_POSYDE := aCols[_x][9] //POS Y DESTINO
    	        	ZB4->ZB4_ORDEM  := aCols[_x][10] //ORDEM
    	        	ZB4->ZB4_STATUS := "P"
    	        	
        	    MsUnlock("ZB4")
 
            EndIf
        Else
			If !_lP .AND. ZB4->(DbSeek(xFilial("ZB4")+_cNum+aCols[_x][1]))
	        	If !empty(aCols[_x][_nOrd])
	        		Alert("O ítem "+aCols[_x][1]+" não foi excluído pois já existe O.S. para este ítem!")
	        	Else
		        	RecLock("ZB4")    
		        		ZB4->(DbDelete())
		   			MsUnlock("ZB4")
		  		EndIf
		 	EndIf
   		EndIf
	Next
        
	If _lP
		fEmailMov()
	EndIf
	
    ConfirmSX8()

Return

//ÚÄÄÄÄÄÄÄÄÄÄ¿
//³ EXCLUSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÙ
Static Function fExcl()
	
	ZB4->(DbSetOrder(1))//filial + num + item
	If ZB4->(DbSeek(xFilial("ZB4")+_cNum))
		While ZB4->(!EOF()) .AND. ZB4->ZB4_NUM == _cNum
            If !EMPTY(ZB4->ZB4_ORDEM)

				Alert("Solicitação não pode ser excluída pois já existe Ordem de Serviço!")
				Return

			EndIf
			ZB4->(DBSKIP())		
		ENDDO
	ENDIF

	RecLock("ZB3")
		ZB3->(DbDelete())
	MsUnLock("ZB3")

	ZB4->(DbSetOrder(1))//filial + num + item
	If ZB4->(DbSeek(xFilial("ZB4")+_cNum))
		While ZB4->(!EOF()) .AND. ZB4->ZB4_NUM == _cNum
            RecLock("ZB4")
	            ZB4->(DbDelete())
	 		MsUnlock("ZB4")
			ZB4->(DBSKIP())		
		ENDDO
	ENDIF

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CANCELA A SOLICITACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fEnd()	
_nOrd    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB4_ORDEM"})

	ZB4->(DbSetOrder(1)) // filial + num + item
    For _x:=1 to Len(aCols)
		If !empty(aCols[_x][_nOrd])
			ZB4->(DbSeek(xFilial("ZB4")+_cNum+aCols[_x][1]))
		    If ZB4->(!Found())
		    	Alert("Foram geradas Ordens para ítens não confirmados! Favor confirmar solicitação")
		    	Return .F.
		    EndIf
		EndIf    
    Next
    Close(oDlg1)
	RollBackSX8()
	
Return   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CENTRO DE CUSTO E TRAZ A DESCRICAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCCOri()

	CTT->(DbSetOrder(1)) //FILIAL + CC
	If CTT->(DbSeek(xFilial("CTT")+_cCCOri))
		_cCCDesc := CTT->CTT_DESC01
		oCCDesc:Refresh()
	Else
		Alert("C.Custo não existe!")
		Return .F.
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O USUÁRIO E TRAZ O NOME  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fMat()

   	SRA->(DbSetOrder(1)) //filial + mat
	IF SRA->(DbSeek(xFilial('SRA')+_cMatSolic))
		_cNome := SRA->RA_NOME
		oNome:Refresh()
	Else
		Alert("Matrícula não existente!")
		Return .F.
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDE CENTRO DE CUSTO DE DESTINO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCCDes()

	CTT->(DbSetOrder(1))
	CTT->(DbSeek(xFilial("CTT")+_cCCDes))
	If CTT->(!Found())
		Alert("Centro de Custo não existe!")
		Return .F.
	EndIf

	If _cCCDes == _cCCOri
		Alert("Centro de Custo de Destino não pode ser igual ao Centro de Custo de Destino!")
		Return .F.
	EndIf
	
	If Len(Alltrim(_cCCDes)) != 6
		Alert("Centro de Custo de Destino deve ter 6 dígitos")
		Return .F.
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA CENTRO DE TRABALHO DE DESTINO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCTDes()

	SHB->(DbSetOrder(1))
	SHB->(DbSeek(xFilial("SHB")+_cCTDes))
	If SHB->(!Found())
		Alert("Centro de Trabalho não existe!")
		Return .F.
	EndIf	

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CHAMA A ROTINA DE MOVIMENTACAO DE BENS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function MNT37MOV()
Private _nBem   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB4_CODBEM"})
Private _nQd1   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB4_POSXDE"})
Private _nQd2   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB4_POSYDE"})
_nOrd   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB4_ORDEM"})

	ZB4->(DBSETORDER(1)) //FILIAL + NUM + ITEM
	ZB4->(DBSEEK(XFILIAL("ZB4")+ZB3->ZB3_NUM+ACOLS[N][1]))
	IF ZB4->(!FOUND())
		ALERT("Este item ainda nao foi gravado!")
		Return .F.
	EndIf
	
/*
	IF Empty(ACOLS[N][_nOrd])
		Alert("Não existe Ordem para este ítem!")
		Return .F.
	EndIf
*/
	
	If ZB4->ZB4_STATUS == "E"
		Alert("Este ítem já está encerrado!")
		Return .F.
	EndIf

	ST9->(DbSetOrder(1))
	ST9->(DbSeek(xFilial("ST9")+aCols[n][_nBem]))

	MNTA470M() 
	
	Close(oDlg1)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ OS DADOS DA SOLICITACAO ³
//³ NA HORA DA MOVIMENTACAO      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Chamada: VALID DO CAMPO TPN->TPN_SOLIC
User Function MNT37SOLIC()
	
	ZB4->(DBSETORDER(1))
	ZB4->(DbSeek(XFILIAL("ZB4")+M->TPN_SOLICI+ACOLS[N][1]))
	IF ZB4->(!FOUND())
		ALERT("Numero da solicitacao nao encontrado!")
		Return .F.
	EndIf
	              
	IF ALLTRIM(ZB4->ZB4_CODBEM) == ALLTRIM(M->TPN_CODBEM)
		M->TPN_ITEM   := ZB4->ZB4_ITEM
		M->TPN_CCUSTO := ZB4->ZB4_CCDEST
//		M->TPN_CTRAB  := ZB4->ZB4_FABDES
		M->TPN_DTINIC := date()
		M->TPN_HRINIC := time()
		M->TPN_OBSERV := ZB3->ZB3_MOTIVO
	ELSE 
		Alert("O Bem da Solicitação não é o igual ao Bem a ser movimentado!")
		Return .F.
	ENDIF 
	
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA A COR NO BROWSE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCriaCor()       

	Local aLegenda :=	{ {"BR_VERDE"    , "Pendente"  },;
	  					  {"BR_AMARELO"  , "OS's Geradas" },;
	  					  {"BR_VERMELHO" , "OS's Geradas/Encerradas" }}

	Local uRetorno := {}
	Aadd(uRetorno, { 'ZB3_STATUS == "P"' , aLegenda[1][1] } ) //SEM GERAR OS OU OSS PARCIALMENTE GERADAS
	Aadd(uRetorno, { 'ZB3_STATUS == "O"' , aLegenda[2][1] } ) //TODAS AS OSS GERADAS
	Aadd(uRetorno, { 'ZB3_STATUS == "E"' , aLegenda[3][1] } ) //OSS GERADAS E FINALIZADAS
	
Return(uRetorno)      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O BEM E TRAZ A POSX E POSY DE ORIGEM ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function fMNT037A()
_nPosX := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB4_POSXOR"})
_nPosY := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB4_POSYOR"})
_nCCOr := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB4_CCORIG"})
_nNome := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "T9_NOME"})		

	ST9->(DbSetOrder(1))
	If ST9->(DbSeek(xFilial("ST9")+M->ZB4_CODBEM))
		aCols[n][_nPosX] := ST9->T9_POSX
		aCols[n][_nPosY] := ST9->T9_POSY
		aCols[n][_nCCOr] := ST9->T9_CCUSTO
		aCols[n][_nNome] := ST9->T9_NOME
		oMultiline:Refresh()
	Else
		Alert("Bem não existe!")
		Return .F.
	EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O C.CUSTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function fMNT037B()
    CTT->(DBSETORDER(1)) //FILIAL + CC
    CTT->(DBSEEK(XFILIAL('CTT')+M->ZB4_CCDEST))
    If CTT->(!Found())
        Alert("Centro de Custo não existe!")
        Return .F.
    EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GERA ORDEM DE SERVICO PARA MOVIMENTAR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function geraOrdem(aOs)
_nBem   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB4_CODBEM"})
_nCCOri := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB4_CCORIG"})
_nCCDes := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB4_CCDEST"})
_nPosXO := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB4_POSXOR"})
_nPosYO := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB4_POSYOR"})
_nPosXD := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB4_POSXDE"})
_nPosYD := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB4_POSYDE"})
_nOrdem := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB4_ORDEM"})

_cMsg   := _cMotivo+" (REALIZAR A MUDANÇA DO BEM "+ALLTRIM(aOs[_nBem])+" DO CENTRO DE CUSTO "+;
		   aOs[_nCCOri]+", POS. X "+TRANSFORM(aOs[_nPosXO],"@e 999.99")+", POS. Y "+;
		   TRANSFORM(aOs[_nPosYO],"@e 999.99")+" PARA CENTRO DE CUSTO "+alltrim(aOs[_nCCDes])+;
		   " POS. X "+TRANSFORM(aOs[_nPosXD],"@e 999.99")+", POS. Y "+TRANSFORM(aOs[_nPosYD],"@e 999.99")+")"

ST9->(DbSetOrder(1)) //Filial + CodBem
ST9->(DbSeek(xFilial("ST9")+aOS[_nBem]))
If ST9->(!Found())
	Alert("Bem não encontrado!")
	Return .F.
EndIf

If !Empty(aOs[_nOrdem])
	Alert("Já existe OS para esta solicitação!")
	Return .F.
EndIf           

If empty(aOs[_nCCDes])
	Alert("C.Custo de Destino não informado!")
	Return .F.
EndIf

/*
If empty(aOs[_nPosXD])
	Alert("Posição X de Destino não informada!")
	Return .F.
EndIf

If empty(aOs[_nPosYD])
	Alert("Posição Y de Destino não informada!")
	Return .F.
EndIf
*/

RecLock("STJ",.T.)

STJ->TJ_FILIAL  := xFilial("STJ")
STJ->TJ_ORDEM   := GetSxENum("STJ","TJ_ORDEM") //Número da Ordem
STJ->TJ_PLANO   := "000000"                    //Corretiva
STJ->TJ_DTORIGI := Date()
STJ->TJ_CODBEM  := aOs[_nBem]
STJ->TJ_SERVICO := "000012"
STJ->TJ_SEQUENC := 0
STJ->TJ_TIPO    := "PRO"
STJ->TJ_CODAREA := "GERAL"
STJ->TJ_CCUSTO  := aOs[_nCCDes]
STJ->TJ_POSCONT := 0
STJ->TJ_HORACO1 := ":"
STJ->TJ_CUSTMDO := 0
STJ->TJ_CUSTMAT := 0
STJ->TJ_CUSTMAA := 0
STJ->TJ_CUSTMAS := 0
STJ->TJ_CUSTTER := 0
STJ->TJ_DTULTMA := CtoD("  /  /  ")
STJ->TJ_COULTMA := 0
STJ->TJ_DTPPINI := CtoD("  /  /  ")
STJ->TJ_HOPPINI := ""
STJ->TJ_DTPPFIM := CtoD("  /  /  ")
STJ->TJ_HOPPFIM := ""
STJ->TJ_DTPRINI := Date()
STJ->TJ_HOPRINI := Time()
STJ->TJ_DTPRFIM := CtoD("  /  /  ")
STJ->TJ_HOPRFIM := ""
STJ->TJ_DTMPINI := Date()
STJ->TJ_HOMPINI := Time()
STJ->TJ_DTMPFIM := Date()
STJ->TJ_HOMPFIM := Time()
STJ->TJ_DTMRINI := CtoD("  /  /  ")
STJ->TJ_HOMRINI := ""
STJ->TJ_DTMRFIM := CtoD("  /  /  ")
STJ->TJ_HOMRFIM := ""
STJ->TJ_COULTM2 := 0
STJ->TJ_TERMINO := "N"
STJ->TJ_USUARIO := Upper(CUSERNAME)
STJ->TJ_PRIORID := "ZZZ"
STJ->TJ_CENTRAB := ST9->T9_CENTRAB
STJ->TJ_TIPORET := ""
STJ->TJ_OBSERVA := _cMsg
STJ->TJ_HORACO2 := ":"
STJ->TJ_SITUACA := "L"
STJ->TJ_POSCON2 := 0
STJ->TJ_ORDEPAI := ""
STJ->TJ_BEMPAI  := ""
STJ->TJ_FILQNC  := ""
STJ->TJ_FNC     := ""
STJ->TJ_REVQFNC := ""
STJ->TJ_VALATF  := ""
STJ->TJ_LUBRIFI := ""
STJ->TJ_SUBSTIT := ""
STJ->TJ_TIPOOS  := "B"
STJ->TJ_SOLICI  := ""
STJ->TJ_SEQRELA := "0"	
STJ->TJ_CODFUN  := _cMatSolic
STJ->TJ_MAQSIT  := "D"
STJ->TJ_HRPARAD := Time()
STJ->TJ_HRDIGIT := Time()
STJ->TJ_TITULO  := _cMotivo
STJ->TJ_AREA    := "4"
STJ->TJ_PRIORI  := "1"
STJ->TJ_IRREGU  := ""
STJ->TJ_TERCEIR := "2"
STJ->TJ_STFOLUP := ""

MsUnlock("STJ") 

ConfirmSx8()

ZB4->(DbSetOrder(1)) // filial + num + item
If ZB4->(DbSeek(xFilial("ZB4")+_cNum+aOs[1]))
	RecLock("ZB4",.F.)
		ZB4->ZB4_ORDEM  := STJ->TJ_ORDEM
	MsUnlock("ZB4") 
EndIf
aCols[n][_nOrdem] := STJ->TJ_ORDEM
oMultiline:Refresh()

ALERT("Ordem gerada "+STJ->TJ_ORDEM)

Return
           


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ENVIA EMAIL INFORMANDO DA MOVIMENTACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fEmailMov()
Local cServer	  := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.4"
Local cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
Local cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga'
Local lConectou
Local lEnviado
Local cTexto    := ""
Local cTo       := ""//joaofr@whbbrasil.com.br;"

cTo += "claudiosa@whbusinagem.com.br;"
cTo += "edinapn@whbusinagem.com.br;"
cTo += "marciliom@whbusinagem.com.br;"
cTo += "paulomg@whbusinagem.com.br;"
cTo += "edemirjs@whbusinagem.com.br;"
cTo += "gilbertot@whbusinagem.com.br;"
cTo += "geraldoz@whbusinagem.com.br;"
cTo += "rogeriofm@whbbrasil.com.br;"
cTo += "fernandow@whbbrasil.com.br;"
cTo += "andersonk@whbbrasil.com.br;"
cTo += "felipest@whbbrasil.com.br;"
cTo += "edsonlm@whbusinagem.com.br;"
cTo += "glalberez@whbbrasil.com.br;"
cTo += "edsontp@whbusinagem.com.br;"
cTo += "antoniobb@whbusinagem.com.br;"
cTo += "jclaudio@whbusinagem.com.br;"
cTo += "evandirm@whbusinagem.com.br"


ZB3->(DbSetOrder(1)) //FILIAL + NUM
ZB3->(DBSEEK(XFILIAL("ZB3")+_cNum))

ZB4->(DBSETORDER(1)) //FILIAL + NUM + ITEM
ZB4->(DBSEEK(XFILIAL("ZB4")+_cNum))

SRA->(DbSetOrder(1)) //filial + mat
SRA->(DbSeek(xFilial('SRA')+ZB3->ZB3_MATSOL))

cTexto += "<body style='font-family:Arial;font-size:12px'>"
cTexto += "<hr />"
cTexto += "<strong>Informe de Solicitação de Movimentação de Bens</strong><b />"
cTexto += "<table border='1' cellpadding='0' cellspacing='0' width='100%'>"
cTexto += "<tr><td style='background:#aabbcc'>Solicitação:</td><td>"+ZB4->ZB4_NUM+"</td></tr>"
cTexto += "<tr><td style='background:#aabbcc'>Data:</td><td>"+DTOC(ZB3->ZB3_DATA)+"</td></tr>"
cTexto += "<tr><td style='background:#aabbcc'>Solicitante:</td><td>"+ZB3->ZB3_MATSOL+" - "+SRA->RA_NOME+"</td></tr>"
cTexto += "<tr><td style='background:#aabbcc'>Data Limite:</td><td>"+DTOC(ZB3->ZB3_DTLIM)+"</td></tr>"
cTexto += "<tr><td style='background:#aabbcc'>Motivo</td><td>"+ZB3->ZB3_MOTIVO+"</td></tr>"
cTexto += "</table><br />"

cTexto += "<table border='1' cellpadding='0' cellspacing='0' width='100%'>"
cTexto += "<tr style='background:#aabbcc'>"
cTexto += "<td>Ítem</td>"
cTexto += "<td>Bem</td>"
cTexto += "<td>Descrição</td>"
cTexto += "<td>C.Custo Origem</td>"
cTexto += "<td>C.Custo Destino</td>"
cTexto += "<td>Quadrante Origem</td>"
cTexto += "<td>Quadrante Destino</td>"

cTexto += "</tr>"
While ZB4->(!EOF()) .AND. ZB4->ZB4_NUM == _cNum
	cTexto += "<tr>"
	cTexto += "<td>"+ZB4->ZB4_ITEM+"</td>"
	cTexto += "<td>"+ZB4->ZB4_CODBEM+"</td>"
	
	ST9->(DBSETORDER(1))
	ST9->(DbSeek(xFilial("ST9")+ZB4->ZB4_CODBEM))
	
	cTexto += "<td>"+ST9->T9_NOME+"</td>"
	cTexto += "<td>"+ZB4->ZB4_CCORIG+"</td>"
	cTexto += "<td>"+ZB4->ZB4_CCDEST +"</td>"
	cTexto += "<td> X: "+TRANSFORM(ZB4->ZB4_POSXOR,"@E 999.99")+", Y: "+TRANSFORM(ZB4->ZB4_POSYOR,"@E 999.99")+"</td>"
	cTexto += "<td> X: "+TRANSFORM(ZB4->ZB4_POSXDE,"@E 999.99")+" ,Y: "+TRANSFORM(ZB4->ZB4_POSYDE,"@E 999.99")+"</td>"
	cTexto += "</tr>"
	//cTexto += "<tr><td style='background:#aabbcc'>O.S.:</td><td>"+ZB4->ZB4_ORDEM+"</td></tr>"

	ZB4->(DBSKIP())
ENDDO
cTexto += "</table>"
cTexto += "<hr />"
cTexto += "<span style='font-family:Arial;font-size:12px'>Mensagem automática. Favor não responder.</span>"
cTexto += "</body>"

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

If lConectou
	Send Mail from "protheus@whbbrasil.com.br";
	To cTo;
	SUBJECT "****** SOLICITAÇÃO DE MOVIMENTAÇÃO DE BEM ******";
	BODY cTexto;
	RESULT lEnviado
	                
	If !lEnviado
		Get mail error cMensagem
		Alert(cMensagem)
	EndIf
else
	Alert("Erro ao se conectar no servidor: " + cServer)		
Endif

Return