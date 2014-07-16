
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE186     ºAutor ³José Henrique M Felipetto Data 06/28/11 ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Servico Social.                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                         ±±
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

User Function NHGPE186()

cString		:= "SRA"
cDesc1		:= "Relatório de Serviço Social"
cDesc2      := ""
cDesc3      := ""      
tamanho		:= "G"
limite		:= 132
aReturn		:= { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHGPE182"
nLastKey	:= 0
titulo		:= OemToAnsi("Relatório de Serviço Social")
cabec2		:= ""
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1 //Variavel da pagina
M_PAG		:= 1
wnrel		:= "NHGPE186"
_cPerg		:= "NHGPE186"
nCont		:= 0
nAlt 		:= 790
Private		nFunc

oFnt1 		:= TFont():New("Arial"		,,14,,.T.,,,,,.F.)
oFnt2		:= TFont():New("Arial"		,,10,,.T.,,,,,.F.)
oFnt3		:= TFont():New("Arial"		,,08,,.T.,,,,,.F.)
oFnt4		:= TFont():New("Arial"		,,09,,.T.,,,,,.F.)

Pergunte(_cPerg,.T.)

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,,,.F.,,,tamanho)

Processa( {|| Gerando()  },"Gerando relatório...")

Return


Static Function Gerando()

SRA->(DbSetOrder(1))
SRA->(DbSeek(xFilial("SRA") + mv_par01))


oPr:=tAvPrinter():New("Protheus")
oPr:StartPage()
	oPr:Say(020,050,"SERVIÇO SOCIAL",oFnt1)
	// Quadro Dados Funcionais
	
	cStr := "DADOS FUNCIONAIS"
	nAlt := 100
	For i := 1 to Len(cStr)
		oPr:Say(nAlt,080,Substr(cStr,i,1),oFnt4)
		nAlt += 30
	Next i
	
	oPr:Line(080,050,080,2200) 	// Linha Horizontal Superior
	oPr:Line(600,050,600,2200) 	// Linha Horizontal Inferior
	oPr:Line(080,050,600,050) 	// Linha Vertical Esquerda
	oPr:Line(080,2200,600,2200)	// Linha Vertical Direita
	oPr:Line(080,150,600,150) 	// Linha Vertical do Meio 
	
	oPr:Say(090,180,"Matrícula",oFnt2)
	oPr:Line(130,180,130,390) 	//Linha Horizontal Superior
	oPr:Line(185,180,185,390)	// Linha Horizontal Inferior
	oPr:Line(130,180,185,180)	// Linha Vertical Esquerda
	oPr:Line(130,390,185,390)	// Linha Vertical Direita 
	oPr:Say(140,185,Alltrim(SRA->RA_MAT),oFnt3)
	
	oPr:Say(090,430,"Nome do Funcionário",oFnt2)
	oPr:Line(130,430,130,1650) 	//Linha Horizontal Superior
	oPr:Line(185,430,185,1650)	// Linha Horizontal Inferior
	oPr:Line(130,430,185,430)	// Linha Vertical Esquerda
	oPr:Line(130,1650,185,1650)	// Linha Vertical Direita
	oPr:Say(130,440,Alltrim(SRA->RA_NOME),oFnt3)
	
	oPr:Say(090,1700,"Data de Admissão",oFnt2)
	oPr:Line(130,1700,130,2100) //Linha Horizontal Superior
	oPr:Line(185,1700,185,2100)	// Linha Horizontal Inferior
	oPr:Line(130,1700,185,1700)	// Linha Vertical Esquerda
	oPr:Line(130,2100,185,2100)	// Linha Vertical Direita
	oPr:Say(130,1710,Substr(DTOS(SRA->RA_ADMISSA),7,2) + "/" + Substr(DTOS(SRA->RA_ADMISSA),5,2) + "/" + Substr(DTOS(SRA->RA_ADMISSA),1,4),oFnt3)
	

	oPr:Say(195,180,"Planta",oFnt2)
	oPr:Line(235,180,235,390) 	//Linha Horizontal Superior
	oPr:Line(290,180,290,390)	// Linha Horizontal Inferior
	oPr:Line(235,180,290,180)	// Linha Vertical Esquerda
	oPr:Line(235,390,290,390)	// Linha Vertical Direita
	oPr:Say(240,190,Alltrim(SRA->RA_ZEMP),oFnt3)

	oPr:Say(195,430,"Função",oFnt2)
	oPr:Line(235,430,235,1150) 	//Linha Horizontal Superior
	oPr:Line(290,430,290,1150)	// Linha Horizontal Inferior
	oPr:Line(235,430,290,430)	// Linha Vertical Esquerda
	oPr:Line(235,1150,290,1150)	// Linha Vertical Direita
	SRJ->(DbSetOrder(1))
	SRJ->(DbSeek(xFilial("SRJ") + SRA->RA_CODFUNC))
	oPr:Say(240,440,Alltrim(SRJ->RJ_DESC),oFnt3)
	
	oPr:Say(195,1200,"Telefone",oFnt2)
	oPr:Line(235,1200,235,1650) //Linha Horizontal Superior
	oPr:Line(290,1200,290,1650)	// Linha Horizontal Inferior
	oPr:Line(235,1200,290,1200)	// Linha Vertical Esquerda
	oPr:Line(235,1650,290,1650)	// Linha Vertical Direita
	oPr:Say(240,1210,Alltrim(SRA->RA_TELEFON),oFnt3)
	
	oPr:Say(195,1700,"Tempo Empresa(anos)",oFnt2)
	oPr:Line(235,1700,235,2100) //Linha Horizontal Superior
	oPr:Line(290,1700,290,2100)	// Linha Horizontal Inferior
	oPr:Line(235,1700,290,1700)	// Linha Vertical Esquerda
	oPr:Line(235,2100,290,2100)	// Linha Vertical Direita
	nVar := (Date() - SRA->RA_ADMISSA) / 365
	oPr:Say(240,1710,Transform(nVar,"@e 999.9"),oFnt3)
	
	
	oPr:Say(300,180,"C. de Custo",oFnt2)
	oPr:Line(340,180,340,390) 	//Linha Horizontal Superior
	oPr:Line(395,180,395,390)	// Linha Horizontal Inferior
	oPr:Line(340,180,395,180)	// Linha Vertical Esquerda
	oPr:Line(340,390,395,390)	// Linha Vertical Direita
	oPr:Say(345,190,Alltrim(SRA->RA_CC),oFnt3)
	
		
	oPr:Say(300,430,"Descrição do C. de Custo",oFnt2)
	oPr:Line(340,430,340,1150) 	//Linha Horizontal Superior
	oPr:Line(395,430,395,1150)	// Linha Horizontal Inferior
	oPr:Line(340,430,395,430)	// Linha Vertical Esquerda
	oPr:Line(340,1150,395,1150)	// Linha Vertical Direita
	CTT->(DbSetOrder(1))
	CTT->(DbSeek(xFilial("CTT") + SRA->RA_CC))
	oPr:Say(345,438,CTT->CTT_DESC01,oFnt3)

	
	oPr:Say(300,1200,"Superior Imediato",oFnt2)
	oPr:Line(340,1200,340,2100) //Linha Horizontal Superior
	oPr:Line(395,1200,395,2100)	// Linha Horizontal Inferior
	oPr:Line(340,1200,395,1200)	// Linha Vertical Esquerda
	oPr:Line(340,2100,395,2100)	// Linha Vertical Direita

	oPr:Say(405,180,"Turno Trab.",oFnt2)
	oPr:Line(460,180,460,390) 	//Linha Horizontal Superior
	oPr:Line(515,180,515,390)	// Linha Horizontal Inferior
	oPr:Line(460,180,515,180)	// Linha Vertical Esquerda
	oPr:Line(460,390,515,390)	// Linha Vertical Direita
	oPr:Say(465,185,Substr(RA_TNOTRAB,3,1) + " TURNO",oFnt3)
	
	oPr:Say(405,430,"Nº Dependentes",oFnt2)
	oPr:Line(460,430,460,800) 	//Linha Horizontal Superior
	oPr:Line(515,430,515,800)	// Linha Horizontal Inferior
	oPr:Line(460,430,515,430)	// Linha Vertical Esquerda
	oPr:Line(460,800,515,800)	// Linha Vertical Direita
	SRB->(DbSetOrder(1))
	SRB->(DbSeek(xFilial("SRB") + SRA->RA_MAT))	                                                    
	nCont := 0
	Do While SRB->(!EOF()) .AND. SRA->RA_MAT == SRB->RB_MAT
		nCont += 1
		SRB->(DbSkip())
	EndDo              
	oPr:Say(465,455,Str(nCont),oFnt3)
	// Fim do Primeiro Quadro

  
//	Quadro Histórico Funcional                                 
	cQuery := "Select TOP 5 * FROM SRENH0"
	cQuery += " WHERE RE_MATD = '" + mv_par01 + "' "
	TCQUERY cQuery NEW ALIAS "TMP0"
	DbSelectArea("TMP0")
	TcSetField("TMP0","RE_DATA","D")  // Muda a data de string para date 
	

	cQuery := "SELECT *  FROM " + RetSqlName('SR7') "
	cQuery += " WHERE R7_MAT = '" + mv_par01 + "' "
	cQuery += " ORDER BY R7_DATA DESC"
	TCQUERY cQuery NEW ALIAS "TMP1"
	DbSelectArea("TMP1")
	TcSetField("TMP1","R7_DATA","D")  // Muda a data de string para date    
	
	
	cStr := "HISTÓRICO FUNCIONAL"
	nAlt := 680
	For i := 1 to Len(cStr)
		oPr:Say(nAlt,080,Substr(cStr,i,1),oFnt4)
		nAlt += 30
	Next i
	
	oPr:Line(650,050,650,2200)   // Linha Horizontal Superior  
  	oPr:Line(1570,050,1570,2200) // Linha Horizontal Inferior  
    oPr:Line(650,050,1570,050) 	 // Linha Vertical Esquerda	   
  	oPr:Line(650,2200,1570,2200) // Linha Vertical Direita     
  	oPr:Line(650,150,1570,150)   // Linha Vertical do Meio

	oPr:Say(660,180,"Transferências (últimas 5)",oFnt2)
  	oPr:Say(660,1470,"Funções(últimas 5)",oFnt2)
  	nAlt := 745
 //	SRE->(DbSetOrder(5))
 // SRE->(DbSeek(xFilial("SRE") + SRA->RA_MAT))
  	CTT->(dbSetOrder(1))
  	SR7->(dbSetOrder(1))
  	SR7->(DbSeek(xFilial("SR7") + SRA->RA_MAT))
  	nVar := SRA->RA_ADMISSA 
  	While TMP0->(!EOF()) 
	  	
	  	If CTT->(DbSeek(xFilial("CTT") + TMP0->RE_CCD))
  			cNome := CTT->CTT_DESC01
  		Else
  			cNome := ""
  		EndIf
	   	
	   	If TMP0->RE_EMPD == SM0->M0_CODIGO
	   		oPr:Say(nAlt,185,Transform((TMP0->RE_DATA - nVar)/365,"@e 999.9"),oFnt3)
	  	 	oPr:Say(nAlt,515,cNome,oFnt3)
  			nAlt += 60
  			nVar := TMP0->RE_DATA 
  		EndIf
  		
  		TMP0->(DbSkip() )
	EndDo
	
	nAlt := 745
	nVar := dDataBase
	nCont := 0
	While TMP1->(!EOF()) .AND. nCont < 5
	nDesc := TMP1->R7_DESCFUN
		nFunc := TMP1->R7_FUNCAO
		While TMP1->R7_FUNCAO == nFunc
			nVar2 := TMP1->R7_DATA
			TMP1->(DbSkip())
		Enddo
		oPr:Say(nAlt,1825,nDesc,oFnt3)
		oPr:Say(nAlt,1485,Transform((nVar - nVar2)/365,"@e 999999.9"),oFnt3)
		nAlt += 60
		nVar := nVar2
		nCont += 1

	Enddo
	

  	oPr:Say(700,180,"Tempo (anos)",oFnt2)
  	oPr:Line(740,180,740,460) // Linha Horizontal Superior
  	oPr:Line(740,180,1050,180) // Linha Vertical Esquerda
  	oPr:Line(1050,180,1050,460) // Linha Horizontal Inferior
   	oPr:Line(740,460,1050,460) // Linha Vertical Direita                 
	
	nAlt := 790
	nCont := 0
	Do while nCont <= 3
 		oPr:Line(nAlt,180,nAlt,460)
  		nAlt += 60
  		nCont += 1
  	EndDo
  	nCont := 0
  	nAlt := 790 
  	
  	oPr:Say(700,510,"Centro Custo",oFnt2)
  	oPr:Line(740,510,740,1410) // Linha Horizontal Superior
  	oPr:Line(740,510,1050,510) // Linha Vertical Esquerda
  	oPr:Line(1050,510,1050,1410)// Linha Horizontal Inferior 
  	oPr:Line(740,1410,1050,1410)// Linha Vertical Direita

  	Do while nCont <= 3
 		oPr:Line(nAlt,510,nAlt,1410)
  		nAlt += 60
  		nCont += 1
  	EndDo
  	nCont := 0
  	nAlt := 800
  	
  	oPr:Say(700,1480,"Tempo(anos)",oFnt2)
  	oPr:Line(740,1480,740,1760) // Linha Horizontal Superior
  	oPr:Line(740,1480,1050,1480) // Linha Vertical Esquerda
  	oPr:Line(1050,1480,1050,1760) // Linha Horizontal Inferior
  	oPr:Line(740,1760,1050,1760) // Linha Vertical Direita
  	Do while nCont <= 3
  		oPr:Line(nAlt,1480,nAlt,1760)
  		nAlt += 60
  		nCont += 1
  	EndDo 
	nCont := 0
	nAlt := 790
  	
  	oPr:Say(700,1820,"Função",oFnt2)
  	oPr:Line(740,1820,740,2190)// Linha Horizontal Superior
  	oPr:Line(740,1820,1050,1820)//Linha Vertical Esquerda
  	oPr:Line(1050,1820,1050,2190)// Linha Horizontal Inferior
  	oPr:Line(740,2190,1050,2190) // Linha Vertical Direita
  	Do While nCont <= 3
  		oPr:Line(nAlt,1820,nAlt,2190)
  		nAlt += 60
  		nCont += 1
  	EndDo

	oPr:Say(1080,180,"Absenteísmo(últimos 12 meses)",oFnt2)
	oPr:Say(1120,180,"Tempo(dias)",oFnt2)
	oPr:Line(1170,180,1170,460) //Linha Horizontal Superior
	oPr:Line(1170,180,1260,180) // Linha Vertical Superior
	oPr:Line(1260,180,1260,460) // Linha Horizontal Inferior
	oPr:Line(1170,460,1260,460) // Linha Vertical Direita
	oPr:Line(1215,180,1215,460) // Linha Horizontal do Meio
	
	oPr:Say(1120,510,"Motivo",oFnt2)
	oPr:Line(1170,510,1170,1410) // Linha Horizontal Superior
	oPr:Line(1170,510,1260,510) // Linha Vertical Esquerda
	oPr:Line(1260,510,1260,1410) // Linha Horizontal Inferior
	oPr:Line(1170,1410,1260,1410) // Linha Vertical Direita
	oPr:Line(1215,510,1215,1410) // Linha Horizontal do Meio

	oPr:Say(1080,1470,"Advertências/Suspensões Disciplinares",oFnt2)
	oPr:Say(1120,1470,"Data",oFnt2)
	oPr:Line(1170,1470,1170,1750) // Linha Horizontal Superior
	oPr:Line(1170,1470,1260,1470) // Linha Vertical Esquerda
	oPr:Line(1260,1470,1260,1750) // Linha Horizontal Inferior
	oPr:Line(1170,1750,1260,1750) // Linha Vertical Direita 
	oPr:Line(1215,1470,1215,1750) // Linha Horizontal do Meio
	
	oPr:Say(1120,1820,"Motivo",oFnt2)
	oPr:Line(1170,1820,1170,2190) // Linha Horizontal Superior
	oPr:Line(1170,1820,1260,1820) // Linha Vertical Esquerda
	oPr:Line(1260,1820,1260,2190) // Linha Horizontal Inferior
	oPr:Line(1170,2190,1260,2190) // Linha Vertical Direita
	oPr:Line(1215,1820,1215,2190) // Linha Horizontal do Meio
	
	oPr:Say(1280,180,"Benefícios",oFnt2)
	oPr:Say(1310,180,"Utilizado(Sim/Não)",oFnt2)
	oPr:Line(1350,180,1350,460) // Linha Horizontal Superior
	oPr:Line(1350,180,1460,180) // Linha Vertical Esquerda
	oPr:Line(1460,180,1460,460) // Linha Horizontal Inferior
	oPr:Line(1350,460,1460,460) // Linha Vertical Direita 
	oPr:Line(1405,180,1405,460) // Linha Horizontal do Meio
	
	oPr:Say(1310,510,"Tipo Benefício",oFnt2)
	oPr:Line(1350,510,1350,1410) // Linha Horizontal Superior
	oPr:Line(1350,510,1460,510) // Linha Vertical Esquerda
	oPr:Line(1460,510,1460,1410) // Linha Horizontal Inferior
	oPr:Line(1350,1410,1460,1410) // Linha Vertical Direita
	oPr:Line(1405,510,1405,1410) // Linha Horizontal do Meio
	oPr:Say(1355,515,"Estacionamento",oFnt3)
	oPr:Say(1410,515,"Vale Transporte",oFnt3)
	
	oPr:Say(1310,1470,"Utilizado (Sim/Não)",oFnt2)
	oPr:Line(1350,1470,1350,1750) // Linha Horizontal Superior
	oPr:Line(1350,1470,1460,1470) // Linha Vertical Esquerda
	oPr:Line(1460,1470,1460,1750) // Linha Horizontal Inferior
	oPr:Line(1350,1750,1460,1750) // Linha Vertical Direita 
	oPr:Line(1405,1470,1405,1750) // Linha Horizontal do Meio
	oPr:Line(1405,1470,1405,1750) // Linha Horizontal do Meio
	
	oPr:Say(1310,1820,"Tipo Benefício",oFnt2)
	oPr:Line(1350,1820,1350,2190) // Linha Horizontal Superior
	oPr:Line(1350,1820,1460,1820) // Linha Vertical Esquerda
	oPr:Line(1460,1820,1460,2190) // Linha Horizontal Inferior
	oPr:Line(1350,2190,1460,2190) // Linha Vertical Direita
	oPr:Line(1405,1820,1405,2190) // Linha Horizontal do Meio
	oPr:Say(1355,1825,"Vale Mercado",oFnt3)
	oPr:Say(1410,1825,"Farmácia",oFnt3)
// Fim do Segundo Quadro

// Quadro Solicitação do Funcionário
	cStr := "SOLICITACÃO DO FUNCIONÁRIO"
	nAlt := 1610
	For i := 1 to Len(cStr)
		oPr:Say(nAlt,080,Substr(cStr,i,1),oFnt4)
		nAlt += 30
	Next i
	
	oPr:Line(1600,050,1600,2200) // Linha Horizontal Superior
  	oPr:Line(1600,050,2520,050) // Linha Vertical Esquerda
  	oPr:Line(2520,050,2520,2200) // Linha Horizontal Inferior
  	oPr:Line(1600,2200,2520,2200)//Linha Vertical Direita
  	oPr:Line(1600,150,2520,150)   // Linha Vertical do Meio

nCont := 0
nAlt := 1700
Do While nCont <= 6
	oPr:Line(nAlt,170,nAlt,2150)
	nAlt += 100
	nCont += 1
EndDo
	oPr:Say(2450,450,"Data: ____/____/____",oFnt3)
	oPr:Say(2450,850,"                         Assinatura:_________________________________",oFnt3)	
// Fim do Terceiro Quadro

// Quadro Serviço Social
    cStr := "SERVICO SOCIAL"
    nAlt := 2545
    For i := 1 to Len(cStr)
		oPr:Say(nAlt,080,Substr(cStr,i,1),oFnt4)
		nAlt += 30
	Next i
	
	oPr:Line(2540,050,2540,2200) // Linha Horizontal Superior
	oPr:Line(2540,050,3000,050) // Linha Vertical Esquerda
	oPr:Line(3000,050,3000,2200) // Linha Horizontal Inferior
	oPr:Line(2540,2200,3000,2200) // Linha Vertical Direita
	oPr:Line(2540,150,3000,150) // Linha Vertical do Meio
	
	oPr:Line(2570,180,2570,220) // Linha Horizontal Superior (DOAÇÃO)
	oPr:Line(2570,180,2610,180) // Linha Vertical Esquerda (DOAÇÃO)
	oPr:Line(2610,180,2610,220) // Linha Horizontal Inferior (DOAÇÃO)
	oPr:Line(2570,220,2610,220) // Linha Vertical Direita (DOAÇÃO)
	oPr:Say(2575,230,"Doação",oFnt2)

	oPr:Line(2570,500,2570,540) // Linha Horizontal Superior (DOAÇÃO)
	oPr:Line(2570,500,2610,500) // Linha Vertical Esquerda (DOAÇÃO)
	oPr:Line(2610,500,2610,540) // Linha Horizontal Inferior (DOAÇÃO)
	oPr:Line(2570,540,2610,540) // Linha Vertical Direita (DOAÇÃO)
	oPr:Say(2575,545,"Medicamentos",oFnt2)
	                                                                
	oPr:Line(2570,820,2570,860) // Linha Horizontal Superior (DOAÇÃO)
	oPr:Line(2570,820,2610,820) // Linha Vertical Esquerda (DOAÇÃO)
	oPr:Line(2610,820,2610,860) // Linha Horizontal Inferior (DOAÇÃO)
	oPr:Line(2570,860,2610,860) // Linha Vertical Direita (DOAÇÃO)
	oPr:Say(2575,865,"Empréstimo Social",oFnt2)
	
	oPr:Line(2570,1220,2570,1260) // Linha Horizontal Superior (DOAÇÃO)
	oPr:Line(2570,1220,2610,1220) // Linha Vertical Esquerda (DOAÇÃO)
	oPr:Line(2610,1220,2610,1260) // Linha Horizontal Inferior (DOAÇÃO)
	oPr:Line(2570,1260,2610,1260) // Linha Vertical Direita (DOAÇÃO)
	oPr:Say(2575,1265,"13º Salário",oFnt2)                            
	
	oPr:Line(2570,1560,2570,1600) // Linha Horizontal Superior (DOAÇÃO)
	oPr:Line(2570,1560,2610,1560) // Linha Vertical Esquerda (DOAÇÃO)
	oPr:Line(2610,1560,2610,1600) // Linha Horizontal Inferior (DOAÇÃO)
	oPr:Line(2570,1600,2610,1600) // Linha Vertical Direita (DOAÇÃO)
	oPr:Say(2575,1605,"Outros",oFnt2)
	
	oPr:Line(2620,150,2620,2200)
	nCont := 1
	nAlt := 2720
	
	While nCont <= 2
		oPr:Line(nAlt,180,nAlt,2150)
		nCont += 1
		nAlt += 100
	EndDo
	
	oPr:Say(2950,180,"Data:___/___/___                  Assinatura:______________________",oFnt2)	
	oPr:Line(2820,1320,3000,1320)
	oPr:Line(2820,2150,3000,2150)
	
	// Quadrado Recomendável
	oPr:Line(2900,1380,2900,1420) // Linha Horizontal Superior
	oPr:Line(2900,1380,2940,1380) // Linha Vertical Esquerda
	oPr:Line(2940,1380,2940,1420) // Linha Horizontal Inferior
	oPr:Line(2900,1420,2940,1420) // Linha Vertical Direita
	oPr:Say(2900,1440,"Recomendável",oFnt2)
	
	oPr:Line(2900,1700,2900,1740) // Linha Horizontal Superior.
	oPr:Line(2900,1700,2940,1700) // Linha Vertical Esquerda.
	oPr:Line(2940,1700,2940,1740) // Linha Horizontal Inferior.
	oPr:Line(2900,1740,2940,1740) // Linha Vertical Direita.
	oPr:Say(2900,1750,"Não Aprovado",oFnt2)
	
	// Quadro Parecer
	cStr := "PARECER"
	nAlt := 3015
	For i := 1 to Len(cStr)
		oPr:Say(nAlt,080,Substr(cStr,i,1),oFnt4)
		nAlt += 30
	Next i
	
	oPr:Line(3010,050,3010,2200) // Linha Horizontal Superior
	oPr:Line(3010,050,3280,050) // Linha Vertical Esquerda
	oPr:Line(3280,050,3280,2200) // Linha Horizontal Inferior
	oPr:Line(3010,2200,3280,2200) // Linha Vertical Direita
	oPr:Line(3010,150,3280,150) // Linha Vertical do Meio
	
	oPr:Line(3210,180,3210,220) // Linha Horizontal Superior
	oPr:Line(3210,180,3250,180) // Linha Vertical Esquerda
	oPr:Line(3250,180,3250,220) // Linha Horizontal Inferior
	oPr:Line(3210,220,3250,220) // Linha Vertical Direita
	oPr:Say(3210,230,"Aprovado",oFnt2)
	
	oPr:Line(3210,400,3210,440) // Linha Horizontal Superior.
	oPr:Line(3210,400,3250,400) // Linha Vertical Esquerda.
	oPr:Line(3250,400,3250,440) // Linha Horizontal Inferior.
	oPr:Line(3210,440,3250,440) // Linha Vertical Direita.
	oPr:Say(3210,450,"Reprovado",oFnt2)
	
	oPr:Say(3210,650,"               Rúbricas: _________________________________________________________",oFnt2)

DbSelectArea("TMP1")
TMP1->(DbCloseArea() )

DbSelectArea("TMP0")
TMP0->(DbCloseArea() )


oPr:EndPage()                                                        
oPr:Preview()
Return