#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0023a  ºAutor  ³Gustavo Henrique    º Data ³  23/set/02  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Regra para emissao do documento Regularidade de Estudos.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParam.    ³Nenhum.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 : Informando se obteve sucesso                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional - Requerimentos                          º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0023a()
local aArea		:= GetArea()
local aScript	:= ACScriptReq( JBH->JBH_NUM )
local aDados	:= {}
local aAss		:= {}
local cNumRA	:= Left( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )
local cDataExt	:= "São Paulo, "+Alltrim(Str(Day(dDatabase),2,0))+" de "+MesExtenso(Month(dDatabase))+" de "+StrZero(Year(dDatabase),4,0)+"."

Private cSEC	:= ""
Private cPRO	:= ""
                     
U_ASSREQ()

JA2->(dbSetOrder(1))
JA2->(dbSeek(xFilial("JA2")+cNumRA))

JAH->(dbSetOrder(1))
JAH->(dbSeek(xFilial("JAH")+aScript[1]))

aAdd( aDados, {"NOME"		, Alltrim(JA2->JA2_NOME) } )
aAdd( aDados, {"CURSO"		, Alltrim(Posicione("JAF",1,xFilial("JAF")+JAH->JAH_CURSO+JAH->JAH_VERSAO,"JAF_DESMEC")) } )
aAdd( aDados, {"INSTITUICAO", Alltrim(aScript[10]) } )
aAdd( aDados, {"HOJE"		, cDataExt } )
aAdd( aDados, {"ASSINATURA"	, "Profª. Luciene Fernandes de Souza" } )
aAdd( aDados, {"CARGO"		, "Secretária de Registros Acadêmicos" } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gerando variaveis para assinaturas 	                	              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAss := U_ACRetAss( cPRO )

aAdd( aDados, {"CASS1"   , aAss[1] })
aAdd( aDados, {"CCARGO1" , aAss[2] })
aAdd( aDados, {"CRG1"    , aAss[3] })

aAss := U_ACRetAss( cSEC )

aAdd( aDados, {"CASS2"   , aAss[1] })
aAdd( aDados, {"CCARGO2" , aAss[2] })
aAdd( aDados, {"CRG2"    , aAss[3] })

JBE->(dbSetOrder(1))
if JBE->(dbSeek(xFilial("JBE")+cNumRA+aScript[1]+aScript[3]+aScript[4]+aScript[6]))

	if JBE->JBE_ATIVO $ "256789A"	// Nao matriculado
		cSituacao	:=	"informamos que "+if(JA2->JA2_SEXO == "2", "a aluna", "o aluno")+" "+Alltrim(JA2->JA2_NOME)+" "+;
						"não renovou matrícula para o semestre em curso, estando, portanto, sem vínculo com este "+;
						"Centro Universitário, o que impossibilita a expedição da Guia de Transferência."
		cConclusao	:=	"Havendo interesse, o aluno poderá solicitar o Histórico Escolar e o Conteúdo Programático."
	elseif JBE->JBE_ATIVO == "4"	// Trancado
		cSituacao	:=	"informamos que "+if(JA2->JA2_SEXO == "2", "a aluna", "o aluno")+" "+Alltrim(JA2->JA2_NOME)+" "+;
						"encontra-se com a matrícula trancada no curso "+Alltrim(Posicione("JAF",1,xFilial("JAF")+JAH->JAH_CURSO+JAH->JAH_VERSAO,"JAF_DESMEC"))+" desde "+dtoc(JBE->JBE_DTSITU)+", "+;
						"de acordo com as Normas Regimentais deste Centro Universitário."
		cConclusao	:=	"Oportunamente, encaminharemos a Guia de Transferência."
	elseif JBE->JBE_ATIVO $ "13"	// Ativo
		cSituacao	:=	"atestamos a regularidade da condição d"+if(JA2->JA2_SEXO == "2", "a aluna", "o aluno")+" "+Alltrim(JA2->JA2_NOME)+", "+;
						"postulante ao ingresso neste Instituição de Ensino Superior, pela via de Transferência."
		cConclusao	:=	"Oportunamente, encaminharemos a Guia de Transferência."
	endif
	
	aAdd( aDados, {"SITUACAO"	, cSituacao		} )
	aAdd( aDados, {"CONCLUSAO"	, cConclusao	} )
	
	ACImpDoc( JBG->JBG_DOCUM, aDados )

endif

RestArea(aArea)
Return( .T. )
