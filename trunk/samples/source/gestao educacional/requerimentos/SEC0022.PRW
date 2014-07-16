#include "RWMAKE.CH"
#Include "MSOLE.CH"

#define CRLF	Chr(13)+Chr(10)

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �SEC0022A    � Autor � Gustavo Henrique     � Data � 03/04/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Valida os cursos de destino.                                  ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �SEC0022A        					    						���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410 - Requerimento de Transferencia de Curso - Veteranos  ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function SEC0022A(lWeb)

Local lRet		:= .F.
Local lUnid		:= iif(lWeb == nil,!Empty( M->JBH_SCP10 ),!Empty(httppost->PERG08))
Local cVersao	:= ""
Local aRet		:= {}

lWeb		:= iif(lWeb == nil,.F.,lWeb)

If !lWeb
	If NaoVazio()
	
		JAF->( dbSetOrder( 6 ) )
		If JAF->( dbSeek( xFilial( "JAF" ) + "1" + M->JBH_SCP12 ) )
		                                                              
			If Empty( M->JBH_SCP14 )
				M->JBH_SCP14 := ""
			EndIf	
	
			cVersao := Iif( Empty(M->JBH_SCP14), JAF->JAF_VERSAO, M->JBH_SCP14)
		          
			JAH->( dbSetOrder( 4 ) )
	
			If JAH->( dbSeek( xFilial( "JAH" ) + M->JBH_SCP12 + cVersao ) )
	
				Do While JAH->( ! EoF() .and. JAH->( JAH_CURSO == M->JBH_SCP12 .and. JAH_VERSAO == cVersao ) )
					// Em aberto e curso vigente diferente do curso matriculado
					If JAH->JAH_STATUS == "1" .and. JAH->JAH_CODIGO # M->JBH_SCP01 .and.;
						If( lUnid, JAH->JAH_UNIDAD == M->JBH_SCP10, .T. )
						lRet := .T.
						Exit
					EndIf
					JAH->( dbSkip() )
				EndDo
		
				If lRet
					M->JBH_SCP13 := JAF->JAF_DESC
					M->JBH_SCP14 := JAF->JAF_VERSAO
				Else
					MsgInfo( "N�o existe nenhum curso vigente ativo definido para o curso e versao informada." )
				EndIf	
				                                                                                                
			Else
				MsgInfo( "N�o existe nenhum curso vigente ativo definido para o curso e versao informada." )			
			EndIf	
		Else
			MsgInfo( "Curso padr�o n�o cadastrado." )
		EndIf	
	    
	EndIf

else //lWeb             

    
       if httppost->PERG08 <> Httpsession->unidade
 		  aadd(aRet,{.F.,"N�o � permitido transfer�ncias entre unidades."})
 		endif  

		JAF->( dbSetOrder( 6 ) )
		If JAF->( dbSeek( xFilial( "JAF" ) + "1" + httppost->PERG10 ) )
		                                                              
			If Empty( httppost->PERG12 )
				httppost->PERG12 := ""
			EndIf	
	
			cVersao := Iif( Empty(httppost->PERG12), JAF->JAF_VERSAO, httppost->PERG12)
		          
			JAH->( dbSetOrder( 4 ) )
	
			If JAH->( dbSeek( xFilial( "JAH" ) + httppost->PERG10 + cVersao ) )
	
				Do While JAH->( ! EoF() .and. JAH->( JAH_CURSO == httppost->PERG10 .and. JAH_VERSAO == cVersao ) )
					// Em aberto e curso vigente diferente do curso matriculado
					If JAH->JAH_STATUS == "1" .and. JAH->JAH_CODIGO # httppost->PERG01 .and.;
						If( lUnid, JAH->JAH_UNIDAD == httppost->PERG08, .T. )
						lRet := .T.
						Exit
					EndIf
					JAH->( dbSkip() )
				EndDo
		
				If !lRet
					aadd(aRet,{.F.,"O curso selecionado n�o esta dispon�vel para Transfer�ncia."})
				EndIf	
				                                                                                                
			Else
				aadd(aRet,{.F.,"O curso selecionado n�o esta dispon�vel para Transfer�ncia."})
			EndIf	
		Else
			aadd(aRet,{.F.,"Curso padr�o n�o cadastrado."})
		EndIf	
EndIf		

Return( iif(!lWeb,lRet,aRet) )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SEC0022b  �Autor  �Gustavo Henrique    � Data �  11/jul/02  ���
�������������������������������������������������������������������������͹��
���Descricao �Regra para gravacao da Grade Curricular do Externo para     ���
���          �analise.                                                    ���
�������������������������������������������������������������������������͹��
���Retorno   �ExpL1 : Informando se obteve sucesso                        ���
�������������������������������������������������������������������������͹��
���Uso       �Gestao Educacional - Requerimentos                          ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SEC0022B()

Local aScript := ACScriptReq( JBH->JBH_NUM )

RecLock("JCS", .T.)
JCS->JCS_FILIAL	:= xFilial("JCS")
JCS->JCS_NUMREQ	:= JBH->JBH_NUM
JCS->JCS_CURPAD	:= aScript[12]
JCS->JCS_VERSAO	:= aScript[14]
msUnlock("JCS")

Return( .T. )

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �SEC0022d    � Autor � Gustavo Henrique     � Data � 25/09/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Valida a unidade selecionada.                                 ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �SEC0022d        					    						���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/                                                                            
User Function SEC0022d(lWeb)

Local lRet	:= .T.
Local aArea	:= GetArea()

lWeb	:= iif(lWeb == nil,.F.,lWeb)

dbSelectArea( "JA3" )                 

If !lWeb
	If ! Empty( M->JBH_SCP10 )
	
		lRet := ExistCpo( "JA3", M->JBH_SCP10 )
		    
		If lRet
			M->JBH_SCP11 := Posicione( "JA3", 1, xFilial("JA3") + M->JBH_SCP10, "JA3_DESLOC" )
		EndIf
	
	Else                  
	
		M->JBH_SCP11 := ""
		
	EndIf

else //lWeb

	If ! Empty( httppost->PERG08 )
	
		lRet := ExistCpo( "JA3", httppost->PERG08 )
		    
		If lRet
			httppost->PERG09 := Posicione( "JA3", 1, xFilial("JA3") + httppost->PERG08, "JA3_DESLOC" )
		EndIf
	
	Else                  
	
		httppost->PERG09 := ""
		
	EndIf
EndIf

		
RestArea( aArea )

Return( lRet )

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �SEC0022e    � Autor � Gustavo Henrique     � Data � 25/09/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Imprime o documento referente ao Conteudo Programatico e      ���
���          �Historico Escolar.                                            ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �SEC0022e        					    						���
���������������������������������������������������������������������������Ĵ��
���Parametros�EXPL1 - Se estah sendo chamada do requerimento de             ���
���          �aproveitamento de estudos.                                    ���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function SEC0022e( lAprov )
                        
Local lRet 		:= .T.
Local aRet		:= ACScriptReq( JBH->JBH_NUM )
Local lImprime	:= .T.

lAprov := iif( lAprov == NIL, .F., lAprov )
            
if lAprov
	lImprime := (aRet[3] # "01")
endif

if lImprime
	U_SEC0002()		// Imprime Historico Escolar
endif

Return( lRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SEC0022f  �Autor  �Gustavo Henrique    � Data �  18/out/02  ���
�������������������������������������������������������������������������͹��
���Descricao �Filtro para consulta J13 do curso refeente ao campo curso do���
���          �script do requerimento de de Transferencia Externos         ���
�������������������������������������������������������������������������͹��
���Retorno   �ExpL1 : Informando se obteve sucesso                        ���
�������������������������������������������������������������������������͹��
���Uso       �Gestao Educacional  									      ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SEC0022f()

Local lRet := .F.
              
If JAF->JAF_ATIVO == "1"
     
	JAH->( dbSetOrder( 4 ) )
	JAH->( dbSeek( xFilial( "JAH" ) + JAF->( JAF_COD + JAF_VERSAO ) ) )
	
	If JAH->JAH_STATUS == "1" .and. Iif( ! Empty( M->JBH_SCP10 ), JAH->JAH_UNIDAD == M->JBH_SCP10, .T. )
		lRet := (Posicione( "JBK", 3, xFilial( "JBK" ) + "1" + JAH->JAH_CODIGO, "JBK_ATIVO" ) == "1")
	EndIf
	                        
EndIf

Return( lRet )


/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �SEC0022h    � Autor � Gustavo Henrique     � Data � 15/04/03  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica se mudou de curso vigente, caso nao mudou apenas     ���
���          �atualiza a situacao das disciplinas da grade do aluno.        ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �SEC0022h        					    						���
���������������������������������������������������������������������������Ĵ��
���Uso		 �Requerimento de Aproveitamento de Estudos	(000032)   			���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function SEC0022h()

local lRet		:= .T.
local aRet		:= ACScriptReq( JBH->JBH_NUM )
local cRA		:= PadR( JBH->JBH_CODIDE, TamSX3( "JA2_NUMRA" )[1] )
local cCurso	:= aRet[ 01 ]
local cTurma    := aRet[ 06 ]
               
JCS->( dbSetOrder( 1 ) )
JCS->( dbSeek( xFilial( "JCS" ) + JBH->JBH_NUM ) )

lRet := ( cCurso == JCS->JCS_CURSO )
                 
if lRet

	JCT->( dbSetOrder(1) )		// JCT_FILIAL+JCT_NUMREQ+JCT_PERLET+JCT_HABILI+JCT_DISCIP
	JCT->( dbSeek(xFilial("JCT")+JBH->JBH_NUM ) )
				
	do while JCT->( ! EoF() .and. JCT->JCT_NUMREQ == JBH->JBH_NUM )

		JC7->( dbSetOrder( 1 ) )
		JC7->( dbSeek( xFilial( "JC7" ) + cRA + cCurso + JCT->JCT_PERLET + JCT->JCT_HABILI + cTurma + JCT->JCT_DISCIP ) )
		                    
	   	do while JC7->( ! EoF() .And. JC7_FILIAL + JC7_NUMRA + JC7_CODCUR + JC7_PERLET + JC7_HABILI + JC7_TURMA + JC7_DISCIP ==;
			xFilial( "JC7" ) + cRA + cCurso + JCT->JCT_PERLET + JCT->JCT_HABILI + cTurma + JCT->JCT_DISCIP )
	                             
			RecLock( "JC7", .F. )
	            					
			JC7->JC7_SITUAC := iif( JCT->JCT_SITUAC == "003", "8", iif( JCT->JCT_SITUAC == "001", "A", JC7->JC7_SITUAC ) )
			JC7->JC7_SITDIS := JCT->JCT_SITUAC
	        
	        If JCT->JCT_SITUAC == "003"
	                                              
	        	JC7->JC7_MEDFIM := JCT->JCT_MEDFIM
	        	JC7->JC7_MEDCON := JCT->JCT_MEDCON
	        	JC7->JC7_DESMCO := JCT->JCT_DESMCO
	        	JC7->JC7_CODINS := JCT->JCT_CODINS
	        	JC7->JC7_ANOINS := JCT->JCT_ANOINS
	        
	        EndIf
	            					
			MsUnlock()			
	                                 
			JC7->( dbSkip() )
	
		enddo               

		//���������������������������������������������Ŀ
		//� Gera disciplinas dispensadas do aluno       �
		//�����������������������������������������������
		JCO->( dbSetOrder(1) )		// JCO_FILIAL+JCO_NUMRA+JCO_CODCUR+JCO_PERLET+JCO_HABILI+JCO_DISCIP
		lAchouJCO := JCO->( dbSeek( xFilial( "JCO" ) + cRA + cCurso + JCT->JCT_PERLET + JCT->JCT_HABILI + JCT->JCT_DISCIP ) )
			
		If JCT->JCT_SITUAC == "003" .and. ! lAchouJCO
				
			RecLock( "JCO", ! lAchouJCO )
				
			JCO->JCO_FILIAL := xFilial("JCO")
			JCO->JCO_NUMRA  := cRA
			JCO->JCO_CODCUR := cCurso
			JCO->JCO_PERLET := JCT->JCT_PERLET
			JCO->JCO_HABILI := JCT->JCT_HABILI
			JCO->JCO_DISCIP := JCT->JCT_DISCIP
			JCO->JCO_MEDFIM := JCT->JCT_MEDFIM
			JCO->JCO_MEDCON := JCT->JCT_MEDCON
			JCO->JCO_CODINS := JCT->JCT_CODINS
			JCO->JCO_ANOINS := JCT->JCT_ANOINS
				
			JCO->( MsUnLock() )
				
		ElseIf JCT->JCT_SITUAC == "010" .and. lAchouJCO
				
			RecLock( "JCO", ! lAchouJCO )
				
			JCO->( dbDelete() )
			
			JCO->( MsUnLock() )
				
		EndIf
			
		JCT->( dbSkip() )
			
	enddo	

endif

Return( lRet )