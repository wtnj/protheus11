/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE196  ºAutor  ³Marcos R Roquitski  º Data ³  27/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao do Arquivo consignacao Banco do Brasil TS08.       º±±
±±º          ³ Consulta margem / Informacao de margem.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"                                                                     
#include "protheus.ch"
#include "topconn.ch" 

User Function Nhgpe196()

SetPrvt("CARQTXT,CCONTA,CDIGIT,NPONTO,X,NLIN")
SetPrvt("NTOT,CNRCOB,NVALOR,CDATVEN,")
SetPrvt("nHdl,cLin,cFnl,cSrc")
cSrc := "TMP_SRC"
   
If !Pergunte("GPE105",.T.) 
	Return 
Endif

         
// inicio do processamento do relatório
Processa( {||  xabreLanc(cSrc) },"Gerando Dados para a Impressao")


If SM0->M0_CODIGO == "FN"	// Fundicao
	cArqDep := "CEFN" + Substr(Dtos(dDataBase),5,4) + ".REM" // Deposito
Else
	cArqDep := "CENH" + Substr(Dtos(dDataBase),5,4) + ".REM" // Deposito
Endif	
cFnl    := CHR(13)+CHR(10)
nHdl    := fCreate(cArqDep)
lEnd    := .F.

MsAguarde ( {|lEnd| fArqRem() },"Aguarde","Gerando arquivo...",.T.)

Return


// Geracao do arquivo TXT.                              
Static Function fArqRem()
Local nSega     := 1
Local _nTotsa   := 0
Local _nSalario := 0
Local nMarg     := 0
Local nQtVer    := 0
Local _nV799    := 0			
Local _nV442    := 0
Local _nV490    := 0
Local _cNome, _cMat, _cCic

	nlin := 0
	
	** Header do Arquivo
	cLin := "001"
	cLin := cLin + "0000"
	cLin := cLin + "0"
	cLin := cLin + Space(9)
	cLin := cLin + "2"
	cLin := cLin + Substr(SM0->M0_CGC,1,14)
	cLin := cLin + '000297520'+Space(11)


	If SM0->M0_CODIGO = 'FN' // Fundicao
		cLin := cLin + "033065" // Agencia e digito agencia
		cLin := cLin + "0000000952591 "
	Else
		cLin := cLin + "033065" // Agencia e digito agencia - Usinagem
		cLin := cLin + "0000000952605 "
	Endif  
	
	//cLin := cLin + StrZero(val(substr(mv_par02,1,4)),5) // Agencia
	//cLin := cLin + Substr(mv_par02,5,1) // digito agencia
	//cLin := cLin + fGeracc()
	
	cLin := cLin + Substr(SM0->M0_NOMECOM,1,30)
	cLin := cLin + "BANCO DO BRASIL"
	cLin := cLin + Space(25)
	cLin := cLin + "1"
	cLin := cLin + Substr(Dtos(date()),7,2) + Substr(Dtos(date()),5,2) + Substr(Dtos(date()),1,4)
	cLin := cLin + Substr(TIME(),1,2)+Substr(TIME(),4,2)+Substr(TIME(),7,2)
	cLin := cLin + "000001" 
	cLin := cLin + "081" 
	cLin := cLin + "00000" 
	cLin := cLin + "CDC240000000000TESTE"
 	cLin := cLin + Space(20) 
	cLin := cLin + Space(29) 

	cLin := cLin + cFnl 
	fWrite(nHdl,cLin,Len(cLin)) 


	** Header do Lote 
	cLin := "001"            // Banco
	cLin := cLin + "0000"    // Codigo de averbacao do banco na empresa
	cLin := cLin + "1" 		 // Tipo de registro
	cLin := cLin + "1"       // modalidade de averbacao INSS
	cLin := cLin + "08"      // tipo do servico 08=Consulta/Informacao margem  09=Averbacao da consignacao/Retencao  12=Consignacao de parcelas
	cLin := cLin + "011"     // numero de versao do leiaute
	cLin := cLin + "00"      // mes de competencia da folha de pagamento
	cLin := cLin + "0000"    // ano de competencia da folha de pagamento
	cLin := cLin + "0001"    // lote de servico
	cLin := cLin + "0000000" // numero sequencial do lote
	cLin := cLin + "2"       // tipo de inscricao da empresa
	cLin := cLin + Subst(SM0->M0_CGC,1,14)	// cnpj da empresa
	cLin := cLin + Space(6)	// codigo de unidade administrativa

	// cLin := cLin + "000297520" + Space(11) // codigo do convenio com o banco 297520 
	// Número do Convênio.: 297521 - WHB COMPONENTES AUTOMOTIVOS 
	// Número do Convênio.: 297520 - WHB FUNDICAO S/A 

	If SM0->M0_CODIGO = 'FN' // Fundicao 
		cLin := cLin + "000297520" + Space(11) // codigo do convenio com o banco 297520 
		cLin := cLin + "033065" // Agencia e digito agencia 
		cLin := cLin + "0000000952591 " 
	Else 
		cLin := cLin + "000297521" + Space(11) // codigo do convenio com o banco 297520 
		cLin := cLin + "033065" // Agencia e digito agencia - Usinagem 
		cLin := cLin + "0000000952605 " 
	Endif  

	//cLin := cLin + "033065" // Agencia e digito agencia 
	//cLin := cLin + "0000000952591 " 
	cLin := cLin + Substr(SM0->M0_NOMECOM,1,30) 
	cLin := cLin + "01" 
	cLin := cLin + Space(106) 
	cLin := cLin + Space(10) 
	
	cLin := cLin + cFnl 
	fWrite(nHdl,cLin,Len(cLin)) 


DbSelectArea(cSrc) 
(cSrc)->(dbgotop()) 

While (cSrc)->(!eof()) 

		If (cSrc)->RA_CATFUNC == 'H'
			_nSalario := (cSrc)->RA_SALARIO * 200
		Else
			_nSalario := (cSrc)->RA_SALARIO 		
		Endif	

		_cMat  := (cSrc)->RD_MAT
		_cNome := Substr((cSrc)->RA_NOME,1,30)
		_cCic  := (cSrc)->RA_CIC
	
		While !(cSrc)->(Eof()) .and. (cSrc)->RD_MAT == _cMat

			If		(cSrc)->RD_PD == '799' // Liquido Folha
				_nV799  += (cSrc)->RD_VALOR
			
			Elseif 	(cSrc)->RD_PD == '442' // Liquido Adiantamento
				_nV442   += (cSrc)->RD_VALOR
				
			Elseif 	(cSrc)->RD_PD == '490' // Consignado B. Itau
				_nV490   += (cSrc)->RD_VALOR
				
			Endif
			(cSrc)->(DbSkip())

		Enddo
		_nMedia  := (_nV799 + _nV442 )
		_nMargem := (((_nMedia/3)*30)/100)

		_nMedia  := 0
		_nV799   := 0			
		_nV442   := 0
		_nV490   := 0
		

		** SEGMENTO H
		cLin := "001"   // Codigo do banco na compensacao
		cLin := cLin + "0001" // lote de servico
		cLin := cLin + "3" // tipo de registro
		cLin := cLin + StrZero(nSega,5)  // numero sequencial do registro no lote
		cLin := cLin + "H" // codigo de segmento do reg. detalhe
		cLin := cLin + "0" // tipo do movimento
		cLin := cLin + _cNome // nome do mutuario
		cLin := cLin + Space(06) // codigo de unidade administrativa
		cLin := cLin + _cCic //numero do cpf do mutuario
		cLin := cLin + StrZero(Val(_cMat),12) // id. do mutuario na empresa/orgao		
		cLin := cLin + "1" // Status do mutuario
		cLin := cLin + "1" // Regime de contratacao do mutuário		
		cLin := cLin + "1" // situacao sindical do mutuário
		cLin := cLin + " " // comprovante da verba rescisória
		cLin := cLin + StrZero(_nMargem*100,9) // valor da margem
		cLin := cLin + "73355174" // identificador do sindical
		cLin := cLin + "4" // Identificacao da Central sindical
		cLin := cLin + " " // Tipo de operacao de Credito
		cLin := cLin + "00"   // dia de vencimento da parcela
		cLin := cLin + "00"   // mes de vencimento da parcela
		cLin := cLin + "0000" // ano de vencimento da parcela
		cLin := cLin + "00" // numero de parcelas a ser consignada
		cLin := cLin + "00" // Qt. de parcela do contrato
		cLin := cLin + "00000000"	// data inicio do contrato
		cLin := cLin + "00000000" // data de fim de contrato
		cLin := cLin + StrZero(0,9) // Total liberado		
		cLin := cLin + StrZero(0,9) // Total da Operacao
		cLin := cLin + StrZero(0,9) // Total da Parcela		
		cLin := cLin + StrZero(0,9) // Total Saldo Devedor		
		cLin := cLin + Space(20)    // Id. do Contrato no Banco
		cLin := cLin + "00"                              // Qtde de Contrato no Banco
		cLin := cLin + "000000000"                       // Valor da contraorestacao H029
		cLin := cLin + "000000000"                       // Valor residual garantido H030
		cLin := cLin + " "                               // Tipo residual garantido H031
		cLin := cLin + '     '                           // Agencia
		cLin := cLin + ' '                               // Digito verificador conta
		cLin := cLin + Space(12)                         // Conta corrente sem dv
		cLin := cLin + ' '                               // Conta corrente sem dv
		cLin := cLin + Space(06)                         // Para uso reservado banco
		cLin := cLin + Space(03)                         // Uso exclusivo da FEBRABAN\CNAB
		cLin := cLin + Space(10)                         // Cod das ocorrencias para retorno
		nQtVer ++
		nMarg += (_nMargem) // valor da margem
		nSega++
		cLin := cLin + cFnl 
		fWrite(nHdl,cLin,Len(cLin)) 

Enddo

cLin := "001"  					  // Codigo do banco
cLin := cLin + "0001" 			  // Lote 
cLin := cLin + "5"    			  // Tipo de registro
cLin := cLin + "0000001" 		  // Numero sequencial do lote
cLin := cLin + StrZero(nSega+1,6) // Qtde de reg. do lote
cLin := cLin + "00000"            // Total de parcelas enviadas
cLin := cLin + StrZero(0,15) 	  // Total dos valores das parcelas
cLin := cLin + "00000"    		  // Total de parcelas consignadas 
cLin := cLin + StrZero(0,15) 	  // Total dos valores das parcelas consignadas
cLin := cLin + "00000"    		  // Total de parcelas nao consignadas 
cLin := cLin + StrZero(0,15) 	  // Total dos valores das parcelas nao consignadas
cLin := cLin + StrZero(nQtVer,5) // Qtde de margens consultadas/averbadas   
cLin := cLin + StrZero(nMarg*100,15)  // Somatorio dos valores de margens consultadas/averbadas
cLin := cLin + StrZero(0,9) 	  // Previsao total de CPMF
cLin := cLin + Space(120)         // Brancos
cLin := cLin + Space(10)          // Brancos
cLin := cLin + cFnl 
fWrite(nHdl,cLin,Len(cLin)) 


cLin := "001" 
cLin := cLin + "9999" 
cLin := cLin + "9" 
cLin := cLin + Space(09) 
cLin := cLin + "000001"
cLin := cLin + StrZero(nSega+3,6) 
cLin := cLin + "000000"
cLin := cLin + Space(205) 
cLin := cLin + cFnl 
fWrite(nHdl,cLin,Len(cLin)) 


fClose(nHdl) 

dbSelectArea(cSrc)
dbCloseArea()

Return

// 
static Function abreLanc(cSrc)

//--Fecha Alias Temporario se estiver aberto
If Select(cSrc) > 0
	dbSelectArea(cSrc)
	dbCloseArea()
Endif

//--Consulta as Previsões de venda
beginSql Alias cSrc
	select SRA.RA_MAT,
	       SRA.RA_NOME,
	       SRA.RA_CC,
	       CTT.CTT_DESC01,
	       SRA.RA_SALARIO,
	       SRA.RA_CATFUNC,
	       SRA.RA_CIC,
	       SRA.RA_BCDEPSA,
	       SRA.RA_CTDEPSA
	from 
		%table:SRA% SRA
	inner join
			%table:CTT% CTT
	on
		CTT.CTT_FILIAL  = %xFilial:CTT%
	and CTT.CTT_CUSTO = SRA.RA_CC
	and CTT.CTT_BLOQ = '2' 
	and CTT.D_E_L_E_T_ = ' '
	
	where              
		SRA.RA_FILIAL  = %xFilial:SRA%
	and SRA.D_E_L_E_T_ = ' '		
	and SRA.RA_DEMISSA = ' '
	and SRA.RA_CATFUNC IN ('M','H')
	and SRA.RA_CC  BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
	and SRA.RA_MAT BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%

	order by
		SRA.RA_MAT
endSql


Return   




// 
static Function xabreLanc(cSrc)
Local _cAnomesi := mv_par06

Local _cAnomesf := Substr(mv_par06,1,4) + StrZero(Val(Substr(mv_par06,5,2))+2,2)
Local _cNomM1 := MesExtenso( Str(Val(Substr(mv_par06,5,2))))
Local _cNomM2 := MesExtenso( Str(Val(Substr(mv_par06,5,2))+1))
Local _cNomM3 := MesExtenso( Str(Val(Substr(mv_par06,5,2))+2))

If Val(Substr(mv_par06,5,2)) == 11 
	_cAnomesf := StrZero(Val(Substr(mv_par06,1,4))+1,4) + '01'
	_cNomM2 := MesExtenso('12')
	_cNomM3 := MesExtenso('01')
Endif

If Val(Substr(mv_par06,5,2)) == 12 
	_cAnomesf := StrZero(Val(Substr(mv_par06,1,4))+1,4) + '02'
	_cNomM2 := MesExtenso('01')
	_cNomM3 := MesExtenso('02')
Endif





Cabec1  := " Matr.  Nome                            C.P.F            Salario M/H Admissao                "+_cNomM1 + Space(30) + _cNomM2 + Space(30) + _cNomM3
//--Consulta as Previsões de venda
beginSql Alias cSrc
	select SRD.RD_MAT,
	       SRA.RA_NOME,
	       SRA.RA_CC,
	       CTT.CTT_DESC01,
	       SRA.RA_SALARIO,
	       SRA.RA_CATFUNC,
	       SRD.RD_PD,
	       SRD.RD_VALOR,
	       SRD.RD_HORAS,
	       SRD.RD_DATARQ,
	       SRA.RA_ADMISSA,
	       SRA.RA_CIC,
	       SRA.RA_BCDEPSA,
	       SRA.RA_CTDEPSA

	from 
		%table:SRD% SRD
	inner join
			%table:SRA% SRA
	on
		SRA.RA_FILIAL  = %xFilial:SRA%					
	and SRD.RD_MAT     = SRA.RA_MAT
	and SRA.D_E_L_E_T_ =  ' '
	and SRA.RA_DEMISSA =  ' ' 
	and SUBSTRING(SRA.RA_BCDEPSA,1,3) =  '001'
	and SRA.RA_CC  BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
	and SRA.RA_MAT BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
	inner join
			%table:CTT% CTT
	on
		CTT.CTT_FILIAL  = %xFilial:CTT%					
	and CTT.CTT_CUSTO = SRA.RA_CC
	and CTT.D_E_L_E_T_ = ' '	
	
	where              
		SRD.RD_FILIAL  = %xFilial:SRD%
	and SRD.D_E_L_E_T_ = ' '		
	and SRD.RD_DATARQ  BETWEEN %Exp:_cAnomesi% AND %Exp:_cAnomesf%
	and SRD.RD_PD IN ('799','442','490')
	order by
		SRD.RD_MAT,SRD.RD_DATARQ
endSql

Return 

