#INCLUDE "TOPCONN.CH"
#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHMNT032  ºAutor ³João Felipe da Rosa º Data ³  17/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATÓRIO DE OCORRÊNCIAS                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MANUTENCAO DE ATIVOS                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHMNT032()   

Agrupo 	  := {}
cString   := ""
cDesc1    := OemToAnsi("Este relatório irá trazer a relação de observações")
cDesc2    := OemToAnsi("das ocorrências de Manutenção.")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT032" //nome do arquivo
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATÓRIO DE OCORRÊNCIAS") //título
//           |01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
cabec1    := ""
cabec2    := " O.S.      Bem           Descrição Bem                             CC      Descrição CC          C.Trab   Data do Insumo  Obs. da O.S.                                          Obs. do Insumo"
cabec3    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
m_Pag     := 1  //Variavel que acumula numero da pagina 
_NPAG     := 1
wnrel     := nomeprog //"NHMNT032"
_cPerg    := "MNT032" 

If !Pergunte(_cPerg,.T.)
   Return(nil)
Endif 

cabec1    := "PERÍODO CONSULTADO: "+DTOC(MV_PAR03)+" A "+DTOC(MV_PAR04)+SPACE(10)+"BENS CONSULTADOS: "+ALLTRIM(MV_PAR01)+" A "+MV_PAR02

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³CHAMADAS PARA AS FUNÇÕES³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa(  {|| Gerando()   },"Gerando Dados para a Impressao") 
RptStatus( {|| Imprime()   },"Imprimindo...")

set filter to //remove o filtro da tabela

If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          

MS_FLUSH() //Libera fila de relatorios em spool

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FUNCAO QUE GERA OS DADOS PARA IMPRESSAO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function Gerando()
Local cQuery

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MONTA A QUERY³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                       

cQuery := "SELECT TJ.TJ_ORDEM, TJ.TJ_CODBEM, T9.T9_NOME,TJ.TJ_CCUSTO, CTT.CTT_DESC01, T9.T9_CENTRAB, TL.TL_DTINICI, "
cQuery += " TJ.R_E_C_N_O_ AS TJ_RECNO, TL.R_E_C_N_O_ AS TL_RECNO "
cQuery += " FROM "+RetSqlName("STJ")+" TJ, "+RetSqlName("ST9")+" T9, "+RetSqlName("STL")+" TL, "+RetSqlName("CTT")+" CTT"
cQuery += " WHERE TJ.TJ_ORDEM = TL.TL_ORDEM"
cQuery += " AND TJ.TJ_CODBEM = T9.T9_CODBEM"
cQuery += " AND TJ.TJ_CCUSTO = CTT.CTT_CUSTO"
cQuery += " AND TJ.TJ_CODBEM BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
cQuery += " AND TL.TL_DTINICI BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"'"

cQuery += " AND TL.TL_HOINICI >= '"+MV_PAR13+"' AND TL.TL_HOFIM <= '"+MV_PAR14+"'"

cQuery += " AND T9.T9_CENTRAB BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
cQuery += " AND TJ.TJ_CCUSTO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
cQuery += " AND TJ.TJ_SERVICO BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'"
cQuery += " AND TJ.D_E_L_E_T_ = '' AND TJ.TJ_FILIAL = '"+XFILIAL('STJ')+"'"
cQuery += " AND T9.D_E_L_E_T_ = '' AND T9.T9_FILIAL = '"+XFILIAL('ST9')+"'"
cQuery += " AND TL.D_E_L_E_T_ = '' AND TL.TL_FILIAL = '"+XFILIAL('STL')+"'"
cQuery += " AND CTT.D_E_L_E_T_ = '' AND CTT.CTT_FILIAL = '"+XFILIAL('CTT')+"'"
cQuery += " GROUP BY TJ.TJ_ORDEM, TJ.TJ_CODBEM, T9.T9_NOME,TJ.TJ_CCUSTO, CTT.CTT_DESC01, "
cQuery += " T9.T9_CENTRAB, TL.TL_DTINICI, TJ.R_E_C_N_O_, TL.R_E_C_N_O_ "
cQuery += " ORDER BY TJ.TJ_CODBEM, TL.TL_DTINICI"

//MemoWrit('C:\TEMP\'+nomeprog+'.SQL',cQuery)
TCQUERY cQuery NEW ALIAS "TRA1" 

TcSetField("TRA1","TL_DTINICI","D")  // Muda a data de string para date    

TRA1->(DbGotop())     

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FUNCAO PARA IMPRESSAO DO RELATÓRIO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function Imprime()
Local _nLinMemo
Local _nLin              
Local _nPos, _nPos2
Local _lPula

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

SETREGUA(TRA1->(RECCOUNT()))

While TRA1->(!Eof())  

	If Prow() > 65 
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
  	Endif

	IncRegua()
		
    STJ->(DBGOTO(TRA1->TJ_RECNO))
    STL->(DBGOTO(TRA1->TL_RECNO))
        

	_lPula   := .T.
	_cStrTJ  := ALLTRIM(MV_PAR09) //PALAVRAS QUE DEVEM CONTER NA OBS DA TJ
	_cStrTL  := ALLTRIM(MV_PAR10) //PALAVRAS QUE DEVEM CONTER NA OBS DA TL
	   	
	WHILE .T.
	
		IF Empty(MV_PAR09) .AND. Empty(MV_PAR10) 
			_lPula := .F.
			EXIT
		ENDIF
		
		IF Empty(_cStrTJ) .AND. Empty(_cStrTL) 
			EXIT
		ENDIF
		
		IF !EMPTY(_cStrTJ)
			
			IF AT(";",_cStrTJ) > 0
				IF (SUBSTR(_cStrTJ,1,AT(";",_cStrTJ) - 1)$STJ->TJ_OBSERVA)
					_lPula := .F.
					EXIT
				ENDIF
			ELSE
				IF ALLTRIM(_cStrTJ)$STJ->TJ_OBSERVA
					_lPula := .F.
					EXIT
				ENDIF
			ENDIF
			
			IF AT(";",_cStrTJ) == 0
				_cStrTJ := ""
			ENDIF
			
			_cStrTJ := Right(_cStrTJ,Len(_cStrTJ) - AT(";",_cStrTJ))
			
		ENDIF
		
		IF !EMPTY(_cStrTL)
			
			IF AT(";",_cStrTL) > 0
				IF (SUBSTR(_cStrTL,1,AT(";",_cStrTL) - 1)$STL->TL_OBSERVA)
					_lPula := .F.
					EXIT
				ENDIF
			ELSE
				IF ALLTRIM(_cStrTL)$STL->TL_OBSERVA
					_lPula := .F.
					EXIT
				ENDIF
			ENDIF
			
			IF AT(";",_cStrTL) == 0
				_cStrTL := ""
			ENDIF
			
			_cStrTL := Right(_cStrTL,Len(_cStrTL) - AT(";",_cStrTL))

		ENDIF
    ENDDO
    
    IF _lPula
    	TRA1->(DBSKIP())
    	LOOP
    ENDIF
   	
   	_nLinMemo  := MLCOUNT(ALLTRIM(STJ->TJ_OBSERVA),45) //Traz a quantidade de linhas que o campo memo possui usando 50 caracteres p/ linha
    _nLinMemo2 := MLCOUNT(ALLTRIM(STL->TL_OBSERVA),45) //Traz a quantidade de linhas que o campo memo possui usando 50 caracteres p/ linha

	If Prow() + IIF(_nLinMemo > _nLinMemo2, _nLinMemo, _nLinMemo2) > 65 
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
  	Endif

	@Prow()+1, 001 psay TRA1->TJ_ORDEM
	@Prow()  , 011 psay ALLTRIM(TRA1->TJ_CODBEM)
	@Prow()  , 025 psay SUBS(TRA1->T9_NOME,1,40)
    @Prow()  , 067 psay ALLTRIM(TRA1->TJ_CCUSTO)
    @Prow()  , 075 psay SUBS(TRA1->CTT_DESC01,1,20)
    @Prow()  , 097 psay TRA1->T9_CENTRAB
    @Prow()  , 107 psay TRA1->TL_DTINICI
    
	_nLin := Prow()
	
	For LinhaCorrente := 1 To IIF(_nLinMemo > _nLinMemo2, _nLinMemo, _nLinMemo2)

		//IMPRIME A OBSERVACAO DA O.S.
		If LinhaCorrente <= _nLinMemo
			@_nLin  , 122 psay (MemoLine(STJ->TJ_OBSERVA,45,LinhaCorrente))
		EndIf
		//IMPRIME A OBSERVACAO DO INSUMO						
		If LinhaCorrente <= _nLinMemo2
			@_nLin  , 171 psay (MemoLine(STL->TL_OBSERVA,45,LinhaCorrente))
		EndIf
		
		_nLin++

	Next
    
	@ prow()+1,000 PSAY __PrtThinLine()  
	@ prow()+1,000 PSAY ""
	
	TRA1->(DbSkip())

EndDo

@ prow()+1,000 PSAY __PrtThinLine()        

TRA1->(DbCloseArea())

Return(nil)