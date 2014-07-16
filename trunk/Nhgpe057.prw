/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE057  ºAutor  ³Microsiga           º Data ³  10/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Acordp Individual para Prorrogacao de horas.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function NhGpe057()

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("M_PAG,NOMEPROG,CPERG,_cDescCC,i")


cSavCur1 := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""
cabec1   := "";cabec2:="";cabec3:="";wnrel:=""
nOrdem   := 0
tamanho  := "P"
limite   := 132
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey := 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Acordo Individual para Prorrogacao de Horas de Trabalho"
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""
cString  := "SRA"
nTipo    := 0
m_pag    := 1
nomeprog := "NHGPE057"
cPerg    := 'RHGP07'
_cDescCC := ""
i        := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte('RHGP07',.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "NHGPE057"
wnRel := SetPrint(cString,wnrel,cperg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif


RptStatus({|| fAutoriza()})

Return Nil


Static Function fAutoriza()

SI3->(DbSetOrder(1))
DbSelectArea("SRA")
DbSetOrder(01)

SRA->(DbGoTop())
SRA->(SetRegua(RecCount()))

SRA->(DbSeek(mv_par01+mv_par03,.T.))
While SRA->(!Eof()) .and. SRA->RA_FILIAL>=mv_par01 .and. SRA->RA_FILIAL<=mv_par02 .and. SRA->RA_MAT>=mv_par03 .and. SRA->RA_MAT<=mv_par04
	
	IncRegua()

	For i := 1 To 2
	 
		@        1, 22 pSay "* *  "+SM0->M0_NOMECOM + "  * *"
		@ pRow()+4, 04 pSay "Curitiba, "+StrZero(Day(SRA->RA_ADMISSAO),2) + " de "+MesExtenso(SRA->RA_ADMISSAO) + " de "+ Str(Year(SRA->RA_ADMISSAO),4)
		@ pRow()+3, 04 pSay "Ao Funcionario"
		@ pRow()+3, 04 pSay "Matricula: "+SRA->RA_MAT
		@ pRow()+1, 04 pSay "Nome     : "+SRA->RA_NOME

		// Localiza a Conta dentro do CC e Imprime
		If SI3->(DbSeek(xFilial("SI3")+SRA->RA_CC)) // Buscar o nome
			_cDescCC := AllTrim(SI3->I3_DESC)
		Else
			_cDescCC := ""
		Endif

		@ pRow()+1, 03 pSay "Setor    : "+SRA->RA_CC  + " "+_cDescCC
		@ pRow()+2, 03 pSay "Ref: Autorizacao de Horas Extras"
		@ pRow()+2, 03 pSay "Prezado Senhor(A)"
		@ pRow()+2, 08 pSay      "Considerando que a empresa constatou irregularidades na marcacao do cartao"
		@ pRow()+1, 03 pSay "de ponto" 
		@ pRow()+1, 08 pSay      "Considerando que o empregado so pode realizar horas exras com  autorizacao"
		@ pRow()+1, 03 pSay "formal da chefia"
		@ pRow()+1, 08 pSay      "Considerando que nao e permitida a permanencia na empresa (em  vestiarios,"
		@ pRow()+1, 03 pSay "no setor fabril,em copa/cozinha) de empregados que nao estejam   trabalhando ou"
		@ pRow()+1, 03 pSay "que ja tenham cumprido o seu turno;"          
		@ pRow()+2, 08 pSay      "Considerando que alguns empregados vem permanecendo na empresa apos o  seu"
		@ pRow()+1, 03 pSay "horario, sem trabalhar e passando o cracha eletronico  apenas  quando  deixam a"
		@ pRow()+1, 03 pSay "empresa, o que gera horas extras sem que o  empregado  esteja  a  disposicao do" 
		@ pRow()+1, 03 pSay "empregador;"
		@ pRow()+2, 08 pSay      "E a presente para cientifica-lo que a partir de  hoje serao advertidos por"
		@ pRow()+1, 03 pSay " escrito e nao terao satisfeitas horas extras os empregados que:"
		@ pRow()+2, 03 pSay "1. Permanecerem  no  posto  de  trabalho   apos  o  seu  horaro de trabalho sem"
		@ pRow()+1, 03 pSay "   autorizacao formal da chefia."
		@ pRow()+2, 03 pSay "2. Permanecerem nas dependencias da empresa (Vestiarios, copa cozinha,  outras)"
		@ pRow()+1, 03 pSay "   apos o seu horario de trabalho, so passando o cracha  eletronico  quando  da"
		@ pRow()+1, 03 pSay "   saida."
		@ pRow()+2, 03 pSay "A presente correspondencia se faz necessaria como forma de otimizar o  processo"
		@ pRow()+1, 03 pSay "produtivo e a alcancar resultados positivos para todos  os  colaboradores,  sem"
		@ pRow()+1, 03 pSay "perdas desnecessaria e geradoras de custos para a empresa."
		@ pRow()+2, 03 pSay "Contando com a compreensao e colaboracao de todos, desde ja agradecemos,"
		@ pRow()+3, 03 pSay "Ciente:"
		@ pRow()+4, 03 pSay "________________________________________"
		@ pRow()  , 50 pSay "______________________________________"
		@ pRow()+1, 03 pSay SM0->M0_NOMECOM
		@ pRow()  , 50 pSay SRA->RA_NOME
		@ pRow()+1, 01 pSay ""

	Next
	i := 0
	SRA->(DbSkip())

Enddo
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel)
Endif
MS_FLUSH()

Return
