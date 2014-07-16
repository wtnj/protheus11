/*                                                              
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                    
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHPCP010  ³ Autor ³ Fabio Nico             Data ³ 07/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Digitacao de Fornadas                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Fusão                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"                   	
#INCLUDE "TOPCONN.CH"

User Function nhpcp010()

//----------------------------------------------------------------------------------------------------
//  CRIACAO DE VARIAVEIS
//----------------------------------------------------------------------------------------------------
SetPrvt("_cArqDbf, cQuery,_aFields,aCampos,cMarca,cARQEXP ,cARQ,_auxdoc,_auxforno")   
SetPrvt("nMax,aHeader,aCols,oMultiline,oDialog,nI,_cForno,_cLiga,lMsErroAuto,_TOTLIN")
SetPrvt("aMatriz,_Colunas,_Insere,_TotLinha1,_qtde,_SolNor")  
SetPrvt("CCADASTRO,AROTINA,_aCabec,VSoma,_soma,_qtde2,_RHora,TOT_HORAS")

_cArqDBF:=SPACE(12) 
aHeader  	:= {}
aCols    	:= {}  
aTotal 	 	:= {}           
_Colunas 	:= 0
_Insere 	:= 0
vSoma 		:= 0
_soma 		:= 0
_TotLinha1 	:= 0
_qtde2      := 0
_aCabec  	:= {}
_RHora		:= .F.   //  AUXILIAR NA VERIFICACAO DAS HORAS
TOT_HORAS	:= 0     //  TOTAL DE MINUTOS UTILIZADOS -  GRAVA NO SD4
Private nOpc   := 0
Private bOk    := {||nOpc:=1,_SolNor:End()}
Private bCancel:= {||nOpc:=0,_SolNor:End()} 

//----------------------------------------------------------------------------------------------------
//  VERIFICACAO DA EMPRESA
//----------------------------------------------------------------------------------------------------
IF SM0->M0_CODIGO <> "FN" //empresa new hubner	
   Msgbox("Esta Rotina So Pode Ser Utilizada na Fundicao!!!" ,"Atencao","ALERT" )  
   Return
Endif

cCadastro := OemToAnsi("Digitacao de Fornadas ")
aRotina := {{ "Pesquisa"  ,'AxPesqui'     ,0,1},;
            { "Fornada"	  ,'U_digf1()'	  ,0,2},;
            { "Legenda"   ,'U_For002()'	  ,0,3},;
            { "Novo Prod" ,'U_For003()'   ,0,4}}

DbSelectArea("SC2")
SC2->(DbSetOrder(1))
mBrowse( 6, 1,22,75,"SC2",,"SC2->C2_DATRF<>CTOD('//')",,,,)
Return(nil)                                              

User Function digf1(cpar)
if SC2->C2_DATRF<>CTOD('//') .or. SC2->C2_SEQUEN <> '001'
   alert("ORDEM DE PRODUCAO JA FINALIZADA OU SEQUENCIA INVALIDA !!!! ")
   return
endif               

_produto := ALLTRIM(SC2->C2_PRODUTO)

Processa( {|| gera_teste() } )

//----------------------------------------------------------------------------------------------------
//  MULTILINE 
//----------------------------------------------------------------------------------------------------
DbSelectArea("SZZ")

@ 010,005 TO 400,820 DIALOG oDlg TITLE "Acompanhamento de Fusão  " + _produto
@ 003,005 TO 150,400 MULTILINE MODIFY DELETE VALID Val_linha() OBJECT oMultiline
@ 180,025 BUTTON OemToAnsi("NOVA Fornada  ") SIZE 50,10  ACTION IlinhaRod()
@ 180,080 BUTTON OemToAnsi(" Grv.Fornada  ") SIZE 50,10  ACTION fGrvOrd()  
@ 180,135 BUTTON OemToAnsi("  Recalcula   ") SIZE 50,10  ACTION IRecalcula()  
@ 180,190 BUTTON OemToAnsi("Saida Fornadas") SIZE 50,10  ACTION fSaida()
@ 180,245 BUTTON OemToAnsi("   Finaliza   ") SIZE 50,10  ACTION fConfirma()  
//@ 180,300 BUTTON OemToAnsi("Carrega Ponte" ) SIZE 50,10  ACTION fPonte()    

oMultiline:nMax := Len(aCols)
ACTIVATE MsDialog oDlg CENTER
            
DbSelectArea("TMP")
DbCloseArea("TMP")
DbSelectArea("TMB")
DbCloseArea("TMB") 
DbSelectArea("SZZ")                                                                         
DbCloseArea("SZZ") 

Return

User Function For003()
Private cProd  := Space(15)
Private cDescP := ""

 	Define MsDialog oDlgNP Title OemToAnsi("Novo Empenho") From 030,015 To 145,350 Pixel
	
	@ 010,010 Say "OP: " Size 30,10
	@ 010,040 Say SC2->C2_NUM Size 40,10
	@ 021,010 Say "Produto: " Size 30,10
	@ 019,040 Get cProd Picture "@!" F3 "SB1" Size 60 ,10 Valid fValPrd()
	@ 032,010 Say "Descrição: " Size 40,10
	@ 031,040 Get cDescP When .F. Size 122,10 object oDescP
    @ 043,105 BMPBUTTON TYPE 01 ACTION fGrvNewP()
    @ 043,135 BMPBUTTON TYPE 02 ACTION oDlgNP:End()

	Activate MsDialog oDlgNP Center

Return

Static Function fGrvNewP()

	RecLock("SD4",.T.)
		SD4->D4_FILIAL := xFilial("SD4")
		SD4->D4_COD    := cProd
		SD4->D4_LOCAL  := "24"
		SD4->D4_OP     := SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN
		SD4->D4_DATA   := Date()
	MsUnlock("SD4")
	
	oDlgNP:End()
	
Return

Static Function fValPrd()

	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(xFilial('SB1')+cProd))
		If ALLTRIM(UPPER(SB1->B1_GRUPO))$"MP01"
			cDescP   := SB1->B1_DESC
			oDescP:Refresh()
		Else
			Alert("Produto deve ser do grupo MP01!")
			Return .F.
		EndIf
	Else
		Alert("Produto não encontrado!")
		Return .F.
	EndIf
	
Return .T.

//----------------------------------------------------------------------------------------------------------
//  GERACAO DO ARQUIVO TEMPORARIO PARA CRIACAO DO MULTILINE
//----------------------------------------------------------------------------------------------------------
STATIC FUNCTION GERA_TESTE()

procregua(6)

aHeader  	:= {}
aCols 		:= {}
_TotLinha1  := 0

AADD(aCols,{" ",0,0,SPACE(5),0,"",0,0,CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,.f.})
cQuery := "SELECT D4.D4_COD,D4.D4_FILIAL,D4.D4_OP,D4.D4_QTDEORI,D4.D4_DATA, B1.B1_TIPO "
cQuery += " FROM " + RetSqlName( 'SD4' ) +" D4 (NOLOCK), "  + RetSqlName( 'SB1' ) +" B1  (NOLOCK)"
cQuery += " WHERE D4.D4_OP = '" + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN +  "'"  
cQuery += " AND SUBSTRING(D4.D4_COD,1,3) <> 'MOD' "
cQuery += " AND SUBSTRING(D4.D4_COD,1,2) <> 'RT' "
cQuery += " AND B1.B1_TIPO NOT IN ('PI','RT') "
cQuery += " AND B1.B1_COD = D4.D4_COD "
cQuery += " AND D4.D_E_L_E_T_ = '' "
cQuery += " AND B1.D_E_L_E_T_ = '' "
cQuery += " ORDER BY D4.D4_COD,D4.D4_FILIAL,D4.D4_OP "

//MemoWrit('C:\TEMP\PCP010.SQL',cQuery)
TCQUERY cQuery NEW ALIAS "TMP"
TMP->(DBGotop())     

incproc()

aCols[1,1] := TMP->D4_OP    //  OP
aCols[1,2] := 0    			// FORNADA
aCols[1,3] := 0             // FORNO 
aCols[1,4] := SPACE(5)      // LIGA    
aCols[1,5] := 0             // CORRIDA
aCols[1,6] := "" 			// DISA
aCols[1,7] := 0 			// PANELA
aCols[1,8] := 0 			// MLL
aCols[1,9] := date()        //  DATA
aCols[1,10] := '00:00'       // HRINI
aCols[1,11] := date()        //  DATA
aCols[1,12] := '00:00'	    // HRFIM
aCols[1,13] := date()        //  DATA
aCols[1,14] := '00:00'		// INIVAZ
aCols[1,15] := date()        //  DATA
aCols[1,16] := '00:00'		// FIMVAZ    

_Colunas := 16
While TMP->(!EOF())
	_Colunas := _Colunas + 1
	aCols[1,_Colunas] := TMP->D4_QTDEORI
	_TotLinha1 := _TotLinha1 + TMP->D4_QTDEORI
	TMP->(DbSkip())
enddo

incproc()

//--------------------------------------------------------------------------------------------------------------
// APENAS PARA CRIAR O ARQUIVO NO SQL
// Axcadastro("SZZ","CRIA ARQ FUSAO")     
//--------------------------------------------------------------------------------------------------------------
cQuery1 := "SELECT * FROM " + RetSqlName( 'SZZ' ) +" SZZ  (NOLOCK)"
cQuery1 += "WHERE SZZ.ZZ_OP = '" + SC2->	C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + "'"
cQuery1 += "AND SZZ.D_E_L_E_T_ = '' "
//cQuery1 += "ORDER BY SZZ.ZZ_OP,SZZ.ZZ_FORNADA,SZZ.ZZ_PRODUTO,SZZ.ZZ_CORRIDA " 
cQuery1 += "ORDER BY SZZ.ZZ_OP,SZZ.ZZ_CORRIDA,SZZ.ZZ_FORNO, SZZ.ZZ_DINIFUS, SZZ.ZZ_PRODUTO,SZZ.ZZ_FORNADA " 
TCQUERY cQuery1 NEW ALIAS "TMB"

incproc()

TMB->(DBGotop())    
//AUX_FORNAD := TMB->ZZ_FORNADA
AUX_CORRIDA := AllTRIM(STR(TMB->ZZ_CORRIDA)) + AllTrim(Str(TMB->ZZ_FORNO)) + TMB->ZZ_DINIFUS

X := 1                         
while TMB->(!EOF())
    AADD(aCols,{" ",0,0,SPACE(5),0,"",0,0,CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,.f.})
	X++
	aCols[X,01] := TMB->ZZ_OP
	aCols[X,02] := TMB->ZZ_FORNADA
	aCols[X,03] := TMB->ZZ_FORNO
	aCols[X,04] := TMB->ZZ_LIGA
	aCols[X,05] := TMB->ZZ_CORRIDA

	aCols[X,06] := TMB->ZZ_DISA
	aCols[X,07] := TMB->ZZ_PANELA
	aCols[X,08] := TMB->ZZ_MLL
	aCols[X,09] := STOD(TMB->ZZ_DINIFUS)
	aCols[X,10] := TMB->ZZ_HRINI         
	aCols[X,11] := STOD(TMB->ZZ_DFIMFUS)	
	aCols[X,12] := TMB->ZZ_HRFIM
	aCols[X,13] := STOD(TMB->ZZ_DINIVAZ)
	aCols[X,14] := TMB->ZZ_INIVAZ       
	aCols[X,15] := STOD(TMB->ZZ_DFIMVAZ)	
	aCols[X,16] := TMB->ZZ_FIMVAZ    

	While  ALLTRIM(STR(TMB->ZZ_CORRIDA)) + AllTrim(Str(TMB->ZZ_FORNO)) + TMB->ZZ_DINIFUS == AUX_CORRIDA     // TMB->(!EOF())
		
		TMP->(dbgotop())

		_ColF := 16
		While TMP->(!EOF())
			_ColF += 1                                          

			If TMP->D4_COD==TMB->ZZ_PRODUTO
				aCols[X,_Colf] := TMB->ZZ_QTDE
			EndIf
			
			TMP->(dbSkip())
		EndDo
		TMB->(DbSkip())		
		
	enddo
	
	AUX_CORRIDA := ALLTRIM(STR(TMB->ZZ_CORRIDA)) + AllTrim(Str(TMB->ZZ_FORNO)) + TMB->ZZ_DINIFUS
	
enddo

incproc()

Processa( {|| gera_multi() } )  

AADD(aCols,{"SALDO TOTAL",0,0,SPACE(5),0,"",0,0,CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,.f.})
                          
	if len(acols) == 2
	for gg := 17 to len(aheader)
		aCols[2,gg] := aCols[1,gg]
	next
else
	for gg := 17 to len(aheader)
		for x:=2 to len(acols)-1
	 		_soma := _soma + aCols[x,gg]	  
		next
        aCols[len(acols),gg] := aCols[1,gg] - _soma 
		_soma := 0
	next
endif

incproc()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ COPIA A PRIMEIRA DATA DIGITADA PARA OS OUTROS CAMPOS DE DATA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function PCP10DT()
Local dDt := M->ZZ_DINIFUS

	aCols[n][11] := dDt
	aCols[n][13] := dDt
	aCols[n][15] := dDt
	oMultiline:Refresh()

Return .T.

//----------------------------------------------------------------------------------------------------------------
//  MONTA O CABECALHO DO MULTILINE
//----------------------------------------------------------------------------------------------------------------
Static Function gera_Multi()

Aadd(aHeader,{"Ord.Prod"   , "ZZ_OP"		, "@!"          ,15,0,".F.","","C","SZZ"})  // 1
Aadd(aHeader,{"Fornada"    , "ZZ_FORNADA"	, "999"         , 3,0,".F.","","N","SZZ"})  // 2
Aadd(aHeader,{"Forno"      , "ZZ_FORNO"		, "999"         , 1,0,".T.","","N","SZZ"})  // 3
Aadd(aHeader,{"Liga"       , "ZZ_LIGA" 		, "@!"          , 5,0,".T.","","C","SZZ"})  // 4
Aadd(aHeader,{"Corrida"    , "ZZ_CORRIDA"	, "9999"        , 4,0,".T.","","N","SZZ"})  // 5
Aadd(aHeader,{"Disa"       , "ZZ_DISA"   	, "@!"          , 1,0,".T.","","C","SZZ"})  // 6
Aadd(aHeader,{"Panela"     , "ZZ_PANELA"   	, "999"         , 3,0,".T.","","N","SZZ"})  // 7
Aadd(aHeader,{"MLL"        , "ZZ_MLL"    	, "99999.99"    , 5,2,"Positivo()" ,"","N","SZZ"})  // 8
Aadd(aHeader,{"Dt.Ini Fus" , "ZZ_DINIFUS"	, "99/99/99"    , 8,0,"U_PCP10DT()","","C","SZZ"})  // 9
Aadd(aHeader,{"Hr Ini"     , "ZZ_HRINI" 	, "99:99"       , 5,0,".T.","","C","SZZ"})  // 10
Aadd(aHeader,{"Dt.Fim Fus" , "ZZ_DFIMFUS"  	, "99/99/99"    , 8,0,".T.","","C","SZZ"})  // 11
Aadd(aHeader,{"Hr Fim"     , "ZZ_HRFIM" 	, "99:99"       , 5,0,".T.","","C","SZZ"})  // 12
Aadd(aHeader,{"Dt.Ini Vaz" , "ZZ_DINIVAZ" 	, "99/99/99"    , 8,0,".T.","","C","SZZ"})  // 13
Aadd(aHeader,{"V. Ini"     , "ZZ_INIVAZ"  	, "99:99"       , 5,0,".T.","","C","SZZ"})  // 14
Aadd(aHeader,{"Dt.Fim Vaz" , "ZZ_DFIMVAZ" 	, "99/99/99"    , 8,0,".T.","","C","SZZ"})  // 15
Aadd(aHeader,{"V. Fim"     , "ZZ_FIMVAZ"  	, "99:99"       , 5,0,".T.","","C","SZZ"})  // 16

//_Colunas := 12
TMP->(DBGotop())

While !TMP->(EOF())
//			_Colunas := _Colunas + 1      //  totaliza o total de colunas a serem criadas.
	Aadd(aHeader,{TMP->D4_COD,"ZZ_QTDE","@E 99999999.99" ,11,2,".T.","","N","SZZ"})
	TMP->(DbSkip())
enddo
Return


//----------------------------------------------------------------------------------------------------
//   INCLUI NOVA LINHA NO ACOLS
//----------------------------------------------------------------------------------------------------
Static Function IlinhaRod()
_Insere = Len(aCols)
aCols[_Insere,01] := aCols[1,1]	  

nProxForn := aCols[1,2]

For xC:=1 to len(aCols)
	if aCols[xC,2] > nProxForn 
		nProxForn := aCols[xC,2]
	endif
Next

aCols[_Insere,02] := nProxForn + 1 //aCols[_Insere-1,2]+1 

aCols[_Insere,09] := date()
aCols[_Insere,11] := date()
aCols[_Insere,13] := date()
aCols[_Insere,15] := date()

for x:=17 to len(aheader)
    aCols[len(aCols),x] := 0
next

AADD(aCols,{"SALDO TOTAL",0,0,SPACE(5),0,"",0,0,CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,.f.})
_soma := 0
X := 1                        

for gg := 17 to len(aheader)
	for x:=2 to len(acols)-1
 		_soma += aCols[x,gg]	  
	next
	aCols[len(acols),gg] := aCols[1,gg] - _soma 
	_soma := 0
next
dlgRefresh(oDlg)
Return                                                      


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CARREGA AS INFORMAÇÕES DA TABELA ZE0 COLETADAS PELA PONTE E ADICIONA NO ACOLS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fPonte()
Local nPos  := 0
Private cAl := getNextAlias()

    IlinhaRod() //Inicia a funcao de digitacão de fornada
   	geraZE0() 

   	If (cAl)->(!eof())
   	
   		// zera todas as quantidades da penultima linha do acols
   		For xH:=1 to Len(aHeader)
   			If Substr(aHeader[xH][1],1,2)=="MP" .AND. aHeader[xH][2]=="ZZ_QTDE"
	   			aCols[Len(aCols)-1][xH] := 0
	   		EndIf
   		Next
    
    	// adiciona as quantidades encontradas na tabela ZE0 (Leitura da Ponte)
	    While (cAl)->(!Eof())
	    
	    	nPos := Ascan(aHeader,{|x| Alltrim(Upper(x[1]))==AllTrim(Upper((cAl)->prod))} )
	    	
	    	If nPos!=0
	    		aCols[Len(aCols)-1][nPos] := (cAl)->quant
	    	Else
	    		Alert("Adicionar o produto "+(cAl)->prod+" quantidade "+AllTrim(Str((cAl)->quant)))
	    	EndIf

			(cAl)->(dbSkip())
			
		EndDo
	Else
		Alert("Não foram coletadas informações da Ponte referentes a esta OP!")
		Return
	Endif
	
	calcula_saldo()

	oMultiLine:Refresh()
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FAZ A QUERY PARA BUSCAR AS QUANTIDADES NA TABELA ZE0 LIDAS PELA PONTE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function geraZE0()

	beginSql Alias cAl
		SELECT
				ZE0_OP 		op
			,   ZE0_FORNO 	forno
			,	ZE0_PROD	prod
			,	SUM(ZE0_QUANTR) quant
		FROM
			%Table:ZE0% ZE0 (NOLOCK)
		WHERE 
				ZE0_OP = %Exp:SC2->C2_NUM%
			AND ZE0.%NotDel%
 		GROUP BY
				ZE0_OP
			,	ZE0_PROD
			,	ZE0_FORNO
	endSql

Return


Static Function fSaida()            
If MsgBox("Deseja gravar as alterações efetuadas? ","Gravação de Fornadas","YESNO")
	Processa({|| fGrvOrd() }, "Grava Fornada")
endif
Close(oDlg)  
Return

Static Function fConfirma()
	Processa({|| fGrvOrd() }, "Grava Fornada")
	_qtde := 0
 	Define MsDialog _QtdePro Title OemToAnsi("Quantidade final produzida") From 030,015 To 200,420 Pixel
    @ 010,006 To 050,200 Title OemToAnsi("  PRODUÇÃO ") //Color CLR_HBLUE
	@ 030,030 Say "Qtde Pecas Produzidas : " Size 130,50
	@ 025,150 Get _qtde Picture "@E 999999"   
    @ 055,085 BMPBUTTON TYPE 01 ACTION fFinaliza()
	Activate MsDialog _QtdePro Center 
//	Close(_QtdePro)   
Return


//----------------------------------------------------------------------------------------------
//  FINALIZACAO DA DIGITACAO DAS FORNADAS                                                       
//  MESMO APOS FINALIZADA AINDA PODE RECEBER ALTERACAOES 
//----------------------------------------------------------------------------------------------
Static Function fFinaliza()

local aProdSzz := {}
local nPosItem := 0


val_linha() 
if _RHora = .F.
   Return
endif

//--------------------------------------------------------------------------------------------------
//  Verifica se a quantidade digitada nao esta superior a 10 da formulacao
//--------------------------------------------------------------------------------------------------

_multi := alltrim(str(_qtde))

cQuer7 := " SELECT SUM(G1_QUANT) * " + _multi + " AS TOTAL "
cQuer7 += " FROM " + RetSqlName( 'SG1' ) + " G1  (NOLOCK)"
cQuer7 += " WHERE G1_COD = '" + SC2->C2_PRODUTO + "'" 
cQuer7 += " AND G1_COMP LIKE '%MP%' "
cQuer7 += " AND D_E_L_E_T_ = ''"
cQuer7 += " AND G1_FILIAL = '"+xFilial("SG1")+"'"

//MemoWrit('C:\TEMP\PCP11A.SQL',cQuer7)
TCQUERY cQuer7 NEW ALIAS "TMA"                                      

cQuer8 := "SELECT SUM(ZZ_QTDE) AS TOTZZ
cQuer8 += " FROM " + RetSqlName( 'SZZ' ) + " ZZ  (NOLOCK)"
cQuer8 += " WHERE ZZ_OP = '" + ACOLS[1,1] + "'" 
cQuer8 += " AND D_E_L_E_T_ = ''"
cQuer8 += " AND ZZ_FILIAL = '"+xFilial("SZZ")+"'"

//MemoWrit('C:\TEMP\PCP12A.SQL',cQuer8)
TCQUERY cQuer8 NEW ALIAS "TMZ"
                        
TMA->(DbSelectArea("TMA"))
TMZ->(DbSelectArea("TMZ"))

_mais10p := TMA->TOTAL * 1.10

/*
if TMZ->TOTZZ > _mais10p 
   Msgbox("A QUANTIDADE UTILIZADA FOI SUPERIOR A 10% DA QUANTIDADE MAXIMA PERMITIDA!!!" ,"Atencao","ALERT" )  
   Msgbox("QTDE :" + _multi + " TOTAL FORMULA : " + ALLTRIM(str(_mais10p)) + " TOTAL DIGITADO : " + ALLTRIM(STR(TMZ->TOTZZ)) + " " ,"Atencao","ALERT" )  
   TMA->(DbCloseArea("TMA"))
   TMZ->(DbCloseArea("TMZ"))
   Return(.F.)
endif
*/
if TMZ->TOTZZ < TMA->TOTAL
    Msgbox("QUANTIDADE INSUFICIENTE PARA A PRODUCAO APONTADA !!!" ,"Atencao","ALERT" )  
    TMA->(DbCloseArea("TMA"))
    TMZ->(DbCloseArea("TMZ"))
   Return(.F.)
endif

TMA->(DbCloseArea("TMA"))
TMZ->(DbCloseArea("TMZ"))

//--------------------------------------------------------------------------------------------------
//
//--------------------------------------------------------------------------------------------------
cQuer2 := "SELECT ZZ_OP,ZZ_PRODUTO,SUM(ZZ_QTDE) AS TOTAL"
cQuer2 += " FROM " + RetSqlName( 'SZZ' ) +" SZZ  (NOLOCK)"
cQuer2 += " WHERE ZZ_OP = '" + ACOLS[1,1] + "'"  
cQuer2 += " AND SZZ.D_E_L_E_T_ = '' "
cQuer2 += " GROUP BY ZZ_OP,ZZ_PRODUTO" 
MemoWrit('C:\TEMP\NHPCP010.SQL',cQuer2)
TCQUERY cQuer2 NEW ALIAS "BAI"

//--------------------------------------------------------------------------------------------------
// RETORNA A QUANTIDADE EMPENHADA NO SB2                                                            
// ACERTA O EMPENHO NO SB2
// ACERTA A QUANTIDADE NO SD4 PARA O TOTAL DIGITADO NAS FORNADAS
//--------------------------------------------------------------------------------------------------
SD4->(dbSetOrder(2)) // filial + OP + Codigo do produto + local
BAI->(dbGotop())     
aProdSzz := {}

While BAI->(!Eof())
	
	// adiciona o produto no array
	AAdd(aProdSzz, BAI->ZZ_PRODUTO)
	
	If SD4->(dbSeek(xFilial("SD4")+BAI->ZZ_OP+BAI->ZZ_PRODUTO,.T.))

		If SB2->(dbSeek(xFilial("SB2")+SD4->D4_COD+SD4->D4_LOCAL,.T.))
	        RecLock("SB2")
		        SB2->B2_QEMP := SB2->B2_QEMP - SD4->D4_QTDEORI
			MsUnLock("SB2") 
	    Endif
	    
	    If SC2->(dbSeek(xFilial("SD4")+SD4->D4_OP,.T.))
			RecLock("SC2")  
				SC2->C2_QUANT := _QTDE
			MsUnLock("SC2") 
	    Endif
		
		RecLock("SD4",.F.)
			SD4->D4_QTDEORI		:= BAI->TOTAL 
			SD4->D4_QUANT		:= BAI->TOTAL 
		MsUnLock("SD4") 
 	
 	Else
	
		RecLock("SD4",.T.)
			SD4->D4_FILIAL  := xFilial("SD4")
			SD4->D4_COD     := BAI->ZZ_PRODUTO
			SD4->D4_LOCAL   := "24"
			SD4->D4_OP      := BAI->ZZ_OP
			SD4->D4_QUANT   := BAI->TOTAL
			SD4->D4_QTDEORI := BAI->TOTAL
			SD4->D4_DATA    := Date()
		MsUnlock("SD4")

 	Endif
 	
	BAI->(dBskip())
	
EndDo

//-----------------------------------------------------------------------------
//    EFETUA A BAIXA DA MAO DE OBRA
//-----------------------------------------------------------------------------

// Comentado em 22/11/07 a pedido do fernando werner
/*
BAI->(DBGotop())   
DbSelectArea("SD4") 
SD4->(DbSetOrder(2)) 
SD4->(DBGotop())         
SD4->(Dbseek('01'+BAI->ZZ_OP+'MOD',.t.))

while SD4->D4_OP = BAI->ZZ_OP .and. SUBSTR(SD4->D4_COD,0,3) = 'MOD' 

		DbSelectArea("SG1") 
		SG1->(DbSetOrder(2)) 
		SG1->(Dbseek('01'+SD4->D4_COD+_produto,.t.))
        _qtde2 = SG1->G1_QUANT
		DbSelectArea("SD4") 
		RecLock("SD4")
		SD4->D4_QTDEORI		:= _QTDE * _qtde2
		SD4->D4_QUANT		:= _QTDE * _qtde2
		MsUnLock("SD4") 
    	SD4->(DBskip())		
enddo

//-----------------------------------------------------------------------------
// FAZ O AJUSTE DAS MAOS DE OBRA DE MOD201001 E MOD202001
//-----------------------------------------------------------------------------

DbSelectArea("SD4") 
SD4->(DbSetOrder(2)) 
SD4->(DBGotop())         
SD4->(Dbseek('01'+BAI->ZZ_OP+'MOD',.t.))

while SD4->D4_OP = BAI->ZZ_OP 
    if SD4->D4_COD = 'MOD201001'  
		DbSelectArea("SG1") 
		SG1->(DbSetOrder(2)) 
		SG1->(Dbseek('01'+SD4->D4_COD+_produto,.t.))
        _qtde2 = SG1->G1_QUANT
		cal2chora()     //  CALCULO DA QTDE DE HORAS
		DbSelectArea("SD4") 
		RecLock("SD4")
		SD4->D4_QTDEORI		:= TOT_HORAS
		SD4->D4_QUANT		:= TOT_HORAS
		MsUnLock("SD4")
	endif
SD4->(DBskip())
enddo                             

DbSelectArea("SD4") 
SD4->(DbSetOrder(2)) 
SD4->(DBGotop())         
SD4->(Dbseek('01'+BAI->ZZ_OP+'MOD',.t.))

while SD4->D4_OP = BAI->ZZ_OP 
    if SD4->D4_COD = 'MOD202001'                              
		DbSelectArea("SG1") 
		SG1->(DbSetOrder(2)) 
		SG1->(Dbseek('01'+SD4->D4_COD+_produto,.t.))
        _qtde2 = SG1->G1_QUANT
		cal3chora()     //  CALCULO DA QTDE DE HORAS
		DbSelectArea("SD4") 
		RecLock("SD4")
		SD4->D4_QTDEORI		:= TOT_HORAS
		SD4->D4_QUANT		:= TOT_HORAS
		MsUnLock("SD4")
	endif
SD4->(DBskip())
enddo
*/


          
//----------------------------------------------------------------------------------------------
// EFETUA O AJUSTE DE MACHOS
// PARA BAIXA DE MACHOS E NECESSARIO QUE O CADASTRO DO MACHO TENHA NO GRUPO "PI01" OU "RT01"
//----------------------------------------------------------------------------------------------
BAI->(DBGotop())   
SD4->(DbSetOrder(2)) // filial + OP + Codigo do produto + local
if SD4->(DbSeek('01'+BAI->ZZ_OP,.T.))
While SD4->D4_OP == BAI->ZZ_OP             
	if SB1->(DbSeek('01'+SD4->D4_COD,.T.))
		if SB1->B1_GRUPO == 'PI01' .or. Subs(SB1->B1_COD,1,4) == 'RT01' .or. Subs(SB1->B1_COD,1,3) == 'MOD'

			DbSelectArea("SG1")
			SG1->(DbSetOrder(2))
			SG1->(Dbseek('01'+SD4->D4_COD+_produto,.t.))

        	_qtde2 = SG1->G1_QUANT

			RecLock("SD4")
				SD4->D4_QTDEORI		:= _QTDE * _qtde2
				SD4->D4_QUANT		:= _QTDE * _qtde2
			MsUnLock("SD4") 
		endif
	endif
	SD4->(DBskip())
enddo
endif


//----------------------------------------------------------------------------------------------
// EFETUA O AJUSTE DOS OUTROS PRODUTOS 
// PARA BAIXA DOS OUTROS PRODUTOS DA ESTRUTURA COM BASE NA QUANTIDADE ALTERADA
//----------------------------------------------------------------------------------------------
BAI->(DBGotop())   
SC2->(DbSetOrder(1))
SC2->(DbSeek(XFilial("SC2") + BAI->ZZ_OP))

SG1->(DbSetOrder(1))
SG1->(DbSeek(XFilial("SG1") + SC2->C2_PRODUTO))
while SG1->G1_FILIAL == XFilial("SG1") .and. SG1->G1_COD == SC2->C2_PRODUTO .and. !SG1->(Eof())
  
  // verifica se o componente foi avaliado na Szz
  nPosItem := AScan(aProdSzz, {|x| x == SG1->G1_COMP})
  if nPosItem == 0
       
    // posiciona o empenho
    SD4->(DbSetOrder(2))
    if SD4->(DbSeek(XFilial("SD4") + BAI->ZZ_OP + SG1->G1_COMP))
      
      // recalcula o empenho pela OP
      RecLock("SD4", .F.)
      SD4->D4_QTDEORI := _QTDE * SG1->G1_QUANT
      SD4->D4_QUANT := _QTDE * SG1->G1_QUANT
      MsUnlock()
      
    endIf
  
  endIf   
     
  // proximo registro
  SG1->(DbSkip())
  
endDo


//--------------------------------------------------------------------------------------------------
//  FAZ A TRANSFERENCIA DE ESTOQUE - UTILIZANDO A ROTINA MATA
//--------------------------------------------------------------------------------------------------
Processa( {|| AjuEstoque() } )
DbSelectArea("BAI")
DbCloseArea("BAI") 
Close(_QtdePro)   
MsgInfo("Procedimento concluido!")
oDlg:End()

Return


Static Function AjuEstoque()

Local _aCab1    := {}
Local _aItem    := {}
Local _atotitem :={}
Local _cCC      := '24001001'
Private lMsHelpAuto := .t.  // se .t. direciona as mensagens de help
Private lMsErroAuto := .f. //necessario a criacao, pois sera
Private inclui :=.T.

_aCab1 :={ {"D3_TM","502",NIL},; 
           {"D3_CC", _cCC,NIL},;
	       {"D3_EMISSAO",ddatabase,NIL}}
                                        
SB1->(dbSetOrder(1))
BAI->(DBGotop())                                    
While BAI->(!Eof())

	SB1->(dbSeek(xFilial("SB1")+BAI->ZZ_PRODUTO))
	
	If AllTrim(SB1->B1_RASTRO)=='L'
		//-- faz o controle para baixar saldo da tabela de lotes SB8
		aSaldoB8 := fSaldoSB8(BAI->ZZ_PRODUTO,'22')
		nSldoRef := BAI->TOTAL
		xS       := 1
		
		While nSldoRef > 0 .and. xS <= len(aSaldoB8)
		
			If aSaldoB8[xS][2] >= nSldoRef
				nQuant   := nSldoRef
				nSldoRef := 0
			Else
				nQuant   := aSaldoB8[xS][2]
				nSldoRef -= aSaldoB8[xS][2]
			EndIf
		
			_aItem:={{"D3_COD"    , BAI->ZZ_PRODUTO        ,NIL},;
		        	 {"D3_LOCAL"  , '22'/*SB1->B1_LOCPAD*/ ,NIL},; // solicitado pela logistica para fixar sempre no 22
			         {"D3_UM"     , 'KG'                   ,NIL},;
		    		 {"D3_QUANT"  , nQuant  /*BAI->TOTAL*/ ,NIL},;
		             {"D3_CC"     , _cCC                   ,NIL},;
		             {"D3_LOTECTL", aSaldoB8[xS][1]        ,NIL}}	  // adicionado controle por lote nas materias primas
		             
					aadd(_atotitem,_aitem)
					_aitem:={}
					
			xS++
	
		Enddo
	
	    If nSldoRef > 0
	    	Alert("Saldo insuficiente por LOTE."+CHR(13)+CHR(10)+;
	    	      "Produto: "+BAI->ZZ_PRODUTO+ CHR(13)+CHR(10)+;
	    	      "Local: 22 "+CHR(13)+CHR(10)+;
	    	      "Quant. Necessária: "+AllTrim(Str(BAI->TOTAL))+;
	    	      "Saldo p/ Lote: "+AllTrim(Str(BAI->TOTAL - nSldoRef)))
	    	Return
	    EndIf
	ElseIF BAI->TOTAL <> 0
	
		_aItem:={{"D3_COD"    , BAI->ZZ_PRODUTO        ,NIL},;
	        	 {"D3_LOCAL"  , '22'/*SB1->B1_LOCPAD*/ ,NIL},; // solicitado pela logistica para fixar sempre no 22
		         {"D3_UM"     , 'KG'                   ,NIL},;
	    		 {"D3_QUANT"  , BAI->TOTAL             ,NIL},;
	             {"D3_CC"     , _cCC                   ,NIL}}
		             
				aadd(_atotitem,_aitem)
				_aitem:={}
	Endif
		
	BAI->(Dbskip())
	
enddo


MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)
If lMsErroAuto
  	Mostraerro()
// 	DisarmTransaction()
//	break
EndIf

Return

Static Function calcula_saldo()
X := 1                        
for gg := 17 to len(aheader)
	for x:=2 to len(acols)-1
 		_soma += aCols[x,gg]	  
	next
	aCols[len(acols),gg] := _soma
next

return


//----------------------------------------------------------------------------------------------------
//  VERIFICA SE FOI ALTERADO A LINHA 1 --  ESTA DEVE SER A LINHA ORIGINAL DO SD4
//----------------------------------------------------------------------------------------------------
Static Function fAlterado()

for x= 17 to 32
	vSoma := vsoma + aCols[1,X]
next
if aCols[1,2] = 0 .and. vSoma <> _TotLinha1
	ALERT("IMPOSSIVEL ALTERAR A PRIMEIRA LINHA")
endif
vSoma := 0  
Return(.T.)


//----------------------------------------------------------------------------------------------------
//   RECALCULO DOS VALORES ADICIONADOS
//----------------------------------------------------------------------------------------------------

Static Function IRecalcula()
for x = 1 to 1   // Len(aCols)                
next                                               
Return                                              
           //----------------------------------------------------------------------------------------------------
//  GRAVACAO 
//----------------------------------------------------------------------------------------------------
Static Function fGrvOrd()
SetPrvt("_cCod,_x,_nLiga,_cDoc,aCab,lMsErroAuto,_n,_cc,_nForno,_nHi,_nHf,_nVi,_nVf,_cNumseq")
private lMsErroAuto:=.f.
Private _aItem :={}
Private _aCab  := {}
X := 1

for x:=2 to len(acols)-1
  	for gg := 17 to len(aheader)
		DbSelectArea("SZZ")
		SZZ->(DbSetorder(1)) 
	  	DbGoTop()
        if !acols[x][52]
        
        	//-- filial + op + corrida + forno + produto
			if SZZ->(DbSeek(xFilial("SZZ")+Substr(acols[x][1],0,13)+Str(acols[x][5],4)+Str(acols[x][3],2)+Substr(aheader[gg][1],0,15)))
				RecLock("SZZ") 
					SZZ->ZZ_FORNO		:= ACOLS[x][03]
					SZZ->ZZ_LIGA		:= ACOLS[x][04] 
					SZZ->ZZ_CORRIDA		:= ACOLS[x][05] 
					SZZ->ZZ_DISA		:= ACOLS[x][06]
					SZZ->ZZ_PANELA		:= ACOLS[x][07]
					SZZ->ZZ_MLL			:= ACOLS[x][08]
					SZZ->ZZ_DINIFUS		:= ACOLS[x][09]
					SZZ->ZZ_HRINI		:= ACOLS[x][10]
					SZZ->ZZ_DFIMFUS		:= ACOLS[x][11]
					SZZ->ZZ_HRFIM		:= ACOLS[x][12]
					SZZ->ZZ_DINIVAZ		:= ACOLS[x][13]
					SZZ->ZZ_INIVAZ		:= ACOLS[x][14]
					SZZ->ZZ_DFIMVAZ		:= ACOLS[x][15]
					SZZ->ZZ_FIMVAZ      := ACOLS[x][16]
	    	 		SZZ->ZZ_PRODUTO     := aheader[gg][1]
					SZZ->ZZ_QTDE		:= ACOLS[x][gg]
				MsUnLock("SZZ")   
			else    
				RecLock("SZZ",.T.)   
			      	SZZ->ZZ_FILIAL  := xFilial("SZZ")
		 			SZZ->ZZ_OP 		:= ACOLS[x][01]
					SZZ->ZZ_FORNADA	:= ACOLS[x][02]
					SZZ->ZZ_FORNO	:= ACOLS[x][03]
					SZZ->ZZ_LIGA	:= ACOLS[x][04]                          
					SZZ->ZZ_CORRIDA	:= ACOLS[x][05] 
					SZZ->ZZ_DISA    := ACOLS[x][06]
					SZZ->ZZ_PANELA	:= ACOLS[x][07]
					SZZ->ZZ_MLL		:= ACOLS[x][08]
					SZZ->ZZ_DINIFUS	:= ACOLS[x][09]
					SZZ->ZZ_HRINI	:= ACOLS[x][10]				
					SZZ->ZZ_DFIMFUS	:= ACOLS[x][11]
					SZZ->ZZ_HRFIM	:= ACOLS[x][12]		                                 
					SZZ->ZZ_DINIVAZ	:= ACOLS[x][13]
					SZZ->ZZ_INIVAZ	:= ACOLS[x][14]
					SZZ->ZZ_DFIMVAZ	:= ACOLS[x][15]
					SZZ->ZZ_FIMVAZ  := ACOLS[x][16]
     				SZZ->ZZ_PRODUTO := aheader[gg][1]
					SZZ->ZZ_QTDE	:= ACOLS[x][gg]	
 				MsUnLock("SZZ",.T.)   
			endif
		else

        	//-- filial + op + corrida + forno + produto
			SZZ->(DbSeek(xFilial("SZZ")+Substr(acols[x][1],0,13)+Str(acols[x][5],4)+Str(acols[x][3],2)+Substr(aheader[gg][1],0,15)))
			RecLock("SZZ") 
  				SZZ->(DbDelete())
			MsUnLock("SZZ")   
			
		endif
	next
next
Return                  



//----------------------------------------------------------------------------------------------------------------
//  
//----------------------------------------------------------------------------------------------------------------
Static Function U_FOR002()       
Local aLegenda :=	{ {"BR_VERMELHO", "Aberto" },;
  					  {"BR_VERDE"   , "Digitado"   }}
BrwLegenda("Empenhos Digitados", "Legenda", aLegenda)
Return                                              

//------------------------------------------------------------------------------
//  VALIDACAO A HORA E SE A PRIMEIRA LINHA FOI DELETADA.
//------------------------------------------------------------------------------
Static Function Val_linha()                           
_Rhora := .T.
If strzero(n,1) <> '1'
	for x := 10 to 16 step 2
	If Subs(acols[n][x],1,2) == "  " .Or. Val(Subs(acols[n][x],1,2)) > 23  .Or.;
	   Subs(acols[n][x],4,2) == "  " .Or. Val(Subs(acols[n][x],4,2)) > 59 
	   Msgbox("Hora Invalida Redigite ","Atencao","STOP")
	   _RHora = .F.
	   Return(.F.)
	Endif  
	next          
endif 

//-------------------------------------------------------------------------------
// verifica se linha foi deletada.
//-------------------------------------------------------------------------------
If strzero(n,1) == '1'
	if acols[n][52]
	   Msgbox("Impossivel DELETAR A LINHA 001 ","Atencao","STOP")
   	   Return(.F.)
	endif
endif
Return(.T.)


//------------------------------------------------------------------------------
//  VALIDACAO DA LINHA TOTAL 
//------------------------------------------------------------------------------
Static Function CAL2CHORA()
Local nHORAS := 0
TOT_HORAS :=0
for x=2 to len(acols)-1
	If (acols[x][11] - acols[x][9]) > 0
	   nHORAS := (acols[x][11] - acols[x][9]) * 1440
	EndIf
	nHORAS := nHORAS+(HTOM(acols[x][12]) - HTOM(acols[x][10]))
	TOT_HORAS:= TOT_HORAS + nHORAS
next
Return TOT_HORAS

Static Function CAL3CHORA()
Local nHORAS := 0
TOT_HORAS :=0
for x=2 to len(acols)-1
	If (acols[x][15] - acols[x][13]) > 0
	   nHORAS := (acols[x][15] - acols[x][16]) * 1440
	EndIf
	nHORAS := nHORAS+(HTOM(acols[x][16]) - HTOM(acols[x][14]))
	TOT_HORAS:= TOT_HORAS + nHORAS

next
Return TOT_HORAS

//-- traz array de saldos por lote
Static Function fSaldoSB8(cprod,clocal)
Local aSaldo := {}
Local cAl := getNextAlias()

	beginSql Alias cAl
		select B8_LOTECTL LOTE, B8_SALDO SALDO
		from %Table:SB8% B8
		WHERE B8_PRODUTO = %Exp:cprod%
		AND B8_DATA <= %Exp:dtos(ddatabase)%
		AND B8_LOCAL = %Exp:clocal%
		AND B8.%NotDel%
	endSql
	
	While (cAl)->(!eof())
		If (cAl)->SALDO > 0
			aAdd(aSaldo,{(cAl)->LOTE , (cAl)->SALDO})
		Endif
		(cAl)->(dbskip())
	Enddo
	
	(cAl)->(dbclosearea())
	
Return aSaldo