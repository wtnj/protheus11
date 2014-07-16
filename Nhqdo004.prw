/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHQDO004  ºAutor  ³Marcosr R. Roquitskiº Data ³  04/14/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Abre o arquivo anexo ao documento.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Controle de documentos.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"

User Function Nhqdo004()
	SetPrvt("cComando,oRun,cPath,cArqExec")
	oRun := 0
	cComando := Space(10)
   cPath := Space(10)
   cArqExec := Space(10)

	If Substr(QDH->QDH_DOCTO,1,2) == "NT"
		cPath := "J:\Normas\"+Alltrim(QDH->QDH_ANEXO)
	
	Elseif Substr(QDH->QDH_DOCTO,1,2) == "DC"
		cPath := "J:\Desenhos\"+Alltrim(QDH->QDH_ANEXO)
		
	Elseif Substr(QDH->QDH_DOCTO,1,2) == "DD"
		cPath := "J:\Desenhos Dispositivos\"+Alltrim(QDH->QDH_ANEXO)
		
	Elseif Substr(QDH->QDH_DOCTO,1,2) == "DI"
		cPath := "J:\Desenhos Instrumentos\"+Alltrim(QDH->QDH_ANEXO)

	Elseif Substr(QDH->QDH_DOCTO,1,2) == "FF"
		cPath := "J:\Folha Ferramenta\"+Alltrim(QDH->QDH_ANEXO)
			
	Elseif Substr(QDH->QDH_DOCTO,1,2) == "FP"
		cPath := "J:\Fluxos\"+Alltrim(QDH->QDH_ANEXO)

	Elseif Substr(QDH->QDH_DOCTO,1,2) == "IT" .or. Substr(QDH->QDH_DOCTO,1,2) == "PR"
		cPath := "J:\IT_PR\"+Alltrim(QDH->QDH_ANEXO)

	Elseif Substr(QDH->QDH_DOCTO,1,2) == "TB" .or. Substr(QDH->QDH_DOCTO,1,2) == "FM"
		cPath := "J:\Registros\"+Alltrim(QDH->QDH_ANEXO)

	Elseif Substr(QDH->QDH_DOCTO,1,2) == "PC"
		cPath := "J:\Planos\"+Alltrim(QDH->QDH_ANEXO)

	Elseif Substr(QDH->QDH_DOCTO,1,2) == "MQ" .or. Substr(QDH->QDH_DOCTO,1,2) == "LV"
		cPath := "J:\Manuais_lv\"+Alltrim(QDH->QDH_ANEXO)

	Else
		cPath := "J:\Geral\"+Alltrim(QDH->QDH_ANEXO)

	Endif


	If UPPER(RIGHT(ALLTRIM(QDH->QDH_ANEXO),4)) == ".PDF"
		cArqExec := "C:\Arquivos de Programas\Adobe\Acrobat 5.0\Reader\ACRORD32.EXE "
      If File(cArqExec)
			cComando := "C:\Arquivos de Programas\Adobe\Acrobat 5.0\Reader\ACRORD32.EXE "
      Else
			cComando := "C:\Arquivos de Programas\Adobe\Acrobat 4.0\Reader\ACRORD32.EXE "
	   Endif
	Elseif UPPER(RIGHT(ALLTRIM(QDH->QDH_ANEXO),4)) $ ".DWG/.DWF/.DXF"
		cComando := "C:\Arquivos de programas\Volo View Express\Voloview.exe "

	Elseif UPPER(RIGHT(ALLTRIM(QDH->QDH_ANEXO),4)) $ ".HTM/.HTML"
		cComando := "C:\Arquivos de Programas\Internet Explorer\IEXPLORE.EXE "

	Elseif UPPER(RIGHT(ALLTRIM(QDH->QDH_ANEXO),4)) == ".XLS"
		cComando := "C:\Arquivos de Programas\Microsoft Office\Office\EXCEL.EXE "

	Elseif UPPER(RIGHT(ALLTRIM(QDH->QDH_ANEXO),4)) == ".DOC"
		cComando := "C:\Arquivos de Programas\Microsoft Office\Office\WINWORD.EXE "

	Elseif UPPER(RIGHT(ALLTRIM(QDH->QDH_ANEXO),4)) $ ".GIF/.BMP/.IPG/.IPEG/.PNG/.PCD/.PCX/.JPG"
		cComando := "C:\Arquivos de Programas\Arquivos comuns\Microsoft Shared\PHOTOED\PHOTOED.EXE "

	Elseif UPPER(RIGHT(ALLTRIM(QDH->QDH_ANEXO),4)) == ".TIF"
		cArqExec := "C:\Arquivos de Programas\Windows NT\Acessórios\ImageVue\KODAKIMG.EXE"
      If File(cArqExec)
			cComando := "C:\Arquivos de Programas\Windows NT\Acessórios\ImageVue\KODAKIMG.EXE "
      Else
			cComando := "C:\Windows\KODAKIMG.EXE "      
	   Endif

   Endif
	cComando := cComando + cPath

   If !Empty(QDH->QDH_ANEXO)

	   oRun:=WinExec(cComando)

		If (oRun==1)
			MSGSTOP("Memória Insuficiente","Atenção")
	
		Elseif (oRun==2)
			MSGSTOP("Arquivo não Encontrado","Atenção")

		Elseif (oRun==3)
			MSGSTOP("Caminho não Encontrado","Atenção")

		Endif
	Else
		MsgBox("Anexo nao disponivel, ou nao cadastraodo","Documentos","INFO")		

	Endif

Return

