/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHPCP008 ³Autor  ³ Alexandre R. Bento    ³ Data ³ 03/09/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Carrega a Data do release                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Compras                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"   
#include "Font.ch"
#include "Colors.ch"


User Function NHPCP007() 

DEFINE FONT oFont  NAME "Arial" SIZE 0, -12 BOLD                                           
SetPrvt(" cQuery,dEmissao,cDoc,cLoja,cFornece,cSerie,nQtdeReg,aHeader")
SetPrvt(" cMarca,_aCampos,_cArqDBF,i,_aDias,_cTurno")
SetPrvt("aHeader,aCols, _nVlrRel,_nVlrUni,_nQtdRel,_cNomCli,_cCod,_cDesc,aCombo,cCombo") //,nVlrMer,dEmissao,dDigi,nQtdJE,nQtdPed,nQtdSal")

nVlrMer   := 0                             
_aDias    := {"Domingo","Segunda",OemToAnsi("Terça"),"Quarta","Quinta","Sexta","Sabado"}
aCombo	  := {"Janeiro","Fevereiro" ,OemToAnsi("Março"),"Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
cCombo    := " "
_cCod     := Space(15)
_cDesc    := Space(20)               
_cNomCli  := Space(30)               
_nQtdRel  := 0        
_nVlrRel  := 0     
_nVlrUni  := 0     
aHeader   := {}
aCols     := {}


//Static Function RptDetail()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando Arquivo Temporario para posterior impressao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cArqDBF  := CriaTrab(NIL,.f.)
_cArqDBF += ".DBF"
_aCampos := {}

AADD(_aCampos,{"OK"      ,"C", 02,0})         // Controle do browse
AADD(_aCampos,{"EMISSAO", "C",10,0})         // Data
AADD(_aCampos,{"DIA"    , "C",15,0})         // Dia da semana
AADD(_aCampos,{"TURNO"  , "C",1,0})         // Dia da semana
DbCreate(_cArqDBF,_aCampos)
DbUseArea(.T.,,_cArqDBF,"ETQ",.F.)

fData() // Carrega os dias do release no arquivo para mostrar no browse

cMarca  := GetMark()
aCampos := {}   

Aadd(aCampos,{"OK"        ,"OK"                 ,"@!"})
Aadd(aCampos,{"EMISSAO"   ,"Data do Release"    ,"@!"})
Aadd(aCampos,{"DIA"       ,"Dia do Release"     ,"@!"})
Aadd(aCampos,{"TURNO"     ,"Turno"              ,"@!"})

ETQ->(DbGoTop())

@ 100,050 To 650,525 Dialog dlgRele Title OemToAnsi("Distribui Release no Mês")
@ 020,010 Say OemToAnsi("Mês")  Size  30,08 
@ 020,040 COMBOBOX cCombo ITEMS aCombo SIZE 50,10 object oCombo 
@ 040,010 Say "Produto"      Size  40,08                              
@ 040,040 Get _cCod      Picture "@!" F3 "SB1" Valid fCod() Size 55,8 Object o_cCod
@ 040,095 Get _cDesc     Picture "@!" When .F. Size 125,8 Object o_cDesc
@ 060,010 Say "Cliente"   Size 30,8
@ 060,040 Get _cNomCli    Size 180,10 When .F. Object o_cNomCli
@ 080,010 Say "Qtde "   Size  60,08                                                
@ 080,040 Get _nQtdRel  Size  50,10 Picture "9,999,999,999" Valid fCod() Object o_nQtdRel   
@ 080,110 Say "Valor"   Size  40,08                                               
@ 080,130 Get _nVlrRel  Size  50,10 When .F. Picture "9,999,999,999.99" Object o_nVlrRel    
@ 100,10 TO 240,225 BROWSE "ETQ"
@ 100,10 TO 240,225 BROWSE "ETQ" FIELDS aCampos MARK "OK"                               
@ 248,045 Button "Atualiza MES" Size 40,15 Action fMesAlt()                                            
@ 248,010 Button "Desmarca" Size 30,15 Action fMarca()                                            
@ 248,090 Button "N.Turno" Size 30,15 Action fTurno()  
@ 250,140 BmpButton Type 1 Action fRelease()                                            
@ 250,180 BmpButton Type 2 Action Close(dlgrele)
Activate Dialog dlgRele Centered
//     oQtdSal:SetFont(oFont)  //Mostra fonte em negrito

DbSelectArea("ETQ")
DbCloseArea()


If File( _cArqDBF )   
   fErase(_cArqDBF)  // Deleta arquivo de dados temporario
Endif   

Return

Static Function fTurno()
//   Alert( " Linha "+ ETQ->EMISSAO + "  " + ETQ->DIA + "  " + ETQ->TURNO)
_cTurno := ETQ->TURNO    
@ 120,100 To 230,480 Dialog dlgTurno Title OemToAnsi("Altera Turno no Mês")
@ 010,035 Say OemToAnsi("Dia da Semana") Color CLR_BLUE Size  55,08 object olbSemana
@ 010,145 Say OemToAnsi("Turno") Color CLR_BLUE Size  35,08  object olbTurno
  olbSemana:SetFont(oFont)                                                 
  olbTurno:SetFont(oFont)                                                 
@ 020,030 Get ETQ->EMISSAO Picture "@!" When .F. SIZE 30,10 object o_Emissao 
@ 020,070 Get ETQ->DIA   Picture "@!" When .F. Size 70,8 Object o_Dia
@ 020,145 Get _cTurno  Size 10,10 Valid fNTurno() Object o_Turno
@ 040,100 BmpButton Type 1 Action fAlTurno()                                            
@ 040,140 BmpButton Type 2 Action Close(dlgTurno)
Activate Dialog dlgTurno Centered        
Return


Static Function fNTurno()

   If !_cTurno$"1/2/3"
       MsgBox(OemToAnsi("Atenção Numero do Turno Não Existe"),OemToAnsi("Alteração de Turno"),"INFO")   
       Return(.F.)
   Endif
Return

// Altera o turno
Static Function fAlTurno()
  Reclock("ETQ")
     ETQ->TURNO := _cTurno
  MsUnlock("ETQ")   
  Close(dlgTurno)
  ETQ->(DbGoTop())      
  dlgRefresh(dlgRele)

Return

Static Function fRelease()                                            
Local _dDataRe
Local _nTur    := 0
Local _nTotDia := 0
Local _nDias   := 0

_dDataRe := Ctod("01/"+StrZero(ascan(acombo,cCombo),2)+"/"+StrZero(Year(dDatabase),4))
// Verifica se já existe release para este mes 
//If SZC->(DbSeek(xFilial("SZC")+Dtos(_dDataRe)+_cCod+Subs(_cNomCli,1,6)+Subs(_cNomCli,10,2),Found())) 
SZC->(DbSeek(xFilial("SZC")+Dtos(_dDataRe)+_cCod+Subs(_cNomCli,1,6)+Subs(_cNomCli,10,2))) 
//   If MsgYesNo(OemToAnsi("Atenção Já Existe Release para este Produto Neste Mês Deseja refazer?"),OemToAnsi("Digitação do Release"))
 
	  While !SZC->(Eof()) 
	     If Month(_dDataRe) == Month(SZC->ZC_DATA) .And. Year(_dDataRe) == Year(SZC->ZC_DATA) .And.;
	        SZC->ZC_COD == _cCod .And. SZC->ZC_CLIENTE == Subs(_cNomCli,1,6) .And. SZC->ZC_LOJA == Subs(_cNomCli,10,2)
	           Reclock("SZC")
		         SZC->(DbDelete())
		       MsUnlock("SZC")   
	     Endif              
	     SZC->(Dbskip())
	  Enddo
//Endif   


if _nQtdRel <= 0
//   MsgBox(OemToAnsi("Atenção Quantidade não pode ser Menor que Zero"),OemToAnsi("Digitação do Release"),"INFO")
   Return
Endif


ETQ->(DbGoTop())
While !ETQ->(eof())

   If EMPTY(ETQ->OK)        
         _nDias +=1
         _nTur += Val(ETQ->TURNO)         
   Endif
   ETQ->(Dbskip())
Enddo             
//ALERT(" QTDE DIAS "+strzero(_ndias))
ETQ->(DbGoTop())
//For i := 1 to f_UltDia(_dDataRe) //--> Retorna o ultimo dia exemplo 30 (retorna tipo numérico)    
While !ETQ->(eof())
      
   RecLock("SZC",.T.)             
      SZC->ZC_FILIAL  := xFilial("SZC")
      SZC->ZC_DATA    := Ctod(ETQ->EMISSAO) //Ctod(StrZero(i,2)+"/"+StrZero(Month(_dDataRe),2)+"/"+StrZero(Year(dDatabase),4))
      SZC->ZC_COD     := _cCod
      SZC->ZC_CLIENTE := Subs(_cNomCli,1,6) //codigo do cliente
      SZC->ZC_LOJA    := Subs(_cNomCli,10,2) // loja do cliente
      If EMPTY(ETQ->OK)                       
         _nTotDia += Round(((_nQtdRel/_nTur)*Val(ETQ->TURNO)),0) //qtde do release / total de turnos * numero de turno dia
	     SZC->ZC_DATAREL := Ctod(ETQ->EMISSAO) //Ctod(StrZero(i,2)+"/"+StrZero(Month(_dDataRe),2)+"/"+StrZero(Year(dDatabase),4))
	     If _nTotDia <> _nQtdRel .And. _nDias == 1 //verifica se é o ultimo dia de produtção
            SZC->ZC_QTDEREL := Round((_nQtdRel/_nTur)* Val(ETQ->TURNO),0) - (_nTotDia - _nQtdRel)
            SZC->ZC_VALORRE := (Round((_nQtdRel/_nTur)* Val(ETQ->TURNO),0) - (_nTotDia - _nQtdRel)) * _nVlrUni
         Else   
	        SZC->ZC_QTDEREL := Round((_nQtdRel/_nTur)* Val(ETQ->TURNO),0)
	        SZC->ZC_VALORRE := Round((_nQtdRel/_nTur)* Val(ETQ->TURNO),0) * _nVlrUni
	     Endif   
	     SZC->ZC_DATAFAT := Ctod(ETQ->EMISSAO) //Ctod(StrZero(i,2)+"/"+StrZero(Month(_dDataRe),2)+"/"+StrZero(Year(dDatabase),4)) 
        _nDias -=1 // decrementa o dia
      Endif	        
   MsUnlock("SZC")                                    
   ETQ->(Dbskip()) 
Enddo             
ETQ->(DbGoTop())      
dlgRefresh(dlgRele)
Return

Static Function fCod()
Local lReturn := .T.
    _nVlrUni := 0
   //Faz verificacao se foi digitado o codigo NEW HUBNER ou o Codigo do CLIENTE
	// SB1->(DbsetOrder(9)) //filial+codap5
	If SB1->(DbSeek(xFilial("SB1")+_cCod),Found())	
	   _cDesc := SB1->B1_DESC
       ObjectMethod(o_cDesc,"Refresh()")                     
       If SB1->B1_MOEDA == 2
       
          If SM2->(DbSeek(dDataBase))
             _nVlrUni := (SB1->B1_PRV1 * SM2->M2_MOEDA2)
          Else
 		      MsgBox("Valor da Moeda nao Encontrado, favor digitar a Moeda no cadastro",OemToAnsi("Digitação do Release"),"INFO")
         	  lReturn := .F.
          Endif
       Else
          _nVlrUni := SB1->B1_PRV1             
       Endif   
	
       If _nQtdRel <> 0 //se a qtde foi digitada pega o valor total do release
          _nVlrRel := _nQtdRel * _nVlrUni  // Preço unitario
          ObjectMethod(o_nVlrRel,"Refresh()")  
       Endif
       SA7->(DbsetOrder(2)) //filial+produto     
       If SA7->(DbSeek(xFilial("SA7")+_cCod),Found()) //Pega o cliente automaticamente da amarraçao prod x fornecedor	
          If SA1->(DbSeek(xFilial("SA1")+SA7->A7_CLIENTE+SA7->A7_LOJA),Found())	
             _cNomCli := SA1->A1_COD +" - "+SA1->A1_LOJA + " "+ SA1->A1_NOME
             ObjectMethod(o_cNomCli,"Refresh()")  
          Endif   
           
       Endif
       
    Else
	   MsgBox("Produto nao Encontrado",OemToAnsi("Digitação do Release"),"INFO")
	   lReturn := .F.
	Endif

Return(lReturn)
                                
//Function Dia_da_semana(dData)
//Return Dow(dDate)
Static Function fData()                     

For i := 1 to f_UltDia(dDatabase) //--> Retorna o ultimo dia exemplo 30 (retorna tipo numérico) 

   _nDia := Transform(Dow(Ctod(StrZero(i,2)+"/"+StrZero(Month(dDatabase),2)+"/"+StrZero(Year(dDatabase),4))),"@E 9")	   
   RecLock("ETQ",.T.)             
      ETQ->OK      := Space(02)     
      ETQ->EMISSAO := StrZero(i,2)+"/"+StrZero(Month(dDatabase),2)+"/"+StrZero(Year(dDatabase),4)
      ETQ->DIA     := _aDias[Val(_nDia)] + Iif(_nDia$"2/3/4/5/6","-Feira","")
      ETQ->TURNO   := "3"
   MsUnlock("ETQ")

Next i                               

Return


Static Function fMesAlt()                     
Local _dData 
Local _nFim  
Local _nDia  

_dData := ascan(acombo,cCombo)
If _dData == 0
   MsgBox("Não foi Escolhido o mes para atualizar","Atenção","INFO")
   Return
Endif                              
//_dData := ascan(acombo,cCombo)
_nFim  := Ctod("01/"+StrZero(ascan(acombo,cCombo),2)+"/"+StrZero(Year(dDatabase),4))
// Limpa o arquivo temporario, pois o usuario escolheu um mes diferente do mes atual
If !empty(_cCod)
  // _dData := Ctod("01/"+StrZero(Scan(acombo,cCombo),2)+"/"+StrZero(Year(dDatabase),4))
   DbSelectArea("ETQ")
   Zap

   For i := 1 to f_UltDia(_nFim) //--> Retorna o ultimo dia exemplo 30 (retorna tipo numérico) 
      _nDia := Transform(Dow(Ctod(StrZero(i,2)+"/"+StrZero(Month(_nFim),2)+"/"+StrZero(Year(dDatabase),4))),"@E 9")	   
      
      RecLock("ETQ",.T.)             
         ETQ->OK      := Space(02)     
         ETQ->EMISSAO := StrZero(i,2)+"/"+StrZero(Month(_nFim),2)+"/"+StrZero(Year(dDatabase),4)
         ETQ->DIA     := _aDias[Val(_nDia)] + Iif(_nDia$"2/3/4/5/6","-Feira","")
         ETQ->TURNO   := "3"
      MsUnlock("ETQ")
	   
   Next i                               

   ETQ->(Dbgotop())
   dlgRefresh(dlgRele)
Endif

Return

//marca todas as notas
Static Function fMarca()

   ETQ->(DbGoTop())
   While !ETQ->(eof())     
      
      RecLock("ETQ")
         ETQ->OK := cMarca
      MsUnlock("ETQ")
      ETQ->(Dbskip())
   Enddo           
   ETQ->(DbGoTop())
   dlgRefresh(dlgRele)
//   MarkBRefresh()
Return

//desmarca todas as notas
Static Function fDesMarca()

   DBF->(DbGoTop())
   While !DBF->(eof())     
      
      RecLock("DBF")
         DBF->OK := "  "
      MsUnlock("DBF")
      DBF->(Dbskip())
   Enddo   
   MarkBRefresh()
Return
                                 

/*

If File( _cArqDBF )   
   fErase(_cArqDBF)  // Deleta arquivo de dados temporario
Endif   

Close ETQ 

  */