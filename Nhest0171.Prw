/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST017        ³ Alexandre R. Bento    ³ Data ³ 21.09.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao da Relação do RMR(relatorio mensal de refugo)   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padrao para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "Rwmake.ch"      
#include "Topconn.ch"

User Function NhEst017()  

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,cQuery,cQuery1,cFornece,cLoja,cCod,nTotal")
SetPrvt("M_PAG,aMRM,aMeses,x,nTotRef,cLocal,lOK,nRMR")

cString   :="SD3"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir o ")
cDesc2    := OemToAnsi("Relatorio Mensal de Refugo")
cDesc3    := OemToAnsi(" ")
tamanho   :="M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  :="NHEST017"
nLastKey  := 0
titulo    :="RELATORIO MENSAL DE REFUGO"
Cabec1    :=""
cabec2    :=""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     :="NHEST017"          //Nome Default do relatorio em Disco
_cPerg    := "EST017"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)
nTotal    := 0
aRMR      := {}          
//eses	  := {"Janeiro","Fevereiro",OemToAnsi("Março"),"Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
nTotRef   := 0
cLocal    := " "
cFornece  := " "
cLoja     := " "
cCod      := " "                               
lOK       := .F.
// Parametros Utilizados
// mv_par01 = Data de emisao inicial
// mv_par02 = Data de emisao final
// mv_par03 = codigo do produto inicial
// mv_par04 = codigo do produto final                                     
// mv_par05 = Operacao inicial
// mv_par06 = Operacao final
// mv_par07 = Fornecedor inicial
// mv_par08 = Fornecedor final
// mv_par09 = Loja inicial
// mv_par10 = Loja final
// mv_par11 = Gera Numeração (Sim/Nao)


// AjustaSX1() // Verifica os parametros

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho) 
//SetPrint("SZ7",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")
If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif
             
nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]                   

If Month(mv_par01) <> Month(mv_par02)
   MsgBox(OemToAnsi("Atenção Relatório só pode sair dentro do mês","Refugo","STOP"))
   Return
Endif

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
TMP->(DbGoTop())
If Empty(TMP->D3_COD)
   MsgBox("Nenhum produto foi encontrado","Atencao","STOP")
   Close TMP
   Return
Endif     

Processa( {|| fGera() },"Slecionando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")
Close TMP

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
   ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function Gerando()    

   cQuery := "SELECT SD3.D3_COD,SD3.D3_TM,MONTH(SD3.D3_EMISSAO) AS 'MES',YEAR(SD3.D3_EMISSAO),SD3.D3_LOCAL,SD3.D3_OPERACA,SB1.B1_CODAP5,SB1.B1_DESC,SD3.D3_FORNECE,SD3.D3_LOJA,SUM(SD3.D3_QUANT) AS 'QTDE'" 
   cQuery += " FROM " + RetSqlName( 'SD3' ) +" SD3, " + RetSqlName( 'SB1' ) +" SB1"
   cQuery += " WHERE SD3.D3_FILIAL = '" + xFilial("SD3")+ "'"
   cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "'"
   cQuery += " AND SD3.D3_EMISSAO >= '" + Dtos(mv_par01) + "' AND SD3.D3_EMISSAO <= '" + Dtos(mv_par02) +"'"   
   cQuery += " AND SD3.D3_COD BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"                            
   cQuery += " AND CAST(SD3.D3_OPERACA AS NUMERIC(3)) BETWEEN " + Str(mv_par05,3) + " AND " + Str(mv_par06,3)+" " 
   cQuery += " AND SD3.D3_FORNECE BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "'" 
   cQuery += " AND SD3.D3_LOJA BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "'" 
   cQuery += " AND SD3.D3_COD = SB1.B1_COD AND SD3.D3_TM = '499' AND SD3.D3_LOCAL IN ('99','00')"  
   cQuery += " AND SD3.D3_LOCORIG NOT IN ('02','03') AND SD3.D_E_L_E_T_ <> '*'"
   cQuery += " AND SB1.D_E_L_E_T_ <> '*' AND SD3.D3_ESTORNO <> 'S'" 
   cQuery += " GROUP BY SD3.D3_COD,SD3.D3_TM,MONTH(SD3.D3_EMISSAO),YEAR(SD3.D3_EMISSAO),SD3.D3_LOCAL,SD3.D3_OPERACA,SB1.B1_CODAP5,SB1.B1_DESC,SD3.D3_FORNECE,SD3.D3_LOJA"
   cQuery += " ORDER BY SD3.D3_COD,MONTH(SD3.D3_EMISSAO),SD3.D3_FORNECE,SD3.D3_LOJA,SD3.D3_LOCAL,SD3.D3_OPERACA ASC"

//   MemoWrit('C:\TEMP\EST017.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"     
//	TcSetField("TMP","D3_EMISSAO","D")  // Muda a data de string para date    


Return

Static Function fGera()
titulo    += "  Data Inicial: "+Dtoc(mv_par01)+ " Ate " + Dtoc(mv_par02)
TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))                         
//cFornece := TMP->D3_FORNECE
//cLoja    := TMP->D3_LOJA
//cCod     := TMP->D3_COD
nTotal   := 0   


SZ9->(DbGotop())
SZ9->(DbSetOrder(1))     
While TMP->(!Eof())
   
   IncProc("Processando Produtos... " + TMP->D3_COD +"  "+TMP->D3_OPERACA)         
   nTotal := 0                                                                  
   If cCod+cFornece+cLoja <> TMP->D3_COD+TMP->D3_FORNECE+TMP->D3_LOJA
      cFornece := TMP->D3_FORNECE
      cLoja    := TMP->D3_LOJA
      cCod     := TMP->D3_COD     
     		
     	cQuery1 := "SELECT SUM(Z9_QUANT) AS 'TOTAL' FROM "+ RetSqlName( 'SZ9' )
		cQuery1 += " WHERE Z9_FILIAL = '" + xFilial("SZ9")+ "'"
		cQuery1 += " AND D_E_L_E_T_ <> '*'"
  	   cQuery1 += " AND Z9_DATA >= '" + Dtos(mv_par01) + "' AND Z9_DATA <= '" + Dtos(mv_par02) +"'"          
      cQuery1 += " AND Z9_COD =  '" + TMP->D3_COD + "'"         
      cQuery1 += " AND Z9_FORNECE BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "'"               	   
      cQuery1 += " AND Z9_LOJA BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "'"       
 	 //  MemoWrit('C:\TEMP\EST017A.SQL',cQuery1)
        //TCQuery Abre uma workarea com o resultado da query
     	TCQUERY cQuery1 NEW ALIAS "TRB"     
          
		TRB->(DbGoTop())
		If !Empty(TRB->TOTAL)       
  		    nTotal := TRB->TOTAL // Pega o total de produçao do SZ9
  		Endif    
		Close TRB //Fecha alias da cquery1                                                                       
		
   Endif
   
   x := Ascan(aRMR, {|x| x[1]+x[7]+x[8] == TMP->D3_COD+TMP->D3_FORNECE+TMP->D3_LOJA})
   If x <> 0 
      aRMR[x][10] += TMP->QTDE + nTotal
      nTotal := aRMR[x][10]
      Aadd(aRMR,{TMP->D3_COD,TMP->D3_LOCAL,TMP->D3_OPERACA,MesExtenso(TMP->MES),TMP->B1_CODAP5,TMP->B1_DESC,TMP->D3_FORNECE,TMP->D3_LOJA,TMP->QTDE,nTotal})      
   Else 
      Aadd(aRMR,{TMP->D3_COD,TMP->D3_LOCAL,TMP->D3_OPERACA,MesExtenso(TMP->MES),TMP->B1_CODAP5,TMP->B1_DESC,TMP->D3_FORNECE,TMP->D3_LOJA,TMP->QTDE,TMP->QTDE+nTotal})      
   Endif

   TMP->(Dbskip())
Enddo

Return

Static Function RptDetail()       

//aRMR := ASort(aRMR,,, { |x, y| x[1]+x[2]+x[7]+x[8]+x[3] < y[1]+y[2]+y[7]+y[8]+y[3]}) //ordena por produto,local,operacao,Fornecedor,loja
ProcRegua(Len(aRMR))                         

Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo) 


@ Prow() + 1, 001 Psay "Codigo : " + Alltrim(aRMR[1][1]) +"  Desenho: " +Alltrim(aRMR[1][5])+ " - " + Subs(Alltrim(aRMR[1][6]),1,30)
SA2->(Dbseek(xfilial("SA2")+aRMR[1][7]+aRMR[1][8]))
@ Prow() + 1, 001 Psay "Fornecedor: " + aRMR[1][7]+" - " + Subs(Alltrim(SA2->A2_NOME),1,30)

// Parametro gera numeração na RMR sim / nao
If mv_par11 ==1 //sim
	
	nRMR := Val(GetMv("MV_RMR"))+1 //Pega o numero da RMR mais 1
	
	//Grava a proximo numero
	SX6->(DbSeek(xFilial()+"MV_RMR"))
	RecLock("SX6",.F.)
	   SX6->X6_CONTEUD:= Alltrim(StrZero(nRMR))
	MsUnlock("SX6")
   //Imprime o numero da RMR
   @ Prow() , 100 Psay "Numero da RMR : " + Transform(nRMR,"@E 999999") 
Endif

@ Prow() + 1, 001 Psay OemToAnsi("Mês : ") + aRMR[1][4] +" / " +StrZero(Year(mv_par01),4)+Space(20)+"Material Consignado" 
// @ Prow() + 1, 001 Psay OemToAnsi("Mês : ") + aRMR[1][4]+" / " +StrZero(Year(mv_par01),4) +Space(20)+"Material Consignado" 
@ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes do total do rodape da pagina   
@ Prow() + 2, 001 Psay OemToAnsi("Total de Peças Produzidas :   ") + Transform(aRMR[1][10],"@E 999,999")      
//@ Prow() + 2, 001 Psay OemToAnsi("Total de Peças Refugadas : ") 

cCod     := aRMR[1][1]
cFornece := aRMR[1][7]
cLoja    := aRMR[1][8]

//aRMR[1][1]+aRMR[1][7]+aRMR[1][8]
For x:=1 to Len(aRMR)
   
   IncProc("Imprimindo Produtos... " )
     
   If Prow() > 58
      _nPag := _nPag + 1
      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)        
   Endif
   
   If cCod+cFornece+cLoja <> aRMR[x][1]+aRMR[x][7]+aRMR[x][8]
      // Imprime o totalizador pois é outro fornecedor
      @ Prow() + 1, 024 Psay "Total: " + Transform(nTotRef,"@E 999,999")     
      @ 46, 001 Psay __PrtThinLine() // Linha antes do total do rodape da pagina   
	  @ 47, 001 Psay OemToAnsi("OBSERVAÇÕES")
      @ 52, 001 Psay __PrtThinLine() // Linha antes do total do rodape da pagina    
      @ 53, 001 Psay OemToAnsi("VISTOS ")                                                                   
      @ 54, 001 Psay Space(15)+ "Nome : _______________________"+Space(20)+ "Nome : __________________________________ "  
      @ 56, 001 Psay Space(15)+ "RG   : _______________________"+Space(20)+ "RG   : __________________________________ "  
      @ 58, 001 Psay Space(15)+ "ASS  : _______________________"+Space(20)+ "ASS  : __________________________________ "  
      @ 59, 001 Psay Space(20)+ "        Cliente        "+Space(26)+ "    Residente   -   Fornecedor "  
      @ 62, 001 Psay Space(20)+ "______________________"+Space(21)+ "___________________________"  
      @ 63, 001 Psay Space(20)+ "    Analista - WHB    "+Space(21)+ "     Responsavel - WHB"  

      cCod     := aRMR[x][1]
      cFornece := aRMR[x][7]
      cLoja    := aRMR[x][8]                            
      nTotal   := 0
      nTotRef  := 0
      _nPag    := _nPag + 1
      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)        
//	  SZ9->(Dbseek(xFilial('SZ9')+Dtos(mv_par01)+cCod+mv_par07+mv_par09))
//         While SZ9->(!EOF()) .And. SZ9->Z9_COD == cCod .And. SZ9->Z9_FORNECE == cFornece .And.;
//            SZ9->Z9_LOJA == cLoja .And. SZ9->Z9_DATA >= mv_par01 .And. SZ9->Z9_DATA <= mv_par02
//            nTotal += SZ9->Z9_QUANT
//            SZ9->(Dbskip())
//         Enddo                     

         @ Prow() + 1, 001 Psay "Codigo : " + Alltrim(aRMR[x][1]) +"  Desenho: " +Alltrim(aRMR[x][5])+ " - " + Subs(Alltrim(aRMR[x][6]),1,30)
         SA2->(Dbseek(xfilial("SA2")+aRMR[x][7]+aRMR[x][8]))
         @ Prow() + 1, 001 Psay "Fornecedor: " + aRMR[x][7]+" - " + Subs(Alltrim(SA2->A2_NOME),1,30)
         @ Prow() + 1, 001 Psay OemToAnsi("Mês : ") + aRMR[x][4] +" / " +StrZero(Year(mv_par01),4)+Space(20)+"Material Consignado" 
//         @ Prow() + 1, 001 Psay OemToAnsi("Mês : ") + aRMR[x][4] +" / " +StrZero(Year(mv_par01))+Space(20)+"Material Consignado" 
         @ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes do total do rodape da pagina   
         @ Prow() + 2, 001 Psay OemToAnsi("Total de Peças Produzidas :   ") + Transform(aRMR[x][10],"@E 999,999")      
//         @ Prow() + 2, 001 Psay OemToAnsi("Total de Peças Refugadas : ") 
         cLocal := " " // Zera para imprimir o total de refugo
   Endif
   
   If cLocal <> aRMR[x][2]               
      cLocal := aRMR[x][2]               
      If aRMR[X][2] == '00' 
         If x <> 1 .And. nTotRef > 0
            @ Prow() + 1, 024 Psay "Total: "+ Transform(nTotRef,"@E 999,999")
            nTotRef := 0
         Endif
         @ Prow() + 2, 001 Psay OemToAnsi("Total de Refugo de Fundido : ")    
      Elseif aRMR[x][2] == '99'
             If x <> 1 .And. nTotRef > 0
                @ Prow() + 1, 024 Psay "Total: " + Transform(nTotRef,"@E 999,999")
                nTotRef := 0
             Endif
         @ Prow() + 2, 001 Psay OemToAnsi("Total de Refugo de Usinagem : ")    
      Endif
   Endif	      
   If !lOK
      @ Prow() + 1, 015 Psay OemToAnsi("Operação: ") +aRMR[x][3] + "  -"  + Transform(aRMR[x][9],"@E 999,999")
      lOK := .T.
   Else 
      @ Prow()  , 050 Psay OemToAnsi("Operação: ") +aRMR[x][3] + "  -"  + Transform(aRMR[x][9],"@E 999,999")   
      lOK := .F.
   Endif   
   nTotRef += aRMR[x][9]
   TMP->(Dbskip())
Next
@ Prow() + 1, 024 Psay "Total: " + Transform(nTotRef,"@E 999,999")     
                                                                       
@ 46, 001 Psay __PrtThinLine() // Linha antes do total do rodape da pagina   
@ 47, 001 Psay OemToAnsi("OBSERVAÇÕES")
@ 52, 001 Psay __PrtThinLine() // Linha antes do total do rodape da pagina    
@ 53, 001 Psay OemToAnsi("VISTOS ")                                                                   
@ 54, 001 Psay Space(15)+ "Nome : _______________________"+Space(20)+ "Nome : __________________________________ "  
@ 56, 001 Psay Space(15)+ "RG   : _______________________"+Space(20)+ "RG   : __________________________________ "  
@ 58, 001 Psay Space(15)+ "ASS  : _______________________"+Space(20)+ "ASS  : __________________________________ "  
@ 59, 001 Psay Space(20)+ "        Cliente        "+Space(26)+ "    Residente   -   Fornecedor "  
@ 62, 001 Psay Space(20)+ "______________________"+Space(21)+ "___________________________"  
@ 63, 001 Psay Space(20)+ "    Analista - WHB    "+Space(21)+ "     Responsavel - WHB"  

Return(nil)      
  