/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE195  �Autor  �Marcos R. Roquitski � Data �  21/09/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     �Termo de entrega do vale transporte.                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �WHB                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"
#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"
#include "protheus.ch"
#INCLUDE "FIVEWIN.CH"

User Function NHGPE195()

cString		:= "SRA"
cDesc1		:= "Termo de Vale Transporte"
cDesc2      := ""
cDesc3      := ""      
tamanho		:= "P"
limite		:= 132
aReturn		:= { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHGPE195"
nLastKey	:= 0
titulo		:= OemToAnsi("Relat�rio de Vale transporte")
cabec2		:= ""
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1 //Variavel da pagina
M_PAG		:= 1
wnrel		:= "NHGPE195"
_cPerg		:= "NHGP20"
nCont		:= 0
nAlt 		:= 790
Private		nFunc

oFnt1 		:= TFont():New("Arial"		,,14,,.T.,,,,,.T.)
oFnt2		:= TFont():New("Arial"		,,13,,.T.,,,,,.F.)
oFnt3		:= TFont():New("Arial"		,,10,,.T.,,,,,.F.)
oFnt4		:= TFont():New("Arial"		,,12,,.F.,,,,,.F.)

Pergunte(_cPerg,.T.)

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,,,.F.,,,tamanho)


// inicio do processamento do relat�rio
Processa( {|| fTmpDep() },"Gerando Dados para a Impressao")
Processa( {|| Gerando()  },"Gerando relat�rio...")

DbCloseArea("_TMP")

Return


Static Function Gerando()
Local _nLin := 0, _cSrnDesc := Space(20), _cDescd := Space(20)

DbSelectArea("_TMP")
_TMP->(DbGotop())

oPr:=tAvPrinter():New("Protheus")
While _TMP->(!Eof())
	
	oPr:StartPage()

	//oPr:Say(0100,800,"* * " + Alltrim(SM0->M0_NOMECOM) + " * *",oFnt1)
	oPr:Say(0100,770,"V A L E   T R A N S P O R T E",oFnt1)

	oPr:Say(0300,200,"Curitiba, "+StrZero(Day(dDataBase),2) + " de "+MesExtenso(dDataBase) + " de "+ Str(Year(dDataBase),4)+".",oFnt2)


	CTT->(DbSeek(xFilial("CTT")+_TMP->RA_CC))
	If CTT->(Found())
		_cDescd := CTT->CTT_DESC01
	Endif	


	oPr:Say(0500,200,"Matricula: " + _TMP->RA_MAT,oFnt2)
	oPr:Say(0550,200,"Nome     : " + _TMP->RA_NOME,oFnt2)
	oPr:Say(0600,200,"C.Custo  : " + _TMP->RA_CC+' '+_cDescd,oFnt2)

	oPr:Say(0700,200,"Informo que utilizo o meio de transporte abaixo para deslocamento resid�ncia-trabalho e vice-versa.",oFnt4)

	SR0->(DbSeek(xFilial("SR0")+_TMP->RA_MAT))
	While SR0->(!Eof()) .and. SR0->R0_MAT == _TMP->RA_MAT
		If SRN->(DbSeek(xFilial("SRN")+SR0->R0_MEIO))
			_cSrnDesc := SRN->RN_DESC
		Endif
		oPr:Say(0800+_nLin,200,"(     ) "+SR0->R0_MEIO+ ' '+_cSrnDesc,oFnt4)
		_cSrnDesc := Space(20)
		_nLin += 50
		SR0->(DbSkip())
	Enddo

	oPr:Say(1000+_nLin,200,"Especifique Empresa/Linha:_____________________________________________________ ",oFnt4)
	oPr:Say(1150+_nLin,200,"(     ) N�o utilizo o benef�cio de Vale Transporte pelo motivo de deslocar-me ao trabalho por meios",oFnt4)
	oPr:Say(1200+_nLin,200,"pr�prios.",oFnt4)
		

	oPr:Say(1400+_nLin,200,"Fico ciente de que o benef�cio ora solicitado ser� creditado  no  cart�o  de  vale-transporte e a ",oFnt4)
	oPr:Say(1450+_nLin,200,"utiliza��o do vale transporte disponibilizado pela empresa, � destinada apenas ao deslocamento ",oFnt4)
	oPr:Say(1500+_nLin,200,"resid�ncia/empresa e vice versa. Estou ciente que o estacionamento da empresa est� dispon�vel ",oFnt4)
	oPr:Say(1550+_nLin,200,"somente aos colaboradores que n�o utilizam vale transporte.",oFnt4)
	

	oPr:Say(1650+_nLin,200,"Estou ciente que havendo utiliza��o do estacionamento da empresa os cr�ditos ser�o" ,oFnt2)
	oPr:Say(1700+_nLin,200,"cancelados nas remessas correspondentes ao m�s seguinte.",oFnt2)


	oPr:Say(1800+_nLin,200,"Estou ciente que havendo altera��o nessas informa��es terei que comunicar formalmente ao rh",oFnt4)
	oPr:Say(1850+_nLin,200,"da empresa.",oFnt4)
    

    oPr:Say(2150+_nLin,200,"__________________________________________________________",oFnt4)          
	oPr:Say(2200+_nLin,200,_TMP->RA_MAT + ' ' + _TMP->RA_NOME,oFnt4)


	oPr:EndPage()                                                         

	_TMP->(DbSkip())

Enddo	
oPr:EndPage()                                                        
oPr:Preview()
Return

Static Function fTmpDep() 

cQuery := "SELECT * FROM " + RetSqlName('SRA') + " RA "
cQuery += "WHERE RA.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.RA_SITFOLH IN (' ','F','A') " 
cQuery += "AND RA.RA_MAT BETWEEN '"+ Mv_par03 + "' AND '"+ Mv_par04 + "' "
cQuery += "AND RA.RA_CC BETWEEN '"+ Mv_par05 + "' AND '"+ Mv_par06 + "' "

cQuery += "ORDER BY RA.RA_MAT " 

TCQUERY cQuery NEW ALIAS "_TMP" 
TcSetField("_TMP","RA_ADMISSA","D") // Muda a data de string para date.
TcSetField("_TMP","RA_NASC","D") // Muda a data de string para date.
Return
