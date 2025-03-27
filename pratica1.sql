-- Questão 2. A)
CREATE ROLE programadores 
GRANT SELECT, UPDATE, DELETE ON ALL TABLES IN SCHEMA northwind TO programadores

-- Questão 2.B)
CREATE ROLE gerente

-- Questao 3.A)
CREATE USER pedro WITH PASSWORD '1234'
