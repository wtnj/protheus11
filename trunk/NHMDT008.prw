
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHMDT008  ºAutor  ³José Henrique M Felipetto Data ³08/15/12 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Atendimentos Diários                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MDT                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function NHMDT008()
Private cString   := ""
Private cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir os  ")
Private cDesc2    := OemToAnsi("Atendimentos diários feitos pelos enfermeiros.")
Private cDesc3    := OemToAnsi("")
Private tamanho   := "G"
Private limite    := 232
Private aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
Private nomeprog  := "NHMDT008"
Private nLastKey  := 0
Private titulo    := "Atendimento diário - Enfermaria."
Private cabec1    := "Ficha Médica   Motivo                            Indicação                Medicamento                  Qtdade.       Unid.      Hora.      Observação"
Private cabec2    := ""
Private cCancel   := "***** CANCELADO PELO OPERADOR *****"
Private _nPag     := 1  //Variavel que acumula numero da pagina
Private M_PAG     := 1
Private wnrel     := "NHMDT008"
Private _cPerg    := "MDT008"
Private _nLinha   := 0
Private aDBF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // De data atendimento                  ³
//³ mv_par02             // Ate data atendimento                 ³
//³ mv_par03             // De Atendente                 		 ³
//³ mv_par04             // Ate Atendente                 		 ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿


SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]


Processa( {|| RptDetail()   },"Buscando Dados...")
Processa( {|| WriteReport() },"Imprimindo...")

Set Filter To

If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif

MS_FLUSH()
TRB->( DbCloseArea() )

Return

Static Function RptDetail()
Local cQuery := ""

cQuery := " SELECT * FROM " + RetSqlName("TL5")
cQuery += " WHERE TL5_DTATEN BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "' "
cQuery += " AND   TL5_CODUSU BETWEEN '" + Alltrim(mv_par03) + "' AND '" + Alltrim(mv_par04) + "' "
cQuery += " AND   D_E_L_E_T_ = ''"
cQuery += " AND   TL5_FILIAL = '" + xFilial("TL5") + "' "

TCQUERY cQuery NEW ALIAS "TRB"

TRB->( DbGoTop() )
If TRB->( Eof() )
	alert("Query vazia!")
	Return .F.
EndIf
Return

Static Function WriteReport()

Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

_cCodUsu := TRB->TL5_CODUSU
_nAten   := 0
While TRB->( !Eof() )

	Cabecalho()    
    If TRB->TL5_CODUSU != _cCodUsu
    	@Prow() + 1 , 000 psay "                         "    	
    	_cCodUsu := TRB->TL5_CODUSU
    	_nAten := 0
    EndIf
	
	_nAten++
	
	_cAtendente := IIF(TMK->(DBSEEK(xFILIAL("TMK")+ TRB->TL5_CODUSU )),TMK->TMK_NOMUSU," ")
	_cAtendido  := IIF(TM0->(DBSEEK(xFILIAL("TM0")+ TRB->TL5_NUMFIC )),TM0->TM0_NOMFIC," ")
	_cMotivo    := IIF(TMS->(DBSEEK(xFILIAL("TMS")+ TRB->TL5_MOTIVO )),TMS->TMS_NOMOTI," ")
	_cDescReme  := IIF(TM1->(DBSEEK(xFILIAL("TM1")+ TRB->TL5_CODMED )),TM1->TM1_NOMEDI," ")
	_cUMRemedio := IIF(TM1->(DBSEEK(xFILIAL("TM1")+ TRB->TL5_CODMED )),TM1->TM1_UNIDAD," ")

 	Do Case
 		Case TRB->TL5_INDICA == "1"
 			_cIndicacao := "Inalação"
		Case TRB->TL5_INDICA == "2"
 			_cIndicacao := "Acidente"
 		Case TRB->TL5_INDICA == "3"
 			_cIndicacao := "Medicamento"
 		Case TRB->TL5_INDICA == "4"
 			_cIndicacao := "Verificar P.A"
 		Case TRB->TL5_INDICA == "5"
 			_cIndicacao := "Verificar Temp."
 		Case TRB->TL5_INDICA == "6"
 			_cIndicacao := "Medic. Injetável"
 		Case TRB->TL5_INDICA == "7"
 			_cIndicacao := "Curativo"
 		Case TRB->TL5_INDICA == "8"
 			_cIndicacao := "Massagem"
 		Case TRB->TL5_INDICA == "9"
 			_cIndicacao := "Fisioterapia"
 		Case TRB->TL5_INDICA == "A"
 			_cIndicacao := "Outros"
 		Otherwise
 			_cIndicacao := ""
 	EndCase

	_nLinha++
	_cMatcCC := getUser(_cAtendido)
	//@Prow() 	, 000 pSay " Data: " + TRB->TL5_DTATEN Picture '99/99/99'         
	_cDescCC := IIF( CTT->( DbSeek(xFilial("CTT")+Substr(_cMatcCC,7,9) )) ,CTT->CTT_DESC01,"")
	@Prow() + 1 , 000 pSay "Atendente: " + _cAtendente + " " + " Atendido: " + _cAtendido + " Matrícula: " + Substr(_cMatcCC,1,6) + " Centro de Custo: " + Substr(_cMatcCC,7,9) + " - " + _cDescCC
	
	@Prow() + 1 , 000 pSay Alltrim(TRB->TL5_NUMFIC)
	@Prow()  	, 014 pSay Alltrim(OemToAnsi(_cMotivo))
	@Prow()  	, 048 pSay Alltrim(OemToAnsi(_cIndicacao))
	@Prow()  	, 074 pSay Alltrim(OemToAnsi(_cDescReme))
	@Prow()  	, 106 pSay Alltrim(Str(TRB->TL5_QTDADE))
	@Prow()  	, 118 pSay Alltrim(_cUMRemedio)
	@Prow()  	, 129 pSay Alltrim(TRB->TL5_HRATEN)    Picture "99:99"
	@Prow()  	, 138 pSay Alltrim(TRB->TL5_OBSERV)
	
	TRB->( DbSkip() )	
EndDo

@Prow() + 2 , 000 pSay "Total Consultas no período de " + DTOC(mv_par01) + " até " + DTOC(mv_par02) + ": " + Alltrim(Str(_nLinha)) Picture "@!"

Return

Static Function Cabecalho()
	If Prow() > 58
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf
Return

Static function getUser(nome)
Local cMatcCC := ""
Local cQuery := " SELECT RA_MAT, RA_CC FROM " + RetSqlName("SRA") + " WHERE RA_NOME = '" + nome + "' "
TCQUERY cQuery New Alias "TMP"
cMatcCC := TMP->RA_MAT+TMP->RA_CC
TMP->( DbCloseArea() )
return cMatcCC