
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHCFG012  �Autor  �Jo�o Felipe da Rosa � Data �  28/07/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � CADASTRA GRUPO EM TODOS OS USUARIOS                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP10 / AP11                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include 'protheus.ch'
#include 'colors.ch'
#include 'rwmake.ch'

User Function NHCFG012()  


Local cBusca 	  := space(25)
Local bOk         := {|| Processa({|| fCarrega()})  }
Local bCanc       := {||oDlg:End()}
Local bEnchoice   := {||}

Private aAllUsers 
Private aCol      := {}
Private oLbx

	//-- cria a barra superior com bot�es 
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}
		
	//-- monta a tela
	oDlg  := MsDialog():New(0,0,400,400,"Usu�rios",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

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
		
		if aAllUsers[xU][1][1]<>'000000' //-- SE NAO FOR ADMINISTRADOR
			fGrupoaT(aAllUsers[xU][1][1])
		endif
		
	Next
	
	ALERT('Ok')

Return


Static function fGrupoaT(cId)	
	
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
Local cUsrId := cId

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

/* --- INCLUI UM GRUPO PARA DTODOS
aGrupos := aPswDet[1][10]

//-- verifica se ja nao possui o grupo 000001
lAchou := .f.
For x:=1 to len(aGrupos)
	If aGrupos[x] == '000001'
		lAchou:= .t.
	endif
Next


//-- adiciona o grupo 000001
If !lAchou
	aAdd(aPswDet[1][10],'000001')
EndIf
*/
aPswDet[2][5] := SUBSTR(aPswDet[2][5],1,113) + 'NN' + SUBSTR(aPswDet[2][5],116,(LEN(aPswDet[2][5]) - 116 )) 

//Convertendo as informacoes no novo usuario para gravacao
cPswDet 	  := Array2Str( @aPswDet , @lEncrypt )

//-- atualiza arquivo 
SPF_UPDATE( cPswFile , nPswRec ,@cPswId , @cPswName , @cPswPwd ,cPswDet)

Return
