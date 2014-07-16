/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST047  ºAutor  ³Marcos R Roquitski  º Data ³  12/17/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclusao no cadastro de Inventario.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Fundicao e Usinagem WHB                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteração ³ Felipe Ciconini                                 01/12/10   ¼±±
±±           ³  > Mudança da tela de Inclusão                             ¼±±
±±           ³  > Inclusao de opção Alterar                               ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#include "colors.ch"
#include "font.ch"
#include "TOPCONN.ch"


User Function NhEst047(nParam)

SetPrvt("_cIniEtq,_cEtiq,_cCont,_cCod,_cLocal,_dData,_cLocaliz,_cDoc,_cFlag,_cOper,oDlg,_cTipo,aHeader,aCols,nPar,_nQtdeEt,nMax,oMultiline,_cContag")

DEFINE FONT oFont NAME "Arial" SIZE 10, -12                                                                  

nPar	  := nParam
_cEtiq    := Space(09)
_cCont    := "1"
_cLocal   := Space(02)
_dData    := dDataBase
_cLocaliz := Space(15)
_cOper    := Space(03)
_cFlag    := Space(01)
_cTipo    := Space(03)
aHeader	  := {}
aCols	  := {}
_cDoc	  := Space(09)
_cIniEtq  := Space(09)
_nQtdeEt  := 0
nMax      := 1
_cContag  := "Primeira Contagem"

//                                                                                 validação
	Aadd(aHeader,{"Etiqueta"    , "ZB_ETIQ"     ,"@!"						,09,0,"U_E47ETQ()","" ,"C"  ,"SZB"})
	Aadd(aHeader,{"Produto"     , "ZB_COD"   	,"@!"						,15,0,"U_E47PRD()","" ,"C"  ,"SZB"})
	Aadd(aHeader,{"Descrição"   , "ZB_DESC"     ,"@!"						,30,0,".F." 	  ,"" ,"C"  ,"SZB"})
	Aadd(aHeader,{"Quantidade 1", "ZB_QTDE1"    ,"@E 999,999,999.99" 		,08,0,".T." 	  ,"" ,"N"  ,"SZB"})
 	Aadd(aHeader,{"Quantidade 2", "ZB_QTDE2"    ,"@E 999,999,999.99" 		,08,0,".T." 	  ,"" ,"N"  ,"SZB"})
	Aadd(aHeader,{"Quantidade 3", "ZB_QTDE3"    ,"@E 999,999,999.99" 		,08,0,".T." 	  ,"" ,"N"  ,"SZB"})
	Aadd(aHeader,{"Operação"    , "ZB_OPERACA"  ,"@!"						,03,0,".T." 	  ,"" ,"C"  ,"SZB"})
	Aadd(aHeader,{"Localização" , "ZB_LOCALIZ"  ,"@!"				 		,15,0,"U_E47LCZ()","" ,"C"  ,"SZB"})

If nPar == 1
	aHeader[5][6] := ".F."
 	aHeader[6][6] := ".F."	

ElseIf nPar == 2
	If SZB->ZB_CONT == "1"
		aHeader[5][6] := ".T."
		aHeader[6][6] := ".F."		
		_cCont	  := "2"
        _cContag  := "Segunda Contagem"		
	ElseIf SZB->ZB_CONT == "2"
		aHeader[6][6] := ".T."
		aHeader[5][6] := ".F."		
		_cCont	:= "3"        
        _cContag  := "Terceira Contagem"				
	ElseIf SZB->ZB_CONT == "3"		
		aHeader[6][6] := ".F."
		aHeader[5][6] := ".F."		
		_cCont	:= "3"        
        _cContag  := "Já Efetuadas Todas Contagens"						
	EndIf
	fCarrega()
	aHeader[1][6] := ".F."	
	aHeader[2][6] := ".F."
	aHeader[3][6] := ".F."
	aHeader[4][6] := ".F."

    If SZB->ZB_LANC == "S"		 
       _cContag  := "Já Efetuada Importação"						
    Endif
		
EndIf 


	Define MsDialog oDlg From 0,0 To 520,980 Pixel Title "Inventário"
//	     LIN,COL
	   @ 012,440 Say "Data:"      Color CLR_HBLUE	Size 35,8
	   @ 012,455 Say Dtoc(_dData)				Picture "99/99/9999"  Size 45,8
	   
   	   @ 012,010 Say "Documento:" Color CLR_HBLUE	Size 35,8
	   @ 010,040 Get _cDoc				Picture "@!" When(nPar==1) Size 45,8	Valid fValDoc()
	   
	   @ 012,100 Say "Almoxarifado:" 	Color CLR_HBLUE	Size 35,8
	   @ 010,135 Get _cLocal			Picture "@!" When(nPar==1) Size 15,8	Valid fValLoc()
	   
	   @ 012,180 Say "Numero Etiqueta:"	Color CLR_HBLUE Size 55,8
	   @ 010,230 Get _cIniEtq			Picture "@!" When(nPar==1) Size 45,8 Valid fValIni()
	   
	   @ 012,330 Say "Qtde Etiq:"		Color CLR_HBLUE Size 45,8
	   @ 010,370 Get _nQtdeEt			Picture "99" When(nPar==1) Size 15,8	Valid fValQtde()	   
	                       
      @ 240,210 Say _cContag Object oContag             
      oContag:Setfont(oFont)                      

	   DbSelectArea("SZB")
	   @ 035,010 To 230,480 Multiline Modify Delete Valid fValLin() Object oMultiline	   
	   @ 240,010 BMPButton Type 01 Action GravaDados()
	   @ 240,040 BMPButton Type 02 Action oDlg:End()


	Activate MsDialog oDlg Center 

Return
//	   @ 035,010 To 230,480 Multiline Modify Delete Valid fValLin() Object oMultiline

Static Function GravaDados()
    
    If !fValida()
    	Return .F.
    EndIf
    
	If nPar == 1

		For xL:=1 to Len(aCols)
		
			If !aCols[xL][len(aHeader)+1]
			
				RecLock('SZB',.T.)
					
					SZB->ZB_FILIAL	:= xFilial("SZB") 		//FILIAL
					SZB->ZB_DATA	:= _dData				//DATA
					SZB->ZB_DOC		:= _cDoc				//DOC
					SZB->ZB_LOCAL	:= _cLocal				//LOCAL
					SZB->ZB_ETIQ	:= aCols[xL][1]			//NUMERO ETIQUETA
					SZB->ZB_COD		:= aCols[xL][2]			//CODIGO PRODUTO
					SZB->ZB_QTDE1	:= aCols[xL][4]			//QUANTIDADE 1
					SZB->ZB_QTDE2	:= aCols[xL][5]			//QUANTIDADE 2
					SZB->ZB_QTDE3	:= aCols[xL][4]			//LANCA A QUANTIDADE 1 TAMBÉM
					SZB->ZB_OPERACA	:= aCols[xL][7]			//OPERACAO
					SZB->ZB_LOCALIZ	:= aCols[xL][8]			//LOCALIZACAO
					SZB->ZB_LANC	:= " "					//FLAG DE LOCALIZAÇÃO
					SZB->ZB_CONT	:= _cCont				//CONTAGEM				
				
				MsUnLock('SZB')
				
			Endif
		
		Next
	
	ElseIf nPar == 2
	
		For xL:=1 to Len(aCols)
		
			If !aCols[xL][len(aHeader)+1]
				SZB->(DbSetOrder(1)) //filial + data
				If SZB->(DbSeek(xFilial("SZB")+DtoS(_dData)+aCols[xL][1]))
			
					RecLock('SZB',.F.)
					
						If _cCont == "2"
						   If SZB->ZB_QTDE1 == aCols[xL][5]
							  SZB->ZB_CONT  := _cCont
							  SZB->ZB_QTDE2 := aCols[xL][5]
  							  SZB->ZB_QTDE3 := aCols[xL][5]							  
						   Else
							  SZB->ZB_CONT  := _cCont
							  SZB->ZB_QTDE2 := aCols[xL][5]
						   Endif	  
						ElseIf _cCont == "3"
							SZB->ZB_CONT := _cCont
							SZB->ZB_QTDE3 := aCols[xL][6]
						EndIf
					
						SZB->ZB_OPERACA	 := aCols[xL][7]
						SZB->ZB_LOCALIZ	 := aCols[xL][8]
					
					MsUnlock('SZB')
								
				EndIf
			
			Else
				SZB->(DbSetOrder(1)) //filial + doc
				If SZB->(DbSeek(xFilial("SZB")+DtoS(_dData)+aCols[xL][1]))
					RecLock("SZB",.F.)
						SZB->(dbDelete())
					MsUnlock("SZB")
		        EndIf
			
			EndIf
			
		Next xL
	
	EndIf
		
	oDlg:End()
	
Return .T.


Static Function fIniEtq()
Local nPosDsc := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB_ETIQ"})

If Empty(_cIniEtq)
	Alert("Digite uma Etiqueta Inicial!")
	Return .F.
Else
	aCols[1][nPosDsc] := _cIniEtq
		//Subs(_cIniEtq,1,4)+ Subs(_cIniEtq,1,4)
EndIf

Return .T.


Static Function fValQtde()
Local _lRet := .F.

If Empty(_nQtdeEt)
	Alert("Digite a Quantidade de Etiquetas Para Este Documento!")
Else	
    _lRet := .T.
Endif           
nMax := _nQtdeEt
oMultiline:Refresh()
DlgRefresh(oDlg)
Return(_lRet)



Static Function fValIni()
Local _lRet := .F.
Local nPosDsc := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB_ETIQ"})

If !Empty(_cIniEtq)
	aCols[1][nPosDsc] := _cIniEtq
    _lRet := .T.
Endif

Return(_lRet)

User Function E47PRD()
Local nPosDsc := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB_DESC"})
Local nPosPrd := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB_COD"})

	SB1->(DbSetOrder(1))
	If !SB1->(DbSeek(xFilial("SB1")+M->ZB_COD))	
		Alert("Produto inválido.")
		Return .F.
	Else
		aCols[n][nPosDsc] := SB1->B1_DESC
	EndIf

Return .T.

User Function E47ETQ()
Local nPosEtq := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB_ETIQ"})
Local nPosPrd := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB_COD"})

If n==1
   Acols[n][nPosEtq] := _cIniEtq
Else   
   Acols[n][nPosEtq] := Subs(aCols[n-1][1],1,4)+StrZero(Val(Subs(aCols[n-1][1],5,5))+1,5)                                                
Endif
oMultiline:Refresh()
DlgRefresh(oDlg)
Return .T.

         
User Function E47LCZ()
Local nPosLcz := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB_LOCALIZ"})
Local nPosPrd := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB_COD"})     
Local _lRet := .T.

	SB1->(DbSetOrder(1))
	If !SB1->(DbSeek(xFilial("SB1")+aCols[n][nPosPrd]))		
		Alert("Produto inválido.")
		_lRet := .F.
	Else
		If SB1->B1_LOCALIZ$"S" .And. Empty(M->ZB_LOCALIZ)
 		   Alert("Produto Com Controle de Localização!!")
    		_lRet := .F. 		   
		Endif
	EndIf

Return (_lRet)


Static Function fValDoc()
Local _lRet := .T.

If Empty(_cDoc)
	Alert("Digite o documento!")
	_lRet := .F.
EndIf

Return(_lRet)

Static Function fValLoc()
Local _lRet := .F.

 SX5->(Dbgotop())       
 SX5->(DbSetOrder(1)) //filial+cod
 SX5->(DbSeek(xFilial("SX5")+"ZA")) //tabelas de almoxarifados
 While SX5->(!Eof()) 
    If SX5->X5_TABELA  == "ZA" .AND. AllTrim(SX5->X5_CHAVE) == _cLocal //Verifica se o almox existe 
       _lRet := .T.
       Exit //
    Endif                       
    SX5->(Dbskip())
 Enddo
 If !_lRet
	Alert("Almoxarifado Não Existe!") 
 Endif

Return(_lRet)

Static Function fCarrega()

	_dData		:= SZB->ZB_DATA
	_cDoc		:= SZB->ZB_DOC
	_cLocal		:= SZB->ZB_LOCAL
    _cIniEtq	:= SZB->ZB_ETIQ 
	SZB->(DbSetOrder(2)) //filial + doc
	SZB->(DbSeek(xFilial("SZB")+SZB->ZB_DOC+DTOS(SZB->ZB_DATA)))		
   
	While SZB->(!EOF()) .And. SZB->ZB_DOC == _cDoc .And. SZB->ZB_DATA == _dData
	
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+SZB->ZB_COD))
		aAdd(aCols,{SZB->ZB_ETIQ,SZB->ZB_COD,SB1->B1_DESC,SZB->ZB_QTDE1,SZB->ZB_QTDE2,SZB->ZB_QTDE3,SZB->ZB_OPERACA,SZB->ZB_LOCALIZ,.F.})
		SZB->(DbSkip())
	EndDo
	aCols := ASort(aCols,,, { |x, y| x[1] < y[1]}) //Orderna por etiqueta
    _cIniEtq	:= Acols[1][1]  	
	nMax     :=  Len(acols)
	_nQtdeEt :=  Len(acols)

Return

Static Function fValida()
 /*
	If Empty(_cDoc)
		Alert("Digite o Documento!")
		Return .F.
	EndIf
	
	If Empty(_cLocal)
		Alert("Digite o Local!")
		Return .F.
	EndIf

	For xL:=1 to Len(aCols)
		
		If Empty(aCols[xL][1])
			Alert("Digite a Etiqueta!")
			Return .F.
		EndIf
		
		If Empty(aCols[xL][2])
			Alert("Digite o Produto!")
			Return .F.
		EndIf
		
		If Empty(aCols[xL][7])
			Alert("Digite a Operação!")
			Return .F.
		EndIf
		
		If Empty(aCols[xL][8])
			Alert("Digite a Localização!")
			Return .F.
		EndIf
		
	Next
   */
Return .T.

Static Function fValLin()
Local _lRet := .T.
Local nPosEtq := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB_ETIQ"})   
Local nPosLcz := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB_LOCALIZ"})
Local nPosPrd := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB_COD"})
Local nPosEtq := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZB_ETIQ"})

//	aCols[n+1][nPosEtq] := Subs(aCols[n][nPosEtq],1,4)+StrZero(Val(Subs(aCols[n][nPosEtq],5,5))+1,5)
If !Acols[n][len(aHeader)+1] .And. nPar == 1 //(incluir) //nao pega quando a linha esta deletada 

   If len(Acols)+1 <= _nQtdeEt
      _lRet := .T.

 	  SB1->(DbSetOrder(1))
	  If SB1->(DbSeek(xFilial("SB1")+aCols[n][nPosPrd]))
	     If SB1->B1_LOCALIZ$"S" .And. Empty(aCols[n][nPosLcz])
 		     Alert("Produto Com Controle de Localização!!")
            _lRet := .F. 		   
	     Endif
	  EndIf
   Else
      Alert("Este Documento so Pode ter " + strzero(_nQtdeEt,2)+ " Itens")   
      _lRet := .F. 		         
   Endif	  

Endif

Return(_lRet)

