/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Nhmdt009  �Autor  �Marcos R. Roquitski � Data �  03/12/2012 ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida terceiros se nao estiver bloqueado pela Seguranca.  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"
#include "protheus.ch"

User Function Nhmdt009(_ZbwRg)

SetPrvt("_nRg,lEnd,cSrr") 

cSrr     := "TMP_ZBW"
lEnd     := .T.
_cRg     := _ZbwRg
_lRet    := .T.
	
Processa( {|| abreZbw(cSrr) },"Validando cadastro......") 

DbSelectArea(cSrr) 
(cSrr)->(dbgotop())

While (cSrr)->(!eof())

	_cNome  := (cSrr)->ZBW_NOME + ' ' + (cSrr)->ZBW_NOMFOR
	If !Empty((cSrr)->ZBW_RG)

	    If  !Empty((cSrr)->ZBW_DTBLOQ)
			Alert('R.G,  Bloqueado verifique com a Gerencia da Seguranca Patrimonial')
			_lRet := .F.
		Endif

	Endif
	(cSrr)->(DbSkip())

Enddo 

dbSelectArea(cSrr) 
dbCloseArea() 

Return(_lRet) 


// 
static Function abreZbw(cSrr)

//--Fecha Alias Temporario se estiver aberto
If Select(cSrr) > 0
	dbSelectArea(cSrr)
	dbCloseArea()
Endif

//--Consulta as Previs�es de venda
beginSql Alias cSrr
	select ZBW.ZBW_NOME,
	       ZBW.ZBW_RG,
	       ZBW.ZBW_NOMFOR,
	       ZBW.ZBW_DTBLOQ
	from 
		%table:ZBW% ZBW
	where              
	ZBW.ZBW_FILIAL = %xFilial:ZBW%
	and %notDel%
	and ZBW.ZBW_RG = %Exp:_cRg%

endSql

Return 
	