/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHCFG001 ³ Autor³Alexandre R. Bento      ³ Data ³ 17/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para verificar os grupos a que o usuario pertence   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ VERSAO 6.09                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User function NHCFG001(cParam)

Public _aGrupo   := {}
Public _cApelido := ""
Public _cNome    := ""
Public _cDepto   := ""
Public _cCargo   := ""
Public _cEmail   := ""
Public _cRamal   := ""
Public _cRetorno := ""

_aGrupo := pswret()  // retorna vetor com dados do usuario

_cApelido := _agrupo[1,2 ] // Apelido
_cNome    := _agrupo[1,4 ] // Nome completo
_cDepto   := _agrupo[1,12] // Depto
_cCargo   := _agrupo[1,13] // Cargo
_cEmail   := _agrupo[1,14] // e-mail
_cRamal   := _agrupo[1,20] //  Ramal

If cParam == "01" // Apelido
   _cRetorno := _cApelido
Elseif cParam == "02" // Nome Completo
   _cRetorno := _cNome
Elseif cParam == "03" // Depto
   _cRetorno := _cDepto
Elseif cParam == "04" // Cargo
   _cRetorno := _cCargo
Elseif cParam == "05" // e-mail
   _cRetorno := _cEmail
Elseif cParam == "06" // Ramal
   _cRetorno := "3341-"+_cRamal
Else
   _cRetorno := " "

Endif   

return(_cRetorno)