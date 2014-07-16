#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPCP030  ºAutor  ³Felipe Ciconini     º Data ³  09/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATORIO DE QUANTIDADE DE ALERTAS DE CRITICIDADE          º±±
±±º          ³ E PARADA DE LINHA                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PLANEJAMENTO E CONTROLE DA PRODUCAO                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Chamado Nº 007860:
Boa Tarde Felipe! Conforme conversamos, após a criação do ALERTA DE CRITICIDADE E PARADA DE LINHA e CALCULO DE PREJUIZO, 
precisamos criar um relatorio para saber quantas ALERTAS DE CRITICIDADE e quantas ALERTAS DE PARADAS de linha foram 
emitidas naquele mes para cada fornecedor, tambem precisamos saber qual o numero emitido para cada uma delas e qual item. 
(um resumo do ocorrido no mes)

Perguntas:
 _______________________
|                       |
| mv_par01 = De Prod    |
| mv_par02 = Ate Prod   |
| mv_par03 = De Fornec  |
| mv_par04 = Ate Fornec |
| mv_par05 = Mes/Ano    |
|_______________________|

*/

User Function NHPCP030()
Private aCri	:= {}
Private aPar    := {}
Private aLog	:= {}
Private aCal	:= {}
Private aProd	:= {}
Private aCliFor := {}
Private aAux	:= {}

cString		:= "ZDU"
cDesc1		:= "Este relatorio tem como objetivo imprimir"
cDesc2		:= "a soma de Alertas e Calculos gerados"
cDesc3		:= ""
tamanho		:= "M"
limite		:= 132
aReturn		:= { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHPCP030"
nLastKey	:= 0
titulo		:= OemToAnsi("RELATÓRIO DE ALERTAS")
cabec1		:= "RELATÓRIO DE ALERTAS"
cabec2		:= " "
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1
M_PAG		:= 1
wnrel		:= "NHPCP030"
_cPerg		:= "PCP030"

Pergunte(_cPerg,.F.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

If nLastKey == 27
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)

nTipo		:= IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))

aDriver		:= ReadDriver()
cCompac		:= aDriver[1]

Processa({|| Gerando()  },"Gerando Dados para Impressao")
Processa({|| RptDetail()  },"Imprimindo....")

Set Filter To
If aReturn[5]==1
	Set Printer To
	Commit
	OurSpool(wnrel)
EndIf
MS_FLUSH()

Return


Static Function Gerando()
Local   cQuery
Local	cCliFor		:= ""
Local	cProd		:= ""
Local	_nC			:= 0




	cQuery := "SELECT ZDU_NUM, ZDU_TIPO, ZDU_CLIFOR, ZDU_CF, ZDU_LOJA,ZDV_PROD, ZDV_ITEM, ZDU_STATUS"
	cQuery += " FROM "+RetSqlName("ZDU")+" ZDU, "+RetSqlName("ZDV")+" ZDV "
	cQuery += " WHERE	ZDV_NUM 		= ZDU_NUM"
	cQuery += " AND		ZDV_PROD		BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND		ZDU_CLIFOR		BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND		MONTH(ZDU_DATA) = "+SubStr(mv_par05,1,2)
	cQuery += " AND		YEAR(ZDU_DATA)	= "+SubStr(mv_par05,4,4)		
	
	cQuery += " AND 	ZDU.D_E_L_E_T_ 	= ' '"
	cQuery += " AND		ZDV.D_E_L_E_T_ 	= ' '"
	cQuery += " AND		ZDU_FILIAL		= '"+xFilial("ZDU")+"'"
	cQuery += " AND		ZDV_FILIAL		= '"+xFilial("ZDV")+"'"
	
	cQuery += " ORDER BY ZDU_CLIFOR,ZDU_LOJA,ZDV_PROD,ZDU_TIPO "
	
	
	MemoWrit("C:\Temp\NHPCP030.SQL",cQuery)
	TCQUERY cQuery NEW ALIAS "TMP1"

	TMP1->(DbGoTop())
	
	While TMP1->(!EoF())
		
		cCliFor := TMP1->ZDU_CLIFOR+"-"+TMP1->ZDU_LOJA+"/"+TMP1->ZDU_CF
		
		While TMP1->ZDU_CLIFOR+"-"+TMP1->ZDU_LOJA+"/"+TMP1->ZDU_CF == cCliFor
		
			cProd := TMP1->ZDV_PROD
			
			While cProd == TMP1->ZDV_PROD			//SEPARA OS TIPOS DE ALERTAS EM ARRAYS DISTINTOS
			
				If TMP1->ZDU_TIPO == "C"           	//CRITICIDADE
					
					aAdd(aCri,TMP1->ZDU_NUM)
					
				ElseIf TMP1->ZDU_TIPO == "P"		//PARADA DE LINHA
					
					aAdd(aPar,TMP1->ZDU_NUM)
					
				ElseIf TMP1->ZDU_TIPO == "L"		//ALERTA LOGITISTICO
					
					aAdd(aLog,TMP1->ZDU_NUM)
					
				EndIf
				
				If TMP1->ZDU_STATUS == "N"			//CALCULO REALIZADO?
				
					aAdd(aCal,TMP1->ZDU_NUM)
				
				EndIf
				
				TMP1->(DbSkip())
			
			EndDo
			
			aAdd(aProd,{cProd,aCri,aPar,aLog,aCal})
			aCri := aClone(aAux)
			aPar := aClone(aAux)
			aLog := aClone(aAux)
			aCal := aClone(aAux)
			
		
		EndDo
		
		aAdd(aCliFor,{cCliFor,aProd})
		aProd := aClone(aAux)
	
	EndDo
	
	
Return

Static Function RptDetail()
Local cFor  	:= ""
Local xP		:= 1
Local xF		:= 1
Local xA		:= 1
Local nTit1 	:= "CODIGO       DESCRIÇÃO CLI/FOR"
Local nTit2 	:= "PRODUTO                DESCRIÇÃO                   CRITICIDADE       PARADAS      LOGISTICO      CALCULOS"
				 //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
				 //          10        20        30        40        50        60        70        80        90        100       110
Local cForDsc 	:= ""
Local nCri		:= 0
Local nPar		:= 0
Local nLog		:= 0
Local nCal		:= 0

	cabec1 := "RELATÓRIO DE ALERTAS DO MÊS DE "+Upper(MesExtenso(SubStr(mv_par05,1,2)))+" DE "+SubStr(mv_par05,4,4)
	
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	@Prow()+1,002 PSAY nTit1			//IMPRIMINDO CABECALHO CLI/FOR
	@Prow()+1,007 PSAY nTit2			//IMPRIMINDO CABECALHO PRODUTO/ALERTAS
	@Prow()+1,001 PSAY __PrtThinLine()

	While xF <= Len(aCliFor)

		@Prow()+2,001 PSAY SubStr(aCliFor[xF][1],1,9)   			//IMPRIMINDO FORNECEDOR/LOJA E DESCRIÇÃO
		If SubStr(aCliFor[xF][1],11,1) == "C"
			cForDsc := Posicione("SA1",1,xFilial("SA1")+SubStr(aCliFor[xF][1],1,6)+SubStr(aCliFor[xF][1],8,2),"A1_NOME")
			@Prow()  ,015 PSAY cForDsc
		ElseIf SubStr(aCliFor[xF][1],11,1) == "F"
			cForDsc := Posicione("SA2",1,xFilial("SA2")+SubStr(aCliFor[xF][1],1,6)+SubStr(aCliFor[xF][1],8,2),"A2_NOME")
			@Prow()  ,015 PSAY cForDsc
		EndIf
		
		While xP <= Len(aCliFor[xF][2])
		
			@Prow()+Iif(xP==1,1,2),007 PSAY xP
			@Prow()  ,Iif(xP>9,9,8) PSAY "."
			@Prow()  ,010 PSAY aCliFor[xF][2][xP][1]
			SB1->(DbSelectArea(1))		//filial+cod
			If SB1->(DbSeek(xFilial("SB1")+aCliFor[xF][2][xP][1]))
				@Prow()  ,030 PSAY SubStr(SB1->B1_DESC,1,19)
			EndIF
			
			While xA <= Len(aCliFor[xF][2][xP][2]) .OR. xA <= Len(aCliFor[xF][2][xP][3]) .OR. xA <= Len(aCliFor[xF][2][xP][4]) .OR. xA <= Len(aCliFor[xF][2][xP][5])
			    
				If Prow() > 60
				
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					@Prow()+1,002 PSAY nTit1	//IMPRIMINDO CABECALHO CLI/FOR
					@Prow()+1,007 PSAY nTit2	//IMPRIMINDO CABECALHO PRODUTO/ALERTAS
					@Prow()+1,001 PSAY __PrtFatLine()
					
					@Prow()+1,002 PSAY SubStr(aCliFor[xF][1],1,9)   			//IMPRIMINDO FORNECEDOR/LOJA E DESCRIÇÃO
					If SubStr(aCliFor[xF][1],11,1) == "C"
	 					cForDsc := Posicione("SA1",1,xFilial("SA1")+SubStr(aCliFor[xF][1],1,6)+SubStr(aCliFor[xF][1],8,2),"A1_NOME")
  						@Prow()  ,015 PSAY cForDsc
  					ElseIf SubStr(aCliFor[xF][1],11,1) == "F"
   						cForDsc := Posicione("SA2",1,xFilial("SA2")+SubStr(aCliFor[xF][1],1,6)+SubStr(aCliFor[xF][1],8,2),"A2_NOME")
						@Prow()  ,015 PSAY cForDsc
					EndIf
					
					@Prow()+1,007 PSAY xP
					@Prow()  ,Iif(xP>9,9,8) PSAY "."
					@Prow()  ,010 PSAY aCliFor[xF][2][xP][1]
					If SB1->(DbSeek(xFilial("SB1")+aCliFor[xF][2][xP][1]))
						@Prow()  ,030 PSAY SubStr(SB1->B1_DESC,1,19)
					EndIF
					
				EndIf

				If xA <= Len(aCliFor[xF][2][xP][2])
					If aCliFor[xF][2][xP][2][xA] <> ""
						@Prow()+Iif(xA==1,0,1),060 PSAY aCliFor[xF][2][xP][2][xA]
						nCri++
					Else
						@Prow()+Iif(xA==1,0,1),060 PSAY ""
					EndIf
				Else
					@Prow()+Iif(xA==1,0,1),060 PSAY " "
				EndIf
				
				If xA <= Len(aCliFor[xF][2][xP][3])
					If aCliFor[xF][2][xP][3][xA] <> ""
						@Prow()  ,077 PSAY aCliFor[xF][2][xP][3][xA]
						nPar++
					Else
						@Prow()  ,077 PSAY ""
					EndIf
				Else
					@Prow()  ,077 PSAY " "
				EndIf
				
				If xA <= Len(aCliFor[xF][2][xP][4])
					If aCliFor[xF][2][xP][4][xA] <> ""
						@Prow()  ,091 PSAY aCliFor[xF][2][xP][4][xA]
						nLog++
					Else
						@Prow()  ,091 PSAY ""
					EndIf
				Else
					@Prow()  ,091 PSAY " "
				EndIf
				
				If xA <= Len(aCliFor[xF][2][xP][5])
					If aCliFor[xF][2][xP][5][xA] <> ""
			  			@Prow()  ,105 PSAY aCliFor[xF][2][xP][5][xA]
			  			nCal++
			 		Else
						@Prow()  ,105 PSAY ""
					EndIf
				Else
					@Prow()  ,105 PSAY " "
				EndIf
				
				xA++
			
			EndDo
			
			@Prow()+1,049 PSAY Repl("_",63)
			@Prow()+1,050 PSAY "TOTAL"
			@Prow()  ,063 PSAY nCri
			@Prow()  ,080 PSAY nPar
			@Prow()  ,094 PSAY nLog
			@Prow()  ,108 PSAY nCal
			nCri := 0
			nPar := 0
			nLog := 0
			nCal := 0
			
			xA := 1
			xP++
		
		EndDo
		
		@Prow()+2,001 PSAY __PrtThinLine()
		xP := 1
		xF++
	
	EndDo

TMP1->(DbCloseArea())
Return