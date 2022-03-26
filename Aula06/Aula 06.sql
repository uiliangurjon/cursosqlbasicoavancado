/****************************************************************************************************************
*    Curso de SQL do básico ao avançado                                                                         *
*    Aula 6                                                                                                     *
*****************************************************************************************************************/

/****************************************************************************************************************
* FASE 1: REALIZAÇÃO DE CONSULTAS SIMPLES                                                                       *
* Definições:                                                                                                   *
*	 SELECT <lista_de_campos> FROM <nome_tabela> WHERE <condição_de_filtragem>                                  *
*                                                                                                               *
*   SELECT: TRADUZINDO É SELECIONAR, COMANDO QUE PERMITE A RECUPERAÇÃO DE DADOS DE UM OBJETO DO BANCO DE DADOS  *
*           COMO UMA TABELA, UMA VIEW, E ALGUNS CASOS DE UMA STORED PROCEDURE (NEM TODOS OS SGBD PERMITEM)      *
*                                                                                                               *
*   FROM  : TRADUZINDO É DE, PORTANDO A PERGUNTA SERIA DE QUAL OBJETO QUEREMOS EXTRAIR OS DADOS, OU SEJA,       *
*           DE QUAL OBJETO DO BANCO (TABELA, VIEW, STORED PROCEDURE)                                            *
*                                                                                                               *
*****************************************************************************************************************/

/* CONSULTA 1: COMO LISTAR TODOS OS MEU CLIENTES E FORNECEDORES E TODAS AS COLUNAS DA TABELA */
SELECT * 
  FROM public.tabcfo;

/* CONSULTA 2: COMO LISTAR TODOS OS MEU CLIENTES E FORNECEDORES RETORNANDO COLUNAS ESPECÍFICAS IDCFO, TIPOCFO, RAZAOSOCIAL*/
SELECT  idcfo
       ,tipocfo
	   ,razaosocial 
  FROM public.tabcfo;

/* CONSULTA 3: COMO LISTAR TODOS OS MEU CLIENTES E FORNECEDORES RETORNANDO COLUNAS ESPECÍFICAS CPFCNPJ, TIPOCFO, RAZAOSOCIAL*/
SELECT  cpfcnpj
       ,tipocfo
	   ,razaosocial
  FROM public.tabcfo;

/* CONSULTA 4: COMO LISTAR TODOS OS MEU CLIENTES E FORNECEDORES UTILIZANDO ALIAS PARA AS COLUNAS CPFCNPJ, TIPOCFO, RAZAOSOCIAL
   
   ==== O QUE É UM ALIAS: ====
   PARA EXIBIR O RESULTADO DE UMA CONSULTA, O SQL NORMALMENTE UITLIZA O NOME DA COLUNA SELECIONADA COMO SEU CABEÇALHO.
   EM MUITOS CASOS ESSE NOME NÃO É AMIGAVEL, DIFICULTANDO O TRABALHO.
   PARA RESOLVER ESTE PROBLEMA VOCÊ PODE UTILIZAR DE UM RECURSO CHAMADO ALIAS, QUE NADA MAIS QUE DO QUE DIGITAR UM NOME AMIGAVEL PARA O CAMPO
   DICAS: 
         1: MESMO PODENDO UTILIZAR ACENTUÇÃO E CARACTERES ESPECIAIS (COMO *, %, &, #, @, Ç, :, ;, ETC.), MINHA RECOMENDAÇÃO É QUE ELES NÃO SEJAM UTILIZADOS.
		 2: OS CARACTERES HIFEN (-) E UNDERLINE (_) PODE SER UTILIZADOS.
		 3: SEMPRE UTILIZE O ALIAS 
*/
SELECT  cpfcnpj     AS "CPF_CNPJ"
       ,tipocfo     AS "TIPO_CLIENTE_FORNCEDOR"
	   ,razaosocial AS "NOME"
  FROM public.tabcfo;

/* CONSULTA 5: COMO LISTAR TODOS OS MEU CLIENTES E FORNECEDORES RETORNANDO APENAS O E-MAIL */
SELECT email  AS "E-MAIL_CLIENTES_FORNECEDORES"
  FROM public.tabcfo;

/* CONSULTA 6: COMO LISTAR DADOS NÃO REPETIDOS
   ==== O QUE É O INSTRUÇÃO DISTINCT: ====
   A INSTRUÇÃO É UTILIZADA PAR RETORNAR APENAS VALORES DISTINTOS OU SEJA VALORES NÃO REPETIDOS
   PENSE QUE DENTRO DE UMA TABELA PODE CONTER COLUNAS COM VALORES DUPLICADOS E AS VEZES PRECISAMOS LISTAR APENAS VALORES NÃO REPETIDOS
*/
--- TABELA DE CLIENTES E FORNECEDORES
SELECT *  
  FROM public.tabcfo;

SELECT DISTINCT *
  FROM public.tabcfo;

SELECT DISTINCT nomefantasia
  FROM public.tabcfo;
  
SELECT DISTINCT tipocfo
  FROM  public.tabcfo;
  
--- TABELA DE VENDAS  
SELECT * 
  FROM public.tabvendas;

SELECT DISTINCT idcfo
  FROM public.tabvendas;
 
SELECT DISTINCT idvendedor
   FROM public.tabvendas;

/****************************************************************************************************************
* FASE 2: REALIZAÇÃO DE CONSULTAS COM FILTRO DE VALORES                                                         *
*   ==== CLÁUSULA WHERE ====                                                                                    *
*       TRADUZINDO É ONDE, OU SEJA PERMITE A PASSAGEM DE CONDIÇÕES DE FILTRAGEM DAS LINHAS A SEREM EXIBIDAS     * 
*       IGUAL: =                                                                                                *
*       DIFERENTE: <>                                                                                           *
*       MAIOR: >                                                                                                *
*       MENOR: <                                                                                                *
*       MAIOR OU IGUAL: >=                                                                                      *
*       MENOR OU IGUAL: <=                                                                                      *
*       AND                                                                                                     *
*       OR                                                                                                      *
*       LIKE                                                                                                    *
*       IS NULL                                                                                                 *
*       IS NOT NULL                                                                                             *
*       IN                                                                                                      *
*       BETWEEN                                                                                                 *
*****************************************************************************************************************/


/* CONSULTA 1: COMO CONTAR LINHAS DE UMA TABLEA
   ==== O QUE É O INSTRUÇÃO COUNT: ====
   A INSTRUÇÃO É UTILIZADA PAR RETORNAR O NUMERO DE LINHAS (CONTAGEM) QUE CORRESPONDE A UM CRITÉRIO ESPECIFICADO
*/
--CONTAGEM SIMPLES
SELECT COUNT(idvenda) AS "QUANTIDADE_VENDAS"
  FROM public.tabvendas;
  
--CONTAGEM COM WHERE (FILTRO COM APENAS UMA CONDIÇÃO)
SELECT COUNT(idvenda) AS "QUANTIDADE_VENDAS_EMPRESA_1"
  FROM public.tabvendas
 WHERE idempresa = 1;
 
SELECT COUNT(idvenda) AS "QUANTIDADE_VENDAS_EMPRESA_2"
  FROM public.tabvendas
 WHERE idempresa = 2;

SELECT COUNT(idvenda) AS "QUANTIDADE_VENDAS_VENDEDOR_1"
  FROM public.tabvendas
 WHERE idvendedor = 1;

SELECT COUNT(idvenda) AS "QUANTIDADE_VENDAS_VENDEDOR_4"
  FROM public.tabvendas
 WHERE idvendedor = 4;

SELECT COUNT(idvenda) AS "QUANTIDADE_VENDAS_POR_DATA"
  FROM public.tabvendas
 WHERE dtvenda = '2006-03-06';

SELECT COUNT(idvenda) AS "QUANTIDADE_VENDAS_POR_DATA"
  FROM public.tabvendas
 WHERE dtvenda > '2006-03-06';
 
SELECT COUNT(idvenda) AS "QUANTIDADE_VENDAS_POR_DATA"
  FROM public.tabvendas
 WHERE dtvenda < '2006-03-06'; 

SELECT COUNT(idvenda) AS "QUANTIDADE_VENDAS_POR_DATA"
  FROM public.tabvendas
 WHERE dtvenda <= '2006-03-06'; 
 
SELECT COUNT(idvenda) AS "QUANTIDADE_VENDAS_POR_DATA"
  FROM public.tabvendas
 WHERE dtvenda >= '2006-03-06';
 
SELECT COUNT(idvenda) AS "QUANTIDADE_VENDAS_POR_DATA"
  FROM public.tabvendas
 WHERE dtvenda <> '2006-03-06';

-- WHERE FILTRO COM 2 OU MAIS CONDIÇÕES
SELECT COUNT(idcidade) AS "QUANTIDADE_CIDADES"
  FROM public.tabcidades;

SELECT idcidade, nomecidade AS "NOME_CIDADE"
  FROM public.tabcidades
 WHERE nomecidade = 'São Paulo';
 
SELECT idcidade, nomecidade
  FROM public.tabcidades
 WHERE nomecidade = 'São Paulo' OR nomecidade = 'Rio de Janeiro';

SELECT idcidade, nomecidade, codigoibge, idestado
  FROM public.tabcidades
 WHERE idestado = 1 OR idestado = 20;

SELECT idcidade, nomecidade, codigoibge, idestado
  FROM public.tabcidades
 WHERE nomecidade = 'Ribeirão Preto' AND idestado = 20;
 
SELECT idcidade, nomecidade, codigoibge, idestado
  FROM public.tabcidades
 WHERE nomecidade = 'Curitiba' AND idestado = 20;

SELECT idcidade, nomecidade, codigoibge, idestado
  FROM public.tabcidades
 WHERE nomecidade LIKE 'Sa%' AND idestado = 20;
 
SELECT idcidade, nomecidade, codigoibge, idestado
  FROM public.tabcidades
 WHERE nomecidade LIKE '%sta' AND idestado = 20;
 
SELECT idcidade, nomecidade, codigoibge, idestado
  FROM public.tabcidades
 WHERE nomecidade LIKE '%ta%' AND idestado = 20;

SELECT idcidade, nomecidade, codigoibge, idestado
  FROM public.tabcidades
 WHERE nomecidade LIKE '%ta%' AND idestado = 20 AND codigoibge LIKE '3500%';

SELECT idcidade, nomecidade, codigoibge, idestado
  FROM public.tabcidades
 WHERE (nomecidade LIKE '%ta' OR nomecidade LIKE 'C%') AND idestado = 20;

SELECT idcidade, nomecidade, codigoibge, idestado
  FROM public.tabcidades
 WHERE idestado IN (1,20);

SELECT idcidade, nomecidade, codigoibge, idestado
  FROM public.tabcidades
 WHERE idestado IN (1,2,5);

SELECT idcidade, nomecidade, codigoibge, idestado
  FROM public.tabcidades
 WHERE idestado NOT IN (1,2,5);
 
SELECT idempresa, idcfo, tipo, numero, campolivre
  FROM public.tabcfotelefones
 WHERE campolivre IS NULL;
 
SELECT idempresa, idcfo, tipo, numero, campolivre
  FROM public.tabcfotelefones
 WHERE campolivre IS NULL AND tipo = 'Fixo';
 
SELECT idempresa, idcfo, tipo, numero, campolivre
  FROM public.tabcfotelefones
 WHERE campolivre IS NULL AND numero LIKE '(78%';

SELECT idempresa, idcfo, tipo, numero, campolivre
  FROM public.tabcfotelefones
 WHERE campolivre IS NOT NULL;

SELECT idempresa, idcfo, tipo, numero, campolivre
  FROM public.tabcfotelefones
 WHERE campolivre IS NOT NULL AND idcfo in (1844, 890, 863);

SELECT idempresa, idvenda, idcfo, idvendedor, dtvenda
  FROM public.tabvendas
 WHERE dtvenda BETWEEN '2006-01-01' AND '2006-12-31';

SELECT idempresa, idvenda, idcfo, idvendedor, dtvenda
  FROM public.tabvendas
 WHERE idcfo BETWEEN 60 AND 100;


