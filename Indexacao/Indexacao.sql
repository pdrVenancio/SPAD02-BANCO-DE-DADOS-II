
-- Questão 1: Avaliar a relação entre o objeto criado no SGBD e os arquivos físicos.
    -- a)	Crie um novo banco de dados no servidor e avalie:
        CREATE DATABASE indexacao;
        show data_directory;

    -- b)	Crie uma tabela no banco e avalie:
        CREATE TABLE departamento(
            numeroDepto int,
            nomeDepto varchar(30) not null,
            primary key(numeroDepto)
        )

    -- c)	Insira registros na tabela e avalie:
        INSERT INTO departamento VALUES (1, 'Recursos Humanos');
        INSERT INTO departamento VALUES (2, 'Producao');
        INSERT INTO departamento VALUES (3, 'Financeiro');
        INSERT INTO departamento VALUES (4, 'Almoxarifado');

-- Questão 2: Testando o tipo HEAP FILE
    -- a)	O comando SELECT * retorna o dado da forma como ele está no disco
        SELECT * FROM departamento;

    -- b)	Qual o nome físico de cada registro?
        SELECT ctid, numerodepto, nomedepto FROM departamento;

    -- c)	Delete todos os registros da tabela departamento. Qual foi o efeito no arquivo físico? 
        SELECT ctid, * FROM northwind.order_details;
        
    -- d)	Reinsira os registros em nova ordem (2, 1, 4, 3).
        DELETE FROM departamento;

    -- e)	Reavalie os comandos executados na letra a e b.
        INSERT INTO departamento VALUES (2, 'Producao');
        INSERT INTO departamento VALUES (1, 'Recursos Humanos');
        INSERT INTO departamento VALUES (4, 'Almoxarifado');
        INSERT INTO departamento VALUES (3, 'Financeiro');

    -- f)	Repita o comando da letra b na tabela order_details do banco northwind.
        SELECT * FROM departamento;
        SELECT ctid, numerodepto, nomedepto FROM departamento;
