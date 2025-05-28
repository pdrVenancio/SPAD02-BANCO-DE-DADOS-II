SELECT * FROM northwind.categories;

SELECT * FROM northwind.products WHERE productid=10; 

--TRANSAÇÃO 1
START TRANSACTION
UPDATE northwind.categories SET description= 'concorrência ativa' WHERE categoryid = 2;
UPDATE northwind.products SET productname = 'mudanca produto' WHERE productid=10;
COMMIT
ROLLBACK


--TRANSAÇÃO 2
START TRANSACTION
UPDATE northwind.products SET productname = 'deadlock teste 2' WHERE productid=10;
UPDATE northwind.categories SET description= 'concorrência ativa teste 2' WHERE categoryid = 2;
COMMIT
ROLLBACK