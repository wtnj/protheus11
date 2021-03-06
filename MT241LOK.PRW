/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � Mt241LOK        � Osmar Schimitberger   � Data �09.07.2002���
������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada para validar a linha da rotina MATA241   ���
���            Internos Modelo 2										 ���
������������������������������������������������������������������������Ĵ��
���Uso       � Estoque / Custos                                          ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/

#include "rwmake.ch"        

User Function MT241LOK
Local _nLocaliz := aScan(Aheader,{|x| UPPER(X[2])=="D3_LOCALIZ"})
Local _nLote 	:= aScan(Aheader,{|x| UPPER(x[2])=="D3_LOTECTL"})
Local _nProd 	:= aScan(Aheader,{|x| ALLTRIM(UPPER(x[2]))=="D3_COD"})
Local _nSerial  := aScan(Aheader,{|x| ALLTRIM(UPPER(x[2]))=="D3_NSERIE"})
Local _nLocal   := aScan(Aheader,{|x| ALLTRIM(UPPER(x[2]))=="D3_LOCAL"})
Local _nSolic   := aScan(Aheader,{|x| ALLTRIM(UPPER(x[2]))=="D3_SOLICIT"})
Local _nQtde    := aScan(Aheader,{|x| ALLTRIM(UPPER(x[2]))=="D3_QUANT"})
Local _cOp   	:= aScan(Aheader,{|x| ALLTRIM(UPPER(x[2]))=="D3_OP"})

Local _nGrupo   := aScan(Aheader,{|x| ALLTRIM(UPPER(x[2]))=="D3_GRUPO"})
Local _nCorr    := aScan(Aheader,{|x| ALLTRIM(UPPER(x[2]))=="D3_CORRID"})

Local _nConta   := aScan(Aheader,{|x| ALLTRIM(UPPER(x[2]))=="D3_CONTA"})
Local _nDias    := GETMV("MV_DIASMO")
Private _nOrdem := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_ORDEM"})
Private _CCC    := Alltrim(CCC)

// Verifica se produto est� bloqueado para invent�rio, adicionado em 23/10/12
IF !aCols[n][len(aHeader)+1]	
	IF !U_E205BLQ(Acols[n][_nProd],Acols[n][_nLocal],.F.)				
	    Return .F. 	
	EndIF

	//-- SOLICITADO PELA ANAP
	If !U_NHEST165(_CCC,aCols[n][_nConta],Acols[n][_nProd])
	  	Return .F.
	EndIf
ENDIF

If Da241data < (Date()- _nDias) .OR. Da241data < (dDatabase - _nDias)  //Controle de data para n�o permitir mov. com data retroativa controle paramatro mv_diasmo = numero de dias
   MsgBox( "Impossivel Fazer a Transferencia Data Menor que a Permitida Depto Custo! - P.E. - MT241LOK", "Mov. Internas 2", "STOP" )
   Return(.F.)
Endif

// ----------------------------------------
// VALIDACAO PARA OEE PERNAMBUCO - 12/12/13
// ----------------------------------------
/*
 SM0->M0_CODIGO == "FN" .and. SM0->M0_CODFIL == "02" .and. Alltrim(aCols[n][_cLocal])$'52' .and. Alltrim(aCols[n][_cLocDest])$'54'
   If Empty(AllTrim(Acols[n][_cOp])) 	             
   		if Type("MsgRetWMS")=="C"                                              
  			//retorna o erro ao coletor
  			MsgRetWMS := "Campo Ordem de Produ��o vazio ! Transferencias do 52 para o 54 � obrigatorio o preenchimento do campo !"
			//indica a origem da mensagem para faciliar o suporte
			MsgRetWMS += " (P.E. MA261LIN)"			
  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
	  	    lMsErroAuto := .T.
		else
			Alert("Campo Ordem de Produ��o vazio ! Transferencias do 52 para o 54 � obrigatorio o preenchimento do campo !")
			return .F.
  		endif		
   EndIF
EndIf
*/

If AllTrim(aCols[n,_nLocal])=="21"
   SB5->(DbSetOrder(1))
   If SB5->(DbSeek(xFilial("SB5")+Acols[n][_nProd]))
      If !Empty(SB5->B5_QPA) .AND. Acols[n][_nQtde]%SB5->B5_QPA != 0
     	  MsgBox("A quantidade deve ser igual ou m�ltipla da quantidade padr�o do produto!"+CHR(13)+CHR(10)+;
		   "Quantidade Padr�o: "+AllTrim(STR(SB5->B5_QPA)),"QUANTIDADE PADR�O","ALERT")
	     Return .F.
	  Endif
   Endif
EndIf

//-- Validacao do campo D3_ORDEM
//-- Caso o campo D3_ORDEM seja informado valida se a Ordem de Servi�o de
//-- Manuten��o � do mesmo C.Custo da Movimenta��o

If !Empty(aCols[n,_nOrdem])
	dbSelectArea("STJ")
	dbSetOrder(1)
	dbSeek(xFilial("STJ")+aCols[n,_nOrdem])

	If STJ->TJ_CCUSTO <> _CCC
		MsgBox( "Atencao o CENTRO DE CUSTO DA O.S. difere do digitado!", "ALERT" )
	   	Return(.F.)
	Endif
Endif

//-- Restri��o para usu�rios que podem realizar baixa somente em alguns almoxarifados 
If SM0->M0_CODIGO=="FN" //empresa fundicao                    
	
	//-- TABELA ZEQ, PERMISSOES / BLOQUEIOS PARA BAIXA OU TRANSFER�NCIA
	cAl := getnextalias()
	beginSql Alias cAl
	
		SELECT * FROM %Table:ZEQ%
		WHERE ZEQ_LOGIN = %Exp:alltrim(upper(cUsername))%
		AND ZEQ_LOCAL = %Exp:AllTrim(aCols[n,_nLocal])%
		AND ZEQ_MOVIM = 'B'
		AND ZEQ_FILIAL = %xFilial:ZEQ%
		AND %NotDel%
	
	endSql
	
	lZEQPermis := .F.
	lZEQBloque := .F.
	
	While (cAl)->(!eof())
		
		If (cAl)->ZEQ_PERMIS=='P'
			lZEQPermis := .T.
		ElseIf (cAl)->ZEQ_PERMIS=='B'
			lZEQBloque := .T.
		Endif
		
		(cAl)->(dbSkip())
	Enddo

	(cAl)->(dbCloseArea())
	
	If !lZEQPermis .OR. lZEQBloque
		MsgBox("Usu�rio n�o tem permiss�o para realizar baixa no armaz�m "+AllTrim(aCols[n,_nLocal])+"!","PE MT241LOK (ZEQ)","ALERT")
	  	Return(.F.)
	Endif     
	
	//-- Adicionado em 26/09/13 - � pedido MARIOCP - forjaria
	IF SM0->M0_CODFIL=='01
	   IF ALLTRIM(Acols[n][_nGrupo])$"PA04\TR04" .AND. Empty(Acols[n][_nCorr]) .AND. CTM = '501'
	      	MsgBox("Campo CORRIDA � obrigatorio para baixa em produtos da forjaria !","PE MT241LOK ","ALERT")
		  	Return(.F.)			   	  	                                                                         
	   ENDIF
	ENDIF      
	
	//-- OS N�: 044447
    IF SM0->M0_CODFIL=='02' .AND. substr(aCols[n,_nLocal],0,1) <> "5" .AND. !Alltrim(upper(cUsername))$"ERICALP\DOUGLASSD\ADMIN\JOAOFR\ALEXANDRERB\MARCOSR\DAIANESC\ANAP" 
       MsgBox("Armaz�m n�o pode ser utilizado!  Na filial 02 (PE) s� pode ser utilizado armazens com inicio 5 !","PE MT241LOK ","ALERT")
   	   Return(.F.)    	
  	ENDIF    
    //-- FIM OS 044447
    
	
	//-- OS N�: 021437
	//-- data: 09/08/2011
	//-- autor: Jo�o Felipe da Rosa
	//-- desc: bloquear baixas como kg para o item IVE01.5.0008.03 pois � controlado em unidade. 
	//--       E mostrar mensagem caso itens PSA01.5.0008.01 e GMB01.5.0008.01
	If ALLTRIM(Acols[n][_nProd])$"IVE01.5.0008.03" .AND. (aCols[n,_nQtde] - Int(aCols[n,_nQtde])) > 0 .And. (aCols[n,_nQtde] - Int(aCols[n,_nQtde])) < 1 //Valida a digitacao de qtde quebrada na unidade
		Alert("Quantidade n�o pode ser quebrada, produto � controlado por Unidade!")
		Return .F.
	EndIf
	
	If ALLTRIM(Acols[n][_nProd])$"PSA01.5.0008.01/GMB01.5.0008.01"
		If !MSGYesNo('ATEN��O: ESTE ITEM � CONTROLADO POR KG. DESEJA CONTINUAR?')	
			Return .f.
		Endif
	EndIf
	//-- fim OS 021437
	
	
	// -- OS N� 073959 
	// -- data: 08/05/2014
	// -- autor: Douglas Dourado
	// -- desc: Fizeram uma 501 de um MOD e deixou o mesmo divergente no fechamento, ent�o a pedido da 
	// -- Ana da controladoria foi feita a valida��o abaixo
		
    //	If ALLTRIM(Acols[n][_nProd])$"PSA01.5.0008.01/GMB01.5.0008.01"
    If ALLTRIM(Acols[n][_nGrupo])$"MO01".AND. CTM = '501'	
		MsgBox("Produtos do grupo MO01 n�o podem ser utilizados no T.M. 501 !","PE MT241LOK ","ALERT")    
		Return .f.	
	EndIf
	
	// fim OS 073959
	
	//-- OS N�: 021435
	//-- data: 09/08/2011
	//-- autor: Jo�o Felipe da Rosa
	//-- desc: bloquear baixas com TES 501 para o grupo CP e MP, para evitar erros de baixas. (estoque 32 e 33). 
	//--       Deixar liberado apenas para Ana Pelhuca e Fernando Werner
	//-- ALTERA��O: SOLICITADO POR ANAPP para incluir exce�ao do produto IVE01.5.0008.03 (11/10/2011)
	//-- ALTERA��O: SOLICITADO POR ERICALP para incluir exce��o do produto VWB01.5.0008.01 (OS: 030421)
	//-- ALTERACAO: Adicionado ROGERIO e VALDELENE como exce��o (OS: 033035)
	//-- ALTERA��O: REMOVIDO BLOQUEIO (OS: 044692)
	
	/*
	If !alltrim(upper(cUserName))$"FERNANDOW/ANAPP/REGINASM/DAIANESC/ROGERIO/VALDELENEMS" .AND. AllTrim(aCols[n,_nLocal])$"32/33"
	    SB1->(DbSetOrder(1)) //filial+cod
	    SB1->(DbSeek(xFilial("SB1")+Acols[n][_nProd]))
	   
		If !ALLTRIM(SB1->B1_COD)$'VWB01.5.0008.01/IVE01.5.0008.03' .AND. ALLTRIM(SB1->B1_TIPO)$"CP/MP" .AND. Alltrim(cTM)$"501"
			Alert("Baixa n�o permitida para produtos do grupo CP ou MP! Bloqueio solicitado pela Log�stica (ERICALP / RODRIGOPV).")
			Return .f.
		Endif
	
	Endif
	*/
	//-- fim OS 021435
   
EndIf
	
If UPPER(Funname())$"MATA241"

   SB1->(DbSetOrder(1)) //filial+cod
   SB1->(DbSeek(xFilial("SB1")+Acols[n][_nProd]))
   If SB1->B1_GRUPO$"PA02" .And. Acols[n][_nLocal]$"23/27"
	  MsgBox("O Produto nao pode ser Movimentado neste almoxarifado. Verifique!","Atencao","ALERT")
	  Return(.F.)
   Endif
//   If SM0->M0_CODIGO == "NH"  //ESTA PARTE DO PROGRAMA � APENAS PARA A empresa USINAGEM
	If CTM$"002/502"
	   SB1->(DbSetOrder(1)) //filial+cod
	   SB1->(DbSeek(xFilial("SB1")+Acols[n][_nProd]))
	   If SB1->B1_TIPO$"CC/MC"
	      MsgBox("O Tipo MC e CC So pode Ser Movimentado por Transferencia modelo 2. Verifique!","Atencao","ALERT")
		  Return(.F.)
	   Elseif SB1->B1_APROPRI <> "I"
	      MsgBox("Produto de Apropriacao Direta nao pode Utilizar Tipo de Movimeta��o 502 ou 002. Verifique!","Atencao","ALERT")
		  Return(.F.)
	   Endif
    Endif	
   
	If CTM$"002"
		For i:=1 to Len(Acols)
			If !Acols[n][len(aHeader)+1]  //nao pega quando a linha esta deletada
				If _nProd <> 0
					SB1->(DbSetOrder(1)) //filial+cod
					SB1->(DbSeek(xFilial("SB1")+Acols[n][_nProd]))
					If SB1->B1_RASTRO == "L"  		    
						If Empty(Acols[n][_nLote])
							MsgBox("Atencao, Lote n�o preenchido. Verifique!","ALERT")
							Return(.F.)
						EndIf
					    If SB1->B1_LOCALIZ == "S"  		    						
						   If Empty(Acols[n][_nLocaliz])
						    	MsgBox("Atencao, Localizacao n�o preenchida. Verifique!","ALERT")
							    Return(.F.)		
						   Endif	    
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	EndIf

	IF SM0->M0_CODIGO == "NH"  //empresa USINAGEM
		// VERIFICA SE � CARTUCHO, TONER OU PAPEL, E OBRIGA A DIGITAR O NUMERO DE SERIE
		SB1->(DBSEEK(XFILIAL("SB1")+ALLTRIM(ACOLS[N][_nProd])))
		IF SB1->(Found())
			IF SB1->B1_GRUPO == 'MX01' .AND. SB1->B1_DESC$"CARTUCHO/TONER/TINTA OCE/CABECOTE/PAPEL A4/PAPEL A3"
				IF EMPTY(ACOLS[N][_nSerial])
					ALERT("Para Cartuchos, Papel e Toners � necess�rio informar o n�mero de s�rie da impressora")
					Return .F.
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	
EndIf
	
//-- chamado 013719 do portal
If SM0->M0_CODIGO == "FN" //empresa fundicao
	SB1->(dbSetOrder(1))
	If SB1->(DBSEEK(XFILIAL("SB1")+ALLTRIM(ACOLS[N][_nProd])))
		If ALLTRIM(SB1->B1_TIPO)=="FE"
			If Empty(aCols[n][_nSolic])
				Alert("Matricula do solicitante obrigat�ria!")
				Return .f.
			Else
				QAA->(dbSetOrder(1))
				If !QAA->(dbSeek(xFilial("QAA")+aCols[n][_nSolic]))
					Alert("Matr�cula digitada n�o encontrada na tabela de usu�rios!")
					/*
					da Fundi��o!" + chr(10)+chr(13) + ;
					"ATEN��O: Para funcion�rios da Usinagem, � necess�rio trocar o primeiro d�gito da matr�cula para 7"+chr(10)+chr(13)+;
					"Exemplo: Matr 003131 => 703131")
					*/
					Return .F.
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

IF !Alltrim(upper(cUsername))$"DOUGLASSD\ADMIN\JOAOFR\ALEXANDRERB\MARCOSR\DAIANESC\ANAP" 

	SBM->(DbSetOrder(1))			// Filial + Grupo
	SBM->(DbSeek(xFilial("SBM")+ALLTRIM(Acols[n][_nGrupo])),.T.)		// Procura no SBM o grupo digitado no SD3
		
	If  AllTrim(ALLTRIM(Acols[n][_nGrupo])) == AllTrim(SBM->BM_GRUPO)  // Se forem iguais SBM e SB1
		Do Case
			Case substr(_CCC,2,1) $ "3/4"
				aCols[n][_nConta] := SBM->BM_CTADIR
			Case substr(_CCC,2,1) $ "7"
				aCols[n][_nConta] := SBM->BM_CTAINOV
			OtherWise
				aCols[n][_nConta] := SBM->BM_CTAADM
		EndCase
	Endif
ENDIF	
	
Return .T.