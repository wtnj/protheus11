/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �NHEST002  � Autor � Jo�o Felipe da Rosa � Data � 31/07/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Criacao do Lotes dos Produtos Automaticamente               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �New Hubner                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Alterado � Alexandre R. Bento - lote na sequencia   � Data � 30.05.03 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

User Function Nhest002(dData)


SetPrvt("aMes, _CDATA,_CLOTE,_CANO,_CMES,_CDIA")

//default dData := Date()     
// 28/05/2014 - Trocado Date() por dDatabase para corrigir lotes criados com database reatroativa porem sendo criados com data do dia atual (Date())
default dData := dDataBase

//-- consistencia A
IF ValType(dData)<>"D" 
	dData := Date()
Endif

_cLote := Space(06)
          
If (!UPPER(Funname())$"MATA103/MATA250/NHEST139/RPC/NHWMS001/NHWMS002/NHEST176/NHEST139/NHWMS007/RPC" .AND. Type("MsgRetWMS")!="C") .OR. !SB1->B1_RASTRO$"L"
	Return(_cLote)
EndIf

// Nao gera lote para os produtos n�o produtivos
If !Upper( Funname() ) $ "NHWMS001/NHWMS002/NHEST176/NHEST139/NHWMS007" // Quando estiver gerando etiquetas no WMS ou Transfer�ncia Usinagem/Fundi��o no EST/CUSTOS, tira as regras.
	If SM0->M0_CODIGO == "NH"
	   If !SB1->B1_TIPO$"PW/CC/MC/CP/MP"
    	  Return(_cLote)
	   Endif
	Elseif SM0->M0_CODIGO == "FN"
	   If !SB1->B1_TIPO$"PW/MA/MP/CP/CC/MC/PA"
    	  Return(_cLote)
	    Endif
	Endif
EndIf

// Construcao de Lotes

// Ano
_cData := dtos(dData)
_cAno  := SubStr(_cData, 3, 2) //-- ano 2 digitos

// Mes
aMes := {"A","B","C","D","E","F","G","H","I","J","K","L"}
_cMes := aMes[ Val(SubStr(_cData, 5, 2)) ] //-- PASSA O MES CONVERTIDO PARA INTEIRO

// Dia
_cDia  := SubStr(_cData, 7, 2)

// Lote
_cLote := alltrim(_cAno + _cMes + _cDia)

IF(LEN(_cLote)<>5)
	Alert("Erro na forma��o do lote! Lote: "+_cLote+" Programa:"+Funname()+" Data:"+_cData)
	break
Endif

Return(_cLote)