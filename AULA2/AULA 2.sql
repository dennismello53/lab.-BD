CREATE DATABASE AULA2;

USE AULA2;

/*
Programação estruturada em SQL (Com SQL SERVER)
Declaração de variáveis:
DECLARE @var TIPO

Atribuição de variáveis:
SET @var = valor
SET @var = (SELECT col FROM Tbl WHERE col = valor) -- Permitido se o select retorna 1 único valor
SELECT @var = col FROM Tbl WHERE col = valor -- Permitido se o select retorna 1 único valor

Condicional:
IF (condição lógica)
BEGIN
	.
	.
	.
END
ELSE
BEGIN
	.
	.
	.
END

Repetição (Não se usa FOR para essa finalidade)
WHILE (condição lógica)
BEGIN
	.
	.
	.
END

-- Exemplo com Tabelas
*/
CREATE TABLE produto(
id	        INT		      NOT NULL,
nome        VARCHAR (100) NOT NULL,
valor_um    DECIMAL(7, 2) NOT NULL,
qtd_estoque INT			  NOT NULL,
PRIMARY KEY(id));

INSERT INTO produto VALUES(1, 'MOUSE', 29.99, 4);

DECLARE @cont INT
SET @cont = 1
PRINT (@cont)

select * from produto

DECLARE @id			INT,
		@nome		VARCHAR(30),
		@valor_um	DECIMAL(7,2)
--SET @id = (SELECT id FROM produto WHERE id = 1)
--SET @nome = (SELECT nome FROM produto WHERE id = 1)
--SET @valor_um = (SELECT valor_um FROM produto WHERE id = 1)
SELECT @id = id, @nome = nome, @valor_um = valor_um 
	FROM produto WHERE id = 1
PRINT (@id)
PRINT (@nome)
PRINT (@valor_um)
 
DECLARE @valor	INT
SET @valor = CAST (((RAND() * 100) + 1) AS INT) 
PRINT (@valor)
IF (@valor % 2 = 0)
BEGIN
	PRINT('É PAR')
END
ELSE
BEGIN
	PRINT('É IMPAR')
END
 
DECLARE @qtd_estoque	INT
SET @qtd_estoque = (SELECT qtd_estoque FROM produto WHERE id = 1)
IF (@qtd_estoque < 5)
BEGIN
	PRINT('Estoque baixo')
END
ELSE
BEGIN
	IF (@qtd_estoque > 30)
	BEGIN
		PRINT('Estoque alto')
	END
	ELSE
	BEGIN
		PRINT('Estoque quase baixo')
	END
END
 
DELETE produto
 
DECLARE @id				INT,
		@nome			VARCHAR(30),
		@valor_um		DECIMAL(7,2),
		@qtd_estoque	INT,
		@cont			INT
SET @cont = 1
WHILE (@cont <= 1000)
BEGIN
	SET @id = @cont
	SET @nome = 'Produto '+CAST(@cont AS VARCHAR(4))
	SET @valor_um = ((RAND() * 285) + 15)
	SET @qtd_estoque = CAST(((RAND() * 51) + 0) AS INT)
	INSERT INTO produto VALUES
		(@id, @nome, @valor_um, @qtd_estoque)
	SET @cont = @cont + 1
END
 
SELECT COUNT(*) FROM produto
SELECT * FROM produto

CREATE TABLE Cliente(
	id INT NOT NULL,
	nome VARCHAR(100) NOT NULL,
	credito DECIMAL(7, 2) NOT NULL,
	ano_nascimento INT NOT NULL,
	PRIMARY KEY(id)
);

DROP TABLE Cliente

DECLARE @id				INT,
		@nome			VARCHAR(100),
		@credito		DECIMAL(7, 2),
		@ano_nascimento INT ,
		@cont			INT
SET @cont = 1
WHILE (@cont <= 50)
BEGIN
	SET @id = 100001 + @cont
	SET @nome = 'Cliente '+CAST(@cont AS VARCHAR(4)) 
	SET @credito = ((RAND() * 8998.99) + 1001.00)
	PRINT (@credito)
	SET @ano_nascimento = CAST(((RAND() * 50) + 1950) AS INT)
	PRINT (@ano_nascimento)
	INSERT INTO Cliente VALUES
			(@id, @nome, @credito, @ano_nascimento)
	SET @cont = @cont + 1
END

SELECT COUNT(*) FROM Cliente
SELECT * FROM Cliente


 --a) Fazer um algoritmo que leia 1 número e mostre se são múltiplos de 2,3,5 ou nenhum deles

DECLARE @number AS INT;
SET @number = 60;
IF @number % 2 = 0
	BEGIN
		IF @number % 3 = 0
			BEGIN
				IF @number % 5 = 0
					BEGIN
						PRINT('É MULTIPLO DE 2,3,5');
					END
			END
	END
ELSE
BEGIN
	PRINT('NÃO')
END

-- b)  Fazer um algoritmo que leia 3 números e mostre o maior e o menor

DECLARE @number1 AS INT,
		@number2 AS INT,
		@number3 AS INT,
		@maior   AS INT,
		@menor   AS INT

SET @number1 = 3
SET @number2 = 6
SET @number3 = 2
SET @menor   = 0 
SET @maior   = 0

IF @number1 > @number2
BEGIN
	SET @maior = @number1
	SET @menor = @number2
END
ELSE
BEGIN
	SET @maior = @number2
	SET @menor = @number1
END
IF @number3 > @maior
BEGIN
	SET @maior = @number3
END
ELSE
BEGIN
	SET @menor = @number3
END
print('Maior ' + CAST(@maior AS VARCHAR))
print('Menor ' + CAST(@menor AS VARCHAR))

 
  
--c) Fazer um algoritmo que calcule os 15 primeiros termos da série 1,1,2,3,5,8,13,21,... E calcule a soma dos 15 termos

DECLARE @n1 AS INT,
		@count AS INT,
		@n2	   AS INT,
		@n3   AS INT,
		@soma AS INT

SET @n1 = 0
SET @count = 1
SET @n2 = 1
SET @n3 = 1
SET @soma = 0

WHILE @count <= 15
BEGIN
	print(@n3)
	SET @n3 = @n1 + @n2
	set @n1 = @n2
	SET @n2 = @n3

	SET @soma = @n3 + @soma

	SET @count = @count + 1
END	
PRINT('Soma fibonacci ' + CAST(@SOMA AS VARCHAR))

--d) Fazer um algoritmo que separa uma frase, colocando todas as letras em maiúsculo e em minúsculo (Usar funções UPPER e LOWER)
  
 DECLARE @string AS VARCHAR(10)

 SET @string = 'aModRoGA'
		SELECT LEFT(UPPER(@string),3) + ' ' + SUBSTRING(UPPER(@string),4,8)
		SELECT LEFT(LOWER(@string),3) + ' ' + SUBSTRING(LOWER(@string),4,8)


--e) Fazer um algoritmo que inverta uma palavra (Usar a função SUBSTRING)

DECLARE @invert AS VARCHAR(10)
SET @invert = 'ABC'

SELECT SUBSTRING(@invert, 3, 3) + SUBSTRING(@invert, 2, 2) + SUBSTRING(@invert, 1, 1)