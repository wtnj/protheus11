

/*
���������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ������������
���Programa  � Relat�rio de estoque   �Autor �Jos� Henrique   � Data �  26/04/2011  ���
�������������������������������������������������������������������������͹������������
���Desc.     � Relat�rio de Estoque                                       �������������
�������������������������������������������������������������������������͹������������
���Uso       � ESTOQUE                                                    �������������
�������������������������������������������������������������������������͹������������
���������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������
*/                                                                     


User Function NHTESTE()

cString		:= "SB"
cDesc1		:= "Este relat�rio tem como objetivo mostrar a quantidade"
cDesc2      := "e o local de produtos"
cDesc3      := ""      
tamanho		:= "G"
limite		:= 132
aReturn		:= { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHteste"
nLastKey	:= 0
titulo		:= OemToAnsi("Relat�rio de Estoque")
cabec1    	:= ""
cabec2		:= ""
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1 //Variavel da pagina
M_PAG		:= 1
wnrel		:= "NHTESTE"
_cPerg		:= ""
                

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif          

SetDefault(aReturn,cString)

nTipo	:= IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver	:= ReadDriver()
cCompac	:= aDriver[1]

Processa( {|| Gerando()  },"Gerando Dados para a Impressao")
Processa( {|| RptDetail()  },"Imprimindo...")    

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool

Return
