--Nome: Henrique Bergami Orlette
--Turma: CC1MD
--Matrícula: 202306131

-- Exclui o banco de dados "uvv" se existir:
DROP DATABASE IF EXISTS uvv;

-- Delata o usuário "henrique" se existir:
DROP USER IF EXISTS henrique;

-- Cria o usuário:
CREATE USER henrique;

-- Permite o usuário a criar banco de dados:
ALTER USER henrique CREATEDB;

-- Permite o usuário a criar novas roles:
ALTER USER henrique CREATEROLE;

-- Cria senha para o usuário henrique:
ALTER USER henrique WITH PASSWORD 'a';

-- Cria o banco de dados:
CREATE DATABASE uvv
WITH 
OWNER = henrique
TEMPLATE = template0
ENCODING = “UTF8”
LC_COLLATE = 'pt_BR.UTF-8'
LC_CTYPE =  'pt_BR.UTF-8'
ALLOW_CONNECTIONS = TRUE;

--COMENTANDO O BANCO DE DADOS
COMMENT ON DATABASE uvv IS 'Banco de Dados com os dados para as lojas uvv';

-- Conecta ao banco de dados uvv:
\c uvv;

-- Define privilégios para o usuário:
SET ROLE = henrique;

-- Criar Schema:
CREATE SCHEMA lojas
AUTHORIZATION henrique;

--Coloca Schema lojas para o presente:
SET SEARCH_PATH TO lojas, "$user", public;

--Coloca Schema lojas como padrão para o futuro:
ALTER USER henrique
SET SEARCH_PATH TO lojas, "$user", public;

--Comentário para o Schema lojas:
COMMENT ON SCHEMA lojas IS 'Schema para o Banco de Dados uvv';

-- Criar a tabela produtos:
CREATE TABLE lojas.produtos (
produto_id                 NUMERIC(38) NOT NULL, 
nome                       VARCHAR(255) NOT NULL,
preco_unitario             NUMERIC(10,2),
detalhes                   BYTEA,
imagem                     BYTEA,
imagem_mime_type           VARCHAR(512),
imagem_arquivo             VARCHAR(512),
imagem_charset             VARCHAR(512),
imagem_ultima_atualizacao  DATE
);

-- Cria Restrição de Verificação da tabela produtos:
ALTER TABLE 	lojas.produtos
ADD CONSTRAINT 	cc_produtos_preco_unitario
CHECK 			(preco_unitario > 0);

-- Cria PRIMARY KEY para tabela produtos:
ALTER TABLE 	lojas.produtos
ADD CONSTRAINT 	pk_produtos_produto_id
PRIMARY KEY 	(produto_id);

-- Comentários para a tabela produtos:
COMMENT ON TABLE lojas.produtos 						   IS 'Tabela com os dados dos produtos.';

-- Comentários para as colunas da tabela:
COMMENT ON COLUMN lojas.produtos.produto_id 			   IS 'Coluna com o ID dos produtos.';
COMMENT ON COLUMN lojas.produtos.nome 					   IS 'Coluna com o nome dos produtos.';
COMMENT ON COLUMN lojas.produtos.preco_unitario 		   IS 'Coluna com o preço unitário dos produtos.';
COMMENT ON COLUMN lojas.produtos.detalhes 				   IS 'Coluna com os detalhes dos produtos.';
COMMENT ON COLUMN lojas.produtos.imagem 				   IS 'Coluna com a imagem dos produtos.';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type 		   IS 'Coluna com o MIME_type da imagem dos produtos.';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo 		   IS 'Coluna com o arquivo da imagem dos produtos.';
COMMENT ON COLUMN lojas.produtos.imagem_charset 		   IS 'Coluna com o charset da imagem dos produtos.
';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'Coluna com a data da última atualização da imagem dos produtos.';

-- Cria a tabela lojas:
CREATE TABLE lojas.lojas (
loja_id                 NUMERIC(38)NOT NULL,
nome                    VARCHAR(255) NOT NULL,
endereco_web            VARCHAR(100),
endereco_fisico         VARCHAR(512),
latitude                NUMERIC NOT NULL,
longitude               NUMERIC,
logo                    BYTEA,
logo_mime_type          VARCHAR(512),
logo_arquivo            VARCHAR(512),
logo_charset            VARCHAR(512),
logo_ultima_atualizacao DATE
);

-- Cria Restrição de Verificação da tabela lojas:
ALTER TABLE 	lojas.lojas
ADD CONSTRAINT 	cc_lojas_latitude
CHECK 			(latitude >= -90 AND latitude <= 90);

ALTER TABLE 	lojas.lojas
ADD CONSTRAINT 	cc_lojas_longitude
CHECK 			(longitude >= -180 AND longitude <= 180);

ALTER TABLE 	lojas.lojas
ADD CONSTRAINT 	cc_lojas_enderecos
CHECK 			((endereco_fisico IS NOT NULL) OR (endereco_web  IS NOT NULL));

-- Cria PRIMARY KEY para tabela lojas:
ALTER TABLE 	lojas.lojas
ADD CONSTRAINT 	pk_lojas_loja_id
PRIMARY KEY 	(loja_id);

-- Comentários para a tabela lojas:
COMMENT ON TABLE lojas.lojas 						    IS 'Tabela com os dados das lojas.';

-- Comentários para as colunas da tabela lojas:
COMMENT ON COLUMN lojas.lojas.loja_id 					IS 'Coluna com o ID de cada loja.';
COMMENT ON COLUMN lojas.lojas.nome 						IS 'Coluna com o nome das lojas.';
COMMENT ON COLUMN lojas.lojas.endereco_web 				IS 'Coluna com o endereço web das lojas.';
COMMENT ON COLUMN lojas.lojas.endereco_fisico 			IS 'Coluna com o endereço físico das lojas.';
COMMENT ON COLUMN lojas.lojas.latitude 					IS 'Coluna com a latitude das lojas.';
COMMENT ON COLUMN lojas.lojas.longitude 				IS 'Coluna com a longitude das 	lojas.';
COMMENT ON COLUMN lojas.lojas.logo 						IS 'Coluna com a imagem da logo das lojas.';
COMMENT ON COLUMN lojas.lojas.logo_mime_type 			IS 'Coluna com os MIME-types das lojas.';
COMMENT ON COLUMN lojas.lojas.logo_arquivo 				IS 'Coluna com o arquivo da logo das lojas.';
COMMENT ON COLUMN lojas.lojas.logo_charset 				IS 'Coluna com o formato de codificação de caracteres utilizado no documento.';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao 	IS 'Coluna com a última data de atualização da logo das lojas.';

-- Cria a tabela estoques:
CREATE TABLE lojas.estoques (
estoque_id   			NUMERIC(38) NOT NULL,
loja_id     			NUMERIC(38) NOT NULL,
produto_id  			NUMERIC(38) NOT NULL,
quantidade  			NUMERIC(38) NOT NULL
);

-- Cria Restrição de Verificação da tabela estoques:
ALTER TABLE 	lojas.estoques
ADD CONSTRAINT 	cc_estoques_quantidade
CHECK 			(quantidade >= 0);

-- Cria PRIMARY KEY para tabela estoques:
ALTER TABLE 	lojas.estoques
ADD CONSTRAINT 	pk_estoques_estoque_id
PRIMARY KEY 	(estoque_id);

-- Comentários para a tabela estoques:
COMMENT ON TABLE lojas.estoques 			IS 'Tabela com os estoques dos produtos.';

-- Comentários para as colunas da tabela estoques:
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'Coluna com o ID dos estoques.';
COMMENT ON COLUMN lojas.estoques.loja_id 	IS 'Coluna com o ID da loja dos estoques.';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'Coluna com o ID do produto dos estoques.';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'Coluna com a quantidade do produto nos estoques.';

-- Cria a tabela clientes:
CREATE TABLE lojas.clientes (
cliente_id  		NUMERIC(38) NOT NULL,
email 				VARCHAR(255) NOT NULL,
nome 				VARCHAR(255) NOT NULL,
telefone1 			VARCHAR(20),
telefone2 			VARCHAR(20),
telefone3 			VARCHAR(20)
);

-- Cria Restrição de Verificação da tabela clientes:
ALTER TABLE 	lojas.clientes
ADD CONSTRAINT 	cc_clientes_email
CHECK 			(email ~* ('^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'));

ALTER TABLE 	lojas.clientes
ADD CONSTRAINT 	cc_clientes_telefone
CHECK (
(telefone1 IS NULL OR telefone1 ~* '^\(\d{2}\)\s\d{5}-\d{4}$') AND
(telefone2 IS NULL OR telefone2 ~* '^\(\d{2}\)\s\d{5}-\d{4}$') AND
(telefone3 IS NULL OR telefone3 ~* '^\(\d{2}\)\s\d{5}-\d{4}$')
);

-- Cria PRIMARY KEY para tabela lojas:
ALTER TABLE 	lojas.clientes
ADD CONSTRAINT 	pk_clientes_cliente_id
PRIMARY KEY 	(cliente_id);

-- Comentários para a tabela:
COMMENT ON TABLE lojas.clientes 			IS 'Tabela com registro de dados do cliente.';

-- Comentários para as colunas da tabela:
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'Coluna com o registro do ID dos clientes.';
COMMENT ON COLUMN lojas.clientes.email 		IS 'Coluna para registro dos emails dos clientes.';
COMMENT ON COLUMN lojas.clientes.nome 		IS 'Coluna com o nome dos clientes.';
COMMENT ON COLUMN lojas.clientes.telefone1 	IS 'Coluna com registro do telefone dos clientes.';
COMMENT ON COLUMN lojas.clientes.telefone2 	IS 'Coluna com registro do telefone secundário dos clientes.';
COMMENT ON COLUMN lojas.clientes.telefone3 	IS 'Coluna com registro do telefone terciário dos clientes.';

-- Cria a tabela envios:
CREATE TABLE lojas.envios (
envio_id  				NUMERIC(38) NOT NULL,
loja_id 				NUMERIC(38) NOT NULL,
cliente_id  			NUMERIC(38) NOT NULL,
endereco_entrega 		VARCHAR(512) NOT NULL,
status 					VARCHAR(15) NOT NULL
);
-- Cria Restrição de Verificação da tabela envios:
ALTER TABLE 	lojas.envios
ADD CONSTRAINT 	cc_envios_status
CHECK 			(status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));

-- Cria PRIMARY KEY para tabela envios:
ALTER TABLE 	lojas.envios
ADD CONSTRAINT 	pk_envios_envio_id
PRIMARY KEY 	(envio_id);

-- Comentários para a tabela envios:
COMMENT ON TABLE lojas.envios 					IS 'Tabela com os dados do envio dos produtos.';

-- Comentários para as colunas da tabela envios:
COMMENT ON COLUMN lojas.envios.envio_id 		IS 'Coluna com o ID de envio.';
COMMENT ON COLUMN lojas.envios.loja_id 			IS 'Coluna com o ID da loja dos envios.';
COMMENT ON COLUMN lojas.envios.cliente_id 		IS 'Coluna com o ID do cliente dos envios.';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'Coluna com o endereço de entrega dos envios.';
COMMENT ON COLUMN lojas.envios.status 			IS 'Coluna com o status dos envios.';

-- Cria a tabela pedidos:
CREATE TABLE lojas.pedidos (
pedido_id 				NUMERIC(38) NOT NULL,
data_hora 				TIMESTAMP 	NOT NULL,
cliente_id 	            NUMERIC(38) NOT NULL,
status                  VARCHAR(15) NOT NULL,
loja_id                 NUMERIC(38) NOT NULL
);

-- Cria Restrição de Verificação da tabela pedidos:
ALTER TABLE 	lojas.pedidos
ADD CONSTRAINT 	cc_pedidos_data_hora
CHECK 			(data_hora = to_timestamp(data_hora::text,'DD-MM-YYYY HH24:MI:SS'));

ALTER TABLE 	lojas.pedidos
ADD CONSTRAINT 	cc_pedidos_status
CHECK 			(status IN('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));

-- Cria PRIMARY KEY para tabela pedidos:
ALTER TABLE 	lojas.pedidos
ADD CONSTRAINT 	pk_pedidos_pedido_id
PRIMARY KEY 	(pedido_id);

-- Comentários para a tabela pedidos:
COMMENT ON TABLE lojas.pedidos 				IS 'Tabela com os dados dos pedidos realizados pelos clientes.';

-- Comentários para as colunas da tabela pedidos:
COMMENT ON COLUMN lojas.pedidos.pedido_id 	IS 'Coluna com o registro do ID dos pedidos.';
COMMENT ON COLUMN lojas.pedidos.data_hora 	IS 'Coluna com o registro da data e hora da realização do pedido.';
COMMENT ON COLUMN lojas.pedidos.cliente_id 	IS 'Coluna com o registro do ID dos clientes.';
COMMENT ON COLUMN lojas.pedidos.status 		IS 'Coluna com o registro do status do pedido.
';
COMMENT ON COLUMN lojas.pedidos.loja_id 	IS 'Coluna com o registro de qual loja foi feito o pedido.';

-- Cria a tabela pedidos_itens:
CREATE TABLE lojas.pedidos_itens (
pedido_id                  NUMERIC(38) NOT NULL,
produto_id                 NUMERIC(38) NOT NULL,
numero_da_linha            NUMERIC(38) NOT NULL,
preco_unitario             NUMERIC(10,2) NOT NULL,
quantidade                 NUMERIC(38) NOT NULL,
envio_id                   NUMERIC(38) NOT NULL
);

-- Cria Restrição de Verificação da tabela pedidos_itens:
ALTER TABLE 	lojas.pedidos_itens
ADD CONSTRAINT 	cc_pedidos_itens_quantidade
CHECK 			(quantidade > 0);

ALTER TABLE 	lojas.pedidos_itens
ADD CONSTRAINT 	cc_pedidos_itens_preco_unitario
CHECK 			(preco_unitario > 0);

ALTER TABLE 	lojas.pedidos_itens
ADD CONSTRAINT 	cc_pedidos_itens_numero_da_linha
CHECK 			(numero_da_linha > 0);

-- Cria PRIMARY KEY composta para tabela pedidos_itens:
ALTER TABLE 	lojas.pedidos_itens
ADD CONSTRAINT 	pk_pedidos_itens_pedido_id_produto_id
PRIMARY KEY 	(pedido_id, produto_id);

-- Comentário para a tabela pedidos_itens:
COMMENT ON TABLE lojas.pedidos_itens 					IS 'Tabela com os dados dos itens pedidos.';

-- Comentários para as colunas da tabela pedidos_itens:
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id 		IS 'Coluna com o ID dos pedidos.';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id 		IS 'Coluna com o ID dos produtos pedidos.';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha 	IS 'Coluna com o número da linha dos itens pedidos.';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario 	IS 'Coluna com o preço unitário dos itens pedidos.';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade 		IS 'Coluna com a quantidade dos itens pedidos.';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id 			IS 'Coluna com o ID de envio dos itens pedidos.';

-- Criar FOREIGN KEY para tabelas:
ALTER TABLE 		lojas.pedidos_itens 
ADD CONSTRAINT 		produtos_pedidos_itens_fk
FOREIGN KEY 		(produto_id)
REFERENCES 			lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE 		lojas.estoques 
ADD CONSTRAINT 		produtos_estoques_fk
FOREIGN KEY 		(produto_id)
REFERENCES 			lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE 		lojas.pedidos 
ADD CONSTRAINT 		lojas_pedidos_fk
FOREIGN KEY 		(loja_id)
REFERENCES 			lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE 		lojas.estoques 
ADD CONSTRAINT 		lojas_estoques_fk
FOREIGN KEY 		(loja_id)
REFERENCES 			lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE 		lojas.envios 
ADD CONSTRAINT 		lojas_envios_fk
FOREIGN KEY 		(loja_id)
REFERENCES 			lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE 		lojas.pedidos 
ADD CONSTRAINT 		clientes_pedidos_fk
FOREIGN KEY 		(cliente_id)
REFERENCES 			lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE 		lojas.envios 
ADD CONSTRAINT 		clientes_envios_fk
FOREIGN KEY 		(cliente_id)
REFERENCES 			lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE 		lojas.pedidos_itens 
ADD CONSTRAINT 		envios_pedidos_itens_fk
FOREIGN KEY 		(envio_id)
REFERENCES 			lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE 		lojas.pedidos_itens 
ADD CONSTRAINT 		pedidos_pedidos_itens_fk
FOREIGN KEY 		(pedido_id)
REFERENCES 			lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

