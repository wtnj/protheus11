/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �NHQDO007  � Autor � Marcos R. Roquitski   � Data � 28.04.03 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Valida o acesso ao Usuario no cadastro de Documentos        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �New Hubner                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Atualiz. �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#Include "rwmake.ch"
                        
User Function Nhqdo007()

SetPrvt("_aGrupo,_cApelido,lFlag")
_aGrupo   := pswret()
_cApelido := _agrupo[1,2]
lFlag     := .F.

SX5->(DbSetOrder(1))
SX5->(DbSeek(xFilial("SX5")+"ZD")) // Tabela de valida��o de Usuarios, Grupos e Local Padr�o                  
While !SX5->(Eof()) .And. SX5->X5_TABELA == "ZD"
   If Alltrim(Substr(SX5->X5_DESCRI,1,16)) == Upper(Alltrim(Subs(_cApelido,1,16))) //Verifica se o Usuario � o mesmo da tabela ZD no SX5
      If Upper(AllTrim(Subs(SX5->X5_DESCRI,17,6))) == Alltrim(M->QDH_CODTP) //Verifica se o Usuario pode cadastrar este tipo de documento
         lFlag := .T.
         Exit
      Endif   
   Endif
   SX5->(DbSkip())
Enddo

If !lFlag  // Usuario sem permiss�o para cadastrar o Grupo
   MsgBox("Usuario sem Permiss�o para Cadastrar este Tipo de Documento","Atencao","STOP")
   Return(lFlag)  // retorna
Endif                        

Return(lFlag)
               