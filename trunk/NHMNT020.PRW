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
	
User Function NHMNT020()   
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
@ 030,010 Get _codBem  Picture "@!" F3 "STF" Valid ValBem(_codBem) SIZE 080,10 Object oCodBem
@ 060,010 Get _codNovo Picture "@!" SIZE 080,10 Object oCodNovo
@ 080,080 BMPBUTTON TYPE 01 ACTION GeraBem()
@ 080,110 BMPBUTTON TYPE 02 ACTION Close(oDlgbem)
Activate msDialog oDlgBem Centered  

Return

//---------------------------------------------------------------------------------------------
//  VERIFICA SE EXISTE O BEM NO BANCO
//---------------------------------------------------------------------------------------------
Static Function ValBem(_codloc)
Local lReturn := .F.

	STF->(DbSetOrder(1)) //filial+cod
	STF->(DbSeek(xFilial("STF")+ALLTRIM(_codloc))) //tabelas de almoxarifados
	
	if !STF->(Found())
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

Processa( {|| ajuSTF()   },"Ajusta tabela STF ") 
Processa( {|| ajuST5()   },"Ajusta tabela ST5 ") 
Processa( {|| ajuSTG()   },"Ajusta tabela STG ")         
Processa( {|| ajuSTH()   },"Ajusta tabela STH ")         
                                                                               
TMP->(DbCloseArea("TMP"))
TMB->(DbCloseArea("TMB"))
TMC->(DbCloseArea("TMC"))
TMD->(DbCloseArea("TMD"))

_codBem 	:= Space(15)
_codNovo 	:= Space(15)

Return


Static Function ajuSTF()

//-----------------------------------------------------------------------
// MONTA A QUERY PARA STF
//-----------------------------------------------------------------------	 
cQuery := " SELECT * FROM "+RetSqlName("STF")+" WHERE TF_CODBEM LIKE '%" + ALLTRIM(_codBem) + "%'"
cQuery += "	AND D_E_L_E_T_ = '' AND TF_ATIVO <> 'N' AND TF_CODAREA = 'LUB' "
cQuery += "	AND TF_SERVICO = '000003' AND TF_PADRAO = 'N' "
cQuery += "	ORDER BY TF_CODBEM,TF_SERVICO,TF_SEQRELA "

TCQUERY cQuery NEW ALIAS "TMP" 

TMP->(Dbgotop())

While TMP->(!Eof())

    _servico := TMP->TF_SERVICO
	_seqrela := TMP->TF_SEQRELA
	_sequen  := substr(TMP->TF_CODBEM,_tamori+1,9)

	DbSelectArea("STF")
    STF->(Dbgotop())       
	STF->(DbSetOrder(1)) 
	
	If !STF->(DbSeek(xFilial("STF")+alltrim(_codNovo)+_sequen+_servico+_seqrela))
		_grava := .t.
	Else
		_grava := .f.
	Endif
 
 	RecLock("STF",_grava)

		If _grava == .t.
	        _auxcod := alltrim(_codNovo)+alltrim(substr(TMP->TF_CODBEM,_tamori+1,9))
	   		STF->TF_CODBEM  := ALLTRIM(_auxcod)
			STF->TF_FILIAL  := TMP->TF_FILIAL
			STF->TF_SERVICO := TMP->TF_SERVICO
			STF->TF_SEQRELA := TMP->TF_SEQRELA			
	 	EndIf

		STF->TF_SEQUENC := TMP->TF_SEQUENC  
		STF->TF_DTULTMA := DATE()//STOD(TMP->TF_DTULTMA)
		STF->TF_NOMEMAN := TMP->TF_NOMEMAN
		STF->TF_PADRAO	:= TMP->TF_PADRAO
		STF->TF_CODAREA := TMP->TF_CODAREA
		STF->TF_TIPO 	:= TMP->TF_TIPO
		STF->TF_CALENDA := TMP->TF_CALENDA
		STF->TF_CONTADO := TMP->TF_CONTADO
		STF->TF_TIPACOM := TMP->TF_TIPACOM
		STF->TF_PARADA 	:= TMP->TF_PARADA
		STF->TF_TEPAANT := TMP->TF_TEPAANT
		STF->TF_UNPAANT := TMP->TF_UNPAANT
		STF->TF_TEPADEP := TMP->TF_TEPADEP
		STF->TF_UNPADEP := TMP->TF_UNPADEP
		STF->TF_PERACOM := TMP->TF_PERACOM
		STF->TF_UNIACOM := TMP->TF_UNIACOM
		STF->TF_TEENMAN := TMP->TF_TEENMAN
		STF->TF_UNENMAN := TMP->TF_UNENMAN
		STF->TF_CONMANU := TMP->TF_CONMANU
		STF->TF_INENMAN := TMP->TF_INENMAN
		STF->TF_NAOUTIL := TMP->TF_NAOUTIL
		STF->TF_VIRADAS := TMP->TF_VIRADAS
		STF->TF_PRIORID := TMP->TF_PRIORID
		STF->TF_PERIODO := TMP->TF_PERIODO
		STF->TF_ATIVO 	:= TMP->TF_ATIVO
		STF->TF_AJUSCON := TMP->TF_AJUSCON
		STF->TF_QUANTOS := TMP->TF_QUANTOS
		STF->TF_CODOBS 	:= TMP->TF_CODOBS
		STF->TF_DOCFIL	:= TMP->TF_DOCFIL
		STF->TF_DOCTO 	:= TMP->TF_DOCTO
		STF->TF_SUBSTIT := TMP->TF_SUBSTIT
		STF->TF_PLANEJA := TMP->TF_PLANEJA
		STF->TF_MFPADR 	:= TMP->TF_MFPADR
		STF->TF_MFINTE 	:= TMP->TF_MFINTE
		STF->TF_MFSEMA 	:= TMP->TF_MFSEMA
		STF->TF_MFDIME 	:= TMP->TF_MFDIME
		STF->TF_MFMEAN 	:= TMP->TF_MFMEAN
		STF->TF_MFSEQU 	:= TMP->TF_MFSEQU
		STF->TF_MFDIDF 	:= TMP->TF_MFDIDF
		STF->TF_MFNACO 	:= TMP->TF_MFNACO
    MsUnLock("STF")     

    TMP->(Dbskip())

EndDo

Return(nil)


Static Function ajuST5()

//-----------------------------------------------------------------------
// MONTA A QUERY PARA ST5
//-----------------------------------------------------------------------	 
cQuery2 := " SELECT TF_SERVICO,* "
cQuery2 += " FROM "+RetSqlName("ST5")+" T5 , "+RetSqlName("STF")+" TF "
cQuery2 += " WHERE T5.T5_CODBEM LIKE '%" + ALLTRIM(_codBem) + "%'"
cQuery2 += " AND TF.TF_CODBEM = T5.T5_CODBEM "
cQuery2 += " AND TF.TF_ATIVO <> 'N' AND TF.TF_CODAREA = 'LUB' "
cQuery2 += " AND TF.TF_SEQRELA = T5.T5_SEQRELA "
cQuery2 += " AND T5_SERVICO = '000003' "
cQuery2 += " AND TF_PADRAO = 'N' "
cQuery2 += " AND TF.D_E_L_E_T_ = '' "
cQuery2 += " AND T5.D_E_L_E_T_ = '' "
cQuery2 += " ORDER BY T5.T5_CODBEM, T5.T5_SEQRELA"

TCQUERY cQuery2 NEW ALIAS "TMB" 

TMB->(Dbgotop())       

While TMB->(!Eof())

	ST5->(DbSetOrder(1)) //filial+cod
	If !ST5->(DbSeek(xFilial("ST5")+alltrim(_codNovo)+substr(TMB->T5_CODBEM,_tamori+1,9)+TMB->T5_SERVICO+TMB->T5_SEQRELA+TMB->T5_TAREFA))
		_grava := .t.	
	Else 
		_grava := .f.	
	EndIf

	RecLock("ST5",_grava)                     
	
		If _grava = .t.	
        	_auxcod := alltrim(_codNovo)+alltrim(substr(TMB->T5_CODBEM,_tamori+1,4))
			ST5->T5_CODBEM  := ALLTRIM(_auxcod)
			ST5->T5_FILIAL 	:= 	TMB->T5_FILIAL
			ST5->T5_SERVICO	:= 	TMB->T5_SERVICO
			ST5->T5_TAREFA	:= 	TMB->T5_TAREFA
			ST5->T5_SEQRELA	:= 	TMB->T5_SEQRELA
        Endif 

		ST5->T5_SEQUENC	:= 	TMB->T5_SEQUENC
		ST5->T5_DESCRIC	:= 	TMB->T5_DESCRIC
		ST5->T5_DOCFIL	:= 	TMB->T5_DOCFIL
		ST5->T5_DOCTO	:= 	TMB->T5_DOCTO

    MsUnLock("ST5")     

    TMB->(Dbskip())

EndDo
Return(nil)


Static Function ajuSTG()

//-----------------------------------------------------------------------
// MONTA A QUERY PARA STG
//-----------------------------------------------------------------------	 
cQuery3 := " SELECT TF_CODBEM,* "
cQuery3 += " FROM "+RetSqlName("STG")+" TG, "+RetSqlName("STF")+" TF " 
cQuery3 += " WHERE TG.TG_CODBEM LIKE '%" + ALLTRIM(_codBem) + "%'"
cQuery3 += " AND TG_SERVICO = TF_SERVICO "
cQuery3 += " AND TF_SERVICO = '000003' "
cQuery3 += " AND TF.TF_CODBEM = TG.TG_CODBEM  "
cQuery3 += " AND TF.TF_ATIVO <> 'N'"
cQuery3 += " AND TF.TF_CODAREA = 'LUB' "
cQuery3 += " AND TF.TF_SEQRELA = TG.TG_SEQRELA "
cQuery3 += " AND TG.D_E_L_E_T_ = '' AND TF.D_E_L_E_T_ = '' "
cQuery3 += " ORDER BY TG.TG_CODBEM, TG.TG_SEQRELA "

TCQUERY cQuery3 NEW ALIAS "TMC" 

TMC->(Dbgotop())       

While TMC->(!Eof())                                                          

	STG->(DbSetOrder(1)) //filial+cod+PROD 
    STG->(Dbgotop())       

	If !STG->(DbSeek(xFilial("STG")+alltrim(_codNovo)+substr(TMC->TG_CODBEM,_tamori+1,9)+TMC->TG_SERVICO+TMC->TG_SEQRELA+TMC->TG_TAREFA+TMC->TG_TIPOREG+TMC->TG_CODIGO))
		_grava := .T.	
	Else                                                                              
		_grava := .F.	
	Endif

	RecLock("STG",_grava)   
		if _grava = .t.	                  
        	_auxcod := alltrim(_codNovo)+alltrim(substr(TMC->TG_CODBEM,_tamori+1,4))
   			STG->TG_CODBEM  := ALLTRIM(_auxcod)
			STG->TG_FILIAL	:= TMC->TG_FILIAL
			STG->TG_SERVICO	:= TMC->TG_SERVICO			
			STG->TG_SEQRELA	:= TMC->TG_SEQRELA			
			STG->TG_TAREFA	:= TMC->TG_TAREFA
			STG->TG_TIPOREG	:= TMC->TG_TIPOREG
			STG->TG_CODIGO	:= TMC->TG_CODIGO
  		endif
	
		STG->TG_SEQUENC	:= TMC->TG_SEQUENC
		STG->TG_QUANREC	:= TMC->TG_QUANREC
		STG->TG_QUANTID	:= TMC->TG_QUANTID
		STG->TG_UNIDADE	:= TMC->TG_UNIDADE
		STG->TG_RESERVA	:= TMC->TG_RESERVA
		STG->TG_DESTINO	:= TMC->TG_DESTINO
		STG->TG_QTDGARA	:= TMC->TG_QTDGARA
		STG->TG_UNIGARA	:= TMC->TG_UNIGARA
		STG->TG_CONGAR	:= TMC->TG_CONGAR
		STG->TG_LOCAL	:= TMC->TG_LOCAL

    MsUnLock("STG")  

    TMC->(Dbskip())
EndDo

Return(nil)        

Static Function ajuSTH()

//-----------------------------------------------------------------------
// MONTA A QUERY PARA STH
//-----------------------------------------------------------------------	 

cQuery4 := " SELECT TF_CODBEM,* FROM "+RetSqlName("STH")+" TH, "+RetSqlName("STF")+" TF "
cQuery4 += " WHERE TH_CODBEM LIKE '%" + ALLTRIM(_codBem) + "%'"
cQuery4 += " AND TH_SERVICO = '000003' "
cQuery4 += " AND TF_SERVICO = TH_SERVICO "
cQuery4 += " AND TF.TF_CODBEM = TH.TH_CODBEM  "
cQuery4 += " AND TF.TF_ATIVO <> 'N'  "
cQuery4 += " AND TF.TF_CODAREA = 'LUB'  "
cQuery4 += " AND TF.TF_SEQRELA = TH.TH_SEQRELA "
cQuery4 += " AND TH.D_E_L_E_T_ = '' AND TF.D_E_L_E_T_ = '' "
cQuery4 += " ORDER BY TH.TH_CODBEM, TH.TH_SEQRELA"

TCQUERY cQuery4 NEW ALIAS "TMD" 

TMD->(Dbgotop())       

While TMD->(!Eof())                                                          

	STH->(DbSetOrder(1)) //filial+cod+PROD 
    STH->(Dbgotop())       

	If !STH->(DbSeek(xFilial("STH")+alltrim(_codNovo)+substr(TMD->TH_CODBEM,_tamori+1,9)+TMD->TH_SERVICO+TMD->TH_SEQRELA+TMD->TH_TAREFA+TMD->TH_ETAPA))
		_grava := .T.	
	Else                                                                              
		_grava := .F.	
	Endif

	RecLock("STH",_grava)   
		If _grava = .t.
        	_auxcod := alltrim(_codNovo)+alltrim(substr(TMD->TH_CODBEM,_tamori+1,4))
   			STH->TH_CODBEM  := ALLTRIM(_auxcod)
			STH->TH_FILIAL	:= TMD->TH_FILIAL
			STH->TH_SERVICO := TMD->TH_SERVICO
			STH->TH_SEQRELA	:= TMD->TH_SEQRELA
			STH->TH_TAREFA	:= TMD->TH_TAREFA
			STH->TH_ETAPA	:= TMD->TH_ETAPA
			
  		Endif

		STH->TH_SEQUENC	:= TMD->TH_SEQUENC
		STH->TH_OPCOES	:= TMD->TH_OPCOES
		STH->TH_SEQETA	:= TMD->TH_SEQETA

    MsUnLock("STH")  

    TMD->(Dbskip())

EndDo

Return(nil)        
