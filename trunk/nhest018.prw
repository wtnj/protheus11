/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³NHEST018  ³ Autor ³ Alexandre R. Bento    ³ Data ³ 22.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³Gatilho para nao deixar alterar o valor unitario,CC,Conta da ±±
±±            NFE qdo a mesma tiver vinculada a um pedido de compra        ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

#include "rwmake.ch"        

User Function Nhest018()    

Local lFlag := .T.
Local _nVunit := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_VUNIT"}) 
Local _Ped    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_PEDIDO"}) 
Local _cCentro:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_CC"}) 
Local _cConta := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_CONTA"}) 
//
If !Acols[n][len(aHeader)+1]  //nao pega quando a linha esta deletada 
   If !Empty(aCols[n,_Ped])                          
      If Empty(aCols[n,_cCentro])                             
         lFlag := .T.
      Elseif Empty(aCols[n,_cConta])                             
         lFlag := .T.
      Elseif Empty(aCols[n,_nVunit])                             
         lFlag := .T.  
      Else   
         MsgBox(OemToAnsi("Atenção não pode ser alterado este Campo "+chr(13)+;
                          "pois o conteudo do mesmo é carregado do pedido de Compras"),"Entrada de Nota Fiscal","ALERT") 
         lFlag := .F.                             
      Endif                    
   Else          
      lFlag := .T.   
   Endif   
Endif

Return(lFlag)
