/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³NHFIN011  ³ Autor ³ Jose Roberto Gorski   ³ Data ³ 27/04/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Acerto de Viagem                                            ³±± 
±±³__________³____________________________________________________________³±±
±±³Alteracao ³Alexandre R.Bento                           Data   05/12/02 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

#include "rwmake.ch"       

User Function Nhfin011()    

SetPrvt("_CADIANT,_NHOTELRS,_NHOTELCV,_NHOTELUS,_NHOTELDM,_NHOTELOU")
SetPrvt("_NREFRS,_NREFCV,_NREFUS,_NREFDM,_NREFOU,_NPASSRS")
SetPrvt("_NPASSCV,_NPASSUS,_NPASSDM,_NPASSOU,_NCOMBRS,_NCOMBCV")
SetPrvt("_NCOMBUS,_NCOMBDM,_NCOMBOU,_NREPRS,_NREPCV,_NREPUS")
SetPrvt("_NREPDM,_NREPOU,_NOUT1RS,_NOUT1CV,_NOUT1US,_NOUT1DM")
SetPrvt("_NOUT1OU,_NOUT2RS,_NOUT2CV,_NOUT2US,_NOUT2DM,_NOUT2OU")
SetPrvt("_NOUT3RS,_NOUT3CV,_NOUT3US,_NOUT3DM,_NOUT3OU,_NTDESPRS")
SetPrvt("_NTDESPCV,_NTDESPUS,_NTDESPDM,_NTDESPOU,_NTAXARS,_NTAXACV")
SetPrvt("_NTAXAUS,_NTAXADM,_NTAXAOU,_NADTRS,_NADTCV,_NADTUS")
SetPrvt("_NADTDM,_NADTOU,_NRESTRS,_NRESTCV,_NRESTUS,_NRESTDM")
SetPrvt("_NRESTOU,_NREEBRS,_NREEBCV,_NREEBUS,_NREEBDM,_NREEBOU")
SetPrvt("_NTOTALRS,_NTOTALCV,_NTOTALUS,_NTOTALDM,_NTOTALOU,_NFONERS")
SetPrvt("_NFONECV,_NFONEUS,_NFONEDM,_NFONEOU,_NCONDRS,_NCONDCV")
SetPrvt("_NCONDUS,_NCONDDM,_NCONDOU,_LCONT,_NSOBRARS,_NFALTARS")
SetPrvt("_NCALCRS,_NSOBRACV,_NFALTACV,_NCALCCV,_NSOBRAUS,_NFALTAUS")
SetPrvt("_NCALCUS,_NSOBRADM,_NFALTADM,_NCALCDM,_NSOBRAOU,_NFALTAOU")
SetPrvt("_NCALCOU,_dDatade,_dDataate")


//Caso ja tenha sido gerado um Acerto de Viagem nao entrar na tela
If SZ3->Z3_GEROUAC == "S"
   MsgBox("Ja foi gerado acerto de viagem para este item")
   Return
Endif

// Inicializacao da Variaveis
_cAdiant  := SZ3->Z3_NUM


_nHotelRS := 0
_nHotelCV := 0
_nHotelUS := 0
_nHotelDM := 0
_nHotelOU := 0

_nRefRS := 0
_nRefCV := 0
_nRefUS := 0
_nRefDM := 0
_nRefOU := 0

_nPassRS := 0
_nPassCV := 0
_nPassUS := 0
_nPassDM := 0
_nPassOU := 0

_nCombRS := 0
_nCombCV := 0
_nCombUS := 0
_nCombDM := 0
_nCombOU := 0

_nRepRS := 0
_nRepCV := 0
_nRepUS := 0
_nRepDM := 0
_nRepOU := 0

_nOut1RS := 0
_nOut1CV := 0
_nOut1US := 0
_nOut1DM := 0
_nOut1OU := 0

_nOut2RS := 0
_nOut2CV := 0
_nOut2US := 0
_nOut2DM := 0
_nOut2OU := 0

_nOut3RS := 0
_nOut3CV := 0
_nOut3US := 0
_nOut3DM := 0
_nOut3OU := 0

_nTDespRS := 0
_nTDespCV := 0
_nTDespUS := 0
_nTDespDM := 0
_nTDespOU := 0

_nTaxaRS := 0
_nTaxaCV := 0
_nTaxaUS := 0
_nTaxaDM := 0            
_nTaxaOU := 0

If SZ3->Z3_MOEDA == "2"
   _nTaxaUS := SZ3->Z3_TAXA
ElseIf SZ3->Z3_MOEDA == "3" 
   _nTaxaDM := SZ3->Z3_TAXA
ElseIf SZ3->Z3_MOEDA == "4"
   _nTaxaOU := SZ3->Z3_TAXA
Endif      

_nAdtRS := 0
_nAdtCV := 0
_nAdtUS := 0
_nAdtDM := 0
_nAdtOU := 0

_nRestRS := 0
_nRestCV := 0
_nRestUS := 0
_nRestDM := 0
_nRestOU := 0

_nReebRS := 0
_nReebCV := 0
_nReebUS := 0
_nReebDM := 0
_nReebOU := 0

_nTotalRS := 0
_nTotalCV := 0
_nTotalUS := 0
_nTotalDM := 0
_nTotalOU := 0

_nFoneRS := 0
_nFoneCV := 0
_nFoneUS := 0
_nFoneDM := 0
_nFoneOU := 0

_nCondRS := 0
_nCondCV := 0
_nCondUS := 0
_nCondDM := 0
_nCondOU := 0
//_dDatade :=SZ3->Z3_DATADE) + "    a " 
//@ 023,090 Get DtoC(SZ3->Z3_DATAATE) Size 50,08 When .F.


If SZ3->Z3_MOEDA == "1"
   _nAdtRS := SZ3->Z3_VALOR
ElseIf SZ3->Z3_MOEDA == "2"
   _nAdtUS := SZ3->Z3_VALOR
   _nAdtCV := SZ3->Z3_VALOR * SZ3->Z3_TAXA   
ElseIf SZ3->Z3_MOEDA == "3"
   _nAdtDM := SZ3->Z3_VALOR
   _nAdtCV := SZ3->Z3_VALOR * SZ3->Z3_TAXA
ElseIf SZ3->Z3_MOEDA == "4"
   _nAdtOU := SZ3->Z3_VALOR
   _nAdtCV := SZ3->Z3_VALOR * SZ3->Z3_TAXA
Endif 


@ 00,00 TO 530,700 DIALOG oDlg6 TITLE "Atualizacao de Viagem    -   WHB Fundicao S/A" 
@ 245,220 BMPBUTTON TYPE 01 ACTION Grava_Dados()
@ 245,270 BMPBUTTON TYPE 02 ACTION Sair()

// Cabecalho
@ 013,014 say "Adiantamento:"
@ 013,050 Get _cAdiant  Size 30,08 When .F.
@ 013,090 say "Empresa:"
@ 013,114 Get SZ3->Z3_EMPRESA Size 80,08 When .F.
@ 023,014 say "Periodo:" 
@ 023,050 Get SZ3->Z3_DATADE Size 45,08 When .F.
@ 023,095 Say  "a" 
@ 023,115 Get SZ3->Z3_DATAATE Size 45,08 When .F.
@ 033,014 say "Destino: "
@ 033,050 Get SZ3->Z3_DESTINO  Size 100,08 When .F.
@ 043,014 say "Funcionario:"
@ 043,050 Get SZ3->Z3_NOME Size 100,08  When .F.

// Itens de Despesas
@ 053,014 say "Moedas:"
@ 053,090 say "Real" 
@ 053,140 say "Real Conv."
@ 053,190 say "Dolar"
@ 053,240 say "DM"
@ 053,290 say "Outras"

@ 063,014 say "Despesas de Hotel:"
@ 063,090 Get _nHotelRS Picture "@E 9,999,999.99" SIZE 50,08 Object oHotelRS Valid FTdesp()
@ 063,140 Get _nHotelCV Picture "@E 9,999,999.99" SIZE 50,08 Object oHotelCV Valid FTdesp()
@ 063,190 Get _nHotelUS Picture "@E 9,999,999.99" SIZE 50,08 Object oHotelUS Valid FHotelUS()  
@ 063,240 Get _nHotelDM Picture "@E 9,999,999.99" SIZE 50,08 Object oHotelDM Valid FTdesp()
@ 063,290 Get _nHotelOU Picture "@E 9,999,999.99" SIZE 50,08 Object oHotelOU Valid FTdesp()              

@ 073,014 say "Refeicoes:"
@ 073,090 Get _nRefRS Picture "@E 9,999,999.99"  SIZE 50,08 Object oRefRS Valid FTdesp()
@ 073,140 Get _nRefCV Picture "@E 9,999,999.99"  SIZE 50,08 Object oRefCV Valid FTdesp()
@ 073,190 Get _nRefUS Picture "@E 9,999,999.99"  SIZE 50,08 Object oRefUS Valid FRefUS()  
@ 073,240 Get _nRefDM Picture "@E 9,999,999.99"  SIZE 50,08 Object oRefDM Valid FTdesp()
@ 073,290 Get _nRefOU Picture "@E 9,999,999.99"  SIZE 50,08 Object oRefOU Valid FTdesp()        

@ 083,014 say "Passagens:"
@ 083,090 Get _nPassRS Picture "@E 9,999,999.99" SIZE 50,08 Object oPassRS Valid FTdesp()
@ 083,140 Get _nPassCV Picture "@E 9,999,999.99" SIZE 50,08 Object oPassCV Valid FTdesp()
@ 083,190 Get _nPassUS Picture "@E 9,999,999.99" SIZE 50,08 Object oPassUS Valid FPassUS()  
@ 083,240 Get _nPassDM Picture "@E 9,999,999.99" SIZE 50,08 Object oPassDM Valid FTdesp()
@ 083,290 Get _nPassOU Picture "@E 9,999,999.99" SIZE 50,08 Object oPassOU Valid FTdesp()
                                                 
@ 093,014 say "Combustivel:"
@ 093,090 Get _nCombRS Picture "@E 9,999,999.99" SIZE 50,08 Object oCombRS Valid FTdesp()
@ 093,140 Get _nCombCV Picture "@E 9,999,999.99" SIZE 50,08 Object oCombCV Valid FTdesp()
@ 093,190 Get _nCombUS Picture "@E 9,999,999.99" SIZE 50,08 Object oCombUS Valid FCombUS()  
@ 093,240 Get _nCombDM Picture "@E 9,999,999.99" SIZE 50,08 Object oCombDM Valid FTdesp()
@ 093,290 Get _nCombOU Picture "@E 9,999,999.99" SIZE 50,08 Object oCombOU Valid FTdesp()          

@ 103,014 say "Telefones:"
@ 103,090 Get _nFoneRS Picture "@E 9,999,999.99" SIZE 50,08 Object oFoneRS Valid FTdesp()
@ 103,140 Get _nFoneCV Picture "@E 9,999,999.99" Size 50,08 Object oFoneCV Valid FTdesp()
@ 103,190 Get _nFoneUS Picture "@E 9,999,999.99" SIZE 50,08 Object oFoneUS Valid FFoneUS()  
@ 103,240 Get _nFoneDM Picture "@E 9,999,999.99" SIZE 50,08 Object oFoneDM Valid FTdesp()
@ 103,290 Get _nFoneOU Picture "@E 9,999,999.99" SIZE 50,08 Object oFoneOU Valid FTdesp()          

@ 113,014 say "Conducao:"
@ 113,090 Get _nCondRS Picture "@E 9,999,999.99" SIZE 50,08 Object oCondRS Valid FTdesp()
@ 113,140 Get _nCondCV Picture "@E 9,999,999.99" Size 50,08 Object oCondCV Valid FTdesp()
@ 113,190 Get _nCondUS Picture "@E 9,999,999.99" SIZE 50,08 Object oCondUS Valid FCondUS()  
@ 113,240 Get _nCondDM Picture "@E 9,999,999.99" SIZE 50,08 Object oCondDM Valid FTdesp()
@ 113,290 Get _nCondOU Picture "@E 9,999,999.99" SIZE 50,08 Object oCondOU Valid FTdesp()
                                                 
@ 123,014 say "Outros Reparos:"
@ 123,090 Get _nRepRS  Picture "@E 9,999,999.99" SIZE 50,08 Object oRepRS Valid FTdesp()
@ 123,140 Get _nRepCV  Picture "@E 9,999,999.99" Size 50,08 Object oRepCV Valid FTdesp()
@ 123,190 Get _nRepUS  Picture "@E 9,999,999.99" SIZE 50,08 Object oRepUS Valid FRepUS()  
@ 123,240 Get _nRepDM  Picture "@E 9,999,999.99" SIZE 50,08 Object oRepDM Valid FTdesp()
@ 123,290 Get _nRepOU  Picture "@E 9,999,999.99" SIZE 50,08 Object oRepOU Valid FTdesp()        

@ 133,014 say "Outras Despesas1:"
@ 133,090 Get _nOut1RS Picture "@E 9,999,999.99" SIZE 50,08 Object oOut1RS Valid FTdesp()
@ 133,140 Get _nOut1CV Picture "@E 9,999,999.99" Size 50,08 Object oOut1CV Valid FTdesp()
@ 133,190 Get _nOut1US Picture "@E 9,999,999.99" SIZE 50,08 Object oOut1US Valid FOut1US()  
@ 133,240 Get _nOut1DM Picture "@E 9,999,999.99" SIZE 50,08 Object oOut1DM Valid FTdesp()
@ 133,290 Get _nOut1OU Picture "@E 9,999,999.99" SIZE 50,08 Object oOut1OU Valid FTdesp()

@ 143,014 say "Outras Despesas2:"
@ 143,090 Get _nOut2RS Picture "@E 9,999,999.99" SIZE 50,08 Object oOut2RS Valid FTdesp()
@ 143,140 Get _nOut2CV Picture "@E 9,999,999.99" Size 50,08 Object oOut2CV Valid FTdesp()
@ 143,190 Get _nOut2US Picture "@E 9,999,999.99" SIZE 50,08 Object oOut2US Valid FOut2US()   
@ 143,240 Get _nOut2DM Picture "@E 9,999,999.99" SIZE 50,08 Object oOut2DM Valid FTdesp()
@ 143,290 Get _nOut2OU Picture "@E 9,999,999.99" SIZE 50,08 Object oOut2OU Valid FTdesp()          

@ 153,014 say "Outras Despesas3:"
@ 153,090 Get _nOut3RS Picture "@E 9,999,999.99" SIZE 50,08 Object oOut3RS Valid FTdesp()
@ 153,140 Get _nOut3CV Picture "@E 9,999,999.99" Size 50,08 Object oOut3CV Valid FTdesp()
@ 153,190 Get _nOut3US Picture "@E 9,999,999.99" SIZE 50,08 Object oOut3US Valid FOut3US()  
@ 153,240 Get _nOut3DM Picture "@E 9,999,999.99" SIZE 50,08 Object oOut3DM Valid FTdesp()
@ 153,290 Get _nOut3OU Picture "@E 9,999,999.99" SIZE 50,08 Object oOut3OU Valid FTdesp()

// Valores Totais                       
// _nTDespRS := _nTDespRS + _nTDespCV
@ 183,014 say "Total Desp.Realizadas:"
@ 183,090 Get _nTDespRS             Picture "@E 9,999,999.99" Size 40,08 When .F. Object oTDespRS
@ 183,140 Get _nTDespCV             Picture "@E 9,999,999.99" Size 40,08 When .F. Object oTDespCV
@ 183,190 Get _nTDespUS             Picture "@E 9,999,999.99" Size 40,08 When .F. Object oTDespUS
@ 183,240 Get _nTDespDM             Picture "@E 9,999,999.99" Size 40,08 When .F. Object oTDespDM
@ 183,290 Get _nTDespOU             Picture "@E 9,999,999.99" Size 40,08 When .F. Object oTDespOU

If SZ3->Z3_MOEDA == "2"
   _nTaxaUS := SZ3->Z3_TAXA
ElseIf SZ3->Z3_MOEDA == "3" 
   _nTaxaDM := SZ3->Z3_TAXA
ElseIf SZ3->Z3_MOEDA == "4"
   _nTaxaOU := SZ3->Z3_TAXA
Endif      

@ 193,014 say "Taxas de Conversao:"
@ 193,190 Get _nTaxaUS  Picture "@E 9999.99"  SIZE 40,08 Object oTaxaUS
@ 193,240 Get _nTaxaDM  Picture "@E 9999.99"  SIZE 40,08 Object oTaxaDM
@ 193,290 Get _nTaxaOU  Picture "@E 9999.99"  SIZE 40,08 Object oTaxaOU

@ 203,014 say "Adiant. para Viagem:"
@ 203,090 Get _nAdtRS Picture "@E 9,999,999.99"  Size 40,08 When .F. Object oAdtRS
@ 203,140 Get _nAdtCV Picture "@E 9,999,999.99"  Size 40,08 When .F. Object oAdtCV
@ 203,190 Get _nAdtUS Picture "@E 9,999,999.99"  Size 40,08 When .F. Object oAdtUS
@ 203,240 Get _nAdtDM Picture "@E 9,999,999.99"  Size 40,08 When .F. Object oAdtDM
@ 203,290 Get _nAdtOU Picture "@E 9,999,999.99"  Size 40,08 When .F. Object oAdtOU
ObjectMethod(oAdtRS,"Refresh()")
ObjectMethod(oAdtCV,"Refresh()")
ObjectMethod(oAdtUS,"Refresh()")
ObjectMethod(oAdtDM,"Refresh()")
ObjectMethod(oAdtOU,"Refresh()")


DlgRefresh(oDlg6)

@ 213,014 say "Restituicao a Empresa:"
@ 213,090 Get _nRestRS Picture "@E 9,999,999.99"  Size 40,08 When .F. Object oRestRS
@ 213,140 Get _nRestCV Picture "@E 9,999,999.99"  Size 40,08 When .F. Object oRestCV
@ 213,190 Get _nRestUS Picture "@E 9,999,999.99"  Size 40,08 When .F. Object oRestUS
@ 213,240 Get _nRestDM Picture "@E 9,999,999.99"  Size 40,08 When .F. Object oRestDM
@ 213,290 Get _nRestOU Picture "@E 9,999,999.99"  Size 40,08 When .F. Object oRestOU

@ 223,014 say "Reembolso dos Gastos:"
@ 223,090 Get _nReebRS Picture "@E 9,999,999.99"  Size 40,08 When .F. Object oReebRS
@ 223,140 Get _nReebCV Picture "@E 9,999,999.99"  Size 40,08 When .F. Object oReebCV
@ 223,190 Get _nReebUS Picture "@E 9,999,999.99"  Size 40,08 When .F. Object oReebUS
@ 223,240 Get _nReebDM Picture "@E 9,999,999.99"  Size 40,08 When .F. Object oReebDM
@ 223,290 Get _nReebOU Picture "@E 9,999,999.99"  Size 40,08 When .F. Object oReebOU


/*/
@ 233,014 say "Total:" 
@ 233,090 Get _nTotalRS Picture "@E 9,999,999.99" Size 40,08 When .F. 
@ 233,140 Get _nTotalCV Picture "@E 9,999,999.99" Size 40,08 When .F. 
@ 233,190 Get _nTotalUS Picture "@E 9,999,999.99" Size 40,08 When .F. 
@ 233,240 Get _nTotalDM Picture "@E 9,999,999.99" Size 40,08 When .F. 
@ 233,290 Get _nTotalOU Picture "@E 9,999,999.99" Size 40,08 When .F. 
/*/

ACTIVATE DIALOG oDlg6 CENTERED

Return


Static Function FhotelUS()
   _nHotelCV := (_nHotelUS * _nTaxaUS) + (_nHotelDM * _nTaxaDM) + (_nHotelOU * _nTaxaOU)
   ObjectMethod(oHotelCV,"Refresh()")
   FTdesp()
Return

Static Function FRefUS()

_nRefCV := (_nRefUS * _nTaxaUS) + (_nRefDM * _nTaxaDM) + (_nRefOU * _nTaxaOU)
ObjectMethod(oRefCV,"Refresh()")
FTdesp()

Return

Static Function FPassUS()
  _nPassCV := (_nPassUS * _nTaxaUS) + (_nPassDM * _nTaxaDM) + (_nPassOU * _nTaxaOU)
  ObjectMethod(oPassCV,"Refresh()")
  FTdesp()
Return


Static Function FCombUS()      
   _nCombCV := (_nCombUS * _nTaxaUS) + (_nCombDM * _nTaxaDM) + (_nCombOU * _nTaxaOU)
   ObjectMethod(oCombCV,"Refresh()")
   FTdesp()
Return

Static Function FFoneUS()
   _nFoneCV := (_nFoneUS * _nTaxaUS) + (_nFoneDM * _nTaxaDM) + (_nFoneOU * _nTaxaOU)
   ObjectMethod(oFoneCV,"Refresh()")                  
   FTdesp()
Return

Static Function FCondUS()
   _nCondCV := (_nCondUS * _nTaxaUS) + (_nCondDM * _nTaxaDM) + (_nCondOU * _nTaxaOU)
   ObjectMethod(oCondCV,"Refresh()")
   FTdesp()
Return
                                                 
Static Function FRepUS()
   _nRepCV := (_nRepUS * _nTaxaUS) + (_nRepDM * _nTaxaDM) + (_nRepOU * _nTaxaOU)
   ObjectMethod(oRepCV,"Refresh()")
   FTdesp()
Return

Static Function FOut1US()
   _nOut1CV := (_nOut1US * _nTaxaUS) + (_nOut1DM * _nTaxaDM) + (_nOut1OU * _nTaxaOU)
   ObjectMethod(oOut1CV,"Refresh()")                 
   FTdesp()
Return

Static Function FOut2US()
   _nOut2CV := (_nOut2US * _nTaxaUS) + (_nOut2DM * _nTaxaDM) + (_nOut2OU * _nTaxaOU)
   ObjectMethod(oOut2CV,"Refresh()")
   FTdesp()
Return

Static Function FOut3US()
   _nOut3CV := (_nOut3US * _nTaxaUS) + (_nOut3DM * _nTaxaDM) + (_nOut3OU * _nTaxaOU)
   ObjectMethod(oOut3CV,"Refresh()")
   FTdesp()
Return

Static Function FTdesp()

   _nTDespRS := _nHotelRS + _nRefRS + _nPassRS + _nCombRS + _nRepRS + _nOut1RS + _nOut2RS + _nOut3RS + _nCondRS + _nFoneRS
   _nTDespCV := _nHotelCV + _nRefCV + _nPassCV + _nCombCV + _nRepCV + _nOut1CV + _nOut2CV + _nOut3CV + _nCondCV + _nFoneCV
   _nTDespUS := _nHotelUS + _nRefUS + _nPassUS + _nCombUS + _nRepUS + _nOut1US + _nOut2US + _nOut3US + _nCondUS + _nFoneUS
   _nTDespDM := _nHotelDM + _nRefDM + _nPassDM + _nCombDM + _nRepDM + _nOut1DM + _nOut2DM + _nOut3DM + _nCondDM + _nFoneDM
   _nTDespOU := _nHotelOU + _nRefOU + _nPassOU + _nCombOU + _nRepOU + _nOut1OU + _nOut2OU + _nOut3OU + _nCondOU + _nFoneOU
   ObjectMethod(oTDespRS,"Refresh()")
   ObjectMethod(oTDespCV,"Refresh()")
   ObjectMethod(oTDespUS,"Refresh()")
   ObjectMethod(oTDespDM,"Refresh()")
   ObjectMethod(oTDespOU,"Refresh()")


   // Calculo da Restituicao ou reembolso em RS
   _nSobraRS  := 0
   _nFaltaRS  := 0
    
   If SZ3->Z3_MOEDA == "1"
      _nCalcRS := _nAdtRS - _nTDespRS 
      If _nCalcRs >= 0
         _nSobraRS  := _nCalcRS
      Else
         _nFaltaRS := _nCalcRS * (-1)
      Endif
      _nRestRS := _nSobraRS
      _nReebRS := _nFaltaRS
   Endif  

// Calculo da Restituicao ou reembolso em CV
   _nSobraCV  := 0
   _nFaltaCV  := 0
                           
   If SZ3->Z3_MOEDA <> "1"
      _nCalcCV := _nAdtCV - _nTDespCV 
      If _nCalcCV >= 0
         _nSobraCV := _nCalcCV
      Else
         _nFaltaCV := _nCalcCV * (-1)
      Endif
      _nRestCV := _nSobraCV
      _nReebCV := _nFaltaCV
   Endif
   // Calculo da Restituicao ou reembolso em US
   _nSobraUS  := 0
   _nFaltaUS  := 0

   If SZ3->Z3_MOEDA == "2"
      _nCalcUS := _nAdtUS - _nTDespUS 
      If _nCalcUS >= 0
         _nSobraUS := _nCalcUS
      Else
        _nFaltaUS := _nCalcUS * (-1)
      Endif
      _nRestUS := _nSobraUS
      _nReebUS := _nFaltaUS
   Endif   

   // Calculo da Restituicao ou reembolso em DM
   _nSobraDM  := 0
   _nFaltaDM  := 0
   
   If SZ3->Z3_MOEDA == "3"
      _nCalcDM := _nAdtDM - _nTDespDM 
      If _nCalcDM >= 0
         _nSobraDM := _nCalcDM
      Else
         _nFaltaDM := _nCalcDM * (-1)
      Endif
      _nRestDM := _nSobraDM
      _nReebDM := _nFaltaDM
   Endif   

// Calculo da Restituicao ou reembolso em OU
   _nSobraOU  := 0
   _nFaltaOU  := 0
    
   If SZ3->Z3_MOEDA == "4"
      _nCalcOU := _nAdtOU - _nTDespOU 
      If _nCalcOU >= 0
         _nSobraOU := _nCalcOU
      Else
         _nFaltaOU := _nCalcOU * (-1)
      Endif
      _nRestOU := _nSobraOU
      _nReebOU := _nFaltaOU
   Endif   

   ObjectMethod(oRestRS,"Refresh()")
   ObjectMethod(oRestCV,"Refresh()")
   ObjectMethod(oRestUS,"Refresh()")
   ObjectMethod(oRestDM,"Refresh()")
   ObjectMethod(oRestOU,"Refresh()")

   ObjectMethod(oReebRS,"Refresh()")
   ObjectMethod(oReebCV,"Refresh()")
   ObjectMethod(oReebUS,"Refresh()")
   ObjectMethod(oReebDM,"Refresh()")
   ObjectMethod(oReebOU,"Refresh()")

Return


Static Function Sair()

   If MsgBox("Tem Certeza que Deseja Sair?","Aviso","YESNO")
      _lCont := .f.
      Close(oDlg6)
   Endif
   
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Grava_Dados Autor ³ Jose Roberto Gorski   ³ Data ³ 05/05/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Grava os Dados Preenchidos (SZ4,SE1,SE2)                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
Static Function Grava_Dados()
Local _aGrupo := pswret()

If !MsgBox("Tem Certeza que Deseja Confirmar?","Aviso","YESNO")
   Return
Endif

// Grava as informa‡äes do acerto de viagem
RecLock("SZ4",.t.)
  SZ4->Z4_FILIAL  := xFilial("SZ4")
  SZ4->Z4_NUM     := SZ3->Z3_NUM
  SZ4->Z4_MATR    := SZ3->Z3_MATR
  SZ4->Z4_DESTINO := SZ3->Z3_DESTINO
  SZ4->Z4_NOME    := SZ3->Z3_NOME
  SZ4->Z4_DATADE  := SZ3->Z3_DATADE
  SZ4->Z4_DATAATE := SZ3->Z3_DATAATE
  SZ4->Z4_EMPRESA := SZ3->Z3_EMPRESA
  SZ4->Z4_HOTELRS := _nHotelRS 
  SZ4->Z4_HOTELCV := _nHotelCV
  SZ4->Z4_HOTELUS := _nHotelUS 
  SZ4->Z4_HOTELDM := _nHotelDM 
  SZ4->Z4_HOTELOU := _nHotelOU 
  SZ4->Z4_REFERS  := _nRefRS 
  SZ4->Z4_REFECV  := _nRefCV
  SZ4->Z4_REFEUS  := _nRefUS 
  SZ4->Z4_REFEDM  := _nRefDM
  SZ4->Z4_REFEOU  := _nRefOU 
  SZ4->Z4_PASRS   := _nPassRS
  SZ4->Z4_PASCV   := _nPassCV 
  SZ4->Z4_PASUS   := _nPassUS
  SZ4->Z4_PASDM   := _nPassDM
  SZ4->Z4_PASOU   := _nPassOU
  SZ4->Z4_COMBRS  := _nCombRS
  SZ4->Z4_COMBCV  := _nCombCV
  SZ4->Z4_COMBUS  := _nCombUS
  SZ4->Z4_COMBDM  := _nCombDM
  SZ4->Z4_COMBOU  := _nCombOU
  SZ4->Z4_FONERS  := _nFoneRS
  SZ4->Z4_FONECV  := _nFoneCV
  SZ4->Z4_FONEUS  := _nFoneUS
  SZ4->Z4_FONEDM  := _nFoneDM
  SZ4->Z4_FONEOU  := _nFoneOU
  SZ4->Z4_CONDRS  := _nCondRS
  SZ4->Z4_CONDCV  := _nCondCV
  SZ4->Z4_CONDUS  := _nCondUS
  SZ4->Z4_CONDDM  := _nCondDM
  SZ4->Z4_CONDOU  := _nCondOU  
  SZ4->Z4_REPARRS := _nRepRS
  SZ4->Z4_REPARCV := _nRepCV
  SZ4->Z4_REPARUS := _nRepUS
  SZ4->Z4_REPARDM := _nRepDM
  SZ4->Z4_REPAROU := _nRepOU
  SZ4->Z4_OUTRORS := _nOut1RS
  SZ4->Z4_OUTROCV := _nOut1CV
  SZ4->Z4_OUTROUS := _nOut1US
  SZ4->Z4_OUTRODM := _nOut1DM
  SZ4->Z4_OUTROOU := _nOut1OU
  SZ4->Z4_OUTR1RS := _nOut2RS
  SZ4->Z4_OUTR1CV := _nOut2CV
  SZ4->Z4_OUTR1US := _nOut2US
  SZ4->Z4_OUTR1DM := _nOut2DM
  SZ4->Z4_OUTR1OU := _nOut2OU
  SZ4->Z4_OUTR2RS := _nOut3RS
  SZ4->Z4_OUTR2CV := _nOut3CV
  SZ4->Z4_OUTR2US := _nOut3US
  SZ4->Z4_OUTR2DM := _nOut3DM
  SZ4->Z4_OUTR2OU := _nOut3OU
  SZ4->Z4_DESPRS  := _nTDespRS
  SZ4->Z4_DESPCV  := _nTDespCV
  SZ4->Z4_DESPUS  := _nTDespUS
  SZ4->Z4_DESPDM  := _nTDespDM
  SZ4->Z4_DESPOU  := _nTDespOU
  SZ4->Z4_TAXAUS  := _nTaxaUS
  SZ4->Z4_TAXADM  := _nTaxaDM
  SZ4->Z4_TAXAOU  := _nTaxaOU

  If SZ3->Z3_MOEDA == "1"   
     SZ4->Z4_ADIANTA := _nAdtRS
     SZ4->Z4_RESTITU := _nRestRS
     SZ4->Z4_REMB    := _nReebRS
  Elseif SZ3->Z3_MOEDA == "2"
     SZ4->Z4_ADIANTA := _nAdtUS
     SZ4->Z4_RESTITU := _nRestUS
     SZ4->Z4_REMB    := _nReebUS
  Elseif SZ3->Z3_MOEDA == "3" 
     SZ4->Z4_ADIANTA := _nAdtDM
     SZ4->Z4_RESTITU := _nRestDM
     SZ4->Z4_REMB    := _nReebDM
  Elseif SZ3->Z3_MOEDA == "4"  
     SZ4->Z4_ADIANTA := _nAdtOU
     SZ4->Z4_RESTITU := _nRestOU
     SZ4->Z4_REMB    := _nReebOU
  Endif   
MsUnLock("SZ4")

// Marcar como ja acertado no SZ3
RecLock("SZ3",.f.)
  SZ3->Z3_GEROUAC := "S"
  SZ3->Z3_STATUS  := "P"  // Grava como requisicao Pendente no Financeiro.
  SZ3->Z3_ACTUSR  :=  _agrupo[1,4 ] // Nome completo.
  SZ3->Z3_ACTDAT  :=  Date()
  SZ3->Z3_ACTHOR  :=  Substr(Time(),1,5)
MsUnLock("SZ3")
Close(oDlg6)
_lCont := .f.
Return
