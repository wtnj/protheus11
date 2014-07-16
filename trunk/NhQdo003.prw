/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHQDO003  �Autor  �Marcos R. Roquitski � Data �  04/14/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"

User Function NhQdo003()

   SetPrvt("cArquivo")

   cArquivo := Space(40)
   cArquivo := QDH->QDH_ANEXO
	
	@ 200,050 To 350,380 Dialog DlgArquivo Title OemToAnsi("Anexar arquivo ao Documento")

   @ 025,020 Say OemToAnsi("Arquivo ") Size 35,8
      
   @ 024,055 Get cArquivo PICTURE "@!"  Size 70,8
      
   @ 058,050 BMPBUTTON TYPE 01 ACTION GravaDados()
   @ 058,090 BMPBUTTON TYPE 02 ACTION Close(DlgArquivo)
   Activate Dialog DlgArquivo CENTERED

Return


Static Function GravaDados()
   RecLock("QDH",.F.)
   QDH->QDH_ANEXO := cArquivo
   MsUnlock("QDH")
   Close(DlgArquivo)
Return

