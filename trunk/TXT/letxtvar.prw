#include "rwmake.ch"

User Function TXTDBF()
Local cArq := ""
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � LETXT    � Autor � Daniel Possebon       � Data � 07/02/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � PROGRAMA DE EXEMPLO DE IMPORTACAO DE TXT                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
Obs.: Este programa assume que todas as linhas do arquivo texto sao do mesmo
      tamanho, ou seja, padronizadas. Se o arquivo nao conter todos as linhas
      do mesmo tamanho, o arquivo pode estar danificado.
/*/


//����������������������������������������������������������������������������������Ŀ
//�Tamanho da linha no arquivo texto.                                                �
//�                                                                                  �
//���������                                                                          �
//�ATENCAO                                                                           �
//���������                                                                          �
//�1) TODAS as linhas devem ser do mesmo tamanho                                     �
//�2) CONTE os caracteres de uma linha e coloque este valor na variavel nTamLin      �
//�3) ERROS, como leitura parcial do arquivo, gravacao dos dados incorretamente, etc,�
//�podem ocorrer devido as linhas nao serem do mesmo tamanho ou o valor ser informado�
//�incorretamente nesta variavel.                                                    �
//������������������������������������������������������������������������������������


cArq    := cGetFile()

ft_fuse(cArq)


// O seguinte loop permanecera executando ate que nao consigamos ler mais
// uma linha inteira. Por isso a necessidade de que o arquivo contenha linhas
// do mesmo tamanho.
// Mais dois por causa das marcas de final de linha (CHR(13)+CHR(10))

While ! ft_feof()

    //�������������������������������������������������������������Ŀ
    //� Neste momento, ja temos uma linha lida. Gravamos os valores �
    //� obtidos retirando-os da linha lida.                         �
    //���������������������������������������������������������������
     cBuff := ft_freadln()
     alert(cBuff)
     ft_fskip()
EndDo

ft_fuse()

Return
