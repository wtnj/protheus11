#include 'fivewin.ch'
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHEST094  ºAutor ³Fabio William Nico  º Data ³  12/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CONTROLE ALMOXARIFADO                          			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Estoque Custos                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHEST094()   

SetPrvt("_aGrupo,_cCodUsr,aCols")
aCols    := {}                  
cString   := "SB1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo o Controle Interno  ")
cDesc2    := OemToAnsi("dos itens de almoxarifado")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST094"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("CONTROLE INTERNO DE ALMOXARIFADO ")                
cabec1    := " Codigo           Descricao                              Desc. Complementar                                                                                        Localizacao                  Saldo Atual     Ultimo Preco"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"     
nTipo    := 1
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1  
wnrel     := "NHEST094"
_cPerg    := "EST094" 
_nTotal   := 0  
_nTotcol01 := 0  
_nTotcol02 := 0  

Pergunte(_cPerg,.T.) 
nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))  
aDriver 	:= ReadDriver()
cCompac 	:= aDriver[1]
cNormal 	:= aDriver[2] 
cFilterUser := aReturn[7]


cabec2    := "Do Codigo : "  + mv_par01 + " a " + mv_par02
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

		cQuery := " SELECT B1_COD,B1_LOCPAD,B1_DESC, B5_CEME, B2_QATU, B1_LOCAFIS,B1_UPRC"
		cQuery += " FROM " + RetSqlName('SB1') + " B1, " + RetSqlName('SB5') +" SB5 , " + RetSqlName('SB2') +" B2 "
		cQuery += " WHERE B1.B1_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
		cQuery += " AND B2.B2_COD = B1.B1_COD "
		cQuery += " AND SB5.B5_COD = B1.B1_COD "
		cQuery += " AND B2.B2_LOCAL = B1.B1_LOCPAD "
		if alltrim(mv_par03) <> ''
			cQuery += " AND SB5.B5_CEME LIKE '%" + alltrim(mv_par03) + "%'"			
		endif
		cQuery += " AND B1.D_E_L_E_T_ = ''"
		cQuery += " AND B2.D_E_L_E_T_ = ''"
		cQuery += " AND SB5.D_E_L_E_T_ = ''"
		MemoWrit('C:\TEMP\NHEST094.SQL',cQuery)
		TCQUERY cQuery NEW ALIAS 'TRA1'
		If	!USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf
Return

Static Function RptDetail()  
Cabec(Titulo, Cabec1,Cabec2,NomeProg, tamanho, nTipo)                                    
DbSelectArea('TRA1')
While TRA1->( ! Eof() )
 	@ Prow()+1 , 001 Psay TRA1->B1_COD
 	@ Prow()   , 017 Psay TRA1->B1_DESC
 	@ Prow()   , 055 Psay SUBSTR(TRA1->B5_CEME,1,100)
 	if alltrim(SUBSTR(TRA1->B5_CEME,101,200)) <> ''
	 	@ Prow()+1 , 055 Psay SUBSTR(TRA1->B5_CEME,101,200)
    endif
 	@ Prow()   , 170 Psay TRA1->B1_LOCAFIS

	@ Prow()   , 190 Psay TRA1->B2_QATU PICTURE '@e 9,999,999.99'
	@ Prow()   , 205 Psay TRA1->B1_UPRC PICTURE '@e 9,999,999.99'	
    TRA1->(DbSkip())
    
    if Prow() > 70                                                                   
	    Cabec(Titulo, Cabec1,Cabec2,NomeProg, tamanho, nTipo)                                    
	endif
end
@ Prow()+1,000 PSAY __PrtThinLine() 
Return(nil)