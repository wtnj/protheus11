#include "rwmake.ch"        

User Function SB6NEW()      

SetPrvt("CQUERY,")

rptStatus({||Gerando()},"Limpando Empenho SB6...")
Return

Static Function Gerando()
cQuery := "UPDATE SB6NH0"
cQuery := cQuery + " SET B6_QULIB = 0.00"
cQuery := cQuery + " WHERE B6_SALDO <> 0.00"
TCSQLExec(cQuery)
MSGINFO("OK! ROTINA BEM SUCEDIDA!")
Return
