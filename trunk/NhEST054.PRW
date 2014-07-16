/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST054        ³ Fabio Nico            ³ Data ³ 06.06.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Cargas                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NhEST054() 

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave,nTipo,aReturn")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,nSubTot")
SetPrvt("_aGrupo,_cApelido,_cCodUsr,_lPri,_nTotItem,")

cString   := "SC7"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir O ")
cDesc2    := OemToAnsi("Resumo das Saidas")
cDesc3    := OemToAnsi("")
tamanho   := "M"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
//nControle := 15
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST054"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.
lDivPed   := .F.
titulo    := "Roteiro de Entregas  "
Cabec1    := "Prioridade      Volume       Nota Fiscal    Nota Retorno                         Data Entrega   Hora Entrega   Carimbo/Assinatura"
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13
Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHEST054"       //Nome Default do relatorio em Disco
_cPerg    := "EST054"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX1)
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

//Mv_par01 := PLACA DO CAMINHAO
                                                                                         
If !Pergunte(_cPerg,.T.) //ativa os parametros
	Return(nil)
Endif
                                     
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho) 

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
//**********************************

	cQuery := "SELECT SZM.ZM_PRIORI,SF2.F2_TIPO,SZM.ZM_PLACACM,SZN.ZN_VOLUME,SZN.ZN_NFISCAL,SZN.ZN_DOC,"
    cQuery += "'CLIENTE' = "
    cQuery += "CASE "
    cQuery += "   WHEN SF2.F2_TIPO = 'N' THEN "
    cQuery += "        (SELECT SA1.A1_NOME+' - '+SA1.A1_MUN+' - '+SA1.A1_EST FROM SA1NH0 SA1 "
    cQuery += "         WHERE SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SF2.F2_CLIENTE "
    cQuery += "         AND SA1.A1_LOJA = SF2.F2_LOJA) "
    cQuery += "   WHEN SF2.F2_TIPO = 'D' OR SF2.F2_TIPO = 'B' THEN "
    cQuery += "        (SELECT SA2.A2_NOME+' - '+SA2.A2_MUN+' - '+SA2.A2_EST FROM SA2NH0 SA2 "
    cQuery += "         WHERE SA2.D_E_L_E_T_ = ' ' AND SA2.A2_COD = SF2.F2_CLIENTE "
    cQuery += "         AND SA2.A2_LOJA = SF2.F2_LOJA) "    
    cQuery += "   ELSE "
    cQuery += "        (SELECT SA2.A2_NOME+' - '+SA2.A2_MUN+' - '+SA2.A2_EST FROM SA2NH0 SA2 "
    cQuery += "         WHERE SA2.D_E_L_E_T_ = ' ' AND SA2.A2_COD = SF2.F2_CLIENTE "
    cQuery += "         AND SA2.A2_LOJA = SF2.F2_LOJA) "
    cQuery += "END, "
    cQuery += " "
    cQuery += "* FROM SZNNH0 SZN,SF2NH0 SF2,SZMNH0 SZM "
    cQuery += "WHERE SZN.D_E_L_E_T_ = ' ' "
    cQuery += "AND SF2.D_E_L_E_T_ = ' ' "
    cQuery += "AND SZM.D_E_L_E_T_ = ' ' "
    cQuery += "AND SF2.F2_DOC = SZN.ZN_NFISCAL "
    cQuery += "AND SF2.F2_SERIE = SZN.ZN_SERIE "
    cQuery += "AND SZN.ZN_DOC = SZM.ZM_DOC "
    cQuery += "AND SZM.ZM_PLACACM BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
    cQuery += "AND SZM.ZM_DATAEXP BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
    cQuery += "AND SZM.ZM_CLIENTE BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
    cQuery += "AND SZM.ZM_DOC BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' "
    cQuery += "AND SZM.ZM_PORTARI = ' ' "
    cQuery += "ORDER BY SZM.ZM_PRIORI,SZN.ZN_DOC "

    MemoWrit('C:\TEMP\NHEST054.SQL',cQuery)
    TCQUERY cQuery NEW ALIAS "TMP"                      
    DbSelectArea("TMP")

Return


Static Function RptDet1()
               
@ 00, 00 pSay Chr(15)      

// imprime cabeçalho
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
      
   
DbSelectArea("TMP") 
dbgotop()

If Prow() > 66
   _nPag := _nPag + 1
   Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
Endif                     
   
aux_doc := ''

While !eof()
	If Prow() > 56
	   _nPag := _nPag + 1
	   Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0) 
	Endif             
   
   if aux_doc <> TMP->ZN_DOC
      @ Prow() +2, 001 Psay 'Cliente :  ' + TMP->CLIENTE
      @ Prow() +1, 001 Psay 'Ordem de Liberacao : ' + TMP->ZN_DOC
   endif      
   @ Prow() +1, 001 Psay TMP->ZM_PRIORI
   @ Prow()   , 020 Psay TMP->ZN_VOLUME
   @ Prow()   , 030 Psay TMP->ZN_NFISCAL
   @ Prow()   , 040 Psay TMP->ZN_NFRET
   aux_doc = TMP->ZN_DOC 
   dbskip()
   if aux_doc <> TMP->ZN_DOC
      @ Prow() , 085 Psay '___/___/___  ___:___     ____________________'
   endif      


enddo
@ Prow() +1, 000 PSAY __PrtThinLine()
Return