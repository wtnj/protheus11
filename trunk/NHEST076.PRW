#include 'fivewin.ch'
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHEST073  ºAutor ³Fabio William Nico  º Data ³  12/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CUSTOS DE MANUTENCAO                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Estoque Custos                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHEST076()   

SetPrvt("_aGrupo,_cCodUsr,aCols")
aCols    := {}                  
cString   := "SD1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir os  ")
cDesc2    := OemToAnsi("Valores de Consumo da Ferramentaria")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST076"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATÓRIO DE CUSTOS FERRAMENTAS")                
cabec1    := "CC        Descrição                       Consumo           Devolucao       Despesa Direta           Total CC         % "
cabec2    := "Periodo de : " + mv_par01 + " a " + mv_par01                                                    
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHEST076"
_cPerg    := "EST073" 
_nTotal   := 0  
_nTotcol01 := 0  
_nTotcol02 := 0  
_nTotcol03 := 0  
_nTotcol04 := 0 
_nTotcol05 := 0 
_nTotGeral := 0  


Pergunte(_cPerg,.F.)                                      
cabec2    := "Periodo de : " + dtoc(mv_par01) + " a " + dtoc(mv_par02)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

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

//TRA1->(DbCloseArea())
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

Return

Static Function Gerando()
		//-----------------------------------------------------------------------
		//  monta a query para o ct2
		//-----------------------------------------------------------------------		
		cQuery := " SELECT CT2.CT2_CCD ,CT2.CT2_DEBITO, CTT.CTT_DESC01,SUM(CT2.CT2_VALOR) AS TOTAL "
		cQuery += " FROM " + RetSqlName('CT2') + " CT2, " + RetSqlName('CTT') + " CTT "
		cQuery += " WHERE CT2.CT2_CCD = CTT.CTT_CUSTO "
		cQuery += " AND CT2.CT2_DATA BETWEEN '"+DTOS(mv_par01)+"' And '"+DTOS(mv_par02)+"' "
		cQuery += " AND CT2.CT2_DEBITO IN ('401020020001')   
		cQuery += " AND CT2.CT2_CREDIT NOT IN ('101040030005') "    
		cQuery += " AND CTT.D_E_L_E_T_ = ' ' "
		cQuery += " AND CT2.D_E_L_E_T_ = ' ' "                                              
		cQuery += " GROUP BY CT2.CT2_CCD ,CT2.CT2_DEBITO, CTT.CTT_DESC01 "
		cQuery += " ORDER BY CT2.CT2_CCD "  

		MemoWrit('C:\TEMP\NHEST076.SQL',cQuery)
		TCQUERY cQuery NEW ALIAS 'TRA1'

		If	! USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf

		DbSelectArea('TRA1')
		Count to _nQtdReg
		ProcRegua(_nQtdReg)
		TRA1->(DbGoTop())
        X := 1
		While TRA1->( ! Eof() )
                AADD(aCols,{" "," "," "," ",0})
                aCols[X][1] := TRA1->CT2_CCD
                aCols[X][2] := TRA1->CT2_DEBITO
                aCols[X][3] := TRA1->CTT_DESC01
                aCols[X][4] := TRA1->CTT_DESC01 
                aCols[X][5] := TRA1->TOTAL
                X := X + 1
                TRA1->(DbSkip())
		end
  
		TRA1->(DbCloseArea())                    

		//-----------------------------------------------------------------------
		//Monta query para o sd3
		//-----------------------------------------------------------------------
		cQuery2 := " SELECT D3.D3_CC, SUM(D3.D3_CUSTO1) AS TOTAL , CTT.CTT_DESC01"
		cQuery2 += " FROM " + RetSqlName('SD3') + " D3 , " + RetSqlName('CTT') + " CTT "
		cQuery2 += " WHERE D3.D3_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' And '"+DTOS(mv_par02)+"' "
		cQuery2 += " AND D3.D3_GRUPO LIKE '%FE%'"
		cQuery2 += " AND D3.D3_CC = CTT.CTT_CUSTO "		
		cQuery2 += " AND D3.D_E_L_E_T_ = ''"
		cQuery2 += " AND D3.D3_TM = '501'"
		cQuery2 += " AND CTT.D_E_L_E_T_ = ''"
		cQuery2 += " GROUP BY D3.D3_CC, CTT.CTT_DESC01 "
		cQuery2 += " ORDER BY D3.D3_CC " 
	   	MemoWrit('C:\TEMP\NHEST07B.SQL',cQuery2)
		TCQUERY cQuery2 NEW ALIAS 'TRB'
                         
		If	! USED()
			MsgBox(cQuery2 +'. Query errada','Erro!!!','STOP')
		EndIf
		DbSelectArea('TRB')
		TRB->(DbGoTop())
		While TRB->( ! Eof() )
		 		AADD(aCols,{" "," "," "," ",0})
                aCols[X][1] := TRB->D3_CC
				aCols[X][2] := ''
                aCols[X][3] := "CONSUMO"
                aCols[X][4] := TRB->CTT_DESC01
                aCols[X][5] := TRB->TOTAL
                X := X + 1                                                   
                TRB ->(DbSkip())
		end

		TRB->(DbCloseArea())                                                                    

		//-----------------------------------------------------------------------
		//Monta query para o SD3 
		//-----------------------------------------------------------------------
		cQuery3 := " SELECT D3.D3_CC, SUM(D3.D3_CUSTO1) AS TOTAL , CTT.CTT_DESC01"
		cQuery3 += " FROM " + RetSqlName('SD3') + " D3 , " + RetSqlName('CTT') + " CTT "
		cQuery3 += " WHERE D3.D3_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' And '"+DTOS(mv_par02)+"' "
		cQuery3 += " AND D3.D3_GRUPO LIKE '%FE%'"
		cQuery3 += " AND D3.D3_CC = CTT.CTT_CUSTO "		
		cQuery3 += " AND D3.D_E_L_E_T_ = ''"   
		cQuery3 += " AND D3.D3_DOC <> 'INVENT' "   		
		cQuery3 += " AND D3.D3_TM IN ('001','499','999')"
		cQuery3 += " AND CTT.D_E_L_E_T_ = ''"
		cQuery3 += " GROUP BY D3.D3_CC, CTT.CTT_DESC01 "
		cQuery3 += " ORDER BY D3.D3_CC " 
		MemoWrit('C:\TEMP\NHEST07C.SQL',cQuery2)
		TCQUERY cQuery3 NEW ALIAS 'TR3'
                         
		If	! USED()
			MsgBox(cQuery3 +'. Query errada','Erro!!!','STOP')
		EndIf
		DbSelectArea('TR3')
		TR3->(DbGoTop())
		While TR3->( ! Eof() )
		 		AADD(aCols,{" "," "," "," ",0})
                aCols[X][1] := TR3->D3_CC
				aCols[X][2] := 'DEV'
                aCols[X][3] := "DEVOLUCAO"
                aCols[X][4] := TR3->CTT_DESC01
                aCols[X][5] := (TR3->TOTAL*-1)
                X := X + 1                                                   
                TR3 ->(DbSkip())
		end
		TR3->(DbCloseArea())                    
Return

Static Function RptDetail()                                      
aCols := ASort(aCols,,, { |x, y| x[1]+x[2] < y[1]+y[2]}) 
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
                                                                            
for X:= 1 to len(acols)
    _nTotGeral := _nTotGeral + aCols[X][5]
next

_cCC := aCols[1][1]
X := 1
@ Prow()+1 , 001 Psay aCols[X][1]
@ Prow()   , 010 Psay Substr(aCols[X][4],1,27) //descricao centro de custo
	   	
for X:= 1 to len(acols)
   If Prow() > 65
      _nPag  := _nPag + 1   
      Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
   Endif
	if _cCC <> aCols[X][1]
	   	@ Prow()   , 100 Psay _nTotal picture "@E 9,999,999.99"   
	   	@ Prow()   , 115 Psay ((_nTotal/_nTotGeral)*100) picture "@E 999.99%"   
	   	_nTotal := 0
	   	@ Prow()+1 , 001 Psay aCols[X][1]
	   	@ Prow()   , 010 Psay Substr(aCols[X][4],1,27)
	   	_cCC := aCols[X][1]
	endif

 	if aCols[X][2] = ''
	   		@ Prow()   , 040 Psay aCols[X][5]  picture "@E 9,999,999.99" 
	   		_nTotcol01 :=  _nTotcol01 + aCols[X][5]
 		elseif aCols[X][2] = 'DEV'
		   	@ Prow()   , 060 Psay aCols[X][5]  picture "@E 9,999,999.99"   
	   		_nTotcol05 :=  _nTotcol05 + aCols[X][5]
    	elseif aCols[X][2] = '401020020001'
    		@ Prow()   , 080 Psay aCols[X][5]  picture "@E 9,999,999.99"   
	   		_nTotcol02 :=  _nTotcol02 + aCols[X][5]

  	endif
  	_nTotal := _nTotal + aCols[X][5]
next

	   	@ Prow()   , 100 Psay _nTotal picture "@E 9,999,999.99"   
	   	@ Prow()   , 115 Psay ((_nTotal/_nTotGeral)*100) picture "@E 999.99%"   

@ Prow()+2,000 PSAY __PrtThinLine() 
@ Prow()+1 , 001 Psay "TOTAL DO PERIODO..:" 
@ Prow()   , 040 Psay _nTotcol01 picture "@E 99,999,999.99"   
@ Prow()   , 060 Psay _nTotcol05 picture "@E 99,999,999.99"   
@ Prow()   , 080 Psay _nTotcol02 picture "@E 99,999,999.99"   
@ Prow()   , 100 Psay _nTotcol01+_nTotcol02+_nTotcol05 picture "@E 999,999,999.99"   

Return(nil)