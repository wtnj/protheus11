/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHGPE070 �Autor  �Marcos R Roquitski  � Data �  04/01/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Solicitacao de Vale transporte.                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//�                                                              �
//����������������������������������������������������������������
pergunte('RHGP07',.F.)

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
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
	@ Prow()+1, 00 Psay "C.T.P.S n� "+SRA->RA_NUMCP+", s�rie  "+SRA->RA_SERCP+" ,inscrito no C.P.F./M.F sob o No. "+SRA->RA_CIC
	@ Prow()+1, 00 Psay "opto pela utilizacao do vale transporte, motivo pelo  qual,  venho  atrav�s  da" 
	@ Prow()+1, 00 Psay "presente fazer a solicita��o deste benef�cio." 


	@ Prow()+2, 00 Psay "Atendendo o disposto no artigo 7� do Decreto n.� 95.247/1987,informo que resido"
	@ Prow()+2, 00 Psay "na Rua __________________________________________________________, n.� ________" 
	@ Prow()+2, 00 Psay "Bairro _____________________, em ____________________/PR, e que os servi�os  de"
	@ Prow()+2, 00 Psay "transporte mais adequados ao meu deslocamento resid�ncia-trabalho e vice-versa "
	@ Prow()+2, 00 Psay "� a linha de �nibus ___________________________________________________________"
	@ Prow()+2, 00 Psay "motivo pelo qual, preciso de _____ vales por dia."

	@ Prow()+2, 00 Psay "Fico  ciente  de  que  o  benef�cio  ora  solicitado  ser�  creditado no cart�o"
	@ Prow()+1, 00 Psay "vale-transporte da URBS e autorizo a empresa a adicionar no  referido cart�o  o"
	@ Prow()+1, 00 Psay "meu nome, o n�mero da minha  carteira  de identidade, dentre outras informacoes"
	@ Prow()+1, 00 Psay "que a  empresa  entender  como  necess�rias,   pois  tenho  ci�ncia  de  que  a"
	@ Prow()+1, 00 Psay "empregadora  somente creditar�  os vales-transporte caso o meu cart�o apresente"
	@ Prow()+1, 00 Psay "identifica��o.
 
	@ Prow()+2, 00 Psay "Autorizo,  tamb�m,  a  empresa,  a   consultar   junto  �  URBS  meu  saldo  de"
	@ Prow()+1, 00 Psay "vales-transporte,a fim  de  que a empregadora possa verificar quantos vales  eu"
	@ Prow()+1, 00 Psay "estou utilizando por m�s."

	@ Prow()+2, 00 Psay "Fico, tamb�m,  ciente,  que  na  hip�tese de existirem  cr�ditos em  meu cart�o" 
	@ Prow()+1, 00 Psay "quando da  consulta  a  ser realizada  pela  empregadora, esta creditar� no meu"
	@ Prow()+1, 00 Psay "cart�o vale-transporte apenas a quantidade faltante para se completar o  n�mero" 
	@ Prow()+1, 00 Psay "de vales-transporte que utilizo a cada m�s. 


	@ Prow()+2, 00 Psay "Comprometo-me a utilizar o benef�cio apenas para o meu deslocamento resid�ncia-" 
	@ Prow()+1, 00 Psay "trabalho e vice-versa, bem como  � informar  o  empregador no caso de altera��o"
	@ Prow()+1, 00 Psay "do meu  endere�o ou  dos servi�os  e  meios de transporte mais adequados ao meu"
	@ Prow()+1, 00 Psay "deslocamento."
 
	@ Prow()+2, 00 Psay "Autorizo o desconto em folha de pagamento de 6%  do  meu   sal�rio  base  mensal"
	@ Prow()+1, 00 Psay "para  concorrer  ao  custeio  do  vale-transporte,  nos  termos do artigo 9� do"
	@ Prow()+1, 00 Psay "Decreto N.� 95.247/1987."

	@ Prow()+2, 00 Psay "Em caso de perda,roubo ou extravio do meu cart�o vale-transporte, comprometo-me" 
	@ Prow()+1, 00 Psay "a  fazer  a  comunica��o  e  a  solicita��o  de  novo  cart�o  junto  � URBS e,"
	@ Prow()+1, 00 Psay "posteriormente, a apresentar no RH da empregadora o novo cart�o."

	@ Prow()+2, 00 Psay "Declaro  estar ciente  de  que o cart�o do vale-transporte tamb�m ser� por  mim"
	@ Prow()+1, 00 Psay "utilizado para registrar os meus hor�rios de trabalho na empresa."
	
	@ Prow()+2, 00 Psay "Por fim,  informo que  tamb�m  estou  ciente de que a declara��o falsa ou o uso"
	@ Prow()+1, 00 Psay "indevido do benef�cio constituem falta de natureza grave."


	@ pRow()+3, 35 pSay "Curitiba, "+Alltrim(Str(Day(SRA->RA_ADMISSA)))+" de "+Mesextenso(Month(SRA->RA_ADMISSA)) + " de "+Alltrim(Str(Year(SRA->RA_ADMISSA)))+"."

	@ pRow()+3, 01 pSay "____________________________________________"


	@ pRow()+1,01 pSay SRA->RA_NOME + " Mtr: "+SRA->RA_MAT

	@ pRow()+2,01 pSay "Testemunhas:"

	@ pRow()+2,01 pSay "________________________"
	@ pRow()  ,35 pSay "________________________"

	@ pRow()+1,01 pSay "RG. N.�:"
	@ pRow()  ,35 pSay "RG. N.�:"

	SRA->(DbSkip())
  
Enddo
If aReturn[5] == 1
	Set Printer To
	Commit
   ourspool(wnrel)
Endif
MS_FLUSH()
Return
