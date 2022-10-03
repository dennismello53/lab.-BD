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
	END 
        ELSE 
        BEGIN
            SET @principais = @time
        END  

		-- Insere na tabela Grupos o grupo sorteado juntamente com o ID do time
        INSERT INTO Grupos VALUES (@grupo, @count)

		-- Passa para o próximo time
        SET @count = @count + 1 

        END 
GO


/*
	- Uma tela deve gerar as rodadas dos jogos, de acordo com as regras do
	campeonato, preenchendo a tabela jogos.
	Lembre-se, cada rodada tem 8 jogos (todos os 16 times). Lembre-se também que, as rodadas
	vão acontecer de quarta e domingo, sucessivamente, sem pausas.
	• Um jogo não pode ocorrer 2 vezes, mesmo em rodadas diferentes
	• Um time não pode aparecer 2 vezes na mesma rodada
	• A fase de grupos vai terminar antes da data final do campeonato, uma vez que o
	  campeonato prevê datas das fase eliminatórias também
*/
CREATE PROC sp_gerarJogos
AS
	DECLARE @dia_de_hoje AS DATE, 
			@dia_final AS DATE,
			@contador AS INT,
			@codigo AS INT,
			@codigoAdv AS INT,
			@times_jogados AS INT,
			@adversario AS INT,
			@jogou AS INT,
			@id_time AS INT, 
			@mesmoGrupo AS INT 
	
	-- Escolhe o dia de inicio e do fim de campeonato
	SET @dia_de_hoje = '2021-02-27'
	SET @dia_final = '2021-05-23'
	
	-- Enquanto o campeonato estiver rolando 
	WHILE (@dia_de_hoje < @dia_final)
	BEGIN 
		-- Verifica se é dia de Jogo (Quarta ou Domingo)
		IF ((DATEPART(WEEKDAY, @dia_de_hoje) = 1) OR (DATEPART(WEEKDAY, @dia_de_hoje) = 4))
		BEGIN 

			SET @times_jogados = 1

			-- Enquanto os 16 times não tiverem jogado
			WHILE (@times_jogados <= 16 )
			BEGIN 

				-- Escolhe o time A que ira jogar 
	            SET @id_time = @times_jogados

				-- Verifica se o time A jogou no dia de hoje
				SET @codigo = NULL
				SET @codigo = (SELECT j.CodigoTimeA 
				               FROM Jogos AS j 
							   WHERE ((@id_time = j.CodigoTimeA OR 

