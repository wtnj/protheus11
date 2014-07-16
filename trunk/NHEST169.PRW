#INCLUDE "TOPCONN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma:EST169   Autor:José Henrique M Felipetto  Data ³  27/07/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ IMPRESSAO DE SOLICITACAO DE EPI                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESTOQUE / CUSTOS                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
  
User Function NHEST169()

	If MsgYesNo("Possui impressora térmica?")
		EST169NV()
	Else
		EST169AN()	
	EndIf
    
Return


Static Function EST169NV()
Private oFnt1   := TFont():New("Arial"		,,08,,.F.,,,,,.F.)
Private oFnt2   := TFont():New("Arial"		,,11,,.T.,,,,,.F.)
Private oFnt3   := TFont():New("Arial"		,,09,,.T.,,,,,.F.)
Private oFnt4   := TFont():New("Arial"		,,13,,.T.,,,,,.F.)
Private cNum    := SCP->CP_NUM
Private oPrn 	:= tMSPrinter():New("Protheus")
Private nAlt  	:= 20
Private nLar  	:= 5
Private aMat 	:= {} 

If !oPrn:Setup()
	Return
EndIf

Processa({|| Gerando()},"Gerando dados para impressão...")

oPrn:StartPage()
Cabecalho()
SB1->(DbSetOrder(1) )

While TRA1->(!Eof() )

	_n := aScan(aMat,{|x| x[1] == TRA1->ZDC_PROD } )
	SB1->(DbSeek(xFilial("SB1") + Alltrim(TRA1->ZDC_PROD) ))
	
	If _n != 0
		aMat[_n][3] += 1		
	Else
		aAdd(aMat,{TRA1->ZDC_PROD,SB1->B1_DESC,1,TRA1->ZDC_CC,SB1->B1_UM} )
	EndIf
	
	TRA1->(DbSkip() )
EndDo

For i := 1 to Len(aMat)
	
	oPrn:Say(nAlt + 400,nLar,Alltrim(aMat[i,1]),oFnt1)
	oPrn:Say(nAlt + 400,nLar + 250,Alltrim(Substr(aMat[i,2],1,10)),oFnt1)
	oPrn:Say(nAlt + 400,nLar + 395,Str(aMat[i,3]),oFnt1)
	oPrn:Say(nAlt + 400,nLar + 613,aMat[i,5],oFnt1)
	oPrn:Say(nAlt + 400,nLar + 785,aMat[i,4],oFnt1)
	
	
	nAlt += 50
Next i 


RodapeMTA()

oPrn:EndPage()
oPrn:End()
oPrn:Print()
TRA1->(DbCloseArea() )
Return(.T.)

Static Function Cabecalho()
Private _cLocaliz := ""
oPrn:Say(nAlt,nLar - 10,"WHB COMPONENTES AUTOMOTIVOS",oFnt4)
oPrn:Say(nAlt + 40,nLar,"Solicitação de EPI: Comprovante ", oFnt2)
oPrn:Say(nAlt + 70,nLar,"------------------------------------------------------------------------------------------",oFnt3)

oPrn:Say(nAlt + 105,nLar,"Requisição:",oFnt1)
oPrn:Say(nAlt + 100,nLar + 200,Alltrim(TRA1->ZDC_NUM),oFnt2)

/*oPrn:Say(nAlt + 118,nLar + 460,"Local: " ,oFnt1)
oPrn:Say(nAlt + 105,nLar + 550,SCP->CP_LOCAL,oFnt2)*/

oPrn:Say(nAlt + 165,nLar,"Emissão:",oFnt1)
oPrn:Say(nAlt + 160,nLar + 200,DTOC(TRA1->ZDC_DATA),oFnt2)

oPrn:Say(nAlt + 225,nLar,"Solicitante:",oFnt1)
oPrn:Say(nAlt + 220,nLar + 200,Alltrim(TRA1->ZDC_SOLIC),oFnt2)

oPrn:Say(nAlt + 270,nLar,"------------------------------------------------------------------------------------------",oFnt3)

oPrn:Say(nAlt + 300,nLar,"Cód.",oFnt3)
oPrn:Say(nAlt + 300,nLar + 250,"Descrição",oFnt3)
oPrn:Say(nAlt + 300,nLar + 490,"Sol",oFnt3)
oPrn:Say(nAlt + 300,nLar + 613,"Unidade",oFnt3)
oPrn:Say(nAlt + 300,nLar + 785,"C.C",oFnt3)

oPrn:Say(nAlt + 330,nLar,"------------------------------------------------------------------------------------------",oFnt3)
Return

Static Function RodapeMTA()
_cEmpr := "Empresa:" + Alltrim(SM0->M0_NOME) + "/Filial:" + Alltrim(SM0->M0_FILIAL)

oPrn:Say(nAlt + 460,nLar ,"------------------------------------------------------------------------------------------",oFnt3)
oPrn:Say(nAlt + 510,nLar,_cEmpr,oFnt3)
oPrn:Say(nAlt + 570,nLar + 100,"Recebi os itens acima em perfeito ",oFnt3)
oPrn:Say(nAlt + 640,nLar + 100,"estado e nas quantidades indicadas. ",oFnt3)
oPrn:Say(nAlt + 760,nLar,"Recebido por:_____________________________",oFnt3)
oPrn:Say(nAlt + 840,nLar,"Ass:_____________________________",oFnt3)
oPrn:Say(nAlt + 900,nLar + 120,"Data de Impressão: " + DTOC(Date() ) + "  "  + time() ,oFnt3)
oPrn:Say(nAlt + 980,nLar,"------------------------------------------------------------------------------------------",oFnt3)

Return

Static Function Gerando()
Local cQuery
    
    cQuery := "SELECT ZDC.*, CTT.CTT_DESC01, SB1.B1_DESC, QA1.QAA_NOME SOL, "
    cQuery += " QA2.QAA_NOME, ZRG.ZRG_OP "
    cQuery += " FROM "+RetSqlName('ZDC')+" ZDC, "+RetSqlName('CTT')+" CTT, "+RetSqlName('SB1')+" SB1, "+RetSqlName('QAA')+" QA1, "
    cQuery += RetSqlName('QAA')+" QA2, "+RetSqlName('ZRG')+" ZRG "
    cQuery += " WHERE ZDC_NUM = '"+ZDC->ZDC_NUM+"'"
    cQuery += " AND ZDC.ZDC_CC = CTT.CTT_CUSTO "
    cQuery += " AND ZDC.ZDC_PROD = SB1.B1_COD "
    cQuery += " AND ZDC.ZDC_SOLIC = QA1.QAA_LOGIN "
    cQuery += " AND ZDC.ZDC_MAT = QA2.QAA_MAT "
    cQuery += " AND ZDC.ZDC_MAT = ZRG.ZRG_MAT "
    
    cQuery += " AND ZDC.D_E_L_E_T_ = ' ' "
    cQuery += " AND CTT.D_E_L_E_T_ = ' ' "
    cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
    cQuery += " AND QA1.D_E_L_E_T_ = ' ' "
    cQuery += " AND QA2.D_E_L_E_T_ = ' ' "
    cQuery += " AND ZRG.D_E_L_E_T_ = ' ' "
    cQuery += " AND ZDC.ZDC_FILIAL = '"+xFilial("ZDC")+"'"
    cQuery += " AND CTT.CTT_FILIAL = '"+xFilial("CTT")+"'"
    cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
    cQuery += " AND QA1.QAA_FILIAL = '"+xFilial("QAA")+"'"
    cQuery += " AND QA2.QAA_FILIAL = '"+xFilial("QAA")+"'"
    cQuery += " AND ZRG.ZRG_FILIAL = '"+xFilial("ZRG")+"'"
	
	TCQUERY cQuery NEW ALIAS "TRA1"
	TRA1->(DbGoTop())    
	TcSetField("TRA1","ZDC_DATA","D")
Return    








Static Function EST169AN()
cString		:= "ZDC"
cDesc1		:= "Este relatorio tem como objetivo Imprimir"
cDesc2      := "a relação de solicitações de EPI"
cDesc3      := ""      
tamanho		:= "G"
limite		:= 132
aReturn		:= { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHEST169"
nLastKey	:= 0
titulo		:= OemToAnsi("SOLICITAÇÃO DE EPI")
cabec1    	:= ""
cabec2		:= ""
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1 //Variavel da pagina
M_PAG		:= 1
wnrel		:= "NHEST169"
_cPerg		:= ""

//Pergunte(_cPerg,.F.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif          

SetDefault(aReturn,cString)

nTipo	:= IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver	:= ReadDriver()
cCompac	:= aDriver[1]

Processa( {|| GerandoAN()  },"Gerando Dados para a Impressao")
Processa( {|| RptDetail()  },"Imprimindo...")    

set filter to 
	//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function GerandoAN()
Local cQuery

	If Select("TRA1") > 0
		TRA1->(DbCloseArea() )
	EndIf
	//------------------
    // MONTA A QUERY
    //------------------              
    
    cQuery := "SELECT ZDC.*, CTT.CTT_DESC01, SB1.B1_DESC, QA1.QAA_NOME SOL, "
    cQuery += " QA2.QAA_NOME, ZRG.ZRG_OP "
    cQuery += " FROM "+RetSqlName('ZDC')+" ZDC, "+RetSqlName('CTT')+" CTT, "+RetSqlName('SB1')+" SB1, "+RetSqlName('QAA')+" QA1, "
    cQuery += RetSqlName('QAA')+" QA2, "+RetSqlName('ZRG')+" ZRG "
    cQuery += " WHERE ZDC_NUM = '"+ZDC->ZDC_NUM+"'"
    cQuery += " AND ZDC.ZDC_CC = CTT.CTT_CUSTO "
    cQuery += " AND ZDC.ZDC_PROD = SB1.B1_COD "
    cQuery += " AND ZDC.ZDC_SOLIC = QA1.QAA_LOGIN "
    cQuery += " AND ZDC.ZDC_MAT = QA2.QAA_MAT "
    cQuery += " AND ZDC.ZDC_MAT = ZRG.ZRG_MAT "
    
    cQuery += " AND ZDC.D_E_L_E_T_ = ' ' "
    cQuery += " AND CTT.D_E_L_E_T_ = ' ' "
    cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
    cQuery += " AND QA1.D_E_L_E_T_ = ' ' "
    cQuery += " AND QA2.D_E_L_E_T_ = ' ' "
    cQuery += " AND ZRG.D_E_L_E_T_ = ' ' "
    cQuery += " AND ZDC.ZDC_FILIAL = '"+xFilial("ZDC")+"'"
    cQuery += " AND CTT.CTT_FILIAL = '"+xFilial("CTT")+"'"
    cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
    cQuery += " AND QA1.QAA_FILIAL = '"+xFilial("QAA")+"'"
    cQuery += " AND QA2.QAA_FILIAL = '"+xFilial("QAA")+"'"
    cQuery += " AND ZRG.ZRG_FILIAL = '"+xFilial("ZRG")+"'"
	
	MemoWrit('C:\TEMP\NHEST169.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TRA1"
	TRA1->(DbGoTop())    
	TcSetField("TRA1","ZDC_DATA","D")

Return    
 
Static Function RptDetail()     
Local _nttotal := 0
Local _ntqtde := 0
                                         
Titulo := OemToAnsi("SOLICITAÇÃO DE EPI - Nº: ")+TRA1->ZDC_NUM

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)



@Prow()+1, 001 psay "Solicitante: " + TRA1->SOL //LOGIN SOLICITANTE
@Prow()  , 060 psay "Data: "+DtoC(TRA1->ZDC_DATA)

@Prow()+2, 001 psay "ITEM   MATRIC   NOME                                    C.CUSTO    DESC. CC                         OP    PRODUTO          DESCRIÇÃO                                   QTD"

While TRA1->(!Eof()) 

   	If Prow() > 55
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	Endif

	@Prow()+1, 001 psay TRA1->ZDC_ITEM //ITEM
	@Prow()  , 008 psay TRA1->ZDC_MAT //MATRICULA COLABORADOR 
	@Prow()  , 017 psay SUBS(TRA1->QAA_NOME,1,40) //NOME COLABORADOR
	@Prow()  , 057 psay TRA1->ZDC_CC //CENTRO DE CUSTO
	@Prow()  , 068 psay SUBS(TRA1->CTT_DESC01,1,30) //DESCRIÇÃO DO CENTRO DE CUSTO
	@Prow()  , 101 psay TRA1->ZRG_OP //OPERAÇÃO
	@Prow()  , 107 psay TRA1->ZDC_PROD //PRODUTO
	@Prow()  , 124 psay SUBS(TRA1->B1_DESC,1,40) //DESCRIÇÃO DO EPI
	@Prow()  , 169 psay "1" //QUANTIDADE
	TRA1->(DbSkip())
EndDo 

@Prow()+2,000 PSAY __PrtThinLine()
    
	aMat := {}
	
	@Prow()+2, 001 psay "Soma dos itens a retirar"
	@Prow()+2, 001 psay "PRODUTO            DESCRICAO                                                  QUANTIDADE"

TRA1->(DbGoTop())  
While TRA1->(!Eof())
	
	_n := aScan(aMat,{|x| x[1]==TRA1->ZDC_PROD})
	If _n != 0
		aMat[_n][3] += 1
	Else
		aAdd(aMat,{TRA1->ZDC_PROD,TRA1->B1_DESC,1})
	EndIf
	TRA1->(DbSkip())
	
EndDo

For x:=1 to Len(aMat)
	
	If Prow() > 55
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	Endif
	
	@Prow()+1, 001 psay aMat[x][1]
	@Prow()  , 020 psay SUBS(aMat[x][2],1,60)
	@Prow()  , 083 psay aMat[x][3]

Next

@Prow()+2,000 PSAY __PrtThinLine()

TRA1->(DbCloseArea())    

Return(nil)
