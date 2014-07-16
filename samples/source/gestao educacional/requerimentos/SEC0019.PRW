#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

#Include "TOPCONN.CH"
#Include "RWMAKE.CH"
#Include "MSOLE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SEC0019	³ Autor ³  Regiane R. Barreira  ³ Data ³ 04/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emite Criterio de Avaliacao						       	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Especifico Academico 							          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SEC0019()

//Declaração de Variáveis e Valores
Local nPeriodos := 0
Local cRa		:= ""
Local cAtivo	:= ""
Local cSituacao := ""
Local aSer_cur  := Array( 10, 2 )
Local aDiaSem   := {}
Local aHora1    := {}
Local aHora2    := {}
Local aDados    := {}
Local aAss		:= {}
Local Mes :=""
Local Escre_Mes :=" "
Local Ano:=""
Local cCodCur := ""
Local cPerLet := ""
Local cHabili := ""
Local cTurma  := ""

cPRO := Space(6)
cSEC := Space(6)

aSer_cur[1]:={"01","primeiro"}
aSer_cur[2]:={"02","segundo"}
aSer_cur[3]:={"03","terceiro"}
aSer_cur[4]:={"04","quarto"}
aSer_cur[5]:={"05","quinto"}
aSer_cur[6]:={"06","sexto"}
aSer_cur[7]:={"07","sétimo"}
aSer_cur[8]:={"08","oitavo"}
aSer_cur[9]:={"09","nono"}
aSer_cur[10]:={"10","décimo"}

//Chamada da rotina de escolha de assinaturas....
Processa({||U_ASSREQ() })

JBE->( dbSetOrder( 1 ) )
JBE->( dbSeek( xFilial( "JBE" ) +  Left( JBH->JBH_CODIDE,15) ) )

// Verifica Se o Aluno Está Ativo
cRA := JBE->JBE_NUMRA
Do While JBE->( ! EoF() .and. JBE_NUMRA == Left( JBH->JBH_CODIDE,15) )
	
	cAtivo := JBE->JBE_ATIVO
	cCodCur := JBE->JBE_CODCUR
	cPerLet := JBE->JBE_PERLET
	cHabili := JBE->JBE_HABILI
	cTurma  := JBE->JBE_TURMA
	
	JBE->( dbSkip() )
	
	If cRA # JBE->JBE_NUMRA
		Exit
	EndIf
	
Enddo

If cAtivo == "1"
	cSituacao := "é"
Else
	cSituacao := "foi"
EndIf

//Procura Ato Legal do Curso
cAtoLegal := msmm( AcDecret(Posicione( "JAH", 1, xFilial( "JAH" ) + JBE->JBE_CODCUR, "JAH_CURSO"),JBE->JBE_DCOLAC))
if  cAtoLegal==""
	cAtoLegal:="Não Encontrado"
endif
//Fim da Procura 

// Verifica grade de aulas por disciplina
JC7->( dbSetOrder( 1 ) )
JC7->( dbSeek( xFilial( "JC7" ) + cRA + cCodCur + cPerLet + cHabili + cTurma ) )

Do While JC7->( ! EoF() .and. JC7_NUMRA + JC7_CODCUR + JC7_PERLET + JC7_HABILI + JC7_TURMA) == cRA + cCodCur + cPerLet + cHabili + cTurma
	
	// Se a situacao da disciplina for Normal, gera vetores com os dias da semana que o aluno tem aulas e
	// com as horas iniciais e finais
	If JC7->JC7_SITDIS == "010"		// Situacao: "Normal"
		
		AAdd( aDiaSem, JC7->JC7_DIASEM )	// Dias da semana. 1=Domingo, 2=Segunda, 3=Terca ...
		AAdd( aHora1 , JC7->JC7_HORA1  )	// Hora inicial da disciplina
		AAdd( aHora2 , JC7->JC7_HORA2  )	// Hora final da disciplina
		
	EndIf
	
	cChave := JC7->( JC7_NUMRA + JC7_CODCUR + JC7_PERLET + JC7_HABILI + JC7_TURMA )
	
	JC7->( dbSkip() )
	
	If cChave # JC7->( JC7_NUMRA + JC7_CODCUR + JC7_PERLET + JC7_HABILI + JC7_TURMA )
		Exit
	EndIf
	
EndDo
//Fim da Verificação de Grades por Disciplina 

//Envia variáveis para Documento Word                              
JAH->( dbSetOrder( 1 ) )
JAH->( dbSeek( xFilial("JAH") + cCodCur ) )

AAdd( aDados, { "CURSO"  ,ALLTRIM(Posicione("JAF",1,xFilial("JAF")+JAH->JAH_CURSO+JAH->JAH_VERSAO,"JAF_DESMEC"))} )
AAdd( aDados, { "ATOLEGAL"  , cAtoLegal} )
AAdd( aDados, { "RA"         ,ALLTRIM( JBH->JBH_CODIDE )} )
AAdd( aDados, { "NOME"       , ALLTRIM(Posicione( "JA2", 1, xFilial( "JA2" ) + JBH->JBH_CODIDE, "JA2_NOME" )) } )
AAdd( aDados, { "SITUACAO",cSituacao} )
AAdd( aDados, { "TURNO",Lower(AllTrim(Tabela('F5',Posicione( "JAH", 1, xFilial( "JAH" ) + cCodCur, "JAH_TURNO" ),.F.)))} )
AAdd( aDados, { "SERIE",StrZero(Val(cPerLet),1)} )                                                                                       
nSerie := aScan(aSer_cur, { |x| x[1] == cPerLet } )
AAdd(aDados, { "NOME_SERIE",aSer_Cur[nSerie,2]} )
AAdd(aDados,{ "DATA", AllTrim(SM0->M0_CIDCOB)+", " + SubStr(DtoC(dDataBase),1,2) + " de " + MesExtenso(Val(SubStr(DtoC(dDataBase),4,2))) + " de " + AllTrim(Str(Year(dDataBase))) })
AAdd(aDados,{"DT_ANO", AllTrim(Str(Year(dDataBase))) })
Aadd(aDados, { "DHABILI", Iif(Empty(cHabili), " ", ", na Habilitação " + AllTrim(Posicione("JDK",1,xFilial("JDK") + cHabili,"JDK_DESC"))) })
//Fim do envio das Variáveis
 
//Verifica Sexo do Aluno para escrever no documento
aSexo:= ALLTRIM(Posicione( "JA2", 1, xFilial( "JA2" ) + JBH->JBH_CODIDE, "JA2_SEXO" ))

If aSexo=="1" 
   aSexo:="o" 
ElseIF aSexo=="2"
   aSexo:="a"
EndIf

AAdd( aDados, { "SEXO" ,aSexo } )

//Fim da Verificação

//Verificação para escrever o periodo do Semestre do Aluno na Avaliação de Rendimento Escolar   
Ano:=AllTrim(Str(Year(dDataBase)))
Mes:= SubStr(DtoC(dDataBase),4,2)

If (Mes>="01" .AND. Mes<="06")
	Escre_Mes:="fevereiro a junho de" + Ano
ElseIf (Mes>="08" .AND. Mes<="12")
	Escre_Mes:="agosto a dezembro de" + Ano
EndIf

AAdd(aDados,{"PER_M", Escre_Mes})

// Verifica a Assinatura do Documento
aAss := U_ACRetAss( cPRO )

AAdd( aDados, { "cASS1"  , aAss[1] } )
AAdd( aDados, { "cCARGO1", aAss[2] } )
AAdd( aDados, { "cRG1"   , aAss[3] } )

aAss := U_ACRetAss( cSEC )

AAdd( aDados, { "cASS2"  , aAss[1] } )
AAdd( aDados, { "cCARGO2", aAss[2] } )
AAdd( aDados, { "cRG2"   , aAss[3] } )

// Verifica quantos semestres tem o curso.
nPeriodos := 0

JAR->( dbSetOrder( 1 ) )
JAR->( dbSeek( xFilial( "JAR" ) + cCodCur ) )

Do While JAR->( ! EoF() .and. JAR_FILIAL + JAR_CODCUR == xFilial( "JAR" ) + cCodCur )
	nPeriodos ++
	JAR->( dbSkip() )
EndDo

AAdd( aDados, { "DURACAO", nPeriodos } )
AAdd( aDados, { "NOME_DURACAO", Lower(Extenso( nPeriodos, .T., 1 )) } )
//Fim da Verificação

//Função de Envio das variáveis para o documento Word
ACImpDoc( JBG->JBG_DOCUM, aDados )

Return( .T. )
