
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHQMT011  �Autor  �Jo�o Felipe da Rosa � Data �  21/06/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � ATUALIZA CAMPO QM2_ULTREV                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � METROLOGIA                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#INCLUDE "rwmake.CH"

User Function NHQMT011()
	Processa({|| NHATUQM2()},"Atualizando tabela QM2 campo QM2_ULTREV ...")      
Return

//������������������Ŀ
//� FUNCAO PRINCIPAL �
//��������������������
Static Function NHATUQM2()
cCod := ''

	ProcRegua(QM2->(RecCount()))
	QM2->(dbSetOrder(1)) //QM2_FILIAL+QM2_INSTR+QM2_REVINV
	QM2->(dbGoTop())
	
	WHILE QM2->(!eof())
		IncProc()
		
		RecLock("QM2",.F.)
			QM2->QM2_ULTREV := Iif(cCod==QM2->QM2_INSTR,"N","S")
		MsUnlock("QM2")
		cCod := QM2->QM2_INSTR
		
		QM2->(dbSkip())
	ENDDO
	
	MsgBox("Atualizado com sucesso!","Ok","INFO")

Return