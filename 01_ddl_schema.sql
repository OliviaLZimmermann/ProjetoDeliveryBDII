-- =============================================================
--  PROJETO FINAL — ECOSSISTEMA DE DELIVERY
-- 	Arquivo: 01_ddl_schema.sql
--  Objetivo: Criação das tabelas, índices e chaves estrangeiras
--  Banco   : MySQL 8.0+
-- =============================================================

CREATE DATABASE IF NOT EXISTS delivery;

USE delivery;

-- -------------------------------------------------------------
-- 1. CLIENTES (RF01)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente    INT            NOT NULL AUTO_INCREMENT,
    nome          VARCHAR(120)   NOT NULL,
    email         VARCHAR(150)   NOT NULL,
    cpf           VARCHAR(14)    NOT NULL,           -- formato 000.000.000-00
    telefone      VARCHAR(20)        NULL,
    senha_hash    VARCHAR(255)   NOT NULL,           -- RNF02: senha criptografada
    cep           VARCHAR(10)        NULL,
    endereco      VARCHAR(200)       NULL,
    cidade        VARCHAR(80)        NULL,
    estado        CHAR(2)            NULL,
    regiao        VARCHAR(60)        NULL,           -- RNF04: índice por região
    ativo         TINYINT(1)     NOT NULL DEFAULT 1,
    criado_em     DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP
                                         ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_clientes     PRIMARY KEY (id_cliente),
    CONSTRAINT uq_clientes_email UNIQUE (email),
    CONSTRAINT uq_clientes_cpf  UNIQUE (cpf)
);

-- Índice para busca regional (RNF04)
CREATE INDEX idx_clientes_regiao ON clientes (regiao);

-- -------------------------------------------------------------
-- 2. ENTREGADORES (RF02)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS entregadores (
    id_entregador INT            NOT NULL AUTO_INCREMENT,
    nome          VARCHAR(120)   NOT NULL,
    cpf           VARCHAR(14)    NOT NULL,           -- formato 000.000.000-00
    cnh           VARCHAR(20)        NULL,
    tipo_veiculo  ENUM('moto','bicicleta','carro','van') NOT NULL DEFAULT 'moto',
    placa         VARCHAR(10)        NULL,
    cnpj          VARCHAR(18)        NULL,           -- formato 00.000.000/0000-00
    status        ENUM('disponivel','em_entrega','inativo') NOT NULL DEFAULT 'disponivel',
    senha_hash    VARCHAR(255)   NOT NULL,           -- RNF02
    criado_em     DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP
                                         ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_entregadores     PRIMARY KEY (id_entregador),
    CONSTRAINT uq_entregadores_cpf UNIQUE (cpf)
);

CREATE INDEX idx_entregadores_status ON entregadores (status);

-- -------------------------------------------------------------
-- 3. RESTAURANTES (RF03)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS restaurantes (
    id_restaurante INT           NOT NULL AUTO_INCREMENT,
    nome           VARCHAR(150)  NOT NULL,
    cnpj           VARCHAR(18)   NOT NULL,           -- formato 00.000.000/0000-00
    telefone       VARCHAR(20)       NULL,
    email          VARCHAR(150)      NULL,
    cep            VARCHAR(10)       NULL,
    endereco       VARCHAR(200)      NULL,
    cidade         VARCHAR(80)       NULL,
    estado         CHAR(2)           NULL,
    regiao         VARCHAR(60)       NULL,           -- RNF04: índice por região
    ativo          TINYINT(1)    NOT NULL DEFAULT 1,
    criado_em      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
                                          ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_restaurantes     PRIMARY KEY (id_restaurante),
    CONSTRAINT uq_restaurantes_cnpj UNIQUE (cnpj)
);

CREATE INDEX idx_restaurantes_regiao ON restaurantes (regiao);
CREATE INDEX idx_restaurantes_cidade ON restaurantes (cidade);

-- -------------------------------------------------------------
-- 4. PRODUTOS / CARDÁPIO (RF03 + RF04)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS produtos (
    id_produto     INT            NOT NULL AUTO_INCREMENT,
    id_restaurante INT            NOT NULL,
    nome           VARCHAR(150)   NOT NULL,
    descricao      TEXT               NULL,
    categoria      VARCHAR(80)    NOT NULL,          -- ex.: lanche, bebida, sobremesa
    preco          DECIMAL(10,2)  NOT NULL CHECK (preco >= 0),
    estoque        INT            NOT NULL DEFAULT 0 CHECK (estoque >= 0),  -- RF04
    disponivel     TINYINT(1)     NOT NULL DEFAULT 1,
    criado_em      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em  DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP
                                           ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_produtos              PRIMARY KEY (id_produto),
    CONSTRAINT fk_produtos_restaurante  FOREIGN KEY (id_restaurante)
        REFERENCES restaurantes (id_restaurante)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX idx_produtos_restaurante ON produtos (id_restaurante);
CREATE INDEX idx_produtos_categoria   ON produtos (categoria);

-- -------------------------------------------------------------
-- 5. TAXAS (RF06)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS taxas (
    id_taxa    INT            NOT NULL AUTO_INCREMENT,
    tipo       ENUM('entrega','servico','cancelamento') NOT NULL,
    descricao  VARCHAR(200)       NULL,
    valor      DECIMAL(10,2)  NOT NULL CHECK (valor >= 0),
    percentual TINYINT(1)     NOT NULL DEFAULT 0,  -- 0=valor fixo, 1=percentual
    ativo      TINYINT(1)     NOT NULL DEFAULT 1,
    criado_em  DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_taxas PRIMARY KEY (id_taxa)
);

-- -------------------------------------------------------------
-- 6. PEDIDOS (RF05)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido      INT            NOT NULL AUTO_INCREMENT,
    id_cliente     INT            NOT NULL,
    id_restaurante INT            NOT NULL,
    id_entregador  INT                NULL,          -- atribuído após confirmação
    valor_subtotal DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    taxa_entrega   DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    taxa_servico   DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    taxa_cancelamento DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    valor_total    DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    status         ENUM(
                     'pendente',
                     'confirmado',
                     'em_preparo',
                     'saiu_entrega',
                     'entregue',
                     'cancelado'
                   ) NOT NULL DEFAULT 'pendente',   -- RF08
    observacao     TEXT               NULL,
    criado_em      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em  DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP
                                           ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_pedidos              PRIMARY KEY (id_pedido),
    CONSTRAINT fk_pedidos_cliente      FOREIGN KEY (id_cliente)
        REFERENCES clientes (id_cliente)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pedidos_restaurante  FOREIGN KEY (id_restaurante)
        REFERENCES restaurantes (id_restaurante)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pedidos_entregador   FOREIGN KEY (id_entregador)
        REFERENCES entregadores (id_entregador)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- RNF04: índice por data e região (via join com restaurante)
CREATE INDEX idx_pedidos_cliente      ON pedidos (id_cliente);
CREATE INDEX idx_pedidos_restaurante  ON pedidos (id_restaurante);
CREATE INDEX idx_pedidos_entregador   ON pedidos (id_entregador);
CREATE INDEX idx_pedidos_status       ON pedidos (status);
CREATE INDEX idx_pedidos_criado_em    ON pedidos (criado_em);

-- -------------------------------------------------------------
-- 7. ITENS DO PEDIDO (RF05)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS itens_pedido (
    id_item        INT            NOT NULL AUTO_INCREMENT,
    id_pedido      INT            NOT NULL,
    id_produto     INT            NOT NULL,
    quantidade     INT            NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2)  NOT NULL CHECK (preco_unitario >= 0),
    subtotal       DECIMAL(10,2)  NOT NULL DEFAULT 0.00,

    CONSTRAINT pk_itens_pedido          PRIMARY KEY (id_item),
    CONSTRAINT fk_itens_pedido_pedido   FOREIGN KEY (id_pedido)
        REFERENCES pedidos (id_pedido)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_itens_pedido_produto  FOREIGN KEY (id_produto)
        REFERENCES produtos (id_produto)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX idx_itens_pedido_pedido  ON itens_pedido (id_pedido);
CREATE INDEX idx_itens_pedido_produto ON itens_pedido (id_produto);

-- -------------------------------------------------------------
-- 8. FAQ E RECLAMAÇÕES — SAC (RF07)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS faq_reclamacoes (
    id_faq      INT            NOT NULL AUTO_INCREMENT,
    id_cliente  INT                NULL,             -- NULL = pergunta pública (FAQ)
    id_pedido   INT                NULL,             -- NULL = dúvida geral
    tipo        ENUM('faq','reclamacao','elogio','sugestao') NOT NULL DEFAULT 'faq',
    assunto     VARCHAR(200)   NOT NULL,
    descricao   TEXT           NOT NULL,
    resposta    TEXT               NULL,
    status      ENUM('aberto','em_analise','resolvido','fechado') NOT NULL DEFAULT 'aberto',
    criado_em   DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolvido_em DATETIME          NULL,

    CONSTRAINT pk_faq_reclamacoes         PRIMARY KEY (id_faq),
    CONSTRAINT fk_faq_cliente             FOREIGN KEY (id_cliente)
        REFERENCES clientes (id_cliente)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_faq_pedido              FOREIGN KEY (id_pedido)
        REFERENCES pedidos (id_pedido)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE INDEX idx_faq_cliente ON faq_reclamacoes (id_cliente);
CREATE INDEX idx_faq_tipo    ON faq_reclamacoes (tipo);
CREATE INDEX idx_faq_status  ON faq_reclamacoes (status);

-- -------------------------------------------------------------
-- 9. HISTÓRICO DE PEDIDOS — tabela de auditoria (RNF05 / Trigger)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS historico_pedidos (
    id_historico   INT            NOT NULL AUTO_INCREMENT,
    id_pedido      INT            NOT NULL,          -- referência (sem FK para preservar histórico)
    id_cliente     INT                NULL,
    id_restaurante INT                NULL,
    id_entregador  INT                NULL,
    valor_subtotal DECIMAL(10,2)      NULL,
    taxa_entrega   DECIMAL(10,2)      NULL,
    taxa_servico   DECIMAL(10,2)      NULL,
    valor_total    DECIMAL(10,2)      NULL,
    status         VARCHAR(30)        NULL,
    observacao     TEXT               NULL,
    operacao       ENUM('INSERT','UPDATE','DELETE') NOT NULL DEFAULT 'INSERT',
    registrado_em  DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_historico_pedidos PRIMARY KEY (id_historico)
);

-- Sem FK intencional: preserva o espelho mesmo se o pedido for removido
CREATE INDEX idx_historico_pedido     ON historico_pedidos (id_pedido);
CREATE INDEX idx_historico_cliente    ON historico_pedidos (id_cliente);
CREATE INDEX idx_historico_registrado ON historico_pedidos (registrado_em);
