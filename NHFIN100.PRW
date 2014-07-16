/*
+--------------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                              !
+--------------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                            !
+------------------+-------------------------------------------------------------+
!Modulo            ! FIN - Financeiroo                                           !
+------------------+-------------------------------------------------------------+
!Nome              ! NHFIN100.PRW                                                !
+------------------+-------------------------------------------------------------+
!Descricao         ! Prorrogação de Vencimento de Titulos                        !
+------------------+-------------------------------------------------------------+
!Autor             ! Edenilson Santos                                            !
+------------------+-------------------------------------------------------------+
!Data de Criacao   ! 16/05/2014                                                  !
+------------------+-------------------------------------------------------------!
!   ATUALIZACOES                                                                 !
+-------------------------------------------+-----------+------------+-----------+
!   Descricao detalhada da atualizacao      !Nome do    ! Analista   !Data da    !
!                                           !Solicitante! Responsavel!Atualizacao!
+-------------------------------------------+-----------+------------+-----------+
!                                           !           !            !           !
+-------------------------------------------+-----------+------------+-----------+
*/
#include "rwmake.ch"
#include "topconn.ch"

User Function NHFIN100()
SetPrvt("_cArqDbf, cQuery,_aFields,aCampos,cMarca,cNovaLinha,cARQEXP ,cARQ,i,_DataPagto")
oFont1      := TFont():New("Arial"        ,,18,,.t.,,,,,.f.)
oFont2      := TFont():New("Arial"        ,,23,,.t.,,,,,.f.)
oFont3      := TFont():New('Arial'        ,,12,,.t.,,,,,.f.)
oFont4      := TFont():New("Ms Sans Serif",,14,,.t.,,,,,.f.)
oFont5      := TFont():New("Ms Sans Serif",,14,,.t.,,,,,.f.)
_cArqDBF    := Space(12)
_DataPagto  := Ctod('  /  /    ')
Private nRec

/*
+----------------------------------------------------------+
! Variaveis utilizadas para parametros                     !
! mv_par01            // do borderô                        !
! mv_par02            // até borderô                       !
! mv_par03            // da fatura                         !
! mv_par04            // até fatura                        !
! mv_par05            // do Vencimento                     !
! mv_par06            // ate o Vencimento                  !
+----------------------------------------------------------+
*/

AjustaSx1("NHFIN100")

If Pergunte('NHFIN100',.T.)
	
	Processa({|| MontaQuery() }, "Aguarde, Reunindo informações...")
	
	If nRec > 0
		Processa( {|| ShowQuery() }, "Aguarde, gerando arquivo temporário...")    //****** E AQUI
	Else
		MsgBox("Não há registro selecionados !","Atencao","INFO")
	Endif
	
	If File( _cArqDBF )
		fErase(_cArqDBF)  // Deleta arquivo de dados temporario
	Endif
	
	if Select("QRY") > 0
		DbSelectArea("QRY")
		DbCloseArea()
	Endif
	
	if Select("TMP") > 0
		DbSelectArea("TMP")
		DbCloseArea()
	Endif
Endif

Return

*--------------------------*
Static Function MontaQuery()
*--------------------------*
cSql1:= ''

If !Empty(mv_par01)
	If mv_par01 == 1
		cSql1 += "E2.E2_NUMBOR BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "' AND "
	Elseif mv_par01 == 2
		cSql1 += "E2.E2_FATURA BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "' AND "
	Endif
Endif

cSql1 := "%"+cSql1+"%"

If Select("QRY") > 0
	dbSelectArea("QRY")
	dbCloseArea()
Endif

BeginSql Alias "QRY"
	SELECT E2.E2_NUMBOR, E2.E2_FATURA, E2.E2_PREFIXO, E2.E2_NUM, E2.E2_PARCELA, E2.E2_TIPO,E2.E2_PORTADO, E2.E2_FORNECE,
	E2.E2_LOJA, E2.E2_NOMFOR, E2.E2_EMISSAO, E2.E2_VENCTO, E2.E2_VENCREA, E2.E2_VALOR,E2.E2_SALDO
	FROM
	%Table:SE2% E2 (NOLOCK)
	WHERE
	%exp:cSql1%
	E2.E2_SALDO > 0 AND
	E2.%NotDel%
	order by
	E2.E2_NUMBOR
EndSql

Count To nRec

Return

*-------------------------*
Static Function ShowQuery()
*-------------------------*

If Select("TMP")>0
	TMP->(dbCloseArea())
EndIf

_cArqDBF := CriaTrab(NIL,.f.)
_cArqDBF += ".DBF"
_aFields := {}
Private _SumTotal := 0
Private _SumSaldo := 0

AADD(_aFields,{"OK"      , "C",02,00})
AADD(_aFields,{"BORDERO" , "C",06,00})
AADD(_aFields,{"FATURA"  , "C",09,00})
AADD(_aFields,{"PREFIXO" , "C",03,00})
AADD(_aFields,{"NUMTIT"  , "C",09,00})
AADD(_aFields,{"PARCELA" , "C",01,00})
AADD(_aFields,{"TIPO"    , "C",03,00})
AADD(_aFields,{"PORTADOR", "C",03,00})
AADD(_aFields,{"FORNEC"  , "C",06,00})
AADD(_aFields,{"LOJA"    , "C",02,00})
AADD(_aFields,{"NOMFOR"  , "C",20,00})
AADD(_aFields,{"EMISSAO" , "C",10,00})
AADD(_aFields,{"VENCTO"  , "C",10,00})
AADD(_aFields,{"VENCREA" , "C",10,00})
AADD(_aFields,{"VALOR"   , "N",14,02})
AADD(_aFields,{"SALDO"   , "N",14,02})

DbCreate(_cArqDBF,_aFields)
DbUseArea(.T.,,_cArqDBF,"TMP",.F.)

QRY->(DBGotop())
ProcRegua(nRec)

While !QRY->(EOF())
	
	IncProc("Processando informações...["+Strzero(QRY->(RecNo()),4,0)+"/"+Strzero(nRec,4,0)+"]")
	
	RecLock("TMP",.T.)
	TMP->OK        := Space(02)
	TMP->BORDERO   := QRY->E2_NUMBOR
	TMP->PREFIXO   := QRY->E2_PREFIXO
	TMP->NUMTIT    := QRY->E2_NUM
	TMP->PARCELA   := QRY->E2_PARCELA
	TMP->TIPO      := QRY->E2_TIPO
	TMP->PORTADOR  := QRY->E2_PORTADO
	TMP->FORNEC    := QRY->E2_FORNECE
	TMP->LOJA      := QRY->E2_LOJA
	TMP->NOMFOR    := QRY->E2_NOMFOR
	TMP->EMISSAO   := Subs(QRY->E2_EMISSAO,7,2)+"/"+Subs(QRY->E2_EMISSAO,5,2)+"/"+Subs(QRY->E2_EMISSAO,1,4)
	TMP->VENCTO    := Subs(QRY->E2_VENCTO,7,2) +"/"+Subs(QRY->E2_VENCTO,5,2) +"/"+Subs(QRY->E2_VENCTO,1,4)
	TMP->VENCREA   := Subs(QRY->E2_VENCREA,7,2)+"/"+Subs(QRY->E2_VENCREA,5,2)+"/"+Subs(QRY->E2_VENCREA,1,4)
	TMP->VALOR     := QRY->E2_VALOR
	TMP->SALDO     := QRY->E2_SALDO
	
	_SumTotal      += QRY->E2_VALOR
	_SumSaldo      += QRY->E2_SALDO
	MsUnlock("TMP")
	
	QRY->(DbSkip())
	
EndDo

cMarca  := GetMark()
aCampos := {}

Aadd(aCampos,{"OK"      ,"OK"              , "@!"})
Aadd(aCampos,{"BORDERO" ,"Borderô"         , "@!"})
Aadd(aCampos,{"FATURA"  ,"Fatura"          , "@!"})
Aadd(aCampos,{"PREFIXO" ,"Prefixo"         , "@!"})
Aadd(aCampos,{"NUMTIT"  ,"No. Titulo"      , "@!"})
Aadd(aCampos,{"PARCELA" ,"Parcela"         , "@!"})
Aadd(aCampos,{"PORTADOR","Portador"        , "@!"})
Aadd(aCampos,{"FORNEC"  ,"Fornecedor"      , "@!"})
Aadd(aCampos,{"LOJA"    ,"Loja"            , "@!"})
Aadd(aCampos,{"NOMFOR"  ,"Nome Fornecedor" , "@!"})
Aadd(aCampos,{"EMISSAO" ,"DT Emissão"      , "@D"})
Aadd(aCampos,{"VENCTO"  ,"Vencimento"      , "@D"})
Aadd(aCampos,{"VENCREA" ,"Vencto Real"     , "@D"})
Aadd(aCampos,{"VALOR"   ,"Vlr. Titulo"     , "@e 999,999,999.99"})
Aadd(aCampos,{"SALDO"   ,"Saldo"           , "@E 999,999,999.99"})

TMP->(DbGoTop())

@ 050,001 to 0700,1500 dialog oDlg title 'Prorrogação de Vencimento(s)'
@ 006,005 to 300,750 browse "TMP"
@ 006,005 to 300,750 browse "TMP" FIELDS aCampos mark "OK"

oGroup := tGroup():New(300,005,323,120," Resumo do Borderô",oDlg,,,.T.)

oSay01 := TSay():New(307,010,{||"Total Borderô: "},oDlg,                   ,oFont4,,,,.T.,,)
oSay02 := TSay():New(307,070,{||_SumTotal}        ,oDlg,"@E 999,999,999.99",oFont5,,,,.T.,,)
oSay03 := TSay():New(314,010,{||"Saldo Borderô: "},oDlg,                   ,oFont4,,,,.T.,,)
oSay04 := TSay():New(314,070,{||_SumSaldo}        ,oDlg,"@E 999,999,999.99",oFont5,,,,.T.,,)

oSay05 := TSay():New(314,125,{||"Data Pagamento: "},oDlg,,,,,,.T.,,)
@ 313,170 Get _DataPagto Picture "99/99/9999" When .T. Size 45,08 Object oDataPagto

//@ 305,300 button "Marcar"     size 40,15 action _Check()
//@ 305,400 button "Desmarcar"  size 40,15 action _Uncheck()

@ 305,655 button "_Confirmar" size 40,15 action Processa({|| AlteraVencrea() }, "Aguarde, processando informações...")
@ 305,700 button "C_ancelar"  size 40,15 action oDlg:End()

activate dialog oDlg centered

Return

*----------------------------------*
Static Function VerificaData(xParam)
*----------------------------------*
If Empty(xParam)
	MsgBox("Não foi informada a data de pagamento desejada, Favor verificar !","Atencao","INFO")
	Return(.F.)
Endif
Return(.T.)

*-----------------------------*
Static Function AlteraVencrea()
*-----------------------------*
If VerificaData(_DataPagto)
	ProcRegua(TMP->(LastRec()))
	TMP->(DbGoTop())
	while !TMP->(Eof())
		If MARKED("OK")
			IncProc("Aguarde, atualizando...["+Strzero(TMP->(RecNo()),4,0)+"/"+Strzero(TMP->(LastRec()),4,0)+"]")
			SE2->(DbSeek(xFilial("SE2")+TMP->PREFIXO+TMP->NUMTIT+TMP->PARCELA+TMP->TIPO+TMP->FORNEC+TMP->LOJA))
			If SE2->(Found())
				RecLock("SE2",.F.)
				SE2->E2_VENCREA := _DataPagto
				MsUnLock("SE2")
			Endif
		Endif
		TMP->(DbSkip())
	Enddo
	
	Processa({|| MontaQuery() }, "Aguarde, reunindo informações...")
	
	Processa({|| UpdateShowQuery() }, "Aguarde, atualizando informações...")
	
	MsgBox("Atualização concluída com sucesso.","Atencao","INFO")
	
	
Endif

Return

*-------------------------------*
Static Function UpdateShowQuery()
*-------------------------------*
DbSelectArea("TMP")
Zap

_SumTotal:= 0
_SumSaldo:= 0

QRY->(DBGotop())

While !QRY->(EOF())
	
	RecLock("TMP",.T.)
	TMP->OK        := Space(02)
	TMP->BORDERO   := QRY->E2_NUMBOR
	TMP->PREFIXO   := QRY->E2_PREFIXO
	TMP->NUMTIT    := QRY->E2_NUM
	TMP->PARCELA   := QRY->E2_PARCELA
	TMP->TIPO      := QRY->E2_TIPO
	TMP->PORTADOR  := QRY->E2_PORTADO
	TMP->FORNEC    := QRY->E2_FORNECE
	TMP->LOJA      := QRY->E2_LOJA
	TMP->NOMFOR    := QRY->E2_NOMFOR
	TMP->EMISSAO   := Subs(QRY->E2_EMISSAO,7,2)+"/"+Subs(QRY->E2_EMISSAO,5,2)+"/"+Subs(QRY->E2_EMISSAO,1,4)
	TMP->VENCTO    := Subs(QRY->E2_VENCTO,7,2) +"/"+Subs(QRY->E2_VENCTO,5,2) +"/"+Subs(QRY->E2_VENCTO,1,4)
	TMP->VENCREA   := Subs(QRY->E2_VENCREA,7,2)+"/"+Subs(QRY->E2_VENCREA,5,2)+"/"+Subs(QRY->E2_VENCREA,1,4)
	TMP->VALOR     := QRY->E2_VALOR
	TMP->SALDO     := QRY->E2_SALDO
	
	_SumTotal      += QRY->E2_VALOR
	_SumSaldo      += QRY->E2_SALDO
	MsUnlock("TMP")
	
	QRY->(DbSkip())
	
EndDo

Return

*------------------------------*
Static Function AjustaSX1(cPerg)
*------------------------------*
SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

cPerg   :=PadR(cPerg,10)

aRegs   := {}

//              G   O          P                     P                     P                      V   T   T D P  G   V         V   D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  F  G
//              R   R          E                     E                     E                      A   I   A E R  S   A         A   E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  3  R
//              U   D          R                     R                     R                      R   P   M C E  C   L         R   F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  |  P
//              P   E          G                     S                     E                      I   O   A I S  |   I         0   0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  |  S
//              O   M          U                     P                     N                      A   |   N M E  |   D         1   1  P  N  1  2  2  P  N  2  3  3  P  N  3  4  4  P  N  4  5  5  P  N  5  |  X
//              |   |          N                     A                     G                      V   |   H A L  |   |         |   |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  G
//              |   |          T                     |                     |                      E   |   O L |  |   |         |   |  1  1  |  |  |  2  2  |  |  |  3  3  |  |  |  4  4  |  |  |  5  5  |  |  |
//              |   |          |                     |                     |                      |   |   | | |  |   |         |   |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
//aadd(aRegs,{cPerg,"01","Tipo Documento ?   ","Tipo Documento ?   ","Tipo Documento ?   ","mv_ch1","N",01,0,4,"C","","mv_par01","Bordero","Bordero","Bordero","","","Fatura","Fatura","Fatura","","","Titulo Aberto","Titulo Aberto","Titulo Aberto","","","Todas","Todas","Todas","","","","","","","",""})
aadd(aRegs,{cPerg,"01","Tipo Documento ?   ","Tipo Documento ?   ","Tipo Documento ?   ","mv_ch1","N",01,0,4,"C","","mv_par01","Bordero","Bordero","Bordero","","","Fatura","Fatura","Fatura","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Documento Inicial ?","Documento Inicial ?","Documento Inicial ?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","Documento Final ?  ","Documento Final ?  ","Documento Fianl ?  ","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
cUltPerg := aRegs[Len(aRegs)][2]

dbSelectArea("SX1")
dbSetOrder(1)
If !SX1->(DbSeek(cPerg + cUltPerg))
	
	SX1->(DbSeek(cPerg))
	While SX1->X1_Grupo == cPerg
		RecLock('SX1')
		SX1->(DbDelete())
		SX1->(DbSkip())
		MsUnLock('SX1')
	End
	
	For i := 1 To Len(aRegs)
		RecLock("SX1", .T.)
		
		For j := 1 to Len(aRegs[i])
			FieldPut(j, aRegs[i, j])
		Next
		MsUnlock()
		
		DbCommit()
	Next
EndIf

dbSelectArea(_sAlias)

return
