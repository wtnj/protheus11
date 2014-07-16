#INCLUDE "LibrSal.ch"
#include "PROTHEUS.CH"        
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIBRSAL   º Autor ³ Julio Cesar        ºFecha ³  03/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprime o Livro Fiscal de Vendas ou Compras para o pais    º±±
±±º          ³ El Salvador.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LIBRSAL()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracion de Variables                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1   := STR0001 //"Este programa tiene como objetivo imprimir informe "
Local cDesc2   := STR0002 //"de acuerdo con los parámetros informados por el usuario."
Local cDesc3   := STR0042 //"Libro Fiscal"
Local cPict    := ""
Local titulo   := STR0042 //"Libro Fiscal"
Local nLin     := 71
Local Cabec1   := ""
Local Cabec2   := ""
Local imprime  := .T.
Local aOrd     := {}
Local cPerg    := "LV1SAL"
Local aAreaSF3 := {}
Local aAreaAtu := GetArea()

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "M"
Private nomeprog    := "LIBRSAL" // Coloque aquí el nombre del programa para impresión en el encabezamiento
Private nTipo       := 15
Private aReturn     := { "A Rayas", 1, "Administración", 2, 1, nomeprog, "", 2}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "LIBRSAL" // Coloque aquí el nombre del archivo usado para impresión en disco
Private cAliasSF3   := "SF3"
Private lQuery      := .F.
Private lLvrVenda   := .F.

// Verifica se eh uma base TopConnect
#IFDEF TOP
	If TCSrvType() != "AS/400"
		lQuery := .T.
	EndIf
#ENDIF	

// Caso as perguntas nao existam as cria no arquivo SX1                 
AjustaSx1()

// Determina qual livro sera impresso e o tamanho do relatorio                                     
If !Pergunte(cPerg,.T.)
	Return
Else
	lLvrVenda := (MV_PAR01==2)
	limite    := If(MV_PAR01==2,132,220)
	tamanho   := If(MV_PAR01==2,"M","G")
	cPerg     := "LV2SAL"
EndIf

// Carrega os parametros do relatorio 
Pergunte(cPerg,.F.)

////////////////////////////////
// MV_PAR01 => Mes ?          //
// MV_PAR02 => Ano ?          //
// MV_PAR03 => Filial de  ?   //
// MV_PAR04 => Filial Ate ?   //
////////////////////////////////

dbSelectArea("SF3")
aAreaSF3 := GetArea()
dbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta la interfase estandar con el usuario...                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cAliasSF3,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cAliasSF3)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Procesamiento. RPTSTATUS monta ventana con la regla de procesamiento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

// Restaura a area do arquivo SF3
RestArea(aAreaSF3)

// Restaura a area original da entrada da rotina
RestArea(aAreaAtu)

Return( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncion   ³RUNREPORT º Autor ³ Julio Cesar        ºFecha ³  03/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcion auxiliar llamada por la RPTSTATUS. La funcion      º±±
±±º          ³ RPTSTATUS monta la ventana con la regla de procesamiento.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRSAL                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cDataIni   := MV_PAR02+If(Len(AllTrim(MV_PAR01)) == 1,"0"+MV_PAR01,MV_PAR01)+"01"
Local cDatafim   := DTOS(LastDay(SToD(cDataIni)))
Local cFiltro    := ""
Local cChave     := ""
Local cIndexSF3  := ""
Local nIndice    := 0
Local aVendaCF   := {}
Local aVendaCO   := {}
Local aNotaCR    := {}
Local aCompras   := {}
Local cFilAtu    := ""
Local cSerAtu    := ""
Local cNotaAtu   := ""
Local dDataAtu   := ""
Local nContCO    := 0
Local nContCF    := 0
Local nContCP    := 0
Local nContGer   := 0
Local cNomeCliFor:= ""
Local cRF        := ""
Local cNIT       := ""
Local lFilSA1    := !Empty(xFilial("SA1"))
Local lFilSA2    := !Empty(xFilial("SA2"))
Local lFilSF2    := !Empty(xFilial("SF2"))
Local lFilSLU    := !Empty(xFilial("SLU"))
Local aTES       := {}
Local aInfTES    := {}
Local nPosTES    := 0
Local cCabec1    := ""
Local cCabec2    := ""
Local cCabec3    := ""
Local cLin       := ""
Local nI         := 0
Local nX         := 0
Local nTotExenCF := 0
Local nTotVIntCF := 0
Local nTotVProCF := 0
Local nTotBImpCF := 0
Local nTotVImpCF := 0
Local nTotExenCO := 0
Local nTotVIntCO := 0
Local nTotVentCO := 0
Local nTotVImpCO := 0
Local nTotExenCR := 0
Local nTotVIntCR := 0
Local nTotVentCR := 0
Local nTotVImpCR := 0
Local nPosFilial := 0
Local nPosNotaCR := 0
Local aResumo    := {}
Local aStruSF3   := {}
Local aAreaSF3   := {}
Local cCpoBAS    := ""
Local cCpoVAL    := ""
Local cCposSF3   := ""
Local lImprime   := .F.

Private cPictVal := "999,999,999.99"
Private cPictNF  := PesqPict("SF3","F3_NFISCAL")
Private cPictData:= PesqPict("SF3","F3_ENTRADA")
Private cPictCGC := If(lLvrVenda,PesqPict("SA1","A1_CGC"),PesqPict("SA2","A2_CGC"))
Private cPictInsc:= If(lLvrVenda,PesqPict("SA1","A1_INSCR"),PesqPict("SA2","A2_INSCR"))
Private cPictNome:= If(lLvrVenda,PesqPict("SA1","A1_NOME"),PesqPict("SA2","A2_NOME"))

//******************************************************
// Estrutura do Array aVendaCF                        //
//******************************************************
// [1] -> Filial                                      //
// [2] -> Totalizador por filial de Venda Isentas     //
// [3] -> Totalizador por filial de Vendas Internas   //
// [4] -> Totalizador por filial de Importacoes       //
// [5] -> Totalizador por filial de Vendas            //
// [6] -> Totalizador por filial de Base do Imposto   //
// [7] -> Totalizador por filial de Valor do Imposto  //
// [8][1] -> Data de Entrada da Fatura                //
// [8][2] -> Numero Inicial do Range da Fatura        //
// [8][3] -> Numero Final do Range da Fatura          //
// [8][4] -> Total de Faturas Isentas para o periodo  //
// [8][5] -> Total vendas internas para o periodo     //
// [8][6] -> Total de Importacoes para o periodo      //
// [8][7] -> Total Vendido no periodo                 //
////////////////////////////////////////////////////////

//******************************************************
// Estrutura do Array aVendaCO                        //
//******************************************************
// [1] -> Filial                                      //
// [2] -> Totalizador por filial de Venda Isentas     //
// [3] -> Totalizador por filial de Base de Imposto   //
// [4] -> Totalizador por filial de Vendas Internas   //
// [5] -> Totalizador por filial de Total deImposto   //
// [6][1] -> Contador                                 //
// [8][2] -> Data de Entrada                          //
// [8][3] -> Numero da Fatura                         //
// [8][4] -> Nome do Cliente                          //
// [8][5] -> Numero do Documento do Cliente           //
// [8][6] -> Total de Vendas Isentas                  //
// [8][7] -> Total de Base de Imposto                 //
// [8][8] -> Total de Vendas                          //
// [8][9] -> Total de Impostos                        //
////////////////////////////////////////////////////////

// Obs: A estrutura do array aNotaCR eh identica a 
// estrutura do array aVendaCO.

//**********************************************************
// Estrutura do Array aCompras                            //
//********************************************************//
// [01] -> Filial                                         //
// [02] -> Totalizador por filial de Vendas Isentas       //
// [03] -> Totalizador por filial de Importacoes          //
// [04] -> Totalizador por filial de Base de Imposto      //
// [05] -> Totalizador por filial de Importacoes          //
// [06] -> Totalizador por filial de Impostos (c/ doc)    //
// [07] -> Totalizador por filial de Impostos (s/ doc)    //
// [08] -> Totalizador por filial de Vendas               //
// [09] -> Totalizador por filial de Impostos a Terceiros //
// [10][01] -> Contador                                   //
// [10][02] -> Data de Entrada                            //
// [10][03] -> Numero da Fatura                           //
// [10][04] -> Numero do RF                               //
// [10][05] -> Numero do NIT ou DUI                       //
// [10][06] -> Nome do Cliente                            //
// [10][07] -> Valor da Venda Isenta                      //
// [10][08] -> Valor da Importacao (Isenta)               //
// [10][09] -> Base do Imposto                            //
// [10][10] -> Valor da Importacao (C/ Imposto)           //
// [10][11] -> Valor do Impostos (C/ Doc)                 //
// [10][12] -> Valor do Impostos (S/ Doc)                 //
// [10][13] -> Valor do Venda                             //
// [10][14] -> Imposto a Terceiros                        //
////////////////////////////////////////////////////////////

// Realiza o filtro dos dados, conforme os parametros informados
If !lQuery
	cFiltro := "(F3_FILIAL >= '"+MV_PAR03+"' .And. F3_FILIAL <= '"+MV_PAR04+"')"
   	cFiltro += " .And. (DTOS(F3_ENTRADA) >= '"+cDataIni+"' .And. DTOS(F3_ENTRADA) <= '"+cDataFim+"')"
   	cFiltro += " .And. Empty(F3_DTCANC)"      

   	If !lLvrVenda  
   		//Compras
    	cFiltro += " .And. F3_TIPOMOV == 'C'" 
   	Else
   		//Vendas
    	cFiltro += " .And. F3_TIPOMOV == 'V'"    
   	EndIf

   	cChave    := "F3_FILIAL+DTOS(F3_ENTRADA)+F3_SERIE+F3_NFISCAL"
   	cIndexSF3 := CriaTrab(NIL,.F.)

   	IndRegua(cAliasSF3,cIndexSF3,cChave,,cFiltro,STR0003) //"Filtrando registros..."
	nIndex	:=	RetIndex()
   	dbSetIndex(cIndexSF3+OrdBagExt())	
	dbsetorder(nIndex+1) 
	dbGoTop()  	
Else
	cAliasSF3 := "SF3TMP"
    aStruSF3  := dbStruct()

	cCposSF3  := "F3_FILIAL,F3_ENTRADA,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,"
    cCposSF3  += "F3_VALCONT,F3_TIPOMOV,F3_DTCANC,F3_TES,F3_EXENTAS,F3_ESPECIE"      
    For nX := 1 To Len(aStruSF3)
    	If "F3_BASIMP"$AllTrim(aStruSF3[nX][1]) .Or. "F3_VALIMP"$AllTrim(aStruSF3[nX][1])
    		cCposSF3 += ","+AllTrim(aStruSF3[nX][1])
    	EndIf
    Next nX

    cQuery := "SELECT "+cCposSF3
    cQuery += "FROM "+RetSqlName("SF3")+" "					
    cQuery += "WHERE "
    cQuery += "F3_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
    cQuery += "F3_ENTRADA BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND "
    cquery += "F3_DTCANC = '' AND "
    
    If !lLvrVenda
    	//Compras
        cQuery += "F3_TIPOMOV = 'C' AND " 
    Else
    	//Vendas
        cQuery += "F3_TIPOMOV = 'V' AND "    
    EndIf      
      
    cQuery += "D_E_L_E_T_<>'*' "
    cQuery += "ORDER BY F3_FILIAL,F3_ENTRADA,F3_SERIE,F3_NFISCAL"

	cQuery := ChangeQuery(cQuery)
 	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF3,.T.,.T.)
	For nX := 1 To Len(aStruSF3)
 		If AllTrim(aStruSF3[nX,1])$cCposSF3 .And. aStruSF3[nX,2] != "C" 
	 		TcSetField(cAliasSF3,aStruSF3[nX,1],aStruSF3[nX,2],aStruSF3[nX,3],aStruSF3[nX,4])
	   	EndIf
	Next nX
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica cuantos registros seran procesados para la regla ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(10)
While !Eof()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   	//³ Comprobar la anulacion por el usuario...                            ³
   	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	If lAbortPrint
    	@nLin,00 PSAY STR0004 //"*** CANCELADO PELO OPERADOR ***"
    	Exit
   	Endif
	
	// Verifica se os informacoes do TES ja foram pesquisadas
	If (nPosTES := aScan(aTES,{|x| Trim(x[1])==Trim(F3_TES)})) > 0
		cCpoBas := aTES[nPosTES][2]
		cCpoVal := aTES[nPosTES][3]	
	Else
		aInfTES := TesImpInf(F3_TES)
		If !Empty(aInfTES)		
			AAdd(aTES,{F3_TES,"F3"+SubStr(aInfTES[1][8],3),"F3"+SubStr(aInfTES[1][6],3)})
	
			cCpoBas := "F3"+SubStr(aInfTES[1][8],3)
			cCpoVal := "F3"+SubStr(aInfTES[1][6],3)
		Else 
			AAdd(aTES,{F3_TES,"F3_BASIMP1","F3_VALIMP1"})
	
			cCpoBas := "F3_BASIMP1"
			cCpoVal := "F3_VALIMP1"
		EndIf
	EndIf

	// Monta os arrays para futura impressao dos dados
	If lLvrVenda 	
		// Vendas
		If F3_FILIAL <> cFilAtu
	   		cFilAtu := F3_FILIAL
	   		cSerAtu := F3_SERIE
	   		cNotaAtu:= F3_NFISCAL+F3_SERIE
	   		dDataAtu:= Dtos(F3_ENTRADA)
	   		If SubStr(F3_SERIE,1,1) == "0"
	   			nContCO++
	   			If (SF3->F3_CLIEFOR == GetMv("MV_CLIPAD")) .AND. (SF3->F3_LOJA == GetMv("MV_LOJAPAD"))	   			                        
	   				aAreaSF3 := GetArea()
	   				dbSelectArea("SF2")
	   			   	dbSetOrder(1)
	   			   	If dbseek(If(lFilSF2,SF3->F3_FILIAL,xFilial("SF2"))+SF3->F3_NFISCAL+SF3->F3_SERIE+SF3->F3_CLIEFOR+SF3->F3_LOJA)
						If AllTrim(SF2->F2_ESPECIE) <> AllTrim(SF3->F3_ESPECIE)   			   	
							While !Eof() .And. SF3->F3_FILIAL+SF3->F3_NFISCAL+SF3->F3_SERIE+SF3->F3_CLIEFOR+SF3->F3_LOJA == ;
							      If(lFilSF2,SF3->F3_FILIAL,xFilial("SF2"))+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
	
								If AllTrim(SF2->F2_ESPECIE) <> AllTrim(SF3->F3_ESPECIE)   			   	        				
	        						dbSkip()
	       						Else 
	       							Exit
	       						EndIf
							End
						EndIf
						cRF := SF2->F2_REGFISC
					Else
						cRF := cRF := "         - "
					EndIf
					RestArea(aAreaSF3)
					
					If !Empty(cRF)					
						cNomeCliFor := SubStr(Posicione("SLU",1,If(lFilSLU,F3_FILIAL,xFilial("SLU"))+cRF,"LU_NOME"),1,30)
					Else
						cNomeCliFor := Space(30)
					EndIf
	   			Else
		   			cNomeCliFor := SubStr(Posicione("SA1",1,If(lFilSA1,F3_FILIAL,xFilial("SA1"))+F3_CLIEFOR+F3_LOJA,"A1_NOME"),1,30)
		   			cRF         := Posicione("SA1",1,If(lFilSA1,F3_FILIAL,xFilial("SA1"))+F3_CLIEFOR+F3_LOJA,"A1_CGC")
	   			EndIf
	   			AAdd(aVendaCO,{F3_FILIAL,F3_EXENTAS,FieldGet(FieldPos(cCpoBAS)),F3_VALCONT,FieldGet(FieldPos(cCpoVAL)),;
	   			     { StrZero(nContCO,4),F3_ENTRADA,F3_NFISCAL,cNomeCliFor,cRF,F3_EXENTAS,FieldGet(FieldPos(cCpoBAS)),F3_VALCONT,FieldGet(FieldPos(cCpoVAL)) }})
	
	   		ElseIf SubStr(F3_SERIE,1,1) == "1"
				nContCF++
				AAdd(aVendaCF,{F3_FILIAL,F3_EXENTAS,F3_VALCONT,0,F3_VALCONT,FieldGet(FieldPos(cCpoBAS)),FieldGet(FieldPos(cCpoVAL)),;
				     { F3_ENTRADA,F3_NFISCAL,F3_NFISCAL,F3_EXENTAS,F3_VALCONT,0,F3_VALCONT }})
	
			ElseIf SubStr(F3_SERIE,1,1) == "3"
	   			nContCO++
	   			If (SF3->F3_CLIEFOR == GetMv("MV_CLIPAD")) .AND. (SF3->F3_LOJA == GetMv("MV_LOJAPAD")) 	   			   
	   				aAreaSF3 := GetArea()
	   				dbSelectArea("SF2")
	   			   	dbSetOrder(1)
	   			   	If dbseek(If(lFilSF2,SF3->F3_FILIAL,xFilial("SF2"))+SF3->F3_NFISCAL+SF3->F3_SERIE+SF3->F3_CLIEFOR+SF3->F3_LOJA)
						If AllTrim(SF2->F2_ESPECIE) <> AllTrim(SF3->F3_ESPECIE)   			   	
							While !Eof() .And. SF3->F3_FILIAL+SF3->F3_NFISCAL+SF3->F3_SERIE+SF3->F3_CLIEFOR+SF3->F3_LOJA == ;
							      If(lFilSF2,SF3->F3_FILIAL,xFilial("SF2"))+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
	
								If AllTrim(SF2->F2_ESPECIE) <> AllTrim(SF3->F3_ESPECIE)   			   	        				
	        						dbSkip()
	       						Else 
	       							Exit
	       						EndIf
							End
						EndIf
						cRF := SF2->F2_REGFISC
					Else
						cRF := cRF := "         - "
					EndIf
					RestArea(aAreaSF3)

					If !Empty(cRF)					
						cNomeCliFor := SubStr(Posicione("SLU",1,If(lFilSLU,F3_FILIAL,xFilial("SLU"))+cRF,"LU_NOME"),1,30)
					Else
						cNomeCliFor := Space(30)
					EndIf
	   			Else
		   			cNomeCliFor := SubStr(Posicione("SA1",1,If(lFilSA1,F3_FILIAL,xFilial("SA1"))+F3_CLIEFOR+F3_LOJA,"A1_NOME"),1,30)
		   			cRF         := Posicione("SA1",1,If(lFilSA1,F3_FILIAL,xFilial("SA1"))+F3_CLIEFOR+F3_LOJA,"A1_CGC")
	   			EndIf
	   			AAdd(aNotaCR,{F3_FILIAL,F3_EXENTAS,FieldGet(FieldPos(cCpoBAS)),F3_VALCONT,FieldGet(FieldPos(cCpoVAL)),;
	   			     { StrZero(nContCO,4),F3_ENTRADA,F3_NFISCAL,cNomeCliFor,cRF,F3_EXENTAS,FieldGet(FieldPos(cCpoBAS)),F3_VALCONT,FieldGet(FieldPos(cCpoVAL)) }})
			
			EndIf
		Else
	   		If SubStr(F3_SERIE,1,1) == "0"
	   			nContCO++
	   			If (SF3->F3_CLIEFOR == GetMv("MV_CLIPAD")) .AND. (SF3->F3_LOJA == GetMv("MV_LOJAPAD"))	   			   
	   				aAreaSF3 := GetArea()
	   				dbSelectArea("SF2")
	   			   	dbSetOrder(1)
	   			   	If dbseek(If(lFilSF2,SF3->F3_FILIAL,xFilial("SF2"))+SF3->F3_NFISCAL+SF3->F3_SERIE+SF3->F3_CLIEFOR+SF3->F3_LOJA)
						If AllTrim(SF2->F2_ESPECIE) <> AllTrim(SF3->F3_ESPECIE)   			   	
							While !Eof() .And. SF3->F3_FILIAL+SF3->F3_NFISCAL+SF3->F3_SERIE+SF3->F3_CLIEFOR+SF3->F3_LOJA == ;
							      If(lFilSF2,SF3->F3_FILIAL,xFilial("SF2"))+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
	
								If AllTrim(SF2->F2_ESPECIE) <> AllTrim(SF3->F3_ESPECIE)   			   	        				
	        						dbSkip()
	       						Else 
	       							Exit
	       						EndIf
							End
						EndIf
						cRF := SF2->F2_REGFISC
					Else
						cRF := "         - "
					EndIf
					RestArea(aAreaSF3)

					If !Empty(cRF)					
						cNomeCliFor := SubStr(Posicione("SLU",1,If(lFilSLU,F3_FILIAL,xFilial("SLU"))+cRF,"LU_NOME"),1,30)
					Else
						cNomeCliFor := Space(30)
					EndIf
	   			Else
		   			cNomeCliFor := SubStr(Posicione("SA1",1,If(lFilSA1,F3_FILIAL,xFilial("SA1"))+F3_CLIEFOR+F3_LOJA,"A1_NOME"),1,30)
		   			cRF         := Posicione("SA1",1,If(lFilSA1,F3_FILIAL,xFilial("SA1"))+F3_CLIEFOR+F3_LOJA,"A1_CGC")
	   			EndIf
	   				
				// Caso tenha mudado a nota eh necessario atualizar o array de 
				// venda a contribuintes com os novos dados.
	   			If F3_NFISCAL+F3_SERIE <> cNotaAtu
		   			If Empty(aVendaCO) .Or. (aScan(aVendaCO,{|x| Trim(x[01]) == cFilAtu}) == 0)
			   			AAdd(aVendaCO,{F3_FILIAL,F3_EXENTAS,FieldGet(FieldPos(cCpoBAS)),F3_VALCONT,FieldGet(FieldPos(cCpoVAL)),;
			   			     { StrZero(nContCO,4),F3_ENTRADA,F3_NFISCAL,cNomeCliFor,cRF,F3_EXENTAS,FieldGet(FieldPos(cCpoBAS)),F3_VALCONT,FieldGet(FieldPos(cCpoVAL)) }})
			   		Else 
						// Atualiza os totalizadores mensais por filial				
						aVendaCO[Len(aVendaCO)][02] += F3_EXENTAS
						aVendaCO[Len(aVendaCO)][03] += FieldGet(FieldPos(cCpoBAS))
						aVendaCO[Len(aVendaCO)][04] += F3_VALCONT
						aVendaCO[Len(aVendaCO)][05] += FieldGet(FieldPos(cCpoVAL))
			   		
			   			AAdd(aVendaCO[Len(aVendaCO)],{ StrZero(nContCO,4),F3_ENTRADA,F3_NFISCAL,cNomeCliFor,cRF,F3_EXENTAS,FieldGet(FieldPos(cCpoBAS)),F3_VALCONT,FieldGet(FieldPos(cCpoVAL)) })
			   		EndIf
			   	Else                    
					// Como nao ocorreram mudancas no dado de "quebra" (nota),
					// apenas os totalizadores sao atualizados.
					
					// Atualiza os totalizadores mensais por filial				
					aVendaCO[Len(aVendaCO)][02] += F3_EXENTAS
					aVendaCO[Len(aVendaCO)][03] += FieldGet(FieldPos(cCpoBAS))
					aVendaCO[Len(aVendaCO)][04] += F3_VALCONT
					aVendaCO[Len(aVendaCO)][05] += FieldGet(FieldPos(cCpoVAL))
	
					// Atualiza os totalizadores por fatura
					aVendaCO[Len(aVendaCO)][Len(aVendaCO[Len(aVendaCO)])][6] += F3_EXENTAS
					aVendaCO[Len(aVendaCO)][Len(aVendaCO[Len(aVendaCO)])][7] += FieldGet(FieldPos(cCpoBAS))
					aVendaCO[Len(aVendaCO)][Len(aVendaCO[Len(aVendaCO)])][8] += F3_VALCONT
					aVendaCO[Len(aVendaCO)][Len(aVendaCO[Len(aVendaCO)])][9] += FieldGet(FieldPos(cCpoVAL))
			   	EndIf
			   	cNotaAtu := F3_NFISCAL+F3_SERIE
	
	   		ElseIf SubStr(F3_SERIE,1,1) == "1"
				// Caso tenha mudado a serie ou a data de entrada eh necessario atualizar
				// o array de venda a consumidores com os novos dados.
				nContCF++			                    
				If SubStr(F3_SERIE,1,1) <> SubStr(cSerAtu,1,1) .Or.;
				   Dtos(aVendaCF[Len(aVendaCF)][Len(aVendaCF[Len(aVendaCF)])][1]) < Dtos(F3_ENTRADA)
				
					cSerAtu := F3_SERIE
		   			If Empty(aVendaCF) .Or. (aScan(aVendaCF,{|x| Trim(x[01]) == cFilAtu}) == 0)
						AAdd(aVendaCF,{F3_FILIAL,F3_EXENTAS,F3_VALCONT,0,F3_VALCONT,FieldGet(FieldPos(cCpoBAS)),FieldGet(FieldPos(cCpoVAL)),;
						     { F3_ENTRADA,F3_NFISCAL,F3_NFISCAL,F3_EXENTAS,F3_VALCONT,0,F3_VALCONT }})
					Else
						aVendaCF[Len(aVendaCF)][02] += F3_EXENTAS
						aVendaCF[Len(aVendaCF)][03] += F3_VALCONT
						aVendaCF[Len(aVendaCF)][05] += F3_VALCONT
						aVendaCF[Len(aVendaCF)][06] += FieldGet(FieldPos(cCpoBAS))
						aVendaCF[Len(aVendaCF)][07] += FieldGet(FieldPos(cCpoVAL))
						AAdd(aVendaCF[Len(aVendaCF)],{ F3_ENTRADA,F3_NFISCAL,F3_NFISCAL,F3_EXENTAS,F3_VALCONT,0,F3_VALCONT })
					EndIf
				Else           
					// Como nao ocorreram mudancas nos dados de "quebra" (serie ou data),
					// apenas os totalizadores sao atualizados.
									
					// Atualiza os totalizadores mensais por filial
					aVendaCF[Len(aVendaCF)][02] += F3_EXENTAS
					aVendaCF[Len(aVendaCF)][03] += F3_VALCONT
					aVendaCF[Len(aVendaCF)][05] += F3_VALCONT
					aVendaCF[Len(aVendaCF)][06] += FieldGet(FieldPos(cCpoBAS))
					aVendaCF[Len(aVendaCF)][07] += FieldGet(FieldPos(cCpoVAL))
	
					// Atualiza os totalizadores diarios			
					aVendaCF[Len(aVendaCF)][Len(aVendaCF[Len(aVendaCF)])][3] := F3_NFISCAL				 
					aVendaCF[Len(aVendaCF)][Len(aVendaCF[Len(aVendaCF)])][4] += F3_EXENTAS
					aVendaCF[Len(aVendaCF)][Len(aVendaCF[Len(aVendaCF)])][5] += F3_VALCONT
					aVendaCF[Len(aVendaCF)][Len(aVendaCF[Len(aVendaCF)])][7] += F3_VALCONT				
				EndIf                         
				
			ElseIf SubStr(F3_SERIE,1,1) == "3"
	   			nContCO++
	   			If (F3_CLIEFOR == GetMv("MV_CLIPAD")) .AND. (F3_LOJA == GetMv("MV_LOJAPAD"))	   			           
	   				aAreaSF3 := GetArea()
	   				dbSelectArea("SF2")
	   			   	dbSetOrder(1)
	   			   	If dbseek(If(lFilSF2,SF3->F3_FILIAL,xFilial("SF2"))+SF3->F3_NFISCAL+SF3->F3_SERIE+SF3->F3_CLIEFOR+SF3->F3_LOJA)
						If AllTrim(SF2->F2_ESPECIE) <> AllTrim(SF3->F3_ESPECIE)   			   	
							While !Eof() .And. SF3->F3_FILIAL+SF3->F3_NFISCAL+SF3->F3_SERIE+SF3->F3_CLIEFOR+SF3->F3_LOJA == ;
							      If(lFilSF2,SF3->F3_FILIAL,xFilial("SF2"))+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
	
								If AllTrim(SF2->F2_ESPECIE) <> AllTrim(SF3->F3_ESPECIE)   			   	        				
	        						dbSkip()
	       						Else 
	       							Exit
	       						EndIf
							End
						EndIf
						cRF := SF2->F2_REGFISC
					Else
						cRF := cRF := "         - "
					EndIf
					RestArea(aAreaSF3)

					If !Empty(cRF)					
						cNomeCliFor := SubStr(Posicione("SLU",1,If(lFilSLU,F3_FILIAL,xFilial("SLU"))+cRF,"LU_NOME"),1,30)
					Else
						cNomeCliFor := Space(30)
					EndIf
	   			Else
		   			cNomeCliFor := SubStr(Posicione("SA1",1,If(lFilSA1,F3_FILIAL,xFilial("SA1"))+F3_CLIEFOR+F3_LOJA,"A1_NOME"),1,30)
		   			cRF         := Posicione("SA1",1,If(lFilSA1,F3_FILIAL,xFilial("SA1"))+F3_CLIEFOR+F3_LOJA,"A1_CGC")
	   			EndIf
	   				
				// Caso tenha mudado a nota eh necessario atualizar o array de 
				// notas de credito com os novos dados.
	   			If F3_NFISCAL+F3_SERIE <> cNotaAtu
		   			If Empty(aNotaCR) .Or. (aScan(aNotaCR,{|x| Trim(x[01]) == cFilAtu}) == 0)
			   			AAdd(aNotaCR,{F3_FILIAL,F3_EXENTAS,FieldGet(FieldPos(cCpoBAS)),F3_VALCONT,FieldGet(FieldPos(cCpoVAL)),;
			   			     { StrZero(nContCO,4),F3_ENTRADA,F3_NFISCAL,cNomeCliFor,cRF,F3_EXENTAS,FieldGet(FieldPos(cCpoBAS)),F3_VALCONT,FieldGet(FieldPos(cCpoVAL)) }})
			   		Else 
						// Atualiza os totalizadores mensais por filial				
						aNotaCR[Len(aNotaCR)][02] += F3_EXENTAS
						aNotaCR[Len(aNotaCR)][03] += FieldGet(FieldPos(cCpoBAS))
						aNotaCR[Len(aNotaCR)][04] += F3_VALCONT
						aNotaCR[Len(aNotaCR)][05] += FieldGet(FieldPos(cCpoVAL))
			   		
			   			AAdd(aNotaCR[Len(aNotaCR)],{ StrZero(nContCO,4),F3_ENTRADA,F3_NFISCAL,cNomeCliFor,cRF,F3_EXENTAS,FieldGet(FieldPos(cCpoBAS)),F3_VALCONT,FieldGet(FieldPos(cCpoVAL)) })
			   		EndIf
			   	Else                    
					// Como nao ocorreu mudanca no dado de "quebra" (nota),
					// apenas os totalizadores sao atualizados.
					
					// Atualiza os totalizadores mensais por filial				
					aNotaCR[Len(aNotaCR)][02] += F3_EXENTAS
					aNotaCR[Len(aNotaCR)][03] += FieldGet(FieldPos(cCpoBAS))
					aNotaCR[Len(aNotaCR)][04] += F3_VALCONT
					aNotaCR[Len(aNotaCR)][05] += FieldGet(FieldPos(cCpoVAL))
	
					// Atualiza os totalizadores diarios							
					aNotaCR[Len(aNotaCR)][Len(aNotaCR[Len(aNotaCR)])][6] += F3_EXENTAS
					aNotaCR[Len(aNotaCR)][Len(aNotaCR[Len(aNotaCR)])][7] += FieldGet(FieldPos(cCpoBAS))
					aNotaCR[Len(aNotaCR)][Len(aNotaCR[Len(aNotaCR)])][8] += F3_VALCONT
					aNotaCR[Len(aNotaCR)][Len(aNotaCR[Len(aNotaCR)])][9] += FieldGet(FieldPos(cCpoVAL))
			   	EndIf
			   	cNotaAtu := F3_NFISCAL+F3_SERIE
			EndIf
		EndIf
	Else
		If cFilAtu <> F3_FILIAL		
			nContCP++
			cNotaAtu    := F3_NFISCAL+F3_SERIE
			cFilAtu     := F3_FILIAL
			cNIT        := Posicione("SA2",1,If(lFilSA2,F3_FILIAL,xFilial("SA2"))+F3_CLIEFOR+F3_LOJA,"A2_INSCR")
			cRF         := Posicione("SA2",1,If(lFilSA2,F3_FILIAL,xFilial("SA2"))+F3_CLIEFOR+F3_LOJA,"A2_CGC")
			cNomeCliFor := SubStr(Posicione("SA2",1,If(lFilSA2,F3_FILIAL,xFilial("SA2"))+F3_CLIEFOR+F3_LOJA,"A2_NOME"),1,30)
		   	AAdd(aCompras,{F3_FILIAL,F3_EXENTAS,0,FieldGet(FieldPos(cCpoBAS)),0,;
			               Iif(!Empty(cRF),FieldGet(FieldPos(cCpoVAL)),0),;
                           Iif(Empty(cRF),FieldGet(FieldPos(cCpoVAL)),0),;
                           F3_VALCONT,0,;
			               {StrZero(nContCP,4),F3_ENTRADA,F3_NFISCAL,cRF,;
			                cNIT,cNomeCliFor,F3_EXENTAS,0,;
			                FieldGet(FieldPos(cCpoBAS)),0,;
			                Iif(!Empty(cRF),FieldGet(FieldPos(cCpoVAL)),0),;
			                Iif(Empty(cRF),FieldGet(FieldPos(cCpoVAL)),0),;
			                F3_VALCONT,0 }})
		Else
			// Caso tenha mudado a nota eh necessario atualizar o array de 
			// compras com os novos dados.
			If cNotaAtu <> F3_NFISCAL+F3_SERIE
				nContCP++
				cNotaAtu    := F3_NFISCAL+F3_SERIE
				cFilAtu     := F3_FILIAL
				cNIT        := Posicione("SA2",1,If(lFilSA2,F3_FILIAL,xFilial("SA2"))+F3_CLIEFOR+F3_LOJA,"A2_INSCR")
				cRF         := Posicione("SA2",1,If(lFilSA2,F3_FILIAL,xFilial("SA2"))+F3_CLIEFOR+F3_LOJA,"A2_CGC")
				cNomeCliFor := SubStr(Posicione("SA2",1,If(lFilSA2,F3_FILIAL,xFilial("SA2"))+F3_CLIEFOR+F3_LOJA,"A2_NOME"),1,30)

				AAdd(aCompras[Len(aCompras)],{StrZero(nContCP,4),F3_ENTRADA,;
				                               F3_NFISCAL,cRF,cNIT,cNomeCliFor,;
	                                           F3_EXENTAS,0,FieldGet(FieldPos(cCpoBAS)),0,;
	                                           Iif(!Empty(cRF),FieldGet(FieldPos(cCpoVAL)),0),;
			                                   Iif(Empty(cRF),FieldGet(FieldPos(cCpoVAL)),0),;
			                                   F3_VALCONT,0})
			Else
				// Como nao ocorreu mudanca no dado de "quebra" (nota),
				// apenas os totalizadores sao atualizados.

				// Atualiza os totalizadores por fatura
				aCompras[Len(aCompras)][Len(aCompras[Len(aCompras)])][07] += F3_EXENTAS
				aCompras[Len(aCompras)][Len(aCompras[Len(aCompras)])][09] += FieldGet(FieldPos(cCpoBAS))
				aCompras[Len(aCompras)][Len(aCompras[Len(aCompras)])][11] += Iif(!Empty(cRF),FieldGet(FieldPos(cCpoVAL)),0)
				aCompras[Len(aCompras)][Len(aCompras[Len(aCompras)])][12] += Iif(Empty(cRF),FieldGet(FieldPos(cCpoVAL)),0)
				aCompras[Len(aCompras)][Len(aCompras[Len(aCompras)])][13] += F3_VALCONT
			EndIf
			// Atualiza os totalizadores mensais por filial				
			aCompras[Len(aCompras)][02] += F3_EXENTAS
			aCompras[Len(aCompras)][04] += FieldGet(FieldPos(cCpoBAS)) 
			aCompras[Len(aCompras)][06] += Iif(!Empty(cRF),FieldGet(FieldPos(cCpoVAL)),0)
			aCompras[Len(aCompras)][07] += Iif(Empty(cRF),FieldGet(FieldPos(cCpoVAL)),0)
			aCompras[Len(aCompras)][08] += F3_VALCONT
		EndIf
	EndIf
	dbSkip() // Avanza el puntero del registro en el archivo
	IncRegua()
	If nContGer == 10
		nContGer := 1
	Else
		nContGer++
	EndIf
EndDo

// Vendas
If lLvrVenda
	// Realiza o acerto do array aVendaCF, para que o seu tamanho seja igual ou
	// maior que o array aVendaCO
	For nI := 1 To Len(aVendaCO)
		If aScan(aVendaCF,{|x| Trim(x[01]) == Trim(aVendaCO[nI][01])}) == 0
			AAdd(aVendaCF,{aVendaCO[nI][01]})
		EndIf
	Next nI
	aSort(aVendaCF,,,{|x,y| x[1] < y[1]})

	//          10        20        30        40        50        60        70        80        90        100       110       120       130
	//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	//                                   DOCUMENTO              VENTAS          VENTAS INTERNAS                        TOTAL VENTAS
	//                         DIA    DEL No.   AL No.         EXENTAS             GRAVADAS         EXPORTACIONES    DIARIAS PROPRIAS
	//                         ----   -----------------     --------------      ---------------    --------------    -----------------
	//
	//                          99    9999999   9999999     999.999.999,99       999.999.999,99    999.999.999,99     999.999.999,99
	
	cCabec1 := STR0005 //"          DOCUMENTO              VENTAS          VENTAS INTERNAS                        TOTAL VENTAS"
	cCabec2 := STR0006 //"DIA    DEL No.   AL No.         EXENTAS             GRAVADAS         EXPORTACIONES    DIARIAS PROPRIAS"
	cLin    := "----   -----------------     --------------      ---------------    --------------    -----------------"
	    
	Titulo  := STR0007+SM0->M0_CGC //"LIBRO DE VENTA A CONSUMIDORES     "
	SetRegua(nContCF+nContCO)
	For nI := 1 To Len(aVendaCF)
		If Len(aVendaCF[nI]) > 1
			For nX := 8 To Len(aVendaCF[nI])
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			   	//³ Comprobar la anulacion por el usuario...                            ³
			   	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			   	If lAbortPrint
			    	@nLin,00 PSAY STR0004 //"*** CANCELADO PELO OPERADOR ***"
			    	Exit
			   	Endif
			    
			   	// Determina que a impressao do cabecalho e totais deve
			   	// ser realizada.
			   	lImprime := .T.
			   
				If nLin > 70
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
				   	nLin := 06
				   	@ nLin,00 PSAY STR0008+If(Len(AllTrim(MV_PAR01)) == 1,"0"+MV_PAR01,MV_PAR01)+STR0009+MV_PAR02 //"Mes : "###"  Ano : "
					@ nLin,25 PSAY cCabec1
					nLin++
					@ nLin,25 PSAY cCabec2
					nLin++
					@ nLin,25 PSAY cLin
					nLin += 02
					@ nLin,10 PSAY STR0010+AllTrim(Str(nContCF+nContCO))+STR0011    //"TOTALES POR PUNTO DE VENTA     "###"     Creditos y Cobros"
					nLin += 02
				Endif                               
			
				@ nLin,026 PSAY SubStr(Dtos(aVendaCF[nI][nX][01]),7,2) Picture "99"
			   	@ nLin,032 PSAY aVendaCF[nI][nX][02] Picture cPictNF
		  	   	@ nLin,042 PSAY aVendaCF[nI][nX][03] Picture cPictNF
		   	   	@ nLin,054 PSAY aVendaCF[nI][nX][04] Picture cPictVal
		   	   	@ nLin,075 PSAY aVendaCF[nI][nX][05] Picture cPictVal
		   	   	@ nLin,093 PSAY aVendaCF[nI][nX][06] Picture cPictVal
		   	   	@ nLin,112 PSAY aVendaCF[nI][nX][07] Picture cPictVal  
		   	   	nLin++
		   	   	IncRegua()
			Next nX
		   	nLin++
			@ nLin,50 PSAY Replicate("-",78)                    
		   	nLin++ 
		   	@ nLin,024 PSAY STR0012 //"Totales del Mes"
		   	@ nLin,054 PSAY aVendaCF[nI][02] Picture cPictVal
		   	@ nLin,075 PSAY aVendaCF[nI][03] Picture cPictVal
		   	@ nLin,093 PSAY aVendaCF[nI][04] Picture cPictVal
		 	@ nLin,112 PSAY aVendaCF[nI][05] Picture cPictVal
		   	 
			nTotExenCF += aVendaCF[nI][02]
			nTotVIntCF += aVendaCF[nI][03]
			nTotVProCF += aVendaCF[nI][05]
			nTotBImpCF += aVendaCF[nI][06]
			nTotVImpCF += aVendaCF[nI][07]
	    EndIf
	    
		// Realiza a impressao do livro de contribuintes
		If ( nPosFilial := aScan(aVendaCO,{|x| Trim(x[01]) == Trim(aVendaCF[nI][01])}) ) > 0 .And.;
		   nI <> Len(aVendaCF)
	
			nPosNotaCR := aScan(aNotaCR,{|x| Trim(x[01]) == Trim(aVendaCF[nI][01])})	    
			nLin := 80
			ImpLvrContrib(aClone(aVendaCO[nPosFilial]),Iif(nPosNotaCR > 0,aClone(aNotaCR[nPosNotaCR]),{}),;
			              @nTotExenCO,@nTotVIntCO,@nTotVentCO,@nTotVImpCO,@nTotExenCR,;
			              @nTotVIntCR,@nTotVentCR,@nTotVImpCR,Titulo,@nLin,NomeProg,;
			              Tamanho,nContCF,nContCO)
			nLin := 80
		EndIf
	Next nI
	
	If lImprime .And. (nLin > 70)
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
	   	nLin := 06
	   	@ nLin,00 PSAY STR0008+If(Len(AllTrim(MV_PAR01)) == 1,"0"+MV_PAR01,MV_PAR01)+STR0009+MV_PAR02 //"Mes : "###"  Ano : "
		@ nLin,25 PSAY cCabec1
		nLin++
		@ nLin,25 PSAY cCabec2
		nLin++
		@ nLin,25 PSAY cLin
		nLin += 02
		@ nLin,10 PSAY STR0010+AllTrim(Str(nContCF+nContCO))+STR0011    //"TOTALES POR PUNTO DE VENTA     "###"     Creditos y Cobros"
	Endif                               
	
	If lImprime
		nLin += 04
		@ nLin,021 PSAY STR0013 //"TOTALES DEL MES   ........"
		@ nLin,054 PSAY nTotExenCF Picture cPictVal
		@ nLin,075 PSAY nTotVIntCF Picture cPictVal
		@ nLin,093 PSAY 0          Picture cPictVal
		@ nLin,112 PSAY nTotVProCF Picture cPictVal
		
		nLin += 03
		@ nLin,015 PSAY STR0014 //"CALCULO DEL DEBITO FISCAL POR OPERACIONES PROPIAS"
		nLin += 02
		@ nLin,015 PSAY STR0015 //"VENTAS INTERNAS GRAVADAS NETAS : "
		@ nLin,064 PSAY If(nTotBImpCF <> 0,nTotBImpCF,nTotExenCF) Picture cPictVal
		nLin++
		@ nLin,015 PSAY STR0016 //"13% IMPUESTO : "
		@ nLin,064 PSAY nTotVImpCF Picture cPictVal
		nLin++
		@ nLin,015 PSAY STR0017          //"TOTAL DE VENTAS GRAVADAS : "
		@ nLin,064 PSAY If(nTotBImpCF <> 0,nTotBImpCF+nTotVImpCF,nTotVIntCF) Picture cPictVal
		nLin += 05
		@ nLin,104 PSAY Replicate("-",23)
		nLin++
		@ nLin,108 PSAY STR0018 //"CONTADOR GENERAL"
		nLin++
		@ nLin,000 PSAY ""
	EndIf
	
	// Realiza a impressao do livro de contribuintes
	If ( nPosFilial := aScan(aVendaCO,{|x| Trim(x[01]) == Trim(aVendaCF[Len(aVendaCF)][01])}) ) > 0
	
		nPosNotaCR := aScan(aNotaCR,{|x| Trim(x[01]) == Trim(aVendaCF[Len(aVendaCF)][01])})	    
		nLin := 80
		ImpLvrContrib(aClone(aVendaCO[nPosFilial]),Iif(nPosNotaCR > 0,aClone(aNotaCR[nPosNotaCR]),{}),;
		              @nTotExenCO,@nTotVIntCO,@nTotVentCO,@nTotVImpCO,@nTotExenCR,;
		              @nTotVIntCR,@nTotVentCR,@nTotVImpCR,Titulo,@nLin,NomeProg,;
		              Tamanho,nContCF,nContCO)
	EndIf
	
	If nTotVentCO > 0
		lImprime := .T.
	   	nLin += 03                                      
	   	@ nLin,025 PSAY STR0019 //"Totales Mensual por Reporte"
	   	@ nLin,072 PSAY nTotExenCO - Iif(nTotExenCR > 0,nTotExenCR,0) Picture cPictVal
	   	@ nLin,087 PSAY nTotVIntCO - Iif(nTotVIntCR > 0,nTotVIntCR,0) Picture cPictVal  
	   	@ nLin,102 PSAY nTotVentCO - Iif(nTotVentCR > 0,nTotVentCR,0) Picture cPictVal     	
	   	@ nLin,117 PSAY nTotVImpCO - Iif(nTotVImpCR > 0,nTotVImpCR,0) Picture cPictVal     	
	EndIf
	nLin += 05
	
	//                     10        20        30        40        50        60        70        80        90
	//            12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	AAdd(aResumo,"+----------------------------------------------------+-------------------------------------+")
	AAdd(aResumo,"|                                                    |                 PROPIAS             |")
	AAdd(aResumo,STR0020) //"|              RESUMEN DE OPERACIONES                +------------------+------------------+"
	AAdd(aResumo,STR0043) //"|                                                    |    VALOR NETO    |   DEBITO FISCAL  |"
	AAdd(aResumo,"+----------------------------------------------------+------------------+------------------+")
	AAdd(aResumo,"                                                                        |                   ")
	AAdd(aResumo,"+----------------------------------------------------+------------------+------------------+")
	AAdd(aResumo,STR0021) //"| VENTAS NETAS INTERNAS GRAVADAS A CONTRIBUYENTES    | $                |                  |"
	AAdd(aResumo,STR0022) //"| VENTAS NETAS INTERNAS GRAVADAS A CONSUMIDORES..    |                  |                  |"
	AAdd(aResumo,STR0023) //"| NOTAS DE CREDITO...............................    |                  |                  |"
	AAdd(aResumo,"|                                                    +------------------+------------------+")
	AAdd(aResumo,STR0024) //"| TOTAL OPERACIONES INTERNAS GRABADAS............    |                  |                  |"
	AAdd(aResumo,"+----------------------------------------------------+------------------+------------------+")
	AAdd(aResumo,STR0025) //"| VENTAS NETAS INTERNAS EXENTAS A CONTRIBUYENTES     |                  |                  |"
	AAdd(aResumo,STR0026) //"| VENTAS NETAS INTERNAS EXENTAS A CONSUMIDORES..     |                  |                  |"
	AAdd(aResumo,STR0027) //"| NOTAS DE CREDITO..............................     |                  |                  |"
	AAdd(aResumo,"|                                                    +------------------+                  |")
	AAdd(aResumo,STR0028) //"| TOTAL OPERACIONES INTERNAS EXENTAS............     |                  |                  |"
	AAdd(aResumo,"|                                                    +------------------+                  |")
	AAdd(aResumo,STR0029) //"| EXPORTACIONES SEGUN FACTURACIOS DE EXPORTACION     |                  |                  |"
	AAdd(aResumo,"+----------------------------------------------------+------------------+------------------+")
	
	// Insere os valores no demonstrativo total
	aResumo[08] := Stuff(aResumo[08],57,14,Transform(nTotVIntCO,cPictVal))
	aResumo[08] := Stuff(aResumo[08],76,14,Transform(nTotVImpCO,cPictVal))
	aResumo[09] := Stuff(aResumo[09],57,14,Transform(nTotVIntCF,cPictVal))
	aResumo[09] := Stuff(aResumo[09],76,14,Transform(nTotVImpCF,cPictVal))
	aResumo[10] := Stuff(aResumo[10],57,14,Transform(nTotVIntCR,cPictVal))
	aResumo[10] := Stuff(aResumo[10],76,14,Transform(nTotVImpCR,cPictVal))
	aResumo[12] := Stuff(aResumo[12],57,14,Transform(nTotVIntCO+nTotVIntCF+nTotVIntCR,cPictVal))
	aResumo[12] := Stuff(aResumo[12],76,14,Transform(nTotVImpCO+nTotVImpCF+nTotVImpCR,cPictVal))
	aResumo[14] := Stuff(aResumo[14],57,14,Transform(nTotExenCO,cPictVal))
	aResumo[15] := Stuff(aResumo[15],57,14,Transform(nTotExenCF,cPictVal))
	aResumo[16] := Stuff(aResumo[16],57,14,Transform(nTotExenCR,cPictVal))
	aResumo[18] := Stuff(aResumo[18],57,14,Transform(nTotExenCO+nTotExenCF+nTotExenCR,cPictVal))
	aResumo[20] := Stuff(aResumo[20],57,14,Transform(0,cPictVal))
	
	// Imprime o demonstrativo final
	If lImprime
		// Verifica se existe espaco suficiente na pagina para impressao dos totais,
		// se nao houver salta para a proxima pagina.
		If (nLin + 28) > 70
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
		   	nLin := 06
		   	@ nLin,00 PSAY STR0008+If(Len(AllTrim(MV_PAR01)) == 1,"0"+MV_PAR01,MV_PAR01)+STR0009+MV_PAR02 //"Mes : "###"  Ano : "
			@ nLin,25 PSAY cCabec1
			nLin++
			@ nLin,25 PSAY cCabec2
			nLin++
			@ nLin,25 PSAY cLin
			nLin += 02
			@ nLin,10 PSAY STR0010+AllTrim(Str(nContCF+nContCO))+STR0011    //"TOTALES POR PUNTO DE VENTA     "###"     Creditos y Cobros"
		EndIf

		For nI := 1 To Len(aResumo)
			@ nLin,20 PSAY aResumo[nI]
			nLin++
		Next nI
		nLin += 05
		@ nLin,104 PSAY Replicate("-",23)
		nLin++
		@ nLin,108 PSAY STR0018 //"CONTADOR GENERAL"
		@ nLin,000 PSAY ""
	EndIf
Else 
	//          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
	//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	//                                           NIT o DUI de                                                                                           Compras Gravadas            Compras a                       Impuesto
	//      Fecha de    Numero de                sujetos                                                  Compras Exentas                                           Credito         sujetos         Total           retenido
	//No.   Emision     Documento  NRC           Excluidos          Nombre del Proveedor            Internas        Importacion     Internas        Importacion     Fiscal          Excluidos       Compras         a terceros
    //----  ----------  ---------  ------------  -----------------  ------------------------------  --------------  --------------  --------------  --------------  --------------  --------------  --------------  --------------
	//9999  9999/99/99  9999999    9999999999-9  9999-999999-999-9  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99  
 	
 	cCabec1 := STR0044 //"                                           NIT o DUI de                                                                                           Compras Gravadas            Compras a                       Impuesto"
	cCabec2 := STR0030 //"      Fecha de    Numero de                sujetos                                                  Compras Exentas                                           Credito         sujetos         Total           retenido"
	cCabec3 := STR0031 //"No.   Emision     Documento  NRC           Excluidos          Nombre del Proveedor            Internas        Importacion     Internas        Importacion     Fiscal          Excluidos       Compras         a terceros"
	cLin    := "----  ----------  ---------  ------------  -----------------  ------------------------------  --------------  --------------  --------------  --------------  --------------  --------------  --------------  --------------"
	Titulo  := STR0032 //"LIBRO O REGISTRO DE COMPRAS"
	SetRegua(nContGer)
	For nI := 1 To Len(aCompras)
		If nLin > 70
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
		   	nLin := 06
		   	@ nLin,00 PSAY STR0008+If(Len(AllTrim(MV_PAR01)) == 1,"0"+MV_PAR01,MV_PAR01)+STR0009+MV_PAR02 //"Mes : "###"  Ano : "
		   	nLin += 02
			@ nLin,00 PSAY cCabec1
			nLin++
			@ nLin,00 PSAY cCabec2
			nLin++
			@ nLin,00 PSAY cCabec3
			nLin++
			@ nLin,00 PSAY cLin
			nLin++
		Endif                               
		
		For nX := 10 To Len(aCompras[nI])
	   	   	@ nLin,000 PSAY aCompras[nI][nX][01] Picture "9999"
	   	   	@ nLin,006 PSAY aCompras[nI][nX][02] Picture cPictData
	   	   	@ nLin,018 PSAY aCompras[nI][nX][03] Picture cPictNF
	   	   	@ nLin,029 PSAY aCompras[nI][nX][04] Picture cPictCGC
	   	   	@ nLin,043 PSAY aCompras[nI][nX][05] Picture cPictInsc
	   	   	@ nLin,062 PSAY aCompras[nI][nX][06] Picture cPictNome
	   	   	@ nLin,094 PSAY aCompras[nI][nX][07] Picture cPictVal
	   	   	@ nLin,110 PSAY aCompras[nI][nX][08] Picture cPictVal    
	   	   	@ nLin,126 PSAY aCompras[nI][nX][09] Picture cPictVal    
	   	   	@ nLin,142 PSAY aCompras[nI][nX][10] Picture cPictVal    
	   	   	@ nLin,158 PSAY aCompras[nI][nX][11] Picture cPictVal              
	   	   	@ nLin,174 PSAY aCompras[nI][nX][12] Picture cPictVal    	   	   	
	   	   	@ nLin,190 PSAY aCompras[nI][nX][13] Picture cPictVal    	   	   	
	   	   	@ nLin,206 PSAY aCompras[nI][nX][14] Picture cPictVal    	   	   		   	   	
	   	   	nLin++
	   	   	IncRegua()
		Next nX
		nLin++
		@ nLin,046 PSAY STR0033+Replicate(".",25)+Space(16)+SubStr(cLin,094) //"Totales"
		nLin++

   	   	@ nLin,094 PSAY aCompras[nI][02] Picture cPictVal
   	   	@ nLin,110 PSAY aCompras[nI][03] Picture cPictVal    
   	   	@ nLin,126 PSAY aCompras[nI][04] Picture cPictVal    
   	   	@ nLin,142 PSAY aCompras[nI][05] Picture cPictVal    
   	   	@ nLin,158 PSAY aCompras[nI][06] Picture cPictVal              
   	   	@ nLin,174 PSAY aCompras[nI][07] Picture cPictVal    	   	   	
   	   	@ nLin,190 PSAY aCompras[nI][08] Picture cPictVal    	   	   	
   	   	@ nLin,206 PSAY aCompras[nI][09] Picture cPictVal    	   	   		   	   	

		nLin += 10
		@ nLin,194 PSAY Replicate("-",23)
		nLin++
		@ nLin,198 PSAY STR0018 //"CONTADOR GENERAL"
		nLin++
		@ nLin,000 PSAY ""	
		nLin := 80
	Next nI
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza la ejecucion del informe...                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Si imprime en disco, llama al gerente de impresion...               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

dbSelectArea(cAliasSF3)
If !lQuery 
	dbClearFilter()
	RetIndex("SF3")
	Ferase(cIndexSF3+OrdBagExt())
Else
	dbCloseArea()
	dbSelectArea("SF3")
EndIf

Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AjustaSX1 ºAutor  ³ Julio Cesar        º Data ³  03/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cria as perguntas caso nao existam                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRSAL                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

// LV1SAL
PutSx1("LV1SAL","01","Livro de           ?","Libro de           ?","From Fiscal Books  ?","mv_ch1","N",1,0,1,"C","","","","","mv_par01","Compras","Compras","Purchase","","Vendas","Ventas","Sales","","","","","","","","","")   

// LV2SAL
PutSx1("LV2SAL","01","Mes                ?","Mes                ?","Month              ?","mv_ch1","C",2,0,0,"G","NaoVazio() .And. ValidMes(MV_PAR01)","","","","mv_par01","","","","01","","","","","","","","","","","","")
PutSx1("LV2SAL","02","Ano                ?","Ano                ?","Year               ?","mv_ch2","C",4,0,0,"G","NaoVazio() .And. ValidAno(MV_PAR02)","","","","mv_par02","","","","2004","","","","","","","","","","","","")
PutSx1("LV2SAL","03","Filial de          ?","Sucursal De        ?","From Branch        ?","mv_ch3","C",2,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1("LV2SAL","04","Filial Ate         ?","Sucursal Hasta     ?","To Branch          ?","mv_ch4","C",2,0,0,"G","","","","","mv_par04","","","","ZZ","","","","","","","","","","","","")



Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ValidMes  ºAutor  ³ Julio Cesar        º Data ³  03/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica se o mes informado como parametro eh valido.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRSAL                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function ValidMes(cMes)

Local lRet := .T.

lRet := Val(cMes) > 0 .And. Val(cMes) < 13

Return( lRet )  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ValidAno  ºAutor  ³ Julio Cesar        º Data ³  03/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica se o ano informado como parametro eh valido.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRSAL                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function ValidAno(cAno)

Local lRet := .T.

lRet := Val(cAno) > 1900 .And. Val(cAno) <= Year(dDataBase)

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ImpLvrContribºAutor  ³ Julio Cesar        º Data ³  03/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Realiza a impressao do livro fiscal a Contribuintes.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRSAL                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpLvrContrib(aVendaCO,aNotaCR,nTotExenCO,nTotVIntCO,;
			    nTotVentCO,nTotVImpCO,nTotExenCR,nTotVIntCR,nTotVentCR,;
			    nTotVImpCR,Titulo,nLin,NomeProg,Tamanho,nContCF,nContCO)

Local nX      := 0
Local cCabec1 := ""
Local cCabec2 := ""
Local cCabec3 := ""
Local lCredito:= .F.
Local lImprime:= .F.

//          10        20        30        40        50        60        70        80        90        100       110       120       130
//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
//                                                                               OPERACIONES DE VENTAS PROPRIAS
//     FECHA DE   CORRELATIVO                                                            INTERNAS                            IVA
// No. EMISION    PREIMPRESO  NOMBRE DE CLIENTE              NRC          EXENTAS        GRAVADAS       TOTAL          (DEBITO FISCAL)
//9999 99/99/9999 9999999     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 9999999999-9 999.999.999,99 999.999.999,99 999.999.999,99 999.999.999,99  

cCabec1 := "                                                                               OPERACIONES DE VENTAS PROPRIAS" 
cCabec2 := STR0034 //"     FECHA DE   CORRELATIVO                                                            INTERNAS                            IVA"
cCabec3 := STR0035 //" No. EMISION    PREIMPRESO  NOMBRE DE CLIENTE              NRC          EXENTAS        GRAVADAS       TOTAL          (DEBITO FISCAL)"
Titulo  := STR0036 //"LIBRO DE VENTA A CONTRIBUYENTES"
// Realiza a impressoa das Vendas a Contribuintes
For nX := 6 To Len(aVendaCO)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   	//³ Comprobar la anulacion por el usuario...                            ³
   	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	If lAbortPrint
    	@nLin,00 PSAY STR0004 //"*** CANCELADO PELO OPERADOR ***"
    	Exit
   	Endif

   	// Determina que a impressao do cabecalho e totais deve
   	// ser realizada.
   	lImprime := .T.

	If nLin > 70
		Cabec(Titulo,"","",NomeProg,Tamanho,GetMv("MV_COMP"))
	   	nLin := 06
	   	@ nLin,00 PSAY STR0037+If(Len(AllTrim(MV_PAR01)) == 1,"0"+MV_PAR01,MV_PAR01)+STR0038+MV_PAR02 //"M E S . "###"  A N O . "
		nLin++                
		@ nLin,00 PSAY cCabec1
		nLin += 02
		@ nLin,00 PSAY cCabec2
		nLin++
		@ nLin,00 PSAY cCabec3
		nLin += 02
		@ nLin,10 PSAY STR0039+AllTrim(Str(nContCF+nContCO))+STR0011    //"PUNTO DE VENTAS--->     "###"     Creditos y Cobros"
		nLin += 02
	Endif                               
	@ nLin,000 PSAY aVendaCO[nX][01] Picture "9999"
 	@ nLin,005 PSAY aVendaCO[nX][02] Picture cPictData
 	@ nLin,016 PSAY aVendaCO[nX][03] Picture cPictNF
	@ nLin,028 PSAY aVendaCO[nX][04] Picture cPictNome
   	@ nLin,059 PSAY aVendaCO[nX][05] Picture cPictCGC
   	@ nLin,072 PSAY aVendaCO[nX][06] Picture cPictVal
   	@ nLin,087 PSAY aVendaCO[nX][07] Picture cPictVal  
   	@ nLin,102 PSAY aVendaCO[nX][08] Picture cPictVal     	
   	@ nLin,117 PSAY aVendaCO[nX][09] Picture cPictVal     	
   	nLin++
   	IncRegua()
Next nX

// Realiza a impressao das notas de Credito
If !Empty(aNotaCR) 
	lCredito := .T.
	nLin++
	   
	If nLin > 70
		Cabec(Titulo,"","",NomeProg,Tamanho,GetMv("MV_COMP"))
	   	nLin := 06
	EndIf

	@ nLin,00 PSAY STR0040 //"N O T A S   D E   C R E D I T O"
	nLin += 02
	
	For nX := 6 To Len(aNotaCR)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   	//³ Comprobar la anulacion por el usuario...                            ³
	   	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   	If lAbortPrint
	    	@nLin,00 PSAY STR0004 //"*** CANCELADO PELO OPERADOR ***"
	    	Exit
	   	Endif
		   
		If nLin > 70
			Cabec(Titulo,"","",NomeProg,Tamanho,GetMv("MV_COMP"))
		   	nLin := 06
		EndIf

		@ nLin,000 PSAY aNotaCR[nX][01] Picture "9999"
	 	@ nLin,005 PSAY aNotaCR[nX][02] Picture cPictData
	 	@ nLin,016 PSAY aNotaCR[nX][03] Picture cPictNF
		@ nLin,028 PSAY aNotaCR[nX][04] Picture cPictNome
	   	@ nLin,059 PSAY aNotaCR[nX][05] Picture cPictCGC
	   	@ nLin,072 PSAY aNotaCR[nX][06] Picture cPictVal
	   	@ nLin,087 PSAY aNotaCR[nX][07] Picture cPictVal  
	   	@ nLin,102 PSAY aNotaCR[nX][08] Picture cPictVal     	
	   	@ nLin,117 PSAY aNotaCR[nX][09] Picture cPictVal     	
	   	nLin++
	   	IncRegua()
	Next nX
EndIf

If lImprime
	nLin++
	@ nLin,71 PSAY Replicate("-",60)                    
	nLin++ 
	@ nLin,025 PSAY STR0041 //"Totales Mensual por Punto de Venta"
	@ nLin,072 PSAY aVendaCO[02] - Iif(lCredito,aNotaCR[02],0) Picture cPictVal
	@ nLin,087 PSAY aVendaCO[03] - Iif(lCredito,aNotaCR[03],0) Picture cPictVal
	@ nLin,102 PSAY aVendaCO[04] - Iif(lCredito,aNotaCR[04],0) Picture cPictVal
	@ nLin,117 PSAY aVendaCO[05] - Iif(lCredito,aNotaCR[05],0) Picture cPictVal
	
	nTotExenCO += aVendaCO[02]
	nTotVIntCO += aVendaCO[03]
	nTotVentCO += aVendaCO[04]
	nTotVImpCO += aVendaCO[05]
EndIf
                              
If lCredito
	nTotExenCR += aNotaCR[02]
	nTotVIntCR += aNotaCR[03]
	nTotVentCR += aNotaCR[04]
	nTotVImpCR += aNotaCR[05]
EndIf

Return( Nil )