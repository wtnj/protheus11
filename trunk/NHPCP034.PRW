#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPCP034  ºAutor  ³Felipe Ciconini     º Data ³  22/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de Calculo de Prejuizo                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Planjamento e Controle da Produção                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHPCP034()
Private nPrim := 0

cString		:= "ZDU"
cDesc1		:= "Este relatorio tem como objetivo imprimir"
cDesc2		:= "o Cálculo de Prejuízo do Alerta de Criticidade"
cDesc3		:= " ou Alerta de Parada de Linha"
tamanho		:= "M"
limite		:= 132
aReturn		:= { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHPCP034"
nLastKey	:= 0
titulo		:= OemToAnsi("CÁLCULO DE PREJUÍZO")
cabec1		:= " "
cabec2		:= " "
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1
M_PAG		:= 1
wnrel		:= "NHPCP034"
_cPerg		:= ""

Pergunte(_cPerg,.T.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

If nLastKey == 27
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)

nTipo		:= IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))

aDriver		:= ReadDriver()
cCompac		:= aDriver[1]

Processa({|| fGrvDdos() },"Gravando Dados no Banco")
Processa({|| Gerando()  },"Imprimindo...")

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
	
	cQuery := "SELECT ZDV_NUM, ZDV_ITEM, ZDV_PROD, B1_DESC, ZDU_STATUS"
	cQuery += " FROM "+RetSqlName("ZDV")+" ZDV, "+RetSqlName("SB1")+" B1, "+RetSqlName("ZDU")+" ZDU"
	cQuery += " WHERE ZDV_NUM = "+_cNum
	cQuery += " AND ZDV_PROD = B1_COD"
	cQuery += " AND ZDU_NUM  = ZDV_NUM"
	
	cQuery += " AND ZDV.D_E_L_E_T_ = ' '"
	cQuery += " AND B1.D_E_L_E_T_  = ' '"
	cQUery += " AND ZDU.D_E_L_E_T_ = ' '"
	
	cQuery += " AND ZDV_FILIAL = '"+xFilial("ZDV")+"'"
	cQuery += " AND B1_FILIAL  = '"+xFilial("SB1")+"'"
	cQuery += " AND ZDU_FILIAL = '"+xFilial("ZDU")+"'"
	
	TCQUERY cQuery NEW ALIAS 'TMP1'
	
	
	
	cabec1 := "CÁLCULO DE PREJUÍZO REFERENTE A "+_cTipoAl+" Nº "+_cNum
	cabec2 := ""
	
	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	
	@Prow()+1,030 PSAY OemToAnsi("Tipo da Ocorrência:")
	@Prow()  ,065 PSAY Upper(_cTipo)
	@Prow()+3,010 PSAY "Debitar o Fornecedor/Cliente devido à quebra na cadeia produtiva conforme informações complementares abaixo:"
	@Prow()+3,030 PSAY OemToAnsi("Nº Débito:")
	@Prow()  ,065 PSAY _nDeb
	@Prow()+3,030 PSAY OemToAnsi("Início da Ocorrência:")
	@Prow()  ,065 PSAY _cIniOc
	@Prow()  ,075 PSAY " - "+_cHorIni+"hs"
	@Prow()+3,030 PSAY OemToAnsi("Fim da Ocorrência:")
	@Prow()  ,065 PSAY _cFimOc
	@Prow()  ,075 PSAY " - "+_cHorFim+"hs"
	@Prow()+3,030 PSAY OemToAnsi("Total de Horas:")
	TotHor := (_cFimOc - _cIniOc) * 24  
	TotMin := HoraToInt(_cHorIni) - HoraToInt(_cHorFim)
	@Prow()  ,065 PSAY   IntToHora(TotHor - TotMin) 
	@Prow()+3,030 PSAY OemToAnsi("Responsável:")
	@Prow()  ,065 PSAY _cResp
	@Prow()+3,030 PSAY OemToAnsi("Fornecedor/Cliente:")
	@Prow()  ,065 PSAY _cFornec+" - "+_cForDesc
	@Prow()+3,030 PSAY OemToAnsi("Operações Envolvidas:")
	@Prow()  ,065 PSAY _cOper
	@Prow()+3,030 PSAY OemToAnsi("Descrição do Problema:")
	
	_nLin := MlCount(AllTrim(_cDesc),50)					//Função de quebra de linhas
	For i:=1 to _nLin
		@Prow() + Iif(i==1,0,1)  ,065 PSAY Upper(MemoLine(_cDesc,50,i))
	Next   
    
	//impressao dos itens
	@Prow()+3,030 PSAY "Relação dos Itens Envolvidos"
	@Prow()+1,035 PSAY "Item  Codigo              Descrição"
	While TMP1->(!EoF())
	
		@Prow()+1,035 PSAY TMP1->ZDV_ITEM
		@Prow()  ,041 PSAY TMP1->ZDV_PROD
		@Prow()  ,061 PSAY TMP1->B1_DESC
	    
		TMP1->(DbSkip())
	
	EndDo
	
	@Prow()+3,000 PSAY __PrtThinLine()

    @Prow()+9,005 PSAY "____________________________________________________"
    @Prow()  ,085 PSAY "__________________________________________"
    @Prow()+1,005 PSAY "Produção"
    @Prow()  ,085 PSAY "Logística"
    @Prow()+1,005 PSAY "Marcelo Reis de Oliveira - Diretor Geral de Manufatura"
    @Prow()  ,085 PSAY "Ivanildo Beniciuti - Gerente de Logística"
    @Prow()+3,000 PSAY __PrtThinLine()
    
    
    
    //impressao dos endereços WHB
	@Prow()+1,005 psay "WHB Fundição"
	@Prow()  ,115 psay "WHB Usinagem"
	@Prow()+1,005 psay "Rua Wiegando Olsen, 1600 - CIC"
	@Prow()  ,097 psay "Rua Wiegando Olsen, 1000 - CIC"
	@Prow()+1,005 psay "Curitiba - PR - Brasil - CEP 81460-070"
	@Prow()  ,089 psay "Curitiba - PR - Brasil - CEP 81460-070"
	@Prow()+1,005 psay "Fone:(41)3341-1800   Fax:(41)3348-3641" 
	@Prow()  ,089 psay "Fone:(41)3341-1900   Fax:(41)3348-3605"   
	
	TMP1->(DbCloseArea())

Return


Static Function fGrvDdos()
Local cStatus


If ZDU->ZDU_STATUS <> "N"
	nPrim := 1
	alert("alo")
EndIf

    cStatus := Posicione("ZDU",1,xFilial("ZDU")+_cNum,"ZDU_STATUS")
    If cStatus <> "N"
		RecLock("ZDZ",.T.)
		    ZDZ->ZDZ_NUM	:= _cNum
		    ZDZ->ZDZ_DEB	:= _nDeb
		    ZDZ->ZDZ_TIPO   := Upper(_cTipo)
		    ZDZ->ZDZ_DTAINI := _cIniOc
		    ZDZ->ZDZ_DTAFIM := _cFimOc
		    ZDZ->ZDZ_HORINI := _cHorIni
		    ZDZ->ZDZ_HORFIM := _cHorFim
		    ZDZ->ZDZ_OPS    := _cOper
		    ZDZ->ZDZ_DESCPR := Upper(_cDesc)
		    ZDZ->ZDZ_FILIAL := xFilial("ZDU")
		MsUnLock("ZDZ")
	
		If ZDU->(DbSeek(xFilial("ZDU")+_cNum))
			RecLock("ZDU",.F.)
				ZDU->ZDU_STATUS := "N"
			MsUnlock("ZDU")
		EndIf
	Else
		RecLock("ZDZ",.F.)
			ZDZ->ZDZ_DTAINI := _cIniOc
			ZDZ->ZDZ_DTAFIM := _cFimOc
			ZDZ->ZDZ_HORINI := _cHorIni
			ZDZ->ZDZ_HORFIM	:= _cHorFim
		MsUnlock("ZDZ")
	EndIf
	

Return
