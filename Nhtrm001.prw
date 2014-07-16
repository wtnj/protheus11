/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHTRM001  บAutor  ณMarcos R. Roquitski บ Data ณ  03/07/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Fatores de Avaliacao X Funcionarios.          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ WHB                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"


User Function Nhtrm001()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cString      :="SRA"
Private aOrd         := {}
Private cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2       := "de acordo com os parametros informados pelo usuario."
Private cDesc3       := "RELATORIO DE FATOR DE AVALIACAO"        
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "NHTRM001" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "TRM001"
Private Titulo       := "FATOR DE AVALIACAO"
Private nLin         := 80
Private Cabec1       := "      F U N C I O A N A R I O                                         F A T O R E S    D E    A V A L I A C A O    D O    C A R G O                                         FATORES DE AVALIACAO DO FUNCIONARIO"
Private Cabec2       := "  Matr.  Nome funcionario                 Cargo Descricao do Cargo                Ft Descricao do Fator                           Gr Descricao do Grau                 Ptos Ft Gr Descricao do Grau   Necessidade   Ptos"
Private Cabec3       := "  Matr.  Nome funcionario                 Cargo Descricao do Cargo                Ft Descricao do Fator                           Gr Descricao do Grau                      Ft Gr Descricao do Grau   Necessidade     "
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private imprime      := .T.
Private wnrel        := "TRM001" // Coloque aqui o nome do arquivo usado para impressao em disco
Private lEnd         := .F.
Private cString      := "SRA"

ValidPerg()

pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Processa({|| Gerando() },"Gerando Dados para a Impressao")
Processa({|| fRunReport() },"Imprimindo...")

Return


Static Function Gerando()

cQuery := "SELECT RA.RA_MAT,RA.RA_NOME,Q4.Q4_CARGO,Q4.Q4_FATOR,QV.QV_DESCFAT,Q4.Q4_GRAU,"
cQuery := cQuery + " QV.QV_DESCGRA,Q8.Q8_FATOR,Q8.Q8_GRAU,Q3.Q3_DESCSUM,Q4.Q4_PONTOS,Q8.Q8_PONTOS"
cQuery := cQuery + " FROM SQ4NH0 Q4, SQ8NH0 Q8, SRANH0 RA,SRJNH0 RJ, SQVNH0 QV, SQ3NH0 Q3"
cQuery := cQuery + " WHERE RA.RA_MAT BETWEEN '" + Mv_par01 + "' AND '" + Mv_par02 + "' "
cQuery := cQuery + " AND RA.RA_MAT *= Q8.Q8_MAT"
cQuery := cQuery + " AND RA.RA_SITFOLH = ' '"
cQuery := cQuery + " AND Q4.Q4_FATOR *= Q8.Q8_FATOR AND Q8.D_E_L_E_T_ <> '*'"
cQuery := cQuery + " AND RJ.RJ_FUNCAO = RA.RA_CODFUNC"
cQuery := cQuery + " AND RJ.RJ_CARGO BETWEEN '" + Mv_par03 + "' AND '" + Mv_par04 + "' "
cQuery := cQuery + " AND Q4.Q4_CARGO = RJ.RJ_CARGO AND Q4.D_E_L_E_T_ <> '*'"
cQuery := cQuery + " AND QV.QV_FATOR = Q4.Q4_FATOR AND QV.D_E_L_E_T_ <> '*'"
cQuery := cQuery + " AND QV.QV_GRAU = Q4.Q4_GRAU"
cQuery := cQuery + " AND Q3.Q3_CARGO = Q4.Q4_CARGO AND Q3.D_E_L_E_T_ <> '*'"
cQuery := cQuery + " ORDER BY RA.RA_MAT,Q4_FATOR ASC"

//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"

Return(NIL)


Static Function fRunReport()
Local _Mat := Space(06)
Local _PCa := 0
Local _PFu := 0
Local lRet := .T.


DbSelectArea("TMP")
TMP->(DbGotop())
While TMP->(!Eof())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,IIF(mv_par05=="S",Cabec2,Cabec3),NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	_Mat := TMP->RA_MAT
	If lRet 
		@ nLin,002 PSAY TMP->RA_MAT
		@ nLin,009 PSAY TMP->RA_NOME
		@ nLin,042 PSAY TMP->Q4_CARGO
		@ nLin,048 PSAY TMP->Q3_DESCSUM
		lRet := .F.
	Endif	
	@ nLin,082 PSAY TMP->Q4_FATOR
	@ nLin,085 PSAY Substr(TMP->QV_DESCFAT,1,40)
	@ nLin,130 PSAY TMP->Q4_GRAU
	@ nLin,133 PSAY Substr(TMP->QV_DESCGRA,1,30)
	If mv_par05=="S"
		@ nLin,165 PSAY TMP->Q4_PONTOS Picture "999.99"
	Endif	
	@ nLin,172 PSAY TMP->Q8_FATOR
	@ nLin,175 PSAY TMP->Q8_GRAU
	SQV->(DbSeek(xFilial("SQV")+TMP->Q8_FATOR+TMP->Q8_GRAU))
	If SQV->(Found())
		@ nLin,178 PSAY Substr(SQV->QV_DESCGRA,1,27)
	Endif
	If TMP->Q8_GRAU < TMP->Q4_GRAU 
		@ nLin,208 PSAY "S"
	Endif		
	If mv_par05=="S"
		@ nLin,210 PSAY TMP->Q8_PONTOS Picture "999.99"
	Endif		
	nLin := nLin + 1
	_Pca := _Pca + TMP->Q4_PONTOS
	_Pfu := _Pfu + TMP->Q8_PONTOS
	TMP->(DbSkip())
	If TMP->RA_MAT <> _Mat 
		If mv_par05=="S"
			nLin := nLin + 1
			@ nLin,165 PSAY _Pca Picture "999.99"
			@ nLin,210 PSAY _Pfu Picture "999.99"   
			nLin := nLin + 1
		Endif			
		@ nLin,002 PSAY Replicate("-",limite)
		nLin := nLin + 1
		_Pca := 0
		_Pfu := 0
		lRet := .T.
	Endif		

Enddo
SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()
DbSelectArea("TMP")
DbCloseArea()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ AP6 IDE            บ Data ณ  17/06/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Funcionario de    ?","Funcionario de    ?","Funcionario de    ?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Funcionario Ate   ?","Funcionario Ate   ?","Funcionario Ate   ?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Cargo de          ?","Cargo de          ?","Cargo de          ?","mv_ch3","C",05,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Cargo Ate         ?","Cargo Ate         ?","Cargo Ate         ?","mv_ch4","C",05,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Totaliza Pontos   ?","Totaliza Pontos   ?","Totaliza Pontos   ?","mv_ch5","C",01,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})


For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)

Return
