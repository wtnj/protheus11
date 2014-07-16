#INCLUDE "FINR150.CH"
#Include "PROTHEUS.Ch"

//#DEFINE QUEBR				1
#DEFINE FORNEC				2
#DEFINE TITUL				3
#DEFINE TIPO				4
#DEFINE NATUREZA			5
#DEFINE EMISSAO			6
#DEFINE VENCTO				7
#DEFINE VENCREA			8
#DEFINE VL_ORIG			9
#DEFINE VL_NOMINAL		10
#DEFINE VL_CORRIG			11
#DEFINE VL_VENCIDO		12
#DEFINE PORTADOR			13
#DEFINE VL_JUROS			14
#DEFINE ATRASO				15
#DEFINE HISTORICO			16
#DEFINE VL_SOMA			17

Static lFWCodFil := FindFunction("FWCodFil")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FIN150	³ Autor ³ Daniel Tadashi Batori ³ Data ³ 07.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Posi‡„o dos Titulos a Pagar					              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR150(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function NHFIN070()

Local oReport  
AjustaSX1()

If FindFunction("TRepInUse") .And. TRepInUse() .and. !IsBlind()
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	Return FINR150R3() // Executa versão anterior do fonte
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ReportDef³ Autor ³ Daniel Batori         ³ Data ³ 07.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Definicao do layout do Relatorio									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportDef(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()
Local oReport
Local oSection1
Local cPictTit
Local nTamVal, nTamCli, nTamQueb
Local cPerg := Padr("FIN150",Len(SX1->X1_GRUPO))
Local aOrdem := {STR0008,;	//"Por Numero"
				 STR0009,;	//"Por Natureza"
				 STR0010,;	//"Por Vencimento"
				 STR0011,;	//"Por Banco"
				 STR0012,;	//"Fornecedor"
				 STR0013,;	//"Por Emissao"
				 STR0014}	//"Por Cod.Fornec."

oReport := TReport():New("FINR150",STR0005,"FIN150",{|oReport| ReportPrint(oReport)},STR0001+STR0002)

oReport:SetLandScape(.T.)
oReport:SetTotalInLine(.F.)		//Imprime o total em linha

//Nao retire esta chamada. Verifique antes !!!
//Ela é necessaria para o correto funcionamento da pergunte 36 (Data Base)
PutDtBase()

dbSelectArea("SX1")


pergunte("FIN150",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01	  // do Numero 			  ³
//³ mv_par02	  // at‚ o Numero 		  ³
//³ mv_par03	  // do Prefixo			  ³
//³ mv_par04	  // at‚ o Prefixo		  ³
//³ mv_par05	  // da Natureza  	     ³
//³ mv_par06	  // at‚ a Natureza		  ³
//³ mv_par07	  // do Vencimento		  ³
//³ mv_par08	  // at‚ o Vencimento	  ³
//³ mv_par09	  // do Banco			     ³
//³ mv_par10	  // at‚ o Banco		     ³
//³ mv_par11	  // do Fornecedor		  ³
//³ mv_par12	  // at‚ o Fornecedor	  ³
//³ mv_par13	  // Da Emiss„o			  ³
//³ mv_par14	  // Ate a Emiss„o		  ³
//³ mv_par15	  // qual Moeda			  ³
//³ mv_par16	  // Imprime Provis¢rios  ³
//³ mv_par17	  // Reajuste pelo vencto ³
//³ mv_par18	  // Da data contabil	  ³
//³ mv_par19	  // Ate data contabil	  ³
//³ mv_par20	  // Imprime Rel anal/sint³
//³ mv_par21	  // Considera  Data Base?³
//³ mv_par22	  // Cons filiais abaixo ?³
//³ mv_par23	  // Filial de            ³
//³ mv_par24	  // Filial ate           ³
//³ mv_par25	  // Loja de              ³
//³ mv_par26	  // Loja ate             ³
//³ mv_par27 	  // Considera Adiantam.? ³
//³ mv_par28	  // Imprime Nome 		  ³
//³ mv_par29	  // Outras Moedas 		  ³
//³ mv_par30     // Imprimir os Tipos    ³
//³ mv_par31     // Nao Imprimir Tipos	  ³
//³ mv_par32     // Consid. Fluxo Caixa  ³
//³ mv_par33     // DataBase             ³
//³ mv_par34     // Tipo de Data p/Saldo ³
//³ mv_par35     // Quanto a taxa		  ³
//³ mv_par36     // Tit.Emissao Futura	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cPictTit := PesqPict("SE2","E2_VALOR")
If cPaisLoc == "CHI"
	cPictTit := SubStr(cPictTit,1,At(".",cPictTit)-1)
EndIf   

nTamVal	 := TamSX3("E2_VALOR")[1]
nTamCli	 := TamSX3("E2_FORNECE")[1] + TamSX3("E2_LOJA")[1] + 25
nTamTit	 := TamSX3("E2_PREFIXO")[1] + TamSX3("E2_NUM")[1] + TamSX3("E2_PARCELA")[1] + 8
nTamQueb := nTamCli + nTamTit + TamSX3("E2_TIPO")[1] + TamSX3("E2_NATUREZ")[1] + TamSX3("E2_EMISSAO")[1] +;
			TamSX3("E2_VENCTO")[1] + TamSX3("E2_VENCREA")[1] + 14
			
//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Secao 1  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport,STR0061,{"SE2","SA2"},aOrdem)

TRCell():New(oSection1,"FORNECEDOR"	,	  ,STR0038				,,nTamCli,.F.,)  		//"Codigo-Nome do Fornecedor"
TRCell():New(oSection1,"TITULO"		,	  ,STR0039+CRLF+STR0040	,,nTamTit,.F.,)  		//"Prf-Numero" + "Parcela"
TRCell():New(oSection1,"E2_TIPO"	,"SE2",STR0041				,,,.F.,)  				//"TP"
TRCell():New(oSection1,"E2_NATUREZ"	,"SE2",STR0042				,,TamSX3("E2_NATUREZ")[1] + 5,.F.,)  				//"Natureza"
TRCell():New(oSection1,"E2_EMISSAO"	,"SE2",STR0043+CRLF+STR0044	,,,.F.,) 				//"Data de" + "Emissao"
TRCell():New(oSection1,"E2_VENCTO"	,"SE2",STR0043+CRLF+STR0045	,,,.F.,)  				//"Vencto" + "Titulo"
TRCell():New(oSection1,"E2_VENCREA"	,"SE2",STR0045+CRLF+STR0047	,,,.F.,)  				//"Vencto" + "Real"
TRCell():New(oSection1,"VAL_ORIG"	,	  ,STR0048				,cPictTit,nTamVal+3,.F.,) //"Valor Original"
TRCell():New(oSection1,"VAL_NOMI"	,	  ,STR0049+CRLF+STR0050	,cPictTit,nTamVal+3,.F.,) //"Tit Vencidos" + "Valor Nominal"
TRCell():New(oSection1,"VAL_CORR"	,	  ,STR0049+CRLF+STR0051	,cPictTit,nTamVal+3,.F.,) //"Tit Vencidos" + "Valor Corrigido"
TRCell():New(oSection1,"VAL_VENC"	,	  ,STR0052+CRLF+STR0050	,cPictTit,nTamVal+3,.F.,) //"Titulos a Vencer" + "Valor Nominal"
TRCell():New(oSection1,"E2_PORTADO"	,"SE2",STR0053+CRLF+STR0054	,,,.F.,)  				//"Porta-" + "dor"
TRCell():New(oSection1,"JUROS"		,	  ,STR0055+CRLF+STR0056	,cPictTit,nTamVal+3,.F.,) //"Vlr.juros ou" + "permanencia"
TRCell():New(oSection1,"DIA_ATR"	,	  ,STR0057+CRLF+STR0058	,,4,.F.,)  				//"Dias" + "Atraso"
TRCell():New(oSection1,"E2_HIST"	,"SE2",IIf(cPaisloc =="MEX",STR0063,STR0059) ,,35,.F.,)  			//"Historico(Vencidos+Vencer)"
TRCell():New(oSection1,"VAL_SOMA"	,	  ,STR0060				,cPictTit,nTamVal+7,.F.,) 	//"(Vencidos+Vencer)"

oSection1:Cell("VAL_ORIG"):SetHeaderAlign("RIGHT")
oSection1:Cell("VAL_NOMI"):SetHeaderAlign("RIGHT")             
oSection1:Cell("VAL_CORR"):SetHeaderAlign("RIGHT")
oSection1:Cell("VAL_VENC"):SetHeaderAlign("RIGHT")
oSection1:Cell("JUROS")   :SetHeaderAlign("RIGHT")  
oSection1:Cell("VAL_SOMA"):SetHeaderAlign("RIGHT") 

oSection1:SetLineBreak(.f.)		//Quebra de linha automatica
Return oReport                                                                              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³Daniel Batori          ³ Data ³08.08.06	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(oReport)

Local oSection1	:=	oReport:Section(1) 
Local oSection2	:=	oReport:Section(2)
Local nOrdem 	:= oSection1:GetOrder()
Local oBreak
Local oBreak2

Local aDados[17]
Local cString :="SE2"
Local nRegEmp := SM0->(RecNo())
Local nRegSM0 := SM0->(Recno())
Local nAtuSM0 := SM0->(Recno())
Local dOldDtBase := dDataBase
Local dOldData := dDataBase
Local nJuros  :=0

Local nQualIndice := 0
Local lContinua := .T.
Local nTit0:=0,nTit1:=0,nTit2:=0,nTit3:=0,nTit4:=0,nTit5:=0
Local nTot0:=0,nTot1:=0,nTot2:=0,nTot3:=0,nTot4:=0,nTotTit:=0,nTotJ:=0,nTotJur:=0
Local nFil0:=0,nFil1:=0,nFil2:=0,nFil3:=0,nFil4:=0,nFilTit:=0,nFilJ:=0
Local cCond1,cCond2,cCarAnt,nSaldo:=0,nAtraso:=0
Local dDataReaj
Local dDataAnt := dDataBase , lQuebra
Local nMestit0:= nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
Local dDtContab
Local cIndexSe2
Local cChaveSe2
Local nIndexSE2
Local cFilDe,cFilAte
Local nTotsRec := SE2->(RecCount())
Local aTamFor := TAMSX3("E2_FORNECE")
Local nDecs := Msdecimais(mv_par15)
Local lFr150Flt := EXISTBLOCK("FR150FLT")
Local cFr150Flt := iif(lFr150Flt,ExecBlock("FR150FLT",.F.,.F.),"")
Local cMoeda := LTrim(Str(mv_par15))
Local cFilterUser
Local cFilUserSA2 := oSection1:GetADVPLExp("SA2")

Local cNomFor	:= ""
Local cNomNat	:= ""
Local cNomFil	:= ""
Local cNumBco	:= 0
Local nTotVenc	:= 0
Local nTotMes	:= 0
Local nTotGeral := 0
Local nTotTitMes:= 0
Local nTotFil	:= 0
Local dDtVenc
Local aFiliais	:= {}
Local lTemCont := .F.
Local cNomFilAnt := ""
Local cFilialSE2	:= ""
Local nInc := 0    
Local aSM0 := {}
Local cPictTit := ""
Local nGerTot := 0
Local nFilTot := 0
Local nAuxTotFil := 0

#IFDEF TOP
	Local nI := 0
	Local aStru := SE2->(dbStruct())
#ENDIF

Private dBaixa := dDataBase
Private cTitulo  := ""

cPictTit := PesqPict("SE2","E2_VALOR")
If cPaisLoc == "CHI"
	cPictTit := SubStr(cPictTit,1,At(".",cPictTit)-1)
EndIf   

//*******************************************************
// Solução para o problema no filtro de Serie minuscula *
//*******************************************************
//mv_par04 := LOWER(mv_par04)

oSection1:Cell("FORNECEDOR"	):SetBlock( { || aDados[FORNEC] 			})
oSection1:Cell("TITULO"		):SetBlock( { || aDados[TITUL] 				})
oSection1:Cell("E2_TIPO"	):SetBlock( { || aDados[TIPO] 					})
oSection1:Cell("E2_NATUREZ"	):SetBlock( { || MascNat(aDados[NATUREZA])})
oSection1:Cell("E2_EMISSAO"	):SetBlock( { || aDados[EMISSAO] 			})
oSection1:Cell("E2_VENCTO"	):SetBlock( { || aDados[VENCTO] 			})
oSection1:Cell("E2_VENCREA"	):SetBlock( { || aDados[VENCREA] 			})
oSection1:Cell("VAL_ORIG"	):SetBlock( { || aDados[VL_ORIG] 			})
oSection1:Cell("VAL_NOMI"	):SetBlock( { || aDados[VL_NOMINAL] 		})
oSection1:Cell("VAL_CORR"	):SetBlock( { || aDados[VL_CORRIG] 		})
oSection1:Cell("VAL_VENC"	):SetBlock( { || aDados[VL_VENCIDO] 		})
oSection1:Cell("E2_PORTADO"	):SetBlock( { || aDados[PORTADOR] 			})
oSection1:Cell("JUROS"		):SetBlock( { || aDados[VL_JUROS] 			})
oSection1:Cell("DIA_ATR"	):SetBlock( { || aDados[ATRASO] 				})
oSection1:Cell("E2_HIST"	):SetBlock( { || aDados[HISTORICO] 			})
oSection1:Cell("VAL_SOMA"	):SetBlock( { || aDados[VL_SOMA] 			})

oSection1:Cell("VAL_SOMA"):Disable()

TRPosition():New(oSection1,"SA2",1,{|| xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define as quebras da seção, conforme a ordem escolhida.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOrdem == 2	//Natureza
	oBreak := TRBreak():New(oSection1,{|| IIf(!MV_MULNATP,SE2->E2_NATUREZ,aDados[NATUREZA]) },{|| cNomNat })
ElseIf nOrdem == 3	.Or. nOrdem == 6	//Vencimento e por Emissao
	oBreak  := TRBreak():New(oSection1,{|| IIf(nOrdem == 3,SE2->E2_VENCREA,SE2->E2_EMISSAO) },{|| STR0026 + DtoC(dDtVenc) })	//"S U B - T O T A L ----> "
	oBreak2 := TRBreak():New(oSection1,{|| IIf(nOrdem == 3,Month(SE2->E2_VENCREA),Month(SE2->E2_EMISSAO)) },{|| STR0030 + "("+ALLTRIM(STR(nTotTitMes))+" "+IIF(nTotTitMes > 1,OemToAnsi(STR0028),OemToAnsi(STR0029))+")" })		//"T O T A L   D O  M E S ---> "
	If mv_par20 == 1	//1- Analitico  2-Sintetico
		TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("E2_HIST"),"","ONPRINT",oBreak2,,Iif(cPaisLoc == "CHI",cPictTit, PesqPict("SE2","E2_VALOR")),{|lSection,lReport| If(lReport, nTotGeral, nTotMes)},.F.,.F.)
	EndIf
ElseIf nOrdem == 4	//Banco
	oBreak := TRBreak():New(oSection1,{|| SE2->E2_PORTADO },{|| STR0026 + cNumBco })	//"S U B - T O T A L ----> "
ElseIf nOrdem == 5	//Fornecedor
	oBreak := TRBreak():New(oSection1,{|| SE2->(E2_FORNECE+E2_LOJA) },{|| cNomFor })
ElseIf nOrdem == 7	//Codigo Fornecedor
	oBreak := TRBreak():New(oSection1,{|| SE2->E2_FORNECE },{|| cNomFor })	
EndIf                                                                       


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprimir TOTAL por filial somente quando ³
//³ houver mais do que uma filial.	         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par22 == 1 .And. SM0->(Reccount()) > 1
	oBreak2 := TRBreak():New(oSection1,{|| SE2->E2_FILIAL },{|| STR0032+" "+cNomFil })	//"T O T A L   F I L I A L ----> " 
	If mv_par20 == 1	//1- Analitico  2-Sintetico
		TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBreak2,,,,.F.,.F.)
		//nTotGeral nao estava imprimindo corretamente o totalizador por isso foi necessario o ajuste abaixo
		//embora seja estranho mas neste caso foi necessario inicializar a variavel nFilTot:=0 no break 
		//por isso salvei o conteudo na variavel nAuxTotFil antes de inicializar e depois imprimo nAuxTotFil
		TRFunction():New(oSection1:Cell("E2_HIST"),"","ONPRINT",oBreak2,,Iif(cPaisLoc == "CHI",cPictTit, PesqPict("SE2","E2_VALOR")),{|lSection,lReport| If(lReport, ( nAuxTotFil:=nFilTot,nFilTot:=0,nAuxTotFil )/*nTotGeral*/, nTotFil)},.F.,.F.)
	EndIf
EndIf

If mv_par20 == 1	//1- Analitico  2-Sintetico
	//Altero o texto do Total Geral
	oReport:SetTotalText({|| STR0027 + "(" + ALLTRIM(STR(nTotTit))+" "+If(nTotTit > 1,STR0028,STR0029)+")" })
	TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBreak,,,,.F.,.T.)
	//nTotGeral nao estava imprimindo corretamente o totalizador por isso foi necessario o ajuste abaixo
	//portanto foi criado a variavel nGerTot que eh o acumulador geral da coluna
	TRFunction():New(oSection1:Cell("E2_HIST"),"","ONPRINT",oBreak,,Iif(cPaisLoc == "CHI",cPictTit, PesqPict("SE2","E2_VALOR")),{|lSection,lReport| If(lReport, nGerTot/*nTotGeral*/, nTotVenc)},.F.,.T.)
EndIf

#IFDEF TOP
	IF TcSrvType() == "AS/400" .and. Select("__SE2") == 0
		ChkFile("SE2",.f.,"__SE2")
	Endif
#ENDIF

dbSelectArea ( "SE2" )
Set Softseek On

If mv_par22 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
ELSE
	cFilDe := mv_par23
	cFilAte:= mv_par24
Endif

//Acerta a database de acordo com o parametro
If mv_par21 == 1    // Considera Data Base
	dDataBase := mv_par33
Endif	

dbSelectArea("SM0")

nRegSM0 := SM0->(Recno())
nAtuSM0 := SM0->(Recno())

//Caso nao preencha o mv_par15 um erro ocorre ao procurar o parametro do sistema MV_MOEDA0.
If Val(cMoeda) == 0
	cMoeda := "1"
Endif
            
// Cria vetor com os codigos das filiais da empresa corrente                     
aFiliais := FinRetFil()

oSection1:Init()      

aSM0	:= AdmAbreSM0()

For nInc := 1 To Len( aSM0 )
	
	If !Empty(cFilAte) .AND. aSM0[nInc][1] == cEmpAnt .AND. (aSM0[nInc][2] >= cFilDe .and. aSM0[nInc][2] <= cFilAte)

		cTitulo := oReport:title() + " " + STR0035 + GetMv("MV_MOEDA"+cMoeda)  //"Posicao dos Titulos a Pagar" + " em "
	
		dbSelectArea("SE2")
		cFilAnt := aSM0[nInc][2] 
		
		IF cFilialSE2 == xFilial("SE2")
			Loop
		ELSE
			cFilialSE2 := xFilial("SE2")
		ENDIF
			
		#IFDEF TOP
			cFilterUser := oSection1:GetSqlExp("SE2")
			if TcSrvType() != "AS/400"
				cQuery := "SELECT * "
				cQuery += "  FROM "+	RetSqlName("SE2")
				cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'"
				cQuery += "   AND D_E_L_E_T_ = ' ' " 
				If !empty(cFilterUser)
				  	cQuery += " AND ( "+cFilterUser + " ) "
				Endif
			endif
		#ENDIF
	
		IF nOrdem == 1
			SE2->(dbSetOrder(1))
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					dbSeek(xFilial("SE2")+mv_par03+mv_par01,.T.)
				else
					cOrder := SqlOrder(indexkey())
				endif
			#ELSE
				dbSeek(xFilial("SE2")+mv_par03+mv_par01,.T.)
			#ENDIF
			cCond1 := "SE2->E2_PREFIXO <= mv_par04"
			cCond2 := "SE2->E2_PREFIXO"
			cTitulo += OemToAnsi(STR0016)  //" - Por Numero"
			nQualIndice := 1
		Elseif nOrdem == 2
			SE2->(dbSetOrder(2))
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					dbSeek(xFilial("SE2")+mv_par05,.T.)
				else
					cOrder := SqlOrder(indexkey())
				endif
			#ELSE
				dbSeek(xFilial("SE2")+mv_par05,.T.)
			#ENDIF
			cCond1 := "SE2->E2_NATUREZ <= mv_par06"
			cCond2 := "SE2->E2_NATUREZ"
			cTitulo += STR0017  //" - Por Natureza"
			nQualIndice := 2
		Elseif nOrdem == 3
			SE2->(dbSetOrder(3))
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					dbSeek(xFilial("SE2")+Dtos(mv_par07),.T.)
				else
					cOrder := SqlOrder(indexkey())
				endif
			#ELSE
				dbSeek(xFilial("SE2")+Dtos(mv_par07),.T.)
			#ENDIF
			cCond1 := "SE2->E2_VENCREA <= mv_par08"
			cCond2 := "SE2->E2_VENCREA"
			cTitulo += STR0018  //" - Por Vencimento"
			nQualIndice := 3
		Elseif nOrdem == 4
			SE2->(dbSetOrder(4))
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					dbSeek(xFilial("SE2")+mv_par09,.T.)
				else
					cOrder := SqlOrder(indexkey())
				endif
			#ELSE
				dbSeek(xFilial("SE2")+mv_par09,.T.)
			#ENDIF
			cCond1 := "SE2->E2_PORTADO <= mv_par10"
			cCond2 := "SE2->E2_PORTADO"
			cTitulo += OemToAnsi(STR0031)  //" - Por Banco"
			nQualIndice := 4
		Elseif nOrdem == 6
			SE2->(dbSetOrder(5))
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					dbSeek(xFilial("SE2")+DTOS(mv_par13),.T.)
				else
					cOrder := SqlOrder(indexkey())
				endif
			#ELSE
				dbSeek(xFilial("SE2")+DTOS(mv_par13),.T.)
			#ENDIF
			cCond1 := "SE2->E2_EMISSAO <= mv_par14"
			cCond2 := "SE2->E2_EMISSAO"
			cTitulo += STR0019 //" - Por Emissao"
			nQualIndice := 5
		Elseif nOrdem == 7
			SE2->(dbSetOrder(6))
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					dbSeek(xFilial("SE2")+mv_par11,.T.)
				else
					cOrder := SqlOrder(indexkey())
				endif
			#ELSE
				dbSeek(xFilial("SE2")+mv_par11,.T.)
			#ENDIF			
			cCond1 := "SE2->E2_FORNECE <= mv_par12"
			cCond2 := "SE2->E2_FORNECE"
			cTitulo += STR0020 //" - Por Cod.Fornecedor"
			nQualIndice := 6
		Else
			cChaveSe2 := "E2_FILIAL+E2_NOMFOR+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					cIndexSe2 := CriaTrab(nil,.f.)
					IndRegua("SE2",cIndexSe2,cChaveSe2,,Fr150IndR(),OemToAnsi(STR0021))  // //"Selecionando Registros..."
					nIndexSE2 := RetIndex("SE2")
					dbSetOrder(nIndexSe2+1)
					dbSeek(xFilial("SE2"))
				else
					cOrder := SqlOrder(cChaveSe2)
				endif
			#ELSE
				cIndexSe2 := CriaTrab(nil,.f.)
				IndRegua("SE2",cIndexSe2,cChaveSe2,,Fr150IndR(),OemToAnsi(STR0021))  // //"Selecionando Registros..."
				nIndexSE2 := RetIndex("SE2")
				dbSetIndex(cIndexSe2+OrdBagExt())
				dbSetOrder(nIndexSe2+1)
				dbSeek(xFilial("SE2"))
			#ENDIF
			cCond1 := "SE2->E2_FORNECE <= mv_par12"
			cCond2 := "SE2->E2_FORNECE+SE2->E2_LOJA"
			cTitulo += STR0022 //" - Por Fornecedor"
			nQualIndice := IndexOrd()
		EndIF
	
		If mv_par20 == 1	//1- Analitico  2-Sintetico	
			cTitulo += STR0023  //" - Analitico"
		Else
			cTitulo += STR0024  // " - Sintetico"
		EndIf
	
		oReport:SetTitle(cTitulo)
		
		dbSelectArea("SE2")
	
		Set Softseek Off
	
		#IFDEF TOP
			if TcSrvType() != "AS/400"
				cQuery += " AND E2_NUM     BETWEEN '"+ mv_par01+ "' AND '"+ mv_par02 + "'"
				cQuery += " AND E2_PREFIXO BETWEEN '"+ mv_par03+ "' AND '"+ mv_par04 + "'"
				cQuery += " AND (E2_MULTNAT = '1' OR (E2_NATUREZ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'))"
				cQuery += " AND E2_VENCREA BETWEEN '"+ DTOS(mv_par07)+ "' AND '"+ DTOS(mv_par08) + "'"
				cQuery += " AND E2_PORTADO BETWEEN '"+ mv_par09+ "' AND '"+ mv_par10 + "'"
				cQuery += " AND E2_FORNECE BETWEEN '"+ mv_par11+ "' AND '"+ mv_par12 + "'"
				cQuery += " AND E2_EMISSAO BETWEEN '"+ DTOS(mv_par13)+ "' AND '"+ DTOS(mv_par14) + "'"
				cQuery += " AND E2_LOJA    BETWEEN '"+ mv_par25 + "' AND '"+ mv_par26 + "'"
	
				//Considerar titulos cuja emissao seja maior que a database do sistema
				If mv_par36 == 2
					cQuery += " AND E2_EMISSAO <= '" + DTOS(dDataBase) +"'"
				Endif
		
				If !Empty(mv_par30) // Deseja imprimir apenas os tipos do parametro 30
					cQuery += " AND E2_TIPO IN "+FormatIn(mv_par30,";") 
				ElseIf !Empty(Mv_par31) // Deseja excluir os tipos do parametro 31
					cQuery += " AND E2_TIPO NOT IN "+FormatIn(mv_par31,";")
				EndIf
				If mv_par32 == 1
					cQuery += " AND E2_FLUXO <> 'N'"
				Endif
				
				cQuery += " AND E2_TIPO NOT IN "+FormatIn(MVABATIM,";")
				
				If mv_par16 == 2
					cQuery += " AND E2_TIPO NOT IN "+FormatIn(MVPROVIS,";")			
				Endif
				
				If mv_par27 == 2
					cQuery += " AND E2_TIPO NOT IN "+FormatIn(MVPAGANT,";")			 
					cQuery += " AND E2_TIPO NOT IN "+FormatIn(MV_CPNEG,";")			
				Endif							
	
				cQuery += " ORDER BY "+ cOrder
	
				cQuery := ChangeQuery(cQuery)
	
				dbSelectArea("SE2")
				dbCloseArea()
				dbSelectArea("SA2")
	
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE2', .F., .T.)
	
				For ni := 1 to Len(aStru)
					If aStru[ni,2] != 'C'
						TCSetField('SE2', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
					Endif
				Next
			endif
		#ELSE
			cFilterUser := oSection1:GetADVPLExp("SE2")
			
			If !Empty(cFilterUser)
				oSection1:SetFilter(cFilterUser)
			Endif	
		#ENDIF
		
		oReport:SetMeter(nTotsRec)
	
		If MV_MULNATP .And. nOrdem == 2
			Finr155(cFr150Flt, .F., @nTot0, @nTot1, @nTot2, @nTot3, @nTotTit, @nTotJ, oReport, aDados, @cNomNat, @nTotVenc, @nTotGeral)
			#IFDEF TOP
				if TcSrvType() != "AS/400"
					dbSelectArea("SE2")
					dbCloseArea()
					ChKFile("SE2")
					dbSetOrder(1)
				endif
			#ENDIF
			If Empty(xFilial("SE2"))
				Exit
			Endif
			Loop
		Endif  
		
		While &cCond1 .and. !Eof() .and. lContinua .and. SE2->E2_FILIAL == xFilial("SE2")
		
			oReport:IncMeter()
	
			dbSelectArea("SE2")
	
			Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5
	
			If nOrdem == 3 .And. Str(Month(SE2->E2_VENCREA)) <> Str(Month(dDataAnt))
				nMesTTit := 0
			Elseif nOrdem == 6 .And. Str(Month(SE2->E2_EMISSAO)) <> Str(Month(dDataAnt))
				nMesTTit := 0
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega data do registro para permitir ³
			//³ posterior analise de quebra por mes.   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dDataAnt := Iif(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)
	
			cCarAnt := &cCond2
	        
			lTemCont := .F.
//			Store 0 To nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ
			While &cCond2 == cCarAnt .and. !Eof() .and. lContinua .and. SE2->E2_FILIAL == xFilial("SE2")
				
				oReport:IncMeter()
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Filtro de usuário pela tabela SA2.					 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SA2")
				MsSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
				If !Empty(cFilUserSA2).And.!SA2->(&cFilUserSA2)
					SE2->(dbSkip())
					Loop
				Endif
				
				dbSelectArea("SE2")
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Considera filtro do usuario no ponto de entrada.             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lFr150flt
					If &cFr150flt
						DbSkip()
						Loop
					Endif
				Endif					
				
				#IFNDEF TOP			
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se trata-se de abatimento ou provisorio, ou ³
				//³ Somente titulos emitidos ate a data base				   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF SE2->E2_TIPO $ MVABATIM .Or. (SE2 -> E2_EMISSAO > dDataBase .and. mv_par36 == 2)
					dbSkip()
					Loop
				EndIF
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se ser  impresso titulos provis¢rios		   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF E2_TIPO $ MVPROVIS .and. mv_par16 == 2
					dbSkip()
					Loop
				EndIF
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se ser  impresso titulos de Adiantamento	 	³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. mv_par27 == 2
					dbSkip()
					Loop
				EndIF
	                                   
	            #ENDIF
	            
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se deve imprimir outras moedas³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If mv_par29 == 2 // nao imprime
					if SE2->E2_MOEDA != mv_par15 //verifica moeda do campo=moeda parametro
						dbSkip()
						Loop
					endif	
				Endif  
	
				// dDtContab para casos em que o campo E2_EMIS1 esteja vazio
				// compatibilizando com a vers„o 2.04 que n„o gerava para titulos
				// de ISS e FunRural
	
				dDtContab := Iif(Empty(SE2->E2_EMIS1),SE2->E2_EMISSAO,SE2->E2_EMIS1)
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se esta dentro dos parametros ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF E2_NUM < mv_par01      .OR. E2_NUM > mv_par02 .OR. ;
						E2_PREFIXO < mv_par03  .OR. E2_PREFIXO > mv_par04 .OR. ;
						E2_NATUREZ < mv_par05  .OR. E2_NATUREZ > mv_par06 .OR. ;
						E2_VENCREA < mv_par07  .OR. E2_VENCREA > mv_par08 .OR. ;
						E2_PORTADO < mv_par09  .OR. E2_PORTADO > mv_par10 .OR. ;
						E2_FORNECE < mv_par11  .OR. E2_FORNECE > mv_par12 .OR. ;
						E2_EMISSAO < mv_par13  .OR. E2_EMISSAO > mv_par14 .OR. ;
						(E2_EMISSAO > dDataBase .and. mv_par36 == 2) .OR. dDtContab  < mv_par18 .OR. ;
						E2_LOJA    < mv_par25  .OR. E2_LOJA    > mv_par26 .OR. ;
						dDtContab  > mv_par19  .Or. !&(fr150IndR())
	
					dbSkip()
					Loop
				Endif  
				
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se esta dentro do parametro compor pela data de digitação ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF mv_par34 == 2 .And. !Empty(E2_EMIS1) .And. !Empty(mv_par33)
					If E2_EMIS1 > mv_par33
						dbSkip()
						Loop
					Endif			
				Endif
							
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se titulo, apesar do E2_SALDO = 0, deve aparecer ou ³
				//³ nÆo no relat¢rio quando se considera database (mv_par21 = 1) ³
				//³ ou caso nÆo se considere a database, se o titulo foi totalmen³
				//³ te baixado.																  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SE2")
				IF !Empty(SE2->E2_BAIXA) .and. Iif(mv_par21 == 2 ,SE2->E2_SALDO == 0 ,SE2->E2_SALDO == 0 .and. SE2->E2_BAIXA <= dDataBase)						

					dbSkip()
					Loop
				EndIF
	            
				 // Tratamento da correcao monetaria para a Argentina
				If  cPaisLoc=="ARG" .And. mv_par15 <> 1  .And.  SE2->E2_CONVERT=='N'
					dbSkip()
					Loop
				Endif
	
				
				dbSelectArea("SA2")
				MSSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
				dbSelectArea("SE2")
	
				// Verifica se existe a taxa na data do vencimento do titulo, se nao existir, utiliza a taxa da database
				If SE2->E2_VENCREA < dDataBase
					If mv_par17 == 2 .And. RecMoeda(SE2->E2_VENCREA,cMoeda) > 0
						dDataReaj := SE2->E2_VENCREA
					Else
						dDataReaj := dDataBase
					EndIf	
				Else
					dDataReaj := dDataBase
				EndIf       
	
				If mv_par21 == 1
					nSaldo := SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,mv_par15,dDataReaj,,SE2->E2_LOJA,,If(mv_par35==1,SE2->E2_TXMOEDA,Nil),IIF(mv_par34 == 2,3,1)) // 1 = DT BAIXA    3 = DT DIGIT
					//Verifica se existem compensações em outras filiais para descontar do saldo, pois a SaldoTit() somente
					//verifica as movimentações da filial corrente. Nao deve processar quando existe somente uma filial.
					If !Empty(xFilial("SE2")) .And. !Empty(xFilial("SE5")) .And. Len(aFiliais) > 1
						nSaldo -= Round(NoRound(xMoeda(FRVlCompFil("P",SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,IIF(mv_par34 == 2,3,1),aFiliais);
										,SE2->E2_MOEDA,mv_par15,dDataReaj,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil)),nDecs+1),nDecs)
					EndIf
					// Subtrai decrescimo para recompor o saldo na data escolhida.
					If Str(SE2->E2_VALOR,17,2) == Str(nSaldo,17,2) .And. SE2->E2_DECRESC > 0 .And. SE2->E2_SDDECRE == 0
						nSAldo -= SE2->E2_DECRESC
					Endif
					// Soma Acrescimo para recompor o saldo na data escolhida.
					If Str(SE2->E2_VALOR,17,2) == Str(nSaldo,17,2) .And. SE2->E2_ACRESC > 0 .And. SE2->E2_SDACRES == 0
						nSAldo += SE2->E2_ACRESC
					Endif
				Else
					nSaldo := xMoeda((SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE),SE2->E2_MOEDA,mv_par15,dDataReaj,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
				Endif
				If ! (SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG) .And. ;
				   ! ( MV_PAR21 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
	
					//Quando considerar Titulos com emissao futura, eh necessario
					//colocar-se a database para o futuro de forma que a Somaabat()
					//considere os titulos de abatimento
					If mv_par36 == 1
						dOldData := dDataBase
						dDataBase := CTOD("31/12/40")
					Endif
	
					nSaldo-=SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",mv_par15,dDataReaj,SE2->E2_FORNECE,SE2->E2_LOJA)
	
					If mv_par36 == 1
						dDataBase := dOldData
					Endif
				EndIf
	
				nSaldo:=Round(NoRound(nSaldo,3),2)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Desconsidera caso saldo seja menor ou igual a zero   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nSaldo <= 0
					dbSkip()
					Loop
				Endif  
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Desconsidera os titulos de acordo com o parametro 
				//	considera filial e a tabela SE2 estiver compartilhada³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
				If MV_PAR22 == 1 .and. Empty(xFilial("SE2"))
					If !(SE2->E2_FILORIG >= mv_par23 .and. SE2->E2_FILORIG <= mv_par24) 
						dbSkip()
						Loop
					Endif			
				Endif 
	
				aDados[FORNEC] := SE2->E2_FORNECE+"-"+SE2->E2_LOJA+"-"+If(mv_par28 == 1, SA2->A2_NREDUZ, SA2->A2_NOME)
				aDados[TITUL]		:= SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA
				aDados[TIPO]		:= SE2->E2_TIPO
				aDados[NATUREZA]	:= SE2->E2_NATUREZ
				aDados[EMISSAO]	:= SE2->E2_EMISSAO
				aDados[VENCTO]		:= SE2->E2_VENCTO
				aDados[VENCREA]	:= SE2->E2_VENCREA
				aDados[VL_ORIG]	:= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil)) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) 
	
				#IFDEF TOP
					If TcSrvType() == "AS/400"
						dbSetOrder( nQualIndice )
					Endif
				#ELSE
					dbSetOrder( nQualIndice )
				#ENDIF
	
				If dDataBase > SE2->E2_VENCREA 		//vencidos
					aDados[VL_NOMINAL] := nSaldo * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) 
					nJuros := 0
					dBaixa := dDataBase
					nJuros := fa080Juros(mv_par15)
					dbSelectArea("SE2")
					aDados[VL_CORRIG] := (nSaldo+nJuros) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1)
					If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
						nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nTit1 -= nSaldo
						nTit2 -= nSaldo+nJuros
						nMesTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nMesTit1 -= nSaldo
						nMesTit2 -= nSaldo+nJuros
					Else
						nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nTit1 += nSaldo
						nTit2 += nSaldo+nJuros
						nMesTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nMesTit1 += nSaldo
						nMesTit2 += nSaldo+nJuros
					Endif
					nTotJur += (nJuros)
					nMesTitJ += (nJuros)
				Else				  //a vencer
					aDados[VL_VENCIDO] := nSaldo  * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) 
					If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
						nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nTit3 -= nSaldo
						nTit4 -= nSaldo
						nMesTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nMesTit3 -= nSaldo
						nMesTit4 -= nSaldo
					Else
						nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nTit3 += nSaldo
						nTit4 += nSaldo
						nMesTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nMesTit3 += nSaldo
						nMesTit4 += nSaldo
					Endif
				Endif
	
				ADados[PORTADOR] := SE2->E2_PORTADO
	
				If nJuros > 0
					aDados[VL_JUROS] := nJuros
					nJuros := 0
				Endif
	
				IF dDataBase > E2_VENCREA
					nAtraso:=dDataBase-E2_VENCTO
					IF Dow(E2_VENCTO) == 1 .Or. Dow(E2_VENCTO) == 7
						IF Dow(dBaixa) == 2 .and. nAtraso <= 2
							nAtraso:=0
						EndIF
					EndIF
					nAtraso := If(nAtraso<0,0,nAtraso)
					IF nAtraso>0
						aDados[ATRASO] := nAtraso
					EndIF
				EndIF
				If mv_par20 == 1	//1- Analitico  2-Sintetico
					aDados[HISTORICO] := SUBSTR(SE2->E2_HIST,1,24)+If(E2_TIPO $ MVPROVIS,"*"," ")
					oSection1:PrintLine()
					aFill(aDados,nil)
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Carrega data do registro para permitir ³
				//³ posterior analise de quebra por mes.	 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dDataAnt := Iif(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)
	
				If nOrdem == 5		//Forncedor
					cNomFor := If(mv_par28 == 1,AllTrim(SA2->A2_NREDUZ),AllTrim(SA2->A2_NOME))+" "+Substr(SA2->A2_TEL,1,15)
	            ElseIf nOrdem == 7	//Codigo Fornecedor
					cNomFor :=	SA2->A2_COD+" "+SA2->A2_LOJA+" "+AllTrim(SA2->A2_NOME)+" "+Substr(SA2->A2_TEL,1,15)
				EndIf
				
				If nOrdem == 2		//Natureza
					dbSelectArea("SED")
					dbSetOrder(1)
					dbSeek(xFilial("SED")+SE2->E2_NATUREZ)
					cNomNat	:= MascNat(SED->ED_CODIGO)+" "+SED->ED_DESCRIC
				EndIf
				
				cNumBco	 := SE2->E2_PORTADO
				dDtVenc  := IIf(nOrdem == 3,SE2->E2_VENCREA,SE2->E2_EMISSAO)
				nTotVenc := nTit2+nTit3
				nTotMes	 := nMesTit2+nMesTit3
	
				SE2->(dbSkip())
	
				nTotTit ++
				nMesTTit ++
				nFiltit++
				nTit5 ++
			EndDo
	
			If nTit5 > 0 .and. nOrdem != 1 .And. mv_par20 == 2	//1- Analitico  2-Sintetico	
				SubT150R(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,oReport,oSection1)
			EndIF
					
		   	nTotGeral  := nTotMes 
			nTotTitMes := nMesTTit
			nGerTot  += nTit2+nTit3
			nFilTot  += nTit2+nTit3
	
			If mv_par20 == 2	//1- Analitico  2-Sintetico	
				lQuebra := .F.
				If nOrdem == 3 .and. Month(SE2->E2_VENCREA) # Month(dDataAnt)
					lQuebra := .T.
				Elseif nOrdem == 6 .and. Month(SE2->E2_EMISSAO) # Month(dDataAnt)
					lQuebra := .T.
				Endif
				If lQuebra .And. nMesTTit # 0
					oReport:SkipLine()
					IMes150R(nMesTit0,nMesTit1,nMesTit2,nMesTit3,nMesTit4,nMesTTit,nMesTitJ,nTotTitMes,oReport,oSection1)
					oReport:SkipLine()
					nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
				Endif
			EndIf
					
			dbSelectArea("SE2")
	
			nTot0 += nTit0
			nTot1 += nTit1
			nTot2 += nTit2
			nTot3 += nTit3
			nTot4 += nTit4
			nTotJ += nTotJur
	
			nFil0 += nTit0
			nFil1 += nTit1
			nFil2 += nTit2
			nFil3 += nTit3
			nFil4 += nTit4
			nFilJ += nTotJur
			Store 0 To nTit0,nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur
			
			cNomFil 	:= cFilAnt + " - " + AllTrim(aSM0[nInc][7])
		Enddo					
	        
		nTotMes 	:= nTotVenc
		nTotFil 	:= nFil2 + nFil3

		If mv_par20 == 2	//1- Analitico  2-Sintetico	
			if mv_par22 == 1 .and. Len(aSM0) > 1 
				oReport:SkipLine()
				IFil150R(nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilj,oReport,oSection1,aSM0[nInc][7])
				Store 0 To nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ
				oReport:SkipLine()			
			Endif	
		EndIf
		
		Store 0 To nFil0,nFil1,nFil2,nFil3,nFil4,nFilJ,nTotJur

		dbSelectArea("SE2")		// voltar para alias existente, se nao, nao funciona
		If Empty(xFilial("SE2"))
			Exit
		Endif
		#IFDEF TOP
			if TcSrvType() != "AS/400"
				dbSelectArea("SE2")
				dbCloseArea()
				ChKFile("SE2")
				dbSetOrder(1)
			endif
		#ENDIF
	
	EndIf
	
Next

SM0->(dbGoTo(nRegSM0))
cFilAnt := SM0->M0_CODFIL 

If mv_par20 == 2	//1- Analitico  2-Sintetico	
	ImpT150R(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nTotTit,oReport,oSection1)
EndIf

oSection1:Finish()

#IFNDEF TOP
	dbSelectArea( "SE2" )
	dbClearFil()
	RetIndex( "SE2" )
	If !Empty(cIndexSE2)
		FErase (cIndexSE2+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	if TcSrvType() != "AS/400"
		dbSelectArea("SE2")
		dbCloseArea()
		ChKFile("SE2")
		dbSetOrder(1)
	else
		dbSelectArea( "SE2" )
		dbClearFil()
		RetIndex( "SE2" )
		If !Empty(cIndexSE2)
			FErase (cIndexSE2+OrdBagExt())
		Endif
		dbSetOrder(1)
	endif
#ENDIF	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura empresa / filial original    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SM0->(dbGoto(nRegEmp))
cFilAnt := SM0->M0_CODFIL

//Acerta a database de acordo com a database real do sistema
If mv_par21 == 1    // Considera Data Base
	dDataBase := dOldDtBase
Endif	

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SubT150R  ³ Autor ³ Wagner Xavier 		  ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR SUBTOTAL DO RELATORIO 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ SubT150R()  															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SubT150R(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,oReport,oSection1)

Local cQuebra := ""

If nOrdem == 1 .Or. nOrdem == 3 .Or. nOrdem == 6
	cQuebra := STR0026 + DtoC(cCarAnt) //"S U B - T O T A L ----> "
ElseIf nOrdem == 2
	dbSelectArea("SED")
	dbSeek(xFilial("SED")+cCarAnt)
	cQuebra := cCarAnt +" "+SED->ED_DESCRIC
ElseIf nOrdem == 4
	cQuebra := STR0026 + cCarAnt //"S U B - T O T A L ----> "
Elseif nOrdem == 5
	cQuebra := If(mv_par28 == 1,SA2->A2_NREDUZ,SA2->A2_NOME)+" "+Substr(SA2->A2_TEL,1,15)
ElseIf nOrdem == 7
	cQuebra := SA2->A2_COD+" "+SA2->A2_LOJA+" "+SA2->A2_NOME+" "+Substr(SA2->A2_TEL,1,15)
Endif

HabiCel(oReport)

oSection1:Cell("FORNECEDOR"):SetBlock({|| cQuebra })
oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nTit1   })
oSection1:Cell("VAL_CORR"  ):SetBlock({|| nTit2   })
oSection1:Cell("VAL_VENC"  ):SetBlock({|| nTit3   })
oSection1:Cell("JUROS"     ):SetBlock({|| nTotJur })
oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nTit2+nTit3 })

oSection1:PrintLine()

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ImpT150R  ³ Autor ³ Wagner Xavier 		  ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR TOTAL DO RELATORIO 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpT150R()	 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function ImpT150R(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nTotTit,oReport,oSection1)

HabiCel(oReport)

oSection1:Cell("FORNECEDOR"):SetBlock({|| STR0027 + "(" + ALLTRIM(STR(nTotTit))+" "+If(nTotTit > 1,STR0028,STR0029)+")" })
oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nTot1 })
oSection1:Cell("VAL_CORR"  ):SetBlock({|| nTot2 })
oSection1:Cell("VAL_VENC"  ):SetBlock({|| nTot3 })
oSection1:Cell("JUROS"     ):SetBlock({|| nTotJ })
oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nTot2+nTot3 })

oSection1:PrintLine()

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³IMes150R  ³ Autor ³ Vinicius Barreira	  ³ Data ³ 12.12.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR TOTAL DO RELATORIO - QUEBRA POR MES					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ IMes150R()  															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function IMes150R(nMesTit0,nMesTit1,nMesTit2,nMesTit3,nMesTit4,nMesTTit,nMesTitJ,nTotTitMes,oReport,oSection1)

HabiCel(oReport)

oSection1:Cell("FORNECEDOR"):SetBlock({|| STR0030 + "("+ALLTRIM(STR(nTotTitMes))+" "+IIF(nTotTitMes > 1,OemToAnsi(STR0028),OemToAnsi(STR0029))+")" })
oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nMesTit1 })
oSection1:Cell("VAL_CORR"  ):SetBlock({|| nMesTit2 })
oSection1:Cell("VAL_VENC"  ):SetBlock({|| nMesTit3 })
oSection1:Cell("JUROS"     ):SetBlock({|| nMesTitJ })
oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nMesTit2+nMesTit3 })

oSection1:PrintLine()

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ IFil150R	³ Autor ³ Paulo Boschetti 	     ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprimir total do relatorio										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ IFil150R()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³																				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico				   									 			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function IFil150R(nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ,oReport,oSection1,cFilSM0)

HabiCel(oReport)

oSection1:Cell("FORNECEDOR"):SetBlock({|| STR0032 + " " + cFilAnt + " - " + AllTrim(cFilSM0) })	//"T O T A L   F I L I A L ----> " 
oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nFil1 })
oSection1:Cell("VAL_CORR"  ):SetBlock({|| nFil2 })
oSection1:Cell("VAL_VENC"  ):SetBlock({|| nFil3 })
oSection1:Cell("JUROS"     ):SetBlock({|| nFilJ })
oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nFil2+nFil3 })

oSection1:PrintLine()

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³HabiCel	³ Autor ³ Daniel Tadashi Batori ³ Data ³ 04/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³habilita ou desabilita celulas para imprimir totais		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ HabiCel()	 											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±³			 ³ oReport ->objeto TReport que possui as celulas 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function HabiCel(oReport)

Local oSection1 := oReport:Section(1)

oSection1:Cell("FORNECEDOR"):SetSize(50)
oSection1:Cell("TITULO"    ):Disable()
oSection1:Cell("E2_TIPO"   ):Hide()
oSection1:Cell("E2_NATUREZ"):Hide()
oSection1:Cell("E2_EMISSAO"):Hide()
oSection1:Cell("E2_VENCTO" ):Hide()
oSection1:Cell("E2_VENCREA"):Hide()
oSection1:Cell("VAL_ORIG"  ):Hide()
oSection1:Cell("E2_PORTADO"):Hide()
oSection1:Cell("DIA_ATR"   ):Hide()
oSection1:Cell("E2_HIST"   ):Disable()
oSection1:Cell("VAL_SOMA"  ):Enable()

oSection1:Cell("FORNECEDOR"):HideHeader()
oSection1:Cell("E2_TIPO"   ):HideHeader()
oSection1:Cell("E2_NATUREZ"):HideHeader()
oSection1:Cell("E2_EMISSAO"):HideHeader()
oSection1:Cell("E2_VENCTO" ):HideHeader()
oSection1:Cell("E2_VENCREA"):HideHeader()
oSection1:Cell("VAL_ORIG"  ):HideHeader()
oSection1:Cell("E2_PORTADO"):HideHeader()
oSection1:Cell("DIA_ATR"   ):HideHeader()	

Return(.T.)



/*
---------------------------------------------------------- RELEASE 3 ---------------------------------------------
*/



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FINR150R3³ Autor ³ Wagner Xavier   	     ³ Data ³ 02.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Posi‡„o dos Titulos a Pagar										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR150R3(void)														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parƒmetros³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FinR150R3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1 :=OemToAnsi(STR0001)  //"Imprime a posi‡„o dos titulos a pagar relativo a data base"
Local cDesc2 :=OemToAnsi(STR0002)  //"do sistema."
LOCAL cDesc3 :=""
LOCAL cString:="SE2"
LOCAL nRegEmp := SM0->(RecNo())
Local dOldDtBase := dDataBase
Local dOldData := dDataBase
Local wnrel
Local nTamPar01,nTamPar02,nTamPar03,nTamPar04,nTamPar05,nTamPar06,nTamPar09,nTamPar10,nTamPar11,nTamPar12,nTamPar23,nTamPar24,nTamPar25,nTamPar26,nTamPar30,nTamPar31
Local i

PRIVATE cPerg    := Padr("FIN150",Len(SX1->X1_GRUPO))
PRIVATE aReturn := { OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="FINR150"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE nJuros  :=0
PRIVATE tamanho:="G"

PRIVATE titulo  := ""
PRIVATE cabec1
PRIVATE cabec2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabe‡alhos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := OemToAnsi(STR0005)  //"Posicao dos Titulos a Pagar"
cabec1 := IIf(cPaisloc =="MEX",OemToAnsi(STR0064),OemToAnsi(STR0006))  //"Codigo Nome do Fornecedor   PRF-Numero         Tp  Natureza    Data de  Vencto   Vencto  Banco  Valor Original |        Titulos vencidos          | Titulos a vencer | Porta-|  Vlr.juros ou   Dias   Historico     "
cabec2 := OemToAnsi(STR0007)  //"                            Parcela                            Emissao  Titulo    Real                         |  Valor nominal   Valor corrigido |   Valor nominal  | dor   |   permanencia   Atraso               "

//Nao retire esta chamada. Verifique antes !!!
//Ela é necessaria para o correto funcionamento da pergunte 36 (Data Base)
PutDtBase()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CriaSX1( cPerg )

pergunte("FIN150",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01	  // do Numero 			  ³
//³ mv_par02	  // at‚ o Numero 		  ³
//³ mv_par03	  // do Prefixo			  ³
//³ mv_par04	  // at‚ o Prefixo		  ³
//³ mv_par05	  // da Natureza  	     ³
//³ mv_par06	  // at‚ a Natureza		  ³
//³ mv_par07	  // do Vencimento		  ³
//³ mv_par08	  // at‚ o Vencimento	  ³
//³ mv_par09	  // do Banco			     ³
//³ mv_par10	  // at‚ o Banco		     ³
//³ mv_par11	  // do Fornecedor		  ³
//³ mv_par12	  // at‚ o Fornecedor	  ³
//³ mv_par13	  // Da Emiss„o			  ³
//³ mv_par14	  // Ate a Emiss„o		  ³
//³ mv_par15	  // qual Moeda			  ³
//³ mv_par16	  // Imprime Provis¢rios  ³
//³ mv_par17	  // Reajuste pelo vencto ³
//³ mv_par18	  // Da data contabil	  ³
//³ mv_par19	  // Ate data contabil	  ³
//³ mv_par20	  // Imprime Rel anal/sint³
//³ mv_par21	  // Considera  Data Base?³
//³ mv_par22	  // Cons filiais abaixo ?³
//³ mv_par23	  // Filial de            ³
//³ mv_par24	  // Filial ate           ³
//³ mv_par25	  // Loja de              ³
//³ mv_par26	  // Loja ate             ³
//³ mv_par27 	  // Considera Adiantam.? ³
//³ mv_par28	  // Imprime Nome 		  ³
//³ mv_par29	  // Outras Moedas 		  ³
//³ mv_par30     // Imprimir os Tipos    ³
//³ mv_par31     // Nao Imprimir Tipos	  ³
//³ mv_par32     // Consid. Fluxo Caixa  ³
//³ mv_par33     // DataBase             ³
//³ mv_par34     // Tipo de Data p/Saldo ³
//³ mv_par35     // Quanto a taxa		  ³
//³ mv_par36     // Tit.Emissao Futura	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF TOP
	IF TcSrvType() == "AS/400" .and. Select("__SE2") == 0
		ChkFile("SE2",.f.,"__SE2")
	Endif
#ENDIF

If IsBlind() // Guardando os tamanhos para restaurar apos pegar os valores do webspool
	nTamPar01:=len(mv_par01)
	nTamPar02:=len(mv_par02)
	nTamPar03:=len(mv_par03)
	nTamPar04:=len(mv_par04)
	nTamPar05:=len(mv_par05)
	nTamPar06:=len(mv_par06)
	nTamPar09:=len(mv_par09)
	nTamPar10:=len(mv_par10)
	nTamPar11:=len(mv_par11)
	nTamPar12:=len(mv_par12)
	nTamPar23:=len(mv_par23)
	nTamPar24:=len(mv_par24)
	nTamPar25:=len(mv_par25)
	nTamPar26:=len(mv_par26)
	nTamPar30:=len(mv_par30)
	nTamPar31:=len(mv_par31)
EndIf

wnrel := "FINR150"            //Nome Default do relatorio em Disco
aOrd	:= {OemToAnsi(STR0008),OemToAnsi(STR0009),OemToAnsi(STR0010) ,;  //"Por Numero"###"Por Natureza"###"Por Vencimento"
	OemToAnsi(STR0011),OemToAnsi(STR0012),OemToAnsi(STR0013),OemToAnsi(STR0014) }  //"Por Banco"###"Fornecedor"###"Por Emissao"###"Por Cod.Fornec."
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If IsBlind() // Acerto dos parametros apos chamada pelo webspool
	mv_par01:=padr(IIf(alltrim(mv_par01)='#','',mv_par01), nTamPar01)
	mv_par02:=padr(IIf(alltrim(mv_par02)='#','',mv_par02), nTamPar02)
	mv_par03:=padr(IIf(alltrim(mv_par03)='#','',mv_par03), nTamPar03)
	mv_par04:=padr(IIf(alltrim(mv_par04)='#','',mv_par04), nTamPar04)
	mv_par05:=padr(IIf(alltrim(mv_par05)='#','',mv_par05), nTamPar05)
	mv_par06:=padr(IIf(alltrim(mv_par06)='#','',mv_par06), nTamPar06)
	mv_par09:=padr(IIf(alltrim(mv_par09)='#','',mv_par09), nTamPar09)
	mv_par10:=padr(IIf(alltrim(mv_par10)='#','',mv_par10), nTamPar10)
	mv_par11:=padr(IIf(alltrim(mv_par11)='#','',mv_par11), nTamPar11)
	mv_par12:=padr(IIf(alltrim(mv_par12)='#','',mv_par12), nTamPar12)
	mv_par22:=IIf(valtype(mv_par22)='C',val(mv_par22),mv_par22)
	mv_par23:=padr(IIf(alltrim(mv_par23)='#','',mv_par23), nTamPar23)
	mv_par24:=padr(IIf(alltrim(mv_par24)='#','',mv_par24), nTamPar24)
	mv_par25:=padr(IIf(alltrim(mv_par25)='#','',mv_par25), nTamPar25)
	mv_par26:=padr(IIf(alltrim(mv_par26)='#','',mv_par26), nTamPar26)
	mv_par30:=padr(IIf(alltrim(mv_par30)='#','',mv_par30), nTamPar30)
	mv_par31:=padr(IIf(alltrim(mv_par31)='#','',mv_par31), nTamPar31)
EndIf

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa150Imp(@lEnd,wnRel,cString)},Titulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura empresa / filial original    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SM0->(dbGoto(nRegEmp))
cFilAnt := SM0->M0_CODFIL

//Acerta a database de acordo com a database real do sistema
If mv_par21 == 1    // Considera Data Base
	dDataBase := dOldDtBase
Endif	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA150Imp ³ Autor ³ Wagner Xavier 		  ³ Data ³ 02.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Posi‡„o dos Titulos a Pagar										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA150Imp(lEnd,wnRel,cString)										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd	  - A‡Æo do Codeblock										  ³±±
±±³			 ³ wnRel   - T¡tulo do relat¢rio 									  ³±±
±±³			 ³ cString - Mensagem										 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA150Imp(lEnd,wnRel,cString)

LOCAL CbCont
LOCAL CbTxt
LOCAL nOrdem :=0
LOCAL nQualIndice := 0
LOCAL lContinua := .T.
LOCAL nTit0:=0,nTit1:=0,nTit2:=0,nTit3:=0,nTit4:=0,nTit5:=0
LOCAL nTot0:=0,nTot1:=0,nTot2:=0,nTot3:=0,nTot4:=0,nTotTit:=0,nTotJ:=0,nTotJur:=0
LOCAL nFil0:=0,nFil1:=0,nFil2:=0,nFil3:=0,nFil4:=0,nFilTit:=0,nFilJ:=0
LOCAL cCond1,cCond2,cCarAnt,nSaldo:=0,nAtraso:=0
LOCAL dDataReaj
LOCAL dDataAnt := dDataBase , lQuebra
LOCAL nMestit0:= nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
LOCAL dDtContab
LOCAL	cIndexSe2
LOCAL	cChaveSe2
LOCAL	nIndexSE2
LOCAL cFilDe,cFilAte
Local nTotsRec := SE2->(RecCount())
Local cTamFor, cTamTit := ""
Local aTamFor := TAMSX3("E2_FORNECE")
Local nDecs := Msdecimais(mv_par15)
Local lFr150Flt := EXISTBLOCK("FR150FLT")
Local cFr150Flt
Local aFiliais := {}      
Local cFilialSE2	:= ""
Local nInc := 0
Local aSM0 := {} 
#IFDEF TOP
	Local nI := 0
	Local aStru := SE2->(dbStruct())
#ENDIF

Private nRegSM0 := SM0->(Recno())
Private nAtuSM0 := SM0->(Recno())
PRIVATE dBaixa := dDataBase

//*******************************************************
// Solução para o problema no filtro de Serie minuscula *
//*******************************************************
//mv_par04 := LOWER(mv_par04)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para Filtrar 										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Localiza‡”es ArgentinaÄÙ
If lFr150Flt
	cFr150Flt := EXECBLOCK("Fr150FLT",.f.,.f.)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impress„o do Cabe‡alho e Rodap‚ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt  := OemToAnsi(STR0015)  //"* indica titulo provisorio, P indica Saldo Parcial"
cbcont := 0
li 	 := 80
m_pag  := 1

nOrdem := aReturn[8]
cMoeda := LTrim(Str(mv_par15))
//Caso nao preencha o mv_par15 um erro ocorre ao procurar o parametro do sistema MV_MOEDA0.
If Val(cMoeda) == 0
	cMoeda := "1"
Endif
Titulo += OemToAnsi(STR0035)+GetMv("MV_MOEDA"+cMoeda)  //" em "

dbSelectArea ( "SE2" )
Set Softseek On

If mv_par22 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
ELSE
	cFilDe := mv_par23
	cFilAte:= mv_par24
Endif

//Acerta a database de acordo com o parametro
If mv_par21 == 1    // Considera Data Base
	dDataBase := mv_par33
Endif	

// Cria vetor com os codigos das filiais da empresa corrente
aFiliais := FinRetFil()

dbSelectArea("SM0")

nRegSM0 := SM0->(Recno())
nAtuSM0 := SM0->(Recno())

aSM0	:= AdmAbreSM0()
For nInc := 1 To Len( aSM0 )
	
	If !Empty(cFilAte) .AND. aSM0[nInc][1] == cEmpAnt .AND. (aSM0[nInc][2] >= cFilDe .and. aSM0[nInc][2] <= cFilAte)
	
		dbSelectArea("SE2")
		cFilAnt := aSM0[nInc][2]
	
		IF cFilialSE2 == xFilial("SE2")
			Loop
		ELSE
			cFilialSE2 := xFilial("SE2")
		ENDIF
		
		#IFDEF TOP
			// Monta total de registros para IncRegua()
			If !Empty(mv_par07)	
				cQuery := "SELECT COUNT( R_E_C_N_O_ ) TOTREC "
				cQuery += "FROM " + RetSqlName("SE2") + " "
				cQuery += "WHERE E2_FILIAL = '" + xFilial("SE2") + "' AND "
				cQuery += "E2_VENCREA >= '" + DtoS(mv_par07) + "' AND "
				cQuery += "E2_VENCREA <= '" + DtoS(mv_par08) + "' AND "
				cQuery += "D_E_L_E_T_ = ' '"
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T.)
				nTotsRec := TRB->TOTREC
			Else
				cQuery := "SELECT COUNT( R_E_C_N_O_ ) TOTREC "
				cQuery += "FROM " + RetSqlName("SE2") + " "
				cQuery += "WHERE E2_FILIAL = '" + xFilial("SE2") + "' AND "
				cQuery += "E2_EMISSAO >= '" + DtoS(mv_par13) + "' AND "
				cQuery += "E2_EMISSAO <= '" + DtoS(mv_par14) + "' AND "
				cQuery += "D_E_L_E_T_ = ' '"
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T.)
				nTotsRec := TRB->TOTREC
			EndIf
	                     
			dbSelectArea("TRB")
			dbCloseArea()      
			dbSelectArea("SE2")
	
			if TcSrvType() != "AS/400"
				cQuery := "SELECT * "
				cQuery += "  FROM "+	RetSqlName("SE2")
				cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'"
				cQuery += "   AND D_E_L_E_T_ = ' ' "
			endif
		#ENDIF
	
		IF nOrdem == 1
			SE2->(dbSetOrder(1))
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					dbSeek(xFilial("SE2")+mv_par03+mv_par01,.T.)
				else
					cOrder := SqlOrder(indexkey())
				endif
			#ELSE
				dbSeek(xFilial("SE2")+mv_par03+mv_par01,.T.)
			#ENDIF
			cCond1 := "E2_PREFIXO <= mv_par04"
			cCond2 := "E2_PREFIXO"
			titulo += OemToAnsi(STR0016)  //" - Por Numero"
			nQualIndice := 1
		Elseif nOrdem == 2
			SE2->(dbSetOrder(2))
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					dbSeek(xFilial("SE2")+mv_par05,.T.)
				else
					cOrder := SqlOrder(indexkey())
				endif
			#ELSE
				dbSeek(xFilial("SE2")+mv_par05,.T.)
			#ENDIF
			cCond1 := "E2_NATUREZ <= mv_par06"
			cCond2 := "E2_NATUREZ"
			titulo += OemToAnsi(STR0017)  //" - Por Natureza"
			nQualIndice := 2
		Elseif nOrdem == 3
			SE2->(dbSetOrder(3))
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					dbSeek(xFilial("SE2")+Dtos(mv_par07),.T.)
				else
					cOrder := SqlOrder(indexkey())
				endif
			#ELSE
				dbSeek(xFilial("SE2")+Dtos(mv_par07),.T.)
			#ENDIF
			cCond1 := "E2_VENCREA <= mv_par08"
			cCond2 := "E2_VENCREA"
			titulo += OemToAnsi(STR0018)  //" - Por Vencimento"
			nQualIndice := 3
		Elseif nOrdem == 4
			SE2->(dbSetOrder(4))
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					dbSeek(xFilial("SE2")+mv_par09,.T.)
				else
					cOrder := SqlOrder(indexkey())
				endif
			#ELSE
				dbSeek(xFilial("SE2")+mv_par09,.T.)
			#ENDIF
			cCond1 := "E2_PORTADO <= mv_par10"
			cCond2 := "E2_PORTADO"
			titulo += OemToAnsi(STR0031)  //" - Por Banco"
			nQualIndice := 4
		Elseif nOrdem == 6
			SE2->(dbSetOrder(5))
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					dbSeek(xFilial("SE2")+DTOS(mv_par13),.T.)
				else
					cOrder := SqlOrder(indexkey())
				endif
			#ELSE
				dbSeek(xFilial("SE2")+DTOS(mv_par13),.T.)
			#ENDIF
			cCond1 := "E2_EMISSAO <= mv_par14"
			cCond2 := "E2_EMISSAO"
			titulo += OemToAnsi(STR0019)  //" - Por Emissao"
			nQualIndice := 5
		Elseif nOrdem == 7
			SE2->(dbSetOrder(6))
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					dbSeek(xFilial("SE2")+mv_par11,.T.)
				else
					cOrder := SqlOrder(indexkey())
				endif
			#ELSE
				dbSeek(xFilial("SE2")+mv_par11,.T.)
			#ENDIF			
			cCond1 := "E2_FORNECE <= mv_par12"
			cCond2 := "E2_FORNECE"
			titulo += OemToAnsi(STR0020)  //" - Por Cod.Fornecedor"
			nQualIndice := 6
		Else
			cChaveSe2 := "E2_FILIAL+E2_NOMFOR+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					cIndexSe2 := CriaTrab(nil,.f.)
					IndRegua("SE2",cIndexSe2,cChaveSe2,,Fr150IndR(),OemToAnsi(STR0021))  // //"Selecionando Registros..."
					nIndexSE2 := RetIndex("SE2")
					dbSetOrder(nIndexSe2+1)
					dbSeek(xFilial("SE2"))
				else
					cOrder := SqlOrder(cChaveSe2)
				endif
			#ELSE
				cIndexSe2 := CriaTrab(nil,.f.)
				IndRegua("SE2",cIndexSe2,cChaveSe2,,Fr150IndR(),OemToAnsi(STR0021))  // //"Selecionando Registros..."
				nIndexSE2 := RetIndex("SE2")
				dbSetIndex(cIndexSe2+OrdBagExt())
				dbSetOrder(nIndexSe2+1)
				dbSeek(xFilial("SE2"))
			#ENDIF
			cCond1 := "E2_FORNECE <= mv_par12"
			cCond2 := "E2_FORNECE+E2_LOJA"
			titulo += OemToAnsi(STR0022)  //" - Por Fornecedor"
			nQualIndice := IndexOrd()
		EndIF
	
		If mv_par20 == 1
			titulo += OemToAnsi(STR0023)  //" - Analitico"
		Else
			titulo += OemToAnsi(STR0024)  // " - Sintetico"
			cabec1 := OemToAnsi(STR0033)  // "                                                                                          |        Titulos vencidos         |    Titulos a vencer     |           Valor dos juros ou                       (Vencidos+Vencer)"
			cabec2 := OemToAnsi(STR0034)  // "                                                                                          | Valor nominal   Valor corrigido |      Valor nominal      |            com. permanencia                                         "
		EndIf
	
		dbSelectArea("SE2")
		cFilterUser:=aReturn[7]
	
		Set Softseek Off
	
		#IFDEF TOP
			if TcSrvType() != "AS/400"
				cQuery += " AND E2_NUM     BETWEEN '"+ mv_par01+ "' AND '"+ mv_par02 + "'"
				cQuery += " AND E2_PREFIXO BETWEEN '"+ mv_par03+ "' AND '"+ mv_par04 + "'"
				cQuery += " AND (E2_MULTNAT = '1' OR (E2_NATUREZ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'))"
				cQuery += " AND E2_VENCREA BETWEEN '"+ DTOS(mv_par07)+ "' AND '"+ DTOS(mv_par08) + "'"
				cQuery += " AND E2_PORTADO BETWEEN '"+ mv_par09+ "' AND '"+ mv_par10 + "'"
				cQuery += " AND E2_FORNECE BETWEEN '"+ mv_par11+ "' AND '"+ mv_par12 + "'"
				cQuery += " AND E2_EMISSAO BETWEEN '"+ DTOS(mv_par13)+ "' AND '"+ DTOS(mv_par14) + "'"
				cQuery += " AND E2_LOJA    BETWEEN '"+ mv_par25 + "' AND '"+ mv_par26 + "'"
	
				//Considerar titulos cuja emissao seja maior que a database do sistema
				If mv_par36 == 2 
					cQuery += " AND E2_EMISSAO <= '" + DTOS(dDataBase) +"'"
				Endif
		
				If !Empty(mv_par30) // Deseja imprimir apenas os tipos do parametro 30
					cQuery += " AND E2_TIPO IN "+FormatIn(mv_par30,";") 
				ElseIf !Empty(Mv_par31) // Deseja excluir os tipos do parametro 31
					cQuery += " AND E2_TIPO NOT IN "+FormatIn(mv_par31,";")
				EndIf
				If mv_par32 == 1
					cQuery += " AND E2_FLUXO <> 'N'"
				Endif 
							
				cQuery += " AND E2_TIPO NOT IN "+FormatIn(MVABATIM,";")
				
				If mv_par16 == 2
					cQuery += " AND E2_TIPO NOT IN "+FormatIn(MVPROVIS,";")			
				Endif
				
				If mv_par27 == 2
					cQuery += " AND E2_TIPO NOT IN "+FormatIn(MVPAGANT,";")			 
					cQuery += " AND E2_TIPO NOT IN "+FormatIn(MV_CPNEG,";")			
				Endif							
							
				cQuery += " ORDER BY "+ cOrder
	
				cQuery := ChangeQuery(cQuery)
	
				dbSelectArea("SE2")
				dbCloseArea()
				dbSelectArea("SA2")
	
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE2', .F., .T.)
	
				For ni := 1 to Len(aStru)
					If aStru[ni,2] != 'C'
						TCSetField('SE2', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
					Endif
				Next
			endif
		#ENDIF
	
		SetRegua(nTotsRec)
		
		If MV_MULNATP .And. nOrdem == 2
			Finr155R3(cFr150Flt, lEnd, @nFil0, @nFil1, @nFil2, @nFil3, @nFilTit, @nFilj )
			#IFDEF TOP
				if TcSrvType() != "AS/400"
					dbSelectArea("SE2")
					dbCloseArea()
					ChKFile("SE2")
					dbSetOrder(1)
				endif
			#ENDIF
			If Empty(xFilial("SE2"))
				Exit
			Endif
			dbSelectArea("SM0")
			if mv_par22 == 1 .and. Len(aSM0) > 1 
				ImpFil150(nFil0,nFil1,nFil2,nFil3,nFil3,nFilTit,nFilj,nDecs,aSM0[nInc][7])
			Endif
			
			nTot0 += nFil0
			nTot1 += nFil1
			nTot2 += nFil2
			nTot3 += nFil3
			nTot4 += nFil4
			nTotJ += nFilj
			nTotTit+=nFilTit
			Store 0 To nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilj
			Loop
		Endif
	
		While &cCond1 .and. !Eof() .and. lContinua .and. E2_FILIAL == xFilial("SE2")
	
			IF lEnd
				@PROW()+1,001 PSAY OemToAnsi(STR0025)  //"CANCELADO PELO OPERADOR"
				Exit
			End
	
			IncRegua()
	
			dbSelectArea("SE2")
	
			Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega data do registro para permitir ³
			//³ posterior analise de quebra por mes.	 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dDataAnt := Iif(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)
	
			cCarAnt := &cCond2
	
			While &cCond2 == cCarAnt .and. !Eof() .and. lContinua .and. E2_FILIAL == xFilial("SE2")
	
				IF lEnd
					@PROW()+1,001 PSAY OemToAnsi(STR0025)  //"CANCELADO PELO OPERADOR"
					Exit
				End
	
				IncRegua()
	
				dbSelectArea("SE2")
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Considera filtro do usuario                                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty(cFilterUser).and.!(&cFilterUser)
					dbSkip()
					Loop
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Considera filtro do usuario no ponto de entrada.             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lFr150flt
					If &cFr150flt
						DbSkip()
						Loop
					Endif
				Endif
				
				#IFNDEF TOP						
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se trata-se de abatimento ou provisorio, ou ³
					//³ Somente titulos emitidos ate a data base				   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					IF SE2->E2_TIPO $ MVABATIM .Or. (SE2 -> E2_EMISSAO > dDataBase .and. mv_par36 == 2)
						dbSkip()
						Loop
					EndIF
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se ser  impresso titulos provis¢rios		   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					IF E2_TIPO $ MVPROVIS .and. mv_par16 == 2
						dbSkip()
						Loop
					EndIF	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se ser  impresso titulos de Adiantamento	 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					IF SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. mv_par27 == 2
						dbSkip()
						Loop
					EndIF      
					         
	            #ENDIF
	            
	            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se deve imprimir outras moedas³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If mv_par29 == 2 // nao imprime
					if SE2->E2_MOEDA != mv_par15 //verifica moeda do campo=moeda parametro
						dbSkip()
						Loop
					endif	
				Endif   
				
				// dDtContab para casos em que o campo E2_EMIS1 esteja vazio
				// compatibilizando com a vers„o 2.04 que n„o gerava para titulos
				// de ISS e FunRural
	
				dDtContab := Iif(Empty(SE2->E2_EMIS1),SE2->E2_EMISSAO,SE2->E2_EMIS1)
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se esta dentro dos parametros ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF E2_NUM < mv_par01      .OR. E2_NUM > mv_par02 .OR. ;
						E2_PREFIXO < mv_par03  .OR. E2_PREFIXO > mv_par04 .OR. ;
						E2_NATUREZ < mv_par05  .OR. E2_NATUREZ > mv_par06 .OR. ;
						E2_VENCREA < mv_par07  .OR. E2_VENCREA > mv_par08 .OR. ;
						E2_PORTADO < mv_par09  .OR. E2_PORTADO > mv_par10 .OR. ;
						E2_FORNECE < mv_par11  .OR. E2_FORNECE > mv_par12 .OR. ;
						E2_EMISSAO < mv_par13  .OR. E2_EMISSAO > mv_par14 .OR. ;
						(E2_EMISSAO > dDataBase .and. mv_par36 == 2) .OR. dDtContab  < mv_par18 .OR. ;
						E2_LOJA    < mv_par25  .OR. E2_LOJA    > mv_par26 .OR. ;
						dDtContab  > mv_par19  .Or. !&(fr150IndR())
	
					dbSkip()
					Loop
				Endif
				     
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se esta dentro do parametro compor pela data de digitação ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF mv_par34 == 2 .And. !Empty(E2_EMIS1) .And. !Empty(mv_par33)
					If E2_EMIS1 > mv_par33
						dbSkip()
						Loop
					Endif			
				Endif
				
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se titulo, apesar do E2_SALDO = 0, deve aparecer ou ³
				//³ nÆo no relat¢rio quando se considera database (mv_par21 = 1) ³
				//³ ou caso nÆo se considere a database, se o titulo foi totalmen³
				//³ te baixado.																  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF !Empty(SE2->E2_BAIXA) .and. Iif(mv_par21 == 2 ,SE2->E2_SALDO == 0 ,SE2->E2_SALDO == 0 .and. SE2->E2_BAIXA <= dDataBase)						


					dbSkip()
					Loop
				EndIF
				
				 // Tratamento da correcao monetaria para a Argentina
				If  cPaisLoc=="ARG" .And. mv_par15 <> 1  .And.  SE2->E2_CONVERT=='N'
					dbSkip()
					Loop
				Endif
	             
				dbSelectArea("SA2")
				MSSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
				dbSelectArea("SE2")
	
				// Verifica se existe a taxa na data do vencimento do titulo, se nao existir, utiliza a taxa da database
				If SE2->E2_VENCREA < dDataBase
					If mv_par17 == 2 .And. RecMoeda(SE2->E2_VENCREA,cMoeda) > 0
						dDataReaj := SE2->E2_VENCREA
					Else
						dDataReaj := dDataBase
					EndIf	
				Else
					dDataReaj := dDataBase
				EndIf       
	
				If mv_par21 == 1
					nSaldo := SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,mv_par15,dDataReaj,,SE2->E2_LOJA,,If(mv_par35==1,SE2->E2_TXMOEDA,Nil),IIF(mv_par34 == 2,3,1)) // 1 = DT BAIXA    3 = DT DIGIT
					//Verifica se existem compensações em outras filiais para descontar do saldo, pois a SaldoTit() somente
					//verifica as movimentações da filial corrente. Nao deve processar quando existe somente uma filial.
					If !Empty(xFilial("SE2")) .And. !Empty(xFilial("SE5")) .And. Len(aFiliais) > 1
						nSaldo -= Round(NoRound(xMoeda(FRVlCompFil("P",SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,IIF(mv_par34 == 2,3,1),aFiliais);
										,SE2->E2_MOEDA,mv_par15,dDataReaj,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil)),nDecs+1),nDecs)
					EndIf
					// Subtrai decrescimo para recompor o saldo na data escolhida.
					If Str(SE2->E2_VALOR,17,2) == Str(nSaldo,17,2) .And. SE2->E2_DECRESC > 0 .And. SE2->E2_SDDECRE == 0
						nSAldo -= SE2->E2_DECRESC
					Endif
					// Soma Acrescimo para recompor o saldo na data escolhida.
					If Str(SE2->E2_VALOR,17,2) == Str(nSaldo,17,2) .And. SE2->E2_ACRESC > 0 .And. SE2->E2_SDACRES == 0
						nSAldo += SE2->E2_ACRESC
					Endif
				Else
					nSaldo := xMoeda((SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE),SE2->E2_MOEDA,mv_par15,dDataReaj,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
				Endif
				If ! (SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG) .And. ;
				   ! ( MV_PAR21 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
	
					//Quando considerar Titulos com emissao futura, eh necessario
					//colocar-se a database para o futuro de forma que a Somaabat()
					//considere os titulos de abatimento
					If mv_par36 == 1
						dOldData := dDataBase
						dDataBase := CTOD("31/12/40")
					Endif
	
					nSaldo-=SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",mv_par15,dDataReaj,SE2->E2_FORNECE,SE2->E2_LOJA)
	
					If mv_par36 == 1
						dDataBase := dOldData
					Endif
				EndIf
	
				nSaldo:=Round(NoRound(nSaldo,3),2)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Desconsidera caso saldo seja menor ou igual a zero   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nSaldo <= 0
					dbSkip()
					Loop
				Endif  
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Desconsidera os titulos de acordo com o parametro 
				//	considera filial e a tabela SE2 estiver compartilhada³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
				If MV_PAR22 == 1 .and. Empty(xFilial("SE2"))
					If !(SE2->E2_FILORIG >= mv_par23 .and. SE2->E2_FILORIG <= mv_par24) 
						dbSkip()
						Loop
					Endif			
				Endif 
	
				IF li > 58
					SM0->(dbGoto(nRegSM0))
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
				EndIF
	
				If mv_par20 == 1				
					If !(Alltrim(cPaisLoc) $ "MEX|POR")
						@li,	0 PSAY SE2->E2_FORNECE+"-"+SE2->E2_LOJA+"-"+IIF(mv_par28 == 1, SubStr(SA2->A2_NREDUZ,1,25), SubStr(SA2->A2_NOME,1,25))
						li := IIf (aTamFor[1] > 6,li+1,li)
						@li, 30 PSAY SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA
	                Else				
						If Len(SE2->E2_FORNECE) > 6
							@li, 00 PSAY SubStr(SE2->E2_FORNECE+"-"+SE2->E2_LOJA,01,25)
							cTamFor  :=  SubStr(IIF(mv_par28 == 1, SA2->A2_NREDUZ, SA2->A2_NOME),01,25)
		            	Else
							@li, 00 PSAY SubStr(SE2->E2_FORNECE+"-"+SE2->E2_LOJA+"-"+IIF(mv_par28 == 1, SubStr(SA2->A2_NREDUZ,1,25), SubStr(SA2->A2_NOME,1,25)),01,25)
							cTamFor  :=  SubStr(SE2->E2_FORNECE+"-"+SE2->E2_LOJA+"-"+IIF(mv_par28 == 1, SubStr(SA2->A2_NREDUZ,1,25), SubStr(SA2->A2_NOME,1,25)),33,57)
		            	EndIf
		            
						@li, 31 PSAY SubStr(SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA,01,20)
						cTamTit  :=  SubStr(SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA,34,55)
	                Endif				
					If cPaisLoc $ "BRA|ARG"
						@li, 49 PSAY SE2->E2_TIPO 
						@li, 54 PSAY SE2->E2_NATUREZ
						@li, 65 PSAY SE2->E2_EMISSAO
						@Li, 76 PSAY SE2->E2_VENCTO 
						@li, 87 PSAY SE2->E2_VENCREA
						@li, 99 PSAY xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil)) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) Picture PesqPict("SE2","E2_VALOR",15,MV_PAR15)
					Else    
						@li, 51 PSAY SE2->E2_TIPO
						@li, 55 PSAY SE2->E2_NATUREZ
						@li, 65 PSAY SE2->E2_EMISSAO
						@Li, 76 PSAY SE2->E2_VENCTO
						@li, 87 PSAY SE2->E2_VENCREA
						@li, 99 PSAY xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil)) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) Picture PesqPict("SE2","E2_VALOR",15,MV_PAR15)
					EndIf
				EndIf
				#IFDEF TOP
					If TcSrvType() == "AS/400"
						dbSetOrder( nQualIndice )
					Endif
				#ELSE
					dbSetOrder( nQualIndice )
				#ENDIF
	
				If dDataBase > SE2->E2_VENCREA 		//vencidos
					If mv_par20 == 1
					@ li, Iif(cPaisloc $ "BRA|ARG",115,128) PSAY nSaldo  * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) Picture TM(nSaldo,15,nDecs)
					EndIf
					nJuros:=0
					dBaixa:=dDataBase
					fa080Juros(mv_par15)
					dbSelectArea("SE2")
					If mv_par20 == 1
						@li,Iif(cPaisloc $ "BRA|ARG",132,135) PSAY (nSaldo+nJuros) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) Picture TM(nSaldo+nJuros,15,nDecs)
					EndIf
					If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
						nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nTit1 -= nSaldo
						nTit2 -= nSaldo+nJuros
						nMesTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nMesTit1 -= nSaldo
						nMesTit2 -= nSaldo+nJuros
					Else
						nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nTit1 += nSaldo
						nTit2 += nSaldo+nJuros
						nMesTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nMesTit1 += nSaldo
						nMesTit2 += nSaldo+nJuros
					Endif
					nTotJur += (nJuros)
					nMesTitJ += (nJuros)
				Else				  //a vencer
					If mv_par20 == 1
						@li,Iif(cPaisloc $ "BRA|ARG",151,148) PSAY nSaldo  * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) Picture TM(nSaldo,15,nDecs)  //leandro
					EndIf
					If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
						nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nTit3 -= nSaldo
						nTit4 -= nSaldo
						nMesTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nMesTit3 -= nSaldo
						nMesTit4 -= nSaldo
					Else
						nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nTit3 += nSaldo
						nTit4 += nSaldo
						nMesTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nMesTit3 += nSaldo
						nMesTit4 += nSaldo
					Endif
				Endif
				If mv_par20 == 1
					@Li,170 PSAY SE2->E2_PORTADO
				EndIf
				If nJuros > 0
					If mv_par20 == 1
						@Li,176 PSAY nJuros Picture PesqPict("SE2","E2_JUROS",12,MV_PAR15)
					EndIf
					nJuros := 0
				Endif
	
				IF dDataBase > E2_VENCREA
					nAtraso:=dDataBase-E2_VENCTO
					IF Dow(E2_VENCTO) == 1 .Or. Dow(E2_VENCTO) == 7
						IF Dow(dBaixa) == 2 .and. nAtraso <= 2
							nAtraso:=0
						EndIF
					EndIF
					nAtraso:=IIF(nAtraso<0,0,nAtraso)
					IF nAtraso>0
						If mv_par20 == 1
							@li,191 PSAY nAtraso Picture "9999"
						EndIf
					EndIF
				EndIF
				If mv_par20 == 1
					@li,197 PSAY SUBSTR(SE2->E2_HIST,1,25)+ ;
						IIF(E2_TIPO $ MVPROVIS,"*"," ")+ ;
						Iif(nSaldo - SE2->E2_ACRESC + SE2->E2_DECRESC == xMoeda(E2_VALOR,E2_MOEDA,mv_par15,dDataReaj,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))," ","P")
				EndIf
	            
				If Alltrim(cPaisLoc) $ "MEX|POR"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Tratamento para imprimir restante do conteúdo   ³
					//³ dos campos quando maior que o permitido         ³
					//³ para evitar impressão incompleta ou imperfeita. ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If mv_par20 == 1 .and. (!Empty(cTamFor) .or. !Empty(cTamTit))
						li ++
						@li, 00 PSAY cTamFor
						@li, 26 PSAY cTamTit
					EndIf
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Carrega data do registro para permitir ³
				//³ posterior analise de quebra por mes.	 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dDataAnt := Iif(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)
	
				dbSkip()
				nTotTit ++
				nMesTTit ++
				nFiltit++
				nTit5 ++
				If mv_par20 == 1
					li ++
				EndIf
	
			EndDO
	
			IF nTit5 > 0 .and. nOrdem != 1
				SubTot150(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs)
				If mv_par20 == 1
					li++
				EndIf
			EndIF
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica quebra por mes					 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lQuebra := .F.
			If nOrdem == 3 .and. Month(SE2->E2_VENCREA) # Month(dDataAnt)
				lQuebra := .T.
			Elseif nOrdem == 6 .and. Month(SE2->E2_EMISSAO) # Month(dDataAnt)
				lQuebra := .T.
			Endif
			If lQuebra .and. nMesTTit # 0
				ImpMes150(nMesTit0,nMesTit1,nMesTit2,nMesTit3,nMesTit4,nMesTTit,nMesTitJ,nDecs)
				nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
			Endif
	
			dbSelectArea("SE2")
	
			nTot0 += nTit0
			nTot1 += nTit1
			nTot2 += nTit2
			nTot3 += nTit3
			nTot4 += nTit4
			nTotJ += nTotJur
	
			nFil0 += nTit0
			nFil1 += nTit1
			nFil2 += nTit2
			nFil3 += nTit3
			nFil4 += nTit4
			nFilJ += nTotJur
			Store 0 To nTit0,nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur
		Enddo					
	
		dbSelectArea("SE2")		// voltar para alias existente, se nao, nao funciona
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprimir TOTAL por filial somente quan-³
		//³ do houver mais do que 1 filial.        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		if mv_par22 == 1 .and. Len(aSM0) > 1 
			ImpFil150(nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilj,nDecs,aSM0[nInc][7])
		Endif
		Store 0 To nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ
		If Empty(xFilial("SE2"))
			Exit
		Endif
	
		#IFDEF TOP
			if TcSrvType() != "AS/400"
				dbSelectArea("SE2")
				dbCloseArea()
				ChKFile("SE2")
				dbSetOrder(1)
			endif
		#ENDIF
	EndIf	
Next

SM0->(dbGoTo(nRegSM0))
cFilAnt := SM0->M0_CODFIL 

IF li != 80
	If mv_par20 == 1
		li +=2
	Endif
	ImpTot150(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nDecs)
	cbcont := 1
	roda(cbcont,cbtxt,"G")
EndIF
Set Device To Screen

#IFNDEF TOP
	dbSelectArea( "SE2" )
	dbClearFil()
	RetIndex( "SE2" )
	If !Empty(cIndexSE2)
		FErase (cIndexSE2+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	if TcSrvType() != "AS/400"
		dbSelectArea("SE2")
		dbCloseArea()
		ChKFile("SE2")
		dbSetOrder(1)
	else
		dbSelectArea( "SE2" )
		dbClearFil()
		RetIndex( "SE2" )
		If !Empty(cIndexSE2)
			FErase (cIndexSE2+OrdBagExt())
		Endif
		dbSetOrder(1)
	endif
#ENDIF	

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SubTot150 ³ Autor ³ Wagner Xavier 		  ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR SUBTOTAL DO RELATORIO 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ SubTot150() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SubTot150(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs)

DEFAULT nDecs := Msdecimais(mv_par15)

If mv_par20 == 1
	li++
EndIf

IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF

if nOrdem == 1 .Or. nOrdem == 3 .Or. nOrdem == 4 .Or. nOrdem == 6
	@li,000 PSAY OemToAnsi(STR0026)  //"S U B - T O T A L ----> "
	@li,028 PSAY cCarAnt
ElseIf nOrdem == 2
	dbSelectArea("SED")
	dbSeek(xFilial("SED")+cCarAnt)
	@li,000 PSAY cCarAnt +" "+SED->ED_DESCRIC
Elseif nOrdem == 5
	@Li,000 PSAY IIF(mv_par28 == 1,SA2->A2_NREDUZ,SA2->A2_NOME)+" "+Substr(SA2->A2_TEL,1,15)
ElseIf nOrdem == 7
	@li,000 PSAY SA2->A2_COD+" "+SA2->A2_LOJA+" "+SA2->A2_NOME+" "+Substr(SA2->A2_TEL,1,15)
Endif

if mv_par20 == 1
	@li,100 PSAY nTit0		 Picture TM(nTit0,14,nDecs)
endif  

@li,116 PSAY nTit1		 Picture TM(nTit1,14,nDecs)  
@li,133 PSAY nTit2		 Picture TM(nTit2,14,nDecs)  
@li,152 PSAY nTit3		 Picture TM(nTit3,14,nDecs) 
   
If nTotJur > 0
	@li,176 PSAY nTotJur 	 Picture TM(nTotJur,12,nDecs)
Endif  
@li,197 PSAY nTit2+nTit3 Picture TM(nTit2+nTit3,16,nDecs)
li++ 
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ImpTot150 ³ Autor ³ Wagner Xavier 		  ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR TOTAL DO RELATORIO 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpTot150() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function ImpTot150(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nDecs)

DEFAULT nDecs := Msdecimais(mv_par15)

li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi(STR0027)  //"T O T A L   G E R A L ----> "
@li,035 PSAY "("+ALLTRIM(STR(nTotTit))+" "+IIF(nTotTit > 1,OemToAnsi(STR0028),OemToAnsi(STR0029))+")"  //"TITULOS"###"TITULO" //28
if mv_par20 == 1
	@li,99 PSAY nTot0		 Picture TM(nTot0,15,nDecs)
endif
@li,115 PSAY nTot1		 Picture TM(nTot1,15,nDecs) 
@li,132 PSAY nTot2		 Picture TM(nTot2,15,nDecs) 
@li,151 PSAY nTot3		 Picture TM(nTot3,15,nDecs) 
@li,176 PSAY nTotJ		 Picture TM(nTotJ,12,nDecs) 
@li,197 PSAY nTot2+nTot3 Picture TM(nTot2+nTot3,17,nDecs)
li+=2
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ImpMes150 ³ Autor ³ Vinicius Barreira	  ³ Data ³ 12.12.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR TOTAL DO RELATORIO - QUEBRA POR MES					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpMes150() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function ImpMes150(nMesTot0,nMesTot1,nMesTot2,nMesTot3,nMesTot4,nMesTTit,nMesTotJ,nDecs)

DEFAULT nDecs := Msdecimais(mv_par15)

li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi(STR0030)  //"T O T A L   D O  M E S ---> "
@li,028 PSAY "("+ALLTRIM(STR(nMesTTit))+" "+IIF(nMesTTit > 1,OemToAnsi(STR0028),OemToAnsi(STR0029))+")"  //"TITULOS"###"TITULO"
if mv_par20 == 1
	@li,100 PSAY nMesTot0   Picture TM(nMesTot0,14,nDecs)
endif
@li,115 PSAY nMesTot1	Picture TM(nMesTot1,14,nDecs)
@li,133 PSAY nMesTot2	Picture TM(nMesTot2,14,nDecs) 
@li,152 PSAY nMesTot3	Picture TM(nMesTot3,14,nDecs) 
@li,176 PSAY nMesTotJ	Picture TM(nMesTotJ,12,nDecs) 
@li,197 PSAY nMesTot2+nMesTot3 Picture TM(nMesTot2+nMesTot3,16,nDecs) 
li+=2
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ ImpFil150³ Autor ³ Paulo Boschetti 	     ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprimir total do relatorio										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpFil150()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³																				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico				   									 			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function ImpFil150(nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ,nDecs,cFilSM0)

DEFAULT nDecs := Msdecimais(mv_par15)

li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi(STR0032)+" "+cFilAnt+" - " + AllTrim(cFilSM0)  //"T O T A L   F I L I A L ----> " 
if mv_par20 == 1
	@li,106 PSAY nFil0        Picture TM(nFil0,14,nDecs)
endif
@li,122 PSAY nFil1        Picture TM(nFil1,14,nDecs)
@li,139 PSAY nFil2        Picture TM(nFil2,14,nDecs)
@li,158 PSAY nFil3        Picture TM(nFil3,14,nDecs)
@li,184 PSAY nFilJ		  Picture TM(nFilJ,12,nDecs)
@li,204 PSAY nFil2+nFil3 Picture TM(nFil2+nFil3,16,nDecs)
li+=2
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fr150Indr ³ Autor ³ Wagner           	  ³ Data ³ 12.12.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta Indregua para impressao do relat¢rio						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fr150IndR()
Local cString
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ATENCAO !!!!                                               ³
//³ N„o adiconar mais nada a chave do filtro pois a mesma est  ³
//³ com 254 caracteres.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cString := 'E2_FILIAL="'+xFilial()+'".And.'
cString += '(E2_MULTNAT="1" .OR. (E2_NATUREZ>="'+mv_par05+'".and.E2_NATUREZ<="'+mv_par06+'")).And.'
cString += 'E2_FORNECE>="'+mv_par11+'".and.E2_FORNECE<="'+mv_par12+'".And.'
cString += 'DTOS(E2_VENCREA)>="'+DTOS(mv_par07)+'".and.DTOS(E2_VENCREA)<="'+DTOS(mv_par08)+'".And.'
cString += 'DTOS(E2_EMISSAO)>="'+DTOS(mv_par13)+'".and.DTOS(E2_EMISSAO)<="'+DTOS(mv_par14)+'"'
If !Empty(mv_par30) // Deseja imprimir apenas os tipos do parametro 30
	cString += '.And.E2_TIPO$"'+mv_par30+'"'
ElseIf !Empty(Mv_par31) // Deseja excluir os tipos do parametro 31
	cString += '.And.!(E2_TIPO$'+'"'+mv_par31+'")'
EndIf
IF mv_par32 == 1  // Apenas titulos que estarao no fluxo de caixa
	cString += '.And.(E2_FLUXO!="N")'	
Endif
		
Return cString

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PutDtBase³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 18/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta parametro database do relat[orio.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Finr150.                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PutDtBase()
Local _sAlias	:= Alias()

dbSelectArea("SX1")
dbSetOrder(1)
If MsSeek( padr( "FIN150" , Len( x1_grupo ) , ' ' )+ "33")
	//Acerto o parametro com a database
	RecLock("SX1",.F.)
	Replace x1_cnt01		With "'"+DTOC(dDataBase)+"'"
	MsUnlock()	
Endif

dbSelectArea(_sAlias)
Return       


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CriaSX1  ³ Autor ³ Microsiga             ³ Data ³ 10.05.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria e analisa grupo de perguntas                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cPerg                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CriaSX1( cPerg )                                                                                         

Local i,j
Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->( GetArea() )
Local aTamSX3	:= {}
Local aRegs     := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava as perguntas no arquivo SX1                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTamSX3	:= TAMSX3( "E5_NUMERO" )
AADD(aRegs,{cPerg,	"01","Do Numero ?"               ,"¿De Numero ?"                 ,"From Number ?"        ,"mv_ch1", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_numde"  ,                "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"02","Ate o Numero ?"            ,"¿A Numero ?"                  ,"To Number ?"          ,"mv_ch2", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_numate" ,                "",               "",            "","ZZZZZZZZZ","",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })

aTamSX3	:= TAMSX3( "E5_PREFIXO" )
AADD(aRegs,{cPerg,	"03","Do Prefixo ?"              ,"¿De Prefijo ?"                ,"From Prefix ?"        ,"mv_ch3", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_prfde"  ,                "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"04","Ate o Prefixo ?"           ,"¿A Prefijo ?"                 ,"To Prefix ?"          ,"mv_ch4", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_prfate" ,                "",               "",            "","ZZ"       ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" }) 

aTamSX3	:= TAMSX3( "ED_CODIGO" )
AADD(aRegs,{cPerg,	"05","Da Natureza ?"             ,"¿De Naturaleza ?"             ,"From Class ?"         ,"mv_ch5", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_natde"  ,                "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","","SED","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"06","Ate a Natureza ?"          ,"¿A Naturaleza ?"              ,"To Class ?"           ,"mv_ch6", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_natate" ,                "",               "",            "","ZZZZZZ"   ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","","SED","S",    "",          "","","" }) 

aTamSX3	:= TAMSX3( "E5_VENCTO" )
AADD(aRegs,{cPerg,	"07","Do Vencimento ?"           ,"¿De Vencimiento ?"            ,"From Due Date ?"      ,"mv_ch7", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_vencde" ,                "",               "",            "","01/01/04" ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })  
AADD(aRegs,{cPerg,	"08","Ate o Vencimento ?"        ,"¿A Vencimiento ?"             ,"To Due Date ?"        ,"mv_ch8", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_vencate",                "",               "",            "","31/12/04" ,"",              "",                "",              "","","",         "",          "",            "","",            "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })

aTamSX3	:= TAMSX3( "A6_COD" )
AADD(aRegs,{cPerg,	"09","Do Banco ?"                ,"¿De Banco ?"                  ,"From Bank ?"          ,"mv_ch9", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_bcode"  ,                "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","","BCO","S","007" ,          "","","" })
AADD(aRegs,{cPerg,	"10","Ate o Banco ?"             ,"¿A Banco ?"                   ,"To Bank ?"            ,"mv_cha", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_bcoate" ,                "",               "",            "","ZZZ"      ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","","BCO","S","007" ,          "","","" }) 

aTamSX3	:= TAMSX3( "A2_COD" )
AADD(aRegs,{cPerg,	"11","Do Fornecedor ?"           ,"¿De Proveedor ?"              ,"From Supplier ?"      ,"mv_chb", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_fornde" ,                "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","","SA2","S","001" ,          "","","" })
AADD(aRegs,{cPerg,	"12","Ate o Fornecedor ?"        ,"¿A Proveedor ?"               ,"To Supplier ?"        ,"mv_chc", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_fornate",                "",               "",            "","ZZZZZZ"   ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","","SA2","S","001" ,          "","","" })

aTamSX3	:= TAMSX3( "E5_DATA" )
AADD(aRegs,{cPerg,	"13","Da Emissao ?"              ,"¿De Emision ?"                ,"From Issue Date ?"    ,"mv_chd", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_emisde" ,                "",               "",            "","01/01/04" ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"14","Ate a Emissao ?"           ,"¿A Emision ?"                 ,"To Issue Date ?"      ,"mv_che", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_emisate",                "",               "",            "","21/12/04" ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })

AADD(aRegs,{cPerg,	"15","Qual Moeda ?"              ,"¿Que Moneda ?"                ,"Which Currency ?"     ,"mv_chf",        "N",          1,         0,         1,"C" ,"","mv_par15"  ,"Moeda 1"         ,"Moneda 1"       ,"Currency 1"  ,""         ,"","Moeda 2"       ,"Moneda 2"        ,"Currency 2"    ,"","", "Moeda 3" , "Moneda 3" , "Currency 3" ,"","", "Moeda 4" , "Moneda 4" , "Currency 4" ,"","", "Moeda 5" , "Moneda 5" , "Currency 5" ,"",   "","S",    "",          "","","" }) 
AADD(aRegs,{cPerg,	"16","Imprime Provisorios ?"     ,"¿Imprime Provisorios ?"       ,"Print Temporary ?"    ,"mv_chg",        "N",          1,         0,         2,"C" ,"","mv_par16"  ,"Sim"             ,"Si"             ,"Yes"         ,""         ,"","Nao"           ,"No"              ,"No"            ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"17","Converte Venci pela ?"     ,"¿Convierte Vencidos por ?"    ,"Convert per ?"        ,"mv_chh",        "N",          1,         0,         2,"C" ,"","mv_par17"  ,"Data Base"       ,"Fecha de Hoy"   ,"Base Date"   ,""         ,"","Data de Vencto","Fecha Vencto."   ,"Due Date"      ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })

aTamSX3	:= TAMSX3( "E5_DATA" )
AADD(aRegs,{cPerg,	"18","Da data contabil ?"        ,"¿A Fecha Contable ?"          ,"From Acconting Date ?","mv_chh", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_dtcont1",                "",               "",            "","01/01/04" ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"19","Ate data contabil ?"       ,"¿A Fecha Contable ?"          ,"To Accounting Date ?" ,"mv_chi", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_dtcont2",                "",               "",            "","31/12/04" ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })

AADD(aRegs,{cPerg,	"20","Imprime Relatorio ?"       ,"¿Imprimir Informe ?"          ,"Print Report ?"       ,"mv_chj",        "N",          1,         0,         1,"C" ,"","mv_par20"  ,"Analitico"       ,"Analitico"      ,"Detailed"    ,""         ,"","Sintetico"     ,"Sintetico"       ,"Summarized"    ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"21","Compoem Saldo Retroativo ?","¿Componen Saldo Retroactivo ?","Consider Base Date ?" ,"mv_chk",        "N",          1,         0,         1,"C" ,"","mv_par21"  ,"Sim"             ,"Si"             ,"Yes "        ,""         ,"","Nao"           ,"No"              ,"No"            ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"22","Cons.Filiais abaixo ?"     ,"¿Considera Siguientes Suc ?"  ,"Cons.Branches below ?","mv_chx",        "C",          1,         0,         2,"C" ,"","mv_par22"  ,"Sim"             ,"Si"             ,"Yes"         ,""         ,"","Nao"           ,"No"              ,"No"            ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })

aTamSX3	:= TAMSX3( "E5_FILIAL" )
AADD(aRegs,{cPerg,	"23","Da Filial ?"               ,"¿De Sucursal ?"               ,"From Branch ?"        ,"mv_chy", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_par23"  ,                "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"24","Ate a Filial ?"            ,"¿A Sucursal ?"                ,"To Branch ?"          ,"mv_chz", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_par24"  ,                "",               "",            "","ZZ"       ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
                                                                                                                                                                                                                                                          
aTamSX3	:= TAMSX3( "E5_LOJA" )
AADD(aRegs,{cPerg,	"25","Da Loja ?"                 ,"¿De Tienda ?"                 ,"From Unit ?"          ,"mv_cho", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_par25"  ,                "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S","002" ,          "","","" })
AADD(aRegs,{cPerg,	"26","Ate a Loja ?"              ,"¿A Tienda ?"                  ,"To Unit ?"            ,"mv_chp", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_par26"  ,                "",               "",            "","ZZ"       ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S","002" ,          "","","" })

AADD(aRegs,{cPerg,	"27","Considera Adiantam. ?"     ,"¿Considera Anticipo ?"        ,"Consider Advance ?"   ,"mv_chq",        "N",          1,         0,         0,"C" ,"","mv_par27"  ,"Sim"             ,"Si"             ,"Yes"         ,""         ,"","Nao"           ,"No"              ,"No"            ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" }) 
AADD(aRegs,{cPerg,	"28","Imprime Nome ?"            ,"¿Imprime Nombre ?"            ,"Print Name ?"         ,"mv_chm",        "N",          1,         0,         1,"C" ,"","mv_par28"  ,"Nome Reduzido"   ,"Nombre Reducido","Reduced Name",""         ,"","Razao Social"  ,"Razon Social"    ,"Trade Name"    ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"29","Outras Moedas ?"           ,"¿Otras Monedas ?"             ,"Other Currencies ?"   ,"mv_chn",        "N",          1,         0,         1,"C" ,"","mv_par29"  ,"Converter"       ,"Convertir"      ,"Convert"     ,""         ,"","Nao Imprimir"  ,"No Imprimir"     ,"Do Not Print"  ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"30","Imprimir Tipos ?"          ,"¿Imprimir Tipos ?"            ,"Print Types ?"        ,"mv_cho",        "C",         40,         0,         0,"G" ,"","mv_par30"  ,                "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"31","Nao Imprimir Tipos ?"      ,"¿No imprimir tipos ?"         ,"Do Not Print Types ?" ,"mv_chn",        "C",         40,         0,         0,"G" ,"","mv_par31"  ,                "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"32","Somente Tit.p/Fluxo ?"     ,"¿Solamente Titulo p/Flujo ?"  ,"Only Bill per Flow ?" ,"mv_cho",        "N",          1,         0,         0,"C" ,"","mv_par32"  ,"Sim"             ,"Si"             ,"Yes"         ,""         ,"","Nao"           ,"No"              ,"No"            ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" }) 

aTamSX3	:= TAMSX3( "E5_DATA" )
AADD(aRegs,{cPerg,	"33","Data Base ?"               ,"¿Fecha Base ?"                ,"Base Date ?"          ,"MV_CHR", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_par33"  ,                "",               "",            "","01/01/04","",               "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })

AADD(aRegs,{cPerg,	"34","Compoe Saldo por ?"        ,"¿Compone saldo por ?"         ,"Set Balance by ?"     ,"MV_CHS",        "N",          1,         0,         1,"C" ,"","mv_par34"  ,"Data da Baixa"   ,"Fecha Baja"     ,"Posting Date",""         ,"","Data Digitacao", "Fch.Digitacion" , "Entry Date"   ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" }) 
AADD(aRegs,{cPerg,	"35","Quanto a taxa ?"           ,"¿Con referencia a tasa ?"     ,"How about rate ?"     ,"MV_CHT",        "N",          1,         0,         1,"C" ,"","mv_par35"  ,"Taxa contratada" ,"Tasa contratada","Hired rate"  ,""         ,"","Taxa normal"   , "Tasa normal"    , "Standard rate","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"36","Tit. Emissao Futura ?"     ,"¿Tit. Emision Futura ?"       ,"Future issue bill ?"  ,"MV_CHU",        "N",          1,         0,         2,"C" ,"","mv_par36"  ,"Sim"             ,"Si"             ,"Yes"         ,""         ,"","Nao"           , "No"             , "No"           ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",".FIN15036.","","" }) 

DbSelectArea("SX1")                                                                                                           
SX1->(DbSetOrder(1))                                                                                                                                                                                                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                                                                                                                                                           
For I := 1 To Len(aRegs)
	If 	!dbSeek(cPerg+aRegs[i,2])                                                                                                                                                                  
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			IF j <= Len(aRegs[i])           
				FieldPut(j,aRegs[i,j])
			EndIf                                          
		Next
	                                                                                                                       
		MsUnLock()
	EndIf
Next

RestArea( aAreaSX1 )
RestArea( aAreaAtu )

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³Raphael Zampieri    º Data ³11.06.2008   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ajusta perguntas da tabela SX1                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINR150                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aArea := GetArea()
Local aRegs		:= {}  
Local nTamTitSX3:= 0       
Local cGrupoSX3	:= ""


dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("E1_NUM")     
nTamTitSX3	:= SX3->X3_TAMANHO
cGrupoSX3	:= SX3->X3_GRPSXG  
dbSetOrder(1)

//            cPerg	Ordem	PergPort         cPerSpa        cPerEng           cVar  Tipo     nTam	 1 2 3    4   cVar01  cDef01  cDefSpa1    cDefEng1    cCont01	        cVar02	   cDef02           cDefSpa2         cDefEng2   cCnt02 cVar03 cDef03   cDefSpa3  cDefEng3  	cCnt03	cVar04	cDef04  cDefSpa4  cDefEng4  cCnt04 	cVar05 	 cDef05	 cDefSpa5  cDefEng5	 cCnt05	 cF3	cGrpSxg  cPyme	 aHelpPor aHelpEng	aHelpSpa  cHelp
AAdd(aRegs,{"FIN150", "01","Do Numero  ?","¿De Numero  ?","From Number  ?",  "mv_ch1","C",nTamTitSX3,0,0,"G","","mv_numde","",      "",         "",         "",               "",        "",              "",              "",       "",    "",   "",        "",      "",       "",     "",    "",      "",        "",      "",     "",      "",     "",       "",      "",   "",   cGrupoSX3, "S",     "",      "",        "",     ""})
AAdd(aRegs,{"FIN150", "02","Ate o Numero  ?","¿A Numero  ?","To Number  ?",  "mv_ch2","C",nTamTitSX3,0,0,"G","","mv_numate","",      "",         "",    "ZZZZZZZZZZZZZZZZZZZZ",          "",        "",              "",              "",       "",    "",   "",        "",      "",       "",     "",    "",      "",        "",      "",     "",      "",     "",       "",      "",   "",   cGrupoSX3, "S",     "",      "",        "",     ""})

ValidPerg(aRegs,"FIN150",.T.)

RestArea( aArea )
                                    
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AdmAbreSM0³ Autor ³ Orizio                ³ Data ³ 22/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna um array com as informacoes das filias das empresas ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function AdmAbreSM0()
	Local aArea			:= SM0->( GetArea() )
	Local aAux			:= {}
	Local aRetSM0		:= {}
	Local lFWLoadSM0	:= FindFunction( "FWLoadSM0" )
	Local lFWCodFilSM0 	:= FindFunction( "FWCodFil" )

	If lFWLoadSM0
		aRetSM0	:= FWLoadSM0()
	Else
		DbSelectArea( "SM0" )
		SM0->( DbGoTop() )
		While SM0->( !Eof() )
			aAux := { 	SM0->M0_CODIGO,;
						IIf( lFWCodFilSM0, FWGETCODFILIAL, SM0->M0_CODFIL ),;
						"",;
						"",;
						"",;
						SM0->M0_NOME,;
						SM0->M0_FILIAL }

			aAdd( aRetSM0, aClone( aAux ) )
			SM0->( DbSkip() )
		End
	EndIf

	RestArea( aArea )
Return aRetSM0