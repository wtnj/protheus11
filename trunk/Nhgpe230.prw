/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE230  ºAutor  ³Marcos R Roquitski  º Data ³  21/01/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Conferencia Vale transporte.                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±                                       
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"  
#include "topconn.ch"

User Function Nhgpe230()

SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC")
SetPrvt("CNORMAL,LPRIMEIRO,CQUERY,")

cSavCur1  := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont    := "";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem    := 0
tamanho   := "M"
limite    := 132
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "Conferencia Vale Transporte"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "SRA"
nTipo     := 0
nomeprog  := "NHGPE230"
cPerg     := "GPE105"
nPag      := 1
M_PAG     := 1 
tot01     := 0 
tot02     := 0 
tot03     := 0 
tot04     := 0 
aOrdem    := { 'Matricula','Centro de Custo','Nome' }
_cOrigem  := ''
lEnd      := .T.
cArqItau  := "C:\RELATO\EXTRA" + Substr(Dtos(dDataBase),5,4) + ".TXT" // 
cFnl      := CHR(13)+CHR(10)
nHdl      := fCreate(cArqItau)
lEnd      := .F.
_cOk      := .T.

/*
fImpArq()

If !File(_cOrigem)
   MsgBox("Arquivo de Entrada nao Localizado: " + _cOrigem,"Arquivo Retorno","INFO")
   Return
Endif
// Arquivo a ser trabalhado
_aStruct:={{ "LINHA","C",50,0}}

_cTr1 := CriaTrab(_aStruct,.t.)
USE &_cTr1 Alias TMPV New Exclusive
Append From (_cOrigem) SDF

*/

If !Pergunte(cPerg,.T.) //ativa os parametros
	Return(nil)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= "NHGPE230" 

SetPrint("SRA",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,aOrdem,,tamanho)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

RptStatus({||Imprime()},"Imprimindo...")

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
DbSelectArea("TMPZ")
DbCloseArea("TMPZ")

MS_FLUSH() //Libera fila de relatorios em spool

Return




Static Function Imprime()

Local lRet := .t.
Local _nSalario := _nAfas := _nDif := _nRece := _nFerias := _nFaltas := _nRecno := _nExperi := _nAdt := _nDiaPro := _nFerPro := 0
Local _dDtExp, _cMat
Local _nTotadt := _nTotSal40 := nTotDif := 0
Local _nTotDif := 0
Local _dDati   := Ctod(Space(08))
Local _dDatf   := Ctod(Space(08))
Local _cTipo   := Space(01)
Local _nSalMes := 0
Local _cApro1, _cApro2, _cApro3
Local _cDescc
Local _lPri := .T.

DbEbsCon()
	     
//-- SELECIONA os usuarios do acesso 
//cQuery := "SELECT CRAC_COD_CRACHA,CRAC_COD_PROX FROM CRACHA  WHERE CRAC_DAT_VALIDADE >= '2030-12-31 23:59:00.000' AND CRAC_COD_PROX = '00000000000165951034' " 

cQuery := "SELECT dbo.dtos(dt_nascimento) 'dt_nascimento', * FROM FUNCIONARIO WHERE CD_EMPRESA = 3"
TCQUERY cQuery New Alias 'TMPZ'

CTT->(DbSetOrder(1)) 
SR8->(DbSetOrder(1)) 
TMPZ->(Dbgotop()) 
Cabec1 := "Mat.      Nome                                    Admissao            Cartao Tp.                                                  Observacao"
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
While !TMPZ->(eof())               


	DbSelectArea("SRA")
	RecLock("SRA",.T.)
	SRA->RA_FILIAL  := '01' // xFilial("SRA") // filial
	SRA->RA_MAT     := StrZero(TMPZ->cd_funcionario,6)
	SRA->RA_CC      := '11005002'
	SRA->RA_NOME    := UPPER(TMPZ->nome)


    // Documentos
    
	cQueryd := "SELECT replace(REPLACE(pis,'.',''),'-','') 'pis1',replace(REPLACE(cpf,'.',''),'-','') 'cpf1',* FROM FUNDOCUMENTO WHERE CD_EMPRESA = 3 AND CD_FUNCIONARIO = " + Alltrim(Str(TMPZ->cd_funcionario)) 
	TCQUERY cQueryd New Alias 'TMPD'
    
	DbSelectArea("TMPD")
	TMPD->(DbGotop())   
	
	SRA->RA_CIC	    := TMPD->cpf1
	SRA->RA_PIS	    := TMPD->pis1
	SRA->RA_RG	    := TMPD->nr_identidade
	SRA->RA_NUMCP	:= TMPD->nr_carteira
	SRA->RA_SERCP	:= TMPD->serie_carteira+TMPD->dv_serie_carteira
	SRA->RA_UFCP	:= TMPD->uf_carteira
	SRA->RA_HABILIT	:= Alltrim(Str(TMPD->nr_habilitacao))
	SRA->RA_RESERVI	:= TMPD->certificado_militar
	SRA->RA_TITULOE	:= Alltrim(Str(TMPD->nr_titulo)) + Alltrim(Str(TMPD->zona_titulo))
	SRA->RA_ZONASEC	:= Alltrim(Str(TMPD->secao_titulo))
	SRA->RA_ENDEREC	:= TMPZ->endereco + Alltrim(Str(TMPZ->nr_endereco))
	SRA->RA_COMPLEM	:= TMPZ->compl_endereco
	SRA->RA_BAIRRO	:= TMPZ->bairro
	SRA->RA_MUNICIP	:= TMPZ->cidade
	SRA->RA_ESTADO  := TMPZ->estado
	SRA->RA_CEP     := Alltrim(Str(TMPZ->cep))
	SRA->RA_TELEFON	:= Alltrim(Str(TMPZ->ddd_fone)) + Alltrim(Str(TMPZ->telefone))
	SRA->RA_PAI	    := TMPZ->pai
	SRA->RA_MAE     := TMPZ->mae
	SRA->RA_SEXO    := TMPZ->sexo
	SRA->RA_ESTCIVI	:= Alltrim(Str(TMPZ->estado_civil))
	SRA->RA_NATURAL	:= Alltrim(TMPZ->estado_nascimento)
	SRA->RA_NACIONA	:= Alltrim(Str(TMPZ->nacionalidade))
	SRA->RA_ANOCHEG	:= Alltrim(Str(TMPZ->ano_chegada))
	//SRA->RA_DEPIR	:=
	//SRA->RA_DEPSF	:=
	SRA->RA_NASC	:= CTOD(TMPZ->dt_nascimento)
	SRA->RA_HOPARC  := '2' 
	SRA->RA_COMPSAB := '1'
	SRA->RA_RACACOR := TMPZ->raca
	SRA->RA_PGCTSIN := 'S' 
	SRA->RA_TIPOADM := '9B'	

    // Salarios
	cQuerys := "SELECT dbo.dtos(dt_salario) 'dt_sal',* FROM FunSalario WHERE CD_EMPRESA = 3 AND CD_FUNCIONARIO = " + Alltrim(Str(TMPZ->cd_funcionario)) "
	cQuerys += "order by cd_funcionario,vl_salario DESC "
	TCQUERY cQuerys New Alias 'TMPS'

	DbSelectArea("TMPS")
	TMPS->(DbGotop())   
	While !TMPS->(Eof()) 
		If TMPS->cd_funcionario == TMPZ->cd_funcionario
			SRA->RA_PERCADT := 40.00
			SRA->RA_CATFUNC := TMPS->tipo_salario
			SRA->RA_TIPOPGT := TMPS->tipo_salario
			SRA->RA_SALARIO := TMPS->vl_salario
			SRA->RA_ANTEAUM := TMPS->vl_salario 
			SRA->RA_HRSMES  := 44.00
			SRA->RA_HRSEMAN := 8.80
			Exit
		Endif
		TMPS->(DbSkip())	
	Enddo
	DbSelectArea("TMPS")
	DbCloseArea("TMPS")
 

    // Bancos
	cQueryf := "SELECT dbo.dtos(dt_admissao) 'dt_admissao',* FROM FunFuncional WHERE CD_EMPRESA = 3 AND CD_FUNCIONARIO = " + Alltrim(Str(TMPZ->cd_funcionario)) 
	TCQUERY cQueryf New Alias 'TMPF'


	SRA->RA_ADMISSA	:= CTOD(TMPF->dt_admissao)
	SRA->RA_OPCAO	:= CTOD(TMPF->dt_admissao)
	//SRA->RA_DEMISSA	varchar
	//SRA->RA_VCTOEXP	varchar
	//SRA->RA_EXAMEDI	varchar
	SRA->RA_BCDEPSA	:= '381'
	SRA->RA_CTDEPSA	:= Alltrim(Str(TMPF->nr_conta_deposito))+'-'+TMPF->dv_conta_deposito
	SRA->RA_BCDPFGT	:= '104'
	SRA->RA_CTDPFGT	:= '1'   
	SRA->RA_VIEMRAI	:= '10'
	SRA->RA_GRINRAI	:= Alltrim(Str(TMPZ->grau_instrucao))

	DbSelectArea("TMPF")
	DbCloseArea("TMPF")


	DbSelectArea("TMPD")
	DbCloseArea("TMPD")



	// Funcao funcionario
	cQuery9  := "SELECT dbo.damd(dt_funcao) 'dt_fun', * FROM FunFuncao WHERE cd_empresa = 3 AND CD_FUNCIONARIO = " + Alltrim(Str(TMPZ->cd_funcionario)) 
	cQuery9  += "ORDER BY cd_funcionario,dt_fun DESC "
	TCQUERY cQuery9  New Alias 'TMP9'


	//
	DbSelectArea("TMP9")
	TMP9->(DbGotop())   
	While !TMP9->(Eof()) 
		If TMP9->cd_funcionario == TMPZ->cd_funcionario
			SRA->RA_CODFUNC := StrZero(Val(Alltrim(Str(TMP9->cd_funcao))),4)
			SRA->RA_CARGO   := StrZero(Val(Alltrim(Str(TMP9->cd_funcao))),4)
			Exit
		Endif
		TMP9->(DbSkip())	
	Enddo
	DbSelectArea("TMP9")
	DbCloseArea("TMP9")


	If _lPri  
	           
		// Funcao
		cQuery10 := "SELECT * FROM Funcao WHERE enterprise_id = 3 and status = 'A' " 
		TCQUERY cQuery10 New Alias 'TMP10'
	   
		DbSelectArea("TMP10")
		TMP10->(DbGotop())   
		While !TMP10->(Eof()) 
		
			DbSelectArea("SRJ")
			RecLock("SRJ",.T.)    
			SRJ->RJ_FILIAL   := '01' // xFilial("SRJ")	
			SRJ->RJ_FUNCAO   := StrZero(Val(Alltrim(Str(TMP10->cd_funcao))),4)
			SRJ->RJ_DESC     := TMP10->descricao
			SRJ->RJ_CBO      := Alltrim(Str(TMP10->cbo2002))
			SRJ->RJ_HRSMES   := 220.00
			SRJ->RJ_HRSEMAN  := 44.00
			SRJ->RJ_CARGO    := StrZero(Val(Alltrim(Str(TMP10->cd_funcao))),4)
			SRJ->RJ_CODCBO   := Alltrim(Str(TMP10->cbo2002))
			SRJ->RJ_PPPIMP   := '1'
			MsUnlock("SRJ")

			DbSelectArea("SQ3")
			RecLock("SQ3",.T.)    
			SQ3->Q3_FILIAL   := xFilial("SQ3")	
			SQ3->Q3_CARGO    := StrZero(Val(Alltrim(Str(TMP10->cd_funcao))),4)
			SQ3->Q3_DESCSUM  := TMP10->descricao
			MsUnlock("SQ3")


			TMP10->(DbSkip())	
    
		Enddo
		DbSelectArea("TMP10")
		DbCloseArea("TMP10")

		_lPri := .F.

	Endif	

	// Dependente
    
	cQuery8  := "SELECT dbo.dtos(dt_nascimento) 'dt_nasc', * FROM FunDependente WHERE cd_empresa = 3 AND CD_FUNCIONARIO = " + Alltrim(Str(TMPZ->cd_funcionario)) 
	TCQUERY cQuery8  New Alias 'TMP8'

	DbSelectArea("TMP8")
	TMP8->(DbGotop())   
	While !TMP8->(Eof()) 
		
		DbSelectArea("SRB")
		RecLock("SRB",.T.)    
		SRB->RB_FILIAL    := xFilial("SRB")
		SRB->RB_MAT       := StrZero(TMPZ->cd_funcionario,6)
		SRB->RB_COD       := StrZero(TMP8->cd_dependente,2)
		SRB->RB_NOME      := TMP8->nome
		SRB->RB_DTNASC    := Ctod(TMP8->dt_nasc)

		If UPPER(Alltrim(TMP8->descricao_parentesco)) $ "MARIDO/FILHO/ESPOSO"
			SRB->RB_SEXO   := "M"                                           
		Elseif UPPER(Alltrim(TMP8->descricao_parentesco)) $ "ESPOSA/FILHA/ENTEADA/CONJUGUE"			
			SRB->RB_SEXO   := "F"                                           		
		Endif 	

		If TMP8->tipo_parentesco == 1 .OR. TMP8->tipo_parentesco == 9
			SRB->RB_GRAUPAR := 'C'     	
		Elseif TMP8->tipo_parentesco == 2 .OR. TMP8->tipo_parentesco == 5
			SRB->RB_GRAUPAR := 'F'     	
		Elseif TMP8->tipo_parentesco == 7 
			SRB->RB_GRAUPAR := 'E'     	
		Else
			SRB->RB_GRAUPAR := 'O'     	
		Endif
		SRB->RB_TIPIR    := '1'
		SRB->RB_TIPSF    := '3'
			
		TMP8->(DbSkip())	
    
	Enddo
	DbSelectArea("TMP8")
	DbCloseArea("TMP8")

	DbSelectArea("SRA")
	MsUnlock("SRA")
	
	DbSelectArea("TMPZ")
	
	/*
	SRA->RA_CIC     := ''
	SRA->RA_PIS     := ''
	SRA->RA_RG      := ''
	SRA->RA_NUMCP   := ''
	SRA->RA_SERCP   := ''
	MsUnlock("SRA")
    */
    


/*
RA_FILIAL	varchar
RA_MAT	varchar
RA_CC	varchar
RA_NOME	varchar
RA_CIC	varchar
RA_PIS	varchar
RA_RG	varchar
RA_NUMCP	varchar
RA_SERCP	varchar
RA_UFCP	varchar
RA_HABILIT	varchar
RA_RESERVI	varchar
RA_TITULOE	varchar
RA_ZONASEC	varchar
RA_ENDEREC	varchar
RA_COMPLEM	varchar
RA_BAIRRO	varchar
RA_MUNICIP	varchar
RA_ESTADO	varchar
RA_CEP	varchar
RA_TELEFON	varchar
RA_PAI	varchar
RA_MAE	varchar
RA_SEXO	varchar
RA_ESTCIVI	varchar
RA_NATURAL	varchar

RA_NACIONA	varchar
RA_ANOCHEG	varchar
RA_DEPIR	varchar
RA_DEPSF	varchar
RA_NASC	varchar

RA_ADMISSA	varchar
RA_OPCAO	varchar
RA_DEMISSA	varchar
RA_VCTOEXP	varchar
RA_EXAMEDI	varchar
RA_BCDEPSA	varchar
RA_CTDEPSA	varchar
RA_BCDPFGT	varchar
RA_CTDPFGT	varchar
RA_SITFOLH	varchar
RA_HRSMES	float
RA_HRSEMAN	float
RA_CHAPA	varchar
RA_TNOTRAB	varchar
RA_CODFUNC	varchar
RA_CBO	varchar
RA_PGCTSIN	varchar
RA_SINDICA	varchar
RA_ASMEDIC	varchar
RA_ADTPOSE	varchar
RA_CESTAB	varchar
RA_VALEREF	varchar
RA_SEGUROV	varchar
RA_PENSALI	float

RA_PERCADT	float
RA_CATFUNC	varchar
RA_TIPOPGT	varchar
RA_SALARIO	float
RA_ANTEAUM	float

RA_BASEINS	float
RA_INSSOUT	float
RA_PERICUL	float
RA_INSMIN	float
RA_INSMED	float
RA_INSMAX	float
RA_TIPOADM	varchar
RA_AFASFGT	varchar
RA_VIEMRAI	varchar
RA_GRINRAI	varchar
RA_RESCRAI	varchar
RA_MESTRAB	varchar
RA_MESESAN	float
RA_ALTEND	varchar
RA_ALTCP	varchar
RA_ALTPIS	varchar
RA_FTINSAL	float
RA_ALTADM	varchar
RA_ALTOPC	varchar
RA_ALTNOME	varchar
RA_CODRET	varchar
RA_CRACHA	varchar
RA_SENHA	varchar
RA_REGISTR	varchar
RA_FICHA	varchar
RA_TPCONTR	varchar
RA_NIVEL	varchar
RA_APELIDO	varchar
RA_TECNICO	varchar
RA_TPRCBT	varchar
RA_TCFMSG	varchar
RA_INSSSC	varchar
RA_OCORREN	varchar
RA_CLASSEC	varchar
RA_DISTSN	varchar
RA_RGORG	varchar
RA_DEFIFIS	varchar
RA_RACACOR	varchar
RA_TABELA	varchar
RA_TABNIVE	varchar
RA_TABFAIX	varchar
RA_RECMAIL	varchar
RA_RECPFNC	varchar
RA_EMAIL	varchar
RA_PERFGTS	float
RA_DTVTEST	varchar
RA_FAIXA	varchar
RA_PERCSAT	float
RA_REGRA	varchar
RA_BITMAP	varchar
RA_SEQTURN	varchar
RA_BHFOL	varchar
RA_ACUMBH	varchar
RA_VCTEXP2	varchar
RA_CATEG	varchar
RA_CODIGO	varchar
RA_TPMAIL	varchar
RA_CARGO	varchar
RA_DTESTAB	varchar
RA_ACIDEN	varchar
RA_MENSALI	varchar
RA_BRPDH	varchar
RA_OKTRANS	varchar
RA_MSBLQL	varchar
RA_TPDEFFI	varchar
RA_CODTIT	varchar
RA_SIC	varchar
RA_ALTNASC	varchar
RA_ALTCBO	varchar
RA_DTCPEXP	varchar
RA_DTRGEXP	varchar
RA_TPVAGA	varchar
RA_TPVG1	varchar
RA_NMVG1	varchar
RA_TPVG2	varchar
RA_NMVG2	varchar
RA_NOMECMP	varchar
RA_PROCES	varchar
RA_POSTO	varchar
RA_CHIDENT	varchar
RA_RGEXP	varchar
RA_RGUF	varchar
RA_NUMINSC	varchar
RA_SERVICO	varchar
RA_ORGEMRG	varchar
RA_DEPTO	varchar
RA_CODUNIC	varchar
RA_REGIME	varchar
RA_FWIDM	varchar
RA_HOPARC	varchar
RA_CLAURES	varchar
RA_DTFIMCT	varchar
RA_COMPSAB	varchar
RA_MOLEST	varchar
RA_FECREI	varchar
RA_DEMIANT	varchar
RA_HFUND	varchar
RA_HFINS	varchar
RA_HFDES	varchar
RA_HMEDI	varchar
RA_HMINS	varchar
RA_HMDES	varchar
RA_HTECN	varchar
RA_INSSAUT	varchar
RA_HTINS	varchar
RA_HTDES	varchar
RA_HGRAD	varchar
RA_HGINS	varchar
RA_HGDES	varchar
RA_HESP	varchar
RA_HEINS	varchar
RA_HEDES	varchar
RA_DTASME	varchar
RA_ZEMP	varchar
RA_ZMAT	varchar
RA_TIPAMED	varchar
RA_DTDESCP	varchar
RA_DPASSME	varchar
RA_TPASODO	varchar
RA_ASODONT	varchar
RA_XCODEST	varchar
RA_ZENTIDA	varchar
RA_XRESMED	varchar
RA_XDESMED	varchar
RA_XMATERI	varchar
RA_XESTABI	varchar
RA_XESTABF	varchar
RA_ITEM	varchar
RA_CLVL	varchar
RA_ASSIST	varchar
RA_CONFED	varchar
RA_MENSIND	varchar
RA_RESEXT	varchar
RA_RHEXP	varchar
D_E_L_E_T_	varchar
R_E_C_N_O_	int
R_E_C_D_E_L_	int  
  

*/

		If Prow() > 56
			nPag := nPag + 1
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
		Endif

		@ Prow() + 1, 000 Psay SRA->RA_MAT 
		@ Prow()    , 010 Psay SRA->RA_NOME
		@ Prow()    , 050 Psay 'Importado'

		/*
		_cDescc := ''
		If CTT->(DbSeek(xFilial("CTT")+SRA->RA_CC))
			_cDescc := CTT->CTT_DESC01
		Endif
		@ Prow()    , 105 Psay _cDescc
		*/
		     
	 TMPZ->(Dbskip())

Enddo
@ Prow() + 1,000 Psay __PrtThinLine()

Return    


Static Function fImpArq()
_lSai     := .T.
_cOrigem  := Space(50)

@ 010,133 To 180,600 Dialog oDialogos Title "Importacao de Arquivo"

@ 021,005 Say "Origem" Size  15,8
@ 021,030 Get _cOrigem Size 130,8 When .F. 

@ 021,180 Button    "_Localizar" Size 36,16 Action Origem()
@ 060,070 BmpButton Type 2 Action fFecha()
@ 060,120 BmpButton Type 1 Action fConfArq()

Activate Dialog oDialogos CENTERED

Return(.t.)


Static Function Origem()

	_cTipo :="Arquivo Tipo (*.*)       | *.* | "
	_cOrigem := cGetFile(_cTipo,,0,,.T.,49)     	 

Return

Static Function fFecha()
	Close(oDialogos)
Return
      
Static Function fConfArq()
	If Empty(_cOrigem)
		MsgBox("Arquivo para Processamento nao Informado","Atencao","INFO")
	Else
		Close(oDialogos)
	Endif
Return



Static Function DbEbsCon() 

Local cDbConn := 'MSSQL7/DBITESA'
Local cSrvConn := '192.168.1.57'
Local nHndConn
Local cTopConType := 'TCPIP'
	
	TCConType(cTopConType)            

	nHndConn := TcLink(cDbConn,cSrvConn)
	
	If (nHndConn  < 0 ) // teste de conexão 
	     Alert ("Erro de conexão!"+STR(nHndConn) )
		oMail          := Email():New()
		oMail:cMsg     := 'Falha na conexão Protheus => DbItesa ('+STR(nHndConn)+')'
		oMail:cAssunto := '*** FALHA CONEXÃO PROTHEUS X DbItesa ***'  
		oMail:cTo      := 'marcosr@whbbrasil.com.br'
		oMail:Envia()
	EndIf 
	  
Return


//			
Static Function DEC2HEX(nDEC)
 cHEX :=""
 IF VALTYPE(nDEC)="N"
    aBASE16 := {"0","1","2","3","4","5","6","7","8","9",;
                "A","B","C","D","E","F"}
    aHEX := {}
    nDIVIDENDO := nDEC
    nQUOCIENTE := 1 // só pra entrar no DO WHILE
    DO WHILE nQUOCIENTE # 0
       nQUOCIENTE := INT(nDIVIDENDO/16)
       nRESTO     := nDIVIDENDO % 16
       nRESTO++   // SOMA 1 PORQUE aBASE16 COMEÇA COM "0" E NÃO "1"
       cHEX       := aBASE16[nRESTO]
       aADD(aHEX, cHEX)
       nDIVIDENDO := nQUOCIENTE
    ENDDO
 ENDIF
 cHEX := ""
 FOR X=LEN(aHEX) TO 1 STEP -1
     cHEX += aHEX[X]
 NEXT
 RETURN cHEX
			
			
/*
alter FUNCTION dbo.dtos(@dat DATETIME) 

RETURNS VARCHAR(10)

AS

BEGIN 

RETURN RTRIM(LTRIM(STR(DATEPART(day,@dat))))+'/'+RTRIM(LTRIM(STR(DATEPART(month,@dat))))+'/'+ RTRIM(LTRIM(STR(DATEPART(year,@dat)))) 

END
*/			
			