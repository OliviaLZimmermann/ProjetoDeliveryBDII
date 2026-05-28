-- =============================================================
--  PROJETO FINAL — ECOSSISTEMA DE DELIVERY
--  Arquivo : 04_procedures.sql
--  Objetivo: Stored Procedures para cadastro com validações,
--            formatação automática e cálculo de totais
--  Banco   : MySQL 8.0+
-- =============================================================

USE delivery;

-- =============================================================
-- 1. sp_cadastrarCliente
-- =============================================================
DROP PROCEDURE IF EXISTS sp_cadastrarCliente;

DELIMITER $$

CREATE PROCEDURE sp_cadastrarCliente(
    IN  p_nome     VARCHAR(120),
    IN  p_email    VARCHAR(150),
    IN  p_cpf      VARCHAR(20),
    IN  p_telefone VARCHAR(20),
    IN  p_senha    VARCHAR(255),
    IN  p_cep      VARCHAR(10),
    IN  p_endereco VARCHAR(200),
    IN  p_cidade   VARCHAR(80),
    IN  p_estado   CHAR(2),
    IN  p_regiao   VARCHAR(60),
    OUT p_mensagem VARCHAR(200)
)
proc_label: BEGIN                          -- ← label explícito obrigatório para o LEAVE
    DECLARE v_cpf_fmt    VARCHAR(14);
    DECLARE v_senha_hash VARCHAR(255);
    DECLARE v_existe     INT DEFAULT 0;

    -- 1. Formata o CPF
    SET v_cpf_fmt = fn_formatarCPF(p_cpf);

    IF v_cpf_fmt IS NULL THEN
        SET p_mensagem = 'ERRO: CPF inválido. Informe 11 dígitos numéricos.';
        LEAVE proc_label;
    END IF;

    -- 2. Valida e criptografa a senha
    SET v_senha_hash = fn_encriptarSenha(p_senha);

    IF v_senha_hash IS NULL THEN
        SET p_mensagem = 'ERRO: Senha fraca. Use ao menos 8 caracteres com maiúscula, minúscula, número e símbolo.';
        LEAVE proc_label;
    END IF;

    -- 3. Verifica duplicidade de e-mail
    SELECT COUNT(*) INTO v_existe FROM clientes WHERE email = p_email;
    IF v_existe > 0 THEN
        SET p_mensagem = 'ERRO: E-mail já cadastrado no sistema.';
        LEAVE proc_label;
    END IF;

    -- 4. Verifica duplicidade de CPF
    SELECT COUNT(*) INTO v_existe FROM clientes WHERE cpf = v_cpf_fmt;
    IF v_existe > 0 THEN
        SET p_mensagem = 'ERRO: CPF já cadastrado no sistema.';
        LEAVE proc_label;
    END IF;

    -- 5. Insere o cliente
    INSERT INTO clientes (nome, email, cpf, telefone, senha_hash, cep, endereco, cidade, estado, regiao)
    VALUES (p_nome, p_email, v_cpf_fmt, p_telefone, v_senha_hash, p_cep, p_endereco, p_cidade, p_estado, p_regiao);

    SET p_mensagem = CONCAT('OK: Cliente cadastrado com sucesso. ID = ', LAST_INSERT_ID());
END proc_label$$                           -- ← fecha com o mesmo label

DELIMITER ;


-- =============================================================
-- 2. sp_cadastrarEntregador
-- =============================================================
DROP PROCEDURE IF EXISTS sp_cadastrarEntregador;

DELIMITER $$

CREATE PROCEDURE sp_cadastrarEntregador(
    IN  p_nome         VARCHAR(120),
    IN  p_cpf          VARCHAR(20),
    IN  p_cnh          VARCHAR(20),
    IN  p_tipo_veiculo ENUM('moto','bicicleta','carro','van'),
    IN  p_placa        VARCHAR(10),
    IN  p_cnpj         VARCHAR(20),
    IN  p_senha        VARCHAR(255),
    OUT p_mensagem     VARCHAR(200)
)
proc_label: BEGIN
    DECLARE v_cpf_fmt    VARCHAR(14);
    DECLARE v_cnpj_fmt   VARCHAR(18);
    DECLARE v_senha_hash VARCHAR(255);
    DECLARE v_existe     INT DEFAULT 0;

    -- 1. Formata CPF
    SET v_cpf_fmt = fn_formatarCPF(p_cpf);
    IF v_cpf_fmt IS NULL THEN
        SET p_mensagem = 'ERRO: CPF inválido. Informe 11 dígitos numéricos.';
        LEAVE proc_label;
    END IF;

    -- 2. Formata CNPJ (se informado)
    IF p_cnpj IS NOT NULL AND p_cnpj <> '' THEN
        SET v_cnpj_fmt = fn_formatarCNPJ(p_cnpj);
        IF v_cnpj_fmt IS NULL THEN
            SET p_mensagem = 'ERRO: CNPJ inválido. Informe 14 dígitos numéricos.';
            LEAVE proc_label;
        END IF;
    ELSE
        SET v_cnpj_fmt = NULL;
    END IF;

    -- 3. Valida e criptografa a senha
    SET v_senha_hash = fn_encriptarSenha(p_senha);
    IF v_senha_hash IS NULL THEN
        SET p_mensagem = 'ERRO: Senha fraca. Use ao menos 8 caracteres com maiúscula, minúscula, número e símbolo.';
        LEAVE proc_label;
    END IF;

    -- 4. Verifica duplicidade de CPF
    SELECT COUNT(*) INTO v_existe FROM entregadores WHERE cpf = v_cpf_fmt;
    IF v_existe > 0 THEN
        SET p_mensagem = 'ERRO: CPF já cadastrado para outro entregador.';
        LEAVE proc_label;
    END IF;

    -- 5. Insere o entregador
    INSERT INTO entregadores (nome, cpf, cnh, tipo_veiculo, placa, cnpj, senha_hash)
    VALUES (p_nome, v_cpf_fmt, p_cnh, p_tipo_veiculo, p_placa, v_cnpj_fmt, v_senha_hash);

    SET p_mensagem = CONCAT('OK: Entregador cadastrado com sucesso. ID = ', LAST_INSERT_ID());
END proc_label$$

DELIMITER ;


-- =============================================================
-- 3. sp_cadastrarProduto
-- =============================================================
DROP PROCEDURE IF EXISTS sp_cadastrarProduto;

DELIMITER $$

CREATE PROCEDURE sp_cadastrarProduto(
    IN  p_id_restaurante INT,
    IN  p_nome           VARCHAR(150),
    IN  p_descricao      TEXT,
    IN  p_categoria      VARCHAR(80),
    IN  p_preco          DECIMAL(10,2),
    IN  p_estoque        INT,
    OUT p_mensagem       VARCHAR(200)
)
proc_label: BEGIN
    DECLARE v_restaurante_ativo INT DEFAULT 0;

    -- 1. Verifica se o restaurante existe e está ativo
    SELECT COUNT(*) INTO v_restaurante_ativo
    FROM restaurantes
    WHERE id_restaurante = p_id_restaurante AND ativo = 1;

    IF v_restaurante_ativo = 0 THEN
        SET p_mensagem = 'ERRO: Restaurante não encontrado ou inativo.';
        LEAVE proc_label;
    END IF;

    -- 2. Valida preço
    IF p_preco < 0 THEN
        SET p_mensagem = 'ERRO: O preço do produto não pode ser negativo.';
        LEAVE proc_label;
    END IF;

    -- 3. Valida categoria
    IF p_categoria IS NULL OR TRIM(p_categoria) = '' THEN
        SET p_mensagem = 'ERRO: A categoria do produto é obrigatória.';
        LEAVE proc_label;
    END IF;

    -- 4. Valida estoque inicial
    IF p_estoque < 0 THEN
        SET p_mensagem = 'ERRO: O estoque inicial não pode ser negativo.';
        LEAVE proc_label;
    END IF;

    -- 5. Insere o produto
    INSERT INTO produtos (id_restaurante, nome, descricao, categoria, preco, estoque)
    VALUES (p_id_restaurante, p_nome, p_descricao, TRIM(p_categoria), p_preco, p_estoque);

    SET p_mensagem = CONCAT('OK: Produto cadastrado com sucesso. ID = ', LAST_INSERT_ID());
END proc_label$$

DELIMITER ;


-- =============================================================
-- 4. sp_cadastrarPedido
-- =============================================================
DROP PROCEDURE IF EXISTS sp_cadastrarPedido;

DELIMITER $$

CREATE PROCEDURE sp_cadastrarPedido(
    IN  p_id_cliente        INT,
    IN  p_id_restaurante    INT,
    IN  p_id_entregador     INT,
    IN  p_id_taxa_entrega   INT,
    IN  p_id_taxa_servico   INT,
    IN  p_itens             TEXT,
    IN  p_observacao        TEXT,
    OUT p_mensagem          VARCHAR(200)
)
proc_label: BEGIN
    DECLARE v_subtotal        DECIMAL(10,2) DEFAULT 0.00;
    DECLARE v_taxa_entrega    DECIMAL(10,2) DEFAULT 0.00;
    DECLARE v_taxa_servico    DECIMAL(10,2) DEFAULT 0.00;
    DECLARE v_valor_total     DECIMAL(10,2) DEFAULT 0.00;
    DECLARE v_id_pedido       INT;

    DECLARE v_par             VARCHAR(50);
    DECLARE v_id_produto      INT;
    DECLARE v_quantidade      INT;
    DECLARE v_preco_unit      DECIMAL(10,2);
    DECLARE v_estoque_atual   INT;
    DECLARE v_subtotal_item   DECIMAL(10,2);
    DECLARE v_resto           TEXT;
    DECLARE v_pos             INT;

    DECLARE v_taxa_percentual TINYINT(1);
    DECLARE v_taxa_valor      DECIMAL(10,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_mensagem = 'ERRO: Falha inesperada. Transação revertida.';
    END;

    -- Validações iniciais
    IF NOT EXISTS (SELECT 1 FROM clientes WHERE id_cliente = p_id_cliente AND ativo = 1) THEN
        SET p_mensagem = 'ERRO: Cliente não encontrado ou inativo.';
        LEAVE proc_label;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM restaurantes WHERE id_restaurante = p_id_restaurante AND ativo = 1) THEN
        SET p_mensagem = 'ERRO: Restaurante não encontrado ou inativo.';
        LEAVE proc_label;
    END IF;

    IF p_itens IS NULL OR TRIM(p_itens) = '' THEN
        SET p_mensagem = 'ERRO: O pedido deve conter ao menos um item.';
        LEAVE proc_label;
    END IF;

    -- Busca taxa de entrega
    SELECT valor, percentual INTO v_taxa_valor, v_taxa_percentual
    FROM taxas
    WHERE id_taxa = p_id_taxa_entrega AND tipo = 'entrega' AND ativo = 1
    LIMIT 1;
    SET v_taxa_entrega = IFNULL(v_taxa_valor, 0.00);

    -- Busca taxa de serviço
    SELECT valor, percentual INTO v_taxa_valor, v_taxa_percentual
    FROM taxas
    WHERE id_taxa = p_id_taxa_servico AND tipo = 'servico' AND ativo = 1
    LIMIT 1;

    -- Inicia transação
    START TRANSACTION;

    INSERT INTO pedidos (id_cliente, id_restaurante, id_entregador, observacao,
                         valor_subtotal, taxa_entrega, taxa_servico, valor_total, status)
    VALUES (p_id_cliente, p_id_restaurante, p_id_entregador, p_observacao,
            0.00, 0.00, 0.00, 0.00, 'pendente');

    SET v_id_pedido = LAST_INSERT_ID();

    -- Processa itens: formato 'id_produto:qtd,id_produto:qtd,...'
    SET v_resto = CONCAT(TRIM(p_itens), ',');

    loop_itens: WHILE LENGTH(v_resto) > 0 DO

        SET v_pos = LOCATE(',', v_resto);
        IF v_pos = 0 THEN
            SET v_par   = v_resto;
            SET v_resto = '';
        ELSE
            SET v_par   = SUBSTRING(v_resto, 1, v_pos - 1);
            SET v_resto = SUBSTRING(v_resto, v_pos + 1);
        END IF;

        SET v_par = TRIM(v_par);
        IF v_par = '' THEN
            ITERATE loop_itens;   -- pula entradas vazias (label do loop)
        END IF;

        SET v_id_produto = CAST(SUBSTRING_INDEX(v_par, ':', 1)  AS UNSIGNED);
        SET v_quantidade = CAST(SUBSTRING_INDEX(v_par, ':', -1) AS UNSIGNED);

        IF v_quantidade <= 0 THEN
            ROLLBACK;
            SET p_mensagem = CONCAT('ERRO: Quantidade inválida para o produto ID ', v_id_produto);
            LEAVE proc_label;
        END IF;

        SELECT preco, estoque INTO v_preco_unit, v_estoque_atual
        FROM produtos
        WHERE id_produto = v_id_produto
          AND id_restaurante = p_id_restaurante
          AND disponivel = 1
        LIMIT 1;

        IF v_preco_unit IS NULL THEN
            ROLLBACK;
            SET p_mensagem = CONCAT('ERRO: Produto ID ', v_id_produto, ' não encontrado ou indisponível neste restaurante.');
            LEAVE proc_label;
        END IF;

        IF v_estoque_atual < v_quantidade THEN
            ROLLBACK;
            SET p_mensagem = CONCAT('ERRO: Estoque insuficiente para o produto ID ', v_id_produto,
                                    '. Disponível: ', v_estoque_atual, ' | Solicitado: ', v_quantidade);
            LEAVE proc_label;
        END IF;

        SET v_subtotal_item = v_preco_unit * v_quantidade;

        INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal)
        VALUES (v_id_pedido, v_id_produto, v_quantidade, v_preco_unit, v_subtotal_item);

        UPDATE produtos SET estoque = estoque - v_quantidade WHERE id_produto = v_id_produto;

        SET v_subtotal = v_subtotal + v_subtotal_item;

    END WHILE loop_itens;

    -- Calcula taxa de serviço
    IF v_taxa_percentual = 1 THEN
        SET v_taxa_servico = ROUND(v_subtotal * (v_taxa_valor / 100), 2);
    ELSE
        SET v_taxa_servico = IFNULL(v_taxa_valor, 0.00);
    END IF;

    SET v_valor_total = v_subtotal + v_taxa_entrega + v_taxa_servico;

    UPDATE pedidos
    SET valor_subtotal = v_subtotal,
        taxa_entrega   = v_taxa_entrega,
        taxa_servico   = v_taxa_servico,
        valor_total    = v_valor_total,
        status         = 'confirmado'
    WHERE id_pedido = v_id_pedido;

    COMMIT;

    SET p_mensagem = CONCAT('OK: Pedido #', v_id_pedido,
                            ' cadastrado. Total: R$ ', FORMAT(v_valor_total, 2, 'pt_BR'));
END proc_label$$

DELIMITER ;


-- =============================================================
-- TESTES
-- =============================================================


CALL sp_cadastrarCliente(
    'Novo Cliente Teste', 'novo@teste.com', '52998224725',
    '(61) 99000-0001', 'Teste@2024!',
    '70040-010', 'SQN 100 Bloco A', 'Brasília', 'DF', 'Centro-Oeste',
    @msg
);
SELECT @msg;

CALL sp_cadastrarEntregador(
    'Entregador Novo', '33355577796', 'CNH12345', 'moto',
    'XYZ-9999', NULL, 'Entrega@2024!', @msg
);
SELECT @msg;

CALL sp_cadastrarProduto(
    1, 'Novo Produto Teste', 'Descrição do produto', 'lanche',
    25.90, 30, @msg
);
SELECT @msg;

CALL sp_cadastrarPedido(
    1, 1, 1, 1, 9, '1:1,2:2', 'Teste de pedido via procedure', @msg
);
SELECT @msg;