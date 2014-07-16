#include "rwmake.ch"
#include "tbiconn.ch"
#include "topconn.ch"
#include "protheus.ch"
#include "fileio.ch"      

user Function NHCFG016( __aCookies, __aPostParms, __nProcID, __aProcParms, __cHTTPPage )

cCodEmp := __aProcParms[4, 2] //'FN'
cCodFil := __aProcParms[5, 2] //'01'

cModulo := 'EST'
cRet := 'false'

	prepare environment empresa cCodEmp filial cCodFil modulo cModulo
      
	//__aProcParams := {{'mv','MV_CQ'},{'putget','get'},{'0','0'}}

	// __aProcParams[1,1] //-- nome do parametro 1 
	// __aProcParams[1,2] //-- conteudo do parametro 1 (nome do parametro)
	// __aProcParams[2,1] //-- nome do parametro 2
	// __aProcParams[2,2] //-- conteudo do parametro 2 (put ou get)
	// __aProcParams[3,1] //-- nome do parametro 3
	// __aProcParams[3,2] //-- conteudo do parametro 3 (valor do parametro)

	If __aProcParams[2,2]=='get'
		cRet := GetMv(__aProcParms[1, 2])
		
		If valType(cRet)!='C'
			If valtype(cRet)=='D'
				cRet := DtoS(cRet)
			ElseIf valType(cRet)=='L'
				cRet := Iif(cRet,'T','F')
			ElseIf valType(cRet)=='N'
				cRet := AllTrim(str(cRet))
			Else
				cRet := 'tipo desconhecido'
			Endif
		Endif
					
	ElseIf __aProcParams[2,2]=='put'
		If PUTMV(__aProcParms[1, 2],__aProcParms[3, 2])
			cRet := 'true'
		Endif
	Endif
		
Return cRet