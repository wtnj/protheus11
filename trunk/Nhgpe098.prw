/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE098  �Autor  �Marcos R Roquitski  � Data �  19/11/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Relatorio 13. Salario. 2. Parcela.                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"  
#include "topconn.ch"

User Function Nhgpe098()   

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
titulo    := "13o. Salario"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "SRC"
nTipo     := 0
nomeprog  := "NHGPE098"
cPerg     := "GPE074"
nPag      := 1
M_PAG     := 1 
tot01     := 0 
tot02     := 0 
tot03     := 0 
tot04     := 0 

If !Pergunte(cPerg,.T.) //ativa os parametros
	Return(nil)
Endif


//��������������������������������������������������������������Ŀ
//� Parametros:                                                  �
//� mv_par01     Matr. de                                        �
//� mv_par02     Matr. Ate                                       �
//� mv_par03     13o. Salario                                    �
//����������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:= "NHGPE098"

SetPrint("ZRF",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

rptStatus({||Gerando()},"Gerando Base para o Relatorio...")

If Empty(TMP->ZRF_MAT)
   MsgBox("Nenhum Ocorrencia ","Aten�ao","ALERT")  
   DbSelectArea("TMP")
   DbCloseArea("TMP")
   Return
Endif

rptStatus({||Imprime()},"Imprimindo...")

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
DbSelectArea("TMP")
DbCloseArea("TMP")
MS_FLUSH() //Libera fila de relatorios em spool

Return


Static Function Gerando()

cQuery := "SELECT * " 
cQuery += "FROM " + RetSqlName( 'ZRF' ) + " ZRF " 
cQuery += "WHERE ZRF.D_E_L_E_T_ = ' ' " 
cQuery += "AND ZRF.ZRF_MAT BETWEEN '"+ Mv_par01 + "' AND '"+ Mv_par02 + "' "
cQuery += "ORDER BY 2,3		 "
TCQUERY cQuery NEW ALIAS "TMP" 
TcSetField("TMP","ZRF_DATA","D") // Muda a data de string para date.


DbSelectArea("TMP")
Return


Static Function Imprime()
Local _nTotPro := _nTotDes := _nTotLiq := 0,_cZrc_Mat := Space(06) 
Local _nTogPro := _nTogDes := _nTogLiq := 0
TMP->(Dbgotop())

Titulo := Titulo + " 2a. Parcela   Periodo: "+Alltrim(+Str(Year(ZRF->ZRF_DATA)))
	
Cabec1    := ""
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

While !TMP->(eof())
	If Prow() > 56
		nPag := nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif
	DbSelectArea("ZRA")
	ZRA->(DbSeek(xFilial("ZRA") +TMP->ZRF_MAT))
	If ZRA->(Found())
		If !Empty(Alltrim(ZRA->ZRA_SITFOLH))
			TMP->(DbSkip())
			Loop
		Endif	
		@ Prow() + 1, 000 Psay "C.CUSTO  : " + ZRF->ZRF_CC+SPACE(05)+"MATR.:"+TMP->ZRF_MAT+SPACE(05)+"NOME: "+ZRA->ZRA_NOME+SPACE(05)+"ADMISSAO: "+DTOC(ZRA->ZRA_INICIO)
		@ Prow() + 1, 000 Psay "P R O V E N T O S"
		@ Prow()    , 045 Psay "D E S C O N T O S"
		@ Prow() + 1,000 Psay __PrtThinLine()
	Endif
    _cZrc_Mat  := TMP->ZRF_MAT


	While !TMP->(Eof()) .AND. TMP->ZRF_MAT == _cZrc_Mat
		If Prow() > 56
			nPag := nPag + 1
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
		Endif
		ZRV->(DbSeek(xFilial("ZRV") + TMP->ZRF_PD))
		If ZRV->(Found())
			If ZRV->ZRV_TIPOCO == "1" .AND. TMP->ZRF_PD <> "799"
				@ Prow() + 1, 000 Psay TMP->ZRF_PD
				@ Prow()    , 005 Psay TMP->ZRF_DESCPD
				@ Prow()    , 030 Psay TMP->ZRF_VALOR  Picture "@E 9,999,999.99"
				_nTotpro += TMP->ZRF_VALOR
				_nTogpro += TMP->ZRF_VALOR
			Elseif ZRV->ZRV_TIPOCO == "2" .AND. TMP->ZRF_PD <> "799"
				@ Prow() + 1, 045 Psay TMP->ZRF_PD
				@ Prow()    , 050 Psay TMP->ZRF_DESCPD
				@ Prow()    , 080 Psay TMP->ZRF_VALOR  Picture "@E 9,999,999.99"
				_nTotdes += TMP->ZRF_VALOR
				_nTogdes += TMP->ZRF_VALOR
			Endif
		Endif				
		If TMP->ZRF_PD == "799"
			_nTotLiq += TMP->ZRF_VALOR
			_nTogLiq += TMP->ZRF_VALOR
		Endif
		TMP->(DbSkip())
	Enddo
    @ Prow() + 1,000 Psay __PrtThinLine()
    @ Prow() + 1,001 Psay "T O T A L: "
	@ Prow()    ,030 Psay _nTotPro Picture "@E 9,999,999.99"
	@ Prow()    ,080 Psay _nTotDes Picture "@E 9,999,999.99"
	@ Prow()    ,100 PSAY "Liquido: "+TRANSFORM(_nTotLiq,"@E 9,999,999.99")
	_nTotPro := _nTotDes := _nTotLiq := 0
	@ Prow() + 1,000 Psay __PrtThinLine()
	@ Prow() + 2,000 Psay ""
Enddo
@ Prow() + 1,001 Psay "TOTAL GERAL:"
@ Prow()    ,030 Psay _nTogPro Picture "@E 9,999,999.99"
@ Prow()    ,080 Psay _nTogDes Picture "@E 9,999,999.99"
@ Prow()    ,100 PSAY "Liquido: "+TRANSFORM(_nTogLiq,"@E 9,999,999.99")
@ Prow() + 1,000 Psay __PrtThinLine()

Return
