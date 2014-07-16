 #INCLUDE "TOPCONN.CH"
 #INCLUDE "RWMAKE.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPCP032  ºAutor  ³FELIPE CICONINI     º Data ³  23/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³RELATORIO DE ENVIO DE PEÇAS PARA RETRABALHO                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PLANEJAMENTO E CONTROLE DA PRODUCAO                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

   _____________________________
  |                             |
  |        ~>Perguntas~<        |
  | --------------------------- |
  | * mv_par01 - De Data ?      |
  | * mv_par02 - Ate Data ?     |
  | * mv_par03 - De Produto ?   |
  | * mv_par04 - Ate Produto ?  |
  | * mv_par05 - De Grupo ?     |
  | * mv_par06 - Ate Grupo ?    |
  | * mv_par07 - Saldo Zerado ? |
  |_____________________________|	

*/

User Function NHPCP032()

cString		:= "ZDH"
cDesc1		:= "Este relatorio tem como objetivo Imprimir o Envio e Retorno de Peças para Retrabalho"
cDesc2      := ""
cDesc3      := ""      
tamanho		:= "M"
limite		:= 132
aReturn		:= { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHPCP032"
nLastKey	:= 0
titulo		:= OemToAnsi("CONTROLE DE PEÇAS PARA RETRABALHO")
cabec1    	:= ""
cabec2		:= ""
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1 //Variavel da pagina
M_PAG		:= 1
wnrel		:= "NHPCP032"
_cPerg		:= "PCP032"

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
        
    If SELECT('TRA1') > 0
    	TRA1->(dbclosearea())
    Endif
    
    //##################################
    //#########MONTANDO#A#QUERY#########
    //##################################
    
	cQuery := "SELECT ZDG.ZDG_NUM,SB1.B1_DESC, ZDG_DATA, ZDH_PROD, SUM(ZDH_QUANT) ENV,  "
 	cQuery += "		(SELECT SUM(ZDH2.ZDH_QUANT) "
 	cQuery += "		FROM ZDHFN0 ZDH2 "
 	cQuery += "		WHERE 	ZDH1.ZDH_NUM	= ZDH2.ZDH_NUM "
	cQuery += "		AND 	ZDH2.ZDH_TM		= 'D' "
	cQuery += "		AND 	ZDH2.ZDH_PROD   = ZDH1.ZDH_PROD "
	cQuery += "		AND 	ZDH2.D_E_L_E_T_ = ' ' "
 	cQuery += "		) DEV "
	cQuery += "FROM "+RetSqlName('ZDH')+" ZDH1, "+RetSqlName('ZDG')+" ZDG, "+RetSqlName('SB1')+" SB1 "
	cQuery += "WHERE   		ZDG_NUM 		= ZDH_NUM "
	cQuery += " AND	   		SB1.B1_COD		= ZDH1.ZDH_PROD "
	cQuery += " AND 		ZDH_PROD		BETWEEN '"+mv_par03+"' 			AND '"+mv_par04+"'"
	cQuery += " AND 		ZDG_DATA		BETWEEN '"+DtoS(mv_par01)+"' 	AND '"+DtoS(mv_par02)+"'"
	cQuery += " AND 		ZDG_TM 			= ZDH_TM "
	cQuery += " AND			SB1.B1_GRUPO	BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cQuery += " AND 		ZDG_NUMSEQ 		= ZDH_NUMSEQ "
	cQuery += " AND 		ZDG_TM 			= 'E' "
	cQuery += " AND 		ZDG.D_E_L_E_T_ 	= ' ' "
	cQuery += " AND 		ZDH1.D_E_L_E_T_ = ' ' "
	cQuery += " AND 		ZDH1.ZDH_FILIAL = '"+xFilial('ZDH')+"'"
	cQuery += " AND 		ZDG.ZDG_FILIAL 	= '"+xFilial('ZDG')+"'"
	cQuery += " GROUP BY 	ZDG_NUM ,ZDH_NUM, ZDG_DATA,  ZDH_PROD, B1_DESC "
	cQuery += " ORDER BY 	ZDG_DATA "

//	MemoWrit('C:\TEMP\NHPCP032.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TRA1"
	TRA1->(DbGoTop())
	TcSetField("TRA1","ZDG_DATA","D")
	
Return

Static Function RptDetail()
Local dData
Local aMat		:= {}
Local nPos
Local nSaldo

	ProcRegua(0)

	Titulo := "SALDO RETRABALHO USINAGEM"
	Cabec1 := OemToAnsi("PEÇA                              DESCRIÇÃO                                 ENVIO        RETORNO           SALDO")
	
	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	
	While TRA1->(!EoF())
	
		IncProc()
	
		If Prow() > 65
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
		EndIf
	    
		dData := TRA1->ZDG_DATA
		cNumT := TRA1->ZDG_NUM
		
		aMatItens := {}
		
		While dData == TRA1->ZDG_DATA .AND. TRA1->ZDG_NUM==cNumT

			nSaldo := TRA1->ENV - TRA1->DEV         //CALCULO DO SALDO TOTAL DO ITEM

			If nSaldo==0 .and. mv_par07==2
				TRA1->(dbSkip())
				Loop
			Endif
			
			aAdd(aMatItens,{TRA1->ZDH_PROD, TRA1->B1_DESC,TRA1->ENV,TRA1->DEV,nSaldo})
			
			nPos := aScan(aMat,{|x| x[1] == TRA1->ZDH_PROD})
			If nPos == 0
				aAdd(aMat,{TRA1->ZDH_PROD,TRA1->ENV - TRA1->DEV})
			Else
				aMat[nPos][2] += nSaldo
			EndIf

			TRA1->(DbSkip())
			
		EndDo
		
		If Len(aMatItens) > 0
			@Prow()+2,001 psay "DATA: "+DtoC(dData) + "      Nº Transf: " + cNumT
			For xI:=1 to Len(aMatItens)
				@Prow()+1,001 psay aMatItens[xI][1]
				@Prow()  ,034 psay aMatItens[xI][2]
				@Prow()  ,076 psay aMatItens[xI][3] Picture "@E 99999"
				@Prow()  ,090 psay aMatItens[xI][4] Picture "@E 99999"
				@Prow()  ,107 psay aMatItens[xI][5] Picture "@E 99999"
			Next
		Endif
		

 	EndDo
 	
	Cabec1 := OemToAnsi("          PEÇA                              DESCRIÇÃO                                                      SALDO")
 	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
 	
 	For xN := 1 to len(aMat)
 		If aMat[xN][2] <> 0
 			@Prow()+1,010 psay aMat[xN][1]
 			@Prow()  ,044 psay Posicione("SB1",1,xFilial("SB1")+aMat[xN][1],"B1_DESC")
 			@Prow()  ,107 psay aMat[xN][2]
 		EndIf
 	Next
	
	TRA1->(DbCloseArea())
	
Return