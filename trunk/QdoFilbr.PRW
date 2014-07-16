/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQDOFILBR  บAutor  ณMarcos R. Roquitski บ Data ณ  07/05/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Filtra documentos.                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#Include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
                                                                  
User Function Qdofilbr()

Private _cFilQdo := ' '

If Upper(Alltrim(Funname())) $ "NHQDO017"
                                                                                     
	If Valtype("_cFil1") <> "U"

		If Substr(_cFil1,1,1) == '1'
			_cFilQdo := 'QDH->QDH_PLANTA == "1" .and. QDH_FILIAL == "'+xFilial("QDH")+'" .and. ( (QDH_CANCEL != "S" .or. ( QDH_CANCEL == "S".and. QDH_STATUS!="L  " ) ) .and. ( (QDH_OBSOL !="S" .And. Dtos(QDH_DTVIG) <= "'+Dtos(dDataBase)+'" ) .or.( QDH_OBSOL == "S" .and. Dtos(QDH_DTLIM) >= "'+Dtos(dDataBase)+'" )))'

		Elseif Substr(_cFil1,1,1) == '2'
			_cFilQdo := 'QDH->QDH_PLANTA == "2" .and. QDH_FILIAL == "'+xFilial("QDH")+'" .and. ( (QDH_CANCEL != "S" .or. ( QDH_CANCEL == "S".and. QDH_STATUS!="L  " ) ) .and. ( (QDH_OBSOL !="S" .And. Dtos(QDH_DTVIG) <= "'+Dtos(dDataBase)+'" ) .or.( QDH_OBSOL == "S" .and. Dtos(QDH_DTLIM) >= "'+Dtos(dDataBase)+'" )))'

		ElseIf Substr(_cFil1,1,1) == '3'
			_cFilQdo := 'QDH->QDH_PLANTA == "3" .and. QDH_FILIAL == "'+xFilial("QDH")+'" .and. ( (QDH_CANCEL != "S" .or. ( QDH_CANCEL == "S".and. QDH_STATUS!="L  " ) ) .and. ( (QDH_OBSOL !="S" .And. Dtos(QDH_DTVIG) <= "'+Dtos(dDataBase)+'" ) .or.( QDH_OBSOL == "S" .and. Dtos(QDH_DTLIM) >= "'+Dtos(dDataBase)+'" )))'

		ElseIf Substr(_cFil1,1,1) == '4'
			_cFilQdo := 'QDH->QDH_PLANTA == "4" .and. QDH_FILIAL == "'+xFilial("QDH")+'" .and. ( (QDH_CANCEL != "S" .or. ( QDH_CANCEL == "S".and. QDH_STATUS!="L  " ) ) .and. ( (QDH_OBSOL !="S" .And. Dtos(QDH_DTVIG) <= "'+Dtos(dDataBase)+'" ) .or.( QDH_OBSOL == "S" .and. Dtos(QDH_DTLIM) >= "'+Dtos(dDataBase)+'" )))'

		ElseIf Substr(_cFil1,1,1) == '5'
			_cFilQdo := 'QDH->QDH_PLANTA == "5" .and. QDH_FILIAL == "'+xFilial("QDH")+'" .and. ( (QDH_CANCEL != "S" .or. ( QDH_CANCEL == "S".and. QDH_STATUS!="L  " ) ) .and. ( (QDH_OBSOL !="S" .And. Dtos(QDH_DTVIG) <= "'+Dtos(dDataBase)+'" ) .or.( QDH_OBSOL == "S" .and. Dtos(QDH_DTLIM) >= "'+Dtos(dDataBase)+'" )))'

		ElseIf Substr(_cFil1,1,1) == '6'
			_cFilQdo := 'QDH->QDH_PLANTA == "6" .and. QDH_FILIAL == "'+xFilial("QDH")+'" .and. ( (QDH_CANCEL != "S" .or. ( QDH_CANCEL == "S".and. QDH_STATUS!="L  " ) ) .and. ( (QDH_OBSOL !="S" .And. Dtos(QDH_DTVIG) <= "'+Dtos(dDataBase)+'" ) .or.( QDH_OBSOL == "S" .and. Dtos(QDH_DTLIM) >= "'+Dtos(dDataBase)+'" )))'

		ElseIf Substr(_cFil1,1,1) == '7'
			_cFilQdo := 'QDH->QDH_PLANTA == "7" .and. QDH_FILIAL == "'+xFilial("QDH")+'" .and. ( (QDH_CANCEL != "S" .or. ( QDH_CANCEL == "S".and. QDH_STATUS!="L  " ) ) .and. ( (QDH_OBSOL !="S" .And. Dtos(QDH_DTVIG) <= "'+Dtos(dDataBase)+'" ) .or.( QDH_OBSOL == "S" .and. Dtos(QDH_DTLIM) >= "'+Dtos(dDataBase)+'" )))'
		
		Else
			_cFilQdo := 'QDH_FILIAL == "'+xFilial("QDH")+'" .and. ( (QDH_CANCEL != "S" .or. ( QDH_CANCEL == "S".and. QDH_STATUS!="L  " ) ) .and. ( (QDH_OBSOL !="S" .And. Dtos(QDH_DTVIG) <= "'+Dtos(dDataBase)+'" ) .or.( QDH_OBSOL == "S" .and. Dtos(QDH_DTLIM) >= "'+Dtos(dDataBase)+'" )))' 
              
		Endif      
	
	Endif		
	
Endif  

Return(_cFilQdo)
