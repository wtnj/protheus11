/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHQDO018  ºAutor  ³Marcos R. Roquitski º Data ³  18/03/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Geração Automatica do Nr. do Documento.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Controle de Documentos.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "protheus.ch" 
#include "rwmake.ch"

User Function NhQdo018(_pInclui)

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

		Alert(" ** ATENCAO para novos documentos usar empresa FUNDICAO ***")
		Return
		
	Elseif SM0->M0_CODIGO == 'FN' // WHB FUNDICAO

		// Regras: 04/2011 
		
		If Alltrim(M->QDH_CODTP) ==  'CAJ' 
		   cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,3) + Substr(M->QDH_PRODUT,4,2) + "."  + Alltrim(M->QDH_SUBPRO) 
		   nTipoCod := 1                                                                                             

		Elseif Alltrim(M->QDH_CODTP) == 'MQ' .OR. ;
		       Alltrim(M->QDH_CODTP) == 'DG'
		       
			If Alltrim(M->QDH_AREA) == '09' .or. Alltrim(M->QDH_AREA) ==  '05' .or. Alltrim(M->QDH_AREA) ==  '03'
				cCodDoc  := Substr(M->QDH_CODTP,1,2) + Alltrim(M->QDH_AREA) +"."+M->QDH_SUBPRO
				nTipoCod := 4
			Else
				cCodDoc  := Alltrim(M->QDH_CODTP) + Alltrim(M->QDH_AREA) + "."
				nTipoCod := 3
			Endif

		Elseif Alltrim(M->QDH_CODTP) == 'RQ' 
		   cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,2) + "02." 
		   nTipoCod := 3 

		Elseif Alltrim(M->QDH_CODTP) == 'FT' 
		   cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,2) + Alltrim(M->QDH_AREA) + "." 
		   nTipoCod := 3 

		Elseif Alltrim(M->QDH_CODTP) == 'PR' 
		   cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,2) + Alltrim(M->QDH_AREA) + "." 
		   nTipoCod := 3 

		Elseif Alltrim(M->QDH_CODTP) == 'IT' 
		   cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,2) + Alltrim(M->QDH_AREA) + "." 
		   nTipoCod := 3 

		Elseif Alltrim(M->QDH_CODTP) == 'FM'
			cCodDoc  := Alltrim(M->QDH_CODTP) + Alltrim(M->QDH_AREA) + "." + Alltrim(M->QDH_SUBPRO)
			nTipoCod := 4

		Elseif Alltrim(M->QDH_CODTP) == 'ME'
			cCodDoc  := Alltrim(M->QDH_CODTP) + Alltrim(M->QDH_AREA) + "." + Alltrim(M->QDH_SUBPRO)
			nTipoCod := 4

		Elseif Alltrim(M->QDH_CODTP) == 'FP'
			cCodDoc  := Alltrim(M->QDH_CODTP) + Alltrim(M->QDH_AREA) + "." + Alltrim(M->QDH_SUBPRO)
			nTipoCod := 4

		Elseif Alltrim(M->QDH_CODTP) == 'TB' 
		   cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,2) + Alltrim(M->QDH_AREA) + "." + Alltrim(M->QDH_SUBPRO) 
		   nTipoCod := 4 

		Elseif Alltrim(M->QDH_CODTP) $  'DCJ/DFJ/PCJ/FIU/LFU/MTU/PCU/PKU/LFV/PCV/PKV/PKJ/MMU/DCA/PKA'
		   cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,3) + Substr(M->QDH_PRODUT,4,2) + "."
		   nTipoCod := 2

		Elseif Substring(Alltrim(M->QDH_CODTP),1,3) == 'FIU' 
		   cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,3) + Substr(M->QDH_PRODUT,4,2) + "." 
		   nTipoCod := 2 

		Elseif Substring(Alltrim(M->QDH_CODTP),1,3) == 'CAV' 
		   cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,3) + Substr(M->QDH_PRODUT,4,2) + "." 
		   nTipoCod := 2 

		Elseif Substring(Alltrim(M->QDH_CODTP),1,3) == 'FIV' 
		   cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,3) + Substr(M->QDH_PRODUT,4,2) + "." 
		   nTipoCod := 2 

		Elseif Alltrim(M->QDH_CODTP) $  'FIJ/FMJ/FPJ/ITJ/MEJ/MTJ/FIF/MEF/MTF/FPA/MTA' //PCA

			If Alltrim(M->QDH_CODTP) $ 'MTF/MTA/PCA' .and. M->QDH_DTOIE == 'E' 
				cCodDoc := Alltrim(M->QDH_CODTP) + Substr(M->QDH_PRODUT,1,3) + "."
				nTipoCod := 8
			Else	
			   cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,3) + Alltrim(M->QDH_AREA) + "."  + Alltrim(M->QDH_SUBPRO) 
			   nTipoCod := 1 
			Endif 

		Elseif Alltrim(M->QDH_CODTP) $ 'PK/PR/PP' 
		   cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,2) + Alltrim(M->QDH_AREA) + "." 
		   nTipoCod := 3 

		Elseif Alltrim(M->QDH_CODTP) == 'TB' // TB01.001.001 
		   cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,2) + Alltrim(M->QDH_AREA) + "." + Alltrim(M->QDH_SUBPRO) 
		   nTipoCod := 4 

		Elseif Alltrim(M->QDH_CODTP) $ 'DCU/DCF/DCV/MTV' 
		   cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,3) + Substr(M->QDH_PRODUT,4,2) + "." 
		   nTipoCod := 5 

		Elseif Alltrim(M->QDH_CODTP) $ 'DDU/DDV' 
		   cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,3) + Substr(M->QDH_PRODUT,4,2) + "." + Substr(M->QDH_PRODUT,9,4) 
		   nTipoCod := 6 

		Elseif Alltrim(M->QDH_CODTP) $ 'DGU/FMU/FPU/IAU/ITU/MQU/TBU/FMV/FPV/ITV/TBV/TBJ/QDJ/FMA/MEA'
		   cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,3) + Alltrim(M->QDH_AREA) + "." 
		   nTipoCod := 5 

			If Alltrim(M->QDH_AREA) == '09' .AND. Alltrim(M->QDH_CODTP) $ 'FMU/FPU/ITU/TBU' 
				cCodDoc  := Alltrim(M->QDH_CODTP) + Alltrim(M->QDH_AREA) + "." + Alltrim(M->QDH_SUBPRO)
				nTipoCod := 15
			Endif

		Elseif Alltrim(M->QDH_CODTP) == 'DIU'
		   cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,3) + "00." 
		   nTipoCod := 5

		Elseif Alltrim(M->QDH_CODTP) == 'NT'
		   cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,2) + "00." 
		   nTipoCod := 7

		Elseif Alltrim(M->QDH_CODTP) $ 'CAF/PCF/CAA/PVA/FPVA/PCA'
			cCodDoc := Alltrim(M->QDH_CODTP) + Substr(M->QDH_PRODUT,1,3) + "."
			nTipoCod := 8

		Elseif Alltrim(M->QDH_CODTP) $ 'DFF/ISU/PRU/PRJ/DFA'
		   cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,3) + Alltrim(M->QDH_AREA) + "."
		   nTipoCod := 9

		Elseif Alltrim(M->QDH_CODTP) $ 'ETMF/ETMJ/ETMA'
			cCodDoc  := Alltrim(M->QDH_CODTP) + Alltrim(M->QDH_AREA) + "." 
			nTipoCod := 10

		Elseif Alltrim(M->QDH_CODTP) $ 'ETP.FU/ETP.MO/ETP.AM/ETP.MA/ETP.PT/ETP.KW/ETP.PM'
			cCodDoc := Alltrim(M->QDH_CODTP) + "."+ Substr(M->QDH_PRODUT,1,6)
			nTipoCod := 11
			
		Elseif Alltrim(M->QDH_CODTP) == 'FIF'
			cCodDoc  := Alltrim(M->QDH_CODTP) + Alltrim(M->QDH_AREA) + "." + Alltrim(M->QDH_SUBPRO)
			nTipoCod := 4


		Elseif Alltrim(M->QDH_CODTP) $ 'PKF/PCR/PCRA'
			cCodDoc  := Alltrim(M->QDH_CODTP) + M->QDH_SUBPRO + "."
			nTipoCod := 14


		Elseif Alltrim(M->QDH_CODTP) == 'FFJ'
			cCodDoc  := Substr(Alltrim(M->QDH_CODTP),1,1) + M->QDH_PRODUT
			nTipoCod := 0


		Elseif Alltrim(M->QDH_CODTP) == 'FMF' .OR. ;
		       Alltrim(M->QDH_CODTP) == 'ITF' .OR. ; 
		       Alltrim(M->QDH_CODTP) == 'PRF' .OR. ; 
		       Alltrim(M->QDH_CODTP) == 'FPF' .OR. ; 
		       Alltrim(M->QDH_CODTP) == 'TBF' .OR. ;
		       Alltrim(M->QDH_CODTP) == 'ITA' 
		       
			If Alltrim(M->QDH_AREA) == '09' .or. Alltrim(M->QDH_AREA) ==  '05' .or. Alltrim(M->QDH_AREA) ==  '03'
				cCodDoc  := Substr(M->QDH_CODTP,1,3) + Alltrim(M->QDH_AREA) +"."+M->QDH_SUBPRO
				nTipoCod := 12
			Else
				cCodDoc  := Alltrim(M->QDH_CODTP) + Alltrim(M->QDH_AREA) + "."
				nTipoCod := 9
			Endif

		Endif

		_nTamtp := Len(Alltrim(M->QDH_CODTP))
		QDH->(DbSetOrder(1)) //FILIAL+DOCUMENTO+REVISAO
		QDH->(DbSeek(xFilial("QDH")+Alltrim(M->QDH_CODTP)))


		If nTipoCod == 0
			cNovoCod := cCodDoc 
	

		Elseif nTipoCod == 1 
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,_nTamtp) == AllTrim(M->QDH_CODTP)
				If Substr(QDH->QDH_DOCTO,1,9) == Alltrim(cCodDoc)
					nSeq := Val(Substr(QDH->QDH_DOCTO,10,3))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,3) // Pega o Proximo Codigo

		ElseIf nTipoCod == 2
			QDH->(DbSeek(xFilial("QDH")+Substr(M->QDH_CODTP,1,3)))
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,3) == Substr(M->QDH_CODTP,1,3)
				If Substr(QDH->QDH_DOCTO,1,6) == Alltrim(cCodDoc)
					nSeq := Val(Substr(QDH->QDH_DOCTO,7,6))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,6) // Pega o Proximo Codigo
			
		ElseIf nTipoCod == 3
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,_nTamtp) == AllTrim(M->QDH_CODTP)
				If Substr(QDH->QDH_DOCTO,1,5) == Alltrim(cCodDoc)
					nSeq := Val(Substr(QDH->QDH_DOCTO,6,6))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,6) // Pega o Proximo Codigo
			
		ElseIf nTipoCod == 4
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,_nTamtp) == AllTrim(M->QDH_CODTP)
				If Substr(QDH->QDH_DOCTO,1,8) == Alltrim(cCodDoc)
					nSeq := Val(Substr(QDH->QDH_DOCTO,9,3))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,3) // Pega o Proximo Codigo

		Elseif nTipoCod == 5

			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,3) == SUBSTR(AllTrim(M->QDH_CODTP),1,3)
				If Substr(QDH->QDH_DOCTO,1,5) == Alltrim(Substr(cCodDoc,1,5))
					nSeq := Val(Substr( QDH->QDH_DOCTO,7,6))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,6) // Pega o Proximo Codigo

		Elseif nTipoCod == 6

			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,3) == SUBSTR(AllTrim(M->QDH_CODTP),1,3)
				If Substr(QDH->QDH_DOCTO,1,10) == Alltrim(Substr(cCodDoc,1,10))
					nSeq := Val(Substr( QDH->QDH_DOCTO,11,2))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,2) // Pega o Proximo Codigo

		Elseif nTipoCod == 7

			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,2) == SUBSTR(AllTrim(M->QDH_CODTP),1,2)
				If Substr(QDH->QDH_DOCTO,1,4) == Alltrim(Substr(cCodDoc,1,4))
					nSeq := Val(Substr( QDH->QDH_DOCTO,6,6))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,6) // Pega o Proximo Codigo

    	Elseif nTipoCod == 8
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,_nTamtp) == AllTrim(M->QDH_CODTP)
				If Substr(QDH->QDH_DOCTO,1,6) == Alltrim(Substr(cCodDoc,1,6))
					nSeq := Val(Substr( QDH->QDH_DOCTO,8,6))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,6) // Pega o Proximo Codigo

    	Elseif nTipoCod == 9
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,_nTamtp) == AllTrim(M->QDH_CODTP)
				If Substr(QDH->QDH_DOCTO,1,5) == Alltrim(Substr(cCodDoc,1,5))
					nSeq := Val(Substr( QDH->QDH_DOCTO,7,6))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,6) // Pega o Proximo Codigo

    	Elseif nTipoCod == 10
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,_nTamtp) == AllTrim(M->QDH_CODTP)
				If Substr(QDH->QDH_DOCTO,1,6) == Alltrim(Substr(cCodDoc,1,6))
					nSeq := Val(Substr( QDH->QDH_DOCTO,8,6))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,6) // Pega o Proximo Codigo

    	Elseif nTipoCod == 11
			QDH->(DbSeek(xFilial("QDH") + Alltrim(Substr(cCodDoc,1,12))))
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,12) == Alltrim(Substr(cCodDoc,1,12))
				If Substr(QDH->QDH_DOCTO,1,12) == Alltrim(Substr(cCodDoc,1,12))
					nSeq := Val(Substr( QDH->QDH_DOCTO,14,3))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,3) // Pega o Proximo Codigo

		Elseif nTipoCod == 12
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,_nTamtp) == AllTrim(M->QDH_CODTP)
				If Substr(QDH->QDH_DOCTO,1,9) == Alltrim(Substr(cCodDoc,1,9))
					nSeq := Val(Substr( QDH->QDH_DOCTO,10,3))
				Endif
				QDH->(Dbskip())
			Enddo
			cNovoCod := cCodDoc + StrZero(nSeq+1,3) // Pega o Proximo Codigo

		Elseif nTipoCod == 14
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,_nTamtp) == AllTrim(M->QDH_CODTP) 
				If Substr(QDH->QDH_DOCTO,1,6) == Alltrim(Substr(cCodDoc,1,6))
					nSeq := Val(Substr( QDH->QDH_DOCTO,8,5)) 
				Endif 
				QDH->(Dbskip()) 
			Enddo 
			cNovoCod := cCodDoc + StrZero(nSeq+1,5) // Pega o Proximo Codigo

		ElseIf nTipoCod == 15
			While QDH->(!EOF()) .AND. Substr(QDH->QDH_DOCTO,1,_nTamtp) == AllTrim(M->QDH_CODTP)
				If Substr(QDH->QDH_DOCTO,1,9) == Alltrim(cCodDoc)
					nSeq := Val(Substr(QDH->QDH_DOCTO,10,3))
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
