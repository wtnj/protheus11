/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHFAT034  ºAutor  ³FELIPE CICONINI     º Data ³  08/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Faturamento                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Faturamento                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

 _____________________________
|                             |
|        ~>Perguntas<~        |
| --------------------------- |
| mv_par01	Data    - Inicial |
| mv_par02	Data    - Final   |
| mv_par03	Cliente - Inicial |
| mv_par04	Loja    - Inicial |
| mv_par05  Cliente - Final   |
| mv_par06  Loja    - Final   |
| mv_par07	Diario/Resumo     |
| mv_par08	WHBIII? (s/n)     |
| mv_par09	txt? (s/n)        |
| mv_par10	Grupo   - Inicial |
| mv_par11	Grupo   - Final   |
|_____________________________|


*/

#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"



User Function NHFAT034()
Private aTxt := {}

cString		:= "SD2"
cDesc1		:= "Este relatorio tem como objetivo imprimir"
cDesc2		:= "o faturamento detalhado ocorrido no intervalo desejado"
cDesc3		:= ""
tamanho		:= "M"
limite		:= 132
aReturn		:= { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHFAT034"
nLastKey	:= 0
titulo		:= OemToAnsi("RELATÓRIO DE FATURAMENTO")
cabec1		:= " "
cabec2		:= " "
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1
M_PAG		:= 1
wnrel		:= "NHFAT034"
_cPerg		:= "FAT034"



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

Processa({|| Gerando() },"Gravando Dados no Banco")
Processa({|| RptDetail()  },"Imprimindo...")

Set Filter To
If aReturn[5]==1
	Set Printer To
	Commit
	OurSpool(wnrel)
EndIf
MS_FLUSH()

Return

Static Function Gerando()
Local cQuery
                                                                                                                        
//#########################\\
//####|GERANDO A QUERY|####\\
//#########################\\

	cQuery := "SELECT D2.D2_CLIENTE,D2.D2_LOJA,D2.D2_COD,D2.D2_EMISSAO,D2.D2_IPI,D2.D2_PRCVEN,D2.D2_VALIPI,D2.D2_VALDEV,SUM(D2.D2_QUANT) QUANT,SUM(D2.D2_TOTAL) TOTAL"
	cQuery += " FROM "+RetSqlName("SD2")+" D2, "+RetSqlName("SF4")+" F4 "
	cQuery += " WHERE	D2.D2_EMISSAO	BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"'"
	cQuery += " AND		D2.D2_CLIENTE	BETWEEN '"+mv_par03+"' AND '"+mv_par05+"'"
	cQuery += " AND		D2.D2_LOJA		BETWEEN '"+mv_par04+"' AND '"+mv_par06+"'"
	cQuery += " AND		D2.D2_GRUPO		BETWEEN '"+mv_par10+"' AND '"+mv_par11+"'"
	cQuery += " AND		D2.D2_TES 		= F4.F4_CODIGO"
	cQuery += " AND		F4.F4_DUPLIC 	= 'S'"					//PEGA APENAS TES COM DUPLICATAS
			
	cQuery += " AND		D2.D_E_L_E_T_	= ''"
	cQuery += " AND		F4.D_E_L_E_T_	= ''"
	cQuery += " AND		D2.D2_FILIAL	= '"+xFilial("SD2")+"'"
	cQuery += " AND		F4.F4_FILIAL	= '"+xFilial("SF4")+"'"
	
	cQuery += " GROUP BY D2.D2_CLIENTE,D2.D2_LOJA,D2.D2_COD,D2.D2_EMISSAO,D2.D2_IPI,D2.D2_PRCVEN,D2.D2_VALIPI,D2.D2_VALDEV "
	
	TCQUERY cQuery NEW ALIAS "TRA1"
	MemoWrit('C:\TEMP\NHFAT034.SQL',cQuery)
	
	If mv_par09 == 1
		fGeraTxt()
	EndIf
	
	TRA1->(DbGoTop())

Return

Static Function RptDetail()
Local cCliDsc,nMed,nValCIpi,nTotGerCli:=0,nTotGer:=0,cCLi:="",cProd:="",nTotIpi:=0,nTotIpiCli:=0,nTotSIpi:=0,nTotSIpiCli:=0,nTotVM:=0,nTotVMCli:=0	//VARIAVEIS RELATORIO DIARIO
Local nFatSIpi:=0,nFatCIpi:=0,nAcuSIpi:=0,nAcuCIpi:=0,nDev:=0,nDias,aArr:={}		//VARIAVEIS RESUMO
Local nTotQtd:=0,nTotQtdCli:=0

TRA1->(DbGoTop())

If mv_par01 == mv_par02
	Cabec1:= Upper("Relatório de Faturamento em "+DtoC(mv_par01))
Else
	Cabec1:= Upper("Relatório de Faturamento de "+DtoC(mv_par01)+" até "+DtoC(mv_par02))
EndIf

If mv_par07 == 1                                  //SE FOR DIÁRIO
    
	Cabec2 := ""
    cCli := TRA1->D2_CLIENTE+TRA1->D2_LOJA
	While TRA1->(!EoF())
	    
		If Prow() > 50 .OR. Prow() < 5
			Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
			@Prow()+1,002 PSAY "COD/LOJA     NOME CLIENTE"
			@Prow()+1,005 PSAY "CODIGO                                                              VALOR        VALOR               VALOR"
            @Prow()+1,005 PSAY "PRODUTO             DESCRIÇÃO                  QUANTIDADE           MEDIO        SEM IPI   % IPI     COM IPI         TOTAL"
							  //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
							  //10        20        30        40        50        60        70        80        90        100       110       120       130       140
			@Prow()+1,002 PSAY __PrtThinLine()
		    @Prow()+1,002 PSAY TRA1->D2_CLIENTE+"/"+TRA1->D2_LOJA
		    SA1->(DbSelectArea(1))
		    cCliDsc := Posicione("SA1",1,xFilial("SA1")+TRA1->D2_CLIENTE+TRA1->D2_LOJA,"A1_NOME")
		    @Prow()  ,015 PSAY cCliDsc
		EndIf
	    
	    If cCli <> TRA1->D2_CLIENTE+TRA1->D2_LOJA                                   //IMPRESSÃO DE TOTAL DO CLIENTE E INÍCIO DE OUTRO CLIENTE
 	       	cCli := TRA1->D2_CLIENTE+TRA1->D2_LOJA
 	    
 			@Prow()+1,002 PSAY "TOTAL DO CLIENTE ------->"
		   	@Prow()  ,049 PSAY nTotQtdCli	Picture "@E 99,999,999.99"
		   	@Prow()  ,065 PSAY nTotVMCli	Picture "@E 99,999,999.99"
		   	@Prow()  ,080 PSAY nTotSIpiCli	Picture "@E 99,999,999.99"
		   	@Prow()  ,103 PSAY nTotIpiCli	Picture "@E 999,999.99"
		   	@Prow()  ,116 PSAY nTotGerCli	Picture "@E 99,999,999.99"
			nTotGerCli 	:= 0
			nTotIpiCli 	:= 0
			nTotSIpiCli := 0
			nTotVMCli 	:= 0
			nTotQtdCli 	:= 0
    		@Prow()+1,002 PSAY __PrtThinLine()
		    @Prow()+1,002 PSAY TRA1->D2_CLIENTE+"/"+TRA1->D2_LOJA
		    SA1->(DbSelectArea(1))
		    cCliDsc := Posicione("SA1",1,xFilial("SA1")+TRA1->D2_CLIENTE+TRA1->D2_LOJA,"A1_NOME")
		    @Prow()  ,015 PSAY cCliDsc

	    Endif   
    	
    			
		//-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-\\
		//-_-_-_-_-_-_-_-IMPRESSÃO DOS DADOS-_-_-_-_-_-_-_-\\
		//-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-\\
		
		
			
			nIpi := TRA1->D2_IPI/100
			nValCIpi := ((TRA1->TOTAL) + (TRA1->TOTAL * (nIpi)))
		
			@Prow()+1,005 PSAY TRA1->D2_COD
			If SB1->(DbSeek(xFilial("SB1")+TRA1->D2_COD))
				@Prow()  ,025 PSAY SubStr(SB1->B1_DESC,1,20)
			EndIf		
		    @Prow()  ,049 PSAY TRA1->QUANT   Picture "@E 99,999,999.99"      //Quantidade
		    @Prow()  ,065 PSAY TRA1->D2_PRCVEN	Picture "@E 99,999,999.99"      //Custo Médio
			@Prow()  ,080 PSAY TRA1->TOTAL 	Picture "@E 99,999,999.99"      //Total Sem IPI
			@Prow()  ,095 PSAY TRA1->D2_IPI	 	Picture "@E 999.99"				//% IPI

			@Prow()  ,103 PSAY nIpi				Picture "@E 999,999.99"			//Valor IPI
			@Prow()  ,116 PSAY nValCIpi			Picture "@E 99,999,999.99"		//TOTAL Com IPI
			
			nTotGerCli 	+= nValCIpi
			nTotIpiCli 	+= nIpi
			nTotSIpiCli += TRA1->TOTAL
			nTotQtdCli 	+= TRA1->QUANT
			nTotVMCli   += TRA1->D2_PRCVEN
		
			nTotGer  += nValCIpi
			nTotIpi  += nIpi
			nTotSIpi += TRA1->TOTAL
			nTotVM	 += TRA1->D2_PRCVEN
			nTotQtd	 += TRA1->QUANT
		
		
	   TRA1->(Dbskip())
	EndDo
	
	@Prow()+1,002 PSAY "TOTAL DO CLIENTE ------->"
	@Prow()  ,049 PSAY nTotQtdCli	Picture "@E 99,999,999.99"
	@Prow()  ,065 PSAY nTotVMCli	Picture "@E 99,999,999.99"
	@Prow()  ,080 PSAY nTotSIpiCli	Picture "@E 99,999,999.99"
	@Prow()  ,103 PSAY nTotIpiCli	Picture "@E 999,999.99"
	@Prow()  ,116 PSAY nTotGerCli	Picture "@E 99,999,999.99"
	
	@Prow()+1,001 PSAY __PrtThinLine()

	@Prow()+2,002 PSAY "TOTAL GERAL ------------>"
	@Prow()  ,049 PSAY nTotQtd	Picture "@E 99,999,999.99"
	@Prow()  ,065 PSAY nTotVM	Picture "@E 99,999,999.99"
	@Prow()  ,080 PSAY nTotSIpi	Picture "@E 99,999,999.99"
	@Prow()  ,103 PSAY nTotIpi	Picture "@E 999,999.99"
	@Prow()  ,116 PSAY nTotGer	Picture "@E 99,999,999.99"
		
ElseIf mv_par07 == 2                              //SE FOR RESUMO

	nDias := mv_par02 - mv_par01
	
	nX := 0
	
	While nX <= nDias
	
		TRA1->(DbGoTop())
		
		While TRA1->(!EoF())
		
			If TRA1->D2_EMISSAO == DtoS(mv_par01+nX)
			
				nFatSIpi += TRA1->TOTAL
				nFatCIpi += (TRA1->TOTAL + TRA1->D2_VALIPI)
				nDev	 += TRA1->D2_VALDEV
			
			EndIf
			
			TRA1->(DbSkip())
			nX++
		
		EndDO
		
		nAcuSIpi += nFatSIpi
		nAcuCIpi += nFatCIpi
		
		aAdd(aArr,{DtoC(mv_par01+nX),nFatSIpi,nAcuSIpi,nFatCIpi,nAcuCIpi,nDev})
		nFatSIpi := 0
		nFatCIpi := 0 
		nDev	 := 0
		
		nX++
		
	EndDo
	
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	@Prow()+1,002 PSAY "  DATA DE               FATURADO           ACUMULADO            FATURADO           ACUMULADO           VALOR DAS "
	@Prow()+1,002 PSAY "  EMISSAO                SEM IPI             SEM IPI             COM IPI             COM IPI          DEVOLUCOES "
	@Prow()+1,001 PSAY __PrtThinLine()
	@Prow()+1,001 PSAY " "
	
	For xD:=1 to Len(aArr)
	
		If Prow() > 50
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		EndIf
		
		@Prow()+1,002 PSAY aArr[xD][1]
		@Prow()  ,020 PSAY aArr[xD][2] Picture "@E 999,999,999.99" //14 CARACTERES
		@Prow()  ,040 PSAY aArr[xD][3] Picture "@E 999,999,999.99"
		@Prow()  ,060 PSAY aArr[xD][4] Picture "@E 999,999,999.99"
		@Prow()  ,080 PSAY aArr[xD][5] Picture "@E 999,999,999.99"
		@Prow()  ,100 PSAY aArr[xD][6] Picture "@E 999,999,999.99"
                     	
	Next

EndIf
	
	TRA1->(DbCloseArea())

Return

Static Function fGeraTxt()
Local xTxt
Local nIpi
Local nValCIpi

TRA1->(DbGoTop())

xTxt := fCreate("C:\RelFat.txt",0)

While TRA1->(!EoF())

	If SB1->(DbSeek(xFilial("SB1")+TRA1->D2_COD))
		
		nIpi := TRA1->TOTAL*(TRA1->D2_IPI/100)
		nValCIpi := ((TRA1->TOTAL) + (TRA1->TOTAL * (nIpi)))    
	
		fWrite(xTxt,TRA1->D2_COD+"	"+SB1->B1_DESC+"	"+Str(TRA1->QUANT,12)+"	"+Str(TRA1->TOTAL,12,2)+"	"+Str(TRA1->D2_IPI,5,2)+"	"+Str(nIpi,12,2)+"	"+Str(nValCIpi,12,2)+CHR(13)+CHR(10),200)
	
	EndIf
	
	TRA1->(DbSkip())
	
EndDO

fClose(xTxt)
MsgAlert("Relatório Gerado em: C:\RelFat.txt")

Return