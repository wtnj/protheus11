/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE224  ºAutor  ³Marcos R. Roquitski º Data ³  26/07/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Acordo plano de saude, conforme lei CONSU.                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"        
#INCLUDE "MSOLE.CH"

User Function Nhgpe224()

SetPrvt("CCADASTRO,ASAYS,ABUTTONS,NOPCA,CTYPE,CARQUIVO")
SetPrvt("NVEZ,OWORD,CINICIO,CFIM,CFIL,CXINSTRU,CXLOCAL,_aExtras")
SetPrvt("LIMPRESS,CARQSAIDA,CARQPAG,NPAG,CPATH,CARQLOC,NPOS") 
SetPrvt("_nSalm2,_nSalf2,_nSale2,_nSalo2,_nSalm1,_nAno,_nMes,_cAnoMes,_nSalf2,_nSale2,_nSalo2")


If Pergunte("NHGPE186",.T.)

	Processa({|| WORDIMP()})

Endif
	
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ WORDIMP  ³ Autor ³ Equipe Desenv. R.H.   ³ Data ³ 31.03.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Certificados dos cursos  - VIA WORD           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³                                          ³ Data ³          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static FUNCTION WORDIMP()
Local _cDescf := Space(20)
Local i
Local _nAno := 0

SRD->(DbSetOrder(1))
SRC->(DbSetOrder(1))
SRJ->(DbSetOrder(1))
                            
If SM0->M0_CODIGO == 'FN'
	cArquivo := "\system\CONSUFN.dot" // 
Else
	cArquivo := "\system\CONSUNH.dot" // 
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Copiar Arquivo .DOT do Server para Diretorio Local ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPos := Rat("\",cArquivo)
If nPos > 0
	cArqLoc := AllTrim(Subst(cArquivo, nPos+1,20 ))
Else 
	cArqLoc := cArquivo
EndIF


cPath := GETTEMPPATH()
If Right( AllTrim(cPath), 1 ) != "\"
   cPath += "\"
Endif
If !CpyS2T(cArquivo, cPath, .T.)
	Return
Endif

lImpress   := .F.
nPag 	   := 0
cArqSaida  := "XCONSU"


// Inicia o Word 
nVez := 1

// Inicializa o Ole com o MS-Word 97 ( 8.0 )	
oWord := OLE_CreateLink('TMsOleWord97')		

OLE_NewFile(oWord,cPath+cArqLoc)

If lImpress
	OLE_SetProperty( oWord, oleWdVisible,   .F. )
	OLE_SetProperty( oWord, oleWdPrintBack, .T. )
Else
	OLE_SetProperty( oWord, oleWdVisible,   .T. )
	OLE_SetProperty( oWord, oleWdPrintBack, .F. )
EndIf

_nDep := 0
_nTit := 0
_cAsm := Space(02)
_cTpr := Space(02)

If SRA->(DbSeek(xFilial("SRA")+mv_par01))

	If !Empty(SRA->RA_ASMEDIC)
		_cAsm := SRA->RA_ASMEDIC
		_nTit++	
	Endif

	SRB->(DbSeek(xFilial("SRB")+ SRA->RA_MAT))
	While !SRB->(Eof()) .and. SRB->RB_MAT == SRA->RA_MAT 
		If !Empty(SRB->RB_ASMEDIC) 
			_nDep++ 
		Endif	 
		SRB->(DbSkip())
	Enddo


	SRG->(DbSeek(xFilial("SRG")+SRA->RA_MAT))
	If SRG->(Found())
		If SRG->RG_TIPORES = '01'
			_cTpr := SRG->RG_TIPORES + ' DEMISSAO S/JUSTA CAUSA TRAB' //01
		Elseif SRG->RG_TIPORES = '02'
			_cTpr := SRG->RG_TIPORES + ' DEMISSAO S/JUSTA CAUSA INDEN' // 02
		Elseif SRG->RG_TIPORES = '03'
			_cTpr := SRG->RG_TIPORES + ' PEDIDO DEMISSAO TRAB/DISP' // 03
		Elseif SRG->RG_TIPORES = '04'		
			_cTpr := SRG->RG_TIPORES + ' PEDIDO DEMISSAO AVISO DESCONT' // 04
		Elseif SRG->RG_TIPORES = '05'
			_cTpr := SRG->RG_TIPORES + ' PEDIDO DEMISSAO CTO EXPERIENCI' // 05
		Elseif SRG->RG_TIPORES = '06'			
			_cTpr := SRG->RG_TIPORES + ' DEMISSAO S/JUSTA CAUSA EXPERIE' // 06
		Elseif SRG->RG_TIPORES = '07'	
			_cTpr := SRG->RG_TIPORES + ' DEMITIDO POR JUSTA CAUSA' // 07
		Elseif SRG->RG_TIPORES = '08'			
			_cTpr := SRG->RG_TIPORES + ' DEM P/FALECIMENTO DO EMPREGADO' // 08
		Elseif SRG->RG_TIPORES = '09'			
			_cTpr := SRG->RG_TIPORES + ' DEMISSAO TERMINO CONTRATO' // 09
		Elseif SRG->RG_TIPORES = '10'			
			_cTpr := SRG->RG_TIPORES + ' PEDIDO DEMISSAO APRENDIZ' // 10
		Elseif SRG->RG_TIPORES = '11'			
			_cTpr := SRG->RG_TIPORES + ' TERMINO ESTAGIO' // 11
		Endif	
	Endif		



	//--Cadastro Funcionario
	OLE_SetDocumentVar(oWord,"cNomeFun",SRA->RA_MAT + ' ' + SRA->RA_NOME)

	_cDescf := Space(20)
	SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC))
	If SRJ->(Found())
		_cDescf := SRJ->RJ_DESC
	Endif		

	_nAno := ((Year(dDataBase) - Year(SRA->RA_ADMISSA)))
	OLE_SetDocumentVar(oWord,"Matricula",SRA->RA_MAT)
	OLE_SetDocumentVar(oWord,"Admissa",DTOC(SRA->RA_ADMISSA))
	OLE_SetDocumentVar(oWord,"Demissa",DTOC(SRA->RA_DEMISSA))
	
	If _nAno == 1 
		OLE_SetDocumentVar(oWord,"Tempo", Alltrim(Str(_nAno)) +' ANO' ) 

	Else 
		OLE_SetDocumentVar(oWord,"Tempo", Alltrim(Str(_nAno)) + ' ANOS' ) 

	Endif 

	If _cAsm == '01'
		OLE_SetDocumentVar(oWord,"Plano", ' APARTAMENTO ' ) 

	Else 
		OLE_SetDocumentVar(oWord,"Plano", ' ENFERMARIA  ' ) 

	Endif 
	OLE_SetDocumentVar(oWord,"Titular",Alltrim(Str(_nTit))) 
	OLE_SetDocumentVar(oWord,"Dependente",Alltrim(Str(_nDep))) 
	OLE_SetDocumentVar(oWord,"Tipores",_cTpr) 
	OLE_SetDocumentVar(oWord,"ValorPlano",Transform(fCalcp(),"@E 999,999,999.99")) 

Endif 

//--Atualiza Variaveis
OLE_UpDateFields(oWord)

//-- Imprime as variaveis				
OLE_SetProperty( oWord, '208', .F. ) 

Aviso("", "Alterne para o programa do Ms-Word para visualizar o documento ou clique no botao para fechar.", {"Fechar"})
	
OLE_CloseLink( oWord ) 			// Fecha o Documento

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Apaga arquivo .DOT temporario da Estacao 		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If File(cPath+cArqLoc)
	FErase(cPath+cArqLoc)
Endif

Return



Static function fCalcp()
Local  _Depend    := 77.53
Local  _nValor    := 77.53
Local  _nIntegral := 130.58
Local _nSalario   := 0
Local _nNu        := 0
Local _nMaior18   := 0
Local nVlrPl      := 0

If SRA->RA_ASMEDIC <> Space(02)
      
      If SRA->RA_ASMEDIC == "02"

         If SRA->RA_CATFUNC = 'H'
            _nSalario := (SRA->RA_SALARIO * SRA->RA_HRSMES)	   
         Else
           _nSalario := SRA->RA_SALARIO	  
         Endif

         If _nSalario <= 1835.99
            _nValor := 32.54
         Elseif _nSalario > 1836.00 .and. _nSalario <= 3055.99
            _nValor := 35.67
         Elseif _nSalario > 3056.00 .and. _nSalario <= 6014.99
            _nValor := 39.99
         Elseif _nSalario > 6015.00 
            _nValor := 41.49
         Endif
   		
   		 _nIntegral := 68.67

      Endif
  
      _nNu := _nNu + 1
      _nMaior18 := 0
   SRB->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT,.T.))
   While !SRB->(Eof()) .and. SRA->RA_FILIAL==SRB->RB_FILIAL .and. SRA->RA_MAT==SRB->RB_MAT
				
				If SRB->RB_ASMEDIC <> Space(02)
				
					If (SRB->RB_GRAUPAR == "F" .OR. SRB->RB_GRAUPAR == "E")
						If Year(dDataBase) - Year(SRB->RB_DTNASC) < 17
	    		        _nNu++
	
						Elseif Year(dDataBase) - Year(SRB->RB_DTNASC) >=19
						    _nMaior18++

						Elseif Year(dDataBase) - Year(SRB->RB_DTNASC) == 17 .and. Month(SRB->RB_DTNASC) < Month(dDatabase)
    				        _nNu++

						Elseif Year(dDataBase) - Year(SRB->RB_DTNASC) == 17 .and. Month(SRB->RB_DTNASC) > Month(dDatabase)
    				        _nNu++

						Elseif Year(dDataBase) - Year(SRB->RB_DTNASC) == 17 .and. Month(SRB->RB_DTNASC) == Month(dDatabase) .and. Day(SRB->RB_DTNASC) <=14
    				        _nNu++
 

						Elseif Year(dDataBase) - Year(SRB->RB_DTNASC) == 17 .and. Month(SRB->RB_DTNASC) == Month(dDatabase) .and. Day(SRB->RB_DTNASC) >=14
    				        _nNu++

						Elseif Year(dDataBase) - Year(SRB->RB_DTNASC) == 18 .and. Month(SRB->RB_DTNASC) < Month(dDatabase)
							    _nMaior18++
			    
						Elseif Year(dDataBase) - Year(SRB->RB_DTNASC) == 18 .and. Month(SRB->RB_DTNASC) > Month(dDatabase)
    			        _nNu++

						Elseif Year(dDataBase) - Year(SRB->RB_DTNASC) == 18 .and. Month(SRB->RB_DTNASC) == Month(dDatabase) .and. Day(SRB->RB_DTNASC) > 14
    			        _nNu++

						Elseif Year(dDataBase) - Year(SRB->RB_DTNASC) == 18 .and. Month(SRB->RB_DTNASC) == Month(dDatabase) .and. Day(SRB->RB_DTNASC) <= 14
						    _nMaior18++
						Endif
					Else
	   		        _nNu := _nNu + 1
					Endif
		        Endif
         SRB->(DbSkip())
	Enddo
	
	nVlrPl :=	(_nValor*_nNu) + (_nMaior18 * _nIntegral) 

Endif

Return(nVlrPl)