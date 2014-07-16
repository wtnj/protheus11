
/**********************************************************************************************************************************/
/** RSAC Soluções Ltda.                                                                                                          **/
/** WHB Usinagem                                                                                                                 **/
/**********************************************************************************************************************************/
/** Data       | Responsável                    | Descrição                                                                      **/
/**********************************************************************************************************************************/
/** 23/05/2011 | Rogério Souza Pereira          | Criação da rotina/procedimento.                                                **/
/**********************************************************************************************************************************/
#include "rwmake.ch"
#include "tbiconn.ch"
#include "topconn.ch"
#include "protheus.ch"
#include "fileio.ch"
#define FUNC_TAG "FuncName"

/**********************************************************************************************************************************/
/** user function WCFGA01()                                                                                                      **/
/**********************************************************************************************************************************/
/** Parâmetro  | Tipo | Tamanho | Descrição                                                                                      **/
/**********************************************************************************************************************************/
/** Nenhum parametro esperado neste procedimento                                                                                 **/
/**********************************************************************************************************************************/
user Function WCFGA01( __aCookies, __aPostParms, __nProcID, __aProcParms, __cHTTPPage )
            
	local cRet := ''
	
	local nI := 0

  local cFuncName := ""

  local aParamVar := {}
	   
	local cExecBloc := ""    
	
	private lWmsApl := .T.
	
	   
	if len(__aProcParms) = 0
 	  cRet := "<ParamOk>NO</ParamOk>
 	  cRet += "<MsgRet>Erro nos parametros de requisicao</MsgRet>
 	  cRet += "<DadosRet></DadosRet>
	else

	  for nI := 1 to len( __aProcParms )	
	         
	    if (nI == 1) .and. ( AllTrim(__aProcParms[nI, 1]) == FUNC_TAG )
	      cFuncName := __aProcParms[nI, 2]
	    else                

	      // adiciona o array de parametros
	      AAdd( aParamVar, { __aProcParms[nI, 1] ,; // nome do parametro
	                         __aProcParms[nI, 2]  ; // conteudo
	                       }                     ;
	          )              

	    endIf
	    
	  Next nI
    
    if empty(cFuncName)
   	  cRet := "<ParamOk>NO</ParamOk>
   	  cRet += "<MsgRet>Erro na funcao a executar</MsgRet>
   	  cRet += "<DadosRet></DadosRet>
	    return cRet
    endIf
    

    cExecBloc := cFuncName + "("
                           
    for nI := 1 to len(aParamVar)
      if nI == 1
        cExecBloc += aParamVar[nI][2]
      else
        cExecBloc += (", " + aParamVar[nI][2])
      endIf  
    next nI                  
    
    cExecBloc += ")"                  
      
    ConOut("*********************** CONEXAO MOBILE ***********************")
    ConOut(cExecBloc)
    
    // executa a função
    cRet := &(cExecBloc)
    ConOut("")
    ConOut(cRet)
    ConOut("************************* FINALIZADO *************************")

	Endif

return cRet