CREATE DATABASE aula4 
GO
USE aula4

CREATE TABLE produto (
codigo  INT				NOT NULL,
nome	VARCHAR(50)		NOT NULL,
valor	DECIMAL(7,2)	NOT NULL
PRIMARY KEY (codigo)
)

CREATE TABLE entrada (
codigo_transacao	INT				NOT NULL,
codigo_produto		INT				NOT NULL,
quantidade			INT				NOT NULL,
valor_total			DECIMAL(7,2)	NOT NULL
PRIMARY KEY (codigo_transacao),
FOREIGN KEY (codigo_produto) REFERENCES produto(codigo) 
)

CREATE TABLE saida (
codigo_transacao	INT				NOT NULL,
codigo_produto		INT				NOT NULL,
quantidade			INT				NOT NULL,
valor_total			DECIMAL(7,2)	NOT NULL
PRIMARY KEY (codigo_transacao),
FOREIGN KEY (codigo_produto) REFERENCES produto(codigo) 
)

INSERT INTO produto VALUES 
(1, 'Boneco Max Steel', 9.99),
(2, 'Boneco de Ação Genérico', 10.99),
(3, 'Boneco Barbie', 11.99),
(4, 'Boneco Zeca Urubu', 12.99),
(5, 'Boneco Naruto STEEL SERIES', 99.99)

/*
Cada produto que a empresa compra, entra na tabela ENTRADA. Cada produto que a empresa vende,
entra na tabela SAIDA.
- Criar uma procedure que receba um código (‘e’ para ENTRADA e ‘s’ para SAIDA),
- Criar uma exceção de erro para código inválido, 
- Receba o codigo_transacao, codigo_produto e a quantidade e 
- Preencha a tabela correta com o valor_total de cada transação de cada produto. 
*/

CREATE PROCEDURE sp_transacao(@codigo VARCHAR(5), @codigo_transacao INT, @codigo_produto INT,
	@quantidade INT) 
AS 
	DECLARE @valor_total AS DECIMAL(7,2),
			@query VARCHAR(MAX),
			@tabela	VARCHAR(7),
			@erro	VARCHAR(MAX)

	SET @valor_total = (SELECT valor FROM produto WHERE codigo = @codigo_produto) * @quantidade

	IF (LOWER(@codigo) = 'e')
	BEGIN
		SET @tabela = 'entrada'
	END
	ELSE
	BEGIN
		IF(LOWER(@codigo) = 's')
		BEGIN 
		SET @tabela = 'saida'
		END 
		ELSE 
		BEGIN
			RAISERROR('Código inválido', 16, 1)
		END 
	END

	BEGIN TRY
		SET @query = 'INSERT INTO '+@tabela+' VALUES (' + CAST(@codigo_transacao AS VARCHAR(5))
		+','+ CAST(@codigo_produto AS VARCHAR(5)) +','+ CAST(@quantidade AS VARCHAR(5)) +','+
		CAST(@valor_total AS VARCHAR(20))+')'
		EXEC (@query)
	END TRY
	BEGIN CATCH
		SET @erro = ERROR_MESSAGE()
		IF (@erro LIKE '%primary%')
		BEGIN
			RAISERROR('Código de transação duplicado', 16, 1)
		END
		ELSE
		BEGIN
			RAISERROR('Erro de processamento', 16, 1)
		END
	END CATCH


SELECT * FROM produto 
SELECT * FROM entrada
SELECT * FROM saida

--@codigo VARCHAR(5), @codigo_transacao INT, @codigo_produto INT, @quantidade INT
EXEC sp_transacao 'e', 1, 5, 5
EXEC sp_transacao 'e', 2, 1, 15
EXEC sp_transacao 'e', 3, 3, 3
EXEC sp_transacao 'e', 4, 2, 2
EXEC sp_transacao 'e', 5, 4, 25

EXEC sp_transacao 's', 1, 1, 7
EXEC sp_transacao 's', 2, 2, 1
EXEC sp_transacao 's', 3, 3, 3
EXEC sp_transacao 's', 4, 4, 24
EXEC sp_transacao 's', 5, 5, 4

EXEC sp_transacao 'j', 1, 1, 7
EXEC sp_transacao 'e', 1, 3, 3
