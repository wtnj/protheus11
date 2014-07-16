/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHCOM16 ºAutor ³João Felipe da Rosa º Data ³  06/08/2007   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                            				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras                                          		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#INCLUDE "FIVEWIN.CH"  
#INCLUDE "TOPCONN.CH"
User Function NHCOM016()   

SetPrvt("_aGrupo,_cCodUsr,aCols")
aCols    := {}                  
cString   := "SX5"
cDesc1    := OemToAnsi("Este relatório tem por objetivo imprimir a relação")
cDesc2    := OemToAnsi("dos ítens ")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHCOM016"
aLinha    := { }
nLastKey  := 0
titulo    := ""
cabec1    := OemToAnsi("Grupo                             Qtde        Média Unit.             Total s/ impostos                       %Total")
cabec2    := ""                 						
cabec3    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1  
wnrel     := "NHCOM016"
_cPerg    := "COM016" 
_AOrd	  := {}
    


// Parametros Utilizados
// mv_par01 = DE  EMISSAO
// mv_par02 = ATE EMISSAO
// mv_par03 = de tipo
// mv_par04 = ate tipo
// mv_par05 = do grupo
// mv_par06 = ate grupo
// mv_par07 = do fornecedor
// mv_par08 = ate fornecedor
// mv_par09 = da loja
// mv_par10 = ate loja
// mv_par11 = separado por (estoque, imobilizado, compras diretas) 
// mv_par12 = relatorio por (geral, grupo, fornecedor)
// mv_par13 = total c/ imp, total s/ imp

Pergunte(_cPerg,.T.) 

if mv_par12 == 1 .And. mv_par13 == 1
	cabec1    := OemToAnsi("Grupo                             Qtde        Média Unit.             Total c/ Impostos                       %Total")
EndIf

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,_AOrd,,tamanho)

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

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")

//TRB->(DbCloseArea()) 
//TR3->(DbCloseArea()) 

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
TRA1->(DbCloseArea())

Return

Static Function Gerando() 

		//-----------------------------------------------------------------------
		//  monta a query para o SD1 E SB1
		//-----------------------------------------------------------------------		

If mv_par12 == 1
		cQuery := "SELECT B1.B1_GRPPROD, SUM(D1.D1_QUANT) AS D1_QUANT, SUM(D1.D1_TOTAL) AS D1_TOTAL, SUM(D1_TOTAL*(1+(D1_IPI/100))) AS VALCIPI, SUM(D1_CUSTO) AS D1_CUSTO "
		cQuery += "FROM " + RetSqlName ('SD1')+ " D1, " + RetSqlName ('SB1') + " B1, " + RetSqlName ('SF4') + " F4 "
        cQuery += "WHERE D1.D1_FILIAL = '" + xFilial("SD1")+ "'"
        cQuery += "AND B1.B1_FILIAL = '" + xFilial("SB1")+ "'"      
        cQuery += "AND F4.F4_FILIAL = '" + xFilial("SF4")+ "'"                		
		cQuery += "AND B1.B1_COD = D1.D1_COD "
		cQuery += "AND D1.D1_TES = F4.F4_CODIGO "
		cQuery += "AND F4.F4_DUPLIC = 'S' "

//IMOBILIZADO (ESTOQUE/IMOBILIZADO/COMPRASDIRETAS/NAOUTILIZAR)
		If mv_par11 <> 4  //nao utilizar
			cQuery += "	AND F4_TIPO = 'E'"
		EndIF
		If mv_par11 == 1 //estoque 
			cQuery += " AND F4_ESTOQUE = 'S'"
		EndIf
		If mv_par11 == 2 //imobilizado
			cQuery += " AND F4_CF LIKE '%551'"
		EndIf
		If mv_par11 == 3//compras diretas
			cQuery += " AND F4_CF NOT LIKE '%551'"
			cQuery += " AND F4_ESTOQUE = 'N'"
		EndIf
        cQuery += "AND D1.D1_PEDIDO <> ' '"
        cQuery += "AND D1.D1_DTDIGIT BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "
        cQuery += "AND D1.D1_TP BETWEEN '" + mv_par03 + "' AND '" +  mv_par04 + "' "
        cQuery += "AND D1.D1_GRUPO BETWEEN '" + mv_par05 + "' AND '" +  mv_par06 + "' "
        cQuery += "AND D1.D1_FORNECE BETWEEN '" + mv_par07 + "' AND '" +  mv_par08 + "' "
        cQuery += "AND D1.D1_LOJA BETWEEN '" + mv_par09 + "' AND '" +  mv_par10 + "' "
		cQuery += "AND B1.D_E_L_E_T_ = ' ' "
 	 	cQuery += "AND D1.D_E_L_E_T_ = ' ' "
	 	cQuery += "AND F4.D_E_L_E_T_ = ' ' " 
		cQuery += "GROUP BY B1.B1_GRPPROD"

//		MemoWrit('C:\TEMP\TRA1.SQL',cQuery)
		TCQUERY cQuery NEW ALIAS 'TRA1'

		If	! USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf
EndIF

If mv_par12 == 2 .Or. mv_par12 == 3

	cQuery := " SELECT "
	If mv_par12 == 2 
		cQuery += "B1.B1_GRPPROD,"
	EndIf
	cQuery += " SUM(D1.D1_QUANT) AS D1_QUANT, SUM(D1.D1_TOTAL) AS D1_TOTAL , D1.D1_FORNECE, D1.D1_LOJA, SUM(D1_TOTAL*(1+(D1_IPI/100))) AS VALCIPI, SUM(D1_CUSTO) AS D1_CUSTO,"
	cQuery += " A2.A2_NOME, SUBSTRING(D1.D1_DTDIGIT,1,6) AS D1_DTDIGIT"
	cQuery += " FROM "+RetSqlName('SD1')+" D1, "+RetSqlName('SB1')+" B1, "+RetSqlName('SF4')+" F4, "+RetSqlName('SA2')+" A2 "
	cQuery += " WHERE D1.D1_FILIAL = '"+xFilial('SD1')+"'"
	cQuery += " AND B1.B1_FILIAL = '"+xFilial('SB1')+"'"
	cQuery += " AND F4.F4_FILIAL = '"+xFilial('SF4')+"'"
	cQuery += " AND B1.B1_COD = D1.D1_COD "
	cQuery += " AND D1.D1_TES = F4.F4_CODIGO "
	cQuery += " AND F4.F4_DUPLIC = 'S' "
	cQuery += " AND A2.A2_COD = D1.D1_FORNECE"
	cQuery += " AND A2.A2_LOJA = D1.D1_LOJA"
    cQuery += " AND D1.D1_PEDIDO <> ' '"
//IMOBILIZADO (ESTOQUE/IMOBILIZADO/COMPRASDIRETAS/NAOUTILIZAR)
	If mv_par11 <> 4  //nao utilizar
		cQuery += "	AND F4_TIPO = 'E'"
	EndIF
	If mv_par11 == 1 //estoque 
		cQuery += " AND F4_ESTOQUE = 'S'"
	EndIf
	If mv_par11 == 2 //imobilizado
		cQuery += " AND F4_CF LIKE '%551'"
	EndIf
	If mv_par11 == 3 //compras diretas
		cQuery += " AND F4_CF NOT LIKE '%551'"
		cQuery += " AND F4_ESTOQUE = 'N'"
	EndIf
	cQuery += " AND D1.D1_DTDIGIT BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "
	cQuery += " AND D1.D1_TP BETWEEN '" + mv_par03 + "' AND '" +  mv_par04 + "' "
	cQuery += " AND D1.D1_GRUPO BETWEEN '" + mv_par05 + "' AND '" +  mv_par06 + "' "
	cQuery += " AND D1.D1_FORNECE BETWEEN '" + mv_par07 + "' AND '" +  mv_par08 + "' "
	cQuery += " AND D1.D1_LOJA BETWEEN '" + mv_par09 + "' AND '" +  mv_par10 + "' "
	cQuery += " AND B1.D_E_L_E_T_ = ' ' AND D1.D_E_L_E_T_ = ' ' AND F4.D_E_L_E_T_ = ' ' "
	cQuery += " AND A2.D_E_L_E_T_ = ' '"
	cQuery += " GROUP BY "
	If mv_par12 == 2
		cQuery += "B1.B1_GRPPROD, "
	EndIf
	cQuery += " D1.D1_FORNECE,D1.D1_LOJA,A2.A2_NOME, SUBSTRING(D1.D1_DTDIGIT,1,6)"
	cQuery += " ORDER BY A2.A2_NOME, D1_LOJA,"
	If mv_par12 == 2
		cQuery += " B1_GRPPROD, D1_CUSTO,D1_TOTAL,"
	EndIF
	cQuery += " SUBSTRING(D1.D1_DTDIGIT,1,6)"
	
//	MemoWrit('C:\TEMP\TRA.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS 'TRA1'

	If	! USED()
		MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
	EndIf

EndIf

Return
Static Function RptDetail()  

Local _vMedUnit := 0
Local _vQuant := 0
Local _vSomaTotal := 0
Local _vTotal :=0   
Local _aEst := {}
Local _cForn := ""
Local _nCol
Local _aMat := {}
Local _aTotal := {0,0,0,0,0} 
Local _vCusto := 0
Local _vValcIpi := 0
Local _aIpi := {}
Local _aCst := {}
  
titulo    := OemToAnsi("ANÁLISE DE COMPRAS DE "+DtoC(mv_par01)+" ATÉ "+DtoC(mv_par02))

IF mv_par12 == 2
	cabec1  := OemToAnsi(" Fornecedor Descrição             Grupo                  Janeiro      Fevereiro    Marco        Abril        Maio         Junho        Julho        Agosto       Setembro     Outubro      Novembro     Dezembro")
EndIF

IF mv_par12 == 3                                            
	cabec1  := OemToAnsi(" Fornecedor Descrição                                    Janeiro      Fevereiro    Marco        Abril        Maio         Junho        Julho        Agosto       Setembro     Outubro      Novembro     Dezembro")
EndIF

Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo)                                    

DbSelectArea('TRA1') 

//-------------------------------------------------
// RELATORIO GERAL
//-------------------------------------------------    

if mv_par12 == 1

	While TRA1->( ! Eof() )
		If mv_par13 == 1 //c/ imp.
			_vSomaTotal += TRA1->VALCIPI
        Else 
			_vSomaTotal += TRA1->D1_CUSTO
		EndIf       
		TRA1->(DbSkip())
	ENDDO 
	
	TRA1->(DBGOTOP())
	
	While TRA1->( ! Eof() )
        _vQuant := TRA1->D1_QUANT

		if mv_par13 == 1 //c/ imp.
	        _vTotal := TRA1->VALCIPI
        Else  //s/ imp. 
        	_vTotal := TRA1->D1_CUSTO
		EndIf       
        _vCusto := TRA1->D1_CUSTO
        _vValcIpi := TRA1->VALCIPI
        _vMedUnit := _vTotal / _vQuant
        Aadd(_aEst,{TRA1-> B1_GRPPROD,; 									 //GRP PROD
        			Transform(TRA1->D1_QUANT,"@e 9,999,999,999"),;        //QUANT
        			Transform(_vMedUnit,"@e 9,999,999,999.99"),;         //MEDIA UNIT
        			Transform(_vTotal, "@e 9,999,999,999.99"), ;		 //TOTAL
        			Transform(((_vTotal*100)/_vSomaTotal),"@e 999.99"),; //%TOTAL
        			Transform(_vCusto,"@e 9,999,999,999.99"), ;			 //S/ IMPOSTOS
        			Transform(_vValcIpi,"@e 9,999,999,999.99")})      	 //C/ IMPOSTOS
   			_aTotal[1] += TRA1->D1_QUANT
			_aTotal[2] += _vMedUnit          
			_aTotal[3] += _vTotal
			_aTotal[4] += _vValcIpi //c/ impostos
			_aTotal[5] += _vCusto   //s/ impostos
	    TRA1->(DbSkip())  
	    
   	ENDDO   
   	
    _aEst:= ASort(_aEst,,, { |x, y| x[5] > y[5]})  
    
    For _nx:= 1 to len(_aEst)        
    
		if Prow() > 60
			Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo) 
		Endif
                                                 
		ZAQ->(DbSetOrder(1))//filial + cod
		ZAQ->(DbSeek(xFilial("ZAQ")+_aEst[_nx][1]))
		If ZAQ->(Found())
			@ Prow ()+1,001 Psay ZAQ->ZAQ_GRUPO//_aEst[_nx][1]		   //TRA1-> B1_GRPPROD 
		Else
			@ Prow ()+1,001 Psay "ERRO ->: "+_aEst[_nx][1]//ZAQ->ZAQ_GRUPO//_aEst[_nx][1]		   //TRA1-> B1_GRPPROD 		
		EndIf

		@ Prow ()  ,025 Psay _aEst[_nx][2]		   //qtde
		@ Prow ()  ,040 Psay _aEst[_nx][3]		   //media unit  

/*
       	If mv_par13 == 1 .Or, mv_par13 == 4 //total ou geral
	       	@ Prow ()  ,060 Psay _aEst[_nx][4]		   //total
       	EndIf
*/
       	If mv_par13 == 1 //C/ impostos
 	      	@ Prow ()  ,070 Psay _aEst[_nx][7]		   //C/ impostos
       	EndIf
       	
       	If mv_par13 == 2 //S impostos
       		@ Prow ()  ,070 Psay _aEst[_nx][6]		   //S/ impostos
      	EndIf
      	
		@ Prow ()  ,110 Psay _aEst[_nx][5] + "%"   //%total

	next _nx

@ Prow()+2,000 PSAY __PrtThinLine()
@ Prow()+1,001 PSAY "Total Geral: --->" 
@ Prow()  ,025 PSAY Transform(_aTotal[1],"@e 9,999,999,999") //total quantidade
@ Prow()  ,040 PSAY Transform(_aTotal[2],"@e 9,999,999,999.99")//total media unitaria
//@ Prow()  ,060 PSAY Transform(_aTotal[3],"@e 9,999,999,999.99")//total geral
If mv_par13 == 1
 @ Prow()  ,070 PSAY Transform(_aTotal[4],"@e 9,999,999,999.99")//C/ IMPOSTOS
Else
 @ Prow()  ,070 PSAY Transform(_aTotal[5],"@e 9,999,999,999.99")//S/ IMPOSTOS
EndIf

EndIf

//----------------------------------------------------
// RELATORIO POR GRUPO
//----------------------------------------------------

If mv_par12 == 2 

	While TRA1->(!EoF())

		If _cForn <> TRA1->D1_FORNECE+"-"+TRA1->D1_LOJA+"  "+SUBSTR(TRA1->A2_NOME,1,20)+"  "+TRA1->B1_GRPPROD
		   _cForn := TRA1->D1_FORNECE+"-"+TRA1->D1_LOJA+"  "+SUBSTR(TRA1->A2_NOME,1,20)+"  "+TRA1-> B1_GRPPROD

		   @ Prow ()+2,001 Psay _cForn
/*
			_aMat := {"         -  ","         -  ","         -  ","         -  ","         -  ","         -  ",;
			    	  "         -  ","         -  ","         -  ","         -  ","         -  ","         -  "}
*/			
			_aIpi := {"         -  ","         -  ","         -  ","         -  ","         -  ","         -  ",;
			    	  "         -  ","         -  ","         -  ","         -  ","         -  ","         -  "}
			
			_aCst := {"         -  ","         -  ","         -  ","         -  ","         -  ","         -  ",;
			    	  "         -  ","         -  ","         -  ","         -  ","         -  ","         -  "}

		EndIf      

//		_aMat[Val(Substr(TRA1->D1_DTDIGIT,5,2))] := TRA1->D1_TOTAL
        _aIpi[Val(Substr(TRA1->D1_DTDIGIT,5,2))] := TRA1->VALCIPI
        _aCst[Val(Substr(TRA1->D1_DTDIGIT,5,2))] := TRA1->D1_CUSTO
        
	    TRA1->(DbSkip())
		If _cForn <> TRA1->D1_FORNECE+"-"+TRA1->D1_LOJA+"  "+SUBSTR(TRA1->A2_NOME,1,20)+"  "+TRA1-> B1_GRPPROD
			_nCol := 54
/*
			If mv_par13 == 1 .Or. mv_par13 == 4 //total ou geral
				For x:= 1 to 12
					If ValType(_aMat[x]) <> "C"// <> "      -     "
						@ Prow (), _nCol Psay _aMat[x] Picture "9,999,999.99"
					Else 
						@ Prow (), _nCol Psay _aMat[x]
					EndIf
					_nCol += 13
				Next
			EndIf
*/           
			If mv_par13 == 1//C/ IMPOSTOS
				@ Prow ()+1,003 Psay "TOTAL C/ IMPOSTOS:--->"
				_nCol := 53
				For x:= 1 to 12
					If ValType(_aIPI[x]) <> "C"// <> "      -     "
						@ Prow (), _nCol Psay _aIPI[x] Picture "9,999,999.99"
					Else 
						@ Prow (), _nCol Psay _aIPI[x]
					EndIf
					_nCol += 13
				Next
			EndIf

			If mv_par13 == 2 //S/ IMPOSTOS
				@ Prow ()+1,003 Psay "TOTAL S/ IMPOSTOS:--->"
				_nCol := 53
				For x:= 1 to 12
					If ValType(_aCst[x]) <> "C"// <> "      -     "
						@ Prow (), _nCol Psay _aCst[x] Picture "9,999,999.99"
					Else 
						@ Prow (), _nCol Psay _aCst[x]
					EndIf
					_nCol += 13
				Next
			EndIf

			if Prow() > 60
				Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo) 
			Endif 
			_nCol := 0
		EndIf
	EndDo
	
//	_cForn := TRA1->A2_NOME

EndIf

//------------------------------------------------
// RELATORIO POR FORNECEDOR     
//------------------------------------------------

If mv_par12 == 3

	While TRA1->(!EoF())
		
		If _cForn <> TRA1->D1_FORNECE+"-"+TRA1->D1_LOJA+"  "+SUBSTR(TRA1->A2_NOME,1,40)

			_cForn := TRA1->D1_FORNECE+"-"+TRA1->D1_LOJA+"  "+SUBSTR(TRA1->A2_NOME,1,40)
			@ Prow ()+2,001 Psay _cForn
/*
			_aMat := {"         -  ","         -  ","         -  ","         -  ","         -  ","         -  ",;
					  "         -  ","         -  ","         -  ","         -  ","         -  ","         -  "}
*/
			_aIpi := {"         -  ","         -  ","         -  ","         -  ","         -  ","         -  ",;
			    	  "         -  ","         -  ","         -  ","         -  ","         -  ","         -  "}
			_aCst := {"         -  ","         -  ","         -  ","         -  ","         -  ","         -  ",;
			    	  "         -  ","         -  ","         -  ","         -  ","         -  ","         -  "}
		EndIf      

//		_aMat[Val(Substr(TRA1->D1_DTDIGIT,5,2))] := TRA1->D1_TOTAL
        _aIpi[Val(Substr(TRA1->D1_DTDIGIT,5,2))] := TRA1->VALCIPI
        _aCst[Val(Substr(TRA1->D1_DTDIGIT,5,2))] := TRA1->D1_CUSTO

	    TRA1->(DbSkip())
		If _cForn <> TRA1->D1_FORNECE+"-"+TRA1->D1_LOJA+"  "+SUBSTR(TRA1->A2_NOME,1,40)

			_nCol := 54
/*
			If mv_par13 == 1 .Or. mv_par13 == 4 //total ou geral
				For x:= 1 to 12
					If ValType(_aMat[x]) == "N"
						@ Prow (), _nCol Psay _aMat[x] Picture "9,999,999.99"
					Else 
						@ Prow (), _nCol Psay _aMat[x]
					EndIf
					_nCol += 13
				Next
			EndIf
*/
			If mv_par13 == 1 //C/ IMPOSTOS
				@ Prow ()+1,003 Psay "TOTAL C/ IMPOSTOS:--->"
				_nCol := 54
				For x:= 1 to 12
					If ValType(_aIPI[x]) <> "C"// <> "      -     "
						@ Prow (), _nCol Psay _aIPI[x] Picture "9,999,999.99"
					Else 
						@ Prow (), _nCol Psay _aIPI[x]
					EndIf
					_nCol += 13
				Next
			EndIf

			If mv_par13 == 2 //S/ IMPOSTOS
				@ Prow ()+1,003 Psay "TOTAL S/ IMPOSTOS:--->"
				_nCol := 54
				For x:= 1 to 12
					If ValType(_aCst[x]) <> "C"// <> "      -     "
						@ Prow (), _nCol Psay _aCst[x] Picture "9,999,999.99"
					Else 
						@ Prow (), _nCol Psay _aCst[x]
					EndIf
					_nCol += 13
				Next
			EndIf

			if Prow() > 60
				Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo) 
			Endif 
			_nCol := 0
		EndIf
	EndDo
	
//	_cForn := TRA1->A2_NOME

EndIf

Return(nil)
  
