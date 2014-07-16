
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHEST095  ºAutor ³Fabio William Nico  º Data ³  12/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CONTROLE DE ENTRADA DE CAMINHOES                			  º±±
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

#include 'fivewin.ch'
#include 'topconn.ch'

User Function NHEST095()   

SetPrvt("_aGrupo,_cCodUsr,aCols")
aCols    := {}                  
cString   := "SB1"
cDesc1    := OemToAnsi("Este relatório tem como objetivo o Controle ")
cDesc2    := OemToAnsi("de ENTRADA / SAIDA dos caminhões ")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHFAT095"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("CONTROLE DE ENTRADA E SAIDA DE CAMINHÕES ")                
cabec1    := "Placa     Empresa               Motorista                    Motivo       Dt.Emissao     Hr.Ent.   Dt.Saida       Hr.Saida"
cabec2    := ""//Do Codigo : " + mv_par01 + " ate " + mv_par01
cCancel   := "***** CANCELADO PELO OPERADOR *****"     
nTipo    := 1
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1  
wnrel     := "NHEST095"
_cPerg    := "EST095" 
_nTotal   := 0  
_nTotcol01 := 0  
_nTotcol02 := 0  

Pergunte(_cPerg,.T.) 
nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))  
aDriver 	:= ReadDriver()
cCompac 	:= aDriver[1]
cNormal 	:= aDriver[2] 
cFilterUser := aReturn[7]

cabec2    := "Periodo de : "  + dtoc(mv_par03) + " a " + dtoc(mv_par04)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,.t.,'P')

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
		
	cQuery := " SELECT O5_PLACA,O5_EMPRESA,O5_DESCRI,O5_MOTIVO,O5_EMISSAO,O5_HORAENT,O5_DTSAIDA,O5_HORASAI 
	cQuery += " FROM " + RetSqlName('SO5') +" SO5 "
	cQuery += "	WHERE O5_PLACA BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQuery += " AND O5_EMISSAO BETWEEN '" + DTOS(mv_par03) + "' AND '" + DTOS(mv_par04) + "' "
	If !Empty(AllTrim(mv_par05))
		cQuery += " AND O5_EMPRESA LIKE '%" + mv_par05 + "%'" 
	EndIf
	If !Empty(AllTrim(mv_par06))
		cQuery += " AND O5_DESCRI LIKE '%" + mv_par06 + "%'"
	EndIf
	cQuery += " AND SO5.D_E_L_E_T_ = ''"
	cQuery += " ORDER BY O5_EMISSAO,O5_HORAENT"

	TCQUERY cQuery NEW ALIAS 'TRA1'

Return

Static Function RptDetail()  
Cabec(Titulo, Cabec1,Cabec2,NomeProg,tamanho, nTipo)                                    
DbSelectArea('TRA1')
While TRA1->( ! Eof() )
 	@ Prow()+1, 001 Psay TRA1->O5_PLACA
 	@ Prow()  , 010 Psay SUBSTR(TRA1->O5_EMPRESA,0,20)
 	@ Prow()  , 032 Psay TRA1->O5_DESCRI
	@ Prow()  , 062 Psay Alltrim(TRA1->O5_MOTIVO)
 	@ Prow()  , 075 Psay STOD(TRA1->O5_EMISSAO)
	@ Prow()  , 090 Psay TRA1->O5_HORAENT
	@ Prow()  , 100 Psay STOD(TRA1->O5_DTSAIDA)
	@ Prow()  , 115 Psay TRA1->O5_HORASAI		
    TRA1->(DbSkip())
    
    if Prow() > 70                                                                   
	    Cabec(Titulo,Cabec1,Cabec2,NomeProg,tamanho,nTipo)                                    
	endif
end
@ Prow()+1,000 PSAY __PrtThinLine() 
Return(nil)