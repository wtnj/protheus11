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
                               
User Function nhpcp037()         

RETURN

//----------------------------------------------------------------------------------------------------
//  CRIACAO DE VARIAVEIS
//----------------------------------------------------------------------------------------------------
SetPrvt("_cArqDbf, cQuery,_aFields,aCampos,cMarca,cARQEXP ,cARQ,_auxdoc,_auxforno")   
SetPrvt("nMax,aHeader,aCols,oMultiline,oDialog,nI,_cForno,_cLiga,lMsErroAuto,_TOTLIN")
SetPrvt("aMatriz,_Colunas,_Insere,_TotLinha1,_qtde,_SolNor,lBxPonte")  
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
lBxPonte    := .F.
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
            { "Fornada"	  ,'U_digf12()'	  ,0,2},;
            { "Legenda"   ,'U_For0022()'	  ,0,3},;
            { "Novo Prod" ,'U_For0032()'   ,0,4}}

DbSelectArea("SC2")
SC2->(DbSetOrder(1))
mBrowse( 6, 1,22,75,"SC2",,"SC2->C2_DATRF<>CTOD('//')",,,,)
Return(nil)                                              

User Function digf12(cpar)
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
@ 180,080 BUTTON OemToAnsi(" Nova Fornada ") SIZE 50,10  ACTION IlinhaRod()
@ 180,135 BUTTON OemToAnsi(" Grv.Fornada  ") SIZE 50,10  ACTION fGrvOrd()  
//@ 180,135 BUTTON OemToAnsi("  Recalcula   ") SIZE 50,10  ACTION IRecalcula()  
@ 180,190 BUTTON OemToAnsi("Saida Fornadas") SIZE 50,10  ACTION fSaida()
@ 180,245 BUTTON OemToAnsi("   Finaliza   ") SIZE 50,10  ACTION fConfirma()  
@ 180,300 BUTTON OemToAnsi("Carrega Ponte" ) SIZE 50,10  ACTION fPonte()    

oMultiline:nMax := Len(aCols)
ACTIVATE MsDialog oDlg CENTER
            
DbSelectArea("TMP")
DbCloseArea("TMP")
DbSelectArea("TMB")
DbCloseArea("TMB") 
DbSelectArea("SZZ")                                                                         
DbCloseArea("SZZ") 

Return

User Function For0032()
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CARREGA AS INFORMAÇÕES DA TABELA ZE0 COLETADAS PELA PONTE E ADICIONA NO ACOLS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fPonte()
Local nPos    := 0
Local nCorrid := 0
Private cAl   := getNextAlias()

	If lBxPonte 
		Alert('opção já executada!')
		Return
	EndIf

	lBxPonte := .T.

   	geraZE0() 

    If (cAl)->(Eof())
    	Alert("Não há ítens a serem importados!")
    	Return
    EndIf

    While (cAl)->(!Eof())
    
/*
		//-- pesquisa no acols para ver se já não está adicionado o ítem
		_n := aScan(aCols,{|x| Substr(x[1],1,6)==(cAl)->op .and. x[5] == (cAl)->corrid .and. x[6] == (cAl)->item })
		
		if(_n!=0)
			alert('Ítem já adicionado!')
			exit
		endif
*/
		
		nCorrid := (cAl)->corrid
        IlinhaRod() //Inicia a funcao de digitacão de fornada
         
        aCols[Len(aCols)-1][5] := (cAl)->corrid
        aCols[Len(aCols)-1][3] := (cAl)->forno
         
   		// zera todas as quantidades da penultima linha do acols
   		For xH:=1 to Len(aHeader)
   			If Substr(aHeader[xH][1],1,2)=="MP" .AND. aHeader[xH][2]=="ZZ_QTDE"
	   			aCols[Len(aCols)-1][xH] := 0
	   		EndIf
   		Next
    
    	// adiciona as quantidades encontradas na tabela ZE0 (Leitura da Ponte)
	    While (cAl)->(!Eof()) .And. nCorrid == (cAl)->corrid
	    
	    	nPos := Ascan(aHeader,{|x| Alltrim(Upper(x[1]))==AllTrim(Upper((cAl)->prod))} )
	    	
	    	If nPos!=0
	    		aCols[Len(aCols)-1][nPos] := (cAl)->quant
	    	Else
	    		Alert("Adicionar o produto "+(cAl)->prod+" quantidade "+AllTrim(Str((cAl)->quant)))
	    	EndIf

			(cAl)->(dbSkip())
			
		EndDo
		

	Enddo
	
	/*
	Else
		Alert("Não foram coletadas informações da Ponte referentes a esta OP!")
		Return
	Endif
	*/
	
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
		    ,   ZE0_ITEM    item
			,   ZE0_FORNO 	forno
			,	ZE0_PROD	prod
			,	ZE0_CORRID	corrid			
			,	SUM(ZE0_QUANTR) quant
		FROM
			%Table:ZE0% ZE0 (NOLOCK)
		WHERE 
				ZE0_OP = %Exp:SC2->C2_NUM%
			AND ZE0.ZE0_STATUS = 'N'
			AND ZE0.%NotDel%
 		GROUP BY
				ZE0_OP
			,   ZE0_ITEM
			,	ZE0_FORNO
			,	ZE0_PROD			
			,	ZE0_CORRID
		ORDER BY
			ZE0_CORRID, ZE0_ITEM
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

val_linha() 
if _RHora = .F.
   Return
endif

//--------------------------------------------------------------------------------------------------
//  Verifica se a quantidade digitada nao esta superior a 10 da formulacao
//--------------------------------------------------------------------------------------------------

_multi := alltrim(str(_qtde))

cQuer7 := " SELECT SUM(G1_QUANT) * " + _multi + " AS TOTAL "
cQuer7 += " FROM " + RetSqlName( 'SG1' ) + " G1 "
cQuer7 += " WHERE G1_COD = '" + SC2->C2_PRODUTO + "'" 
cQuer7 += " AND G1_COMP LIKE '%MP%' "
cQuer7 += " AND D_E_L_E_T_ = ''"
cQuer7 += " AND G1_FILIAL = '"+xFilial("SG1")+"'"

//MemoWrit('C:\TEMP\PCP11A.SQL',cQuer7)
TCQUERY cQuer7 NEW ALIAS "TMA"                                      

cQuer8 := "SELECT SUM(ZZ_QTDE) AS TOTZZ
cQuer8 += " FROM " + RetSqlName( 'SZZ' ) + " ZZ "
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
cQuer2 += " FROM " + RetSqlName( 'SZZ' ) +" SZZ "
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

/*

SD4->(dbSetOrder(2)) // filial + OP + Codigo do produto + local
BAI->(dbGotop())     

While BAI->(!Eof())
	
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
		
		RecLock("SD4")
			SD4->D4_QTDEORI		:= BAI->TOTAL 
			SD4->D4_QUANT		:= BAI->TOTAL 
		MsUnLock("SD4") 
 	
 	Else
		
 	Endif
 	
	BAI->(dBskip())
	
EndDo

*/

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

/*

BAI->(DBGotop())   
SD4->(DbSetOrder(2)) // filial + OP + Codigo do produto + local
if SD4->(DbSeek('01'+BAI->ZZ_OP,.T.))
While SD4->D4_OP = BAI->ZZ_OP             
	if SB1->(DbSeek('01'+SD4->D4_COD,.T.))
		if SB1->B1_GRUPO = 'PI01' .or. Subs(SB1->B1_COD,1,4) = 'RT01' .or. Subs(SB1->B1_COD,1,3) = 'MOD'

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

*/

//--------------------------------------------------------------------------------------------------
//  FAZ A TRANSFERENCIA DE ESTOQUE - UTILIZANDO A ROTINA MATA
//--------------------------------------------------------------------------------------------------
Processa( {|| AjuEstoque() } )

DbSelectArea("BAI")
DbCloseArea("BAI") 
Close(_QtdePro)   
Return

Static Function AjuEstoque()

Local _aCab1    := {}
Local _aItem    := {}
Local _atotitem := {}
Local _cCC      := '24001001'
Private lMsHelpAuto := .t.  // se .t. direciona as mensagens de help
Private lMsErroAuto := .f. //necessario a criacao, pois sera
Private inclui :=.T.

_aCab1 :={ {"D3_TM","502",NIL},; 
           {"D3_CC", _cCC,NIL},;
	       {"D3_EMISSAO",ddatabase,NIL}}

BAI->(DBGotop())                                    
While BAI->(!Eof())
    IF BAI->TOTAL <> 0
    
    //----------------------------------------------------------------
    //  BUSCA NO SB1 O LOCAL PADRAO PARA COLOCAR NO ARRAY DO MATA241
    //----------------------------------------------------------------
      SB1->(DbSeek(xFilial()+BAI->ZZ_PRODUTO))  //Filial+produto    

	_aItem:={{"D3_COD"   , BAI->ZZ_PRODUTO ,NIL},;
        	 {"D3_LOCAL" , '22'/*SB1->B1_LOCPAD*/ ,NIL},; //solicitado pela logistica para fixar sempre no 22
	         {"D3_UM"    , 'KG'            ,NIL},;
    		 {"D3_QUANT" , BAI->TOTAL	   ,NIL},;
             {"D3_CC"    , _cCC            ,NIL}}
			aadd(_atotitem,_aitem)
			_aitem:={}
	ENDIF
	BAI->(DBskip())
enddo

If Len(_aItem) > 0
	MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)
	If lMsErroAuto
	  	Mostraerro()
	// 	DisarmTransaction()
	//	break
	EndIf
EndIf
	
Return


//----------------------------------------------------------------------------------------------------
//   INCLUI NOVA LINHA NO ACOLS
//----------------------------------------------------------------------------------------------------
Static Function IlinhaRod()
_Insere = Len(aCols)
aCols[_Insere,01] := aCols[1,1]	  
aCols[_Insere,02] := aCols[_Insere-1,2]+1 

aCols[_Insere,08] := date()
aCols[_Insere,10] := date()
aCols[_Insere,12] := date()
aCols[_Insere,14] := date()

for x:=16 to len(aheader)
    aCols[len(aCols),x] := 0
next

AADD(aCols,{"SALDO TOTAL",0,0,0,0,"",0,CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,.f.})
_soma := 0
X := 1                        

for gg := 16 to len(aheader)
	for x:=2 to len(acols)-1
 		_soma += aCols[x,gg]	  
	next
	aCols[len(acols),gg] := aCols[1,gg] - _soma 
	_soma := 0
next
dlgRefresh(oDlg)
Return                                                      


Static Function calcula_saldo()
X := 1                        
for gg := 16 to len(aheader)
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

for x= 16 to 33
	vSoma := vsoma + aCols[1,X]
next
if aCols[1,2] = 0 .and. vSoma <> _TotLinha1
	ALERT("IMPOSSIVEL ALTERAR A PRIMEIRA LINHA")
endif
vSoma := 0  
Return(.T.)

           
//----------------------------------------------------------------------------------------------------
//  GRAVACAO 
//----------------------------------------------------------------------------------------------------
Static Function fGrvOrd()
SetPrvt("_cCod,_x,_nLiga,_cDoc,aCab,lMsErroAuto,_n,_cc,_nForno,_nHi,_nHf,_nVi,_nVf,_cNumseq")
private lMsErroAuto:=.f.
Private _aItem :={}
Private _aCab  := {}
X := 1

ZE0->(dbSetOrder(1)) // filial + num_op + corrida + item

for x:=2 to len(acols)-1
  	for gg := 16 to len(aheader)
		DbSelectArea("SZZ")
		SZZ->(DbSetorder(1)) 
	  	DbGoTop()
        if !acols[x][51]
			if SZZ->(DbSeek(xFilial("SZZ")+Substr(acols[x][1],0,15)+Str(acols[x][2],3)+Substr(aheader[gg][1],0,15)))
				RecLock("SZZ") 
					SZZ->ZZ_FORNO		:= ACOLS[x][03]
					SZZ->ZZ_LIGA		:= ACOLS[x][04] 
					SZZ->ZZ_CORRIDA		:= ACOLS[x][05] 
					SZZ->ZZ_DISA		:= ACOLS[x][06]
					SZZ->ZZ_PANELA		:= ACOLS[x][07]
					SZZ->ZZ_DINIFUS		:= ACOLS[x][08]
					SZZ->ZZ_HRINI		:= ACOLS[x][09]
					SZZ->ZZ_DFIMFUS		:= ACOLS[x][10]
					SZZ->ZZ_HRFIM		:= ACOLS[x][11]
					SZZ->ZZ_DINIVAZ		:= ACOLS[x][12]
					SZZ->ZZ_INIVAZ		:= ACOLS[x][13]
					SZZ->ZZ_DFIMVAZ		:= ACOLS[x][14]
					SZZ->ZZ_FIMVAZ      := ACOLS[x][15]
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
					SZZ->ZZ_DINIFUS	:= ACOLS[x][08]
					SZZ->ZZ_HRINI	:= ACOLS[x][09]				
					SZZ->ZZ_DFIMFUS	:= ACOLS[x][10]
					SZZ->ZZ_HRFIM	:= ACOLS[x][11]		                                 
					SZZ->ZZ_DINIVAZ	:= ACOLS[x][12]
					SZZ->ZZ_INIVAZ	:= ACOLS[x][13]
					SZZ->ZZ_DFIMVAZ	:= ACOLS[x][14]
					SZZ->ZZ_FIMVAZ  := ACOLS[x][15]
     				SZZ->ZZ_PRODUTO := aheader[gg][1]
					SZZ->ZZ_QTDE	:= ACOLS[x][gg]	
 				MsUnLock("SZZ")   
			endif
			
		else
			
			If SZZ->(DbSeek(xFilial("SZZ")+Substr(acols[x][1],0,13)+Str(acols[x][2],3)+Substr(aheader[gg][1],0,15)))
				RecLock("SZZ",.F.) 
  					SZZ->(DbDelete())
				MsUnLock("SZZ")   
			EndIf
			
		endif
		
		If lBxPonte // flag se o usuário clicou no botao "carrega ponte"

			//Baixa os ítens da leitura da ponte na tabela ZE0
			If ZE0->(dbSeek(Space(2)+Substr(aCols[x][1],1,6)+StrZero(aCols[x][5],2)))
				While ZE0->(!EOF()) .and. ZE0->ZE0_OP==Substr(aCols[x][1],1,6) .and. ZE0->ZE0_CORRID==aCols[x][5]
					RecLock("ZE0")
						ZE0->ZE0_STATUS := 'S'
					MsUnlock("ZE0")
					
					ZE0->(dbSkip())
				EndDo
			EndIf

		EndIf
		
	next
next

Return                  

//----------------------------------------------------------------------------------------------------------
//  GERACAO DO ARQUIVO TEMPORARIO PARA CRIACAO DO MULTILINE
//----------------------------------------------------------------------------------------------------------
STATIC FUNCTION GERA_TESTE()

aHeader  	:= {}
aCols 		:= {}
_TotLinha1  := 0

AADD(aCols,{" ",0,0,0,0,"",0,CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,.f.})

cQuery := "SELECT D4.D4_COD,D4.D4_FILIAL,D4.D4_OP,D4.D4_QTDEORI,D4.D4_DATA, B1.B1_TIPO "
cQuery += " FROM " + RetSqlName( 'SD4' ) +" D4, "  + RetSqlName( 'SB1' ) +" B1 "
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

aCols[1,1] := TMP->D4_OP    //  OP
aCols[1,2] := 0    			// FORNADA
aCols[1,3] := 0             // FORNO 
aCols[1,4] := 0             // LIGA    
aCols[1,5] := 0             // CORRIDA
aCols[1,6] := "" 			// DISA
aCols[1,7] := 0 			// PANELA
aCols[1,8] := date()        //  DATA
aCols[1,9] := '00:00'       // HRINI
aCols[1,10] := date()        //  DATA
aCols[1,11] := '00:00'	    // HRFIM
aCols[1,12] := date()        //  DATA
aCols[1,13] := '00:00'		// INIVAZ
aCols[1,14] := date()        //  DATA
aCols[1,15] := '00:00'		// FIMVAZ    

_Colunas := 15
While TMP->(!EOF())
	_Colunas += 1
	aCols[1,_Colunas] := TMP->D4_QTDEORI
	_TotLinha1 := _TotLinha1 + TMP->D4_QTDEORI
	TMP->(DbSkip())
enddo

cQuery1 := "SELECT * FROM " + RetSqlName( 'SZZ' ) +" SZZ "
cQuery1 += "WHERE SZZ.ZZ_OP = '" + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + "'"
cQuery1 += "AND SZZ.D_E_L_E_T_ = '' "
cQuery1 += "ORDER BY SZZ.ZZ_OP,SZZ.ZZ_FORNADA,SZZ.ZZ_PRODUTO,SZZ.ZZ_CORRIDA " 
TCQUERY cQuery1 NEW ALIAS "TMB"

TMB->(DBGotop())    
AUX_FORNAD := TMB->ZZ_FORNADA
X := 1

while TMB->(!EOF())

    AADD(aCols,{" ",0,0,0,0,"",0,CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,.f.})
	X++
	aCols[X,01] := TMB->ZZ_OP
	aCols[X,02] := TMB->ZZ_FORNADA
	aCols[X,03] := TMB->ZZ_FORNO
	aCols[X,04] := TMB->ZZ_LIGA
	aCols[X,05] := TMB->ZZ_CORRIDA
	aCols[X,06] := TMB->ZZ_DISA
	aCols[X,07] := TMB->ZZ_PANELA
	aCols[X,08] := STOD(TMB->ZZ_DINIFUS)
	aCols[X,09] := TMB->ZZ_HRINI         
	aCols[X,10] := STOD(TMB->ZZ_DFIMFUS)	
	aCols[X,11] := TMB->ZZ_HRFIM
	aCols[X,12] := STOD(TMB->ZZ_DINIVAZ)
	aCols[X,13] := TMB->ZZ_INIVAZ       
	aCols[X,14] := STOD(TMB->ZZ_DFIMVAZ)	
	aCols[X,15] := TMB->ZZ_FIMVAZ    
	
	_ColF := 15
	
	While TMB->ZZ_FORNADA == AUX_FORNAD     // TMB->(!EOF())
		_ColF += 1
		aCols[X,_Colf] := TMB->ZZ_QTDE
		TMB->(DbSkip())
	enddo
	
	AUX_FORNAD := TMB->ZZ_FORNADA
	
enddo

Processa( {|| gera_multi() } )  

AADD(aCols,{"SALDO TOTAL",0,0,0,0,"",0,CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",CTOD("  /  /  "),"00:00",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,.f.})
                          
if len(acols) = 2
	for gg := 16 to len(aheader)
		aCols[2,gg] := aCols[1,gg]
	next
else
	for gg := 16 to len(aheader)
		for x:=2 to len(acols)-1
	 		_soma := _soma + aCols[x,gg]	  
		next
        aCols[len(acols),gg] := aCols[1,gg] - _soma 
		_soma := 0
	next
endif

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ COPIA A PRIMEIRA DATA DIGITADA PARA OS OUTROS CAMPOS DE DATA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function PCP10DT2()
Local dDt := M->ZZ_DINIFUS

	aCols[n][10] := dDt
	aCols[n][12] := dDt
	aCols[n][14] := dDt
	oMultiline:Refresh()

Return .T.

//----------------------------------------------------------------------------------------------------------------
//  MONTA O CABECALHO DO MULTILINE
//----------------------------------------------------------------------------------------------------------------
Static Function gera_Multi()

Aadd(aHeader,{"Ord.Prod"   , "ZZ_OP"		, "@!"          ,15,0,".F.","","C","SZZ"})  // 1
Aadd(aHeader,{"Fornada"    , "ZZ_FORNADA"	, "999"         , 3,0,".F.","","N","SZZ"})  // 2
Aadd(aHeader,{"Forno"      , "ZZ_FORNO"		, "999"         , 1,0,".T.","","N","SZZ"})  // 3
Aadd(aHeader,{"Liga"       , "ZZ_LIGA" 		, "9999"        , 4,0,".T.","","N","SZZ"})  // 4
Aadd(aHeader,{"Corrida"    , "ZZ_CORRIDA"	, "9999"        , 4,0,".T.","","N","SZZ"})  // 5
Aadd(aHeader,{"Disa"       , "ZZ_DISA"   	, "@!"          , 1,0,".T.","","C","SZZ"})  // 6
Aadd(aHeader,{"Panela"     , "ZZ_PANELA"   	, "999"         , 3,0,".T.","","N","SZZ"})  // 7
Aadd(aHeader,{"Dt.Ini Fus" , "ZZ_DINIFUS"	, "99/99/99"    , 8,0,"U_PCP10DT2()","","C","SZZ"})  // 8
Aadd(aHeader,{"Hr Ini"     , "ZZ_HRINI" 	, "99:99"       , 5,0,".T.","","C","SZZ"})  // 9
Aadd(aHeader,{"Dt.Fim Fus" , "ZZ_DFIMFUS"  	, "99/99/99"    , 8,0,".T.","","C","SZZ"})  // 10
Aadd(aHeader,{"Hr Fim"     , "ZZ_HRFIM" 	, "99:99"       , 5,0,".T.","","C","SZZ"})  // 11
Aadd(aHeader,{"Dt.Ini Vaz" , "ZZ_DINIVAZ" 	, "99/99/99"    , 8,0,".T.","","C","SZZ"})  // 12
Aadd(aHeader,{"V. Ini"     , "ZZ_INIVAZ"  	, "99:99"       , 5,0,".T.","","C","SZZ"})  // 13
Aadd(aHeader,{"Dt.Fim Vaz" , "ZZ_DFIMVAZ" 	, "99/99/99"    , 8,0,".T.","","C","SZZ"})  // 14
Aadd(aHeader,{"V. Fim"     , "ZZ_FIMVAZ"  	, "99:99"       , 5,0,".T.","","C","SZZ"})  // 15

TMP->(DBGotop())

While !TMP->(EOF())
	Aadd(aHeader,{TMP->D4_COD,"ZZ_QTDE","@E 99999999.99" ,11,2,".T.","","N","SZZ"})
	TMP->(DbSkip())
EndDo

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
	for x := 9 to 15 step 2
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
	if acols[n][51]
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
	If (acols[x][10] - acols[x][8]) > 0
	   nHORAS := (acols[x][10] - acols[x][8]) * 1440
	EndIf
	nHORAS := nHORAS+(HTOM(acols[x][11]) - HTOM(acols[x][9]))
	TOT_HORAS:= TOT_HORAS + nHORAS
next
Return TOT_HORAS

Static Function CAL3CHORA()
Local nHORAS := 0
TOT_HORAS :=0
for x=2 to len(acols)-1
	If (acols[x][14] - acols[x][12]) > 0
	   nHORAS := (acols[x][14] - acols[x][12]) * 1440
	EndIf
	nHORAS := nHORAS+(HTOM(acols[x][15]) - HTOM(acols[x][13]))
	TOT_HORAS:= TOT_HORAS + nHORAS

next
Return TOT_HORAS