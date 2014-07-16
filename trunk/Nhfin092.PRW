/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHFIN092  ºAutor  ³Marcos R. Roquitski º Data ³  30/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro do acerto de adiantamento                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/**********************************************************************************************************************************/
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/**********************************************************************************************************************************/
user function Nhfin092()

  // area atual
  local aArea := getArea()

  private _aGrupo, _clApelido, _clNome   
  // titulo do cadastro
  private cCadastro := "Acerto de Adiatamento de Viajem"

  // funções
  private aRotina := { {"Pesquisar", "AxPesqui", 0, 1}  ,; // botao pesquisar
                       {"Visualizar", "AxVisual", 0, 2} ,; // botao visualizar
                       {"Acerto", "U_Adt017Inc", 0, 3}  ,; // botao incluir
                       {"Imprime Acerto", "U_impFin092", 0, 4}  ,; // botao Imprimir
                       {"Gera Financeiro","U_fGrvAcerto", 0, 5}  ,; // gera financeiro
       	               {"Legenda" ,"U_Fa017Legenda",0,6}} // botao legenda

                       // {"Excluir Financeiro","U_Adt017Exc", 0, 4}  ,; // botao excluir

  _aGrupo   :=  {}
  _aGrupo   :=  pswret()
  _clApelido := _agrupo[1,2 ] // Apelido
  _clNome    := _agrupo[1,4 ] // Nome completo

  // abre o browse com os dados
  dbSelectArea("ZZ3")
  ZZ3->(dbSetOrder(1))
  ZZ3->(dbGoTop())

  // abre o browse
  mBrowse( 006, 001, 022, 075, "ZZ3", nil, nil, nil, nil, nil, fCriaCor() )
  
  // restaura a area
  restArea(aArea)

return nil

User Function Fa017Legenda()       

Local aLegenda :=	{	{"BR_AZUL"    , "Financeiro gerado" },;
						{"BR_VERMELHO", "Gerou acerto" },;
						{"BR_VERDE"   , "Aberto"   }}

BrwLegenda("Acerto de Adiantamento de Viajem", "Legenda", aLegenda)

Return  


Static Function fCriaCor()       

Local aLegenda :=	{	{"BR_AZUL" , "Financeiro" },;
						{"BR_VERMELHO", "Gerou acerto" },;
						{"BR_VERDE"   , "Aberto"   }}

Local uRetorno := {}
Aadd(uRetorno, { 'ZZ3_STATUS = "F"' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZZ3_STATUS = "G"' , aLegenda[2][1] } )
Aadd(uRetorno, { 'ZZ3_STATUS = " "' , aLegenda[3][1] } )

Return(uRetorno)


User Function Adt017Inc()

SetPrvt("nMax,aHeader,aCols,oMultiline,oDialog,_nId,lDialog,_cUser,_lFlag,_cUser,_aF4,_nF4,cQuery1")
SetPrvt("_cNum,_cMatr,_cNome,_dDatad,_dDataa,_dEmissao,_nVlrAdt,_cObs,_clNome,_clApelido")


If ZZ3->ZZ3_CPR == "X"
	Alert("Titulo ja foi gerado no financeiro, use a opcao <Excluir Financeiro>!")
	Return
Endif
	
DEFINE FONT oFont NAME "Arial" SIZE 10, -12
DEFINE FONT oFont10 NAME "Arial" SIZE 20, -10 

_lFlag    := .T.
lDialog   := .T.               
_cNum     := ZZ3->ZZ3_NUM
_cMatr    := ZZ3->ZZ3_MATR
_cNome    := ZZ3->ZZ3_NOME
_dDatad   := ZZ3->ZZ3_DATADE
_dDataa   := ZZ3->ZZ3_DATAATE 
_dEmissao := ZZ3->ZZ3_EMISSAO
_nVlrAdt  := ZZ3->ZZ3_VALOR
_cObs     := ZZ3->ZZ3_OBS
_cMotivo  := IIF(ZZ3->ZZ3_MOTIVO=='1',"Desenvolvimento","Outros         ")
aHeader   := {}        
aCols     := {}
_cMoeda   := Space(1)
nMax      := 1
_nStotal  := 0
_nRestit  := 0
_cProjeto := ''
_cCusto   := ''
_nReal    := 0
_nTaxa    := IIF(ZZ3->ZZ3_TAXA==0,1,ZZ3->ZZ3_TAXA)
_cAta     := ZZ3->ZZ3_ATA

_aGrupo   :=  {}
_aGrupo   :=  pswret()
_clApelido := _agrupo[1,2 ] // Apelido
_clNome    := _agrupo[1,4 ] // Nome completo

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
_aAta := {"S=Sim","N=Nao"}

If ZZ3->ZZ3_MOTIVO == '1'
	If ZZ6->(Dbseek(xFilial("ZZ6")+ZZ3->ZZ3_CODPRJ )) 
		_cProjeto := ZZ3->ZZ3_CODPRJ + ' - ' + ZZ6->ZZ6_DESCRI
		If CTT->(Dbseek(xFilial("CTT")+ZZ6->ZZ6_CCUSTO )) 
			_cCusto := ZZ6->ZZ6_CCUSTO + ' - ' + CTT->CTT_DESC01
		Endif	
	Endif						
Else
	If CTT->(Dbseek(xFilial("CTT")+ZZ3->ZZ3_CC )) 
		_cCusto := ZZ3->ZZ3_CC + ' - ' + CTT->CTT_DESC01
	Endif	
Endif	

Aadd(aHeader,{"Tipo"           , "ZZ4_TIPO",   "@!"               ,10,0,"ExecBlock('fZz4Tipo',.F.,.F.)","","C","ZZ5"}) //03
Aadd(aHeader,{"Descricao\Obs." , "ZZ4_OBS" ,   Repli("!",40)      ,40,0,".T.","","C","ZZ4"}) //03
Aadd(aHeader,{"Valor"          , "ZZ4_VALOR",  "@E 999,999,999.99" ,12,2,"ExecBlock('fVlZ4017',.F.,.F.)",".T.","N","ZZ4"})
Aadd(aHeader,{"Data"           , "ZZ4_DATA",  "99/99/9999"       ,10,0,".T.","","C","ZZ4"}) //03
Aadd(aHeader,{"Comprovante"    , "ZZ4_MODELO", Repli("!",10)      ,10,0,".T.","","C","ZZ4"}) //03

//
fBuscaZZ4()

Define MsDialog oDialog Title OemToAnsi("Adiantamento de Viajem") From 010,030 To 500,860 Pixel 

@ 013,007 To 102,410 Title OemToAnsi("  Adiatamento ") //Color CLR_HBLUE
@ 027,010 Say "Numero :" Size 030,8 Object oNum
@ 027,032 Get _cNum Picture "@!" When .F. Size 035,10 Object oNum 
oNum:Setfont(oFont)

@ 027,080 Say "Matr:" Size 30,8 object oMatr
@ 025,095 Get _cMatr Picture "@!" When .F. Size 35,8 Object oMatr

@ 027,150 Say "Nome:" Size 30,8 object oNome
@ 025,170 Get _cNome Picture "@!" When .F. Size 80,8 Object oNome

@ 027,260 Say "Moeda:" Size 30,8 object oMoeda  
@ 025,280 Get _cMoeda Picture "@!" When .F. Size 30,8 Object oMoeda 

@ 027,330 Say "Valor:" Size 30,8 object oVlrAdt
@ 025,360 Get _nVlrAdt Picture "@E 999,999,999.99" When .F. Size 45,8 Object oVlrAdt

@ 050,010 Say "Data de:" Size 040,8 Object oDatad                
@ 048,040 Get _dDatad When .F. Size 40,8 Object oDatad

@ 050,090 Say "Data ate:" Size 040,8 Object oDataa
@ 048,120 Get _dDataa When .F. Size 40,8 Object oDataa

@ 050,180 Say "Emissao:" Size 040,8 Object odEmissao
@ 048,210 Get _dEmissao When .F. Size 40,8 Object odEmissao

@ 050,260 Say "Motivo:" Size 040,8 Object oMotivo 
@ 048,285 Get _cMotivo When .F. Size 80,8 Object oMotivo 
oMotivo:Setfont(oFont) 

@ 068,010 Say OemToAnsi("Projeto:") Size 040,8 object oProjeto
@ 066,040 Get _cProjeto When .F. Size 120,8 Object oProjeto

@ 068,180 Say OemToAnsi("C.Custo:") Size 040,8 object oCCusto
@ 066,200 Get _cCusto When .F. Size 120,8 Object oCCusto

@ 068,340 Say OemToAnsi("Ata em Anexo:") Size 040,8 object oAta
@ 066,380 COMBOBOX _cAta   ITEMS _aAta SIZE 25,10 object oAta  
   
@ 088,010 Say OemToAnsi("Atividade:")   Size 040,8 object oObs 
@ 086,040 Get _cObs Size 365,8 Object oObs 

@ 105,006 To 200,410 Title OemToAnsi(" Despesas ")  
@ 115,006 TO 190,410 MULTILINE MODIFY DELETE OBJECT oMultiline 

@ 205,090 BUTTON "Financeiro" Size 40,15 ACTION fSomAdt() // Finaceiro 17                  

@ 205,120 BMPBUTTON TYPE 13 ACTION fGrvAdt() // grava 13
@ 205,160 BMPBUTTON TYPE 02 ACTION fEnd()   //  cancela 02
@ 205,200 BMPBUTTON TYPE 03 ACTION fExcAdt()   //  exclui 03
//@ 205,240 BMPBUTTON TYPE 01 ACTION fSomAdt() // Finaceiro 17

@ 205,090 BUTTON "Financeiro" Size 40,15 ACTION fSomAdt() // Finaceiro 17                  

@ 205,290 Say "    Sub-total:"   Size 040,8 object oSTotal
@ 220,290 Say "Pagar/Receber:"   Size 040,8 object oRestit
@ 235,290 Say " (R$) em Real:"   Size 040,8 object oReal

@ 203,360 Get _nSTotal Picture "@E 999,999.99" When .F. Size 40,8 Object oStotal
@ 217,360 Get _nRestit Picture "@E 999,999.99" When .F. Size 40,8 Object oRestit
@ 232,360 Get _nReal   Picture "@E 999,999.99" When .F. Size 40,8 Object oReal
                                        	
// oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline
Activate MsDialog oDialog Center  // Valid fDialog()
ZZ4->(DbCloseArea())

Return           

//
Static Function fEnd() 
   Close(oDialog) 

Return

//
User Function fZz4Tipo()
Local lRet := .T.
	If ZZ5->(Dbseek(xFilial("ZZ5")+M->ZZ4_TIPO ))// Acols[n][1]))	
		Acols[n][2] := ZZ5->ZZ5_DESCRI
	Else
		MsgBox("Tipo de despesa Nao Cadastrada!","Despesas","ALERT")
		lRet := .F.
	Endif
	oMultiline:Refresh()                  
Return(lRet)

//                                                      
User Function fVlZ4017()
Local lRet := .T.
	oMultiline:Refresh()                  
	If M->ZZ4_VALOR <=0
		MsgBox("Valor menor que zero, Verifique !","Despesas","ALERT")
		lRet := .F.
	Else
		_nsTotal -= Acols[n][3]
		_nsTotal += M->ZZ4_VALOR                            
	Endif		
	/*
	For _x:=1 to Len(aCols)
		If !Acols[_x][len(aHeader)+1]  //nao pega quando a linha esta deletada
			_nSTotal += M->ZZ4_VALOR //Acols[_x][3]
		Endif
	Next
	*/
	_nRestit := _nVlrAdt - _nStotal
	_nReal   := _nRestit * _nTaxa
	oStotal:Refresh()
	oRestit:Refresh()
	oReal:Refresh()
	oMultiline:Refresh()
Return(lRet)

// Totaliza Adiatamento - Despesas
User Function fGrvAcerto()
Local _lRet   := .T.
Local i := 0
_nVlrAdt := ZZ3->ZZ3_VALOR
_nTaxa   := ZZ3->ZZ3_TAXA
_nStotal := 0
ZZ4->(DbSetOrder(1))
ZZ4->(Dbseek(xFilial("ZZ4")+ZZ3->ZZ3_NUM))	
While !ZZ4->(Eof()) .AND. ZZ4->ZZ4_NUM == ZZ3->ZZ3_NUM
	_nSTotal += ZZ4->ZZ4_VALOR
	ZZ4->(DbSkip())	
Enddo
_nRestit := _nVlrAdt - _nStotal
_nReal   := _nRestit * IIF(_nTaxa > 0,_nTaxa,1)

If ZZ3->ZZ3_MOTIVO == '1'
	If ZZ6->(Dbseek(xFilial("ZZ6")+ZZ3->ZZ3_CODPRJ )) 
		_cCusto := ZZ6->ZZ6_CCUSTO
	Endif						
Else
	_cCusto := ZZ3->ZZ3_CC
Endif	


//
If ZZ3->ZZ3_STATUS <> "F"

	If MsgBox("Gera financeiro do Acerto de Adiantamento","Financeiro","YESNO")

		If _nReal > 0

		  DbSelectArea("SE2")
		  RecLock("SE2",.t.)
		  SE2->E2_FILIAL  := xFilial("SE2")
		  SE2->E2_PREFIXO := "ADT"
		  SE2->E2_NUM     := ZZ3->ZZ3_NUM
		  SE2->E2_PARCELA := "B"
		  SE2->E2_TIPO    := "VL"
		  SE2->E2_NATUREZ := ZZ3->ZZ3_NATUREZ
		  SE2->E2_FORNECE := "999999"
		  SE2->E2_LOJA    := "01"
		  SE2->E2_NOMFOR  := "ADIANTAMENTO DE VIAGEM"
		  SE2->E2_EMISSAO := ZZ3->ZZ3_EMISSAO
		  SE2->E2_VENCTO  := dDataBase
		  SE2->E2_VENCREA := dDataBase
		  SE2->E2_VALOR   := _nReal
		  SE2->E2_EMIS1   := dDataBase
		  SE2->E2_HIST    := "PGTO/" + ZZ3->ZZ3_NUM + " P/" + ZZ3->ZZ3_NOME
		  SE2->E2_SALDO   := _nReal

 		  SE2->E2_VENCORI := dDataBase
		  SE2->E2_MOEDA   := 1   // Verificar com Dercy
		  SE2->E2_RATEIO  := "N"
		  SE2->E2_VLCRUZ  := _nReal
		  SE2->E2_OCORREN := "01"
		  SE2->E2_ORIGEM  := ""
		  SE2->E2_FLUXO   := "S"
		  SE2->E2_DESDOBR := "N"
		  SE2->E2_CC      := _cCusto
		  MsUnLock("SE2")
	
		  DbSelectArea("ZZ3")
		  // Marcar como Gerado titulo no financeiro
		  RecLock("ZZ3",.f.)
		  ZZ3->ZZ3_CPR    := "X"
		  ZZ3->ZZ3_STATUS := "F"
	      ZZ3->ZZ3_FINNOM  := _clNome
		  ZZ3->ZZ3_FINDAT  := DATE()
		  ZZ3->ZZ3_FINHOR  := Substr(time(),1,5) 
     	  MsUnLock("ZZ3")

		  Alert("Titulo gerado no financeiro Contas a Pagar")

		Else
	
		
		_nReal := (_nReal * -1)
      
		RecLock("SE1",.t.)
	    SE1->E1_FILIAL  := xFilial("SE1")
	    SE1->E1_PREFIXO := "ADT"
	    SE1->E1_NUM     := ZZ3->ZZ3_NUM
	    SE1->E1_PARCELA := "B"
	    SE1->E1_TIPO    := "VL"
	    SE1->E1_NATUREZ := ZZ3->ZZ3_NATUREZ
	    SE1->E1_PORTADO := "" 
	    SE1->E1_AGEDEP  := "" 
	    SE1->E1_CLIENTE := "999999"
	    SE1->E1_LOJA    := "01"
	    SE1->E1_NOMCLI  := "ADT DE VIAGEM"
	    SE1->E1_EMISSAO := dDataBase
	    SE1->E1_VENCTO  := dDataBase
	    SE1->E1_VENCREA := dDataBase
	    SE1->E1_VALOR   := _nReal
	    SE1->E1_HIST    := "REST.N. " + ZZ3->ZZ3_NUM + " DO ADT DE VIAGEM"
	    SE1->E1_SALDO   := _nReal
	    SE1->E1_SITUACA := "0" 
	    SE1->E1_VENCORI := dDataBase
	    SE1->E1_MOEDA   := Val(ZZ3->ZZ3_MOEDA)
	    SE1->E1_FLUXO   := "S"
	    SE1->E1_VLRREAL := _nReal
		MsUnLock("SE1")

		DbSelectArea("ZZ3")
		// Marcar como Gerado titulo no financeiro
		RecLock("ZZ3",.f.)
		ZZ3->ZZ3_CPR    := "X"
		ZZ3->ZZ3_STATUS := "F"
		ZZ3->ZZ3_FINNOM  := _clNome
		ZZ3->ZZ3_FINDAT  := DATE()
		ZZ3->ZZ3_FINHOR  := Substr(time(),1,5) 
		MsUnLock("ZZ3")

		Alert("Titulo gerado no financeiro Contas a Receber")
		Endif	
		
	
	Endif  

Else

	Alert("Titulo ja foi gerado no financeiro !")

Endif

Return


// grava acerto de adiatamento
Static Function fGrvAdt()
Local _dDataCol := Ctod(Space(08))

  // exclui dados ZZ4
	DbSelectArea("ZZ4")
	ZZ4->(DbSetOrder(1))
	If ZZ4->(Dbseek(xFilial("ZZ4")+ZZ3->ZZ3_NUM))	
		While ZZ4->ZZ4_NUM == ZZ3->ZZ3_NUM
			Reclock("ZZ4",.F.)   
		  ZZ4->(DbDelete())
		  MsUnlock("ZZ4")	
		  ZZ4->(DbSkip())
		Enddo
	Endif	

	// grava
	For _x:=1 to Len(aCols)
           
		If !Empty(Acols[_x][1]) .And. !Acols[_x][len(aHeader)+1]  //nao pega quando a linha esta deletada


			If Valtype(Acols[_x][4]) == 'D'
        		_dDataCol := Acols[_x][4]
			
			Else
				_dDataCol := Ctod(Substr(Acols[_x][4],1,2) + '/' + Substr(Acols[_x][4],4,2) + '/' + Substr(Acols[_x][4],7,2))

			Endif
		

			Reclock("ZZ4",.T.)   
			ZZ4->ZZ4_FILIAL  := xFilial("ZZ4")
			ZZ4->ZZ4_NUM     := ZZ3->ZZ3_NUM
			ZZ4->ZZ4_TIPO    := Acols[_x][1] // Tipos
			ZZ4->ZZ4_OBS     := Acols[_x][2] // observacao
			ZZ4->ZZ4_VALOR   := Acols[_x][3] // valor
			ZZ4->ZZ4_DATA    := _dDataCol    // data de documento
			ZZ4->ZZ4_MODELO  := Acols[_x][5] // tipo de documento
			MsUnlock("ZZ4")

			DbSelectArea("ZZ3")
			Reclock("ZZ3",.F.)   
			ZZ3->ZZ3_GEROUAC := "S"			
			ZZ3->ZZ3_STATUS  := "G"			
			ZZ3->ZZ3_OBS     := _cObs
			ZZ3->ZZ3_ATA     := _cAta
			ZZ3->ZZ3_ACENOM  := _clNome
			ZZ3->ZZ3_ACEDAT  := DATE()
			ZZ3->ZZ3_ACEHOR  := Substr(time(),1,5) 
			MsUnlock("ZZ3")

		Endif   
		   
	Next _x
      
	Close(oDialog)	                           
Return

//
Static function fBuscaZZ4()
	_nStotal := 0
	ZZ4->(DbSetOrder(1))
	ZZ4->(Dbseek(xFilial("ZZ4")+ZZ3->ZZ3_NUM))	
	While !ZZ4->(Eof()) .AND. ZZ4->ZZ4_NUM == ZZ3->ZZ3_NUM
	  Aadd(aCols,{ZZ4->ZZ4_TIPO,ZZ4->ZZ4_OBS,ZZ4->ZZ4_VALOR,ZZ4->ZZ4_DATA,ZZ4->ZZ4_MODELO,.F.})
		_nSTotal += ZZ4->ZZ4_VALOR
		ZZ4->(DbSkip())	
	Enddo
	_nRestit := _nVlrAdt - _nStotal
	_nReal   := _nRestit * _nTaxa
	If Len(aCols) == 0
		Aadd(aCols,{Space(10),Space(40),0,Ctod(Space(08)),Space(10),.F.})
	Endif	
Return


// exclui acerto de adiatamento
Static Function fExcAdt()

	If MsgBox("Confirma exclusao do Acerto de Adiantamento","Exclui acerto","YESNO")

	  // exclui dados ZZ4
		DbSelectArea("ZZ4")
		ZZ4->(DbSetOrder(1))
		If ZZ4->(Dbseek(xFilial("ZZ4")+ZZ3->ZZ3_NUM))	
			While ZZ4->ZZ4_NUM == ZZ3->ZZ3_NUM
				Reclock("ZZ4",.F.)   
			  ZZ4->(DbDelete())
			  MsUnlock("ZZ4")	
			  ZZ4->(DbSkip())
			Enddo
		Endif	

		DbSelectArea("ZZ3")
		Reclock("ZZ3",.F.)   
		ZZ3->ZZ3_GEROUAC := "N"
		ZZ3->ZZ3_STATUS  := "A"			
		MsUnlock("ZZ3")
  	  
		Close(oDialog)	                           

	Endif	
	oMultiline:Refresh()                  
Return


// Exclui acerto ZZ4 e SE2 nao pode estar baixado
User Function Adt017Exc()

If ZZ3->ZZ3_CPR == "X"

	If MsgBox("Confirma exclusao do Acerto de Adiantamento no Financeiro","Exclui acerto","YESNO")
      
			// Pesquisa no contas a pagar
			DbSelectArea("SE2")
			If SE2->(dbSeek(xFilial("SE2")+"ADT"+ZZ3->ZZ3_NUM+"B"))

				If SE2->(dbSeek(xFilial("SE2")+"ADT"+ZZ3->ZZ3_NUM+"A"))
					
					If SE2->E2_BAIXA <> Ctod(Space(08))
						Alert("Titulo com baixa, favor cancelar baixa para exclusao!")						
						Return
					Endif
				
					If !Empty(SE2->E2_NUMBOR)
						Alert("Titulo em bordero, favor cancelar bordero para exclusao!")	
						Return
					Endif

					DbSelectArea("SE2")
					Reclock("SE2",.F.)   
					SE2->(DbDelete())			
					MsUnlock("SE2")

					DbSelectArea("ZZ3")
					Reclock("ZZ3",.F.)
					ZZ3->ZZ3_STATUS  := "G"
					ZZ3->ZZ3_CPR := " "
					MsUnlock("ZZ3")
						
				Endif	



			Else

				If SE1->(dbSeek(xFilial("SE1")+"ADT"+ZZ3->ZZ3_NUM+"A"))
					
					If SE1->E1_BAIXA <> Ctod(Space(08))
						Alert("Titulo com baixa, favor cancelar baixa para exclusao!")						
						Return
					Endif
				
					If !Empty(SE1->E1_NUMBOR)
						Alert("Titulo em bordero, favor cancelar bordero para exclusao!")	
						Return
					Endif

					DbSelectArea("SE1")
					Reclock("SE1",.F.)   
					SE1->(DbDelete())			
					MsUnlock("SE1")

					DbSelectArea("ZZ3")
					Reclock("ZZ3",.F.)   
					ZZ3->ZZ3_STATUS  := "G"			
					ZZ3->ZZ3_CPR := " "					
					MsUnlock("ZZ3")
						
				Endif	
			
			Endif			

	Endif		
Else
	Alert("Titulo nao foi gerado no financeiro, use a opcao <Acerto>!")
Endif

Return 
                                    

//
User Function ImpFin092()

SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC")
SetPrvt("CNORMAL,LPRIMEIRO,CQUERY,")

cSavCur1  := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont    := "";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem    := 0
tamanho   := "M"
limite    := 220	
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "Acerto de Despesas de Viagem"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "SRA"
nTipo     := 0
nomeprog  := "NHFIN092"
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
wnrel:= "NHFIN092"

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

Cabec1 := "                      D E S P E S A S    C O M   V I A G E M"
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
	_cCusto := ZZ3->ZZ3_CC + ' - ' + CTT->CTT_DESC01
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
	@ Prow() + 1, 070 Psay '  Banco: ' + ZZ3->ZZ3_BANCO

	@ Prow() + 1, 000 Psay 'Colaborador : ' + ZZ3->ZZ3_MATR + ' ' + ZZ3->ZZ3_NOME
	@ Prow() + 1, 070 Psay 'Agencia: ' + ZZ3->ZZ3_AGENCI
	
	@ Prow() + 1, 000 Psay 'C. de Custo : ' + _cCusto
	@ Prow() + 1, 070 Psay '  Conta: ' + ZZ3->ZZ3_CONTA
	
	@ Prow() + 2, 000 Psay 'Periodo     : ' + Dtoc(ZZ3->ZZ3_DATADE) + ' ate ' + Dtoc(ZZ3->ZZ3_DATAAT)
	@ Prow() + 2, 000 Psay 'Atividade   : ' + ZZ3->ZZ3_OBS 
	@ Prow() + 2, 000 Psay 'Projeto     : ' + _cProjeto
	@ Prow() + 1, 000 Psay 'C.Custo     : ' + _cCusto2
	@ Prow() + 2, 000 Psay 'Vlr Adt.    : ' + Transform(ZZ3->ZZ3_VALOR,"@E 999,999,999.99")
	@ Prow() + 1, 000 Psay 'Moeda       : ' + _cMoeda      	
	@ Prow() + 1, 000 Psay 'Taxa        : ' + Transform(ZZ3->ZZ3_TAXA,"@E 999,999,999.99")
	@ Prow() + 2, 000 Psay 'Ata em enexo: ' + IIF(ZZ3->ZZ3_ATA=="S","SIM","NAO")

	@ Prow() + 1, 000  Psay __PrtThinLine()
	@ Prow() + 1, 030  Psay '***  D E S C R I M I N A C A O    D A S    D E S P E S A S  ***'
	@ Prow() + 2, 000  Psay 'Cod. Descricao                                             Valor      Data          Comprovante'
	@ Prow() + 1, 000  Psay __PrtThinLine()


	ZZ4->(DbSetOrder(1))
	ZZ4->(Dbseek(xFilial("ZZ4")+ZZ3->ZZ3_NUM))	
	While !ZZ4->(Eof()) .AND. ZZ4->ZZ4_NUM == ZZ3->ZZ3_NUM
		@ Prow() + 1, 000 Psay ZZ4->ZZ4_TIPO 
		@ Prow()    , 005 Psay ZZ4->ZZ4_OBS
		@ Prow()    , 050 Psay Transform(ZZ4->ZZ4_VALOR,'@E 999,999,999.99')
		@ Prow()    , 070 Psay ZZ4->ZZ4_DATA
		If Alltrim(ZZ4->ZZ4_MODELO) == '1'
			@ Prow()    , 084 Psay 'NF'
		Elseif Alltrim(ZZ4->ZZ4_MODELO) == '2'
			@ Prow()    , 084 Psay 'RECIBOS'
		Elseif Alltrim(ZZ4->ZZ4_MODELO) == '3'			
			@ Prow()    , 084 Psay 'CUPOM FISCAL'
		Elseif Alltrim(ZZ4->ZZ4_MODELO) == '4'
			@ Prow()    , 084 Psay 'TICKET'
		Else
			@ Prow()    , 084 Psay 'OUTROS'
		Endif	
		_nVlrzz4 += ZZ4->ZZ4_VALOR
		ZZ4->(DbSkip())	
	Enddo


@ Prow() + 1,000  Psay __PrtThinLine()
@ Prow() + 1,030  Psay '    Sub-Total:'
@ Prow()    ,050 Psay Transform(_nVlrzz4,'@E 999,999,999.99')
@ Prow() + 1,030  Psay 'Pagar/Receber:'
@ Prow()    ,050 Psay Transform((ZZ3->ZZ3_VALOR - _nVlrzz4),'@E 999,999,999.99')
@ Prow() + 1,030  Psay ' (R$) em Real:'
@ Prow()    ,050 Psay Transform(((ZZ3->ZZ3_VALOR - _nVlrzz4) * _nTaxa),'@E 999,999,999.99')
@ Prow() + 1,000 Psay __PrtThinLine()
@ Prow() + 5,010  Psay '__________________________        ______________________'
@ Prow() + 1,010  Psay '     Solicitante                        Gerencia        '

Return
