#include "rwmake.ch"

User Function MT120GRV()

SetPrvt("nRegSC7,cPed,x")
nRegSC7 := SC7->(Recno())      
cPed    := SC7->C7_NUM 
x       := 1

//nPosicao := aScan(aHeader,{|aPos| aPos[2] == "C1_JUST   "})
//cJust := Acols[i,nPosicao]

If Altera                
	SC7->(DbSeek(xFilial("SC7")+cPed+"01",.t.)) //filial+numero+item
	While SC7->C7_NUM == cPed                                       
	   
//	   nPos := aScan(aCols,{|aCols| aCols[2] == "C7_QUANT"})
	   // Inclusão do pedido no SZ2 historico de alterações de pedidos de compra
	   RecLock("SZ2",.T.)  //Atualizacao qdo foi alterado
      	SZ2->Z2_FILIAL  := xFilial("SZ2")
      	SZ2->Z2_PEDIDO  := cPed
	      SZ2->Z2_STATUS  := "ALTERADO"
	      SZ2->Z2_EMISSAO := Ddatabase
	      SZ2->Z2_DPRECO   := SC7->C7_PRECO // Preco Unitario de
	      SZ2->Z2_PPRECO   := Acols[x][7]   // Preco Unitario para	      
	      SZ2->Z2_DQUANT   := SC7->C7_QUANT // Qtde de
	      SZ2->Z2_PQUANT   := Acols[x][6]   // Qtde	para      
	      SZ2->Z2_DDATA    := SC7->C7_DATPRF// Data de Entrega de
	      SZ2->Z2_PDATA    := Acols[x][12]  // Data de Entrega para	      
     	   SZ2->Z2_PRODUTO  := SC7->C7_PRODUTO// Produto
  	      SZ2->Z2_ITEM     := SC7->C7_ITEM// Item
  	      SZ2->Z2_TIPO     := SC7->C7_TIPOPED // Tipo do pedido N=Normal e C=Complementar
    	MsUnLock("SZ2")
      x:=x+1
	   SC7->(Dbskip())
   Enddo

Endif
Dbgoto(nRegSC7)       

Return(.T.)
