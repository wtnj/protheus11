/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MA125BUT    ³Autor³ Alexandre R. Bento    ³ Data ³28.07.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta uma tela de Integracao com as Solicitacoes/Contratos ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Perguntas ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Compras                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#include "rwmake.ch"
#include "Topconn.ch"

User Function MA125BUT()
Local aBotao := {}
Local xP := 0
Local nC3Rec := SC3->(Recno()) //guarda a posicao do sc3

//Aadd(aBotao	, {'SOLICITA',{||FSolic() },OemToAnsi('Solicita')})

SetKey( VK_F4, { || FSolic() } )	

IF ALTERA
//	Aadd(aBotao	, {'DBG09',{||FRevis() },OemToAnsi('Revisao')})   

	SB1->(dbSetOrder(1))//FILIAL + COD
	cNum := SC3->C3_NUM

	//-- altera todos os produtos no campo b1_contrat como 's'
	WHILE SC3->(!EOF()) .AND. SC3->C3_NUM==cNum
		If SB1->(dbSeek(xFilial("SB1")+SC3->C3_PRODUTO))
			Reclock("SB1",.F.)
				SB1->B1_CONTRAT := 'S'
			MsUnlock("SB1")
		EndIf
		SC3->(dbskip())
	ENDDO

	SC3->(dbGoTo(nC3Rec)) //retorna a posicao do sc3

ENDIF

IF !INCLUI
	Aadd(aBotao , {'PROJETPMS',{||fHist() },OemToAnsi('Historico')})
ENDIF

Return(aBotao)

Static Function FSolic()
Local   aHeader := {}
Local   aCols   := {} 
Local  _lStatus := .T.
Local   nMax    := 0
Private _aSol   := {} 
Private nOpc    := 0
Private bOk     := {||nOpc:=1,_SolNor:End()}
Private bCancel := {||nOpc:=0,_SolNor:End()} 
Private oDlg    := Nil
Private _nPos   := 0 
Private oLbx    := Nil

Processa({|| GeraSol() }, OemToAnsi("Busca Solicitação"))

TMP->(DBGotop())       
If Empty(TMP->C1_NUM)
   MsgBox(OemToAnsi("Nenhuma Solicitação Encontrada Arquivo"),OemToAnsi("Atenção"),"ALERT") 
   DbSelectArea("SC3")
   TMP->(DbCloseArea()) //Fecha a area da consulta
   return
Endif

TMP->(DBGotop())       
SZU->(DbSetOrder(2))             
While !TMP->(EOF())
    _lStatus := .T.
	SZU->(DbSeek(xFilial("SZU")+TMP->C1_NUM+TMP->C1_ITEM))
	While !SZU->(Eof()) .And. SZU->ZU_NUM+SZU->ZU_ITEM == TMP->C1_NUM+TMP->C1_ITEM
	   If SZU->ZU_STATUS$"B/C" 
          _lStatus := .F.
	   	  Exit
	   Endif
  
	   If Empty(SZU->ZU_STATUS) .And. Val(SZU->ZU_NIVEL) < 9
          _lStatus := .F.
	   	  Exit
	   Endif	  
       SZU->(Dbskip())
 	Enddo  
 	If _lStatus
       Aadd(_aSol,{TMP->C1_NUM,TMP->C1_ITEM,TMP->C1_PRODUTO+Subs(TMP->C1_DESCRI,1,35),;
       Transform(TMP->C1_QUANT,"@E 999999999.99"),DTOC(TMP->C1_EMISSAO)})
    Endif        
   
   TMP->(Dbskip())
Enddo   

If Len(_aSol) == 0 
   MsgBox(OemToAnsi("Nenhuma Solicitação Encontrada"),OemToAnsi("Atenção"),"ALERT") 
   DbSelectArea("SC3")
   TMP->(DbCloseArea()) //Fecha a area da consulta
   return
Endif     

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
DEFINE MSDIALOG oDlg TITLE "Solicitacao de Contrato" FROM 0,0 TO 420,730 PIXEL

@ 20,10 LISTBOX oLbx FIELDS HEADER ;
   "Solicitacao", "Item", "Produto", "Quantidade","Data Emissao" ;
   SIZE 350,180 OF oDlg PIXEL ON DBLCLICK( u_fListSol(oLbx:nAt),oDlg:End())
  
oLbx:SetArray( _aSol )
//oLbx:bLine := {||{_aF4[oLbx:nAt]}}    

oLbx:bLine := {|| {_aSol[oLbx:nAt,1],; //Solicitaçao
                   _aSol[oLbx:nAt,2],; // Item
                   _aSol[oLbx:nAt,3],; // Produto
                   _aSol[oLbx:nAt,4],; // Qtde                   
                   _aSol[oLbx:nAt,5]}} // Data emissao
oLbx:Refresh()                   

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||U_fListSol(oLbx:nAt),nOpc:=1,oDlg:End(),.T.},{||oDlg:End()})

//If nOpc == 1      
//  _nPos := oLbx:nAt
//Endif
DbSelectArea("SC3")
TMP->(DbCloseArea()) //Fecha a area da consulta                              
Return .T.

User Function fListSol(_nPos)

Local _cNumSC   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_NUMSC"}) 
Local _cItemSC  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_ITEMSC"}) 
Local _cProd    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_PRODUTO"}) 
Local _cDescri  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_DESCRI"}) 
Local _nQtde    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_QUANT"}) 
Local _nLocal   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_LOCAL"}) 
Local _nCC      := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_CC"}) 
Local _nConta   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_CONTA"}) 
Local _nUM      := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_UM"}) 
Local _nOBS     := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_OBS"}) 
Local _nPreco   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_PRECO"}) 
Local _nTotal   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_TOTAL"}) 

//Local _dData  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_EMISSAO"}) 

DbSelectArea("SC3")
//Alert( " estou aqui EDLIST" )
If !Acols[n][len(aHeader)+1]  //nao pega quando a linha esta deletada
    Acols[n][_cNumSC]    := _aSol[_nPos,1]
    Acols[n][_cItemSC]   := _aSol[_nPos,2]
    Acols[n][_cProd]     := Subs(_aSol[_nPos,3],1,15)    
    Acols[n][_cDescri]   := Subs(_aSol[_nPos,3],16,35)    
    Acols[n][_nQtde]     := Val(_aSol[_nPos,4])            
    M->C3_QUANT          := Acols[n][_nQtde]    
//    Acols[n][_dData]   := _aSol[_nPos,5]        
	SC1->(DbSeek(xFilial("SC1")+_aSol[_nPos,1]+_aSol[_nPos,2]))
    Acols[n][_nLocal]    := SC1->C1_LOCAL
    Acols[n][_nCC]       := SC1->C1_CC
    Acols[n][_nConta]    := SC1->C1_CONTA    
    Acols[n][_nUM]       := SC1->C1_UM        
    Acols[n][_nOBS]      := SC1->C1_OBS    

	If SB1->(DbSeek(xFilial("SB1")+Acols[n][_cProd]))
	     Acols[n][_nPreco]  := SB1->B1_UPRC 
	     Acols[n][_nTotal]  := Acols[n][_nQtde] * SB1->B1_UPRC         
	Endif     
    M->C3_PRECO  := Acols[n][_nPreco]
    
//    aHeader[_nTotal][6] := "A125Total(M->C3_TOTAL)"
    
//   If oGetDados<>Nil
//     	oGetDados:oBrowse:Refresh()
//   EndIf   
//   A125Frefresh(n)

Endif      
oLbx:Refresh() // atualiza a matriz p/ mostrar em tela
Return(.T.)

Static Function Gerasol()
Local cQuery

cQuery := "SELECT SC1.C1_NUM,SC1.C1_ITEM,SC1.C1_PRODUTO,SC1.C1_DESCRI,(SC1.C1_QUANT - SC1.C1_QUJE) AS 'C1_QUANT',* "
cQuery += "FROM " +  RetSqlName( 'SC1' ) +" SC1 "
cQuery += "WHERE SC1.C1_FILIAL = '" + xFilial("SC1")+ "' " 
cQuery += "AND SC1.D_E_L_E_T_ =  ' ' "
cQuery += "AND SC1.C1_CONTRAT = 'S' "   
cQuery += "AND (SC1.C1_QUANT - SC1.C1_QUJE) > 0 "   
cQuery += "ORDER BY SC1.C1_NUM,SC1.C1_ITEM"

//TCQuery Abre uma workarea com o resultado da query
//MemoWrit('C:\TEMP\MA125BUT.SQL',cQuery)
TCQUERY cQuery NEW ALIAS "TMP"      
TcSetField("TMP","C1_EMISSAO","D")  // Muda a data de string para date    

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³EXIBE HISTORICO DAS REVISOES ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fHist()

Local aFixe :=   { 	{ "Numero"      ,"ZB2_NUM"    },;		        //"Numero"
                    { "Emissao"     ,"ZB2_EMISSA" },;		        //"Emissao"
                    { "Produto"     ,"ZB2_PRODUT" },;		        //"Produto"
                    { "Dt. Entrega" ,"ZB2_DATPRF" },;		        //"Dt. Entrega"
                    { "Fornecedor"  ,"ZB2_FORNEC" },;		        //"Fornecedor"
                    { "Qt. Entregue","ZB2_QUJE"   } }		        //"Qt. Entregue"

Private cCadastro
Private aRotina

cCadastro := OemToAnsi('Histórico dos Pedidos em Aberto')

aRotina := {{ "Visualizar"  ,"U_fVisuZB2()",0,2}}
           
DbSelectArea("ZB2")
ZB2->(DbSetOrder(1))
DbGoTop()
            
mBrowse(06,01,22,75,"ZB2",aFixe,,,,,{{'' ,'DISABLE'}})   

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VISUALIZA ITEM DO HISTORICO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function fVisuZB2()  
Local _aItem := {}
Local _cNum
Local _cRev
Local _CPDesc
Local cDescMoed
Local _nRec
Local nMoeda

//+-------------------------------------------------------+
//| Monta a tela para usuario visualizar o Ped. em Aberto |
//+-------------------------------------------------------+
DEFINE MSDIALOG oDlg TITLE "Historico do Pedido em Aberto - Visualizacao" FROM 0,0 TO 420,730 PIXEL

@ 015,010 TO 060,360 OF oDlg PIXEL

@ 020,015 Say OemToAnsi("Número: ")  Size 040,8 Object olNum
@ 020,045 Get ZB2->ZB2_NUM WHEN .F.  Size 040,8 Object oNum
@ 020,140 Say OemToAnsi("Emissão: ") Size 040,8 Object olEmissao
@ 020,180 Get DtoC(ZB2->ZB2_EMISSA)  Size 040,8 Object oEmissao
@ 020,260 Say OemToAnsi("Fornecedor: ") Size 040,8 Object olForn
@ 020,295 Get ZB2->ZB2_FORNEC when .f.  Size 040,8 Object oForn
@ 020,335 Get ZB2->ZB2_LOJA   when .f.  Size 005,8 Object oForn

@ 032,015 Say OemToAnsi("Cond. Pgto: ") Size 040,8 Object olCond
@ 032,045 Get ZB2->ZB2_COND when .f.  Size 020,8 Object oCond

SE4->(DBSETORDER(1))
SE4->(DBSEEK(XFILIAL('SE4')+ZB2->ZB2_COND))
_CPDesc := SE4->E4_DESCRI 

@ 032,070 Get _CPDesc when .f.  Size 060,8 Object oCondDesc
@ 032,140 Say "Contato: " Size 040,8 Object olContat
@ 032,180 Get ZB2->ZB2_CONTAT when .f.  Size 060,8 Object oCond

@ 032,260 Say "Filial p/ Entrega: " Size 040,8 Object olFilEnt
@ 032,335 Get ZB2->ZB2_FILENT when .f.  Size 005,8 Object oFilEnt

nMoeda    := ZB2->ZB2_MOEDA
cDescMoed := SuperGetMv("MV_MOEDA"+AllTrim(Str(nMoeda,2)))

@ 044,015 Say OemToAnsi("Moeda: ") Size 040,8 Object olCond
@ 044,045 Get ZB2->ZB2_MOEDA when .f.  Size 020,8 Object oCond
@ 044,070 Get cDescMoed when .f.  Size 060,8 Object oCondDesc

@ 044,140 Say "Transportadora: " Size 040,8 Object olTransp
@ 044,180 Get ZB2->ZB2_TRANSP when .f.  Size 040,8 Object oTransp

@ 044,260 Say OemToAnsi("Data Revisão: ") Size 040,8 Object olRev
@ 044,295 Get ZB2->ZB2_DATARE when .f.  Size 040,8 Object oDataRev
@ 044,335 Get ZB2->ZB2_NUMREV when .f.  Size 005,8 Object oNumRev

@ 065,10 LISTBOX oLbx FIELDS HEADER ;
   "Item", "Produto", "Descricao","Quantidade","Unidade","Dt. Inicial","Dt. Final", ;
   "Prc Unitario","Sigla","Vlr. Total","Aliq. IPI","Almoxarifado","Observacoes",;
   "Num. Solicita","Item Solicit","Transportado","Cond. Entrega","Num Revisao","C.Custo",;
   "Data Revisao","Grupo Aprov.","Conta","Grade","Item Grade","Segunda UM","Qtd. 2a UM";
   SIZE 350,120 OF oDlg PIXEL 

_cNum := ZB2->ZB2_NUM  
_cRev := ZB2->ZB2_NUMREV

_nRec := ZB2->(RecNo())
While  ZB2->ZB2_NUM == _cNum .AND. ZB2->ZB2_NUMREV == _cRev
 		aAdd(_aItem, {ZB2->ZB2_ITEM,;
	              ZB2->ZB2_PRODUT,;
                  ZB2->ZB2_DESCRI,;
                  ZB2->ZB2_QUANT,;
                  ZB2->ZB2_UM,;
                  ZB2->ZB2_DATPRI,;
                  ZB2->ZB2_DATPRF,;
                  ZB2->ZB2_PRECO,;
                  ZB2->ZB2_SIGLA,;
                  ZB2->ZB2_TOTAL,;
                  ZB2->ZB2_IPI,;
                  ZB2->ZB2_LOCAL,;
                  ZB2->ZB2_MSG,;
                  ZB2->ZB2_NUMSC,;
                  ZB2->ZB2_ITEMSC,;
                  ZB2->ZB2_TRANSP,;
                  ZB2->ZB2_ENTREG,;
                  ZB2->ZB2_NUMREV,;
                  ZB2->ZB2_CC,;
                  ZB2->ZB2_DATARE,;
                  ZB2->ZB2_APROV,;
                  ZB2->ZB2_CONTA,;
                  ZB2->ZB2_GRADE,;
                  ZB2->ZB2_ITEMGR,;
                  ZB2->ZB2_SEGUM,;
                  ZB2->ZB2_QTSEGU})

	ZB2->(DbSkip())
enddo
oLbx:SetArray( _aItem )

ZB2->(DbGoTo(_nRec))

oLbx:bLine := {|| {_aItem[oLbx:nAt,1],;  // ZB2->ZB2_ITEM
	               _aItem[oLbx:nAt,2],;  // ZB2->ZB2_PRODUT
	               _aItem[oLbx:nAt,3],;  // ZB2->ZB2_DESCRI
                   _aItem[oLbx:nAt,4],;  // ZB2->ZB2_QUANT
                   _aItem[oLbx:nAt,5],;  // ZB2->ZB2_UM
                   _aItem[oLbx:nAt,6],;  // ZB2->ZB2_DATPRI
                   _aItem[oLbx:nAt,7],;  // ZB2->ZB2_DATPRF
                   _aItem[oLbx:nAt,8],;  // ZB2->ZB2_PRECO
                   _aItem[oLbx:nAt,9],;  // ZB2->ZB2_SIGLA
                   _aItem[oLbx:nAt,10],; // ZB2->ZB2_TOTAL
                   _aItem[oLbx:nAt,11],; // ZB2->ZB2_IPI
                   _aItem[oLbx:nAt,12],; // ZB2->ZB2_LOCAL
                   _aItem[oLbx:nAt,13],; // ZB2->ZB2_MSG
                   _aItem[oLbx:nAt,14],; // ZB2->ZB2_NUMSC
                   _aItem[oLbx:nAt,15],; // ZB2->ZB2_ITEMSC
                   _aItem[oLbx:nAt,16],; // ZB2->ZB2_TRANSP
                   _aItem[oLbx:nAt,17],; // ZB2->ZB2_ENTREG
                   _aItem[oLbx:nAt,18],; // ZB2->ZB2_NUMREV
                   _aItem[oLbx:nAt,19],; // ZB2->ZB2_CC
                   _aItem[oLbx:nAt,20],; // ZB2->ZB2_DATARE
                   _aItem[oLbx:nAt,21],; // ZB2->ZB2_APROV
                   _aItem[oLbx:nAt,22],; // ZB2->ZB2_CONTA
                   _aItem[oLbx:nAt,23],; // ZB2->ZB2_GRADE
                   _aItem[oLbx:nAt,24],; // ZB2->ZB2_ITEMGR
                   _aItem[oLbx:nAt,25],; // ZB2->ZB2_SEGUM
                   _aItem[oLbx:nAt,26]}} // ZB2->ZB2_QTSEGU
                   
oLbx:Refresh()                   

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End(),.T.},{||oDlg:End()})

Return