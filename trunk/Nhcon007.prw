/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Nhcon007     � Osmar Schimitberger     � Data �  17/06/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Relat�rio Contabiliza��o das Transferencias entre C.Custo  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Contabilidade                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"


User Function Nhcon007()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cString      :="SRT"
Private aOrd         := {}
Private CbTxt        := "CONFER�NCIA DE TRANSFER�NCIAS POR C.CUSTO"
Private cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2       := "de acordo com os parametros informados pelo usuario."
Private cDesc3       := "RELA��O DE TRANSFER�NCIAS POR C.CUSTO"
Private cPict        := "CONTABILIZA��O DAS TRANSFER�NCIAS - APROPRIA��O CORRETA"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "NHCON007" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "CON007"
Private titulo       := "CONTABILIZA��O TRANSFER�NCIA"
Private nLin         := 80
Private Cabec1       := "C.C.Destino     Data      Verba          Valor           Matricula   Tipo"
Private Cabec2       := ""
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private imprime      := .T.
Private wnrel        := "CON007" // Coloque aqui o nome do arquivo usado para impressao em disco
Private lEnd         := .F.
Private cString      := "SRT"

ValidPerg()

pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

Processa({|| Gerando() },"Gerando Dados para a Impressao")
MsAguarde ( {|lEnd| fProcTemp() },"Aguarde","Processando...",.T.)
Processa( {|| fRunReport() },"Imprimindo...")

Return


Static Function Gerando()

cQuery := "SELECT * FROM SRTNH0"         
cQuery := cQuery + " WHERE RT_DATACAL BETWEEN '" + DtoS(Mv_par01) + "' AND '" + DtoS(Mv_par02) + "' "
cQuery := cQuery + " AND D_E_L_E_T_ <> '*' "
cQuery := cQuery + " ORDER BY RT_FILIAL, RT_DATACAL, RT_VERBA ASC"

//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMPSRT"
TcSetField("TMPSRT","RT_DATACAL","D")  // Muda a data de string para date

Return(NIL)

Static Function fProcTemp()

dData      := " "
cMatricula := " "
cCCD       := " "
cCCP       := " "
cVerba     := " "
nValor     := 0.00
cCCusto    := " "
nTotCCusto := 0.00
_cSRZarea  := SRZ->(GetArea())
_nTotReg   := 0.00

//��������������������������������������������������������������Ŀ
//� Criando Arquivo Temporario para posterior impressao          �
//����������������������������������������������������������������
_cArqDBF  := CriaTrab(NIL,.f.)
_aFields := {}

AADD(_aFields,{"TR_FILIAL" ,"C", 2,0})         // Filial
AADD(_aFields,{"TR_CC    " ,"C", 9,0})         // Centro de Custo
AADD(_aFields,{"TR_DATA  " ,"D", 8,0})         // Data
AADD(_aFields,{"TR_PD    " ,"C", 3,0})         // Verba
AADD(_aFields,{"TR_VAL   " ,"N",12,2})         // Valor
AADD(_aFields,{"TR_MAT   " ,"C", 6,0})         // Matricula
AADD(_aFields,{"TR_TIPO  " ,"C", 2,0})         // Tipo
AADD(_aFields,{"TR_TPC   " ,"C", 1,0})         // Tipo Contabilizacao (Origem/Destino)

DbCreate(_cArqDBF,_aFields)
DbUseArea(.T.,,_cArqDBF,"TRB",.F.)

SRE->(DbSelectArea("SRE")) //Abre arquivo Provis�es
SRE->(DbSetOrder(1))

dbSelectArea("TMPSRT")
TMPSRT->(Dbgotop())
While !TMPSRT->(EOF())

	MsProcTxt("Matricula : "+TMPSRT->RT_MAT)

	//IncProc("Atualizando Base para Impressao: ")
	
	If DTOS(TMPSRT->RT_DATACAL)==DTOS(MV_PAR02) .and. TMPSRT->RT_VERBA=="722" .or. TMPSRT->RT_VERBA=="724";
		.or. TMPSRT->RT_VERBA=="726" .or. TMPSRT->RT_VERBA=="728" .or. TMPSRT->RT_VERBA=="768";
		.or. TMPSRT->RT_VERBA=="769" .or. TMPSRT->RT_VERBA=="775" .or. TMPSRT->RT_VERBA=="776";
		.or. TMPSRT->RT_VERBA=="777"
		
		dData      := TMPSRT->RT_DATACAL
		cMatricula := TMPSRT->RT_MAT
		cVerba     := TMPSRT->RT_VERBA
		nValor     := TMPSRT->RT_VALOR
		cCCusto    := Alltrim(TMPSRT->RT_CC)
		
		RecLock("TRB",.T.)
		TRB->TR_FILIAL     := TMPSRT->RT_FILIAL
		TRB->TR_PD         := cVerba
		TRB->TR_VAL        := nValor
		TRB->TR_CC         := cCcusto
		TRB->TR_DATA       := dData
		TRB->TR_MAT        := cMatricula
		TRB->TR_TPC        := "O"
		MsUnLock("TRB")
		
		If TRB->TR_TPC == "O"
			
			//Procura a Matricula no SRE e identifica o Centro de Custo de Destino
			SRE->(DbSeek("NH01"+cMatricula))
			While !SRE->(EOF()) .AND. SRE->RE_MATD == cMatricula
				If Substr(Dtos(SRE->RE_DATA),1,6) == Substr(Dtos(dData),1,6)
					cCCP:=SRE->RE_CCP				
					Exit
				Endif		
				SRE->(DbSkip())
			Enddo
			nTotCCusto :=nTotCCusto+nValor
			
			
			RecLock("TRB",.T.)
			TRB->TR_FILIAL     := SRT->RT_FILIAL
			TRB->TR_PD         := cVerba
			TRB->TR_VAL        := nValor
			TRB->TR_CC         := cCCP
			TRB->TR_DATA       := dData
			TRB->TR_MAT        := cMatricula
			TRB->TR_TPC        := "D"
			_nTotReg := _nTotReg + 1
			MsUnLock("TRB")

		Else
			Exit
		Endif
		DbSkip() // Avanca o ponteiro do registro no arquivo
		
	Endif
	TMPSRT->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	
Enddo

Return


Static Function fRunReport()

_TotVerCC   := 0.00
_nTotCCusto := 0.00
_cArqNtx    := CriaTrab(NIL,.f.)
_cOrdem     := "TRB->TR_PD + TRB->TR_CC"

DbSelectArea("TRB")
IndRegua("TRB",_cArqNtx,_cOrdem) //"Selecionando Registros..."
TRB->(DbGotop())
While TRB->(!Eof())

	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	If TRB->TR_TPC == "D" //.and. TRB->TR_PD == cVerba .and. Alltrim(TRB->TR_CC) == Alltrim(cCCP)
		
		@ nLin,02 PSAY TRB->TR_CC
		@ nLin,15 PSAY DTOC(TRB->TR_DATA)
		@ nLin,27 PSAY TRB->TR_PD
		@ nLin,35 PSAY TRB->TR_VAL Picture "@E 99,999,999.99"
		@ nLin,60 PSAY TRB->TR_MAT
		@ nLin,70 PSAY TRB->TR_TPC
		
		_nTotCCusto := _nTotCCusto + TRB->TR_VAL
		
		nLin := nLin + 1 // Avanca a linha de impressao
		
	Endif
	
	TRB->(DbSkip())
EndDo

@nLin+2,05 PSAY "Total C.Custo Destino"
@nLin+2,35 PSAY _nTotCCusto Picture "@E 99,999,999.99"

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()
DbSelectArea("TMPSRT")
DbCloseArea()

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �VALIDPERG � Autor � AP6 IDE            � Data �  17/06/03   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario (caso nao existam).                             ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Da Data           ?","Da Data           ?","Da Data           ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate a Data        ?","Ate a Data        ?","Ate a Data        ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"03","Verbas            ?","Verbas            ?","Verbas            ?","mv_ch3","C",40,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
