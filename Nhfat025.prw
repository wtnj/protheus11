/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHFAT025  ºAutor  ³Alexandre R. Bento  º Data ³  14/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia email de Avisos Sob Prazo de Retorno da NF            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"                 
#include "topconn.ch"                 

User Function Nhfat025()

SetPrvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cMail,_cNome,_cTempo")
SetPrvt("cQuery")


_cPerg    := "FAT025" 

// Parametros Utilizados
// mv_par01 = Data inicial
// mv_par02 = Data final
// mv_par03 = codigo do produto inicial
// mv_par04 = codigo do produto final
// mv_par05 = Email para enviar a relacao


Pergunte('FAT025',.T.)

cServer	  := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.11"
cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga'
lConectou
lEnviado
cMensagem := '' 
CRLF := chr(13)+chr(10)
cMSG := ""
lEnd := .F.   
e_email = .F.                         


If Empty(mv_par05)
   MsgBox("Favor Preencher o Parametro Com o email p/ Envio da Relacao das notas","Enviar e-mail","STOP")
   Return
Endif

fEmaiNF()


Return(.t.)

Static Function fEmaiNF()
Local lRet := .F.
Local _nTotPro := 0
Local _nTotDes := 0
Local _nZero := 0
Local _cMes := Space(20)
Local _aFile := {}
Local _nEnvia := 0
Local _aFile3 := {}
Local _nCout := 0
Local _cFornec

fQuery()     

TRA1->(Dbgotop())

If Empty(TRA1->B6_DOC) //se vazio sai do programa
   MsgBox("Nao foi Selecionada Nenhuma Nota Fiscal" ,"Enviar e-mail","ALERT")
   TRA1->(DbCloseArea())   
   Return
Endif


_cMail := mv_par05

cMsg := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><meta http-equiv="Content-type" content="text/html; charset=iso-8859-1" />' 
cMsg += '<head>' 
cMsg += '<title>.</title>' 
cMsg += '<style>.centraliza { text-align: center; };.tdfornecedor {background:#F0F0F0;color:#0000cc;font-size:10px;};.BODY{font-family:Verdana;font-size:11px;}</style>'    

cMsg += '</head>'
cMsg += '<body>' 
cMsg += '<p><strong><font size="3" face="Arial">Rela&ccedil;&atilde;o de Notas Fiscais Pendentes de Retorno</font></strong></p>' 

cMsg += '<table style="font-family:arial" width="100%" border="1">'
cMsg += '<tr>'
cMsg += '<td colspan="8" class="centraliza" style="background:#ccc">Rela&ccedil;&atilde;o de Notas Fiscais '+Iif(SM0->M0_CODIGO$"NH"," WHB Usinagem"," WHB Fundi&ccedil;&atilde;o") +'</td>'
cMsg += '</tr>'

cMsg += '<tr style="background:#aabbcc">' 
cMsg += '<td  class="centraliza">Nota</td>'
cMsg += '<td  class="centraliza">S&eacute;rie</td>'
cMsg += '<td  class="centraliza">Produto</td>'
cMsg += '<td  class="centraliza">Descri&ccedil;&atilde;o</td>'	
cMsg += '<td  class="centraliza">Emiss&atilde;o</td>'
cMsg += '<td  class="centraliza">B6 Ident</td>'
cMsg += '<td  class="centraliza">Qtde Original</td>'
cMsg += '<td  class="centraliza">Saldo</td>'


cMsg += '</tr>'			

cMsg += '<tr>'
cMsg += '<td colspan="8" class="tdfornecedor">Fornecedor: '+TRA1->A2_COD + '-'+TRA1->A2_LOJA+'  '+TRA1->A2_NOME+' Fone: '+ TRA1->A2_TEL + '</td>' 
cMsg += '</tr>'

_cFornec := TRA1->A2_COD+TRA1->A2_LOJA    

While !TRA1->(Eof())

   If _cFornec <> TRA1->A2_COD+TRA1->A2_LOJA    
      cMsg += '<tr>'
      cMsg += '<td colspan="8" class="tdfornecedor">Fornecedor: '+TRA1->A2_COD + '-'+TRA1->A2_LOJA+'  '+TRA1->A2_NOME+' Fone: '+ TRA1->A2_TEL + '</td>' 
      cMsg += '</tr>'
      _cFornec := TRA1->A2_COD+TRA1->A2_LOJA       
   Endif   


   cMsg += '<tr style="background:#eeeeee;font-size:12px">'	
   cMsg += '<td  class="centraliza">'+TRA1->B6_DOC+'</td>'//Nota
   cMsg += '<td  class="centraliza">'+TRA1->B6_SERIE+'</td>'//item	
   cMsg += '<td  class="centraliza">'+TRA1->B6_PRODUTO+'</td>'//produto
   cMsg += '<td  class="centraliza">'+TRA1->B1_DESC+'</td>'//descricao
   cMsg += '<td  class="centraliza">'+DtoC(TRA1->B6_EMISSAO)+'</td>'//Emissao
   cMsg += '<td  class="centraliza">'+TRA1->B6_IDENT+'</td>'//produto   
   cMsg += '<td  class="centraliza">'+Str(TRA1->B6_QUANT)+'</td>'//quantidade
   cMsg += '<td  class="centraliza">'+Str(TRA1->B6_SALDO)+'</td>'//quantidade   
   cMsg += '</tr>'			
	
   _nCout += 1
	
	If _nCout > 500
	  fRodape()
	  fCabec() 
      _nCout := 0
	Endif  
	
	TRA1->(DbSkip())
	
Enddo

cMsg += '<tr>'
cMsg += '<td colspan="8"  class="centraliza" style="background:#ccc;color:red">Mensagem Processada automaticamente. Favor n&atilde;o responder este email.</td>'
cMsg += '</tr>'

cMsg += '<tr>'
cMsg += '<td colspan="8"  class="centraliza" style="background:#ccc;color:red">ICMS - Suspenso pelo prazo de 180 dias conforme o art .299 do RICMS/PR decreto 1.980 de 21/12/07 </td>' 
cMsg += '</tr>'
cMsg += '<tr>'
cMsg += '<td colspan="8"  class="centraliza" style="background:#ccc;color:red">IPI - Suspenso conforme art. 42 do RIPI decreto 4.544 de 26/12/02.</td>' 
cMsg += '</tr>'

cMsg += '</table>' 

cMsg += '</body></html>' 

MemoWrit('C:\TEMP\FATHTML.html',cMsg) 

       
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
If lConectou
	Send Mail from 'protheus@whbbrasil.com.br' To Alltrim(_cMail);
	SUBJECT ' Relação de Notas Fiscais ';
	BODY cMsg;
	RESULT lEnviado
Endif
lRet := .F.

Msgbox("Processo concluido com sucesso !","Enviar email","ALERT")
TRA1->(DbCloseArea())

Return(.T.)


Static Function fQuery()                                  

	cQuery := "SELECT B1.B1_TIPO,B6.B6_PRODUTO,B1.B1_DESC,B6.B6_DOC,B6.B6_SERIE,B6.B6_QUANT,B6.B6_EMISSAO,B6.B6_SALDO,A2.A2_COD,A2.A2_NOME,A2.A2_TEL,A2.A2_LOJA,B6.B6_IDENT"
	cQuery += " FROM "+RetSqlName("SB6")+" B6, "+RetSqlName("SF4")+" F4, "+RetSqlName("SB1")+" B1, "+RetSqlName("SA2")+" A2"				
	cQuery += " WHERE B6.D_E_L_E_T_ =''"
	cQuery += " AND F4.D_E_L_E_T_ =''" 
	cQuery += " AND A2.D_E_L_E_T_ =''" 	
	cQuery += " AND B1.D_E_L_E_T_ =''"
	cQuery += " AND F4.F4_FILIAL = '"+xFilial("SF4")+"'"
	cQuery += " AND A2.A2_FILIAL = '"+xFilial("SA2")+"'"
	cQuery += " AND B1.B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery += " AND B6.B6_FILIAL = '"+xFilial("SB6")+"'"
	cQuery += " AND F4.F4_PODER3 = 'R'"
 	cQuery += " AND F4.F4_CODIGO >= '500'"
	cQuery += " AND F4.F4_CODIGO = B6.B6_TES"
	cQuery += " AND B6.B6_CLIFOR = A2.A2_COD"
    cQuery += " AND B6.B6_LOJA = A2.A2_LOJA"		
	cQuery += " AND B6.B6_SALDO > 0"
    cQuery += " AND B6.B6_EMISSAO >= '" + Dtos(mv_par01) + "' AND B6.B6_EMISSAO <= '" + Dtos(mv_par02) +"'"
    cQuery += " AND B1.B1_COD BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"	
    cQuery += " AND B1.B1_GRUPO BETWEEN '" + mv_par06 + "' AND '" + mv_par07 + "'"	    
    cQuery += " AND B6.B6_CLIFOR BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'"	        
	cQuery += " AND B1.B1_COD = B6.B6_PRODUTO"
//	cQuery += " AND B1.B1_TIPO IN ('FE')"
	cQuery += " ORDER BY A2.A2_COD,A2.A2_LOJA,B1.B1_TIPO,B6.B6_EMISSAO,B6.B6_DOC,B6.B6_PRODUTO" 

    MemoWrit('C:\TEMP\FAT025.SQL',cQuery)

   //TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TRA1"  
	TcSetField("TRA1","B6_EMISSAO","D")  // Muda a data de string para date    
	
Return

Static Function fRodape()

cMsg += '<tr>'
cMsg += '<td colspan="8"  class="centraliza" style="background:#ccc;color:red">Mensagem Processada automaticamente. Favor n&atilde;o responder este email.</td>'
cMsg += '</tr>'

cMsg += '<tr>'
cMsg += '<td colspan="8"  class="centraliza" style="background:#ccc;color:red">ICMS - Suspenso pelo prazo de 180 dias conforme o art .299 do RICMS/PR decreto 1.980 de 21/12/07 </td>' 
cMsg += '</tr>'
cMsg += '<tr>'
cMsg += '<td colspan="8"  class="centraliza" style="background:#ccc;color:red">IPI - Suspenso conforme art. 42 do RIPI decreto 4.544 de 26/12/02.</td>' 
cMsg += '</tr>'

cMsg += '</table>' 

cMsg += '</body></html>' 

MemoWrit('C:\TEMP\FATHTML.html',cMsg) 

       
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
If lConectou
	Send Mail from 'protheus@whbbrasil.com.br' To Alltrim(_cMail);
	SUBJECT ' Relação de Notas Fiscais ';
	BODY cMsg;
	RESULT lEnviado
Endif


Return(.T.)


Static Function fCabec()
cMsg := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><meta http-equiv="Content-type" content="text/html; charset=iso-8859-1" />' 
cMsg += '<head>' 
cMsg += '<title>.</title>' 
cMsg += '<style>.centraliza { text-align: center; };.tdfornecedor {background:#F0F0F0;color:#0000cc;font-size:10px;};.BODY{font-family:Verdana;font-size:11px;}</style>'    

cMsg += '</head>'
cMsg += '<body>' 
cMsg += '<p><strong><font size="3" face="Arial">Rela&ccedil;&atilde;o de Notas Fiscais Pendentes de Retorno</font></strong></p>' 

cMsg += '<table style="font-family:arial" width="100%" border="1">'
cMsg += '<tr>'
cMsg += '<td colspan="8" class="centraliza" style="background:#ccc">Rela&ccedil;&atilde;o de Notas Fiscais '+Iif(SM0->M0_CODIGO$"NH"," WHB Usinagem"," WHB Fundi&ccedil;&atilde;o") +'</td>'
cMsg += '</tr>'

cMsg += '<tr style="background:#aabbcc">' 
cMsg += '<td  class="centraliza">Nota</td>'
cMsg += '<td  class="centraliza">S&eacute;rie</td>'
cMsg += '<td  class="centraliza">Produto</td>'
cMsg += '<td  class="centraliza">Descri&ccedil;&atilde;o</td>'	
cMsg += '<td  class="centraliza">Emiss&atilde;o</td>'
cMsg += '<td  class="centraliza">B6 Ident</td>'
cMsg += '<td  class="centraliza">Qtde Original</td>'
cMsg += '<td  class="centraliza">Saldo</td>'
cMsg += '</tr>'			

cMsg += '<tr>'
cMsg += '<td colspan="8" class="tdfornecedor">Fornecedor: '+TRA1->A2_COD + '-'+TRA1->A2_LOJA+'  '+TRA1->A2_NOME+'</td><td class="tdfornecedor">Fone: '+ TRA1->A2_TEL + '</td>' 
cMsg += '</tr>'

Return(.T.)


