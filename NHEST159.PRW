/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST159        ³ João Felipe da Rosa   ³ Data ³ 15.04.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao a necessidade de Ferramentas                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padrao para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "Rwmake.ch"     
 
#include "Topconn.ch"

User Function NhEst159()

cString   := "ZDJ"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir as ")
cDesc2    := OemToAnsi("Necessidades de Ferramentas")
cDesc3    := OemToAnsi(" ")
tamanho   := "G"
limite    := 270
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST159"
nLastKey  := 0
titulo    := ""
cabec1    := ""
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHEST159" //Nome Default do relatorio em Disco
cPerg     := "EST159"  //Grupo de Parametros que serao utilizados (cadastrar novo grupo no SX1)

// Parametros Utilizados
// mv_par01 = Data de emisao inicial
// mv_par02 = Data de emisao final
// mv_par03 = codigo do produto inicial
// mv_par04 = codigo do produto final
// mv_par05 = Relatorio sintetico ou Analitico ou Geral
// mv_par06 = lista critica (sim / nao)
// mv_par07 = de ferramenta
// mv_par08 = ate ferramenta

CriaSx1(cPerg)
Pergunte(cPerg, .F.)
 
SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho) 

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)
             
nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]                   
                             
If mv_par06 == 1 //Lista critica sim
   titulo := "LISTA CRITICA"
Else
   titulo := "NECESSIDADE"
Endif   

titulo += " DE FERRAMENTAS - PERÍODO DE "+DtoC(mv_par01)+" ATÉ "+DtoC(mv_par02)+" - Revisão 12"

//--Calcula o Estoque Mínimo para as ferramentas
Processa( {|| U_MRPCalEMin(mv_par01,mv_par02,mv_par07,mv_par08) },"Calculando estoque mínimo para as ferramentas!")
Processa( {|| Explode() },"Gerando Explosao")
Processa( {|| fGera()   },"Gerando Dados para a Impressao")

Set Filter To   

If aReturn[5] == 1
	Set Printer To
	Commit
   ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

//--Fecha Alias Temporario se nao encontrou nada
If Select("TMP") > 0
	TMP->(dbCloseArea())
Endif

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FAZ A CONSULTA NO BANCO DE DADOS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Explode()    

   	cQuery := "SELECT ZDJ.ZDJ_FAB,ZDJ.ZDJ_PROD,ZDJ.ZDJ_FERRAM,ZDJ.ZDJ_CC,ZDJ.ZDJ_OP,"
   	cQuery += " ZDJ.ZDJ_VUMONT,ZDJ.ZDJ_VUSET,ZDJ.ZDJ_FMONT,ZDJ.ZDJ_INDREF,ZDJ.ZDJ_INDQUE,ZDJ.ZDJ_QTREAF,ZDJ.ZDJ_ITEM,"
   	cQuery += " ZDJ.ZDJ_ARESTA,SUM(SHC.HC_QUANT) AS HC_QUANT, ZDJ.R_E_C_N_O_ AS ZDJ_RECNO"
   	cQuery += " FROM " + RetSqlName( 'ZDJ' ) +" ZDJ (NOLOCK), " + RetSqlName( 'SHC' ) +" SHC (NOLOCK)" 
   	cQuery += " WHERE ZDJ.ZDJ_FILIAL = '" + xFilial("ZDJ")+ "'"
   	cQuery += " AND SHC.HC_FILIAL = '" + xFilial("SHC")+ "'"
   	cQuery += " AND ZDJ.ZDJ_PROD = SHC.HC_PRODUTO"  
   	cQuery += " AND ZDJ.D_E_L_E_T_ = ' '"  
   	cQuery += " AND SHC.D_E_L_E_T_ = ' '"
   	cQuery += " AND SHC.HC_DATA BETWEEN '" + Dtos(mv_par01) + "' AND '" +DtoS( mv_par02) + "'"    
   	cQuery += " AND SHC.HC_PRODUTO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"       
   	cQuery += " AND ZDJ.ZDJ_FERRAM BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "'"
   	cQuery += " GROUP BY ZDJ.ZDJ_FAB,ZDJ.ZDJ_PROD,ZDJ.ZDJ_FERRAM,ZDJ.ZDJ_CC,ZDJ.ZDJ_OP,"
   	cQuery += " ZDJ.ZDJ_VUMONT,ZDJ.ZDJ_VUSET,ZDJ.ZDJ_FMONT,ZDJ.ZDJ_INDREF,ZDJ.ZDJ_INDQUE,ZDJ.ZDJ_QTREAF,"
   	cQuery += " ZDJ.ZDJ_ITEM,ZDJ.ZDJ_ARESTA, ZDJ.R_E_C_N_O_"
   	cQuery += " ORDER BY ZDJ.ZDJ_FAB,ZDJ.ZDJ_PROD,ZDJ.ZDJ_OP,ZDJ.ZDJ_FERRAM"

//  	MemoWrit('C:\TEMP\EST159.SQL',cQuery)
	//TCQuery Abre uma workarea com o resultado da query
   	TCQUERY cQuery NEW ALIAS "TMP"     

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GERA O ARRAY ALISTA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fGera()
Private cAz      := "TMPN"
Private nUVNova  := 0
Private nUVReaf  := 0               
Private nSalNov  := 0
Private nSalRef  := 0
Private nVlrTot  := 0
Private nTotGer  := 0
Private _nSNec   := 0
Private _nSCon   := 0
Private nQtdPC   := 0
Private nQtdSC   := 0
Private _cProd 
Private _nQtNec  := 0
Private _nI,_x   
Private _nSaldo  := 0
Private _nSalMin := 0
Private _cProdut := ""
Private _cDesPro := ""
Private _cCodFer := ""
Private _cFornec := ""
Private _nVidaUt := 0
Private aLista   := {}
Private _nTcoPla := 0
Private _nTnec   := 0
Private _nTcuPc  := 0     
Private cCodReaf := ''    
Private aArr     := {} //variavel auxiliar

TMP->(DbGoTop())

ProcRegua(0)

If Empty(TMP->ZDJ_FERRAM)
	//--Fecha Alias Temporario se nao encontrou nada      
	Alert("Arquivo vazio!")
	TMP->(dbCloseArea())
	Return
Endif

SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+TMP->ZDJ_PROD))         

_cProd := SB1->B1_COD

While TMP->(!Eof())
   
   	IncProc("Processando Produtos ... " + TMP->ZDJ_PROD)
	
	//Armazena a descricao do produto a ser produzido  
   	_cDesPro := Posicione("SB1",1,xFilial("SB1")+TMP->ZDJ_PROD,"B1_DESC") 
   
   	SB1->(dbSetOrder(1))
   	SB1->(dbSeek(xFilial("SB1")+TMP->ZDJ_FERRAM))
   	
   	If SB1->(!Found()) //existem alguns casos de ferramentas que nao sao encontradas no sb1 por erro da engenharia
   		TMP->(dbSkip())
   		Loop
   	EndIf
    
    //-- guarda o codigo da ferramenta reafiada
	cCodReaf := subStr(SB1->B1_COD,1,3)+"5"+subStr(SB1->B1_COD,5,11)
	
   	//--Pega o saldo da ferramenta nova
   	nSalNov := U_MRPFSld(SB1->B1_COD)
   	
   	//-- Pega o saldo da ferramenta reafiada
   	nSalRef := U_MRPFSld(cCodReaf)
   
	//-- Traz a quantidade em pedidos abertos E SC para a ferramenta
   	nQtdSC := U_MRPFQSCA(TMP->ZDJ_FERRAM) 
   	nQtdPC := U_MRPFQPCA(TMP->ZDJ_FERRAM) 

	//-- Busca o valor unitario e fornecedor da ultima entrada da ferramenta nova na empresa corrente
    aArr = U_MRPFVUFor(TMP->ZDJ_FERRAM,"N") //-- N de Nova

    nUVNova  := aArr[1]
    _cFornec := aArr[2]
    
 	// Busca o ultimo valor unitario da ferramenta reafiada na empresa corrente
    aArr = U_MRPFVUFor(cCodReaf,"R") //-- R de Reafiada
    nUVReaf := aArr[1]
	    
	//retorna o consumo planejado de acordo com a quantidade de peças a produzir
	ZDJ->(dbGoTo(TMP->ZDJ_RECNO))
	aArr := U_MRPFConP(TMP->HC_QUANT)//-- obs: necessita estar posicionada no zdj
	nConPlan := aArr[1]
	_nVidaUt := aArr[2]

    //traz o consumo planejado até a data de compra da necessidade
    nConFut := U_MRPConAte(TMP->ZDJ_RECNO,mv_par01-1) 

   	If !Empty(_cFornec)
   		If AllTrim(_cFornec)<>'00000301'  // WHB USINAGEM
	      	_cFornec := Posicione("SA2",1,xFilial("SA2")+_cFornec,"A2_NREDUZ")   
	    Else
	    	_cFornec := " "
	    EndIf
   	Endif

	Aadd(aLista,{TMP->ZDJ_PROD,;
                 TMP->ZDJ_FAB,;
                 TMP->ZDJ_OP,;
                 Subs(TMP->ZDJ_FERRAM,1,11),;
                 Subs(Posicione("SB1",1,xFilial("SB1")+TMP->ZDJ_FERRAM,'B1_DESC'),1,30),; //05 DESCRICAO DA FERRAMENTA
                 TMP->HC_QUANT,;
                 TMP->ZDJ_VUMONT,;  //7
                 _nVidaUt,;         //8 vida util
                 nSalNov,;          //9
                 nSalRef,;          //10
                 /*_nQtNec*/ 0 ,;   //11  //-- NAO USADO
   	  		     nConPlan,;         //12 consumo planejado SEM ARREDONDAMENTO
   	     		 "000",;            //12  //-- NAO USADO
   	     		 _nQtNec,;          //14 necessidade SEM ARREDONDAMENTO
   	     		 Round(nUVNova,2),;
   	     		 Round(nUVReaf,2),;
   	     		 TMP->ZDJ_QTREAF,;
   	     		 Round((nUVReaf * TMP->ZDJ_QTREAF),2),; //18 
	    		       Round(nUVNova +(TMP->ZDJ_QTREAF * nUVReaf),2),; //19
	    		 Round(Round(nUVNova +(TMP->ZDJ_QTREAF * nUVReaf),2)/(_nVidaUt),3),;  //20 Custo da ferramenta
   			     SB1->B1_LT,;
   			     0,;
   			     _cDesPro,;
   			     "1",;
   			     _cFornec,;
   			     nQtdPC,; //26 quantidade em pedidos abertos
   			     TMP->ZDJ_ARESTA,;
   			     TMP->ZDJ_FMONT,0,0,0,;
   			     nConFut,; //32 consumo futuro
   			     Posicione("SB1",1,xFilial("SB1")+TMP->ZDJ_FERRAM,'B1_EMIN'),;//33 Estoque mínimo
   			     nQtdSC})  //34 Quantidade em sc abertas
   
   	TMP->(Dbskip())
   	
Enddo

aLista := ASort(aLista,,, { |x, y| x[4]+X[3]< y[4]+Y[3]})  //orderna a matriz por produto+operacao+descricao da ferramenta + codigo ferramenta

If mv_par05 == 1 // Relatorio Analitico
    fRelAnali()
ElseIf mv_par05 == 2 // Relatorio Sintetico
   	fRelSint()
ElseIf mv_par05 == 3 .OR. mv_par05 == 4 // Relatorio Geral (Sr. Teodoro) OU Geral 2
	fRelGeral()
EndIf

Return	

/*
*******************************************************
//-- retirado decrementação conforme reunião (22/06)
*******************************************************
_nSaldo  := 0
_cProdut := ""
// Diminui o saldo 	do estoque conforme a necessidade da ferramenta
For _x:=1 to len(aLista)
      If alista[_x][4] <> _cProdut 
         
        //_nSaldo := (alista[_x][9]+alista[_x][10]) - alista[_x][12] //-- retirado decrementação conforme reunião (22/06)
        
        _cProdut := alista[_x][4] //atribui a ferramenta      
        alista[_x][24] := "0"
      else

		//alista[_x][9] := Iif(_nSaldo <0,0,_nSaldo) //-- retirado decrementação conforme reunião (22/06) 
        //alista[_x][14] := Iif((alista[_x][9] - alista[_x][12]) < 0,(alista[_x][9] - alista[_x][12])*-1,0) //NECESSIDADE
		        
        _nSaldo := Iif((alista[_x][9] - alista[_x][12]) < 0,0,alista[_x][9] - alista[_x][12])         
      Endif   
      
Next _x
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                   ³
//³ A N A L I T I C O ³
//³                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fRelAnali()
Local cabec1 := "                                                                      VIDA                EST.  EST.    EST.   CONSU.             CUSTO     CUSTO   NUM.    CUSTO          CUSTO    CUSTO        CUSTO    LEAD"
Local cabec2 := "IND. OP  FERRAMENTA                                     FORNECEDOR    UTIL   PC.   SC.    NOVA  REAF.   MIN.   PLANE.   NECES.    NOVA      REAF.   REAF.   TOT.REAF.      FER.     TOT.FER.     PEÇA     TIME"
Local nSomaEmin := 0

nVlrTot   := 0
_nTcoPla  := 0     
_nTGcoPla := 0     
_nTnec    := 0
_nTGnec   := 0
_nTcuPc   := 0 //Total do custo
_cProd    := ""

//orderna a matriz por produto + operacao + descricao da ferramenta + codigo ferramenta
aLista := ASort(aLista,,, { |x, y| x[1]+x[3]+x[5]+[4]+[24] < y[1]+y[3]+y[5]+y[4]+[24]})  

Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

SB1->(dbSetOrder(1))                             

For _x:=1 to len(aLista)
   
	IncProc("Processando Produtos ... " + alista[_x][5])     

	If Prow() > 58
		_nPag := _nPag + 1                            
      
  		Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)        

	   	SB1->(dbSeek(xFilial("SB1")+alista[_x,1])) //produto

      	@ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes do produto
      	@ Prow() + 1, 001 Psay  "PRODUTO :" + Subs(SB1->B1_COD,1,15) + " - " + Subs(SB1->B1_DESC,1,30) +" VOLUME PEÇAS MES : "+ Transform(alista[_x][6],"@E 9999999")+"  CUSTO TOTAL MÊS :"+Transform(_nTcoPla,"@E 9,999,999.99")+"       NECESSIDADE DE COMPRA MÊS :"+Transform(_nTnec,"@E 9,999,999.99")+space(15)+" CUSTO FER. POR PEÇA : " +Transform(_nTcuPc,"@E 9,999,999.999")  
		@ Prow() + 1, 001 Psay __PrtThinLine() // Linha deopois do produto

   Elseif _cProd <> alista[_x][1] //produto

      	_nTcoPla := 0
      	_nTnec   := 0
      	_nTcuPc  := 0
      
      	_xx := _x 

      	While _xx <= len(alista) .and. alista[_x][1] == alista[_xx][1]

			//-- recalcula a necessidade total
			nNecTot := Ceiling(alista[_xx][12]) + Ceiling(alista[_xx][32])
			fCalcEmin(@nNecTot,_xx)

           	_nTcoPla += (alista[_xx][12] * alista[_xx][15]) // consumo planejado * val.nova
           	_nTnec   += nNecTot * alista[_xx][15]           // necess * val.nova  (alista[_xx][14] * alista[_xx][19]) // necessidade            
			_nTcuPc  += alista[_xx][19]/alista[_xx][8]        // soma do custo da peça

			_xx++
			
		EndDo

      	_nTGcoPla += _nTcoPla  // armazena o acumulado da soma do consumo planejado
     	_nTGnec   += _nTnec    // armazena o acumulado da soma da necessidade

	   	_cProd := alista[_x][1]
	   	SB1->(dbSeek(xFilial("SB1")+_cProd)) //produto   

      	@ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes do produto
      	@ Prow() + 1, 001 Psay  "PRODUTO :" + Subs(SB1->B1_COD,1,15) + " - " + Subs(SB1->B1_DESC,1,30) +" VOLUME PEÇAS MES : "+ Transform(alista[_x][6],"@E 9999999")+"  CUSTO TOTAL MÊS :"+Transform(_nTcoPla,"@E 9,999,999.99")+"       NECESSIDADE DE COMPRA MÊS :"+Transform(_nTnec,"@E 9,999,999.99")+space(15)+" CUSTO FER. POR PEÇA : " +Transform(_nTcuPc,"@E 9,999,999.999")  
		@ Prow() + 1, 001 Psay __PrtThinLine() // Linha deopois do produto
      	
      	nTotGer += nVlrTot
      	nVlrTot := 0
	
	Endif

	//-- recalcula a necessidade total
	nNecTot := Ceiling(alista[_x][12]) + Ceiling(alista[_x][32])
	fCalcEmin(@nNecTot,_x)
	
	//-- desconsidera se lista critica = sim e necessidade for zerada
	If mv_par06 == 1 .AND. nNecTot <= 0
		Loop
	EndIf
 
   	@ Prow()+1 , 001 Psay StrZero(_x,4)
   	@ Prow()   , 006 Psay alista[_x][3] + " " + alista[_x][4] + "-"+alista[_x][5] //"REB DAISHO 915X75X340 1SGK46R9" 
   	@ Prow()   , 056 Psay Subs(alista[_x][25],1,11)                // fornecedor            
   	@ Prow()   , 067 Psay Transform(alista[_x][7]    ,"@E 999999") //Vida util   
   	@ Prow()   , 073 Psay Transform(alista[_x][26]   ,"@E 99,999") //Pedido em aberto          	
   	@ Prow()   , 079 Psay Transform(alista[_x][34]   ,"@E 99,999") //SC em aberto          	
   	@ Prow()   , 088 Psay Transform(alista[_x][9]    ,"@E 9999")   //estoque ferramenta nova
   	@ Prow()   , 094 Psay Transform(alista[_x][10]   ,"@E 9999")   //estoque ferramenta reafiada             
   	@ Prow()   , 103 Psay Transform(alista[_x][33]   ,"@E 999")    //_nSalMin,"@E 999")    // Estoque minimo (necessidade /4)
   	@ Prow()   , 106 Psay Transform(alista[_x][12]   ,"@E 999999.99")   //Consumo planejado
   	@ Prow()   , 117 Psay Transform(Ceiling(nNecTot) ,"@E 99999.99")    //necessidade arredondada para cima
   	@ Prow()   , 127 Psay Transform(alista[_x][15]   ,"@E 99,999.99")   //Ultimo custo da ferramenta Nova
   	@ Prow()   , 136 Psay Transform(alista[_x][16]   ,"@E 99,999.99")   //Ultimo custo da ferramenta reafiada
   	@ Prow()   , 147 Psay Transform(alista[_x][17]   ,"@E 999")         // qtde de vezes de afiaçao
   	@ Prow()   , 152 Psay Transform(alista[_x][18]   ,"@E 999,999.99")  // custo total ferramenta afiada
   	@ Prow()   , 165 Psay Transform(alista[_x][19]*Ceiling(nNecTot),"@E 999,999.99") // custo da ferramenta
   	@ Prow()   , 177 Psay Transform(alista[_x][19]   ,"@E 999,999.99")             // custo total da ferramenta
   	@ Prow()   , 190 Psay Transform(alista[_x][19]/alista[_x][8],"@E 999.99999")   // custo por peça
   	@ Prow()   , 203 Psay Transform(alista[_x][21]   ,"@E 999")                    // Lead Time
  
Next _x

  @ Prow() + 1 , 001 Psay __PrtThinLine()
  @ Prow() + 1, 001 Psay  Space(30)+"   CUSTO TOTAL GERAL MÊS :"+Transform(_nTGcoPla,"@E 9,999,999.99")+"           NECESSIDADE TOTAL GERL DE COMPRA MÊS :"+Transform(_nTGnec,"@E 9,999,999.99")
   
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                   ³
//³ S I N T É T I C O ³
//³                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fRelSint()
Local aProd   := {}
Local nTotGer := 0
Local cDtAte  := DtoC(MV_PAR01)
Local nConFut := 0
Local nAux
Local nConTot 
Local nNecTot
Local nConFTot
Local nSomaEmin := 0

SB1->(dbSetOrder(1))

Cabec1 := "                                                                        EST.    EST.      CONSU.    EST.  CONSU. ATÉ              MEDIA ENTR.      CUSTO       CUSTO      CUSTO         NECES.    LEAD   FORNECEDOR"
Cabec2 := " OP  FERRAMENTA                                            PC.    SC.   NOVA    REAF.     PLANE.    MIN.  "+cDtAte+"    NECES.    ULT. 6 MESES     NOVA        REAF.      TOT.FER.      COMPRA    TIME"

Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

aSort(aLista,,, { |x,y| x[4] < y[4]}) //orderna a matriz por codigo ferramenta

ProcRegua(len(aLista))

For _x:=1 to len(aLista)

	nAux     := _x
	nNecTot  := 0 
	nConTot  := 0
	nConFut  := 0
	nConFTot := 0
	
	cFer := alista[_x][4] //ferramenta
	While alista[nAux][4]==cFer

		IncProc("Imprimindo ... " + alista[_x][4])
	
		nConFut := U_MRPConAte(alista[nAux][32],mv_par01-1) //traz o consumo planejado até a data de compra da necessidade
		
    	Aadd(aProd,{alista[nAux][3] ,; //operacao
		     	    alista[nAux][1] ,; //codigo
    	            Posicione("SB1",1,xFilial("SB1")+alista[nAux][1],"B1_DESC"),;   //descricao
    	            alista[nAux][6] ,; //volume por mes
    	            alista[nAux][14],; //necessidade
    	            alista[nAux][15],; //ultimo valor da ferramenta nova
    	            alista[nAux][12],; //consumo planejado
    	            alista[nAux][32]}) //consumo planejado futuro
		
		nConTot  += alista[nAux][12]   //-- soma o consumo planejado
		nConFTot += alista[nAux][32]   //-- soma o consumo plajenado futuro
		
		nAux++
		
		If nAux > len(aLista)
			exit
		EndIf
		
	EndDo

	//-- recalcula a necessidade total
	nNecTot := nConTot + Ceiling(nConFTot)

	fCalcEmin(@nNecTot,_x)
	
	//-- desconsidera se lista critica = sim e necessidade for zerada
	If mv_par06 == 1 .AND. nNecTot <= 0 
		aProd := {}
		_x := nAux-1 
		Loop
	EndIf
	
	nNecTot := Ceiling(nNecTot)
	
	//-- verifica para pular pagina
	If Prow() > 58
      	_nPag := _nPag + 1                            
      	Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)        
   	Endif

   	@ Prow()+1 , 005 Psay alista[_x][4] + " - "+alista[_x][5]            // Codigo - Descricao da ferramenta
   	@ Prow()   , 055 Psay Transform(alista[_x][26]   ,"@E 99,999")       // Pedido em aberto
   	@ Prow()   , 062 Psay Transform(alista[_x][34]   ,"@E 99,999")       // sc em aberto
   	@ Prow()   , 069 Psay Transform(alista[_x][9]    ,"@E 999999")       // estoque ferramenta nova
   	@ Prow()   , 077 Psay Transform(alista[_x][10]   ,"@E 999999")       // estoque ferramenta reafiada
   	@ Prow()   , 085 Psay Transform(Ceiling(nConTot) ,"@E 9999999.99")   // Consumo planejado
   	@ Prow()   , 096 Psay Transform(alista[_x][33]   ,"@E 999999")       // estoque mínimo
	@ Prow()   , 104 Psay Transform(Ceiling(nConFTot),"@E 9999999.99")   // Consumo da data atual até a data de entrega do pedido
   	@ Prow()   , 117 Psay Transform(nNecTot ,"@E 99999.99")     // necessidade arredondada para cima
   	@ Prow()   , 130 Psay Transform(Ceiling(fQtEnt6M(alista[_x][4])),"@e 99999.99") // media Quantidade de entrada dos ultimos 6 meses
   	@ Prow()   , 142 Psay Transform(alista[_x][15]   ,"@E 999,999.99")   // Ultimo valor da ferramenta Nova
   	@ Prow()   , 153 Psay Transform(alista[_x][16]   ,"@E 999,999.99")   // Ultimo valor da ferramenta reafiada
   	@ Prow()   , 164 Psay Transform(alista[_x][19]   ,"@E 9,999,999.99") // Custo total de ferramenta
   	@ Prow()   , 178 Psay Transform(alista[_x][15]*nNecTot,"@E 9,999,999.99")  // Necessodade de Compra
   	@ Prow()   , 194 Psay Transform(alista[_x][21]   ,"@E 999")          // Lead Time
   	@ Prow()   , 201 Psay alista[_x][25]                                 // Fornecedor

   	nTotGer += alista[_x][15]*nNecTot //soma o custo total geral
   	
   	aSort(aProd,,,{|x,y| x[1]+x[2] < y[1]+y[2]}) //ordena a matriz por operação + produto
   	
   	For _nx:=1 to Len(aProd)
		If Prow() > 58
	      	_nPag := _nPag + 1                            
	      	Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)        
	   	Endif
	
       	@ Prow() +1, 001 Psay aProd[_nx][1] // operacao
      	@ Prow()   , 005 Psay aProd[_nx][2] + " - " + aProd[_nx][3] //peça e descricao 
      	@ Prow()   , 055 Psay "VOL. PÇ MES: " + Transform(aProd[_nx][4],"@E 9999999") //vol pç mes 
   	   	@ Prow()   , 085 Psay Transform(aProd[_nx][7],"@E 9999999.99")                // Consumo planejado
		@ Prow()   , 104 Psay Transform(aProd[_nx][8],"@e 9999999.99") //consumo futuro
   	Next _nx

   	aProd:= {} //zera a matriz
   	@ Prow() +1, 001 Psay __PrtThinLine() // Linha antes do produto  

	_x := nAux-1    

Next _x
                                                                                                           
	@ Prow()+1 , 160 Psay "Total Geral:"
	@ Prow()   , 176 Psay Transform(nTotGer,"@E 999,999,999.99")   // Custo total de compra da ferramenta
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³           ³
//³ G E R A L ³
//³           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fRelGeral()

   	aLista := ASort(aLista,,, { |x, y| x[5]+x[4]+x[23]+x[24] < y[5]+y[4]+y[23]+x[24]})  //orderna a matriz por produto+operacao+descricao da ferramenta + codigo ferramenta

	nVlrTot := 0
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+alista[1][1]))
	
	_cProd := SB1->B1_COD
	Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
	@ Prow() +1, 001 Psay "                                                                                          VIDA  NUM.      FER.  CUSTO     CUSTO  VOL.   EST. EST.  EST.  CONSU.               CUSTO       CUSTO    CUSTO     CUSTO  LEAD"
	@ Prow() +1, 001 Psay "IND.   FERRAMENTA                  COD.FER.      APLICACAO               FORNECEDOR   OP  UTIL  REAF. AR. MON.  NOVA      REAF.  P/MES  NOVA REAF. MIN.  PLANE.  NECES.  PC   TOT.REAF.   FER.     TOT.FER.  PEÇA   TIME"
	_cCodFer :=""
	_cDesPro := ""
	_cFornec := ""
	For _x:=1 to len(aLista)
	   
	   IncProc("Processando Produtos ... " + alista[_x][5])     
	  
  	   //-- desconsidera se lista critica = sim e necessidade for zerada
	   If mv_par06 == 1 .AND. alista[_x][14] <= 0 
	  	  Loop
 	   EndIf
	   
	   If Prow() > 58
	      _nPag := _nPag + 1                            
	      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)        
	      @ Prow() +1, 001 Psay "                                                                                          VIDA  NUM.      FER.  CUSTO     CUSTO  VOL.   EST. EST.  EST.  CONSU.               CUSTO       CUSTO    CUSTO     CUSTO  LEAD"
	      @ Prow() +1, 001 Psay "IND.   FERRAMENTA                  COD.FER.      APLICACAO               FORNECEDOR   OP  UTIL  REAF. AR. MON.  NOVA      REAF.  P/MES  NOVA REAF. MIN.  PLANE.  NECES.  PC   TOT.REAF.   FER.     TOT.FER.  PEÇA   TIME"
	     
	   Endif
	   @ Prow()+1 , 001 Psay StrZero(_x,4)
	   If _cCodFer <> alista[_x][4] .OR. mv_par05==4 //+alista[_x][23] //controle para nao imprimir o mesmo codigo e descricao da ferramenta já impresso
	      @ Prow() , 006 Psay Subs(alista[_x][5],1,30) + " " + Subs(alista[_x][4],1,11) 
	      @ Prow() , 048 Psay Subs(alista[_x][23],1,25)
	      @ Prow() , 074 Psay Subs(alista[_x][25],1,11) // fornecedor      
	  //    _cCodFer := alista[_x][4]
	      _cDesPro := alista[_x][23]      
	      _cFornec := alista[_x][25] // fornecedor      
	   Else
	      If _cDesPro  <> alista[_x][23]    .OR. mv_par05==4 
	         @ Prow() , 048 Psay Subs(alista[_x][23],1,25)      
	         @ Prow()   , 074 Psay Subs(alista[_x][25],1,11) // fornecedor               
	           _cDesPro := alista[_x][23]               
	           _cFornec := alista[_x][25] // fornecedor                 
	      Else
	         If _cFornec <> alista[_x][25]   
	            @ Prow()   , 074 Psay Subs(alista[_x][25],1,11) // fornecedor               
	           _cFornec := alista[_x][25] // fornecedor                 
	           
	         Endif
	      
	      Endif
	   Endif      
	
	   @ Prow()   , 086 Psay alista[_x][3] //Operacao
	   @ Prow()   , 089 Psay Transform(alista[_x][7],"@E 999999") //Vida util   
	   @ Prow()   , 096 Psay Transform(alista[_x][17],"@E 999")  // qtde de vezes de afiaçao 
	   @ Prow()   , 103 Psay Transform(alista[_x][28],"@E 99")  // qtde de Arestas
	   @ Prow()   , 106 Psay Transform(alista[_x][27],"@E 99")  // qtde de ferramentas por montagem   
	   
	   @ Prow()   , 108 Psay Transform(alista[_x][15],"@E 99,999.99") //Ultimo custo da ferramenta Nova
	   @ Prow()   , 117 Psay Transform(alista[_x][16],"@E 99,999.99") //Ultimo custo da ferramenta reafiada
	   @ Prow()   , 128 Psay Transform(alista[_x][6],"@E 999,999") //Volume por mes
	
	   If _cCodFer <> alista[_x][4]//+alista[_x][23] //controle para nao imprimir o mesmo codigo e descricao da ferramenta já impresso   
	      @ Prow()   , 135 Psay Transform(alista[_x][9],"@E 9999") //estoque ferramenta nova
	      @ Prow()   , 140 Psay Transform(alista[_x][10],"@E 9999") //estoque ferramenta reafiada             
	      _cCodFer := alista[_x][4]//+alista[_x][23] //controle para nao imprimir o mesmo codigo e descricao da ferramenta já impresso      
	   Endif                            
	
	   if (alista[_x][11]-alista[_x][9]-alista[_x][10])/4 < 0 //calcula o estoque minimo
	      _nSalMin := 1
	   Else
	      _nSalMin := (alista[_x][11]-alista[_x][9]-alista[_x][10])/4 
	   Endif
	   
	   
	   @ Prow()   , 146 Psay Transform(_nSalMin,"@E 999")    // Estoque minimo (necessidade /4)
	
	   @ Prow()   , 149 Psay Transform(Ceiling(alista[_x][12]),"@E 999999.99")   //Consumo planejado ARREDONDADO PARA CIMA
	
       /*
	   if alista[_x][12]-alista[_x][9]-alista[_x][10] < 0 //calcula a necessidade
	      _nQtNec := 0
	   Else
	      _nQtNec := alista[_x][12]-alista[_x][9]-alista[_x][10]    
	   Endif
	   */       
	   
	   @ Prow()   , 158 Psay Transform(alista[_x][14],"@E 99999.99")    //necessidade    
	   @ Prow()   , 166 Psay Transform(alista[_x][26],"@E 99,999")    //Pedido em aberto       
	   @ Prow()   , 172 Psay Transform(alista[_x][18],"@E 999,999.99") // custo total ferramenta afiada
	   @ Prow()   , 182 Psay Transform(alista[_x][19]*alista[_x][14],"@E 999,999.99") // custo total da ferramenta
	   @ Prow()   , 192 Psay Transform(alista[_x][19],"@E 999,999.99") // custo total de ferramenta nova + reafiada
	   @ Prow()   , 204 Psay Transform(alista[_x][20],"@E 999.999") //custo por peça
	   @ Prow()   , 213 Psay Transform(alista[_x][21],"@E 999")    // Lead Time   
	       
	   nVlrTot += (alista[_x][14] * alista[_x][15]) //Armazena o valor necessario para atender a compra das ferramentas
	Next _x

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CALCULA O ESTOQUE MINIMO EM CIMA DA NECESSIDADE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCalcEmin(nNecTot,nPos)

	nNecTot -= alista[nPos][10] //subtrai as reafiadas que teoricamente devem ser consumidas por primeiro
	 
	//Se a quant. de reafiadas suprir a necessidade, soma o estoque minimo - (sal.nova + pedidos)
	If nNecTot <= 0
		nSomaEmin := alista[nPos][33] - (alista[nPos][26] + alista[nPos][9] + alista[nPos][34]) 
	Else
		//senao, tenta suprir a necessidade restante com as ferramentas novas e pedidos em aberto
		nNecTot -= (alista[nPos][26] + alista[nPos][9] + alista[nPos][34])

		//se suprir a necessidade, soma a necessidade (que estará negativa ou zerada) + estoque minimo
		If nNecTot <= 0
			nSomaEmin := nNecTot + alista[nPos][33] 
		Else
			//se nao suprir soma o estoque minimo
			nSomaEmin := alista[nPos][33]
		EndIf
	EndIf
	
	nNecTot := Iif(nNecTot < 0,0,nNecTot) //se for menor que zero, recebe zero
	
	nNecTot += Iif(nSomaEmin>0,nSomaEmin,0) //se o estoque for menor que o estoque minimo, soma a diferenca a necessidade

	//--------------------------------------------------------
	//-- solicitacao de RUBENSVM quando for FE51 ou FE53
	//-- arredondar a quantidade da necessidade para um numero
	//-- multiplo do campo B1_LE (Lote econômico)
	//--------------------------------------------------------
	If AllTrim(Posicione("SB1",1,xFilial("SB1")+alista[nPos][4],"B1_GRUPO")) $ "FE51/FE53"
		nLE := Posicione("SB1",1,xFilial("SB1")+alista[nPos][4],"B1_LE")
		
		If nNecTot < nLE
			nNecTot := nLE
		Else
			nNecTot := 	nNecTot - (nNecTot%nLE) + nLE
		EndIf
	EndIf
	
Return 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria as perguntas no SX3 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function CriaSx1()
PutSx1(cPerg,"01","Da Data?"       ,"Da Data?"        ,"Da data?"        ,"mv_ch1","D",08,0,0,"G","",""   ,"","","mv_par01","","","","","","","","","","","","","","","","",{"Da data"      ,"","",""},{"Da data"      ,"","",""},{"Da data"      ,"","",""},"")
PutSx1(cPerg,"02","Até a Data?"    ,"Até a Data?"     ,"Até a Data?"     ,"mv_ch2","D",08,0,0,"G","",""   ,"","","mv_par02","","","","","","","","","","","","","","","","",{"Até a data"   ,"","",""},{"Até a data"   ,"","",""},{"Até a data"   ,"","",""},"")
PutSx1(cPerg,"03","Do Produto?"    ,"Do Produto?"     ,"Do Produto?"     ,"mv_ch3","C",15,0,0,"G","","SB1","","","mv_par03","","","","","","","","","","","","","","","","",{"Do produto"   ,"","",""},{"Do produto"   ,"","",""},{"Do produto"   ,"","",""},"")
PutSx1(cPerg,"04","Até o Produto?" ,"Até o Produto?"  ,"Até o Produto?"  ,"mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04",""         ,""         ,""         ,"",""         ,""         ,""         ,""     ,""     ,""     ,""       ,""       ,""       ,"","","",{"Até o produto","","","" },{"Até o produto","","","" },{"Até o produto","","","" },"")
PutSx1(cPerg,"05","Tipo Relatorio?","Tipo Relatorio?" ,"Tipo Relatorio?" ,"mv_ch5","N",1 ,0,0,"C","",""   ,"","","mv_par05","Analitico","Analitico","Analitico","","Sintetico","Sintetico","Sintetico","Geral","Geral","Geral","Geral 2","Geral 2","Geral 2","","","",{"Tipo Relatorio","","",""},{"Tipo Relatorio","","",""},{"Tipo Relatorio","","",""},"")
PutSx1(cPerg,"06","Lista Critica?" ,"Lista Critica?"  ,"Lista Critica?"  ,"mv_ch6","N",1 ,0,0,"C","",""   ,"","","mv_par06","Sim"      ,"Sim"      ,"Sim"      ,"","Não"      ,"Não"      ,"Não"      ,""     ,""     ,""     ,""       ,""       ,""       ,"","","",{"Lista Critica" ,"","",""},{"Lista Critica" ,"","",""},{"Lista Critica" ,"","",""},"")
PutSx1(cPerg,"07","Da Ferramenta?" ,"Da Ferramenta?"  ,"Da Ferramenta?"  ,"mv_ch7","C",15,0,0,"G","","FER","","","mv_par07","","","","","","","","","","","","","","","","",{"Da Ferramenta"   ,"","",""},{"Da Ferramenta"   ,"","",""},{"Da Ferramenta"   ,"","",""},"")
PutSx1(cPerg,"08","Até Ferramenta?","Até Ferramenta?" ,"Até Ferramenta?" ,"mv_ch8","C",15,0,0,"G","","FER","","","mv_par08","","","","","","","","","","","","","","","","",{"Até Ferramenta?","","",""},{"Até Ferramenta?","","",""},{"Até Ferramenta?","","",""},"")

Return   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ A MEDIA DE ENTRADA DOS ULTIMOS 6 MESES ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fQtEnt6M(cProd)
Local cAlias := 'TMP4'
Local cDt1   := DtoS(dDataBase - 180)
Local cDt2   := DtoS(dDataBase)
Local nQuant := 0

	beginSql Alias cAlias
		select
			(SUM(SD1.D1_QUANT) / 6 ) as quant
		from 
			%table:SD1% SD1
		inner join
	        %table:SF4% SF4
		    on  SF4.F4_FILIAL  = %xFilial:SF4%
		    and SF4.F4_CODIGO  = SD1.D1_TES
		    and SF4.F4_ESTOQUE = 'S'
		    and SD1.D_E_L_E_T_ = ' '
		where
		    SD1.D1_FILIAL       = %xFilial:SD1%
			and SD1.D1_COD      = %Exp:cProd%
			and SD1.D1_ORIGLAN != 'LF'
			and SD1.D1_QUANT   != 0
			and SD1.D1_REMITO   = '         '
			and SD1.D_E_L_E_T_  = ' '
			and SD1.D1_EMISSAO BETWEEN %Exp:cDt1% AND %Exp:cDt2%
	endSql
	
   	If !(cAlias)->(Eof())
  	 	nQuant := (cAlias)->quant //-- media de entrada por mes dos ultimos 180 dias
	Else
		nQuant := 0
	EndIf
          
	(cAlias)->(dbCloseArea())
	
Return nQuant

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ O CONSUMO PREVISTO ATÉ A DATA DA CHEGADA DO PEDIDO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function MRPConAte(nZDJRecno,dData)
Local cAlias  := 'TMP5'
Local nVidaUt := 0
Local nQuant  := 0
Local nNecess := 0

	beginSql Alias cAlias
		SELECT
			SUM(HC.HC_QUANT) AS quant
		FROM
			%Table:SHC% HC , %Table:ZDJ% ZDJ
		WHERE 
			ZDJ.ZDJ_FILIAL = %xFilial:ZDJ%
			AND HC.HC_FILIAL = %xFilial:SHC%
			AND ZDJ.ZDJ_PROD = HC.HC_PRODUTO
			AND HC.HC_DATA BETWEEN %Exp:DtoS(date())% AND %Exp:DtoS(dData)%
            AND ZDJ.R_E_C_N_O_ = %Exp:nZDJRecno%
			AND HC.D_E_L_E_T_ = ' '
			AND ZDJ.D_E_L_E_T_ = ' '
	endSql

	If (cAlias)->(!eof())
	
		ZDJ->(dbGoTo(nZDJRecno))
		
		//calcula o consumo planejado
		nQuant += U_MRPFConP((cAlias)->quant)[1]

	EndIf
	
	(cAlias)->(dbCloseArea())

Return nQuant