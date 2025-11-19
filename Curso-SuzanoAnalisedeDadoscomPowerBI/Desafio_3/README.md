# Suzano - Análise de Dados com Power BI
## Diagrama DER 

![DER BANCO ECOMMERCE_WJ](https://github.com/WiltonJackson/CursosDIO/blob/master/Curso-SuzanoAnalisedeDadoscomPowerBI/Desafio_3/imagens/Diagrama_ecommerce_wj_v1.png)  
O arquivo de script para criação do banco está no arquivo criar_banco.sql

### Querys usadas para persistir os dados

```sql
1. Produtos mais vendidos (ranking geral)

SELECT
    p.idProduto,
    p.nome,
    SUM(php.quantidade) AS total_vendido,
    FORMAT(SUM(php.quantidade * php.preco_unitario_vendido), 2) AS faturamento
FROM Produto_has_Pedido php
JOIN Produto p ON php.Produto_idProduto = p.idProduto
GROUP BY p.idProduto, p.nome
ORDER BY total_vendido DESC, faturamento DESC
LIMIT 15;
```
![Resultado ](https://github.com/WiltonJackson/CursosDIO/blob/master/Curso-SuzanoAnalisedeDadoscomPowerBI/Desafio_3/imagens/query_5.png)
```sql
2. Faturamento por mês (2025)
SELECT 
    DATE_FORMAT(data_pedido, '%Y-%m') AS mes,
    COUNT(*) AS total_pedidos,
    FORMAT(SUM(valor_total), 2) AS faturamento,
    FORMAT(AVG(valor_total), 2) AS ticket_medio
FROM Pedido
WHERE YEAR(data_pedido) = 2025
  AND status NOT IN ('Cancelado', 'Pendente')
GROUP BY DATE_FORMAT(data_pedido, '%Y-%m')
ORDER BY mes;
```
![Resultado ](https://github.com/WiltonJackson/CursosDIO/blob/master/Curso-SuzanoAnalisedeDadoscomPowerBI/Desafio_3/imagens/query_5.png)
```sql

3. Estoque baixo (precisa repor urgente)
SELECT 
    p.idProduto,
    p.nome,
    e.local,
    (ee.quantidade - ee.reserva) AS disponivel
FROM Em_estoque ee
JOIN Produto p ON ee.Produto_idProduto = p.idProduto
JOIN Estoque e ON ee.Estoque_idEstoque = e.idEstoque
WHERE (ee.quantidade - ee.reserva) <= 15
  AND p.ativo = TRUE
ORDER BY disponivel ASC;
```
![Resultado ](https://github.com/WiltonJackson/CursosDIO/blob/master/Curso-SuzanoAnalisedeDadoscomPowerBI/Desafio_3/imagens/query_5.png)
```sql
4. Pedidos pendentes (fila do estoque)
SELECT 
    p.idPedido,
    c.nome AS cliente,
    c.telefone,
    p.status,
    DATE(p.data_pedido) AS data_pedido,
    FORMAT(p.valor_total, 2) AS valor_total
FROM Pedido p
JOIN Cliente c ON p.idCliente = c.idCliente
WHERE p.status IN ('Pendente', 'Pago', 'Em separação')
ORDER BY 
    CASE p.status WHEN 'Em separação' THEN 1 WHEN 'Pago' THEN 2 ELSE 3 END,
    p.data_pedido ASC;

```
![Resultado ](https://github.com/WiltonJackson/CursosDIO/blob/master/Curso-SuzanoAnalisedeDadoscomPowerBI/Desafio_3/imagens/query_5.png)
```sql
5. Itens de um pedido específico
SELECT 
    p.nome,
    php.quantidade,
    FORMAT(php.preco_unitario_vendido, 2) AS preco_unitario,
    FORMAT(php.quantidade * php.preco_unitario_vendido, 2) AS subtotal
FROM Produto_has_Pedido php
JOIN Produto p ON php.Produto_idProduto = p.idProduto
WHERE php.Pedido_idPedido = 8;
```
![Resultado ](https://github.com/WiltonJackson/CursosDIO/blob/master/Curso-SuzanoAnalisedeDadoscomPowerBI/Desafio_3/imagens/query_5.png)
```sql
6. Margem de lucro por produto
SELECT 
    p.nome,
    FORMAT(phf.preco_custo, 2) AS custo,
    FORMAT(p.preco_venda, 2) AS venda,
    FORMAT(p.preco_venda - phf.preco_custo, 2) AS lucro_unitario,
    ROUND(((p.preco_venda - phf.preco_custo) / p.preco_venda) * 100, 2) AS margem_percent
FROM Produto p
JOIN Produto_has_Fornecedor phf ON p.idProduto = phf.Produto_idProduto
ORDER BY margem_percent DESC
LIMIT 20;
```
![Resultado ](https://github.com/WiltonJackson/CursosDIO/blob/master/Curso-SuzanoAnalisedeDadoscomPowerBI/Desafio_3/imagens/query_5.png)
```sql
7. Clientes que mais compram (fidelidade)
SELECT 
    c.nome,
    c.telefone,
    COUNT(p.idPedido) AS qtd_pedidos,
    FORMAT(SUM(p.valor_total), 2) AS total_gasto
FROM Cliente c
JOIN Pedido p ON c.idCliente = p.idCliente
WHERE p.status NOT IN ('Cancelado')
GROUP BY c.idCliente, c.nome, c.telefone
ORDER BY total_gasto DESC
LIMIT 15;
```
![Resultado ](https://github.com/WiltonJackson/CursosDIO/blob/master/Curso-SuzanoAnalisedeDadoscomPowerBI/Desafio_3/imagens/query_5.png)
```sql
8. Vendas por terceiro vendedor (marketplace)
SELECT 
    tv.nome_fantasia AS parceiro,
    COUNT(DISTINCT php.Pedido_idPedido) AS pedidos,
    FORMAT(SUM(php.quantidade * php.preco_unitario_vendido), 2) AS faturamento_bruto,
    FORMAT(SUM(php.quantidade * php.preco_unitario_vendido) * tv.comissao_percentual / 100, 2) AS comissao_devida
FROM Produto_has_Pedido php
JOIN Terceiro_Vendedor tv ON php.idTerceiro_Vendedor = tv.idTerceiro_Vendedor
GROUP BY tv.idTerceiro_Vendedor, tv.nome_fantasia, tv.comissao_percentual
ORDER BY faturamento_bruto DESC;
```
![Resultado ](https://github.com/WiltonJackson/CursosDIO/blob/master/Curso-SuzanoAnalisedeDadoscomPowerBI/Desafio_3/imagens/query_5.png)
```sql
9. Produtos ativos mas sem estoque
SELECT 
    p.idProduto,
    p.nome,
    p.preco_venda
FROM Produto p
LEFT JOIN Em_estoque ee ON p.idProduto = ee.Produto_idProduto
WHERE p.ativo = TRUE 
  AND ee.Produto_idProduto IS NULL;
```
![Resultado ](https://github.com/WiltonJackson/CursosDIO/blob/master/Curso-SuzanoAnalisedeDadoscomPowerBI/Desafio_3/imagens/query_5.png)
```sql
10. Dashboard rápido do mês atual
SELECT 'Faturamento Bruto' AS indicador, 
       FORMAT(COALESCE(SUM(valor_total), 0), 2) AS valor
FROM Pedido 
WHERE status NOT IN ('Cancelado', 'Pendente')
  AND MONTH(data_pedido) = MONTH(CURDATE())
  AND YEAR(data_pedido) = YEAR(CURDATE())

UNION ALL

SELECT 'Comissão Marketplace', 
       FORMAT(COALESCE(SUM(php.quantidade * php.preco_unitario_vendido) * tv.comissao_percentual / 100, 0), 2)
FROM Produto_has_Pedido php
JOIN Terceiro_Vendedor tv ON php.idTerceiro_Vendedor = tv.idTerceiro_Vendedor
JOIN Pedido pe ON php.Pedido_idPedido = pe.idPedido
WHERE pe.status NOT IN ('Cancelado', 'Pendente')
  AND MONTH(pe.data_pedido) = MONTH(CURDATE());
```
```
![Resultado ](https://github.com/WiltonJackson/CursosDIO/blob/master/Curso-SuzanoAnalisedeDadoscomPowerBI/Desafio_3/imagens/query_5.png)
```sql