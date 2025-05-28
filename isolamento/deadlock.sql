SELECT * FROM northwind.categories;

SELECT * FROM northwind.products WHERE productid=10; 

--TRANSAÇÃO 1 (T1)
START TRANSACTION
-- Primeiro
UPDATE northwind.categories SET description= 'concorrência ativa' WHERE categoryid = 2;
-- Terceiro
UPDATE northwind.products SET productname = 'mudanca produto' WHERE productid=10; -- gera o bloqueio (aresta de T1 para T2)
COMMIT
ROLLBACK


--TRANSAÇÃO 2 (T2)
START TRANSACTION
-- Segundo
UPDATE northwind.products SET productname = 'deadlock teste 2' WHERE productid=10;
-- Quarto
UPDATE northwind.categories SET description= 'concorrência ativa teste 2' WHERE categoryid = 2; -- gera o deadlock (aresta de T2 para T1 formando o cilclo)
COMMIT
ROLLBACK