/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � NHFIN014 � Autor � Jose Roberto Gorski   � Data � 11/05/00 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Tela de Acerto de Viagem                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para a New Hubner                               ���
�������������������������������������������������������������������������Ĵ��
��� Arquivos � SZ3,SZ4                                                    ���
�������������������������������������������������������������������������Ĵ��
��� Alterac. �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#include "rwmake.ch"  

User Function Nhfin014() 

SetPrvt("CCADASTRO,AROTINA,")

cCadastro := 'Atendimento dos Adiantamentos de Viagem'
aRotina := {{ "Pesquisa","AxPesqui"                        , 0 , 1},;
            { "Visual"  ,"AxVisual"                        , 0 , 2},;
            { "Acerto"  ,'ExecBlock("NHFIN011",.f.,.f.,01)', 0 , 3},;
            { "Exclui Acerto"  ,'U_fExclui()', 0 , 4},;                        
            { "Legenda" ,"U_Fa014Legenda",0,2}}


mBrowse(06,01,22,75,"SZ3",,,,,,fCriaCor())

Return

User Function fExclui() 

	If !MsgBox ("Tem Certeza em Excluir o Acerto do Adiantamento de Viagem Numero "+SZ3->Z3_NUM,"Exclusao de Acerto de Viagem","YESNO")
	   Return
	Endif

   Begin Transaction
	   RecLock("SZ3",.f.)
	   SZ3->Z3_GEROUAC := " "
  	   SZ3->Z3_STATUS  := "A"
	   MsUnLock("SZ3")
	
	   // Libera para a Geracao de Novo Acerto de Viagem
	   If SZ4->(DbSeek(xFilial("SZ4")+SZ3->Z3_NUM))
	      RecLock("SZ4",.f.)
	      SZ4->(DbDelete())
	      MsUnLock("SZ4")
	   Endif
	End Transaction   
	
Return


User Function Fa014Legenda()       

Local aLegenda :=	{	{"BR_AZUL"    , "Pendente" },;
  							{"BR_VERMELHO", "Liberado" },;
  							{"BR_VERDE"   , "Aberto"   }}

BrwLegenda("Acerto de Viagem", "Legenda", aLegenda)

Return  


Static Function fCriaCor()       

Local aLegenda :=	{	{"BR_AZUL"    , "Pendente" },;
  							{"BR_VERMELHO", "Liberado" },;
  							{"BR_VERDE"   , "Aberto"   }}

Local uRetorno := {}
Aadd(uRetorno, { 'Z3_STATUS = "P"' , aLegenda[1][1] } )
Aadd(uRetorno, { 'Z3_STATUS = "F"' , aLegenda[2][1] } )
Aadd(uRetorno, { 'Z3_STATUS = "A"' , aLegenda[3][1] } )

Return(uRetorno)

