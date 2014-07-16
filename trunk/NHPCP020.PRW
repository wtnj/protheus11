
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPCP020  ºAutor  ³João Felipe da Rosa º Data ³  23/07/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ORDEM DE SERVIÇO DE EMPILHADEIRAS                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP - FUNDIÇÃO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHPCP020()
                          
Private aRotina, cCadastro

cCadastro := "O.S. Empilhadeira"
aRotina   := {}
aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"     , 0 , 1})
aAdd(aRotina,{ "Visualizar"	    ,"U_PCP20(2)" 	, 0 , 2})
aAdd(aRotina,{ "Incluir"		,"U_PCP20(3)" 	, 0 , 3})
aAdd(aRotina,{ "Excluir"        ,"U_PCP20(5)"   , 0 , 4})
aAdd(aRotina,{ "Finalizar"      ,"U_PCP20(6)"   , 0 , 4})
aAdd(aRotina,{ "Legenda"        ,"U_PCP20LEG()" , 0 , 4})
aAdd(aRotina,{ "Imprimir"       ,"U_PCP20IMP()" , 0 , 4})
aAdd(aRotina,{ "Reabrir"        ,"U_PCP20(9)"   , 0 , 5})
aAdd(aRotina,{ "Insumos"        ,"U_PCP20(7)"   , 0 , 3})

mBrowse( 6, 1,22,75,"ZBX",,,,,,fCriaCor())

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PRINCIPAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
USER FUNCTION PCP20(nParam)
Local   aRotOld := {}
Private nPar    := nParam
Private oOsEmp

	If nPar==3 //incluir
		oOsEmp := OsEmp():New()  //nova os de empilhadeira
	Else //visualizar, alterar, excluir, finalizar, insumos, reabre
		oOsEmp := OsEmp():New(ZBX->ZBX_ORDEM) //carrega uma os de empilhadeira já existente
	EndIf
	
	If nPar==2 .Or. nPar==3 .Or. nPar==5 .Or. nPar==6
		oOsEmp:Tela(nPar)
	ElseIf nPar==7

		DbSelectArea("ZBZ")
		Set Filter To &("ZBZ->ZBZ_ORDEM == '"+ZBX->ZBX_ORDEM+"'")

	   	aRotOld := aClone(aRotina)
	   	
	   	cCadastro := "Insumos da O.S. de Empilhadeira"
		aRotina   := {}
		aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"     , 0 , 1})
		aAdd(aRotina,{ "Visualizar"	    ,"U_PCP20I(2)" 	, 0 , 2})
		aAdd(aRotina,{ "Incluir"		,"U_PCP20I(3)" 	, 0 , 3})
		aAdd(aRotina,{ "Alterar"		,"U_PCP20I(4)" 	, 0 , 4})
		aAdd(aRotina,{ "Excluir"		,"U_PCP20I(5)" 	, 0 , 5})
			
		mBrowse( 6, 1,22,75,"ZBZ",,,,,,)
		
		aRotina := aClone(aRotOld)

	ElseIf nPar==9 //Reabrir
		oOsEmp:Reabre()
	EndIf

RETURN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PRINCIPAL DO INSUMO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function PCP20I(nParam)
Local nPar := nParam

	If nPar==3 //incluir
		oInsumo := InsumoEmp():New()
	Else
		oInsumo := InsumoEmp():New(ZBX->ZBX_ORDEM)
	EndIf
	
	oInsumo:Tela(nPar)

Return

//ÚÄÄÄÄÄÄÄÄÄ¿
//³ LEGENDA ³
//ÀÄÄÄÄÄÄÄÄÄÙ
User Function PCP20LEG()
Local aLegenda := {{"BR_VERMELHO", OemToAnsi("Aberta")},;
                   {"BR_VERDE"   , OemToAnsi("Finalizada")}}

BrwLegenda(OemToAnsi("Ordem de Serviço de Empilhadeira"), "Legenda", aLegenda)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA A LEGENDA DO BROWSE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCriaCor()
Local aLegenda :=	{{"BR_VERMELHO", OemToAnsi("Aberta")},;
                     {"BR_VERDE"   , OemToAnsi("Finalizada")}}

Local uRetorno := {}
Aadd(uRetorno, { 'ZBX_TERMIN=="N"' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZBX_TERMIN=="S"' , aLegenda[2][1] } )

Return(uRetorno)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ IMPRIME O RELATORIO DA OS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function PCP20IMP()

	//instancia um novo objeto do tipo relatorio
	oRelato          := Relatorio():New()
	
	oRelato:cString  := "ZBX"
	oRelato:cPerg    := "PCP020"
	oRelato:cNomePrg := "NHPCP020"
	oRelato:wnrel    := oRelato:cNomePrg
	oRelato:cTamanho := "P"
	
	//descricao
	oRelato:cDesc1   := "Este relatório apresenta os detalhes"
	oRelato:cDesc2   := "da Ordem de Serviço de  Empilhadeira"
	oRelato:cDesc3   := ""
	
	//titulo
	oRelato:cTitulo  := " ORDEM DE SERVIÇO DE EMPILHADEIRA "
	
	//cabecalho
	oRelato:cCabec1  := ""
	
	oRelato:Run({||Imprime()})

Return  
                         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO DE IMPRESSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Imprime()
Local cTipo   := ""
Local aStsEmp := {"1=Parada","2=Deficiente"}
Local cStsEmp := ""

	oRelato:Cabec()
	
	@Prow()+1, 001 Psay "+------------------------------------------------------------------------------+"
	@Prow()+1, 001 Psay "| Ordem de Serviço de Empilhadeira: "+ZBX->ZBX_ORDEM
	@Prow()  , 080 Psay "|"
	@Prow()+1, 001 Psay "|------------------------------------------------------------------------------|"

	//Inicio e fim da Os
	@Prow()+1, 001 Psay "| Inicio: "+DtoC(ZBX->ZBX_DATINI)+"   "+Substr(ZBX->ZBX_HORINI,1,5)
	@Prow()  , 040 Psay "Fim: "+DtoC(ZBX->ZBX_DATFIM)+"   "+Substr(ZBX->ZBX_HORFIM,1,5)
	@Prow()  , 080 Psay "|"
	                                    
    Do Case
    	Case ZBX->ZBX_TIPO=="1"
    		cTipo := "Preventiva"
    	Case ZBX->ZBX_TIPO=="2"
    		cTipo := "Corretiva"
		Case ZBX->ZBX_TIPO=="3"
			cTipo := "Programada"
	EndCase

	//Tipo 1=preventiva, 2=corretiva, 3=programada
	@Prow()+1, 001 Psay "| Tipo: "+cTipo 
	@Prow()  , 080 Psay "|"

	@Prow()+1, 001 Psay "|--------------------------------Empilhadeira----------------------------------|"
	@Prow()+1, 001 Psay "| Código...: "+Alltrim(ZBX->ZBX_CODEMP)
	@Prow()  , 080 Psay "|"
			
    ST9->(dbSetOrder(1))
    ST9->(dbSeek(xFilial("ST9")+ZBX->ZBX_CODEMP))

	If ST9->(Found())
		//Descricao do empilhadeira
		@Prow()+1, 001 Psay "| Descrição: "+ALLTRIM(ST9->T9_NOME)
		@Prow()  , 080 Psay "|"
		
		//C.Custo da Empilhadeira da OS
		@Prow()+1, 001 Psay "| C.Custo..: "+ST9->T9_CCUSTO
	
		CTT->(DbSetOrder(1)) // FILIAL + CCUSTO
		CTT->(DbSeek(xFilial("CTT")+ST9->T9_CCUSTO))
		IF CTT->(Found())
			@Prow() , 025 Psay ALLTRIM(CTT->CTT_DESC01)
		EndIf
		@Prow()  , 080 Psay "|"
		
		//Centro de trabalho do empilhadeira e da OS
		@Prow()+1, 001 Psay "| C.Trab...: "+ST9->T9_CENTRAB
				
		SHB->(DbSetOrder(1))//filial + centrab
		SHB->(DbSeek(xFilial("SHB")+ST9->T9_CENTRAB))
		If SHB->(Found())
			@Prow()  , 025 Psay SHB->HB_NOME
		EndIf

		@Prow()  , 080 Psay "|"
	EndIf
	
	//Status do empilhadeira
	cStsEmp := aStsEmp[Val(ZBX->ZBX_STSEMP)]
	
	@Prow()+1, 001 Psay "| Status...: "+ Substr(cStsEmp,1,68)
	@Prow()  , 080 Psay "|"

	//Problema da OS
	@Prow()+1, 001 Psay "|------------------------------------------------------------------------------|"	
	@Prow()+1, 001 Psay "| Problema:                                                                    |"

	For x:=1 To MlCount(ZBX->ZBX_PROBLE,76)
	  	@Prow()+1, 001 Psay "| "+ MemoLine(ZBX->ZBX_PROBLE,76,x)
	Next
	@Prow()  , 080 Psay "|"

	//Descrição da OS
	@Prow()+1, 001 Psay "| Descrição:"+ Iif(ZBX->ZBX_DESC=="1","Mecânico",Iif(ZBX->ZBX_DESC=="2","Elétrico","Eletrônico"))
	@Prow()  , 080 Psay "|"

	//Responsavel pela abertura da OS
	@Prow()+1, 001 Psay "|------------------------------------------------------------------------------|"			
	@Prow()+1, 001 Psay "| Responsável: "+ZBX->ZBX_RESP
	                                           
	QAA->(DbSetOrder(1)) // FILIAL + RESPONSAVEL
	QAA->(DbSeek(xFilial("QAA")+ZBX->ZBX_RESP))
	IF QAA->(Found())
		@Prow()  , 025 Psay ALLTRIM(QAA->QAA_NOME)
	EndIf
	@Prow()  , 080 Psay "|"
	@Prow()+1, 001 Psay "|--------------------------------- APROVACOES ---------------------------------|"
	@Prow()+1, 001 Psay "|                                                                              |"
	@Prow()+1, 001 Psay "|                                                                              |" 
	@Prow()+1, 001 Psay "|___________________________                           ________________________|"
	@Prow()+1, 001 Psay "|  RESPONSÁVEL PELO SETOR                                 ENTREGA DO SERVIÇO   |"
	@Prow()+1, 001 Psay "|                                                                              |" 
	@Prow()+1, 001 Psay "| Data.......: ____/____/____                                                  |"
	@Prow()+1, 001 Psay "|                                                                              |"
	@Prow()+1, 001 Psay "+------------------------------------------------------------------------------+"
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±±ºPrograma  ³ OSEMP    ºAutor  ³ João Felipe da Rosa º Data ³ 23/07/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CLASSE OSEMP - OS DE EMPILHADEIRAS                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - MANUTENCAO DE ATIVOS                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "msobjects.ch"
#INCLUDE "protheus.ch"

Class OSEmp 

	Var cOrdem   as Character     //Numero da Ordem de Servico
	Var cTipo    as Character     //Tipo da OS {1-Corretiva,2-Preventiva,3-Programada}
	Var cCC      as Character     //Centro de Custo da OS - deve ser o mesmo CCusto do Empilhadeira
	Var cCTrab   as Character     //Centro de Trabalho da OS - deve ser o mesmo CTrab do Empilhadeira
	Var dDatIni  as Date          //Data da abertura da OS
	Var dDatFim  as Date          //Data da abertura da OS
	Var cHorIni  as Character     //Hora da OS
	Var cHorFim  as Character     //Hora da OS
	Var cResp    as Character     //Matricula do responsavel pela Ordem de Servico
	Var cNomResp as Character     //Nome do Responsavel pela Ordem de Servico
	Var cEmp     as Character     //Empilhadeira para o qual a OS foi aberta
	Var cDesEmp  as Character     //Descricao do empilhadeira
	Var cStsEmp  as Character     //Status do empilhadeira{}
	Var cDesc    as Character     //Descricao da OS {1-Mecânico,2-Elétrico,3-Eletrônico}
	Var cProblem as Character     //Descricao do problema da empilhadeira
	Var cSolucao as Character     //Solucao da os da empilhadeira
	Var cTermino as Character     //Termino (S/N)
 	Var cFResp   as Character     //Responsavel pelo encerramento da Os
 	Var cNomFRes as Character     //Nome do responsavel pelo encerramento da Os

	Method New() Constructor
	Method Tela(nParam)
	Method Valida()
	Method Inclui()
	Method Exclui()
	Method ValCC()
	Method ValEmp()
	Method ValCTrab()		
	Method ValResp()
	Method ValFResp()
	Method Insumo()
	Method Final()
	Method Reabre()
	Method Altera()
	
EndClass
                                   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CONSTRUTOR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method New(cOrdem) Class OSEmp

	If Empty(cOrdem)
	
		::cOrdem   := GetSxENum("ZBX","ZBX_ORDEM")
	    ::cTipo    := ""
	    ::cCC      := Space(6)
	    ::cCTrab   := Space(6)
	    ::dDatIni  := Date()
	    ::cHorIni  := Time()
	    ::dDatFim  := CtoD("  /  /  ")
	    ::cHorFim  := Space(5)
	    ::cResp    := Space(6)
	    ::cNomResp := ""
	    ::cEmp     := Space(15)
	    ::cDesEmp  := ""
	    ::cStsEmp  := ""
	    ::cDesc    := ""
	    ::cProblem := ""
	    ::cSolucao := ""
	    ::cTermino := "N"
	    ::cFResp   := Space(06)
	    ::cNomFRes := ""

	Else
		
		::cOrdem   := ZBX->ZBX_ORDEM
	    ::cTipo    := ZBX->ZBX_TIPO
	    ::cCC      := ZBX->ZBX_CC
	    ::cCTrab   := ZBX->ZBX_CTRAB
	    ::dDatIni  := ZBX->ZBX_DATINI
	    ::cHorIni  := ZBX->ZBX_HORINI
	    ::dDatFim  := ZBX->ZBX_DATFIM
	    ::cHorFim  := ZBX->ZBX_HORFIM
	    ::cResp    := ZBX->ZBX_RESP
	    QAA->(DbSetORder(1)) // FILIAL + MAT
	    QAA->(DbSeek(xFilial("QAA")+ZBX->ZBX_RESP))
	    ::cNomResp := QAA->QAA_NOME
	    ::cEmp     := ZBX->ZBX_CODEMP
	    ST9->(dbSetOrder(1)) // FILIAL + COD
		ST9->(dbSeek(xFilial("ZBX")+::cEmp))
		::cDesEmp  := ST9->T9_NOME
	    ::cStsEmp  := ZBX->ZBX_STSEMP
	    ::cDesc    := ZBX->ZBX_DESC
	    ::cProblem := ZBX->ZBX_PROBLE
	    ::cSolucao := ZBX->ZBX_SOLUC
	    ::cTermino := ZBX->ZBX_TERMIN
	    ::cFResp   := ZBX->ZBX_FRESP
	    QAA->(DbGoTop())
	    QAA->(DbSeek(xFilial("QAA")+ZBX->ZBX_FRESP))
	    ::cNomFRes := QAA->QAA_NOME
		
	EndIf

Return Self

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTA A TELA DA OS DE EMPILHADEIRA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Tela(nParam) Class OsEmp
Local aSize       := MsAdvSize()
Local bOk         := {||}
Local bCanc       := {||oDlg:End()}
Local bEnchoice   := {||}
Private aTipo     := {"1=Corretiva","2=Preventiva","3=Programada"}
Private aStsEmp   := {"1=Parada","2=Deficiente"}
                      
Private aDesc     := {"1=Mecânico","2=Elétrico","3=Eletrônico"}
Private nPar      := nParam

    oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
   
	If nPar==2     //visualizar 
	    bOk := {|| oDlg:End()}
	ElseIf nPar==3 //incluir
		bOk := {|| ::Inclui()}
		bCanc := {||RollBackSx8(), oDlg:End()}
	ElseIf nPar==4 //alterar
		bOk := {|| ::Altera()}
	ElseIf nPar==5 //excluir
		bOk := {|| ::Exclui()}
	ElseIf nPar==6 //Finalizar
		bOk := {|| ::Final()}
		
		If ::cTermino=="S"
			Alert("O.S. já finalizada!")
			Return .F.
		EndIf
		
	EndIf
	
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}
			
	oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Ordem de Serviço - Empilhadeira",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(20,10,{||"O.S."},oDlg,,,,,,.T.,,)
	oSay2 := TSay():New(20,50,{||::cOrdem},oDlg,,oFont1,,,,.T.,,)

	oSay2 := TSay():New(20,130,{||"Tipo"},oDlg,,,,,,.T.,,)
	oCombo1 := TComboBox():New(18,170,{|u| if(Pcount() > 0,::cTipo := u,::cTipo)},;
		aTipo,50,20,oDlg,,{||},,,,.T.,,,,{|| nPar==3 .Or. nPar==4},,,,,"::cTipo")

	oSay4 := TSay():New(32,10,{||"Empilhadeira"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet3 := tGet():New(30,50,{|u| if(Pcount() > 0, ::cEmp := u,::cEmp)},oDlg,70,8,"@!",{||::ValEmp()},;
		,,,,,.T.,,,{|| nPar==3},,,,,,"EM1","::cEmp")
		
	oGet5 := tGet():New(30,121,{|u| if(Pcount() > 0, ::cDesEmp := u,::cDesEmp)},oDlg,180,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"::cDesEmp")

	oSay3 := TSay():New(44,10,{||"C.Custo"},oDlg,,,,,,.T.,,)
	oGet2 := tGet():New(42,50,{|u| if(Pcount() > 0, ::cCC := u,::cCC)},oDlg,40,8,"@!",{||::ValCC()},;
		,,,,,.T.,,,{||.F.},,,,,,"CTT","::cCC")

	oSay6 := TSay():New(44,130,{||"C.Trabalho"},oDlg,,,,,,.T.,,)
	oGet7 := tGet():New(42,170,{|u| if(Pcount() > 0, ::cCTrab := u,::cCTrab)},oDlg,40,8,"@!",{||::ValCTrab()},;
		,,,,,.T.,,,{||.F.},,,,,,"SHB","::cCTrab")

	oSay2 := TSay():New(56,10,{||"Status Emp."},oDlg,,,,,,.T.,CLR_HBLUE,)
	oCombo2 := TComboBox():New(54,50,{|u| if(Pcount() > 0,::cStsEmp := u,::cStsEmp)},;
		aStsEmp,150,20,oDlg,,{||},,,,.T.,,,,{|| nPar==3 .Or. nPar==4},,,,,"::cStsEmp")

    oSay7 := TSay():New(68,10,{||"Data Inicial"},oDlg,,,,,,.T.,,)
	oGet8 := tGet():New(66,50,{|u| if(Pcount() > 0, ::dDatIni := u,::dDatIni)},oDlg,40,8,"99/99/99",/*valid*/,;
		,,,,,.T.,,,{||Substr(::cTipo,1,1)=="3"},,,,,,,"::dDatIni")
		
    oSay8 := TSay():New(68,130,{||"Hora Inicial"},oDlg,,,,,,.T.,,)
	oGet9 := tGet():New(66,170,{|u| if(Pcount() > 0, ::cHorIni := u,::cHorIni)},oDlg,40,8,"@e 99:99",/*valid*/,;
		,,,,,.T.,,,{||Substr(::cTipo,1,1)=="3"},,,,,,,"::cHorIni")

    oSay9  := TSay():New(80,10,{||"Responsável"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet10 := tGet():New(78,50,{|u| if(Pcount() > 0, ::cResp := u,::cResp)},oDlg,40,8,"@!",{||::ValResp()},;
		,,,,,.T.,,,{||nPar==3 .Or. nPar==4},,,,,,"QAA","::cResp")

	oGet11 := tGet():New(78,91,{|u| if(Pcount() > 0, ::cNomResp := u,::cNomResp)},oDlg,180,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"::cNomResp")

	oSay12  := TSay():New(92,10,{||"Descrição"},oDlg,,,,,,.T.,,)
	oCombo4 := TComboBox():New(90,50,{|u| if(Pcount() > 0,::cDesc := u,::cDesc)},;
		aDesc,150,20,oDlg,,{||},,,,.T.,,,,{|| nPar==3 .Or. nPar==4},,,,,"::cDesc")
		
	oSay13  := TSay():New(104,10,{||"Problema"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oMemo1  := tMultiget():New(102,50,{|u|if(Pcount()>0,::cProblem:=u,::cProblem)},;
	oDlg,250,40,,,,,,.T.,,,{|| nPar==3 .Or. nPar==4})

	If nPar==6 .OR. nPar==2 //Finalizar ou Visualizar

	    oSay14  := TSay():New(146,10,{||"Resp. Final"},oDlg,,,,,,.T.,CLR_HBLUE,)
		oGet14  := tGet():New(144,50,{|u| if(Pcount() > 0, ::cFResp := u,::cFResp)},oDlg,40,8,"@!",{||::ValFResp()},;
			,,,,,.T.,,,{||nPar==6},,,,,,"QAA","::cFResp")

		oGet15 := tGet():New(144,91,{|u| if(Pcount() > 0, ::cNomFRes := u,::cNomFRes)},oDlg,180,8,"@!",{||.T.},;
			,,,,,.T.,,,{||.F.},,,,,,,"::cNomFRes")

		oSay17  := TSay():New(158,10,{||"Solução"},oDlg,,,,,,.T.,CLR_HBLUE,)
		oMemo2  := tMultiget():New(156,50,{|u|if(Pcount()>0,::cSolucao:=u,::cSolucao)},;
		oDlg,250,40,,,,,,.T.,,,{|| nPar==6})

	    oSay7 := TSay():New(200,10,{||"Data Final"},oDlg,,,,,,.T.,CLR_HBLUE,)
		oGet8 := tGet():New(198,50,{|u| if(Pcount() > 0, ::dDatFim := u,::dDatFim)},oDlg,40,8,"99/99/99",/*valid*/,;
			,,,,,.T.,,,{||nPar==6},,,,,,,"::dDatIni")
			
	    oSay8 := TSay():New(200,130,{||"Hora Final"},oDlg,,,,,,.T.,CLR_HBLUE,)
		oGet9 := tGet():New(198,170,{|u| if(Pcount() > 0, ::cHorFim := u,::cHorfim)},oDlg,40,8,"@e 99:99",/*valid*/,;
			,,,,,.T.,,,{||nPar==6},,,,,,,"::cHorFim")
	
	EndIf

	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return

Method Altera() Class OsEmp
	oDlg:End()
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CENTRO DE CUSTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValCC() Class OsEmp
	CTT->(DbSetOrder(1)) // FILIAL + CC
	CTT->(DbSeek(xFilial("CTT")+::cCC))
    If CTT->(!Found())
    	Alert("Centro de custo não encontrado!")
    	Return .F.
    EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A EMPILHADEIRA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValEmp() Class OsEmp

	If !Substr(::cEmp,1,2)$"EP"
		Alert("Empilhadeira não encontrada!")
		Return .F.
	EndIf

	ST9->(dbSetOrder(1)) // FILIAL + CODBEM
	If ST9->(dbSeek(xFilial("ST9")+::cEmp))
		::cDesEmp := ST9->T9_NOME
		oGet5:Refresh()
		::cCC := ST9->T9_CCUSTO
		oGet2:Refresh()
		::cCTrab := ST9->T9_CENTRAB
		oGet7:Refresh()
	Else
		Alert("Empilhadeira não encontrada!")
		Return .F.
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CENTRO DE TRABALHO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValCTrab() Class OsEmp
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
Method ValResp() Class OsEmp
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
Method ValFResp() Class OsEmp
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
          
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A OS DE EMPILHADEIRA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Valida() Class OsEmp
	
	If Empty(::cEmp)
		Alert("Empilhadeira não informada!")
		Return .F.
	EndIf
	
	If Empty(::cStsEmp)
		Alert("Status da empilhadeira não informado!")
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
		
	EndIf
		
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ INCLUI A OS DE EMPILHADEIRA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Inclui() Class OsEmp
	
	If !::Valida()
		Return .F.
	EndIf
	
	RecLock("ZBX",.T.)
		ZBX->ZBX_FILIAL := xFilial("ZBX")
		ZBX->ZBX_ORDEM  := ::cOrdem
		ZBX->ZBX_TIPO   := ::cTipo
		ZBX->ZBX_CC     := ::cCC
		ZBX->ZBX_CTRAB  := ::cCTrab
		ZBX->ZBX_HORINI	:= ::cHorIni
		ZBX->ZBX_DATINI	:= ::dDatIni
		ZBX->ZBX_HORFIM	:= ::cHorFim
		ZBX->ZBX_DATFIM	:= ::dDatFim
		ZBX->ZBX_RESP	:= ::cResp
		ZBX->ZBX_CODEMP := ::cEmp
		ZBX->ZBX_STSEMP	:= ::cStsEmp
		ZBX->ZBX_DESC	:= ::cDesc
		ZBX->ZBX_SOLUC	:= ::cSolucao
		ZBX->ZBX_PROBLE	:= ::cProblem
		ZBX->ZBX_TERMIN := ::cTermino
		ZBX->ZBX_FRESP  := ::cFResp
	MsUnlock("ZBX")	 
	
	ConfirmSX8()
	
	oDlg:End()
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EXCLUI A OS DE EMPILHADEIRA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Exclui() Class OsEmp

	If MsgYesNo("Tem certeza de que deseja excluir a OS "+::cOrdem+" ?")
		//exclui a os
		RecLock("ZBX",.F.)
			ZBX->(DbDelete())
		MsUnlock("ZBX")
		
		//exclui os insumos
		ZBZ->(DbSetOrdeR(1)) //ZBZ_FILIAL+ZBZ_ORDEM
		If ZBZ->(DbSeek(xFilial("ZBZ")+::cOrdem))
			While ZBZ->(!Eof()) .AND. ZBZ->ZBZ_ORDEM==::cOrdem
				RecLock("ZBZ",.F.)
					ZBZ->(DbDelete())
				MsUnLock("ZBZ")
				ZBZ->(DbSkip())
		    EndDo
		EndIf
	EndIf

	oDlg:End()
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FINALIZA A OS DE EMPILHADEIRA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Final() Class OsEmp

	If !::Valida()
		Return
	EndIf
	
	::cTermino := "S"
	
	RecLock("ZBX",.F.)
		ZBX->ZBX_DATFIM := ::dDatFim
		ZBX->ZBX_HORFIM := ::cHorFim
		ZBX->ZBX_TERMIN := ::cTermino
		ZBX->ZBX_SOLUC  := ::cSolucao
		ZBX->ZBX_FRESP  := ::cFResp
	MsUnLock("ZBX")
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ REABRE A OS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Reabre() Class OsEmp
	
	If MsgYesNo("Tem certeza que deseja reabrir esta OS?")
		
		RecLock("ZBX",.F.)
			ZBX->ZBX_DATFIM := CtoD("  /  /  ")
			ZBX->ZBX_HORFIM := ""
			ZBX->ZBX_TERMIN := "N"
			ZBX->ZBX_SOLUC  := ""
			ZBX->ZBX_FRESP  := ""
		MsUnLock("ZBX")
	
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ INSUMOEMP  º Autor ³ João Felipe da Rosaº Data ³ 23/07/2009º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CLASSE INSUMOEMP                                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Class InsumoEmp

	Var cOrdem  as Character //Numero da ordem de servico que o insumo pertence	
	Var cTipo   as Character //tipo do insumo (P=Produto, N=Mao de Obra)
	Var cCodigo as Character //codigo do insumo (matricula ou codigo do produto)
	Var cDesCod as Character //descricao do codigo do insumo
	Var nQuant  as Numeric   //quantidade (@e 9,999.99)
	Var dDatIni as Date      //data inicial do insumo
	Var cHorIni as Character //hora inicial da utilizacao do insumo
	Var dDatFim as Date 	 //data final da utilizacao do insumo
	Var cHorFim as Character //hora final da utilizacao do insumo
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
Method New(cOrdem) Class InsumoEmp
	
	If Empty(cOrdem)
		::cOrdem  := ZBX->ZBX_ORDEM
		::cTipo   := Space(1)
		::cCodigo := Space(15)
		::cDesCod := ""
		::nQuant  := 0
		::dDatIni := CtoD("  /  /  ")
		::cHorIni := Space(5)
		::dDatFim := CtoD("  /  /  ")
		::cHorFim := Space(5)
		::cDesc   := ""
	Else
		::cOrdem  := ZBZ->ZBZ_ORDEM
		::cTipo   := ZBZ->ZBZ_TIPO
		::cCodigo := ZBZ->ZBZ_CODIGO
		If ::cTipo=="P"
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+::cCodigo))
			::cDesCod := SB1->B1_DESC
		ElseIf ::cTipo=="M"
			QAA->(DbSetOrder(1))
			QAA->(DbSeek(xFilial("QAA")+::cCodigo))
			::cDesCod := QAA->QAA_NOME
		EndIf
		::nQuant  := ZBZ->ZBZ_QUANT
		::dDatIni := ZBZ->ZBZ_DATINI
		::cHorIni := ZBZ->ZBZ_HORINI
		::dDatFim := ZBZ->ZBZ_DATFIM
		::cHorFim := ZBZ->ZBZ_HORFIM
		::cDesc   := ZBZ->ZBZ_DESC
	EndIf
	
Return Self

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TELA PARA EXIBICAO DO INSUMO DA OS DE EMPILHADEIRA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Tela(nPar) Class InsumoEmp
Local aTipo  := {"","P=Produto","M=Mao de Obra"}
Local bOk   := {||}

	//para OS finalizada somente eh permitido visualizar
	If ZBX->ZBX_TERMIN=="S" .and. nPar!=2
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

	oSay11  := TSay():New(106,10,{||"Descrição"},oDlg,,,,,,.T.,,)
	oMemo1  := tMultiget():New(104,50,{|u|if(Pcount()>0,::cDesc:=u,::cDesc)},;
	oDlg,240,40,,,,,,.T.,,,{||::cTipo=="M" .And. nPar==3 .Or. nPar==4})

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
Method ValCod() Class InsumoEmp

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
Method AltF3() Class InsumoEmp
	
	If Substr(::cTipo,1,1)=="P"
		::dDatIni := CtoD("  /  /  ")
		::cHorIni := Space(8)
		::dDatFim := CtoD("  /  /  ")
		::cHorFim := Space(8)
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
Method Valida() Class InsumoEmp

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
		
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ INCLUI UM INSUMO NA OS DE EMPILHADEIRA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Inclui() Class InsumoEmp
	
	If !::Valida()
		Return
	EndIf
	
	RecLock("ZBZ",.T.)
		ZBZ->ZBZ_FILIAL := xFilial("ZBZ")
		ZBZ->ZBZ_ORDEM  := ::cOrdem
		ZBZ->ZBZ_TIPO   := ::cTipo 
		ZBZ->ZBZ_CODIGO := ::cCodigo
		ZBZ->ZBZ_QUANT  := ::nQuant
		ZBZ->ZBZ_DATINI := ::dDatIni
		ZBZ->ZBZ_HORINI := ::cHorIni
		ZBZ->ZBZ_DATFIM := ::dDatFim
		ZBZ->ZBZ_HORFIM := ::cHorFim
		ZBZ->ZBZ_DESC   := ::cDesc
	MsUnlock("ZBZ") 
	
	ConfirmSx8()
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ALTERA O INSUMO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Altera() Class InsumoEmp

	If !::Valida()
		Return
	EndIf
	
	RecLock("ZBZ",.F.)
		ZBZ->ZBZ_TIPO   := ::cTipo 
		ZBZ->ZBZ_CODIGO := ::cCodigo
		ZBZ->ZBZ_QUANT  := ::nQuant
		ZBZ->ZBZ_DATINI := ::dDatIni
		ZBZ->ZBZ_HORINI := ::cHorIni
		ZBZ->ZBZ_DATFIM := ::dDatFim
		ZBZ->ZBZ_HORFIM := ::cHorFim
		ZBZ->ZBZ_DESC   := ::cDesc
	MsUnLock("ZBZ")
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EXCLUI O INSUMO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Exclui() Class InsumoEmp
	
	If MsgYesNo("Tem certeza de que deseja excluir este insumo?")
		RecLock("ZBZ",.F.)
			ZBZ->(DbDelete())
		MsUnLock("ZBZ")
	EndIf

	oDlg:End()
	
Return