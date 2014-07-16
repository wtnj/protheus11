/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST032  ºAutor  ³Alexandre R. Bento  º Data ³  27/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao de etiqueta codigo Barras (Operador e movimento)  º±±
±±º          ³Impressora TERMICA SATO                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Para Produção                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function NhEst032()

SetPrvt("_cCod,_cDesc,_nQuant,_aOpçoes,_cOpe,_nPos,cNovaLinha,cInicializa,cFinaliza,")
SetPrvt("cConfEtB1,cConfEtB2,cConfEtN1,cConfEtN2,_cCodigo")
_cCod       := Space(15)
_cDesc      := Space(30)
_cOpe       := Space(06)
_nQuant     := 0
_aOpcoes    := {"Operador ","Produto "}
_nPos       := 1  
cNovaLinha  := Chr(13) + Chr(10)
cInicializa := "//"+cNovaLinha+"//"+cNovaLinha+"//"+cNovaLinha+Chr(27)+"A"  //inicialização da impressora termica SATO
cFinaliza   := Chr(27)+"&" +Chr(27) + "Z" +Chr(27) + "A" +Chr(27) + "Q1" + Chr(27) + "/" + Chr(27) + "Z" //Finalização da impressora termica SATO
cConfEtB1   := Chr(27) + "H0316" + Chr(27) + "V0008"+Chr(27) + "D101076" // + *codigo de barra*"
cConfEtB2   := Chr(27) + "H0604" + Chr(27) + "V0008"+Chr(27) + "D101076" // + *codigo de barra*"
cConfEtN1   := Chr(27) +"P02" +Chr(27) + "H0310" + Chr(27) + "V0091"+Chr(27) + "L0202" +Chr(27) + "U" //codigo
cConfEtN2   := Chr(27) +"P02" +Chr(27) + "H0595" + Chr(27) + "V0091"+Chr(27) + "L0202" +Chr(27) + "U" //codigo

@ 100,050 To 300,370 Dialog DlgItem Title OemToAnsi("Imprime Código de Barra")
@ 005,008 To 075,150                                     
@ 020,050 Say OemToAnsi("Escolha uma Opção")   Size 150,8
@ 040,050 RADIO _aOpcoes VAR _nPos   
@ 080,080 BMPBUTTON TYPE 01 ACTION fOK()
@ 080,120 BMPBUTTON TYPE 02 ACTION Close(DlgItem)
Activate Dialog DlgItem Centered

Return


Static Function fOK()
   Close(DlgItem)
   If _nPos == 1
      fOperador()
      Close(DlgOpe)

   Else
      fProduto()   
      Close(DlgImp)
   Endif

Return

Static Function fOperador()

_nQuant := 2 // imprime sempre 2 etiq de operador 

@ 200,050 To 420,585 Dialog DlgOpe Title OemToAnsi("Impressão de Código de Barras do Operador")
@ 005,008 To 100,260

@ 042,020 Say OemToAnsi("Operador    ") Size 35,8
@ 040,070 Get _cOpe      Picture "@!" F3 "QAA" Valid fOpe() Size 55,8 Object oOpe 
@ 040,124 Get _cDesc     Picture "@!" When .F. Size 120,8 Object oDesc 

@ 080,185 BMPBUTTON TYPE 01 ACTION fImpBarras()
@ 080,225 BMPBUTTON TYPE 02 ACTION Close(DlgOpe)
Activate Dialog DlgOpe CENTERED

Return


Static Function fOpe()
Local lReturn := .T.
                                              
QAA->(dbSetOrder(1)) //Filial+ matricula
If !QAA->(dbSeek(xFilial("QAA")+_cOpe ))
	MsgBox(OemToAnsi("Operador Não Encontrado"),OemToAnsi("Atenção"),"INFO")
    cOpe := Space(06)              
    ObjectMethod(oOpe ,"Refresh()")
    lReturn := .F.
Else
   _cDesc := QAA->QAA_NOME
   ObjectMethod(oDesc ,"Refresh()")
EndIf   

Return (lReturn)


Static Function fProduto()

@ 200,050 To 420,585 Dialog DlgProd Title OemToAnsi("Impressão de Código de Barras do Produto")
@ 005,008 To 100,260

@ 042,020 Say OemToAnsi("Produto    ") Size 35,8
@ 057,020 Say OemToAnsi("Quantidade ") Size 35,8
@ 040,070 Get _cCod      Picture "@!" F3 "SB1" Valid fCod() Size 55,8 Object oCod 
@ 040,124 Get _cDesc     Picture "@!" When .F. Size 120,8 Object oDesc 
@ 055,070 Get _nQuant    Picture "@E 999,999,999.99"  Valid fQtde() Size 75,8

@ 080,185 BMPBUTTON TYPE 01 ACTION fImpBarras()
@ 080,225 BMPBUTTON TYPE 02 ACTION Close(DlgProd)
Activate Dialog DlgProd CENTERED

Return

Static Function fQtde()
Local lReturn := .T.

If _nQuant <= 0
   MsgBox(OemToAnsi("Quantidade do Produto errada Redigite"),OemToAnsi("Atenção"),"INFO")
   lReturn := .F.
Endif            

If Mod(_nQuant,2) <> 0
   MsgBox(OemToAnsi("Quantidade não pode ser IMPAR, pois a etiq é dupla"),OemToAnsi("Atenção"),"INFO")
   lReturn := .F.

Endif

Return(lReturn)

Static Function fCod()
Local lReturn := .T.

   //Faz verificacao se foi digitado o codigo NEW HUBNER ou o Codigo do CLIENTE
   IF Subs(_cCod,5,1) == "."             
      SB1->(DbsetOrder(1)) //filial+codap5
	   If SB1->(DbSeek(xFilial("SB1")+_cCod),Found())	
			_cDesc := SB1->B1_DESC
            ObjectMethod(oDesc ,"Refresh()")
		Else
			MsgBox("Produto nao Encontrado",OemToAnsi("Atenção"),"INFO")
			lReturn := .F.
		Endif
	Else
		 SB1->(DbsetOrder(9)) //filial+codap5
		 If SB1->(DbSeek(xFilial("SB1")+_cCod),Found())	
		    _cDesc := SB1->B1_DESC
  		    _cCod := SB1->B1_COD           
            ObjectMethod(oDesc ,"Refresh()")
            ObjectMethod(oCod  ,"Refresh()")            
		 Else
			 MsgBox("Produto nao Encontrado",OemToAnsi("Atenção"),"INFO")
			 lReturn := .F.
	 	 Endif
		
	Endif
Return(lReturn)

                                                 
Static Function fImpBarras()

//"B103100*CODE 39*"
// Codificação p/ impressora Termica SATO
// D/B = bar code symbol
// 1 = code 39
// bb = numero de pontos (01-12) p/ barra estreita e espaço estreito
// ccc = altura de barras em ponto 001-600

Local cARQEXP      := "C:\SATO"
Local cARQ         := FCreate(cARQEXP)  

If _nPos == 1
    _cCodigo := _cOpe // codigo do operador     
    Close(DlgOpe)
Else                 
    _cCodigo := _cCod // codigo do produto       
    Close(DlgProd)
Endif

FWrite(cArq,(cInicializa+cNovaLinha))                     
For x:=0 to _nQuant Step 2 // pois as etiquetas são 2 por linha                     

   FWrite (cArq,(cConfEtB1+"*"+AllTrim(_cCodigo)+"*"+cNovaLinha))
   FWrite (cArq,(cConfEtB2+"*"+Alltrim(_cCodigo)+"*"+cNovaLinha))
   FWrite (cArq,(cConfEtN1+Alltrim(_cCodigo)+cNovaLinha))
   FWrite (cArq,(cConfEtN2+Alltrim(_cCodigo)+cNovaLinha))
   
Next
FWrite(cArq,(cFinaliza+cNovaLinha))   
FClose(cARQ)            

//winexec("Command /c c:\sato.txt >prn")
waitrun("print c:\sato")

Return
