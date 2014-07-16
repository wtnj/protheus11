/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE092  ºAutor  ³Marcos R. Roquitski º Data ³  20/07/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Layout do arquivo de movimentacoes AMIL.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function Nhgpe092()

SetPrvt("CLOTE,CARQTXT,CCARAC,CAGENC,X,CCONTA,CQUERY")
SetPrvt("NLIN,NTOT,CNRCOB,NVALOR,CDATVEN,_cCfop")
SetPrvt("nHdl,cLin,cFnl,_Datai,_Dataf,lEnd,_cCgc")

If !Pergunte('CON011',.T.)
   Return(nil)
Endif
SRJ->(DbSetOrder(1))
CTT->(DbSetOrder(1))

If MsgBox("Confirme geracao arquivo","Arquivo de Importacao AMIL","YESNO")

	DbSelectArea("SD1")
	SD1->(DbSetOrder(1))

	lEnd    := .T.
	cArqTxt := "C:\AMIL\AMIL" + Substr(Dtos(dDataBase),1,4) + ".TXT"
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

	DbSelectArea("TMP")
	TMP->(DbGotop())
	
	While !TMP->(Eof())

		nlin := 0
		cLin := 'I'
		cLin := cLin + 'T'
		cLin := cLin + '000000000'
		cLin := cLin + '000000000' // Obrigatorio Marca otica do titular
		cLin := cLin + TMP->RA_CIC                     
		cLin := cLin + TMP->RA_PIS		
		cLin := cLin + TMP->RA_NOME + Space(40)		
		cLin := cLin + Substr(Dtos(TMP->RA_NASC),7,2)+Substr(Dtos(TMP->RA_NASC),5,2)+Substr(Dtos(TMP->RA_NASC),1,4)
		cLin := cLin + TMP->RA_SEXO

		If     TMP->RA_ESTCIVI == 'S' // Solteiro
			cLin := cLin + '1'
		Elseif TMP->RA_ESTCIVI == 'C' // Casado
			cLin := cLin + '2'
		Elseif TMP->RA_ESTCIVI == 'V' // Viuvo
			cLin := cLin + '3'
		Elseif TMP->RA_ESTCIVI == 'Q' // Separado
			cLin := cLin + '4'
		Elseif TMP->RA_ESTCIVI == 'D' // Divorciado
			cLin := cLin + '5'
        Else
			cLin := cLin + '1'
		Endif

		cLin := cLin + '1' // Grau de parentesco             

		If TMP->RA_ASMEDIC = '01'
			cLin := cLin + '93130' 
		Elseif TMP->RA_ASMEDIC = '02'	
			cLin := cLin + '93124' 
		Endif

		cLin := cLin + TMP->RA_PAI + Space(30) // Nome do Pai
		cLin := cLin + '01011950' 			   // Data de Nasc. Pai
		cLin := cLin + TMP->RA_MAE + Space(30) // Nome da Mae
		cLin := cLin + '01011950'			   // Data de Nasc. Mae

		cLin := cLin + Substr(Dtos(TMP->RA_ADMISSA),7,2)+Substr(Dtos(TMP->RA_ADMISSA),5,2)+Substr(Dtos(TMP->RA_ADMISSA),1,4) // Admissao
		cLin := cLin + TMP->RA_MAT + SPACE(08) // Matricula

		SRJ->(DbSeek(xFilial("SRJ") + TMP->RA_CODFUNC))
		If SRJ->(Found())
			cLin := cLin + Substr(SRJ->RJ_DESC,1,14) // Descricao do cargo
		Else
			cLin := cLin + SPACE(14)
		Endif						

		CTT->(DbSeek(xFilial("CTT") + TMP->RA_CC))
		If CTT->(Found())
			cLin := cLin + Substr(CTT->CTT_DESC01,1,14)+Space(12) // Lotacao e Setor
		Else
			cLin := cLin + SPACE(26)
		Endif						
		cLin := cLin + TMP->RA_ENDEREC+TMP->RA_COMPLEM +Space(03) // Endereco
		cLin := cLin + StrZero(Val(TMP->RA_ENDEREC),10) // Numero	
		cLin := cLin + Space(20) // Complemento
		cLin := cLin + TMP->RA_BAIRRO+SPACE(05) // Bairro
		cLin := cLin + TMP->RA_MUNICIP+SPACE(10) // Cidade
		cLin := cLin + TMP->RA_ESTADO 
		cLin := cLin + TMP->RA_CEP
		cLin := cLin + StrZero(Val(TMP->RA_TELEFON),16) // DDD Residencial + Fone Residencial + Ramal Residencial
		cLin := cLin + Space(100) // E-mail
		cLin := cLin + '00000' // codigo do banco
		cLin := cLin + Space(05) // codigo da agencia
		cLin := cLin + Space(14) // nr. da conta corrente
		cLin := cLin + 'N' // ativo internacional
		
		cLin := cLin + cFnl
		fWrite(nHdl,cLin,Len(cLin))
		nlin := nlin+1

		// Dependentes. -

		SRB->(DbSeek(xFilial("SRB") + TMP->RA_MAT))
		While !SRB->(Eof()) .AND. SRB->RB_MAT == TMP->RA_MAT

			If Empty(SRB->RB_ASMEDIC)
				SRB->(DbSkip())
				Loop
			Endif


			nlin := 0
			cLin := 'I'
			cLin := cLin + 'D'
			cLin := cLin + '000000000'
			cLin := cLin + '000000000'
			cLin := cLin + StrZero(Val(SRB->RB_CPF),11) // Cpf
			cLin := cLin + '00000000000' // Pis
			cLin := cLin + SRB->RB_NOME + Space(40)
			cLin := cLin + Substr(Dtos(SRB->RB_DTNASC),7,2)+Substr(Dtos(SRB->RB_DTNASC),5,2)+Substr(Dtos(SRB->RB_DTNASC),1,4)
			cLin := cLin + SRB->RB_SEXO
			cLin := cLin + '1' // Estado civil
	
			If SRB->RB_GRAUPAR == "C" // Conjuge
				cLin := cLin + '2'

			Elseif SRB->RB_GRAUPAR == "F" // Filho
				cLin := cLin + '3'
		
			Elseif SRB->RB_GRAUPAR == "E" // Enteado
				cLin := cLin + '3'
	
			Elseif SRB->RB_GRAUPAR == "P" // Companheira
				cLin := cLin + '2'
	
			Else  
				cLin := cLin + '4'

			Endif	

			If SRB->RB_ASMEDIC = '01'
				
				cLin := cLin + '93130'
	
			Elseif SRB->RB_ASMEDIC = '02'

				cLin := cLin + '93124'			
			
			Endif
			
			cLin := cLin + SPACE(70)
			cLin := cLin + '00000000'			
			cLin := cLin + SRB->RB_MAE + Space(30)
			cLin := cLin + '05011970'
			
			cLin := cLin + '00000000' 

			cLin := cLin + SPACE(14)  // Matricula funcional
			cLin := cLin + SPACE(14)  // Descricao do cargo
			cLin := cLin + SPACE(14)  // Lotacao
			cLin := cLin + SPACE(12)  // Setor
			cLin := cLin + SPACE(48)  // Endereco
			cLin := cLin + SPACE(10)  // Numero
			cLin := cLin + SPACE(20)  // Complemento
			cLin := cLin + SPACE(20)  // Bairro
			cLin := cLin + SPACE(30)  // Cidade
			cLin := cLin + SPACE(02)  // Uf
			cLin := cLin + '00000000' // Cep
			cLin := cLin + '000'      // ddd residencial
			cLin := cLin + '00000000' // Fone residencial
			cLin := cLin + '00000'    // Ramal residencial
			cLin := cLin + Space(100) // E-mail residencial
			cLin := cLin + '00000'    // Codigo do banco
			cLin := cLin + Space(05)  // Codigo da agencia
			cLin := cLin + Space(14)  // Nr. da conta corrente
			cLin := cLin + 'N'        // Aditivo resgate

			cLin := cLin + cFnl
			fWrite(nHdl,cLin,Len(cLin))
			nlin := nlin+1

			SRB->(DbSkip())
			
		Enddo

		TMP->(DbSkip())

	Enddo
	fClose(nHdl)
	
Return(nil)

Static Function Gerando()
	_dDatai := mv_par01
	_dDataf := mv_par02

	cQuery  := " SELECT * FROM " + RetSqlName( 'SRA' ) + " RA "
    cQuery  += " WHERE RA.RA_FILIAL = '" + xFilial("SRA")+ "'"	
    cQuery  += " AND RA.RA_DTASME BETWEEN '" + Dtos(_dDatai) + "' AND '" + Dtos(_dDataf) + "' AND RA.D_E_L_E_T_ = ' ' "
    cQuery  += " AND RA.RA_SITFOLH <> 'D' "
	TCQUERY cQuery NEW ALIAS "TMP"  

	TcSetField("TMP","RA_ADMISSA","D") // Muda a data de string para date.
	TcSetField("TMP","RA_DTASME","D") // Muda a data de string para date.
	TcSetField("TMP","RA_NASC","D") // Muda a data de string para date.

Return                                   
