#include "RwMake.ch"
#include "RGPER09.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRGPER09   บAutor  ณSilvia Taguti       บ Data ณ  16/06/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณHace la impresion de Informe de 13 Salario                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION RGPER09()

Local cString := "SRA"  // alias do arquivo principal (Base)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis Private(Basicas)                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private NomeProg := "RGPER09"
Private cPerg    := "RGPR09"
Private Titulo
Private aCodFol:= {}
Private cPict1	:= TM(9999999999,16,MsDecimais(1))
Private cPict2	:= PesqPict("SRC","RC_HORAS",10)

pergunte("RGPR09",.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros                         ณ
//ณ mv_par01        //  Filial De                                ณ
//ณ mv_par02        //  Filial Ate                               ณ
//ณ mv_par03        //  Centro de Custo De                       ณ
//ณ mv_par04        //  Centro de Custo Ate                      ณ
//ณ mv_par05        //  Matricula De                             ณ
//ณ mv_par06        //  Matricula Ate                            ณ
//ณ mv_par07        //  Nome De                                  ณ
//ณ mv_par08        //  Nome Ate                                 ณ
//ณ mv_par09        //  Chapa De                                 ณ
//ณ mv_par10        //  Chapa Ate                                ณ
//ณ mv_par11        //  Categorias                               ณ
//ณ mv_par12        //  Situaไes                                ณ
//| mv_par13		  //  Data de Referencia							  |
//| mv_par14		  //  Nivel de Centro de Custo			        |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel:="RGPER09"            //Nome Default do relatorio em Disco

RptStatus({|lEnd| GPR09Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGR09IMP   บAutor  ณSilvia Taguti       บ Data ณ  04/07/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio                                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GPR09IMP(lEnd,WnRel,cString)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis Locais (Programa)                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aInfo	 	:= {}
Local nSubTot := 0              
Local aOrdBag     := {}
Local cArqMov     := ""
Local cAnoMes   
Local cMesAnoRef 
Local dChkDtRef
Local cDataREf  
Local cMapa       := 0
Local nLaco       := nByte := 0

Private cMascCus  := GetMv("MV_MASCCUS")
Private aNiveis   := {}
Private cMatr
Private cNome
Private cFPag
Private nSalMes  := 0
Private nSalAno  := 0
Private aDescFil := {}
Private nLinDet   := 2400
Private nQtdEmpl := 0
Private oPrn := TMSPrinter():New()
Private aFunc 	 := {0,0,0}
Private aSubTot := {0,0,0}
Private aSubCc  := {0,0,0}
Private aTotal  := {0,0,0}
Private cAliasMov     := ""
Private nPag	:= 0
Private lFirst := .T.
Private dDtAdmissa:= ctod("  /  /  ")          
Private nMesesTrab := 0
Private nDiasTrab  := 0
Private nBase13 := 0
Private nCont13 := 0
// Crea los objetos con las configuraciones de fuentes
oFont07  := TFont():New( "Times New Roman",,07,,.f.,,,,,.f. )
oFont08  := TFont():New( "Times New Roman",,08,,.f.,,,,,.f. )
oFont08b := TFont():New( "Times New Roman",,08,,.t.,,,,,.f. )
oFont09b := TFont():New( "Times New Roman",,09,,.t.,,,,,.f. )
oFont10b := TFont():New( "Times New Roman",,10,,.t.,,,,,.f. )
oFont12  := TFont():New( "Times New Roman",,12,,.f.,,,,,.f. )
oFont12b := TFont():New( "Times New Roman",,12,,.t.,,,,,.f. )
oFont14  := TFont():New( "Times New Roman",,14,,.f.,,,,,.f. )
oFont14b := TFont():New( "Times New Roman",,14,,.t.,,,,,.f. )
oFont16  := TFont():New( "Times New Roman",,16,,.f.,,,,,.f. )
oFont19b := TFont():New( "Times New Roman",,19,,.t.,,,,,.f. )

cFilDe     := mv_par01
cFilAte    := mv_par02
cCcDe      := mv_par03
cCcAte     := mv_par04
cMatDe     := mv_par05
cMatAte    := mv_par06
cNomeDe    := mv_par07
cNomeAte   := mv_par08
cChapaDe   := mv_par09
cChapaAte  := mv_par10
cCategoria := mv_par11
cSituacao  := mv_par12									//  Situacao Funcionario
dData13    := mv_par13        //  Data Referencia                          
lImpNiv  := If(mv_par14 == 1,.T.,.F.)

nOrdem := 2
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ aNiveis -  Armazena as chaves de quebra.                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lImpNiv
	cMapa := 0
	For nLaco := 1 to 1            //Len( cMascCus )
		nByte := Val( SubStr( cMascCus , nLaco , 1 ) )
		cMapa += nByte
		If nByte > 0
			Aadd( aNiveis, cMapa )
		Endif
	Next
	
	//--Criar os Arrays com os Niveis de Quebras
	For nQ = 1 to Len(aNiveis)
		cQ := STR(NQ,1)
		cCcAnt&cQ       := ""    //Variaveis c.custo dos niveis de quebra
	Next nQ
Endif

dbSelectArea( "SRA" )
dbSetOrder( 2 )
dbGoTop()

If nOrdem == 1
	dbSeek(cFilDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim    := cFilAte + cMatAte
ElseIf nOrdem == 2
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim    := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 3
	DbSeek(cFilDe + cNomeDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim    := cFilAte + cNomeAte + cMatAte
Endif

dbSelectArea( "SRA" )
SetRegua(SRA->(RecCount()))

cFilialAnt := "  "
cFuncaoAnt := "    "
cCcAnt     := Space(9)
cMatAnt    := Space(6)
cAnoMes    := AnoMes(dData13)
cMesAnoRef := "13" + Str(Year(dData13),4)	
dChkDtRef   := CTOD("01/"+Right(cAnoMes,2)+"/"+Left(cAnoMes,4),"DDMMYY")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Verifica se existe o arquivo de fechamento do mes informado  |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !OpenSrc( cMesAnoRef, @cAliasMov, @aOrdBag, @cArqMov, dChkDtRef)
	Return .f.
Endif

dbSelectArea("SRA")

While !EOF() .And. &cInicio <= cFim .And.(SRA->RA_FILIAL+SRA->RA_MAT <> cFilialAnt+cMatAnt)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Movimenta Regua Processamento                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
  	IncRegua()  // Anda a regua
   If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Consiste Parametrizacao do Intervalo de Impressao            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If (SRA->RA_CHAPA < cChapaDe).Or. (SRA->Ra_CHAPa > cChapaAte).Or. ;
	   (SRA->RA_NOME < cNomeDe)  .Or. (SRA->Ra_NOME > cNomeAte)  .Or. ;
	   (SRA->RA_MAT < cMatDe)    .Or. (SRA->Ra_MAT > cMatAte)    .Or. ;
	   (SRA->RA_CC < cCcDe)      .Or. (SRA->Ra_CC > cCcAte)
		SRA->(dbSkip(1))
		Loop
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Testa Situacao do Funcionario na Folha						 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !( SRA->RA_SITFOLH $ cSituacao ) .Or. !( SRA->RA_CATFUNC $ cCategoria )
		dbSkip()
		Loop
	EndIf

	
	If SRA->RA_FILIAL # cFilialAnt
		If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial)
	       Exit
	   Endif
    	If ! fInfo(@aInfo,SRA->RA_FILIAL)
			Exit
		Endif
	   dbSelectArea( "SRA" )
	   cFilialAnt := SRA->RA_FILIAL
	Endif
  
   cMatr		 := SRA->RA_MAT
	cNome     := SRA->RA_NOME
 	cFPag 	:= Substr(DescFun(Sra->Ra_Codfunc,Sra->Ra_Filial),1,15)

	If SRA->RA_CATFUNC == "M"
		nSalMes  := SRA->RA_SALARIO
		nSalDia  := SRA->RA_SALARIO / (SRA->RA_HRSMES/SRA->RA_HRSDIA)
	ElseIf SRA->RA_CATFUNC $ "H*T*G"
		nSalMes  := SRA->RA_SALARIO * SRA->RA_HRSMES
		nSalDia  := ( SRA->RA_SALARIO * SRA->RA_HRSDIA)
	ElseIf SRA->RA_CATFUNC $ "D"
		nSalMes  := ( SRA->RA_SALARIO * (SRA->RA_HRSMES/SRA->RA_HRSDIA) )
		nSalDia  := SRA->RA_SALARIO
	Endif
  	nSalAno := nSalMes * 12	
   dDtAdmissa := SRA->RA_ADMISSA

	nMesesTrab:= Int((dData13 - SRA->RA_ADMISSA) / 30)
	nDiasTrab := dData13 - SRA->RA_ADMISSA
	If nMesesTrab > 12
		nMesesTrab:= 12.0
	Else	
		nMesesTrab += (nDiasTrab-(nMesesTrab * 30))/100
   Endif
	
	dbSelectArea( "SRI" )
	dbSetOrder(2)
	If dbSeek( SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT ) 
		While !Eof() .And. SRI->RI_FILIAL + SRI->RI_CC + SRI->RI_MAT == SRA->RA_FILIAL+SRA->RA_CC+SRA->RA_MAT
			If PosSrv(SRI->RI_PD,SRI->RI_FILIAL,"RV_TIPOCOD") == "1"
				If SRI->RI_PD == aCodFol[024,1] 									//Regalia
					aFunc[01] := SRI->RI_VALOR             			
            Endif
			Endif
			dbSelectArea("SRI")
			dbSkip()
		Enddo
	Endif	
	If aFunc[01] <> 0 
	   TotGanado(@nBase13,@nCont13)
	   aFunc[02] := nBase13										//Total Recebido no Ano 
	   If nMesesTrab < 12
	   	aFunc[03] := nBase13 /(nCont13/If(SRA->RA_TIPOPGT=="S",2,1))					//Sueldo Promedio
		Else
	   	aFunc[03] := nBase13 /12 							//Sueldo Promedio
		Endif
		GperImp()
	Endif
	dbSelectArea("SRA")
	dbSkip()
Enddo
nSubTot := 0
For Nx:=1 to Len(aSubTot)
 	nSubTot+= aSubTot[nX]
Next	
If nSubTot <> 0
	GperSub()
	GperCc()
Endif	
GperTot()

dbSelectArea("SRI")
dbSetOrder(1)          // Retorno a ordem 1
dbSelectArea("SRA")
dbSetOrder(1)          // Retorno a ordem 1

// Cerra la pagina
oPrn:EndPage()
// Mostra la pentalla de Setup
oPrn:Setup()
// Mostra la pentalla de preview
oPrn:Preview()

MS_FLUSH()


Return Nil

Return	   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTotGanado บAutor  ณSilvia Taguti       บ Data ณ  04/07/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calcula o Total recebido pelo funcionario para a media     บฑฑ
ฑฑบ          ณ do 13 salario                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                                   
Static Function TotGanado(nBaseSal,nCont)
             
Local cMesAnt	:=	""
Local nContSem := 0

nBaseSal		:=	0
nCont := 0
dbSelectArea( "SRD" )
dbSetOrder(1)
dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + Strzero(Year(dData13),4) + "01", .T. )
While !Eof() .And. SRD->RD_FILIAL + SRD->RD_MAT == SRA->RA_FILIAL + SRA->RA_MAT .And. Substr(SRD->RD_DATARQ,1,4) == Strzero(Year(dData13),4)
	If SRD->RD_PD == aCodFol[318,1]         //Calcula o promedio pelo salario base
		nBaseSal		+=	 SRD->RD_VALOR
		nCont++
	Endif
	dbSkip()
Enddo
DbSkip(-1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCaso o mes de dezembro ainda nao esteja fechadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If SRD->RD_DATARQ <> Strzero(Year(dData13),4)+"12"
	SRC->(DbSetOrder(1))
	SRC->(DbSeek(xFilial()+SRA->RA_MAT ))
	While !SRC->(Eof()) .And. SRC->RC_FILIAL + SRC->RC_MAT == SRA->RA_FILIAL + SRA->RA_MAT;
		.And. Year(SRC->RC_DATA) == Year(dData13)
		If SRC->RC_PD == aCodFol[318,1]
			nBaseSal		+=	 SRC->RC_VALOR
			nContSem += 1
		Endif
		SRC->(dbSkip())
	Enddo
	If nContSem = 0
		nBaseSal += nSalMes
	ElseIf nContSem =1
		nBaseSal += nSalMes /2
	Endif
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGperImp   บAutor  ณSilvia Taguti       บ Data ณ  07/04/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImprime Relatorio                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GperImp()

Local nX, nY,  nTamLin
Local nSubTot := 0
// Crea un nuevo objeto para impresion
oPrn:SetLandscape()
// Imprime la inicializacon de la impresora
//oPrn:Say(20,20," ",oFont12,100)
If nLinDet > 2300 
	// Cerra la pagina
	oPrn:EndPage()
 	oPrn:StartPage()
	Cabec()
Endif

If SRA->RA_CC <> cCcAnt                   // Centro de Custo
   For Nx:=1 to Len(aSubTot)
   	nSubTot+= aSubTot[nX]
   Next	
   If !lFirst
	   GperSub()
		For nQ := Len(aNiveis) to 1 Step -1           //Imprime Niveis de Centro de custo
			cQ := Str(nQ,1)
			If Subs(SRA->RA_CC,1,aNiveis[nQ]) # cCcAnt&cQ 
				GperCC()
			Endif		        
		Next nQ
	Endif
	lFirst := .F.
	oPrn:Say(nLinDet,200,SRA->RA_CC+ " - " +DescCc(SRA->RA_CC,SRA->RA_FILIAL),oFont09b,50)  //Centro de Custo
	cCcAnt := SRA->RA_CC
	If lImpNiv .And. Len(aNiveis) > 0
		For nQ = 1 TO Len(aNiveis)
			cQ        := Str(nQ,1)
			cCcAnt&cQ := Subs(cCcAnt,1,aNiveis[nQ])
		Next nQ
	Endif
Endif       

oPrn:Say(nLinDet+=50,200,cMatr,oFont07,50)
oPrn:Say(nLinDet,360,cNome,oFont07,50)
oPrn:Say(nLinDet,0900,cFPag,oFont07,50)                      //cargo
oPrn:Say(nLinDet,1230,dtoc(dDtAdmissa),oFont07,50)           //Admissao
oPrn:Say(nLinDet,1360,Transform(nMesesTrab,cPict1),oFont07,50)  //MES
oPrn:Say(nLinDet,1540,Transform(nSalMes,cPict1),oFont07,50) // SALARIO   
oPrn:Say(nLinDet,1800,Transform(aFunc[02],cPict1),oFont07,50) // TOTAL GANADO   
oPrn:Say(nLinDet,2100,Transform(aFunc[03],cPict1),oFont07,50) // SUELDO PROMEDIO 
oPrn:Say(nLinDet,2440,Transform(aFunc[01],cPict1),oFont07,50) // REGALIA        
oPrn:Say(nLinDet,2700,REPLICATE('_',20),oFont07,50) // ______________

For nX := 1 to Len(aFunc)
	aSubTot[nX]+= aFunc[nX]
	aTotal[nX] += aFunc[nX]
	aSubCC[nX] += aFunc[nX]
Next	
nQtdEmpl += 1
aFunc := {0,0,0}

Return
               
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCABEC     บAutor  ณSilvia Taguti       บ Data ณ  07/07/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCabecalho do Relatorio                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cabec()

Local nTamLin                         
Local cDtCabec

nLinDet := 100
nPag+=1 
cDtCabec := StrZero(Day(dData13),2)+OemToAnsi(STR0004)+MesExtenso(Month(dData13))+OemToAnsi(STR0015)+Str(Year(dData13),4)

oPrn:Say(100,2900,OemToAnsi(STR0016)+StrZero(nPag,5),oFont08,50) // pagina
// Empeza la impresion del cabezallo
oPrn:Say(nLinDet,1200,OemToAnsi(STR0001),oFont19b,100)   // Corp.Avic.y Gan,Jarabacoa,
oPrn:Say(nLinDet+=080,1370,OemToAnsi(STR0002),oFont12b,100)   // "Relacion de Prestaciones Laborales Y Regalia
oPrn:Say(nLinDet+=040,1470,OemToAnsi(STR0003)+cDtCabec,oFont12b ,100)   // Al 
oPrn:Box(nLinDet+=70,190,2400,3100)

oPrn:Say(nLinDet+=020, 200,OemToAnsi(STR0005),oFont09b,50) // N.
oPrn:Say(nLinDet,0360,OemToAnsi(STR0006),oFont08b,50) // NOME              
oPrn:Say(nLinDet,0900,OemToAnsi(STR0007),oFont08b,50) // cargo  
oPrn:Say(nLinDet,1220,OemToAnsi(STR0008),oFont08b,50) // admissao 
oPrn:Say(nLinDet,1400,OemToAnsi(STR0009),oFont08b,50) // MES      

oPrn:Say(nLinDet,1540,OemToAnsi(STR0017),oFont08b,50) // SALARIO  
oPrn:Say(nLinDet,1800,OemToAnsi(STR0010),oFont08b,50) // TOT.GANA.
oPrn:Say(nLinDet,2100,OemToAnsi(STR0011),oFont08b,50) // SUELDO PROMEDIO
oPrn:Say(nLinDet,2450,OemToAnsi(STR0012),oFont08b,50) // REGALIA        
oPrn:Line(nLinDet+=50,190,nLinDet,3100)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGperSub   บAutor  ณSilvia Taguti       บ Data ณ  04/17/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime Sub-Totais                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GperSub()

If nLinDet > 2200 
	// Cerra la pagina
	oPrn:EndPage()
 	oPrn:StartPage()
	Cabec()
	nLinDet-=50
Endif
oPrn:Line(nLinDet+50,190,nLinDet+50,3100)
oPrn:Say(nLinDet+=50,1500,OemToAnsi(STR0013),oFont08b,50)      //Sub-total
oPrn:Say(nLinDet,2440,Transform(aSubTot[01],cPict1),oFont07,50) // REGALIA        
oPrn:Line(nLinDet+=50,190,nLinDet,3100)

aSubTot := {0,0,0}

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGperTot   บAutor  ณSilvia Taguti       บ Data ณ  04/17/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime Totais                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GperTot()

If nLinDet > 2200 
	// Cerra la pagina
	oPrn:EndPage()
 	oPrn:StartPage()
	Cabec()
Endif

//oPrn:Line(nLinDet+50,190,nLinDet+50,3100)
oPrn:Say(nLinDet+=50,1500,OemToAnsi(STR0014),oFont08b,50)      //total
oPrn:Say(nLinDet,2440,Transform(aTotal[01],cPict1),oFont07,50) // REGALIA        
oPrn:Line(nLinDet+=50,190,nLinDet,3100)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGpercc    บAutor  ณSilvia Taguti       บ Data ณ  04/17/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime Totais  Centro de custo                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GperCc()

If nLinDet > 2200 
	// Cerra la pagina
	oPrn:EndPage()
 	oPrn:StartPage()
	Cabec()
Endif

oPrn:Say(nLinDet,1500,cCcAnt&cQ+" - "+DescCc(cCcAnt&cQ,cFilialAnt),oFont08b,50)      //Centro Custo-Total
oPrn:Say(nLinDet,2440,Transform(aTotal[01],cPict1),oFont07,50) // REGALIA        
oPrn:Line(nLinDet+=50,190,nLinDet,3100)

aSubTot := {0,0,0}

Return

