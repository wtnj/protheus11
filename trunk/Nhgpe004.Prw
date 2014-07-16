/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RHGP12          ³ M.GracaNCarvalho      ³ Data ³ 13.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ AUTORIZACAO PARA DESCONTOS                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
#include "rwmake.ch"

User Function Nhgpe004()  

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("M_PAG,NOMEPROG,CPERG,")

cSavCur1 := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""
cabec1   := "";cabec2:="";cabec3:="";wnrel:=""
nOrdem   := 0
tamanho  := "P"
limite   := 132
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey := 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Autorizacao para Descontos"
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""
cString  := "SRA"
nTipo    := 0
m_pag    := 1
nomeprog := "RHGP12"
cPerg    := 'RHGP07'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte('RHGP07',.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "NHGPE004"
wnRel := SetPrint(cString,wnrel,cperg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif


RptStatus({|| RHG012()})

Return Nil


Static Function RHG012()
Local cAsMedic := Iif(SM0->M0_CODFIL=='02','UNIMED','  AMIL')

DbSelectArea("SRA")
DbSetOrder(01)

SRA->(DbGoTop())
SRA->(SetRegua(RecCount()))

SRA->(DbSeek(mv_par01+mv_par03,.T.))

While SRA->(!Eof()) .and. SRA->RA_FILIAL>=mv_par01 .and. SRA->RA_FILIAL<=mv_par02 .and. SRA->RA_MAT>=mv_par03 .and. SRA->RA_MAT<=mv_par04
   	
   	IncRegua()
   
   	@ 1, 22 pSay  "* * "+ ALLTRIM(SM0->M0_NOMECOM) + " * *" 
   	@ pRow()+2, 30 pSay "AUTORIZACAO PARA DESCONTO"
   	@ pRow()+1, 01 pSay Replicate("-",80)   
   	@ pRow()+1, 01 pSay "NOME : " + SRA->RA_NOME + "   REGISTRO : " + SRA->RA_MAT
   	@ pRow()+1, 01 pSay Replicate("-",80)   
   	@ pRow()+1, 01 pSay "REFEICAO / ALIMENTACAO"

	If SM0->M0_CODFIL=='01'
	   	@ pRow()+2, 04 pSay "Eu, abaixo assinado, autorizo o  desconto mensal em meu  Recibo de Pagamento" 
   		@ pRow()+1, 04 pSay "de Salario,  o valor  referente a  20% do valor pago por  refeicao a empresa"
	   	@ pRow()+1, 04 pSay "fornecedora da alimentacao."
	Else	   	
	   	@ pRow()+2, 04 pSay "Eu, abaixo assinado, autorizo o  desconto mensal em meu  Recibo de Pagamento" 
	   	@ pRow()+1, 04 pSay "de Salario,  o valor fixo de R$ 24,15 referente  a  refeicao  pago a empresa"
	   	@ pRow()+1, 04 pSay "fornecedora da alimentacao."
    Endif                            

   	@ pRow()+1, 50 pSay SRA->RA_ADMISSA
   	@ pRow()+2, 50 pSay "______________________________"
   	@ pRow()+1, 50 pSay SRA->RA_NOME
   	@ pRow()+1, 01 pSay Replicate("_",80)
   	@ pRow()+1, 01 pSay "ASSISTENCIA MEDICA"
   	@ pRow()+2, 04 pSay "Eu, abaixo assinado,  autorizo o desconto mensal em meu  Recibo de Pagamento" 
   	@ pRow()+1, 04 pSay "de Salario, referente a utilizacao do plano de Assistencia Medica feito  com"
   	@ pRow()+1, 04 pSay "a "+cAsMedic+", da  qual  classifico   minha   preferencia  em  questao,  opcional"
   	@ pRow()+1, 04 pSay "a qual passo a fazer parte como conveniado dando o direito de uso tambem aos"
   	@ pRow()+1, 04 pSay "meus dependentes legais, usufruindo de todos os beneficios e restricoes  que"
   	@ pRow()+1, 04 pSay "houverem em contrato firmado entre esta e "+ SM0->M0_NOMECOM 
   
    If SM0->M0_CODFIL=='01'
	   	@ pRow()+1, 04 pSay "A  parcela  que  ser-me-a  descontada  sera de 80%, proporcionais  ao  valor" 
	   	@ pRow()+1, 04 pSay "a opcao ENFERMARIA, ou como for de minha  preferencia, a  diferenca de plano"
	   	@ pRow()+1, 04 pSay "quando a opcao for APARTAMENTO."
    Else 
	   	@ pRow()+1, 04 pSay "Estou ciente que tanto a opção enfermaria quanto  a opção  apartamento  terá"
	   	@ pRow()+1, 04 pSay "coparticipação de 20% (vinte por cento ) conforme contrato firmado  entre  a"
		@ pRow()+1, 04 pSay "UNIMED e WHB FUNDIÇÃO S.A."
   	Endif
   
   	@ pRow()+2, 10 pSay "(    ) ENFERMARIA"
   	@ pRow()  , 40 pSay "(    ) APARTAMENTO"
   	@ pRow()+1, 01 pSay " "
   	SRB->(DbSetOrder(1))
   	SRB->(DbSeek(xFilial("SRB") + SRA->RA_MAT))

   	Do While SRA->(!EOF() ) .AND. SRB->(!EOF() .AND. SRA->RA_MAT == SRB->RB_MAT )
		@ pRow()+1,10 pSay "(    )" + Alltrim(SRB->RB_NOME) + " - " + Alltrim(SRB->RB_GRAUPAR) 
		SRB->(DbSkip() )
	EndDo  		
   				
	@ pRow()+2, 04 pSay "(   ) Nao manifesto interesse pelo beneficio, e estou ciente que na eventua-"
	@ pRow()+1, 04 pSay "lidade de sofrer algum tipo de acidente de trabalho ou doenca, serei encami-"
	@ pRow()+1, 04 pSay "nhado(a) a orgao publico."
	@ pRow()+1, 50 pSay SRA->RA_ADMISSA
	@ pRow()+2, 50 pSay "______________________________"
	@ pRow()+1, 50 pSay SRA->RA_NOME
	@ pRow()+1, 01 pSay Replicate("_",80)
	@ pRow()+1, 01 pSay "BENEFICIO - VALE - TRANSPORTE"
	@ pRow()+2, 04 pSay "Eu, abaixo assinado,  autorizo o desconto mensal em meu  Recibo de Pagamento"
	@ pRow()+1, 04 pSay "de Salario, referente  utilizacao do Vale-Transporte, no qual necessito para"
	@ pRow()+1, 04 pSay "conduzir-me do trajeto ( CASA PARA TRABALHO ) e  vice-versa, comprometo-me a"
	@ pRow()+1, 04 pSay "utilizar os  vales-transporte  que  me  forem  concedidos  exclusivamente no"
	@ pRow()+1, 04 pSay "percurso indicado e estou ciente de que a  declaracao  inexata que  induza o"
	@ pRow()+1, 04 pSay "empregador em erro ou uso  indevido dos  Vales-Transporte,  configura  justa"
	@ pRow()+1, 04 pSay "para  rescisao do  contrato  de trabalho  por ato de  improbidade,  caso nao"
	@ pRow()+1, 04 pSay "manifeste interesse assinale com um ( X )."
	@ pRow()+2, 04 pSay "(   ) Nao manifesto interesse pelo beneficio."
	@ pRow()+1, 50 pSay SRA->RA_ADMISSA
	@ pRow()+2, 50 pSay "______________________________"
	@ pRow()+1, 50 pSay SRA->RA_NOME
	@ pRow()+1, 01 pSay Replicate("_",80)
	
    SRA->(DbSkip())
    
Enddo

If aReturn[5] == 1
	Set Printer To
	Commit
   ourspool(wnrel)
Endif

MS_FLUSH()
Return
