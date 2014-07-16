/*
+----------------------------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                                            !
+----------------------------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                                          !
+------------------+---------------------------------------------------------------------------+
!Modulo            ! END - Endividamento                                                       !
+------------------+---------------------------------------------------------------------------+
!Nome              ! RFIN001.PRW                                                               !
+------------------+---------------------------------------------------------------------------+
!Descricao         ! Relatório de Endividamento                                                +
+------------------+---------------------------------------------------------------------------+
!Autor             ! Edenilson Santos                                                          !
+------------------+---------------------------------------------------------------------------+
!Data de Criacao   ! 07/04/2014                                                                !
+------------------+---------------------------------------------------------------------------+
!   ATUALIZACOES                                                                               !
+-----------------------------------------------------+-------------+-------------+------------+
!   Descricao detalhada da atualizacao                !Nome do      ! Analista    !Data da     !
!                                                     !Solicitante  ! Responsavel !Atualização !
+-----------------------------------------------------+-------------+-------------+------------+
!                                                     ! Alexandrevm ! Edenilson   ! 07/04/2014 !
+-----------------------------------------------------+-------------+-------------+------------+
*/
#include "protheus.ch"
#include "topconn.ch"

User Function RFIN001()

Local oReport
Private cCaixas :=""
Private cAgenc :=""
Private cCont  :=""
Private cUser  := RetCodUsr()
Private cPerg  :="RFIN001"
CRIASX1(cPerg)
pergunte(cperg,.F.)

oReport:= ReportDef()
oReport:PrintDialog()

return

Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2


oReport := TReport():New("RFIN001","Relatorio de Endividamento"  ,cperg,{|oReport| PrintReport(oReport)},"Relatorio de Endividamento")
oReport:SetTotalInLine(.F.)

oSection1 := TRSection():New(oReport,"Endividamento",{"ZF8","SE2"})


TRCell():New(oSection1,"ZF8_NUM","ZF8", , , )
TRCell():New(oSection1,"ZF8_CONTRA","ZF8", , , )
TRCell():New(oSection1,"ZF8_JUBNDS","ZF8", , , )
TRCell():New(oSection1,"ZF8_JUBANC","ZF8", , , )
TRCell():New(oSection1,"ZF8_JURTOT","ZF8", , , )
TRCell():New(oSection1,"A2_NOME","SA1", , , )
TRCell():New(oSection1,"ZF8_CONTAC","SA1", , , )
TRCell():New(oSection1,"ZF8_VLRFIN","ZF8", , , )
TRCell():New(oSection1,"ZF8_CODBAN","ZF8", , , )
TRCell():New(oSection1,"BANCO","ZF8","Banco" , , )
TRCell():New(oSection1,"ZF8_MODAL","ZF8", , , )
TRCell():New(oSection1,"ZF8_PRAZO","ZF8", , , )
TRCell():New(oSection1,"ZF8_JURTOT","ZF8", , , )


oBreak := TRBreak():New(oSection1,oSection1:Cell("ZF8_NUM"),"Contrato")


oSection2 := TRSection():New(oSection1,"Parcelas",{"SE2"})

//TRCell():New(oSection1,"C1_DESCRI","SC1",/*Titulo*/,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"E2_PARCELA"  ,"SE2",'Parcela', ,10 )
TRCell():New(oSection2,"E2_NUM"  ,"SE2",'Titulo', ,30 )
TRCell():New(oSection2,"DATAS"   ,"ZF8",'Data' , ,30 )
TRCell():New(oSection2,"E2_VALOR","ZF8", 'Valor', ,30 )
TRCell():New(oSection2,"VLRCPRA","ZF8" ,"Saldo Curto Prazo" ,"@E 999,999,999.99" ,30 )
TRCell():New(oSection2,"VLRLPRA","ZF8" ,"Saldo Longo Prazo" ,"@E 999,999,999.99" ,30 )
TRCell():New(oSection2,"VLRPAGO","ZF8" ,"Vlr.Pago" , "@E 999,999,999.99",30 )
TRCell():New(oSection2,"VLRPEND","ZF8" ,"Em Aberto" ,"@E 999,999,999.99" , 30)
TRCell():New(oSection2,"OBS"  ,"SE2",'Observacao', ,30 )

oSection3 := TRSection():New(oSection2,"Juros",{"SE2"})

TRCell():New(oSection3,"Liqui"  ,"SE2",'Liquidado', ,10 )
TRCell():New(oSection3,"Vencer"  ,"SE2",'A Vencer', ,30 )
TRCell():New(oSection3,"Total"   ,"ZF8",'Total' , ,30 )



oSection4 := TRSection():New(oSection3,"Parcelas",{"SE2"})

TRCell():New(oSection4,"Liquip"  ,"SE2",'Liquidado', ,10 )
TRCell():New(oSection4,"Vencerp"  ,"SE2",'A Vencer', ,30 )
TRCell():New(oSection4,"Totalp"   ,"ZF8",'Total' , ,30 )


//TRCell():New(oSection1,"D2_DOC","SD2",,,15,,,,,,,1,.T.,,,)


Return oReport

//=========================================== IMPRESSÃO DO RELATÓRIO ============================================//

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)
Local oSection3 := oReport:Section(1):Section(1):Section(1)
Local oSection4 := oReport:Section(1):Section(1):Section(1):Section(1)
cAlias := GetNextAlias()

cPart := "% ZF8_CONTRA ='77889/5'       "
cPart +=" 		and ZF8.D_E_L_E_T_<>'*' "
cPart +=" 		and SA2.D_E_L_E_T_<>'*'"
cPart +=" %"

//BeginSql alias cAlias
cQry2:=""

cQry:=" SELECT * FROM ( "
if mv_par05==1
	cQry2+=" 	SELECT ZF8_NUM "
	cQry2+="			,ZF8_CONTRA "
	cQry2+="			,ZF8_VLRFIN "
	cQry2+="			,ZF8_JUBNDS "
	cQry2+="			,ZF8_JUBANC "
	cQry2+="			,ZF8_JURTOT "
	cQry2+="			,ZF8_CODBAN "
	cQry2+="			,A2_COD "
	cQry2+="			,A2_LOJA "
	cQry2+="			,A2_NOME "
	cQry2+="			,ZF8_CONTAC "
	cQry2+="			,E2_PARCELA "
	cQry2+="			,E2_NUM "
	cQry2+="			,E2_VENCREA AS DATAS "
	cQry2+="			,E2_VALOR "
	cQry2+="			,E2_SALDO "
	cQry2+="			, ZF8_MODAL "
	cQry2+="			, ZF8_PRAZO "
	cQry2+="		FROM "+RetSqlName('ZF8')+" ZF8 "
	cQry2+="		INNER JOIN "+RetSqlName('SA2')+" SA2 "
	cQry2+="		ON A2_COD=ZF8_FORN "
	cQry2+="		AND A2_LOJA= ZF8_LOJA "
	cQry2+="		INNER JOIN "+RetSqlName('SE2')+" SE2 "
	cQry2+="			ON E2_HIST=ZF8_CONTRA "
	cQry2+="			and SE2.D_E_L_E_T_<>'*' "
	cQry2+="		WHERE  "
	cQry2+="		ZF8_CONTRA >='"+MV_PAR01+"' "
	cQry2+="		AND ZF8_CONTRA <='"+MV_PAR02+"' "
	cQry2+="		AND E2_VENCREA >='"+DTOS(MV_PAR03)+"' "
	cQry2+="		AND E2_VENCREA <='"+DTOS(MV_PAR04)+"' "
	if Mv_Par06==1
		cQry2+="		AND E2_BAIXA=''"
	EndIf
	if Mv_Par06==2
		cQry2+="		AND E2_BAIXA<>''"
	EndIf
	cQry2+="		and ZF8.D_E_L_E_T_<>'*' "
	cQry2+="		and SA2.D_E_L_E_T_<>'*' "
EndIf
If !Empty(cQry2)
	cQry2+="	UNION  "
EndIf
If mv_par08==1
	cQry2+="		SELECT ZF8_NUM "
	cQry2+="			,ZF8_CONTRA "
	cQry2+="			,ZF8_VLRFIN "
	cQry2+="			,ZF8_JUBNDS "
	cQry2+="			,ZF8_JUBANC "
	cQry2+="			,ZF8_JURTOT "
	cQry2+="			,ZF8_CODBAN "
	cQry2+="			,A2_COD "
	cQry2+="			,A2_LOJA "
	cQry2+="			,A2_NOME "
	cQry2+="			,ZF8_CONTAC "
	cQry2+="			,'' PARCELA"
	cQry2+="			,'PAGAMENTO DE JUROS' "
	cQry2+="			,ZG0_DATA "
	cQry2+="			,0 "
	cQry2+="			,0 AS E2_SALDO "
	cQry2+="			, ZF8_MODAL "
	cQry2+="			,ZF8_PRAZO "
	cQry2+="		FROM "+RetSqlName('ZF8')+" ZF8 "
	cQry2+="		INNER JOIN "+RetSqlName('SA2')+" SA2 "
	cQry2+="		ON A2_COD=ZF8_FORN "
	cQry2+="		AND A2_LOJA= ZF8_LOJA "
	cQry2+="		INNER JOIN "+RetSqlName('ZG0')+" ZG0 "
	cQry2+="			ON ZG0_CONTRA = ZF8_NUM "
	cQry2+="			and ZG0.D_E_L_E_T_<>'*' "
	cQry2+="		WHERE  "
	cQry2+="		ZF8_CONTRA >='"+MV_PAR01+"' "
	cQry2+="		AND ZF8_CONTRA <='"+MV_PAR02+"' "
	cQry2+="		AND ZG0_DATA >='"+DTOS(MV_PAR03)+"' "
	cQry2+="		AND ZG0_DATA <='"+DTOS(MV_PAR04)+"' "
	cQry2+="		and ZF8.D_E_L_E_T_<>'*'  "
	cQry2+="		and SA2.D_E_L_E_T_<>'*' "
EndIF
If !Empty(cQry2)
	cQry2+="	UNION  "
EndIf
If mv_par07==1
	cQry2+="		SELECT ZF8_NUM "
	cQry2+="			,ZF8_CONTRA "
	cQry2+="			,ZF8_VLRFIN "
	cQry2+="			,ZF8_JUBNDS "
	cQry2+="			,ZF8_JUBANC "
	cQry2+="			,ZF8_JURTOT "
	cQry2+="			,ZF8_CODBAN "
	cQry2+="			,A2_COD "
	cQry2+="			,A2_LOJA "
	cQry2+="			,A2_NOME "
	cQry2+="			,ZF8_CONTAC "
	cQry2+="			,'' E2_PARCELA "
	cQry2+="			,'LIBERACAO' "
	cQry2+="			,ZF9_DATA "
	cQry2+="			, ZF9_VALOR "
	cQry2+="			,0 AS E2_SALDO "
	cQry2+="			, ZF8_MODAL "
	cQry2+="			, ZF8_PRAZO "
	cQry2+="		FROM "+RetSqlName('ZF8')+" ZF8 "
	cQry2+="		INNER JOIN "+RetSqlName('SA2')+" SA2 "
	cQry2+="		ON A2_COD=ZF8_FORN "
	cQry2+="		AND A2_LOJA= ZF8_LOJA "
	cQry2+="	  	INNER JOIN "+RetSqlName('ZF9')+" ZF9 "
	cQry2+="			ON ZF9_NUM = ZF8_NUM "
	cQry2+="			and ZF9.D_E_L_E_T_<>'*' "
	cQry2+="		WHERE "
	cQry2+="		ZF8_CONTRA >='"+MV_PAR01+"' "
	cQry2+="		AND ZF8_CONTRA <='"+MV_PAR02+"' "
	cQry2+="		AND ZF9_DATA >='"+DTOS(MV_PAR03)+"' "
	cQry2+="		AND ZF9_DATA <='"+DTOS(MV_PAR04)+"' "
	cQry2+="		and ZF8.D_E_L_E_T_<>'*' "
	cQry2+="		and SA2.D_E_L_E_T_<>'*'"
EndIF

cQry+=cQry2
cQry+=") FINAME 	Order By ZF8_NUM,DATAS "

If Select('TRBX')<>0
	TRBX->(dbCloseArea())
EndIf

TcQuery cQry New Alias "TRBX"

nCount:=0
While !TRBX->(EOF())
	
	nCount++
	
	
	TRBX->(dbSkip())
EndDO
//EndSql

//oSection1:EndQuery()

oReport:SetMeter(nCount)
TRBX->(DBGoTop())

cNum:=''
oSection1:Init()
nInc:=0
lPass:=.f.
	nJurP:=0
	nJurA:=0	
	nJur :=0	
	PAGPAR:=0
	ABEPAR:=0
	TOTPAR:=0

While !TRBX->(EOF())
	if cNum <> TRBX->ZF8_NUM
		
		oSection1:Cell("ZF8_NUM"):SetValue(TRBX->ZF8_NUM)
		oSection1:Cell("ZF8_CONTRA"):SetValue(TRBX->ZF8_CONTRA)
		oSection1:Cell("ZF8_JUBNDS"):SetValue(TRBX->ZF8_JUBNDS)  `
		oSection1:Cell("ZF8_JUBANC"):SetValue(TRBX->ZF8_JUBANC)
		oSection1:Cell("ZF8_JURTOT"):SetValue(TRBX->ZF8_JURTOT)
		oSection1:Cell("A2_NOME"):SetValue(TRBX->A2_NOME)
		oSection1:Cell("ZF8_CONTAC"):SetValue(TRBX->ZF8_CONTAC)
		oSection1:Cell("ZF8_VLRFIN"):SetValue(TRBX->ZF8_VLRFIN)
		oSection1:Cell("ZF8_CODBAN"):SetValue(TRBX->ZF8_CODBAN)
		oSection1:Cell("BANCO"):SetValue(POSICIONE('SA6',1,xFilial('ZF8')+TRBX->ZF8_CODBAN,"A6_NOME"))
		oSection1:Cell("ZF8_MODAL"):SetValue(TRBX->ZF8_MODAL)
		oSection1:Cell("ZF8_PRAZO"):SetValue(TRBX->ZF8_PRAZO)
		oSection1:Cell("ZF8_JURTOT"):SetValue(TRBX->ZF8_JURTOT)
		oSection1:PrintLine()
		
		
		cNum:=TRBX->ZF8_NUM
	EndIF
	npago:=0
	cCpraz := CURTOPRAZO(TRBX->ZF8_CONTRA)
	nLpraz := LONPRAZO(TRBX->ZF8_CONTRA)
	npagar := pagar(TRBX->ZF8_CONTRA)
	oSection2:Init()
	LPAGO:=.F.
	/*
	nJurP:=0
	nJurA:=0	
	nJur :=0	
	PAGPAR:=0
	ABEPAR:=0
	TOTPAR:=0
	*/
	While !TRBX->(EOF()) .and. cNum == TRBX->ZF8_NUM
		nInc++
		IF  substr(TRBX->E2_NUM,3,1)=='J'
			
			nJur+=(TRBX->E2_VALOR*(-1))
			If TRBX->E2_SALDO ==0
				nJurP+=(TRBX->E2_VALOR*(-1))
			Else
				nJurA+=(TRBX->E2_VALOR*(-1))
			EndIF
			
		EndIF
		
		IF  substr(TRBX->E2_NUM,3,1)=='P'
			
			TOTPAR+=TRBX->E2_VALOR
			If TRBX->E2_SALDO ==0
				PAGPAR+=TRBX->E2_VALOR
			Else
				ABEPAR+=TRBX->E2_VALOR
			EndIF
			
		EndIF
		
		
		if  TRBX->E2_NUM <> 'LIBERACAO' .and. TRBX->E2_NUM<>'PAGAMENTO DE JUROS'
			if TRBX->E2_SALDO ==0
				LPAGO:=.T.
				nPago  += npago
				npagar -=TRBX->E2_VALOR
			EndIF
		EndIF
		oReport:IncMeter ( nInc)
		oSection2:Cell("E2_PARCELA"):SetValue(TRBX->E2_PARCELA)
		oSection2:Cell("E2_NUM"):SetValue(TRBX->E2_NUM)
		oSection2:Cell("DATAS"):SetValue(DTOC(STOD(TRBX->DATAS)))
		oSection2:Cell("E2_VALOR"):SetValue(TRBX->E2_VALOR)
		oSection2:Cell("VLRCPRA"):SetValue(cCpraz)
		oSection2:Cell("VLRLPRA"):SetValue(nLpraz)
		oSection2:Cell("VLRPAGO"):SetValue(npago)
		oSection2:Cell("VLRPEND"):SetValue(npagar)
		oSection2:Cell("OBS"):SetValue(IF(LPAGO,'Liquidado','A Vencer'))
		LPAGO:=.F.
		oSection2:PrintLine()
		TRBX->(dbSkip())
		lPass:=.t.
	EndDO
	if !Lpass
		(cAlias)->(dbSkip())
		lPass:=.f.
	Else
		
		Loop
	EndIF
	
EndDO
oSection3:Init()
oSection3:Cell("Liqui"):SetValue(nJurP)
oSection3:Cell("Vencer"):SetValue(nJurA)
oSection3:Cell("Total"):SetValue(nJur)
oSection3:PrintLine()


oSection4:Init()
oSection4:Cell("Liquip"):SetValue(PAGPAR)
oSection4:Cell("Vencerp"):SetValue(ABEPAR)
oSection4:Cell("Totalp"):SetValue(TOTPAR)
oSection4:PrintLine()
//oSection1:Print()
oReport:EndPage(.f.)
Return


Static Function CURTOPRAZO(nCont)
ncPrazo:=0
cQry:=" SELECT SUM(E2_VALOR) SALDO "
cQry+=" from "+RETSQLNAME('SE2')
cQry+=" WHERE  D_E_L_E_T_<>'*'"
cQry+=" AND E2_HIST ='"+nCont+"' "
cQry+=" AND E2_VENCTO<='"+DTOS(DDATABASE+360)+"'"
If Select('TRCP')<>0
	TRCP->(DBCloseArea())
EndIF
TcQuery cQry New Alias "TRCP"

ncPrazo:=TRCP->SALDO

return ncPrazo

Static Function LONPRAZO(nCont)
ncPrazo:=0
cQry:=" SELECT SUM(E2_VALOR) SALDO "
cQry+=" from "+RETSQLNAME('SE2')
cQry+=" WHERE  D_E_L_E_T_<>'*'"
cQry+=" AND E2_HIST ='"+nCont+"' "
cQry+=" AND E2_VENCTO>='"+DTOS(DDATABASE+360)+"'"
If Select('TRCP')<>0
	TRCP->(DBCloseArea())
EndIF
TcQuery cQry New Alias "TRCP"

ncPrazo:=TRCP->SALDO

return ncPrazo



Static Function pagos(nCont)
ncPrazo:=0
cQry:=" SELECT SUM(E2_VALOR) SALDO "
cQry+=" from "+RETSQLNAME('SE2')
cQry+=" WHERE D_E_L_E_T_<>'*'"
cQry+=" AND E2_HIST ='"+nCont+"' "
cQry+=" AND E2_SALDO ='0'"
If Select('TRCP')<>0
	TRCP->(DBCloseArea())
EndIF
TcQuery cQry New Alias "TRCP"

ncPrazo:=TRCP->SALDO

return ncPrazo


Static Function pagar(nCont)
ncPrazo:=0
cQry:=" SELECT SUM(E2_VALOR) SALDO "
cQry+=" from "+RETSQLNAME('SE2')
cQry+=" WHERE  D_E_L_E_T_<>'*'"
cQry+=" AND E2_HIST ='"+nCont+"' "
//cQry+=" AND E2_SALDO > '0'"
If Select('TRCP')<>0
	TRCP->(DBCloseArea())
EndIF
TcQuery cQry New Alias "TRCP"

ncPrazo:=TRCP->SALDO

return ncPrazo


Static Function criasx1(cperg)

PutSX1(cPerg, "01", "Contrato de"           , "", "", "mv_ch1", "C", 20						,  0, 0, "G", "", "ZF8", "", "", "mv_par01", "","","","","","","","","","","","","","","","")
PutSX1(cPerg, "02", "Contrato Ate"          , "", "", "mv_ch2", "C", 20						,  0, 0, "G", "", "ZF8", "", "", "mv_par02", "","","","","","","","","","","","","","","","")
PutSX1(cPerg, "03", "Vencimento De"         , "", "", "mv_ch3", "D", 08						,  0, 0, "G", "", "" 	, "", "", "mv_par03", "","","","","","","","","","","","","","","","")
PutSX1(cPerg, "04", "Vencimento Ate"        , "", "", "mv_ch4", "D", 08						,  0, 0, "G", "", "" 	, "", "", "mv_par04", "","","","","","","","","","","","","","","","")
PutSX1(cPerg, "05", "Parcelas"              , "", "", "mv_ch5", "N", 01						, 0	, 1 , "C", "", "" 	, "", "", "mv_par05", "Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","")
PutSX1(cPerg, "06", "Em Aberto"             , "", "", "mv_ch6", "N", 01						, 0	, 1 , "C", "", "" 	, "", "", "mv_par06", "Sim","Sim","Sim","","Nao","Nao","Nao","Ambos","Ambos","Ambos","","","","","","")
PutSX1(cPerg, "07", "Liberacao"             , "", "", "mv_ch7", "N", 01						, 0	, 1 , "C", "", "" 	, "", "", "mv_par07", "Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","")
PutSX1(cPerg, "08", "Juros"              	, "", "", "mv_ch8", "N", 01						, 0	, 1 , "C", "", "" 	, "", "", "mv_par08", "Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","")


Return