#include "font.ch"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"   
#include "colors.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHFAT022  ºAutor ³Fabio Nico          º Data ³  12/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ MANUTENCAO DE ATIVOS                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GERAR UM NOVO BEM COM A MESMA CARACTERISTICA DE OUTRO      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
	
User Function NHMNT016()   
SetPrvt("_codBem,_codNovo,_tamori,_auxCodF,_auxcod,_acodbem,_acodpro")


_codBem 	:= Space(15)
_codNovo 	:= Space(15)
_tamori 	:= Space(15)
_auxCodF	:= Space(15)
_auxCod		:= Space(15)       
_acodbem 	:= Space(15)     
_acodpro	:= Space(15)     

DEFINE FONT oFont NAME "Arial" SIZE 12, -12                                                                  

@ 200,050 To 450,500 Dialog oDlgBem Title "Geracao de novo BEM "
@ 015,010 Say OemToAnsi("Digite o codigo do BEM a ser copiado") Color CLR_BLUE Size 450,8 Object oItem                        
oItem:Setfont(oFont)                      
@ 045,010 Say OemToAnsi("Digite o codigo PAI a ser gerado ") Color CLR_BLUE Size 450,8 Object oItem 
oItem:Setfont(oFont)
@ 030,010 Get _codBem  Picture "@!" F3 "ST9" Valid ValBem(_codBem) SIZE 080,10 Object oCodBem
@ 060,010 Get _codNovo Picture "@!" F3 "ST9" Valid ValBem(_codNovo)  SIZE 080,10 Object oCodNovo
@ 080,080 BMPBUTTON TYPE 01 ACTION GeraBem()
@ 080,110 BMPBUTTON TYPE 02 ACTION Close(oDlgbem)
Activate msDialog oDlgBem Centered  


Return

//---------------------------------------------------------------------------------------------
//  VERIFICA SE EXISTE O BEM NO BANCO
//---------------------------------------------------------------------------------------------
Static Function ValBem(_codloc)
Local lReturn := .F.
DbSelectArea("ST9")
ST9->(DbSetOrder(1)) //filial+cod
ST9->(DbSeek(xFilial("ST9")+ALLTRIM(_codloc))) //tabelas de almoxarifados

if !ST9->(Found())
		ALERT("Produto nao Cadastrado Verifique")  
	ELSE
	    lReturn := .T.
endif
Return(lReturn)

//--------------------------------------------------------------------------------------------
//
//--------------------------------------------------------------------------------------------
Static Function GeraBem()
_tamOri = len(alltrim(_codbem))

DbSelectArea("ST9")
ST9->(DbSetOrder(1)) //filial+cod
ST9->(DbSeek(xFilial("ST9")+_codNovo)) //tabelas de almoxarifados
_auxCodF := T9_CODFAMI

Processa( {|| ajuST9()   },"Ajusta tabela ST9 ") 
Processa( {|| ajuSTB()   },"Ajusta tabela STB ") 
Processa( {|| ajuTPY()   },"Ajusta tabela TPY ")         
                  
TMP->(DbCloseArea("TMP"))
TMB->(DbCloseArea("TMB"))
TMC->(DbCloseArea("TMC"))

_codBem 	:= Space(15)
_codNovo 	:= Space(15)

Return


Static Function ajuST9()

//-----------------------------------------------------------------------
// MONTA A QUERY PARA ST9
//-----------------------------------------------------------------------	 

cQuery := " SELECT * FROM "+RetSqlName("ST9")+" WHERE T9_CODBEM LIKE '%" + ALLTRIM(_codBem) + "%'"
cQuery += "	AND D_E_L_E_T_ = ''"
MemoWrit('C:\TEMP\NHMNT016.SQL',cQuery)
TCQUERY cQuery NEW ALIAS "TMP" 
DbSelectArea("TMP")   
TMP->(Dbgotop())       


cQuery2:= " SELECT * FROM "+RetSqlName("ST9")+" WHERE T9_CODBEM = '" + ALLTRIM(_codNovo) + "'"
cQuery2+= "	AND D_E_L_E_T_ = ''"
MemoWrit('C:\TEMP\NHMNT016b.SQL',cQuery)
TCQUERY cQuery2 NEW ALIAS "TMC" 
DbSelectArea("TMC")   
TMC->(Dbgotop())       


while TMP->(!Eof())

	DbSelectArea("ST9")
	ST9->(DbSetOrder(1)) //filial+cod
	if !ST9->(DbSeek(xFilial("ST9")+alltrim(_codNovo)+alltrim(substr(TMP->T9_CODBEM,_tamori+1,4)))) //tabelas de almoxarifados
			_grava := .t.	
		else 
			_grava := .f.	
	endif

 	RecLock("ST9",_grava)                     
		if _grava = .t.	                  
	        _auxcod := alltrim(_codNovo)+alltrim(substr(TMP->T9_CODBEM,_tamori+1,4))
	   		ST9->T9_CODBEM  := ALLTRIM(_auxcod)
			ST9->T9_FILIAL  := TMP->T9_FILIAL	   		
	 	endif


		ST9->T9_CODIMOB := TMP->T9_CODIMOB
		ST9->T9_FERRAME := TMP->T9_FERRAME
		ST9->T9_RECFERR := TMP->T9_RECFERR
		ST9->T9_CODFAMI := _auxCodF
		ST9->T9_PADRAO 	:= TMP->T9_PADRAO

		IF ALLTRIM(ST9->T9_CODBEM) == ALLTRIM(_codNovo)

		Else
			ST9->T9_NOME 	:= TMP->T9_NOME
		EndIf
		
		ST9->T9_CCUSTO	:= TMC->T9_CCUSTO //ST9->T9_CCUSTO
		ST9->T9_CALENDA	:= TMP->T9_CALENDA
		ST9->T9_CENTRAB	:= TMC->T9_CENTRAB //ST9->T9_CENTRAB
		ST9->T9_FORNECE	:= TMP->T9_FORNECE
		ST9->T9_LOJA	:= TMP->T9_LOJA
		ST9->T9_FABRICA	:= TMP->T9_FABRICA
		ST9->T9_MODELO 	:= TMC->T9_MODELO //ST9->T9_MODELO
		ST9->T9_SERIE	:= TMC->T9_SERIE //ST9->T9_SERIE
		ST9->T9_ESTRUTU	:= TMP->T9_ESTRUTU
		ST9->T9_PRGARAN	:= TMP->T9_PRGARAN
		ST9->T9_UNGARAN	:= TMP->T9_UNGARAN
		ST9->T9_PRIORID	:= TMP->T9_PRIORID
		ST9->T9_CODESTO	:= TMP->T9_CODESTO
		ST9->T9_TEMCONT	:= TMP->T9_TEMCONT
		ST9->T9_TPCONTA	:= TMP->T9_TPCONTA
		ST9->T9_POSCONT	:= TMP->T9_POSCONT
		ST9->T9_VARDIA	:= TMP->T9_VARDIA
		ST9->T9_LIMICON	:= TMP->T9_LIMICON
		ST9->T9_INDPOND	:= TMP->T9_INDPOND
		ST9->T9_PONDERA	:= TMP->T9_PONDERA
		ST9->T9_SITMAN	:= TMP->T9_SITMAN
		ST9->T9_SITBEM	:= TMP->T9_SITBEM
		ST9->T9_LOCAL	:= TMP->T9_LOCAL
		ST9->T9_CHAPA	:= TMP->T9_CHAPA
		ST9->T9_CUSTOHO	:= TMP->T9_CUSTOHO
		ST9->T9_CONTACU	:= TMP->T9_CONTACU
		ST9->T9_VIRADAS	:= TMP->T9_VIRADAS
		ST9->T9_CONTDES	:= TMP->T9_CONTDES
		ST9->T9_UNIDDES	:= TMP->T9_UNIDDES
		ST9->T9_VALCPA	:= TMP->T9_VALCPA
		ST9->T9_CLIENTE	:= TMP->T9_CLIENTE
		ST9->T9_AJUSCON	:= TMP->T9_AJUSCON
		ST9->T9_CODOBS	:= TMP->T9_CODOBS
		ST9->T9_INDAMB	:= TMP->T9_INDAMB
		ST9->T9_INDPLT	:= TMP->T9_INDPLT
		ST9->T9_INDIMG	:= TMP->T9_INDIMG
		ST9->T9_LARGURA	:= TMP->T9_LARGURA
		ST9->T9_COMPRIM	:= TMP->T9_COMPRIM
		ST9->T9_POSX	:= TMP->T9_POSX
		ST9->T9_POSY	:= TMP->T9_POSY
		ST9->T9_SITATR	:= .F.
		ST9->T9_SITMNT	:= TMP->T9_SITMNT
		ST9->T9_SITPAR	:= .F.
		ST9->T9_PERACOM	:= TMP->T9_PERACOM
		ST9->T9_UNIACOM	:= TMP->T9_UNIACOM
		ST9->T9_MOVIBEM	:= TMP->T9_MOVIBEM
		ST9->T9_CONTGAR	:= TMP->T9_CONTGAR
		ST9->T9_MTBAIXA	:= TMP->T9_MTBAIXA
		ST9->T9_BITMAP	:= TMP->T9_BITMAP
		ST9->T9_LOJACLI := TMP->T9_LOJACLI
    MsUnLock("ST9")     

    TMP->(Dbskip())
enddo

Return(nil)


Static Function ajuSTB()

//-----------------------------------------------------------------------
// MONTA A QUERY PARA STB
//-----------------------------------------------------------------------	 

cQuery2 := " SELECT * FROM "+RetSqlName("STB")+" WHERE TB_CODBEM LIKE '%" + ALLTRIM(_codBem) + "%'"
cQuery2 += "	AND D_E_L_E_T_ = ''"
MemoWrit('C:\TEMP\NHMNT016B.SQL',cQuery2)
TCQUERY cQuery2 NEW ALIAS "TMB" 


DbSelectArea("TMB")   
TMB->(Dbgotop())       
while TMB->(!Eof())

	DbSelectArea("STB")
	STB->(DbSetOrder(1)) //filial+cod
	if !STB->(DbSeek(xFilial("STB")+alltrim(_codNovo)+alltrim(substr(TMB->TB_CODBEM,_tamori+1,4)))) //tabelas de almoxarifados
			_grava := .t.	
		else 
			_grava := .f.	
	endif

	RecLock("STB",_grava)                     
	
		if _grava = .t.	
        	_auxcod := alltrim(_codNovo)+alltrim(substr(TMB->TB_CODBEM,_tamori+1,4))
			STB->TB_CODBEM  := ALLTRIM(_auxcod)
			STB->TB_FILIAL  := TMB->TB_FILIAL
        endif 

		STB->TB_CARACTE := TMB->TB_CARACTE
		STB->TB_DETALHE := TMB->TB_DETALHE
		STB->TB_UNIDADE := TMB->TB_UNIDADE
    MsUnLock("STB")     
    TMB->(Dbskip())
enddo
Return(nil)


Static Function ajuTPY()

//-----------------------------------------------------------------------
// MONTA A QUERY PARA TPY
//-----------------------------------------------------------------------	 
TMC->(DbCloseArea())

cQuery3 := " SELECT * FROM "+RetSqlName("TPY")+" WHERE TPY_CODBEM LIKE '%" + ALLTRIM(_codBem) + "%'"
cQuery3 += "	AND D_E_L_E_T_ = ''"  
cQuery3 += "	ORDER BY TPY_CODBEM "  

MemoWrit('C:\TEMP\NHMNT016Y.SQL',cQuery3)
TCQUERY cQuery3 NEW ALIAS "TMC" 


DbSelectArea("TMC")   
TMC->(Dbgotop())       
while TMC->(!Eof())                                                          

   _auxcod := alltrim(_codNovo)+alltrim(substr(TMC->TPY_CODBEM,_tamori+1,4))


	_acodbem := substr(TMC->TPY_CODBEM,_tamori+1,9)
	_acodpro := TMC->TPY_CODPRO



	DbSelectArea("TPY")
	TPY->(DbSetOrder(1)) //filial+cod+PROD 
    TPY->(Dbgotop())       
	if !TPY->(DbSeek(xFilial("TPY")+alltrim(_codNovo)+_acodbem+_acodpro))
			_grava := .T.	
		else                                                                              
			_grava := .F.	
	endif

	RecLock("TPY",_grava)   
		if _grava = .t.	                  
    		TPY->TPY_CODBEM  := ALLTRIM(_auxcod)
			TPY->TPY_FILIAL  := TMC->TPY_FILIAL
			TPY->TPY_CODPRO  := TMC->TPY_CODPRO
  		endif
		TPY->TPY_QUANTI  := TMC->TPY_QUANTI
		TPY->TPY_CRITIC  := TMC->TPY_CRITIC
		TPY->TPY_QTDGAR  := TMC->TPY_QTDGAR		
		TPY->TPY_UNIGAR  := TMC->TPY_UNIGAR
		TPY->TPY_CONGAR  := TMC->TPY_CONGAR
    MsUnLock("TPY")  

    TMC->(Dbskip())
enddo
Return(nil)

