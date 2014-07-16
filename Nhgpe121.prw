/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHGPE121  บAutor  ณMarcos R Roquitski  บ Data ณ  29/04/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de custo da folha de pagamento.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAP                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhgpe121()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave,nTipo,aReturn,NOMEPROG,ALINHA,NLASTKEY,LEND")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,CCOMPAC,CNORMAL,CQUERY,TITULO,CABEC1")
SetPrvt("dDataRef,cFilDe,cFilAte,cCcDe,cCcAte,cMatDe,cMatAte,cNomeDe,cNomeAte,nAnaSin,nGerRes,lImpNiv,cCateg")
SetPrvt("_nVlSalario,_nVlExtras,_nVlFerias,_nVlRct,_nVl131,_nVl132,_nVlFgts,_nVlInss,_nVlAdNot,_nVlRct,_nVlSalMat,_nVlEstagio,_nVlFgts,nVlInss,_ntVlInss")
SetPrvt("_ntVlSalario,_ntVlExtras,_ntVlFerias,_ntVlRct,_ntVl131,_ntVl132,_ntVlFgts,_ntVlInss,_ntVlAdNot,ntVlRct,_ntVlSalMat,_ntVlEstagio,_ntVlFgts")
SetPrvt("_ntVlAsMed,_nVlAsMed")
SetPrvt("_ntVlTrans,_nVlTrans")
SetPrvt("_ntVlRefei,_nVlRefei")
SetPrvt("_ntVlMerca,_nVlMerca")
SetPrvt("_ntVlOdont,_nVlOdont")
SetPrvt("_ntVlFarma,_nVlFarma")

SetPrvt("_ntVlSesmt,_nVlSesmt")
SetPrvt("_ntVlRecru,_nVlRecru")
SetPrvt("_ntVlSindi,_nVlSindi")
SetPrvt("_ntVlSerso,_nVlSerso")
SetPrvt("_ntVlRpaci,_nVlRpaci")
SetPrvt("_ntVlMdtsg,_nVlMdtsg")

cString   := "SC7"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir")
cDesc2    := OemToAnsi("resumo gerencial salarios/ferias/rescisao/13.salario/fgts/inss")
cDesc3    := OemToAnsi("")
tamanho   := "G"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
//nControle := 15
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHGPE121"
aLinha    := {}
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "Resumo Gerencial salarios/ferias/rescisao/13.salario/fgts/inss"
Cabec1    := " C.Custo      Salarios       H.Extras    Ad. Noturno   Ferias/Abono   13o. Salario       Rescisao    Maternidade    Estagiarios           FGTS           INSS      As.Medica  V.Transp.    Refeicao    Mercado         TOTAL"
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13
Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHGPE121"
_cPerg    := "NHGP21"
aMatriz   := {}
_aPed     := {}
_axPed    := {}
_nTotPe   := 0
_nIpi     := 0
_anPed    := {}
_azPed    := {}	

_ntVlSalario:= 0
_ntVlExtras := 0
_ntVlFerias := 0
_ntVlAdNot := 0
_ntVlRct := 0
_ntVl131 := 0
_ntVl132 := 0
_ntVlFgts := 0
_ntVlInss := 0
_ntVlRct := 0
_ntVlSalMat  := 0
_ntVlEstagio := 0
_ntVlFgts := 0
_ntVlInss := 0
_ntVlAsMed := 0
_ntVlTrans := 0
_ntVlRefei := 0
_ntVlMerca := 0
_ntVlOdont := 0
_ntVlFarma := 0
_ntVlSesmt := 0
_ntVlRecru := 0
_ntVlSindi := 0
_ntVlSerso := 0
_ntVlRpaci := 0
_ntVlMdtsg := 0


If !Pergunte(_cPerg,.T.) //Ativa os parametros
	Return(nil)
Endif
                                   
wnRel := SetPrint(cString,wnrel,_cperg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")
If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo   := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))
aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]
dDataRef:= mv_par01                             // Data de Referencia
cFilDe	:= mv_par02								//	Filial De
cFilAte := mv_par03								//	Filial Ate
cCcDe	:= mv_par04								//	Centro de Custo De
cCcAte	:= mv_par05								//	Centro de Custo Ate

// inicio do processamento do relat๓rio
Processa( {|| Geract2() },"Gerando Dados para a Impressao")
                  
//inicio da impressao
Processa( {|| RptDet() },"Imprimindo...")
     
DbSelectArea("TMP")
DbCloseArea("TMP")


DbSelectArea("TM2")
DbCloseArea("TM2")


Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function GeraCt2()
	//**********************************
	cQuery := "SELECT * FROM " + RetSqlName('CT2') + " CT2, " +  RetSqlName('CT1') + " CT1 "
	cQuery += "WHERE CT1.CT1_GRUPOC IN ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24') "
	cQuery += "AND CT2.CT2_CCD BETWEEN '"+ Mv_par04 + "' AND '"+ Mv_par05 + "' "	
	cQuery += "AND SUBSTRING(CT2.CT2_DATA,1,6) = '" + Substr(Dtos(Mv_par01),1,6) + "' "
	cQuery += "AND CT2.CT2_DEBITO = CT1.CT1_CONTA "	
    cQuery += "AND CT2.CT2_FILIAL = '" + xFilial("CT2")+ "'"	
	cQuery += "AND CT2.D_E_L_E_T_ = ' ' "
	cQuery += "AND CT2.CT2_CCD <> '' "	
	cQuery += "AND CT2.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY CT2.CT2_CCD"

	//TCQuery Abre uma workarea com o resultado da query
	MemoWrit('C:\TEMP\NHGPE121A.SQL',cQuery)

	TCQUERY cQuery NEW ALIAS "TMP"                      


	//**********************************
	cQuery := "SELECT * FROM " + RetSqlName('CT2') + " CT2, " +  RetSqlName('CT1') + " CT1 "
	cQuery += "WHERE CT1.CT1_GRUPOC IN ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24') "
	cQuery += "AND CT2.CT2_CCD BETWEEN '"+ Mv_par04 + "' AND '"+ Mv_par05 + "' "
	cQuery += "AND SUBSTRING(CT2.CT2_DATA,1,6) = '" + Substr(Dtos(Mv_par01),1,6) + "' "
	cQuery += "AND CT2.CT2_CREDIT = CT1.CT1_CONTA "
	cQuery += "AND CT2.CT2_CCC <> '' "
    cQuery += "AND CT2.CT2_FILIAL = '" + xFilial("CT2")+ "'"	
	cQuery += "AND CT2.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY CT2.CT2_CCC"

	//TCQuery Abre uma workarea com o resultado da query
	MemoWrit('C:\TEMP\NHGPE121B.SQL',cQuery)

	TCQUERY cQuery NEW ALIAS "TM2"
Return




Static Function RptDet()
Local _lRet := .F.,	_nToth1 := _nTotg1 := 0
titulo    := "Resumo Gerencial "+MesExtenso(mv_par01)+"/"+Substr(Dtos(Mv_par01),1,4)
cCusto := Space(10)
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
TM2->(DbGotop())
DbSelectArea("TMP") 
TMP->(DbGotop())

While TMP->(!eof())
	If Prow() > 56
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
	Endif
	
	_cCusto := TMP->CT2_CCD
	@ Prow() +1, 000 Psay Substr(TMP->CT2_CCD,1,8)

	While TMP->CT2_CCD == _cCusto
		fTotHrm()
		fTotHrm2()
		_nToth1 := (_nVlSalario+_nVlExtras+_nVlAdNot+_nVlFerias+_nVl131+_nVlRct+_nVlSalMat+_nVlEstagio+_nVlFgts+_nVlInss+_nVlAsMed+_nVlTrans+_nVlRefei+_nVlMerca)
		@ Prow()   , 010 PSAY Transform(_nVlSalario,"@E 9,999,999.99")
		@ Prow()   , 025 PSAY Transform(_nVlExtras,"@E 9,999,999.99")
		@ Prow()   , 040 PSAY Transform(_nVlAdNot,"@E 9,999,999.99")
		@ Prow()   , 055 PSAY Transform(_nVlFerias,"@E 9,999,999.99")
		@ Prow()   ,  70 PSAY Transform(_nVl131,"@E 9,999,999.99")
		@ Prow()   ,  85 PSAY Transform(_nVlRct,"@E 9,999,999.99")
		@ Prow()   , 100 PSAY Transform(_nVlSalMat,"@E 9,999,999.99")
		@ Prow()   , 115 PSAY Transform(_nVlEstagio,"@E 9,999,999.99")
		@ Prow()   , 130 PSAY Transform(_nVlFgts,"@E 9,999,999.99")
		@ Prow()   , 145 PSAY Transform(_nVlInss,"@E 9,999,999.99")
		@ Prow()   , 160 PSAY Transform(_nVlAsMed,"@E 9,999,999.99")
		@ Prow()   , 173 PSAY Transform(_nVlTrans,"@E 999,999.99")
		@ Prow()   , 185 PSAY Transform(_nVlRefei,"@E 999,999.99")
		@ Prow()   , 196 PSAY Transform(_nVlMerca,"@E 999,999.99")
		@ Prow()   , 208 PSAY Transform(_nToth1,"@E 9,999,999.99")
	Enddo
	_nTotg1 += _nToth1
	_nToth1 := 0
Enddo
@ Prow() +1, 000 PSAY __PrtThinLine()
@ Prow() +1, 001 Psay "Total:"
@ Prow()   ,  10 PSAY Transform(_ntVlSalario,"@E 9,999,999.99")
@ Prow()   ,  25 PSAY Transform(_ntVlExtras,"@E 9,999,999.99")
@ Prow()   ,  40 PSAY Transform(_ntVlAdNot,"@E 9,999,999.99")
@ Prow()   ,  55 PSAY Transform(_ntVlFerias,"@E 9,999,999.99")
@ Prow()   ,  70 PSAY Transform(_ntVl131,"@E 9,999,999.99")
@ Prow()   ,  85 PSAY Transform(_ntVlRct,"@E 9,999,999.99")
@ Prow()   , 100 PSAY Transform(_ntVlSalMat,"@E 9,999,999.99")
@ Prow()   , 115 PSAY Transform(_ntVlEstagio,"@E 9,999,999.99")
@ Prow()   , 130 PSAY Transform(_ntVlFgts,"@E 9,999,999.99")
@ Prow()   , 145 PSAY Transform(_ntVlInss,"@E 9,999,999.99")
@ Prow()   , 160 PSAY Transform(_ntVlAsMed,"@E 9,999,999.99")
@ Prow()   , 173 PSAY Transform(_ntVlTrans,"@E 999,999.99")
@ Prow()   , 185 PSAY Transform(_ntVlRefei,"@E 999,999.99")
@ Prow()   , 196 PSAY Transform(_ntVlMerca,"@E 999,999.99")
@ Prow()   , 208 PSAY Transform(_nTotg1,"@E 9,999,999.99")
@ Prow() +1, 000 PSAY __PrtThinLine()

RptDet1()

Return



Static Function fTotHrm()
Local _cTipoCod := Space(01)
_nVlSalario := 0
_nVlExtras  := 0 
_nVlAdNot   := 0
_nVlFerias  := 0
_nVlRct     := 0
_nVl131     := 0
_nVl132     := 0
_nVlFgts    := 0
_nVlInss    := 0
_nVlRct     := 0
_nVlSalMat  := 0
_nVlEstagio := 0
_nVlFgts    := 0
_nVlInss    := 0
_nVlAsMed   := 0
_nVlTrans   := 0
_nVlRefei   := 0
_nVlMerca   := 0
_nVlOdont   := 0
_nVlFarma   := 0
_nVlSesmt   := 0
_nVlRecru   := 0
_nVlSindi   := 0
_nVlSerso   := 0
_nVlRpaci   := 0
_nVlMdtsg   := 0

While TMP->(!eof()) .AND. _cCusto == TMP->CT2_CCD
		
	If TMP->CT1_GRUPOC == '01' // Salario
		_nVlSalario += TMP->CT2_VALOR
		_ntVlSalario += TMP->CT2_VALOR
			
	Elseif TMP->CT1_GRUPOC == '02' // Horas extras
		_nVlextras += TMP->CT2_VALOR
		_ntVlextras += TMP->CT2_VALOR
		

	Elseif TMP->CT1_GRUPOC == '03' // Adicional Noturno
		_nVlAdNot += TMP->CT2_VALOR
		_ntVlAdNot += TMP->CT2_VALOR

	Elseif TMP->CT1_GRUPOC == '04' // Ferias e Abono
		_nVlFerias += TMP->CT2_VALOR
		_ntVlFerias += TMP->CT2_VALOR

	Elseif TMP->CT1_GRUPOC == '05' // Decimo Terceiro
		_nVl131 += TMP->CT2_VALOR
		_ntVl131 += TMP->CT2_VALOR

	Elseif TMP->CT1_GRUPOC == '07' // Salario maternidade
	    _nVlSalMat  += TMP->CT2_VALOR
		_ntVlSalMat += TMP->CT2_VALOR

	Elseif TMP->CT1_GRUPOC == '08' // Rescisao
		_nVlRct += TMP->CT2_VALOR
		_ntVlRct += TMP->CT2_VALOR

	Elseif TMP->CT1_GRUPOC == '09' // Estagiarios
		_nVlEstagio += TMP->CT2_VALOR
		_ntVlEstagio += TMP->CT2_VALOR

 	Elseif TMP->CT1_GRUPOC == '10' // Fgts
		_nVlFgts += TMP->CT2_VALOR
		_ntVlFgts += TMP->CT2_VALOR
 
 	Elseif TMP->CT1_GRUPOC == '11' // INSS
		_nVlInss += TMP->CT2_VALOR
		_ntVlInss += TMP->CT2_VALOR

 	Elseif TMP->CT1_GRUPOC == '12' // Assistencia medica
		_nVlAsMed += TMP->CT2_VALOR
		_ntVlAsMed += TMP->CT2_VALOR

 	Elseif TMP->CT1_GRUPOC == '13' // Vale transporte
		_nVlTrans += TMP->CT2_VALOR
		_ntVlTrans += TMP->CT2_VALOR

  	Elseif TMP->CT1_GRUPOC == '14' // Refeicao
		_nVlRefei += TMP->CT2_VALOR
		_ntVlRefei += TMP->CT2_VALOR
 
  	Elseif TMP->CT1_GRUPOC == '15' // Mercado
		_nVlMerca += TMP->CT2_VALOR
		_ntVlMerca += TMP->CT2_VALOR

  	Elseif TMP->CT1_GRUPOC == '16' // Odontologica
		_nVlOdont += TMP->CT2_VALOR
		_ntVlOdont += TMP->CT2_VALOR

	Endif
    
	TMP->(Dbskip())

Enddo

Return


Static Function fTotHrm2()
Local _cTipoCod := Space(01)

TM2->(DbGotop())
While TM2->(!eof()) 

	If _cCusto == TM2->CT2_CCC
		
		If TM2->CT1_GRUPOC == '01' // Salario
			_nVlSalario -= TM2->CT2_VALOR
			_ntVlSalario -= TM2->CT2_VALOR
			
		Elseif TM2->CT1_GRUPOC == '02' // Horas extras
			_nVlextras -= TM2->CT2_VALOR
			_ntVlextras -= TM2->CT2_VALOR

		Elseif TM2->CT1_GRUPOC == '03' // Adicional Noturno
			_nVlAdNot -= TM2->CT2_VALOR
			_ntVlAdNot -= TM2->CT2_VALOR

		Elseif TM2->CT1_GRUPOC == '04' // Ferias e Abono
			_nVlFerias -= TM2->CT2_VALOR
			_ntVlFerias -= TM2->CT2_VALOR

		Elseif TM2->CT1_GRUPOC == '05' // Decimo Terceiro
			_nVl131 -= TM2->CT2_VALOR
			_ntVl131 -= TM2->CT2_VALOR

		Elseif TM2->CT1_GRUPOC == '07' // Salario maternidade
		    _nVlSalMat  -= TM2->CT2_VALOR
			_ntVlSalMat -= TM2->CT2_VALOR

		Elseif TM2->CT1_GRUPOC == '08' // Rescisao
			_nVlRct -= TM2->CT2_VALOR
			_ntVlRct -= TM2->CT2_VALOR

		Elseif TM2->CT1_GRUPOC == '09' // Estagiarios
			_nVlEstagio -= TM2->CT2_VALOR
			_ntVlEstagio -= TM2->CT2_VALOR

	 	Elseif TM2->CT1_GRUPOC == '10' // Fgts
			_nVlFgts -= TM2->CT2_VALOR
			_ntVlFgts -= TM2->CT2_VALOR
 
	 	Elseif TM2->CT1_GRUPOC == '11' // INSS
			_nVlInss -= TM2->CT2_VALOR
			_ntVlInss -= TM2->CT2_VALOR

		Elseif TM2->CT1_GRUPOC == '12' // Assistencia medica
			_nVlAsMed -= TM2->CT2_VALOR
			_ntVlAsMed -= TM2->CT2_VALOR

	 	Elseif TM2->CT1_GRUPOC == '13' // Vale transporte
			_nVlTrans -= TM2->CT2_VALOR
			_ntVlTrans -= TM2->CT2_VALOR

	  	Elseif TM2->CT1_GRUPOC == '14' // Refeicao
			_nVlRefei -= TM2->CT2_VALOR
			_ntVlRefei -= TM2->CT2_VALOR
	 
	  	Elseif TM2->CT1_GRUPOC == '15' // Mercado
			_nVlMerca -= TM2->CT2_VALOR
			_ntVlMerca -= TM2->CT2_VALOR

	  	Elseif TM2->CT1_GRUPOC == '16' // Odontologica
			_nVlOdont -= TM2->CT2_VALOR
			_ntVlOdont -= TM2->CT2_VALOR

		Endif
    
	Endif   

	TM2->(Dbskip())

Enddo

Return


Static Function fNomecc(_pCusto)
Local _cDesc := Space(30)
If CTT->(DbSeek(xFilial("CTT") + _pCusto))	
	_cDesc := CTT->CTT_DESC01
Endif	
Return(_cDesc)

Static Function RptDet1()
Local _lRet := .F.,_nToth1 := _nTotg1 := 0
titulo    := "Resumo Gerencial "+MesExtenso(mv_par01)+"/"+Substr(Dtos(Mv_par01),1,4)
cCusto := Space(10)
Cabec1    := " C.Custo        Odonto       Farmacia          SESMT  Recrut./Selec      Sindicato    Serv.Social    RPA Audiom.       Medicina          TOTAL"
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
DbSelectArea("TMP") 
dbgotop()

While TMP->(!eof())
	If Prow() > 56
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
	Endif
	
	_cCusto := TMP->CT2_CCD
	@ Prow() +1, 001 Psay Substr(TMP->CT2_CCD,1,6)

	While TMP->CT2_CCD == _cCusto
		fTotHrm()
		_nToth1 := (_nVlOdont + _nVlFarma + _nVlSesmt + _nVlRecru + _nVlSindi + _nVlSerso + _nVlRpaci + _nVlMdtsg)
		@ Prow()   ,  10 PSAY Transform(_nVlOdont,"@E 9,999,999.99")
		@ Prow()   ,  25 PSAY Transform(_nVlFarma,"@E 9,999,999.99")
		@ Prow()   ,  40 PSAY Transform(_nVlSesmt,"@E 9,999,999.99")
		@ Prow()   ,  55 PSAY Transform(_nVlRecru,"@E 9,999,999.99")
		@ Prow()   ,  70 PSAY Transform(_nVlSindi,"@E 9,999,999.99")
		@ Prow()   ,  85 PSAY Transform(_nVlSerso,"@E 9,999,999.99")
		@ Prow()   , 100 PSAY Transform(_nVlRpaci,"@E 9,999,999.99")
		@ Prow()   , 115 PSAY Transform(_nVlMdtsg,"@E 9,999,999.99")
		@ Prow()   , 130 PSAY Transform(_nToth1,"@E 9,999,999.99")
	Enddo
	_nTotg1 += _nToth1
	_nToth1 := 0
Enddo
@ Prow() +1, 000 PSAY __PrtThinLine()
@ Prow() +1, 001 Psay "Total:"
@ Prow()   ,  10 PSAY Transform(_ntVlOdont,"@E 9,999,999.99")
@ Prow()   ,  25 PSAY Transform(_ntVlFarma,"@E 9,999,999.99")
@ Prow()   ,  40 PSAY Transform(_ntVlSesmt,"@E 9,999,999.99")
@ Prow()   ,  55 PSAY Transform(_ntVlRecru,"@E 9,999,999.99")
@ Prow()   ,  70 PSAY Transform(_ntVlSindi,"@E 9,999,999.99")
@ Prow()   ,  85 PSAY Transform(_ntVlSerso,"@E 9,999,999.99")
@ Prow()   , 100 PSAY Transform(_ntVlRpaci,"@E 9,999,999.99")
@ Prow()   , 115 PSAY Transform(_ntVlMdtsg,"@E 9,999,999.99")
@ Prow()   , 130 PSAY Transform(_nTotg1,"@E 9,999,999.99")
@ Prow() +1, 000 PSAY __PrtThinLine()

Return


Static Function fTotHrm1()
Local _cTipoCod := Space(01)
_nVlOdont   := 0
_nVlFarma   := 0
_nVlSesmt   := 0
_nVlRecru   := 0
_nVlSindi   := 0
_nVlSerso   := 0
_nVlRpaci   := 0
_nVlMdtsg   := 0

While TMP->(!eof()) .AND. _cCusto == TMP->CT2_CCD
		
  	If TMP->CT1_GRUPOC == '17' // Farmacia
		_nVlFarma += TMP->CT2_VALOR
		_ntVlFarma += TMP->CT2_VALOR

  	Elseif TMP->CT1_GRUPOC == '18' // Sesmet
		_nVlSesmt += TMP->CT2_VALOR
		_ntVlSesmt += TMP->CT2_VALOR

  	Elseif TMP->CT1_GRUPOC == '19' // Recrutametno e Selecao
		_nVlRecru += TMP->CT2_VALOR
		_ntVlRecru += TMP->CT2_VALOR

  	Elseif TMP->CT1_GRUPOC == '20' // Sindicato
		_nVlSindi += TMP->CT2_VALOR
		_ntVlSindi += TMP->CT2_VALOR

  	Elseif TMP->CT1_GRUPOC == '21' // Servico social
		_nVlSerso += TMP->CT2_VALOR
		_ntVlSerso += TMP->CT2_VALOR

  	Elseif TMP->CT1_GRUPOC == '22' // Rpa Audiometria
		_nVlRpaci += TMP->CT2_VALOR
		_ntVlRpaci += TMP->CT2_VALOR

  	Elseif TMP->CT1_GRUPOC == '23' // Medicina do Trabalho
		_nVlMdtsg += TMP->CT2_VALOR
		_ntVlMdtsg += TMP->CT2_VALOR

    Endif
    
	TMP->(Dbskip())

Enddo

Return
