/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GP110ACT  ºAutor  ³Marcos R. Roquitski º Data ³  27/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada na Contabilizacao da Folha.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function Gp110ACT()
   

Return

/*
If SM0->M0_CODIGO = 'FN'
	Return
Endif
	
If Mv_par02 <> 4
	Return
Endif	



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cString      :="SRT"
Private aOrd         := {}  
Private CbTxt        := "CONFERÊNCIA DE TRANSFERÊNCIAS POR C.CUSTO"
Private cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2       := "de acordo com os parametros informados pelo usuario."
Private cDesc3       := "RELAÇÃO DE TRANSFERÊNCIAS POR C.CUSTO"
Private cPict        := "CONTABILIZAÇÃO DAS TRANSFERÊNCIAS - APROPRIAÇÃO CORRETA"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "CONTRANSF" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "CONTRA"
Private titulo       := "CONTABILIZAÇÃO TRANSFERÊNCIA"
Private nLin         := 80
Private Cabec1       := "C.C.Destino     Data      Verba          Valor           Matricula   Tipo"
Private Cabec2       := ""
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private imprime      := .T.
Private wnrel        := "CONTRA" // Coloque aqui o nome do arquivo usado para impressao em disco
Private lEnd         := .F.
Private cString      := "SRT"
Private dDatai
Private dDataf

Gerando()
fProcTemp()

DbSelectArea("TMPSRT")
DbCloseArea()

Return


Static Function fProcTemp()

dData      :=" "
cMatricula :=" "
cCCD       :=" "
cCCP       :=" "
cVerba     :=" "
nValor     :=0.00
cCCusto    :=" "
nTotCCusto :=0.00
_cSRZarea  :=SRZ->(GetArea())
_nTotReg   :=0.00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando Arquivo Temporario para posterior impressao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
AADD(_aFields,{"TR_FD    " ,"C", 1,0})         // Tipo Ferias/Decimo

DbCreate(_cArqDBF,_aFields)
DbUseArea(.T.,,_cArqDBF,"TRB",.F.)


DbSelectArea("SRZ")
DbSetOrder(1)

dbSeek(xFilial("SRZ"),.T.) // Posiciona no 1o.reg. satisfatorio ³
While !EOF()
	If SRZ->RZ_TPC=="O" .or. SRZ->RZ_TPC=="D"
		RecLock("SRZ",.F.)
		SRZ->(DbDelete())
		MsUnLock("SRZ",.F.)
	Endif
	DbSkip()
End

SRE->(DbSelectArea("SRE")) //Abre arquivo Provisões
SRE->(DbSetOrder(1))

dbSelectArea("TMPSRT")
TMPSRT->(Dbgotop())
While !TMPSRT->(EOF())

	// MsProcTxt("Matricula : "+TMPSRT->RT_MAT)
	// Ferias


	If DTOS(TMPSRT->RT_DATACAL)==DTOS(dDataf) .and. (TMPSRT->RT_VERBA=="768";
		.or. TMPSRT->RT_VERBA=="769" .or. TMPSRT->RT_VERBA=="775" .or. TMPSRT->RT_VERBA=="776";
		.or. TMPSRT->RT_VERBA=="777")
		
		dData      := TMPSRT->RT_DATACAL
		cMatricula := TMPSRT->RT_MAT
		cVerba     := TMPSRT->RT_VERBA
		nValor     := TMPSRT->RT_VALOR
		cCCusto    := Alltrim(TMPSRT->RT_CC)
		
		RecLock("TRB",.T.)
		TRB->TR_FILIAL     := "01"
		TRB->TR_PD         := cVerba
		TRB->TR_VAL        := nValor
		TRB->TR_CC         := cCcusto
		TRB->TR_DATA       := dData
		TRB->TR_MAT        := cMatricula
		TRB->TR_TPC        := "O"
		TRB->TR_FD         := "PF"
		_fGravaSRZ()
		
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
			TRB->TR_FILIAL     := "01"
			TRB->TR_PD         := cVerba
			TRB->TR_VAL        := nValor
			TRB->TR_CC         := cCCP
			TRB->TR_DATA       := dData
			TRB->TR_MAT        := cMatricula
			TRB->TR_TPC        := "D"
			_nTotReg := _nTotReg + 1
			MsUnLock("TRB")
			_fGravaSRZ()
		Else
        	Exit
        Endif	
		Dbskip()

		
	Elseif DTOS(TMPSRT->RT_DATACAL)==DTOS(dDataf) .and. (TMPSRT->RT_VERBA=="722" .or. TMPSRT->RT_VERBA=="724";
		.or. TMPSRT->RT_VERBA=="726" .or. TMPSRT->RT_VERBA=="728")
		
		dData      := TMPSRT->RT_DATACAL
		cMatricula := TMPSRT->RT_MAT
		cVerba     := TMPSRT->RT_VERBA
		nValor     := TMPSRT->RT_VALOR
		cCCusto    := Alltrim(TMPSRT->RT_CC)
		
		RecLock("TRB",.T.)
		TRB->TR_FILIAL     := "01"
		TRB->TR_PD         := cVerba
		TRB->TR_VAL        := nValor
		TRB->TR_CC         := cCcusto
		TRB->TR_DATA       := dData
		TRB->TR_MAT        := cMatricula
		TRB->TR_TPC        := "O"
		_fGravaSRZ()
		
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
			TRB->TR_FILIAL     := "01"
			TRB->TR_PD         := cVerba
			TRB->TR_VAL        := nValor
			TRB->TR_CC         := cCCP
			TRB->TR_DATA       := dData
			TRB->TR_MAT        := cMatricula
			TRB->TR_TPC        := "D"
			TRB->TR_FD         := "PD"
			_nTotReg := _nTotReg + 1
			MsUnLock("TRB")
			_fGravaSRZ()
		Else

			Exit

		Endif
		DbSkip() // Avanca o ponteiro do registro no arquivo
		
	Endif
	TMPSRT->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	
Enddo

Return


Static Function Gerando()

dDatai := Ctod("01/"+Substr(Dtos(dDataBase),5,2)+"/"+Substr(Dtos(dDataBase),1,4))
dDataf := Ctod(StrZero(f_UltDia(dDataBase),2)+"/"+Substr(Dtos(dDataBase),5,2)+"/"+ Substr(Dtos(dDataBase),1,4))

cQuery := "SELECT * FROM SRTNH0"         
cQuery := cQuery + " WHERE RT_DATACAL BETWEEN '" + DtoS(dDatai) + "' AND '" + DtoS(dDataf) + "' "
cQuery := cQuery + " AND D_E_L_E_T_ <> '*' "
cQuery := cQuery + " ORDER BY RT_FILIAL, RT_DATACAL, RT_VERBA ASC"

//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMPSRT"
TcSetField("TMPSRT","RT_DATACAL","D")  // Muda a data de string para date

Return(NIL)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gravacao no Arquivo de Contabilizacao - SRZ                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static FUNCTION _fGravaSRZ()
SRZ->(DbSeek(xFilial("SRZ")+cCcusto+cVerba))
If SRZ->(Found())
	RecLock("SRZ",.F.) // REGRAVA NO REGISTRO JA EXISTENTE
Else
	RecLock("SRZ",.T.) // GRAVA REGISTRO NOVO
EndIf
SRZ->RZ_FILIAL  := TRB->TR_FILIAL
SRZ->RZ_CC      := TRB->TR_CC
SRZ->RZ_PD      := TRB->TR_PD
SRZ->RZ_HRS     := 0.00
SRZ->RZ_VAL     := TRB->TR_VAL
SRZ->RZ_OCORREN := 0
SRZ->RZ_TIPO    := TRB->TR_FD
SRZ->RZ_TPC     := TRB->TR_TPC
SRZ->RZ_CC2002  := " "
SRZ->RZ_MAT     := "zzzzzz"
MsUnLock("SRZ")

Return
*/
