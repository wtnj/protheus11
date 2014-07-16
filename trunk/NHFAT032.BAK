/*
+----------------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                                !
+----------------------------------------------------------------------------------+
!                             DADOS DO PROGRAMA                                    !
+------------------+---------------------------------------------------------------+
!Modulo            ! FIN - Financeiro                                              !
+------------------+---------------------------------------------------------------+
!Nome              ! NHFAT032.PRW                                                  !
+------------------+---------------------------------------------------------------+
!Descricao         ! Impressão da Notal de Débito ao Fornecedor                    +
+------------------+---------------------------------------------------------------+
!Autor             ! João Felipe da Rosa                                           !
+------------------+---------------------------------------------------------------+
!Data de Criacao   ! 17/03/2010                                                    !
+------------------+---------------------------------------------------------------+
!ATUALIZACOES                                                                      !
+-------------------------------------------+---------------+-----------+----------+
!Descricao detalhada da atualizacao         !Nome do        ! Analista  !Data da   !
!                                           !Solicitante    ! Respons.  !Atualiz.  !
+-------------------------------------------+---------------+-----------+----------+
!Melhorias no processo de impressão/Filtros !Gustavocr      !Edenilsonas!03/02/2014!
+-------------------------------------------+---------------+-----------+----------+
*/

#Include "Protheus.Ch"
#include "rwmake.ch"
#include "topconn.ch"

User Function NHFAT032(nParam)
Local _nLin
Local _nCol
Private oPrint
Private cStartPath:= GetSrvProfString("Startpath","")

If Pcount() > 0

	If Select("ZDMTMP") > 0
		dbSelectArea("ZDMTMP")
		dbCloseArea()
	Endif

	BeginSql Alias "ZDMTMP"
		SELECT *
		FROM
		%Table:ZDM% ZDM (NOLOCK)
		WHERE
		ZDM.ZDM_NUM = %Exp:nParam% AND
		ZDM.%NotDel%
		order by
		ZDM.R_E_C_N_O_
	EndSql

else


	AjustaSx1("FAT032")
	/*
	+----------------------------------------------------------+
	! Variaveis utilizadas para parametros                     !
	! mv_par01            // da nota fiscal debito             !
	! mv_par02            // ate a nota fiscal de debito       !
	! mv_par03            // série                             !
	! mv_par04            // ate a série                       !
	! mv_par05            // número                            !
	! mv_par06            // até o número                      !
	! mv_par07            // da data de emissão                !
	! mv_par08            // ate a data de emissão             !
	! mv_par09            // do fornecedor                     !
	! mv_par10            // ate o fornecedor                  !
	! mv_par11            // da loja                           !
	! mv_par12            // ate a loja                        !
	+----------------------------------------------------------+
	*/
	
	If !Pergunte('FAT032',.T.)
		Return(nil)
	Endif
	
	//cStartPath += Iif(Right(cStartPath,1)=="\","","\")
	
	cSql1:= ''
	
	If !Empty(mv_par01) .And. !Empty(mv_par02)
		cSql1 += "ZDM.ZDM_DOC BETWEEN " + mv_par01 + " AND " + mv_par02 + " AND "
	Endif

	If !Empty(mv_par03) .And. !Empty(mv_par04)
		cSql1 += "ZDM.ZDM_SERIE BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND "
	Endif

	If !Empty(mv_par05) .And. !Empty(mv_par06)
		cSql1 += "ZDM.ZDM_NUM BETWEEN " + mv_par05 + " AND " + mv_par06 + " AND "
	Endif
	
	If !Empty(mv_par07) .And. !Empty(mv_par08)
		cSql1 += "ZDM.ZDM_DTDIGI BETWEEN " + Dtos(mv_par07) + " AND " + Dtos(mv_par08) + " AND "
	Endif
	
	If !Empty(mv_par09) .And. !Empty(mv_par10)
		cSql1+= "ZDM.ZDM_FORNEC BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "' AND "
	Endif
	
	If !Empty(mv_par11) .And. !Empty(mv_par12)
		cSql1 += "ZDM.ZDM_LOJFOR BETWEEN '" + mv_par11 + "' AND '" + mv_par12 + "' AND "
	Endif

	If !Empty(mv_par13)
		If mv_par13 == 1
			cSql1 += "ZDM.ZDM_STATUS = 'E' AND "
		Elseif mv_par13 == 2
			cSql1 += "ZDM.ZDM_STATUS = 'N' AND "
		Elseif mv_par13 == 3
			cSql1 += "ZDM.ZDM_STATUS = 'A' AND "
		Elseif mv_par13 == 4
			//cSql1 += "ZDM.ZDM_STATUS = 'A' AND "
		Endif
		
	Endif
	
	cSql1 := "%"+cSql1+"%"
	
	If Select("ZDMTMP") > 0
		dbSelectArea("ZDMTMP")
		dbCloseArea()
	Endif
	
	BeginSql Alias "ZDMTMP"
		SELECT *
		FROM
		%Table:ZDM% ZDM (NOLOCK)
		WHERE
		%exp:cSql1%
		ZDM.%NotDel%
		order by
		ZDM.R_E_C_N_O_
	EndSql
Endif

//CRIA OS OBJETOS DE IMPRESSÃO
oPrint := TMSPrinter():New("NOTA DE DÉBITO")
oPrint:SetPortrait() //SetLandScape

DbSelectAr("ZDMTMP")
ZDMTMP->(DbGoTop())
While ZDMTMP->(!Eof())
	//define as fontes
	oFont10  := TFont():New("Arial" ,10,10,,.F.,,,,.T.,.F.)
	oFont10s := TFont():New("Arial" ,10,10,,.F.,,,,.T.,.T.)
	oFont10b := TFont():New("Arial" ,10,10,,.T.,,,,.T.,.F.)
	
	oFont12  := TFont():New("Arial" ,12,12,,.F.,,,,.T.,.F.)
	oFont14b := TFont():New("Arial" ,14,14,,.T.,,,,.T.,.F.)
	
	//_nLin := _nCol := 100
	
	oPrint:SayBitmap(120,930,cStartPath+"WHBL.bmp",600,270)   //logo whb
	
	oPrint:Say(550,1000,"NOTA DE DÉBITO",oFont14b)
	
	If SM0->M0_CODIGO=="FN"
		oPrint:Say(430,1020,"WHB Fundição S/A",oFont12)
		oPrint:Say(710,950,"CNPJ: 01.261.681/0001-04",oFont12)
	ElseIf SM0->M0_CODIGO=="NH"
		oPrint:Say(430,860,"WHB Componentes Automotivos S/A",oFont12)
		oPrint:Say(710,950,"CNPJ: 73.355.174/0001-40",oFont12)
	EndIf
	
	nLin := 850
	
	fPrintBox(nLin,100,nLin+500,2280) //caixa 01
	nLin += 520
	fPrintBox(nLin,100,nLin+450,2280) //caixa 02
	nLin += 470
	fPrintBox(nLin,100,nLin+450,2280) //caixa 03
	nLin += 470
	fPrintBox(nLin,100,nLin+350,2280) //caixa 04
	
	//-- dados da caixa 1
	nLin := 880
	
	oPrint:Say(nLin,  130 ,"Dados do Fornecedor:",oFont10s)
	nLin += 100
	oPrint:Say(nLin,  130 ,"Fornecedor:"         ,oFont10b)
	oPrint:Say(nLin,  460 ,ZDMTMP->ZDM_FORNEC       ,oFont10)
	oPrint:Say(nLin, 1250 ,"Loja:"               ,oFont10b)
	oPrint:Say(nLin, 1600 ,ZDMTMP->ZDM_LOJFOR       ,oFont10)
	nLin += 60
	
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2")+ZDMTMP->ZDM_FORNEC+ZDMTMP->ZDM_LOJFOR))
	
	oPrint:Say(nLin,  130 ,"Razão Social:"       ,oFont10b)
	oPrint:Say(nLin,  460 ,SA2->A2_NOME          ,oFont10)
	nLin += 60
	
	oPrint:Say(nLin,  130 ,"Endereço:"           ,oFont10b)
	oPrint:Say(nLin,  460 ,SA2->A2_END           ,oFont10)
	nLin += 60
	
	oPrint:Say(nLin,  130 ,"Cidade:"             ,oFont10b)
	oPrint:Say(nLin,  460 ,SA2->A2_MUN           ,oFont10)
	nLin += 60
	
	oPrint:Say(nLin,  130 ,"CEP:"                ,oFont10b)
	oPrint:Say(nLin,  460 ,SA2->A2_CEP           ,oFont10)
	nLin += 60
	
	oPrint:Say(nLin,  130 ,"CNPJ:"               ,oFont10b)
	oPrint:Say(nLin,  460 ,SA2->A2_CGC           ,oFont10)
	oPrint:Say(nLin, 1250 ,"Inscrição Estadual:" ,oFont10b)
	oPrint:Say(nLin, 1600 ,SA2->A2_INSCR         ,oFont10)
	
	//-- dados da caixa 2
	nLin := 1400
	oPrint:Say(nLin,  130 ,"Dados do Débito:"    ,oFont10s)
	nLin += 100
	oPrint:Say(nLin,  130 ,"Nº Débito:"          ,oFont10b)
	oPrint:Say(nLin,  460 ,ZDMTMP->ZDM_DOC+" - "+ZDMTMP->ZDM_SERIE ,oFont10)
	
	SF2->(dbSetOrder(1)) //FILIAL + NF + SERIE + FORN + LOJA
	SF2->(dbSeek(xFilial("SF2")+ZDMTMP->ZDM_DOC+ZDMTMP->ZDM_SERIE+ZDMTMP->ZDM_CLI+ZDMTMP->ZDM_LOJCLI))
	oPrint:Say(nLin, 1250 ,"Emissão ND:"         ,oFont10b)
	oPrint:Say(nLin, 1600 ,Iif(SF2->(Found()),DtoC(SF2->F2_EMISSAO),"") ,oFont10)
	nLin += 60
	
	oPrint:Say(nLin,  130 ,"Nº da Nota:"         ,oFont10b)
	oPrint:Say(nLin,  460 ,ZDMTMP->ZDM_DOCORI+" - "+ZDMTMP->ZDM_SERORI ,oFont10)
	SF1->(dbSetOrder(1)) //FILIAL + NF + SERIE + FORN + LOJA
	SF1->(dbSeek(xFilial("SF1")+ZDMTMP->ZDM_DOCORI+ZDMTMP->ZDM_SERORI+ZDMTMP->ZDM_FORNEC+ZDMTMP->ZDM_LOJFOR))
	oPrint:Say(nLin, 1250 ,"Emissão NF:"         ,oFont10b)
	oPrint:Say(nLin, 1600 ,Iif(SF1->(FOUND()),DtoC(SF1->F1_EMISSAO),"") ,oFont10)
	nLin += 60
	
	//busca a data de vencimento
	SE2->(dbSetOrder(6)) // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
	SE2->(dbSeek(xFilial("SE2")+ZDMTMP->ZDM_FORNEC+ZDMTMP->ZDM_LOJFOR+ZDMTMP->ZDM_SERORI+ZDMTMP->ZDM_DOCORI))
	oPrint:Say(nLin,  130 ,"Data Vcto:"          ,oFont10b)
	oPrint:Say(nLin,  460 ,Iif(SE2->(FOUND()),DtoC(SE2->E2_VENCTO),"") ,oFont10)
	
	cMater := ""
	cUn    := ""
	
	//busca a descricao do material
	SD1->(dbSetOrder(1)) //FILIAL + NF + SERIE + FORN + LOJA
	If SD1->(dbSeek(xFilial("SD1")+ZDMTMP->ZDM_DOCORI+ZDMTMP->ZDM_SERORI+ZDMTMP->ZDM_FORNEC+ZDMTMP->ZDM_LOJFOR))
		SB1->(dbSetOrder(1)) //FILIAL + COD
		If SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
			cMater := SB1->B1_DESC
			cUn    := SB1->B1_UM
		EndIf
	EndIf
	
	oPrint:Say(nLin, 1250 ,"Material:"           ,oFont10b)
	oPrint:Say(nLin, 1600 ,Substr(cMater,1,40)   ,oFont10)
	nLin += 60
	
	oPrint:Say(nLin,  130 ,"Unidade:"            ,oFont10b)
	oPrint:Say(nLin,  460 ,cUn                   ,oFont10)
	oPrint:Say(nLin, 1250 ,"Solicitante:"        ,oFont10b)
	oPrint:Say(nLin, 1600 ,ZDMTMP->ZDM_SOLIC        ,oFont10)
	nLin += 60
	
	oPrint:Say(nLin,  130 ,"Vlr Total Débito:"   ,oFont10b)
	oPrint:Say(nLin,  460 ,AllTrim(Transform(Iif(SF2->(Found()),SF2->F2_VALBRUT,0),"@e 999,999,999.99")) ,oFont10)
	
	//-- dados da caixa 3
	nLin := 1870
	oPrint:Say(nLin,  130 ,"Histórico:"          ,oFont10s)
	
	nLinha := MlCount(ZDMTMP->ZDM_MOTIVO,110)
	nLin   := 1970
	For y:=1 to nLinha
		oPrint:Say(nLin, 130,OemToAnsi(MemoLine(ZDMTMP->ZDM_MOTIVO,110,y)),oFont10)
		nLin += 40
	Next
	
	nLin   += 40
	
	nLinha := MlCount(ZDMTMP->ZDM_MOTIV2,110)
	For y:=1 to nLinha
		oPrint:Say(nLin, 130,OemToAnsi(MemoLine(ZDMTMP->ZDM_MOTIV2,110,y)),oFont10)
		nLin += 40
	Next
	
	//-- dados da caixa 4
	nLin := 2340
	oPrint:Say(nLin,  130 ,"DECLARAÇÃO"          ,oFont10b)
	
	cDec := "Declaramos para os devidos fins previstos no artigo 166 "+;
	"e demais pertinente ao código tributário nacional(lei nº 5.172 de 25/10/66) "+;
	"não havermos aproveitado os créditos referentes ao ICMS e IPI correspondentes "+;
	"a nota fiscal acima mencionada, pagos a maior ou indevidamente pelo fornecedor "+;
	"acima.Assim sendo, está a mesma, perfeitamente apta a pleitear a restituição dos "+;
	"referidos impostos, na forma da legislação vigente "
	
	nLinha := MlCount(cDec,120)
	nLin   := 2440
	For y:=1 to nLinha
		oPrint:Say(nLin, 130,OemToAnsi(MemoLine(cDec,120,y)),oFont10)
		nLin += 40
	Next
	
	oPrint:Say(2880,  130 ,"Emitente:"          ,oFont10b)
	oPrint:Line(3080, 130 , 3080 , 1000)
	oPrint:Say(3100,  130 ,"Gerente de Controladoria"      ,oFont10)
	oPrint:Say(3150,  130 ,""         ,oFont10)
	
	oPrint:EndPage()// Finaliza a pagina
	
	ZDMTMP->(DbSkip())
Enddo
oPrint:Preview()// Visualiza a pagina

Return

Static Function fPrintBox(nY1,nX1,nY2,nX2)

oPrint:Line(   nY1 ,  nX1  ,  nY1 ,  nX2 ) //HORIZONTAL 1
oPrint:Line(   nY2 ,  nX1  ,  nY2 ,  nX2 ) //HORIZONTAL 2
oPrint:Line(   nY1 ,  nX1  ,  nY2 ,  nX1 ) //VERTICAL 1
oPrint:Line(   nY1 ,  nX2  ,  nY2 ,  nX2 ) //VERTICAL 2

Return

Static Function AjustaSX1(cPerg)

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

cPerg   :=PadR(cPerg,10)

aRegs   := {}

//              G   O          P                     P                     P                      V   T   T D P  G   V         V   D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  F  G
//              R   R          E                     E                     E                      A   I   A E R  S   A         A   E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  3  R
//              U   D          R                     R                     R                      R   P   M C E  C   L         R   F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  |  P
//              P   E          G                     S                     E                      I   O   A I S  |   I         0   0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  |  S
//              O   M          U                     P                     N                      A   |   N M E  |   D         1   1  P  N  1  2  2  P  N  2  3  3  P  N  3  4  4  P  N  4  5  5  P  N  5  |  X
//              |   |          N                     A                     G                      V   |   H A L  |   |         |   |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  G
//              |   |          T                     |                     |                      E   |   O L |  |   |         |   |  1  1  |  |  |  2  2  |  |  |  3  3  |  |  |  4  4  |  |  |  5  5  |  |  |
//              |   |          |                     |                     |                      |   |   | | |  |   |         |   |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |

aadd(aRegs,{cPerg,"01","Da nota fiscal de debito ?   ","Da nota fiscal de ddebito ?  ","Da nota fiscal de debito ?   "  ,"mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Ate a nota fiscal de debito ?","Ate a nota fiscal de debito ?","Ate a nota fiscal de debito ?"  ,"mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

aadd(aRegs,{cPerg,"03","Série ?                      ","Série ?                      ","Série ?                      "  ,"mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","Ate a série ?                ","Ate a série ?                ","Ate a série ?                "  ,"mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

aadd(aRegs,{cPerg,"05","Número ?                     ","Número ?                     ","Número ?                     "  ,"mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"06","Ate a número ?               ","Ate a número ?               ","Ate a número ?               "  ,"mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})

aadd(aRegs,{cPerg,"07","Da data de emissão ?         ","Da data de emissão ?         ","Da data de emissão ?         "  ,"mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"08","Ate data de emissão ?        ","Ate data de emissão ?        ","Ate data de emissão ?        "  ,"mv_ch8","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})

aadd(aRegs,{cPerg,"09","Do Fornecedor ?              ","Do Fornecedor ?              ","Do Fornecedor ?              "  ,"mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
aadd(aRegs,{cPerg,"10","Até o Fornecedor ?           ","Até o Fornecedor ?           ","Até o Fornecedor ?           "  ,"mv_cha","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})

aadd(aRegs,{cPerg,"11","Da Loja ?                    ","Da Loja ?                    ","Da Loja ?                    "  ,"mv_chb","C",02,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"12","Ate Loja ?                   ","Ate Loja ?                   ","Ate Loja ?                   "  ,"mv_chc","C",02,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})

aadd(aRegs,{cPerg,"13","Situação ?                   ","Situação ?                   ","Situação ?                   "  ,"mv_chd","N",01,0,4,"C","","mv_par13","Titulo Baixado","Titulo Baixado","Titulo Baixado","","","Débito s/Lancto","Débito s/Lancto","Débito s/Lancto","","","Titulo Aberto","Titulo Aberto","Titulo Aberto","","","Todas","Todas","Todas","","","","","","","",""})

cUltPerg := aRegs[Len(aRegs)][2]

dbSelectArea("SX1")
dbSetOrder(1)
If !SX1->(DbSeek(cPerg + cUltPerg))
	
	SX1->(DbSeek(cPerg))
	While SX1->X1_Grupo == cPerg
		RecLock('SX1')
		SX1->(DbDelete())
		SX1->(DbSkip())
		MsUnLock('SX1')
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
