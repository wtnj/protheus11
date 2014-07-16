/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT110TOK        ³ José Roberto Gorski   ³ Data ³ 26/02/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ para tratar as SCs no MRP, ao invés de gerar SC, será gerado³±±
±±³          ³ Release para o Fornecedor, PE antes da confirmação da SC  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
 */       

 
#include "topconn.ch"
#include "rwmake.ch"

User Function MT110TOK()

Local _lRet       := .T.
Local _cChave     := ""
Local _cObs       := ""
Local _lAchou     := .f.
Local _nItem      := 1    
Local _nPerce     := 0
Local cQuery1 
Local _nxx 
Local cAprvdr     := ''

Private _nPosSeqMRP := GdFieldPos("C1_SEQMRP")
Private _nPosProd   := GdFieldPos("C1_PRODUTO")
Private _cNum       := "" 
Private _aRel       := {}
Private _nx  
Private _dDtaRec    := Ctod(" / / ")
Private aFreq       := {}

// Se SC gerada pelo MRP, será bloqueada....Caso contrário deixa passar
/*
If Empty(Acols[1][_nPosSeqMRP])
	Return .t.
Endif
*/
  
//If !Alltrim ((Acols[1][GdFieldPos("C1_PRODUTO")]))$'AUD08.1.0212.00'
//   return(.t.)
//Endif   


ZA0->(DbSetOrder(1)) // Filial + Numero

// Para cada linha da SC atualizar ou incluir release
For _i := 1 to Len(Acols)

   
       // -- Alert (Acols[_i][_nPosProd])	
  	    //Verificar para qual fornecedor e percentual deve-se gerar o release
  		cQuery1 := "SELECT SA5.A5_FORNECE,SA5.A5_LOJA,SA5.A5_NOMEFOR,SA5.A5_PRODUTO,SA5.A5_PERCENT,SA5.A5_FREQ, SA5.R_E_C_N_O_ AS REG"
		cQuery1 += " FROM " +RetSqlName("SA5")+" SA5 (NOLOCK)"
		cQuery1 += " WHERE SA5.A5_PRODUTO = '" + Acols[_i][_nPosProd] + "'"
	    cQuery1 += " AND SA5.A5_PERCENT <> 0" 
	    cQuery1 += " AND SA5.D_E_L_E_T_  = ''"     
   
	    MemoWrit('C:\TEMP\MT110TOK.SQL',cQuery1)    
	    TCQUERY cQuery1 NEW ALIAS "TEMP"

	    TEMP->(DbGoTop())
	    _nPerce := 0
    
	    While TEMP->(!Eof())
	       If _nPerce < 100
	          Aadd(_aRel,{TEMP->A5_FORNECE,TEMP->A5_LOJA,TEMP->A5_NOMEFOR,TEMP->A5_PRODUTO,TEMP->A5_PERCENT,TEMP->A5_FREQ})
	          _nPerce+=TEMP->A5_PERCENT  
	       Endif   
	       TEMP->(Dbskip())
	    Enddo    
      
	    If _nPerce > 0
    
			If _nPerce <> 100 //verifica se o percentual é diferente de 100%
			   MsgBox(OemToAnsi("Atenção o Percentual para o Produto "+Acols[_i][GdFieldPos("C1_PRODUTO")]+ " Esta diferente de 100% no Cadastro Produto X Fornecedor","MRP Materiais","ALERT"))
			Endif

			For _nx := 1 to len(_aRel)
		        
							
		       Atu_Dia(Acols[_i][GdFieldPos("C1_DATPRF")],_aRel[_nx][6])//busca as data no mes, conforme a frequencia
		        
			   _cObs := Acols[1][_nPosSeqMRP] + SubStr(DtoS(Acols[_i][GdFieldPos("C1_DATPRF")]),1,4)
		       _cObs += SubStr(DtoS(Acols[_i][GdFieldPos("C1_DATPRF")]),5,2)
		
			  //Verificar se já existe Release lançada
			   cQuery := "SELECT ZA9_NUM,ZA9_OBS, R_E_C_N_O_ AS REG"
			   cQuery += " FROM " +RetSqlName("ZA9")+" ZA9 (NOLOCK)"
			   cQuery += " WHERE ZA9.ZA9_OBS = '" + _cObs + "'"
		       cQuery += " AND ZA9.D_E_L_E_T_  = ''"     
               cQuery += " AND ZA9.ZA9_FORNEC = '" + _aRel [_nx][1] + "'"  //Fornecedor
               cQuery += " AND ZA9.ZA9_LOJA = '" + _aRel [_nx][2] + "'"  //Loja
		
			   TCQUERY cQuery NEW ALIAS "REL"
		
			   REL->(DbGoTop())
				If REL->(!Eof()) //ALteração
				
					If ZA0->(DbSeek(xFilial("ZA0") + REL->ZA9_NUM))
						_cChave := ZA0->ZA0_FILIAL + ZA0->ZA0_NUM
						_lAchou := .f.
						While ZA0->(!Eof()) .And. _cChave == ZA0->ZA0_FILIAL + ZA0->ZA0_NUM
						// Procura dentro da solicitação se tem o mesmo produto
		    				If ZA0->ZA0_PROD == Acols[_i][GdFieldPos("C1_PRODUTO")]
								Begin TRansaction
							// Caso já exista soma ao valor já existente
								RecLock("ZA0",.f.)
													/* cCmd := "ZA0->ZA0_PREV" + SubStr(DtoS(_dDtaRec),7,2)
                                   cCmd += " += (_aRel["+StrZero(_nx,2)+ "][5]/100)* Acols[" + StrZero(_i,2) + "]" + "[" + StrZero(GdFieldPos("C1_QUANT"),2) + "]"
							   	   &(cCmd)
							    */

								
								For _nidx:=1 to Len(_aDatas)
								    cCmd := "ZA0->ZA0_PREV" + SubStr(DtoS(_aDatas[_nIdx][1]),7,2)
							        cCmd += " += (_aRel["+StrZero(_nx,2)+ "][5]/100)* _aDatas["+StrZero(_nIdx,2)+"][2] "
 
 									&(cCmd)
								Next _nIdx   
								
								MsUnLock("ZA0")
								End Transaction
								_lAchou := .t.
							Endif
							_nItem++
							ZA0->(DbSkip())
						EndDo
					
						// Caso ainda não exista registro, deverá ser incluido
						If !_lAchou
							Atu_ZA0(StrZero(_nItem,4),REL->ZA9_NUM)
						Endif
					Endif
				
				Else // Inclusão
				
					_cNum := GetSXENum("ZA9","ZA9_NUM")
				
					//Cabeçalho
					Begin Transaction
					RecLock("ZA9",.T.)
					ZA9->ZA9_FILIAL := xFilial("ZA9")
					ZA9->ZA9_NUM	:= _cNum
					ZA9->ZA9_FORNEC	:= _aRel [_nx][1] //Fornecedor
					ZA9->ZA9_LOJA	:= _aRel [_nx][2] //Loja
					ZA9->ZA9_FNOME	:= _aRel [_nx][3] //Nome Fornecedor
					ZA9->ZA9_DATA	:= _aDatas[1][1] // primeira data a ser gerado o release
					ZA9->ZA9_MES    := Val(SubStr(DtoS(Acols[_i][GdFieldPos("C1_DATPRF")]),5,2))
					ZA9->ZA9_ANO    := Val(SubStr(DtoS(Acols[_i][GdFieldPos("C1_DATPRF")]),1,4))
					ZA9->ZA9_STATUS := "P"
					ZA9->ZA9_RESP   := Upper(cUserName)
					ZA9->ZA9_OBS    := _cObs
					MsUnLock('ZA9')
				
					// Itens
					Atu_ZA0("0001",_cNum)
				
					ConfirmSX8()
				
					End Transaction
				Endif
				If SELECT("REL") > 1
			   	   REL->(DbCloseArea())
			   	Endif
			Next _nx	
	    Endif	
//	Endif
	
   	
    If SELECT("TEMP") > 1   	   
       TEMP->(DbCloseArea())
    Endif   
    
Next _i

//-- se retornar verdadeiro
//-- limpa as pendencias de aprovacao que ja foram aprovadas
//-- e avisa os aprovadores

/*
If _lRet

	//-- os: 046753, 046804
	If altera .AND. !lCopia
		//-- aprovação de SC
		SZUAltSC()
			
	Endif
	//-- FIM os: 046753,046804
Endif
*/

Return _lRet

************************************************************************************
Static Function Atu_ZA0(_pcItem,_pcNum)


RecLock('ZA0',.T.)
ZA0->ZA0_FILIAL := xFilial('ZA0')
ZA0->ZA0_NUM	:= _pcNum
ZA0->ZA0_ITEM   := _pcItem
ZA0->ZA0_DATA	:= dDataBase
ZA0->ZA0_PROD   := Acols[_i][GdFieldPos("C1_PRODUTO")]
ZA0->ZA0_ATRASO := 0
ZA0->ZA0_TIPO   := "" // Verificar o que é isto
ZA0->ZA0_PEDIDO := Acols[1][_nPosSeqMRP]
ZA0->ZA0_FREQ	:= _aRel [_nx][6] //Frequencia

//cCmd := "ZA0->ZA0_PREV" + SubStr(DtoS(Acols[_i][GdFieldPos("C1_DATPRF")]),7,2)
For _nidx:=1 to Len(_aDatas)
   cCmd := "ZA0->ZA0_PREV" + SubStr(DtoS(_aDatas[_nIdx][1]),7,2)
   cCmd += " := (_aRel["+StrZero(_nx,2)+ "][5]/100)* _aDatas["+StrZero(_nIdx,2)+"][2] "

   &(cCmd)
Next _nIdx   

ZA0->ZA0_MES1   := 0
ZA0->ZA0_MES2   := 0
ZA0->ZA0_MES3   := 0
ZA0->ZA0_COND   := ""
ZA0->ZA0_ITEMPE := Acols[_i][GdFieldPos("C1_ITEM")]
MsUnLock('ZA0')

//fAtuAtraso(_cNum, Acols[x][1],Acols[x][5]) //grava o atraso no release anterior
Return
                                           


Static Function Atu_Dia(_dtData,_nFreq)
Local _nAux
Local _nIni       := 1
Local _dDtaAux
Local _nQtde      := 0
Local _nControl   := 0 
Public _aDatas   := {}

// _dDtaAux := Stod(SubStr(DtoS(_dtData),1,6) + "01")
_dDtaAux := _dtData

If Dow(_dDtaAux) == 1 //domingo 
   _dDtaAux += 1 // primeiro dia segunda
   _nIni    :=  3
Elseif Dow(_dDtaAux) == 7 //sabado
   _dDtaAux += 2 // primeiro dia segunda     
   _nIni    :=  4   
Elseif Dow(_dDtaAux) == 2 //Segunda
   _nIni    :=  2   
Endif          

SB1->(DbSeek(xFilial("SB1") +Acols[_i][_nPosProd]))
//If aperiodos[1] //dia inicial

//Endif
If _nFreq == "6"//Mensal
   If SB1->B1_QE > 0 //Qtde por embalagem
//      alert(Acols[_i][GdFieldPos("C1_QUANT")])
//      alert(SB1->B1_QE)
      _nQtde := Acols[_i][GdFieldPos("C1_QUANT")] - (Acols[_i][GdFieldPos("C1_QUANT")]%SB1->B1_QE )
//      alert(_nQtde)
      _nQtde +=SB1->B1_QE
//      alert(_nQtde)
      Aadd(_aDatas,{_dDtaAux,_nQtde}) //adiciona primeira data valida      
   Else
       Aadd(_aDatas,{_dDtaAux,Acols[_i][GdFieldPos("C1_QUANT")]}) //adiciona primeira data valida
   Endif
   Return(_aDatas)   // Sai do programa pois é uma data apenas
ElseIf _nFreq == "4"//Semanal 
      
   _nQtde := Round(Acols[_i][GdFieldPos("C1_QUANT")]/4,0)
   Aadd(_aDatas,{_dDtaAux,_nQtde}) //adiciona primeira data valida
   
ElseIf _nFreq == "5"//Quinzenal 

   _nQtde := Round(Acols[_i][GdFieldPos("C1_QUANT")]/2,0)
   Aadd(_aDatas,{_dDtaAux,_nQtde}) //adiciona primeira data valida
   _nIni    :=  11     

ElseIf _nFreq == "2"//Duas Vezes por Semana

   _nQtde := Round((Acols[_i][GdFieldPos("C1_QUANT")]/4)/2,0)
   If Dow(_dDtaAux) > 2
      Aadd(_aDatas,{_dDtaAux,_nQtde*2}) //adiciona primeira data valida
      _nIni += 1
      _nControl := 7 
   Else
      Aadd(_aDatas,{_dDtaAux,_nQtde}) //adiciona primeira data valida   
      _nControl := 8 
   Endif
   
ElseIf _nFreq == "3"//Tres Vezes por Semana

   _nQtde := Round((Acols[_i][GdFieldPos("C1_QUANT")]/4)/3,0)
   If Dow(_dDtaAux) > 2 .And. Dow(_dDtaAux) < 5              
      _nQtde := Round((Acols[_i][GdFieldPos("C1_QUANT")]/4)/2,0)
      Aadd(_aDatas,{_dDtaAux,_nQtde}) //adiciona primeira data valida
      _nControl := 11 
   Elseif Dow(_dDtaAux) > 4
      _nQtde := Round((Acols[_i][GdFieldPos("C1_QUANT")]/4),0)
      Aadd(_aDatas,{_dDtaAux,_nQtde}) //adiciona primeira data valida   
      _nControl := 10 
   Else 
      Aadd(_aDatas,{_dDtaAux,_nQtde}) //adiciona primeira data valida   
      _nControl := 12       
   Endif   
   _nQtde := Round((Acols[_i][GdFieldPos("C1_QUANT")]/4)/3,0)

ElseIf _nFreq == "1"//Diario

   _nQtde := Round((Acols[_i][GdFieldPos("C1_QUANT")]/4)/5,0)
   _nControl := 20       

Endif   



//For _nAux := _nIni to UltimoDia(_dtData) // percorre todo mes

For _nAux := 1 to 7  //Dow(_dDtaAux) // percorre a semana
  
   If _nFreq == "4"//Semanal 
        
      If Dow(_dDtaAux) == 1
         _dDtaAux+=1
      Elseif Dow(_dDtaAux) > 2
         _nDia :=  1
      Endif
      
      If Len(_aDatas) == 4
         Exit //força a saida do for para agilizar o processamento
      Endif

      _dDtaAux := Stod(SubStr(DtoS(_dtData),1,6) + StrZero( _nAux,2))
      If Dow(_dDtaAux) == 2 .And. Len(_aDatas) <= 3
         Aadd(_aDatas,{_dDtaAux, _nQtde}) //adiciona primeira data valida         
         If Len(_aDatas) == 4
            Exit //força a saida do for para agilizar o processamento
         Endif
      Endif

   Elseif _nFreq == "5"//Quinzenal
        
      _dDtaAux := Stod(SubStr(DtoS(_dtData),1,6) + StrZero( _nAux,2))
      If Dow(_dDtaAux) == 2 .And. Len(_aDatas) <= 2
         Aadd(_aDatas,{_dDtaAux, _nQtde}) //adiciona primeira data valida         
         If Len(_aDatas) == 2
            Exit //força a saida do for para agilizar o processamento
         Endif
      Endif

   Elseif _nFreq == "2"//Duas Vezes por Semana
        
      _dDtaAux := Stod(SubStr(DtoS(_dtData),1,6) + StrZero( _nAux,2))
      If (Dow(_dDtaAux) == 2 .Or. Dow(_dDtaAux) == 4) .And. Len(_aDatas) < _nControl
         Aadd(_aDatas,{_dDtaAux, _nQtde}) //adiciona primeira data valida         
         If Len(_aDatas) == _nControl
            Exit //força a saida do for para agilizar o processamento
         Endif         
      Endif

   Elseif _nFreq == "3"//Tres Vezes por Semana
        
      _dDtaAux := Stod(SubStr(DtoS(_dtData),1,6) + StrZero( _nAux,2))
      If (Dow(_dDtaAux) == 2 .Or. Dow(_dDtaAux) == 4 .Or. Dow(_dDtaAux) == 6) .And. Len(_aDatas) < _nControl
         Aadd(_aDatas,{_dDtaAux, _nQtde}) //adiciona primeira data valida         
         If Len(_aDatas) == _nControl
            Exit //força a saida do for para agilizar o processamento
         Endif                  
      Endif

   Elseif _nFreq == "1"//Diario
      _dDtaAux := Stod(SubStr(DtoS(_dtData),1,6) + StrZero( _nAux,2))
      If Dow(_dDtaAux) > 1 .And. Dow(_dDtaAux) < 7 .And. Len(_aDatas) < _nControl 
         Aadd(_aDatas,{_dDtaAux,_nQtde}) //adiciona primeira data valida      
         If Len(_aDatas) == _nControl
            Exit //força a saida do for para agilizar o processamento
         Endif                  
      Endif   
   Endif                    
           
    
Next _nAux

Return(_aDatas)


