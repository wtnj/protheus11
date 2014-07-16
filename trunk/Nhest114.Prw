/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณ NHEST114  ณ Autor ณ Alexandre R. Bento     Data ณ 25/02/08 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Controle de Bloqueio de produtos                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ Rdmake                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Compras / financeiro                                       ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

#include "rwmake.ch"
#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"    

User Function nhest114()

SetPrvt("CCADASTRO,AROTINA,")

//AXCADASTRO("ZAK","ZAK")

cCadastro := OemToAnsi("Bloqueio de Produtos")
aRotina := {{ "Pesquisa","AxPesqui"         , 0 ,1},;
            { "Visualizacao",'U_fBloque(1)' , 0 ,2},;
            { "Inclui"      ,'U_fBloque(2)' , 0 ,3},;
            { "Alterar"     ,'U_fBloque(3)' , 0 ,4},;            
            { "Exclui"      ,'U_fBloque(4)' , 0 ,5},;
            { "Relatorio"   ,'U_fBloque(5)' , 0, 3},;                        
            { "Legenda"     ,"U_FLegBloq",0,2}}     
            

mBrowse( 6, 1,22,75,"ZAK",,,,,,fCriaCor())

Return


User Function fBloque(_cPar)

If _cPar == 5 //relatorio
	RelatoBloq()
	Return
EndIf

SetPrvt("_cTipo,_cMes,_dData,_cHora,oDialog,cQuery,cQuery1,_cTipoDe")  
SetPrvt("_nValfat,_nPerc,_nVal,_nSal,_cParam,_nSld")

DEFINE FONT oFont NAME "Arial" SIZE 12, -12                                                                  
DEFINE FONT oFont10 NAME "Arial" SIZE 10, -10                                                                  


_nSld  := 0
   
_cParam  := _cPar
_dData   := date()
_cHora   := time()   

_cTipo   := space(02)
_cTipoDe := Space(40)

_aMes := {"Janeiro","Fevereiro",OemToAnsi("Mar็o"),"Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
_cMes := "1"

_nValfat := 0
_nPerc    := 0
_nVal  := 0
_nSal  := 0

If _cParam == 1 .Or. _cParam == 3 .Or. _cParam == 4 

	_cMes    := Val(Subs(ZAK->ZAK_MESANO,1,2))		     
	_dData	 :=	ZAK->ZAK_DATA    
	_nValfat := ZAK->ZAK_VLRFAT
	_nPerc   := ZAK->ZAK_PERC
	_nVal    := ZAK->ZAK_VLR
	_nSal    := ZAK->ZAK_SLD
	_cTipo   := ZAK->ZAK_TIPO
	
Endif

Private cPerg := "EST114"                                

ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//Processa( {|| fRptDet() }, "Aguarde Pesquisando...")

 
Define MsDialog oDialog Title OemToAnsi("Bloqueio de Produtos por Tipo") From 020,030 To 250,770 Pixel 
@ 013,007 To 110,365 Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE
//@ 027,010 Say "Tipo :" Size 030,8            
//@ 025,030 COMBOBOX _cTipo ITEMS _aTipo SIZE 60,10 object oTipo
//@ 027,030 Say _cTipo Size 035,8 Object oDoc            
// oDoc:Setfont(oFont)                      
@ 027,10 Say "M๊s:" Size 30,8            
@ 025,30 COMBOBOX _cMes ITEMS _aMes SIZE 50,10 object oMes
@ 027,80 say Year(date()) Picture "9999"  Size 060,8 Object oyear
 oyear:Setfont(oFont)                      
 
@ 027,230 Say "Data:" Size 30,8            
@ 025,245 Get _dData Picture "99/99/9999" When .F. Size 35,8 Object oData            
@ 027,305 Say "Hora:" Size 30,8            
@ 025,325 Get _cHora Picture "99:99:99" When .F. Size 25,8 Object oHora            

@ 042,010 Say "Tipo :" Size 030,8            
@ 040,030 Get _cTipo F3 "02" SIZE 30,10 Valid fTipo() object oTipo
@ 040,060 Get _cTipoDe WHEN .F. SIZE 100,10 object oTipoDe
oTipo:Setfont(oFont)                      


@ 055,010 Say OemToAnsi("Faturamento :") Size 040,8
@ 053,050 Get _nValFat Picture "999,999,999.99" Size 050,8 Object oValFat

@ 055,120 Say OemToAnsi("Percentual :") Size 050,8
@ 053,150 Get _nPerc Picture "999.99" Size 030,8 Valid fPerc() Object oPerc

@ 055,200 Say OemToAnsi("Valor :") Size 050,8
@ 053,220 Get _nVal  When(.F.) Picture "999,999,999.99" Size 050,8 Object oVal

@ 055,290 Say OemToAnsi("Saldo :") Size 050,8
@ 053,310 Get _nSal When(.F.) Picture "999,999,999.99" Size 050,8 Object oSal

@ 080,285 BMPBUTTON TYPE 01 ACTION fGrvOrd()
@ 080,330 BMPBUTTON TYPE 02 ACTION fEnd() //FCancela()

Activate MsDialog oDialog Center 
Return           

Static Function fTipo()
Local _lEnd := .F.

SX5->(Dbgotop())       
SX5->(DbSetOrder(1)) //filial+cod
SX5->(DbSeek(xFilial("SX5")+"02")) //tabelas de tipo de produtos
While SX5->(!Eof()) .And.  SX5->X5_TABELA  == "02"
   If AllTrim(SX5->X5_CHAVE) == _cTipo //Verifica se o tipo existe 
      _cTipoDe := Alltrim(SX5->X5_DESCRI)
      _lEnd := .T. //Encontrou o tipo
	  lOK := .T.
	  Exit //
   Endif  
   SX5->(Dbskip())
Enddo

ObjectMethod(oTipoDe, "Refresh()")
Return(_lEnd)

Static Function fPerc()
Local _lEnd := .T.

If _nValFat > 0 
	_nVal :=  (_nValFat * _nPerc) / 100
	_nSal := _nVal
	ObjectMethod(oVal, "Refresh()")
	ObjectMethod(oSal, "Refresh()")
Else                         
    oValFat:SetFocus(oValFat)  
   _lEnd := .F.
Endif	

Return(_lEnd)


Static Function fEnd() 

   Close(oDialog) 

Return

Static Function fGrvOrd()

Local _cNumOrc
_cNumOrc := GETMV("MV_ORC")

//fAtuSld() //atualiza saldo dos pedidos que jแ estใo em abertos
If _cParam == 2 //INCLUI
   ZAK->(DbSetOrder(1))//filial + mesano
   If !ZAK->(Dbseek(xFilial("ZAK")+Strzero(Ascan(_aMes,_cMes),2) + "/"+Strzero(Year(Date()),4)+_cTipo))  
	   If !Empty(_nValFat) .And. !Empty(_nVal) //.And. !Empty(_nValFE)
		  //Begin Transaction  
		      Reclock("ZAK",.T.)
		         ZAK->ZAK_FILIAL  := xFilial("ZAK")
//			     ZAK->ZAK_HORA    := Time()       
			     ZAK->ZAK_MESANO  := Strzero(Ascan(_aMes,_cMes),2) + "/"+Strzero(Year(Date()),4)         
			     ZAK->ZAK_DATA    := Ctod(StrZero(Day(date()),2)+"/" + Strzero(Ascan(_aMes,_cMes),2) + "/"+Strzero(Year(Date()),4))         
			     ZAK->ZAK_TIPO    := _cTipo
			     ZAK->ZAK_VLRFAT  := _nValFat
			     ZAK->ZAK_PERC    := _nPerc
			     ZAK->ZAK_VLR     := _nVal
			     ZAK->ZAK_SLD     := _nSal //- _nSld 
			     ZAK->ZAK_NUMORC  := GetSxeNum("ZAK","ZAK_NUMORC") //Traz um novo n๚mero de or็amento
	//		     ZAK->ZAK_STATUS		     		     		     		     		     
		      MsUnlock("ZAK")     
	     // End Transaction   	  
		   Close(oDialog)
	   Else
	       Msgbox("Campos Obrigatorios Nao Foram Digitados, Verifique !!!" ,"Atencao Campo em Branco","ALERT" )      
	   Endif

   Else 
      Msgbox("Valor de Faturamento jแ cadastrado da Este Mes/Ano, Verifique !!!" ,"Atencao","ALERT" )          
   Endif
                          
ElseIf _cParam == 3 //altera

	   If !Empty(_nValFat) .And. !Empty(_nPerc) 
		  //Begin Transaction  
		      Reclock("ZAK",.F.)
		         ZAK->ZAK_FILIAL  := xFilial("ZAK")
	//		     ZAK->ZAK_HORA    := Time()       
   //			     ZAK->ZAK_MESANO  := Strzero(Ascan(_aMes,_cMes),2) + "/"+Strzero(Year(Date()),4)         
//			     ZAK->ZAK_DATA    := Ctod(StrZero(Day(date()),2)+"/" + Strzero(Ascan(_aMes,_cMes),2) + "/"+Strzero(Year(Date()),4))         
//			     ZAK->ZAK_DATA    := date()
	//		     ZAK->ZAK_TIPO    := _cTipo
			     ZAK->ZAK_VLRFAT  := _nValFat
			     ZAK->ZAK_PERC    := _nPerc
			     ZAK->ZAK_VLR     := _nVal
			     ZAK->ZAK_SLD     := _nSal
	//		     ZAK->ZAK_STATUS		     		     		     		     		     
		      MsUnlock("ZAK")     
			  Close(oDialog)
       Endif

ElseIf _cParam == 4 //exclui
       
       If _nVal == _nSal 
    	  Reclock("ZAK",.F.)
             ZAK->(DbDelete())
	      MsUnlock("ZAK")     
	      Close(oDialog)
	   Else 
          Msgbox("Jแ foi baixado pedido de compras, Nao foi possivel a Exclusใo, Verifique !!!" ,"Atencao","ALERT" )          	   
	   Endif   

Endif

Return


User Function fLegBloq()

Private aCores := {{ "ENABLE"  , "Nota nao Selecionada" },;
                   { "DISABLE" , "Nota Selecionada" }}

BrwLegenda(cCadastro,"Legenda",aCores)

Return
              


Static Function fCriaCor()       

Local aLegenda :=	{ {"BR_VERDE"   , "Aberto"  },;
  					  {"BR_VERMELHO" , "Fechada"   }}

Local uRetorno := {}
Aadd(uRetorno, { 'ZAK_STATUS = " " ' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZAK_STATUS <> " "'  , aLegenda[2][1] } )
Return(uRetorno)
                                         
                     

Static Function fAtuSld()

cQuery := " SELECT SUM((C7_QUANT-C7_QUJE)*C7_PRECO) AS TOTAL FROM " + RetSqlName( 'SC7' )
cQuery += " WHERE C7_FILIAL = '" + xFilial("SC7")+ "'"    
cQuery += " AND SUBSTRING(C7_DATPRF,1,6) = '" +Strzero(Year(Date()),4)+Strzero(Ascan(_aMes,_cMes),2)+ "'"
cQuery += " AND  C7_RESIDUO = ' ' "    
cQuery += " AND  (C7_QUANT-C7_QUJE) > 0 "    
cQuery += " AND  SUBSTRING(C7_PRODUTO,1,2) = '" + _cTipo + "'"
cQuery += " AND  D_E_L_E_T_ = ' ' " 
MemoWrit('C:\TEMP\EST114.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"      
DbSelectArea("TMP")

If TMP->TOTAL > 0 
   _nSld := TMP->TOTAL
Endif   
TMP->(DbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RelatoBloq   บAutor ณJoใo Felipe       บ Data ณ  13/06/2008บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ RELATORIO ITENS DOS GASTOS					              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ COMPRAS                                                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RelatoBloq()

cString   := "QM2"
cDesc1    := OemToAnsi("Este   relatorio   tem   como   objetivo  Imprimir ")
cDesc2    := OemToAnsi("a rela็ใo dos ํtens que comp๕em os gastos.")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST114"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATำRIO DE BLOQUEIO DE PRODUTOS")
cabec1    := " "
cabec2    := " Pedido    Forn.    Item       Produto                                          N.F.   Quant. Vlr Unit.  Vlr Total"
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHEST114"
_cPerg    := "EST114"  

// mv_par01 de tipo
// mv_par02 at้ tipo
// mv_par03 de data
// mv_par04 at้ data

Pergunte(_cPerg,.T.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]   


If Month(mv_par03) <> Month(mv_par04) .Or. Year(mv_par03) <> Year(mv_par04)
   Msgbox("O relatorio so pode ser emitido dentro do mesmo Mes e Ano, Verifique !!!" ,"Atencao","ALERT" )          	   
   Return
Endif


Processa( {|| Gerando()   },"Gerando Dados para a Impressao") 
RptStatus( {|| RptDetail()   },"Imprimindo...") 

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function Gerando()
Local cQuery

    //------------------
    // MONTA A QUERY
    //------------------
    
    cQuery := "SELECT D1.D1_PEDIDO, D1.D1_FORNECE, D1.D1_COD, D1.D1_DESCRI, D1.D1_DOC, D1.D1_QUANT, D1.D1_VUNIT, D1.D1_TOTAL, D1.D1_ITEM,B1.B1_TIPO"
    cQuery += " FROM "+RetSqlName("SD1")+" D1,"+RetSqlName("SB1")+" B1,"+RetSqlName("ZAK")+" ZAK"
    cQuery += " WHERE D1_NUMORC = ZAK.ZAK_NUMORC"
	cQuery += " AND B1.B1_COD = D1.D1_COD"
	cQuery += " AND B1.B1_TIPO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND ZAK.ZAK_MESANO = '"+Strzero(MONTH(mv_par03),2)+"/"+ Strzero(year(mv_par04),4)+"'"
    cQuery += " AND ZAK.ZAK_TIPO = B1.B1_TIPO"
	cQuery += " AND D1.D1_DTDIGIT BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"' "
	cQuery += " AND D1.D_E_L_E_T_ = ' ' AND ZAK.D_E_L_E_T_ = ' ' AND B1.D_E_L_E_T_ = ' '"	
	cQuery += " ORDER BY B1.B1_TIPO"    
    memoWrit('C:\TEMP\EST114.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TRA1"
	
	TRA1->(DbGoTop())

Return

Static Function RptDetail()
Local _nTotal   := 0
Local _nToQuant := 0
Local _cTipo    := Space(02)

Cabec1 := "Do tipo: "+mv_par01+OemtoAnsi(" At้ ")+mv_par02
Cabec1 += OemtoAnsi(" - Perํodo: ")+DtoC(mv_par03)+OemtoAnsi(" At้ ")+DtoC(mv_par04)

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

SetRegua(1000)

_cTipo := TRA1->B1_TIPO 
While TRA1->(!Eof()) 

	If Prow() > 60
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	Endif
          
	IncRegua()
	@Prow()+1, 001 psay TRA1->D1_PEDIDO
	@Prow()  , 010 Psay TRA1->D1_FORNECE
	@Prow()  , 020 Psay TRA1->D1_ITEM
    @Prow()  , 030 Psay ALLTRIM(TRA1->D1_COD)+" - "+SUBSTR(TRA1->D1_DESCRI,1,30)
	@Prow()  , 078 psay TRA1->D1_DOC
   
    @Prow()  , 085 Psay TRA1->D1_QUANT Picture("@e 99999")
    _nToQuant += TRA1->D1_QUANT
    @Prow()  , 092 Psay TRA1->D1_VUNIT Picture("@e 99999.99") 
	@Prow()  , 105 psay TRA1->D1_TOTAL Picture("@e 99999.99")
	_nTotal += TRA1->D1_TOTAL

 	TRA1->(DbSkip())
 	
 	If _cTipo<>TRA1->B1_TIPO //Verifica quebra de pagina por tipo
	   @ Prow()+1,000 PSAY __PrtThinLine()
       @ Prow()+1,001 Psay "TOTAL -->:"
       @ Prow()  ,080 Psay _nToQuant Picture("@e 9999999999") 
       @ Prow()  ,100 Psay _nTotal Picture("@e 9999999999.99") 
 
       _cTipo    := TRA1->B1_TIPO 
       _nToQuant := 0
	   _nTotal   := 0
       If !Empty(_cTipo)
          Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
       Endif   
	Endif
	
EndDo
If _nToQuant > 0
   @ Prow()+1,000 PSAY __PrtThinLine()
   @ Prow()+1,001 Psay "TOTAL -->:"
   @ Prow()  ,080 Psay _nToQuant Picture("@e 9999999999") 
   @ Prow()  ,100 Psay _nTotal Picture("@e 9999999999.99") 
Endif

TRA1->(DbCloseArea())          

Return(nil)