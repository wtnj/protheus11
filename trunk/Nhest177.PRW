
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST177  ºAutor  ³Felipe Ciconini     º Data ³  07/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela de visualização de Cadastro de Produto                 º±±
±±º          ³Chamado Nº 13610 (Mario Pietrzak)                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Estoque/Faturamento                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "protheus.ch"
#INCLUDE "colors.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

User Function NHEST177()

SetPrvt("cCADASTRO,aROTINA")
Private aFixos := {}
Private aRotina   := {}

cCadastro := 'Tabela de Pesos'

aFixos := {{"Código"         , "B1_COD"   	},;
		   {"Descrição"      , "B1_DESC"  	},;
		   {"Peças/Placa"	 , "B1_PPLACA"	},;
		   {"Liga"			 , "B1_LIGA"	},;
		   {"Moldes/Hora"	 , "B1_MOLDHR"  },;
		   {"Peso Liquido"	 , "B1_PESO"  	},;
		   {"Peso Bruto"	 , "B1_PESBRU"	},;
		   {"Peso Canais"	 , "B1_PECANAL"	},;
		   {"Peso Conjunto"	 , "B1_PECJTRO"	},;
		   {"Rendimento"	 , "B1_RMETAL"	},;
		   {"Filtro"		 , "B1_FILTRO"	},;
		   {"Ult Atualizacao", "B1_ULTATU"	}}

aRotina := {{ "Pesquisar"       ,"AxPesqui"     , 0 , 1},;
			{ "Atualizar"       ,"U_EST177(4)"  , 0 , 4}}

cCadastro := 'Tabela de Pesos'

mBrowse(,,,,"SB1",aFixos)							//aFixos = parâmetro para exibição de campos selecionados no Browse.

Return

//****************************************************************************************************************

User Function EST177(nParam)
Local 		bOk 			:= {||}
Local		bCanc			:= {||oDlg:End()}
Local		bEnchoice		:= {||}
Local		aButtons		:= {}

Private nPar 	 := nParam  
Private aSize    := MsAdvSize()
Private aObjects := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aPosObj  := MsObjSize( aInfo, aObjects, .T.)
Private aCols    := {}
Private aHeader  := {}

Private cProd := " "
Private cDesc := " "
Private nPLiq := 0
Private nPBru := 0
Private nPcPl := 0
Private nPCan := 0
Private nRend := 0
Private nPCon := 0
Private nFilt := 0
Private nPMach := 0
Private dData
Private nMdHr := 0
Private cLiga := Space(04)
Private cMach := ""
Private aMach := {"NÃO","SIM"}

If nPar == 4
	fCarrega()
	fAltera()
EndIf

Return

//****************************************************************************************************************

//****************************
//******CARREGA OS ITENS******
//****************************
Static Function fCarrega()

	cProd := SB1->B1_COD
	cDesc := SB1->B1_DESC
	nPLiq := SB1->B1_PESO
	nPBru := SB1->B1_PESBRU
	nPcPl := SB1->B1_PPLACA
	nPCan := SB1->B1_PECANAL
	nRend := SB1->B1_RMETAL
	nPCon := SB1->B1_PECJTRO
	nMdHr := SB1->B1_MOLDHR
	cLiga := SB1->B1_LIGA
	nFilt := SB1->B1_FILTRO
	
	SG1->(DbSelectArea(1))
	If SG1->(DbSeek(xFilial("SG1")+SB1->B1_COD))				//ADICIONANDO O PESO NO MACHO DO PRODUTO
		If SB1->(DbSeek(xFilial("SB1")+SG1->G1_COMP))
			cMach := "SIM"
			nPMach := SB1->B1_PESO
		Else
			cMach := "NÃO"
		EndIF
	EndIf
	SB1->(DbSeek(xFilial("SB1")+cProd))							//VOLTANDO PARA O PRODUTO ALTERADO 
		
Return

//****************************************************************************************************************

//******************
//******ALTERA******
//******************
Static Function fAltera()

	Define MsDialog oDlg From 0,0 To 260,365 Pixel Title "Atualização Tabela Engenharia"
	   //  V , H
	    @ 005,005 Say "Código:" 	  Size 030,08
	    @ 005,045 Say cProd			  Size 100,08
	    @ 015,005 Say "Descrição:"	  Size 030,08
	    @ 015,045 Say cDesc			  Size 150,08
	    
	    @ 030,005 Say "Peças/Placa"	  Size 030,08                                 //B1_PPLACA
	    @ 028,037 Get nPcPl			  Size 050,08 Picture "@E 999.99"
	    @ 030,095 Say "Peso Liquido"  Size 030,08                                 //B1_PESO
	    @ 028,130 Get nPLiq			  Size 050,08 Picture "@E 999.99"
	    @ 045,005 Say "Peso Canais"   Size 030,08                                 //B1_PECANAL
	    @ 043,037 Get nPCan			  Size 050,08 Picture "@E 999.99"
	    @ 045,095 Say "Peso Bruto"	  Size 030,08                                 //B1_PESBRU
	    @ 043,130 Get nPBru			  Size 050,08 Picture "@E 999.99"
	    @ 060,005 Say "Rendimento"	  Size 030,08                                 //B1_RMETAL
	    @ 058,037 Get nRend			  Size 050,08 Picture "@E 999.99"
	    @ 060,095 Say "Peso Conjunto" Size 050,08                                 //B1_PECJTRO
	    @ 058,130 Get nPCon			  Size 050,08 Picture "@E 999.99"
	    @ 075,005 Say "Macho"		  Size 030,08                                 //B1_MACHO
	    @ 073,037 ComboBox cMach	  Items aMach Size 25,08 Pixel Of oDlg
	    @ 075,095 Say "Moldes / Hora" Size 050,08                                 //B1_MOLDHR
	    @ 073,130 Get nMdHr			  Size 050,08 Picture "@E 999.99"
	    @ 090,005 Say "Liga"		  Size 030,08                                 //B1_LIGA
	    @ 088,037 Get cLiga			  Size 050,08 Picture "@!"
	    @ 090,095 Say "Filtro"		  Size 030,08								  //B1_FILTRO
	    @ 088,130 Get nFilt			  Size 050,08 Picture "@E 999.99"
	    @ 105,005 Say "Peso Macho"	  Size 050,08 								  //B1_PEMACH
	    @ 103,037 Get nPMach		  Size 050,08 Picture "@E 999.99"	When fValMach()
	    
		@ 115,113 Button "Atualizar"  Size 030,012 Action fGrava()
		@ 115,148 Button "Cancelar"   Size 030,012 Action oDlg:End()
		
	Activate MsDialog oDlg Center
	
Return

//****************************************************************************************************************

//*****************
//******GRAVA******
//*****************
Static Function fGrava()
	
	RecLock("SB1",.F.)
		SB1->B1_PPLACA	:= nPcPl 
		SB1->B1_PESO    := nPLiq
		SB1->B1_PECANAL := nPCan
		SB1->B1_PESBRU  := nPBru
		SB1->B1_RMETAL	:= nRend
		SB1->B1_PECJTRO	:= nPCon
		SB1->B1_MOLDHR	:= nMdHr
		SB1->B1_LIGA	:= cLiga
		SB1->B1_FILTRO	:= nFilt
		SB1->B1_ULTATU	:= Date()
	MsUnlock("SB1")
	
	SG1->(DbSelectArea(1))
	If SG1->(DbSeek(xFilial("SG1")+SB1->B1_COD))				//ADICIONANDO O PESO NO MACHO DO PRODUTO
		If SB1->(DbSeek(xFilial("SB1")+SG1->G1_COMP))
			RecLock("SB1",.F.)
				SB1->B1_PESO := nPMach
			MsUnlock("SB1")
		EndIF
	EndIf
	
	SB1->(DbSeek(xFilial("SB1")+cProd))							//VOLTANDO PARA O PRODUTO ALTERADO
	
	oDlg:End()

Return

//****************************************************************************************************************

//************************
//******VALIDA MACHO******
//************************
Static Function fValMach()
	
	If SubStr(cMach,1,1) == "N"
		Return .F.
	EndIf

Return .T.