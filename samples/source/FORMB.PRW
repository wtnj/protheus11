/*
    Programa : FORMB.PRW
    Autor    : Heder M Oliveira    
    Data     : 24/06/99 20:21
    Revisao  : 24/06/99 20:21
    Uso      : Impressao de RPT para Apresentacao Luciano
*/

//o exe do relatorio deve estar junto com os dados

DIR_RPT:=IF(SX2->(DBSEEK("EE4")),ALLTRIM(SX2->X2_PATH),"\SIGAMAT\")+"FORMB"

if (oRun:=WinExec(DIR_RPT,1))==0
   MSGSTOP("Memória Insuficiente","Atenção")
ELSEIF (oRUN==2)
   MSGSTOP("Arquivo não Encontrado","Atenção")
ELSEIF (oRUN==3)
   MSGSTOP("Caminho não Encontrado","Atenção")
endif

__RETURN()
