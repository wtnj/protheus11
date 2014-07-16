/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST042        ³ Alexandre R. Bento    ³ Data ³03.01.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gatilho no b1_tipo do Cadatro de Produtos - Atualizando   ³±±
±±³            a Conta de Estoque.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"     

User Function nhest042()        

SetPrvt("cCONTA")                         

//IF Subs(M->B1_COD,1,2) <> M->B1_TIPO
//   MsgBox("Atencao o Tipo esta Errado o mesmo devera seguir a estrutura do codigo do Produto","Atencao","STOP")
//   M->B1_TIPO := 0
//   Return
//Endif

IF SM0->M0_CODIGO == "NH"  //empresa new hubner
	If M->B1_TIPO == "MP"
		cCONTA := "101040030001"
	Elseif M->B1_TIPO == "CP"
		cCONTA := "101040030002"
	Elseif M->B1_TIPO == "EB"
		cCONTA := "101040030003"
	Elseif M->B1_TIPO == "MA"
		cCONTA := "101040030004"
	Elseif M->B1_TIPO == "FC"
		cCONTA := "101040020003"
	Elseif M->B1_TIPO == "FD"
		cCONTA := "101040020004"
	Elseif M->B1_TIPO == "FE"
		cCONTA := "101040030005"
	Elseif M->B1_TIPO == "FR"
		cCONTA := "101040010002"
	Elseif M->B1_TIPO == "FU"
		cCONTA := "102010010001"
	Elseif M->B1_TIPO == "OL"
		cCONTA := "101040030006"
	Elseif M->B1_TIPO == "MD"
		cCONTA := "101040030013"
	Elseif M->B1_TIPO == "MM"
		cCONTA := "101040030007"
	Elseif M->B1_TIPO == "MQ"
		cCONTA := "101040030008"
	Elseif M->B1_TIPO == "MX"
		cCONTA := "101040030009"
	Elseif M->B1_TIPO == "ML"
		cCONTA := "101040030010"
	Elseif M->B1_TIPO == "MS"
		cCONTA := "101040030011"
	Elseif M->B1_TIPO == "BN"
		cCONTA := "101040030012"
	Elseif M->B1_TIPO == "MC"
		cCONTA := "101040040001"
	Elseif M->B1_TIPO == "CC"
		cCONTA := "101040040001"
	Elseif M->B1_TIPO == "EC"
		cCONTA := "101040040001"
	Elseif M->B1_TIPO == "PA"
		cCONTA := "101040010001"
	Elseif M->B1_TIPO == "PI"
		cCONTA := "101040020001"
	Elseif M->B1_TIPO == "SU"
		cCONTA := "302010020004"
	Elseif M->B1_TIPO == "MO"
		cCONTA := "401010010001"                            
	Elseif M->B1_TIPO == "SA"
		cCONTA := "101040030009"
	Elseif M->B1_TIPO == "IM"
		cCONTA := "103020020001"		
	Elseif M->B1_TIPO == "FZ"
		cCONTA := "102010010001" 
	Elseif M->B1_TIPO == "ME"
		cCONTA := "101040030014"			
	Elseif M->B1_TIPO == "PQ"
		cCONTA := "101040030015"	
	Elseif M->B1_TIPO == "ZB"
		cCONTA := "101040040001"	
  	Elseif M->B1_TIPO == "MK"
       cCONTA := "101040030016"	        
	Endif
	
Elseif SM0->M0_CODIGO == "FN" //empresa Fundição	
//Favor incluir o programa através de gatilho no campo B1_TIPO 

		If M->B1_TIPO == "MP"
			cCONTA := "101040030001"
		Elseif M->B1_TIPO == "EB"
			cCONTA := "101040030002"
		Elseif M->B1_TIPO == "MA"
			cCONTA := "101040030003"
		Elseif M->B1_TIPO == "FE"
			cCONTA := "101040030015"
		Elseif M->B1_TIPO == "FD"
			cCONTA := "101040030015"
		Elseif M->B1_TIPO == "OL"
			cCONTA := "101040030005"
		Elseif M->B1_TIPO == "MM"
			cCONTA := "101040030006"
		Elseif M->B1_TIPO == "MX"
			cCONTA := "101040030007"
		Elseif M->B1_TIPO == "MS"
			cCONTA := "101040030008"
		Elseif M->B1_TIPO == "MQ"
			cCONTA := "101040030009"
		Elseif M->B1_TIPO == "BN"
			cCONTA := "101040030010"
		Elseif M->B1_TIPO == "PA"
			cCONTA := "101040010001"
		Elseif M->B1_TIPO == "MO"
			cCONTA := "401010010001"
		Elseif M->B1_TIPO == "SA"
			cCONTA := "101040030009"
	    Elseif M->B1_TIPO == "EC"
		    cCONTA := "101040040001"
  	    Elseif M->B1_TIPO == "PI"
		    cCONTA := "101040020001"
  	    Elseif M->B1_TIPO == "FR"
		    cCONTA := "101040030004"		    
   	    Elseif M->B1_TIPO == "IM"
		    cCONTA := "103020020001"		
   	    Elseif M->B1_TIPO == "MC"
		    cCONTA := "101040040002"
   	    Elseif M->B1_TIPO == "CC"
		    cCONTA := "101040040002"
   	    Elseif M->B1_TIPO == "MD"
		    cCONTA := "101040030005"
     	Elseif M->B1_TIPO == "CP"
		    cCONTA := "101040030011"
		Elseif M->B1_TIPO == "ZB"
			cCONTA := "101040040001"	
		Elseif M->B1_TIPO == "ML"
			cCONTA := "101040030016"	
     	Elseif M->B1_TIPO == "PQ"
	        cCONTA := "101040030017"
     	Elseif M->B1_TIPO == "GG"
	        cCONTA := "101040010001"
     	Elseif M->B1_TIPO == "MF"
	        cCONTA := "101040030018"
     	Elseif M->B1_TIPO == "MG"
	        cCONTA := "101040030020"
     	Elseif M->B1_TIPO == "FC"
	        cCONTA := "101040020003"	        
     	Elseif M->B1_TIPO == "MK"
	        cCONTA := "101040030016"	        
		Elseif M->B1_TIPO == "FJ"
			cCONTA := "101040030015"
	        
		Endif

		
Endif

Return(cCONTA) 
