/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEEC002  �Autor  �Marcos R. Roquitski � Data �  17/02/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Etiqueta PANDROL.                                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"


User Function NHEEC002()

SetPrvt("_cArqDbf, cQuery,_aFields,aCampos,cMarca,cNovaLinha,cARQEXP ,cARQ,nPbruto,i,nqtde,netiq,nVol")   
Private cPerg := "NHEEC002"                             

//-----------------------------------------------------------------------------------------------------
//  verifica se tem o bmp para impressao.
//-----------------------------------------------------------------------------------------------------

If Pergunte(cPerg,.T.)

	Processa( {|| ImpEtq() }, "Aguarde Gerando Arquivo de Etiquetas...")

Endif 

Return



Static Function ImpEtq()

	Local aEtiq := {}
    Local nWidth  := 0.0330 //Comprimento do cod.de barras (centimetros)                    
	Local nHeigth := 0.991  //Largura do cod.de barras (milimetros)
	Local nLinBar := 1.0  //Linha inicial do cod. de barras da etiqueta
	Local nLinTex := 200  //240
	Local nColBar := 1  //Coluna Inicial do cod. de barras
	Local nColTex := 0  //Coluna Inicial do texto da etiqueta
	Local nColAtu := 1  //Numero de colunas da impressas
	Local nLinAtu := 1  //Numero de linhas impressas
	Local nAjust  := 1                       
	
	oFont10  := TFont():New("Arial",,10,,.F.)
	oFont12  := TFont():New("Arial",,12,,.F.)
	oFont18  := TFont():New("Arial",,18,,.F.)
	oFont22  := TFont():New("Arial",,22,,.F.)
	oFont34  := TFont():New("Arial",,34,,.F.)
	oFont44  := TFont():New("Arial",,44,,.F.)

	oFont12N := TFont():New("Arial",,12,,.T.)                  
	oFont14N := TFont():New("Arial",,14,,.T.)	
	oFont16N := TFont():New("Arial",,16,,.T.)
	oFont18N := TFont():New("Arial",,18,,.T.)
	oPr:= tAvPrinter():New("Protheus")
	oPr:StartPage()
    

/*
���Parametros� 01 cTypeBar String com o tipo do codigo de barras          ���
���	         � 	       "EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"         ���
���          � 		  "INT25","MAT25,"IND25","CODABAR" ,"CODE3_9"         ���
���          � 02 nRow	  Numero da Linha em centimentros                 ���
���          � 03 nCol	  Numero da coluna em centimentros	              ���
���          � 04 cCode	  String com o conteudo do codigo                 ���
���          � 05 oPr	  Objeto Printer                                  ���
���          � 06 lcheck   Se calcula o digito de controle                ���
���          � 07 Cor 	  Numero  da Cor, utilize a "common.ch"           ���
���          � 08 lHort	  Se imprime na Horizontal                        ���
���          � 09 nWidth   Num do Tamanho da largura da barra em centimet ���
���          � 10 nHeigth  Numero da Altura da barra em milimetros        ���
���          � 11 lBanner  Se imprime o linha em baixo do codigo          ���
���          � 12 cFont	  String com o tipo de fonte                      ���
���          � 13 cMode	  String com o modo do codigo de barras CODE128   ���
*/

	oPr:Say(0200,0050,OemtoAnsi("Order N�"), oFont12)
	oPr:Say(0210,0500,OemtoAnsi(mv_par01), oFont22)
    MSBAR("CODE3_9",1.3,0.5,Alltrim(mv_par01),oPr,.F., ,.T.,0.0194,0.6,NIL,NIL,NIL      ,.F.,,,.F.)

	oPr:Say(0600,0050,OemtoAnsi("Product code"), oFont12)
	oPr:Say(0610,0500,OemtoAnsi(mv_par02), oFont22)
    MSBAR("CODE3_9",3.0,0.5,Alltrim(mv_par02),oPr,.F., ,.T.,0.0194,0.6,NIL,NIL,NIL      ,.F.,,,.F.)

	oPr:Say(1000,0050,OemtoAnsi("Quantity of package"), oFont12)
	oPr:Say(1000,0500,OemtoAnsi(Transform(mv_par03,"99999")), oFont22)
    MSBAR("CODE3_9",04.5,0.5,Transform(mv_par03,"99999"),oPr,.F., ,.T.,0.0194,0.6,NIL,NIL,NIL      ,.F.,,,.F.) //imprime cod. de barra do produto
	//oPr:Line(1170,0050,1100,2200) // vertical qtde |produto

    oPr:EndPage()
	oPr:Preview()
	oPr:End()

	MS_FLUSH()

Return
