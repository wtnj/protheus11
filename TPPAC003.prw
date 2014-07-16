#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TPPAC003³ Autor ³ HANDERSON LEMOS DUARTE³ Data ³ 17/12/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Cadastro de Matrizes WH9,WH0,WHA                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TPPAC003  



/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local nOpc := GD_INSERT+GD_DELETE+GD_UPDATE
Local nOpc := GD_INSERT+GD_DELETE+GD_UPDATE
Private aCoBrwCarac := {}
Private aCoBrwOper 	:= {}
Private aHoBrwCarac := {}
Private aHoBrwOper 	:= {}
Private noBrwCarac  := 0
Private noBrwOper  	:= 0
Private aCabec		:={}//Estrutura do Cabeçalho da tabela WH9

Private cObjGet       
Private cObjSay       
Private cCampo		:=""
Private nLin		:=2
Private cBloco		:=""
Private cBlocoTit	:=""
Private cTitulo		:=""
Private	aCampo		:={}
Private aCabec		:={}
Private cValid		:=""//Validação do Campo 
Private lVisual		:=.F.//Se .T. o controle não poderá ser editado.
Private cInicial	//Valor inicial do campo
Private cObrigat	:=""//Flag para modificar a cor do Say para os campos obrigatórios

sfModelo2()
Return()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgPrinc","oSBoxPrin","oGrpOper","oBrwOper","oGrpCarac","oBrwCarac")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oDlgPrinc  := MSDialog():New( 106,192,751,1245,"Cadastro de Matriz de Correlação",,,.F.,,,,,,.T.,,,.T. )
oDlgPrinc:bInit := {||EnchoiceBar(oDlgPrinc,{|| oDlgPrinc:End() },{|| oDlgPrinc:End() },.F.,{})}  
//EnchoiceBar(	oDlg1,{|| sfButOK (cAliasSE2,oValor,@nValor,oQtdTit,@nQtdTit)},{|| ODlg1:End()},,@aButtons ) Centered 
oSBoxPrin  := TScrollBox():New( oDlgPrinc,016,004,124,516,.T.,.T.,.T. )

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("WH9")
While !Eof() .and. SX3->X3_ARQUIVO == "WH9"
	If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
   		cCampo	:=	AllTrim(SX3->X3_CAMPO)
		aAdd(aCampo,SX3->X3_CAMPO)   		
   		Do Case
   			Case AllTrim(SX3->X3_TIPO)	== "C" .OR. AllTrim(SX3->X3_TIPO) == "M" 
   				cInicial:=AllTrim(SX3->X3_RELACAO)		
				&cCampo	:=IIF(Empty(SX3->X3_RELACAO),Space(SX3->X3_TAMANHO),&cInicial)	
							   			
   			Case AllTrim(SX3->X3_TIPO)	== "N" 
   				cInicial:=AllTrim(SX3->X3_RELACAO)  			
				&cCampo	:=IIF(Empty(SX3->X3_RELACAO),0,&cInicial)
								    							
   			Case AllTrim(SX3->X3_TIPO)	== "D"
   				cInicial:=AllTrim(SX3->X3_RELACAO)
				&cCampo	:=IIF(Empty(SX3->X3_RELACAO),StoD(" / / "),&cInicial)
							
   			Case AllTrim(SX3->X3_TIPO)	== "L"
   				cInicial:=AllTrim(SX3->X3_RELACAO)
				&cCampo	:=IIF(Empty(SX3->X3_RELACAO),.F.,&cInicial)  
				  				    				  			 			  				
   		EndCase	
		cObjGet	:=	"o"+AllTrim(SX3->X3_CAMPO)   	
		cObjSay	:=	"o"+AllTrim(SX3->X3_CAMPO) 
		cTitulo	:="cTit"+SX3->X3_ORDEM
		cBlocoTit:="{||"+cTitulo+"}"	
		&cTitulo:=AllTrim(SX3->X3_TITULO)
		cValid	:=IIF (Empty(SX3->X3_VLDUSER),"","{ || "+AllTrim(SX3->X3_VLDUSER)+" }")		
		lVisual	:=IIF(SX3->X3_VISUAL=="V",.T.,.F.)
		/*
		cObrigat:="cObr"+SX3->X3_ORDEM
		&cObrigat:=""		
		&cObrigat:=IIF(Empty(SX3->X3_OBRIGAT),"CLR_BLACK","CLR_BLUE")
		*/
		
		&cObjSay       := TSay():New( nLin,012,&cBlocoTit,oSBoxPrin,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		cBloco:="{|u| If(PCount()>0,"+cCampo+":=u,"+cCampo+")}"
		&cObjGet       := TGet():New( nLin,080,&cBloco,oSBoxPrin,SX3->X3_TAMANHO*5,008,SX3->X3_PICTURE,&cValid,CLR_BLACK,IIF(lVisual,CLR_GRAY,CLR_WHITE),;
								     ,,,.T.,"Teste de Campo",,,.F.,lVisual,,.F.,.F.,IIF(Empty(SX3->X3_F3),"",SX3->X3_F3),SX3->X3_CAMPO,,)
										     
   		nLin+=14
	EndIf   
	DbSkip()
EndDo


oGrpOper   := TGroup():New( 148,004,316,260,"Operações",oDlgPrinc,CLR_BLACK,CLR_WHITE,.T.,.F. )
MHoBrwOper()
MCoBrwOper()
oBrwOper   := MsNewGetDados():New(156,008,312,256,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrpOper,aHoBrwOper,aCoBrwOper )
oGrpCarac  := TGroup():New( 148,264,316,520,"Caracteristicas",oDlgPrinc,CLR_BLACK,CLR_WHITE,.T.,.F. )
MHoBrwCarac()
MCoBrwCarac()
oBrwCarac  := MsNewGetDados():New(156,268,312,516,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,25,'AllwaysTrue()','','AllwaysTrue()',oGrpCarac,aHoBrwCarac,aCoBrwCarac )


oDlgPrinc:Activate(,,,.T.)

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MHoBrwOper() - Monta aHeader da MsNewGetDados para o Alias: WH0
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MHoBrwOper()

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("WH0")
While !Eof() .and. SX3->X3_ARQUIVO == "WH0"
   If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
      noBrwOper++
      Aadd(aHoBrwOper,{Trim(X3Titulo()),;
           SX3->X3_CAMPO,;
           SX3->X3_PICTURE,;
           SX3->X3_TAMANHO,;
           SX3->X3_DECIMAL,;
           "",;
           "",;
           SX3->X3_TIPO,;
           "",;
           "" } )
   EndIf
   DbSkip()
End

Return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MCoBrwOper() - Monta aCols da MsNewGetDados para o Alias: WH0
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MCoBrwOper()

Local aAux := {}

Aadd(aCoBrwOper,Array(noBrwOper+1))
For nI := 1 To noBrwOper
   aCoBrwOper[1][nI] := CriaVar(aHoBrwOper[nI][2])
Next
aCoBrwOper[1][noBrwOper+1] := .F.

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MHoBrwCarac() - Monta aHeader da MsNewGetDados para o Alias: WHA
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MHoBrwCarac()

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("WHA")
While !Eof() .and. SX3->X3_ARQUIVO == "WHA"
   If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
      noBrwCarac++
      Aadd(aHoBrwCarac,{Trim(X3Titulo()),;
           SX3->X3_CAMPO,;
           SX3->X3_PICTURE,;
           SX3->X3_TAMANHO,;
           SX3->X3_DECIMAL,;
           "",;
           "",;
           SX3->X3_TIPO,;
           "",;
           "" } )
   EndIf
   DbSkip()
End

Return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MCoBrwCarac() - Monta aCols da MsNewGetDados para o Alias: WHA
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MCoBrwCarac()

Local aAux := {}

Aadd(aCoBrwCarac,Array(noBrwCarac+1))
For nI := 1 To noBrwCarac
   aCoBrwCarac[1][nI] := CriaVar(aHoBrwCarac[nI][2])
Next
aCoBrwCarac[1][noBrwCarac+1] := .F.

Return 


//====================
Static Function sfModelo2()
//+-----------------------------------------------+
//¦ Opcao de acesso para o Modelo 2               ¦
//+-----------------------------------------------+
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
nOpcx:=3
//+-----------------------------------------------+
//¦ Montando aHeader                              ¦
//+-----------------------------------------------+  
dbSelectArea("WH9") 
DbsetOrder(1)
RegToMemory( "WH9", .T., .F. )  
dbSelectArea("Sx3")

dbSetOrder(1)
dbSeek("WHD")
nUsado:=0
aHeader:={}
While !Eof() .And. (x3_arquivo == "WHD")
    IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
    	cValid:="'"+SX3->X3_VLDUSER+"'"
        nUsado:=nUsado+1
        AADD(aHeader,{ TRIM(x3_titulo),;
        	x3_campo,;
           	x3_picture,;
           	x3_tamanho,;
           	x3_decimal,;
           	&cValid,;
           	x3_usado,;
           	x3_tipo,;
           	x3_arquivo,;
           	x3_context } )
    Endif
    dbSkip()
End
//+-----------------------------------------------+
//¦ Montando aCols                                ¦
//+-----------------------------------------------+
aCols:=Array(1,nUsado+1)
dbSelectArea("Sx3")
dbSeek("WHD")
nUsado:=0
While !Eof() .And. (x3_arquivo == "WHD")
    IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
        nUsado:=nUsado+1
        IF nOpcx == 3
           IF x3_tipo == "C"
             aCOLS[1][nUsado] := SPACE(x3_tamanho)
                Elseif x3_tipo == "N"
                    aCOLS[1][nUsado] := 0
                Elseif x3_tipo == "D"
                    aCOLS[1][nUsado] := dDataBase
                Elseif x3_tipo == "M"
                    aCOLS[1][nUsado] := ""
                Else
                    aCOLS[1][nUsado] := .F.
                Endif
            Endif
        Endif
   dbSkip()
End
aCOLS[1][nUsado+1] := .F.
//+----------------------------------------------+
//¦ Variaveis do Cabecalho do Modelo 2           ¦
//+----------------------------------------------+
cCliente:=Space(6)
cLoja   :=Space(4)
dData   :=Date()
//+----------------------------------------------+

//¦ Variaveis do Rodape do Modelo 2
//+----------------------------------------------+
nLinGetD:=0
//+----------------------------------------------+
//¦ Titulo da Janela                             ¦
//+----------------------------------------------+
cTitulo:="MATRIZ DE CORRELAÇÃO"
//+----------------------------------------------+
//¦ Array com descricao dos campos do Cabecalho  ¦
//+----------------------------------------------+
aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"

// aC[n,2] = Array com coordenadas do Get [x,y], em
//           Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.


DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("WH9")
While !Eof() .and. SX3->X3_ARQUIVO == "WH9"
	If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL 
   		cCampo	:=	AllTrim(SX3->X3_CAMPO)
   		Do Case
   			Case AllTrim(SX3->X3_TIPO)	== "C" .OR. AllTrim(SX3->X3_TIPO) == "M" 		
				&cCampo	:=Space(SX3->X3_TAMANHO)
							   			
   			Case AllTrim(SX3->X3_TIPO)	== "N" 			
				&cCampo	:=0
								    							
   			Case AllTrim(SX3->X3_TIPO)	== "D"
				&cCampo	:=StoD(" / / ")
							
   			Case AllTrim(SX3->X3_TIPO)	== "L"
				&cCampo	:=.F.
				  				    				  			 			  				
   		EndCase			
 		AADD(aC,{cCampo ,{nLin,10} ,AllTrim(SX3->X3_TITULO),SX3->X3_PICTURE,;
 		'(SX3->X3_VLDUSER)',IIF(Empty(SX3->X3_F3),"",SX3->X3_F3),IIF(SX3->X3_VISUAL=="V",.F.,.T.)})

   		nLin+=14
	EndIf   
	DbSkip()
EndDo

/*
#IFDEF WINDOWS
 AADD(aC,{"cCliente" ,{15,10} ,"Cod. do Cliente","@!",;
 'ExecBlock("MD2VLCLI",.F.,.F.)',"SA1",})
 AADD(aC,{"cLoja"    ,{15,200},"Loja","@!",,,})
 AADD(aC,{"dData"    ,{27,10} ,"Data de Emissao",,,,})
#ELSE
 AADD(aC,{"cCliente" ,{6,5} ,"Cod. do Cliente","@!",;

 'ExecBlock("MD2VLCLI",.F.,.F.)',"SA1",})
 AADD(aC,{"cLoja"    ,{6,40},"Loja","@!",,,})
 AADD(aC,{"dData"    ,{7,5} ,"Data de Emissao",,,,})
#ENDIF
*/
//+-------------------------------------------------+
//¦ Array com descricao dos campos do Rodape        ¦
//+-------------------------------------------------+
aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em
//           Windows estao em PIXEL
// aR[n,3] = Titulo do Campo

// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.
#IFDEF WINDOWS
 AADD(aR,{"nLinGetD" ,{120,10},"Linha na GetDados",;
 "@E 999",,,.F.})
#ELSE
 AADD(aR,{"nLinGetD" ,{19,05},"Linha na GetDados",;
 "@E 999",,,.F.})
#ENDIF
//+------------------------------------------------+
//¦ Array com coordenadas da GetDados no modelo2   ¦
//+------------------------------------------------+
#IFDEF WINDOWS
 //   aCGD:={44,5,118,315}
    aCGD:={44,5,118,315}

#ELSE
    aCGD:={10,04,15,73}
#ENDIF
//+----------------------------------------------+
//¦ Validacoes na GetDados da Modelo 2           ¦
//+----------------------------------------------+
cLinhaOk :="" //"ExecBlock('Md2LinOk',.f.,.f.)"
cTudoOk  := "" //"ExecBlock('Md2TudOk',.f.,.f.)"
//+----------------------------------------------+
//¦ Chamada da Modelo2                           ¦
//+----------------------------------------------+
// lRet = .t. se confirmou
// lRet = .f. se cancelou

lRet:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)
// No Windows existe a funcao de apoio CallMOd2Obj() que
// retorna o objeto Getdados Corrente
Return
