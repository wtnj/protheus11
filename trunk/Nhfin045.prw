/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Nhfin045 ³ Autor ³ Marcos R. Roquitski   ³ Data ³ 29/10/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime relatorio do retorno de cobranca B. Brasil         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Contas a Receber                                           ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "rwmake.ch"

User Function Nhfin045()

SetPrvt("cString,cDesc1,cDesc2,cDesc3,cTamanho,aReturn,cNomeprog,aLinha,nLastKey,lEnd,cTitulo")
SetPrvt("cabec1,cabec2,cabec3,cCancel,m_pag,cPerg,wnrel,nLimite,li,_cArq,_lRet")

cString   := "TRB"
cDesc1    := "Listagem Retorno"
cDesc2    := "Este programa gera o relat¢rio com as ocorrencias do Arquivo Retorno"
cDesc3    := ""
cTamanho  := "G"
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
cNomeprog := "NHFIN045"
aLinha    := {}
nLastKey  := 0 
lEnd      := .f. 
cTitulo   := "Relatorio de Ocorrencias - Cobranca Banco do Brasil"
cabec1    := " Prf Numero                Valor   Descricao da Ocorrencia                          Valor Pago   Valor Liquido    Outras Desp.   Dt. Credito"
cabec2    := ""
cabec3    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
m_pag     := 1  //Variavel que acumula numero da pagina
cPerg     := "NHFIN045"
wnrel     := "NHFIN045"
nLimite   := 220
_lRet     := .F.

If !fValidArq()
	Return
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3,.F.,"",,cTamanho)
If nLastKey == 27
   Set Filter To
   Return
Endif

SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o tipo do relat¢rio                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo  := IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))


RptStatus ({|| fDetalhe() })

Return


Static Function fValidArq()

   SetPrvt("_cArquivo,_Tipo")

   _cArquivo := Space(50)
	
	@ 200,050 To 350,500 Dialog DlgArquivo Title OemToAnsi("Selecione arquivo para Impressao")
	@ 025,020 Say OemToAnsi("Arquivo") Size 20,8
	@ 024,055 Get _cArquivo PICTURE "@!"  Size 110,8 When .F.

	@ 021,180 Button  "Localizar" Size 36,16 Action fRunDlg()
	@ 058,080 BMPBUTTON TYPE 01 ACTION fImpArq()
	@ 058,120 BMPBUTTON TYPE 02 ACTION Close(DlgArquivo)

	Activate Dialog DlgArquivo CENTERED

Return(_lRet)


Static Function fImpArq()
Local _aStruct

_lRet := .T.
_aStruct:={{ "FILLER01","C",240,0}} 

_cArq := CriaTrab(_aStruct,.t.)
USE &_cArq Alias TRB New Exclusive

DbselectArea("TRB")
If !Empty(_cArquivo)
	Append From (_cArquivo) SDF
Endif	
TRB->(DbGotop())

Close(DlgArquivo)

Return


Static Function fRunDlg()

	_cTipo :=          "Todos os Arquivos (*.*)    | *.*   | "
	_cTipo := _cTipo + "Arquivos tipo     (*.TXT)  | *.TXT   "
    
	// cFile := cGetFile(cTipo,"Dialogo de Selecao de Arquivos")
	_cArquivo := cGetFile(_cTipo,,0,,.T.,49)

Return


Static Function fDetalhe()
Local _nVlrTot := _nVlrLiq := _nVlrDes := _nVlrPag := 0


	TRB->(Dbgotop())
	SetRegua(TRB->(RecCount()))

	cabec(ctitulo,cabec1,cabec2,cNomeprog,ctamanho,nTipo)
	While !TRB->(Eof())
		If Substr(TRB->FILLER01,14,1) == "T"

			If Prow() > 55
				cabec(ctitulo,cabec1,cabec2,cNomeprog,ctamanho,nTipo)
			Endif

			@ Prow()+001,001 pSay Substr(TRB->FILLER01,59,03)
			@ Prow()    ,005 pSay Substr(TRB->FILLER01,62,10)
			@ Prow()    ,018 pSay Transform((Val(Substr(TRB->FILLER01,82,15)) / 100),"@e 999,999,999.99")
			@ Prow()    ,035 pSay Substr(TRB->FILLER01,214,2) + " "+_fOcorrencia(Alltrim(Substr(TRB->FILLER01,214,10)))
			_nVlrTot += (Val(Substr(TRB->FILLER01,82,15)) / 100)
			TRB->(Dbskip())
			If Substr(TRB->FILLER01,14,1) == "U"
				@ Prow()    ,080 pSay Transform((Val(Substr(TRB->FILLER01,78,15)) / 100),"@e 999,999,999.99")
				@ Prow()    ,096 pSay Transform((Val(Substr(TRB->FILLER01,93,15)) / 100),"@e 999,999,999.99")
				@ Prow()    ,112 pSay Transform((Val(Substr(TRB->FILLER01,108,15)) / 100),"@e 999,999,999.99")
				@ Prow()    ,130 pSay Substr(TRB->FILLER01,146,02)+"/"+Substr(TRB->FILLER01,148,02)+"/"+Substr(TRB->FILLER01,150,04)
				_nVlrPag += (Val(Substr(TRB->FILLER01,078,15))/100)
				_nVlrLiq += (Val(Substr(TRB->FILLER01,093,15))/100)
				_nVlrDes += (Val(Substr(TRB->FILLER01,108,15))/100)
			Endif
								
		Endif
		TRB->(Dbskip())

	Enddo
	@ Prow()+02,001 Psay __PrtThinLine() 
	@ Prow()+01,002 Psay "Total:"
	@ Prow()   ,018 pSay Transform(_nVlrTot,"@e 999,999,999.99")
	@ Prow()   ,080 pSay Transform(_nVlrPag,"@e 999,999,999.99")
	@ Prow()   ,096 pSay Transform(_nVlrLiq,"@e 999,999,999.99")
	@ Prow()   ,112 pSay Transform(_nVlrDes,"@e 999,999,999.99")
	@ Prow()+01,001 Psay __PrtThinLine() 
	If aReturn[5] == 1
		Set Printer to
		DbcommitAll()
		Ourspool(wnrel)
   Endif
   MS_FLUSH()

   DbSelectArea("TRB")
   DbCloseArea()

   fErase(_cArq+".DBF")

Return		


Static Function _fOcorrencia(_cTipo)
Local _cDescri 

	If _cTipo == "00"
		_cDescri := "Pagamento Efetuado"
	Elseif _cTipo == "01"
		_cDescri := "Codigo do banco invalido"
	Elseif _cTipo == "02"
		_cDescri := "Codigo do registro detalhe invalido"
	Elseif _cTipo == "03"
		_cDescri := "Codigo do segmento invalido"
	Elseif _cTipo == "04"
		_cDescri := "Movimento nao permitido para carteira"
	Elseif _cTipo == "05"
		_cDescri := "Codigo do movimento invalido"
	Elseif _cTipo == "06"
		_cDescri := "Tipo/Nr de inscr.do cedente invalidos"
	Elseif _cTipo == "07"
		_cDescri := "Agencia/Conta/DV invalido"
	Elseif _cTipo == "08"
		_cDescri := "Nosso numero invalido"
	Elseif _cTipo == "09"
		_cDescri := "Nosso numero duplicado"
	Elseif _cTipo == "10"
		_cDescri := "Carteira invalida"
	Elseif _cTipo == "11"
		_cDescri := "Forma de cadastr. do titulo invalido"
	Elseif _cTipo == "12"
		_cDescri := "Tipo de documento invalido"
	Elseif _cTipo == "13"
		_cDescri := "Identif. emissao do bloq. invalida"
	Elseif _cTipo == "14"
		_cDescri := "Identif. distrib. do bloq. invalida"
	Elseif _cTipo == "15"
		_cDescri := "Caracter. da cobranca incompativeis"
	Elseif _cTipo == "16"
		_cDescri := "Data de vencimento invalida"
	Elseif _cTipo == "17"
		_cDescri := "Dt. Vecto anterior a emissao"
	Elseif _cTipo == "18"
		_cDescri := "Vencto fora do prazo de operacao"
	Elseif _cTipo == "19"
		_cDescri := "Tit. com Vencto inferior"
	Elseif _cTipo == "20"
		_cDescri := "Valor do titulo invalido"
	Elseif _cTipo == "21"
		_cDescri := "Especie do titulo invalida"
	Elseif _cTipo == "22"
		_cDescri := "Especie nao permitida p/ carteira"
	Elseif _cTipo == "23"
		_cDescri := "Aceite invalido"
	Elseif _cTipo == "24"
		_cDescri := "Data da emissao invalida"
	Elseif _cTipo == "25"
		_cDescri := "Dt. emissao posterior a data"
	Elseif _cTipo == "26"
		_cDescri := "Cod. juros de mora invalido"
	Elseif _cTipo == "27"
		_cDescri := "Vlr/Taxa de juros de mora invalido"
	Elseif _cTipo == "28"
		_cDescri := "Cod. desconto invalido"
	Elseif _cTipo == "29"
		_cDescri := "Vlr do desconto maior que o Titulo"
	Elseif _cTipo == "30"
		_cDescri := "Desconto a conceder nao confere"
	Elseif _cTipo == "31"
		_cDescri := "Concessao de desconto - ja existe"
	Elseif _cTipo == "32"
		_cDescri := "Valor do IOF invalido"
	Elseif _cTipo == "33"
		_cDescri := "Valor do abatimento invalido"
	Elseif _cTipo == "34"
		_cDescri := "Valor do abatim. maior que o titulo"
	Else
		_cDescri := "< ver NOTAS  item 42 >"
	Endif

Return(_cDescri)

