/*/



Programa   NHEST027         Jose Roberto Gorski                  Data 18.06.2001  

Descricao Gatilho para atualizacao da Conta Debito do SD3/SC1/SC7/SD1                

Sintaxe    Chamada padrao para programas em RDMake.                                  

Alteraes Osmar Schimitberger - conta cadastro de Grupo-SBM - 27/06/02              
            Alexandre R. Bento  - Limpar campo CC e Bloquear CC antigo    15/01/04    


*/

#include "rwmake.ch"

User Function nhest027()

SetPrvt("_nTcc,_cCampo,_cConta,_Grupo")
Public CCC                          

_nTcc   := Space(09)                                              
_cConta := " "					// Variavel de retorno da conta contabil
_Grupo:=SB1->B1_GRUPO

If Upper(FunName())$"MATA250/MATA240" 
   _nTcc := M->D3_CC                                                                            
//Elseif Upper(FunName())=="MATA240" .Or. Upper(FunName())=="MATA261" 
//   _nTcc := CCC  
Elseif Upper(FunName())=="MATA110" //.And. Len(Alltrim(M->C1_CC)) < 6   //solicitacao de compras
//   Acols[n][9] := Space(9) //Limpa centro de custo errado
   _nTcc := M->C1_CC
Elseif Upper(FunName())=="NHPCP011" //.And. Len(Alltrim(M->C1_CC)) < 6   //solicitacao de compras
//   Acols[n][9] := Space(9) //Limpa centro de custo errado
   _nTcc := M->C1_CC
Elseif Upper(FunName())$"MATA105/NHEST151" //solicitacao ao almoxarifado
   _nTcc := M->CP_CC	   
Elseif Upper(FunName())$"MATA241/NHEST087/NHPCP010"
   _nTcc:= CCC
Elseif Upper(FunName())=="MATA121"
   _nTcc := M->C7_CC
Elseif Upper(FunName())=="MATA103"
   _nTcc := M->D1_CC
   
Elseif Upper(FunName())=="FINA050"
   _nTcc := M->E2_CC
   
//Elseif Upper(FunName())=="ATFA010"
//   _nTcc := M->N3_CUSTBEM
//   _nTcc1:= M->N3_CCUSTO
   
Endif      
/*
If FunName()$"BRWZSC"
	lMsErroAuto := .F.
	Return
EndIf
*/
// Verifica o tamanho do centro de custo digitado, nao pode ser menor que 6 digitos
If Len(Alltrim(_nTcc)) < Iif(SM0->M0_CODIGO=="FN",8,6) .AND. ( (FunName())<>"NHEST208" .AND. (FunName())<>"AP11_ACD_NEW" .AND. (FunName())<>"BRWZSC" )  // NHEST208 = RNC (Não tem campo CC), por isso não necessita desta validacao   

   //verifica se a variavel que controla o erro via coletor está declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "ATENCAO: DIGITE O CENTRO DE CUSTO COM "+STRZERO(Iif(SM0->M0_CODIGO=="FN",8,6),1)+" DIGITOS!!!!!!!!"
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (NHEST057)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					MsgBox("ATENCAO: DIGITE O CENTRO DE CUSTO COM "+STRZERO(Iif(SM0->M0_CODIGO=="FN",8,6),1)+" DIGITOS!!!!!!!!")
			    fFuncao() // Limpa campo de centro de custo
	  		endif		
   
Endif

// Retirado pois a contabilidade gerencial trata CC bloqueados
// Centro de custo bloqueados passados pelo Osmar em 15/01/04
//SI3->(DbSeek(xFilial("SI3")+Subs(_nTcc,1,6),.T.))
//If SI3->I3_ATIVO =="I" // Inativo
//   MsgBox("ATENCAO: CENTRO DE CUSTO BLOQUEADO, USAR  CENTRO DE CUSTO VALIDO !!!!!!!!")
//   fFuncao() // Limpa campo de centro de custo dependendo da rotina utilizada
//Endif

//If Subs(_nTcc,1,6)$"401002/401003/401007/401009/401011/402001/404002/411002/411003/411004/412001/413001/413002/415001/302002/404002/402001/401012/410002"
//   MsgBox("ATENCAO: CENTRO DE CUSTO BLOQUEADO, USAR  CENTRO DE CUSTO VALIDO !!!!!!!!")
//   fFuncao() // Limpa campo de centro de custo dependendo da rotina utilizada
//Endif

If !Upper(FunName())$"FINA050"
	SBM->(DbSelectArea("SBM"))	// Abre arquivo SBM -> Grupos de Produtos
	SBM->(DbSetOrder(1))			// Filial + Grupo
	SBM->(DbGotop())				// Posiciona no inicio do arquivo
	SBM->(DbSeek(xFilial("SBM")+_GRUPO),.T.)		// Procura no SBM o grupo digitado no SD3
	
	If  AllTrim(_GRUPO) == AllTrim(SBM->BM_GRUPO)  // Se forem iguais SBM e SB1
	
		//-- adicionado por joaofr
		If SM0->(EOF())
			SM0->(DBSEEK(CNUMEMP))
		Endif
	
		Do Case 
		   Case SM0->M0_CODIGO == "NH"  //empresa Usinagem	
		         If substr(_nTcc,1,1) $ "1/2"
			        _cConta := SBM->BM_CTAADM
			     Else // Empresa Fundio
                    _cConta := SBM->BM_CTADIR			     
			     Endif                                       
		   Case SM0->M0_CODIGO$"FN/IT"  //empresa Fundicao
		         If substr(_nTcc,2,1) $ "3/4" .OR. (substr(_nTcc,2,1)$"5" .AND. SB1->B1_TIPO$"BN")
				    _cConta := SBM->BM_CTADIR
				 ElseIf substr(_nTcc,2,1) $ "7"
					 _cConta := SBM->BM_CTAINOV
				 Else // Empresa Fundio
			        _cConta := SBM->BM_CTAADM
				 Endif	   
		EndCase      
//  	OtherWise
	Endif


   Return(_cConta)

Endif
	
Return


// Funcao p/ limpar a variavel de centro de custo dependendo a funcao chamada
Static Function fFuncao()

	If Upper(FunName())=="MATA240" .Or. Upper(FunName())=="MATA250" .Or.;
	   Upper(FunName())=="MATA261" // Internos I, Transf. modelo I e apont. produo
      M->D3_CC := Space(09) //Limpa centro de custo errado
      
	Elseif Upper(FunName())=="MATA110"  //solicitacao de compras
   	_cCampo := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C1_CC"})
	   Acols[n][_cCampo] := Space(9) //Limpa centro de custo errado    
	  
	Elseif Upper(FunName())=="MATA241"  //Internos modelo II
      CCC := Space(09)                                              
  	Elseif Upper(FunName())=="MATA121" //pedido de compras
    	_cCampo := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_CC"})
	   Acols[n][_cCampo] := Space(9) //Limpa centro de custo errado    
	   
	Elseif Upper(FunName())=="MATA103" // nota fiscal de entrada
    	_cCampo := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_CC"})
	   Acols[n][_cCampo] := Space(9) //Limpa centro de custo errado    
                                
	Elseif Upper(FunName())=="MATA105"  //solicitacao AO ALMOXARIFADO
   	_cCampo := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_CC"})
	   Acols[n][_cCampo] := Space(9) //Limpa centro de custo errado    
	   
	Elseif Upper(FunName())=="FINA050" // Contas a Pagar
      M->E2_CC := Space(09) //Limpa centro de custo errado

	Endif

Return	
