/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RHGP05    ºAutor  ³Marcos R. Roquitski º Data ³  30/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relacao de Aumentos Salarias no Mes 
±± Manutenção: José Henrique M Felipetto
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico WHB.                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"


User Function Rhgp05()

	SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
	SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
	SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
	SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
	SetPrvt("M_PAG,NOMEPROG,_NVLRANT,_NVLRATU,_LFUNCAO,_NSALATU")
	SetPrvt("_LSALARIO,_CTIPOALT,DDATAI,DDATAF,_nSalant,_cFunAnt")
	
	cPerg   := "RHGP05"
	cSavCur1 := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""
	cabec1   := "";cabec2:="";cabec3:="";wnrel:=""
	nOrdem   := 0
	tamanho  := "G"
	limite   := 220
	aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
	nLastKey := 0
	cRodaTxt := ""
	nCntImpr := 0
	titulo   := "Relatorio de Funcionarios com Aumento Salarial no Mes"
	cDesc1   := ""
	cDesc2   := ""
	cDesc3   := ""
	cString  := "SR7"
	nTipo    := 0
	m_pag    := 1
	nomeprog := "RHGP05"
	cabec1   := "MATRIC NOME                           ADMIS ALTER TIPO ALTERACAO  ANTERIOR   SAL.ATUAL  FUNCAO ANTERIOR      FUNCAO ATUAL                   C. CUSTO                                    PLANTA"                   
	cabec2   := "______ ______________________________ _____ _____ ____ __________ __________ __________ ____________________ ____________________           _____________________________               ______________"
	cabec3   := "." 
	Pergunte(cPerg,.T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := "RHGP05"
	wnRel := SetPrint("SR7",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")
    
    
	
	If LastKey() == 27 .or. nLastKey == 27
	   Return
	Endif

	SetDefault(aReturn,cString)

	If LastKey() == 27 
	   Return
	Endif

	 
	Processa( {|| fGeraTmp() },"Gerando Dados para a Impressao")
	RptStatus({|| RHG005()})
    
Return


Static Function RHG005()

	CTT->(DbSetOrder(1))

	DbSelectArea("SRA")
	DbSetOrder(01)      
	If Mv_par01 == 1 // Usinagem
	    Set Filter To SRA->RA_ZEMP == '1'
	Endif
	If Mv_par01 == 2 // Fundição
	    Set Filter To SRA->RA_ZEMP == '2'
	Endif
	SRA->(DbGoTop())

	
	
	DbSelectArea("SR3")
	DbSetOrder(01)
	
	DbSelectArea("SR7")
	DbSetOrder(01)
	
	m_pag    := 1
	_nVlrAnt := 0.00
	_nVlrAtu := 0.00
	_nSalAnt := 0
	_cFunAnt := ""
	
	DbSelectArea("TMP")
	TMP->(DbgoTop())
	TMP->(SetRegua(RecCount()))
	Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	TMP->(dbGoTop())
	While TMP->(!Eof())
	   IncRegua()
	   SR7->(DbSeek(TMP->R7_FILIAL+TMP->R7_MAT+dTos(TMP->R7_DATA),.T.))
	   If SR7->R7_FILIAL==TMP->R7_FILIAL .AND. SR7->R7_MAT==TMP->R7_MAT .AND. dTos(SR7->R7_DATA)==dTos(TMP->R7_DATA)
	      SR7->(DbSkip(-1))
			If Empty(SR7->R7_TIPO) .OR. SR7->R7_DATA == Ctod(Space(08))
	         _lFuncao:=.F.		   			
			Else
		      If SR7->R7_FILIAL==TMP->R7_FILIAL .AND. SR7->R7_MAT==TMP->R7_MAT .AND. dTos(SR7->R7_DATA)<>dTos(TMP->R7_DATA)
		         If TMP->R7_FUNCAO<>SR7->R7_FUNCAO
	   	         _lFuncao:=.T.
		         Else   
		            _lFuncao:=.F.
	   	      EndIf
		      Endif
		   EndIf
		Endif
	   SR3->(DbSeek(TMP->R7_FILIAL+TMP->R7_MAT+dTos(TMP->R7_DATA),.T.))
	   If SR3->R3_FILIAL==TMP->R7_FILIAL .AND. SR3->R3_MAT==TMP->R7_MAT .AND. dTos(SR3->R3_DATA)==dTos(TMP->R7_DATA)
	      _nSalAtu := SR3->R3_VALOR
	      SR3->(DbSkip(-1))
	      If SR3->R3_FILIAL==TMP->R7_FILIAL .AND. SR3->R3_MAT==TMP->R7_MAT .AND. dTos(SR3->R3_DATA)<>dTos(TMP->R7_DATA)
	         If _nSalAtu <> SR3->R3_VALOR
	            _lSalario:=.T.
	         Else
	            _lSalario:=.F.
	         Endif
	      Else
				_lSalario:=.F.	      
	      Endif
	   EndIf  
	   If _lSalario==.T. .OR. _lFuncao==.T.
	      SRA->(DbSeek(TMP->R7_FILIAL+TMP->R7_MAT,.T.))
	      If SRA->(Found())
	      	If SRA->RA_SITFOLH<>"D"
	      		If pRow() > 60
		            Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		         Endif
	             @ pRow()+1,01  pSay SRA->RA_MAT
		         @ pRow()  ,08  pSay SRA->RA_NOME
		         @ pRow()  ,39  pSay SubStr(dToc(SRA->RA_ADMISSA),4,2) + "/" + SubStr(Dtos(SRA->RA_ADMISSA),3,2)
	   	         @ pRow()  ,45  pSay SubStr(dToc(TMP->R7_DATA),4,2) + "/" + SubStr(Dtos(TMP->R7_DATA),3,2)
		         _cTipoAlt:=SubStr(Tabela("41",TMP->R7_TIPO),1,10)
		         @ pRow()  ,51  pSay _cTipoAlt 
		         @ pRow()  ,67  pSay SR3->R3_VALOR Picture "@E 999,999.99"
		         @ pRow()  ,78  pSay _nSalAtu Picture "@E 999,999.99"
		         @ pRow()  ,89  pSay SR7->R7_DESCFUN
		         @ pRow()  ,110 pSay TMP->R7_DESCFUN



		         @ pRow()  ,140 pSay SRA->RA_CC          
		         If CTT->(DbSeek(CTT->CTT_FILIAL+SRA->RA_CC))
			         @ pRow()  ,150 pSay CTT->CTT_DESC01    

				 Endif
		         @ pRow()  ,185 pSay SRA->RA_ZEMP
		         If SRA->RA_ZEMP == '2'
			         @ pRow()  ,187 pSay 'Fundicao   '
                                                   
		         Elseif SRA->RA_ZEMP == '3'
			         @ pRow()  ,187 pSay 'Usinagem   '

		         Elseif SRA->RA_ZEMP == '4'
			         @ pRow()  ,187 pSay 'Forjaria   '

		         Elseif SRA->RA_ZEMP == '5'
			         @ pRow()  ,187 pSay 'Virabrequim'

				 Endif
		         _nVlrAnt:=_nVlrAnt+SR3->R3_VALOR
		         _nVlrAtu:=_nVlrAtu+_nSalAtu
		      EndIf   
	      Endif 
	   EndIf
	   TMP->(DbSkip())
	Enddo
	@ Prow()+02,001 Psay __PrtThinLine()
	DbSelectArea("TMP")
    DbCloseArea()

	
	If aReturn[5] == 1
		Set Printer To
		Commit
	   ourspool(wnrel)
	Endif
	MS_FLUSH()

DbSelectArea("SRA")
Set Filter To  
SRA->(DbGotop() )	
Return


Static Function fGeraTmp()

   dDatai := Ctod( "01/" + Str( Month(dDataBase) ) + "/" + Str(Year(dDataBase) ) )

   dDataf := UltimoDia(dDatai)

   cQuery  := " SELECT * FROM " + RetSqlName( 'SR7' ) + " R7 "
   cQuery := cQuery + " WHERE R7.R7_DATA BETWEEN '" + Dtos(dDatai) + "' AND '" + Dtos(dDataf) + "' "
   cQuery := cQuery + " AND R7.D_E_L_E_T_ <> '*' "
   cQuery := cQuery + " AND R7.R7_TIPO <> '   ' "
	cQuery := cQuery + " ORDER BY R7.R7_FILIAL,R7.R7_MAT,R7.R7_DATA,R7.R7_TIPO ASC"
	TCQUERY cQuery NEW ALIAS "TMP"
   	TcSetField("TMP","R7_DATA","D")  // Muda a data de string para date
   
   

Return
