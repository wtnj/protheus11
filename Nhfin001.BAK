/*
+-----------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                             !
+-----------------------------------------------------------------------------------+
!                                 DADOS DO PROGRAMA                                 !
+------------------+----------------------------------------------------------------+
!Modulo            ! FIN - Financeiro                                               !
+------------------+----------------------------------------------------------------+
!Nome              ! NHFIN001.PRW                                                   !
+------------------+----------------------------------------------------------------+
!Descricao         ! Geração do Arquivo de Pagamento ITAÚ                           +
+------------------+----------------------------------------------------------------+
!Autor             ! Marcos R. Roquitski                                            !
+------------------+----------------------------------------------------------------+
!Data de Criacao   ! 17/02/2003                                                     !
+------------------+----------------------------------------------------------------+
!   ATUALIZACOES                                                                    !
+--------------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao             !Nome do    ! Analista  !Data da !
!                                                  !Solicitante! Respons.  !Atualiz.!
+--------------------------------------------------+-----------+-----------+--------+
!Recebe parametros e avalia                        ! Pauloci   ! Edenilson !12/11/13!
!        01 - Nossa Conta Corrente                 !           !           !        !
!        02 - Agencia e Conta Favorecido           !           !           !        !
!        03 - Agencia e Conta Header do Lote       !           !           !        !
!        04 - Valida Camara Centralizadora         !           !           !        !
!        05 - Valida Banco no codigo de barra      !           !           !        !
!        06 - Digito verificador do codigo de barra!           !           !        !
!        07 - Campo Livre do Codigo de barra       !           !           !        !
!        08 - Valor Impresso no Codigo de Barra    !           !           !        !
+--------------------------------------------------+-----------+-----------+--------+ 
*/
#include "rwmake.ch"       
#include "topconn.ch"

User Function Nhfin001(cMv_par01)
   
   SetPrvt("cRetorno,cDac,cAgencia,cConta,i,_nPeso,_nSoma,_nResto,_nSubtrai,_cCCCb,_cAgCb,_nPos")

   cDac      := Space(01)
   cConta    := Space(12)
   cRetorno  := Space(01)
   _nPeso    := 0
   _nSoma    := 0
   _nResto   := 0
   _nSubtrai := 0
   _cAgCb    := Space(04)
   _cCcCb    := Space(07)
   _nPos     := 0

   If cMv_par01 == "01"  // Nossa Conta Corrente

      If Len(Alltrim(SEE->EE_CONTA)) == 10

		cConta := StrZero(Val(Substr(SEE->EE_CONTA,1,9)),12)
		cDac   := Substr(SEE->EE_CONTA,10,1) + Space(01)
		cRetorno := cConta + cDac      
      Else

	      cConta    := StrZero(Val(Substr(SEE->EE_CONTA,1,AT("-",SEE->EE_CONTA))),12,0)
	      i := 1
	      For i := 1 To 12
	         If Substr(SEE->EE_CONTA,i,1) == "-"
	            cDac := cDac + Substr(SEE->EE_CONTA,i+1,2)
	            Exit
	         Endif
	      Next
	      cDac := Alltrim(cDac)

		  If SEE->EE_CODIGO = '341'				      
                cRetorno := cConta+" "+cDac
		  Else
		      If Len(cDac) == 1
		         cRetorno := cConta+cDac+" "
		      Else
		         cRetorno := cConta+cDac
		      Endif
		  Endif			      

      Endif
   Endif
      	   


   If cMv_par01 == "02"  // Agencia e Conta Favorecido

      cAgencia  := StrZero(Val(Substr(SA2->A2_AGENCIA,1,4)),5,0)+Substr(SA2->A2_AGENCIA,5,1)
      cConta    := StrZero(Val(Substr(SA2->A2_NUMCON,1,AT("-",SA2->A2_NUMCON))),12,0)

      i := 1
      For i := 1 To 12
         If Substr(SA2->A2_NUMCON,i,1) == "-"
            cDac := cDac + Substr(SA2->A2_NUMCON,i+1,2)
            Exit
         Endif  
      Next
      cDac   := Alltrim(cDac)


	  If Alltrim(SEE->EE_CODIGO) $ '341/409'

			If Alltrim(SA2->A2_BANCO) $ '341/409'    

		   		cRetorno := "0" + StrZero(Val(Substr(SA2->A2_AGENCIA,1,4)),4)+ " " + cConta + " " + cDac

		   	Else

			      If     Len(cDac) == 1
		    	     cRetorno :=  "0" + StrZero(Val(Substr(SA2->A2_AGENCIA,1,4)),4) + " " + cConta + " " + cDac

			      Elseif Len(cDac) == 2
			         cRetorno :=  "0" + StrZero(Val(Substr(SA2->A2_AGENCIA,1,4)),4) + " " + cConta + cDac      

			      Else
			         cRetorno :=  "0" + StrZero(Val(Substr(SA2->A2_AGENCIA,1,4)),4) + cConta + cDac

			      Endif
		   	
		   	Endif	
    
	  Else     	  

	      If     Len(cDac) == 1
    	     cRetorno := cAgencia+cConta+cDac+" "
	      Elseif Len(cDac) == 2
	         cConta   := StrZero(Val(Substr(SA2->A2_NUMCON,1,AT("-",SA2->A2_NUMCON))),11,0)
	         cRetorno := cAgencia+cConta+cDac      
	      Else
	         cRetorno := cAgencia+cConta+cDac
	      Endif

	  Endif
   Endif

   If cMv_par01 == "03"  // Agencia e Conta - Header do Lote 


      If Len(Alltrim(SEE->EE_CONTA)) == 10

		cConta := StrZero(Val(Substr(SEE->EE_CONTA,1,9)),12)
		cDac   := Substr(SEE->EE_CONTA,10,1) + Space(01)
		cRetorno := cConta + cDac      

      Else

	      cConta  := StrZero(Val(Substr(SEE->EE_CONTA,1,AT("-",SEE->EE_CONTA))),12,0)

	      i := 1
	      For i := 1 To 12
	         If Substr(SEE->EE_CONTA,i,1) == "-"
	            cDac := cDac + Substr(SEE->EE_CONTA,i+1,2)
	            Exit
	         Endif  
	      Next
	      cDac   := Alltrim(cDac)
			
          If SEE->EE_CODIGO == '341'
			  cRetorno := cConta+" "+cDac		   
          Else 
		      If Len(cDac) == 1
    		     cRetorno := cConta+cDac+" "
		      Else
		         cRetorno := cConta+cDac
		      Endif
		  Endif   

      Endif

   Endif   

   If cMv_par01 == "04"  // Codigo da Camara Centralizadora  

      SX6->(DbSeek(xFilial()+"MV_VLRTED"))
      If SX6->(Found())
         If SEA->EA_MODELO == "01" .AND. SA2->A2_BANCO == "001"
            cRetorno := "000"
         Else   
            If SE2->E2_SALDO > Val(SX6->X6_CONTEUD)
               cRetorno := "018" // TED
            Else
               cRetorno := "700" // Doc
            Endif
         Endif
   
      Else
         MsgBox("Paramentro MV_VLRTED Nao Cadastrado, Arquivo contem errro.","Geracao de Arquivo","INFO")
      Endif   
   Endif   


   If cMv_par01 == "05"  // Valida codigo do banco Segmento J codigo de barras

      If Empty(SE2->E2_CODBAR)

         cRetorno := Subst(SE2->E2_CODBAR,1,3)
	   
	      MsgBox("Erro na Geracao do Arquivo","ERRO","INFO")
	
	      @ 135,006 To 380,600 Dialog DlgTitulos Title "FALTOU LEITURA DO CODIGO DE BARRAS"
	
	      @ 10,15 Say "Prefixo" Size 35,8
	      @ 20,15 Say "Titulo" Size 35,8
	      @ 30,15 Say "Fornecedor" Size 35,8
	      @ 40,15 Say "Emissao" Size 35,8
	      @ 50,15 Say "Vencimento" Size 35,8
	      @ 60,15 Say "Valor" Size 35,8
	
		   @ 10,50 Get SE2->E2_PREFIXO WHEN .F. Size 20,8
		   @ 20,50 Get SE2->E2_NUM WHEN .F. Size 25,8
		   @ 30,50 Get SA2->A2_NOME WHEN .F. Size 110,8
		   @ 40,50 Get SE2->E2_EMISSAO WHEN .F. Size 35,8
		   @ 50,50 Get SE2->E2_VENCTO WHEN .F. Size 35,8
		   @ 60,50 Get SE2->E2_VALOR PICT "@E 99,999,999.99" WHEN .F. Size 45,8
		
		   @ 080,120 BMPBUTTON TYPE 02 ACTION Close(DlgTitulos)
		   Activate Dialog DlgTitulos CENTERED
		
	  Else
		
		   cRetorno := Subst(SE2->E2_CODBAR,1,3)
		
		   If cRetorno == "001" .and. SEA->EA_MODELO == "31"
		         MsgBox("Erro na Geracao do Arquivo","ERRO","INFO")
		         @ 135,006 To 380,500 Dialog dlgTitulos Title "BANCO "+cRetorno+" NAO PODE SER INCLUSO EM PAGAMENTO 31."
		         @ 10,15 Say "Prefixo" Size 35,8
		         @ 20,15 Say "Titulo" Size 35,8
		         @ 30,15 Say "Fornecedor" Size 35,8
		         @ 40,15 Say "Emissao" Size 35,8
		         @ 50,15 Say "Vencimento" Size 35,8
		         @ 60,15 Say "Valor" Size 35,8
		         @ 10,50 Get SE2->E2_PREFIXO WHEN .F. Size 20,8
		         @ 20,50 Get SE2->E2_NUM WHEN .F. Size 25,8
		         @ 30,50 Get SA2->A2_NOME WHEN .F. Size 110,8
		         @ 40,50 Get SE2->E2_EMISSAO WHEN .F. Size 35,8
		         @ 50,50 Get SE2->E2_VENCTO WHEN .F. Size 35,8
		         @ 60,50 Get SE2->E2_VALOR PICT "@E 99,999,999.99" WHEN .F. Size 45,8
		         @ 080,120 BMPBUTTON TYPE 02 ACTION Close(DlgTitulos)
		         Activate Dialog DlgTitulos CENTERED
			Endif		         
	
		   If cRetorno == "341" .and. SEA->EA_MODELO == "31"
		         MsgBox("Erro na Geracao do Arquivo","ERRO","INFO")
		         @ 135,006 To 380,500 Dialog dlgTitulos Title "BANCO "+cRetorno+" NAO PODE SER INCLUSO EM PAGAMENTO 31."
		         @ 10,15 Say "Prefixo" Size 35,8
		         @ 20,15 Say "Titulo" Size 35,8
		         @ 30,15 Say "Fornecedor" Size 35,8
		         @ 40,15 Say "Emissao" Size 35,8
		         @ 50,15 Say "Vencimento" Size 35,8
		         @ 60,15 Say "Valor" Size 35,8
		         @ 10,50 Get SE2->E2_PREFIXO WHEN .F. Size 20,8
		         @ 20,50 Get SE2->E2_NUM WHEN .F. Size 25,8
		         @ 30,50 Get SA2->A2_NOME WHEN .F. Size 110,8
		         @ 40,50 Get SE2->E2_EMISSAO WHEN .F. Size 35,8
		         @ 50,50 Get SE2->E2_VENCTO WHEN .F. Size 35,8
		         @ 60,50 Get SE2->E2_VALOR PICT "@E 99,999,999.99" WHEN .F. Size 45,8
		         @ 080,120 BMPBUTTON TYPE 02 ACTION Close(DlgTitulos)
		         Activate Dialog DlgTitulos CENTERED
			Endif		         

		    If  cRetorno == "001" .And. SEA->EA_MODELO <> "30"
		         @ 135,006 To 380,500 Dialog dlgTitulos Title "BANCO "+cRetorno+" NAO PODE SER INCLUSO EM PAGAMENTO 30."
		         @ 10,15 Say "Prefixo" Size 35,8
		         @ 20,15 Say "Titulo" Size 35,8
		         @ 30,15 Say "Fornecedor" Size 35,8
		         @ 40,15 Say "Emissao" Size 35,8
		         @ 50,15 Say "Vencimento" Size 35,8
		         @ 60,15 Say "Valor" Size 35,8
		         @ 10,50 Get SE2->E2_PREFIXO WHEN .F. Size 20,8
		         @ 20,50 Get SE2->E2_NUM WHEN .F. Size 25,8
		         @ 30,50 Get SA2->A2_NOME WHEN .F. Size 110,8
		         @ 40,50 Get SE2->E2_EMISSAO WHEN .F. Size 35,8
		         @ 50,50 Get SE2->E2_VENCTO WHEN .F. Size 35,8
		         @ 60,50 Get SE2->E2_VALOR PICT "@E 99,999,999.99" WHEN .F. Size 45,8
		         @ 080,120 BMPBUTTON TYPE 02 ACTION Close(DlgTitulos)
		         Activate Dialog DlgTitulos CENTERED
		     Endif   
	
		    If  cRetorno == "341" .And. SEA->EA_MODELO <> "30"
		         @ 135,006 To 380,500 Dialog dlgTitulos Title "BANCO "+cRetorno+" NAO PODE SER INCLUSO EM PAGAMENTO 30."
		         @ 10,15 Say "Prefixo" Size 35,8
		         @ 20,15 Say "Titulo" Size 35,8
		         @ 30,15 Say "Fornecedor" Size 35,8
		         @ 40,15 Say "Emissao" Size 35,8
		         @ 50,15 Say "Vencimento" Size 35,8
		         @ 60,15 Say "Valor" Size 35,8
		         @ 10,50 Get SE2->E2_PREFIXO WHEN .F. Size 20,8
		         @ 20,50 Get SE2->E2_NUM WHEN .F. Size 25,8
		         @ 30,50 Get SA2->A2_NOME WHEN .F. Size 110,8
		         @ 40,50 Get SE2->E2_EMISSAO WHEN .F. Size 35,8
		         @ 50,50 Get SE2->E2_VENCTO WHEN .F. Size 35,8
		         @ 60,50 Get SE2->E2_VALOR PICT "@E 99,999,999.99" WHEN .F. Size 45,8
		         @ 080,120 BMPBUTTON TYPE 02 ACTION Close(DlgTitulos)
		         Activate Dialog DlgTitulos CENTERED
		     Endif   

		Endif

   Endif

   If cMv_par01 == "06"  // Digito Verificar do Codigo de barra
		If Len(Alltrim(SE2->E2_CODBAR)) == 44
			cRetorno := Substr(SE2->E2_CODBAR,5,1)
		Else
			cRetorno := Substr(SE2->E2_CODBAR,33,1)
		EndIf	
   Endif
   
   If cMv_par01 == "07"  // Campo Livre do Codigo de barra.     

		If SEA->EA_MODELO $ '03/08' .AND. SEA->EA_PORTADO == '237'
			cRetorno := 'C0000000101'
		Else
			If Len(Alltrim(SE2->E2_CODBAR)) == 44
				cRetorno := Substr(SE2->E2_CODBAR,20,25)
			Else	
				cRetorno :=	Substr(SE2->E2_CODBAR,5,5)+Substr(SE2->E2_CODBAR,11,10)+Substr(SE2->E2_CODBAR,22,10)
			Endif
    	Endif
    	
   Endif

   If cMv_par01 == "08"  // Valor Impresso no Codigo de Barra

		If Len(Alltrim(SE2->E2_CODBAR)) == 44
			cRetorno := Substr(SE2->E2_CODBAR,6,14)
		Else 
			If Len(Substr(SE2->E2_CODBAR,34,4)) == 4 .And. Val(Substr(SE2->E2_CODBAR,38,10)) > 0
				cRetorno :=	Substr(SE2->E2_CODBAR,34,14)
         Else  
				cRetorno :=	StrZero(0,14)
			Endif				
		Endif
	Endif


	If cMv_par01 == "09"  // Banco/Agencia e Conta Corrente
		
		If SEA->EA_MODELO $ "30/01/02" 		
			cBanco := "237"
		Elseif SEA->EA_MODELO $ "03/08"
			cBanco := SA2->A2_BANCO
		Else
			cBanco := Subst(SE2->E2_CODBAR,1,3)		
		Endif
		
		// Agencia
		If cBanco $ '237/001' // Bradesco/Banco do Brasil - 
			// A ultima posicao e o digito verificador obrigatoriamente
			cAgencia := StrZero(Val(Substr(SA2->A2_AGENCIA,1,4)),5) + Substr(SA2->A2_AGENCIA,5,1)
		Else
			cAgencia := StrZero(Val(Substr(SA2->A2_AGENCIA,1,4)),5) + Space(01)
		Endif						
		cConta  := StrZero(Val(Substr(SA2->A2_NUMCON,1,AT("-",SA2->A2_NUMCON))),13,0)

		i := 1
		For i := 1 To 10
			If Substr(SA2->A2_NUMCON,i,1) == "-"
				cDac := cDac + Substr(SA2->A2_NUMCON,i+1,2)
				Exit
			Endif
		Next
		cDac := Alltrim(cDac)
     
		If     Len(cDac) == 1
			cRetorno := cBanco+cAgencia+cConta+cDac+" "
		Else
			cRetorno := cBanco+cAgencia+cConta+Substr(cDac,1,2)
		Endif
	

		If cBanco $ '237' .and. SEA->EA_MODELO $ "31/30"
			_cAgCb    := Substr(SE2->E2_CODBAR,20,4)
			_cCcCb    := Substr(SE2->E2_CODBAR,37,7)

			// Calculo digito verificador Agencia
	        _nPeso    := 5
			For j := 1 to 4
				_nSoma += Val(Substr(_cAgCb,j,1)) * _nPeso
				_nPeso--
			Next
			_nResto   := (_nSoma % 11)
			_nSubtrai := (11 - _nResto)

			cAgencia := StrZero(Val(_cAgCb),5)
			If _nSubtrai == 1
				cAgencia += '0'
			Else
	            cAgencia += Alltrim(Str(_nSubtrai))
			Endif
			
			// Calculo digito verificador Conta corrente
	        _nPeso  := 2
	        _nPos   := 7 
	        _nSoma  := 0 
			For j := 1 to 7
				_nSoma += Val(Substr(_cCcCb,_nPos,1)) * _nPeso
				_nPeso++
				_nPos--
				If _nPeso == 7
					_nPeso := 2
				Endif	
			Next
			_nResto   := (_nSoma % 11)
			_nSubtrai := (11 - _nResto)

			cConta := StrZero(Val(_cCcCb),13)            
			If _nSubtrai == 1
				cConta  += '0'
			Else
	            cConta += Alltrim(Str(_nSubtrai))
			Endif

			cRetorno := cBanco+cAgencia+cConta
	    Else
			If SEA->EA_MODELO $ '31' .and. cBanco <> '237'
				cRetorno := cBanco+"000000000000000000000"
			Endif	    
	    Endif
	Endif

	If cMv_par01 == "10"  // Carteira / Bradesco

		If SEA->EA_MODELO == "31" .AND. SA2->A2_BANCO == "237"
	  	    cRetorno := "0"+Substr(SE2->E2_CODBAR,24,2)
		Else   
            cRetorno := "000" 
        Endif
   
    Endif   


	If cMv_par01 == "11"  // Data de geracao do arquivo formato DDMMAA

		cRetorno := Substr(Dtos(dDataBase),7,2) + Substr(Dtos(dDataBase),5,2) + Substr(Dtos(dDataBase),3,2) 
   
    Endif   

   If cMv_par01 == "12"  // Conta Corrente Banco Safra com 08 posicoes

      cRetorno  := StrZero(Val(Substr(SEE->EE_CONTA,1,AT("-",SEE->EE_CONTA))),08)

   Endif

   If cMv_par01 == "13"  // Vencimento DDMMAA

      cRetorno := Substr(Dtos(SE2->E2_VENCREA),7,2) + Substr(Dtos(SE2->E2_VENCREA),5,2) + Substr(Dtos(SE2->E2_VENCREA),3,2)

   Endif

   If cMv_Par01 == "14"	
		If Len(Alltrim(SE2->E2_CODBAR)) == 44 // Leitura LEITORA DE COD. BARRA
                                     
        	cRetorno := Substr(SE2->E2_CODBAR,6,4)
        	 	
		Else // Linha digitada
		
        	cRetorno := Substr(SE2->E2_CODBAR,34,4)

		Endif
   Endif

	If cMv_par01 == "15"  // Valor posicao 10 a 19 do codigo de barras.

		cRetorno := '0000000000'

		If SEA->EA_MODELO == "31" 
	
			If Len(Alltrim(SE2->E2_CODBAR)) == 44				  	
		  	    cRetorno := Substr(SE2->E2_CODBAR,10,10)		  	
		  	Else
		  	    cRetorno := Substr(SE2->E2_CODBAR,38,10)		  				  	
		  	Endif    
			  	    
        Endif
   
    Endif   


	If cMv_par01 == "069" // Especifico banco BPN

		cRetorno := '0002'+ Alltrim(SEE->EE_AGENCIA)+"0"+Substr(SEE->EE_CONTA,1,6)+Substr(Alltrim(SEE->EE_CONTA),8,1)
  
    Endif   


Return(cRetorno)
/*  
34100000      080201261681000104                    00566 000000042986 6WHB FUNDICAO S/A              BANCO ITAU                              11411201211042300000000000000                                                                     
34100011C2003040 201261681000104                    00566 000000042986 6WHB FUNDICAO S/A                                                      RUA WIEGANDO OLSEN Nr.  1600  00000               CURITIBA            81460070PR                  
3410001300001A00000039901131 00000001914867PRODA PRODUTOS ABRASIVOS E FER   000006509BNF 003816112012REA000000000000000000000001093200                    00000000000000000000000                    999999053816890001650100010     0          
3410001300002A00000023717884 000000000050 7DIFER DIAMANTES INDUSTRIAIS LT   000010093 NF 003816112012REA000000000000000000000006243480                    00000000000000000000000                    999999608096960001230100010     0          
3410001300003A00000034101688 000000033034 7WODONIS COMERCIO DE FERRAMENTA   000011519 NF 002416112012REA000000000000000000000000256500                    00000000000000000000000                    999999092236570001920100010     0          
34100015         000005000000000007593180000000000000000000                                                                                                                                                                                     
34199999         000001000007                                                                                                                                                                                                                   
*/
