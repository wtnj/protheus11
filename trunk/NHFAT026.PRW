#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ NHFAT026   บAutor ณJoใo Felipe         บ Data ณ  25/01/08  บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ RELATORIO DE ฺLTIMAS ENTRADAS E SAอDAS                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FISCAL	                                                  บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


//mv_par01 = do produto
//mv_par02 = ate produto
//mv_par03 = TIPO
//mv_par04 = DT LIMITE
//mv_par05 = QUANTIDADE DE PRODUTOS
//MV_PAR06 = POR PRODUTO (SIM/NAO) 

User Function NHFAT026()   

cString   := "SB1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir ")
cDesc2    := OemToAnsi("a rela็ใo das ๚ltimas movimenta็๕es.")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHFAT026"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATORIO DE MOVIMENTACOES RECENTES")    	            
cabec1    := " NF   Serie  Data        Produto                                  Fornecedor                        Quant   V.Unitแrio     V.Total"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHFAT026"
_cPerg    := "FAT026"  
_AMAT 	  := {}
 
Pergunte(_cPerg,.F.)

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if Empty(mv_par03) .Or. (Substr(mv_par03,1,1) <> "'" .And. Substr(mv_par03,1,1) <> '"');
    	.Or. (Substr(mv_par03,len(alltrim(mv_par03)),1) <> "'" .And. Substr(mv_par03,len(alltrim(mv_par03)),1) <> '"')
	  MsgAlert("Tipo de produto invแlido, Verifique!")
	  Return
EndIf

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]      

If mv_par06 == 1
	Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
ElseIf mv_par06 == 2 
	Processa( {|| Gerando2()   },"Gerando Dados para a Impressao")
EndIf

Processa( {|| RptDetail()   },"Imprimindo...")  

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function Gerando()
Local cQuery
Local _nTotal := 0
Local _lEspaco := .f.

//-----------------------------------------------------------------------
// MONTA A QUERY
//-----------------------------------------------------------------------		

	cQuery1 := "SELECT B1.B1_COD  FROM "+RetSqlName('SB1')+ " B1"
	cQuery1 += " WHERE B1.B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"			
	cQuery1 += " AND B1.B1_TIPO IN ("+mv_par03+")"
	cQuery1 += " AND B1.D_E_L_E_T_ = ' ' AND B1.B1_FILIAL = "+xFilial('SB1')
	cQuery1 += " ORDER BY B1.B1_COD"
	
	TCQUERY cQuery1 NEW ALIAS 'TRA1'
//    MemoWrit('C:\TEMP\FAT26-TRA.SQL',cQuery1)

	If	!USED()
		MsgBox(cQuery1+'. Query errada','Erro!!!','STOP')
	EndIf

	TRA1->(DbGotop())
	While TRA1->(!eof())
		
		cQuery := "SELECT TOP "+Str(mv_par05)+" D1.D1_DOC,D1.D1_SERIE,D1.D1_DTDIGIT,RTRIM(B1.B1_COD)+'-'+B1.B1_DESC AS PRODUTO,"
		cQuery += " A2.A2_COD+'-'+A2.A2_LOJA+' '+A2.A2_NOME AS FORNECE,"
		cQuery += " D1.D1_QUANT,D1.D1_VUNIT AS VUNIT,D1.D1_TOTAL"
		cQuery += " FROM "+RetSqlName('SD1')+" D1, "+RetSqlName('SB1')+" B1, "+RetSqlName('SA2')+" A2, "+RetSqlName('SF4')+" F4"
		cQuery += " WHERE D1.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = ' ' AND A2.D_E_L_E_T_ = ' ' AND F4.D_E_L_E_T_ = ' '"
		cQuery += " AND D1.D1_DTDIGIT <= '"+DtoS(mv_par04)+"'"
		cQuery += " AND B1.B1_COD = D1.D1_COD"
		cQuery += " AND B1.B1_COD = '"+AllTrim(TRA1->B1_COD)+"'"
		cQuery += " AND D1.D1_FORNECE = A2.A2_COD"
		cQuery += " AND D1.D1_LOJA = A2.A2_LOJA"
		cQuery += " AND D1.D1_TES = F4.F4_CODIGO"
		cQuery += " AND F4.F4_ESTOQUE = 'S'"
		cQuery += " AND B1.B1_TIPO IN ("+mv_par03+")"
		cQuery += " ORDER BY D1.R_E_C_N_O_ DESC"

		TCQUERY cQuery NEW ALIAS 'TRB'
		TcSetField("TRB","D1_DTDIGIT","D")  // TRANSFORMA DE STRING PARA DATA

	    MemoWrit('C:\TEMP\FAT26-TRB.SQL',cQuery)
	
		If	!USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf
        
    	While TRB->(!EoF())
	        IF !Empty(TRB->D1_DOC)
   		    	aAdd(_aMat,{TRB->D1_DOC, TRB->D1_SERIE, TRB->D1_DTDIGIT, TRB->PRODUTO, TRB->FORNECE, TRB->D1_QUANT, TRB->VUNIT, TRB->D1_TOTAL})
	       		_lEspaco := .T.
       		EndIf
        	TRB->(DbSkip())
   	 	EndDo

    	If _lEspaco
    		aAdd(_aMat,{"","","","","","","",""})
    		_lEspaco := .F.
    	EndIf
        
        DbCloseArea('TRB')
    	
		TRA1->(dBsKIP())
	EndDo
	
	DbCloseArea('TRA1')

Return

//---------------------------------
// Impressใo
//---------------------------------

Static Function Gerando2()

		cQuery := "SELECT TOP "+Str(mv_par05)+" D1.D1_DOC,D1.D1_SERIE,D1.D1_DTDIGIT,RTRIM(B1.B1_COD)+'-'+B1.B1_DESC AS PRODUTO,"
		cQuery += " A2.A2_COD+'-'+A2.A2_LOJA+' '+A2.A2_NOME AS FORNECE,"
		cQuery += " D1.D1_QUANT,D1.D1_VUNIT AS VUNIT,D1.D1_TOTAL"
		cQuery += " FROM "+RetSqlName('SD1')+" D1, "+RetSqlName('SB1')+" B1, "+RetSqlName('SA2')+" A2, "+RetSqlName('SF4')+" F4"
		cQuery += " WHERE D1.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = ' ' AND A2.D_E_L_E_T_ = ' ' AND F4.D_E_L_E_T_ = ' '"
		cQuery += " AND D1.D1_DTDIGIT <= '"+DtoS(mv_par04)+"'"
		cQuery += " AND B1.B1_COD = D1.D1_COD"
		cQuery += " AND B1.B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
		cQuery += " AND D1.D1_FORNECE = A2.A2_COD"
		cQuery += " AND D1.D1_LOJA = A2.A2_LOJA"
		cQuery += " AND D1.D1_TES = F4.F4_CODIGO"
		cQuery += " AND F4.F4_ESTOQUE = 'S'"
		cQuery += " AND B1.B1_TIPO IN ("+mv_par03+")"
		cQuery += " ORDER BY D1.R_E_C_N_O_ DESC"

		TCQUERY cQuery NEW ALIAS 'TRB'
		TcSetField("TRB","D1_DTDIGIT","D")  // TRANSFORMA DE STRING PARA DATA

	    MemoWrit('C:\TEMP\FAT26-TRB.SQL',cQuery)
	
		If	!USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf  
		
    	While TRB->(!EoF())
	    	aAdd(_aMat,{TRB->D1_DOC, TRB->D1_SERIE, TRB->D1_DTDIGIT, TRB->PRODUTO, TRB->FORNECE, TRB->D1_QUANT, TRB->VUNIT, TRB->D1_TOTAL})
        	TRB->(DbSkip())
   	 	EndDo
   	 	
   	 	DbCloseArea('TRB')
Return

Static Function RptDetail()

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

For x := 1 to len(_aMat)

	If Prow() > 60
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	Endif

	@Prow()+1, 001 psay _aMat[x][1] //NF
	@Prow()  , 009 psay _aMat[x][2] //SERIE
	@Prow()  , 013 psay _aMat[x][3] //DATA
	@Prow()  , 025 psay Substr(_aMat[x][4],1,40) //PROD
	@Prow()  , 067 psay Substr(_aMat[x][5],1,30) //FORN
	@Prow()  , 102 psay _aMat[x][6] //QUANT
	@Prow()  , 106 psay _aMat[x][7] Picture "@e 9,999,999.99"//V. UNITARIO
	@Prow()  , 118 psay _aMat[x][8] Picture "@e 9,999,999.99"//TOTAL

Next x

@ Prow()+1,000 PSAY __PrtThinLine()

Return(nil) 

