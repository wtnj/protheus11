/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE152  ºAutor  ³Marcos R Roquitski  º Data ³  18/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao da requisicao de pessoal.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#Include "FIVEWIN.Ch"

User Function Nhgpe152()
//Inicializa constante.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE titulo   := "Requisicao de Pessoal"
PRIVATE cPerg
PRIVATE cabec1, cabec2
PRIVATE cAlias
PRIVATE cDescr
PRIVATE cEmpPPP := SM0->M0_CODIGO
PRIVATE cTypeEnd
PRIVATE lNGMDTPS := .F.

Processa({|lEnd| R152Imp()}) // MONTE TELA PARA ACOMPANHAMENTO DO PROCESSO.

Return NIL
// 
Static Function R152Imp(lEnd,wnRel,titulo,tamanho)
Private oPrintPPP, _cRh, _cMed, _cDias
Private lin := 0,nPaginaPPP := 0
Private lin2 := 0
Private oFont06,oFont07,oFont08,oFont09,oFont09n,oFont08n,oFont10,oFont11,oFont12,oFont13,oFont14,oFont15,oFont10n,oFont20
oFont06 := TFont():New("Courier New",06,06,,.F.,,,,.F.,.F.)
oFont07 := TFont():New("Courier New",07,07,,.F.,,,,.F.,.F.)
oFont08 := TFont():New("Courier New",08,08,,.F.,,,,.F.,.F.)
oFont08n := TFont():New("Courier New",08,08,,.T.,,,,.F.,.F.)
oFont09 := TFont():New("Courier New",09,09,,.F.,,,,.F.,.F.)
oFont09n := TFont():New("Courier New",09,09,,.T.,,,,.F.,.F.)
oFont10 := TFont():New("Courier New",10,10,,.F.,,,,.F.,.F.)
oFont10n := TFont():New("Courier New",10,10,,.T.,,,,.F.,.F.)
oFont11 := TFont():New("Courier New",11,11,,.F.,,,,.F.,.F.)
oFont12 := TFont():New("Courier New",12,12,,.F.,,,,.F.,.F.)
oFont13 := TFont():New("Courier New",13,13,,.T.,,,,.F.,.F.)
oFont14 := TFont():New("Courier New",14,14,,.T.,,,,.F.,.F.)
oFont15 := TFont():New("Courier New",15,15,,.T.,,,,.F.,.F.)
oFont20 := TFont():New("Courier New",20,20,,.T.,,,,.F.,.F.)

oPrintPPP:= TMSPrinter():New(OemToAnsi("Perfil Profissiografico Previdenciario"))
oPrintPPP:Setup()

fGpe152() //Chamada da funcao que imprime

oPrintPPP:Preview()
// oPrintPPP:Print()

Return NIL   


//
Static Function fGpe152()
Local aHist := {}, aAUDIO := {},xx,i,LinhaCorrente,nInd
Private aNUMCAPS := {}
Private aFuncao := {}
Private aFichasUsa := {}
Private aCargoSv  := {}
Private aCargo  := {}
Private aMatriculas := {}
Private aRiscos := {}
Private aCat  := {}
Private lFindCLI := .f.
Private aAREASRA := SRA->(GetArea())
Private cCliFun := Space(6)


_cSta := ''
IF ZQS_STATUS==Space(01)
	_cSta := 'Em Analise'
 	
Elseif ZQS_STATUS== '1'
 	_cSta := 'Aprovado'

Elseif ZQS_STATUS== '2'
 	_cSta := 'Processo de selecao'

Elseif ZQS_STATUS== '3'
 	_cSta := 'Concluida'

Elseif ZQS_STATUS== '4'
 	_cSta := 'Cancelada'

Endif
     

lin := 20
oPrintPPP:StartPage()
/*
If File("\PROTHEUS_DATA\SYSTEM\WHB.BMP") //Imprime logotipo da previdencia social
	oPrintPPP:SayBitMap(lin,1000,"\PROTHEUS_DATA\SYSTEM\WHB.BMP",400,130)
Endif
lin := 180
*/


oPrintPPP:Say(lin+100,800,"*** HISTORICO DO PROCESSO DE SELECAO ***",oFont15)

oPrintPPP:Box(lin+200,50,lin+480,2350)

//PRIMEIRA PARTE
oPrintPPP:Line(lin+200,480,lin+480,480)
oPrintPPP:SayBitMap(lin+250,80,"\PROTHEUS_DATA\SYSTEM\WHBL.BMP",350,120)


oPrintPPP:Say(lin+220,500,"Numero  :",oFont13)
oPrintPPP:Say(lin+220,710,ZQS->ZQS_VAGA,oFont12)

oPrintPPP:Say(lin+300,500,"Status  :",oFont13)
oPrintPPP:Say(lin+300,710,_cSta,oFont12)

oPrintPPP:Say(lin+380,500,"Abertura:",oFont13) 
oPrintPPP:Say(lin+380,1000,"Fechamento:",oFont13)
oPrintPPP:Say(lin+380,1600,"Periodo:",oFont13)
oPrintPPP:Say(lin+380,710,Substr(Dtos(ZQS->ZQS_DTINC),7,2)+'/'+Substr(Dtos(ZQS->ZQS_DTINC),5,2)+'/'+Substr(Dtos(ZQS->ZQS_DTINC),1,4),oFont12)
oPrintPPP:Say(lin+380,1220,Substr(Dtos(ZQS->ZQS_DTFECH),7,2)+'/'+Substr(Dtos(ZQS->ZQS_DTFECH),5,2)+'/'+Substr(Dtos(ZQS->ZQS_DTFECH),1,4),oFont12)

IF ZQS->ZQS_DTINC==Ctod(Space(08))
	_cDias := Alltrim(Str(ZQS->ZQS_DTFECH - ZQS->ZQS_DTINC))+ ' Dias'
	
Else
	_cDias := Alltrim(Str(dDataBase - ZQS->ZQS_DTINC))+ ' Dias'

Endif

oPrintPPP:Say(lin+380,1800,_cDias,oFont12)



// Aumento de Quadro
lin := 380
oPrintPPP:Box(lin+120,50,lin+2800,2350)

oPrintPPP:Say(lin+140,200,"1-Numero de Vagas",oFont10)
oPrintPPP:Say(lin+140,1100,"2-Cargo Requisitado",oFont10)
oPrintPPP:Say(lin+140,2000,"3-Salario",oFont10)

oPrintPPP:Say(lin+180,290,StrZero(ZQS->ZQS_NRVAGA,2),oFont12)
oPrintPPP:Say(lin+180,1120,ZQS->ZQS_FUNCAO+'  '+ZQS->ZQS_DESCFU,oFont12)
oPrintPPP:Say(lin+180,2020,Transform(ZQS->ZQS_SALARI,'@E 999,999.99'),oFont12)

oPrintPPP:Line(lin+250,50,lin+250,2350) 

oPrintPPP:Say(lin+300,200,"4-Planta",oFont10)
oPrintPPP:Say(lin+300,1100,"5-Centro de custo setor",oFont10)
oPrintPPP:Say(lin+300,2000,"6-Horario",oFont10)

oPrintPPP:Say(lin+340,0210,IIF(SM0->M0_CODIGO=="NH","USINAGEM","FUNDICAO"),oFont12)
oPrintPPP:Say(lin+340,1120,ZQS->ZQS_CC+' '+ZQS->ZQS_DESCCC,oFont12)
oPrintPPP:Say(lin+340,2010,ZQS->ZQS_TURNO,oFont12)

oPrintPPP:Line(lin+400,50,lin+400,2350) 

oPrintPPP:Say(lin+450,200,"7-Responsavel direto da vaga",oFont10)
oPrintPPP:Say(lin+450,800,"8-Cargo",oFont10)
oPrintPPP:Say(lin+450,1450,"9-Ramal",oFont10)
oPrintPPP:Say(lin+450,1750,"10-Centro de Custo",oFont10)


oPrintPPP:Say(lin+490,0200,ZQS->ZQS_ONOME,oFont12)
oPrintPPP:Say(lin+490,0800,ZQS->ZQS_OFUNC+" "+ZQS->ZQS_OFUNDE,oFont12)
oPrintPPP:Say(lin+490,1450,ZQS->ZQS_ORAMAL,oFont12)
oPrintPPP:Say(lin+490,1750,ZQS->ZQS_OCC+" "+ZQS->ZQS_ODESCC,oFont12)
		
oPrintPPP:Line(lin+550,50,lin+550,2350) 
oPrintPPP:Say(lin+590,150,"11-Descricao da Vaga",oFont10)

lin += 650
nLinhasMemo := MLCOUNT(ZQS->ZQS_OBS2,100)
For i := 1 To nLinhasMemo
	oPrintPPP:Say(lin,100,MemoLine(ZQS->ZQS_OBS2,100,i),oFont12)
	lin += 40
Next
lin += 80

oPrintPPP:Line(lin,50,lin,2350) 
oPrintPPP:Say(lin+80,150,"12-Candidatos",oFont10)

lin += 80
ZQD->(DbSeek(xFilial("ZQD") + ZQS->ZQS_VAGA))
While !ZQD->(Eof()) .AND. ZQD->ZQD_VAGA == ZQS->ZQS_VAGA 

	oPrintPPP:Say(lin+80,200,"12.1-Nome:",oFont10)
	oPrintPPP:Say(lin+80,800,"12.2-Data Entrevista:",oFont10)
	oPrintPPP:Say(lin+80,1200,"12.3-Hora Entrevista:",oFont10)
	oPrintPPP:Say(lin+80,1600,"12.4-Status Rh:",oFont10)	


	_cRh := ''
	_cMed := ''
	If ZQD->ZQD_RH == '1'             
		_cRh := 'APROVADO  '
	Elseif ZQD->ZQD_RH == '2'
		_cRh := 'REPROVADO '
	Elseif ZQD->ZQD_RH == '3'
		_cRh := 'DESISTENTE'
	Elseif ZQD->ZQD_RH == '4'
		_cRh := 'AUSENTE   '
	Endif

	If ZQD->ZQD_MEDICA  == '1'
		_cMed := 'APTO  '
	Elseif ZQD->ZQD_MEDICA == '2'
		_cMed := 'NAO APTO '
	Endif
    
	oPrintPPP:Say(lin+120,200,ZQD->ZQD_NOME,oFont12)
	oPrintPPP:Say(lin+120,800,DTOC(ZQD->ZQD_DATA),oFont12)
	oPrintPPP:Say(lin+120,1200,ZQD->ZQD_HORA,oFont12)
	oPrintPPP:Say(lin+120,1600,_cRh,oFont12)		
	
	oPrintPPP:Say(lin+200,200,"12.5-Observacao:",oFont10)

	lin := lin + 250
	nLinhasMemo := MLCOUNT(ZQD->ZQD_OBS,100)
	For i := 1 To nLinhasMemo
		oPrintPPP:Say(lin,100,MemoLine(ZQD->ZQD_OBS,100,i),oFont12)
		lin += 40

		If lin > 2500
			oPrintPPP:EndPage()
			oPrintPPP:StartPage()
			lin := 20
		Endif	

        /*
		If Lin > 2500
			oPrintPPP:EndPage()
			oPrintPPP:StartPage()
		endif	
		*/

	Next

	oPrintPPP:Line(lin+50,50,lin+50,2350) 
	lin += 50
	ZQD->(DbSkip())
	
Enddo	



/*
oPrintPPP:Say(lin+520,200,"Justificativa da Contratacao",oFont10)
oPrintPPP:Box(lin+560,200,lin+660,2320)
oPrintPPP:Say(lin+580,210,ZQS->ZQS_OBS1,oFont12)

// Funcionario a ser Substituido
oPrintPPP:Box(lin+750,50,lin+1570,2350)
oPrintPPP:Line(lin+750,170,lin+1570,170) 

oPrintPPP:Say(lin+760,200,"Funcionario a ser substituido",oFont10) 
oPrintPPP:Say(lin+760,1700,"Matricula",oFont10)
oPrintPPP:Say(lin+760,2000,"Salario",oFont10)

oPrintPPP:Box(lin+800,200,lin+900,1600)
oPrintPPP:Box(lin+800,1700,lin+900,1900)
oPrintPPP:Box(lin+800,2000,lin+900,2320)

oPrintPPP:Say(lin+840,220,ZQS->ZQS_SFUNOM,oFont12) 
oPrintPPP:Say(lin+840,1715,ZQS->ZQS_SMAT,oFont12)
oPrintPPP:Say(lin+840,2040,Transform(ZQS->ZQS_SSAL,'@E 999,999.99'),oFont12)

oPrintPPP:Say(lin+960,200,"Cargo",oFont10)
oPrintPPP:Say(lin+960,1300,"Setor",oFont10)
oPrintPPP:Say(lin+960,2000,"Centro de Custo",oFont10)

oPrintPPP:Box(lin+1000,200,lin+1100,1200)
oPrintPPP:Box(lin+1000,1300,lin+1100,1900)
oPrintPPP:Box(lin+1000,2000,lin+1100,2320)

oPrintPPP:Say(lin+1040,220,ZQS->ZQS_SFUNC+' '+ZQS->ZQS_SFUNDE,oFont12)

oPrintPPP:Say(lin+1160,200,"Motivo da substituicao",oFont10)
oPrintPPP:Say(lin+1160,1300,"Turno",oFont10)
oPrintPPP:Say(lin+1160,2000,"Data demissao",oFont10)

oPrintPPP:Box(lin+1200,200,lin+1300,1200)
oPrintPPP:Box(lin+1200,1300,lin+1300,1900)
oPrintPPP:Box(lin+1200,2000,lin+1300,2320)

oPrintPPP:Say(lin+1240,220,ZQS->ZQS_SMOTSU,oFont12)
oPrintPPP:Say(lin+1240,1320,ZQS->ZQS_STURNO,oFont12)
oPrintPPP:Say(lin+1240,2020,Substr(Dtos(ZQS->ZQS_SDEMIS),7,2)+'/'+Substr(Dtos(ZQS->ZQS_SDEMIS),5,2)+'/'+Substr(Dtos(ZQS->ZQS_SDEMIS),1,4),oFont12)

oPrintPPP:Say(lin+1360,200,"Comentarios",oFont10)
oPrintPPP:Box(lin+1400,200,lin+1500,2320)
oPrintPPP:Say(lin+1440,220,ZQS->ZQS_SCOMEN,oFont12)

oPrintPPP:Box(lin+1570,50,lin+2000,2350)
oPrintPPP:Line(lin+1570,170,lin+2000,170) 

oPrintPPP:Say(lin+1600,200,"Responsavel direto da vaga",oFont10)
oPrintPPP:Say(lin+1600,1700,"Matricula",oFont10)
oPrintPPP:Say(lin+1600,2000,"Ramal",oFont10)

oPrintPPP:Box(lin+1640,200,lin+1740,1500)
oPrintPPP:Box(lin+1640,1700,lin+1740,1900)
oPrintPPP:Box(lin+1640,2000,lin+1740,2320)

oPrintPPP:Say(lin+1680,0220,ZQS->ZQS_ONOME,oFont12)
oPrintPPP:Say(lin+1680,1710,ZQS->ZQS_OMAT,oFont12)
oPrintPPP:Say(lin+1680,2010,ZQS->ZQS_ORAMAL,oFont12)

oPrintPPP:Say(lin+1800,200,"Cargo",oFont10)
oPrintPPP:Say(lin+1800,1550,"Centro de Custo",oFont10)
oPrintPPP:Box(lin+1840,200,lin+1940,1500)
oPrintPPP:Box(lin+1840,1550,lin+1940,2320)

oPrintPPP:Say(lin+1880,0220,ZQS->ZQS_OFUNC+" "+ZQS->ZQS_OFUNDE,oFont12)
oPrintPPP:Say(lin+1880,1560,ZQS->ZQS_OCC+" "+ZQS->ZQS_ODESCC,oFont12)


oPrintPPP:Box(lin+2000,50,lin+2950,2350)
oPrintPPP:Line(lin+2000,170,lin+2950,170) 

oPrintPPP:Say(lin+2030,200,"Cargo",oFont10)
oPrintPPP:Say(lin+2030,1400,"Horario",oFont10)
oPrintPPP:Say(lin+2030,2000,"Salario",oFont10)

oPrintPPP:Box(lin+2080,200,lin+2160,1350)
oPrintPPP:Box(lin+2080,1400,lin+2160,1900)
oPrintPPP:Box(lin+2080,2000,lin+2160,2320)

oPrintPPP:Say(lin+2200,200,"Candidato aprovado",oFont10)
oPrintPPP:Say(lin+2200,1400,"Admissao",oFont10)
oPrintPPP:Say(lin+2200,2000,"Centro de Custo",oFont10)

oPrintPPP:Box(lin+2250,200,lin+2330,1350)
oPrintPPP:Box(lin+2250,1400,lin+2330,1900)
oPrintPPP:Box(lin+2250,2000,lin+2330,2320)

oPrintPPP:Say(lin+2370,200,"Nivel",oFont10)
oPrintPPP:Say(lin+2370,700,"Recrutamento",oFont10)
oPrintPPP:Say(lin+2370,1100,"No. da MPE",oFont10)
oPrintPPP:Say(lin+2370,1500,"Agencia recrutadora",oFont10)

oPrintPPP:Box(lin+2420,200,lin+2500,600)
oPrintPPP:Box(lin+2420,700,lin+2500,1000)
oPrintPPP:Box(lin+2420,1100,lin+2500,1400)
oPrintPPP:Box(lin+2420,1500,lin+2500,2320)

oPrintPPP:Box(lin+2570,050,lin+2570,2350)
			
oPrintPPP:Say(lin+2660,0200,"Resp. Remuneracao:",oFont10)
oPrintPPP:Say(lin+2660,0800,"Gerencia:",oFont10)
oPrintPPP:Say(lin+2660,1370,"Diretoria:",oFont10)
oPrintPPP:Say(lin+2660,1900,"Presidencia:",oFont10)

oPrintPPP:Say(lin+2780,0200,"Ass:__________________",oFont10)
oPrintPPP:Say(lin+2780,0800,"Ass:__________________",oFont10)
oPrintPPP:Say(lin+2780,1370,"Ass:__________________",oFont10)
oPrintPPP:Say(lin+2780,1900,"Ass:_________________",oFont10)

oPrintPPP:Say(lin+2880,0200,"Data: _____/_____/_____",oFont10)
oPrintPPP:Say(lin+2880,0800,"Data: _____/_____/_____",oFont10)
oPrintPPP:Say(lin+2880,1370,"Data: _____/_____/_____",oFont10)
oPrintPPP:Say(lin+2880,1900,"Data: ____/____/_____",oFont10)
*/

oPrintPPP:EndPage()
nPaginaPPP++

Return
