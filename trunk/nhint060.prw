
#include "rwmake.ch"      

User Function nhint060()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_NRECNOSE2,_NVLR,")

// Pesquisa o Vlr a Lancar para acertar o Adiantamento de Viagem

_nRecnoSE2 := SE2->(Recno())

SE2->(DbSeek(xFilial("SE2")+"ADT"+SE1->E1_NUM))

_nVlr := 0

If SE2->(Found())
   _nVlr := SE2->E2_VALOR - SE1->E1_VALOR
Endif

SE2->(DbGoto(_nRecnoSE2))

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> __Return(_nVlr)
Return(_nVlr)        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

