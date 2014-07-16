/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST108  ³ Autor ³ João Felipe da Rosa    Data ³ 24/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera TXT da Movimentação do Estoque                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Estoque/Custos                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
 
#include "rwmake.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"    
#include "protheus.ch"
 
User Function NHEST108()

_cPerg    := "EST108" 
cQuery    := ""
_aGer     := {}

/* 
+-----------------------+
| mv_par01 de produto   |
| mv_par02 até produto  |
| mv_par03 de data      |
| mv_par04 até data     |
| mv_par05 de cc        |
| mv_par06 até cc       |
+-----------------------+
*/

Pergunte(_cPerg,.T.)

cQuery := " SELECT D3.D3_COD, D3.D3_CUSTO1/D3.D3_QUANT AS UNIT, D3.D3_CUSTO1, B1.B1_DESC,"
cQuery += " D3.D3_QUANT, CTT.CTT_DESC01, D3.D3_CC, D3.D3_USUARIO, D3.D3_TM, D3.D3_EMISSAO"
cQuery += " FROM "+RetSqlName('SD3')+" D3, "+RetSqlName('CTT')+" CTT, "+RetSqlName('SB1')+" B1"
cQuery += " WHERE D3_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
cQuery += " AND CTT.CTT_CUSTO = D3.D3_CC"
cQuery += " AND B1.B1_COD = D3.D3_COD"
cQuery += " AND D3_EMISSAO BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"'"
cQuery += " AND D3_CC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
cQuery += " AND D3.D_E_L_E_T_ = ' '  AND CTT.D_E_L_E_T_ = ' '"  
cQuery += " ORDER BY D3.D3_COD"

TCQUERY cQuery NEW ALIAS 'TMP' 

TCSETFIELD("TMP","D3_EMISSAO","D")

            While TMP->(!EoF())
            	aAdd(_aGer,{TMP->D3_COD,TMP->UNIT, Iif(Val(TMP->D3_TM) > 500,TMP->D3_CUSTO1,0-D3_CUSTO1),TMP->B1_DESC,TMP->D3_QUANT,TMP->CTT_DESC01,TMP->D3_CC,TMP->D3_USUARIO,TMP->D3_EMISSAO})
                TMP->(DbSkip())
            EndDo
 
			Processa( {|| Gerando()   },"Gerando Arquivo txt")

DbCloseArea("TMP") 

Return

Static Function Gerando()// Gera o arquivo txt
            _nOutFile:= Fcreate("C:\Movim.txt",0)
			ProcRegua(Len(_aGer))
            For x := 1 to Len(_aGer)
            	Fwrite(_nOutFile,AllTrim(_aGer[x][1])+"	"+; //D3_CODIGO
            							  Transform(_aGer[x][2],"@e 9,999,999")+"	"+; //CUSTO UNITARIO
            							  Transform(_aGer[x][3],"@e 9,999,999")+"	"+; //D3_CUSTO1
            							  _aGer[x][4]+"	"+; //B1_DESC
            							  Transform(_aGer[x][5],"@e 999999")+"	"+; //D3_QUANT
            							  _aGer[x][6]+"	"+; //CTT_DESC
            							  _aGer[x][7]+"	"+; //D3_CC
            							  _aGer[x][8]+"	"+; //D3_USUARIO	
            							  DtoC(_aGer[x][9])+CHR(13)+CHR(10),200) //D3_EMISSAO
            	IncProc("Criando C:\Movim.txt")
            Next x 
            Fclose(_nOutFile)
			MsgAlert("Arquivo gerado em C:\Movim.txt") 
            _aGer:= {}
Return