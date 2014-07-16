/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST081  ³ Autor ³ Alexandre R. Bento     Data ³ 20/12/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Solicitação de Abertura de O.S. para Projeto                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Custos/Compras/Engenharia   				                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"    
#include "protheus.ch"        
#INCLUDE "FIVEWIN.CH"

User Function nhest081()

SetPrvt("CCADASTRO,AROTINA,_aTipoN,_cTipon,_dDtini,_dDtfim,_cConta,_nVlr,_cOS,_nSaldo,_nSalTot")
SetPrvt("onTVlrEm,onTVlrEo,onTVlrAm,onTVlrAo,oPrint,i,_aOSGer,_cNumos")

Private cStartPath 	:= GetSrvProfString("Startpath","")

If Right(cStartPath,1) <> "\"
	cStartPath += "\"
Endif

oFont10	 := TFont():New("Arial" ,10,10,,.F.,,,,.T.,.F.)
oFont10B := TFont():New("Arial" ,10,10,,.T.,,,,.T.,.F.)
oFont12	 := TFont():New("Arial" ,12,12,,.F.,,,,.T.,.F.)
oFont12B := TFont():New("Arial" ,12,12,,.T.,,,,.T.,.F.)
oFont12S := TFont():New("Arial" ,12,12,,.T.,,,,.T.,.T.)
oFont16	 := TFont():New("Arial" ,16,16,,.T.,,,,.T.,.F.)

cCadastro := OemToAnsi("Solicitação de Abertura de O.S. ")
aRotina := {{OemToAnsi("Pesquisar")      ,'AxPesqui'       ,0 , 1},;
            {OemToAnsi("Visualizar")     ,'U_fSolici(2)'   ,0 , 2},;
            {OemToAnsi("Incluir")        ,'U_fSolici(3)'   ,0 , 3},;
            {OemToAnsi("Alterar")        ,'U_fSolici(8)'   ,0 , 8},;            
            {OemToAnsi("Excluir")        ,'U_fSolici(4)'   ,0 , 4},;                   
            {OemToAnsi("Finalizar")      ,'U_fFinali()'    ,0 , 4},;
            {OemToAnsi("O.S. Complemen") ,'U_fSolici(5)'   ,0 , 5},;                               
            {OemToAnsi("Aprovação O.S.") ,'U_fSolici(6)'   ,0 , 6},;                                           
            {OemToAnsi("Imprimir")       ,'U_fSolimp()'    ,0 , 7},;
            {OemToAnsi("Detalhes")       ,'U_fSolDet(1)'   ,0 , 7},;
            {OemToAnsi("Rel.Geral")      ,'U_fSolDet(2)'   ,0 , 3},;            
            {OemToAnsi("Itens")          ,'U_fSolDet(3)'   ,0 , 7},;            
            {OemToAnsi("Legenda")        ,'U_FLegSoli'     ,0 , 2}}     

mBrowse( 6, 1,22,75,"ZA1",,,,,,fCriaCor())

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PRINCIPAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function fSolici(cPar01)

SetPrvt("nMax,aHeader,aCols,oMultiline,oDialog,_nId,lDialog,_cUser,_lFlag,_cUser,_aF4,_nF4,cQuery1")
SetPrvt("_cDoc,_aTipoN,_cTipon,_cCond,_cTpFre,_nPLiqui,_nPBruto,_nVol,_cEsp,_cMens,_cDesCli,_cF3")
SetPrvt("_cCliFor,_aTiFre,_cObs,_dData,_cHora,_cPar,_lExc,_cTpCli,_nMoeda,_aVia, _cVia,_cCodTra,_cDesTra,VK_F4")
SetPrvt("_cRamal,_aGet,_lMo,_lAlt")
SetPrvt("_cConta,_cCentro,_cDesCon,_cDesCC,_dDataI,_dDataF, _cResp,_cDesRes,_nVlrEst,_nVlrApr,_aAprova,_aOSComp,_cAprova,_cOSComp")
SetPrvt("_cDescSe,oDescSe,_ncVlrEs,_ncVlrAp,_dcData,_ccAprov,ocData,_lCOS,_lApOS,_cTitle,aCols,aHeader")
SetPrvt("_nVlrEMO,_nVlrAMO,_nVlrEMa,_nVlrAMa,_cEncera")
SetPrvt("_ncVlrEM,_ncVlrAM,_ncVlrEO,_ncVlrAO")      
SetPrvt("_nTVlrEM,_nTVlrAM,_nTVlrEO,_nTVlrAO")
SetPrvt("_nTVlrEs,_nTVlrAp,_cCombo,oCombo")
SetPrvt("onTVlrEm,onTVlrEo,onTVlrAm,onTVlrAo")
SetPrvt("_lMostra,_nTVlrNe,_cCli,_cNomCli,_cLoja")

//Local oCombo
_cTitle  := OemToAnsi("Solicitação de Abertura de O.S.")
_cDescSe := ""
_cConta  := space(20)
_cCentro := space(09)
_cDesCon := space(20)
_cDesCC  := space(20)
_dDataI  := Ctod("//")
_dDataF  := Ctod("//")
_dcData  := Ctod("//")
_cResp   := space(06)
_cDesRes := space(20)
_cDoc    := Space(06)      
_cCombo  := Space(06)      
_cCli    := Space(06)      
_cLoja   := Space(02)      
_cNomCli := Space(30)      
aCols    := {}
aHeader  := {}
_nVlrEst := 0
_nVlrApr := 0
_ncVlrEs := 0
_ncVlrAp := 0
_nTVlrEs := 0
_nTVlrAp := 0             
_nTVlrNe := 0
_lMostra := .F.

_nVlrEMO:=_nVlrAMO:=_nVlrEMa:=_nVlrAMa:=0
_ncVlrEM:=_ncVlrAM:=_ncVlrEO:=_ncVlrAO:=0
_nTVlrEM:=_nTVlrAM:=_nTVlrEO:=_nTVlrAO:=0

_dData   := date()
_cHora   := time()   

_lFlag   := .T.
_lCOS    := .F.
_lApOS   := .F.        
_lMo     := .F.        
_lAlt    := .F.

//If cPar01 <> 3 
//   alert(" Encerrada ")
//Endif

IF cPar01 == 4 //excluir
  _cTitle += OemToAnsi(" Exclusão")
  _cPar   := 2   // visualização
  _lExc   := .T. //Controle para excluir
  lDialog := .T.               
Else            
   If cPar01 == 6      
//      _cTitle += OemToAnsi(" Aprovação O.S.")
      _cPar   := 2   // visualização   
      _lApOS  := .T. //Aprovação de valor de OS
      _lExc   := .F. // Controle para não excluir
      lDialog := .F.   
      _lMo    := .F. //Lança mao de obra                    
   ElseIf cPar01 == 5
//      _cTitle += OemToAnsi(" Complemento de O.S.")
      _cPar   := 2   // visualização   
      _lCOS   := .T. //Complemento de OS
      _lExc   := .F. // Controle para não excluir
      lDialog := .F.                             
      _lMo    := .F. //Lança mao de obra                          
   ElseIf cPar01 == 7
      _cPar   := 2   // visualização   
      _lCOS   := .F. //Complemento de OS
      _lExc   := .F. // Controle para não excluir
      lDialog := .F.                                        
      _lMo    := .T. //Lança mao de obra                          
   ElseIf cPar01 == 8
      _cPar   := 2   // visualização   
      _lCOS   := .F. //Complemento de OS
      _lExc   := .F. // Controle para não excluir
      lDialog := .F.                                        
      _lMo    := .F. //Lança mao de obra                          
      _lAlt   := .T. //permite alterar
   Else
      _cPar   := cPar01 // receber visualizaçao ou impressao      
      _lExc   := .F. // Controle para não excluir
      lDialog := .F.           
      _lMo    := .F. //Lança mao de obra                          
   Endif         
Endif
_cDoc   := Space(06)
_aTipon := { OemToAnsi("B=Ferramental Imobilizado"),;
             OemToAnsi("C=Compra de Material - Construções"),;
             OemToAnsi("D=Custo Ferramental Fundição / Alumínio"),;
             OemToAnsi("F=Ferramental - Faturado p/ cliente"),;
             OemToAnsi("I=Instalações de Novas Máquinas"),;             
             OemToAnsi("P=Projeto de Melhoria,Ampliação Produção, Adequação da Linha, Reforma"),;
             OemToAnsi("M=Reforma de Bens de Terceiros")  }

_aAprova:= {"SIM","NAO"}
_aOSComp:= {"SIM","NAO"}//{"Aereo","Correio","Maritimo",OemToAnsi("Rodoviario")}
_cAprova:= "NAO" 
_ccAprov:= "NAO" 
_cEncera:= "NAO" 
_cOSComp:= Iif(cPar01==3,"NAO","SIM")
_cCodTra:= Space(06)
_cDesTra:= Space(40)
_cTipon := "Normal"   
_cCliFor:= "Cliente:"
_cCond  := Space(03)
_cTpFre := Space(10)  
_cUser  := Space(06)
_nPLiqui:= 0          
_nPBruto:= 0
_nVol   := 0
_cEsp   := "VOL"
_cMens  := Space(100) 
_cObs   := Space(100) 
_cF3    := Space(03)        
aHeader := {}        
aCols   := {}
_cTpCli := Space(01)
_nMoeda := 1

 nMax    := 0                                                       

If _cPar == 3
   _cTitle += OemToAnsi(" Inclusão")
      
  // _cDoc       := GetSXENum("SZQ","ZQ_NUM")   // Traz o novo numero da solicitação de NF
   _cUser := "Solicitante:  " + UsrFullname(__cUserId )
   _cRamal   := SUBSTR(U_Nhcfg001("06"),6,4)
   
   If empty(_cRamal)
   	_cRamal := space(4)
   Endif
ElseIf _cPar == 2

   fQuery()
   fMostra()

   If !_lFlag  
      Return //retorna para browse
   Endif
   //_cUser := "Solicitante:  " + UsrFullname(_cUser )   
Endif         

//DbSelectArea("ZA2")
If cPar01 == 5 // o.s. complementar
	Aadd(aHeader,{"Item"        , "ZAD_ITEM",    "@!"             ,04,0,".F.","","C","ZAD"}) //03
	Aadd(aHeader,{"Controle"    , "ZAD_CODCON"  ,"@!"             ,02,0,".T.","","C","ZAD"}) //03
	Aadd(aHeader,{"Descricao"   , "ZAD_DESCRI"  ,Repli("!",30)    ,30,0,".F.","","C","ZAD"}) //03                 
	Aadd(aHeader,{"Qtde"        , "ZAD_QUANT"   ,"@E 999999"      ,6,0 ,".T.","","N","ZAD"}) //03
	Aadd(aHeader,{"R$ Unit"     , "ZAD_VUNIT"   ,"@E 999999999.99",12,2,"ExecBlock('FUNITE',.f.,.f.)","","N","ZAD"}) //03
	Aadd(aHeader,{"R$ Total"    , "ZAD_VTOT"    ,"@E 999999999.99",12,2,".F.","","N","ZAD"}) //03
	Aadd(aHeader,{"Qtde Ap."    , "ZAD_AQUANT"  ,"@E 999999"      ,6,0 ,".T.","","N","ZAD"}) //03
	Aadd(aHeader,{"R$ Unit Ap." , "ZAD_AVUNIT"  ,"@E 999999999.99",12,2,"ExecBlock('FUNITE',.f.,.f.)","","N","ZAD"}) //03
	Aadd(aHeader,{"R$ Total Ap.", "ZAD_AVTOT"   ,"@E 999999999.99",12,2,".F.","","N","ZAD"}) //03
Else                 
    DbSelectArea("ZA2")
	Aadd(aHeader,{"Item"        , "ZA2_ITEM",    "@!"             ,04,0,".F.","","C","ZA2"}) //03
	Aadd(aHeader,{"Controle"    , "ZA2_CODCON"  ,"@!"             ,02,0,".T.","","C","ZA2"}) //03
	Aadd(aHeader,{"Descricao"   , "ZA2_DESCRI"  ,Repli("!",30)    ,30,0,".F.","","C","ZA2"}) //03
	Aadd(aHeader,{"Qtde"        , "ZA2_QUANT"   ,"@E 999999"      ,6,0 ,".T.","","N","ZA2"}) //03
	Aadd(aHeader,{"R$ Unit"     , "ZA2_VUNIT"   ,"@E 999999999.99",12,2,"ExecBlock('FUNITE',.f.,.f.)","","N","ZA2"}) //03
	Aadd(aHeader,{"R$ Total"    , "ZA2_VTOT"    ,"@E 999999999.99",12,2,".F.","","N","ZA2"}) //03
	Aadd(aHeader,{"Qtde Ap."    , "ZA2_AQUANT"  ,"@E 999999"      ,6,0 ,".T.","","N","ZA2"}) //03
	Aadd(aHeader,{"R$ Unit Ap." , "ZA2_AVUNIT"  ,"@E 999999999.99",12,2,"ExecBlock('FUNITE',.f.,.f.)","","N","ZA2"}) //03
	Aadd(aHeader,{"R$ Total Ap.", "ZA2_AVTOT"   ,"@E 999999999.99",12,2,".F.","","N","ZA2"}) //03

Endif
	
Define MsDialog oDialog Title _cTitle From 010,030 To 550,860 Pixel 

@ 013,007 To 125,410 Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE
@ 027,010 Say "Numero :" Size 030,8 Object oNum
@ 027,032 Get _cDoc Picture "@!" When(.F.) Size 035,10 Object oDoc            

@ 027,80 Say "Tipo :" Size 30,8 Object oTP

If _cpar == 3                      
	@ 025,095 MSCOMBOBOX oCombo1 VAR _cTipon ITEMS _aTipon SIZE 185 ,10 OF oDialog PIXEL VALID (fNumber())
Else

   If Len(alltrim(_cTipon)) > 45
      @ 020,100 say  _cTipon SIZE 180,20 object oTipon
      oTipon:Setfont(oFont12)                         
   
   Else
      @ 027,100 say  _cTipon SIZE 180,10 object oTipon
      oTipon:Setfont(oFont12)                         
   Endif   

Endif

@ 027,285 Say "Data:" Size 25,8 object oDt                                
@ 025,305 Get _dData Picture "99/99/9999" When .F. Size 35,8 Object oData            
@ 027,350 Say "Hora:" Size 30,8 object oHr            
@ 025,370 Get _cHora Picture "99:99" When .F. Size 35,8 Object oHora              

@ 040,10 Say "Conta Contabil:" Size 050,8 object oConta
@ 038,50 Get _cConta  Size 55,8 F3 "CT1" When(cPar01 == 6 .or. cPar01 == 8) Valid fConta() object ocConta
@ 038,108 Get _cDesCon Picture "@!" When .F. Size 105,8 Object oDesCont            

@ 040,225 Say "Centro Custo:" Size 050,8 object oCentro
@ 038,260 Get _cCentro  Size 15,8 F3 "CTT" When(_cPar == 3 .Or. cPar01 == 8) Valid fCC() object ocCentro       
@ 038,305 Get _cDesCC Picture "@!" When .F. Size 100,8 Object oDesCC            

@ 053,010 Say "Data Inicio:" Size 030,8 object oDatai           
If _cpar == 3 .Or. cPar01 == 8                      
   @ 051,040 Get _dDataI Picture "99/99/99" SIZE 35,10 Valid fDataI() object odDatai 
Else
   @ 053,040 say  Dtoc(_dDataI) Picture "@!" SIZE 45,10 object odDatai 
   odDatai :Setfont(oFont12)                         
Endif

@ 053,100 Say "Data Termino:" Size 040,8 object oDataF           
If _cpar == 3 .Or. cPar01 == 8                     
	   @ 051,145 Get _dDataf Picture "99/99/99" SIZE 35,10 Valid fDataF() object odDataf 
Else
   @ 053,135 Say  Dtoc(_dDataf) Picture "@!" SIZE 45,10 object odDataf 
   odDataf :Setfont(oFont12)                            

Endif

@ 053,205 Say OemToAnsi("Responsável:") Size 35,8 object oResp                                
@ 051,245 Get _cResp Picture "@!" F3 "QAA" When(_cPar == 3) Size 40,8 Valid fResp() Object ocResp           
@ 051,290 Get _cDesRes Picture "@!" When (.F.) Size 115,8 Object ocDesRes             

@ 065,010 Say "Aprovado:" Size 30,8 Object oAPv
@ 065,038 say  _cAprova SIZE 25,8 object oAprova
 oAprova:Setfont(oFont12)                         

@ 065,068 Say "O.S. Complem.:" Size 50,8 Object oOS
If _cpar == 3                      
   @ 065,105 say  Iif(Subs(_cOSComp,1,1)=="S","SIM","NAO") SIZE 25,8 object oOSComp
Else
   @ 065,105 say  Iif(Subs(_cOSComp,1,1)=="S","SIM","NAO") SIZE 25,8 object oOSComp
Endif
 oOSComp:Setfont(oFont12)                         

@ 065,135 Say "O.S.Encer.:" Size 35,8 Object oEnce
If cPar01 == 6                      
   @ 065,165 COMBOBOX _cEncera ITEMS _aAprova SIZE 25,8 object oEncerra
Else
   @ 065,165 say  _cEncera SIZE 25,8 object oEncera
   oEncera:Setfont(oFont12)                         
Endif

//*****************************************************
@ 065,205 Say OemToAnsi("Cliente:") Size 35,8 object oCliente
@ 038,50 Get _cConta  Size 55,8 F3 "CT1" When(cPar01 == 6 .or. cPar01 == 8) Valid fConta() object ocConta

@ 063,230 Get _cCli Picture "@!" F3 "SA1" When(cPar01 == 6 .or. cPar01 == 8 .or. cPar01 == 3)  Size 30,8 Valid fCli() Object ocCli           
@ 063,265 Get _cLoja    Size 10,8  Picture "@!" When(cPar01 == 6 .or. cPar01 == 8 .or. cPar01 == 3)      Valid fCli() Object oLoja
@ 063,290 Get _cNomCli Picture "@!" When (.F.) Size 115,8 Object ocNomCli             

///**************************************************************  
@ 187,006 Say OemToAnsi("Descrição do Serviço") Size 060,8 object oDS
@ 197, 006 GET oDescSe VAR _cDescSe MEMO When(_cPar == 3 .Or. _lApOS .Or. _lAlt) SIZE 400,25 PIXEL OF oDialog

@ 080,200 Say "COTADO" Color CLR_BLUE Size 50,8 Object oEst    
 oEST:Setfont(oFont12)                         

@ 080,340 Say "APROVADO" Color CLR_BLUE Size 50,8 Object oApro    
 oApro:Setfont(oFont12)                         
 
@ 087,008 TO 175,410 MULTILINE MODIFY DELETE Valid Totais() OBJECT oMultiline

If cPar01 <> 3 .And. cPar01 <> 5 .And. cPar01 <> 6 .And. cPar01 <> 8 
   oMultiline:Disable()
Endif   

@ 233,005 Say OemToAnsi("Vlr Tot Cotado Mat:") Size 055,8 object oTValEm
@ 231,060 Get _nTVlrEm Picture "9,999,999,999.99" When(.F.) Size 050,8 Object onTVlrEm

@ 243,005 Say OemToAnsi("Vlr Tot Cotado M.O.:") Size 055,8 object oTValEo
@ 241,060 Get _nTVlrEo Picture "9,999,999,999.99" When(.F.) Size 050,8 Object onTVlrEo

@ 233,125 Say OemToAnsi("Vlr Tot Aprovado Mat:") Size 055,8 object oTValAm
@ 231,180 Get _nTVlrAm Picture "9,999,999,999.99" When(.F.) Size 050,8 Object onTVlrAm

@ 243,125 Say OemToAnsi("Vlr Tot Aprovado M.O.:") Size 057,8 object oTValAo
@ 241,180 Get _nTVlrAo Picture "9,999,999,999.99" When(.F.) Size 050,8 Object onTVlrAo

@ 233,300 Say OemToAnsi("Vlr Tot Negociado:") Size 055,8 object oTValNe
@ 231,350 Get _nTVlrNe Picture "9,999,999,999.99" When(cPar01 == 6) Size 050,8 Object onTVlrNe

If len(alltrim(_cUser)) > 15
   @ 257,010 Say _cUser Object oUser             
   oUser:Setfont(oFont12)                      
Endif   

@ 257,210 Say OemToAnsi("Ramal:")   Size 030,8 object oRama                                        
@ 255,230 Get _cRamal Picture "@!" When(_cPar == 3) Size 20,8 valid fRamal() Object oRamal          

@ 250,285 BMPBUTTON TYPE 01 ACTION fGrvOrd()
@ 250,350 BMPBUTTON TYPE 02 ACTION fEnd() 

Activate MsDialog oDialog Center Valid fDialog() //Init on totais()
SZR->(DbCloseArea())
If _cPar == 2
   TMP->(DbCloseArea())                  
Endif   

Return           

User Function FdOS()
Local _lOK := .F.

	  SX5->(Dbgotop())       
	  SX5->(DbSetOrder(1)) //filial+cod
	  SX5->(DbSeek(xFilial("SX5")+"ZL")) //tabelas de almoxarifados
	  While SX5->(!Eof()) 
	   	  If SX5->X5_TABELA  == "ZL"  //.AND. Val(SX5->X5_CHAVE) > _cChave
	         If M->ZA2_CODCON$SX5->X5_CHAVE //) == M->B1_LOCPAD //Verifica se o almox existe 
	            _lOK := .T.
	            Exit //
	         Endif                       
		  Endif  
	      SX5->(Dbskip())
	  Enddo
  	  If !_lOK
         Msgbox("Atencao Codigo de Controle NÃO EXISTE Verifique","Atencao","ALERT" )  
         M->ZA2_CODCON := "  " //Limpa o conteudo 
         Return(" ")       
      Endif       

Return(SX5->X5_DESCRI)

User Function FUnitE()

   Local nQtde    := aCols[n,4]
   Local nVlru    := aCols[n,5]
   
   Local nQtdea    := aCols[n,7]
   Local nVlrua    := aCols[n,8]

   If aCols[n,6] <>  (nQtde * nVlru) .Or. aCols[n,9] <> (nQtdea * nVlrua)   
      aCols[n,6] := nQtde * nVlru
      aCols[n,9] := nQtdea * nVlrua   
      _lMostra := .T.
      Totais()  // Atualiza totais no rodape
   Endif

   If aCols[n,6] > 0 .Or.  aCols[n,9] > 0
      _lMostra := .T.
      Totais()  // Atualiza totais no rodape
   Endif   
   ObjectMethod(oMultiline, "Refresh()") //Total Aprovdo MO                            
   dlgRefresh(oDialog)    
Return(.T.)


Static Function Totais()

   Local nTamanho          := Len(aCols)
   Local nQuante:=nQuanta   := 0 
   Local nVlre:=nVlra       := 0
   Local nTotvlre:=nTotvlra := 0

 
   For i:=1 To nTamanho
      nVlre := 0
      nVlra := 0
      nQuante := aCols[i,4] //qtde estimada
      nQuanta := aCols[i,7] //qtde aprovada     
      If nQuante <> 0
         nVlre    := aCols[i,4] * aCols[i,5]
         nTotvlre += nVlre
      Endif

      If nQuanta <> 0
         nVlra    := aCols[i,7] * aCols[i,8]
         nTotvlra += nVlra
      Endif

   Next i   

_nTVlrEm := nTotvlre 
_nTVlrEo := nTotvlre 

_nTVlrAm := nTotvlra 
_nTVlrAo := nTotvlra 

If _cPar <> 2 .Or.  _lMostra // .Or. _lApos .Or. _lAlt //.And. _cPar <> 8 .And. _cPar <> 6  
   ObjectMethod(onTVlrEm, "Refresh()") //Total estimado mat
   ObjectMethod(onTVlrEo, "Refresh()") //Total estimado MO                            

   ObjectMethod(onTVlrAm, "Refresh()") //Total Aprovado mat
   ObjectMethod(onTVlrAo, "Refresh()") //Total Aprovdo MO                            
Endif  

   
Return(.T.)


Static Function fNumber()

   If _ctipon$"A/F"
	   _cCombo := "DF"
   ElseIf _ctipon$"M"
	   _cCombo := "MM"
   Else
	   _cCombo := "IM"
   Endif
   
   //_cCombo := IIf(_ctipon$"A/F","DF","IM")
   
   ZA1->(DbSetOrder(1))
   ZA1->(Dbseek(xFilial("ZA1")+_cCombo))
   While ZA1->(!Eof()) .And. Subs(ZA1->ZA1_NUM,1,2) ==  Subs(_cCombo,1,2)
      _cCombo := ZA1->ZA1_NUM
      ZA1->(Dbskip())
   Enddo
   _cDoc := Subs(_cCombo,1,2) +  StrZero(Val(Subs(_cCombo,3,4))+1,4)
   oDoc:Refresh()
Return(.t.)

Static Function fDataI()
Local _lRet := .T.

If Empty(_dDataI) //.or. Empty(_dDataf)
   Msgbox("Data Inicial em Branco, Verifique !!!" ,"Atencao","ALERT" )        
   _lRet := .F.
Endif

Return(_lRet)

Static Function fDataF()
Local _lRet := .T.

If Empty(_dDataF) //.or. Empty(_dDataf)
   Msgbox("Data Final em Branco, Verifique !!!" ,"Atencao","ALERT" )        
   _lRet := .F.
Endif

If  _dDataf < _dDataI
   Msgbox("Data Final Menor que Data Inicial, Verifique !!!" ,"Atencao","ALERT" )        
   _lRet := .F.
Endif


Return(_lRet)

    
Static Function  fValorma()    
Local _lRet := .T.
                      
If _nVlrEMa == 0
   Msgbox("Valor Estimado nao Pode ser Zero, Verifique !!!" ,"Atencao","ALERT" )        
   _lRet := .F.
   onVlrEma:SetFocus()
Endif


If _nVlrAMa > _nVlrEMa   //_nVlrApr > _nVlrEst
   Msgbox("Valor Aprovado nao Pode Maior que Valor Estimado, Verifique !!!" ,"Atencao","ALERT" )        
   _lRet := .F.
   onVlrAma:SetFocus()
Endif
fTotal() //totaliza os valores de materiais e mao de obra
Return(_lRet)

Static Function  fValormo()    
Local _lRet := .T.


If _nVlrAMO > _nVlrEMO  //_nVlrAMa > _nVlrEMa   //_nVlrApr > _nVlrEst
   Msgbox("Valor Aprovado nao Pode Maior que Valor Mao de Obra, Verifique !!!" ,"Atencao","ALERT" )        
   _lRet := .F.
   onVlrAmo:SetFocus()
Endif
fTotal() //totaliza os valores de materiais e mao de obra
Return(_lRet)

Static Function  fcValorm()    
Local _lRet := .T.

//If _lcos
                                    
	If _ncVlrEM == 0
	   Msgbox("Valor Estimado dos Materiais nao Pode ser Zero, Verifique !!!" ,"Atencao","ALERT" )        
	   _lRet := .F.
	   oncVlrEm:SetFocus()
	Endif

	If _ncVlrAM > _ncVlrEM   //_nVlrApr > _nVlrEst
	   Msgbox("Valor Estimado Aprovado nao Pode Maior que Valor Estipulado, Verifique !!!" ,"Atencao","ALERT" )        
	   _lRet := .F.
	   oncVlram:SetFocus()
	Endif
fTotal() //totaliza os valores de materiais e mao de obra
Return(_lRet)

Static Function  fcValoro()    
Local _lRet := .T.

	
	If _ncVlrAO > _ncVlrEO  //_nVlrAMa > _nVlrEMa   //_nVlrApr > _nVlrEst
	   Msgbox("Valor Aprovado da Mao de Obra nao Pode Maior que Valor Estimado, Verifique !!!" ,"Atencao","ALERT" )        
	   _lRet := .F.
	   oncVlrAo:SetFocus()
	Endif
fTotal() //totaliza os valores de materiais e mao de obra
Return(_lRet)	

Static Function fTotal()

onTVlrEm:Refresh()
onTVlrEo:Refresh()
onTVlrAm:Refresh()
onTVlrAo:Refresh()

Return

Static Function fResp()
Local _lRet := .T.

QAA->(DbSetOrder(1)) //filial+cod
QAA->(DbSeek(xFilial("QAA") + _cResp))
If QAA->(Found())
   _cDesRes :=	QAA->QAA_NOME 
   ObjectMethod(ocDesRes,"Refresh()")
Else
   Msgbox("Responsavel nao Cadastrada, Verifique !!!" ,"Atencao","ALERT" )        
    _lRet := .F.
Endif

Return(_lRet)     
                

Static Function fCC()
Local _lRet := .T.

CTT->(DbSetOrder(1)) //filial+cod
CTT->(DbSeek(xFilial("CTT") + _cCentro))
If CTT->(Found())
   _cDesCC :=	CTT->CTT_DESC01 
   ObjectMethod(oDesCC,"Refresh()")
Else
   Msgbox("Centro de Custo nao Cadastrada, Verifique !!!" ,"Atencao","ALERT" )        
    _lRet := .F.
Endif

Return(_lRet)     


Static Function fConta()
Local _lRet := .T.

If !Empty(_cConta)

	CT1->(DbSetOrder(1)) //filial+cod
	CT1->(DbSeek(xFilial("CT1") + _cConta))
	If CT1->(Found())
	   _cDesCon :=	CT1->CT1_DESC01 
	   ObjectMethod(oDesCont,"Refresh()")
	Else
	   Msgbox("Conta Contabil nao Cadastrada, Verifique !!!" ,"Atencao","ALERT" )        
	    _lRet := .F.
	Endif
Endif
	
Return(_lRet)     


Return()

Static Function fRamal()

If Empty(_cRamal) .Or. Len(Alltrim(_cRamal)) <> 4
   Msgbox("Favor Preencher o Ramal do Solicitante Corretamente, Verifique !!!" ,"Atencao","ALERT" )     
   Return(.F.)
Endif

Return(.T.)

Static Function fQuery()
Local cQuery
Local cQuery1

   cQuery := "SELECT CONVERT(TEXT,CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),ZA1_DESC))) AS 'DESC',ZA1.R_E_C_N_O_ AS 'ZA1_RECNO',* "
   cQuery += " FROM " +  RetSqlName( 'ZA1' ) +" ZA1, " +  RetSqlName( 'ZA2' ) +" ZA2, " +   RetSqlName( 'QAA' ) +" QAA,"  +   RetSqlName( 'CT1' ) +" CT1, "  +   RetSqlName( 'CTT' ) +" CTT "
   cQuery += " WHERE ZA1.ZA1_FILIAL = '" + xFilial("ZA1")+ "'"    
   cQuery += " AND ZA2.ZA2_FILIAL = '" + xFilial("ZA2")+ "'" 
   cQuery += " AND QAA.QAA_FILIAL = '" + xFilial("QAA")+ "'"    
   cQuery += " AND CT1.CT1_FILIAL = '" + xFilial("CT1")+ "'"       
   cQuery += " AND CTT.CTT_FILIAL = '" + xFilial("CTT")+ "'"          
   cQuery += " AND ZA1.ZA1_NUM = '" + ZA1->ZA1_NUM +"' " 
   cQuery += " AND ZA1.ZA1_CC  = CTT.CTT_CUSTO "
   cQuery += " AND ZA1.ZA1_NUM *= ZA2.ZA2_NUM "
   cQuery += " AND ZA1.ZA1_RESP *= QAA.QAA_MAT "   
   cQuery += " AND ZA1.ZA1_CONTA *= CT1.CT1_CONTA "      
   cQuery += " AND ZA1. D_E_L_E_T_ = ' ' AND ZA2. D_E_L_E_T_ = ' ' "
   cQuery += " AND CTT. D_E_L_E_T_ = ' ' AND QAA. D_E_L_E_T_ = ' ' AND CT1. D_E_L_E_T_ = ' '"               
   cQuery += " ORDER BY ZA1.ZA1_FILIAL,ZA1.ZA1_NUM ASC"    

   MemoWrit('C:\TEMP\EST081B.SQL',cQuery)
   //TCQuery Abre uma workarea com o resultado da query
   TCQUERY cQuery NEW ALIAS "TMP"      
   TcSetField("TMP","ZA1_DATA" ,"D")  // Muda a data de string para date    
   TcSetField("TMP","ZA1_CDATA","D")  // Muda a data de string para date    
   TcSetField("TMP","ZA1_DTINI","D")  // Muda a data de string para date    
   TcSetField("TMP","ZA1_DTFIM","D")  // Muda a data de string para date    
   TcSetField("TMP","ZA2_DATA" ,"D")  // Muda a data de string para date    


TMP->(DBGOTOP())
  
Return

Static Function fMostra()
Local i
Local _nLinha
Local _aTipon := {"A=Ativo Diferido - Gastos Pre-Operacionais",;
             OemToAnsi("B=Ferramental Imobilizado"),;
             OemToAnsi("C=Compra de Material - Construções"),;
			 OemToAnsi("D=Custo Ferramental Fundição / Alumínio"),;
             OemToAnsi("F=Ferramental - Faturado p/ cliente"),;
             OemToAnsi("I=Instalações de Novas Máquinas"),;             
             OemToAnsi("P=Projeto de Melhoria,Ampliação Produção, Adequação da Linha, Reforma"),;
             OemToAnsi("M=Reforma de Bens de Terceiros")  }

If Empty(TMP->ZA1_NUM)//Verifica se não encontrou a solicitação de nota na visualização
   Msgbox(OemToAnsi("Nao Existe Nenhuma Movimentação para a O.S. Selecionada, Verifique !!!1") ,"Atencao","ALERT" )     
//   TMP->(DbCloseArea())
//   _lFlag := .F.
   Return
Endif 

//Atribui variaveis para consulta
_cDoc   := TMP->ZA1_NUM
_ctipon := IIf(TMP->ZA1_TIPO$"A",_aTipon[1],IIf(TMP->ZA1_TIPO$"C",_aTipon[2],IIf(TMP->ZA1_TIPO$"F",_aTipon[3],IIf(TMP->ZA1_TIPO$"I",_aTipon[4],_aTipon[5]))))  //Cliente         
_cConta	:= TMP->ZA1_CONTA 
CT1->(DbSetOrder(1)) //filial+cod
CT1->(DbSeek(xFilial("CT1") + _cConta))
If CT1->(Found())
   _cDesCon :=	CT1->CT1_DESC01 
Endif                     

If _lApOS  //Aprovação de valor de OS
   _cAprova:= "SIM"
Else
   _cAprova:= Iif(TMP->ZA1_OSLIB=="S","SIM","NAO") 
Endif
_cOSComp:= TMP->ZA1_OSCOMP
_cResp  := TMP->ZA1_RESP  //IIf(_ctipon$"Normal","N",IIf(_ctipon$"Dev.Compra","D","B"))  //Cliente         
_dData  := TMP->ZA1_DATA   
_cCli   := TMP->ZA1_CLIENT
_cLoja  := TMP->ZA1_LOJA
SA1->(DbSeek(xFilial("SA1")+_cCli+_cLoja ))                
If SA1->(Found())            
   _cNomCli := SA1->A1_NOME
Endif

_cCentro:= TMP->ZA1_CC     
CTT->(DbSetOrder(1)) //filial+cod
CTT->(DbSeek(xFilial("CTT") + _cCentro))
If CTT->(Found())
   _cDesCC :=	CTT->CTT_DESC01 
Endif

_cHora  := TMP->ZA1_HORA
_cResp  := TMP->ZA1_RESP    
QAA->(DbSetOrder(1)) //filial+cod
QAA->(DbSeek(xFilial("QAA") + _cResp))
If QAA->(Found())
   _cDesRes :=	QAA->QAA_NOME 
Endif
_dDataI := TMP->ZA1_DTINI   
_dDataf := TMP->ZA1_DTFIM    
// _cDescSe:= lower(TMP->DESC) 	//memo	            
ZA1->(Dbgoto(TMP->ZA1_RECNO))         
_nLinha = MlCount(Lower(Alltrim(ZA1->ZA1_DESC)))
for i:= 1 to _nLinha
    _cDescSe +=  OemToAnsi(MemoLine(ZA1->ZA1_DESC,90,i))
next i 

_dcData  := TMP->ZA1_CDATA   
_cUser   := TMP->ZA1_USER  
_cRamal  := TMP->ZA1_RAMAL   
_nTVlrNe  := TMP->ZA1_VLNEGO
_ccAprov:= Iif(TMP->ZA1_COSLIB=="S","SIM","NAO") 
_cEncera := Iif(TMP->ZA1_ENCERA=="S","SIM","NAO") 
		
Acols := {}
If !_lCOS
   While TMP->(!EOF())
      Aadd(Acols,{TMP->ZA2_ITEM,TMP->ZA2_CODCON,TMP->ZA2_DESCRI,TMP->ZA2_QUANT,TMP->ZA2_VUNIT,TMP->ZA2_VTOT,TMP->ZA2_AQUANT,TMP->ZA2_AVUNIT,TMP->ZA2_AVTOT,.F.})  
      TMP->(Dbskip())
   Enddo
   Totais()
Else

ZAD->(DbsetOrder(1))//Filial + numero + item
If ZAD->(Dbseek(xFilial("ZAD")+TMP->ZA1_NUM)) //filial + num OS + Item OS
   	While !ZAD->(EOF()) .And. TMP->ZA1_NUM == ZAD->ZAD_NUM
   		Aadd(aCols,{ZAD->ZAD_ITEM,ZAD->ZAD_CODCON,ZAD->ZAD_DESCRI,ZAD->ZAD_QUANT,ZAD->ZAD_VUNIT, ZAD->ZAD_VTOT,ZAD->ZAD_AQUANT, ZAD->ZAD_AVUNIT, ZAD->ZAD_AVTOT,.F.})
      	ZAD->(Dbskip())
   	Enddo   
Endif
   
Endif    
//TMP->(DbCloseArea())

Return


Static Function fDialog()
   DlgRefresh(oDialog)
   If Empty(_cTipon) .Or. Empty(_cDoc) .or. Empty(_cRamal) 

      lDialog := .F.  
   Else
      lDialog := .T.                        
   Endif
Return(lDialog)


Static Function fEnd() 

   If _cPar == 3 //Opcao incluir
      RollBackSx8() //Volta a numeração da Ordem de Liberação
   Endif   
   Close(oDialog) 
Return


Static Function fGrvOrd()
Local _lGravou := .F.  
local x          
Local _nx := 1
   
   If Empty(_cRamal) .Or. Len(Alltrim(_cRamal)) <> 4
      Msgbox("Favor Preencher o Ramal do Solicitante Corretamente, Verifique !!!" ,"Atencao","ALERT" )     
      Return(.F.)
   Endif

   If Empty(_cDescSe)
      Msgbox("Favor Preencher a Descricao do Servico, Verifique !!!" ,"Atencao","ALERT" )     
      Return(.F.)
   Endif
   
   for xA:=1 to len(acols)
		If ( empty(aCols[xA][1]) .or. empty(aCols[xA][2]) .or. empty(aCols[xA][3]))  
			alert('Campos obrigatórios não preenchidos nos itens!')
			return .f.
		endif
   next
   
   
   If _cPar == 3 //incluir
	  //Begin Transaction                   
             
      If ZA1->(DbSeek(xFilial("ZA1")+_cDoc),Found())
  	     Msgbox("Solicitação já foi Gravada com Este Numero, Verifique !!!" ,"Atencao","ALERT" )     	   
	  Else
		 Reclock("ZA1",.T.)
		    ZA1->ZA1_FILIAL  := xFilial("ZA1")
			ZA1->ZA1_NUM     := _cDoc         
  	        ZA1->ZA1_TIPO    := _ctipon //$"Normal","N",IIf(_ctipon$"Dev.Compra","D","B"))  //Cliente         			
			ZA1->ZA1_CONTA   := _cConta
			ZA1->ZA1_DCONTA  := _cDesCon
    	    ZA1->ZA1_OSCOMP  := _cOSComp
 	        ZA1->ZA1_RESP    := _cResp //IIf(_ctipon$"Normal","N",IIf(_ctipon$"Dev.Compra","D","B"))  //Cliente         
  		    ZA1->ZA1_DATA    := Date() 	        
  		    ZA1->ZA1_CC      := _cCentro
 	        ZA1->ZA1_HORA    := time()   
 	 		ZA1->ZA1_RESP    := _cResp
		    ZA1->ZA1_DTINI   := _dDataI
	        ZA1->ZA1_DTFIM   := _dDataf 
		    ZA1->ZA1_DESC    := _cDescSe 	//memo
		    ZA1->ZA1_CLIENT  := _cCli
		    ZA1->ZA1_LOJA    := _cLoja

		    ZA1->ZA1_VLESMA  := _nVlrEMa
			ZA1->ZA1_VLESMO  := _nVlrEMO 
									
			ZA1->ZA1_USER    := __cUserId
			ZA1->ZA1_RAMAL   := _cRamal		     
	     MsUnlock("ZA1")     
      	     // End Transaction   	  
         _nx :=1     	     
         For x:= 1 to Len(Acols)        
           //nao pega quando a linha esta deletada
            
               If ZA2->(DbSeek(xFilial("ZA2")+_cDoc+Acols[x][1]))
                  Reclock("ZA2",.F.)   
                     ZA2->(DbDelete())
                  MsUnlock("ZA2")                                                    
               Endif
               
               If !Acols[x][len(aHeader)+1] .And. !Empty(Acols[x][2]) .And. !Empty(Acols[x][3]) .And. !Empty(Acols[x][4])     
                  Reclock("ZA2",.T.)   
                  ZA2->ZA2_FILIAL  := xFilial("ZA2")
			      ZA2->ZA2_NUM     := _cDoc            
 	              ZA2->ZA2_ITEM    := Acols[x][1]
  		          ZA2->ZA2_CODCON  := Acols[x][2]  	              
  		          ZA2->ZA2_QUANT   := Acols[x][4] 
 	  			  ZA2->ZA2_DESCRI  := Acols[x][3]
    	          ZA2->ZA2_VUNIT   := Acols[x][5]
    	          ZA2->ZA2_VTOT    := Acols[x][6]    	          
  		          ZA2->ZA2_AQUANT   := Acols[x][7] 
    	          ZA2->ZA2_AVUNIT   := Acols[x][8]
    	          ZA2->ZA2_AVTOT    := Acols[x][9]    	          
                  MsUnlock("ZA2")                                                    
                  _nx+=1
               Endif    
         Next x
              	     
     Endif
      
   Else
      
      IF _lApOS //atualiza a conta contabil e vlr aprovado e o.s. aprovada
   		 Reclock("ZA1",.F.)
			ZA1->ZA1_OSLIB   := "S" //coloca como aprovada a O.S. principal.
			ZA1->ZA1_CONTA   := _cConta 
			ZA1->ZA1_DCONTA  := _cDesCon			
			ZA1->ZA1_VLAPMO  := _nVlrAMO 
			ZA1->ZA1_VLAPMA  := _nTVlrAm
		    ZA1->ZA1_DESC    := _cDescSe 	//memo	            			
		    ZA1->ZA1_ENCERA  := _cEncera   // OS ENCERADA SIM OU NAO
			ZA1->ZA1_VLNEGO  := _nTVlrNe		    
           
            // Aprocaçao de valores
            If _cOSComp$"S"
			   ZA1->ZA1_COSLIB  := "S" //_ccAprov
			Endif
	     MsUnlock("ZA1")     
         _nx :=1     	     
         For x:= 1 to Len(Acols)        
           //nao pega quando a linha esta deletada
            
               If ZA2->(DbSeek(xFilial("ZA2")+_cDoc+Acols[x][1]))
                  Reclock("ZA2",.F.)   
                     ZA2->(DbDelete())
                  MsUnlock("ZA2")                                                    
               Endif
               
               If !Acols[x][len(aHeader)+1] .And. !Empty(Acols[x][2]) .And. !Empty(Acols[x][3]) .And. !Empty(Acols[x][4])     
                  Reclock("ZA2",.T.)   
                  ZA2->ZA2_FILIAL  := xFilial("ZA2")
			      ZA2->ZA2_NUM     := _cDoc            
 	              ZA2->ZA2_ITEM    := Strzero(_nx,4)			   
  		          ZA2->ZA2_CODCON  := Acols[x][2]  	              
  		          ZA2->ZA2_QUANT   := Acols[x][4] 
 	  			  ZA2->ZA2_DESCRI  := Acols[x][3]
    	          ZA2->ZA2_VUNIT   := Acols[x][5]
    	          ZA2->ZA2_VTOT    := Acols[x][6]    	          
  		          ZA2->ZA2_AQUANT   := Acols[x][7] 
    	          ZA2->ZA2_AVUNIT   := Acols[x][8]
    	          ZA2->ZA2_AVTOT    := Acols[x][9]    	          
                  MsUnlock("ZA2")                                                    
                  _nx+=1
               Endif    
         Next x
	     
      Endif
      
      If _lCOS // Atualiza OS complementar ZA1->ZA1_OSLIB
         If ZA1->ZA1_OSCOMP$"N" // nao permite regravar o valor da os complementar
   		    Reclock("ZA1",.F.)
   		   	ZA1->ZA1_VLCEMO  := _nTVlrEm
			ZA1->ZA1_VLCEMA  := _nTVlrEo
			ZA1->ZA1_CDATA   :=	Date() //Iif (ValType(_dcData)=="C",CtoD(_dcData),_dcData)
   	        ZA1->ZA1_OSCOMP  := "S"  //OS complementar sim			
	        MsUnlock("ZA1")     
	     Endif                  
         _nx :=1     	     

         ZAD->(dbsetorder(1))//ZAD_FILIAL+ZAD_NUM+ZAD_ITEM
                  
         For x:= 1 to Len(Acols)        
               
              
              If !Acols[x][len(aHeader)+1] 
                  
                  
                  IF ZAD->(dbSeek(xFilial("ZAD")+_cDoc + aCols[x][1] ))

		              Reclock("ZAD",.F.)   
	  		    	      ZAD->ZAD_CODCON  := Acols[x][2]  	              
	  		        	  ZAD->ZAD_QUANT   := Acols[x][4] 
	 	  				  ZAD->ZAD_DESCRI  := Acols[x][3]
		    	          ZAD->ZAD_VUNIT   := Acols[x][5]
		    	          ZAD->ZAD_VTOT    := Acols[x][6]    	          
	  			          ZAD->ZAD_AQUANT  := Acols[x][7] 
	    		          ZAD->ZAD_AVUNIT  := Acols[x][8]
	    	    	      ZAD->ZAD_AVTOT   := Acols[x][9]    	          
	                  MsUnlock("ZAD")                                                    

	          	  Else
	                  Reclock("ZAD",.T.)   
    	        	      ZAD->ZAD_FILIAL  := xFilial("ZAD")
					      ZAD->ZAD_NUM     := _cDoc            
 	    	    	      ZAD->ZAD_ITEM    := Acols[x][1]
 		            	  ZAD->ZAD_DATA    := dDatabase
		  		          ZAD->ZAD_CODCON  := Acols[x][2]  	              
  			        	  ZAD->ZAD_QUANT   := Acols[x][4] 
 	  					  ZAD->ZAD_DESCRI  := Acols[x][3]
    	    		      ZAD->ZAD_VUNIT   := Acols[x][5]
    	    	    	  ZAD->ZAD_VTOT    := Acols[x][6]    	          
	  			          ZAD->ZAD_AQUANT  := Acols[x][7] 
    			          ZAD->ZAD_AVUNIT  := Acols[x][8]
	    		          ZAD->ZAD_AVTOT   := Acols[x][9]    	          
            	      MsUnlock("ZAD")                                                    
                  _nx+=1
	              Endif    
	          Else 
	          	IF ZAD->(dbSeek(xFilial("ZAD")+_cDoc + aCols[x][1] ))
		              Reclock("ZAD",.F.)   
  			    	      ZAD->(dbdelete())
        	          MsUnlock("ZAD")                                                    
		         Endif	          
	          endif
         Next x
	Endif
     if _lExc //permite excluir a solicitação  
         //Deleta o cabecalho da solicitação de nota fiscal
         TMP->(Dbgotop()) //Posiciona registro para excluir
         ZA1->(Dbgoto(TMP->ZA1_RECNO)) //Posiciona registro para excluir
         Reclock("ZA1",.F.)   
            ZA1->(DbDelete())
         MsUnlock("ZA1")                                                    

      Endif //Fim exclusao
      
      If _lAlt                
         Reclock("ZA1",.F.)         
 		    ZA1->ZA1_CONTA   := _cConta
			ZA1->ZA1_DCONTA  := _cDesCon
  		    ZA1->ZA1_CC      := _cCentro
		    ZA1->ZA1_DTINI   := _dDataI
	        ZA1->ZA1_DTFIM   := _dDataf 
		    ZA1->ZA1_CLIENT  := _cCli
		    ZA1->ZA1_LOJA    := _cLoja
		    ZA1->ZA1_DESC    := _cDescSe 	//memo
         MsUnlock("ZA1")                                                          
         _nx :=1     	              
         For x:= 1 to Len(Acols)        
           //nao pega quando a linha esta deletada
            
               If ZA2->(DbSeek(xFilial("ZA2")+_cDoc+Acols[x][1]))
                  Reclock("ZA2",.F.)   
                     ZA2->(DbDelete())
                  MsUnlock("ZA2")                                                    
               Endif
               
               If !Acols[x][len(aHeader)+1] .And. !Empty(Acols[x][2]) .And. !Empty(Acols[x][3]) .And. !Empty(Acols[x][4])     
                  Reclock("ZA2",.T.)   
                  ZA2->ZA2_FILIAL  := xFilial("ZA2")
			      ZA2->ZA2_NUM     := _cDoc            
 	              ZA2->ZA2_ITEM    := Strzero(_nx,4)			   
  		          ZA2->ZA2_CODCON  := Acols[x][2]  	              
  		          ZA2->ZA2_QUANT   := Acols[x][4] 
 	  			  ZA2->ZA2_DESCRI  := Acols[x][3]
    	          ZA2->ZA2_VUNIT   := Acols[x][5]
    	          ZA2->ZA2_VTOT    := Acols[x][6]    	          
  		          ZA2->ZA2_AQUANT   := Acols[x][7] 
    	          ZA2->ZA2_AVUNIT   := Acols[x][8]
    	          ZA2->ZA2_AVTOT    := Acols[x][9]    	          
                  MsUnlock("ZA2")                                                    
                  _nx+=1
               Endif    
         Next x
           	     
      Endif
      
   Endif   

   lDialog := .T.                           
   Close(oDialog)	                           

Return


User Function FLegSoli()       

Local aLegenda :=	{ {"BR_VERDE"    , "Aberta"  },;
  					  {"BR_VERMELHO" , "Fechada"   }}

BrwLegenda(OemToAnsi("Solicitação de Abertura de O.S. "), "Legenda", aLegenda)

Return  


Static Function fCriaCor()       

Local aLegenda :=	{ {"BR_VERDE"   , "Aberta"  },;
  					  {"BR_VERMELHO" , "Fechada"   }}

Local uRetorno := {}
Aadd(uRetorno, { 'ZA1_ENCERA = " " .OR. ZA1_ENCERA = "N"' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZA1_ENCERA = "S"', aLegenda[2][1] } )
Return(uRetorno)


Static Function fLimpa()

_cDoc   := Space(06)
_aTipon := {"N=Normal",OemToAnsi("D=Dev.Compra"),"B=Util.Fornecedor"}
_aTiFre := {"C=CIF","F=FOB"}
_aVia   := {"Aereo","Correio","Maritimo",OemToAnsi("Rodoviario")}
_cVia   := "Rodoviario"
_cCodTra:= Space(06)
_cDesTra:= Space(40)
_cTiFre := ""
_cTipon := "Normal"   
_cCliFor:= "Cliente:"
_cCond  := Space(03)
_cCli   := Space(06)
_cLoja  := Space(02) 
_cDesCli:= Space(30) 
_cTpFre := Space(10)  
_cUser  := Space(06)
_nPLiqui:= 0          
_nPBruto:= 0
_nVol   := 0
_cEsp   := "VOL"
_cMens  := Space(100) 
_cObs   := Space(100) 
_cF3    := Space(03)        
aHeader := {}        
aCols   := {}
_cTpCli := Space(01)
_nMoeda := 1
// n      := 0
_dData  := date()
_cHora  := time()   
 nMax   := 0                                                       
RestArea(_aGet)   
//Inicializa o acols
Aadd(aCols,{"01", Space(15),Space(30),0,0,0,Space(03),Space(04), Space(02), 0, 0, 0, Space(06), Space(03), Space(02),.F. })
   dbSelectArea("SX3")
   SX3->(dbSetOrder(1))
   SX3->(MsSeek("SZR"))
   While ( !SX3->(Eof()) .And. (SX3->X3_ARQUIVO == "SZR") )
    
      If ( X3USO(SX3->X3_USADO) .And.;
			!(	Trim(SX3->X3_CAMPO) == "ZR_NUM" ) 	.And.;
			Trim(SX3->X3_CAMPO) <> "ZR_EMISSAO" 	.And.;
			Trim(SX3->X3_CAMPO) <> "ZR_PEDIDO"   	.And.;			
			Trim(SX3->X3_CAMPO) <> "ZR_FILIAL" )
			dbSelectArea("SZR")
			Aadd(aHeader,{ TRIM(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT})
      Endif
      SX3->(dbSkip())
   EndDo
                                                    		
DbSelectArea("SZQ")

_cDoc       := GetSXENum("SZQ","ZQ_NUM")   // Traz o novo numero da solicitação de NF
_cUser := "Solicitante:  " + UsrFullname(__cUserId )
_cRamal   := SUBSTR(U_Nhcfg001("06"),6,4)            

ObjectMethod(oDoc,"SetText(_cdoc)")
oMultiline:oBrowse:ncolpos := 1 //Atualiza o focu para primeira posicao
//oGet:ForceRefresh()
oMultiline:Refresh()  
ObjectMethod(oCli,"Refresh()")
oTipon:Refresh()       
oTipon:SetFocus()      
oDoc:Setfont(oFont12)                      
DlgRefresh(oDialog)
ZA1->(DBGOBOTTOM())
Return
                                         

User Function fSolImp()

//colocar consulta
Processa( {|| fGera()   },"Gerando Dados para a Impressao")

Return Nil

Static Function fGera()
   cQuery := "SELECT CONVERT(TEXT,CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),ZA1_DESC))) AS 'DESC',ZA1.R_E_C_N_O_,* "
   cQuery += " FROM " +  RetSqlName( 'ZA1' ) +" ZA1, " +  RetSqlName( 'ZA2' ) +" ZA2, " +   RetSqlName( 'CT1' ) +" CT1, "  +   RetSqlName( 'CTT' ) +" CTT "
   cQuery += " WHERE ZA1.ZA1_FILIAL = '" + xFilial("ZA1")+ "'"    
   cQuery += " AND ZA2.ZA2_FILIAL = '" + xFilial("ZA2")+ "'" 
   cQuery += " AND CT1.CT1_FILIAL = '" + xFilial("CT1")+ "'"       
   cQuery += " AND CTT.CTT_FILIAL = '" + xFilial("CTT")+ "'"          
   cQuery += " AND ZA1.ZA1_NUM = '" + ZA1->ZA1_NUM +"' " 
   cQuery += " AND ZA1.ZA1_CC  = CTT.CTT_CUSTO "
   cQuery += " AND ZA1.ZA1_NUM = ZA2.ZA2_NUM "
   cQuery += " AND ZA1.ZA1_CONTA *= CT1.CT1_CONTA "      
   cQuery += " AND ZA1. D_E_L_E_T_ = ' ' AND ZA2. D_E_L_E_T_ = ' ' "
   cQuery += " AND CTT. D_E_L_E_T_ = ' ' AND CT1. D_E_L_E_T_ = ' '"               
   cQuery += " ORDER BY ZA1.ZA1_FILIAL,ZA1.ZA1_NUM ASC"    

   //MemoWrit('C:\TEMP\EST081B.SQL',cQuery)
   //TCQuery Abre uma workarea com o resultado da query
   TCQUERY cQuery NEW ALIAS "TMA"      
   TcSetField("TMA","ZA1_DATA","D")   // Muda a data de string para date    
   TcSetField("TMA","ZA1_CDATA","D")  // Muda a data de string para date    
   TcSetField("TMA","ZA1_DTINI","D")  // Muda a data de string para date    
   TcSetField("TMA","ZA1_DTFIM","D")  // Muda a data de string para date    
   TcSetField("TMA","ZA2_DATA","D")   // Muda a data de string para date    

Processa( {|| fRptDet() }, "Aguarde Imprimindo...")

Return

Static Function fRptDet()
Local oPrint
Local i 			
Local lin 			:= 500
Local _cDescSe
Local _nLinha
Local _nTotE   := 0
Local _nTotA   := 0  
Local _nGTotE  := 0
Local _nGTotA  := 0
Local _lPri    := .F.
Local _lOSComp := .F.
Local _cNumOS  := Space(06)

Local _dcData  := Ctod("  /  /  ")
Local _nVLCEMA := 0
Local _nVLCAMA := 0
Local _nVLCEMO := 0
Local _nVLCAMO := 0

_aTipon := {"A=Ativo Diferido - Gastos Pre-Operacionais",;
             OemToAnsi("C=Compra de Material - Construções"),;
             OemToAnsi("F=Ferramental - Faturado p/ cliente"),;
             OemToAnsi("I=Instalações de Novas Máquinas"),;             
             OemToAnsi("P=Projeto de Melhoria,Ampliação Produção, Adequação da Linha, Reforma")}

oPrint := TMSPrinter():New( "SOLICITACAO DE ABERTURA DE OS") 
oPrint:SetPortrait()
oPrint:Setup()
oPrint:StartPage() 		// Inicia uma nova pagina

oPrint:SayBitmap(150,1050, cStartPath+"\Whbl.bmp",340,170)
oPrint:Say(320,1050,"WHB FUNDIÇÃO S/A",oFont12B)

oPrint:Say(470,700,OemToAnsi("SOLICITAÇÃO DE ABERTURA DE OS"),oFont16) //OemToAnsi("SOLICITAÇÃO DE ABERTURA DE OS")
TMA->(Dbgotop())
_ctipon := IIf(TMA->ZA1_TIPO$"A",_aTipon[1],IIf(TMA->ZA1_TIPO$"C",_aTipon[2],IIf(TMA->ZA1_TIPO$"F",_aTipon[3],IIf(TMA->ZA1_TIPO$"I",_aTipon[4],_aTipon[5]))))  //Cliente         

	If lin > 2720
		i++
		oPrint:EndPage() 		// Finaliza a pagina
		Cabecalho(oPrint,i)  	// Funcao que monta o cabecalho
		lin := 500
	Endif
	
	lin += 90

    oPrint:Line( 450, 01900, 450, 2300 )   	// horizontal para diretoria
    oPrint:Line( 450, 1900, 550, 1900 )   	// vertical  
    oPrint:Line( 550, 1900, 550, 2300 )   	// horizontal
    oPrint:Line( 450, 02300, 550, 2300 )    // vertical
	
	oPrint:Say(400,1950,"Numero OS",oFont12)

  	oPrint:Say(470,2030,TMA->ZA1_NUM,oFont12B)	
	//Box Itens
    //oPrint:Box( 550, 1900, 450, 2300 )
   	lin += 150
	oPrint:Say(lin,350,Subs(_ctipon,3,len(_cTipon)),oFont12B)
    lin += 100                                             	
  	oPrint:Say(lin,050,OemToAnsi("Conta Contabil:"),oFont12)

  	If !Empty(TMA->ZA1_CONTA)
  	   oPrint:Say(lin,350,OemToAnsi(TMA->ZA1_CONTA),oFont12)
  	   oPrint:Say(lin,0680,OemToAnsi(TMA->CT1_DESC01),oFont12)
    Endif

	lin += 180

  	oPrint:Say(lin,050,OemToAnsi("Data Inicio:"),oFont12)
    oPrint:Say(lin,350,Dtoc(TMA->ZA1_DTINI),oFont12)  	
 	oPrint:Say(lin,1500,OemToAnsi("Previsão Término:"),oFont12)
    oPrint:Say(lin,1900,Dtoc(TMA->ZA1_DTFIM),oFont12) 	
	lin += 90

 	oPrint:Say(lin,050,OemToAnsi("Centro de Custo:"),oFont12)
 	oPrint:Say(lin,0400,OemToAnsi(Alltrim(TMA->ZA1_CC)),oFont12) 	
 	oPrint:Say(lin,0580,OemToAnsi(TMA->CTT_DESC01),oFont12) 	
 	
	lin += 100   
  	oPrint:Say(lin,050,OemToAnsi("Descrição da O.S."),oFont12B)
  	oPrint:Say(lin,1500,OemToAnsi("Data Solicitação da O.S.:"),oFont12)
  	oPrint:Say(lin,2000,Dtoc(TMA->ZA1_DATA),oFont12B)   
  	
  	ZA1->(Dbgoto(TMA->R_E_C_N_O_))         
	_nLinha = MlCount(Lower(Alltrim(ZA1->ZA1_DESC)))
                                                 
	For i:= 1 to _nLinha
		lin += 70
    	oPrint:Say(lin,050,OemToAnsi(MemoLine(ZA1->ZA1_DESC,105,i)),oFont10)
  	Next
 	
	lin += 100

    oPrint:Say(lin,050,OemToAnsi("MATERIAL"),oFont12S)		      	  
    oPrint:Say(lin,1120,OemToAnsi("VLR COTADO"+SPACE(56)+"APROVADO"),oFont12B)		
  	lin += 070
    oPrint:Say(lin,40,OemToAnsi("ITEM      CONTROLE    DESCRIÇÃO"+SPACE(54)+"QTDE                R$ UNIT.              R$ TOTAL         QTDE               R$ UNIT.                 R$ TOTAL"),oFont10B)	
   	lin += 070      
   	
    If TMA->ZA1_OSCOMP$"S"  //OS complementar sim			
   	   _lOSComp := .T.
   	   _dcData  := TMA->ZA1_CDATA
   	   _nVLCEMA := TMA->ZA1_VLCEMA
   	   _nVLCAMA := TMA->ZA1_VLCAMA            
   	   _nVLCEMO := TMA->ZA1_VLCEMO
   	   _nVLCAMO := TMA->ZA1_VLCAMO            	
   	   _cNumOS  := TMA->ZA1_NUM //numero da os
    Endif
  	
	While TMA->(!EOF())	
 	   
    	If Val(TMA->ZA2_CODCON) >= 20 .And. Val(TMA->ZA2_CODCON) <= 40 .And. !_lPri //Imprime mao de obra
         	oPrint:Say(lin,050,"SUB-TOTAL",oFont10B) 	       
         	_nGTotE := _nTotE           
         	_nGTotA := _nTotA                    
         	oPrint:Say(lin,1350,Transform(_nTotE, "@E 9,999,999,999.99"),oFont10B) 	       
     		Iif(_nTotA>0,oPrint:Say(lin,2020,Transform(_nTotA, "@E 9,999,999,999.99"),oFont10B),) 	       

      	  	lin += 170                                      
          	oPrint:Say(lin,050,OemToAnsi("MÃO DE OBRA"),oFont12S)		      	  
          	oPrint:Say(lin,1120,OemToAnsi("VLR COTADO"+SPACE(56)+"APROVADO"),oFont12B)		      	  
      	  	lin += 070
          	oPrint:Say(lin,40,OemToAnsi("ITEM      CONTROLE    DESCRIÇÃO"+SPACE(54)+"QTDE                R$ UNIT.              R$ TOTAL         QTDE               R$ UNIT.                 R$ TOTAL"),oFont10B)	
   	      	lin += 070                              
   	      	_lPri  := .T.
   	      	_nTotE := _nTotA := 0
       	Endif

 	   	oPrint:Say(lin,040,TMA->ZA2_ITEM,oFont10)
 	   	oPrint:Say(lin,230,TMA->ZA2_CODCON,oFont10)
 	   	oPrint:Say(lin,350,TMA->ZA2_DESCRI,oFont10)
       	oPrint:Say(lin,0900,Transform(TMA->ZA2_QUANT, "@E 9,999,999,999"),oFont10) 	
       	oPrint:Say(lin,1100,Transform(TMA->ZA2_VUNIT, "@E 9,999,999,999.99"),oFont10) 	
       	oPrint:Say(lin,1350,Transform(TMA->ZA2_VTOT,  "@E 9,999,999,999.99"),oFont10) 	       
       	_nTotE += TMA->ZA2_VTOT
       
   	   	If TMA->ZA2_AVUNIT > 0
          	oPrint:Say(lin,1550,Transform(TMA->ZA2_AQUANT, "@E 9,999,999,999"),oFont10) 	
          	oPrint:Say(lin,1750,Transform(TMA->ZA2_AVUNIT, "@E 9,999,999,999.99"),oFont10) 	
          	oPrint:Say(lin,2020,Transform(TMA->ZA2_AVTOT, "@E 9,999,999,999.99"),oFont10) 	       
          	_nTotA += TMA->ZA2_AVTOT     
       	Else
          	oPrint:Say(lin,1600,"_________",oFont10) 	
          	oPrint:Say(lin,1800,"_________",oFont10) 	
          	oPrint:Say(lin,2000,"________________",oFont10) 	
       	Endif   
                                                               
	    lin += 60
		TMA->(DbSkip())
	Enddo      

  	oPrint:Say(lin,050,"SUB-TOTAL",oFont10B) 	       
  	oPrint:Say(lin,1350,Transform(_nTotE, "@E 9,999,999,999.99"),oFont10B) 	       
  	Iif(_nTotA>0,oPrint:Say(lin,2020,Transform(_nTotA, "@E 9,999,999,999.99"),oFont10B),) 	       

   	_nGTotE += _nTotE //soma valor total cotado da mao de obra           
   	_nGTotA += _nTotA //soma valor total aprovado da mao de obra                        
   	_nTotE  := 0 //soma valor total cotado da mao de obra           
   	_nTotA  := 0 //soma valor total aprovado da mao de obra            
//---------------------------
    If _lOSComp // OS complementar sim			
       lin += 150
	   oPrint:Say(lin,0050,OemToAnsi("O.S. COMPLEMENTAR"),oFont12B)
       oPrint:Say(lin,1300,OemToAnsi("Data Solicitação O.S. Complementar:"),oFont12)

       If ZAD->(DbSeek(xFilial("ZAD")+_cNumOs,.T.))//orderm de serviço complementar

	  	   oPrint:Say(lin,2050,Dtoc(ZAD->ZAD_DATA),oFont12B)
       lin += 60                                                

//-------------------------------------------------------  	   
  	      While !ZAD->(Eof()) .And. ZAD->ZAD_NUM == _cNumOs
  	   
  	   	 	 oPrint:Say(lin,040,ZAD->ZAD_ITEM,oFont10)
	 	     oPrint:Say(lin,230,ZAD->ZAD_CODCON,oFont10) 	   
	 	     oPrint:Say(lin,350,ZAD->ZAD_DESCRI,oFont10) 	    	   
	         oPrint:Say(lin,0900,Transform(ZAD->ZAD_QUANT, "@E 9,999,999,999")   ,oFont10) 	
	         oPrint:Say(lin,1100,Transform(ZAD->ZAD_VUNIT, "@E 9,999,999,999.99"),oFont10) 	
	         oPrint:Say(lin,1350,Transform(ZAD->ZAD_VTOT,  "@E 9,999,999,999.99"),oFont10) 	       
	         _nTotE += ZAD->ZAD_VTOT
       
    	     If ZAD->ZAD_AVUNIT > 0
	            oPrint:Say(lin,1550,Transform(ZAD->ZAD_AQUANT, "@E 9,999,999,999")   ,oFont10) 	
	            oPrint:Say(lin,1750,Transform(ZAD->ZAD_AVUNIT, "@E 9,999,999,999.99"),oFont10) 	
	            oPrint:Say(lin,2020,Transform(ZAD->ZAD_AVTOT , "@E 9,999,999,999.99"),oFont10) 	       
	            _nTotA += ZAD->ZAD_AVTOT     
	         Else
	            oPrint:Say(lin,1600,"_________",oFont10) 	
	            oPrint:Say(lin,1800,"_________",oFont10) 	
	            oPrint:Say(lin,2000,"________________",oFont10) 	
	         Endif   
                                                                
             lin += 60
 	         ZAD->(DbSkip())
 	      Enddo   
      Endif
      
	  oPrint:Say(lin,050,"SUB-TOTAL",oFont10B) 	       
	  oPrint:Say(lin,1350,Transform(_nTotE, "@E 9,999,999,999.99"),oFont10B) 	       
	  oPrint:Say(lin,2020,Iif(_nTotA>0,Transform(_nTotA, "@E 9,999,999,999.99"),""),oFont10B)

	  _nGTotE += _nTotE //soma valor total cotado da mao de obra           
	  _nGTotA += _nTotA //soma valor total aprovado da mao de obra                        

	Endif

  	lin += 130                                                                      
  	oPrint:Say(lin,050,"TOTAL GERAL",oFont10B) 	       
  	oPrint:Say(lin,1350,Transform(_nGTotE, "@E 9,999,999,999.99"),oFont10B)
  	oPrint:Say(lin,2020,Iif(_nGTotA>0,Transform(_nGTotA, "@E 9,999,999,999.99"),""),oFont10B)
  
  	lin += 500

	oPrint:Line( lin,  0200, lin, 1100 )   	// horizontal para gerencia
	oPrint:Line( lin, 01300, lin, 2200 )   	// horizontal para diretoria

	lin += 10
	oPrint:Say(lin,500,OemToAnsi("Gerência"),oFont12)    
	oPrint:Say(lin,1700,OemToAnsi("Diretoria"),oFont12)
  	lin += 90
  
  	TMA->(DbCloseArea())      
              
  	oPrint:EndPage() 		// Finaliza a pagina              
  	oPrint:Preview()  		// Visualiza antes de imprimir  
Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA O CABECALHO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Cabecalho(oPrint,i)
Local cFileLogo  := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial

	If !File(cFileLogo)
		cFileLogo := "LGRL" + SM0->M0_CODIGO+".BMP" // Empresa
	Endif

	oPrint:StartPage() // Inicia uma nova pagina

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ IMPRIME OS DETALHES DA O.S. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function fSolDet(nRel)
Local bFuncao 
Private _lRet2 := .F.

	If nRel==2 // geral
		If !Pergunte('EST081',.T.)
			Return
		Endif
	Endif

	Processa( {|| fGeraDet(nRel) },"Gerando Dados para a Impressao")
	
	If _lRet2
		Return
	EndIf

	If nRel == 1     //único
		bFuncao := {|| fRptDet1() }
	ElseIf nRel == 2 //geral       
		bFuncao := {|| fRptDet2() }
	ElseIf nRel == 3 //item
		bFuncao := {|| fRptDet3() }
	EndIf

	Processa( bFuncao,"Aguarde Imprimindo...")
	
Return Nil

Static Function fGeraDet(nRel)
Local nRadio
Local aRadio := {"Diferido:","Imobilizado:","Manutencao:"}
Local _cTipoOs := ""
Local _lRet := .f. 
	
	If nRel == 2 //GERAL

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³FILTRA POR IM OU DF, OU MM³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   	DEFINE MSDIALOG oDlg TITLE "Tipo de Ordem de Servico" FROM 0,0 TO 170,170 Pixel
	   
	   	@ 15,15 SAY "Tipo de O.S." SIZE 040,8 Object otipoos //"Imprime Peso Bruto"
		@ 30, 15 RADIO oRadio VAR nRadio ITEMS aRadio[1],aRadio[2],aRadio[3] SIZE 65,8 PIXEL OF oDlg
	
	   	DEFINE SBUTTON oBtnOk     FROM 70,15 TYPE 1 ACTION Close(oDlg) ENABLE OF oDlg
	   	DEFINE SBUTTON oBtnCancel FROM 70,45 TYPE 2 ACTION (_lret:=.t.,Close(oDlg)) ENABLE OF oDlg
	
	   	ACTIVATE MSDIALOG oDlg CENTERED 
	   
	   	If _lret //CANCELA
	   		_lRet2 := .T.
	   		Return
	   	endif
	   	
	   	If nRadio==1
	   		_cTipoOs := "DF"
	   	ElseIf nRadio==2
	   		_cTipoOs := "IM"
	   	ElseIf nRadio==3
	   		_cTipoOs := "MM"
	   	Endif

	EndIf

	If Select("TMB") > 0
		TMB->(DbCloseArea())
	EndIf

   	cQuery := "SELECT ZA2.*,ZA1.*,CTT.CTT_DESC01,"
   	cQuery += " SC1.C1_MOEDA, SC1.C1_NUMOS,SC1.C1_NUM,SC1.C1_ITEM,SC1.C1_FORNECE,SC1.C1_LOJA,"
   	cQuery += " SC1.C1_EMISSAO,SC1.C1_QUANT,SC1.C1_VUNIT,SC1.C1_RESIDUO, SC1.C1_FILIAL "
   	
   	If nRel == 3//itens
   		cQuery += " ,SC1.C1_PRODUTO,SC1.C1_DESCRI"
   	EndIf
   	
   	cQuery += " FROM "+RetSqlName('ZA1')+" ZA1," + RetSqlName('CTT')+" CTT, "
	cQuery += RetSqlName('ZA2')+" ZA2 LEFT JOIN "+ RetSqlName('SC1')+" SC1 "
	cQuery += " ON ZA2.ZA2_NUM+ZA2.ZA2_ITEM = SC1.C1_NUMOS "

   	cQuery += " WHERE ZA1.ZA1_NUM  = ZA2.ZA2_NUM "
   	cQuery += " AND ZA1.ZA1_CC     = CTT.CTT_CUSTO "
	cQuery += " AND ZA1.ZA1_FILIAL = '" + xFilial("ZA1")+ "' AND ZA1. D_E_L_E_T_ = ' '"
	cQuery += " AND ZA2.ZA2_FILIAL = '" + xFilial("ZA2")+ "' AND ZA2. D_E_L_E_T_ = ' '" 
   	cQuery += " AND CTT.CTT_FILIAL = '" + xFilial("CTT")+ "' AND CTT. D_E_L_E_T_ = ' '"

   	cQuery += " AND SC1. D_E_L_E_T_ = ' '" //-- nao filtra SC1 POR FILIAL

   	If nRel == 1 .Or. nRel == 3//UNICO
	   	cQuery += "AND ZA1.ZA1_NUM = '" + ZA1->ZA1_NUM +"' " 
	EndIf
	
	If nRel == 2 //GERAL (IMPRIME TODAS AS O.S.)
		cQuery += " AND SUBSTRING(ZA1.ZA1_NUM,1,2) ='"+_cTipoOs+"' "

	 	If !empty(mv_par01)
	 		cQuery += " AND ZA1.ZA1_RESP = '"+mv_par01+"' "
	 	Endif
	EndIf
	
   	If nRel != 3 //itens (os:003452)
   		cQuery += " AND ZA1.ZA1_ENCERA != 'S'"
   	EndIf
   	
   	cQuery += " ORDER BY ZA1.ZA1_NUM, SC1.C1_FILIAL,SC1.C1_NUM,SC1.C1_ITEM ASC"    

    //MemoWrit('C:\TEMP\EST081C.SQL',cQuery)
   	TCQUERY cQuery NEW ALIAS "TMB"      

   	TcSetField("TMB","ZA1_DATA"  ,"D") // Muda a data de string para date    
   	TcSetField("TMB","ZA1_CDATA" ,"D") // Muda a data de string para date    
   	TcSetField("TMB","ZA1_DTINI" ,"D") // Muda a data de string para date    
   	TcSetField("TMB","ZA1_DTFIM" ,"D") // Muda a data de string para date    
   	TcSetField("TMB","ZA2_DATA"  ,"D") // Muda a data de string para date    
   	TcSetField("TMB","C1_EMISSAO","D") // Muda a data de string para date       

	TMB->(Dbgotop())
	If Empty(TMB->ZA1_NUM)//Verifica se não encontrou a solicitação de nota na visualização
		Msgbox(OemToAnsi("Nao Existe Nenhuma Movimentação para a O.S. Selecionada, Verifique !!!2") ,"Atencao","ALERT" )     
    	TMB->(DbCloseArea())
    	_lRet2 := .T.
	   	Return
	Endif

Return

Static Function fRptDet1()
Local lin 	    := 500
Local _cDescSe
Local _nLinha
Local _nx
Local _aOSAtiv  := {}
Local _nVlrCon  := 0
Local _cOk      := .T.
Local _lPri     := .F.
Local _nTotA    := 0
Local _nTotC    := 0  
Local _nTotG    := 0  
Local _nGTotA   := 0
Local _nGTotC   := 0
Local _nGTotG   := 0
Local _nVlrPed  := 0
Local _nVlrGas  := 0
Local _nVGasIt  := 0
Local _nVlrGTo  := 0 
Local _cTipo    := Space(01)
Local _nVlrNfSI := 0

 i       := 1
 _aOSGer := {}
_nSaldo  := 0
_cConta  := Space(50)
_aTipon  := {OemToAnsi("A=Ativo Diferido - Gastos Pré-Operacionais"),;
             OemToAnsi("C=Compra de Material - Construções"),;
             OemToAnsi("F=Ferramental - Faturado p/ cliente"),;
             OemToAnsi("I=Instalações de Novas Máquinas"),;             
             OemToAnsi("P=Projeto de Melhoria,Ampliação Produção, Adequação da Linha, Reforma")}

SC7->(DbsetOrder(22)) // C7_FILIAL+C7_NUMSC+C7_ITEMSC
SD1->(DbsetOrder(14)) // D1_FILIAL+D1_PEDIDO+D1_ITEMPC

While TMB->(!EOF())

	If !Empty(TMB->C1_NUM)
    
	   	_cOk := .T.
	   
	   	//VERIFICA APROVACAO DA SC
	   	SZU->(DbSetOrder(2))
	   	SZU->(DbSeek(/*xFilial("SZU")+*/TMB->C1_FILIAL+TMB->C1_NUM+TMB->C1_ITEM))
		//-- Verifica se a aprovação não foi cancelada

	   	While !SZU->(Eof()) .AND. SZU->ZU_FILIAL==TMB->C1_FILIAL .And. SZU->ZU_NUM+SZU->ZU_ITEM == TMB->C1_NUM+TMB->C1_ITEM
		   	If SZU->ZU_STATUS $ "C"
				_cOk := .F.
				Exit
		   	Endif

		   	SZU->(DbSkip())
	   	Enddo
	   
       	If _cOK
           
          	If SC7->(Dbseek(/*xFilial("SC7")*/TMB->C1_FILIAL+TMB->C1_NUM+TMB->C1_ITEM)) //filial + num SC + Item SC
             
             	While (!SC7->(Eof()) .AND. SC7->C7_FILIAL==TMB->C1_FILIAL .And. TMB->C1_NUM+TMB->C1_ITEM == SC7->C7_NUMSC+SC7->C7_ITEMSC)
	              	//nao pega qdo o pedido esta c/ eliminação de residuo, mas pode pegar qdo tiver qtde já entregue e c/ eliminacao de residuo parcial
	             	If Empty(SC7->C7_RESIDUO) .Or. (!Empty(SC7->C7_RESIDUO) .And. SC7->C7_QUJE > 0 )
	
		             If SD1->(Dbseek(/*xFilial("SD1")*/SC7->C7_FILIAL+SC7->C7_NUM+SC7->C7_ITEM)) //Filial + num pedido + item pedido       
		                
		                //Inclui os pedidos que foram atendidos parcialmente, sem eliminacao de residuo
		                If (SC7->C7_QUANT - SC7->C7_QUJE) > 0 .And. (SC7->C7_QUJE > 0 ) .And. Empty(SC7->C7_RESIDUO)
			                _nx := Ascan(_aOSAtiv, {|x| x[1]+x[5]== SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA+TMB->C1_NUMOS})
			                //Saldo a entregar * (preco unitario * aliq de ipi)  //traz valor de ipi unitario
			                If SC7->C7_IPI > 0  
			                   _nVlrPed := (SC7->C7_QUANT - SC7->C7_QUJE)* xMoeda ( (SC7->C7_PRECO + ((SC7->C7_PRECO*SC7->C7_IPI)/100)) , SC7->C7_MOEDA , 1 , SC7->C7_EMISSAO )
			                Else
	      		                //Saldo a entregar * preco unitario
			                   _nVlrPed := (SC7->C7_QUANT - SC7->C7_QUJE)* xMoeda ( SC7->C7_PRECO , SC7->C7_MOEDA , 1 , SC7->C7_EMISSAO )
			                Endif
			                   
			          	    If _nx <> 0
			                   _aOSAtiv[_nx][4] += _nVlrPed
			                   _aOSAtiv[_nx][7] += _nVlrPed
			                Else 
			                   Aadd(_aOSAtiv,{SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA,Dtoc(SC7->C7_EMISSAO),"P",_nVlrPed,TMB->C1_NUMOS,.F.,_nVlrPed, TMB->C1_NUM})
			                Endif       
			               //Para imprimir a primeira pagina c/ resumo da OS
			                _nx := Ascan(_aOSGer, {|x| x[1]== TMB->C1_NUMOS})             
			           	    If _nx <> 0
			                   _aOSGer[_nx][7] +=  _nVlrPed
			                Else 
			                   Aadd(_aOSGer,{TMB->C1_NUMOS,TMB->ZA2_ITEM,TMB->ZA2_CODCON,TMB->ZA2_DESCRI,TMB->ZA2_VTOT,TMB->ZA2_AVTOT,_nVlrPed,.F.})                                  
			                Endif   
			            Endif
                        
						//verifica a existencia de varias notas p/ o mesmo pedido
                        While (!SD1->(Eof()) .And. SD1->D1_FILIAL==SC7->C7_FILIAL .AND. SC7->C7_NUM+SC7->C7_ITEM == SD1->D1_PEDIDO+SD1->D1_ITEMPC)		                
		            
			             	// inclui as notas fiscais
			             
			             	//-- ALTERADO
			             	//-- JOAOFR 02/05/2012
			             	//-- OS 17112
			                _nx := Ascan(_aOSAtiv, {|x| x[1]+x[5]== SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+TMB->C1_NUMOS})
			          	    If _nx <> 0
			                   _aOSAtiv[_nx][4] += SD1->D1_TOTAL // (SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM
			                   _aOSAtiv[_nx][7] += SD1->D1_CUSTO // SD1->D1_TOTAL
			                Else 
			                   Aadd(_aOSAtiv,{SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA,;
			                   				 Dtoc(SD1->D1_DTDIGIT),"N",;
			                   				 SD1->D1_TOTAL,;    //(SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM,
			                   				 TMB->C1_NUMOS,.F.,;
			                   				 SD1->D1_CUSTO,TMB->C1_NUM, SD1->D1_PEDIDO })   //SD1->D1_TOTAL})
			                Endif   
			                //Para imprimir a primeira pagina c/ resumo da OS
			                _nx := Ascan(_aOSGer, {|x| x[1]== TMB->C1_NUMOS})
				            
				            If _nx <> 0
			                   _aOSGer[_nx][7] +=  SD1->D1_TOTAL //CUSTO //(SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM
			                Else
			                   Aadd(_aOSGer,{TMB->C1_NUMOS,TMB->ZA2_ITEM,TMB->ZA2_CODCON,TMB->ZA2_DESCRI,TMB->ZA2_VTOT,TMB->ZA2_AVTOT,;
			                   				SD1->D1_TOTAL,; //SD1->D1_CUSTO,; //(SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM,;
			                   				.F.})
			                Endif
			                  
			                //-- os 054874 (26/08/2013) usuario: valdelenems
			                //-- autor: joaofr
			                //-- trazer as nf de frete
			                SF8->(dbsetorder(2))//F8_FILIAL+F8_NFORIG+F8_SERORIG+F8_FORNECE+F8_LOJA
			                If SF8->(DBSEEK(/*xFilial("SF8")*/SD1->D1_FILIAL+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)))
			                
			                    cD1PrdIt := SD1->D1_COD+SD1->D1_ITEM //-- guarda para usar no seek abaixo

								aAreaSd1 := SD1->(getarea())
								
								SD1->(DBSETORDER(1))//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
								
		             			If SD1->(Dbseek(/*xFilial("SD1")*/SD1->D1_FILIAL+SF8->(F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN)+cD1PrdIt)) //Filial + num pedido + item pedido       
		             
					                _nx := Ascan(_aOSAtiv, {|x| x[1]+x[5]== SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+TMB->C1_NUMOS})
					          	    If _nx <> 0
					                   _aOSAtiv[_nx][4] += SD1->D1_TOTAL // (SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM
					                   _aOSAtiv[_nx][7] += SD1->D1_CUSTO // SD1->D1_TOTAL
					                Else 
					                   Aadd(_aOSAtiv,{SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA,;
					                   				 Dtoc(SD1->D1_DTDIGIT),"N",;
					                   				 SD1->D1_TOTAL,;    //(SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM,
					                   				 TMB->C1_NUMOS,.F.,;
					                   				 SD1->D1_CUSTO,TMB->C1_NUM, SD1->D1_PEDIDO })   //SD1->D1_TOTAL})
					                Endif   
					                //Para imprimir a primeira pagina c/ resumo da OS
					                _nx := Ascan(_aOSGer, {|x| x[1]== TMB->C1_NUMOS})
						            
						            If _nx <> 0
					                   _aOSGer[_nx][7] +=  SD1->D1_TOTAL //CUSTO //(SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM
					                Else
					                   Aadd(_aOSGer,{TMB->C1_NUMOS,TMB->ZA2_ITEM,TMB->ZA2_CODCON,TMB->ZA2_DESCRI,TMB->ZA2_VTOT,TMB->ZA2_AVTOT,;
					                   				SD1->D1_TOTAL,; //SD1->D1_CUSTO,; //(SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM,;
					                   				.F.})
					                Endif
					                
			                	ENDIF
			                	
			                	SD1->(restArea(aAreaSd1))
			                
			                ENDIF
			                
			                SD1->(Dbskip())
			                
			            Enddo
			            
		             Else // inclui os pedidos de compras
		                If Empty(SC7->C7_RESIDUO)
			                _nx := Ascan(_aOSAtiv, {|x| x[1]+x[5]== SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA+TMB->C1_NUMOS})
			          	    If _nx <> 0
			                   _aOSAtiv[_nx][4] += xMoeda ( (SC7->C7_TOTAL+SC7->C7_VALIPI) , SC7->C7_MOEDA, 1 , SC7->C7_EMISSAO )
			                   _aOSAtiv[_nx][7] += xMoeda ( SC7->C7_TOTAL, SC7->C7_MOEDA , 1 , SC7->C7_EMISSAO )
			                Else
			                   Aadd(_aOSAtiv,{SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA,Dtoc(SC7->C7_EMISSAO),"P",;
			                   				  xMoeda ( (SC7->C7_TOTAL+SC7->C7_VALIPI), SC7->C7_MOEDA , 1 , SC7->C7_EMISSAO ),TMB->C1_NUMOS,.F.,(SC7->C7_TOTAL+SC7->C7_VALIPI),;
			                   				  TMB->C1_NUM})
			                Endif
			               //Para imprimir a primeira pagina c/ resumo da OS
			                _nx := Ascan(_aOSGer, {|x| x[1]== TMB->C1_NUMOS})
			           	    If _nx <> 0
			                   _aOSGer[_nx][7] +=  xMoeda( (SC7->C7_TOTAL+SC7->C7_VALIPI) , SC7->C7_MOEDA , 1 , SC7->C7_EMISSAO)
			                Else
			                   Aadd(_aOSGer,{TMB->C1_NUMOS,TMB->ZA2_ITEM,TMB->ZA2_CODCON,TMB->ZA2_DESCRI,TMB->ZA2_VTOT,TMB->ZA2_AVTOT,xMoeda ( (SC7->C7_TOTAL+SC7->C7_VALIPI), SC7->C7_MOEDA , 1 , SC7->C7_EMISSAO ),.F.})
			                Endif
			            Endif
		             Endif
		         Endif
		         SC7->(Dbskip())
		     Enddo    
	      Else // inclui a requisicao de compras somente as já aprovadas
	         If Empty(TMB->C1_RESIDUO)
	             _nx := Ascan(_aOSAtiv, {|x| x[1]+x[5]== TMB->C1_NUM+TMB->C1_FORNECE+TMB->C1_LOJA+TMB->C1_NUMOS})
	 	      	 If _nx <> 0
	                _aOSAtiv[_nx][4] +=  xMoeda ((TMB->C1_QUANT * TMB->C1_VUNIT)  , TMB->C1_MOEDA , 1 , TMB->C1_EMISSAO)
	             Else 
	                Aadd(_aOSAtiv,{TMB->C1_NUM+TMB->C1_FORNECE+TMB->C1_LOJA,Dtoc(TMB->C1_EMISSAO),"S",xMoeda ((TMB->C1_QUANT * TMB->C1_VUNIT), TMB->C1_MOEDA , 1 , TMB->C1_EMISSAO),TMB->C1_NUMOS,.F.,(TMB->C1_QUANT * TMB->C1_VUNIT)})
	             Endif   
	             //Para imprimir a primeira pagina c/ resumo da OS
	             _nx := Ascan(_aOSGer, {|x| x[1]== TMB->C1_NUMOS})             
		      	 If _nx <> 0
	                _aOSGer[_nx][7] += xMoeda ((TMB->C1_QUANT * TMB->C1_VUNIT), TMB->C1_MOEDA , 1 , TMB->C1_EMISSAO) //(TMB->C1_QUANT * TMB->C1_VUNIT)
	             Else 
	                Aadd(_aOSGer,{TMB->C1_NUMOS,TMB->ZA2_ITEM,TMB->ZA2_CODCON,TMB->ZA2_DESCRI,TMB->ZA2_VTOT,TMB->ZA2_AVTOT,xMoeda ((TMB->C1_QUANT * TMB->C1_VUNIT), TMB->C1_MOEDA , 1 , TMB->C1_EMISSAO),.F.})               
	             Endif   
	         Endif
          Endif 
          
       Endif   
    Endif
    
	TMB->(DbSkip())

Enddo

If Len(_aOSAtiv)==0 .Or.  Len(_aOSGer)==0 //Verifica se não encontrou a solicitação de nota na visualização
   Msgbox(OemToAnsi("Nao Existe Nenhuma Movimentação para a O.S. Selecionada, Verifique !!!3") ,"Atencao","ALERT" )     
   TMB->(DbCloseArea())
   return
Endif 

_aOSAtiv := ASort(_aOSAtiv,,, { |x, y| x[5]+x[3] < y[5]+y[3]})  //Ordena a matriz pelo numero da O.S.

oPrint := TMSPrinter():New( "Ordem de Serviço do Ativo") 
oPrint:SetPortrait()
oPrint:Setup()
oPrint:StartPage() 		// Inicia uma nova pagina

TMB->(Dbgotop())
oPrint:SayBitmap(015,0015, cStartPath+"\Whbl.bmp",328,140)

oPrint:Say(070,2150,"Pag:",oFont10 ,,,,1) //"Pagina :"
oPrint:Say(070,2250,StrZero(i,3),oFont10,,,,1)
oPrint:Say(170,040,"Data:",oFont10)
oPrint:Say(170,140,Dtoc(dDatabase),oFont10) 
oPrint:Say(170, 800,OemToAnsi("ORDEM DE SERVIÇO DO ATIVO"),oFont12B)
oPrint:Say(170,2100,"Hora:",oFont10 ,,,,1)
oPrint:Say(170,2250,Subs(Time(),1,5),oFont10,,,,1)

oPrint:Say(310, 040,OemToAnsi("Data Inicio:"),oFont10B)
oPrint:Say(310, 300,Dtoc(TMB->ZA1_DTINI),oFont10)  	
oPrint:Say(310, 650,OemToAnsi("Previsão Término:"),oFont10B)
oPrint:Say(310,1030,Dtoc(TMB->ZA1_DTFIM),oFont10)

//oPrint:Say(310,1500,OemToAnsi("Resp:"),oFont10B)
//oPrint:Say(310,1610,TMB->QAA_NOME,oFont10)

oPrint:Say(400,040,"Numero OS:",oFont10B)
oPrint:Say(400,300,TMB->ZA1_NUM,oFont10)	
oPrint:Say(400,650,OemToAnsi("Conta Contabil:"),oFont10B)
If !Empty(TMB->ZA1_CONTA)
 	oPrint:Say(400,1030,OemToAnsi(Alltrim(TMB->ZA1_CONTA)+" - "+Subs(TMB->ZA1_DCONTA,1,40) ),oFont12)
   _cConta  := OemToAnsi(Alltrim(TMB->ZA1_CONTA)+"-"+Subs(TMB->ZA1_DCONTA,1,40)) 	
Endif
_dDtini  := Dtoc(TMB->ZA1_DTINI)
_dDtfim  := Dtoc(TMB->ZA1_DTFIM)

_cOS     := TMB->ZA1_NUM
_nlin    := 500 

oPrint:Say(_nlin,40,OemToAnsi("ITEM    COMPLEM."),oFont10B)

oPrint:Say(_nlin,400,OemToAnsi("CONTROLE"),oFont10B)
oPrint:Say(_nlin,610,OemToAnsi("DESCRIÇÃO"),oFont10B)

oPrint:Say(_nLin,1600,OemToAnsi("R$ APROVADO"),oFont10B,,,,1)
oPrint:Say(_nLin,1950,OemToAnsi("R$ GASTO"),oFont10B,,,,1)
oPrint:Say(_nLin,2300,OemToAnsi("R$ SALDO"),oFont10B,,,,1)


_nlin += 070

ZA2->(DbsetOrder(1))//Filial + numero + item
If ZA2->(Dbseek(xFilial("ZA2")+Subs(_aOSGer[1][1],1,6))) //filial + num OS + Item OS
   	While !ZA2->(EOF()) .And. Subs(_aOSGer[1][1],1,6) == ZA2->ZA2_NUM
   		IF SUBSTR(_AOSGER[1][1],1,2) == "IM" 
       		_nx := Ascan(_aOSGer, {|x| ALLTRIM(SUBSTR(x[1],1,6))+ALLTRIM(x[2])$ZA2->ZA2_NUM+ZA2->ZA2_ITEM})
     	ELSEIF  SUBSTR(_AOSGER[1][1],1,2)$"DF/MM"
	     	_nx := Ascan(_aOSGer, {|x| ALLTRIM(x[1])$ZA2->ZA2_NUM+ZA2->ZA2_ITEM})
     	ENDIF
       
	    If _nx == 0
    		Aadd(_aOSGer,{ZA2->ZA2_NUM+ZA2->ZA2_ITEM,ZA2->ZA2_ITEM,ZA2->ZA2_CODCON,ZA2->ZA2_DESCRI,ZA2->ZA2_VTOT,ZA2->ZA2_AVTOT,0,.F.})                      
       	Endif
      
      	ZA2->(Dbskip())
   	Enddo   
Endif

_aOSGer  := ASort(_aOSGer,,, { |x, y| x[2] < y[2]})  //Ordena a matriz pelo Item da O.S.

//-- OS Nº: 022384 do Portal
//-- data : 20/09/2011
//-- autor: João Felipe da Rosa
//-- desc : OS COMPLEMENTAR

ZAD->(DbsetOrder(1))//Filial + numero + item
If ZAD->(Dbseek(xFilial("ZAD")+Subs(_aOSGer[1][1],1,6))) //filial + num OS + Item OS
   	While !ZAD->(EOF()) .And. Subs(_aOSGer[1][1],1,6) == ZAD->ZAD_NUM
   		Aadd(_aOSGer,{ZAD->ZAD_NUM+ZAD->ZAD_ITEM,ZAD->ZAD_ITEM+'           COMPL.',ZAD->ZAD_CODCON,ZAD->ZAD_DESCRI,ZAD->ZAD_VTOT,ZAD->ZAD_AVTOT,0,.F.})
      	ZAD->(Dbskip())
   	Enddo   
Endif

//-- FIM OS N.: 022384

_lPri  := .F.
For _ni:= 1 to Len(_aOSGer)

       If Val(_aOSGer[_ni][3]) >= 20 .And. !_lPri //Imprime mao de obra
       	//  _nLin += 070                              
          oPrint:Say(_nLin,050,"TOTAL",oFont12B) 	       
          _nGTotA := _nTotA           
          _nGTotC := _nTotC
          _nGTotG := _nTotG
          oPrint:Say(_nLin,1600,Transform(_nTotC, "@E 9,999,999,999.99"),oFont12,,,,1)
          oPrint:Say(_nLin,1950,Transform(_nTotA, "@E 9,999,999,999.99"),oFont12,,,,1)
          oPrint:Say(_nLin,2300,Transform(_nTotG, "@E 9,999,999,999.99"),oFont12,,,,1)

      	  _nLin += 170                                      

          oPrint:Say(_nLin,050,OemToAnsi("MÃO DE OBRA"),oFont12S)		      	  

   	      _nLin += 070                              
   	      _lPri  := .T.
   	      _nTotA := _nTotC := _nTotG := 0
       Endif
       oPrint:Say(_nLin,040,_aOSGer[_ni][2],oFont12)
       oPrint:Say(_nLin,460,_aOSGer[_ni][3],oFont12)
       oPrint:Say(_nLin,610,_aOSGer[_ni][4],oFont12)                                          

       oPrint:Say(_nLin,1600,Transform(_aOSGer[_ni][6],"@e 9,999,999,999.99"),oFont12,,,,1)
       oPrint:Say(_nLin,1950,Transform(_aOSGer[_ni][7],"@e 9,999,999,999.99"),oFont12,,,,1)
       oPrint:Say(_nLin,2300,Transform(_aOSGer[_ni][6]-_aOSGer[_ni][7],"@e 9,999,999,999.99"),oFont12,,,,1)

		//Alert(_aOSGer[_ni][7])

       _nTotC += _aOSGer[_ni][6]
       _nTotA += _aOSGer[_ni][7]
       _nTotG += _aOSGer[_ni][6]-_aOSGer[_ni][7]       
  
       _nLin += 70
Next _ni

  oPrint:Say(_nLin,050,"TOTAL",oFont12B) 	       
  oPrint:Say(_nLin,1600,Transform(_nTotC, "@E 9,999,999,999.99"),oFont12S,,,,1)
  oPrint:Say(_nLin,19050,Transform(_nTotA, "@E 9,999,999,999.99"),oFont12S,,,,1)
  oPrint:Say(_nLin,2300,Transform(_nTotG, "@E 9,999,999,999.99"),oFont12S,,,,1)
  
  _nGTotC += _nTotC //soma valor total cotado da mao de obra           
  _nGTotA += _nTotA //soma valor total aprovado da mao de obra                        
  _nGTotG += _nTotG //soma valor total aprovado da mao de obra                           
  _nLin += 80
  oPrint:Say(_nLin,050,"TOTAL GERAL",oFont12B) 	       
  oPrint:Say(_nLin,1600,Transform(_nGTotC, "@E 9,999,999,999.99"),oFont12B,,,,1)
  oPrint:Say(_nLin,1950,Transform(_nGTotA, "@E 9,999,999,999.99"),oFont12B,,,,1)
  oPrint:Say(_nLin,2300,Transform(_nGTotG, "@E 9,999,999,999.99"),oFont12B,,,,1)

  _nLin += 80                                                                      
  oPrint:Say(_nLin,050,"Valor Total Negociado: ",oFont12B) 	       
  oPrint:Say(_nLin,600,Transform(TMB->ZA1_VLNEGO, "@E 9,999,999,999.99"),oFont12B) 	    
  
 
 SA1->(DbSeek(xFilial("SA1")+TMB->ZA1_CLIENTE+TMB->ZA1_LOJA ))                
 If SA1->(Found())            
    _nLin += 90                                                                      
    oPrint:Say(_nLin,050,"Cliente :",oFont12B) 	       
    oPrint:Say(_nLin,300,TMB->ZA1_CLIENTE +"-"+TMB->ZA1_LOJA+"  "+ SA1->A1_NOME,oFont12B) 	    
 Endif    
  
  _nLin += 150                                                                      
  oPrint:Say(_nLin,050,OemToAnsi("Descrição do Serviço"),oFont12B)
  ZA1->(Dbgoto(TMB->R_E_C_N_O_))         
  _nLinha := MlCount(Lower(Alltrim(ZA1->ZA1_DESC)))
                                                 
  for i:= 1 to _nLinha
 	_nLin += 70
    oPrint:Say(_nLin,050,OemToAnsi(MemoLine(ZA1->ZA1_DESC,105,i)),oFont10)
  next i 

oPrint:EndPage() 		// Finaliza a pagina
/**************************************************************************/

i := 1 //Volta o numero da pagina em 1
TMB->(Dbgotop())

_cNumos  := TMB->ZA1_NUM
_nSaldo  := TMB->ZA1_VLAPMA+TMB->ZA1_VLCAMA
_nSalTot := _nSaldo
_ctipon  := IIf(TMB->ZA1_TIPO$"A",_aTipon[1],IIf(TMB->ZA1_TIPO$"C",_aTipon[2],IIf(TMB->ZA1_TIPO$"F",_aTipon[3],IIf(TMB->ZA1_TIPO$"I",_aTipon[4],_aTipon[5]))))  //Cliente         

If !Empty(TMB->ZA1_CONTA)
   _cConta  := OemToAnsi(Alltrim(TMB->ZA1_CONTA)+"-"+Subs(TMB->ZA1_DCONTA,1,40)) 	
Endif

_dDtini  := Dtoc(TMB->ZA1_DTINI)
_dDtfim  := Dtoc(TMB->ZA1_DTFIM)
_cOS     := TMB->ZA1_NUM

ZA2->(DbsetOrder(1))
If ZA2->(Dbseek(xFilial("ZA2")+_aOSAtiv[1][5])) //filial + num OS + Item OS
   _nVlrCon := ZA2->ZA2_AVTOT
Endif        

Cabecalho1(oPrint,i)  	// Funcao que monta o cabecalho

lin := 510

_cCodCon := _aOSAtiv[1][5] //guarda codigo de controle
_cTipo   := _aOSAtiv[1][3] //Guarda tipo 

For _nx:= 1 to Len(_aOSAtiv)

	If lin > 3120
	    _cNumos := _aOSAtiv[_nx][5] //Guarda numero da os
		i++
		oPrint:EndPage() 		// Finaliza a pagina
		Cabecalho1(oPrint,i)  	// Funcao que monta o cabecalho
		lin := 510
	Endif

    //-- Exibe valor gasto por NF = nota fiscal, PC= pedido de compra e SC = Solicitaçao de compra
	//-- Verifica codigo de controle
    If (_aOSAtiv[_nx][3] <> _cTipo) .OR. (_cCodCon <>  _aOSAtiv[_nx][5])

        lin += 070

        If _nVlrGas  > 0 //imprime o valor gasto antes do saldo se ainda nao imprimiu
        
	        oPrint:Say(lin,1650,"Valor Gasto de " + Iif(_cTipo$"N","Nota Fiscal : ",Iif(_cTipo$"P","Pedido : ","Solicitação : ")),oFont12B,,,,1)
	        oPrint:Say(lin,2050,Transform( _nVlrGas,"@e 9,999,999,999.99"),oFont12S,,,,1)
	        
	        //-- OS N: 054872 02/09/2013, FEITO POR JOAOFR
	        If _cTipo$"N"
			    oPrint:Say(lin,2340,Transform( _nVlrNFSI,"@e 9,999,999,999.99"),oFont12S,,,,1)
			Endif
			//-- FIM OS N: 054872
	
	        _cTipo    := _aOSAtiv[_nx][3]  // Guarda tipo 
	        _nVlrGTo  += _nVlrGas //Soma valor total de gasto
	        _nVlrGas  := 0
	        _nVlrNFSI := 0
	        
	        lin += 10
		Endif
			
    Endif
    
    lin += 70
       
    If  (_cCodCon <>  _aOSAtiv[_nx][5])
    
        oPrint:Say(lin,0450,"Saldo Deste Item da O.S : "+Transform(_nVlrCon,"@e 9,999,999,999.99"),oFont12B)
        oPrint:Say(lin,1650,"Valor Gasto : ",oFont12B,,,,1)
        oPrint:Say(lin,2050,Transform( _nVGasIt ,"@e 9,999,999,999.99"),oFont12S,,,,1)
	                
        _nVGasIt := 0  // zera a variavel de gasto por item da OS.       
		lin += 60
        oPrint:Line( lin, 33, lin, 2350 )   	// horizontal para diretoria
		lin += 50

        If lin > 3120
		   _cNumos := _aOSAtiv[_nx][5] //Guarda numero da os        
  		   i++
		   oPrint:EndPage() 		// Finaliza a pagina
		   Cabecalho1(oPrint,i)  	// Funcao que monta o cabecalho
		   lin := 510
	    Endif

	    ZA2->(Dbseek(xFilial("ZA2")+_aOSAtiv[_nx][5])) //filial + num OS + Item OS
		If lin <> 510
	       oPrint:Say(Lin,040,ZA2->ZA2_CODCON +" - "+ ZA2->ZA2_DESCRI + OemToAnsi("             Valor Total:")+Transform(ZA2->ZA2_AVTOT,"@e 9,999,999,999.99"),oFont10B)
 		   lin += 70    	
		Endif
	    _nVlrCon := ZA2->ZA2_AVTOT		
        _cCodCon := _aOSAtiv[_nx][5] //guarda codigo de controle    
    Endif
    
    _nVlrGas  += _aOSAtiv[_nx][4] //soma valor gasto por tipo N = nota fiscal, P= pedido de compra e S = Solicitaçao de compra
	_nVlrNfSI += _aOSAtiv[_nx][7] //soma o valor sem impostos
    _nVGasIt  += _aOSAtiv[_nx][4] //soma valor gasto por Item da O.S.

    oPrint:Say(lin,050,_aOSAtiv[_nx][2],oFont10) //dt digitacao

    If _aOSAtiv[_nx][3]$"N"

	    oPrint:Say(lin,290,_aOSAtiv[_nx][8],oFont10) // SC da NF
    	oPrint:Say(lin,490,_aOSAtiv[_nx][9],oFont10) // PC da NF

       	oPrint:Say(lin,690,Subs(_aOSAtiv[_nx][1],1,9)+"-"+Subs(_aOSAtiv[_nx][1],10,3),oFont10) // NF-SERIE

       	If SA2->(Dbseek(xFilial("SA2")+Subs(_aOSAtiv[_nx][1],13,8))) //Filial + fornece + loja
          	oPrint:Say(lin,920,SA2->A2_NOME,oFont10)             
       	Endif 

    Elseif _aOSAtiv[_nx][3]$"P/S"

	   	if _aOSAtiv[_nx][3]$"P"
		   	oPrint:Say(lin,290,_aOSAtiv[_nx][8],oFont10) // SC do PC
	    	oPrint:Say(lin,490,Subs(_aOSAtiv[_nx][1],1,6),oFont10) //-- PC 
        Endif

	   	if _aOSAtiv[_nx][3]$"S"
	    	oPrint:Say(lin,290,Subs(_aOSAtiv[_nx][1],1,6),oFont10) //-- SC
        Endif
        
       	If SA2->(Dbseek(xFilial("SA2")+Subs(_aOSAtiv[_nx][1],7,8))) //Filial + fornece + loja
          	oPrint:Say(lin,920,SA2->A2_NOME,oFont10)             
      	Endif 

    Endif		   
    
    oPrint:Say(lin,2050,Transform(_aOSAtiv[_nx][4],"@e 9,999,999,999.99"),oFont10,,,,1)

    If _aOSAtiv[_nx][3]$"N"
	   	oPrint:Say(lin,2340,Transform(_aOSAtiv[_nx][7],"@e 9,999,999,999.99"),oFont10,,,,1)
	Endif

    _nSaldo  -= _aOSAtiv[_nx][4] // diminui as entradas referentes a OS
    _nVlrCon -= _aOSAtiv[_nx][4] // diminui as entradas referentes a OS

Next _nx

lin += 070

oPrint:Say(lin,1650,"Valor Gasto de " + Iif(_cTipo$"N","Nota Fiscal : ",Iif(_cTipo$"P","Pedido : ","Solicitação : ")),oFont12B,,,,1)
oPrint:Say(lin,2050,Transform( _nVlrGas,"@e 9,999,999,999.99"),oFont12S,,,,1)
        
//-- OS N: 054872	 02/09/2013, FEITO POR JOAOFR
If _cTipo$"N"
    oPrint:Say(lin,2340,Transform( _nVlrNFSI,"@e 9,999,999,999.99"),oFont12S,,,,1)
Endif
//-- FIM OS N: 054872

_nVlrGTo  += _nVlrGas //Soma valor total de gasto
_nVlrNFSI := 0
_nVlrGas  := 0        

lin += 80

oPrint:Say(lin,0450,"Saldo Deste Item da O.S : "+Transform(_nVlrCon,"@e 9,999,999,999.99"),oFont12B)
oPrint:Say(lin,1650,"Valor Gasto : ",oFont12B,,,,1)
oPrint:Say(lin,2050,Transform( _nVGasIt ,"@e 9,999,999,999.99"),oFont12S,,,,1)

_nVGasIt := 0  // zera a variavel de gasto por item da OS.       

lin += 60            
oPrint:Line( lin, 33, lin, 2340 )   	// horizontal para diretoria  
lin += 90

oPrint:Say(lin,0520,"O Saldo Geral da O.S.  " +Transform((_nGTotC - _nVlrGto)/*_nSaldo*/,"@e 9,999,999,999.99") +"     e o Valor Total Gasto Foi de : "+Transform(_nVlrGto,"@e 9,999,999,999.99"),oFont12S)
_nVlrGto := 0
TMB->(DbCloseArea())                  
oPrint:EndPage() 		// Finaliza a pagina              
oPrint:Preview()  		// Visualiza antes de imprimir  

Return Nil

Static Function Cabecalho1(oPrint,i)

	oPrint:StartPage() 		// Inicia uma nova pagina
	oPrint:SayBitmap(015,040, cStartPath+"\Whbl.bmp",328,140)
	oPrint:Say(070,2150,"Pag:",oFont10 ,,,,1) //"Pagina :"
	oPrint:Say(070,2250,StrZero(i,3),oFont10,,,,1)
	oPrint:Say(170,040,"Data:",oFont10)
	oPrint:Say(170,140,Dtoc(dDatabase),oFont10) 
	oPrint:Say(170,750,OemToAnsi("DETALHES DA ORDEM DE SERVIÇO DO ATIVO"),oFont12B)
	oPrint:Say(170,2100,"Hora:",oFont10 ,,,,1)
	oPrint:Say(170,2250,Subs(Time(),1,5),oFont10,,,,1)

	oPrint:Say(260, 040,OemToAnsi("Data Inicio:"),oFont10B)
	oPrint:Say(260, 300,_dDtini,oFont10)  	
	oPrint:Say(260, 650,OemToAnsi("Previsão Término:"),oFont10B)
	oPrint:Say(260,1030,_dDtfim,oFont10) 	
	oPrint:Say(260,1600,"Valor Total OS :"+Transform(_nSalTot,"@e 9,999,999,999.99"),oFont10B)

	_ctipon := IIf(TMB->ZA1_TIPO$"A",_aTipon[1],IIf(TMB->ZA1_TIPO$"C",_aTipon[2],IIf(TMB->ZA1_TIPO$"F",_aTipon[3],IIf(TMB->ZA1_TIPO$"I",_aTipon[4],_aTipon[5]))))  //Cliente         
	
	oPrint:Say(350,040,"Numero OS:",oFont10B)
	oPrint:Say(350,300,_cOS,oFont10)	
	oPrint:Say(350,650,OemToAnsi("Conta Contabil:"),oFont10B)
	If !Empty(_cConta)
	 	oPrint:Say(350, 1030,_cConta,oFont10)
	Endif
	oPrint:Box( 410, 0030, 3250, 2350 )
	
	ZA2->(DbsetOrder(1))
	If ZA2->(Dbseek(xFilial("ZA2")+_cNumos)) //filial + num OS + Item OS
	   oPrint:Say(440,040,ZA2->ZA2_CODCON +" - "+ ZA2->ZA2_DESCRI + OemToAnsi("             Valor Total:")+Transform(ZA2->ZA2_AVTOT,"@e 9,999,999,999.99"),oFont10B)
	Endif
	
	oPrint:Say(510, 040,OemToAnsi("Dt Digitação"),oFont10B)  
	oPrint:Say(510, 290,OemToAnsi("SC"),oFont10B)
	oPrint:Say(510, 490,OemToAnsi("PC"),oFont10B)
	oPrint:Say(510, 690,OemToAnsi("NF"),oFont10B)
	oPrint:Say(510, 920,OemToAnsi("Fornecedor"),oFont10B)
	oPrint:Say(510,2050,OemToAnsi("Valor c/Imp."),oFont10B,,,,1)
	oPrint:Say(510,2340,OemToAnsi("Valor s/Imp."),oFont10B,,,,1)
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ IMPRESSAO DO RELATORIO GERAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fRptDet2()

Local i 			:= 1
Local lin 			:= 500
Local _aOSGer 		:= {}
Local _nx
Local _aOSAtiv      := {}
Local _cOk          := .T.
Local _nTotVO 		:= 0
Local _nTotVA 		:= 0
Local _nTotA  		:= 0
Local _nVlrPed 		:= 0
Local _nVlrGas 		:= 0
Local _nVGasIt 		:= 0
Local _nGastoMat 	:= 0  
Local _nGastoMao 	:= 0
Local _nVlrGTo 		:= 0 
Local _cTipo   		:= Space(01)
Local _nTotal1      := _nTotal2 := _nTotal3 := _nTotal4 := _nTotal5 := _nTotal6 := _nTotal7 :=0

oPrint := TMSPrinter():New( "WHB USINAGEM - Relação de Projetos em Andamento"+ Iif(mv_par02==1," em R$(mil)","")) 
oPrint:SetLandscape()
oPrint:Setup()
oPrint:StartPage() // Inicia uma nova pagina

oPrint:SayBitmap(020,0020, cStartPath+"\Whbl.bmp",328,136)
oPrint:Say(070,3000,"Pag:",oFont10 ) //"Pagina :"
oPrint:Say(070,3100,StrZero(i,3),oFont10)

oPrint:Say(170,900,OemToAnsi("WHB USINAGEM - Relação de Projetos em Andamento "+strzero(year(date()),4))+ Iif(mv_par02==1," em R$(mil)",""),oFont16)
oPrint:Say(400,050,"Projetos Diferidos",oFont10)        

oPrint:Say(490, 070,OemToAnsi("Nº OS"), oFont12B)
oPrint:Say(490, 600,OemToAnsi("Descrição do Projeto"), oFont12B)
oPrint:Say(490,1340,OemToAnsi("C.Custo"), oFont12B)
oPrint:Say(490,1610,OemToAnsi("Valor"), oFont12B)
oPrint:Say(560,1590,OemToAnsi("Orçado"), oFont12B)
oPrint:Say(490,1885,OemToAnsi("Valor"), oFont12B)
oPrint:Say(560,1860,OemToAnsi("Aprovado"), oFont12B)
oPrint:Say(490,2120,OemToAnsi("Valor Gasto"), oFont12B)
oPrint:Say(560,2120,OemToAnsi("c/ Material"), oFont12B)
oPrint:Say(490,2440,OemToAnsi("Saldo"), oFont12B)
oPrint:Say(490,2690,OemToAnsi("Valor Gasto"), oFont12B)
oPrint:Say(560,2660,OemToAnsi("c/ Mão de Obra"), oFont12B)
oPrint:Say(490,3015,OemToAnsi("Saldo"), oFont12B)

lin += 120

oPrint:Box(  460, 0030, 2020, 3200 )    // BOX GERAL
oPrint:Box (2020, 1270, 2090, 3200 )    // CAIXA DE TOTAIS
oPrint:Line( lin,   33, lin,  3197 )   	// horizontal para diretoria 
oPrint:Line( 460,  220, 2030,  220 )   	// vertical para baixo
oPrint:Line( 460, 1270, 2090, 1270 )   	// vertical para baixo
oPrint:Line( 460, 1520, 2090, 1520 )   	// vertical para baixo
oPrint:Line( 460, 1800, 2090, 1800 )   	// vertical para baixo
oPrint:Line( 460, 2080, 2090, 2080 )   	// vertical para baixo
oPrint:Line( 460, 2360, 2090, 2360 )   	// vertical para baixo
oPrint:Line( 460, 2640, 2090, 2640 )   	// vertical para baixo
oPrint:Line( 460, 2930, 2090, 2930 )   	// vertical para baixo

TMB->(DbgoTop())

DbSelectArea('TMB')
ProcRegua(RecCount())

While TMB->(!EOF())

	IncProc()

	if lin > 1999
	
		i++
		lin := 500
		oPrint:EndPage() 		// Finaliza a pagina              
		oPrint:SetLandscape()		
		oPrint:StartPage() 		// Inicia uma nova pagina
		oPrint:SayBitmap(020,020, cStartPath+"\Whbl.bmp",328,136)
		oPrint:Say(070,3000,"Pag:",oFont10 ) //"Pagina :"
		oPrint:Say(070,3100,StrZero(i,3),oFont10)

		oPrint:Say(170,900,OemToAnsi("WHB USINAGEM - Relação de Projetos em Andamento "+strzero(year(date()),4))+ Iif(mv_par02==1," em R$(mil)",""),oFont16)
		
		oPrint:Say(400,050,"Projetos Diferidos",oFont10)        
                                                                
		oPrint:Say(490, 070,OemToAnsi("Nº OS"), oFont12B)
		oPrint:Say(490, 600,OemToAnsi("Descrição do Projeto"), oFont12B)
		oPrint:Say(490,1340,OemToAnsi("C.Custo"), oFont12B)		
		oPrint:Say(490,1610,OemToAnsi("Valor"), oFont12B)
		oPrint:Say(560,1590,OemToAnsi("Orçado"), oFont12B)
		oPrint:Say(490,1885,OemToAnsi("Valor"), oFont12B)
		oPrint:Say(560,1860,OemToAnsi("Aprovado"), oFont12B)
		oPrint:Say(490,2120,OemToAnsi("Valor Gasto"), oFont12B)
		oPrint:Say(560,2120,OemToAnsi("c/ Material"), oFont12B)
		oPrint:Say(490,2440,OemToAnsi("Saldo"), oFont12B)
		oPrint:Say(490,2690,OemToAnsi("Valor Gasto"), oFont12B)
		oPrint:Say(560,2660,OemToAnsi("c/ Mão de Obra"), oFont12B)
		oPrint:Say(490,3015,OemToAnsi("Saldo"), oFont12B)
	
		lin += 120
		oPrint:Line( lin,   33,  lin, 3197 )   	// horizontal para diretoria 
		oPrint:Box(  460, 0030, 2020, 3200 )    // CAIXA GERAL
		oPrint:Box( 2020, 1270, 2090, 3200 )    // CAIXA DE TOTAIS     
		oPrint:Line( 460,  220, 2020,  220 )   	// vertical para baixo
		oPrint:Line( 460, 1270, 2090, 1270 )   	// vertical para baixo
		oPrint:Line( 460, 1520, 2090, 1520 )   	// vertical para baixo
		oPrint:Line( 460, 1800, 2090, 1800 )   	// vertical para baixo
		oPrint:Line( 460, 2080, 2090, 2080 )   	// vertical para baixo
		oPrint:Line( 460, 2360, 2090, 2360 )   	// vertical para baixo
		oPrint:Line( 460, 2640, 2090, 2640 )   	// vertical para baixo
		oPrint:Line( 460, 2930, 2090, 2930 )   	// vertical para baixo
		
	endif

	SZU->(DbSetOrder(2))
	SC7->(DbSetOrder(22)) // C7_FILIAL+C7_NUMSC+C7_ITEMSC
	SD1->(DbSetOrder(14)) // D1_FILIAL+D1_PEDIDO+D1_ITEMPC

	_cOrdSrv := TMB->ZA1_NUM
	_cCC     := TMB->ZA1_CC
	_nDProj  := TMB->ZA1_DCONTA
	_nVlrNeg := TMB->ZA1_VLNEGO
	
	While TMB->(!EOF()) .AND. TMB->ZA1_NUM == _cOrdSrv 
	
	    If !Empty(TMB->C1_NUM)
	    
		   _cOk := .T.
		   
		   //VERIFICA APROVACAO
		   SZU->(DbSetOrder(2))
		   SZU->(DbSeek(/*xFilial("SZU")*/TMB->C1_FILIAL+TMB->C1_NUM+TMB->C1_ITEM))
		   While !SZU->(Eof()) .AND. SZU->ZU_FILIAL==TMB->C1_FILIAL .And. SZU->ZU_NUM+SZU->ZU_ITEM == TMB->C1_NUM+TMB->C1_ITEM
			   If SZU->ZU_STATUS $ "C"
					_cOk := .F.
					Exit
			   Endif
			   SZU->(DbSkip())
		   Enddo
	
	       If _cOK
	           
	          If SC7->(Dbseek(/*xFilial("SC7")*/TMB->C1_FILIAL+TMB->C1_NUM+TMB->C1_ITEM)) //filial + num SC + Item SC
	             
	             While (!SC7->(Eof()) .AND. SC7->C7_FILIAL==TMB->C1_FILIAL .And. TMB->C1_NUM+TMB->C1_ITEM == SC7->C7_NUMSC+SC7->C7_ITEMSC)
		              //nao pega qdo o pedido esta c/ eliminação de residuo, mas pode pegar qdo tiver qtde já entregue e c/ eliminacao de residuo parcial
		             If Empty(SC7->C7_RESIDUO) .Or. (!Empty(SC7->C7_RESIDUO) .And. SC7->C7_QUJE > 0 )
		
			             If SD1->(Dbseek(/*xFilial("SD1")*/SC7->C7_FILIAL+SC7->C7_NUM+SC7->C7_ITEM)) //Filial + num pedido + item pedido       
			                
			                //Inclui os pedidos que foram atendidos parcialmente, sem eliminacao de residuo
			                If (SC7->C7_QUANT - SC7->C7_QUJE) > 0 .And. (SC7->C7_QUJE > 0 ) .And. Empty(SC7->C7_RESIDUO)
				                _nx := Ascan(_aOSAtiv, {|x| x[1]+x[5]== SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA+TMB->C1_NUMOS})
				                // Saldo a entregar  *   (preco unitario * aliq de ipi)  //traz valor de ipi unitario
				                If SC7->C7_IPI > 0  
				                   _nVlrPed := (SC7->C7_QUANT - SC7->C7_QUJE)* xMoeda( (SC7->C7_PRECO + ((SC7->C7_PRECO*SC7->C7_IPI)/100)) , SC7->C7_MOEDA, 1 , SC7->C7_EMISSAO)
				                Else
		      		                // Saldo a entregar  * preco unitario 
				                   _nVlrPed := (SC7->C7_QUANT - SC7->C7_QUJE)*  xMoeda( SC7->C7_PRECO , SC7->C7_MOEDA, 1 , SC7->C7_EMISSAO)
				                Endif
				                   
				          	    If _nx <> 0
				                   _aOSAtiv[_nx][4] +=  _nVlrPed
				                Else 
				                   Aadd(_aOSAtiv,{SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA,Dtoc(SC7->C7_EMISSAO),TMB->ZA2_CODCON,( _nVlrPed),TMB->C1_NUMOS,.F.})          	 
				                Endif       
				               //Para imprimir a primeira pagina c/ resumo da OS
				                _nx := Ascan(_aOSGer, {|x| x[1]== TMB->C1_NUMOS})             
				           	    If _nx <> 0
				                   _aOSGer[_nx][7] +=  _nVlrPed
				                Else 
				                   Aadd(_aOSGer,{TMB->C1_NUMOS,TMB->ZA2_ITEM,TMB->ZA2_CODCON,TMB->ZA2_DESCRI,TMB->ZA2_VTOT,TMB->ZA2_AVTOT,_nVlrPed,.F.})                                  
				                Endif   
				            Endif
	                        
							//verifica a existencia de varias notas p/ o mesmo pedido
	                        While (!SD1->(Eof()) .AND. SD1->D1_FILIAL == SC7->C7_FILIAL .And. SC7->C7_NUM+SC7->C7_ITEM == SD1->D1_PEDIDO+SD1->D1_ITEMPC)		                
			            
				             	//-- ALTERADO
				             	//-- JOAOFR 02/05/2012
				             	//-- OS 17112
				                _nx := Ascan(_aOSAtiv, {|x| x[1]+x[5]== SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+TMB->C1_NUMOS})
				          	    If _nx <> 0
				                   _aOSAtiv[_nx][4] += SD1->D1_TOTAL // (SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM
				                   _aOSAtiv[_nx][7] += SD1->D1_CUSTO // SD1->D1_TOTAL
				                Else 
				                   Aadd(_aOSAtiv,{SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA,;
				                   				 Dtoc(SD1->D1_DTDIGIT),"N",;
				                   				 SD1->D1_TOTAL,;    //(SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM,
				                   				 TMB->C1_NUMOS,.F.,;
				                   				 SD1->D1_CUSTO })   //SD1->D1_TOTAL})
				                Endif   
				                //Para imprimir a primeira pagina c/ resumo da OS
				                _nx := Ascan(_aOSGer, {|x| x[1]== TMB->C1_NUMOS})
					            
					            If _nx <> 0
				                   _aOSGer[_nx][7] +=  SD1->D1_TOTAL // CUSTO //(SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM
				                Else
				                   Aadd(_aOSGer,{TMB->C1_NUMOS,TMB->ZA2_ITEM,TMB->ZA2_CODCON,TMB->ZA2_DESCRI,TMB->ZA2_VTOT,TMB->ZA2_AVTOT,;
				                   				SD1->D1_TOTAL,;//CUSTO,; //(SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM,;
				                   				.F.})
	                        	Endif
				                
				                //-- os 054874 (26/08/2013) usuario: valdelenems
				                //-- autor: joaofr
				                //-- trazer as nf de frete
				                SF8->(dbsetorder(2))//F8_FILIAL+F8_NFORIG+F8_SERORIG+F8_FORNECE+F8_LOJA
				                If SF8->(DBSEEK(/*xFilial("SF8")*/SD1->D1_FILIAL+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)))
	
				                    cD1PrdIt := SD1->D1_COD+SD1->D1_ITEM //-- guarda para usar no seek abaixo
	
									aAreaSd1 := SD1->(getarea())
									
									SD1->(DBSETORDER(1))//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
									
			             			If SD1->(Dbseek(/*xFilial("SD1")*/SD1->D1_FILIAL+SF8->(F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN)+cD1PrdIt)) //Filial + num pedido + item pedido       
				             
						                _nx := Ascan(_aOSAtiv, {|x| x[1]+x[5]== SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+TMB->C1_NUMOS})
						          	    If _nx <> 0
						                   _aOSAtiv[_nx][4] += SD1->D1_TOTAL // (SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM
						                   _aOSAtiv[_nx][7] += SD1->D1_CUSTO // SD1->D1_TOTAL
						                Else 
						                   Aadd(_aOSAtiv,{SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA,;
						                   				 Dtoc(SD1->D1_DTDIGIT),"N",;
						                   				 SD1->D1_TOTAL,;    //(SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM,
						                   				 TMB->C1_NUMOS,.F.,;
						                   				 SD1->D1_CUSTO,TMB->C1_NUM, SD1->D1_PEDIDO })   //SD1->D1_TOTAL})
						                Endif   
						                //Para imprimir a primeira pagina c/ resumo da OS
						                _nx := Ascan(_aOSGer, {|x| x[1]== TMB->C1_NUMOS})
							            
							            If _nx <> 0
						                   _aOSGer[_nx][7] +=  SD1->D1_TOTAL //CUSTO //(SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM
						                Else
						                   Aadd(_aOSGer,{TMB->C1_NUMOS,TMB->ZA2_ITEM,TMB->ZA2_CODCON,TMB->ZA2_DESCRI,TMB->ZA2_VTOT,TMB->ZA2_AVTOT,;
						                   				SD1->D1_TOTAL,; //SD1->D1_CUSTO,; //(SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM,;
						                   				.F.})
						                Endif
						                
				                	ENDIF
				                	
				                	SD1->(restArea(aAreaSd1))
				                
				                ENDIF
	
				                SD1->(Dbskip())
				                
				            Enddo
				            
			             Else // inclui os pedidos de compras
			                If Empty(SC7->C7_RESIDUO)		             
				                _nx := Ascan(_aOSAtiv, {|x| x[1]+x[5]== SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA+TMB->C1_NUMOS})
				          	    If _nx <> 0
				                   _aOSAtiv[_nx][4] += xMoeda( (SC7->C7_TOTAL+SC7->C7_VALIPI) , SC7->C7_MOEDA, 1 , SC7->C7_EMISSAO)
				                Else 
				                   Aadd(_aOSAtiv,{SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA,Dtoc(SC7->C7_EMISSAO),TMB->ZA2_CODCON, xMoeda((SC7->C7_TOTAL+SC7->C7_VALIPI) , SC7->C7_MOEDA, 1 , SC7->C7_EMISSAO),TMB->C1_NUMOS,.F.})          	 
				                Endif       
				               //Para imprimir a primeira pagina c/ resumo da OS
				                _nx := Ascan(_aOSGer, {|x| x[1]== TMB->C1_NUMOS})             
				           	    If _nx <> 0
				                   _aOSGer[_nx][7] +=  xMoeda( (SC7->C7_TOTAL+SC7->C7_VALIPI) , SC7->C7_MOEDA,1,SC7->C7_EMISSAO)
				                Else 
				                   Aadd(_aOSGer,{TMB->C1_NUMOS,TMB->ZA2_ITEM,TMB->ZA2_CODCON,TMB->ZA2_DESCRI,TMB->ZA2_VTOT,TMB->ZA2_AVTOT, xMoeda((SC7->C7_TOTAL+SC7->C7_VALIPI) , SC7->C7_MOEDA, 1 , SC7->C7_EMISSAO),.F.})                                  
				                Endif   
				            Endif
			             Endif
			         Endif
			         SC7->(Dbskip())
			     Enddo    
		      Else // inclui a requisicao de compras somente as já aprovadas
		         If Empty(TMB->C1_RESIDUO)
		             _nx := Ascan(_aOSAtiv, {|x| x[1]+x[5]== TMB->C1_NUM+TMB->C1_FORNECE+TMB->C1_LOJA+TMB->C1_NUMOS})
		 	      	 If _nx <> 0
		                _aOSAtiv[_nx][4] +=  xMoeda( (TMB->C1_QUANT * TMB->C1_VUNIT),TMB->C1_MOEDA,1,TMB->C1_EMISSAO)
		             Else 
		                Aadd(_aOSAtiv,{TMB->C1_NUM+TMB->C1_FORNECE+TMB->C1_LOJA,Dtoc(TMB->C1_EMISSAO),TMB->ZA2_CODCON, xMoeda((TMB->C1_QUANT * TMB->C1_VUNIT),TMB->C1_MOEDA,1,TMB->C1_EMISSAO),TMB->C1_NUMOS,.F.})               
		             Endif   
		             //Para imprimir a primeira pagina c/ resumo da OS
		             _nx := Ascan(_aOSGer, {|x| x[1]== TMB->C1_NUMOS})             
			      	 If _nx <> 0
		                _aOSGer[_nx][7] +=  xMoeda( (TMB->C1_QUANT * TMB->C1_VUNIT) , TMB->C1_MOEDA, 1 , TMB->C1_EMISSAO) 
		             Else 
		                Aadd(_aOSGer,{TMB->C1_NUMOS,TMB->ZA2_ITEM,TMB->ZA2_CODCON,TMB->ZA2_DESCRI,TMB->ZA2_VTOT,TMB->ZA2_AVTOT, xMoeda((TMB->C1_QUANT * TMB->C1_VUNIT),TMB->C1_MOEDA,1,TMB->C1_EMISSAO),.F.})               
		             Endif   
		         Endif
	          Endif 
	          
	       Endif   
	    Endif
	
		TMB->(DbSkip())
	
	EndDo
	
	_aOSAtiv := ASort(_aOSAtiv,,, { |x, y| x[5]+x[3] < y[5]+y[3]})  //Ordena a matriz pelo numero da O.S.
		
	ZA2->(DbsetOrder(1))//Filial + numero + item
	If ZA2->(Dbseek(xFilial("ZA2")+_cOrdSrv)) //filial + num OS + Item OS
	   While !ZA2->(EOF()) .And. ZA2->ZA2_NUM == _cOrdSrv
	       
	       If Substr(ZA2->ZA2_NUM,1,2)$"DF/MM"
	       		_nx := Ascan(_aOSGer, {|x| ALLTRIM(SUBSTR(x[1],1,6))+ALLTRIM(x[2])$ZA2->ZA2_NUM+ZA2->ZA2_ITEM})             
	       ELSE
		  		_nx := Ascan(_aOSGer, {|x| ALLTRIM(x[1])+ALLTRIM(x[2])$ZA2->ZA2_NUM+ZA2->ZA2_ITEM})             
	       ENDIF	                            
	       If _nx == 0
	          Aadd(_aOSGer,{ZA2->ZA2_NUM+ZA2->ZA2_ITEM,ZA2->ZA2_ITEM,ZA2->ZA2_CODCON,ZA2->ZA2_DESCRI,ZA2->ZA2_VTOT,ZA2->ZA2_AVTOT,0,.F.})
	       Endif
	       
	       _nTotVO += ZA2->ZA2_VTOT
		   _nTotVA += ZA2->ZA2_AVTOT
		   
	      ZA2->(Dbskip())
	   Enddo   
	Endif
	
 	//-- pega também o valor aprovado e orçado das OSs complementares
 	ZAD->(dbsetorder(1))
    If ZAD->(DbSeek(xFilial("ZAD")+_cOrdSrv))//orderm de serviço complementar
  	      While !ZAD->(Eof()) .And. ZAD->ZAD_NUM == _cOrdSrv
  	   
	         _nTotVO += ZAD->ZAD_VTOT
	         _nTotVA += ZAD->ZAD_AVTOT
	     
	     	ZAD->(dbSkip())
	     EndDo
	Endif
	
	If _nTotVA == 0
	    _nGastoMat := _nGastoMao := _nTotVA := _nTotVO := 0
	    _aOSAtiv := {}
	    _aOSGer  := {}		
		Loop
	EndIf
	
	_aOSGer  := ASort(_aOSGer,,, { |x, y| x[2] < y[2]})  //Ordena a matriz pelo Item da O.S.

	For x := 1 to len(_aOSAtiv)
	
		If !ValType(_aOsAtiv[x][3]) == "N"
			_aOsAtiv[x][3] := Val(_aOsAtiv[x][3])
		EndIf
		
		If _aOsAtiv[x][3] < 20
			_nGastoMat += _aOSAtiv[x][4] //acumula os valores gastos com material 	
		Else
			If _aOsAtiv[x][3] >= 20
				_nGastoMao +=  _aOSAtiv[x][4] 
			EndIf
		EndIf
	Next

	oPrint:Say(lin+10,50,_cOrdSrv,oFont12) //num os  
	oPrint:Say(lin+10,250,_nDProj,oFont12) //descricao do projeto	
	
    // Os: 024317
    // autor: João Felipe da Rosa
    // data: 04/11/2011
    // desc: alterado valor negociado para centro de custo conforme conversado com patriciaff
    oPrint:Say(lin+10,1510,_cCC ,oFont12,,,,1) // centro de custo
	//fim os: 024317
	
	oPrint:Say(lin+10,1790,Transform(_nTotVO  / Iif(mv_par02==1,1000,1) ,"@e 9,999,999,999.99"),oFont12,,,,1) //valor orçado
	oPrint:Say(lin+10,2070,Transform(_nTotVA  / Iif(mv_par02==1,1000,1) ,"@e 9,999,999,999.99"),oFont12,,,,1) //valor aprovado

	oPrint:Say(lin+10,2350,Transform(_nGastoMat / Iif(mv_par02==1,1000,1),"@e 9,999,999,999.99"),oFont12,,,,1)   		//valor GASTO com material
	oPrint:Say(lin+10,2630,Transform((_NTotVA - _nGastoMat) / Iif(mv_par02==1,1000,1),"@e 9,999,999,999.99"),oFont12,,,,1)   		//saldo material
	oPrint:Say(lin+10,2910,Transform(_nGastoMao / Iif(mv_par02==1,1000,1),"@e 9,999,999,999.99"),oFont12,,,,1)   		//valor GASTO com MAO DE OBRA
	oPrint:Say(lin+10,3190,Transform(((_NTotVA - _nGastoMat)-_nGastoMao) / Iif(mv_par02==1,1000,1),"@e 99,999,999,999.99"),oFont12,,Iif(((_NTotVA - _nGastoMat)-_nGastoMao) / Iif(mv_par02==1,1000,1) < 0,CLR_HRED,CLR_BLACK),,1)   		//SALDO GASTO com MAO DE OBRA
	lin += 70
	
	oPrint:Line( lin, 33, lin, 3197 )   	 // horizontal para diretoria  

	_nTotal1 += _nVlrNeg
	_nTotal2 += _nTotVO 					 //total de valor orçado
	_nTotal3 += _nTotVA 					 // total de valor aprovado
	_nTotal4 += _nGastoMat 					 //total de gastos com material
	_nTotal5 += _NTotVA - _nGastoMat 		 //total de saldos material
	_nTotal6 += _nGastoMao //TME->GASTOMAO 	 //total de gastos com mao de obra
	_nTotal7 += (_NTotVA - _nGastoMat)-_nGastoMao//TME->GASTOMAO //total de saldos com gastos gerais
	
    _nGastoMat := _nGastoMao := _nTotVA := _nTotVO := 0
    _aOSAtiv := {}
    _aOSGer  := {}

EndDo

oPrint:Say(lin + 10, 070,OemToAnsi("Total ---->"), oFont12B)
oPrint:Say(lin + 10,1790,Transform(_nTotal2 / Iif(mv_par02==1,1000,1),"@e 9,999,999,999.99"),oFont12,,,,1)   		//valor orçado
oPrint:Say(lin + 10,2070,Transform(_nTotal3 / Iif(mv_par02==1,1000,1),"@e 9,999,999,999.99"),oFont12,,,,1)   		//valor aprovado

oPrint:Say(lin + 10,2350,Transform(_nTotal4 / Iif(mv_par02==1,1000,1),"@e 9,999,999,999.99"),oFont12,,,,1)   		//valor GASTO com material
oPrint:Say(lin + 10,2630,Transform(_nTotal5 / Iif(mv_par02==1,1000,1),"@e 9,999,999,999.99"),oFont12,,,,1)   		//saldo material
oPrint:Say(lin + 10,2910,Transform(_nTotal6 / Iif(mv_par02==1,1000,1),"@e 9,999,999,999.99"),oFont12,,,,1)   		//valor GASTO com MAO DE OBRA
oPrint:Say(lin + 10,3190,Transform(_nTotal7 / Iif(mv_par02==1,1000,1),"@e 9,999,999,999.99"),oFont12,,,,1)   		//valor GASTO com MAO DE OBRA

TMB->(DbCloseArea())                  
oPrint:EndPage() 		// Finaliza a pagina              
oPrint:Preview()  		// Visualiza antes de imprimir  

Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO ITENS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fRptDet3()
Local lin 			:= 500
Local _cDescSe
Local _nLinha
Local _nx
Local _aOSAtiv      := {}
Local _nVlrCon      := 0
Local _cOk          := .T.
Local _lPri         := .F.
Local _nTotA  := 0
Local _nTotC  := 0  
Local _nTotG  := 0  
Local _nGTotA := 0
Local _nGTotC := 0
Local _nGTotG := 0
Local _nVlrPed := 0
Local _nVlrGas := 0
Local _nVGasIt := 0
Local _nVlrGTo := 0 
Local _nTotOrc := 0
Local _cTipo   := Space(01)
Local _cForne  := Space(08)
Local oPrint,  _auxtotgrupo, _auxtotsoli

 i       := 1
 _aOSGer := {}
_nSaldo  := 0
_cConta  := Space(50)
_aTipon  := {"A=Ativo Diferido - Gastos Pre-Operacionais",;
             OemToAnsi("C=Compra de Material - Construções"),;
             OemToAnsi("F=Ferramental - Faturado p/ cliente"),;
             OemToAnsi("I=Instalações de Novas Máquinas"),;             
             OemToAnsi("P=Projeto de Melhoria,Ampliação Produção, Adequação da Linha, Reforma")}

Private cStartPath 	:= GetSrvProfString("Startpath","")

If Right(cStartPath,1) <> "\"
	cStartPath += "\"
Endif

_aOSGer := {}
                         
SC7->(DbsetOrder(22))//C7_FILIAL+C7_NUMSC+C7_ITEMSC
SD1->(DbsetOrder(14))
SZU->(DbSetOrder(2))

   	While TMB->(!EOF())
	
	    If !Empty(TMB->C1_NUM)
	    
		   _cOk := .T.
		   
		   //VERIFICA APROVACAO
		   SZU->(DbSetOrder(2))
		   SZU->(DbSeek(/*xFilial("SZU")*/TMB->C1_FILIAL+TMB->C1_NUM+TMB->C1_ITEM))
		   While !SZU->(Eof()) .AND. SZU->ZU_FILIAL==TMB->C1_FILIAL .And. SZU->ZU_NUM+SZU->ZU_ITEM == TMB->C1_NUM+TMB->C1_ITEM
			   If SZU->ZU_STATUS $ "C"
					_cOk := .F.
					Exit
			   Endif
			   SZU->(DbSkip())
		   Enddo
	
	       If _cOK
	           
	          If SC7->(Dbseek(/*xFilial("SC7")*/TMB->C1_FILIAL+TMB->C1_NUM+TMB->C1_ITEM)) //filial + num SC + Item SC
	             
	             While (!SC7->(Eof()) .AND. SC7->C7_FILIAL==TMB->C1_FILIAL .And. TMB->C1_NUM+TMB->C1_ITEM == SC7->C7_NUMSC+SC7->C7_ITEMSC)
		              //nao pega qdo o pedido esta c/ eliminação de residuo, mas pode pegar qdo tiver qtde já entregue e c/ eliminacao de residuo parcial
		             If Empty(SC7->C7_RESIDUO) .Or. (!Empty(SC7->C7_RESIDUO) .And. SC7->C7_QUJE > 0 )
		
			             If SD1->(Dbseek(/*xFilial("SD1")*/SC7->C7_FILIAL+SC7->C7_NUM+SC7->C7_ITEM)) //Filial + num pedido + item pedido       
			                
			                //Inclui os pedidos que foram atendidos parcialmente, sem eliminacao de residuo
			                If (SC7->C7_QUANT - SC7->C7_QUJE) > 0 .And. (SC7->C7_QUJE > 0 ) .And. Empty(SC7->C7_RESIDUO)
				                _nx := Ascan(_aOSAtiv, {|x| x[1]+x[2]+x[9]+x[11]== SC7->C7_NUM+SC7->C7_ITEM+TMB->C1_NUMOS+SC7->C7_FILIAL})
				                //  (preco unitario * aliq de ipi)  //traz valor de ipi unitario
				                If SC7->C7_IPI > 0  
				                   _nVlrPed := xMoeda( (SC7->C7_PRECO + ((SC7->C7_PRECO*SC7->C7_IPI)/100)) , SC7->C7_MOEDA, 1 , SC7->C7_EMISSAO)
				                Else
		      		                // preco unitario 
				                   _nVlrPed := xMoeda( SC7->C7_PRECO , SC7->C7_MOEDA, 1 , SC7->C7_EMISSAO)
				                Endif
				                   
				          	    If _nx <> 0
				                   _aOSAtiv[_nx][7] +=  _nVlrPed
				                Else 
				                   //Aadd(_aOSAtiv,{SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA,Dtoc(SC7->C7_EMISSAO),TMB->ZA2_CODCON,( _nVlrPed),TMB->C1_NUMOS,.F.})          	 
			                       Aadd(_aOSAtiv,{SC7->C7_NUM,SC7->C7_ITEM,SC7->C7_FORNECE+SC7->C7_LOJA,SC7->C7_PRODUTO,"P", (SC7->C7_QUANT - SC7->C7_QUJE), _nVlrPed,SC7->C7_DESCRI,TMB->C1_NUMOS,.F.,SC7->C7_FILIAL})

				                Endif       
				            Endif
	                        
							//verifica a existencia de varias notas p/ o mesmo pedido
	                        While (!SD1->(Eof()) .AND. SD1->D1_FILIAL == SC7->C7_FILIAL .And. SC7->C7_NUM+SC7->C7_ITEM == SD1->D1_PEDIDO+SD1->D1_ITEMPC)		                
			            
				             	//-- ALTERADO
				             	//-- JOAOFR 02/05/2012
				             	//-- OS 17112
				                _nx := Ascan(_aOSAtiv, {|x| x[1]+x[2]+x[3]+x[9]+x[11]== SD1->D1_DOC+'/'+SD1->D1_SERIE+SD1->D1_ITEM+SD1->D1_FORNECE+SD1->D1_LOJA+TMB->C1_NUMOS+SD1->D1_FILIAL})
				          	    If _nx <> 0
				                   _aOSAtiv[_nx][7] += 	SD1->D1_VUNIT // (SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM
				                   //_aOSAtiv[_nx][7] += SD1->D1_CUSTO // SD1->D1_TOTAL
				                Else 
				                   Aadd(_aOSAtiv,{SD1->D1_DOC+'/'+SD1->D1_SERIE, SD1->D1_ITEM,;
					                   				  SD1->D1_FORNECE+SD1->D1_LOJA,;
					                   				  SD1->D1_COD,"N",;
					                   				  SD1->D1_QUANT,;    
					                   				  SD1->D1_VUNIT,;
					                   				  SD1->D1_DESCRI,;
					                   				  TMB->C1_NUMOS,.F.,;
					                   				  SD1->D1_FILIAL})
		
						                
				                Endif   
				                
				                //-- os 054874 (26/08/2013) usuario: valdelenems
				                //-- autor: joaofr
				                //-- trazer as nf de frete
				                SF8->(dbsetorder(2))//F8_FILIAL+F8_NFORIG+F8_SERORIG+F8_FORNECE+F8_LOJA
				                If SF8->(DBSEEK(/*xFilial("SF8")*/SD1->D1_FILIAL+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)))
	
				                    cD1PrdIt := SD1->D1_COD+SD1->D1_ITEM //-- guarda para usar no seek abaixo
	
									aAreaSd1 := SD1->(getarea())
									
									SD1->(DBSETORDER(1))//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
									
			             			If SD1->(Dbseek(/*xFilial("SD1")*/SD1->D1_FILIAL+SF8->(F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN)+cD1PrdIt)) //Filial + num pedido + item pedido       
				             
						                _nx := Ascan(_aOSAtiv, {|x| x[1]+x[2]+x[3]+x[9]+x[11]== SD1->D1_DOC+'/'+SD1->D1_SERIE+SD1->D1_ITEM+SD1->D1_FORNECE+SD1->D1_LOJA+TMB->C1_NUMOS+SD1->D1_FILIAL})
						          	    If _nx <> 0
						                   _aOSAtiv[_nx][7] += SD1->D1_VUNIT // (SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM
						                   //_aOSAtiv[_nx][7] += SD1->D1_CUSTO // SD1->D1_TOTAL
						                Else 
						                   Aadd(_aOSAtiv,{SD1->D1_DOC+'/'+SD1->D1_SERIE, SD1->D1_ITEM,;
						                   				  SD1->D1_FORNECE+SD1->D1_LOJA,;
						                   				  SD1->D1_COD,"N",;
						                   				  SD1->D1_QUANT,;    
						                   				  SD1->D1_VUNIT,;
					    	               				  SD1->D1_DESCRI,;
					        	           				  TMB->C1_NUMOS,.F.,;
					        	           				  SD1->D1_FILIAL})
		                   				   
						                Endif   
						                
				                	ENDIF
				                	
				                	SD1->(restArea(aAreaSd1))
				                
				                ENDIF
	
				                SD1->(Dbskip())
				                
				            Enddo
				            
			             Else // inclui os pedidos de compras
			                If Empty(SC7->C7_RESIDUO)		             
				                _nx := Ascan(_aOSAtiv, {|x| x[1]+x[2]+x[9]+x[11]== SC7->C7_NUM+SC7->C7_ITEM+TMB->C1_NUMOS+SC7->C7_FILIAL})
				          	    
				                //  (preco unitario * aliq de ipi)  //traz valor de ipi unitario
				                If SC7->C7_IPI > 0  
				                   _nVlrPed := xMoeda( (SC7->C7_PRECO + ((SC7->C7_PRECO*SC7->C7_IPI)/100)) , SC7->C7_MOEDA, 1 , SC7->C7_EMISSAO)
				                Else
		      		                // preco unitario 
				                   _nVlrPed := xMoeda( SC7->C7_PRECO , SC7->C7_MOEDA, 1 , SC7->C7_EMISSAO)
				                Endif
				          	    
				          	    If _nx <> 0
				                   _aOSAtiv[_nx][7] += _nVlrPed
				                Else 
				                   //Aadd(_aOSAtiv,{SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA,Dtoc(SC7->C7_EMISSAO),TMB->ZA2_CODCON, xMoeda((SC7->C7_TOTAL+SC7->C7_VALIPI) , SC7->C7_MOEDA, 1 , SC7->C7_EMISSAO),TMB->C1_NUMOS,.F.})          	 
								   Aadd(_aOSAtiv,{SC7->C7_NUM,SC7->C7_ITEM,SC7->C7_FORNECE+SC7->C7_LOJA,SC7->C7_PRODUTO,"P", (SC7->C7_QUANT - SC7->C7_QUJE), _nVlrPed,SC7->C7_DESCRI,TMB->C1_NUMOS,.F.,SC7->C7_FILIAL})
				                Endif       
				            Endif
			             Endif
			         Endif
			         SC7->(Dbskip())
			     Enddo    
		      Else // inclui a requisicao de compras
		         If Empty(TMB->C1_RESIDUO)
		             _nx := Ascan(_aOSAtiv, {|x| x[1]+x[2]+x[9]+x[11]== TMB->C1_NUM+TMB->C1_ITEM+TMB->C1_NUMOS+TMB->C1_FILIAL})
		 	      	 If _nx <> 0
		                _aOSAtiv[_nx][7] +=  xMoeda( TMB->C1_VUNIT,TMB->C1_MOEDA,1,TMB->C1_EMISSAO)
		             Else 
		                //Aadd(_aOSAtiv,{TMB->C1_NUM+TMB->C1_FORNECE+TMB->C1_LOJA,Dtoc(TMB->C1_EMISSAO),TMB->ZA2_CODCON, xMoeda((TMB->C1_QUANT * TMB->C1_VUNIT),TMB->C1_MOEDA,1,TMB->C1_EMISSAO),TMB->C1_NUMOS,.F.})               
		    	     	Aadd(_aOSAtiv,{TMB->C1_NUM,TMB->C1_ITEM,TMB->C1_FORNECE+TMB->C1_LOJA,TMB->C1_PRODUTO,"S",TMB->C1_QUANT, xMoeda(TMB->C1_VUNIT,TMB->C1_MOEDA,1,TMB->C1_EMISSAO),TMB->C1_DESCRI,TMB->C1_NUMOS,.F.,TMB->C1_FILIAL})               		                
		             Endif   
		         Endif
	          Endif 
	          
	       Endif   
	    Endif
	
		TMB->(DbSkip())
	
		EndDo
	
If Len(_aOSAtiv)==0 //Verifica se não encontrou a solicitação de nota na visualização
   Msgbox(OemToAnsi("Nao Existe Nenhuma Movimentação para a O.S. Selecionada, Verifique !!!4") ,"Atencao","ALERT" )     
   TMB->(DbCloseArea())
   return
Endif 

_aOSAtiv := ASort(_aOSAtiv,,,{ |x, y| x[9]+x[5]+x[3]+x[4] < y[9]+y[5]+y[3]+y[4]})  //Ordena a matriz pelo produto + tipo + cod controle

_auxtotgrupo := 0 
_auxtotger :=  0
_auxtotsoli := 0

TMB->(DbGotop())

oPrint := TMSPrinter():New( "ITENS DE PEDIDO") 
oPrint:SetPortrait() // ou SetLandscape()
oPrint:Setup()//chama janela para escolher impressora, orientacao da pagina etc...
oPrint:StartPage() 		// Inicia uma nova pagina
i:= 1 					//Volta o numero da pagina em 1

oPrint:SayBitmap(015,0015, cStartPath+"\Whbl.bmp",328,140)
oPrint:Say(070,2120,"Pag:",oFont10 ) //"Pagina :"
oPrint:Say(070,2220,StrZero(i,3),oFont10)
oPrint:Say(170,040,"Data:",oFont12)
oPrint:Say(170,145,Dtoc(dDatabase),oFont12) 
oPrint:Say(170,700,OemToAnsi("DETALHE DE ITENS POR O.S."),oFont12B)
oPrint:Say(170,2070,"Hora:",oFont12 ) //"Pagina :"
oPrint:Say(170,2175,Subs(Time(),1,5),oFont12)
oPrint:Say(310,0040,"Numero OS",oFont12)
oPrint:Say(310,0300,TMB->ZA1_NUM,oFont12B)
oPrint:Say(310,0800,OemToAnsi("Conta Contabil:"),oFont12)

oPrint:Say(310,1100,OemToAnsi(TMB->ZA1_CONTA),oFont12b)
oPrint:Say(310,1500,OemToAnsi(TMB->ZA1_DCONTA),oFont12b)  	   

oPrint:Say(400,040,OemToAnsi("Numero"),oFont12B)
oPrint:Say(400,310,OemToAnsi("Codigo Prod."),oFont12B)
oPrint:Say(400,600,OemToAnsi("Descrição"),oFont12B)
oPrint:Say(400,1700,OemToAnsi("Qtde"),oFont12B)
oPrint:Say(400,1900,OemToAnsi("Vlr.Unit. Custo"),oFont12B)
oPrint:Say(400,2100,OemToAnsi("Vlr.Total Custo"),oFont12B)
oPrint:Box(460, 0030, 3200, 2370 )
                    
_auxitem := substr(TMB->C1_NUMOS,7,4)
_auxtipo := '' //TMH->TIPO 
_auxsoli := TMB->C1_NUMOS

ZA2->(Dbseek(xFilial("ZA2")+_aOSAtiv[1][9])) //filial + num OS + Item OS
oPrint:Say(490,040,ZA2->ZA2_CODCON +" - "+ ZA2->ZA2_DESCRI + OemToAnsi("             Valor Total:")+Transform(ZA2->ZA2_AVTOT,"@e 9,999,999,999.99"),oFont12B)
SA2->(Dbseek(xFilial("SA2")+_aOSAtiv[1][3])) //filial + num OS + Item OS
oPrint:Say(560,040,SA2->A2_COD + ' - ' + SA2->A2_LOJA +' '+SA2->A2_NOME,oFont12b)

//*********** ITENS NOVOS *********
_cCodCon := _aOSAtiv[1][9] //guarda codigo de controle
_cTipo   := _aOSAtiv[1][5]  // Guarda tipo 
_cForne  := _aOSAtiv[1][3]  // Guarda fornecedor 
lin:= 570                      
For _nx:= 1 to Len(_aOSAtiv)

    if lin > 2900
			oPrint:EndPage() 		// Finaliza a pagina              
			oPrint:StartPage() 		// Inicia uma nova pagina
			i++
			Cabecalho2(oPrint,i)
			oPrint:Box( 460, 0030, 3200, 2370 )
			lin:= 500	
	endif

    //Exibe valor gasto por NF = nota fiscal, PC= pedido de compra e SC = Solicitaçao de compra
    If _aOSAtiv[_nx][5] <> _cTipo

        lin += 070
        oPrint:Say(lin,1500,"O Valor Gasto de " + Iif(_cTipo$"N","Nota Fiscal  : ",Iif(_cTipo$"P","Pedido  : ","Solicitação  : ")),oFont10B)
        oPrint:Say(lin,2050,Transform( _nVlrGas,"@e 9,999,999,999.99"),oFont10B)
        _cTipo   := _aOSAtiv[_nx][5]  // Guarda tipo 
        _nVlrGTo += _nVlrGas //Soma valor total de gasto
        _nVlrGas := 0        

    Endif
    
    lin += 70
       
    If  _cCodCon <>  _aOSAtiv[_nx][9] //Verifica codigo de controle
    
        If _nVlrGas  > 0 //imprime o valor gasto antes do saldo se ainda nao imprimiu
           lin += 070
           oPrint:Say(lin,1500,"O Valor Gasto de " + Iif(_cTipo$"N","Nota Fiscal  : ",Iif(_cTipo$"P","Pedido  : ","Solicitação  : ")),oFont10B)
           oPrint:Say(lin,2050,Transform( _nVlrGas,"@e 9,999,999,999.99"),oFont10B)
           _cTipo   := _aOSAtiv[_nx][5]  // Guarda tipo
           _nVlrGTo += _nVlrGas //Soma valor total de gasto
           _nVlrGas := 0
           lin += 070
        Endif

        oPrint:Say(lin,1700,"O Valor Gasto : ",oFont10B)
        oPrint:Say(lin,2050,Transform( _nVGasIt ,"@e 9,999,999,999.99"),oFont10B)
        _nVGasIt := 0  // zera a variavel de gasto por item da OS.
		lin += 60
        oPrint:Line( lin, 33, lin, 2300 )   	// horizontal para diretoria
		lin += 70    

	    if lin > 2900
			oPrint:EndPage() 		// Finaliza a pagina              
			oPrint:StartPage() 		// Inicia uma nova pagina
			i++
			Cabecalho2(oPrint,i)
			oPrint:Box( 460, 0030, 3200, 2370 )
			lin:= 500	
		endif

	    ZA2->(Dbseek(xFilial("ZA2")+_aOSAtiv[_nx][9])) //filial + num OS + Item OS
		If lin <> 630
	       oPrint:Say(Lin,040,ZA2->ZA2_CODCON +" - "+ ZA2->ZA2_DESCRI + OemToAnsi("             Valor Total:")+Transform(ZA2->ZA2_AVTOT,"@e 9,999,999,999.99"),oFont12B)
 		   lin += 70    	
 		   
 		   If SA2->(Dbseek(xFilial("SA2")+_aOSAtiv[_nx][3])) //filial + num OS + Item OS
              oPrint:Say(Lin,040,SA2->A2_COD + ' - ' + SA2->A2_LOJA +' '+SA2->A2_NOME,oFont12b)
   		      lin += 70    	
   		   Endif   

		Endif   

	    _nVlrCon := ZA2->ZA2_AVTOT		
        _cCodCon := _aOSAtiv[_nx][9] //guarda codigo de controle    
        _cForne  := _aOSAtiv[_nx][3] //guarda fornecedor
    Endif
    
    If _cForne <> _aOSAtiv[_nx][3]
       If SA2->(Dbseek(xFilial("SA2")+_aOSAtiv[_nx][3])) //filial + num OS + Item OS
          oPrint:Say(Lin,040,SA2->A2_COD + ' - ' + SA2->A2_LOJA +' '+SA2->A2_NOME,oFont12b)
          lin += 70    	
       Endif   
       _cForne := _aOSAtiv[_nx][3]       
    Endif  
    
    oPrint:Say(lin,0040,_aOSAtiv[_nx][5],oFont10B)
    oPrint:Say(lin,0060,_aOSAtiv[_nx][1],oFont10)  			      			
	oPrint:Say(lin,0310,_aOSAtiv[_nx][4],oFont10)  	
	oPrint:Say(lin,0600,SUBSTR(_aOSAtiv[_nx][8],0,40),oFont10)  	
	oPrint:Say(lin,1700,Transform(_aOSAtiv[_nx][6],"@E 9,999.99"),oFont10)  	
	oPrint:Say(lin,1900,Transform(_aOSAtiv[_nx][7],"@E 999,999.99"),oFont10)  	
	
	//No caso de frete a quantidade é zero então multiplica por 1.
	oPrint:Say(lin,2100,Transform(IIF(_aOSAtiv[_nx][6]==0,1,_aOSAtiv[_nx][6])*_aOSAtiv[_nx][7],"@E 9,999,999.99"),oFont10) 

    _nVlrGas += IIF(_aOSAtiv[_nx][6]==0,1,_aOSAtiv[_nx][6]) * _aOSAtiv[_nx][7] //SOMA V.UNIT X QUANT. No caso de frete a quantidade é zero então multiplica por 1. (POR TIPO, N,P,S)
    _nVGasIt += IIF(_aOSAtiv[_nx][6]==0,1,_aOSAtiv[_nx][6]) * _aOSAtiv[_nx][7] //SOMA V.UNIT X QUANT. No caso de frete a quantidade é zero então multiplica por 1. (por Item da O.S.)

    _nSaldo  -= IIF(_aOSAtiv[_nx][6]==0,1,_aOSAtiv[_nx][6]) * _aOSAtiv[_nx][7] // diminui as entradas referentes a OS
    _nVlrCon -= IIF(_aOSAtiv[_nx][6]==0,1,_aOSAtiv[_nx][6]) * _aOSAtiv[_nx][7] // diminui as entradas referentes a OS

Next _nx

lin += 070
oPrint:Say(lin,1500,"O Valor Gasto de " + Iif(_cTipo$"N","Nota Fiscal : ",Iif(_cTipo$"P","Pedido : ","Solicitação : ")),oFont10B)
oPrint:Say(lin,2050,Transform( _nVlrGas,"@e 9,999,999,999.99"),oFont10B)
_nVlrGTo += _nVlrGas //Soma valor total de gasto
_nVlrGas := 0        

lin += 70
oPrint:Say(lin,1700,"O Valor Gasto : ",oFont10B)        
oPrint:Say(lin,2050,Transform( _nVGasIt ,"@e 9,999,999,999.99"),oFont10B)                

 _nVGasIt := 0  // zera a variavel de gasto por item da OS.       
lin += 60            
oPrint:Line( lin, 33, lin, 2300 )   	// horizontal para diretoria  

//Traz o valor Aprovado dos materiais
_nTotOrc := 0
ZA2->(Dbseek(xFilial("ZA2")+Subs(_aOSAtiv[1][9],1,6)+"0001")) //filial + num OS + Item OS
While (!ZA2->(Eof()) .And. ZA2->ZA2_NUM == Subs(_aOSAtiv[1][9],1,6) )
	_nTotOrc += ZA2->ZA2_AVTOT
   ZA2->(Dbskip())
Enddo    

//-- pega também o valor aprovado e orçado das OSs complementares
ZAD->(dbsetorder(1))
If ZAD->(DbSeek(xFilial("ZAD")+Subs(_aOSAtiv[1][9],1,6)+"0001"))//orderm de serviço complementar
	While !ZAD->(Eof()) .And. ZAD->ZAD_NUM == Subs(_aOSAtiv[1][9],1,6)
		_nTotOrc += ZAD->ZAD_AVTOT		
		ZAD->(dbSkip())
	EndDo
Endif

lin += 70
oPrint:Say(lin,1500," O Valor Total Aprovado: ",oFont10B)
oPrint:Say(lin,2050,Transform(_nTotOrc,"@e 9,999,999,999.99"),oFont10B)

lin += 80
oPrint:Say(lin,1500," O Valor Total Gasto: ",oFont10B)
oPrint:Say(lin,2050,Transform(_nVlrGto,"@e 9,999,999,999.99"),oFont10B)

lin += 90
oPrint:Say(lin,1500," O Saldo: ",oFont10B)
oPrint:Say(lin,2050,Transform(_nTotOrc-_nVlrGto,"@e 9,999,999,999.99"),oFont10B)

_nVlrGto := 0
TMB->(DbCloseArea())                  
oPrint:EndPage() 		// Finaliza a pagina              
oPrint:Preview()  		// Visualiza antes de imprimir  

Return Nil

Static Function Cabecalho2(oPrint,i)

	oPrint:SayBitmap(015,0015, cStartPath+"\Whbl.bmp",328,140)
	oPrint:Say(070,2120,"Pag:",oFont10 ) //"Pagina :"
	oPrint:Say(070,2220,StrZero(i,3),oFont10)
	oPrint:Say(170,040,"Data:",oFont12)
	oPrint:Say(170,145,Dtoc(dDatabase),oFont12) 
	oPrint:Say(170,700,OemToAnsi("DETALHE DE ITENS POR O.S."),oFont12B)
	oPrint:Say(170,2070,"Hora:",oFont12 ) //"Pagina :"
	oPrint:Say(170,2175,Subs(Time(),1,5),oFont12)
	oPrint:Say(310,0040,"Numero OS",oFont12)
	oPrint:Say(310,0300,SUBSTR(TMB->ZA1_NUM,0,6),oFont12B)	
	oPrint:Say(310,0800,OemToAnsi("Conta Contabil:"),oFont12)
	
	oPrint:Say(310,1100,OemToAnsi(TMB->ZA1_CONTA),oFont12b)
	oPrint:Say(310,1500,OemToAnsi(TMB->ZA1_DCONTA),oFont12b)  	   
	
	oPrint:Say(400,040,OemToAnsi("Numero  Codigo Prod.    Descrição                                                                      Qtde    Vlr.Unit.Custo   Vlr.Total Custo"),oFont12B)
	oPrint:Box(460, 0030, 3200, 2370 )

Return

Static Function fCli()
Local lRet := .T.

	IF !EMPTY(_cCli) .OR. !EMPTY(_cLoja)
		If SA1->(DbSeek(xFilial("SA1")+_cCli+_cLoja ))                
		   If SA1->(Found())            
	   	      _cNomCli := SA1->A1_NOME
	          ObjectMethod(ocNomCli , "Refresh()")          	   
	       Endif
	    Else   
		    MsgBox("Cliente nao encontrado, Escolha um Cliente Valido !","STOP","Composicao do Codigo do Produto")
		    lRet := .F.
		Endif	          
	EndIf
		
Return (lRet)
                
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄĞ
//³ FINALIZA A O.S. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄĞ
User Function fFinali()

	//Constroi tela
	DEFINE MSDIALOG oDlg FROM 0,0 TO 100,230 PIXEL TITLE "Encerramento de O.S."

    @ 010,010 SAY "O.S.: "+ZA1->ZA1_NUM SIZE 040,008 PIXEL OF oDlg
   	@ 030,010 BUTTON "_Encerrar" SIZE 30,15 ACTION U_fFinalOk(1) OBJECT OBT1
   	@ 030,045 BUTTON "_Reabrir"  SIZE 30,15 ACTION U_fFinalOk(2) OBJECT OBT2
   	@ 030,080 BUTTON "_Cancelar" SIZE 30,15 ACTION oDlg:End()    OBJECT OBT3

	ACTIVATE MSDIALOG oDlg CENTER 

Return
       
User Function fFinalOk(nAcao)
	
	If nAcao == 1 //encerrar

		If ZA1->ZA1_ENCERA == 'S'
			MsgBox("O.S. já finalizada!","Finalizada","INFO")
			Return
		ElseIf MsgYesNo("Deseja encerrar a O.s.?")
			RecLock("ZA1",.F.)
				ZA1->ZA1_ENCERA := 'S'
			MsUnlock("ZA1")
		EndIf

	ElseIf nAcao == 2 //reabrir

		If ZA1->ZA1_ENCERA == 'N'
			MsgBox("O.S. já está aberta!","Aberta","INFO")
			Return
		ElseIf MsgYesNo("Deseja reabrir a O.S.?")
			RecLock("ZA1",.F.)
				ZA1->ZA1_ENCERA := 'N'
			MsUnlock("ZA1")
		EndIf

	EndIf
	
	oDlg:End()
	
Return