#Include "FiveWin.ch"
#Include "Fileio.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ PREFECTO | Autor ³ Andre                 ³ Data ³ 01/08/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao do Pre-Fechamento   (Individual)                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PREFECTO()
            
SetPrvt("oOsv,oTemTra,oTemPad,lOsv,lTemTra,lTemPad,lCheckObserv,oChekObserv,oObserv,cObserv")
SetPrvt("aTempos,cAliasSrv,cAliasPec,cObserv,oDlgPreFecto")

aTempos  := ParamIXB[1] //Vetor com os tipos de tempo
cAliasSrv:= ParamIXB[2] //Alias de Servicos
cAliasPec:= ParamIXB[3] //Alias de Pecas

lOsv    := .f.
lTemTra := .f.
lTemPad := .f.
lCheckObserv := .f.
cObserv := ""

DEFINE MSDIALOG oDlgPreFecto FROM 001,000 TO 016,050 TITLE "Pre-Fechamento" OF oMainWnd
  
@ 001,002 TO 025,198 LABEL "Informacoes adcionais" OF oDlgPreFecto PIXEL 

@ 010,005 CHECKBOX oOsv VAR lOsv PROMPT "Ordem Servico" ;
                               OF oDlgPreFecto ;
                               SIZE 55,08 PIXEL 
@ 010,075 CHECKBOX oTemTra VAR lTemTra PROMPT "Tempo Trabalhado" ;
                               OF oDlgPreFecto ;
                               SIZE 55,08 PIXEL 
@ 010,140 CHECKBOX oTemPad VAR lTemPad PROMPT "Tempo Padrao" ;
                               OF oDlgPreFecto ;
                               SIZE 55,08 PIXEL 

@ 030,002 TO 100,198 LABEL "Observacao" OF oDlgPreFecto PIXEL 

@ 037,005 CHECKBOX oChekObserv VAR lCheckObserv PROMPT "Lista Observacao" ;
                               OF oDlgPreFecto ;
                               ON CLICK If( lCheckObserv , oObserv:Enable() , oObserv:Disable() ) ;
                               SIZE 60,08 PIXEL 

@ 047,005 GET oObserv VAR cObserv OF oDlgPreFecto MEMO SIZE 190,50 PIXEL //READONLY MEMO

DEFINE SBUTTON FROM 101,120 TYPE 6 ACTION ( FS_SETPREFECTO() , oDlgPreFecto:End() ) ENABLE OF oDlgPreFecto
DEFINE SBUTTON FROM 101,160 TYPE 2 ACTION oDlgPreFecto:End() ENABLE OF oDlgPreFecto

ACTIVATE MSDIALOG oDlgPreFecto CENTER 
                         
Return

Function FS_SETPREFECTO()

SetPrvt("cAlias,nLin,aPag,nIte,aReturn,Limite,aOrdem,cTitulo,cTamanho,cNomProg,cNomeRel,cgPerg,nLastKey")
SetPrvt("cDesc1,cDesc2,cDesc3")
                
cAlias   := Alias()
nLin 	  	:= 1
aPag		:= 1
nIte 		:= 1
aReturn 	:= { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
Limite 	:= 132           // 80/132/220
aOrdem  	:= {}           // Ordem do Relatorio
cTitulo	:= "Pre-fechamento da Ordem de Servico"
cTamanho	:= "P"
cNomProg	:= "PREFECTO"
cNomeRel	:= "PREFECTO"
cgPerg  	:= ""
nLastKey	:= 0              
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""

cNomeRel := SetPrint(cAliasSrv,cNomeRel,cgPerg ,@cTitulo,cDesc1,cDesc2,cDesc3,.f.,,,cTamanho)
      
If nLastKey == 27
   Return
Endif

Pergunte("FECHAM",.f.)

SetDefault(aReturn,cAlias)

RptStatus({|lEnd| IMPPREFECTO(aTempos,cAliasSrv,cAliasPec)},cTitulo)

If aReturn[5] == 1
     
   OurSpool( cNomeRel )

EndIf

Return              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPPREFECTºAutor  ³Fabio               º Data ³  05/28/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime pre-fechamento                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Oficina                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                           
Function IMPPREFECTO(aTempos,cAliasSrv,cAliasPec)

SetPrvt("nLin,cQuebra,cQuebraCli,cQuebraVei,cQuebraGruTp,aTotaliz,aObserv,nObs")

Set Printer to &cNomeRel
Set Printer On
Set Device  to Printer

&(cAliasSrv)->(DbSetOrder( 2 ))
&(cAliasPec)->(DbSetOrder( 2 ))

SetRegua( &(cAliasSrv)->( RecCount() ) + &(cAliasPec)->( RecCount() ) )
                                         
aTotaliz := {}
aObserv  := {}

Aadd( aTotaliz , { 0 , 0 , 0 } )		 			&& Totaliza Pecas por grupo de item
Aadd( aTotaliz , { 0 , 0 , 0 , 0 } ) 			&& Totaliza Servicos por tipo de servico
Aadd( aTotaliz , { 0 , 0 , 0 } )		 			&& Totaliza Pecas 
Aadd( aTotaliz , { 0 , 0 , 0 , 0 } ) 			&& Totaliza Servicos
Aadd( aTotaliz , { 0 , 0 } ) 			   		&& Totaliza OS e Descontos
 
nLin := 0                                                           
&(cAliasSrv)->(DbGoTop())
&(cAliasPec)->(DbGoTop())

cQuebraCli   := ""
cQuebraVei   := ""
cQuebraGruTp := ""

Do While !( &(cAliasSrv)->( Eof() ) ) .Or. !( &(cAliasPec)->( Eof() ) )
              
	&& Pecas
	DbSelectArea(cAliasPec)
	DbSetOrder(2)         

   If cQuebraCli == PEC->PEC_CODCLI+PEC->PEC_LOJCLI

		@ CABPREFECTO(),00 PSAY Repl("=",3) + " Pecas " + Repl("=",94)

	EndIf   

	cQuebra    := PEC->PEC_CODCLI+PEC->PEC_LOJCLI+PEC->PEC_NUMOSV+PEC->PEC_TIPTEM
	cQuebraGruTp	:= ""
	Do While !Eof() .And. cQuebra == PEC->PEC_CODCLI+PEC->PEC_LOJCLI+PEC->PEC_NUMOSV+PEC->PEC_TIPTEM
                
		If Ascan( aTempos , { |x| x[1] == .t. .And. x[2] == PEC->PEC_TIPTEM } ) # 0
                                  
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek( xFilial("SA1") + PEC->PEC_CODCLI + PEC->PEC_LOJCLI )
	
			DbSelectArea("VV1")
			DbSetOrder(1)
			DbSeek( xFilial("VV1") + PEC->PEC_CHAINT )
	
			DbSelectArea("VV2")
			DbSetOrder(1)
			DbSeek( xFilial("VV2") + VV1->VV1_CODMAR + VV1->VV1_MODVEI + VV1->VV1_SEGMOD )
	
			If cQuebraCli # PEC->PEC_CODCLI+PEC->PEC_LOJCLI
	
				&& Imprime dados do Cliente		
				FS_DADOSCLI()
	
				cQuebraCli := PEC->PEC_CODCLI+PEC->PEC_LOJCLI
	
			EndIf		                   
   
			If cQuebraVei # PEC->PEC_CODCLI+PEC->PEC_LOJCLI+PEC->PEC_CHAINT

				FS_DADOSVEI( "P" )      
				
				cQuebraVei := PEC->PEC_CODCLI+PEC->PEC_LOJCLI+PEC->PEC_CHAINT

			EndIf
			
			&& Imprime total das pecas
			If cQuebraGruTp # PEC->PEC_CODCLI+PEC->PEC_LOJCLI+PEC->PEC_CHAINT+PEC->PEC_GRUITE
		
				@ CABPREFECTO(),00 PSAY "Grp" + Space(2) + "Codigo" + Space(22) + "Descricao"  + Space(9) + If( lOsv , "Nro Os" , Space(6) ) + Space(5) + "Mec." + Space(10) + "Qtde." + Space(6) + "Valor Dsct" + Space(5) + "Valor Total"
	                                                      
			EndIf
	
			cQuebraGruTp	:= PEC->PEC_CODCLI+PEC->PEC_LOJCLI+PEC->PEC_CHAINT+PEC->PEC_GRUITE

			@ CABPREFECTO(),00 PSAY PEC->PEC_GRUITE + Space(1) + PEC->PEC_CODIGO+ Space(1) + PEC->PEC_DESCRI + Space(3) + If( lOsv , PEC->PEC_NUMOSV , Space(8) ) + Space(3) + PEC->PEC_PROREQ + Space(2) + Transform( PEC->PEC_QTDITE , "@E 999,999,999" ) + Space(2) + Transform( PEC->PEC_VALDES , "@E 999,999,999.99" ) + Space(2) + Transform( PEC->PEC_TOTDES , "@E 999,999,999.99" )
			
			cQuebraCli 		:= PEC->PEC_CODCLI+PEC->PEC_LOJCLI

			aTotaliz[1,1]	+= PEC->PEC_QTDITE
			aTotaliz[1,2]	+= PEC->PEC_VALDES
			aTotaliz[1,3]	+= PEC->PEC_TOTDES
	      
			&& Totaliza OS
			aTotaliz[5,1] += PEC->PEC_VALDES
			aTotaliz[5,2] += PEC->PEC_TOTDES
		
			&& Totaliza Pecas
			aTotaliz[3,1]	+= PEC->PEC_QTDITE
			aTotaliz[3,2]	+= PEC->PEC_VALDES
			aTotaliz[3,3]	+= PEC->PEC_TOTDES
                 
			&& Imprime total das pecas
			DbSelectArea("PEC")
			DbSkip()
			If cQuebraGruTp # PEC->PEC_CODCLI+PEC->PEC_LOJCLI+PEC->PEC_CHAINT+PEC->PEC_GRUITE
		
				@ CABPREFECTO(),00 PSAY "Total "+ Substr( cQuebraGruTp ,Len(cQuebraGruTp)-3 ) + Space(1) + Repl(".",54) + ":" + Transform( aTotaliz[1,1] , "@E 999,999,999,999" ) + Space(2) + Transform( aTotaliz[1,2] , "@E 999,999,999.99" ) + Space(2) + Transform( aTotaliz[1,3] , "@E 999,999,999.99" ) 
		
				@ CABPREFECTO(),00 PSAY ""
		
				&& Zera totais do grupo
				aTotaliz[1,1] := aTotaliz[1,2] := aTotaliz[1,3]	:= 0
			      
			EndIf
			DbSkip(-1)
	
			If Len( aObserv ) == 0 .Or. Ascan( aObserv , {|x| x[1] == PEC->PEC_OBSMEM } ) == 0
			   
				Aadd( aObserv , { PEC->PEC_OBSMEM , PEC->PEC_NUMOSV } )
			
			EndIf

		EndIf
	
	   IncRegua()   
		     
		DbSelectArea(cAliasPec)
		DbSkip()
	   
	EndDo

	@ CABPREFECTO(),00 PSAY "Total Pecas" + Space(1) + Repl(".",53) + ":" + Transform( aTotaliz[3,1] , "@E 999,999,999,999" ) + Space(2) + Transform( aTotaliz[3,2] , "@E 999,999,999.99" ) + Space(2) + Transform( aTotaliz[3,3] , "@E 999,999,999.99" ) 
			
	@ CABPREFECTO(),00 PSAY ""

	&& Zera totais do grupo
	aTotaliz[3,1] := aTotaliz[3,2] := aTotaliz[3,3]	:= 0

   && Servicos  
	DbSelectArea(cAliasSrv)
	DbSetOrder(2)         

   If cQuebraCli == SRV->SRV_CODCLI+SRV->SRV_LOJCLI
	
		@ CABPREFECTO(),00 PSAY Repl("=",3) + " Servicos " + Repl("=",100)

	EndIf   

	cQuebra := SRV->SRV_CODCLI+SRV->SRV_LOJCLI+SRV->SRV_NUMOSV+SRV->SRV_TIPTEM
	cQuebraGruTp	:= ""
	Do While !Eof() .And. cQuebra == SRV->SRV_CODCLI+SRV->SRV_LOJCLI+SRV->SRV_NUMOSV+SRV->SRV_TIPTEM
	           
		If Ascan( aTempos , { |x| x[1] == .t. .And. x[2] == SRV->SRV_TIPTEM } ) # 0

			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek( xFilial("SA1") + SRV->SRV_CODCLI + SRV->SRV_LOJCLI )
	
			DbSelectArea("VV1")
			DbSetOrder(1)
			DbSeek( xFilial("VV1") + SRV->SRV_CHAINT )
	
			DbSelectArea("VV2")
			DbSetOrder(1)
			DbSeek( xFilial("VV2") + VV1->VV1_CODMAR + VV1->VV1_MODVEI + VV1->VV1_SEGMOD )
	
			If cQuebraCli # SRV->SRV_CODCLI + SRV->SRV_LOJCLI
			
				&& Imprime dados do Cliente		
				FS_DADOSCLI()
	
				cQuebraCli := SRV->SRV_CODCLI + SRV->SRV_LOJCLI
				
			EndIf		     

			&& Quebra veiculos
			If cQuebraVei # SRV->SRV_CODCLI+SRV->SRV_LOJCLI+SRV->SRV_CHAINT

				FS_DADOSVEI( "S" )      
				
				cQuebraVei := SRV->SRV_CODCLI+SRV->SRV_LOJCLI+SRV->SRV_CHAINT

			EndIf
		     
			&& Imprime total do servico
			If cQuebraGruTp # SRV->SRV_CODCLI+SRV->SRV_LOJCLI+SRV->SRV_CHAINT+SRV->SRV_TIPSER
		
				@ CABPREFECTO(),00 PSAY "Tp Srv" + Space(1) + "Codigo" + Space(10) + "Descricao" + Space(10) + If( lOsv , "Nro OS" , Space(6) ) + Space(5)+ "Mec." + Space(6) + If( lTemTra , "Apl." , Space(4) ) + Space(5) + If( lTemPad , "Padrao" , Space(6) )  + Space(7) + "Valor Dsct"+ Space(7) + "Valor Total"
	                                                        
			EndIf

			cQuebraGruTp	:= SRV->SRV_CODCLI+SRV->SRV_LOJCLI+SRV->SRV_CHAINT+SRV->SRV_TIPSER

			@ CABPREFECTO(),00 PSAY SRV->SRV_TIPSER + Space(4) + SRV->SRV_CODIGO + Space(1) + SRV->SRV_DESCRI + Space(4) + If( lOsv , SRV->SRV_NUMOSV , Space(8) )+ Space(3) + SRV->SRV_PROREQ + Space(2) + If( lTemTra , Transform( SRV->SRV_TEMTRA , "@R 999:99" ) , Space(6) ) + Space(5) + If( lTemPad , Transform( SRV->SRV_TEMPAD , "@R 999:99" ) , Space(6) ) + Space(3) + Transform( SRV->SRV_VALDES , "@E 999,999,999.99" ) + Space(4) + Transform( SRV->SRV_TOTDES , "@E 999,999,999.99" )
	
			cQuebraCli		:= SRV->SRV_CODCLI + SRV->SRV_LOJCLI

			aTotaliz[2,1]	+= SRV->SRV_TEMTRA
			aTotaliz[2,2]	+= SRV->SRV_TEMPAD
			aTotaliz[2,3]	+= SRV->SRV_VALDES
			aTotaliz[2,4]	+= SRV->SRV_TOTDES
	
			&& Totaliza OS
			aTotaliz[5,1] += aTotaliz[2,3] 
			aTotaliz[5,2] += aTotaliz[2,4] 
		
			&& Totaliza Servicos
			aTotaliz[4,1]	+= SRV->SRV_TEMTRA
			aTotaliz[4,2]	+= SRV->SRV_TEMPAD
			aTotaliz[4,3]	+= SRV->SRV_VALDES
			aTotaliz[4,4]	+= SRV->SRV_TOTDES

			&& Imprime total do servico
			DbSelectArea("SRV")
			DbSkip()
			If cQuebraGruTp # SRV->SRV_TIPSER
		
				@ CABPREFECTO(),00 PSAY "Total " + Substr( cQuebraGruTp , Len(cQuebraGruTp)-2 ) + Space(1) + Repl(".",45) + ":" + Space(5) + If( lTemTra , Transform( aTotaliz[2,1] , "@R 999:99" ) , Space(6) ) + Space(5) + If( lTemPad , Transform( aTotaliz[2,2] , "@R 999:99" )  , Space(6) ) + Space(3) + Transform( aTotaliz[2,3] , "@E 999,999,999.99" ) + Space(4) + Transform( aTotaliz[2,4] , "@E 999,999,999.99" )
		
				@ CABPREFECTO(),00 PSAY ""
			
				&& Zera Totais de tp de Servico
				aTotaliz[2,1] := aTotaliz[2,2] := aTotaliz[2,3] := aTotaliz[2,4]	:= 0

			EndIf
    		DbSkip(-1)

			If Len( aObserv ) == 0 .Or. Ascan( aObserv ,  {|x| x[1] == SRV->SRV_OBSMEM } ) == 0
			   
				Aadd( aObserv , { SRV->SRV_OBSMEM , SRV->SRV_NUMOSV } )
			
			EndIf

		EndIf
	
	   IncRegua()   
	
		DbSelectArea(cAliasSrv)
		DbSkip()
	   
	EndDo

	@ CABPREFECTO(),00 PSAY "Total Servicos" + Space(1) + Repl(".",40) + ":" + Space(5) + If( lTemTra , Transform( aTotaliz[4,1] , "@R 999:99" ) , Space(6) ) + Space(5) + If( lTemPad , Transform( aTotaliz[4,2] , "@R 999:99" )  , Space(6) ) + Space(3) + Transform( aTotaliz[4,3] , "@E 999,999,999.99" ) + Space(4) + Transform( aTotaliz[4,4] , "@E 999,999,999.99" )
		
	@ CABPREFECTO(),00 PSAY ""
			
	&& Zera Totais de tp de Servico
	aTotaliz[4,1] := aTotaliz[4,2] := aTotaliz[4,3] := aTotaliz[4,4]	:= 0

EndDo

@ CABPREFECTO(),00 PSAY "Valor Total dos Descontos..: " + Transform( aTotaliz[5,1] , "@E 999,999,999.99 " ) + Space(34) + "Valor Total das Os..: " + Transform( aTotaliz[5,2] , "@E 999,999,999.99 " )
                                 
If lCheckObserv
                            
	@ CABPREFECTO(),00 PSAY Repl("=",3) + "Observacoes do Pre-fechamento" + Repl("=",81)

	For nObs := 1 to Len( cObserv ) Step 100
	    
		@ CABPREFECTO(),00 PSAY Substr( cObserv , nObs , 100 )
	
	Next
		
	For nObs := 1 to Len( aObserv )
	    
		@ CABPREFECTO(),00 PSAY Repl("=",3) + " Os " + aObserv[nObs,2] +" "+ Repl("=",97)
		@ CABPREFECTO(),00 PSAY E_MSMM( aObserv[nObs,1] , 100 )
	
	Next

EndIf
		
Eject

Set Printer to
Set Device  to Screen

MS_Flush()

Return                
         
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CABPREFECTºAutor  ³Fabio               º Data ³  05/29/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cabecalho do pre-fechamento                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Oficina                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CABPREFECTO()      

SetPrvt("cTitulo , cabec1 , cabec2 , nomeprog , tamanho , nCaracter")
SetPrvt("cbTxt,cbCont,cString,Li,m_Pag,wnRel,cTitulo,cabec1,cabec2,nomeprog,tamanho,nCaracter")

cbTxt    := Space(10)
cbCont   := 0
cString  := cAliasSrv
Li       := 80
m_Pag    := 1
wnRel    := "PREFECTO"

cTitulo	:= "Pre-Fechamento da Ordem de Servico"
cabec1 	:= ""
cabec2 	:= ""

nomeprog	:="PREFECTO"
tamanho	:="M"
nCaracter:=15
                                     
If nLin == 0 .Or. nLin >= 63

	nLin := cabec(ctitulo,cabec1,cabec2,nomeprog,tamanho,nCaracter)

EndIf   
        
nLin += 1

Return( nLin )
         
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FS_DADOSCLºAutor  ³Fabio               º Data ³  05/29/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Dados do cliente cabecalho                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Oficina                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_DADOSCLI()
      
SetPrvt("nSaldo")

nSaldo := 0

SE1->( dbSetOrder(2) )
SE1->( dbSeek( xFilial("SE1")+SA1->A1_COD+SA1->A1_LOJA) )
Do While !SE1->( Eof() ) .And. SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA == xFilial("SE1")+SA1->A1_COD+SA1->A1_LOJA

	nSaldo += SE1->E1_SALDO
   
	SE1->( DbSkip() )

EndDo

@ CABPREFECTO(),00 PSAY Repl("=",46)+" Pre-Fechamento Geral "+Repl("=",45)

@ CABPREFECTO(),00 PSAY "Cliente: "

@ CABPREFECTO(),00 PSAY SA1->A1_CGC + " " + SA1->A1_NOME + " Fone: " + SA1->A1_TEL

@ CABPREFECTO(),00 PSAY SA1->A1_END + " " + SA1->A1_MUN + " " + SA1->A1_EST

@ CABPREFECTO(),00 PSAY "Lim.Cred.: " + Transform( SA1->A1_LC , "@E 999,999,999.99" ) + Space(10) + "Sdo.Dev.: " + Transform( nSaldo , "@E 999,999,999.99" )

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FS_DADOSVEºAutor  ³Fabio               º Data ³  05/29/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Dados do VEICULO                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Oficina                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_DADOSVEI( cPecSrv )
      
@ CABPREFECTO(),00 PSAY Repl("=",113)
   
@ CABPREFECTO(),00 PSAY "Dados do Veiculo:"

@ CABPREFECTO(),00 PSAY "Chassi: " + VV1->VV1_CHASSI + Space(2) + " Placa: " + VV1->VV1_PLAVEI  + Space(2) + "Marca: " + VV1->VV1_CODMAR  + Space(2) + "Modelo: " + VV2->VV2_DESMOD

@ CABPREFECTO(),00 PSAY "Cor: " + VV1->VV1_CORVEI + Space(2) + " Fabricacao: " + Transform( VV1->VV1_FABMOD , "@R  /  /    " )  + Space(2) + " Frota: " + VV1->VV1_CODFRO  + Space(2) + " Km: " + Transform( VV1->VV1_KILVEI , "@E 999,999,999,999")  
   
If cPecSrv == "P"
      
	@ CABPREFECTO(),00 PSAY Repl("=",3) + " Pecas " + Repl("=",103)
	             
Else

	@ CABPREFECTO(),00 PSAY Repl("=",3) + " Servicos " + Repl("=",100)
	
EndIf	

Return