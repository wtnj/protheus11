/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCOM055  ºAutor  ³Marcos R. Roquitski º Data ³  21/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio Nota Fiscal X Pedido X Financeiro por Conta        ±±
±±º          ³Contabil                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³AP                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhcom055()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,CCOMPAC,CNORMAL,CQUERY")

_aGrupo   := pswret()
_cCodUsr  := _agrupo[1,1]
cString   := "SC7"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir a  ")
cDesc2    := OemToAnsi("Previsao de Desembolso por Fornecedor")
cDesc3    := OemToAnsi("")
tamanho   := "G"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHCOM055"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "PEDIDO DE COMPRA x NOTA FISCAL x CONTAS A PAGAR"
Cabec1    := "Cod.  Nome Fornecedor                   Pedido              Vl.Pedido   Pref. N.Fiscal    Parc Tipo Vcto Real      Baixa                Vlr. Titulo"
Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHCOM055"       //Nome Default do relatorio em Disco
_cPerg    := "NHCOM055"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)

//Mv_par01 :=	Usuario
//Mv_par02 :=	Centro de Custo de   
//Mv_par03 :=	Centro de Custo Ate  
//Mv_par04 :=	Grupo de 
//Mv_par05 :=	Grupo Ate 
//Mv_par06 :=	Data de 
//Mv_par07 :=	Data Ate 
//Mv_par08 :=	Sigla de 
//Mv_par09 :=	Sigla Ate

If !Pergunte(_cPerg,.T.) //ativa os parametros
	Return(nil)
Endif
                                     
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho) 

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

// inicio do processamento do relatório
Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
                  
// verifica se existe dados para o relatorio atraves da validação de dados em um campo qualquer
TMP->(DbGoTop())

If Empty(TMP->C7_NUM)
   MsgBox("Não existem dados para estes parâmetros...verifique!","Atencao","STOP")
   DbSelectArea("TMP")
   DbCloseArea()
   Return
Endif

Processa( {|| RptDet() },"Imprimindo...")

DbSelectArea("TMP")
DbCloseArea()

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


Static Function Gerando()

	If !Empty(Alltrim(mv_par01))

		cQuery := "SELECT C7.C7_NUM,C7.C7_CONTA,C7.C7_FORNECE,C7.C7_LOJA,SUM(C7_TOTAL) AS 'VLPED' FROM " + RetSqlName( 'SC7' ) + " C7 "
		cQuery += "WHERE C7.D_E_L_E_T_ = '' "
		cQuery += "AND C7.C7_CONTA = '" + mv_par01 + "' " 
		cQuery += "GROUP BY C7.C7_NUM,C7.C7_CONTA, C7.C7_FORNECE,C7_LOJA "
		cQuery += "ORDER BY C7.C7_NUM,C7.C7_CONTA, C7.C7_FORNECE,C7_LOJA "
		TCQUERY cQuery NEW ALIAS "TMP"

	Else

		cQuery := "SELECT C7.C7_NUM,C7.C7_CC,C7.C7_FORNECE,C7.C7_LOJA,SUM(C7_TOTAL) AS 'VLPED' FROM " + RetSqlName( 'SC7' ) + " C7 "
		cQuery += "WHERE C7.D_E_L_E_T_ = '' "
		cQuery += "AND C7.C7_CC BETWEEN '"+ Mv_par05 + "' AND '"+ Mv_par06 + "' "
		cQuery += "GROUP BY C7.C7_NUM,C7.C7_CC, C7.C7_FORNECE,C7_LOJA "
		cQuery += "ORDER BY C7.C7_NUM,C7.C7_CC, C7.C7_FORNECE,C7_LOJA "
		TCQUERY cQuery NEW ALIAS "TMP"

	Endif	

Return




Static Function RptDet()
Local _cNome := Space(20), n := 0, _nVlSe2 := 0, _aNota := {}, _nPosDoc := 0
Local _nVlse2p := _nVlse2b := _n := 0, _aNfDiver := {}
Local _nTotPed := _nTot2p := _nTot2b := _nTote2 := 0
// imprime cabeçalho
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
       
// calcula as datas finais para cada semana
SE2->(DbSetOrder(1))
SD1->(DbSetOrder(13))
                       
DbSelectArea("TMP")
TMP->(DbGotop())
While !TMP->(Eof())

	If Prow() > 60
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo) 
	Endif 
	_cNome := Space(20) 
	SA2->(DbSeek(xFilial("SA2")+ TMP->C7_FORNECE+TMP->C7_LOJA) )
	If SA2->(Found())
		_cNome := SA2->A2_NREDUZ
	Endif
	@ Prow() +1, 001 Psay TMP->C7_FORNECE+" "+TMP->C7_LOJA
	@ Prow()   , 012 Psay _cNome
	@ Prow()   , 040 Psay TMP->C7_NUM
	@ Prow()   , 055 Psay TMP->VLPED Picture "@E 999,999,999.99"
	_nTotPed += TMP->VLPED

    n := 0
	SD1->(DbSeek(xFilial("SD1")+ TMP->C7_NUM) )
	While !SD1->(Eof()) .And. SD1->D1_PEDIDO == TMP->C7_NUM

	  If Alltrim(SD1->D1_CONTA) == Alltrim(TMP->C7_CONTA)
		
		_cD1Doc := SD1->D1_SERIE + SD1->D1_DOC
		_nPosDoc := Ascan(_aNota,{ |x| x[1] == _cD1Doc})	
					
		If _nPosDoc <= 0
			_cChave := _cD1Doc
			SE2->(DbSeek(xFilial("SE2")+ _cChave) )
			While !SE2->(Eof()) .And. SE2->E2_PREFIXO + SE2->E2_NUM == _cD1Doc

				If SE2->E2_FORNECE + SE2->E2_LOJA == SD1->D1_FORNECE + SD1->D1_LOJA .AND. Alltrim(SE2->E2_TIPO) == 'NF

					If (SE2->E2_VENCREA >= mv_par02 .AND. SE2->E2_VENCREA <= mv_par03) 
					
						If Prow() > 60
							_nPag := _nPag + 1
							Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)
						Endif
					
						@ Prow() +n, 073 Psay SE2->E2_PREFIXO
						@ Prow()   , 077 Psay SE2->E2_NUM					
						@ Prow()   , 090 Psay SE2->E2_PARCELA
						@ Prow()   , 095 Psay SE2->E2_TIPO
						@ Prow()   , 100 Psay SE2->E2_VENCREA        
						@ Prow()   , 115 Psay SE2->E2_BAIXA
						@ Prow()   , 130 Psay SE2->E2_VALOR	PICTURE "@E 999,999,999.99"
						_nVlSe2 += SE2->E2_VALOR
						_nTote2 += SE2->E2_VALOR
					
						If SE2->E2_SALDO == 0
							_nVlSe2b += SE2->E2_VALOR
							_nTot2b += SE2->E2_VALOR
						Else	
							_nVlSe2p += SE2->E2_VALOR										
							_nTot2p += SE2->E2_VALOR										
						Endif	
						n := 1

				  		cQuery := "SELECT * FROM "+RetSqlName("SD1")
				  		cQuery += " WHERE D1_DOC = '"+SE2->E2_NUM+"'"
				  		cQuery += " AND D1_SERIE = '"+SE2->E2_PREFIXO+"'"
				  		cQuery += " AND D1_FORNECE = '"+SE2->E2_FORNECE+"'"
				  		cQuery += " AND D1_LOJA = '"+SE2->E2_LOJA+"'"
				  		cQuery += " AND D1_FILIAL = '"+XFILIAL("SD1")+"' AND D_E_L_E_T_ = ''" 
				  		TCQUERY cQuery NEW ALIAS "TM2"
  		     
						DbSelectArea("TM2")
				  		TM2->(DbGotop())
						While !TM2->(Eof())
							If TM2->D1_PEDIDO <> TMP->C7_NUM
								_nPosDoc := Ascan(_aNfDiver,{ |x| x[1] == SE2->E2_NUM+ ' Pc: ' + TM2->D1_PEDIDO})	
								If _nPosDoc == 0
									Aadd(_aNfDiver,{SE2->E2_NUM+ ' Pc: ' + TM2->D1_PEDIDO})
								Endif	
							Endif
							TM2->(DbSkip())
						Enddo
			  			TM2->(DbCloseArea())

		  			Endif

				Endif	
				SE2->(DbSkip())				
			Enddo
			Aadd(_aNota,{_cD1Doc})			
        Endif
	 Endif	          
	 SD1->(DbSkip())
		
	Enddo
	
	_aNota := {}
	If _nVlse2 > 0
		@ Prow() + 2, 100 Psay 'Total titulos'
		@ Prow()    , 130 Psay _nVlSe2  PICTURE "@E 999,999,999.99"
		@ Prow() + 1, 100 Psay '      Baixados'
		@ Prow()    , 130 Psay _nVlSe2b PICTURE "@E 999,999,999.99"
		@ Prow() + 1, 100 Psay '      Pendentes'	
		@ Prow()    , 130 Psay _nVlSe2p PICTURE "@E 999,999,999.99"
	Endif	
	@ Prow() + 1, 001 Psay __PrtThinLine() 	
	_nVlse2p := _nVlse2b := _nVlSe2 := 0

	TMP->(DbSkip())

Enddo 
@ Prow() + 2, 001 Psay __PrtThinLine() 
@ Prow() + 1, 010 Psay 'Total Geral:'

@ Prow() + 2 ,010 Psay 'Total de pedidos  :'+Transform(_nTotPed,"@E 999,999,999.99")
@ Prow() + 1 ,010 Psay 'Total titulos     :'+Transform(_nTote2,"@E 999,999,999.99")
@ Prow() + 1, 010 Psay 'Total Baixados    :'+Transform(_nTot2b,"@E 999,999,999.99")
@ Prow() + 1, 010 Psay 'Total Pendentes   :'+Transform(_nTot2p,"@E 999,999,999.99")
@ Prow() + 2, 010 Psay 'Notas Divergentes :'
_n := 35
For i := 1 to Len(_aNfDiver)
	@ Prow() ,_n Psay _aNfDiver[i,1]
	_n += 22

	If _n >= 200
		@ Prow() + 1 ,025 Psay '=>'
		_n := 35
	Endif	
Next
@ Prow() + 1, 001 Psay __PrtThinLine() 

If Prow() > 60 
	_nPag := _nPag + 1 
	Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo) 
Endif 
      
Return(nil) 