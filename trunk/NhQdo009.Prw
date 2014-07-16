/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHQDO009        ³ Alexandre R. Bento     ³ Data ³ 19.01.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Licoes Aprendidas                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NhQdo009() 

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave,nTipo,aReturn")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,nSubTot")
SetPrvt("_aGrupo,_cApelido,_cCodUsr,_lPri,_nTotItem,")

cString   := "SZP"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir as")
cDesc2    := OemToAnsi(" Lições Aprendidas")
cDesc3    := OemToAnsi("")
tamanho   := "M"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 200
//nControle := 15
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHQDO009"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := OemToAnsi("Lições Aprendidas WHB")
Cabec1    := OemToAnsi("  Data      Usuario                            Num Item   Util. Informação   Documento")
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13
Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHQDO009"       //Nome Default do relatorio em Disco
_cPerg    := "QDO009"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX1)

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
//Mv_par05 := CLIENTE INICIO
//Mv_par06 := CLIENTE FIM
//Mv_par07 := NOTA INICIO
//Mv_par08 := NOTA FIM
                                                                                         
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
If Empty(TMP->ZP_ITEM)
   MsgBox("Não existem dados para estes parâmetros...verifique!","Atencao","STOP")
   TMP->(DbCloseArea())
   Return                                                 
Endif

//inicio da impressao
Processa( {|| RptDet1() },"Imprimindo...")

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
//**********************************

	cQuery := "SELECT * FROM " + RetSqlName('SZP') "
    cQuery += " WHERE ZP_FILIAL = '" + xFilial("SZP")+ "'"    
    cQuery += "AND D_E_L_E_T_ = ' ' "    
    cQuery += "AND ZP_DATA BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' " 
    cQuery += "ORDER BY ZP_FILIAL,ZP_DATA"

    MemoWrit('C:\TEMP\NHQDO009.SQL',cQuery)
    TCQUERY cQuery NEW ALIAS "TMP"                      
	TcSetField("TMP","ZP_DATA","D")  // Muda a data de string para date        
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

While TMP->(!eof())                    '
   If Prow() > 56
	  _nPag := _nPag + 1
	  Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0) 
   Endif             

//       @ Prow() +1, 000 PSAY __PrtThinLine()
       @ Prow() +1, 001 Psay DtoC(TMP->ZP_DATA)
	   @ Prow()   , 010 Psay UsrRetName(TMP->ZP_LOGIN)       
       @ Prow()   , 048 Psay TMP->ZP_ITEM	   
	   @ Prow()   , 063 Psay Iif(TMP->ZP_INFORMA=='S',"SIM","NAO")
	   @ Prow()   , 080 Psay TMP->ZP_DOCUME
       

   TMP->(dbskip())

Enddo
@ Prow() +1, 000 PSAY __PrtThinLine()
Return