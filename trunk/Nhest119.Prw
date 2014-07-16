/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST119  ºAutor  ³Alexandre R. bento     º Data ³  28/05/08º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Composicao da descricao do produto de ferramenta            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³WHB                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch" 
#INCLUDE "topconn.ch"   

User Function Nhest119()
	SetPrvt("_Sigla,_Grupo,_Etapa,_Compo,_Loja,_cGrupo,_cEtapa,_cCompo,_cNovo,cQuery,_cCombo,_aCombo,_cCarac,_cProt,_cArq")
	SetPrvt("_cProd,_aProd,_cTipo,_aTipo,_cCorte,_aCorte,_cForma,_cRef,_cHeli,_cDim,_cNorma,_cDesc")
		
	If M->B1_TIPO$"FE"
	    
	   If M->B1_GRUPO$"FE05/FE35"
          M->B1_COD    := M->B1_GRUPO + "."+M->B1_CODAP5	  
          M->B5_COD    := M->B1_COD
	      Return(Space(10))
	   Endif	   
	   
	   If Empty(M->B1_FAMFER)
	      MsgBox("A Familia da Ferramenta nao foi Digitada !","STOP","Composicao da Ferramenta")
	      Return(Space(10))
	   Endif
	
	   _cProd  := Space(20)
	   _cTipo  := Space(15)
	   _cCorte := Space(10)
	   _cRef   := Space(10)
        _cHeli := Space(10)	   
	   _cDim   := Space(20)
	   _cNorma := Space(20)
	   _cDesc  := Space(100)
		_aProd  := {} 	   	
		_aTipo  := {} 
		_aFerra := {} 		
		_aCorte := {}
		_aHeli  := {} 				
		_aFerra := {} 				
		_aRef   := {} 				
		
		 				
		_cCombo  := " "
		_lCria   := .F.
		
	  SX5->(Dbgotop())       
	  SX5->(DbSetOrder(1)) //filial+cod
	  SX5->(DbSeek(xFilial("SX5")+"ZK")) //tabelas de Tipos de ferramentas
	  While SX5->(!Eof()) .And. SX5->X5_TABELA$"ZK" 
	   	 If Subs(SX5->X5_CHAVE,1,3)$M->B1_FAMFER
	   	    Aadd(_aProd,SX5->X5_DESCRI)
	   	  Endif   
	      SX5->(Dbskip())
	  Enddo

	  SX5->(Dbgotop())       
	  SX5->(DbSeek(xFilial("SX5")+"ZM")) //tabelas de Tipos de ferramentas
	  While SX5->(!Eof()) .And. SX5->X5_TABELA$"ZM" 
	   	 Aadd(_aTipo,SX5->X5_DESCRI)
	     SX5->(Dbskip())
	  Enddo

	  SX5->(Dbgotop())       
	  SX5->(DbSeek(xFilial("SX5")+"ZN")) //tabelas de Cortes de ferramentas
	  While SX5->(!Eof()) .And. SX5->X5_TABELA$"ZN" 
   	     Aadd(_aCorte,SX5->X5_DESCRI)
	     SX5->(Dbskip())
	  Enddo

	  SX5->(Dbgotop())       
	  SX5->(DbSeek(xFilial("SX5")+"ZO")) //tabelas de Tipos de ferramentas
	  While SX5->(!Eof()) .And. SX5->X5_TABELA$"ZO" 
   	     Aadd(_aHeli,SX5->X5_DESCRI)
	     SX5->(Dbskip())
	  Enddo

	  SX5->(Dbgotop())       
	  SX5->(DbSeek(xFilial("SX5")+"ZP")) //tabelas de Refrigeracao de ferramentas
	  While SX5->(!Eof()) .And. SX5->X5_TABELA$"ZP" 
   	     Aadd(_aRef,SX5->X5_DESCRI)
	     SX5->(Dbskip())
	  Enddo

		
		@ 200,050 To 480,1000 Dialog oDlg Title OemToAnsi("Composicao do Codigo de Ferramentas")
		@ 007,010 Say OemToAnsi("Descrição Ferramenta") Size 65,8
		@ 021,010 Say OemToAnsi("Produto ") Size 35,8 
		@ 034,010 Say OemToAnsi("Tipo ") Size 30,8
		@ 047,010 Say OemToAnsi("Corte") Size 35,8
		@ 060,010 Say OemToAnsi("Dimensão") Size 35,8
		@ 073,010 Say OemToAnsi("Hélice  ") Size 35,8
		@ 086,010 Say OemToAnsi("Refrigeração") Size 45,8
		@ 099,010 Say OemToAnsi("Norma da Haste") Size 50,8
                                                                 
		@ 007,070 Get _cDesc When(.F.) Size 200,8 object oDesc
		@ 019,050 COMBOBOX _cProd ITEMS _aProd SIZE 080,10 object oProd
		@ 032,050 COMBOBOX _cTipo ITEMS _aTipo SIZE 100,10 object oTipo		
		@ 045,050 COMBOBOX _cCorte ITEMS _aCorte SIZE 050,10 object oCorte				
		@ 058,050 Get _cDim   PICTURE "@!" Size 90,8 object oDim
        @ 071,050 COMBOBOX _cHeli ITEMS _aHeli SIZE 050,10 object oHeli						
        @ 084,050 COMBOBOX _cRef ITEMS _aRef SIZE 075,10 object oRef							
		@ 097,050 Get _cNorma    PICTURE "@!" Size 70,8
		
//		@ 039,070 Get _Cliente      PICTURE "@!" F3 "SA1" Valid(fCliente()) When Substr(_cCombo,1,1) $ 'NC' Size 20,8
//		@ 039,102 Get _Loja         PICTURE "@!" Valid(fLoja()) When Substr(_cCombo,1,1) $ 'NC' Size 10,8
//		@ 039,155 Get _Sigla        PICTURE "@!" Size 15,8 When .F.
//		@ 054,070 Get _Grupo        PICTURE "@!" F3 "SZJ" Size 10,8 Valid(fGrupo()) When Substr(_cCombo,1,1) $ 'NC'
//		@ 054,090 Get _cGrupo       PICTURE "@!" When .f. Size 83,8
//		@ 069,070 Get _Etapa        PICTURE "@!" F3 "SZL" Size 06,8 Valid(fEtapa()) When Substr(_cCombo,1,1) == 'E'
//		@ 069,090 Get _cEtapa       PICTURE "@!" When .f. Size 83,8 Object ocEtapa		                
//		@ 084,070 Get _Compo        PICTURE "@!" F3 "SZK" Size 10,8 When Alltrim(_Etapa) == '5' Valid(fCompo())
//		@ 084,098 Get _cCompo       PICTURE "@!" When .f. Size 75,8
   
		@ 120,070 BMPBUTTON TYPE 01 ACTION fGDesc()
		@ 120,110 BMPBUTTON TYPE 02 ACTION Close(oDlg)

		Activate Dialog oDlg CENTERED
	Endif

Return(Space(10))

Static Function fGDesc()

_cDesc :=Alltrim(_cProd) +Space(01)+;
		 Alltrim(_cTipo) +Space(01)+;
		 Alltrim(_cCorte) +Space(01)+;
		 Alltrim(_cDim)  +Space(01)+;
         Alltrim(_cHeli) +Space(01)+;
         Alltrim(_cRef) +Space(01)+;
		 Alltrim(_cNorma) 

ObjectMethod(oDesc, "Refresh()")          
M->B1_DESC := _cDesc
M->B1_FDESC:= _cDesc
M->B5_CEME := _cDesc
M->B5_COD  := M->B1_COD
Close(oDlg)
Return



