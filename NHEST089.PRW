#include 'fivewin.ch'
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHEST073  ºAutor ³Fabio William Nico  º Data ³  12/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ FERRAMENTAS AVARIADAS                        			  º±±
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

User Function NHEST089()   

SetPrvt("_aGrupo,_cCodUsr,aCols")
aCols    := {}                  
cString   := "SD1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir as  ")
cDesc2    := OemToAnsi("Ferramentas avariadas")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST089"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("FERRAMENAS AVARIADAS ")                
cabec1    := "    Data     Doc    Cod.Ferr.             Ferramenta               Cod.Maquina           Maquina       otivo "
cabec2    := "Periodo de : " + mv_par01 + " a " + mv_par01
cCancel   := "***** CANCELADO PELO OPERADOR *****"     
nTipo    := 0
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1  
wnrel     := "NHEST089"
_cPerg    := "EST089" 
_nTotal   := 0  
_nTotcol01 := 0  
_nTotcol02 := 0  
          
// mv_ch01 -> Dt Inicio
// mv_ch02 -> Dt Fim                       
// mv_ch05 -> CC Inicio
// mv_ch06 -> CC Fim
// mv_ch03 -> Conta Inicio
// mv_ch04 -> Conta Fim 
// mv_ch07 -> Tipo Analitico / Sintetico.


Pergunte(_cPerg,.T.) 

cabec2    := "Periodo de : "  + dtoc(mv_par01) + " a " + dtoc(mv_par02)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,'G')

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

		cQuery := " SELECT ZA4_DATA,ZA4_FERRAM,B1_DESC,ZA4_DOC,ZA4_TURNO,ZA4_DEFEIT,ZA4_FORNEC,A2_NREDUZ,ZA4_FUSO,ZA4_MAQUIN,"
		cQuery += " T9_NOME,ZA4_CC,CTT_DESC01,ZA4_BROCA,ZA4_QTDUSA,ZA4_FUNCIO,QAA_NOME,X5_DESCRI "
		cQuery += " FROM " + RetSqlName('ZA4') + " ZA4, " + RetSqlName('QAA') +" QAA , " + RetSqlName('SB1') +" B1 , "
		cQuery += " " + RetSqlName('ST9') +" ST9 , " + RetSqlName('CTT') +" CTT , " + RetSqlName('SA2') +" A2 , " + RetSqlName('SX5') +" X5 "
		cQuery += " WHERE ZA4_DATA BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "
		cQuery += " AND ZA4.ZA4_FUNCIO = QAA.QAA_MAT "
		cQuery += " AND ZA4.ZA4_FERRAM   = B1.B1_COD "
		cQuery += " AND ZA4.ZA4_MAQUIN   = ST9.T9_CODBEM "
		cQuery += " AND ZA4.ZA4_CC       = CTT.CTT_CUSTO "
		cQuery += " AND ZA4.ZA4_FORNEC   = A2.A2_COD "
		cQuery += " AND X5.X5_TABELA  = 'Z3' "
		cQuery += " AND X5.X5_CHAVE = ZA4_DEFEIT "


		MemoWrit('C:\TEMP\NHEST089.SQL',cQuery)
		TCQUERY cQuery NEW ALIAS 'TRA1'

		If	! USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf
Return



Static Function RptDetail()  
Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo)                                    
DbSelectArea('TRA1')
While TRA1->( ! Eof() )
 	@ Prow()+1 , 001 Psay STOD(TRA1->ZA4_DATA)
 	@ Prow()   , 012 Psay TRA1->ZA4_DOC
 	@ Prow()   , 020 Psay TRA1->ZA4_FERRAM
 	@ Prow()   , 035 Psay TRA1->B1_DESC
	@ Prow()   , 068 Psay TRA1->ZA4_MAQUIN
	@ Prow()   , 083 Psay TRA1->T9_NOME  
	@ Prow()   , 115 Psay TRA1->ZA4_DEFEIT
	@ Prow()   , 120 Psay TRA1->X5_DESCRI
	@ Prow()   , 140 Psay SUBSTR(TRA1->CTT_DESC01,0,15)
	@ Prow()   , 157 Psay SUBSTR(TRA1->QAA_NOME,0,15)

 	
    TRA1->(DbSkip())
end

	   	
@ Prow()+2,000 PSAY __PrtThinLine() 


Return(nil)