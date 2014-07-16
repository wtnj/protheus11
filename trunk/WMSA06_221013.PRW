/**********************************************************************************************************************************/
/** WMS                                                                                                                          **/
/** Rotina para transferencia                                                                                         **/
/** RSAC Soluções Ltda.                                                                                                          **/
/** WHB Usinagem                                                                                                                 **/
/**********************************************************************************************************************************/
/** Data       | Responsável                    | Descrição                                                                      **/
/**********************************************************************************************************************************/
/** 06/10/2011 | Harold          			    | Criação da rotina/procedimento.                                                **/
/**********************************************************************************************************************************/
#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/******************************************************************************************/
/** user function WMSA06(aItemTraf, cSolic, cCodEmp, cCodFil)								 **/
/** Executa a transferencia de estoque												     **/
/** Obs: a Variável aItemTraf é um array, em formato string composta dos seguintes campos   **/
/** separados por um caracter especial para cada campo e registro						 **/
/** SEPARADOR DE CAMPO = '||'															 **/
/** SEPARADOR DE REGISTROS = '/\'														 **/
/** aItem = 1-cDocto,2-dEmis,3-cArmOri,4-cEndOri,5-cArmDes,6-cEndDest,7-cCodProd,8-cLote,9-nQuant,**/
/** Ex aItem = 																			 **/
/**  u_WMSA06('000000099||20131009||01||E003||01||E001||PA002||LOTFOR002||10||/\','HAROLD','99','01') **/  

/******************************************************************************************/
user function WMSA06(aItemTraf, cSolic, cCodEmp, cCodFil)

  local cRet := ""
  local aRegistros := {}         
  local aCampos := {}         
  local vARRAY_REGISTRO := '' 
  local DEL_REG := '/\'
  local DEL_CAM := '||'  
  local nR := 0
  local MsgRet := ''
  local cObs := 'TRANSF COLETOR'
  local cEstorna := ''
  local lError := .F.  
  local cRegErro := ''
  local cMsgRet := ''

  // prepara o ambiente
  prepare environment empresa cCodEmp filial cCodFil modulo "PCP"


  //separa os registros em um array convencional	
  aRegistros := STRTOKARR(aItemTraf, DEL_REG) 
  
  Begin Transaction //Cabecalho a Incluir 

   
  //percorre todos os registros
  for nR := 1 to len(aRegistros)                    
  
  	//separa os campos em array para que possa ser utilizado  
  	//aItem = cCodProd, cArmOri, cArmzDest, nQuant, dEmis, cEndDest, cDocto, cArmDes,  cLote, 
    aCampos := STRTOKARR(aRegistros[nR], DEL_CAM)  

	 
          //IRASTransf(cDocto    ,dEmis         ,cArmOri   ,cEndOri   ,cArmDes   ,cEndDest  ,cCodProd  ,cLote     , nQuant         , MsgRet  ,cObs,cSolic,cEstorna ) 
      if !IRASTransf(aCampos[1],stod(aCampos[2]),aCampos[3],aCampos[4],aCampos[5],aCampos[6],aCampos[7],aCampos[8], VAL(aCampos[9]), @cMsgRet,cObs,cSolic,cEstorna )                     
	      //monta a mensagem de erro
      		cRegErro :=  cMsgRet;
      		
	      //seta a variavel ionformando que houve um erro
	      lError := .T.
	      Exit // sai do loop = break
      endIf  	
	
  next nR  


  if  (lError)
  		// erro na rotina automatica
  	    DisarmTransactions()
  endif

  
  
  End Transaction


  
 if (lError)             
 	  cRet := "<ParamOk>NO</ParamOk>
 	  cRet += "<MsgRet>" + cRegErro + "</MsgRet>
 	  cRet += "<DadosRet></DadosRet>  
 else
 	  cRet := "<ParamOk>OK</ParamOk>
 	  cRet += "<MsgRet>Transferencia realizada com sucesso!</MsgRet>
 	  cRet += "<DadosRet></DadosRet>  
 endif
 	  
return cRet



/**********************************************************************************************************************************/
/** static function IRASTransf(cDocto,dEmis,cArmOri,cEndOri,cArmDes,cEndDest,cCodProd,cLote, nQuant, MsgRet, cObs, cSolic , cEstorna )**/
/** grava a transferência de estoque                                                                                             **/
/**********************************************************************************************************************************/
static function IRASTransf(cDocto,dEmis,cArmOri,cEndOri,cArmDes,cEndDest,cCodProd,cLote, nQuant, MsgRet, cObs, cSolic , cEstorna )

  // variaveis auxiliares
  local lRet := .F.
  local aAuto := {}
  local aItem := {}    
  local nOpcAuto := 3
  Local cNumDoc := ''
  private lMsErroAuto := .F.
  private lAutoma291 := .T.  

           
	// posiciona o produto
	DbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(XFilial("SB1")+Padr(cCodProd, 15)))
	
	
	DbSelectArea("SB8")
	SB8->(dbSetOrder(3))
	SB8->(dbSeek(XFilial("SB8") + Padr(cCodProd, 15) +cArmOri+ Padr(cLote, 10)  ))


	                    
	aAuto := {}
	aItem := {}   

	aadd(aAuto,{cDocto, dEmis})//Cabecalho 
		
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
	//aadd(aItem,"") //D3_SERVIC
	aadd(aItem,"") //D3_ITEMGRD 
	aadd(aAuto,aItem) 


	//Variaveis para atualizar ponto de entrada MA261D3
	Private cObs1 := cObs
	Private cSolic1 := cSolic    
	Private cCodProd1 := cCodProd
  
  
 	// executa a rotina automatica
	lMsErroAuto := .F.
	MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto) 

	                           
	if ( lMsErroAuto )
		cPath := '/'
		// recupera mensagem de erro
		cMsg  := MostraErro( cPath )    
		
		conout(cMsg)
		
		MsgRet := cMsg //"Erro transferencia produto:" +alltrim(cCodProd)+" Armz Origem: "+ cArmOri + " Destino-> " + cArmDes +chr(13)+chr(10)+alltrim(cMsg)
	else
		// procedimento ok
		MsgRet := "Transferencia executada com sucesso!"
		lRet := .T.
	endIf	           
	

return lRet



 
User Function MyMata261()

Local cProd := "PA001"
Local cUM := ""
Local cLocal := ""
Local cDoc := ""
Local cLote := "LOTFOR001"
Local dDataVl := stod("20131108")
Local nQuant := 25
Local lOk := .T.
Local aItem := {}
Local nOpcAuto := 3 // Indica qual tipo de ação será tomada (Inclusão/Exclusão)

PRIVATE lMsHelpAuto := .T.
PRIVATE lMsErroAuto := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Abertura do ambiente |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//PREPARE ENVIRONMENT EMPRESA "YY" FILIAL "01" MODULO "EST" 
// prepara o ambiente
//prepare environment empresa "99" filial "01" modulo "PCP"

DbSelectArea("SB1")
DbSetOrder(1)
If !SB1->(MsSeek(xFilial("SB1")+cProd)) 
lOk := .F. 
ConOut(OemToAnsi("Cadastrar produto: " + cProd))
Else 
cProd := B1_COD 
cDescri := B1_DESC 
cUM := B1_UM 
cLocal := B1_LOCPAD
EndIf 

lOk := .T. 

If lOk 
cDoc := GetSxENum("SD3","D3_DOC",1) 
ConOut(Repl("-",80)) 
ConOut(PadC("Teste de Transf. Mod2",80)) 
ConOut("Inicio: "+Time()) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ 
//| Teste de Inclusao | 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

Begin Transaction //Cabecalho a Incluir 
aAuto := {} 
aadd(aAuto,{"CEROULA", stod("20131012")})//Cabecalho 
//Itens a Incluir 
aadd(aItem,"PA001          ") //D3_COD 
aadd(aItem,"PROD ACABADO 01               ") //D3_DESCRI 
aadd(aItem,"UN") //D3_UM 
aadd(aItem,"01") //D3_LOCAL 
aadd(aItem,"E004           ") //D3_LOCALIZ 
aadd(aItem,"PA001          ") //D3_COD 
aadd(aItem,"PROD ACABADO 01               ") //D3_DESCRI 
aadd(aItem,"UN") //D3_UM 
aadd(aItem,"01") //D3_LOCAL 
aadd(aItem,"E001           ") //D3_LOCALIZ 
aadd(aItem,"") //D3_NUMSERI 
aadd(aItem,"LOTFOR001 ") //D3_LOTECTL 
aadd(aItem,"") //D3_NUMLOTE 
aadd(aItem, stod("20131108")) //D3_DTVALID 
aadd(aItem,0) //D3_POTENCI 
aadd(aItem,25) //D3_QUANT 
aadd(aItem,0) //D3_QTSEGUM 
aadd(aItem,"") //D3_ESTORNO 
aadd(aItem,"") //D3_NUMSEQ 
aadd(aItem,"LOTFOR001 ") //D3_LOTECTL 
aadd(aItem,stod("20131108")) //D3_DTVALID 
//aadd(aItem,"") //D3_SERVIC
aadd(aItem,"") //D3_ITEMGRD 
aadd(aAuto,aItem) 
MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto) 

If !lMsErroAuto 
ConOut("Incluido com sucesso! " + cDoc) 
Else 
ConOut("Erro na inclusao!") 
MostraErro() 
EndIf 
ConOut("Fim : "+Time()) 
End Transaction
EndIf
//RESET ENVIRONMENT
Return Nil
