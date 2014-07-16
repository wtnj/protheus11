/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHFIN066  ºAutor  ³Marcos R Roquitski  º Data ³  28/09/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Enviar e-mail para os fornecedores dos titulos pagos.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"  
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLOR.CH"
#INCLUDE "FONT.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE "DBTREE.CH"
#include "ap5mail.ch"
#include "tbiconn.ch"
#include "inkey.ch"

User function Nhfin066()

SetPrvt("mStruct,mArqTrab,aFields,aRotina,cDelFunc,cCadastro,cMarca,cCoord,_aGrupo,_cLogin,_cLogin2")
SetPrvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cMail,_cNome")
SetPrvt("_dDatade,_dDatate,_cSitu,_cObs,_cIndex")

cServer	:= Alltrim(GETMV("MV_RELSERV")) //"192.168.1.11"
cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga'
cMensagem := '' 
lConectou
lEnviado
cMSG := ""
_aGrupo := pswret()
_cLogin := _agrupo[1,2]
mStruct := {}
AADD(mStruct,{"DT_MARCA",    "C",01,0})
AADD(mStruct,{"DT_PREFIXO",  "C",03,0})
AADD(mStruct,{"DT_NUMERO",   "C",09,0})
AADD(mStruct,{"DT_PARCELA",  "C",01,0})
AADD(mStruct,{"DT_TIPO",     "C",03,0})
Aadd(mStruct,{"DT_PORTADO",  "C",06,0})
Aadd(mStruct,{"DT_FORNECE",  "C",06,0})
AADD(mStruct,{"DT_LOJA",     "C",02,0})
AADD(mStruct,{"DT_NOMFOR",   "C",30,0})
AADD(mStruct,{"DT_EMISSAO",  "D",08,0})
AADD(mStruct,{"DT_VENCREA",  "D",08,0})
AADD(mStruct,{"DT_VALOR",    "N",14,2})
AADD(mStruct,{"DT_BAIXA",    "D",08,0})
AADD(mStruct,{"DT_SALDO",    "N",14,2})
AADD(mStruct,{"DT_PIS",      "N",14,2})
AADD(mStruct,{"DT_COFINS",   "N",14,2})
AADD(mStruct,{"DT_FATURA",   "C",09,0})
AADD(mStruct,{"DT_FATPREF",  "C",03,0})

mArqTrab := CriaTrab(mStruct,.t.)
USE &mArqTrab Alias DET New Exclusive
_cIndex := CriaTrab(nil,.f.)
IndRegua("DET",_cIndex,"DT_FORNECE+DT_LOJA",,,"Indice")

Processa( {|| fDetalhes()})

DbSelectArea("DET")
DET->(DbGotop())

If Reccount() <=0
	MsgBox("Nao ha registro Selecionados !","Atencao !","INFO")
	DbCloseArea("DET")
	Return
Endif

aFields := {}
Aadd(aFields,{"DT_MARCA"     ,"C",OemToAnsi("   ")  })
Aadd(aFields,{"DT_PREFIXO"   ,"C",OemToAnsi("Prefix") })    
Aadd(aFields,{"DT_NUMERO"    ,"C",OemToAnsi("Numero") })    
Aadd(aFields,{"DT_PARCELA"   ,"C",OemToAnsi("Parcela") })      
Aadd(aFields,{"DT_TIPO"      ,"C",OemToAnsi("Tipo") })    
Aadd(aFields,{"DT_PORTADO"   ,"C",OemToAnsi("Portador") })
Aadd(aFields,{"DT_FORNECE"   ,"C",OemToAnsi("Fornecedor") })    
Aadd(aFields,{"DT_LOJA"      ,"C",OemToAnsi("Loja") })
Aadd(aFields,{"DT_NOMFOR"    ,"C",OemToAnsi("Nome Fornecedor") })
Aadd(aFields,{"DT_EMISSAO"   ,"C",OemToAnsi("Emissao") })
Aadd(aFields,{"DT_VENCREA"   ,"C",OemToAnsi("Vencimento") })
Aadd(aFields,{"DT_VALOR"     ,"N",OemToAnsi("Total"),"@E 999,999,999.99"})
Aadd(aFields,{"DT_BAIXA"     ,"C",OemToAnsi("Baixa") })
Aadd(aFields,{"DT_SALDO"     ,"N",OemToAnsi("Saldo"),"@E 999,999,999.99"})
Aadd(aFields,{"DT_PIS"       ,"N",OemToAnsi("Pis"),"@E 999,999.99"})
Aadd(aFields,{"DT_COFINS"    ,"N",OemToAnsi("Cofins"),"@E 999,999.99"})

aRotina := { {"Detalhes"      ,'U_ftest()', 0 , 1 },;
             {"Envia Email"   ,'U_fMailFin()', 0 , 1 },;
             {"Marca todos"   ,'U_fMailF2()', 0 , 1 },;
             {"Desmarca todos"   ,'U_fMailF3()', 0 , 1 } }
                                     
cDelFunc  := ".T."
cCadastro := OemToAnsi("<ENTER> Marca/Desmarca")
cMarca    := getmark()
cCoord    := {50,50,600,600}
                
MarkBrow("DET","DT_MARCA" ,"DET->DT_MARCA",afields,,cMarca)

DbCloseArea("DET")

Return

Static Function fDetalhes()
Local _aGrupo,_cLogin,nRecno,_cNumSc,_cNivel,_cOk

DbSelectArea("DET")
Zap

SA2->(DbSetOrder(1))
SE2->(DbSetOrder(14))
SE2->( DbGotop())
SE2->(DbSeek(xFilial("SE2")+Dtos(dDatabase)))

While !SE2->(Eof()) .AND. Dtos(SE2->E2_BAIXA) == Dtos(dDataBase)
	If Empty(SE2->E2_MAILFOR) .AND. !Empty(SE2->E2_BAIXA)
		If Alltrim(SE2->E2_TIPO) <> 'TX'
			If (ALLTRIM(SE2->E2_FATURA) == 'NOTFAT' .OR. Empty(SE2->E2_FATURA))
				RecLock("DET",.T.)
				SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
				If SA2->(Found()) .AND. !Empty(SA2->A2_MAILFIN)
					DET->DT_MARCA    := '*'
            	Endif
				DET->DT_PREFIXO  := SE2->E2_PREFIXO
				DET->DT_NUMERO   := SE2->E2_NUM
				DET->DT_PARCELA  := SE2->E2_PARCELA
				DET->DT_TIPO     := SE2->E2_TIPO
				DET->DT_PORTADO  := SE2->E2_PORTADO
				DET->DT_FORNECE  := SE2->E2_FORNECE
				DET->DT_LOJA     := SE2->E2_LOJA
				DET->DT_NOMFOR   := SE2->E2_NOMFOR
				DET->DT_EMISSAO  := SE2->E2_EMISSAO
				DET->DT_VENCREA  := SE2->E2_VENCREA
				DET->DT_VALOR    := SE2->E2_VALOR
				DET->DT_BAIXA    := SE2->E2_BAIXA
				DET->DT_SALDO    := SE2->E2_SALDO
				DET->DT_FATPREF  := SE2->E2_FATPREF
				DET->DT_FATURA   := SE2->E2_FATURA
				DET->DT_PIS      := SE2->E2_PIS
				DET->DT_COFINS   := SE2->E2_COFINS
				MsUnlock("DET")
			Endif	
		Endif	
	Endif		
	SE2->(DbSkip())
Enddo

Return



User Function fMailFin()
Local lSolic := .T., _cMail2, _cC1Solicit,_cConta1,_cConta2,_cConta3,_lFornece,_nVlrt,_cCnpj,_cEnd
Local _nPa := _nNdf := 0

If !MsgBox("Confirma envio do E-mail ?","E-mail ao Fornecedor","YESNO")
	Return(.t.)
	DET->(DbGotop())
Endif	

SA2->(DbSetOrder(1))
SE2->(DbSetOrder(13))
DET->(Dbgotop())

lEnd    := .F.
e_email := .F.
_cMail2 := ""
While !DET->(Eof())

   If EMPTY(ALLTRIM(DET->DT_MARCA))
	   DET->(DbSkip())
	   Loop
	Endif	   

	lRet    := .F.
	_cMail  := ""
	_cNome  := " "
	_cConta1 := ""
	_cConta2 := ""
	_cConta3 := ""	
	_Fornece := ""
	_cCnpj   := ""
	_cEnd    := ""
	_nVlrt   := 0
	_nPa     := 0
	_nDf     := 0
	
	SA2->(DbSeek(xFilial("SA2")+DET->DT_FORNECE+DET->DT_LOJA))
	If SA2->(Found())
		_cMail   := SA2->A2_MAILFIN
		_cNome   := "Fornecedor : "+SA2->A2_NOME + " ("+SA2->A2_COD+"-"+SA2->A2_LOJA+")"
		_cCnpj   := "CNPJ       : "+TRANSFORM(SA2->A2_CGC,"@R 99.999.999/9999-99")
		_cEnd    := "Endereco   : "+Alltrim(SA2->A2_END) + "Cidade: "+Alltrim(SA2->A2_MUN)+" UF: "+SA2->A2_EST
		_cConta1 := "Banco      : "+SA2->A2_BANCO 
		_cConta2 := "Agencia    : "+SA2->A2_AGENCIA 
		_cConta3 := "Nr.Conta:  : "+SA2->A2_NUMCON
	Endif

	cMsg := '<html>'
	cMsg += '<head>'
   	cMsg += '<title> Relacao de pagamentos agrupados </title>'
	cMsg += '</head>'
	
	cMsg += '<body>'
	
	cMsg += 'Prezado Fornecedor, <br /><br />Para mais detalhes e maiores informações sobre os seus recebíveis, '+;
		    'favor acessar o nosso portal do fornecedor: <a href="http://portalfornecedor.whbbrasil.com.br">http://portalfornecedor.whbbrasil.com.br</a><br />'+;
			'Seus dados de acesso são: <br />'+;
			'Usuário: CNPJ de sua empresa<br />'+;
			'Senha: 5 primeiros dígitos de seu CNPJ - (Por motivos de segurança, recomendamos que você altere a sua senha no primeiro acesso).<br /><br />'

    cMsg += '<b><font size="3" face="Arial">'+_cNome  +'</font></b><br /><br />'
	cMsg += '<b><font size="2" face="Arial">'+_cConta1+'</font></b><br /><br />'
	cMsg += '<b><font size="2" face="Arial">'+_cConta2+'</font></b><br /><br />'
	cMsg += '<b><font size="2" face="Arial">'+_cConta3+'</font></b><br /><br />'

	cMsg += '<font size="3" face="Arial">Relacao de Pagamentos:</font>'

	cMsg += '<table border="1" width="100%">'	
	cMsg += '<tr bgcolor="#666666" style="color:#ffffff">'
	cMsg += '<th width="10%">Prefixo</th>'
	cMsg += '<th width="10%">Numero</th>'
    cMsg += '<th width="10%">Parcela</th>'
	cMsg += '<th width="10%">Tipo</th>'
	cMsg += '<th width="10%">Emissao</th>'
	cMsg += '<th width="10%">Data do Pgto</th>'
	cMsg += '<th width="10%">Valor Pago</th>'
	cMsg += '<th width="10%">Pis</th>'
	cMsg += '<th width="10%">Cofins</th>'
	cMsg += '</tr>'

	e_email = .T.

	_lFornece := DET->DT_FORNECE + DET->DT_LOJA

	While DET->(!Eof()) .And. DET->DT_FORNECE+DET->DT_LOJA == _lFornece

		If Empty(DET->DT_FATURA)
			cMsg += '<tr>'

		    cMsg += '<td>' + IIF(EMPTY(DET->DT_PREFIXO),".",DET->DT_PREFIXO) + '</td>'
		    cMsg += '<td>' + DET->DT_NUMERO + '</td>'
		    cMsg += '<td>' + IIF(EMPTY(DET->DT_PARCELA),".",DET->DT_PARCELA) + '</td>'
		    cMsg += '<td>'

			If Alltrim(DET->DT_TIPO) == 'PA'
		    	cMsg += DET->DT_TIPO+" - Pagto Antecipado"
			Elseif Alltrim(DET->DT_TIPO) == 'NDF'
		    	cMsg += DET->DT_TIPO + " - Nf Devolucao"
			Else
		    	cMsg += DET->DT_TIPO
			Endif
			
			cMsg += '</td>'
			
		    cMsg += '<td>'+ DTOC(DET->DT_EMISSAO) + '</td>'
		    cMsg += '<td>' + DTOC(DET->DT_VENCREA) + '</td>'
		    cMsg += '<td>' +TRANSFORM(DET->DT_VALOR,"@E 999,999,999.99") + '</td>'
		    cMsg += '<td>' +TRANSFORM(DET->DT_PIS,"@E 999,999.99") + '</td>'
		    cMsg += '<td>' +TRANSFORM(DET->DT_COFINS,"@E 999,999.99") + '</td>'

			cMsg += '</tr>'
			lRet := .T.

			If Alltrim(DET->DT_TIPO) == 'PA'
				_nPa += DET->DT_VALOR

			Elseif Alltrim(DET->DT_TIPO) == 'NDF'
				_nDf += DET->DT_VALOR
				
			Else
				_nVlrt += DET->DT_VALOR

			Endif				

		Elseif Alltrim(DET->DT_FATURA) == 'NOTFAT'

	    	SE2->(DbSetOrder(15))
			SE2->(DbSeek(xFilial("SE2") + DET->DT_PREFIXO + DET->DT_NUMERO))
			While SE2->(!Eof()) .AND. SE2->E2_FATPREF + SE2->E2_FATURA == DET->DT_PREFIXO + DET->DT_NUMERO
				If SE2->E2_FORNECE + SE2->E2_LOJA == DET->DT_FORNECE + DET->DT_LOJA
			
					cMsg += '<tr>'
				    cMsg += '<td>' + IIF(EMPTY(SE2->E2_PREFIXO),".",SE2->E2_PREFIXO) + '</td>'
				    cMsg += '<td>' + SE2->E2_NUM + '</td>'
				    cMsg += '<td>' + "Refaturado: "+DET->DT_NUMERO + '</td>'
				    cMsg += '<td>' + IIF(EMPTY(SE2->E2_TIPO),".",SE2->E2_TIPO) + '</td>'
				    cMsg += '<td>' + DTOC(SE2->E2_EMISSAO) + '</td>'
				    cMsg += '<td>' + DTOC(SE2->E2_VENCREA) + '</td>'
				    cMsg += '<td>' + TRANSFORM(SE2->E2_VALOR,"@E 999,999,999.99") + '</td>'
				    cMsg += '<td>' + TRANSFORM(SE2->E2_PIS,"@E 999,999.99") + '</td>'
				    cMsg += '<td>' + TRANSFORM(SE2->E2_COFINS,"@E 999,999.99") + '</td>'
					cMsg += '</tr>'
					
					lRet := .T.

	                RecLock("SE2",.F.)
	                SE2->E2_MAILFOR := 'S'
	                MsUnlock("SE2")

				Endif	
				SE2->(DbSkip())

			Enddo
			cMsg += '<tr>'
		    cMsg += '<td>' + IIF(EMPTY(DET->DT_PREFIXO),".",DET->DT_PREFIXO) + '</td>'
		    cMsg += '<td>' + DET->DT_NUMERO + '</td>'
		    cMsg += '<td>' + IIF(EMPTY(DET->DT_PARCELA),".",DET->DT_PARCELA) + '</td>'
		    cMsg += '<td>' + IIF(EMPTY(DET->DT_TIPO),".",DET->DT_TIPO) + '</td>'
		    cMsg += '<td>' + DTOC(DET->DT_EMISSAO) + '</td>'
		    cMsg += '<td>' + DTOC(DET->DT_VENCREA) + '</td>'
		    cMsg += '<td>' +TRANSFORM(DET->DT_VALOR,"@E 999,999,999.99") + '</td>'
			cMsg += '</tr>'
			
			lRet := .T.
			_nVlrt += DET->DT_VALOR
		Endif
    	
    	SE2->(DbSetOrder(1))
		SE2->(DbSeek(xFilial("SE2")+DET->DT_PREFIXO+DET->DT_NUMERO+DET->DT_PARCELA+DET->DT_TIPO+DET->DT_FORNECE+DET->DT_LOJA))
		If SE2->(Found())	
			RecLock("SE2",.F.)
			SE2->E2_MAILFOR := 'S'
			MsUnlock("SE2")
		Endif
		DET->(DbSkip())
	Enddo	

	If lRet 
		cMsg += '</tr>'
		cMsg += '<tr>'
	    cMsg += '<td>&nbsp;</td>'
	    cMsg += '<td>&nbsp;</td>'
	    cMsg += '<td>&nbsp;</td>'
	    cMsg += '<td>&nbsp;</td>'
	    cMsg += '<td>&nbsp;</td>'
	    cMsg += '<td>' + "Total (NF)" + '</td>'
	    cMsg += '<td>' + TRANSFORM(_nVlrt,"@E 999,999,999.99") + '</td>'
	    cMsg += '<td>&nbsp;</td>'
	    cMsg += '<td>&nbsp;</td>'
		cMsg += '</tr>'

		If _nPa > 0
			cMsg += '<tr>'
		    cMsg += '<td>&nbsp;</td>'
		    cMsg += '<td>&nbsp;</td>'
		    cMsg += '<td>&nbsp;</td>'
		    cMsg += '<td>&nbsp;</td>'
		    cMsg += '<td>&nbsp;</td>'
		    cMsg += '<td>' + "Total (PA) " + '</td>'
		    cMsg += '<td>' + TRANSFORM(_nPa,"@E 999,999,999.99") + '</td>'
		    cMsg += '<td>&nbsp;</td>'
		    cMsg += '<td>&nbsp;</td>'
			cMsg += '</tr>'
		Endif
		
		If _nDf > 0
			cMsg += '<tr>'
		    cMsg += '<td>&nbsp;</td>'
		    cMsg += '<td>&nbsp;</td>'
	    	cMsg += '<td>&nbsp;</td>'
		    cMsg += '<td>&nbsp;</td>'
		    cMsg += '<td>&nbsp;</td>'
		    cMsg += '<td>' + "Total (NDF)" + '</td>'
		    cMsg += '<td>' + TRANSFORM(_nDf,"@E 999,999,999.99") + '</td>'
		    cMsg += '<td>&nbsp;</td>'
		    cMsg += '<td>&nbsp;</td>'
			cMsg += '</tr>'
		Endif
 
		If _nDf > 0 .OR. _nPa > 0
			cMsg += '<tr>'
		    cMsg += '<td>&nbsp;</td>'
		    cMsg += '<td>&nbsp;</td>'
	    	cMsg += '<td>&nbsp;</td>'
		    cMsg += '<td>&nbsp;</td>'
		    cMsg += '<td>&nbsp;</td>'
		    cMsg += '<td>' + "S A L D O  " + '</td>'
		    cMsg += '<td>' + TRANSFORM((_nVlrt - _nDf - _nPa),"@E 999,999,999.99") + '</td>'
		    cMsg += '<td>&nbsp;</td>'
		    cMsg += '<td>&nbsp;</td>'
			cMsg += '</tr>'
		Endif


    Endif

    
	If lRet


		cMsg += '</table><br /><br />'

	    cMsg += '<b>' + "Pagamento(s) depositado em conta corrente."+ '</b><br /><br />'
	    cMsg += '<b>' + "Atenciosamente,"+ '</b><br /><br />'
	    cMsg += '<b>' + "Depto Financeiro - "+Alltrim(SM0->M0_NOME)+ '</b><br /><br />'

	    cMsg += '<b>' + "OBSERVACAO:"+ '</b><br /><br />'
	    cMsg += '<b>' + "Não responda a esta mensagem, pois foi enviada de um endereço de e-mail não monitorado as mensagens enviadas a este endereço não podem ser respondidas."+ '</b>'

		cMsg += '</body>'
		cMsg += '</html>'

		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
		If lConectou
			Send Mail from 'protheus@whbbrasil.com.br' To Alltrim(_cMail)+';'+Alltrim(GETMV("MV_FIN066"));
			SUBJECT 'Relacao de Pagamentos';
			BODY cMsg;
			RESULT lEnviado
			If !lEnviado
				Send Mail from 'protheus@whbbrasil.com.br' To 'marcosr@whbbrasil.com.br';		
				SUBJECT 'Relacao de Pagamentos';
				BODY cMsg;
				RESULT lEnviado
	    	Endif
		Endif
		lRet := .F.
	Endif

Enddo

DET->(DbGotop())
While !DET->(Eof())
	If !EMPTY(ALLTRIM(DET->DT_MARCA))
		RecLock("DET",.F.)
		Dele
		MsUnlock("DET")
	Endif
	DET->(DbSkip())
Enddo
DET->(Dbgotop())


Return(.T.)

User Function fMailf2()
	DET->(DbGotop())
	While !DET->(Eof())
		RecLock("DET",.F.)
		DET->DT_MARCA    := '*'
		MsUnlock("DET")
		DET->(DbSkip())
	Enddo
	DET->(Dbgotop())
Return

User Function fMailf3()
	DET->(DbGotop())
	While !DET->(Eof())
		RecLock("DET",.F.)
		DET->DT_MARCA    := ' '
		MsUnlock("DET")
		DET->(DbSkip())
	Enddo
	DET->(Dbgotop())
Return