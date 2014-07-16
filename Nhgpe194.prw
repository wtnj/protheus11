/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE194  ºAutor  ³Marcos R. Roquitski º Data ³  21/09/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Contrato de experiencia.                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³WHB                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"
#include "protheus.ch"
#INCLUDE "FIVEWIN.CH"

User Function NHGPE194()

cString		:= "SRA"
cDesc1		:= "Relatório de Serviço Social"
cDesc2      := ""
cDesc3      := ""      
tamanho		:= "P"
limite		:= 132
aReturn		:= { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHGPE194"
nLastKey	:= 0
titulo		:= OemToAnsi("Relatório de Contrato de Experiencia Grafico")
cabec2		:= ""
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1 //Variavel da pagina
M_PAG		:= 1
wnrel		:= "NHGPE194"
_cPerg		:= "RHGP07"
nCont		:= 0
nAlt 		:= 790
Private		nFunc

oFnt1 		:= TFont():New("Courier New"		,,14,,.T.,,,,,.T.)
oFnt2		:= TFont():New("Courier New"		,,12,,.T.,,,,,.F.)
oFnt3		:= TFont():New("Courier New"		,,10,,.T.,,,,,.F.)
oFnt4		:= TFont():New("Courier New"		,,08,,.T.,,,,,.F.)

Pergunte(_cPerg,.T.)

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,,,.F.,,,tamanho)

Processa( {|| Gerando()  },"Gerando relatório...")

Return


Static Function Gerando()

DbSelectArea("SRA")
DbSetOrder(1)

DbSelectArea("SRJ")
DbSetOrder(1)

DbSelectArea("SR6")
DbSetOrder(1)

SRA->(DbSeek(mv_par01+mv_par03))
While SRA->(!Eof()) .and. SRA->RA_FILIAL >= mv_par01 .and. SRA->RA_FILIAL <= mv_par02 .and. SRA->RA_MAT >= mv_par03 .and. SRA->RA_MAT <= mv_par04
	
	SRJ->(DbSeek(xFilial()+SRA->RA_CODFUNC,.T.))
	
	If SRA->RA_CATFUNC=="H"
		_cCateg:=" POR HORA."

	ElseIf SRA->RA_CATFUNC=="M"   
		_cCateg:=" POR MES ."

	Endif

	oPr:=tAvPrinter():New("Protheus")
	oPr:StartPage()

	oPr:Say(0100,800,"* * " + Alltrim(SM0->M0_NOMECOM) + " * *",oFnt1)
	oPr:Say(0300,600,"C O N T R A T O   D E   E X P E R I E N C I A",oFnt1)


	oPr:Say(0500,200,"ENTRE A EMPRESA " + Alltrim(SM0->M0_NOMECOM) + ", COM SEDE EM CURITIBA NA " + SUBSTR(SM0->M0_ENDENT,1,35) + ", DORAVANTE DESIGNADA",oFnt4)
	oPr:Say(0530,200,"DE EMPREGADORA E   "+Alltrim(SRA->RA_NOME)+ "  PORTADOR DA CARTEIRA DE  TRABALHO E  PREVIDENCIA SOCIAL N. " + Alltrim(SRA->RA_NUMCP) ,oFnt4)
	oPr:Say(0560,200,"SERIE N. " + Alltrim(SRA->RA_SERCP)+ " A SEGUIR DESIGNADO EMPREGADO, E CELEBRADO O PRESENTE CONTRATO DE TRABALHO, DE ACORDO ",oFnt4)
	oPr:Say(0590,200,"COM AS CONDICOES A SEGUIR ESPECIFICADAS:",oFnt4)

	oPr:Say(0650,200,"1. O  EMPREGADO  EXERCERA  AS  FUNCOES  DE  " + Substr(SRJ->RJ_DESC,1,20) + ", MEDIANTE  A REMUNERACAO DE (R$ " + Transform(SRA->RA_SALARIO,"999,999.99")+" )" )
	oPr:Say(0690,200,AllTrim(SubStr(Extenso(SRA->RA_SALARIO),1,70)) + _cCateg,oFnt4)

	oPr:Say(0750,200,"2. O LOCAL DE TRABALHO SITUA-SE " + Alltrim(SUBSTR(SM0->M0_ENDENT,1,30)) + " AREA INDUSTRIAL.",oFnt4)

	oPr:Say(0850,200,"3. O  PAGAMENTO DE  SALARIO E  QUALQUER OUTRO VALOR DEVIDO AO EMPREGADO SERA CREDITADO EM CONTA CORRENTE BANCARIA.",oFnt4)
	oPr:Say(0950,200,"4. FICA AJUSTADO NOS TERMOS DO PARAG. 1§ DO ART.469 DA CONSOLIDACAO DAS LEIS DO TRABALHO QUE A EMPREGADORA PODERA,",oFnt4)
	oPr:Say(0980,200,"A  QUALQUER TEMPO, TRANSFERIR, O EMPREGADO PARA QUAISQUER OUTRAS LOCALIDADES DO PAIS.",oFnt4)
	
	oPr:Say(1080,200,"5. ACEITA O EMPREGADO, EXPRESSAMENTE, A CONDICAO, PRESTAR SERVICOS EM QUALQUER  DOS  TURNOS  DE  TRABALHO, ISTO E,",oFnt4)
	oPr:Say(1110,200,"TANTO O DIA COMO A NOITE, OU EM TURNO DE ESCALA DE JORNADA 6 X 2 E 4 X 4 DESDE QUE SEM SIMULTANEAMENTE, OBSERVADAS",oFnt4)
	oPr:Say(1140,200,"PRESCRICOES LEGAIS REGULADORAS DO ASSUNTO, QUANTO A REMUNERACAO.",oFnt4)
	
	oPr:Say(1240,200,"6. EM CASO DE  DANO CAUSADO  PELO EMPREGADO, FICA  A EMPREGADORA  AUTORIZADA A EFETUAR O  DESCONTO  DA IMPORTANCIA" ,oFnt4)                              
	oPr:Say(1270,200,"CORRESPONDENTE  AO  PREJUIZO, COM FUNDAMENTO NO  PARAG. 1§ DO ARTIGO 462 DA CONSOLIDACAO DAS LEIS DO TRABALHO, VEZ",oFnt4)
	oPr:Say(1300,200,"QUE ESSA POSSIBILIDADE FICA EXPRESSAMENTE PREVISTA  EM CONTRATO.",oFnt4)

	oPr:Say(1400,200,"7. O PRAZO  DESTE  CONTRATO  E  DE 30 DIAS, COM INICIO EM " + Dtoc(SRA->RA_ADMISSA) + " E TERMINO EM "+DtoC(SRA->RA_ADMISSA+29) + ", SENDO PRORROGADO POR",oFnt4)
	oPr:Say(1430,200,"MAIS 60 DIAS.",oFnt4)

	oPr:Say(1500,200,"8. CONFORME ART. 472 PARAGRAFO 2o. DA CLT, O EMPREGADO CONCORDA QUE O TEMPO DE AFASTAMENTO  NAO  SERA COMPUTADO NA",oFnt4)
	oPr:Say(1530,200,"CONTAGEM DO PRAZO PARA RESPECTIVA TERMINACAO.",oFnt4)

	oPr:Say(1630,200,"9. PERMANECENDO O EMPREGADO  A  SERVICO DA  EMPREGADORA  APOS O  TERMINO  DA  EXPERIENCIA,  CONTINUARAO  EM  PLENA",oFnt4)
	oPr:Say(1660,200,"VIGENCIA CLAUSULAS CONSTANTES DESTE CONTRATO.",oFnt4)          

    oPr:Say(1760,200,"10. OPERA-SE  A RESCISAO DO PRESENTE CONTRATO PELA DECORRENCIA DO PRAZO SUPRA OU POR VONTADE  DE UMA  DAS  PARTES,",oFnt4)          
    oPr:Say(1790,200,"RESCINDINDO-SE POR VONTADE  DO  EMPREGADO OU  PELA  EMPREGADORA COM JUSTA  CAUSA,  NENHUMA   INDENIZACAO E DEVIDA,",oFnt4)          
    oPr:Say(1820,200,"RESCINDINDO-SE ANTES  DO  PRAZO, PELA EMPREGADORA, FICA ESTA  OBRIGADA  A  PAGAR 50%  DOS  SALARIOS DEVIDOS  ATE O",oFnt4)          
    oPr:Say(1850,200,"FINAL (METADE DO PRAZO COMBINADO  RESTANTE), NOS TERMOS DO  ARTIGO  479  DA   CLT,   SEM    PREJUIZO  DO  DISPOSTO",oFnt4)           
	oPr:Say(1880,200,"REG. NO FGTS NENHUM  AVISO  PREVIO E DEVIDO PELA   RESCISAO  DO  PRESENTE  CONTRATO.  RESCINDINDO-SE  POR  VONTADE",oFnt4)           
	oPr:Say(1910,200,"DO  EM-PREGADO  ANTES  DO  PRAZO, FICA  ESTE OBRIGADO A PAGAR  50%  DOS  SALARIOS DEVIDOS  ATE O FINAL DO CONTRATO",oFnt4)          
    oPr:Say(1940,200,"NOS TERMOS DO ARTIGO 480 DA CLT.",oFnt4)          

    oPr:Say(2040,200,"11.O EMPREGADO COMPROMETE-SE A SEGUIR TODAS AS NORMAS E PROCEDIMENTOS  INTERNOS  DA  EMPRESA, TAIS  COMO:  VEDACAO",oFnt4)          
    oPr:Say(2070,200,"DE UTILIZACAO DE TELEFONES CELULARES NA PLANTA INDUSTRIAL, PROIBICAO EM RELACAO AO FUMO E PROCEDIMENTO DE REVISTA,",oFnt4)          
    oPr:Say(2100,200,"TENDO PLENA CIENCIA QUE A EVENTUAL NAO OBSERVANCIA OBSERVANCIA PARA COM TAIS NORMAS E PROCEDIMENTOS,   CONFIGURARA",oFnt4)           
    oPr:Say(2130,200,"INDISCIPLINA  E/OU  INSUBORDINACAO, QUEBRANDO  FIDUCIA  IMPRESCINDIVEL  PARA VIGENCIA DO CONTRATO DE TRABALHO, SEM",oFnt4)           
    oPr:Say(2160,200,"PREJUIZO  DE  SER  APLICADA A PENALIDADE DISCIPLINAR CABIVEL.",oFnt4)
    
    oPr:Say(2260,200,"PARAGRAFO PRIMEIRO: O EMPREGADO DECLARA TER PLENO E IRRESTRITO ACESSO, A  QUALQUER  TEMPO  DURANTE  A  VIGENCIA DO",oFnt4)
    oPr:Say(2290,200,"CONTRATO DE TRABALHO, AS  NORMAS  E  PROCEDIMENTOS  INTERNOS  DA  EMPRESA,  BEM  COMO  QUE  RECEBEU TREINAMENTO DE",oFnt4)
    oPr:Say(2320,200,"INTEGRACAO  NO  QUAL  FORAM  EXPOSTAS  TODAS  AS  NORMAS  E  PROCEDIMENTOS  INTERNOS,  INCLUSIVE,  NO   TOCANTE AO",oFnt4)
    oPr:Say(2350,200,"PROCEDIMENTO DE REVISTA.",oFnt4)
    
    oPr:Say(2450,200,"PARAGRAGO SEGUNDO: O EMPREGADO DECLARA TER CIENCIA  DE  QUE  AS  NORMAS  E PROCEDIMENTOS INTERNOS DA EMPRESA DEVEM",oFnt4)          
    oPr:Say(2480,200,"SER INTEGRALMENTE CUMPRIDOS, AS QUAIS ADEREM AO CONTRATO  DE  TRABALHO  E  DEVEM  SER OBSERVADAS PELAS PARTES, SOB",oFnt4)          
    oPr:Say(2510,200,"PENA DE TERMINACAO DO CONTRATO  DE TRABALHO  NOS  TERMOS DA LEI.  E, POR  ESTAREM  DE   PLENO  ACORDO,  AS  PARTES",oFnt4)          
    oPr:Say(2540,200,"ASSINAM O PRESENTE  CONTRATO  DE  TRABALHO, EM  DUAS VIAS, FICANDO  A  PRIMEIRA   EM  PODER  DA  EMPREGADORA  E  A",oFnt4)          
	oPr:Say(2570,200,"SEGUNDA COM O EMPREGADO, QUE DELA DARA O COMPETENTE RECIBO.",oFnt4)          
	
	oPr:Say(2670,200,Dtoc(SRA->RA_ADMISSA),oFnt4)

	oPr:Say(2770,200,"EMPREGADOR                               EMPREGADO",oFnt4)          
	oPr:Say(2870,200,"TESTEMUNHAS                              TESTEMUNHAS",oFnt4)          

	oPr:Say(2970,200,"TERMO DE PRORROGACAO POR MUTUO ACORDO ENTRE AS PARTES,",oFnt4)          
	oPr:Say(3000,200,"O PRESENTE  CONTRATO DE EXPERIENCIA, DEVERIA VENCER NESTA DATA FICA PRORROGADO ATE _____/_____/_____.",oFnt4)          

	oPr:Say(3100,200,"EMPREGADOR                               EMPREGADO",oFnt4)          
	oPr:Say(3200,200,"TESTEMUNHAS                              TESTEMUNHAS",oFnt4)          

	oPr:EndPage()                                                         

	SRA->(DbSkip())

Enddo	
oPr:EndPage()                                                        
oPr:Preview()
Return
