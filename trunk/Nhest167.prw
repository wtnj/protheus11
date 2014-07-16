/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST167  ºAutor  ³Marcos R Roquitski  º Data ³  28/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Composicao da descricao do produto Ferramentas.             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³WHB                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch" 
#INCLUDE "topconn.ch"   

User Function Nhest167()
	SetPrvt("_cArq,_cTipoMat,_aMaterial,_cMaterial,_aEscalon,_cEscalon,_aCortes,_cCortes,_aCanal,_cCanal")
	SetPrvt("_aRefrig,_cRefrig,_aCobert,_cCobert,_nHaste,_nCompri,_nDiaEsc,_nD1,_nL1,_nD2,_nL2,_nD3,_nL3,_nD4,_nL4,_nD5,_nL5")

	If     M->B1_CODFER == '01'
		_fBroca()

	Elseif M->B1_CODFER == '02'
		_fBroCanhao()

	Elseif M->B1_CODFER == '03'
		_fBroCaLibr()

	Elseif M->B1_CODFER == '04'
		_fAlargador()

	Elseif M->B1_CODFER == '05'
		_fFresaHaste()
		
	Elseif M->B1_CODFER == '06'
		_fFresaDisco()

	Elseif M->B1_CODFER == '07'
		_fRebaixador()

	Elseif M->B1_CODFER == '08'
		_fEscareador()

	Elseif M->B1_CODFER == '09'
		_fMachoMetr()

	Elseif M->B1_CODFER == '10'
		_fMachoPol()

	Endif	

Return(.T.)


Static Function _fBroca()

	_cArq      := Select()
	_cTipoMat  := "BR"
	_aMaterial := {"MDU","HSS","PCD","HSE","CER","CMT","CBN"}
	_cMaterial := Substr(M->B1_FDESCRI,4,3)
	_aEscalon  := {"E","L"}
	_cEscalon  := Substr(M->B1_FDESCRI,8,1)

	_aCortes   := {"2C","3C","4C","5C"}
	_cCortes   := Substr(M->B1_FDESCRI,10,2)
	_aCanal    := {"H","R"}
	_cCanal    := Space(01)
	_aRefrig   := {"CR","SR"}
	_cRefrig   := Space(02)
	_aCobert   := {"CC","SC"}
	_cCobert   := Space(02)
	_nHaste    := 0
	_nCompri   := 0		

	_nDiaEsc   := 0		
	_nD1       := 0
	_nL1       := 0
	_nD2       := 0
	_nL2       := 0
	_nD3       := 0
	_nL3       := 0
	_nD4       := 0
	_nL4       := 0
	_nD5       := 0
	_nL5       := 0

	For i := 1 To Len(Alltrim(M->B1_FDESCRI))

		If _cEscalon == 'E'
			
			If Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. _nD1 == 0
				_nD1  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
				_nL1 := Val( Substr(M->B1_FDESCRI,i+7,3) + '.' +Substr(M->B1_FDESCRI,i+11,2) ) 
				_nDiaEsc++ 
			Elseif Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. (_nD1 > 0 .and. _nD2 == 0)
				_nD2  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
				_nL2 := Val( Substr(M->B1_FDESCRI,i+7,3) + '.' +Substr(M->B1_FDESCRI,i+11,2) ) 
				_nDiaEsc++   				
			Elseif Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. (_nD2 > 0 .and. _nD3 == 0)
				_nD3  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
				_nL3 := Val( Substr(M->B1_FDESCRI,i+7,3) + '.' +Substr(M->B1_FDESCRI,i+11,2) ) 
				_nDiaEsc++   				
			Elseif Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. (_nD3 > 0 .and. _nD4 == 0)
				_nD4  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
				_nL4 := Val( Substr(M->B1_FDESCRI,i+7,3) + '.' +Substr(M->B1_FDESCRI,i+11,2) ) 
				_nDiaEsc++   				
			Elseif Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. (_nD4 > 0 .and. _nD5 == 0)
				_nD5  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
				_nL5 := Val( Substr(M->B1_FDESCRI,i+7,3) + '.' +Substr(M->B1_FDESCRI,i+11,2) ) 
				_nDiaEsc++   				
			Endif

		Elseif 	_cEscalon == 'L' .AND. _nHaste == 0

			If Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. _nD1 == 0
				_nD1  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
				_nDiaEsc++ 
			Elseif Substr(M->B1_FDESCRI,i,1)=="X" .AND. (_nD1 > 0 .and. _nD2 == 0)
				_nD2  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
				_nDiaEsc++   				
			Elseif Substr(M->B1_FDESCRI,i,1)=="X" .AND. (_nD2 > 0 .and. _nD3 == 0)
				_nD3  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
				_nDiaEsc++   				
			Elseif Substr(M->B1_FDESCRI,i,1)=="X" .AND. (_nD3 > 0 .and. _nD4 == 0)
				_nD4  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
				_nDiaEsc++   				
			Elseif Substr(M->B1_FDESCRI,i,1)=="X" .AND. (_nD4 > 0 .and. _nD5 == 0)
				_nD5  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
				_nDiaEsc++   				
			Endif

		Endif


		if Substr(M->B1_FDESCRI,i,1)=="H" .and. _nHaste == 0 
			_nHaste  := Val(Substr(M->B1_FDESCRI,i+1,2)) // Haste
			_nCompri := Val(Substr(M->B1_FDESCRI,i+4,3)) // Comprimento
			_cCanal  := Substr(M->B1_FDESCRI,i+8,1)	   // Canal        
			_cRefrig := Substr(M->B1_FDESCRI,i+10,2)	   // Refrigeracao 
			_cCobert := Substr(M->B1_FDESCRI,i+13,2)     // Cobertura   
		Endif
	Next

	@ 200,050 To 700,600 Dialog oDlg Title OemToAnsi("B R O C A")
	@ 010,020 Say OemToAnsi("Ferramenta") Size 35,8
	@ 025,020 Say OemToAnsi("Material       ") Size 35,8 
	@ 040,020 Say OemToAnsi("Escalonado     ") Size 30,8
	@ 055,020 Say OemToAnsi("Nr. de Cortes  ") Size 35,8
	
	@ 055,125 Say OemToAnsi("Qt.de Escalonado") Size 45,8
	@ 070,020 Say OemToAnsi("Diametro 1     ") Size 35,8
	@ 070,150 Say OemToAnsi("L1 ") Size 35,8

	@ 085,020 Say OemToAnsi("Diametro 2     ") Size 35,8
	@ 085,150 Say OemToAnsi("L2 ") Size 35,8

	@ 100,020 Say OemToAnsi("Diametro 3     ") Size 35,8
	@ 100,150 Say OemToAnsi("L3 ") Size 35,8

	@ 115,020 Say OemToAnsi("Diametro 4     ") Size 35,8
	@ 115,150 Say OemToAnsi("L4 ") Size 35,8

	@ 130,020 Say OemToAnsi("Diametro 5     ") Size 35,8
	@ 130,150 Say OemToAnsi("L5 ") Size 35,8

	@ 145,020 Say OemToAnsi("Ø Haste        ") Size 35,8
	@ 160,020 Say OemToAnsi("Comprimento    ") Size 35,8

	@ 175,020 Say OemToAnsi("Tipo do Canal  ") Size 35,8
	@ 190,020 Say OemToAnsi("Refrigeracao   ") Size 35,8
	@ 205,020 Say OemToAnsi("Cobertura      ") Size 35,8

	@ 009,070 Get _cTipoMat       PICTURE "@!" Size 25,8 When .F. Size 50,8
	@ 024,070 COMBOBOX _cMaterial ITEMS _aMaterial SIZE 50,10 object oCombo
	@ 039,070 COMBOBOX _cEscalon  ITEMS _aEscalon  SIZE 50,10 object oCombo
	@ 054,070 COMBOBOX _cCortes   ITEMS _aCortes   SIZE 50,10 object oCombo

	@ 054,170 Get _nDiaEsc        PICTURE "9"        Size 25,8 Valid(_nDiaEsc >= 1) Size 15,8 
	@ 069,070 Get _nD1            PICTURE "@E 99.99" Size 25,8 Valid(_nD1 >= 0)  When _nDiaEsc >=1 Size 50,8
	@ 069,170 Get _nL1            PICTURE "@E 999.99" Size 25,8 Valid(_nL1 >= 0)  When (_nDiaEsc >=1 .and. _cEscalon <> 'L') Size 50,8
		
	@ 084,070 Get _nD2            PICTURE "@E 99.99" Size 25,8 Valid(_nD2 >= 0)  When (_nDiaEsc >=2 )  Size 50,8
	@ 084,170 Get _nL2            PICTURE "@E 999.99" Size 25,8 Valid(_nL2 >= 0)  When (_nDiaEsc >=2  .and. _cEscalon <> 'L')  Size 50,8

	@ 099,070 Get _nD3            PICTURE "@E 99.99" Size 25,8 Valid(_nD3 >= 0)  When (_nDiaEsc >=3 )  Size 50,8
	@ 099,170 Get _nL3            PICTURE "@E 999.99" Size 25,8 Valid(_nL3 >= 0)  When (_nDiaEsc >=3  .and. _cEscalon <> 'L')  Size 50,8

	@ 114,070 Get _nD4            PICTURE "@E 99.99" Size 25,8 Valid(_nD4 >= 0)  When (_nDiaEsc >=4 )  Size 50,8
	@ 114,170 Get _nL4            PICTURE "@E 999.99" Size 25,8 Valid(_nL4 >= 0)  When (_nDiaEsc >=4  .and. _cEscalon <> 'L')  Size 50,8

	@ 129,070 Get _nD5            PICTURE "@E 99.99" Size 25,8 Valid(_nD5 >= 0)  When (_nDiaEsc >=5 )  Size 50,8
	@ 129,170 Get _nL5            PICTURE "@E 999.99" Size 25,8 Valid(_nL5 >= 0)  When (_nDiaEsc >=5  .and. _cEscalon <> 'L')  Size 50,8

	@ 144,070 Get _nHaste         PICTURE "@E 99"  Size 25,8 Valid(_nHaste >0) Size 50,8
	@ 159,070 Get _nCompri        PICTURE "@E 999" Size 25,8 Valid(_nCompri >0) Size 50,8

	@ 174,070 COMBOBOX _cCanal    ITEMS _aCanal   SIZE 50,10 object oCombo		
	@ 189,070 COMBOBOX _cRefrig   ITEMS _aRefrig  SIZE 50,10 object oCombo		
	@ 204,070 COMBOBOX _cCobert   ITEMS _aCobert  SIZE 50,10 object oCombo		
		
	@ 220,070 BMPBUTTON TYPE 01 ACTION fGBroca()
	@ 220,110 BMPBUTTON TYPE 02 ACTION Close(oDlg)

	Activate Dialog oDlg CENTERED

	DbselectArea(_cArq)
	
Return

Static Function fGBroca()
Local lRet := .T.

	If _nD1 == 0
		Alert("Verifique : Ø da Broca")
		lRet := .F.
	Endif	
	
	If (_nL1  == 0  .and. _cEscalon == 'E')
		Alert("Verifique : Comprimento do Escalonado")
		lRet := .F.
	Endif	
	
	If _nHaste == 0
		Alert("Verifique : Ø Haste")
		lRet := .F.
	Endif	
	
	If _nCompri== 0
		Alert("Verifique : Comprimento Total = <Haste + Corpo>")
		lRet := .F.
	Endif	


	If lRet

		// Descricao broca

		M->B1_FDESCRI := _cTipoMat  + ' ' + _cMaterial + ' ' + _cEscalon  + ' ' + _cCortes   + ' '

		If _cEscalon == 'E'
			If _nD1 > 0	
		       M->B1_FDESCRI += 'Ø' + fDec22(_nD1) + 'X'+ fDec32(_nL1)
		       // M->B1_FDESCRI += 'Ø' + Transform(_nD1,"@E 99.99") + 'X' + Transform(_nL1,"@E 999.99") 
			Endif
			If _nD2 > 0		
		       M->B1_FDESCRI += 'Ø' + fDec22(_nD2) + 'X'+ fDec32(_nL2)
			   // M->B1_FDESCRI += 'Ø' + Transform(_nD2,"@E 99.99") + 'X' + Transform(_nL2,"@E 999.99")
			Endif
			If _nD3 > 0	
		       M->B1_FDESCRI += 'Ø' + fDec22(_nD3) + 'X'+ fDec32(_nL3)
			   // M->B1_FDESCRI += 'Ø' + Transform(_nD3,"@E 99.99") + 'X' + Transform(_nL3,"@E 999.99")
			Endif
			If _nD4 > 0
		       M->B1_FDESCRI += 'Ø' + fDec22(_nD4) + 'X'+ fDec32(_nL4)
				// M->B1_FDESCRI += 'Ø' + Transform(_nD4,"@E 99.99") + 'X' + Transform(_nL4,"@E 999.99")
			Endif
			If _nD5 > 0		
		       M->B1_FDESCRI += 'Ø' + fDec22(_nD5) + 'X'+ fDec32(_nL5)
			   // M->B1_FDESCRI += 'Ø' + Transform(_nD5,"@E 99.99") + 'X' + Transform(_nL5,"@E 999.99")
			Endif

			M->B1_FDESCRI += ' H' + StrZero(_nHaste,2)
			M->B1_FDESCRI += 'X' + StrZero(_nCompri,3)
			M->B1_FDESCRI += ' ' + _cCanal
			M->B1_FDESCRI += ' ' + _cRefrig
			M->B1_FDESCRI += ' ' + _cCobert	

		Elseif 	_cEscalon == 'L'
		
			If _nD1 > 0	
		       M->B1_FDESCRI += 'Ø' + fDec22(_nD1)
			Endif

			If _nD2 > 0		
		       M->B1_FDESCRI += 'X' + fDec22(_nD2)
			Endif

			If _nD3 > 0	
		       M->B1_FDESCRI += 'X' + fDec22(_nD3)
			Endif

			If _nD4 > 0
		       M->B1_FDESCRI += 'X' + fDec22(_nD4)
			Endif
			
			If _nD5 > 0		
		       M->B1_FDESCRI += 'X' + fDec22(_nD5)
			Endif

			M->B1_FDESCRI += ' H' + StrZero(_nHaste,2)
			M->B1_FDESCRI += 'X' + StrZero(_nCompri,3)
			M->B1_FDESCRI += ' ' + _cCanal
			M->B1_FDESCRI += ' ' + _cRefrig
			M->B1_FDESCRI += ' ' + _cCobert	
	
		Endif

	Endif		
	Close(oDlg)
Return(lRet)


Static Function _fBroCanhao()

//BR CANHAO HSS 2C Ø12,34X567 H89X100 SC

	_cArq       := Select()
	_cTipoMat   := "BR CANHAO"
	_aMaterial  := {"MDU","HSS","HSE","MDS"}
	_cMaterial  := Substr(M->B1_FDESCRI,11,3)
	_aCortes    := {"1C","2C"}
	_cCortes    := Substr(M->B1_FDESCRI,15,2)
	_aCobert    := {"CC","SC"}
	_cCobert    := Substr(M->B1_FDESCRI,37,2)
	_nComMatCor := Val(Substr(M->B1_FDESCRI,25,3))
	_nHaste     := Val(Substr(M->B1_FDESCRI,30,2))
	_nCompri    := Val(Substr(M->B1_FDESCRI,33,3))
	_nD1        := Val(Substr(M->B1_FDESCRI,19,2)+'.'+Substr(M->B1_FDESCRI,22,2))
   
	@ 200,050 To 600,600 Dialog oDlg Title OemToAnsi("B R O C A   C A N H Ã O")
	@ 010,020 Say OemToAnsi("Ferramenta") Size 35,8
	@ 030,020 Say OemToAnsi("Material       ") Size 35,8 
	@ 050,020 Say OemToAnsi("Nr. de Cortes  ") Size 35,8
	@ 070,020 Say OemToAnsi("Ø da Broca     ") Size 35,8
	@ 090,020 Say OemToAnsi("Comp. Mat. Cortante ") Size 35,8
	@ 110,020 Say OemToAnsi("Ø Haste        ") Size 35,8
	@ 130,020 Say OemToAnsi("Comp. Total    ") Size 35,8
	@ 150,020 Say OemToAnsi("Cobertura      ") Size 35,8

	@ 009,070 Get _cTipoMat       PICTURE "@!" Size 25,8 When .F. Size 50,8
	@ 029,070 COMBOBOX _cMaterial ITEMS _aMaterial SIZE 50,10 object oCombo
	@ 049,070 COMBOBOX _cCortes   ITEMS _aCortes   SIZE 50,10 object oCombo

	@ 069,070 Get _nD1            PICTURE "@E 99.99" Size 25,8 Valid(_nD1 > 0)   Size 50,8
	@ 089,070 Get _nComMatCor     PICTURE "999" Size 25,8 Valid(_nComMatCor > 0)  Size 50,8
		
	@ 109,070 Get _nHaste         PICTURE "@E 99"  Size 25,8 Valid(_nHaste >0) Size 50,8
	@ 129,070 Get _nCompri        PICTURE "@E 999" Size 25,8 Valid(_nCompri >0) Size 50,8

	@ 149,070 COMBOBOX _cCobert   ITEMS _aCobert  SIZE 50,10 object oCombo		
		
	@ 180,070 BMPBUTTON TYPE 01 ACTION fGBroCanhao()
	@ 180,110 BMPBUTTON TYPE 02 ACTION Close(oDlg)

	Activate Dialog oDlg CENTERED

	DbselectArea(_cArq)
	
Return

Static Function fGBroCanhao()
Local lRet := .T.

	If _nD1 == 0
		Alert("Verifique : Ø da Broca")
		lRet := .F.
	Endif	
	
	If _nComMatCor == 0
		Alert("Verifique : Comprimento Material de Corte")
		lRet := .F.
	Endif	
	
	If _nHaste == 0
		Alert("Verifique : Ø Haste")
		lRet := .F.
	Endif	
	
	If _nCompri== 0
		Alert("Verifique : Comprimento Total = <Haste + Corpo>")
		lRet := .F.
	Endif	

	If lRet
		// Descricao broca canhao
		M->B1_FDESCRI := _cTipoMat  + ' ' + _cMaterial + ' ' + _cCortes   + ' '
		M->B1_FDESCRI += 'Ø' + fDec22(_nD1) + 'X' + StrZero(_nComMatCor,3)
		M->B1_FDESCRI += ' H' + StrZero(_nHaste,2)
		M->B1_FDESCRI += 'X' + StrZero(_nCompri,3)
		M->B1_FDESCRI += ' ' + _cCobert	
	
	Endif	
	Close(oDlg)
Return(lRet)

Static Function _fBroCalibr()

	_cArq      := Select()
	_cTipoMat  := "BR CALIBR"
	_aMaterial := {"MDU","HSS","PCD","HSE","CER","CMT","CBN","MDS"}
	_cMaterial := Substr(M->B1_FDESCRI,11,3)
	_aEscalon  := {"E","L"}
	_cEscalon  := Substr(M->B1_FDESCRI,15,1)
	_aCortes   := {"2C","3C","4C","5C"}
	_cCortes   := Substr(M->B1_FDESCRI,17,2)
	_aCanal    := {"H","R"}
	_cCanal    := Space(01)
	_aRefrig   := {"CR","SR"}
	_cRefrig   := Space(02)
	_aCobert   := {"CC","SC"}
	_cCobert   := Space(02)
	_nHaste    := 0
	_nCompri   := 0		
	_nDiaEsc   := 0		
	_nTolIso   := Val(Substr(M->B1_FDESCRI,28,2))
	_nD1       := 0
	_nL1       := 0
	_nD2       := 0
	_nL2       := 0
	_nD3       := 0
	_nL3       := 0
	_nD4       := 0
	_nL4       := 0
	_nD5       := 0
	_nL5       := 0


	For i := 1 To Len(Alltrim(M->B1_FDESCRI))
			
		If Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. _nD1 == 0
			_nD1  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,3) )
			_nL1 := Val( Substr(M->B1_FDESCRI,i+11,3) + '.' +Substr(M->B1_FDESCRI,i+15,2) ) 
			_nDiaEsc++ 
		Elseif Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. (_nD1 > 0 .and. _nD2 == 0)
			_nD2  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
			_nL2 := Val( Substr(M->B1_FDESCRI,i+7,3) + '.' +Substr(M->B1_FDESCRI,i+11,2) ) 
			_nDiaEsc++   				
		Elseif Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. (_nD2 > 0 .and. _nD3 == 0)
			_nD3  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
			_nL3 := Val( Substr(M->B1_FDESCRI,i+7,3) + '.' +Substr(M->B1_FDESCRI,i+11,2) ) 
			_nDiaEsc++   				
		Elseif Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. (_nD3 > 0 .and. _nD4 == 0)
			_nD4  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
			_nL4 := Val( Substr(M->B1_FDESCRI,i+7,3) + '.' +Substr(M->B1_FDESCRI,i+11,2) ) 
			_nDiaEsc++   				
		Elseif Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. (_nD4 > 0 .and. _nD5 == 0)
			_nD5  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
			_nL5 := Val( Substr(M->B1_FDESCRI,i+7,3) + '.' +Substr(M->B1_FDESCRI,i+11,2) ) 
			_nDiaEsc++   				
		Endif

		if (Substr(M->B1_FDESCRI,i,1)=="H" .and. _nHaste ==0 .and. i > 30)
			_nHaste  := Val(Substr(M->B1_FDESCRI,i+1,2)) // Haste
			_nCompri := Val(Substr(M->B1_FDESCRI,i+4,3)) // Comprimento
			_cCanal  := Substr(M->B1_FDESCRI,i+8,1)	   // Canal        
			_cRefrig := Substr(M->B1_FDESCRI,i+10,2)	   // Refrigeracao 
			_cCobert := Substr(M->B1_FDESCRI,i+13,2)     // Cobertura   
		Endif

	Next

	@ 200,050 To 700,600 Dialog oDlg Title OemToAnsi("B R O C A   C A L I B R A D O R A")
	@ 010,020 Say OemToAnsi("Ferramenta") Size 35,8
	@ 025,020 Say OemToAnsi("Material       ") Size 35,8 
	@ 040,020 Say OemToAnsi("Escalonado     ") Size 30,8
	@ 055,020 Say OemToAnsi("Nr. de Cortes  ") Size 35,8
	
	@ 055,125 Say OemToAnsi("Qt.de Escalonado") Size 45,8

	@ 070,020 Say OemToAnsi("Diametro 1     ") Size 35,8
	@ 070,110 Say OemToAnsi("Tolerancia ISO") Size 35,8
	@ 070,190 Say OemToAnsi("L1 ") Size 35,8

	@ 085,020 Say OemToAnsi("Diametro 2     ") Size 35,8
	@ 085,150 Say OemToAnsi("L2 ") Size 35,8

	@ 100,020 Say OemToAnsi("Diametro 3     ") Size 35,8
	@ 100,150 Say OemToAnsi("L3 ") Size 35,8

	@ 115,020 Say OemToAnsi("Diametro 4     ") Size 35,8
	@ 115,150 Say OemToAnsi("L4 ") Size 35,8

	@ 130,020 Say OemToAnsi("Diametro 5     ") Size 35,8
	@ 130,150 Say OemToAnsi("L5 ") Size 35,8

	@ 145,020 Say OemToAnsi("Ø Haste        ") Size 35,8
	@ 160,020 Say OemToAnsi("Comprimento    ") Size 35,8

	@ 175,020 Say OemToAnsi("Tipo do Canal  ") Size 35,8
	@ 190,020 Say OemToAnsi("Refrigeracao   ") Size 35,8
	@ 205,020 Say OemToAnsi("Cobertura      ") Size 35,8

	@ 009,070 Get _cTipoMat       PICTURE "@!" Size 25,8 When .F. Size 50,8
	@ 024,070 COMBOBOX _cMaterial ITEMS _aMaterial SIZE 50,10 object oCombo
	@ 039,070 COMBOBOX _cEscalon  ITEMS _aEscalon  SIZE 50,10 object oCombo
	@ 054,070 COMBOBOX _cCortes   ITEMS _aCortes   SIZE 50,10 object oCombo

	@ 054,170 Get _nDiaEsc        PICTURE "9"         Size 25,8 Valid(_nDiaEsc >= 1) Size 15,8 
	@ 069,070 Get _nD1            PICTURE "@E 99.999" Size 25,8 Valid(_nD1 >= 0)  When _nDiaEsc >=1 Size 50,8
	@ 069,150 Get _nTolIso        PICTURE "99"        Size 25,8 Valid(_nTolIso >= 0)  When _nDiaEsc >=1 Size 50,8
	@ 069,210 Get _nL1            PICTURE "@E 999.99" Size 25,8 Valid(_nL1 >= 0)  When _nDiaEsc >=1 Size 50,8
		
	@ 084,070 Get _nD2            PICTURE "@E 99.99"  Size 25,8 Valid(_nD2 >= 0 .and. _nD2 > _nD1)  When (_nDiaEsc >=2 )  Size 50,8
	@ 084,170 Get _nL2            PICTURE "@E 999.99" Size 25,8 Valid(_nL2 >= 0)  When (_nDiaEsc >=2 )  Size 50,8

	@ 099,070 Get _nD3            PICTURE "@E 99.99"  Size 25,8 Valid(_nD3 >= 0 .and. _nD3 > _nD2)  When (_nDiaEsc >=3 )  Size 50,8
	@ 099,170 Get _nL3            PICTURE "@E 999.99" Size 25,8 Valid(_nL3 >= 0)  When (_nDiaEsc >=3 )  Size 50,8

	@ 114,070 Get _nD4            PICTURE "@E 99.99"  Size 25,8 Valid(_nD4 >= 0 .and. _nD4 > _nD3)  When (_nDiaEsc >=4 )  Size 50,8
	@ 114,170 Get _nL4            PICTURE "@E 999.99" Size 25,8 Valid(_nL4 >= 0)  When (_nDiaEsc >=4 )  Size 50,8

	@ 129,070 Get _nD5            PICTURE "@E 99.99"  Size 25,8 Valid(_nD5 >= 0)  When (_nDiaEsc >=5 )  Size 50,8
	@ 129,170 Get _nL5            PICTURE "@E 999.99" Size 25,8 Valid(_nL5 >= 0)  When (_nDiaEsc >=5 )  Size 50,8

	@ 144,070 Get _nHaste         PICTURE "@E 99"  Size 25,8 Valid(_nHaste >0) Size 50,8
	@ 159,070 Get _nCompri        PICTURE "@E 999" Size 25,8 Valid(_nCompri >0) Size 50,8

	@ 174,070 COMBOBOX _cCanal    ITEMS _aCanal   SIZE 50,10 object oCombo		
	@ 189,070 COMBOBOX _cRefrig   ITEMS _aRefrig  SIZE 50,10 object oCombo		
	@ 204,070 COMBOBOX _cCobert   ITEMS _aCobert  SIZE 50,10 object oCombo		
		
	@ 220,070 BMPBUTTON TYPE 01 ACTION fGBroCalibr()
	@ 220,110 BMPBUTTON TYPE 02 ACTION Close(oDlg)

	Activate Dialog oDlg CENTERED

	DbselectArea(_cArq)
	
Return

Static Function fGBroCalibr()
Local lRet := .T.

	If _nD1 == 0
		Alert("Verifique : Ø da Broca")
		lRet := .F.
	Endif	
	
	If _nL1  == 0
		Alert("Verifique : Comprimento do Escalonado")
		lRet := .F.
	Endif	
	
	If _nHaste == 0
		Alert("Verifique : Ø Haste")
		lRet := .F.
	Endif	
	
	If _nCompri== 0
		Alert("Verifique : Comprimento Total = <Haste + Corpo>")
		lRet := .F.
	Endif	


	If lRet

		// Descricao broca

		M->B1_FDESCRI := _cTipoMat  + ' ' + _cMaterial + ' ' + _cEscalon  + ' ' + _cCortes   + ' '
	
		If _nD1 > 0	
	       M->B1_FDESCRI += 'Ø' + fDec23(_nD1) + 'H'+ StrZero(_nTolIso,2) + 'X' + fDec32(_nL1)
	       //M->B1_FDESCRI += 'Ø' + Transform(_nD1,"@E 99.999") + 'H' + Transform(_nTolIso,"99") + 'X' + Transform(_nL1,"@E 999.99") 
		Endif
	
		If _nD2 > 0		
	       M->B1_FDESCRI += 'Ø' + fDec22(_nD2) + 'X' + fDec32(_nL2)
		   //	M->B1_FDESCRI += 'Ø' + Transform(_nD2,"@E 99.99") + 'X' + Transform(_nL2,"@E 999.99")
		Endif
	
		If _nD3 > 0		
	       M->B1_FDESCRI += 'Ø' + fDec22(_nD3) + 'X' + fDec32(_nL3)
		   //	M->B1_FDESCRI += 'Ø' + Transform(_nD3,"@E 99.99") + 'X' + Transform(_nL3,"@E 999.99")
		Endif
	
		If _nD4 > 0	
	       M->B1_FDESCRI += 'Ø' + fDec22(_nD4) + 'X' + fDec32(_nL4)
			// M->B1_FDESCRI += 'Ø' + Transform(_nD4,"@E 99.99") + 'X' + Transform(_nL4,"@E 999.99")
		Endif
	
		If _nD5 > 0		
	       M->B1_FDESCRI += 'Ø' + fDec22(_nD5) + 'X' + fDec32(_nL5)
			// M->B1_FDESCRI += 'Ø' + Transform(_nD5,"@E 99.99") + 'X' + Transform(_nL5,"@E 999.99")
		Endif

		M->B1_FDESCRI += ' H' + StrZero(_nHaste,2)
		M->B1_FDESCRI += 'X' + StrZero(_nCompri,3)
		M->B1_FDESCRI += ' ' + _cCanal
		M->B1_FDESCRI += ' ' + _cRefrig
		M->B1_FDESCRI += ' ' + _cCobert	

	Endif		
	Close(oDlg)
Return(lRet)


Static Function _fAlargador()

	// ALARG I MDU E 2C Ø12,345H12X123,45Ø12,345H12X123,45Ø12,345H12X123,45Ø12,345H12X123,45 ABS 123X012 H CR CC

	_cArq      := Select()
	_cTipoMat  := "ALARG"
	_aTipoAlar := {"I","L","S"}
	_cTipoAlar := Substr(M->B1_FDESCRI,7,1)
	
	_aMaterial := {"MDU","HSS","PCD","HSE","CER","CMT","CBN","MDS"}
	_cMaterial := Substr(M->B1_FDESCRI,9,3)

	_aEscalon  := {"E","L"}
	_cEscalon  := Substr(M->B1_FDESCRI,13,1)

	_aCortes   := {"2C","3C","4C","5C","6C"}
	_cCortes   := Substr(M->B1_FDESCRI,15,2)

	_aCanal    := {"H","R"}
	_cCanal    := Space(01)

	_aRefrig   := {"CR","SR"}
	_cRefrig   := Space(02)

	_aCobert   := {"CC","SC"}
	_cCobert   := Space(02)

	_aTipoFix  := {"ABS","MOD","CIL","WEL","HSK","ISO"}
	_cTipoFix  := Space(03)

	_nHaste    := 0
	_nCompri   := 0		
	_nDiaEsc   := 0		

	_nD1       := 0
	_nTolIso1  := 0
	_nL1       := 0
	_nD2       := 0
	_nTolIso2  := 0
	_nL2       := 0
	_nD3       := 0
	_nTolIso3  := 0
	_nL3       := 0
	_nD4       := 0
	_nTolIso4  := 0
	_nL4       := 0


	For i := 1 To Len(Alltrim(M->B1_FDESCRI))

		// ALARG I MDU E 2C Ø12,345H12X123,45Ø12,345H12X123,45Ø12,345H12X123,45Ø12,345H12X123,45 ABS 123X012 H CR CC			

		If Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. _nD1 == 0
			_nD1       := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,3) )
			_nTolIso1  := Val( Substr(M->B1_FDESCRI,i+8,2))
			_nL1       := Val( Substr(M->B1_FDESCRI,i+11,3) + '.' +Substr(M->B1_FDESCRI,i+15,2) ) 
			_nDiaEsc++ 
		Elseif Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. (_nD1 > 0 .and. _nD2 == 0)
			_nD2       := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,3) )
			_nTolIso2  := Val( Substr(M->B1_FDESCRI,i+8,2))
			_nL2       := Val( Substr(M->B1_FDESCRI,i+11,3) + '.' +Substr(M->B1_FDESCRI,i+15,2) ) 
			_nDiaEsc++   				
		Elseif Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. (_nD2 > 0 .and. _nD3 == 0)
			_nD3       := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
			_nTolIso3  := Val( Substr(M->B1_FDESCRI,i+8,2))
			_nL3       := Val( Substr(M->B1_FDESCRI,i+11,3) + '.' +Substr(M->B1_FDESCRI,i+15,2) ) 
			_nDiaEsc++   				
		Elseif Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. (_nD3 > 0 .and. _nD4 == 0)
			_nD4       := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
			_nTolIso4  := Val( Substr(M->B1_FDESCRI,i+8,2))
			_nL4       := Val( Substr(M->B1_FDESCRI,i+11,3) + '.' +Substr(M->B1_FDESCRI,i+15,2) ) 
			_nDiaEsc++   				
		Endif


		// _aTipoFix  := {"ABS","MOD","CIL","WEL","HSK","ISO"}
		//ALARG I MDU E 2C Ø12,345H12X123,45Ø12,345H12X123,45Ø12,345H12X123,45Ø12,345H12X123,45 ABS 123X012 H CR CC			
		if (Substr(M->B1_FDESCRI,i,3) $ "ABS/MOD/CIL/WEL/HSK/ISO" .and. _nHaste == 0)
			_cTipoFix  := Substr(M->B1_FDESCRI,i,3)
			_nHaste    := Val(Substr(M->B1_FDESCRI,i+4,4))     // Haste
			_nCompri   := Val(Substr(M->B1_FDESCRI,i+8,3))	 // Comprimento
			_cCanal    := Substr(M->B1_FDESCRI,i+12,1)	 	  	 // Canal        
			_cRefrig   := Substr(M->B1_FDESCRI,i+14,2)	     // Refrigeracao 
			_cCobert   := Substr(M->B1_FDESCRI,i+17,2)         // Cobertura   
		Endif

	Next

	@ 200,050 To 700,600 Dialog oDlg Title OemToAnsi("A L A R G A D O R")
	@ 010,020 Say OemToAnsi("Ferramenta") Size 35,8
	@ 010,125 Say OemToAnsi("Tipo") Size 35,8
	@ 025,020 Say OemToAnsi("Material       ") Size 35,8 
	@ 040,020 Say OemToAnsi("Escalonado     ") Size 30,8
	@ 055,020 Say OemToAnsi("Nr. de Cortes  ") Size 35,8
	
	@ 055,125 Say OemToAnsi("Qt.de Escalonado") Size 40,8

	@ 070,020 Say OemToAnsi("Diametro 1     ") Size 35,8
	@ 070,110 Say OemToAnsi("Tolerancia ISO") Size 35,8
	@ 070,190 Say OemToAnsi("L1 ") Size 35,8

	@ 085,020 Say OemToAnsi("Diametro 2     ") Size 35,8
	@ 085,110 Say OemToAnsi("Tolerancia ISO") Size 35,8
	@ 085,190 Say OemToAnsi("L2 ") Size 35,8

	@ 100,020 Say OemToAnsi("Diametro 3     ") Size 35,8
	@ 100,110 Say OemToAnsi("Tolerancia ISO") Size 35,8
	@ 100,190 Say OemToAnsi("L3 ") Size 35,8

	@ 115,020 Say OemToAnsi("Diametro 4     ") Size 35,8
	@ 115,110 Say OemToAnsi("Tolerancia ISO") Size 35,8
	@ 115,190 Say OemToAnsi("L4 ") Size 35,8

	@ 130,020 Say OemToAnsi("Tipo Fixacao   ") Size 35,8

	@ 145,020 Say OemToAnsi("Haste/Flange   ") Size 35,8
	@ 160,020 Say OemToAnsi("Comprimento    ") Size 35,8

	@ 175,020 Say OemToAnsi("Tipo do Canal  ") Size 35,8
	@ 190,020 Say OemToAnsi("Refrigeracao   ") Size 35,8
	@ 205,020 Say OemToAnsi("Cobertura      ") Size 35,8

	@ 009,070 Get _cTipoMat       PICTURE "@!" Size 25,8 When .F. Size 50,8
	@ 009,170 COMBOBOX _cTipoAlar ITEMS _aTipoAlar SIZE 50,10 object oCombo
	@ 024,070 COMBOBOX _cMaterial ITEMS _aMaterial SIZE 50,10 object oCombo
	@ 039,070 COMBOBOX _cEscalon  ITEMS _aEscalon  SIZE 50,10 object oCombo
	@ 054,070 COMBOBOX _cCortes   ITEMS _aCortes   SIZE 50,10 object oCombo

	@ 054,170 Get _nDiaEsc        PICTURE "9"         Size 25,8 Valid(_nDiaEsc >= 1) Size 15,8 
	@ 069,070 Get _nD1            PICTURE "@E 99.999" Size 25,8 Valid(_nD1 >= 0)  When _nDiaEsc >=1 Size 50,8
	@ 069,150 Get _nTolIso1       PICTURE "99"        Size 25,8 Valid(_nTolIso1 >= 1)  When _nDiaEsc >=1 Size 50,8
	@ 069,210 Get _nL1            PICTURE "@E 999.99" Size 25,8 Valid(_nL1 >= 0)  When _nDiaEsc >=1 Size 50,8
		
	@ 084,070 Get _nD2            PICTURE "@E 99.999"  Size 25,8 Valid(_nD2 >= 0)  When (_nDiaEsc >=2 )  Size 50,8
	@ 084,150 Get _nTolIso2       PICTURE "99"        Size 25,8 Valid(_nTolIso2 >= 1)  When _nDiaEsc >=2 Size 50,8
	@ 084,210 Get _nL2            PICTURE "@E 999.99" Size 25,8 Valid(_nL2 >= 0)  When (_nDiaEsc >=2 )  Size 50,8

	@ 099,070 Get _nD3            PICTURE "@E 99.999"  Size 25,8 Valid(_nD3 >= 0)  When (_nDiaEsc >=3 )  Size 50,8
	@ 099,150 Get _nTolIso3       PICTURE "99"        Size 25,8 Valid(_nTolIso3 >= 1)  When _nDiaEsc >=3 Size 50,8
	@ 099,210 Get _nL3            PICTURE "@E 999.99" Size 25,8 Valid(_nL3 >= 0)  When (_nDiaEsc >=3 )  Size 50,8

	@ 114,070 Get _nD4            PICTURE "@E 99.999"  Size 25,8 Valid(_nD4 >= 0)  When (_nDiaEsc >=4 )  Size 50,8
	@ 114,150 Get _nTolIso4       PICTURE "99"        Size 25,8 Valid(_nTolIso4 >= 1)  When _nDiaEsc >=4 Size 50,8
	@ 114,210 Get _nL4            PICTURE "@E 999.99" Size 25,8 Valid(_nL4 >= 0)  When (_nDiaEsc >=4 )   Size 50,8

	@ 129,070 COMBOBOX _cTipoFix  ITEMS _aTipoFix SIZE 50,10 object oCombo		

	@ 144,070 Get _nHaste         PICTURE "@E 999"  Size 25,8 Valid(_nHaste >0) Size 50,8
	@ 159,070 Get _nCompri        PICTURE "@E 999" Size 25,8 Valid(_nCompri >0) Size 50,8

	@ 174,070 COMBOBOX _cCanal    ITEMS _aCanal   SIZE 50,10 object oCombo		
	@ 189,070 COMBOBOX _cRefrig   ITEMS _aRefrig  SIZE 50,10 object oCombo		
	@ 204,070 COMBOBOX _cCobert   ITEMS _aCobert  SIZE 50,10 object oCombo		
		
	@ 220,070 BMPBUTTON TYPE 01 ACTION fGAlargador()
	@ 220,110 BMPBUTTON TYPE 02 ACTION Close(oDlg)

	Activate Dialog oDlg CENTERED

	DbselectArea(_cArq)
	
Return

Static Function fGAlargador()
Local lRet := .T.

	If _nD1 == 0
		Alert("Verifique : Ø da Broca")
		lRet := .F.
	Endif	
	
	If _nL1  == 0
		Alert("Verifique : Comprimento do Escalonado")
		lRet := .F.
	Endif	
	
	If _nHaste == 0
		Alert("Verifique : Ø Haste")
		lRet := .F.
	Endif	
	
	If _nCompri== 0
		Alert("Verifique : Comprimento Total = <Haste + Corpo>")
		lRet := .F.
	Endif	


	If lRet

		// Descricao broca

		M->B1_FDESCRI := _cTipoMat + ' '+_cTipoalar + ' ' + _cMaterial + ' ' + _cEscalon  + ' ' + _cCortes   + ' '
	
		If _nD1 > 0	
	       M->B1_FDESCRI += 'Ø' + fDec23(_nD1) + 'H'+ StrZero(_nTolIso1,2) + 'X' + fDec32(_nL1)
	       //M->B1_FDESCRI += 'Ø' + Transform(_nD1,"99.999") + 'H' + Transform(_nTolIso1,"99") + 'X' + Transform(_nL1,"@R 999.99") 
		Endif
	
		If _nD2 > 0		
	       M->B1_FDESCRI += 'Ø' + fDec23(_nD2) + 'H'+ StrZero(_nTolIso2,2) + 'X' + fDec32(_nL2)
	       //M->B1_FDESCRI += 'Ø' + Transform(_nD2,"@R 99.999") + 'H' + Transform(_nTolIso2,"99") + 'X' + Transform(_nL2,"@R 999.99") 
		Endif
	
		If _nD3 > 0		
	       M->B1_FDESCRI += 'Ø' + fDec23(_nD3) + 'H'+ StrZero(_nTolIso3,2) + 'X' + fDec32(_nL3)		
	       // M->B1_FDESCRI += 'Ø' + Transform(_nD3,"@R 99.999") + 'H' + Transform(_nTolIso3,"99") + 'X' + Transform(_nL3,"@R 999.99") 
		Endif
	
		If _nD4 > 0		
	       M->B1_FDESCRI += 'Ø' + fDec23(_nD4) + 'H'+ StrZero(_nTolIso4,2) + 'X' + fDec32(_nL4)		
	       // M->B1_FDESCRI += 'Ø' + Transform(_nD4,"@R 99.999") + 'H' + Transform(_nTolIso4,"99") + 'X' + Transform(_nL4,"@R 999.99")
		Endif
	
		M->B1_FDESCRI += ' ' + _cTipoFix
		M->B1_FDESCRI += ' ' + StrZero(_nHaste,3)
		M->B1_FDESCRI += 'X' + StrZero(_nCompri,3)
		M->B1_FDESCRI += ' ' + _cCanal
		M->B1_FDESCRI += ' ' + _cRefrig
		M->B1_FDESCRI += ' ' + _cCobert	

	Endif		
	Close(oDlg)
Return(lRet)

Static Function fDec12(_nVlr)
Local _nRet := STRZERO(INT(_nVlr),1) + '.' + SUBSTR(STR(_nVlr,4,2),3,2)
Return(_nRet)


Static Function fDec22(_nVlr)
Local _nRet := STRZERO(INT(_nVlr),2) + '.' + SUBSTR(STR(_nVlr,5,2),4,2)
Return(_nRet)

Static Function fDec23(_nVlr)
Local _nRet := STRZERO(INT(_nVlr),2) + '.' + SUBSTR(STR(_nVlr,6,3),4,3)
Return(_nRet)
 
Static Function fDec32(_nVlr)
Local _nRet := STRZERO(INT(_nVlr),3) + '.' + SUBSTR(STR(_nVlr,6,2),5,2)
Return(_nRet)

//
Static Function _fFresaHaste()

//FR TOPO MDU 02C Ø12.34X567.89Ø98.76X565.32 H32X655 H CR CC

	_cArq      := Select()
	_aTipoMat  := {"FR TOPO","FR ESFE","FR WOOD"}
	_cTipoMat  := Substr(M->B1_FDESCRI,1,7)
	_aMaterial := {"MDU","HSS","PCD","HSE","CER","CMT","CBN"}
	_cMaterial := Substr(M->B1_FDESCRI,9,3)
	_aEscalon  := {"E","L"}
	_cEscalon  := Substr(M->B1_FDESCRI,8,1)
	_aCortes   := {"2C","3C","4C","5C","6C","7C","8C","9C","10C"}
	_cCortes   := Substr(M->B1_FDESCRI,13,3)
	_aCanal    := {"H","R"}
	_cCanal    := Space(01)
	_aRefrig   := {"CR","SR"}
	_cRefrig   := Space(02)
	_aCobert   := {"CC","SC"}
	_cCobert   := Space(02)
	_nHaste    := 0
	_nCompri   := 0		
	_nDiaEsc   := 0		
	_nD1       := 0
	_nL1       := 0
	_nD2       := 0
	_nL2       := 0
	_nD3       := 0
	_nL3       := 0
	_nD4       := 0
	_nL4       := 0
	_nD5       := 0
	_nL5       := 0

	For i := 1 To Len(Alltrim(M->B1_FDESCRI))

		If Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. _nD1 == 0
			_nD1  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
			_nL1 := Val( Substr(M->B1_FDESCRI,i+7,3) + '.' +Substr(M->B1_FDESCRI,i+11,2) ) 
			_nDiaEsc++ 
		Elseif Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. (_nD1 > 0 .and. _nD2 == 0)
			_nD2  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
			_nL2 := Val( Substr(M->B1_FDESCRI,i+7,3) + '.' +Substr(M->B1_FDESCRI,i+11,2) ) 
			_nDiaEsc++   				
		Endif

		if Substr(M->B1_FDESCRI,i,1)=="H" .and. _nHaste == 0 
			_nHaste  := Val(Substr(M->B1_FDESCRI,i+1,2)) // Haste
			_nCompri := Val(Substr(M->B1_FDESCRI,i+4,3)) // Comprimento
			_cCanal  := Substr(M->B1_FDESCRI,i+8,1)	   // Canal        
			_cRefrig := Substr(M->B1_FDESCRI,i+10,2)	   // Refrigeracao 
			_cCobert := Substr(M->B1_FDESCRI,i+13,2)     // Cobertura   
		Endif
	Next

	@ 200,050 To 600,600 Dialog oDlg Title OemToAnsi("F R E S A S   C O M    H A S T E S")

	@ 010,020 Say OemToAnsi("Ferramenta") Size 35,8
	@ 025,020 Say OemToAnsi("Material       ") Size 35,8 
	@ 040,020 Say OemToAnsi("Nr. de Cortes  ") Size 35,8
	@ 040,125 Say OemToAnsi("Qt.de Escalonado") Size 45,8

	@ 055,020 Say OemToAnsi("Diametro 1     ") Size 35,8
	@ 055,150 Say OemToAnsi("L1 ") Size 35,8

	@ 070,020 Say OemToAnsi("Diametro 2     ") Size 35,8
	@ 070,150 Say OemToAnsi("L2 ") Size 35,8

	@ 085,020 Say OemToAnsi("Ø Haste        ") Size 35,8
	@ 100,020 Say OemToAnsi("Comprimento    ") Size 35,8

	@ 115,020 Say OemToAnsi("Tipo do Canal  ") Size 35,8
	@ 130,020 Say OemToAnsi("Refrigeracao   ") Size 35,8
	@ 145,020 Say OemToAnsi("Cobertura      ") Size 35,8

	@ 009,070 COMBOBOX _cTipoMat  ITEMS _aTipoMat  SIZE 50,10 object oCombo
	@ 024,070 COMBOBOX _cMaterial ITEMS _aMaterial SIZE 50,10 object oCombo
	@ 039,070 COMBOBOX _cCortes   ITEMS _aCortes   SIZE 50,10 object oCombo
	@ 039,170 Get _nDiaEsc        PICTURE "9"        Size 25,8 Valid(_nDiaEsc >= 1) Size 15,8 

	@ 054,070 Get _nD1            PICTURE "@E 99.99" Size 25,8 Valid(_nD1 >= 0)  When _nDiaEsc >=1 Size 50,8
	@ 054,170 Get _nL1            PICTURE "@E 999.99" Size 25,8 Valid(_nL1 >= 0)  When (_nDiaEsc >=1 .and. _cEscalon <> 'L') Size 50,8
		
	@ 069,070 Get _nD2            PICTURE "@E 99.99" Size 25,8 Valid(_nD2 >= 0)  When (_nDiaEsc >=2 )  Size 50,8
	@ 069,170 Get _nL2            PICTURE "@E 999.99" Size 25,8 Valid(_nL2 >= 0)  When (_nDiaEsc >=2  .and. _cEscalon <> 'L')  Size 50,8

	@ 084,070 Get _nHaste         PICTURE "@E 99"  Size 25,8 Valid(_nHaste >0) Size 50,8
	@ 099,070 Get _nCompri        PICTURE "@E 999" Size 25,8 Valid(_nCompri >0) Size 50,8

	@ 114,070 COMBOBOX _cCanal    ITEMS _aCanal   SIZE 50,10 object oCombo
	@ 129,070 COMBOBOX _cRefrig   ITEMS _aRefrig  SIZE 50,10 object oCombo
	@ 144,070 COMBOBOX _cCobert   ITEMS _aCobert  SIZE 50,10 object oCombo
		
	@ 160,070 BMPBUTTON TYPE 01 ACTION fGFresHas()
	@ 160,110 BMPBUTTON TYPE 02 ACTION Close(oDlg)

	Activate Dialog oDlg CENTERED

	DbselectArea(_cArq)
	
Return

Static Function fGFresHas()
Local lRet := .T.

	If _nD1 == 0
		Alert("Verifique : Ø da Broca")
		lRet := .F.
	Endif	
	
	If (_nL1  == 0  .and. _cEscalon == 'E')
		Alert("Verifique : Comprimento do Escalonado")
		lRet := .F.
	Endif	
	
	If _nHaste == 0
		Alert("Verifique : Ø Haste")
		lRet := .F.
	Endif	
	
	If _nCompri== 0
		Alert("Verifique : Comprimento Total = <Haste + Corpo>")
		lRet := .F.
	Endif	

	If lRet

		// Descricao broca
		M->B1_FDESCRI := _cTipoMat  + ' ' + _cMaterial +' ' + StrZero(Val(Substr(_cCortes,1,1)),2)+'C'+ ' '

		If _nD1 > 0	
	       M->B1_FDESCRI += 'Ø' + fDec22(_nD1) + 'X'+ fDec32(_nL1)
	       // M->B1_FDESCRI += 'Ø' + Transform(_nD1,"@E 99.99") + 'X' + Transform(_nL1,"@E 999.99") 
		Endif
		If _nD2 > 0		
	       M->B1_FDESCRI += 'Ø' + fDec22(_nD2) + 'X'+ fDec32(_nL2)
		   // M->B1_FDESCRI += 'Ø' + Transform(_nD2,"@E 99.99") + 'X' + Transform(_nL2,"@E 999.99")
		Endif

		M->B1_FDESCRI += ' H' + StrZero(_nHaste,2)
		M->B1_FDESCRI += 'X' + StrZero(_nCompri,3)
		M->B1_FDESCRI += ' ' + _cCanal
		M->B1_FDESCRI += ' ' + _cRefrig
		M->B1_FDESCRI += ' ' + _cCobert	

	Endif		
	Close(oDlg)
Return(lRet)


Static Function _fFresaDisco()

//FR DISC HSE 63C Ø33.33XØ56.78X55.66 CC

	_cArq      := Select()
	_aTipoMat  := {"FR DISC"}
	_cTipoMat  := Substr(M->B1_FDESCRI,1,7)
	_aMaterial := {"MDU","HSS","HSE","MDS"}
	_cMaterial := Substr(M->B1_FDESCRI,9,3)
	_nDentes   := Val(Substr(M->B1_FDESCRI,13,2))
	_aCobert   := {"CC","SC"}
	_cCobert   := Substr(M->B1_FDESCRI,37,2)
	_nHaste    := 0
	_nCompri   := 0		
	_nDiaEsc   := 0		
	_nD1       := 0
	_nL1       := 0
	_nD2       := 0
	_nL2       := 0
	_nD3       := 0
	_nL3       := 0
	_nD4       := 0
	_nL4       := 0
	_nD5       := 0
	_nL5       := 0

	For i := 1 To Len(Alltrim(M->B1_FDESCRI))

		If Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. _nD1 == 0
			_nD1  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
			_nL1  := Val( Substr(M->B1_FDESCRI,i+8,2) + '.' +Substr(M->B1_FDESCRI,i+11,2) ) 
		Elseif Substr(M->B1_FDESCRI,i,1)=="X" .AND. (_nD1 > 0 .and. _nD2 == 0)
			_nD2     := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
		Endif

	Next

	@ 200,050 To 500,600 Dialog oDlg Title OemToAnsi("F R E S A S   D I S C O")

	@ 010,020 Say OemToAnsi("Ferramenta") Size 35,8
	@ 025,020 Say OemToAnsi("Material       ") Size 35,8 
	@ 040,020 Say OemToAnsi("Nr. de Dentes  ") Size 35,8

	@ 055,020 Say OemToAnsi("Ø Externo    ") Size 35,8
	@ 055,140 Say OemToAnsi("Ø Interno    ") Size 35,8
	@ 070,020 Say OemToAnsi("Espessura    ") Size 35,8
	@ 085,020 Say OemToAnsi("Cobertura      ") Size 35,8

	@ 009,070 COMBOBOX _cTipoMat  ITEMS _aTipoMat  SIZE 50,10 object oCombo
	@ 024,070 COMBOBOX _cMaterial ITEMS _aMaterial SIZE 50,10 object oCombo
	@ 039,070 Get _nDentes        PICTURE "@E 99" Size 25,8 

	@ 054,070 Get _nD1            PICTURE "@E 99.99" Size 25,8 Valid(_nD1 >= 0)  Size 50,8
	@ 054,170 Get _nL1            PICTURE "@E 99.99" Size 25,8 Valid(_nL1 >= 0)  Size 50,8
		
	@ 069,070 Get _nD2            PICTURE "@E 99.99" Size 25,8 Valid(_nD2 >= 0)  Size 50,8

	@ 084,070 COMBOBOX _cCobert   ITEMS _aCobert  SIZE 50,10 object oCombo
		
	@ 110,070 BMPBUTTON TYPE 01 ACTION fGFresDis()
	@ 110,110 BMPBUTTON TYPE 02 ACTION Close(oDlg)

	Activate Dialog oDlg CENTERED

	DbselectArea(_cArq)
	
Return

Static Function fGFresDis()
Local lRet := .T.

	If _nD1 == 0
		Alert("Verifique : Ø Externo")
		lRet := .F.
	Endif	
	
	If _nL1  == 0  
		Alert("Verifique : Ø Interno")
		lRet := .F.
	Endif	
	
	If _nD2== 0
		Alert("Verifique : Espessura")
		lRet := .F.
	Endif	

	If _nDentes== 0
		Alert("Verifique : Nr. de Dentes")
		lRet := .F.
	Endif	


	If lRet

		// Descricao broca
		M->B1_FDESCRI := _cTipoMat  + ' ' + _cMaterial +' ' + StrZero(_nDentes,2)+'C'+ ' '

		If _nD1 > 0	
	       M->B1_FDESCRI += 'Ø' + fDec22(_nD1) + 'XØ'+ fDec22(_nL1)
	       // M->B1_FDESCRI += 'Ø' + Transform(_nD1,"@E 99.99") + 'X' + Transform(_nL1,"@E 999.99") 
		Endif
		If _nD2 > 0		
	       M->B1_FDESCRI += 'X' + fDec22(_nD2) 
		Endif

		M->B1_FDESCRI += ' ' + _cCobert	

	Endif		
	Close(oDlg)
Return(lRet)

// 
Static Function _fRebaixador()     


// REB MDU L 02C Ø12.34X567.89Ø98.76X543.21 H12X345 H CR SC

	_cArq      := Select()
	_aTipoMat  := {"REB"}
	_cTipoMat  := Substr(M->B1_FDESCRI,1,3)

	_aMaterial := {"MDU","HSS","HSE","MDS","PCD"}
	_cMaterial := Substr(M->B1_FDESCRI,5,3)

	_aEscalon  := {"E","L"}
	_cEscalon  := Substr(M->B1_FDESCRI,9,1)

	_aCortes   := {"2C","3C","4C","5C","6C","7C","8C","9C","10C"}
	_cCortes   := Substr(M->B1_FDESCRI,11,3)

	_aCanal    := {"H","R"}
	_cCanal    := Space(01)

	_aRefrig   := {"CR","SR"}
	_cRefrig   := Space(02)

	_aCobert   := {"CC","SC"}
	_cCobert   := Space(02)

	_nHaste    := 0
	_nCompri   := 0		
	_nDiaEsc   := 0		
	_nD1       := 0
	_nL1       := 0
	_nD2       := 0
	_nL2       := 0
	_nD3       := 0
	_nL3       := 0
	_nD4       := 0
	_nL4       := 0
	_nD5       := 0
	_nL5       := 0

	For i := 1 To Len(Alltrim(M->B1_FDESCRI))

		If Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. _nD1 == 0
			_nD1  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
			_nL1 := Val( Substr(M->B1_FDESCRI,i+7,3) + '.' +Substr(M->B1_FDESCRI,i+11,2) ) 
			_nDiaEsc++ 
		Elseif Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. (_nD1 > 0 .and. _nD2 == 0)
			_nD2  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
			_nL2 := Val( Substr(M->B1_FDESCRI,i+7,3) + '.' +Substr(M->B1_FDESCRI,i+11,2) ) 
			_nDiaEsc++   				
		Endif

		if Substr(M->B1_FDESCRI,i,1)=="H" .and. _nHaste == 0 
			_nHaste  := Val(Substr(M->B1_FDESCRI,i+1,2)) // Haste
			_nCompri := Val(Substr(M->B1_FDESCRI,i+4,3)) // Comprimento
			_cCanal  := Substr(M->B1_FDESCRI,i+8,1)	   // Canal        
			_cRefrig := Substr(M->B1_FDESCRI,i+10,2)	   // Refrigeracao 
			_cCobert := Substr(M->B1_FDESCRI,i+13,2)     // Cobertura   
		Endif
	Next

	@ 200,050 To 600,600 Dialog oDlg Title OemToAnsi("R E B A I X A D O R")

	@ 010,020 Say OemToAnsi("Ferramenta") Size 35,8
	@ 025,020 Say OemToAnsi("Material       ") Size 35,8 
	@ 040,020 Say OemToAnsi("Escalonado     ") Size 30,8
	
	@ 055,020 Say OemToAnsi("Nr. de Cortes  ") Size 35,8
	@ 055,125 Say OemToAnsi("Qt.de Escalonado") Size 45,8

	@ 070,020 Say OemToAnsi("Diametro 1     ") Size 35,8
	@ 070,150 Say OemToAnsi("L1 ") Size 35,8

	@ 085,020 Say OemToAnsi("Diametro 2     ") Size 35,8
	@ 085,150 Say OemToAnsi("L2 ") Size 35,8

	@ 100,020 Say OemToAnsi("Ø Haste        ") Size 35,8
	@ 115,020 Say OemToAnsi("Comprimento    ") Size 35,8

	@ 130,020 Say OemToAnsi("Tipo do Canal  ") Size 35,8
	@ 145,020 Say OemToAnsi("Refrigeracao   ") Size 35,8
	@ 160,020 Say OemToAnsi("Cobertura      ") Size 35,8

	@ 009,070 COMBOBOX _cTipoMat  ITEMS _aTipoMat  SIZE 50,10 object oCombo
	@ 024,070 COMBOBOX _cMaterial ITEMS _aMaterial SIZE 50,10 object oCombo
	@ 039,070 COMBOBOX _cEscalon  ITEMS _aEscalon  SIZE 50,10 object oCombo

	@ 054,070 COMBOBOX _cCortes   ITEMS _aCortes   SIZE 50,10 object oCombo
	@ 054,170 Get _nDiaEsc        PICTURE "9"        Size 25,8 Valid(_nDiaEsc >= 1) Size 15,8 

	@ 069,070 Get _nD1            PICTURE "@E 99.99" Size 25,8 Valid(_nD1 >= 0)  When _nDiaEsc >=1 Size 50,8
	@ 069,170 Get _nL1            PICTURE "@E 999.99" Size 25,8 Valid(_nL1 >= 0)  When (_nDiaEsc >=1 .and. _cEscalon <> 'L') Size 50,8
		
	@ 084,070 Get _nD2            PICTURE "@E 99.99" Size 25,8 Valid(_nD2 >= 0)  When (_nDiaEsc >=2 )  Size 50,8
	@ 084,170 Get _nL2            PICTURE "@E 999.99" Size 25,8 Valid(_nL2 >= 0)  When (_nDiaEsc >=2  .and. _cEscalon <> 'L')  Size 50,8

	@  99,070 Get _nHaste         PICTURE "@E 99"  Size 25,8 Valid(_nHaste >0) Size 50,8
	@ 114,070 Get _nCompri        PICTURE "@E 999" Size 25,8 Valid(_nCompri >0) Size 50,8

	@ 129,070 COMBOBOX _cCanal    ITEMS _aCanal   SIZE 50,10 object oCombo
	@ 144,070 COMBOBOX _cRefrig   ITEMS _aRefrig  SIZE 50,10 object oCombo
	@ 159,070 COMBOBOX _cCobert   ITEMS _aCobert  SIZE 50,10 object oCombo
		
	@ 180,070 BMPBUTTON TYPE 01 ACTION fGRebaix()
	@ 180,110 BMPBUTTON TYPE 02 ACTION Close(oDlg)

	Activate Dialog oDlg CENTERED

	DbselectArea(_cArq)
	
Return

Static Function fGRebaix()
Local lRet := .T.

	If _nD1 == 0
		Alert("Verifique : Ø da Broca")
		lRet := .F.
	Endif	
	
	If (_nL1  == 0  .and. _cEscalon == 'E')
		Alert("Verifique : Comprimento do Escalonado")
		lRet := .F.
	Endif	
	
	If _nHaste == 0
		Alert("Verifique : Ø Haste")
		lRet := .F.
	Endif	
	
	If _nCompri== 0
		Alert("Verifique : Comprimento Total = <Haste + Corpo>")
		lRet := .F.
	Endif	

	If lRet

		// Descricao broca
		M->B1_FDESCRI := _cTipoMat  + ' ' + _cMaterial + ' ' + _cEscalon + ' ' + StrZero(Val(Substr(_cCortes,1,1)),2)+'C'+ ' '

		If _nD1 > 0	
	       M->B1_FDESCRI += 'Ø' + fDec22(_nD1) + 'X'+ fDec32(_nL1)
	       // M->B1_FDESCRI += 'Ø' + Transform(_nD1,"@E 99.99") + 'X' + Transform(_nL1,"@E 999.99") 
		Endif
		If _nD2 > 0		
	       M->B1_FDESCRI += 'Ø' + fDec22(_nD2) + 'X'+ fDec32(_nL2)
		   // M->B1_FDESCRI += 'Ø' + Transform(_nD2,"@E 99.99") + 'X' + Transform(_nL2,"@E 999.99")
		Endif

		M->B1_FDESCRI += ' H' + StrZero(_nHaste,2)
		M->B1_FDESCRI += 'X' + StrZero(_nCompri,3)
		M->B1_FDESCRI += ' ' + _cCanal
		M->B1_FDESCRI += ' ' + _cRefrig
		M->B1_FDESCRI += ' ' + _cCobert	

	Endif		
	Close(oDlg)
Return(lRet)


//
Static Function _fEscareador()
 
//ESC HSS 45º 02C Ø12.12X123.12 H33X123 H SC

	_cArq      := Select()
	_aTipoMat  := {"ESC"}
	_cTipoMat  := Substr(M->B1_FDESCRI,1,3)

	_aMaterial := {"MDU","HSS","HSE","MDS"}
	_cMaterial := Substr(M->B1_FDESCRI,5,3)

	_nAngulo   := Val(Substr(M->B1_FDESCRI,9,2))

	_aCortes   := {"2C","3C","4C","5C","6C","7C","8C","9C","10C"}
	_cCortes   := Alltrim(Str(Val(Substr(M->B1_FDESCRI,13,2))))+'C'

	_aCanal    := {"H","R"}
	_cCanal    := Space(01)

	_aRefrig   := {"CR","SR"}
	_cRefrig   := Space(02)

	_aCobert   := {"CC","SC"}
	_cCobert   := Space(02)

	_nHaste    := 0
	_nCompri   := 0		
	_nDiaEsc   := 0		
	_nD1       := 0
	_nL1       := 0
	_nD2       := 0
	_nL2       := 0
	_nD3       := 0
	_nL3       := 0
	_nD4       := 0
	_nL4       := 0
	_nD5       := 0
	_nL5       := 0

	For i := 1 To Len(Alltrim(M->B1_FDESCRI))

		If Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. _nD1 == 0
			_nD1  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
			_nL1 := Val( Substr(M->B1_FDESCRI,i+7,3) + '.' +Substr(M->B1_FDESCRI,i+11,2) ) 
			_nDiaEsc++ 
		Elseif Substr(M->B1_FDESCRI,i,1)=="Ø" .AND. (_nD1 > 0 .and. _nD2 == 0)
			_nD2  := Val( Substr(M->B1_FDESCRI,i+1,2) + '.' +Substr(M->B1_FDESCRI,i+4,2) )
			_nL2 := Val( Substr(M->B1_FDESCRI,i+7,3) + '.' +Substr(M->B1_FDESCRI,i+11,2) ) 
			_nDiaEsc++   				
		Endif

		if Substr(M->B1_FDESCRI,i,1)=="H" .and. _nHaste == 0 
			_nHaste  := Val(Substr(M->B1_FDESCRI,i+1,2)) // Haste
			_nCompri := Val(Substr(M->B1_FDESCRI,i+4,3)) // Comprimento
			_cCanal  := Substr(M->B1_FDESCRI,i+8,1)	     // Canal
			_cCobert := Substr(M->B1_FDESCRI,i+10,2)     // Cobertura
		Endif
	Next

	@ 200,050 To 550,600 Dialog oDlg Title OemToAnsi("E S C A R E A D O R")

	@ 010,020 Say OemToAnsi("Ferramenta") Size 35,8
	@ 025,020 Say OemToAnsi("Material       ") Size 35,8 
	@ 040,020 Say OemToAnsi("Angulo da Ponta") Size 40,8
	@ 055,020 Say OemToAnsi("Nr. de Cortes  ") Size 35,8

	@ 070,020 Say OemToAnsi("Diametro 1     ") Size 35,8
	@ 070,150 Say OemToAnsi("L1 ") Size 35,8

	@ 085,020 Say OemToAnsi("Ø Haste        ") Size 35,8
	@ 100,020 Say OemToAnsi("Comprimento    ") Size 35,8

	@ 115,020 Say OemToAnsi("Tipo do Canal  ") Size 35,8
	@ 130,020 Say OemToAnsi("Cobertura      ") Size 35,8

	@ 009,070 COMBOBOX _cTipoMat  ITEMS _aTipoMat  SIZE 50,10 object oCombo
	@ 024,070 COMBOBOX _cMaterial ITEMS _aMaterial SIZE 50,10 object oCombo
	@ 039,070 Get _nAngulo PICTURE "99" Size 25,8 Valid(_nAngulo >= 1) Size 15,8 

	@ 054,070 COMBOBOX _cCortes ITEMS _aCortes SIZE 50,10 object oCombo

	@ 069,070 Get _nD1 PICTURE "@E 99.99" Size 25,8 Valid(_nD1 >= 0)  Size 50,8
	@ 069,170 Get _nL1 PICTURE "@E 999.99" Size 25,8 Valid(_nL1 >= 0)  Size 50,8
		
	@ 084,070 Get _nHaste PICTURE "@E 99"  Size 25,8 Valid(_nHaste >0) Size 50,8
	@ 099,070 Get _nCompri PICTURE "@E 999" Size 25,8 Valid(_nCompri >0) Size 50,8

	@ 114,070 COMBOBOX _cCanal ITEMS _aCanal   SIZE 50,10 object oCombo
	@ 129,070 COMBOBOX _cCobert ITEMS _aCobert  SIZE 50,10 object oCombo
		
	@ 150,070 BMPBUTTON TYPE 01 ACTION fGEscar()
	@ 150,110 BMPBUTTON TYPE 02 ACTION Close(oDlg)

	Activate Dialog oDlg CENTERED

	DbselectArea(_cArq)
	
Return

Static Function fGEscar()
Local lRet := .T.

	If _nD1 == 0
		Alert("Verifique : Ø da Broca")
		lRet := .F.
	Endif	
	
	If (_nL1  == 0  .and. _cEscalon == 'E')
		Alert("Verifique : Comprimento do Escalonado")
		lRet := .F.
	Endif	
	
	If _nHaste == 0
		Alert("Verifique : Ø Haste")
		lRet := .F.
	Endif	
	
	If _nCompri== 0
		Alert("Verifique : Comprimento Total = <Haste + Corpo>")
		lRet := .F.
	Endif	

	If lRet
	
		// Descricao broca
		M->B1_FDESCRI := _cTipoMat+' '+_cMaterial+' '+StrZero(_nAngulo,2)+CHR(186)+' '+StrZero(Val(Substr(_cCortes,1,2)),2)+'C'+ ' '
  
		If _nD1 > 0	
	       M->B1_FDESCRI += 'Ø' + fDec22(_nD1) + 'X'+ fDec32(_nL1)
		Endif

		M->B1_FDESCRI += ' H' + StrZero(_nHaste,2)
		M->B1_FDESCRI += 'X' + StrZero(_nCompri,3)
		M->B1_FDESCRI += ' ' + _cCanal
		M->B1_FDESCRI += ' ' + _cCobert	

	Endif		
	Close(oDlg)
Return(lRet)


// Macho metrico
Static Function _fMachoMetr()

	_cArq      := Select()
	_cTipoMat  := "MACHO"
	_aMaterial := {"MDU","HSS","HSE","MDS"}
	_cMaterial := Substr(M->B1_FDESCRI,7,3)
	_aTipoco   := {"C","L"}
	_cTipoco   := Substr(M->B1_FDESCRI,11,1)
	_aCortes   := {"2C","3C","4C","5C"}
	_cCortes   := Substr(M->B1_FDESCRI,13,2)
	_cR1       := Substr(M->B1_FDESCRI,16,4)
	_nP1       := Val(Substr(M->B1_FDESCRI,21,4))
	_cT1       := Substr(M->B1_FDESCRI,26,3)
	_nCompCor  := Val(Substr(M->B1_FDESCRI,38,3))
	_aForma    := {"HE","CR","CH"}
	_cForma    := Substr(M->B1_FDESCRI,42,2)
	_aRefrig   := {"CR","SR"}
	_cRefrig   := Substr(M->B1_FDESCRI,45,2)
	_aCobert   := {"CC","SC"}
	_cCobert   := Substr(M->B1_FDESCRI,48,2)
	_aNorma    := {"DIN371","DIN374","DIN376"}
	_cNorma    := Substr(M->B1_FDESCRI,51,6)
	_nHaste    := Val(Substr(M->B1_FDESCRI,31,2))
	_nCompri   := Val(Substr(M->B1_FDESCRI,34,3))

	@ 200,050 To 700,600 Dialog oDlg Title OemToAnsi("M A C H O   M E T R I C O")
	@ 010,020 Say OemToAnsi("Ferramenta") Size 35,8
	@ 025,020 Say OemToAnsi("Material       ") Size 35,8 
	@ 040,020 Say OemToAnsi("Tipo do Corte  ") Size 30,8
	@ 055,020 Say OemToAnsi("Nr. de Cortes  ") Size 35,8
	
	@ 070,020 Say OemToAnsi("Rosca          ") Size 35,8
	@ 070,110 Say OemToAnsi("Passo da Rosca") Size 40,8
	@ 070,190 Say OemToAnsi("Tolerancia") Size 40,8

	@ 085,020 Say OemToAnsi("Ø Haste        ") Size 35,8
	@ 100,020 Say OemToAnsi("Comprimento    ") Size 35,8
	@ 115,020 Say OemToAnsi("Comp. do Corte ") Size 40,8
	@ 130,020 Say OemToAnsi("Forma de Helice") Size 40,8

	@ 145,020 Say OemToAnsi("Refrigeracao   ") Size 35,8
	@ 160,020 Say OemToAnsi("Cobertura      ") Size 35,8
	@ 175,020 Say OemToAnsi("Norma da Haste ") Size 35,8

	@ 009,070 Get _cTipoMat       PICTURE "@!" Size 25,8 When .F. Size 50,8
	@ 024,070 COMBOBOX _cMaterial ITEMS _aMaterial SIZE 50,10 object oCombo
	@ 039,070 COMBOBOX _cTipoco   ITEMS _aTipoco   SIZE 50,10 object oCombo
	@ 054,070 COMBOBOX _cCortes   ITEMS _aCortes   SIZE 50,10 object oCombo

	@ 069,070 Get _cR1            PICTURE "!!99" Size 25,8 Size 50,8
	@ 069,150 Get _nP1            PICTURE "@E 9.99"  Size 25,8 Valid(_nP1 >= 0)
	@ 069,220 Get _cT1            PICTURE "9!!" Size 25,8 
		
	@ 084,070 Get _nHaste         PICTURE "@E 99"  Size 25,8 Valid(_nHaste >0) Size 50,8
	@ 099,070 Get _nCompri        PICTURE "@E 999" Size 25,8 Valid(_nCompri >0) Size 50,8
	@ 114,070 Get _nCompcor       PICTURE "@E 999" Size 25,8 Valid(_nCompcor >0) Size 50,8

	@ 129,070 COMBOBOX _cForma    ITEMS _aForma    SIZE 50,10 object oCombo	
	@ 144,070 COMBOBOX _cRefrig   ITEMS _aRefrig  SIZE 50,10 object oCombo		
	@ 159,070 COMBOBOX _cCobert   ITEMS _aCobert  SIZE 50,10 object oCombo		
	@ 174,070 COMBOBOX _cNorma    ITEMS _aNorma   SIZE 50,10 object oCombo		

		
	@ 200,070 BMPBUTTON TYPE 01 ACTION fGMachoMetr()
	@ 200,110 BMPBUTTON TYPE 02 ACTION Close(oDlg)

	Activate Dialog oDlg CENTERED

	DbselectArea(_cArq)
	
Return

Static Function  fGMachoMetr()
Local lRet := .T.

	If lRet
		M->B1_FDESCRI := _cTipoMat  + ' ' + _cMaterial + ' ' + _cTipoco  + ' ' + _cCortes   + ' '  + _cR1 + 'X' + fDec12(_nP1)
		M->B1_FDESCRI += ' ' + _cT1
		M->B1_FDESCRI += ' H' + StrZero(_nHaste,2)
		M->B1_FDESCRI += 'X' + StrZero(_nCompri,3)
		M->B1_FDESCRI += ' ' + StrZero(_nCompcor,3)
		M->B1_FDESCRI += ' ' + _cForma
		M->B1_FDESCRI += ' ' + _cRefrig
		M->B1_FDESCRI += ' ' + _cCobert	
		M->B1_FDESCRI += ' ' + _cNorma
	Endif		
	Close(oDlg)
Return(lRet)


// Macho polegada
Static Function _fMachoPol()

	_cArq      := Select()
	_cTipoMat  := "MACHO"

	_aMaterial := {"MDU","HSS","HSE","MDS"}
	_cMaterial := Substr(M->B1_FDESCRI,7,3)

	_cTipoco   := Substr(M->B1_FDESCRI,11,1)
	_aTipoco   := {"C","L"}

	_cCortes   := Substr(M->B1_FDESCRI,13,2)
	_aCortes   := {"2C","3C","4C","5C"}

	_cR1       := Substr(M->B1_FDESCRI,16,2) + Substr(M->B1_FDESCRI,19,2)
	_nP1       := Val(Substr(M->B1_FDESCRI,23,2))
	
	_aF1       := {"NPTF","NPT ","UNC ","UNF ","RP  "}
	_cF1       := Substr(M->B1_FDESCRI,26,4)

	_cT1       := Substr(M->B1_FDESCRI,32,2)
	_aT1       := {"2B","3B"}

	_nCompri   := Val(Substr(M->B1_FDESCRI,39,3))	
	_nCompCor  := Val(Substr(M->B1_FDESCRI,43,3))

	_aForma    := {"HE","CR","CH"}
	_cForma    := Substr(M->B1_FDESCRI,47,2)

	_aRefrig   := {"CR","SR"}
	_cRefrig   := Substr(M->B1_FDESCRI,50,2)

	_aCobert   := {"CC","SC"}
	_cCobert   := Substr(M->B1_FDESCRI,53,2)

	_nHaste    := Val(Substr(M->B1_FDESCRI,36,2))

	@ 200,050 To 660,600 Dialog oDlg Title OemToAnsi("M A C H O   P O L E G A D A")
	@ 010,020 Say OemToAnsi("Ferramenta") Size 35,8
	@ 025,020 Say OemToAnsi("Material       ") Size 35,8 
	@ 040,020 Say OemToAnsi("Tipo do Corte  ") Size 30,8
	@ 055,020 Say OemToAnsi("Nr. de Cortes  ") Size 35,8
	
	@ 070,020 Say OemToAnsi("Rosca          ") Size 35,8
	@ 070,110 Say OemToAnsi("Passo da Rosca ") Size 40,8
	@ 070,185 Say OemToAnsi("Formato Rosca  ") Size 40,8

	@ 085,020 Say OemToAnsi("Tolerancia     ") Size 35,8

	@ 100,020 Say OemToAnsi("Ø Haste        ") Size 35,8
	@ 115,020 Say OemToAnsi("Comprimento    ") Size 35,8
	@ 130,020 Say OemToAnsi("Comp. do Corte ") Size 40,8
	@ 145,020 Say OemToAnsi("Forma de Helice") Size 40,8
	@ 160,020 Say OemToAnsi("Refrigeracao   ") Size 35,8
	@ 175,020 Say OemToAnsi("Cobertura      ") Size 35,8

	@ 009,070 Get _cTipoMat       PICTURE "@!" Size 25,8 When .F. Size 50,8
	@ 024,070 COMBOBOX _cMaterial ITEMS _aMaterial SIZE 50,10 object oCombo
	@ 039,070 COMBOBOX _cTipoco   ITEMS _aTipoco   SIZE 50,10 object oCombo
	@ 054,070 COMBOBOX _cCortes   ITEMS _aCortes   SIZE 50,10 object oCombo

	@ 069,070 Get _cR1            PICTURE "@R 99/99" Size 25,8 
	@ 069,150 Get _nP1            PICTURE "99"  Size 25,8 Valid(_nP1 >= 0)
	@ 069,225 COMBOBOX _cF1       ITEMS _aF1   SIZE 50,10 object oCombo
	@ 084,070 COMBOBOX _cT1       ITEMS _aT1   SIZE 50,10 object oCombo
			
	@ 099,070 Get _nHaste         PICTURE "@E 99"  Size 25,8 Valid(_nHaste >0) Size 50,8
	@ 114,070 Get _nCompri        PICTURE "@E 999" Size 25,8 Valid(_nCompri >0) Size 50,8
	@ 129,070 Get _nCompcor       PICTURE "@E 999" Size 25,8 Valid(_nCompcor >0) Size 50,8

	@ 144,070 COMBOBOX _cForma    ITEMS _aForma    SIZE 50,10 object oCombo	
	@ 159,070 COMBOBOX _cRefrig   ITEMS _aRefrig  SIZE 50,10 object oCombo		
	@ 174,070 COMBOBOX _cCobert   ITEMS _aCobert  SIZE 50,10 object oCombo		
		
	@ 200,070 BMPBUTTON TYPE 01 ACTION fGMachoPol()
	@ 200,110 BMPBUTTON TYPE 02 ACTION Close(oDlg)

	Activate Dialog oDlg CENTERED

	DbselectArea(_cArq)
	
Return

Static Function  fGMachoPol()
Local lRet := .T.
	If lRet
		M->B1_FDESCRI := _cTipoMat  + ' ' + _cMaterial + ' ' + _cTipoco  + ' ' + _cCortes   + ' '  + Transform(_cR1,"@r 99/99")+ '"X' + StrZero(_nP1,2)
		M->B1_FDESCRI += ' ' + Alltrim(_cF1)+Space(4-Len(Alltrim(_cF1))) + ' ' + ' ' + _cT1
		M->B1_FDESCRI += ' H' + StrZero(_nHaste,2)
		M->B1_FDESCRI += 'X' + StrZero(_nCompri,3)
		M->B1_FDESCRI += ' ' + StrZero(_nCompcor,3)
		M->B1_FDESCRI += ' ' + _cForma
		M->B1_FDESCRI += ' ' + _cRefrig
		M->B1_FDESCRI += ' ' + _cCobert	
	Endif		
	Close(oDlg)
Return(lRet)
