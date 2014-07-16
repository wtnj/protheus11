 #INCLUDE "rwmake.ch"

/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Cadastro                                                !
+------------------+---------------------------------------------------------+
!Modulo            ! FAT - Faturamento                                       !
+------------------+---------------------------------------------------------+
!Nome              ! AFAT001.PRW                                             !
+------------------+---------------------------------------------------------+
!Descricao         ! Tipos de composição para a lista de preços.             !
+------------------+---------------------------------------------------------+
!Autor             ! Cleverson Funaki                                        !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 20/06/2012                                              !
+------------------+---------------------------------------------------------+
!   ATUALIZACOES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+ 
*/
User Function NHEST216
	Private cCadastro := "Tipos de Composição"
	Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
			             {"Visualizar","AxVisual",0,2} ,;
			             {"Incluir","U_EST216A",0,3} ,;
			             {"Alterar","AxAltera",0,4} ,;
			             {"Excluir","AxDeleta",0,5} }
	Private cDelFunc := ".T."
	Private cString := "Z01"

	dbSelectArea("Z01")
	dbSetOrder(1)

	dbSelectArea(cString)
	mBrowse( 6,1,22,75,cString)
Return

User Function EST216A(cAlias,nReg,nOpc)
	Local _aArea := GetArea()
	Local _nOpc := 0
	Local _cCodAux := ""
	
	_nOpc := AxInclui("Z01",Z01->(RecNo()),3,,,,"U_EST216B()")
	
	If _nOpc == 1
		// Se for analítico, verifica se existe o tipo sintético cadastrado
		If Z01->Z01_TIPO == "A"
			_cCodAux := Substr(Z01->Z01_CODIGO,1,3)
			
			If SELECT("QZ01") > 0
				QZ01->(dbCloseArea())
			Endif
			
			BeginSql Alias "QZ01"
				SELECT Z01.Z01_CODIGO
				  FROM %table:Z01% Z01
				 WHERE Z01.Z01_FILIAL = %xFilial:Z01%
				   AND Z01.Z01_CODIGO = %Exp:_cCodAux%
				   AND Z01.Z01_TIPO = 'S'
				   AND Z01.%NotDel%
			EndSql
			
			If QZ01->(EOF())
				Aviso("Atenção!","Não existe o sintético para este tipo. Será incluído um registro, favor alterar a descrição manualmente.",{"Ok"},2)
				
				RecLock("Z01",.T.)
				Z01->Z01_FILIAL := xFilial("Z01")
				Z01->Z01_CODIGO := _cCodAux
				Z01->Z01_DESCRI := "."
				Z01->Z01_TIPO = "S"
				MsUnlock("Z01")
			Endif
			QZ01->(dbCloseArea())
		Endif
	Endif
	
	RestArea(_aArea)
Return

User Function EST216B
	// Verifica se o código e o tipo são compatíveis
	If M->Z01_TIPO == "S" .And. Len(Alltrim(M->Z01_CODIGO)) > 3
		Alert("Para o tipo Sintético, o código deverá ter no máximo 3 caracteres.")
		Return(.F.)
	ElseIf M->Z01_TIPO == "A" .And. Len(Alltrim(M->Z01_CODIGO)) < 4
		Alert("Para o tipo Analítico, o código deverá ter no mínimo 4 caracteres.")
		Return(.F.)
	Endif
Return(.T.)