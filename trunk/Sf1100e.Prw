
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  SF1100E ³ Autor ³  Alexandre R. Bento  ³ Data ³ 27/01/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Excluir automaticamente a nota no quality qdo nota benefici³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Estoque													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ANALISTA      ³ DATA     ³      MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	Alexandre R.B ³ 05/09/03 ³ So excluir Tes que Atualiza Estoque         ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"                            
#include "topconn.ch"

User Function SF1100E()       
                          
SetPrvt("cDoc,cSerie,cFornece,cLoja,dData,cQuery,aTamLab,cChvMed,cSeek")

	cDoc     := SF1->F1_DOC
	cSerie   := SF1->F1_SERIE
	cFornece := SF1->F1_FORNECE
	cLoja    := SF1->F1_LOJA
	dData    := Dtos(SF1->F1_DTDIGIT)

	U_Nhest191()	

    If SF1->F1_TIPO$"B/N"  //Beneficiamento ou Normal
	   SF4->(DbSeek(xFilial("SF4")+SD1->D1_TES))
	   IF SF4->F4_ESTOQUE = "S"
	 	  cQuery := "SELECT *"
		  cQuery += " FROM " + RetSqlName( 'QEK' ) +" QEK "
		  cQuery += " WHERE QEK.QEK_FILIAL = '" + xFilial("QEK")+ "'"
          cQuery += " AND QEK.QEK_NTFISC = '" + cDoc + "' AND  QEK.QEK_LOJFOR = '" + cLoja + "'"
		  cQuery += " AND QEK.QEK_SERINF = '" + cSerie + "' AND QEK.QEK_FORNEC = '" + cFornece + "'" 
		  cQuery += " AND QEK.QEK_DTENTR = '" + dData + "'" 		
		  cQuery += " AND QEK.D_E_L_E_T_ = ' '"
 
		  // TCQuery Abre uma workarea com o resultado da query
  	      TCQUERY cQuery NEW ALIAS "TMP"
		
	      // Define Tamanho do campo Laboratorio
		  aTamLab := Array(2)
		  aTamLab := TamSX3("QEL_LABOR") // Parametro que indica o numero maximo de dias em atraso
	      
		  QEL->(dbSetOrder(1))
		  QER->(DbSetOrder(1))
		  QEU->(DbSetOrder(1))                               
	      QEK->(DbsetOrder(7)) //filial+chave
	      QEP->(DbsetOrder(2)) //filial+ntfiscal+serinf+fornec+lojfor+produt+dtos(dtentr)+lote	      
		  TMP->(Dbgotop())

		  While TMP->(!EOF())
	   
		     If QEK->(DbSeek(xFilial("QEK")+TMP->QEK_CHAVE))
		     
		     	cMsg := '<h3>Aviso de Exclusão de Nota Fiscal</h3><br />'
		     	cMsg += 'Foi excluída a seguinte Nota Fiscal bem como a importação no módulo de Inspeção de Entradas: <br /><br />'
		     	cMsg += 'Nota Fiscal: ' + cDoc + '<br />'
		     	cMsg += 'Serie: ' + cSerie + '<br />'
		     	cMsg += 'Produto: ' + QEK->QEK_PRODUT + '<br /><br />'
		     	
		     	cMsg += 'Obs.: Caso os resultados já tenham sido lançados, será necessário realizar novo lançamento.<br /><br />'
		     	
				oMail          := Email():New()
				oMail:cMsg     := cMsg
				oMail:cAssunto := "*** AVISO DE EXCLUSÃO DE NOTA FISCAL " + cDoc + " ***"
				oMail:cTo      := 'eversonco@whbbrasil.com.br;'+;
								  'joarezsb@whbbrasil.com.br;'+;
								  'lucileifs@whbbrasil.com.br;'+;
								  'valdeciz@whbbrasil.com.br;'+;
								  'jairom@whbbrasil.com.br;'+;
								  'tiagolb@whbbrasil.com.br'
				                  
				oMail:Envia()
					     	
		     	RecLock("QEK",.F.)
			       QEK->(DbDelete()) 
			    MsUnLock("QEK") 
			    
			 Endif   
			  
		     If QEP->(DbSeek(xFilial("QEP")+TMP->QEK_NTFISC+TMP->QEK_SERINF+TMP->QEK_FORNEC+TMP->QEK_LOJFOR+TMP->QEK_PRODUT+TMP->QEK_DTENTR+TMP->QEK_LOTE))
		       	RecLock("QEP",.F.)
			       QEP->(DbDelete()) 
			    MsUnLock("QEP")
			 Endif   
	
			 // Localiza o laudo geral da Entrega
			 If QEL->(dbSeek(xFilial("QEL")+TMP->QEK_FORNEC+TMP->QEK_LOJFOR+TMP->QEK_PRODUT+;
			          TMP->QEK_DTENTR+TMP->QEK_LOTE)) //+Space(aTamLab[1])))
			    //para pegar o lancamento no lab. fisico 
			     While QEL->(!EOF()) .And. QEL->QEL_FORNEC+QEL->QEL_LOJFOR+QEL->QEL_PRODUT+;
					   Dtos(QEL->QEL_DTENTR)+QEL->QEL_LOTE==TMP->QEK_FORNEC+TMP->QEK_LOJFOR+TMP->QEK_PRODUT+;
			          TMP->QEK_DTENTR+TMP->QEK_LOTE
       
				    RecLock("QEL",.F.)
				    	QEL->(DbDelete()) 
				    MsUnLock("QEL")
				    QEL->(Dbskip())
				  Enddo   
			  EndIf
      
			  // Acumula pontos de demeritos oriundos das NCs
			  cSeek := TMP->QEK_PRODUT+TMP->QEK_REVI+TMP->QEK_FORNEC+TMP->QEK_LOJFOR+;
					   TMP->QEK_DTENTR+TMP->QEK_LOTE
			  If QER->(DbSeek(xFilial("QER")+cSeek))
			     // para apagar todas as ocorrencias de nao conformidades
			     While QER->(!EOF()) .And. QER->QER_PRODUT+QER->QER_REVI+QER->QER_FORNEC+QER->QER_LOJFOR+;
					   Dtos(QER->QER_DTENTR)+QER->QER_LOTE==cSeek
			    	 // Obtem chave de ligacao da medicao com os outros arquivos
				     cChvMed := QER->QER_CHAVE
				     RecLock("QER",.F.)
				        QER->(DbDelete()) 
				     MsUnLock("QER")   
		   
	 				 // Verifica se a medicao tem NC
					 // tabela de não conformidade
				     IF QEU->(dbSeek(xFilial("QEU")+cChvMed))
				  	     While QEU->(!EOF()) .And. QEU->QEU_CODMED==cChvMed
						     RecLock("QEU",.F.)
						       QEU->(DbDelete()) 
						     MsUnLock("QEU")   
						     QEU->(Dbskip())
					     Enddo   
				     Endif
				     QER->(Dbskip())
		   	  Enddo	   
			  EndIf
      
	        TMP->(Dbskip())
	     Enddo
         DbSelectArea("TMP")
         DbCloseArea()

	   Endif    
	   
	Endif
	         
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ EXCLUI IMPORTACAO DO CONTROLE DE RECEBIMENTO (ZB8) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ZB8->(dbSetOrder(1))
	ZB8->(dbSeek(xFilial("ZB8")+cDoc+cSerie+cFornece+cLoja))
	While ZB8->(!EOF()) .AND. ZB8->(ZB8_DOC+ZB8_SERIE+ZB8_FORNEC+ZB8_LOJA)==cDoc+cSerie+cFornece+cLoja
		RecLock("ZB8",.F.)
			ZB8->(dbDelete())
		MsUnlock("ZB8")
		
		ZB8->(DBSKIP())
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ EXCLUI IMPORTACAO DO CONTROLE DE DIVERGENCIAS (ZDE) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ZDE->(dbSetOrder(2))
	ZDE->(dbSeek(xFilial("ZDE")+cDoc+cSerie+cFornece+cLoja))
	While ZDE->(!EOF()) .AND. ZDE->(ZDE_DOC+ZDE_SERIE+ZDE_FORNEC+ZDE_LOJA)==cDoc+cSerie+cFornece+cLoja
		RecLock("ZDE",.F.)
			ZDE->(dbDelete())
		MsUnlock("ZDE")
		
		ZDE->(DBSKIP())
	EndDo
	
	/**
	 * EXCLUI O DEBITO
	 */
	DbSelectArea("ZA8")
	DbSetOrder(2) //FILIAL + DOC + SERIE
	If DbSeek(xFilial("ZA8")+cDoc+cSerie)
		RecLock("ZA8",.F.)
			ZA8->(DbDelete())
		MsUnLock("ZA8")
	EndIf
Return(.F.)
