CREATE DATABASE campeonato
GO
USE campeonato
GO
CREATE TABLE times(
	CodigoTime INT NOT NULL IDENTITY,
	NomeTime VARCHAR(25) NOT NULL,
	Cidade	VARCHAR(25) NOT NULL,
	Estadio VARCHAR(30) NOT NULL,
	PRIMARY KEY(CodigoTime)
);

INSERT INTO Times VALUES('Botafogo-SP','Ribeirão Preto','Santa Cruz')
INSERT INTO Times VALUES('Corinthians','São Paulo','Arena Corinthians')
INSERT INTO Times VALUES('Ferroviária','Araraquara','Fonte Luminosa')
INSERT INTO Times VALUES('Guarani','Campinas','Brinco de Ouro da Princesa')
INSERT INTO Times VALUES('Inter de Limeira','Limeira', 'Limeirão')
INSERT INTO Times VALUES('Ituano','Itu','Novelli Júnior')
INSERT INTO Times VALUES('Mirassol','Mirassol','Jóse Maria de Campos Maia')
INSERT INTO Times VALUES('Novorizontino','Novo Horizonte','Jorge Ismael de Biasi')
INSERT INTO Times VALUES('Palmeiras','São Paulo','Allianz Parque')
INSERT INTO Times VALUES('Ponte Preta','Campinas','Moisés Lucarelli')
INSERT INTO Times VALUES('Red Bull Bragantino','Bragança Paulista','Nabi Abi Chedid')
INSERT INTO Times VALUES('Santo André', 'Santo André', 'Bruno José Daniel')
INSERT INTO Times VALUES('Santos','Santos','Vila Belmiro')
INSERT INTO Times VALUES('São Bento','Sorocaba','Walter Ribeiro')
INSERT INTO Times VALUES('São Caetano','São Caetano do Sul','Anacletto Campenella')
INSERT INTO Times VALUES('São Paulo','São Paulo','Morumbi')

SELECT * FROM times;

CREATE TABLE grupos(
	Grupo VARCHAR(1) CHECK (Grupo  IN ('A', 'B', 'C', 'D' )),
	CodigoTime INT NOT NULL,
	PRIMARY KEY (CodigoTime, Grupo),
	FOREIGN KEY (CodigoTime) references times(CodigoTime)
);


CREATE TABLE jogos(
	CodigoTimeA INT NOT NULL,
	CodigoTimeB INT NOT NULL,
	GolsTimeA INT NOT NULL,
	GolsTimeB INT NOT NULL,
	Dia DATE CHECK (Dia >= '27/02/2021' and Dia <= '23/05/2021' ),
	PRIMARY KEY (CodigoTimeA, CodigoTimeB),
	FOREIGN KEY (CodigoTimeA) REFERENCES times(CodigoTime),
	FOREIGN KEY (CodigoTimeB) REFERENCES times(CodigoTime)
);

SELECT * FROM times;
SELECT * FROM grupos;
SELECT * FROM jogos;

CREATE PROC sp_sorteiopaulistao
AS
	DECLARE @random INT,
			@cabeca AS VARCHAR(4),
			@secundarios AS VARCHAR(16),
			@grupo AS CHAR(1),
            @time AS VARCHAR(16),
            @count AS INT,
            @aux AS CHAR(1)


	SET @cabeca = 'ABCD'
	SET @secundarios = 'AAABBBCCCDDD'
	SET @count = 1
	
	WHILE (@count <= 16)
	BEGIN
		IF ((@count = 2) OR (@count = 9) OR (@count = 13) OR (@count = 16)) 
        BEGIN 
            SET @time = @cabeca
            SET @aux = 'c'
        END 
		ELSE
		BEGIN
			SET @time = @secundarios
			SET @aux = 's'
		END

	SET @random = FLOOR(RAND()*(LEN(@time))+1)
			
		SET @grupo = SUBSTRING(@time, @random, 1)
	
	SET @time = STUFF(@time, PATINDEX('%' + @grupo + '%', @time), LEN(@grupo), '')

	IF(@aux = 's')
	BEGIN
		SET @secundarios = @time