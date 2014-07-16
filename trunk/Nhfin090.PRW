
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHFIN090  ºAutor  ³Marcos R. Roquitski º Data ³  30/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclui Adiantamento de Viagens.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

user function Nhfin090()

  // area atual
  local aArea := getArea()
  
  // titulo do cadastro
  private cCadastro := "Adiatamento(s)"

  // funções
  private aRotina := { {"Pesquisar", "AxPesqui", 0, 1}  ,; // botao pesquisar
                       {"Visualizar", "AxVisual", 0, 2} ,; // botao visualizar
                       {"Incluir", "AxInclui", 0, 3}    ,; // botao incluir
                       {"Imprime", "U_Adt090i", 0, 4}    ,; // Imprime adiantamento
                       {"Excluir", "U_Adt014Del", 0, 5} } ; // botao excluir


  // função de deleção dos registros
  private cDelFunc := "U_Adt014Del()"
  
  // abre o browse com os dados
  dbSelectArea("ZZ3")
  ZZ3->(dbSetOrder(1))
  ZZ3->(dbGoTop())

  // abre o browse
  mBrowse( 006, 001, 022, 075, "ZZ3", nil, nil, nil, nil, nil, nil )
  
  // restaura a area
  restArea(aArea)

return nil


User Function Adt014Del()

If MsgBox("Confirma exclusao do Adiantamento? ","Exclui adiantamento","YESNO")

	If ZZ3->ZZ3_CP == "X" 
	
			If ZZ3->ZZ3_GEROUAC == "N"

				If SE2->(dbSeek(xFilial("SE2")+"ADT"+ZZ3->ZZ3_NUM+"A"))
			
					If SE2->E2_BAIXA <> Ctod(Space(08))
							Alert("Titulo com baixa, favor cancelar baixa para exclusao!")						
							Return
					Endif

					DbSelectArea("SE2")
					Reclock("SE2",.F.)   
					SE2->(DbDelete())			
					MsUnlock("SE2")

					DbSelectArea("ZZ3")
					Reclock("ZZ3",.F.)
					ZZ3->(DbDelete())
					MsUnlock("ZZ3")

      	Else

					DbSelectArea("ZZ3")
					Reclock("ZZ3",.F.)
					ZZ3->(DbDelete())
					MsUnlock("ZZ3")

					Alert("Nao encontrado no Contas a pagar verifique! Excluido o adiantamento")						  

				Endif

			Else									
					Alert("Verifique o acerto do Adiantamento!")						  
			Endif

	Else
	
		DbSelectArea("ZZ3")
		Reclock("ZZ3",.F.)
		ZZ3->(DbDeleted())
		MsUnlock("ZZ3")
		Alert("Adiantamento excluido!")						  
  
  Endif

Endif

Return

//
User Function Adt090i()

SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC")
SetPrvt("CNORMAL,LPRIMEIRO,CQUERY,")

cSavCur1  := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont    := "";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem    := 0
tamanho   := "P"
limite    := 220	
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "Adiantamento de Viagem"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "SRA"
nTipo     := 0
nomeprog  := "NHFIN090"
cPerg     := ""
nPag      := 1
M_PAG     := 1 
tot01     := 0 
tot02     := 0 
tot03     := 0 
tot04     := 0 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= "NHFIN090"

SetPrint("ZZ3",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,,,tamanho)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

rptStatus({||Imprime()},"Imprimindo...")

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


Static Function Imprime()
Local lRet      := .t.
Local _cProjeto := ''
Local _cCusto2  := ''
Local _cCusto   := ''
Local _nVlrzz4  := 0

Cabec1 := "               A D I A N T A M E N T O   D E   V I A G E M"
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

If ZZ3->ZZ3_MOTIVO == '1'
	If ZZ6->(Dbseek(xFilial("ZZ6")+ZZ3->ZZ3_CODPRJ )) 
		_cProjeto := ZZ3->ZZ3_CODPRJ + ' - ' + ZZ6->ZZ6_DESCRI
		If CTT->(Dbseek(xFilial("CTT")+ZZ6->ZZ6_CCUSTO )) 
			_cCusto2 := ZZ6->ZZ6_CCUSTO + ' - ' + CTT->CTT_DESC01
		Endif	
	Endif						
Endif

If CTT->(Dbseek(xFilial("CTT")+ZZ3->ZZ3_CC )) 
	_cCusto := ZZ6->ZZ6_CCUSTO + ' - ' + CTT->CTT_DESC01
Endif	

If ZZ3->ZZ3_MOEDA == '1'
	_cMoeda := 'REAL'
Elseif ZZ3->ZZ3_MOEDA == '2'
	_cMoeda := 'U$ VENDA'
Elseif ZZ3->ZZ3_MOEDA == '4'
	_cMoeda := 'EURO VENDA'
Elseif ZZ3->ZZ3_MOEDA == '6'
	_cMoeda := 'U$ COMPRA'
Elseif ZZ3->ZZ3_MOEDA == '7'
	_cMoeda := 'EURO COMPRA'
Elseif ZZ3->ZZ3_MOEDA == '8'
	_cMoeda := 'YEN VENDA'
Elseif ZZ3->ZZ3_MOEDA == '9'
	_cMoeda := 'U$ COMPRA'
Endif
_nTaxa := IIF(ZZ3->ZZ3_TAXA==0,1,ZZ3->ZZ3_TAXA)
//

	If Prow() > 56
		nPag := nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif

	@ Prow() + 1, 000 Psay 'Adiantamento: ' + ZZ3->ZZ3_NUM 
	@ Prow()    , 060 Psay '  Banco: ' + ZZ3->ZZ3_BANCO

	@ Prow() + 1, 000 Psay 'Colaborador : ' + ZZ3->ZZ3_MATR + ' ' + ZZ3->ZZ3_NOME
	@ Prow()    , 060 Psay 'Agencia: ' + ZZ3->ZZ3_AGENCI
	
	@ Prow() + 1, 000 Psay 'C. de Custo : ' + _cCusto
	@ Prow()    , 060 Psay '   Conta: ' + ZZ3->ZZ3_CONTA
	
	@ Prow() + 2, 000 Psay 'Periodo     : ' + Dtoc(ZZ3->ZZ3_DATADE) + ' ate ' + Dtoc(ZZ3->ZZ3_DATAAT)
	
	@ Prow() + 2, 000 Psay 'Atividade   : ' + ZZ3->ZZ3_OBS 

	@ Prow() + 2, 000 Psay 'Projeto     : ' + _cProjeto
	@ Prow() + 1, 000 Psay 'C.Custo     : ' + _cCusto2
	
	@ Prow() + 2, 000 Psay 'Vlr Adt.    : ' + Transform(ZZ3->ZZ3_VALOR,"@E 999,999,999.99") 
	@ Prow()    , 000 Psay 'Vlr Adt.    : ' + Transform(ZZ3->ZZ3_VALOR,"@E 999,999,999.99")
		
	@ Prow() + 1, 000 Psay 'Moeda       : ' + _cMoeda      	
	@ Prow() + 1, 000 Psay 'Taxa        : ' + Transform(ZZ3->ZZ3_TAXA,"@E 999,999,999.99")
	@ Prow() + 2, 000 Psay 'Ata em enexo: ' + IIF(ZZ3->ZZ3_ATA=="S","SIM","NAO")

	@ Prow() + 1, 000  Psay __PrtThinLine()


@ Prow() + 5,010  Psay '__________________________        ______________________'
@ Prow() + 1,010  Psay '     Financeiro                         Solicitante     '


Return

