/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST106        ³ Joao Felipe           ³ Data ³ 20.12.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Carregamento                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"  

User Function NhEST106()  

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave,nTipo,aReturn")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,nSubTot")
SetPrvt("_aGrupo,_cApelido,_cCodUsr,_lPri,_nTotItem,")

cString   := "SZM"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir o ")
cDesc2    := OemToAnsi("Resumo das Saidas")
cDesc3    := OemToAnsi("")
tamanho   := "G"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
//nControle := 15
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST106"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "Notas Fiscais - Expedidadas / Faturamento "                                                                                                                        
Cabec1    := " Placa        Data         Hora           Cliente          Codigo WHB       Cod.Cliente             Descrição               Qtd.  Vol.   NF     Ord.Lib.   Motorista                Ord.   Obs. Expedidors"
Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHEST106"       //Nome Default do relatorio em Disco
_cPerg    := "EST106"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX1)
_AOrd	  := {OemToAnsi("Por Placa"),OemToAnsi("Por Horário"),OemToAnsi("Por Cliente")} 
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

//Mv_par01 := PERIODO INICIO
//Mv_par02 := PERIODO FIM
//Mv_par03 := PRODUTO INICIO
//Mv_par04 := PRODUTO FIM
//MV_par05 := TIPO DO PRODUTO
//Mv_par06 := CLIENTE INICIO
//Mv_par07 := CLIENTE FIM
//mv_par08 := LOJA INICIO
//mv_par09 := LOJA FIM
//Mv_par10 := NOTA INICIO
//Mv_par11 := NOTA FIM
//Mv_par12 := WHBIII (SIM/NAO)
                                                                                         
If !Pergunte(_cPerg,.T.) //ativa os parametros
	Return(nil)
Endif
                                     
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,_AOrd,,tamanho) 

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
If Empty(TMP->ZM_PLACACM)
   MsgBox("Não existem dados para estes parâmetros...verifique!","Atencao","STOP")
   DbselectArea("TMP")
   DbCloseArea()
   Return                                                 
Endif

//inicio da impressao
Processa( {|| RptDet1() },"Imprimindo...")

DbselectArea("TMP")
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
//**********************************
 
	cQuery := "SELECT SZM.ZM_PLACACM,SZN.ZN_VOLUME,SZN.ZN_NFISCAL,SZN.ZN_DOC,SZN.ZN_COD,SZN.ZN_QUANT,SZN.ZN_NFISCAL,SZM.ZM_OBSEXP,"
    cQuery += "SZM.ZM_LACRE, SB1.B1_DESC, SB1.B1_CODAP5,SZM.ZM_HORAPOR,SZM.ZM_DATAPOR,SZM.ZM_PRIORI,SZM.ZM_DOC,SZM.ZM_MOTORIS, "
    cQuery += "'CLIENTE' = "
    cQuery += "CASE "
    cQuery += "   WHEN SF2.F2_TIPO = 'B' THEN "
    cQuery += "        (SELECT SA2.A2_NOME FROM " +RetSqlName('SA2') +" SA2 " 
    cQuery += "         WHERE SA2.D_E_L_E_T_ = ' ' AND SA2.A2_COD = SF2.F2_CLIENTE "
    cQuery += "         AND SA2.A2_LOJA = SF2.F2_LOJA) "
    cQuery += "   ELSE "
    cQuery += "        (SELECT SA1.A1_NOME FROM " +RetSqlName('SA1') +" SA1 " 
    cQuery += "         WHERE SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SF2.F2_CLIENTE "
    cQuery += "         AND SA1.A1_LOJA = SF2.F2_LOJA) "
    cQuery += "END "
    cQuery += "FROM " + RetSqlName('SZN') +" SZN, " +RetSqlName('SF2') +" SF2, " + RetSqlName('SZM') +" SZM, " + RetSqlName('SB1') +" SB1 "
    cQuery += "WHERE SB1.B1_COD = SZN.ZN_COD "
    cQuery += "AND SB1.D_E_L_E_T_ = ' ' "    
	if Empty(mv_par05)
		cQuery += "AND SB1.B1_TIPO BETWEEN '' AND 'ZZ'"
	else
		cQuery += "AND SB1.B1_TIPO = '"+mv_par05+"'"
	endif     
	
	If SM0->M0_CODIGO == "FN" .And. mv_par12 == 1                              
		cQuery += "AND SB1.B1_GRUPO = 'PA02' "
    ElseIf SM0->M0_CODIGO == "FN" .And. mv_par12 == 2     
   		cQuery += " AND SB1.B1_GRUPO = 'PA01'"
	EndIf 
		    
    cQuery += "AND SF2.F2_DOC = SZN.ZN_NFISCAL "
    cQuery += "AND SF2.F2_SERIE = SZN.ZN_SERIE "
    cQuery += "AND SF2.D_E_L_E_T_ = ' ' "
    cQuery += "AND SZN.ZN_DOC = SZM.ZM_DOC "
    cQuery += "AND SZN.ZN_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' " 
    cQuery += "AND SZN.ZN_NFISCAL BETWEEN '"+mv_par10+"' AND '"+mv_par11+"' "     
    cQuery += "AND SZN.D_E_L_E_T_ = ' ' "
    cQuery += "AND SZM.ZM_CLIENTE BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "      
    cQuery += "AND SZM.ZM_LOJA BETWEEN '"+mv_par08+"' AND '"+mv_par09+"' "
    cQuery += "AND SZM.ZM_DATAEXP BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' "
    cQuery += "AND SZM.D_E_L_E_T_ = ' ' "

	If aReturn[8] == 1 //ordem por placa
	    cQuery += "ORDER BY SZM.ZM_PLACACM, SZM.ZM_DATAPOR, SZM.ZM_HORAPOR "
	ElseIf aReturn[8] == 2 //ordem por horario
	    cQuery += "ORDER BY SZM.ZM_HORAPOR, SZM.ZM_DATAPOR, SZM.ZM_PLACACM  "	
	ElseIf aReturn[8] == 3 //ordem por cliente
	    cQuery += "ORDER BY CLIENTE, SZM.ZM_DATAPOR, SZM.ZM_HORAPOR  "	
    EndIf

    MemoWrit('C:\TEMP\NHEST106.SQL',cQuery)
    TCQUERY cQuery NEW ALIAS "TMP"                      
    DbSelectArea("TMP")

Return


Static Function RptDet1()
Local _cPlaca := ""
               
@ 00, 00 pSay Chr(15)      

// imprime cabeçalho
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
      
   
DbSelectArea("TMP") 
dbgotop()

If Prow() > 66
   _nPag := _nPag + 1
   Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
Endif                     
   


While !eof()
	If Prow() > 56
	   _nPag := _nPag + 1
	   Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0) 
	Endif
	
	If _cPlaca  <> TMP->ZM_PLACACM
		_cPlaca := TMP->ZM_PLACACM
		@ Prow() +1, 000 PSAY __PrtThinLine()
	EndIf

    @ Prow() +1, 001 Psay SUBSTR(TMP->ZM_PLACACM,0,9)
    @ Prow()   , 012 Psay Stod(TMP->ZM_DATAPOR)
    @ Prow()   , 025 Psay TMP->ZM_HORAPOR
    @ Prow()   , 036 Psay SUBSTR(TMP->CLIENTE,0,20)       
	@ Prow()   , 059 Psay TMP->ZN_COD
	@ Prow()   , 077 Psay TMP->B1_CODAP5
    @ Prow()   , 094 Psay Substr(TMP->B1_DESC,1,25)
    @ Prow()   , 120 Psay TMP->ZN_QUANT                   Picture"@E 999,999"
    @ Prow()   , 130 Psay TMP->ZN_VOLUME
    @ Prow()   , 134 Psay TMP->ZN_NFISCAL
//    @ Prow()   , 082 Psay "___"
//    @ Prow()   , 126 Psay TMP->ZM_LACRE
    @ Prow()   , 144 Psay TMP->ZM_DOC
    @ Prow()   , 154 Psay SUBSTR(TMP->ZM_MOTORIS,1,26)
    @ Prow()   , 181 Psay TMP->ZM_PRIORI       
    @ Prow()   , 184 Psay TMP->ZM_OBSEXP

    dbskip()

enddo
@ Prow() +1, 000 PSAY __PrtThinLine()
Return