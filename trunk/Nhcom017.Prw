/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHCOM017 ºAutor ³Alexandre R, Bento  º Data ³  11/09/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de desconto de preco nos pedidos de compras     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include 'topconn.ch'
#include "rwmake.ch"

User Function NHCOM017()   

cString   := "SC7"
cDesc1    := OemToAnsi("Este relatório tem por objetivo")
cDesc2    := OemToAnsi("")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHCOM017"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATÓRIO DE DESCONTO DE PREÇO ")                
cabec1    := "" 
cabec2    := OemToAnsi(" PEDIDO ITEM  FORNECEDOR                   RECOMPRA   QTDE      UNIT.ORÇADO      UNIT.NEGOC  $DIFERENÇA  %DESC/REAJ   TOT.C/ IPI")                 
cabec3    := " "
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1  
wnrel     := "NHCOM017"
_cPerg    := "COM017" 
aOrd      := {OemToAnsi("Por Data"),OemToAnsi("Por Fornecedor"),OemToAnsi("Por Comprador"),OemToAnsi("Por Recompra")} 
 
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,tamanho)

Pergunte(_cPerg,.F.) 

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
		//  monta a query para o SX5
		//-----------------------------------------------------------------------		

cQuery := "SELECT *"
cQuery += " FROM " +  RetSqlName( 'SC7' ) +" SC7 "
cQuery += " WHERE SC7.C7_EMISSAO BETWEEN '" + DtoS(Mv_par01) + "' AND '" + DtoS(Mv_par02) + "'"
cQuery += " AND SC7.C7_FORNECE BETWEEN '" + mv_par03 + "' AND '" +  mv_par04 + "'"
cQuery += " AND SC7.D_E_L_E_T_ = ' ' " 
If !Empty(mv_par05)
   cQuery += " AND SC7.C7_USER = '" + mv_par05 + "'" 
Endif   
If mv_par06==1 //RECOMPRA SIM
   cQuery += " AND SC7.C7_RECOMPR = 'S'" 
Else
   cQuery += " AND SC7.C7_RECOMPR IN (' ','N')"   
Endif   

If aReturn[8] == 1 //ordem por Data
   cQuery += " ORDER BY SC7.C7_EMISSAO"
ElseIf aReturn[8] == 2 //ordem por Fornecedor
   cQuery += " ORDER BY SC7.C7_FORNECE,SC7.C7_LOJA"
ElseIf aReturn[8] == 3 //ordem por Comprador
   cQuery += " ORDER BY SC7.C7_USER"
Else
   cQuery += " ORDER BY SC7.C7_RECOMPR"
Endif

// MemoWrit('C:\TEMP\COM017.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TRA1"
TcSetField("TRA1","C7_EMISSAO","D") // Muda a data de digitaçao de string para date    
TcSetField("TRA1","C7_DATPRF" ,"D") // Muda a data de preferencia de string para date

If	! USED()
	MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
EndIf

Return

Static Function RptDetail()   
Local _tpreco   := 0 // total dos precos
Local _tprecoor := 0 // total dos precos orcados
Local _tdifer   := 0 // total diferenca do valor orcado e valor negociado
Local _ttped    := 0 // total de totais dos pedidos   
Local _ttdesc   :=0  // total de descontos

//PadC(titulo,82)
Cabec1 := "Emissão do P.C. no Periodo de: " + DtoC(mv_par01) + " Ate: " + DtoC(mv_par02) +"  "+Iif(aReturn[8] == 1,"Por Data",Iif(aReturn[8] == 2,"Por Fornecedor",Iif(aReturn[8] == 3,"Por Comprador","Por Recompra")))
TRA1->(Dbgotop())
if !Empty(mv_par05)////Imprime nome do comprador
   SY1->(DbSetOrder(3))
   If SY1->(DbSeek(xFilial("SY1")+mv_par05))
      Cabec1 += "   Comprador: "+SubStr(SY1->Y1_NOME,1,25)
   Endif
Endif   
Cabec1 := Padc(Cabec1,132)
Cabec(Titulo, Cabec1,Cabec2,NomeProg, "M", nTipo)                                    
//Cabecalho()
SA2->(DbSetOrder(1))


DbSelectArea('TRA1')
	While TRA1->( ! Eof() )
		if Prow() > 57
			Cabec(Titulo, Cabec1,Cabec2,NomeProg,"M", nTipo) 
			//Cabecalho()			
		Endif    
                
		//solicitacao do marlon compras chamado 013401 do portal
		If TRA1->C7_PRECOOR-TRA1->C7_PRECO<>0

			@ Prow ()+1,001 Psay  TRA1->C7_NUM 
			@ Prow ()  ,008 Psay  TRA1->C7_ITEM 
		    SA2->(DbSeek(xFilial("SA2")+ TRA1->C7_FORNECE+TRA1->C7_LOJA))
	
			@ Prow ()  ,013 Psay TRA1->C7_FORNECE+"-"+TRA1->C7_LOJA+"-"+Substr(SA2->A2_NOME,1,20)
	
			@ Prow ()  ,046 Psay TRA1->C7_RECOMPR
			@ Prow ()  ,045 Psay TRA1->C7_QUANT Picture "@E 999,999,999.99"    		
			@ Prow ()  ,059 Psay TRA1->C7_PRECOOR Picture "@E 999,999,999.99"
			@ Prow ()  ,076 Psay TRA1->C7_PRECO Picture "@E 999,999,999.99"
			@ Prow ()  ,090 Psay (TRA1->C7_PRECOOR-TRA1->C7_PRECO) Picture "@E 999,999,999.99"  
			@ Prow ()  ,107 Psay ((TRA1->C7_PRECO/TRA1->C7_PRECOOR)-1)*100 Picture "@E 9999.99" + "%"
			@ Prow ()  ,116 Psay (TRA1->C7_QUANT*TRA1->C7_PRECO) Picture "@E 999,999,999.99"  
	
		EndIf

	    _tprecoor += C7_PRECOOR	    				
		_tpreco   += C7_PRECO
		_tdifer   += (TRA1->C7_PRECOOR-TRA1->C7_PRECO)
		_ttdesc   += ((TRA1->C7_PRECO/TRA1->C7_PRECOOR)-1)*100
  		_ttped    += (TRA1->C7_QUANT*TRA1->C7_PRECO)+(TRA1->C7_IPI/100*TRA1->C7_PRECO)

// 		@ Prow ()  ,059 Psay Substr(TRA1->X5_DESCRI,01,15) // Login
//    	@ Prow ()  ,075 Psay Iif(Substr(TRA1->X5_DESCRI,32,1)=="S","Sim",OemToAnsi("Não")) // Contrato S=SIM/N=NAO
//		@ Prow ()  ,085 Psay  Substr(TRA1->X5_DESCRI,20,1) // Ordem
	
	    TRA1->(DbSkip())
   	ENDDO
	@ Prow()+2,000 PSAY __PrtThinLine()                         
    @ Prow() +1, 002 Psay "TOTAL"
	@ Prow()   , 057 Psay _tprecoor Picture "@E 999,999,999.99" 
	@ Prow()   , 075 Psay _tpreco   Picture "@E 999,999,999.99" 
	@ Prow()   , 090 Psay _tdifer   Picture "@E 999,999,999.99" 
	@ Prow()   , 104 Psay _ttdesc   Picture "@E 999999.99" + "%"
	@ Prow()   , 115 Psay _ttped    Picture "@E 999,999,999.99" 
	
Return(nil)
                                        
Static Function Cabecalho()

aDriver := ReadDriver()

   @ 0,0 PSAY &(aDriver[4])
   /*
If ( Tamanho == 'P' )
    @ 0,0 PSAY &(aDriver[1])
ElseIf ( Tamanho == 'G' )
    @ 0,0 PSAY &(aDriver[5])
ElseIf ( Tamanho == 'M' ) .And. ( aReturn[4] == 1 ) 
    @ 0,0 PSAY &(aDriver[3])
ElseIf ( Tamanho == 'M' ) .And. ( aReturn[4] == 2 ) 
    @ 0,0 PSAY &(aDriver[4])
EndIf 
     */
@ Prow()+1,00   Psay Repli("*",132)
//Lin := Lin + 1
@ Prow()+1,00   Psay "*"+SM0->M0_NOMECOM
@ Prow()+1,112  Psay "Folha : "                                                                                                    
@ Prow()+1,124  Psay StrZero(_nPag,5,0)+"  *"
@ Prow()+2,00   Psay "*S.I.G.A. / "+nomeprog
@ Prow()+2,20   Psay PadC(titulo,82)
@ Prow()+2,112  Psay "DT.Ref.: "+Dtoc(dDataBase)+"*"
@ Prow()+2+1,00 Psay "*Hora...: "+Time()
@ Prow()+3  ,41 Psay "Periodo de: " + DtoC(mv_par01) + " Ate: " + DtoC(mv_par02) +"  "+Iif(aReturn[8] == 1,"Por Data",Iif(aReturn[8] == 2,"Por Fornecedor",Iif(aReturn[8] == 3,"Por Comprador","Por Recompra")))
@ Prow()+3,112  Psay "Emissao: "+Dtoc(Date())+"*"
@ Prow()+4 ,00  Psay Repli("*",132)
@ Prow()+5,00   Psay " "
//lin:=Lin+5
@ Prow() + 1 , 001 Psay Cabec1       
//Lin := Lin + 1         

Return
  