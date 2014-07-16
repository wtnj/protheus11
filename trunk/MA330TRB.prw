#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA330TRB  � Autor � Dema Informatica   � Data �  16/01/12   ���
�������������������������������������������������������������������������͹��
���Descricao � AJUSTAR O ARQUIVO TRB DO RCM ANTES DO PROCESSAMENTO FINAL  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MA330TRB()

Local nTotRec   := 0
Local nAtuRec   := 0
Local nRecno    := 0
Local aArea     := GetArea()
Local aAreaSd3  := SD3->(GetArea('SD3'))

If !GetMv( "MV_XUMT330" , .T., .T. ) 
	RestArea(aArea)
	RestArea(aAreaSd3)
	Return()
Else
	dbSelectArea('TRB')
	nTotRec:=LastRec()
	dbSelectArea('TRB')
	Procregua(nTotRec)
	dbGoTop()
	While !Eof()
		
		IncProc('Ajustando Sequencia: '+StrZero(nAtuRec,6)+' de '+StrZero(nTotRec,6))
		
		RecLock('TRB',.F.)
		If AllTrim(TRB->TRB_CF) $ 'DE6/DE4' .Or. AllTrim(TRB->TRB_CF) $ 'RE6/RE4'
			TRB->TRB_ORDEM 	:= '101'
			TRB->TRB_NIVSD3	:= '1'
			If AllTrim(TRB->TRB_CF) == "RE4"
				TRB->TRB_ORDEM 	:= '301'
				TRB->TRB_NIVSD3	:= SubStr(TRB->TRB_NIVSD3,1,5)+'w'
			EndIf
		ElseIf AllTrim(TRB->TRB_CF) == 'DE0' .Or. AllTrim(TRB->TRB_CF) == 'RE0'
			If Empty(TRB->TRB_OP)
				TRB->TRB_ORDEM 	:= '301'
				TRB->TRB_NIVSD3	:= '9'
				If AllTrim(TRB->TRB_CF) == 'RE0'
					TRB->TRB_ORDEM 	:= '300'
					TRB->TRB_NIVSD3	:= '9w'
				EndIf
			ElseIf AllTrim(TRB->TRB_CF) == 'RE0'
				TRB->TRB_ORDEM 	:= '300'
				TRB->TRB_NIVSD3	:= SubStr(TRB->TRB_NIVSD3,1,5)+'w'
			ElseIf AllTrim(TRB->TRB_CF) == 'DE0'
				TRB->TRB_NIVSD3	:= StrZero(Val(TRB->TRB_NIVSD3)-1,2)
			EndIf
		Endif
		
		MsUnlock()
		
		dbSelectArea('TRB')
		dbSkip()
	EndDo
EndIf
dbSelectArea('TRB');dbGoTop()
RestArea(aArea)
RestArea(aAreaSd3)

Return