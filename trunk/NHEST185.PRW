

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST185  ºAutor  ³Alexandre R. Bento  º Data ³  16/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³RELATORIO DE MOV. DE ESTOQUE                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ESTOQUE/CUSTOS                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±± 																		   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "TOPCONN.CH" 
#INCLUDE "RWMAKE.CH"

User Function NHEST185()
Private cAliasSB1 

cString		:= "SD3"
cDesc1		:= "Este relatorio tem como objetivo imprimir a movimentação de Estoque"
cDesc2		:= ""
cDesc3		:= ""
tamanho		:= "M"
limite		:= 132
aReturn		:= { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHEST185"
nLastKey	:= 0
titulo		:= OemToAnsi("MOVIMENTAÇÃO DE ESTOQUE")
cabec1      := " PRODUTO          COD. CLIENTE          DESCRIÇÃO                             SAIDA ESTOQUE    QTDE ESTOQUE"
cabec2		:= " "
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1
M_PAG		:= 1
wnrel		:= "NHEST185"
_cPerg		:= "EST185"


Pergunte(_cPerg,.F.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)


If nLastKey == 27
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)

nTipo		:= IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))

aDriver		:= ReadDriver()
cCompac		:= aDriver[1]

Processa({|| Gerando()  },"Gerando Dados para Impressao")

Set Filter To
If aReturn[5]==1
	Set Printer To
	Commit
	OurSpool(wnrel)
EndIf
MS_FLUSH()

Return


Static Function Gerando()
	
/*
*******************************************************************************************				
				SELECT B1.B1_COD,B1.B1_CODAP5,B1.B1_DESC,(SELECT SUM(D3.D3_QUANT) 
                                          FROM SD3FN0 D3
                                          WHERE D3.D_E_L_E_T_ =''
                                          AND D3.D3_COD = B1.B1_COD
                                          AND D3.D3_TM >= '500'
                                          GROUP BY D3.D3_COD)
                                     
FROM SB1FN0 B1
WHERE B1.D_E_L_E_T_ =''
AND B1.B1_GRUPO BETWEEN 'MM52' AND 'MMZZ'
ORDER BY B1.B1_COD,B1.B1_CODAP5,B1.B1_DESC
				

*/	

    cAliasSB1 := GetNextAlias()	            
    BeginSql Alias cAliasSB1    
	   SELECT SB1.B1_COD,SB1.B1_CODAP5,SB1.B1_DESC,(SELECT SUM(SD3.D3_QUANT) 
       FROM %Table:SD3% SD3 (NOLOCK)
       WHERE 
	   SD3.D3_FILIAL = %xFilial:SD3% AND
	   SD3.%NotDel% AND       
       SD3.D3_COD = SB1.B1_COD AND
	   SD3.D3_EMISSAO BETWEEN %Exp:Dtos(mv_par05)% AND %Exp:Dtos(mv_par06)% AND              
       SD3.D3_TM >= '500' 
       GROUP BY SD3.D3_COD) AS 'SOMA' 
       FROM %Table:SB1% SB1 (NOLOCK)       
       WHERE
	   SB1.%NotDel% AND              
	   SB1.B1_GRUPO	BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% AND       
	   SB1.B1_COD	BETWEEN %Exp:mv_par03% AND %Exp:mv_par04% AND       	   
	   SB1.B1_FILIAL = %xFilial:SB1% 
       ORDER BY SB1.B1_COD,SB1.B1_CODAP5,SB1.B1_DESC
	EndSql   
	
//----------------------------------------------------------------------------------------------

   (cAliasSB1)->(Dbgotop())
    SB2->(DbSetOrder(1))   
	While (cAliasSB1)->(!EoF())
			
		IncProc()    
     
		If Prow() > 60 .OR. Prow() < 2
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
		EndIf
  	   
  	    @Prow()+1,001 PSAY (cAliasSB1)->B1_COD
  	    @Prow()  ,020 PSAY (cAliasSB1)->B1_CODAP5  	             
   	    @Prow()  ,040 PSAY (cAliasSB1)->B1_DESC
  	    @Prow()  ,072 PSAY (cAliasSB1)->SOMA Picture "@E 9,999,999.999" //MOV. QUANTIDADE   	    
  	    If SB2->(Dbseek(xFilial("SB2")+(cAliasSB1)->B1_COD))
           @Prow()  ,090 PSAY SB2->B2_QATU Picture "@E 9,999,999.999" //QUANTIDADE   	      	    
        Else
           @Prow()  ,090 PSAY 0.000 Picture "@E 9,999,999.999" //QUANTIDADE   	      	               
  	    Endif

       (cAliasSB1)->(Dbskip())
       
    Enddo
	(cAliasSB1)->(DbCloseArea())	
Return              

