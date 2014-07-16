/*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHCON008  บAutor  ณMarcos R Roquitski  บ Data ณ  15/01/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFaz a importa็ใo do arquivo de or็amento                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#include "rwmake.ch"        

User Function Nhcon008()      

SetPrvt("cArq")

cArq := Space(12)

@ 96,42 TO 323,505 DIALOG oDlg5 TITLE OemToAnsi("Importacao do Or็amento NH")
@ 40,020 Say OemToAnsi("Digite o Nome do arquivo de Or็amento no \Sigaadv :") Size 140,10 Object oTexto
@ 40,150 Get cArq Picture "@!" Size 60,10 Valid NaoVazio(cArq) Object oArq
@ 91,158 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
@ 20,030 SAY OemToAnsi("Este programa tem como objetivo Importar dados do Or็amento")
@ 40,65 SAY " "
ACTIVATE DIALOG oDlg5 CENTERED

Static Function Gerando()

Static Function OkProc()
Close(oDlg5)

cArq := "\Sigaadv\" + Alltrim(cArq)+".dbf" //"c:\Control.dbf"
If !File(cArq)
   Alert("Aten็ใo arquivo nao Encontrado :"+cArq)
   Return
Endif

USE &cArq alias TMP SHARED NEW
//DBSELECTAREA("TMP")

// Copia do Arquivo DBF para o arquivo de Importacao

DbSelectArea("SIA")
//DbsetOrder(1)
//IF AbreExcl("SIA")
 append from &cArq    //C\DADOSADV\CONTROL.DBF
//ENDIF
//AbreExcl( )
dbGoTop()
DbSelectArea("TMP")
DbCloseArea()

MsgBox("Importacao Realizada com Sucesso..................")

Return
