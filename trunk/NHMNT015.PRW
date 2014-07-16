#include "font.ch"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ NHMNT015  บAutor ณ Joใo Felipe da Rosa บ Data ณ  12/07/06  บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ OS ABERTO / SITUACAO                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANUTENCAO DE ATIVOS                                       บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function NHMNT015()   
Local oPrint  
SetPrvt("aGrupo,_cCodUsr,aCols,aGrupo,_cArqDBF,_aDBF,_cArqDBF,_cOrdem,_totalgeral,_totalcc")

aCols	:= {}                  
Agrupo 	:= {}
cString   := "STJ"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir ")
cDesc2    := OemToAnsi(" as OS de servicos para execucao")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT015"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("O.S. / Situacao ")                
cabec2    := " No.OS    Data OS      Cod.Bem          Descricao Bem                               Sit.    C.C.                        C.Trab.    Dat.Ini       H.Ini      Dat.Fim       H.Fim  Dura็ใo  Matr.    Funcionแrio"
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHMNT015"
_cPerg    := "NMNT15" 
_nTotal   := 0  
_totalgeral := 0  
_totalcc := 0

If !Pergunte(_cPerg,.T.)
   Return(nil)
Endif                        
cabec1  := " Periodo de : " + DTOC(mv_par03) + " a " + DTOC(mv_par04)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]      

Processa( {|| Gerando()   },"Gerando Dados para a Impressao") 
RptStatus( {|| Imprime()   },"Imprimindo...")

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool
DbCloseArea("TMP")     
Return

Static Function Gerando()
Local cQuery

//-----------------------------------------------------------------------
// MONTA A QUERY
//-----------------------------------------------------------------------	 

cQuery := " SELECT STJ.TJ_ORDEM,STJ.TJ_DTORIGI,STJ.TJ_CODBEM,ST9.T9_NOME,STJ.TJ_SERVICO, STJ.TJ_CENTRAB,STJ.TJ_CCUSTO,STJ.TJ_MAQSIT, STJ.TJ_HRDIGIT,"
cQuery += "	STJ.TJ_TERMINO,STJ.TJ_MAQSIT,STJ.TJ_HRPARAD, STJ.TJ_DTPRINI, STJ.TJ_DTPRFIM,STJ.TJ_DTORIGI, STJ.TJ_HRPARAD, STL.TL_HOFIM, STL.TL_HOINICI,"
cQuery += "	STJ.TJ_HOPRINI, STJ.TJ_OBSERVA, STJ.TJ_HOPRFIM, CTT.CTT_DESC01,STJ.R_E_C_N_O_ AS TJ_RECNO, C1.C1_NUM"

cQuery += " FROM " + RetSqlName('STJ') + " STJ (NOLOCK) "

cQuery += " INNER JOIN " + RetSqlName('ST9') + " ST9 (NOLOCK) ON " 
cQuery += "		ST9.T9_FILIAL = '"+xFilial("ST9")+"' "
cQuery += "	AND STJ.TJ_CODBEM = ST9.T9_CODBEM "
cQuery += " AND ST9.T9_OPERAC BETWEEN '"+ mv_par15 +"' AND '"+ mv_par16 +"'"
cQuery += "	AND ST9.D_E_L_E_T_ = ' ' "

cQuery += " INNER JOIN " + RetSqlName('CTT') + " CTT  (NOLOCK) ON " 
cQuery += " 	CTT.CTT_FILIAL = '"+xFilial("CTT")+"' "
cQuery += "	AND CTT.CTT_CUSTO = STJ.TJ_CCUSTO "
cQuery += "	AND CTT.D_E_L_E_T_ = ' ' "

cQuery += " LEFT JOIN " + RetSqlName('STL') + " STL  (NOLOCK) ON "
cQuery += "		STL.TL_FILIAL = '"+ xFILIAL("STL")+"' " 
cQuery += "	AND STJ.TJ_ORDEM = STL.TL_ORDEM "
cQuery += "	AND STL.TL_TIPOREG = 'M' "
cQuery += " AND STL.TL_CODIGO BETWEEN '"+MV_PAR19+"' AND '"+MV_PAR20+"'"
cQuery += "	AND STL.D_E_L_E_T_ = ' ' "

cQuery += " LEFT JOIN " + RetSqlName("SC1")+" C1  (NOLOCK) ON "
cQuery += "		C1.C1_FILIAL = '"+ xFILIAL("SC1")+"' " 
cQuery += " AND C1.C1_OS = STJ.TJ_ORDEM "
cQuery += "	AND C1.D_E_L_E_T_ = ' ' "

cQuery += "	WHERE STJ.TJ_SITUACA <> 'C' "

If mv_par12 == 2 //deficiente
	cQuery += " AND STJ.TJ_MAQSIT = 'D'"
ElseIf mv_par12 == 1 //parada
	cQuery += " AND STJ.TJ_MAQSIT = 'P'"
EndIf

if MV_PAR09 == 1//Sำ ABERTAS
	cQuery += "	AND STJ.TJ_TERMINO = 'N' "
Elseif MV_PAR09 == 2//Sำ FECHADAS
	cQuery += "	AND STJ.TJ_TERMINO = 'S' "
endif 

cQuery += "	AND STJ.TJ_SERVICO BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 +"' "
cQuery += "	AND STJ.TJ_CENTRAB BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 +"' "
cQuery += " AND STJ.TJ_CODBEM BETWEEN '"+mv_par10+"' AND '"+mv_par11+"'"
cQuery += " AND STJ.TJ_STFOLUP BETWEEN '"+mv_par21+"' AND '"+mv_par22+"'"
cQuery += "	AND STJ.TJ_ORDEM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 +"' "
cQuery += " AND STJ.TJ_CCUSTO BETWEEN '"+MV_PAR13+"' AND '"+MV_PAR14+"'"
cQuery += "	AND STJ.TJ_DTORIGI BETWEEN '" + Dtos(Mv_par03) + "' AND '" + Dtos(Mv_par04) + "'"  
cQuery += "	AND STJ.D_E_L_E_T_ = ' ' "


/*
IF MV_PAR09 == 3 //AMBAS
	cQuery += "	AND (STJ.TJ_DTORIGI BETWEEN '" + Dtos(Mv_par03) + "' AND '" + Dtos(Mv_par04) + "' OR "  
	cQuery += " STJ.TJ_DTPRFIM BETWEEN '" + Dtos(Mv_par03) + "' AND '" + Dtos(Mv_par04) + "')"
ENDIF
*/

//cQuery += "	ORDER BY STJ.TJ_CCUSTO,STJ.TJ_DTORIGI, STJ.TJ_CODBEM, STJ.TJ_ORDEM ASC "
cQuery += " ORDER BY STJ.TJ_CCUSTO, STJ.TJ_CODBEM, STJ.TJ_DTORIGI"

TCQUERY cQuery NEW ALIAS "TMP"

TMP->(DbGotop())     

Return

Static Function Imprime()
Local _cNumOS , cQuery1 
Local _aMatSc := {}
Local _cSC := ""         
Local _numrec := 0
Local aInsumo := {}
 
Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

_cNumOS := TMP->TJ_ORDEM

While TMP->(!Eof())
    _numrec++
	TMP->(DbSkip())
EndDo

SetRegua(_numrec)

TMP->(DbGoTop())

STL->(DBSETORDER(1))

DBSELECTAREA("TPL")
DBSETORDER(1)//TPL_FILIAL+TPL_ORDEM+TPL_CODMOT+DTOS(TPL_DTINIC)+TPL_HOINIC+DTOS(TPL_DTFIM)+TPL_HOFIM

DbSelectArea("STJ")
DbSetOrder(1)

DBSELECTAREA("STN")
DBSETORDER(1)//TN_FILIAL+TN_ORDEM+TN_PLANO+TN_TAREFA+TN_SEQRELA+TN_CODOCOR+TN_CAUSA+TN_SOLUCAO

//DBSELECTAREA("SRA")
//DBSETORDER(1)
DBSELECTAREA("ST1")
DBSETORDER(1) // T1_FILIAL+T1_CODFUNC
							
DBSELECTAREA("TPJ")
DBSETORDER(1)//TPJ_FILIAL+TPJ_CODMOT

While TMP->(!Eof())      

	_cNumOS := TMP->TJ_ORDEM
	IncRegua()
	
	IF TMP->TJ_DTORIGI == DTOS(MV_PAR03)
		IF TMP->TJ_HOPRINI < MV_PAR17 .OR. ;
		   TMP->TJ_HRPARAD < MV_PAR17 .OR. ;
		   TMP->TL_HOINICI < MV_PAR17
			
			TMP->(DbSkip())
			Loop
			
		ENDIF
	ENDIF
	
	IF TMP->TJ_DTORIGI == DTOS(MV_PAR04)
		IF TMP->TJ_HOPRFIM > MV_PAR18 .OR.;
		   TMP->TJ_HOPRFIM > MV_PAR18 .OR.;
		   TMP->TL_HOFIM > MV_PAR18
			
			TMP->(DbSkip())
			Loop
			
		ENDIF
	ENDIF 

	//---------------------------------------------------------------------
	// FILTRA OSS QUE NAO TENHAM MAO DE OBRA DENTRO DE MV_PAR19 E MV_PAR20 
	//---------------------------------------------------------------------
//	IF SM0->M0_CODIGO = "FN" //EMPRESA FUNDICAO 
		lPula := .T.
	
		STL->(DbSetOrder(1)) // FILIAL + ORDEM
		If STL->(DbSeek(xFilial("STL")+TMP->TJ_ORDEM))
			While STL->(!EOF()) .AND. STL->TL_ORDEM == TMP->TJ_ORDEM
				If STL->TL_CODIGO >= MV_PAR19 .AND. STL->TL_CODIGO <= MV_PAR20
					lPula := .F.
				EndIf 
        		STL->(DBSKIP())
	  		EndDo
	  	Else
	  		If EMPTY(MV_PAR19) .AND. "ZZZ"$MV_PAR20
	  			lPula := .F.
	  		EndIf
	  	EndIf
  		
  		If lPula
  			TMP->(DbSkip())
  			Loop
  		EndIf

//    ENDIF
		
	@Prow()+1, 001 psay TMP->TJ_ORDEM
	@Prow()  , 010 psay STOD(TMP->TJ_DTORIGI) Picture "99/99/9999"
	@Prow()  , 023 psay ALLTRIM(TMP->TJ_CODBEM)
	@Prow()  , 040 psay ALLTRIM(TMP->T9_NOME)
	@Prow()  , 085 psay TMP->TJ_MAQSIT
	@Prow()  , 088 psay ALLTRIM(TMP->CTT_DESC01)
	@Prow()  , 120 psay TMP->TJ_CENTRAB
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ BUSCA A SC E OS ITENS DA SC DE CADA OS. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Select("TMA") > 0
		TMA->(DbCloseArea())
	EndIf
	
	cQuery1 := "SELECT C1.C1_NUM, C1.C1_ITEM, C1.C1_DESCRI FROM "+RetSqlName("SC1")+" C1"
	cQuery1 += " WHERE C1.C1_ORDSERV = '"+TMP->TJ_ORDEM+"'"
	cQuery1 += " AND C1.D_E_L_E_T_ = ' ' AND C1.C1_FILIAL = '"+XFILIAL("SC1")+"'"
	
	TCQUERY cQuery1 NEW ALIAS "TMA"
	
	While TMA->(!Eof())
		aAdd(_aMatSc,{TMA->C1_NUM, TMA->C1_ITEM, TMA->C1_DESCRI})
		TMA->(DBSKIP())
	EndDo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณIMPRIME HORA INICIAL E HORA FINAL DA O.S.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Empty(TMP->TJ_DTPRINI)
		@Prow()  , 130 psay STOD(TMP->TJ_DTORIGI) Picture "99/99/9999"
	Else
		@Prow()  , 130 psay STOD(TMP->TJ_DTPRINI) Picture "99/99/9999"
	EndIf
	
	If Empty(TMP->TJ_HOPRINI)
		@Prow()  , 145 psay TMP->TJ_HRDIGIT
		//Se Vazio Data final da parada
		If Empty(TMP->TJ_DTPRFIM)
			_nDias := ((Date() - STOD(TMP->TJ_DTORIGI)))*24
		Else
			_nDias := ((STOD(TMP->TJ_DTPRFIM) - STOD(TMP->TJ_DTORIGI)))*24
		EndIf
		
		//Se vazio hora final da parada
		If Empty(TMP->TJ_HOPRFIM)
			_nDias += (HoraToInt(Time()) - HoraToInt(TMP->TJ_HRDIGIT))
		Else
			_nDias += (HoraToInt(TMP->TJ_HOPRFIM) - HoraToInt(TMP->TJ_HRDIGIT))
		EndIf
	Else
		@Prow()  , 145 psay TMP->TJ_HOPRINI
		If Empty(TMP->TJ_DTPRFIM)
			_nDias := ((Date() - STOD(TMP->TJ_DTPRINI)))*24
		Else
			_nDias := ((STOD(TMP->TJ_DTPRFIM) - STOD(TMP->TJ_DTPRINI)))*24
		EndIf
		
		If Empty(TMP->TJ_HOPRFIM)
			_nDias += (HoraToInt(Time()) - HoraToInt(TMP->TJ_HOPRINI))
		Else
			_nDias += (HoraToInt(TMP->TJ_HOPRFIM) - HoraToInt(TMP->TJ_HOPRINI))
		EndIf
	EndIf
	
	@Prow()  , 155 psay STOD(TMP->TJ_DTPRFIM) Picture "99/99/9999"
	@Prow()  , 170 psay TMP->TJ_HOPRFIM
	
	@ Prow() , 178 Psay IntToHora(_nDias,LEN(alltrim(TRANSFORM(INT(_nDias),"@e 99999"))))
	
	STJ->(Dbgoto(TMP->TJ_RECNO))
	nLinha = MlCount(Alltrim(STJ->TJ_OBSERVA))
	
	@ Prow()+2 , 034 Psay "DEFEITO PROD.:"
	if nLinha < 1
		@ Prow()   , 050 Psay "- - -"
	Else
		For x:=1 to nLinha
			@ Prow()+Iif(x==1,0,1), 050 Psay MemoLine(STJ->TJ_OBSERVA,70,x)
		Next
	Endif 
	
	aInsumo := {}
	
	//IMPRIME OS INSUMOS
	IF STL->(DBSEEK(XFILIAL("STL")+TMP->TJ_ORDEM))
    
		WHILE STL->(!EOF()) .AND. STL->TL_ORDEM == TMP->TJ_ORDEM
			
			aAdd(aInsumo,{STL->TL_ORDEM,;   //1
						  STL->TL_SEQRELA,; //2
						  STL->TL_OBSERVA,; //3
						  STL->TL_DTINICI,; //4
						  STL->TL_HOINICI,; //5
						  STL->TL_DTFIM,;   //6
						  STL->TL_HOFIM,;   //7
						  STL->TL_CODIGO})  //8
		
			STL->(dbSkip())
		EndDo
	EndIf
	
	//ordena os insumos por data, hora
	aSort(aInsumo,,,{|x,y| DtoS(x[4])+x[5] < DtoS(y[4])+y[5]}) //ordena por m๓dulo e nome
	
	For x:=1 to Len(aInsumo)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณIMPRIME AS OBS. DE OCORRENCIAS (24/11/2008)ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		IF STN->(DbSeek(xFilial("STN")+TMP->TJ_ORDEM))
				
			WHILE STN->(!EOF()) .AND. STN->TN_ORDEM == TMP->TJ_ORDEM
					
				IF STN->TN_SEQRELA != aInsumo[x][2]
					STN->(DBSKIP())
					LOOP
				ENDIF
		
				fVerRow()					
				
				//------------OCORRENCIA
				nLinha = MlCount(Alltrim(STN->TN_OBSOCOR),70)
					
				@ Prow()+2 , 034 Psay "DEFEITO MANUT.: "

				If nLinha < 1
					@ Prow()   , 050 Psay "- - -"
				Else
					For y:=1 to nLinha
						@ Prow()+Iif(y==1,0,1) , 050 Psay MemoLine(STN->TN_OBSOCOR,70,y)
					Next
				EndIf
				
				fVerRow()				
				
				//--------------CAUSA
				nLinha := MlCount(Alltrim(STN->TN_OBSCAUS),70)
				
				@ Prow()+2 , 034 Psay "CAUSA.:"
				if nLinha < 1
					@ Prow()   , 050 Psay "- - -"
				Else
					For y:=1 to nLinha
						@ Prow()+Iif(y==1,0,1) , 050 Psay MemoLine(STN->TN_OBSCAUS,70,y)
					Next
				EndIf
				
				fVerRow()					
					
				//----------------SOLUCAO
				nLinha = MlCount(Alltrim(STN->TN_OBSSOLU),70)
					
				@ Prow()+2 , 034 Psay "SOLUCAO.:"
				If nLinha < 1
					@ Prow()   , 050 Psay "- - -"
				Else
					For y:=1 to nLinha
						@ Prow()+Iif(y==1,0,1) , 050 Psay MemoLine(STN->TN_OBSSOLU,70,y)
					Next
				EndIf
					
				fVerRow()		                 
				
				STN->(dbSkip())
		
			ENDDO
	
		ENDIF
		
		nLinha := MlCount(Alltrim(aInsumo[x][3]),70)
			
		@ Prow()+2 , 034 Psay "OBSERVACAO.:"
		@ Prow()   , 130 Psay aInsumo[x][4] Picture "99/99/9999"
		@ Prow()   , 145 Psay aInsumo[x][5]
		@ Prow()   , 155 Psay aInsumo[x][6] Picture "99/99/9999"
		@ Prow()   , 170 Psay aInsumo[x][7]

//		IF SRA->(DBSEEK(XFILIAL('SRA')+ALLTRIM(aInsumo[x][8])))
//			@ Prow()   , 186 Psay ALLTRIM(aInsumo[x][8]) + " - " + SUBSTR(SRA->RA_NOME,1,25)
//		ENDIF

		IF ST1->(DBSEEK(XFILIAL('ST1')+ALLTRIM(aInsumo[x][8])))
			@ Prow()   , 186 Psay ALLTRIM(aInsumo[x][8]) + " - " + SUBSTR(ST1->T1_NOME,1,25)
		ENDIF

		if nLinha < 1
			@ Prow()   , 050 Psay "- - -"
		Else		
			For y:=1 to nLinha
				@ Prow()+Iif(y==1,0,1) , 050 Psay MemoLine(aInsumo[x][3],70,y)
			Next
		EndIf
	
		fVerRow()	
	
		@ Prow()+1 , 034 Psay Repli("-",186)
	
	Next
	
	//ATRASO --------------------------------
	If TPL->(DbSeek(xFilial("TPL")+TMP->TJ_ORDEM))
		
		While TPL->TPL_ORDEM == TMP->TJ_ORDEM
			@ Prow()+2 , 034 Psay "ATRASO.:"
			
			If TPJ->(DBSEEK(XFILIAL("TPJ")+TPL->TPL_CODMOT))
				@ Prow()   , 050 Psay TPJ->TPJ_DESMOT
			EndIf
			
			@ Prow()   , 130 Psay TPL->TPL_DTINIC Picture "99/99/9999"
			@ Prow()   , 145 Psay TPL->TPL_HOINIC
			@ Prow()   , 155 Psay TPL->TPL_DTFIM Picture "99/99/9999"
			@ Prow()   , 170 Psay TPL->TPL_HOFIM
			
			TPL->(DBSKIP())
		ENDDO
	EndIf
	
	While _cNumOS == TMP->TJ_ORDEM
		IncRegua()
		TMP->(Dbskip())
	EndDo
	
	If !Empty(_aMAtSC)
		
		For i:=1 to len(_aMatSC)
			
			fVerRow()
	
			If _cSC <> _aMatSC[i][1]
				@ prow()+2,034 PSAY "S.C.: "
				@ prow()  ,050 PSAY _aMatSC[i][1]
				_cSC := _aMatSC[i][1]
			EndIf
			@ prow()+1,034 PSAY "ITEM: "+_aMatSC[i][2] +" "
			@ prow()  ,050 PSAY _aMatSC[i][3]
		Next
	EndIf
	
	@ prow()+1,000 PSAY __PrtThinLine()
	
	fVerRow()	
	
	_aMatSc := {}

EndDo

TMP->(DbCloseArea())          

Return(nil)      

Static Function fVerRow()
	If Prow() > 65
		_nPag  := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif
Return