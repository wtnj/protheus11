/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHTER002  ºAutor  ³Alexandre R. Bento  º Data ³  27/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao de etiqueta codigo Barras (Maq.Operador e produto)º±±
±±º          ³Impressora TERMICA SATO                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Para Produção                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhter002()

SetPrvt("_cCod,_cDesc,_nQuant,_aOpçoes,_cOpe,_nPos,cNovaLinha,cInicializa,cFinaliza,")
SetPrvt("cConfEtB1,cConfEtB2,cConfEtN1,cConfEtN2,_cCodigo,_cMaq,_cOperaca")
SetPrvt("_cCodBar,_cLabEtq,_cSerial,_cSerFim")            
_cLabEtq    := Space(15)
_cCod       := Space(15)
_cDesc      := Space(30)
_cOpe       := Space(06)
_cMaq       := Space(03)
_cOperaca   := Space(03)
_cCodBar    := Space(06)                    
_cSerFim    := Space(09)
_cSerial    := Space(09)
_nQuant     := 0
_aOpcoes    := {OemToAnsi("Maquina/Operação"),"Operador ","Produto "}
_nPos       := 1        
//Axcadastro("SZI","CRIA ARQ SZI")
//  coracao
//  carinha
cNovaLinha  := Chr(13) + Chr(10)
cInicializa := "//"+cNovaLinha+"//"+cNovaLinha+"//"+cNovaLinha  //inicialização da impressora termica SATO
cFinaliza   := Chr(27)+"&" +Chr(27) + "Z" +Chr(27) + "A" +Chr(27) + "Q0001" + Chr(27) + "/" + Chr(27) + "Z" //Finalização da impressora termica SATO
cConfEtB1   := ""+Chr(27)+"A"+Chr(27)+"%0"+Chr(27)+ "H0310" + Chr(27) + "V0008"+Chr(27) + "D101076" // + *codigo de barra*"
cConfEtB2   := Chr(27) + "H0600" + Chr(27) + "V0008"+Chr(27) + "D101076" // + *codigo de barra*"
cConfEtN1   := Chr(27) +"P02" +Chr(27) + "H0310" + Chr(27) + "V0091"+Chr(27) + "L0202" +Chr(27) + "U" //codigo
cConfEtN2   := Chr(27) +"P02" +Chr(27) + "H0600" + Chr(27) + "V0091"+Chr(27) + "L0202" +Chr(27) + "U" //codigo
                                              

@ 100,050 To 300,370 Dialog oDlgItem Title OemToAnsi("Imprime Código de Barra")
@ 005,008 To 075,150                                     
@ 020,050 Say OemToAnsi("Escolha uma Opção")   Size 150,8
@ 040,050 RADIO _aOpcoes VAR _nPos   
@ 080,080 BMPBUTTON TYPE 01 ACTION fOK()
@ 080,120 BMPBUTTON TYPE 02 ACTION Close(oDlgItem)
Activate Dialog oDlgItem Centered
_cCod    := Space(15)
Return


Static Function fOK()
   //Close(DlgItem)     
   _cDesc      := Space(30)
   If _nPos == 1
      fMaquina()
     // Close(DlgMaq)
   
   ElseIf _nPos == 2
      fOperador()
     // Close(DlgOpe)

   ElseIf _nPos == 3
      fProduto()   
    //  Close(DlgProd)
   Endif

Return

Static Function fMaquina()

_nQuant := 2 // imprime sempre 2 etiq de operador 

@ 200,050 To 420,585 Dialog oDlgMaq Title OemToAnsi("Impressão de Código de Barras da Maquina")
@ 005,008 To 100,260

@ 042,020 Say OemToAnsi("Maquina    ") Size 35,8
@ 057,020 Say OemToAnsi("Operação  ") Size 35,8
@ 040,070 Get _cMaq      Picture "@!" F3 "SZF" Valid fMaq() Size 55,8 Object oMaq 
@ 040,124 Get _cDesc    Picture "@!" When .F. Size 120,8 Object oDesc 
@ 055,070 Get _cOperaca Picture "@!" When .F. Size 35,8 Object oOperaca 

@ 080,185 BMPBUTTON TYPE 01 ACTION fImpBarras()
@ 080,225 BMPBUTTON TYPE 02 ACTION Close(oDlgMaq)
Activate Dialog oDlgMaq CENTERED

Return

Static Function fMaq()
Local lReturn := .T.
                                              
SZF->(dbSetOrder(1)) //Filial+ matricula
If !SZF->(dbSeek(xFilial("SZF")+_cMaq ))
	MsgBox(OemToAnsi("Maquina Não Encontrada"),OemToAnsi("Atenção"),"INFO")
    _cMaq := Space(03)              
    ObjectMethod(oMaq ,"Refresh()")
    lReturn := .F.
Else
   _cDesc    := SZF->ZF_DESC
   _cOperaca := SZF->ZF_OPERACA
   _cLabEtq  := "MAQ= "+_cMaq +" OP= "+ SZF->ZF_OPERACA	
   ObjectMethod(oDesc ,"Refresh()")
   ObjectMethod(oOperaca,"Refresh()")   
EndIf   

Return (lReturn)


Static Function fOperador()

_nQuant := 2 // imprime sempre 2 etiq de operador 

@ 200,050 To 420,585 Dialog oDlgOpe Title OemToAnsi("Impressão de Código de Barras do Operador")
@ 005,008 To 100,260

@ 042,020 Say OemToAnsi("Operador    ") Size 35,8
@ 040,070 Get _cOpe      Picture "@!" F3 "QAA" Valid fOpe() Size 55,8 Object oOpe 
@ 040,124 Get _cDesc     Picture "@!" When .F. Size 120,8 Object oDesc 

@ 080,185 BMPBUTTON TYPE 01 ACTION fImpBarras()
@ 080,225 BMPBUTTON TYPE 02 ACTION Close(oDlgOpe)
Activate Dialog oDlgOpe CENTERED

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
   _cDesc    := QAA->QAA_NOME
   _cLabEtq  := _cOpe + " "+Subs(QAA->QAA_NOME,1,9)

   ObjectMethod(oDesc ,"Refresh()")
EndIf   

Return (lReturn)


Static Function fProduto()

@ 200,050 To 420,585 Dialog oDlgProd Title OemToAnsi("Impressão de Código de Barras do Produto")
@ 005,008 To 100,260

@ 042,020 Say OemToAnsi("Produto    ") Size 35,8
@ 057,020 Say OemToAnsi("Quantidade ") Size 35,8
@ 072,020 Say OemToAnsi("Etiq. Inicial") Size 35,8
@ 072,140 Say OemToAnsi("Etiq. Final  ") Size 35,8
@ 040,070 Get _cCod      Picture "@!" F3 "SZA" Valid fCod() Size 50,8 Object oCod 
@ 040,124 Get _cDesc     Picture "@!" When .F. Size 120,8 Object oDesc 
@ 055,070 Get _nQuant    Picture "@E 999,999,999.99"  Valid fQtde() Size 50,8 Object oQuant 

@ 070,070 Get _cSerial   Picture "@!" When .F. Size 40,8 Object oSerial 
@ 070,170 Get _cSerFim   Picture "@!" When .F. Size 40,8 Object oSerFim 

@ 085,185 BMPBUTTON TYPE 01 ACTION fImpBarras()
@ 085,225 BMPBUTTON TYPE 02 ACTION Close(oDlgProd)
Activate Dialog oDlgProd CENTERED

Return

Static Function fQtde()
Local lReturn := .T.

If _nQuant <= 0
   MsgBox(OemToAnsi("Quantidade do Produto errada Redigite"),OemToAnsi("Atenção"),"INFO")
   Return(.F.)
Endif            

If Mod(_nQuant,2) <> 0
   MsgBox(OemToAnsi("Quantidade não pode ser IMPAR, pois a etiq é dupla"),OemToAnsi("Atenção"),"INFO")
   Return(.F.)
Endif

SZI->(DbsetOrder(1)) //filial+codigo produto
If SZI->(DbSeek(xFilial("SZI")+_cCod,.T.))	
//   ALERT("SERIAL NUMERO " + SZI->ZI_SERIAL)
   While !SZI->(EOF()) .And. SZI->ZI_COD == _cCod
      _cSerial := Strzero(val(SZI->ZI_SERFIM)+1,9) 
      SZI->(Dbskip())
   Enddo 
Else   
//   ALERT("SERIAL NUMERO 000000001")
   _cSerial := "000000001"
Endif
_cSerFim := Strzero(Val(_cSerial) +( _nQuant-1),9) // Gera numero de serie final
ObjectMethod(oSerial ,"Refresh()")
ObjectMethod(oSerFim ,"Refresh()")

Return(lReturn)

Static Function fCod()
Local lReturn := .T.

   //Faz verificacao se foi digitado o codigo NEW HUBNER ou o Codigo do CLIENTE
   
If SubStr(_cCod,1,2) == "VW" //IF Incluido p/ imprimir qualquer produto volks como generico se quiser voltar a condição normal é só tirar
	  _cDesc   := "Produto VW Generico"
//      _cCodigo := "000000" // codigo de Barras do produto VW eh ZERO ou seja generico                    
  	  _cCodBar :=  "8V-RSH" // codigo de Barras do produto VW eh ZERO ou seja generico                    
      _cCod    := "000000000000000" // codigo de Barras do produto VW eh ZERO ou seja generico           
      ObjectMethod(oDesc ,"Refresh()")
      ObjectMethod(oCod  ,"Refresh()")            
Else
   If Subs(_cCod,5,1) == "."             
      SB1->(DbsetOrder(1)) //filial+codigo produto
	  If SB1->(DbSeek(xFilial("SB1")+_cCod),Found())	
 	     If Subs(SB1->B1_COD,6,1) <> "4"
  		    MsgBox("Somente Produto que seja Materia Prima Pode ser Impresso",OemToAnsi("Atenção"),"INFO")
		    Return(.F.)
	     Endif  	           
	 	 _cDesc  := SB1->B1_DESC
	 	 _cCodBar := Subs(SB1->B1_CODBAR,1,6)  	           
         ObjectMethod(oDesc ,"Refresh()")
	  Else
	  	 MsgBox("Produto nao Encontrado",OemToAnsi("Atenção"),"INFO")
		 lReturn := .F.
	  Endif
   Else
	  SB1->(DbsetOrder(9)) //filial+codap5
	  If SB1->(DbSeek(xFilial("SB1")+_cCod),Found())	
	     If Subs(SB1->B1_COD,6,1) <> "4"
  		    MsgBox("Somente Produto que seja Materia Prima Pode ser Impresso",OemToAnsi("Atenção"),"INFO")
		    Return(.F.)
	     Endif  	           
	     _cDesc  := SB1->B1_DESC
  	     _cCod   := SB1->B1_COD     
	 	 _cCodBar := Subs(SB1->B1_CODBAR,1,6)  	           
         ObjectMethod(oDesc ,"Refresh()")
         ObjectMethod(oCod  ,"Refresh()")            
	  Else
		 MsgBox("Produto nao Encontrado",OemToAnsi("Atenção"),"INFO")
		 lReturn := .F.
	  Endif
		
   Endif       
   
Endif

_nQuant := 0   
_cSerial  := Space(15) //Serial inicial 
_cSerFim  := Space(15) //Serial Final   
ObjectMethod(oSerial ,"Refresh()")
ObjectMethod(oSerFim ,"Refresh()")
ObjectMethod(oQuant  ,"Refresh()")

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
Local cCodEtq2     := Space(15) 

If _nPos == 1
    _cCodigo := _cMaq // codigo da Maquina mais Operação
//    Close(oDlgMaq)
Elseif _nPos == 2
    _cCodigo := _cOpe // codigo do Operador
//    Close(oDlgOpe)
Elseif _nPos == 3
    _cLabEtq  := Space(15) // limpa a descricao do codigo de barras
//    If SubStr(_cCod,1,2) == "VW"
//       _cCodigo := "000000" // codigo de Barras do produto VW eh ZERO ou seja generico           
//       _cCod    := "000000" // codigo de Barras do produto VW eh ZERO ou seja generico           
//    Else
       _cCodigo := _cCodBar // codigo de Barras do produto       
//    Endif  

   // Grava informaçoes no arquivo quando o usuario imprime a etiq.                      
   Reclock("SZI",.T.)
      SZI->ZI_FILIAL := xFilial("SZI")               
      SZI->ZI_COD    := _cCod
      SZI->ZI_SERIAL := _cSerial //Serial inicial 
      SZI->ZI_SERFIM := _cSerFim  //serial final
      SZI->ZI_USUARIO:= upper(alltrim(cUserName))
      SZI->ZI_DATA   := dDatabase
      //SZI->ZI_OBS    := 
   MsUnlock("SZI")
Endif

FWrite(cArq,(cInicializa))                     
For x:=Val(_cSerFim) to Val(_cSerial) Step -2 // pois as etiquetas são 2 por linha                     

   If _nPos == 3
      _cCodigo  := _cCodBar+Strzero(x,9) // codigo de Barras + serial da etiq de cod. barras do produto          
      cCodEtq2 := _cCodBar+Strzero(x-1,9)
//    If _cCod == "000000000000000" //Verifica de é VW generico
//       _cLabEtq := "Cabecote 8V RSH"
//       FWrite (cArq,(cConfEtB1+"*"+AllTrim(_cCodigo)+"*"+cConfEtB2+"*"+Alltrim(cCodetq2)+"*"+; 
//       cConfEtN1+Alltrim(_cLabEtq)+cConfEtN2+Alltrim(_cLabEtq)+cFinaliza+cNovaLinha)) 
//    Else 
         _cLabEtq := _cCodBar+Strzero(x,9)      
         FWrite (cArq,(cConfEtB1+"*"+AllTrim(_cCodigo)+"*"+cConfEtB2+"*"+Alltrim(cCodetq2)+"*"+; 
          cConfEtN1+Alltrim(_cLabEtq)+cConfEtN2+Alltrim(cCodEtq2)+cFinaliza+cNovaLinha)) 
//    Endif   
   
   Else
       FWrite (cArq,(cConfEtB1+"*"+AllTrim(_cCodigo)+"*"+cConfEtB2+"*"+Alltrim(_cCodigo)+"*"+; 
           cConfEtN1+Alltrim(_cLabEtq)+cConfEtN2+Alltrim(_cLabEtq)+cFinaliza+cNovaLinha)) 
   
   Endif
   
Next   

FClose(cARQ)            
_cLabEtq  := Space(15) // limpa a descricao do codigo de barras
_cSerial  := Space(15) //Serial inicial 
_cSerFim  := Space(15) //Serial Final   
_cCod     := Space(15) //Codigo do produto
_cDesc    := Space(30) //Descricao

waitrun("print c:\sato")
If _nPos == 1
    Close(oDlgMaq)
Elseif _nPos == 2
    Close(oDlgOpe)
Elseif _nPos == 3
    Close(oDlgProd)    
Endif   

Return
