 /*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � NHTER001 �Autor  � Alexandre R. Bento    � Data � 05/01/2005���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Programa que efetua leitura de pe�a no Micro-Terminal       ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe   � NHTER001                                                    ���
��������������������������������������������������������������������������Ĵ��
���Uso       � MICRO-TERMINAL 16 TECLAS DA WILBOR                                             ���
��������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ���
��������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                    ���
��������������������������������������������������������������������������Ĵ��
���              �        �      �                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#include "rwmake.ch"
#include "fivewin.ch"
#include "tbiconn.ch"

User Function NHTER001()                                  

PREPARE ENVIRONMENT EMPRESA "NH" FILIAL "01" MODULO "05"
SetPrvt("cOperador,cMaquina,cBarra,lAtiva,cTipoMicro,cMensagem,ndoc,lFlag,cCod,cSerial")
SetPrvt("cIDMaq,cOperaca,cArqImp,nHdl,lValida,lPrim,cOpReq,cCodBar,cZESeek,cIDTer")
cOperador  := Space(06)
cMaquina   := Space(03)
cBarra     := Space(15)
cCod       := Space(15)
cSerial    := Space(09)
cIDMaq     := Space(03)
cOperaca   := Space(03)   
cOpReq     := Space(03)   
cCodBar    := Space(06)   

cTipoMicro := "1" //Alltrim(GetMV("MV_LJTPMIC"))  //Determina o tipo de MicroTerminal(16 ou 40 Teclas)
cMensagem  := ""
lAtiva     := .T.        
lFlag      := .T.                                     
lValida    := .T.
lPrim      := .T. //Espera o Operador confirmar o produto somente a primeira VEZ de cada produto
ndoc       := 0                                                                  
cIDTer     := StrZero(ternumter(),2) //traz o numero do microterminal

//���������������������������������������������������������������������������Ŀ
//�Chamada do Menu Principal do Micro Terminal para 16 caracteres em uma linha�
//�����������������������������������������������������������������������������

Do While lFlag // fica ativo pedindo o operador e maquina
   lAtiva  := .T.        
   TerCls() //Limpa o display do microterminal
   TerCBuffer() // limpa o buffer do microterminal

   //�Solicita o Codigo do Operador										 �
   TerSay(00,00,"Operador: ") 
   TerGetRead(00,09,@cOperador,"XXXXXX", {||MOperador(@cOperador)},{||Empty(cOperador)})
   TerSay(00,09,Space(08))    

    // Traz Solicita a Maquina
   SZF->(dbSetOrder(2)) //Filial+ IDTER
   If SZF->(dbSeek(xFilial("SZF")+cIDTer )) 
      cIDMaq    := SZF->ZF_IDMAQ //Codigo da maquina
      cMaquina  := SZF->ZF_IDMAQ //Codigo da maquina
      cOperaca  := SZF->ZF_OPERACA //Codigo da opera��o
      cOpReq    := SZF->ZF_MAQREQ //Maq/operacao de pre requisito
   Endif
      

   If Empty(cMaquina) .Or. Empty(cOperador)
      TerSay(01,00,Padr("Maq. ou Op. Em Branco",16)) //
	  TerBeep(3)
	  Sleep(1000)
	  TerSay(01,00,Space(16))
      lAtiva := .F. 
   Endif

   SB1->(dbSetOrder(5))//filial + b1_codbar      
   SZE->(dbSetOrder(2))//filial + produto + serial + maquina
   Do While lAtiva  //Ativa o Loop de entrada de pecas
	
	//���������������������������������������������������������������������������Ŀ
	//�Chamada do Menu Principal do Micro Terminal para 16 caracteres em uma linha�
	//�����������������������������������������������������������������������������

      cMensagem  := " "
     // TerCls()
      TerCBuffer()
      TerSay(00,00,"Peca: ") 
      TerGetRead(00,05,@cBarra,"XXXXXXXXXXXXXXX", {||MProduto(@cBarra)},{||Empty(cBarra)})
      //TerSay( 01, 00, cMensagem )
      
      If lValida .And. ( Len(cBarra) == 15  .or. Len(cBarra) == 14) .And. cCodBar == Subs(cBarra,1,6)

      // N�o permite a leitura duplicada do produto + serial + maquina 
	      If !SZE->(dbSeek(xFilial("SZE")+cCod+Subs(cBarra,7,9)+cIDMaq)) 
	         // Verifica se o produto+serial+operacao de pre-requisito existe no arquivo 
	         If Empty(cOpReq)
	         	Reclock("SZE",.T.)
		           SZE->ZE_FILIAL  := xFilial("SZE")
		           SZE->ZE_SERIAL  := Subs(cBarra,7,9) //nuemro de serie
		           SZE->ZE_OPER    := cOperador  // operador
		           SZE->ZE_MAQUINA := cIDMaq     // Codigo da maquina
		           SZE->ZE_PRODUTO := cCod       // codigo do produto
		           SZE->ZE_DATA    := Date()  // data
		           SZE->ZE_HORA    := Subs(Time(),1,8) //hora
		        MsUnLock("SZE")	
		        TerBeep(1)  //BEEP de aviso de pe�a lida
	         Else  
	            If SZE->(dbSeek(xFilial("SZE")+cCod+Subs(cBarra,7,9)+cOpReq))			 
  			       Reclock("SZE",.T.)
		              SZE->ZE_FILIAL  := xFilial("SZE")
		              SZE->ZE_SERIAL  := Subs(cBarra,7,9)
		              SZE->ZE_OPER    := cOperador
		              SZE->ZE_MAQUINA := cIDMaq    // Codigo da maquina
		              SZE->ZE_PRODUTO := cCod
		              SZE->ZE_DATA    := Date()
		              SZE->ZE_HORA    := Subs(Time(),1,8)
		           MsUnLock("SZE")	
		           TerBeep(1)  //BEEP de aviso de pe�a lida
			    Else                          
			       TerSay(01,00,Padr("Op. Ant. nao Lida",22)) //
  			       Reclock("SZE",.T.)
		              SZE->ZE_FILIAL  := xFilial("SZE")
		              SZE->ZE_SERIAL  := Subs(cBarra,7,9)
		              SZE->ZE_OPER    := cOperador
		              SZE->ZE_MAQUINA := cIDMaq    // Codigo da maquina
		              SZE->ZE_PRODUTO := cCod
		              SZE->ZE_DATA    := Date()
		              SZE->ZE_HORA    := Subs(Time(),1,8)
		           MsUnLock("SZE")	
			       TerBeep(3)
			       Sleep(500)
			    Endif  
			 Endif   
		  Else                          
		     TerSay(01,00,Padr("Produto ja Lido.",16)) //
		     Reclock("SZE",.T.)
		        SZE->ZE_FILIAL  := xFilial("SZE")
		        SZE->ZE_SERIAL  := Subs(cBarra,7,9)
		        SZE->ZE_OPER    := cOperador
		        SZE->ZE_MAQUINA := cIDMaq    // Codigo da maquina
		        SZE->ZE_PRODUTO := cCod
		        SZE->ZE_DATA    := Date()
		        SZE->ZE_HORA    := Subs(Time(),1,8)
		     MsUnLock("SZE")	
		     TerBeep(3)
		     Sleep(500)
		  Endif  
		  
	  Endif
		
	  // Verifica os produtos da visteon se tem arquivo de medicao para carregar o mesmo
      If !Empty(SB1->B1_ARQUIVO) .And. cIDMaq$"004/009"
	      fMedida() // Grava os dados da medida
	  Endif       
		  
	  cBarra    := Space(15) 
	  lValida :=  .T.    
      TerSay(01,00,Space(22))                               

    
    //������������������������������������������������������������������Ŀ
    //�Teclou Esc, sai da funcao e retorna ao passo anterior			 �
    //��������������������������������������������������������������������
    //  If TerEsc()
  	//     lAtiva := .F.
    //  EndIf

   EndDo
   lPrim    := .T. // Habilita a confirma��o do produto pelo Operador, pois � um nova produto
   cOpReq   := Space(03) // Limpa a maquina / operacao de pre requisito     
   cCodBar  := Space(06)

Enddo // fecha loop while lflag
//������������������������������������������������������������������Ŀ
//�Funcao que finaliza o Micro-Terminal caso seja feito pelo Monitor.�
//��������������������������������������������������������������������
TerIsQuit()
RESET ENVIRONMENT
Return

Static Function MOperador(cOperador)

QAA->(dbSetOrder(1)) //Filial+ matricula
If !QAA->(dbSeek(xFilial("QAA")+cOperador ))
   TerSay(01,00,Padr("Operador Nao Cadastrado",16)) //
   TerBeep(3)                                         
   Sleep(1000)                
   TerSay(00,00,Space(16))    
   TerSay(00,00,"Operador: ") 
   TerSay(01,00,Space(16))    
   cOperador := Space(06)
   Return(.F.)
Else
   cOperador := QAA->QAA_MAT
EndIf   
Return(.T.)


Static Function MMaquina(cMaquina)

SZF->(dbSetOrder(1)) //Filial+ codigo da maquina
If !Empty(cMaquina )
    If !SZF->(dbSeek(xFilial("SZF")+cMaquina )) 
	   TerSay(01,00,Padr("Maq. Nao Cadastrado",16)) //
	   TerBeep(3)
	   Sleep(1000)
	   TerSay(01,00,Space(16))
	   cMaquina := Space(03)
	   cIDMaq   := Space(03)
	   cOperaca := Space(03)   
	   Return(.F.)
	EndIf                  
	cIDMaq    := SZF->ZF_IDMAQ //Codigo da maquina
	cOperaca  := SZF->ZF_OPERACA //Codigo da opera��o
	cOpReq    := SZF->ZF_MAQREQ //Maq/operacao de pre requisito
Else
   Return(.F.)
Endif
	
Return(.T.)


Static Function MProduto(cBarra)
Local cSer := Space(09)

If Empty(cBarra) //para n�o permitir codigo vazio
   lValida := .F.            
   TerCls()
   TerSay(00,00,"Peca: ") 
   Return(.F.)
Endif

// Feito temporariamente at� acabar as etiquetas da VW
If Substr(cBarra,1,2) == "8V"
   cSer   := Substr(cBarra,7,9)
   If len(cSer) < 9
      cSer := "0"+cSer
   Endif
   cBarra := "8V-RSH"+cSer
Endif

If lPrim // S� passa a primeira vez em cada produto p/ operador confirmar
	If !SB1->(dbSeek(xFilial("SB1")+Substr(cBarra,1,6)))
	   IF Subs(cBarra,1,1) = ','
	      lAtiva := .F.      
	      cOperador := Space(06)
	      cMaquina  := Space(03)      
	      cBarra := Space(15)
	      cCod   := Space(15)
	      cSerial:= Space(09)
	      lValida := .F.       
	//      lFlag := .F. //Sai do sistema somente ativando o microterminal via software
	      Return(.T.)
	   Else
	      TerSay(01,00,Padr("Peca Nao Cadastrada",16)) //
	      TerSay(00,00,"Peca: ") 
	      TerBeep(3)
	      Sleep(1000)
	      TerSay(01,00,Space(16))   
	      cBarra := Space(15)
	      cCod   := Space(15)
	      cSerial:= Space(09)  
	      lValida := .F.       
	      Return(.F.)
	   Endif   
	
	Else        
	   If Subs(SB1->B1_COD,6,1) <> "4" .And. Subs(SB1->B1_COD,6,1) <> "H" .And. Subs(SB1->B1_COD,6,1) <> "0" // verifica se � peca produto acabado
	      lValida := .F.      
	      TerSay(01,00,Padr("Peca Nao Cadastrada",16)) //
	      TerBeep(3)
	      Sleep(1000)
	      cCod    := Space(15)
	      cBarra  := Space(15)      
	      TerSay(00,06,Space(15))                        
	      TerSay(01,00,Padr(Space(16))) // Limpa mensagem       
	      Return(.F.)
	   Endif
	   cCod    := SB1->B1_COD
       cCodBar := Subs(SB1->B1_CODBAR,1,6)	   
	   lValida := .T.       
	   cSerial := Subs(cBarra,7,9) // nove caracter � o numero serial
	   cMensagem := Padr( SB1->B1_DESC,25 )
	   TerSay( 01, 00, cMensagem )
	   TerInkey(0) //Espera o operador confirmar o produto no display do microterminal somente a primeira vez
	 //  TerInkey(0) //Espera o operador confirmar o produto no display do microterminal somente a primeira vez	   
  
	Endif   
    lPrim := .F. // Desabilita a verifica�ao do produto para agilizar a grava��o
Endif	

IF Subs(cBarra,1,1) = ','
   lAtiva := .F.      
   cOperador := Space(06)
   cMaquina  := Space(03)      
   cBarra := Space(15)
   cCod   := Space(15)
   cSerial:= Space(09)
   lValida := .F.       
 //  lFlag := .F. //Sai do sistema somente ativando o microterminal via software
   Return(.T.)
Endif   

Return(.T.)


Static Function fMedida()
Local cBuff  := " "

cArqImp      := Alltrim(SB1->B1_ARQUIVO) //Nome do arquivo para importar as medicoes do marposs

If Alltrim(SB1->B1_GRUPO) = 'VU02' // Cubo X
   cArqImp := "\\VISTEON03\MARPOSS\SPOOLER\"+cArqImp 

Elseif SB1->B1_GRUPO = 'VU13' //Carcaca   Z
   cArqImp := "\\VISTEON04\MARPOSS\SPOOLER\"+cArqImp 
Endif

//Nao encontrou o arquivo para leitura
If !File(cArqImp)
   return   
Endif

While File(cArqImp)                       
   cArqImp := SUBS(cArqImp,1,37)+StrZero(Val(Right(cArqImp,2))+1,2)
   If !File(cArqImp)   
      cArqImp := SUBS(cArqImp,1,37)+StrZero(Val(Right(cArqImp,2))-1,2)   
      exit //pega o ultimo arquivo gerado no marposs e sai do while
   Endif
Enddo                  

//verifica a existencia do arquivo para leitura
If (File(cArqImp))
   ft_fuse(cArqImp)//�Efetua a Abertura do Arquivo 
   ft_fgotop()
   While( !ft_feof())
    //�������������������������������������������������������������Ŀ
    //� Neste momento, ja temos uma linha lida. Gravamos os valores �
    //� obtidos retirando-os da linha lida.                         �
    //���������������������������������������������������������������
      cBuff := ft_freadln() //pega linha a linha do arquivo texto
      If Val(SubStr(cBuff,001,2)) >= 01       
	      
	     Reclock("SZH",.T.)
	        SZH->ZH_FILIAL := xFilial("SZH")
	        SZH->ZH_SERIAL := Subs(cBarra,7,9)
            SZH->ZH_PRODUTO:= cCod
	        SZH->ZH_ITEM   := Val(SubStr(cBuff,001,2))
	        SZH->ZH_DESC   := SubStr(cBuff,004,80)
            SZH->ZH_MAQUINA := cIDMaq    // Codigo da maquina
	     MsUnlock("SZH")
	
	  Endif
      ft_fskip()
   EndDo
   ft_fuse() //fecha o arquivo
Endif   

Return
