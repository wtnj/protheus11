/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST017  ºAutor  ³Marcos R. Roquitski º Data ³  07/05/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtra produtos conforme parametro MV_NHQDO017.            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#Include "rwmake.ch"
#include "topconn.ch"
#include "qdo.ch"

User Function Nhqdo017()
     
Public _cFil1
//Public _aFil1 := {'1=Integrado','2=Fundicao','3=Usinagem','4=Forjaria','5=Virabrequim','6=Fundicao Aluminio','7=Pernambuco','0=Todos'}
Public _aFil1 := {'1=Integrado','2=Fundicao','3=Usinagem','4=Forjaria','5=Virabrequim','6=Fundicao Aluminio','7=Pernambuco'}

   If Upper(cUserName) $ RespArea
		aAdd(_aFil1,'0=Todos')        
	Endif

If SM0->M0_CODIGO == "IT"
	_cFil1 := '0'
	QDOA050()  
Else
	@ 200,050 To 450,400 Dialog oDlg Title OemToAnsi("Empresa")
	
	@ 080,050 To 080,400 
	
	@ 015,010 Say OemToAnsi("Empresa") Size 65,8
	                                                               
	@ 013,050 COMBOBOX _cFil1 ITEMS _aFil1 SIZE 080,10 object oFil1  
			
	@ 100, 70 BMPBUTTON TYPE 01 ACTION QDOA050()
	@ 100,102 BMPBUTTON TYPE 02 ACTION Close(oDlg)
	
	Activate Dialog oDlg CENTERED
Endif 

Return