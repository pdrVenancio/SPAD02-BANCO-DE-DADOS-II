-- Nome: Pedro Venâncio dos Santos
-- Matricula: 2023010066

-- Questão 1: Considere o modelo abaixo.
--     a) Implemente o modelo no banco de dados PostgreSQL, considerando os
--     conceitos de banco objeto-relacional.

        -- Enum para número de eixos
        CREATE TYPE eixo_enum AS ENUM ('1', '2', '3', '4', '5', '6+');

        -- Tipo composto para endereço
        CREATE TYPE t_endereco AS (
            rua TEXT,
            numero INTEGER,
            cidade TEXT,
            estado CHAR(2),
            cep CHAR(8)
        );

        CREATE TABLE Cliente (
            cpf VARCHAR(11) PRIMARY KEY,
            nome VARCHAR(100),
            endereco t_endereco,
            telefone VARCHAR[] -- array de telefones
        );

        CREATE TABLE Financiamento (
            numero SERIAL PRIMARY KEY,
            cpf_cliente VARCHAR(11) REFERENCES Cliente(cpf),
            data DATE,
            valor NUMERIC,
            prazo INTEGER
        );

        CREATE TABLE Veiculo (
            num_renavam INT PRIMARY KEY,
            valor REAL,
            marca VARCHAR(20),
            financiamento_id INT UNIQUE REFERENCES Financiamento(numero) -- cada veículo só pode estar em um financiamento
        );

        CREATE TABLE Passageiro (
            qtd_passageiro SMALLINT
        ) INHERITS (Veiculo);


        CREATE TABLE Carga (
            carga_maxima INT,
            numero_eixo eixo_enum
        ) INHERITS (Veiculo);

--     b) Insira, ao menos, dez registros em cada tabela.

        INSERT INTO Cliente (cpf, nome, endereco, telefone) VALUES
        ('11111111111', 'Cliente A', ROW('Rua A', 1, 'Cidade A', 'MG', '12345678'), ARRAY['31988888888']),
        ('22222222222', 'Cliente B', ROW('Rua B', 2, 'Cidade B', 'SP', '87654321'), ARRAY['11999999999']),
        ('33333333333', 'Cliente C', ROW('Rua C', 3, 'Cidade C', 'RJ', '11223344'), ARRAY['21999999999']),
        ('44444444444', 'Cliente D', ROW('Rua D', 4, 'Cidade D', 'RS', '55667788'), ARRAY['51999999999']),
        ('55555555555', 'Cliente E', ROW('Rua E', 5, 'Cidade E', 'BA', '99887766'), ARRAY['71999999999']),
        ('66666666666', 'Cliente F', ROW('Rua F', 6, 'Cidade F', 'PE', '33445566'), ARRAY['81999999999']),
        ('77777777777', 'Cliente G', ROW('Rua G', 7, 'Cidade G', 'CE', '77889900'), ARRAY['88999999999']),
        ('88888888888', 'Cliente H', ROW('Rua H', 8, 'Cidade H', 'GO', '11221122'), ARRAY['62999999999']),
        ('99999999999', 'Cliente I', ROW('Rua I', 9, 'Cidade I', 'AM', '55664433'), ARRAY['92999999999']),
        ('00000000000', 'Cliente J', ROW('Rua J', 10, 'Cidade J', 'PA', '66554433'), ARRAY['91999999999']);

        INSERT INTO Financiamento (cpf_cliente, data, valor, prazo) VALUES
        ('11111111111', '2024-01-01', 10000, 12),
        ('11111111111', '2024-02-01', 15000, 18),
        ('22222222222', '2024-03-01', 20000, 24),
        ('33333333333', '2024-04-01', 18000, 36),
        ('44444444444', '2024-05-01', 22000, 48),
        ('55555555555', '2024-06-01', 25000, 60),
        ('66666666666', '2024-07-01', 30000, 24),
        ('77777777777', '2024-08-01', 12000, 12),
        ('88888888888', '2024-09-01', 16000, 18),
        ('99999999999', '2024-10-01', 14000, 24);

        INSERT INTO Passageiro (num_renavam, valor, marca, financiamento_id, qtd_passageiro) VALUES
        (1001, 25000, 'Fiat', 1, 5),
        (1002, 27000, 'Chevrolet', 2, 5),
        (1003, 30000, 'Ford', 3, 4),
        (1004, 22000, 'VW', 4, 5),
        (1005, 18000, 'Hyundai', 5, 5);

        INSERT INTO Carga (num_renavam, valor, marca, financiamento_id, carga_maxima, numero_eixo) VALUES
        (2001, 80000, 'Scania', 6, 20000, '4'),
        (2002, 70000, 'Volvo', 7, 18000, '3'),
        (2003, 90000, 'Mercedes', 8, 25000, '6+'),
        (2004, 85000, 'DAF', 9, 22000, '5'),
        (2005, 75000, 'Iveco', 10, 17000, '2');

--     c) Implemente a função realizaFinanciamento para o veículo de passeio e para o
--     veículo de carga, utilizando o conceito de polimorfismo.
        
        -- Para Passageiro
        CREATE OR REPLACE FUNCTION realizaFinanciamento(v Passageiro)
        RETURNS TEXT AS $$
        BEGIN
            RETURN 'Financiamento realizado para veículo de passeio RENAVAM ' || v.num_renavam;
        END;
        $$ LANGUAGE plpgsql;

        -- Para Carga
        CREATE OR REPLACE FUNCTION realizaFinanciamento(v Carga)
        RETURNS TEXT AS $$
        BEGIN
            RETURN 'Financiamento realizado para veículo de carga RENAVAM ' || v.num_renavam;
        END;
        $$ LANGUAGE plpgsql;

--     d) Realize um financiamento para um veículo de passeio e um para um veículo de
--     carga.
        -- Financiamento de veículo de passeio
        SELECT realizaFinanciamento(p.*) FROM Passageiro p WHERE num_renavam = 1001;

        -- Financiamento de veículo de carga
        SELECT realizaFinanciamento(c.*) FROM Carga c WHERE num_renavam = 2001;

--     e) Nos bancos objeto-relacionais, os relacionamentos 1:n podem ser modelados
--     como um dado complexo. Ou seja, a entidade 1 é inserida na entidade n como
--     um atributo. No modelo acima, o cliente poderia ter vários financiamentos.
--     Modele e implemente a tabela Cliente nesse contexto. Desconsidere a relação
--     de financiamento com veículo e realize as seguintes operações:
        CREATE TYPE t_financiamento AS (
            data DATE,
            valor NUMERIC,
            prazo INTEGER
        );

        CREATE TABLE ClienteComplexo (
            cpf VARCHAR(11) PRIMARY KEY,
            nome TEXT,
            financiamentos t_financiamento[]
        );

--         a. Inserir 2 financiamentos para o cliente X
            INSERT INTO ClienteComplexo (cpf, nome, financiamentos)
            VALUES ('12345678901', 'Cliente X', ARRAY[
                ROW('2025-01-01', 10000, 12)::t_financiamento,
                ROW('2025-02-01', 15000, 24)::t_financiamento
            ]);

--         b. Remover o primeiro financiamento do cliente X
            UPDATE ClienteComplexo
            SET financiamentos = ARRAY[financiamentos[2]]
            WHERE cpf = '12345678901';

--         c. Inserir um novo financiamento para o cliente X
            UPDATE ClienteComplexo
            SET financiamentos = financiamentos || ROW('2025-03-01', 20000, 36)::t_financiamento
            WHERE cpf = '12345678901';

--         d. Atualizar o valor do primeiro financiamento do cliente X em menos 30%
            UPDATE ClienteComplexo
            SET financiamentos[1] = ROW(
                financiamentos[1].data,
                financiamentos[1].valor * 0.7,
                financiamentos[1].prazo
            )::t_financiamento
            WHERE cpf = '12345678901';

--         e. Inserir um financiamento para o cliente Y
            INSERT INTO ClienteComplexo (cpf, nome, financiamentos)
            VALUES ('98765432100', 'Cliente Y', ARRAY[
                ROW('2025-04-01', 18000, 18)::t_financiamento
            ]);

--         f. Verificar, dentre os financiamentos dos clientes X e Y, qual o maior valor
            SELECT MAX((f).valor) AS maior_valor
            FROM (
                SELECT unnest(financiamentos) AS f
                FROM ClienteComplexo
                WHERE cpf IN ('12345678901', '98765432100')
            ) AS sub;
            
--         g. Verificar, dentre os financiamentos dos clientes X e Y, qual o menor prazo
            SELECT MIN((f).prazo) AS menor_prazo
            FROM (
                SELECT unnest(financiamentos) AS f
                FROM ClienteComplexo
                WHERE cpf IN ('12345678901', '98765432100')
            ) AS sub;
