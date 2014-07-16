#Include "rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT710SHA        ³ Alexandre R. Bento    ³ Data ³ 02.08.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Zerar as entradas previstas no arquivo SHA                ³±±
±±³          ³ HA_TIPO = 2 Entradas previstas                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr"o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
user function MT710SHA
	
	// grava area
	local aArea   := GetArea()
	// tipo do registro (2 = Entradas)
	local _cTpReg := ParamIxb[04]
	// quantidade de periodos (Ex.: 30 dias)
  local _nQtPer := ParamIxb[05]
  // contador
  local _nX     := 0
  // nome do campo
  local _cCampo := ""
	
	
  // tipo entrada
  if SHA->HA_TIPO == "2"
		// loop sobre as entradas previstas
		For _nX := 1 to _nQtPer
			
			// nome do campo
      _cCampo := "SHA->HA_PER"+ Strzero(_nX,3) 
      
      // altera se quantidade da entrada for maior de zero
      if &(_cCampo) > 0
      	// trava o registro
      	RecLock("SHA", .F.)
      	// zera a quantidade
        &(_cCampo) := 0
        // libera o registro
        SHA->(MsUnlock())
        
			endIf
			
		next _nX
		
  endIf
	
	// restaura area
	RestArea(aArea)
	
Return
