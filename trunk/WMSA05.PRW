/**********************************************************************************************************************************/
/** WMS                                                                                                                          **/
/** Rotina para baixa de pré-requisições                                                                                         **/
/** RSAC Soluções Ltda.                                                                                                          **/
/** WHB Usinagem                                                                                                                 **/
/**********************************************************************************************************************************/
/** Data       | Responsável                    | Descrição                                                                      **/
/**********************************************************************************************************************************/
/** 02/07/2011 | Rogério Souza Pereira          | Criação da rotina/procedimento.                                                **/
/**********************************************************************************************************************************/
#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/******************************************************************************************/
/** user function WWMSA05(cNumReq, cOpc, cNomeUsr, cIdCol, cCodEmp, cCodFil)             **/
/** Executa o encerramento dos itens pendentes de uma pre-requisicao                     **/
/******************************************************************************************/
user function WWMSA05(cNumReq, cOpc, cNomeUsr, cIdCol, cCodEmp, cCodFil)
  
  // variáveis auxiliares
  local lErro := .F.
  local cMsgErro := ""
  local cRet := ""
  local aPre := {}
  local aSd3 := {}
  local cMsErro := ""
  local nOpcAuto := 0 
  local cTm := ""
  private l185Auto := .T.

  /* teste 
  cNumReq := "278915"
  cOpc := "1"
  cNomeUsr := "RSAC"
  cIdCol := "8"
  cCodEmp := "FN"
  cCodFil := "01"
  */


  // prepara o ambiente
  prepare environment empresa cCodEmp filial cCodFil modulo "EST"
  
  // inicializa as variáveis
  cTm := GetNewPar("MV_TMBXPRE", "501")                 
  nOpcAuto := Val(cOpc)

  // recupera as requisições marcadas para baixa
  QryScp(cNumReq)
  if QSCP->(Eof())
                
    // nao foi localizada a pre-requisicao
    lErro := .T.                         
    cMsgErro := "Nao foram localizadas itens pendentes para encerramento!"
  
  else
  
	  // inicia a transação
	  begin transaction
	
		  // faz o loop sobre as pre requisições marcadas
		  nTotPre := 0
		  while !QSCP->(Eof())
		    
		    // posiciona a pré requisição
		    SCQ->(DbGoTo(QSCP->CQ_RECNO))
		    SCP->(DbGoTo(QSCP->CP_RECNO))
		    
		    // posiciona o produto
		    SB1->(DbSetOrder(1))
		    if !SB1->(DbSeek(XFilial("SB1") + SCQ->CQ_PRODUTO))
		      lErro := .T.
		      cMsgErro := "O produto da pre-requisicao nao foi localizado!"
		      Exit
		    endIf
		       
		    // monta o array de rotina automatica
		    cA105Num := SCQ->CQ_NUM
			              
			  aPre := {}  
		    AAdd(aPre, {"CP_NUM", SCQ->CQ_NUM, nil})
		    AAdd(aPre, {"CP_ITEM", SCQ->CQ_ITEM, nil})
		    AAdd(aPre, {"CP_PRODUTO", SCQ->CQ_PRODUTO, nil})
		    AAdd(aPre, {"CP_UM", SCQ->CQ_UM, nil})
		    AAdd(aPre, {"CP_QUANT", SCP->CP_QUANT, nil})
		    AAdd(aPre, {"CP_SEGUM", SB1->B1_SEGUM, nil})
		    AAdd(aPre, {"CP_QTSEGUM", ConvUm(SB1->B1_COD, SCP->CP_QUANT, 0, 2), nil})
		    AAdd(aPre, {"CP_LOCAL", SB1->B1_LOCPAD, nil})
		    AAdd(aPre, {"CP_QUJE", SCP->CP_QUANT, nil})
			
		    // monta o array com os dados da SD3
		    if nOpcAuto == 1
			    aSd3 := {}
			    AAdd(aSd3, {"D3_TM", cTm, Nil})
			    AAdd(aSd3, {"D3_LOTECTL", Iif(SB1->B1_RASTRO $ "SL", SB8->B8_LOTECTL, ""), Nil})
			    AAdd(aSd3, {"D3_NUMLOTE", Iif(SB1->B1_RASTRO $ "SL", SB8->B8_NUMLOTE, ""), Nil})
			    AAdd(aSd3, {"D3_DTVALID", Iif(SB1->B1_RASTRO $ "SL", SB8->B8_DTVALID, ""), Nil})
			    AAdd(aSd3, {"D3_LOCALIZ", QSCP->ZW4_LOCALI, Nil})
			  endIf
			    
		    // faz a baixa da pré requisição
		    lMsErroAuto := .F.
		 		MsExecAuto({|x, y, z| Mata185(x, y, z)}, aPre, aSd3, nOpcAuto)
			    
		    // reposiciona o SCP processado
		    SCQ->(DbGoTo(QSCP->CQ_RECNO))
		    SCP->(DbGoTo(QSCP->CP_RECNO))
			    
	      // grava o usuario, data, hora e coletor que fez o encerramento da Pre Requisicao
	      RecLock("SCQ", .F.)
 	      SCQ->CQ_W_USBAI := cNomeUsr
	      SCQ->CQ_W_HRBAI := Time()
	      SCQ->CQ_W_DTBAI := Date()
	      SCQ->CQ_W_ICBAI := cIdCol
	      MsUnlock()
		      
		    // verifica o retorno
		    if lMsErroAuto
		      
		      // recupera o error.log
		      cMsgErro := U_WmsErroLog()
		        
		      // valida se o erro tem a ver com o DOCSEQ
		      if !("A240DOC" $ cMsgErro) 
		        cMsgErro := "Erro ao executar a baixa da pre-requisicao: " + AllTrim(SCQ->CQ_NUM) + "/" + SCQ->CQ_ITEM + "!" + cMsErro
		        lErro := .T.
		        Exit
		      endIf
		    
		    endIf
			
	    	// proximo registro
	    	QSCP->(DbSkip())
		    
	  	endDo
		       
		  // tratamento do erro de transação 
 			if ( lErro )
   			DisarmTransactions()
   	  endIf
		
	  end transaction
	  
  endIf
  
 	// fecha a query
 	QSCP->(DbCloseArea())
		
	// monta o retorno da função	
 	if ( lErro )
 		cRet := "<ParamOk>NO</ParamOk>
 		cRet += "<MsgRet>" + cMsgErro + "</MsgRet>
 		cRet += "<DadosRet></DadosRet>
 	else
 		cRet := "<ParamOk>OK</ParamOk>
 		cRet += "<MsgRet>Procedimento concluido com sucesso!</MsgRet>
 		cRet += "<DadosRet></DadosRet>
 	endIf
    
  //MsgInfo(cRet)

return cRet


/**********************************************************************************************************************************/
/** static function QryScp(cNumReq)                                                                                              **/
/** Recupera as pré-requisições marcadas para baixa                                                                              **/
/**********************************************************************************************************************************/
static function QryScp(cNumReq)

  // variáveis auxiliares
  local cQr := ""
  local aArea := GetArea()


  // monta a query para recuperar as pré-requisições marcadas pelo coletor
  cQr := " select SCQ.R_E_C_N_O_ CQ_RECNO,
  cQr += "        SCP.R_E_C_N_O_ CP_RECNO
  cQr += "   from " + RetSqlName("SCQ") + " SCQ
  
  cQr += "   left join " + RetSqlName("SCP") + " SCP
  cQr += "     on SCP.D_E_L_E_T_ = ' '
  cQr += "    and SCP.CP_FILIAL = '" + XFilial("SCP") + "'
  cQr += "    and SCP.CP_NUM = SCQ.CQ_NUM
  cQr += "    and SCP.CP_ITEM = SCQ.CQ_ITEM
   
  cQr += "  where SCQ.D_E_L_E_T_ = ' '
  cQr += "    and SCQ.CQ_FILIAL = '" + XFilial("SCQ") + "'
  cQr += "    and SCQ.CQ_QTDISP > 0
  cQr += "    and SCQ.CQ_NUMREQ = ''
  cQr += "    and SCQ.CQ_NUM = '" + cNumReq + "'

  cQr += "  order by SCQ.R_E_C_N_O_,
  cQr += "        SCP.R_E_C_N_O_
  
  TcQuery cQr new alias "QSCP"
  RestArea(aArea)

return nil