#INCLUDE "PROTHEUS.CH"
          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ AJUSTSPIS ³ Autor ³ Sergio Silveira       ³ Data ³06/11/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta referencia de impostos para o PIS / Pasep           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±       
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Ajustpis()         

Local aCbx       := {} 

Local	cCpoBaseD1 := ""
Local	cCpoAliqD1 := ""
Local	cCpoValD1  := ""
Local	cVldBaseD1 := ""
Local	cVldAliqD1 := ""
Local	cVldValD1  := ""
Local	cCpoBaseF1 := ""
Local	cCpoAliqF1 := ""
Local	cCpoValF1  := ""
Local	cVldBaseF1 := ""
Local	cVldAliqF1 := ""
Local	cVldValF1  := ""

Local cModelo    := ""
Local cCbx       := ""

Local lOk1       := .F. 
Local lOk2       := .F. 
Local lOk3       := .F. 
Local lOk4       := .F. 

Local lContinua  := .T. 
Local l2Continua := .T. 

Local nModelo    := 1 
Local nOpca      := 0

Local oDlg
Local oCombo 
Local oBold
Local oBmp          
Local oCbx                  

SX3->( dbSetOrder( 1 ) ) 

If SX3->( dbSeek( "SD1" ) ) 
	While !SX3->( Eof() ) .And. SX3->X3_ARQUIVO == "SD1" 
		If '"IT_BASEPS2"' $ SX3->X3_VALID .Or. '"IT_ALIQPS2"' $ SX3->X3_VALID .Or. '"IT_VALPS2"' $ SX3->X3_VALID
			lContinua := .F. 			
		EndIf 
		SX3->( dbskip() ) 
	EndDo
EndIf 		          

If SX3->( dbSeek( "SD2" ) ) 
	While !SX3->( Eof() ) .And. SX3->X3_ARQUIVO == "SD2" 
		If '"IT_BASEPS2"' $ SX3->X3_VALID .Or. '"IT_ALIQPS2"' $ SX3->X3_VALID .Or. '"IT_VALPS2"' $ SX3->X3_VALID
			l2Continua := .F.
		EndIf 
		SX3->( dbskip() ) 
	EndDo
EndIf 		          
If lContinua 
	If SX3->( dbSeek( "SF1" ) ) 
		While !SX3->( Eof() ) .And. SX3->X3_ARQUIVO == "SF1" 
			If '"NF_BASEPS2"' $ SX3->X3_VALID .Or. '"NF_ALIQPS2"' $ SX3->X3_VALID .Or. '"NF_VALPS2"' $ SX3->X3_VALID
				lContinua := .F. 			
			EndIf 
			SX3->( dbskip() ) 
		EndDo
	EndIf 		          
EndIf 	
If l2Continua 
	If SX3->( dbSeek( "SF2" ) ) 
		While !SX3->( Eof() ) .And. SX3->X3_ARQUIVO == "SF2" 
			If '"NF_BASEPS2"' $ SX3->X3_VALID .Or. '"NF_ALIQPS2"' $ SX3->X3_VALID .Or. '"NF_VALPS2"' $ SX3->X3_VALID
				l2Continua := .F.
			EndIf 
			SX3->( dbskip() ) 
		EndDo
	EndIf 		          
EndIf 	

If lContinua .Or. l2Continua

	AAdd( aCbx, "Grupo 1" )  
	AAdd( aCbx, "Grupo 2" )  
	AAdd( aCbx, "Grupo 3" )  
	AAdd( aCbx, "Grupo 4" )  
	AAdd( aCbx, "Grupo 5" )  
	AAdd( aCbx, "Grupo 6 - Recomendado" )  
	  
	DEFINE MSDIALOG oDlg TITLE "PIS / Pasep - Alteracao do dicionario" FROM 09,0 TO 20,40 OF oMainWnd 
	
	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
	
	@  0, 0 BITMAP oBmp RESNAME "LOGIN" oF oDlg SIZE 40, 1000 NOBORDER WHEN .F. PIXEL 
	
	@ 03, 50 SAY "Grupo de Impostos" FONT oBold PIXEL
	
	@ 14, 40 TO 16 ,400 LABEL '' OF oDlg   PIXEL
	
	@ 030, 50 SAY "Grupo" of oDlg PIXEL 
	
	@ 039, 50 MSCOMBOBOX oCbx VAR cCbx ITEMS aCbx SIZE 065, 65 OF oDlg PIXEL ON CHANGE nModelo := oCbx:nAt 
	
	DEFINE SBUTTON oBut1 FROM 047, 124 TYPE 2 ACTION ( nOpca := 0, oDlg:End() )  ENABLE of oDlg
	DEFINE SBUTTON oBut2 FROM 062, 124 TYPE 1 ACTION ( nOpca := 1, oDlg:End() )  ENABLE of oDlg
	
	ACTIVATE MSDIALOG oDlg CENTERED  
	
	If nOpca == 1                     
	
		cGrupo := Str( nModelo, 1 ) 
	
		cCpoBaseD1 := "D1_BASIMP" + cGrupo
		cCpoAliqD1 := "D1_ALQIMP" + cGrupo
		cCpoValD1  := "D1_VALIMP"  + cGrupo
		
		cVldBaseD1 := 'MaFisRef("IT_BASEPS2","MT100",M->'+ cCpoBaseD1 + ')' 
		cVldAliqD1 := 'MaFisRef("IT_ALIQPS2","MT100",M->'+ cCpoAliqD1 + ')' 
		cVldValD1  := 'MaFisRef("IT_VALPS2","MT100",M->' + cCpoValD1  + ')' 
		
		SX3->( dbSetOrder( 2 ) ) 
		If SX3->( dbSeek( cCpoBaseD1 ) ) 
			RecLock( "SX3" ) 
			SX3->X3_VALID := cVldBaseD1
			SX3->( MsUnLock() ) 		
			lOk1 := .T. 
		EndIf 		
		
		SX3->( dbSetOrder( 2 ) ) 
		If SX3->( dbSeek( cCpoAliqD1 ) ) 
			RecLock( "SX3" ) 
			SX3->X3_VALID := cVldAliqD1
			SX3->( MsUnLock() ) 		
		EndIf 		
			
		SX3->( dbSetOrder( 2 ) ) 
		If SX3->( dbSeek( cCpoValD1 ) ) 
			RecLock( "SX3" ) 
			SX3->X3_VALID := cVldValD1 
			SX3->( MsUnLock() ) 		
			lOk2 := .T. 		
		EndIf  
		
		cCpoBaseF1 := "F1_BASIMP" + cGrupo
		cCpoAliqF1 := "F1_ALQIMP" + cGrupo
		cCpoValF1  := "F1_VALIMP"  + cGrupo
		
		cVldBaseF1 := 'MaFisRef("NF_BASEPS2","MT100",M->'+ cCpoBaseF1 + ')' 
		cVldAliqF1 := 'MaFisRef("NF_ALIQPS2","MT100",M->'+ cCpoAliqF1 + ')' 
		cVldValF1  := 'MaFisRef("NF_VALPS2","MT100",M->' + cCpoValF1  + ')' 
		
		SX3->( dbSetOrder( 2 ) ) 
		If SX3->( dbSeek( cCpoBaseF1 ) ) 
			RecLock( "SX3" ) 
			SX3->X3_VALID := cVldBaseF1
			SX3->( MsUnLock() ) 		
			lOk3 := .T. 
		EndIf 		
		
		SX3->( dbSetOrder( 2 ) ) 
		If SX3->( dbSeek( cCpoAliqF1 ) ) 
			RecLock( "SX3" ) 
			SX3->X3_VALID := cVldAliqF1
			SX3->( MsUnLock() ) 		
		EndIf 		
			
		SX3->( dbSetOrder( 2 ) ) 
		If SX3->( dbSeek( cCpoValF1 ) ) 
			RecLock( "SX3" ) 
			SX3->X3_VALID := cVldValF1 
			SX3->( MsUnLock() ) 		
			lOk4 := .T. 		
		EndIf  

		cCpoBaseD2 := "D2_BASIMP" + cGrupo
		cCpoAliqD2 := "D2_ALQIMP" + cGrupo
		cCpoValD2  := "D2_VALIMP"  + cGrupo
		
		cVldBaseD2 := 'MaFisRef("IT_BASEPS2","MT100",M->'+ cCpoBaseD2 + ')' 
		cVldAliqD2 := 'MaFisRef("IT_ALIQPS2","MT100",M->'+ cCpoAliqD2 + ')' 
		cVldValD2  := 'MaFisRef("IT_VALPS2","MT100",M->' + cCpoValD2  + ')' 
		
		SX3->( dbSetOrder( 2 ) ) 
		If SX3->( dbSeek( cCpoBaseD2 ) ) 
			RecLock( "SX3" ) 
			SX3->X3_VALID := cVldBaseD2
			SX3->( MsUnLock() ) 		
			lOk1 := .T. 
		EndIf 		
		
		SX3->( dbSetOrder( 2 ) ) 
		If SX3->( dbSeek( cCpoAliqD2 ) ) 
			RecLock( "SX3" ) 
			SX3->X3_VALID := cVldAliqD2
			SX3->( MsUnLock() ) 		
		EndIf 		
			
		SX3->( dbSetOrder( 2 ) ) 
		If SX3->( dbSeek( cCpoValD2 ) ) 
			RecLock( "SX3" ) 
			SX3->X3_VALID := cVldValD2 
			SX3->( MsUnLock() ) 		
			lOk2 := .T. 		
		EndIf  
		
		cCpoBaseF2 := "F2_BASIMP" + cGrupo
		cCpoAliqF2 := "F2_ALQIMP" + cGrupo
		cCpoValF2  := "F2_VALIMP"  + cGrupo
		
		cVldBaseF2 := 'MaFisRef("NF_BASEPS2","MT100",M->'+ cCpoBaseF2 + ')' 
		cVldAliqF2 := 'MaFisRef("NF_ALIQPS2","MT100",M->'+ cCpoAliqF2 + ')' 
		cVldValF2  := 'MaFisRef("NF_VALPS2","MT100",M->' + cCpoValF2  + ')' 
		
		SX3->( dbSetOrder( 2 ) ) 
		If SX3->( dbSeek( cCpoBaseF2 ) ) 
			RecLock( "SX3" ) 
			SX3->X3_VALID := cVldBaseF2
			SX3->( MsUnLock() ) 		
			lOk3 := .T. 
		EndIf 		
		
		SX3->( dbSetOrder( 2 ) ) 
		If SX3->( dbSeek( cCpoAliqF2 ) ) 
			RecLock( "SX3" ) 
			SX3->X3_VALID := cVldAliqF2
			SX3->( MsUnLock() ) 		
		EndIf 		
			
		SX3->( dbSetOrder( 2 ) ) 
		If SX3->( dbSeek( cCpoValF2 ) ) 
			RecLock( "SX3" ) 
			SX3->X3_VALID := cVldValF2 
			SX3->( MsUnLock() ) 		
			lOk4 := .T. 		
		EndIf  
		If lOk1 .And. lOk2 .And. lOk3 .And. lOk4
			Aviso( "Atencao", "Referencias atualizadas com sucesso !", { "Ok" }, 2 ) 
		Else
			Aviso( "Atencao", "Nao foi possivel atualizar as referencias !", { "Ok" }, 2 ) 	
		EndIf 		
	
	EndIf 
	
Else

	Aviso( "Atencao !", "Ja existem referencias de PIS/Pasep registradas na base ! Impossivel continuar !", { "Ok" }, 2 )

EndIf 
	
Return()

