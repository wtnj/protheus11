
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHMNT039  ºAutor  ³ João Felipe da Rosaº Data ³  06/10/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório MTTR, MTBF (DISPOSITIVOS)                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MANUTENCAO DE ATIVOS                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

User Function NHMNT039()

	AjustaSx1()

	oRelato          := Relatorio():New()
	
	oRelato:cString  := "ZBN"
    oRelato:cPerg    := "MNT039"
	oRelato:cNomePrg := "NHMNT039"
	oRelato:wnrel    := oRelato:cNomePrg
	oRelato:cTamanho := "M"

	//descricao
	oRelato:cDesc1   := "Relatório de MTTR, MTBF dos Dispositivos WHB"
	oRelato:cDesc2   := ""
	oRelato:cDesc3   := ""

	//titulo
	oRelato:cTitulo := "RELATÓRIO DE %INFO% DOS DISPOSITIVOS WHB"

	//cabecalho
	oRelato:cCabec1  := " PERÍODO DE %DINI% ATÉ %DFIM%"
    oRelato:cCabec2  := " DISPOSITIVO    LETRA    DESCRICAO                                                                 %INFO%"
		    
	oRelato:Run({||Imprime()})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ PARAMETROS ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// MV_PAR01 -> DE DISPOSITIVO
	// MV_PAR02 -> ATE DISPOSITIVO
	// MV_PAR03 -> DE LETRA
	// MV_PAR04 -> ATE LETRA
Return 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO DE IMPRESSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Imprime()
Local cQuery

	oRelato:cTitulo := StrTran(oRelato:cTitulo,"%INFO%",Iif(mv_par11==1,"MTBF","MTTR"))
	oRelato:cCabec1 := StrTran(oRelato:cCabec1,"%DINI%",DtoC(mv_par05))
	oRelato:cCabec1 := StrTran(oRelato:cCabec1,"%DFIM%",DtoC(mv_par06))
	oRelato:cCabec2 := StrTran(oRelato:cCabec2,"%INFO%",Iif(mv_par11==1,"MTBF","MTTR"))
	
	cQuery := " SELECT ZBN.ZBN_COD, ZBN.ZBN_LETRA, ZBN.ZBN_DESC, "
	cQuery += " ZBO.ZBO_ORDEM, ZBO.ZBO_DATINI, ZBO.ZBO_DATFIM, ZBO.ZBO_HORINI, ZBO.ZBO_HORFIM"

	cQuery += " FROM "+RetSqlName("ZBN")+" ZBN (nolock) 

	cQuery += " LEFT JOIN " + RetSqlName("ZBO") + " ZBO (NOLOCK) ON "
	cQuery += "		ZBO.ZBO_DISP  = ZBN.ZBN_COD"
	cQuery += " AND ZBO.ZBO_LETRA = ZBN.ZBN_LETRA"
	cQuery += " AND ZBO.ZBO_DATINI > '"+DtoS(mv_par05)+"'"
	cQuery += " AND ZBO.ZBO_DATFIM < '"+DtoS(mv_par06)+"'"
	cQuery += " AND ZBO.ZBO_CC     BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	cQuery += " AND ZBO.ZBO_CTRAB  BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
	cQuery += " AND ZBO.D_E_L_E_T_ = '' AND ZBO.ZBO_FILIAL = '"+xFilial("ZBO")+"'"

	cQuery += " WHERE ZBN_COD+ZBN_LETRA BETWEEN '"+mv_par01+mv_par02+"' AND '"+mv_par03+mv_par04+"'"
	cQuery += " AND ZBN.D_E_L_E_T_ = '' AND ZBN.ZBN_FILIAL = '"+xFilial("ZBN")+"'"

	cQuery += " ORDER BY ZBN.ZBN_COD, ZBN.ZBN_LETRA"

	TCQUERY cQuery NEW ALIAS "TRA1"
	
	TCSETFIELD("TRA1","ZBO_DATFIM","D") //muda de string para date
	TCSETFIELD("TRA1","ZBO_DATINI","D") //muda de string para date
	
	oRelato:Cabec()
		
	nHrTot := (mv_par06-mv_par05) * 24 //horas totais de trabalho do dispositivo
	
	While TRA1->(!EOF())
	
		If Prow() > 60
			oRelato:Cabec()
		EndIf
	
		nHrPar  := 0
		nQtdPar := 0
		
		aDisp := {TRA1->ZBN_COD,;   //dispositivo
		          TRA1->ZBN_LETRA,;  //letra
		          TRA1->ZBN_DESC,;   //descricao
		          nHrPar,;          //hora parada
		          nQtdPar}          //quantidade parada
		
		nHIni := ""
		nHFim := ""
		nDIni := CtoD("  /  /  ")
		nDFim := CtoD("  /  /  ")
		
		While TRA1->(!EOF()) .AND. TRA1->ZBN_COD==aDisp[1] .AND. TRA1->ZBN_LETRA==aDisp[2]

			If Empty(TRA1->ZBO_ORDEM)
				TRA1->(dbSkip())
				Loop
			EndIf
			
			nHIni := TRA1->ZBO_HORINI
			nHFim := Iif(Empty(TRA1->ZBO_HORFIM),Iif(mv_par06==Date(),Time(),"23:59:59"),TRA1->ZBO_HORFIM)
			nDIni := TRA1->ZBO_DATINI
			nDFim := Iif(Empty(TRA1->ZBO_DATFIM),mv_par06,TRA1->ZBO_DATFIM)

			//Calcula em horas o tempo do dispositivo parado
			aDisp[4] += ((nDFim - nDIni) * 24) - (HoraToInt(nHFim) - HoraToInt(nHIni))

			aDisp[5]++ //incrementa a quantidade de paradas
			
			TRA1->(DbSkip())
		EndDo
		
		@ Prow()+1 ,  1 psay aDisp[1]
		@ Prow()   , 18 psay aDisp[2]
		@ Prow()   , 25 psay aDisp[3]
		                                  
		If mv_par11==1 // MTBF
			
			//fórmula: hora total - hora parada / n. paradas
			nInfo := (nHrTot - aDisp[4]) / aDisp[5]
			
			If nInfo==0
				nInfo := nHrTot
			EndIf

		ElseIf mv_par11==2 // MTTR
		    
			//fórmula: hora total / n. paradas
			nInfo := (nHrTot / aDisp[5])
		
		EndIf
		
		nTam := Len(AllTrim(str(Int(nInfo))))
		
		@ Prow()   , 92 psay PadL(IntToHora(nInfo,nTam),13)
    EndDo
    
    TRA1->(dbCloseArea())

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PARA CRIAR AS PERGUNTAS NO SX1 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function AjustaSX1()
SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")
_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "MNT039    "
aRegs   := {}

aadd(aRegs,{cPerg,"01","De Dispositivo ?" ,"De Dispositivo ?"   ,"De Dispositivo ?  ","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","ZBN",""})
aadd(aRegs,{cPerg,"02","De Letra ?"       ,"De Letra ?"         ,"De Letra ?"        ,"mv_ch2","C",01,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","Ate Dispositivo ?","Ate Dispositivo ?"  ,"Ate Dispositivo ?" ,"mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","ZBN",""})
aadd(aRegs,{cPerg,"04","Ate Letra ?"      ,"Ate Letra ?"        ,"Ate Letra ?"       ,"mv_ch4","C",01,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"05","De Data ?"        ,"De Data ?"          ,"De Data ?"         ,"mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"06","Ate Data ?"       ,"Ate Data ?"         ,"Ate Data ?"        ,"mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"07","De C.Custo ?"     ,"De C.Custo ?"       ,"De C.Custo ?"      ,"mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aadd(aRegs,{cPerg,"08","Ate C.Custo ?"    ,"Ate C.Custo ?"      ,"Ate C.Custo ?"     ,"mv_ch8","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aadd(aRegs,{cPerg,"09","De C.Trabalho ?"  ,"De C.Trabalho ?"    ,"De C.Trabalho ?"   ,"mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SHB",""})
aadd(aRegs,{cPerg,"10","Ate C.Trabalho ?" ,"Ate C.Trabalho ?"   ,"Ate C.Trabalho ?"  ,"mv_cha","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SHB",""})
aadd(aRegs,{cPerg,"11","Informação ?"     ,"Informação ?"       ,"Informação ?"      ,"mv_chb","N",01,0,0,"C","","mv_par11","MTBF","MTBF","MTBF","","","MTTR","MTTR","MTTR","","","","","","","","","","","","","","","","","SHB",""})

cUltPerg := aRegs[Len(aRegs)][2]

If SX1->(!DbSeek(cPerg + cUltPerg))
   	
   	SX1->(DbSeek(cPerg))
   	While SX1->(!EOF()) .AND. SX1->X1_GRUPO == cPerg
   		RecLock('SX1')
      		SX1->(DbDelete())
      	MsUnLock('SX1')
      	
      	SX1->(DbSkip())
   	End
   	
   	For i := 1 To Len(aRegs)
    	RecLock("SX1", .T.)
	 		For j := 1 to Len(aRegs[i])
	     		FieldPut(j, aRegs[i, j])
	 		Next
     	MsUnlock()
     	DbCommit()
   	Next

EndIf                   

dbSelectArea(_sAlias)

Return                     
