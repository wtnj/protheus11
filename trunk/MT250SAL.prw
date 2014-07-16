/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT250SAL Autor:Jos� Henrique M Felipetto  Data �  01/10/12  ���
�������������������������������������������������������������������������͹��
���Desc.     �  O ponto de entrada MT250SAl � executado no final da fun��o 
A250TudoOk() que � respons�vel por validar as informa��es digitadas no 
apontamento de produ��o. Com este ponto de entrada o usu�rio poder� 
manipular os valores de saldos dos produtos a serem requisitados pelo 
apontamento em quest�o..                                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � PCP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT250SAL()
Local aSaldos := ParamIxb[1]
Local nQuant  := M->D3_QUANT //-- quantidade apontada na op
Local cProd   := SC2->C2_PRODUTO //-- produto a ser produzido
Local aAreaB2 := SB2->(getarea()) //-- guarda a area do sb2
Local aAreaG1 := SG1->(getarea()) //-- guarda a area do sg1

//If Alltrim(Upper(Funname())) $ "NHPCP043"
	SG1->(dbsetorder(1)) // G1_FILIAL+G1_COD+G1_COMP+G1_TRT
	SB2->(dbsetorder(1)) // B2_FILIAL + COD + LOCAL
	

	For y := 1 to Len(aSaldos)
		
		//-- quando produto for MOD, retornamos saldo suficiente para nao dar erro MA240NEGAT no execauto e finalizar o processo com Disarmtransaction()
		//-- o saldo retornado neste ponto de entrada n�o interfere no saldo do produto MOD.
		If Substr(aSaldos[y][1],1,3)$'MOD'
			aSaldos[y][3] := 9999999
		ElseIf Alltrim(Upper(Funname())) $ "NHPCP043"
		
			If SG1->(dbseek(xFilial('SG1')+cProd+aSaldos[y][1]))
				SB2->(dbSeek(xFilial("SB2")+aSaldos[y][1]+aSaldos[y][2]))
				aSaldos[y][3] := SB2->B2_QATU - SB2->B2_QACLASS - SB2->B2_RESERVA - SB2->B2_QTNP - (SG1->G1_QUANT * nQuant) // formula do saldo subtraido da quantidade a utilizar
			Endif
		Endif
	Next y

//EndIf

SB2->(restarea(aAreaB2)) //-- recupera a area do sb2
SG1->(restarea(aAreaG1)) //-- recupera a area do sg1

	PutMv("MV_INDNEG","S")
	
Return (aSaldos)

User Function A250ETRAN()
	PutMv("MV_INDNEG","E")
Return