#include "rwmake.ch"     

user Function NHAUT001()   
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ NHAUT001 ³ Autor ³ Alexandre R. Bento    ³ Data ³ 20.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Executa Leitura da gravadora do cubo/carcaça e cabeçote    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Rastreabilidade de produção                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Local nHandle := 0
Local xx 
Local vezes    := 0
Local nHdl1    := 0 
Local cText    := space(5000)                 
Local _cAux    := space(20)                 
Local _nCodc4  := 0                 
Local lAborta  := .T.         
Local _lFlag   := .F.         
Private nHdll  := 0  
MSOpenPort(nHdll,"COM4:19200,N,8,1") 

While lAborta
    inkey(2)
	xx := MsRead(nHdll,@cText)      

   if !xx
  	  msgbox("Nao foi possivel pegar informações da porta",,"STOP")
   Endif                   
   // 27Y272710242727174/06 T2
      
   _cLer := Space(15)
   If xx 
      If Len(Alltrim(cText)) > 0
	     If Len(Alltrim(cText)) < 10 .And. Len(Alltrim(_cAux)) == 0
	        _cAux :=Alltrim(cText)
	     Else
	        cText := _cAux + cText
            _cAux := Space(20)
	        cText := Alltrim(cText)          
	  
		   	for _n := 1 to len(ctext) 
		   	   //Desconsidera as teclas       // 47 --> /    32 --> espaco   34 --> "  13 -->Enter    Y --> 89        27 --> ESC   42 -->* 
		       If !Strzero(Asc(Subs(ctext,_n,1)),2)$"27/13/89/47/32/34/30/38/42"
		          _cLer:= Alltrim(_cLer) + Subs(ctext,_n,1)//Monta Numero serial sequencial
		          If Subs(_cLer,10,1) == "T" .And. Len(Alltrim(_cLer)) == 11 //Grava e limpa a variavel
		             Alert(" Codigo Correto " + Subs(_cLer,1,11))
		             alert(" Leiura completa " + cText)
		             fGrava() //Grava informações da porta COM4
		             _nCodc4 := Val(Subs(_cLer,1,4))
		             _cLer := Space(15)
		          Endif  
		          If _lFlag
		             _cLer  := Space(15)
		             _lFlag := .F.		          
		          Endif
		          If !_lFlag 
			          If At("T",_cLer) > 0 .And. At("T",_cLer) < 10 
	                     Alert(" Problema na Pesquisa da Porta Serial " + _cLer)		           
			             _lFlag := .T. // Leitura com problema
			          Endif
			      Endif
			   Endif   
		    Next _n    
		    
		    If Len(Alltrim(_cLer)) > 1 .And. Len(Alltrim(_cLer)) < 11
		       _cAux := _cLer //atribui conteudo para variavel auxuliar
		       _cLer := Space(15)
		    Endif
		    
		 Endif         
        // Alert(" Leitura Aux  "+_cAux)		 
        // Alert(" Leitura Ler  "+_cLer)		          
	  Endif	      
   Endif
  cText := Space(5000)
//   If Alltrim(cText)$"T0"
//      Alert(cText)
//      cText := " "
//   Endif
//At("T",_cLer)
   
  //	   Endif     
//       Alert(" porta ")
//  	   If !Empty(cText)
// 	      lAborta:=.F.
//  	      exit
//  	   Endif

Enddo	
MsCloseport(nHdll)    
Return (.t.)                  

Static Function fGrava()
//Verifica o arquivo da carcaça para leitura
Local cArqCa1 := "\\VISTEON04\MARPOSS\SPOOLER\3550_BA.M00"
Local cArqCa2 := "\\VISTEON04\MARPOSS\SPOOLER\3550_EA.M00"
Local _cCod   := Space(15)  
Local cArqC4  := Space(39)  
Local aMeses  := {"Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez"}
Local ni

If File(cArqCa1)
   cArqC4 := cArqCa1      
Else
    If File(cArqCa2)   
       cArqC4 := cArqCa2    
    Endif
Endif

While File(cArqC4)                       
   cArqC4 := SUBS(cArqC4,1,37)+StrZero(Val(Right(cArqC4,2))+1,2)
   If !File(cArqC4)   
      cArqC4 := SUBS(cArqC4,1,37)+StrZero(Val(Right(cArqC4,2))-1,2)   
      exit //pega o ultimo arquivo gerado no marposs e sai do while
   Endif
Enddo                  

//verifica a existencia do arquivo para leitura
If (File(cArqC4))
   ft_fuse(cArqC4)//³Efetua a Abertura do Arquivo 
   ft_fgotop()
   While( !ft_feof())
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Neste momento, ja temos uma linha lida. Gravamos os valores ³
    //³ obtidos retirando-os da linha lida.                         ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      cBuff := ft_freadln() //pega linha a linha do arquivo texto
      If SubStr(cBuff,001,3) == "M A"            
         ni := Ascan(aMeses, {|x| x[1] == SubStr(cBuff,063,03)})
      
         ALERT(" Data  "+SubStr(cBuff,060,11))
         ALERT(" Hora  "+SubStr(cBuff,071,10))         
      Endif
      If SubStr(cBuff,001,2) == "PE"      
         ALERT(" Codigo da Peca "+SubStr(cBuff,021,2))
         If SubStr(cBuff,021,2) == "BA"
            _cCod := "VU13.4.211.00" //Carcaça BA   
         ElseIf SubStr(cBuff,021,2) == "EA"                 
                _cCod := "VU13.4.185.01" //Carcaça EA               
         ElseIf SubStr(cBuff,021,2) == "AA"                 
            _cCod := "VU13.4.185.00" //Carcaça AA               
         Endif   
              
      Endif             
      Alert("Codigo  "+_cCod) 
      
      /*
      If Val(SubStr(cBuff,001,2)) >= 01       
	      
	     Reclock("SZH",.T.)
	        SZH->ZH_FILIAL := xFilial("SZH")
	        SZH->ZH_SERIAL := Strzero(_cCodc4,4)
            SZH->ZH_PRODUTO:= _cCod
	        SZH->ZH_ITEM   := Val(SubStr(cBuff,001,2))
	        SZH->ZH_DESC   := SubStr(cBuff,004,80)
          //  SZH->ZH_MAQUINA := cIDMaq    // Codigo da maquina
	     MsUnlock("SZH")
	
	  Endif
	  */
      ft_fskip()
   EndDo
   ft_fuse() //fecha o arquivo
Endif   


Return

     // If Asc(Subs(ctext,_n,1)) <> 27 .And. Asc(Subs(ctext,_n,1)) <> 89 .And.;
      //    Subs(ctext,_n,1) <>  " " .And. Asc(Subs(ctext,_n,1)) <> 13 .And.;
      //    Asc(Subs(ctext,_n,1)) <> 47                  

//		          If Len(Alltrim(_cLer))>= 2//Verifica se tem erro na leitura da porta
//			          If Subs(_cLer,_n-1,1) == "T" .And. _n < 10 //Grava e limpa a variavel
//			             Alert(" Problema na Pesquisa da Porta Serial " + Subs(_cLer,1,11))
//			             _cLer := Space(15)
//			          Endif            
//		          Endif


Static Function LeE_peso(lFim)
Local lEnd := .f.
Private cText := "00000"
          
nVezes := 0

ProcRegua(10000)
While !lEnd

    If lFim  
       Exit 
    EndIf 
  	    	   
    MsRead(nHdll,@cText)                     
    nVezes ++  
    
  	if (val(substr(cText,at("p`",cText)+2,6)) >= 0 .and.  ;  
  	   at("p`",cText) != 0)                              
  	   cTemp := substr(cText,at("p`",cText)+2,6)
  	   nLok := .t.
  	   For nCT := 1 to 5
  	       //if RetAsc(substr(cTemp,nCT,1),1,.T.) < "0" .or. RetAsc(substr(cTemp,nCT,1),1,.T.) > "9"
  	       if substr(cTemp,nCT,1) < "0" .or. substr(cTemp,nCT,1)> "9"
  	          nLok := .f. 
  	       Endif
  	   Next
  	   if nLOK       
  	   	  cPeso := substr(cText,at("p`",cText)+2,6)
  	   	  //IncProc(cPeso) 	      
  	   	  IncProc("Peso Liquido na Balança: " + transform(val(cPeso)/1000,"@E 999,999,999.99999"))
 	   Endif   
  	Else    
  	
  	Endif
  	           	  
Enddo                                                   
 
Return