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
!Nome              ! A0203                                                   !
+------------------+---------------------------------------------------------+
!Descricao         ! GATILHO                                                 !
!                  ! Executado no campo C1_PRODUTO para buscar o valor de    !
!                  ! compra e sugerir no campo C1_PRCUNI                     !
+------------------+---------------------------------------------------------+
!Autor             ! PAULO SERGIO SALVADOR                                   !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 26/05/2014                                              !
+------------------+---------------------------------------------------------+
Essa está sendo executada no gatilho C1_PRODUTO-005.
Retorna o conteúdo para o campo C1_PRCUNI.
*/

#include "rwmake.ch"
#include "topconn.ch"

User Function A0203()
         
Local aArea     := GetArea()
Local _cCampo   := Upper(Alltrim(Substr(ReadVar(),4)))
Local _npCod    := aScan(aHeader,{|x|UPPER(Alltrim(x[2]))==_cCampo})
Local _cProduto := aCols[n][_npCod]
Local _nPrcUni  := 0
Local cDataFim  := Dtos(dDataBase)
Local cDataIni  := Dtos(dDataBase-180)
Local _cQuery
Local lPrcPco   := Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_PRCPCO")<>'2'

If aCols[n][len(aHeader)+1]  //so executa se a linha digitada estiver ativa
	Return(_nPrcUni)
Endif

If !lPrcPco  //so executa se o produto tiver o preco controlado parao PCO
	Return(_nPrcUni)
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
If Select("TD1")<>0
	TD1->(dbCloseArea("TD1"))
Endif
MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TD1",.T.,.T.)},"Selecionando registros...")
TcSetField("TD1","D1_VUNIT","N",TamSX3("D1_VUNIT")[1],TamSX3("D1_VUNIT")[2])
dbSelectArea('TD1');dbGoTop()
While !Eof()
	_nPrcUni  := TD1->D1_VUNIT
	dbSelectArea('TD1');dbSkip();Loop
End

RestArea(aArea)

Return(_nPrcUni)