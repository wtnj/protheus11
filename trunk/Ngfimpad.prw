/*
��������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � NGFIMPAD        �                       � Data � 23.04.03 ���
������������������������������������������������������������������������Ĵ��
���Descri��o �                                                           ���
������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                           ���
������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/

User Function NGFIMPAD()
Local lInclOld := Inclui
Local aOldArea := GetArea()
Private Inclui   := .T.
 
Private aChoice  := {},aRelac  := {},bNgGrava := {},aSMENU := {},aCHKDEL := {}
aOldRot  := aClone(aRotina)
Private aRotina := {{"Pesquisar"  ,"PesqBrw" , 0, 1},; 
                    {"Visualizar" ,"AXVISUAL", 0, 2},;
                    {"Incluir"    ,"NG401INC", 0, 3},; 
                    {"Alterar"    ,"NG401INC", 0, 4},; 
                    {"Excluir"    ,"NG401INC", 0, 5, 3}}
 
cPrograma := "MNTA400"
 
aRelac := {{"TPL_ORDEM","STJ->TJ_ORDEM"}}
 
dbSelectArea("TPL")
dbGoBottom()
dbSkip()
 
NGCAD01("TPL",Recno(),3)
 
RestArea(aOldArea)
Inclui := lInclOld      
aRotina := aClone(aOldRot)

Return .t.

 

                                                            