/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT710SHA        ³ Alexandre R. Bento    ³ Data ³ 02.08.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Zerar as entradas previstas no arquivo SHA                ³±±
±±³          ³ HA_TIPO = 2 Entradas previstas                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


#include "rwmake.ch"

user function MT710SHA()
        
  // variaveis auxiliares  não são utilizadas no processamento deste ponto de entrada        
  Local _nQtPer   := ParamIxb[05] // Quantidade de dias no periodo ex: dias = 30  Qtde de periodos em dias digitado para rodar o MRP   
  Local CLR  := chr(13)+chr(10)
  Local _cVar := ""
  local _cProduto := ParamIxb[01] // codigo do produto
  local _cPeriodo := ParamIxb[02] // periodo do produto ex: 001
  local _nQuant   := ParamIxb[03] // Saldo do produto
  local _cTipoReg := ParamIxb[04] // Registro ex: tipo = 1
  Local _nx 
  Local _cCampo                 

  // verifica o tipo do registro
  if SHA->HA_TIPO == "2"      	
   // entrada prevista, zera a quantidade
   
	    For _nx := 1 to _nQtPer //zera as entradas prevista até a qtde dos periodos digitados no MRP exemplo 30 dias
	
	       _cCampo :="SHA->HA_PER"+ Strzero(_nx,3) 
	       If &(_cCampo) > 0 //Só altera se o campo valor e entrada for maior de zero
	          RecLock("SHA", .F.)
	            &(_cCampo) := 0
	          MsUnlock("SHA")
	       Endif   
	    Next   
	
  Endif


return
 

