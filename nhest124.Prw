/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST124  ³ Autor ³ Alexandre R. Bento     Data ³ 29/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Mov. de produtos na expedicao da fundicao                  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Expedicao                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"

User Function NHEST124()

SetPrvt("CCADASTRO,AROTINA,")
//axcadastro("ZAV","ZAV")
//axcadastro("ZAX","ZAX")
cCadastro := OemToAnsi("Movimentação de Produtos")
aRotina := {{ "Pesquisa"		,"AxPesqui"     , 0 , 1},;
            { "Incluir"   		,'U_fEST()'  , 0 , 3},;
            { "Imprimir"   		,'U_fEtiq()'	, 0 , 3},;
            { "Cria Localiz"    ,'U_fCria()'	, 0 , 3},;
            { "Legenda"  		,'U_FLegExp()'	, 0 , 2}}            
            
mBrowse( 6, 1,22,75,"ZAV",,,,,,fCriaCor())
Return


User Function fEST(_cPar)

SetPrvt("_cTipo,_cDesc,_cProd,_dData,_cHora,_cOper,_cNomeOp")
SetPrvt("nMax,aHeader,aCols,oMultiline,cQuery,lMed,oBtMed,aMed,nLdlg,nCdlg,_SolNor,nI")  
SetPrvt("_cArqDBF,_aFields,aBotoes1,_cBarra,_cCodCli,_dData,_cTurno,_cHoraI,_cHoraF")
SetPrvt("_cLocaliz, _nQuant,_aTipo,_cCliente,_cLoja,_cDescli,_dData,_cNomeCli,_ccli,_cLoj,_cLoc")

 nMax    := 1     
 _nQuant := 0
_cTipo   := "E"
_aTipo   := {"Entrada " , "Saida "} 
_cDesc   := Space(30)
_cProd   := Space(15)
_cNomeOp := Space(30)
_cOper   := Space(06)               
_cArqDBF := Space(12) 
_cLocaliz:= Space(03) 
_cLoc    := Space(03) 
_cCliente:= Space(06)
_cLoja   := Space(02)
_ccli    := Space(06)
_cLoj    := Space(02)
_cNomeCli:= Space(30)
_dData   := Ctod(" / / ")

aBotoes1 := {{"RELATORIO",{|| Alert(" Em Desenvolvimento") },OemToAnsi("Relatório" )}}
    
Private nOpc   := 0
Private bOk    := {||nOpc:=1,_SolNor:End()}
Private bCancel:= {||nOpc:=0,_SolNor:End()} 

/*
@ 038,040 Get _cCli Picture "@!"  When(_cPar == 3 .Or. _cPar == 5) F3 fRetF3() Size 30,8 valid fFornece() Object oCli            
@ 038,072 Get _cLoja Picture "@!"  When(_cPar == 3 .Or. _cPar == 5) Size 10,8 valid fLoja() Object oLoja            
@ 038,090 Get _cDesCli Picture "@!" When .F. Size 100,8 Object oDesCli            
  */
 
Define MsDialog _SolNor Title OemToAnsi("Movimentação de Produtos") From 020,030 To 240,700 Pixel 
@ 023,006 To 105,330 Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE
@ 037,010 Say "Tipo Movimento :" Color CLR_HBLUE  Size 050,8            
@ 035,050 COMBOBOX _cTipo ITEMS _aTipo SIZE 60,10 object ocTipo     
@ 050,010 Say "Produto:" Color CLR_HBLUE  Size 40,8            
@ 050,050 Get _cProd Picture "@!" F3 "SZA" Valid fProd()  Size 50,8 Object oProd            
@ 050,105 Get _cDesc Picture "@!" When(.F.)   Size 180,8 Object oDesc

@ 063,010 Say "Cliente:" Color CLR_HBLUE  Size 40,8            
@ 063,050 Get _cCliente Picture "@!" F3 "SA1" Valid fCliente()  Size 30,8 Object oCliente            
@ 063,082 Get _cLoja Picture "@!" Valid fLoja()  Size 10,8 Object oLoja            
@ 063,100 Get _cDescli Picture "@!" When(.F.)   Size 130,8 Object oDescli

@ 076,010 Say "Data de Fusao:" Color CLR_HBLUE  Size 040,8            
@ 076,050 Get _dData Picture "99/99/99"  When(Subs(_cTipo,1,1)$"E") Size 040,8  Object oData

@ 091,010 Say "Quantidade:" Color CLR_HBLUE  Size 040,8            
@ 089,050 Get _nQuant Picture "9999999999"   When(Subs(_cTipo,1,1)$"E") Size 040,8  Valid (_nQuant > 0)  Object onQuant

@ 091,100 Say "Localização:" Color CLR_HBLUE  Size 050,8            
@ 089,140 Get _cLocaliz Picture "@!"  When(Subs(_cTipo,1,1)$"E") Size 015,8  Valid fLocal() Object oLocaliz

@ 091,190 Say "Confirma Localização:" Color CLR_HBLUE  Size 070,8            
@ 089,250 Get _cLoc Picture "@!"  When(Subs(_cTipo,1,1)$"S") Size 015,8  Valid fLoc() Object oLoc

//If Subs(_cTipo,1,1)$"E"
//   oLoc:hide()
//Endif  

Activate MsDialog _SolNor On Init EnchoiceBar(_SolNor,bOk,bCancel,,aBotoes1) Centered


If nOpc == 1
   ZAV->(DbSetOrder(2)) //filial + localizacao 
   ZAV->(DbSeek(xFilial("ZAV")+_cLocaliz))   
   If ZAV->(Found())
      If (ZAV->ZAV_QUANT == 0 .And. Subs(_cTipo,1,1)$"E") .Or. (ZAV->ZAV_QUANT <> 0 .And. Subs(_cTipo,1,1)$"S") 

		   Reclock("ZAX",.T.) //tabela de movimento
		      ZAX->ZAX_FILIAL := xFilial("ZAX")
		      ZAX->ZAX_COD    := _cProd
		      ZAX->ZAX_QUANT  := _nQuant
		      ZAX->ZAX_LOCALI := _cLocaliz
		      ZAX->ZAX_DATA   := dDatabase
		      ZAX->ZAX_TIPO   := _cTipo
		      ZAX->ZAX_CLIENT := _cCliente
		      ZAX->ZAX_LOJA   := _cLoja
		      ZAX->ZAX_DATAF  := _dData //data da fusao do produto
		      ZAX->ZAX_USER   := __CUSERID
		      ZAX->ZAX_HORA   := Subs(Time(),1,5)
		      
		   MsUnlock("ZAX")
		   
		  
		   Reclock("ZAV",.F.) // tabela de saldo
		      ZAV->ZAV_FILIAL := xFilial("ZAV")
		      ZAV->ZAV_COD    := Iif(Subs(_cTipo,1,1)$"E",_cProd,Space(15))
		      ZAV->ZAV_QUANT  := Iif(Subs(_cTipo,1,1)$"E",_nQuant,0)
		      ZAV->ZAV_LOCALI := _cLocaliz
		      ZAV->ZAV_DATA   := dDatabase
		      ZAV->ZAV_CLIENT := Iif(Subs(_cTipo,1,1)$"E",_cCliente,Space(06))
		      ZAV->ZAV_LOJA   := Iif(Subs(_cTipo,1,1)$"E",_cLoja,Space(02)) 
		      ZAV->ZAV_DATAF  := Iif(Subs(_cTipo,1,1)$"E",_dData,CtoD("//")) //data da fusao do produto
		      
		   MsUnlock("ZAV")
	  Endif	   
   Endif  
Endif

/*
If File(_cArqDBF)
   DbSelectArea("MAR")
   DbCloseArea()
   fErase(_cArqDBF)
Endif   
*/
Return

                
Static Function fLoc()
Local _lOk := .T.
   
   If _cLocaliz <> _cLoc
      _lOk := .F.
      MsgBox("Localizacao não Confere, Verifique !!! ","Atencao","ALERT")
   Endif

Return(_lOk)

Static Function fCliente()

If Empty(_cCliente) .Or. Len(Alltrim(_cCliente)) < 6
   Return(.F.)
Endif

SA1->(DbSetOrder(1))
If !SA1->(DbSeek(xFilial("SA1")+_cCliente,.T.))
   Msgbox("Cliente Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
   oCliente:SetFocus(oCliente)
   ObjectMethod(oCliente,"Refresh()")
   Return(.F.)
Endif
        
Return(.T.)



Static Function fLoja()
Local _lok     := .F.
Local _lAchou  := .F.

SA1->(DbSetOrder(1))
If SA1->(DbSeek(xFilial("SA1")+_cCliente+_cLoja))
   _cDesCli := SA1->A1_NOME
   _cLoja   := SA1->A1_LOJA 
   _lok     := .T.
Else
    Msgbox("Cliente Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
    oCliente:SetFocus(oCliente)
    ObjectMethod(oCliente,"Refresh()")
    DlgRefresh(_SolNor)
    Return(_lok)                                       	
Endif

ObjectMethod(oDesCli,"Refresh()")
ObjectMethod(oLoja,"Refresh()")


If _lok .And. Subs(_cTipo,1,1)$"S" 
   ZAV->(DbSetOrder(1)) //filial + produto + data + localizacao 
   ZAV->(Dbseek(xFilial("ZAV")+_cProd))
   While ZAV->(!Eof()) .And. ZAV->ZAV_COD == _cProd
      
      If _cCliente+_cLoja == ZAV->ZAV_CLIENT+ZAV->ZAV_LOJA .And. ZAV->ZAV_QUANT <> 0  
         _nQuant   := ZAV->ZAV_QUANT
         _cLocaliz := ZAV->ZAV_LOCALI
         _cCliente := ZAV->ZAV_CLIENT
         _cLoja    := ZAV->ZAV_LOJA
         _dData    := ZAV->ZAV_DATAF
         _lAchou   := .T.
         Exit // força a saida do while
      Endif
      ZAV->(DbSkip())
   Enddo	
 
   If !_lAchou
   
      If !MsgBox(" Para o Cliente " + _cCliente+"-"+_cLoja+"-"+ _cDescli+ "  Nao Existe Saldo. Utiliza Saldo do Clinte "+;
              _cNomeCli ,"Atencao","YESNO")
         _cCliente := _cCli
         _cLoja    := _cLoj 
         _cDesCli  := _cNomeCli
         _lok := .F.     
      Endif
   Endif
Endif
                               
ObjectMethod(oCliente,"Refresh()")
ObjectMethod(oLoja,"Refresh()")
ObjectMethod(oDesCli,"Refresh()")

ObjectMethod(onQuant,"Refresh()")
ObjectMethod(oData,"Refresh()")
ObjectMethod(oLocaliz,"Refresh()")
   
Return(_lok)                                       	



Static Function fLocal()
Local _lok := .F.

ZAV->(DbSetOrder(2)) //filial + localizacao 
If !Empty(_cLocaliz)   
   _cLocaliz := Subs(_cLocaliz,1,1)+StrZero(Val(Subs(_cLocaliz,2,2)),2)//deixa padrao a variavel de A1 p/ A01
   
   If Subs(_cLocaliz,2,2) == '00' 
   
      ZAV->(DbSeek(xFilial("ZAV")+Subs(_cLocaliz,1,1)))
      While ZAV->(!Eof()) .And. Subs(ZAV->ZAV_LOCALI,1,1) == Subs(_cLocaliz,1,1)
         If ZAV->ZAV_QUANT == 0
            _cLocaliz := ZAV->ZAV_LOCALI
            _lok := .T.
            Exit // forca a saida do loop
         Endif
         ZAV->(Dbskip())
      Enddo   
      
      If !_lok
         MsgBox(" Localizacao nao Disponivel Nesta Fila ","Movimentacao de Produtos","ALERT")
      Endif
      
   Else
      ZAV->(DbSeek(xFilial("ZAV")+_cLocaliz))   
      If ZAV->(Found())
         If ZAV->ZAV_QUANT == 0
            _lok := .T.
            
         Else
            MsgBox(" Esta Localizacao nao esta Disponivel ","Movimentacao de Produtos","ALERT")         
         Endif
      Else
         MsgBox(" Esta Localizacao nao Existe ","Movimentacao de Produtos","ALERT")               
      Endif   
   Endif

   	ObjectMethod(oLocaliz ,"Refresh()")   //atualiza o conteudo da variavel na tela
Endif

Return(_lok)
      

User Function  fCria()

Axcadastro("ZAV","ZAV")

Return


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

If _lok .And. Subs(_cTipo,1,1)$"S" 
   ZAV->(DbSetOrder(1)) //filial + produto + data + localizacao 
   ZAV->(Dbseek(xFilial("ZAV")+_cProd))
   While ZAV->(!Eof()) .And. ZAV->ZAV_COD == _cProd
      
      If ZAV->ZAV_QUANT <> 0
         _nQuant   := ZAV->ZAV_QUANT
         _cLocaliz := ZAV->ZAV_LOCALI
         _cCliente := ZAV->ZAV_CLIENT
         _cLoja    := ZAV->ZAV_LOJA
         _dData    := ZAV->ZAV_DATAF
         Exit // força a saida do while
      Endif
      ZAV->(DbSkip())
   Enddo	
   ObjectMethod(oLocaliz ,"Refresh()")
   ObjectMethod(onQuant ,"Refresh()")	
   ObjectMethod(oCliente,"Refresh()")	
   ObjectMethod(oLoja ,"Refresh()")	
   ObjectMethod(oData ,"Refresh()")	   
   
   If _nQuant == 0
      MsgBox(" Produto Sem Saldo Disponivel ","Movimentacao de Produtos","ALERT")         
   Endif

   SA1->(DbSetOrder(1))
   If SA1->(DbSeek(xFilial("SA1")+_cCliente+_cLoja))
      _cDesCli  := SA1->A1_NOME
      _cCli     := SA1->A1_COD
      _cLoj     := SA1->A1_LOJA
      _cNomeCli := SA1->A1_NOME
   Else
      Msgbox("Cliente Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
      oCliente:SetFocus(oCliente)
      ObjectMethod(oCliente,"Refresh()")
      DlgRefresh(_SolNor)
      Return(.F.)                                       	
   Endif
   ObjectMethod(oDesCli,"Refresh()")
   ObjectMethod(oLoja,"Refresh()")

Endif


Return(_lok)

User Function FLegExp()       

Local aLegenda :=	{ {"BR_VERDE"    , "Livre"  },;
  					  {"BR_VERMELHO" , "Ocupado"    }}
  					  
BrwLegenda(OemToAnsi("Movimentação de Produtos"), "Legenda", aLegenda)

Return

                                           
Static Function fCriaCor()       

	Local aLegenda :=	{ {"BR_VERDE"    , "Livre"  },;
	  					  {"BR_VERMELHO" , "Ocupado" }}


	Local uRetorno := {}
	Aadd(uRetorno, { 'ZAV_QUANT == 0' , aLegenda[1][1] } )
	Aadd(uRetorno, { 'ZAV_QUANT <> 0' , aLegenda[2][1] } )
	
Return(uRetorno)          


User Function FEtiq()

Local _cDesCli := Space(70)
Local _cCod    := Space(06)
Private cStartPath 	:= GetSrvProfString("Startpath","")

	If Right(cStartPath,1) <> "\"
		cStartPath += "\"
	Endif
	
	oFont10  := TFont():New("Arial",,10,,.F.)
	oFont12  := TFont():New("Arial",,12,,.F.)
	oFont12N := TFont():New("Arial",,12,,.T.)                  
	oFont14N := TFont():New("Arial",,14,,.T.)	
	oFont16N := TFont():New("Arial",,16,,.T.)
	oFont18N := TFont():New("Arial",,18,,.T.)
	oFont18  := TFont():New("Arial",,18,,.F.)	
	oPr:= tAvPrinter():New("Protheus")
	oPr:StartPage()

	oPrint := TMSPrinter():New( "Movimentacao de Produtos") 
	oPr:SetPortrait()
	oPrint:Setup()//chama janela para escolher impressora, orientacao da pagina etc...

/*	oPr:SayBitmap(080,0100, cStartPath+"\Whbl.bmp",240,100)
	oPr:Say(100,380,"FUNDIÇÃO S/A",oFont18)

	oPr:Say(340,0050,OemtoAnsi("Produto"), oFont18)
    SB1->(dbSeek(xFilial("SB1")+ZAV->ZAV_COD,.T. ))
	oPr:Say(340,0350,Substr(SB1->B1_DESC,1,30), oFont18N) //////XXXXXXXXX
	oPr:Say(470,0050,OemtoAnsi("Quantidade"), oFont12)  	
	oPr:Say(470,0300,Transform(ZAV->ZAV_QUANT,"@E 999999999"), oFont12)  		
	oPr:Say(600,050,OemtoAnsi("Localização"), oFont12)
	oPr:Say(600,350,ZAV->ZAV_LOCALI, oFont12)	
	MSBAR("CODE3_9",2.4,2.3,ZAV->ZAV_LOCALI,oPr,.F., ,.T.,0.0194,0.4,NIL,NIL,NIL      ,.F.,,,.F.) //imprime cod. de barra do produto
	

	MSBAR("CODE3_9",3.0,0.5,ZAV->ZAV_COD,oPr,.F., ,.T.,0.0194,0.6,NIL,NIL,NIL      ,.F.,,,.F.) //imprime cod. de barra do produto	

/*****************************************/

   SA1->(DbSetOrder(1))
   If SA1->(DbSeek(xFilial("SA1")+ZAV->ZAV_CLIENT+ZAV->ZAV_LOJA))
      _cDesCli  := Subs(SA1->A1_NOME,1,29)+ALLTRIM(SA1->A1_MUN)+" "+ Alltrim(SA1->A1_ESTADO)
   Endif

    SA7->(DbSetOrder(1))
	IF	SA7->(DbSeek(xFilial("SA7")+ZAV->ZAV_CLIENT+ZAV->ZAV_LOJA+ZAV->ZAV_COD)) 
		_cCod    := Alltrim(SA7->A7_CODCLI)  //Pega o codigo do cliente  
//		_cPCFor  := SA7->A7_PCCLI  // Numero do pedido do cliente na New Hubner
//		_cCodFor := SA7->A7_CODFOR  // Codigo da New Hubner no Cliente
    Else
        Msgbox("Cliente Nao Possui Cadastro de Amarracao Produto x Cliente, Verifique !!!" ,"Atencao","ALERT" )         
    Endif

   SB1->(DbSetOrder(1))
   SB1->(DbSeek(xFilial("SB1")+ZAV->ZAV_COD))
   	                                      
	oPr:Line(010,020,010,2350) // Horizontal 1º linha
	oPr:Line(0010,1200,570,1200) // vertical
	oPr:Say(040,0050,OemtoAnsi("Destinatário"), oFont12)
	oPr:Say(040,1210,OemtoAnsi("Local de Utilização"), oFont12)

	oPr:Say(110,0050,Substr(_cDesCli,1,29), oFont14N) //////XXXXXXXXX
	oPr:Say(160,0050,Substr(_cDesCli,30,35),oFont14N)
	oPr:Line(240,050,240,2350) // Horizontal 2º linha
	oPr:Say(270,0050,OemtoAnsi("Nº da Nota Fiscal"), oFont12)  	
	oPr:Say(250,1210,OemtoAnsi("Endereço do Expedidor"), oFont12)  	
	oPr:Say(350,0060,OemtoAnsi(" "), oFont18N)//nota fiscal  		
	oPr:Say(310,1210,OemtoAnsi("WHB FUNDIÇÃO S/A CURITIBA-PR"), oFont16N)
	oPr:Line(390,1200,390,2350) // Horizontal 3º linha            
	oPr:Say(420,1210,OemtoAnsi("Peso Liquido (Kg)"), oFont12)
	oPr:Line(0390,1570,570,1570) // vertical	
	oPr:Say(420,1620,OemtoAnsi("Peso Bruto (Kg)"), oFont12)	
	oPr:Line(0390,1950,570,1950) // vertical		
	oPr:Say(420,2000,OemtoAnsi("Nº de Caixas"), oFont12)
	oPr:Say(500,1250,OemtoAnsi(" "), oFont16N) //peso liquido
	oPr:Say(500,1670,OemtoAnsi(" "), oFont16N)	//peso bruto
	oPr:Say(500,2050,OemtoAnsi(" "), oFont16N) //qtde caixas
	oPr:Line(0570,0050,0570,2350) // Horizontal 4º linha            	
	oPr:Line(0600,0050,0600,2350) // Horizontal 5º linha            		
	oPr:Say(0630,0050,OemtoAnsi("Nº do Produto (P)"), oFont12)  		
//		        ETQ->PLIQUI := Transform((TMP->B1_PESO * nQtde),"@e 9999.99") 	
	oPr:Say(0620,0500,OemtoAnsi(Alltrim(ZAV->ZAV_COD)), oFont18N)
	MSBAR("CODE3_9",3.0,0.5,Alltrim(ZAV->ZAV_COD),oPr,.F., ,.T.,0.0194,0.6,NIL,NIL,NIL      ,.F.,,,.F.) //imprime cod. de barra do produto
	    
	oPr:Line(0910,0050,0910,2350) // Horizontal 6º linha            		
	oPr:Say(0930,0050,OemtoAnsi("Quantidade (Q)"), oFont12)  	
	oPr:Say(0930,1230,OemtoAnsi("Produto"), oFont12)  	
	oPr:Line(0910,1200,1810,1200) // vertical qtde |produto

	oPr:Say(970,0600,Transform(ZAV->ZAV_QUANT,"@E 999999999"), oFont18N)  		
	oPr:Say(1000,1230,OemtoAnsi(Subs(SB1->B1_DESC,1,22)), oFont12N)  	
	oPr:Line(1050,1200,1050,2350) // Horizontal 7º linha            
	oPr:Say(1070,1230,OemtoAnsi("Ref. Fornecedor (30S)"), oFont12)  		
	oPr:Say(1130,1230,OemtoAnsi(" "), oFont18N)// fornece  	   
    MSBAR("CODE3_9",4.4,0.5,Transform(ZAV->ZAV_QUANT,"@E 999999999") ,oPr,.F., ,.T.,0.0194,0.6,NIL,NIL,NIL,.F.,,,.F.) //imprime cod. de barra do produto        
	oPr:Line(1250,0020,1250,1200) // Horizontal 8º linha              	                       
	oPr:Say(1280,0050,OemtoAnsi("Fornecedor (V)"), oFont12)    	
	oPr:Say(1270,0350,OemtoAnsi(" "), oFont16N) //fornecedor    		       
	oPr:Line(1370,1200,1370,2350) // Horizontal 9º linha            
	oPr:Say(1390,1230,OemtoAnsi("Data"), oFont12)
	oPr:Line(1370,1650,1510,1650) // vertical	data | indice de modificação    	
	oPr:Say(1390,1700,OemtoAnsi("Indice de Modificação"), oFont12)    	
	oPr:Say(1440,1230,OemtoAnsi(DTOC(ZAV->ZAV_DATA)), oFont16N)    		       
	
	MSBAR("CODE3_9",5.5,0.5,OemToAnsi("FORNECE"),oPr,.F., ,.T.,0.0194,0.6,NIL,NIL,NIL,.F.,,,.F.) //imprime cod. de barra do fornecedor
	oPr:Line(1510,0050,1510,2350) // Horizontal 10º linha            	
	oPr:Say(1530,0050,OemtoAnsi("Nº da Etiqueta (S)"), oFont12)    		
	oPr:Say(1530,0420,OemtoAnsi("0000"), oFont14N)//NUMERO DA etiqueta
	oPr:Say(1530,1230,OemtoAnsi("Nº Lote"), oFont12)    	    		
	MSBAR("CODE3_9",6.55,0.5,OemToAnsi("0000"),oPr,.F., ,.T.,0.0194,0.6,NIL,NIL,NIL,.F.,,,.F.) //imprime cod. de barra c/ numero da etq  	
	oPr:Say(1760,0070,OemtoAnsi("WHB FUNDIÇÃO S/A CURITIBA-PR"), oFont10)    	    		  	
	oPr:Line(1810,0050,1810,2350) // Horizontal 11º linha            	
	oPr:Line(1840,0050,1840,2350) // Horizontal 12º linha            		
	oPr:Say(1870,0050,OemtoAnsi("Nº da Etiqueta (S)"), oFont12)    	    		  	  	
	oPr:Say(1870,0420,OemtoAnsi("0000"), oFont14N)// numero da etiqueta	
	oPr:Say(1870,1230,OemtoAnsi("Nº do Produto"), oFont12)    		
	oPr:Say(1920,1230,OemtoAnsi(ZAV->ZAV_COD), oFont16N)               
	oPr:Line(2060,1200,2060,2350) // Horizontal 13º linha            
	MSBAR("CODE3_9",8.0,0.5,OemToAnsi("0000"),oPr,.F., ,.T.,0.0194,0.6,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra c/ numero da etq  	
	oPr:Say(2110,0070,OemtoAnsi("WHB FUNDIÇÃO S/A CURITIBA-PR"), oFont10)    	    		  	
	oPr:Line(1840,1200,2420,1200) // vertical	Nº da etq | indice de modificação    	                                                                              
	oPr:Say(2070,1230,OemtoAnsi("Produto"), oFont12)    		
	oPr:Say(2120,1230,OemtoAnsi(SB1->B1_DESC), oFont16N)      
	oPr:Line(2220,1200,2220,2350) // Horizontal 13º linha            
	oPr:Say(2250,1230,OemtoAnsi("Quantidade (Q)"), oFont12)    		
	oPr:Say(2300,1300,Transform(ZAV->ZAV_QUANT,"@E 999999999"), oFont16N)               

	oPr:Say(2250,1600,OemtoAnsi("Fornecedor (V)"), oFont12)    		
	oPr:Say(2300,1600,OemtoAnsi("FORNECE"), oFont16N)               
	
	oPr:Say(2250,2000,OemtoAnsi("Data"), oFont12)    		
	oPr:Say(2300,2000,OemtoAnsi(DTOC(ZAV->ZAV_DATA)), oFont16N)    		       	 	
 
	oPr:Line(2220,1580,2420,1580) // vertical	
	oPr:Line(2220,1980,2420,1980) // vertical		
                          
oPr:Preview()
oPr:End()

MS_FLUSH()
Return

