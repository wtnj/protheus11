#include 'fivewin.ch'
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHQDO011 ºAutor ³Fabio William Nico  º Data ³  01/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATORIO DE LICOES APREENDIDAS               			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Controle de Documentos                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHQDO012()   

SetPrvt("_aGrupo,_cCodUsr,aCols")
aCols    := {}                  
cString   := "SZO"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo ")
cDesc2    := OemToAnsi("Licoes Apreendidas ")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHQDO012"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATORIO DE LICOES APRENDIDAS CONTROLE DE SAIDA/ENTRADA DE CAMINHOES ")                
cabec1    := "IDENTIFICAÇÃO         CAUSA                AÇÃO       PRODUTO                    RESPONSAVEL  "
cabec2    := "Do Codigo : " + mv_par01 + " ate " + mv_par01
cCancel   := "***** CANCELADO PELO OPERADOR *****"     
nTipo    := 1
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1  
wnrel     := "NHQDO012"
_cPerg    := "QDO012" 
_nTotal   := 0  
_nTotcol01 := 0  
_nTotcol02 := 0  

Pergunte(_cPerg,.T.) 
nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))  
aDriver 	:= ReadDriver()
cCompac 	:= aDriver[1]
cNormal 	:= aDriver[2] 
cFilterUser := aReturn[7]


cabec2    := "Dt abertura de: "  + dtoc(mv_par03) + " a " + dtoc(mv_par04)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,.t.,'P')

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif


Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")

//TRB->(DbCloseArea()) 
//TR3->(DbCloseArea()) 

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
TRA1->(DbCloseArea())

Return

Static Function Gerando()

		cQuery := " SELECT ZO_IDENTIF,ZO_DESCRI,ZO_CAUSA,ZO_ACAO,ZO_COD,ZO_RESP,B1_DESC,QAA_NOME "
		cQuery += " FROM " + RetSqlName('SZO') +" SZO, " + RetSqlName('SB1') +" SB1, " + RetSqlName('QAA') +" QAA "
		cQuery += "	WHERE ZO_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
		cQuery += " AND ZO_DTABERT BETWEEN '" + DTOS(mv_par03) + "' AND '" + DTOS(mv_par04) + "' "
		if mv_par05 <= 4
   			cQuery += " AND ZO_STATUS = '" + ALLTRIM(STR(mv_par05)) + "' "
  		endif                              
		cQuery += " AND SB1.B1_COD = SZO.ZO_COD "
		cQuery += " AND SZO.ZO_RESP = QAA.QAA_MAT "
		cQuery += " AND QAA.D_E_L_E_T_ = '' "
		cQuery += " AND SB1.D_E_L_E_T_ = '' "
		cQuery += " AND SZO.D_E_L_E_T_ = '' "
		MemoWrit('C:\TEMP\NHQDO011.SQL',cQuery)
		TCQUERY cQuery NEW ALIAS 'TRA1'
		If	!USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf
Return

Static Function RptDetail()  
Cabec(Titulo, Cabec1,Cabec2,NomeProg,tamanho, nTipo)                                    
DbSelectArea('TRA1')
While TRA1->( ! Eof() )
 	@ Prow()+1, 001 Psay TRA1->ZO_IDENTIF
 	@ Prow()  , 030 Psay TRA1->ZO_COD
	@ Prow()  , 050 Psay TRA1->B1_DESC
 	@ Prow()+1, 030 Psay TRA1->ZO_RESP 	
 	@ Prow()  , 040 Psay TRA1->QAA_NOME
 	@ Prow()+1, 001 Psay "CAUSA: " +SUBSTR(TRA1->ZO_CAUSA,1,100)
 	if alltrim(SUBSTR(TRA1->ZO_CAUSA,101,200)) <> ''
	 	@ Prow()+1, 001 Psay SUBSTR(TRA1->ZO_CAUSA,101,200)
	endif
 	@ Prow()+1, 001 Psay "ACAO : " +SUBSTR(TRA1->ZO_ACAO,1,100)
 	if alltrim(SUBSTR(TRA1->ZO_CAUSA,101,200)) <> ''
	 	@ Prow()+1, 001	Psay SUBSTR(TRA1->ZO_ACAO,101,200)
	endif          
    @ Prow()+1,000 PSAY __PrtThinLine() 
    TRA1->(DbSkip())
    
    if Prow() > 70                                                                   
	    Cabec(Titulo,Cabec1,Cabec2,NomeProg,tamanho,nTipo)                                    
	endif
end
Return(nil)