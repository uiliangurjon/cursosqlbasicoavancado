/*******************************************
*    Curso de SQL do básico ao avançado    *
*    Aula 5                                *
*******************************************/

/* Definições 
	-> CONSTRAINS (restrições): Podemos criar restrições evitando assim que dados inválidos sejam inseridos no banco. 
	                            Nada mais é do que um método para validar a integridade de todos os dados que entram no banco de dados
								
	-> DOMAIN (domínio): É, essencialmente, um tipo de dado com restrições opcionais, onde é possível, por exemplo, criar uma restrição
	                     para um conjunto de valores permitidos.
                         Podemos utilizar domínios para reunir restrições comuns em campos em um único local para manutenção.
	
	-> Aviso: Os dados inseridos para teste em nosso banco de dados forma gerados de forma aleatória e não são dados reais de pessoas!
*/ 


/* Alterando a tabela de estados para construir uma restrição unica para o campo nome do estado */
ALTER TABLE public.tabestados ADD CONSTRAINT tabestados_unq UNIQUE (estado);

/* Alterando a tabela de cidades para o modelo correto */
ALTER TABLE public.tabcidades RENAME nome TO nomecidade;

/* Incluindo uma restrição unica */
ALTER TABLE public.tabcidades ADD CONSTRAINT tabcidades_unq UNIQUE (idestado, codigoibge, nomecidade);

/* Inicio das alterações da tabela de empresas */
ALTER TABLE public.tabempresa ALTER COLUMN razaosocial TYPE character varying (255);
ALTER TABLE public.tabempresa ALTER COLUMN nomefantasia TYPE character varying (255);
ALTER TABLE public.tabempresa RENAME ie TO inscricaoestadual;
ALTER TABLE public.tabempresa ADD telefone1 character varying (15) NOT NULL;
ALTER TABLE public.tabempresa ADD telefone2 character varying (15);
ALTER TABLE public.tabempresa ADD telefone3 character varying (15);
ALTER TABLE public.tabempresa ADD email character varying (60);
ALTER TABLE public.tabempresa ADD cep character varying (9) NOT NULL;
ALTER TABLE public.tabempresa ALTER COLUMN logradouro TYPE character varying (100);
ALTER TABLE public.tabempresa ALTER COLUMN bairro TYPE character varying (100);
ALTER TABLE public.tabempresa ADD numero character varying (8) NOT NULL;
ALTER TABLE public.tabempresa ADD complemento character varying (60);

-- Campos do tipo boolean aceitam as strings como valores verdadeiros (true) e como falso (false)
ALTER TABLE public.tabempresa ADD ativo boolean NOT NULL DEFAULT true; 

ALTER TABLE public.tabempresa DROP COLUMN cidade;
ALTER TABLE public.tabempresa DROP COLUMN estado;
ALTER TABLE public.tabempresa ADD idcidade integer;
ALTER TABLE public.tabempresa ADD idestado integer;

-- Criando a chave estrangeira com referencia a tabela tabestados
ALTER TABLE public.tabempresa 
      ADD CONSTRAINT tabempresa_estados_fk FOREIGN KEY (idestado)
	  REFERENCES public.tabestados(idestado);
	  
-- Criando a chave estrangeira com referencia a tabela tabcidades
ALTER TABLE public.tabempresa 
      ADD CONSTRAINT tabempresa_cidades_fk FOREIGN KEY (idcidade)
	  REFERENCES public.tabcidades(idcidade);
	  
-- Inserindo dados na tabela de empresa
INSERT INTO public.tabempresa(idempresa,
	razaosocial, nomefantasia, cnpj, inscricaoestadual, logradouro, bairro, telefone1, telefone2, telefone3, email, cep, numero, complemento, ativo, idcidade, idestado)
	VALUES (1,'Empresa de public 1', 'Empresa de public 1', '99.999.999/0001-99', '999.999.999.999', 'Rua da empresa de public', 'Bairro da empresa de public',
			'(99) 9999-9999', '(88) 8888-8888', '(77) 7777-7777', 'empresapublic1@public.com', '99999-999', 22, 'public complemento', true, 3755, 20);

INSERT INTO public.tabempresa(idempresa,
	razaosocial, nomefantasia, cnpj, inscricaoestadual, logradouro, bairro, telefone1, telefone2, telefone3, email, cep, numero, complemento, ativo, idcidade, idestado)
	VALUES (2,'Empresa de public 2', 'Empresa de public 2', '11.111.111/0001-11', '111.111.111.111', 'Rua da empresa de public 2', 'Bairro da empresa de public 2',
			'(11) 1111-1111', '(22) 2222-2222', '(33) 3333-3333', 'empresapublic2@public.com', '11111-11', 33, 'public complemento 2', true, 3067, 17);

-- Verificando se as empresa foram incluídas
SELECT * FROM public.tabempresa

SELECT * FROM public.tabestados
SELECT * FROM public.tabestadosregioes
SELECT * FROM public.tabcidades


DELETE FROM public.tabestados
DELETE FROM public.tabestadosregioes

/* fim das alterações da tabela tabempres */


/* Inicio criação de domínios simples e com validações */
--Domínio Simples
CREATE DOMAIN public.dmoeda1 AS numeric(15,2)
  DEFAULT 0;

--Domínio com validações
CREATE DOMAIN public.dtipocfo AS character varying(1)
  NOT NULL
  CHECK (VALUE IN ('C','F','A'));
  
--Domínio com validações
CREATE DOMAIN public.ddata1 AS date
  DEFAULT '01/01/1900'
  NOT NULL
  CHECK (VALUE > '01/01/1900');
/* Fim da criação de domínios */
  
/* Inicio da criação da tabela de clientes */
CREATE TABLE IF NOT EXISTS public.tabcfo
(
	idempresa integer NOT NULL, 
	idcfo serial NOT NULL,
	
	-- Campos do tipo boolean aceitam as strings como valores verdadeiros (true) e como falso (false)
	ativo boolean NOT NULL DEFAULT true, 
	
	tipocfo public.dtipocfo,
	razaosocial character varying(100) NOT NULL,
	nomefantasia character varying(100) NOT NULL,
	cpfcnpj character varying(20) NOT NULL,
    rginscricaoestaudal character varying(20) NOT NULL,
	email character varying(60) NOT NULL,
	dtnascimentofundacao date,
	limitecredito public.dmoeda1,
	valoracumulado public.dmoeda1,
	dataultimacompra public.ddata1,
	
	CONSTRAINT tabcfo_pk PRIMARY KEY (idcfo),
	CONSTRAINT tabcfo_unq UNIQUE (idempresa, cpfcnpj)
)

-- Criando a chave estrangeira com referencia a tabela tabempresa
ALTER TABLE public.tabcfo
      ADD CONSTRAINT tabcfo_empresa_fk FOREIGN KEY (idempresa)
	  REFERENCES public.tabempresa(idempresa);

-- Adicionando comentários para a tabela de cliente
COMMENT ON TABLE public.tabcfo IS 'Tabela para armazenar os dados de cliente e fornecedores globais por empresa';
COMMENT ON COLUMN public.tabcfo.tipocfo IS 'Este campo armazena o tipo de pessoa utilizando C para cliente, F para Fornecedor e A para Ambos';
COMMENT ON COLUMN public.tabcfo.cpfcnpj IS 'Este campo pode receber dados de Pessoa Física ou Jurídica';
COMMENT ON COLUMN public.tabcfo.rginscricaoestaudal IS 'Este campo pode receber dados de Pessoa Física ou Jurídica';
/* Fim da criação da tabela de clientes */

/* Inicio da criação da tabela de telefones de clientes */
CREATE TABLE IF NOT EXISTS public.tabcfotelefones
(
	idempresa integer NOT NULL, 
	idcfo integer NOT NULL,
	tipo character varying(20) NOT NULL,
	numero character varying(15) NOT NULL,
	campolivre character varying(100),
	
	CONSTRAINT tabcfotelefones_unq UNIQUE (idempresa, idcfo, numero)
)

-- Criando a chave estrangeira com referencia a tabela tabempresa
ALTER TABLE public.tabcfotelefones
      ADD CONSTRAINT tabcfotelefones_empresa_fk FOREIGN KEY (idempresa)
	  REFERENCES public.tabempresa(idempresa);

-- Criando a chave estrangeira com referencia a tabela tabempresa
ALTER TABLE public.tabcfotelefones
      ADD CONSTRAINT tabcfotelefones_tabcfo_fk FOREIGN KEY (idcfo)
	  REFERENCES public.tabcfo(idcfo);

/* fim da criação da tabela de telefones de clientes */

/* Inicio da criação da tabela de endereços */

CREATE TABLE IF NOT EXISTS public.tabcfoenderecos
(
	idcfoendereco serial NOT NULL,
	idempresa integer NOT NULL,
	idcfo integer NOT NULL,	
	tipo character varying(20) NOT NULL,
	logradouro character varying(100) NOT NULL,
	numero character varying (8) NOT NULL,
	bairro character varying (100) NOT NULL,
	cep character varying (9) NOT NULL,
	idestado integer NOT NULL,
	idcidade integer NOT NULL,
	
	CONSTRAINT tabcfoenderecos_pk PRIMARY KEY (idcfoendereco)
)

-- Criando a chave estrangeira com referencia a tabela tabempresa
ALTER TABLE public.tabcfoenderecos
      ADD CONSTRAINT tabcfoenderecos_empresa_fk FOREIGN KEY (idempresa)
	  REFERENCES public.tabempresa(idempresa);

-- Criando a chave estrangeira com referencia a tabela tabcfo
ALTER TABLE public.tabcfoenderecos
      ADD CONSTRAINT tabcfoenderecos_tabcfo_fk FOREIGN KEY (idcfo)
	  REFERENCES public.tabcfo(idcfo);

-- Criando a chave estrangeira com referencia a tabela tabestados
ALTER TABLE public.tabcfoenderecos 
      ADD CONSTRAINT tabcfoenderecos_estados_fk FOREIGN KEY (idestado)
	  REFERENCES public.tabestados(idestado);
	  
-- Criando a chave estrangeira com referencia a tabela tabcidades
ALTER TABLE public.tabcfoenderecos 
      ADD CONSTRAINT tabcfoenderecos_cidades_fk FOREIGN KEY (idcidade)
	  REFERENCES public.tabcidades(idcidade);

/* fim da criação da tabela cfoenderecos */

/* Inicio da criação da tabela de vendedores */
CREATE TABLE IF NOT EXISTS public.tabvendedores
(
	idvendedor serial NOT NULL,
	idempresa integer NOT NULL,	
	nome character varying(100) NOT NULL,
	comissao numeric(15,4) NOT NULL DEFAULT 0,
	
	CONSTRAINT vendedores_pk PRIMARY KEY (idvendedor)
)

-- Criando a chave estrangeira com referencia a tabela tabempresa
ALTER TABLE public.tabvendedores
      ADD CONSTRAINT tabvendedores_empresa_fk FOREIGN KEY (idempresa)
	  REFERENCES public.tabempresa(idempresa);

-- Inserindo dados na tabela
INSERT INTO public.tabvendedores(idempresa, nome, comissao) VALUES (1, 'Vendedor 1', 1);
INSERT INTO public.tabvendedores(idempresa, nome, comissao) VALUES (1, 'Vendedor 2', 0.5);
INSERT INTO public.tabvendedores(idempresa, nome, comissao) VALUES (1, 'Vendedor 3', 1.2);
INSERT INTO public.tabvendedores(idempresa, nome, comissao) VALUES (2, 'Vendedor 4', 2);
INSERT INTO public.tabvendedores(idempresa, nome, comissao) VALUES (2, 'Vendedor 5', 1.5);
INSERT INTO public.tabvendedores(idempresa, nome, comissao) VALUES (2, 'Vendedor 6', 0.7);

SELECT * FROM public.tabvendedores
/* fim da criação da tabela tabvendedores */

/* Inicio da criação da tabela de categorias */
CREATE TABLE IF NOT EXISTS public.tabcategoria
(
	idcategoria serial NOT NULL,
	descricao character varying(25) NOT NULL,
		
	CONSTRAINT tabcategoria_pk PRIMARY KEY (idcategoria)
)

-- Inserindo dados na tabela
INSERT INTO public.tabcategoria(descricao) VALUES ('Categoria 1');
INSERT INTO public.tabcategoria(descricao) VALUES ('Categoria 2');
INSERT INTO public.tabcategoria(descricao) VALUES ('Categoria 3');
INSERT INTO public.tabcategoria(descricao) VALUES ('Categoria 4');
INSERT INTO public.tabcategoria(descricao) VALUES ('Categoria 5');
INSERT INTO public.tabcategoria(descricao) VALUES ('Categoria 6');
INSERT INTO public.tabcategoria(descricao) VALUES ('Categoria 7');
INSERT INTO public.tabcategoria(descricao) VALUES ('Categoria 8');
INSERT INTO public.tabcategoria(descricao) VALUES ('Categoria 9');
INSERT INTO public.tabcategoria(descricao) VALUES ('Categoria 10');

/* fim da criação da tabela tabcategoria */

/* Inicio da criação da tabela de produtos */
CREATE TABLE IF NOT EXISTS public.tabprodutos
(
	idproduto serial NOT NULL,
	idempresa integer NOT NULL,
	nome character varying(100) NOT NULL,
	estoque numeric(15,4) NOT NULL DEFAULT 0,
	valor numeric(15,4) NOT NULL DEFAULT 0,
	
	CONSTRAINT tabprodutos_pk PRIMARY KEY (idproduto)
)

-- Criando a chave estrangeira com referencia a tabela tabempresa
ALTER TABLE public.tabprodutos
      ADD CONSTRAINT tabprodutos_empresa_fk FOREIGN KEY (idempresa)
	  REFERENCES public.tabempresa(idempresa);

-- Criando a chave estrangeira com referencia a tabela categoria
ALTER TABLE public.tabprodutos
	ADD idcategoria integer NOT NULL;
	
ALTER TABLE public.tabprodutos
      ADD CONSTRAINT tabprodutos_categoria_fk FOREIGN KEY (idcategoria)
	  REFERENCES public.tabcategoria(idcategoria);

/* fim da criação da tabela tabvendedores */

/* Inicio da criação da tabela de vendas */
CREATE TABLE IF NOT EXISTS public.tabvendas
(
	idvenda serial NOT NULL,
	idempresa integer NOT NULL,
	idcfo integer NOT NULL,
	idvendedor integer NOT NULL,
	dtvenda timestamp NOT NULL,
		
	CONSTRAINT tabvendas_pk PRIMARY KEY (idvenda)
)

-- Criando a chave estrangeira com referencia a tabela tabempresa
ALTER TABLE public.tabvendas
      ADD CONSTRAINT tabtabvendas_empresa_fk FOREIGN KEY (idempresa)
	  REFERENCES public.tabempresa(idempresa);

-- Criando a chave estrangeira com referencia a tabela tabcfo
ALTER TABLE public.tabvendas
      ADD CONSTRAINT tabtabvendas_tabcfo_fk FOREIGN KEY (idcfo)
	  REFERENCES public.tabcfo(idcfo);

-- Criando a chave estrangeira com referencia a tabela tabcfo
ALTER TABLE public.tabvendas
      ADD CONSTRAINT tabtabvendas_tabvendedor_fk FOREIGN KEY (idvendedor)
	  REFERENCES public.tabvendedores(idvendedor);

/* fim da criação da tabela tabvendas */

/* Inicio da criação da tabela de vendas */
CREATE TABLE IF NOT EXISTS public.tabvendasitens
(
	idvendaitens serial NOT NULL,
	idvenda integer NOT NULL,
	idempresa integer NOT NULL,
	idproduto integer NOT NULL,
	valorunitario numeric(15,4) NOT NULL,
	quantidade numeric(15,4) NOT NULL,
	desconto numeric(15,4) NOT NULL DEFAULT 0,
	
		
	CONSTRAINT tabvendasitens_pk PRIMARY KEY (idvendaitens)
)

-- Criando a chave estrangeira com referencia a tabela tabempresa
ALTER TABLE public.tabvendasitens
      ADD CONSTRAINT tabtabvendasitens_empresa_fk FOREIGN KEY (idempresa)
	  REFERENCES public.tabempresa(idempresa);

-- Criando a chave estrangeira com referencia a tabela tabvendas
ALTER TABLE public.tabvendasitens
      ADD CONSTRAINT tabvendasitens_tabvendas_fk FOREIGN KEY (idvenda)
	  REFERENCES public.tabvendas(idvenda);

-- Criando a chave estrangeira com referencia a tabela tabprodutos
ALTER TABLE public.tabvendasitens
      ADD CONSTRAINT tabvendasitens_tabprodutos_fk FOREIGN KEY (idproduto)
	  REFERENCES public.tabprodutos(idproduto);

/* fim da criação da tabela tabvendasitens */