#include "rwmake.ch"
#include "tbiconn.ch"
#include "topconn.ch"
#include "protheus.ch"
#include "fileio.ch"      

user Function TESTEWEB( __aCookies, __aPostParms, __nProcID, __aProcParms, __cHTTPPage )

cCodEmp := 'FN'
cCodFil := '01'
cModulo := 'EST'

aParamVar := {}

cRet := 'false'

  	// prepara o ambiente
	prepare environment empresa cCodEmp filial cCodFil modulo cModulo tables "SRA"

    // adiciona o array de parametros
    AAdd( aParamVar, { __aProcParms[1, 1] ,; // nome do parametro
                       __aProcParms[1, 2]  ; // conteudo
                     }                     ;
        )              
    
	If PUTMV('MV_DIASMO',aParamVar[1,2])
		cRet := 'true'
	Endif
  
Return cRet