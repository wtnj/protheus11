/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RHGP14    ºAutor  ³Microsiga           º Data ³  03/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime contrato de trabalho.                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch" 

User Function Rhgp14()

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("M_PAG,NOMEPROG,CPERG,_CCATEG,i")


cSavCur1 := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""
cabec1   := "";cabec2:="";cabec3:="";wnrel:=""
nOrdem   := 0
tamanho  := "P"
limite   := 132
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey := 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Contrato de Trabalho"
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""
cString  := "SRA"
nTipo    := 0
m_pag    := 1
nomeprog := "RHGP14"
cPerg    := 'RHGP07'
i        := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte('RHGP07',.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "RHGP14"
wnRel := SetPrint(cString,wnrel,cperg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

RptStatus({|| RHG014()})

Return Nil


Static Function RHG014()

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
	Endif
	
	IncRegua()

	For i := 1 To 2
		@        1, 23 pSay "* * "+ Alltrim(SM0->M0_NOMECOM) + " * *"
		@ pRow()+2, 23 pSay "C O N T R A T O   D E   T R A B A L H O"


        If SM0->M0_CODIGO == "FN"	.AND. SM0->M0_CODFIL == "02"	
   		      @ pRow()+3, 01 pSay "ENTRE A EMPRESA " + Subs(SM0->M0_NOMECOM,1,33) + ", COM SEDE EM " + ALLTRIM(SM0->M0_CIDENT)
        Else
		      @ pRow()+3, 01 pSay "ENTRE A EMPRESA " + Subs(SM0->M0_NOMECOM,1,40) + ", COM SEDE EM " + ALLTRIM(SM0->M0_CIDENT)
        Endif	            

		//@ pRow()+3, 01 pSay "ENTRE A EMPRESA " + Substr(SM0->M0_NOMECOM,1,40) + ", COM SEDE EM CURITIBA"

		@ pRow()+1, 01 pSay "NA  " + Substr(SM0->M0_ENDENT,1,35) + ", DORAVANTE  DESIGNADA DE EMPREGADORA E"
		@ pRow()+1, 01 pSay SRA->RA_NOME + "PORTADOR DA CARTEIRA DE  TRABALHO E  PREVIDENCIA"
		@ pRow()+1, 01 pSay "SOCIAL N. " + SRA->RA_NUMCP + ", SERIE N. " + SRA->RA_SERCP + " A SEGUIR DESIGNADO  EMPREGADO, E  CELEBRADO" 
		@ pRow()+1, 01 pSay "O  PRESENTE  CONTRATO  DE  TRABALHO,  DE  ACORDO  COM  AS  CONDICOES A  SEGUIR"
		@ pRow()+1, 01 pSay "ESPECIFICADAS :"
		@ pRow()+2, 01 pSay "1. O  EMPREGADO  EXERCERA  AS  FUNCOES  DE  " + SRJ->RJ_DESC + ",  MEDIANTE  A"
		@ pRow()+1, 01 pSay "REMUNERACAO DE (R$ "
		@ pRow()  , 20 pSay SRA->RA_SALARIO Picture "999,999.99"
		If SubStr(Extenso(SRA->RA_SALARIO),38,10)<>Space(10)
			@ pRow()  , 30 pSay ") "+SubStr(Extenso(SRA->RA_SALARIO),1,47)
			@ pRow()+1, 01 pSay AllTrim(SubStr(Extenso(SRA->RA_SALARIO),48,70)) + _cCateg
		Else
			@ pRow()  , 30 pSay ") "+SubStr(Extenso(SRA->RA_SALARIO),1,37) + _cCateg
		Endif
		@ pRow()+1, 01 pSay "2. O LOCAL DE TRABALHO SITUA-SE " + Substr(SM0->M0_ENDENT,1,30) + "AREA INDUSTRIAL."
		@ pRow()+1, 01 pSay "3. O  PAGAMENTO DE  SALARIO E  QUALQUER OUTRO  VALOR DEVIDO AO  EMPREGADO SERA"    
		@ pRow()+1, 01 pSay "CREDITADO EM CONTA CORRENTE BANCARIA."   
		@ pRow()+1, 01 pSay "4. FICA AJUSTADO NOS TERMOS DO PARAG. 1§ DO ART. 469 DA CONSOLIDACAO  DAS LEIS"   
		@ pRow()+1, 01 pSay "DO TRABALHO QUE A EMPREGADORA PODERA, A QUALQUER TEMPO, TRANSFERIR O EMPREGADO"
		@ pRow()+1, 01 pSay "PARA QUAISQUER OUTRAS LOCALIDADES DO PAIS."   
        @ pRow()+1, 01 pSay "5. ACEITA O EMPREGADO, EXPRESSAMENTE, A CONDICAO, PRESTAR SERVICOS EM QUALQUER"    
        @ pRow()+1, 01 pSay "DOS  TURNOS DE  TRABALHO, ISTO E, TANTO O  DIA  COMO A  NOITE,  OU EM TURNO DE"
        @ pRow()+1, 01 pSay "ESCALA DE JORNADA 4 X 4  E  6 X 2  DESDE  QUE  SEM SIMULTANEAMENTE, OBSERVADAS" 
        @ pRow()+1, 01 pSay "PRESCRICOES LEGAIS REGULADORAS DO ASSUNTO,  QUANTO A REMUNERACAO."      
		@ pRow()+1, 01 pSay "6. EM CASO DE  DANO CAUSADO  PELO EMPREGADO, FICA A  EMPREGADORA  AUTORIZADA A"
		@ pRow()+1, 01 pSay "EFETUAR O DESCONTO DA IMPORTANCIA  CORRESPONDENTE AO  PREJUIZO, COM FUNDAMENTO"
		@ pRow()+1, 01 pSay "NO PARAG. 1§ DO ARTIGO 462 DA  CONSOLIDACAO DAS LEIS DO TRABALHO, VEZ QUE ESSA"
		@ pRow()+1, 01 pSay "POSSIBILIDADE FICA EXPRESSAMENTE PREVISTA EM CONTRATO."
		@ pRow()+1, 01 pSay "7. O PRAZO  DESTE  CONTRATO E INDETERMINADO."
		@ pRow()+1, 01 pSay "8. A COMPENSACAO DE HORARIO SEMANAL E FEITA PARA OS FUNCIONARIOS QUE TRABALHAM"
		@ pRow()+1, 01 pSay "DE SEGUNDA A SEXTA-FEIRA."
		@ pRow()+1, 01 pSay "9. OPERA-SE  A RESCISAO DO  PRESENTE CONTRATO  PELA VONTADE DE  UMA DAS PARTES"
		@ pRow()+1, 01 pSay "RESCINDINDO-SE POR VONTADE DO  EMPREGADO OU PELA  EMPREGADORA COM JUSTA CAUSA,"
		@ pRow()+1, 01 pSay "NENHUMA INDENIZACAO E DEVIDA; RESCINDINDO-SE, PELA EMPREGADORA, ESTA SE REGERA"
		@ pRow()+1, 01 pSay "NA FORMA DA CLT, PELAS NORMAS APLICAVEIS AOS CONTRATOS DE PRAZO INDETERMINADO." 
		@ pRow()+1, 01 pSay "RESCINDINDO-SE PELO EMPREGADO  FICA ESTE SUJEITO  AS NORMAS DA CLT  APLICAVEIS"
		@ pRow()+1, 01 pSay "AOS CONTRATOS DE TRABALHO DE PRAZO INDETERMINADO."
		@ pRow()+1, 01 pSay "10. AJUSTANDO-SE AS CONDICOES INICIAIS DE TRABALHO SOB VINCULO EMPREGATICIO,AS"
		@ pRow()+1, 01 pSay "QUAIS IMPLICAM A  SUJEICAO DOS  CONTRATANTES AS  NORMAS  INTERNAS  DA EMPRESA,"
		@ pRow()+1, 01 pSay "ACORDOS E CONVENCOES COLETIVAS  E NORMAS LEGAIS E  ADMINISTRATIVAS  APLICAVEIS"
		@ pRow()+1, 01 pSay "PARTICULARMENTE, AS REFERENTES A SEGURANCA E MEDICINA DO TRABALHO."
		@ pRow()+3, 01 pSay "E, POR  ESTAREM  DE PLENO  ACORDO,  AS PARTES  ASSINAM O PRESENTE  CONTRATO DE" 
		@ pRow()+1, 01 pSay "TRABALHO, EM DUAS VIAS, FICANDO A PRIMEIRA EM PODER DA EMPREGADORA E A SEGUNDA"    
		@ pRow()+1, 01 pSay "COM O EMPREGADO, QUE DELA DARA O COMPETENTE RECIBO."
		@ pRow()+3, 01 pSay "CURITIBA, "+dToc(SRA->RA_ADMISSA)+"."
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
