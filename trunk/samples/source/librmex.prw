/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ FUNCAO   ³ LIBRMEX  ³ AUTOR ³ Marcello Gabriel      ³ DATA ³ 04.05.00   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ DESCRICAO³ Livro de apuracao de IVA  (Mexico)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ USO      ³ Generico - Localizacoes                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LIBRMEX()
//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01             // Fecha desde                          ¦
//¦ mv_par02             // Fecha hasta                          ¦
//¦ mv_par03             // Ventas o compras                     ¦
//+--------------------------------------------------------------+
SA1->(dbsetorder(1))
SA2->(dbsetorder(1))
dbselectarea("SF3")
dbsetorder(1)
aReturn:={ OemToAnsi("Especial"), 1,OemToAnsi("Administracion"), 1, 2, 1,"",1 }
nomeprog:="LIBRMEX"
cPerg:="LIBMEX"
cPrn:="LIBMEX"    

aTES := {}

//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ¦
//+-------------------------------------------------------------------------+
ValidPerg()

Pergunte(cPerg,.F.)
//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+
cPrn:=SetPrint("SF3",cPrn,cPerg,"Libro I.V.A","","","",.F.,"",.T.,"M")
If nLastKey!=27
   nLin:=(nPg:=0)
   SetDefault(aReturn,"SF3")
   RptStatus({|lCanc| Impressao(@lCanc)})
Endif
return

Static Procedure cabec_iva(tipo)
nPg++
@001,000 psay trim(SM0->M0_NOMECOM)
@001,pcol()+2 psay "R.F.C. "+transf(SM0->M0_CGC,pesqpict("SA1","A1_CGC"))
if tipo==3
   @002,059 psay "Resumen I.V.A."
else
    @002,058 psay "Libro de "+if(mv_par03==1,"Ventas","Compras")+" (I.V.A.)"
    if tipo>0
       @002,pcol()+1 psay " - Resumen"
    endif   
endif    
@003,000 psay date()
@003,124 psay "Pag "+strzero(nPg,4)
@004,000 psay replicate("-",132)
if tipo==0
   @005,000 psay "Factura"
   @005,011 psay "Emission"
   @005,021 psay if(mv_par03==1,"Cliente","Proveedor")
   @005,043 psay "R.F.C."
   @005,059 psay "Total Factura"
   @005,079 psay "Gravadas"
   @005,095 psay "Exentas"
   @005,111 psay "I.V.A."
   @005,123 psay "Retencion"
elseif tipo==3
       @005,000 psay "Impuesto"
       @005,054 psay "Venta"
       @005,072 psay "Compra"
else
    @005,000 psay "Impuesto"
    @005,054 psay "Valor"
endif
@006,000 psay replicate("=",132)
nLin:=7
return

Static Procedure Impressao(lCanc)
local aImpEntr:={},aImpSaida:={},aResumo
local nTotTot:=0,nTotBas:=0,nTotImp:=0,nTotRet:=0,nTotIse:=0,;
      nTot:=0,nBas:=0,nImp:=0,nRet:=0,nIse:=0,nG,nGG,nPrinc,nSecun,;
      nPosAliq,nPos
local cEsp:="",cCond,cNF,cClie,cTipMov
local dEnt
local lCancelada

SFC->(dbsetorder(2))
dbselectarea("SF3")
dbgotop()
cCond:="!eof() .and. SF3->F3_FILIAL=='"+xfilial("SF3")+"'"
if !empty(mv_par01) 
   cCond+=" .and. SF3->F3_ENTRADA>=mv_par01"
   dbseek(xfilial("SF3")+dtos(mv_par01),.t.)
endif
if !empty(mv_par02) 
   cCond+=" .and. SF3->F3_ENTRADA<=mv_par02"
endif
SetRegua(RecCount())
while &(cCond) 
      if mv_par03<3
         cabec_iva(0)
      endif   
      while nLin<60 .and. &(cCond) 
            cConc:=if(lCanc,".F.",cCond)
            cNF:=F3_NFISCAL
            cCLie:=F3_CLIEFOR+F3_LOJA
            dEnt:=F3_ENTRADA
            nTot:=(nBas:=(nRet:=(nImp:=(nIse:=0))))
            cEsp:=left(upper(trim(F3_ESPECIE)),2)
            cTipMov:=F3_TIPOMOV         
            if (lCancelada:=(!empty(SF3->F3_DTCANC)))
               dbskip()
               incregua()
            else   
                while &(cCond) .and. F3_ENTRADA==dEnt .and. (F3_CLIEFOR+F3_LOJA)==cClie .and. F3_NFISCAL==cNF
                      cConc:=if(lCanc,".F.",cCond)
                      nTot+=F3_VALCONT
                      if F3_BASIMP1==0
                         nIse+=F3_VALCONT
                      else
                          nBas+=F3_BASIMP1
                          nImp+=F3_VALIMP1
                          nRet+=F3_VALIMP2
                      endif                       
                      PosImpIVA( @aTES, SF3->F3_TES)  // Posiciona o SFB respectivo 
                      if SF3->F3_TIPOMOV=="C"
                         if (nPos:=ascan(aImpEntr,{|x| x[1]==SFB->FB_CODIGO}))>0
                            if (nPosAliq:=ascan(aImpEntr[nPos,2],{|x| (x[2]==SF3->F3_ALQIMP1)}))==0
                               aadd(aImpEntr[nPos,2],{SF3->F3_BASIMP1,SF3->F3_ALQIMP1,SF3->F3_VALIMP1,SF3->F3_VALIMP2})     
                            else
                                if cEsp=="NC"  
                                   aImpEntr[nPos,2,nPosAliq,1]-=SF3->F3_BASIMP1
                                   aImpEntr[nPos,2,nPosAliq,3]-=SF3->F3_VALIMP1
                                   aImpEntr[nPos,2,nPosAliq,4]-=SF3->F3_VALIMP2
                                else
                                    aImpEntr[nPos,2,nPosAliq,1]+=SF3->F3_BASIMP1
                                    aImpEntr[nPos,2,nPosAliq,3]+=SF3->F3_VALIMP1
                                    aImpEntr[nPos,2,nPosAliq,4]+=SF3->F3_VALIMP2
                                 endif    
                            endif 
                         else
                             aadd(aImpEntr,{SFB->FB_CODIGO,{{SF3->F3_BASIMP1,SF3->F3_ALQIMP1,SF3->F3_VALIMP1,SF3->F3_VALIMP2}}})     
                         endif
                      else
                          if (nPos:=ascan(aImpSaida,{|x| x[1]==SFB->FB_CODIGO}))>0
                             if (nPosAliq:=ascan(aImpSaida[nPos,2],{|x| (x[2]==SF3->F3_ALQIMP1)}))==0
                                aadd(aImpSaida[nPos,2],{SF3->F3_BASIMP1,SF3->F3_ALQIMP1,SF3->F3_VALIMP1,SF3->F3_VALIMP2})     
                             else
                                 if cEsp=="NC"  
                                    aImpSaida[nPos,2,nPosAliq,1]-=SF3->F3_BASIMP1
                                    aImpSaida[nPos,2,nPosAliq,3]-=SF3->F3_VALIMP1
                                    aImpSaida[nPos,2,nPosAliq,4]-=SF3->F3_VALIMP2
                                 else
                                     aImpSaida[nPos,2,nPosAliq,1]+=SF3->F3_BASIMP1
                                     aImpSaida[nPos,2,nPosAliq,3]+=SF3->F3_VALIMP1
                                     aImpSaida[nPos,2,nPosAliq,4]+=SF3->F3_VALIMP2
                                 endif    
                             endif 
                          else
                              if cEsp=="NC"
                                 aadd(aImpSaida,{SFB->FB_CODIGO,{{-SF3->F3_BASIMP1,-SF3->F3_ALQIMP1,-SF3->F3_VALIMP1,-SF3->F3_VALIMP2}}})     
                              else   
                                  aadd(aImpSaida,{SFB->FB_CODIGO,{{SF3->F3_BASIMP1,SF3->F3_ALQIMP1,SF3->F3_VALIMP1,SF3->F3_VALIMP2}}})     
                              endif    
                          endif           
                      endif   
                      dbskip()
                      incregua()
                enddo    
            endif
            if !lCanc
               if if(mv_par03==3,.f.,cTipMov==if(mv_par03==1,"V","C"))
                  if mv_par03==1
                     SA1->(dbseek(xfilial("SA1")+cCLie))
                  else   
                      SA2->(dbseek(xfilial("SA2")+cCLie))
                  endif
                  @nLin,000 psay cNF picture pesqpict("SF3","F3_NFISCAL")
                  @nLin,007 psay if(cEsp=="NC","CR",if(cEsp=="ND","DB","FA"))
                  @nLin,010 psay dEnt
                  @nLin,021 psay if(mv_par03==1,left(SA1->A1_NOME,21),left(SA2->A2_NOME,21))    
                  @nLin,043 psay if(mv_par03==1,transf(SA1->A1_CGC,pesqpict("SA1","A1_CGC")),transf(SA2->A2_CGC,pesqpict("SA2","A2_CGC")))
                  if lCancelada
                     @nLin++,59 psay "C A N C E L A D A"
                  else   
                     if cEsp=="NC"
                        nTot=-nTot
                        nBas=-nBas
                        nImp=-nImp
                        nIse=-nIse
                        nRet=-nRet
                     endif   
                     @nLin,058 psay nTot picture pesqpict("SF3","F3_VALCONT",14,1)
                     @nLIn,073 psay nBas picture pesqpict("SF3","F3_BASIMP1",14,1)
                     @nLin,088 psay nIse picture pesqpict("SF3","F3_BASIMP1",14,1)  
                     @nLin,103 psay nImp picture pesqpict("SF3","F3_VALIMP1",14,1)
                     @nLin++,118 psay nRet picture pesqpict("SF3","F3_VALIMP2",14,1)
                     nTotTot+=nTot
                     nTotBas+=nBas
                     nTotImp+=nImp
                     nTotIse+=nIse
                     nTotRet+=nRet
                  endif
               endif        
            endif
      enddo
enddo
if lCanc
   @++nLin,000 psay "<<<<<< Cancelado por el operador. >>>>>>"
else   
    if (nTotTot+nTotBAS+nTotImp+nTotRet)<>0
       @++nLin,038 psay "TOTAL"
       @nLin,058 psay nTotTot picture pesqpict("SF3","F3_VALCONT",14,1)
       @nLin,073 psay nTotBas picture pesqpict("SF3","F3_BASIMP1",14,1)
       @nLin,088 psay nTotIse picture pesqpict("SF3","F3_BASIMP1",14,1)
       @nLin,103 psay nTotImp picture pesqpict("SF3","F3_VALIMP1",14,1)
       @nLin,118 psay nTotRet picture pesqpict("SF3","F3_VALIMP2",14,1)   
    endif 
    //Impressao do resumo------------------------------------------
    nTotImp:=0
    nTotTot:=0
    nLin:=61
    aResumo:={}
    if mv_par03==3
       for nG:=1 to len(aImpSaida)
           aadd(aResumo,{aImpSaida[nG][1],{}})
           for nGG:=1 to len(aImpSaida[nG][2])
               aadd(aResumo[len(aResumo)][2],{aImpSaida[nG][2][nGG][2],aImpSaida[nG][2][nGG][1],aImpSaida[nG][2][nGG][3],0,0})
           next    
       next
       for nG:=1 to len(aImpEntr)
           if (nPos:=ascan(aResumo,{|x| x[1]==aImpEntr[nG][1]}))==0
              aadd(aResumo,{aImpEntr[nG][1],{}})
              nPos:=len(aResumo)
           endif
           for nGG:=1 to len(aImpEntr[nG][2])
               if (nPosAliq:=ascan(aResumo[nPos,2],{|x| (x[1]==aImpEntr[nG][2][nGG][2])}))==0
                  aadd(aResumo[nPos][2],{aImpEntr[nG][2][nGG][2],0,0,aImpEntr[nG][2][nGG][1],aImpEntr[nG][2][nGG][3]})
               else
                   aResumo[nPos][2][nPosAliq][4]+=aImpEntr[nG][2][nGG][1]
                   aResumo[nPos][2][nPosAliq][5]+=aImpEntr[nG][2][nGG][3]
               endif    
           next    
       next
       for nG:=1 to len(aResumo)
           SFB->(dbseek(xfilial("SFB")+aResumo[nG][1]))
           for nGG:=1 to len(aResumo[nG][2])
               if nLin>60 
                  cabec_iva(3)
               endif
               if (aResumo[nG][2][nGG][2]+aResumo[nG][2][nGG][4])<>0 
                  @nLin,000 psay trim(SFB->FB_DESCR)+" ("+str(aResumo[nG][2][nGG][1],6,2)+"%)"
                  @nLin,042 psay aResumo[nG][2][nGG][3] picture pesqpict("SF3","F3_BASIMP1",17,1)
                  @nLin++,061 psay aResumo[nG][2][nGG][5] picture pesqpict("SF3","F3_BASIMP1",17,1)
                  nTotImp+=aResumo[nG][2][nGG][3]
                  nTotTot+=aResumo[nG][2][nGG][5]
               endif    
           next
       next   
       if (nTotImp+nTotTot)<>0
          @++nLin,027 psay "TOTAL"
          @nLin,042 psay nTotImp picture pesqpict("SF3","F3_BASIMP1",17,1)
          @nLin,061 psay nTotTot picture pesqpict("SF3","F3_BASIMP1",17,1)
          nLin:=nLin+2
          @nLin,016 psay "(FAVOR O CONTRA)"
          @nLin,042 psay nTotTot-nTotImp picture pesqpict("SF3","F3_BASIMP1",17,1)
          @nLin,062 psay "(COMPRA - VENDA)"
       endif   
    else
        nPrinc:=if(mv_par03==1,len(aImpSaida),len(aImpEntr))
        for nG:=1 to nPrinc
            SFB->(dbseek(xfilial("SFB")+if(mv_par03==1,aImpSaida[nG][1],aImpEntr[nG][1])))
            nSecun:=len(if(mv_par03==1,aImpSaida[nG][2],aImpEntr[nG][2]))
            for nGG:=1 to nSecun
                if nLin>60 
                   cabec_iva(mv_par03)
                endif
                if mv_par03==1
                   if aImpSaida[nG][2][nGG][1]<>0
                      @nLin,000 psay trim(SFB->FB_DESCR)+" ("+str(aImpSaida[nG][2][nGG][2],6,2)+"%)"
                      @nLin++,042 psay aImpSaida[nG][2][nGG][3] picture pesqpict("SF3","F3_BASIMP1",17,1)
                      nTotImp+=aImpSaida[nG][2][nGG][3]
                   endif   
                elseif mv_par03==2   
                       if aImpEntr[nG][2][nGG][1]<>0
                          @nLin,000 psay trim(SFB->FB_DESCR)+" ("+str(aImpEntr[nG][2][nGG][2],6,2)+"%)"
                          @nLin++,042 psay aImpEntr[nG][2][nGG][3] picture pesqpict("SF3","F3_BASIMP1",17,1)
                          nTotImp+=aImpEntr[nG][2][nGG][3]
                       endif   
                endif       
            next
        next   
        if nTotImp<>0
           @++nLin,035 psay "TOTAL"
           @nLin,042 psay nTotImp picture pesqpict("SF3","F3_BASIMP1",17,1)
        endif   
    endif
endif    
Set Device To Screen
If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(cPrn)
Endif
MS_FLUSH()
return

/*_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ ValidPerg()¦ Autor ¦                     ¦ Data ¦ 06/07/98 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Verifica as perguntas incluíndo-as caso näo existam        ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ LIBR010 - Listado de IVA Compras ou Ventas.                ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

Static Function ValidPerg()
Local i:=0, j:=0

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := "LIBMEX"
aRegs:={}

aAdd(aRegs,{cPerg,"01","Da Data  ?","¨Fecha Inicio       ?","From Date? ","mv_ch1","D",8,0,0,"G","","mv_par01","","","","01/01/01","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate Data ? ","¨Fecha Fin         ?","To Date  ?","mv_ch2","D",8,0,0,"G","","mv_par02","","","","31/12/10","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Do Livro ?","¨Libro de           ?","From Fiscal Books? ","mv_ch3","N",1,0,0,"C","","mv_par03","IVA Vendas","IVA Ventas","IVA Sales","","","IVA Compras","IVA Compras","IVA Purchase","","","Resumen","Resumo","Summary","",""})
aAdd(aRegs,{cPerg,"04","Considera Anuladas?","¨Considera Anuladas ?","Consider deleted?","mv_ch4","N",1,0,0,"C","","mv_par04","Sim","Si","Yes","","","Nao","No","No","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
RETURN



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PosImpIVA ºAutor  ³Microsiga           º Data ³  07/24/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Posiciona no registro do SFB respectivo ao imposto1 - IVA  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PosImpIVA(aTES, cTES)
Local nPosTES := 0
nPosTES := aScan( aTES, {|x| x[1]==cTES} )
If nPosTES = 0
	SFC->(dbSeek(xFilial("SFC")+cTES))
	While !(SFC->(Eof())) .And. SFC->FC_TES==cTES
		SFB->(dbSeek(xfilial("SFB")+SFC->FC_IMPOSTO))
	 	If SFB->FB_CPOLVRO=="1"
			SFC->(dbGoBottom())
		EndIf
		SFC->(dbSkip())
	EndDo    
	Aadd( aTES, {cTES, SFB->(Recno()) } )
Else
	SFB->(dbGoTo(aTES[nPosTES][2]))
EndIf	
Return
