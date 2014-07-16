/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST092  ºAutor  ³Marcos R Roquitski  º Data ³  25/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de Lista de Ferramentas.                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracao ³ Por Alexandre R. Bento                                     º±±
±±º 25/08/08 ³ Modificado todo a estrutura do programa. Tabelas(ZA7/ZAZ)  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"                                                                     
#include "protheus.ch"
#include "Topconn.ch"
#include "FIVEWIN.CH"
#include "DbTree.ch"
#include "Colors.ch"

User Function Nhest129()
SetPrvt("aRotina,cCadastro,_cList,_cOperc,aHeader,acols")

Private cCadastro := "Cadastro de Lista de Ferramentas"

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
                     {"Visualizar","U_fVisua()",0,2} ,;
                     {"Incluir","U_fListaf()",0,3} ,;
                     {"Ferramenta","U_fFerram(3)",0,3} ,;                     
                     {"Alterar","U_fFerram(2)",0,2} ,;                     
                     {"Desenho","U_fDese(1)",0,5} }

             
ZA7->(DbGotop())
mBrowse(,,,,"ZA7",,,)
Return
//                     {"Alterar","AxAltera",0,4} ,;
//                     {"Excluir","AxDeleta",0,5} ,;


User Function fFerram(_cPar)

SetPrvt("oWhb,_lPesq,_lDlg,_cProd,_cDesc,_cProdLi,_cDescLi,_cProdFo,_cDescFo,aBotoes1,_x, _dData,_cOpera,_cPara")
Private nOpc   := 0
Private bOk    := {||nOpc:=1,oWhb:End()}
Private bCancel:= {||nOpc:=0,oWhb:End()} 

//Alert(_cpar)
_cPara   := _cpar    
_lPesq   := .T.
_lDlg    := .T.
_cProd   := Space(15)
_cDesc   := Space(30)
_cProdLi := Space(15)
_cDescLi := Space(30)
_cProdFo := Space(15)
_cDescFo := Space(30)                                  
 _dData  := dDatabase
_cOpera  := Space(03) 
aHeader  := {}
aCols    := {}

If _lPesq 
   fPesqFer()
Endif

If _lDlg 
	DbSelectArea("ZAZ")
	
//    If _cpar$"3"
		Aadd(aHeader,{"Ferramenta" , "ZAZ_FCOD"   , Repli("!",15) ,15,0,".T.","","C","ZAZ"}) //03
		Aadd(aHeader,{"Descricao"  , "B1_DESC"    , Repli("!",30) ,30,0,".F.","","C","SB1"}) //06
		Aadd(aHeader,{"ID Fer."    , "ZAZ_IDFER"  , Repli("!",03) ,03,0,".T.","","C","ZAZ"}) //06
		Aadd(aHeader,{"Quantidade" , "ZAZ_QTDE"   , "@E 999999"   ,06,0,".T.","","N","ZAZ"}) //06
		Aadd(aHeader,{"VC Minimo"  , "ZAZ_VC"     , "@E 999"      ,03,0,".T.","","N","ZAZ"}) //06
		Aadd(aHeader,{"Avanco"     , "ZAZ_ARESTA" , "@E 99.99"    ,05,2,".T.","","N","ZAZ"}) //06
		Aadd(aHeader,{"Vida Util"  , "ZAZ_VIDAUT" , "@E 999999"   ,06,0,".T.","","N","ZAZ"}) //06
		Aadd(aHeader,{"Qt.Reaf"    , "ZAZ_REAFIA" , "@E 999"      ,03,0,".T.","","N","ZAZ"}) //06
  /*	Else
		Aadd(aHeader,{"Ferramenta" , "ZAZ_FCOD"   , Repli("!",15) ,15,0,".F.","","C","ZAZ"}) //03
		Aadd(aHeader,{"Descricao"  , "B1_DESC"    , Repli("!",30) ,30,0,".F.","","C","SB1"}) //06
		Aadd(aHeader,{"ID Fer."    , "ZAZ_IDFER"  , Repli("!",03) ,03,0,".F.","","C","ZAZ"}) //06
		Aadd(aHeader,{"Quantidade" , "ZAZ_QTDE"   , "@E 999999"   ,06,0,".F.","","N","ZAZ"}) //06
		Aadd(aHeader,{"VC Minimo"  , "ZAZ_VC"     , "@E 999"      ,03,0,".F.","","N","ZAZ"}) //06
		Aadd(aHeader,{"Avanco"     , "ZAZ_ARESTA" , "@E 99.99"    ,05,2,".F.","","N","ZAZ"}) //06
		Aadd(aHeader,{"Vida Util"  , "ZAZ_VIDAUT" , "@E 999999"   ,06,0,".F.","","N","ZAZ"}) //06
		Aadd(aHeader,{"Qt.Reaf"    , "ZAZ_REAFIA" , "@E 999"      ,03,0,".F.","","N","ZAZ"}) //06
	
	Endif	
	*/
	Define MsDialog oWhb Title OemToAnsi("Lista de Ferramentas") From 020,030 To 430,865 Pixel 
	@ 020,006 To 073,415 Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE
	
	@ 035,010 Say "Produto:"  Size 60,8 Object oPro            
	@ 033,050 Get _cProd Picture "@!" When(_cPara==2) Size 50,8 Object oProd            
	@ 033,105 Get _cDesc Picture "@!" When(.f.) Size 130,8 Object oDesc
	
	@ 035,250 Say "Data:" Size 30,8 Object oDat             
	@ 033,275 Get _dData Picture "99/99/9999" When .F. Size 35,8 Object oData            
	
	@ 048,010 Say "L.Ferramenta:"   Size 60,8 Object oProdl            
	@ 046,050 Get _cProdLi Picture "@!" When(_cPara==2) Size 50,8 Object oProdLi            
	@ 046,105 Get _cDescLi Picture "@!" When(.f.) Size 130,8 Object oDesc
	
	@ 048,250 Say OemToAnsi("Operação:") Size 30,8 Object oOpe             
	@ 046,275 Get _cOpera Picture "@!" When(_cPara==2) Size 30,8 Object oOpera            
	
	@ 061,010 Say "F.Ferramenta:" Size 60,8 Object oProdF            
	@ 059,050 Get _cProdFo Picture "@!" When(_cPara==2) Size 50,8 Object oProdFo            
	@ 059,105 Get _cDescFo Picture "@!" When(.f.) Size 150,8 Object oDesc
	
	@ 078,006 To 200,415 Title OemToAnsi(" Ferramestas ")  
	@ 085,010 TO 195,410 MULTILINE MODIFY Valid fMFer() OBJECT oMultiline
	oMultiline:Refresh()
	
	//oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline
	
	Activate MsDialog oWhb On Init EnchoiceBar(oWhb,bOk,bCancel,,) Centered
	
	If nOpc == 1
//       If _cpar$"3"	
		  ZAZ->(DbSetOrder(1)) //filial + produto principal + Lista Ferramenta + Folha Ferramenta         	
		  ZAZ->(DbSeek(xFilial("ZAZ")+_cProd+_cProdLi+_cProdFo ))   
		  If !ZAZ->(Found())
		      
		     For _x:=1 to len(acols)
				   Reclock("ZAZ",.T.) //tabela de movimento
				      ZAZ->ZAZ_FILIAL := xFilial("ZAZ")
				      ZAZ->ZAZ_PRODUT := _cProd      //codido do produto
				      ZAZ->ZAZ_FFER   := _cProdFo    //codido da Folha de ferramenta
				      ZAZ->ZAZ_LF     := _cProdLi   //codido da lista de ferrramentas
				      ZAZ->ZAZ_FCOD   := acols[_x,1] //codigo da ferramenta
				      ZAZ->ZAZ_IDFER  := acols[_x,3] //Id da ferramenta
		//		      ZA7->ZA7_DATA   := dDatabase
				      ZAZ->ZAZ_QTDE   := acols[_x,4]
				      ZAZ->ZAZ_VC     := acols[_x,5]
				      ZAZ->ZAZ_ARESTA := acols[_x,6]
				      ZAZ->ZAZ_VIDAUT := acols[_x,7]
				      ZAZ->ZAZ_REAFIA := acols[_x,8]
				      
				   MsUnlock("ZAZ")
				   
			 Next _x	  
		  Else
			   MsgBox("Produto Já Contem Ferramenta Cadastrada Para este Produto","Atençao","ALERT")    
		  Endif  
		
		  nOpc  := 3
		  _lPesq   := .F.
  //	   Else
	   
	   Endif
	Endif //finaliza o dialogo
	
Return


Static Function fPesqFer()
Local cQuery

   cQuery := "SELECT * "
   cQuery += " FROM " +  RetSqlName( 'ZA7' ) 
   cQuery += " WHERE ZA7_FILIAL = '" + xFilial("ZA7")+ "'" 
   cQuery += " AND ZA7_PRODUT = '" + ZA7->ZA7_PRODUT + "'" 
   cQuery += " AND ZA7_LF = '"`+ ZA7->ZA7_LF + "'" 
   cQuery += " AND ZA7_FER = '" + ZA7->ZA7_FER + "'"    
   cQuery += " AND D_E_L_E_T_ = ' '"
   //MemoWrit('C:\TEMP\ESTPED.SQL',cQuery1)
   //TCQuery Abre uma workarea com o resultado da query
   TCQUERY cQuery NEW ALIAS "FER"  
  // DbSelectArea("PRI")    
   FER->(DBGotop())            
   
   ZAZ->(DbSetOrder(1)) //filial + produto principal + Lista Ferramenta + Folha Ferramenta         
   If ZAZ->(DbSeek(xFilial("ZAZ")+FER->ZA7_PRODUT+FER->ZA7_LF+FER->ZA7_FER))   
      MsgBox("Produto Já Contem Ferramenta Cadastrada 1 ","Atençao","ALERT")       
      FER->(DBCloseArea())            
      _lDlg   := .F. //nao permite abrir o dialogo, pois já existe ferramenta cadastrada
	  Return
   Endif

   _cProd   := FER->ZA7_PRODUT
   SB1->(DbsetOrder(1)) //filial+codigo  do produto
   SB1->(dbSeek(xFilial("SB1")+_cProd,.T. ))
   _cDesc   := SB1->B1_DESC
   _cProdLi := FER->ZA7_LF
   _cDescLi := FER->ZA7_DLF
   _cProdFo := FER->ZA7_FER
   _cDescFo := FER->ZA7_DFER                              
//   _dData   := dDatabase
   _cOpera  := FER->ZA7_OPERAC 
 //  alert(_cpara)

   FER->(DBCloseArea())            
   _lPesq   := .F.   
Return


User Function fListaf()
SetPrvt("_cProd,_cDesc,_cProdLi,_cDescLi,_cProdFo,_cDescFo,_x, _dData,_cOpera")
Private nOpc   := 0
Private bOk    := {||nOpc:=1,oWhb:End()}
Private bCancel:= {||nOpc:=0,oWhb:End()} 

_cProd   := Space(15)
_cDesc   := Space(30)
_cProdLi := Space(15)
_cDescLi := Space(30)
_cProdFo := Space(15)
_cDescFo := Space(30)                                  
 _dData  := dDatabase
_cOpera  := Space(03) 
aHeader  := {}
aCols    := {}
Aadd(aCols,{space(16),Space(50)})

//alert(inclui)

ZA7->(DbSeek(xFilial("ZA7")+" "))  //Para trzaer o acols em branco                                                    

Aadd(aHeader,{"Folha Ferramenta", "ZA7_FER", Repli("!",16)  ,16,0,".T.","","C","ZA7"}) //03
Aadd(aHeader,{"Descricao"       , "ZA7_DFER", Repli("!",50) ,50,0,".F.","","C","ZA7"}) //06

Define MsDialog oWhb Title OemToAnsi("Lista de Ferramentas") From 020,030 To 430,680 Pixel 
@ 020,006 To 061,320 Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE

@ 035,010 Say "Produto:"  Size 60,8 Object oPro            
@ 033,050 Get _cProd Picture "@!" F3 "SB1" Valid fProd()  Size 50,8 Object oProd            
@ 033,105 Get _cDesc Picture "@!" When(.F.)   Size 110,8 Object oDesc

@ 034,230 Say "Data:" Size 30,8 Object oDat             
@ 033,255 Get _dData Picture "99/99/9999" When .F. Size 35,8 Object oData            

@ 048,010 Say "L.Ferramenta:" Size 60,8 Object oProdl            
@ 046,050 Get _cProdLi Picture "@!" F3 "ZA7LF" Valid fProdLi()  Size 50,8 Object oProdLi            
@ 046,105 Get _cDescLi Picture "@!" When(.F.)   Size 110,8 Object oDesc

@ 048,230 Say OemToAnsi("Operação:") Size 30,8 Object oOpe             
@ 046,255 Get _cOpera Picture "@!" Size 30,8 Object oOpera            


//@ 063,010 Say "F.Ferramenta:" Color CLR_HBLUE  Size 60,8 Object oProdF            
//@ 063,050 Get _cProdFo Picture "@!" F3 "ZA7FF" Valid fProdfo()  Size 50,8 Object oProdFo            
//@ 063,105 Get _cDescFo Picture "@!" When(.F.)   Size 150,8 Object oDesc
DbSelectArea("ZA7")
@ 066,006 To 200,320 Title OemToAnsi(" Folha de Ferramentas ")  
@ 075,010 TO 195,315 MULTILINE MODIFY Valid fMulti() OBJECT oMultiline

//oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline

Activate MsDialog oWhb On Init EnchoiceBar(oWhb,bOk,bCancel,,) Centered

If nOpc == 1
   ZA7->(DbSetOrder(1)) //filial + produto principal
   ZA7->(DbSeek(xFilial("ZA7")+_cProd ))   
   If !ZA7->(Found())
      
      For _x:=1 to len(acols)
		   Reclock("ZA7",.T.) //tabela de movimento
		      ZA7->ZA7_FILIAL := xFilial("ZA7")
		      ZA7->ZA7_PRODUT := _cProd
		      ZA7->ZA7_LF     := _cProdLi
		      ZA7->ZA7_DLF    := _cDescLi
//		      ZA7->ZA7_DATA   := dDatabase
		      ZA7->ZA7_FER    := acols[_x,1]
		      ZA7->ZA7_DFER   := acols[_x,2]
		      ZA7->ZA7_OPERAC  := Strzero(Val(_cOpera),3)
//		      ZA7->ZA7_USER   := __CUSERID
//		      ZA7->ZA7_HORA   := Subs(Time(),1,5)
		      
		   MsUnlock("ZA7")
		   
	  Next _x	  
   Else
	   MsgBox("Produto Já Contem uma Lista de Ferramenta Cadastrada","Atençao","ALERT")    
   Endif  
Endif

Return

Static Function fMFer()
Local _lRet := .T.
Local _xi   := 0

SB1->(DbSetOrder(1)) //filial + produto 
If Len(acols) == 0
   MsgBox("Favor Digitar os Dados da Ferramentas para o Produto","Atençao","ALERT")    
   _lRet := .F.
Else
   For _xi:=1 to len(Acols)
   

      If !SB1->(DbSeek(xFilial("SB1")+acols[_xi][1] ))   
         MsgBox("Produto nao Cadastrado, verifique !!! ","Atençao","ALERT")    
         _lRet := .F.
      Endif
      
      If Empty(acols[_xi][1]) .Or. Empty(acols[_xi][2]) 
         MsgBox("Campos Vazios da Ferramentas ","Atençao","ALERT")    
         _lRet := .F.
      Endif   
   
   Next _xi
Endif   

Return(_lRet)



Static Function fMulti
Local _lRet := .T.

If Len(acols) == 0
   MsgBox("Favor Digitar a Folha de Ferramentas para o Produto","Atençao","ALERT")    
   _lRet := .F.
Else
   If Empty(acols[n][1]) .Or. Empty(acols[n][2]) 
      MsgBox("Campos Vazios na Folha de Ferramentas ","Atençao","ALERT")    
      _lRet := .F.
   
   Endif
Endif   

Return(_lRet)


Static Function fProd()
Local _lok := .F.

SB1->(DbsetOrder(1)) //filial+codigo  do produto
If !Empty(_cProd)
	If !SB1->(dbSeek(xFilial("SB1")+_cProd,.T. ))
	   MsgBox("Produto Nao Cadastrado","Atençao","ALERT") 
	   Return(_lok)
	EndIf                                           
	_cDesc   := SB1->B1_DESC
	ObjectMethod(oDesc ,"Refresh()")
	_lOK := .T.
Endif	

Return(_lok)


Static Function fProdLi()
Local _lok := .F.

QDH->(DbSetOrder(1)) // Ultima revisao
QDH->(DbSeek(xFilial("QDH")+_cProdLi)) //  + ZA7->ZA7_FERRV))	        
If QDH->(Found())
	_lok  := .T.
EndIf

Return(_lok)

Static Function fProdfo()
Local _lok := .F.

QDH->(DbSetOrder(1)) // Ultima revisao
QDH->(DbSeek(xFilial("QDH")+_cProdfo)) //  + ZA7->ZA7_FERRV))	        
If QDH->(Found())
	_lok  := .T.
EndIf

Return(_lok)



/*
DbSelectArea("SB1")
RecLock("SB1",.F.)
SB1->B1_LISTFER := "S"
MsUnlock("SB1")
	*/
                                           

                             
/*////////////////////////*/	

User Function fDese(_cPar)
Local cMvSave := "CELEWIN400"  
Local oWord
Local lView   := GetMv( "MV_QDVIEW" ) 
Local cEditor := Space(12)
Local cArqtmp
Local cPView  := Alltrim( GetMv( "MV_QDPVIEW" ) )
Local cLinha  := ""  
Local nRecebe
Local lAchou  := .F.
Local aQPath     := QDOPATH()
Local cQPath     := aQPath[1]
Local f          
Local cQPathD   := aQPath[2]
Local cQPathTrm := aQPath[3]
Local cTexto
Local cQPathf
Local _cFolha 

//ALERT (cQPathTrm)

//Alert(cQPath)
//ALERT(_cPar)
//alert(len(_cFolha))
If _cPar == 1
   _cFolha := ZA7->ZA7_FER
Else
   _cFolha :=Substring(otree:getprompt(),5,11)+Space(5)
Endif   
//alert(_cFolha)
//alert(len(_cFolha))
QDH->(DbSetOrder(1)) // Ultima revisao
QDH->(DbSeek(xFilial("QDH")+_cFolha)) //  + ZA7->ZA7_FERRV))	        
While QDH->QDH_DOCTO = _cFolha
	lAchou := .T.
	QDH->(DbSkip())
Enddo


If lAchou
	QDH->(DbSkip(-1))	
    cTexto := Alltrim(QDH->QDH_NOMDOC)
	If !File(cQPathTrm+cTexto)
		CpyS2T(cQPath+cTexto,cQPathTrm,.T.)
	EndIf
	QA_OPENARQ(cQPathTrm+cTexto)

Else
	MsgBox("Documento nao encontrado!","Cadastro de documento","STOP")
Endif

Return	


User Function fVisua()
SetPrvt("_cProd,_cDesc,_cProdLi,_cDescLi,_cProdFo,_cDescFo,aBotoes1,_x, _dData,_cOpera,oTree,oWhb")
Private nOpc   := 0
Private bOk    := {||nOpc:=1,oWhb:End()}
Private bCancel:= {||nOpc:=0,oWhb:End()}   

DEFINE FONT oFont12 NAME "Arial" SIZE 12, -12                                                                  
DEFINE FONT oFont10 NAME "Arial" SIZE 10, -10                                                                  

aBotoes1 := {{"S4WB011N",{|| Alert(" Em Desenvolvimento") },OemToAnsi("Desenho" )}}

_cProd   := Space(15)
_cDesc   := Space(30)
_cProdLi := Space(15)
_cDescLi := Space(30)
_cProdFo := Space(15)
_cDescFo := Space(30)                                  
 _dData  := dDatabase
_cOpera  := Space(03) 
aHeader  := {}
aCols    := {}

fVisEst()

Define MsDialog oWhb Title OemToAnsi("Lista de Ferramentas") From 020,030 To 430,680 Pixel 
@ 020,006 To 061,320 Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE

@ 035,010 Say "Produto:"  Size 60,8 Object oPro            
@ 033,050 Get _cProd Picture "@!" When(.F.)   Size 50,8 Object oProd            
@ 033,105 Get _cDesc Picture "@!" When(.F.)   Size 110,8 Object oDesc

@ 034,230 Say "Data:" Size 30,8 Object oDat             
@ 033,255 Get _dData Picture "99/99/9999" When .F. Size 35,8 Object oData            

@ 048,010 Say "L.Ferramenta:" Size 60,8 Object oProdl            
@ 046,050 Get _cProdLi Picture "@!" When(.F.)  Size 50,8 Object oProdLi            
@ 046,105 Get _cDescLi Picture "@!" When(.F.)  Size 110,8 Object oDesc

@ 048,230 Say OemToAnsi("Operação:") Size 30,8 Object oOpe             
@ 046,255 Get _cOpera Picture "@!" When(.F.) Size 30,8 Object oOpera            

@ 067,010 Say OemToAnsi(" Folha de Ferramentas ") Color CLR_BLUE Size 130,8 Object oFolhaF             
oFolhaF:Setfont(oFont12)                                    

@ 0065,230 BUTTON "&Desenho"       SIZE 36,12 PIXEL ACTION U_fDese(2) //Botao mostra o desenho

DEFINE DBTREE oTree FROM 080,06 TO 180,320 OF oWhb CARGO //ON init (U_fVtree())

Activate MsDialog oWhb On Init EnchoiceBar(oWhb,bOk,bCancel,,T_FillTree( oTree )) Centered

/*
ACTIVATE MSDIALOG oDlg CENTERED ON INIT,;
ENCHOICEBAR(oDlg,{|| APMsgInfo(“Ok”)}, {|| ApMsgInfo(“Cancelar”)}, ,
 {{“BMPINCLUIR”,{||APMsgInfo(“Teste”)},”Teste”}})
 */
Return


Return

User function fVtree()

//ALERT(funname())
//alert(otree:getcargo())
//alert(Substring(otree:getprompt(),5,11))


Return


Static Function fVisEst()
Local cQuery
Local J := 1
Local i := 1

   If Select("FER") > 0
      FER->(DBCloseArea())               
   Endif

   cQuery := "SELECT * FROM " +  RetSqlName( 'ZA7')+" ZA7,"+  RetSqlName('ZAZ')+ " ZAZ" 
   cQuery += " WHERE ZA7.ZA7_PRODUT = '" + ZA7->ZA7_PRODUT + "'" 
   cQuery += " AND ZA7.ZA7_LF = '" + ZA7->ZA7_LF + "'" 
   cQuery += " AND ZA7.ZA7_PRODUT *= ZAZ.ZAZ_PRODUT"
   cQuery += " AND ZA7.ZA7_FER *= ZAZ.ZAZ_FFER"
   cQuery += " AND ZA7.ZA7_LF *= ZAZ.ZAZ_LF"
   cQuery += " AND ZA7.D_E_L_E_T_ = ' '"
   cQuery += " AND ZAZ.D_E_L_E_T_ = ' '"
   cQuery += " ORDER BY ZA7.ZA7_PRODUT,ZA7.ZA7_LF,ZA7.ZA7_FER"   
   
   MemoWrite('C:\TEMP\EST092.SQL',cQuery)
   //TCQuery Abre uma workarea com o resultado da query
   TCQUERY cQuery NEW ALIAS "FER"  
  // DbSelectArea("PRI")    
   FER->(DBGotop())            
   
   _cProd   := FER->ZA7_PRODUT
   SB1->(DbsetOrder(1)) //filial+codigo  do produto
   SB1->(dbSeek(xFilial("SB1")+_cProd,.T. ))
   _cDesc   := SB1->B1_DESC
   _cProdLi := FER->ZA7_LF
   _cDescLi := FER->ZA7_DLF
//   _cProdFo := FER->ZA7_FER
//   _cDescFo := FER->ZA7_DFER                              
//   _dData   := dDatabase
   _cOpera  := FER->ZA7_OPERAC 
//   FER->(DBCloseArea())            
   
Return

Static Function T_FillTree( oTree )
Local J    := 1
Local i    := 1
Local _cFF := Space(16)
oTree:BeginUpdate() // Sempre fechar o com EndUpdate
While !FER->(Eof())
   
//   ALERT(FER->ZAZ_FCOD)
   If !Empty(Alltrim(FER->ZAZ_FCOD)) //.And. Alltrim(FER->ZAZ_FCOD)<>"NULL"
      SB1->(dbSeek(xFilial("SB1")+FER->ZAZ_FCOD,.T. )) //Busca a descricao da ferramenta
   Endif   

//	ALERT(ALLTRIM(FER->ZA7_FER))
   If FER->ZA7_FER <> _cFF
      i := 1
      _cFF := FER->ZA7_FER  
      oTree:TreeSeek("")
      DBADDTREE oTree PROMPT StrZero(j,3)+"-"+ ALLTRIM(FER->ZA7_FER)+" - " + FER->ZA7_DFER  RESOURCE "FOLDER5","FOLDER6" CARGO StrZero(j,3)

//	  oTree:AddItem("Filho"+StrZero(i,3) , StrZero(j,3),"FOLDER10","FOLDER10",,,1) // "Pedido/Item - "
//      ALERT( Alltrim(FER->ZAZ_FCOD))
	  If !Empty(Alltrim(FER->ZAZ_FCOD))// .And. Alltrim(FER->ZAZ_FCOD)<>"NULL"
	     oTree:TreeSeek(StrZero(j-10,3))
	     DBADDITEM oTree PROMPT StrZero(i,3)+"-"+ Alltrim(FER->ZAZ_FCOD)+" - "+SB1->B1_DESC CARGO StrZero(j,3)+StrZero(i,3)
         j+=1 
      Endif   
   Else  
//		ALERT (Alltrim(FER->ZAZ_FCOD))   
	  If !Empty(Alltrim(FER->ZAZ_FCOD)) //.And. Alltrim(FER->ZAZ_FCOD)<>"NULL"   	  
         i+= 1
        //	oTree:AddItem("Filho"+StrZero(i,3) , StrZero(j,3),"FOLDER10","FOLDER10",,,1) // "Pedido/Item - "
        //	oTree:TreeSeek(StrZero(j-10,3))
  	     DBADDITEM oTree PROMPT StrZero(i,3)+"-"+ Alltrim(FER->ZAZ_FCOD)+" - "+SB1->B1_DESC CARGO StrZero(j,3)+StrZero(i,3)
  	  Endif   
   Endif

   FER->(Dbskip())
   If FER->ZA7_FER <> _cFF
      DBENDTREE oTree
   Endif   
   
Enddo
FER->(DBCloseArea())            
oTree:EndUpdate()     
Return
