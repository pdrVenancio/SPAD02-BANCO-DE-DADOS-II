--Questão 1: O banco de dados PostgreSQL é do tipo ‘objeto-relacional’. Isso significa que
--ele implementa conceitos da orientação objeto em seu modelo. Dessa forma, tabelas,
--roles, usuários, são objetos no banco e possuem ‘um dono’. Ou seja, quem criou aquele
--‘objeto’ tem direitos sobre ele. No caso dos comandos SQL GRANT e REVOKE, isso tem
--diversas implicações. Vamos testá-las nessa atividade.
--  a) Crie uma role, cujo perfil é de ‘DBA de Banco de Dados’. Ou seja, ela terá todos
--  os privilégios sobre o banco Northwind.

--  b) Crie um usuário e associe ele a esse perfil.

--  c) Faça login no banco com o perfil criado e execute a seguinte operação no banco:
--  inserir uma coluna na tabela ‘categories’.


--  d) Qual o resultado da operação executada na letra c?
--  e) Ainda logado como o usuário criado na letra b (que é um DBA), remova da role
--  ‘programadores’ o privilégio de realizar ‘delete’ na tabela ‘Orders.

--  f) Qual o resultado da operação executada na letra e?
--
--Questão 2: Testando o ‘WITH GRANT OPTION’.
--    a) Crie um novo usuario no banco chamado ‘user1’ e dê a ele privilégios de CRUD
--    nas tabelas categories, customers e products. Utilize o ‘with grant option’.
--      a. Lembrem-se que essa não é uma boa prática de segurança! Estamos
--      utilizando apenas para testes!!!!
--    b) Crie um novo usuario no banco chamado ‘user2’ e dê a ele privilégios de CRUD
--    nas tabelas orders e orderdetails. Utilize o ‘with grant option’.

--    c) Crie um novo usuario no banco chamado ‘user3’ e dê a ele privilégios de SELECT
--    em todas as tabelas do schema northwind.

--    d) Agora, o user1 vai repassar os privilégios dele para o user3.

--    e) De forma análoga, o user2 repassará os privilégios dele para o user3.

--    f) Qual o efeito das operações executadas nas letras d e e no banco?

--    g) Logado como postgres, remova os privilégios no user3. O que acontece? Como
--    resolver?