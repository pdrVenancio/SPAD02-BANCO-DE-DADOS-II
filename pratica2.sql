--Questão 1: O banco de dados PostgreSQL é do tipo ‘objeto-relacional’. Isso significa que
--ele implementa conceitos da orientação objeto em seu modelo. Dessa forma, tabelas,
--roles, usuários, são objetos no banco e possuem ‘um dono’. Ou seja, quem criou aquele
--‘objeto’ tem direitos sobre ele. No caso dos comandos SQL GRANT e REVOKE, isso tem
--diversas implicações. Vamos testá-las nessa atividade.
--  a) Crie uma role, cujo perfil é de ‘DBA de Banco de Dados’. Ou seja, ela terá todos
--  os privilégios sobre o banco Northwind.
    CREATE ROLE DBA
    GRANT ALL ON ALL TABLES IN SCHEMA northwind TO DBA

--  b) Crie um usuário e associe ele a esse perfil.
    CREATE USER DBA_USER WITH PASSWORD '1234'
    GRANT DBA TO DBA_USER

--  c) Faça login no banco com o perfil criado e execute a seguinte operação no banco:
--  inserir uma coluna na tabela ‘categories’.
    ALTER TABLE northwind.categories
    ADD COLUMN DBA INT


--  d) Qual o resultado da operação executada na letra c?

--    ERRO:  permissão negada para esquema northwind
--    SQL state: 42501


--  e) Ainda logado como o usuário criado na letra b (que é um DBA), remova da role
--  ‘programadores’ o privilégio de realizar ‘delete’ na tabela ‘Orders.
    REVOKE DELETE ON northwind.orders FROM programadores

--  f) Qual o resultado da operação executada na letra e?

--  ERRO:  permissão negada para esquema northwind
--  SQL state: 42501

--Questão 2: Testando o ‘WITH GRANT OPTION’.
--    a) Crie um novo usuario no banco chamado ‘user1’ e dê a ele privilégios de CRUD
--    nas tabelas categories, customers e products. Utilize o ‘with grant option’.
--      a. Lembrem-se que essa não é uma boa prática de segurança! Estamos
--      utilizando apenas para testes!!!!
        CREATE USER User1 WITH PASSWORD '1234'
        GRANT USAGE, INSERT, UPDATE, DELETE ON northwind.customers, northwind.categories, northwind.products TO User1 WITH GRANT OPTION

--    b) Crie um novo usuario no banco chamado ‘user2’ e dê a ele privilégios de CRUD
--    nas tabelas orders e orderdetails. Utilize o ‘with grant option’.
        CREATE USER User2 WITH PASSWORD '1234'
        GRANT INSERT, UPDATE, DELETE ON northwind.orders, northwind.order_details TO User2 WITH GRANT OPTION

--    c) Crie um novo usuario no banco chamado ‘user3’ e dê a ele privilégios de SELECT
--    em todas as tabelas do schema northwind.
        CREATE USER User3 WITH PASSWORD '1234'
        GRANT USAGE, SELECT ON ALL TABLES IN SCHEMA northwind TO User3 WITH GRANT OPTION

--    d) Agora, o user1 vai repassar os privilégios dele para o user3.
--      Logado como User1

        GRANT INSERT, UPDATE, DELETE ON northwind.customers, northwind.categories, northwind.products TO User3

--    e) De forma análoga, o user2 repassará os privilégios dele para o user3.
--      Logado como User1

        GRANT INSERT, UPDATE, DELETE ON northwind.orders, northwind.order_details TO User3

--    f) Qual o efeito das operações executadas nas letras D e E no banco?

--      Os privilegios foram passados.

--    g) Logado como postgres, remova os privilégios no user3. O que acontece? Como
--    resolver?
        REVOKE ALL ON ALL TABLES IN SCHEMA northwind FROM User3
        SELECT * FROM information_schema.table_privileges

--      Ele vai revogar apenas os privilegios que o postegres deu grant  (SELECT) os previlegios herdados ainda vão se manter.
--      Tirar os  WITH GRANT OPTION dos User1 e User2 e revogar seus privilegios para ai sim tirar os privilegios do User3.