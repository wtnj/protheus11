
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHMNT041 �Autor � Jo�o Felipe da Rosa � Data � 30/04/2009  ���
�������������������������������������������������������������������������͹��
���Desc.     � CADASTRO DE DISPOSITIVOS                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP10 - MANUTENCAO DE ATIVOS / DISPOSITIVOS                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
        
User Function NHMNT041()    
Private CCADASTRO
Private AROTINA

cCadastro := OemToAnsi("Dispositivos")
aRotina   := {}
aAdd(aRotina,{ "Pesquisa"		,"AxPesqui"     , 0 , 1})
aAdd(aRotina,{ "Visualizacao"	,"U_MNT41(2)" 	, 0 , 2})
aAdd(aRotina,{ "Incluir"		,"U_MNT41(3)" 	, 0 , 3})
aAdd(aRotina,{ "Alterar"		,"U_MNT41(4)" 	, 0 , 4})
aAdd(aRotina,{ "Excluir"		,"U_MNT41(5)" 	, 0 , 5})
aAdd(aRotina,{ "Anexo"			,"U_MNT41ANX()" 	, 0 , 4})

mBrowse( 6, 1,22,75,"ZBN",,,,,,)

Return

User Function MNT41ANX()
	MsDocument('ZBN',ZBN->(RECNO()), 4)
Return

//������������������Ŀ
//� FUNCAO PRINCIPAL �
//��������������������
USER FUNCTION MNT41(nParam)
Private nPar  := nParam
Private oDisp

	If nPar==3 //incluir
		oDisp := Dispositivo():New()  //novo dispositivo
	Else //visualizar, alterar, excluir
		oDisp := Dispositivo():New(ZBN->ZBN_COD,ZBN->ZBN_LETRA) //carrega um dispositivo j� existente
	EndIf

	oDisp:Tela(nPar)

RETURN