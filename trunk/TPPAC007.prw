#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TPPAC007  � Autor � Handerson Duarte   � Data �  06/01/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Tabela de justificativas para nao aprova��o dos documentos ���
���          � customizados                                               ���
�������������������������������������������������������������������������͹��
���Uso       � WHB - MP10 R 1.2 MSSQL                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function TPPAC007


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cCadastro := "Tabela de Justificativas"

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","",0,3} ,;
             {"Alterar","",0,4} ,;
             {"Excluir","",0,5} }

/*            
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"IncluirTEste","U_PPAC007A (3)",0,3} ,;
             {"Alterar","",0,4} ,;
             {"Excluir","",0,5} }
*/

Private cDelFunc := ".F." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZCC"

dbSelectArea("ZCC")
dbSetOrder(1)


dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return 
/*
//===============================Incluir Registros=================================================  
User Function PPAC007A (nOpc) 
Local vCad	:={}
//AxInclui(cAlias,nReg,nOpc,aAcho,cFunc,aCpos,cTudoOk,lF3,cTransact,aButtons,aParam,aAuto,lVirtual,lMaximized)
//EnchAuto(cAlias,aAuto,{|| Obrigatorio(aGets,aTela).And.Eval(bOk).And.Eval(bOk2,nOpc)},nOpc,aCpos)
			vCad := { {"ZCC_FILIAL"	,xFilial("ZCC")			,NIL},;
					 	  {"ZCC_REV"	,"02"					,NIL},;
					 	  {"ZCC_TABELA"	,"ZCC"				,NIL},;
					 	  {"ZCC_USUAR"		,"1234567890"			,NIL}}
AxInclui(cString,,nOpc,,,,,,,,,vCad,.F.,)
//AxInclui( cString,,,,,,"U_PPAC006F  ("+AllTrim(Str(nOpc))+")",,,)  

Return ()
//==========================Fim da Incluis�o de Registros==========================================
*/
