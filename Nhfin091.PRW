/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHFIN091  ºAutor  ³Marcos R. Roquitski º Data ³  30/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atendimento do Adiantamento.                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

user function Nhfin091()

SetPrvt("CCADASTRO,AROTINA,CMARCA,LINVERTE,")                                                                

	// area atual
	Private cMarca,lInverte
	  
	// titulo do cadastro
	private cCadastro := "Atendimento dos Adiatamento(s)"

	// funções
	private aRotina := { {"Pesquisar", "AxPesqui", 0, 3}  ,; // botao pesquisar
                         {"Atender", "U_Ap015At", 0, 4} } // botao atende

	// chama browse para marcar
	DbSelectArea("ZZ3")
	cMarca   := GetMark()
	lInverte :=.F.
	Set Filter to (Empty(ZZ3->ZZ3_CP).AND. ZZ3->ZZ3_VALOR > 0)
	ZZ3->(DbGotop())
	
	MarkBrow("ZZ3","ZZ3_OK",,,.T.,GetMark())
	//MarkBrow("ZZ3","ZZ3_OK","ZZ3_CP == ' '",,lInverte,cMarca)
	Set Filter to    
	ZZ3->(DbGotop())

return nil


User Function Ap015At()  

	SetPrvt("_LFLAG,_CTIT,_NTAXA,_NVALOR,")

	Processa( {|| libera() } )

Return

// Libera adiantamentos
Static Function Libera()

	If !MsgBox ("Confirme liberaracao dos Adiantamento(s) !","Escolha","YESNO")
	   Return
	Endif

	ProcRegua(ZZ3->(RecCount()))

	ZZ3->(DbGoTop())
	_lFlag := .f.
	While ZZ3->(!Eof())
       // Condicao para tratamento dos registros marcados
      If Marked("ZZ3_OK") .And. Empty(ZZ3->ZZ3_CP) // Alteracao feita em 25/07/00
         // Marca os Registros apontados
         _lFlag := .t.
      Else
          _lFlag := .f.
      Endif

      // Se Passou pelo Marked processa
      If _lFlag
         // Gerar Contas a Pagar
         GeraCP()
      EndIf

      DbSelectArea("ZZ3")
      IncProc()
      ZZ3->(DbSkip())
	EndDo

	ZZ3->(DbGoTop())
	
Return


// Gera contas a pagar
Static Function GeraCP()

// Se a Moeda e diferente de real 1, perguntar qual a taxa da moeda 
// multiplicar pelo valor e gravar a taxa no ZZ3
	If ZZ3->ZZ3_MOEDA <> "1"

      If ZZ3->ZZ3_MOEDA == "2"
         _cTit := "Moeda 2"
      ElseIf ZZ3->ZZ3_MOEDA == "3"
         _cTit := "Moeda 3"
      ElseIf ZZ3->ZZ3_MOEDA == "4"
         _cTit := "Moeda 4"   
      Endif
      
      _nTaxa := 0.00
      @ 0,0 TO 125,156 DIALOG oDlg1 TITLE "Atualiza Taxa"
      @ 001,005 TO 055,072 Title _cTit      
      @ 025,013 Say "Taxa: "
      @ 025,030 Get _nTaxa Picture "@E 999.99"
      @ 040,010 BMPBUTTON TYPE 01 ACTION Grava(1)
      Activate Dialog oDlg1 Centered
	Else
      _nValor := ZZ3->ZZ3_VALOR
      _nTaxa := 0.00
      Grava(2)
	Endif

Return(nil)    


// Gravacao no SE2
Static Function Grava(_nPos)

	If ZZ3->ZZ3_MOEDA <> "1"
	   _nValor := ZZ3->ZZ3_VALOR * _nTaxa
	Endif

	RecLock("SE2",.t.)
	  SE2->E2_FILIAL  := xFilial("SE2")
	  SE2->E2_PREFIXO := "XX1"
	  SE2->E2_NUM     := ZZ3->ZZ3_NUM
	  SE2->E2_PARCELA := "A"
	  SE2->E2_TIPO    := "VL"
	  SE2->E2_NATUREZ := ZZ3->ZZ3_NATUREZ
	  SE2->E2_FORNECE := "999999"
	  SE2->E2_LOJA    := "01"
	  SE2->E2_NOMFOR  := "ADIANTAMENTO DE VIAGEM"
	  SE2->E2_EMISSAO := ZZ3->ZZ3_EMISSAO
	  SE2->E2_VENCTO  := dDataBase
	  SE2->E2_VENCREA := dDataBase
	  SE2->E2_VALOR   := _nValor
	  SE2->E2_EMIS1   := dDataBase
	  SE2->E2_HIST    := "PGTO/" + ZZ3->ZZ3_NUM + " P/" + ZZ3->ZZ3_NOME
	  SE2->E2_SALDO   := _nValor
	  SE2->E2_VENCORI := dDataBase
	  SE2->E2_MOEDA   := 1   // Verificar com Dercy
	  SE2->E2_RATEIO  := "N"
	  SE2->E2_VLCRUZ  := _nValor
	  SE2->E2_OCORREN := "01"
	  SE2->E2_ORIGEM  := ""
	  SE2->E2_FLUXO   := "S"
	  SE2->E2_DESDOBR := "N"
	MsUnLock("SE2")
	
	// Marcar como Gerado titulo no financeiro
	RecLock("ZZ3",.f.)
 	  ZZ3->ZZ3_CP     := "X"
 	  ZZ3->ZZ3_STATUS := "A"
	  ZZ3->ZZ3_TAXA := _nTaxa
	MsUnLock("ZZ3")

	If _nPos == 1
	   Close(oDlg1)
	Endif
	
Return
              
