/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Nhcom004  � Autor � Marcos R. Roquitski   � Data � 14.04.03 ���
�������������������������������������������������������������������������Ĵ��  
���Descricao �Browse do cadastro de produtos, para anexar imagens.        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico New Hubner.                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
#include "rwmake.ch"  

User Function Nhcom004()   

SetPrvt("CCADASTRO,AROTINA,")

cCadastro := 'Desenhos do Produto'

aRotina := {{ "Pesquisar"    ,"AxPesqui",0,1},;
            { "Anexar"       ,'ExecBlock("NHCOM005",.F.,.F.,0)',0,2},;
            { "Mostra Anexo" ,'ExecBlock("NHCOM006",.F.,.F.,0)',0,2},;
            { "Altera" 		 ,"AxAltera",0,4},;
            { "Legenda"      ,"U_C002Legenda",0,2}}

DbSelectArea("SB1")
SB1->(DbSetOrder(1))
DbGoTop()
            
mBrowse(,,,,"SB1",,"Alltrim(SB1->B1_ANEXO)==''")

Return(nil)    


User Function C002Legenda()

 BrwLegenda("Desenhos","Status",{{"ENABLE", "Com Anexo"},{"DISABLE","Sem Anexo "}})

Return
