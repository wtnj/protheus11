#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁPrograma  Ё         Ё Autor Ё                       Ё Data Ё           Ё╠╠
╠╠цддддддддддеддддддддддадддддддеддддддддбддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁLocacao   Ё                  ЁContato Ё                                Ё╠╠
╠╠цддддддддддеддддддддддддддддддаддддддддадддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁDescricao Ё                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametrosЁ                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁRetorno   Ё                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁAplicacao Ё                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso       Ё                                                            Ё╠╠
╠╠цддддддддддадддбддддддддбддддддбдддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁAnalista Resp.Ё  Data  Ё                                               Ё╠╠
╠╠цддддддддддддддеддддддддеддддддедддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё              Ё  /  /  Ё                                               Ё╠╠
╠╠Ё              Ё  /  /  Ё                                               Ё╠╠
╠╠юддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/

User Function TESTES

/*дддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠ DeclaraГЦo de cVariable dos componentes                                 ╠╠
ы╠╠юддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддд*/
Local aAlterEnch := {}  //Vetor com nome dos campos que poderao ser editados
Local aCpoEnch   := {}// Vetor com nome dos campos que serao exibidos. Os campos de usuario sempre serao exibidos se nao existir no parametro um elemento com a expressao "NOUSER"
Local aPos       := {052,044,127,244}  //Vetor com coordenadas para criacao da enchoice no formato <top>, <left>, <bottom>, <right>
Local cAliasE    := "ZF8"  //Tabela cadastrada no Dicionario de Tabelas (SX2) que sera editada
Local caTela     := ""  // Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lColumn    := .F.  //Indica se a apresentacao dos campos sera em forma de coluna
Local lF3        := .F.  //Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria   := .T.  //Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lNoFolder  := .F.  //Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty  := .T.  //Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
Local nCntFor 
Local nModelo    := 3  //Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Local nOpcE      := 3  //Numero da linha do aRotina que definira o tipo de edicao (Inclusao, Alteracao, Exclucao, Visualizacao)
Local nRegE      := 0  //Numero do Registro a ser Editado/Visualizado (Em caso de Alteracao/Visualizacao)
Private ALTERA   := .F.
Private bCampo   := {|nCPO| Field(nCPO)}
Private DELETA   := .F.
Private INCLUI   := .T.
Private VISUAL   := .F.

/*дддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠ DeclaraГЦo de Variaveis Private dos Objetos                             ╠╠
ы╠╠юддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддд*/
SetPrvt("oDlg1")

/*дддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠ Definicao do Dialog e todos os seus componentes.                        ╠╠
ы╠╠юддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддд*/
oDlg1      := MSDialog():New( 091,232,691,927,"oDlg1",,,.F.,,,,,,.T.,,,.T. )
RegToMemory(cAliasE, INCLUI, .F.)
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAliasE)
while !Eof().and.(x3_arquivo==cAliasE)
   if X3USO(x3_usado).and.cNivel>=x3_nivel
      AADD(aCpoEnch,x3_campo)
      if X3_VISUAL # "V"
         AADD(aAlterEnch,x3_campo)
      endif
   endif
   &("M->"+Alltrim(x3_campo) ) := CriaVar(x3_campo)
   dbSkip()
end
for nCntFor := 1 TO FCount()
   M->&(EVAL(bCampo,nCntFor)) := FieldGet(nCntFor)
next
Enchoice(cAliasE,nRegE,nOpcE,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPos,aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,/*cTudoOk*/,oDlg1,lF3,lMemoria,lColumn,/*caTela*/,lNoFolder,lProperty)

oDlg1:Activate(,,,.T.)

Return
