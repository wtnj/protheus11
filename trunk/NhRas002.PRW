/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHTER003  ³ Autor ³ Alexandre R. Bento     Data ³ 03/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta Rastreabilidade de Peças feita pela gravadora meca³±±
±±³          ³ nica Modelo de impressao 0001 Serial 184/06 T1             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Engenharia e Qualidade                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"

User Function NHRAS002()

SetPrvt("_cSerial,_cDesc,_cProd,_dData,_cHora,_cOper,_cNomeOp")
SetPrvt("nMax,aHeader,aCols,oMultiline,cQuery,lMed,oBtMed,aMed,nLdlg,nCdlg,_SolNor,nI")  
SetPrvt("_cArqDBF,_aFields,aBotoes1,_cBarra,_cCodCli,_dData,_cTurno,_cHoraI,_cHoraF")


 nMax    := 1 
_cSerial := Space(09)
_cDesc   := Space(30)
_cProd   := Space(15)
_cNomeOp := Space(30)
_cOper   := Space(06)               
_cArqDBF := Space(12) 
_cBarra  := Space(15) 
lMed     := .F.
aMed     := {}


aBotoes1 := {{"RELATORIO",{|| U_fRelMed2() },OemToAnsi("Relatório de Medições"    )}}
     
Private nOpc   := 0
Private bOk    := {||nOpc:=1,_SolNor:End()}
Private bCancel:= {||nOpc:=0,_SolNor:End()} 
 
aHeader   := {}
aCols     := {}

Aadd(aHeader,{"Data"     , "UM",  "99/99/99"        ,08,0,".F.","","C","SZE"}) //03
Aadd(aHeader,{"Hora"     , "ZE_HORA"  ,"99:99:99"   ,08,0,".F.","","C","SZE"}) //06
Aadd(aHeader,{"Status" , "UM"  ,Repli("!",40)     ,40,0,".F.","","C","SZE"}) //03
//Aadd(aHeader,{"Status" , "ZF_OPERACA"  ,"@!"      ,03,0,".F.","","C","SZF"}) //06
//Aadd(aHeader,{"Status" , "UM"  ,Repli("!",40)     ,40,0,".F.","","C","SZE"}) //03
Aadd(aCols,{"99/99/99","99:99:99","Produto Nao Encontrado"}) //03
 
Define MsDialog _SolNor Title OemToAnsi("Pesquisa Produção de Peça") From 020,030 To 380,770 Pixel 
@ 013,006 To 053,362 Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE
@ 027,010 Say "Serial :" Color CLR_HBLUE  Size 040,8            
@ 025,030 Get _cSerial Picture "@!" F3 "SZE"     Size 050,8 Object oSerial            
@ 027,090 Say "Produto:" Color CLR_HBLUE  Size 40,8            
@ 025,120 Get _cProd Picture "@!" F3 "SZA" Valid fProd()  Size 50,8 Object oProd            
@ 025,175 Get _cDesc Picture "@!" When .F.    Size 180,8 Object oDesc

@ 040,010 Say "Cod.Cliente:" Color CLR_HBLUE  Size 040,8            
@ 038,040 Get _cCodCli Picture "@!" When .F.  Size 040,8 Object oCodCli            

@ 040,090 Say "Calendario/Ano Turno:" Color CLR_HBLUE  Size 070,8            
@ 038,150 Get _cBarra Picture "@!"  Size 035,8 Valid fBarra() Object oBarra             
@ 038,263 Button OemToAnsi("_Pesquisar...")   Size 36,12 Action fPesqui() Object oBtPes            
@ 055,006 To 150,362 Title OemToAnsi("  Informações ")  
//oMultiline:nMax //:= Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline          
@ 070,015 TO 140,355 MULTILINE MODIFY OBJECT oMultiline
@ 160,300 Button OemToAnsi("_Medições...")    Size 36,12  Action fMedicao() Object oBtMed            
Activate MsDialog _SolNor On Init EnchoiceBar(_SolNor,bOk,bCancel,,aBotoes1) Centered

If File(_cArqDBF)
   DbSelectArea("MAR")
   DbCloseArea()
   fErase(_cArqDBF)
Endif   

Return


Static Function fPesqui()
   
   aCols := {} // inicializacao da matriz novamente                
   aMed  := {} // inicializaçao da matriz de medição

   If File(_cArqDBF) .And.  !Empty(_cArqDBF)  //Exclue o arquivo temp. se for fazer uma nova pesquisa.
      DbSelectArea("MAR")
      DbCloseArea()
      fErase(_cArqDBF)
   Endif

//   _cSerial := StrZero(Val(_cSerial),9)          
  
/*
  				dbSelectArea("SF3")
				dbSetOrder(4)
						cQuery    += "WHERE SF3.F3_FILIAL='"+xFilial("SF3")+"' AND "
						cQuery    += "ORDER BY "+SqlOrder(SF3->(IndexKey()))
*/
   SZE->(DbSetOrder(1))
   cQuery := "SELECT SZE.ZE_PRODUTO,SZE.ZE_SERIAL,SZE.ZE_OPER,SB1.B1_DESC,SZE.ZE_DATA,SZE.ZE_HORA,SZH.ZH_ITEM,SZH.ZH_DESC,SZE.ZE_MAQUINA" 
   cQuery += " FROM " + RetSqlName( 'SZE' ) +" SZE," + RetSqlName( 'SB1' ) +" SB1 ," + RetSqlName( 'SZH' ) +" SZH"  
   cQuery += " WHERE SZE.ZE_FILIAL='"+xFilial("SZE")+"' "   
   cQuery += " AND SZH.ZH_FILIAL='"+xFilial("SZH")+"' "   
   cQuery += " AND SB1.B1_FILIAL='"+xFilial("SB1")+"' "      
   cQuery += " AND SZE.D_E_L_E_T_ = ' '"   
   cQuery += " AND SZH.D_E_L_E_T_ = ' '"
   cQuery += " AND SB1.D_E_L_E_T_ = ' '"
   cQuery += " AND SZE.ZE_PRODUTO = '" + _cProd + "' "   
   cQuery += " AND SZE.ZE_SERIAL = '" + _cSerial + "' "      
   cQuery += " AND SZE.ZE_DATA = '" + Dtos(_dData) + "' "    
   If  _cHoraI <> "23:01"                                                               
      cQuery += " AND SZE.ZE_HORA BETWEEN '" + _cHoraI + "' AND '" + _cHoraF + "'"   
   Else
      cQuery += " AND (SZE.ZE_HORA BETWEEN '23:01' AND '23:59:99' "   
      cQuery += " OR SZE.ZE_HORA BETWEEN '00:00' AND '06:30' )"            
   Endif   
   cQuery += " AND SZE.ZE_PRODUTO *= SZH.ZH_PRODUTO"
   cQuery += " AND SZE.ZE_SERIAL *= SZH.ZH_SERIAL"
   cQuery += " AND SZE.ZE_DATA *= SZH.ZH_DATA"   
   cQuery += " AND SZE.ZE_PRODUTO = SB1.B1_COD"
   cQuery += " ORDER BY " + SqlOrder(SZE->(IndexKey()))


//   MemoWrit('C:\TEMP\MOSTRA.SQL',cQuery)
   //TCQuery Abre uma workarea com o resultado da query
   TCQUERY cQuery NEW ALIAS "TMP"                      
   TcSetField("TMP","ZE_DATA","D")  // Muda a data de string para date    
   fMSerie() // Mostra o conteudo da pesquisa do numero de serie
Return

Static Function fMSerie()

Local lPrim := .T.
Local nItem := 0

   TMP->(Dbgotop())
   If Empty(TMP->ZE_PRODUTO)
      MsgBox("Nenhuma Leitura foi Encontrada para este Serial","Atencao","STOP")
      DbSelectArea("TMP")
      DbCloseArea()
      Return
   Endif 


   While TMP->(!Eof())
      
      nI := Ascan(aCols, {|x| x[1]+x[2] == Dtoc(TMP->ZE_DATA)+TMP->ZE_HORA})
	  If nI == 0
         Aadd(aCols,{Dtoc(TMP->ZE_DATA),TMP->ZE_HORA," Produto Encontrado"})
      Endif

      If TMP->ZH_ITEM <> nItem  
          nItem := TMP->ZH_ITEM //para não permitir item duplicado
	      If TMP->ZH_ITEM > 0 //So adiciona
	         If lPrim
	            fCriaTmp() // Cria arquivo temporario
	            lPrim := .F.
	         Endif
	         //Aadd(aMed,{StrZero(TMP->ZH_ITEM,2),TMP->ZH_DESC})         
	         //ALERT(Substr(TMP->ZH_DESC,1,16))
	         Reclock("MAR",.T.)
				MAR->ITEM       := StrZero(TMP->ZH_ITEM,2)
				MAR->DESCRICAO  := Substr(TMP->ZH_DESC,1,16)
				MAR->VALOR      := Substr(TMP->ZH_DESC,18,8)
				MAR->UND        := Substr(TMP->ZH_DESC,27,2)
				MAR->STATUS     := Substr(TMP->ZH_DESC,31,6)
				MAR->DELTA      := Substr(TMP->ZH_DESC,38,7)
				MAR->PERCENTUAL := Substr(TMP->ZH_DESC,45,6)
				MAR->UNREC      := Substr(TMP->ZH_DESC,52,8)
				MAR->REC        := Substr(TMP->ZH_DESC,61,8)
				MAR->ABS        := Substr(TMP->ZH_DESC,70,8)
	         MsUnlock("MAR")
	         
	      Endif   
      Endif
      
      TMP->(Dbskip())
   Enddo
   nMax := Len(aCols) //atualiza numero de linhas de pesquisa
   oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline   
   ObjectMethod(oMultiline ,"Refresh()")
   DbSelectArea("TMP")
   DbCloseArea()

   //orderna a matriz pelo operador
   aCols := ASort(aCols,,, { |x, y| x[1] < y[1]}) //ordena por operação

Return

Static Function fProd()
aCols := {} // inicializacao da matriz novamente                
aMed  := {} // inicializaçao da matriz de medição

If File(_cArqDBF) .And.  !Empty(_cArqDBF)  //Exclue o arquivo temp. se for fazer uma nova pesquisa.
   DbSelectArea("MAR")
   DbCloseArea()
   fErase(_cArqDBF)
Endif
SB1->(DbsetOrder(1)) //filial+codigo  do produto
If !Empty(_cProd)
	If !SB1->(dbSeek(xFilial("SB1")+_cProd,.T. ))
	   MsgBox("Produto Nao Cadastrado","Atençao","ALERT") 
	   Return(.F.)
	EndIf                                           
	_cDesc   := SB1->B1_DESC
	_cCodCli := SB1->B1_CODAP5 
  //	_cBarra  := Subs(SB1->B1_CODBAR,1,6) + StrZero(Val(_cSerial),9)              
	ObjectMethod(oDesc ,"Refresh()")
	ObjectMethod(oCodCli,"Refresh()")
//	ObjectMethod(oBarra ,"Refresh()")
Endif	

Return(.T.)


Static Function fBarra()    

_cHoraI:= Space(05)
_cHoraF:= Space(05)

If Len(Alltrim(_cBarra)) == 8
   _dData   := Ctod("01/01/"+ Subs(Alltrim(_cBarra),5,2)) + Val(Subs(Alltrim(_cBarra),1,3)) + 1    
Else
    MsgBox("Informações Referente a Data de Fabricação foram digitada Errada"+Chr(13)+;
           " Exemplo 180/06T1, Dia e Mes / Ano e Turno","Atençao","ALERT") 
Endif                       
_cTurno := Subs(Alltrim(_cBarra),8,1)
If _cTurno == "1"
   _cHoraI := "06:31"
   _cHoraF := "14:50"
Elseif _cTurno == "2"
   _cHoraI := "14:51"
   _cHoraF := "23:00"
Elseif _cTurno == "3"
   _cHoraI := "23:01"
   _cHoraF := "06:30"   
Endif

/*aCols := {} // inicializacao da matriz novamente                
aMed  := {} // inicializaçao da matriz de medição

If File(_cArqDBF) .And.  !Empty(_cArqDBF)  //Exclue o arquivo temp. se for fazer uma nova pesquisa.
   DbSelectArea("MAR")
   DbCloseArea()
   fErase(_cArqDBF)
Endif
SB1->(DbsetOrder(5)) //filial+codigo de barra
If !SB1->(dbSeek(xFilial("SB1")+Subs(_cbarra,1,6)))
	   MsgBox("Codigo de Barras Nao Cadastrado","Atençao","ALERT") 
	   Return(.F.)
EndIf                                           
_cProd   := SB1->B1_COD
_cDesc   := SB1->B1_DESC
_cCodCli := SB1->B1_CODAP5 
_cBarra  := Subs(SB1->B1_CODBAR,1,6) + StrZero(Val(Subs(_cbarra,7,9)),9)     
_cSerial := Subs(_cBarra,7,9)
ObjectMethod(oProd ,"Refresh()")
ObjectMethod(oDesc ,"Refresh()")
ObjectMethod(oCodCli,"Refresh()")
ObjectMethod(oBarra ,"Refresh()")
ObjectMethod(oSerial,"Refresh()")
  */
Return(.T.)


Static Function fMedicao()

Local x :=1   
Local aCampos := {}

If !File(_cArqDBF) .Or.  Empty(_cArqDBF)  //Verifica se existe o arquivo para pesquisa
   MsgBox("Para Este Produto Nao Existe Medição","Atençao","ALERT") 
   Return(.F.)
Endif

DbSelectArea("MAR")
MAR->(DbGotop())
aCampos := {}

AADD(aCampos,{"ITEM"      ,"Item","@!","02"})         
AADD(aCampos,{"DESCRICAO" ,"Descricao","@!","20"})         
AADD(aCampos,{"VALOR"     ,"Valor","@!","08"})        
AADD(aCampos,{"UND"       ,"Und","@!","02"})        
AADD(aCampos,{"STATUS"    ,"Status","@!","06"})        
AADD(aCampos,{"DELTA"     ,"Delta","@!","07"})        
AADD(aCampos,{"PERCENTUAL","Percentual","@!","06"})        
AADD(aCampos,{"UNREC"     ,"Unrec","@!","08"})       
AADD(aCampos,{"REC"       ,"Rec","@!","08"})       
AADD(aCampos,{"ABS"       ,"Abs","@!","08"})       

@ 100,30 To 530,830 Dialog dlgMed Title OemToAnsi("Medições")   
@ 010,012 Say "Codigo :" Color CLR_HBLUE  Size 040,8            
@ 010,035 Get _cProd Picture "@!" When .F. Size 50,8 Object oProd            
@ 010,085 Get _cDesc Picture "@!" When .F. Size 170,8 Object oDesc
@ 010,312 Say "Cod.Cliente :" Color CLR_HBLUE Size 040,8            
@ 010,340 Get _cCodCli Picture "@!" When .F.  Size 040,8 Object oCodCli            
@ 025,010 TO 190,390 BROWSE "MAR" Fields aCampos
@ 200,330 BmpButton Type 1 Action Close(dlgMed)
Activate Dialog dlgMed Centered

Return 

Static Function fCriaTmp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando Arquivo Temporario para posterior impressao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cArqDBF  := CriaTrab(NIL,.f.)
_cArqDBF += ".DBF"
_aFields := {}

AADD(_aFields,{"ITEM"      ,"C",02,0})         
AADD(_aFields,{"DESCRICAO" ,"C",20,0})         
AADD(_aFields,{"VALOR"     ,"C",08,0})        
AADD(_aFields,{"UND"       ,"C",02,0})        
AADD(_aFields,{"STATUS"    ,"C",06,0})        
AADD(_aFields,{"DELTA"     ,"C",07,0})        
AADD(_aFields,{"PERCENTUAL","C",06,0})        
AADD(_aFields,{"UNREC"     ,"C",08,0})       
AADD(_aFields,{"REC"       ,"C",08,0})       
AADD(_aFields,{"ABS"       ,"C",08,0})       

DbCreate(_cArqDBF,_aFields)
DbUseArea(.T.,,_cArqDBF,"MAR",.F.)

Return

User Function fRelMed2()

//SetPrvt("NQTDE1,NQTDE2,NQTDE3,nEtq")

cString   := "SZE"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir a  ")
cDesc2    := OemToAnsi("Rastreabilidade de Peças")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHTER003"
nLastKey  := 0
titulo    := "RELATÓRIO DE RASTREABILIDADE"
Cabec1    := ""
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1  
wnrel     := "NHTER003"
_cPerg    := "TER003" 
//aOrd      := {OemToAnsi("Por Produto"),OemToAnsi("Por Etiqueta")} // ' Por Codigo         '###' Por Tipo           '###' Por Descricao    '###' Por Grupo        '

//AjustaSx1()                                                               

//Pergunte(_cPerg,.F.)
/*
If !Pergunte(_cPerg,.T.)
    Return(nil)
Endif   
*/
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
cNormal := aDriver[2]

//if aReturn[8] == 2 //ordem por etiqueta
//   Cabec1    := "COD PRODUTO    COD.CLIENTE    DESCRIÇÃO DO PRODUTO            ETIQ    DOC    ALM LOCALIZ      QTDE "
//Endif   

//Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")

//Close TMP

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function RptDetail()

If Len(aCols) == 0
   MsgBox("Nenhum Produto Encontrado","Atençao","ALERT") 
   Return(.F.)
Endif

Cabec1    := "Produto : " +_cProd +" - "+_cDesc+"      Cod.Cliente : "+_cCodCli+"         Serial : " +_cSerial
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

@ Prow() + 1, 000 Psay OemToAnsi("DATA       HORA")

For x:= 1 to len(aCols)
  
  // If Prow() > 60
//      _nPag := _nPag + 1
//      Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
//   Endif
   @ Prow() + 1, 000 Psay aCols[x][1]
   @ Prow()    , 011 Psay aCols[x][2]
//   @ Prow()    , 023 Psay aCols[x][3]+"-"+aCols[x][5]//TMP->ZF_OPERACA+" - "+TMP->ZF_DESC 	
//   @ Prow()    , 070 Psay aCols[x][4]//TMP->ZE_OPER 
	
Next
    
If File(_cArqDBF) .And.  !Empty(_cArqDBF)  //Exclue o arquivo temp. se for fazer uma nova pesquisa.

   MAR->(DbGotop())
   @ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes da Medição
   @ Prow() + 1, 000 Psay OemToAnsi("ITEM  DESCRIÇÃO                VALOR    UND      STATUS   DELTA   PERCENTUAL  UNREC       REC       ABS")

   While !MAR->(EOF())
      
      @ Prow() + 1, 000 Psay MAR->ITEM
      @ Prow()    , 006 Psay MAR->DESCRICAO
      @ Prow()    , 028 Psay MAR->VALOR
      @ Prow()    , 041 Psay MAR->UND
      @ Prow()    , 050 Psay Alltrim(MAR->STATUS)
      If !empty(Alltrim(MAR->DELTA))
         @ Prow()    , 059 Psay Alltrim(MAR->DELTA)
         @ Prow()    , 068 Psay Alltrim(MAR->PERCENTUAL)+"%"
         @ Prow()    , 075 Psay MAR->UNREC
         @ Prow()    , 085 Psay MAR->REC
         @ Prow()    , 095 Psay MAR->ABS

      Else
         @ Prow()    , 076 Psay MAR->UNREC
         @ Prow()    , 086 Psay MAR->REC
         @ Prow()    , 096 Psay MAR->ABS
             
      Endif   
            
      MAR->(Dbskip())

   Enddo

Endif

Return(nil) 
