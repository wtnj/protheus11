
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT242CLS  ºAutor  ³Alexandre R. Bento  º Data ³ 28/03/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E. chamado logo após a confirmação da digitação da tela  º±±
±±º          ³ de desmonte de produto  Deve retornar verdadeiro ou falso  º±±
±±º          ³ para validar a data do desmonte.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA242 - desmonte de produtos                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function MT242CLS

Local _cCCusto := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_CC"})  
Local _cConta  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_CONTA"})
Local _cLcz    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOCALIZ"})  

Local x
Local _nOrdSB1 
Local _nRecSB1 

For x:= 1 to len(acols)

   If ValType( acols[x][1]) == "C"   
      If Subs(acols[x][1],1,3)=="MOD"
         Acols[x][len(aHeader)+1] := .T.
      Else 
         _nOrdSB1 := SB1->(DbSetOrder())
         _nRecSB1 := SB1->(Recno())
         If SB1->B1_LOCALIZ$"S"
            Acols[x][_cLcz] := "01"
         Endif   
         SB1->(DbSetOrder(1))        
         SB1->(DbSeek(xFilial("SB1")+CPRODUTO))
         Acols[x][_cCCusto] := SB1->B1_CC         
         Acols[x][_cConta]  := SB1->B1_CONTA
         /*         	 	         
         If SM0->M0_CODIGO=="FN"                            
            SBM->(DbSetOrder(1))        
            SBM->(DbSeek(xFilial("SBM")+SB1->B1_GRUPO))
            Acols[x][_cConta] := SBM->BM_CTAADM         	 	
         Else
            Acols[x][_cConta] := '303010010001' //Conta CPV fixa conforme instrucao do Fernando Werner.
         Endif   
         */
	 	 
	 	 SB1->(dbSetOrder(_nOrdSB1))
     	 SB1->(dbGoto(_nRecSB1))
      Endif   
   Endif
Next

Return(aCols)