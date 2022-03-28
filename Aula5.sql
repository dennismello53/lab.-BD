CREATE DATABASE aula5
GO
USE aula5

-- 3) A partir das tabelas abaixo, fa�a:
-- Funcion�rio (C�digo, Nome, Sal�rio)
-- Dependendente (C�digo_Funcion�rio, Nome_Dependente, Sal�rio_Dependente)
CREATE TABLE funcionario (
codigo INT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
salario DECIMAL(7,2) NOT NULL
)

CREATE TABLE dependente (
codigo_funcionario INT NOT NULL, 
nome_dependente VARCHAR(100) NOT NULL,
salario_dependente DECIMAL(7,2) NOT NULL
FOREIGN KEY (codigo_funcionario) REFERENCES funcionario(codigo)
)
INSERT INTO funcionario VALUES (1, 'Jorge', 25.0)
INSERT INTO dependente VALUES (1, 'claudio', 40.0)


-- a) Uma Function que Retorne uma tabela:
-- (Nome_Funcion�rio, Nome_Dependente, Sal�rio_Funcion�rio, Sal�rio_Dependente)
CREATE FUNCTION fn_salarios()
RETURNS @table TABLE (
nome_funcionario VARCHAR(100),
nome_dependente VARCHAR(100),
salario_funcionario DECIMAL(7,2),
salario_dependente DECIMAL(7,2)
)
AS
BEGIN
	INSERT INTO @table 
		SELECT f.nome, d.nome_dependente, f.salario, d.salario_dependente
		FROM funcionario f, dependente d
		WHERE f.codigo = d.codigo_funcionario
	RETURN
END

SELECT * FROM fn_salarios()


-- b) Uma Scalar Function que Retorne a soma dos Sal�rios dos dependentes,
-- mais a do funcion�rio.
CREATE FUNCTION fn_somaSalario()
RETURNS DECIMAL(7,2)
AS
BEGIN
	DECLARE @soma	DECIMAL(7,2),
			@d_salario DECIMAL(7,2),
			@f_salario DECIMAL(7,2)
	
	SELECT @f_salario = f.salario, @d_salario = d.salario_dependente
	FROM funcionario f, dependente d
	WHERE f.codigo = d.codigo_funcionario
	
	SET @soma = @f_salario + @d_salario
	RETURN (@soma)
END

SELECT dbo.fn_somaSalario() AS Soma_Salarios


-------------------------------------------------------------------------
-- 4)A partir das tabelas abaixo, fa�a:
-- Cliente (CPF, nome, telefone, e-mail)
-- Produto (C�digo, nome, descri��o, valor_unit�rio)
-- Venda (CPF_Cliente, C�digo_Produto, Quantidade, Data(Formato DATE))

CREATE TABLE cliente (
cpf VARCHAR(11) PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
telefone VARCHAR(11) NOT NULL,
email VARCHAR(100) NOT NULL
)
INSERT INTO cliente VALUES ('123', 'Jorge', '9023', 'jorge@jorge.jorge')

CREATE TABLE produto (
codigo INT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
descricao VARCHAR(200) NOT NULL,
valor_unitario DECIMAL(7,2)
)
INSERT INTO produto VALUES (1, 'Teclado', 'Gamer', 500.0)

CREATE TABLE venda (
codigo_venda INT PRIMARY KEY,
cpf_cliente VARCHAR(11) NOT NULL,
codigo_produto INT NOT NULL,
quantidade INT NOT NULL,
data DATETIME NOT NULL
)
INSERT INTO venda VALUES (1, '123', 1, 3, '2020-09-10')

-- a) Uma Function que Retorne uma tabela:
-- (Nome_Cliente, Nome_Produto, Quantidade, Valor_Total)
CREATE FUNCTION fn_valorTotal()
RETURNS @table TABLE (
codigo_venda INT,
nome_cliente VARCHAR(100),
nome_produto VARCHAR(100),
quantidade INT,
valor_total DECIMAL(7,2)
)
AS
BEGIN
	INSERT INTO @table 
		SELECT v.codigo_venda, c.nome, p.nome, v.quantidade, (v.quantidade * p.valor_unitario) AS valor_total
		FROM venda v, cliente c, produto p 
		WHERE v.codigo_produto = p.codigo 
			AND c.cpf = v.cpf_cliente
		ORDER BY v.data DESC
	RETURN
END

SELECT * FROM fn_valorTotal()

-- b) Uma Scalar Function que Retorne a soma dos produtos comprados na �ltima Compra
CREATE FUNCTION fn_somaUltimaCompra()
RETURNS DECIMAL(7,2)
AS
BEGIN
	RETURN (
		SELECT SUM(f.valor_total) AS soma_total
		FROM fn_valorTotal() f, venda v
		WHERE f.codigo_venda = v.codigo_produto
	)
END
SELECT dbo.fn_somaUltimaCompra() AS Soma_Produtos
