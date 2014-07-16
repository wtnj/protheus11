#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
//#INCLUDE "LJTER01.CH"

//Posicoes da array aProds (Itens da venda)
#DEFINE ELEMENTOS_PRODUTO      10 //Quantidades de elementos da array aProds

#DEFINE CODIGO_PRODUTO          1
#DEFINE DESCRICAO_PRODUTO       2
#DEFINE PRECO_UNITARIO_PRODUTO  3
#DEFINE QUANTIDADE_PRODUTO      4
#DEFINE VALOR_DESCONTO_PRODUTO  5
#DEFINE VALOR_IPI_PRODUTO       6
#DEFINE TES_PRODUTO			     7
#DEFINE TABELA_PADRAO_PRODUTO   8
#DEFINE VALOR_ACRESCIMO_PRODUTO 9 
#DEFINE VALOR_IMPOSTO_PRODUTO   10

//Posicoes da array aParcelas  (Parcelas a pagar)
#DEFINE DATA_PARCELAS          1
#DEFINE VALOR_PARCELAS         2
#DEFINE FORMA_PAGTO_PARCELAS   3

#IFDEF SPANISH
	Static cOpcaoMenC     := "C"
	Static cOpcaoMenP     := "P"
	Static cOpcaoS        := "S"
	Static cOpcaoE			 := CHR(13)
	Static cOpcaoN        := "N"
#ELSE
	#IFDEF ENGLISH
		Static cOpcaoMenC     := "S"
		Static cOpcaoMenP     := "P"
		Static cOpcaoS        := "Y"
		Static cOpcaoE			 := CHR(13)
		Static cOpcaoN        := "N"
	#ELSE
		Static cOpcaoMenC     := "C"
		Static cOpcaoMenP     := "P"
		Static cOpcaoS        := "S"
		Static cOpcaoE			 := CHR(13)
		Static cOpcaoN        := "N"
	#ENDIF
#ENDIF


/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � LJTER01  �Autor  � Fernando Salvatori    � Data � 12/08/2002���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Programa que efetua um orcamento no Micro-Terminal          ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe   � LJTER01(void)                                               ���
��������������������������������������������������������������������������Ĵ��
���Uso       � MICRO-TERMINAL                                              ���
��������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ���
��������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                    ���
��������������������������������������������������������������������������Ĵ��
���              �        �      �                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function MICROTER()
SetPrvt("cOperador,cMaquina,cProd,lAtiva,cTipoMicro,cMensagem,ndoc")
cOperador  := Space(06)
cMaquina   := Space(06)
cProd      := Space(15)
cTipoMicro := "1" //Alltrim(GetMV("MV_LJTPMIC"))  //Determina o tipo de MicroTerminal(16 ou 40 Teclas)
cMensagem  := ""
lAtiva     := .T.        
ndoc       := 0

	//���������������������������������������������������������������������������Ŀ
	//�Chamada do Menu Principal do Micro Terminal para 16 caracteres em uma linha�
	//�����������������������������������������������������������������������������

TerCls() //Limpa o display do microterminal
TerCBuffer() // limpa o buffer do microterminal

//�Solicita o Codigo do Operador										 �
TerSay(00,00,"Operador: ") 
TerGetRead(00,09,@cOperador,"XXXXXX", {||MOperador(@cOperador)},{||Empty(cOperador)})
 // Solicita a Maquina
TerSay(00,00,"Maquina: ") 
TerGetRead(00,09,@cMaquina,"XXXXXX", {||MMaquina(@cMaquina)},{||Empty(cMaquina)})

SB1->(dbSetOrder(1))      

Do While lAtiva  //Ativa o Loop de entrada de pecas
	
	//���������������������������������������������������������������������������Ŀ
	//�Chamada do Menu Principal do Micro Terminal para 16 caracteres em uma linha�
	//�����������������������������������������������������������������������������

  //-- cCodPro    := Space(15)               // Variavel que guarda o codigo do Vendedor
   cMensagem  := " "
    
   TerCls()
   TerCBuffer()
	
//	If cTipoMicro == "1"	                                                  
		//�Solicita o Codigo do Operador										 �
   TerSay(00,00,"Peca: ") 
   TerGetRead(00,05,@cProd,"XXXXXXXXXXXXXXX", {||MProduto(@cProd)},{||Empty(cProd)})
   TerSay( 01, 00, cMensagem )
//	EndIf

   Reclock("SZE",.T.)
      SZE->ZE_DOC     := strzero(ndoc+=1,10)
      SZE->ZE_OPER    := cOperador
      SZE->ZE_MAQUINA := cMaquina
      SZE->ZE_PRODUTO := cProd
      SZE->ZE_DATA    := Ddatabase
      SZE->ZE_HORA    := Subs(Time(),1,8)
   MsUnLock("SZE")	
   
  // cMensagem  := " "
//--   TerSay( 01, 00, cMensagem )
		
    
   //������������������������������������������������������������������Ŀ
   //�Teclou Esc, sai da funcao e retorna ao passo anterior			 �
   //��������������������������������������������������������������������
   If TerEsc()
  	  lAtiva := .F.
   EndIf

EndDo

//������������������������������������������������������������������Ŀ
//�Funcao que finaliza o Micro-Terminal caso seja feito pelo Monitor.�
//��������������������������������������������������������������������
TerIsQuit()

Return

Static Function MOperador(cOperador)

QAA->(dbSetOrder(1)) //Filial+ matricula
If !QAA->(dbSeek(xFilial("QAA")+cOperador ))
   TerSay(01,00,Padr("Operador Nao Cadastrado.",16)) //
   TerBeep(4)
   Sleep(1000)
   TerSay(01,00,Space(16))    
   cOperador := Space(06)
   Return .F.
EndIf   
Return .T.


Static Function MMaquina(cMaquina)

SZF->(dbSetOrder(1)) //Filial+ codigo da maquina
If !SZF->(dbSeek(xFilial("  ")+cMaquina ))
   TerSay(01,00,Padr("Maq. Nao Cadastrado.",16)) //
   TerBeep(4)
   Sleep(1000)
   TerSay(01,00,Space(16))
   cMaquina := Space(06)
   Return .F.
EndIf   
Return .T.


Static Function MProduto(cProd)

If !SB1->(dbSeek(xFilial("SB1")+cProd ))
   TerSay(01,00,Padr("Produto Nao Cadastrado.",16)) //
   TerBeep(4)
   Sleep(2000)
//   TerSay(01,00,Space(16))   
   cProd := Space(15)
   Return .F.
EndIf        
cMensagem := Padr( SB1->B1_DESC,30 )
cProd := Space(15)
Return .T.

