/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHQMT002  ºAutor  ³Marcos R. Roquitski º Data ³  05/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Termo de Responsabilidade, para concessao dos instrumentos º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhqmt002()

	Processa({|| fGrTermo() }, "Termo de Responsabilidade")

Return Nil


Static Function fGrTermo()
Local nPagina := 1,;
      cResRet := Space(40),;
      cDescIn := Space(40) 
        
	oFonteP1 := TFont():New("Arial",,10,,.t.,,,,,.f.)                             
	oFonteP2 := TFont():New("Arial",,12,,.t.,,,,,.f.)                             
	
	oFonteG1 := TFont():New("Arial",,14,,.t.,,,,,.f.)
	oFonteG2 := TFont():New("Arial",,12,,.t.,,,,,.f.)
   
	oPr := tAvPrinter():New("Protheus")
	oPr:StartPage()
    
	QAA->(DbSetOrder(1))
	QAA->(Dbseek(xFilial("QAA") + QML->QML_RESRET))
	If QAA->(Found())
		cResRet := QAA->QAA_NOME	
	Endif

	QM2->(DbSetOrder(1))
	QM2->(Dbseek(xFilial("QM2") + QML->QML_INSTR))
	If QM2->(Found())
		cDescIn := Alltrim(QM2->QM2_DESC)
	Endif

	oPr:Say(0400,250,"** NEW HUBNER COMPONENTES AUTOMOTIVOS LTDA **",oFonteG1)

	oPr:Say(0700,600,"TERMO DE RESPONSABILIDADE",oFonteG2)
	
	oPr:Say(1000,200,"Pelo presente termo, declaro  que  recebi, em  perfeito estado  de conservacao e uso  o  aparelho",oFonteP1)

	oPr:Say(1100,200,"de medicao: ",oFonteP1)
	oPr:Say(1100,480,cDescIn,oFonteP2)

	oPr:Say(1200,200,"cujo numero e: ",oFonteP1)
	oPr:Say(1200,510,QML->QML_INSTR,oFonteP2)

	
	oPr:Say(1300,200,"Comprometo-me   a   utiliza-lo   para    exercer   a   minha   atividade   profissional    na   empresa",oFonteP1)
	oPr:Say(1400,200,"New Hubner Componentes Automotivos Ltda,    responsabilizando-me   pela     sua  conservacao",oFonteP1)
	oPr:Say(1500,200,"e  pelo bom uso.",oFonteP1)
	oPr:Say(1600,200,"Comprometo-me  a   devolve-lo   quando  a  tando   for  instado.",oFonteP1)
	oPr:Say(1700,200,"Responsabilizo-me em repor o aparelho ou a indenizar a  empresa  no  valor correspondente, em",oFonteP1)
	oPr:Say(1800,200,"caso de dano ou extravio.",oFonteP1)
	oPr:Say(2300,200,"Curitiba, "+StrZero(Day(dDataBase),2) + " de "+MesExtenso(dDataBase) + " de "+Alltrim(Str(Year(dDataBase))),oFonteP1)
	oPr:Say(2500,200,"_________________________________________________",oFonteP1)
	oPr:Say(2600,200,"EMPREGADO: "+QML->QML_RESRET+" - "+cResRet,oFonteP1)
      
	oPr:EndPage()
	oPr:Preview()
	oPr:End()
   
	MS_FLUSH()

Return(nil)
