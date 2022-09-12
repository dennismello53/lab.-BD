CREATE DATABASE querydinamica
GO
USE querydinamica
GO
CREATE TABLE produto(
idProduto INT NOT NULL,
tipo VARCHAR(100),
cor VARCHAR(50)
PRIMARY KEY(idProduto)
)
GO
CREATE TABLE camiseta(
idProduto INT NOT NULL,
tamanho VARCHAR(3)
PRIMARY KEY(idProduto)
FOREIGN KEY (idProduto) REFERENCES produto(idProduto))
GO
CREATE TABLE tenis(
idProduto INT NOT NULL,
tamanho INT
PRIMARY KEY(idProduto)
FOREIGN KEY (idProduto) REFERENCES produto(idProduto))
 
SELECT * FROM produto
SELECT * FROM tenis
SELECT * FROM camiseta
 
SELECT p.idProduto, p.cor, p.tipo, t.tamanho
FROM tenis t, produto p
WHERE p.idProduto = t.idProduto
 
SELECT p.idProduto, p.cor, p.tipo, c.tamanho
FROM camiseta c, produto p
WHERE p.idProduto = c.idProduto
 
--Query Dinâmica
DECLARE @query VARCHAR(200)
SET @query = 'INSERT INTO produto VALUES (1, ''Polo'', ''Azul'')'
PRINT @query
EXEC (@query)
 
DELETE produto
 
CREATE PROCEDURE sp_insereproduto (@id INT, @tipo VARCHAR(100),
	@cor VARCHAR(50), @tamanho VARCHAR(3), 
	@saida VARCHAR(100) OUTPUT)
AS
	DECLARE @tam		INT,
			@tabela		VARCHAR(20),
			@query		VARCHAR(200),
			@erro		VARCHAR(MAX)
 
	SET @tabela = 'tenis'
	BEGIN TRY
		SET @tam = CAST(@tamanho AS INT)
	END TRY
	BEGIN CATCH
		SET @tabela = 'camiseta'
	END CATCH
 
	SET @query = 'INSERT INTO '+@tabela+' VALUES('+
				CAST(@id AS VARCHAR(3))+','''+@tamanho+''')' 
	PRINT @query
 
	BEGIN TRY 
		INSERT INTO produto VALUES (@id, @tipo, @cor)
		EXEC(@query)
		SET @saida = UPPER(@tabela) + ' inserido com sucesso'
	END TRY
	BEGIN CATCH
		SET @erro = ERROR_MESSAGE()
		IF (@erro LIKE '%primary%')
		BEGIN
			RAISERROR('ID já existente', 16, 1)
		END
		ELSE
		BEGIN
			RAISERROR('Falha no armazenamento de dados', 16, 1)
		END
	END CATCH
 
DECLARE @out1 VARCHAR(100)
EXEC sp_insereproduto 1, 'Polo', 'Azul', 'GG', @out1 OUTPUT
PRINT @out1
 
DECLARE @out2 VARCHAR(100)
EXEC sp_insereproduto 2, 'Regata', 'Amarela', 'XGG', @out2 OUTPUT
PRINT @out2
 
DECLARE @out3 VARCHAR(100)
EXEC sp_insereproduto 3, 'Air Jordan', 'Branco', '42', @out3 OUTPUT
PRINT @out3
 
DELETE camiseta WHERE idProduto = 2
GO
DELETE produto WHERE idProduto = 2
