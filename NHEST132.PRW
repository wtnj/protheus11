#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST132 ºAutor  ³João Felipe da Rosa  º Data ³  03/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATÓRIO PEÇA X FERRAMENTA                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

User Function NHEST132()

Agrupo 	  := {}
cString   := ""
cDesc1    := OemToAnsi("Este Relatório apresenta a relação emtre ferramentas")
cDesc2    := OemToAnsi("e peças produzinas.")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST132" //nome do arquivo
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATÓRIO PEÇA X FERRAMENTA") //título
//           |01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
cabec1    := " Peça            Descr. Peca                      Ferramenta     Descr. Ferramenta                Qtde      Valor Unit.  Valor Total"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1 
M_PAG     := 1 //Variavel que acumula numero da pagina 
wnrel     := nomeprog //"NH"
_cPerg    := "EST132" 


If !Pergunte(_cPerg,.T.)
   Return(nil)
Endif 


IF MV_PAR05 == 2
	" Ferramenta      Descr. Ferramenta                Paca           Descr. Peca                      Qtde      Valor Unit.  Valor Total"
ENDIF

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³CHAMADAS PARA AS FUNÇÕES³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus( {|| Imprime()   },"Imprimindo...")

set filter to //remove o filtro da tabela

If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          

MS_FLUSH() //Libera fila de relatorios em spool

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FUNCAO PARA IMPRESSAO DO RELATÓRIO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function Imprime()
Local _nTTGer  := 0
Local _cFiltro := ""
Local nIndex   
Local _nPrc
Local _cFer
Local _cProd

SetRegua(ZAZ->(RecCount()))

_cFiltro += "ZAZ->ZAZ_FCOD   <= '"+MV_PAR01+"' .AND. ZAZ->ZAZ_FCOD   >= '"+MV_PAR02+"' .AND."
_cFiltro += "ZAZ->ZAZ_PRODUT <= '"+MV_PAR03+"' .AND. ZAZ->ZAZ_PRODUT >= '"+MV_PAR04+"'"

Set Filter To &(_cFiltro)

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)                            

//Percorre os registros
While ZAZ->(!Eof())  

	If Prow() > 65 
		_nPag  := _nPag + 1   
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
  	Endif

	IncRegua()
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ AGRUPADO POR PECA ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    
    IF MV_PAR05 == 1
	
		dbSelectArea("ZAZ")
		dbSetOrder(1)//filial + peca + 

		@Prow()+1, 001 psay ALLTRIM(ZAZ->ZAZ_PRODUT)
		
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial('SB1')+ZAZ->ZAZ_PRODUT)
		
		@Prow()  , 017 psay SUBSTR(SB1->B1_DESC,1,30)
		
		_cProd := ZAZ->ZAZ_PRODUT
	    While ZAZ->ZAZ_PRODUT == _cProd
		    @Prow()  , 050 psay ALLTRIM(ZAZ->ZAZ_FCOD)
			
			DbSeek(xFilial('SB1')+ZAZ->ZAZ_FCOD)
	
			@Prow()  , 065 psay SUBSTR(SB1->B1_DESC,1,30)
			@Prow()  , 098 psay ZAZ->ZAZ_QTDE Picture "@e 9999"
			
			@Prow()  , 106 psay SB1->B1_UPRC Picture "@e 9,999,999.99"
			@Prow()  , 120 psay SB1->B1_UPRC * ZAZ->ZAZ_QTDE Picture "@e 9,999,999.99"
			_nTTGer += SB1->B1_UPRC * ZAZ->ZAZ_QTDE
	    
		    ZAZ->(DbSkip())
	    
	    EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ AGRUPADO POR PECA ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	ELSEIF MV_PAR05 == 2

		//seta o indice
		dbSelectArea("ZAZ")
		dbSetOrder(2) //filial + ferramenta

		@Prow()+1, 001 psay ALLTRIM(ZAZ->ZAZ_FCOD)
		
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial('SB1')+ZAZ->ZAZ_FCOD)
		
		@Prow()  , 017 psay SUBSTR(SB1->B1_DESC,1,30)

		_nPrc := SB1->B1_UPRC		
		_cFer := ZAZ->ZAZ_FCOD

	    While ZAZ->ZAZ_FCOD == _cFer
		    @Prow()  , 050 psay ALLTRIM(ZAZ->ZAZ_PRODUT)
			
			DbSeek(xFilial('SB1')+ZAZ->ZAZ_PRODUT)
	
			@Prow()  , 065 psay SUBSTR(SB1->B1_DESC,1,30)
			@Prow()  , 098 psay ZAZ->ZAZ_QTDE Picture "@e 9999"
			
			@Prow()  , 106 psay _nPrc Picture "@e 9,999,999.99"
			@Prow()  , 120 psay _nPrc * ZAZ->ZAZ_QTDE Picture "@e 9,999,999.99"
			_nTTGer += _nPrc * ZAZ->ZAZ_QTDE
	    
		    ZAZ->(DbSkip())
	    
	    EndDo
	
	ENDIF
EndDo

@Prow()+1, 000 psay __PrtThinLine()
@Prow()+1, 100 psay "Total Geral: "
@Prow()  , 120 psay _nTTGer Picture "@e 9,999,999.99"
	
ZAZ->(DbCloseArea())

Return(nil)