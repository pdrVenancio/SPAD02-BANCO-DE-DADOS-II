EXPLAIN ANALYZE
SELECT 
    bai_nu_sequencial_ini, 
    COUNT(bai_nu_sequencial_ini) 
FROM cep.log_logradouro 
WHERE ufe_sg = 'AC' and log_tipo_logradouro = 'Avenida'
GROUP BY bai_nu_sequencial_ini

-- QUERY PLAN
-- Finalize GroupAggregate  (cost=21559.04..21578.51 rows=165 width=12) (actual time=210.406..218.284 rows=59 loops=1)"
--   Group Key: bai_nu_sequencial_ini"
--   ->  Gather Merge  (cost=21559.04..21576.17 rows=138 width=12) (actual time=210.396..218.256 rows=72 loops=1)"
--         Workers Planned: 2"
--         Workers Launched: 2"
--         ->  Partial GroupAggregate  (cost=20559.01..20560.22 rows=69 width=12) (actual time=63.945..63.958 rows=24 loops=3)"
--               Group Key: bai_nu_sequencial_ini"
--               ->  Sort  (cost=20559.01..20559.19 rows=69 width=4) (actual time=63.938..63.941 rows=46 loops=3)"
--                     Sort Key: bai_nu_sequencial_ini"
--                     Sort Method: quicksort  Memory: 25kB"
--                     Worker 0:  Sort Method: quicksort  Memory: 25kB"
--                     Worker 1:  Sort Method: quicksort  Memory: 25kB"
--                     ->  Parallel Seq Scan on log_logradouro  (cost=0.00..20556.91 rows=69 width=4) (actual time=2.900..63.892 rows=46 loops=3)"
--                           Filter: (((ufe_sg)::text = 'AC'::text) AND ((log_tipo_logradouro)::text = 'Avenida'::text))"
--                           Rows Removed by Filter: 303149"
-- Planning Time: 1.344 ms"
-- Execution Time: 218.620 ms"

-- EXPLICAÇÃO

-- 1. Leitura paralela da tabela (Parallel Seq Scan)
--     - A tabela log_logradouro foi varrida por 3 processos (1 principal + 2 workers).
--     - Mais de 303 mil linhas foram lidas, mas apenas ~46 por worker foram aproveitadas após o filtro por ufe_sg = 'AC' e log_tipo_logradouro = 'Avenida'.

-- 2. Ordenação local por grupo
--     - Cada worker ordenou os dados pelo campo bai_nu_sequencial_ini para permitir o agrupamento parcial.

-- 3. Agregação parcial em paralelo (Partial GroupAggregate)
--     - Cada worker fez um COUNT() por grupo localmente.

-- 4. Combinação dos resultados (Gather Merge)
--     - Os resultados dos workers foram reunidos e ordenados novamente para serem agregados em definitivo.

-- 5. Agregação final (Finalize GroupAggregate)
--     - O PostgreSQL finalizou a contagem por grupo, totalizando 59 grupos distintos retornados.


EXPLAIN ANALYSE
SELECT * 
    FROM cep.log_bairro 
    WHERE bai_nu_sequencial IN(
        SELECT bai_nu_sequencial 
        FROM cep.log_faixa_bairro 
        WHERE fcb_rad_ini = '69918' 
    )

-- QUERY PLAN

-- Nested Loop  (cost=1857.10..1931.67 rows=9 width=38) (actual time=4.595..4.614 rows=21 loops=1)
--   ->  HashAggregate  (cost=1856.81..1856.90 rows=9 width=4) (actual time=4.575..4.578 rows=21 loops=1)
--         Group Key: log_faixa_bairro.bai_nu_sequencial
--         Batches: 1  Memory Usage: 24kB
--         ->  Seq Scan on log_faixa_bairro  (cost=0.00..1856.79 rows=9 width=4) (actual time=0.022..4.558 rows=21 loops=1)
--               Filter: ((fcb_rad_ini)::text = '69918'::text)
--               Rows Removed by Filter: 92202
--   ->  Index Scan using log_bairro_pkey on log_bairro  (cost=0.29..8.31 rows=1 width=38) (actual time=0.001..0.001 rows=1 loops=21)
--         Index Cond: (bai_nu_sequencial = log_faixa_bairro.bai_nu_sequencial)
-- Planning Time: 0.487 ms
-- Execution Time: 4.657 ms

-- EXPLICAÇÃO
-- A consulta realiza uma subconsulta com Seq Scan na tabela log_faixa_bairro, filtrando as linhas com fcb_rad_ini = '69918' (removendo ~92 mil linhas e mantendo 21).
-- Esses 21 valores distintos de bai_nu_sequencial são agregados com HashAggregate para eliminar duplicatas.
-- Em seguida, o PostgreSQL usa um Nested Loop para, para cada valor da subconsulta, buscar a linha correspondente em log_bairro usando o índice primário log_bairro_pkey.