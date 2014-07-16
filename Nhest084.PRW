/*
+----------------------------------------------------------------------------+
!                             FICHA TÉCNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Relatorio                                               !
+------------------+---------------------------------------------------------+
!Módulo            ! ESTOQUE                                                 !
+------------------+---------------------------------------------------------+
!Nome              ! NHEST084                                                !
+------------------+---------------------------------------------------------+
!Tabelas Utilizadas! SB1 SB2 SB8                                             !
+------------------+---------------------------------------------------------+
!Descrição         ! Analisa Saldo Atual X Saldo por Lote X izacao           !
+------------------+---------------------------------------------------------+
!Autor             ! Marcelo A.Paese(Prg.SP)-->Alexandre R.B.                !
+------------------+---------------------------------------------------------+
!Data de Criação   ! 09/05/01                                                !
+------------------+---------------------------------------------------------+
!   ATUALIZACÕES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+ 
*/ 
#include "rwmake.ch"     
#include "TOPCONN.CH"

User Function NHEST084() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,CABEC1,CABEC2,CABEC3,WNREL")
SetPrvt("NORDEM,NLASTKEY,TAMANHO,LIMITE,TITULO,CDESC1")
SetPrvt("CDESC2,CDESC3,CSTRING,ARETURN,NOMEPROG,M_PAG")
SetPrvt("CQUERY,ADRIVER,CDRIVER,CNORMAL,CPRODUTO,CLOCAL")
SetPrvt("ACAMPOS,")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//
CbTxt:= "";CbCont:= cabec1:= cabec2:= cabec3:= wnrel:= ""
nOrdem  := cbcont := nLastkey := 0
tamanho :="M"   // Tamanho do Layout do Relatorio    "P/M/G"
limite  := 132   // Limites de Colunas do Relatorio
titulo  := cDesc1 := "Analisa Saldo Atual X Saldo por Lote"
cDesc2  := cDesc3 := ""

//          0         1         2         3         4         5         6         7         8
//          0         0         0         0         0         0         0         0         0
Cabec1  := "PRODUTO         DESCRICAO                     LOCAL      SALDO (SB2)     SALDO (SB8)      SALDO (SBF)     DISTRIB(SDA)"
//          XXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX       9999999,999.999 9999999,999.999  9999999,999.999

//
cString :="SC2"    // Arquivo que ira fazer a filtragem
aReturn := { "PREENCHER", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:= "NHEST084" // Nome do programa
M_PAG   := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "NHEST084"
wnrel:=SetPrint(cString,wnrel,"NHEST084",Titulo,cDesc1,cDesc2,cDesc3,.F.,"")

IF nLastKey == 27
   Return
ENDIF

SetDefault(aReturn,cString)

SB1->( DBSETORDER(1) )
SB2->( DBSETORDER(1) )
SB8->( DBSETORDER(1) )
SBF->( DBSETORDER(2) )   // Produto Local

Processa( {|| IMPRESSAO() } )// Substituido pelo assistente de conversao do AP5 IDE em 06/06/01 ==> Processa( {|| Execute(IMPRESSAO) } )

TONE( 900, 3 )
TONE( 500, 1 )

SET DEVICE TO SCREEN

//EJECT
IF aReturn[ 5 ] == 1
   SET PRINTER TO
   DBCOMMITALL()
   OURSPOOL(wnrel)
ENDIF
// Eject
RETURN

//////////////////////////////////////////////////////////////////////////////

Static FUNCTION IMPRESSAO()
******************

cQuery := "select B2_COD PRODUTO, B2_LOCAL LOCAL, 1 TIPO, SUM(B2_QATU) QATU, SUM(B2_QEMP) QEMP"
cQuery := cQuery + " from " + RetSQLName('SB2')
cQuery := cQuery + " where B2_FILIAL = '" + xFilial('SB2') + "'"
cQuery := cQuery + " and D_E_L_E_T_ <> '*'"
cQuery := cQuery + " group by B2_COD, B2_LOCAL"
cQuery := cQuery + " union"
cQuery := cQuery + " select B8_PRODUTO PRODUTO, B8_LOCAL LOCAL, 2 TIPO, SUM(B8_SALDO) QATU, SUM(B8_EMPENHO) QEMP"
cQuery := cQuery + " from " + RetSQLName('SB8')
cQuery := cQuery + " where B8_FILIAL = '" + xFilial('SB8') + "'"
cQuery := cQuery + " and D_E_L_E_T_ <> '*'"
cQuery := cQuery + " group by B8_PRODUTO, B8_LOCAL"
cQuery := cQuery + " union"
cQuery := cQuery + " select BF_PRODUTO PRODUTO, BF_LOCAL LOCAL, 3 TIPO, SUM(BF_QUANT) QATU, SUM(BF_EMPENHO) QEMP"
cQuery := cQuery + " from " + RetSQLName('SBF') + ", " + RetSQLName('SB1')
cQuery := cQuery + " where BF_FILIAL = '" + xFilial('SBF') + "'"
cQuery := cQuery + " and B1_FILIAL = '" + xFilial('SB1') + "'"
cQuery := cQuery + " and "+ RetSQLName('SBF') + ".D_E_L_E_T_ <> '*'"
cQuery := cQuery + " and "+ RetSQLName('SB1') + ".D_E_L_E_T_ <> '*'"
cQuery := cQuery + " and B1_LOCALIZ = 'S'"
cQuery := cQuery + " and BF_PRODUTO = B1_COD"
cQuery := cQuery + " group by BF_PRODUTO, BF_LOCAL"
cQuery := cQuery + " union"
cQuery := cQuery + " select DA_PRODUTO PRODUTO, DA_LOCAL LOCAL, 4 TIPO, SUM(DA_SALDO) QATU, SUM(DA_EMPENHO) QEMP"
cQuery := cQuery + " from " + RetSQLName('SDA') + ", " + RetSQLName('SB1')
cQuery := cQuery + " where DA_FILIAL = '" + xFilial('SDA') + "'"
cQuery := cQuery + " and B1_FILIAL = '" + xFilial('SB1') + "'"
cQuery := cQuery + " and "+ RetSQLName('SDA') + ".D_E_L_E_T_ <> '*'"
cQuery := cQuery + " and "+ RetSQLName('SB1') + ".D_E_L_E_T_ <> '*'"
cQuery := cQuery + " and DA_PRODUTO = B1_COD"
cQuery := cQuery + " and B1_LOCALIZ = 'S'"
cQuery := cQuery + " and DA_SALDO > 0 "
cQuery := cQuery + " group by DA_PRODUTO, DA_LOCAL"
cQuery := cQuery + " order by 1,2,3"

TCQuery cQuery new alias "TRB"
TCSetField("TRB", "QATU", "N", 14, 3)
TCSetField("TRB", "QEMP", "N", 14, 3)

   aDriver   := ReadDriver()
   cDriver   := aDriver[3]
   cNormal   := aDriver[2]

   @ pRow()+1,000 psay &cDriver

   CABEC( titulo, cabec1 ,cabec2 , "NHEST084", tamanho, 15 )

   WHILE TRB->( !EOF() )

	cProduto := TRB->PRODUTO 
	cLocal   := TRB->LOCAL
	//Inicializa o vetor que contera os campos para cada produto
        //O valor de 9999999999 serve para a diferenciar na comparacao
	//1-SB2   2-SB8   3-SBF   4-SDA
	aCampos := {{0, 0, '', ''}, {0, 0, '', ''}, {0, 0, '', ''}, {0, 0, '', ''}}

	WHILE TRB->PRODUTO + TRB->LOCAL == cProduto + cLocal .AND. TRB->( !EOF() )
		aCampos[TRB->TIPO, 1] := TRB->QATU
		aCampos[TRB->TIPO, 2] := TRB->QEMP
		TRB->(dbskip())
	ENDDO

        IF (NoRound(aCampos[1,1],3) <> NoRound(aCampos[2,1],3) .OR. ;
            NoRound(aCampos[1,1],3) <> NoRound(aCampos[3,1]+ aCampos[4,1],3) .OR. ;
            NoRound(aCampos[2,1],3) <> NoRound(aCampos[3,1]+ aCampos[4,1],3))
         SB1->( DBSEEK( xFilial( "SB1" ) + cProduto) )

         IF SB1->B1_RASTRO == "L" .and. NoRound(aCampos[1,1],3) <> NoRound(aCampos[2,1],3)

            // Caso a diferenca seja no SB2/SB8

            IF PROW() > 64
               CABEC( titulo, cabec1 ,cabec2 , "NHEST084", tamanho, 15 )
            ENDIF

            @ PROW()+1, 000    PSAY LEFT( SB1->B1_COD, 14 )
            @ PROW(), PCOL()+1 PSAY SB1->B1_DESC

            @ PROW(), PCOL()+1 PSAY cLocal
//            @ PROW(), PCOL()+4 PSAY SB1->B1_GRUPO
//            @ PROW(), PCOL()+3 PSAY SB1->B1_LOCALIZ
            @ PROW(), PCOL()+4 PSAY TRAN( aCampos[1,1], "@E 99999,999.999" )
            @ PROW(), PCOL()+3 PSAY TRAN( aCampos[2,1], "@E 99999,999.999" )

            If SB1->B1_LOCALIZ == 'S' .and. cLocal <> '98' //Almoxarifado de controle de qualidade

               If NoRound(aCampos[1,1],3) <> NoRound(aCampos[3,1]+ aCampos[4,1],3) .OR.;
                  NoRound(aCampos[2,1],3) <> NoRound(aCampos[3,1]+ aCampos[4,1],3) 
                  
                  @ PROW(), PCOL()+4 PSAY TRAN( aCampos[3,1], "@E 99999,999.999" )
                  @ PROW(), PCOL()+4 PSAY TRAN( aCampos[4,1], "@E 99999,999.999" )

               Endif

            Endif

         ElseIf SB1->B1_RASTRO == "L" .and. ( NoRound(aCampos[1,1],3) <> NoRound(aCampos[3,1]+ aCampos[4,1],3) .OR. NoRound(aCampos[2,1],3) <> NoRound(aCampos[3,1]+ aCampos[4,1],3))

            // Caso a diferenca nao seja no SB2/SB8
            If SB1->B1_LOCALIZ == 'S' .and. cLocal <> '98'//Almoxarifado de controle de qualidade

               IF PROW() > 64
                  CABEC( titulo, cabec1 ,cabec2 , "NHEST084", tamanho, 15 )
               ENDIF

               SB1->( DBSEEK( xFilial( "SB1" ) + cProduto ) )

               @ PROW()+1, 000    PSAY LEFT( SB1->B1_COD, 14 )
               @ PROW(), PCOL()+1 PSAY SB1->B1_DESC

               @ PROW(), PCOL()+1 PSAY cLocal
//               @ PROW(), PCOL()+4 PSAY SB1->B1_GRUPO
//               @ PROW(), PCOL()+3 PSAY SB1->B1_LOCALIZ
               @ PROW(), PCOL()+4 PSAY TRAN( aCampos[1,1], "@E 99999,999.999" )
               @ PROW(), PCOL()+3 PSAY TRAN( aCampos[2,1], "@E 99999,999.999" )

               @ PROW(), PCOL()+4 PSAY TRAN( aCampos[3,1], "@E 99999,999.999" )
               @ PROW(), PCOL()+4 PSAY TRAN( aCampos[4,1], "@E 99999,999.999" )

            Endif
             
         Endif

      Endif

      IncProc()

   Enddo

   TRB->( DBCLOSEAREA() )

RETURN( NIL )

