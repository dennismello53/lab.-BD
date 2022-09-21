CREATE DATABASE functions2
GO
USE functions2
 
CREATE TABLE aluno (
cod			INT				NOT NULL,
nome		VARCHAR(100),
altura		DECIMAL(7,2),
peso		DECIMAL(7,2)
PRIMARY KEY(cod))
GO
INSERT INTO aluno VALUES 
(1, 'Fulano', 1.7, 100.2),
(2, 'Cicrano', 1.92, 107.1),
(3, 'Beltrano', 1.83, 76.0)
 
SELECT * FROM aluno
 
/*User Defined Functions (UDF)
-Tipos:
	- Scalar Function (Ret. Var. Escalar)
	- Inline Table (Assemelha a Views, pouco utilizadas)(Ret. Table)
	- Multi Statement Tables (Ret. Table)
 
Em SGBDs como o Oracle, só existe o retorno escalar,
nesse caso, deve-se criar um objeto tipo tabela, fazer um pipe do 
retorno para o objeto e a UDF retorna o objeto
 
- Não permite DDL
- Não permite Raise Error
- Retona ResultSet (Acessado por selects)
- Pode fazer joins com selects de tabelas comuns ou views
*/
 
--Ex.1: Fazer uma função escalar da Database acima que, 
--dado o 
--código de um aluno, retornar seu imc (Peso/Altura²)
 
/*Ex.2: Fazer uma função Multi Statement Table que retorne:
cod			int
nome		varchar
altura		decimal
peso		decimal
imc			decimal
condicao	varchar
 
Condição:
Classificação			IMC
Muito abaixo do peso	abaixo de 16,9 kg/m2	
Abaixo do peso			17 a 18,4 kg/m2	
Peso normal				18,5 a 24,9 kg/m2
Acima do peso			25 a 29,9 kg/m2	
Obesidade Grau I		30 a 34,9 kg/m2	
Obesidade Grau II		35 a 40 kg/m2		
Obesidade Grau III		acima de 40 kg/m2
*/
 
--Função Escalar
CREATE FUNCTION fn_imc(@cod INT)
RETURNS DECIMAL(7,2)
AS
BEGIN
	DECLARE @altura		DECIMAL(7,2),
			@peso		DECIMAL(7,2),
			@imc		DECIMAL(7,2)
	--SET @altura = (SELECT altura FROM aluno WHERE cod = @cod)
	--SET @peso = (SELECT peso FROM aluno WHERE cod = @cod)
	SELECT @altura = altura, @peso = peso FROM aluno
		WHERE cod = @cod
	--SET @imc = @peso / (@altura * @altura)
	SET @imc = @peso / POWER(@altura, 2)
	RETURN (@imc)
END
 
SELECT dbo.fn_imc(3) AS imc
 
--Exemplo 2 - Multi Statement Table
CREATE FUNCTION fn_tabelaimc()
RETURNS @tabela TABLE (
cod			INT,
nome		VARCHAR(100),
altura		DECIMAL(7,2),
peso		DECIMAL(7,2),
imc			DECIMAL(7,2),
descricao	VARCHAR(40)
)
AS
BEGIN
	INSERT INTO @tabela(cod, nome, altura, peso)
		SELECT cod, nome, altura, peso FROM aluno
 
	--UPDATE @tabela SET imc = peso / POWER(altura, 2)
	UPDATE @tabela SET imc = (SELECT dbo.fn_imc(cod))
 
	UPDATE @tabela SET descricao = 'Muito abaixo do peso'
		WHERE imc < 17
	UPDATE @tabela SET descricao = 'Abaixo do peso'
		WHERE imc >= 17 AND imc < 18.5
	UPDATE @tabela SET descricao = 'Peso Normal'
		WHERE imc >= 18.5 AND imc < 25
	UPDATE @tabela SET descricao = 'Acima do peso'
		WHERE imc >= 25 AND imc < 30
	UPDATE @tabela SET descricao = 'Obesidade Grau I'
		WHERE imc >= 30 AND imc < 35
	UPDATE @tabela SET descricao = 'Obesidade Grau II'
		WHERE imc >= 35 AND imc < 40
	UPDATE @tabela SET descricao = 'Obesidade Grau III'
		WHERE imc >= 40
	RETURN 
END
 
SELECT * FROM fn_tabelaimc()
 
SELECT cod, nome, altura, peso, descricao FROM fn_tabelaimc()
WHERE imc >= 25
 
SELECT cod, nome, peso FROM fn_tabelaimc()
WHERE imc < 25
 
SELECT cod, nome, altura, peso,
		CASE WHEN (imc >= 25 AND peso < 105)
			THEN 'Exercícios Aeróbicos'
			ELSE 'Exercícios Gerais'
		END AS exercicios
FROM fn_tabelaimc()
