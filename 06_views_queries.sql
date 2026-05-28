-- =============================================================
--  PROJETO FINAL — ECOSSISTEMA DE DELIVERY
--  Arquivo : 06_views_queries.sql
--  Objetivo: View de relatório regional + queries de teste
--            com UPDATE e DELETE exemplares
--  Banco   : MySQL 8.0+
-- =============================================================

USE delivery;

-- =============================================================
-- 1. vw_relatorio_regional
--    Apresenta pedidos filtrados por:
--      - Região do Restaurante
--      - Período (criado_em)
--      - Tipo de Item (categoria do produto)
--      - Valor Total
-- =============================================================
DROP VIEW IF EXISTS vw_relatorio_regional;

CREATE VIEW vw_relatorio_regional AS
SELECT
    -- Identificação do pedido
    p.id_pedido,
    p.criado_em                             AS data_pedido,
    p.status                                AS status_pedido,

    -- Dados do cliente
    c.id_cliente,
    c.nome                                  AS nome_cliente,
    c.cidade                                AS cidade_cliente,

    -- Dados do restaurante e região
    r.id_restaurante,
    r.nome                                  AS nome_restaurante,
    r.cidade                                AS cidade_restaurante,
    r.estado                                AS estado_restaurante,
    r.regiao                                AS regiao_restaurante,   -- filtro principal RNF04

    -- Dados do produto / tipo de item
    pr.id_produto,
    pr.nome                                 AS nome_produto,
    pr.categoria                            AS tipo_item,            -- filtro por categoria
    ip.quantidade,
    ip.preco_unitario,
    ip.subtotal                             AS subtotal_item,

    -- Dados do entregador
    e.id_entregador,
    e.nome                                  AS nome_entregador,
    e.tipo_veiculo,

    -- Valores financeiros do pedido
    p.valor_subtotal,
    p.taxa_entrega,
    p.taxa_servico,
    p.taxa_cancelamento,
    p.valor_total,                                                   -- filtro por valor total

    -- Período — colunas auxiliares para facilitar filtros por data
    YEAR(p.criado_em)                       AS ano_pedido,
    MONTH(p.criado_em)                      AS mes_pedido,
    DATE(p.criado_em)                       AS dia_pedido

FROM pedidos p
    INNER JOIN clientes     c  ON c.id_cliente     = p.id_cliente
    INNER JOIN restaurantes r  ON r.id_restaurante = p.id_restaurante
    INNER JOIN itens_pedido ip ON ip.id_pedido     = p.id_pedido
    INNER JOIN produtos     pr ON pr.id_produto    = ip.id_produto
    LEFT  JOIN entregadores e  ON e.id_entregador  = p.id_entregador;


-- =============================================================
-- 2. CONSULTAS DE USO DA VIEW
-- =============================================================

-- -----------------------------------------------------------
-- 2a. Todos os pedidos entregues na região Centro-Oeste
-- -----------------------------------------------------------
SELECT *
FROM vw_relatorio_regional
WHERE regiao_restaurante = 'Centro-Oeste'
  AND status_pedido      = 'entregue'
ORDER BY data_pedido DESC;


-- -----------------------------------------------------------
-- 2b. Pedidos por período (mês/ano específico)
-- -----------------------------------------------------------
SELECT
    id_pedido,
    nome_restaurante,
    regiao_restaurante,
    tipo_item,
    valor_total,
    data_pedido
FROM vw_relatorio_regional
WHERE ano_pedido = YEAR(CURDATE())
  AND mes_pedido = MONTH(CURDATE())
ORDER BY data_pedido DESC;


-- -----------------------------------------------------------
-- 2c. Pedidos filtrados por tipo de item (categoria)
-- -----------------------------------------------------------
SELECT
    id_pedido,
    nome_cliente,
    nome_restaurante,
    regiao_restaurante,
    tipo_item,
    nome_produto,
    quantidade,
    subtotal_item,
    valor_total
FROM vw_relatorio_regional
WHERE tipo_item = 'pizza'
ORDER BY valor_total DESC;


-- -----------------------------------------------------------
-- 2d. Pedidos com valor total acima de R$ 80,00
-- -----------------------------------------------------------
SELECT
    id_pedido,
    nome_cliente,
    nome_restaurante,
    regiao_restaurante,
    status_pedido,
    valor_total
FROM vw_relatorio_regional
WHERE valor_total > 80.00
ORDER BY valor_total DESC;


-- -----------------------------------------------------------
-- 2e. Relatório agrupado: total de pedidos e receita
--     por região e tipo de item
-- -----------------------------------------------------------
SELECT
    regiao_restaurante,
    tipo_item,
    COUNT(DISTINCT id_pedido)   AS total_pedidos,
    SUM(subtotal_item)          AS receita_itens,
    SUM(valor_total)            AS receita_total,
    ROUND(AVG(valor_total), 2)  AS ticket_medio
FROM vw_relatorio_regional
WHERE status_pedido = 'entregue'
GROUP BY regiao_restaurante, tipo_item
ORDER BY regiao_restaurante, receita_total DESC;


-- -----------------------------------------------------------
-- 2f. Ranking de restaurantes por receita na região Sudeste
-- -----------------------------------------------------------
SELECT
    nome_restaurante,
    cidade_restaurante,
    COUNT(DISTINCT id_pedido)  AS total_pedidos,
    SUM(valor_total)           AS receita_total
FROM vw_relatorio_regional
WHERE regiao_restaurante = 'Sudeste'
  AND status_pedido      = 'entregue'
GROUP BY id_restaurante, nome_restaurante, cidade_restaurante
ORDER BY receita_total DESC;


-- =============================================================
-- 3. UPDATES EXEMPLARES (mínimo 5)
-- =============================================================

-- Update 1: Avança status do pedido 13 para saiu_entrega
UPDATE pedidos
SET status        = 'saiu_entrega',
    id_entregador = 7
WHERE id_pedido = 13;

-- Update 2: Confirma o pedido 15 e atribui entregador
UPDATE pedidos
SET status        = 'confirmado',
    id_entregador = 17
WHERE id_pedido = 15;

-- Update 3: Atualiza preço e estoque do produto Smash Burger
UPDATE produtos
SET preco   = 34.90,
    estoque = 45
WHERE id_produto = 1;

-- Update 4: Desativa restaurante inativo (Bar do Portão)
UPDATE restaurantes
SET ativo = 0
WHERE id_restaurante = 20;

-- Update 5: Atualiza endereço e telefone de um cliente
UPDATE clientes
SET telefone = '(61) 99100-9999',
    endereco = 'SQN 210 Bloco C Ap 305',
    cep      = '70855-030'
WHERE id_cliente = 1;


-- =============================================================
-- 4. DELETES EXEMPLARES (mínimo 5)
-- =============================================================

-- Delete 1: Remove FAQ resolvido e fechado (id_cliente NULL = público)
DELETE FROM faq_reclamacoes
WHERE tipo      = 'faq'
  AND status    = 'resolvido'
  AND id_cliente IS NULL
LIMIT 1;

-- Delete 2: Remove produto sem estoque e indisponível
DELETE FROM produtos
WHERE estoque   = 0
  AND disponivel = 0
LIMIT 1;

-- Delete 3: Remove entregador inativo sem pedidos vinculados
DELETE FROM entregadores
WHERE status = 'inativo'
  AND id_entregador NOT IN (
      SELECT DISTINCT id_entregador
      FROM pedidos
      WHERE id_entregador IS NOT NULL
  )
LIMIT 1;

-- Delete 4: Remove histórico de auditoria mais antigo que 1 ano
DELETE FROM historico_pedidos
WHERE registrado_em < DATE_SUB(NOW(), INTERVAL 1 YEAR);

-- Delete 5: Remove itens de pedidos cancelados
--           (pedidos cancelados não precisam manter itens ativos)
DELETE ip
FROM itens_pedido ip
INNER JOIN pedidos p ON p.id_pedido = ip.id_pedido
WHERE p.status = 'cancelado';