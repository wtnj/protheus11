#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Rhgp07()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("M_PAG,NOMEPROG,CPERG,_CCATEG,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 27/10/01 ==> 	#DEFINE PSAY SAY
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RHGP07          ³ M.GracaNCarvalho      ³ Data ³ 11.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Contrato de Experiencia de Trabalho                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

cSavCur1:="";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""

cabec1:="";cabec2:="";cabec3:="";wnrel:=""

nOrdem:=0
tamanho:="P"
limite :=132
aReturn := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey:= 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Contrato de Experiencia"
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""
cString  := "SRA"
nTipo    := 0
m_pag    := 1
nomeprog := "RHGP07"
cPerg     := 'RHGP07'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte('RHGP07',.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "RHGP07"
wnRel := SetPrint(cString,wnrel,cperg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .or. nLastKey == 27
   RestScreen(3,0,24,79,cSavScr1)
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   RestScreen(3,0,24,79,cSavScr1)
   Return
Endif


#IFDEF WINDOWS
    RptStatus({|| RHG007()})  //-- Chamada do Relatorio.// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==>     RptStatus({|| Execute(RHG007)})  //-- Chamada do Relatorio.
	Return Nil
#ENDIF

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function RHG007
Static Function RHG007()

DbSelectArea("SRA")
DbSetOrder(01)

DbSelectArea("SRJ")
DbSetOrder(01)

DbSelectArea("SR6")
DbSetOrder(01)

SRA->(DbGoTop())
SRA->(SetRegua(RecCount()))

SRA->(DbSeek(mv_par01+mv_par03,.T.))
While SRA->(!Eof()) .and. SRA->RA_FILIAL>=mv_par01 .and. SRA->RA_FILIAL<=mv_par02 .and. SRA->RA_MAT<=mv_par03 .and. SRA->RA_MAT>=mv_par04
   SRJ->(DbSeek(xFilial()+SRA->RA_CODFUNC,.T.))
   If SRA->RA_CATFUNC=="H"
      _cCateg:=" POR HORA."
   ElseIf SRA->RA_CATFUNC=="M"   
      _cCateg:=" POR MES ."
   EndIf   
   IncRegua()
   @ pRow(), 22 pSay "* * NEW HUBNER COMPONENTES AUTOMOTIVOS * *"
   @ pRow()+2, 20 pSay "C O N T R A T O   D E   E X P E R I E N C I A"
   @ pRow()+2, 01 pSay "ENTRE A EMPRESA " + SM0->M0_NOMECOM + ", COM SEDE EM CURITIBA"
   @ pRow()+1, 01 pSay "NA  " + SM0->M0_ENDCOB + ",  DORAVANTE   DESIGNADA  DE  EMPREGADORA  E"
   @ pRow()+1, 01 pSay SRA->RA_NOME + "PORTADOR DA CARTEIRA DE  TRABALHO E  PREVIDENCIA"
   @ pRow()+1, 01 pSay "SOCIAL N. " + SRA->RA_NUMCP + ", SERIE N. " + SRA->RA_SERCP + " A SEGUIR  DESIGNADO  EMPREGADO, E  CELEBRADO" 
   @ pRow()+1, 01 pSay "O  PRESENTE  CONTRATO  DE  TRABALHO,  DE  ACORDO  COM  AS  CONDICOES A  SEGUIR"
   @ pRow()+1, 01 pSay "ESPECIFICADAS :"
   @ pRow()+1, 01 pSay "1. O  EMPREGADO  EXERCERA  AS  FUNCOES  DE  " + SRJ->RJ_DESC + ",  MEDIANTE  A"
   @ pRow()+1, 01 pSay "REMUNERACAO DE (R$ "
   @ pRow()  , 20 pSay SRA->RA_SALARIO Picture "999,999.99"
   If SubStr(Extenso(SRA->RA_SALARIO),38,10)<>Space(10)
      @ pRow()  , 30 pSay ") "+SubStr(Extenso(SRA->RA_SALARIO),1,47)
      @ pRow()+1, 01 pSay AllTrim(SubStr(Extenso(SRA->RA_SALARIO),48,70)) + _cCateg
   Else   
      @ pRow()  , 30 pSay ") "+SubStr(Extenso(SRA->RA_SALARIO),1,37) + _cCateg
   EndIf   
   @ pRow()+1, 01 pSay "2. O LOCAL DE TRABALHO SITUA-SE " + SM0->M0_ENDCOB + "AREA INDUSTRIAL."
   @ pRow()+1, 01 pSay "3. O  PAGAMENTO DE  SALARIO E  QUALQUER OUTRO  VALOR DEVIDO AO  EMPREGADO SERA"    
   @ pRow()+1, 01 pSay "CREDITADO EM CONTA CORRENTE BANCARIA."   
   @ pRow()+1, 01 pSay "4. FICA AJUSTADO NOS TERMOS DO PARAG. 1§ DO ART. 469 DA CONSOLIDACAO  DAS LEIS"   
   @ pRow()+1, 01 pSay "DO TRABALHO QUE A EMPREGADORA PODERA, A QUALQUER TEMPO, TRANSFERIR O EMPREGADO"
   @ pRow()+1, 01 pSay "PARA QUAISQUER OUTRAS LOCALIDADES DO PAIS."   
   @ pRow()+1, 01 pSay "5. ACEITA O EMPREGADO, EXPRESSAMENTE, A CONDICAO, PRESTAR SERVICOS EM QUALQUER"    
   @ pRow()+1, 01 pSay "DOS  TURNOS DE  TRABALHO, ISTO E, TANTO O  DIA  COMO A  NOITE,  DESDE  QUE SEM"   
   @ pRow()+1, 01 pSay "SIMULTANEAMENTE, OBSERVADAS PRESCRICOES LEGAIS REGULADORAS DO ASSUNTO,  QUANTO"   
   @ pRow()+1, 01 pSay "A REMUNERACAO"   
   @ pRow()+1, 01 pSay "6. EM CASO DE  DANO CAUSADO  PELO EMPREGADO, FICA A  EMPREGADORA  AUTORIZADA A"
   @ pRow()+1, 01 pSay "EFETUAR O DESCONTO DA IMPORTANCIA  CORRESPONDENTE AO  PREJUIZO, COM FUNDAMENTO"
   @ pRow()+1, 01 pSay "NO PARAG. 1§ DO ARTIGO 462 DA  CONSOLIDACAO DAS LEIS DO TRABALHO, VEZ QUE ESSA"
   @ pRow()+1, 01 pSay "POSSIBILIDADE FICA EXPRESSAMENTE PREVISTA EM CONTRATO."
   @ pRow()+1, 01 pSay "7. O PRAZO  DESTE  CONTRATO E DE 30 DIAS, COM  INICIO EM " + Dtoc(SRA->RA_ADMISSA) + " E TERMINO EM"
   @ pRow()+1, 01 pSay DtoC(SRA->RA_ADMISSA+29) + ". PODENDO SER PRORROGADO POR MAIS 60 DIAS SE NECESSARIO."
   @ pRow()+1, 01 pSay "8. PERMANECENDO  O  EMPREGADO  A  SERVICO  DA  EMPREGADORA  APOS O TERMINO DA,"
   @ pRow()+1, 01 pSay "EXPERIENCIA, CONTINUARAO EM PLENA VIGENCIA CLAUSULAS CONSTANTES DESTE CONTRATO"
   @ pRow()+1, 01 pSay "9. OPERA-SE A RESCISAO DO PRESENTE CONTRATO PELA DECORRENCIA DO PRAZO SUPRA OU"
   @ pRow()+1, 01 pSay "POR VONTADE DE UMA DAS PARTES, RESCINDINDO-SE POR VONTADE DO EMPREGADO OU PELA"
   @ pRow()+1, 01 pSay "EMPREGADORA  COM  JUSTA  CAUSA, NENHUMA  INDENIZACAO E DEVIDA, RESCINDINDO-SE,"
   @ pRow()+1, 01 pSay "ANTES DO PRAZO, PELA EMPREGADORA, FICA ESTA OBRIGADA A PAGAR  50% DOS SALARIOS" 
   @ pRow()+1, 01 pSay "DEVIDOS ATE O FINAL (METADE DO PRAZO COMBINADO RESTANTE), NOS TERMOS DO ARTIGO"
   @ pRow()+1, 01 pSay "479 DA CLT, SEM PREJUIZO DO DISPOSTO REG. NO FGTS NENHUM AVISO PREVIO E DEVIDO"
   @ pRow()+1, 01 pSay "PELA RESCISAO DO PRESENTE CONTRATO."
   @ pRow()+2, 01 pSay "E, POR ESTAREM  DE PLENO  ACORDO, AS  PARTES  ASSINAM O  PRESENTE  CONTRATO DE"
   @ pRow()+1, 01 pSay "TRABALHO, EM DUAS VIAS, FICANDO A PRIMEIRA EM PODER DA EMPREGADORA E A SEGUNDA"
   @ pRow()+1, 01 pSay "COM O EMPREGADO, QUE DELA DARA O COMPETENTE RECIBO."   
   @ pRow()+1, 60 pSay SRA->RA_ADMISSA
   @ pRow()+2, 01 pSay "EMPREGADOR"
   @ pRow()  , 41 pSay "EMPREGADO"
   @ pRow()+3, 01 pSay "TESTEMUNHAS"
   @ pRow()  , 41 pSay "TESTEMUNHAS"
   @ pRow()+3, 01 pSay "TERMO DE PRORROGACAO"
   @ pRow()+2, 01 pSay "POR MUTUO ACORDO ENTRE AS PARTES, O PRESENTE  CONTRATO DE EXPERIENCIA, DEVERIA"
   @ pRow()+1, 01 pSay "VENCER NESTA DATA FICA PRORROGADO ATE _____/_____/_____."
   @ pRow()+3, 01 pSay "EMPREGADOR"
   @ pRow()  , 41 pSay "EMPREGADO"
   @ pRow()+3, 01 pSay "TESTEMUNHAS"
   @ pRow()  , 41 pSay "TESTEMUNHAS"
   
   SRA->(DbSkip())
Enddo
RestScreen(3,0,24,79,cSavScr1)
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return
