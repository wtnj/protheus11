/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MS520VLD  ºAutor  ³Alexandre R. Bento  º Data ³ 06/10/06    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se foi gerado a ordem de liberação p/ esta nota   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³ Uso      ³ WHB Usinagem / Fundição                                    ³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
#INCLUDE 'RWMAKE.CH'
User Function MS520VLD()

Local lRet    := .T.
Local nRegSD2 := SD2->(Recno())  //Guarda posição do registro do SD2    
SZN->(DbSetOrder(1))//filial+doc		
SZM->(DbSetOrder(1))//filial+doc		
SD2->(DbSetOrder(3))
If SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.))
   If !Empty(SD2->D2_ORDLIB) .and. !alltrim(upper(cUserName))$"LUIZWJ/JOAOFR/ALEXANDRERB/MARCOSR"
      
      //-- chamado 032431
   	  //-- joaofr
   	  //-- 22/05/2012
   	  If SZM->(Dbseek(xFilial("SZM")+SD2->D2_ORDLIB))
	   	  Alert('A NF: '+SF2->F2_DOC+' Serie: '+SF2->F2_SERIE+' Cliente: '+SF2->F2_CLIENTE+'/'+SF2->F2_LOJA+' não será excluída pois possui Ordem de Liberação: '+SD2->D2_ORDLIB+ '!')
   		  Return .f.
      EndIf
      /*
      SZN->(Dbseek(xFilial("SZN")+SD2->D2_ORDLIB))
      While !SZN->(EOF()) .And. SZN->ZN_DOC == SD2->D2_ORDLIB // marcas todos os itens da ordem de liberação
	  
	  	 RecLock("SZN")
		    SZN->ZN_OBS := "EXCLUIDA" 	//Marca a ordem de liberaçao como excluida
	     MsUnlock("SZN")
	     SZN->(Dbskip())
      Enddo
	  Aviso("Atençäo","Esta Nota, Possui a Ordem de Liberação "+SD2->D2_ORDLIB+ " Que Vai Ser Marcada como Excluida pelo Sistema.",{"Ok"})
	  // lRet := .F.
	  */
      
      //-- fim chamado 032431
      	  
	Endif
EndIf
SD2->(Dbgoto(nRegSD2))//Retorna posição do registro do SD2

//-- OS Nº: 030990
//-- Autor: Joao Felipe da Rosa
//-- 27/04/2012

ZAF->(dbsetorder(2)) //ZAF_FILIAL+ZAF_DOC+ZAF_SERIE
If !ZAF->(dbSeek(xFilial('ZAF')+SF2->F2_DOC+SF2->F2_SERIE))
	Alert('Não existe Solicitação de Exclusão de NF para esta NF! Verifique!')
	If !alltrim(upper(cUserName))$"LUIZWJ/JOAOFR/ALEXANDRERB/MARCOSR"
		Return .F.
	ENDIF
Else
	RecLock('ZAF',.F.)
		ZAF->ZAF_STATUS := 'S'
	MsUnLock('ZAF')
Endif	

//-- Fim OS 030990

Return(lRet)
