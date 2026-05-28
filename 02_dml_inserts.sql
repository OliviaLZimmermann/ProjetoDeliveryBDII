-- =============================================================
--  PROJETO FINAL — ECOSSISTEMA DE DELIVERY
--  Arquivo: 02_dml_inserts.sql
--  Objetivo: Carga de dados (mínimo 20 inserts por tabela)
--  Banco   : MySQL 8.0+
-- =============================================================

USE delivery;

-- =============================================================
-- 1. CLIENTES (20 registros)
-- =============================================================
INSERT INTO clientes (nome, email, cpf, telefone, senha_hash, cep, endereco, cidade, estado, regiao) VALUES
('Ana Paula Souza',       'ana.souza@email.com',      '123.456.789-01', '(61) 99101-0001', SHA2('Senha@2024!', 256), '70040-010', 'SQN 208 Bloco A Ap 101', 'Brasília',       'DF', 'Centro-Oeste'),
('Carlos Henrique Lima',  'carlos.lima@email.com',    '234.567.890-12', '(11) 99202-0002', SHA2('Senha@2024!', 256), '01310-100', 'Av. Paulista 1000 Ap 52', 'São Paulo',     'SP', 'Sudeste'),
('Fernanda Rocha',        'fernanda.rocha@email.com', '345.678.901-23', '(21) 99303-0003', SHA2('Senha@2024!', 256), '20040-020', 'Rua da Assembleia 50',   'Rio de Janeiro', 'RJ', 'Sudeste'),
('Marcos Vinicius Santos','marcos.santos@email.com',  '456.789.012-34', '(31) 99404-0004', SHA2('Senha@2024!', 256), '30112-000', 'Av. Afonso Pena 200',    'Belo Horizonte', 'MG', 'Sudeste'),
('Juliana Ferreira',      'juliana.ferreira@email.com','567.890.123-45','(41) 99505-0005', SHA2('Senha@2024!', 256), '80010-010', 'Rua XV de Novembro 300', 'Curitiba',       'PR', 'Sul'),
('Rafael Almeida',        'rafael.almeida@email.com', '678.901.234-56', '(51) 99606-0006', SHA2('Senha@2024!', 256), '90010-150', 'Av. Borges de Medeiros 500','Porto Alegre','RS', 'Sul'),
('Tatiane Costa',         'tatiane.costa@email.com',  '789.012.345-67', '(71) 99707-0007', SHA2('Senha@2024!', 256), '40020-020', 'Av. Sete de Setembro 100','Salvador',      'BA', 'Nordeste'),
('Bruno Mendes',          'bruno.mendes@email.com',   '890.123.456-78', '(81) 99808-0008', SHA2('Senha@2024!', 256), '50010-010', 'Rua do Imperador 80',    'Recife',         'PE', 'Nordeste'),
('Letícia Oliveira',      'leticia.oliveira@email.com','901.234.567-89','(85) 99909-0009', SHA2('Senha@2024!', 256), '60010-060', 'Av. Beira Mar 200',      'Fortaleza',      'CE', 'Nordeste'),
('Diego Carvalho',        'diego.carvalho@email.com', '012.345.678-90', '(91) 99010-0010', SHA2('Senha@2024!', 256), '66010-000', 'Tv. Padre Eutíquio 10',  'Belém',          'PA', 'Norte'),
('Priscila Nunes',        'priscila.nunes@email.com', '111.222.333-44', '(62) 99111-0011', SHA2('Senha@2024!', 256), '74010-010', 'Av. Goiás 500',          'Goiânia',        'GO', 'Centro-Oeste'),
('Leonardo Barbosa',      'leonardo.barbosa@email.com','222.333.444-55','(67) 99222-0012', SHA2('Senha@2024!', 256), '79010-010', 'Av. Afonso Pena 1500',   'Campo Grande',   'MS', 'Centro-Oeste'),
('Sabrina Teixeira',      'sabrina.teixeira@email.com','333.444.555-66','(65) 99333-0013', SHA2('Senha@2024!', 256), '78005-000', 'Av. Historiador Rubens de Mendonça 200','Cuiabá','MT','Centro-Oeste'),
('Felipe Gomes',          'felipe.gomes@email.com',   '444.555.666-77', '(92) 99444-0014', SHA2('Senha@2024!', 256), '69010-000', 'Av. Eduardo Ribeiro 150','Manaus',         'AM', 'Norte'),
('Camila Pereira',        'camila.pereira@email.com', '555.666.777-88', '(86) 99555-0015', SHA2('Senha@2024!', 256), '64000-010', 'Rua Álvaro Mendes 300',  'Teresina',       'PI', 'Nordeste'),
('Gustavo Ribeiro',       'gustavo.ribeiro@email.com','666.777.888-99', '(98) 99666-0016', SHA2('Senha@2024!', 256), '65010-000', 'Av. Getúlio Vargas 400', 'São Luís',       'MA', 'Nordeste'),
('Aline Martins',         'aline.martins@email.com',  '777.888.999-00', '(83) 99777-0017', SHA2('Senha@2024!', 256), '58010-000', 'Av. Epitácio Pessoa 700','João Pessoa',    'PB', 'Nordeste'),
('Rodrigo Freitas',       'rodrigo.freitas@email.com','888.999.000-11', '(82) 99888-0018', SHA2('Senha@2024!', 256), '57010-000', 'Av. Fernandes Lima 500', 'Maceió',         'AL', 'Nordeste'),
('Vanessa Araújo',        'vanessa.araujo@email.com', '999.000.111-22', '(79) 99999-0019', SHA2('Senha@2024!', 256), '49010-000', 'Av. Beira Mar 1000',     'Aracaju',        'SE', 'Nordeste'),
('Thiago Nascimento',     'thiago.nascimento@email.com','000.111.222-33','(27) 99000-0020',SHA2('Senha@2024!', 256), '29010-010', 'Av. Princesa Isabel 300','Vitória',        'ES', 'Sudeste');


-- =============================================================
-- 2. ENTREGADORES (20 registros)
-- =============================================================
INSERT INTO entregadores (nome, cpf, cnh, tipo_veiculo, placa, cnpj, status, senha_hash) VALUES
('João Pedro Silva',     '101.202.303-40', '00112233', 'moto',      'ABC-1234', '10.200.300/0001-40', 'disponivel',  SHA2('Entrega@2024!', 256)),
('Maria Eduarda Santos', '202.303.404-51', '00223344', 'bicicleta', NULL,       NULL,                  'disponivel',  SHA2('Entrega@2024!', 256)),
('Paulo Ricardo Souza',  '303.404.505-62', '00334455', 'moto',      'DEF-2345', '30.400.500/0001-62', 'em_entrega',  SHA2('Entrega@2024!', 256)),
('Claudia Vieira',       '404.505.606-73', '00445566', 'carro',     'GHI-3456', '40.500.600/0001-73', 'disponivel',  SHA2('Entrega@2024!', 256)),
('Alexandre Moreira',    '505.606.707-84', '00556677', 'moto',      'JKL-4567', NULL,                  'disponivel',  SHA2('Entrega@2024!', 256)),
('Patrícia Lemos',       '606.707.808-95', '00667788', 'van',       'MNO-5678', '60.700.800/0001-95', 'inativo',     SHA2('Entrega@2024!', 256)),
('Sérgio Corrêa',        '707.808.909-06', '00778899', 'moto',      'PQR-6789', NULL,                  'em_entrega',  SHA2('Entrega@2024!', 256)),
('Amanda Pinto',         '808.909.010-17', '00889900', 'bicicleta', NULL,       NULL,                  'disponivel',  SHA2('Entrega@2024!', 256)),
('Renato Cardoso',       '909.010.111-28', '00990011', 'carro',     'STU-7890', '90.010.111/0001-28', 'disponivel',  SHA2('Entrega@2024!', 256)),
('Isabela Cruz',         '010.111.212-39', '01001122', 'moto',      'VWX-8901', NULL,                  'disponivel',  SHA2('Entrega@2024!', 256)),
('Henrique Dias',        '111.212.313-40', '01112233', 'moto',      'YZA-9012', '11.212.313/0001-40', 'disponivel',  SHA2('Entrega@2024!', 256)),
('Luciana Campos',       '212.313.414-51', '01223344', 'bicicleta', NULL,       NULL,                  'inativo',     SHA2('Entrega@2024!', 256)),
('Fábio Monteiro',       '313.414.515-62', '01334455', 'moto',      'BCD-0123', NULL,                  'disponivel',  SHA2('Entrega@2024!', 256)),
('Daniela Ramos',        '414.515.616-73', '01445566', 'carro',     'EFG-1234', '41.515.616/0001-73', 'em_entrega',  SHA2('Entrega@2024!', 256)),
('Wagner Azevedo',       '515.616.717-84', '01556677', 'moto',      'HIJ-2345', NULL,                  'disponivel',  SHA2('Entrega@2024!', 256)),
('Natália Borges',       '616.717.818-95', '01667788', 'van',       'KLM-3456', '61.717.818/0001-95', 'disponivel',  SHA2('Entrega@2024!', 256)),
('Márcio Rocha',         '717.818.919-06', '01778899', 'moto',      'NOP-4567', NULL,                  'disponivel',  SHA2('Entrega@2024!', 256)),
('Simone Cavalcante',    '818.919.020-17', '01889900', 'bicicleta', NULL,       NULL,                  'disponivel',  SHA2('Entrega@2024!', 256)),
('Edson Figueiredo',     '919.020.121-28', '01990011', 'moto',      'QRS-5678', '91.020.121/0001-28', 'em_entrega',  SHA2('Entrega@2024!', 256)),
('Cristina Melo',        '020.121.222-39', '02001122', 'carro',     'TUV-6789', '02.121.222/0001-39', 'disponivel',  SHA2('Entrega@2024!', 256));


-- =============================================================
-- 3. RESTAURANTES (20 registros)
-- =============================================================
INSERT INTO restaurantes (nome, cnpj, telefone, email, cep, endereco, cidade, estado, regiao) VALUES
('Burger Palace',        '11.111.111/0001-01', '(61) 3301-0001', 'contato@burgerpalace.com',   '70040-010', 'SHN Quadra 2 Bloco A',      'Brasília',       'DF', 'Centro-Oeste'),
('Pizza Express',        '22.222.222/0001-02', '(11) 3302-0002', 'contato@pizzaexpress.com',   '01310-100', 'Av. Paulista 500',           'São Paulo',      'SP', 'Sudeste'),
('Sushi Tokyo',          '33.333.333/0001-03', '(21) 3303-0003', 'contato@sushitokyo.com',     '20040-020', 'Rua do Catete 200',          'Rio de Janeiro', 'RJ', 'Sudeste'),
('Churrascaria Gaúcha',  '44.444.444/0001-04', '(51) 3304-0004', 'contato@churrascariagaucha.com','90010-150','Av. Ipiranga 100',         'Porto Alegre',   'RS', 'Sul'),
('Cantina Italiana',     '55.555.555/0001-05', '(31) 3305-0005', 'contato@cantina.com',        '30112-000', 'Av. do Contorno 300',        'Belo Horizonte', 'MG', 'Sudeste'),
('Tapiocaria Nordestina','66.666.666/0001-06', '(81) 3306-0006', 'contato@tapiocaria.com',     '50010-010', 'Rua da Aurora 150',          'Recife',         'PE', 'Nordeste'),
('Frango Assado Brasil', '77.777.777/0001-07', '(71) 3307-0007', 'contato@frangoassado.com',   '40020-020', 'Av. ACM 400',               'Salvador',       'BA', 'Nordeste'),
('Comida Caseira da Vó', '88.888.888/0001-08', '(85) 3308-0008', 'contato@caseiradavo.com',    '60010-060', 'Rua Major Facundo 20',       'Fortaleza',      'CE', 'Nordeste'),
('Lanches do Zé',        '99.999.999/0001-09', '(41) 3309-0009', 'contato@lanchesdoze.com',    '80010-010', 'Rua Marechal Deodoro 500',   'Curitiba',       'PR', 'Sul'),
('Açaí & Cia',           '10.101.010/0001-10', '(91) 3310-0010', 'contato@acaicia.com',        '66010-000', 'Av. Nazaré 800',             'Belém',          'PA', 'Norte'),
('Ramen House',          '20.202.020/0001-11', '(11) 3311-0011', 'contato@ramenhouse.com',     '01310-200', 'Rua Augusta 600',            'São Paulo',      'SP', 'Sudeste'),
('Taqueria Mexicana',    '30.303.030/0001-12', '(21) 3312-0012', 'contato@taqueria.com',       '20040-030', 'Rua Visconde de Pirajá 300', 'Rio de Janeiro', 'RJ', 'Sudeste'),
('Vegano & Natural',     '40.404.040/0001-13', '(61) 3313-0013', 'contato@veganoenatural.com', '70040-020', 'CLSW 302 Bloco B',           'Brasília',       'DF', 'Centro-Oeste'),
('Poke Bowl Aloha',      '50.505.050/0001-14', '(62) 3314-0014', 'contato@pokebowlaloha.com',  '74010-010', 'Av. T-63 800',               'Goiânia',        'GO', 'Centro-Oeste'),
('Hot Dog Premium',      '60.606.060/0001-15', '(92) 3315-0015', 'contato@hotdogpremium.com',  '69010-000', 'Av. Djalma Batista 500',     'Manaus',         'AM', 'Norte'),
('Pastelaria do Mercado','70.707.070/0001-16', '(83) 3316-0016', 'contato@pastelaria.com',     '58010-000', 'Mercado Central Loja 15',    'João Pessoa',    'PB', 'Nordeste'),
('Crepe & Waffle',       '80.808.080/0001-17', '(27) 3317-0017', 'contato@crepewaffle.com',    '29010-010', 'Av. Nossa Senhora da Penha 400','Vitória',     'ES', 'Sudeste'),
('Grill Master',         '90.909.090/0001-18', '(65) 3318-0018', 'contato@grillmaster.com',    '78005-000', 'Av. CPA 300',                'Cuiabá',         'MT', 'Centro-Oeste'),
('Bistrô das Flores',    '01.010.101/0001-19', '(48) 3319-0019', 'contato@bistroflores.com',   '88010-001', 'Rua Felipe Schmidt 200',     'Florianópolis',  'SC', 'Sul'),
('Bar do Portão',        '12.121.212/0001-20', '(98) 3320-0020', 'contato@bardoportao.com',    '65010-000', 'Rua do Sol 50',              'São Luís',       'MA', 'Nordeste');


-- =============================================================
-- 4. TAXAS (20 registros)
-- =============================================================
INSERT INTO taxas (tipo, descricao, valor, percentual, ativo) VALUES
('entrega',      'Taxa padrão moto – até 5 km',             5.00,  0, 1),
('entrega',      'Taxa padrão moto – 5 a 10 km',            8.00,  0, 1),
('entrega',      'Taxa padrão moto – acima de 10 km',       12.00, 0, 1),
('entrega',      'Taxa bicicleta – até 3 km',               3.00,  0, 1),
('entrega',      'Taxa carro – longa distância',            15.00, 0, 1),
('entrega',      'Taxa van – entrega grande volume',        20.00, 0, 1),
('entrega',      'Taxa expressa – entrega em até 30 min',   10.00, 0, 1),
('entrega',      'Taxa noturna – entre 22h e 6h',           7.00,  0, 1),
('servico',      'Taxa de serviço padrão – 5%',             5.00,  1, 1),
('servico',      'Taxa de serviço premium – 8%',            8.00,  1, 1),
('servico',      'Taxa de serviço marketplace – 10%',       10.00, 1, 1),
('servico',      'Taxa de serviço parceiro – 3%',           3.00,  1, 1),
('servico',      'Taxa de serviço fixo pequeno pedido',     2.00,  0, 1),
('cancelamento', 'Cancelamento antes de confirmar – isento',0.00,  0, 1),
('cancelamento', 'Cancelamento após confirmação – R$ 5',    5.00,  0, 1),
('cancelamento', 'Cancelamento em preparo – R$ 10',         10.00, 0, 1),
('cancelamento', 'Cancelamento saiu entrega – R$ 15',       15.00, 0, 1),
('cancelamento', 'Cancelamento por percentual – 10%',       10.00, 1, 1),
('entrega',      'Frete grátis (cupom parceiro)',            0.00,  0, 0),
('servico',      'Taxa plano corporativo – 2%',             2.00,  1, 0);


-- =============================================================
-- 5. PRODUTOS (20 registros — mistura de restaurantes)
-- =============================================================
INSERT INTO produtos (id_restaurante, nome, descricao, categoria, preco, estoque, disponivel) VALUES
(1,  'Smash Burger Duplo',     'Hambúrguer artesanal duplo com queijo cheddar e bacon',   'lanche',    32.90, 50, 1),
(1,  'Batata Frita Crocante',  'Porção de batata frita temperada com páprica',            'acompanhamento', 16.90, 80, 1),
(1,  'Milk Shake Chocolate',   'Milk shake cremoso 400ml',                                'bebida',    18.90, 30, 1),
(2,  'Pizza Margherita G',     'Pizza grande molho, mussarela e manjericão',              'pizza',     49.90, 20, 1),
(2,  'Pizza Pepperoni G',      'Pizza grande com generoso pepperoni',                     'pizza',     54.90, 20, 1),
(2,  'Calzone Quatro Queijos', 'Calzone recheado com 4 tipos de queijo',                  'pizza',     39.90, 15, 1),
(3,  'Combo Sushi 20 peças',   '20 peças variadas de sushi e sashimi',                    'japonês',   65.00, 10, 1),
(3,  'Temaki Salmão',          'Temaki grande de salmão com cream cheese',                'japonês',   28.00, 25, 1),
(4,  'Picanha na Brasa 300g',  'Picanha com acompanhamentos',                             'churrasco', 79.90, 15, 1),
(4,  'Costela Bovina 400g',    'Costela assada lentamente com farofa',                    'churrasco', 89.90, 10, 1),
(5,  'Lasanha à Bolonhesa',    'Lasanha tradicional italiana com molho bolonhesa',        'massa',     38.90, 20, 1),
(5,  'Fettuccine Alfredo',     'Fettuccine ao molho branco clássico',                     'massa',     34.90, 20, 1),
(6,  'Tapioca de Frango',      'Tapioca recheada com frango desfiado e catupiry',         'tapioca',   18.00, 40, 1),
(6,  'Tapioca Doce de Coco',   'Tapioca com coco ralado e leite condensado',              'tapioca',   12.00, 40, 1),
(9,  'X-Burgão Especial',      'Lanche com dois hambúrgueres e molho especial',           'lanche',    27.90, 60, 1),
(9,  'Cachorro-Quente Gourmet','Hot dog com ingredientes premium',                        'lanche',    22.90, 50, 1),
(10, 'Açaí 500ml',             'Açaí puro da Amazônia com granola e banana',              'sobremesa', 22.00, 35, 1),
(13, 'Prato Vegano do Dia',    'Prato variado 100% vegetal com proteína de soja',         'prato',     32.00, 25, 1),
(11, 'Ramen Tradicional',      'Caldo de porco com macarrão, ovo e chashu',               'japonês',   42.00, 20, 1),
(14, 'Poke Bowl Salmão',       'Bowl com arroz, salmão, edamame e molho shoyu',           'bowl',      38.00, 18, 1);


-- =============================================================
-- 6. PEDIDOS (20 registros)
-- =============================================================
INSERT INTO pedidos (id_cliente, id_restaurante, id_entregador, valor_subtotal, taxa_entrega, taxa_servico, taxa_cancelamento, valor_total, status, observacao) VALUES
(1,  1,  1,  49.80, 5.00, 2.49, 0.00,  57.29, 'entregue',     'Sem cebola no burguer'),
(2,  2,  3,  49.90, 8.00, 2.50, 0.00,  60.40, 'entregue',     NULL),
(3,  3,  7,  65.00, 12.00,3.25, 0.00,  80.25, 'entregue',     'Entregar na portaria'),
(4,  4,  9,  79.90, 5.00, 3.99, 0.00,  88.89, 'entregue',     NULL),
(5,  5,  1,  38.90, 8.00, 1.94, 0.00,  48.84, 'entregue',     'Lasanha bem gratinada'),
(6,  9,  5,  27.90, 5.00, 1.39, 0.00,  34.29, 'entregue',     NULL),
(7,  6,  2,  30.00, 3.00, 1.50, 0.00,  34.50, 'entregue',     NULL),
(8,  1,  1,  32.90, 5.00, 1.64, 0.00,  39.54, 'entregue',     'Ponto da carne: bem passado'),
(9,  2,  3,  94.80, 8.00, 4.74, 0.00, 107.54, 'entregue',     'Dois sabores distintos'),
(10, 10, 4,  22.00, 5.00, 1.10, 0.00,  28.10, 'entregue',     NULL),
(11, 11, 11, 42.00, 8.00, 2.10, 0.00,  52.10, 'entregue',     'Extra ovo cozido'),
(12, 13, 13, 32.00, 5.00, 1.60, 0.00,  38.60, 'entregue',     NULL),
(13, 3,  7,  93.00, 12.00,4.65, 0.00, 109.65, 'em_preparo',   'Alergia a camarão'),
(14, 14, 15, 38.00, 8.00, 1.90, 0.00,  47.90, 'saiu_entrega', NULL),
(15, 7,  17, 30.00, 5.00, 1.50, 0.00,  36.50, 'confirmado',   NULL),
(16, 8,  NULL,18.00,5.00, 0.90, 0.00,  23.90, 'pendente',     NULL),
(17, 5,  NULL,73.80, 8.00,3.69, 0.00,  85.49, 'pendente',     'Sem glúten se possível'),
(18, 9,  NULL,50.80, 5.00,2.54, 0.00,  58.34, 'cancelado',    'Pedido duplicado'),
(19, 2,  NULL,49.90, 8.00,2.50,10.00,  70.40, 'cancelado',    'Restaurante fechado'),
(20, 4,  14, 169.80,15.00,8.49, 0.00, 193.29, 'saiu_entrega', 'Aniversário, favor caprichar');


-- =============================================================
-- 7. ITENS DO PEDIDO (20+ registros)
-- =============================================================
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal) VALUES
-- Pedido 1: Smash Burger + Batata
(1,  1,  1, 32.90, 32.90),
(1,  2,  1, 16.90, 16.90),
-- Pedido 2: Pizza Margherita
(2,  4,  1, 49.90, 49.90),
-- Pedido 3: Combo Sushi 20 peças
(3,  7,  1, 65.00, 65.00),
-- Pedido 4: Picanha
(4,  9,  1, 79.90, 79.90),
-- Pedido 5: Lasanha
(5,  11, 1, 38.90, 38.90),
-- Pedido 6: X-Burgão
(6,  15, 1, 27.90, 27.90),
-- Pedido 7: Tapioca frango + Tapioca doce
(7,  13, 1, 18.00, 18.00),
(7,  14, 1, 12.00, 12.00),
-- Pedido 8: Smash Burger
(8,  1,  1, 32.90, 32.90),
-- Pedido 9: 2x Pizza Pepperoni
(9,  5,  1, 54.90, 54.90),
(9,  4,  1, 49.90, 49.90),  -- segundo sabor = Margherita
-- Pedido 10: Açaí 500ml
(10, 17, 1, 22.00, 22.00),
-- Pedido 11: Ramen
(11, 19, 1, 42.00, 42.00),
-- Pedido 12: Prato Vegano
(12, 18, 1, 32.00, 32.00),
-- Pedido 13: Combo Sushi + Temaki
(13, 7,  1, 65.00, 65.00),
(13, 8,  1, 28.00, 28.00),
-- Pedido 14: Poke Bowl
(14, 20, 1, 38.00, 38.00),
-- Pedido 15: Tapioca de Frango x2
(15, 13, 2, 18.00, 36.00),  -- quantidade 2
-- Pedido 16: Tapioca Doce
(16, 14, 1, 12.00, 12.00),
-- Pedido 17: Lasanha + Fettuccine
(17, 11, 1, 38.90, 38.90),
(17, 12, 1, 34.90, 34.90),
-- Pedido 18: X-Burgão + Cachorro-Quente + Batata
(18, 15, 1, 27.90, 27.90),
(18, 16, 1, 22.90, 22.90),
-- Pedido 19: Pizza Pepperoni
(19, 5,  1, 49.90, 49.90),
-- Pedido 20: 2x Picanha + Costela
(20, 9,  1, 79.90, 79.90),
(20, 10, 1, 89.90, 89.90);


-- =============================================================
-- 8. FAQ E RECLAMAÇÕES (20 registros)
-- =============================================================
INSERT INTO faq_reclamacoes (id_cliente, id_pedido, tipo, assunto, descricao, resposta, status) VALUES
(NULL, NULL, 'faq',        'Como faço para cadastrar?',           'Quero saber como criar minha conta no sistema.', 'Acesse o app, clique em Criar Conta e preencha seus dados.', 'resolvido'),
(NULL, NULL, 'faq',        'Quais são as formas de pagamento?',   'Quais meios de pagamento são aceitos?',           'Aceitamos cartão de crédito, débito e Pix.',               'resolvido'),
(NULL, NULL, 'faq',        'Como acompanhar meu pedido?',         'Quero saber em que etapa está minha entrega.',    'Acompanhe pelo aplicativo na seção Meus Pedidos.',         'resolvido'),
(1,    1,    'elogio',     'Entrega muito rápida!',               'O pedido chegou antes do previsto. Parabéns!',    'Obrigado pelo elogio!',                                   'fechado'),
(2,    2,    'reclamacao', 'Pizza chegou fria',                   'A pizza estava fria ao chegar na minha casa.',    'Pedimos desculpas. Reembolso processado.',                 'resolvido'),
(3,    3,    'reclamacao', 'Sushi com item faltando',             'Vieram apenas 18 peças, faltaram 2.',             'Identificamos o erro. Crédito adicionado à conta.',        'resolvido'),
(4,    4,    'elogio',     'Carne excelente!',                    'A picanha estava no ponto perfeito. Adorei!',     'Ficamos felizes com seu retorno!',                         'fechado'),
(5,    5,    'sugestao',   'Opção de lasanha sem glúten',         'Seria ótimo ter opção sem glúten no cardápio.',   'Sugestão encaminhada ao restaurante parceiro.',            'em_analise'),
(6,    6,    'reclamacao', 'Hambúrguer errado entregue',          'Recebi um hambúrguer diferente do que pedi.',     'Erro confirmado, novo pedido enviado sem custo.',          'resolvido'),
(7,    7,    'elogio',     'Melhor tapioca da cidade!',           'Nunca comi uma tapioca tão gostosa.',             'Agradecemos seu carinho!',                                 'fechado'),
(8,    8,    'reclamacao', 'Batata veio mole',                    'As batatas fritas chegaram moles e sem crocância.','Analisaremos o prazo de entrega nessa região.',           'em_analise'),
(9,    9,    'sugestao',   'Quero metade a metade',               'Gostaria de pedir pizza meio a meio pelo app.',   'Funcionalidade em desenvolvimento.',                       'em_analise'),
(10,   10,   'elogio',     'Açaí muito saboroso',                 'O açaí é autêntico e chegou na temperatura certa.','Fico feliz em ouvir isso, obrigado!',                    'fechado'),
(11,   11,   'reclamacao', 'Ovo do ramen faltou',                 'Pedi com ovo extra mas não veio.',                'Crédito de R$ 3,00 adicionado à sua carteira.',            'resolvido'),
(12,   12,   'elogio',     'Prato vegano delicioso',              'Ótima iniciativa e sabor incrível.',              'Obrigado pelo apoio à alimentação saudável!',               'fechado'),
(13,   NULL, 'faq',        'Como cancelar um pedido?',            'Posso cancelar após confirmar o pedido?',         'Sim, mas taxas de cancelamento podem ser aplicadas.',      'resolvido'),
(14,   14,   'reclamacao', 'Entregador demorou muito',            'O entregador levou mais de 1h para chegar.',      'Pedimos desculpas pelo inconveniente. Avaliação em curso.','em_analise'),
(15,   15,   'sugestao',   'App para iOS',                        'Quando teremos o aplicativo para iPhone?',        'Versão iOS prevista para o próximo trimestre.',            'em_analise'),
(NULL, NULL, 'faq',        'Tem programa de fidelidade?',         'Existem pontos ou recompensas para clientes?',   'Em breve lançaremos o programa Delivery+.',                'aberto'),
(20,   20,   'elogio',     'Pedido de aniversário perfeito!',     'Tudo chegou certinho para a festa. Obrigado!',    'Parabéns pelo aniversário! Fico feliz que aprovaram!',     'fechado');


-- =============================================================
-- 9. HISTÓRICO DE PEDIDOS — Auditoria (20 registros manuais)
--    Na produção, o trigger tg_auditoria_pedido popula esta tabela.
--    Estes inserts simulam o histórico inicial para testes.
-- =============================================================
INSERT INTO historico_pedidos (id_pedido, id_cliente, id_restaurante, id_entregador, valor_subtotal, taxa_entrega, taxa_servico, valor_total, status, observacao, operacao) VALUES
(1,  1,  1,  1,  49.80, 5.00, 2.49,  57.29, 'pendente',     'Sem cebola no burguer',          'INSERT'),
(1,  1,  1,  1,  49.80, 5.00, 2.49,  57.29, 'confirmado',   'Sem cebola no burguer',          'UPDATE'),
(1,  1,  1,  1,  49.80, 5.00, 2.49,  57.29, 'em_preparo',   'Sem cebola no burguer',          'UPDATE'),
(1,  1,  1,  1,  49.80, 5.00, 2.49,  57.29, 'saiu_entrega', 'Sem cebola no burguer',          'UPDATE'),
(1,  1,  1,  1,  49.80, 5.00, 2.49,  57.29, 'entregue',     'Sem cebola no burguer',          'UPDATE'),
(2,  2,  2,  3,  49.90, 8.00, 2.50,  60.40, 'pendente',     NULL,                             'INSERT'),
(2,  2,  2,  3,  49.90, 8.00, 2.50,  60.40, 'entregue',     NULL,                             'UPDATE'),
(3,  3,  3,  7,  65.00,12.00, 3.25,  80.25, 'pendente',     'Entregar na portaria',           'INSERT'),
(3,  3,  3,  7,  65.00,12.00, 3.25,  80.25, 'entregue',     'Entregar na portaria',           'UPDATE'),
(18, 18, 9,  NULL,50.80, 5.00, 2.54, 58.34, 'pendente',     'Pedido duplicado',               'INSERT'),
(18, 18, 9,  NULL,50.80, 5.00, 2.54, 58.34, 'cancelado',    'Pedido duplicado',               'UPDATE'),
(19, 19, 2,  NULL,49.90, 8.00, 2.50, 70.40, 'pendente',     'Restaurante fechado',            'INSERT'),
(19, 19, 2,  NULL,49.90, 8.00, 2.50, 70.40, 'cancelado',    'Restaurante fechado',            'UPDATE'),
(13, 13, 3,  7,  93.00,12.00, 4.65, 109.65, 'pendente',     'Alergia a camarão',              'INSERT'),
(13, 13, 3,  7,  93.00,12.00, 4.65, 109.65, 'confirmado',   'Alergia a camarão',              'UPDATE'),
(13, 13, 3,  7,  93.00,12.00, 4.65, 109.65, 'em_preparo',   'Alergia a camarão',              'UPDATE'),
(20, 20, 4,  14,169.80,15.00, 8.49, 193.29, 'pendente',     'Aniversário, favor caprichar',   'INSERT'),
(20, 20, 4,  14,169.80,15.00, 8.49, 193.29, 'confirmado',   'Aniversário, favor caprichar',   'UPDATE'),
(20, 20, 4,  14,169.80,15.00, 8.49, 193.29, 'em_preparo',   'Aniversário, favor caprichar',   'UPDATE'),
(20, 20, 4,  14,169.80,15.00, 8.49, 193.29, 'saiu_entrega', 'Aniversário, favor caprichar',   'UPDATE');