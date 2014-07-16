#include "rwmake.ch"

User Function TXTDBF()
Local cArq := ""


cArq    := cGetFile()

ft_fuse(cArq)



While ! ft_feof()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Neste momento, ja temos uma linha lida. Gravamos os valores ³
    //³ obtidos retirando-os da linha lida.                         ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     cBuff := ft_freadln()
     alert(cBuff)
     ft_fskip()
EndDo

ft_fuse()

Return
