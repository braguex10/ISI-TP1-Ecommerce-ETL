-- Consultas de verificação da base de dados SQLite gerada pelo workflow KNIME
-- Ficheiro: output/knime/ecommerce_knime.db

-- 1. Produtos e estado do stock
SELECT SKU, Nome_Produto, Categoria, Stock_Atual, estado_stock
FROM dim_produto
ORDER BY Stock_Atual;

-- 2. Alertas de stock (rutura ou crítico)
SELECT SKU, Nome_Produto, Stock_Atual, estado_stock
FROM dim_produto
WHERE estado_stock <> 'OK';

-- 3. Clientes com dados anonimizados (RGPD)
SELECT id_transacao, nome_anon, email_anon, nif_anon, telefone_anon, email_valido
FROM dim_cliente;

-- 4. Vendas válidas com margem e conversão de moeda (API Frankfurter)
SELECT id_transacao, sku, Categoria, quantidade, total_linha, margem, total_linha_usd, total_linha_gbp
FROM fact_vendas;

-- 5. Vendas rejeitadas (email inválido ou produto sem fornecedor)
SELECT id_transacao, sku, email_valido, fornecedor_nome
FROM vendas_rejeitadas;

-- 6. Resumo por categoria
SELECT * FROM resumo_categoria ORDER BY total_vendas DESC;

-- 7. Total geral de vendas válidas (esperado: 538.80 EUR)
SELECT ROUND(SUM(total_linha), 2) AS total_vendas_eur FROM fact_vendas;
