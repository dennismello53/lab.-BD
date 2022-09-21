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

CREATE FUNCTION fn_fam()
RETURNS @tabela TABLE
	(Nome_Funcionario VARCHAR(20),
	Nome_Dependente VARCHAR(20),
	Salario_Funcionario VARCHAR(20),
	Salario_Dependente VARCHAR(20))
AS
BEGIN
INSERT @tabela(Nome_Funcionario, Nome_Dependente, Salario_Funcionario, Salario_Dependente)
		SELECT F.nome, D.nome_dependente, F.salario, D.salario_dependente 
		FROM funcionarios AS F INNER JOIN dependente AS D ON cod=cod_funcionario
RETURN
END

SELECT * FROM fn_fam()
