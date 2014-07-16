#Include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC001a   ºAutor  ³                    º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Regra da Secretaria no requerimento de Declaracao de        º±±
±±º          ³Matricula.                                                  º±±
±±º          ³Prepara o documento .DOT com os dados do aluno e curso      º±±
±±º          ³solicitados.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParam.    ³Nenhum                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³Nenhum                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional - Requerimentos                          º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Rafael Rodr.³14/06/02³------³Emissao do documento para o curso especi- ³±±
±±³            ³        ³      ³ficado no script. Estava emitindo sempre  ³±±
±±³            ³        ³      ³para o primeiro curso ativo do aluno.     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0001()

Local nPeriodos := 0
Local nPos		:= 0
Local cAtoLegal := ""
Local OBS       := ""
Local cSituacao := ""
Local cNomSer	:= ""
Local cRegime	:= ""
Local aSer_cur  := Array( 10 )
Local aDias		:= Array( 7 )
Local aDiaSem   := {}
Local aDados    := {}
Local aScript	:= {}
Local aAss		:= {}
Local lSeq		:= .T.
Local aHoras	:= {}
Local cCursando	:= ""
Local i         := 0
Local j         := 0

cPRO := Space(6)
cSEC := Space(6)

aDias[1]  := "domingo"
aDias[2]  := "2ª feira"
aDias[3]  := "3ª feira"
aDias[4]  := "4ª feira"
aDias[5]  := "5ª feira"
aDias[6]  := "6ª feira"
aDias[7]  := "sábado"

aSer_cur[1]  := {"01","primeiro"}
aSer_cur[2]  := {"02","segundo"}
aSer_cur[3]  := {"03","terceiro"}
aSer_cur[4]  := {"04","quarto"}
aSer_cur[5]  := {"05","quinto"}
aSer_cur[6]  := {"06","sexto"}
aSer_cur[7]  := {"07","sétimo"}
aSer_cur[8]  := {"08","oitavo"}
aSer_cur[9]  := {"09","nono"}
aSer_cur[10] := {"10","décimo"}
cVar := ""
//Chamada da rotina de escolha de assinaturas....
Processa({||U_ASSREQ(cVar) })

aScript := ACScriptReq( JBH->JBH_NUM )

// Posiciona matricula do aluno
JBE->( dbSetOrder( 1 ) )
JBE->( dbSeek( xFilial( "JBE" ) +  Padr( JBH->JBH_CODIDE,15) + aScript[1]  + aScript[3] + aScript[4]) )

// Posiciona cadastro de curso vigente
JAH->( dbSetOrder( 1 ) )
JAH->( dbSeek( xFilial( "JAH" ) + JBE->JBE_CODCUR ) )

// UNIDADE
JA3->( dbSetOrder(1))
JA3->( dbSeek( xFilial( "JA3" ) + JAH->JAH_UNIDAD ) )

// Posiciona curso padrao
JAF->( dbSetOrder( 1 ) )
JAF->( dbSeek( xFilial( "JAF" ) + JAH->( JAH_CURSO + JAH_VERSAO ) ) )    


JCF->(dbSetOrder(1))                    
JCF->(DBGOTOP())
JCF->(dbSeek(xFilial("JCF")+JAF->JAF_COD))
dAtual := ""
WHILE ALLTRIM(JCF->JCF_CURSO) == ALLTRIM(JAF->JAF_COD)
IF DTOS(JCF->JCF_DATA1) <= DTOS(JBE->JBE_DTMATR) .AND. DTOS(JCF->JCF_DATA2) >= DTOS(JBE->JBE_DTMATR)
	dAtual := DTOS(JCF->JCF_DATA1)
ENDIF
	JCF->(dbskip())
enddo
if !empty(dAtual)
	JCF->(dbSeek(xFilial("JCF")+JAF->JAF_COD+dAtual))
else
	JCF->(dbSeek(xFilial("JCF")+JAF->JAF_COD))
endif

If JBE->JBE_ATIVO == "1"
	cSituacao := "é"
Else
	cSituacao := "foi"
EndIf

cAtoLegal := msmm( JCF->JCF_MEMO3 )
OBS		 := msmm( JBH->JBH_MEMO1 )
if Empty(cAtoLegal)
	cAtoLegal:="Não Cadastrado"
endif
if !Empty(OBS)
	OBS := ", "+alltrim(OBS) + "."
ELSEif !Empty(cVar)
	OBS := ", " + ALLTRIM(cVar) + "."
ELSE
	OBS := "."
endif

JBL->( dbSetOrder( 1 ) )
JBL->( dbSeek( xFilial( "JBL" ) + JBE->( JBE_CODCUR + JBE_PERLET + JBE_HABILI + JBE_TURMA ) ) )

while JBL->( ! EoF() .And. JBL_FILIAL + JBL_CODCUR + JBL_PERLET + JBL_HABILI + JBL_TURMA == xFilial("JBL") + JBE->( JBE_CODCUR + JBE_PERLET  + JBE_HABILI + JBE_TURMA ) )
	   
	nPos := aScan( aDiaSem, { |x| x[1] == JBL->JBL_DIASEM } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se encontrar o dia da semana atualiza hora inicial ou final ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if nPos # 0
 		if JBL->JBL_HORA1 < aDiaSem[ nPos, 2 ] 
 			aDiaSem[ nPos, 2 ] := JBL->JBL_HORA1
 		elseif JBL->JBL_HORA2 > aDiaSem[ nPos, 3 ]
 			aDiaSem[ nPos, 3 ] := JBL->JBL_HORA2
 		endif	
 	else
		JBL->( AAdd( aDiaSem, { JBL_DIASEM, JBL_HORA1, JBL_HORA2 } ) )	
	endif

	JBL->( dbSkip() )

end

if len( aDiaSem ) == 0
	Aviso( "Problema", "Este aluno não está cursando nenhuma disciplina no curso, período letivo e turma informados, ou é um aluno provisório.", {"Ok"} )
	Return
endif

aDiaSem := aSort( aDiaSem,,, { |x,y| x[2] + x[3] < y[2] + y[3] } )

for i := 1 to len( aDiaSem )
	cHora := aDiaSem[i,2]+aDiaSem[i,3]
	aAdd( aHoras, {} )
	while i <= len(aDiaSem) .and. cHora == aDiaSem[i,2]+aDiaSem[i,3]
		aAdd( aHoras[len(aHoras)], aDiaSem[i] )
		i++
	end
next i

for i := 1 to len( aHoras )
	aHoras[i] := aSort( aHoras[i],,, { |x,y| x[1] < y[1] } )
next
 
aHoras := aSort( aHoras,,, { |x,y| x[1,1] < y[1,1] } )
      
for i := 1 to len( aHoras )
	if len( aHoras[i] ) == 1
		cCursando += if( i > 1, ", ", "de ")+aDias[Val(aHoras[i,1,1])]+" das "+aHoras[i,1,2]+"h. às "+aHoras[i,1,3]+"h."
	else
		lSeq := .T.
		for j := 1 to len( aHoras[i] )
   			if j < len( aHoras[i] ) .And. val( aHoras[i,j,1] )+1 <> val( aHoras[i,j+1,1] )
		    	lSeq := .F.
		    endif
		next j

		if lSeq
			cCursando += if( i > 1, ", ", "de ")+aDias[Val(aHoras[i,1,1])]+" a "+aDias[Val(aHoras[i,len(aHoras[i]),1])]+" das "+aHoras[i,1,2]+"h. às "+aHoras[i,1,3]+"h."
		else
			for j := 1 to len( aHoras[i] )
				cCursando += if( j > 1, ", ", "de ")+aDias[Val(aHoras[i,j,1])]
			next j
			cCursando += " das "+aHoras[i,1,2]+"h. às "+aHoras[i,1,3]+"h."
		endif
	endif
next i

nSerie := aScan(aSer_cur, { |x| x[1] == JBE->JBE_PERLET } )

// Se for Pos-Graduacao
If JAH->JAH_GRUPO == "005"
	cNomSer := 'curso de pós-graduação "' + RTrim( Lower( Posicione( "JAG", 1, xFilial( "JAG" ) + JAF->JAF_AREA, "JAG_DESC" ) ) ) + '" em'
ElseIf JAH->JAH_GRUPO # "005"
	cNomSer := StrZero( Val( JBE->JBE_PERLET ), 1 ) + "º (" + aSer_Cur[nSerie,2] + ") período letivo do curso de "
EndIf

// Verifica quantos semestres tem o curso.
nPeriodos := 0

JAR->( dbSetOrder( 1 ) )
JAR->( dbSeek( xFilial( "JAR" ) + JBE->JBE_CODCUR ) )

Do While JAR->( ! EoF() .and. JAR_FILIAL + JAR_CODCUR == xFilial( "JAR" ) + JBE->JBE_CODCUR )
	nPeriodos ++
	JAR->( dbSkip() )
EndDo

// Verifica regime do curso
If JAF->JAF_REGIME == "001"		// Anual
	cRegime	:= " ano(s)"
ElseIf JAF->JAF_REGIME == "002"
	cRegime	:= " semestre(s)"
ElseIf JAF->JAF_REGIME == "003"
	cRegime	:= " trimestre(s)"
ElseIf JAF->JAF_REGIME == "004"
	cRegime	:= " bimestre(s)"
EndIf

aAdd( aDados, { "NOME_CURSO"	, RTrim(JAF->JAF_DESMEC) } ) // ESTAVA JAF->JAF_DESMEC
aAdd( aDados, { "ATOLEGAL"		, cAtoLegal} )
aAdd( aDados, { "RA"				, ALLTRIM( JBH->JBH_CODIDE )} )
aAdd( aDados, { "NOME"			, ALLTRIM(Posicione( "JA2", 1, xFilial( "JA2" ) + JBH->JBH_CODIDE, "JA2_NOME" ))} )
aAdd( aDados, { "SITUACAO"		, cSituacao} )
aAdd( aDados, { "TURNO"			, Lower( AllTrim( Tabela( 'F5', JAH->JAH_TURNO,.F. ) ) ) } )
aAdd( aDados, { "NOME_SERIE"	, cNomSer } )
aAdd( aDados, { "DATA"			, "São Paulo, " + SubStr(DtoC(dDataBase),1,2) + " de " + MesExtenso(Val(SubStr(DtoC(dDataBase),4,2))) + " de " + AllTrim(Str(Year(dDataBase))) })
aAdd( aDados, { "NOME_HAB"		, ", habilitação " + AllTrim(Posicione( "JDK", 1, xFilial("JDK") + JBE->JBE_HABILI, "JDK_DESC" )) } )
aAdd( aDados, { "cOBS"			, OBS } )
aAdd( aDados, { "cUnidade"		, alltrim(ja3->ja3_desloc) } )
aAdd( aDados, { "cEmail"		,ALLTRIM(Posicione( "JA2", 1, xFilial( "JA2" ) + JBH->JBH_CODIDE, "JA2_EMAIL" ))} )
aAdd( aDados, { "cFonRes"		,ALLTRIM(Posicione( "JA2", 1, xFilial( "JA2" ) + JBH->JBH_CODIDE, "JA2_FRESID" ))} )
aAdd( aDados, { "cFoneCom"		,ALLTRIM(Posicione( "JA2", 1, xFilial( "JA2" ) + JBH->JBH_CODIDE, "JA2_FCELUL" )) } )
aAdd( aDados, { "cDocum"		,ALLTRIM(JBF->JBF_DESC)} )
aAdd( aDados, { "cDIAA"			,ALLTRIM(DTOC(DDATABASE))} )
// Verifica a Assinatura do Documento
aAss := U_ACRetAss( cSEC )

AAdd( aDados, { "cAss1"  , aAss[1] } )
AAdd( aDados, { "cCargo1", aAss[2] } )
AAdd( aDados, { "cRG1"   , aAss[3] } )

aAss := U_ACRetAss( cPRO )

AAdd( aDados, { "cAss2"  , aAss[1] } )
AAdd( aDados, { "cCargo2", aAss[2] } )
AAdd( aDados, { "cRG2"   , aAss[3] } )
AAdd( aDados, { "HORARIO", cCursando } )
AAdd( aDados, { "DURACAO"		, nPeriodos } )
AAdd( aDados, { "NOME_DURACAO"	, Lower(Extenso( nPeriodos, .T., 1 )) } )
AAdd( aDados, { "REGIME" , cRegime } )

ACImpDoc( JBG->JBG_DOCUM, aDados )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC001B   ºAutor  ³ Gustavo Henrique   º Data ³ 28/08/2002  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Verificar se o aluno estah cursando alguma disciplina no    º±±
±±º          ³curso, periodo letivo e turma selecionados.                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Nenhum                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³Nenhum                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional - Requerimentos                          º±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0001B( lWeb )

Local lRet := .F.
Local aRet := {}

lWeb := If( lWeb == NIL, .F., lWeb )

JA2->( dbSetOrder( 1 ) )
JBE->( dbSetOrder( 1 ) )
JC7->( dbSetOrder( 1 ) )

lRet := JBE->( dbSeek( xFilial( "JBE" ) +  Padr( M->JBH_CODIDE, 15 ) + M->JBH_SCP01 + M->JBH_SCP03 + M->JBH_SCP04 ) )

If lRet
	
	// Verifica se o aluno estah cursando pelo menos uma disciplina
	lRet := JC7->( dbSeek( xFilial( "JC7" ) + JBE->( JBE_NUMRA + JBE_CODCUR + JBE_PERLET + JBE_HABILI + JBE_TURMA ) ) )
	
	If lRet
		
		While JC7->( ! EoF() .and. JC7_NUMRA + JC7_CODCUR + JC7_PERLET + JC7_HABILI + JC7_TURMA == JBE->( JBE_NUMRA + JBE_CODCUR + JBE_PERLET + JBE_HABILI + JBE_TURMA ) )
			
			If JC7->JC7_SITDIS == "010"		// Situacao: "Normal"
				lRet := .T.
				Exit
			EndIf
			JC7->( dbSkip() )
			
		EndDo
		
	EndIf
	
EndIf

If lRet
	If ! JA2->( dbSeek( xFilial( "JA2" ) +  Padr( M->JBH_CODIDE,15) )) .or. JA2->JA2_STATUS == "2"
		lRet := .F.
	EndIf
EndIf

If ! lRet
	If ! lWeb
		MsgStop( "Este aluno não está cursando nenhuma disciplina no curso, período letivo e turma informados, ou é um aluno provisório." )
	Else
		AAdd( aRet, { .F., "Este aluno não está cursando nenhuma disciplina no curso, período letivo e turma informados, ou é um aluno provisório." } )
		Return aRet
	EndIf
EndIf

Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PROTOCOLO DE RETIRADA                 º Data ³  08/30/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ IMPRIME O PRTOCOLO DE RETIRADA                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION ProRet()

Local aDados    := {}

//aScript := ACScriptReq( JBH->JBH_NUM )

// Posiciona matricula do aluno
JA2->( dbSetOrder( 1 ) )
JA2->( dbSeek( xFilial( "JA2" ) + ALLTRIM(JBH->JBH_CODIDE) ) )

JBE->(dbSetOrder(1))
JBE->(dbSeek(xFilial("JBE")+ALLTRIM(JA2->JA2_NUMRA)))
nN	:= "1"
WHILE ALLTRIM(JA2->JA2_NUMRA) == alltrim(JBE->JBE_NUMRA)
	IF JBE->JBE_ATIVO = "5"
		nN	:= "5"
	ELSEIF JBE->JBE_ATIVO = "1"
		nN	:= "1"  
	ELSEIF JBE->JBE_ATIVO = "3"
		nN	:= "3"
	ENDIF
	JBE->(DbSkip())
end
// Posiciona cadastro de curso vigente
JBE->(dbSetOrder(3))
JBE->(dbSeek(xFilial("JBE")+nN+ALLTRIM(JA2->JA2_NUMRA)))
JAH->( dbSetOrder( 1 ) )
JAH->( dbSeek( xFilial( "JAH" ) + ALLTRIM(JBE->JBE_CODCUR) ) )

// UNIDADE
JA3->( dbSetOrder(1))
JA3->( dbSeek( xFilial( "JA3" ) + JAH->JAH_UNIDAD ) )

// Posiciona curso padrao
JAF->( dbSetOrder( 1 ) )
JAF->( dbSeek( xFilial( "JAF" ) + JAH->( JAH_CURSO + JAH_VERSAO ) ) )

aAdd( aDados, { "NOME_CURSO"	, RTrim(JAF->JAF_DESMEC) } )   //ok
aAdd( aDados, { "cProt"			, alltrim(JBH->JBH_NUM)} )     //ok
aAdd( aDados, { "RA"				, ALLTRIM( JBH->JBH_CODIDE )} )//ok
aAdd( aDados, { "NOME"			, ALLTRIM(JA2->JA2_NOME)} )    //OK
aAdd( aDados, { "SIT"			, ALLTRIM(IIF(ALLTRIM(JBE->JBE_ATIVO)== '1' ,"Matriculado",;
													 IIF(ALLTRIM(JBE->JBE_ATIVO)== '2' ,"Não Matriculado",;
													 IIF(ALLTRIM(JBE->JBE_ATIVO)== '3' ,"Transferido",;
													 IIF(ALLTRIM(JBE->JBE_ATIVO)== '4' ,"Trancado",;
													 IIF(ALLTRIM(JBE->JBE_ATIVO)== '5' ,"Formado",;
													 IIF(ALLTRIM(JBE->JBE_ATIVO)== '5' ,"Cancelado",;
													 IIF(ALLTRIM(JBE->JBE_ATIVO)== '7' ,"Desistencia",;
													 IIF(ALLTRIM(JBE->JBE_ATIVO)== '8' ,"Obito",;
													 IIF(ALLTRIM(JBE->JBE_ATIVO)== '9' ,"Debito - Financeiro","Integralizado"))))))))))} )
aAdd( aDados, { "AASS"			, ALLTRIM(JBE->JBE_ANOLET+' - '+JBE->JBE_PERIOD) } )
aAdd( aDados, { "serie"			, ALLTRIM(JBE->JBE_PERLET+' / '+JBE->JBE_TURMA)} )
aAdd( aDados, { "cUnidade"		, alltrim(JA3->JA3_DESLOC) } )
aAdd( aDados, { "cEmail"		,ALLTRIM( JA2->JA2_EMAIL )} )
aAdd( aDados, { "cFonRes"		,iif(empty(alltrim(JA2->JA2_FRESID)),' ',JA2->JA2_FRESID)} )
aAdd( aDados, { "cFoneCom"		,iif(empty(alltrim(JA2->JA2_FCELUL)),' ',JA2->JA2_FCELUL) } )
aAdd( aDados, { "cDocum"		,ALLTRIM(JBF->JBF_DESC)} )
aAdd( aDados, { "cDIAA"			,ALLTRIM(DTOC(DDATABASE))} )
AAdd( aDados, { "FUNCIONARIO" , cUserName } )
IF ALLTRIM(JBH->JBH_GERABL) == '1'
	SE1->(DBSETORDER(15))
	IF SE1->(dbSeek( xFilial( "SE1" ) + ALLTRIM(JBH->JBH_NUM) ) )
		IF ALLTRIM(SE1->E1_STATUS) == 'A'
			aAdd( aDados, { "PAG"			,'NÃO'} )
		ELSE
			aAdd( aDados, { "PAG"			,'SIM'} )
		ENDIF
	ELSE
		aAdd( aDados, { "PAG"			,' '} )
	ENDIF
ELSE
	aAdd( aDados, { "PAG"			,' '} )
ENDIF
//ARQ := '\SIGAADV\PROTRETIRADA.dot'
//ACImpDoc( ARQ, aDados )
ACImpDoc( JBG->JBG_DOCUM, aDados )

Return
