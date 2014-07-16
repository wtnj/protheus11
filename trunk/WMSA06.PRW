/**********************************************************************************************************************************/
/** WMS                                                                                                                          **/
/** Rotina para transferencia                                                                                         					 **/
/** RSAC Soluções Ltda.                                                                                                          **/
/** WHB Usinagem                                                                                                                 **/
/********************************rsac**************************************************************************************************/
/** Data       | Responsável                    | Descrição                                                                      **/
/**********************************************************************************************************************************/
/** 06/10/2011 | Harold          			    | Criação da rotina/procedimento.                                                			 **/
/**********************************************************************************************************************************/
#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/******************************************************************************************/
/** user function WMSA06(aItemTraf, cSolic, cCodEmp, cCodFil)								 											**/
/** Executa a transferencia de estoque												     											  				**/
/** Obs: a Variável aItemTraf é um array, em formato string composta dos seguintes campos 				**/
/** separados por um caracter especial para cada campo e registro						 											**/
/** SEPARADOR DE CAMPO = '||'															 																				**/
/** SEPARADOR DE REGISTROS = '/\'														 																			**/
/** aItem = 1-cDocto,2-dEmis,3-cArmOri,4-cEndOri,5-cArmDes,6-cEndDest,7-cCodProd,8-cLote,9-nQuant,**/
/** Ex aItem = 																			 **/
/**  u_WMSA06('W00000005||20131022||33||A03031||33||A03032||VWB01.5.0900.01||13J17||1||/\','RSAC','FN','01') **/  
/** http://192.168.1.81:8089/u_wcfga01.apl?FuncName=u_WMSA06&aItemTraf='W00000009||20131023||33||A03031||33||A03032||VWB01.5.0900.01||13J17||1||/\'&cSolic='RSAC'&CodEmp='FN'&CodFil='01' **/
/******************************************************************************************/
user function WMSA06(aItemTraf, cSolic, cCodEmp, cCodFil)

  local cRet := ""
  local aRegistros := {}         
  local aCampos := {}         
  local vARRAY_REGISTRO := '' 
  local DEL_REG := '/\'
  local DEL_CAM := '||'  
  local nR := 0
  local cObs := 'TRANSF COLETOR'
  local cEstorna := ''
  local lError := .F.  
  // variaveis auxiliares
 local aAuto := {}
  local aItem := {}    
  local nOpcAuto := 3
  local cDocto := ''
  local dEmis := Date()
  local cArmOri := ''
  local cEndOri := ''
  local cArmDes := ''
  local cEndDest := ''
  local cCodProd := ''
  local cLote := ''
  local nQuant := 0
  local cObs := ''
  local cEstorna := ''    
  local cQr := ''         
  local aArea := GetArea()
  
  private lMsErroAuto := .F.
  private lAutoma291 := .T.  
  private MsgRetWMS := ''

//	aItemTraf := 'W00000027||20131101||33||A16001||34||01||IVE18.5.0900.03||13J14||160||/\W00000026||20131101||33||A16002||34||01||IVE18.5.0900.16||13J14||400||/\'/
//	cSolic :='LEANDROJS'
//	cCodEmp :='FN'
//	cCodFil :='01'   
	
  // prepara o ambiente
  prepare environment empresa cCodEmp filial cCodFil modulo "PCP"
    
  //passa o codigo do usuario
	cUserName := cSolic;
  

  //separa os registros em um array convencional	
  aRegistros := STRTOKARR(aItemTraf, DEL_REG)      
  aCampos := STRTOKARR(aRegistros[1], DEL_CAM)  
  cDocto := aCampos[1]
  dEmis := stod(aCampos[2])

	conout('aItemTraf='+aItemTraf)
	conout('cSolic='+cSolic)
	conout('cCodEmp='+cCodEmp)
	conout('cCodFil='+cCodFil)

	//verifica se o documento ja existe e envia a mensagem para reiniciar o processo

			cQr := ""
		  cQr += " SELECT COUNT(*) QTD
		  cQr += " FROM " + RetSqlName("SD3")
		  cQr += " WHERE D3_DOC = '" + cDocto + "'
		  cQr += "   AND D_E_L_E_T_ = ''  	
		  cQr += "   AND D3_FILIAL = '" + XFilial("SD3") + "'		  	
		  	
		  TcQuery cQr new alias "QWMS2"
		  RestArea(aArea)
		          
		  conout('QWMS2->QTD=')  
		  conout(QWMS2->QTD)
		    
		  //VERIFICA SE FOI ENCONTRADO ALGUM REGISTRO
		  IF (QWMS2->QTD > 0)                    
		  		lError := .T.
		  		if (MsgRetWMS == '')                                                                                                           
		  			MsgRetWMS := 'Erro código do documento já utilizado por outro coletor, reinicie o processo ou inclua um documento valido! (REFDOCINV)'
		  			conout(MsgRetWMS)    

			
					 	  cRet := "<ParamOk>NO</ParamOk>
					 	  cRet += "<MsgRet>" + MsgRetWMS + "</MsgRet>
					 	  cRet += "<DadosRet></DadosRet>  
							
						return cRet							  			
		  		endif
		  		
		  ENDIF


  
  Begin Transaction //Cabecalho a Incluir 

 	aAuto := {}
  Conout('cDocto='+cDocto)
	aadd(aAuto,{cDocto, dEmis})//Cabecalho 
   
  //percorre todos os registros
  for nR := 1 to len(aRegistros)                    
  
		  	//separa os campos em array para que possa ser utilizado  
		  	//aCampos = 1-cDocto,2-dEmis,3-cArmOri,4-cEndOri,5-cArmDes,6-cEndDest,7-cCodProd,8-cLote,9-nQuant
	    aCampos := STRTOKARR(aRegistros[nR], DEL_CAM)  
			cArmOri := aCampos[3]  //cArmOri
			cEndOri := aCampos[4]  //cEndOri
			cArmDes := aCampos[5]  //cArmDes
			cEndDest := aCampos[6] //cEndDest
			cCodProd := aCampos[7] //cCodProd
			cLote := aCampos[8]    //cLote 
			nQuant := VAL(aCampos[9]) //nQuant                    
		    
			// posiciona o produto
			DbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(XFilial("SB1")+Padr(cCodProd, 15)))
			
			
			//VERIFICA SE O PRODUTO USA LOTE
			IF (SB1->B1_RASTRO = 'L')
			
				DbSelectArea("SB8")
				SB8->(dbSetOrder(3))
				SB8->(dbSeek(XFilial("SB8") + Padr(cCodProd, 15) +cArmOri+ Padr(cLote, 10)  ))
			
				aItem := {}   
			    //Itens a Incluir 
				aadd(aItem,SB1->B1_COD) //D3_COD 
				aadd(aItem,SB1->B1_DESC) //D3_DESCRI 
				aadd(aItem,SB1->B1_UM) //D3_UM 
				aadd(aItem,Padr(cArmOri,2)) //D3_LOCAL 
				aadd(aItem,Padr(cEndOri,15)) //D3_LOCALIZ 
				aadd(aItem,SB1->B1_COD) //D3_COD 
				aadd(aItem,SB1->B1_DESC) //D3_DESCRI 
				aadd(aItem,SB1->B1_UM) //D3_UM 
				aadd(aItem,Padr(cArmDes,2)) //D3_LOCAL 
				aadd(aItem,Padr(cEndDest,15)) //D3_LOCALIZ 
				aadd(aItem,"") //D3_NUMSERI 
				aadd(aItem,Padr(cLote,10)) //D3_LOTECTL 
				aadd(aItem,"") //D3_NUMLOTE 
				aadd(aItem, SB8->B8_DTVALID) //D3_DTVALID 
				aadd(aItem,0) //D3_POTENCI 
				aadd(aItem,nQuant) //D3_QUANT 
				aadd(aItem,0) //D3_QTSEGUM 
				aadd(aItem,"") //D3_ESTORNO 
				aadd(aItem,"") //D3_NUMSEQ 
				aadd(aItem,Padr(cLote,10)) //D3_LOTECTL 
				aadd(aItem,SB8->B8_DTVALID) //D3_DTVALID 
				aadd(aItem,"") //D3_ITEMGRD 
			
				aadd(aItem,CriaVar("D3_CARDEF",.F.)	) 
				aadd(aItem,CriaVar("D3_DEFEITO",.F.)	) 
				aadd(aItem,CriaVar("D3_OPERACA",.F.)	) 
				aadd(aItem,CriaVar("D3_FORNECE",.F.)	) 
				aadd(aItem,CriaVar("D3_LOJA",.F.)	) 
				aadd(aItem,CriaVar("D3_LOCORIG",.F.)	) 
				aadd(aItem,SB1->B1_CC) 
				aadd(aItem,CriaVar("D3_TURNO",.F.)	) 
				aadd(aItem,CriaVar("D3_MAQUINA",.F.)	) 
				aadd(aItem,CriaVar("D3_LINHA",.F.)	) 
				aadd(aItem,CriaVar("D3_CODPA",.F.)	) 
				aadd(aItem,CriaVar("D3_DTREF",.F.)	) 
				aadd(aItem,CriaVar("D3_CORRID",.F.)	) 
				aadd(aItem,CriaVar("D3_CORRIDA",.F.)	) 				
				aadd(aItem,CriaVar("D3_OP",.F.)	) 
				
				aadd(aAuto,aItem)            
		else //IF (SB1->B1_RASTRO = 'L')				
		
				aItem := {}   
			    //Itens a Incluir 
				aadd(aItem,SB1->B1_COD) //D3_COD 
				aadd(aItem,SB1->B1_DESC) //D3_DESCRI 
				aadd(aItem,SB1->B1_UM) //D3_UM 
				aadd(aItem,Padr(cArmOri,2)) //D3_LOCAL 
				aadd(aItem,Padr(cEndOri,15)) //D3_LOCALIZ 
				aadd(aItem,SB1->B1_COD) //D3_COD 
				aadd(aItem,SB1->B1_DESC) //D3_DESCRI 
				aadd(aItem,SB1->B1_UM) //D3_UM 
				aadd(aItem,Padr(cArmDes,2)) //D3_LOCAL 
				aadd(aItem,Padr(cEndDest,15)) //D3_LOCALIZ 
				aadd(aItem,"") //D3_NUMSERI 
				aadd(aItem,CriaVar("D3_LOTECTL",.F.)) //D3_LOTECTL 
				aadd(aItem,"") //D3_NUMLOTE 
				aadd(aItem, CriaVar("D3_DTVALID",.F.)) //D3_DTVALID 
				aadd(aItem,0) //D3_POTENCI 
				aadd(aItem,nQuant) //D3_QUANT 
				aadd(aItem,0) //D3_QTSEGUM 
				aadd(aItem,"") //D3_ESTORNO 
				aadd(aItem,"") //D3_NUMSEQ 
				aadd(aItem,CriaVar("D3_LOTECTL",.F.)) //D3_LOTECTL 
				aadd(aItem, CriaVar("D3_DTVALID",.F.)) //D3_DTVALID 
				aadd(aItem,"") //D3_ITEMGRD 
			
				aadd(aItem,CriaVar("D3_CARDEF",.F.)	) 
				aadd(aItem,CriaVar("D3_DEFEITO",.F.)	) 
				aadd(aItem,CriaVar("D3_OPERACA",.F.)	) 
				aadd(aItem,CriaVar("D3_FORNECE",.F.)	) 
				aadd(aItem,CriaVar("D3_LOJA",.F.)	) 
				aadd(aItem,CriaVar("D3_LOCORIG",.F.)	) 
				aadd(aItem,SB1->B1_CC) 
				aadd(aItem,CriaVar("D3_TURNO",.F.)	) 
				aadd(aItem,CriaVar("D3_MAQUINA",.F.)	) 
				aadd(aItem,CriaVar("D3_LINHA",.F.)	) 
				aadd(aItem,CriaVar("D3_CODPA",.F.)	) 
				aadd(aItem,CriaVar("D3_DTREF",.F.)	) 
				aadd(aItem,CriaVar("D3_CORRID",.F.)	) 
				aadd(aItem,CriaVar("D3_CORRIDA",.F.)	) 				
				aadd(aItem,CriaVar("D3_OP",.F.)	) 
				
				aadd(aAuto,aItem)            		
		
		endif	//IF (SB1->B1_RASTRO = 'L')				
	
  next nR  

 	// executa a rotina automatica
	Conout('MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto) ')
	lMsErroAuto := .F.    
	MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto) 

	                           
	if ( lMsErroAuto )
		cPath := '/'
		// recupera mensagem de erro
		if (MsgRetWMS == '')
			MsgRetWMS  := MostraErro( cPath )    
		endif
		
		Conout('lMsErroAuto =.T.')
		conout(MsgRetWMS)
	else
		Conout('lMsErroAuto =.F.')
		// procedimento ok
		if (MsgRetWMS == '')
			MsgRetWMS := "Transferencia executada com sucesso!"
		endif
	endIf	           

  if  (lMsErroAuto)
  		// erro na rotina automatica
  	    DisarmTransactions()
  	    lError := .T.
  endif
  
  //finaliza a transação
  End Transaction
                      

                        
  //faz uma verificação de segurança para checar se o registro foi realmente incluido na base
  //pois pode existir alguma rotina ou ponto de entrada que cancele o processo e nao retorna como erro
  if  (lMsErroAuto = .F.)
			cQr := ""
		  cQr += " SELECT COUNT(*) QTD
		  cQr += " FROM " + RetSqlName("SD3")
		  cQr += " WHERE D3_DOC = '" + cDocto + "'
		  cQr += "   AND D3_EMISSAO = '" + dtos(dEmis) + "'
		  cQr += "   AND D3_LOCALIZ = '" + cEndDest + "' 
		  cQr += "   AND D3_LOCAL = '"+ cArmDes +"'
		  cQr += "   AND D_E_L_E_T_ = ''  	
		  cQr += "   AND D3_FILIAL = '" + XFilial("SD3") + "'		  	
		  	
		  TcQuery cQr new alias "QWMS"
		  RestArea(aArea)
		          
		  conout('QWMS->QTD=')  
		  conout(QWMS->QTD)
		    
		  //VERIFICA SE FOI ENCONTRADO ALGUM REGISTRO
		  IF (QWMS->QTD = 0)                    
		  		lError := .T.
		  		if (MsgRetWMS == '')
		  			MsgRetWMS := 'Erro na transferencia de produto! Favor entrar em contato com o responsável pelo sertor de informatica! O registro nao foi encontrado na SD3 (WMSA06.prw)'
		  			conout(MsgRetWMS)
		  		endif
		  		
		  ENDIF
   ENDIF
  
 if (lError)             
 	  cRet := "<ParamOk>NO</ParamOk>
 	  cRet += "<MsgRet>" + MsgRetWMS + "</MsgRet>
 	  cRet += "<DadosRet></DadosRet>  
 else
 	  cRet := "<ParamOk>OK</ParamOk>
 	  cRet += "<MsgRet>" + MsgRetWMS + "</MsgRet>
 	  cRet += "<DadosRet></DadosRet>  
 endif
 	  
return cRet