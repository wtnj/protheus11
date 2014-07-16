
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHMNT042  �Autor  �Jo�o Felipe da Rosa � Data �  06/05/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     � ABERTURA DE OS DE DISPOSITIVOS                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP10 - MANUTENCAO DE ATIVOS                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NHMNT042()

Private aRotina, cCadastro

cCadastro := "O.S. Dispositivo"
aRotina   := {}
aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"     , 0 , 1})
aAdd(aRotina,{ "Visualizar"	    ,"U_MNT42(2)" 	, 0 , 2})
aAdd(aRotina,{ "Incluir"		,"U_MNT42(3)" 	, 0 , 3})
aAdd(aRotina,{ "Excluir"        ,"U_MNT42(5)"   , 0 , 4})
aAdd(aRotina,{ "Finalizar"      ,"U_MNT42(6)"   , 0 , 4})
aAdd(aRotina,{ "Aprovar"        ,"U_MNT42(8)"   , 0 , 4})
aAdd(aRotina,{ "Anexo"          ,"U_MNT42ANX()" , 0 , 4})
aAdd(aRotina,{ "Legenda"        ,"U_MNT42LEG()" , 0 , 4})
aAdd(aRotina,{ "Imprimir"       ,"U_MNT42IMP()" , 0 , 4})
aAdd(aRotina,{ "Reabrir"        ,"U_MNT42(9)"   , 0 , 5})
aAdd(aRotina,{ "Insumos"        ,"U_MNT42(7)"   , 0 , 3})

mBrowse( 6, 1,22,75,"ZBO",,,,,,fCriaCor())

Return

User Function MNT42ANX()
	If ZBO->ZBO_TERMIN!="S"
		MsDocument('ZBO',ZBO->(RECNO()), 4)
	Else
		Alert("OS j� est� finalizada!")
	EndIf
Return

//������������������Ŀ
//� FUNCAO PRINCIPAL �
//��������������������
USER FUNCTION MNT42(nParam)
Local   aRotOld := {}
Private nPar    := nParam
Private oOsDisp

	If nPar==3 //incluir
		
		If SM0->M0_CODIGO=='NH' //USINAGEM
			Alert('Somente permitido abrir OS de Dispositivos pela Fundicao!')
			Return .f.
		Endif
		
		oOsDisp := OsDisp():New()  //novo dispositivo
		
	Else //visualizar, alterar, excluir, finalizar, insumos
		oOsDisp := OsDisp():New(ZBO->ZBO_ORDEM) //carrega um dispositivo j� existente
	EndIf
	
	If nPar==2 .Or. nPar==3 .Or. nPar==5 .Or. nPar==6
		oOsDisp:Tela(nPar)
	ElseIf nPar==7

		DbSelectArea("ZBP")
		Set Filter To &("ZBP->ZBP_ORDEM == '"+ZBO->ZBO_ORDEM+"'")

	   	aRotOld := aClone(aRotina)
	   	
	   	cCadastro := "Insumos da O.S. de Dispositivo"
		aRotina   := {}
		aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"     , 0 , 1})
		aAdd(aRotina,{ "Visualizar"	    ,"U_MNT42I(2)" 	, 0 , 2})
		aAdd(aRotina,{ "Incluir"		,"U_MNT42I(3)" 	, 0 , 3})
		aAdd(aRotina,{ "Alterar"		,"U_MNT42I(4)" 	, 0 , 4})
		aAdd(aRotina,{ "Excluir"		,"U_MNT42I(5)" 	, 0 , 5})
			
		mBrowse( 6, 1,22,75,"ZBP",,,,,,)
		
		aRotina := aClone(aRotOld)

	ElseIf nPar==8 //Aprovar
		oOsDisp:Aprova()
	ElseIf nPar==9 //Reabrir
		oOsDisp:Reabre()
	EndIf

RETURN

//����������������������������Ŀ
//� FUNCAO PRINCIPAL DO INSUMO �
//������������������������������
User Function MNT42I(nParam)
Local nPar := nParam

	If nPar==3 //incluir
		oInsumo := InsumoDisp():New()
	Else
		oInsumo := InsumoDisp():New(ZBO->ZBO_ORDEM)
	EndIf
	
	oInsumo:Tela(nPar)

Return 

//���������Ŀ
//� LEGENDA �
//�����������
User Function MNT42LEG()

Local aLegenda :=	{ {"BR_PRETO"   , OemToAnsi("Parado e retirado")  },;
                      {"BR_VERMELHO", OemToAnsi("Existe algum problema em disp. E manuten��o mec�nica (deve ser aberta ordem de servi�o)") },;
                      {"BR_VERDE"   , OemToAnsi("Terminado")}}

BrwLegenda(OemToAnsi("Ordem de Servi�o de Dispositivos"), "Legenda", aLegenda)

Return  

//��������������������������Ŀ
//� CRIA A LEGENDA DO BROWSE �
//����������������������������
Static Function fCriaCor()

Local aLegenda :=	{ {"BR_PRETO"   , OemToAnsi("Parado e retirado")  },;
                      {"BR_VERMELHO", OemToAnsi("Existe algum problema em disp. E manuten��o mec�nica (deve ser aberta ordem de servi�o)") },;
                      {"BR_VERDE"   , OemToAnsi("Terminado")}}

Local uRetorno := {}
Aadd(uRetorno, { 'ZBO_TERMIN=="N" .AND. ZBO_STSDISP == "1" ' , aLegenda[1][1] } )//PRETO
Aadd(uRetorno, { 'ZBO_TERMIN=="N" .AND. ZBO_STSDISP <> "1" ' , aLegenda[2][1] } )//VERMELHO
Aadd(uRetorno, { 'ZBO_TERMIN=="S"' 							 , aLegenda[3][1] } )//VERDE

Return(uRetorno)

//���������������������������Ŀ
//� IMPRIME O RELATORIO DA OS �
//�����������������������������
User Function MNT42IMP()

	//instancia um novo objeto do tipo relatorio
	oRelato          := Relatorio():New()
	
	oRelato:cString  := "ZBO"
	oRelato:cPerg    := "MNT042"
	oRelato:cNomePrg := "NHMNT042"
	oRelato:wnrel    := oRelato:cNomePrg
	oRelato:cTamanho := "P"
	
	//descricao
	oRelato:cDesc1   := "Este relat�rio apresenta os detalhes"
	oRelato:cDesc2   := "da Ordem de Servi�o de  Dispositivos"
	oRelato:cDesc3   := ""
	
	//titulo
	oRelato:cTitulo  := " ORDEM DE SERVI�O DE DISPOSITIVOS "
	
	//cabecalho
	oRelato:cCabec1  := ""
	
	oRelato:Run({||Imprime()})

Return  
                         
//���������������������Ŀ
//� FUNCAO DE IMPRESSAO �
//�����������������������
Static Function Imprime()
Local cTipo
Local aStsDis := {"Disp. Parado e retirado",;
                  "Disp. Isolado alguma posi��o (trabalhando deficiente)",;
                  "Disp Isolado por completo hidraulicamente, mecanicamente ou via programa",;
                  "Existe problema em disp. E manuten��o mec�nica (deve ser aberta ordem de servi�o)",;
                  "Vazamento",;
                  "Conferir geometria ap�s colis�o"}

Local cStsDis

	oRelato:Cabec()
	
	@Prow()+1, 001 Psay "+------------------------------------------------------------------------------+"
	@Prow()+1, 001 Psay "| Ordem de Servi�o de Dispositivos: "+ZBO->ZBO_ORDEM
	@Prow()  , 080 Psay "|"
	@Prow()+1, 001 Psay "|------------------------------------------------------------------------------|"

	//Inicio e fim da Os
	@Prow()+1, 001 Psay "| Inicio: "+DtoC(ZBO->ZBO_DATINI)+"   "+Substr(ZBO->ZBO_HORINI,1,5)
	@Prow()  , 040 Psay "Fim: "+DtoC(ZBO->ZBO_DATFIM)+"   "+Substr(ZBO->ZBO_HORFIM,1,5)
	@Prow()  , 080 Psay "|"

	cTipo := ""
	                                    
    Do Case
    	Case ZBO->ZBO_TIPO=="1"
    		cTipo := "Preventiva"
    	Case ZBO->ZBO_TIPO=="2"
    		cTipo := "Corretiva"
		Case ZBO->ZBO_TIPO=="3"
			cTipo := "Programada"
		Case ZBO->ZBO_TIPO=="4"
			cTipo := "Corretiva Manut. Rotina"
		Case ZBO->ZBO_TIPO=="5"
			cTipo := "Melhoria"
	EndCase

	//Tipo 1=preventiva, 2=corretiva, 3=programada
	@Prow()+1, 001 Psay "| Tipo: "+cTipo 
	@Prow()  , 080 Psay "|"

	@Prow()+1, 001 Psay "|--------------------------------Dispositivo-----------------------------------|"
	@Prow()+1, 001 Psay "| C�digo...: "+Alltrim(ZBO->ZBO_DISP)+" - "+ZBO->ZBO_LETRA
	@Prow()  , 080 Psay "|"
		
	ZBN->(DbSetOrder(1))//filial + cod + letra
	ZBN->(DbSeek(xFilial("ZBN")+ZBO->ZBO_DISP+ZBO->ZBO_LETRA))
	If ZBN->(Found())
		//Descricao do dispositivo
		@Prow()+1, 001 Psay "| Descri��o: "+ALLTRIM(ZBN->ZBN_DESC)
		@Prow()  , 080 Psay "|"
		
		//C.Custo do Dispositivo e da OS
		@Prow()+1, 001 Psay "| C.Custo..: "+ZBN->ZBN_CC
	
		CTT->(DbSetOrder(1)) // FILIAL + CCUSTO
		CTT->(DbSeek(xFilial("CTT")+ZBN->ZBN_CC))
		IF CTT->(Found())
			@Prow() , 025 Psay ALLTRIM(CTT->CTT_DESC01)
		EndIf
		@Prow()  , 080 Psay "|"
		
		//Centro de trabalho do dispositivo e da OS
		@Prow()+1, 001 Psay "| C.Trab...: "+ZBN->ZBN_CTRAB
				
		SHB->(DbSetOrder(1))//filial + centrab
		SHB->(DbSeek(xFilial("SHB")+ZBN->ZBN_CTRAB))
		If SHB->(Found())
			@Prow()  , 025 Psay SHB->HB_NOME
		EndIf

		@Prow()  , 080 Psay "|"

		@Prow()+1, 001 Psay "| OP.......: "+ZBN->ZBN_OP
		@Prow()  , 080 Psay "|"
	EndIf
	
	//Status do dispositivo
	cStsDis := aStsDis[Val(ZBO->ZBO_STSDIS)]
	
	@Prow()+1, 001 Psay "| Status...: "+ Substr(cStsDis,1,68)
	@Prow()  , 080 Psay "|"

	If Len(cStsDis) > 68
		@Prow()+1, 001 Psay "| "+ Substr(cStsDis,69,76)
		@Prow()  , 080 Psay "|"
	EndIf

	//Bem
	@Prow()+1, 001 Psay "|--------------------------------M�quina---------------------------------------|"	
	@Prow()+1, 001 Psay "| Descri��o: "+ALLTRIM(ZBO->ZBO_CODBEM)
	
	ST9->(DbSetOrder(1)) // FILIAL + CODBEM
	ST9->(DbSeek(xFilial("ST9")+ZBO->ZBO_CODBEM))
	IF ST9->(Found())
	  	@Prow()  , 030 Psay Alltrim(ST9->T9_NOME)
	EndIF
	
	@Prow()  , 080 Psay "|"

	//Status do bem
	@Prow()+1, 001 Psay "| Status: "+Iif(ZBO->ZBO_STSBEM=="1","Parada","Deficiente")
	@Prow()  , 080 Psay "|"	
	
	//Problema da OS
	@Prow()+1, 001 Psay "|------------------------------------------------------------------------------|"	
	@Prow()+1, 001 Psay "| Problema:                                                                    |"

	For x:=1 To MlCount(ZBO->ZBO_PROBLE,76)
	  	@Prow()+1, 001 Psay "| "+ MemoLine(ZBO->ZBO_PROBLE,76,x)
	Next
	@Prow()  , 080 Psay "|"

	//Descri��o da OS
	@Prow()+1, 001 Psay "| Descri��o:"+ Iif(ZBO->ZBO_DESC=="1","Problemas com dispositivos","Problemas com manuten��o mec�nica e dispositivos")
	@Prow()  , 080 Psay "|"

	//Responsavel pela abertura da OS
	@Prow()+1, 001 Psay "|------------------------------------------------------------------------------|"			
	@Prow()+1, 001 Psay "| Respons�vel: "+ZBO->ZBO_RESP
	                                           
	QAA->(DbSetOrder(1)) // FILIAL + RESPONSAVEL
	QAA->(DbSeek(xFilial("QAA")+ZBO->ZBO_RESP))
	IF QAA->(Found())
		@Prow()  , 025 Psay ALLTRIM(QAA->QAA_NOME)
	EndIf
	@Prow()  , 080 Psay "|"
	@Prow()+1, 001 Psay "|--------------------------------- APROVACOES ---------------------------------|"
	@Prow()+1, 001 Psay "|                                                                              |"
	@Prow()+1, 001 Psay "|                                                                              |" 
	@Prow()+1, 001 Psay "|___________________________                           ________________________|"
	@Prow()+1, 001 Psay "|  RESPONS�VEL PELO SETOR                                 ENTREGA DO SERVI�O   |"
	@Prow()+1, 001 Psay "|                                                                              |" 
	@Prow()+1, 001 Psay "| Data.......: ____/____/____                                                  |"
	@Prow()+1, 001 Psay "|                                                                              |"
	@Prow()+1, 001 Psay "+------------------------------------------------------------------------------+"
	
Return
