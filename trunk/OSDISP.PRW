/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±±ºPrograma  ³ OSDISP   ºAutor  ³ João Felipe da Rosa º Data ³ 06/05/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CLASSE OSDISP - OS DE DISPOSITIVOS                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - MANUTENCAO DE ATIVOS                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß                                         
*/

#include "msobjects.ch"
#INCLUDE "protheus.ch"

Class OSDisp 

	Var cOrdem   as Character     //Numero da Ordem de Servico
	Var cTipo    as Character     //Tipo da OS ( 	)
	Var cCC      as Character     //Centro de Custo da OS - deve ser o mesmo CCusto do Dispositivo
	Var cCTrab   as Character     //Centro de Trabalho da OS - deve ser o mesmo CTrab do Dispositivo
	Var dDatIni  as Date          //Data da abertura da OS
	Var dDatFim  as Date          //Data da abertura da OS
	Var cHorIni  as Character     //Hora da OS
	Var cHorFim  as Character     //Hora da OS
	Var cResp    as Character     //Matricula do responsavel pela Ordem de Servico
	Var cNomResp as Character     //Nome do Responsavel pela Ordem de Servico
	Var cDisp    as Character     //Dispositivo para o qual a OS foi aberta
	Var cLetra   as Character     //Letra do dispositivo
	Var cDesDisp as Character     //Descricao do dispositivo
	Var cOp      as Character     //Op para a qual a OS foi aberta
	Var cStsDis  as Character     /*Status do dispositivo  (1-Disp. Parado e Retirado, 
	                                                        2-Disp. Isolado alguma posição (trabalhando deficiente
	                                                        3-Disp. Isolado por completo hidraulicamente, mecanicamente ou via programa
	                                                        4-Existe problema em disp. E manutenção mecanica (deve ser aberta ordem de serviço) */
	Var cCodBem  as Character     //Nome da máquina onde o dispositivo é utilizado
	Var cDescBem as Character     //Descricao da máquina 
	Var cStsBem  as Character     //Status do bem (1-Parada, 2-Deficiente)
	Var cDesc    as Character     //Descricao da OS (1-Problemas com Dispositivos,2-Problemas de manutencao mecanica e dispositivo)
	Var cProblem as Character     //Descricao do problema do dispositivo
	Var cCRaiz   as Character     //Causa Raiz do problema
	Var cSolucao as Character     //Solucao da os do dispositivo
	Var cTermino as Character     //Termino (S/N)
 	Var cFResp   as Character     //Responsavel pelo encerramento da Os
 	Var cNomFRes as Character     //Nome do responsavel pelo encerramento da Os
	Var dDtAprv  as Date          //Data da aprovacao
	Var cHrAprv  as Character     //Hora da aprovacao
	Var cAprv    as Character     //Matricula do aprovador
	Var cNomAprv as Character     //Nome do aprovador
	Var cRelato  as Character     //numero do relatorio de aprovacao
	Var cAprvd   as Character     //OS aprovada (S/N)
	Var cConRel  as Character     //Contém relatório 3d? (S/N)

	Method New() Constructor
	Method Tela(nParam)
	Method Valida()
	Method Inclui()
	Method Exclui()
	Method ValCC()
	Method ValDisp()
	Method ValLetra()
	Method ValCTrab()		
	Method ValResp()
	Method ValFResp()
	Method ValBem()
	Method Insumo()
	Method Final()
	Method Aprova()
	Method ValAprv()
	Method GrvAprv()
	Method Reabre() 
	Method Email()
	Method Altera()
			
EndClass
                                   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CONSTRUTOR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method New(cOrdem) Class OSDisp

	If Empty(cOrdem)
	
		::cOrdem   := GetSxENum("ZBO","ZBO_ORDEM")
	    ::cTipo    := ""
	    ::cCC      := Space(6)
	    ::cCTrab   := Space(6)
	    ::dDatIni  := Date()
	    ::cHorIni  := Substr(Time(),1,5)
	    ::dDatFim  := CtoD("  /  /  ")
	    ::cHorFim  := Space(5)
	    ::cResp    := Space(6)
	    ::cNomResp := ""
	    ::cDisp    := Space(15)
	    ::cLetra   := Space(1)
	    ::cDesDisp := ""
	    ::cOp      := ""
	    ::cStsDis  := ""
	    ::cCodBem  := Space(15)
	    ::cDescBem := ""
	    ::cStsBem  := ""
	    ::cDesc    := ""
	    ::cProblem := ""//Space(200)
	    ::cCRaiz   := Space(100)
	    ::cSolucao := ""//Space(200)
	    ::cTermino := "N"
	    ::cFResp   := Space(06)
	    ::cNomFRes := ""
		::dDtAprv  := CtoD("  /  /  ")
		::cHrAprv  := ""
		::cAprv    := Space(06)
		::cNomAprv := ""
		::cRelato  := Space(15)
		::cAprvd   := "N"
		::cConRel  := "N"

	Else
		
		::cOrdem   := ZBO->ZBO_ORDEM
	    ::cTipo    := ZBO->ZBO_TIPO
	    ::cCC      := ZBO->ZBO_CC
	    ::cCTrab   := ZBO->ZBO_CTRAB
	    ::dDatIni  := ZBO->ZBO_DATINI
	    ::cHorIni  := ZBO->ZBO_HORINI
	    ::dDatFim  := ZBO->ZBO_DATFIM
	    ::cHorFim  := ZBO->ZBO_HORFIM
	    ::cResp    := ZBO->ZBO_RESP
	    QAA->(DbSetORder(1)) // FILIAL + MAT
	    QAA->(DbSeek(xFilial("QAA")+ZBO->ZBO_RESP))
	    ::cNomResp := QAA->QAA_NOME
	    ::cDisp    := ZBO->ZBO_DISP
	    ::cLetra   := ZBO->ZBO_LETRA
	    ZBN->(DbSetOrder(1)) // FILIAL + DISP + LETRA
		ZBN->(DbSeek(xFilial("ZBO")+::cDisp+::cLetra))
		::cDesDisp := ZBN->ZBN_DESC
	    ::cOp      := ZBN->ZBN_OP
	    ::cStsDis  := ZBO->ZBO_STSDIS
	    ::cCodBem  := ZBO->ZBO_CODBEM
	    ST9->(DbSetOrder(1)) // FILIAL + CODBEM
	    ST9->(DbSeek(xFilial("ST9")+::cCodBem))
	    ::cDescBem := ST9->T9_NOME
	    ::cStsBem  := ZBO->ZBO_STSBEM
	    ::cDesc    := ZBO->ZBO_DESC
	    ::cProblem := ZBO->ZBO_PROBLE
	    ::cCRaiz   := ZBO->ZBO_CRAIZ
	    ::cSolucao := ZBO->ZBO_SOLUC
	    ::cTermino := ZBO->ZBO_TERMIN
	    ::cFResp   := ZBO->ZBO_FRESP
	    QAA->(DbGoTop())
	    QAA->(DbSeek(xFilial("QAA")+ZBO->ZBO_FRESP))
	    ::cNomFRes := QAA->QAA_NOME
		::dDtAprv  := ZBO->ZBO_DTAPRV
		::cHrAprv  := ZBO->ZBO_HRAPRV
		::cAprv    := ZBO->ZBO_APRV
		QAA->(DbGoTop())
		QAA->(DbSeek(xFilial("QAA")+::cAprv))
		::cNomAprv := QAA->QAA_NOME
		::cRelato  := ZBO->ZBO_RELATO
		::cAprvd   := ZBO->ZBO_APRVD
		::cConRel  := Iif(Empty(ZBO->ZBO_CONREL),"N",ZBO->ZBO_CONREL)
		
	EndIf

Return Self

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTA A TELA DO DISPOSITIVO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Tela(nParam) Class OsDisp
Local aSize       := MsAdvSize()
Local bOk         := {||}
Local bCanc       := {||oDlg:End()}
Local bEnchoice   := {||}
Private aTipo     := {"1=Corretiva","2=Preventiva","3=Programada","4=Corretiva Manut. Rotina","5=Melhoria"}
Private aStsDis   := {"",;
			          "1=Disp. Parado e retirado",;
                      "2=Disp. Isolado alguma posição (trabalhando deficiente)",;
                      "3=Disp Isolado por completo hidraulicamente, mecanicamente ou via programa",;
                      "4=Existe problema em disp. E manutenção mecânica (deve ser aberta ordem de serviço)",;
                      "5=Preventiva",;
                      "6=Vazamento",;
                      "7=Conferir geometria após colisão"}
                      
Private aStsBem   := {"","1=Parada","2=Deficiente"}
Private aDesc     := {"","1=Problemas com dispositivos",;
			 		  "2=Problemas com manutenção mecânica e disp.",;
			 		  "3=Realização de Preventiva."}
Private nPar      := nParam
Private cDescBem  := ""
Private cDescProd := ""
Private cDescCli  := ""
Private cDescClp  := ""

    oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
   
	If nPar==2     //visualizar
  	    Aadd(aStsBem,"3=Preventiva Agendada") 
	    bOk := {|| oDlg:End()}	    
	ElseIf nPar==3 //incluir
		bOk := {|| ::Inclui()}
		bCanc := {||RollBackSx8(), oDlg:End()}
	ElseIf nPar==4 //alterar
		Aadd(aStsBem,"3=Preventiva Agendada")
		bOk := {|| ::Altera()}		
	ElseIf nPar==5 //excluir
		Aadd(aStsBem,"3=Preventiva Agendada")
		bOk := {|| ::Exclui()}		
	ElseIf nPar==6 //Finalizar
		Aadd(aStsBem,"3=Preventiva Agendada")
		bOk := {|| ::Final()}				
		If ::cTermino=="S"
			Alert("O.S. já finalizada!")
			Return .F.
		EndIf
		
	EndIf
	
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}
			
	oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Ordem de Serviço - Dispositivo",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
                                                                              
	//ESTA CAIXA CRIA A BARRA DE ROLAGEM PARA TELAS COM RESOLUCAO 800X600 OU MENOR
	oSBox1 := TScrollBox():New(oDlg,0,0,(aSize[6]/2),(aSize[5]/2),.T.,.T.,.T.)

	oSay1 := TSay():New(20,10,{||"O.S."},oSBox1,,,,,,.T.,,)
	oSay2 := TSay():New(20,50,{||::cOrdem},oSBox1,,oFont1,,,,.T.,,)

	oSay2 := TSay():New(20,130,{||"Tipo"},oSBox1,,,,,,.T.,,)
	oCombo1 := TComboBox():New(18,150,{|u| if(Pcount() > 0,::cTipo := u,::cTipo)},;
		aTipo,50,20,oSBox1,,{||},,,,.T.,,,,{|| nPar==3 .or. nPar==4},,,,,"::cTipo")

	oSay3 := TSay():New(20,225,{||"C.Custo"},oSBox1,,,,,,.T.,,)
	oGet2 := tGet():New(18,250,{|u| if(Pcount() > 0, ::cCC := u,::cCC)},oSBox1,40,8,"@!",{||::ValCC()},;
		,,,,,.T.,,,{||.F.},,nPar!=3 .Or. nPar!=4,,,,"CTT","::cCC")

	oSay4 := TSay():New(32,10,{||"Cód. Dispositivo"},oSBox1,,,,,,.T.,CLR_HBLUE,)
	oGet3 := tGet():New(30,50,{|u| if(Pcount() > 0, ::cDisp := u,::cDisp)},oSBox1,70,8,"@!",{||::ValDisp()},;
		,,,,,.T.,,,{|| nPar==3 .Or. nPar==4},,,,,,"ZBN","::cDisp")
	oGet4 := tGet():New(30,122,{|u| if(Pcount() > 0, ::cLetra := u,::cLetra)},oSBox1,15,8,"@!",{||::ValLetra()},;
		,,,,,.T.,,,{|| .T.},,nPar==3,,,,,"::cLetra")
	oGet5 := tGet():New(30,140,{|u| if(Pcount() > 0, ::cDesDisp := u,::cDesDisp)},oSBox1,180,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"::cDesDisp")

	oSay2 := TSay():New(44,10,{||"Status Disp."},oSBox1,,,,,,.T.,CLR_HBLUE,)
	oCombo2 := TComboBox():New(42,50,{|u| if(Pcount() > 0,::cStsDis := u,::cStsDis)},;
		aStsDis,250,20,oSBox1,,{||},,,,.T.,,,,{|| nPar==3 .Or. nPar==4},,,,,"::cStsDis")

	oSay5 := TSay():New(56,10,{||"Op"},oSBox1,,,,,,.T.,,)
	oGet6 := tGet():New(54,50,{|u| if(Pcount() > 0, ::cOp := u,::cOp)},oSBox1,40,8,"@!",/*valid*/,;
		,,,,,.T.,,,{||nPar==3 .Or. nPar==4},,,,,,,"::cOp")

	oSay6 := TSay():New(56,130,{||"C.Trabalho"},oSBox1,,,,,,.T.,,)
	oGet7 := tGet():New(54,170,{|u| if(Pcount() > 0, ::cCTrab := u,::cCTrab)},oSBox1,40,8,"@!",{||::ValCTrab()},;
		,,,,,.T.,,,{||.F.},,,,,,"SHB","::cCTrab")

    oSay7 := TSay():New(68,10,{||"Data Inicial"},oSBox1,,,,,,.T.,,)
	oGet8 := tGet():New(66,50,{|u| if(Pcount() > 0, ::dDatIni := u,::dDatIni)},oSBox1,50,8,"99/99/99",/*valid*/,;
		,,,,,.T.,,,{||(nPar==3 .Or. nPar==4) .and. Substr(::cTipo,1,1)=="3"},,,,,,,"::dDatIni")
		
    oSay8 := TSay():New(68,130,{||"Hora Inicial"},oSBox1,,,,,,.T.,,)
	oGet9 := tGet():New(66,170,{|u| if(Pcount() > 0, ::cHorIni := u,::cHorIni)},oSBox1,40,8,"@e 99:99",/*valid*/,;
		,,,,,.T.,,,{||(nPar==3 .Or. nPar==4) .and. Substr(::cTipo,1,1)=="3"},,,,,,,"::cHorIni")

    oSay9  := TSay():New(80,10,{||"Responsável"},oSBox1,,,,,,.T.,CLR_HBLUE,)
	oGet10 := tGet():New(78,50,{|u| if(Pcount() > 0, ::cResp := u,::cResp)},oSBox1,40,8,"@!",{||::ValResp()},;
		,,,,,.T.,,,{||nPar==3 .Or. nPar==4},,,,,,"QAA","::cResp")

	oGet11 := tGet():New(78,95,{|u| if(Pcount() > 0, ::cNomResp := u,::cNomResp)},oSBox1,180,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"::cNomResp")
			
	oSay10 := TSay():New(92,10,{||"Máquina"},oSBox1,,,,,,.T.,,)
	oGet12 := tGet():New(90,50,{|u| if(Pcount() > 0, ::cCodBem := u,::cCodBem)},oSBox1,70,8,"@!",{||::ValBem()},;
		,,,,,.T.,,,{||.F.},,,,,,"ST9","::cCodBem")
	oGet13 := tGet():New(90,125,{|u| if(Pcount() > 0, ::cDescBem := u,::cDescBem)},oSBox1,180,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"::cDescBem")

	oSay11  := TSay():New(104,10,{||"Status Máq."},oSBox1,,,,,,.T.,,)
	oCombo3 := TComboBox():New(102,50,{|u| if(Pcount() > 0,::cStsBem := u,::cStsBem)},;
		aStsBem,80,20,oSBox1,,{||},,,,.T.,,,,{|| nPar==3 .Or. nPar==4},,,,,"::cStsBem")

	oSay12  := TSay():New(116,10,{||"Descrição"},oSBox1,,,,,,.T.,,)
	oCombo4 := TComboBox():New(114,50,{|u| if(Pcount() > 0,::cDesc := u,::cDesc)},;
		aDesc,150,20,oSBox1,,{||},,,,.T.,,,,{|| nPar==3 .OR. nPar==4},,,,,"::cDesc")
		
	oSay13  := TSay():New(128,10,{||"Problema"},oSBox1,,,,,,.T.,CLR_HBLUE,)
	oMemo1  := tMultiget():New(126,50,{|u|if(Pcount()>0,::cProblem:=u,::cProblem)},;
	oSBox1,250,40,,,,,,.T.,,,{|| .T. },,,nPar==2 .or. nPar==5 )

	If nPar==6 .OR. nPar==2 //Finalizar ou Visualizar

	    oSay14  := TSay():New(170,10,{||"Resp. Final"},oSBox1,,,,,,.T.,CLR_HBLUE,)
		oGet14  := tGet():New(168,50,{|u| if(Pcount() > 0, ::cFResp := u,::cFResp)},oSBox1,40,8,"@!",{||::ValFResp()},;
			,,,,,.T.,,,{||nPar==6},,,,,,"QAA","::cFResp")

		oGet15 := tGet():New(168,95,{|u| if(Pcount() > 0, ::cNomFRes := u,::cNomFRes)},oSBox1,180,8,"@!",{||.T.},;
			,,,,,.T.,,,{||.F.},,,,,,,"::cNomFRes")

	    oSay15  := TSay():New(182,10,{||"Causa Raiz"},oSBox1,,,,,,.T.,CLR_HBLUE,)
		oGet16 := tGet():New(180,50,{|u| if(Pcount() > 0, ::cCRaiz := u,::cCRaiz)},oSBox1,250,8,"@!",{||.T.},;
			,,,,,.T.,,,{||nPar==6},,,,,,,"::cCRaiz")

		oSay17  := TSay():New(194,10,{||"Solução"},oSBox1,,,,,,.T.,CLR_HBLUE,)
		oMemo2  := tMultiget():New(192,50,{|u|if(Pcount()>0,::cSolucao:=u,::cSolucao)},;
		oSBox1,250,40,,,,,,.T.,,,{|| .T. },,,nPar==2 .or. nPar==5 )

	    oSay18  := TSay():New(236,215,{||"Cont. Relatório 3D"},oSBox1,,,,,,.T.,,)
		oCombo5 := TComboBox():New(234,260,{|u| if(Pcount() > 0,::cConRel := u,::cConRel)},;
			{"S=Sim","N=Não"},30,10,oSBox1,,{||},,,,.T.,,,,{|| nPar==6},,,,,"::cConRel")

	    oSay7 := TSay():New(236,10,{||"Data Final"},oSBox1,,,,,,.T.,CLR_HBLUE,)
		oGet8 := tGet():New(234,50,{|u| if(Pcount() > 0, ::dDatFim := u,::dDatFim)},oSBox1,40,8,"99/99/99",/*valid*/,;
			,,,,,.T.,,,{||nPar==6},,,,,,,"::dDatIni")
			
	    oSay8 := TSay():New(236,130,{||"Hora Final"},oSBox1,,,,,,.T.,CLR_HBLUE,)
		oGet9 := tGet():New(234,170,{|u| if(Pcount() > 0, ::cHorFim := u,::cHorfim)},oSBox1,40,8,"@e 99:99",/*valid*/,;
			,,,,,.T.,,,{||nPar==6},,,,,,,"::cHorFim")
	
	EndIf


	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return

Method Altera() Class OsDisp
	oDlg:End()
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CENTRO DE CUSTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValCC() Class OsDisp
	CTT->(DbSetOrder(1)) // FILIAL + CC
	CTT->(DbSeek(xFilial("CTT")+::cCC))
    If CTT->(!Found())
    	Alert("Centro de custo não encontrado!")
    	Return .F.
    EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O DISPOSITIVO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValDisp() Class OsDisp
	ZBN->(DbSetOrder(1)) // FILIAL + CODDISP + LETRA
	ZBN->(DbSeek(xFilial("ZBN")+::cDisp))
	If ZBN->(!Found())
		Alert("Dispositivo não encontrado")
		Return .F.
	EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O DISPOSITIVO E A LETRA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValLetra() Class OsDisp
Local aZBOArea
	ZBN->(DbSetOrder(1)) // FILIAL + CODDISP + LETRA
	ZBN->(DbSeek(xFilial("ZBN")+::cDisp+::cLetra))
	If ZBN->(!Found())
		Alert("Dispositivo / Letra não encontrado")
		Return .F.
	Else
		If AllTrim(ZBN->ZBN_ATIVO)!="S"
			Alert("Este Dispositivo não está ativo!")
			Return .F.
		Else 
		    
		    If nPar == 3  // Adicionado em 19/02/2013 - OS 046383
		    
			    aZBOArea := ZBO->(GetArea())
			  	ZBO->(DBSETORDER(2))
			  	ZBO->(DBSEEK(xFilial("ZBO") + ::cDisp + ::cLetra))      
		    

				If ZBO->(Found())       
					While ZBO->(!Eof()) .AND. ZBO->ZBO_DISP == ::cDisp .AND. ZBO->ZBO_LETRA == ::cLetra
						If ZBO_TERMIN == 'N'
							Alert("Já existe uma O.S. em aberto para este dispositivo!"+chr(13)+chr(10)+"O.S. "+ZBO->ZBO_ORDEM+" - Favor verificar! ")
							ZBO->(RestArea(aZBOArea))
							Return .F.
						EndIf
						ZBO->(DBSKIP())
					EndDo
				EndIf
				
				ZBO->(RestArea(aZBOArea))
				
		    EndIf
			
			::cDesDisp := ZBN->ZBN_DESC
			oGet5:Refresh()
			::cOp := ZBN->ZBN_OP
			oGet6:Refresh()
			::cCC := ZBN->ZBN_CC
			oGet2:Refresh()
			::cCTrab := ZBN->ZBN_CTRAB
			oGet7:Refresh()
			::cCodBem := ZBN->ZBN_CODBEM
			oGet12:Refresh()

		    ::ValBem() //traz a descricao do bem
			
		EndIf
	EndIf
Return .T.     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CENTRO DE TRABALHO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValCTrab() Class OsDisp
	SHB->(DbSetOrder(1)) // FILIAL + CENTRAB
	SHB->(DbSeek(xFilial("SHB")+::cCTrab))
	If SHB->(!Found())
		Alert("Centro de Trabalho não encontrado!")
		Return .F.
	EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O RESPONSAVEL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValResp() Class OsDisp
	QAA->(DbSetOrder(1)) //FILIAL + MAT
	QAA->(DbSeek(xFilial("QAA")+::cResp))
	If QAA->(!Found())
		Alert("Funcionário não encontrado!")
		Return .F.
	Else
		::cNomResp := QAA->QAA_NOME
		oGet11:Refresh()
	EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O RESPONSAVEL PELO FECHAMENTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValFResp() Class OsDisp
	QAA->(DbSetOrder(1)) //FILIAL + MAT
	QAA->(DbSeek(xFilial("QAA")+::cFResp))
	If QAA->(!Found())
		Alert("Funcionário não encontrado!")
		Return .F.
	Else
		::cNomFRes := QAA->QAA_NOME
		oGet15:Refresh()
	EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O BEM ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValBem() Class OsDisp
    ST9->(DbSetOrder(1)) // FILIAL + CODBEM
    ST9->(DbSeek(xFilial("ST9")+::cCodBem))
    If ST9->(!Found())
    	Alert("Bem não encontrado!")
    	Return .F.
	Else
		::cDescBem := ST9->T9_NOME
		oGet13:Refresh()
    EndIf
Return .T.
          
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A OS DE DISPOSITIVO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Valida() Class OsDisp
	
	If Empty(::cDisp) .or. Empty(::cLetra)
		Alert("Dispositivo ou letra devem ser informados!")
		Return .F.
	EndIf

	If Empty(::cStsDis)
		Alert("Status do dispositivo não informado!")
		Return .F.
	EndIf

	If Empty(::cResp)
		Alert("Responsável não informado!")
		Return .F.
	EndIf                                                         
	
	If Empty(::cProblem)
		Alert("Problema não informado!")
		Return .F.
	EndIf            
	
	If Empty(::cCodBem)
		Alert("A máquina deve ser informada na abertura da OS!")
		return .F.
	EndIf
	
	If Empty(::cCC)
		Alert("O Centro de Custo deve ser informado!")
		Return .F.
	EndIf
	
	If nPar==6//Finaliza
		
		If Empty(::dDatFim)
			Alert("Data final não informada!")
			Return .F.
		EndIf
		
		If Empty(::cHorFim)
			Alert("Hora final não informada!")
			Return .F.
		EndIf
		
		If ::dDatFim < ::dDatIni
			Alert("Data final não pode ser inferior a data inicial!")
			Return .F.
		EndIf
		
		If ::dDatFim==::dDatIni .AND. ::cHorFim < ::cHorIni
			Alert("Hora e data final não podem ser inferiores a data e hora inicial!")
			Return .F.
		EndIf

		If ::dDatFim > dDataBase
			Alert("Data final não pode ser superior a data atual!")
			Return .F.
		EndIf
		
		If Empty(::cFResp)
			Alert("Responsável pela Finalização não informado!")
			Return .F.
		EndIf
		
		If Empty(::cSolucao)
			Alert("Solucao não informada!")
			Return .F.
		EndIf
	
		If Empty(::cCRaiz)
			Alert("Causa raiz não informada!")
			Return .F.
		EndIf
		
		// Adicionado em 19/02/2013 - OS 46382		
		
		ZBP->(DBSETORDER(1))
		ZBP->(DBSEEK(xFilial("ZBP") + ::cOrdem)) 
		
		While ZBP->(!Eof()) .AND. ZBP->ZBP_ORDEM == ::cOrdem
					
			If ZBP->ZBP_DATINI > ::dDatFim .OR. ZBP->ZBP_DATFIM > ::dDatFim
			   Alert("Está O.S. tem insumos com data superior à esta data de fechamento, favor ajustar o insumo !")
			   Return .F.			   
			EndIf
			
			If ZBP->ZBP_DATFIM == ::dDatFim .OR. ZBP->ZBP_DATINI == ::dDatFim 
			   If ZBP->ZBP_HORFIM > ::cHorFim .OR. ZBP->ZBP_HORINI > ::cHorFim 
			   		Alert("Está O.S. tem insumos com horário superior ao horário de fechamento, favor ajustar o insumo !")
			   		Return .F.			   
			   EndIf
			EndIf
			
			ZBP->(DBSKIP())                                                   
			
		EndDo
		
		// -----------------------------------  
		
	EndIf
		
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿               
//³ INCLUI A OS DE DISPOSITIVO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Inclui() Class OsDisp
	
	If !::Valida()
		Return .F.
	EndIf
	
	RecLock("ZBO",.T.)
		ZBO->ZBO_FILIAL := xFilial("ZBO")
		ZBO->ZBO_ORDEM  := ::cOrdem
		ZBO->ZBO_TIPO   := ::cTipo
		ZBO->ZBO_CC     := ::cCC
		ZBO->ZBO_CTRAB  := ::cCTrab
		ZBO->ZBO_HORINI	:= ::cHorIni
		ZBO->ZBO_DATINI	:= ::dDatIni
		ZBO->ZBO_HORFIM	:= ::cHorFim
		ZBO->ZBO_DATFIM	:= ::dDatFim
		ZBO->ZBO_RESP	:= ::cResp
		ZBO->ZBO_DISP	:= ::cDisp
		ZBO->ZBO_LETRA	:= ::cLetra
		ZBO->ZBO_STSDIS	:= ::cStsDis
		ZBO->ZBO_CODBEM	:= ::cCodBem
		ZBO->ZBO_STSBEM	:= ::cStsBem
		ZBO->ZBO_DESC	:= ::cDesc
		ZBO->ZBO_CRAIZ	:= ::cCRaiz
		ZBO->ZBO_SOLUC	:= ::cSolucao
		ZBO->ZBO_PROBLE	:= ::cProblem
		ZBO->ZBO_TERMIN := ::cTermino
		ZBO->ZBO_FRESP  := ::cFResp
		ZBO->ZBO_DTAPRV := ::dDtAprv
		ZBO->ZBO_HRAPRV := ::cHrAprv
		ZBO->ZBO_APRV   := ::cAprv  
		ZBO->ZBO_RELATO := ::cRelato
		ZBO->ZBO_APRVD  := ::cAprvd
		ZBO->ZBO_CONREL := ::cConRel
	MsUnlock("ZBO")	 
	
	::Email("ABERTURA")

	ConfirmSX8()
	
	oDlg:End()
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EXCLUI A OS DE DISPOSITIVO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Exclui() Class OsDisp

	If !AllTrim(UPPER(cUserName))$"ALINEBM/SHIRLEYPS"
		Alert("Usuário sem permissão para excluir!")
		Return
	EndIf
	
	If MsgYesNo("Tem certeza de que deseja excluir a OS "+::cOrdem+" ?")
		//exclui a os
		RecLock("ZBO",.F.)
			ZBO->(DbDelete())
		MsUnlock("ZBO")
		
		//exclui os insumos
		ZBP->(DbSetOrdeR(1)) //ZBP_FILIAL+ZBP_ORDEM
		If ZBP->(DbSeek(xFilial("ZBP")+::cOrdem))
			While ZBP->(!Eof()) .AND. ZBP->ZBP_ORDEM==::cOrdem
				RecLock("ZBP",.F.)
					ZBP->(DbDelete())
				MsUnLock("ZBP")
				ZBP->(DbSkip())
		    EndDo
		EndIf
	EndIf

	oDlg:End()
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FINALIZA A OS DE DISPOSITIVO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Final() Class OsDisp

	If !::Valida()
		Return
	EndIf
	
	::cTermino := "S"
	
	RecLock("ZBO",.F.)
		ZBO->ZBO_DATFIM := ::dDatFim
		ZBO->ZBO_HORFIM := ::cHorFim
		ZBO->ZBO_TERMIN := ::cTermino
		ZBO->ZBO_CRAIZ  := ::cCRaiz
		ZBO->ZBO_SOLUC  := ::cSolucao
		ZBO->ZBO_FRESP  := ::cFResp
		ZBO->ZBO_CONREL := ::cConRel
	MsUnLock("ZBO")
	
	oDlg:End()

	::Email("FECHAMENTO")

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ APROVA A OS DE DISPOSITIVOS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Aprova() Class OsDisp
Local lAct := .F.
	
	If ::cTermino=="N"
		Alert("O.S. não está finalizada!")
		Return 
	EndIf
	
	If ::cAprvd=="N" .OR. EMPTY(::cAprvd)
		lAct := .T.
		::dDtAprv := Date()
		::cHrAprv := Time()
		::cAprv   := Space(06)
		::cRelato := Space(15)
	EndIf
		
	oDlg := MsDialog():New(0,0,152,560,"Aprovação da OS de Dispositivos",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	oSay1 := tSay():New(15,10,{||"Data"},oDlg,,,,,,.T.,,)
	oGet1 := tGet():New(13,50,{|u| if(Pcount() > 0, ::dDtAprv := u,::dDtAprv)},oDlg,40,8,"99/99/99",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"::dDtAprv")

	oSay2 := tSay():New(15,110,{||"Hora"},oDlg,,,,,,.T.,,)
	oGet2 := tGet():New(13,135,{|u| if(Pcount() > 0, ::cHrAprv := u,::cHrAprv)},oDlg,40,8,"99:99",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"::cHrAprv")

	oSay3 := tSay():New(27,10,{||"Aprovador"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet3 := tGet():New(25,50,{|u| if(Pcount() > 0, ::cAprv := u,::cAprv)},oDlg,40,8,"@!",{||::ValAprv()},;
		,,,,,.T.,,,{||nPar==8 .AND. lAct},,,,,,"QAA","::cAprv")

	oGet4 := tGet():New(25,95,{|u| if(Pcount() > 0, ::cNomAprv := u,::cNomAprv)},oDlg,180,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"::cNomAprv")

	oSay4 := tSay():New(39,10,{||"Relatório Nº"},oDlg,,,,,,.T.,Iif(::cConRel=="S",CLR_HBLUE,),)
	oGet5 := tGet():New(37,50,{|u| if(Pcount() > 0, ::cRelato := u,::cRelato)},oDlg,70,8,"@!",{||.T.},;
		,,,,,.T.,,,{||nPar==8 .AND. lAct},,,,,,,"::cRelato")

	oGroup := tGroup():New(54,05,56,275,,oDlg,,,.T.)

	oBtn1 := tButton():New(61,190,"Ok",oDlg,{||::GrvAprv()},40,10,,,,.T.)
	oBtn2 := tButton():New(61,235,"Cancelar",oDlg,{||oDlg:End()},40,10,,,,.T.)
	oDlg:Activate(,,,.T.,{||.T.},,{||})

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA E TRAZ O NOME DO APROVADOR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValAprv() Class OsDisp
	QAA->(DbSetOrder(1))
	QAA->(DbSeek(xFilial("QAA")+::cAprv))
	If QAA->(!Found())
		Alert("Funcionário não encontrado!")
		Return .F.
	Else
		::cNomAprv := QAA->QAA_NOME
		oGet4:Refresh()
	EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVA A APROVACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method GrvAprv() Class OsDisp

	If Empty(::cAprv)
		Alert("Aprovador não informado!")
		Return .F.
	EndIf
	
	If ::cAprvd=="S"
		Alert("Ordem de Serviço já aprovada!")
		Return
	EndIf
	
	If ::cConRel=="S" .AND. Empty(::cRelato)
		Alert("Informe o número do relatório!")
		Return
	EndIf
	
	::cAprvd := "S"
	
	RecLock("ZBO",.F.)
		ZBO->ZBO_APRV   := ::cAprv
		ZBO->ZBO_DTAPRV := ::dDtAprv
		ZBO->ZBO_HRAPRV := ::cHrAprv
		ZBO->ZBO_RELATO := ::cRelato
		ZBO->ZBO_APRVD  := ::cAprvd
	MsUnLock("ZBO")  
	
	oDlg:End()
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ REABRE A OS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Reabre() Class OsDisp

	If Alltrim(Upper(cUsername)) $ "ROMULODB/DOUGLASSD/JOAOFR/ALEXANDRERB/ADMIN" // Validação a pedido do Romulo - OS 46381
	
		If MsgYesNo("Tem certeza que deseja reabrir esta OS?")
		
			If ZBO->ZBO_APRVD=="S"
				Alert("OS já foi aprovada!")
				Return
			EndIf
			
			RecLock("ZBO",.F.)
				ZBO->ZBO_DATFIM := CtoD("  /  /  ")
				ZBO->ZBO_HORFIM := ""
				ZBO->ZBO_TERMIN := "N"
				ZBO->ZBO_CRAIZ  := ""
				ZBO->ZBO_SOLUC  := ""
				ZBO->ZBO_FRESP  := ""
				ZBO->ZBO_CONREL := "N"
			MsUnLock("ZBO")
		
		EndIf
		
	Else
	
		Alert("Usuário não pode reabrir OS! Favor entrar em contato com o coordenador responsável.")
		Return
	
	EndIf
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ENVIA EMAIL INFORMANDO DA ABERTURA DA OS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Email(cAcao) Class OsDisp
Local cMsg

	cMsg := '<html>'
	cMsg += '<body style="font-family:arial">'
	cMsg += '<p></p>'
	cMsg += '<table width="100%" border="1">'

	cMsg += '  <tr style="background:#ccc">'
	cMsg += '    <td colspan="4">'
	cMsg += '      '+cAcao+' DE ORDEM DE SERVIÇO'
	cMsg += '    </td>'
	cMsg += '  </tr>'
	
	cMsg += '  <tr>'
	cMsg += '    <td style="background:#abc">Número</td>'
	cMsg += '    <td>'+::cOrdem+'</td>'
	cMsg += '    <td style="background:#abc">Tipo</td>'
	cMsg += '    <td>'+aTipo[Val(::cTipo)]+'</td>'
	cMsg += '  </tr>'
	
	cMsg += '  <tr>'
	cMsg += '    <td style="background:#abc">C.Custo</td>'
	cMsg += '    <td>'+::cCC+'</td>'
	cMsg += '    <td style="background:#abc">Descrição</td>'
	CTT->(DbSetOrder(1))
	CTT->(DbSeek(xFilial("CTT")+::cCC))
	cMsg += '    <td>'+CTT->CTT_DESC01+'</td>'
	cMsg += '  </tr>'

	cMsg += '  <tr>'
	cMsg += '    <td style="background:#abc">Cód. Dispositivo</td>'
	cMsg += '    <td>'+::cDisp+' - '+::cLetra+'</td>'
	cMsg += '    <td style="background:#abc">Descrição</td>'
	cMsg += '    <td>'+::cDesDisp+'</td>'
	cMsg += '  </tr>'

	_n := aScan(aStsDis,{|x| Substr(x,1,1)==::cStsDis})
	_n := Iif(_n<>0,_n,1)
	
	cMsg += '  <tr>'
	cMsg += '    <td style="background:#abc">Status Dispositivo</td>'
	cMsg += '    <td colspan="3">'+aStsDis[_n]+'</td>'
	cMsg += '  </tr>'

	cMsg += '  <tr>'
	cMsg += '    <td style="background:#abc">Op</td>'
	cMsg += '    <td>'+::cOp+'</td>'
	cMsg += '    <td style="background:#abc">C.Trabalho</td>'
	cMsg += '    <td>'+::cCTrab+'</td>'
	cMsg += '  </tr>'

	cMsg += '  <tr>'
	cMsg += '    <td style="background:#abc">Data</td>'
	cMsg += '    <td>'+DtoC(::dDatIni)+'</td>'
	cMsg += '    <td style="background:#abc">Hora</td>'
	cMsg += '    <td>'+::cHorIni+'</td>'
	cMsg += '  </tr>'

	cMsg += '  <tr>'
	cMsg += '    <td style="background:#abc">Responsável</td>'
	cMsg += '    <td>'+::cResp+'</td>'
	cMsg += '    <td style="background:#abc">Nome</td>'
	cMsg += '    <td>'+::cNomResp+'</td>'
	cMsg += '  </tr>'

	cMsg += '  <tr>'
	cMsg += '    <td style="background:#abc">Máquina</td>'
	cMsg += '    <td>'+::cCodBem+'</td>'
	cMsg += '    <td style="background:#abc">Descrição</td>'
	cMsg += '    <td>'+::cDescBem+'</td>'
	cMsg += '  </tr>'

	_n := aScan(aStsBem,{|x| Substr(x,1,1)==::cStsBem})
	_n := Iif(_n<>0,_n,1)

	cMsg += '  <tr>'
	cMsg += '    <td style="background:#abc">Status da Máq.</td>'
	cMsg += '    <td>'+aStsBem[_n]+'</td>'

	_n := aScan(aDesc,{|x| Substr(x,1,1)==::cDesc})
	_n := Iif(_n<>0,_n,1)

	cMsg += '    <td style="background:#abc">Descrição</td>'
	cMsg += '    <td>'+aDesc[_n]+'</td>'
	cMsg += '  </tr>'

	cMsg += '  <tr>'
	cMsg += '    <td style="background:#abc">Problema</td>'
	cMsg += '    <td colspan="3">'+::cProblem+'</td>'
	cMsg += '  </tr>'
        
	if cAcao=='FECHAMENTO'
		cMsg += '  <tr>'
		cMsg += '    <td colspan="4" align="center" style="background:#ccc">FECHAMENTO</td>'
		cMsg += '  </tr>'
		cMsg += '  <tr>'
		cMsg += '    <td style="background:#abc">Resp. Fechamento</td>'
		cMsg += '    <td>'+::cFResp+'</td>'
		cMsg += '    <td style="background:#abc">Nome</td>'
		cMsg += '    <td>'+::cNomFRes+'</td>'
		cMsg += '  </tr>'
		cMsg += '  <tr>'
		cMsg += '    <td style="background:#abc">Solução</td>'
		cMsg += '    <td colspan="3">'+::cSolucao+'</td>'
		cMsg += '  </tr>'
	endif

	cMsg += '</table><br />'
	cMsg += '</body>'
	cMsg += '</html>

	//cTo := "ronaldor@whbusinagem.com.br;"
   //	cTo += "alinebm@whbusinagem.com.br;"
//	cTo := "fabiosr@whbusinagem.com.br;" // retirado pela OS 020720
	cTo := "rodrigoco@whbusinagem.com.br;"

	//-- OS Nº: 041238
	If ::cStsDis=="7"
		cTo += "claudiosa@whbbrasil.com.br;"
		cTo += "geraldof@whbusinagem.com.br;"
		cTo += "rogeriojs@whbbrasil.com.br;"
		cTo += "leonardojb@whbbrasil.com;"
		cTo += "clodoalders@whbusinagem.com.br;"
		cTo += "guilhermecm@whbbrasil.com.br;"
	Endif
	//--Fim OS 041238

	//-- OS Nº: 041356
	If Alltrim(::cCC)$"33003003"
		cTo += "romulodb@whbbrasil.com.br"
	Endif
	//-- Fim OS 041356
			
	If Upper(AllTrim(::cCTrab))$"FAB-01"
//		cTo += "edemirjs@whbusinagem.com.br;" //cancelado pela OS 003563
//		cTo += "fernandoej@whbbrasil.com.br;"
//		cTo += "edsontp@whbusinagem.com.br;"
		cTo += "antoniovg@whbusinagem.com.br;"
 //		cTo += "denilsonaa@whbusinagem.com.br;"
		cTo += "josefg@whbusinagem.com.br;"
		cTo += "leandrog@whbusinagem.com.br"
	ElseIf Upper(AllTrim(::cCTrab))$"FAB-03"
//		cTo += "edemirjs@whbusinagem.com.br;" //cancelado pela OS 003563
//		cTo += "fernandoej@whbbrasil.com.br;"  //funcionario demitido
		cTo += "antoniobb@whbusinagem.com.br;"
//		cTo += "julianagy@whbusinagem.com.br;"
		cTo += "reinaldo@whbusinagem.com.br;"
//		cTo += "felipelr@whbusinagem.com.br;"
		cTo += "gersonrs@whbusinagem.com.br;"
		cTo += "marciom@whbusinagem.com.br"
	EndIf
	
	oMail          := Email():New()
	oMail:cMsg     := cMsg
	oMail:cAssunto := "*** "+cAcao+" DE OS - "+::cOrdem+" ***"
	oMail:cTo      := cTo
	
	oMail:Envia()
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ INSUMODISP º Autor ³ João Felipe da Rosaº Data ³ 07/05/2009º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CLASSE INSUMODISP                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - MANUTENCAO DE ATIVOS                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Class InsumoDisp

	Var cOrdem  as Character //Numero da ordem de servico que o insumo pertence	
	Var cTipo   as Character //tipo do insumo (P=Produto, N=Mao de Obra)
	Var cCodigo as Character //codigo do insumo (matricula ou codigo do produto)
	Var cDesCod as Character //descricao do codigo do insumo
	Var nQuant  as Numeric   //quantidade (@e 9,999.99)
	Var dDatIni as Date      //data inicial do insumo
	Var cHorIni as Character //hora inicial da utilizacao do insumo
	Var dDatFim as Date 	 //data final da utilizacao do insumo
	Var cHorFim as Character //hora final da utilizacao do insumo
	Var cAguard as Character //aguarda? (S/N)
	Var cCausa  as Character //se aguarda==S, qual a causa do aguardo
	Var cOsFer  as Character //quando a causa for = 4, deve preencher a os da ferramentaria	
	Var cDesc   as Character //descricao do servico executado pela mao de obra
		
	Method New(cOrdem) Constructor
	Method Tela(nPar)
	Method ValCod()
	Method Valida()
	Method Inclui()
	Method Exclui()
	Method Altera()
	Method AltF3()	

EndClass

//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CONSTRUTOR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method New(cOrdem) Class InsumoDisp
	
	If Empty(cOrdem)
		::cOrdem  := ZBO->ZBO_ORDEM
		::cTipo   := Space(1)
		::cCodigo := Space(15)
		::cDesCod := ""
		::nQuant  := 0
		::dDatIni := CtoD("  /  /  ")
		::cHorIni := Space(5)
		::dDatFim := CtoD("  /  /  ")
		::cHorFim := Space(5)
		::cAguard := Space(1)
		::cCausa  := Space(1)
		::cOsFer  := Space(10)
		::cDesc   := ""
	Else
		::cOrdem  := ZBP->ZBP_ORDEM
		::cTipo   := ZBP->ZBP_TIPO
		::cCodigo := ZBP->ZBP_CODIGO
		If ::cTipo=="P"
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+::cCodigo))
			::cDesCod := SB1->B1_DESC
		ElseIf ::cTipo=="M"
			QAA->(DbSetOrder(1))
			QAA->(DbSeek(xFilial("QAA")+::cCodigo))
			::cDesCod := QAA->QAA_NOME
		EndIf
		::nQuant  := ZBP->ZBP_QUANT
		::dDatIni := ZBP->ZBP_DATINI
		::cHorIni := ZBP->ZBP_HORINI
		::dDatFim := ZBP->ZBP_DATFIM
		::cHorFim := ZBP->ZBP_HORFIM
		::cAguard := ZBP->ZBP_AGUARD
		::cCausa  := ZBP->ZBP_CAUSA
		::cOsFer  := ZBP->ZBP_OSFER
		::cDesc   := ZBP->ZBP_DESC
	EndIf
	
Return Self

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TELA PARA EXIBICAO DO INSUMO DA OS DE DISPOSITIVO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Tela(nPar) Class InsumoDisp
Local aTipo  := {"","P=Produto","M=Mao de Obra"}
Local aCausa := {"",  "1=Aguard. projeto",;
					  "2=Aguard. desenho interno",;
					  "3=Aguard. compra de mat.",;
                      "4=Aguard. peças encam. p/ Ferramentaria",;
                      "5=Aguard. liberação pela manut.",;
                      "6=Aguard. peças encam. p/ 3D",;
                      "7=Aguard. liberação por parte de:(Processo TRY-OUT)",;
                      "8=Aguard. liberação pela produção"}
Local bOk   := {||}

	//para OS finalizada somente eh permitido visualizar
	If ZBO->ZBO_TERMIN=="S" .and. nPar!=2
		Alert("O.S. já finalizada!")
		Return
	EndIf

	If nPar==2     //visualizar
		bOk   := {||oDlg:End()}
	ElseIf nPar==3 //incluir
		bOk   := {||::Inclui()} 
	ElseIf nPar==4 //alterar
		bOk := {||::Altera()}
	ElseIf nPar==5 //excluir
		bOk := {||::Exclui()}  
	EndIf

	oDlg  := MsDialog():New(0,0,354,600,"Lançamento de Insumo",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(10,10,{||"Tipo"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oCombo1 := TComboBox():New(8,50,{|u| if(Pcount() > 0,::cTipo := u,::cTipo)},;
		aTipo,50,20,oDlg,,{||::AltF3()},{||.T.},,,.T.,,,,{|| nPar==3 .Or. nPar==4},,,,,"::cTipo")

	oSay2 := TSay():New(22,10,{||"Código"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(20,50,{|u| if(Pcount() > 0, ::cCodigo := u,::cCodigo)},oDlg,70,8,"@!",{||::ValCod()},;
		,,,,,.T.,,,{||nPar==3 .Or. nPar==4},,,,,,"","::cCodigo")   
	oGet2 := tGet():New(20,125,{|u| if(Pcount() > 0, ::cDesCod := u,::cDesCod)},oDlg,150,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,"","::cDesCod")

	oSay3 := TSay():New(34,10,{||"Quant"},oDlg,,,,,,.T.,,)
	oGet3 := tGet():New(32,50,{|u| if(Pcount() > 0, ::nQuant := u,::nQuant)},oDlg,50,8,"@e 9,999.99",{||.T.},;
		,,,,,.T.,,,{||::cTipo=="P" .and. (nPar==3 .Or. nPar==4)},,,,,,"","::nQuant")
		
	oSay4 := TSay():New(46,10,{||"Data Inicial"},oDlg,,,,,,.T.,,)
	oGet4 := tGet():New(44,50,{|u| if(Pcount() > 0, ::dDatIni := u,::dDatIni)},oDlg,50,8,"99/99/99",{||.T.},;
		,,,,,.T.,,,{||::cTipo=="M" .AND. (nPar==3 .Or. nPar==4)},,,,,,"","::dDatIni")

	oSay5 := TSay():New(46,120,{||"Hora Inicial"},oDlg,,,,,,.T.,,)
	oGet5 := tGet():New(44,160,{|u| if(Pcount() > 0, ::cHorIni := u,::cHorIni)},oDlg,50,8,"99:99",{||.T.},;
		,,,,,.T.,,,{||::cTipo=="M" .AND. (nPar==3 .Or. nPar==4)},,,,,,"","::cHorIni")

	oSay6 := TSay():New(58,10,{||"Data Final"},oDlg,,,,,,.T.,,)
	oGet6 := tGet():New(56,50,{|u| if(Pcount() > 0, ::dDatFim := u,::dDatFim)},oDlg,50,8,"99/99/99",{||.T.},;
		,,,,,.T.,,,{||::cTipo=="M" .AND. (nPar==3 .Or. nPar==4)},,,,,,"","::dDatFim")

	oSay7 := TSay():New(58,120,{||"Hora Final"},oDlg,,,,,,.T.,,)
	oGet7 := tGet():New(56,160,{|u| if(Pcount() > 0, ::cHorFim := u,::cHorFim)},oDlg,50,8,"99:99",{||.T.},;
		,,,,,.T.,,,{||::cTipo=="M" .AND. (nPar==3 .Or. nPar==4)},,,,,,"","::cHorFim")

	oSay8 := TSay():New(70,10,{||"Aguarda"},oDlg,,,,,,.T.,,)
	oCombo2 := TComboBox():New(68,50,{|u| if(Pcount() > 0,::cAguard := u,::cAguard)},;
		{"S=Sim","N=Não"},50,20,oDlg,,{||.T.},{||.T.},,,.T.,,,,{||::cTipo=="M" .AND. (nPar==3 .Or. nPar==4)},,,,,"::cAguard")

	oSay9 := TSay():New(82,10,{||"Causa"},oDlg,,,,,,.T.,,)
	oCombo3 := TComboBox():New(80,50,{|u| if(Pcount() > 0,::cCausa := u,::cCausa)},;
		aCausa,150,20,oDlg,,{||.T.},{||.T.},,,.T.,,,,{||::cTipo=="M" .And. ::cAguard=="S" .AND. (nPar==3 .Or. nPar==4)},,,,,"::cCausa")

	oSay10 := TSay():New(94,10,{||"OS. Fer."},oDlg,,,,,,.T.,,)
	oGet8  := tGet():New(92,50,{|u| if(Pcount() > 0, ::cOsFer := u,::cOsFer)},oDlg,50,8,"@!",{||.T.},;
		,,,,,.T.,,,{||::cTipo=="M"  .And. ::cAguard=="S" .AND. Substr(::cCausa,1,1)=="4".AND. (nPar==3 .Or. nPar==4)},,,,,,"","::cOsFer")

	oSay11  := TSay():New(106,10,{||"Descrição"},oDlg,,,,,,.T.,,)
	oMemo1  := tMultiget():New(104,50,{|u|if(Pcount()>0,::cDesc:=u,::cDesc)},;
	oDlg,240,40,,,,,,.T.,,,{||::cTipo=="M"},,,nPar==2 .or. nPar==5)

	oGroup := tGroup():New(154,05,156,295,,oDlg,,,.T.)

	oBtn1 := tButton():New(162,230,"Ok",oDlg,bOk,30,10,,,,.T.)
	oBtn2 := tButton():New(162,265,"Cancelar",oDlg,{||oDlg:End()},30,10,,,,.T.)
	
	If nPar==4
		If Substr(::cTipo,1,1)=="P"
			oGet1:cF3 := "SB1"
		ElseIf Substr(::cTipo,1,1)=="M"
			oGet1:cF3 := "QAA"
		EndIf
		
		oGet1:Refresh()
	EndIf
	
	oDlg:Activate(,,,.T.,{||.T.},,)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ A DESCRICAO DO CODIGO DO INSUMO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValCod() Class InsumoDisp

	If ::cTipo=="P"
		SB1->(DbSetOrder(1))//filial + cod
		SB1->(DbSeek(xFilial("SB1")+::cCodigo))
		If SB1->(!Found())
			Alert("Produto não encontrado!")
			Return .F.
		Else
			::cDesCod := SB1->B1_DESC
			oGet2:Refresh()
		EndIf
	EndIf
	
	If ::cTipo=="M"
		QAA->(DbSetOrder(1))
		QAA->(DbSeek(xFilial("QAA")+::cCodigo))
		If QAA->(!Found())
			Alert("Funcionario não encontrado!")
			Return .F.
		Else
			::cDesCod := QAA->QAA_NOME
			oGet2:Refresh()
		EndIf
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ALTERA O F3 DO CAMPO CODIGO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method AltF3() Class InsumoDisp
	
	If Substr(::cTipo,1,1)=="P"
		::dDatIni := CtoD("  /  /  ")
		::cHorIni := Space(8)
		::dDatFim := CtoD("  /  /  ")
		::cHorFim := Space(8)
		::cAguard := "S"
		::cCausa  := ""
		::cCodigo := Space(15)
		oGet1:cF3 := "SB1"
	ElseIf Substr(::cTipo,1,1)=="M"
		::nQuant  := 0
		::cCodigo := Space(6)
		oGet1:cF3 := "QAA"
	EndIf
	
	oGet1:Refresh()
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O INSUMO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Valida() Class InsumoDisp

	If Empty(::cTipo)
		Alert("Informe o tipo do insumo!")
		Return .F.
	EndIf

	If Empty(::cCodigo)
		Alert("Informe o insumo!")
		Return .F.
	EndIf

	If ::cTipo=="P"
		If Empty(::nQuant)
			Alert("Informe a quantidade do insumo!")
			Return .F.
		EndIf
	EndIf
	
	If ::cTipo=="M"
	
		If Empty(::dDatIni)
			Alert("Informe a data inicial do insumo!")
			Return .F.
		EndIf
		
		If Empty(::dDatFim)
			Alert("Informe a data final do insumo!")
			Return .F.
		EndIf
	
		If Empty(::cHorIni)
			Alert("Informe a hora inicial do insumo!")
			Return .F.
		EndIf
	
		If Empty(::cHorFim)
			Alert("Informe a hora final do insumo!")
			Return .F.
		EndIf
	
		If ::dDatFim < ::dDatIni
			Alert("Data final não pode ser inferior a data inicial!")
			Return .F.
		EndIf
		
		If ::dDatFim==::dDatIni .AND. ::cHorFim < ::cHorIni
			Alert("Data e hora final não podem ser inferiores a data e hora inicial!")
			Return .F.
		EndIf
		
		If Substr(::cAguard,1,1)=="S"
			If Empty(::cCausa)
				Alert("Informe a causa do aguardo!")
				Return .F.
			EndIf
			
			If Substr(::cCausa,1,1)=="4" .AND. Empty(::cOSFer)
				Alert("Informe a OS da Ferramentaria!")
				Return .F.
			EndIf
		EndIf
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ INCLUI UM INSUMO NA OS DE DISPOSITIVO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Inclui() Class InsumoDisp
	
	If !::Valida()
		Return
	EndIf
	
	RecLock("ZBP",.T.)
		ZBP->ZBP_FILIAL := xFilial("ZBP")
		ZBP->ZBP_ORDEM  := ::cOrdem
		ZBP->ZBP_TIPO   := ::cTipo 
		ZBP->ZBP_CODIGO := ::cCodigo
		ZBP->ZBP_QUANT  := ::nQuant
		ZBP->ZBP_DATINI := ::dDatIni
		ZBP->ZBP_HORINI := ::cHorIni
		ZBP->ZBP_DATFIM := ::dDatFim
		ZBP->ZBP_HORFIM := ::cHorFim
		ZBP->ZBP_AGUARD := ::cAguard
		ZBP->ZBP_CAUSA  := ::cCausa
		ZBP->ZBP_OSFER  := ::cOsFer
		ZBP->ZBP_DESC   := ::cDesc
	MsUnlock("ZBP") 
	
	ConfirmSx8()
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ALTERA O INSUMO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Altera() Class InsumoDisp

	If !::Valida()
		Return
	EndIf
	
	RecLock("ZBP",.F.)
		ZBP->ZBP_TIPO   := ::cTipo 
		ZBP->ZBP_CODIGO := ::cCodigo
		ZBP->ZBP_QUANT  := ::nQuant
		ZBP->ZBP_DATINI := ::dDatIni
		ZBP->ZBP_HORINI := ::cHorIni
		ZBP->ZBP_DATFIM := ::dDatFim
		ZBP->ZBP_HORFIM := ::cHorFim
		ZBP->ZBP_AGUARD := ::cAguard
		ZBP->ZBP_CAUSA  := ::cCausa
		ZBP->ZBP_OSFER  := ::cOsFer
		ZBP->ZBP_DESC   := ::cDesc
	MsUnLock("ZBP")
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EXCLUI O INSUMO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Exclui() Class InsumoDisp
	
	If MsgYesNo("Tem certeza de que deseja excluir este insumo?")
		RecLock("ZBP",.F.)
			ZBP->(DbDelete())
		MsUnLock("ZBP")
	EndIf

	oDlg:End()
	
Return


