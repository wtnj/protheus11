/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST143 ºAutor  ³João Felipe          º Data ³  07/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CADASTRO DA MONTAGEM DE FERRAMENTAS                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "msobjects.ch"
#INCLUDE "topconn.ch"
#INCLUDE "colors.ch"
#INCLUDE "protheus.ch"
#include "rwmake.ch"                                                                    


User Function NHEST143()
SetPrvt("_cObs1,_cObs2")
Private cAlias    := "ZBJ"
Private aRotina   := {}
Private cCadastro := "Montagem de Ferramentas"

	aAdd( aRotina, {"Pesquisar"   ,"AxPesqui"     ,0,1} )
	aAdd( aRotina, {"Visualizar"  ,"U_fEST143(2)" ,0,2} )
	aAdd( aRotina, {"Incluir"     ,"U_fEST143(3)" ,0,3} )
	aAdd( aRotina, {"Alterar"     ,"U_fEST143(4)" ,0,4} )
	aAdd( aRotina, {"Excluir"     ,"U_fEST143(5)" ,0,5} )
	aAdd( aRotina, {"Gera Revisao","U_fEST143(6)" ,0,6} )
	aAdd( aRotina, {"Aprovacao"   ,"U_fAPR143()"  ,0,7} )

	dbSelectArea(cAlias)
	dbSetOrder(1)
	Set filter to Empty(ZBJ->ZBJ_OBSOL)
	ZBJ->(DbGotop())

	mBrowse(,,,,cAlias,,"ZBJ_DTAPRO==CTOD(Space(08))",,,,)

	Set filter to 
	ZBJ->(DbGotop())

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PRINCIPAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function fEST143(nParam)
Local lCheck       := .F.
Local bGrava       := {|| oDlg:End()}
Private cDescCC    := ""
Private nPar       := nParam
Private aHeader    := {}
Private aCols      := {}
Private cStartPath := GetSrvProfString("Startpath","")
Private _aGrupo    := pswret()     // Retorna vetor com dados do usuario

//bloqueia para alteracao
If nPar==4 
	MsgBox("Favor usar a opcao: Gera revisao.","Montagem Ferramentas","ALERT")
	Return
EndIf
	



If Right(cStartPath,1) <> "\"
	cStartPath += "\"
Endif               

If SM0->M0_CODIGO=="NH" //EMPRESA USINAGEM
	cStartPath += "FT\"
ElseIf SM0->M0_CODIGO=="FN" //EMPRESA FUNDICAO
	cStartPath += "FTFN\"
EndIf

	aadd(aHeader,{"Item"     , "ZBC_ITEM" , PesqPict('ZBC', 'ZBC_ITEM') , 04, 00, '.F.'          , '' , 'C', 'ZBC', ''})
    aadd(aHeader,{"Qtde"     , "ZBC_QTDE" , PesqPict('ZBC', 'ZBC_QTDE') , 05, 00, '.T.'          , '' , 'N', 'ZBC', ''})
    aadd(aHeader,{"Código"   , "ZBC_COD"  , PesqPict('ZBC', 'ZBC_COD')  , 15, 00, 'U_EST143PRD()', '' , 'C', 'ZBC', ''})
    aadd(aHeader,{"Descrição", "B1_DESC"  , PesqPict('SB1', 'B1_DESC')  , 50, 00, '.F.'		     , '' , 'C', 'SB1', ''})
	aadd(aHeader,{"Posição"  , "ZBC_POS"  , PesqPict('ZBC', 'ZBC_POS')  , 02, 00, '.T.'		     , '' , 'N', 'ZBC', ''})
	aadd(aHeader,{"Imagem"   , "ZBC_IMG01", PesqPict('ZBC', 'ZBC_IMG01'), 40, 00, '.F.'          , '' , 'C', 'ZBC', ''})
      
	//bloqueia para alteracao
	If nPar==2 .Or. nPar==5 //visualizar ou excluir
		For _x := 1 to Len(aHeader)
			aHeader[_x][6] := '.F.'
		Next
	EndIf
	
	If nPar == 3 //Incluir
		//instancia um novo objeto
		oMontagem := Montagem():New()
		bGrava    := {||oMontagem:Inclui()}

	Else
		//instancia um objeto construido
		oMontagem := Montagem():New(ZBJ->ZBJ_NUMONT,ZBJ->ZBJ_RV)
		          
		CTT->(DBSETORDER(1))
		CTT->(DBSEEK(XFILIAL("CTT")+oMontagem:cCC))
		
		cDescCC := CTT->CTT_DESC01
		
		If nPar==4     //Alterar
			bGrava := {||oMontagem:Altera()}
		ElseIf nPar==5 //Excluir
			bGrava := {||oMontagem:Exclui()}
		Elseif nPar==6 //Gera revisao
			f143Obs()
			bGrava := {||oMontagem:Revisao()}
		EndIf
	EndIf

	//tela de dialogo
	oDlg := MsDialog():New(0,0,500,600,"Montagem de Ferramentas",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
    
    //caixa contorno para agrupamento de componentes
    oGroup1 := tGroup():New(5,5,128,297,,oDlg,,,.T.)
    
    oSay1 := tSay():New(12,10,{||"Nº Montagem"},oDlg,,,,,,.T.,,)
    oGet1 := tGet():New(10,50,{|u| if(Pcount()>0,oMontagem:cNumMont := u, oMontagem:cNumMont)},oDlg,;
    		 50,8,"@!",/*valid*/,,,,,,.T.,,,{||.F.},,,,,,,"oMontagem:cNumMont")

    oSay5 := tSay():New(12,105,{||"Revisao"},oDlg,,,,,,.T.,,)
    oGet5 := tGet():New(10,130,{|u| if(Pcount()>0,oMontagem:cRv := u, oMontagem:cRv)},oDlg,;
    		 15,8,"@!",/*valid*/,,,,,,.T.,,,{||.F.},,,,,,,"oMontagem:cRv")

    oSay2 := tSay():New(24,10,{||"Descricao"},oDlg,,,,,,.T.,,)
    oGet2 := tGet():New(22,50,{|u| if(Pcount()>0,oMontagem:cDescMont := u, oMontagem:cDescMont)},oDlg,;
    		 110,8,"@!",/*valid*/,,,,,,.T.,,,{||nPar==3 .Or. nPar==4 .or. nPar==6},,,,,,,"oMontagem:cDescMont")

    oSay3 := tSay():New(36,10,{||"C.Custo"},oDlg,,,,,,.T.,,)
    oGet3 := tGet():New(34,50,{|u| if(Pcount()>0,oMontagem:cCC := u, oMontagem:cCC)},oDlg,;
    		 40,8,"@!",{||oMontagem:MontaNum()},,,,,,.T.,,,{||nPar==3},,,/*ONCHANGE*/,,,"CTT","oMontagem:cCC")
                                                      
    oSay4 := tSay():New(48,10,{||"Desc. C.Custo"},oDlg,,,,,,.T.,,)
    oGet4 := tGet():New(46,50,{|u| if(Pcount()>0,cDescCC := u, cDescCC)},oDlg,;
    		 110,8,"@!",/*valid*/,,,,,,.T.,,,{||.F.},,,,,,,"cDescCC")

    oSay6 := tSay():New(60,10,{||"Operacao"},oDlg,,,,,,.T.,,)
    oGet6 := tGet():New(62,50,{|u| if(Pcount()>0,oMontagem:cOperacao := u, oMontagem:cOperacao)},oDlg,;
    		 15,8,"@!",/*valid*/,,,,,,.T.,,,{||nPar==3 .Or. nPar==4 .or. nPar==6},,,,,,,"oMontagem:cOperacao")

	//imagem da montagem
	oSBox := TScrollBox():New(oDlg,10,162,100,130,.T.,.T.,.T.)
	
	@ 000,000 BITMAP FILE oMontagem:cImg01 PIXEL OF oSBox object obmp // NOBORDER
	
	If nPar != 3 //visualiza, altera, exclui
		obmp:cbmpfile  := cStartPath + "teste.jpg"        //apaga do objeto o endereço da imagem atual 
		obmp:cbmpfile  := cStartPath + oMontagem:cImg01 //atribui o endereço da nova imagem
		obmp:lautosize := .F.
		obmp:lautosize := .T.      //força o tamanho da imagem
		obmp:lvisible  := .T.      //força a visualização da imagem
	EndIf

	oCheckImg := tCheckBox():New(113,162,"Ajustar",{|u|if(pcount()>0,lCheck:=u,lCheck)};
		,oDlg,30,8,/*Reservado*/,{||oMontagem:AjustaImg(obmp,oSBox)},,,,,,.T.)
	
	If nPar == 3 .or. nPar == 4 .or. nPar == 6
		oBtn1 := tButton():New(115,207 ,"Alterar",oDlg,{||oMontagem:AlteraImg(obmp)},40,8,,,,.T.)
	EndIf
	
	oBtn2 := tButton():New(115,252 ,"Visualizar",oDlg,{||oMontagem:VisualizaImg(oMontagem:cImg01)},40,8,,,,.T.)
	
	//monta o getdados
	oGetD := MsGetDados():New(133,5,205,297,;
	                          4,"AllwaysTrue",;
	                          "AllwaysTrue","",;
	                          .T.,nil,nil,.F.,;
	                          200,nil,"AllwaysTrue",;
	                          nil,"AllwaysTrue",;
	                          oDlg) 

	SET KEY VK_F4 TO oMontagem:IncDes()

	If(nPar==2 .Or. nPar==5)//visualizar
		oGetD:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no getdados
	EndIf
    
	oSay5 := tSay():New(210,10,{||"F4 - Alterar Desenho"},oDlg,,,,,,.T.,,)

	oSay7 := tSay():New(230,010,{||"Elaborador:"},oDlg,,,,,,.T.,,)

    oGet7 := tGet():New(230,045,{|u| if(Pcount()>0,oMontagem:cElabor := u,oMontagem:cElabor)},oDlg,;
    		 110,8,"@!",/*valid*/,,,,,,.T.,,,{||.F.},,,,,,,"oMontagem:cElabor")

	oSay8 := tSay():New(230,170,{||"Aprovador:"},oDlg,,,,,,.T.,,)	

    oGet7 := tGet():New(230,205,{|u| if(Pcount()>0,oMontagem:cAprov := u,oMontagem:cAprov)},oDlg,;
    		 110,8,"@!",/*valid*/,,,,,,.T.,,,{||.F.},,,,,,,"oMontagem:cAprov")


	oBtn5 := tButton():New(210,167,"Desenho",oDlg,{||oMontagem:VisualizaImg(aCols[n][6])},40,10,,,,.T.)
	oBtn3 := tButton():New(210,212,"Ok",oDlg,bGrava,40,10,,,,.T.)
	oBtn4 := tButton():New(210,257,"Cancelar",oDlg,{||oDlg:End()},40,10,,,,.T.)
	oDlg:Activate(,,,.T.,{||.T.},,{||})
	                      
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Classe Montagem ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Class Montagem

	Data cNumMont  as Character //Numero da Montagem
	Data cDescMont as Character //Descrição da Montagem
	Data cCC       as Character //Centro de Custo da Montagem
	Data cImg01    as Character //Endereco da imagem
	Data cRv       as Character //Revisao da montagem  
	Data cElabor   as Character //Revisao da montagem 
	Data cAprov    as Character //Revisao da montagem 
	Data cOperacao as Character //Operacao                  


	Method New(cNumMont,cRv) Constructor 
	Method getMontagem(cNumMont)
	Method Valida()
	Method Inclui() 
	Method Altera()
	Method Revisao()
	Method Exclui()
	Method AjustaImg(oImg,oScroll)
	Method AlteraImg(obmp)
	Method RunDlg()
	Method UpLoadImg(cLocImg,oImg)
	Method VisualizaImg(oImg)
	Method MontaNum()
	Method IncDes()
	Method Destroy()	
	Method ChekResp()		
	
EndClass

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Metodo Construtor ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method New(cNumMont,cRv) Class Montagem
	If !Empty(cNumMont)
		::getMontagem(cNumMont,cRv)
	Else
		::cNumMont  := Space(15)
		::cCC       := Space(8)
		::cDescMont := Space(100)
		::cRv       := Space(03)
		::cElabor   := Alltrim(_agrupo[1,2])
		::cAprov    := Space(15)
		::cOperacao := Space(03)
	EndIf
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna a Montagem Construida ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method getMontagem(cNumMont,cRv) Class Montagem
    
	//Recupera os dados da montagem
	ZBJ->(DbSetOrder(1)) //Filial + NuMont
	If ZBJ->(DbSeek(xFilial("ZBJ")+cNumMont+cRv))
		::cNumMont  := ZBJ->ZBJ_NUMONT
		::cDescMont := ZBJ->ZBJ_DESC
		::cCC       := ZBJ->ZBJ_CC
		::cImg01    := ZBJ->ZBJ_IMG01
		::cRv       := ZBJ->ZBJ_RV    
		::cElabor   := ZBJ->ZBJ_ELABOR
		::cAprov    := ZBJ->ZBJ_APROV   
		::cOperacao := ZBJ->ZBJ_OPERAC  
    EndIf

	If nPar==6
		::cRv := StrZero(Val(ZBJ->ZBJ_RV)+ 1,3)
	Endif		
	    
	//Recupera os itens da montagem no acols
	SB1->(DbSetOrder(1)) //Filial + Cod
	ZBC->(DbSetOrder(1)) //Filial + NuMont + Item + Revisao
	If ZBC->(DbSeek(xFilial("ZBC")+cNumMont))
		While ZBC->(!EOF())	.AND. ZBC->ZBC_NUMONT == cNumMont 
			If ZBC->ZBC_RV == cRv
				SB1->(DbSeek(xFilial("SB1")+ZBC->ZBC_COD))
			    aAdd(aCols,{ZBC->ZBC_ITEM,ZBC->ZBC_QTDE,ZBC->ZBC_COD,SB1->B1_DESC,ZBC->ZBC_POS,ZBC->ZBC_IMG01,.F.})
			Endif				    
		    ZBC->(DbSkip())
		EndDo
	EndIf

Return
                   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A MONTAGEM DE FERRAMENTAS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Valida() Class Montagem
	If Empty(::cNumMont)
		Alert("Número da Montagem não pode estar vazio!")
		Return .F.
	EndIf
	
	If Len(aCols) <= 1 .AND. Empty(aCols[1][3])
		Alert("Digite pelo menos um componente da montagem de ferramentas!")
		Return .F.
	EndIf
	
	If nPar == 3 // incluir
		ZBJ->(DbSetOrder(1)) // FILIAL + NUMONT
		If ZBJ->(DbSeek(xFilial("ZBJ")+::cNumMont))
			Alert("Número da montagem já existe!")
			Return .F.
		EndIf
	EndIF 
	
	If !::ChekResp()
		Return .F.
	Endif	
	 
Return .T.     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³ GRAVA A MONTAGEM NO BANCO DE DADOS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù
Method Inclui() Class Montagem
Local cImgTmp    := ""

	If !::Valida()
		Return	
	EndIf
	     
  	//copia a imagem para o servidor e altera o nome para gravar no banco de dados
    If !Empty(::cImg01)
		cImgTmp := AllTrim(::cNumMont) + AllTrim(::cRv) + Right(ALLTRIM(::cImg01),4)//padrao: numero da montagem + extensao do arquivo
				
		If ::cImg01 != cImgTmp
			If __CopyFile(::cImg01,cStartPath + cImgTmp)
				::cImg01 := cImgTmp
			Else
				Alert("Impossível copiar Imagem!")
				::cImg01 := ""
			EndIf
		EndIf
	EndIf
	
	//grava os dados da montagem
	RecLock("ZBJ",.T.)
		ZBJ->ZBJ_FILIAL := xFilial("ZBJ")
		ZBJ->ZBJ_NUMONT := ::cNumMont
		ZBJ->ZBJ_DESC   := ::cDescMont
		ZBJ->ZBJ_CC     := ::cCC
		ZBJ->ZBJ_IMG01  := ::cImg01
		ZBJ->ZBJ_RV     := ::cRv
		ZBJ->ZBJ_ELABOR := ::cElabor
		ZBJ->ZBJ_OPERAC := ::cOperacao
	MsUnLock("ZBJ")
	
	//grava os itens da montagem
	For x:=1 to Len(Acols)
		If !Acols[x][len(aHeader)+1]//nao pega quanto a linha esta deletada

		  	//copia a imagem para o servidor e altera o nome para gravar no banco de dados
    		If !Empty(aCols[x][6])
				cImgTmp := AllTrim(aCols[x][3]) + Right(ALLTRIM(aCols[x][6]),4)//padrao: cod da ferramenta + extensao do arquivo

				If aCols[x][6] != cImgTmp
					If __CopyFile(aCols[x][6],cStartPath + cImgTmp)
						aCols[x][6] := cImgTmp
					Else
						Alert("Impossível copiar Imagem!")
						aCols[x][6] := ""
					EndIf
				EndIf
			EndIf

			RecLock("ZBC",.T.)
				ZBC->ZBC_FILIAL := xFilial("ZBC")
				ZBC->ZBC_NUMONT := ::cNumMont
				ZBC->ZBC_ITEM   := aCols[x][1]
				ZBC->ZBC_COD    := aCols[x][3]
				ZBC->ZBC_QTDE   := aCols[x][2]
				ZBC->ZBC_POS    := aCols[x][5]
				ZBC->ZBC_IMG01  := aCols[x][6]
				ZBC->ZBC_RV     := ::cRv
			MsUnLock("ZBC")
		EndIf
	Next 
	
	oDlg:End()
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ALTERA A MONTAGEM ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Altera() Class Montagem
Local cImgTmp    := ""

	If !::Valida()
		Return
	EndIf
	
  	//se a imagem for diferente copia denovo para o servidor
	cImgTmp := AllTrim(::cNumMont) + Right(AllTrim(::cImg01),4)
			
	If ::cImg01 != cImgTmp
		If ::cImg01 != cImgTmp
			If __CopyFile(::cImg01,cStartPath + cImgTmp)
				::cImg01 := cImgTmp
			Else
				Alert("Impossível copiar Imagem!")
				::cImg01 := ""
			EndIf
		EndIf
	EndIf

	ZBJ->(DbSetOrder(1))//filial + numont
	If ZBJ->(DbSeek(xFilial("ZBJ")+::cNumMont))
		RecLock("ZBJ",.F.)
			ZBJ->ZBJ_NUMONT := ::cNumMont
			ZBJ->ZBJ_IMG01  := ::cImg01
			ZBJ->ZBJ_DESC   := ::cDescMont
			ZBJ->ZBJ_CC     := ::cCC
			ZBJ->ZBJ_RV     := ::cRv
			ZBJ->ZBJ_ELABOR := ::cElabor
			ZBJ->ZBJ_OPERAC := ::cOperacao
		MsUnLock("ZBJ")
	Else
		Alert("Não foi possível Alterar!")
		Return .F.
	EndIf
	
	ZBC->(DbSetOrder(1)) //filial + numont + item
	For x:=1 to Len(aCols)
	    If !Acols[x][len(aHeader)+1]//nao pega quanto a linha esta deletada

		  	//copia a imagem para o servidor e altera o nome para gravar no banco de dados
    		If !Empty(aCols[x][6])
				cImgTmp := AllTrim(aCols[x][3]) + Right(ALLTRIM(aCols[x][6]),4)//padrao: cod da ferramenta + extensao do arquivo

				If aCols[x][6] != cImgTmp
					If __CopyFile(aCols[x][6],cStartPath + cImgTmp)
						aCols[x][6] := cImgTmp
					Else
						Alert("Impossível copiar Imagem!")
						aCols[x][6] := ""
					EndIf
				EndIf
			EndIf


		    If ZBC->(DbSeek(xFilial("ZBC")+::cNumMont+aCols[x][1]))
		   	    RecLock("ZBC",.F.)
					ZBC->ZBC_ITEM   := aCols[x][1]
					ZBC->ZBC_COD    := aCols[x][3]
					ZBC->ZBC_QTDE   := aCols[x][2]
					ZBC->ZBC_POS    := aCols[x][5]
					ZBC->ZBC_IMG01  := aCols[x][6]
					ZBC->ZBC_RV     := ::cRv
				MsUnLock("ZBC")    		
			Else
				RecLock("ZBC",.T.)
					ZBC->ZBC_FILIAL := xFilial("ZBC")
					ZBC->ZBC_NUMONT := ::cNumMont
					ZBC->ZBC_ITEM   := aCols[x][1]
					ZBC->ZBC_COD    := aCols[x][3]
					ZBC->ZBC_QTDE   := aCols[x][2]
					ZBC->ZBC_POS    := aCols[x][5]
					ZBC->ZBC_IMG01  := aCols[x][6]
					ZBC->ZBC_RV     := ::cRv
				MsUnLock("ZBC")
			EndIf
		Else
			If ZBC->(DbSeek(xFilial("ZBC")+::cNumMont+aCols[x][1]))
				RecLock("ZBC",.F.)
					ZBC->(DbDelete())
				MsUnLock("ZBC")
		    EndIf
		EndIf
	Next
    
    oDlg:End()
	
Return  


// GRAVA REVISAO DA MONTAGEM NO BANCO DE DADOS 
Method Revisao() Class Montagem
Local cImgTmp    := ""

     
  	//copia a imagem para o servidor e altera o nome para gravar no banco de dados
    If !Empty(::cImg01)
		cImgTmp := AllTrim(::cNumMont) + ALLTRIM(::cRv) + Right(ALLTRIM(::cImg01),4)//padrao: numero da montagem + extensao do arquivo
				
		If ::cImg01 != cImgTmp
			If __CopyFile(::cImg01,cStartPath + cImgTmp)
				::cImg01 := cImgTmp
			Else
				Alert("Impossível copiar Imagem!")
				::cImg01 := ""
			EndIf
		EndIf
	EndIf

	RecLock("ZBJ",.F.)
		ZBJ->ZBJ_OBSOL  := 'S'
	MsUnLock("ZBJ")


	//grava os dados da montagem
	RecLock("ZBJ",.T.)
		ZBJ->ZBJ_FILIAL := xFilial("ZBJ")
		ZBJ->ZBJ_NUMONT := ::cNumMont
		ZBJ->ZBJ_DESC   := ::cDescMont
		ZBJ->ZBJ_CC     := ::cCC
		ZBJ->ZBJ_IMG01  := ::cImg01
		ZBJ->ZBJ_RV     := ::cRv
		ZBJ->ZBJ_ELABOR := ::cElabor
		ZBJ->ZBJ_OBS1   := _cObs1
		ZBJ->ZBJ_OBS2   := _cObs2
		ZBJ->ZBJ_OPERAC := ::cOperacao
	MsUnLock("ZBJ")
	
	//grava os itens da montagem
	For x:=1 to Len(Acols)
		If !Acols[x][len(aHeader)+1]//nao pega quanto a linha esta deletada

		  	//copia a imagem para o servidor e altera o nome para gravar no banco de dados
    		If !Empty(aCols[x][6])
				cImgTmp := AllTrim(aCols[x][3]) + Right(ALLTRIM(aCols[x][6]),4)//padrao: cod da ferramenta + extensao do arquivo

				If aCols[x][6] != cImgTmp
					If __CopyFile(aCols[x][6],cStartPath + cImgTmp)
						aCols[x][6] := cImgTmp
					Else
						Alert("Impossível copiar Imagem!")
						aCols[x][6] := ""
					EndIf
				EndIf
			EndIf

			RecLock("ZBC",.T.)
				ZBC->ZBC_FILIAL := xFilial("ZBC")
				ZBC->ZBC_NUMONT := ::cNumMont
				ZBC->ZBC_ITEM   := aCols[x][1]
				ZBC->ZBC_COD    := aCols[x][3]
				ZBC->ZBC_QTDE   := aCols[x][2]
				ZBC->ZBC_POS    := aCols[x][5]
				ZBC->ZBC_IMG01  := aCols[x][6]
				ZBC->ZBC_RV     := ::cRv
			MsUnLock("ZBC")
		EndIf
	Next 
	
	oDlg:End()
	
Return



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EXCLUI A MONTAGEM ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Exclui() Class Montagem
		
	If MsgYesNo("Tem certeza de que deseja excluir a Montagem?")
		ZBJ->(DbSetOrder(1))//filial + numont
		If ZBJ->(DbSeek(xFilial("ZBJ")+::cNumMont))
			WHILE ZBJ->(!EOF()) .AND. ZBJ->ZBJ_NUMONT==::cNumMont
				RecLock("ZBJ",.F.)
					ZBJ->(DbDelete())
				MsUnLock("ZBJ")
				ZBJ->(dbskip())
			Enddo
		EndIf
	
		ZBC->(DbSetOrder(1)) //filial + numont + item
		For x:=1 to Len(aCols)
		    If ZBC->(DbSeek(xFilial("ZBC")+::cNumMont))
		   	 	WHILE ZBC->(!EOF()) .AND. ZBC->ZBC_NUMONT == ::cNumMont  
			   	   
			   	    RecLock("ZBC",.F.)
						ZBC->(DbDelete())
					MsUnLock("ZBC")    		
					
					ZBC->(dbskip())
					
				Enddo
			EndIf
		Next	
	EndIf
	    
    oDlg:End()
    
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ REDIMENSIONA A IMAGEM ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method AjustaImg(oImg,oScroll) Class Montagem
	If oImg:lautosize 
		oImg:lautosize := .F.
		oImg:nWidth    := 300
		oImg:nHeight   := 210
		oImg:lstretch  := .T.
		oScroll:nstyle := 0
	Else
		oImg:lstretch  := .f.
		oImg:nWidth    := 0
		oImg:nHeight   := 0
		oImg:lautosize := .t.
		oScroll:nstyle := 7
	EndIf
Return 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TELA PARA BUSCAR A IMAGEM          ³
//³ parametro: oImg = objeto da imagem ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method AlteraImg(oImg) Class Montagem

	::cImg01 := ""

	::RunDlg()
	::UpLoadImg(oImg)

/*
	//tela de dialogo
	oDlgImg := MsDialog():New(0,0,80,360,"Imagem",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
    oSayImg1 := tSay():New(10,5,{||"Imagem"},oDlgImg,,,,,,.T.,,)
    oGetImg1 := tGet():New(8,28,{|u| if(Pcount()>0,::cImg01 := u, ::cImg01)},oDlgImg,;
    		 110,8,"@!",/*valid*,,,,,,.T.,,,{||.F.},,,,,,,"::cImg01")
	
	oBtnImg1 := tButton():New(8,142 ,"Localizar",oDlgImg,{||::RunDlg()},36,10,,,,.T.)
	oBtnImg2 := tButton():New(25,101 ,"Ok",oDlgImg,{||::UpLoadImg(oImg)},36,10,,,,.T.)
	oBtnImg3 := tButton():New(25,142 ,"Cancelar",oDlgImg,{||oDlgImg:End()},36,10,,,,.T.)
	
	oDlgImg:Activate(,,,.T.,{||.T.},,{||})
*/

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BUSCA A IMAGEM ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method RunDlg() Class Montagem

	//cTipo := "Arquivos tipo     (*.DWG)  | *.DWG | "
	cTipo := "Desenhos          (*.BMP)  | *.BMP | "
	cTipo += "Desenhos          (*.JPG)  | *.JPG | "
	cTipo += "Desenhos          (*.GIF)  | *.GIF | "
	//cTipo += "Desenhos          (*.PDF)  | *.PDF   "

	::cImg01 := cGetFile(cTipo,,0,,.T.,49)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FAZ O UPLOAD DA IMAGEM                                 ³
//³ parametros:                                            ³
//³ cLocImg = endereco completo da imagem na maquina local ³
//³ oImg    = objeto da imagem							   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method UpLoadImg(oImg) Class Montagem
Local cBMP
Local _CRLF := CHR(13)+CHR(10)

	//valida o formato do arquivo
	If !UPPER(Right(::cImg01,4))$".JPG/.BMP/.GIF"
		Alert("Formato do arquivo inválido!"+_CRLF+;
			  "Por favor, escolha um arquivo de imagem do tipo JPG, GIF ou BMP")
		Return
	EndIf
	 
	oImg:cbmpfile  := cStartPath+"teste.jpg" //apaga do objeto o endereço da imagem atual 
	oImg:cbmpfile  := ::cImg01  //atribui o endereço da nova imagem
	oImg:lautosize := .F.
	oImg:lautosize := .T.      				 //força o tamanho da imagem
	oImg:lvisible  := .T.      				 //força a visualização da imagem
	
//	oDlgImg:End()
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FAZ A VISUALIZACAO DA IMAGEM ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method VisualizaImg(cImg) Class Montagem
Local aQPath    := QDOPATH()
Local cQPathTrm := aQPath[3]

	If Empty(cImg)
		Alert("Imagem não disponível!")
		Return
	EndIf
	
	If File(cImg)
		QA_OPENARQ(cImg)
	ElseIf File(cStartPath+cImg)
		CpyS2T(cStartPath+cImg,cQPathTrm,.T.)
		QA_OPENARQ(cQPathTrm+cImg)
 	Else
		Alert("Imagem não encontrada!")
		Return	
	EndIf

Return    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTA O NUMERO DA MONTAGEM ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method MontaNum() Class Montagem
Local nSeq := 1

	// Centro de custo 6 digitos
	If SM0->M0_CODIGO == 'NH'	
		CTT->(DbSetOrder(1)) 
		IF CTT->(DbSeek(xFilial("CTT")+::cCC))
			cDescCC := CTT->CTT_DESC01
			oGet4:Refresh()
		Else
			Alert("Centro de Custo não encontrado!")
			Return .F.
		EndIf

		ZBJ->(DbSetOrder(1)) // FILIAL + NUMONT
		IF ZBJ->(DbSeek(xFilial("ZBJ")+::cCC))
			WHILE ZBJ->(!EOF()) .AND. SUBSTR(ZBJ->ZBJ_NUMONT,1,6)==::cCC
				nSeq := Val(Right(AllTrim(ZBJ->ZBJ_NUMONT),3))+1
				ZBJ->(DBSKIP())
			ENDDO
		ENDIF
	
		::cNumMont := Alltrim(::cCC)+"."+StrZero(nSeq,3)
		::cRv      := '000'
		oGet1:Refresh()

	Else 
		// Centro de custo 8 digitos

		CTT->(DbSetOrder(1)) 
		IF CTT->(DbSeek(xFilial("CTT")+::cCC))
			cDescCC := CTT->CTT_DESC01
			oGet4:Refresh()
		Else
			Alert("Centro de Custo não encontrado!")
			Return .F.
		EndIf

		ZBJ->(DbSetOrder(1)) // FILIAL + NUMONT
		IF ZBJ->(DbSeek(xFilial("ZBJ")+::cCC))
			WHILE ZBJ->(!EOF()) .AND. SUBSTR(ZBJ->ZBJ_NUMONT,1,8)==::cCC
				nSeq := Val(Right(AllTrim(ZBJ->ZBJ_NUMONT),3))+1
				ZBJ->(DBSKIP())
			ENDDO
		ENDIF
	
		::cNumMont := ::cCC+"."+StrZero(nSeq,3)
		::cRv      := '000'
		oGet1:Refresh()

	Endif	
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ4¿
//³ TRAZ O ENDERECO DA IMAGEM PARA O ACOLS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ4Ù
Method IncDes() Class Montagem
Local nCol := oGetD:OBrowse:ColPos//retorna a coluna em que o cursor está focando
Local nPos := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="ZBC_IMG01"})

	If nPar==3 .Or. nPar == 4//incluir ou alterar
		If nCol != nPos	
			Return
		EndIf
		
		//cTipo := "Arquivos tipo     (*.DWG)  | *.DWG | "
		cTipo := "Desenhos          (*.JPG)  | *.JPG | "
		cTipo += "Desenhos          (*.BMP)  | *.BMP | "
		cTipo += "Desenhos          (*.GIF)  | *.GIF   "
		    
		aCols[n][nPos] := cGetFile(cTipo,,0,,.T.,49)
		                                            
		oGetD:Refresh()
	EndIf
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Destroi o Objeto ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Destroy() Class Montagem
	Super:Destroy()
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ A DESCRICAO DO PRODUTO NO MULTILINE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function EST143PRD()
Local nPosDes := aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="B1_DESC"}) 

	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+M->ZBC_COD))
		aCols[n][nPosDes] := SB1->B1_DESC
		oGetD:Refresh()
	Else
		Alert("Produto não encontrado!")
		Return .F.
	EndIf
		
Return .T.
           
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PARA INICIALIZAR O CAMPO DE ITEM NO GETDADOS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function ZBCItmIni()
Local nItem  := 0
Local nItem1 := 0
Local nItem2 := 0

	ZBC->(DbSetOrder(1)) //ZBC_FILIAL+ZBC_NUMONT+ZBC_ITEM
	If ZBC->(DbSeek(xFilial("ZBC")+oMontagem:cNumMont))
		WHILE ZBC->(!EOF()) .AND. ZBC->ZBC_NUMONT == oMontagem:cNumMont
			nItem1 := VAL(ZBC->ZBC_ITEM)
 			ZBC->(DbSkip())
		ENDDO
	EndIf
	
	If Len(aCols)==1 .AND. aCols[1][1]==1
		nItem2 := 0
	Else
		for x:=1 to Len(aCols)-1
			nItem2 := Val(aCols[x][1])
		Next
	EndIf
	nItem2++
	
	nItem := Iif(nItem2 > nItem1, nItem2, nItem1)
	
Return (StrZero(nItem,4))

            
// Funcao login
Method  ChekResp() class montagem

Local lRet := .f.
Local _aGrupo, _cLogin 
Local _cCusto := ::cCc
ZCR->(dbSetOrder(3))

_aGrupo  := pswret()     // Retorna vetor com dados do usuario
_cLogin  := Alltrim(_agrupo[1,2]) // Apelido


ZCR->(DbSeek(xFilial("ZCR")+_cLogin))
While !ZCR->(Eof()) .AND. Alltrim(ZCR->ZCR_LOGIN) == _cLogin
//	If nPar==3 .and. (Alltrim(ZCR->ZCR_CC) == Alltrim(_cCusto) .OR. alltrim(ZCR->ZCR_CC)=='<todos>') .AND. ZCR->ZCR_RESP == 'E' //-- Retirado a pedido de Edson J. Gomes. OS 048976
	If nPar==3 .AND. ZCR->ZCR_RESP == 'E'
		lRet := .t.		
		Exit
	Endif	
	ZCR->(dbSkip())
Enddo 
	
If nPar==3 .and. !lRet
	Alert("Usuario " + Alltrim(_cLogin)+ " ,nao autorizado a incluir montagem.")
Endif


Return(lRet)       

// Aprovacao
User Function fApr143()
Local lRet := .f.
Local _aGrupo, _cLogin 
Local _cCusto := ZBJ->ZBJ_CC
ZCR->(dbSetOrder(3))

_aGrupo  := pswret()     // Retorna vetor com dados do usuario
_cLogin  := Alltrim(_agrupo[1,2]) // Apelido

ZCR->(DbSeek(xFilial("ZCR")+_cLogin))
While !ZCR->(Eof()) .AND. Alltrim(ZCR->ZCR_LOGIN) == _cLogin
	//If (Alltrim(ZCR->ZCR_CC) == '<todos>' .or. Alltrim(ZCR->ZCR_CC) == Alltrim(_cCusto)) .AND. ZCR->ZCR_RESP == 'A'
	If ZCR->ZCR_RESP == 'A'
		lRet := .t.		
		Exit                                       	
	Endif	
	ZCR->(dbSkip())
Enddo 
	
If !lRet
	Alert("Usuario " + Alltrim(_cLogin)+ " ,nao autorizado Aprovar lancamento")

Else
	If MsgBox("Confirma Aprovacao do documento","Aprovacao","YESNO")

		RecLock("ZBJ",.F.)
			ZBJ->ZBJ_APROV   := _cLogin  
			ZBJ->ZBJ_DTAPRO  := dDataBase
		MsUnLock("ZBJ")

		MsgBox("Documento aprovado em: "+Dtoc(dDataBase)+"    Aprovador: "+_cLogin,"Aprovacao","ALERT")

	Endif
Endif	

Return(lRet)


Static Function f143Obs()
//SetPrvt("_cObs1,_cObs2")
_cObs1 := _cObs2 := Space(100)

@ 200,050 To 350,650 Dialog DlgObs Title OemToAnsi("Motivo da Revisao")

@ 010,010 Get _cObs1   Picture "@!" Size 280,8
@ 025,010 Get _cObs2   Picture "@!" Size 280,8
     
@ 045,130 BMPBUTTON TYPE 01 ACTION fGrava()
Activate Dialog DlgObs CENTERED
	
Return

Static Function fGrava()
	Close(DlgObs)
Return(.T.)