/*
+----------------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                                !
+----------------------------------------------------------------------------------+
!                             DADOS DO PROGRAMA                                    !
+------------------+---------------------------------------------------------------+
!Modulo            ! FIN - Financeiro                                              !
+------------------+---------------------------------------------------------------+
!Nome              ! NHFIN048.PRW                                                  !
+------------------+---------------------------------------------------------------+
!Descricao         ! Resumo de Borderos                                            +
+------------------+---------------------------------------------------------------+
!Autor             ! Fabio Nico                                                    !
+------------------+---------------------------------------------------------------+
!Data de Criacao   ! 06/06/2005                                                    !
+------------------+---------------------------------------------------------------+
!ATUALIZACOES                                                                      !
+-------------------------------------------+---------------+-----------+----------+
!Descricao detalhada da atualizacao         !Nome do        ! Analista  !Data da   !
!                                           !Solicitante    ! Respons.  !Atualiz.  !
+-------------------------------------------+---------------+-----------+----------+
!Implementado funções para geração do relato!               !           !          !
!rio atendendo o parametro MV_TREPORT       ! Paulo/Gustavo !Edenilson  !04/12/2013!
+-------------------------------------------+---------------+-----------+----------+
*/
#include "rwmake.ch"      
#include "topconn.ch"

User Function NhFIN048() 
SetPrvt("_cCodUsr") 
_cPerg    := "FIN048"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX1)

dbSelectArea("SX1")
dbSetOrder(1)
SX1->(DbSeek(_cPerg))
If Sx1->(Found())
	RecLock('SX1')
	SX1->X1_CNT01 := _cCodUsr
	MsUnLock('SX1')
Endif

If !Pergunte(_cPerg,.T.) //ativa os parametros
	Return(nil)
Endif

If FindFunction("TRepInUse") .And. TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Processa( {|| Gerando()   },"Gerando Dados para a Impressao")	
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	U_NHFINR048()
EndIf

User Function NHFINR048()
SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave,nTipo,aReturn")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1,_nTotAberto,nTotAtende,_nSubAberto,_nSubAtende")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,_nSemana, _aPed,_axPed,_n,_nSaldo,_anPed,_azPed,_c7NumPro")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,nSubTot,nTotGer,nTotCC,nConta,dData1,dData2,dData3,dData4,dData5,dData6,cCentroC")
SetPrvt("_aGrupo,_cApelido,_cCodUsr,_lPri,_nTotItem,_nTotcIpi,nSubIpi,nTotIpi,_nTotPe,_nIpi,_c7Num,_z")

Private c_DirDocs    := GetTempPath()//Caminho da pasta temporaria do Cliente.
Private c_Extensao   := ".XLS"//A extensão também pode ser declarada como ".XLS"
Private c_Arquivo    := CriaTrab(,.F.)//Cria um nome aleatório para o arquivo

cString   := "SC7"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir O ")
cDesc2    := OemToAnsi("Resumo dos Borderos Enviados para o Banco")
cDesc3    := OemToAnsi("")
tamanho   := "M"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
//nControle := 15
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHFIN048"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "RESUMO DOS BORDEROS "
Cabec1    := "Numero  Parcela  Tipo  Fornecedor             Vencimento     Valor    Bordero   Modelo"
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13
Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHFIN048"       //Nome Default do relatorio em Disco
aMatriz   := {}
_aPed     := {}
_axPed    := {}
_nTotPe   := 0
_nIpi     := 0
_anPed    := {}
_azPed    := {}	
                                    
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho) 

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo  := iif(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))
aDriver:= ReadDriver()
cCompac:= aDriver[1]
cNormal:= aDriver[2]

// inicio do processamento do relatório
Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
                  
// verifica se existe dados para o relatorio atraves da validação de dados em um campo qualquer

TMP->(DbGoTop())
If Empty(TMP->E2_NUM)
   MsgBox("Não existem dados para estes parâmetros...verifique!","Atencao","STOP")
   DbSelectArea("TMP")
   DbCloseArea()
   Return
Endif

//inicio da impressao
Processa( {|| RptDet1() },"Imprimindo...")
     
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
//**********************************
	cQuery := "SELECT SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO, SE2.E2_FORNECE, SE2.E2_NOMFOR, SED.ED_DESCRIC, "
   cQuery += "SE2.E2_VENCREA, SE2.E2_SALDO, SE2.E2_BAIXA, SE2.E2_CODBAR, SE2.E2_NUMBOR, SE2.E2_NATUREZ,"
   cQuery += "SEA.EA_MODELO, SX5.X5_DESCRI, SA2.A2_NOME "
	cQuery += "FROM " + RetSqlName('SE2') + " SE2, "  + RetSqlName('SEA') + " SEA, " + RetSqlName('SX5') + " SX5, "+ RetSqlName('SED') + " SED , "+ RetSqlName('SA2') + " SA2 "
	cQuery += "WHERE SED.ED_CODIGO = SE2.E2_NATUREZ "
   cQuery += "AND SE2.E2_FILIAL BETWEEN '"+ Mv_par07 + "' AND '"+ Mv_par08 + "' "	
	cQuery += "AND SED.D_E_L_E_T_ = ' ' "
   cQuery += "AND SX5.X5_CHAVE   =  SEA.EA_MODELO "
   cQuery += "AND SX5.X5_TABELA  = '58' "
   cQuery += "AND SX5.D_E_L_E_T_ = ' ' "
	cQuery += "AND SEA.EA_FILIAL  = SE2.E2_FILIAL "
	cQuery += "AND SX5.X5_FILIAL  = SA2.A2_FILIAL "
	cQuery += "AND SEA.EA_NUM     = SE2.E2_NUM "
	cQuery += "AND SEA.EA_TIPO    = SE2.E2_TIPO "    
	cQuery += "AND SEA.EA_PREFIXO = SE2.E2_PREFIXO " 
   cQuery += "AND SEA.EA_PARCELA = SE2.E2_PARCELA " 
	cQuery += "AND SEA.EA_FORNECE = SE2.E2_FORNECE "
   cQuery += "AND SEA.EA_LOJA = SE2.E2_LOJA "
   cQuery += "AND SEA.EA_MODELO BETWEEN '"+ Mv_par05 + "' AND '"+ Mv_par06 + "' "	
	cQuery += "AND SEA.D_E_L_E_T_ = ' ' "
	cQuery += "AND SE2.E2_FORNECE = SA2.A2_COD "
	cQuery += "AND SE2.E2_LOJA = SA2.A2_LOJA "
	cQuery += "AND SA2.D_E_L_E_T_ = ' ' "    
	cQuery += "AND SED.D_E_L_E_T_ = ' ' "    	
	cQuery += "AND SE2.E2_VENCREA BETWEEN '"+ Dtos(Mv_par03) + "' AND '"+ Dtos(Mv_par04) + "' "
	cQuery += "AND SE2.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY 11,1,4 desc"  
	
   MemoWrit('C:\TEMP\NHFIN048.SQL',cQuery)
   TCQUERY cQuery NEW ALIAS "TMP"                      
   DbSelectArea("TMP")

Return

Static Function RptDet1()
               
@ 00, 00 pSay Chr(15)      
// imprime cabeçalho
Cabec2    := "Periodo de : " + dtoc(Mv_par03) + " ate " + dtoc(Mv_par04) + "  Banco de : " + mv_par01 + " ate " + mv_par02
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
       
// inicializa totalizadores
aux_total := 0
aux_totbor   := 0   // total por grupo de bordero
   
DbSelectArea("TMP") 
dbgotop()
                                              
If Prow() > 66
   _nPag := _nPag + 1
   Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
Endif                     
   
aux_bordero := TMP->E2_NUMBOR

While !eof()
		
	If Prow() > 56
	   _nPag := _nPag + 1
	   Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0) 
	Endif
	if aux_bordero = TMP->E2_NUMBOR
	   @ Prow() +1, 001 Psay TMP->E2_NUM

	   @ Prow()   , 011 Psay TMP->E2_PARCELA
	   @ Prow()   , 014 Psay TMP->E2_TIPO

	   @ Prow()   , 018 Psay TMP->E2_FORNECE
	   @ Prow()   , 025 Psay SUBSTR(TMP->A2_NOME,1,22)

	   @ Prow()   , 049 Psay STOD(TMP->E2_VENCREA)
	   @ Prow()   , 060 Psay TMP->E2_SALDO      picture "@E 999,999.99"
	   @ Prow()   , 071 Psay TMP->E2_NUMBOR
      @ Prow()   , 078 Psay TMP->EA_MODELO
      @ Prow()   , 082 Psay SUBSTR(TMP->X5_DESCRI,1,18)
      @ Prow()   , 102 Psay TMP->ED_DESCRIC       
	
	   aux_totbor := aux_totbor + TMP->E2_SALDO
    else
      @ Prow() +1, 000 PSAY __PrtThinLine()
      @ Prow() +1, 030 Psay "Total do Bordero.:"
      @ Prow()   , 051 Psay aux_totbor       picture "@E 9,999,999.99"
      @ Prow() +1, 000 PSAY __PrtThinLine()
	   aux_totbor:= TMP->E2_SALDO
	   aux_bordero := TMP->E2_NUMBOR
	   
	   @ Prow() +2, 001 Psay TMP->E2_NUM
	   @ Prow()   , 011 Psay TMP->E2_PARCELA
	   @ Prow()   , 014 Psay TMP->E2_TIPO
	   @ Prow()   , 018 Psay TMP->E2_FORNECE
	   @ Prow()   , 025 Psay SUBSTR(TMP->A2_NOME,1,22)
	   @ Prow()   , 048 Psay STOD(TMP->E2_VENCREA)
	   @ Prow()   , 060 Psay TMP->E2_SALDO      picture "@E 999,999.99"
	   @ Prow()   , 071 Psay TMP->E2_NUMBOR
      @ Prow()   , 078 Psay TMP->EA_MODELO	   
      @ Prow()   , 082 Psay SUBSTR(TMP->X5_DESCRI,1,18)
      @ Prow()   , 102 Psay TMP->ED_DESCRIC       
    endif
    aux_total = aux_total + TMP->E2_SALDO
   dbskip()
enddo
@ Prow() +1, 000 PSAY __PrtThinLine()
@ Prow() +1, 030 Psay "Total do Bordero.:"
@ Prow()   , 051 Psay aux_totbor       picture "@E 9,999,999.99"
@ Prow() +1, 000 PSAY __PrtThinLine()
@ Prow() +2, 035 Psay "Total Geral..:"
@ Prow()   , 052 Psay aux_total    picture "@E 9,999,999.99"            

                
If SM0->M0_CODIGO=="NH"
	@ Prow() +5, 002 Psay "________________________________            __________________________________"
	@ Prow() +1, 002 Psay "   Responsável Contas a Pagar                WHB Componentes Automotivos S.A."
else
	@ Prow() +5, 002 Psay "________________________________            __________________________________"
	@ Prow() +1, 002 Psay "   Responsável Contas a Pagar                       WHB Fundição S.A."
Endif

Return
 
static function reportDef()
	local oReport
	Local oSection1
	Local oSection2
	local cTitulo := 'Resumo de Borderôs'

	Processa( {|| Gerando()   },"Gerando Dados para a Impressao")	
 
	oReport := TReport():New('NHFIN048', cTitulo, , {|oReport| PrintReport(oReport)},"Este relatório ira imprimir o resumo de borderôs.")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:ShowHeader()

	/* Itens do Relatórios */ 
	oSection1 := TRSection():New(oReport,"Filial",{"TMP"})
	oSection1:SetTotalInLine(.F.)                                                                              
   
	TRCell():New(oSection1, "E2_NUM"    , "TMP", 'Número'    , PesqPict('TMP',"E2_NUM")          , TamSX3("E2_NUM")[1]+03    , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "E2_PARCELA", "TMP", 'Parcela'   , PesqPict('TMP',"E2_PARCELA")      , TamSX3("E2_PARCELA")[1]+10, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "E2_TIPO"	, "TMP", 'Tipo'      , PesqPict('TMP',"E2_TIPO")         , TamSX3("E2_TIPO")[1]+05   , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "E2_FORNECE", "TMP", 'Código'    , PesqPict('TMP',"E2_FORNECE")      , TamSX3("E2_FORNECE")[1]+02, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "A2_NOME"   , "TMP", 'Fornecedor', PesqPict('TMP',"A2_NOME")         , TamSX3("A2_NOME")[1]+05   , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "E2_VENCREA", "TMP", 'Vencimento', PesqPict('TMP',"E2_VENCREA")      , TamSX3("E2_VENCREA")[1]+10, /*lPixel*/, /*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")
	TRCell():new(oSection1, "E2_SALDO"	, "TMP", 'Valor'     , PesqPict('TMP',"E2_SALDO")        , TamSX3("E2_SALDO")[1]     , /*lPixel*/, /*{|| code-block de impressao }*/,"CENTER",,"CENTER")
	TRCell():new(oSection1, "E2_NUMBOR"	, "TMP", 'Borderô'   , PesqPict('TMP',"E2_NUMBOR")       , TamSX3("E2_NUMBOR")[1]+05 , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "EA_MODELO"	, "TMP", 'Modelo'    , PesqPict('TMP',"EA_MODELO")       , 10                        , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "X5_DESCRI" , "TMP", ''     	   , PesqPict('TMP',"X5_DESCRI")       , 15                        , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "ED_DESCRIC", "TMP", ''	         , PesqPict('TMP',"ED_DESCRIC")      , 40                        , /*lPixel*/, /*{|| code-block de impressao }*/)	

	//oBreak := TRBreak():New(oSection1,oSection1:Cell("E2_FORNECE"),,.F.)

   // QUEBRA
	oBreak := TRBreak():New(oSection1,oSection1:Cell("EA_MODELO"),,.F.)	
 
	//TRFunction():New(oSection1:Cell("E2_FORNECE"),"TOTAL FORNEC","COUNT",oBreak,,"@E 999999",,.F.,.F.)                                                                       e
	TRFunction():New(oSection1:Cell("E2_SALDO"),NIL,"SUM",oBreak)
	TRFunction():New(oSection1:Cell("EA_MODELO"),NIL,"COUNT",oBreak)
 
	//TRFunction():New(oSection1:Cell("E2_SALDO"),"TOTAL GERAL" ,"SUM",,,"@E 999999",,.F.,.T.)	
	//	TRFunction():New(oSection:Cell("E2_SALDO"),NIL,"SUM",oBreak)
 
return (oReport)
 
Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)
	oSection1:Init()
	oSection1:SetHeaderSection(.T.)
 
	DbSelectArea('TMP')
	dbGoTop()
	oReport:SetMeter(TMP->(RecCount()))
	While TMP->(!Eof())

		If oReport:Cancel()
			Exit
		EndIf
 
		oReport:IncMeter()

		oSection1:Cell("E2_NUM"):SetValue(TMP->E2_NUM)
		oSection1:Cell("E2_NUM"):SetAlign("LEFT")
 
		oSection1:Cell("E2_PARCELA"):SetValue(TMP->E2_PARCELA)
		oSection1:Cell("E2_PARCELA"):SetAlign("CENTER")
 
		oSection1:Cell("E2_TIPO"):SetValue(TMP->E2_TIPO)
		oSection1:Cell("E2_TIPO"):SetAlign("LEFT")
 
		oSection1:Cell("E2_FORNECE"):SetValue(TMP->E2_FORNECE)
		oSection1:Cell("E2_FORNECE"):SetAlign("LEFT")
 
		oSection1:Cell("A2_NOME"):SetValue(TMP->A2_NOME)
		oSection1:Cell("A2_NOME"):SetAlign("LEFT")

		oSection1:Cell("E2_VENCREA"):SetValue(stod(TMP->E2_VENCREA))
		oSection1:Cell("E2_VENCREA"):SetAlign("RIGHT")

		oSection1:Cell("E2_SALDO"):SetValue(TMP->E2_SALDO)
		oSection1:Cell("E2_SALDO"):SetAlign("RIGHT")

		oSection1:Cell("E2_NUMBOR"):SetValue(TMP->E2_NUMBOR)
		oSection1:Cell("E2_NUMBOR"):SetAlign("RIGHT")

		oSection1:Cell("EA_MODELO"):SetValue(TMP->EA_MODELO)
		oSection1:Cell("EA_MODELO"):SetAlign("RIGHT")

		oSection1:Cell("X5_DESCRI"):SetValue(SUBSTR(TMP->X5_DESCRI,1,15))
		oSection1:Cell("X5_DESCRI"):SetAlign("LEFT")

		oSection1:Cell("ED_DESCRIC"):SetValue(SUBSTR(TMP->ED_DESCRIC,1,30))
		oSection1:Cell("ED_DESCRIC"):SetAlign("LEFT")

		oSection1:PrintLine()
                        	
		dbSelectArea("TMP")
		TMP->(dbSkip())
	EndDo
	oSection1:Finish()
	TMP->(dbclosearea())

Return