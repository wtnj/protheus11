#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNTA4207()      �Autor  �Jo�o Felipe da Rosa� Data �09/05/08���
�������������������������������������������������������������������������͹��
���Desc.     �  VALIDACAO DE OS CORRETIVA MNTA420                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION MNTA4207() 

Local _oldAlias := alias()

	/**********************************
	* BLOQUEIA OS PARA C.CUSTO IMOBIL *
	**********************************/
	DBSELECTAREA('ST9')
	DBSETORDER(1) //FILIAL + CODBEM
	IF DBSEEK(XFILIAL('ST9')+M->TJ_CODBEM)
		
		IF ALLTRIM(ST9->T9_CCUSTO) == Iif(SM0->M0_CODIGO=="FN","IMOBILIZ","IMOBIL")
			MsgBox("Centro de custo para o Bem n�o pode ser "+Iif(SM0->M0_CODIGO=="FN","IMOBILIZ","IMOBIL"),'C.Custo Inv�lido','INFO')
		ENDIF
		
		If SM0->M0_CODIGO=='NH'
			If Substr(ST9->T9_CCUSTO,1,1)=='5'
				MsgBox('O Bem n�o pode ter um C.Custo de Resultados (iniciando com 5). Altere o C.Custo do Bem e tente novamente','C.Custo Inv�lido','INFO')
				return .f.
			Endif
		ElseIf SM0->M0_CODIGO=='FN'
			If Substr(ST9->T9_CCUSTO,1,2)=='35'
				MsgBox('O Bem n�o pode ter um C.Custo de Resultados (iniciando com 5). Altere o C.Custo do Bem e tente novamente','C.Custo Inv�lido','INFO')
				return .f.
			Endif
		Endif			

		/*************************************
		* BLOQUEIA OS PARA C.CUSTO BLOQUEADO *
		*************************************/
		CTT->(DBSETORDER(1))
		IF CTT->(DBSEEK(XFILIAL('CTT')+ST9->T9_CCUSTO))
			IF CTT->CTT_BLOQ == '1'
				MsgBox('Centro de custo para o Bem est� bloqueado no cadastro','C.Custo Inv�lido','INFO')
			ENDIF
		ELSE
			MsgBox('Centro de Custo para o Bem n�o existe no cadastro','C.Custo Inv�lido','INFO')
		ENDIF
	
	ELSE
		ALERT('BEM NAO EXISTE')
		Return .F.
	ENDIF
	
	/********************************************************
	* LOGIN MANUTENCAO SO PODE ABRIR OS COM STATUS LIBERADO *
	********************************************************/
	//If SM0->M0_CODIGO == "NH"
	
	
	If ST9->T9_CENTRAB$"UTI-03/UTI-01/FAB-01/FAB-03/DISPOS"
		If ("MANUTENCAO"$ALLTRIM(UPPER(cUserName))) .AND. M->TJ_SITUACA != "L"
			Alert("Somente permitido abrir OS com Status Liberado!")
			Return .F.
		EndIf
	EndIf
	
	If !ST9->T9_CENTRAB$"UTI-03/UTI-01/FAB-01/FAB-03/DISPOS/FAB-05"

		//OS N�: 023117
		//DATA: 03/10/2011
		//Autor: JOAO FELIPE DA ROSA
		
		//-- comentado pela OS: 050518
		/*
		If M->TJ_SERVICO$"000000" .and. M->TJ_MAQSIT!="P"
			Alert("S� � permitido OS Corretiva (Servi�o 000000) para M�quina = PARADA")
			Return .F.
		Endif		
		*/
		//FIM OS N�: 023117
		
		/****************************************************************************************
		* LOGINS MANUTENCAO E MANUTENCAOF SO PODEM ABRIR OS COM SERVICO 000000 E MAQUINA PARADA *
		****************************************************************************************/
    	If ALLTRIM(UPPER(cUserName))$"MANUTENCAO/MANUTENCAOF" 
    	
			If !M->TJ_SERVICO$"000300/000000/000010"
				Alert("Logins MANUTENCAO e MANUTENCAOF s� podem abrir OS com servi�o(000000,000300,000010)")
   				Return .F.
    		EndIf

    	EndIf

		/********************************************
		* BLOQUEIA OS PENDENTE PARA ALGUNS SERVI�OS *
		********************************************/
	    If !M->TJ_SERVICO$"000000/000001/000029/000031/000032/000033" .AND. M->TJ_SITUACA=="P"
	    	Alert("Status n�o pode ser Pendente para este servi�o!")
	    	Return .F.
	    Else
	    	If M->TJ_SERVICO$"000000" .AND. M->TJ_MAQSIT!="P"
				Alert("Status s� pode ser Pendete para servi�o 000000 para M�q. parada!")
				Return .F.
			EndIf
		EndIf
	EndIf
	
	DBSELECTAREA(_oldAlias)

	//CHAMADO 005445
	//Sempre que alterar a OS para Pendente, o Status fica como AGPROG (Aguardando Programa��o)
	If M->TJ_SITUACA=="P" .AND. (M->TJ_STFOLUP!="AGPROG" .OR. M->TJ_STFOLUP!="AGMAT")
		M->TJ_STFOLUP := "AGPROG"
	EndIf
	
RETURN U_VALUSOINSUMO()

//����������������������������������������������Ŀ
//�VALIDA OS 4 CAMPOS                            �
//�TL_HRUSINI, TL_DTUSINI, TL_HRUSFIM, TL_HRUSFIM�
//������������������������������������������������

USER FUNCTION VALUSOTL()
	
	IF !EMPTY(M->TL_DTUSINI) .AND. !EMPTY(M->TL_DTUSFIM)
		IF M->TL_DTUSFIM < M->TL_DTUSINI
			MSGBOX("Data de Uso Final deve ser maior do que Data de Uso Inicial","HORA","INFO")
			RETURN .F.
		ENDIF
	
		IF M->TL_DTUSFIM == M->TL_DTUSINI .AND.;
		   M->TL_HRUSFIM < M->TL_HRUSINI .AND.;
		   !EMPTY(M->TL_HRUSINI) .AND. !EMPTY(M->TL_HRUSFIM)
		   
			MSGBOX("Hora de Uso Final deve ser maior do que Hora de Uso Inicial","HORA","INFO")
			RETURN .F.
		ENDIF
    ENDIF
    
RETURN .T.
              

//�����������������������������������������������������������Ŀ
//�GATILHO PARA PUXAR A HORA FINAL DE USO DO INSUMO FERRAMENTA�
//�CONSIDERANDO O CAMPO TL_QUANTID                            �
//�������������������������������������������������������������

USER FUNCTION TL_HRFIM()

Local _newHoraFim

	IF M->TL_TIPOREG$'F' .AND. (INCLUI .OR. ALTERA)//Se � insumo do tipo Ferramenta
	
		IF !EMPTY(M->TL_DTUSINI) .AND. !EMPTY(M->TL_HRUSINI)
	   			
			_nHrMais   := HoraToInt(M->TL_HRUSINI) + M->TL_QUANTID
	   			
			WHILE _nHrMais > 24
	   			
				_nHrMais -= 24
	 			
			ENDDO
	   			
			_newHoraFim := IntToHora(_nHrMais)
	    ENDIF

	ENDIF

RETURN _newHoraFim
                 

//�����������������������������������������������������������Ŀ
//�GATILHO PARA PUXAR A DATA FINAL DE USO DO INSUMO FERRAMENTA�
//�CONSIDERANDO O CAMPO TL_QUANTID                            �
//�������������������������������������������������������������

USER FUNCTION TL_DTFIM()

Local _newDataFim

	IF M->TL_TIPOREG$'F' .AND. (INCLUI .OR. ALTERA)//Se � insumo do tipo Ferramenta
	
		IF !EMPTY(M->TL_DTUSINI) .AND. !EMPTY(M->TL_HRUSINI)
	   			
			_nHrMais   := HoraToInt(M->TL_HRUSINI) + M->TL_QUANTID
	   		_nDiasMais := 0
	   			
			WHILE _nHrMais > 24
	   			
				_nHrMais -= 24
				_nDiasMais++
	 			
			ENDDO
	   			
			_newDataFim := M->TL_DTUSINI + _nDiasMais
	    ENDIF
	
	ENDIF

RETURN _newDataFim


//������������������������������������������������Ŀ
//� VERIFICA SE A FERRAMENTA INFORMADA COMO INSUMO �
//� NAO EST� ALOCADA PARA OUTRA ORDEM DE  SERCVI�O �
//� NO MESMO PER�ODO DATA E HORA                   �
//��������������������������������������������������

USER FUNCTION VALUSOINSUMO()

Local cQuery
Local _dDt, _nHr
Local _lRet := .T.    
Local _oldAlias := alias()

    //Varre o Array de Insumos
    FOR _x := 1 to Len(aGETINS)
    	
    	IF aGETINS[_x][1]$'F' .AND. (INCLUI .OR. ALTERA)//Se � insumo do tipo Ferramenta
        
			cQuery := "SELECT TL_ORDEM, TL_CODIGO, TL_HRUSINI, TL_HRUSFIM, TL_DTUSINI, TL_DTUSFIM "
			cQuery += " FROM "+RetSqlName('STL')+" TL, "+RetSqlName('STJ')+" TJ"
			cQuery += " WHERE TL_TIPOREG = 'F'"
			cQuery += " AND TL.TL_CODIGO = '"+aGETINS[_x][2]+"'"
            cQuery += " AND TL.TL_DTUSFIM >= '"+DTOS(aGETINS[_x][15])+"'"
            cQuery += " AND TL.TL_DTUSINI <= '"+DTOS(aGETINS[_x][17])+"'"
			cQuery += " AND TL.TL_ORDEM = TJ.TJ_ORDEM"
			cQuery += " AND TL.D_E_L_E_T_ = '' AND TL.TL_FILIAL = '"+xFilial("STL")+"'"
			cQuery += " AND TJ.D_E_L_E_T_ = '' AND TJ.TJ_FILIAL = '"+xFilial("STJ")+"'"  
		
			TCQUERY cQuery NEW ALIAS 'TRA1'
			
			TcSetField("TRA1","TL_DTUSINI","D")  // Muda a data de string para date    
			TcSetField("TRA1","TL_DTUSFIM","D")  // Muda a data de string para date    	
			
			TRA1->(DBGOTOP())
				
			_dDt := aGETINS[_x][15]
			_nHr := HoraToInt(aGETINS[_x][16])
			
			WHILE TRA1->(!EOF())

				If TRA1->TL_DTUSFIM == aGETINS[_x][15]
					If HoraToInt(aGETINS[_x][16]) < HoraToInt(TRA1->TL_HRUSFIM) .AND. ;
					   HoraToInt(aGETINS[_x][16]) >= HoraToInt(TRA1->TL_HRUSINI)
						_lRet := .F.
						EXIT
					EndIF
				ElseIf TRA1->TL_DTUSFIM >  aGETINS[_x][15]
				    IF TRA1->TL_DTUSINI == aGETINS[_x][15]
						IF HoraToInt(aGETINS[_x][18]) > HoraToInt(TRA1->TL_HRUSINI)
							_lRet := .F.
							EXIT
						EndIf
					ElseIf TRA1->TL_DTUSINI < aGETINS[_x][15]
						_lRet := .F.
						EXIT						
					EndIf
				EndIf
				
				If TRA1->TL_DTUSINI == aGETINS[_x][17]
					If HoraToInt(aGETINS[_x][18]) > HoraToInt(TRA1->TL_HRUSINI) .AND. ;
					   HoraToInt(aGETINS[_x][18]) <= HoraToInt(TRA1->TL_HRUSFIM)
						_lRet := .F.
						EXIT
					EndIf
				ElseIf TRA1->TL_DTUSINI <  aGETINS[_x][17]
					If TRA1->TL_DTUSFIM == aGETINS[_x][15]
						If HoraToInt(aGETINS[_x][16]) < HoraToInt(TRA1->TL_HRUSFIM)
							_lRet := .F.
							EXIT
						EndIf
					ElseIf TRA1->TL_DTUSFIM > aGETINS[_x][15]
						_lRet := .F.
						EXIT
					EndIf
				EndIf
				
				TRA1->(DBSKIP())

			ENDDO            
			
			If !_lRet
			
				MsgBox("Hor�rio indispon�vel para uso da ferramenta "+aGETINS[_x][2]+"." + chr(13)+chr(10) + chr(13) + chr(10) +; //pula linha
			           "Usado Por: " + chr(13) + chr(10) + chr(13) + chr(10) + ;
			           "O.S.: "+TRA1->TL_ORDEM + chr(13) + chr(10) + ;
			           "Data Inicial: " + DTOC(TRA1->TL_DTUSINI) + chr(13) + chr(10) + ;
			           "Hora Inicial: " + TRA1->TL_HRUSINI       + chr(13) + chr(10) + ;
			           "Data Final..: " + DTOC(TRA1->TL_DTUSFIM) + chr(13) + chr(10) + ;
			           "Hora Final..: " + TRA1->TL_HRUSFIM       + chr(13) + chr(10) , "INSUMO","INFO")
			           
			 	TRA1->(DBCLOSEAREA())
			 	
			 	Return _lRet
			           
			EndIf
			
			DBSELECTAREA('SH4')
			DBSETORDER(1)
			IF DBSEEK(XFILIAL('SH4')+aGETINS[_x][2])
				IF aGETINS[_x][5] > SH4->H4_QUANT
					MSGBOX("Quantidade insuficiente do insumo: "+aGETINS[_x][2],"INSUMO","INFO")
					RETURN .F.
				ENDIF
			ELSE 
				MSGBOX("Insumo n�o cadastrado: "+aGETINS[_x][2],"INSUMO","INFO")
				RETURN .F.
			ENDIF 
			
			TRA1->(DBCLOSEAREA())
    	
        ENDIF
    NEXT    
                 
    DBSELECTAREA(_oldAlias)

RETURN .T.

/*  
USER FUNCTION MNTA4202()

ALERT('4202')          

RETURN .T.

USER FUNCTION MNTA4203()

ALERT('4203')          

RETURN .T.
          
USER FUNCTION MNTA4204()

ALERT('4204')          

RETURN .T.

USER FUNCTION MNTA4205()

ALERT('4025')          

RETURN .T.

USER FUNCTION MNTA4206()

ALERT('4026')          

RETURN .T.

USER FUNCTION MNTA4208()

ALERT('4208')          

RETURN .T.            

USER FUNCTION MNTA4209()

ALERT('4209')          

RETURN .T.

*/


