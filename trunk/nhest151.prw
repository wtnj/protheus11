/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST151  �Autor  �Jo�o Felipe da Rosa � Data �  28/08/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     � SOLICITA��O DE EPI                                         ���                                                        
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE / CUSTOS                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/* teste*/
#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

User Function NHEST151()

Private aRotina, cCadastro

cCadastro := "Solicita��o de EPI"
aRotina   := {}
aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"      , 0 , 1})
aAdd(aRotina,{ "Visualizar"	    ,"U_EST151"      , 0 , 2})
aAdd(aRotina,{ "Incluir"		,"U_EST151"      , 0 , 3})
aAdd(aRotina,{ "Imprimir"		,"U_NHEST169()"  , 0 , 3})
aAdd(aRotina,{ "Excluir"        ,"U_EST151"      , 0 , 5})
aAdd(aRotina,{ "EPI x CC"		,"U_151EPICC()"  , 0 , 3})
aAdd(aRotina,{ "Legenda"        ,"U_151leg()"    , 0 , 5})
//aAdd(aRotina,{ "Atualiza UM"    ,"Processa({||U_ATUUM()},'Atualizando unidades de medida...')"   , 0 , 3})

mBrowse(6,1,22,75,"ZDC",,,,,,fCriaCor())

Return

//��������������������
//� TELA DO CADASTRO �
//��������������������
User Function EST151(cAlias,nReg,nOpc) 
Local bOk        := {||}
Local bCanc      := {||oDlg:End()}
Local bEnchoice  := {||}
Local aTurno     := {"","1=Primeiro","2=Segundo","3=Terceiro"}
Private aEPI     := {}
Private aFUN     := {}
Private aSize    := MsAdvSize()
Private nPar     := nOpc
Private cNum     := ""
Private cNumSA   := ""
Private dData    := CtoD("  /  /  ")
Private cSolic   := ""
Private cTurno   := ""
Private aCC      := {}
Private ACAMPOS  := {}
Private cMarca   := GetMark()
Private aSelecao := {} //itens que foram selecionados para gravar a solicitacao dos epis
Private cEmail   := ""
Private ltodos   := .F. // usu�rio pode escolher o C.Custo ? (s/n)
Private dDtRet   := CToD("  /  /  ")
Private lExclui  := .F.
Private cLocal   := space(2)

	If nPar==2     //visualizar
		If !fInicio()
			Return
		EndIf

	    bOk := {|| oDlg:End()}
	ElseIf nPar==3 //incluir 
	
		//inicializa as vari�veis
		cNum   := GetSxENum("ZDC","ZDC_NUM")
		dData  := date()
		cSolic := AllTrim(Upper(cUserName))
		cLocal := Iif(SM0->M0_CODIGO=='NH','01',Iif(SM0->M0_CODFIL=="02","51","31"))
		
		//verifica se o usu�rio logado possui cadastro v�lido no QAA
		QAA->(dbSetOrder(6)) //LOGIN
		If !QAA->(dbSeek(cSolic))
			Alert("Usu�rio n�o cadastrado! Cadastro de Usu�rios!")
			Return .F.
		Else
			cEmail := AllTrim(QAA->QAA_EMAIL)
		EndIf
        
		Processa({|| fInicio()}, "Carregando informa��es ...")
		
		bOk := {|| Processa({||fInclui()},"Gerando Solicita��o ao Almox...")}
		bCanc := {||RollBackSx8(), oDlg:End()}

	ElseIf nPar==5 //excluir

		//EXCLUI A REQUISICAO DA TABELA SCQ
		SCQ->(dbSetOrder(1))
		SCQ->(dbSeek(xFilial("SCQ")+cNumSA))
		WHILE SCQ->(!EOF()) .AND. SCQ->CQ_NUM==cNumSA
			If !EMPTY(SCQ->CQ_NUMREQ)
				lExclui := .T.
			EndIf

			SCQ->(dbSkip())
		ENDDO
		
		If lExclui
			Alert("Imposs�vel excluir!"+CHR(13)+CHR(10)+"Um ou mais �tens desta solicita��o j� foram baixados!")
			Return .F.
		EndIf

		Processa({|| fInicio()}, "Carregando informa��es ...")
		bOk := {|| fExclui()}
		
	Else
		MsgBox("Usu�rio sem permiss�o para executar esta opera��o!","Par "+ALLTRIM(STR(nPar)),"INFO")
		Return
	EndIf

	oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)

	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}
			
	oDlg := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Solicita��o de EPI",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	TSay():New(18,10,{||"N�mero"},oDlg,,,,,,.T.,,)
	TSay():New(18,50,{||cNum},oDlg,,oFont1,,,,.T.,,)

	TSay():New(18,150,{||"Data"},oDlg,,,,,,.T.,,)
	TGet():New(16,195,{|u| if(Pcount() > 0, dData := u,dData)},oDlg,45,8,"99/99/99",{||.T.},,,,,,.T.,,,{||.F.})

	TSay():New(29,10,{||"Solicitante"},oDlg,,,,,,.T.,,)
	TGet():New(27,50,{|u| if(Pcount() > 0, cSolic := u,cSolic)},oDlg,45,8,"@!",{||.T.},,,,,,.T.,,,{||.F.})

	TSay():New(29,150,{||"N�mero S.A."},oDlg,,,,,,.T.,,)
	TGet():New(27,195,{|u| if(Pcount() > 0, cNumSA := u,cNumSA)},oDlg,45,8,"@!",{||.T.},,,,,,.T.,,,{||.F.})
	
	TSay():New(40,10,{||"Turno"},oDlg,,,,,,.T.,CLR_HBLUE,)
	TComboBox():New(38,50,{|u| if(Pcount() > 0,cTurno:= u,cTurno)},aTurno,50,20,oDlg,,{||},,,,.T.,,,,{|| nPar==3})

	TSay():New(40,150,{||"Data de Retirada"},oDlg,,,,,,.T.,CLR_HBLUE,)
	TGet():New(38,195,{|u| if(Pcount() > 0, dDtRet := u,dDtRet)},oDlg,45,8,"99/99/99",{||ValDtRet()},,,,,,.T.,,,{||nPar==3})

	TSay():New(51,10,{||"Local"},oDlg,,,,,,.T.,CLR_HBLUE,)
	TGet():New(49,50,{|u| if(Pcount() > 0, cLocal := u,cLocal)},oDlg,15,8,"@!",{||.t.},,,,,,.T.,,,{||nPar==3 .and. SM0->M0_CODIGO=='FN'})

	//���������������������������������������Ŀ
	//� Constr�i tela para sele��o de CCustos �
	//�����������������������������������������
	aCampos := {}               
	Aadd(aCampos,{"OK"     ,,""          })
	Aadd(aCampos,{"CCUSTO" ,,"C.Custo"   })
	Aadd(aCampos,{"DESCCC" ,,"Descri��o" })

	oMark1 := MsSelect():New("CCT","OK",nil,aCampos,.F.,@cMarca,{62,10,119,300})
	oMark1:oBrowse:bChange := {|| fTrazFun(.F.) }
	oMark1:bMark := {||Processa({||fTrazFun(.T.)},"Carregando funcion�rios...")}

	aCampos := {}
	Aadd(aCampos,{"OK"     ,,""            })
	Aadd(aCampos,{"MAT"    ,,"Matr�cula"   })
	Aadd(aCampos,{"NOME"   ,,"Nome"        })
	Aadd(aCampos,{"OP"     ,,"Opera��o"    })

	oMark2 := MsSelect():New("FUN","OK",nil,aCampos,.F.,@cMarca,{122,10,194,300})
	oMark2:oBrowse:bChange := {||fTrazEPI()}
	oMark2:bMark := {||fMarkFun()}
	
	aCampos := {}
	Aadd(aCampos,{"OK"     ,,""            })
	Aadd(aCampos,{"EPI"    ,,"EPI"         })
	Aadd(aCampos,{"DESC"   ,,"Descri��o"   })

	oMark3 := MsSelect():New("EPI","OK",nil,aCampos,.F.,@cMarca,{197,10,268,300})
	oMark3:bMark := {|| Processa({||fMarkEPI()},'Carregando ...')}

	//BOTOES MARCA DESMARCA
	oBtn1 := tButton():New(62 ,305,"Marcar Todos"    ,oDlg,{||fMarkAll(oMark1,.T.,"CCT")},70,10,,,,.T.)
	oBtn2 := tButton():New(75 ,305,"Desmarcar Todos" ,oDlg,{||fMarkAll(oMark1,.F.,"CCT")},70,10,,,,.T.)
//	If ltodos
	oBtn3 := tButton():New(88  ,305,"C.Custo"         ,oDlg,{||fChoseCC()},70,10,,,,.T.)
	oBtn4 := tButton():New(101 ,305,"Consulta Matr�cula"       ,oDlg,{||fConsMat()},70,10,,,,.T.)
//	EndIf
	
	oBtn1 := tButton():New(122,305,"Marcar Todos"    ,oDlg,{||fMarkAll(oMark2,.T.,"FUN")},70,10,,,,.T.)
	oBtn2 := tButton():New(135,305,"Desmarcar Todos" ,oDlg,{||fMarkAll(oMark2,.F.,"FUN")},70,10,,,,.T.)
	oBtn3 := tButton():New(148,305,"Altera Opera��o" ,oDlg,{||fAltOp()},70,10,,,,.T.)

	oBtn1 := tButton():New(197,305,"Marcar Todos"    ,oDlg,{||fMarkAll(oMark3,.T.,"EPI")},70,10,,,,.T.)
	oBtn2 := tButton():New(210,305,"Desmarcar Todos" ,oDlg,{||fMarkAll(oMark3,.F.,"EPI")},70,10,,,,.T.)
	
	oMark1:oBrowse:bWhen := {|| CCT->(!EOF()) }	 //-- evita erro log ao clicar quando estiver vazio
//	oMark2:oBrowse:bWhen := {|| FUN->(!EOF()) }	 //-- evita erro log ao clicar quando estiver vazio
	oMark3:oBrowse:bWhen := {|| EPI->(!EOF()) }	 //-- evita erro log ao clicar quando estiver vazio
	
	If nPar==2 .or. nPar==5 //visualiza ou exclui
		oMark1:oBrowse:lReadOnly := .T. //bWhen := {||.F.} //desabilita o markbrowse para edicao
		oMark2:oBrowse:lReadOnly := .T. //bWhen := {||.F.} //desabilita o markbrowse para edicao
		oMark3:oBrowse:lReadOnly := .T. //bWhen := {||.F.} //desabilita o markbrowse para edicao
	EndIf

	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)
	
	CCT->(dbCloseArea())
	FUN->(dbCloseArea())
	EPI->(dbCloseArea())

Return

User Function E151RET(lTurno)
Local cRet := ""
Default lTurno := .F.
	cRet := Posicione("ZDC",1,xFilial("ZDC")+SCP->CP_NUMSEPI,Iif(lTurno,"ZDC_TURNO","ZDC_DTRET"))
Return cRet

//-- valida a data de retirada
Static Function ValDtRet()
	If !Empty(dDtRet)
		If dDtRet < dDataBase
			Alert('Data de Retirada deve ser igual ou maior que a data de hoje!')
			Return .F.
		EndIf
	EndIF
Return .T.

//�����������������������������������������Ŀ
//� INICIALIZA A TELA DE SOLICITACAO DE EPI �
//�������������������������������������������
Static Function	fInicio()
Local lExclui := .F.
Local cAl  := 'SOLEPI'
Local cCC  := ''
Local cMat := ''
Local cEpi := ''

	If nPar==2 .or. nPar==5 //visualiza ou excluir
		cNum   := ZDC->ZDC_NUM
		dData  := ZDC->ZDC_DATA
		cSolic := ZDC->ZDC_SOLIC
		cNumSA := AllTrim(ZDC->ZDC_NUMSA)
		dDtRet := ZDC->ZDC_DTRET
		cTurno := ZDC->ZDC_TURNO
	EndIf

	//���������������������������������������Ŀ
	//� Criando Arquivo Temporario de C.Custo �
	//�����������������������������������������
	If !Select("CCT") > 0
		_cArqDBF  := CriaTrab(NIL,.f.)
		_cArqDBF += ".DBF"
		_aFields := {}
		
		AADD(_aFields,{"OK"      ,"C", 02,0})         // Controle do browse
		AADD(_aFields,{"CCUSTO"  ,"C", 09,0})         // Centro de custo
		AADD(_aFields,{"DESCCC"  ,"C", 50,0})         // Centro de custo
		
		DbCreate(_cArqDBF,_aFields)
		DbUseArea(.T.,,_cArqDBF,"CCT",.F.)

	EndIf

	fEpiQuery(.F.,cAl,nil)
      
 	/*
 	//-- verifica se o usuario logado possui o acesso a todos os CC na tabela ZRJ
	ZRJ->(dbSetOrder(1))
	ltodos := ZRJ->(dbSeek(xFilial("ZRJ")+PadR(cSolic,TamSx3("ZRJ_LOGIN")[1])+'<todos>'))
	
    fAtuArray(cAl)
	*/
	
	//�������������������������������������������Ŀ
	//� CRIA O DBF QUE IR� CONTER OS FUNCION�RIOS �
	//���������������������������������������������
	If !Select("FUN") > 0
		_cArqDBF := CriaTrab(NIL,.f.)
		_cArqDBF += ".DBF"
		_aFields := {}
	
		AADD(_aFields,{"OK"      ,"C", 02,0})         // Controle do browse
		AADD(_aFields,{"MAT"     ,"C", 06,0})         // MATRICULA
		AADD(_aFields,{"NOME"    ,"C", 50,0})         // NOME
		AADD(_aFields,{"OP"      ,"C", 03,0})         // OPERACAO
	
		DbCreate(_cArqDBF,_aFields)
		DbUseArea(.T.,,_cArqDBF,"FUN",.F.)
    EndIf
	
	//����������������������������������������������������Ŀ
	//� CRIA O DBF QUE IR� CONTER OS EPIS DOS FUNCION�RIOS �
	//������������������������������������������������������
	If !Select("EPI") > 0
		_cArqDBF := CriaTrab(NIL,.f.)
		_cArqDBF += ".DBF"
		_aFields := {}
		
		AADD(_aFields,{"OK"      ,"C", 02,0})         // Controle do browse
		AADD(_aFields,{"EPI"     ,"C", 15,0})         // PRODUTO
		AADD(_aFields,{"DESC"    ,"C", 50,0})         // DESCRICAO

		DbCreate(_cArqDBF,_aFields)
		DbUseArea(.T.,,_cArqDBF,"EPI",.F.)
	EndIf

//	aSort(aFun,,,{|x,y| x[1]+x[3] < y[1]+y[3]}) //ordena por centro de custo
//	aSort(aEPI,,,{|x,y| x[1]+x[4] < y[1]+y[4]}) //ordena por matricula

	If nPar==2 .or. nPar==5 //visualizar ou excluir
		ZDC->(dbGoTop())
		ZDC->(dbSetOrder(1)) // FILIAL + NUM
		ZDC->(dbSeek(xFilial("ZDC")+cNum))
		
		WHILE ZDC->(!EOF()) .AND. ZDC->ZDC_NUM==cNum
		  	
		  	//MARCA O CC QUE ESTA NO ZDC
		  	CCT->(dbgotop())
		  	WHILE CCT->(!EOF())
		  	    If CCT->CCUSTO==ZDC->ZDC_CC
		  	    	RecLock("CCT",.F.)
		  	    		CCT->OK := cMarca
		  	    	MsUnLock("CCT")	
		  	    EndIf 	
		  		CCT->(dbSkip())
		  	ENDDO
		  	
		  	//MARCA OS FUNCIONARIOS ENCONTRADOS NO ZDC
		  	_nFun := aScan(aFun,{|x| x[3]==ZDC->ZDC_MAT})
		  	If _nFun!=0
		  		aFun[_nFun][2] := cMarca
		  	EndIf
		  	
		  	//MARCA OS EPIS QUE FORAM ENCONTRADOS NO ZDC
		  	_nEPI := aScan(aEPI,{|x| x[3]==ZDC->ZDC_PROD .AND. x[1]==ZDC->ZDC_MAT})
		  	If _nEPI!=0
		  		aEPI[_nEPI][2] := cMarca
		  	EndIf
			
			ZDC->(dbSkip())
		ENDDO
	
	EndIf
	
	(cAl)->(dbCloseArea())
	CCT->(dbGoTop())

Return .T.

//Esta query traz todos os centros de custo cujo funcion�rio logado tem permiss�o
//destes centros de custo, traz todos os funcion�rios que pertencem a este cc na tabela ZRG
//destes funcion�rios, traz todos os epi's caso existam cadastrados na tabela ZDD 
Static Function fEpiQuery(lAddNew,cAl,cNewCC)
Local cZrjInn  := "%"
Default cNewCC := ''            
	
	If lAddNew
		cZrjInn += " AND ZRG.ZRG_CC = '"+cNewCC+"' "
	Else    
   		cZrjInn += " INNER JOIN "+RetSQLName("ZRJ")+" ZRJ ON "
		cZrjInn += " ZRJ.ZRJ_CC = ZRG.ZRG_CC "
		cZrjInn += " AND ZRJ.D_E_L_E_T_ = ' ' "
		cZrjInn += " AND ZRJ.ZRJ_FILIAL = '"+xFilial("ZRJ")+"' "
		cZrjInn += " AND ZRJ.ZRJ_LOGIN = '"+cSolic+"' "
	EndIf       
	
	cZrjInn += "%"
	
    /*
	beginSql Alias cAl
	
		SELECT
			ZRG.ZRG_CC cc,
			CTT.CTT_DESC01 dcc,
			ZRG.ZRG_MAT mat, 
			ZRG.ZRG_NOME nome, 
			ZRG.ZRG_OP op,
			ZDD.ZDD_CODEPI epi,
			(
				SELECT 
					SB1.B1_DESC 
				FROM  
					%Table:SB1% SB1 
				WHERE
					SB1.B1_COD = ZDD.ZDD_CODEPI
					AND SB1.D_E_L_E_T_ = ' '
					AND SB1.B1_FILIAL = %xFilial:SB1%
					AND SB1.B1_MSBLQL <> '1'
			) depi
		FROM 
			%Table:ZDD% ZDD, 
			%Table:ZRG% ZRG, 
			%Table:CTT% CTT 
			%Exp:cFrom%
			
		WHERE 
			ZRG.ZRG_CC = CTT.CTT_CUSTO    
			%Exp:cWhere%
			AND ZDD.ZDD_CC = ZRG.ZRG_CC
			AND ZDD.ZDD_OP = ZRG.ZRG_OP
			AND ZRG.D_E_L_E_T_ = ' '
			AND CTT.D_E_L_E_T_ = ' '
			AND ZDD.D_E_L_E_T_ = ' '
			AND ZRG.ZRG_FILIAL = %xFilial:ZRG%
			AND ZDD.ZDD_FILIAL = %xFilial:ZDD%
			AND CTT.CTT_FILIAL = %xFilial:CTT%
		    
		    
		    
		    
		ORDER BY ZRG.ZRG_CC, ZRG.ZRG_MAT
		
	endSql 
	*/                                  
	beginSql Alias cAl
	
	 SELECT 
	 	ZRG.ZRG_CC cc, 
	 	CTT.CTT_DESC01 dcc, 
	 	ZRG.ZRG_MAT mat, 
	 	ZRG.ZRG_NOME nome, 
	 	ZRG.ZRG_OP op, 
	 	ZDD.ZDD_CODEPI epi,  	
		 	( SELECT SB1.B1_DESC 
		   	  FROM  %Table:SB1% SB1 		   	  
		 	  WHERE SB1.B1_COD = ZDD.ZDD_CODEPI 
		 	  AND SB1.%notdel% 
		 	  AND SB1.B1_FILIAL = %xFilial:SB1%
	 		  AND SB1.B1_MSBLQL <> '1' ) depi 
	 FROM %Table:CTT% CTT 

	 INNER JOIN %Table:ZRG% ZRG ON 
 	 ZRG.ZRG_CC = CTT.CTT_CUSTO    
	 AND ZRG.ZRG_FILIAL =  %xFilial:ZRG%   
	 AND ZRG.%notdel%

  	 %Exp:cZrjInn%  	 

	 LEFT JOIN %Table:ZDD% ZDD ON
	 ZDD.ZDD_CC = ZRG.ZRG_CC  
	 AND ZDD.ZDD_OP = ZRG.ZRG_OP  
	 AND ZDD.%notdel%
	 AND ZDD.ZDD_FILIAL = %xFilial:ZDD% 
	 WHERE CTT.%notdel%
	 AND CTT.CTT_FILIAL = %xFilial:CTT% 
	 
	 ORDER BY ZRG.ZRG_CC, ZRG.ZRG_MAT
	 
	endSql

Return

//����������������������������������������������������������������Ŀ
//�Atualiza os arrays de acordo com o alias passado como par�metro �
//������������������������������������������������������������������
Static Function fAtuArray(cAl)
Local xAl := getNextAlias()
	
	While (cAl)->(!Eof())
	     
	     _n := aScan(aCC,{|x| AllTrim(x[1])==AllTrim((cAl)->cc) })
	     
	     If _n<>0
	     	(cAl)->(dbSkip())
	     	Loop
	     EndIf
	     
	     aAdd(aCC,{(cAl)->cc,(cAl)->dcc})

         //GRAVA OS CENTROS DE CUSTO NA TABELA TEMPORARIA CCT
	     RecLock("CCT",.T.)
	   	  	CCT->OK        := Space(02)
	   	  	CCT->CCUSTO    := (cAl)->cc
	   	  	CCT->DESCCC    := (cAl)->dcc
	   	 MsUnlock("CCT")

	     cCC := (cAl)->cc
	     
	     While (cAl)->(!Eof()) .and. cCC==(cAl)->cc

		    //ADICIONA OS FUNCIONARIOS NO ARRAY aFun
		    If Empty((cAl)->mat)
		    	(cAl)->(dbSkip())
		    	Loop
		    EndIf

			aAdd(aFun,{(cAl)->cc,Space(02),(cAl)->mat,(cAl)->nome,(cAl)->op})
		    cMat := (cAl)->mat
				
			beginSql Alias xAl
				SELECT 
					ZED_EPI epi, 
					B1_DESC depi
				FROM 
					%Table:ZED% ZED,
					%Table:SB1% SB1
				WHERE
					SB1.B1_COD = ZED.ZED_EPI
					AND ZED.ZED_FILIAL = %xFilial:ZED%
					AND SB1.B1_FILIAL = %xFilial:SB1%
					AND ZED.%NotDel%
					AND SB1.%NotDel%
					AND ZED.ZED_MAT = %Exp:cMat%
			endSql
			
			While (xAl)->(!eof())
				
				_n := aScan(aEPI,{|x| x[3]==(xAl)->epi .AND. x[1]==cMat})
				
				If _n==0
					//adiciona os epis de cada funcionario no array aEPI
					aAdd(aEPI,{cMat,Space(2),(xAl)->epi,(xAl)->depi,(cAl)->op})
				Endif
				
				(xAl)->(dbskip())
			Enddo
			
			(xAl)->(dbclosearea())
			While (cAl)->(!Eof()) .AND. (cAl)->mat==cMat
				
				If Empty((cAl)->epi)
					(cAl)->(dbSkip()) 
					Loop�
				EndIf
				
				//adiciona os epis de cada funcionario no array aEPI
				_n := aScan(aEPI,{|x| x[3]==(cAl)->epi .AND. x[1]==(cAl)->mat})
				
				If _n==0
					aAdd(aEPI,{(cAl)->mat,Space(2),(cAl)->epi,(cAl)->depi,(cAl)->op})
				Endif
				
				(cAl)->(dbSkip()) 
			EndDo
	    		
	     EndDo
		
	EndDo

Return

//��������������������������������������������������������Ŀ
//� TRAZ OS FUNCIONARIOS DOS CENTROS DE CUSTO SELECIONADOS �
//����������������������������������������������������������
Static Function fTrazFun(lDblClic)
Local aOld := getArea()

	//APAGA TODA A TABELA DE FUNCIONARIOS
	dbSelectArea("FUN")
	dbGoTop()
	ZAP

	If lDblClic
		If !CCT->(MARKED("OK"))
			If !MsgYesNo("Esta opera��o ir� desfazer as altera��es realizadas!"+Chr(13)+chr(10)+;
				         "Deseja continuar?")
				RecLock("CCT",.F.)
					CCT->OK := cMarca
				MsUnlock("CCT")
		    	
				Return
			EndIf
		EndIf
	EndIf

	_n := aScan(aFun,{|x| AllTrim(x[1])==AllTrim(CCT->CCUSTO)})
		
	If _n!=0
		While _n <= Len(aFun) .and. AllTrim(aFun[_n][1])==AllTrim(CCT->CCUSTO)
			If CCT->(MARKED("OK"))
		    	RecLock("FUN",.T.)
			      FUN->OK     := aFun[_n][2]
		   		  FUN->MAT    := aFun[_n][3]
			   	  FUN->NOME   := aFun[_n][4]
	   			  FUN->OP     := aFun[_n][5]
			    MsUnlock("FUN")
			Else
				aFun[_n][2] := Space(2)
			EndIf
			_n++
		EndDo
	EndIf
            
	
	FUN->(dbGoTop()) //posiciona o oMark2:obrowse no primeiro registro

	If FUN->(!EOF())
		oMark2:oBrowse:bWhen := {|| .t. }
		oMark2:oBrowse:lReadOnly := .F.
	Else                                
		oMark2:oBrowse:bWhen := {|| .F. }
		oMark2:oBrowse:lReadOnly := .t.
	EndIf
	
	oMark2:oBrowse:Refresh()

	fTrazEPI()
	
	restArea(aOld)
	
Return

//����������������������������������������������Ŀ
//� ATUALIZA OS EPIS QUANDO CLICA NO FUNCIONARIO �
//������������������������������������������������
Static Function fTrazEPI()
Local aOld := getArea()

	//Apaga o conte�do da tabela tempor�ria EPI
	dbSelectArea("EPI")
	dbGoTop()
	ZAP

	//TRAZ OS EPIS DO FUNCIONARIO
	aSort(aEPI,,,{|x,y| x[1]+x[4] < y[1]+y[4]}) //ordena por matriculaD
    _n := aScan(aEPI,{|x| AllTrim(x[1])==AllTrim(FUN->MAT)}) //posiciona no funcionario em questao
	 
 	If _n!=0
 		While _n <= Len(aEPI) .AND. AllTrim(aEPI[_n][1])==AllTrim(FUN->MAT)
			If FUN->(MARKED("OK")) //SE ESTIVER MARCANDO O FUNCIONARIO
				RecLock("EPI",.T.)
					EPI->OK   := aEPI[_n][2]
					EPI->EPI  := aEPI[_n][3]
					EPI->DESC := aEPI[_n][4]
				MsUnLock("EPI")		     
			Else//SE ESTIVER DESMARCANDO O FUNCIONARIO
				//DESMARCA TODOS OS EPIS
				aEPI[_n][2] := Space(2)
			EndIF			
		 			
 			_n++
	    EndDo
 	EndIf   
	 	                        
 	EPI->(dbGoTop())
	If EPI->(!EOF())
		oMark3:oBrowse:bWhen := {|| .t. }
		oMark3:oBrowse:lReadOnly := .F.
	Else                                
		oMark3:oBrowse:bWhen := {|| .F. }
		oMark3:oBrowse:lReadOnly := .t.
	EndIf

 	oMark3:oBrowse:Refresh()
	
	restArea(aOld)	

Return

//������������������������������������������������������Ŀ
//� FUNCAO CHAMADA NO MOMENTO EM QUE MARCA O FUNCIONARIO �
//��������������������������������������������������������
Static Function fMarkFun()

    _n := aScan(aFun,{|x| x[3]==FUN->MAT}) //posiciona no Funcionario do cc em questao 

 	If _n!=0
	    If FUN->(MARKED("OK")) //Se n�o estiver marcado
	 		aFun[_n][2] := cMarca //marca como ok
 		Else //se n�o estiver marcada
 			aFun[_n][2] := Space(2) //desmarca 
 		EndIf
 	EndIf	
	
	fTrazEPI()      
	
Return

//����������������������������������������������Ŀ
//� FUNCAO CHAMADA NO MOMENTO EM QUE MARCA O EPI �
//������������������������������������������������
Static Function fMarkEPI()
Local aSelecao2 := {}

	ProcRegua(3)
	
//	If SM0->M0_CODIGO=="NH"

	    If EPI->(MARKED("OK")) //Se estiver marcando o epi

			If empty(cLocal)
				Alert("Informe o Local!")

				//-- Desmarca o epi solicitado
   	     		RecLock("EPI")
       	 			EPI->OK := Space(2)
       			MsUnlock("EPI")
	
				Return .F.
			EndIf
			
			cProd := EPI->EPI

			SB2->(dbSetOrder(1))

		    If SM0->M0_CODIGO=="NH"
		    
			    If Alltrim(cProd)$"MS02.000530"              
	    	  		SB2->(DbSeek(xFilial("SB2")+"MS02.000247    "+cLocal))
	      			If (SB2->B2_QATU-SB2->B2_QEMPSA) > 0 //saldo atual - qtde empenhada de S.A.(solicitacao ao almoxarifado)
		         		MSGBOX('Favor Solicitar o Produto MS02.000247 a Quantidade Disponivel � : ' + Transform((SB2->B2_QATU-SB2->B2_QEMPSA),"@E 999,999.99"),OemToAnsi('Aten��o'),'ALERT')
	    	
						//-- Desmarca o epi solicitado
	         			RecLock("EPI")
	         				EPI->OK := Space(2)
		         		MsUnlock("EPI")
	    	
	        	 		Return .F.
	 		    	 Endif         
			    Endif

			EndIf
						    
		    If Alltrim(cProd)=='MS01.000264'
			    nQuant := 2
			ELSE
			    nQuant := 1			
			ENDIF
			
		    For xQ:=1 to Len(aSelecao)
		    	If aSelecao[xQ][3]==cProd
		    		
  				    If Alltrim(cProd)=='MS01.000264'
			    		nQuant+=2
			    	ELSE
			    		nQuant++
			    	ENDIF
			    	
		    	EndIf
		    Next
	        
	    	IncProc('Verificando saldo!')
	    	
			If SB2->(DbSeek(xFilial("SB2")+cProd+cLocal))
	      		If (SB2->B2_QATU-SB2->B2_QEMPSA) < nQuant //saldo atual - qtde empenhada de S.A.(solicitacao ao almoxarifado)
    	     		MSGBOX('Produto n�o tem saldo em estoque!',OemToAnsi('Aten��o'),'ALERT')
        	
					//-- Desmarca o epi solicitado
    	     		RecLock("EPI")
        	 			EPI->OK := Space(2)
         			MsUnlock("EPI")

	         		Return .F.
 			     Endif         
		    Endif   
		    
			//-- Verifica se j� n�o existe solicitacao aberta
			If fJaSolic(cProd,FUN->MAT)
				cMsg := "J� existe solicitacao do EPI " + AllTrim(cProd)
				cMsg += " para o funcion�rio " + AllTrim(Posicione("SRA",1,xFilial("SRA")+FUN->MAT,"RA_NOME")) + "!"
				cMsg += " Enquanto a solicita��o n�o for encerrada, n�o poder� fazer outra!"
				Alert(cMsg)

				//-- Desmarca o epi solicitado
   	     		RecLock("EPI")
       	 			EPI->OK := Space(2)
       			MsUnlock("EPI")
	
				Return .F.
			EndIf
 			    
		EndIf
//	EndIf

    _n := aScan(aEPI,{|x| x[1]==FUN->MAT .and. x[3]==EPI->EPI}) //posiciona no epi do funcionario em questao 

 	IncProc('Verificando restric��es!')
 	
 	If _n!=0
	    If EPI->(MARKED("OK")) //Se n�o estiver marcado, ou seja, est� marcando

			If Empty(cLocal)
				Alert("Informe o Local!")

				//-- Desmarca o epi solicitado
   	     		RecLock("EPI")
       	 			EPI->OK := Space(2)
       			MsUnlock("EPI")
	
				Return .F.
			EndIf

			//-- Se for solicita��o de BOTINA DE SEGURAN�A SEM BIQUEIRA DE A�O para armaz�m 31
			//-- S� � permitido para os funcion�rios com fun��o ELETR�NICO DE MANUTEN��O
			//-- Cfe chamado n� 010112 do portal, solicitado por ALMIRRR
            If cLocal=="31" .AND. AllTrim(EPI->EPI)$"MS01.000035/MS01.000036/MS01.000037/MS01.000038/MS01.000026/"+;
            								        "MS01.000027/MS01.000028/MS01.000029/MS01.000030/MS01.000031/"+;
            								        "MS01.000032/MS01.000033/MS01.000034"
                
            	If !Posicione("SRA",1,xFilial("SRA")+FUN->MAT,"RA_CODFUNC")$"0827/0509/0310/0866/0974/1827/1509"
   	        		Alert("Botina de Seguran�a SEM Biqueira de A�o s� � permitido para funcion�rio com fun��o eletr�nico!")

					//-- Desmarca o epi solicitado
   	    	 		RecLock("EPI")
       	 				EPI->OK := Space(2)
       				MsUnlock("EPI")

					If !Upper(AllTrim(cUsername))$"OSNIRZ/ADRIANAVR/GUILHERMEMB/LEANDROS/OZIELRV/OZIELRV/ALMIRRR/EVERTONG/JULIOKR/PAULORR/MARCILIOM/LUCASF/JACQUELINENV/CARLOSAS/ROGINALDO.VASCO/LOURIVALCC/ARIADSONMS/JONESTONBM/RAFAELB/POLIANARA/CARMENCITAAA/MERCIAMS"
    	        		Return .F.
  		        	EndIf
				Endif
            	
            EndIf

	 		aEPI[_n][2] := cMarca //marca como ok

			//Adiciona os itens selecionados no array aSelecao
			aAdd(aSelecao,{CCT->CCUSTO,; //C.Custo
						   FUN->MAT,;    //Matricula
			               EPI->EPI})    //codigo do epi
	 		
 		Else //se estiver marcada ent�o desmarca
 			
 			_nn := aScan(aSelecao,{|x| ALLTRIM(x[1])==ALLTRIM(CCT->CCUSTO) .and. ALLTRIM(x[2])==ALLTRIM(FUN->MAT) .and. ALLTRIM(x[3])==ALLTRIM(EPI->EPI)}) //verifica se o epi j� est� no array de selecao
 			
 			//retira o epi marcado do array aselecao
 			aSelecao2 := {}
 			For xS:=1 to Len(aSelecao)
 				If xS<>_nn
 					aAdd(aSelecao2,aSelecao[xS])
 				EndIf
 			Next
 			aSelecao := aClone(aSelecao2)
 			
 			aEPI[_n][2] := Space(2) //desmarca 
 		EndIf
 	EndIf	

 	IncProc('pronto')
 	 	
 	dbSelectArea("EPI")  

Return .T.

//��������Ŀ
//� VALIDA �
//����������
Static Function fValida()
Local lSaldo := .F.
Local dDtUltBx := cTod('  /  /  ')
Local dDurabil := 0
Local cMsgDurab := ''                    

//	aSelecao := {}
	
//	CCT->(dbGoTop())    

	//�������������������������������������������������������������Ŀ
	//� VERIFICA OS ITENS SELECIONADOS E ADICIONA NO ARRAY ASELECAO �
	//���������������������������������������������������������������
	//PERCORRE OS CENTROS DE CUSTO
/*
	WHILE CCT->(!EOF()) 

		IncProc()
	
		If CCT->(MARKED("OK")) //centro de custo esta marcado
			_nFun := aScan(aFun,{|x| AllTrim(x[1])==AllTrim(CCT->CCUSTO)})
                
			If _nFun!=0
				//Percorre o array de funcionarios enquanto o centro de custo for igual ao corrente
			    While _nFun <= len(aFun) .and. AllTrim(aFun[_nFun][1])==AllTrim(CCT->CCUSTO)
		    		
		    		If !Empty(aFun[_nFun][2]) //funcionario esta marcado
			    		_nEPI := aScan(aEPI,{|x| AllTrim(x[1])==AllTrim(aFun[_nFun][3])})
			    		If _nEPI!=0
			    			//Percorre o array de epis enquanto o funcionario for igual ao corrente
			    			While _nEPI <= Len(aEPI) .and. AllTrim(aEPI[_nEPI][1])==AllTrim(aFun[_nFun][3])
				    			                  
				    			If !Empty(aEPI[_nEPI][2]) //epi marcado

									//Adiciona os itens selecionados no array aSelecao
									aAdd(aSelecao,{aFun[_nFun][1],;   //C.Custo
												   aFun[_nFun][3],;   //Matricula
									               aEPI[_nEPI][3]})   //codigo do epi

					 			EndIf
					 			
					 			_nEPI++

			    			EndDo
			    		EndIf
			    	EndIf
			    	_nFun++
			    EndDo
			    	
		    EndIf
		
		EndIf
	     
		CCT->(dbSkip())
	ENDDO
*/
	
//	CCT->(dbGoTop())
	
	SB2->(DbsetOrder(1))
    SB1->(dbSetOrder(1)) //FILIAL + COD
	SRA->(dbSetOrder(1)) // FILIAL + MAT

	//pega a quantidade total de cada EPI's e verifica se tem saldo no SB2
	For x:=1 to Len(aSelecao)
		nQuant   := 0
		aFuncion := {}
		
		IncProc()
		
		For y:=1 to Len(aSelecao)
			
			//aglutina as quantidades para epis iguais
			If aSelecao[x][3]==aSelecao[y][3]
			    If Alltrim(aSelecao[x][3])=='MS01.000264'
					nQuant+=2
				ELSE
					nQuant++
				ENDIF
				
				If SRA->(dbSeek(xFilial("SRA")+ALLTRIM(aSelecao[y][2])))
					aAdd(aFuncion,ALLTRIM(SRA->RA_NOME)+" - "+SRA->RA_CC) //matricula
				EndIf
			EndIf
			
		Next
		
/*
		//-- Verifica se j� n�o existe solicitacao aberta
		If fJaSolic(aSelecao[x][3],aSelecao[x][2])
			cMsg := "J� existe solicitacao do EPI " + AllTrim(aSelecao[x][3])
			cMsg += " para o funcion�rio " + AllTrim(Posicione("SRA",1,xFilial("SRA")+aSelecao[x][2],"RA_NOME")) + "!"
			cMsg += " Enquanto a solicita��o n�o for encerrada, n�o poder� fazer outra!"
			Alert(cMsg)

			Return .F.
		EndIf
*/
		SB1->(dbSeek(xFilial("SB1")+aSelecao[x][3])) //posiciona na tabela SB1 para o epi solicitado
		
		If SM0->M0_CODIGO$"IT" .OR. SM0->M0_CODIGO$"FN"// .AND. alltrim(cLocal)$"21")
		
			//-- Verifica a durabilidade do epi 
			dDtUltBx := fUltBx(aSelecao[x][3],aSelecao[x][2]) // retorna a data da ultima baixa do epi para o funcionario
			dDurabil := SB1->B1_DURA
	
			//-- chamado 027460 portal
			//-- data: 07/02/2012
			//-- autor: joao felipe da rosa		
			cAlZED := getnextalioas()
			
			beginSql alias cAlZED
				SELECT MAX(ZED_DURAB) AS DURAB 
				FROM %Table:ZED%
				WHERE ZED_MAT = %Exp:aSelecao[x][2]%
				AND ZED_EPI = %Exp:aSelecao[x][3]%
				AND ZED_FILIAL = %xFilial:ZED%
				AND %NotDel%
			endSql
			
			If (cAlZED)->(!eof()) 
				If (cAlZED)->DURAB <> 0 .and. (cAlZED)->DURAB <> dDurabil
					dDurabil := (cAlZED)->DURAB
				Endif
			Endif
			
			(cAlZED)->(dbclosearea())
			//-- fim chamado 027460
			
			If (dDtUltBx + dDurabil) > date()                                                        
				//cMsgDurab := "D U R A B I L I D A D E !" + CHR(13)+CHR(10) + CHR(13)+CHR(10)
				cMsgDurab += " Funcion�rio " + Posicione("SRA",1,xFilial("SRA")+aSelecao[x][2],"RA_NOME")
				cMsgDurab += " EPI " + AllTrim(aSelecao[x][3]) + "!" + CHR(13)+CHR(10)
				cMsgDurab += " (Aguardar " + AllTrim(Str(dDurabil - (date() - dDtUltBx))) + " dias)" + CHR(13)+CHR(10)
				//cMsgDurab += " Em caso de urg�ncia, favor solicitar ao setor de Seguran�a do Trabalho para liberar o EPI!"
				
			EndIf
		
		EndIf
		
	   	If SB2->(DbSeek(xFilial("SB2")+aSelecao[x][3]+cLocal))
    		If nQuant > (SB2->B2_QATU-SB2->B2_QEMPSA) //saldo atual - qtde empenhada de S.A.(solicitacao ao almoxarifado)
				cMsg := 'O produto '+AllTrim(aSelecao[x][3])+' - '+SB1->B1_DESC+CHR(13)+CHR(10)
				cMsg += 'N�o tem saldo suficiente no estoque!'+chr(13)+chr(10)+chr(13)+chr(10)
				cMsg += 'Funcion�rios: '+CHR(13)+CHR(10)
				
				For _h:=1 to Len(aFuncion)
					cMsg += '       '+aFuncion[_h]+chr(13)+chr(10)
				Next

				cMsg += chr(13)+chr(10)
				cMsg += 'Qtde Solicitada : '+AllTrim(Str(nQuant))+chr(13)+chr(10)
				cMsg += 'Saldo no Estoque: '+AllTrim(Str(SB2->B2_QATU-SB2->B2_QEMPSA))+chr(13)+chr(10)

       			MSGBOX(cMsg,OemToAnsi('Aten��o'),'INFO')
       			
         		Return .F.
      		Endif  
   		Else
   			Alert("Produto n�o encontrado na tabela de Saldos (SB2)!")
   			Return .F.
   		Endif
		
	Next
	
	If !empty(cMsgDurab)
		cMsgDurab := "D U R A B I L I D A D E !" + CHR(13)+CHR(10) + CHR(13)+CHR(10) + ;
					 cMsgDurab + CHR(13)+CHR(10) //+ ;
//					 " Em caso de urg�ncia, favor solicitar ao setor de Seguran�a do Trabalho para liberar o EPI!"
		
		MSGBOX(cMsgDurab,'Aten��o','ALERT')

		If !AllTrim(Upper(cUserName))$"OSNIRZ/ALMIRRR/OZIELRV/EVERTONG/PAULORR/MARCILIOM/LUCASF/JOAOFR/ADMIN/ADMINISTRADOR/"+;
		                              "JACQUELINENV/CARLOSAS/ROGINALDO.VASCO/JULIANE.SANTOS/ALEXSANDRO.SANTOS/GUILHERMEMB/"+;
		                              "LOURIVALCC/ARIADSONMS/JONESTONBM/POLIANARA/LEANDROS/LEANDROLR/RAFAELB/CARMENCITAAA/MERCIAMS"
			Return .F.
		EndIf
	Endif
	
	
	If Empty(aSelecao)
		Alert("Solicite pelo menos 1 �tem!")
		Return .F.
	EndIf
	
	If Empty(cTurno)
		Alert("Informe o turno!")
		Return .F.
	EndIf
	
	If Empty(dDtRet)
		Alert("Informe a data de retirada!")
		Return .F.
	EndIf
	
	If Empty(cLocal)
		Alert("Informe o local!")
		REturn .F.
	EndIf
	
Return .T.

Static function fJaSolic(cEpi,cMatr)
Local cAl := 'JASOLIC'
Local lRet 

	beginSql Alias cAl
		SELECT 
			ZDC_NUM num
		FROM 
			%Table:ZDC% ZDC
		JOIN
			%Table:SCP% SCP
		ON
			ZDC.ZDC_NUM = SCP.CP_NUMSEPI
			AND SCP.CP_FILIAL = %xFilial:SCP%
			AND SCP.CP_STATUS <> 'E'
			AND SCP.D_E_L_E_T_ = ' '
		WHERE 
			ZDC.ZDC_FILIAL = %xFilial:ZDC%
			AND ZDC_MAT = %Exp:cMatr%
			AND ZDC_PROD = %Exp:cEpi%
			AND ZDC_DOC = ' '
			AND ZDC.D_E_L_E_T_ = ' '
	endSql
	
	lRet := (cAl)->(!Eof())
	
	(cAl)->(dbCloseArea())
	
Return lRet

Static Function fUltBx(cEpi,cMatr)
Local dDt := ctod('  /  /  ')
Local cAl := 'DURABIL'
	
	beginSql Alias cAl
		SELECT 
			TOP 1 D3.D3_EMISSAO data
		FROM 
			%Table:SD3% D3
		JOIN
			%Table:ZDC% ZDC
		ON
		    ZDC.ZDC_FILIAL = %xFilial:ZDC%
			AND ZDC.ZDC_DOC = D3.D3_DOC
			AND ZDC.ZDC_PROD = D3.D3_COD
			AND ZDC.ZDC_MAT = %Exp:cMatr%
			AND ZDC.ZDC_PROD = %Exp:cEpi%
		WHERE
			D3.D3_TM > '500'
			AND D3.D_E_L_E_T_ = ' '
			AND D3.D3_ESTORNO <> 'S'
		ORDER BY
			D3.R_E_C_N_O_ DESC
	endSql
	      
	If (cAl)->(!Eof())
		dDt := StoD((cAl)->data)
	EndIf

	(cAl)->(dbCloseArea())
		
Return dDt

//��������Ŀ
//� INCLUI �
//����������
Static Function fInclui()
Local nItem  := 0
Local aCab   := {}
Local aItens := {} 
Local aItem  := {}
PRIVATE _aSaveArea := {Alias(),recno(),IndexOrd()}
PRIVATE _cConta 
lMsErroAuto := .F.
	
	ProcRegua(Len(aSelecao))

	If !fValida()
		Return
	EndIf
	
	begin Transaction
	
	//cabe�alho para a rotina automatica de Sol. ao Almox.
	aCab:= {{"CP_SOLICIT",cSolic,NIL},;
			{"CP_EMISSAO",dData,NIL}}

	//grava os itens da solicitacao
    For x:=1 to Len(aSelecao)

	   SB1->(dbSetOrder(1))
	   SBM->(dbSetOrder(1))	
	   If SB1->(dbSeek(xFilial("SB1")+aSelecao[x][3]))
	
	      SBM->(DbSeek(xFilial("SBM")+SB1->B1_GRUPO,.T.))		// Procura no SBM o grupo digitado na solicitacao

		  Do Case 
		     Case SM0->M0_CODIGO == "NH"  //empresa new hubner	
		         If substr(aSelecao[x][1],1,1) $ "1/2"
			        _cConta := SBM->BM_CTAADM
			     Else // Empresa Fundi��o
                    _cConta := SBM->BM_CTADIR			     
			     Endif                                       
		     Case SM0->M0_CODIGO == "FN/IT"  //empresa new hubner				     
		         If substr(aSelecao[x][1],2,1) $ "3/4"
				    _cConta := SBM->BM_CTADIR
				 ElseIf substr(aSelecao[x][1],2,1) $ "7"
					_cConta := SBM->BM_CTAINOV
				 Else // Empresa Fundi��o
			        _cConta := SBM->BM_CTAADM
				 Endif	   
		  EndCase

	   Endif
		
		//pega o novo item
		nItem++
		cItem := StrZero(nItem,4)
		
		//grava na tabela de solicitacao de epi
		RecLock("ZDC",.T.)
			ZDC->ZDC_FILIAL := xFilial("ZDC")
			ZDC->ZDC_NUM    := cNum
			ZDC->ZDC_DATA   := dData
			ZDC->ZDC_SOLIC  := cSolic
			ZDC->ZDC_ITEM   := cItem
			ZDC->ZDC_TURNO  := cTurno
			ZDC->ZDC_DTRET  := dDtRet
			ZDC->ZDC_MAT    := aSelecao[x][2]
			ZDC->ZDC_CC     := aSelecao[x][1]
			ZDC->ZDC_PROD   := aSelecao[x][3]
		MsUnLock("ZDC")
		
	    If Alltrim(aSelecao[x][3])=='MS01.000264'
	    	nQuant := 2
	    Else
	    	nQuant := 1
	    Endif
		
		//adiciona o item para rotina automatica de Sol. ao Almox.
		aItem:={{"CP_ITEM"   ,Right(cItem,2) ,NIL},;
 		        {"CP_PRODUTO",aSelecao[x][3] ,NIL},;
 		        {"CP_QUANT"  ,nQuant         ,NIL},;
 		        {"CP_CC"     ,aSelecao[x][1] ,NIL},;
 		        {"CP_CONTA"  ,_cConta        ,NIL},;
 		        {"CP_DTRET"  ,dDtRet         ,NIL},;
 		        {"CP_TURNRET",cTurno         ,NIL}} 		        

		If SM0->M0_CODIGO$"FN/IT"
			aAdd(aItem,{"CP_LOCAL",cLocal,nil})
		EndIf
			
		aadd(aitens,aItem)
    
    Next
	
	SAH->(dbSetOrder(1))
	//������������������������������Ŀ
	//� Grava Pre-Requisicao         �
	//��������������������������������
	MSExecAuto({|x,y,z| mata105(x,y,z)},aCab,aItens,3) //Inclusao

	If lMsErroAuto
		MOSTRAERRO()
		DisarmTransaction()
	Endif           
	
	//aAdd(aCab,{"",cTurno}) //-- adiciona a informacao para enviar por email
	//aAdd(aCab,{"",dDtRet}) //-- adiciona a informacao para enviar por email
	
	//E151Mail(aCab,aItens)
	
	end Transaction
	
	ConfirmSx8()	
	
	dbSelectArea(_aSaveArea[1])
	dbSetOrder(_aSaveArea[3])
	dbGoto(_aSaveArea[2])
	
	ZDC->(DBGOBOTTOM())
	
	oDlg:End()

Return

//��������������������������������������������������������������Ŀ
//� ENVIA E-MAIL PARA O ALMOXARIFADO SEPARAR OS EPIS SOLICITADOS �
//����������������������������������������������������������������
Static Function E151Mail(aCab,aItens)
Local cMsg 
Local aItmMsg := {}
  				    
	cMsg := '<html>' 
	
	cMsg += '<style type="text/css">'
	cMsg += '.tabela{'
	cMsg += '   font-family:arial;'
	cMsg += '   border-collapse:collapse;'
	cMsg += '   border-color:#ccc;'
	cMsg += '   color:#333;'
	cMsg += '   width:100%;'
	cMsg += '   font-size:12px;'
	cMsg += '}'
	cMsg += '</style>'
	
	cMsg += '<body style="font-family:arial;color:#333">'
	cMsg += '<p></p>'
	
	cMsg += 'SOLICITA��O DE EPI - N�: '+cNum+'<br /><br />'
	
	cMsg += 'SOLICITANTE: '

	QAA->(dbSetOrder(6)) //LOGIN
	If QAA->(dbSeek(aCab[1][2]))
		cMsg += QAA->QAA_NOME+'<br />'
	Else
		cMsg += aCab[1][2]+'<br />'
	EndIf
	
	cMsg += 'DATA: '+DtoC(aCab[2][2])+'<br />'
	cMsg += 'RETIRAR EM: '+DtoC(aCab[4][2])+' - ('+aCab[3][2]+'� TURNO)<br /><br />'

	//FUNCIONARIOS
	cMsg += '<table border="1" class="tabela">'
	cMsg += '<tr style="background:#efefef">'  
	cMsg += '<td>ITEM</td>'
	cMsg += '<td>MATRICULA</td>'
	cMsg += '<td>NOME</td>'
	cMsg += '<td>C.CUSTO</td>'
	cMsg += '<td>DESC. CC</td>'
	cMsg += '<td>OPERA��O</td>'
	cMsg += '<td>PRODUTO</td>'
	cMsg += '<td>DESCRI��O</td>'
	cMsg += '<td>QUANTIDADE</td>'
	cMsg += '</tr>'
	
//	SRA->(dbSetOrder(1)) // FILIAL + MAT
	CTT->(dbSetORder(1)) // FILIAL + CC
	ZRG->(dbSetOrder(1)) // FILIAL + MAT
	SB1->(dbSetOrder(1)) // FILIAL + COD
	ZDC->(dbSetOrder(1)) // FILIAL + NUM
	ZDC->(dbSeek(xFilial("ZDC")+cNum))
	While ZDC->(!EOF()) .AND. ZDC->ZDC_NUM==cNum

		//SRA->(dbSeek(xFilial("SRA")+ZDC->ZDC_MAT))
		ZRG->(dbSeek(xFilial("ZRG")+ZDC->ZDC_MAT))
		SB1->(dbSeek(xFilial("SB1")+ZDC->ZDC_PROD))
		CTT->(dbSeek(xFilial("CTT")+ZDC->ZDC_CC))
		
		cMsg += '<tr>'
		cMsg += '<td>'+ZDC->ZDC_ITEM+'</td>'
		cMsg += '<td>'+ZDC->ZDC_MAT+'</td>'
		cMsg += '<td>'+ZRG->ZRG_NOME+'</td>'
		cMsg += '<td>'+ZDC->ZDC_CC+'</td>'
		cMsg += '<td>'+CTT->CTT_DESC01+'</td>'
		cMsg += '<td>'+ZRG->ZRG_OP+'</td>'
		cMsg += '<td>'+ZDC->ZDC_PROD+'</td>'
		cMsg += '<td>'+SB1->B1_DESC+'</td>'
		cMsg += '<td>'+"1"+'</td>'
		cMsg += '</tr>'
			     
		//adiciona os itens em um array para ordenar posteriormente
		aAdd(aItmMsg,{ZDC->ZDC_PROD  ,; //produto
					  SB1->B1_DESC   ,; //descricao
		              Iif( Alltrim(ZDC->ZDC_PROD)=='MS01.000264',2,1)})               //quantidade

		ZDC->(dbSkip())

	EndDo

	cMsg += '</table><br />'
	
	aSort(aItmMsg,,,{|x,y| x[1] < y[1]}) //ordena por produto
	
	//ITENS
	cMsg += '<table border="1" class="tabela">'
	cMsg += '<tr style="background:#efefef">'  
	cMsg += '<td>PRODUTO</td>'
	cMsg += '<td>DESCRI��O</td>'
	cMsg += '<td>QUANTIDADE</td>'
	cMsg += '</tr>'

	//agrupa os �tens por c�digo e soma as quantidades
	For x:=1 to Len(aItmMsg)
		
		If x+1 <= Len(aItmMsg) .and. aItmMsg[x][1]==aItmMsg[x+1][1] //se o pr�ximo produto for igual ao corrente
			If Alltrim(aItmMsg[x][1])=='MS01.000264'
				aItmMsg[x][3] += 2
			else
				aItmMsg[x][3]++//soma a quantidade e n�o imprime
			endif
			
		Else
			cMsg += '<tr>'
			cMsg += '<td>'+aItmMsg[x][1]+'</td>'
			cMsg += '<td>'+aItmMsg[x][2]+'</td>'
			cMsg += '<td>'+ALLTRIM(STR(aItmMsg[x][3]))+'</td>'
			cMsg += '</tr>'

		EndIf
	Next

	cMsg += '</table><br />'

	cMsg += '</body>'
	cMsg += '</html>
	
	If SM0->M0_CODIGO == "NH" //EMPRESA USINAGEM

		cTo := "lista-almoxarifado@whbbrasil.com.br;"
 		cTo += "almirrr@whbusinagem.com.br;"
 		cTo += "paulorr@whbbrasil.com.br;"
 		cTo += "jacquelinenv@whbbrasil.com.br"
		 		 
 		If !Empty(cEmail) //email do usu�rio LOGADO
 			cTo += ";"+cEmail
 		EndIf

	EndIf
	
	oMail          := Email():New()
	oMail:cMsg     := cMsg
	oMail:cAssunto := "*** SOLICITACAO DE EPI ***"
//	oMail:cTo      := cTo
	
//	oMail:Envia()

Return

/*
//��������Ŀ
//� ALTERA �
//����������
Static Function fAltera()
	
	If !fValida()
		Return
	EndIf
	
	oDlg:End()

Return
*/

//��������Ŀ
//� EXCLUI �
//����������
Static Function fExclui()

	If MsgYesNo("Tem certeza de que deseja excluir?")
		
		//EXCLUI A REQUISICAO DA TABELA SCP
		SCP->(dbSetOrder(1)) //CP_FILIAL+CP_NUM+CP_ITEM+DTOS(CP_EMISSAO)
		SCP->(dbSeek(xFilial("SCP")+cNumSA))
		WHILE SCP->(!EOF()) .AND. SCP->CP_NUM==cNumSA
			RecLock("SCP",.F.)
				SCP->(dbDelete())			
		    MsUnLock("SCP") 

			SCP->(dbSkip())
		ENDDO
		
		//EXCLUI A REQUISICAO DA TABELA SCQ
		SCQ->(dbSetOrder(1))
		SCQ->(dbSeek(xFilial("SCQ")+cNumSA))
		WHILE SCQ->(!EOF()) .AND. SCQ->CQ_NUM==cNumSA
			RecLock("SCQ",.F.)
				SCQ->(dbDelete())			
		    MsUnLock("SCQ") 

			SCQ->(dbSkip())
		ENDDO
			
		//EXCLUI A REQUISICAO DA TABELA ZDC
		ZDC->(dbSetOrder(1)) //FILIAL + NUM + ITEM
		ZDC->(dbGoTop())
		ZDC->(dbSeek(xFilial("ZDC")+cNum))
		WHILE ZDC->(!EOF()) .AND. ZDC->ZDC_NUM==cNum
			RecLock("ZDC",.F.)
				ZDC->(dbDelete())			
		    MsUnLock("ZDC") 
			ZDC->(dbSkip())
		ENDDO
	
	EndIf
	
	oDlg:End()

Return

//�����������������Ŀ
//� TELA DE LEGENDA �
//�������������������
User Function 151Leg()       
Local aLegenda :=	{ {"BR_VERMELHO", "Baixado" },;
  					  {"BR_VERDE"   , "Aberto"   }}

BrwLegenda("Solicita��o de EPI's", "Legenda", aLegenda)

Return  

//��������������������������Ŀ
//� CRIA A LEGENDA DO BROWSE �
//����������������������������
Static Function fCriaCor()
Local aLegenda :=	{	{"BR_VERMELHO", "Fechado"  },;
  						{"BR_VERDE"   , "Aberto"   }}

Local uRetorno := {}
Aadd(uRetorno, { 'ALLTRIM(ZDC_DOC) != ""' , aLegenda[1][1] })
Aadd(uRetorno, { 'ALLTRIM(ZDC_DOC) == ""' , aLegenda[2][1] })

Return(uRetorno)

//������������������
//� MARCA DESMARCA �
//������������������
Static Function fMarkAll(oObj,lMarca,cTabMark)
Local aOld := getArea()
Local nRecno

	dbSelectArea(cTabMark)
	nRecno := recno()
	dbGotop()

	While !Eof()
		
		RecLock(cTabMark,.F.)
			If lMarca
				&(cTabMark+"->OK") := cMarca
			Else
				&(cTabMark+"->OK") := "  "
			Endif
		MsUnlock(cTabMark)

		If cTabMark=="CCT"
			fTrazFun(.F.)
		EndIf
		
		If cTabMark=="FUN"
			fMarkFun()
		EndIf
		
		If cTabMark=="EPI"
			fMarkEPI()
		EndIf
		
		dbSkip()
	EndDo

	dbGoto(nRecno)

	oObj:oBrowse:Refresh()

	dbSelectArea(aOld[1])
	dbSetOrder(aOld[2])
	dbGoTo(aOld[3])

Return

Static Function fConsMat()
Local cMatCons := Space(6)
			
	oDlgMat := MsDialog():New(0,0,130,410,"Consulta Matr�cula",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
                                                              
	oFont1 := TFont():New("Arial",,16,,.t.,,,,,.f.)

	oSay1 := TSay():New(20,10,{||"Matr�cula"},oDlgMat,,,,,,.T.,,)
	oGet1 := tGet():New(18,40,{|u| if(Pcount() > 0, cMatCons := u,cMatCons)},oDlgMat,35,8,"@!",{||},;
		,,,,,.T.,,,{||.T.},,,,,,"ZRG","cMatCons")

	oBtn1 := tButton():New(50 ,135 ,"OK"      ,oDlgMat,{||fMatInfo(cMatCons)},30,10,,,,.T.)
	oBtn2 := tButton():New(50 ,170,"Cancelar" ,oDlgMat,{||oDlgMat:End()} ,30,10,,,,.T.)

	oDlgMat:Activate(,,,.T.,{||.T.},,{||})

Return

Static Function fMatInfo(cMat)

	ZRG->(dbsetorder(1))//ZRG_FILIAL+ZRG_MAT
	
	If ZRG->(dbseek(xFilial("ZRG")+cMat))
		Alert("Matr�cula: "+ZRG->ZRG_MAT+CHR(13)+CHR(10)+;
			  "Funcion�rio: "+ALLTRIM(ZRG->ZRG_NOME)+CHR(13)+CHR(10)+;
			  "C.Custo: "+ALLTRIM(ZRG->ZRG_CC)+" - "+Posicione("CTT",1,xFilial("CTT")+ZRG->ZRG_CC,"CTT_DESC01")+CHR(13)+CHR(10)+;
			  "�rea: "+alltrim(ZRG->ZRG_AREA)+CHR(13)+CHR(10)+;
			  "Turno: "+alltrim(ZRG->ZRG_TURNO))
	Else
	
		Alert("N�o encontrado!")
	
	EndIf

Return

//������������������������������������Ŀ
//� PERMITE ESCOLHER O CENTRO DE CUSTO �
//��������������������������������������

Static Function fChoseCC()
Private cNewCC  := Space(9)
Private cDNewCC := ""
			
	oDlgCC := MsDialog():New(0,0,130,410,"Centro de Custo",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
                                                              
	oFont1 := TFont():New("Arial",,16,,.t.,,,,,.f.)

	oSay1 := TSay():New(10,10,{||"Informe o Centro de Custo para o qual"},oDlgCC,,oFont1,,,,.T.,CLR_BLUE,)
	oSay1 := TSay():New(20,10,{||"deseja solicitar o(s) EPI(s)"},oDlgCC,,oFont1,,,,.T.,CLR_BLUE,)

	oSay1 := TSay():New(38,10,{||"C.Custo"},oDlgCC,,,,,,.T.,,)
	oGet1 := tGet():New(36,30,{|u| if(Pcount() > 0, cNewCC := u,cNewCC)},oDlgCC,45,8,"@!",{||fValCC()},;
		,,,,,.T.,,,{||.T.},,,,,,"CTT","cNewCC")

	oGet1 := tGet():New(36,80,{|u| if(Pcount() > 0, cDNewCC := u,cDNewCC)},oDlgCC,120,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cDNewCC")

	oBtn1 := tButton():New(50 ,135 ,"OK"      ,oDlgCC,{||fAddNewCC()()},30,10,,,,.T.)
	oBtn2 := tButton():New(50 ,170,"Cancelar" ,oDlgCC,{||oDlgCC:End()} ,30,10,,,,.T.)

	oDlgCC:Activate(,,,.T.,{||.T.},,{||})

Return

//���������������������������������������������Ŀ
//� VALIDA O CENTRO DE CUSTO E TRAZ A DESCRI��O �
//�����������������������������������������������
Static Function fValCC()

	CTT->(dbSetOrder(1)) //FILIAL + CC
	If CTT->(dbSeek(xFilial("CTT")+cNewCC))
		cDNewCC := CTT->CTT_DESC01
	Else
		Alert("Centro de Custo n�o encontrado!")
		Return .F.
	EndIf

Return .T.

//�������������������������������������0�
//� INCLUI O CENTRO DE CUSTO NA MATRIZ �
//�������������������������������������0�
Static Function fAddNewCC()
Local cAl := 'NOVOCC'

 	//-- verifica se o usuario logado possui o acesso ao CC na tabela ZRJ
	ZRJ->(dbSetOrder(1))
	If !ZRJ->(dbSeek(xFilial("ZRJ")+PadR(cSolic,TamSx3("ZRJ_LOGIN")[1])+cNewCC))
		If !ZRJ->(dbSeek(xFilial("ZRJ")+PadR(cSolic,TamSx3("ZRJ_LOGIN")[1])+'<todos>'))
			Alert("Centro de Custo n�o liberado! Favor entrar em contato com o Tecnico de Seguran�a do Trabalho!")
			Return .F.
		EndIf
	EndIf   
	

	// OS 070066 - Feito por Douglas Dourado - 27/03/2014 
	If SM0->M0_CODIGO=="FN"   
	
	   If Empty(cTurno)			   	
		   	Alert("Preencher o campo turno !")
		    Return .F.	 		           
       Else
	
		If !ZRJ->(dbSeek(xFilial("ZRJ")+PadR(cSolic,TamSx3("ZRJ_LOGIN")[1])+cNewCC+cTurno)) 
		   If !ZRJ->(dbSeek(xFilial("ZRJ")+PadR(cSolic,TamSx3("ZRJ_LOGIN")[1])+cNewCC+'4'))
			  If !Upper(AllTrim(cUsername))$"OSNIRZ/ADRIANAVR/GUILHERMEMB/LEANDROS/OZIELRV/OZIELRV/ALMIRRR/EVERTONG/JULIOKR/MARCILIOM/LUCASF/JACQUELINENV/CARLOSAS/ROGINALDO.VASCO/LOURIVALCC/ARIADSONMS/JONESTONBM/RAFAELB/POLIANARA/CARMENCITAAA/MERCIAMS/JOAOFR"
			    Alert("Usuario n�o tem permiss�o para requisitar neste turno ! Favor entrar em contato com o Tecnico de Seguran�a do Trabalho!")
			    Return .F.	 
			  EndIf
	       EndIf
	    EndIf
	    
	    EndIf
	    
	EndIf	
    // ---
	// ---------

	If Select(cAl) > 0
		(cAl)->(dbCloseArea())
	EndIf
	
	fEpiQuery(.T.,cAl,cNewCC)

	If (cAl)->(Eof())
		Alert("C.Custo n�o possui funcion�rios!")
	Else
		fAtuArray(cAl)
	EndIf

	(cAl)->(dbCloseArea())

	CTT->(dbGoTop())

	oDlgCC:End()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ATUUM  �Autor  � Jo�o Felipe da Rosa  � Data �  03/09/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     � ATUALIZA AS UNIDADES DE MEDIDA ENTRE SAH E SX5 (62)        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE / CUSTOS                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ATUUM()
	
	SX5->(dbSetOrder(1)) //X5_FILIAL+X5_TABELA+X5_CHAVE
	SAH->(dbSetOrder(1)) //AH_FILIAL+AH_UNIMED
	
	ProcRegua(SAH->(RecCount()))
	
	While SAH->(!EOF())
	    IncProc(SAH->AH_UNIMED)
	    
	    If !SX5->(dbSeek(xFilial("SX5")+"62"+SAH->AH_UNIMED))
	    	RecLock("SX5",.T.)
	    		SX5->X5_FILIAL  := xFilial("SX5")
	    		SX5->X5_TABELA  := "62"
	    		SX5->X5_CHAVE   := SAH->AH_UNIMED
	    		SX5->X5_DESCRI  := SAH->AH_DESCPO
	    		SX5->X5_DESCSPA := SAH->AH_DESCES
	    		SX5->X5_DESCENG := SAH->AH_DESCIN
		    MsUnLock("SX5")
		EndIf	
		SAH->(dbSkip())
	EndDo
	
	MsgBox("Unidades atualizadas com sucesso!","Unidades","INFO")
	
Return

//��������������������������������������Ŀ
//� CADASTRO DE EPI X C.CUSTO X OPERACAO �
//����������������������������������������
User Function 151EPICC()

oldRot := aClone(aRotina)

cCadastro := "Solicita��o de EPI"
aRotina   := {}
aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"      , 0 , 1})
aAdd(aRotina,{ "Visualizar"	    ,"U_151EPIC1"    , 0 , 2})
aAdd(aRotina,{ "EPI"		    ,"U_151EPIC1"    , 0 , 3})
aAdd(aRotina,{ "Copia"		    ,"U_151EPICO"    , 0 , 3})
aAdd(aRotina,{ "Liberacao"      ,"U_151LIBER"    , 0 , 3})

mBrowse(6,1,22,75,"CTT",,,,,,)

aRotina := aClone(oldRot)

Return

User Function 151EPIC1(cAlias,nReg,nOpc)
Local bOk        := {||}
Local bCanc      := {||oDlg:End()}
Local bEnchoice  := {||}
Private aSize    := MsAdvSize()
Private aObjects := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aPosObj  := MsObjSize( aInfo, aObjects, .T.)
Private nPar     := nOpc
Private cCC      := CTT->CTT_CUSTO
Private cDescCC  := CTT->CTT_DESC01
Private aHeader  := {}
Private aCols    := {}
 
	fEPICarg()
		
	If nPar==2     //visualizar
	    bOk := {|| oDlg:End()}
	ElseIf nPar==3 //EPI
		bOk := {|| fEPI()}
		bCanc := {||RollBackSx8(), oDlg:End()}
	EndIf

	aAdd(aHeader,{"EPI"        , "ZDD_CODEPI"  , PesqPict("ZDD","ZDD_CODEPI") , 15,00, "U_E151VPRD()"  ,"","C","ZDD"})
	aAdd(aHeader,{"Descri��o"  , "B1_DESC"     , PesqPict("SB1","B1_DESC")    , 50,00, ".F."           ,"","C","SB1"})
	aAdd(aHeader,{"Opera��o"   , "ZDD_OP"      , PesqPict("ZDD","ZDD_OP")     , 03,00, "U_E151VOP()"   ,"","C","ZDD"})

	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}
			
	oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"EPI x CC",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(20,10,{||"C.Custo"},oDlg,,,,,,.T.,,)
	oGet1 := tGet():New(18,50,{|u| if(Pcount() > 0, cCC := u,cCC)},oDlg,45,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cCC")
	oGet2 := tGet():New(18,100,{|u| if(Pcount() > 0, cDescCC := u,cDescCC)},oDlg,180,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cDescCC")

    // cria o getDados
	oGeTD := MsGetDados():New( 40               ,; //superior
	                           aPosObj[2,2]     ,; //esquerda
	                           aPosObj[2,3]     ,; //inferior
	                           300              ,; //direita
	                           nPar             ,; // nOpc
	                           "U_E151VEPI()"   ,; // CLINHAOK
	                           "AllwaysTrue"    ,; // CTUDOOK
	                           ""               ,; // CINICPOS
	                           .T.              ,; // LDELETA
	                           nil              ,; // aAlter
	                           nil              ,; // uPar1
	                           .F.              ,; // LEMPTY
	                           400              ,; // nMax
	                           nil              ,; // cCampoOk
	                           "AllwaysTrue()"  ,; // CSUPERDEL
	                           nil              ,; // uPar2
	                           "AllwaysTrue()"  ,; // CDELOK
	                           oDlg              ; // oWnd
	                          )

	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return

User Function E151VEPI()
Local nPosOP  := aScan(aHeader,{|x| UPPER(Alltrim(x[2])) == "ZDD_OP"})

	If SM0->M0_CODIGO=="NH"
		If SUBSTR(CTT->CTT_CUSTO,1,1)$'4'
			If Len(AllTrim(aCols[n][nPosOp])) != 3
				Alert("Informe a Operacao com 3 d�gitos!")
				Return .F.
			EndIf
		Else
			If !Empty(aCols[n][nPosOp])
				aCols[n][nPosOp] := space(3)
			EndIf
		EndIf
	EndIf
		
Return .T.


//������������������������������Ŀ
//� GRAVA OS EPIS X C.CUSTO X OP �
//��������������������������������
Static Function fEPI()
Local nPosEPI := aScan(aHeader,{|x| UPPER(Alltrim(x[2])) == "ZDD_CODEPI"})
Local nPosOP  := aScan(aHeader,{|x| UPPER(Alltrim(x[2])) == "ZDD_OP"})
	
	If !Alltrim(UPPER(cUserName))$"OSNIRZ/ALMIRRR/EVERTONG/JOAOFR/ADMINISTRADOR/ADMIN/JULIOKR/LUCASF/MARCILIOM/PAULORR/JACQUELINENV/CARLOSAS/ROGINALDO.VASCO/GUILHERMEMB/LEANDROS/OZIELRV/LOURIVALCC/ARIADSONMS/JONESTONBM/RAFAELB/POLIANARA/CARMENCITAAA/MERCIAMS"
		Alert("Usu�rio n�o autorizado!")
		Return .F.
	EndIf
	
	ZDD->(dbSetOrder(1)) //filial + cc + codepi + OP
	
	For x:=1 to Len(aCols)
		If !aCols[x][len(aHeader)+1] //nao pega quando estiver deletado
			If !ZDD->(dbSeek(xFilial("ZDD")+cCC+aCols[x][nPosEPI]+aCols[x][nPosOP]))
				RecLock("ZDD",.T.)
					ZDD->ZDD_FILIAL := xFilial("ZDD")
					ZDD->ZDD_CC     := cCC
					ZDD->ZDD_CODEPI := aCols[x][nPosEPI]
					ZDD->ZDD_OP     := aCols[x][nPosOp]
				MsUnLock("ZDD")
			EndIf
 	    Else
			If ZDD->(dbSeek(xFilial("ZDD")+cCC+aCols[x][nPosEPI]))
				RecLock("ZDD",.F.)
				    ZDD->(dbDelete())
			    MsUnLock("ZDD")
			EndIf	    	
	    EndIf
	Next
	                           
	//VERIFICA SE EXISTE ALGUM REGISTRO NA ZDD QUE N�O TENHA NO ACOLS E ENT�O EXCLUI
	ZDD->(dbGoTop())
	ZDD->(dbSeek(xFilial("ZDD")+cCC))	
	WHILE ZDD->(!EOF()) .AND. ZDD->ZDD_CC==cCC
	    _n := Ascan(aCols, {|x| x[1]==ZDD->ZDD_CODEPI .AND. x[3]==ZDD->ZDD_OP})
	    
	    If _n==0
	    	RecLock("ZDD",.F.)
	    		ZDD->(dbDelete())
	    	MsUnlock("ZDD")
	    EndIf
	    
	    ZDD->(dbSkip())
	    
	ENDDO
	oDlg:End()
	
Return

//�����������������������������Ŀ
//� TRAZ A DESCRICAO DO PRODUTO �
//�������������������������������
User Function E151VPRD()
Local nPosDesc := aScan(aHeader,{|x| UPPER(Alltrim(x[2])) == "B1_DESC"})
	
    SB1->(dbSetOrder(1)) // FILIAL + COD
    If !SB1->(dbSeek(xFilial("SB1")+M->ZDD_CODEPI))
    	Alert("C�digo do EPI n�o encontrado!")
     	Return .F.
    Else
		aCols[n][nPosDesc] := SB1->B1_DESC
		oGetD:Refresh()
	EndIf
    
Return .T.

//���������������������
//� VALIDA A OPERACAO �
//���������������������
User Function E151VOP()

	If (SM0->M0_CODIGO=="NH" .AND. SUBSTR(CTT->CTT_CUSTO,1,1)$'4') .OR.;
	    SM0->M0_CODIGO=="FN"
	    
		If Len(AllTrim(M->ZDD_OP)) != 3
			Alert("Informe a Operacao com 3 d�gitos!")
			Return .F.
		EndIf
	Else
		If !Empty(M->ZDD_OP)
			M->ZDD_OP := space(3)
			Return .F.
		EndIf
	EndIf

Return .T.

//����������������������������������Ŀ
//� CARREGA OS DADOS DO EPI X CCUSTO �
//������������������������������������
Static Function fEPICarg()

	ZDD->(dbSetOrder(1)) // FILIAL + CC + CODEPI          
	SB1->(dbSetOrder(1)) // FILIAL + COD
	If ZDD->(dbSeek(xFilial("ZDD")+CTT->CTT_CUSTO))
	    While ZDD->(!EOF()) .AND. ZDD->ZDD_CC == CTT->CTT_CUSTO
			SB1->(dbSeek(xFilial("SB1")+ZDD->ZDD_CODEPI))
	        aAdd(aCols,{ZDD->ZDD_CODEPI,SB1->B1_DESC,ZDD->ZDD_OP,.F.})
	    	ZDD->(dbSkip())
		EndDo
    EndIf
    
    aSort(aCols,,,{|x,y| x[2] < y[2]}) //ordena por descricao

REturn

//��������������������������������������������������������Ŀ
//� ABRE UMA JANELA PARA ALTERAR A OPERACAO DO FUNCIONARIO �
//����������������������������������������������������������
Static Function fAltOp()
Private cNewOP := FUN->OP
			
	oDlgOP := MsDialog():New(0,0,130,410,"Alterar Opera��o",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
                                                              
	oFont1 := TFont():New("Arial",,16,,.t.,,,,,.f.)

	oSay1 := TSay():New(10,10,{||"Funcion�rio: "+FUN->MAT+" - "+FUN->NOME},oDlgOP,,oFont1,,,,.T.,CLR_BLUE,)

	oSay1 := TSay():New(38,10,{||"Opera��o:"},oDlgOP,,,,,,.T.,,)
	oGet1 := tGet():New(36,40,{|u| if(Pcount() > 0, cNewOP := u,cNewOp)},oDlgOP,40,8,"@e 999",{||.T.},;
		,,,,,.T.,,,{||.T.},,,,,,,"cNewOp")

	oBtn1 := tButton():New(50 ,135 ,"OK"      ,oDlgOP,{||fGrvOP()},30,10,,,,.T.)
	oBtn2 := tButton():New(50 ,170,"Cancelar" ,oDlgOP,{||oDlgOP:End()} ,30,10,,,,.T.)

	oDlgOP:Activate(,,,.T.,{||.T.},,{||})


Return

//��������������������������������������Ŀ
//� GRAVA A NOVA OPERA��O DO FUNCIONARIO �
//����������������������������������������
Static Function fGrvOP()
Local CloneFun := aClone(aFun)
Local CloneEpi := aClone(aEpi)
Local lOk      := .F.
	
	//ALTERA A OPERACAO DO FUNCIONARIO NO ARRAY aFun
	_n := aScan(aFun,{|x| x[3]==FUN->MAT})
	If _n != 0
		aFun[_n][5] := cNewOP
	EndIf
        
	//EXCLUI TODOS OS REGISTROS DO ARRAY AEPI COM A MATRICULA DO FUNCIONARIO QUE TEVE A OP ALTERADA
	_aEpi := {}
	For _x:=1 to Len(aEpi)
		If aEpi[_x][1]!=FUN->MAT
			aAdd(_aEpi,aEpi[_x])
	    EndIf
	Next
	aEpi := aClone(_aEpi)
	
	//ADICIONA NO ARRAY aEPI TODOS OS EPIS DA NOVA OPERACAO DO FUNCIONARIO
	ZDD->(dbSetOrdeR(1)) // FILIAL + CC + CODEPI + OP
	If ZDD->(dbSeek(xFilial("ZDD")+CCT->CCUSTO))
		WHILE ZDD->(!EOF()) .AND. ZDD->ZDD_CC == CCT->CCUSTO
			If ZDD->ZDD_OP == cNewOP
				lOk := .T.
				//adiciona os epis de cada funcionario no array aEPI
				SB1->(dbSeek(xFilial("SB1")+ZDD->ZDD_CODEPI))
				aAdd(aEPI,{FUN->MAT,Space(2),ZDD->ZDD_CODEPI,SB1->B1_DESC,ZDD->ZDD_OP})
			EndIf
			ZDD->(dbSkip())
		ENDDO
	EndIf

	if lOk
	
		ZRG->(dbSetOrder(1))
		If ZRG->(dbSeek(xFilial("ZRG")+FUN->MAT))
			RecLock("ZRG",.F.)
				ZRG->ZRG_OP := cNewOP
			MsUnlock("ZRG")
		EndIf

		RecLock("FUN",.F.)
			FUN->OP := cNewOP
		MsUnlock("FUN")
		
		fTrazEpi()
	
		oDlgOP:End()
	Else
		Alert("A opera��o digitada n�o foi cadastrada para este C.Custo!"+chr(10)+chr(13)+;
			  "Favor entrar em contato com o setor de Seguran�a do Trabalho!")         
		aFun := CloneFun
		aEpi := CloneEpi
	EndIf

Return

User Function 151LIBER()
Local aRotina2 := aClone(aRotina)                    
	dbselectarea("ZED")
	aRotina := {}
	axcadastro('ZED')
	aRotina := aClone(aRotina2)
Return

//�����������������������������������Ŀ
//� COPIA DE EPIS DE UM CC PARA OUTRO �
//�������������������������������������
User Function 151EPICO()
Private cCopyCC  := Space(9)
Private cDCopyCC := ""
Private cCCOrig  := CTT->CTT_CUSTO
			
	oDlgCC := MsDialog():New(0,0,130,410,"Centro de Custo",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
                                                              
	oFont1 := TFont():New("Arial",,16,,.t.,,,,,.f.)

	oSay1 := TSay():New(10,10,{||"Copiar EPI's do C.Custo "+alltrim(cCCOrig)+" para o C.Custo: "},oDlgCC,,oFont1,,,,.T.,CLR_BLUE,)

	oSay1 := TSay():New(38,10,{||"C.Custo"},oDlgCC,,,,,,.T.,,)
	oGet1 := tGet():New(36,30,{|u| if(Pcount() > 0, cCopyCC := u,cCopyCC)},oDlgCC,45,8,"@!",{||fValCopyCC()},;
		,,,,,.T.,,,{||.T.},,,,,,"CTT","cCopyCC")

	oGet1 := tGet():New(36,80,{|u| if(Pcount() > 0, cDCopyCC := u,cDCopyCC)},oDlgCC,120,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cDCopyCC")

	oBtn1 := tButton():New(50 ,135 ,"OK"      ,oDlgCC,{|| Processa({||fCopyCC()},'Copiando')},30,10,,,,.T.)
	oBtn2 := tButton():New(50 ,170,"Cancelar" ,oDlgCC,{||oDlgCC:End()} ,30,10,,,,.T.)

	oDlgCC:Activate(,,,.T.,{||.T.},,{||})

Return

Static function fCopyCC()
Local aArr := {}

	ProcRegua(0)

	ZDD->(dbSetorder(1)) //ZDD_FILIAL+ZDD_CC+ZDD_CODEPI+ZDD_OP
	If ZDD->(dbSeek(xFilial("ZDD")+cCCOrig))
	
		While ZDD->(!EOF()) .AND. ZDD->ZDD_CC==cCCOrig
			aAdd(aArr,{ZDD->ZDD_CC,ZDD->ZDD_CODEPI,ZDD->ZDD_OP})	
			ZDD->(dbSkip())
		Enddo
		
	Endif

	ProcRegua(len(aArr))
	
	For xA:=1 to Len(aArr)
		
		IncProc()
		
		If !ZDD->(dbSeek(xFilial("ZDD")+cCopyCC+aArr[xA][2]+aArr[xA][3]))
		
			Reclock('ZDD',.T.)
				ZDD->ZDD_FILIAL := xFilial('ZDD')
				ZDD->ZDD_CC     := cCopyCC
				ZDD->ZDD_CODEPI := aArr[xA][2]
				ZDD->ZDD_OP     := aArr[xA][3]
			MsUnlock('ZDD')		
		Endif			
	Next
	
	Alert('Copia efetuada com sucesso!')
	
	oDlgCC:End()
	
Return

//���������������������������������������������Ŀ
//� VALIDA O CENTRO DE CUSTO E TRAZ A DESCRI��O �
//�����������������������������������������������
Static Function fValCopyCC()

	CTT->(dbSetOrder(1)) //FILIAL + CC
	If CTT->(dbSeek(xFilial("CTT")+cCopyCC))
		cDCopyCC := CTT->CTT_DESC01
	Else
		Alert("Centro de Custo n�o encontrado!")
		Return .F.
	EndIf

Return .T.

User Function CPFUNCEPI()
Return Posicione("SRA",1,xFilial("SRA")+Posicione("ZDC",1,xFilial("ZDC")+SCP->CP_NUMSEPI+SCP->CP_ITEM,"ZDC_MAT"),"RA_NOME")