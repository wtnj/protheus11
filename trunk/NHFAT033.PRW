#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPCP033  ºAutor  ³Felipe Ciconini     º Data ³  10/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de Débitos do Cliente                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHFAT033()


cString		:= "ZDM"
cDesc1		:= "Este relatorio tem como objetivo imprimir"
cDesc2		:= " os débitos dos fornecedores no intervalo"
cDesc3		:= " estipulado"
tamanho		:= "G"
limite		:= 132
aReturn		:= { "Zebrado", 1, "AdminisTRA1cao", 1, 2, 1, "", 1 }
nomeprog	:= "NHFAT033"
nLastKey	:= 0
titulo		:= OemToAnsi("DÉBITOS DO FORNECEDOR")                                                                                                                             
//cabec1	:= "  NOTA      SERIE  EMISSAO     QTD  COD PRODUTO    DESC PRODUTO                  TOTAL     COD CLI      RAZAO SOCIAL                     SOLICITANTE               C.CUSTO                VENCIMENTO  PAGAMENTO"
cabec2		:= ""
cabec1		:= "  NOTA       EMISSAO     QTD      COD PRODUTO    DESC PRODUTO                  TOTAL     COD FORNEC     SOLICITANTE            C.CUSTO          MOTIVO                                       NF ORIG        VENC"
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1
M_PAG		:= 1
wnrel		:= "NHFAT033"
_cPerg		:= "FAT033"

Pergunte (_cPerg,.F.)
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
    
	//††††††††††††††††††††††
	//†††MONTANDO A QUERY†††
	//††††††††††††††††††††††

	cQuery := "SELECT ZDM.ZDM_DOC, ZDM.ZDM_SERIE, SF2.F2_EMISSAO, SD2.D2_QUANT, SD2.D2_TOTAL, SD2.D2_COD, SB1.B1_DESC, SA1.A1_COD, SA1.A1_LOJA, "
	cQuery += " SA1.A1_NOME, ZDM.ZDM_SOLIC, ZDM.ZDM_MOTIVO, ZDM.ZDM_DOCORI, CTT.CTT_DESC01 " //SE2.E2_VENCTO, SE2.E2_BAIXA "
	cQuery += " FROM "+RetSqlName('ZDM')+" ZDM, "+RetSqlName('SA1')+" SA1, "+RetSqlName('SF2')+" SF2, "
	cQuery += " "+RetSqlName('SD2')+" SD2, "+RetSqlName('SB1')+" SB1, "/*+RetSqlName('SE2')+" SE2, "*/+RetSqlName('CTT')+" CTT "
	cQuery += " WHERE ZDM.ZDM_CLI 	= SA1.A1_COD "
	cQuery += " AND ZDM.ZDM_LOJCLI 	= SA1.A1_LOJA "
	cQuery += " AND SF2.F2_DOC 		= ZDM.ZDM_DOC "
	cQuery += " AND SF2.F2_SERIE 	= ZDM.ZDM_SERIE "
	cQuery += " AND SF2.F2_CLIENTE 	= ZDM.ZDM_CLI "
	cQuery += " AND SF2.F2_LOJA 	= ZDM.ZDM_LOJCLI "
	cQuery += " AND SF2.F2_DOC 		= SD2.D2_DOC "
	cQuery += " AND SF2.F2_SERIE 	= SD2.D2_SERIE "
	cQuery += " AND SF2.F2_CLIENTE 	= SD2.D2_CLIENTE "
	cQuery += " AND SF2.F2_LOJA 	= SD2.D2_LOJA "  
	cQuery += " AND SD2.D2_COD 		= SB1.B1_COD "
//	cQuery += " AND ZDM.ZDM_DOCORI 	= SE2.E2_NUM "
//	cQuery += " AND ZDM.ZDM_SERORI 	= SE2.E2_PREFIXO "
//	cQuery += " AND ZDM.ZDM_FORNEC 	= SE2.E2_FORNECE "
//	cQuery += " AND ZDM.ZDM_LOJFOR 	= SE2.E2_LOJA "
	cQuery += " AND ZDM.ZDM_CC 		= CTT.CTT_CUSTO "
	
	
	//Filtros Ini
	
	cQuery += " AND ZDM.ZDM_DOC 	BETWEEN 	'"+mv_par01+"'			AND '"+mv_par02+"'"	   		//Numero Nota
	cQuery += " AND ZDM.ZDM_SERIE 	BETWEEN 	'"+mv_par03+"' 			AND '"+mv_par04+"'"			//Numero Serie
	cQuery += " AND SF2.F2_EMISSAO 	BETWEEN 	'"+DtoS(mv_par05)+"' 	AND '"+DtoS(mv_par06)+"'"	//Data Emissao
	cQuery += " AND ZDM.ZDM_CLI 	BETWEEN 	'"+mv_par07+"' 			AND '"+mv_par09+"'"			//Cod Cliente
	cQuery += " AND ZDM.ZDM_LOJCLI 	BETWEEN 	'"+mv_par08+"' 			AND '"+mv_par10+"'"	   		//Loja Cliente
	cQuery += " AND ZDM.ZDM_CC 		BETWEEN		'"+mv_par11+"' 			AND '"+mv_par12+"'"	   		//Centro de Custo
	
	//Filtros Fim 
	
	cQuery += " AND ZDM.D_E_L_E_T_ = ' ' "
	cQuery += " AND SF2.D_E_L_E_T_ = ' ' "
	cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
//	cQuery += " AND SE2.D_E_L_E_T_ = ' ' "
	cQuery += " AND SD2.D_E_L_E_T_ = ' ' "
	cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " AND CTT.D_E_L_E_T_ = ' ' "
	
	cQuery += " AND ZDM.ZDM_FILIAL = '"+xFilial("ZDM")+"'"
	cQuery += " AND SF2.F2_FILIAL = '"+xFilial("SF2")+"'"
	cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
//	cQuery += " AND SE2.E2_FILIAL = '"+xFilial("SE2")+"'"
	cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery += " AND SD2.D2_FILIAL = '"+xFilial("SD2")+"'"
	cQuery += " AND CTT.CTT_FILIAL = '"+xFilial("CTT")+"'"
	cQuery += " ORDER BY SF2.F2_EMISSAO ASC "

	MemoWrit('C:\TEMP\NHFAT033.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TRA1"
	TRA1->(DbGoTop())
	TcSetField("TRA1","F2_EMISSAO","D")
//	TcSetField("TRA1","E2_VENCTO","D")
//	TcSetField("TRA1","E2_BAIXA","D")
	
Return

Static Function RptDetail()
Local nMesAtual := 0
Local _nLin     := 0
Local cMes
Local _nTotal	:= 0

	//†††††††††††††††††††††††††††
	//††††IMPRESSAO DOS DADOS††††
	//†††††††††††††††††††††††††††

Titulo	:= OemToAnsi("CONTROLE DE NOTAS DE DÉBITO")

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)


TRA1->(DbGoTop())
While TRA1->(!Eof())
       
    If Prow() > 60
  		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	EndIf
    
    If nMesAtual != MONTH(TRA1->F2_EMISSAO)
		    
		    cMes := OemToAnsi("Total do Mês de ")
		    cMes += MesExtenso(MONTH(TRA1->F2_EMISSAO))
		    cMes += " de "
		    cMes += StrZero(YEAR(TRA1->F2_EMISSAO),4)
		    nMesAtual := MONTH(TRA1->F2_EMISSAO)
			@Prow()+2,000 psay __PrtThinLine()
			@Prow()+1,001 psay Upper(cMes)
//			@Prow()  ,017 psay Upper(MesExtenso(MONTH(TRA1->F2_EMISSAO)))
//			@Prow()  ,026 psay "/"
//			@Prow()  ,027 psay YEAR(TRA1->F2_EMISSAO)
			@Prow()+1,000 psay __PrtThinLine()        

	EndIf
    
	@Prow()+1,001 psay TRA1->ZDM_DOC
//	@Prow()  ,013 psay TRA1->ZDM_SERIE  								//SERIE DA NOTA REMOVIDA POR SOLICITAÇÃO DO USUARIO
	@Prow()  ,013 psay TRA1->F2_EMISSAO
	@Prow()  ,026 psay TRA1->D2_QUANT
	@Prow()  ,034 psay TRA1->D2_COD
	@Prow()  ,049 psay SubStr(TRA1->B1_DESC,1,20)
	@Prow()  ,071 psay TRA1->D2_TOTAL Picture "@e 999,999,999.99"
	_nTotal += TRA1->D2_TOTAL
   	@Prow()  ,089 psay TRA1->A1_COD+"-"+TRA1->A1_LOJA 
//	@Prow()  ,104 psay SubStr(TRA1->A1_NOME,1,32)  					//RAZÃO SOCIAL REMOVIDA POR SOLICITAÇÃO DO USUARIO
	@Prow()	 ,104 psay SubStr(TRA1->ZDM_SOLIC,1,20)
	@Prow()  ,127 psay SubStr(TRA1->CTT_DESC01,1,15)
	
/*	@Prow()  ,186 psay DtoC(TRA1->E2_BAIXA)   						//Vencimento v.2
	@Prow()  ,198 psay DtoC(TRA1->E2_BAIXA)   						//Pagamento v.2
	@Prow()+1,001 psay "MOTIVO: "
	@Prow()  ,010 psay TRA1->ZDM_MOTIVO	   							//Motivo v.2 */
    
	_nLin := MlCount(AllTrim(TRA1->ZDM_MOTIVO),40)					//Motivo v.1
	For i:=1 to _nLin
		@Prow() + Iif(i==1,0,1)  ,144 psay MemoLine(TRA1->ZDM_MOTIVO,40,i)
		If i==1
			@Prow()  ,189 psay TRA1->ZDM_DOCORI
// 			@Prow()  ,203 psay DtoC(TRA1->E2_VENCTO)  				//Vencimento v.1
//	 		@Prow()  ,208 psay DtoC(TRA1->E2_BAIXA)   				//Pagamento v.1  DATA DE PAGAMENTO REMOVIDA POR SOLICITAÇÃO DO USUARIO 
		EndIf
	Next   


	
    TRA1->(DbSkip())

EndDo 
             			 	 	
@Prow()+1,000 PSAY __PrtThinLine()
@Prow()+1,001 PSAY "TOTAL:"
@Prow()  ,071 PSAY _nTotal Picture "@E 999,999,999.99"

TRA1->(DbCloseArea())

Return(nil)
