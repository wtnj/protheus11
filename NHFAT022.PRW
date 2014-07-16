#include "font.ch"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHFAT022  ºAutor ³Fabio Nico          º Data ³  12/07/06   º±±
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

User Function NHFAT022()   


	SetPrvt("aGrupo,_cCodUsr,aCols,aGrupo,_cArqDBF,_aDBF,_cArqDBF,_cOrdem,_totalgeral,_totalcc,_TotTp,aCusTP,aCusCod")

    aCusTP    := {}
    aCusCod	  := {}
	aCols	:= {}                  
	Agrupo 	:= {}
	cString   := "SD1"
	cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir os  ")
	cDesc2    := OemToAnsi("Reajustes das NOTAS FISCAIS de ENTRADA / MOVIMENTACAO INTERNA")
	cDesc3    := OemToAnsi("")
	tamanho   := "G"
	limite    := 220
	aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
	nomeprog  := "NHFAT022"
	aLinha    := { }
	nLastKey  := 0
	titulo    := OemToAnsi("RELAÇÃO DE NOTAS FISCAIS E REAJUSTES")                
	cabec1    := "Cod.For.      Fornecedor                               NF   Dt.Entrada    Codigo Peça     Descricao                              Custo Total           Valor Unitario        Variacao          Repres.Custo     Var.Acumulada"
//	cabec2    := "Periodo de : " + Dtoc(mv_par01) + " a " + Dtoc(mv_par02)                                                    
	cCancel   := "***** CANCELADO PELO OPERADOR *****"
	_nPag     := 1  //Variavel que acumula numero da pagina 
	M_PAG     := 1
	wnrel     := "NHFAT022"
	_cPerg    := "FAT022" 
	_nTotal   := 0  
	_totalgeral := 0  
	_totalcc := 0
	
	Pergunte(_cPerg,.F.)                                      
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
	
	aDriver := ReadDriver()
	cCompac := aDriver[1]      
	cabec2  := "Periodo de : " + dtoc(mv_par01) + " a " + dtoc(mv_par02)
	Processa( {|| Gerando()   },"Gerando Dados para a Impressao") 
	
	set filter to 
	//set device to screen
	If aReturn[5] == 1
		Set Printer To
		Commit
	    ourspool(wnrel) //Chamada do Spool de Impressao
	Endif                                          
	MS_FLUSH() //Libera fila de relatorios em spool
	TRA1->( DbCloseArea())     
    TRB->( DbCloseArea())     
	TRC->( DbCloseArea())         
	
Return

Static Function Gerando()
Local cQuery,cQuery1,cQuery2,_cDesCC
Local _n1,_n2,_n3,_ni,_nj,_ng,_np,_nTotRC,_nTotVA


                                    
_cDesCC := ""
//-----------------------------------------------------------------------
// MONTA A QUERY da empresa NH
//-----------------------------------------------------------------------		

//-- LISTA SD1 POR CENTRO DE CUSTO P/ BUSCAR O CUSTO TOTAL POR TIPO E PRODUTO
cQuery := " SELECT SD1.D1_COD,SD1.D1_CUSTO,SD1.D1_TP"
cQuery += " FROM " + RetSqlName('SD1') + " SD1"
cQuery += " WHERE SD1.D_E_L_E_T_ = '' "
cQuery += " AND SD1.D1_PEDIDO <> '' "
cQuery += " AND SD1.D1_FILIAL = '"+xFilial("SD1")+"'"
cQuery += " AND SD1.D1_DTDIGIT BETWEEN '"+DTOS(mv_par01)+"' And '"+DTOS(mv_par02)+"' "
cQuery += " AND SD1.D1_TP BETWEEN '"+mv_par03+"' AND '" + mv_par04+"' "
cQuery += " AND SD1.D1_CC IN ('" +mv_par05+"') "
cQuery += " ORDER BY SD1.D1_TP,SD1.D1_COD DESC "
                                    
MemoWrit('C:\TEMP\NHFAT22.SQL',cQuery)
TCQUERY cQuery NEW ALIAS "TRA1" 

//----- LISTA SD3 P/ BUSCAR O TOTAL DO CUSTO DAS MOV. INTERNAS
cQuery1 := " SELECT SD3.D3_COD,SD3.D3_CUSTO1, SD3.D3_TIPO"
cQuery1 += " FROM " + RetSqlName('SD3') + " SD3 " 
cQuery1 += " WHERE SD3.D_E_L_E_T_ = ' ' "      
cQuery1 += " AND SD3.D3_FILIAL = '"+xFilial("SD3")+"'"
cQuery1 += " AND SD3.D3_DOC <> 'INVENT' "
cQuery1 += " AND SD3.D3_TM > '500' "
cQuery1 += " AND SD3.D3_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' And '"+DTOS(mv_par02)+"' "
cQuery1 += " AND SD3.D3_TIPO BETWEEN '"+mv_par03+"' AND '" + mv_par04+"' "
cQuery1 += " AND SD3.D3_CC IN ('" +mv_par05+"') "
                                    
MemoWrit('C:\TEMP\NHFAT22A.SQL',cQuery1)
TCQUERY cQuery1 NEW ALIAS "TRB" 

//-- LISTA SD1 GERAL SEM PARAMETRO DE CENTRO DE CUSTO P/ BUSCAR PRIMEIRA E SEGUNDO NOTA
cQuery2 := " SELECT SD1.D1_FORNECE,SD1.D1_DOC, SD1.D1_DTDIGIT,SD1.D1_COD,SD1.D1_DESCRI,SD1.D1_VUNIT,SD1.D1_GRUPO,SD1.D1_CC,SF1.F1_TIPO,SA2.A2_NOME,SD1.D1_TP"
cQuery2 += " FROM " + RetSqlName('SD1') + " SD1, " + RetSqlName('SF1') + " SF1, " + RetSqlName('SA2') + " SA2 " 
cQuery2 += " WHERE SF1.F1_DOC     = SD1.D1_DOC "
cQuery2 += " AND SF1.F1_FORNECE = SD1.D1_FORNECE "
cQuery2 += " AND SF1.F1_LOJA    = SD1.D1_LOJA "
cQuery2 += " AND SF1.F1_SERIE   = SD1.D1_SERIE "
cQuery2 += " AND SA2.A2_COD 	   = SD1.D1_FORNECE "
cQuery2 += " AND SA2.A2_LOJA = SD1.D1_LOJA "                 
cQuery2 += " AND SA2.D_E_L_E_T_ = ' ' "
cQuery2 += " AND SF1.D_E_L_E_T_ = '' AND SF1.F1_FILIAL = '"+xFilial("SF1")+"'"
cQuery2 += " AND SD1.D_E_L_E_T_ = '' AND SD1.D1_FILIAL = '"+xFilial("SD1")+"'"                                                
cQuery2 += " AND SD1.D1_PEDIDO <> '' "
cQuery2 += " AND SD1.D1_DTDIGIT BETWEEN '"+DTOS(mv_par01)+"' And '"+DTOS(mv_par02)+"' "
cQuery2 += " AND SD1.D1_TP BETWEEN '"+mv_par03+"' AND '" + mv_par04+"' "
cQuery2 += " ORDER BY SD1.D1_TP,SD1.D1_COD,SD1.D1_DTDIGIT DESC "
//cQuery += " ORDER BY SF1.F1_TIPO,SD1.D1_GRUPO,NOVOCC,SD1.D1_COD,SD1.D1_DTDIGIT DESC "
//cQuery += " ORDER BY SD1.D1_GRUPO,SD1.D1_FORNECE,SD1.D1_CC,SD1.D1_COD,SD1.D1_DTDIGIT "
                                    
MemoWrit('C:\TEMP\NHFAT22C.SQL',cQuery2)
TCQUERY cQuery2 NEW ALIAS "TRC" 


// Busca as movimentacoes internas (SD3)
TRB->(DbGotop())     

If Empty(TRB->D3_COD)
   MsgBox("Nao Existe Informacao Para os Parametros Informados no SD3 linha-230","Atencao","STOP")
Endif

While !TRB->(EOF())                              
   
   // busca o tipo e faz a somatoria do custo
   _n1 := Ascan(aCusTP, {|x| x[1]== TRB->D3_TIPO})

   // busca o codigo e faz a somatoria do custo
   _n2 := Ascan(aCusCod, {|x| x[1]== TRB->D3_COD})
   

   //Nao encontro o tipo na matriz adiciona
	If _n1 == 0
       AADD(aCusTP,{TRB->D3_TIPO,TRB->D3_CUSTO1})

  	Else   //encontrou o tipo na matriz soma o custo
	   aCusTP[_n1] [02] += TRB->D3_CUSTO1
	Endif                                                      
  
  
     //Nao encontro o codigo na matriz
	If _n2 == 0
       AADD(aCusCod,{TRB->D3_COD,TRB->D3_CUSTO1})
  	Else   // encontrou o codigo na matriz soma o custo
	   aCusCod[_n2] [02] += TRB->D3_CUSTO1
	Endif                                                      
 
   TRB->(Dbskip())
Enddo


// Busca as entradas das notas fiscal (SD1)
TRA1->(DbGotop())     
TRB->(DbGotop())                              

If Empty(TRA1->D1_COD) .And. Empty(TRB->D3_COD)
   MsgBox("Nao Existe Informacao Para os Parametros Informados no SD1 e SD3 linha-274","Atencao","STOP")
   Return
Endif

If Empty(TRA1->D1_COD)
   MsgBox("Nao Existe Informacao Para os Parametros Informados no SD1 linha-279","Atencao","STOP")
Endif

While !TRA1->(EOF())                              

   // busca o tipo e faz a somatoria do custo
   _n1 := Ascan(aCusTP, {|x| x[1]== TRA1->D1_TP})

   // busca o codigo e faz a somatoria do custo
   _n2 := Ascan(aCusCod, {|x| x[1]== TRA1->D1_COD})
   

   //Nao encontro o tipo na matriz adiciona
   If _n1 == 0
       AADD(aCusTP,{TRA1->D1_TP,TRA1->D1_CUSTO})

   Else   //encontrou o tipo na matriz soma o custo
	   aCusTP[_n1] [02] += TRA1->D1_CUSTO
   Endif                                                      
  
     //Nao encontro o codigo na matriz
   If _n2 == 0
       AADD(aCusCod,{TRA1->D1_COD,TRA1->D1_CUSTO})
   Else   // encontrou o codigo na matriz soma o custo
	   aCusCod[_n2] [02] += TRA1->D1_CUSTO
   Endif                                                      

   TRA1->(DbSkip())
Enddo


TRC->(DbGotop())     


If Empty(TRC->D1_FORNECE)
   MsgBox("Nao Existe Informacao Para os Parametros Informados no SD1 linha-216","Atencao","STOP")
Endif

While !TRC->(EOF())                              

   // procuro o  produto igual na matriz
   _n1 := Ascan(aCols, {|x| x[4]== TRC->D1_COD})
   
   //Nao encontro o produto na matriz adiciona
   If _n1 == 0
       AADD(acols,{TRC->D1_FORNECE,TRC->D1_DOC,stod(TRC->D1_DTDIGIT),TRC->D1_COD,TRC->D1_DESCRI,TRC->D1_VUNIT,TRC->D1_TP,TRC->D1_CC,TRC->A2_NOME,"2"})
       
   	// encontrou o registro na matriz
   Else
       _n2 := Ascan(aCols, {|x| x[4]+x[10]== TRC->D1_COD+"1"})	   
       if _n2 == 0
	       AADD(acols,{TRC->D1_FORNECE,TRC->D1_DOC,stod(TRC->D1_DTDIGIT),TRC->D1_COD,TRC->D1_DESCRI,TRC->D1_VUNIT,TRC->D1_TP,TRC->D1_CC,TRC->A2_NOME,"1"})
       else 
	   	   if acols[_n2][6] > TRC->D1_VUNIT .OR. acols[_n2][6] = TRC->D1_VUNIT // sobrepoe o ultimo registro encontrada
	         Acols[_n2] [01] := TRC->D1_FORNECE
	         Acols[_n2] [02] := TRC->D1_DOC
		     Acols[_n2] [03] := STOD(TRC->D1_DTDIGIT)                                                       
		     Acols[_n2] [04] := TRC->D1_COD
	    	 Acols[_n2] [05] := TRC->D1_DESCRI                                    
	         Acols[_n2] [06] := TRC->D1_VUNIT
		     Acols[_n2] [07] := TRC->D1_TP //Tipo
		     Acols[_n2] [08] := TRC->D1_CC
	    	 Acols[_n2] [09] := TRC->A2_NOME
	   	   endif
	   Endif
   Endif                                                      
   
   TRC->(DbSkip())
Enddo


//---------------------------------------------------------------------------------------------------------
// impressao
//---------------------------------------------------------------------------------------------------------

aCols := Asort(aCols,,, { |x,y| x[4]+x[10] < y[4]+y[10] }) // Orderna as notas no acols p/mostrar p/ usuario


Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

CTT->(dbSetOrder(1))
If CTT->(dbSeek(xFilial("CTT")+mv_par05))
   _cDesCC := CTT->CTT_DESC01                                                             
Endif

@Prow()+1, 000 psay "Centro de Custo..:" + mv_par05 +" "+ _cDesCC + "     Tipo..:" + acols[1,07]
_codigo 	:= acols[1,04]
_cc 		:= acols[1,08]
_tipo 		:= acols[1,07]
_fornece 	:= acols[1,01]


 _nTotRC := 0 //total repres. custo
 _nTotVA := 0 // Variacao acumulada

for _ni:= 1 to len(aCols)                                                                                  
  
    _np := Ascan(aCusCod, {|x| x[1] == aCols[_ni][4]}) //busca o custo total do produto na matriz	    
    
    If _np <> 0  //Nao imprime qdo o produto nao mov. no centro de custo escolhido
       if _tipo <> acols[_ni,07]
          _tipo := acols[_ni,07]
   		  _nt :=  Ascan(aCusTP, {|x| x[1] == aCols[_ni-1][7]}) //busca o custo total do tipo do produto na matriz	    
           _nTotTip := aCusTP[_nt][2] // total do custo do tipo

   		  @Prow()+2 , 000 PSAY __PrtThinLine() 
		  @Prow()+1, 100 psay "Total do Tipo...:"
		  @Prow()  , 128 psay aCusTP[_nt][2] Picture "@E 9,999,999.99" // total do custo do tipo
		  @Prow()  , 188 psay _nTotRC Picture "@E 9,999,999.99" // total do custo do tipo
		  @Prow()  , 208 psay _nTotVA Picture "@E 9,999,999.99" // total do custo do tipo
		
	   	  _nPag  := _nPag + 1   
    	  Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	      @Prow()+1, 000 psay "Centro de Custo..:" + mv_par05 +" "+ _cDesCC + "     Tipo..:" + acols[_ni,07]    	  
          _nTotRC := 0 //total repres. custo
          _nTotVA := 0 // Variacao acumulada

	   endif
	
 	         
       if _codigo <> acols[_ni,04]        /// .or. _fornece <> acols[_ni,01]
	      @Prow()+1, 000 psay " "
	      _codigo 	:= acols[_ni,04]
	      _fornece 	:= acols[_ni,01]
	   endif
    
	   @Prow()+1, 000 psay acols[_ni,01]   // FORNECE
	   @Prow()	, 010 psay acols[_ni,09]  // RAZAO SOCIAL
	   @Prow()  , 051 psay acols[_ni,02]   // DOC
	   @Prow()  , 061 psay acols[_ni,03] Picture "99/99/9999"  // DTDIGIT
	   @Prow()  , 074 psay acols[_ni,04]   // COD PRODUTO
	   @Prow()  , 090 psay acols[_ni,05]   // DESCRICAO PRODUTO
	   if acols[_ni,10] == "2"	   
	      @Prow()  , 130 psay aCusCod[_np,02] Picture "@E 999,999.99"   // custo total do produto na matriz	    
	   Endif   
	   @Prow()  , 150 psay acols[_ni,06] Picture "@E 999,999.99"   // VUNIT
	
 	   _variacao :=0
	   _TotTp 	  :=0
	   _varac 	  :=0
	
	   if acols[_ni,10] == "2"
	      _nt :=  Ascan(aCusTP, {|x| x[1] == aCols[_ni][7]}) //busca o custo total do tipo do produto na matriz	    
	      _np :=  Ascan(aCusCod, {|x| x[1] == aCols[_ni][4]}) //busca o custo total do produto na matriz	    

          if _nt <> 0           
        
	         If _ni > 1 //Nao encontro o registro na matriz   
	    	   if acols[_ni,4] == acols[_ni-1,4]  
					_variacao := ((acols[_ni,06]/acols[_ni-1,06])-1)*100  
			   Endif
		     Else 
 			    _variacao := 0		   
		     Endif	  
   		     _TotTp   := (aCusCod[_np][2]/aCusTP[_nt][2])*100 //calcula a repres. custo do produto / total do tipo
		  else
			_variacao := 0
			_TotTp    := 0
		  endif

		  _varac	  := (_variacao * _TotTp) / 100
		
		  @Prow()  , 170 psay _variacao Picture "@E 99,999.99"
		  @Prow()  , 190 psay _TotTp    Picture "@E 9,999.9999"    
		  @Prow()  , 210 psay _varac    Picture "@E 9,999.9999"    
		  _nTotRC+=  _TotTp //Soma o total repres. custo
		  _nTotVA+= _varac //Soma Variacao acumulada
		
       endif
       
  	   If Prow() > 62 .And. acols[_ni,10] == "2" 
	      _nPag  := _nPag + 1   
    	  Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
          @Prow()+1, 000 psay "Centro de Custo..:" + mv_par05 +" "+ _cDesCC + "     Tipo..:" + acols[_ni,07]    	  
	   ElseIf Prow() > 65
	      _nPag  := _nPag + 1   
    	  Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
          @Prow()+1, 000 psay "Centro de Custo..:" + mv_par05 +" "+ _cDesCC + "     Tipo..:" + acols[_ni,07]    	  
	   Endif
     
    Endif
Next _ni

@ Prow()+2 , 000 PSAY __PrtThinLine()  
_nt :=  Ascan(aCusTP, {|x| x[1] == aCols[_ni-1][7]}) //busca o custo total do tipo do produto na matriz	    
@Prow()+1, 100 psay "Total do Tipo...:"
@Prow()  , 128 psay aCusTP[_nt][2] Picture "@E 9,999,999.99" // total do custo do tipo
@Prow()  , 188 psay _nTotRC Picture "@E 999,999.99" // total do RC
@Prow()  , 208 psay _nTotVA Picture "@E 999,999.99" // total do VA


Return(nil)


Static Function Gerando2()
Local cQuery
Local _n1,_n2,_n3,_ni,_nj,_ng,_np 

//-----------------------------------------------------------------------
// MONTA A QUERY DA empresa FN
//-----------------------------------------------------------------------		

                                                      	
cQuery := "SELECT SD1.D1_FORNECE,SD1.D1_DOC, SD1.D1_DTDIGIT,SD1.D1_COD,SD1.D1_DESCRI,SD1.D1_VUNIT,SD1.D1_GRUPO,SF1.F1_TIPO,SA2.A2_NOME"
cQuery += " FROM "+RetSqlName('SD1')+" SD1, "+RetSqlName('SF1')+" SF1, "+RetSqlName('SA2')+" SA2"
cQuery += " WHERE SF1.F1_DOC   = SD1.D1_DOC"
cQuery += " AND SF1.F1_FORNECE = SD1.D1_FORNECE"
cQuery += " AND SF1.F1_LOJA    = SD1.D1_LOJA"
cQuery += " AND SF1.F1_SERIE   = SD1.D1_SERIE"
cQuery += " AND SA2.A2_COD 	   = SD1.D1_FORNECE"
cQuery += " AND SA2.A2_LOJA = SD1.D1_LOJA"
cQuery += " AND SA2.D_E_L_E_T_ = ' '"
cQuery += " AND SF1.D_E_L_E_T_ = ''  AND SF1.F1_FILIAL = '"+xFilial("SF1")+"'"
cQuery += " AND SD1.D1_CF IN ('1101','1102','1116','1124','1252','1302','1352','1551','1555','1556','1901','1908','1922','1949','3101','3127','3551','3556','3949','2101')"
cQuery += " AND SD1.D1_DTDIGIT BETWEEN '"+DtoS(mv_par01)+"' And '"+DtoS(mv_par02)+"'"
cQuery += " AND SD1.D1_GRUPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
cQuery += " AND SD1.D_E_L_E_T_ = ''  AND SD1.D1_FILIAL = '"+xFilial("SD1")+"'"                                                

cQuery += " ORDER BY SD1.D1_GRUPO,SD1.D1_COD,SD1.D1_DTDIGIT DESC"
                                    
MemoWrit('C:\TEMP\NHFAT22.SQL',cQuery)
TCQUERY cQuery NEW ALIAS "TRA1" 

TRA1->(DbGotop())     

If Empty(TRA1->D1_FORNECE)
   MsgBox("Nao Existe Informacao Para os Parametros Informados linha-426","Atencao","STOP")
   Return
Endif


While !TRA1->(EOF())                              

   	// procuro registro igual na matriz
   	_n1 := Ascan(aCols, {|x| x[4]== TRA1->D1_COD})
   
   	//Nao encontro o registro na matriz
	If _n1 == 0
       	AADD(acols,{TRA1->D1_FORNECE,TRA1->D1_DOC,stod(TRA1->D1_DTDIGIT),TRA1->D1_COD,TRA1->D1_DESCRI,TRA1->D1_VUNIT,TRA1->D1_GRUPO,"",TRA1->A2_NOME,"2"})
  	Else // encontrou o registro na matriz
        _n2 := Ascan(aCols, {|x| x[4]+x[10]== TRA1->D1_COD+"1"})	   
	    If _n2 == 0
	      	Aadd(acols,{TRA1->D1_FORNECE,TRA1->D1_DOC,stod(TRA1->D1_DTDIGIT),TRA1->D1_COD,TRA1->D1_DESCRI,TRA1->D1_VUNIT,TRA1->D1_GRUPO,"",TRA1->A2_NOME,"1"})
        Else 
			If acols[_n2][6] > TRA1->D1_VUNIT .OR. acols[_n2][6] = TRA1->D1_VUNIT // sobrepoe o ultimo registro encontrada
	    	  Acols[_n2] [01] := TRA1->D1_FORNECE
	          Acols[_n2] [02] := TRA1->D1_DOC
		      Acols[_n2] [03] := STOD(TRA1->D1_DTDIGIT)                                                       
		      Acols[_n2] [04] := TRA1->D1_COD
	    	  Acols[_n2] [05] := TRA1->D1_DESCRI                                    
	          Acols[_n2] [06] := TRA1->D1_VUNIT
		      Acols[_n2] [07] := TRA1->D1_GRUPO
		      Acols[_n2] [08] := ""
	    	  Acols[_n2] [09] := TRA1->A2_NOME
	    	endif
	    Endif
	Endif                                                      
   TRA1->(DbSkip())
Enddo

//----------------------------------------------------------
//  FAZ A SOMATORIA DOS GRUPOS
//----------------------------------------------------------

For _ng:= 1 to len(aCols)
   If aCols[_ng][10] == "2"
      _ni := Ascan(aGrupo, {|x| x[1] == aCols[_ng][7]})
      If _ni == 0 //Nao encontro o registro na matriz   
         AADD(aGrupo,{aCols[_ng][7],aCols[_ng][6]})  
      Else
         aGrupo[_ni][2] += aCols[_ng][6] // Soma o valor do grupo
      Endif   
   Endif
Next _ng

//---------------------------------------------------------------------------------------------------------
// impressao
//---------------------------------------------------------------------------------------------------------

for _nj:=1 to len(aGrupo)
   _totalgeral := _totalgeral + aGrupo[_nj,2]
next

aCols := Asort(aCols,,, { |x,y| x[4]+x[10] < y[4]+y[10] }) // Orderna as notas no acols p/mostrar p/ usuario

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

@Prow()+1, 000 psay " Tipo..:" + acols[1,07]

_codigo 	:= acols[1,04]
_cc 		:= acols[1,08]
_grupo 		:= acols[1,07]
_fornece 	:= acols[1,01]

for _ni:= 1 to len(aCols)
  
    if _grupo <> acols[_ni,07]
    	_grupo := acols[_ni,07]
   		@ Prow()+2 , 000 PSAY __PrtThinLine() 

	    _nt :=  Ascan(aGrupo, {|x| x[1] == aCols[_ni-1][7]})
		_totalcc := aGrupo[_nt,02]

		@Prow()+1, 100 psay "Total do Tipo...:"
		@Prow()  , 128 psay _totalcc Picture "@E 9,999,999.99"
		@Prow()+1, 100 psay " % com relacao ao Tipo...:"
		@Prow()  , 128 psay (_totalcc/_totalgeral)*100 Picture "@E 9,999,999.99"
		
	   	_nPag  := _nPag + 1   
    	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
    	@Prow()+1, 000 psay " Tipo..:" + acols[_ni,07]

	endif
	
    
	If Prow() > 65 
	   	_nPag  := _nPag + 1   
    	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
    	@Prow()+1, 000 psay " Tipo..:" + acols[_ni,07]
	Endif
	         
    if _codigo <> acols[_ni,04]        /// .or. _fornece <> acols[_ni,01]
	    @Prow()+1, 000 psay " "
	    _codigo 	:= acols[_ni,04]
	    _fornece 	:= acols[_ni,01]
	endif
    
	@Prow()+1, 000 psay acols[_ni,01]   // FORNECE
	@Prow()	 , 010 psay acols[_ni,09]  // RAZAO SOCIAL
	@Prow()  , 051 psay acols[_ni,02]   // DOC
	@Prow()  , 061 psay acols[_ni,03] Picture "99/99/9999"  // DTDIGIT
	@Prow()  , 074 psay acols[_ni,04]   // COD PRODUTO
	@Prow()  , 090 psay acols[_ni,05]   // DESCRICAO PRODUTO
	@Prow()  , 130 psay acols[_ni,06] Picture "@E 999,999.99"   // VUNIT
	

	if  acols[_ni,10] == "1"
	    _nt :=  Ascan(aGrupo, {|x| x[1] == aCols[_ni][7]})
		_totalcc := aGrupo[_nt,02]

		_variacao := ((acols[_ni,06]/acols[_ni,06])-1)*100  
		_totcc    :=  (acols[_ni,06]/_totalcc)*100
		
		@Prow()  , 150 psay _variacao Picture "@E 99,999.99"   
		@Prow()  , 170 psay _totcc    Picture "@E 9,999.9999"   

	endif                  
	
	_variacao :=0
	_totcc 	  :=0
	_varac 	  :=0
	
	if  acols[_ni,10] == "2"
	    _nt :=  Ascan(aGrupo, {|x| x[1] == aCols[_ni][7]})
		_totalcc := aGrupo[_nt,02]


        if _ni > 1
	    	    if acols[_ni,4] == acols[_ni-1,4]  
					_variacao := ((acols[_ni,06]/acols[_ni-1,06])-1)*100  
				endif
			else
				_variacao := 0
		endif

		_totcc    := (acols[_ni,06]/_totalcc)*100
		
		_varac	  := (_variacao * _totcc) / 100
		
		@Prow()  , 150 psay _variacao Picture "@E 99,999.99"
		@Prow()  , 170 psay _totcc    Picture "@E 9,999.9999"    
		@Prow()  , 190 psay _varac    Picture "@E 9,999.9999"    
		
    endif


Next _ni
           
_nt :=  Ascan(aGrupo, {|x| x[1] == aCols[_ni-1][7]})
_totalcc := aGrupo[_nt,02]                    

@ Prow()+2 , 000 PSAY __PrtThinLine() 
@Prow()+1, 100 psay "Total do Tipo...:"
@Prow()  , 128 psay _totalcc Picture "@E 9,999,999.99"
@Prow()+1, 100 psay " % com relacao ao Tipo...:"
@Prow()  , 128 psay (_totalcc/_totalgeral)*100 Picture "@E 9,999,999.99"
@ Prow()+2 , 000 PSAY __PrtThinLine() 		                                
@Prow()+1, 100 psay "Total GERAL --->>>>>>   "		      
@Prow()  , 128 psay _totalgeral Picture "@E 9,999,999.99"                   
@Prow()  , 150 psay " <<<<<<<<< "	
@ Prow()+2 , 000 PSAY __PrtThinLine() 
	

Return(nil)     


