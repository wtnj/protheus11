
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHPCP003 ³ Autor ³ Alexandre R. Bento    ³ Data ³ 13/05/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Importacao dos Arquivos de Programaçao das montadoras IED ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para a New Hubner                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Arquivos ³ IED,DBF Temporarios                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alterac. ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


#include "rwmake.ch"     
#include "Font.ch"     
#include "Colors.ch"   

User Function Nhpcp003() 

DEFINE FONT oFont NAME "Arial" SIZE 0, -12                                            
SetPrvt("_CCONTACRED,_CCONTADEB,cArqImp,_cArq,_aArq,lQtde,_cCod,_dDtAnt,x,cTxt,lOK,aRelease")
SetPrvt("_cCodCli,_cCodProd,_cNomCli,_cLojCli,_nQtde,_dData,aCols,aHeader,_cDoc,_cArqRel,aDiverg")
SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,_CORDEM,_CCABEC1,Lin,nMax,nTam,cKey")

aCols    := {}
aRelease := {}
aDiverg  := {}
_cArq    := Space(12) 
_cArqRel := Space(08) 
_cNomCli :="" 
_dData   := ddatabase
_cCodProd:= Space(15)
_nQtde   := 0.00
_cCodCli :="" 
_cDoc    :="" 
lQtde    := .T. // Controla quebra de qtde por dia
_dDtAnt  := CtoD("//")
lOK      := .F.

@ 96,42 TO 250,440 DIALOG oDlg6 TITLE OemToAnsi("Importação do Release")
@ 10,10 Say OemToAnsi("Atenção Digite Abaixo o nome do Arquivo recebido Via"+Chr(13)+;
                      "EDI com a Progração de peças do Mês") Color CLR_HRED Size 300,16 object oInfo
oInfo:SetFont(oFont)
@ 40,010 Say OemToAnsi("Digite o Nome do arquivo do Release :") Size 110,10 Object oTexto
oTexto:SetFont(oFont)
@ 40,120 Get _cArqRel Picture "@!" Size 40,10 Valid NaoVazio(_cArqRel) Object oArqRel

@ 55,135 BUTTON "Confirma" Size 45,15  ACTION Close(oDlg6)
ACTIVATE DIALOG oDlg6 CENTERED
//ALERT(_CARQREL)               
cARQIMP    := "C:\IED30\PARCEIRO\PSA\REC\"+Alltrim(_cArqRel) +".EKT"
//ALERT(CARQIMP)
If !File(cArqImp)
   MsgBox("Arquivo para Importar nao Localizado: " + cArqImp,"Arquivo Release","INFO")
   Return
Endif


//Subs(Dtos(dDatabase),7,2)+Subs(Dtos(dDatabase),5,2)+"1.TXT"   

Processa( {|| fCriaDBF() } )  //Cria arquivo temporario e appenda o arquivo txt

Processa( {|| fAnalisa() } )  //Analisa o arquivo se esta certo

//If lOk
//	Processa( {|| Importa() })
//Endif	
importa()         

If File( _cArq )   
   fErase(_cArq)    // Deleta arquivo de dados temporario
Endif
DbSelectArea("IED")
DbCloseArea()
   
Return

Static Function Importa()

IED->(DbGoTop())
ProcRegua(IED->(RecCount()))          

SA1->(DbSetOrder(1)) //filial+cliente _loja
SA7->(DbSetOrder(3)) //filial+cod cliente
SB1->(DbSetOrder(1)) //filial+produto

While IED->(!Eof())

	If SubStr(IED->TEXTO,001,3) == "PE1"       
	   _cDoc     := SubStr(IED->TEXTO,007,6)
	   _cCodProd := SubStr(IED->TEXTO,037,15) 

	   IF SA7->(DbSeek(xFilial("SA7")+_cCodProd)) 
			_cCodProd := SA7->A7_PRODUTO +" - "+ SA7->A7_DESCCLI  // Codigo da New Hubner + Descricao do produto
			_cCod     := SA7->A7_PRODUTO
		   _cCodCli  := SA7->A7_CLIENTE
	      _cLojCli  := SA7->A7_LOJA
    	   IF	SA1->(DbSeek(xFilial("SA1")+_cCodCli+_cLojCli)) 
		      _cNomCli := SA1->A1_COD + " - " + SA1->A1_LOJA + " - " + SA1->A1_NOME 
		   Else
		      MsgBox("Atenção Cliente Nao encontrado Verifique","Atencao","STOP")
   	          DbSelectArea("IED")
              DbCloseArea()

		      Return
		   Endif
	   Else
	      MsgBox("Atenção Codigo = "+Alltrim(SubStr(IED->TEXTO,037,15))+ " do Cliente Nao encontrado Verifique","Atencao","STOP")
	      DbSelectArea("IED")
          DbCloseArea()

	      Return
	   Endif
	   
	Endif   

	If SubStr(IED->TEXTO,001,3) == "PE3"       
	   //ALERT("ESTOU NO PD1 " + IED->TEXTO,004,15)
	   _nQtde := Val(SubStr(IED->TEXTO,012,09)) 
	   _dData := CTOD(SubStr(IED->TEXTO,008,2)+"/"+SubStr(IED->TEXTO,006,2)+"/"+SubStr(IED->TEXTO,004,2))
      
      If Empty( _dDtAnt)
         _dDtAnt:= _dData //Guarda data anterior
      Endif
      
	   If (_dData - _dDtAnt) > 20  //Verifica se é progração do mês
    	   Aadd(aCols,{_cCodProd,_dData,_nQtde,"04"}) //Adiciona os Qtde total pois é progragração p/ o mes
    	   _dDtAnt:= _dData //Guarda data p/ verif. prog. mês
	   Else
         _dDtAnt:= _dData //Guarda data p/ verif. prog. mês
	      If SB1->(DbSeek(xFilial("SB1")+_cCod)) //filial+codido produto
	      // Explosao do release por dia pegando o lote economico do produto
	         While lQtde
	            IF _nQtde > SB1->B1_LE
	               
	               If SB1->B1_LE == 0
	                  lQtde := .F.
	                  Aadd(aCols,{_cCodProd,_dData,_nQtde,"04"}) //Adiciona os campos para o multiline
	                  Alert("Lote Economico do Produto " + _cCodProd + " Zerado ")
	               Else
	                  Aadd(aCols,{_cCodProd,_dData,SB1->B1_LE,"04"}) //Adiciona os campos para o multiline
	                  _nQtde := _nQtde - SB1->B1_LE 
	                  _dData := _dData + 1  // Soma mais um Dia para programação de peça
	               Endif
	                  
	               IncProc("Importando Release..." )
	            Else                             
	              // _nQtde := SB1->B1_LM - _nQtde
//	               MsgBox("Para o Dia " + DtoC(_dData+1)+" So Sera Gerado Previsao Programacao de "+chr(13)+;
//	                      Transform(_nQtde,"@e 9999")+" Mas o Lote Minimo eh "+Transform(SB1->B1_LM,"@e 9999"),+chr(13)+;
//	                      "Importaçao do Release","INFO")
						Aadd(aDiverg,_cCodProd) 
	               Aadd(aDiverg,"Para o Dia " + DtoC(_dData+1)+OEMtoAnsi(" So foi Gerado Previsão Programação de ")+;
	               Transform(_nQtde,"@e 9999")+OEMtoAnsi(" Mas o Lote Minimo é ")+Transform(SB1->B1_LE,"@e 9999"))
	               Aadd(aCols,{_cCodProd,_dData,_nQtde,"04"}) //Adiciona os campos para o multiline
	               lQtde := .F. // Sai do while
//	               alert(adiverg[1])
	            Endif
	         Enddo
	         lQtde := .T. //Volta Flag p/ explosão do release por dia
	      Endif	   
		Endif   
	Endif //fim PE3  
   IED->(DbSkip())
   IncProc("Importando Release..." )
EndDo

For x:= 1 to Len(aCols)
//    aRelease := aCols //Grava o release na matriz ate o usuario confirmar a programação
    Aadd(aRelease,{acols[x][1],acols[x][2],acols[x][3],acols[x][4]}) //Adiciona os campos para o multiline
Next x

If Len(aDiverg) > 0
   MsgBox("Foram Encontradas Algumas Divergências na Geração da Programação Diaria"+chr(13)+;
          "Click em OK para Imprimir") 
   fImp_Div()
Endif

nMax := Len(aCols)
aHeader     := {}

Aadd(aHeader,{"Produto"    , "UM",Repli("!",40)       ,40,0,".F.","","C","SC4"})                   //03
Aadd(aHeader,{"Data"       , "UM"  ,"99/99/99"           ,08,0,".F.","","N","SC4"}) //06
Aadd(aHeader,{"Qtde"       , "C4_QUANT"  ,"@E 999,999,999.99" ,12,2,".T.","","N","SC4"}) //06
Aadd(aHeader,{"Local"      , "UM"  ,"!!"                ,02,0,".F.","","C","SC4"})                   //03
   
@ 167,098 To 588,791 Dialog dlgRelease Title "Recebimento do Release"
@ 006,007 Say "Cliente"   Size 30,8
@ 019,007 Say "Documento" Size 55,8
@ 004,040 Get _cNomCli  Size 180,10 When .F. Object oNomCli
@ 018,040 Get _cDoc     Size 030,10 When .F. Object oDoc
@ 037,006 TO 190,335 MULTILINE MODIFY OBJECT oMultiline
@ 196,280 BmpButton Type 1 Action fGera()
@ 196,310 BmpButton Type 2 Action Close(dlgRelease)           
oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline
Activate Dialog dlgRelease 
              
Return
  
                                     
Static Function fGera()    

//Grava na tabela SC4 previsão de vendas
 
	For x:=1 to Len(aRelease)
      Begin Transaction
			RecLock("SZ1",.T.)
		   SZ1->Z1_FILIAL  := xFilial("SZ1")
		   SZ1->Z1_PRODUTO := SubStr(aRelease[x][1],1,13)  // Codigo do produto
		   SZ1->Z1_LOCAL   := aRelease[x][4]  //Local
		   SZ1->Z1_DOC     := _cDoc   // Numero documento
		   SZ1->Z1_QUANT   := aRelease[x][3] // Qtde que veio no release    
	      SZ1->Z1_QUANTPR := aCols[x][3] // Qtde que foi alterada pelo PCP
		   SZ1->Z1_DATA    := aRelease[x][2] // Data da prog. no release
		   SZ1->Z1_OBS     := Alltrim(_cArqRel) +".EKT"  //nome do arquivo que foi importado
			MsUnLock("SZ1")    
		
			RecLock("SC4",.T.)
		   SC4->C4_FILIAL  := xFilial("SC4")
		   SC4->C4_PRODUTO := SubStr(aCols[x][1],1,13)  // Codigo do produto
		   SC4->C4_LOCAL   := aCols[x][4]  //Local
		   SC4->C4_DOC     := _cDoc   // Numero documento
		   SC4->C4_QUANT   := aCols[x][3] // Qtde que veio no release
		   SC4->C4_DATA    := aCols[x][2] // Data da prog. no release
		   SC4->C4_OBS     := Alltrim(_cArqRel) +".EKT"  //nome do arquivo que foi importado
			MsUnLock("SC4")
		End Trasaction
	Next x
	Close(dlgRelease)
   Alert(OEMtoAnsi("Geração da Previsão de Vendas com Sucesso"))
Return

Static Function fCriaDBF()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando Arquivo Temporario para posterior impressao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cArq  := CriaTrab(NIL,.f.)
_cArq += ".DBF"
_aArq := {}

AADD(_aArq,{"Texto"   ,"C", 200,0})    // Identificacao linha a linha

DbCreate(_cArq,_aArq)
//DbUseArea(.T.,,_cArq,"IED",.F.) 
USE &_cArq Alias IED New Exclusive
Append From (cArqImp) SDF // Copia do Arquivo texto para o arquivo de Importacao

Return


//Analisa o arquivo que foi appendado se é de programação
Static Function fAnalisa()

IED->(DbGoTop())
ProcRegua(IED->(RecCount()))          
While IED->(!Eof())
	
	If SubStr(IED->TEXTO,001,3) == "PE3" 
	   lOK := .T.
	Endif      
   IncProc("Analisando Arquivo de Release..." )
	IED->(Dbskip())
	
Enddo	

If !lOK
   cTxt := OEMtoAnsi("Atenção Arquivo Digitado não tem Programação Verifique o Nome do Arquivo") 
   MsgBox(cTxt,OEMtoAnsi("Importação do Release"),"INFO") 
Endif

Return	    

Static Function fImp_Div()

cString  :="SC4"
cDesc1   := OemToAnsi("Este relatorio tem como objetivo demostrar a            ")
cDesc2   := OemToAnsi("Divergências na programação Diaria baseando-se pela data")
cDesc3   := OemToAnsi("prevista de entrega.                                    ")
tamanho  :="M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog :="NHPCP005"
nLastKey := 0
Lin      := 0
titulo   :=OemToAnsi("Divergência na Programação Diaria")
cabec1   :=OemToAnsi("Divergência na Programação Diaria")
cabec2   :=""
cCancel  := "***** CANCELADO PELO OPERADOR *****"
_nPag    := 1  //Variavel que acumula numero da pagina

wnrel  :="NHCOM0005"          //Nome Default do relatorio em Disco
_cPerg := ""



//Pergunte(_cPerg,.f.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

Processa( {|| RptDetail() },"Imprimindo Divergencias..." )

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


Static Function RptDetail()

ProcRegua(Len(aDiverg))

//               10         20       30         40       50        60         70       80          90     100      110        120       130        140
//           012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
_cCabec1 := "PRODUTO         DESCRICAO DA DIVERGENCIA"
         
Cabecalho()

For x:= 1 to Len(aDiverg)

    // Imprime as Informacoes

   If Lin > 60
      Lin := 0
      _nPag := _nPag + 1
      Cabecalho()
      @ Lin + 1 , 001 Psay _cCabec1
      Lin := Lin + 1
   Endif

   // Imprime os Dados
   Lin := Lin + 1    
   @ Lin    , 001 Psay Alltrim(aDiverg[x])
   If Mod(x,2) == 0
      Lin := Lin + 1
   Endif
Next

Return

Static Function Cabecalho()

aDriver := ReadDriver()

If ( Tamanho == 'P' )
    @ 0,0 PSAY &(aDriver[1])
ElseIf ( Tamanho == 'G' )
    @ 0,0 PSAY &(aDriver[5])
ElseIf ( Tamanho == 'M' ) .And. ( aReturn[4] == 1 ) 
    @ 0,0 PSAY &(aDriver[3])
ElseIf ( Tamanho == 'M' ) .And. ( aReturn[4] == 2 ) 
    @ 0,0 PSAY &(aDriver[4])
EndIf 

@ Lin+1,00   Psay Repli("*",132)
Lin := Lin + 1
@ Lin+1,00   Psay "*"+SM0->M0_NOMECOM
@ Lin+1,112  Psay "Folha : "                                                                                                    
@ Lin+1,124  Psay StrZero(_nPag,5,0)+"  *"
@ Lin+2,00   Psay "*S.I.G.A. / "+nomeprog
@ Lin+2,20   Psay PadC(titulo,82)
@ Lin+2,112  Psay "DT.Ref.: "+Dtoc(dDataBase)+"  *"
@ Lin+2+1,00 Psay "*Hora...: "+Time()
//@ Lin+3  ,41 Psay "Periodo de: " + DtoC(mv_par01) + " Ate: " + DtoC(mv_par02) 
@ Lin+3,112  Psay "Emissao: "+Dtoc(Date())+"  *"
@ Lin+4 ,00  Psay Repli("*",132)
@ Lin+5,00   Psay " "
lin:=Lin+4

Return
                                    
