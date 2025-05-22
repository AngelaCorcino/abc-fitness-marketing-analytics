SELECT * FROM abc_fitness_campanhas

--Quais canais de aquisição geraram mais conversões?

SELECT canal, COUNT(*) AS total_conversoes
FROM abc_fitness_campanhas
WHERE resultado	 = 'Conversão'
GROUP BY canal
ORDER BY total_conversoes desc

--Qual a taxa de conversão por canal? (Número de conversões dividido pelo número total de leads por canal)
SELECT canal,
ROUND (
COUNT(CASE WHEN resultado = 'Conversão' THEN 1 END)*100.0 / COUNT(*),2) AS taxa_conversao
FROM abc_fitness_campanhas
GROUP BY canal
ORDER BY taxa_conversao DESC;

-- Quantidade de não conversão por canal 
SELECT canal, COUNT(*) as nao_conversao
FROM abc_fitness_campanhas
WHERE resultado = 'ignorado'
GROUP BY canal

--Taxa de não conversão
SELECT
  canal,
  ROUND(
    COUNT(CASE WHEN resultado <> 'Conversão' THEN 100.0 END) * 100.0 / COUNT(*),
    2
  ) AS taxa_nao_conversao_percent
FROM abc_fitness_campanhas
GROUP BY canal
ORDER BY taxa_nao_conversao_percent ASC;

--CTR (Click Through Rate, ou Taxa de Cliques)
SELECT canal, 
	   ROUND(
			COUNT(CASE WHEN resultado ='Clique' THEN 1 END)*100.0 /
			NULLIF(COUNT(CASE WHEN resultado ='Visualização' THEN 1 END),0),2) as CTR
FROM abc_fitness_campanhas
GROUP BY canal
ORDER BY CTR DESC;

SELECT 
    canal,
    COUNT(DISTINCT cliente_id) AS usuarios_atingidos,
    COUNT(CASE WHEN resultado = 'Visualização' THEN 1 END) AS visualizacoes,
    COUNT(CASE WHEN resultado = 'Clique' THEN 1 END) AS cliques,
    ROUND(
        COUNT(CASE WHEN resultado = 'Clique' THEN 1 END) * 100.0 / 
        NULLIF(COUNT(CASE WHEN resultado = 'Visualização' THEN 1 END), 0), 
    2) AS CTR
FROM abc_fitness_campanhas
GROUP BY canal;

