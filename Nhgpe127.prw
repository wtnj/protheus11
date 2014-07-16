/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE127  ºAutor  ³Marcos R. Roquitski º Data ³  12/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Layout do arquivo de inclusao AMIL.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function Nhgpe127()

SetPrvt("CLOTE,CARQTXT,CCARAC,CAGENC,X,CCONTA,CQUERY")
SetPrvt("NLIN,NTOT,CNRCOB,NVALOR,CDATVEN,_cCfop")
SetPrvt("nHdl,cLin,cFnl,_Datai,_Dataf,lEnd,_cCgc")

If !Pergunte('CON011',.T.)
   Return(nil)
Endif
SRJ->(DbSetOrder(1))
CTT->(DbSetOrder(1))
SRB->(DbSetOrder(1))

If MsgBox("Confirme geracao arquivo","Arquivo de Inclusao AMIL","YESNO")

	lEnd    := .T.
	cArqTxt := "C:\AMIL\PJ" + SM0->M0_CGC + ".TXT"
	cFnl    := CHR(13)+CHR(10)
	nHdl    := fCreate(cArqTxt)
	lEnd    := .F.

	Processa( {|| Gerando()   },"Criando arquivo temporario")
	MsAguarde ( {|lEnd| Processo() },"Aguarde","Gerando arquivo...",.T.)

    DbSelectArea("TMP")
    DbCloseArea()

Endif	

Return


Static Function Processo()

	nlin := 0
	cLin := '1'
	cLin := cLin + 'AMILPJ'
	cLin := cLin + Substr(Dtos(dDataBase),7,2)+Substr(Dtos(dDataBase),5,2)+Substr(Dtos(dDataBase),1,4)
	cLin := cLin + Space(520)
	cLin := cLin + cFnl
	fWrite(nHdl,cLin,Len(cLin))

	DbSelectArea("TMP")
	TMP->(DbGotop())
	
	While !TMP->(Eof())

		cLin := '2'        
		cLin := cLin + ' '		

		cLin := cLin + SM0->M0_CGC
		cLin := cLin + ' '				

		cLin := cLin + Substr(Dtos(dDataBase),7,2)+Substr(Dtos(dDataBase),5,2)+Substr(Dtos(dDataBase),1,4)
		cLin := cLin + ' '				

		cLin := cLin + 'T'
		cLin := cLin + ' '							

		If !Empty(TMP->RA_NOMECMP)
			cLin := cLin + TMP->RA_NOMECMP
			cLin := cLin + ' '				
		Else
			cLin := cLin + TMP->RA_NOME + Space(40)		
			cLin := cLin + ' '				
		Endif	

		cLin := cLin + Substr(Dtos(TMP->RA_NASC),7,2)+Substr(Dtos(TMP->RA_NASC),5,2)+Substr(Dtos(TMP->RA_NASC),1,4)
		cLin := cLin + ' '				

		cLin := cLin + TMP->RA_CIC
		cLin := cLin + ' '				

		cLin := cLin + TMP->RA_SEXO
		cLin := cLin + ' '				

		If     TMP->RA_ESTCIVI == 'S' // Solteiro
			cLin := cLin + '1'
			cLin := cLin + ' '							
			
		Elseif TMP->RA_ESTCIVI == 'C' // Casado
			cLin := cLin + '2'
			cLin := cLin + ' '							
			
		Elseif TMP->RA_ESTCIVI == 'V' // Viuvo
			cLin := cLin + '3'
			cLin := cLin + ' '							
			
		Elseif TMP->RA_ESTCIVI == 'Q' // Separado
			cLin := cLin + '4'
			cLin := cLin + ' '							
			
		Elseif TMP->RA_ESTCIVI == 'D' // Divorciado
			cLin := cLin + '5'
			cLin := cLin + ' '							
    
        Else
			cLin := cLin + '6'
			cLin := cLin + ' '							
	
		Endif

		cLin := cLin + '0'
		cLin := cLin + ' '							


		If TMP->RA_ASMEDIC = '01'
			cLin := cLin + '93130' // Codigo Plano de Saude na AMIL BLUE QP Privativo 93130
			cLin := cLin + ' '					
		Elseif TMP->RA_ASMEDIC = '02'
			cLin := cLin + '93124' // Codigo Plano de Saude na AMIL BLUE QC Coletivo  93124
			cLin := cLin + ' '					
		Endif

		cLin := cLin + TMP->RA_PAI
		cLin := cLin + ' '				

		cLin := cLin + '01011950' // Data de Nasc. Pai
		cLin := cLin + ' '		
				
		cLin := cLin + TMP->RA_MAE				
		cLin := cLin + ' '		
				
		cLin := cLin + '01011950' // Daya de Nasc. Mae
		cLin := cLin + ' '				

		cLin := cLin + Substr(Dtos(TMP->RA_ADMISSA),7,2)+Substr(Dtos(TMP->RA_ADMISSA),5,2)+Substr(Dtos(TMP->RA_ADMISSA),1,4)
		cLin := cLin + ' '				

		cLin := cLin + Strzero(Val(TMP->RA_MAT),14)
		cLin := cLin + ' '				

		SRJ->(DbSeek(xFilial("SRJ") + TMP->RA_CODFUNC))
		If SRJ->(Found())
			cLin := cLin + Substr(SRJ->RJ_DESC,1,14)
			cLin := cLin + ' '					
		Else
			cLin := cLin + SPACE(14)
			cLin := cLin + ' '					
			
		Endif						

		cLin := cLin + Strzero(Val(TMP->RA_CC),14)
		cLin := cLin + ' '		
				
		CTT->(DbSeek(xFilial("CTT") + TMP->RA_CC))
		If CTT->(Found())
			cLin := cLin + Substr(CTT->CTT_DESC01,1,12)
			cLin := cLin + ' '					
			
		Else
			cLin := cLin + SPACE(12)
			cLin := cLin + ' '					
			
		Endif						
		cLin := cLin + "RUA     "
		cLin := cLin + ' '		
				
		cLin := cLin + TMP->RA_ENDEREC+Substr(TMP->RA_COMPLEM,1,10) // Endereco
		cLin := cLin + ' '		
				
		cLin := cLin + StrZero(Val(TMP->RA_ENDEREC),10) // Numero	
		cLin := cLin + ' '		
				
		cLin := cLin + Space(20) // Complemento
		cLin := cLin + ' '		
				
		cLin := cLin + TMP->RA_BAIRRO+SPACE(05) // Bairro
		cLin := cLin + ' '		
				
		cLin := cLin + TMP->RA_MUNICIP // Cidade
		cLin := cLin + ' '		
				
		cLin := cLin + TMP->RA_ESTADO 
		cLin := cLin + ' '		
				
		cLin := cLin + TMP->RA_CEP
		cLin := cLin + ' '		
				
		cLin := cLin + '00000' // codigo do banco
		cLin := cLin + ' '		
				
		cLin := cLin + Space(05) // codigo da agencia
		cLin := cLin + ' '		
				
		cLin := cLin + Space(14) // nr. da conta corrente
		cLin := cLin + ' '				

		cLin := cLin + StrZero(0,4) // ddd residencial       
		cLin := cLin + ' '		
				
		cLin := cLin + StrZero(0,8) // fone residencial      
		cLin := cLin + ' '		
				
		cLin := cLin + StrZero(0,6) // ramal residencial     
		cLin := cLin + ' '		
				
		cLin := cLin + StrZero(0,8) // fax residencial       
		cLin := cLin + ' '		
				
		cLin := cLin + Space(30) // email residencial 
		cLin := cLin + ' '				

		cLin := cLin + "0041" // ddd comercial         
		cLin := cLin + ' '		
				
		cLin := cLin + "33411900" // fone comercial
		cLin := cLin + ' '		
				
		cLin := cLin + StrZero(0,6) // ramal comercial
		cLin := cLin + ' '		
				
		cLin := cLin + StrZero(0,8) // fax comercial       
		cLin := cLin + ' '		
				
		
		cLin := cLin + Space(30) // email comercial    
		cLin := cLin + ' '		
				
		cLin := cLin + 'N' // ativo resgate
		cLin := cLin + ' '		
				
		cLin := cLin + 'N' // ativo internacional
		cLin := cLin + ' '		
				
		cLin := cLin + 'N'  
		cLin := cLin + ' '		
				
		cLin := cLin + 'N'
		cLin := cLin + ' '		
				
		cLin := cLin + 'N'		
		cLin := cLin + ' '
					
		cLin := cLin + 'N'
		cLin := cLin + ' '		
				

		cLin := cLin + TMP->RA_PIS // pis/paseq
		cLin := cLin + ' '		
				
		cLin := cLin + StrZero(0,5) // prc do beneficiario
		cLin := cLin + ' '				

		cLin := cLin + cFnl
		fWrite(nHdl,cLin,Len(cLin))
		nlin := nlin+1

		// Dependentes. -
		DbSelectArea("SRB")
		SRB->(DbSeek( TMP->RA_FILIAL + TMP->RA_MAT))
		While !SRB->(Eof()) .AND. SRB->RB_MAT == TMP->RA_MAT

			If Empty(SRB->RB_ASMEDIC)
				SRB->(DbSkip())
				Loop
			Endif


		  If SRB->RB_FILIAL == TMP->RA_FILIAL
            
			cLin := '2'
			cLin := cLin + ' '					
			
			cLin := cLin + SM0->M0_CGC
			cLin := cLin + ' '					

			cLin := cLin + Substr(Dtos(dDataBase),7,2)+Substr(Dtos(dDataBase),5,2)+Substr(Dtos(dDataBase),1,4)
			cLin := cLin + ' '		

			cLin := cLin + 'D'
			cLin := cLin + ' '					

			cLin := cLin + SRB->RB_NOME 
			cLin := cLin + ' '		

			cLin := cLin + Substr(Dtos(SRB->RB_DTNASC),7,2)+Substr(Dtos(SRB->RB_DTNASC),5,2)+Substr(Dtos(SRB->RB_DTNASC),1,4)
			cLin := cLin + ' ' 
			
			cLin := cLin + StrZero(Val(SRB->RB_CIC),11)
			cLin := cLin + ' '		
						
			cLin := cLin + SRB->RB_SEXO
			cLin := cLin + ' '		
						
			cLin := cLin + '1' // estado civil
			cLin := cLin + ' '		

			If SRB->RB_GRAUPAR == 'C'
				cLin := cLin + '2' 
				cLin := cLin + ' '					

			Elseif	SRB->RB_GRAUPAR == 'F'
				cLin := cLin + '3' 
				cLin := cLin + ' '					

			Else
				cLin := cLin + '4' 
				cLin := cLin + ' '					

			Endif


			If TMP->RA_ASMEDIC = '01'
				cLin := cLin + '93130' // Codigo Plano de Saude na AMIL BLUE QP Privativo 93130
				cLin := cLin + ' '						
			Elseif TMP->RA_ASMEDIC = '02'
				cLin := cLin + '93124' // Codigo Plano de Saude na AMIL BLUE QC Coletivo  93124
				cLin := cLin + ' '						
			Endif

 			cLin := cLin + Space(40)
			cLin := cLin + ' '		
			 			
			cLin := cLin + '00000000' // Data de Nasc. Pai
			cLin := cLin + ' '					


			If !EMPTY(SRB->RB_MAE)
				cLin := cLin + SRB->RB_MAE				
				cLin := cLin + ' '						
			Else
				cLin := cLin + "MARIA DA SILVA                          "
				cLin := cLin + ' '						
			Endif	
			// cLin := cLin + SRB->RB_MAE				
			
			cLin := cLin + '01011950' // Daya de Nasc. Mae
			cLin := cLin + ' '		
						
			cLin := cLin + '00000000'
			cLin := cLin + ' '		
						
			cLin := cLin + Strzero(Val(TMP->RA_MAT),14)
			cLin := cLin + ' '		
						
			cLin := cLin + SPACE(14)
			cLin := cLin + ' '					

			cLin := cLin + Strzero(Val(TMP->RA_CC),14)
			cLin := cLin + ' '		
				
			CTT->(DbSeek(xFilial("CTT") + TMP->RA_CC))
			If CTT->(Found())
				cLin := cLin + Substr(CTT->CTT_DESC01,1,12)
				cLin := cLin + ' '					
			Else
				cLin := cLin + SPACE(12)
				cLin := cLin + ' '					
			Endif

			cLin := cLin + "RUA     "
			cLin := cLin + ' '		
						
			cLin := cLin + TMP->RA_ENDEREC+Substr(TMP->RA_COMPLEM,1,10) // Endereco
			cLin := cLin + ' '		
						
			cLin := cLin + StrZero(Val(TMP->RA_ENDEREC),10) // Numero	
			cLin := cLin + ' '		
						
			cLin := cLin + Space(20) // Complemento
			cLin := cLin + ' '		
						
			cLin := cLin + TMP->RA_BAIRRO+SPACE(05) // Bairro
			cLin := cLin + ' '					
			
			cLin := cLin + TMP->RA_MUNICIP // Cidade
			cLin := cLin + ' '		
						
			cLin := cLin + TMP->RA_ESTADO 
			cLin := cLin + ' '		
						
			cLin := cLin + TMP->RA_CEP
			cLin := cLin + ' '		
						
			cLin := cLin + '00000' // codigo do banco
			cLin := cLin + ' '		
						
			cLin := cLin + Space(05) // codigo da agencia
			cLin := cLin + ' '		
						
			cLin := cLin + Space(14) // nr. da conta corrente
			cLin := cLin + ' '		
						

			cLin := cLin + StrZero(0,4) // ddd residencial       
			cLin := cLin + ' '		
						
			cLin := cLin + StrZero(0,8) // fone residencial      
			cLin := cLin + ' '		
						
			cLin := cLin + StrZero(0,6) // ramal residencial     
			cLin := cLin + ' '		
						
			cLin := cLin + StrZero(0,8) // fax residencial       
			cLin := cLin + ' '		
						
			cLin := cLin + Space(30) // email residencial     
			cLin := cLin + ' '		
						
			cLin := cLin + "0000" // ddd comercial         
			cLin := cLin + ' '		
			
			cLin := cLin + "00000000" // fone comercial
			cLin := cLin + ' '		
						
			cLin := cLin + StrZero(0,6) // ramal comercial
			cLin := cLin + ' '		
						
			cLin := cLin + StrZero(0,8) // fax comercial       
			cLin := cLin + ' '		
						
			cLin := cLin + Space(30) // email comercial    
			cLin := cLin + ' '		
						
			cLin := cLin + 'N' // ativo resgate
			cLin := cLin + ' '		
						
			cLin := cLin + 'N' // ativo internacional
			cLin := cLin + ' '		
						
			cLin := cLin + 'N'  
			cLin := cLin + ' '		
						
			cLin := cLin + 'N'
			cLin := cLin + ' '		
						
			cLin := cLin + 'N'		
			cLin := cLin + ' '		
						
			cLin := cLin + 'N'
			cLin := cLin + ' '					

			cLin := cLin + StrZero(0,11) // pis/paseq
			cLin := cLin + ' '		
						
			cLin := cLin + StrZero(0,5) // prc do beneficiario
			cLin := cLin + ' '

			cLin := cLin + cFnl
			fWrite(nHdl,cLin,Len(cLin))
			nlin := nlin+1
          
          Endif
		  SRB->(DbSkip())
		
						
		Enddo
		DbSelectArea("TMP")
		TMP->(DbSkip())

	Enddo

	
	cLin := '3'
	cLin := cLin + StrZero(nLin,5)
	cLin := cLin + Space(529)
	cLin := cLin + cFnl
	fWrite(nHdl,cLin,Len(cLin))

	fClose(nHdl)
	
Return(nil)        

//
Static Function Gerando()
	_dDatai := Dtos(mv_par01)
	_dDataf := Dtos(mv_par02)

	cQuery  := " SELECT * FROM " + RetSqlName( 'SRA' ) + " RA "
    cQuery  += " WHERE RA.RA_SITFOLH <> 'D' "
    cQuery  += " AND RA.RA_ASMEDIC <> '' " 
    cQuery  += " AND RA.D_E_L_E_T_ =  '' "    
	cQuery  += " AND RA.RA_FILIAL BETWEEN '" + Mv_par03 + "' AND '" + Mv_par04 +"'" 
	cQuery  += " AND RA.RA_DTASME BETWEEN '" + Dtos(Mv_par01) + "' AND '" + Dtos(Mv_par02) +"'" 

	/*
	_cZemp := mv_par05

	If Mv_par05 $ '2/3/4/5/6/7' // 2-fundicao/3-usinagem/4-forjaria/5-virabrequim/6-Aluminio/7-Pernambuco
	    cQuery  += " AND RA.RA_ZEMP = '" + _cZemp + "' "

	Elseif Mv_par05 == '8'
	    cQuery  += " AND RA.RA_ZEMP IN ('2','4','5','6') "
	Endif
    */

	TCQUERY cQuery NEW ALIAS "TMP"  

	TcSetField("TMP","RA_ADMISSA","D") // Muda a data de string para date.
	TcSetField("TMP","RA_DTASME","D") // Muda a data de string para date.
	TcSetField("TMP","RA_NASC","D") // Muda a data de string para date.

Return                                   
 
//
Static Function fGerater()

	cQuery  := " SELECT * FROM " + RetSqlName( 'ZRA' ) + " ZRA "
    cQuery  += " WHERE ZRA.ZRA_FILIAL = '" + xFilial("ZRA")+ "'"
    cQuery  += " AND ZRA.ZRA_ASMEDI <> '' "
    cQuery  += " AND ZRA.D_E_L_E_T_ =  '' "    
    cQuery  += " AND ZRA.ZRA_FIM = ' ' "
    cQuery  += " AND ZRA.ZRA_CPF <> '' "
	TCQUERY cQuery NEW ALIAS "TMT"

	TcSetField("TMT","ZRA_DTNASC","D") // Muda a data de string para date.
	TcSetField("TMT","ZRA_INICIO","D") // Muda a data de string para date.

Return                                   
