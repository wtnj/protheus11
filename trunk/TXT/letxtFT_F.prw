#include "rwmake.ch"

User Function TXTDBF()
Local cArq := ""


cArq    := cGetFile()

ft_fuse(cArq)



While ! ft_feof()

    //�������������������������������������������������������������Ŀ
    //� Neste momento, ja temos uma linha lida. Gravamos os valores �
    //� obtidos retirando-os da linha lida.                         �
    //���������������������������������������������������������������
     cBuff := ft_freadln()
     alert(cBuff)
     ft_fskip()
EndDo

ft_fuse()

Return
