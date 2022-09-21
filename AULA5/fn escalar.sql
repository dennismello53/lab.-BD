CREATE TABLE funcionarios(
	cod INT NOT NULL,
	nome VARCHAR(20),
	salario DECIMAL(7,2) NOT NULL,
	PRIMARY KEY(cod)
);

CREATE TABLE dependente(
	cod_funcionario INT NOT NULL, 
	nome_dependente VARCHAR(20), 
	salario_dependente DECIMAL(7,2) NOT NULL,
	PRIMARY KEY(cod_funcionario),
	FOREIGN KEY (cod_funcionario) REFERENCES funcionarios(cod)
);


INSERT INTO funcionarios VALUES 
(1, 'Fulano', 9999.99),
(2, 'Cicrano', 5555.55),
(3, 'Beltrano', 2000.00)

INSERT INTO dependente VALUES 
(1, 'Onaluf', 999.99),
(2, 'Onarcic', 555.55),
(3, 'Onartleb', 200.00)

CREATE FUNCTION fn_soma(@cod INT)
RETURNS DECIMAL(7,2)
AS
BEGIN
	DECLARE @sal_f		DECIMAL(7,2),
			@sal_d		DECIMAL(7,2),
			@soma		DECIMAL(9,2)
	--SET @sal_f = (SELECT salario FROM funcionario WHERE cod = @cod)
	--SET @sal_d = (SELECT salario_dependente FROM dependente WHERE cod = @cod)
	SELECT @sal_f = salario, @sal_d = salario_dependente FROM funcionarios LEFT OUTER JOIN dependente ON cod=cod_funcionario
		WHERE cod = @cod
	--SET @soma = @sal_f + @sal_d)
	SET @soma = SUM(@sal_f+@sal_d)
	RETURN (@soma)
END
 
SELECT dbo.fn_soma(1) AS soma