#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE2.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ANALISE   ∫Autor  ≥Reinaldo Dias       ∫ Data ≥  19/08/2005 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Rotina analisar movimentacao e saldo em estoque.           ∫±±
±±∫          ≥ Controle de lote e localizacao ativo.                      ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP8                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function NHEST157()            
Local oDlgMain    
Local aArea          := GetArea()
Local oNoMarked      := LoaDBitmap( GetResources(), "LBNO" )
Local oMarked        := LoaDBitmap( GetResources(), "LBOK" )
Private cPict        := PesqPict('SB2','B2_QATU')
Private cPict2UM     := PesqPict('SB2','B2_QTSEGUM')
Private cPictD5      := PesqPict('SD5','D5_QUANT')
Private cPictDB      := PesqPict('SDB','DB_QUANT')
Private cPictB1      := PesqPict('SB1','B1_CONV')
Private aDetSB8      := {}
Private aDetSD5      := {}
Private aDetSBF      := {}
Private aDetSDB      := {}
Private aDetSBJ      := {}
Private aAnaSBJ      := {}
Private aDetSBK      := {}
Private aAnaSBK      := {}
Private aDetDASDA    := {}
Private aDetDASB8    := {}
Private aDet01B8BF   := {}
Private aDet02B8BF   := {}
Private aKarLocal    := {}
Private aKarLote     := {}
Private aKarEnde     := {}                                               
//Private aDocto       := {}
Private aNumSeq      := {}
Private cLocal       := Space(02)                                
Private dDtProces    := dDataBase
Private dUltFech     := dDataI := dDataF := CTOD("  /  /  ")
Private nSB9         := 0
Private nSBJ         := 0
Private nSBK         := 0
Private nKAR         := 0
Private nSD5         := 0
Private nSDB         := 0
Private nSB2         := 0
Private nSB8         := 0
Private nSBF         := 0
Private nSDA         := 0
Private nDASB2       := 0
Private nEmpSB2       := 0
Private nDASB8       := 0
Private nSldKarLocal := nSldKarLote := nSldKarEnde := 0
Private cProduto     := Space(15)    
Private cDescr       := Space(40)
Private nOpSB8       := 1
Private nOpSBF       := 1
Private cMensagem    := ""
Private cMensSB8     := ""
Private cMensSBF     := ""        
Private cCrlLot      := ""        
Private cCrlEnd      := ""        
Private c1UM         := ""
Private c2UM         := ""
Private nFatConv     := 0
Private cTipConv     := ""
Private cZona        := ""
Private aSx3Box      := RetSx3Box(Posicione('SX3',2,'BE_STATUS','X3CBox()'),,,1)
Private cMensB8BF    := ""
Private cMensBJBK    := ""
Private cMensDocto   := ""
Private cMensNumSeq  := ""
Private cMensDAB8    := ""
Private _lReturn     := .F.
Private oSB9
Private oSBJ
Private oSBK
Private oKAR
Private oSD5
Private oSDB
Private oSB2
Private oSB8
Private oSBF
Private oSDA    
Private oDASB2  
Private oEmpSB2
Private oDASB8  
Private lNumLote := SuperGetMV('MV_LOTEUNI', .F., .F.)

Aadd(aDetSB8   ,{CTOD("  /  /  "),Space(10),Space(06),CTOD("  /  /  "),0,0,Space(08),0,0,0})
Aadd(aDetSD5   ,{CTOD("  /  /  "),Space(03),Space(10),Space(06),CTOD("  /  /  "),0,0,Space(06),Space(08),Space(06),Space(03),Space(06),Space(02),Space(01)})
Aadd(aDetSBF   ,{Space(15),Space(10),0,Space(08),0,Space(01),Space(01),Space(01),0,0,Space(01)})
Aadd(aDetSDB   ,{Space(03),CTOD("  /  /  "),Space(03),Space(15),Space(10),0,0,Space(06),Space(08),Space(06),Space(03),Space(06),Space(02),Space(01)})
Aadd(aDet01B8BF,{Space(10),0,0,0,0,0,0,Space(08)})
Aadd(aDet02B8BF,{Space(10),0,0,0,0,Space(08)})
Aadd(aDetSBJ   ,{Space(10),0,0,Space(08)})
Aadd(aAnaSBJ   ,{Space(10),Space(06),CTOD("  /  /  "),0,Space(08)})
Aadd(aDetSBK   ,{Space(10),0,0,Space(08)})
Aadd(aAnaSBK   ,{Space(15),Space(10),0,Space(08)})
Aadd(aDetDASDA ,{CTOD("  /  /  "),Space(10),0,0,0,Space(06),Space(03),Space(06),Space(03),Space(06),Space(02),Space(08)})
Aadd(aDetDASB8 ,{CTOD("  /  /  "),Space(10),Space(06),0,0,Space(03),Space(06),Space(03),Space(06),Space(02),Space(08),Space(01)})
//Aadd(aDocto    ,{Space(06),Space(03),Space(06),Space(02),0,0,0,0,0,0,0,0,Space(03),Space(08),Space(03),Space(01),Space(01)})
Aadd(aNumSeq   ,{Space(06),0,0,0,0,0,0,0,0,Space(03),Space(08),CTOD("  /  /  "),Space(06),Space(03),Space(06),Space(02),Space(03),Space(01),Space(01)})
AAdd(aKarLocal ,{Space(03),Space(08),Space(03),Space(03),Space(06),Space(01),Space(01),Space(06)})
AAdd(aKarLote  ,{Space(03),Space(08),Space(03),Space(06),Space(06),Space(08),Space(08),Space(01),Space(01),Space(30),Space(01)})
AAdd(aKarEnde  ,{Space(03),Space(08),Space(03),Space(06),Space(15),Space(01),Space(01),Space(01),Space(06),Space(01)})
                                                                                                                 
IF !fDigSenha()
   Return
Endif

DEFINE MSDIALOG oDlgMain TITLE "Analise de Saldos"  OF oMainWnd PIXEL FROM 040,040 TO 650,1000
DEFINE FONT oBold   NAME "Arial" SIZE 0, -12 BOLD
DEFINE FONT oBold2  NAME "Arial" SIZE 0, -40 BOLD

DBSelectArea("SB1")

@ 060,006 FOLDER oFolder OF oDlgMain PROMPT "&Saldo","SB8 x SD5","SBF x SDB","SB8 x SBF","SBJ x SBK","SBJ","SBK","SDA x SB2 x SB8","Kardex por Local","Kardex por Lote","Kardex por EndereÁo","Num.Seq." PIXEL SIZE 470,241
//                                           01       02        03        04        05        06    07    08            09             10            11                13
@ 014,010 SAY "Produto"                                 SIZE 040,10 PIXEL OF oDlgMain FONT oBold 
@ 010,040 MSGET oVar   VAR cProduto Picture "@!"        SIZE 060,10 PIXEL OF oDlgMain F3 "SB1" VALID(GetDescProd())
@ 010,105 MSGET oVar   VAR cDescr   Picture "@!"        SIZE 176,10 PIXEL OF oDlgMain When .F.
@ 032,010 SAY "Local"                                   SIZE 040,10 PIXEL OF oDlgMain FONT oBold 
@ 028,040 MSGET oVar   VAR cLocal Picture "!!"          SIZE 010,10 PIXEL OF oDlgMain VALID(GetDatas()) 
@ 049,010 SAY "Limite"                                  SIZE 070,10 PIXEL OF oDlgMain FONT oBold 
@ 045,040 MSGET oVar   VAR dDtProces Picture "99/99/99" SIZE 040,10 PIXEL OF oDlgMain VALID(GetDatas()) 

@ 032,095 SAY "1 UM"                                    SIZE 070,10 PIXEL OF oDlgMain FONT oBold
@ 028,114 MSGET oVar   VAR c1UM      Picture "@!"       SIZE 015,10 PIXEL OF oDlgMain When .F.
@ 032,150 SAY "2 UM"                                    SIZE 070,10 PIXEL OF oDlgMain FONT oBold
@ 028,190 MSGET oVar   VAR c2UM      Picture "@!"       SIZE 015,10 PIXEL OF oDlgMain When .F.
@ 032,210 SAY "Fat.Conv."                               SIZE 070,10 PIXEL OF oDlgMain FONT oBold
@ 028,240 MSGET oVar   VAR cTipConv  Picture "!"        SIZE 008,10 PIXEL OF oDlgMain When .F.
@ 028,251 MSGET oVar   VAR nFatConv  Picture cPictB1    SIZE 030,10 PIXEL OF oDlgMain When .F.

@ 014,300 SAY "Ultimo Fechamento"                       SIZE 070,10 PIXEL OF oDlgMain FONT oBold 
@ 010,365 MSGET oVar   VAR dUltFech  Picture "99/99/99" SIZE 040,10 PIXEL OF oDlgMain When .F.
@ 029,300 SAY "Data Inicial"                            SIZE 070,10 PIXEL OF oDlgMain FONT oBold 
@ 025,365 MSGET oVar   VAR dDataI    Picture "99/99/99" SIZE 040,10 PIXEL OF oDlgMain When .F.
@ 044,300 SAY "Data Final"                              SIZE 070,10 PIXEL OF oDlgMain FONT oBold 
@ 040,365 MSGET oVar   VAR dDataF    Picture "99/99/99" SIZE 040,10 PIXEL OF oDlgMain When .F.

@ 049,095 SAY "Lote"                                    SIZE 040,10 PIXEL OF oDlgMain FONT oBold 
@ 045,114 MSGET oVar   VAR cCrlLot   Picture "@!"       SIZE 025,10 PIXEL OF oDlgMain When .F.
@ 049,150 SAY "LocalizaÁ„o"                             SIZE 040,10 PIXEL OF oDlgMain FONT oBold 
@ 045,190 MSGET oVar   VAR cCrlEnd   Picture "@!"       SIZE 015,10 PIXEL OF oDlgMain When .F.
@ 049,210 SAY "Zona"                                    SIZE 040,10 PIXEL OF oDlgMain FONT oBold 
@ 045,240 MSGET oVar   VAR cZona     Picture "@!"       SIZE 041,10 PIXEL OF oDlgMain When .F.

@ 022,015 TO 087, 095 PROMPT "Saldo Inicial"             PIXEL OF oFolder:aDialogs[1]
@ 034,020 SAY "SB9"                          SIZE 015,10 PIXEL OF oFolder:aDialogs[1] FONT oBold 
@ 030,035 MSGET oSB9  VAR nSB9 Picture cPict SIZE 050,10 PIXEL OF oFolder:aDialogs[1] When .F. 
@ 054,020 SAY "SBJ"                          SIZE 015,10 PIXEL OF oFolder:aDialogs[1] FONT oBold 
	@ 050,035 MSGET oSBJ  VAR nSBJ Picture cPict SIZE 050,10 PIXEL OF oFolder:aDialogs[1] When .F.
@ 074,020 SAY "SBK"                          SIZE 015,10 PIXEL OF oFolder:aDialogs[1] FONT oBold 
@ 070,035 MSGET oSBK  VAR nSBK Picture cPict SIZE 050,10 PIXEL OF oFolder:aDialogs[1] When .F.

@ 022,115 TO 087, 195 PROMPT "Saldo MovimentaÁ„o"        PIXEL OF oFolder:aDialogs[1]
@ 034,120 SAY "SD3"                          SIZE 015,10 PIXEL OF oFolder:aDialogs[1] FONT oBold 
@ 030,135 MSGET oKAR  VAR nKAR Picture cPict SIZE 050,10 PIXEL OF oFolder:aDialogs[1] When .F. 
@ 054,120 SAY "SD5"                          SIZE 015,10 PIXEL OF oFolder:aDialogs[1] FONT oBold 
@ 050,135 MSGET oSD5  VAR nSD5 Picture cPict SIZE 050,10 PIXEL OF oFolder:aDialogs[1] When .F.
@ 074,120 SAY "SDB"                          SIZE 015,10 PIXEL OF oFolder:aDialogs[1] FONT oBold 
@ 070,135 MSGET oSDB  VAR nSDB Picture cPict SIZE 050,10 PIXEL OF oFolder:aDialogs[1] When .F.
  
@ 022,215 TO 087, 295 PROMPT "Saldo Atual"               PIXEL OF oFolder:aDialogs[1] 
@ 034,220 SAY "SB2"                          SIZE 015,10 PIXEL OF oFolder:aDialogs[1] FONT oBold 
@ 030,235 MSGET oSB2  VAR nSB2 Picture cPict SIZE 050,10 PIXEL OF oFolder:aDialogs[1] When .F. 
@ 054,220 SAY "SB8"                          SIZE 015,10 PIXEL OF oFolder:aDialogs[1] FONT oBold 
@ 050,235 MSGET oSB8  VAR nSB8 Picture cPict SIZE 050,10 PIXEL OF oFolder:aDialogs[1] When .F.
@ 074,220 SAY "SBF"                          SIZE 015,10 PIXEL OF oFolder:aDialogs[1] FONT oBold 
@ 070,235 MSGET oSBF  VAR nSBF Picture cPict SIZE 050,10 PIXEL OF oFolder:aDialogs[1] When .F.

@ 022,315 TO 167, 440 PROMPT "Divergencias"              PIXEL OF oFolder:aDialogs[1] 
@ 034,320 SAY cMensBJBK                      SIZE 120,10 PIXEL OF oFolder:aDialogs[1] FONT oBold  COLOR CLR_HRED
@ 054,320 SAY cMensB8BF                      SIZE 120,10 PIXEL OF oFolder:aDialogs[1] FONT oBold  COLOR CLR_HRED
@ 074,320 SAY cMensDAB8                      SIZE 120,10 PIXEL OF oFolder:aDialogs[1] FONT oBold  COLOR CLR_HRED
@ 094,320 SAY cMensDocto                     SIZE 120,10 PIXEL OF oFolder:aDialogs[1] FONT oBold  COLOR CLR_HRED
@ 114,320 SAY cMensNumSeq                    SIZE 120,10 PIXEL OF oFolder:aDialogs[1] FONT oBold  COLOR CLR_HRED
@ 134,320 SAY cMensSB8                       SIZE 120,10 PIXEL OF oFolder:aDialogs[1] FONT oBold  COLOR CLR_HRED
@ 154,320 SAY cMensSBF                       SIZE 120,10 PIXEL OF oFolder:aDialogs[1] FONT oBold  COLOR CLR_HRED

//@ 220,002 SAY "Sugestıes e melhorias para Reinaldo Dias e-mail: rdias@totvs.com.br"   SIZE 200,10 PIXEL OF oFolder:aDialogs[1] FONT oBold  COLOR CLR_HBLUE
@ 220,410 SAY "Vers„o: 28/12/2010"                                                    SIZE 200,10 PIXEL OF oFolder:aDialogs[1] FONT oBold  COLOR CLR_HBLUE
                                                                          
@ 092,015 TO 157, 095 PROMPT "Saldo a Classificar"         PIXEL OF oFolder:aDialogs[1] 
@ 114,020 SAY "SB2"                             SIZE 015,10 PIXEL OF oFolder:aDialogs[1] FONT oBold 
@ 110,035 MSGET oDASB2 VAR nDASB2 Picture cPict SIZE 050,10 PIXEL OF oFolder:aDialogs[1] When .F. 
@ 134,020 SAY "SB8"                             SIZE 015,10 PIXEL OF oFolder:aDialogs[1] FONT oBold 
@ 130,035 MSGET oDASB8 VAR nDASB8 Picture cPict SIZE 050,10 PIXEL OF oFolder:aDialogs[1] When .F.
@ 154,020 SAY "SDA"                             SIZE 015,10 PIXEL OF oFolder:aDialogs[1] FONT oBold 
@ 150,035 MSGET oSDA   VAR nSDA   Picture cPict SIZE 050,10 PIXEL OF oFolder:aDialogs[1] When .F.  


// ADICIONADO EM 28/05/2014 - DOUGLAS DOURADO - EMPENHO NO B2 ---

@ 160,015 TO 190, 095 PROMPT "Empenho.:"          PIXEL OF oFolder:aDialogs[1] 
@ 175,020 SAY "SB2"                             SIZE 015,10 PIXEL OF oFolder:aDialogs[1] FONT oBold 
@ 171,035 MSGET oEmpSB2 VAR nEmpSB2 Picture cPict SIZE 050,10 PIXEL OF oFolder:aDialogs[1] When .F. 
@ 169,115 BUTTON  "Confirmar Empenho" SIZE 60,12 ACTION fAjustEmp("EMPENHO_SB2") PIXEL OF oFolder:aDialogs[1]

// --------------------------------------------------------------

@ 092,115 TO 157, 295 PROMPT "Status do Saldo"             PIXEL OF oFolder:aDialogs[1]                                      

@ 120,134 SAY oSay VAR cMensagem                       SIZE 200,50 PIXEL OF oFolder:aDialogs[1] FONT oBold2 COLOR CLR_HBLUE 

/*
@ 022,315 LISTBOX oBox Var cFolder FIELDS HEADER " ", "Folder") SIZE 090,120 ON DBLCLICK (TrocaTip()) PIXEL OF oFolder:aDialogs[1] 
oBox:nFreeze := 1
oBox:SetArray(aFolder)
oBox:bLine:={ ||{IIF(aFolder[oBox:nAT,1],oMarked,oNoMarked),aFolder[oBox:nAT,2]}}

@ 030,410 BUTTON  "Marcar Todos")    SIZE 50,12 ACTION MarcaTodos(.T.) PIXEL OF oFolder:aDialogs[1]
@ 050,410 BUTTON  "Desmarcar Todos") SIZE 50,12 ACTION MarcaTodos(.F.) PIXEL OF oFolder:aDialogs[1]
*/

@ 005,015 BUTTON  "Confirmar SB9" SIZE 50,12 ACTION fAjustSB9("SALDO_SB9") PIXEL OF oFolder:aDialogs[1]
@ 005,115 BUTTON  "Saldo Atual" SIZE 50,12 ACTION fSaldoAtual()          PIXEL OF oFolder:aDialogs[1]
@ 005,215 BUTTON  "Confirmar SB2" SIZE 50,12 ACTION fAjustSB2("SALDO_SB2") PIXEL OF oFolder:aDialogs[1]
                                                                                                      
@ 005,315 BUTTON  "<<" SIZE 20,12 ACTION fRetINI(.T.) PIXEL OF oFolder:aDialogs[1]
@ 005,340 BUTTON  ">>" SIZE 20,12 ACTION fRetINI()    PIXEL OF oFolder:aDialogs[1]

@ 005,365 BUTTON  "Cria EndereÁo" SIZE 45,12 ACTION MATA805() PIXEL OF oFolder:aDialogs[1]
@ 005,415 BUTTON  "Manut. Lote"   SIZE 45,12 ACTION MATA390() PIXEL OF oFolder:aDialogs[1]

//-- ADICIONADO POR JOAOFR (FECHAMENTO)

@ 169,215 BUTTON  "FECHAMENTO" SIZE 50,12 ACTION fFechamento() PIXEL OF oFolder:aDialogs[1]
@ 183,215 BUTTON  "Refaz Ac." SIZE 50,12 ACTION mata215() PIXEL OF oFolder:aDialogs[1]

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FOLDER 02
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Detalhe do SB8            
cB8xD5 := "B8=>D5"
@ 003,005 SAY "SB8"                SIZE 50,50                                                      PIXEL OF oFolder:aDialogs[2] FONT oBold
@ 001,030 BUTTON "SB8 => SD5"      SIZE 30,10 ACTION (cB8xD5 := "B8=>D5",Processa({||fDetaSB8()})) PIXEL OF oFolder:aDialogs[2]
@ 001,075 BUTTON "Incluir"         SIZE 30,10 ACTION (fAjustSB8("B8_I"))                           PIXEL OF oFolder:aDialogs[2] When IF(nOpSB8=1,.T.,.F.)
@ 001,120 BUTTON "Alterar"         SIZE 30,10 ACTION (fAjustSB8("B8_A"))                           PIXEL OF oFolder:aDialogs[2] When IF(nOpSB8=1,.T.,.F.)
@ 001,165 BUTTON "Excluir"         SIZE 30,10 ACTION (fAjustSB8("B8_E"))                           PIXEL OF oFolder:aDialogs[2] When IF(nOpSB8=1,.T.,.F.)
@ 001,320 BUTTON "Lote e Num.Lote" SIZE 40,10 ACTION (nOpSB8:= 1,Processa({||fDetaSB8()}))         PIXEL OF oFolder:aDialogs[2] When IF(nOpSB8=2,.T.,.F.)
@ 001,375 BUTTON "Lote"            SIZE 30,10 ACTION (nOpSB8:= 2,Processa({||fDetaSB8()}))         PIXEL OF oFolder:aDialogs[2] When IF(nOpSB8=1,.T.,.F.)
@ 001,420 BUTTON "Pesquisar"       SIZE 30,10 ACTION (fPesquisa("SB8",oDetSB8))                    PIXEL OF oFolder:aDialogs[2]
@ 010,005 LISTBOX oDetSB8 Var cModelo FIELDS HEADER; 
     "Data"   ,;
     "Lote"   ,;
	 "Num.Lote" ,;
	 "Validade" ,;
	 "Saldo" ,;
	 "Qtde.Original" ,; 
	 "Status" ,;
	 "Empenho" ,;			
	 "Qtde.2UM" ,;	
	 "Empenho 2UM" FIELDSIZES 30,40,30,30,40,40,35,40,40,40 SIZE 459,110 ON DBLCLICK () PIXEL OF oFolder:aDialogs[2]
   	 oDetSB8:SetArray(aDetSB8)
     oDetSB8:bLDblClick := {|| Processa({||fMontaSD5()})} 
	 oDetSB8:bLine:={ ||{aDetSB8[oDetSB8:nAT,1],aDetSB8[oDetSB8:nAT,2],aDetSB8[oDetSB8:nAT,3],aDetSB8[oDetSB8:nAT,4],aDetSB8[oDetSB8:nAT,5],aDetSB8[oDetSB8:nAT,6],aDetSB8[oDetSB8:nAT,7],aDetSB8[oDetSB8:nAT,8],aDetSB8[oDetSB8:nAT,9],aDetSB8[oDetSB8:nAT,10]}}
	 oDetSB8:Refresh()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Detalhe do SD5
@ 123,005 SAY "SD5"                 SIZE 50,50                                                      PIXEL OF oFolder:aDialogs[2] FONT oBold
@ 121,030 BUTTON "SD5 => SB8"       SIZE 30,10 ACTION (cB8xD5 := "D5=>B8",Processa({||fDetaSD5()})) PIXEL OF oFolder:aDialogs[2]
@ 121,075 BUTTON "Incluir D5"       SIZE 30,10 ACTION (fAjustSD5("D5_I","02"))                      PIXEL OF oFolder:aDialogs[2] When IF(nOpSB8=1,.T.,.F.)
@ 121,120 BUTTON "Alterar D5"       SIZE 30,10 ACTION (fAjustSD5("D5_A","02"))                      PIXEL OF oFolder:aDialogs[2] When IF(nOpSB8=1,.T.,.F.)
@ 121,165 BUTTON "Excluir D5"       SIZE 30,10 ACTION (fAjustSD5("D5_E","02"))                      PIXEL OF oFolder:aDialogs[2] When IF(nOpSB8=1,.T.,.F.)
@ 121,210 BUTTON "Incluir D5+B8"    SIZE 40,10 ACTION (fAjustSD5("D5+B8_I","02"))                   PIXEL OF oFolder:aDialogs[2] When IF(nOpSB8=1,.T.,.F.)
@ 121,265 BUTTON "Subtrair D5+B8"   SIZE 40,10 ACTION (fAjustSD5("D5+B8_S","02"))                   PIXEL OF oFolder:aDialogs[2] When IF(nOpSB8=1,.T.,.F.)
@ 121,320 BUTTON "Estornar D5+B8"   SIZE 40,10 ACTION (fAjustSD5("D5+B8_E","02"))                   PIXEL OF oFolder:aDialogs[2] When IF(nOpSB8=1,.T.,.F.)
@ 121,375 BUTTON "Analisar"         SIZE 30,10 ACTION (Processa({||fMontaSB8(.F.)}))                PIXEL OF oFolder:aDialogs[2] When IF(nOpSB8=1,.T.,.F.)
@ 121,420 BUTTON "Pesquisar"        SIZE 30,10 ACTION (fPesquisa("SD5",oDetSD5))                    PIXEL OF oFolder:aDialogs[2]

@ 130,005 LISTBOX oDetSD5 Var cDetSD5 FIELDS HEADER; 
     "Data" ,;
	 "TM" ,;
     "Lote" ,;
	 "Num.Lote" ,;
	 "Validade" ,;
	 "Quantidade" ,;	
	 "Saldo" ,;
	 "Num.Seq." ,;
	 "Status" ,;
     "Documento" ,;
     "Serie" ,;
     "Clie.For" ,;
     "Loja" FIELDSIZES 30,15,40,30,30,40,40,30,35,32,20,30,20 SIZE 459,095 ON DBLCLICK () PIXEL OF oFolder:aDialogs[2]
	 oDetSD5:SetArray(aDetSD5)
     oDetSD5:bLDblClick := {|| Processa({||fMontaSB8(.T.)})} 
	 oDetSD5:bLine:={ ||{aDetSD5[oDetSD5:nAT,1],aDetSD5[oDetSD5:nAT,2],aDetSD5[oDetSD5:nAT,3],aDetSD5[oDetSD5:nAT,4],aDetSD5[oDetSD5:nAT,5],aDetSD5[oDetSD5:nAT,6],aDetSD5[oDetSD5:nAT,7],aDetSD5[oDetSD5:nAT,8],aDetSD5[oDetSD5:nAT,9],aDetSD5[oDetSD5:nAT,10],aDetSD5[oDetSD5:nAT,11],aDetSD5[oDetSD5:nAT,12],aDetSD5[oDetSD5:nAT,13]}}
	 oDetSD5:Refresh()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FOLDER 03
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Detalhe do SBF
cBFxDB := "BF=>DB"
@ 003,005 SAY "SBF"                SIZE 50,50                                                      PIXEL OF oFolder:aDialogs[3] FONT oBold
@ 001,030 BUTTON "SBF => SDB"      SIZE 30,10 ACTION (cBFxDB := "BF=>DB",Processa({||fDetaSBF()})) PIXEL OF oFolder:aDialogs[3]
@ 001,075 BUTTON "Incluir"         SIZE 30,10 ACTION (fAjustSBF("BF_I"))                           PIXEL OF oFolder:aDialogs[3] When IF(nOpSBF=1,.T.,.F.)
@ 001,120 BUTTON "Alterar"         SIZE 30,10 ACTION (fAjustSBF("BF_A"))                           PIXEL OF oFolder:aDialogs[3] When IF(nOpSBF=1,.T.,.F.)
@ 001,165 BUTTON "Excluir"         SIZE 30,10 ACTION (fAjustSBF("BF_E"))                           PIXEL OF oFolder:aDialogs[3] When IF(nOpSBF=1,.T.,.F.)
@ 001,420 BUTTON "Pesquisar"       SIZE 30,10 ACTION (fPesquisa("SBF",oDetSBF))                    PIXEL OF oFolder:aDialogs[3]
@ 010,005 LISTBOX oDetSBF Var cModelo FIELDS HEADER; 
     "LocalizaÁ„o",;
	 "Lote" ,;
	 "Quantidade" ,;
	 "Status" ,;
	 "Empenho" ,;			
	 "Estrutura" ,;
	 "Status End" ,;
	 "Zona" ,;
	 "Qtde.2UM" ,;	
	 "Empenho 2UM" FIELDSIZES 50,40,40,35,40,60,40,30,40,40 SIZE 459,110 ON DBLCLICK () PIXEL OF oFolder:aDialogs[3]
  	 oDetSBF:SetArray(aDetSBF)
    oDetSBF:bLDblClick := {|| Processa({||fMontaSDB()})} 
	 oDetSBF:bLine:={ ||{aDetSBF[oDetSBF:nAT,1],aDetSBF[oDetSBF:nAT,2],aDetSBF[oDetSBF:nAT,3],aDetSBF[oDetSBF:nAT,4],aDetSBF[oDetSBF:nAT,5],aDetSBF[oDetSBF:nAT,6],aDetSBF[oDetSBF:nAT,7],aDetSBF[oDetSBF:nAT,8],aDetSBF[oDetSBF:nAT,9],aDetSBF[oDetSBF:nAT,10]}}
	 oDetSBF:Refresh()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Detalhe do SDB
@ 123,005 SAY "SDB"                 SIZE 50,50                                                      PIXEL OF oFolder:aDialogs[3] FONT oBold
@ 121,030 BUTTON "SDB => SBF"       SIZE 30,10 ACTION (cBFxDB := "DB=>BF",Processa({||fDetaSDB()})) PIXEL OF oFolder:aDialogs[3]
@ 121,075 BUTTON "Incluir DB"       SIZE 30,10 ACTION (fAjustSDB("DB_I","03"))                      PIXEL OF oFolder:aDialogs[3] When IF(nOpSBF=1,.T.,.F.)
@ 121,120 BUTTON "Alterar DB"       SIZE 30,10 ACTION (fAjustSDB("DB_A","03"))                      PIXEL OF oFolder:aDialogs[3] When IF(nOpSBF=1,.T.,.F.)
@ 121,165 BUTTON "Excluir DB"       SIZE 30,10 ACTION (fAjustSDB("DB_E","03"))                      PIXEL OF oFolder:aDialogs[3] When IF(nOpSBF=1,.T.,.F.)
@ 121,210 BUTTON "Incluir DB+BF"    SIZE 40,10 ACTION (fAjustSDB("DB+BF_I","03"))                   PIXEL OF oFolder:aDialogs[3] When IF(nOpSBF=1,.T.,.F.)
@ 121,265 BUTTON "Subtrair DB+BF"   SIZE 40,10 ACTION (fAjustSDB("DB+BF_S","03"))                   PIXEL OF oFolder:aDialogs[3] When IF(nOpSBF=1,.T.,.F.)
@ 121,320 BUTTON "Estornar DB+BF"   SIZE 40,10 ACTION (fAjustSDB("DB+BF_E","03"))                   PIXEL OF oFolder:aDialogs[3] When IF(nOpSBF=1,.T.,.F.)
@ 121,375 BUTTON "Analisar"         SIZE 30,10 ACTION (Processa({||fMontaSBF(.F.)}))                PIXEL OF oFolder:aDialogs[3] When IF(nOpSBF=1,.T.,.F.)
@ 121,420 BUTTON "Pesquisar"        SIZE 30,10 ACTION (fPesquisa("SDB",oDetSDB))                    PIXEL OF oFolder:aDialogs[3]
@ 130,005 LISTBOX oDetSDB Var cDetSDB FIELDS HEADER; 
	 "Origem" ,;
     "Data" ,;
	 "TM" ,;
	 "LocalizaÁ„o" ,;
     "Lote" ,;
	 "Quantidade" ,;	
	 "Saldo" ,;
	 "Num.Seq." ,;
     "Status" ,;	
     "Documento" ,;
     "Serie" ,;
     "Clie.For" ,;
     "Loja" FIELDSIZES 25,30,15,50,40,40,40,30,35,32,20,30,20 SIZE 459,095 ON DBLCLICK () PIXEL OF oFolder:aDialogs[3]
	 oDetSDB:SetArray(aDetSDB)
     oDetSDB:bLDblClick := {|| Processa({||fMontaSBF(.T.)})} 
	 oDetSDB:bLine:={ ||{aDetSDB[oDetSDB:nAT,1],aDetSDB[oDetSDB:nAT,2],aDetSDB[oDetSDB:nAT,3],aDetSDB[oDetSDB:nAT,4],aDetSDB[oDetSDB:nAT,5],aDetSDB[oDetSDB:nAT,6],aDetSDB[oDetSDB:nAT,7],aDetSDB[oDetSDB:nAT,8],aDetSDB[oDetSDB:nAT,9],aDetSDB[oDetSDB:nAT,10],aDetSDB[oDetSDB:nAT,11],aDetSDB[oDetSDB:nAT,12],aDetSDB[oDetSDB:nAT,13]}}
 	 oDetSDB:Refresh()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FOLDER 04
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Detalhe do SB8
@ 003,005 SAY "SB8"                SIZE 50,50                                          PIXEL OF oFolder:aDialogs[4] FONT oBold
@ 001,420 BUTTON "Processar"       SIZE 30,10 ACTION (Processa({||fDetaB8BF()}))        PIXEL OF oFolder:aDialogs[4]
@ 010,005 LISTBOX oDet01B8BF Var cModelo FIELDS HEADER; 
	 "Lote" ,;
	 "Qtde." ,;
	 "Empenho" ,;
	 "A Classificar" ,;
	 "Qtde.2UM" ,;
	 "Empenho 2UM" ,;
	 "A Classificar 2UM" ,;
	 "Status" FIELDSIZES 40,40,40,40,40,40,40,35 SIZE 459,110 ON DBLCLICK () PIXEL OF oFolder:aDialogs[4]
   	 oDet01B8BF:SetArray(aDet01B8BF)
	 oDet01B8BF:bLine:={ ||{aDet01B8BF[oDet01B8BF:nAT,1],aDet01B8BF[oDet01B8BF:nAT,2],aDet01B8BF[oDet01B8BF:nAT,3],aDet01B8BF[oDet01B8BF:nAT,4],aDet01B8BF[oDet01B8BF:nAT,5],aDet01B8BF[oDet01B8BF:nAT,6],aDet01B8BF[oDet01B8BF:nAT,7],aDet01B8BF[oDet01B8BF:nAT,8]}}
	 oDet01B8BF:Refresh()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Detalhe do SBF
@ 123,005 SAY "SBF"                   SIZE 50,50  PIXEL OF oFolder:aDialogs[4] FONT oBold
@ 130,005 LISTBOX oDet02B8BF Var cDet02B8BF FIELDS HEADER; 
     "Lote" ,;
	 "Qtde." ,;
	 "Empenho" ,;
	 "Qtde.2UM" ,;
	 "Empenho 2UM" ,;
     "Status" FIELDSIZES 40,40,40,40,40,35 SIZE 459,095 ON DBLCLICK () PIXEL OF oFolder:aDialogs[4]
	 oDet02B8BF:SetArray(aDet02B8BF)
	 oDet02B8BF:bLine:={ ||{aDet02B8BF[oDet02B8BF:nAT,1],aDet02B8BF[oDet02B8BF:nAT,2],aDet02B8BF[oDet02B8BF:nAT,3],aDet02B8BF[oDet02B8BF:nAT,4],aDet02B8BF[oDet02B8BF:nAT,5],aDet02B8BF[oDet02B8BF:nAT,6]}}
	 oDet02B8BF:Refresh()


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FOLDER 05
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Detalhe do SBJ
@ 003,005 SAY "SBJ"                 SIZE 50,50                                                          PIXEL OF oFolder:aDialogs[5] FONT oBold
@ 001,420 BUTTON "Processar"        SIZE 30,10 ACTION (Processa({||fDetaBJBK(),fDetaSBJ(),fDetaSBK()})) PIXEL OF oFolder:aDialogs[5]
@ 010,005 LISTBOX oDetSBJ Var cModelo FIELDS HEADER; 
	 "Lote" ,;
	 "Qtde." ,;
	 "Qtde.2UM" ,;
	 "Status" FIELDSIZES 40,40,40,35 SIZE 459,110 ON DBLCLICK () PIXEL OF oFolder:aDialogs[5]
	 oDetSBJ:SetArray(aDetSBJ)
	 oDetSBJ:bLine:={ ||{aDetSBJ[oDetSBJ:nAT,1],aDetSBJ[oDetSBJ:nAT,2],aDetSBJ[oDetSBJ:nAT,3],aDetSBJ[oDetSBJ:nAT,4]}}
	 oDetSBJ:Refresh()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Detalhe do SBK
@ 123,005 SAY "SBK"                   SIZE 50,50 PIXEL OF oFolder:aDialogs[5] FONT oBold
@ 130,005 LISTBOX oDetSBK Var cDet02B8BK FIELDS HEADER; 
     "Lote" ,;
	 "Qtde." ,;
	 "Qtde.2UM" ,;
	 "Status" FIELDSIZES 40,40,40,35 SIZE 459,095 ON DBLCLICK () PIXEL OF oFolder:aDialogs[5]
	 oDetSBK:SetArray(aDetSBK)
	 oDetSBK:bLine:={ ||{aDetSBK[oDetSBK:nAT,1],aDetSBK[oDetSBK:nAT,2],aDetSBK[oDetSBK:nAT,3],aDetSBK[oDetSBK:nAT,4]}}
	 oDetSBK:Refresh()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FOLDER 06
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Detalhe do SBJ
@ 003,005 SAY "SBJ"                SIZE 50,50                                   PIXEL OF oFolder:aDialogs[6] FONT oBold
@ 001,210 BUTTON "Incluir"         SIZE 30,10 ACTION (fAjustSBJ("BJ_I"))        PIXEL OF oFolder:aDialogs[6]
@ 001,265 BUTTON "Alterar"         SIZE 30,10 ACTION (fAjustSBJ("BJ_A"))        PIXEL OF oFolder:aDialogs[6]
@ 001,320 BUTTON "Excluir"         SIZE 30,10 ACTION (fAjustSBJ("BJ_E"))        PIXEL OF oFolder:aDialogs[6]
@ 001,375 BUTTON "Processar"       SIZE 30,10 ACTION (Processa({||fDetaSBJ()})) PIXEL OF oFolder:aDialogs[6]
@ 001,420 BUTTON "Pesquisar"       SIZE 30,10 ACTION (fPesquisa("SBJ",oAnaSBJ)) PIXEL OF oFolder:aDialogs[6]
@ 010,005 LISTBOX oAnaSBJ Var cModelo FIELDS HEADER; 
	 "Lote" ,;
	 "Nunlote" ,;
	 "Validade" ,;
	 "Quantidade" FIELDSIZES 40,30,30,40 SIZE 459,215 ON DBLCLICK () PIXEL OF oFolder:aDialogs[6]
	 oAnaSBJ:SetArray(aAnaSBJ)
	 oAnaSBJ:bLine:={ ||{aAnaSBJ[oAnaSBJ:nAT,1],aAnaSBJ[oAnaSBJ:nAT,2],aAnaSBJ[oAnaSBJ:nAT,3],aAnaSBJ[oAnaSBJ:nAT,4]}}
     oAnaSBJ:Refresh()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FOLDER 07
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Detalhe do SBK
@ 123,005 SAY "SBK"                SIZE 50,50                                   PIXEL OF oFolder:aDialogs[7] FONT oBold
@ 001,210 BUTTON "Incluir"         SIZE 30,10 ACTION (fAjustSBK("BK_I"))        PIXEL OF oFolder:aDialogs[7]
@ 001,265 BUTTON "Alterar"         SIZE 30,10 ACTION (fAjustSBK("BK_A"))        PIXEL OF oFolder:aDialogs[7]
@ 001,320 BUTTON "Excluir"         SIZE 30,10 ACTION (fAjustSBK("BK_E"))        PIXEL OF oFolder:aDialogs[7]
@ 001,375 BUTTON "Processar"       SIZE 30,10 ACTION (Processa({||fDetaSBK()})) PIXEL OF oFolder:aDialogs[7] 
@ 001,420 BUTTON "Pesquisar"       SIZE 30,10 ACTION (fPesquisa("SBK",oAnaSBK)) PIXEL OF oFolder:aDialogs[7]
@ 010,005 LISTBOX oAnaSBK Var cDet02B8BK FIELDS HEADER; 
     "Endereco" ,;
     "Lote" ,;
	 "Quantidade" FIELDSIZES 50,40,40 SIZE 459,215 ON DBLCLICK () PIXEL OF oFolder:aDialogs[7]
	 oAnaSBK:SetArray(aAnaSBK)
	 oAnaSBK:bLine:={ ||{aAnaSBK[oAnaSBK:nAT,1],aAnaSBK[oAnaSBK:nAT,2],aAnaSBK[oAnaSBK:nAT,3]}}
     oAnaSBK:Refresh()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FOLDER 08
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Detalhe do SDAxsSB2xSB8
@ 003,005 SAY "SDA"                                SIZE 50,50                                     PIXEL OF oFolder:aDialogs[8] FONT oBold
@ 003,070 SAY "Saldo a Classificar no SB2 : "+Trans(nDASB2,cPict) SIZE 150,50                     PIXEL OF oFolder:aDialogs[8] FONT oBold
@ 001,220 BUTTON "Alterar no SB2"                  SIZE 45,10 ACTION (fAjustSB2("CLASS_SB2"))     PIXEL OF oFolder:aDialogs[8] 
@ 001,320 BUTTON "Alterar no SDA"                  SIZE 45,10 ACTION (fAjustSDA("SDA"))           PIXEL OF oFolder:aDialogs[8] 
@ 001,420 BUTTON "Processar"                       SIZE 30,10 ACTION (Processa({||fDetaSDA(),fDetaDASB8()})) PIXEL OF oFolder:aDialogs[8] 
@ 010,005 LISTBOX oDetDASDA Var cModelo FIELDS HEADER; 
     "Data" ,;
     "Lote" ,;
	 "A Classificar" ,;	
	 "Saldo" ,;
	 "Qtde.Original" ,;	
	 "Num.Seq." ,;
	 "Origem" ,;
     "Documento" ,;
     "Serie" ,;
     "Clie.For" ,;
     "Loja" ,; 
     "Status" FIELDSIZES 30,40,40,40,40,30,25,32,20,30,20,35 SIZE 459,110 ON DBLCLICK () PIXEL OF oFolder:aDialogs[8]
	 oDetDASDA:SetArray(aDetDASDA)
	 oDetDASDA:bLine:={ ||{aDetDASDA[oDetDASDA:nAT,1],aDetDASDA[oDetDASDA:nAT,2],aDetDASDA[oDetDASDA:nAT,3],aDetDASDA[oDetDASDA:nAT,4],aDetDASDA[oDetDASDA:nAT,5],aDetDASDA[oDetDASDA:nAT,6],aDetDASDA[oDetDASDA:nAT,7],aDetDASDA[oDetDASDA:nAT,8],aDetDASDA[oDetDASDA:nAT,9],aDetDASDA[oDetDASDA:nAT,10],aDetDASDA[oDetDASDA:nAT,11],aDetDASDA[oDetDASDA:nAT,12]}}
	 oDetDASDA:Refresh()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Detalhe do SDAxsSB2xSB8
@ 123,005 SAY "SB8"            SIZE 200,50                              PIXEL OF oFolder:aDialogs[8] FONT oBold
@ 121,420 BUTTON "Alterar"     SIZE 30,10 ACTION (fAjustDAB8("DAxB8"))  PIXEL OF oFolder:aDialogs[8]
@ 130,005 LISTBOX oDetDASB8 Var cDet02B8BK FIELDS HEADER; 
     "Data" ,;
     "Lote" ,;
     "Num.Lote" ,;
	 "A Classificar" ,;	
	 "Qtde.Original" ,;	
	 "Origem" ,;
     "Documento" ,;
     "Serie" ,;
     "Clie.For" ,;
     "Loja" ,; 
     "Status" FIELDSIZES 30,40,30,40,40,25,32,20,30,20,35  SIZE 459,095 ON DBLCLICK () PIXEL OF oFolder:aDialogs[8]
	 oDetDASB8:SetArray(aDetDASB8)
	 oDetDASB8:bLine:={ ||{aDetDASB8[oDetDASB8:nAT,1],aDetDASB8[oDetDASB8:nAT,2],aDetDASB8[oDetDASB8:nAT,3],aDetDASB8[oDetDASB8:nAT,4],aDetDASB8[oDetDASB8:nAT,5],aDetDASB8[oDetDASB8:nAT,6],aDetDASB8[oDetDASB8:nAT,7],aDetDASB8[oDetDASB8:nAT,8],aDetDASB8[oDetDASB8:nAT,9],aDetDASB8[oDetDASB8:nAT,10],aDetDASB8[oDetDASB8:nAT,11]}}
     oDetDASB8:Refresh()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FOLDER 09
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Kardex - Almoxarifado
@ 003,005 SAY "Saldo Final : "+Trans(nSldKarLocal,cPict) SIZE 200,50                                    PIXEL OF oFolder:aDialogs[9] FONT oBold
@ 001,420 BUTTON "Processar"                             SIZE 30,10 ACTION (Processa({||fKardLocal()})) PIXEL OF oFolder:aDialogs[9]
@ 010,005 LISTBOX oKarLocal Var cModelo FIELDS HEADER; 
     "Origem" ,;
	 "Data" ,;
	 "TES/TM" ,;
	 "CFO" ,;
	 "Documento" ,;
	 "Quantidade" ,;	
	 "Saldo" ,;   
	 "Num.Seq." FIELDSIZES 25,40,30,20,32,40,40,30 SIZE 459,215 ON DBLCLICK () PIXEL OF oFolder:aDialogs[9]
	 oKarLocal:SetArray(aKarLocal)
	 oKarLocal:bLine:={ ||{aKarLocal[oKarLocal:nAT,1],aKarLocal[oKarLocal:nAT,2],aKarLocal[oKarLocal:nAT,3],aKarLocal[oKarLocal:nAT,4],aKarLocal[oKarLocal:nAT,5],aKarLocal[oKarLocal:nAT,6],aKarLocal[oKarLocal:nAT,7],aKarLocal[oKarLocal:nAT,8]}}
     oKarLocal:Refresh()
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FOLDER 10
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Kardex - Lote
@ 003,005 SAY "Saldo Final : "+Trans(nSldKarLote,cPict) SIZE 200,50                                                PIXEL OF oFolder:aDialogs[10] FONT oBold
@ 001,100 BUTTON "Pesquisa DiferenÁa - PrÛxima"         SIZE 080,10 ACTION (fPesqDifLote("Prox"))                  PIXEL OF oFolder:aDialogs[10]
@ 001,200 BUTTON "Pesquisa DiferenÁa - Anterior"        SIZE 080,10 ACTION (fPesqDifLote("Ante"))                  PIXEL OF oFolder:aDialogs[10]
@ 001,420 BUTTON "Processar"                            SIZE 030,10 ACTION (Processa({||fDetaSB8(),fKardLote()}))  PIXEL OF oFolder:aDialogs[10]
@ 010,005 LISTBOX oKarLote Var cModelo FIELDS HEADER; 
     "Origem" ,;
	 "Data" ,;
	 "TM" ,;
	 "Documento" ,;
	 "Lote" ,;	
	 "Num.Lote" ,;	
	 "Validade" ,;
	 "Quantidade" ,;   			
	 "Saldo" ,;   
	 "Num.Seq." FIELDSIZES 25,30,15,32,40,30,30,40,40,40 SIZE 459,215 ON DBLCLICK () PIXEL OF oFolder:aDialogs[10]
	 oKarLote:bLDblClick := {|| Processa({||fPesqNumSeq("Lote")})} 
	 oKarLote:SetArray(aKarLote)
	 oKarLote:bLine:={ ||{aKarLote[oKarLote:nAT,1],aKarLote[oKarLote:nAT,2],aKarLote[oKarLote:nAT,3],aKarLote[oKarLote:nAT,4],aKarLote[oKarLote:nAT,5],aKarLote[oKarLote:nAT,6],aKarLote[oKarLote:nAT,7],aKarLote[oKarLote:nAT,8],aKarLote[oKarLote:nAT,9],aKarLote[oKarLote:nAT,10]}}
     oKarLote:Refresh()
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FOLDER 11
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Kardex - Localizacao
@ 003,005 SAY "Saldo Final : "+Trans(nSldKarEnde,cPict) SIZE 200,50                                              PIXEL OF oFolder:aDialogs[11] FONT oBold
@ 001,100 BUTTON "Pesquisa DiferenÁa - PrÛxima"         SIZE 080,10 ACTION (fPesqDifEnde("Prox"))                PIXEL OF oFolder:aDialogs[11]
@ 001,200 BUTTON "Pesquisa DiferenÁa - Anterior"        SIZE 080,10 ACTION (fPesqDifEnde("Ante"))                PIXEL OF oFolder:aDialogs[11]
@ 001,420 BUTTON "Processar"                            SIZE 030,10 ACTION (Processa({||fDetaSBF(),fKardEnde()})) PIXEL OF oFolder:aDialogs[11]
@ 010,005 LISTBOX oKarEnde Var cModelo FIELDS HEADER; 
     "Origem" ,;
	 "Data" ,;
	 "TM" ,;
	 "Documento" ,;
	 "LocalizaÁ„o" ,;		
	 "Lote" ,;	
	 "Quantidade" ,;   			
	 "Saldo" ,;   
	 "Num.Seq." FIELDSIZES 25,30,15,32,50,40,40,40,40 SIZE 459,215 ON DBLCLICK () PIXEL OF oFolder:aDialogs[11]
     oKarEnde:bLDblClick := {|| Processa({||fPesqNumSeq("Ende")})} 
	 oKarEnde:SetArray(aKarEnde)
	 oKarEnde:bLine:={ ||{aKarEnde[oKarEnde:nAT,1],aKarEnde[oKarEnde:nAT,2],aKarEnde[oKarEnde:nAT,3],aKarEnde[oKarEnde:nAT,4],aKarEnde[oKarEnde:nAT,5],aKarEnde[oKarEnde:nAT,6],aKarEnde[oKarEnde:nAT,7],aKarEnde[oKarEnde:nAT,8],aKarEnde[oKarEnde:nAT,9]}}
     oKarEnde:Refresh()
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FOLDER 12
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Documento
/*
@ 001,040 BUTTON "Somente Movimento Com DiferenÁa"     SIZE 100,10 ACTION (Processa({||fSoDocto()})) PIXEL OF oFolder:aDialogs[12]
@ 001,375 BUTTON "Processar"        SIZE 30,10 ACTION (Processa({||fAnaliseDoc(),fDetaSDA()}))       PIXEL OF oFolder:aDialogs[12]
@ 001,420 BUTTON "Pesquisar"        SIZE 30,10 ACTION (fPesquisa("DOCTO",oDocto))                    PIXEL OF oFolder:aDialogs[12]
@ 010,005 LISTBOX oDocto Var cModelo FIELDS HEADER; 
     "Documento" ,;
     "Serie" ,;
     "Cli/For" ,;
     "Loja" ,;
	 "SD1" ,;
	 "SD2" ,;
     "SD3_E" ,;
	 "SD3_S" ,;
	 "SD5_E" ,;
	 "SD5_S" ,;	
	 "SDB_E" ,;
     "SDB_S" ,;    
	 "Origem" ,;
	 "Status" ,;  
	 "ServiÁo" ,;
	 "Status ServiÁo" ,;
     "ServiÁo Pendente"  SIZE 459,215 ON DBLCLICK () PIXEL OF oFolder:aDialogs[12]
	 oDocto:SetArray(aDocto)
     oDocto:bLine:={ ||{aDocto[oDocto:nAT,1],aDocto[oDocto:nAT,2],aDocto[oDocto:nAT,3],aDocto[oDocto:nAT,4],aDocto[oDocto:nAT,5],aDocto[oDocto:nAT,6],aDocto[oDocto:nAT,7],aDocto[oDocto:nAT,8],aDocto[oDocto:nAT,9],aDocto[oDocto:nAT,10],aDocto[oDocto:nAT,11],aDocto[oDocto:nAT,12],aDocto[oDocto:nAT,13],aDocto[oDocto:nAT,14],aDocto[oDocto:nAT,15],aDocto[oDocto:nAT,16],aDocto[oDocto:nAT,17]}}
     oDocto:Refresh()
*/    
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FOLDER 12
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// NumSeq
@ 001,040 BUTTON "Somente Movimento Com DiferenÁa"     SIZE 100,10 ACTION (Processa({||fSoNumSeq()})) PIXEL OF oFolder:aDialogs[12]
@ 001,180 BUTTON "Incluir SD5"     SIZE 30,10 ACTION (fAjustSD5("D5_I","13"))                         PIXEL OF oFolder:aDialogs[12]
@ 001,240 BUTTON "Incluir SDB"     SIZE 30,10 ACTION (fAjustSDB("DB_I","13"))                         PIXEL OF oFolder:aDialogs[12]
@ 001,300 BUTTON "_Alterar"         SIZE 30,10 ACTION (fAjustD5DB("D5DB_A"))                           PIXEL OF oFolder:aDialogs[12]
@ 001,375 BUTTON "Processar"       SIZE 30,10 ACTION (Processa({||fNumSeq(),fDetaSDA()}))             PIXEL OF oFolder:aDialogs[12]
@ 001,420 BUTTON "Pesquisar"       SIZE 30,10 ACTION (fPesquisa("NUMSEQ",oNumSeq))                    PIXEL OF oFolder:aDialogs[12]
@ 010,005 LISTBOX oNumSeq Var cModelo FIELDS HEADER; 
     "Num.Seq." ,;
	 "SD1" ,;
	 "SD2" ,;
	 "SD3_E" ,;
	 "SD3_S" ,;
	 "SD5_E" ,;
	 "SD5_S" ,;	
	 "SDB_E" ,;
	 "SDB_S" ,;	
	 "Origem" ,;
	 "Status" ,;  
	 "Data" ,;       
	 "Documento" ,;  
	 "Serie" ,;  
	 "Clie.Forn" ,;  
	 "Loja" ,;  
	 "ServiÁo" ,;
	 "Status ServiÁo" ,;
     "ServiÁo Pendente"  SIZE 459,215 ON DBLCLICK () PIXEL OF oFolder:aDialogs[12]
   oNumSeq:bLDblClick := {|| Processa({||fPesqKarEnd()})}      
	oNumSeq:SetArray(aNumSeq)
	oNumSeq:bLine:={ ||{aNumSeq[oNumSeq:nAT,1],aNumSeq[oNumSeq:nAT,2],aNumSeq[oNumSeq:nAT,3],aNumSeq[oNumSeq:nAT,4],aNumSeq[oNumSeq:nAT,5],aNumSeq[oNumSeq:nAT,6],aNumSeq[oNumSeq:nAT,7],aNumSeq[oNumSeq:nAT,8],aNumSeq[oNumSeq:nAT,9],aNumSeq[oNumSeq:nAT,10],aNumSeq[oNumSeq:nAT,11],aNumSeq[oNumSeq:nAT,12],aNumSeq[oNumSeq:nAT,13],aNumSeq[oNumSeq:nAT,14],aNumSeq[oNumSeq:nAT,15],aNumSeq[oNumSeq:nAT,16],aNumSeq[oNumSeq:nAT,17],aNumSeq[oNumSeq:nAT,18],aNumSeq[oNumSeq:nAT,19]}}
   oNumSeq:Refresh()
    
@ 010,420 BUTTON "&Processar"   SIZE 36,16 PIXEL ACTION Processa({||fProcessa()})
@ 040,420 BUTTON "&Sair"        SIZE 36,16 PIXEL ACTION oDlgMain:End()

ACTIVATE MSDIALOG oDlgMain  CENTERED

RestArea(aArea)        

Return(.T.)




///------------------ made by JOAOFR 20/05/2013
Static Function FRETINI(lRet)

Default lRet := .F.

	//Alert(dtoc(ddatai)+cProduto+cLocal)
	
	if !lRet .and. empty(dultfech) .and. msgyesno("Retornar todos os fechamentos?")

		cQuery := " UPDATE "+RetSqlName("SB9") 
		cQuery += "	SET D_E_L_E_T_ = '"+(Iif(lRet,'*',''))+"'"
		cQuery += "	WHERE B9_COD = '"+cProduto+"'"
		cQuery += "	AND B9_LOCAL = '"+cLocal+"'"
		cQuery += "	AND B9_FILIAL = '"+xFilial("SB9")+"'"
		
		cQuery += "	UPDATE "+RetSqlName("SBK")
		cQuery += "	SET D_E_L_E_T_ = '"+(Iif(lRet,'*',''))+"'"
		cQuery += "	WHERE BK_COD = '"+cProduto+"'"
		cQuery += "	AND BK_LOCAL = '"+cLocal+"'"
		cQuery += "	AND BK_FILIAL = '"+xFilial("SBK")+"'"
		
		cQuery += "	UPDATE "+retsqlname("SBJ")
		cQuery += "	SET D_E_L_E_T_ = '"+(Iif(lRet,'*',''))+"'"
		cQuery += "	WHERE BJ_COD = '"+cProduto+"'"
		cQuery += "	AND BJ_LOCAL = '"+cLocal+"'"
		cQuery += "	AND BJ_FILIAL = '"+xFilial("SBJ")+"'"

    else
		cQuery := " UPDATE "+RetSqlName("SB9") 
		cQuery += "	SET D_E_L_E_T_ = '"+(Iif(lRet,'*',''))+"'"
		cQuery += "	WHERE B9_COD = '"+cProduto+"'"
		cQuery += "	AND B9_LOCAL = '"+cLocal+"'"
		cQuery += "	AND B9_DATA = '"+DtOS(Iif(lRet,dUltFech,ultimodia(ddatai)))+"' "
		cQuery += "	AND B9_FILIAL = '"+xFilial("SB9")+"'"
		
		cQuery += "	UPDATE "+RetSqlName("SBK")
		cQuery += "	SET D_E_L_E_T_ = '"+(Iif(lRet,'*',''))+"'"
		cQuery += "	WHERE BK_COD = '"+cProduto+"'"
		cQuery += "	AND BK_LOCAL = '"+cLocal+"'"
		cQuery += "	AND BK_DATA = '"+DtOS(Iif(lRet,dUltFech,ultimodia(ddatai)))+"' "
		cQuery += "	AND BK_FILIAL = '"+xFilial("SBK")+"'"
		
		cQuery += "	UPDATE "+retsqlname("SBJ")
		cQuery += "	SET D_E_L_E_T_ = '"+(Iif(lRet,'*',''))+"'"
		cQuery += "	WHERE BJ_COD = '"+cProduto+"'"
		cQuery += "	AND BJ_LOCAL = '"+cLocal+"'"
		cQuery += "	AND BJ_DATA = '"+DtOS(Iif(lRet,dUltFech,ultimodia(ddatai)))+"' "
		cQuery += "	AND BJ_FILIAL = '"+xFilial("SBJ")+"'"
    
	endif

	If TCSQLExec(cQuery) < 0 //Executa a query
		cErro := TCSQLERROR()
		ALERT(cErro)
 	Endif   

	GetDatas()

	Processa({||fProcessa()})
	
Return

//-----------------------






///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function TrocaTip()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
aFolder[oBox:nAt,1] := IIF(aFolder[oBox:nAt,1],.F.,.T. )
oBox:Refresh()
Return


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function MarcaTodos(lMark)
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
For nI:= 1 To Len(aFolder)
  aFolder[nI,1] := IIF(lMark,.T.,.F.)
Next
oBox:Refresh()
Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fProcessa()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
nSB9        := 0
nSBJ        := 0
nSBK        := 0
nKAR        := 0
nSD5        := 0
nSDB        := 0
nSB2        := 0
nSB8        := 0
nSBF        := 0
nSDA        := 0
nDASB2      := 0
nEmpSB2     := 0
nDASB8      := 0
cMensagem   := ""
cMensSB8    := ""
cMensSBF    := ""        
cMensB8BF   := ""
cMensBJBK   := ""
cMensDocto  := ""
cMensNumSeq := ""
cMensDAB8   := ""

IF Empty(dDataI) .OR. Empty(dDataF)
   MsgStop("Datas de Processamento Invalidas !!!")
   Return
Endif

DBSelectArea("SB1")
DBSetOrder(1)
DBSeek(xFilial("SB1")+cProduto)

ProcRegua(15)

IncProc("Processando Saldo Inicial")
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
DBSelectArea("SB9")
DBSetOrder(1) 
IF DBSeek(xFilial("SB9")+cProduto+cLocal+DTOS(dUltFech))
   nSB9 := SB9->B9_QINI
Endif  

// Saldo Inicial
cQuery := "SELECT SUM(BJ_QINI) AS BJ_QINI FROM "+RETSQLNAME('SBJ')+" (NOLOCK) WHERE BJ_FILIAL='"+xFilial("SBJ")+"' AND BJ_LOCAL='"+cLocal+"' AND D_E_L_E_T_ <> '*' AND BJ_DATA = '"+DTOS(dUltFech)+"'AND BJ_COD = '"+cProduto+"'"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBJ",.F.,.T.)
nSBJ := QrySBJ->BJ_QINI
DBCloseArea()

cQuery := "SELECT SUM(BK_QINI) AS BK_QINI FROM "+RETSQLNAME('SBK')+" (NOLOCK) WHERE BK_FILIAL='"+xFilial("SBK")+"' AND BK_LOCAL='"+cLocal+"' AND D_E_L_E_T_ <> '*' AND BK_DATA = '"+DTOS(dUltFech)+"'AND BK_COD = '"+cProduto+"'"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBK",.F.,.T.)
nSBK := QrySBK->BK_QINI
DBCloseArea()

IncProc("Processando Saldo Atual")
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Saldo Atual
DBSelectArea("SB2")
DBSetOrder(1) 
IF DBSeek(xFilial("SB2")+cProduto+cLocal)
   nSB2   := SB2->B2_QATU
   nDASB2 := SB2->B2_QACLASS
   nEmpSB2 := SB2->B2_QEMP
Endif  

cQuery := "SELECT SUM(B8_SALDO) AS B8_SALDO, SUM(B8_QACLASS) AS B8_QACLASS FROM "+RETSQLNAME('SB8')+" (NOLOCK) WHERE B8_FILIAL='"+xFilial("SB8")+"' AND B8_LOCAL='"+cLocal+"' AND B8_SALDO <> 0 AND D_E_L_E_T_ <> '*' AND B8_PRODUTO = '"+cProduto+"' AND B8_DATA <= '"+DTOS(dDataF)+"'"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySB8",.F.,.T.)
nSB8   := QrySB8->B8_SALDO
nDASB8 := QrySB8->B8_QACLASS
DBCloseArea()

cQuery := "SELECT SUM(BF_QUANT) AS BF_QUANT FROM "+RETSQLNAME('SBF')+" (NOLOCK) WHERE BF_FILIAL='"+xFilial("SBF")+"' AND BF_LOCAL='"+cLocal+"' AND BF_QUANT <> 0 AND D_E_L_E_T_ <> '*' AND BF_PRODUTO = '"+cProduto+"'"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBF",.F.,.T.)
nSBF := QrySBF->BF_QUANT
DBCloseArea()

cQuery := "SELECT SUM(DA_SALDO) AS DA_SALDO  FROM "+RETSQLNAME('SDA')+" (NOLOCK) WHERE DA_FILIAL='"+xFilial("SDA")+"' AND DA_LOCAL='"+cLocal+"' AND DA_SALDO <> 0 AND D_E_L_E_T_ <> '*' AND DA_PRODUTO = '"+cProduto+"' AND DA_DATA <= '"+DTOS(dDataF)+"'"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySDA",.F.,.T.)
nSDA   := QrySDA->DA_SALDO
DBCloseArea()

IncProc("Processando Movimento")
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Saldo Movimentacao
DBSelectArea('SB1')
aSaldos := CalcEst(cProduto, cLocal, dDtProces+1)
IF aSaldos <> Nil .AND. Len(aSaldos) > 0
   nKAR  := aSaldos[1]                        
Endif   

fDetaSB8()    // Detalhe do SB8 x SD5
fDetaSBF()    // Detalhe do SBF x SDB
fDetaB8BF()   // Detalhe do SB8 x SBF
fDetaBJBK()   // Detalhe do SBJ x SBK   
fDetaSBJ()    // Detalhe do SBJ     
fDetaSBK()    // Detalhe do SBK        
//fAnaliseDoc() // Analisa Documento
fNumSeq()     // Analisa NumSeq
fKardLocal()  // Kardex por Almoxarifado
fKardLote()   // Kardex por Lote
fKardEnde()   // Kardex por Endereco

nSDB += nSDA
nSBF += nSDA

fDetaSDA()    // Detalhe SDA
fDetaDASB8()  // Detalhe SDAxSB8

IF Empty(cMensagem)
   cMensagem := "OK"  
Endif   

Do Case
   Case SB1->B1_LOCALIZ == "S" .AND. SB1->B1_RASTRO == "L"  
      IF nKAR <> nSB8 .OR. nKAR <> nSD5 .OR. nKAR <> nSDB .OR. nKAR <> nSBF .OR. nKAR <> nSB2 .OR. nSB8 <> nSD5 .OR. nSBF <> nSDB .OR. nSB8 <> nSBF .OR. nSB2 <> nSB8 .OR. nSB2 <> nSBF 
         cMensagem := "DIVERGENCIA"
      Endif
      IF nSB9 <> nSBJ
         cMensagem := "DIVERGENCIA"
      Endif
      IF nSDA <> nDASB2 .OR. nSDA <> nDASB8
         cMensagem := "DIVERGENCIA"
      Endif
      IF nSBJ = 0 .AND.  nSBK = 0 .AND. nKAR = nSB8 .AND. nKAR = nSD5 .AND. nKAR = nSDB .AND. nKAR = nSBF .AND. nKAR = nSB2 .AND. nSB8 = nSD5 .AND. nSBF = nSDB .AND. nSB8 = nSBF .AND. nSB2 = nSB8 .AND. nSB2 = nSBF 
         cMensagem := "OK"  
      Endif
   Case SB1->B1_LOCALIZ == "S"
      IF nKAR <> nSDB .OR. nKAR <> nSBF .OR. nKAR <> nSB2 .OR. nSBF <> nSDB .OR. nSB2 <> nSBF 
         cMensagem := "DIVERGENCIA"
      Endif
      IF nSDA <> nDASB2 
         cMensagem := "DIVERGENCIA"
      Endif
      IF nSBK = 0 .AND. nKAR = nSDB .AND. nKAR = nSBF .AND. nKAR = nSB2 .AND. nSBF = nSDB .AND. nSB2 = nSBF 
         cMensagem := "OK"  
      Endif
   Case SB1->B1_RASTRO == "L"
      IF nKAR <> nSB8 .OR. nKAR <> nSD5 .OR. nKAR <> nSB2 .OR. nSB8 <> nSD5 .OR. nSB2 <> nSB8
         cMensagem := "DIVERGENCIA"
      Endif
      IF nSB9 <> nSBJ
         cMensagem := "DIVERGENCIA"
      Endif
      IF nSBJ = 0 .AND. nKAR = nSB8 .AND. nKAR = nSD5 .AND. nKAR = nSB2 .AND. nSB8 = nSD5 .AND. nSB2 = nSB8 
         cMensagem := "OK"  
      Endif
   OtherWise   
      IF nKAR <> nSB2 
         cMensagem := "DIVERGENCIA"
      Endif
EndCase
           
IF nSD5 == nSDB .AND. nSB8 == nSBF
  cMensBJBK := ""
Endif  

oSB9:Refresh()
oSBJ:Refresh()
oSBK:Refresh()
oKAR:Refresh()
oSD5:Refresh()
oSDB:Refresh()
oSB2:Refresh()
oSB8:Refresh()
oSBF:Refresh()
oSDA:Refresh()
oDASB2:Refresh()
oEmpSB2:Refresh()
oDASB8:Refresh()
 
DBSelectArea('SB1')
Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GetDescProd()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local aArea  := GetArea()

DBSelectArea("SB1")
DBSetOrder(1)
IF !Empty(cProduto) .AND. !DBSeek(xFilial("SB1")+cProduto)
   MsgStop("Produto n„o cadastrado !!!")
   Return (.F.)
Endif

cDescr   := SB1->B1_DESC
cCrlLot  := If(SB1->B1_RASTRO ="L","Lote",If(SB1->B1_RASTRO ="S","Sub-Lote","N„o"))
cCrlEnd  := If(SB1->B1_LOCALIZ="S","Sim","N„o")
cLocal   := IF(Empty(cLocal),SB1->B1_LOCPAD,cLocal)
c1UM     := SB1->B1_UM
c2UM     := SB1->B1_SEGUM
nFatConv := SB1->B1_CONV
cTipConv := SB1->B1_TIPCONV

DBSelectArea("SB5")
DBSetOrder(1)
DBSeek(xFilial("SB5")+cProduto)
cZona := SB5->B5_CODZON   

IF !Empty(cProduto)
   If File("ANALISE.LOG")
      hdl := FOpen("ANALISE.LOG", 1)
      FSeek(hdl,0,2)
   Else
      hdl := FCreate("ANALISE.LOG", 0)
   Endif
   FWrite(hdl,"Produto: "+cProduto+"    Usuario:  "+cUserName+"    Data: "+Dtoc(Date())+"    Hora: "+Time()+CHR(13)+CHR(10))
   FClose(hdl)
Endif
RestArea(aArea)

Return(.T.)


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GetDatas()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local aArea  := GetArea()

cQuery := "SELECT MAX(B9_DATA) AS B9_DATA FROM "+RETSQLNAME('SB9')+" (NOLOCK) WHERE B9_FILIAL='"+xFilial("SB9")+"' AND B9_LOCAL='"+cLocal+"' AND D_E_L_E_T_ <> '*' AND B9_COD = '"+cProduto+"' AND B9_DATA < '"+DTOS(dDtProces)+"'"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySB9",.F.,.T.)
TCSETFIELD( "QrySB9","B9_DATA","D")
dUltFech := QrySB9->B9_DATA
DBCloseArea()

dDataI := (dUltFech + 1)
dDataF := dDtProces

RestArea(aArea)
Return(.T.)



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fDetaSB8()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IncProc("Processando Detalhe - SB8")

aSize(aDetSB8, 0)
aSize(aDetSD5, 0)

// Movimento do SB8
IF nOpSB8 == 1 // Num.Lote
   cQuery := " SELECT B8_DATA,B8_LOTECTL,B8_NUMLOTE,B8_DTVALID,B8_QTDORI,B8_SALDO,B8_EMPENHO,B8_SALDO2,B8_EMPENH2 FROM "+RETSQLNAME("SB8")   
   cQuery += " (NOLOCK) WHERE B8_FILIAL='"+xFilial("SB8")+"' AND B8_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SB8")+".D_E_L_E_T_ <> '*' AND B8_PRODUTO = '"+cProduto+"'"
   cQuery += " AND B8_SALDO <> 0 AND B8_DATA <= '"+DTOS(dDataF)+"' ORDER BY B8_LOTECTL,B8_NUMLOTE"   
Else
   cQuery := " SELECT B8_LOTECTL,B8_DTVALID,SUM(B8_QTDORI) AS B8_QTDORI,SUM(B8_SALDO) AS B8_SALDO,SUM(B8_EMPENHO) AS B8_EMPENHO,SUM(B8_SALDO2) AS B8_SALDO2,SUM(B8_EMPENH2) AS B8_EMPENH2 
   cQuery += " FROM "+RETSQLNAME("SB8")+" (NOLOCK) "
   cQuery += " WHERE B8_FILIAL='"+xFilial("SB8")+"' AND B8_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SB8")+".D_E_L_E_T_ <> '*' AND B8_PRODUTO = '"+cProduto+"'"
   cQuery += " AND B8_SALDO <> 0 AND B8_DATA <= '"+DTOS(dDataF)+"'"
   cQuery += " GROUP BY B8_LOTECTL,B8_DTVALID ORDER BY B8_LOTECTL"
Endif   
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySB8",.F.,.T.)
TCSETFIELD( "QrySB8","B8_DATA","D")
TCSETFIELD( "QrySB8","B8_DTVALID","D")
While !Eof() 
  AAdd(aDetSB8,{IF(nOpSB8==2,Space(06),B8_DATA),B8_LOTECTL,IF(nOpSB8==2,Space(06),B8_NUMLOTE),B8_DTVALID,B8_SALDO,B8_QTDORI,SPACE(06),B8_EMPENHO,B8_SALDO2,B8_EMPENH2})
  DBSkip()
Enddo
DBCloseArea()

IF Len(aDetSB8) == 0  
   Aadd(aDetSB8   ,{CTOD("  /  /  "),Space(10),Space(06),CTOD("  /  /  "),0,0,Space(08),0,0,0})
   oDetSB8:nAT := 1
Endif

IF Len(aDetSD5) == 0
   Aadd(aDetSD5   ,{CTOD("  /  /  "),Space(03),Space(10),Space(06),CTOD("  /  /  "),0,0,Space(06),Space(08),Space(06),Space(03),Space(06),Space(02),Space(01)})
   oDetSD5:nAT := 1
Endif

oDetSB8:Refresh()
oDetSD5:Refresh()
   
Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fDetaSD5()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IncProc("Processando Detalhe - SD5")

aSize(aDetSB8, 0)
aSize(aDetSD5, 0)

// Movimento do SD5
IF nOpSB8 == 2 // Lote
   cQuery := " SELECT D5_DATA,D5_ORIGLAN,D5_LOTECTL,D5_DTVALID,SUM(D5_QUANT) AS D5_QUANT FROM "+RETSQLNAME("SD5")+" (NOLOCK) "
   cQuery += " WHERE D5_FILIAL='"+xFilial("SD5")+"' AND D5_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SD5")+".D_E_L_E_T_ <> '*' AND D5_PRODUTO = '"+cProduto+"'"
   cQuery += " AND D5_ESTORNO= ' ' AND D5_DATA <= '"+DTOS(dDataF)+"'"
   cQuery += " GROUP BY D5_DATA,D5_ORIGLAN,D5_LOTECTL,D5_DTVALID"
Else // Lote e Num.Lote
   cQuery := " SELECT D5_DATA,D5_ORIGLAN,D5_LOTECTL,D5_NUMLOTE,D5_DTVALID,D5_NUMSEQ,D5_QUANT,D5_DOC,D5_SERIE,D5_CLIFOR,D5_LOJA,R_E_C_N_O_ AS RECNO FROM "+RETSQLNAME("SD5")+" (NOLOCK) "
   cQuery += " WHERE D5_FILIAL='"+xFilial("SD5")+"' AND D5_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SD5")+".D_E_L_E_T_ <> '*' AND D5_PRODUTO = '"+cProduto+"'"
   cQuery += " AND D5_ESTORNO= ' ' AND D5_DATA <= '"+DTOS(dDataF)+"'"
Endif
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySD5",.F.,.T.)
TCSETFIELD( "QrySD5","D5_DATA","D")
TCSETFIELD( "QrySD5","D5_DTVALID","D")
While !Eof() 
  IF nOpSB8 == 2 // Lote
     AAdd(aDetSD5,{D5_DATA,D5_ORIGLAN,D5_LOTECTL,SPACE(06) ,D5_DTVALID,D5_QUANT,0,Space(06),Space(06),Space(06),Space(01),Space(01),Space(01),Space(01)})
  Else
     AAdd(aDetSD5,{D5_DATA,D5_ORIGLAN,D5_LOTECTL,D5_NUMLOTE,D5_DTVALID,D5_QUANT,0,D5_NUMSEQ,Space(01),D5_DOC  ,D5_SERIE ,D5_CLIFOR ,D5_LOJA,QrySD5->RECNO})
  Endif   
  DBSkip()
Enddo
DBCloseArea()
IF nOpSB8 == 2 // Lote
   aSort(aDetSD5,,, { |x,y| DTOS(y[1])+y[3]+y[2] > DTOS(x[1])+x[3]+x[2]} )      
Else
   aSort(aDetSD5,,, { |x,y| y[3]+y[4]+y[8]+y[2] > x[3]+x[4]+x[8]+x[2]} )      
Endif   

IF Len(aDetSD5) == 0                   
   Aadd(aDetSD5   ,{CTOD("  /  /  "),Space(03),Space(10),Space(06),CTOD("  /  /  "),0,0,Space(06),Space(08),Space(06),Space(03),Space(06),Space(02),Space(01)})
   oDetSD5:nAT := 1
Endif

IF Len(aDetSB8) == 0
   Aadd(aDetSB8   ,{CTOD("  /  /  "),Space(10),Space(06),CTOD("  /  /  "),0,0,Space(08),0,0,0})
   oDetSB8:nAT := 1
Endif

oDetSD5:Refresh()
oDetSB8:Refresh()
   
Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fMontaSB8(lFiltro)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IF Len(aDetSD5) = 0 .OR. Empty(aDetSD5[1,1])
   Return
Endif

IncProc("Processando Detalhe - SB8")

aSize(aDetSB8, 0)

// Movimento do SB8
IF nOpSB8 == 2 // Lote
   cQuery := " SELECT B8_LOTECTL,B8_DTVALID,SUM(B8_QTDORI) AS B8_QTDORI,SUM(B8_SALDO) AS B8_SALDO,SUM(B8_EMPENHO) AS B8_EMPENHO,SUM(B8_SALDO2) AS B8_SALDO2,SUM(B8_EMPENH2) AS B8_EMPENH2 "
   cQuery += " FROM "+RETSQLNAME("SB8")+" (NOLOCK) "
   cQuery += " WHERE B8_FILIAL='"+xFilial("SB8")+"' AND B8_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SB8")+".D_E_L_E_T_ <> '*' AND B8_PRODUTO = '"+cProduto+"'"
   IF lFiltro
      cQuery += " AND B8_LOTECTL = '"+aDetSD5[oDetSD5:nAT][3]+"'"
//    cQuery += " AND B8_LOTECTL = '"+aDetSD5[oDetSD5:nAT][3]+"' AND B8_DATA <= '"+DTOS(dDataF)+"'"   
   Endif
   cQuery += " GROUP BY B8_LOTECTL,B8_DTVALID"
Else
   cQuery := " SELECT B8_DATA,B8_LOTECTL,B8_NUMLOTE,B8_DTVALID,B8_QTDORI,B8_SALDO,B8_EMPENHO,B8_SALDO2,B8_EMPENH2 FROM "+RETSQLNAME("SB8")+" (NOLOCK) "
   cQuery += " WHERE B8_FILIAL='"+xFilial("SB8")+"' AND B8_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SB8")+".D_E_L_E_T_ <> '*' AND B8_PRODUTO = '"+cProduto+"'"
   IF lFiltro
      cQuery += " AND B8_LOTECTL = '"+aDetSD5[oDetSD5:nAT][3]+"' AND B8_NUMLOTE = '"+aDetSD5[oDetSD5:nAT][4]+"'"
//    cQuery += " AND B8_LOTECTL = '"+aDetSD5[oDetSD5:nAT][3]+"' AND B8_NUMLOTE = '"+aDetSD5[oDetSD5:nAT][4]+"' AND B8_DATA <= '"+DTOS(dDataF)+"'"   
   Endif
Endif   
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySB8",.F.,.T.)
TCSETFIELD( "QrySB8","B8_DATA","D")
TCSETFIELD( "QrySB8","B8_DTVALID","D")
While !Eof() 
  AAdd(aDetSB8  ,{IF(nOpSB8==2,Space(06),B8_DATA),B8_LOTECTL,IF(nOpSB8==2,SPACE(06),B8_NUMLOTE),B8_DTVALID,B8_SALDO,B8_QTDORI,SPACE(06),B8_EMPENHO,B8_SALDO2,B8_EMPENH2})
  DBSkip()
Enddo
DBCloseArea()

IF Len(aDetSB8) == 0
   For J:= 1 To Len(aDetSD5)
     IF aDetSD5[oDetSD5:nAT][3]+aDetSD5[oDetSD5:nAT][4] == aDetSD5[J,3]+aDetSD5[J,4]
        aDetSD5[J,09] := "Analisar"
     Endif   
   Next
Else
   For I:= 1 To Len(aDetSB8)  
     nSaldo := 0
     For J:= 1 To Len(aDetSD5)
       IF aDetSB8[I,2]+aDetSB8[I,3] == aDetSD5[J,3]+aDetSD5[J,4]
          nSaldo += IF(aDetSD5[J,2] <= "500" .OR. Substr(aDetSD5[J,2],1,2) $ 'DE/PR/MA' .OR. aDetSD5[J,2] = "SBJ" ,aDetSD5[J,6],aDetSD5[J,6]*-1)
          aDetSD5[J,07] := nSaldo      
          aDetSD5[J,09] := "OK"
       Endif   
     Next
     aDetSB8[I,7] := "OK"
     IF aDetSB8[I,5] <> nSaldo
        aDetSB8[I,7] := "Problema"
        For J:= 1 To Len(aDetSD5)
           IF aDetSB8[I,2]+aDetSB8[I,3] == aDetSD5[J,3]+aDetSD5[J,4]
              aDetSD5[J,09] := "Problema"
           Endif   
        Next
      Endif           
   Next
Endif

IF Len(aDetSB8) == 0
   Aadd(aDetSB8   ,{CTOD("  /  /  "),Space(10),Space(06),CTOD("  /  /  "),0,0,Space(08),0,0,0})
   oDetSB8:nAT := 1
Endif

IF Len(aDetSD5) == 0
   Aadd(aDetSD5   ,{CTOD("  /  /  "),Space(03),Space(10),Space(06),CTOD("  /  /  "),0,0,Space(06),Space(08),Space(06),Space(03),Space(06),Space(02),Space(01)})
   oDetSD5:nAT := 1
Endif

oDetSB8:Refresh()
oDetSD5:Refresh()
  
Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fMontaSD5()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IF Len(aDetSB8) = 0 .OR. Empty(aDetSB8[1,1])
   Return
Endif

IncProc("Processando Detalhe - SD5")

aSize(aDetSD5, 0)

// Identifica os Lotes               
IF nOpSB8 == 2 // Lote
   cQuery := " SELECT DISTINCT BJ_LOTECTL AS LOTECTL,BJ_NUMLOTE AS NUMLOTE FROM "+RETSQLNAME("SBJ")+" (NOLOCK) "
   cQuery += " WHERE BJ_FILIAL='"+xFilial("SBJ")+"' AND BJ_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SBJ")+".D_E_L_E_T_ <> '*' AND BJ_COD = '"+cProduto+"'"
   cQuery += " AND BJ_DATA = '"+DTOS(dUltFech)+"' AND BJ_QINI <> 0 AND BJ_LOTECTL  = '"+aDetSB8[oDetSB8:nAT][2]+"'"
   cQuery += " UNION"
   cQuery += " SELECT DISTINCT D5_LOTECTL AS LOTECTL,D5_NUMLOTE AS NUMLOTE FROM "+RETSQLNAME("SD5")+" (NOLOCK) "
   cQuery += " WHERE D5_FILIAL='"+xFilial("SD5")+"' AND D5_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SD5")+".D_E_L_E_T_ <> '*' AND D5_PRODUTO = '"+cProduto+"'"
   cQuery += " AND D5_ESTORNO= ' ' AND D5_DATA >= '"+DTOS(dDataI)+"' AND D5_DATA <= '"+DTOS(dDataF)+"' AND D5_LOTECTL  = '"+aDetSB8[oDetSB8:nAT][2]+"'"
Else // Lote e Num.Lote                                                                            
   cQuery := " SELECT DISTINCT BJ_LOTECTL AS LOTECTL,BJ_NUMLOTE AS NUMLOTE FROM "+RETSQLNAME("SBJ")+" (NOLOCK) "
   cQuery += " WHERE BJ_FILIAL='"+xFilial("SBJ")+"' AND BJ_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SBJ")+".D_E_L_E_T_ <> '*' AND BJ_COD = '"+cProduto+"'"
   cQuery += " AND BJ_DATA = '"+DTOS(dUltFech)+"' AND BJ_QINI <> 0 AND BJ_LOTECTL  = '"+aDetSB8[oDetSB8:nAT][2]+"'"
   cQuery += " AND BJ_NUMLOTE  = '"+aDetSB8[oDetSB8:nAT][3]+"'"
   cQuery += " UNION"
   cQuery += " SELECT DISTINCT D5_LOTECTL AS LOTECTL,D5_NUMLOTE AS NUMLOTE FROM "+RETSQLNAME("SD5")+ " (NOLOCK) "
   cQuery += " WHERE D5_FILIAL='"+xFilial("SD5")+"' AND D5_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SD5")+".D_E_L_E_T_ <> '*' AND D5_PRODUTO = '"+cProduto+"'"
   cQuery += " AND D5_ESTORNO= ' ' AND D5_DATA >= '"+DTOS(dDataI)+"' AND D5_DATA <= '"+DTOS(dDataF)+"' AND D5_LOTECTL  = '"+aDetSB8[oDetSB8:nAT][2]+"'"
   cQuery += " AND D5_NUMLOTE = '"+aDetSB8[oDetSB8:nAT][3]+"'"
Endif
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QryTRB",.F.,.T.)
While !Eof()
  // Movimento do SBJ 
  IF nOpSB8 == 2 // Lote
     cQuery := " SELECT BJ_LOTECTL,BJ_NUMLOTE,BJ_DATA,BJ_DTVALID,SUM(BJ_QINI) AS BJ_QINI FROM "+RETSQLNAME("SBJ")+" (NOLOCK) "
     cQuery += " WHERE BJ_FILIAL='"+xFilial("SBJ")+"' AND BJ_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SBJ")+".D_E_L_E_T_ <> '*' AND BJ_COD = '"+cProduto+"'"
     cQuery += " AND BJ_DATA = '"+DTOS(dUltFech)+"' AND BJ_LOTECTL  = '"+QryTRB->LOTECTL+"'"
     cQuery += " GROUP BY BJ_LOTECTL,,BJ_DATA,BJ_DTVALID"
  Else // Lote e Num.Lote
     cQuery := " SELECT BJ_LOTECTL,BJ_NUMLOTE,BJ_DATA,BJ_DTVALID,SUM(BJ_QINI) AS BJ_QINI FROM "+RETSQLNAME("SBJ")+" (NOLOCK) "
     cQuery += " WHERE BJ_FILIAL='"+xFilial("SBJ")+"' AND BJ_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SBJ")+".D_E_L_E_T_ <> '*' AND BJ_COD = '"+cProduto+"'"
     cQuery += " AND BJ_DATA = '"+DTOS(dUltFech)+"' AND BJ_LOTECTL  = '"+QryTRB->LOTECTL+"' AND BJ_NUMLOTE  = '"+QryTRB->NUMLOTE+"'"
     cQuery += " GROUP BY BJ_LOTECTL,BJ_NUMLOTE,BJ_DATA,BJ_DTVALID"
  Endif
  cQuery := ChangeQuery(cQuery)
  DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBJ",.F.,.T.)
  TCSETFIELD( "QrySBJ","BJ_DTVALID","D")
  IF nOpSB8 == 2 // Lote
     AAdd(aDetSD5,{BJ_DATA,"SBJ",BJ_LOTECTL,SPACE(06) ,D5_DTVALID,BJ_QINI,0,Space(06),Space(01),Space(06),Space(01),Space(01),Space(01),Space(01)})
  Else // Lote e Num.Lote
     AAdd(aDetSD5,{BJ_DATA,"SBJ",BJ_LOTECTL,BJ_NUMLOTE,BJ_DTVALID,BJ_QINI,0,Space(06),Space(01),Space(06),Space(01),Space(01),Space(01),Space(01)})
  Endif   
  DBCloseArea()
  DBSelectArea("QryTRB")
  DBSkip()
Enddo
DBCloseArea()

// Movimento do SD5
IF nOpSB8 == 2 // Lote
   cQuery := " SELECT D5_DATA,D5_ORIGLAN,D5_LOTECTL,D5_DTVALID,SUM(D5_QUANT) AS D5_QUANT FROM "+RETSQLNAME("SD5")+" (NOLOCK) "
   cQuery += " WHERE D5_FILIAL='"+xFilial("SD5")+"' AND D5_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SD5")+".D_E_L_E_T_ <> '*' AND D5_PRODUTO = '"+cProduto+"'"
   cQuery += " AND D5_ESTORNO= ' ' AND D5_LOTECTL = '"+aDetSB8[oDetSB8:nAT][2]+"'"
   cQuery += " AND D5_DATA >= '"+DTOS(dDataI)+"' AND D5_DATA <= '"+DTOS(dDataF)+"'"
   cQuery += " GROUP BY D5_DATA,D5_ORIGLAN,D5_LOTECTL,D5_DTVALID"
Else // Lote e Num.Lote
   cQuery := " SELECT D5_DATA,D5_ORIGLAN,D5_LOTECTL,D5_NUMLOTE,D5_DTVALID,D5_NUMSEQ,D5_QUANT,D5_DOC,D5_SERIE,D5_CLIFOR,D5_LOJA,R_E_C_N_O_ AS RECNO FROM "+RETSQLNAME("SD5")+" (NOLOCK) "
   cQuery += " WHERE D5_FILIAL='"+xFilial("SD5")+"' AND D5_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SD5")+".D_E_L_E_T_ <> '*' AND D5_PRODUTO = '"+cProduto+"'"
   cQuery += " AND D5_ESTORNO= ' ' AND D5_LOTECTL = '"+aDetSB8[oDetSB8:nAT][2]+"' AND D5_NUMLOTE = '"+aDetSB8[oDetSB8:nAT][3]+"'"
   cQuery += " AND D5_DATA >= '"+DTOS(dDataI)+"' AND D5_DATA <= '"+DTOS(dDataF)+"'"
Endif
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySD5",.F.,.T.)
TCSETFIELD( "QrySD5","D5_DATA","D")   
TCSETFIELD( "QrySD5","D5_DTVALID","D")
While !Eof() 
  IF nOpSB8 == 2 // Lote
     AAdd(aDetSD5,{D5_DATA,D5_ORIGLAN,D5_LOTECTL,SPACE(06) ,D5_DTVALID,D5_QUANT,0,Space(06),Space(01),Space(06),Space(01),Space(01),Space(01),Space(01)})
  Else
     AAdd(aDetSD5,{D5_DATA,D5_ORIGLAN,D5_LOTECTL,D5_NUMLOTE,D5_DTVALID,D5_QUANT,0,D5_NUMSEQ,Space(01),D5_DOC  ,D5_SERIE  ,D5_CLIFOR,D5_LOJA ,QrySD5->RECNO})
  Endif   
  DBSkip()
Enddo
DBCloseArea()
IF nOpSB8 == 1 // Lote e Num.Lote
   aSort(aDetSD5,,, { |x,y| y[8]+y[2] > x[8]+y[2]} )      
Endif   
nSaldo := 0
For I:= 1 To Len(aDetSD5)
   IF !Empty(aDetSD5[I,1])
      nSaldo += IF(aDetSD5[I,2] <= "500" .OR. Substr(aDetSD5[I,2],1,2) $ 'DE/PR/MA' .OR. aDetSD5[I,2] = "SBJ",aDetSD5[I,6],aDetSD5[I,6]*-1)
      aDetSD5[I,07] := nSaldo     
      aDetSD5[I,09] := "OK"
   Else
      nSaldo := 0
   Endif   
Next

aDetSB8[oDetSB8:nAT][7] := "OK"
IF nSaldo <> aDetSB8[oDetSB8:nAT][5]
   aDetSB8[oDetSB8:nAT][7] := "Problema"
   For I:= 1 To Len(aDetSD5)
      aDetSD5[I,09] := "Problema"
   Next
Endif

IF Len(aDetSB8) == 0
   Aadd(aDetSB8   ,{CTOD("  /  /  "),Space(10),Space(06),CTOD("  /  /  "),0,0,Space(08),0,0,0})
   oDetSB8:nAT := 1
Endif

IF Len(aDetSD5) == 0
   Aadd(aDetSD5   ,{CTOD("  /  /  "),Space(03),Space(10),Space(06),CTOD("  /  /  "),0,0,Space(06),Space(08),Space(06),Space(03),Space(06),Space(02),Space(01)})
   oDetSD5:nAT := 1
Else                          
   oDetSD5:nAT := Len(aDetSD5)
Endif

oDetSB8:Refresh()
oDetSD5:Refresh()
   
Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fDetaSBF()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IncProc("Processando Detalhe - SBF")

aSize(aDetSBF, 0)
aSize(aDetSDB, 0)

// Movimento do SBF
cQuery := " SELECT BF_LOCALIZ,BF_LOTECTL,BF_QUANT,BF_QTSEGUM,BF_EMPENHO,BF_EMPEN2,BF_ESTFIS,R_E_C_N_O_ AS RECNO FROM "+RETSQLNAME("SBF")+" (NOLOCK) "
cQuery += " WHERE BF_FILIAL='"+xFilial("SBF")+"' AND BF_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SBF")+".D_E_L_E_T_ <> '*' AND BF_PRODUTO = '"+cProduto+"'"
cQuery += " AND BF_QUANT <> 0 ORDER BY BF_LOCALIZ,BF_LOTECTL"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBF",.F.,.T.)
While !Eof()                                        
  DBSelectArea("SBE")
  DBSetOrder(1) //BE_FILIAL+BE_LOCAL+BE_LOCALIZ
  DBSeek(xFilial("SBE")+cLocal+QrySBF->BF_LOCALIZ)
  
  cEndStatus := ""
  IF (nSeek := Ascan(aSx3Box, { |x| x[ 2 ] == SBE->BE_STATUS })) > 0
     cEndStatus := AllTrim( aSx3Box[ nSeek, 3 ] )
  Endif

  DBSelectArea("DC8")
  DBSetOrder(1) 
  DBSeek(xFilial("DC8")+QrySBF->BF_ESTFIS)
    
  AAdd(aDetSBF,{QrySBF->BF_LOCALIZ,QrySBF->BF_LOTECTL,QrySBF->BF_QUANT,SPACE(06),QrySBF->BF_EMPENHO,QrySBF->BF_ESTFIS+" - "+Substr(DC8->DC8_DESEST,1,15),cEndStatus,SBE->BE_CODZON,QrySBF->BF_QTSEGUM,QrySBF->BF_EMPEN2,QrySBF->RECNO})

  DBSelectArea("QrySBF")
  DBSkip()
Enddo
DBCloseArea()

IF Len(aDetSBF) == 0
   Aadd(aDetSBF   ,{Space(15),Space(10),0,Space(08),0,Space(01),Space(01),Space(01),0,0,Space(01)})
   oDetSBF:nAT := 1
Endif

IF Len(aDetSDB) == 0
   Aadd(aDetSDB   ,{Space(03),CTOD("  /  /  "),Space(03),Space(15),Space(10),0,0,Space(06),Space(08),Space(06),Space(03),Space(06),Space(02),Space(01)})
   oDetSDB:nAT := 1
Endif

oDetSBF:Refresh()
oDetSDB:Refresh()   

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fDetaSDB()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IncProc("Processando Detalhe - SDB")

aSize(aDetSDB, 0)
aSize(aDetSBF, 0)

cQuery := " SELECT DB_ORIGEM,DB_DATA,DB_TM,DB_LOCALIZ,DB_LOTECTL,DB_QUANT,DB_NUMSEQ,DB_DOC,DB_SERIE,DB_CLIFOR,DB_LOJA,R_E_C_N_O_ AS RECNO FROM "+RETSQLNAME("SDB")+" (NOLOCK) "
cQuery += " WHERE DB_FILIAL='"+xFilial("SDB")+"' AND DB_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SDB")+".D_E_L_E_T_ <> '*' AND DB_PRODUTO = '"+cProduto+"'"
cQuery += " AND DB_ESTORNO= ' ' AND DB_ATUEST='S'"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySDB",.F.,.T.)
TCSETFIELD( "QrySDB","DB_DATA","D")
While !Eof() 
  AAdd(aDetSDB,{DB_ORIGEM,DB_DATA,DB_TM,DB_LOCALIZ,DB_LOTECTL,DB_QUANT,0,DB_NUMSEQ,Space(06),DB_DOC,DB_SERIE,DB_CLIFOR,DB_LOJA,QrySDB->RECNO})
  DBSkip()
Enddo
DBCloseArea()

aSort(aDetSDB,,, { |x,y| y[4]+y[5]+y[8]+y[3] > x[4]+x[5]+x[8]+x[3]} )      

IF Len(aDetSBF) == 0
   Aadd(aDetSBF   ,{Space(15),Space(10),0,Space(08),0,Space(01),Space(01),Space(01),0,0,Space(01)})
   oDetSBF:nAT := 1
Endif
IF Len(aDetSDB) == 0
   Aadd(aDetSDB   ,{Space(03),CTOD("  /  /  "),Space(03),Space(15),Space(10),0,0,Space(06),Space(08),Space(06),Space(03),Space(06),Space(02),Space(01)})
   oDetSDB:nAT := 1
Endif

oDetSDB:Refresh()
oDetSBF:Refresh()
   
Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fMontaSBF(lFiltro)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IF Len(aDetSDB) = 0 .OR. Empty(aDetSDB[1,1])
   Return
Endif

IncProc("Processando Detalhe - SBF")

aSize(aDetSBF, 0)

// Movimento do SBF
cQuery := " SELECT BF_LOCALIZ,BF_LOTECTL,BF_QUANT,BF_QTSEGUM,BF_EMPENHO,BF_EMPEN2,BF_ESTFIS,R_E_C_N_O_ AS RECNO FROM "+RETSQLNAME("SBF")+" (NOLOCK) "
cQuery += " WHERE BF_FILIAL='"+xFilial("SBF")+"' AND BF_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SBF")+".D_E_L_E_T_ <> '*' AND BF_PRODUTO = '"+cProduto+"'"
IF lFiltro
   cQuery += " AND BF_QUANT <> 0 AND BF_LOCALIZ = '"+aDetSDB[oDetSDB:nAT][4]+"' AND BF_LOTECTL = '"+aDetSDB[oDetSDB:nAT][5]+"' ORDER BY BF_LOCALIZ,BF_LOTECTL"
Endif   
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBF",.F.,.T.)
While !Eof() 
  DBSelectArea("SBE")
  DBSetOrder(1) //BE_FILIAL+BE_LOCAL+BE_LOCALIZ
  DBSeek(xFilial("SBE")+cLocal+QrySBF->BF_LOCALIZ)
  
  cEndStatus := ""
  IF (nSeek := Ascan(aSx3Box, { |x| x[ 2 ] == SBE->BE_STATUS })) > 0
     cEndStatus := AllTrim( aSx3Box[ nSeek, 3 ] )
  Endif

  DBSelectArea("DC8")
  DBSetOrder(1) 
  DBSeek(xFilial("DC8")+QrySBF->BF_ESTFIS)
    
  AAdd(aDetSBF,{QrySBF->BF_LOCALIZ,QrySBF->BF_LOTECTL,QrySBF->BF_QUANT,SPACE(06),QrySBF->BF_EMPENHO,QrySBF->BF_ESTFIS+" - "+Substr(DC8->DC8_DESEST,1,15),cEndStatus,SBE->BE_CODZON,QrySBF->BF_QTSEGUM,QrySBF->BF_EMPEN2,QrySBF->RECNO})

  DBSelectArea("QrySBF")
  DBSkip()
Enddo
DBCloseArea()

IF Len(aDetSBF) == 0
   nSaldo := 0
   For J:= 1 To Len(aDetSDB)
     IF aDetSDB[oDetSDB:nAT][4]+aDetSDB[oDetSDB:nAT][5] == aDetSDB[J,4]+aDetSDB[J,5]
        nSaldo += IF(aDetSDB[J,3] <= "500" .OR. Substr(aDetSDB[J,3],1,2) $ 'DE/PR/MA' .OR. aDetSDB[J,3] = "SBK" ,aDetSDB[J,6],aDetSDB[J,6]*-1)
        aDetSDB[J,7] := nSaldo
        aDetSDB[J,9] := "OK"
     Endif   
   Next
   IF nSaldo <> 0
      For J:= 1 To Len(aDetSDB)
        IF aDetSDB[oDetSDB:nAT][4]+aDetSDB[oDetSDB:nAT][5] == aDetSDB[J,4]+aDetSDB[J,5]
           aDetSDB[J,9] := "Problema"
        Endif   
      Next
   Endif
Else
   For I:= 1 To Len(aDetSBF)  
     nSaldo := 0
     For J:= 1 To Len(aDetSDB)
       IF aDetSBF[I,1]+aDetSBF[I,2] == aDetSDB[J,4]+aDetSDB[J,5]
          nSaldo += IF(aDetSDB[J,3] <= "500" .OR. Substr(aDetSDB[J,3],1,2) $ 'DE/PR/MA' .OR. aDetSDB[J,3] = "SBK",aDetSDB[J,6],aDetSDB[J,6]*-1)
          aDetSDB[J,7] := nSaldo
          aDetSDB[J,9] := "OK"
       Endif   
     Next
     aDetSBF[I,4] := "OK"
     IF aDetSBF[I,3] <> nSaldo
        aDetSBF[I,4] := "Problema"
        For J:= 1 To Len(aDetSDB)
           IF aDetSBF[I,1]+aDetSBF[I,2] == aDetSDB[J,4]+aDetSDB[J,5]
              aDetSDB[J,9] := "Problema"
           Endif   
        Next
      Endif           
   Next
Endif               

IF Len(aDetSBF) == 0
   Aadd(aDetSBF   ,{Space(15),Space(10),0,Space(08),0,Space(01),Space(01),Space(01),0,0,Space(01)})
   oDetSBF:nAT := 1
Endif  

IF Len(aDetSDB) == 0
   Aadd(aDetSDB   ,{Space(03),CTOD("  /  /  "),Space(03),Space(15),Space(10),0,0,Space(06),Space(08),Space(06),Space(03),Space(06),Space(02),Space(01)})
   oDetSDB:nAT := 1
Endif

oDetSBF:Refresh()
oDetSDB:Refresh()   

Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fMontaSDB()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IF Len(aDetSBF) = 0 .OR. Empty(aDetSBF[1,1])
   Return
Endif

IncProc("Processando Detalhe - SDB")

aSize(aDetSDB, 0)    

cQuery := " SELECT DISTINCT BK_LOCALIZ AS LOCALIZ,BK_LOTECTL AS LOTECTL FROM "+RETSQLNAME("SBK")+" (NOLOCK) "
cQuery += " WHERE BK_FILIAL='"+xFilial("SBK")+"' AND BK_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SBK")+".D_E_L_E_T_ <> '*' AND BK_COD = '"+cProduto+"'"
cQuery += " AND BK_DATA = '"+DTOS(dUltFech)+"' AND BK_QINI <> 0 "
cQuery += " AND BK_LOCALIZ = '"+aDetSBF[oDetSBF:nAT][1]+"' AND BK_LOTECTL = '"+aDetSBF[oDetSBF:nAT][2]+"'"
cQuery += " UNION"
cQuery += " SELECT DISTINCT DB_LOCALIZ AS LOCALIZ,DB_LOTECTL AS LOTECTL FROM "+RETSQLNAME("SDB")+" (NOLOCK) "
cQuery += " WHERE DB_FILIAL='"+xFilial("SDB")+"' AND DB_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SDB")+".D_E_L_E_T_ <> '*' AND DB_PRODUTO = '"+cProduto+"'"
cQuery += " AND DB_ESTORNO=' ' AND DB_ATUEST='S' AND DB_DATA >= '"+DTOS(dDataI)+"' AND DB_DATA <= '"+DTOS(dDataF)+"'"
cQuery += " AND DB_LOCALIZ = '"+aDetSBF[oDetSBF:nAT][1]+"' AND DB_LOTECTL = '"+aDetSBF[oDetSBF:nAT][2]+"'"
cQuery += " UNION"
cQuery += " SELECT DISTINCT BF_LOCALIZ AS LOCALIZ,BF_LOTECTL AS LOTECTL FROM "+RETSQLNAME("SBF")+" (NOLOCK) "
cQuery += " WHERE BF_FILIAL='"+xFilial("SBF")+"' AND BF_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SBF")+".D_E_L_E_T_ <> '*' AND BF_PRODUTO = '"+cProduto+"'"
cQuery += " AND BF_QUANT <> 0 AND BF_LOCALIZ = '"+aDetSBF[oDetSBF:nAT][1]+"' AND BF_LOTECTL = '"+aDetSBF[oDetSBF:nAT][2]+"'"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QryTRB",.F.,.T.)
While !Eof()
  // Movimento do SBK
  cQuery := " SELECT BK_LOCALIZ,BK_LOTECTL,SUM(BK_QINI) AS BK_QINI FROM "+RETSQLNAME("SBK")+" (NOLOCK) "
  cQuery += " WHERE BK_FILIAL='"+xFilial("SBK")+"' AND BK_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SBK")+".D_E_L_E_T_ <> '*' AND BK_COD = '"+cProduto+"'"
  cQuery += " AND BK_DATA = '"+DTOS(dUltFech)+"' AND BK_LOCALIZ  = '"+QryTRB->LOCALIZ+"' AND BK_LOTECTL  = '"+QryTRB->LOTECTL+"'"
  cQuery += " GROUP BY BK_LOCALIZ,BK_LOTECTL"           
  cQuery := ChangeQuery(cQuery)
  DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBK",.F.,.T.)
  AAdd(aDetSDB,{"SBK",dUltFech,Space(03),BK_LOCALIZ,BK_LOTECTL,BK_QINI,0,Space(06),Space(6),Space(6),Space(3),Space(6),Space(2),0})
  DBCloseArea()
  DBSelectArea("QryTRB")
  DBSkip()
Enddo
DBCloseArea()

cQuery := " SELECT DB_ORIGEM,DB_DATA,DB_TM,DB_LOCALIZ,DB_LOTECTL,DB_QUANT,DB_NUMSEQ,DB_DOC,DB_SERIE,DB_CLIFOR,DB_LOJA,R_E_C_N_O_ AS RECNO FROM "+RETSQLNAME("SDB")+" (NOLOCK) "
cQuery += " WHERE DB_FILIAL='"+xFilial("SDB")+"' AND DB_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SDB")+".D_E_L_E_T_ <> '*' AND DB_PRODUTO = '"+cProduto+"'"
cQuery += " AND DB_ESTORNO= ' ' AND DB_ATUEST='S' AND DB_LOCALIZ = '"+aDetSBF[oDetSBF:nAT][1]+"' AND DB_LOTECTL = '"+aDetSBF[oDetSBF:nAT][2]+"'"
cQuery += " AND DB_DATA >= '"+DTOS(dDataI)+"' AND DB_DATA <= '"+DTOS(dDataF)+"'"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySDB",.F.,.T.)
TCSETFIELD( "QrySDB","DB_DATA","D")
While !Eof() 
  AAdd(aDetSDB,{DB_ORIGEM,DB_DATA,DB_TM,DB_LOCALIZ,DB_LOTECTL,DB_QUANT,0,DB_NUMSEQ,Space(6),DB_DOC,DB_SERIE,DB_CLIFOR,DB_LOJA,QrySDB->RECNO})
  DBSkip()
Enddo
DBCloseArea()

aSort(aDetSDB,,, { |x,y| y[8]+STR(y[14]) > x[8]+STR(x[14])} )      

nSaldo := 0
For I:= 1 To Len(aDetSDB)
   IF !Empty(aDetSDB[I,1])
      nSaldo += IF(aDetSDB[I,3] <= "500" .OR. Substr(aDetSDB[I,3],1,2) $ 'DE/PR/MA' .OR. aDetSDB[I,3] = "SBK",aDetSDB[I,6],aDetSDB[I,6]*-1)
      aDetSDB[I,7] := nSaldo
   Else
      nSaldo := 0
   Endif   
Next

aDetSBF[oDetSBF:nAT][4] := "OK"
IF nSaldo <> aDetSBF[oDetSBF:nAT][3]
   aDetSBF[oDetSBF:nAT][4] := "Problema"
Endif

IF Len(aDetSBF) == 0
   Aadd(aDetSBF   ,{Space(15),Space(10),0,Space(08),0,Space(01),Space(01),Space(01),0,0,Space(01)})
   oDetSBF:nAT := 1
Endif

IF Len(aDetSDB) == 0
   Aadd(aDetSDB   ,{Space(03),CTOD("  /  /  "),Space(03),Space(15),Space(10),0,0,Space(06),Space(08),Space(06),Space(03),Space(06),Space(02),Space(01)})
   oDetSDB:nAT := 1
Else
   oDetSDB:nAT := Len(aDetSDB)   
Endif

oDetSDB:Refresh()
oDetSBF:Refresh()
   
Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fDetaB8BF()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IncProc("Processando Detalhe - SB8xSBF")
cMensB8BF   := ""

aSize(aDet01B8BF, 0)
aSize(aDet02B8BF, 0)

// Movimento do SB8
cQuery := " SELECT B8_LOTECTL,SUM(B8_SALDO) AS B8_SALDO,SUM(B8_SALDO2) AS B8_SALDO2,SUM(B8_EMPENHO) AS B8_EMPENHO,SUM(B8_EMPENH2) AS B8_EMPENH2,SUM(B8_QACLASS) AS B8_QACLASS,SUM(B8_QACLAS2) AS B8_QACLAS2 "
cQuery += " FROM "+RETSQLNAME("SB8")+" (NOLOCK) "
cQuery += " WHERE B8_FILIAL='"+xFilial("SB8")+"' AND B8_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SB8")+".D_E_L_E_T_ <> '*' AND B8_PRODUTO = '"+cProduto+"'"
cQuery += " AND B8_SALDO <> 0  GROUP BY B8_LOTECTL"
//cQuery += " AND B8_SALDO <> 0 AND B8_DATA <= '"+DTOS(dDataF)+"' GROUP BY B8_LOTECTL"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySB8",.F.,.T.)
While !Eof() 
  AAdd(aDet01B8BF,{B8_LOTECTL,B8_SALDO,B8_EMPENHO,B8_QACLASS,B8_SALDO2,B8_EMPENH2,B8_QACLAS2,"OK"})
  DBSkip()
Enddo
DBCloseArea()

// Movimento do SBF
cQuery := " SELECT BF_LOTECTL,SUM(BF_QUANT) AS BF_QUANT,SUM(BF_QTSEGUM) AS BF_QTSEGUM,SUM(BF_EMPENHO) AS BF_EMPENHO,SUM(BF_EMPEN2) AS BF_EMPEN2 FROM "+RETSQLNAME("SBF")+" (NOLOCK) "
cQuery += " WHERE BF_FILIAL='"+xFilial("SBF")+"' AND BF_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SBF")+".D_E_L_E_T_ <> '*' AND BF_PRODUTO = '"+cProduto+"'"
cQuery += " AND BF_QUANT <> 0 GROUP BY BF_LOTECTL"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBF",.F.,.T.)
While !Eof() 
  AAdd(aDet02B8BF,{BF_LOTECTL,BF_QUANT,BF_EMPENHO,BF_QTSEGUM,BF_EMPEN2,"OK"})
  DBSkip()
Enddo
DBCloseArea()

IF  SB1->B1_RASTRO == "L"  .AND. SB1->B1_LOCALIZ == "S"
   For I:= 1 To Len(aDet01B8BF)
     nPos := Ascan(aDet02B8BF,{ |x| x[1] == aDet01B8BF[I,1] })
     IF nPos == 0 .AND. (aDet01B8BF[I,2] - aDet01B8BF[I,4]) <> 0
        aDet01B8BF[I,8] := "Analisar"
        cMensB8BF       := "Entre o SB8 x SBF"
     ElseIF nPos > 0 .AND. (aDet01B8BF[I,2]- aDet01B8BF[I,4]) <> aDet02B8BF[nPos,2]
        aDet01B8BF[I,8] := "Analisar"
        cMensB8BF       := "Entre o SB8 x SBF"
     Endif
   Next

   For I:= 1 To Len(aDet02B8BF)
     nPos := Ascan(aDet01B8BF,{ |x| x[1] == aDet02B8BF[I,1] })
     IF nPos == 0 .OR. aDet02B8BF[I,2] <> (aDet01B8BF[nPos,2]-aDet01B8BF[nPos,4])
        aDet02B8BF[I,6] := "Analisar"
        cMensB8BF       := "Entre o SB8 x SBF"
     Endif
   Next
Endif

IF Len(aDet01B8BF) == 0
   Aadd(aDet01B8BF,{Space(10),0,0,0,0,0,0,Space(08)})
   oDet01B8BF:nAT := 1
Endif

IF Len(aDet02B8BF) == 0
   Aadd(aDet02B8BF,{Space(10),0,0,0,0,Space(08)})
   oDet02B8BF:nAT := 1
Endif

oDet01B8BF:Refresh()
oDet02B8BF:Refresh()
   
Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fDetaBJBK()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IncProc("Processando Detalhe - SBJxSBK")

cMensBJBK   := ""

aSize(aDetSBJ, 0)
aSize(aDetSBK, 0)

// Movimento do SBJ
cQuery := " SELECT BJ_LOTECTL,SUM(BJ_QINI) AS BJ_QINI,SUM(BJ_QISEGUM) AS BJ_QISEGUM FROM "+RETSQLNAME("SBJ")+" (NOLOCK) "
cQuery += " WHERE BJ_FILIAL='"+xFilial("SBJ")+"' AND BJ_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SBJ")+".D_E_L_E_T_ <> '*' AND BJ_COD = '"+cProduto+"'"
cQuery += " AND BJ_QINI <> 0  AND BJ_DATA = '"+DTOS(dUltFech)+"' GROUP BY BJ_LOTECTL"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBJ",.F.,.T.)
While !Eof() 
  AAdd(aDetSBJ,{BJ_LOTECTL,BJ_QINI,BJ_QISEGUM,"OK"})
  DBSkip()
Enddo
DBCloseArea()

// Movimento do SBK
cQuery := " SELECT BK_LOTECTL,SUM(BK_QINI) AS BK_QINI,SUM(BK_QISEGUM) AS BK_QISEGUM FROM "+RETSQLNAME("SBK")+" (NOLOCK) "
cQuery += " WHERE BK_FILIAL='"+xFilial("SBK")+"' AND BK_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SBK")+".D_E_L_E_T_ <> '*' AND BK_COD = '"+cProduto+"'"
cQuery += " AND BK_QINI <> 0  AND BK_DATA = '"+DTOS(dUltFech)+"' GROUP BY BK_LOTECTL"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBK",.F.,.T.)
While !Eof() 
  AAdd(aDetSBK,{BK_LOTECTL,BK_QINI,BK_QISEGUM,"OK"})
  DBSkip()
Enddo
DBCloseArea()

IF SB1->B1_LOCALIZ == "S"  .AND. SB1->B1_RASTRO="L"
   For I:= 1 To Len(aDetSBJ)
     nPos := Ascan(aDetSBK,{ |x| x[1] == aDetSBJ[I,1] })
     IF nPos == 0 .OR. aDetSBJ[I,2] <> aDetSBK[nPos,2]
        IF nPos == 0 .OR. aDetSBJ[I,2] < aDetSBK[nPos,2]
           aDetSBJ[I,4] := "Analisar"            
           cMensBJBK    := "Entre o SBJ x SBK"
        Endif   
     Endif
   Next

   For I:= 1 To Len(aDetSBK)
     nPos := Ascan(aDetSBJ,{ |x| x[1] == aDetSBK[I,1] })
     IF nPos == 0 .OR. aDetSBK[I,2] <> aDetSBJ[nPos,2]
        IF nPos == 0 .OR. aDetSBK[I,2] > aDetSBJ[nPos,2]
           aDetSBK[I,4] := "Analisar"
           cMensBJBK    := "Entre o SBJ x SBK"
        Endif   
      Endif
   Next
Endif

IF Len(aDetSBK) == 0
   Aadd(aDetSBK   ,{Space(10),0,0,Space(08)})
   oDetSBK:nAT := 1
Endif

IF Len(aDetSBJ) == 0
   Aadd(aDetSBJ   ,{Space(10),0,0,Space(08)})
   oDetSBJ:nAT := 1
Endif   

oDetSBJ:Refresh()
oDetSBK:Refresh()
   
Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fDetaSBJ()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IncProc("Processando Detalhe - SBJ")

aSize(aAnaSBJ, 0)

// Movimento do SBJ
cQuery := " SELECT BJ_LOTECTL,BJ_NUMLOTE,BJ_DTVALID,BJ_QINI,R_E_C_N_O_ AS RECNO FROM "+RETSQLNAME("SBJ")+" (NOLOCK) "
cQuery += " WHERE BJ_FILIAL='"+xFilial("SBJ")+"' AND BJ_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SBJ")+".D_E_L_E_T_ <> '*' AND BJ_COD = '"+cProduto+"'"
cQuery += " AND BJ_DATA = '"+DTOS(dUltFech)+"' ORDER BY BJ_LOTECTL,BJ_NUMLOTE"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBJ",.F.,.T.)
TCSETFIELD( "QrySBJ","BF_DTVALID","D")
While !Eof() 
  AAdd(aAnaSBJ,{BJ_LOTECTL,BJ_NUMLOTE,BJ_DTVALID,BJ_QINI,QrySBJ->RECNO})
  DBSkip()
Enddo
DBCloseArea()

IF Len(aDetSBJ) == 0
   Aadd(aDetSBJ   ,{Space(10),0,0,Space(08)})
   oDetSBJ:nAT := 1
Endif   

oAnaSBJ:Refresh()
   
Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fDetaSBK()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IncProc("Processando Detalhe - SBK")

aSize(aAnaSBK, 0)

// Movimento do SBK
cQuery := " SELECT BK_LOCALIZ,BK_LOTECTL,BK_QINI,R_E_C_N_O_ AS RECNO FROM "+RETSQLNAME("SBK")+" (NOLOCK) "
cQuery += " WHERE BK_FILIAL='"+xFilial("SBK")+"' AND BK_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SBK")+".D_E_L_E_T_ <> '*' AND BK_COD = '"+cProduto+"'"
cQuery += " AND BK_DATA = '"+DTOS(dUltFech)+"' ORDER BY BK_LOCALIZ,BK_LOTECTL"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBK",.F.,.T.)
While !Eof() 
  AAdd(aAnaSBK,{BK_LOCALIZ,BK_LOTECTL,BK_QINI,QrySBK->RECNO})
  DBSkip()
Enddo
DBCloseArea()

IF Len(aAnaSBK) == 0
   Aadd(aAnaSBK   ,{Space(15),Space(10),0,Space(08)})
   oDetSBK:nAT := 1
Endif

oAnaSBK:Refresh()
   
Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fDetaSDA()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IncProc("Processando Detalhe - SDA")

cMensDocto  := ""
cMensNumSeq := ""

aSize(aDetDASDA,0)

cQuery := " SELECT DA_DATA,DA_QTDORI,DA_SALDO,DA_LOTECTL,DA_NUMSEQ,DA_ORIGEM,DA_DOC,DA_SERIE,DA_CLIFOR,DA_LOJA,R_E_C_N_O_ AS RECNO FROM "+RETSQLNAME("SDA")+" (NOLOCK) "
cQuery += " WHERE DA_FILIAL='"+xFilial("SDA")+"' AND DA_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SDA")+".D_E_L_E_T_ <> '*' AND DA_PRODUTO = '"+cProduto+"'"
cQuery += " AND DA_SALDO <> 0 AND DA_DATA <= '"+DTOS(dDataF)+"'"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySDA",.F.,.T.)
TCSETFIELD( "QrySDA","DA_DATA","D")
While !Eof() 
  AAdd(aDetDASDA,{DA_DATA,DA_LOTECTL,DA_SALDO,0,DA_QTDORI,DA_NUMSEQ,DA_ORIGEM,DA_DOC,DA_SERIE,DA_CLIFOR,DA_LOJA,"OK",QrySDA->RECNO})
/*
  nPos := Ascan(aDocto,{|x|x[1]== DA_DOC })
  IF nPos == 0
     AAdd(aDocto,{DA_DOC,DA_SERIE,DA_CLIFOR,DA_LOJA,0 ,0 ,0   ,0   ,0   ,0   ,DA_SALDO,0,"SDA","OK",Space(01),Space(01),Space(01)})
//                                                  D1,D2,D3_E,D3_S,D5_E,D5_S,DB_E    ,DB_S
  Else
     aDocto[nPos,11] += DA_SALDO
  Endif   
*/
  nPos := Ascan(aNumSeq,{|x|x[1]== DA_NUMSEQ })
  IF nPos == 0
     AAdd(aNumSeq,{DA_NUMSEQ,0 ,0 ,0   ,0   ,0   ,0   ,DA_SALDO,0,"SDA","OK",DA_DATA,DA_DOC,DA_SERIE,DA_CLIFOR,DA_LOJA,Space(01),Space(01),Space(01)})
//                           D1,D2,D3_E,D3_S,D5_E,D5_S,DB_E    ,DB_S
  Else                                    
     aNumSeq[nPos,8] += DA_SALDO
  Endif   
 
  DBSkip()
Enddo
DBCloseArea()

aSort(aDetDASDA,,, { |x,y| y[6] > x[6]} )      
aSort(aNumSeq  ,,, { |x,y| y[1] > x[1]} )      
//aSort(aDocto   ,,, { |x,y| y[1] > x[1]} )      

nSaldo := 0
For I:= 1 To Len(aDetDASDA)
   nSaldo += aDetDASDA[I,3]
   aDetDASDA[I,4] := nSaldo
Next

//                           D1,D2,D3_E,D3_S,D5_E,D5_S,DB_E,DB_S
//                           5  6  7    8    9    10   11   12
/* Desabilitado por nao ter muita funcionalidade
For I:= 1 To Len(aDocto)
  IF SB1->B1_LOCALIZ = "S" .AND. SB1->B1_RASTRO = "L"
     IF aDocto[I,13] = "SD1" .AND. (aDocto[I,5] <> aDocto[I,9] .OR. aDocto[I,5] <> aDocto[I,11] .OR. aDocto[I,9] <> aDocto[I,11])
        aDocto[I,14] := "Analisar"
        cMensDocto   := "No Documento"
     Endif  
     // SD2
     IF aDocto[I,13] = "SD2" .AND. (aDocto[I,6] <> aDocto[I,10] .OR. aDocto[I,6] <> aDocto[I,12] .OR. aDocto[I,10] <> aDocto[I,12])
        aDocto[I,14] := "Analisar"    
        cMensDocto   := "No Documento"
     Endif
     // SD3
     IF aDocto[I,13] = "SD3" .AND. (aDocto[I,7] <> aDocto[I,9] .OR. aDocto[I,7] <> aDocto[I,11] .OR. aDocto[I,9] <> aDocto[I,11])
        aDocto[I,14] := "Analisar"    
        cMensDocto   := "No Documento"
     Endif
     // SD3
     IF aDocto[I,13] = "SD3" .AND. (aDocto[I,8] <> aDocto[I,10] .OR. aDocto[I,8] <> aDocto[I,12] .OR. aDocto[I,10] <> aDocto[I,12])
        aDocto[I,14] := "Analisar"    
        cMensDocto   := "No Documento"
     Endif 
     IF aDocto[I,13] = "SD5" .OR. aDocto[I,13] = "SDB" .OR. aDocto[I,13] = "SDA"
        aDocto[I,14] := "Analisar"    
        cMensDocto   := "No Documento"
     Endif 
  ElseIF SB1->B1_LOCALIZ = "S"
       IF aDocto[I,13] = "SD1" .AND. (aDocto[I,5] <> aDocto[I,11])
        aDocto[I,14] := "Analisar"
        cMensDocto   := "No Documento"
     Endif  
     // SD2
     IF aDocto[I,13] = "SD2" .AND. (aDocto[I,6] <> aDocto[I,12])
        aDocto[I,14] := "Analisar"    
        cMensDocto   := "No Documento"
     Endif
     // SD3
     IF aDocto[I,13] = "SD3" .AND. (aDocto[I,7] <> aDocto[I,11])
        aDocto[I,14] := "Analisar"    
        cMensDocto   := "No Documento"
     Endif
     // SD3
     IF aDocto[I,13] = "SD3" .AND. (aDocto[I,8] <> aDocto[I,12])
        aDocto[I,14] := "Analisar"    
        cMensDocto   := "No Documento"
     Endif 
     IF aDocto[I,13] = "SDB" .OR. aDocto[I,13] = "SDA"
        aDocto[I,14] := "Analisar"    
        cMensDocto   := "No Documento"
     Endif 
   ElseIF SB1->B1_RASTRO = "L"
     IF aDocto[I,13] = "SD1" .AND. (aDocto[I,5] <> aDocto[I,9])
        aDocto[I,14] := "Analisar"
        cMensDocto   := "No Documento"
     Endif  
     // SD2
     IF aDocto[I,13] = "SD2" .AND. (aDocto[I,6] <> aDocto[I,10])
        aDocto[I,14] := "Analisar"    
        cMensDocto   := "No Documento"
     Endif
     // SD3
     IF aDocto[I,13] = "SD3" .AND. (aDocto[I,7] <> aDocto[I,9])
        aDocto[I,14] := "Analisar"    
        cMensDocto   := "No Documento"
     Endif
     // SD3
     IF aDocto[I,13] = "SD3" .AND. (aDocto[I,8] <> aDocto[I,10])
        aDocto[I,14] := "Analisar"    
        cMensDocto   := "No Documento"
     Endif 
     IF aDocto[I,13] = "SD5"
        aDocto[I,14] := "Analisar"    
        cMensDocto   := "No Documento"
     Endif 
  Endif   
Next
*/

//                           D1,D2,D3_E,D3_S,D5_E,D5_S,DB_E,DB_S     
//                           2  3  4    5    6    7    8    9
For I:= 1 To Len(aNumSeq)                            
  IF SB1->B1_LOCALIZ = "S" .AND. SB1->B1_RASTRO = "L"
     IF aNumSeq[I,10] = "SD1" .AND. (aNumSeq[I,2] <> aNumSeq[I,6] .OR. aNumSeq[I,2] <> aNumSeq[I,8] .OR. aNumSeq[I,6] <> aNumSeq[I,8])
        aNumSeq[I,11] := "Analisar" 
        cMensNumSeq  := "No NumSeq"
     Endif  
     // SD2
     IF aNumSeq[I,10] = "SD2" .AND. (aNumSeq[I,3] <> aNumSeq[I,7] .OR. aNumSeq[I,3] <> aNumSeq[I,9] .OR. aNumSeq[I,7] <> aNumSeq[I,9])
        aNumSeq[I,11] := "Analisar"
        cMensNumSeq   := "No NumSeq"
     Endif
     // SD3
     IF aNumSeq[I,10] = "SD3" .AND. (aNumSeq[I,4] <> aNumSeq[I,6] .OR. aNumSeq[I,4] <> aNumSeq[I,8] .OR. aNumSeq[I,6] <> aNumSeq[I,8])
        aNumSeq[I,11] := "Analisar"
        cMensNumSeq   := "No NumSeq"
     Endif
     // SD3
     IF aNumSeq[I,10] = "SD3" .AND. (aNumSeq[I,5] <> aNumSeq[I,7] .OR. aNumSeq[I,5] <> aNumSeq[I,9] .OR. aNumSeq[I,7] <> aNumSeq[I,9])
        aNumSeq[I,11] := "Analisar"
        cMensNumSeq   := "No NumSeq"
     Endif 
     IF aNumSeq[I,10] = "SD5" .OR. aNumSeq[I,10] = "SDB" .OR. aNumSeq[I,10] = "SDA" 
        aNumSeq[I,11] := "Analisar"
        cMensNumSeq   := "No NumSeq"
     Endif 
  ElseIF SB1->B1_LOCALIZ = "S"
     IF aNumSeq[I,10] = "SD1" .AND. (aNumSeq[I,2] <> aNumSeq[I,8])
        aNumSeq[I,11] := "Analisar" 
        cMensNumSeq  := "No NumSeq"
     Endif  
     // SD2
     IF aNumSeq[I,10] = "SD2" .AND. (aNumSeq[I,3] <> aNumSeq[I,9])
        aNumSeq[I,11] := "Analisar"
        cMensNumSeq   := "No NumSeq"
     Endif
     // SD3
     IF aNumSeq[I,10] = "SD3" .AND. (aNumSeq[I,4] <> aNumSeq[I,8])
        aNumSeq[I,11] := "Analisar"
        cMensNumSeq   := "No NumSeq"
     Endif
     // SD3
     IF aNumSeq[I,10] = "SD3" .AND. (aNumSeq[I,5] <> aNumSeq[I,9])
        aNumSeq[I,11] := "Analisar"
        cMensNumSeq   := "No NumSeq"
     Endif 
     IF aNumSeq[I,10] = "SDB" .OR. aNumSeq[I,10] = "SDA" 
        aNumSeq[I,11] := "Analisar"
        cMensNumSeq   := "No NumSeq"
     Endif 
  ElseIF SB1->B1_RASTRO = "L"
     IF aNumSeq[I,10] = "SD1" .AND. (aNumSeq[I,2] <> aNumSeq[I,6])
        aNumSeq[I,11] := "Analisar" 
        cMensNumSeq  := "No NumSeq"
     Endif  
     // SD2
     IF aNumSeq[I,10] = "SD2" .AND. (aNumSeq[I,3] <> aNumSeq[I,7])
        aNumSeq[I,11] := "Analisar"
        cMensNumSeq   := "No NumSeq"
     Endif
     // SD3
     IF aNumSeq[I,10] = "SD3" .AND. (aNumSeq[I,4] <> aNumSeq[I,6])
        aNumSeq[I,11] := "Analisar"
        cMensNumSeq   := "No NumSeq"
     Endif
     // SD3
     IF aNumSeq[I,10] = "SD3" .AND. (aNumSeq[I,5] <> aNumSeq[I,7])
        aNumSeq[I,11] := "Analisar"
        cMensNumSeq   := "No NumSeq"
     Endif 
     IF aNumSeq[I,10] = "SD5" 
        aNumSeq[I,11] := "Analisar"
        cMensNumSeq   := "No NumSeq"
     Endif 
  Endif  
  IF !Empty(cMensNumSeq)
     IF nKAR = nSD5 .AND. nKAR = nSDB .AND. nSD5 = nSDB .AND.;
        aNumSeq[I,2] = 0 .AND. aNumSeq[I,3] = 0 .AND. aNumSeq[I,4] = 0 .AND. aNumSeq[I,5] = 0 .AND. aNumSeq[I,6] = 0 .AND. aNumSeq[I,7] = 0 
        aNumSeq[I,11] := "OK"
        cMensNumSeq   := ""
     Endif
  Endif 
Next

IF Len(aNumSeq) == 0   
   Aadd(aNumSeq   ,{Space(06),0,0,0,0,0,0,0,0,Space(03),Space(08),CTOD("  /  /  "),Space(06),Space(03),Space(06),Space(02),Space(03),Space(01),Space(01)})
   oNumSeq:nAT := 1
Endif
/*
IF Len(aDocto) == 0    
   Aadd(aDocto    ,{Space(06),Space(03),Space(06),Space(02),0,0,0,0,0,0,0,0,Space(03),Space(08),Space(03),Space(01),Space(01)})
   oDocto:nAT := 1
Endif
*/
IF Len(aDetDASDA) == 0
   Aadd(aDetDASDA ,{CTOD("  /  /  "),Space(10),0,0,0,Space(06),Space(03),Space(06),Space(03),Space(06),Space(02),Space(08)})
   oDetDASDA:nAT := 1
Endif
  
oNumSeq:Refresh()
//oDocto:Refresh()
oDetDASDA:Refresh()
   
Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fDetaDASB8()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IncProc("Processando Detalhe - SDAxSB8")

cMensDAB8   := ""

aSize(aDetDASB8, 0)
  
cQuery := " SELECT B8_DATA,B8_LOTECTL,B8_NUMLOTE,B8_QACLASS,B8_QTDORI,B8_ORIGLAN,B8_DOC,B8_SERIE,B8_CLIFOR,B8_LOJA,R_E_C_N_O_ AS RECNO FROM "+RETSQLNAME("SB8")+" (NOLOCK) "   
cQuery += " WHERE B8_FILIAL='"+xFilial("SB8")+"' AND B8_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SB8")+".D_E_L_E_T_ <> '*' AND B8_PRODUTO = '"+cProduto+"'"
cQuery += /*" AND B8_QACLASS <> 0*/"  AND B8_DATA <= '"+DTOS(dDataF)+"'"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySB8",.F.,.T.)
TCSETFIELD( "QrySB8","B8_DATA","D")
While !Eof() 
  AAdd(aDetDASB8,{B8_DATA,B8_LOTECTL,B8_NUMLOTE,B8_QACLASS,B8_QTDORI,B8_ORIGLAN,B8_DOC,B8_SERIE,B8_CLIFOR,B8_LOJA,"OK",QrySB8->RECNO})
//                1       2          3          4          5         6          7      8        9         10
  DBSkip()
Enddo
DBCloseArea()

nDASB8 := 0
nDASDa := 0

IF SB1->B1_LOCALIZ = "S" .AND. SB1->B1_RASTRO = "L"                
   For I:= 1 To Len(aDetDASB8)
     nDASB8 += aDetDASB8[I,4]
   Next

   For I:= 1 To Len(aDetDASDA)
     nDASDA += aDetDASDA[I,3]
   Next
   
   IF nDASDA <> nDASB8
      cMensDAB8 := "Entre DA x B8"
      For I:= 1 To Len(aDetDASB8)
        aDetDASB8[I,11] := "Analisar"
      Next
      For I:= 1 To Len(aDetDASDA)
        aDetDASDA[I,12] := "Analisar"     
      Next
   Endif
   
Endif

IF Len(aDetDASB8) == 0
   Aadd(aDetDASB8 ,{CTOD("  /  /  "),Space(10),Space(06),0,0,Space(03),Space(06),Space(03),Space(06),Space(02),Space(08),Space(01)})
   oDetDASB8:nAT := 1
Endif

IF Len(aDetDASDA) == 0
   Aadd(aDetDASDA ,{CTOD("  /  /  "),Space(10),0,0,0,Space(06),Space(03),Space(06),Space(03),Space(06),Space(02),Space(08)})
   oDetDASDA:nAT := 1
Endif

oDetDASB8:Refresh()
oDetDASDA:Refresh()        

Return
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fKardLocal()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IncProc("Processando Kardex - Almoxarifado")

aSize(aKarLocal, 0)

DBSelectArea("SB9")
DBSetOrder(1) 
DBSeek(xFilial("SB9")+cProduto+cLocal+DTOS(dUltFech))

// Saldo Inicial
AAdd(aKarLocal,{"SB9",SB9->B9_DATA,Space(3),Space(3),Space(6),SB9->B9_QINI,SB9->B9_QINI,Space(6)})

// Movimento do SD1
cQuery := " SELECT D1_DTDIGIT,D1_TES,D1_CF,D1_DOC,D1_QUANT,D1_NUMSEQ FROM "+RETSQLNAME("SD1")+" (NOLOCK), "+RETSQLNAME("SF4")+" (NOLOCK) " 
cQuery += " WHERE D1_FILIAL='"+xFilial("SD1")+"' AND D1_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SD1")+".D_E_L_E_T_ <> '*' AND D1_COD = '"+cProduto+"'"
cQuery += " AND D1_ORIGLAN <> 'LF' AND D1_DTDIGIT >= '"+DTOS(dDataI)+"' AND D1_DTDIGIT <= '"+DTOS(dDataF)+"'"                                      
cQuery += " AND "+IF(Empty(xFilial("SF4")),"D1_TES=F4_CODIGO","D1_FILIAL=F4_FILIAL AND D1_TES=F4_CODIGO")+" AND F4_ESTOQUE = 'S' AND "+RETSQLNAME("SF4")+".D_E_L_E_T_ <> '*'"
cQuery += " ORDER BY D1_DTDIGIT,D1_NUMSEQ"  
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySD1",.F.,.T.)
TCSETFIELD( "QrySD1","D1_DTDIGIT","D")
While !Eof() 
  AAdd(aKarLocal,{"SD1",D1_DTDIGIT,D1_TES,D1_CF,D1_DOC,D1_QUANT,0,D1_NUMSEQ})
  DBSkip()
Enddo
DBCloseArea()

// Movimento do SD2
cQuery := " SELECT D2_EMISSAO,D2_TES,D2_CF,D2_DOC,D2_QUANT,D2_NUMSEQ FROM "+RETSQLNAME("SD2")+" (NOLOCK) , "+RETSQLNAME("SF4")+" (NOLOCK) "
cQuery += " WHERE D2_FILIAL='"+xFilial("SD2")+"' AND D2_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SD2")+".D_E_L_E_T_ <> '*' AND D2_COD = '"+cProduto+"'"
cQuery += " AND D2_ORIGLAN <> 'LF' AND D2_EMISSAO >= '"+DTOS(dDataI)+"' AND D2_EMISSAO <= '"+DTOS(dDataF)+"'"
cQuery += " AND "+IF(Empty(xFilial("SF4")),"D2_TES=F4_CODIGO","D2_FILIAL=F4_FILIAL AND D2_TES=F4_CODIGO")+" AND F4_ESTOQUE = 'S' AND "+RETSQLNAME("SF4")+".D_E_L_E_T_ <> '*'"
cQuery += " ORDER BY D2_EMISSAO,D2_NUMSEQ"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySD2",.F.,.T.)
TCSETFIELD( "QrySD2","D2_EMISSAO","D")
While !Eof() 
  AAdd(aKarLocal,{"SD2",D2_EMISSAO,D2_TES,D2_CF,D2_DOC,D2_QUANT,0,D2_NUMSEQ})
  DBSkip()
Enddo    
DBCloseArea()

// Movimento do SD3
cQuery := " SELECT D3_EMISSAO,D3_TM,D3_CF,D3_DOC,D3_QUANT,D3_NUMSEQ,R_E_C_N_O_ AS RECNO FROM "+RETSQLNAME("SD3") +" (NOLOCK) "
cQuery += " WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SD3")+".D_E_L_E_T_ <> '*' AND D3_COD = '"+cProduto+"'"
cQuery += " AND D3_ESTORNO=' ' AND D3_EMISSAO >= '"+DTOS(dDataI)+"' AND D3_EMISSAO <= '"+DTOS(dDataF)+"'"
cQuery += " ORDER BY D3_EMISSAO,D3_NUMSEQ"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySD3",.F.,.T.)
TCSETFIELD( "QrySD3","D3_EMISSAO","D")
While !Eof()
  DBSelectArea("SD3")
  DBGoto(QrySD3->RECNO)
  If D3Valido()         
     AAdd(aKarLocal,{"SD3",D3_EMISSAO,D3_TM,D3_CF,D3_DOC,D3_QUANT,0,D3_NUMSEQ})
  Endif              
  DBSelectArea("QrySD3")
  DBSkip()
Enddo 
DBCloseArea()

aSort(aKarLocal,,, { |x,y| y[8] > x[8] } )   

nSldKarLocal := aKarLocal[1,6]
For I:= 2 To Len(aKarLocal)
   nSldKarLocal += IF(aKarLocal[I,3] <= "500",aKarLocal[I,6],aKarLocal[I,6]*-1)
   aKarLocal[I,7] := nSldKarLocal
Next

IF Len(aKarLocal) == 0      
   AAdd(aKarLocal ,{Space(03),Space(08),Space(03),Space(03),Space(06),Space(01),Space(01),Space(06)})
   oKarLocal:nAT := 1
Endif

oKarLocal:Refresh()
   
Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fKardLote()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IncProc("Processando Kardex - Lote")

aSize(aKarLote, 0)

// Identifica os Lotes               
cQuery := " SELECT DISTINCT BJ_LOTECTL AS LOTECTL,BJ_NUMLOTE AS NUMLOTE FROM "+RETSQLNAME("SBJ")+" (NOLOCK) "
cQuery += " WHERE BJ_FILIAL='"+xFilial("SBJ")+"' AND BJ_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SBJ")+".D_E_L_E_T_ <> '*' AND BJ_COD = '"+cProduto+"'"
cQuery += " AND BJ_DATA = '"+DTOS(dUltFech)+"' AND BJ_QINI <> 0"
cQuery += " UNION"
cQuery += " SELECT DISTINCT D5_LOTECTL AS LOTECTL,D5_NUMLOTE AS NUMLOTE FROM "+RETSQLNAME("SD5")+" (NOLOCK) "
cQuery += " WHERE D5_FILIAL='"+xFilial("SD5")+"' AND D5_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SD5")+".D_E_L_E_T_ <> '*' AND D5_PRODUTO = '"+cProduto+"'"
cQuery += " AND D5_ESTORNO= ' ' AND D5_DATA >= '"+DTOS(dDataI)+"' AND D5_DATA <= '"+DTOS(dDataF)+"'"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QryTRB",.F.,.T.)
While !Eof()
  // Movimento do SBJ
  cQuery := " SELECT BJ_LOTECTL,BJ_NUMLOTE,BJ_DTVALID,SUM(BJ_QINI) AS BJ_QINI FROM "+RETSQLNAME("SBJ")+" (NOLOCK) "
  cQuery += " WHERE BJ_FILIAL='"+xFilial("SBJ")+"' AND BJ_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SBJ")+".D_E_L_E_T_ <> '*' AND BJ_COD = '"+cProduto+"'"
  cQuery += " AND BJ_DATA = '"+DTOS(dUltFech)+"' AND BJ_LOTECTL  = '"+QryTRB->LOTECTL+"' AND BJ_NUMLOTE  = '"+QryTRB->NUMLOTE+"'"
  cQuery += " GROUP BY BJ_LOTECTL,BJ_NUMLOTE,BJ_DTVALID"
  cQuery := ChangeQuery(cQuery)
  DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBJ",.F.,.T.)
  TCSETFIELD( "QrySBJ","BJ_DTVALID","D")
  AAdd(aKarLote,{"SBJ"  ,dUltFech ,Space(3),Space(6),QryTRB->LOTECTL,QryTRB->NUMLOTE,BJ_DTVALID,BJ_QINI,0        ,Space(30),QryTRB->LOTECTL+QryTRB->NUMLOTE+"A"+Space(6)})
  AAdd(aKarLote,{"SALDO",dDataF   ,Space(3),Space(6),QryTRB->LOTECTL,QryTRB->NUMLOTE,SPACE(06) ,SPACE(06),0           ,Space(30),QryTRB->LOTECTL+QryTRB->NUMLOTE+"C"+Space(6)})
  AAdd(aKarLote,{"     ",Space(08),Space(3),Space(6),SPACE(06)      ,SPACE(06)      ,SPACE(06) ,SPACE(06),SPACE(06)   ,Space(30),QryTRB->LOTECTL+QryTRB->NUMLOTE+"D"+Space(6)})
  DBCloseArea()
  DBSelectArea("QryTRB")
  DBSkip()
Enddo
DBCloseArea()

// Movimento do SD5
cQuery := " SELECT D5_DATA,D5_ORIGLAN,D5_DOC,D5_LOTECTL,D5_NUMLOTE,D5_DTVALID,D5_QUANT,D5_NUMSEQ FROM "+RETSQLNAME("SD5")+" (NOLOCK) "
cQuery += " WHERE D5_FILIAL='"+xFilial("SD5")+"' AND D5_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SD5")+".D_E_L_E_T_ <> '*' AND D5_PRODUTO = '"+cProduto+"'"
cQuery += " AND D5_ESTORNO= ' ' AND D5_DATA >= '"+DTOS(dDataI)+"' AND D5_DATA <= '"+DTOS(dDataF)+"'"
cQuery += " ORDER BY D5_DATA,D5_NUMSEQ"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySD5",.F.,.T.)
TCSETFIELD( "QrySD5","D5_DATA","D")
TCSETFIELD( "QrySD5","D5_DTVALID","D")
While !Eof() 
  AAdd(aKarLote,{"SD5",D5_DATA,D5_ORIGLAN,D5_DOC,D5_LOTECTL,D5_NUMLOTE,D5_DTVALID,D5_QUANT,0,D5_NUMSEQ,D5_LOTECTL+D5_NUMLOTE+"B"+D5_NUMSEQ})
  DBSkip()
Enddo
DBCloseArea()

aSort(aKarLote,,, { |x,y| y[11]+y[3] > x[11]+x[3] } )   

nSldKarLote := 0
nSaldo      := 0
nSD5        := 0
cMensSB8    := ""                          

For I:= 1 To Len(aKarLote)   
  Do Case
    Case aKarLote[I,1] == "SBJ"
       nSaldo        := aKarLote[I,8]
       aKarLote[I,9] := nSaldo
    Case aKarLote[I,1] == "SD5"
       nSaldo        += IF(aKarLote[I,3] <= "500" .OR. Substr(aKarLote[I,3],1,2) $ 'DE/PR/MA',aKarLote[I,8],aKarLote[I,8]*-1)
       aKarLote[I,9] := nSaldo      
    Case aKarLote[I,1] == "SALDO"
       aKarLote[I,9] := nSaldo
       nSldKarLote   += nSaldo
       nSD5          += nSaldo
       nSalSB8       := 0     
       nPos := Ascan(aDetSB8,{ |x| x[2]+x[3] == aKarLote[I,5]+aKarLote[I,6] })
       If nPos <> 0  
          nSalSB8 += aDetSB8[nPos,5]
       Endif   
       IF nSaldo <> nSalSB8
          aKarLote[I,10] := "Saldo SB8:  "+Alltrim(Str(nSalSB8))+"     DiferenÁa: "+Alltrim(Str(ABS(nSalSB8-nSaldo)))
          cMensSB8       := "SB8 diferente do Kardex por Lote"
          cMensagem      := "DIVERGENCIA"
       Endif
  EndCase
Next

IF Len(aKarLote) == 0
   AAdd(aKarLote  ,{Space(03),Space(08),Space(03),Space(06),Space(06),Space(08),Space(08),Space(01),Space(01),Space(30),Space(01)})
   oKarLote:nAT := 1
Endif

oKarLote:Refresh()
   
Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fKardEnde()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IncProc("Processando Kardex - Endereco")

aSize(aKarEnde, 0)

// Identifica os Enderecos
cQuery := " SELECT DISTINCT BK_LOCALIZ AS LOCALIZ,BK_LOTECTL AS LOTECTL FROM "+RETSQLNAME("SBK")+" (NOLOCK) "
cQuery += " WHERE BK_FILIAL='"+xFilial("SBK")+"' AND BK_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SBK")+".D_E_L_E_T_ <> '*' AND BK_COD = '"+cProduto+"'"
cQuery += " AND BK_DATA = '"+DTOS(dUltFech)+"' AND BK_QINI <> 0"
cQuery += " UNION"
cQuery += " SELECT DISTINCT DB_LOCALIZ AS LOCALIZ,DB_LOTECTL AS LOTECTL FROM "+RETSQLNAME("SDB")+" (NOLOCK) "
cQuery += " WHERE DB_FILIAL='"+xFilial("SDB")+"' AND DB_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SDB")+".D_E_L_E_T_ <> '*' AND DB_PRODUTO = '"+cProduto+"'"
cQuery += " AND DB_ESTORNO=' ' AND DB_ATUEST='S' AND DB_DATA >= '"+DTOS(dDataI)+"' AND DB_DATA <= '"+DTOS(dDataF)+"'"
cQuery += " UNION"
cQuery += " SELECT DISTINCT BF_LOCALIZ AS LOCALIZ,BF_LOTECTL AS LOTECTL FROM "+RETSQLNAME("SBF")+" (NOLOCK) "
cQuery += " WHERE BF_FILIAL='"+xFilial("SBF")+"' AND BF_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SBF")+".D_E_L_E_T_ <> '*' AND BF_PRODUTO = '"+cProduto+"'"
cQuery += " AND BF_QUANT <> 0"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QryTRB",.F.,.T.)
While !Eof()
  // Movimento do SBK
  cQuery := " SELECT BK_LOCALIZ,BK_LOTECTL,SUM(BK_QINI) AS BK_QINI FROM "+RETSQLNAME("SBK")+" (NOLOCK) "
  cQuery += " WHERE BK_FILIAL='"+xFilial("SBK")+"' AND BK_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SBK")+".D_E_L_E_T_ <> '*' AND BK_COD = '"+cProduto+"'"
  cQuery += " AND BK_DATA = '"+DTOS(dUltFech)+"' AND BK_LOCALIZ  = '"+QryTRB->LOCALIZ+"' AND BK_LOTECTL  = '"+QryTRB->LOTECTL+"'"
  cQuery += " GROUP BY BK_LOCALIZ,BK_LOTECTL"           
  cQuery := ChangeQuery(cQuery)
  DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBK",.F.,.T.)
  AAdd(aKarEnde,{"SBK"  ,dUltFech ,Space(3),Space(6),QryTRB->LOCALIZ,QryTRB->LOTECTL,BK_QINI  ,0        ,Space(6),QryTRB->LOCALIZ+QryTRB->LOTECTL+"A"+Space(6)})
  AAdd(aKarEnde,{"SALDO",dDataF   ,Space(3),Space(6),QryTRB->LOCALIZ,QryTRB->LOTECTL,SPACE(06),0        ,Space(6),QryTRB->LOCALIZ+QryTRB->LOTECTL+"C"+Space(6)})
  AAdd(aKarEnde,{"     ",Space(08),Space(3),Space(6),SPACE(06)      ,SPACE(06)      ,SPACE(06),SPACE(06),Space(6),QryTRB->LOCALIZ+QryTRB->LOTECTL+"D"+Space(6)})
  DBCloseArea()
  DBSelectArea("QryTRB")
  DBSkip()
Enddo
DBCloseArea()

// Movimento do SDB
cQuery := " SELECT DB_DATA,DB_TM,DB_DOC,DB_LOCALIZ,DB_LOTECTL,DB_QUANT,DB_NUMSEQ FROM "+RETSQLNAME("SDB")+" (NOLOCK) "
cQuery += " WHERE DB_FILIAL='"+xFilial("SDB")+"' AND DB_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SDB")+".D_E_L_E_T_ <> '*' AND DB_PRODUTO = '"+cProduto+"'"
cQuery += " AND DB_ESTORNO=' ' AND DB_ATUEST='S' AND DB_DATA >= '"+DTOS(dDataI)+"' AND DB_DATA <= '"+DTOS(dDataF)+"'"
cQuery += " ORDER BY DB_DATA,DB_NUMSEQ"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySDB",.F.,.T.)
TCSETFIELD( "QrySDB","DB_DATA","D")
While !Eof() 
  AAdd(aKarEnde,{"SDB",DB_DATA,DB_TM,DB_DOC,DB_LOCALIZ,DB_LOTECTL,DB_QUANT,0,DB_NUMSEQ,DB_LOCALIZ+DB_LOTECTL+"B"+DB_NUMSEQ})
  DBSkip()
Enddo
DBCloseArea()

aSort(aKarEnde,,, { |x,y| y[10]+y[3] > x[10]+x[3] } )   

nSldKarEnde := 0
nSaldo      := 0
nSDB        := 0  
cMensSBF    := ""

For I:= 1 To Len(aKarEnde)   
  Do Case
    Case aKarEnde[I,1] == "SBK"
       nSaldo        := aKarEnde[I,7]
       aKarEnde[I,8] := nSaldo
    Case aKarEnde[I,1] == "SDB"
       nSaldo        += IF(aKarEnde[I,3] <= "500" .OR. Substr(aKarEnde[I,3],1,2) $ 'DE/PR/MA',aKarEnde[I,7],aKarEnde[I,7]*-1)
       aKarEnde[I,8] := nSaldo      
    Case aKarEnde[I,1] == "SALDO"
       aKarEnde[I,8] := nSaldo
       nSldKarEnde   += nSaldo
       nSDB          += nSaldo
       nSalSBF       := 0
       nPos := Ascan(aDetSBF,{ |x| x[1]+x[2] == aKarEnde[I,5]+aKarEnde[I,6] })
       If nPos <> 0 
          nSalSBF += aDetSBF[nPos,3]
       Endif   
       IF nSaldo <> nSalSBF
          aKarEnde[I,9] := "Saldo SBF:  "+Alltrim(Str(nSalSBF))+"     DiferenÁa: "+Alltrim(Str(ABS(nSalSBF-nSaldo)))
          cMensSBF      := "SBF diferente do Kardex por EndereÁo"
          cMensagem     := "DIVERGENCIA"
       Endif
  EndCase
Next

IF Len(aKarEnde) = 0
   AAdd(aKarEnde  ,{Space(03),Space(08),Space(03),Space(06),Space(15),Space(01),Space(01),Space(01),Space(06),Space(01)})
   oKarEnde:nAT := 1
Endif

oKarEnde:Refresh()
   
Return

/*
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fAnaliseDoc()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IncProc("Processando Detalhe Documento")
aSize(aDocto,0)

// SD1
cQuery := " SELECT D1_DOC AS DOC,D1_SERIE AS SERIE, D1_FORNECE AS CLIEFOR, D1_LOJA AS LOJA,D1_SERVIC AS SERVIC,D1_STSERV AS STSERV,SUM(D1_QUANT) AS QUANT FROM "+RETSQLNAME("SD1")+", "+RETSQLNAME("SF4")
cQuery += " WHERE D1_FILIAL='"+xFilial("SD1")+"' AND D1_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SD1")+".D_E_L_E_T_ <> '*' AND D1_COD = '"+cProduto+"'"
cQuery += " AND D1_ORIGLAN <> 'LF' AND D1_DTDIGIT >= '"+DTOS(dDataI)+"' AND D1_DTDIGIT <= '"+DTOS(dDataF)+"'"
cQuery += " AND "+IF(Empty(xFilial("SF4")),"D1_TES=F4_CODIGO","D1_FILIAL=F4_FILIAL AND D1_TES=F4_CODIGO")+" AND F4_ESTOQUE = 'S' AND "+RETSQLNAME("SF4")+".D_E_L_E_T_ <> '*'"
cQuery += " GROUP BY D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_SERVIC,D1_STSERV"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QryTRB",.F.,.T.)
While !Eof()
  Do Case
     Case !Empty(QryTRB->SERVIC) .AND. QryTRB->STSERV = "1"; cStServ := "A Executar"
     Case !Empty(QryTRB->SERVIC) .AND. QryTRB->STSERV = "2"; cStServ := "Interrompido"
     Case !Empty(QryTRB->SERVIC) .AND. QryTRB->STSERV = "3"; cStServ := "Ja Executado"   
     OtherWise;                                              cStServ := Space(1)     
  EndCase   
  AAdd(aDocto,{QryTRB->DOC,QryTRB->SERIE,QryTRB->CLIEFOR,QryTRB->LOJA,QryTRB->QUANT,0 ,0   ,0   ,0   ,0   ,0   ,0   ,"SD1","OK",QryTRB->SERVIC,cStServ,Space(1)})
 //                                                                   D1           ,D2,D3_E,D3_S,D5_E,D5_S,DB_E,DB_S
  DBSkip()
Enddo
DBCloseArea()

// SD2
cQuery := " SELECT D2_DOC AS DOC,D2_SERIE AS SERIE, D2_CLIENTE AS CLIEFOR, D2_LOJA AS LOJA,SUM(D2_QUANT) AS QUANT FROM "+RETSQLNAME("SD2")+", "+RETSQLNAME("SF4")
cQuery += " WHERE D2_FILIAL='"+xFilial("SD2")+"' AND D2_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SD2")+".D_E_L_E_T_ <> '*' AND D2_COD = '"+cProduto+"'"
cQuery += " AND D2_ORIGLAN <> 'LF' AND D2_EMISSAO >= '"+DTOS(dDataI)+"' AND D2_EMISSAO <= '"+DTOS(dDataF)+"'"
cQuery += " AND "+IF(Empty(xFilial("SF4")),"D2_TES=F4_CODIGO","D2_FILIAL=F4_FILIAL AND D2_TES=F4_CODIGO")+" AND F4_ESTOQUE = 'S' AND "+RETSQLNAME("SF4")+".D_E_L_E_T_ <> '*'"
cQuery += " GROUP BY D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QryTRB",.F.,.T.)
While !Eof()
  AAdd(aDocto,{QryTRB->DOC,QryTRB->SERIE,QryTRB->CLIEFOR,QryTRB->LOJA,0 ,QryTRB->QUANT,0   ,0   ,0   ,0   ,0   ,0   ,"SD2","OK",Space(01),Space(01),Space(01)})
  //                                                                  D1,D2           ,D3_E,D3_S,D5_E,D5_S,DB_E,DB_S

  DBSkip()
Enddo
DBCloseArea()

// SD3
cQuery := " SELECT D3_DOC,D3_SERVIC,D3_STSERV,D3_TM,D3_QUANT FROM "+RETSQLNAME("SD3")
cQuery += " WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SD3")+".D_E_L_E_T_ <> '*' AND D3_COD = '"+cProduto+"'"
cQuery += " AND D3_ESTORNO = ' ' AND D3_EMISSAO >= '"+DTOS(dDataI)+"' AND D3_EMISSAO <= '"+DTOS(dDataF)+"'"
cQuery += " ORDER BY D3_DOC"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QryTRB",.F.,.T.)
While !Eof()
  Do Case
     Case !Empty(D3_SERVIC) .AND. D3_STSERV = "1"; cStServ := "A Executar"
     Case !Empty(D3_SERVIC) .AND. D3_STSERV = "2"; cStServ := "Interrompido"
     Case !Empty(D3_SERVIC) .AND. D3_STSERV = "3"; cStServ := "Ja Executado"   
     OtherWise;                                    cStServ := Space(1)     
  EndCase   
  nPos := Ascan(aDocto,{|x|x[1]== D3_DOC })
  IF nPos == 0
     IF D3_TM <= "500"
        AAdd(aDocto,{D3_DOC,Space(03),Space(06),Space(02),0 ,0 ,D3_QUANT,0   ,0   ,0   ,0   ,0   ,"SD3","OK",D3_SERVIC,cStServ,Space(01)})
//                                                        D1,D2,D3_E    ,D3_S,D5_E,D5_S,DB_E,DB_S
     Else
        AAdd(aDocto,{D3_DOC,Space(03),Space(06),Space(02),0 ,0 ,0   ,D3_QUANT,0   ,0   ,0   ,0   ,"SD3","OK",D3_SERVIC,cStServ,Space(01)})
//                                                        D1,D2,D3_E,D3_S    ,D5_E,D5_S,DB_E,DB_S
     Endif
  Else
     IF D3_TM <= "500"
        aDocto[nPos,7] += D3_QUANT
     Else
        aDocto[nPos,8] += D3_QUANT
     Endif    
  Endif   
  DBSkip()
Enddo
DBCloseArea()

// SD5
cQuery := " SELECT D5_DOC,D5_SERIE,D5_CLIFOR,D5_LOJA,D5_ORIGLAN,D5_QUANT FROM "+RETSQLNAME("SD5")
cQuery += " WHERE D5_FILIAL='"+xFilial("SD5")+"' AND D5_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SD5")+".D_E_L_E_T_ <> '*' AND D5_PRODUTO = '"+cProduto+"'"
cQuery += " AND D5_ESTORNO = ' ' AND D5_DATA >= '"+DTOS(dDataI)+"' AND D5_DATA <= '"+DTOS(dDataF)+"'"
cQuery += " ORDER BY D5_DOC,D5_SERIE,D5_CLIFOR,D5_LOJA"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QryTRB",.F.,.T.)
While !Eof()
//  nPos := Ascan(aDocto,{|x|x[1]+x[2]+x[3]+x[4] == D5_DOC+D5_SERIE+D5_CLIFOR+D5_LOJA })
  nPos := Ascan(aDocto,{|x|x[1] == D5_DOC })
  IF nPos == 0
     IF D5_ORIGLAN <= "500" .OR. Substr(D5_ORIGLAN,1,2) $ 'DE/PR/MA'
        AAdd(aDocto,{D5_DOC,D5_SERIE,D5_CLIFOR,D5_LOJA,0 ,0 ,0  ,0   ,D5_QUANT,0   ,0   ,0   ,"SD5","OK",Space(01),Space(01),Space(01)})
//                                                     D1,D2,D3_E,D3_S,D5_E    ,D5_S,DB_E,DB_S
     Else
        AAdd(aDocto,{D5_DOC,D5_SERIE,D5_CLIFOR,D5_LOJA,0 ,0 ,0  ,0   ,0   ,D5_QUANT,0   ,0   ,"SD5","OK",Space(01),Space(01),Space(01)})
//                                                     D1,D2,D3_E,D3_S,D5_E,D5_S    ,DB_E,DB_S
     Endif
  Else                                    
     IF D5_ORIGLAN <= "500" .OR. Substr(D5_ORIGLAN,1,2) $ 'DE/PR/MA'
        aDocto[nPos,09] += D5_QUANT
     Else
        aDocto[nPos,10] += D5_QUANT
     Endif    
  Endif   
  DBSkip()
Enddo
DBCloseArea()

// SDB
cQuery := " SELECT DB_DOC,DB_SERIE,DB_CLIFOR,DB_LOJA,DB_TM,DB_QUANT FROM "+RETSQLNAME("SDB")
cQuery += " WHERE DB_FILIAL='"+xFilial("SDB")+"' AND DB_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SDB")+".D_E_L_E_T_ <> '*' AND DB_PRODUTO = '"+cProduto+"'"
cQuery += " AND DB_ESTORNO = ' ' AND DB_ATUEST='S' AND DB_DATA >= '"+DTOS(dDataI)+"' AND DB_DATA <= '"+DTOS(dDataF)+"'"
cQuery += " ORDER BY DB_DOC,DB_SERIE,DB_CLIFOR,DB_LOJA"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QryTRB",.F.,.T.)
While !Eof()
//  nPos := Ascan(aDocto,{|x|x[1]+x[2]+x[3]+x[4] == DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA })
  nPos := Ascan(aDocto,{|x|x[1] == DB_DOC })
  IF nPos == 0
     IF DB_TM <= "500" .OR. Substr(DB_TM,1,2) $ 'DE/PR/MA'
        AAdd(aDocto,{DB_DOC,DB_SERIE,DB_CLIFOR,DB_LOJA,0 ,0 ,0   ,0   ,0   ,0   ,DB_QUANT,0   ,"SDB","OK",Space(01),Space(01),Space(01)})
//                                                     D1,D2,D3_E,D3_S,D5_E,D5_S,DB_E    ,DB_S
     Else
        AAdd(aDocto,{DB_DOC,DB_SERIE,DB_CLIFOR,DB_LOJA,0 ,0 ,0   ,0   ,0   ,0   ,0   ,DB_QUANT,"SDB","OK",Space(01),Space(01),Space(01)})
//                                                     D1,D2,D3_E,D3_S,D5_E,D5_S,DB_E,DB_S
     Endif
  Else                                    
     IF DB_TM <= "500" .OR. Substr(DB_TM,1,2) $ 'DE/PR/MA'
        aDocto[nPos,11] += DB_QUANT
     Else
        aDocto[nPos,12] += DB_QUANT
     Endif    
  Endif   
  DBSkip()
Enddo
DBCloseArea()

// SDB - Servicos Pendentes
cQuery := " SELECT DB_DOC,DB_SERIE,DB_CLIFOR,DB_LOJA,DB_TM,DB_QUANT FROM "+RETSQLNAME("SDB")
cQuery += " WHERE DB_FILIAL='"+xFilial("SDB")+"' AND DB_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SDB")+".D_E_L_E_T_ <> '*' AND DB_PRODUTO = '"+cProduto+"'"
cQuery += " AND DB_ESTORNO = ' ' AND DB_ATUEST='N' AND DB_STATUS IN ('2','3','4') AND DB_DATA >= '"+DTOS(dDataI)+"' AND DB_DATA <= '"+DTOS(dDataF)+"'"
cQuery += " ORDER BY DB_DOC,DB_SERIE,DB_CLIFOR,DB_LOJA"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QryTRB",.F.,.T.)
While !Eof()
  nPos := Ascan(aDocto,{|x|x[1]+x[2]+x[3]+x[4] == DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA })
  IF nPos <> 0
     aDocto[nPos,17] := "Sim"
  Endif   
  DBSkip()
Enddo
DBCloseArea()

Return
*/

/*
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fSoDocto()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local aArray := {}
For I:= 1 To Len(aDocto)
   IF aDocto[I,14] = "Analisar"
      AAdd(aArray,aDocto[I])
  Endif 
Next
aSize(aDocto,0)
For I:= 1 To Len(aArray)
   AAdd(aDocto,aArray[I])
Next
oDocto:Refresh()
Return
*/

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fSoNumseq()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local aArray := {}
For I:= 1 To Len(aNumseq)
   IF aNumseq[I,11] = "Analisar"
      AAdd(aArray,aNumseq[I])
  Endif 
Next
aSize(aNumseq,0)
For I:= 1 To Len(aArray)
   AAdd(aNumseq,aArray[I])
Next
oNumseq:Refresh()
Return
                  

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fNumSeq()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IncProc("Processando Detalhe NumSeq")

aSize(aNumSeq, 0)

// SD1
cQuery := " SELECT D1_NUMSEQ AS NUMSEQ,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_DTDIGIT,D1_SERVIC AS SERVIC,D1_STSERV AS STSERV,SUM(D1_QUANT) AS QUANT FROM "+RETSQLNAME("SD1")+" (NOLOCK) , "+RETSQLNAME("SF4")+" (NOLOCK) "
cQuery += " WHERE D1_FILIAL='"+xFilial("SD1")+"' AND D1_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SD1")+".D_E_L_E_T_ <> '*' AND D1_COD = '"+cProduto+"'"
cQuery += " AND D1_ORIGLAN <> 'LF' AND D1_DTDIGIT >= '"+DTOS(dDataI)+"' AND D1_DTDIGIT <= '"+DTOS(dDataF)+"'"
cQuery += " AND "+IF(Empty(xFilial("SF4")),"D1_TES=F4_CODIGO","D1_FILIAL=F4_FILIAL AND D1_TES=F4_CODIGO")+" AND F4_ESTOQUE = 'S' AND "+RETSQLNAME("SF4")+".D_E_L_E_T_ <> '*'"
cQuery += " GROUP BY D1_NUMSEQ,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_DTDIGIT,D1_SERVIC,D1_STSERV"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QryTRB",.F.,.T.)
TCSETFIELD( "QryTRB","D1_DTDIGIT","D")
While !Eof()
  Do Case
     Case !Empty(QryTRB->SERVIC) .AND. QryTRB->STSERV = "1"; cStServ := "A Executar"
     Case !Empty(QryTRB->SERVIC) .AND. QryTRB->STSERV = "2"; cStServ := "Interrompido"
     Case !Empty(QryTRB->SERVIC) .AND. QryTRB->STSERV = "3"; cStServ := "Ja Executado"   
     OtherWise;                                              cStServ := Space(1)     
  EndCase   
  AAdd(aNumSeq,{QryTRB->NUMSEQ,QryTRB->QUANT,0 ,0   ,0   ,0   ,0   ,0   ,0   ,"SD1","OK",QryTRB->D1_DTDIGIT,QryTRB->D1_DOC,QryTRB->D1_SERIE,QryTRB->D1_FORNECE,QryTRB->D1_LOJA,QryTRB->SERVIC,cStServ,Space(01)})
  //                           D1           ,D2,D3_E,D3_S,D5_E,D5_S,DB_E,DB_S
  DBSkip()
Enddo
DBCloseArea()                                                                                                       

// SD2
cQuery := " SELECT D2_NUMSEQ AS NUMSEQ,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_EMISSAO,SUM(D2_QUANT) AS QUANT FROM "+RETSQLNAME("SD2")+" (NOLOCK) , "+RETSQLNAME("SF4")+" (NOLOCK) "
cQuery += " WHERE D2_FILIAL='"+xFilial("SD2")+"' AND D2_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SD2")+".D_E_L_E_T_ <> '*' AND D2_COD = '"+cProduto+"'"
cQuery += " AND D2_ORIGLAN <> 'LF' AND D2_EMISSAO >= '"+DTOS(dDataI)+"' AND D2_EMISSAO <= '"+DTOS(dDataF)+"'"
cQuery += " AND "+IF(Empty(xFilial("SF4")),"D2_TES=F4_CODIGO","D2_FILIAL=F4_FILIAL AND D2_TES=F4_CODIGO")+" AND F4_ESTOQUE = 'S' AND "+RETSQLNAME("SF4")+".D_E_L_E_T_ <> '*'"
cQuery += " GROUP BY D2_NUMSEQ,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_EMISSAO"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QryTRB",.F.,.T.)
TCSETFIELD( "QryTRB","D2_EMISSAO","D")
While !Eof()
  AAdd(aNumSeq,{QryTRB->NUMSEQ,0 ,QryTRB->QUANT,0   ,0   ,0   ,0   ,0   ,0   ,"SD2","OK",QryTRB->D2_EMISSAO,QryTRB->D2_DOC,QryTRB->D2_SERIE,QryTRB->D2_CLIENTE,QryTRB->D2_LOJA,Space(01),Space(01),Space(01)})
  //                           D1,D2           ,D3_E,D3_S,D5_E,D5_S,DB_E,DB_S
  DBSkip()
Enddo
DBCloseArea()

// SD3
cQuery := " SELECT D3_NUMSEQ,D3_DOC,D3_EMISSAO,D3_SERVIC,D3_STSERV,D3_TM,D3_QUANT FROM "+RETSQLNAME("SD3")+" (NOLOCK) "
cQuery += " WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SD3")+".D_E_L_E_T_ <> '*' AND D3_COD = '"+cProduto+"'"
cQuery += " AND D3_ESTORNO = ' ' AND D3_EMISSAO >= '"+DTOS(dDataI)+"' AND D3_EMISSAO <= '"+DTOS(dDataF)+"'"
cQuery += " ORDER BY D3_NUMSEQ,D3_DOC"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QryTRB",.F.,.T.)
TCSETFIELD( "QryTRB","D3_EMISSAO","D")
While !Eof()
  Do Case
     Case !Empty(D3_SERVIC) .AND. D3_STSERV = "1"; cStServ := "A Executar"
     Case !Empty(D3_SERVIC) .AND. D3_STSERV = "2"; cStServ := "Interrompido"
     Case !Empty(D3_SERVIC) .AND. D3_STSERV = "3"; cStServ := "Ja Executado"   
     OtherWise;                                    cStServ := Space(1)     
  EndCase   
  nPos := Ascan(aNumSeq,{|x|x[1]== D3_NUMSEQ })
  IF nPos == 0
     IF D3_TM <= "500"
        AAdd(aNumSeq,{D3_NUMSEQ,0 ,0 ,D3_QUANT,0   ,0   ,0   ,0   ,0   ,"SD3","OK",QryTRB->D3_EMISSAO,D3_DOC,Space(01),Space(01),Space(01),D3_SERVIC,cStServ,Space(01)})
//                              D1,D2,D3_E    ,D3_S,D5_E,D5_S,DB_E,DB_S
     Else
        AAdd(aNumSeq,{D3_NUMSEQ,0 ,0 ,0   ,D3_QUANT,0   ,0   ,0   ,0   ,"SD3","OK",QryTRB->D3_EMISSAO,D3_DOC,Space(01),Space(01),Space(01),D3_SERVIC,cStServ,Space(01)})
//                             D1,D2,D3_E,D3_S    ,D5_E,D5_S,DB_E,DB_S
     Endif
  Else
     IF D3_TM <= "500"
        aNumSeq[nPos,4] += D3_QUANT
     Else
        aNumSeq[nPos,5] += D3_QUANT
     Endif    
  Endif   
  DBSkip()
Enddo
DBCloseArea()

// SD5
cQuery := " SELECT D5_NUMSEQ,D5_DATA,D5_ORIGLAN,D5_DOC,D5_SERIE,D5_CLIFOR,D5_LOJA,D5_QUANT FROM "+RETSQLNAME("SD5")+" (NOLOCK) "
cQuery += " WHERE D5_FILIAL='"+xFilial("SD5")+"' AND D5_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SD5")+".D_E_L_E_T_ <> '*' AND D5_PRODUTO = '"+cProduto+"'"
cQuery += " AND D5_ESTORNO = ' ' AND D5_DATA >= '"+DTOS(dDataI)+"' AND D5_DATA <= '"+DTOS(dDataF)+"'"
cQuery += " ORDER BY D5_NUMSEQ"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QryTRB",.F.,.T.)
TCSETFIELD( "QryTRB","D5_DATA","D")
While !Eof()
  nPos := Ascan(aNumSeq,{|x|x[1]== D5_NUMSEQ })
  IF nPos == 0
     IF D5_ORIGLAN <= "500" .OR. Substr(D5_ORIGLAN,1,2) $ 'DE/PR/MA'
        AAdd(aNumSeq,{D5_NUMSEQ,0 ,0 ,0  ,0   ,D5_QUANT,0   ,0   ,0   ,"SD5","OK",D5_DATA,D5_DOC,D5_SERIE,D5_CLIFOR,D5_LOJA,Space(01),Space(01),Space(01)})
//                             D1,D2,D3_E,D3_S,D5_E    ,D5_S,DB_E,DB_S
     Else
        AAdd(aNumSeq,{D5_NUMSEQ,0 ,0 ,0  ,0   ,0   ,D5_QUANT,0   ,0   ,"SD5","OK",D5_DATA,D5_DOC,D5_SERIE,D5_CLIFOR,D5_LOJA,Space(01),Space(01),Space(01)})
//                             D1,D2,D3_E,D3_S,D5_E,D5_S    ,DB_E,DB_S
     Endif
  Else                                    
     IF D5_ORIGLAN <= "500" .OR. Substr(D5_ORIGLAN,1,2) $ 'DE/PR/MA'
        aNumSeq[nPos,6] += D5_QUANT
     Else
        aNumSeq[nPos,7] += D5_QUANT
     Endif    
  Endif   
  DBSkip()
Enddo
DBCloseArea()

// SDB
cQuery := " SELECT DB_NUMSEQ,DB_DATA,DB_TM,DB_DOC,DB_SERIE,DB_CLIFOR,DB_LOJA,DB_QUANT FROM "+RETSQLNAME("SDB")+" (NOLOCK) "
cQuery += " WHERE DB_FILIAL='"+xFilial("SDB")+"' AND DB_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SDB")+".D_E_L_E_T_ <> '*' AND DB_PRODUTO = '"+cProduto+"'"
cQuery += " AND DB_ESTORNO = ' ' AND DB_ATUEST='S' AND DB_DATA >= '"+DTOS(dDataI)+"' AND DB_DATA <= '"+DTOS(dDataF)+"'"
cQuery += " ORDER BY DB_NUMSEQ"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QryTRB",.F.,.T.)
TCSETFIELD( "QryTRB","DB_DATA","D")
While !Eof()
  nPos := Ascan(aNumSeq,{|x|x[1]== DB_NUMSEQ })
  IF nPos == 0
     IF DB_TM <= "500" .OR. Substr(DB_TM,1,2) $ 'DE/PR/MA'
        AAdd(aNumSeq,{DB_NUMSEQ,0 ,0 ,0   ,0   ,0   ,0   ,DB_QUANT,0   ,"SDB","OK",DB_DATA,DB_DOC,DB_SERIE,DB_CLIFOR,DB_LOJA,Space(01),Space(01),Space(01)})
//                              D1,D2,D3_E,D3_S,D5_E,D5_S,DB_E    ,DB_S
     Else
        AAdd(aNumSeq,{DB_NUMSEQ,0 ,0 ,0   ,0   ,0   ,0   ,0   ,DB_QUANT,"SDB","OK",DB_DATA,DB_DOC,DB_SERIE,DB_CLIFOR,DB_LOJA,Space(01),Space(01),Space(01)})
//                              D1,D2,D3_E,D3_S,D5_E,D5_S,DB_E,DB_S
     Endif
  Else                                    
     IF DB_TM <= "500" .OR. Substr(DB_TM,1,2) $ 'DE/PR/MA'
        aNumSeq[nPos,8] += DB_QUANT
     Else
        aNumSeq[nPos,9] += DB_QUANT
     Endif    
  Endif   
  DBSkip()
Enddo
DBCloseArea()

// SDB - Servicos Pendentes
cQuery := " SELECT DB_NUMSEQ,DB_TM,DB_DOC,DB_QUANT FROM "+RETSQLNAME("SDB")+" (NOLOCK) "
cQuery += " WHERE DB_FILIAL='"+xFilial("SDB")+"' AND DB_LOCAL='"+cLocal+"' AND "+RETSQLNAME("SDB")+".D_E_L_E_T_ <> '*' AND DB_PRODUTO = '"+cProduto+"'"
cQuery += " AND DB_ESTORNO = ' ' AND DB_ATUEST='N' AND DB_STATUS IN ('2','3','4') AND DB_DATA >= '"+DTOS(dDataI)+"' AND DB_DATA <= '"+DTOS(dDataF)+"'"
cQuery += " ORDER BY DB_DOC,DB_SERIE,DB_CLIFOR,DB_LOJA"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QryTRB",.F.,.T.)
While !Eof()
  nPos := Ascan(aNumSeq,{|x|x[1]== DB_NUMSEQ })
  IF nPos <> 0
     aNumSeq[nPos,19] := "Sim"
  Endif   
  DBSkip()
Enddo
DBCloseArea()

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fAjustSB2(cOpcao)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local oDlgSB2
Local aArea    := GetArea()
Local nQuant   := IF(cOpcao="SALDO_SB2",nSB2,nDASB2)

DBSelectArea("SB1")

DEFINE MSDIALOG oDlgSB2 TITLE "Ajuste no SB2"  OF oDlgSB2 PIXEL FROM 010,010 TO 200,265 
DEFINE FONT oBold   NAME "Arial" SIZE 0, -12 BOLD

@ 024,005 SAY "Quantidade"                              SIZE 040,10 PIXEL OF oDlgSB2 FONT oBold 
@ 020,043 MSGET oVar  VAR  nQuant  Picture cPict        SIZE 050,10 PIXEL OF oDlgSB2 
                                                     //fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,cEndereco,cNumSeq,cTipoMov,cNumLote,cSerie,cCliFor,cLoja)
@ 075,050 BUTTON "&Confirmar" SIZE 30,14 PIXEL ACTION (fAjusta(cOpcao,        ,    ,     ,nQuant),oDlgSB2:End())
@ 075,090 BUTTON "&Sair"      SIZE 30,14 PIXEL ACTION oDlgSB2:End()

ACTIVATE MSDIALOG oDlgSB2  CENTERED

RestArea(aArea)          

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fAjustEmp(cOpcao)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local oDlgSB2
Local aArea    := GetArea()
Local nQuant   := nEmpSB2

DBSelectArea("SB1")

DEFINE MSDIALOG oDlgSB2 TITLE "Ajuste no Empenho"  OF oDlgSB2 PIXEL FROM 010,010 TO 200,265 
DEFINE FONT oBold   NAME "Arial" SIZE 0, -12 BOLD

@ 024,005 SAY "Quantidade"                              SIZE 040,10 PIXEL OF oDlgSB2 FONT oBold 
@ 020,043 MSGET oVar  VAR  nQuant  Picture cPict        SIZE 050,10 PIXEL OF oDlgSB2 
                                                     //fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,cEndereco,cNumSeq,cTipoMov,cNumLote,cSerie,cCliFor,cLoja)
@ 075,050 BUTTON "&Confirmar" SIZE 30,14 PIXEL ACTION (fAjusta(cOpcao,        ,    ,     ,nQuant),oDlgSB2:End())
@ 075,090 BUTTON "&Sair"      SIZE 30,14 PIXEL ACTION oDlgSB2:End()

ACTIVATE MSDIALOG oDlgSB2  CENTERED

RestArea(aArea)          

Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fAjustSB9(cOpcao)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local oDlgSB9
Local aArea    := GetArea()
Local nQuant   := nSB9

Return

DBSelectArea("SB1")

DEFINE MSDIALOG oDlgSB9 TITLE "Ajuste no SB9"  OF oDlgSB9 PIXEL FROM 010,010 TO 200,265 
DEFINE FONT oBold   NAME "Arial" SIZE 0, -12 BOLD

@ 024,005 SAY "Quantidade"                              SIZE 040,10 PIXEL OF oDlgSB9 FONT oBold 
@ 020,043 MSGET oVar  VAR  nQuant  Picture cPict        SIZE 050,10 PIXEL OF oDlgSB9 
                                                     //fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,cEndereco,cNumSeq,cTipoMov,cNumLote,cSerie,cCliFor,cLoja)
@ 075,050 BUTTON "&Confirmar" SIZE 30,14 PIXEL ACTION (fAjusta(cOpcao,        ,    ,     ,nQuant),oDlgSB9:End())
@ 075,090 BUTTON "&Sair"      SIZE 30,14 PIXEL ACTION oDlgSB9:End()

ACTIVATE MSDIALOG oDlgSB9  CENTERED

RestArea(aArea)

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fAjustSB8(cOpcao)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local oDlgSB8
Local aArea    := GetArea()
Local dData    := IF(Len(aDetSB8)>0,aDetSB8[oDetSB8:nAT][01],dDataBase)
Local cLoteCtl := IF(Len(aDetSB8)>0,aDetSB8[oDetSB8:nAT][02],SPACE(10))
Local cNumLote := IF(Len(aDetSB8)>0,aDetSB8[oDetSB8:nAT][03],SPACE(06))
Local nQuant   := IF(Len(aDetSB8)>0,aDetSB8[oDetSB8:nAT][05],0)
Local cDoc     :=  "AJ"+Substr(DTOC(dDataBase),4,2)+Substr(DTOC(dDataBase),7,2)
Local lVisLote := lVisDoc := lVisData := lVisNumLote := lVisQuant := .T.

IF cOpcao = "B8_A" //Alterar
   lVisLote  := lVisDoc := lVisData := lVisNumLote := .F.
ElseIF cOpcao = "B8_E" //Excluir
   lVisLote := lVisDoc := lVisData := lVisNumLote := lVisQuant := .F.
Endif

DBSelectArea("SB1")

DEFINE MSDIALOG oDlgSB8 TITLE "Ajuste no SB8"  OF oDlgSB8 PIXEL FROM 010,010 TO 215,295 
DEFINE FONT oBold   NAME "Arial" SIZE 0, -12 BOLD

@ 009,005 SAY "Num.Lote"                                SIZE 040,10 PIXEL OF oDlgSB8 FONT oBold 
@ 005,043 MSGET oVar   VAR cNumLote Picture "@!"        SIZE 040,10 PIXEL OF oDlgSB8 When lVisNumLote
@ 024,005 SAY "Lote"                                    SIZE 040,10 PIXEL OF oDlgSB8 FONT oBold 
@ 020,043 MSGET oVar   VAR cLoteCtl Picture "@!"        SIZE 040,10 PIXEL OF oDlgSB8 When lVisLote
@ 039,005 SAY "Documento"                               SIZE 040,10 PIXEL OF oDlgSB8 FONT oBold 
@ 035,043 MSGET oVar   VAR cDoc     Picture "@!"        SIZE 030,10 PIXEL OF oDlgSB8 When lVisDoc
@ 054,005 SAY "Data"                                    SIZE 040,10 PIXEL OF oDlgSB8 FONT oBold  
@ 050,043 MSGET oVar   VAR dData    Picture "99/99/99"  SIZE 040,10 PIXEL OF oDlgSB8 When lVisData 
@ 069,005 SAY "Quantidade"                              SIZE 040,10 PIXEL OF oDlgSB8 FONT oBold 
@ 065,043 MSGET oVar   VAR nQuant   Picture cPict       SIZE 050,10 PIXEL OF oDlgSB8 When lVisQuant
                                                     //fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,cEndereco,cNumSeq,cTipoMov,cNumLote,cSerie,cCliFor,cLoja)
@ 085,050 BUTTON "&Confirmar" SIZE 30,14 PIXEL ACTION (fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,Nil      ,Nil    ,Nil     ,cNumLote),oDlgSB8:End())
@ 085,090 BUTTON "&Sair"      SIZE 30,14 PIXEL ACTION oDlgSB8:End()

ACTIVATE MSDIALOG oDlgSB8  CENTERED

RestArea(aArea)

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fAjustSD5(cOpcao,cFolder)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local oDlgSD5
Local aArea    := GetArea()
Local lVisLote := lVisDoc := lVisSerie := lVisCliFor := lVisLoja := lVisData := lVisQuant := lVisNumSeq := lVisNumLote := .T.
Local dData    := CTOD('  /  /    ')
Local cDoc     := SPACE(9)
Local cSerie   := SPACE(3)
Local cCliFor  := SPACE(6)
Local cLoja    := SPACE(2)
Local cLoteCtl := SPACE(10)
Local cNumSeq  := SPACE(6)
Local cNumLote := SPACE(6)
Local nQuant   := 0
Local dDtValid := CTOD('  /  /    ')

IF cFolder = "02"
   dData    := IF(Len(aDetSD5)>0,aDetSD5[oDetSD5:nAT][01],dDataBase)
   cDoc     := IF(Len(aDetSD5)>0,aDetSD5[oDetSD5:nAT][10],Space(06))
   cSerie   := IF(Len(aDetSD5)>0,aDetSD5[oDetSD5:nAT][11],Space(03))	//dDataBase)
   cCliFor  := IF(Len(aDetSD5)>0,aDetSD5[oDetSD5:nAT][12],Space(06))	//dDataBase)
   cLoja    := IF(Len(aDetSD5)>0,aDetSD5[oDetSD5:nAT][13],Space(03))	//dDataBase)
   cLoteCtl := IF(Len(aDetSD5)>0,aDetSD5[oDetSD5:nAT][03],SPACE(10))
   cNumSeq  := IF(Len(aDetSD5)>0,aDetSD5[oDetSD5:nAT][08],SPACE(06))
   cNumLote := IF(Len(aDetSD5)>0,aDetSD5[oDetSD5:nAT][04],SPACE(06))
   nQuant   := IF(Len(aDetSD5)>0,aDetSD5[oDetSD5:nAT][06],0)
   dDtValid := IF(Len(aDetSD5)>0,aDetSD5[oDetSD5:nAT][05],CTOD("  /  /  "))
ElseIF cFolder = "13"                  
   cNumSeq  := aNumSeq[oNumSeq:nAT][01]
   DBSelectArea("SD5")
   DBSetOrder(3) //-- D5_FILIAL+D5_NUMSEQ+D5_PRODUTO+D5_LOCAL+D5_LOTECTL+D5_NUMLOTE
   IF DBSeek(xFilial("SD5")+cNumSeq)
      cNumLote := D5_NUMLOTE
      dDtValid := D5_DTVALID
   Else
      cNumLote := Space(6)  
      dDtValid := CTOD("  /  /  ")
   Endif
   Do Case
     Case !Empty(aNumSeq[oNumSeq:nAT][02])
       DBSelectArea("SD1")
       DBSetOrder(4) //--D1_FILIAL+D1_NUMSEQ
       IF DBSeek(xFilial("SD1")+cNumSeq)
          dData    := D1_DTDIGIT
          cDoc     := D1_DOC
          cSerie   := D1_SERIE
          cCliFor  := D1_FORNECE
          cLoja    := D1_LOJA
          cLoteCtl := D1_LOTECTL
          nQuant   := D1_QUANT
       Endif
     Case !Empty(aNumSeq[oNumSeq:nAT][03])
       DBSelectArea("SD2")
       DBSetOrder(4) //--D2_FILIAL+D2_NUMSEQ
       IF DBSeek(xFilial("SD2")+cNumSeq)
          dData    := D2_EMISSAO
          cDoc     := D2_DOC
          cSerie   := D2_SERIE
          cCliFor  := D2_CLIENTE
          cLoja    := D2_LOJA
          cLoteCtl := D2_LOTECTL
          nQuant   := D2_QUANT
       Endif
     Case !Empty(aNumSeq[oNumSeq:nAT][04])
       DBSelectArea("SD3")
       DBSetOrder(7) //--D3_FILIAL+D3_COD+D3_LOCAL+DTOS(D3_EMISSAO)+D3_NUMSEQ 
       IF DBSeek(xFilial("SD3")+cProduto+cLocal+DTOS(aNumSeq[oNumSeq:nAT][12])+cNumSeq)
          dData    := D3_EMISSAO
          cDoc     := D3_DOC
          cSerie   := Space(03)
          cCliFor  := Space(06)
          cLoja    := Space(02)
          cLoteCtl := D3_LOTECTL
          nQuant   := D3_QUANT
       Endif
     Case !Empty(aNumSeq[oNumSeq:nAT][05])
       DBSelectArea("SD5")
       DBSetOrder(3) //-- D5_FILIAL+D5_NUMSEQ+D5_PRODUTO+D5_LOCAL+D5_LOTECTL+D5_NUMLOTE
       IF DBSeek(xFilial("SD5")+cNumSeq)
          dData    := D5_DATA
          cDoc     := D5_DOC
          cSerie   := D5_SERIE
          cCliFor  := D5_CLIFOR
          cLoja    := D5_LOJA
          cLoteCtl := D5_LOTECTL
          nQuant   := D5_QUANT
       Endif
     Case !Empty(aNumSeq[oNumSeq:nAT][05])
       DBSelectArea("SDB")
       DBSetOrder(1) //--DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM
       IF DBSeek(xFilial("SDB")+cProduto+cLocal+cNumSeq)
          dData    := DB_DATA
          cDoc     := DB_DOC
          cSerie   := DB_SERIE
          cCliFor  := DB_CLIFOR
          cLoja    := DB_LOJA
          cLoteCtl := DB_LOTECTL
          nQuant   := DB_QUANT
       Endif
   EndCase
Endif

IF cOpcao $ "D5_A" //Alterar
   lVisLote := lVisDoc := lVisSerie := lVisCliFor := lVisLoja := lVisData := lVisNumSeq := lVisNumLote := .F.
ElseIF cOpcao $ "D5_E/D5+B8_E" //Excluir
   lVisLote := lVisDoc := lVisSerie := lVisCliFor := lVisLoja := lVisData := lVisNumSeq := lVisNumLote := lVisQuant := .F.
Endif

DBSelectArea("SB1")

DEFINE MSDIALOG oDlgSD5 TITLE "Ajuste no SD5"  OF oDlgSD5 PIXEL FROM 010,010 TO 340,295 
DEFINE FONT oBold   NAME "Arial" SIZE 0, -12 BOLD

@ 009,005 SAY "Data"                                    SIZE 040,10 PIXEL OF oDlgSD5 FONT oBold  
@ 005,043 MSGET oVar   VAR dData    Picture "99/99/99"  SIZE 040,10 PIXEL OF oDlgSD5 When lVisData
@ 024,005 SAY "Documento"                               SIZE 040,10 PIXEL OF oDlgSD5 FONT oBold 
@ 020,043 MSGET oVar   VAR cDoc     Picture "@!"        SIZE 030,10 PIXEL OF oDlgSD5 When lVisDoc
@ 039,005 SAY "Serie"                                   SIZE 040,10 PIXEL OF oDlgSD5 FONT oBold 
@ 035,043 MSGET oVar   VAR cSerie   Picture "@!"        SIZE 030,10 PIXEL OF oDlgSD5 When lVisSerie
@ 054,005 SAY "Clie.Forn"                               SIZE 040,10 PIXEL OF oDlgSD5 FONT oBold 
@ 050,043 MSGET oVar   VAR cCliFor  Picture "@!"        SIZE 030,10 PIXEL OF oDlgSD5 When lVisCliFor
@ 069,005 SAY "Loja"                                    SIZE 040,10 PIXEL OF oDlgSD5 FONT oBold 
@ 065,043 MSGET oVar   VAR cLoja    Picture "@!"        SIZE 030,10 PIXEL OF oDlgSD5 When lVisLoja
@ 084,005 SAY "Lote"                                    SIZE 040,10 PIXEL OF oDlgSD5 FONT oBold 
@ 080,043 MSGET oVar   VAR cLoteCtl Picture "@!"        SIZE 040,10 PIXEL OF oDlgSD5 When lVisLote
@ 099,005 SAY "Num.Seq."                                SIZE 040,10 PIXEL OF oDlgSD5 FONT oBold 
@ 095,043 MSGET oVar   VAR cNumSeq  Picture "@!"        SIZE 040,10 PIXEL OF oDlgSD5 When lVisNumSeq
@ 114,005 SAY "Num.Lote"                                SIZE 040,10 PIXEL OF oDlgSD5 FONT oBold 
@ 110,043 MSGET oVar   VAR cNumLote Picture "@!"        SIZE 040,10 PIXEL OF oDlgSD5 When lVisNumLote
@ 129,005 SAY "Quantidade"                              SIZE 040,10 PIXEL OF oDlgSD5 FONT oBold 
@ 125,043 MSGET oVar   VAR nQuant   Picture cPictD5     SIZE 050,10 PIXEL OF oDlgSD5 When lVisQuant Valid(nQuant >= 0)
                                                     //fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,cEndereco,cNumSeq,cTipoMov,cNumLote,cSerie,cCliFor,cLoja)
IF cOpcao $ "D5_I" //Incluir                                                                                                   
  @ 145,005 BUTTON "&Entrada" SIZE 25,14 PIXEL ACTION (fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,Nil      ,cNumSeq,"499"   ,cNumLote,cSerie,cCliFor,cLoja,dDtValid,cFolder),oDlgSD5:End())
  @ 145,040 BUTTON "&Saida"   SIZE 25,14 PIXEL ACTION (fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,Nil      ,cNumSeq,"999"   ,cNumLote,cSerie,cCliFor,cLoja,dDtValid,cFolder),oDlgSD5:End())
  @ 145,075 BUTTON "&Transf." SIZE 25,14 PIXEL ACTION (fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,Nil      ,cNumSeq,"499/999",cNumLote,cSerie,cCliFor,cLoja,dDtValid,cFolder),oDlgSD5:End())  
  @ 145,110 BUTTON "&Sair"    SIZE 25,14 PIXEL ACTION oDlgSD5:End()  
Else
   @ 145,050 BUTTON "&Confirmar" SIZE 30,14 PIXEL ACTION (fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,Nil   ,cNumSeq,Nil     ,cNumLote,cSerie,cCliFor,cLoja,dDtValid,cFolder),oDlgSD5:End())
   @ 145,090 BUTTON "&Sair"      SIZE 30,14 PIXEL ACTION oDlgSD5:End()
Endif


ACTIVATE MSDIALOG oDlgSD5  CENTERED

RestArea(aArea)

Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fAjustSBF(cOpcao)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local oDlgSBF
Local aArea     := GetArea()
Local cEndereco := IF(Len(aDetSBF)>0,aDetSBF[oDetSBF:nAT][01],SPACE(15))
Local cLoteCtl  := IF(Len(aDetSBF)>0,aDetSBF[oDetSBF:nAT][02],SPACE(10))
Local nQuant    := IF(Len(aDetSBF)>0,aDetSBF[oDetSBF:nAT][03],0)
Local cDoc      :=  "AJ"+Substr(DTOC(dDataBase),4,2)+Substr(DTOC(dDataBase),7,2)
Local lVisLote  := lVisDoc := lVisEndereco := lVisQuant := .T.

IF cOpcao = "BF_A" //Alterar
   lVisLote  := lVisDoc := lVisEndereco  := .F.
ElseIF cOpcao = "BF_E" //Excluir
   lVisLote := lVisDoc := lVisEndereco := lVisQuant := .F.
Endif

DBSelectArea("SB1")

DEFINE MSDIALOG oDlgSBF TITLE "Ajuste no SBF"  OF oDlgSBF PIXEL FROM 010,010 TO 200,265 
DEFINE FONT oBold   NAME "Arial" SIZE 0, -12 BOLD

@ 009,005 SAY "EndereÁo"                                SIZE 040,10 PIXEL OF oDlgSBF FONT oBold  
@ 005,043 MSGET oVar   VAR cEndereco Picture "@!"       SIZE 040,10 PIXEL OF oDlgSBF When lVisEndereco
@ 024,005 SAY "Lote"                                    SIZE 040,10 PIXEL OF oDlgSBF FONT oBold 
@ 020,043 MSGET oVar   VAR cLoteCtl Picture "@!"        SIZE 040,10 PIXEL OF oDlgSBF When lVisLote
@ 039,005 SAY "Documento"                               SIZE 040,10 PIXEL OF oDlgSBF FONT oBold 
@ 035,043 MSGET oVar   VAR cDoc     Picture "@!"        SIZE 030,10 PIXEL OF oDlgSBF When lVisDoc
@ 054,005 SAY "Quantidade"                              SIZE 040,10 PIXEL OF oDlgSBF FONT oBold 
@ 050,043 MSGET oVar   VAR nQuant   Picture cPict       SIZE 050,10 PIXEL OF oDlgSBF When lVisQuant 
                                                     //fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,cEndereco,cNumSeq,cTipoMov,cNumLote,cSerie,cCliFor,cLoja)
@ 075,050 BUTTON "&Confirmar" SIZE 30,14 PIXEL ACTION (fAjusta(cOpcao,cLoteCtl,cDoc,Nil  ,nQuant,cEndereco),oDlgSBF:End())
@ 075,090 BUTTON "&Sair"      SIZE 30,14 PIXEL ACTION oDlgSBF:End()

ACTIVATE MSDIALOG oDlgSBF  CENTERED

RestArea(aArea)

Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fAjustSDB(cOpcao,cFolder)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local oDlgSDB
Local aArea     := GetArea()
Local lVisLote := lVisDoc := lVisSerie := lVisCliFor := lVisLoja := lVisLocaliz :=lVisData := lVisQuant := lVisNumSeq := .T.
Local dData    := CTOD("  /  /  ")
Local cDoc     := Space(06)
Local cSerie   := Space(03)
Local cCliFor  := Space(06)
Local cLoja    := Space(02)
Local cLoteCtl := Space(10)
Local cNumSeq  := Space(06)
Local cLocaliz := Space(15)
Local nQuant   := 0
Local cNumLote 

IF cFolder = "03" .AND. Len(aDetSDB) > 0 .AND. aDetSDB[oDetSDB:nAT][01] = "SBK"
   MsgStop("A Origem SBK n„o permite essa opÁ„o !")
   Return
Endif

IF cFolder = "03"
   dData    := IF(Len(aDetSDB)>0,aDetSDB[oDetSDB:nAT][02],dDataBase)
   cDoc     := IF(Len(aDetSDB)>0,aDetSDB[oDetSDB:nAT][10],"AJ"+Substr(DTOC(dDataBase),4,2)+Substr(DTOC(dDataBase),7,2))
   cSerie   := IF(Len(aDetSDB)>0,aDetSDB[oDetSDB:nAT][11],SPACE(03))
   cCliFor  := IF(Len(aDetSDB)>0,aDetSDB[oDetSDB:nAT][12],SPACE(06))
   cLoja    := IF(Len(aDetSDB)>0,aDetSDB[oDetSDB:nAT][13],SPACE(02))
   cLoteCtl := IF(Len(aDetSDB)>0,aDetSDB[oDetSDB:nAT][05],SPACE(10))
   cNumSeq  := IF(Len(aDetSDB)>0,aDetSDB[oDetSDB:nAT][08],SPACE(06))
   cLocaliz := IF(Len(aDetSDB)>0,aDetSDB[oDetSDB:nAT][04],SPACE(15))
   nQuant   := IF(Len(aDetSDB)>0,aDetSDB[oDetSDB:nAT][06],0)
   dDtValid := IF(Len(aDetSDB)>0,aDetSDB[oDetSDB:nAT][04],CTOD("  /  /  "))
ElseIF cFolder = "13"                  
   cNumSeq  := aNumSeq[oNumSeq:nAT][01]
   DBSelectArea("SDB")
   DBSetOrder(1) //--DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM
   IF DBSeek(xFilial("SDB")+cProduto+cLocal+cNumSeq)
      cLocaliz := DB_LOCALIZ
   Endif
   Do Case
     Case !Empty(aNumSeq[oNumSeq:nAT][02])
       DBSelectArea("SD1")
       DBSetOrder(4) //--D1_FILIAL+D1_NUMSEQ
       IF DBSeek(xFilial("SD1")+cNumSeq)
          dData    := D1_DTDIGIT
          cDoc     := D1_DOC
          cSerie   := D1_SERIE
          cCliFor  := D1_FORNECE
          cLoja    := D1_LOJA
          cLoteCtl := D1_LOTECTL
          nQuant   := D1_QUANT
       Endif
     Case !Empty(aNumSeq[oNumSeq:nAT][03])
       DBSelectArea("SD2")
       DBSetOrder(4) //--D2_FILIAL+D2_NUMSEQ
       IF DBSeek(xFilial("SD2")+cNumSeq)
          dData    := D2_EMISSAO
          cDoc     := D2_DOC
          cSerie   := D2_SERIE
          cCliFor  := D2_CLIENTE
          cLoja    := D2_LOJA
          cLoteCtl := D2_LOTECTL
          nQuant   := D2_QUANT
       Endif
     Case !Empty(aNumSeq[oNumSeq:nAT][04])
       DBSelectArea("SD3")
       DBSetOrder(4) //--D3_FILIAL+D3_NUMSEQ+D3_CHAVE+D3_COD
       IF DBSeek(xFilial("SD3")+cNumSeq)
          dData    := D3_EMISSAO
          cDoc     := D3_DOC
          cSerie   := Space(03)
          cCliFor  := Space(06)
          cLoja    := Space(02)
          cLoteCtl := D3_LOTECTL
          nQuant   := D3_QUANT
       Endif
     Case !Empty(aNumSeq[oNumSeq:nAT][05])
       DBSelectArea("SD5")
       DBSetOrder(3) //-- D5_FILIAL+D5_NUMSEQ+D5_PRODUTO+D5_LOCAL+D5_LOTECTL+D5_NUMLOTE
       IF DBSeek(xFilial("SD5")+cNumSeq)
          dData    := D5_DATA
          cDoc     := D5_DOC
          cSerie   := D5_SERIE
          cCliFor  := D5_CLIFOR
          cLoja    := D5_LOJA
          cLoteCtl := D5_LOTECTL
          nQuant   := D5_QUANT
       Endif
     Case !Empty(aNumSeq[oNumSeq:nAT][05])
       DBSelectArea("SDB")
       DBSetOrder(1) //--DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM
       IF DBSeek(xFilial("SDB")+cProduto+cLocal+cNumSeq)
          dData    := DB_DATA
          cDoc     := DB_DOC
          cSerie   := DB_SERIE
          cCliFor  := DB_CLIFOR
          cLoja    := DB_LOJA
          cLoteCtl := DB_LOTECTL
          cLocaliz := DB_LOCALIZ
          nQuant   := DB_QUANT
       Endif
   EndCase
Endif

IF cOpcao = "DB_A"  //Alterar
   lVisLote := lVisDoc := lVisSerie := lVisCliFor := lVisLoja := lVisLocaliz := lVisData :=  lVisNumSeq := .F.
ElseIF cOpcao $ "DB_E/DB+BF_E" //Excluir
   lVisLote := lVisDoc := lVisSerie := lVisCliFor := lVisLoja := lVisLocaliz := lVisData :=  lVisNumSeq := lVisQuant := .F.
Endif

DBSelectArea("SB1")

DEFINE MSDIALOG oDlgSDB TITLE "Ajuste no SDB"  OF oDlgSDB PIXEL FROM 010,010 TO 340,295 
DEFINE FONT oBold   NAME "Arial" SIZE 0, -12 BOLD

@ 009,005 SAY "Data"                                    SIZE 040,10 PIXEL OF oDlgSDB FONT oBold  
@ 005,043 MSGET oVar   VAR dData    Picture "99/99/99"  SIZE 040,10 PIXEL OF oDlgSDB When lVisData
@ 024,005 SAY "Documento"                               SIZE 040,10 PIXEL OF oDlgSDB FONT oBold 
@ 020,043 MSGET oVar   VAR cDoc     Picture "@!"        SIZE 030,10 PIXEL OF oDlgSDB When lVisDoc
@ 039,005 SAY "Serie"                                   SIZE 040,10 PIXEL OF oDlgSDB FONT oBold 
@ 035,043 MSGET oVar   VAR cSerie   Picture "@!"        SIZE 030,10 PIXEL OF oDlgSDB When lVisSerie
@ 054,005 SAY "Clie.Forn"                               SIZE 040,10 PIXEL OF oDlgSDB FONT oBold 
@ 050,043 MSGET oVar   VAR cCliFor  Picture "@!"        SIZE 030,10 PIXEL OF oDlgSDB When lVisCliFor
@ 069,005 SAY "Loja"                                    SIZE 040,10 PIXEL OF oDlgSDB FONT oBold 
@ 065,043 MSGET oVar   VAR cLoja    Picture "@!"        SIZE 030,10 PIXEL OF oDlgSDB When lVisLoja
@ 084,005 SAY "Lote"                                    SIZE 040,10 PIXEL OF oDlgSDB FONT oBold 
@ 080,043 MSGET oVar   VAR cLoteCtl Picture "@!"        SIZE 040,10 PIXEL OF oDlgSDB When lVisLote
@ 099,005 SAY "Num.Seq."                                SIZE 040,10 PIXEL OF oDlgSDB FONT oBold 
@ 095,043 MSGET oVar   VAR cNumSeq  Picture "@!"        SIZE 040,10 PIXEL OF oDlgSDB When lVisNumSeq
@ 114,005 SAY "LocalizaÁ„o"                             SIZE 040,10 PIXEL OF oDlgSDB FONT oBold 
@ 110,043 MSGET oVar   VAR cLocaliz Picture "@!"        SIZE 040,10 PIXEL OF oDlgSDB When lVisLocaliz
@ 129,005 SAY "Quantidade"                              SIZE 040,10 PIXEL OF oDlgSDB FONT oBold 
@ 125,043 MSGET oVar   VAR nQuant   Picture cPictDB     SIZE 050,10 PIXEL OF oDlgSDB When lVisQuant Valid(nQuant >= 0)
                                                      //fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,cEndereco,cNumSeq,cTipoMov,cNumLote,cSerie,cCliFor,cLoja)
IF cOpcao $ "DB_I" //Incluir                                                                                                   
   @ 145,005 BUTTON "&Entrada" SIZE 25,14 PIXEL ACTION (fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,cLocaliz,cNumSeq,"499"   ,cNumLote,cSerie,cCliFor,cLoja,,cFolder),oDlgSDB:End())
   @ 145,040 BUTTON "&Saida"   SIZE 25,14 PIXEL ACTION (fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,cLocaliz,cNumSeq,"999"   ,cNumLote,cSerie,cCliFor,cLoja,,cFolder),oDlgSDB:End())
   @ 145,075 BUTTON "&Transf." SIZE 25,14 PIXEL ACTION (fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,cLocaliz,cNumSeq,"499/999",cNumLote,cSerie,cCliFor,cLoja,,cFolder),oDlgSDB:End())  
   @ 145,110 BUTTON "&Sair"    SIZE 25,14 PIXEL ACTION oDlgSDB:End()  
Else
   @ 145,050 BUTTON "&Confirmar" SIZE 30,14 PIXEL ACTION (fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,cLocaliz,cNumSeq,Nil   ,cNumLote,cSerie,cCliFor,cLoja,,cFolder),oDlgSDB:End())
   @ 145,090 BUTTON "&Sair"      SIZE 30,14 PIXEL ACTION oDlgSDB:End()
Endif

ACTIVATE MSDIALOG oDlgSDB  CENTERED

RestArea(aArea)

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fAjustDAB8(cOpcao)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local oDlgSDA
Local aArea    := GetArea()
Local dData    := IF(Len(aDetDASB8)>0,aDetDASB8[oDetDASB8:nAT][01],dDataBase)
Local cLoteCtl := IF(Len(aDetDASB8)>0,aDetDASB8[oDetDASB8:nAT][02],SPACE(10))
Local nQuant   := IF(Len(aDetDASB8)>0,aDetDASB8[oDetDASB8:nAT][04],0)
Local cDoc     := IF(Len(aDetDASB8)>0,aDetDASB8[oDetDASB8:nAT][07],SPACE(06))

DBSelectArea("SB1")

DEFINE MSDIALOG oDlgSDA TITLE "Ajuste no SB8"  OF oDlgSDA PIXEL FROM 010,010 TO 200,265 
DEFINE FONT oBold   NAME "Arial" SIZE 0, -12 BOLD

@ 009,005 SAY "Lote"                                    SIZE 040,10 PIXEL OF oDlgSDA FONT oBold 
@ 005,043 MSGET oVar   VAR cLoteCtl Picture "@!"        SIZE 040,10 PIXEL OF oDlgSDA When .F.
@ 024,005 SAY "Documento"                               SIZE 040,10 PIXEL OF oDlgSDA FONT oBold 
@ 020,043 MSGET oVar   VAR cDoc     Picture "@!"        SIZE 030,10 PIXEL OF oDlgSDA When .F.
@ 039,005 SAY "Data"                                    SIZE 040,10 PIXEL OF oDlgSDA FONT oBold  
@ 035,043 MSGET oVar   VAR dData    Picture "99/99/99"  SIZE 040,10 PIXEL OF oDlgSDA When .F.
@ 054,005 SAY "Quantidade"                              SIZE 040,10 PIXEL OF oDlgSDA FONT oBold 
@ 050,043 MSGET oVar   VAR nQuant   Picture cPict       SIZE 050,10 PIXEL OF oDlgSDA When .T.
                                                     //fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,cEndereco,cNumSeq,cTipoMov,cNumLote,cSerie,cCliFor,cLoja)
@ 075,050 BUTTON "&Confirmar" SIZE 30,14 PIXEL ACTION (fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant),oDlgSDA:End())
@ 075,090 BUTTON "&Sair"      SIZE 30,14 PIXEL ACTION oDlgSDA:End()

ACTIVATE MSDIALOG oDlgSDA  CENTERED

RestArea(aArea)

Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fAjustSDA(cOpcao)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local oDlgSDA
Local aArea    := GetArea()
Local dData    := IF(Len(aDetDASDA)>0,aDetDASDA[oDetDASDA:nAT][01],dDataBase)
Local cLoteCtl := IF(Len(aDetDASDA)>0,aDetDASDA[oDetDASDA:nAT][02],SPACE(10))
Local nQuant   := IF(Len(aDetDASDA)>0,aDetDASDA[oDetDASDA:nAT][03],0)
Local cDoc     := IF(Len(aDetDASDA)>0,aDetDASDA[oDetDASDA:nAT][08],SPACE(06))

DBSelectArea("SB1")

DEFINE MSDIALOG oDlgSDA TITLE "Ajuste no SDA"  OF oDlgSDA PIXEL FROM 010,010 TO 200,265 
DEFINE FONT oBold   NAME "Arial" SIZE 0, -12 BOLD

@ 009,005 SAY "Lote"                                    SIZE 040,10 PIXEL OF oDlgSDA FONT oBold 
@ 005,043 MSGET oVar   VAR cLoteCtl Picture "@!"        SIZE 040,10 PIXEL OF oDlgSDA When .F.
@ 024,005 SAY "Documento"                               SIZE 040,10 PIXEL OF oDlgSDA FONT oBold 
@ 020,043 MSGET oVar   VAR cDoc     Picture "@!"        SIZE 030,10 PIXEL OF oDlgSDA When .F.
@ 039,005 SAY "Data"                                    SIZE 040,10 PIXEL OF oDlgSDA FONT oBold  
@ 035,043 MSGET oVar   VAR dData    Picture "99/99/99"  SIZE 040,10 PIXEL OF oDlgSDA When .F.
@ 054,005 SAY "Quantidade"                              SIZE 040,10 PIXEL OF oDlgSDA FONT oBold 
@ 050,043 MSGET oVar   VAR nQuant   Picture cPict       SIZE 050,10 PIXEL OF oDlgSDA When .T.
                                                     //fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,cEndereco,cNumSeq,cTipoMov,cNumLote,cSerie,cCliFor,cLoja)
@ 075,050 BUTTON "&Confirmar" SIZE 30,14 PIXEL ACTION (fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant),oDlgSDA:End())
@ 075,090 BUTTON "&Sair"      SIZE 30,14 PIXEL ACTION oDlgSDA:End()

ACTIVATE MSDIALOG oDlgSDA  CENTERED

RestArea(aArea)

Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fAjustSBJ(cOpcao)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local oDlgSBJ
Local aArea     := GetArea()
Local cLoteCtl  := IF(Len(aAnaSBJ)>0,aAnaSBJ[oAnaSBJ:nAT][01],Space(10))
Local cNumLote  := IF(Len(aAnaSBJ)>0,aAnaSBJ[oAnaSBJ:nAT][02],Space(06))
Local nQuant    := IF(Len(aAnaSBJ)>0,aAnaSBJ[oAnaSBJ:nAT][04],0        )

DBSelectArea("SB1")

DEFINE MSDIALOG oDlgSBJ TITLE "Ajuste no SBJ"  OF oDlgSBJ PIXEL FROM 010,010 TO 200,265 
DEFINE FONT oBold   NAME "Arial" SIZE 0, -12 BOLD

@ 009,005 SAY "Lote"                                    SIZE 040,10 PIXEL OF oDlgSBJ FONT oBold  
@ 005,043 MSGET oVar   VAR cLoteCtl Picture "@!"        SIZE 040,10 PIXEL OF oDlgSBJ 
@ 024,005 SAY "Num.Lote"                                SIZE 040,10 PIXEL OF oDlgSBJ FONT oBold 
@ 020,043 MSGET oVar   VAR cNumLote Picture "@!"        SIZE 040,10 PIXEL OF oDlgSBJ 
@ 039,005 SAY "Quantidade"                              SIZE 040,10 PIXEL OF oDlgSBJ FONT oBold 
@ 035,043 MSGET oVar   VAR nQuant   Picture PESQPICT("SBJ","BJ_QINI")       SIZE 050,10 PIXEL OF oDlgSBJ 
                                                     //fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,cEndereco,cNumSeq,cTipoMov,cNumLote,cSerie,cCliFor,cLoja)
@ 075,050 BUTTON "&Confirmar" SIZE 30,14 PIXEL ACTION (fAjusta(cOpcao,cLoteCtl,Nil ,Nil  ,nQuant,Nil      ,Nil    ,Nil     ,cNumLote),oDlgSBJ:End())
@ 075,090 BUTTON "&Sair"      SIZE 30,14 PIXEL ACTION oDlgSBJ:End()

ACTIVATE MSDIALOG oDlgSBJ  CENTERED

RestArea(aArea)

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fAjustSBK(cOpcao)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local oDlgSBK
Local aArea     := GetArea()
Local cEndereco := IF(Len(aAnaSBK)>0,aAnaSBK[oAnaSBK:nAT][01],Space(15))
Local cLoteCtl  := IF(Len(aAnaSBK)>0,aAnaSBK[oAnaSBK:nAT][02],Space(10))
Local nQuant    := IF(Len(aAnaSBK)>0,aAnaSBK[oAnaSBK:nAT][03],0        )

DBSelectArea("SB1")

DEFINE MSDIALOG oDlgSBK TITLE "Ajuste no SBK"  OF oDlgSBK PIXEL FROM 010,010 TO 200,265 
DEFINE FONT oBold   NAME "Arial" SIZE 0, -12 BOLD

@ 009,005 SAY "EndereÁo"                                SIZE 040,10 PIXEL OF oDlgSBK FONT oBold  
@ 005,043 MSGET oVar   VAR cEndereco Picture "@!"       SIZE 040,10 PIXEL OF oDlgSBK 
@ 024,005 SAY "Lote"                                    SIZE 040,10 PIXEL OF oDlgSBK FONT oBold 
@ 020,043 MSGET oVar   VAR cLoteCtl Picture "@!"        SIZE 040,10 PIXEL OF oDlgSBK 
@ 039,005 SAY "Quantidade"                              SIZE 040,10 PIXEL OF oDlgSBK FONT oBold 
@ 035,043 MSGET oVar   VAR nQuant   Picture cPict       SIZE 050,10 PIXEL OF oDlgSBK 
                                                     //fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,cEndereco,cNumSeq,cTipoMov,cNumLote,cSerie,cCliFor,cLoja)
@ 075,050 BUTTON "&Confirmar" SIZE 30,14 PIXEL ACTION (fAjusta(cOpcao,cLoteCtl,Nil ,Nil  ,nQuant,cEndereco),oDlgSBK:End())
@ 075,090 BUTTON "&Sair"      SIZE 30,14 PIXEL ACTION oDlgSBK:End()

ACTIVATE MSDIALOG oDlgSBK  CENTERED

RestArea(aArea)

Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fAjusta(cOpcao,cLoteCtl,cDoc,dData,nQuant,cEndereco,cNumSeq,cTipoMov,cNumLote,cSerie,cCliFor,cLoja,dDtValid,cFolder)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local aArea  := GetArea()
Do Case
  Case cOpcao == "SALDO_SB2"  // Saldo do SB2
     DBSelectArea("SB2")
     DBSetOrder(1) //B2_FILIAL+B2_COD+B2_LOCAL
     IF DBSeek(xFilial("SB2")+cProduto+cLocal)
        RecLock("SB2",.F.)
        SB2->B2_QATU    := nQuant
        SB2->B2_QTSEGUM := ConvUM(cProduto,nQuant,0,2) // 2UM
        MsUnlock()
        nSB2 := SB2->B2_QATU
     Endif 
  Case cOpcao == "EMPENHO_SB2"  // Saldo do SB2
     DBSelectArea("SB2")
     DBSetOrder(1) //B2_FILIAL+B2_COD+B2_LOCAL
     IF DBSeek(xFilial("SB2")+cProduto+cLocal)
        RecLock("SB2",.F.)
	        SB2->B2_QEMP    := nQuant      
        MsUnlock()
        nEmpSB2 := SB2->B2_QEMP
     Endif   
  Case cOpcao == "CLASS_SB2"  // Saldo A Classificar do SB2
     DBSelectArea("SB2")
     DBSetOrder(1) //B2_FILIAL+B2_COD+B2_LOCAL
     IF DBSeek(xFilial("SB2")+cProduto+cLocal)
        RecLock("SB2",.F.)
        SB2->B2_QACLASS := nQuant
        MsUnlock()
        nDASB2 := SB2->B2_QACLASS
     Endif
  Case cOpcao == "SALDO_SB9"  // Saldo do SB9
     DBSelectArea("SB9")
     DBSetOrder(1) //B9_FILIAL+B9_COD+B9_LOCAL+DTOS(B9_DATA)
     IF DBSeek(xFilial("SB9")+cProduto+cLocal+DTOS(dUltFech))
        RecLock("SB9",.F.)
        SB9->B9_QINI    := nQuant
        SB9->B9_QISEGUM := ConvUM(cProduto,nQuant,0,2) // 2UM
        MsUnlock()          
        nSB9 := SB9->B9_QINI
     Endif
  Case cOpcao == "DAxB8" // Altera Saldo a Classificar
     DBSelectArea("SB8")
     DBGoto(aDetDASB8[oDetDASB8:nAT][12])
     RecLock("SB8",.F.)
     SB8->B8_QACLASS := nQuant
     SB8->B8_QACLAS2 := ConvUM(cProduto,nQuant,0,2) // 2UM
     MsUnlock()
  Case cOpcao == "SDA"   // Altera Saldo a Classificar no SDA
     DBSelectArea("SDA")
     DBGoto(aDetDASDA[oDetDASDA:nAT][13])
     RecLock("SDA",.F.)
     SDA->DA_SALDO   := nQuant
     SDA->DA_QTSEGUM := ConvUM(cProduto,nQuant,0,2) // 2UM
     MsUnlock()
  Case cOpcao == "B8_I"  // Inclusao
     cLoteFor  := Nil
     cSerie    := Nil                                                         
     cCliFor   := Nil
     cLoja     := Nil
     cTm       := Nil 
     cOrigLan  := "MI"
     cChave    := Nil
     cOp       := Nil
     nQuant2UM := Nil
     cNumSeq   := Nil
     dDtValid  := Nil
     fMovto(.T.,.F.,cProduto,cLocal,cLoteCtl,cNumLote,cLoteFor,cCliFor,cLoja,cTm,cOrigLan,cChave,cNumSeq,cDoc,cSerie,cOp,nQuant,nQuant2UM,dData,dDtValid)
  Case cOpcao == "B8_A" // Alteracao
     DBSelectArea("SB8")
     DBSetOrder(3) // B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
     IF DBSeek(xFilial("SB8")+cProduto+cLocal+cLoteCtl+cNumLote+DTOS(aDetSB8[oDetSB8:nAT][4]))
        RecLock("SB8",.F.)
        SB8->B8_SALDO  := nQuant
        SB8->B8_SALDO2 := ConvUM(cProduto,nQuant,0,2) // 2UM
        MsUnlock()
     Endif
  Case cOpcao == "B8_E" // Exclusao
     dDtValid  := aDetSB8[oDetSB8:nAT][4]
     DBSelectArea("SB8")
     DBSetOrder(3) // B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
     IF DBSeek(xFilial("SB8")+cProduto+cLocal+cLoteCtl+cNumLote+DTOS(dDtValid))
        RecLock("SB8",.F.)
        DBDelete()
        MsUnlock()
     Endif
  Case cOpcao $ "D5_I" // Inclusao
     cLoteFor  := Nil                                                         
     cOrigLan  := "MI"
     cChave    := Nil
     cOp       := Nil
     nQuant2UM := Nil
     IF "499" $ cTipoMov
       cTm := "499"
       fMovto(.F.,.T.,cProduto,cLocal,cLoteCtl,cNumLote,cLoteFor,cCliFor,cLoja,cTm,cOrigLan,cChave,cNumSeq,cDoc,cSerie,cOp,nQuant,nQuant2UM,dData,dDtValid)
     Endif  
     IF "999" $ cTipoMov
       cTm := "999"
       fMovto(.F.,.T.,cProduto,cLocal,cLoteCtl,cNumLote,cLoteFor,cCliFor,cLoja,cTm,cOrigLan,cChave,cNumSeq,cDoc,cSerie,cOp,nQuant,nQuant2UM,dData,dDtValid)
     Endif  
  Case cOpcao $ "D5_A" // Alterar 
    DBSelectArea("SD5")
    DBGoto(aDetSD5[oDetSD5:nAT][14])
    RecLock("SD5",.F.)
    SD5->D5_QUANT   := nQuant
    SD5->D5_QTSEGUM := ConvUM(cProduto,nQuant,0,2) // 2UM
    MsUnlock()
  Case cOpcao $ "D5_E" // Excluir
    DBSelectArea("SD5")
    DBGoto(aDetSD5[oDetSD5:nAT][14])
    RecLock("SD5",.F.)
    DBDelete()
    MsUnlock() 
  Case cOpcao $ "D5+B8_I" // Inclusao
     cLoteFor  := Nil                                                         
     cOrigLan  := "MI"
     cChave    := Nil
     cOp       := Nil
     nQuant2UM := Nil
     cTm       := "499"
     fMovto(.T.,.T.,cProduto,cLocal,cLoteCtl,cNumLote,cLoteFor,cCliFor,cLoja,cTm,cOrigLan,cChave,cNumSeq,cDoc,cSerie,cOp,nQuant,nQuant2UM,dData,dDtValid)
  Case cOpcao $ "D5+B8_S" // Subtrair
     cLoteFor  := Nil                                                         
     cOrigLan  := "MI"
     cChave    := Nil
     cOp       := Nil
     cSerie    := Nil                                                         
     cTm       := "999"
     nQuant2UM := ConvUM(cProduto,nQuant,0,2) // 2UM
     nPotencia := 0
     DBSelectArea("SB8")
     DBSetOrder(3) // B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
     IF DBSeek(xFilial("SB8")+cProduto+cLocal+cLoteCtl+cNumLote+DTOS(dDtValid))
        RecLock("SB8",.F.)
        SB8->B8_SALDO  -= nQuant
        SB8->B8_SALDO2 -= nQuant2UM
        MsUnlock()
     Endif
     fMovto(.F.,.T.,cProduto,cLocal,cLoteCtl,cNumLote,cLoteFor,cCliFor,cLoja,cTm,cOrigLan,cChave,cNumSeq,cDoc,cSerie,cOp,nQuant,nQuant2UM,dData,dDtValid)
  Case cOpcao == "D5+B8_E" // Estornar
     cTipoLote := If(Rastro(cProduto),If(Rastro(cProduto,"S"),"S","L"),"N")
     cOrigLan  := aDetSD5[oDetSD5:nAT][02]                                   
     EstornaSD5(cTipoLote,cProduto,cLocal,cLoteCtl,cNumLote,cNumSeq,.F.,NIL,cOrigLan,NIL,nQuant,Nil,cCliFor,cLoja,cDoc,cSerie)
  Case cOpcao == "BF_I" // Inclusao
     cNumLote  := Nil                 
     cNumSeq   := IF(Empty(cNumSeq),ProxNum(),cNumSeq)
     nQuant2UM := ConvUM(cProduto,nQuant,0,2) // 2UM
     cTm       := "499"
     fGravaSBF(cTM,cProduto,cLocal,cLoteCtl,cNumLote,cNumSeq,cEndereco,nQuant,nQuant2UM)
  Case cOpcao == "BF_A" // Alteracao
        DBSelectArea("SBF")
        DBGoto(aDetSBF[oDetSBF:nAT][11])       
        RecLock("SBF",.F.)
        SBF->BF_QUANT   := nQuant
        SBF->BF_QTSEGUM := ConvUM(cProduto,nQuant,0,2) // 2UM
        MsUnlock()
        If SBF->BF_QUANT <= 0
           DeletSBF()
        Endif
  Case cOpcao == "BF_E" // Exclusao
        DBSelectArea("SBF")
        DBGoto(aDetSBF[oDetSBF:nAT][11])
        RecLock("SBF",.F.)
        SBF->BF_QUANT   := 0
        SBF->BF_QTSEGUM := 0
        MsUnlock()
        If SBF->BF_QUANT <= 0
           DeletSBF()
        Endif
  Case cOpcao $ "DB_I" // Inclusao
     cNumLote  := Nil
     cNumSeq   := IF(Empty(cNumSeq),ProxNum(),cNumSeq)
     cNumSerie := Nil
     cTipoNf   := Nil
     cOrigem   := "SD3"
     cItem     := "0001"
     nQuant2UM := ConvUM(cProduto,nQuant,0,2) // 2UM
     IF "499" $ cTipoMov
        cTm   := "499"
        cTipo := "D"                                                                                                                          
        CriaSDB(cProduto,cLocal,nQuant,cEndereco,cNumSerie,cDoc,cSerie,cCliFor,cLoja,cTipoNf,cOrigem,dData,cLoteCtl,cNumLote,cNumSeq,cTm,cTipo,cItem,.F.,0,nQuant2UM,0)
     Endif   
     IF "999" $ cTipoMov
       cTm := "999"
       cTipo := "M"                                                                                                                          
       CriaSDB(cProduto,cLocal,nQuant,cEndereco,cNumSerie,cDoc,cSerie,cCliFor,cLoja,cTipoNf,cOrigem,dData,cLoteCtl,cNumLote,cNumSeq,cTm,cTipo,cItem,.F.,0,nQuant2UM,0)
     Endif               
  Case cOpcao $ "DB_A" // Alterar 
    DBSelectArea("SDB")
    DBGoto(aDetSDB[oDetSDB:nAT][14])
    RecLock("SDB",.F.)
    SDB->DB_QUANT   := nQuant
    SDB->DB_QTSEGUM := ConvUM(cProduto,nQuant,0,2) // 2UM
    MsUnlock()
  Case cOpcao $ "DB_E" // Excluir
    DBSelectArea("SDB")
    DBGoto(aDetSDB[oDetSDB:nAT][14])
    RecLock("SDB",.F.)
    DBDelete()
    MsUnlock() 
  Case cOpcao $ "DB+BF_I" // Inclusao
     cNumLote  := Nil
     cNumSerie := Nil
     cNumSeq   := IF(Empty(cNumSeq),ProxNum(),cNumSeq)
     cTipoNf   := Nil
     cOrigem   := "SD3"
     cTm       := "499"
     cTipo     := "D"                                                                                                                  
     cItem     := "0001"
     nQuant2UM := ConvUM(cProduto,nQuant,0,2) // 2UM
     CriaSDB(cProduto,cLocal,nQuant,cEndereco,cNumSerie,cDoc,cSerie,cCliFor,cLoja,cTipoNf,cOrigem,dData,cLoteCtl,cNumLote,cNumSeq,cTm,cTipo,cItem,.F.,0,nQuant2UM,0)
     GravaSBF('SDB')
  Case cOpcao $ "DB+BF_S" // Subtrair
     cNumLote  := Nil
     cNumSerie := Nil
     cNumSeq   := IF(Empty(cNumSeq),ProxNum(),cNumSeq)
     cTipoNf   := Nil
     cOrigem   := "SD3"
     cTm       := "999"
     cTipo     := "M"                                                                                                                  
     cItem     := "0001"
     nQuant2UM := ConvUM(cProduto,nQuant,0,2) // 2UM
     CriaSDB(cProduto,cLocal,nQuant,cEndereco,cNumSerie,cDoc,cSerie,cCliFor,cLoja,cTipoNf,cOrigem,dData,cLoteCtl,cNumLote,cNumSeq,cTm,cTipo,cItem,.F.,0,nQuant2UM,0)
     GravaSBF('SDB')
  Case cOpcao $ "DB+BF_E" // Estorno
     DBSelectArea("SDB")
     DBGoto(aDetSDB[oDetSDB:nAT][14])
     nQuant2UM := SDB->DB_QTSEGUM
     cNumLote  := IF(!lNumLote,SDB->DB_NUMLOTE,Space(06))
     cDoc      := SDB->DB_DOC
     cSerie    := SDB->DB_SERIE
     cCliFor   := SDB->DB_CLIFOR
     cLoja     := SDB->DB_LOJA
     cNumSerie := SDB->DB_NUMSERI
     cNumSeq   := SDB->DB_NUMSEQ
     cTipoNf   := SDB->DB_TIPONF
     cOrigem   := SDB->DB_ORIGEM
     cTm       := "999"
     cTipo     := SDB->DB_TIPO
     cItem     := SDB->DB_ITEM
     CriaSDB(cProduto,cLocal,nQuant,cEndereco,cNumSerie,cDoc,cSerie,cCliFor,cLoja,cTipoNf,cOrigem,dData,cLoteCtl,cNumLote,cNumSeq,cTm,cTipo,cItem,.T.,0,nQuant2UM,0)
     GravaSBF('SDB')
  Case cOpcao $ "BJ_I" // Incluir
     dDataValid := CTOD("  /  /  ")
     DBSelectArea("SB8")
     DBSetOrder(3) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
     IF DBSeek(xFilial("SB8")+cProduto+cLocal+cLoteCtl)
        dDataValid := SB8->B8_DTVALID
     Endif     
     DBSelectArea("SBJ")     
     DBSetOrder(1) // BJ_FILIAL+BJ_COD+BJ_LOCAL+BJ_LOTECTL+BJ_NUMLOTE+DTOS(BJ_DATA)
     IF DBSeek(xFilial("SBJ")+cProduto+cLocal+cLoteCtl+cNumLote+DTOS(dUltFech))
        MsgStop("Movimento j· existe !!!")
        Return
     Endif     
     RecLock("SBJ",.T.)
     SBJ->BJ_FILIAL  := xFilial("SBJ")
     SBJ->BJ_COD     := cProduto
     SBJ->BJ_LOCAL   := cLocal        
     SBJ->BJ_DATA    := dUltFech
     SBJ->BJ_DTVALID := dDataValid
     SBJ->BJ_LOTECTL := cLoteCtl
     SBJ->BJ_NUMLOTE := IF(!lNumLote,cNumLote,Space(06))
     SBJ->BJ_QINI    := nQuant
     SBJ->BJ_QISEGUM := ConvUM(cProduto,nQuant,0,2) // 2UM
     MsUnlock()
  Case cOpcao $ "BJ_A" // Alterar
     DBSelectArea("SBJ")
     DBGoto(aAnaSBJ[oAnaSBJ:nAT][05])
     RecLock("SBJ",.F.)
     SBJ->BJ_LOTECTL := cLoteCtl
     SBJ->BJ_NUMLOTE := IF(!lNumLote,cNumLote,Space(06))
     SBJ->BJ_QINI    := nQuant
     SBJ->BJ_QISEGUM := ConvUM(cProduto,nQuant,0,2) // 2UM
     MsUnlock()
  Case cOpcao $ "BJ_E" // Excluir
     DBSelectArea("SBJ")
     DBGoto(aAnaSBJ[oAnaSBJ:nAT][05])
     RecLock("SBJ",.F.)
     DBDelete()
     MsUnlock() 
  Case cOpcao $ "BK_I" // Incluir
     RecLock("SBK",.T.)
     SBK->BK_FILIAL  := xFilial("SBK")
     SBK->BK_COD     := cProduto
     SBK->BK_LOCAL   := cLocal        
     SBK->BK_DATA    := dUltFech
     SBK->BK_LOCALIZ := cEndereco
     SBK->BK_LOTECTL := cLoteCtl
//   SBK->BK_NUMLOTE := cNumLote
     SBK->BK_QINI    := nQuant
     SBK->BK_QISEGUM := ConvUM(cProduto,nQuant,0,2) // 2UM
     MsUnlock()
  Case cOpcao $ "BK_A" // Alterar
     DBSelectArea("SBK")
     DBGoto(aAnaSBK[oAnaSBK:nAT][04])
     RecLock("SBK",.F.)
     SBK->BK_LOTECTL := cLoteCtl
     SBK->BK_LOCALIZ := cEndereco
     SBK->BK_QINI    := nQuant
     SBK->BK_QISEGUM := ConvUM(cProduto,nQuant,0,2) // 2UM
     MsUnlock()           
  Case cOpcao $ "BK_E" // Excluir
     DBSelectArea("SBK")
     DBGoto(aAnaSBK[oAnaSBK:nAT][04])
     RecLock("SBK",.F.)
     DBDelete()
     MsUnlock() 
  Case cOpcao $ "D5DB_A" // Alterar Movimento - NumSeq
     For I:= 1 To Len(ACols)
        Do Case
           Case aCols[I,1] = "SD1"
             DBSelectArea("SD1")
             DBGoto(aCols[I,14])
             IF aCols[I,15] // Deletar
                RecLock("SD1",.F.)
                DBDelete()
                MsUnlock()
             Else  
                IF aCols[I,02] <> SD1->D1_DTDIGIT .OR.;
                   aCols[I,03] <> SD1->D1_DOC     .OR.;
                   aCols[I,04] <> SD1->D1_SERIE   .OR.;
                   aCols[I,05] <> SD1->D1_FORNECE .OR.;
                   aCols[I,06] <> SD1->D1_LOJA    .OR.;
                   aCols[I,09] <> SD1->D1_LOTECTL .OR.;
                   aCols[I,10] <> SD1->D1_NUMLOTE .OR.;
                   aCols[I,12] <> SD1->D1_QUANT   .OR.;
                   aCols[I,13] <> SD1->D1_QTSEGUM
                   RecLock("SD1",.F.)
                   SD1->D1_DTDIGIT := aCols[I,02]
                   SD1->D1_DOC     := aCols[I,03]
                   SD1->D1_SERIE   := aCols[I,04]
                   SD1->D1_FORNECE := aCols[I,05]
                   SD1->D1_LOJA    := aCols[I,06]
                   SD1->D1_LOTECTL := aCols[I,09]
                   SD1->D1_NUMLOTE := IF(!lNumLote,aCols[I,10],Space(06))
                   SD1->D1_QUANT   := aCols[I,12]
                   SD1->D1_QTSEGUM := aCols[I,13]
                   MsUnlock()
                Endif
             Endif
           Case aCols[I,1] = "SD2"
             DBSelectArea("SD2")
             DBGoto(aCols[I,14])
             IF aCols[I,15] // Deletar
                RecLock("SD2",.F.)
                DBDelete()
                MsUnlock()
             Else  
                IF aCols[I,02] <> D2_EMISSAO .OR.;
                   aCols[I,03] <> D2_DOC     .OR.;
                   aCols[I,04] <> D2_SERIE   .OR.;
                   aCols[I,05] <> D2_CLIENTE .OR.;
                   aCols[I,06] <> D2_LOJA    .OR.;
                   aCols[I,09] <> D2_LOTECTL .OR.;
                   aCols[I,10] <> D2_NUMLOTE .OR.;
                   aCols[I,11] <> D2_LOCALIZ .OR.;
                   aCols[I,12] <> D2_QUANT   .OR.;
                   aCols[I,13] <> D2_QTSEGUM
                   RecLock("SD2",.F.)
                   SD2->D2_EMISSAO := aCols[I,02]
                   SD2->D2_DOC     := aCols[I,03]
                   SD2->D2_SERIE   := aCols[I,04]
                   SD2->D2_CLIENTE := aCols[I,05]
                   SD2->D2_LOJA    := aCols[I,06]
                   SD2->D2_LOTECTL := aCols[I,09]
                   SD2->D2_NUMLOTE := IF(!lNumLote,aCols[I,10],Space(06))
                   SD2->D2_LOCALIZ := aCols[I,11]
                   SD2->D2_QUANT   := aCols[I,12]
                   SD2->D2_QTSEGUM := aCols[I,13]
                   MsUnlock()
                Endif
             Endif
           Case aCols[I,1] = "SD3"
             DBSelectArea("SD3")
             DBGoto(aCols[I,14])
             IF aCols[I,15] // Deletar
                RecLock("SD3",.F.)
                DBDelete()
                MsUnlock()
             Else  
                IF aCols[I,02] <> D3_EMISSAO .OR.;
                   aCols[I,03] <> D3_DOC     .OR.;
                   aCols[I,09] <> D3_LOTECTL .OR.;
                   aCols[I,10] <> D3_NUMLOTE .OR.;
                   aCols[I,11] <> D3_LOCALIZ .OR.;
                   aCols[I,12] <> D3_QUANT   .OR.;
                   aCols[I,13] <> D3_QTSEGUM
                   RecLock("SD3",.F.)
                   SD3->D3_EMISSAO := aCols[I,02]
                   SD3->D3_DOC     := aCols[I,03]
                   SD3->D3_LOTECTL := aCols[I,09]
                   SD3->D3_NUMLOTE := IF(!lNumLote,aCols[I,10],Space(06))
                   SD3->D3_LOCALIZ := aCols[I,11]
                   SD3->D3_QUANT   := aCols[I,12]
                   SD3->D3_QTSEGUM := aCols[I,13]
                   MsUnlock()
                Endif
             Endif
           Case aCols[I,1] = "SD5"
             DBSelectArea("SD5")
             DBGoto(aCols[I,14])
             IF aCols[I,15] // Deletar
                RecLock("SD5",.F.)
                DBDelete()
                MsUnlock()
             Else  
                IF aCols[I,02] <> D5_DATA    .OR.;
                   aCols[I,03] <> D5_DOC     .OR.;
                   aCols[I,04] <> D5_SERIE   .OR.;
                   aCols[I,05] <> D5_CLIFOR  .OR.;
                   aCols[I,06] <> D5_LOJA    .OR.;
                   aCols[I,09] <> D5_LOTECTL .OR.;
                   aCols[I,10] <> D5_NUMLOTE .OR.;
                   aCols[I,12] <> D5_QUANT   .OR.;
                   aCols[I,13] <> D5_QTSEGUM
                   RecLock("SD5",.F.)
                   SD5->D5_DATA    := aCols[I,02]
                   SD5->D5_DOC     := aCols[I,03]
                   SD5->D5_SERIE   := aCols[I,04]
                   SD5->D5_CLIFOR  := aCols[I,05]
                   SD5->D5_LOJA    := aCols[I,06]
                   SD5->D5_LOTECTL := aCols[I,09]
                   SD5->D5_NUMLOTE := IF(!lNumLote,aCols[I,10],Space(06))
                   SD5->D5_QUANT   := aCols[I,12]
                   SD5->D5_QTSEGUM := aCols[I,13]
                   MsUnlock()
                Endif
             Endif
           Case aCols[I,1] = "SDB"
             DBSelectArea("SDB")
             DBGoto(aCols[I,14])
             IF aCols[I,15] // Deletar
                RecLock("SDB",.F.)
                DBDelete()
                MsUnlock()
             Else  
                IF aCols[I,02] <> DB_DATA    .OR.;
                   aCols[I,03] <> DB_DOC     .OR.;
                   aCols[I,04] <> DB_SERIE   .OR.;
                   aCols[I,05] <> DB_CLIFOR  .OR.;
                   aCols[I,06] <> DB_LOJA    .OR.;
                   aCols[I,09] <> DB_LOTECTL .OR.;
                   aCols[I,10] <> DB_NUMLOTE .OR.;
                   aCols[I,11] <> DB_LOCALIZ .OR.;
                   aCols[I,12] <> DB_QUANT   .OR.;
                   aCols[I,13] <> DB_QTSEGUM
                   RecLock("SDB",.F.)
                   SDB->DB_DATA    := aCols[I,02]
                   SDB->DB_DOC     := aCols[I,03]
                   SDB->DB_SERIE   := aCols[I,04]
                   SDB->DB_CLIFOR  := aCols[I,05]
                   SDB->DB_LOJA    := aCols[I,06]
                   SDB->DB_LOTECTL := aCols[I,09]
                   SDB->DB_NUMLOTE := IF(!lNumLote,aCols[I,10],Space(06))
                   SDB->DB_LOCALIZ := aCols[I,11]
                   SDB->DB_QUANT   := aCols[I,12]
                   SDB->DB_QTSEGUM := aCols[I,13]
                   MsUnlock()
                Endif
             Endif
        EndCase
     Next         
EndCase  

Do Case
  Case Substr(cOpcao,1,2) == "B8"
    Processa({||fDetaSB8()})  // Detalhe do SB8 x SD5
  Case Substr(cOpcao,1,2) == "D5" .AND. cFolder <> "13"
    IF cB8xD5 = "B8=>D5"
       Processa({||fDetaSB8()})   // Detalhe do SB8 x SD5
       Processa({||fMontaSD5()})  // Detalhe do SB8 x SD5
    Else
       Processa({||fDetaSD5()})      // Detalhe do SB8 x SD5
       Processa({||fMontaSB8(.T.)})  // Detalhe do SB8 x SD5
    Endif   
  Case Substr(cOpcao,1,2) == "BF"
    Processa({||fDetaSBF()})  // Detalhe do SB8 x SD5
  Case Substr(cOpcao,1,2) == "DB" .AND. cFolder <> "13"
    IF cBFxDB = "BF=>DB"
       Processa({||fDetaSBF()})   // Detalhe do SBF x SDB
       Processa({||fMontaSDB()})  // Detalhe do SBF x SDB
    Else
       Processa({||fDetaSDB()})   // Detalhe do SBF x SDB
       Processa({||fMontaSBF(.T.)})  // Detalhe do SBF x SDB
    Endif 
  Case cOpcao == "DAxB8"
    Processa({||fDetaDASB8()})      
  Case cOpcao == "SDA"  
    Processa({||fDetaSDA()})      
  Case cOpcao $ "BJ_I/BJ_A/BJ_E"
    Processa({||fDetaSBJ()})  
  Case cOpcao $ "BK_I/BK_A/BK_E"
    Processa({||fDetaSBK()})    
EndCase

RestArea(aArea)

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fMovto(lSB8,lSD5,cProduto,cLocal,cLoteCtl,cNumLote,cLoteFor,cCliFor,cLoja,cTm,cOrigLan,cChave,cNumSeq,cDoc,cSerie,cOp,nQuant,nQuant2UM,dData,dDtValid,lCrialote,nPotencia)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local nRegistro := 0
Local aArea    := GetArea()
Local aAreaSB1 := SB1->(GetArea())

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Preenche parametros nao recebidos pela funcao         ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
dData     := IF(dData == NIL .Or. !(ValType(dData) == "D") .Or. Empty(dData),dDataBase,dData)
cChave    := IF(cChave == NIL,"",cChave)
cLoteFor  := IF(cLoteFor == NIL,"",cLoteFor)
nQuant2UM := If(nQuant2UM == NIL, ConvUM(cProduto, nQuant, 0, 2),ConvUM(cProduto, nQuant, nQuant2UM,2))
lCriaLote := If(ValType(lCriaLote) # "L",.F.,lCrialote)
nPotencia := If(nPotencia == NIL, 0,nPotencia)
cNumSeq   := IF(Empty(cNumSeq),ProxNum(),cNumSeq)

DBSelectArea("SB1")
DBSetOrder(1)
DBSeek(xFilial("SB1")+cProduto)
// Descobre a data de validade
If !(ValType(dDtValid) == "D") .Or. Empty(dDtValid)
	If SB1->B1_FILIAL+SB1->B1_COD == xFilial("SB1")+cProduto
		dDtValid:=dData+SB1->B1_PRVALID
	Else
		dDtValid:=dData
	EndIf
EndIf
RestArea(aAreaSB1)

// Descobre o NumLote
IF !lNumLote
   cNumLote := If(cNumLote == Nil,NextLote(cProduto,"S"),IF(Empty(cNumLote),NextLote(cProduto,"S"),cNumLote))
Else          
   cNumLote := Space(6)       
Endif                      

// Descobre o lote
cLoteCtl := If(Empty(cLoteCtl),NextLote(cProduto,"L",cNumLote),cLoteCtl)
cLoteCtl := If(Empty(cLoteCtl),"AUTO"+cNumLote,cLoteCtl)

IF lSB8
  DBSelectArea("SB8")
  RecLock("SB8",.T.)
  Replace	B8_FILIAL  with cFilial,;
  	B8_NUMLOTE with cNumLote,;
	B8_PRODUTO with cProduto,;
	B8_LOCAL   with cLocal,;
	B8_DATA    with dData,;
	B8_DTVALID with dDtValid,;
	B8_SALDO   with nQuant,;
	B8_SALDO2  with nQuant2UM,;
	B8_ORIGLAN with cOrigLan,;
	B8_LOTEFOR with cLoteFor,;
	B8_DOC     with cDoc,;
	B8_SERIE   with cSerie,;
	B8_CLIFOR  with cCliFor,;
	B8_LOJA    with cLoja,;
	B8_PRODUTO with cProduto,;
	B8_QTDORI  with nQuant,;
	B8_QTDORI2 with nQuant2UM,;
	B8_LOTECTL with cLoteCtl,;
	B8_POTENCI with nPotencia
  MsUnlock()

  // Verifica se a data de validade pode ser utilizada
  nRegistro:=Recno()
  If DBSeek(xFilial("SB8")+cProduto+cLocal+cLoteCtl+IF(Rastro(cProduto,"S"),cNumLote,""))
     If	dDtValid # SB8->B8_DTVALID
  		HelpAutoma(" ",1,"A240DTVALI")
    	dDtValid:=SB8->B8_DTVALID
		// Grava no registro o Lote e a Data de Validade
		DBGoto(nRegistro)
		RecLock("SB8",.F.)
		Replace	B8_DTVALID with dDtValid
	 	MsUnlock()
  	 EndIf
  EndIf
  DBGoto(nRegistro)
Endif

IF lSD5
   GravaSD5("SD5",cProduto,cLocal,cLoteCtl,cNumLote,cNumSeq,cDoc,cSerie,cOp,cTm,cCliFor,cLoja,cLoteFor,nQuant,nQuant2UM,dData,dDtValid,nPotencia)
EndIf

RestArea(aArea)

Return NIL

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fGravaSBF(cTM,cProduto,cLocal,cLoteCtl,cNumLote,cNumSeq,cEndereco,nQuant,nQuant2UM)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local aAreaAnt   := GetArea()
Local aAreaSBE   := SBE->(GetArea())
Local nMultiplic := 1
Local cEstFis    := ''
cNumSeq  := IF(cNumSeq  == Nil,Space(20),cNumSeq)

IF !lNumLote
   cNumLote := If(cNumLote == Nil,Space(06),cNumLote)
Else                                        
   cNumLote := Space(06)
Endif   

If cTM > "500"
   nMultiplic:=-1
EndIf

DBSelectArea("SBE")
DBSetOrder(1)
If DBSeek(xFilial('SBE')+cLocal+cEndereco, .F.)
   cEstFis := SBE->BE_ESTFIS
EndIf

DBSelectArea("SBF")
DBSetOrder(6)
If DBSeek(xFilial("SBF")+cLocal+cEndereco+cEstFis+cProduto+cNumSeq+cLoteCtl+cNumLote, .F.)
   RecLock("SBF",.F.)
Else
   RecLock("SBF",.T.)
   SBF->BF_FILIAL   := xFilial("SBF")
   SBF->BF_PRODUTO  := cProduto
   SBF->BF_LOCAL    := cLocal
   SBF->BF_LOCALIZ  := cEndereco
   If Rastro(BF_PRODUTO,"S")
 	  SBF->BF_NUMLOTE := cNumLote
   EndIf
   SBF->BF_LOTECTL  := cLoteCtl
   SBF->BF_PRIOR    := If(Empty(SBE->BE_PRIOR),"",SBE->BE_PRIOR)
EndIf
SBF->BF_QUANT   := BF_QUANT   + (nQuant * nMultiplic)
SBF->BF_QTSEGUM := BF_QTSEGUM + (nQuant2UM * nMultiplic)
SBF->BF_ESTFIS  := cEstFis
MsUnlock()

If SBF->BF_QUANT <= 0
   If lDelZero 
      DeletSBF()
   Endif
Else	
    //⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Altera o Status do Endereco no SBE para Ocupado caso este possua saldo no SBF ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	DBSelectArea('SBE')	
	DBSetOrder(1)
	If MsSeek(xFilial('SBE')+SBF->BF_LOCAL+SBF->BF_LOCALIZ, .F.) .And. !(SBE->BE_STATUS=='2') .And. !(SBE->BE_STATUS=='3')
	   If !IsCrossDoc(SBE->BE_ESTFIS)
		  RecLock('SBE', .F.)
		  SBE->BE_STATUS := '1'
		  MsUnlock()			
	   EndIf	
	EndIf
EndIf
RestArea(aAreaSBE)
RestArea(aAreaAnt)
Return Nil


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fAjustD5DB(cOpcao)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local oDlgDados
Local aArea   := GetArea()
Local cNumSeq := aNumSeq[oNumSeq:nAT][01]

DBSelectArea("SB1")

aHeader := {}                                                                                                          
//             X3_TITULO          , X3_CAMPO  , X3_PICTURE        ,X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT
aadd(aHeader, {"Origem"           , "ORIGEM"  , "@!"              , 03       , 0         ,"U_ValidACols()"       , ""      , "C"    , ""        ,,})
aadd(aHeader, {"Data"             , "DATA"    , "99/99/99"        , 08       , 0         ,""       , ""      , "D"    , ""        ,,})
aadd(aHeader, {"Docto."           , "DOCTO"   , "@!"              , 06       , 0         ,""       , ""      , "C"    , ""        ,,})
aadd(aHeader, {"Serie"            , "SERIE"   , "@!"              , 03       , 0         ,""       , ""      , "C"    , ""        ,,})
aadd(aHeader, {"Clie.For"         , "CLIEFOR" , "@!"              , 06       , 0         ,""       , ""      , "C"    , ""        ,,})
aadd(aHeader, {"Loja"             , "LOJA"    , "@!"              , 02       , 0         ,""       , ""      , "C"    , ""        ,,})
aadd(aHeader, {"TES"              , "TES"     , "@!"              , 03       , 0         ,"U_ValidACols()"       , ""      , "C"    , ""        ,,})
aadd(aHeader, {"CF"               , "CF"      , "@!"              , 03       , 0         ,"U_ValidACols()"       , ""      , "C"    , ""        ,,})
aadd(aHeader, {"Lote"             , "LOTE"    , "@!"              , 10       , 0         ,""       , ""      , "C"    , ""        ,,})
aadd(aHeader, {"Num.Lote"         , "NUMLOTE" , "@!"              , 06       , 0         ,""       , ""      , "C"    , ""        ,,})
aadd(aHeader, {"EndereÁo"         , "ENDERECO", "@!"              , 15       , 0         ,""       , ""      , "C"    , ""        ,,})
aadd(aHeader, {"Qtde."            , "QTDE"    , cPict             , 18       , 2         ,"U_ValidACols()"       , ""      , "N"    , ""        ,,})
aadd(aHeader, {"Qtde.UM2"         , "QTDE2UM" , cPict2UM          , 18       , 2         ,"U_ValidACols()"       , ""      , "N"    , ""        ,,})

aCols   := {}

// SD1
DBSelectArea("SD1")
DBSetOrder(4) //--D1_FILIAL+D1_NUMSEQ
DBSeek(xFilial("SD1")+cNumSeq)
While !Eof() .AND. xFilial("SD1")+cNumSeq == D1_FILIAL+D1_NUMSEQ
  IF D1_COD = cProduto .AND. D1_LOCAL = cLocal
     Aadd(aCols, {})
     Aadd(aCols[Len(aCols)], "SD1"     )
     Aadd(aCols[Len(aCols)], D1_DTDIGIT)
     Aadd(aCols[Len(aCols)], D1_DOC    )
     Aadd(aCols[Len(aCols)], D1_SERIE  )
     Aadd(aCols[Len(aCols)], D1_FORNECE)
     Aadd(aCols[Len(aCols)], D1_LOJA   )
     Aadd(aCols[Len(aCols)], D1_TES    )
     Aadd(aCols[Len(aCols)], D1_CF     )
     Aadd(aCols[Len(aCols)], D1_LOTECTL)
     Aadd(aCols[Len(aCols)], D1_NUMLOTE)
     Aadd(aCols[Len(aCols)], Space(15) )  
     Aadd(aCols[Len(aCols)], D1_QUANT  )
     Aadd(aCols[Len(aCols)], D1_QTSEGUM)  
     Aadd(aCols[Len(aCols)], RECNO()   )    
     Aadd(aCols[Len(aCols)],.F.)
  Endif   
  DBSkip()
Enddo

// SD2
DBSelectArea("SD2")
DBSetOrder(4) //--D2_FILIAL+D2_NUMSEQ
DBSeek(xFilial("SD2")+cNumSeq)
While !Eof() .AND. xFilial("SD2")+cNumSeq == D2_FILIAL+D2_NUMSEQ
  IF D2_COD = cProduto .AND. D2_LOCAL = cLocal
     Aadd(aCols, {})
     Aadd(aCols[Len(aCols)], "SD2"     )
     Aadd(aCols[Len(aCols)], D2_EMISSAO)
     Aadd(aCols[Len(aCols)], D2_DOC    )
     Aadd(aCols[Len(aCols)], D2_SERIE  )
     Aadd(aCols[Len(aCols)], D2_CLIENTE)
     Aadd(aCols[Len(aCols)], D2_LOJA   )
     Aadd(aCols[Len(aCols)], D2_TES    )
     Aadd(aCols[Len(aCols)], D2_CF     )
     Aadd(aCols[Len(aCols)], D2_LOTECTL)
     Aadd(aCols[Len(aCols)], D2_NUMLOTE)
     Aadd(aCols[Len(aCols)], D2_LOCALIZ)  
     Aadd(aCols[Len(aCols)], D2_QUANT  )
     Aadd(aCols[Len(aCols)], D2_QTSEGUM)  
     Aadd(aCols[Len(aCols)], RECNO()   )    
     Aadd(aCols[Len(aCols)],.F.)
  Endif
  DBSkip()
Enddo

// SD3
DBSelectArea("SD3")
DBSetOrder(4) //--D3_FILIAL+D3_NUMSEQ+D3_CHAVE+D3_COD
DBSeek(xFilial("SD3")+cNumSeq)
While !Eof() .AND. xFilial("SD3")+cNumSeq == D3_FILIAL+D3_NUMSEQ
  IF D3_ESTORNO <> "S" .AND. D3_COD = cProduto .AND. D3_LOCAL = cLocal
     Aadd(aCols, {})
     Aadd(aCols[Len(aCols)], "SD3"     )
     Aadd(aCols[Len(aCols)], D3_EMISSAO)
     Aadd(aCols[Len(aCols)], D3_DOC    )
     Aadd(aCols[Len(aCols)], Space(03) )
     Aadd(aCols[Len(aCols)], Space(06) )
     Aadd(aCols[Len(aCols)], Space(02) )
     Aadd(aCols[Len(aCols)], D3_TM     )
     Aadd(aCols[Len(aCols)], D3_CF     )
     Aadd(aCols[Len(aCols)], D3_LOTECTL)
     Aadd(aCols[Len(aCols)], D3_NUMLOTE)
     Aadd(aCols[Len(aCols)], D3_LOCALIZ)  
     Aadd(aCols[Len(aCols)], D3_QUANT  )
     Aadd(aCols[Len(aCols)], D3_QTSEGUM)  
     Aadd(aCols[Len(aCols)], RECNO()   )    
     Aadd(aCols[Len(aCols)],.F.)
  Endif   
  DBSkip()
Enddo

Aadd(aCols, {})
Aadd(aCols[Len(aCols)], Space(03) )
Aadd(aCols[Len(aCols)], CTOD("  /  /  "))
Aadd(aCols[Len(aCols)], Space(06) )
Aadd(aCols[Len(aCols)], Space(03) )
Aadd(aCols[Len(aCols)], Space(06) )
Aadd(aCols[Len(aCols)], Space(02) )
Aadd(aCols[Len(aCols)], Space(03) )
Aadd(aCols[Len(aCols)], Space(03) )
Aadd(aCols[Len(aCols)], Space(10) )
Aadd(aCols[Len(aCols)], Space(06) )
Aadd(aCols[Len(aCols)], Space(15) )  
Aadd(aCols[Len(aCols)], 0         )
Aadd(aCols[Len(aCols)], 0         )  
Aadd(aCols[Len(aCols)], 0         )    
Aadd(aCols[Len(aCols)],.F.)

// SD5
DBSelectArea("SD5")
DBSetOrder(3) //-- D5_FILIAL+D5_NUMSEQ+D5_PRODUTO+D5_LOCAL+D5_LOTECTL+D5_NUMLOTE
DBSeek(xFilial("SD5")+cNumSeq)
While !Eof() .AND. xFilial("SD5")+cNumSeq == D5_FILIAL+D5_NUMSEQ
  IF D5_ESTORNO <> "S" .AND. D5_PRODUTO = cProduto .AND. D5_LOCAL = cLocal
     Aadd(aCols, {})
     Aadd(aCols[Len(aCols)], "SD5"     )
     Aadd(aCols[Len(aCols)], D5_DATA   )
     Aadd(aCols[Len(aCols)], D5_DOC    )
     Aadd(aCols[Len(aCols)], D5_SERIE  )
     Aadd(aCols[Len(aCols)], D5_CLIFOR )
     Aadd(aCols[Len(aCols)], D5_LOJA   )
     Aadd(aCols[Len(aCols)], D5_ORIGLAN)
     Aadd(aCols[Len(aCols)], Space(03) )
     Aadd(aCols[Len(aCols)], D5_LOTECTL)
     Aadd(aCols[Len(aCols)], D5_NUMLOTE)
     Aadd(aCols[Len(aCols)], Space(15) )  
     Aadd(aCols[Len(aCols)], D5_QUANT  )
     Aadd(aCols[Len(aCols)], D5_QTSEGUM)  
     Aadd(aCols[Len(aCols)], RECNO()   )    
     Aadd(aCols[Len(aCols)],.F.)
  Endif
  DBSkip()
Enddo

Aadd(aCols, {})
Aadd(aCols[Len(aCols)], Space(03) )
Aadd(aCols[Len(aCols)], CTOD("  /  /  "))
Aadd(aCols[Len(aCols)], Space(06) )
Aadd(aCols[Len(aCols)], Space(03) )
Aadd(aCols[Len(aCols)], Space(06) )
Aadd(aCols[Len(aCols)], Space(02) )
Aadd(aCols[Len(aCols)], Space(03) )
Aadd(aCols[Len(aCols)], Space(03) )
Aadd(aCols[Len(aCols)], Space(10) )
Aadd(aCols[Len(aCols)], Space(06) )
Aadd(aCols[Len(aCols)], Space(15) )  
Aadd(aCols[Len(aCols)], 0         )
Aadd(aCols[Len(aCols)], 0         )  
Aadd(aCols[Len(aCols)], 0         )    
Aadd(aCols[Len(aCols)],.F.)

// SDB
DBSelectArea("SDB")
DBSetOrder(1) //--DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM
DBSeek(xFilial("SDB")+cProduto+cLocal+cNumSeq)
While !Eof() .AND. xFilial("SDB")+cProduto+cLocal+cNumSeq == DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ
  IF DB_ESTORNO <> "S" .AND. DB_ATUEST <> "N" .AND. DB_PRODUTO = cProduto .AND. DB_LOCAL = cLocal
     Aadd(aCols, {})
     Aadd(aCols[Len(aCols)], "SDB"     )
     Aadd(aCols[Len(aCols)], DB_DATA   )
     Aadd(aCols[Len(aCols)], DB_DOC    )
     Aadd(aCols[Len(aCols)], DB_SERIE  )
     Aadd(aCols[Len(aCols)], DB_CLIFOR )
     Aadd(aCols[Len(aCols)], DB_LOJA   )
     Aadd(aCols[Len(aCols)], DB_TM     )
     Aadd(aCols[Len(aCols)], Space(03) )
     Aadd(aCols[Len(aCols)], DB_LOTECTL)
     Aadd(aCols[Len(aCols)], DB_NUMLOTE)
     Aadd(aCols[Len(aCols)], DB_LOCALIZ)  
     Aadd(aCols[Len(aCols)], DB_QUANT  )
     Aadd(aCols[Len(aCols)], DB_QTSEGUM)  
     Aadd(aCols[Len(aCols)], RECNO()   )    
     Aadd(aCols[Len(aCols)],.F.)
  Endif
  DBSkip()
Enddo

Aadd(aCols, {})
Aadd(aCols[Len(aCols)], Space(03) )
Aadd(aCols[Len(aCols)], CTOD("  /  /  "))
Aadd(aCols[Len(aCols)], Space(06) )
Aadd(aCols[Len(aCols)], Space(03) )
Aadd(aCols[Len(aCols)], Space(06) )
Aadd(aCols[Len(aCols)], Space(02) )
Aadd(aCols[Len(aCols)], Space(03) )
Aadd(aCols[Len(aCols)], Space(03) )
Aadd(aCols[Len(aCols)], Space(10) )
Aadd(aCols[Len(aCols)], Space(06) )
Aadd(aCols[Len(aCols)], Space(15) )  
Aadd(aCols[Len(aCols)], 0         )
Aadd(aCols[Len(aCols)], 0         )  
Aadd(aCols[Len(aCols)], 0         )    
Aadd(aCols[Len(aCols)],.F.)

// SDA
DBSelectArea("SDA")
DBSetOrder(1) //--DA_FILIAL+DA_PRODUTO+DA_LOCAL+DA_NUMSEQ+DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA
DBSeek(xFilial("SDA")+cProduto+cLocal+cNumSeq)
While !Eof() .AND. xFilial("SDA")+cProduto+cLocal+cNumSeq == DA_FILIAL+DA_PRODUTO+DA_LOCAL+DA_NUMSEQ
  IF DA_SALDO <> 0  .AND. DA_PRODUTO = cProduto .AND. DA_LOCAL = cLocal
     Aadd(aCols, {})
     Aadd(aCols[Len(aCols)], "SDA"     )
     Aadd(aCols[Len(aCols)], DA_DATA   )
     Aadd(aCols[Len(aCols)], DA_DOC    )
     Aadd(aCols[Len(aCols)], DA_SERIE  )
     Aadd(aCols[Len(aCols)], DA_CLIFOR )
     Aadd(aCols[Len(aCols)], DA_LOJA   )
     Aadd(aCols[Len(aCols)], DA_ORIGEM )
     Aadd(aCols[Len(aCols)], Space(03) )
     Aadd(aCols[Len(aCols)], DA_LOTECTL)
     Aadd(aCols[Len(aCols)], DA_NUMLOTE)
     Aadd(aCols[Len(aCols)], Space(15) )  
     Aadd(aCols[Len(aCols)], DA_SALDO  )
     Aadd(aCols[Len(aCols)], DA_QTSEGUM)  
     Aadd(aCols[Len(aCols)], RECNO()   )    
     Aadd(aCols[Len(aCols)],.F.)
  Endif   
  DBSkip()
Enddo

@ 010,010 To 400,820 DIALOG oDlgDados TITLE "Alterar Dados" 
@ 003,005  To 170,400 MULTILINE MODIFY DELETE 
@ 175,050 BUTTON "&Confirmar" SIZE 30,14 PIXEL ACTION (fAjusta(cOpcao),oDlgDados:End())
@ 175,090 BUTTON "&Sair"      SIZE 30,14 PIXEL ACTION oDlgDados:End()
ACTIVATE DIALOG oDlgDados  CENTERED

RestArea(aArea)

Return                                  

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ValidACols()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local cCampo  := ReadVar()
Local _Return := .T.
IF cCampo $ "M->ORIGEM/M->CF"
   MsgStop("Este campo n„o pode ser alterado.","AtenÁ„o")
   _Return := .F.
ElseIF cCampo == "M->QTDE2UM"
   nQuant     := &(cCampo)
   aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "QTDE"})]    := ConvUM(cProduto,0,nQuant,1) // 1UM
ElseIF cCampo == "M->QTDE"
   nQuant     := &(cCampo)
   aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "QTDE2UM"})] := ConvUM(cProduto,nQuant,0,2) // 2UM
Endif      
Return (_Return)


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fPesquisa(cOpcao,oBrowse)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local oDlgPesq
Local aArea   := GetArea()
Local cCampos := Space(20)          
Local cSeek   := Space(20)   
Local aCampos := {}

For I:= 1 To Len(oBrowse:AHEADERS)
   IF Valtype(oBrowse:AARRAY[1,I]) = "C" .AND. !UPPER(Alltrim(oBrowse:AHEADERS[I])) $ "STATUS/TM/SERIE/LOJA/CLIE.FOR/ORIGEM"
      AAdd(aCampos,oBrowse:AHEADERS[I])
   Endif   
Next

DBSelectArea("SB1")

DEFINE MSDIALOG oDlgPesq TITLE "Pesquisar no "+cOpcao  OF oDlgPesq PIXEL FROM 010,010 TO 150,265 

@ 010,005 COMBOBOX cCampos ITEMS aCampos       SIZE 100,10 PIXEL OF oDlgPesq 
@ 030,005 MSGET oVar  VAR  cSeek Picture "@!"  SIZE 100,10 PIXEL OF oDlgPesq 
                                                 
@ 050,050 BUTTON "&Pesquisar" SIZE 30,14 PIXEL ACTION (Processa({|| fPesq(cOpcao,cCampos,cSeek)}),oDlgPesq:End())
@ 050,090 BUTTON "&Sair"      SIZE 30,14 PIXEL ACTION oDlgPesq:End()

ACTIVATE MSDIALOG oDlgPesq  CENTERED

RestArea(aArea)

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fPesq(cOpcao,cCampos,cSeek)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Do Case
   Case cOpcao = "SBJ"
     nSeek := Ascan(oAnaSBJ:AHEADERS,cCampos)
     IF (nPos := Ascan(aAnaSBJ, { |x| Alltrim(x[nSeek]) == Alltrim(cSeek) })) > 0
       oAnaSBJ:nAT := nPos
     Endif      
   Case cOpcao = "SBK"
     nSeek := Ascan(oAnaSBK:AHEADERS,cCampos)
     IF (nPos := Ascan(aAnaSBK, { |x| Alltrim(x[nSeek]) == Alltrim(cSeek) })) > 0
       oAnaSBK:nAT := nPos
     Endif      
   Case cOpcao = "SB8"
     nSeek := Ascan(oDetSB8:AHEADERS,cCampos)
     IF (nPos := Ascan(aDetSB8, { |x| Alltrim(x[nSeek]) == Alltrim(cSeek) })) > 0
       oDetSB8:nAT := nPos
     Endif      
   Case cOpcao = "SD5" 
     nSeek := Ascan(oDetSD5:AHEADERS,cCampos)
     IF (nPos := Ascan(aDetSD5, { |x| Alltrim(x[nSeek]) == Alltrim(cSeek) })) > 0
       oDetSD5:nAT := nPos
     Endif      
   Case cOpcao = "SBF" 
     nSeek := Ascan(oDetSBF:AHEADERS,cCampos)
     IF (nPos := Ascan(aDetSBF, { |x| Alltrim(x[nSeek]) == Alltrim(cSeek) })) > 0
       oDetSBF:nAT := nPos
     Endif      
   Case cOpcao = "SDB" 
     nSeek := Ascan(oDetSDB:AHEADERS,cCampos)
     IF (nPos := Ascan(aDetSDB, { |x| Alltrim(x[nSeek]) == Alltrim(cSeek) })) > 0
       oDetSDB:nAT := nPos
     Endif  
/*   Case cOpcao = "DOCTO"
     nSeek := Ascan(oDocto:AHEADERS,cCampos)
     IF (nPos := Ascan(aDocto, { |x| Alltrim(x[nSeek]) == Alltrim(cSeek) })) > 0
       oDocto:nAT := nPos
     Endif      */
   Case cOpcao = "NUMSEQ" 
     nSeek := Ascan(oNumSeq:AHEADERS,cCampos)
     IF (nPos := Ascan(aNumSeq, { |x| Alltrim(x[nSeek]) == Alltrim(cSeek) })) > 0
       oNumSeq:nAT := nPos
     Endif       
EndCase
Return (nPos)


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fDigSenha()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Private cSenha   := Space(10)         
Private cSenhAce := "sql2010"
@ 067,020 To 169,312 Dialog Senhadlg Title OemToAnsi("LiberaÁ„o de Acesso")
@ 015,005 Say OemToAnsi("Informe a senha para o acesso ?") Size 80,8
@ 015,089 Get cSenha Size 50,10 Password
@ 037,106 BmpButton Type 1 Action fOK()
@ 037,055 BmpButton Type 2 Action Close(Senhadlg)
Activate Dialog Senhadlg CENTERED
Return(_lReturn)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fOK()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
If ALLTRIM(cSenha)<> cSenhAce
   MsgStop("Senha n„o Confere !!!")
   cSenha  := Space(10)
   dlgRefresh(Senhadlg)
Else
   _lReturn  := .T.
   Close(Senhadlg)
Endif
Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fPesqDifLote(cOpcao)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local lAchou := .F.       
IF cOpcao = "Prox"
   nIni := (oKarLote:nAT + 1)
   For nPos := nIni To Len(aKarLote)
     IF Substr(aKarLote[nPos,10],1,10) = "Saldo SB8:"
        lAchou := .T.
        Exit
     Endif
   Next
ElseIF cOpcao = "Ante"
   nIni := (oKarLote:nAT - 1)
   For nPos := nIni To 1 STEP -1
    IF Substr(aKarLote[nPos,10],1,10) = "Saldo SB8:"
       lAchou := .T.
       Exit
    Endif
   Next
Endif
IF lAchou
   oKarLote:nAT := nPos
Else
   MsgAlert("N„o Existe DiferenÁa !")
Endif

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fPesqDifEnde(cOpcao)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local lAchou := .F.       
IF cOpcao = "Prox"
   nIni := (oKarEnde:nAT + 1)
   For nPos := nIni To Len(aKarEnde)
     IF Substr(aKarEnde[nPos,09],1,10) = "Saldo SBF:"
        lAchou := .T. 
        Exit
     Endif
   Next
ElseIF cOpcao = "Ante"
   nIni := (oKarEnde:nAT - 1)
   For nPos := nIni To 1 STEP -1
    IF Substr(aKarEnde[nPos,09],1,10) = "Saldo SBF:"
       lAchou := .T. 
       Exit
    Endif
   Next
Endif  
IF lAchou 
   oKarEnde:nAT := nPos
Else
   MsgAlert("N„o Existe DiferenÁa !")
Endif   
Return  


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fPesqNumSeq(cOpcao)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Do Case
  Case cOpcao = "Lote"
    cNumSeq :=  aKarLote[oKarLote:nAT,10]
    IF fPesq("NUMSEQ","Num.Seq.",cNumSeq) > 0
       oFolder:nOption := 13
       oNumSeq:Refresh()
    Endif   
  Case cOpcao = "Ende"
    cNumSeq :=  aKarEnde[oKarEnde:nAT,09]
    IF fPesq("NUMSEQ","Num.Seq.",cNumSeq) > 0
       oFolder:nOption := 13
       oNumSeq:Refresh()
    Endif   
EndCase    
Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fPesqKarEnd()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
cNumSeq := aNumSeq[oNumSeq:nAT,01]
nSeek   := Ascan(oKarEnde:AHEADERS,"Num.Seq.")
IF (nPos := Ascan(aKarEnde, { |x| Alltrim(x[nSeek]) == Alltrim(cNumSeq) })) > 0
   oKarEnde:nAT := nPos
   oFolder:nOption := 11
   oKarEnde:Refresh()
Endif       
Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fSaldoAtual()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
DBSelectArea("SX1")
DBSetOrder(1)
If DbSeek("MTA30001")
   RecLock("SX1",.F.)
   SX1->X1_CNT01 := cLocal
   MsUnlock()
Endif
If DbSeek("MTA30002")
   RecLock("SX1",.F.)
   SX1->X1_CNT01 := cLocal
   MsUnlock()
Endif
If DbSeek("MTA30003")
   RecLock("SX1",.F.)
   SX1->X1_CNT01 := cProduto
   MsUnlock()
Endif
If DbSeek("MTA30004")
   RecLock("SX1",.F.)
   SX1->X1_CNT01 := cProduto
   MsUnlock()
Endif
                             
MATA300() 

Processa({||fProcessa()})

Return
/*
5.2
Inclusao da alteracao no SDA
5.3
Correcao do erro na confirmacao da alteracao da pasta numseq
5.4
Alteracao para contemplar o parametro MV_LOTEUNI
5.5
CorreÁ„o para validar movimentacao de SB2 e SBF e algums melhorias de pesquisa entre a pasta de kardex por endereco e a pasta numseq
5.6
CorreÁ„o na composicao de saldo na pasta SBFXSDB e SB8xSD5
Rotina de Saldo Atual no programa
12/06/2008
CorreÁ„o na composiÁ„o do saldo do kardex por endereco
Ajusta para compor o saldo do lote.
Melhoria para zerar os browse na troca de produot
*/

Static Function fFechamento()

Local aTab := {"SB2","SB8","SBF"}

	If !MsgYesno("CUIDADO!!!! "+chr(13)+chr(10)+"Este processo requer modo exclusivo!"+chr(13)+chr(10)+"Realizar fechamento?????")
		Return
	Endif 
	
	lContinua := .T.
	        
	//Begin transaction
	
		For xT:=1 to len(aTab)
		
			cTabela := RetSqlName( aTab[xT] )

			If TcCanOpen(cTabela) 
			
				dbSelectArea(aTab[xT])
				dbCloseArea(aTab[xT])

				If 	!TCDelFile(cTabela) //TCSQLEXEC(cQuery) < 0
					Alert(TCSQLError())
					lContinua := .F.
				ENDIF
				
				axcadastro(aTab[xT])
				
			Else
				Alert("Tabela nao pode ser aberta "+cTabela)
				lContinua := .F.				
			Endif  
			
		Next
		
	//End Transaction		
	If lContinua
	
		MATA300()
		
		//ShellExecute( "open", "iexplore.exe","http://painel.hotmobile.com.br/SendAPI/Send.aspx?usr=carlosa@whbbrasil.com.br&pwd=uca9mpqz&number=554199632022&msg=SALDO+ATUAL+OK","",5 )
		
		MATA215(.t.) // TRUE PRA RODAR EM BATCH
	
		ShellExecute( "open", "iexplore.exe","http://painel.hotmobile.com.br/SendAPI/Send.aspx?usr=carlosa@whbbrasil.com.br&pwd=uca9mpqz&number=554199632022&msg=REFAZ+ACUMULADOS+OK","",5 )	
	
	Endif
		
Return