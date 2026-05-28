-- =============================================================
--  PROJETO FINAL — ECOSSISTEMA DE DELIVERY
--  Arquivo : 03_functions.sql
--  Objetivo: Funções reutilizáveis de formatação, validação
--            e criptografia de dados
--  Banco   : MySQL 8.0+
-- =============================================================

USE delivery;

-- =============================================================
-- 1. fn_formatarCPF
--    Recebe uma string de 11 dígitos numéricos e retorna
--    o CPF no formato 000.000.000-00
--    Exemplo: '12345678901' → '123.456.789-01'
-- =============================================================
DROP FUNCTION IF EXISTS fn_formatarCPF;

DELIMITER $$

CREATE FUNCTION fn_formatarCPF(p_cpf VARCHAR(20))
RETURNS VARCHAR(14)
DETERMINISTIC
BEGIN
    -- Remove qualquer caractere não numérico antes de formatar
    DECLARE v_cpf_limpo VARCHAR(11);

    SET v_cpf_limpo = REGEXP_REPLACE(p_cpf, '[^0-9]', '');

    -- Valida se possui exatamente 11 dígitos
    IF LENGTH(v_cpf_limpo) <> 11 THEN
        RETURN NULL; -- CPF inválido
    END IF;

    -- Monta o formato 000.000.000-00
    RETURN CONCAT(
        SUBSTRING(v_cpf_limpo, 1, 3), '.',
        SUBSTRING(v_cpf_limpo, 4, 3), '.',
        SUBSTRING(v_cpf_limpo, 7, 3), '-',
        SUBSTRING(v_cpf_limpo, 10, 2)
    );
END$$

DELIMITER ;


-- =============================================================
-- 2. fn_formatarCNPJ
--    Recebe uma string de 14 dígitos numéricos e retorna
--    o CNPJ no formato 00.000.000/0000-00
--    Exemplo: '11111111000101' → '11.111.111/0001-01'
-- =============================================================
DROP FUNCTION IF EXISTS fn_formatarCNPJ;

DELIMITER $$

CREATE FUNCTION fn_formatarCNPJ(p_cnpj VARCHAR(20))
RETURNS VARCHAR(18)
DETERMINISTIC
BEGIN
    DECLARE v_cnpj_limpo VARCHAR(14);

    SET v_cnpj_limpo = REGEXP_REPLACE(p_cnpj, '[^0-9]', '');

    -- Valida se possui exatamente 14 dígitos
    IF LENGTH(v_cnpj_limpo) <> 14 THEN
        RETURN NULL; -- CNPJ inválido
    END IF;

    -- Monta o formato 00.000.000/0000-00
    RETURN CONCAT(
        SUBSTRING(v_cnpj_limpo, 1,  2), '.',
        SUBSTRING(v_cnpj_limpo, 3,  3), '.',
        SUBSTRING(v_cnpj_limpo, 6,  3), '/',
        SUBSTRING(v_cnpj_limpo, 9,  4), '-',
        SUBSTRING(v_cnpj_limpo, 13, 2)
    );
END$$

DELIMITER ;


-- =============================================================
-- 3. fn_validarSenha
--    Verifica a força da senha e retorna um status textual:
--      'FRACA'   — menos de 8 caracteres
--      'MEDIA'   — 8+ caracteres, mas sem todos os critérios
--      'FORTE'   — 8+ chars, letra maiúscula, minúscula,
--                  número e caractere especial
-- =============================================================
DROP FUNCTION IF EXISTS fn_validarSenha;

DELIMITER $$

CREATE FUNCTION fn_validarSenha(p_senha VARCHAR(255))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE v_tem_maiuscula   TINYINT(1) DEFAULT 0;
    DECLARE v_tem_minuscula   TINYINT(1) DEFAULT 0;
    DECLARE v_tem_numero      TINYINT(1) DEFAULT 0;
    DECLARE v_tem_especial    TINYINT(1) DEFAULT 0;
    DECLARE v_comprimento     INT;

    SET v_comprimento = LENGTH(p_senha);

    -- Critério 1: mínimo de 8 caracteres
    IF v_comprimento < 8 THEN
        RETURN 'FRACA';
    END IF;

    -- Critério 2: contém letra maiúscula (A-Z)
    IF p_senha REGEXP '[A-Z]' THEN
        SET v_tem_maiuscula = 1;
    END IF;

    -- Critério 3: contém letra minúscula (a-z)
    IF p_senha REGEXP '[a-z]' THEN
        SET v_tem_minuscula = 1;
    END IF;

    -- Critério 4: contém número (0-9)
    IF p_senha REGEXP '[0-9]' THEN
        SET v_tem_numero = 1;
    END IF;

    -- Critério 5: contém caractere especial
    IF p_senha REGEXP '[^a-zA-Z0-9]' THEN
        SET v_tem_especial = 1;
    END IF;

    -- Todos os critérios atendidos → FORTE
    IF v_tem_maiuscula = 1 AND v_tem_minuscula = 1
       AND v_tem_numero = 1 AND v_tem_especial = 1 THEN
        RETURN 'FORTE';
    END IF;

    -- Comprimento OK mas falta algum critério → MEDIA
    RETURN 'MEDIA';
END$$

DELIMITER ;


-- =============================================================
-- 4. fn_encriptarSenha
--    Aplica algoritmo SHA-256 (via SHA2) para proteger a senha.
--    Retorna NULL se a senha for considerada FRACA pela
--    fn_validarSenha, garantindo que senhas fracas nunca
--    sejam armazenadas. (RNF02)
-- =============================================================
DROP FUNCTION IF EXISTS fn_encriptarSenha;

DELIMITER $$

CREATE FUNCTION fn_encriptarSenha(p_senha VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    -- Rejeita senhas fracas antes de criptografar
    IF fn_validarSenha(p_senha) = 'FRACA' THEN
        RETURN NULL;
    END IF;

    -- Retorna o hash SHA-256 da senha
    RETURN SHA2(p_senha, 256);
END$$

DELIMITER ;


-- =============================================================
-- TESTES RÁPIDOS DAS FUNCTIONS
-- =============================================================

-- Teste fn_formatarCPF
SELECT fn_formatarCPF('12345678901')   AS cpf_formatado;   -- 123.456.789-01
SELECT fn_formatarCPF('123.456.789-01') AS cpf_ja_formatado; -- 123.456.789-01 (limpa e reformata)
SELECT fn_formatarCPF('1234567')       AS cpf_invalido;    -- NULL

-- Teste fn_formatarCNPJ
SELECT fn_formatarCNPJ('11111111000101')       AS cnpj_formatado;   -- 11.111.111/0001-01
SELECT fn_formatarCNPJ('11.111.111/0001-01')   AS cnpj_ja_formatado; -- 11.111.111/0001-01
SELECT fn_formatarCNPJ('123456')               AS cnpj_invalido;    -- NULL

-- Teste fn_validarSenha
SELECT fn_validarSenha('abc')          AS resultado;  -- FRACA
SELECT fn_validarSenha('minhasenha')   AS resultado;  -- MEDIA
SELECT fn_validarSenha('Senha@2024!')  AS resultado;  -- FORTE

-- Teste fn_encriptarSenha
SELECT fn_encriptarSenha('abc')         AS hash; -- NULL (fraca, rejeitada)
SELECT fn_encriptarSenha('Senha@2024!') AS hash; -- hash SHA-256 da senha