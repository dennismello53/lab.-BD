CREATE DATABASE Cadastro
GO
USE Cadastro

/*
Tarefas Stored Procedure:
-Criar uma database chamada cadastro, 
-criar uma tabela pessoa (CPF CHAR(11) PK, nome VARCHAR(80)), 
-pegar o algoritmo de validação de CPF, transformar em uma Stored Procedure sp_inserepessoa, 
que receba como parâmetro @cpf e @nome e @saida como parâmtero de saída. 
-Valide o CPF e, só insira na tabela pessoa (cpf e nome) com CPF válido e nome com LEN Maior que zero. 
@saida deve dizer que foi inserido com sucesso. Raiserrors devem tratar violações. */

CREATE TABLE pessoa(		
cpf CHAR(11) PRIMARY KEY,
nome VARCHAR(80) NOT NULL
)

CREATE PROCEDURE sp_testaNumero(@cpf CHAR(11), @resposta CHAR(1) OUTPUT) --testa se todos os digitos sao iguais
AS
	SET @resposta = 'n'
	--variaveis locais
	DECLARE @novoCont INT
	DECLARE @outroValor INT
	DECLARE @contValida INT
	SET @novoCont = 1
	SET @contValida = 1
	SET @outroValor = CAST(SUBSTRING(@cpf,1, 1) as int)

	WHILE (@novoCont <= 10)
	BEGIN
		SET @novoCont = @novoCont + 1

		IF(@outroValor = CAST(SUBSTRING(@CPF, @novoCont, 1) as INT))
		BEGIN
			SET @contValida = @contValida + 1
		END
	END

	IF (@contValida = 11)
	BEGIN
		SET @resposta = 's'
	END

CREATE PROCEDURE sp_testaNome(@nome VARCHAR(50), @respostaN INT OUTPUT) --testa se todos os digitos sao iguais
AS
	SET @respostaN = LEN(@nome)


CREATE PROCEDURE sp_inserepessoa(@cpf CHAR(11), @nome VARCHAR(80), @out VARCHAR(MAX) OUTPUT)
AS
	DECLARE @resposta CHAR(1)
	DECLARE @respostaN INT
	EXEC sp_testaNumero @cpf, @resposta OUTPUT
	EXEC sp_testaNome @nome, @respostaN OUTPUT

	IF (@resposta = 's' OR @respostaN = 0)
	BEGIN
		IF(@resposta = 's')
		BEGIN
			RAISERROR('Os numeros do cpf são todos iguais', 16, 1)
		END
		ELSE
		BEGIN
			RAISERROR('O nome está vazio', 16, 1)
		END
	END

	ELSE
	BEGIN
		DECLARE @numero INT
		DECLARE	@soma INT
		DECLARE @resto INT
		DECLARE	@digitoUm INT
		DECLARE	@digitoDois INT
		DECLARE @cont INT
		DECLARE @contDigUm INT
		DECLARE @contDigDois INT
		DECLARE @valida INT
		SET @valida = 0
		SET @cont = 1
		SET @soma = 0
		SET @contDigUm = 10
		SET @contDigDois = 11

		WHILE (@cont <= 9)
		BEGIN
			SET @numero = CAST(SUBSTRING(@cpf,  @cont, 1) as INT)
			SET @soma = @soma + (@numero * @contDigUm)
			SET @contDigUm = @contDigUm - 1
			SET @cont = @cont + 1
		END

		SET @resto = @soma % 11
		SET @digitoUm = CAST(SUBSTRING(@cpf, 10, 1) as INT)

		IF(@resto < 2)
		BEGIN
			IF(@digitoUm = 0)
			BEGIN
				--PRINT 'O digito um é valido'
				SET @valida = @valida + 1
			END
		END
		ELSE
		BEGIN
			IF(@digitoUm = (11 - @resto))
			BEGIN
				 --PRINT 'O digito um é valido'
				 SET @valida = @valida + 1
			END
		END

		SET @cont = 1
		SET @soma = 0
		SET @resto = 0

		WHILE (@cont <= 10)
		BEGIN
			SET @numero = CAST(SUBSTRING(@cpf,  @cont, 1) as INT)
			SET @soma = @soma + (@numero * @contDigDois)
			SET @contDigDois = @contDigDois - 1
			SET @cont = @cont + 1
		END

		SET @resto = @soma % 11
		SET @digitoDois = CAST(SUBSTRING(@cpf, 11, 1) as INT)

		IF(@resto < 2)
		BEGIN
			IF(@digitoDois = 0)
			BEGIN
				--PRINT 'O digito dois é valido'
				SET @valida = @valida + 1
			END
		END
		ELSE
		BEGIN
			IF(@digitoDois = (11 - @resto))
			BEGIN
				 --PRINT 'O digito dois é valido'
				 SET @valida = @valida + 1
			END
			END
		IF (@valida >= 2)
		BEGIN
			INSERT INTO pessoa VALUES (@cpf, @nome)
			SET @out = 'Pessoa inserida com sucesso'
		END
		ELSE
		BEGIN
			RAISERROR('Cpf com digito errado', 16, 1)
		END
			

	END

--inserir dados
DECLARE @saida VARCHAR(MAX)
EXEC sp_inserepessoa '11111111111', 'lucas', @saida OUTPUT
PRINT @saida

SELECT * FROM pessoa