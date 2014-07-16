/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHGPE180  บAutor  ณFelipe Ciconini     บ Data ณ  17/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressใo de Vencimento de Experi๊ncia                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

User Function NHGPE180(nParam)
SetPrvt("_cArqDbf, cQuery,_aFields,aCampos,cMarca,cNovaLinha,cARQEXP ,cARQ,nPbruto,i,nqtde,netiq,nVol")   
Private cPerg := "GPE180"
Private cStartPath 	:= GetSrvProfString("Startpath","")

If Right(cStartPath,1) <> "\"
	cStartPath += "\"
Endif                                

If Pergunte(cPerg,.T.)
    
   	Processa({|| Gerando()}, "Gerando dados para Impressใo")
	Processa({|| ImpEtq() }, "Imprimindo...")

Endif

Return
 
Static Function ImpEtq()
Local nLin := 30
Local nPag := 0
Local cDias
Local dVen
Local dEnt

	Local aEtiq := {}
	Local nColAtu := 1  //Numero de colunas da impressas
	Local nLinAtu := 1  //Numero de linhas impressas
	Local nAjust  := 1                       
	Local _cQtde  

	oFont10  := TFont():New("Arial",,10,,.F.)
	oFont11  := TFont():New("Arial",,11,,.F.)
	oFont12  := TFont():New("Arial",,12,,.F.)
	oFont16  := TFont():New("Arial",,16,,.F.)
	oFont12I := TFont():New("Arial",,12,,.T.)
	oFont10N := TFont():New("Arial",,10,,.T.)
	oFont11N := TFont():New("Arial",,11,,.T.)
	oFont12N := TFont():New("Arial",,12,,.T.)
	oFont14N := TFont():New("Arial",,14,,.T.)
	oFont16N := TFont():New("Arial",,16,,.T.)
	oFont18N := TFont():New("Arial",,18,,.T.)
	oPr:= tAvPrinter():New("Protheus")
	oPr:StartPage()

	IncProc("Imprimindo...")
    
    While TMP1->(!EoF())
    
	    //PEGANDO VENCIMENTO DE EXPERIENCIA 90 DIAS
	    If StoD(TMP1->RA_ADMISSA)+29 >= mv_par03 .AND. StoD(TMP1->RA_ADMISSA)+29 <= mv_par04
	    	cDias := "30"
	    Else
	    	If StoD(TMP1->RA_ADMISSA)+89 >= mv_par03 .AND. StoD(TMP1->RA_ADMISSA)+89 <= mv_par04
	    		cDias := "90"
	    	Else
	    		TMP1->(DbSkip())
	    		Loop
	    	EndIf
	    EndIf
    
		oPr:SayBitmap(nLin,100,cStartPath+"\WHBL.bmp",300,100)
		oPr:Say(nLin+50,0800,OemToAnsi("Informa็๕es de Vencimento de Experi๊ncia"),oFont12I)
		oPr:Say(nLin+170,0300,OemToAnsi("COD"),oFont12N)
		oPr:Say(nLin+170,0500,OemToAnsi(TMP1->CTT_CUSTO),oFont11N)
		oPr:Line(nLin+160,0450,nLin+160,0700)
		oPr:Line(nLin+160,0450,nLin+220,0450)
		oPr:Line(nLin+160,0700,nLin+220,0700)
		oPr:Line(nLin+220,0450,nLin+220,0700)
		
		oPr:Say(nLin+170,1250,OemToAnsi("DESCRIวรO"),oFont12N)
		oPr:Say(nLin+170,1580,OemToAnsi(SubStr(TMP1->CTT_DESC01,1,25)),oFont11N)
		oPr:Line(nLin+160,1530,nLin+160,2300)
		oPr:Line(nLin+160,1530,nLin+220,1530)
		oPr:Line(nLin+160,2300,nLin+220,2300)
		oPr:Line(nLin+220,1530,nLin+220,2300)

		If cDias == "90"
			dVen := StoD(TMP1->RA_ADMISSA)+89
			dEnt := dVen-4
		Else
			dVen := StoD(TMP1->RA_ADMISSA)+29
			dEnt := dVen-4
		EndIf
		
		oPr:Say(nLin+270,200,OemToAnsi("Referente ao contrato de experi๊ncia por "+cDias+" dias com o Sr(a). "+AllTrim(TMP1->RA_MAT)+" - "+AllTrim(SubStr(TMP1->RA_NOME,1,25))),oFont12)
		oPr:Say(nLin+320,200,OemToAnsi("e estando o mesmo por expirar no dia "+DtoC(dVen)+" solicitamos เ V.Sa. o preenchimento do questionแrio"),oFont12)
		oPr:Say(nLin+370,200,OemToAnsi("abaixo e devolv๊-lo at้ "+DtoC(dEnt)+" เs 14:00hs, possibilitando assim os tramites legais."),oFont12)
		
		//MONTANDO TABELA
		
		oPr:Line(nLin+570,0250,nLin+570,2300)	//1a linha
		oPr:Line(nLin+620,0250,nLin+620,2300)	//2a linha
		oPr:Line(nLin+670,0250,nLin+670,2300)	//3a linha
		oPr:Line(nLin+720,0250,nLin+720,2300)	//4a linha
		oPr:Line(nLin+770,0250,nLin+770,2300)	//5a linha
		oPr:Line(nLin+820,0250,nLin+820,2300)	//6a linha
		oPr:Line(nLin+870,0250,nLin+870,2300)	//7a linha	
		oPr:Line(nLin+920,0250,nLin+920,2300)	//8a linha
		oPr:Line(nLin+970,0250,nLin+970,2300)	//9a linha
		oPr:Line(nLin+1020,0250,nLin+1020,2300)	//10a linha
		
		oPr:Line(nLin+570,0250,nLin+1020,0250)	 //1a coluna
		oPr:Line(nLin+570,0750,nLin+1020,0750)	 //2a coluna
		oPr:Line(nLin+570,0900,nLin+1020,0900)	 //3a coluna
		oPr:Line(nLin+570,1050,nLin+1020,1050)	 //4a coluna
		oPr:Line(nLin+570,1260,nLin+1020,1260)	 //5a coluna
		oPr:Line(nLin+570,1440,nLin+1020,1440)	 //6a coluna
		oPr:Line(nLin+570,2300,nLin+1020,2300)	 //7a coluna
		
		oPr:Say(nLin+580,0460,OemToAnsi("ITEM"),oFont10N)
		oPr:Say(nLin+580,0770,OemToAnsi("OTIMO"),oFont10N)
		oPr:Say(nLin+580,0930,OemToAnsi("BOM"),oFont10N)
		oPr:Say(nLin+580,1070,OemToAnsi("REGULAR"),oFont10N)
		oPr:Say(nLin+580,1290,OemToAnsi("FRACO"),oFont10N)
		oPr:Say(nLin+580,1680,OemToAnsi("OBSERVAวีES"),oFont10N)
		oPr:Say(nLin+630,0280,OemToAnsi("Adapta็ใo ao Servi็o"),oFont10)
		oPr:Say(nLin+680,0280,OemToAnsi("Conhecimento da Fun็ใo"),oFont10)
		oPr:Say(nLin+730,0280,OemToAnsi("Iniciativa"),oFont10)
		oPr:Say(nLin+780,0280,OemToAnsi("Coopera็ใo com o Grupo"),oFont10)
		oPr:Say(nLin+830,0280,OemToAnsi("Pontualidade"),oFont10)
		oPr:Say(nLin+880,0280,OemToAnsi("Qualidade de Trabalho"),oFont10)
		oPr:Say(nLin+930,0280,OemToAnsi("Produ็ใo"),oFont10)
		oPr:Say(nLin+980,0280,OemToAnsi("Relac. com os Colegas"),oFont10)
		
		oPr:Say(nLin+1110,270,OemToAnsi("Considera็๕es:"),oFont11)
		
		oPr:Say(nLin+1180,270,OemToAnsi("1.Deve ser Prorrogado"),oFont11)	
		oPr:Line(nLin+1160,0750,nLin+1160,0900)	//linha 1
		oPr:Line(nLin+1230,0750,nLin+1230,0900)	//linha 2
		oPr:Line(nLin+1160,0750,nLin+1230,0750)	//colun 1
		oPr:Line(nLin+1160,0900,nLin+1230,0900)	//colun 2
			                   
		oPr:Say(nLin+1280,270,OemToAnsi("2.Deve ser Desligado"),oFont11)
		oPr:Line(nLin+1260,0750,nLin+1260,0900)	//linha 1
		oPr:Line(nLin+1330,0750,nLin+1330,0900)	//linha 2
		oPr:Line(nLin+1260,0750,nLin+1330,0750)	//colun 1
		oPr:Line(nLin+1260,0900,nLin+1330,0900)	//colun 2
		
		oPr:Say(nLin+1280,1300,OemToAnsi("Curitiba,_____ de ________________________ de "+Str(Year(Date()),4)),oFont11)
		oPr:Say(nLin+1430,0270,Replicate("_",30),oFont11)
		oPr:Say(nLin+1470,0460,OemToAnsi("Funcionแrio"),oFont10)
		oPr:Say(nLin+1430,1500,Replicate("_",30),oFont11)
		oPr:Say(nLin+1470,1600,OemToAnsi("Nome do Superior Imediato"),oFont10)
		
		oPr:Line(nLin+1580,050,nLin+1580,2450)

		oPr:Say(nLin+1610,270,OemToAnsi("Data                /         /             ."  ),oFont11)
		oPr:Say(nLin+1660,270,OemToAnsi("Tendo sido efetuado a prorroga็ใo acima solicitada, retornamos ao assunto a fim de obtermos de"),oFont11)	
		oPr:Say(nLin+1710,270,OemToAnsi("V.Sa., decisใo final, que deverแ nos ser devolvido at้ o dia              /            /               เs 16:00 horas."),oFont11)	

		nLin := 1300
	    
		//MONTANDO TABELA 2 

		
		oPr:Line(nLin+570,0250,nLin+570,2300)	//1a linha
		oPr:Line(nLin+620,0250,nLin+620,2300)	//2a linha
		oPr:Line(nLin+670,0250,nLin+670,2300)	//3a linha
		oPr:Line(nLin+720,0250,nLin+720,2300)	//4a linha
		oPr:Line(nLin+770,0250,nLin+770,2300)	//5a linha
		oPr:Line(nLin+820,0250,nLin+820,2300)	//6a linha
		oPr:Line(nLin+870,0250,nLin+870,2300)	//7a linha	
		oPr:Line(nLin+920,0250,nLin+920,2300)	//8a linha
		oPr:Line(nLin+970,0250,nLin+970,2300)	//9a linha
		oPr:Line(nLin+1020,0250,nLin+1020,2300)	//10a linha
		
		oPr:Line(nLin+570,0250,nLin+1020,0250)	 //1a coluna
		oPr:Line(nLin+570,0750,nLin+1020,0750)	 //2a coluna
		oPr:Line(nLin+570,0900,nLin+1020,0900)	 //3a coluna
		oPr:Line(nLin+570,1050,nLin+1020,1050)	 //4a coluna
		oPr:Line(nLin+570,1260,nLin+1020,1260)	 //5a coluna
		oPr:Line(nLin+570,1440,nLin+1020,1440)	 //6a coluna
		oPr:Line(nLin+570,2300,nLin+1020,2300)	 //7a coluna
		
		oPr:Say(nLin+580,0460,OemToAnsi("ITEM"),oFont10N)
		oPr:Say(nLin+580,0770,OemToAnsi("OTIMO"),oFont10N)
		oPr:Say(nLin+580,0930,OemToAnsi("BOM"),oFont10N)
		oPr:Say(nLin+580,1070,OemToAnsi("REGULAR"),oFont10N)
		oPr:Say(nLin+580,1290,OemToAnsi("FRACO"),oFont10N)
		oPr:Say(nLin+580,1680,OemToAnsi("OBSERVAวีES"),oFont10N)
		oPr:Say(nLin+630,0280,OemToAnsi("Adapta็ใo ao Servi็o"),oFont10)
		oPr:Say(nLin+680,0280,OemToAnsi("Conhecimento da Fun็ใo"),oFont10)
		oPr:Say(nLin+730,0280,OemToAnsi("Iniciativa"),oFont10)
		oPr:Say(nLin+780,0280,OemToAnsi("Coopera็ใo com o Grupo"),oFont10)
		oPr:Say(nLin+830,0280,OemToAnsi("Pontualidade"),oFont10)
		oPr:Say(nLin+880,0280,OemToAnsi("Qualidade de Trabalho"),oFont10)
		oPr:Say(nLin+930,0280,OemToAnsi("Produ็ใo"),oFont10)
		oPr:Say(nLin+980,0280,OemToAnsi("Relac. com os Colegas"),oFont10)
		oPr:Say(nLin+1110,270,OemToAnsi("Considera็๕es:"),oFont11)
		oPr:Say(nLin+1180,270,OemToAnsi("1.Deve ser Efetivado"),oFont11)	

		oPr:Line(nLin+1160,0750,nLin+1160,0900)	//linha 1
		oPr:Line(nLin+1230,0750,nLin+1230,0900)	//linha 2
		oPr:Line(nLin+1160,0750,nLin+1230,0750)	//colun 1
		oPr:Line(nLin+1160,0900,nLin+1230,0900)	//colun 2
			
		oPr:Say(nLin+1280,270,OemToAnsi("2.Deve ser Desligado"),oFont11)
		oPr:Line(nLin+1260,0750,nLin+1260,0900)	//linha 1
		oPr:Line(nLin+1330,0750,nLin+1330,0900)	//linha 2
		oPr:Line(nLin+1260,0750,nLin+1330,0750)	//colun 1
		oPr:Line(nLin+1260,0900,nLin+1330,0900)	//colun 2
		
		oPr:Say(nLin+1280,1300,OemToAnsi("Curitiba,_____ de ________________________ de "+Str(Year(Date()),4)),oFont11)
		oPr:Say(nLin+1430,0270,Replicate("_",30),oFont11)
		oPr:Say(nLin+1470,0460,OemToAnsi("Funcionแrio"),oFont10)
		oPr:Say(nLin+1430,1500,Replicate("_",30),oFont11)
		oPr:Say(nLin+1470,1600,OemToAnsi("Nome do Superior Imediato"),oFont10)
		
		oPr:Line(nLin+1580,050,nLin+1580,2450)
		oPr:EndPage()
		oPr:StartPage()
		nPag := 0
		nLin := 30
		
		TMP1->(DbSkip())
		
	Enddo
	TMP1->(DbCloseArea())
	
    oPr:Preview()
	oPr:End()

	MS_FLUSH()

Return

Static Function Gerando()
Local cQuery

	cQuery := "SELECT RA.RA_MAT,RA.RA_NOME,RA.RA_ADMISSA,CTT.CTT_DESC01,CTT.CTT_CUSTO" 
	cQuery += " FROM "+RetSqlName("SRA")+" RA, "+RetSqlName("CTT")+" CTT"
	cQuery += " WHERE RA.RA_CC 		= CTT.CTT_CUSTO"
	cQuery += " AND RA.RA_MAT 		BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	
	cQuery += " AND RA.D_E_L_E_T_ 	= ''"
	cQuery += " AND CTT.D_E_L_E_T_ 	= ''"
	cQuery += " AND RA.RA_FILIAL 	= '"+xFilial("SRA")+"'"
	cQuery += " AND CTT.CTT_FILIAL 	= '"+xFilial("CTT")+"'"
	cQuery += " ORDER BY RA_ADMISSA DESC"

	TCQUERY cQuery NEW ALIAS "TMP1"

	TMP1->(DbGoTop())

Return