#include "font.ch"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHFAT022  ºAutor ³Fabio Nico          º Data ³  12/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao de OS de serviços para execução                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MANUTENCAO DE ATIVOS                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHMNT010()
Local oPrint  
SetPrvt("aGrupo,_cCodUsr,_aDBF,_cOrdem,_totalgeral,_totalcc")

cString   := "SD1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir ")
cDesc2    := OemToAnsi(" as OS de servicos para execucao")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT010"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELACAO DE O.S. PARA EXECUCAO")                
cabec1    := " Cod do Bem   Descricao do Bem                                                                Periodo de : " // + dtoc(mv_par03) + " a " + dtoc(mv_par04)
cabec2    := " Data OS     No.OS   Etapa      Desc.Etapa                               Freq        Insumo        Desc.Insumo                            Qtde.          Qtde Real   Data     Status "
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHMNT010"
_cPerg    := "NHMNT010" 
_nTotal   := 0  
_totalgeral := 0  
_totalcc := 0

Pergunte(_cPerg,.F.)
cabec1  := " Cod do Bem   Descricao do Bem                                                                                                Periodo de : " + dtoc(mv_par03) + " a " + dtoc(mv_par04)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]      

Processa( {|| Gerando()   },"Gerando Dados para a Impressao") 

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool
DbCloseArea("TMP")     
Return

Static Function Gerando()
Local cQuery
Local _n1,_n2,_n3,_ni,_nj,_ng 
Local _aMat := {}
Local _nlin := 0
Local _x := 0
//-----------------------------------------------------------------------
// MONTA A QUERY
//-----------------------------------------------------------------------		

cQuery := " SELECT TJ_DTORIGI,TJ_ORDEM,TJ_PLANO,TJ_CODBEM,T9_NOME,TJ_SEQRELA,TH_TAREFA,TH_ETAPA,TPA_DESCRI,TF_TEENMAN,TF_UNENMAN,TG_CODIGO,T9_CCUSTO, "
cQuery += "	B1_DESC,TG_QUANTID,TG_UNIDADE,TJ_CCUSTO,TF_SERVICO,CTT_DESC01,T9_CODFAMI,T6_NOME "
cQuery += "FROM " + RetSqlName('STJ') + " TJ, " + RetSqlName('ST9') + " T9, " + RetSqlName('STH') + " TH, "+ RetSqlName('TPA') + " PA, " 
cQuery += RetSqlName('STF') + " TF, " + RetSqlName('STG') + " TG, " + RetSqlName('SB1') + " B1, " + RetSqlName('CTT') + " CTT,  " + RetSqlName('ST6') + " T6 " 
cQuery += "WHERE TJ.TJ_CODBEM = T9.T9_CODBEM "
cQuery += "AND T6.T6_CODFAMI = T9.T9_CODFAMI "
cQuery += "AND CTT.CTT_CUSTO = T9.T9_CCUSTO "
cQuery += "AND B1.B1_COD = TG.TG_CODIGO "
cQuery += "AND TG.TG_CODBEM = TJ.TJ_CODBEM "
cQuery += "AND TG.TG_SERVICO = TJ.TJ_SERVICO "
cQuery += "AND TG.TG_SEQRELA = TJ.TJ_SEQRELA "
cQuery += "AND TG.TG_TAREFA = TH.TH_TAREFA "
cQuery += "AND TF.TF_CODBEM = TJ.TJ_CODBEM "
cQuery += "AND TF_SEQRELA = TJ.TJ_SEQRELA "
cQuery += "AND PA.TPA_ETAPA = TH.TH_ETAPA "
cQuery += "AND TH.TH_CODBEM = TJ.TJ_CODBEM "
cQuery += "AND TH.TH_SEQRELA = TJ.TJ_SEQRELA "
cQuery += "AND TH.TH_SERVICO = TJ.TJ_SERVICO " 
cQuery += "AND PA.TPA_ETAPA BETWEEN '"+mv_par15+"' AND '"+mv_par16+"' "     //ETAPA
cQuery += "AND TJ.TJ_CODBEM  BETWEEN '"+mv_par13+"' AND '"+mv_par14+"' "     // COD BEM
cQuery += "AND TF.TF_SERVICO BETWEEN '"+mv_par11+"' AND '"+mv_par12+"' "     // SERVICO 
cQuery += "AND TG.TG_CODIGO  BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "	// CODIGO INSUMO
cQuery += "AND T9.T9_CENTRAB BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "     // FABRICA
cQuery += "AND TJ.TJ_CCUSTO  BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
cQuery += "AND TJ.TJ_PLANO   BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cQuery += "AND TJ.TJ_DTMPINI BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' "
cQuery += "AND TJ.D_E_L_E_T_ = '' AND T9.D_E_L_E_T_ = '' AND TH.D_E_L_E_T_ = '' AND TG.D_E_L_E_T_ = ''  "
cQuery += "AND TF.D_E_L_E_T_ = '' AND PA.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' "
cQuery += "ORDER BY T9_CCUSTO,TJ_CODBEM,TJ_DTORIGI "
//MemoWrit('C:\TEMP\NHMNT010.SQL',cQuery)
TCQUERY cQuery NEW ALIAS "TMP" 

TMP->(DbGotop())     

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

_bem_ant := TMP->TJ_CODBEM
_cc_ant := TMP->T9_CCUSTO

// ESTA ESTRUTURA CRIA UM ARRAY COM O NÚMERO DE LINHAS PARA CADA BEM A SER IMPRESSO
// ESTE ARRAY SERVE PARA VERIFICAR SE O BEM IRÁ CABER NA PÁGINA, SENÃO ELE SERÁ IMPRESSO NA OUTRA PÁGINA
While TMP->(!EoF())
	If _bem_ant == TMP->TJ_CODBEM
		_nlin ++
	Else
		aAdd(_aMat,_nlin)
		_nlin := 1
		_bem_ant := TMP->TJ_CODBEM
	EndIf

	TMP->(DbSkip())
EndDo
aAdd(_aMat,_nlin)
TMP->(DbGoTop())
_bem_ant := TMP->TJ_CODBEM

_x++
@Prow()+1, 001 psay TMP->TJ_CODBEM
@Prow()  , 025 psay ALLTRIM(TMP->T6_NOME) + " / " + ALLTRIM(TMP->T9_NOME)
@Prow()  , 120 psay "Centro Custo: "
@Prow()  , 135 psay TMP->T9_CCUSTO
@Prow()  , 150 psay TMP->CTT_DESC01

While TMP->(!Eof()) 

	If _cc_ant <> TMP->T9_CCUSTO
	   	_nPag  := _nPag + 1
    	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
    	_cc_ant := TMP->T9_CCUSTO
    Endif
		
    If _bem_ant <> TMP->TJ_CODBEM
	    _x++ 
    	If _aMat[_x] >= (65 - Prow()) //verifica se o bem terá o número de linhas que restam na página
		   	_nPag  := _nPag + 1   
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
        EndIf

       	@Prow()+2, 001 psay TMP->TJ_CODBEM
		@Prow()  , 025 psay ALLTRIM(TMP->T6_NOME) + " / " + ALLTRIM(TMP->T9_NOME)
		@Prow()  , 120 psay "Centro Custo: "
		@Prow()  , 135 psay TMP->T9_CCUSTO
		@Prow()  , 150 psay TMP->CTT_DESC01
		_bem_ant := TMP->TJ_CODBEM
	Endif      

	If Prow() > 65 // .Or. _aMat[_x] > (65 - Prow())
	   	_nPag  := _nPag + 1   
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
    Endif
                            		
		@Prow()+1, 001 psay STOD(TMP->TJ_DTORIGI) Picture "99/99/9999" 
		@Prow()  , 012 psay TMP->TJ_ORDEM
//		@Prow()  , 020 psay TMP->TJ_CODBEM
//		@Prow()  , 040 psay TMP->T9_NOME
		@Prow()  , 020 psay TMP->TH_ETAPA
		@Prow()  , 030 psay TMP->TPA_DESCRI
		@Prow()  , 075 psay TMP->TF_TEENMAN 
		@Prow()  , 078 psay TMP->TF_UNENMAN
		@Prow()  , 085 psay TMP->TG_CODIGO
		@Prow()  , 100 psay TMP->B1_DESC
		@Prow()  , 140 psay TMP->TG_QUANTID
		
		@Prow()  , 150 psay "__________"
		@Prow()  , 162 psay "____/____/____"
		@Prow()  , 180 psay "________"  
		
	TMP->(Dbskip())
enddo

Return(nil)