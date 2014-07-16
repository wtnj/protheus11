/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHFIN098  ºAutor  ³Microsiga            º Data ³  20/02/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alterado por João Felipe da Rosa, incluída coluna C.custo   ±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "FINR190.CH"
#Include "PROTHEUS.Ch"

Static lFWCodFil := FindFunction("FWCodFil")

// 17/08/2009 - Compilacao para o campo filial de 4 posicoes
// 18/08/2009 - Compilacao para o campo filial de 4 posicoes

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR190  ³ Autor ³ Adrianne Furtado      ³ Data ³ 02.09.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rela‡„o das baixas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±       
±±³Sintaxe   ³ FINR190(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß                                        
/*/
User Function nhfin098()

Local oReport  
Private cChaveInterFun := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualizar o as perguntas "Codigo de" e "Codigo Até" para não estavam no ³
//³grupo SXG do codigo de Cliente/Fornecedor só retirar na proxima versão  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

FR190ATSX1()

If FindFunction("TRepInUse") .And. TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	FinR190R3()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Nereu Humberto Junior  ³ Data ³16.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport 
Local oSection 
Local oCell         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("FINR190",STR0009,"FIN190", {|oReport| ReportPrint(oReport)},STR0006+" "+STR0007+" "+STR0008) //"Relacao de Amarracao Grupo x Fornecedor"##"Este programa tem como objetivo , relacionar os Grupos e seus"##"respectivos Fornecedores."

AjustaSX1()

Pergunte("FIN190",.F.)

oReport:SetLandScape() 

oBaixas := TRSection():New(oReport,STR0072,{"SE5","SED"},{STR0001,STR0002,STR0003,STR0004,STR0032,STR0005,STR0036,STR0048}) //"Baixas"
// ORDEM:
/*"Por Data" "Por Banco" "Por Natureza" "Alfabetica"
"Nro. Titulo" "Dt.Digitacao" " Por Lote" "Por Data de Credito"*/

oBaixas:SetTotalInLine(.F.)

TRCell():New(oBaixas,"E5_PREFIXO"	,, STR0049,,TamSx3("E5_PREFIXO")[1], .F.)	//"Prf"

If "PTG/MEX" $ cPaisLoc
	TRCell():New(oBaixas,"E5_NUMERO" 	,, STR0050,,TamSx3("E5_NUMERO")[1]+18,.F.)	//"Numero"
Else
	TRCell():New(oBaixas,"E5_NUMERO" 	,, STR0050,,TamSx3("E5_NUMERO")[1]+2,.F.)	//"Numero"
Endif

TRCell():New(oBaixas,"E5_PARCELA"	,, STR0051,,TamSx3("E5_PARCELA")[1], .F.)	//"Prc"
TRCell():New(oBaixas,"E5_TIPODOC"	,, STR0052,,TamSx3("E5_TIPODOC")[1], .F.)	//"TP"
TRCell():New(oBaixas,"E5_CLIFOR"	,, STR0053,,TamSx3("E5_CLIFOR")[1]+8, .F.)	//"Cli/For"
TRCell():New(oBaixas,"NOME CLI/FOR"	,, STR0054,, 20, .F.)	//"Nome Cli/For"
TRCell():New(oBaixas,"E5_NATUREZ"	,, STR0055,,11/*TamSx3("E5_NATUREZ")[1]*/, .F.)	//"Natureza"
TRCell():New(oBaixas,"E5_VENCTO"	,, STR0056,,TamSx3("E5_VENCTO")[1], .F.)	//"Vencto"
TRCell():New(oBaixas,"E5_HISTOR"	,, STR0057,, TamSx3("E5_HISTOR")[1]+8, .F.)	//"Historico"
TRCell():New(oBaixas,"E5_DATA"		,, STR0058,,TamSx3("E5_DATA")[1], .F.)	//"Dt Baixa"
TRCell():New(oBaixas,"E5_VALOR"		,, STR0059,, TamSX3("E5_VALOR")[1]+10	,/*[lPixel]*/,,"RIGHT",,"RIGHT")	//"Valor Original"
TRCell():New(oBaixas,"JUROS/MULTA"	,, STR0060,, TamSX3("E5_VLJUROS")[1],/*[lPixel]*/,,"RIGHT",,"RIGHT")//"Jur/Multa"
TRCell():New(oBaixas,"CORRECAO"		,, STR0061,, TamSX3("E5_VLCORRE")[1],/*[lPixel]*/,,"RIGHT",,"RIGHT")//"Correcao"
TRCell():New(oBaixas,"DESCONTO"		,, STR0062,, TamSX3("E5_VLDESCO")[1],/*[lPixel]*/,,"RIGHT",,"RIGHT")//"Descontos"
TRCell():New(oBaixas,"ABATIMENTO"	,, STR0063,, TamSX3("E5_VLDESCO")[1],/*[lPixel]*/,,"RIGHT",,"RIGHT")//"Abatim."
TRCell():New(oBaixas,"IMPOSTOS"		,, STR0064,, TamSX3("E5_VALOR")[1]	,/*[lPixel]*/,,"RIGHT",,"RIGHT")	//"Impostos"
TRCell():New(oBaixas,"E5_VALORPG"	,, STR0065,, TamSX3("E5_VALOR")[1]+10,/*[lPixel]*/,,"RIGHT",,"RIGHT")//"Total Baixado"
TRCell():New(oBaixas,"E5_BANCO"		,, STR0066,, TamSX3("E5_BANCO")[1]+1,.T.)	//"Bco"
TRCell():New(oBaixas,"E5_DTDIGIT"	,, STR0067,,8, .T.)	//"Dt Dig."
TRCell():New(oBaixas,"E5_MOTBX"		,, STR0068,,3, .T.)	//"Mot"
TRCell():New(oBaixas,"E5_ORIG"		,, STR0069,,2, .T.)	//"Orig"

oBaixas:SetNoFilter({"SED"})

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Nereu Humberto Junior  ³ Data ³16.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)
Local oBaixas	:= oReport:Section(1)
Local nOrdem	:= oReport:Section(1):GetOrder() 
Local cAliasSE5	:= "SE5"
Local cTitulo 	:= "" 
Local cSuf		:= LTrim(Str(mv_par12))
Local cMoeda	:= GetMv("MV_MOEDA"+cSuf)     
Local cCondicao	:= "" 
Local cCond1 	:= ""
Local cChave 	:= ""
Local bFirst
Local oBreak1, oBreak2
Local nDecs	   	:= GetMv("MV_CENT"+(IIF(mv_par12 > 1 , STR(mv_par12,1),""))) 
Local cAnterior, cAnt     
Local aRelat	:={}	   
Local nI  := 1           
Local lVarFil	:= (mv_par17 == 1 .and. SM0->(Reccount()) > 1	) // Cons filiais abaixo
Local nTotBaixado := 0                 
Local aTotais	:={}
Local cTotText	:=	""    
Local nGerOrig	:= 0
Local nRegSM0 := SM0->(Recno())
Local nRegSE5 := SE5->(Recno())
Local nJ		:= 1
Private cNomeArq


cFilterUser := ""       

AjustaSx1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par11 == 1
	cTitulo := STR0011 + cMoeda  //"Relacao dos Titulos Recebidos em "
Else
	cTitulo := STR0013 + cMoeda  //"Relacao dos Titulos Pagos em "
EndIf

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³aRelat[x][01]: Prefixo			³
//³         [02]: Numero 			³
//³         [03]: Parcela			³
//³         [04]: Tipo do Documento	³
//³         [05]: Cod Cliente/Fornec³
//³         [06]: Nome Cli/Fornec	³
//³         [07]: Natureza         	³
//³         [08]: Vencimento       	³
//³         [09]: Historico       	³
//³         [10]: Data de Baixa    	³
//³         [11]: Valor Original   	³
//³         [12]: Jur/Multa        	³
//³         [13]: Correcao         	³
//³         [14]: Descontos        	³
//³         [15]: Abatimento       	³
//³         [16]: Impostos         	³
//³         [17]: Total Pago       	³
//³         [18]: Banco            	³
//³         [19]: Data Digitacao   	³
//³         [20]: Motivo           	³
//³         [21]: Filial de Origem 	³
//³         [22]: Filial            ³      
//³         [23]: E5_BENEF - cCliFor³
//³         [24]: E5_LOTE          	³ 
//³         [25]: E5_DTDISPO        ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

aRelat := FA190ImpR4(nOrdem,@aTotais,oReport,@nGerOrig)

If Len(aRelat) = 0
	Return Nil
EndIf

Do Case
Case nOrdem == 1
	nCond1  := 10
	cTitulo += STR0015  //" por data de pagamento"
Case nOrdem == 2
	nCond1  := 18
	cTitulo += STR0016 // " por Banco"
Case nOrdem == 3
	nCond1  := 7
	cTitulo += STR0017  //" por Natureza"
Case nOrdem == 4
	nCond1  := 23 //E5_BENEF   
	cTitulo += STR0020  //" Alfabetica"
Case nOrdem == 5
	nCond1  := 2
	cTitulo += STR0035 //" Nro. dos Titulos"
Case nOrdem == 6	//Ordem 6 (Digitacao)
	nCond1  := 19
	cTitulo += STR0019  //" Por Data de Digitacao"
Case nOrdem == 7 // por Lote
	nCond1  := 24	//"E5_LOTE"
	cTitulo += STR0036  //" por Lote"
OtherWise						// Data de Crédito (dtdispo)
	nCond1  := 25	//"E5_DTDISPO"
	cTitulo += STR0015  //" por data de pagamento"
EndCase

If !Empty(mv_par28) .And. ! ";" $ mv_par28 .And. Len(AllTrim(mv_par28)) > 3
	ApMsgAlert(STR0073)//"Separe os tipos a imprimir (pergunta 28) por um ; (ponto e virgula) a cada 3 caracteres"
	Return(Nil)
Endif	
If !Empty(mv_par29) .And. ! ";" $ mv_par29 .And. Len(AllTrim(mv_par29)) > 3
	ApMsgAlert(STR0074)//"Separe os tipos que não deseja imprimir (pergunta 29) por um ; (ponto e virgula) a cada 3 caracteres"
	Return(Nil)
Endif	

//Validacao no array para que seus tipos nao gerem error log
//no exec block em TrPosition()
aEval(aRelat, {|e| Iif( e[5] == Nil, e[5] := "", .T. )} )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Metodo TrPosition()                                                     ³
//³                                                                        ³
//³Posiciona em um registro de uma outra tabela. O posicionamento será     ³
//³realizado antes da impressao de cada linha do relatório.                ³
//³                                                                        ³
//³                                                                        ³
//³ExpO1 : Objeto Report da Secao                                          ³
//³ExpC2 : Alias da Tabela                                                 ³
//³ExpX3 : Ordem ou NickName de pesquisa                                   ³
//³ExpX4 : String ou Bloco de código para pesquisa. A string será macroexe-³
//³        cutada.                                                         ³
//³                                                                        ³				
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRPosition():New(oBaixas,"SED",1,{|| xFilial("SED") + aRelat[nI,07]})

//**************************************************
// Bloco comentado pela chave do SE5 utilizada não *
// esta completa. Este sendo utilizado o nRecSe5.  *
//**************************************************
//If !((MV_MULNATR .and. mv_par11 = 1 .and. mv_par38 = 2 .and. !mv_par39 == 2) .or. (MV_MULNATP .and. mv_par11 = 2 .and. mv_par38 = 2 .and. !mv_par39 == 2) )
//	TRPosition():New(oBaixas,"SE5",7,{|| xFilial("SE5") + aRelat[nI,01]+ aRelat[nI,02]+ aRelat[nI,03]+ aRelat[nI,04]+ aRelat[nI,05]})
//EndIf	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oBaixas:Cell("E5_PREFIXO")	:SetBlock( { || aRelat[nI,01] } )
oBaixas:Cell("E5_NUMERO")	:SetBlock( { || aRelat[nI,02] } )
oBaixas:Cell("E5_PARCELA")	:SetBlock( { || aRelat[nI,03] } )
oBaixas:Cell("E5_TIPODOC")	:SetBlock( { || aRelat[nI,04] } )
oBaixas:Cell("E5_CLIFOR")	:SetBlock( { || aRelat[nI,05] } )
oBaixas:Cell("NOME CLI/FOR"):SetBlock( { || aRelat[nI,06] } )
oBaixas:Cell("E5_NATUREZ")	:SetBlock( { || aRelat[nI,07] } )
oBaixas:Cell("E5_VENCTO")	:SetBlock( { || aRelat[nI,08] } )
oBaixas:Cell("E5_HISTOR")	:SetBlock( { || aRelat[nI,09] } )
oBaixas:Cell("E5_DATA")		:SetBlock( { || aRelat[nI,10] } )
oBaixas:Cell("E5_VALOR")	:SetBlock( { || aRelat[nI,11] } )
oBaixas:Cell("JUROS/MULTA"):SetBlock( { || aRelat[nI,12] } )
oBaixas:Cell("CORRECAO")	:SetBlock( { || aRelat[nI,13] } )
oBaixas:Cell("DESCONTO")	:SetBlock( { || aRelat[nI,14] } )
oBaixas:Cell("ABATIMENTO")	:SetBlock( { || aRelat[nI,15] } )
oBaixas:Cell("IMPOSTOS")	:SetBlock( { || aRelat[nI,16] } )
oBaixas:Cell("E5_VALORPG")	:SetBlock( { || aRelat[nI,17] } )
oBaixas:Cell("E5_BANCO")	:SetBlock( { || aRelat[nI,18] } )
oBaixas:Cell("E5_DTDIGIT")	:SetBlock( { || aRelat[nI,19] } )
oBaixas:Cell("E5_MOTBX")	:SetBlock( { || aRelat[nI,20] } )
oBaixas:Cell("E5_ORIG")		:SetBlock( { || aRelat[nI,21] } )

oBaixas:SetTotalText(STR0029) //"Total Geral : "
oBaixas:SetHeaderPage()    

	If (nOrdem == 1 .or. nOrdem == 6 .or. nOrdem == 8)
		oBreak1 := TRBreak():New( oBaixas, { || aRelat[nI][22]+DToS(aRelat[nI][nCond1]) }, STR0071) //"Sub Total"
		oBreak1:SetTotalText({ || cTotText })	 //"Sub Total"             
	Else //nOrdem == 2 .or. nOrdem == 3 .or. nOrdem == 4 .or. nOrdem == 5 .or. nOrdem == 7
		oBreak1 := TRBreak():New( oBaixas, { || aRelat[nI][22]+aRelat[nI][nCond1] }, STR0071) //"Sub Total"
		oBreak1:SetTotalText({ || cTotText })	 //"Sub Total"
	EndIf
	oBreak3 := TRBreak():New( oReport, { || }, STR0029) //"Total Geral"
	
//             New(<oParent>                       , [cID], <cFunction>, [oBreak], [cTitle], [cPicture], [uFormula], [lEndSection], [lEndReport]) --> NIL
TRFunction():New(oBaixas:Cell("E5_VALOR")	 	,/*[cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("E5_VALOR")  :nSize,nDecs), {|| If(aRelat[nI,26],aRelat[nI,11],0) }/*[ uFormula ]*/ , .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("JUROS/MULTA")	,/*[cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("JUROS/MULTA") :nSize,nDecs), /*[ uFormula ]*/ , .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("CORRECAO")	 	,/*[cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("CORRECAO")  :nSize,nDecs), /*[ uFormula ]*/ , .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("DESCONTO")	 	,/*[cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("DESCONTO")  :nSize,nDecs), /*[ uFormula ]*/ , .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("ABATIMENTO") 	,/*[cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("ABATIMENTO"):nSize,nDecs), /*[ uFormula ]*/ , .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("IMPOSTOS")	 	,/*[cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("IMPOSTOS")  :nSize,nDecs), /*[ uFormula ]*/ , .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("E5_VALORPG")	    ,/*[cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("E5_VALORPG"):nSize,nDecs), {|| aRelat[nI][27]}/*[ uFormula ]*/ , .F., .F.,.F.) //"Sub Total"

If ((MV_MULNATR .and. mv_par11 = 1 .and. MV_PAR38 = 2) .or. (MV_MULNATP .and. mv_par11 = 2 .and. MV_PAR38 = 2))
	TRFunction():New(oBaixas:Cell("E5_VALOR")	 	,/*[cID*/, "SUM", oBreak3  , STR0029, tm(E5_VALOR,oBaixas:Cell("E5_VALOR")  :nSize,nDecs), {|| If(aRelat[nI,26],aRelat[nI,11],0) }/*[ uFormula ]*/ , .F., .F.,.F.) //"Total Geral : "
Else	
	TRFunction():New(oBaixas:Cell("E5_VALOR")	 	,/*[cID*/, "SUM", oBreak3  , STR0029, tm(E5_VALOR,oBaixas:Cell("E5_VALOR")  :nSize,nDecs), {|| If(aRelat[nI,26],aRelat[nI,11],0) }/*[ uFormula ]*/ , .F., .F.,.F.) //"Total Geral : "
EndIf
TRFunction():New(oBaixas:Cell("JUROS/MULTA")	,/*[cID*/, "SUM", oBreak3  , STR0071, tm(E5_VALOR,oBaixas:Cell("JUROS/MULTA") :nSize,nDecs), /*[ uFormula ]*/ , .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("CORRECAO")	 	,/*[cID*/, "SUM", oBreak3  , STR0071, tm(E5_VALOR,oBaixas:Cell("CORRECAO")  :nSize,nDecs), /*[ uFormula ]*/ , .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("DESCONTO")	 	,/*[cID*/, "SUM", oBreak3  , STR0071, tm(E5_VALOR,oBaixas:Cell("DESCONTO")  :nSize,nDecs), /*[ uFormula ]*/ , .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("ABATIMENTO") 	,/*[cID*/, "SUM", oBreak3  , STR0071, tm(E5_VALOR,oBaixas:Cell("ABATIMENTO"):nSize,nDecs), /*[ uFormula ]*/ , .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("IMPOSTOS")	 	,/*[cID*/, "SUM", oBreak3  , STR0071, tm(E5_VALOR,oBaixas:Cell("IMPOSTOS")  :nSize,nDecs), /*[ uFormula ]*/ , .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("E5_VALORPG")	    ,/*[cID*/, "SUM", oBreak3  , STR0071, tm(E5_VALOR,oBaixas:Cell("E5_VALORPG"):nSize,nDecs), {|| aRelat[nI][27]}/*[ uFormula ]*/ , .F., .F.,.F.) //"Sub Total"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprimir TOTAL por filial somente quan-³
//³ do houver mais do que 1 filial.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lVarFil
	oBreak2 := TRBreak():New( oBaixas, { || aRelat[nI][22] }, STR0070) //"FILIAL"
	TRFunction():New(oBaixas:Cell("E5_VALOR")	 	,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("E5_VALOR")  :nSize,nDecs), {|| If(aRelat[nI,26],aRelat[nI,11],0) }/*[ uFormula ]*/ , .F., .F.) //"FILIAL"
	TRFunction():New(oBaixas:Cell("JUROS/MULTA")	,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("JUROS/MULTA") :nSize,nDecs), /*[ uFormula ]*/ , .F., .F.) //"FILIAL"
	TRFunction():New(oBaixas:Cell("CORRECAO")	 	,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("CORRECAO")  :nSize,nDecs), /*[ uFormula ]*/ , .F., .F.) //"FILIAL"
	TRFunction():New(oBaixas:Cell("DESCONTO")	 	,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("DESCONTO")  :nSize,nDecs), /*[ uFormula ]*/ , .F., .F.) //"FILIAL"
	TRFunction():New(oBaixas:Cell("ABATIMENTO") 	,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("ABATIMENTO"):nSize,nDecs), /*[ uFormula ]*/ , .F., .F.) //"FILIAL"
	TRFunction():New(oBaixas:Cell("IMPOSTOS")	 	,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("IMPOSTOS")  :nSize,nDecs), /*[ uFormula ]*/ , .F., .F.) //"FILIAL"
	TRFunction():New(oBaixas:Cell("E5_VALORPG")	,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("E5_VALORPG"):nSize,nDecs), {|| aRelat[nI][27]}/*[ uFormula ]*/ , .F., .F.) //"FILIAL"
	oBreak2:SetTotalText({ || STR0070 + " : " + cTxtFil })	 //"FILIAL"
EndIf

	oBreak1:OnPrintTotal({ || PRINTTOT(aTotais,oReport,.F.,,@nJ   ) })
	If nOrdem != 3 .and. lVarFil
		oBreak2:OnPrintTotal({ || PRINTTOT(aTotais,oReport,.T.,,@nJ) })	
	EndIf

oBaixas:Cell("E5_VALOR")	:SetPicture(tm(E5_VALOR,oBaixas:Cell("E5_VALOR")  :nSize,nDecs))
oBaixas:Cell("JUROS/MULTA"):SetPicture(tm(E5_VALOR,oBaixas:Cell("JUROS/MULTA"):nSize,nDecs))
oBaixas:Cell("CORRECAO")	:SetPicture(tm(E5_VALOR,oBaixas:Cell("CORRECAO")  :nSize,nDecs))
oBaixas:Cell("DESCONTO")	:SetPicture(tm(E5_VALOR,oBaixas:Cell("DESCONTO")  :nSize,nDecs))
oBaixas:Cell("ABATIMENTO")	:SetPicture(tm(E5_VALOR,oBaixas:Cell("ABATIMENTO"):nSize,nDecs))
oBaixas:Cell("IMPOSTOS")	:SetPicture(tm(E5_VALOR,oBaixas:Cell("IMPOSTOS")  :nSize,nDecs))
oBaixas:Cell("E5_VALORPG")	:SetPicture(tm(E5_VALOR,oBaixas:Cell("E5_VALORPG"):nSize,nDecs))
                         
oReport:SetTitle(cTitulo)
oReport:SetMeter(Len(aRelat))  

oBaixas:Init()                  	
nI := 1
While nI <= Len(aRelat)

	If oReport:Cancel()
		nI++
		Exit
	EndIf
        
    If ((MV_MULNATR .and. mv_par11 = 1 .and. mv_par38 = 2 .and. !mv_par39 == 2) .or. (MV_MULNATP .and. mv_par11 = 2 .and. mv_par38 = 2 .and. !mv_par39 == 2) )
		If !Empty(aRelat[nI,28])
			SE5->(dbGoTo(aRelat[nI,29]))
		Endif	
    Endif
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona na Filial do Movimento a ser impresso³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((MV_MULNATR .and. mv_par11 = 1 .and. mv_par38 = 2 .and. !mv_par39 == 2) .or. (MV_MULNATP .and. mv_par11 = 2 .and. mv_par38 = 2 .and. !mv_par39 == 2))
	  	SE5->(dbGoto(aRelat[nI,29]))
	Else
	  	SE5->(dbGoto(aRelat[nI,28]))
	Endif
  	cFilAnt := SE5->E5_FILIAL
   oReport:IncMeter()
	oBaixas:PrintLine()

	If (nOrdem == 1 .or. nOrdem == 6 .or. nOrdem == 8)
		cTotText := STR0071 + " : " + DToC(aRelat[nI][nCond1]) //"Sub Total"
	Else //nOrdem == 2 .or. nOrdem == 3 .or. nOrdem == 4 .or. nOrdem == 5 .or. nOrdem == 7
		cTotText := STR0071 + " : " + aRelat[nI][nCond1]       //"Sub Total"
		If nOrdem == 2 //Banco
			SA6->(DbSetOrder(1))
			SA6->(MsSeek(xFilial("SA6")+aRelat[nI][nCond1]))
			cTotText += " " + TRIM(SA6->A6_NOME)
		ElseIf nOrdem == 3 //Natureza
			SED->(DbSetOrder(1))
			SED->(MsSeek(xFilial("SED")+aRelat[nI][nCond1]))
			cTotText += SED->ED_DESCRIC
		EndIf
	EndIf
	
	If lVarFil
		cTxtFil := aRelat[nI][22]
	EndIf               

	nI++

EndDo
SE5->(dbGoto(nRegSE5))
SM0->(dbGoTo(nRegSM0))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

//nao retirar "nI--" pois eh utilizado na impressao do ultimo TRFunction
nI--

oBaixas:Finish()
PRINTTOT(aTotais,oReport,.F.,3,@nJ)

Return NIL


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ PRINTTOT ³ Autor ³ Daniel Tadashi Batori ³ Data ³ 10.10.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime os totais "Baixados", "Mov Fin.", "Compens."       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PRINTTOT(aTotal,oReport,lFil)                              ³±±
±±³          ³ aTotais -> array a ser utilizado para impressao            ³±±
±±³          ³ oReport -> objeto TReport                                  ³±±
±±³          ³ lFil -> .F. se for total da secao ou .T. se for da filial  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PRINTTOT(aTotais,oReport,lFil,nBreak,nJ)
Local nDecs := GetMv("MV_CENT"+(If(mv_par12 > 1 , STR(mv_par12,1),""))) 
Local cAnt := ""
Local nAscan := 0 
Local cGeral := OemToAnsi(STR0075)  
Default nJ 	 := 1

If lFil == .T.
	oReport:SkipLine(2)
EndIf

nAscan := Ascan(aTotais , {|e| Alltrim(e[1]) ==  cGeral } )

If nBreak <> 3
	If Len(aTotais)>0
		If (MV_MULNATP .Or. MV_MULNATR) .And. !(aTotais[nJ][1] $ "/") .And. Len(aTotais[nJ]) > 3
			cAnt := aTotais[nJ][4]      
		Else
			cAnt := aTotais[nJ][1]
		EndIf
	EndIf
	While (nJ< Len(aTotais)) .And. (IIf(ValType(cAnt) <> ValType(aTotais[nJ][1]) .And. Len(aTotais[nJ]) == 3,"",cAnt) == IIF((MV_MULNATP .Or. MV_MULNATR) .And. !(aTotais[nJ][1] $ "/") .And.;
	 		Len(aTotais[nJ]) > 3,aTotais[nJ][4],aTotais[nJ][1])) .And. nJ < nAscan
		oReport:PrintText( PadR(aTotais[nJ][2],12," ") + Transform(aTotais[nJ][3], tm(aTotais[nJ][3],20,nDecs) ) )
		nJ++
	EndDo
Else    
	oReport:PrintText( '' )
	oReport:PrintText( STR0075 + ':' )
	While nAscan > 0 
		oReport:PrintText( PadR(aTotais[nAscan][2],12," ") + Transform(aTotais[nAscan][3], tm(aTotais[nAscan][3],20,nDecs) ) )
		nAscan := If( (nAscan+1)<=Len(aTotais) .and. aTotais[nAscan+1][1] == cGeral,nAscan+1,0)
	EndDo
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FINR190  ³ Autor ³ Wagner Xavier         ³ Data ³ 05.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rela‡„o das baixas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FINR190(void)                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FinR190R3()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local wnrel
Local aOrd:={OemToAnsi(STR0001),OemToAnsi(STR0002),OemToAnsi(STR0003),OemToAnsi(STR0004),OemToAnsi(STR0032),OemToAnsi(STR0005),OemToAnsi(STR0036),STR0048}  //"Por Data"###"Por Banco"###"Por Natureza"###"Alfabetica"###"Nro. Titulo"###"Dt.Digitacao"###"Por Lote" //"Por Data de Credito"
Local cDesc1 := STR0006  //"Este programa ir  emitir a rela‡„o dos titulos baixados."
Local cDesc2 := STR0007  //"Poder  ser emitido por data, banco, natureza ou alfab‚tica"
Local cDesc3 := STR0008  //"de cliente ou fornecedor e data da digita‡„o."
Local tamanho:="G"
Local cString:="SE5"

Private titulo:=OemToAnsi(STR0009)  //"Relacao de Baixas"
Private cabec1
Private cabec2
Private cNomeArq
Private aReturn := { OemToAnsi(STR0010), 1,OemToAnsi(STR0030), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private nomeprog:="FINR190"
Private aLinha  := { },nLastKey := 0
Private cPerg   :="FIN190"

ajustasx1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN190",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                     ³
//³ mv_par01            // da data da baixa                  ³
//³ mv_par02            // at‚ a data da baixa               ³
//³ mv_par03            // do banco                          ³
//³ mv_par04            // at‚ o banco                       ³
//³ mv_par05            // da natureza                       ³
//³ mv_par06            // at‚ a natureza                    ³
//³ mv_par07            // do c¢digo                         ³
//³ mv_par08            // at‚ o c¢digo                      ³
//³ mv_par09            // da data de digita‡„o              ³
//³ mv_par10            // ate a data de digita‡„o           ³
//³ mv_par11            // Tipo de Carteira (R/P)            ³
//³ mv_par12            // Moeda                             ³
//³ mv_par13            // Hist¢rico: Baixa ou Emiss„o       ³
//³ mv_par14            // Imprime Baixas Normais / Todas    ³
//³ mv_par15            // Situacao                          ³
//³ mv_par16            // Cons Mov Fin                      ³
//³ mv_par17            // Cons filiais abaixo               ³
//³ mv_par18            // da filial                         ³
//³ mv_par19            // ate a filial                      ³
//³ mv_par20            // Do Lote                           ³
//³ mv_par21            // Ate o Lote                        ³
//³ mv_par22            // da loja                           ³
//³ mv_par23            // Ate a loja                        ³ 
//³ mv_par24            // NCC Compensados                   ³
//³ mv_par25            // Outras Moedas                     ³ 
//³ mv_par26            // do prefixo                        ³
//³ mv_par27            // at‚ o prefixo                     ³
//³ mv_par28            // Imprimir os Tipos                 ³
//³ mv_par29            // Nao Imprimir Tipos			       ³
//³ mv_par30            // Imprime nome (Normal ou reduzido) ³
//³ mv_par31            // da data da vencto. do tit         ³
//³ mv_par32            // at‚ a data de vencto do tit.      ³
//³ mv_par33            // da filial origem                  ³
//³ mv_par34            // ate filial origem                 ³
//³ mv_par35            // Impr.Incl. Adiantamentos ?Sim/Nao ³
//³ mv_par36            // Imprime Titulos em Carteira ?     |
//³ mv_par37            // Imp. mov. cheque aglutinado?Cheque/Baixa/Ambos³
//³ mv_par38            // Cons. Nat. Aglutinadas? Sim/Nao   |
//| mv_par39            // Filtrar Natureza Por?             |
//|                                  - Padrao                |
//|                                  - Nat.Principal         |
//|                                  - Mult.Naturezas        |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "FINR190"            //Nome Default do relat¢rio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return(Nil)
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return(Nil)
EndIf

cFilterUser := aReturn[7]

RptStatus({|lEnd| Fa190Imp(@lEnd,wnRel,cString)},Titulo)
Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FA190Imp ³ Autor ³ Wagner Xavier         ³ Data ³ 05.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rela‡„o das baixas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA190Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA190Imp(lEnd,wnRel,cString)

Local cExp 			:= ""
Local CbTxt,CbCont
Local nValor:=0,nDesc:=0,nJuros:=0,nMulta:=0,nJurMul:=0,nCM:=0,dData,nVlMovFin:=0
Local nTotValor:=0,nTotDesc:=0,nTotJurMul:=0,nTotCm:=0,nTotOrig:=0,nTotBaixado:=0,nTotMovFin:=0,nTotComp:=0,nTotFat:=0
Local nGerValor:=0,nGerDesc:=0,nGerJurMul:=0,nGerCm:=0,nGerOrig:=0,nGerBaixado:=0,nGerMovFin:=0,nGerComp:=0,nGerFat:=0
Local nFilOrig:=0,nFilJurMul:=0,nFilCM:=0,nFilDesc:=0
Local nFilAbLiq:=0,nFilAbImp:=0,nFilValor:=0,nFilBaixado:=0,nFilMovFin:=0,nFilComp:=0, nFilFat:=0
Local nAbatLiq := 0,nTotAbImp := 0,nTotImp := 0,nTotAbLiq := 0,nGerAbLiq := 0,nGerAbImp := 0
Local cBanco,cNatureza,cAnterior,cCliFor,nCT:=0,dDigit,cLoja
Local lContinua		:=.T.
Local lBxTit		:=.F.
Local lBxLoja		:=.F.			//Verifica se o titulo foi baixado pelo loja e tem a excecao do MV_LJTROCO = .T.
Local tamanho		:="G"
Local aCampos:= {},cNomArq1:="",nVlr,cLinha,lOriginal:=.T.
Local nAbat 		:= 0
Local cHistorico
Local lManual 		:= .f.
Local cTipodoc
Local nRecSe5 		:= 0
Local dDtMovFin
Local cRecPag
Local nRecEmp 		:= SM0->(Recno())
Local cMotBaixa		:= CRIAVAR("E5_MOTBX")
Local cFilNome 		:= Space(15)
Local cCliFor190	:= ""
Local aTam 			:= IIF(mv_par11 == 1,TamSX3("E1_CLIENTE"),TamSX3("E2_FORNECE"))
Local aColu 		:= {}
Local nDecs	   		:= GetMv("MV_CENT"+(IIF(mv_par12 > 1 , STR(mv_par12,1),""))) 
Local nMoedaBco		:= 1
Local cCarteira
#IFDEF TOP
	Local aStru		:= SE5->(DbStruct()), nI
	Local cQuery
#ENDIF	
Local cFilTrb
Local lAsTop		:= .F.
Local cFilSe5		:= ".T."
Local cChave, bFirst
Local cFilOrig
Local lAchou		:= .F.
Local lF190Qry		:= ExistBlock("F190QRY")
Local cQueryAdd		:= ""
Local lAjuPar15		:= Len(AllTrim(mv_par15))==Len(mv_par15)
Local lAchouEmp		:= .T.                                
Local lAchouEst		:= .F.                                
Local nTamEH		:= TamSx3("EH_NUMERO")[1]
Local nTamEI		:= TamSx3("EI_NUMERO")[1]+TamSx3("EI_REVISAO")[1]+TamSx3("EI_SEQ")[1]
Local cCodUlt		:= SM0->M0_CODIGO
Local cFilUlt		:= IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
Local nRecno  
Local nSavOrd 
Local aAreaSE5 
Local cChaveNSE5	:= ""
Local nRecSE2		:= 0
Local aAreaSE2
Local aAreabk

Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

Local nTaxa:= 0 
Local lUltBaixa := .F.
Local cChaveSE1 := ""
Local cChaveSE5 := ""
Local cSeqSE5 := ""
Local cBancoAnt, cAgAnt, cContaAnt
Local lNaturez := .F.

//Controla o Pis Cofins e Csll na baixa (1-Retem PCC na Baixa ou 2-Retem PCC na Emissão(default))
Local lPccBxCr	:= If (FindFunction("FPccBxCr"),FPccBxCr(),.F.)
Local nPccBxCr := 0 
Private nIndexSE5	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas para Impress„o do Cabe‡alho e Rodap‚    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1
nOrdem 	:= aReturn[8]
cSuf	:= LTrim(Str(mv_par12))
cMoeda	:= GetMv("MV_MOEDA"+cSuf)
cCond3	:= ".T."


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


#define STR0012  "C.Custo   Prf Numero     Prc TP  Client Nome Cliente       Natureza   Vencto     Historico             Dt Baixa     Vlr Origi. Jur/Multa   Correcao Descontos   Abatim.  Impostos     Total Baixado  Bco  Dt Dig.  Mot Orig "
#define STR0014  "C.Custo   Prf Numero     Prc TP  Client Nome Cliente       Natureza   Vencto     Historico             Dt Baixa     Vlr Origi. Jur/Multa   Correcao Descontos   Abatim.  Impostos     Total Baixado  Bco  Dt Dig.  Mot Orig "

If mv_par11 == 1
	titulo := OemToAnsi(STR0011)  + cMoeda  //"Relacao dos Titulos Recebidos em "
	cabec1 := iif(aTam[1] > 6 , OemToAnsi(STR0039),OemToAnsi(STR0012))  //"Cliente-Nome Cliente "###"Prf Numero       P TP Client Nome Cliente       Natureza    Vencto  Historico       Dt Baixa  Valor Original    Tx Permanen         Multa      Correcao     Descontos     Abatimentos    Total Rec. Bco Dt Digit. Mot. Baixa"
	cabec2 := iif(aTam[1] > 6 , OemToAnsi(STR0040),"")  //"                       Prf Numero       P TP     Natureza   Vencto     Historico          Dt Baixa   Valor Original  Tx Permanen        Multa     Correcao    Descontos  Abatimentos     Total Rec. Bco Dt Digit.  Mot.Baixa"
Else
	titulo := OemToAnsi(STR0013)  + cMoeda  //"Relacao dos Titulos Pagos em "
	cabec1 := iif(aTam[1] > 6 , OemToAnsi(STR0041),OemToAnsi(STR0014))  //"Prf Numero       P TP Fornec Nome Fornecedor    Natureza    Vencto  Historico       Dt Baixa  Valor Original    Tx Permanen         Multa      Correcao     Descontos     Abatimentos    Total Pago Bco Dt Digit. Mot. Baixa"
	cabec2 := iif(aTam[1] > 6 , OemToAnsi(STR0040),"")  //"                       Prf Numero       P TP     Natureza   Vencto     Historico          Dt Baixa   Valor Original  Tx Permanen        Multa     Correcao    Descontos  Abatimentos     Total Rec. Bco Dt Digit.  Mot.Baixa"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par17 == 2
	cFilDe := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	cFilAte:= IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
Else
	cFilDe := mv_par18	// Todas as filiais
	cFilAte:= mv_par19
EndIf
// Definicao das condicoes e ordem de impressao, de acordo com a ordem escolhida pelo
// usuario.
DbSelectArea("SE5")
Do Case
Case nOrdem == 1
	cCondicao := "E5_DATA >= mv_par01 .and. E5_DATA <= mv_par02"
	cCond2 := "E5_DATA"
	cChave := IndexKey(1)
	cChaveInterFun := cChave
	titulo += OemToAnsi(STR0015)  //" por data de pagamento"
	bFirst := {|| MsSeek(xFilial("SE5")+Dtos(mv_par01),.T.)}
Case nOrdem == 2
	cCondicao := "E5_BANCO >= mv_par03 .and. E5_BANCO <= mv_par04"
	cCond2 := "E5_BANCO"
	cChave := IndexKey(3)
	cChaveInterFun := cChave
	titulo += OemToAnsi(STR0016) // " por Banco"
	bFirst := {||MsSeek(xFilial("SE5")+mv_par03,.T.)}
Case nOrdem == 3
	cCondicao := "E5_MULTNAT = '1' .Or. (E5_NATUREZ >= mv_par05 .and. E5_NATUREZ <= mv_par06)"
	cCond2 := "E5_NATUREZ"
	cChave := IndexKey(4)
	cChaveInterFun := cChave
	titulo += OemToAnsi(STR0017)  //" por Natureza"
	bFirst := {||MsSeek(xFilial("SE5")+mv_par05,.T.)}
Case nOrdem == 4
	cCondicao := ".T."
	cCond2 := "E5_BENEF"
	cChave := "E5_FILIAL+E5_BENEF+DTOS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA"
	cChaveInterFun := cChave
	titulo += OemToAnsi(STR0020)  //" Alfabetica"
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 5
	cCondicao := ".T."
	cCond2 := "E5_NUMERO"
	cChave := "E5_FILIAL+E5_NUMERO+E5_PARCELA+E5_PREFIXO+DTOS(E5_DATA)"
	cChaveInterFun := cChave
	titulo += OemToAnsi(STR0035) //" Nro. dos Titulos"
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 6	//Ordem 6 (Digitacao)
	cCondicao := ".T."
	cCond2 := "E5_DTDIGIT"
	cChave := "E5_FILIAL+DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+DTOS(E5_DATA)"
	cChaveInterFun := cChave
	titulo += OemToAnsi(STR0019)  //" Por Data de Digitacao"
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 7 // por Lote
	cCondicao := "E5_LOTE >= mv_par20 .and. E5_LOTE <= mv_par21"
	cCond2 := "E5_LOTE"
	cChave := IndexKey(5)
	cChaveInterFun := cChave
	titulo += OemToAnsi(STR0036)  //" por Lote"
	bFirst := {||MsSeek(xFilial("SE5")+mv_par20,.T.)}
OtherWise						// Data de Crédito (dtdispo)
	cCondicao := "E5_DTDISPO >= mv_par01 .and. E5_DTDISPO <= mv_par02"
	cCond2 := "E5_DTDISPO"
	cChave := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
	cChaveInterFun := cChave
	titulo += OemToAnsi(STR0015)  //" por data de pagamento"
	bFirst := {||MsSeek(xFilial("SE5")+Dtos(mv_par01),.T.)}
EndCase

If !Empty(mv_par28) .And. ! ";" $ mv_par28 .And. Len(AllTrim(mv_par28)) > 3
	ApMsgAlert(STR0073)//"Separe os tipos a imprimir (pergunta 28) por um ; (ponto e virgula) a cada 3 caracteres")
	Return(Nil)
Endif	
If !Empty(mv_par29) .And. ! ";" $ mv_par29 .And. Len(AllTrim(mv_par29)) > 3
	ApMsgAlert(STR0074)//"Separe os tipos que não deseja imprimir (pergunta 29) por um ; (ponto e virgula) a cada 3 caracteres")
	Return(Nil)
Endif	

#IFDEF TOP
	If TcSrvType() != "AS/400" .and. TCGetDB()!="SYBASE"
		lAsTop := .T.
		cCondicao := ".T."
		DbSelectArea("SE5")
		cQuery := ""
		aEval(DbStruct(),{|e| cQuery += ","+AllTrim(e[1])})
		// Obtem os registros a serem processados
		cQuery := "SELECT " +SubStr(cQuery,2)
		cQuery +=         ",SE5.R_E_C_N_O_ SE5RECNO "
		cQuery += "FROM " + RetSqlName("SE5")+" SE5 "
		cQuery += "WHERE E5_RECPAG = '" + IIF( mv_par11 == 1, "R","P") + "' AND "
		cQuery += "      E5_DATA    between '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "' AND "
		cQuery += "      E5_DATA    <= '" + DTOS(dDataBase) + "' AND "
		cQuery += "      E5_BANCO   between '" + mv_par03       + "' AND '" + mv_par04       + "' AND "
		//-- Realiza filtragem pela natureza principal
		If mv_par39 == 2
			cQuery +=  " E5_NATUREZ between '" + mv_par05       + "' AND '" + mv_par06     	+ "' AND "
		Else
			cQuery +=  " (E5_NATUREZ between '" + mv_par05       + "' AND '" + mv_par06     	+ "' OR "
			cQuery +=  " EXISTS (SELECT EV_FILIAL, EV_PREFIXO, EV_NUM, EV_PARCELA, EV_CLIFOR, EV_LOJA "
			cQuery +=            " FROM "+RetSqlName("SEV")+" SEV "
			cQuery +=           " WHERE E5_FILIAL  = EV_FILIAL  AND "
			cQuery +=                  "E5_PREFIXO = EV_PREFIXO AND "
			cQuery +=                  "E5_NUMERO  = EV_NUM     AND "
			cQuery +=                  "E5_PARCELA = EV_PARCELA AND "
			cQuery +=                  "E5_TIPO    = EV_TIPO    AND "
			cQuery +=                  "E5_CLIFOR  = EV_CLIFOR  AND "
			cQuery +=                  "E5_LOJA    = EV_LOJA    AND "
			cQuery +=                  "EV_NATUREZ between '" + mv_par05 + "' AND '" + mv_par06 + "' AND "
			cQuery +=                  "SEV.D_E_L_E_T_ = ' ')) AND "
		EndIf	
		cQuery += "      E5_CLIFOR  between '" + mv_par07       + "' AND '" + mv_par08       + "' AND "
		cQuery += "      E5_DTDIGIT between '" + DTOS(mv_par09) + "' AND '" + DTOS(mv_par10) + "' AND "
		cQuery += "      E5_LOTE    between '" + mv_par20       + "' AND '" + mv_par21       + "' AND "
		cQuery += "      E5_LOJA    between '" + mv_par22       + "' AND '" + mv_par23 	    + "' AND "
		cQuery += "      E5_PREFIXO between '" + mv_par26       + "' AND '" + mv_par27 	    + "' AND "
		cQuery += "      SE5.D_E_L_E_T_ = ' '  AND "
		cQuery += "		  E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE') AND "
		cQuery += " 	  E5_SITUACA NOT IN ('C','E','X') AND "
		cQuery += "      ((E5_TIPODOC = 'CD' AND E5_VENCTO <= E5_DATA) OR "
		cQuery += "      (E5_TIPODOC <> 'CD')) "
		cQuery += "		  AND E5_HISTOR NOT LIKE '%"+STR0077+"%'"
		
		If mv_par11 == 2
			cQuery += " AND E5_TIPODOC <> 'E2'"
		EndIf
		
		If !Empty(mv_par28) // Deseja imprimir apenas os tipos do parametro 28
			cQuery += " AND E5_TIPO IN "+FormatIn(mv_par28,";")
		ElseIf !Empty(Mv_par29) // Deseja excluir os tipos do parametro 29
			cQuery += " AND E5_TIPO NOT IN "+FormatIn(mv_par29,";")
		EndIf
		
		If mv_par16 == 2
			cQuery += " AND E5_TIPODOC <> '" + SPACE(LEN(E5_TIPODOC)) + "'"
			cQuery += " AND E5_NUMERO  <> '" + SPACE(LEN(E5_NUMERO)) + "'"
			cQuery += " AND E5_TIPODOC <> 'CH'"
		Endif
		
		cCondFil := "NEWSE5->E5_FILIAL==xFilial('SE5')"
		
		If mv_par17 == 2
			cQuery += " AND E5_FILIAL = '" + FwxFilial("SE5") + "'"
		Else
			If Empty( xFilial("SE5") )
				cQuery += " AND E5_FILORIG between '" + mv_par18 + "' AND '" + mv_par19 + "'"
			Else
				cQuery += " AND E5_FILIAL between '" + mv_par18 + "' AND '" + mv_par19 + "'"
			EndIf
		Endif
		
		If lF190Qry
			cQueryAdd := ExecBlock("F190QRY", .F., .F., {aReturn[7]})
			If ValType(cQueryAdd) == "C"
				cQuery += " AND (" + cQueryAdd + ")"
			EndIf
		EndIf
		
		// seta a ordem de acordo com a opcao do usuario
		cQuery += " ORDER BY " + SqlOrder(cChave) 
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "NEWSE5", .F., .T.)
		For nI := 1 TO LEN(aStru)
			If aStru[nI][2] != "C"
				TCSetField("NEWSE5", aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
			EndIf
		Next
		DbGoTop()
	Else
#ENDIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abre o SE5 com outro alias para ser filtrado porque a funcao³
		//³ TemBxCanc() utilizara o SE5 sem filtro.							 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Select("NEWSE5") == 0 .And. !( ChkFile("SE5",.F.,"NEWSE5") )
			Return(Nil)
		EndIf		
		lAsTop := .F.
		DbSelectArea("NEWSE5")
		cFilSE5 := 'E5_RECPAG=='+IIF(mv_par11 == 1,'"R"','"P"')+'.and.'
		cFilSE5 += 'DTOS(E5_DATA)>='+'"'+dtos(mv_par01)+'"'+'.and.DTOS(E5_DATA)<='+'"'+dtos(mv_par02)+'".and.'
		cFilSE5 += 'DTOS(E5_DATA)<='+'"'+dtos(dDataBase)+'".and.'
		If nOrdem == 3
   			cFilSE5 += '(E5_MULTNAT = "1" .Or. (E5_NATUREZ>='+'"'+mv_par05+'"'+'.and.E5_NATUREZ<='+'"'+mv_par06+'")).and.'
		Else
			cFilSE5 += '(E5_NATUREZ>='+'"'+mv_par05+'"'+'.and.E5_NATUREZ<='+'"'+mv_par06+'").and.'
		Endif		
		cFilSE5 += 'E5_CLIFOR>='+'"'+mv_par07+'"'+'.and.E5_CLIFOR<='+'"'+mv_par08+'".and.'
		cFilSE5 += 'DTOS(E5_DTDIGIT)>='+'"'+dtos(mv_par09)+'"'+'.and.DTOS(E5_DTDIGIT)<='+'"'+dtos(mv_par10)+'".and.'
		cFilSE5 += 'E5_LOTE>='+'"'+mv_par20+'"'+'.and.E5_LOTE<='+'"'+mv_par21+'".and.'
		cFilSE5 += 'E5_LOJA>='+'"'+mv_par22+'"'+'.and.E5_LOJA<='+'"'+mv_par23+'".and.'
		cFilSe5 += 'E5_PREFIXO>='+'"'+mv_par26+'"'+'.And.E5_PREFIXO<='+'"'+mv_par27+'"'
		If !Empty(mv_par28) // Deseja imprimir apenas os tipos do parametro 28
			cFilSe5 += '.And.E5_TIPO $'+'"'+ALLTRIM(mv_par28)+Space(1)+'"'
		ElseIf !Empty(Mv_par29) // Deseja excluir os tipos do parametro 29
			cFilSe5 += '.And.!(E5_TIPO $'+'"'+ALLTRIM(mv_par29)+Space(1)+'")'
		EndIf

		cCondFil := "NEWSE5->E5_FILIAL==xFilial('SE5')"
		
		If mv_par17 == 2
			cFilSe5 +=  " .AND. E5_FILIAL = '" + xFilial("SE5") + "'"
		Else
			If Empty( xFilial("SE5") )
				cFilSe5 += " .AND. E5_FILORIG >= '" + mv_par18 + "' .AND. E5_FILORIG <= '" + mv_par19 + "'"
			Else
				cFilSe5 +=" .AND. E5_FILIAL >= '" + mv_par18 + "' .AND. E5_FILIAL <= '" + mv_par19 + "'"
			EndIf
		Endif
#IFDEF TOP
	Endif
#ENDIF	
// Se nao for TOP, ou se for TOP e for AS400, cria Filtro com IndRegua
// Pois em SQL os registros ja estao filtrados em uma Query
If !lAsTop
	cNomeArq := CriaTrab(Nil,.F.)
	IndRegua("NEWSE5",cNomeArq,cChave,,cFilSE5,OemToAnsi(STR0018))  //"Selecionando Registros..."
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{"LINHA","C",80,0 } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq1 := CriaTrab(aCampos)
dbUseArea( .T.,, cNomArq1, "Trb", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",cNomArq1,"LINHA",,,OemToAnsi(STR0018))  //"Selecionando Registros..."

aColu := Iif(aTam[1] > 6,{023,027,TamParcela("E1_PARCELA",40,39,38),042,000,022},{000,004,TamParcela("E1_PARCELA",17,16,15),019,023,030})

//-- joaofr
nxmenos := 10
For xC:=1 to len(aColu)
	//-- diminui 2 de cada coluna dos valores
	if xC > 11 .and. xC < 17
		nxmenos -= 2
	endif	

	aColu[xC] += nxmenos
Next


If MV_PAR16 == 1

	dbSelectArea("SE5")
	dbSetOrder(17) //"E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ+E5_TIPODOC+E5_SEQ"
	dbGoTop()

Endif

DbSelectArea("SM0")
DbSeek(cEmpAnt+cFilDe,.T.)

While !Eof() .and. M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) <= cFilAte
	cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	cFilNome:= SM0->M0_FILIAL
	DbSelectArea("NEWSE5")
	SetRegua(RecCount())
	// Se nao for TOP, ou se for TOP e for AS400, posiciona no primeiro registro do escopo	
	// Pois em SQL os registro ja estao filtrados em uma Query e ja esta no inicio do arquivo
	If !lAsTop
		Eval(bFirst) // Posiciona no primeiro registro a ser processado
	Endif

	If ((MV_MULNATR .and. mv_par11 = 1 .and. mv_par38 = 2 .and. !mv_par39 == 2) .or. (MV_MULNATP .and. mv_par11 = 2 .and. mv_par38 = 2 .and. !mv_par39 == 2) )
	
		Finr199R3(	@nGerOrig,@nGerValor,@nGerDesc,@nGerJurMul,@nGerCM,@nGerAbLiq,@nGerAbImp,@nGerBaixado,@nGerMovFin,@nGerComp,;
					@nFilOrig,@nFilValor,@nFilDesc,@nFilJurMul,@nFilCM,@nFilAbLiq,@nFilAbImp,@nFilBaixado,@nFilMovFin,@nFilComp,;
					lEnd,cCondicao,cCond2,aColu,lContinua,cFilSe5,lAsTop,Tamanho,nOrdem, @nGerFat, @nFilFat)

		#IFDEF TOP
			If TcSrvType() != "AS/400" .and. TCGetDB()!="SYBASE"
				dbSelectArea("SE5")
				dbCloseArea()
				ChKFile("SE5")
				dbSelectArea("SE5")
				dbSetOrder(1)
			Endif
		#ENDIF
		If Empty(xFilial("SE5"))
			Exit
		Endif
		dbSelectArea("SM0")
		cCodUlt := SM0->M0_CODIGO
		cFilUlt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
		dbSkip()
		Loop

	Else

		While NEWSE5->(!Eof()) .And. &cCondFil .And. &cCondicao .and. lContinua
			If lEnd
				@PROW()+1,001 PSAY OemToAnsi(STR0021)  //"CANCELADO PELO OPERADOR"
				lContinua:=.F.
				Exit
			EndIf
			
			IncRegua()
			DbSelectArea("NEWSE5")
			// Testa condicoes de filtro	
			If !Fr190TstCond(cFilSe5,.F.)
				NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
				Loop
			Endif						
								 	
			// Se nao for TOP, ou se for TOP e for AS400, posiciona no primeiro registro do escopo	
			// Pois em SQL os registro ja estao filtrados em uma Query e ja esta no inicio do arquivo
			If !lAsTop
				SE2->(dbSetOrder(1))
				SE2->(MsSeek(NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
				If SE2->E2_MULTNAT == '1'
					lNaturez := .F.
					SEV->(dbSetOrder(1))
					SEV->(MsSeek(NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
					While NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == SEV->(EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA) .and. !lNaturez
						If SEV->EV_NATUREZ >= mv_par05 .and. SEV->EV_NATUREZ <= mv_par06
							lNaturez := .T.
						EndIf
						SEV->(DbSkip())
					EndDo
					If !lNaturez
						NEWSE5->(dbSkip())
						Loop
					EndIf
				Else
					If !(NEWSE5->E5_NATUREZ >= mv_par05 .and. NEWSE5->E5_NATUREZ <= mv_par06)
						NEWSE5->(dbSkip())
						Loop
					EndIf
				EndIf
			EndIf			
					 	
			If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
				(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 	//Adiantamento
				cCarteira := "R"
			Else
				cCarteira := "P"
			Endif
	
			dbSelectArea("NEWSE5")
			cAnterior 	:= &cCond2
			cBancoAnt	:= NEWSE5->E5_BANCO
			cAgAnt		:= NEWSE5->E5_AGENCIA
			cContaAnt	:= NEWSE5->E5_CONTA
			
			nTotValor	:= 0
			nTotDesc	:= 0
			nTotJurMul  := 0
			nTotCM		:= 0
			nCT			:= 0
			nTotOrig	:= 0
			nTotBaixado	:= 0
			nTotAbLiq  	:= 0
			nTotImp		:= 0
			nTotMovFin	:= 0
			nTotComp	:= 0
			nTotFat	    := 0
	
			While NEWSE5->(!EOF()) .and. &cCond2=cAnterior .and. &cCondFil .and. lContinua
	
				lManual := .f.
				dbSelectArea("NEWSE5")
				
				IF lEnd
					@PROW()+1,001 PSAY OemToAnsi(STR0021)  //"CANCELADO PELO OPERADOR"
					lContinua:=.F.
					Exit
				EndIF
	
				If (Empty(NEWSE5->E5_TIPODOC) .And. mv_par16 == 1) .Or.;
					(Empty(NEWSE5->E5_NUMERO)  .And. mv_par16 == 1)
					lManual := .t.
				EndIf
				
				// Testa condicoes de filtro	
				If !Fr190TstCond(cFilSe5,.T.)
					dbSelectArea("NEWSE5")
					NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
					Loop
				Endif	               											
				
				// Imprime somente cheques
				If mv_par37 == 1 .And. NEWSE5->E5_TIPODOC == "BA"

					aAreaSE5 := SE5->(GetArea())
					lAchou := .F.

					SE5->(dbSetOrder(11))
					cChaveNSE5	:= NEWSE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
					SE5->(MsSeek(xFilial("SE5")+cChaveNSE5))					
               
					// Procura o cheque aglutinado, se encontrar, marca lAchou := .T. e despreza 
					WHILE SE5->(!EOF()) .And. SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)	== cChaveNSE5
						If SE5->E5_TIPODOC == "CH"
							lAchou := .T.
							Exit
						Endif
						SE5->(dbSkip())
					Enddo
					RestArea(aAreaSE5)
					// Achou cheque aglutinado para a baixa, despreza o registro
					If lAchou
						NEWSE5->(dbSkip())
						Loop
					Endif  	

				ElseIf mv_par37 == 2 .And. NEWSE5->E5_TIPODOC == "CH" //somente baixas

					aAreaSE5 := SE5->(GetArea())
					lAchou := .F.
					
					SE5->(dbSetOrder(11))
					cChaveNSE5	:= NEWSE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
					SE5->(MsSeek(xFilial("SE5")+cChaveNSE5))					
               
					// Procura a baixa aglutinada, se encontrar despreza o movimento bancario
					WHILE SE5->(!EOF()) .And. SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)	== cChaveNSE5
						If SE5->E5_TIPODOC $ "BA"
							lAchou := .T.
							Exit
						Endif	
						SE5->(dbSkip())
					Enddo
					RestArea(aAreaSE5)
					// Achou cheque aglutinado para a baixa, despreza o registro
					If lAchou
						NEWSE5->(dbSkip())
						Loop
					Endif
				Endif	

				cNumero    	:= NEWSE5->E5_NUMERO
				cPrefixo   	:= NEWSE5->E5_PREFIXO
				cParcela   	:= NEWSE5->E5_PARCELA
				dBaixa     	:= NEWSE5->E5_DATA
				cBanco     	:= NEWSE5->E5_BANCO
				cNatureza  	:= NEWSE5->E5_NATUREZ
				cCliFor    	:= NEWSE5->E5_BENEF
				cLoja      	:= NEWSE5->E5_LOJA
				cSeq       	:= NEWSE5->E5_SEQ
				cNumCheq   	:= NEWSE5->E5_NUMCHEQ
				cRecPag 	:= NEWSE5->E5_RECPAG
				cTipodoc   	:= NEWSE5->E5_TIPODOC
				cMotBaixa	:= NEWSE5->E5_MOTBX
				cCheque    	:= NEWSE5->E5_NUMCHEQ
				cTipo      	:= NEWSE5->E5_TIPO
				cFornece   	:= NEWSE5->E5_CLIFOR
				cLoja      	:= NEWSE5->E5_LOJA
				dDigit     	:= NEWSE5->E5_DTDIGIT
				lBxTit	  	:= .F.
				cFilorig    := NEWSE5->E5_FILORIG
				
				If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
					(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 	//Adiantamento
					dbSelectArea("SE1")
					dbSetOrder(1)
					lBxTit := MsSeek(cFilial+cPrefixo+cNumero+cParcela+cTipo)
					If !lBxTit
						lBxTit := dbSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo)
					Endif				
					cCarteira := "R"
					dDtMovFin := IIF (lManual,CTOD("//"), DataValida(SE1->E1_VENCTO,.T.))
					While SE1->(!Eof()) .and. SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO==cPrefixo+cNumero+cParcela+cTipo
						If SE1->E1_CLIENTE == cFornece .And. SE1->E1_LOJA == cLoja	// Cliente igual, Ok
							Exit
						Endif                                
						SE1->( dbSkip() )
					EndDo
					If !SE1->(EOF()) .And. mv_par11 == 1 .and. !lManual .and.  ;
						(NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG))
						If SE5->(FieldPos("E5_SITCOB")) > 0
							cExp := "NEWSE5->E5_SITCOB"
						Else
							cExp := "SE1->E1_SITUACA"
						Endif 
						
						If mv_par36 == 2 // Nao imprime titulos em carteira 
							// Retira da comparacao as situacoes branco, 0, F e G
							mv_par15 := AllTrim(mv_par15)       
							mv_par15 := StrTran(mv_par15,"0","")
							mv_par15 := StrTran(mv_par15,"F","")
							mv_par15 := StrTran(mv_par15,"G","")
						Else
							If (NEWSE5->E5_RECPAG == "R") .And. lAjuPar15
								mv_par15  += " "
							Endif
						EndIf	
				
						cExp += " $ mv_par15" 
						If !(&cExp)
							dbSelectArea("NEWSE5")
							NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
							Loop
						Endif
					Endif
					cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+DtoS(dBaixa)+cSeq+cNumCheq"
					nDesc := nJuros := nValor := nMulta := nJurMul := nCM := nVlMovFin := 0
				Else
					dbSelectArea("SE2")
					DbSetOrder(1)
					cCarteira := "P"
				    lBxTit 	:= MsSeek(cFilial+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
				    
				    Iif(lBxTit, nRecSE2	:= SE2->(Recno()), nRecSE2 := 0 )
				    
					If !lBxTit
						lBxTit := dbSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
					Endif				
					dDtMovFin := IIF(lManual,CTOD("//"),DataValida(SE2->E2_VENCTO,.T.))
					cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+cFornece+DtoS(dBaixa)+cSeq+cNumCheq"
					nDesc := nJuros := nValor := nMulta := nJurMul := nCM := nVlMovFin := 0
					cCheque    := Iif(Empty(NEWSE5->E5_NUMCHEQ),SE2->E2_NUMBCO,NEWSE5->E5_NUMCHEQ)
				Endif
				dbSelectArea("NEWSE5")
				IncRegua()
				cHistorico := Space(40)
				While NEWSE5->( !Eof()) .and. &cCond3 .and. lContinua .And. &cCondFil
					
					IncRegua()
					dbSelectArea("NEWSE5")
					cTipodoc   := NEWSE5->E5_TIPODOC
					cCheque    := NEWSE5->E5_NUMCHEQ
	
					lAchouEmp := .T.
					lAchouEst := .F.
	
					IF lEnd
						@PROW()+1,001 PSAY OemToAnsi(STR0021)  //"CANCELADO PELO OPERADOR"
						lContinua:=.F.
						Exit
					EndIF	                																		
	
					// Testa condicoes de filtro	
					If !Fr190TstCond(cFilSe5,.T.)
						dbSelectArea("NEWSE5")
						NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
						Loop
					Endif  								
										
					If NEWSE5->E5_SITUACA $ "C/E/X" 
						dbSelectArea("NEWSE5")
						NEWSE5->( dbSkip() )
						Loop
					EndIF
					
					If NEWSE5->E5_LOJA != cLoja
						Exit
					Endif
	
					If NEWSE5->E5_FILORIG < mv_par33 .or. NEWSE5->E5_FILORIG > mv_par34
						dbSelectArea("NEWSE5")
						NEWSE5->( dbSkip() )
						Loop
					Endif
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Nao imprime os registros de emprestimos excluidos ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
					If NEWSE5->E5_TIPODOC == "EP"
						aAreaSE5 := NEWSE5->(GetArea())	
						dbSelectArea("SEH")
						dbSetOrder(1)
						lAchouEmp := MsSeek(xFilial("SEH")+Substr(NEWSE5->E5_DOCUMEN,1,nTamEH))
						RestArea(aAreaSE5)
						If !lAchouEmp
							NEWSE5->(dbSkip())
							Loop
						EndIf
					EndIf
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Nao imprime os registros de pagamento de emprestimos estornados ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
					If NEWSE5->E5_TIPODOC == "PE"
						aAreaSE5 := NEWSE5->(GetArea())	
						dbSelectArea("SEI")
						dbSetOrder(1)
						If	MsSeek(xFilial("SEI")+"EMP"+Substr(NEWSE5->E5_DOCUMEN,1,nTamEI))
							If SEI->EI_STATUS == "C"
								lAchouEst := .T.
							EndIf
						EndIf
						RestArea(aAreaSE5)
						If lAchouEst
							NEWSE5->(dbSkip())
							Loop
						EndIf
					EndIf
	  
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica o vencto do Titulo ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cFilTrb := If(mv_par11==1,"SE1","SE2")
					If (cFilTrb)->(!Eof()) .And.;
						((cFilTrb)->&(Right(cFilTrb,2)+"_VENCREA") < mv_par31 .Or. (!Empty(mv_par32) .And. (cFilTrb)->&(Right(cFilTrb,2)+"_VENCREA") > mv_par32))
						dbSelectArea("NEWSE5")
						NEWSE5->(dbSkip())
						Loop
					Endif
	            
					dBaixa     	:= NEWSE5->E5_DATA
					cBanco     	:= NEWSE5->E5_BANCO
					cNatureza  	:= NEWSE5->E5_NATUREZ
					cCliFor    	:= NEWSE5->E5_BENEF
					cSeq       	:= NEWSE5->E5_SEQ
					cNumCheq   	:= NEWSE5->E5_NUMCHEQ
					cRecPag		:= NEWSE5->E5_RECPAG
					cMotBaixa	:= NEWSE5->E5_MOTBX
					cTipo190	:= NEWSE5->E5_TIPO
					cFilorig    := NEWSE5->E5_FILORIG
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Obter moeda da conta no Banco.                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ( cPaisLoc # "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA) ) .OR. ( FindFunction( "FXMultSld" ) .AND. FXMultSld() )
						SA6->(DbSetOrder(1))
						SA6->(MsSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
						nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
					Else
						nMoedaBco	:=	1
					Endif
	
					If !Empty(NEWSE5->E5_NUMERO)
						If (NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG)) .or. ;
							(NEWSE5->E5_RECPAG == "P" .and. NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG) .Or.;
							(NEWSE5->E5_RECPAG == "P" .And. NEWSE5->E5_TIPODOC $ "DB#OD")
							dbSelectArea( "SA1")
							dbSetOrder(1)
							lAchou := .F.
							If Empty(xFilial("SA1"))  //SA1 Compartilhado
								If dbSeek(xFilial("SA1")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									lAchou := .T.
								Endif
							Else
								cFilOrig := NEWSE5->E5_FILIAL //Procuro SA1 pela filial do movimento
								If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
										lAchou := .T.
									Else
										cFilOrig := NEWSE5->E5_FILORIG //Procuro SA1 pela filial origem
										If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
											If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
												lAchou := .T.
											Endif
										Endif
									Endif
								Else
									cFilOrig := NEWSE5->E5_FILORIG	//Procuro SA1 pela filial origem
									If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
										If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
											lAchou := .T.
										Endif
									Endif
								Endif							
							EndIF
							If lAchou 
								cCliFor := Iif(mv_par30==1,SA1->A1_NREDUZ,SA1->A1_NOME)
							Endif
						Else
							dbSelectArea( "SA2")
							dbSetOrder(1)
							lAchou := .F.
							If Empty(xFilial("SA2"))  //SA2 Compartilhado
								If dbSeek(xFilial("SA2")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									lAchou := .T.
								Endif
							Else
								cFilOrig := NEWSE5->E5_FILIAL //Procuro SA2 pela filial do movimento
								If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
										lAchou := .T.
									Else
										cFilOrig := NEWSE5->E5_FILORIG //Procuro SA2 pela filial origem
										If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
											If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
												lAchou := .T.
											Endif
										Endif
									Endif
								Else
									cFilOrig := NEWSE5->E5_FILORIG	//Procuro SA2 pela filial origem
									If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
										If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
											lAchou := .T.
										Endif
									Endif
								Endif							
							EndIF
							If lAchou 
								cCliFor := Iif(mv_par30==1,SA2->A2_NREDUZ,SA2->A2_NOME)
							Endif
						EndIf
					EndIf
					dbSelectArea("SM2")
					dbSetOrder(1)
					dbSeek(NEWSE5->E5_DATA)
					dbSelectArea("NEWSE5")
					nTaxa:= 0
					If cPaisLoc=="BRA"
						If !Empty(NEWSE5->E5_TXMOEDA)
							nTaxa:=NEWSE5->E5_TXMOEDA
						Else
							If nMoedaBco == 1
								nTaxa := NEWSE5->E5_VALOR / NEWSE5->E5_VLMOED2
							Else
								nTaxa := NEWSE5->E5_VLMOED2 / NEWSE5->E5_VALOR
							EndIf
						EndIf
					EndIf
					nRecSe5:=If(lAsTop,NEWSE5->SE5RECNO,Recno())
					nDesc+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLDESCO,Round(xMoeda(NEWSE5->E5_VLDESCO,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
					nJuros+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLJUROS,Round(xMoeda(NEWSE5->E5_VLJUROS,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
					nMulta+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLMULTA,Round(xMoeda(NEWSE5->E5_VLMULTA,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
					nJurMul+= nJuros + nMulta
					nCM+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLCORRE,Round(xMoeda(NEWSE5->E5_VLCORRE,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
										
					If cCarteira == "R" .and. mv_par12 == SE1->E1_MOEDA					
					   nCM := 0
					
					ElseIf cCarteira == "P" .and. mv_par12 == SE2->E2_MOEDA
					   nCM := 0					   
					   
					Endif					
										
					If lPccBaixa .and. Empty(NEWSE5->E5_PRETPIS) .And. Empty(NEWSE5->E5_PRETCOF) .And. Empty(NEWSE5->E5_PRETCSL)
						If nRecSE2 > 0 
						
							aAreabk  := Getarea()
							aAreaSE2 := SE2->(Getarea())
							SE2->(DbGoto(nRecSE2))
						
							nTotAbImp+=(NEWSE5->E5_VRETPIS)+(NEWSE5->E5_VRETCOF)+(NEWSE5->E5_VRETCSL)+;
										SE2->E2_INSS+ SE2->E2_ISS+ SE2->E2_IRRF
										
							Restarea(aAreaSE2)
							Restarea(aAreabk)
						Else
							nTotAbImp+=(NEWSE5->E5_VRETPIS)+(NEWSE5->E5_VRETCOF)+(NEWSE5->E5_VRETCSL)
						Endif
					Endif				
					If NEWSE5->E5_TIPODOC $ "VL/V2/BA/RA/PA/CP"

						cHistorico := NEWSE5->E5_HISTOR

						If mv_par11 == 2
						  	nValor+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par12,SE2->E2_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0)),nDecs+1))
						Else
						  	nValor+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par12,SE1->E1_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),nDecs+1))						
						EndIf

						//Pcc Baixa CR
						If cCarteira == "R" .and. lPccBxCr .and. cPaisLoc == "BRA"
							If Empty(NEWSE5->E5_PRETPIS) 
								nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETPIS,Round(xMoeda(NEWSE5->E5_VRETPIS,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif						
							If Empty(NEWSE5->E5_PRETCOF) 
								nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETCOF,Round(xMoeda(NEWSE5->E5_VRETCOF,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif						
							If Empty(NEWSE5->E5_PRETCSL) 
								nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETCSL,Round(xMoeda(NEWSE5->E5_VRETCSL,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif											
						Endif

					Else
						nVlMovFin+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VALOR,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
						cHistorico := Iif(Empty(NEWSE5->E5_HISTOR),"MOV FIN MANUAL",NEWSE5->E5_HISTOR)
						cNatureza  	:= NEWSE5->E5_NATUREZ
					Endif	
					dbSkip()
					If lManual		// forca a saida do looping se for mov manual
						Exit
					Endif
				EndDO
	
				If (nDesc+nValor+nJurMul+nCM+nVlMovFin) > 0
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ C lculo do Abatimento        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If cCarteira == "R" .and. !lManual
						dbSelectArea("SE1")
						nRecno := Recno()
						nAbat := 0
						nAbatLiq := 0						
						If !SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG 

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Encontra a ultima sequencia de baixa na SE5 a partir do título da SE1 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							aAreaSE1 := SE1->(GetArea())
							dbSelectArea("SE5")
							dbSetOrder(7)
							cChaveSE1 := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
							SE5->(MsSeek(xFilial("SE5")+cChaveSE1))					
		               
							cSeqSE5 := SE5->E5_SEQ
                     
							While SE5->(!EOF()) .And. cChaveSE1 == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
								If SE5->E5_SEQ > cSeqSE5
									cSeqSE5 := SE5->E5_SEQ
								Endif	
								SE5->(dbSkip())
							Enddo

							SE5->(MsSeek(xFilial("SE5")+cChaveSE1+cSeqSE5))
							cChaveSE5 := cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja+cSeq							

							If cChaveSE5 == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ) .And.;
								Empty(SE1->E1_SALDO)
								If SE1->E1_VALOR <> SE1->E1_VALLIQ
									lUltBaixa := .T.
								EndIf
							EndIf                                                      

							RestArea(aAreaSE1)
                                                         
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Calcula o valor total de abatimento do titulo e impostos se houver ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							nTotAbImp := 0
							
							If lUltBaixa
								nAbat := SumAbatRec(cPrefixo,cNumero,cParcela,SE1->E1_MOEDA,"V",dBaixa,@nTotAbImp)
								nAbatLiq := nAbat - nTotAbImp
							EndIf
						                             
							lUltBaixa := .F.
						EndIf			
						dbSelectArea("SE1")
						dbGoTo(nRecno)
					Elseif !lManual
						dbSelectArea("SE2")
						nRecno := Recno()
						nAbat := 0
						nAbatLiq := 0						
						If !SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
							nAbat :=	SomaAbat(cPrefixo,cNumero,cParcela,"P",mv_par12,,cFornece,cLoja)
							nAbatLiq := nAbat	
						EndIf			
						dbSelectArea("SE2")
						dbGoTo(nRecno)
					EndIF
	
					If li > 55
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
					EndIF
	
					IF mv_par11 == 1 .and. aTam[1] > 6 .and. !lManual
						
						If lBxTit
							@li, aColu[05] PSAY SE1->E1_CLIENTE						
						Endif
						@li, aColu[06] PSAY SubStr(cCliFor,1,18)
						li++
					Elseif mv_par11 == 2 .and. aTam[1] > 6 .and. !lManual

						If lBxTit
							@li, aColu[05] PSAY SE2->E2_FORNECE
						Endif
						@li, aColu[06] PSAY SubStr(cCliFor,1,18)
						li++
					Endif

					IF mv_par11 == 1
						@li, 001 PSAY Posicione("SD2",3,xFilial("SD2")+cNumero+cPrefixo+SE1->E1_CLIENTE+SE1->E1_LOJA,'D2_CCUSTO')
					Elseif mv_par11 == 2
						@li, 001 PSAY Posicione("SD1",1,xFilial("SD1")+cNumero+cPrefixo+SE2->E2_FORNECE+SE2->E2_LOJA,'D1_CC')
                    ENDIF
						
					@li, aColu[01] PSAY cPrefixo
					@li, aColu[02] PSAY cNumero
					
					If cPaisLoc	$ "MEX|PTG"
					   li++
					Endif					
					
					@li, aColu[03] PSAY cParcela
					@li, aColu[04] PSAY cTipo		
	
					If !lManual
						dbSelectArea("TRB")
						lOriginal := .T.
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Baixas a Receber             ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If cCarteira == "R"
							cCliFor190 := SE1->E1_CLIENTE+SE1->E1_LOJA
							nVlr:= SE1->E1_VLCRUZ
							If mv_par12 > 1
								nVlr := Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par12,SE1->E1_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),nDecs+1)
							EndIF
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Baixa de PA                  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Else
							cCliFor190 := SE2->E2_FORNECE+SE2->E2_LOJA
							
							If cPaisLoc=="BRA"
								lCalcIRF:= Posicione("SA2",1,xFilial("SA2")+cCliFor190,"A2_CALCIRF") == "1" .Or.;//1-Normal, 2-Baixa
								           Posicione("SA2",1,xFilial("SA2")+cCliFor190,"A2_CALCIRF") == " "
							Else 
								lCalcIRF:=.f.
							EndIf
										
							// MV_MRETISS "1" retencao do ISS na Emissao, "2" retencao na Baixa.
							nVlr:= SE2->E2_VLCRUZ+ SE2->E2_INSS+ Iif(GetNewPar('MV_MRETISS',"1")=="1",SE2->E2_ISS,0) +;
									Iif(lCalcIRF,SE2->E2_IRRF,0)
									
							If mv_par12 > 1
								nVlr := Round(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par12,SE2->E2_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0)),nDecs+1)
							Endif
						Endif
						cFilTrb := If(cCarteira=="R","SE1","SE2")
						IF DbSeek( xFilial(cFilTrb)+cPrefixo+cNumero+cParcela+cCliFor190+cTipo)
							nAbat:=0
							lOriginal := .F.
						Else
							nVlr:=NoRound(nVlr)
							RecLock("TRB",.T.)
							Replace linha With xFilial(cFilTrb)+cPrefixo+cNumero+cParcela+cCliFor190+cTipo
							MsUnlock()
						EndIF
					Else
						If lAsTop
							dbSelectArea("SE5")
						Else
							dbSelectArea("NEWSE5")
						Endif
						dbgoto(nRecSe5)
						nVlr := Round(xMoeda(E5_VALOR,nMoedaBco,mv_par12,E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",E5_TXMOEDA,0)),nDecs+1)
						nAbat:= 0
						lOriginal := .t.
						If lAsTop
							nRecSe5:=NEWSE5->SE5RECNO
						Else
							nRecSe5:=Recno()
							NEWSE5->( dbSkip() )
						Endif
						dbSelectArea("TRB")
					Endif
					IF cCarteira == "R"
						If ( !lManual )
							If mv_par13 == 1  // Utilizar o Hist¢rico da Baixa ou Emiss„o
								cHistorico := Iif(Empty(cHistorico), SE1->E1_HIST, cHistorico )
							Else
								cHistorico := Iif(Empty(SE1->E1_HIST), cHistorico, SE1->E1_HIST )
							Endif
						EndIf
						If aTam[1] <= 6 .and. !lManual
							If lBxTit
								@li, aColu[05] PSAY SE1->E1_CLIENTE
							Endif
							@li, aColu[06] PSAY SubStr(cCliFor,1,18)
						Endif
						@li, 59 PSAY cNatureza
						If Empty( dDtMovFin ) .or. dDtMovFin == Nil
							dDtMovFin := CtoD("  /  /  ")
						Endif
						@li, 70 PSAY IIf(lManual,dDtMovFin,DataValida(SE1->E1_VENCTO,.T.))
						@li, 81 PSAY SubStr( cHistorico ,1,21)
						@li, 103 PSAY dBaixa
						IF nVlr > 0
							@li,114 PSAY nVlr  Picture tm(nVlr,12,nDecs)
						Endif
					Else
						If mv_par13 == 1  // Utilizar o Hist¢rico da Baixa ou Emiss„o
							cHistorico := Iif(Empty(cHistorico), SE2->E2_HIST, cHistorico )
						Else
							cHistorico := Iif(Empty(SE2->E2_HIST), cHistorico, SE2->E2_HIST )
						Endif
						If aTam[1] <= 6 .and. !lManual
							If lBxTit
								@li, aColu[05] PSAY SE2->E2_FORNECE
							Endif
							@li, aColu[06] PSAY SubStr(cCliFor,1,18)
						Endif
						@li, 59 PSAY cNatureza
						If Empty( dDtMovFin ) .or. dDtMovFin == Nil
							dDtMovFin := CtoD("  /  /  ")
						Endif
						@li, 70 PSAY IIf(lManual,dDtMovFin,DataValida(SE2->E2_VENCTO,.T.))
						If !Empty(cCheque)
							@li, 81 PSAY SubStr(ALLTRIM(cCheque)+"/"+Trim(cHistorico),1,18)
						Else
							@li, 81 PSAY SubStr(cHistorico,1,21)
						EndIf
						@li, 103 PSAY dBaixa
						IF nVlr > 0
							@li,114 PSAY nVlr Picture tm(nVlr,12,nDecs)
						Endif
					Endif
					nCT++
					
					//PCC Baixa CR
					//Somo aos abatimentos de impostos, os impostos PCC na baixa.
					//Caso o calculo do PCC CR seja pela emissao, esta variavel estara zerada
					nTotAbImp := nTotAbImp + nPccBxCr

					@li,127 PSAY nJurMul    PicTure tm(nJurMul,9,nDecs)
					@li,138 PSAY nCM        PicTure tm(nCM ,9,nDecs)
					@li,148 PSAY nDesc      PicTure tm(nDesc,9,nDecs)
					@li,158 PSAY nAbatLiq  	Picture tm(nAbatLiq,9,nDecs)
					@li,168 PSAY nTotAbImp 	Picture tm(nTotAbImp,9,nDecs)
					If (nVlr <= IIf(nVlMovFin > 0 , nVlMovFin , nValor)) .AND. ;
						(Substr(AllTrim(cHistorico),1,At("-",AllTrim(cHistorico))-1) == "LOJ")
						//---------------------------------------------------------------------------------
						//Quando o recebimento de titulos é efetuado pelo SIGALOJA e o parametro 
						//MV_LJTROCO == .T., o valor de total gravado no E5_VALOR é gravado com o valor do 
						// titulo (E1_VALOR) + valor do troco portanto deve-se mostrar o valor do E1_VALOR
						// e assim desconsidera-se o parâmetro.
						//---------------------------------------------------------------------------------
						@li,179 PSAY nVlr			PicTure tm(nVlr,15,nDecs)
						lBxLoja	:=	.T.
					ElseIf nVlMovFin > 0
						@li,179 PSAY nVlMovFin     PicTure tm(nVlMovFin,15,nDecs)
					Else
						@li,179 PSAY nValor			PicTure tm(nValor,15,nDecs)
					Endif
					@li,196 PSAY cBanco
					If Len(DtoC(dDigit)) <= 8
						@li,203 PSAY dDigit
					Else                   
						@li,201 PSAY dDigit
					EndIf
	
					If empty(cMotBaixa)
						cMotBaixa := "NOR"  //NORMAL
					Endif
	
					@li,212 PSAY Substr(cMotBaixa,1,3)
					@li,216 PSAY cFilorig
					
					nTotOrig   += Iif(lOriginal,nVlr,0)
					nTotBaixado+= If(cTipodoc $ "CP/BA" .AND. cMotBaixa $ "CMP/FAT",0,IIF(lBxLoja,nVlr,nValor))		// n„o soma, j  somou no principal					
					nTotDesc   += nDesc
					nTotJurMul += nJurMul
					nTotCM     += nCM
					nTotAbLiq  += nAbatLiq
					nTotImp    += nTotAbImp
					nTotValor  += IIF( lBxLoja , nVlr, IIF(nVlMovFin <> 0, nVlMovFin , Iif(MovBcoBx(cMotBaixa),IIF(lBxLoja,nVlr,nValor),0)))
					nTotMovFin += nVlMovFin
					nTotComp   += Iif(cTipodoc == "CP",IIF(lBxLoja,nVlr,nValor),0)
					nTotFat	   += Iif(cMotBaixa $ "FAT",IIF(lBxLoja,nVlr,nValor), 0)									
					nDesc := nJurMul := nValor := nCM := nAbat := nTotAbImp := nAbatLiq := nVlMovFin := 0
					nPccBxCr	 := 0			//PCC Baixa
					lBxLoja		 := .F.
					li++
				Endif
				dbSelectArea("NEWSE5")
			Enddo
	
			If (nTotValor+nDesc+nJurMul+nCM+nTotOrig+nTotMovFin+nTotComp)>0
				li++
				IF li > 55
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
				Endif
				If nCT > 0
					IF nOrdem == 1 .or. nOrdem == 6 .or. nOrdem == 8
						@li, 0 PSAY "Sub Total : " + DTOC(cAnterior)
					Elseif nOrdem == 2 .or. nOrdem == 4 .or. nOrdem == 7
						cLinha := "Sub Total : "+cAnterior+" "
						If nOrdem == 4
							If (mv_par11 == 1 .and. (cRecpag == "R" .and. !(cTipo190 $ MVPAGANT+"/"+MV_CPNEG))) .or. ;
								(cRecpag == "P" .and. cTipo190 $ MVRECANT+"/"+MV_CRNEG) .Or.;
								(cRecPag == "P" .And. cTipoDoc $ "DB#OD")
	
								dbSelectArea("SA1")
								DbSetOrder(1)
								If !Empty(cAnterior)
									MsSeek(cFilial+cFornece+cLoja)
									cLinha+=" "+A1_CGC
								Else
									cLinha+= OemToAnsi(STR0038)  //"Moviment. Financeiras Manuais "
								Endif
							ElseIF (mv_par11 == 2 .and. (cRecpag == "P" .and. !(cTipo190 $ MVRECANT+"/"+MV_CRNEG))) .or.;
									(cRecpag == "R" .and. cTipo190 $ MVPAGANT+"/"+MV_CPNEG)
								dbSelectArea("SA2")
								DbSetOrder(1)
								If !Empty(cAnterior)
									MsSeek(cFilial+cFornece+cLoja)
									cLinha+=TRIM(A2_NOME)+"  "+A2_CGC
								Else
									cLinha+= OemToAnsi(STR0038)  //"Moviment. Financeiras Manuais "
								Endif
							Endif
						Elseif nOrdem == 2
							dbSelectArea("SA6")
							DbSetOrder(1)
							MsSeek(xFilial("SA6")+cBancoAnt+cAgAnt+cContaAnt)
							cLinha+=TRIM(A6_NOME)
						Endif
						@li,0 PSAY cLinha
					Elseif nOrdem == 3
						dbSelectArea("SED")
						DbSetOrder(1)
						MsSeek(cFilial+cAnterior)
						@li, 0 PSAY "SubTotal : " + cAnterior + " "+ED_DESCRIC
					Endif
					If nOrdem != 5
						@li,102 PSAY nTotOrig     PicTure tm(nTotOrig,15,nDecs)
						@li,129 PSAY nTotJurMul   PicTure tm(nTotJurMul,9,nDecs)
  						@li,138 PSAY nTotCM       PicTure tm(nTotCM ,9,nDecs)
						@li,148 PSAY nTotDesc     PicTure tm(nTotDesc,9,nDecs)
						@li,158 PSAY nTotAbLiq    Picture tm(nTotAbLiq,9,nDecs)
						@li,168 PSAY nTotImp      Picture tm(nTotImp,9,nDecs)  
						@li,180 PSAY nTotValor    PicTure tm(nTotValor,11,nDecs)
						If nTotBaixado > 0
							@li,197 PSAY STR0028  //"Baixados"
							@li,206 PSAY nTotBaixado  PicTure tm(nTotBaixado,15,nDecs)
						Endif	
						If nTotMovFin > 0
							li++
							@li,197 PSAY STR0031   //"Mov Fin."
							@li,206 PSAY nTotMovFin   PicTure tm(nTotMovFin,15,nDecs)
						Endif
						If nTotComp > 0
							li++
							@li,197 PSAY STR0037  //"Compens."
							@li,206 PSAY nTotComp     PicTure tm(nTotComp,15,nDecs)
						Endif
						If nTotFat > 0
							li++
							@li,197 PSAY STR0076  //"Bx.Fatura"
							@li,206 PSAY nTotFat     PicTure tm(nTotFat,15,nDecs)
						Endif						
						li+=2
					Endif
					dbSelectArea("NEWSE5")
				Endif
			Endif
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Incrementa Totais Gerais ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nGerOrig	   += nTotOrig
			nGerValor	+= nTotValor 
			nGerDesc	   += nTotDesc
			nGerJurMul	+= nTotJurMul
			nGerCM		+= nTotCM                        
			nGerAbLiq	+= nTotAbLiq                                    
			nGerAbImp	+= nTotImp
			nGerBaixado += nTotBaixado
			nGerMovFin	+= nTotMovFin
			nGerComp	+= nTotComp
			nGerFat     += nTotFat			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                                   
			//³Incrementa Totais Filial ³                                  
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nFilOrig	+= nTotOrig               
			nFilValor	+=  nTotValor  
			nFilDesc	+= nTotDesc
			nFilJurMul	+= nTotJurMul
			nFilCM		+= nTotCM
			nFilAbLiq	+= nTotAbLiq 
			nFilAbImp	+= nTotImp 		
			nFilBaixado += nTotBaixado
			nFilMovFin	+= nTotMovFin
			nFilComp	+= nTotComp
			nFilFat	    += nTotFat
		Enddo
	Endif	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimir TOTAL por filial somente quan-³
	//³ do houver mais do que 1 filial.        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if mv_par17 == 1 .and. SM0->(Reccount()) > 1 .And. li != 80            
		@li,  0 PSAY "FILIAL : " +  cFilAnt + " - " + cFilNome
		@li,102 PSAY nFilOrig       PicTure tm(nFilOrig,15,nDecs)
		@li,129 PSAY nFilJurMul     PicTure tm(nFilJurMul,9,nDecs)
		@li,138 PSAY nFilCM         PicTure tm(nFilCM ,9,nDecs)
		@li,148 PSAY nFilDesc       PicTure tm(nFilDesc,9,nDecs)                                       
		@li,158 PSAY nFilAbLiq       PicTure tm(nFilAbLiq,9,nDecs)
		@li,168 PSAY nFilAbImp       PicTure tm(nFilAbImp,9,nDecs)
		@li,180 PSAY nFilValor      PicTure tm(nFilValor,15,nDecs)
		If nFilBaixado > 0 
			@li,197 PSAY STR0028 // "Baixados"
			@li,206 PSAY nFilBaixado    PicTure tm(nFilBaixado,15,nDecs)
		Endif
		If nFilMovFin > 0
			li++
			@li,197 PSAY STR0031   //"Mov Fin."
			@li,206 PSAY nFilMovFin   PicTure tm(nFilMovFin,15,nDecs)
		Endif
		If nFilComp > 0
			li++
			@li,197 PSAY STR0037  //"Compens."
			@li,206 PSAY nFilComp     PicTure tm(nFilComp,15,nDecs)
		Endif
		If nFilFat > 0
			li++
			@li,197 PSAY STR0076  //"Bx.Fatura"
			@li,206 PSAY nFilFat     PicTure tm(nFilFat,15,nDecs)
		Endif
		li+=2
		If Empty(xFilial("SE5")) .And. mv_par17 == 2
			Exit
		Endif	

		nFilOrig:=nFilJurMul:=nFilCM:=nFilDesc:=nFilAbLiq:=nFilAbImp:=nFilValor:=0
		nFilBaixado:=nFilMovFin:=nFilComp:=nFilFat:=0
	Endif
	dbSelectArea("SM0")
	cCodUlt := SM0->M0_CODIGO
	cFilUlt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	dbSkip()
Enddo

If li != 80
	// Imprime o cabecalho, caso nao tenha espaco suficiente para impressao do total geral
	If (li+4)>=60
		SM0->(MsSeek(cCodUlt+cFilUlt))		
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	Endif
	li+=2
	@li,  0 PSAY OemToAnsi(STR0029)  //"Total Geral : "
	@li,102 PSAY nGerOrig       PicTure tm(nGerOrig,15,nDecs)
	@li,129 PSAY nGerJurMul     PicTure tm(nGerJurMul,9,nDecs)
	@li,138 PSAY nGerCM         PicTure tm(nGerCM ,9,nDecs)
	@li,148 PSAY nGerDesc       PicTure tm(nGerDesc,9,nDecs)
	@li,158 PSAY nGerAbLiq       PicTure tm(nGerAbLiq,9,nDecs)
	@li,168 PSAY nGerAbImp       PicTure tm(nGerAbImp,9,nDecs)	
	@li,180 PSAY nGerValor      PicTure tm(nGerValor,15,nDecs)
	If nGerBaixado > 0 
		@li,197 PSAY OemToAnsi(STR0028) // "Baixados"
		@li,206 PSAY nGerBaixado    PicTure tm(nGerBaixado,15,nDecs)
	Endif
	If nGerMovFin > 0
		li++
		@li,197 PSAY OemToAnsi(STR0031)   //"Mov Fin."
		@li,206 PSAY nGerMovFin   PicTure tm(nGerMovFin,15,nDecs)
	Endif
	If nGerComp > 0
		li++
		@li,197 PSAY STR0037  //"Compens."
		@li,206 PSAY nGerComp     PicTure tm(nGerComp,15,nDecs)
	Endif
	If nGerFat > 0
		li++
		@li,197 PSAY STR0076  //"Bx.Fatura"
		@li,206 PSAY nGerFat     PicTure tm(nGerFat,15,nDecs)
	Endif
	li++
	roda(cbcont,cbtxt,"G")
Endif

SM0->(dbgoto(nRecEmp))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
dbSelectArea("TRB")
dbCloseArea()
Ferase(cNomArq1+GetDBExtension())
dbSelectArea("NEWSE5")
dbCloseArea()
If cNomeArq # Nil
	Ferase(cNomeArq+OrdBagExt())
Endif
dbSelectArea("SE5")
dbSetOrder(1)

If aReturn[5] == 1
	Set Printer to
	dbCommit()
	OurSpool(wnrel)
Endif

MS_FLUSH()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fr190TstCo³ Autor ³ Claudio D. de Souza   ³ Data ³ 22.08.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Testa as condicoes do registro do SE5 para permitir a impr.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Fr190TstCon(cFilSe5)													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cFilSe5 - Filtro em CodBase										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINR190																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr190TstCond(cFilSe5,lInterno)
Local lRet := .T.
Local nMoedaBco
Local lManual := .F.

If (Empty(NEWSE5->E5_TIPODOC) .And. mv_par16 == 1) .Or.;
	(Empty(NEWSE5->E5_NUMERO)  .And. mv_par16 == 1)
	lManual := .t.
EndIf

Do Case
Case !&(cFilSe5)           		// Verifico filtro CODEBASE tambem para TOP
	lRet := .F.
Case NEWSE5->E5_TIPODOC $ "DC/D2/JR/J2/TL/MT/M2/CM/C2" 
	lRet := .F.
Case NEWSE5->E5_SITUACA $ "C/E/X" .or. NEWSE5->E5_TIPODOC $ "TR#TE" .or.;
	(NEWSE5->E5_TIPODOC == "CD" .and. NEWSE5->E5_VENCTO > NEWSE5->E5_DATA)
	lRet := .F.
Case NEWSE5->E5_TIPODOC == "E2" .and. mv_par11 == 2
	lRet := .F.
Case Empty(NEWSE5->E5_TIPODOC) .and. mv_par16 == 2
	lRet := .F.
Case Empty(NEWSE5->E5_NUMERO) .and. mv_par16 == 2
	lRet := .F. 
Case mv_par16 == 2 .and. NEWSE5->E5_TIPODOC $ "CH" 
	lRet := .F. 
Case NEWSE5->E5_TIPODOC == "TR" .Or. NEWSE5->E5_MOTBX == "DSD"
	lRet := .F.
Case mv_par11 = 1 .And. E5_TIPODOC $ "E2#CB"
	lRet := .F.
Case NEWSE5->E5_BANCO < mv_par03 .Or. NEWSE5->E5_BANCO > MV_PAR04
	lRet := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se escolhido o parƒmetro "baixas normais", apenas imprime as baixas  ³
	//³que gerarem movimenta‡„o banc ria e as movimenta‡”es financeiras     ³
	//³manuais, se consideradas.                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Case mv_par14 == 1 .and. !MovBcoBx(NEWSE5->E5_MOTBX) .and. !lManual	
	lRet := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Case !Empty(cFilterUser).and.!(&cFilterUser)
	lRet := .F.	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe estorno para esta baixa, somente no nivel de quebra ³
	//³ mais interno, para melhorar a performance 										³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Case	lInterno .And.;
		!Empty(NEWSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)) .And.;
	  	TemBxCanc(NEWSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))	
	lRet := .F.
EndCase

If lRet .And. NEWSE5->E5_RECPAG == "R"
	If ( NEWSE5->E5_TIPODOC = "RA" .And. mv_par35 = 2 ) .Or.;
		(NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG.and. mv_par24 == 2 .and.;
		NEWSE5->E5_MOTBX == "CMP")
		lRet := .F.
	EndIf
Endif
If lRet .And. NEWSE5->E5_RECPAG == "P"
	If ( NEWSE5->E5_TIPODOC = "PA" .And. mv_par35 = 2 ) .Or.;
		(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. mv_par24 == 2 .and.;
		 NEWSE5->E5_MOTBX == "CMP")
		lRet := .F.
	EndIf
Endif	

If lRet .And. mv_par25 == 2
	If ( cPaisLoc # "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA) ) .OR. ( FindFunction( "FXMultSld" ) .AND. FXMultSld() )
	   SA6->(DbSetOrder(1))
	   SA6->(MsSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
	   nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
	ElseIf !Empty(NEWSE5->E5_ORDREC)
		nMoedaBco:= Val(NEWSE5->E5_MOEDA)
	Else
	   nMoedaBco	:=	1
	Endif
	If nMoedaBco <> mv_par12
		lRet := .F.
	EndIf
EndIf 

If lRet
	// Testar se considerar mov bancario e se o cancelamento da baixa tiver sido realizado, não imprimir o mov.						
	If MV_PAR16 == 1			   
		If Fr190MovCan(17,"NEWSE5")
		   lRet := .F.
		Endif   
	Endif
Endif

If lRet
	// Se for um recebimento de Titulo pago em dinheiro originado pelo SIGALOJA, nao imprime o mov.
	If NEWSE5->E5_TIPODOC == "BA" .and. NEWSE5->E5_MOTBX == "LOJ" .And. IsMoney(NEWSE5->E5_MOEDA)
		lRet := .F.	
	EndIf
EndIf

Return lRet     

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1³ Autor ³ Claudio D. de Souza   ³ Data ³ 26/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FINR190                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()

Local aArea 	:= GetArea()
Local aHelpPor  := {}
Local aHelpEng  := {}
Local aHelpSpa  := {}

/*------------------ MV_PAR38 -----------------------------*/
PutSx1(	"FIN190",;
		"38",;
		"Cons. Nat. Aglutinadas?",;
		"Cons. Nat. Aglutinadas?",;
		"Cons. Nat. Aglutinadas?",;
		"mv_ch38",;
		"N",;
		01,;
		0,;
		0,;
		"C",;
		"",;
		"",;
		"",;
		"",;
		"mv_par38",;
		"Sim",;
		"Si",;
		"Yes",;
		"",;
		"Nao",;
		"No",;
		"No",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		, , , )        

aHelpPor := {	"SIM - apresentará as naturezas do "	,;
				"relatório em formato Sintético e "		,;
				"Aglutinado. Caso o título possua "		,;
				"rateio múltiplas naturezas, ele "		,;
				"será apresentado em uma só linha,"		,;
				"constando a sua natureza principal,"	,;
				"ou seja, do SE5."						,;
				"NÃO - apresentará as naturezas do"		,;
				"relatório em formato Sintético."		,;
				"Caso o título possua rateio "			,;
				"múltiplas naturezas, ele será"			,;
				"apresentado no formato do rateio"		,;
				"efetuado, ou seja, conforme consta"	,;
				"no SEV. Somente títulos que não "		,;
				"possuam múltiplas naturezas,"			,;
				"apresentação a informação"				,;
				"existente no SE5."						,;
				"ATENÇÃO: Independente da resposta"		,;
				"escolhida para essa pergunta, o"		,;
				"relatório sempre levará em "			,;
				"consideração, tanto a natureza"		,;
				"do SE5 (baixa do título) quanto"		,;
				"do SEV (múltiplas naturezas do"		,;
				"título), para filtragem das "			,;
				"naturezas."							}

PutHelp("P.FIN19038.",aHelpPor,aHelpEng,aHelpSpa,.T.)

/*------------------ MV_PAR39 -----------------------------*/
aHelpPor := {	"Indica qual o metodo utilizado para"	,;
				"filtragem das naturezas. Os metodos"	,;
				"abaixo se baseiam nos parametros "		,;
				"'Da Natureza' e 'Ate a Natureza' "		,;
				"para realização do filtro."			,;
				"METODOS UTILIZADOS:"					,;
				"-PADRÃO: Este metodo se baseia na"		,;
				" pergunta 'Cons. Nat. Aglutinadas?'"	,;
				" para aplicar a filtragem."			,;				
				"-NAT.PRINCIPAL: Este metodo se "		,;
				" baseia somente na natureza princi-"	,;
				" pal informada na baixa do titulo"		,;
				" (Tabela SE5) para aplicar a fil-"		,;
				" tragem por naturezas."				,;
				"-MULT.NATUREZAS:Este metodo se "		,;
				" baseia somente nas multiplas natu-"	,;
				" rezas geradas na baixa do titulo"		,;
				" (Tabela SEV)."						,;
				" Nesta opção as baixas serão"			,;
				" apresentadas no formato do rateio"	,;
				" efetuado, ou seja, conforme consta"	,;
				" na tabela SEV. "						}

aHelpEng := {}
aHelpSpa := {}

PutSX1("FIN190",;
 	   "39",;
 	   "Filtrar Natureza Por?",;
 	   "Filtrar Natureza Por?",;
 	   "Filtrar Natureza Por?",;
 	   "mv_chz"			,;
 	   "N"				,;
 	   1				,;
 	   0				,;
 	   1				,;
 	   "C"				,;
 	   ""				,;
 	   ""				,;
 	   ""				,;
 	   "S"				,;
 	   "mv_par39"		,;
 	   "Padrão"			,;
 	   "Padrão"			,;
 	   "Padrão"			,;
 	   ""				,;
 	   "Nat.Principal"	,;
 	   "Nat.Principal"	,;
 	   "Nat.Principal"	,;
 	   "Mult.Naturezas"	,;
 	   "Mult.Naturezas"	,;
 	   "Mult.Naturezas"	,;
 	   ""				,;
 	   ""				,;
 	   ""				,;
 	   ""				,;
 	   ""				,;
 	   ""				,;
 	   aHelpPor,;
 	   aHelpEng,;
 	   aHelpSpa)

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FA190ImpR4 ³ Autor ³ Adrianne Furtado      ³ Data ³ 05.09.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rela‡„o das baixas                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA190ImpR4(nOrdem,aTotais)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nOrdem    - Ordem que sera utilizada na emissao do relatorio ³±±
±±³          ³ aTotais   - Array que retorna o totalizador especifico de    ³±±
±±³          ³ 			   cada quebra de secao                             ³±±
±±³          ³ oReport   - objeto da classe TReport                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA190ImpR4(nOrdem,aTotais,oReport,nGerOrig)
Local oBaixas	:= oReport:Section(1)
Local cExp 			:= ""
Local CbTxt,CbCont
Local nValor:=0,nDesc:=0,nJuros:=0,nMulta:=0,nJurMul:=0,nCM:=0,dData,nVlMovFin:=0
Local nTotValor:=0,nTotDesc:=0,nTotJurMul:=0,nTotCm:=0,nTotOrig:=0,nTotBaixado:=0,nTotMovFin:=0,nTotComp:=0,nTotFat:=0
Local nGerValor:=0,nGerDesc:=0,nGerJurMul:=0,nGerCm:=0,nGerBaixado:=0,nGerMovFin:=0,nGerComp:=0,nGerFat:=0
Local nFilOrig:=0,nFilJurMul:=0,nFilCM:=0,nFilDesc:=0
Local nFilAbLiq:=0,nFilAbImp:=0,nFilValor:=0,nFilBaixado:=0,nFilMovFin:=0,nFilComp:=0,nFilFat:=0
Local nAbatLiq := 0,nTotAbImp := 0,nTotImp := 0,nTotAbLiq := 0,nGerAbLiq := 0,nGerAbImp := 0
Local cBanco,cNatureza,cAnterior,cCliFor,nCT:=0,dDigit,cLoja
Local lContinua		:=.T.
Local lBxTit		:=.F.
Local tamanho		:="G"
Local aCampos:= {},cNomArq1:="",nVlr,cLinha,lOriginal:=.T.
Local nAbat 		:= 0
Local cHistorico
Local lManual 		:= .f.
Local cTipodoc
Local nRecSe5 		:= 0
Local dDtMovFin
Local cRecPag
Local nRecEmp 		:= SM0->(Recno())
Local cMotBaixa		:= CRIAVAR("E5_MOTBX")
Local cFilNome 		:= Space(15)
Local cCliFor190	:= ""
Local aTam 			:= IIF(mv_par11 == 1,TamSX3("E1_CLIENTE"),TamSX3("E2_FORNECE"))
Local aColu 		:= {}
Local nDecs	   		:= GetMv("MV_CENT"+(IIF(mv_par12 > 1 , STR(mv_par12,1),""))) 
Local nMoedaBco		:= 1
Local cCarteira
#IFDEF TOP
	Local aStru		:= SE5->(DbStruct()), nI
	Local cQuery
#ENDIF	
Local cFilTrb
Local lAsTop		:= .F.
Local cFilSe5		:= ".T."
Local cChave, bFirst
Local cFilOrig
Local lAchou		:= .F.
Local lF190Qry		:= ExistBlock("F190QRY")
Local cQueryAdd		:= ""
Local lAjuPar15		:= Len(AllTrim(mv_par15))==Len(mv_par15)
Local lAchouEmp		:= .T.                                
Local lAchouEst		:= .F.                                
Local nTamEH		:= TamSx3("EH_NUMERO")[1]
Local nTamEI		:= TamSx3("EI_NUMERO")[1]+TamSx3("EI_REVISAO")[1]+TamSx3("EI_SEQ")[1]
Local cCodUlt		:= SM0->M0_CODIGO
Local cFilUlt		:= IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
Local nRecno  
Local nSavOrd 
Local aAreaSE5 
Local cChaveNSE5	:= ""           
Local nRecSE2		:= 0
Local aAreaSE2
Local aAreabk

Local aRet 			:= {}
Local cAuxFilNome
Local cAuxCliFor
Local cAuxLote
Local dAuxDtDispo
Local cFilUser	 	:= ""

Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

Local nTaxa:= 0   
Local lUltBaixa := .F.
Local cChaveSE1 := ""
Local cChaveSE5 := ""
Local cSeqSE5 := ""
Local lNaturez := .F.  
Local lMVLjTroco	:= SuperGetMV("MV_LJTROCO", ,.F.)				
Local nRecnoSE5		:= 0
Local nValTroco 	:= 0
Local lTroco 		:= .F.

//Controla o Pis Cofins e Csll na baixa (1-Retem PCC na Baixa ou 2-Retem PCC na Emissão(default))
Local lPccBxCr	:= If (FindFunction("FPccBxCr"),FPccBxCr(),.F.)
Local nPccBxCr := 0

nGerOrig :=0

li := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par17 == 2 // Cons filiais abaixo
	cFilDe := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	cFilAte:= IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
Else
	cFilDe := mv_par18	// Todas as filiais
	cFilAte:= mv_par19
EndIf
// Definicao das condicoes e ordem de impressao, de acordo com a ordem escolhida pelo
// usuario.
DbSelectArea("SE5")
Do Case
Case nOrdem == 1
	cCondicao := "E5_DATA >= mv_par01 .and. E5_DATA <= mv_par02"
	cCond2 := "E5_DATA"
	cChave := IndexKey(1)
	cChaveInterFun := cChave
	bFirst := {|| MsSeek(xFilial("SE5")+Dtos(mv_par01),.T.)}
Case nOrdem == 2
	cCondicao := "E5_BANCO >= mv_par03 .and. E5_BANCO <= mv_par04"
	cCond2 := "E5_BANCO"
	cChave := IndexKey(3)
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5")+mv_par03,.T.)}
Case nOrdem == 3
	cCondicao := "E5_MULTNAT = '1' .Or. (E5_NATUREZ >= mv_par05 .and. E5_NATUREZ <= mv_par06)"
	cCond2 := "E5_NATUREZ"
	cChave := IndexKey(4)
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5")+mv_par05,.T.)}
Case nOrdem == 4
	cCondicao := ".T."
	cCond2 := "E5_BENEF"
	cChave := "E5_FILIAL+E5_BENEF+DTOS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA"
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 5
	cCondicao := ".T."
	cCond2 := "E5_NUMERO"
	cChave := "E5_FILIAL+E5_NUMERO+E5_PARCELA+E5_PREFIXO+DTOS(E5_DATA)"
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 6	//Ordem 6 (Digitacao)
	cCondicao := ".T."
	cCond2 := "E5_DTDIGIT"
	cChave := "E5_FILIAL+DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+DTOS(E5_DATA)"
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 7 // por Lote
	cCondicao := "E5_LOTE >= '"+mv_par20+"' .and. E5_LOTE <= '"+mv_par21+"'"
	cCond2 := "E5_LOTE"
	cChave := IndexKey(5)
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5")+mv_par20,.T.)}
OtherWise						// Data de Crédito (dtdispo)
	cCondicao := "E5_DTDISPO >= mv_par01 .and. E5_DTDISPO <= mv_par02"
	cCond2 := "E5_DTDISPO"
	cChave := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5")+Dtos(mv_par01),.T.)}
EndCase

If !Empty(mv_par28) .And. ! ";" $ mv_par28 .And. Len(AllTrim(mv_par28)) > 3
	ApMsgAlert(STR0073)//"Separe os tipos a imprimir (pergunta 28) por um ; (ponto e virgula) a cada 3 caracteres")
	Return(Nil)
Endif	
If !Empty(mv_par29) .And. ! ";" $ mv_par29 .And. Len(AllTrim(mv_par29)) > 3
	ApMsgAlert(STR0074)//"Separe os tipos que não deseja imprimir (pergunta 29) por um ; (ponto e virgula) a cada 3 caracteres")
	Return(Nil)
Endif	

#IFDEF TOP
	If TcSrvType() != "AS/400" .and. TCGetDB()!="SYBASE"
		
		lAsTop := .T.
		cCondicao := ".T."
		DbSelectArea("SE5")
		cQuery := ""
		aEval(DbStruct(),{|e| cQuery += ","+AllTrim(e[1])})
		// Obtem os registros a serem processados
		cQuery := "SELECT " +SubStr(cQuery,2)
		cQuery +=         ",SE5.R_E_C_N_O_ SE5RECNO "
		cQuery += "FROM " + RetSqlName("SE5")+" SE5 "
		cQuery += "WHERE E5_RECPAG = '" + IIF( mv_par11 == 1, "R","P") + "' AND "
		cQuery += "      E5_DATA    between '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "' AND "
		cQuery += "      E5_DATA    <= '" + DTOS(dDataBase) + "' AND "
		cQuery += "      E5_BANCO   between '" + mv_par03       + "' AND '" + mv_par04       + "' AND "
		//-- Realiza filtragem pela natureza principal
		If mv_par39 == 2
			cQuery +=  " E5_NATUREZ between '" + mv_par05       + "' AND '" + mv_par06     	+ "' AND "
		Else
			cQuery +=       " (E5_NATUREZ between '" + mv_par05       + "' AND '" + mv_par06       + "' OR "
			cQuery +=       " EXISTS (SELECT EV_FILIAL, EV_PREFIXO, EV_NUM, EV_PARCELA, EV_CLIFOR, EV_LOJA "
			cQuery +=                 " FROM "+RetSqlName("SEV")+" SEV "
			cQuery +=                " WHERE E5_FILIAL  = EV_FILIAL AND "
			cQuery +=                       "E5_PREFIXO = EV_PREFIXO AND "
			cQuery +=                       "E5_NUMERO  = EV_NUM AND "
			cQuery +=                       "E5_PARCELA = EV_PARCELA AND "
			cQuery +=                       "E5_TIPO    = EV_TIPO AND "		
			cQuery +=                       "E5_CLIFOR  = EV_CLIFOR AND "
			cQuery +=                       "E5_LOJA    = EV_LOJA AND " 
			cQuery +=                       "EV_NATUREZ between '" + mv_par05 + "' AND '" + mv_par06 + "' AND "
			cQuery +=                       "SEV.D_E_L_E_T_ = ' ')) AND "
		EndIf
		cQuery += "      E5_CLIFOR  between '" + mv_par07       + "' AND '" + mv_par08       + "' AND "
		cQuery += "      E5_DTDIGIT between '" + DTOS(mv_par09) + "' AND '" + DTOS(mv_par10) + "' AND "
		cQuery += "      E5_LOTE    between '" + mv_par20       + "' AND '" + mv_par21       + "' AND "
		cQuery += "      E5_LOJA    between '" + mv_par22       + "' AND '" + mv_par23 	    + "' AND "
		cQuery += "      E5_PREFIXO between '" + mv_par26       + "' AND '" + mv_par27 	    + "' AND "
		cQuery += "      SE5.D_E_L_E_T_ = ' '  AND "
		cQuery += "		  E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE') AND "
		cQuery += " 	  E5_SITUACA NOT IN ('C','E','X') AND "
		cQuery += "      ((E5_TIPODOC = 'CD' AND E5_VENCTO <= E5_DATA) OR "
		cQuery += "      (E5_TIPODOC <> 'CD')) "
		cQuery += "		  AND E5_HISTOR NOT LIKE '%"+STR0077+"%'"
		
		If mv_par11 == 2
			cQuery += " AND E5_TIPODOC <> 'E2'"
		EndIf
		
		If !Empty(mv_par28) // Deseja imprimir apenas os tipos do parametro 28
			cQuery += " AND E5_TIPO IN "+FormatIn(mv_par28,";")
		ElseIf !Empty(Mv_par29) // Deseja excluir os tipos do parametro 29
			cQuery += " AND E5_TIPO NOT IN "+FormatIn(mv_par29,";")
		EndIf
		
		If mv_par16 == 2
			cQuery += " AND E5_TIPODOC <> '" + SPACE(LEN(E5_TIPODOC)) + "'"
			cQuery += " AND E5_NUMERO  <> '" + SPACE(LEN(E5_NUMERO)) + "'"
			cQuery += " AND E5_TIPODOC <> 'CH'"
		Endif

		cCondFil := "NEWSE5->E5_FILIAL==xFilial('SE5')"
		
		If mv_par17 == 2
			cQuery += " AND E5_FILIAL = '" + FwxFilial("SE5") + "'"
		Else
			If Empty( FwxFilial("SE5") )
				cQuery += " AND E5_FILORIG between '" + mv_par18 + "' AND '" + mv_par19 + "'"
			Else
				cQuery += " AND E5_FILIAL between '" + mv_par18 + "' AND '" + mv_par19 + "'"
			EndIf
		Endif
		
		cFilUser := oBaixas:GetSqlExp('SE5')

		If lF190Qry
			cQueryAdd := ExecBlock("F190QRY", .F., .F., {cFilUser})
			If ValType(cQueryAdd) == "C"
				cQuery += " AND (" + cQueryAdd + ")"
			EndIf
		EndIf

		If !Empty(cFilUser)
			cQuery += " AND (" + cFilUser + ") "
		EndIf
		
		// seta a ordem de acordo com a opcao do usuario
		cQuery += " ORDER BY " + SqlOrder(cChave) 
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "NEWSE5", .F., .T.)
		For nI := 1 TO LEN(aStru)
			If aStru[nI][2] != "C"
				TCSetField("NEWSE5", aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
			EndIf
		Next
		DbGoTop()
	Else
#ENDIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abre o SE5 com outro alias para ser filtrado porque a funcao³        
		//³ TemBxCanc() utilizara o SE5 sem filtro.							 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Select("NEWSE5") == 0 .And. !( ChkFile("SE5",.F.,"NEWSE5") )
			Return(Nil)
		EndIf		
		lAsTop := .F.
		DbSelectArea("NEWSE5")
		cFilSE5 := 'E5_RECPAG=='+IIF(mv_par11 == 1,'"R"','"P"')+'.and.'
		cFilSE5 += 'DTOS(E5_DATA)>='+'"'+dtos(mv_par01)+'"'+'.and.DTOS(E5_DATA)<='+'"'+dtos(mv_par02)+'".and.'
		cFilSE5 += 'DTOS(E5_DATA)<='+'"'+dtos(dDataBase)+'".and.'
		If nOrdem == 3
			cFilSE5 += '(E5_MULTNAT = "1" .Or. (E5_NATUREZ>='+'"'+mv_par05+'"'+'.and.E5_NATUREZ<='+'"'+mv_par06+'")).and.'
		Else
			cFilSE5 += '(E5_NATUREZ>='+'"'+mv_par05+'"'+'.and.E5_NATUREZ<='+'"'+mv_par06+'").and.'
		Endif		
		cFilSE5 += 'E5_CLIFOR>='+'"'+mv_par07+'"'+'.and.E5_CLIFOR<='+'"'+mv_par08+'".and.'
		cFilSE5 += 'DTOS(E5_DTDIGIT)>='+'"'+dtos(mv_par09)+'"'+'.and.DTOS(E5_DTDIGIT)<='+'"'+dtos(mv_par10)+'".and.'
		cFilSE5 += 'E5_LOTE>='+'"'+mv_par20+'"'+'.and.E5_LOTE<='+'"'+mv_par21+'".and.'
		cFilSE5 += 'E5_LOJA>='+'"'+mv_par22+'"'+'.and.E5_LOJA<='+'"'+mv_par23+'".and.'
		cFilSe5 += 'E5_PREFIXO>='+'"'+mv_par26+'"'+'.And.E5_PREFIXO<='+'"'+mv_par27+'"'

		If !Empty(mv_par28) // Deseja imprimir apenas os tipos do parametro 28
			cFilSe5 += '.And.E5_TIPO $'+'"'+ALLTRIM(mv_par28)+Space(1)+'"'
		ElseIf !Empty(Mv_par29) // Deseja excluir os tipos do parametro 29
			cFilSe5 += '.And.!(E5_TIPO $'+'"'+ALLTRIM(mv_par29)+Space(1)+'")'
		EndIf

		cFilUser := oBaixas:GetAdvPlExp('SE5')
		If !Empty(cFilUser)
			cFilSe5 += '.And. (' + cFilUser + ')'		
		Endif
		
		cCondFil := "NEWSE5->E5_FILIAL==xFilial('SE5')"
		
		If mv_par17 == 2
			cFilSe5 += " .AND. E5_FILIAL = '" + xFilial("SE5") + "'"
		Else
			If Empty( xFilial("SE5") )
				cFilSe5 += " .AND. E5_FILORIG >= '" + mv_par18 + "' .AND. E5_FILORIG <= '" + mv_par19 + "'"
			Else
				cFilSe5 +=" .AND. E5_FILIAL >= '" + mv_par18 + "' .AND. E5_FILIAL <= '" + mv_par19 + "'"
			EndIf
		Endif
#IFDEF TOP
	Endif
#ENDIF	
// Se nao for TOP, ou se for TOP e for AS400, cria Filtro com IndRegua
// Pois em SQL os registros ja estao filtrados em uma Query
If !lAsTop
	cNomeArq := CriaTrab(Nil,.F.)
	IndRegua("NEWSE5",cNomeArq,cChave,,cFilSE5,OemToAnsi(STR0018))  //"Selecionando Registros..."
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{"LINHA","C",80,0 } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq1 := CriaTrab(aCampos)
dbUseArea( .T.,, cNomArq1, "Trb", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",cNomArq1,"LINHA",,,OemToAnsi(STR0018))  //"Selecionando Registros..."

aColu := Iif(aTam[1] > 6,{023,027,TamParcela("E1_PARCELA",40,39,38),042,000,022},{000,004,TamParcela("E1_PARCELA",17,16,15),019,023,030})


If MV_PAR16 == 1

	dbSelectArea("SE5")
	dbSetOrder(17) //"E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ+E5_TIPODOC+E5_SEQ"
	dbGoTop()

Endif



DbSelectArea("SM0")
DbSeek(cEmpAnt+cFilDe,.T.)

While !Eof() .and. SM0->M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) <= cFilAte
	cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	cFilNome:= SM0->M0_FILIAL
	DbSelectArea("NEWSE5")

	// Se nao for TOP, ou se for TOP e for AS400, posiciona no primeiro registro do escopo	
	// Pois em SQL os registro ja estao filtrados em uma Query e ja esta no inicio do arquivo
	If !lAsTop
		Eval(bFirst) // Posiciona no primeiro registro a ser processado
	Endif

	If ((MV_MULNATR .and. mv_par11 = 1 .and. mv_par38 = 2 .and. !mv_par39 == 2) .or. (MV_MULNATP .and. mv_par11 = 2 .and. mv_par38 = 2 .and. !mv_par39 == 2))
	
		Finr199(	@nGerOrig,@nGerValor,@nGerDesc,@nGerJurMul,@nGerCM,@nGerAbLiq,@nGerAbImp,@nGerBaixado,@nGerMovFin,@nGerComp,;
					@nFilOrig,@nFilValor,@nFilDesc,@nFilJurMul,@nFilCM,@nFilAbLiq,@nFilAbImp,@nFilBaixado,@nFilMovFin,@nFilComp,;
					.F.,cCondicao,cCond2,aColu,lContinua,cFilSe5,lAsTop,Tamanho, @aRet, @aTotais, nOrdem, @nGerFat, @nFilFat)

		#IFDEF TOP
			If TcSrvType() != "AS/400" .and. TCGetDB()!="SYBASE"
				dbSelectArea("SE5")
				dbCloseArea()
				ChKFile("SE5")
				dbSelectArea("SE5")
				dbSetOrder(1)
			Endif
		#ENDIF
		If Empty(xFilial("SE5"))
			Exit
		Endif
		dbSelectArea("SM0")
		cCodUlt := SM0->M0_CODIGO
		cFilUlt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
		dbSkip()
		Loop

	Else

		While NEWSE5->(!Eof()) .And. &cCondFil .And. &cCondicao .and. lContinua
			
			DbSelectArea("NEWSE5")
			// Testa condicoes de filtro	
			If !Fr190TstCond(cFilSe5,.F.)
				NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
				Loop
			Endif							
						
			// Se nao for TOP, ou se for TOP e for AS400, posiciona no primeiro registro do escopo	
			// Pois em SQL os registro ja estao filtrados em uma Query e ja esta no inicio do arquivo
			If !lAsTop 
				SE2->(dbSetOrder(1))
				SE2->(MsSeek(NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
				If SE2->E2_MULTNAT == '1'
					lNaturez := .F.					
					SEV->(dbSetOrder(1))
					SEV->(MsSeek(NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
					While NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == SEV->(EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA) .and. !lNaturez
						If SEV->EV_NATUREZ >= mv_par05 .and. SEV->EV_NATUREZ <= mv_par06
							lNaturez := .T.
						EndIf
						SEV->(DbSkip())
					EndDo
					If !lNaturez
						NEWSE5->(dbSkip())
						Loop
					EndIf
				Else
					If !(NEWSE5->E5_NATUREZ >= mv_par05 .and. NEWSE5->E5_NATUREZ <= mv_par06)
						NEWSE5->(dbSkip())
						Loop
					EndIf					
				EndIf
			EndIf		 	
			If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
				(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 	//Adiantamento
				cCarteira := "R"
			Else
				cCarteira := "P"
			Endif
	
			dbSelectArea("NEWSE5")
			cAnterior 	:= &cCond2
			nTotValor	:= 0
			nTotDesc	   := 0
			nTotJurMul  := 0
			nTotCM		:= 0
			nCT			:= 0
			nTotOrig	   := 0
			nTotBaixado	:= 0
			nTotAbLiq  	:= 0
			nTotImp		:= 0
			nTotMovFin	:= 0
			nTotComp		:= 0
	
			While NEWSE5->(!EOF()) .and. &cCond2=cAnterior .and. &cCondFil .and. lContinua
	
				lManual := .f.
				dbSelectArea("NEWSE5")
				
				If (Empty(NEWSE5->E5_TIPODOC) .And. mv_par16 == 1) .Or.;
					(Empty(NEWSE5->E5_NUMERO)  .And. mv_par16 == 1)
					lManual := .t.
				EndIf
				
				// Testa condicoes de filtro	
				If !Fr190TstCond(cFilSe5,.T.)
					dbSelectArea("NEWSE5")
					NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
					Loop
				Endif	 						
					
				// Imprime somente cheques
				If mv_par37 == 1 .And. NEWSE5->E5_TIPODOC == "BA"

					aAreaSE5 := SE5->(GetArea())
					lAchou := .F.

					SE5->(dbSetOrder(11))
					cChaveNSE5	:= NEWSE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
					SE5->(MsSeek(xFilial("SE5")+cChaveNSE5))					
               
					// Procura o cheque aglutinado, se encontrar, marca lAchou := .T. e despreza 
					WHILE SE5->(!EOF()) .And. SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)	== cChaveNSE5
						If SE5->E5_TIPODOC == "CH"
							lAchou := .T.
							Exit
						Endif
						SE5->(dbSkip())
					Enddo
					RestArea(aAreaSE5)
					// Achou cheque aglutinado para a baixa, despreza o registro
					If lAchou
						NEWSE5->(dbSkip())
						Loop
					Endif  	

				ElseIf mv_par37 == 2 .And. NEWSE5->E5_TIPODOC == "CH" //somente baixas

					aAreaSE5 := SE5->(GetArea())
					lAchou := .F.
					
					SE5->(dbSetOrder(11))
					cChaveNSE5	:= NEWSE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
					SE5->(MsSeek(xFilial("SE5")+cChaveNSE5))					
               
					// Procura a baixa aglutinada, se encontrar despreza o movimento bancario
					WHILE SE5->(!EOF()) .And. SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)	== cChaveNSE5
						If SE5->E5_TIPODOC $ "BA"
							lAchou := .T.
							Exit
						Endif	
						SE5->(dbSkip())
					Enddo
					RestArea(aAreaSE5)
					// Achou cheque aglutinado para a baixa, despreza o registro
					If lAchou
						NEWSE5->(dbSkip())
						Loop
					Endif
				Endif	

				cNumero    	:= NEWSE5->E5_NUMERO
				cPrefixo   	:= NEWSE5->E5_PREFIXO
				cParcela   	:= NEWSE5->E5_PARCELA
				dBaixa     	:= NEWSE5->E5_DATA
				cBanco     	:= NEWSE5->E5_BANCO
				cNatureza  	:= NEWSE5->E5_NATUREZ
				cCliFor    	:= NEWSE5->E5_BENEF
				cLoja      	:= NEWSE5->E5_LOJA
				cSeq       	:= NEWSE5->E5_SEQ
				cNumCheq   	:= NEWSE5->E5_NUMCHEQ
				cRecPag     := NEWSE5->E5_RECPAG
				cTipodoc   	:= NEWSE5->E5_TIPODOC
				cMotBaixa	:= NEWSE5->E5_MOTBX
				cCheque    	:= NEWSE5->E5_NUMCHEQ
				cTipo      	:= NEWSE5->E5_TIPO
				cFornece   	:= NEWSE5->E5_CLIFOR
				cLoja      	:= NEWSE5->E5_LOJA
				dDigit     	:= NEWSE5->E5_DTDIGIT
				lBxTit	  	:= .F.
				cFilorig    := NEWSE5->E5_FILORIG
				
				If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
					(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 	//Adiantamento
					dbSelectArea("SE1")
					dbSetOrder(1)
					lBxTit := MsSeek(cFilial+cPrefixo+cNumero+cParcela+cTipo)
					If !lBxTit
						lBxTit := dbSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo)
					Endif				
					cCarteira := "R"
					dDtMovFin := IIF (lManual,CTOD("//"), DataValida(SE1->E1_VENCTO,.T.))
					While SE1->(!Eof()) .and. SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO==cPrefixo+cNumero+cParcela+cTipo
						If SE1->E1_CLIENTE == cFornece .And. SE1->E1_LOJA == cLoja	// Cliente igual, Ok
							Exit
						Endif                                
						SE1->( dbSkip() )
					EndDo
					If !SE1->(EOF()) .And. mv_par11 == 1 .and. !lManual .and.  ;
						(NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG))
						If SE5->(FieldPos("E5_SITCOB")) > 0
							cExp := "NEWSE5->E5_SITCOB"
						Else
							cExp := "SE1->E1_SITUACA"
						Endif 
						
						If mv_par36 == 2 // Nao imprime titulos em carteira 
							// Retira da comparacao as situacoes branco, 0, F e G
							mv_par15 := AllTrim(mv_par15)       
							mv_par15 := StrTran(mv_par15,"0","")
							mv_par15 := StrTran(mv_par15,"F","")
							mv_par15 := StrTran(mv_par15,"G","")
						Else
							If (NEWSE5->E5_RECPAG == "R") .And. lAjuPar15
								mv_par15  += " "
							Endif
						EndIf	
				
						cExp += " $ mv_par15" 
						If !(&cExp)
							dbSelectArea("NEWSE5")
							NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
							Loop
						Endif
					Endif
					cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+DtoS(dBaixa)+cSeq+cNumCheq"
					nDesc := nJuros := nValor := nMulta := nJurMul := nCM := nVlMovFin := 0
				Else
					dbSelectArea("SE2")
					DbSetOrder(1)
					cCarteira := "P"
				    lBxTit 	:= MsSeek(cFilial+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
				    
				    Iif(lBxTit, nRecSE2	:= SE2->(Recno()), nRecSE2 := 0 )
				    
					If !lBxTit
						lBxTit := dbSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
					Endif				
					dDtMovFin := IIF(lManual,CTOD("//"),DataValida(SE2->E2_VENCTO,.T.))
					cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+cFornece+DtoS(dBaixa)+cSeq+cNumCheq"
					nDesc := nJuros := nValor := nMulta := nJurMul := nCM := nVlMovFin := 0
					cCheque    := Iif(Empty(NEWSE5->E5_NUMCHEQ),SE2->E2_NUMBCO,NEWSE5->E5_NUMCHEQ)
				Endif
				dbSelectArea("NEWSE5")

				cHistorico := Space(40)
				While NEWSE5->( !Eof()) .and. &cCond3 .and. lContinua .And. &cCondFil
					
					dbSelectArea("NEWSE5")
					cTipodoc   := NEWSE5->E5_TIPODOC
					cCheque    := NEWSE5->E5_NUMCHEQ
	
					lAchouEmp := .T.
					lAchouEst := .F.
	
					// Testa condicoes de filtro	
					If !Fr190TstCond(cFilSe5,.T.)
						dbSelectArea("NEWSE5")
						NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
						Loop
					Endif	  								
												
					If NEWSE5->E5_SITUACA $ "C/E/X" 
						dbSelectArea("NEWSE5")
						NEWSE5->( dbSkip() )
						Loop
					EndIF
					
					If NEWSE5->E5_LOJA != cLoja
						Exit
					Endif
	
					If NEWSE5->E5_FILORIG < mv_par33 .or. NEWSE5->E5_FILORIG > mv_par34
						dbSelectArea("NEWSE5")
						NEWSE5->( dbSkip() )
						Loop
					Endif
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Nao imprime os registros de emprestimos excluidos ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
					If NEWSE5->E5_TIPODOC == "EP"
						aAreaSE5 := NEWSE5->(GetArea())	
						dbSelectArea("SEH")
						dbSetOrder(1)
						lAchouEmp := MsSeek(xFilial("SEH")+Substr(NEWSE5->E5_DOCUMEN,1,nTamEH))
						RestArea(aAreaSE5)
						If !lAchouEmp
							NEWSE5->(dbSkip())
							Loop
						EndIf
					EndIf
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Nao imprime os registros de pagamento de emprestimos estornados ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
					If NEWSE5->E5_TIPODOC == "PE"
						aAreaSE5 := NEWSE5->(GetArea())	
						dbSelectArea("SEI")
						dbSetOrder(1)
						If	MsSeek(xFilial("SEI")+"EMP"+Substr(NEWSE5->E5_DOCUMEN,1,nTamEI))
							If SEI->EI_STATUS == "C"
								lAchouEst := .T.
							EndIf
						EndIf
						RestArea(aAreaSE5)
						If lAchouEst
							NEWSE5->(dbSkip())
							Loop
						EndIf
					EndIf
	  
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica o vencto do Titulo ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cFilTrb := If(mv_par11==1,"SE1","SE2")
					If (cFilTrb)->(!Eof()) .And.;
						((cFilTrb)->&(Right(cFilTrb,2)+"_VENCREA") < mv_par31 .Or. (!Empty(mv_par32) .And. (cFilTrb)->&(Right(cFilTrb,2)+"_VENCREA") > mv_par32))
						dbSelectArea("NEWSE5")
						NEWSE5->(dbSkip())
						Loop
					Endif
	            
					dBaixa     	:= NEWSE5->E5_DATA
					cBanco     	:= NEWSE5->E5_BANCO
					cNatureza  	:= NEWSE5->E5_NATUREZ
					cCliFor    	:= NEWSE5->E5_BENEF
					cSeq       	:= NEWSE5->E5_SEQ
					cNumCheq   	:= NEWSE5->E5_NUMCHEQ
					cRecPag		:= NEWSE5->E5_RECPAG
					cMotBaixa	:= NEWSE5->E5_MOTBX
					cTipo190		:= NEWSE5->E5_TIPO
					cFilorig    := NEWSE5->E5_FILORIG
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Obter moeda da conta no Banco.                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ( cPaisLoc # "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA) ) .OR. ( FindFunction( "FXMultSld" ) .AND. FXMultSld() )
						SA6->(DbSetOrder(1))
						SA6->(MsSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
						nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
					Else
						nMoedaBco	:=	1
					Endif
	
					If !Empty(NEWSE5->E5_NUMERO)
						If (NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG)) .or. ;
							(NEWSE5->E5_RECPAG == "P" .and. NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG) .Or.;
							(NEWSE5->E5_RECPAG == "P" .And. NEWSE5->E5_TIPODOC $ "DB#OD")
							dbSelectArea( "SA1")
							dbSetOrder(1)
							lAchou := .F.
							If Empty(xFilial("SA1"))  //SA1 Compartilhado
								If dbSeek(xFilial("SA1")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									lAchou := .T.
								Endif
							Else
								cFilOrig := NEWSE5->E5_FILIAL //Procuro SA1 pela filial do movimento
								If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
										lAchou := .T.
									Else
										cFilOrig := NEWSE5->E5_FILORIG //Procuro SA1 pela filial origem
										If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
											If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
												lAchou := .T.
											Endif
										Endif
									Endif
								Else
									cFilOrig := NEWSE5->E5_FILORIG	//Procuro SA1 pela filial origem
									If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
										If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
											lAchou := .T.
										Endif
									Endif
								Endif							
							EndIF
							If lAchou 
								cCliFor := Iif(mv_par30==1,SA1->A1_NREDUZ,SA1->A1_NOME)
							Else
								cCliFor	:= 	Upper(Alltrim(NEWSE5->E5_BENEF))
							Endif
						Else
							dbSelectArea( "SA2")
							dbSetOrder(1)
							lAchou := .F.
							If Empty(xFilial("SA2"))  //SA2 Compartilhado
								If dbSeek(xFilial("SA2")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									lAchou := .T.
								Endif
							Else
								cFilOrig := NEWSE5->E5_FILIAL //Procuro SA2 pela filial do movimento
								If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
										lAchou := .T.
									Else
										cFilOrig := NEWSE5->E5_FILORIG //Procuro SA2 pela filial origem
										If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
											If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
												lAchou := .T.
											Endif
										Endif
									Endif
								Else
									cFilOrig := NEWSE5->E5_FILORIG	//Procuro SA2 pela filial origem
									If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
										If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
											lAchou := .T.
										Endif
									Endif
								Endif							
							EndIF
							If lAchou 
								cCliFor := Iif(mv_par30==1,SA2->A2_NREDUZ,SA2->A2_NOME)
							Else
								cCliFor	:= 	Upper(Alltrim(NEWSE5->E5_BENEF))
							Endif
						EndIf
					EndIf
					dbSelectArea("SM2")
					dbSetOrder(1)
					dbSeek(NEWSE5->E5_DATA)
					dbSelectArea("NEWSE5") 
					nTaxa:= 0

					If cPaisLoc=="BRA"
						If !Empty(NEWSE5->E5_TXMOEDA)
							nTaxa:=NEWSE5->E5_TXMOEDA
						Else
							If nMoedaBco == 1
								nTaxa := NEWSE5->E5_VALOR / NEWSE5->E5_VLMOED2
							Else
								nTaxa := NEWSE5->E5_VLMOED2 / NEWSE5->E5_VALOR
							EndIf																
						EndIf
					EndIf
					nRecSe5:=If(lAsTop,NEWSE5->SE5RECNO,Recno())
					nDesc+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLDESCO,Round(xMoeda(NEWSE5->E5_VLDESCO,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
					nJuros+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLJUROS,Round(xMoeda(NEWSE5->E5_VLJUROS,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
					nMulta+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLMULTA,Round(xMoeda(NEWSE5->E5_VLMULTA,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
					nJurMul+= nJuros + nMulta
					nCM+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLCORRE,Round(xMoeda(NEWSE5->E5_VLCORRE,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))

					If lPccBaixa .and. Empty(NEWSE5->E5_PRETPIS) .And. Empty(NEWSE5->E5_PRETCOF) .And. Empty(NEWSE5->E5_PRETCSL)
						If nRecSE2 > 0 
						
							aAreabk  := Getarea()
							aAreaSE2 := SE2->(Getarea())
							SE2->(DbGoto(nRecSE2))
						
							nTotAbImp+=(NEWSE5->E5_VRETPIS)+(NEWSE5->E5_VRETCOF)+(NEWSE5->E5_VRETCSL)+;
										SE2->E2_INSS+ SE2->E2_ISS+ SE2->E2_IRRF
										
							Restarea(aAreaSE2)
							Restarea(aAreabk)
						Else
							nTotAbImp+=(NEWSE5->E5_VRETPIS)+(NEWSE5->E5_VRETCOF)+(NEWSE5->E5_VRETCSL)
						Endif
					Endif				

					If NEWSE5->E5_TIPODOC $ "VL/V2/BA/RA/PA/CP"
						nValTroco := 0                                          					
						cHistorico := NEWSE5->E5_HISTOR

						If mv_par11 == 2
						 	nValor+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par12,SE2->E2_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0)),nDecs+1))
						Else
						 	nValor+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par12,SE1->E1_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),nDecs+1))
						EndIf						

						If lMVLjTroco
							lTroco := If(Substr(NEWSE5->E5_HISTOR,1,3)=="LOJ",.T.,.F.)
							If lTroco						
								nRecnoSE5 := SE5->(Recno())
								DbSelectArea("SE5")
								DbSetOrder(7)
								If dbSeek(xFilial("SE5")+NEWSE5->E5_PREFIXO+NEWSE5->E5_NUMERO+NEWSE5->E5_PARCELA+Space(TamSX3("E5_TIPO")[1])+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									While !Eof() .AND. xFilial("SE5") == SE5->E5_FILIAL .AND. NEWSE5->E5_PREFIXO+NEWSE5->E5_NUMERO+NEWSE5->E5_PARCELA+Space(TamSX3("E5_TIPO")[1])+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA == SE5->E5_PREFIXO+;
														SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR + SE5->E5_LOJA
										
										If SE5->E5_MOEDA = "TC" .AND. SE5->E5_TIPODOC = "VL" .AND.;
											SE5->E5_RECPAG = "P" 
											nValTroco := SE5->E5_VALOR
										EndIf  
										SE5->(DbSkip())				    					
									EndDo
								EndIf
								SE5->(DbGoTo(nRecnoSE5)) 			   
							Endif
                        Endif                                                              
                        
						dbSelectArea("NEWSE5") 										
						
						nValor -= nValTroco

						//Pcc Baixa CR
						If cCarteira == "R" .and. lPccBxCr .and. cPaisLoc == "BRA"
							If Empty(NEWSE5->E5_PRETPIS) 
								nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETPIS,Round(xMoeda(NEWSE5->E5_VRETPIS,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif						
							If Empty(NEWSE5->E5_PRETCOF) 
								nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETCOF,Round(xMoeda(NEWSE5->E5_VRETCOF,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif						
							If Empty(NEWSE5->E5_PRETCSL) 
								nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETCSL,Round(xMoeda(NEWSE5->E5_VRETCSL,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif											
						Endif

					Else
						nVlMovFin+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VALOR,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
						cHistorico := Iif(Empty(NEWSE5->E5_HISTOR),"MOV FIN MANUAL",NEWSE5->E5_HISTOR)
						cNatureza  	:= NEWSE5->E5_NATUREZ
					Endif	

					cAuxFilNome := cFilAnt + " - "+ cFilNome
					cAuxCliFor  := cCliFor					    
					cAuxLote    := E5_LOTE
					dAuxDtDispo := E5_DTDISPO

					dbSkip()
					If lManual		// forca a saida do looping se for mov manual
						Exit
					Endif
				EndDO
	
				If (nDesc+nValor+nJurMul+nCM+nVlMovFin) > 0    
					AAdd(aRet, Array(28))

					// Defaults >>>
					aRet[Li][01] := ""
					aRet[Li][02] := ""
					aRet[Li][03] := ""
					aRet[Li][04] := ""
					aRet[Li][05] := ""
					// <<< Defaults
					
					aRet[Li][22] := cAuxFilNome
					aRet[Li][23] := cAuxCliFor
					aRet[Li][24] := cAuxLote
					aRet[Li][25] := dAuxDtDispo
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ C lculo do Abatimento        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If cCarteira == "R" .and. !lManual
						dbSelectArea("SE1")
						nRecno := Recno()
						nAbat := 0
						nAbatLiq := 0						
						If !SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG 
                                 
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Encontra a ultima sequencia de baixa na SE5 a partir do título da SE1 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							aAreaSE1 := SE1->(GetArea())
							dbSelectArea("SE5")
							dbSetOrder(7)
							cChaveSE1 := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
							SE5->(MsSeek(xFilial("SE5")+cChaveSE1))
		               
							cSeqSE5 := SE5->E5_SEQ
                     
							While SE5->(!EOF()) .And. cChaveSE1 == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
								If SE5->E5_SEQ > cSeqSE5
									cSeqSE5 := SE5->E5_SEQ
								Endif
								SE5->(dbSkip())
							Enddo

							SE5->(MsSeek(xFilial("SE5")+cChaveSE1+cSeqSE5))
							cChaveSE5 := cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja+cSeq							

							If cChaveSE5 == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ) .And.;
								Empty(SE1->E1_SALDO)
								If SE1->E1_VALOR <> SE1->E1_VALLIQ
									lUltBaixa := .T.                  
								EndIf
							EndIf                                                     

							RestArea(aAreaSE1)
                                     
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Calcula o valor total de abatimento do titulo e impostos se houver ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							nTotAbImp  := 0  

							If lUltBaixa
								nAbat := SumAbatRec(cPrefixo,cNumero,cParcela,SE1->E1_MOEDA,"V",dBaixa,@nTotAbImp)
								nAbatLiq := nAbat - nTotAbImp
							EndIf	
							lUltBaixa := .F.							
						EndIf			
						dbSelectArea("SE1")
						dbGoTo(nRecno)
					Elseif !lManual
						dbSelectArea("SE2")
						nRecno := Recno()
						nAbat := 0
						nAbatLiq := 0						
						If !SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
							nAbat :=	SomaAbat(cPrefixo,cNumero,cParcela,"P",mv_par12,,cFornece,cLoja)
							nAbatLiq := nAbat	
						EndIf			
						dbSelectArea("SE2")
						dbGoTo(nRecno)
					EndIF
					aRet[li][05]:= " "
					IF mv_par11 == 1 .and. aTam[1] > 6 .and. !lManual
						If lBxTit
							aRet[li][05] := SE1->E1_CLIENTE						
						Endif
						aRet[li][06] := AllTrim(cCliFor)
					Elseif mv_par11 == 2 .and. aTam[1] > 6 .and. !lManual
						If lBxTit
							aRet[li][05] := SE2->E2_FORNECE
						Endif
						aRet[li][06] := AllTrim(cCliFor)
					Endif
	
					aRet[li][01] := cPrefixo
					aRet[li][02] := cNumero
					aRet[li][03] := cParcela
					aRet[li][04] := cTipo		
	
					If !lManual
						dbSelectArea("TRB")
						lOriginal := .T.
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Baixas a Receber             ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If cCarteira == "R"
							cCliFor190 := SE1->E1_CLIENTE+SE1->E1_LOJA
							nVlr:= SE1->E1_VLCRUZ
							If mv_par12 > 1
								nVlr := Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par12,SE1->E1_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),nDecs+1)
							EndIF
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Baixa de PA                  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Else
							cCliFor190 := SE2->E2_FORNECE+SE2->E2_LOJA
                                                                      
							If cPaisLoc=="BRA"
								lCalcIRF:= Posicione("SA2",1,xFilial("SA2")+cCliFor190,"A2_CALCIRF") == "1" .Or.;//1-Normal, 2-Baixa
								    	   Posicione("SA2",1,xFilial("SA2")+cCliFor190,"A2_CALCIRF") == " "
							Else 
								lCalcIRF:=.f.
							EndIf

							// MV_MRETISS "1" retencao do ISS na Emissao, "2" retencao na Baixa.
							nVlr:= SE2->E2_VLCRUZ+ SE2->E2_INSS+ Iif(GetNewPar('MV_MRETISS',"1")=="1",SE2->E2_ISS,0) +;
									Iif(lCalcIRF,SE2->E2_IRRF,0)

							If mv_par12 > 1
								nVlr := Round(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par12,SE2->E2_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0)),nDecs+1)
							Endif
						Endif
						aRet[li,28] := nRecSE5
						dbgoto(nRecSe5)
						cFilTrb := If(cCarteira=="R","SE1","SE2")
						IF DbSeek( xFilial(cFilTrb)+cPrefixo+cNumero+cParcela+cCliFor190+cTipo)
							nAbat:=0
							lOriginal := .F.
						Else
							nVlr:=NoRound(nVlr)
							RecLock("TRB",.T.)
							Replace linha With xFilial(cFilTrb)+cPrefixo+cNumero+cParcela+cCliFor190+cTipo
							MsUnlock()
						EndIF
					Else
						If lAsTop
							dbSelectArea("SE5")
						Else
							dbSelectArea("NEWSE5")
						Endif         
						aRet[li,28] := nRecSE5
						dbgoto(nRecSe5)
						nVlr := Round(xMoeda(E5_VALOR,nMoedaBco,mv_par12,E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",E5_TXMOEDA,0)),nDecs+1)
						nAbat:= 0
						lOriginal := .t.
						If lAsTop
							nRecSe5:=NEWSE5->SE5RECNO
						Else
							nRecSe5:=Recno()
							NEWSE5->( dbSkip() )
						Endif
						dbSelectArea("TRB")
					Endif
					IF cCarteira == "R"
						If ( !lManual )
							If mv_par13 == 1  // Utilizar o Hist¢rico da Baixa ou Emiss„o
								cHistorico := Iif(Empty(cHistorico), SE1->E1_HIST, cHistorico )
							Else
								cHistorico := Iif(Empty(SE1->E1_HIST), cHistorico, SE1->E1_HIST )
							Endif
						EndIf
						If aTam[1] <= 6 .and. !lManual
							If lBxTit
								aRet[li][05] := SE1->E1_CLIENTE
							Endif
							aRet[li][06] := AllTrim(cCliFor)
						Endif
						aRet[li][07] := cNatureza
						If Empty( dDtMovFin ) .or. dDtMovFin == Nil
							dDtMovFin := CtoD("  /  /  ")
						Endif
						aRet[li][08] := IIf(lManual,dDtMovFin,DataValida(SE1->E1_VENCTO,.T.)) //Vencto
						aRet[li][09] := AllTrim(cHistorico)
						aRet[li][10] := dBaixa
						IF nVlr > 0
							aRet[li][11] := nVlr // Picture tm(nVlr,14,nDecs)
						Endif
					Else
						If mv_par13 == 1  // Utilizar o Hist¢rico da Baixa ou Emiss„o
							cHistorico := Iif(Empty(cHistorico), SE2->E2_HIST, cHistorico )
						Else
							cHistorico := Iif(Empty(SE2->E2_HIST), cHistorico, SE2->E2_HIST )
						Endif
						If aTam[1] <= 6 .and. !lManual
							If lBxTit
								aRet[li][05] := SE2->E2_FORNECE
							Endif
							aRet[li][06] := AllTrim(cCliFor)
						Endif
						aRet[li][07] := cNatureza
						If Empty( dDtMovFin ) .or. dDtMovFin == Nil
							dDtMovFin := CtoD("  /  /  ")
						Endif
						aRet[li][08] := IIf(lManual,dDtMovFin,DataValida(SE2->E2_VENCTO,.T.))
						If !Empty(cCheque)
							aRet[li][09] := ALLTRIM(cCheque)+"/"+Trim(cHistorico)
						Else
							aRet[li][09] := ALLTRIM(cHistorico)
						EndIf
						aRet[li][10] := dBaixa
						IF nVlr > 0
							aRet[li][11] := nVlr //Picture tm(nVlr,14,nDecs)
						Endif
					Endif
					nCT++
					aRet[li][12] := nJurMul    //PicTure tm(nJurMul,11,nDecs)
										
					If cCarteira == "R" .and. mv_par12 == SE1->E1_MOEDA					
					   aRet[li][13] := 0
					
					ElseIf cCarteira == "P" .and. mv_par12 == SE2->E2_MOEDA
					   aRet[li][13] := 0
					   
					Else					   
					   aRet[li][13] := nCM        //PicTure tm(nCM ,11,nDecs)
					   
					Endif

					//PCC Baixa CR
					//Somo aos abatimentos de impostos, os impostos PCC na baixa.
					//Caso o calculo do PCC CR seja pela emissao, esta variavel estara zerada
					nTotAbImp := nTotAbImp + nPccBxCr
					   
					aRet[li][14] := nDesc      //PicTure tm(nDesc,11,nDecs)
					aRet[li][15] := nAbatLiq  	//Picture tm(nAbatLiq,11,nDecs)
					aRet[li][16] := nTotAbImp 	//Picture tm(nTotAbImp,11,nDecs)
					If nVlMovFin > 0
						aRet[li][17] := nVlMovFin     //PicTure tm(nVlMovFin,15,nDecs)
					Else
						aRet[li][17] := nValor			//PicTure tm(nValor,15,nDecs)
					Endif
					aRet[li][18] := cBanco
					If Len(DtoC(dDigit)) <= 8
						aRet[li][19] := dDigit
					Else                   
						aRet[li][19] := dDigit
					EndIf
	
					If empty(cMotBaixa)
						cMotBaixa := "NOR"  //NORMAL
					Endif
	
					aRet[li][20] := Substr(cMotBaixa,1,3)
					aRet[li][21] := cFilorig
					
					aRet[li][26] := lOriginal
					aRet[li][27] := If( nVlMovFin <> 0, nVlMovFin , If(MovBcoBx(cMotBaixa),nValor,0))
					nTotOrig   += If(lOriginal,nVlr,0)
					nTotBaixado+= If(cTipodoc $ "CP/BA" .AND. cMotBaixa $ "CMP/FAT",0,nValor)		// n„o soma, j  somou no principal
					nTotDesc   += nDesc
					nTotJurMul += nJurMul
					nTotCM     += nCM
					nTotAbLiq  += nAbatLiq
					nTotImp    += nTotAbImp
					nTotValor  += If( nVlMovFin <> 0, nVlMovFin , If(MovBcoBx(cMotBaixa),nValor,0))
					nTotMovFin += nVlMovFin
					nTotComp   += If(cTipodoc == "CP",nValor,0)
					nTotFat    += If(cMotBaixa $ "FAT",nValor,0)
					nDesc := nJurMul := nValor := nCM := nAbat := nTotAbImp := nAbatLiq := nVlMovFin := 0
					nPccBxCr	:= 0		//PCC Baixa CR
					li++
				Endif
				dbSelectArea("NEWSE5")
			Enddo

			If (nOrdem == 1 .or. nOrdem == 6 .or. nOrdem == 8)
				cQuebra := DtoS(cAnterior)
			Else //nOrdem == 2 .or. nOrdem == 3 .or. nOrdem == 4 .or. nOrdem == 5 .or. nOrdem == 7
				cQuebra := cAnterior
			EndIf

			If (nTotValor+nDesc+nJurMul+nCM+nTotOrig+nTotMovFin+nTotComp+nTotFat)>0
				If nCT > 0
						If nTotBaixado > 0
							AAdd(aTotais,{cQuebra,STR0028,nTotBaixado})  //"Baixados"
						Endif	
						If nTotMovFin > 0
							AAdd(aTotais,{cQuebra,STR0031,nTotMovFin})  //"Mov Fin."
						Endif
						If nTotComp > 0
							AAdd(aTotais,{cQuebra,STR0037,nTotComp})  //"Compens."
						Endif
						If nTotFat > 0
							AAdd(aTotais,{cQuebra,STR0076,nTotFat})  //"Bx.Fatura"
						Endif						
				Endif
			Endif      
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Incrementa Totais Gerais ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nGerBaixado += nTotBaixado
			nGerMovFin	+= nTotMovFin
			nGerComp	+= nTotComp
			nGerFat		+= nTotFat

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Incrementa Totais Filial ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nFilOrig	+= nTotOrig
			nFilValor	+= nTotValor
			nFilDesc	+= nTotDesc
			nFilJurMul	+= nTotJurMul
			nFilCM		+= nTotCM
			nFilAbLiq	+= nTotAbLiq 
			nFilAbImp	+= nTotImp 		
			nFilBaixado += nTotBaixado
			nFilMovFin	+= nTotMovFin
			nFilComp	+= nTotComp 
			nFilFat     += nTotFat
		Enddo
	Endif	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimir TOTAL por filial somente quan-³
	//³ do houver mais do que 1 filial.        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if mv_par17 == 1 .and. SM0->(Reccount()) > 1
		If nFilBaixado > 0 
			AAdd( aTotais,{ IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ), STR0028, nFilBaixado } )  //"Baixados"
		Endif
		If nFilMovFin > 0
			AAdd( aTotais,{ IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ), STR0031, nFilMovFin } )  //"Mov Fin."
		Endif
		If nFilComp > 0
			AAdd( aTotais,{ IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ), STR0037, nFilComp } )  //"Compens."
		Endif
		If nFilFat > 0
			AAdd( aTotais,{ IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ), STR0076, nFilFat } )  //"Compens."
		Endif
		
		If Empty(xFilial("SE5")) .And. mv_par17 == 2
			Exit
		Endif	

		nFilOrig:=nFilJurMul:=nFilCM:=nFilDesc:=nFilAbLiq:=nFilAbImp:=nFilValor:=0
		nFilBaixado:=nFilMovFin:=nFilComp:=nFilFat:=0
	Endif
	dbSelectArea("SM0")
	cCodUlt := SM0->M0_CODIGO
	cFilUlt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	dbSkip()
Enddo

If nGerBaixado > 0
	AAdd(aTotais,{STR0075,STR0028,nGerBaixado})  //"Baixados"
Endif	
If nGerMovFin > 0
	AAdd(aTotais,{STR0075,STR0031,nGerMovFin})  //"Mov Fin."
Endif
If nGerComp > 0
	AAdd(aTotais,{STR0075,STR0037,nGerComp})  //"Compens."
EndIf                             
If nGerFat > 0
	AAdd(aTotais,{STR0075,STR0076,nGerFat})  //"Bx.Fatura"
EndIf                             

SM0->(dbgoto(nRecEmp))                                                                            
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
dbSelectArea("TRB")
dbCloseArea()
Ferase(cNomArq1+GetDBExtension())
dbSelectArea("NEWSE5")
dbCloseArea()
If cNomeArq # Nil
	Ferase(cNomeArq+OrdBagExt())
Endif
dbSelectArea("SE5")
dbSetOrder(1)

Return aRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FR190MovCan³ Autor ³ Marcelo Celi Marques ³ Data ³ 05.10.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se o registro selecionado pertente a um titulo    ³±± 
±±³          ³ cuja baixa foi cancelada, mas, que gerou mov bancario      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FR190MovCan(nIndexSE5,_SE5)								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nIndexSE5 - Filtro provisório criado no inicio da rotina	  ³±± 
±±³          ³ E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ    >>	  ³±± 
±±³          ³ +E5_TIPODOC+E5_SEQ                                   	  ³±±
±±³          ³ 															  ³±± 
±±³          ³ _SE5 - Nome da tabela temporária do SE5 gerada       	  ³±±
±±³          ³ no inicio da rotina										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINR190/FINR199											  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FR190MovCan(nIndexSE5,_SE5)
	Local lRet := .F.
	Local aAreaSE5 := (_SE5)->(GetArea())
	If Empty((_SE5)->E5_MOTBX)
		dbSelectArea("SE5")
		dbSetOrder(nIndexSE5)
		If dbSeek((_SE5)->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ+"EC"+E5_SEQ))
			lRet := .T.
		Endif
		dbSelectArea(_SE5)
		RestArea(aAreaSE5)
	Endif	
Return lRet

 /*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FR190ATSX1³ Autor ³ Alexandre Circenis     ³ Data ³ 30/07/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualiza o grupo de campos das perguntas Codigo de e Codigo³±± 
±±³          ³ até com o mesmo grupo campos do Codigo Cliente/Fornecedor  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FR190ATSX1               								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINR190       											  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function FR190ATSX1()
Local aSavArea := GetArea()
Local aSavAreaSXG := SXG->(GetArea())
Local aSavAreaSX1 := SX1->(GetArea())
Local cGrupo := Padr("FIN190", Len(SX1->X1_GRUPO))

SXG->(DbSeek('001'))

dbSelectArea("SX1")
dbSetOrder(1)

if dbSeek(cGrupo+"07") // Pergunta "Codigo de"
	// Verificar se terá que alterar o Grupo ou o tamanho
	if SX1->X1_GRPSXG <> '001' .or. SX1->X1_TAMANHO <> SXG->XG_SIZE
		RecLock("SX1",.F.)
		SX1->X1_GRPSXG := "001"
		SX1->X1_TAMANHO := SXG->XG_SIZE
		MsUnlock()
	endif
endif
	
if dbSeek(cGrupo+"08") // Pergunta "Codigo até"                   
	// Verificar se terá que alterar o Grupo ou o tamanho
	if SX1->X1_GRPSXG <> '001' .or. SX1->X1_TAMANHO <> SXG->XG_SIZE
		RecLock("SX1",.F.)
		SX1->X1_GRPSXG := "001"
		SX1->X1_TAMANHO := SXG->XG_SIZE
		MsUnlock()
	endif	
endif

RestArea(aSavAreaSXG)
RestArea(aSavAreaSX1)

RestArea(aSavArea)

Return