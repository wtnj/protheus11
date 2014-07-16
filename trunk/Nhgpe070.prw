/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHGPE070 ºAutor  ³Marcos R Roquitski  º Data ³  04/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Solicitacao de Vale transporte.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"

User Function Nhgpe070()

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
titulo   := "Solicitacao de Vale Transporte"
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""
cString  := "SRA"
nTipo    := 0
m_pag    := 1
nomeprog := "NHGPE070"
cPerg    := 'RHGP07'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte('RHGP07',.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "NHGPE070"
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

	@ 1, 25 Psay "SOLICITACAO DE VALE TRANSPORTE"
	//@ Prow() + 1, 001 Psay __PrtThinLine()

	@ Prow()+2, 00 Psay "Eu, "+SRA->RA_NOME+" portador(a) do R.G No. "+SRA->RA_RG+"  e da"
	@ Prow()+1, 00 Psay "C.T.P.S nº "+SRA->RA_NUMCP+", série  "+SRA->RA_SERCP+" ,inscrito no C.P.F./M.F sob o No. "+SRA->RA_CIC
	@ Prow()+1, 00 Psay "opto pela utilizacao do vale transporte, motivo pelo  qual,  venho  através  da" 
	@ Prow()+1, 00 Psay "presente fazer a solicitação deste benefício." 


	@ Prow()+2, 00 Psay "Atendendo o disposto no artigo 7º do Decreto n.º 95.247/1987,informo que resido"
	@ Prow()+2, 00 Psay "na Rua __________________________________________________________, n.º ________" 
	@ Prow()+2, 00 Psay "Bairro _____________________, em ____________________/PR, e que os serviços  de"
	@ Prow()+2, 00 Psay "transporte mais adequados ao meu deslocamento residência-trabalho e vice-versa "
	@ Prow()+2, 00 Psay "é a linha de ônibus ___________________________________________________________"
	@ Prow()+2, 00 Psay "motivo pelo qual, preciso de _____ vales por dia."

	@ Prow()+2, 00 Psay "Fico  ciente  de  que  o  benefício  ora  solicitado  será  creditado no cartão"
	@ Prow()+1, 00 Psay "vale-transporte da URBS e autorizo a empresa a adicionar no  referido cartão  o"
	@ Prow()+1, 00 Psay "meu nome, o número da minha  carteira  de identidade, dentre outras informacoes"
	@ Prow()+1, 00 Psay "que a  empresa  entender  como  necessárias,   pois  tenho  ciência  de  que  a"
	@ Prow()+1, 00 Psay "empregadora  somente creditará  os vales-transporte caso o meu cartão apresente"
	@ Prow()+1, 00 Psay "identificação.
 
	@ Prow()+2, 00 Psay "Autorizo,  também,  a  empresa,  a   consultar   junto  à  URBS  meu  saldo  de"
	@ Prow()+1, 00 Psay "vales-transporte,a fim  de  que a empregadora possa verificar quantos vales  eu"
	@ Prow()+1, 00 Psay "estou utilizando por mês."

	@ Prow()+2, 00 Psay "Fico, também,  ciente,  que  na  hipótese de existirem  créditos em  meu cartão" 
	@ Prow()+1, 00 Psay "quando da  consulta  a  ser realizada  pela  empregadora, esta creditará no meu"
	@ Prow()+1, 00 Psay "cartão vale-transporte apenas a quantidade faltante para se completar o  número" 
	@ Prow()+1, 00 Psay "de vales-transporte que utilizo a cada mês. 


	@ Prow()+2, 00 Psay "Comprometo-me a utilizar o benefício apenas para o meu deslocamento residência-" 
	@ Prow()+1, 00 Psay "trabalho e vice-versa, bem como  à informar  o  empregador no caso de alteração"
	@ Prow()+1, 00 Psay "do meu  endereço ou  dos serviços  e  meios de transporte mais adequados ao meu"
	@ Prow()+1, 00 Psay "deslocamento."
 
	@ Prow()+2, 00 Psay "Autorizo o desconto em folha de pagamento de 6%  do  meu   salário  base  mensal"
	@ Prow()+1, 00 Psay "para  concorrer  ao  custeio  do  vale-transporte,  nos  termos do artigo 9º do"
	@ Prow()+1, 00 Psay "Decreto N.º 95.247/1987."

	@ Prow()+2, 00 Psay "Em caso de perda,roubo ou extravio do meu cartão vale-transporte, comprometo-me" 
	@ Prow()+1, 00 Psay "a  fazer  a  comunicação  e  a  solicitação  de  novo  cartão  junto  à URBS e,"
	@ Prow()+1, 00 Psay "posteriormente, a apresentar no RH da empregadora o novo cartão."

	@ Prow()+2, 00 Psay "Declaro  estar ciente  de  que o cartão do vale-transporte também será por  mim"
	@ Prow()+1, 00 Psay "utilizado para registrar os meus horários de trabalho na empresa."
	
	@ Prow()+2, 00 Psay "Por fim,  informo que  também  estou  ciente de que a declaração falsa ou o uso"
	@ Prow()+1, 00 Psay "indevido do benefício constituem falta de natureza grave."


	@ pRow()+3, 35 pSay "Curitiba, "+Alltrim(Str(Day(SRA->RA_ADMISSA)))+" de "+Mesextenso(Month(SRA->RA_ADMISSA)) + " de "+Alltrim(Str(Year(SRA->RA_ADMISSA)))+"."

	@ pRow()+3, 01 pSay "____________________________________________"


	@ pRow()+1,01 pSay SRA->RA_NOME + " Mtr: "+SRA->RA_MAT

	@ pRow()+2,01 pSay "Testemunhas:"

	@ pRow()+2,01 pSay "________________________"
	@ pRow()  ,35 pSay "________________________"

	@ pRow()+1,01 pSay "RG. N.º:"
	@ pRow()  ,35 pSay "RG. N.º:"

	SRA->(DbSkip())
  
Enddo
If aReturn[5] == 1
	Set Printer To
	Commit
   ourspool(wnrel)
Endif
MS_FLUSH()
Return
