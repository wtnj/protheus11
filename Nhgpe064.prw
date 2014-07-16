/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHGPE064 ºAutor  ³Marcos R Roquitski  º Data ³  17/04/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Termo aditivo do contrato de trabalho.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"

User Function Nhgpe064()

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("M_PAG,NOMEPROG,CPERG,")

cSavCur1 := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""
cabec1   := "";cabec2:="";cabec3:="";wnrel:=""
nOrdem   := 0
tamanho  := "P"
limite   := 132
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey := 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Autorizacao para Descontos"
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""
cString  := "SRA"
nTipo    := 0
m_pag    := 1
nomeprog := "NHGPE064"
cPerg    := 'RHGP07'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte('RHGP07',.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "NHGPE064"
wnRel := SetPrint(cString,wnrel,cperg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif


RptStatus({|| fContrato()})

Return Nil


Static Function fContrato()
Local i := 0

DbSelectArea("SRA")
DbSetOrder(01)

SRA->(DbGoTop())
SRA->(SetRegua(RecCount()))

SRA->(DbSeek(mv_par01+mv_par03,.T.))
While SRA->(!Eof()) .and. SRA->RA_FILIAL>=mv_par01 .and. SRA->RA_FILIAL<=mv_par02 .and. SRA->RA_MAT>=mv_par03 .and. SRA->RA_MAT<=mv_par04

  For i := 1 To 2
	@ 1, 30 Psay "TERMO ADITIVO AO CONTRATO DE TRABALHO"
	//@ Prow() + 1, 001 Psay __PrtThinLine()

	@ Prow()+2, 01 Psay "Por  este  instrumento  particular,  de  um  lado "+SM0->M0_NOMECOM 

    If SM0->M0_CODIGO == "FN"	.AND. SM0->M0_CODFIL == "02"	
       @ Prow()+1, 01 Psay "com sede na Rua Senador V. Carvalho,33 em Gloria de Goita, Pernanbuco, ins. no" 
    Else
       @ Prow()+1, 01 Psay "com sede na "+Substr(SM0->M0_ENDCOB,1,34)+" , em Curitiba, Paraná, inscrita no" 
    Endif	            

	@ Prow()+1, 01 Psay "CNPJ  sob  o  nº "+TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99")+", doravante  denominada  de EMPREGADORA,  e de"
	@ Prow()+1, 01 Psay "outro lado o Sr. "+SRA->RA_NOME+" , brasileiro,  portador  da  CTPS"
	@ Prow()+1, 01 Psay "nº   "+SRA->RA_NUMCP+", série   "+SRA->RA_SERCP+" ,doravante denominado  de  EMPREGADO,  têm entre si,"
	@ Prow()+1, 01 Psay "certo  e  ajustado  o  presente  termo  aditivo  ao contrato de trabalho, ficando"
	@ Prow()+1, 01 Psay "estabelecidas as seguintes cláusulas e condições:"

	@ pRow()+3, 01 pSay "CLAUSULA PRIMEIRA"
	@ Prow()+1, 01 Psay "Fica ciente o EMPREGADO que o cartão magnético fornecido ao mesmo  para  registro"
	@ Prow()+1, 01 Psay "do  horário  de   trabalho   e   para  registro do fornecimento da alimentação no"
	@ Prow()+1, 01 Psay "refeitório é de uso pessoal e intransferível."

	@ pRow()+3, 01 pSay "CLÁUSULA SEGUNDA"
	@ pRow()+1, 01 pSay "Compromete-se o EMPREGADO a registrar diariamente e corretamente  os  horários de"
	@ pRow()+1, 01 pSay "início  e  de  término  do  trabalho,  bem  como o fornecimento da alimentação no"
	@ pRow()+1, 01 pSay "refeitório."

	@ pRow()+3, 01 pSay "CLÁUSULA TERCEIRA"
	@ pRow()+1, 01 pSay "EMPREGADO  responsabiliza-se  pelo  uso do cartão  e compromete-se a devolve-lo à"
	@ pRow()+1, 01 pSay "EMPREGADORA no  momento  da  rescisão  do  contrato de trabalho ou na hipótese de"
	@ pRow()+1, 01 pSay "troca e/ou substituição do cartão."

	@ pRow()+3, 01 pSay "CLÁUSULA QUARTA"
	@ pRow()+1, 01 pSay "Caso o EMPREGADO venha  a  perder  o cartão magnético, fica desde já autorizada a"
	@ pRow()+1, 01 pSay "EMREGADORA a efetuar o desconto no holerite de pagamento do valor necessário para"
	@ pRow()+1, 01 pSay "a aquisição de outro cartão."

	@ pRow()+3, 01 pSay "CLÁUSULA QUINTA"
	@ pRow()+1, 01 pSay "Declaro ter recebido na data de hoje da empresa "+SM0->M0_NOMECOM
	@ pRow()+1, 01 pSay "o cartão magnético através  do qual farei o registro do meu horário de  trabalho,"
	@ pRow()+1, 01 pSay "bem como o registro do fornecimento da alimentação no refeitório."

	@ pRow()+3, 01 pSay "CLÁUSULA SEXTA"
	@ pRow()+1, 01 pSay "E,  por  estarem  de pleno  acordo, as partes assinam o presente termo aditivo ao"
	@ pRow()+1, 01 pSay "contrato  de  trabalho  em  duas  vias de igual teor e forma, na presença de duas"
	@ pRow()+1, 01 pSay "testemunhas."

	@ pRow()+5,35 pSay SM0->M0_CIDENT+", "+Alltrim(Str(Day(SRA->RA_ADMISSA)))+" de "+Mesextenso(Month(SRA->RA_ADMISSA)) + " de "+Alltrim(Str(Year(SRA->RA_ADMISSA)))+"."

	@ pRow()+5,01 pSay "___________________________________________"
	@ pRow()  ,55 pSay "________________________"

	@ pRow()+1,01 pSay SRA->RA_NOME +" Mtr.: "+SRA->RA_MAT
	@ pRow()  ,55 pSay "EMPREGADOR"


	@ pRow()+3,01 pSay "Testemunhas:"

	@ pRow()+3,01 pSay "________________________"
	@ pRow()  ,35 pSay "________________________"

	@ pRow()+1,01 pSay "RG. N.º:"
	@ pRow()  ,35 pSay "RG. N.º:"
   
   Next 
   SRA->(DbSkip())
Enddo
If aReturn[5] == 1
	Set Printer To
	Commit
   ourspool(wnrel)
Endif
MS_FLUSH()
Return
