/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Nhcom041  ³ Autor ³ Marcos R. Roquitski   ³ Data ³ 12/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±  
±±³Descricao ³Consulta Status da solicitacao de Compras.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³WHB.                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
#include "rwmake.ch"  
#include "topconn.ch"

User Function Nhcom041()
                           

SetPrvt("CCADASTRO,AROTINA,lEnd,_cSc1Num,_dSc1Emi,_cSc1Item,aCores,_dSc1Prf,lSaida,nMax,aCols,aHeader")
SetPrvt("_dDatade,_dDatate,_cSitu,_aGrupo,_cLogin,_nFechada,_nAberta,lEnd,_nAguardar,_nRejeitar")
SetPrvt("_cGrupode,_cGrupoat,_cProdude,_cProduat,_cCustode,_cCustoat,_cC1Numde,_cC1Numat")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC,CNORMAL,LPRIMEIRO,CQUERY")

cSavCur1  := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont    := "";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem    := 0
tamanho   := "G"
limite    := 220
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "Status de Solicitacoes de Compras sem Pedido de Compra"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "SZ4"
nTipo     := 0
nomeprog  := "NHCOM041"
cPerg     := "NHCO44"
nPag      := 1
m_pag     := 1


aCores    := {{ '!Empty(C1_RESIDUO)','BR_PRETO'},;						//SC Eliminada por Residuo
	{'C1_QUJE==0.And.C1_COTACAO==Space(Len(C1_COTACAO)).And.C1_APROV$" ,L"' , 'ENABLE' },;		//SC em Aberto
	{'C1_QUJE==0.And.C1_COTACAO==Space(Len(C1_COTACAO)).And.C1_APROV="R"' , 'BR_LARANJA' },;	//SC Rejeitada	
	{'C1_QUJE==0.And.C1_COTACAO==Space(Len(C1_COTACAO)).And.C1_APROV="B"' , 'BR_CINZA' },;		//SC Bloqueada
	{ 'C1_QUJE==C1_QUANT' , 'DISABLE'},;									//SC com Pedido Colocado
	{ 'C1_QUJE>0','BR_AMARELO'},;											//SC com Pedido Colocado Parcial
	{ 'C1_QUJE==0.And.C1_COTACAO<>Space(Len(C1_COTACAO))' , 'BR_AZUL'}}		//SC em Processo de Cotacao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando Arquivo Temporario para posterior impressao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCadastro := 'Aprovacao Solicitacoes de Compras'
aRotina := {{ "Pesquisar" ,"AxPesqui",0,1},;
			{ "Visualiza" ,"AxVisual",0,1},;
            { "Detalhes"  ,"U_fConsDet()",0,2},;
            { "Anexo 1" ,'U_fAnexosc1(1)',0,2},;
            { "Anexo 2" ,'U_fAnexosc1(2)',0,2},;
            { "Anexo 3" ,'U_fAnexosc1(3)',0,2},;
            { "Transferir",'U_fTransf()',0,2},;
            { "Imprime"   ,"U_fImpStat()",0,2},;
            { "Legenda"  ,"U_C41Legenda",0,2}}



DbSelectArea("SC1")
SC1->(DbSetOrder(1))
SC1->(DbgoTop())
lEnd := .T.            
mBrowse(,,,,"SC1",,,,,,aCores)

Return(nil)    


User Function C41Legenda()       

Local aLegenda :=	{ 	{"BR_VERDE" ,   "Solicitacao Pendente              " },;
						{"BR_VERMELHO", "Solicitacao Totalmente Atendida   " },;
						{"BR_AMARELO" , "Solicitacao Parcialmente Atendida " },;
				    	{"BR_AZUL" ,    "Solicitacao em Processo de Cotacao" },;
						{"BR_PRETO" ,   "Eliminado por Residuo             " },;
						{"BR_CINZA",    "Solicitacao Bloqueada             " },;
						{"BR_LARANJA" , "Solicitacao Rejeitada             " }}

BrwLegenda("Aprovacao de SC", "Legenda", aLegenda)

Return  


Static Function fCriaCor()       

Local aLegenda :=	{	{"BR_VERDE"    , "Pendente" },;
						{"BR_VERMELHO", "Rejeitado" },;
  						{"BR_AZUL"   , "Aprovado"   },;
						{"BR_PRETO"  , "Aguardando" }}

Local uRetorno := {}
Aadd(uRetorno, { 'ZU_STATUS = " "' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZU_STATUS = "C"' , aLegenda[2][1] } )
Aadd(uRetorno, { 'ZU_STATUS = "A"' , aLegenda[3][1] } )
Aadd(uRetorno, { 'ZU_STATUS = "B"' , aLegenda[4][1] } )

Return(uRetorno)


User Function fConsDet()
Local _cArqNtx  
Local _nOrder 
lEnd     := .T.
lSaida   := .F.
_cArqDBF := CriaTrab(NIL,.f.)
_cArqDBF += ".DBF"
_aFields := {}


AADD(_aFields,{"ZU_NUM"   ,"C",06,0})
AADD(_aFields,{"ZU_ITEM"  ,"C",04,0})
AADD(_aFields,{"ZU_LOGIN" ,"C",15,0})
AADD(_aFields,{"ZU_STATUS","C",20,0})
AADD(_aFields,{"ZU_DATAPR","D",08,0})
AADD(_aFields,{"ZU_HORAPR","C",05,0})
AADD(_aFields,{"ZU_FUNCAO","C",30,0})
AADD(_aFields,{"ZU_SOLICIT","C",15,0})
AADD(_aFields,{"ZU_ORIGEM","C",17,0})
AADD(_aFields,{"ZU_PEDIDO","C",06,0})
AADD(_aFields,{"ZU_OBS","C",99,0})
AADD(_aFields,{"ZU_NIVEL","C",01,0})


DbCreate(_cArqDBF,_aFields)
DbUseArea(.T.,,_cArqDBF,"DET",.F.)   

// Criacao de Indice Temporario
_cArqNtx  := CriaTrab(NIL,.f.)
_nOrder   := "DET->ZU_ORIGEM+DET->ZU_NIVEL"
IndRegua("DET",_cArqNtx,_nOrder,"Indexando Registros..." )

MsAguarde ( {|lEnd| fDetalhes() },"Processando","Aguarde...",.T.)


DbSelectArea("DET")
DET->(DbGotop())
If Reccount() <=0
   MsgBox("Nao foi encontrado o(s) titulo(s) origem!","Atencao","INFO")
   DbCloseArea("DET")
   Return
Endif

_cSc1Num := SC1->C1_NUM
_cSc1Item := SC1->C1_ITEM
_dSc1Emi := SC1->C1_EMISSAO
_dSc1Prf := SC1->C1_DATPRF

aCampos1 := {}
//AADD(aCampos1,{"ZU_NUM","Nr.Sc","@!","06"})
//AADD(aCampos1,{"ZU_ITEM","Item SC","@!","04"})
AADD(aCampos1,{"ZU_LOGIN","Responsavel","@!","15"})
Aadd(aCampos1,{"ZU_FUNCAO","Funcao","@!","30"})
AADD(aCampos1,{"ZU_STATUS","Status","@!","01"})
AADD(aCampos1,{"ZU_DATAPR","Data Aprovacao","99/99/99","08"})
Aadd(aCampos1,{"ZU_HORAPR","Hora Aprovacao","@!","05"})
Aadd(aCampos1,{"ZU_SOLICIT","Solicitante","@!","15"})
Aadd(aCampos1,{"ZU_ORIGEM","Origem","@!","17"})
Aadd(aCampos1,{"ZU_PEDIDO","Nr. PC","@!","06"})
Aadd(aCampos1,{"ZU_OBS","Observacao","@!","99"})
Aadd(aCampos1,{"ZU_OBS","Observacao","@!","99"})

@ 100,041 To 470,575 Dialog dlgComp Title "Status da Solicitacao de Compras"
@ 007,010 Say OemToAnsi("Nr.SC:") Size 35,8
@ 007,067 Say OemToAnsi("Item:") Size 30,8
@ 007,118 Say OemToAnsi("Emissao:") Size 35,8
@ 007,185 Say OemToAnsi("Previsao:") Size 35,8

@ 005,030 Get _cSc1Num  Size 20,8 When .F.
@ 005,080 Get _cSc1Item Size 20,8 When .F.
@ 005,142 Get _dSc1Emi  Size 30,8 When .F.
@ 005,210 Get _dSc1Prf  Size 30,8 When .F.

@ 020,10 TO 145,260 Browse "DET" Fields aCampos1

@ 170,218 Button "_Sair" SIZE 40,10 Action fFecha()

Activate Dialog dlgComp Centered

DbSelectArea("DET")	
DbCloseArea("DET")

If File(_cArqNtx+OrdBagExt())
   Ferase(_cArqNtx+OrdBagExt())
Endif   


Return


Static Function fFecha()
	//DbSelectArea("DET")	
	//DbCloseArea("DET")
	Close(dlgComp)
Return(.T.)


Static Function fDetalhes()
Local _cRjDesc := Space(30)

	/* Status SC
	A - Aprovado
	B - Aguardando
	C - Rejeitado
	  - Pendente
	*/

	QAA->(DbSetOrder(6))
	

	DbSelectArea("SZU")
	SZU->(DbSetOrder(2))             
	SZU->(DbSeek(xFilial("SZU")+SC1->C1_NUM+SC1->C1_ITEM))
	While !SZU->(Eof()) .And. SZU->ZU_NUM+SZU->ZU_ITEM == SC1->C1_NUM+SC1->C1_ITEM
		RecLock("DET",.T.)
		DET->ZU_NUM    := SZU->ZU_NUM
		DET->ZU_ITEM   := SZU->ZU_ITEM 
		DET->ZU_LOGIN  := SZU->ZU_LOGIN 
		If SZU->ZU_STATUS == "A"
			DET->ZU_STATUS :=  "Aprovado "
		Elseif SZU->ZU_STATUS == "B"			
			DET->ZU_STATUS :=  "Aguardando"
		Elseif SZU->ZU_STATUS == "C"			
			DET->ZU_STATUS :=  "Rejeitado "
		Endif	
		DET->ZU_DATAPR  := SZU->ZU_DATAPR 
		DET->ZU_HORAPR  := SZU->ZU_HORAPR
		DET->ZU_PEDIDO  := SC1->C1_PEDIDO
		DET->ZU_SOLICIT := SC1->C1_SOLICIT
		DET->ZU_OBS     := SZU->ZU_OBS
		DET->ZU_NIVEL   := SZU->ZU_NIVEL
		DET->ZU_ORIGEM  := Iif(SZU->ZU_ORIGEM$"SC1","1-Solicitacao",Iif(SZU->ZU_ORIGEM$"SC3","2-Pedido Aberto","3-Aut.Entrega"))
		
		QAA->(DbSeek(SZU->ZU_LOGIN))
		If QAA->(Found())
			SRJ->(DbSeek(xFilial("SRJ")+QAA->QAA_CODFUN))
			If SRJ->(Found())
				DET->ZU_FUNCAO := SRJ->RJ_DESC
			Endif
		Endif
		MsUnlock("DET")
		SZU->(DbSkip())
	Enddo

	DbSelectArea("DET")
	DET->(DbGotop())

Return 

User function fParm()
	_aGrupo   := pswret()
	_cLogin   := _agrupo[1,2] // Apelido
	_dDatade  := dDataBase
	_dDatate  := dDataBase
	_cGrupode := Substr(SC1->C1_PRODUTO,1,4)
	_cGrupoat := Substr(SC1->C1_PRODUTO,1,4)
	_cProdude := SC1->C1_PRODUTO
	_cProduat := SC1->C1_PRODUTO
    _cCustode := SC1->C1_CC
    _cCustoat := SC1->C1_CC
    _cC1Numde := SC1->C1_NUM
    _cC1Numat := SC1->C1_NUM
		
	_cSitu   := Space(01)
	_aCombo  := {"A-Aprovadas ","B-Aguardando","C-Rejeitadas  ","Todas opcoes "}

	@ 100,002 To 487,350 Dialog DlgParam Title "Parametros de consulta"

	@ 010,010 Say "Responsavel ? "  Size 45,8
	@ 025,010 Say "Data de ?     "  Size 45,8
	@ 040,010 Say "Data Ate ?    "  Size 45,8
	@ 055,010 Say "Grupo de ?    "  Size 45,8
	@ 070,010 Say "Grupo Ate ?   "  Size 45,8
	@ 085,010 Say "Produto de ?  "  Size 45,8
	@ 100,010 Say "Produto Ate ? "  Size 45,8
	@ 115,010 Say "C.Custo de ?  "  Size 45,8
	@ 130,010 Say "C.Custo Ate ? "  Size 45,8
	@ 145,010 Say "Sc Nr. de ?   "  Size 45,8
	@ 160,010 Say "Sc Nr. Ate ?  "  Size 45,8

	@ 011,065 Get _cLogin     Picture "@!" When .F. Size 45,8
	@ 026,065 Get _dDatade    Picture "99/99/9999" Size 45,8
	@ 041,065 Get _dDatate    Picture "99/99/9999" Size 45,8
	@ 056,065 Get _cGrupode   Picture "@!" F3 "SBM" Size 15,8
	@ 071,065 Get _cGrupoat   Picture "@!" F3 "SBM" Size 15,8
	@ 086,065 Get _cProdude   Picture "@!" F3 "SB1" Size 45,8
	@ 101,065 Get _cProduat   Picture "@!" F3 "SB1" Size 45,8
	@ 116,065 Get _cCustode   Picture "@!" F3 "CTT" Size 25,8
	@ 131,065 Get _cCustoat   Picture "@!" F3 "CTT" Size 25,8

	@ 146,065 Get _cC1Numde   Picture "@!" Size 25,8
	@ 161,065 Get _cC1Numat   Picture "@!" Size 25,8


	@ 180,035 BMPBUTTON TYPE 01 ACTION fGeraTot()
	@ 180,080 BMPBUTTON TYPE 02 ACTION Close(dlgParam)

	Activate Dialog DlgParam CENTERED

Return(.T.)





Static Function fGeratot()
	MsAguarde ( {|lEnd| fProcSc2() },"Aguarde", "Somatorio das SC", .T.)
Return


Static Function fProcSc1()
Local _nRecno := SC1->(Recno()), _nTotal := 0, _cChave

	_nRejeitar:= 0
	_nAguardar:= 0
	_nFechada := 0
	_nAberta  := 0

	SZU->(DbSetOrder(2))

	DbSelectArea("SC1")
	SC1->(DbGotop())
 	SC1->(DbSetOrder(8))
 	_cChave := xFilial() + Dtos(_dDatade) 
	SC1->(DbSeek(_cChave),.F.)
	While SC1->(!Eof())
		If (SC1->C1_EMISSAO >= _dDatade .AND. SC1->C1_EMISSAO <= _dDatate)
			MsProcTxt(" Processando ..: " +SC1->C1_NUM)
			SZU->(DbSeek(xFilial("SZU")+SC1->C1_NUM+SC1->C1_ITEM))
			While !SZU->(Eof()) .AND. SZU->ZU_NUM+SZU->ZU_ITEM == SC1->C1_NUM+SC1->C1_ITEM
				If Alltrim(SZU->ZU_LOGIN) == Alltrim(_cLogin)
					If SZU->ZU_STATUS == 'A' // Aprovadas
						_nFechada += (SC1->C1_QUANT * SC1->C1_VUNIT)
					Elseif SZU->ZU_STATUS == 'B' // Aguardar
					    _nAguardar += (SC1->C1_QUANT * SC1->C1_VUNIT)
					Elseif SZU->ZU_STATUS == 'C' // Rejeitar
					    _nRejeitar += (SC1->C1_QUANT * SC1->C1_VUNIT)
					Else
						_nAberta += (SC1->C1_QUANT * SC1->C1_VUNIT)
					Endif
				Endif
		 		SZU->(DbSkip())
			Enddo
		Endif
		SC1->(DbSkip())
    Enddo
	SC1->(DbGoto(_nRecno))
	_nTotal := (_nFechada + _nAberta + _nAguardar + _nRejeitar)


	@ 100,002 To 330,370 Dialog DlgTotal Title "TOTALIZACAO DE SC"
	@ 010,010 Say "Aprovadas    :"  Size 45,8
    @ 025,010 Say "Abertas      :"  Size 45,8
	@ 040,010 Say "Aguardando   :"  Size 45,8    
	@ 055,010 Say "Rejeitadas   :"  Size 45,8
	@ 070,010 Say "TOTAL        :"  Size 45,8

	@ 011,065 Get _nFechada  Picture "@E 999,999,999.99"  When .F. Size 45,8
	@ 026,065 Get _nAberta   Picture "@E 999,999,999.99"  When .F. Size 45,8
	@ 041,065 Get _nAguardar Picture "@E 999,999,999.99"  When .F. Size 45,8 
	@ 056,065 Get _nRejeitar Picture "@E 999,999,999.99"  When .F. Size 45,8
	@ 071,065 Get _nTotal    Picture "@E 999,999,999.99"  When .F. Size 45,8

	@ 090,080 BMPBUTTON TYPE 01 ACTION Close(dlgTotal)

	Activate Dialog DlgTotal CENTERED

Return

Static Function fGeras()

	cQuery := "SELECT * FROM " + RetSqlName( 'SC1' ) + " C1 " 
	cQuery += " WHERE C1.C1_FILIAL = '"	 + xFilial("SC1")+ "' "
	cQuery += " AND SUBSTRING(C1.C1_PRODUTO,1,4) BETWEEN '"+ _cGrupode + "' AND '"+ _cGrupoat + "' "
	cQuery += " AND C1.C1_EMISSAO BETWEEN '"+ DTOS(_dDatade) + "'  AND '"+ DTOS(_dDatate) + "' "
	cQuery += " AND C1.C1_CC BETWEEN '"+ _cCustode + "' AND '"+ _cCustoat + "' "
	cQuery += " AND C1.C1_NUM BETWEEN '"+ _cC1Numde + "' AND '"+ _cC1Numat + "' "
	cQuery += " AND C1.C1_PRODUTO BETWEEN '"+ _cProdude + "' AND '"+ _cProduat + "' "
	cQuery += " AND D_E_L_E_T_ = ' ' "
	//cQuery := cQuery + "ORDER BY 6,2,4 " 

	//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"
	TcSetField("TMP","C1_EMISSAO","D")  // Muda a data de string para date

Return

Static Function fProcSc2()
Local _nRecno := SC1->(Recno()), _nTotal := 0, _cChave

	_nRejeitar:= 0
	_nAguardar:= 0
	_nFechada := 0
	_nAberta  := 0

	fGeras()

	SZU->(DbSetOrder(2))

	DbSelectArea("TMP")
	While TMP->(!Eof())
		MsProcTxt(" Processando ..: " +TMP->C1_NUM)
		SZU->(DbSeek(xFilial("SZU")+SC1->C1_NUM+SC1->C1_ITEM))
		// While !TMP->(Eof()) .AND. SZU->ZU_NUM+SZU->ZU_ITEM == TMP->C1_NUM+TMP->C1_ITEM
		If SZU->(Found())
			If SZU->ZU_STATUS == 'A' // Aprovadas
				_nFechada += (TMP->C1_QUANT * TMP->C1_VUNIT)
			Elseif SZU->ZU_STATUS == 'B' // Aguardar
			    _nAguardar += (TMP->C1_QUANT * TMP->C1_VUNIT)
			Elseif SZU->ZU_STATUS == 'C' // Rejeitar
			    _nRejeitar += (TMP->C1_QUANT * TMP->C1_VUNIT)
			Else
				_nAberta += (TMP->C1_QUANT * TMP->C1_VUNIT)
			Endif
		Endif
	 	//	SZU->(DbSkip())
		//  Enddo
		TMP->(DbSkip())
    Enddo
	_nTotal := (_nFechada + _nAberta + _nAguardar + _nRejeitar)
	DbCloseArea("TMP")

	@ 100,002 To 330,370 Dialog DlgTotal Title "TOTALIZACAO DE SC"
	@ 010,010 Say "Aprovadas    :"  Size 45,8
    @ 025,010 Say "Abertas      :"  Size 45,8
	@ 040,010 Say "Aguardando   :"  Size 45,8    
	@ 055,010 Say "Rejeitadas   :"  Size 45,8
	@ 070,010 Say "TOTAL        :"  Size 45,8

	@ 011,065 Get _nFechada  Picture "@E 999,999,999.99"  When .F. Size 45,8
	@ 026,065 Get _nAberta   Picture "@E 999,999,999.99"  When .F. Size 45,8
	@ 041,065 Get _nAguardar Picture "@E 999,999,999.99"  When .F. Size 45,8 
	@ 056,065 Get _nRejeitar Picture "@E 999,999,999.99"  When .F. Size 45,8
	@ 071,065 Get _nTotal    Picture "@E 999,999,999.99"  When .F. Size 45,8

	@ 090,080 BMPBUTTON TYPE 01 ACTION Close(dlgTotal)

	Activate Dialog DlgTotal CENTERED

Return

     
User Function fPrecPed()
Local nValor := 0
SC7->(DbSetOrder(1))             
SC7->(DbSeek(xFilial("SC7")+SC1->C1_PEDIDO+SC1->C1_ITEMPED))
If SC7->(Found())
	nValor := SC7->C7_PRECO
Endif
Return(nValor)


User Function fTransf()
lEnd := .T.
lSaida := .F.
_cArqDBF := CriaTrab(NIL,.f.)
_cArqDBF += ".DBF"
_aFields := {}
aCols    := {}

AADD(_aFields,{"ZU_NUM"   , "C",06,0})
AADD(_aFields,{"ZU_ITEM"  , "C",04,0})
AADD(_aFields,{"ZU_LOGIN" , "C",15,0})
AADD(_aFields,{"ZU_STATUS", "C",32,0})
AADD(_aFields,{"ZU_DATAPR", "D",08,0})
AADD(_aFields,{"ZU_HORAPR", "C",05,0})
AADD(_aFields,{"ZU_FUNCAO", "C",30,0})
AADD(_aFields,{"ZU_SOLICIT","C",15,0})
AADD(_aFields,{"ZU_PEDIDO", "C",06,0})
AADD(_aFields,{"ZU_OBS","C",99,0})
AADD(_aFields,{"ZU_NIVEL","C",01,0}) 
AADD(_aFields,{"ZU_ORIGEM","C",17,0})

DbCreate(_cArqDBF,_aFields)
DbUseArea(.T.,,_cArqDBF,"DET",.F.)

MsAguarde ( {|lEnd| fDetalhes() },"Processando","Aguarde...",.T.)


DbSelectArea("DET")
DET->(DbGotop())
While !DET->(Eof())
	AADD(aCols,{DET->ZU_LOGIN,DET->ZU_NUM,DET->ZU_ITEM,DET->ZU_LOGIN,DET->ZU_NIVEL})
	DET->(Dbskip())
Enddo

_cSc1Num := SC1->C1_NUM
_cSc1Item := SC1->C1_ITEM
_dSc1Emi := SC1->C1_EMISSAO
_dSc1Prf := SC1->C1_DATPRF

nMax      := Len(aCols)
aHeader   := {}
Aadd(aHeader,{"Responsavel" ,"ZU_LOGIN","@!" ,15,0,".T.","","C","SZU"})
Aadd(aHeader,{"Nr. Sc",      "UM","@!" ,06,0,".F.","","N","SZU"})
Aadd(aHeader,{"Item",        "UM","@!" ,06,0,".F.","","N","SZU"})
Aadd(aHeader,{"Responsavel" ,"UM","@!" ,15,0,".F.","","C","SZU"})
Aadd(aHeader,{"Nivel",       "UM","@!" ,01,0,".F.","","N","SZU"})

@ 100,041 To 470,575 Dialog dlgComp Title "Status da Solicitacao de Compras"
@ 007,010 Say OemToAnsi("Nr.SC:") Size 35,8
@ 007,067 Say OemToAnsi("Item:") Size 30,8
@ 007,118 Say OemToAnsi("Emissao:") Size 35,8
@ 007,185 Say OemToAnsi("Previsao:") Size 35,8

@ 005,030 Get _cSc1Num  Size 20,8 When .F.
@ 005,080 Get _cSc1Item Size 20,8 When .F.
@ 005,142 Get _dSc1Emi  Size 30,8 When .F.
@ 005,210 Get _dSc1Prf  Size 30,8 When .F.

@ 020,10 TO 145,260 MULTILINE MODIFY OBJECT oMultiline
oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline
@ 170,170 Button "_Grava" SIZE 40,10 Action fGrava()
@ 170,218 Button "_Cancelar" SIZE 40,10 Action fFecha()

Activate Dialog dlgComp Centered

DbSelectArea("DET")	
DbCloseArea("DET")

Return


Static Function fGrava()
Local i
ZAA->(DbSetOrder(1))

	For i := 1 To Len(aCols)
		ZAA->(DbSeek(xFilial("ZAA") + aCols[i,1]))
		If ZAA->(Found())
			If Alltrim(aCols[i,1]) <> Alltrim(aCols[i,4])
				DbSelectArea("SZU")
				SZU->(DbSeek(xFilial("SZU")+aCols[i,2]+aCols[i,3]))
				While Szu->(!Eof()) .And. SZU->ZU_NUM+SZU->ZU_ITEM == aCols[i,2]+aCols[i,3]
					If Alltrim(SZU->ZU_LOGIN) == Alltrim(aCols[i,4])
						RecLock("SZU",.F.)
							SZU->ZU_LOGIN := aCols[i,1]
						MsUnlock("SZU")
					Endif
					SZU->(DbSkip())
				Enddo	
			Endif
        Else
			MsgBox("Aprovador nao cadastro, Verifique !","Altera aprovador","Alert")
		Endif	

	Next
	Close(dlgComp)
Return



User Function fImpStat()
_aGrupo   := pswret()
_cLogin   := _agrupo[1,2] 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= "NHCOM041"
cPerg:= ""
SetPrint("SZ3",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")


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
DbCloseArea("TZU")

Return


Static Function Imprime()
Local _nZxVlpago := 0, _cNumero, _cNmbanco := Space(40)
Local _cDescStatus := Space(10)
Local _cDescFuncao := Space(20)
Local _Lszu := .F.
Local L := 0
fGeraDet()

DbSelectArea("TZU")
TZU->(Dbgotop())
                        
Cabec1    := "               Nr.Sc    Item  Produto             Descricao                                   Quantidade          V.Unitario               Total Solicitante    Emissao   Anexo     Aprovador        Status       Dt.Aprov."
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

While !TZU->(Eof())
	
	If Prow() > 56
		nPag := nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif

	SC1->(DbSeek(xFilial("SC1")+TZU->ZU_NUM+TZU->ZU_ITEM))
	If SC1->(Found()) .And. Empty(SC1->C1_PEDIDO)

		@ Prow() + 1, 015 Psay 	SC1->C1_NUM
		@ Prow()    , 024 Psay 	SC1->C1_ITEM
		@ Prow()    , 030 Psay  SC1->C1_PRODUTO
		@ Prow()    , 050 Psay 	Substr(SC1->C1_DESCRI,1,30)
		@ Prow()    , 090 Psay 	SC1->C1_QUANT Picture "@E 9,999,999.9999"
		@ Prow()    , 110 Psay 	SC1->C1_VUNIT Picture "@E 999,999,999.99"
		@ Prow()    , 130 Psay 	(SC1->C1_QUANT * SC1->C1_VUNIT) Picture "@E 999,999,999.99"
		@ Prow()    , 145 Psay 	Substr(SC1->C1_SOLICIT,1,10)
		@ Prow()    , 157 Psay 	SC1->C1_EMISSAO
		@ Prow()    , 170 Psay 	IIf(Empty(SC1->C1_ANEXO1),"  ","Sim")

		SZU->(DbSetOrder(2))
		SZU->(DbSeek(xFilial("SZU")+SC1->C1_NUM+SC1->C1_ITEM))
		l := 0
		If SZU->(Found())

			While !SZU->(Eof()) .And. SZU->ZU_NUM+SZU->ZU_ITEM == SC1->C1_NUM+SC1->C1_ITEM

				_cDescStatus := Space(10)
				_cDescFuncao := Space(20)
				If SZU->ZU_STATUS == "A"
					_cDescStatus :=  "Aprovado  "
				Elseif SZU->ZU_STATUS == "B"			
					_cDescStatus :=  "Aguardando"
				Elseif SZU->ZU_STATUS == "C"			
					_cDescStatus :=  "Rejeitado "
				Endif	
				QAA->(DbSetOrder(6))
				QAA->(DbSeek(SZU->ZU_LOGIN))
				If QAA->(Found())
					SRJ->(DbSeek(xFilial("SRJ")+QAA->QAA_CODFUN))
					If SRJ->(Found())
						_cDescFuncao := SRJ->RJ_DESC
					Endif
				Endif
	 		  	@ Prow()+l,180 psay SZU->ZU_LOGIN
	 		  	@ Prow()  ,197 psay _cDescStatus
	 		  	@ Prow()  ,210 psay SZU->ZU_DATAPR
				l := 1
				SZU->(DbSkip())
			Enddo
		Endif
		@ Prow()+1,000 Psay __PrtThinLine()

	Endif
	TZU->(DbSkip())

Enddo
@ Prow() + 1,000 Psay __PrtThinLine()

Return

Static Function fGeraDet()

	cQuery := "SELECT * FROM " + RetSqlName( 'SZU' ) + " ZU " 
	cQuery += " WHERE ZU.ZU_FILIAL = '"	 + xFilial("SZU")+ "' "
	cQuery += " AND ZU.ZU_LOGIN = '" + _cLogin + "' "
	cQuery += " AND D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY 1,2,3,5 " 

	//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TZU"
	TcSetField("TZU","ZU_DATAPR","D")  // Muda a data de string para date

Return
