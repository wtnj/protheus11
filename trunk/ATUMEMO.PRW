#include "tbiconn.ch"
#include "topconn.ch"
#include "protheus.ch"
#include "fileio.ch"      

USER FUNCTION ATUMEMO()  
/*cCodEmp := 'FN'
cCodFil := '01'
cModulo := 'EST'
aParamVar := {}
cRet := 'false'

prepare environment empresa cCodEmp filial cCodFil modulo cModulo
*/
DbSelectArea("STJ")
STJ->(DBSETORDER(1))

IF STJ->(DBSEEK(xFilial("STJ")+'196900')) 	  
      RECLOCK("STJ",.F.) 
	      STJ->TJ_OBSERVA := "PREDITIVA TERMOGRAFIA ABRIL"
      MSUNLOCK("STJ")    
      alert("196900 ok !")      
ENDIF 

IF STJ->(DBSEEK(xFilial("STJ")+'196916'))                                   
      RECLOCK("STJ",.F.) 
	      STJ->TJ_OBSERVA := "PREDITIVA TERMOGRAFIA ABRIL"
      MSUNLOCK("STJ")           
      alert("196916 ok !")      
ENDIF 
     
RETURN