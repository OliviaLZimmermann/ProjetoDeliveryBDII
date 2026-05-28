-- =============================================================
--  PROJETO FINAL — ECOSSISTEMA DE DELIVERY
--  Arquivo : 05_triggers.sql
--  Objetivo: Trigger de auditoria — espelha cada INSERT ou
--            UPDATE na tabela pedidos para historico_pedidos
--  Banco   : MySQL 8.0+
-- =============================================================

USE delivery;

-- =============================================================
-- 1. tg_auditoria_pedido — AFTER INSERT
--    Sempre que um novo pedido for inserido, grava um espelho
--    completo do registro em historico_pedidos com
--    operacao = 'INSERT'
-- =============================================================
DROP TRIGGER IF EXISTS tg_auditoria_pedido_insert;

DELIMITER $$

CREATE TRIGGER tg_auditoria_pedido_insert
AFTER INSERT ON pedidos
FOR EACH ROW
BEGIN
    INSERT INTO historico_pedidos (
        id_pedido,
        id_cliente,
        id_restaurante,
        id_entregador,
        valor_subtotal,
        taxa_entrega,
        taxa_servico,
        valor_total,
        status,
        observacao,
        operacao,
        registrado_em
    ) VALUES (
        NEW.id_pedido,
        NEW.id_cliente,
        NEW.id_restaurante,
        NEW.id_entregador,
        NEW.valor_subtotal,
        NEW.taxa_entrega,
        NEW.taxa_servico,
        NEW.valor_total,
        NEW.status,
        NEW.observacao,
        'INSERT',
        NOW()
    );
END$$

DELIMITER ;


-- =============================================================
-- 2. tg_auditoria_pedido — AFTER UPDATE
--    Sempre que um pedido for atualizado (status, entregador,
--    valores etc.), grava o estado NOVO em historico_pedidos
--    com operacao = 'UPDATE', permitindo rastrear cada
--    mudança ao longo do ciclo de vida do pedido (RNF05)
-- =============================================================
DROP TRIGGER IF EXISTS tg_auditoria_pedido_update;

DELIMITER $$

CREATE TRIGGER tg_auditoria_pedido_update
AFTER UPDATE ON pedidos
FOR EACH ROW
BEGIN
    INSERT INTO historico_pedidos (
        id_pedido,
        id_cliente,
        id_restaurante,
        id_entregador,
        valor_subtotal,
        taxa_entrega,
        taxa_servico,
        valor_total,
        status,
        observacao,
        operacao,
        registrado_em
    ) VALUES (
        NEW.id_pedido,
        NEW.id_cliente,
        NEW.id_restaurante,
        NEW.id_entregador,
        NEW.valor_subtotal,
        NEW.taxa_entrega,
        NEW.taxa_servico,
        NEW.valor_total,
        NEW.status,
        NEW.observacao,
        'UPDATE',
        NOW()
    );
END$$

DELIMITER ;


-- =============================================================
-- TESTES DOS TRIGGERS
-- =============================================================


-- -------------------------------------------------------
-- Teste 1: INSERT dispara tg_auditoria_pedido_insert
-- -------------------------------------------------------
INSERT INTO pedidos (
    id_cliente, id_restaurante, id_entregador,
    valor_subtotal, taxa_entrega, taxa_servico, valor_total,
    status, observacao
) VALUES (
    1, 1, 1,
    32.90, 5.00, 1.64, 39.54,
    'pendente', 'Pedido de teste do trigger'
);

-- Confere se o espelho foi gravado em historico_pedidos
SELECT *
FROM historico_pedidos
WHERE id_pedido = LAST_INSERT_ID()
ORDER BY registrado_em DESC;


-- -------------------------------------------------------
-- Teste 2: UPDATE dispara tg_auditoria_pedido_update
-- Simula a progressão de status de um pedido existente
-- -------------------------------------------------------
-- Passo a passo do ciclo de vida:
UPDATE pedidos SET status = 'confirmado'    WHERE id_pedido = 1;
UPDATE pedidos SET status = 'em_preparo'    WHERE id_pedido = 1;
UPDATE pedidos SET status = 'saiu_entrega'  WHERE id_pedido = 1;
UPDATE pedidos SET status = 'entregue'      WHERE id_pedido = 1;

-- Confere todo o histórico do pedido 1 (deve mostrar cada etapa)
SELECT
    id_historico,
    id_pedido,
    status,
    operacao,
    registrado_em
FROM historico_pedidos
WHERE id_pedido = 1
ORDER BY registrado_em ASC;


-- -------------------------------------------------------
-- Teste 3: Cancelamento com taxa
-- -------------------------------------------------------
UPDATE pedidos
SET status            = 'cancelado',
    taxa_cancelamento = 10.00,
    valor_total       = valor_total + 10.00
WHERE id_pedido = 2;

SELECT *
FROM historico_pedidos
WHERE id_pedido = 2
ORDER BY registrado_em DESC
LIMIT 1;