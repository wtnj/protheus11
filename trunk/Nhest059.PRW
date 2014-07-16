/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST059        ³ FABIO NICO            ³ Data ³ 29/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Inconsistencia de entradas                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padrao para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"
User Function NhEst059

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,nQtde")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,_CARQDBF,_AFIELDS,_NTGERAL")
SetPrvt("_NTPARCIAL,_CFORNECE,_CLOJA,_NTOTALF,_NAUX,_CNOMEF,lDivPed")
SetPrvt("_DDATA,_CARQNTX,_CORDEM,_NPER,_NPOS,_CCABEC1,M_PAG,_ca,_cb,_cc,cTipoNF")
SetPrvt("aAuxCombo1,aCombo1,cPedido,cINSP,cFornece,cSerie,cNF,cLoja,dDtDigi,_cNome")
SetPrvt("nBASEICM,nVALICM,nBRICMS,nICMSRET,nVALMERC,nDESCONT,nFRETE,nSEGURO,nDESPESA,nVALIPI,nVALBRUT")
SetPrvt("_cCodUsr")

cString   :="SD1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir os ")
cDesc2    := OemToAnsi("Itens que vieram na nota fiscal de Entrada e tambem acusar")
cDesc3    := OemToAnsi("as divergencias com o Pedido de Compras.")
tamanho   :="M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  :="NHEST059"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    :="Relatório de Diferença NF de Entrada" 
Cabec1    :="NF   SERIE    Cod.Produto   Descricao Produto             Quantidade     Cod.Fornece   Dt.Emissao"
cabec2    :=""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     :="NHEST059"          //Nome Default do relatorio em Disco
_cPerg    := "EST059"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)
nBASEICM :=	0
nVALICM  := 0
nBRICMS  :=	0
nICMSRET :=	0
nVALMERC :=	0
nDESCONT :=	0
nFRETE   :=	0
nSEGURO  :=	0
nDESPESA :=	0
nVALIPI  := 0
nVALBRUT := 0

dDtDigIni  := DATE()-30
dDtDigFim  := DATE()

// Parametros Utilizados
// mv_par01 = Data da digitacao Inicio
// mv_par02 = Data da Digitacao Fim


dbSelectArea("SX1")
dbSetOrder(1)
SX1->(DbSeek(_cPerg))
If Sx1->(Found())
	RecLock('SX1')
	SX1->X1_CNT01 := _cCodUsr
	MsUnLock('SX1')
Endif

                                                                                        
If !Pergunte(_cPerg,.T.) //ativa os parametros
	Return(nil)
Endif

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho) 
//SetPrint("SZ7",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")        


If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif
             
nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver 	:= ReadDriver()
cCompac 	:= aDriver[1]
cNormal 	:= aDriver[2] 
cFilterUser := aReturn[7]

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
TMP->(DbGoTop())
If Empty(TMP->D1_DOC)
   MsgBox("Nota Fiscal nao Encontrada","Atencao","STOP")
   DbSelectArea("TMP")
   DbCloseArea()
   Return
Endif

Processa( {|| RptDetail() },"Gerando Dados para a Impressao")
DbSelectArea("TMP")
DbCloseArea()

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function Gerando()    
	cQuery := " SELECT D1.D1_DOC,D1.D1_SERIE,D1.D1_EMISSAO,D1.D1_FORNECE,A2.A2_NOME,QEK.QEK_NTFISC,B1.B1_TIPO,"
	cQuery += " D1.D1_COD,B1.B1_DESC,D1.D1_QUANT,D1.D1_EMISSAO, QEP.QEP_ERRO "
    
    cQuery += " FROM " + RetSqlName('SD1') +" D1 (nolock) "

    cQuery += " INNER JOIN " +RetSqlName('SB1') +" B1 (NOLOCK) ON "
    cQuery += "		B1.B1_FILIAL = '"+xFilial("SB1")+"' " 
    cQuery += " AND B1.B1_COD    = D1.D1_COD "
    cQuery += " AND B1.B1_TIPO IN ('CC','MC','CP','MP') "
	cQuery += " AND B1.D_E_L_E_T_   = ' ' "                    

    cQuery += " INNER JOIN "+RetSqlName('SA2') +" A2 (NOLOCK) ON " 
	cQuery += "		A2.A2_FILIAL  = '"+xFilial("SA2")+"' "
	cQuery += " AND D1.D1_FORNECE = A2.A2_COD "
	cQuery += " AND D1.D1_LOJA    = A2.A2_LOJA "
	cQuery += " AND A2.D_E_L_E_T_ = '' "
        
    cQuery += " LEFT JOIN "+RetSqlName('QEK') +" QEK (NOLOCK) ON "
	cQuery += "		QEK.QEK_FILIAL  = D1.D1_FILIAL "
	cQuery += " AND D1.D1_SERIE     = QEK.QEK_SERINF "
	cQuery += " AND D1.D1_DOC       = QEK.QEK_NTFISC "
	cQuery += " AND D1.D1_COD       = QEK.QEK_PRODUT "
	cQuery += " AND QEK.QEK_NTFISC  = NULL "
	cQuery += " AND QEK.D_E_L_E_T_  = ' ' "

	cQuery += " LEFT JOIN "+ RetSqlName('QEP') +" QEP ON "
	cQuery += " 	QEP.QEP_FILIAL  = D1.D1_FILIAL "
	cQuery += " AND D1.D1_DOC       = QEP.QEP_NTFISC "
	cQuery += " AND D1.D1_FORNECE   = QEP.QEP_FORNEC "
	cQuery += " AND D1.D1_COD       = QEP.QEP_PRODUT "
	cQuery += " AND D1.D1_LOTECTL   = QEP.QEP_LOTE "
	cQuery += " AND QEP.D_E_L_E_T_ '' "

	cQuery += " WHERE D1.D1_EMISSAO BETWEEN '"  + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
	cQuery += " AND D1.D_E_L_E_T_   = ' ' "
	
	cQuery += "ORDER BY D1.D1_EMISSAO "

//TCQuery Abre uma workarea com o resultado da query            
    MemoWrit('C:\TEMP\NHEST059.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TMP"  

Return

Static Function RptDetail()
TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
While TMP->(!Eof())
   cInsp := Space(11)
   IncProc("Imprimindo divergencias de ENTRADA.. " + TMP->D1_DOC)
      
   If Prow() > 60
      _nPag := _nPag + 1
      Cabec1 := " "
      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
      @ Prow() + 1, 001 Psay "------------------------------------------------------- DADOS DA NOTA FISCAL -------------------------------------------------------"
      @ Prow() + 1, 001 Psay "NF   SERIE    Cod.Produto   Descricao Produto             Quantidade    Cod.Fornece  Dt.Emissao"
   Endif

                                            
	@ Prow() + 1, 001 Psay TMP->D1_DOC
	@ Prow()    , 008 Psay TMP->D1_SERIE 
	@ Prow()    , 012 Psay TMP->D1_COD  	
	@ Prow()    , 030 Psay TMP->B1_DESC
	@ Prow()    , 065 Psay TMP->D1_QUANT      Picture"@E 9999,999"
	@ Prow()    , 075 Psay TMP->D1_FORNECE
	@ Prow()    , 085 Psay STOD(TMP->D1_EMISSAO)    Picture"99/99/9999"
	if !empty(TMP->QEP_ERRO)
       @ Prow()+1  , 030 Psay TMP->QEP_ERRO
    endif
   
   TMP->(Dbskip())   
EndDo
      
Return(nil)      
  
