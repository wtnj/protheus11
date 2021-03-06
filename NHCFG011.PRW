/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHCFG011  �Autor  �Jo�o Felipe da Rosa � Data �  20/07/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � DUPLICA��O DE USU�RIO DO SISTEMA PROTHEUS                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CONFIGURADOR                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include 'protheus.ch'
#include 'colors.ch'
#include 'rwmake.ch'

User Function NHCFG011()
Local cBusca 	  := space(25)
Local bOk         := {|| fDuplica()}
Local bCanc       := {||oDlg:End()}
Local bEnchoice   := {||}

Private aAllUsers 
Private aCol      := {}
Private oLbx

	Processa({|| fCarrega()},"Carregando Usu�rios ...")

	//-- ordena por login
	aSort(aCol,,,{|x,y| x[1]<y[1]}) 
	
	//-- cria a barra superior com bot�es 
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}
		
	//-- monta a tela
	oDlg  := MsDialog():New(0,0,600,500,"Usu�rios",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	tSay():New(18,05,{||"Procurar: "},oDlg,,,,,,.T.,CLR_BLACK,)
	tGet():New(16,30,{|u| if(Pcount() > 0, cBusca := u,cBusca)},oDlg,80,8,"@!",,;
		,,,,,.T.,,,{|| .t.},,,,,,,"cBusca")
    tButton():New(16,115,"&Procurar"      ,oDlg,{||fBusca(cBusca)},40,10,,,,.T.)
	
	//-- listbox com os usuarios
	@ 30,005 LISTBOX oLbx FIELDS HEADER "Login","Nome","ID";
   		SIZE 240,265 OF oDlg PIXEL ON DBLCLICK( fDuplica())

	oLbx:SetArray( aCol )
	oLbx:bLine := {|| {aCol[oLbx:nAt,1],;  // LOGIN
                       aCol[oLbx:nAt,2],;  // USUARIO
                       aCol[oLbx:nAt,3]}}  // SENHA
	oLbx:Refresh()

	oDlg:Activate(,,,.T.,{||.T.},,bEnchoice)

Return

//�������������������������������Ŀ
//� CARREGA OS USU�RIOS NA MATRIZ �
//���������������������������������
Static Function fCarrega()

	aAllUsers := AllUsers()
	
	ProcRegua(len(aAllUsers))
	
	//-- percorre todos os usuarios e adiciona na matriz
	For xU := 1 to len(aAllUsers)
		IncProc()
		aAdd(aCol,{aAllUsers[xU][1][2],aAllUsers[xU][1][4],aAllUsers[xU][1][1],.f.})
	Next

Return

//�����������������������������(�
//� BUSCA O USUARIO NO LISTBOX �
//�����������������������������(�
Static Function fBusca(cBusca)
Local nAchou := 0

	cBusca := AllTrim(cBusca)
	nAchou := aScan(aCol,{|x| Substr(x[1],1,Len(cBusca))==AllTrim(cBusca) })
	            
	If nAchou<>0
		oLbx:nAt := nAchou
		oLbx:Refresh(.F.)
	EndIf

Return

//�����������������������������������������������Ŀ
//� TELA PARA DIGITACAO DOS DADOS DO NOVO USUARIO �
//�������������������������������������������������
Static Function CFG11()
Local lRet := .F.

	oDlgD  := MsDialog():New(0,0,162,380,"Duplica��o de Usu�rio",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	tSay():New(07,05,{||"Login: "},oDlgD,,,,,,.T.,CLR_HBLUE,)
	tGet():New(05,30,{|u| if(Pcount() > 0, cLogin := u,cLogin)},oDlgD,80,8,"@!",{||fValLogin()},;
		,,,,,.T.,,,{|| .T.},,,,,,,"cLogin")

	tSay():New(18,05,{||"Nome: "},oDlgD,,,,,,.T.,CLR_HBLUE,)
	tGet():New(16,30,{|u| if(Pcount() > 0, cNome := u,cNome)},oDlgD,155,8,"@!",,;
		,,,,,.T.,,,{|| .t.},,,,,,,"cNome")

	tSay():New(29,05,{||"Setor: "},oDlgD,,,,,,.T.,CLR_HBLUE,)
	tGet():New(27,30,{|u| if(Pcount() > 0, cSetor := u,cSetor)},oDlgD,155,8,"@!",,;
		,,,,,.T.,,,{|| .t.},,,,,,,"cSetor")

	tSay():New(40,05,{||"Cargo: "},oDlgD,,,,,,.T.,CLR_HBLUE,)
	tGet():New(38,30,{|u| if(Pcount() > 0, cCargo := u,cCargo)},oDlgD,155,8,"@!",,;
		,,,,,.T.,,,{|| .t.},,,,,,,"cCargo")

	tSay():New(51,05,{||"Email: "},oDlgD,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(49,30,{|u| if(Pcount() > 0, cEmail := u,cEmail)},oDlgD,155,8,"@!",,;
		,,,,,.T.,,,{|| .t.},,,,,,,"cEmail")

    tButton():New(62,145,"&Ok"      ,oDlgD,{||lRet := fValida()} ,40,15,,,,.T.)
    tButton():New(62,100,"&Cancelar",oDlgD,{||oDlgD:End(), lRet := .F.},40,15,,,,.T.)

	oDlgD:Activate(,,,.T.,{||.T.},,)

Return lRet

//��������������������Ŀ
//� VALIDACAO DO LOGIN �
//����������������������
Static Function fValLogin()

	nAchou := aScan(aAllUsers,{|x| AllTrim(x[1,2])==AllTrim(cLogin) })
	
	If nAchou<>0
		Alert("Login j� cadastrado!")
		Return .F.
	EndIf
	
	cEmail := AllTrim(cLogin)+"@whbbrasil.com.br"
	oGet1:Refresh()

Return .T.

//���������������������
//� VALIDACAO DA TELA �
//���������������������
Static Function fValida()
    
	If Empty(cLogin)
		Alert("Informe o login!")
		Return .F.
	EndIf
	
	If Empty(cNome)
		Alert("Informe o nome!")
		Return .F.
	EndIf
	
	oDlgD:End()
	
Return .T.

/*/
������������������������������������������������������������������������Ŀ
�Fun��o    �U_AddNewUser  �Autor �Marinaldo de Jesus   � Data �25/11/2008�
������������������������������������������������������������������������Ĵ
�Descri��o �Simular a Inclusao de um usuario Atraves de user Function    �
������������������������������������������������������������������������Ĵ
�Sintaxe   �<vide parametros formais>             						 �
������������������������������������������������������������������������Ĵ
�Parametros�<vide parametros formais>             						 �
������������������������������������������������������������������������Ĵ
�Retorno   �void                                                 	     �
������������������������������������������������������������������������Ĵ
�Observa��o�                                                      	     �
������������������������������������������������������������������������Ĵ
�Uso       �Generico 													 �
��������������������������������������������������������������������������
/*/
Static Function fDuplica()

Local cPswFile := "sigapss.spf" //Tabela de Senhas
Local cPswId   := ""
Local cPswName := ""
Local cPswPwd  := ""
Local cPswDet  := ""
Local lEncrypt := .F.
Local aPswDet
Local cOldPsw
Local cNewPsw
Local nPswRec

//Obtenho o usuario Base
Local cUsrId := aCol[oLbx:nat,3]

Private cLogin := Space(25)
Private cNome  := Space(30)
Private cSetor := Space(30)
Private cCargo := Space(30)
Private cEmail := Space(30)

IF Type( "cEmpAnt" ) <> "C"
	Private cEmpAnt := "01"
EndIF
IF Type( "cFilAnt" ) <> "C"
	Private cFilAnt := "01"
EndIF

//Abro a Tabela de Senhas
spf_CanOpen(cPswFile) 

//Procuro pelo usuario Base
nPswRec := spf_Seek( cPswFile , "2U"+cUsrId , 1 ) 

//Obtenho as Informacoes do usuario Base ( retornadas por referencia na variavel cPswDet)
spf_GetFields( @cPswFile , @nPswRec , @cPswId , @cPswName , @cPswPwd , @cPswDet )

//Converto o conteudo da string cPswDet em um Array
aPswDet := Str2Array( @cPswDet , @lEncrypt )

cSetor := aPswDet[1,12]
cCargo := aPswDet[1,13]

If CFG11()

	aPswDet[1,1]  := GetNextUsr( NIL , "999999" , .T. ) //Atribuindo o Novo user ID
	aPswDet[1,2]  := cLogin //Atribuindo o Nome do novo usuario
	
	//-- O B S.: A senha padrao � o pr�prio ID do cadastro
	cNewPsw	  	  := PswEncript( AllTrim(aPswDet[1,1]),0) //Encriptando a senha para o novo usuario

	aPswDet[1,3]  := cNewPsw //Atribuindo a nova senha ao novo usuario
	aPswDet[1,4]  := cNome   //Atribuindo o nome completo ao novo usuario
	aPswDet[1,12] := cSetor  //Atribuindo o Departamento ao novo usuario
	aPswDet[1,13] := cCargo  //Atribuindo o cargo ao novo usuario
	aPswDet[1,14] := cEmail  //Atribuindo o email ao novo usuario
	aPswDet[1,22] := cEmpAnt+cFilAnt+aPswDet[1,1] //Atribuindo o vinculo funcional ao novo usuario
	aPswDet[2,3]  := "\RELATO\" //Atribuindo o diretorio de impressao ao novo usuario
	
	//Convertendo as informacoes no novo usuario para gravacao
	cPswDet 	  := Array2Str( @aPswDet , @lEncrypt )
	
	//Incluindo o novo usuario
	spf_Insert( cPswFile , "1U"+aPswDet[1,1] , Upper("1U"+aPswDet[1,2]) , "1U"+aPswDet[1,3] , cPswDet )
	
	//atualiza a matriz 
	aAdd(aCol,{aPswDet[1,2],aPswDet[1,4],aPswDet[1,1],.f.})

	oLbx:Reset()
	oLbx:SetArray( aCol )
	oLbx:bLine := {|| {aCol[oLbx:nAt,1],;  // LOGIN
                       aCol[oLbx:nAt,2],;  // USUARIO
                       aCol[oLbx:nAt,3]}}  // SENHA
	oLbx:Refresh()
	
	MsgBox("",aPswDet[1,1],"INFO")

EndIf

Return( NIL )

/*/
������������������������������������������������������������������������Ŀ
�Fun��o    �GetNextUsr    �Autor �Marinaldo de Jesus   � Data �25/11/2008�
������������������������������������������������������������������������Ĵ
�Descri��o �Obter usuario valido para inclusao no sigapss.spf            �
������������������������������������������������������������������������Ĵ
�Sintaxe   �<vide parametros formais>             						 �
������������������������������������������������������������������������Ĵ
�Parametros�<vide parametros formais>             						 �
������������������������������������������������������������������������Ĵ
�Retorno   �void                                                 	     �
������������������������������������������������������������������������Ĵ
�Observa��o�                                                      	     �
������������������������������������������������������������������������Ĵ
�Uso       �Generico 													 �
��������������������������������������������������������������������������/*/
Static Function GetNextUsr( cUser , cMaxUser , lNewUser )

Local aAllUsers 
Local bPswSeek

Static __cMaxUser

PswOrder(1)

IF ((Empty( __cMaxUser ) .and. Empty( cMaxUser )) .or. Empty( cUser ))	
	IF ( Select( "SX6" ) > 0 )
		aAllUsers	:= AllUsers()
		__cMaxUser	:= aAllUsers[ Len( aAllUsers ) , 1 , 1 ]
		IF ( lNewUser )
			cUser	:= __cMaxUser
		EndIF
		aAllUsers	:= NIL
	EndIF	
EndIF

DEFAULT cUser	 := ID_USER_ADMINISTRATOR
DEFAULT cMaxUser := __cMaxUser
DEFAULT lNewUser := .F.

cUser			 := Soma1( cUser )

bPswSeek  	     := Iif(lNewUser,{ || PswSeek( @cUser ) },{ || !PswSeek( @cUser ) })

While ( Eval( bPswSeek ) )
	cUser := Soma1( cUser )
	IF (( lNewUser ) .and. ( cUser > cMaxUser ))
		cUser := Space( 6 )
		Exit
	EndIF
EndDo

If (lNewUser)
	__cMaxUser		:= cUser
EndIf	

Return( cUser )