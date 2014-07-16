/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE233  ºAutor  ³Marcos R. Roquitski º Data ³  25/03/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Contrato de Trabalho a Titulo de Experiencia.              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ITESAPAR                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhgpe233()

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("M_PAG,NOMEPROG,CPERG,_NVIAS,_CCATEG,I")

cSavCur1  := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""
cabec1    := "";cabec2:="";cabec3:="";wnrel:=""
nOrdem    := 0
tamanho   := "P"
limite    := 132
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "Contrato de Experiencia a Titulo de Experiencia"
cDesc1    := ""
cDesc2    := ""
cDesc3    := ""
cString   := "SRA"
nTipo     := 0
m_pag     := 1
nomeprog  := 'RHGP07'
cPerg     := 'RHGP07'
_nVias    := 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte('RHGP07',.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "NHGPE233"
wnRel := SetPrint(cString,wnrel,cperg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

RptStatus({|| _fIt233()})

Return Nil


Static Function _fIt233()

DbSelectArea("SRA")
DbSetOrder(01)

DbSelectArea("SRJ")
DbSetOrder(01)

DbSelectArea("SR6")
DbSetOrder(01)

SRA->(DbGoTop())
SRA->(SetRegua(RecCount()))

_cRjDesc := Space(30)

SRA->(DbSeek(mv_par01+mv_par03,.T.))
While SRA->(!Eof()) .and. SRA->RA_FILIAL>=mv_par01 .and. SRA->RA_FILIAL<=mv_par02 .and. SRA->RA_MAT>=mv_par03 .and. SRA->RA_MAT<=mv_par04
   If SRJ->(DbSeek(xFilial()+SRA->RA_CODFUNC))
		_cRjDesc := SRJ->RJ_DESC
   Endif		   	
   
   If SRA->RA_CATFUNC=="H"
      _cCateg:="POR HORA."
   ElseIf SRA->RA_CATFUNC=="M"   
      _cCateg:="POR MES ."
   EndIf   
   IncRegua()

   For i:=1 to _nVias
      @ 1, 28 pSay "* * " + Alltrim(SM0->M0_NOMECOM) + " * *"

      @ pRow()+2, 20 pSay "CONTRATO DE TRABALHO A TÍTULO DE EXPERIÊNCIA"

      @ pRow()+3, 01 pSay "EMPREGADORA   : " + Alltrim(SM0->M0_NOMECOM) 
	  @ pRow()+1, 01 pSay "CNPJ          : " + TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99") 
	  @ pRow()+1, 01 pSay "ENDERECO      : " + SM0->M0_ENDENT  
      @ pRow()+1, 01 pSay "BAIRRO        : " + SM0->M0_BAIRENT + "CIDADE: PALMEIRA UF: PR" 

	  @ pRow()+2, 01 pSay "EMPREGADO     : " + SRA->RA_NOMECMP 
      @ pRow()+1, 01 pSay "CTPS NR       : " + SRA->RA_NUMCP + "SERIE: "+SRA->RA_SERCP + "UF: "+SRA->RA_UFCP
	  @ pRow()+2, 01 pSay "FUNCAO        : " + SRA->RA_CODFUNC + "  " + _cRjDesc
	  @ pRow()+1, 01 pSay "VIGÊNCIA      : 45 DIAS " + "Periodo: " + DTOC(SRA->RA_ADMISSA) + " a " + DTOC(SRA->RA_ADMISSA + 45)
	  @ pRow()+1, 01 pSay "REMUNERAÇÃO   : R$ " + TRANSFORM(SRA->RA_SALARIO,"@E 999,999.99") + " POR: MES"
	  @ pRow()+1, 01 pSay "HORAS         : 44,00  SEMANAL"
   
      @ pRow()+2, 01 pSay "CONTRATO DE TRABALHO A TÍTULO DE EXPERIÊNCIA"

      @ pRow()+2, 01 pSay "Pelo  presente  instrumento  particular  de  contrato de experiência, a  empresa" 
      @ pRow()+1, 01 pSay "ITESAPAR LTDA. pessoa  jurídica  de  direito privado, com  sede  na   Rua  Padre" 
      @ pRow()+1, 01 pSay "Anchieta, nº. 112, Vila Vida, na  cidade  de  Palmeira,   Estado    do   Paraná,"  
      @ pRow()+1, 01 pSay "inscrita  no  CNPJ/MF sob nº. " + TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99") + " doravante denominada"
      @ pRow()+1, 01 pSay "EMPREGADORA, e de outro doravante denominado simplesmente de EMPREGADO(A)" 

      @ pRow()+2, 01 pSay "Resolvem  celebrar  o presente vccontrato  individual   de trabalho para fins de"
      @ pRow()+1, 01 pSay "experiência,  que  conforme  legislação trabalhista em  vigor terá a vigência de"
      @ pRow()+1, 01 pSay "45 dias  podendo  prorrogar-se  por  mais  45  dias,  conforme   pactuado  entre" 
      @ pRow()+1, 01 pSay "as  partes  nas condições a seguir especificadas: "
	 
      @ pRow()+2, 01 pSay "1.1.  Fica  o  (a)  EMPREGADO  (A)  admitido (a)   no  quadro  de  empregados da"
      @ pRow()+1, 01 pSay "EMPREGADORA para exercer a função e remuneração mensal  citado  neste  contrato."
	 
      @ pRow()+2, 01 pSay "1.2.  Fica  ajustado nos termos do que dispõe o parágrafo  1º do Artigo  469, da"
      @ pRow()+1, 01 pSay "CLT, que o(a)EMPREGADO(A)  aceitará   ordem  emanada  da  EMPREGADORA,   para  a"
      @ pRow()+1, 01 pSay "prestação  de  serviços  tanto  na  localidade  da   celebração   do Contrato de"
      @ pRow()+1, 01 pSay "Trabalho, como  em  qualquer  outra cidade ou vila do Território  Nacional, quer"
      @ pRow()+1, 01 pSay "essa transferência seja transitória ou definitiva. 
	 
      @ pRow()+2, 01 pSay "1.3.  O  empregado cumprirá  o  horário de trabalho estabelecibo neste  contrato"
      @ pRow()+1, 01 pSay "com intervalo de  01h00min  para descanso e refeição, com jornada de 220   horas"
      @ pRow()+1, 01 pSay "mensais.  Eventual  redução  da jornada,  por  determinação da EMPREGADORA,  não"
      @ pRow()+1, 01 pSay "inovará  este  ajuste, permanecendo sempre integra a obrigação do (a)  EMPREGADO"
      @ pRow()+1, 01 pSay "(A) de cumprir o horário que lhe for determinado,observando o limite legal."


      @ pRow()+2, 01 pSay "1.4.  Não obstante a jornada pré-fixado, o(a) EMPREGADO(A) aceita, expressamente"
      @ pRow()+1, 01 pSay "a condição	de  prestar serviços, quando  necessário, em  qualquer  dos turnos de"
      @ pRow()+1, 01 pSay "trabalho, isto é tanto durante o dia como a noite, desde que sem simultaneidade,"
      @ pRow()+1, 01 pSay "observadas os preceitos legais	reguladores do assunto."
	 
      @ pRow()+2, 01 pSay "1.5.  A  prestação  do  serviço é inerente ao contrato de trabalho, portanto não"
      @ pRow()+1, 01 pSay "poderá o(a) EMPREGADO(A) transferir  a  responsabilidade  da  sua execução, para"
      @ pRow()+1, 01 pSay "outrem que não esteja previamente contratado."
	 
      @ pRow()+2, 01 pSay "1.6.  No  ato  da  assinatura  deste contrato, o(a) EMPREGADO(A), recebe  e toma"
      @ pRow()+1, 01 pSay "conhecimento  do  Regulamento  Interno da Empresa, cujas as cláusulas integram o"
      @ pRow()+1, 01 pSay "presente  contrato de  trabalho, sendo  que  a  violação  de  quaisquer  de suas"
      @ pRow()+1, 01 pSay "cláusulas implicará  em  sanções, cuja graduação dependerá  da  gravidade do ato"
      @ pRow()+1, 01 pSay "praticado, podendo ocasionar até mesmo a rescisão do contrato."
	
	 
      @ pRow()+2, 01 pSay "1.7.  O(a)  EMPREGADO(A)  fica  ciente  das Normas de Segurança que regulam suas"
      @ pRow()+1, 01 pSay "atividades na EMPREGADORA  e  se compromete  a usar os equipamentos de segurança"
      @ pRow()+1, 01 pSay "fornecidos, sob pena de ser punido  por  falta  grave, nos termos da  legislação"
      @ pRow()+1, 01 pSay "vigente e demais disposições inerentes á segurança e medicina do trabalho."

      @ 01,01 pSay ''	  				 	 
      @ pRow()+2, 01 pSay "1.8.  Em  caso  de  danos  ou  prejuízos  causados pelo  (a)  EMPREGADO(A), fica" 
      @ pRow()+1, 01 pSay "a EMPREGADORA autorizada a efetivar o desconto da  importância correspondente ao"
      @ pRow()+1, 01 pSay "prejuízo o qual fará com fundamento no parágrafo  primeiro do artigo 462 da CLT." 

      @ pRow()+2, 01 pSay "1.9.  Obriga-se o (a) EMPREGADO(A)  a executar com  dedicação e responsabilidade"
      @ pRow()+1, 01 pSay "suas funções obedecendo ao Regulamento Interno  da EMPREGADORA, as instruções de"
      @ pRow()+1, 01 pSay "sua  administração  e  as  ordens de  seus  chefes  e  superiores  hierárquicos,"
      @ pRow()+1, 01 pSay "relativas às peculiaridades dos serviços que lhe foram confiados. 
	 
      @ pRow()+2, 01 pSay "1.10.  É  vedado  ao  EMPREGADO,  sob  as  penas  da lei,  prestar informações a"
      @ pRow()+1, 01 pSay "terceiros sobre a natureza  ou  andamento dos serviços da  EMPREGADORA, bem como"
      @ pRow()+1, 01 pSay "divulgar, por quaisquer meio de comunicação, dados e/ou  informes relativos  aos"
      @ pRow()+1, 01 pSay "serviços executados à tecnologia adotada e/ou à  documentação técnica envolvida,"
      @ pRow()+1, 01 pSay "salvo  expressa  autorização  escrita  da  EMPREGADORA."

	 
      @ pRow()+2, 01 pSay "1.11.  O  presente contrato terá  a vigência de  45 ( quarenta e cinco )   dias,"
      @ pRow()+1, 01 pSay "podendo prorrogar-se por  mais 45 (quarenta e cinco ) dias caso as partes  assim"
      @ pRow()+1, 01 pSay "desejem."

	 
      @ pRow()+2, 01 pSay "1.12.  Terminando o prazo de 45 (trinta) dias e não havendo nenhuma manifestação"
      @ pRow()+1, 01 pSay "das  partes  ou  fato impeditivo  para a sua prorrogação, o presente contrato de"
      @ pRow()+1, 01 pSay "experiência será automaticamente prorrogado por mais 45 (quarenta e cinco) dias." 
	 

      @ pRow()+2, 01 pSay "1.13. Na  hipótese  deste  ajuste, vencido  o  período  experimental  o presente"
      @ pRow()+1, 01 pSay "contrato  transformar-se-á  em  Contrato  de  Trabalho  por prazo indeterminado,"
      @ pRow()+1, 01 pSay "ficando  prorrogadas   todas  as cláusulas  aqui  estabelecidas enquanto não  se"
      @ pRow()+1, 01 pSay "rescindir o contrato de trabalho." 
	 
      @ pRow()+1, 01 pSay "1.14.  Opera-se  a  rescisão  do  presente Contrato pela decorrência do tempo ou"
      @ pRow()+1, 01 pSay "por vontade de	uma das partes. Rescindindo-se  o  presente  antes  do    prazo"
      @ pRow()+1, 01 pSay "estipulado, fica a parte que tomou a iniciativa  obrigada a pagar a  indenização"
      @ pRow()+1, 01 pSay "a que se refere os artigos 479 e 480 da CLT, sem prejuízo do  disposto  no  Reg."
      @ pRow()+1, 01 pSay "do FGTS, sendo que nenhum aviso prévio será devido pela rescisão do contrato."
	 
      @ pRow()+1, 01 pSay "1.15.  E  por estarem de pleno acordo, as partes contratantes assinam o presente"
      @ pRow()+1, 01 pSay "contrato  de  experiência  em   duas   vias,   ficando  a  primeira  em poder da"
      @ pRow()+1, 01 pSay "EMPREGADORA e a segunda com o(a) EMPREGADO(A), que dela dará competente recibo."
	
      @ pRow()+3, 01 pSay "Palmeira, "+Alltrim(Str(DAY(SRA->RA_ADMISSA))) + " de " + MesExtenso(MONTH(SRA->rA_ADMISSA)) + " de " + Alltrim(Str(Year(SRA->RA_ADMISSA)))

      @ pRow()+4, 01 pSay "EMPREGADOR"
      @ pRow()  , 41 pSay "EMPREGADO"

      @ pRow()+4, 01 pSay "TESTEMUNHAS"
      @ pRow()  , 41 pSay "TESTEMUNHAS"
    
    
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
