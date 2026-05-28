# ProjetoDeliveryBDII

# 🚴‍♂️ Ecossistema de Delivery - Desenvolvimento de Banco de Dados Relacional com MySQL

[![MySQL Version](https://img.shields.io/badge/MySQL-8.0%2B-blue?logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Database Architecture](https://img.shields.io/badge/Architecture-Relational-orange)](#)
[![Status](https://img.shields.io/badge/Status-Conclu%C3%ADdo-brightgreen)](#)

Este repositório contém o projeto prático de desenvolvimento de um banco de dados relacional robusto e de alta complexidade voltado para um **Ecossistema de Delivery** (gerenciamento de múltiplos restaurantes, clientes e entregadores). O projeto foi desenvolvido como requisito para a disciplina de Banco de Dados II do **CEUB**.

O principal objetivo é aplicar conceitos avançados de modelagem de dados, normalização e programação em banco de dados utilizando **Stored Procedures, Functions, Triggers e Views** em um cenário real de alta escalabilidade e integridade de dados.

---

## 📌 Escopo do Sistema e Requisitos

### 🔹 Requisitos Funcionais (RF)
* **RF01 (Cadastro de Usuários):** Cadastro completo de usuários (Clientes).
* **RF02 (Cadastro de Entregadores):** Registro de entregadores parceiros contendo dados detalhados do veículo.
* **RF03 (Gestão de Restaurantes e Cardápios):** Controle e administração de estabelecimentos parceiros e de seus respectivos produtos.
* **RF04 (Controle de Estoque):** Gerenciamento em tempo real do estoque de itens dos restaurantes.
* **RF05 (Processamento de Pedidos):** Fluxo completo de criação, processamento de pedidos e seus respectivos itens vinculados.
* **RF06 (Gestão de Taxas):** Controle automatizado de taxas de entrega, serviço e regras/políticas para cancelamento.
* **RF07 (SAC - FAQ e Reclamações):** Sistema integrado de atendimento ao cliente, dúvidas frequentes e central de suporte.
* **RF08 (Rastreamento de Entrega):** Atualização dinâmica e monitoramento do status de entrega do pedido.

### 🔸 Requisitos Não Funcionais (RNF)
* **RNF01:** Implementação nativa utilizando o SGBD **MySQL 8.0+**.
* **RNF02:** Segurança e privacidade: as senhas de acessos dos usuários são armazenadas de forma **criptografada**.
* **RNF03:** Garantia de integridade referencial estrita por meio do uso correto de **Foreign Keys (FKs)**.
* **RNF04:** Otimização de performance de consultas complexas por região e por data via criação de **índices**.
* **RNF05:** Rastreabilidade corporativa e auditoria de alterações críticas em pedidos (Histórico).

---

## 🛠️ Objetivos de Banco de Dados Desenvolvidos

A inteligência de regras de negócio e as validações foram automatizadas diretamente na camada de banco de dados por meio dos seguintes objetos:

### ⚙️ Functions (Funções)
* `fn_formatarCPF`: Recebe uma cadeia de caracteres numéricos e retorna formatada no padrão máscara `000.000.000-00`.
* `fn_formatarCNPJ`: Recebe uma cadeia de caracteres numéricos e retorna formatada no padrão máscara `00.000.000/0000-00`.
* `fn_validarSenha`: Avalia a complexidade interna e verifica os critérios mínimos de força da senha informada.
* `fn_encriptarSenha`: Utiliza algoritmo robusto de hash para proteger e salvar de forma segura as senhas de usuários.

### ⚡ Procedures (Procedimentos Armazenados)
* `sp_cadastrarPedido`: Realiza a verificação de estoque físico do item, efetua o cálculo do valor total somado às taxas incidentes e realiza a inserção segura do registro.
* `sp_cadastrarCliente`: Insere novos clientes invocando nativamente as funções internas de validação e criptografia hash.
* `sp_cadastrarEntregador`: Efetua o cadastro de novos parceiros aplicando rotinas de formatação automática de documentos.
* `sp_cadastrarProduto`: Valida a integridade de faixas de preços e restrições obrigatórias de categorias.

### 📊 View (Visão)
* `vw_relatorio_regional`: Visão consolidada para fins gerenciais. Apresenta os pedidos agregados e filtrados por: *Região do Restaurante*, *Período*, *Tipo de Item* e *Valor Total*.

### 🛡️ Trigger (Gatilho)
* `tg_auditoria_pedido`: Disparada de forma automatizada (`AFTER INSERT`) toda vez que um novo pedido entra no sistema, gravando um "espelho" completo e imutável do registro na tabela `historico_pedidos` para fins de auditoria e rastreabilidade.

---

## 📂 Estrutura de Pastas e Organização

Para garantir uma organização profissional alinhada às melhores práticas exigidas, o repositório está estruturado da seguinte forma:

```text
/projeto-final-delivery
├── /docs          # Relatório Técnico (PDF) e Modelos (Imagens/Arquivos Case)
├── /scripts
│   ├── 01_ddl_schema.sql       # Criação de tabelas, relacionamentos e índices
│   ├── 02_dml_inserts.sql      # Carga de dados (mínimo de 20 inserts por tabela)
│   ├── 03_functions.sql        # Todas as funções desenvolvidas
│   ├── 04_procedures.sql       # Todas as stored procedures criadas
│   ├── 05_triggers.sql         # Definição do trigger de auditoria
│   └── 06_views_queries.sql    # Criação da View e scripts de testes de Update/Delete
└── README.md
