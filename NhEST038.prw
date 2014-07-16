/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHest038        ³ Fabio Nico            ³ Data ³ 03.06.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao da Previsao de Desembolso por Fornecedor        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NhEST038() 

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1,_nTotAberto,nTotAtende,_nSubAberto,_nSubAtende")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,_nSemana, _aPed,_axPed,_n,_nSaldo,_anPed,_azPed,_c7NumPro")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,nSubTot,nTotGer,nTotCC,nConta,dData1,dData2,dData3,dData4,dData5,dData6,cCentroC")
SetPrvt("_aGrupo,_cApelido,_cCodUsr,_lPri,_nTotItem,_nTotcIpi,nSubIpi,nTotIpi,_nTotPe,_nIpi,_c7Num,_z")

cString   := "SC7"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir a  ")
cDesc2    := OemToAnsi("Previsao de Desembolso por Fornecedor")
cDesc3    := OemToAnsi("")
tamanho   := "G"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST038"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "COMPRAS EFETUADAS FORNECEDOR X PRODUTO X VALOR X PERIODO"
Cabec1    := "Codigo              Descrição                         Quant          Val.Unit           IPI        Total       Documento     N.Pedido    Dt.Emissao"
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13
Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHEST038"       //Nome Default do relatorio em Disco
_cPerg    := "EST038"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX1)
aMatriz   := {}
_aPed     := {}
_axPed    := {}
_nTotPe   := 0
_nIpi     := 0
_anPed    := {}
_azPed    := {}	

dbSelectArea("SX1")
dbSetOrder(1)
SX1->(DbSeek(_cPerg))
If Sx1->(Found())
	RecLock('SX1')
	SX1->X1_CNT01 := _cCodUsr
	MsUnLock('SX1')
Endif

//Mv_par01 :=	FORNECEDOR INICIO
//Mv_par02 :=	FORNECEDOR FIM
//Mv_par03 :=	EMISSAO DE
//Mv_par04 :=	EMISSAO ATE
//Mv_par05 :=	VALOR TOTAL DOS ITENS DE
//Mv_par06 :=	VALOR TOTAL DOS ITENS ATE 
//Mv_par07 :=   Centro de Custo Inicial
//Mv_par08 :=   Centro de Custo Final

                                                                                         
If !Pergunte(_cPerg,.T.) //ativa os parametros
	Return(nil)
Endif
                                     
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,,,tamanho)     
//wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,cTamanho,{},.F.)

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo   := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))
aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]   

// inicio do processamento do relatório
Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
                  
// verifica se existe dados para o relatorio atraves da validação de dados em um campo qualquer

TMP->(DbGoTop())
If Empty(TMP->D1_COD)
   MsgBox("Não existem dados para estes parâmetros...verifique!","Atencao","STOP")
   DbSelectArea("TMP")
   DbCloseArea()

   Return
Endif

//inicio da impressao
Processa( {|| RptDet1() },"Imprimindo...")
DbSelectArea("TMP")
DbCloseArea()

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


Static Function Gerando()

	cQuery := "SELECT SD1.D1_COD, SD1.D1_QUANT, SD1.D1_VUNIT, SD1.D1_FORNECE, SD1.D1_DOC, SD1.D1_PEDIDO, SD1.D1_EMISSAO, "
    cQuery += "SF1.F1_FORNECE, SF1.F1_EMISSAO, SF1.F1_DOC, SA2.A2_COD, SA2.A2_NOME, SB1.B1_COD, SB1.B1_DESC, SD1.D1_TOTAL, SD1.D1_VALIPI "
	cQuery += "FROM " + RetSqlName( 'SD1' ) +" SD1, " + RetSqlName( 'SF1' ) +" SF1, "
	cQuery += + RetSqlName( 'SA2' ) +" SA2, " + RetSqlName( 'SB1' ) +" SB1 "   
	cQuery += "WHERE SB1.B1_COD = SD1.D1_COD "
    cQuery += "AND SB1.D_E_L_E_T_ <> '*' "
	cQuery += "AND SA2.A2_COD = SD1.D1_FORNECE "
	cQuery += "AND SA2.D_E_L_E_T_ <> '*' "
	cQuery += "AND SF1.F1_FORNECE = SD1.D1_FORNECE "
	cQuery += "AND SF1.F1_DOC = SD1.D1_DOC "
	cQuery += "AND SF1.F1_SERIE = SD1.D1_SERIE "
    cQuery += "AND SF1.F1_FILIAL = SA2.A2_LOJA "
	cQuery += "AND SF1.D_E_L_E_T_ <> '*' "
	cQuery += "AND SD1.D1_TES <> '241' "
	cQuery += "AND SD1.D1_EMISSAO BETWEEN '"+ Dtos(Mv_par03) + "' AND '"+ Dtos(Mv_par04) + "' "
    cQuery += "AND SD1.D1_FORNECE BETWEEN '" + mv_par01 + "' And '" +  mv_par02 + "' "
    cQuery += "AND SD1.D1_TOTAL BETWEEN '" + STR(mv_par05) + "' And '" +  STR(mv_par06) + "' "    
    cQuery += "AND SD1.D1_COD BETWEEN '" + mv_par07 + "' And '" +  mv_par08 + "' "
    cQuery += "AND SD1.D1_CC BETWEEN '"  + mv_par09 + "' And '" +  mv_par10 + "' "    
	cQuery += "AND SD1.D_E_L_E_T_ <> '*' "
	cQuery += "ORDER BY 4,15 desc"  
	
    //MemoWrit('C:\TEMP\NHEST038.SQL',cQuery)
    TCQUERY cQuery NEW ALIAS "TMP"                      
    DbSelectArea("TMP")

Return


Static Function RptDet1()

// imprime cabeçalho
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
       
// inicializa totalizadores
aux_total := 0
   
DbSelectArea("TMP") 
dbgotop()

aux_forne = TMP->D1_FORNECE
@ Prow() + 1, 000 Psay "Fornecedor : " + TMP->A2_NOME

While !eof()

   If Prow() > 56
      _nPag := _nPag + 1
      Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
   Endif         

    if aux_forne = TMP->D1_FORNECE
     		@ Prow() +1, 001 Psay TMP->D1_COD
    		@ Prow()   , 020 Psay TMP->B1_DESC
   			@ Prow()   , 055 Psay TMP->D1_QUANT
			@ Prow()   , 070 Psay TMP->D1_VUNIT     picture "@E 99,999.99"
			@ Prow()   , 085 Psay TMP->D1_VALIPI    picture "@E 99,999.99"			
			@ Prow()   , 100 Psay TMP->D1_TOTAL+TMP->D1_VALIPI     picture "@E 99,999.99"			
			@ Prow()   , 115 Psay TMP->D1_DOC	
			@ Prow()   , 130 Psay TMP->D1_PEDIDO
			@ Prow()   , 145 Psay STOD( TMP->D1_EMISSAO)
			aux_total := aux_total + TMP->D1_TOTAL + TMP->D1_VALIPI
		else               

            @ Prow() +1, 069 Psay "Total..:"
            @ Prow()   , 082 Psay aux_total        picture "@E 9,999,999.99"			
            aux_total := 0
			
 			@ Prow() +2, 000 Psay "Fornecedor : "  + TMP->A2_NOME
     		@ Prow() +1, 001 Psay TMP->D1_COD
   			@ Prow()   , 020 Psay TMP->B1_DESC
   			@ Prow()   , 055 Psay TMP->D1_QUANT
			@ Prow()   , 070 Psay TMP->D1_VUNIT     picture "@E 99,999.99"
			@ Prow()   , 085 Psay TMP->D1_VALIPI    picture "@E 99,999.99"			
			@ Prow()   , 100 Psay TMP->D1_TOTAL     picture "@E 99,999.99"			
			@ Prow()   , 115 Psay TMP->D1_DOC	
			@ Prow()   , 130 Psay TMP->D1_PEDIDO
			@ Prow()   , 145 Psay STOD(TMP->D1_EMISSAO)
//			aux_forne = TMP->D1_FORNECE          
			aux_total := aux_total + TMP->D1_TOTAL + TMP->D1_VALIPI
	endif
	aux_forne = TMP->D1_FORNECE
	dbskip()

enddo
@ Prow() +1, 070 Psay "Total..:"
@ Prow()   , 082 Psay aux_total    picture "@E 9,999,999.99"

Return