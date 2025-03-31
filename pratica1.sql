--Questão 1: Restaure o banco de dados Northwind.

--Questão 2: Seguindo as boas práticas de segurança, você deve criar perfis de usuário
--no banco e posteriormente adicionar usuários a esses perfis
    --a) Crie uma role chamada ‘programadores’, com o privilégio de CRUD em todas as
    --tabelas do banco.
    CREATE ROLE programadores
    GRANT SELECT, UPDATE, DELETE ON ALL TABLES IN SCHEMA northwind TO programadores

    --b) Crie uma role chamada ‘gerente’. Daremos privilégios para essa role nas
    --próximas questões.
    CREATE ROLE gerente

--Questão 3 : Criação de usuário no banco de dados
    --a) Crie um usuário com seu nome no banco de dados Northwind
    CREATE USER pedro WITH PASSWORD '1234'

    --b) Faça login com esse novo usuário
    --c) Simule falhas de conexão
    --d) Verifique os privilégios do usuário


--Questão 4: Concedendo privilégios ao usuário.
    --a) Considere que o usuário que você criou na questão 3 é um usuário do tipo
    --‘programador’. Insira ele na role criada na questão 2.
    --b) Verifique o que é possível realizar no banco
    --c) Simule falhas associadas a falta de privilégios por esse usuário.

-- Questão 5: Removendo privilégios do usuário.
    -- a) Remova da role ‘programadores’ o privilégio de realizar ‘delete’ na tabela
    -- ‘Categories’.
    -- b) Teste a remoção do privilégio.

--Questão 6 : É possível conceder privilégios sobre Views. A associação dos comandos
--GRANT e VIEW permite que se limite o acesso de registros a usuários (e não apenas a
--nível de coluna, como no GRANT). É possível também permitir que usuários tenham
--acesso apenas a relatórios. Testaremos essa funcionalidade nessa questão
--    a) Crie uma view chamada ‘relatorio’, sobre as tabelas Orders e OrderDetails, cujo
--    resultado seja idêntico à figura 1. Onde:
--        • Total_produtos é a total de produtos comprados no pedido
--        • Total_pedido é a soma dos valores de todos os produtos comprados
--    b. Conceda o privilégio de leitura sobre a View para a role ‘gerente’.
--    c. Crie o usuário ‘gestor’ e adicione ele na role
--    d. Teste os privilégios do usuário gestor no banco de dados.


