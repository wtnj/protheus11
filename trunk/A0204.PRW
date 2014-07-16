/*
+----------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualizacao                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! Compras                                              !
+------------------+---------------------------------------------------------+
!Nome              ! A0204                                                   !
+------------------+---------------------------------------------------------+
!Descricao         ! VALIDACAO DO USUARIO                                    !
!                  ! Executado na saida do campo C1_PRCUNI para validar o    !
!                  ! valor digitado e permitir ou nao alteracao              !
+------------------+---------------------------------------------------------+
!Autor             ! PAULO SERGIO SALVADOR                                   !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 26/05/2014                                              !
+------------------+---------------------------------------------------------+
Essa funcao está cadastrada no campo X3_VLDUSR do campo C1_PRCUNI.
Retorna mensagem se o usuario pode ou não alterar o conteúdo do campo.
*/

#include "rwmake.ch"
#include "topconn.ch"

User Function A0204()

Local _cCampo    := Upper(Alltrim(Substr(ReadVar(),4)))
Local _npPrcUni  := aScan(aHeader,{|x|UPPER(Alltrim(x[2]))==_cCampo})
Local _nPrcUni   := aCols[n][_npPrcUni]
Local _nValCpo   := &(ReadVar())
Local _lRet      := .T.
Local _npCod     := aScan(aHeader,{|x|UPPER(Alltrim(x[2]))=="C1_PRODUTO"})
Local _cProduto  := aCols[n][_npCod]
Local cDataFim   := Dtos(dDataBase)
Local cDataIni   := Dtos(dDataBase-180)
Local _cQuery
Local lPrcPco   := Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_PRCPCO")<>'2'

If aCols[n][len(aHeader)+1]  //so executa se a linha digitada estiver ativa
	//SysRefresh()
	Return(_lRet)
Endif

If !lPrcPco  //so executa se o produto tiver o preco controlado parao PCO
	Return(_lRet)
Endif
              
If _nPrcUni == 0
	Return(_lRet)
Endif

_cQuery := "SELECT DISTINCT SD1.D1_VUNIT "
_cQuery += "FROM "
_cQuery += RetSqlName('SD1')+" SD1 "
_cQuery += "WHERE 1=1 "
_cQuery += "AND SD1.D1_FILIAL = '"+xFilial("SD1")+"' " 
_cQuery += "AND SD1.D1_COD = '"+_cProduto+"' "
_cQuery += "AND SD1.D1_DTDIGIT = "
_cQuery += "( "
_cQuery += "SELECT MAX(XD1.D1_DTDIGIT) "
_cQuery += "FROM "
_cQuery += RetSqlName('SD1')+" XD1 "
_cQuery += "WHERE 1=1 "
_cQuery += "AND XD1.D1_FILIAL = SD1.D1_FILIAL "
_cQuery += "AND XD1.D1_COD = SD1.D1_COD "
_cQuery += "AND XD1.D_E_L_E_T_ = ' ' "
_cQuery += ") "
_cQuery := ChangeQuery(_cQuery)
If Select("XD1")<>0
	XD1->(dbCloseArea("XD1"))
Endif
MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"XD1",.T.,.T.)},"Selecionando registros...")
TcSetField("XD1","D1_VUNIT","N",TamSX3("D1_VUNIT")[1],TamSX3("D1_VUNIT")[2])
dbSelectArea('XD1');dbGoTop()
While !Eof()
	_nPrcUni  := XD1->D1_VUNIT
	dbSelectArea('XD1');dbSkip();Loop
End
  
If _nPrcUni <> _nValCpo
	_lRet := .F.
	MsgStop('Atencao...O valor alimentado automaticamente: '+Alltrim(Str(_nPrcUni,12,2))+' não pode ser alterado pelo operador...!!!')
Endif

Return(_lRet)