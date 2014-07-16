/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE002  ºAutor  ³Microsiga           º Data ³  03/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Contrato de Experiencia.                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhgpe002()

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("M_PAG,NOMEPROG,CPERG,_NVIAS,_CCATEG,I")

cSavCur1  := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""
cabec1    := "";cabec2:="";cabec3:="";wnrel:=""
nOrdem    := 0
tamanho   := "P"
limite    := 132
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "Contrato de Experiencia"
cDesc1    := ""
cDesc2    := ""
cDesc3    := ""
cString   := "SRA"
nTipo     := 0
m_pag     := 1
nomeprog  := 'RHGP07'
cPerg     := 'RHGP07'
_nVias    := 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte('RHGP07',.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "NHGPE002"
wnRel := SetPrint(cString,wnrel,cperg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

RptStatus({|| RHG007()})

Return Nil


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
While SRA->(!Eof()) .and. SRA->RA_FILIAL>=mv_par01 .and. SRA->RA_FILIAL<=mv_par02 .and. SRA->RA_MAT>=mv_par03 .and. SRA->RA_MAT<=mv_par04
   SRJ->(DbSeek(xFilial()+SRA->RA_CODFUNC,.T.))
   If SRA->RA_CATFUNC=="H"
      _cCateg:="POR HORA."
   ElseIf SRA->RA_CATFUNC=="M"   
      _cCateg:="POR MES ."
   EndIf   
   IncRegua()
   For i:=1 to _nVias
      @ 1, 28 pSay "* * " + Alltrim(SM0->M0_NOMECOM) + " * *"
      @ pRow()+2, 20 pSay "C O N T R A T O   D E   E X P E R I E N C I A"
      If SM0->M0_CODIGO == "FN"	.AND. SM0->M0_CODFIL == "02"	
	      @ pRow()+2, 01 pSay "ENTRE A EMPRESA " + Subs(SM0->M0_NOMECOM,1,33) + ", COM SEDE EM " + ALLTRIM(SM0->M0_CIDENT)
      Else
	      @ pRow()+2, 01 pSay "ENTRE A EMPRESA " + Subs(SM0->M0_NOMECOM,1,40) + ", COM SEDE EM " + ALLTRIM(SM0->M0_CIDENT)
      Endif	            
      @ pRow()+1, 01 pSay "NA  " + SUBSTR(SM0->M0_ENDENT,1,35) + ",  DORAVANTE DESIGNADA DE EMPREGADORA E"
      @ pRow()+1, 01 pSay Subs(SRA->RA_NOME,1,30) + "PORTADOR DA CARTEIRA DE  TRABALHO E  PREVIDENCIA"
      @ pRow()+1, 01 pSay "SOCIAL N. " + Alltrim(SRA->RA_NUMCP) + ", SERIE N. " + Alltrim(SRA->RA_SERCP) + " A SEGUIR  DESIGNADO  EMPREGADO, E CELEBRADO" 
      @ pRow()+1, 01 pSay "O  PRESENTE  CONTRATO  DE  TRABALHO,  DE  ACORDO  COM  AS  CONDICOES A  SEGUIR"
      @ pRow()+1, 01 pSay "ESPECIFICADAS :"
      @ pRow()+2, 01 pSay "1. O  EMPREGADO  EXERCERA  AS  FUNCOES  DE  " + Substr(SRJ->RJ_DESC,1,20) + ",  MEDIANTE  A"
      @ pRow()+1, 01 pSay "REMUNERACAO DE (R$ "
      @ pRow()  , 20 pSay SRA->RA_SALARIO Picture "999,999.99"
      If SubStr(Extenso(SRA->RA_SALARIO),38,10)<>Space(10)
         @ pRow()  , 30 pSay ") "+SubStr(Extenso(SRA->RA_SALARIO),1,47)
         @ pRow()+1, 01 pSay AllTrim(SubStr(Extenso(SRA->RA_SALARIO),48,70)) + _cCateg
      Else
         @ pRow()  , 30 pSay ") "+SubStr(Extenso(SRA->RA_SALARIO),1,37) + _cCateg
      Endif
      @ pRow()+2, 01 pSay "2. O LOCAL DE TRABALHO SITUA-SE " + Alltrim(SUBSTR(SM0->M0_ENDENT,1,30)) + " AREA INDUSTRIAL."

      @ pRow()+2, 01 pSay "3. O  PAGAMENTO DE  SALARIO E  QUALQUER OUTRO  VALOR DEVIDO AO  EMPREGADO SERA"    
      @ pRow()+1, 01 pSay "CREDITADO EM CONTA CORRENTE BANCARIA."   

      @ pRow()+2, 01 pSay "4. FICA AJUSTADO NOS TERMOS DO PARAG. 1§ DO ART. 469 DA CONSOLIDACAO  DAS LEIS"   
      @ pRow()+1, 01 pSay "DO TRABALHO QUE A EMPREGADORA PODERA, A QUALQUER TEMPO, TRANSFERIR O EMPREGADO"
      @ pRow()+1, 01 pSay "PARA QUAISQUER OUTRAS LOCALIDADES DO PAIS."   

      @ pRow()+2, 01 pSay "5. ACEITA O EMPREGADO, EXPRESSAMENTE, A CONDICAO, PRESTAR SERVICOS EM QUALQUER"    
      @ pRow()+1, 01 pSay "DOS  TURNOS DE  TRABALHO, ISTO E, TANTO O  DIA  COMO A  NOITE,  OU EM TURNO DE"
      @ pRow()+1, 01 pSay "ESCALA  DE  JORNADA 6 X 2  E  4 X 4 DESDE QUE SEM SIMULTANEAMENTE,  OBSERVADAS" 
      @ pRow()+1, 01 pSay "PRESCRICOES LEGAIS REGULADORAS DO ASSUNTO,  QUANTO A REMUNERACAO."      

      @ pRow()+2, 01 pSay "6. EM CASO DE  DANO CAUSADO  PELO EMPREGADO, FICA A  EMPREGADORA  AUTORIZADA A"
      @ pRow()+1, 01 pSay "EFETUAR O DESCONTO DA IMPORTANCIA  CORRESPONDENTE AO  PREJUIZO, COM FUNDAMENTO"
      @ pRow()+1, 01 pSay "NO PARAG. 1§ DO ARTIGO 462 DA  CONSOLIDACAO DAS LEIS DO TRABALHO, VEZ QUE ESSA"
      @ pRow()+1, 01 pSay "POSSIBILIDADE FICA EXPRESSAMENTE PREVISTA EM CONTRATO."

      @ pRow()+2, 01 pSay "7. O PRAZO DESTE CONTRATO E DE 30 DIAS, COM  INICIO EM " + Dtoc(SRA->RA_ADMISSA) + " E TERMINO EM"
      @ pRow()+1, 01 pSay DtoC(SRA->RA_ADMISSA+29) + ", SENDO PRORROGADO POR MAIS 60 DIAS. "

      @ pRow()+2, 01 pSay "8. CONFORME ART. 472 PARAGRAFO 2o. DA CLT, O  EMPREGADO  CONCORDA  QUE O TEMPO"
      @ pRow()+1, 01 pSay "DE  AFASTAMENTO  NAO  SERA  COMPUTADO  NA  CONTAGEM  DO  PRAZO PARA RESPECTIVA" 
      @ pRow()+1, 01 pSay "TERMINACAO."

      @ pRow()+2, 01 pSay "9. PERMANECENDO  O  EMPREGADO  A  SERVICO  DA  EMPREGADORA  APOS  O TERMINO DA"
      @ pRow()+1, 01 pSay "EXPERIENCIA,  CONTINUARAO  EM   PLENA   VIGENCIA  CLAUSULAS  CONSTANTES  DESTE
      @ pRow()+1, 01 pSay "CONTRATO."          

      @ pRow()+2, 01 pSay "10. OPERA-SE  A RESCISAO DO PRESENTE CONTRATO PELA  DECORRENCIA DO PRAZO SUPRA"
      @ pRow()+1, 01 pSay "OU POR VONTADE DE UMA DAS PARTES, RESCINDINDO-SE POR VONTADE  DO  EMPREGADO OU"
      @ pRow()+1, 01 pSay "PELA EMPREGADORA COM JUSTA CAUSA, NENHUMA INDENIZACAO E DEVIDA, RESCINDINDO-SE"
      @ pRow()+1, 01 pSay "ANTES DO PRAZO, PELA EMPREGADORA, FICA ESTA OBRIGADA A PAGAR  50% DOS SALARIOS" 
      @ pRow()+1, 01 pSay "DEVIDOS ATE O FINAL (METADE DO PRAZO COMBINADO RESTANTE), NOS TERMOS DO ARTIGO"
      @ pRow()+1, 01 pSay "479 DA CLT, SEM PREJUIZO DO DISPOSTO REG. NO FGTS NENHUM AVISO PREVIO E "
      @ pRow()+1, 01 pSay "DEVIDO PELA RESCISAO DO PRESENTE CONTRATO.  RESCINDINDO-SE  POR VONTADE DO EM-"
      @ pRow()+1, 01 pSay "PREGADO ANTES DO PRAZO, FICA  ESTE  OBRIGADO A PAGAR  50% DOS SALARIOS DEVIDOS"
      @ pRow()+1, 01 pSay "ATE O FINAL DO CONTRATO NOS TERMOS DO ARTIGO 480 DA CLT."

      @ pRow()+2, 01 pSay "11. O EMPREGADO COMPROMETE-SE A SEGUIR TODAS AS NORMAS E PROCEDIMENTOS INTERNOS"
      @ pRow()+1, 01 pSay "DA EMPRESA, TAIS COMO: VEDACAO DE UTILIZACAO DE TELEFONES  CELULARES  NA PLANTA"
      @ pRow()+1, 01 pSay "INDUSTRIAL, PROIBICAO EM RELACAO AO FUMO E PROCEDIMENTO DE REVISTA, TENDO PLENA"
      @ pRow()+1, 01 pSay "CIENCIA QUE A EVENTUAL NAO OBSERVANCIA PARA COM  TAIS  NORMAS E  PROCEDIMENTOS,"
      @ pRow()+1, 01 pSay "CONFIGURARA INDISCIPLINA E/OU INSUBORDINACAO, QUEBRANDO  FIDUCIA IMPRESCINDIVEL"
      @ pRow()+1, 01 pSay "PARA  VIGENCIA  DO  CONTRATO  DE  TRABALHO,  SEM  PREJUIZO  DE  SER  APLICADA A"
      @ pRow()+1, 01 pSay "PENALIDADE DISCIPLINAR CABIVEL."

      @ pRow()+2, 01 pSay "PARAGRAFO PRIMEIRO: O  EMPREGADO  DECLARA  TER  PLENO E  IRRESTRITO  ACESSO,  A"
      @ pRow()+1, 01 pSay "QUALQUER  TEMPO  DURANTE  A  VIGENCIA  DO  CONTRATO DE  TRABALHO,  AS  NORMAS E"
      @ pRow()+1, 01 pSay "PROCEDIMENTOS  INTERNOS  DA   EMPRESA,  BEM  COMO  QUE  RECEBEU  TREINAMENTO DE"
      @ pRow()+1, 01 pSay "INTEGRACAO NO  QUAL  FORAM EXPOSTAS  TODAS  AS NORMAS E PROCEDIMENTOS INTERNOS,"
      @ pRow()+1, 01 pSay "INCLUSIVE, NO TOCANTE AO PROCEDIMENTO DE REVISTA."  

      @ 01,01 pSay ''
      @ pRow()+2, 01 pSay "PARAGRAGO  SEGUNDO: O  EMPREGADO  DECLARA  TER  CIENCIA  DE  QUE  AS  NORMAS  E"
      @ pRow()+1, 01 pSay "PROCEDIMENTOS INTERNOS DA EMPRESA DEVEM  SER  INTEGRALMENTE CUMPRIDOS, AS QUAIS"
      @ pRow()+1, 01 pSay "ADEREM AO CONTRATO DE TRABALHO E DEVEM SER OBSERVADAS PELAS PARTES, SOB PENA DE" 
      @ pRow()+1, 01 pSay "TERMINACAO DO CONTRATO DE TRABALHO NOS TERMOS DA LEI.

      @ pRow()+2, 01 pSay "E, POR ESTAREM  DE PLENO  ACORDO, AS  PARTES  ASSINAM O  PRESENTE  CONTRATO DE"
      @ pRow()+1, 01 pSay "TRABALHO, EM DUAS VIAS, FICANDO A PRIMEIRA EM PODER DA EMPREGADORA E A SEGUNDA"
      @ pRow()+1, 01 pSay "COM O EMPREGADO, QUE DELA DARA O COMPETENTE RECIBO."   

      @ pRow()+1, 60 pSay SRA->RA_ADMISSA

      @ pRow()+3, 01 pSay "EMPREGADOR"
      @ pRow()  , 41 pSay "EMPREGADO"

      @ pRow()+3, 01 pSay "TESTEMUNHAS"
      @ pRow()  , 41 pSay "TESTEMUNHAS"

      @ pRow()+3, 01 pSay "TERMO DE PRORROGACAO"
      @ pRow()+3, 01 pSay "POR MUTUO ACORDO ENTRE AS PARTES, O PRESENTE  CONTRATO DE EXPERIENCIA, DEVERIA"
      @ pRow()+1, 01 pSay "VENCER NESTA DATA FICA PRORROGADO ATE _____/_____/_____."
      @ pRow()+3, 01 pSay "EMPREGADOR"
      @ pRow()  , 41 pSay "EMPREGADO"
      @ pRow()+3, 01 pSay "TESTEMUNHAS"
      @ pRow()  , 41 pSay "TESTEMUNHAS"
   Next
   SRA->(DbSkip())
Enddo
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel)
Endif
MS_FLUSH()

Return
