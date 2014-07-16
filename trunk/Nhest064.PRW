/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST064  ³ Autor ³ Alexandre R. Bento     Data ³ 06/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Baixa Automatica do Tool Boss                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Almoxarifado                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "tbiconn.ch"
User Function nhest064()
                                    

local _cCod         := Space(15)
local _cDoc         := Space(06)
local _aTBoss       := {}
Private _aItem 		:= {}
Private _atotitem 	:= {}
Private _aCab  		:= {}
Private _dados      := {}

Private lMsHelpAuto := .t.  // se .t. direciona as mensagens de help
Private lMsErroAuto := .f. //necessario a criacao, pois sera
Private inclui      := .T.
Private cCC        := "401005"
Private cTM         := "501"            
SetPrvt("_cArquivo,_aStruct,_cTr1,lEnd,_aConsig,_aBaixa, _data1,_lGrava")


//-------------------------------------------------------------------------
//   NOME E CAMINHO DO ARQUIVO
//-------------------------------------------------------------------------
_cArquivo := "C:\AP8\TB.TXT"
lEnd      := .T.
_aConsig  := {}
_aBaixa   := {}

If !File(_cArquivo)
   MsgBox("Arquivo de Entrada nao Localizado: " + _cArquivo,"Arquivo Retorno","INFO")
   Return
Endif

//---------------------------------------------------------------------------------------------------------------
// FIZ A COPIA DO ARQUIVO TXT EM UM UNICO ARQUIVO DE TRABALHO NAO CONSEGUI FAZER COM A FUNCAO FREAD.
// PEGO LINHA A LINHA E CRIO 1 REGISTRO PARA CADA UMA
//---------------------------------------------------------------------------------------------------------------
  
_aStruct:={{ "TOO_DADOS","C",40,0}}
  
  
_cTr1 := CriaTrab(_aStruct,.t.)
USE &_cTr1 Alias TRB New Exclusive
Append From (_cArquivo) SDF

If MsgYesNo("Confirma Importacao ","Valores")
	fAtualiza()
Endif
DbCloseArea("TRB")
erase(_cTr1) 
Return

TRB->(DbGotop())        
while TRB->(!eof())                


enddo

Return
//--------------------------------------------------------------------------------------------------------
//  atualiza via mata241
//--------------------------------------------------------------------------------------------------------
Static Function fAtualiza()
LOCAL _cod,_sqtde,_cc,_data,x,_nLin,_ni,_cMsg,_aErro  //  VARIAVEIS LOCAIS QUE USEI PARA FAZER CONTROLE
Local cARQ  := FCreate("c:\ap8\critica.txt")
Local cNovaLinha := Chr(13) + Chr(10)
_cod    := SPACE(15)       
_sqtde 	:= SPACE(2)
_cMsg   := Space(100)
_qtde 	:= 0
_cc		:= space(09)
_data 	:= SPACE(10)
_novo 	:= space(04)
_consig := space(04)
_nLin   := 1
_aErro  := {}


SB1->(DbSetOrder(1)) //filial+cod	                          
SB2->(DbSetOrder(1)) //filial+cod+local	                          
TRB->(DbGotop())        
while TRB->(!eof())                
x :=1   //inicia a variavel de controle       
   _data1 := Space(10)
   SB1->(DbGotop())        
    //------------------------------------------------------------------------------------------------------
    //  esta parte vou refazer
    //  AQUI EU PEGUEI CADA REGISTRO DO ARQUIVO DE TRABALHO E SEPAREI NA VIRGULA.
    //------------------------------------------------------------------------------------------------------
    
	while substr(TRB->TOO_DADOS,x,1) <> ',' //Produto
	     _cod := Iif(Empty(_cod), substr(TRB->TOO_DADOS,x,1),_cod + substr(TRB->TOO_DADOS,x,1))
	     x = x+1
	enddo    

	x=x+1
	while substr(TRB->TOO_DADOS,x,1) <> ',' //qtde
	     _sqtde := _sqtde + substr(TRB->TOO_DADOS,x,1)
	     x = x+1
	enddo
	If val(_sqtde) == 0
       _cMsg := OemToAnsi("Linha "+Strzero(_nlin,4)+ " Qtde não Pode Ser Zero, Verifique !!!")  	
     //  Msgbox(_cMsg ,OemToAnsi("Atenção Erro Arquivo"),"STOP" )  	  
       Aadd(_aErro,{_cMsg})
	Endif

	
	x = x+1
	while substr(TRB->TOO_DADOS,x,1) <> ',' // centro de custo
	     _cc := Iif(Empty(_cc), substr(TRB->TOO_DADOS,x,1),_cc + substr(TRB->TOO_DADOS,x,1))	
	     x = x+1
	enddo
	If !ExistCpo("CTT",_cc)
       _cMsg := OemToAnsi("Linha "+Strzero(_nlin,4)+ " Centro de Custo não Encontrado no cadastro, Verifique !!!") 
    //   Msgbox(_cMsg ,OemToAnsi("Atenção Erro Arquivo"),"STOP" )  	  
       Aadd(_aErro,{_cMsg})
	Endif

	
	x = x+1
	while substr(TRB->TOO_DADOS,x,1) <> ',' .AND. x < 100
	     _data := Iif(Empty(_data), substr(TRB->TOO_DADOS,x,1),_data + substr(TRB->TOO_DADOS,x,1))		
	     x = x+1
	enddo
	
	If !Empty(_data)
	   for _ni:=1 to len(_data) //Valida possivel falta de digitos na data
	        
	       If _ni == 3
	          If subs(_data,_ni,1) <> '/'                        
                 _data1 := _data //variavel auxiliar
	             _data1 := Stuff(_data1,1,0,"0")  // Insere o primeiro caracter
	             If Subs(_data1,6,1) <> '/'
	                _data1:=Stuff(_data1,4,0,"0")  // Insere o quarto caracter	             
	                _data := _data1 // volta conteudo da variavel
	             Endif
	          Endif
	       Else
	           If _ni == 6
	              If Subs(_data,_ni,1) <> '/'
	                _data:=Stuff(_data,4,0,"0")  // Insere o quarto caracter	             	              
	              Endif
	           Endif
	       Endif   
	       
	       
	   Next _ni
	
	Endif   
	
	If Empty(_data)
       _cMsg := OemToAnsi("Linha "+Strzero(_nlin,4)+ " Data em Branco, Verifique !!!") 
      // Msgbox(_cMsg ,OemToAnsi("Atenção Erro Arquivo"),"STOP" )  	  
       Aadd(_aErro,{_cMsg})

    Endif   
	x = x+1

	while substr(TRB->TOO_DADOS,x,1) <> ',' .AND. x < 100
	     _consig := Iif(Empty(_consig), substr(TRB->TOO_DADOS,x,1),_consig + substr(TRB->TOO_DADOS,x,1))		
         If substr(TRB->TOO_DADOS,x,1) == ' '
            x = x+1         
            exit // força a saida do loop
         Endif
	     x = x+1
	enddo   

	If Empty(_consig)
       _cMsg  := OemToAnsi("Linha "+Strzero(_nlin,4)+ " Campo Consiguinação em Branco, Verifique !!!")
     //  Msgbox(_cMsg ,OemToAnsi("Atenção Erro Arquivo"),"STOP" )  	  
       Aadd(_aErro,{_cMsg})

    Endif   

	x = x+1	

	while substr(TRB->TOO_DADOS,x,1) <> ','  .AND. substr(TRB->TOO_DADOS,x,1) <> ' ' .And. x < 45      
	     _novo := Iif(Empty(_novo), substr(TRB->TOO_DADOS,x,1),_novo + substr(TRB->TOO_DADOS,x,1))		
	     x = x+1
	enddo   

	If Empty(_Novo)
       _cMsg := OemToAnsi("Linha "+Strzero(_nlin,4)+ " Campo Usado em Branco, Verifique !!!")
     //  Msgbox(_cMsg ,OemToAnsi("Atenção Erro Arquivo"),"STOP" )  	  
       Aadd(_aErro,{_cMsg})

    Endif   
    
    If Subs(Alltrim(_novo),1,1) <> 'N' //Faz a verificação do produto FE05 (Ferramenta Usada)
       _cod := "FE05"+Subs(_cod,5,10) //muda o codigo para FE05
    Endif
    
    If !SB1->(Dbseek(xfilial("SB1")+_cod,found()))   
       _cMsg := OemToAnsi("Linha "+Strzero(_nlin,4)+ " Produto "+_cod +" não Encontrado no cadastro, Verifique !!!")
      // Msgbox(_cMsg ,OemToAnsi("Atenção Erro Arquivo"),"STOP" )  	  
       Aadd(_aErro,{_cMsg})

	Endif          

	if Subs(Alltrim(_consig),1,1) <> 'C' // so pega os produtos que nao são consignados
	    If SB2->(Dbseek(xfilial("SB2")+_cod+"01",found()))   
	       If SB2->B2_QATU < Val(_sqtde)
	          _cMsg := OemToAnsi("Linha "+Strzero(_nlin,4)+ " Saldo Insuficiente em Estoque do Produto "+_cod +" não é possivel efetuar a baixa, Verifique !!!")
	       //   Msgbox(_cMsg ,OemToAnsi("Atenção Erro Arquivo"),"STOP" )  	  
	          Aadd(_aErro,{_cMsg})
	
	       Endif   
	    Else
	          _cMsg := OemToAnsi("Linha "+Strzero(_nlin,4)+ " Produto não Cadastrado no Saldo em Estoque do Produto "+_cod +" não é possivel efetuar a baixa, Verifique !!!")
	       //   Msgbox(_cMsg ,OemToAnsi("Atenção Erro Arquivo"),"STOP" )  	  
	          Aadd(_aErro,{_cMsg})
	
		Endif          
		
	Endif 
    //------------------------------------------------------------------------------------------------------
    //  esta parte vou refazer
    //------------------------------------------------------------------------------------------------------
    //  COLOQUEI O IF ABAIXO, APENAS PARA INSERIR NO ARRAY QUANDO NAO FOR CONSIGNADO
    //  JA FUNCIONA PARA A BAIXA DO SB2
    //------------------------------------------------------------------------------------------------------

    SBM->(DbSeek(xFilial("SBM")+SB1->B1_GRUPO))	
	IF Subs(_cc,1,1)$"1/2" //Pega conta administrativa
	   _cConta := SBM->BM_CTAADM
	Else // Pega conta direta
          _cConta := SBM->BM_CTADIR			     
	endif                            
	   
	if Subs(Alltrim(_consig),1,1) <> 'C'
	
	   _ni := Ascan(_aBaixa, {|x| x[2]+x[3]+x[4] == _cc + _data + _cod })
   
	   If _ni <> 0
          _aBaixa[_ni][8] += Val(_sqtde) //soma a qtde p/ o mesmo produto e CC
	   Else
	   	   aadd(_aBaixa,{"501",_cc,_data,_cod,"01",SB1->B1_UM,SB1->B1_GRUPO,Val(_sqtde),_cConta})
	   Endif
	   
    Else
    
       _ni := Ascan(_aConsig, {|x| x[2]+x[3]+x[4] == _cc + _data + _cod })
   
	   If _ni <> 0
          _aConsig[_ni][8] += Val(_sqtde) //soma a qtde p/ o mesmo produto e CC
	   Else
          aadd(_aConsig,{"501",_cc,_data,_cod,"01",SB1->B1_UM,SB1->B1_GRUPO,VaL(_sqtde),_cConta})
       Endif   

    Endif
   	
	_cod 	:= SPACE(15)
	_sqtde 	:= SPACE(2)
	_cc 	:= space(9)
	_data 	:= SPACE(10) 
	_cConta := Space(20)
	_Consig := Space(04)
	_Novo   := Space(04)
	
	TRB->(DBSKIP())           
	
	_nLin += 1 //acrescenta um no numero de linhas p/ controle de erro

enddo

If Len(_aErro) > 0
   For x:= 1 to Len(_aErro)
      FWrite(cArq,(_aErro[x][1]+cNovaLinha))                
   
   Next x   
   Alert(OemtoAnsi(" Atenção Arrume as Criticas que foram geradas atualiza o arquivo e rode a rotina novamente no Sistema Protheus"))
Endif   
FClose(cARQ)            

If len(_aBaixa) > 1
   _aBaixa := ASort(_aBaixa,,, { |x, y| x[2] > y[2]})  //ordena por centro de custo
Endif

If Len(_aConsig) > 1   
   _aConsig:= ASort(_aConsig,,, { |x, y| x[2] > y[2]})  //ordena por centro de custo

Endif

_cc     := Space(09)
_lGrava := .F.

//Fazer a gravaçao....

/*
For _ni := 1 to len(_aBaixa)

    
    If _cc <> _aBaixa[_ni][2]

       If _lGrava // Variavel de controle p/ efetuar a baixa
          Alert(" Vou Gravar")
          fGrava() //efetua a baixa
       Endif
       _cc := _aBaixa[_ni][2]
	   _aCab   := {{"D3_TM"    	 ,_aBaixa[_ni][1]       ,NIL},;  
                   {"D3_CC"    	 ,_aBaixa[_ni][2]       ,NIL},;  
	               {"D3_EMISSAO" ,Ctod(_aBaixa[_ni][3]) ,Nil}}                                  
    Endif                                         
    
   	_aItem := {{"D3_COD"	    , _aBaixa[_ni][4]       	,NIL},; 
			   {"D3_LOCAL"		, _aBaixa[_ni][5]			,NIL},;
   	    	   {"D3_UM"		    , _aBaixa[_ni][6]  			,NIL},;
    	       {"D3_GRUPO"		, _aBaixa[_ni][7]			,NIL},;
   	   		   {"D3_QUANT"		, _aBaixa[_ni][8]		 	,NIL},; 
    	   	   {"D3_CONTA"		, _aBaixa[_ni][9]			,NIL}}
	aadd(_atotitem,_aItem)
	_lGrava := .T. // Variavel de controle p/ efetuar a baixa
  
Next _ni
*/
Return

Static Function fGrava()

   MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab,_atotitem,3)
   ALERT(" GRAVEI  " )
   If lMsErroAuto
       Mostraerro()
       DisarmTransaction()
       break
   EndIf                                         
   _aItem    := {}
   _aCab     := {}
   _atotitem := {}
   _lGrava   := .F. // Variavel de controle p/ efetuar a baixa   
Return   
