/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST088        ³ Alexandre R. Bento    ³ Data ³ 30.03.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao dos Refugos por maquina e turno do mes          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padrao para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


#include "Rwmake.ch"      
#include "Topconn.ch"

User Function NhEst088()  

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,cErro")
SetPrvt("CCOMPAC,CNORMAL,cQuery,cQuery1,M_PAG,_nTotGer,nTotProd")


cString   :="SD3"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir a ")
cDesc2    := OemToAnsi("Lista de Refugo por maquina e turno")
cDesc3    := OemToAnsi(" ")
tamanho   :="M"
limite    := 260
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  :="NHEST088"
nLastKey  := 0
titulo    :="LISTA DE " 
Cabec1    :=OemToAnsi("PEÇA : ")                                                                  
cabec2    :=OemToAnsi("CARACTERISTICA DO DEFEITO                                               MAQUINA    TURNO   OPERAÇÃO  LINHA       TOTAL DE PEÇAS")
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     :="NHEST088"          //Nome Default do relatorio em Disco
_cPerg    := "EST088"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)
nTotProd  := 0
// Parametros Utilizados
// mv_par01 = Data de emisao inicial
// mv_par02 = Data de emisao final
// mv_par03 = codigo do produto inicial
// mv_par04 = codigo do produto final
// mv_par05 = codigo do defeito inicial
// mv_par06 = codigo do defeito final
// mv_par07 = codigo cacteristica defeito inicial
// mv_par08 = codigo cacteristica defeito final


// AjustaSX1() // Verifica os parametros

Pergunte('EST088',.T.)

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

aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]                   
                                 

If Month(mv_par01) <> Month(mv_par02)
   MsgBox(OemToAnsi("Atenção Relatório só pode sair dentro do mês","Refugo","STOP"))
   Return
Endif

//nUltDia := Day(UltimoDia(mv_par02))                                                                   


Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
TMP->(DbGoTop())
If Empty(TMP->D3_COD)
   MsgBox("Nenhum produto foi encontrado","Atencao","STOP")
   TMP->(DbCloseArea())
   Return
Endif     


Processa( {|| RptDetail() },"Imprimindo...")
TMP->(DbCloseArea())

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
   ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function Gerando()    

   cQuery := "SELECT SD3.D3_CARDEF,SD3.D3_DEFEITO,SD3.D3_OPERACA,SD3.D3_TURNO,SD3.D3_MAQUINA,SD3.D3_LINHA,SD3.D3_COD,SD3.D3_TM,SD3.D3_LOCAL,SZ6.Z6_DESC,SZ8.Z8_DESC,SB1.B1_DESC,SUM(SD3.D3_QUANT) AS 'QTDE'"
   cQuery += " FROM " + RetSqlName( 'SD3' ) +" SD3, " + RetSqlName( 'SZ6' ) +" SZ6, " + RetSqlName( 'SZ8' ) +" SZ8, " + RetSqlName( 'SB1' ) +" SB1 "     
   cQuery += " WHERE SD3.D3_FILIAL = '" + xFilial("SD3")+ "'"
   cQuery += " AND SZ6.Z6_FILIAL = '" + xFilial("SZ6")+ "'"
   cQuery += " AND SZ8.Z8_FILIAL = '" + xFilial("SZ8")+ "'"
   cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "'"
   cQuery += " AND SD3.D3_FILIAL = SZ6.Z6_FILIAL"
   cQuery += " AND SD3.D3_DEFEITO = SZ6.Z6_COD"
   cQuery += " AND SD3.D3_FILIAL = SZ8.Z8_FILIAL"
   cQuery += " AND SD3.D3_CARDEF = SZ8.Z8_COD"
   cQuery += " AND SD3.D3_COD = SB1.B1_COD"   
   If SM0->M0_CODIGO=="NH"                            
      cQuery += " AND SD3.D3_TM IN ('499','002')"  
      If Mv_par09 == "97"
         cQuery += " AND SD3.D3_LOCAL IN ('99','00','97')" 
      Else   
         cQuery += " AND SD3.D3_LOCAL IN ('99','00')" 
      Endif   
   ElseIf SM0->M0_CODIGO=="FN"
      cQuery += " AND SD3.D3_TM IN ('501')" 
      cQuery += " AND SD3.D3_LOCAL IN ('11','95')" 
   Endif   
   cQuery += " AND SD3.D3_EMISSAO >= '" + Dtos(mv_par01) + "' AND SD3.D3_EMISSAO <= '" + Dtos(mv_par02) +"'"
   cQuery += " AND SD3.D3_COD BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"   
//   cQuery += " AND SD3.D3_COD = '" + mv_par03 + "' "
   cQuery += " AND SD3.D3_LOCAL = '" + mv_par05 + "' "   
   cQuery += " AND SD3.D3_TURNO BETWEEN '" + mv_par06 + "' AND '" + mv_par07 + "'"
   cQuery += " AND SD3.D3_MAQUINA BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'" 
   cQuery += " AND SD3.D3_LINHA BETWEEN '" + mv_par10 + "' AND '" + mv_par11 + "'" 
//   cQuery += " AND SD3.D3_FORNECE BETWEEN '" + mv_par12 + "' AND '" + mv_par13 + "'" 
//   cQuery += " AND SD3.D3_LOJA BETWEEN '" + mv_par14 + "' AND '" + mv_par15 + "'" 
   cQuery += " AND SD3.D3_ESTORNO <> 'S' AND SD3.D3_LOCORIG NOT IN ('02','03')" 
   cQuery += " AND SD3.D3_MAQUINA <> ' '"   
   cQuery += " AND SD3.D_E_L_E_T_ = ' '"
   cQuery += " AND SZ6.D_E_L_E_T_ = ' '"
   cQuery += " AND SZ8.D_E_L_E_T_ = ' '"          
   cQuery += " AND SB1.D_E_L_E_T_ = ' '"             
   cQuery += " GROUP BY SD3.D3_CARDEF,SD3.D3_DEFEITO,SD3.D3_OPERACA,SD3.D3_TURNO,SD3.D3_MAQUINA,SD3.D3_LINHA,SD3.D3_COD,SD3.D3_TM,SD3.D3_LOCAL,SZ6.Z6_DESC,SZ8.Z8_DESC,SB1.B1_DESC"
//   cQuery += " ORDER BY SD3.D3_COD,SD3.D3_EMISSAO,SD3.D3_CARDEF,SD3.D3_DEFEITO,SD3.D3_LOCAL ASC" 
//   cQuery += " AND CAST(SD3.D3_OPERACA AS NUMERIC(3)) BETWEEN " + Str(mv_par10,3) + " AND " + Str(mv_par11,3)+" " 
  cQuery += " ORDER BY SD3.D3_CARDEF,SD3.D3_DEFEITO,SD3.D3_OPERACA,SD3.D3_TURNO,SD3.D3_MAQUINA,SD3.D3_LINHA,SD3.D3_COD,SD3.D3_TM,SD3.D3_LOCAL,SZ6.Z6_DESC,SZ8.Z8_DESC,SB1.B1_DESC"

//  MemoWrit('C:\TEMP\EST088.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
   TCQUERY cQuery NEW ALIAS "TMP"     
//	TcSetField("TMP","D3_EMISSAO","D")  // Muda a data de string para date    


cQuery1 := "SELECT SUM(Z9_QUANT) AS 'TOTAL' FROM "+ RetSqlName( 'SZ9' )
cQuery1 += " WHERE Z9_FILIAL = '" + xFilial("SZ9")+ "'"
cQuery1 += " AND D_E_L_E_T_  = ' '"
cQuery1 += " AND Z9_DATA >= '" + Dtos(mv_par01) + "' AND Z9_DATA <= '" + Dtos(mv_par02) +"'"          
cQuery1 += " AND Z9_COD =  '" + mv_par03 + "'"         
//cQuery1 += " AND Z9_FORNECE BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "'"               	   
//cQuery1 += " AND Z9_LOJA BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "'"       
//MemoWrit('C:\TEMP\EST088A.SQL',cQuery1)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery1 NEW ALIAS "TRB"     
          
TRB->(DbGoTop())
If !Empty(TRB->TOTAL)       
    nTotProd := TRB->TOTAL // Pega o total de produçao do SZ9
Endif
//DbSelectArea("TRB")
TRB->(DbCloseArea()) //fecha alias da cquery1

Return


Static Function RptDetail()       

//ProcRegua(Reccount("TMP"))

TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))
//SetRegua(TMP->(RecCount()))
//ALERT(TMP->(RecCount()))
Titulo := Titulo+IIF(Mv_par04=="97","RETRABALHO","REFUGO") + " POR MAQUINA E TURNO DO MES DE " + UPPER(MesExtenso(Month(Mv_par01))) +"/" + StrZero(Year(Mv_par01),4)+ " DO ALMOX. " + Subs(mv_par04,1,2)
Cabec1+= Alltrim(TMP->D3_COD)+"-"+TMP->B1_DESC
Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)     
//_cCod := TMP->D3_COD   
_nTotGer := 0
While TMP->(!Eof())
   
   IncProc("Processando Produtos ... " + TMP->D3_COD)     
   If Prow() > 58
      _nPag := _nPag + 1
      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)        
   Endif
   
   @ Prow() +1, 001 Psay TMP->D3_CARDEF+TMP->D3_DEFEITO+"-"+Alltrim(TMP->Z8_DESC)+" "+Alltrim(TMP->Z6_DESC)
   @ Prow()   , 075 Psay TMP->D3_MAQUINA
   @ Prow()   , 085 Psay TMP->D3_TURNO
   @ Prow()   , 094 Psay TMP->D3_OPERACA   
   @ Prow()   , 103 Psay TMP->D3_LINHA      
   @ Prow()   , 110 Psay Transform(TMP->QTDE,"@E 9,999,999,999.99")      
   _nTotGer += TMP->QTDE //soma p/ imprimir o total geral
   TMP->(Dbskip())
Enddo 
@ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes do total do rodape da pagina
@ Prow() + 1, 001 Psay "TOTAL GERAL DE REFUGO MENSAL "
@ Prow()    , 110 Psay Transform(_nTotGer,"@E 9,999,999,999.99")      
@ Prow() + 1, 001 Psay "TOTAL PRODUZIDO MENSAL "
@ Prow()    , 110 Psay Transform(nTotProd,"@E 9,999,999,999.99")      
@ Prow() + 1, 001 Psay "MEDIAS GERAL DE REFUGO  MENSAL"
@ Prow()    , 120 Psay Transform((_nTotGer/nTotProd)*100,"@E 999.9")+"%"      
Return

