#include "rwmake.ch"
#include "acadef.ch"

static aPrefixo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AC060DLB  ºAutor  ³Rafael Rodrigues    º Data ³  08/21/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada antes da exclusao de titulos.              º±±
±±º          ³Utilizado para permitir ou nao a exclusao quando for transf.º±±
±±º          ³                                                            º±±
±±º          ³No caso de requerimentos de transferecia:                   º±±
±±º          ³Neste momento o JBE esta posicionado no curso de destino    º±±
±±º          ³e o SE1 esta posicionado no titulo de origem.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AC060DLB()
Local lRet	:= .F.
Local lEst  := iif( ParamIXB[1] == NIL, .F., ParamIXB[1] )
Local aAreaSE1
Local aAreaJBE
Local aAreaJC7
Local aAreaJBA
Local aArea
Local cTrab
Local cTipo
Local nParc   

// So entra se a funcao de menu for "Requerimentos"
// e se for um dos requerimentos de transferencia
if ( FunName() == "ACAA410" .and. Posicione("JBF",1,xFilial("JBF")+JBH->(JBH_TIPO+JBH_VERSAO),"JBF_TRANSF") == "1" ) .or. ( FunName() == "ACAA060" .And. ! lEst )

	aArea := GetArea()
	
	if aPrefixo == nil
		aPrefixo := ACPrefixo()
	endif
	
	if SE1->E1_PREFIXO == aPrefixo[__ADA]
		cTipo := '001'
	elseif SE1->E1_PREFIXO == aPrefixo[__DEP]
		cTipo := '002'
	elseif SE1->E1_PREFIXO == aPrefixo[__TUT]
		cTipo := '006'
	elseif SE1->E1_PREFIXO $ aPrefixo[__MES]+"/"+aPrefixo[__MAT]
		cTipo := '010'
	else
		lRet := .T.
	endif
	
	if !lRet
		// Cria o arquivo de trabalho com a mesma estrutura do SE1
		cTrab := CriaTrab( SE1->( dbStruct() ), .T. )
		dbUseArea( .T.,, cTrab, "TRBDLB", .F., .F. )
		
		if Val(SE1->E1_PARCELA) == 0
	        if GetMV("MV_1DUP") == "1"
                nParc := ASC(SE1->E1_PARCELA)-55
	        else
                nParc := ASC(SE1->E1_PARCELA)-64
    	    endif
		else
        	nParc := Val(SE1->E1_PARCELA)
		endif

		aAreaSE1 := SE1->( GetArea() )
		aAreaJBE := JBE->( GetArea() )
				
		// Essa rotina vai simular a geracao do título usando o alias TRBDLB, e entao poderemos comparar os valores
		AC680BOLET(nil, cTipo, JBE->JBE_NUMRA, JBE->JBE_NUMRA, JBE->JBE_CODCUR, JBE->JBE_CODCUR, nParc, JBE->JBE_PERLET, JBE->JBE_TURMA,,, .F., .F., .F., "TRBDLB", JBE->JBE_HABILI )
		
		JBE->( RestArea( aAreaJBE ) )
		SE1->( RestArea( aAreaSE1 ) )
		
		TRBDLB->( dbGoTop() )
		lRet := TRBDLB->( eof() )
			
		// Se o boleto atual for por disciplina, posiciona o TRBDLB na disciplina equivalente
		if !lRet .and. !Empty( Subs( SE1->E1_NRDOC, 9, 15 ) )
		
			// Deixa o lRet como .T. para, caso nao exista titulo equivalente no TRB, eliminar o titulo atual.
			lRet := .T. .and. !ExistBlock("AC680DP")
			
			while lRet .and. TRBDLB->( !eof() )
				if Subs( SE1->E1_NRDOC, 9, 15 ) == Subs( TRBDLB->E1_NRDOC, 9, 15 )
					lRet := .F.
				else
					TRBDLB->( dbSkip() )
				endif
			end
		endif
		
		if !lRet
			if TRBDLB->E1_VALOR <> SE1->E1_VALOR .OR. TRBDLB->E1_PREFIXO <> SE1->E1_PREFIXO
				
				lRet := .T.		// Permite eliminar o titulo, pois os valores sao diferentes
				
			else
				
				// Se for aproveitar o titulo, muda o NRDOC do titulo
				SE1->( RecLock( "SE1", .F. ) )
				SE1->E1_NRDOC := JBE->JBE_CODCUR + JBE->JBE_PERLET + Subs( SE1->E1_NRDOC, 9 )
				SE1->( msUnlock() )

				// E atualiza o JBE_BOLETO ou JC7_BOLETO, dependendo se o titulo eh por disciplina ou nao.
				if Empty( Subs( SE1->E1_NRDOC, 9, 15 ) )
					JBE->( RecLock( "JBE", .F. ) )
					JBE->JBE_BOLETO := Subs( JBE->JBE_BOLETO, 1, nParc - 1 ) + "X" + Subs( JBE->JBE_BOLETO , nParc + 1 )
					JBE->( msUnlock() )
				else
					aAreaJC7 := JC7->( GetArea() )
					aAreaJBA := JBA->( GetArea() )

					if ExistBlock("AC680DP")
						JC7->( dbSetOrder(1) )
						JBA->( dbSetOrder(1) )
						JBA->( dbSeek( xFilial("JBA") + Subs( SE1->E1_NRDOC, 9, TamSX3("JBA_COD")[1] ) ) )
						while JBA->( !eof() ) .and. JBA->( JBA_FILIAL + JBA_COD ) == Subs( SE1->E1_NRDOC, 9, TamSX3("JBA_COD")[1] )
							JC7->( dbSeek( xFilial("JC7") + JBE->( JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_TURMA ) + JBA->JBA_CODDIS ) )
							while JC7->( !eof() ) .and. JC7->( JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_TURMA+JC7_DISCIP ) == xFilial("JC7") + JBE->( JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_TURMA ) + JBA->JBA_CODDIS
								JC7->( RecLock( "JC7", .F. ) )
								JC7->JC7_BOLETO := Subs( JC7->JC7_BOLETO, 1, nParc - 1 ) + "X" + Subs( JC7->JC7_BOLETO , nParc + 1 )
								JC7->( msUnlock() )
								
								JC7->( dbSkip() )
							end
							JBA->( dbSkip() )
						end
					else
						JC7->( dbSetOrder(1) )
						JC7->( dbSeek( xFilial("JC7") + JBE->( JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_TURMA ) + Subs( SE1->E1_NRDOC, 9, 15 ) ) )
						while JC7->( !eof() ) .and. JC7->( JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_TURMA+JC7_DISCIP ) == xFilial("JC7") + JBE->( JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_TURMA ) + Subs( SE1->E1_NRDOC, 9, 15 )
							JC7->( RecLock( "JC7", .F. ) )
							JC7->JC7_BOLETO := Subs( JC7->JC7_BOLETO, 1, nParc - 1 ) + "X" + Subs( JC7->JC7_BOLETO , nParc + 1 )
							JC7->( msUnlock() )
							
							JC7->( dbSkip() )
						end
					endif
					JBA->( RestArea( aAreaJBA ) )
					JC7->( RestArea( aAreaJC7 ) )
				endif
			endif
		endif
			
		// Elimina o arquivo de trabalho
		dbSelectArea("TRBDLB")
		dbCloseArea()
		FErase( cTrab + GetDBExtension() )
	endif
	
	RestArea( aArea )
else
	lRet := .T.
endif

Return lRet
