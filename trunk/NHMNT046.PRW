
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHMNT046  บAutor  ณJoใo Felipe da Rosa บ Data ณ  25/08/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ RELATORIO DE OS DE DISPOSITIVOS                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP10 - MANUTENCAO DE ATIVOS                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#include "topconn.ch"

User Function NHMNT046()
Private oRelato 

	oRelato          := Relatorio():New()
	
	oRelato:cString  := "ZBO"
    oRelato:cPerg    := "MNT046"
	oRelato:cNomePrg := "NHMNT046"
	oRelato:wnrel    := oRelato:cNomePrg
	oRelato:cTamanho := "G"

	//descricao
	oRelato:cDesc1   := "Este relat๓rio apresenta as Ordens de Servi็o "
	oRelato:cDesc2   := "de dispositivos. "
	oRelato:cDesc3   := ""

	//titulo
	oRelato:cTitulo  := "O.S. DE DISPOSITIVOS"

	//cabecalho
	oRelato:cCabec1  := " Nบ.OS    Tipo        Dispositivo/Letra                                    C.Trab.     C.C                     Dat.Ini     H.Ini        Dat.Fim     H.Fim       Dura็ใo     Mแquina"
    oRelato:cCabec2  := ""
		    
	oRelato:Run({||Imprime()})
	
Return 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ FUNCAO DE IMPRESSAO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function Imprime()
Local nDuracao
Local aTipo     := {"Corretiva","Preventiva","Programada","Corretiva Manut. Rotina","Melhoria"}
Local nTotalHP  := 0 //total horas paradas 

	Processa({|| Gerando()},"Gerando Dados p/ Impressใo...")
	
	oRelato:Cabec()
	
	While TRA1->(!EOF())
	
		If Prow() > 65
			oRelato:Cabec()
		EndIf
		
		@Prow() +1,001 psay TRA1->ZBO_ORDEM
		
		@Prow()  , 010 psay aTipo[Val(TRA1->ZBO_TIPO)]
		@Prow()  , 022 psay ALLTRIM(TRA1->ZBO_DISP)+" - "+TRA1->ZBO_LETRA
		@Prow()  , 075 psay TRA1->ZBO_CTRAB
		@Prow()  , 087 psay TRA1->ZBO_CC
		@Prow()  , 111 psay TRA1->ZBO_DATINI
		@Prow()  , 123 psay Substr(TRA1->ZBO_HORINI,1,5)
		@Prow()  , 136 psay TRA1->ZBO_DATFIM
		@Prow()  , 148 psay TRA1->ZBO_HORFIM
		@Prow()  , 160 psay fDuracao(TRA1->ZBO_DATINI,TRA1->ZBO_DATFIM,TRA1->ZBO_HORINI,TRA1->ZBO_HORFIM)
		
		nTotalHP += HoraToInt(fDuracao(TRA1->ZBO_DATINI,TRA1->ZBO_DATFIM,TRA1->ZBO_HORINI,TRA1->ZBO_HORFIM))
	
		@Prow()  , 172 psay AllTrim(TRA1->ZBO_CODBEM)

		ZBN->(dbSetOrder(1)) // FILIAL + DISP + LETRA
		If ZBN->(dbSeek(xFilial("ZBN")+TRA1->ZBO_DISP+TRA1->ZBO_LETRA))
			@Prow()+1 , 022 psay Substr(ZBN->ZBN_DESC,1,60)
		EndIf
		
		CTT->(dbSetOrder(1)) //FILIAL + CC
		If CTT->(dbSeek(xFilial("CTT")+TRA1->ZBO_CC))
			@Prow()  , 087 psay Substr(CTT->CTT_DESC01,1,30)
		EndIf

		ST9->(dbSetOrder(1)) //FILIAL + CODIGO
		If ST9->(dbSeek(xFilial("ST9")+TRA1->ZBO_CODBEM))
			@Prow()  , 172 psay Substr(ST9->T9_NOME,1,40)
		EndIf
		
		ZBO->(dbGoTO(TRA1->ZBO_RECNO))//posiciona a tabela ZBO no registro corrente

		@Prow()+2, 010 Psay "PROBLEMA: "
		For x:=1 To MlCount(ALLTRIM(ZBO->ZBO_PROBLE),70)
	  		@Prow()+Iif(x==1,0,1) , 022 Psay MemoLine(ZBO->ZBO_PROBLE,70,x)
		Next
		
		@Prow()+2, 010 Psay "CAUSA RAIZ: "
		For x:=1 To MlCount(ALLTRIM(ZBO->ZBO_CRAIZ),70)
	  		@Prow()+Iif(x==1,0,1) , 022 Psay MemoLine(ZBO->ZBO_CRAIZ,70,x)
		Next

		@Prow()+2, 010 Psay "SOLUCAO: "
		For x:=1 To MlCount(ALLTRIM(ZBO->ZBO_SOLUC),70)
	  		@Prow()+Iif(x==1,0,1) , 022 Psay MemoLine(ZBO->ZBO_SOLUC,70,x)
		Next
		
		If Prow() > 65
			oRelato:Cabec()
		EndIf

		@Prow()+2 , 010 Psay "---INSUMOS"+Repli("-",60)+"inicio"+Repli("-",17)+"fim"+Repli("-",15)+"dura็ใo"+Repli("-",92)
		
		/**********
		* INSUMOS *
		**********/
		ZBP->(dbSetOrder(1)) // FILIAL + ORDEM
		ZBP->(dbSeek(xFilial("ZBP")+TRA1->ZBO_ORDEM))
		
		While ZBP->(!EOF()) .AND. ZBP->ZBP_ORDEM==TRA1->ZBO_ORDEM
			
			If Prow() > 65
				oRelato:Cabec()
			EndIf

			@Prow()+1 , 010 Psay ZBP->ZBP_TIPO
			@Prow()   , 016 Psay ZBP->ZBP_CODIGO
			
			If ZBP->ZBP_TIPO=="M"
				QAA->(dbSetOrder(1))
				If QAA->(dbSeek(xFilial("QAA")+ZBP->ZBP_CODIGO))
					@Prow()   , 031 Psay SUBSTR(QAA->QAA_NOME,1,40)
				EndIf
				
				@Prow()   , 078 Psay ZBP->ZBP_DATINI
				@Prow()   , 090 Psay ZBP->ZBP_HORINI
				@Prow()   , 100 Psay ZBP->ZBP_DATFIM
				@Prow()   , 112 Psay ZBP->ZBP_HORFIM
				@Prow()   , 122 Psay fDuracao(ZBP->ZBP_DATINI,ZBP->ZBP_DATFIM,ZBP->ZBP_HORINI,ZBP->ZBP_HORFIM)
				
				@Prow()   , 135 Psay "DESCRIวรO: "
				For x:=1 To MlCount(ALLTRIM(ZBP->ZBP_DESC),70)
			  		@Prow()+Iif(x==1,0,1) , 146 Psay MemoLine(ZBP->ZBP_DESC,70,x)
				Next
				
			ElseIf ZBP->ZBP_TIPO=="P"
				SB1->(dbSetOrder(1))
	
				If SB1->(dbSeek(xFilial("SB1")+ZBP->ZBP_CODIGO))
					@Prow()   , 031 Psay SUBSTR(SB1->B1_DESC,1,40)
				EndIf
			EndIf
		
			ZBP->(dbSkip())
		EndDo

		@Prow() +2,000 psay __PrtThinLine()

		TRA1->(dbSkip())
		
	ENDDO

	@Prow() +1,000 psay __PrtThinLine()
	@Prow() +1,000 psay "Total de horas paradas: "+AllTrim(IntToHora(nTotalHP,Len(AllTrim(Str(Int(nTotalHP))))))

	TRA1->(DbCloseArea())
Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ GERA OS DADOS PARA IMPRESSรO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function Gerando()
Local cQuery 

	mv_par17 := Iif(AllTrim(mv_par17)$":","",mv_par17) //de hora inicial
	mv_par18 := Iif(AllTrim(mv_par18)$":","",mv_par18) //ate hora inicial
	mv_par19 := Iif(AllTrim(mv_par19)$":","",mv_par19) //de hora final
	mv_par20 := Iif(AllTrim(mv_par20)$":","",mv_par20) //ate hora final
	mv_par21 := Iif(AllTrim(mv_par21)$":","",mv_par21) //de hora prev
	mv_par22 := Iif(AllTrim(mv_par22)$":","",mv_par22) //ate hora prev

	cQuery := "SELECT ZBO.*, ZBO.R_E_C_N_O_ AS ZBO_RECNO "
	cQuery += " FROM "+RetSqlName("ZBO")+" ZBO "
	cQuery += " WHERE ZBO.ZBO_ORDEM BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND ZBO.ZBO_DISP   BETWEEN  '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND ZBO.ZBO_LETRA  BETWEEN  '"+mv_par05+"' AND '"+mv_par06+"'"
	cQuery += " AND ZBO.ZBO_DATINI BETWEEN  '"+DtoS(mv_par07)+"' AND '"+DtoS(mv_par08)+"'"
	cQuery += " AND ZBO.ZBO_DATFIM BETWEEN  '"+DtoS(mv_par09)+"' AND '"+DtoS(mv_par10)+"'"
	cQuery += " AND ZBO.ZBO_DTAPRV BETWEEN  '"+DtoS(mv_par11)+"' AND '"+DtoS(mv_par12)+"'"
	cQuery += " AND ZBO.ZBO_CC     BETWEEN  '"+mv_par13+"' AND '"+mv_par14+"'"
	cQuery += " AND ZBO.ZBO_CTRAB  BETWEEN  '"+mv_par15+"' AND '"+mv_par16+"'"
	cQuery += " AND ZBO.ZBO_HORINI BETWEEN  '"+mv_par17+"' AND '"+mv_par18+"'"
	cQuery += " AND ZBO.ZBO_HORFIM BETWEEN  '"+mv_par19+"' AND '"+mv_par20+"'"
	cQuery += " AND ZBO.ZBO_HRAPRV BETWEEN  '"+mv_par21+"' AND '"+mv_par22+"'"
	cQuery += " AND ZBO.ZBO_CODBEM BETWEEN  '"+mv_par23+"' AND '"+mv_par24+"'"
	cQuery += " AND ZBO.ZBO_RESP   BETWEEN  '"+mv_par25+"' AND '"+mv_par26+"'"
	cQuery += " AND ZBO.ZBO_FRESP  BETWEEN  '"+mv_par27+"' AND '"+mv_par28+"'"
	cQuery += " AND ZBO.ZBO_APRV   BETWEEN  '"+mv_par29+"' AND '"+mv_par30+"'"
	
	If mv_par31!=3 //ambos
		cQuery += " AND ZBO.ZBO_STSBEM '"+STR(mv_par31)+"'"
	EndIf
	
	If mv_par32!=3 //ambos
	    cQuery += " AND ZBO.ZBO_APRVD = '"+Iif(mv_par32==1,"S","N")+"'"
	EndIf
	
	If mv_par33!=3 //ambos
		cQuery += " AND ZBO.ZBO_TERMIN = '"+Iif(mv_par33==1,"S","N")+"'"
	EndIf
	
	If mv_par34!=4 //ambos
		cQuery += " AND ZBO.ZBO_TIPO = '"+STR(mv_par34)+"'"
	EndIf
	
	cQuery += " AND ZBO.D_E_L_E_T_ = '' AND ZBO.ZBO_FILIAL = '"+xFilial("ZBO")+"'"
	
    MemoWrit('C:\TEMP\NHMNT046.SQL',cQuery)	
	TCQUERY cQuery NEW ALIAS "TRA1"
	
	TcSetField("TRA1","ZBO_DATINI","D")  // Muda a data de string para date
	TcSetField("TRA1","ZBO_DATFIM","D")  // Muda a data de string para date
	TcSetField("TRA1","ZBO_DTAPRV","D")  // Muda a data de string para date
	
	TRA1->(DBGOTOP())

Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CALCULA A DURACAO DA OS ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function fDuracao(dDtIni,dDtFim,cHrIni,cHrFim)
Local nDuracao := 0
Local cDuracao := ""
Local nTamanho := 0

	If Empty(dDtFim)
		nDuracao := (Date() - dDtIni) * 24
	Else
		nDuracao := (dDtFim - dDtIni) * 24
	EndIf
	
	If Empty(cHrFim)
		nDuracao += (HoraToInt(Substr(Time(),1,5)) - HoraToInt(Substr(cHrIni,1,5)))
	Else
		nDuracao += (HoraToInt(Substr(cHrFim,1,5)) - HoraToInt(Substr(cHrIni,1,5)))
	EndIf

	nTamanho := Len(AllTrim(Str(Int(nDuracao))))
	nTamanho := Iif(nTamanho==1,2,nTamanho)
	cDuracao := IntToHora(nDuracao,nTamanho)
	cDuracao := AllTrim(cDuracao)

//RETORNA EM CARACTERES FORMATO HORA 99:99
Return cDuracao