/****************************************************************************************************************
*    Curso de SQL do básico ao avançado                                                                         *
*    Aula 7                                                                                                     *
*****************************************************************************************************************/

/******************************************************************************************************************
* FASE 1: REALIZAÇÃO DE CONSULTAS ORDENADAS                                                                       *
* Definições:                                                                                                     *
*	 SELECT <lista_de_campos> FROM <nome_tabela> WHERE <condição_de_filtragem> ORDER BY <lista_de_campos>         *
*                                                                                                                 *
*   SELECT: TRADUZINDO É SELECIONAR, COMANDO QUE PERMITE A RECUPERAÇÃO DE DADOS DE UM OBJETO DO BANCO DE DADOS    *
*           COMO UMA TABELA, UMA VIEW, E ALGUNS CASOS DE UMA STORED PROCEDURE (NEM TODOS OS SGBD PERMITEM)        *
*                                                                                                                 *
*     FROM: TRADUZINDO É DE, PORTANDO A PERGUNTA SERIA DE QUAL OBJETO QUEREMOS EXTRAIR OS DADOS, OU SEJA,         *
*           DE QUAL OBJETO DO BANCO (TABELA, VIEW, STORED PROCEDURE)                                              *
*                                                                                                                 *
*    WHERE: TRADUZINDO É ONDE, OU SEJA PERMITE A PASSAGEM DE CONDIÇÕES DE FILTRAGEM DAS LINHAS A SEREM EXIBIDAS   * 
*           IGUAL =  | DIFERENTE <>  | MAIOR >  | MENOR < | MAIOR OU IGUAL >= | MENOR OU IGUAL <=                 *
*           AND | OR | LIKE | IS NULL | IS NOT NULL | IN | BETWEEN                                                *
*                                                                                                                 *
* ORDER BY: TRADUZINDO É ORDENAR POR, ESTA CLÁUSULA É UTILIZADA PARA ORDENAR O RESULTADO DA CONSULTA DE ACORDO    *
            COM UMA OU MAIS COLUNAS DA TABELA, PODENDO DEFINIR A ORDEM DO RESULTADO COMO CRESCENTE OU DECRESCENTE *
*******************************************************************************************************************/

/* CONSULTA 1: COMO LISTAR TODOS OS MEUS CLIENTES E FORNECEDORES E TODAS AS COLUNAS DA TABELA E ORDENAR PELO CAMPO IDCFO */
   SELECT * 
     FROM public.tabcfo
 ORDER BY IDCFO;

/* CONSULTA 2: COMO LISTAR TODOS OS MEUS CLIENTES E FORNECEDORES RETORNANDO COLUNAS ESPECÍFICAS IDCFO, TIPOCFO, RAZAOSOCIAL
               E ORDERNAR POR RAZÃO SOCIAL EM ORDEM DECRESCENTE (DE Z-A) */
  SELECT  idcfo
         ,tipocfo
	     ,razaosocial 
    FROM public.tabcfo
ORDER BY razaosocial DESC;

/* CONSULTA 3: COMO LISTAR TODOS OS MEUS CLIENTES E FORNECEDORES RETORNANDO COLUNAS ESPECÍFICAS CPFCNPJ, TIPOCFO, RAZAOSOCIAL
               E ORDENAR POR RAZÃO SOCIAL EM ORDEM CRESCENTE (DE A-Z) */
  SELECT  cpfcnpj
         ,tipocfo
	     ,razaosocial
    FROM public.tabcfo
ORDER BY razaosocial ASC;

/* CONSULTA 4: COMO LISTAR TODOS OS MEUS CLIENTES E FORNECEDORES UTILIZANDO ALIAS PARA AS COLUNAS CPFCNPJ, TIPOCFO, RAZAOSOCIAL
               E ORDENAR OS RESULTADOS POR TIPO DE CLIENTE E RAZAO SOCIAL
*/
  -- RELEMBRANDO O COMANDO DISTINCT
  SELECT DISTINCT tipocfo 
    FROM public.tabcfo
  
  SELECT  cpfcnpj     AS "CPF_CNPJ"
         ,tipocfo     AS "TIPO_CLIENTE_FORNCEDOR"
	     ,razaosocial AS "NOME"
    FROM public.tabcfo
ORDER BY tipocfo, razaosocial;

/* CONSULTA 5: COMO LISTAR TODOS OS MEU CLIENTES E FORNECEDORES RETORNANDO APENAS O E-MAIL UTILIZANDO UM ALIAS 
               E ORDENADO POR ORDEM ALFABÉTICA */
  SELECT email  AS "E-MAIL_CLIENTES_FORNECEDORES"
    FROM public.tabcfo
ORDER BY email;

/* CONSULTA 6: LISTAR CLIENTE QUE NÃO TENHAM NOME FANTASIA REPETIDO E ORDENÁ-LOS DE FORMA DECRESCENTE */
--- TABELA DE CLIENTES E FORNECEDORES
SELECT *  
  FROM public.tabcfo;

SELECT DISTINCT *
  FROM public.tabcfo;

  SELECT DISTINCT nomefantasia
    FROM public.tabcfo
ORDER BY nomefantasia;

--- TABELA DE VENDAS
/* CONSULTA 7: LISTAR APENAS CLIENTES QUE NÃO SE REPETEM NA TABELA DE VENDAS E ORDENA-LOS POR IDCFO */
SELECT * 
  FROM public.tabvendas;

  SELECT DISTINCT 
         idcfo
    FROM public.tabvendas
ORDER BY idcfo;

/* CONSULTA 8: LISTAR VENDAS POR CLIENTES E ORDENA-LOS POR IDCFO E DATA DA VENDA*/
  SELECT DISTINCT idvenda
                 ,idcfo
                 ,idvendedor
  	  		     ,dtvenda
    FROM public.tabvendas
ORDER BY idcfo
        ,dtvenda;

/* IDENTIFICAMOS ALGUNS PROBLEMAS COM DATAS, VAMOS CORRIGIR UTILIZANDO CONHECIMENTOS APRENDIDOS NAS AULAS ANTERIORES */
UPDATE tabvendas 
   SET dtvenda = '2007-02-02' 
 WHERE idvenda = 2040;

UPDATE tabvendas 
   SET dtvenda = '2008-01-02' 
 WHERE idvenda = 2564;

/* CONSULTA 9: LISTAR VENDAS POR CLIENTES E ORDENA-LOS POR IDVENDEDOR, IDCFO E DATA DA VENDA*/
  SELECT DISTINCT idvenda
                 ,idvendedor
				 ,idcfo                 
  	  		     ,dtvenda
    FROM public.tabvendas
ORDER BY idvendedor
        ,idcfo
		,dtvenda;

/* CONSULTA 10: LISTAR VENDAS POR CLIENTES E ORDENA-LOS CRESCENTE POR IDVENDEDOR, IDCFO 
                E DE FORMA DECRESCENTE POR DATA DA VENDA*/
  SELECT DISTINCT idvenda
                 ,idvendedor
				 ,idcfo                 
  	  		     ,dtvenda
    FROM public.tabvendas
ORDER BY idvendedor
        ,idcfo ASC
		,dtvenda DESC;
		
/*******************************************************************************************************************
 * FASE 2: REALIZAÇÃO DE CONSULTAS COM FILTRO AGRUPAMENTO DE VALORES                                               *
 *   ==== CLÁUSULA  GROUP BY ====                                                                                  *
 *       TRADUZINDO É AGRUPE POR, ESTA CLÁUSULA É UTILIZADA PARA AGRUPAR LINHA BASEADAS EM SEMELHANÇAS ENTRE ELAS. *
 *       VOCÊ PODE, POR EXEMPLO, AGRUPAR TODAS A LINHA DA TABELA DE CLIENTE/FORNECEDOR COM BASE EM SUA CIDADE, O   *
 *       O RESULTADO SERIA UM GRUPO DE CLIENTES/FORNECEDORES POR CIDADE.  A PARTIR DESTE PONTO, VOCÊ PODERIA SE    *
 *       QUESTIONAR QUANTOS CLIENTES/FORNECEDORES SUA TABELA POSSUI POR CIDADE.                                    *
 *       PARA RESOLVER ESTA QUESTÃO E ALGUMAS OUTRAS QUE VAMOS ESTUDAR VAMOS APRENDER MAIS ALGUMAS FUNÇÕES DE      *
 *       AGREGAÇÃO.                                                                                                *
 *                                                                                                                 *
 *         SUM: RETORNA A SOMATÓRIA DE UM CONJUNTO DE REGISTROS                                                    *
 *         MAX: RETORNA O VALOR MÁXIMO DE UM DETERMINADO CAMPO                                                     *
 *         MIN: RETORNA O VALOR MÁXIMO DE UM DETERMINADO CAMPO                                                     *
 *         AVG: RETORNA O VALOR MÉDIO DE UM GRUPO DE REGISTROS                                                     *
 *       COUNT: DETERMINAR O VALOR TOTAL DE REGISTROS QUE ATENDA UMA CONDIÇÃO                                      *
 *******************************************************************************************************************/


/* CONSULTA 1: RETORNAR A QUANTIDADE DE VENDAS POR CLIENTE/FORNECEDOR */
  SELECT  idcfo
         ,COUNT(idvenda) AS "TOTAL_DE_VENDAS"
    FROM public.tabvendas
   WHERE idempresa = 1
GROUP BY idcfo;
 
/* CONSULTA 2: RETORNAR A QUANTIDADE DE VENDAS POR CLIENTE/FORNECEDOR E ORDENADO POR IDCFO */ 
  SELECT  idcfo
         ,COUNT(idvenda) AS "TOTAL_DE_VENDAS"
    FROM public.tabvendas
   WHERE idempresa = 1
GROUP BY idcfo
ORDER BY idcfo;

/* CONSULTA 3: RETORNAR A QUANTIDADE DE VENDAS POR CLIENTE/FORNECEDOR, ORDENADO POR IDCFO E TOTAL DE VENDAS */
  SELECT  idcfo
         ,COUNT(idvenda) AS "TOTAL_DE_VENDAS"
    FROM public.tabvendas
   WHERE idempresa = 1
GROUP BY idcfo
ORDER BY idcfo, COUNT(idvenda);

/* CONSULTA 4: RETORNAR A QUANTIDADE DE VENDAS POR CLIENTE/FORNECEDOR, ORDENADO POR TOTAL DE VENDAS DECRESCENTE */
  SELECT  idcfo
         ,COUNT(idvenda) AS "TOTAL_DE_VENDAS"
    FROM public.tabvendas
   WHERE idempresa = 1
GROUP BY idcfo
ORDER BY COUNT(idvenda) DESC;

/* CONSULTA 5: RETORNAR A QUANTIDADE DE VENDAS POR EMPRESA, ORDENADO POR TOTAL DE VENDAS DECRESCENTE */
  SELECT  idempresa
         ,COUNT(idvenda) AS "TOTAL_DE_VENDAS"
    FROM public.tabvendas
   
GROUP BY idempresa
ORDER BY COUNT(idvenda) DESC;

/* CONSULTA 6: RETORNAR A QUANTIDADE DE VENDAS POR EMPRESA E VENDEDOR, ORDENADO POR TOTAL DE VENDAS DECRESCENTE */
  SELECT  idempresa
         ,idvendedor
         ,COUNT(idvenda) AS "TOTAL_DE_VENDAS"
    FROM public.tabvendas
   
GROUP BY idempresa, idvendedor
ORDER BY COUNT(idvenda) DESC;

/* CONSULTA 7: RETORNAR A DATA DA ULTIMA VENDA POR EMPRESA E VENDEDOR ORDENADO POR EMPRESA E VENDEDOR */
  SELECT idempresa
        ,idvendedor
        ,MAX(dtvenda) AS "MAIOR_DATA_VENDA"
    FROM public.tabvendas
GROUP BY idempresa
        ,idvendedor
ORDER BY idempresa
        ,idvendedor;

/* CONSULTA 8: RETORNAR A SOMA DA QUANTIDADE DE PRODUTOS VENDIDOS AGRUPADOS POR EMPRESA E ORDENADO POR EMPRESA E ID DO PRODUTO */
  SELECT idempresa
        ,idproduto
        ,SUM(quantidade) AS "total_produtos_vendidos"
    FROM public.tabvendasitens
GROUP BY idempresa
         ,idproduto
ORDER BY idempresa
         ,idproduto;

/* CONSULTA 9: RETORNAR A SOMA DA QUANTIDADE DE PRODUTOS VENDIDOS AGRUPADOS POR EMPRESA, ONDE A ID DO PRODUTO SEJA 100, 1000, 1002 
               E ORDENADO POR EMPRESA E ID DO PRODUTO */
  SELECT idempresa
        ,idproduto
        ,SUM(quantidade) AS "total_produtos_vendidos"
    FROM public.tabvendasitens
   WHERE idproduto IN(100, 1000, 1002)
GROUP BY idempresa
         ,idproduto
ORDER BY idempresa
         ,idproduto;

/* CONSULTA 10: RETORNAR OS PRODUTOS COM O MAIOR DESCONTO APLICADO, AGRUPADOS POR EMPRESA, ONDE O DESCONTO SEJA MAIOR QUE 30% 
               E ORDENADO POR EMPRESA E ID DO PRODUTO */
  SELECT idempresa
        ,idproduto
        ,MAX(desconto) AS "MAIOR_DESCONTO_APLICADO"
    FROM public.tabvendasitens  
	WHERE desconto > 30
GROUP BY idempresa
         ,idproduto
ORDER BY idempresa
         ,idproduto;

/* CONSULTA 11: RETORNAR O MENOR DESCONTO APLICADO POR EMPRESA, AGRUPANDO POR EMPRESA, */
  SELECT idempresa        
        ,MIN(desconto) AS "MENOR_DESCONTO_APLICADO"
    FROM public.tabvendasitens  
GROUP BY idempresa
ORDER BY idempresa;

/* CONSULTA 12: RETORNAR O MAIOR DESCONTO APLICADO POR EMPRESA, AGRUPANDO POR EMPRESA, */
  SELECT idempresa        
        ,MAX(desconto) AS "MAIOR_DESCONTO_APLICADO"
    FROM public.tabvendasitens  
GROUP BY idempresa
ORDER BY idempresa;

/* CONSULTA 13: RETORNAR A MÉDIA DE DESCONTO APLICADO POR EMPRESA, AGRUPANDO POR EMPRESA, */
  SELECT idempresa        
        ,AVG(desconto) AS "MAIOR_DESCONTO_APLICADO"
    FROM public.tabvendasitens  
GROUP BY idempresa
ORDER BY idempresa;
