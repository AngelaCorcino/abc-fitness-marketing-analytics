SELECT * FROM abc_fitness_campanhas

--Quais canais de aquisi��o geraram mais convers�es?

SELECT canal, COUNT(*) AS total_conversoes
FROM abc_fitness_campanhas
WHERE resultado	 = 'Convers�o'
GROUP BY canal
ORDER BY total_conversoes desc

--Qual a taxa de convers�o por canal? (N�mero de convers�es dividido pelo n�mero total de leads por canal)
SELECT canal,
ROUND (
COUNT(CASE WHEN resultado = 'Convers�o' THEN 1 END)*100.0 / COUNT(*),2) AS taxa_conversao
FROM abc_fitness_campanhas
GROUP BY canal
ORDER BY taxa_conversao DESC;

-- Quantidade de n�o convers�o por canal 
SELECT canal, COUNT(*) as nao_conversao
FROM abc_fitness_campanhas
WHERE resultado = 'ignorado'
GROUP BY canal

--Taxa de n�o convers�o
SELECT
  canal,
  ROUND(
    COUNT(CASE WHEN resultado <> 'Convers�o' THEN 100.0 END) * 100.0 / COUNT(*),
    2
  ) AS taxa_nao_conversao_percent
FROM abc_fitness_campanhas
GROUP BY canal
ORDER BY taxa_nao_conversao_percent ASC;

--CTR (Click Through Rate, ou Taxa de Cliques)
SELECT canal, 
	   ROUND(
			COUNT(CASE WHEN resultado ='Clique' THEN 1 END)*100.0 /
			NULLIF(COUNT(CASE WHEN resultado ='Visualiza��o' THEN 1 END),0),2) as CTR
FROM abc_fitness_campanhas
GROUP BY canal
ORDER BY CTR DESC;

SELECT 
    canal,
    COUNT(DISTINCT cliente_id) AS usuarios_atingidos,
    COUNT(CASE WHEN resultado = 'Visualiza��o' THEN 1 END) AS visualizacoes,
    COUNT(CASE WHEN resultado = 'Clique' THEN 1 END) AS cliques,
    ROUND(
        COUNT(CASE WHEN resultado = 'Clique' THEN 1 END) * 100.0 / 
        NULLIF(COUNT(CASE WHEN resultado = 'Visualiza��o' THEN 1 END), 0), 
    2) AS CTR
FROM abc_fitness_campanhas
GROUP BY canal;

