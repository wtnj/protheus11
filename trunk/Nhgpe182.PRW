/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE182  ºAutor  ³José Henrique         º Data ³  27/04/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Pagamento do CIEE                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gestão de Pessoal                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"    
#include "protheus.ch"        
#INCLUDE "FIVEWIN.CH"

User Function NHGPE182()

Local nValIpi := 0
Local nValIcm := 0
cString		:= "ZDC"
cDesc1		:= "Este relatorio tem como objetivo relacionar"
cDesc2      := "os estagiários vinculados a empresa WHB Componentes Automotivos Ltda e"
cDesc3      := "calcular a contribuição ao CIEE/PR"      
tamanho		:= "G"
limite		:= 132
aReturn		:= { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHGPE181"
nLastKey	:= 0
titulo		:= OemToAnsi("Relatório de Estagiários")
cabec2		:= ""
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1 //Variavel da pagina
M_PAG		:= 1
wnrel		:= "NHGPE181"
_cPerg		:= "NHGPE181"

Pergunte(_cPerg,.t.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif          

SetDefault(aReturn,cString)
nTipo	:= IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))
aDriver	:= ReadDriver()
cCompac	:= aDriver[1]
Processa( {|| fTmpDoc()  },"Gerando Dados para a Impressao")
Processa( {|| Gerando()  },"Gerando Dados para a Impressao")

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool

Return 

Static Function Gerando()
Private nAlt1 := 650
Private nAlt2 := 650
Private nCont := 1 
Private cQuery
Private nAlt3 := 665
Private nSomac5 := 0
Private nSomac6 := 0
Private nContri
Private n2Contri
Private nNumEst := 0

//Declara as Fontes
	oFonteN1 := TFont():New("Arial"		,,10,,.T.,,,,,.T.)
 	oFonteN2 := TFont():New("Arial"		,,10,,.T.,,,,,.F.)
 	oFontN5	 := TFont():New("Arial"		,,10,,.F.,,,,,.F.)
   	oFontN7	 := TFont():New("Arial"		,,08,,.F.,,,,,.F.)
   	oFontN3	 := TFont():New("Arial"		,,10,,.F.,,,,,.F.)
   	oFontN4	 := TFont():New("Arial"		,,10,,.T.,,,,,.F.)
   	oFontN5	 := TFont():New("Arial"		,,09,,.F.,,,,,.F.) 
   	oFonteN6 := TFont():New("Arial"		,,12,,.F.,,,,,.T.)
   	oFonteN3 := TFont():New("Arial"		,,13,,.T.,,,,,.F.)
   	oFonteN4 := TFont():New("Arial"		,,11,,.T.,,,,,.F.)
   	oFonteN5 := TFont():New("Arial"		,,11,,.F.,,,,,.F.)
   	oFonteN8 := TFont():New("Arial"		,,15,,.T.,,,,,.F.) 
   	oFonteN9 := TFont():New("Arial"		,,12,,.T.,,,,,.F.)
   	oFonteN10:= TFont():New("Arial"		,,09,,.F.,,,,,.F.)
    oFonteN11:= TFont():New("Arial"		,,09,,.F.,,,,,.T.)
    oFonteN12:= TFont():New("Arial"		,,13,,.T.,,,,,.T.) 
    oFonteN13:= TFont():New("Arial"		,,09,,.F.,,,,,.T.)
    oFontN14 := TFont():New("Arial"		,,08,,.T.,,,,,.F.)  
    //Fim                                                 
    
    //Seta para Paisagem(SetLandScape) e Inicia a Página(StartPage)
	oPr:=tAvPrinter():New("Protheus")
	oPr:SetLandScape()
   	oPr:StartPage()       
   	// Fim
   	
   	While TMPR->(!Eof()) 
 	   
		If !( TMPR->RA_SITFOLH $ mv_par01 )
	      TMPR->(DbSkip())
    	  Loop
	    Endif
	
 		
 		nAlt1 := 650
 		nAlt2 := 650
 		nCont := 1 
 		nAlt3 := 665
 		nSomac5 := 0
 		nSomac6 := 0
 		nNumEst := 0
	
 		// Cabeçalho do Relatório
   		oPr:Say(150,100,"Ao CENTRO DE INTEGRAÇÃO EMPRESA - ESCOLA NO PARANA",oFonteN6)
	   	oPr:Say(250,100,"Cumprindo o que determina a CLAUSULA TERCEIRA(alineas 'g' . 'h' e 'i') do convenio com essa",oFontN5)
	   	oPr:Say(280,100,"Instituição,informamos a frequência do(s) estagiário(s), bem como o(s) respectivo(s) valor(es) de bolsa(s) -",oFontN5)
   		oPr:Say(310,100,"auxílio e o total das contribuições devidas.",oFontN5)

		If SM0->M0_CODIGO = 'NH'
	   		oPr:Say(380,100,"Convenio nº    10112236   CNPJ/MF: 73.355.174/0001-40   Fone: (41) 3341-1235",oFontN4)
	   		oPr:Say(430,100,"Razão Social: WHB COMPONENTES AUTOMOTIVOS S/A",oFontN4)
	   		oPr:Say(160,1900,"FOLHA DE FREQUÊNCIA",oFonteN8)
	   		oPr:Say(240,1800,"C.N.R. nº 160909843 Depósito Bancário ",oFonteN9)
	   	Else
	   		oPr:Say(380,100,"Convenio nº    9988915501 CNPJ/MF: 01.261.681/0001-04   Fone: (41) 3341-1852",oFontN4)
	   		oPr:Say(430,100,"Razão Social: WHB FUNDICAO S/A",oFontN4)
	   		oPr:Say(160,1900,"FOLHA DE FREQUÊNCIA",oFonteN8)
	   		oPr:Say(240,1800,"C.N.R. nº 150809268 Depósito Bancário ",oFonteN9)
		Endif	   	

   		oPr:Say(390,1850,"Mês:"+"           " + mesextenso(month(dDatabase))+"            " + "Ano:"+"       " + alltrim(Str(year(dDatabase))))
	   	//Fim


		// Quadrado canto Superior Direito
		oPr:Line(150,2650,150,3100)
		oPr:Say(170,2650," Para uso exclusivo do CIEE/PR",oFontN14)
		oPr:Line(450,2650,450,3100)
		oPr:Line(150,2650,450,2650)
		oPr:Line(150,3100,450,3100) 
		//Linhas de Dentro do Quadrado
		oPr:Line(200,2650,200,3100)
		oPr:Say(210,2650," Recibo nº :",oFontN14)
		oPr:Line(290,2650,290,3100)
		oPr:Say(300,2650," Data Recebimento:",oFontN14)
		oPr:Line(370,2650,370,3100)
		oPr:Say(380,2650," Data Liberação:",oFontN14)
		//Fim
	
    	// Quadrado Maior
		oPr:Line(500,100,500,3100)
		oPr:Line(1650,100,1650,3100)
		oPr:Line(500,100,1650,100)
		oPr:Line(500,3100,1650,3100)
    	//Fim
		// Linhas Verticais
		oPr:Line(500,300,1650,300)
		oPr:Line(500,600,1650,600)
		oPr:Line(500,2000,1650,2000)
		oPr:Line(500,2300,1650,2300)
		oPr:Line(500,2700,1650,2700)
		oPr:Say(570,170,"Nº",oFontN4)
		oPr:Say(520,350,"Código do(a)",oFontN4)
		oPr:Say(570,330,"Estagiário(a) no",oFontN4)
		oPr:Say(620,360,"CIEE/PR",oFontN4)
		oPr:Say(570,1000,"            Nome do(a) Estagiário(a)",oFontN4)
   		oPr:Say(570,2005,"   Total de Horas",oFontN4)
		oPr:Say(500,2020,"1",oFontN4)
		oPr:Line(540,2000,540,2050)
		oPr:Line(500,2050,540,2050)
		oPr:Say(600,2015,"       no mês",oFontN4) 
	
		oPr:Say(560,2340,"Bolsa-Auxílio com",oFontN4)
		oPr:Say(590,2340,"valor 'superior' a ",oFontN4)
		oPr:Say(620,2390,"    R$250,00",oFontN4)
		oPr:Say(500,2320,"2",oFontN4)
		oPr:Line(540,2300,540,2350)
		oPr:Line(500,2350,540,2350)
	
		oPr:Say(540,2720,"      Bolsa-Auxílio com",oFontN4)
		oPr:Say(570,2720,"       valor'igual ou",oFontN4)
		oPr:Say(600,2720,"    inferior' a R$250,00",oFontN4)
		oPr:Say(500,2720,"3",oFontN4)
		oPr:Line(540,2700,540,2750)
		oPr:Line(500,2750,540,2750)
		//Fim
	
		// Linhas Horizontais
		oPr:Line(700,100,700,3100)
		nSomaBo := 0

		While TMPR->(!Eof()) .and. nCont <= 19

			If !( TMPR->RA_SITFOLH $ mv_par01 )
		      TMPR->(DbSkip())
	    	  Loop
		    Endif


			nAlt1 += 50
			nAlt2 += 50
			oPr:Line(nAlt1,100,nAlt2,3100)
			nAlt3 += 50
			oPr:Say(nAlt3,120,Transform(nCont,"9999"),oFontN4)	
			oPr:Say(nAlt3,360,TMPR->RA_XCODEST,oFontN4)
			oPr:Say(nAlt3,610,TMPR->RA_NOME,oFontN4)

        	_nHorasm := 0
			_cMat    := TMPR->RC_MAT
			_nRecno  := TMPR->(Recno())
			_nV799   := 0
			While TMPR->(!Eof()) .and. TMPR->RC_MAT == _cMat

				If !( TMPR->RA_SITFOLH $ mv_par01 )
			      TMPR->(DbSkip())
		    	  Loop
			    Endif

				If TMPR->RC_PD $ "097/098"				
					_nHorasm := TMPR->RC_HORAS
				Endif

				If TMPR->RC_PD $ "799/476"
					_nV799 := TMPR->RC_VALOR
				Endif
	       		TMPR->(DbSkip())
			Enddo				

   			oPr:Say(nAlt3,2060,Transform(_nHorasm,"@e 999.99"),oFontN4)

       		if _nV799 >= 250
      			oPr:Say(nAlt3,2380,Transform(_nV799,"@e 999,999.99"),oFontN4)
       			nSomac5 += _nV799              
       		elseif _nV799 < 250
       			oPr:Say(nAlt3,2750,Transform(_nV799,"@e 999,999.99"),oFontN4)
       			nSomac6 += _nV799
       			nNumEst += 1
       		endif
			nCont += 1       		
		Enddo

	    nDif := 19 - nCont
		If nDif < 19 .and. nDif > 0
			For I := 1 TO nDif
				nAlt1 += 50
				nAlt2 += 50
				oPr:Line(nAlt1,100,nAlt2,3100)
				nAlt3 += 50
				oPr:Say(nAlt3,120,Transform(nCont+I-1,"9999"),oFontN4)
	        Next
	    EndIf
    
		If nCont <= 21
			
			// Escrita da Soma das bolas
			oPr:Say(1890,2470,Transform(nSomac5,"@e 999,999.99"),oFontN4)
			oPr:Say(1890,2760,Transform(nSomac6,"@e 999,999.99"),oFontN4)
		
			// Linha IDENTIFICAÇÃO
			oPr:Say(1800,370,"IDENTIFICAÇÃO",oFonteN8)
			oPr:Say(1955,180,"Curitiba, " + Str(day(dDatabase)) + " de " + mesextenso(month(dDatabase)) + " de "+ Str(year(dDatabase)),oFontN4) 
			oPr:Line(2000,180,2000,780)
			oPr:Line(2300,180,2300,840)
			oPr:Say(1800,330,"4",oFontN4)
			oPr:Say(2340,100,"Assinatura do representante legal da empresa, sob carimbo",oFonteN11)
  
			//Quadro Importante
			oPr:Line(1800,1000,1800,1600)
			oPr:Line(2300,1000,2300,1600)
			oPr:Line(1800,1000,2300,1000)
			oPr:Line(1800,1600,2300,1600)
			oPr:Say(1850,1150,"IMPORTANTE",oFonteN8)
			oPr:Say(2000,1050,"   Em caso de eventual rescisão",oFontN4)	 
		 	oPr:Say(2040,1070,"   antecipada de contrato de",oFontN4)	 
			oPr:Say(2080,1050,"   estágio, informar ao CIEE/PR",oFontN4)
			oPr:Say(2120,1060,"       por escrito ou utilizar o",oFontN4)
			oPr:Say(2160,1060,"      formulário próprio para",oFontN4)
			oPr:Say(2200,1060,"   rescisão, disponível no site",oFontN4)
			oPr:Say(2240,1070,"         www.cieepr.org.br",oFontN4)
  
			// Escrita Soma dos Valores...
			oPr:Say(1850,1630,"Soma dos valores de Bolsas-Auxílio",oFontN3)
			oPr:Say(1840,2220,"R$",oFonteN8)
			oPr:Say(1770,2400,"Soma das Bolas",oFonteN10)
			oPr:Say(1800,2390,"relacionadas no item 2",oFonteN10) 
			oPr:Say(1770,2720,"Soma das Bolas",oFonteN10)
			oPr:Say(1800,2710,"relacionadas no item 3",oFonteN10)
			oPr:Line(1840,2700,1950,2700)
			oPr:Line(1840,2400,1840,3000)
			oPr:Line(1950,2400,1950,3000)
			oPr:Line(1840,2400,1950,2400)
			oPr:Line(1840,3000,1950,3000)
			oPr:Say(1845,2410," 5",oFontN4)
			oPr:Line(1890,2400,1890,2450)
			oPr:Line(1840,2450,1890,2450)
 
			oPr:Say(1845,2710,"6",oFontN4)
			oPr:Line(1890,2700,1890,2750)
			oPr:Line(1840,2750,1890,2750)
  
			// Escrita Contribuição..
			oPr:Say(2000,1650,"             Contribuição ao CIEE/PR",oFontN3)
			oPr:Say(2000,2220,"R$",oFonteN8)
			oPr:Line(2000,2400,2000,3000)
			oPr:Line(2110,2400,2110,3000)
			oPr:Line(2000,2400,2110,2400)
			oPr:Line(2000,3000,2110,3000)
			oPr:Line(2000,2700,2110,2700)
			oPr:Say(2000,2410,"7",oFontN4)
			oPr:Line(2050,2400,2050,2450)
			oPr:Line(2000,2450,2050,2450)
		   	oPr:Say(2000,2710,"8",oFontN4)
			oPr:Line(2050,2700,2050,2750)
			oPr:Line(2000,2750,2050,2750)
	 		nContri := (nSomac5 /100) * 10
			oPr:Say(2045,2460,Transform(nContri,"@e 999,999.99"),oFontN4) 
			oPr:Say(2045,2760,Transform(25 *  nNumEst ,"@e 999,999.99"),oFontN4)
  
  			// Escrita SubTotal
			oPr:Say(2200,1650,"                                        Subtotal",oFontN3)
			oPr:Say(2200,2220,"R$",oFonteN8)
			oPr:Line(2150,2400,2150,3000)
			oPr:Line(2260,2400,2260,3000)
			oPr:Line(2150,2400,2260,2400)
			oPr:Line(2150,3000,2260,3000)
			oPr:Line(2150,2700,2260,2700)
			oPr:Say(2150,2410,"9",oFontN4)
			oPr:Line(2200,2400,2200,2450)
			oPr:Line(2150,2450,2200,2450)
			oPr:Say(2150,2710,"10",oFontN4)
			oPr:Line(2200,2700,2200,2760)
			oPr:Line(2150,2760,2200,2760)
			nSubTota := nSomac5 + nContri
			oPr:Say(2200,2460,Transform(nSubTota,"@e 999,999.99"),oFontN4)
			n2SubTot := nSomac6 + (25 *  nNumEst)
			oPr:Say(2200,2760,Transform(n2SubTot,"@e 999,999.99"),oFontN4)
  
			// Escrita valor Total.... 
			oPr:Say(2340,1650,"    Valor total das Bolsas-Auxílio e",oFontN3) 
			oPr:Say(2370,1610,"contribuição ao CIEE/PR(item9 + 10)",oFontN3)
			oPr:Say(2350,2220,"R$",oFonteN8)
			oPr:Line(2300,2400,2300,3000)
			oPr:Line(2400,2400,2400,3000)
			oPr:Line(2300,2400,2400,2400)
			oPr:Line(2300,3000,2400,3000)
			oPr:Say(2310,2410,"11",oFontN4)
			oPr:Line(2350,2400,2350,2460)
			oPr:Line(2300,2460,2350,2460)
			nTotalBo := nSubTota + n2SubTot
			oPr:Say(2340,2610,Transform(nTotalBo,"@e 999,999.99"),oFontN4)

			//Termina o Relatório
		   	oPr:EndPage()
		   	oPr:StartPage()       
			nCont := 1

		Endif		

	Enddo  

	TMPR->(DbCloseArea())
	oPr:EndPage()
	oPr:Preview()
	oPr:End() 
	
Return


Static Function fTmpDoc()

cQuery := "SELECT *  FROM " + RetSqlName('SRA') + " RA, " +  RetSqlName('SRC') + " RC "
cQuery += "WHERE RC.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.D_E_L_E_T_ = ' ' "
cQuery += "AND RC.RC_PD IN ('799','098','097','476') " 
cQuery += "AND RA.RA_CATFUNC = 'G' "
cQuery += "AND RC.RC_MAT = RA.RA_MAT " 
cQuery += "AND RA.RA_FILIAL = '" + xFilial("SRA")+ "'"
cQuery += "AND RC.RC_FILIAL = '" + xFilial("SRC")+ "'"
cQuery += "ORDER BY RA.RA_NOME "

TCQUERY cQuery NEW ALIAS "TMPR" 

DbSelectArea("TMPR")
TMPR->(Dbgotop())

Return
