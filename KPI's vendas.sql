--Dataset Overview 
SELECT * FROM abc_fitness_vendas
ORDER BY data_venda;

-- Valor total de vendas por categoria
SELECT produto, sum(valor)
FROM abc_fitness_vendas
GROUP BY produto

--Qual ticket médio (valor médio de venda) por canal?

SELECT c.canal,Count(*) AS total_conversoes,AVG(v.valor) AS ticket_medio
FROM abc_fitness_campanhas as c
JOIN abc_fitness_vendas AS v
ON c.cliente_id = v.cliente_id
WHERE c.resultado = 'Conversão'
GROUP BY c.canal
ORDER BY total_conversoes DESC;

--RECEITA TOTAL
SELECT SUM(valor) AS receita_total
FROM abc_fitness_vendas

-- TOTAL CLIENTES
SELECT COUNT(DISTINCT(cliente_id)) AS clientes_unicos
FROM abc_fitness_vendas


