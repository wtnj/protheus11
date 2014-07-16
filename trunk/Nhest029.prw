
User Function NHEST029()
Local aPergs := {}

	oRelato          := Relatorio():New()
	
	oRelato:cString  := "SB1"
    oRelato:cPerg    := "EST029"
	oRelato:cNomePrg := "NHEST029"
	oRelato:wnrel    := oRelato:cNomePrg

	//descricao
	oRelato:cDesc1   := "Relatório de produtos sem movimentação"

	//titulo
	oRelato:cTitulo  := "PRODUTOS SEM MOVIMENTAÇÃO"

	oRelato:cCabec1  := "PRODUTO            DESCRIÇÃO                            GRUPO    AMZ          SALDO     VLR. UNIT          TOTAL"
    oRelato:cCabec2  := ""
	
	aAdd(aPergs,{"Do  Produto ?"         ,"C",15,0,"G","","","","","","SB1",""})//1
	aAdd(aPergs,{"Ate Produto ?"         ,"C",15,0,"G","","","","","","SB1",""})//2
	aAdd(aPergs,{"De Grupo ?"            ,"C",04,0,"G","","","","","","SBM",""})//3
	aAdd(aPergs,{"Ate Grupo ?"           ,"C",04,0,"G","","","","","","SBM",""})//4
	aAdd(aPergs,{"Do Armazém ?"		     ,"C", 2,0,"G","","","","","","ALM",""})//5
	aAdd(aPergs,{"Até Armazém ?"	     ,"C", 2,0,"G","","","","","","ALM",""})//6
	aAdd(aPergs,{"De Data ?"             ,"D", 8,0,"G","","","","","","","99/99/9999"}) //7
	aAdd(aPergs,{"Até Data ?"            ,"D", 8,0,"G","","","","","","","99/99/9999"}) //8
	aAdd(aPergs,{"Saldo Zerado ?"        ,"N", 1,0,"C","Sim","Não","","","","",""})//9
	aAdd(aPergs,{"Mostra Bloqueados ?"   ,"N", 1,0,"C","Sim","Não","","","","",""})//10
                                                                                       
	oRelato:AjustaSx1(aPergs)

	oRelato:Run({||Imprime()})

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO DE IMPRESSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Imprime()
Local cAl := getnextalias()
Local nTotal := 0 

	oRelato:cTitulo += " DE "+dtoc(mv_par07)+" ATÉ "+dtoc(mv_par08)

	SetRegua(0)

	beginSql alias cAl
	
		SELECT prod,grupo,descri,armazem,bloq FROM (

			SELECT DISTINCT
				B9_COD prod,
				B1_DESC descri, 
				B1_GRUPO grupo, 
				B1_MSBLQL bloq,
				B9_LOCAL armazem,
				(SELECT TOP 1 D1_DTDIGIT 
				 FROM %Table:SD1% (NOLOCK)
				 WHERE D1_COD = B9_COD
				 AND D1_LOCAL = B9_LOCAL
				 AND D1_DTDIGIT BETWEEN %Exp:mv_par07% AND %Exp:mv_par08%
				 AND D1_FILIAL = %xFilial:SD1% AND %NotDel%) MOV_D1,
				(SELECT TOP 1 D2_DTDIGIT 
				 FROM %Table:SD2% (NOLOCK)
				 WHERE D2_COD = B9_COD
				 AND D2_LOCAL = B9_LOCAL
				 AND D2_DTDIGIT BETWEEN %Exp:mv_par07% AND %Exp:mv_par08%
				 AND D2_FILIAL = %xFilial:SD2% AND %NotDel%) MOV_D2,
				(SELECT TOP 1 D3_EMISSAO
				 FROM %Table:SD3% (NOLOCK)
				 WHERE D3_COD = B9_COD
				 AND D3_LOCAL = B9_LOCAL
				 AND D3_EMISSAO BETWEEN %Exp:mv_par07% AND %Exp:mv_par08%
				 AND D3_FILIAL = %xFilial:SD3% AND %NotDel%) MOV_D3
			FROM 
				%Table:SB9% B9 (NOLOCK),
				%Table:SB1% B1 (NOLOCK)
			WHERE 
				B1_COD = B9_COD
			AND B9_DATA BETWEEN %Exp:mv_par07% AND %Exp:mv_par08%
			AND B9_LOCAL BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
			AND B1_COD BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
			AND B1_GRUPO BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
			AND B1_FILIAL = %xFilial:SB1% AND B1.%NotDel%
			AND B9_FILIAL = %xFilial:SB9% AND B9.%NotDel%
		) MYTABLE
		WHERE 
			MOV_D1 IS NULL 	
		AND MOV_D2 IS NULL 	
		AND MOV_D3 IS NULL 	
		
		ORDER BY armazem,prod
		
	endSql
	
	If (cAl)->(eof())
		Alert('Nenhum dado encontrado!')
		return
	Endif
	
	oRelato:Cabec()
	
	While (cAl)->(!EOF())
	  
		IncRegua()

  		If Empty((cAl)->armazem)
	  	 	aSaldos := {0,0}
	  	Else
		  	aSaldos := CalcEst((cAl)->prod,(cAl)->armazem,mv_par08)
		Endif
               
		//-- saldo zerado nao		
		If (mv_par09==2 .AND. aSaldos[1]<=0)
        	(cal)->(dbskip())
        	loop
		EndIf

		//-- mostra bloqueados ?
		If (cAl)->bloq=='1' .and. mv_par10==2
        	(cal)->(dbskip())
        	loop
		Endif
		
		If Prow() > 65
			oRelato:Cabec()
		EndIf
       
		@Prow()+1 , 001 psay (cAl)->prod
		@Prow()   , 019 psay OemToAnsi((cAl)->descri)
		@Prow()   , 056 psay (cAl)->grupo
		@Prow()   , 066 psay (cAl)->armazem
		@Prow()   , 074 psay aSaldos[1] Picture "@e 9,999,999" // PesqPict('SB2','B2_QATU') // 12,2
		@Prow()   , 085 psay aSaldos[2]/aSaldos[1] Picture "@e 9,999,999.99" // PesqPict('SB2','B2_VATU1') // 18,2
		@Prow()   , 099 psay aSaldos[2] Picture "@e 99,999,999.99" // PesqPict('SB2','B2_VATU1') // 18,2
		
		nTotal += aSaldos[2]
	     
		(cAl)->(dbskip())
			
	ENDDO
	@Prow() +1,000 psay __PrtThinLine()
	@Prow() +1,083 psay "Total: "
	@Prow()   ,096 psay nTotal Picture "@e 9,999,999,999.99" //'999'+PesqPict('SB2','B2_VATU1') //21,2

	(cAl)->(DbCloseArea())
	
Return




/* -- comentado por joao felipe da rosa  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST029  ºAutor  ³Marcos R Roquitski  º Data ³  01/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relacao de produtos sem movimentacao no estoque.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NhEst029()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,cFilterUser")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,")

cString   := "SD3"
cDesc1    := OemToAnsi("RELACAO DE ITENS SEM MOVIMENTACAO NO ESTOQUE")
cDesc2    := OemToAnsi("")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1,"",1 }
aOrdem    := { 'Codigo do Produto','Dias em atraso' }
nomeprog  := "NHEST029"
aLinha    := {}
nLastKey  := 0
nQtde     := 0
lEnd      := .F.
lDivPed   := .F.
titulo    := "RELACAO DE ITENS SEM MOVIMENTACAO NO ESTOQUE"
Cabec1    := ""
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHEST029"
_cPerg    := "EST029"
aImpRel   := {}

AjustaSx1()

If !Pergunte('EST029',.T.)
	Return(nil)
Endif   

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,aOrdem,,tamanho)
//SetPrint(cString,nomeprog,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem)
If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif
             
nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver     := ReadDriver()
cCompac     := aDriver[1]
cNormal     := aDriver[2]
cFilterUser := aReturn[7]

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")
//Processa( {|| Rptdet() },"Imprimindo...")
DbSelectArea("TMP")
DbCloseArea()

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function Gerando()
	cQuery := "SELECT B1.B1_COD,B1.B1_DESC,B1.B1_LOCAFIS,B2.B2_LOCAL,B2.B2_QATU,B1.B1_UPRC, B2.B2_VATU1 "
	cQuery += "FROM " + RetSqlName( 'SB1' ) +" B1, " + RetSqlName( 'SB2' ) +" B2, " + RetSqlName("SB5")+" B5 "
	cQuery += "WHERE B1.B1_FILIAL = '" + xFilial("SB1")+ "' "
	cQuery += "AND B5.B5_COD = B1.B1_COD "
	cQuery += "AND B2.B2_FILIAL = '" + xFilial("SB2")+ "' "
	cQuery += "AND B1.B1_COD    = B2.B2_COD "
	cQuery += "AND B5.B5_FILIAL = '" + xFilial("SB5")+ "' "
	cQuery += "AND B1.D_E_L_E_T_  = ' ' "
//	cQuery += "AND B1.B1_MSBLQL = '2' "
	cQuery += "AND B2.D_E_L_E_T_  =  ' ' "	
	cQuery += "AND B5.D_E_L_E_T_  =  ' ' "	
	cQuery += "AND B1.B1_TIPO BETWEEN '" + mv_par03 + "' AND '" + Mv_par04 + "' "

	//contem na descricao ou no complemento
    If !Empty(mv_par09)

    	cQuery += " AND (B1.B1_DESC LIKE '%"+ALLTRIM(mv_par09)+"%' OR B5.B5_CEME LIKE '%"+mv_par09+"%')"
    
    EndIf
    
	If mv_par08 == 2 //nao considera saldo zerado
		cQuery += "AND B2.B2_QATU   > 0 "
	EndIf

	cQuery += "AND B2.B2_LOCAL BETWEEN '" + mv_par05 + "' AND '" + Mv_par06 +"' "
	if mv_par07 = 1
 		   	cQuery += "AND B1.B1_MSBLQL = '1' "
	endif                                       
	if mv_par07 = 2
	        cQuery += "AND B1.B1_MSBLQL = '2' "
	endif
	
	cQuery += "ORDER BY B1.B1_COD ASC"

//    MemoWrit('C:\TEMP\NHEST029.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TMP"

Return


Static Function RptDetail()
Local _nQtde := 0, i := 0, _lAchou := .F., _nVlUnit := 0, _nVltot := 0, _dDatai := Ctod(Space(08)), _nDias := 0
Local _dtDignf := Mv_par01

SD3->(DbSetOrder(7))
Cabec1 := Space(40) + "PERIODO DE " + DTOC(Mv_Par01) + " ATE " + DTOC(Mv_Par02) + " dias sem movimento: "+Alltrim(STR(Mv_par02 - Mv_Par01))
Cabec2 := " Produto                                         Local. Loc.Fisico  Qtde           Vlr. Unit.          Vlr. Total        Dias S/Mov."
Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
TMP->(DbGoTop())
While TMP->(!Eof())

	IF 'FE02.064073'$TMP->B1_COD
		ALERT('')
	ENDIF

    _nDias := 0
	_dtDignf := CTOD("  /  /  ")
	ProcRegua(TMP->(RecCount()))

	_lAchou := .F.

	If Prow() > 60
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif
    _nDias := mv_par02 - Mv_par01
    SD3->(DbSeek(xFilial("SD3")+TMP->B1_COD+TMP->B2_LOCAL))
    If SD3->(Found())
	 	While SD3->(!EOF()) .AND. (SD3->D3_COD == TMP->B1_COD .AND. SD3->D3_LOCAL == TMP->B2_LOCAL)
	        If (SD3->D3_EMISSAO >= Mv_Par01 .AND. SD3->D3_EMISSAO <= Mv_Par02)
				If (SD3->D3_TM > '500' .AND. SD3->D3_DOC <> 'INVENT')
					_lAchou := .T.  
					_nDias := mv_par02 - SD3->D3_EMISSAO
					If _nDias < (Mv_par02 - Mv_par01) //verifica se tem mov recente
					   Exit
					Endif  
				Endif
			Endif
			SD3->(DbSkip())
		Enddo
	Else
	   _nDias := mv_par02 - Mv_par01
	Endif

//	_nValorUnit := TMP->B1_UPRC //ultimo preco de entrada do prod.
	_nValorUnit := TMP->B2_VATU1 //ultimo preco de entrada do prod.


*/ //-- fim comentado por joao felipe da rosa


/*	
	If _lAchou
	    SB9->(DbSeek(xFilial("SB9")+TMP->B1_COD+TMP->B2_LOCAL))
		If SB9->(Found())
			While SB9->(!Eof()) .AND.  (SB9->B9_COD == TMP->B1_COD .AND. SB9->B9_LOCAL == TMP->B2_LOCAL)
				If SB9->B9_VINI1 > 0
	    			_nValorUnit := (SB9->B9_VINI1 / SB9->B9_QINI)
					_dDatai := SB9->B9_DATA
	    		Endif
				SB9->(DbSkip())
			Enddo
		Endif
		If _dDatai == Ctod(Space(08))
			_nDias := (Mv_Par02 - Mv_Par01)		
		Else
			If Mv_Par02 > _dDatai
				_nDias := (Mv_Par02 - _dDatai)
			Else
				_nDias := (_dDatai - Mv_Par02)
			Endif	
		Endif
	Endif
	*/		     
	
	/*
	        If (SD3->D3_EMISSAO >= Mv_Par01 .AND. SD3->D3_EMISSAO <= Mv_Par02)
				If (SD3->D3_TM > '500' .AND. SD3->D3_DOC <> 'INVENT')
					_lAchou := .T.  
					_nDias := mv_par02 - SD3->D3_EMISSAO
					If _nDias < (Mv_par02 - Mv_par01) //verifica se tem mov recente
					   Exit
					Endif  
				Endif
			Endif
	
	*/


/* -- comentado por joao felipe da rosa

    _nDias   := mv_par02 - Mv_par01	 
    _dtDignf := 0
	If !_lAchou     
  	    SD1->(DbSetOrder(7))
	    SD1->(DbSeek(xFilial("SD1")+TMP->B1_COD+TMP->B2_LOCAL,.T.))
		If SD1->(Found())
			While SD1->(!Eof()) .AND.  (SD1->D1_COD == TMP->B1_COD .AND. SD1->D1_LOCAL == TMP->B2_LOCAL)
				If (SD1->D1_DTDIGIT >= Mv_Par01 .AND. SD1->D1_DTDIGIT <= Mv_Par02)
				    _dtDignf := SD1->D1_DTDIGIT
				    _lAchou := .t.     
				    exit				    
		        Endif
	            SD1->(Dbskip())		        
		    Enddo
	    Endif
	Endif


    _nDias   := mv_par02 - Mv_par01	 
    _dtDignf := 0
	If !_lAchou     
  	    SD2->(DbSetOrder(1))//D2_FILIAL+D2_COD+D2_LOCAL+D2_NUMSEQ                                                                                                                             
	    SD2->(DbSeek(xFilial("SD2")+TMP->B1_COD+TMP->B2_LOCAL,.T.))
		If SD2->(Found())
			While SD2->(!Eof()) .AND.  (SD2->D2_COD == TMP->B1_COD .AND. SD2->D2_LOCAL == TMP->B2_LOCAL)
				If (SD2->D2_EMISSAO >= Mv_Par01 .AND. SD2->D2_EMISSAO <= Mv_Par02)
				    _dtDignf := SD2->D2_EMISSAO
				    _lAchou := .t.     
				    exit				    
		        Endif
	            SD2->(Dbskip())		        
		    Enddo
	    Endif
	Endif

	
	If !_lAchou     
//    	_nDias := mv_par02 - _dtDignf
	
//	If _nDias >= (Mv_par02 - Mv_par01)
	   @ Prow()  +01 , 001 pSay TMP->B1_COD + " - " + TMP->B1_DESC + "  " + TMP->B2_LOCAL + "    " + TMP->B1_LOCAFIS
  	   @ Prow()      , 064 pSay TMP->B2_QATU Picture "@E 9999,9999"
	   @ Prow()      , 080 pSay _nValorUnit  Picture "@E 999,999.99"
	   @ Prow()      , 100 pSay (_nValorUnit * TMP->B2_QATU) Picture "@E 99,999,999.99"
	   @ Prow()      , 124 pSay _nDias Picture "99999"
	   _nVlTot += (_nValorUnit * TMP->B2_QATU)
	   _nQtde += TMP->B2_QATU
       _dDatai := Ctod(Space(08))
    Endif

	TMP->(DbSkip())
Enddo
@ Prow() + 1, 001 Psay __PrtThinLine()
@ Prow() + 1, 001 Psay "TOTAL GERAL"
@ Prow()    , 060 Psay _nQtde  Picture "@E 999999,9999"
@ Prow()    , 100 pSay _nVlTot Picture "@E 999,999,999.99"
@ Prow() + 1, 001 Psay __PrtThinLine()

Return(nil)



Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
cPerg   := Space(10)
cPerg   := "EST029    "
aRegs   := {}

aadd(aRegs,{cPerg,"01","do Periodo       ?","do Periodo       ?","do Periodo       ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","ate Periodo      ?","ate Periodo      ?","ate Periodo      ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","do Tipo          ?","do Tipo          ?","do Tipo          ?","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","ate Tipo         ?","ate Tipo         ?","ate Tipo         ?","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"05","do Local         ?","do Local         ?","do Local         ?","mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"06","ate Local        ?","ate Local        ?","ate Local        ?","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"07","Lista Bloqueados ?","Lista Bloqueados ?","Lista Bloqueados ?","mv_ch7","C",01,0,0,"C","","mv_par07","Sim","Nao","Ambos","","","","","","","","","","","","","","","","","","","","","","",""})


cUltPerg := aRegs[Len(aRegs)][2]

If SX1->(!DbSeek(cPerg + cUltPerg))

   SX1->(DbSeek(cPerg))

   While SX1->X1_Grupo == cPerg
      RecLock('SX1')
      SX1->(DbDelete())
   	SX1->(DbSkip())
      MsUnLock('SX1')
   End

   For i := 1 To Len(aRegs)
       RecLock("SX1", .T.)

	 For j := 1 to Len(aRegs[i])
	     FieldPut(j, aRegs[i, j])
	 Next
       MsUnlock()

       DbCommit()
   Next
EndIf                   

dbSelectArea(_sAlias)

Return

Static Function fGravaMatr()
Local _nQtde := 0, i := 0, _lAchou := .T., _nVlUnit := 0, _nVltot := 0, _dDatai := Ctod(Space(08)), _nDias := 0
SD3->(DbSetOrder(7))
TMP->(DbGoTop())
While TMP->(!Eof())
	_lAchou := .T.
    SD3->(DbSeek(xFilial("SD3")+TMP->B1_COD+TMP->B2_LOCAL))
 	While SD3->(!EOF()) .AND. (SD3->D3_COD == TMP->B1_COD .AND. SD3->D3_LOCAL == TMP->B2_LOCAL)
		If SD3->D3_DOC <> 'INVENT'
			_dDatai := SD3->D3_EMISSAO
		Endif
		SD3->(DbSkip())
	Enddo
	_nValorUnit := 0

    SB9->(DbSeek(xFilial("SB9")+TMP->B1_COD+TMP->B2_LOCAL))
	If SB9->(Found())
		While SB9->(!Eof()) .AND.  (SB9->B9_COD == TMP->B1_COD .AND. SB9->B9_LOCAL == TMP->B2_LOCAL)
   			_nValorUnit := (SB9->B9_VINI1 / SB9->B9_QINI)
			SB9->(DbSkip())
		Enddo
		_nDias := (mv_par02 - _dDatai)
		AADD(aLinha,{TMP->B1_COD + " - " + TMP->B1_DESC + "  " + TMP->B2_LOCAL + " " + TMP->B1_LOCAFIS,TMP->B2_QATU, _nValorUnit,(_nValorUnit * TMP->B2_QATU),_nDias})
	Endif
   	_dDatai := Ctod(Space(08))
	TMP->(DbSkip())

Enddo

Return


Static Function Rptdet() 
Local _nQtde := 0, i := 0, _lAchou := .T., _nVlUnit := 0, _nVltot := 0, _dDatai := Ctod(Space(08)), _nDias := 0

fGravaMatr()

Cabec1 := Space(40) + "DIAS SEM MOVIMENTACAO DE " + dtoc(Mv_Par01) + " ATE " + dtoc(Mv_Par02)
Cabec2 := "Produto                                            Local. Loc.Fisico   Qtde             Vlr. Unit.          Vlr. Total    Dias S/Mov."
Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)

If aReturn[8] == 1
	aLinha := aSort(aLinha,,,{ |x,y| x[1] < y[1] })
Else
	aLinha := aSort(aLinha,,,{ |x,y| x[5] > y[5] })
Endif	

For i := 1 to Len(aLinha)
	_lAchou := .T.

//	If aLinha[i,5] >= Mv_Par01 .and. aLinha[i,5] <= Mv_Par02

		If Prow() > 60
			_nPag := _nPag + 1
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
		Endif

	    @ Prow()  +01 , 001 pSay aLinha[i,1]
		@ Prow()      , 060 pSay aLinha[i,2]  Picture "@E 9999,9999"
		@ Prow()      , 080 pSay aLinha[i,3]  Picture "@E 999,999.99"
		@ Prow()      , 100 pSay aLinha[i,4]  Picture "@E 999,999,999.99"
		@ Prow()      , 124 pSay aLinha[i,5]  Picture "99999"
		_nVlTot += aLinha[i,4]
	    _nQtde += aLinha[i,2]

//	Endif	    

Next
@ Prow() + 1, 001 Psay __PrtThinLine()
@ Prow() + 1, 001 Psay "TOTAL GERAL"
@ Prow()    , 060 Psay _nQtde  Picture "@E 999999,9999"
@ Prow()    , 100 pSay _nVlTot Picture "@E 999,999,999.99"
@ Prow() + 1, 001 Psay __PrtThinLine()

Return(nil)

*/ //-- fim comentado por joao felipe da rosa


