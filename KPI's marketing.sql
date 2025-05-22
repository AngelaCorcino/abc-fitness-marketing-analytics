SELECT * FROM marketing_investment
SELECT * FROM abc_fitness_campanhas
SELECT * FROM abc_fitness_vendas

--Total investido por canal
SELECT 
  canal, RIGHT(mês,2) AS mes,
  ROUND(SUM(investimento), 2) AS investimento_total
FROM marketing_investment
WHERE RIGHT(mês,2) ='05'
GROUP BY canal,mês
ORDER BY investimento_total DESC;


--CAC (Custo por aquisição de cliente)
SELECT 
  i.canal,
  ROUND(SUM(i.investimento), 2) AS total_investido,
  COUNT(DISTINCT CASE WHEN c.resultado = 'Conversão' THEN v.cliente_id END) AS total_convertido,
  ROUND(
    SUM(i.investimento) / NULLIF(COUNT(DISTINCT CASE WHEN c.resultado = 'Conversão' THEN v.cliente_id END), 0),
    2
  ) AS CAC
FROM marketing_investment AS i
JOIN abc_fitness_campanhas AS c
  ON i.campanha_id = c.campanha_id
JOIN abc_fitness_vendas AS v
  ON c.cliente_id = v.cliente_id
WHERE c.resultado = 'Conversão'
  AND YEAR(c.data_interacao) = YEAR(CAST(i.mês + '-01' AS DATE))
  AND MONTH(c.data_interacao) = MONTH(CAST(i.mês + '-01' AS DATE))
GROUP BY i.canal
ORDER BY CAC DESC;


--CAC utilizando CTE para otimização e legibilidade.

WITH clientes_convertidos AS (
  SELECT DISTINCT c.cliente_id, c.resultado, c.data_interacao, c.campanha_id
  FROM abc_fitness_campanhas c
  WHERE c.resultado = 'Conversão'
),

investimentos_por_campanha AS (
  SELECT i.campanha_id, i.canal, i.investimento, i.mês
  FROM marketing_investment i
)

SELECT
  i.canal,
  ROUND(SUM(i.investimento), 2) AS total_investido,
  COUNT(DISTINCT cc.cliente_id) AS total_convertido,
  ROUND(
    SUM(i.investimento) / NULLIF(COUNT(DISTINCT cc.cliente_id), 0),
    2
  ) AS CAC
FROM investimentos_por_campanha i
LEFT JOIN clientes_convertidos cc
  ON i.campanha_id = cc.campanha_id
  AND YEAR(cc.data_interacao) = YEAR(CAST(i.mês +'-01' AS DATE))
  AND MONTH(cc.data_interacao) = MONTH(CAST(i.mês+'-01' AS DATE))
GROUP BY i.canal
ORDER BY CAC DESC;


-- ROI (Return on Investment) Quanto de retorno (receita) foi obtido para cada real investido em marketing

SELECT 
  i.canal,
  ROUND(SUM(v.valor), 2) AS receita_total,
  ROUND(SUM(i.investimento), 2) AS investimento_total,
  ROUND((SUM(v.valor) - SUM(i.investimento)) / NULLIF(SUM(i.investimento), 0), 2) AS ROI
FROM abc_fitness_vendas AS v
JOIN abc_fitness_campanhas AS c
  ON v.cliente_id = c.cliente_id
JOIN marketing_investment AS i
  ON c.campanha_id = i.campanha_id
GROUP BY i.canal
ORDER BY ROI DESC;

-- LTV (Life Time Value) Valor médio que cada cliente gera em receita ao longo do seu ciclo de vida.

SELECT 
  i.canal,
  COUNT(DISTINCT v.cliente_id) AS total_clientes,
  ROUND(SUM(v.valor), 2) AS receita_total,
  ROUND(SUM(v.valor) / NULLIF(COUNT(DISTINCT v.cliente_id), 0), 2) AS LTV
FROM abc_fitness_vendas AS v
JOIN abc_fitness_campanhas AS c
  ON v.cliente_id = c.cliente_id
JOIN marketing_investment AS i
  ON c.campanha_id = i.campanha_id
GROUP BY i.canal
ORDER BY LTV DESC;