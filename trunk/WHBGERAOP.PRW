/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WHBGERAOP ºAutor  ³João Felipe da Rosa º Data ³  18/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera as OPS faltantes das Ordens de Serviço de Manutenção  º±±
±±º          ³ na tabela SC2.                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE 'TOPCONN.CH'

USER FUNCTION WHBGERAOP()   
	Processa({|| fGera(), 'Gerando...'})
Return

Static function fGera()
Local nCount := 0
LOCAL cQuery

	procregua(0)

	cQuery := " SELECT * FROM "+RETSQLNAME("STJ")+" STJ "
	cQuery += " WHERE TJ_ORDEM NOT IN (SELECT C2_NUM FROM SC2FN0 WHERE D_E_L_E_T_='')" // AND C2_EMISSAO >= '20130401')
//	cQuery += " AND TJ_DTORIGI >= '"+(strzero(YEAR(ddatabase),4)+strzero(month(ddatabase),2)+'01')+"' "
	cQuery += " AND TJ_TIPO IN ('COR','PRV','PRG') "
	cQuery += " AND D_E_L_E_T_ = '' "
	cQuery += " AND TJ_SITUACA <>'C' "
	
	tcquery cquery new alias "SEMOP"
	
	While SEMOP->(!EOF())
	
		incproc()
	
		Reclock("SC2",.T.)
			SC2->C2_FILIAL  := xFilial("SC2")
			SC2->C2_NUM     := SEMOP->TJ_ORDEM
			SC2->C2_ITEM    := 'OS'
			SC2->C2_SEQUEN  := '001'
			SC2->C2_PRODUTO := 'MANUTENCAO'
			SC2->C2_LOCAL   := '21'
			SC2->C2_CC      := SEMOP->TJ_CCUSTO
			SC2->C2_QUANT   := 5520
			SC2->C2_UM      := 'UN'
			SC2->C2_DATPRI  := STOD(SEMOP->TJ_DTPRINI)
			SC2->C2_DATPRF  := STOD(SEMOP->TJ_DTPRINI)
			SC2->C2_OBS     := 'PLANO '+ SEMOP->TJ_PLANO
			SC2->C2_EMISSAO := STOD(SEMOP->TJ_DTORIGI)
			SC2->C2_PRIOR   := '500'
			SC2->C2_STATUS  := 'U'
			SC2->C2_DESTINA := 'E'
			SC2->C2_NIVEL   := '99'
			SC2->C2_DATAJI  := STOD(SEMOP->TJ_DTORIGI)
			SC2->C2_DATAJF  := STOD(SEMOP->TJ_DTORIGI)
			SC2->C2_SEQPAI  := '000'
			SC2->C2_TPOP    := 'F'
			SC2->C2_ROTINA  := 'MANUAL'
			SC2->C2_USUARIO := 'MANUTENCAO'
			SC2->C2_BATROT  := 'MNTA420'
			SC2->C2_BATCH   := 'S'
			SC2->C2_BATUSR  := '000586'
		Msunlock("SC2")
	
		nCount++
		
		SEMOP->(dbskip())
	ENDDO
	
	Alert('OPs Geradas: '+alltrim(str(ncount)))
	
	SEMOP->(dbclosearea())

RETURN