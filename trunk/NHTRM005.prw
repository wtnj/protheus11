#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHTRM005  บAutor  ณFelipe Ciconini     บ Data ณ  09/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de Cursos x Funcionarios                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Perguntas:

mv_par01 = De Produto
mv_par02 = At้ Produto
mv_par03 = De Curso
mv_par04 = At้ Curso
mv_par05 = Situa็ใo
mv_par06 = De Data
mv_par07 = Ate Data
mv_par08 = De C.Custo
mv_par09 = Ate C.Custo
mv_par10 = Empresa

*/

User Function NHTRM005()

cString		:= "RA1"
cDesc1		:= "Este relatorio tem como objetivo Imprimir os cursos"
cDesc2      := "que cada funcionario fez"
cDesc3      := ""      
tamanho		:= "G"
limite		:= 132
aReturn		:= { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHTRM005"
nLastKey	:= 0
titulo		:= OemToAnsi("CONTROLE DE PEวAS PARA RETRABALHO")
cabec1    	:= ""
cabec2		:= ""
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1 //Variavel da pagina
M_PAG		:= 1
wnrel		:= "NHTRM005"
_cPerg		:= "TRM005"

Pergunte(_cPerg,.F.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

If nLastKey == 27
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)
nTipo		:= IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))

aDriver		:= ReadDriver()
cCompac		:= aDriver[1]

Processa({|| Gerando()  },"Gerando Dados para Impressao")
Processa({|| RptDetail()  },"Imprimindo...")

Set Filter To
If aReturn[5]==1
	Set Printer To
	Commit
	OurSpool(wnrel)
EndIf
MS_FLUSH()
Return

Static Function Gerando()
Local cQuery
Local aSit := {}
	
	If SubStr(mv_par05,1,1) <> "*"
		aAdd(aSit," ")
	EndIf
	If SubStr(mv_par05,2,1) <> "*"
		aAdd(aSit,"A")
	EndIf
	If SubStr(mv_par05,3,1) <> "*"
		aAdd(aSit,"D")
	EndIf
	If SubStr(mv_par05,4,1) <> "*"
		aAdd(aSit,"F")
	EndIf
	If SubStr(mv_par05,5,1) <> "*"
		aAdd(aSit,"T")
	EndIf
		
	cQuery := "SELECT RA.RA_MAT,RA.RA_NOME,RA.RA_ZEMP,RA1.RA1_CURSO,RA1.RA1_DESC,RA4.RA4_DATAIN,RA4.RA4_DATAFI,RA4.RA4_NOTA,RA4.RA4_EFICAC,RA4.RA4_HORAS,"
	cQuery += " RA0.RA0_ENTIDA,RA0.RA0_DESC,CTT.CTT_DESC01,CTT.CTT_CUSTO"
	cQuery += " FROM "+RetSqlName("RA1")+" RA1, "+RetSqlName("RA4")+" RA4, "+RetSqlName("SRA")+" RA, "+RetSqlName("RA0")+" RA0, "+RetSqlName("CTT")+" CTT "
	cQuery += " WHERE RA1.RA1_CURSO = RA4.RA4_CURSO"
	cQuery += " AND RA4.RA4_MAT 	= RA.RA_MAT"
	cQuery += " AND RA4.RA4_ENTIDA	= RA0.RA0_ENTIDA"
	cQuery += " AND RA.RA_CC		= CTT.CTT_CUSTO"
	cQuery += " AND RA.RA_MAT		BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND RA1.RA1_CURSO 	BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND RA4.RA4_DATAIN	BETWEEN '"+DtoS(mv_par06)+"' AND '"+DtoS(mv_par07)+"'"
	cQuery += " AND CTT.CTT_CUSTO	BETWEEN '"+mv_par08+"' AND '"+mv_par09+"'"
	cQuery += " AND RA.RA_NOME		BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'"

	//If mv_par10 <> 3
	//	cQuery += " AND RA.RA_ZEMP	= '"+Str(mv_par10,1)+"'"
	//EndIf
                

	cQuery += " AND RA.RA_SITFOLH IN (

	For xD:=1 to len(aSit)
		cQuery += "'"+aSit[xD]+"'"
		If len(aSit) > 1 .AND. xD < len(aSit)
			cQuery += ","
		EndIf
	Next
	cQuery += ")"
	cQuery += " AND RA.D_E_L_E_T_ 	= ''"
	cQuery += " AND RA1.D_E_L_E_T_ 	= ''"
	cQuery += " AND RA0.D_E_L_E_T_ 	= ''"
	cQuery += " AND RA4.D_E_L_E_T_ 	= ''"
	cQuery += " AND CTT.D_E_L_E_T_	= ''"
	cQuery += " AND RA.RA_FILIAL 	= '"+xFilial("SRA")+"'"
	cQuery += " AND RA1.RA1_FILIAL 	= '"+xFilial("RA1")+"'"
	cQuery += " AND RA0.RA0_FILIAL 	= '"+xFilial("RA0")+"'"
	cQuery += " AND RA4.RA4_FILIAL 	= '"+xFilial("RA4")+"'"
	cQuery += " AND CTT.CTT_FILIAL 	= '"+xFilial("CTT")+"'"

	cQuery += " ORDER BY RA1_CURSO"
	MemoWrit('C:\TEMP\NHTRM005.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TMP1"
	
	TMP1->(DbGoTop())
	
Return

Static Function RptDetail()
Local cCurso := TMP1->RA1_CURSO

	Titulo := "CURSOS X FUNCIONARIOS"
	Cabec1 := OemToAnsi(" CURSO:  "+AllTrim(TMP1->RA1_CURSO)+" / "+AllTrim(TMP1->RA1_DESC))
	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)

	@Prow()+1,001 PSAY "MATR     NOME                                    DATA INI        DATA FINAL           HORAS        FREQUENCIA             NOTA        ENTIDADE                              CENT CUSTO   DESCRIวรO"
	@Prow()+1,000 PSAY __PrtThinLine()
	                  //1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	                  //         10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190
	
	While TMP1->(!EoF())
		If Prow() > 65
			Cabec1 := OemToAnsi(" CURSO:  "+AllTrim(TMP1->RA1_CURSO)+" / "+AllTrim(TMP1->RA1_DESC))
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
						
			@Prow()+1,001 PSAY "MATR     NOME                                    DATA INI        DATA FINAL           HORAS        FREQUENCIA             NOTA        ENTIDADE                              CENT CUSTO   DESCRIวรO"
			@Prow()+1,000 PSAY __PrtThinLine()
		EndIf
		
		If cCurso <> TMP1->RA1_CURSO
			@Prow()+2,000 PSAY __PrtThinLine()
			@Prow()+1,001 PSAY "CURSO:  "+AllTrim(TMP1->RA1_CURSO)+" / "+AllTrim(TMP1->RA1_DESC)
			@Prow()+1,000 PSAY __PrtThinLine()
			@Prow()+1,001 PSAY "MATR     NOME                                    DATA INI        DATA FINAL           HORAS        FREQUENCIA             NOTA        ENTIDADE                              CENT CUSTO   DESCRIวรO"
			@Prow()+1,000 PSAY __PrtThinLine()
			cCurso := TMP1->RA1_CURSO
		EndIf
	    
		@Prow()+1,001 PSAY TMP1->RA_MAT
		@Prow()  ,010 PSAY TMP1->RA_NOME
		@Prow()  ,050 PSAY StoD(TMP1->RA4_DATAIN)
		@Prow()  ,066 PSAY StoD(TMP1->RA4_DATAFI)
		@Prow()  ,085 PSAY Str(TMP1->RA4_HORAS,7,2)
		@Prow()  ,100 PSAY Str(TMP1->RA4_EFICAC,7,2)+"%"
		@Prow()  ,120 PSAY Str(TMP1->RA4_NOTA,7,2)
		@Prow()  ,135 PSAY TMP1->RA0_ENTIDA+"-"+SubStr(TMP1->RA0_DESC,1,30)
		@Prow()  ,173 PSAY TMP1->CTT_CUSTO
		@Prow()  ,186 PSAY SubStr(TMP1->CTT_DESC01,1,30)
		
		TMP1->(DbSkip())
 	EndDo
 	
 	TMP1->(DbCloseArea())

Return