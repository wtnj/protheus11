#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/09/01

User Function matrgia()        // incluido pelo assistente de conversao do AP5 IDE em 25/09/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TAMANHO,TITULO,CDESC1,CDESC2,CDESC3,ARETURN")
SetPrvt("LIMITE,NOMEPROG,NLASTKEY,CPERG,ADRIVER,ALAY")
SetPrvt("NLIN,NCNTFOR,NFOLHA,NTIPO,M_PAG,CSTRING")
SetPrvt("CABEC1,CABEC2,NPAGINA,LEND,AREGISTROS,ACAMPOS")
SetPrvt("CARQTEMP,CMES,CANO,AGIA,CLINHA,ACONTEUDO")
SetPrvt("AAREA,CARQGIA,_NI,DDTINI,DDTFIM,_NCPO_051")
SetPrvt("_NCPO_052,_NCPO_053,_NCPO_054,_NCPO_055,_NCPO_056,_NCPO_057")
SetPrvt("_NCPO_058,_NCPO_059,_NCPO_061,_NCPO_062,_NCPO_063,_NCPO_064")
SetPrvt("_NCPO_065,_NCPO_066,_NCPO_067,_NCPO_068,_NCPO_069,CPO_090")
SetPrvt("AARQAPUR,NPERAPURADO,CNRLIVRO,NPERIODO,CCAMPO,CVALOR")
SetPrvt("NVALOR,CTEXTO,LRET,I,J,WNREL")
SetPrvt("_CARQUIVO,_NOUTFILE,CCONTEUDO,_NSALCRED,_CREG,_NIMPREC")
SetPrvt("CARQAPUR,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MATRGIAP  ³ Autor ³ Andreia dos Santos    ³ Data ³ 02.10.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Emiss„o da Gia para o Estado do Parana. Emite a GIA de acordo±±
±±³          ³com a configuracao do arquivo GIA.CFG                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³MATRGIA(void)                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
tamanho	:=	"G"
titulo	:=	"GUIA DE INFORMACAO E APURACAO DO ICMS"
cDesc1	:=	"Guia de Informacao e Apuracao do ICMS ( GIA/ICMS )"
cDesc2	:=	"Secretaria de Estado da Fazenda"
cDesc3	:=	""
aReturn 	:= { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 } //
Limite 	:= 	132
nomeprog	:=	"MATRGIA"
nLastKey	:=	0
cPerg   	:=	"MTRGIA"
aDriver 	:=	ReadDriver()
aLay		:= array(65)
nLin		:= 80
nCntFor	:= 0
nFolha	:= 0
nTipo		:=	18
m_pag		:=1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cString  :=	"SF3"
cabec1   := ""
cabec2   := ""      
nPagina	:=	1          
lEND		:= .F.
aRegistros:= {}
aCampos	:= {}
cArqTemp	:= ""
cMes		:= ""
cAno		:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas na leitura do arquivo ini               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aGIA	:= {}
cLinha 	:= ""
aConteudo:= {}
aArea		:= GetArea()
cArqGIA	:= ""
_nI		:= 0 
dDtIni	:= ""
dDtFim	:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis que armazenam os campos do resumo da apuracao      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nCPO_051	:=	0
_nCPO_052	:=	0
_nCPO_053	:=	0
_nCPO_054	:=	0
_nCPO_055	:=	0
_nCPO_056	:=	0
_nCPO_057	:=	0
_nCPO_058	:=	0
_nCPO_059	:=	0

_nCPO_061	:=	0
_nCPO_062	:=	0
_nCPO_063	:=	0
_nCPO_064	:=	0
_nCPO_065	:=	0
_nCPO_066	:=	0
_nCPO_067	:=	0
_nCPO_068	:=	0
_nCPO_069	:=	0
CPO_090     :=  0

aArqApur:={}
nPerApurado := 1
cNrLivro	:= "*"
nPeriodo	:= 0
cLinha	:= ""
cCampo	:= ""
cValor	:= ""
nValor	:= 0
cTexto	:= ""
acampos	:= {}
lRet		:= .t.              
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria as perguntas se nao existirem                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//5.07
//aadd(aRegistros,{"MTRGIA","01","Mes de apuracao   ?","mv_ch1","N",02,0,0,"G","","mv_par01","","01","","","","","","","","","","","","",""})
//aadd(aRegistros,{"MTRGIA","02","Ano de apuracao   ?","mv_ch2","N",04,0,0,"G","","mv_par02","","2000","","","","","","","","","","","","",""})
//aadd(aRegistros,{"MTRGIA","03","Arq. Configuracao ?","mv_ch3","C",08,0,0,"G","","mv_par03","","GIA","","","","","","","","","","","","",""})
//aadd(aRegistros,{"MTRGIA","04","Despesas do Mes   ?","mv_ch4","N",14,2,0,"G","","mv_par04","","","","","","","","","","","","","","","",""})
//aadd(aRegistros,{"MTRGIA","05","Produtos Primarios?","mv_ch5","N",14,2,0,"G","","mv_par05","","","","","","","","","","","","","","","",""})
//aadd(aRegistros,{"MTRGIA","06","Receita Servicos  ?","mv_ch6","N",14,2,0,"G","","mv_par06","","","","","","","","","","","","","","","",""})
//aadd(aRegistros,{"MTRGIA","07","Estoque           ?","mv_ch7","N",14,2,0,"G","","mv_par07","","","","","","","","","","","","","","","",""})
//aadd(aRegistros,{"MTRGIA","08","Nº de Funcionarios?","mv_ch8","N",05,0,0,"G","","mv_par08","","","","","","","","","","","","","","","",""})
//aadd(aRegistros,{"MTRGIA","09","Valor Salarios    ?","mv_ch9","N",14,2,0,"G","","mv_par09","","","","","","","","","","","","","","","",""})
//aadd(aRegistros,{"MTRGIA","10","Tipo da Gia       ?","mv_ch10","C",02,0,0,"G","","mv_par10","","","","","","","","","","","","","","","",""})
//aadd(aRegistros,{"MTRGIA","11","CRC Contador      ?","mv_ch11","C",10,0,0,"G","","mv_par11","","","","","","","","","","","","","","","",""})

//6.09
aadd(aRegistros,{"MTRGIA","01","Mes de apuracao   ?","Mes de apuracao   ?","Mes de apuracao   ?","mv_ch1" ,"N",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{"MTRGIA","02","Ano de apuracao   ?","Ano de apuracao   ?","Ano de apuracao   ?","mv_ch2" ,"N",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{"MTRGIA","03","Arq. Configuracao ?","Arq. Configuracao ?","Arq. Configuracao ?","mv_ch3" ,"C",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{"MTRGIA","04","Despesas do Mes   ?","Despesas do Mes   ?","Despesas do Mes   ?","mv_ch4" ,"N",14,2,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{"MTRGIA","05","Produtos Primarios?","Produtos Primarios?","Produtos Primarios?","mv_ch5" ,"N",14,2,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{"MTRGIA","06","Receita Servicos  ?","Receita Servicos  ?","Receita Servicos  ?","mv_ch6" ,"N",14,2,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{"MTRGIA","07","Estoque           ?","Estoque           ?","Estoque           ?","mv_ch7" ,"N",14,2,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{"MTRGIA","08","Nº de Funcionarios?","Nº de Funcionarios?","Nº de Funcionarios?","mv_ch8" ,"N",14,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{"MTRGIA","09","Valor Salarios    ?","Valor Salarios    ?","Valor Salarios    ?","mv_ch9" ,"N",14,2,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{"MTRGIA","10","Tipo da Gia       ?","Tipo da Gia       ?","Tipo da Gia       ?","mv_ch10","C",02,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{"MTRGIA","11","CRC Contador      ?","CRC Contador      ?","CRC Contador      ?","mv_ch11","C",10,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

dbSelectArea("SX1")
For i:=1 to Len(aRegistros)
	If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegistros[i,j])
		Next
		MsUnlock()
	EndIf
Next
dbSelectArea("SF3")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Mes de apuracao    ?                 ³
//³ mv_par02             // Ano de Apuracao    ?                 ³
//³ mv_par03             // Arquivo de Configuracao?             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:="MATRGIA"   // nome default do relatorio em disco
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Return
Endif
cArqGIA	:= alltrim(mv_par03)+".ini"

ReadGIA()
if !lRet
   RETURN
Endif    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFNDEF WINDOWS
	RGIAPR(.F.,wnRel,cString,Tamanho)
#ELSE
        RptStatus({|| RGIAPR()})// Substituido pelo assistente de conversao do AP5 IDE em 25/09/01 ==>         RptStatus({|| Execute(RGIAPR)})
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura Ambiente                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF3")
dbSetOrder(1)
#IFNDEF WINDOWS
	Set Device To Screen
#ENDIF
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RGIAPR    ³ Autor ³ Andreia dos Santos    ³ Data ³02/10/00  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao da GIA                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATRGIA                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/09/01 ==> Function RGIAPR
Static Function RGIAPR()

LayGIA()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo para armazenar apuracoes   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{"CPO_MES"		,"C"	,02	,0	})
AADD(aCampos,{"CPO_ANO"		,"C"	,04	,0	})
AADD(aCampos,{"CPO_001"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_002"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_003"		,"N"	,05	,0	})
AADD(aCampos,{"CPO_004"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_005"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_006"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_007"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_008"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_009"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_010"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_011"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_012"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_013"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_014"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_015"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_016"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_017"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_018"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_019"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_020"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_021"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_022"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_023"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_024"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_025"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_026"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_027"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_028"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_029"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_030"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_031"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_032"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_033"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_034"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_035"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_036"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_037"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_038"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_039"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_040"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_041"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_042"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_043"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_044"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_045"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_046"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_047"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_048"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_049"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_050"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_051"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_052"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_053"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_054"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_055"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_056"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_057"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_058"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_059"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_060"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_061"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_062"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_063"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_064"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_065"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_066"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_067"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_068"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_069"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_070"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_080"		,"N"	,14	,2	})
AADD(aCampos,{"CPO_090"		,"N"	,14	,2	})

cArqTemp	:=	CriaTrab(aCampos)
dbUseArea(.T.,,cArqTemp,cArqTemp,.T.,.F.)
IndRegua(cArqTemp,cArqTemp,"CPO_MES+CPO_ANO",,,"Indexando Dados")

//ARQUIVO MAGNETICO DA GIA-ICMS PARANA - OSMAR

//layout do arquivo texto-Exportacao DA GIA-ICMS PARANA (REGISTRO TIPO 1)
//TIPO DE REGISTRO  INSCRICAO CAD.ICMS  DATA  REFERENCIA  TIPO DA GIA  CRC CONTABILISTA   ESTOQUE         FUNCIONARIOS  FOLHA PAGTO      QTDE LINHAS  
//1                 1019550440          199603            51           RR00000103         000000000150000 00010         000000000010000  30

//layout do arquivo texto-Exportacao DA GIA-ICMS PARANA (REGISTRO TIPO 2)
//TIPO DE REGISTRO  INSCRICAO CAD.ICMS  DATA  REFERENCIA  TIPO DA GIA  NR.DA LINHA  
//2                 1019550440          199603            51           ??

_cArquivo:="c:\temp\GIA"+SM0->M0_CODIGO+SM0->M0_CODFIL+".TXT"

_nOutFile:= Fcreate(_cArquivo,0) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculando as movimentacoes do SF3                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMes		:=	""
cAno		:=	""   
dDtini	:=	CTOD("01/"+StrZero(MV_PAR01,2)+"/"+substr(strzero(MV_PAR02,4),3,2))
dDtFim	:=	UltimoDia(dDtIni)

dbSelectArea("SF3")
dbSetOrder(1)
dbSeek(xFilial("SF3")+Dtos(dDtini),.T.)
SetRegua(LastRec())
While ( !Eof() .And. xFilial("SF3") == F3_FILIAL .And.;
							dDtIni	<= F3_ENTRADA.And.;
							dDtFim	>= F3_ENTRADA )
   cMes	:= strzero(month(F3_ENTRADA),2)
   cAno	:= strzero(year(F3_ENTRADA),4)
   
	DbSelectArea( cArqTemp )
	if !dbSeek(cMes+cAno)
		RECLOCK(cArqTemp,.T.)
		Replace CPO_MES With cMes
		Replace CPO_ANO With cAno
	Else
		RECLOCK(cArqTemp,.F.)
	EndIf                                        
		
	For _nI	:= 1 to len(aGIA)
		if aGIA[_nI,2]=="N"                                               
			cConteudo:=	aGIA[_nI,5] 	                        
		    If CPO_001==0
		       Replace CPO_001 With  CPO_001	+	if(aGIA[_nI,1]=="CPO_001",&cConteudo,0)
			Endif
			If CPO_002==0
			   Replace CPO_002 With  CPO_002   +   if(aGIA[_nI,1]=="CPO_002",&cConteudo,0)
			Endif
			If CPO_003==0   
			   Replace CPO_003 With  CPO_003	+	if(aGIA[_nI,1]=="CPO_003",&cConteudo,0)
			Endif
			If CPO_004==0   
			   Replace CPO_004 With  CPO_004	+	if(aGIA[_nI,1]=="CPO_004",&cConteudo,0)
			Endif
			If CPO_005==0   
			   Replace CPO_005	With CPO_005	+	if(aGIA[_nI,1]=="CPO_005",&cConteudo,0)
			Endif
			If CPO_006==0   
			   Replace CPO_006	With  CPO_006	+	if(aGIA[_nI,1]=="CPO_006",&cConteudo,0)
			Endif   
			Replace CPO_010	With  (CPO_002+CPO_004+CPO_006)
	
			Replace CPO_011	With  CPO_011	+	if(aGIA[_nI,1]=="CPO_011",&cConteudo,0)
			Replace CPO_013	With  CPO_013	+	if(aGIA[_nI,1]=="CPO_013",&cConteudo,0)
			Replace CPO_014	With  CPO_014	+	if(aGIA[_nI,1]=="CPO_014",&cConteudo,0)
			Replace CPO_015	With  CPO_015	+	if(aGIA[_nI,1]=="CPO_015",&cConteudo,0)
			Replace CPO_016	With  CPO_016	+	if(aGIA[_nI,1]=="CPO_016",&cConteudo,0)
			Replace CPO_017	With  CPO_017	+	if(aGIA[_nI,1]=="CPO_017",&cConteudo,0)
			Replace CPO_018	With  CPO_018	+	if(aGIA[_nI,1]=="CPO_018",&cConteudo,0)
			Replace CPO_019	With  CPO_019	+	if(aGIA[_nI,1]=="CPO_019",&cConteudo,0)
			Replace CPO_020	With  (CPO_011+CPO_013+CPO_014+CPO_015+CPO_016+CPO_017+CPO_018+CPO_019)//TOTAL

			Replace CPO_021	With  CPO_021	+	if(aGIA[_nI,1]=="CPO_021",&cConteudo,0)
			Replace CPO_023	With  CPO_023	+	if(aGIA[_nI,1]=="CPO_023",&cConteudo,0)
			Replace CPO_024	With  CPO_024	+	if(aGIA[_nI,1]=="CPO_024",&cConteudo,0)
			Replace CPO_025	With  CPO_025	+	if(aGIA[_nI,1]=="CPO_025",&cConteudo,0)
			Replace CPO_026	With  CPO_026	+	if(aGIA[_nI,1]=="CPO_026",&cConteudo,0)
			Replace CPO_027	With  CPO_027	+	if(aGIA[_nI,1]=="CPO_027",&cConteudo,0)
			Replace CPO_028	With  CPO_028	+	if(aGIA[_nI,1]=="CPO_028",&cConteudo,0)
			Replace CPO_029	With  CPO_029	+	if(aGIA[_nI,1]=="CPO_029",&cConteudo,0)
			Replace CPO_030	With  (CPO_021+CPO_023+CPO_024+CPO_025+CPO_026+CPO_027+CPO_028+CPO_029)//TOTAL
		
			Replace CPO_031	With  CPO_031	+	if(aGIA[_nI,1]=="CPO_031",&cConteudo,0)
			Replace CPO_033	With  CPO_033	+	if(aGIA[_nI,1]=="CPO_033",&cConteudo,0)
			Replace CPO_034	With  CPO_034	+	if(aGIA[_nI,1]=="CPO_034",&cConteudo,0)
			Replace CPO_035	With  CPO_035	+	if(aGIA[_nI,1]=="CPO_035",&cConteudo,0)
			Replace CPO_036	With  CPO_036	+	if(aGIA[_nI,1]=="CPO_036",&cConteudo,0)
			Replace CPO_039	With  CPO_039	+	if(aGIA[_nI,1]=="CPO_039",&cConteudo,0)
			Replace CPO_040	With  (CPO_031+CPO_033+CPO_034+CPO_035+CPO_036+CPO_039)//TOTAL

			Replace CPO_041	With  CPO_041	+	if(aGIA[_nI,1]=="CPO_041",&cConteudo,0)
			Replace CPO_043	With  CPO_043	+	if(aGIA[_nI,1]=="CPO_043",&cConteudo,0)
			Replace CPO_044	With  CPO_044	+	if(aGIA[_nI,1]=="CPO_044",&cConteudo,0)
			Replace CPO_045	With  CPO_045	+	if(aGIA[_nI,1]=="CPO_045",&cConteudo,0)
			Replace CPO_046	With  CPO_046	+	if(aGIA[_nI,1]=="CPO_046",&cConteudo,0)
			Replace CPO_049	With  CPO_049	+	if(aGIA[_nI,1]=="CPO_049",&cConteudo,0)
			Replace CPO_050	With  (CPO_041+CPO_043+CPO_044+CPO_045+CPO_046+CPO_049)//TOTAL		EndIf	
		Endif
	Next
	MsUnlock()
	dbSelectArea("SF3")
	dbSkip()
	IncRegua()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                RESUMO DA APURACAO DO IMPOSTO                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GIAAPUR()

dbSelectArea(cArqTemp)
if dbSeek(cMes+cAno)
	RECLOCK(cArqTemp,.F.)
	For _nI	:= 1 to len(aGIA)
		if aGIA[_nI,2]=="N"                                               
			cConteudo:=	aGIA[_nI,5] 	
			Replace CPO_051	With  CPO_051	+if(aGIA[_nI,1]=="CPO_051",&cConteudo,0)
			Replace CPO_052	With  CPO_052	+if(aGIA[_nI,1]=="CPO_052",&cConteudo,0)
			Replace CPO_053	With  CPO_053	+if(aGIA[_nI,1]=="CPO_053",&cConteudo,0)
			Replace CPO_054	With  CPO_054	+if(aGIA[_nI,1]=="CPO_054",&cConteudo,0)
			Replace CPO_055	With  CPO_055	+if(aGIA[_nI,1]=="CPO_055",&cConteudo,0)
			Replace CPO_056	With  CPO_056	+if(aGIA[_nI,1]=="CPO_056",&cConteudo,0)
			Replace CPO_057	With  CPO_057	+if(aGIA[_nI,1]=="CPO_057",&cConteudo,0)
			Replace CPO_058	With  CPO_058	+if(aGIA[_nI,1]=="CPO_058",&cConteudo,0)
			Replace CPO_059	With  CPO_059	+if(aGIA[_nI,1]=="CPO_059",&cConteudo,0)
			Replace CPO_060	With  (CPO_051+CPO_052+CPO_053+CPO_054+CPO_055+CPO_056+CPO_057+CPO_058+CPO_059)//TOTAL

			Replace CPO_061	With  CPO_061	+if(aGIA[_nI,1]=="CPO_061",&cConteudo,0)
			Replace CPO_062	With  CPO_062	+if(aGIA[_nI,1]=="CPO_062",&cConteudo,0)
			Replace CPO_063	With  CPO_063	+if(aGIA[_nI,1]=="CPO_063",&cConteudo,0)
			Replace CPO_064	With  CPO_064	+if(aGIA[_nI,1]=="CPO_064",&cConteudo,0)
			Replace CPO_065	With  CPO_065	+if(aGIA[_nI,1]=="CPO_065",&cConteudo,0)
			Replace CPO_066	With  CPO_066	+if(aGIA[_nI,1]=="CPO_066",&cConteudo,0)
			Replace CPO_067	With  CPO_067	+if(aGIA[_nI,1]=="CPO_067",&cConteudo,0)
			Replace CPO_068	With  CPO_068	+if(aGIA[_nI,1]=="CPO_068",&cConteudo,0)
			Replace CPO_069	With  CPO_069	+if(aGIA[_nI,1]=="CPO_069",&cConteudo,0)
			Replace CPO_070	With  (CPO_061+CPO_062+CPO_063+CPO_064+CPO_065+CPO_066+CPO_067+CPO_068+CPO_069)//TOTAL
            
	   Endif
	Next
Endif

_nSalCred:=(CPO_070-CPO_060)
If _nSalCred > 0
    Replace CPO_080	With  (_nSalCred)//SALDO CREDOR 
Else
    Replace CPO_090	With  (_nSalCred*-1)//IMPOSTO A RECOLHER
Endif
	        

dbGoTop()

SetRegua(LastRec())

While ( !Eof())


	nLin := 0
  	If Interrupcao(@lEnd)
		Exit
	EndIf
   cMes	:= CPO_MES
   cAno	:= CPO_ANO
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)			
	nLin	:=	PROW()+1
	nFolha 	:= nFolha+1
	FmtLin(,aLay[01],,,@nLin)
	FmtLin(,aLay[02],,,@nLin)
	FmtLin({CPO_MES+"/"+CPO_ANO},aLay[03],,,@nLin)
	FmtLin(,aLay[04],,,@nLin)
	FmtLin(,aLay[05],,,@nLin)
	FmtLin(,aLay[06],,,@nLin)
	dbSelectArea("SM0")
	FmtLin({M0_NOMECOM,Transf(M0_CGC,"@R 99.999.999/9999-99"),M0_INSC},aLay[07],,,@nLin)
	FmtLin({M0_ENDCOB,"",M0_CIDCOB},aLay[08],,,@nLin)
	dbSelectArea(cArqTemp)
	FmtLin(,aLay[09],,,@nLin)
	FmtLin(,aLay[10],,,@nLin)
	FmtLin(,aLay[11],,,@nLin)
	FmtLin({CPO_002,CPO_001},aLay[12],,,@nLin) //002 - Total das Despesas do Mes / 001 - ESTOQUE
	FmtLin(,aLay[13],,,@nLin)
	FmtLin({CPO_004},aLay[14],,,@nLin) // 004 - Produtos Primarios Adquiridos de Contribuintes nao Inscritos
	FmtLin(,aLay[15],,,@nLin)
	FmtLin({CPO_006,Transf(CPO_003,"@R 99999999999999")},aLay[16],,,@nLin) // 006 - Receita de Servicos nao sujeitos ao ICMS/ 003 - Funcionarios
	FmtLin({CPO_010,CPO_005},aLay[17],,,@nLin) // 010 - Total do quadro 5 / 005 - VALOR em Folha
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quadro 8- Valores Fiscais ( Entrada )                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FmtLin(,aLay[18],,,@nLin)
	FmtLin(,aLay[19],,,@nLin)
	FmtLin(,aLay[20],,,@nLin)
	FmtLin(,aLay[21],,,@nLin)
	FmtLin(,aLay[22],,,@nLin)
	FmtLin(,aLay[23],,,@nLin)
	FmtLin(,aLay[24],,,@nLin)
	FmtLin({CPO_011,CPO_021},aLay[25],,,@nLin) // No Estado
	FmtLin({CPO_013,CPO_023},aLay[26],,,@nLin) // Com outros Estados
	FmtLin({CPO_014,CPO_024},aLay[27],,,@nLin) // Com o Exterior	
	FmtLin({CPO_015,CPO_025},aLay[28],,,@nLin) // Substituicao Tributaria
	FmtLin(,aLay[29],,,@nLin)
	FmtLin({CPO_016,CPO_026},aLay[30],,,@nLin) // Ativo Imobilizado e Material de Uso e Consumo
	FmtLin({CPO_017,CPO_027},aLay[31],,,@nLin) // Energia Eletrica
	FmtLin({CPO_018,CPO_028},aLay[32],,,@nLin) // Comunicacao   	
	FmtLin({CPO_019,CPO_029},aLay[33],,,@nLin) // Outras	
	FmtLin({CPO_020,CPO_030},aLay[34],,,@nLin) // Total do quadro 8 - Entradas
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³QUADRO 8 - VALORES FISCAIS ( SAIDAS) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FmtLin(,aLay[35],,,@nLin)
	FmtLin(,aLay[36],,,@nLin)
	FmtLin(,aLay[37],,,@nLin)
	FmtLin(,aLay[38],,,@nLin)
	FmtLin(,aLay[39],,,@nLin)
	FmtLin(,aLay[40],,,@nLin)
	FmtLin(,aLay[41],,,@nLin)
	FmtLin({CPO_031,CPO_041}		,aLay[42],,,@nLin) // No Estado
	FmtLin({CPO_033,CPO_043}		,aLay[43],,,@nLin) // Com Outros Estados
	FmtLin({CPO_034,CPO_044}		,aLay[44],,,@nLin) // Com o Exterior	
	FmtLin({CPO_035,CPO_045}		,aLay[45],,,@nLin) // Substituicao Tributaria
	FmtLin(,aLay[46],,,@nLin) 
	FmtLin({CPO_036,CPO_046}		,aLay[47],,,@nLin) // Ativo Imobilizado e mat. Uso e Consumo
	FmtLin({CPO_039,CPO_049}		,aLay[48],,,@nLin) // Outras	
	FmtLin({CPO_040,CPO_050}	,aLay[49],,,@nLin) // Total do quadro 8 - Saidas
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³QUADROS 9 e 10 - Debitos e Creditos do ICMS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FmtLin(,aLay[50],,,@nLin)
	FmtLin(,aLay[51],,,@nLin)
	FmtLin(,aLay[52],,,@nLin)
	FmtLin({CPO_051,CPO_061},aLay[53],,,@nLin) // 051 -Por Saidas com Debito do Imposto /061- Saldo credor do mes anterior
	FmtLin({CPO_052,CPO_062},aLay[54],,,@nLin) // 052 -Outros  Debitos / 062 -Por Entradas com Credito do Imposto
	FmtLin({CPO_053,CPO_063},aLay[55],,,@nLin) // 053 -Estorno de Creditos /063 -Outros Creditos
	FmtLin({CPO_054,CPO_064},aLay[56],,,@nLin) // 054 -Diferencial de Aliquota  /064 -Estorno de Debitos
	FmtLin({CPO_055,CPO_065},aLay[57],,,@nLin)
	FmtLin({CPO_056,CPO_066},aLay[58],,,@nLin) // 056 -Estorno de Creditos de Bens do Ativo /066 -Ativo Imobilizado 
	FmtLin({CPO_057,CPO_067},aLay[59],,,@nLin) //                           / 067 -Material de Uso e Consumo
	FmtLin({CPO_058,CPO_068},aLay[60],,,@nLin) //                           / 068 -ICMS Recolhido Antecipadamente
	FmtLin({CPO_059,CPO_069},aLay[61],,,@nLin) // 059 -Transferencia de creditos acumulados/069 - Creditos Recebidos por Transferencia
	FmtLin({CPO_060,CPO_070},aLay[62],,,@nLin) // 060 -TOTAL DO DEBITO       /070 -TOTAL DO CREDITO
	FmtLin(,aLay[63],,,@nLin)
	FmtLin({CPO_080,CPO_090},aLay[64],,,@nLin) // 080 -SALDO CREDOR          /090 -IMPOSTO A RECOLHER  
	FmtLin(,aLay[65],,,@nLin)


//Gera arquivo magnetico para o Fisco (GIA.TXT)
   _cReg:= "1"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+MV_PAR11+Right("000000000000000"+LTrim(Str((CPO_001*100),15,0)),15)+;   
           Right("00000"+LTrim(Str(CPO_003,5,0)),5)+Right("000000000000000"+LTrim(Str((CPO_005*100),15,0)),15)+"57" 
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 

   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"02"+Right("000000000000000"+LTrim(Str((CPO_002*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"04"+Right("000000000000000"+LTrim(Str((CPO_004*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"06"+Right("000000000000000"+LTrim(Str((CPO_006*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"10"+Right("000000000000000"+LTrim(Str((CPO_010*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 

   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"11"+Right("000000000000000"+LTrim(Str((CPO_011*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"13"+Right("000000000000000"+LTrim(Str((CPO_013*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"14"+Right("000000000000000"+LTrim(Str((CPO_014*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"15"+Right("000000000000000"+LTrim(Str((CPO_015*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"16"+Right("000000000000000"+LTrim(Str((CPO_016*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"17"+Right("000000000000000"+LTrim(Str((CPO_017*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"18"+Right("000000000000000"+LTrim(Str((CPO_018*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"19"+Right("000000000000000"+LTrim(Str((CPO_019*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"20"+Right("000000000000000"+LTrim(Str((CPO_011*100+CPO_013*100+CPO_014*100+CPO_015*100+CPO_016*100+CPO_017*100+CPO_018*100+CPO_019*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
            
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"21"+Right("000000000000000"+LTrim(Str((CPO_021*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"23"+Right("000000000000000"+LTrim(Str((CPO_023*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"24"+Right("000000000000000"+LTrim(Str((CPO_024*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"25"+Right("000000000000000"+LTrim(Str((CPO_025*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"26"+Right("000000000000000"+LTrim(Str((CPO_026*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"27"+Right("000000000000000"+LTrim(Str((CPO_027*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"28"+Right("000000000000000"+LTrim(Str((CPO_028*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"29"+Right("000000000000000"+LTrim(Str((CPO_029*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"30"+Right("000000000000000"+LTrim(Str((CPO_021*100+CPO_023*100+CPO_024*100+CPO_025*100+CPO_026*100+CPO_027*100+CPO_028*100+CPO_029*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 

   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"31"+Right("000000000000000"+LTrim(Str((CPO_031*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"33"+Right("000000000000000"+LTrim(Str((CPO_033*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"34"+Right("000000000000000"+LTrim(Str((CPO_034*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"35"+Right("000000000000000"+LTrim(Str((CPO_035*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"36"+Right("000000000000000"+LTrim(Str((CPO_036*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"39"+Right("000000000000000"+LTrim(Str((CPO_039*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"40"+Right("000000000000000"+LTrim(Str((CPO_031*100+CPO_033*100+CPO_034*100+CPO_035*100+CPO_036*100+CPO_039*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"41"+Right("000000000000000"+LTrim(Str((CPO_041*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"43"+Right("000000000000000"+LTrim(Str((CPO_043*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"44"+Right("000000000000000"+LTrim(Str((CPO_044*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"45"+Right("000000000000000"+LTrim(Str((CPO_045*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"46"+Right("000000000000000"+LTrim(Str((CPO_046*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"49"+Right("000000000000000"+LTrim(Str((CPO_049*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"50"+Right("000000000000000"+LTrim(Str((CPO_041*100+CPO_043*100+CPO_044*100+CPO_045*100+CPO_046*100+CPO_049*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 

   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"51"+Right("000000000000000"+LTrim(Str((CPO_051*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"52"+Right("000000000000000"+LTrim(Str((CPO_052*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"53"+Right("000000000000000"+LTrim(Str((CPO_053*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"54"+Right("000000000000000"+LTrim(Str((CPO_054*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"55"+Right("000000000000000"+LTrim(Str((CPO_055*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"56"+Right("000000000000000"+LTrim(Str((CPO_056*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"57"+Right("000000000000000"+LTrim(Str((CPO_057*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"58"+Right("000000000000000"+LTrim(Str((CPO_058*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"59"+Right("000000000000000"+LTrim(Str((CPO_059*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"60"+Right("000000000000000"+LTrim(Str((CPO_051*100+CPO_052*100+CPO_053*100+CPO_054*100+CPO_055*100+CPO_056*100+CPO_057*100+CPO_058*100+CPO_059*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 

   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"61"+Right("000000000000000"+LTrim(Str((CPO_061*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"62"+Right("000000000000000"+LTrim(Str((CPO_062*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"63"+Right("000000000000000"+LTrim(Str((CPO_063*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"64"+Right("000000000000000"+LTrim(Str((CPO_064*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"65"+Right("000000000000000"+LTrim(Str((CPO_065*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"66"+Right("000000000000000"+LTrim(Str((CPO_066*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"67"+Right("000000000000000"+LTrim(Str((CPO_067*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"68"+Right("000000000000000"+LTrim(Str((CPO_068*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"69"+Right("000000000000000"+LTrim(Str((CPO_069*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"70"+Right("000000000000000"+LTrim(Str((CPO_061*100+CPO_062*100+CPO_063*100+CPO_064*100+CPO_065*100+CPO_066*100+CPO_067*100+CPO_068*100+CPO_069*100),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 

   _nImpRec:=(CPO_051*100+CPO_052*100+CPO_053*100+CPO_054*100+CPO_055*100+CPO_056*100+CPO_057*100+CPO_058*100+CPO_059*100)-(CPO_061*100+CPO_062*100+CPO_063*100+CPO_064*100+CPO_065*100+CPO_066*100+CPO_067*100+CPO_068*100+CPO_069*100)
   If _nImpRec < 0   
      _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"80"+Right("000000000000000"+LTrim(Str(((_nImpRec*-1)),15,0)),15)  //CPO_051*100+CPO_052*100+CPO_053*100+CPO_054*100+CPO_055*100+CPO_056*100+CPO_057*100+CPO_058*100+CPO_059*100)-(CPO_061*100+CPO_062*100+CPO_063*100+CPO_064*100+CPO_065*100+CPO_066*100+CPO_067*100+CPO_068*100+CPO_069*100
      Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   Endif
   If _nImpRec > 0
      _cReg:= "2"+Substr(SM0->M0_INSC,1,10)+Str(MV_PAR02,4)+Str(MV_PAR01,2)+MV_PAR10+"90"+Right("000000000000000"+LTrim(Str(((_nImpRec)),15,0)),15)  //CPO_051*100+CPO_052*100+CPO_053*100+CPO_054*100+CPO_055*100+CPO_056*100+CPO_057*100+CPO_058*100+CPO_059*100)-(CPO_061*100+CPO_062*100+CPO_063*100+CPO_064*100+CPO_065*100+CPO_066*100+CPO_067*100+CPO_068*100+CPO_069*100
      Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   Endif
   
	dbSkip()
	IncRegua()
EndDo
   
Fclose(_nOutFile)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga arquivos temporarios                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If File(cArqTemp+".DBF")
	dbSelectArea(cArqTemp)
	dbCloseArea()
	Ferase(cArqTemp+".DBF")
	Ferase(cArqTemp+OrdBagExt())
Endif


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GIAAPUR   ºAutor  ³Andreia dos Santos  º Data ³  09/10/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Le o arquivo de apuracao do ICMS                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ matrgia                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GIAAPUR()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega informacoes dos arquivos .IC?                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AADD(aArqApur,NmArqApur("IC",MV_PAR02,MV_PAR01,3,nPerApurado,cNrLivro))

SetRegua(Len(aArqApur))
For i:=1 to Len(aArqApur)
	IncRegua()
	nPeriodo:=i
	cArqApur:=aArqApur[i]
	If !File(cArqApur)
		Loop
	Endif
	cConteudo:=MemoRead(cArqApur)
	aCampos:={.t.,.t.,.t.,.t.}
	For j:=2 to MlCount(cConteudo,85)
		cLinha:=MemoLine(cConteudo,85,j)
		cCampo:=Substr(cLinha,1,3)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega valor numerico e descricao                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If IsDigit(Substr(cCampo,1,1)).and.IsDigit(Substr(cCampo,3,1))
			cValor:=	Substr(cLinha,52,18)
			cValor:=	StrTran(cValor,'.')
			cValor:=	StrTran(cValor,',','.')
			nValor:=	Val(cValor)
			cTexto:=	Substr(cLinha,5,50)
		Else
			nValor:=	0
			cTexto:=	Substr(cLinha,5)
		Endif
		Do Case
			Case cCampo=='001'
				_nCPO_051	:=	_nCPO_051+nValor //saida com debito do imposto
			Case cCampo=='002'
				if acampos[1]
					_nCPO_052	:=	_nCPO_052+nValor	//outros debitos
					acampos[1]	:= .f.
				endIf	
			Case cCampo=='003'
				if aCampos[2]
					_nCPO_053	:=	_nCPO_053+nValor //estorno de creditos
					aCampos[2]	:= .f.
				EndIf	
			Case cCampo=='005'
				_nCPO_062	:=	_nCPO_062+nValor  //entradas com credito do imposto
			Case cCampo=='006'
				if aCampos[3]
					_nCPO_063	:=	_nCPO_063+nValor //outros creditos
					acampos[3]	:= .f.
				EndIf	
			Case cCampo=='007'
				if aCampos[4]
					_nCPO_064	:=	_nCPO_064+nValor //Estorno de debitos
					aCampos[4]	:= .f.
				Endif	
			Case cCampo=='009' .and. (nPerApurado!=4.or.(nPerApurado==4.and.i==1))
				_nCPO_061	:=	_nCPO_061+nValor   //Saldo Credor do periodo anterior
		EndCase
	Next j
Next i

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LayGIA()   ³ Autor ³ Andreia dos Santos    ³ Data ³02/10/00³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Layout da GIA                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 25/09/01 ==> Function LayGIA
Static Function LayGIA()

aLay[01] :="+-----------------------------------------------------------------------------------------------------------------------------------------------+"
aLay[02] :="|                                            GUIA DE INFORMACAO E APURACAO DO ICMS ( GIA/ICMS )                                                 |"
aLay[03] :="| PERIODO : #######                                                                                                                             |"
aLay[04] :="+-----------------------------------------------------------------------------------------------------------------------------------------------+"
aLay[05] :="| 1 - IDENTIFICACAO DO CONTRIBUINTE                                                                                                             |"
aLay[06] :="+-----------------------------------------------------------------------------------------------------------------------------------------------+"
aLay[07] :="|Nome: ######################################## C.N.P.J. No: ##################    Inscricao Estadual No: ##################################### |"
aLay[08] :="|Endereco: ####################################   Bairro: #####################    Municipio: ################################################# |"
aLay[09] :="+-----------------------------------------------------------------------------------------------------------------------------------------------+"
aLay[10] :="| QUADRO 5 - INFORMACOES FISCAIS                                 |              |            QUADRO 6 - ESTOQUE                                 |"
aLay[11] :="+----------------------------------------------------------------+--------------+-----------------------+-------------------------+-------------+"
aLay[12] :="| 02 - Total das Despesas do Mes        | ###################### |              | ESTOQUE               | ######################  |             |"
aLay[13] :="| 04 - Produtos Primarios Adquiridos    |                        |              +-------------------------------------------------+             |"
aLay[14] :="|      de Contribuintes nao Inscritos   | ###################### |              |         QUADRO 7 - DESPESAS COM PESSOAL         |             |"
aLay[15] :="| 06 - Receita de Servicos nao sujeitos |                        |              +-------------------------------------------------+             |"
aLay[16] :="|      ao ICMS                          | ###################### |              | Funcionarios          | ######################  |             |"
aLay[17] :="| 10 - TOTAL DO QUADRO                  | ###################### |              | Valor em Folha        | ######################  |             |"
aLay[18] :="+-----------------------------------------------------------------------------------------------------------------------------------------------+"
aLay[19] :="| QUADRO 8 - VALORES FISCAIS ( ENTRADAS )                                                                                                       |"
aLay[20] :="+-----------------------------------------------------------------------------------------------------------------------------------------------+"
aLay[21] :="|     OPERACOES           |            VALORES DAS ENTRADAS                                                                                     |"
aLay[22] :="+         E               |-------------------------------------------------------------+                                                       |"
aLay[23] :="|     PRESTACOES          |           VALOR CONTABIL     | BASE DE CALCULO              |                                                       |"
aLay[24] :="+-------------------------+------------------------------+------------------------------+                                                       |"
aLay[25] :="| No Estado               |11|   ######################  |21|   ######################  |                                                       |"
aLay[26] :="| Com outros Estados      |13|   ######################  |23|   ######################  |                                                       |"
aLay[27] :="| Com o Exterior          |14|   ######################  |24|   ######################  |                                                       |"
aLay[28] :="| Substituicao Tributaria |15|   ######################  |25|   ######################  |                                                       |"
aLay[29] :="| Ativo Imobilizado e Mat.|  |                           |  |                           |                                                       |"
aLay[30] :="| de Uso e Consumo        |16|   ######################  |26|   ######################  |                                                       |"
aLay[31] :="| Energia Eletrica        |17|   ######################  |27|   ######################  |                                                       |"
aLay[32] :="| Comunicacao             |18|   ######################  |28|   ######################  |                                                       |"
aLay[33] :="| Outras                  |19|   ######################  |29|   ######################  |                                                       |"
aLay[34] :="| TOTAL                   |20|   ######################  |30|   ######################  |                                                       |"
aLay[35] :="+-----------------------------------------------------------------------------------------------------------------------------------------------+"
aLay[36] :="| QUADRO 8 - VALORES FISCAIS ( SAIDAS)                                                                                                          |"
aLay[37] :="+-----------------------------------------------------------------------------------------------------------------------------------------------+"
aLay[38] :="|     OPERACOES           |            VALORES DAS SAIDAS                                                                                       |"
aLay[39] :="+         E               |-------------------------------------------------------------+                                                       |"
aLay[40] :="|     PRESTACOES          |           VALOR CONTABIL     | BASE DE CALCULO              |                                                       |"
aLay[41] :="+-------------------------+------------------------------+------------------------------+                                                       |"
aLay[42] :="| No Estado               |31|   ######################  |41|   ######################  |                                                       |"
aLay[43] :="| Com outros Estados      |33|   ######################  |43|   ######################  |                                                       |"
aLay[44] :="| Com o Exterior          |34|   ######################  |44|   ######################  |                                                       |"
aLay[45] :="| Substituicao Tributaria |35|   ######################  |45|   ######################  |                                                       |"
aLay[46] :="| Ativo Imobilizado e Mat.|  |                           |  |                           |                                                       |"
aLay[47] :="| de Uso e Consumo        |36|   ######################  |46|   ######################  |                                                       |"
aLay[48] :="| Outras                  |39|   ######################  |49|   ######################  |                                                       |"
aLay[49] :="| TOTAL                   |40|   ######################  |50|   ######################  |                                                       |"
aLay[50] :="+-----------------------------------------------------------------------------------------------------------------------------------------------+"
aLay[51] :="|                     QUADRO 9 - DEBITOS DO ICMS                        |              QUADRO 10 - CREDITOS DO ICMS                             |"
aLay[52] :="+-----------------------------------------------------------------------+-----------------------------------------------------------------------+"
aLay[53] :="|   Por Saidas com Debito do Imposto     |51|   ######################  |  Saldo credor do mes anterior         |61|   ######################   |"
aLay[54] :="|   Outros Debitos                       |52|   ######################  |  Por Entradas com Credito do Imposto  |62|   ######################   |"
aLay[55] :="|   Estorno de Creditos                  |53|   ######################  |  Outros Creditos                      |63|   ######################   |"
aLay[56] :="|   Diferencial de Aliquota              |54|   ######################  |  Estorno de Debitos                   |64|   ######################   |"
aLay[57] :="|                                        |55|   ######################  |                                       |65|   ######################   |"
aLay[58] :="|   Estorno de Creditos de Bens do Ativo |56|   ######################  |  Ativo Imobilizado                    |66|   ######################   |"
aLay[59] :="|                                        |57|   ######################  |  Material de Uso e Consumo            |67|   ######################   |"
aLay[60] :="|                                        |58|   ######################  |  ICMS Recolhido Antecipadamente       |68|   ######################   |"
aLay[61] :="|   Transferencia de creditos acumulados |59|   ######################  |  Creditos Recebidos por Transferencia |69|   ######################   |"
aLay[62] :="|   TOTAL DO DEBITO                      |60|   ######################  |  TOTAL DO CREDITO                     |70|   ######################   |"
aLay[63] :="+-----------------------------------------------------------------------------------------------------------------------------------------------+"
aLay[64] :="|   SALDO CREDOR                         |80|   ######################  |  IMPOSTO A RECOLHER                   |90|   ######################   |"                                                                   
aLay[65] :="+-----------------------------------------------------------------------------------------------------------------------------------------------+"

Return

	
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ReadGIA   ³ Autor ³Andreia dos Santos     ³ Data ³05.10.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de Leitura dos arquivos de GIA                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com o Lay-Out da GIA                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Arquivo                                              ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/09/01 ==> Function ReadGIA
Static Function ReadGIA()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura do Arquivo a Ser Lido                                         ³
//³                                                                        ³
//³XXX_XXX    X YYY Z CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC ³
//³|          | |   | |                                                    ³
//³|          | |   | À> Conteudo                                          ³
//³|          | |   À--> Numero de Decimais                                ³
//³|          | À------> Tamanho da Coluna                                 ³
//³|          À--------> Formato de Gravacao ( Numerico Caracter Data)     ³
//³À-------------------> Nome do campo                                     ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a Abertura do Arquivo cArqGIA.Ini                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( File(cArqGIA) )
	FT_FUse(cArqGIA)
	FT_FGotop()
	
	While ( !FT_FEof() )
		cLinha := FT_FREADLN()
		
		Do Case
			Case SubStr(cLinha,1,4)=="CPO_"
				aadd(aGIA, {	SubStr(cLinha,01,07) 			,;	//1.Campo
									SubStr(cLinha,12,01) 			,;	//2.Tipo
									Val(SubStr(cLinha,14,03)) 	,;	//3.Tamanho
									Val(SubStr(cLinha,18,01)) 	,;	//4.Decimal
				 					SubStr(cLinha,20) 	})				//5.Conteudo
				
		EndCase
		
		FT_FSkip()
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Fecha o Arquivo cArqGIA.INI                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FT_FUse()    
Else
	lRet	:= .F.
EndIf

RestArea(aArea)

Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 25/09/01

