/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHQDO001  ºAutor  ³Marcos R. Roquitski º Data ³  03/18/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Geração Automatica do Nr. do Documento.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Controle de Documentos.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function NhQdo001(_pInclui)
	SetPrvt("cCodDoc,nSeq,cNovoCodigo,nRecno,nOrder,nTipoCod,_nTamtp,i,_cCodMont,_lMont")

	If !Empty(_pInclui) .and. _pInclui == 1
		Return(.T.)

	Endif

	DbSelectArea("QDH")
	nRecno   := QDH->(RECNO())
	nOrder   := QDH->(IndexOrd())
	nSeq     := 0
	cNovoCod := Space(16)
	cCodDoc  := Space(16)
	nTipoCod := 0

	If SM0->M0_CODIGO == 'NH' // WHB USINAGEM
		
		If Substr(M->QDH_CODTP,1,2) == "DD"
			If !Empty(Substr(M->QDH_PRODUT,3,2))
		    	cCodDoc  := Substr(M->QDH_CODTP,1,2) + Substr(M->QDH_PRODUT,3,2) + Substr(M->QDH_PRODUT,8,3)
			Else
		         cCoddoc := Space(10)
			Endif
			// cCodDoc := "DD00210" // Definido pela Depto. da Qualidade variavael fixa.
			nTipoCod := 3

		Elseif Substr(M->QDH_CODTP,1,2) == "NT" .OR. Substr(M->QDH_CODTP,1,2) == "DM" .OR. ; 
		   		Substr(M->QDH_CODTP,1,2) == "QM" .OR. Substr(M->QDH_CODTP,1,2) == "SG"
		    	cCodDoc  := Substr(M->QDH_CODTP,1,2) + "00"

		Elseif Substr(M->QDH_CODTP,1,2) == "FP" .Or. Substr(M->QDH_CODTP,1,2) == "FM" .Or. ;
	           Substr(M->QDH_CODTP,1,2) == "IT" .Or. Substr(M->QDH_CODTP,1,2) == "TB" .Or. ;
	           Substr(M->QDH_CODTP,1,2) == "PR" .OR. Substr(M->QDH_CODTP,1,2) == "LV" .Or. ;
	           Substr(M->QDH_CODTP,1,2) == "MQ" .OR. Substr(M->QDH_CODTP,1,2) == "DG" .Or. ;
		       Substr(M->QDH_CODTP,1,2) == "ET" .OR. Substr(M->QDH_CODTP,1,2) == "IA" .or. ;
			   Substr(M->QDH_CODTP,1,2) == "IS"	

			If !Empty(M->QDH_AREA)
				If M->QDH_AREA == '09'
					cCodDoc  := Substr(M->QDH_CODTP,1,2) + M->QDH_AREA + M->QDH_SUBPRO
					nTipoCod := 3
				Else
					cCodDoc  := Substr(M->QDH_CODTP,1,2) + M->QDH_AREA
				Endif	
			Else
				cCoddoc := Space(10)
			Endif


		Elseif Substr(M->QDH_CODTP,1,2) == "CD" .or. Substr(M->QDH_CODTP,1,2) == "CM"
			cCodDoc  := Substr(M->QDH_CODTP,1,2) + M->QDH_AREA
		
		Elseif Substr(M->QDH_CODTP,1,2) == "DB"
			cCodDoc  := Substr(M->QDH_CODTP,1,2) + "91"

		Elseif Substr(M->QDH_CODTP,1,2) == "DU"  .OR. Substr(M->QDH_CODTP,1,2) == "DM"
			If !Empty(Substr(M->QDH_PRODUT,1,4))
		    	cCodDoc  := Substr(M->QDH_CODTP,1,2) + Substr(M->QDH_PRODUT,1,4)
		   	 	nTipoCod := 1
			Else
		         cCoddoc := Space(10)
			Endif

		Elseif Substr(M->QDH_CODTP,1,2) == "DI"
			If !Empty(Substr(M->QDH_INSTR,1,6))
				cCodDoc  := Substr(M->QDH_CODTP,1,2) + "00" + Substr(M->QDH_INSTR,1,6)
	     		nTipoCod := 2
			Else
				cCoddoc := Space(10)		
			Endif			

		Elseif Substr(M->QDH_CODTP,1,2) == "CR"
	    	cCodDoc  := Substr(M->QDH_CODTP,1,2) + Substr(M->QDH_PRODUT,3,2)


		Elseif Substr(M->QDH_CODTP,1,2) == "FB"
	    	cCodDoc  := Substr(M->QDH_CODTP,1,2) + Substr(M->QDH_PRODUT,3,2)+Alltrim(Substr(M->QDH_PRODUT,6,8))
	   	 	nTipoCod := 4

		Else

			If !Empty(Substr(M->QDH_PRODUT,3,2))
				cCodDoc  := Substr(M->QDH_CODTP,1,2) + Substr(M->QDH_PRODUT,3,2)
				If 	Substr(M->QDH_CODTP,1,2) == 'PF'
					cCodDoc  := 'PC' + Substr(M->QDH_PRODUT,3,2)					
				Endif	
			Else
				cCoddoc := Space(10)
			Endif
		Endif
	    	
		QDH->(DbSetOrder(1)) //FILIAL+DOCUMENTO+REVISAO
		QDH->(DbSeek(xFilial("QDH")+cCodDoc)) // Posicionar no grupo
		If nTipoCod == 0
		   While !EOF() .AND. Substr(QDH->QDH_DOCTO,1,4) == cCodDoc
	   	      nSeq := Val(Substr(QDH->QDH_DOCTO,5,6))
		      QDH->(Dbskip())
		   Enddo
		   If !Empty(cCodDoc)
		      cNovoCod := cCodDoc + StrZero(nSeq+1,6)+SPACE(06)  // Pega o Proximo Codigo
		   Endif

		Elseif nTipoCod == 1
		   While !EOF() .AND. Substr(QDH->QDH_DOCTO,1,6) == cCodDoc
	          nSeq := Val(Substr(QDH->QDH_DOCTO,7,4))
		      QDH->(Dbskip())
		   Enddo
	       If !Empty(cCodDoc)
		      cNovoCod := cCodDoc + StrZero(nSeq+1,4)+SPACE(06)  // Pega o Proximo Codigo
		   Endif

		Elseif nTipoCod == 2
	       cNovoCod := cCodDoc + Space(06)

		Elseif nTipoCod == 3
		   While !EOF() .AND. Substr(QDH->QDH_DOCTO,1,7) == cCodDoc
	          nSeq := Val(Substr(QDH->QDH_DOCTO,8,3))
		      QDH->(Dbskip())
		   Enddo
	       If !Empty(cCodDoc)
		      cNovoCod := cCodDoc + StrZero(nSeq+1,3)+SPACE(05)  // Pega o Proximo Codigo
		   Endif

		Elseif nTipoCod == 4
	       cNovoCod := cCodDoc 

		Endif

		If Substr(cNovoCod,1,2) == 'PF'
			cNovoCod := 'PC' + Alltrim(Substr(cNovoCod,3,14))

		Endif
		M->QDH_DOCTO := cNovoCod

		DbSelectarea("QDH")
		QDH->(DbSetOrder(nOrder))
		QDH->(Dbgoto(nRecno))


	Elseif SM0->M0_CODIGO == 'FN' // WHB FUNDICAO
		_cCodMont := ""
		If Alltrim(M->QDH_CODTP) $ 'ETP.FU/ETP.MO/ETP.AM/ETP.MA/ETP.PT/ETP.KW'
			cCodDoc := Alltrim(M->QDH_CODTP) + "."+ Substr(M->QDH_PRODUT,1,6)
			nTipoCod := 9

		Elseif Alltrim(M->QDH_CODTP) $ 'DC/DD/DW'
			cCodDoc := Alltrim(M->QDH_CODTP) + Substr(M->QDH_PRODUT,4,2) + "."
			nTipoCod := 5

		Elseif Alltrim(M->QDH_CODTP)=='PCUSI' .OR. ;
	  		   Alltrim(M->QDH_CODTP)=='MT-USI' .OR. ;
	  		   Alltrim(M->QDH_CODTP)=='LF-USI' .OR. ;
	  		   Alltrim(M->QDH_CODTP)=='FI-USI'
	  		   
			cCodDoc := Substr(M->QDH_CODTP,1,2) + Substr(M->QDH_PRODUT,4,2) + "."
			nTipoCod := 5

		Elseif Alltrim(M->QDH_CODTP) == 'PC'
			cCodDoc := Alltrim(M->QDH_CODTP) + Substr(M->QDH_PRODUT,1,3) + "."
			nTipoCod := 8
			
		Elseif Alltrim(M->QDH_CODTP) == 'CA'
			cCodDoc := Alltrim(M->QDH_CODTP) + Substr(M->QDH_PRODUT,1,3) + "."
			nTipoCod := 8
			

		Elseif Alltrim(M->QDH_CODTP) == 'FE'
			cCodDoc := Alltrim(M->QDH_CODTP) + Substr(M->QDH_PRODUT,1,5) + "."
			nTipoCod := 4

		Elseif Alltrim(M->QDH_CODTP) == 'PCR'
			cCodDoc := Alltrim(M->QDH_CODTP)+"."+ALLTRIM(M->QDH_SUBPRO) + "."
			nTipoCod := 4

		Elseif Alltrim(M->QDH_CODTP) == 'FM' .OR. ;
		       Alltrim(M->QDH_CODTP) == 'IT' .OR. ; 
		       Alltrim(M->QDH_CODTP) == 'PR' .OR. ; 
		       Alltrim(M->QDH_CODTP) == 'FP' .OR. ; 
		       Alltrim(M->QDH_CODTP) == 'MQ' .OR. ;
		       Alltrim(M->QDH_CODTP) == 'TB' 
		       
			If Alltrim(M->QDH_AREA) == '09' .or. Alltrim(M->QDH_AREA) ==  '05' .or. Alltrim(M->QDH_AREA) ==  '03'
				cCodDoc  := Substr(M->QDH_CODTP,1,2) + Alltrim(M->QDH_AREA) +"."+M->QDH_SUBPRO
				nTipoCod := 4
			Else
				cCodDoc  := Alltrim(M->QDH_CODTP) + Alltrim(M->QDH_AREA) + "."
				nTipoCod := 3
			Endif

		Elseif Alltrim(M->QDH_CODTP) == 'DF'
			cCodDoc  := Alltrim(M->QDH_CODTP) + Alltrim(M->QDH_AREA) + "."
			nTipoCod := 3
 
		Elseif Alltrim(M->QDH_CODTP) == 'DM'
			cCodDoc  := Alltrim(M->QDH_CODTP) + Alltrim(M->QDH_AREA) + "."
			nTipoCod := 3

		Elseif Alltrim(M->QDH_CODTP) == 'FT'
			cCodDoc  := Alltrim(M->QDH_CODTP) + Alltrim(M->QDH_AREA) + "."
			nTipoCod := 3


		Elseif Alltrim(M->QDH_CODTP) == 'ETM'
			cCodDoc  := Alltrim(M->QDH_CODTP) + "." + Alltrim(M->QDH_AREA) + "." 
			nTipoCod := 6

		Elseif Alltrim(M->QDH_CODTP) == 'NT'
			cCodDoc  := Alltrim(M->QDH_CODTP) + "00.000" 
			nTipoCod := 4

		Elseif Alltrim(M->QDH_CODTP) == 'PK'
			cCodDoc  := Alltrim(M->QDH_CODTP) + M->QDH_SUBPROV + "."
			nTipoCod := 7

		Elseif Alltrim(M->QDH_CODTP) == 'FOP'
			cCodDoc  := Alltrim(M->QDH_CODTP) + "."
			nTipoCod := 10

		Elseif Alltrim(M->QDH_CODTP) == 'FIPQ'
			cCodDoc  := Alltrim(M->QDH_CODTP) + "." + Alltrim(M->QDH_AREA) + "." 
			nTipoCod := 11

		Elseif Alltrim(M->QDH_CODTP) == 'PCFRJ'
			cCodDoc  := Alltrim(M->QDH_CODTP) + "."  
			nTipoCod := 12

		Elseif Alltrim(M->QDH_CODTP) == 'MTFRJ'
			cCodDoc  := Alltrim(M->QDH_CODTP) + "."  
			nTipoCod := 12

		Elseif Alltrim(M->QDH_CODTP) == 'MEFRJ'
			cCodDoc  := Alltrim(M->QDH_CODTP) + "."  
			nTipoCod := 12

		Elseif Alltrim(M->QDH_CODTP) == 'PKFRJ'
			cCodDoc  := Alltrim(M->QDH_CODTP) + "."  
			nTipoCod := 12

		Elseif Alltrim(M->QDH_CODTP) $ 'DFFRJ'
			cCodDoc  := Alltrim(M->QDH_CODTP) + Substr(M->QDH_PRODUT,4,2) + "." 
			nTipoCod := 13

		Elseif Alltrim(M->QDH_CODTP) == 'PC-FRJ' //
			cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,2) + Substr(M->QDH_PRODUT,4,2) + "." 
			nTipoCod := 14

		Elseif Alltrim(M->QDH_CODTP) == 'CA-FRJ' //
			cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,2) + Substr(M->QDH_PRODUT,4,2) + "." 
			nTipoCod := 14

		Elseif Alltrim(M->QDH_CODTP) == 'DC-FRJ' //
			cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,2) + Substr(M->QDH_PRODUT,4,2) + "." 
			nTipoCod := 14

		Elseif Alltrim(M->QDH_CODTP) == 'NT-FRJ' //
			cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,2) + Alltrim(M->QDH_AREA) + "." 
			nTipoCod := 14

		Elseif Alltrim(M->QDH_CODTP) == 'PK-USI' //
			cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,2) + Alltrim(M->QDH_AREA) + "." 
			nTipoCod := 14

		Elseif Alltrim(M->QDH_CODTP) == 'ETMFRJ' //
			cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,3) + Alltrim(M->QDH_AREA) + "." 
			nTipoCod := 12

		Elseif Alltrim(M->QDH_CODTP) == 'PP-FRJ' //
			cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,2) + Alltrim(M->QDH_AREA) + "." 
			nTipoCod := 14

		Elseif Alltrim(M->QDH_CODTP) == 'ME-FRJ' //
			cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,2) + Alltrim(M->QDH_AREA) + ".000"
			nTipoCod := 16
			
		Elseif Alltrim(M->QDH_CODTP) == 'FI-FRJ' 
			cCodDoc  := Substr(M->QDH_CODTP,1,2) + Alltrim(M->QDH_AREA) + "." + Alltrim(M->QDH_SUBPRO)
			nTipoCod := 15

		Elseif Alltrim(M->QDH_CODTP) == 'FP-FRJ' 
			cCodDoc  := Substr(M->QDH_CODTP,1,6) + Alltrim(M->QDH_AREA) + "." + Alltrim(M->QDH_SUBPRO)
			nTipoCod := 18

		Elseif Alltrim(M->QDH_CODTP) == 'FM-FRJ' 
			cCodDoc  := Substr(M->QDH_CODTP,1,6) + Alltrim(M->QDH_AREA) + "." + Alltrim(M->QDH_SUBPRO)
			nTipoCod := 18

		Elseif Alltrim(M->QDH_CODTP) == 'IT-FRJ' 
			cCodDoc  := Substr(M->QDH_CODTP,1,6) + Alltrim(M->QDH_AREA) + "." + Alltrim(M->QDH_SUBPRO)
			nTipoCod := 18

		Elseif Alltrim(M->QDH_CODTP) == 'PK-FRJ' 
			cCodDoc  := Substr(M->QDH_CODTP,1,2) + Alltrim(M->QDH_AREA) + "." + Alltrim(M->QDH_SUBPRO)
			nTipoCod := 15

		Elseif Alltrim(M->QDH_CODTP) == 'MT-FRJ' 
			cCodDoc  := Substr(M->QDH_CODTP,1,2) + Alltrim(M->QDH_AREA) + "." + Alltrim(M->QDH_SUBPRO)
			nTipoCod := 15

		Elseif Alltrim(M->QDH_CODTP) == 'MT'
			cCodDoc  := Alltrim(M->QDH_CODTP) + Alltrim(M->QDH_AREA) + "." + Alltrim(M->QDH_SUBPRO)
			nTipoCod := 4

		Elseif Alltrim(M->QDH_CODTP) == 'ME'
			cCodDoc  := Alltrim(M->QDH_CODTP) + Alltrim(M->QDH_AREA) + "." + Alltrim(M->QDH_SUBPRO)
			nTipoCod := 4

		Elseif Alltrim(M->QDH_CODTP) == 'FI'
			cCodDoc  := Alltrim(M->QDH_CODTP) + Alltrim(M->QDH_AREA) + "." + Alltrim(M->QDH_SUBPRO)
			nTipoCod := 4

		Elseif Substr(M->QDH_CODTP,1,2) == "FB"
	    	cCodDoc  := Substr(M->QDH_CODTP,1,2) + Substr(M->QDH_PRODUT,3,2)+"."+Alltrim(Substr(M->QDH_PRODUT,6,8))
	   	 	nTipoCod := 17

		Else
			cCodDoc  := Alltrim(M->QDH_CODTP) + "." + Alltrim(M->QDH_AREA) + "."
			nTipoCod := 0


		Endif


		_nTamtp := Len(Alltrim(M->QDH_CODTP))
		QDH->(DbSetOrder(1)) //FILIAL+DOCUMENTO+REVISAO

		If Alltrim(M->QDH_CODTP) == 'PC-FRJ' //
			QDH->(DbSeek(xFilial("QDH")+Substr(M->QDH_CODTP,1,2)))

		Elseif Alltrim(M->QDH_CODTP) == 'CA-FRJ' //
			QDH->(DbSeek(xFilial("QDH")+Substr(M->QDH_CODTP,1,2)))

		Elseif Alltrim(M->QDH_CODTP) == 'NT-FRJ' //
			QDH->(DbSeek(xFilial("QDH")+Substr(M->QDH_CODTP,1,2)))

		Elseif Alltrim(M->QDH_CODTP) == 'ME-FRJ' //
			QDH->(DbSeek(xFilial("QDH")+Substr(M->QDH_CODTP,1,2)))

		Elseif Alltrim(M->QDH_CODTP) == 'PK-FRJ' //
			QDH->(DbSeek(xFilial("QDH")+Substr(M->QDH_CODTP,1,2)))

		Elseif Alltrim(M->QDH_CODTP) == 'MT-USI' //
			QDH->(DbSeek(xFilial("QDH")+Substr(M->QDH_CODTP,1,2)))

		Elseif Alltrim(M->QDH_CODTP) == 'PCUSI' //
			QDH->(DbSeek(xFilial("QDH")+Substr(M->QDH_CODTP,1,2)))

		Elseif Alltrim(M->QDH_CODTP) == 'LF-USI' //
			QDH->(DbSeek(xFilial("QDH")+Substr(M->QDH_CODTP,1,2)))

		Elseif Alltrim(M->QDH_CODTP) == 'FI-USI' //
			QDH->(DbSeek(xFilial("QDH")+Substr(M->QDH_CODTP,1,2)))

		Elseif Alltrim(M->QDH_CODTP) == 'FI-FRJ' //
			QDH->(DbSeek(xFilial("QDH")+Substr(M->QDH_CODTP,1,2)))

		Elseif Alltrim(M->QDH_CODTP) == 'PK-USI' //
			QDH->(DbSeek(xFilial("QDH")+Substr(M->QDH_CODTP,1,2)))

		Elseif Alltrim(M->QDH_CODTP) == 'MT-FRJ' //
			QDH->(DbSeek(xFilial("QDH")+Substr(M->QDH_CODTP,1,2)))

		Elseif Alltrim(M->QDH_CODTP) == 'DC-FRJ' //
			QDH->(DbSeek(xFilial("QDH")+Substr(M->QDH_CODTP,1,2)))

		Elseif Alltrim(M->QDH_CODTP) == 'PP-FRJ' //
			QDH->(DbSeek(xFilial("QDH")+Substr(M->QDH_CODTP,1,2)))

		Elseif Alltrim(M->QDH_CODTP) == 'ETMFRJ' //
			QDH->(DbSeek(xFilial("QDH")+Substr(cCodDoc,1,5)))

		Else
			QDH->(DbSeek(xFilial("QDH")+Alltrim(M->QDH_CODTP)))		
		Endif
			
		If nTipoCod == 0
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,_nTamtp) == AllTrim(M->QDH_CODTP)
				If Substr(QDH->QDH_DOCTO,1,6) == Alltrim(cCodDoc)
					nSeq := Val(Substr(QDH->QDH_DOCTO,6,6))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,6) // Pega o Proximo Codigo

		Elseif nTipoCod == 3
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,_nTamtp) == AllTrim(M->QDH_CODTP)
				If Substr(QDH->QDH_DOCTO,1, Len(ALLTRIM(QDH->QDH_DOCTO))-6) == Alltrim(cCodDoc)
					nSeq := Val(Substr( QDH->QDH_DOCTO, (Len(ALLTRIM(QDH->QDH_DOCTO)) - 2),3))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,6) // Pega o Proximo Codigo

		Elseif nTipoCod == 4
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,_nTamtp) == AllTrim(M->QDH_CODTP)
				If Substr(QDH->QDH_DOCTO,1,8) == Alltrim(Substr(cCodDoc,1,8))
					nSeq := Val(Substr( QDH->QDH_DOCTO,9,3))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,3) // Pega o Proximo Codigo

		Elseif nTipoCod == 5

			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,2) == SUBSTR(AllTrim(M->QDH_CODTP),1,2)
				If Substr(QDH->QDH_DOCTO,1,4) == Alltrim(Substr(cCodDoc,1,4))
					nSeq := Val(Substr( QDH->QDH_DOCTO,6,6))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,6) // Pega o Proximo Codigo

		Elseif nTipoCod == 6
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,3) == AllTrim(M->QDH_CODTP)
				If Substr(QDH->QDH_DOCTO,1,7) == Alltrim(Substr(cCodDoc,1,7))
					nSeq := Val(Substr( QDH->QDH_DOCTO,8,4))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,4) // Pega o Proximo Codigo

		Elseif nTipoCod == 7
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,_nTamtp) == AllTrim(M->QDH_CODTP)
				If Substr(QDH->QDH_DOCTO,1,6) == Alltrim(Substr(cCodDoc,1,6))
					nSeq := Val(Substr( QDH->QDH_DOCTO,7,5))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,5) // Pega o Proximo Codigo

    	Elseif nTipoCod == 8
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,_nTamtp) == AllTrim(M->QDH_CODTP)
				If Substr(QDH->QDH_DOCTO,1,6) == Alltrim(Substr(cCodDoc,1,6))
					nSeq := Val(Substr( QDH->QDH_DOCTO,7,6))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,6) // Pega o Proximo Codigo

    	Elseif nTipoCod == 9
			QDH->(DbSeek(xFilial("QDH") + Alltrim(Substr(cCodDoc,1,12))))
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,12) == Alltrim(Substr(cCodDoc,1,12))
				If Substr(QDH->QDH_DOCTO,1,12) == Alltrim(Substr(cCodDoc,1,12))
					nSeq := Val(Substr( QDH->QDH_DOCTO,14,3))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,3) // Pega o Proximo Codigo

		Elseif nTipoCod == 10
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,_nTamtp) == AllTrim(M->QDH_CODTP)
				If Substr(QDH->QDH_DOCTO,1,4) == Alltrim(Substr(cCodDoc,1,4))
					nSeq := Val(Substr( QDH->QDH_DOCTO,5,6))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,6) // Pega o Proximo Codigo
        
		Elseif nTipoCod == 11
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,4) == AllTrim(M->QDH_CODTP)
				If Substr(QDH->QDH_DOCTO,1,8) == Alltrim(Substr(cCodDoc,1,8))
					nSeq := Val(Substr( QDH->QDH_DOCTO,9,6))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,6) // Pega o Proximo Codigo

		Elseif nTipoCod == 12
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,5) == Substr(cCoddoc,1,5)
				If Substr(QDH->QDH_DOCTO,1,6) == Alltrim(Substr(cCodDoc,1,6))
					nSeq := Val(Substr( QDH->QDH_DOCTO,7,6))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,6) // Pega o Proximo Codigo

		Elseif nTipoCod == 13
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,5) == AllTrim(M->QDH_CODTP)
				If Substr(QDH->QDH_DOCTO,1,7) == Alltrim(Substr(cCodDoc,1,7))
					nSeq := Val(Substr( QDH->QDH_DOCTO,9,6))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,6) // Pega o Proximo Codigo

		Elseif nTipoCod == 14 
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,2) == Substr(M->QDH_CODTP,1,2)
				If Substr(QDH->QDH_DOCTO,1,4) == Alltrim(Substr(cCodDoc,1,4))
					nSeq := Val(Substr( QDH->QDH_DOCTO,6,6))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,6) // Pega o Proximo Codigo

		Elseif nTipoCod == 15
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,2) == Substr(M->QDH_CODTP,1,2)
				If Substr(QDH->QDH_DOCTO,1,8) == Alltrim(Substr(cCodDoc,1,8))
					nSeq := Val(Substr( QDH->QDH_DOCTO,9,3))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,3) // Pega o Proximo Codigo

		Elseif nTipoCod == 16
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,2) == Substr(M->QDH_CODTP,1,2)
				If Substr(QDH->QDH_DOCTO,1,8) == Alltrim(Substr(cCodDoc,1,8))
					nSeq := Val(Substr( QDH->QDH_DOCTO,9,3))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,3) // Pega o Proximo Codigo


		Elseif nTipoCod == 17
			cNovoCod := cCodDoc


		Elseif nTipoCod == 18
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,6) == Substr(M->QDH_CODTP,1,6)
				If Substr(QDH->QDH_DOCTO,1,12) == Alltrim(Substr(cCodDoc,1,12))
					nSeq := Val(Substr( QDH->QDH_DOCTO,14,3))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,3) // Pega o Proximo Codigo

	   	Endif

		M->QDH_DOCTO := cNovoCod + Space(16-Len(Alltrim(cNovoCod)))
		DbSelectarea("QDH")
		QDH->(DbSetOrder(nOrder))
		QDH->(Dbgoto(nRecno))
	Endif


Return(.T.)   
