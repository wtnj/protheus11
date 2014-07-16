/**********************************************************************************************************************************/
/** WMS                                                                                                                          **/
/** Rotina para transferencia                                                                                         			 **/
/** RSAC Soluções Ltda.                                                                                                          **/
/** WHB Usinagem                                                                                                                 **/
/********************************rsac**********************************************************************************************/
/** Data       | Responsável                    | Descrição                                                                      **/
/**********************************************************************************************************************************/
/** 06/10/2011 | Harold          			    | Criação da rotina/procedimento.                                                **/
/**********************************************************************************************************************************/
#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*********************************************************************************************************************************/
/** user function WMSA07(cCodEmp, cCodFil)								 				 										**/
/** rotina a ser usada no schedulle, para execucao das rotinas de apontamento e enderecamento de produtos acabados 				**/
/*********************************************************************************************************************************/
user function WMSA07(cCodEmp, cCodFil)   

  local cRet := "Rotina Executada"  
  local cQr := ""
  local aArea := GetArea()  
  // verificar se é rotina automatica  
  local lAuto := .F.     
  //default cCodEmp := '99'
  //default	cCodFil := '01' 
  
  private lMsErroAuto := .F.
  private MsgRetWMS := '' 
                        

  if (cCodEmp = nil)
  	cCodEmp := 'FN'
  	cCodFil := '01'  	
  endif 
  // prepara o ambiente
  //prepare environment empresa cCodEmp filial cCodFil modulo "PCP"  
  
  //Conecta ambiente
  If	Select('SX2') == 0
		RPCSetType( 3 )					
		conout(dtoc(date())+'|'+time()+'|'+"Preparando ambiente utilizando empresa " + cCodEmp + " filial " + cCodFil)
		RpcSetEnv(cCodEmp,cCodFil,,,,GetEnvServer(),{ "SM2" })
		lAuto := .T.
  EndIf
  
	//U_WMSEMAIL('haroldbarros@rsacsolucoes.com.br','WMS - Execucao Rotina WMSA07','Teste',cCodEmp,cCodFil)

	  //faz o select dos itens pendentes de apontamento e enderecamento
	  cQr := ""   
	  cQr += " SELECT	ZSC_DTREG DTREG,
	  cQr += " 			ZSC_HRREG HRREG,
	  cQr += " 			ZSC_NUMOP NUMPO,
	  cQr += " 			'APO' ORIGEM, 
	  cQr += " 			ZSC_QUANT QUANT,
	  cQr += " 			ZSC_UM	UM,
	  cQr += " 			'' ARMZ,
	  cQr += " 			ZSC_DTEMIS DTEMISS,
	  cQr += " 	   		'' ENDERECO,
	  cQr += " 			ZSC_USER USUARIO,   
	  cQr += " 			ZSC_ERROR ERROR,
	  cQr += " 			R_E_C_N_O_ 
	  cQr += " FROM " + RetSqlName("ZSC")
	  cQr += " WHERE D_E_L_E_T_  = ''
	  cQr += "   AND ZSC_STATUS = ''
	  cQr += "  and ZSC_FILIAL = '" + XFilial('ZSC') + "'  
	 		  
	  cQr += " UNION ALL   
	  
	  cQr += " SELECT 	ZSD_DTREG, 
	  cQr += " 			ZSD_HRREG, 
	  cQr += " 			ZSD_NUMOP,
	  cQr += " 			'END' ORIGEM, 
	  cQr += " 			ZSD_QUANT,
	  cQr += " 			ZSD_UM, 
	  cQr += " 			ZSD_LOCAL, 
	  cQr += " 			'' DTEMISS,
	  cQr += " 	   		ZSD_END,         
	  cQr += " 			ZSD_USER,   
	  cQr += " 			ZSD_ERROR,                                                                                            
	  cQr += " 			R_E_C_N_O_ 
	  cQr += " FROM " + RetSqlName("ZSD")
	  cQr += " WHERE D_E_L_E_T_ = ''
	  cQr += "  AND  ZSD_STATUS = ''
	  cQr += "  and  ZSD_FILIAL = '" + XFilial('ZSD') + "' 
	  //ordena pela data e hora para nao ocorrer de enderecar um produto antes do mesmo ser apontado
	  cQr += " ORDER BY 1,2,3,4,5		
	
	TcQuery cQr new alias "QAPO" 
	RestArea(aArea)
	
	QAPO->(DbGoTop())   
	
	//percorre todos os registros realizando o apontamento dos mesmos
	while ( !QAPO->(Eof()) )
		
		//verifica se é um registro de apontamento de producao 
		if (QAPO->ORIGEM == 'APO')
			//chama o processo de apontamento de producao, passando os dados inclusive o recno para que este seja atualizado no final do processo
      u_WsApoProd(QAPO->NUMPO, Str(QAPO->QUANT),QAPO->DTEMISS, cCodEmp, cCodFil,Str(QAPO->R_E_C_N_O_))  
		else
			//verifica se é um registro de enderecamento de produtos acabados
			u_WsEndProd( QAPO->NUMPO, QAPO->ENDERECO,  Str(QAPO->QUANT), cCodEmp, cCodFil,Str(QAPO->R_E_C_N_O_))
		
			//faz update do registro informando que o mesmo já foi apontado 
		endif
		  		
		//próximo registro
		QAPO->(DbSkip())
		    
	endDo
		    
	// fecha a query
	QAPO->(DbCloseArea())	  
 	  
return cRet 


//tela de vizualiaçao dos apontamentos de producao pendentes
//fonte: exemplo basico protheus
  USER FUNCTION BrwZSC()

	Local cFiltro :=  '' //'ZSC->ZSC_STATUS!="S"' //Expressao do Filtro   
	Local aIndex := {}
	
	LOCAL aCores  := {{ 'ZSC->ZSC_STATUS=="E"' , 'BR_VERMELHO'  },;    // REGISTRO COM ERRO 
	                  { 'ZSC->ZSC_STATUS==" "'  , 'BR_AMARELO' },;    //PENDENTE DE APONTAMENTO
	                  { 'ZSC->ZSC_STATUS=="S"' , 'BR_VERDE' }}    // APONTADO  
	                  
		
	LOCAL cAlias := 'ZSC'
	PRIVATE _cCpo  := "ZSC_FILIAL/ZSC_PRODUT/ZSC_DESC"
	PRIVATE cCadastro := 'Apontamento de Producao - Pendentes'
	PRIVATE aRotina     := { }
	
	
	AADD(aRotina, { 'Pesquisar' , 'AxPesqui', 0, 1 })
	AADD(aRotina, { 'Visualizar', 'AxVisual', 0, 2 })
	//AADD(aRotina, { 'Incluir'   , 'AxInclui', 0, 3 })
	//AADD(aRotina, { 'Alterar'   , 'AxAltera', 0, 4 })
	//AADD(aRotina, { 'Excluir'   , 'AxDeleta', 0, 5 }) 
	AADD(aRotina, { "Legenda"   , 'u_ZSCLeg()', 0, 6 })
	AADD(aRotina, { "Apontar"   , 'u_ZSCApo()', 0, 7 })
	
	dbSelectArea(cAlias)
	dbSetOrder(1)
	
	Private bFiltraBrw := { || FilBrowse( cAlias , @aIndex , @cFiltro ) } //Determina a Expressao do Filtro Private 
	Eval( bFiltraBrw ) //Efetiva o Filtro antes da Chamada a mBrowse 
	//mBrowse( 6 , 1 , 22 , 75 , cAlias )   
	//mBrowse(6, 1, 22, 75, cAlias)
	mBrowse(6, 1, 22, 75, cAlias,,,,,,aCores,,,,,,,,cFiltro)     
	EndFilBrw( cAlias , @aIndex ) //Finaliza o Filtro
	
RETURN NIL

        


//Funcao da Legenda
User FUNCTION ZSCLeg()

BrwLegenda(cCadastro,"Status", { {"BR_VERDE","Apontamento Realizado"},;   
								 {"BR_AMARELO","Aguardando Processamento"},;
								 {"BR_VERMELHO","Erro no Apontamento"}})

Return



// faz a verifica sao e realiza o apontamento 
User FUNCTION ZSCApo()
          
	local cRet := "" 
      
	//verifica se o status permite realizar o apontamento
	if (ZSC->ZSC_STATUS == "") .or. (ZSC->ZSC_STATUS == "E")
	      
	      cRet = u_WsApoProd(ZSC->ZSC_NUMOP, Str(ZSC->ZSC_QUANT),dtos(ZSC->ZSC_DTEMIS), SM0->M0_CODIGO, ZSC->ZSC_FILIAL,Str(RECNO()));   
		  
		  if empty(cRet)
		  	MsgAlert('Não foi possivel obter o retorno do apontamento, atualiza o registro para ver a mensagem de erro!')
		  else
		  	MsgAlert(cRet)
		  endif
	else
	 	MsgAlert('Apontamento já realizado!')
 	endif
	
return nil     