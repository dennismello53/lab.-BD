CREATE DATABASE campeonato
GO
USE campeonato

/*
Fazer  uma  aplicação  em  Java  Web (Maven + Servlets + JSP + CSS + JSTL) com SQL Server para resolver os problemas, da seguinte maneira: 
O sistema deve ter 3 tabelas principais: 
- Times (Com todos os times)(Não é necessário CRUD para ela) 
Times (CodigoTime | NomeTime | Cidade | Estadio) 
*/

CREATE TABLE Times(
	CodigoTime		INT	PRIMARY KEY		IDENTITY,
	NomeTime		VARCHAR(30)			NOT NULL,
	Cidade			VARCHAR(30)			NOT NULL,
	Estadio			VARCHAR(30)			NOT NULL
)

INSERT INTO Times VALUES('Botafogo-SP','Ribeirão Preto','Santa Cruz')
INSERT INTO Times VALUES('Corinthians','São Paulo','Neo Química Arena')
INSERT INTO Times VALUES('Ferroviária','Araraquara','Fonte Luminosa')
INSERT INTO Times VALUES('Guarani','Campinas','Brinco de Ouro da Princesa')
INSERT INTO Times VALUES('Inter de Limeira','Limeira','Limeirão')
INSERT INTO Times VALUES('Ituano','Itu','Novelli Júnior')
INSERT INTO Times VALUES('Mirassol','Mirassol','Jóse Maria de Campos Maia')
INSERT INTO Times VALUES('Novorizontino','Novo Horizonte','Jorge Ismael de Biasi')
INSERT INTO Times VALUES('Palmeiras','São Paulo','Allianz Parque')
INSERT INTO Times VALUES('Ponte Preta','Campinas','Moisés Lucarelli')
INSERT INTO Times VALUES('Red Bull Bragantino', 'Bragança Paulista', 'Nabi Abi Chedid')
INSERT INTO Times VALUES('Santo André', 'Santo André', 'Bruno José Daniel')
INSERT INTO Times VALUES('Santos','Santos','Vila Belmiro')
INSERT INTO Times VALUES('São Bento','Sorocaba','Walter Ribeiro')
INSERT INTO Times VALUES('São Caetano','São Caetano do Sul','Anacletto Campenella')
INSERT INTO Times VALUES('São Paulo','São Paulo','Morumbi')

/*
-  Grupos  (Coritnthians,  Palmeiras,  Santos  e  São  Paulo  NÃO  PODEM  estar  no  mesmo  grupo) 
(A coluna Grupo não pode aceitar nenhum valor diferente de A, B, C, D) 
Grupos (Grupo | CodigoTime)
*/

CREATE TABLE Grupos(
	Grupo			VARCHAR(1) CHECK (Grupo IN ('A','B','C','D')),
	Codigo_Time		INT
PRIMARY KEY (Grupo, Codigo_Time)
)	

/*
- Jogos(A  primeira  fase  ocorrerá  em  12  datas  seguidas,  sempre  rodada  cheia  (Todos  os  jogos),  aos  domingos e quartas)- 
Jogos 
(CodigoTimeA | CodigoTimeB | GolsTimeA | GolsTimeB | Data)
*/

CREATE TABLE Jogos(
	CodigoTimeA		INT,
	CodigoTimeB		INT,
	GolsTimeA		INT,
	GolsTimeB		INT,
	DataJogo		DATE	CHECK(DataJogo BETWEEN '2021-02-27' and '2021-05-23')	
PRIMARY KEY (CodigoTimeA, CodigoTimeB)
)

-- Chaves estrangeiras 
ALTER TABLE Grupos ADD CONSTRAINT FK_Grupos_Times
FOREIGN KEY(Codigo_Time) REFERENCES Times(CodigoTime)

ALTER TABLE Jogos ADD CONSTRAINT FK_Jogos_TimesA
FOREIGN KEY(CodigoTimeA) REFERENCES Times(CodigoTime)

ALTER TABLE Jogos ADD CONSTRAINT FK_Jogos_TimesB
FOREIGN KEY(CodigoTimeB) REFERENCES Times(CodigoTime)
GO

/*
  O sistema deve se comportar da seguinte maneira:
 Uma tela deve chamar uma procedure que divide os times nos quatro grupos, 
 preenchendo, aleatoriamente (com exceção da regra já exposta em Grupos).
*/

CREATE PROC sp_gerarGrupos
AS
    DECLARE @random INT, 
            @secundarios AS VARCHAR(16),
            @principais AS VARCHAR (4),
            @grupo AS CHAR(1),
            @time AS VARCHAR(16),
            @count AS INT,
            @aux AS CHAR(1)

	-- Define a quantidade de times em cada grupo:
	-- Secundarios: 3 Vagas em cada grupo
    SET @secundarios = 'AAABBBCCCDDD'
	-- Principais: 1 Vaga em cada grupo
    SET @principais = 'ABCD'

	-- Contador de ID dos times
    SET @count = 1

	-- Ira realizar o ciclo até ser definido o grupo dos 16 Times
    WHILE (@count <= 16) 
    BEGIN 
		-- Define se ira pegar a vaga na lista principal ou secundaria
		-- Se o time estiver na lista de "Principais" (Sp, Corint, Palm, Sant)
        IF ((@count = 2) OR (@count = 9) OR (@count = 13) OR (@count = 16)) 
        BEGIN 
            SET @time = @principais
            SET @aux = 'p'
        END 
		-- Se estiver na lista de "Secundarios" 
        ELSE
        BEGIN 
            SET @time = @secundarios
            SET @aux = 's'
        END  

		-- Define um grupo aleatóriamente
        SET @random = FLOOR(RAND()*(LEN(@time))+1)
        -- Utilizando as vagas escolhidas anteriormente
		SET @grupo = SUBSTRING(@time, @random, 1)

		-- Remove uma vaga do grupo escolhido
        SET @time = STUFF(@time, PATINDEX('%' + @grupo + '%', @time), LEN(@grupo), '')

		-- Registra as vagas restantes 
        IF (@aux = 's')
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
									 @id_time = j.CodigoTimeB) AND
									 @dia_de_hoje = j.DataJogo))

				-- Caso ainda não tenha jogado 
				IF (@codigo IS NULL)
				BEGIN
					SET @jogou = 0
					SET @contador = 1
					SET @adversario = 0

					-- Em quanto ainda não jogou e ainda tem adversários para serem enfrentados
					WHILE ((@jogou = 0) AND (@contador < 16))
					BEGIN 
						
						-- Escolhe o adversário
						SET @adversario = @id_time + @contador 
						IF (@adversario > 16)
						BEGIN
							SET @adversario = @adversario - 16
						END 

						-- Verifica se adversario já jogou no dia de hoje
						SET @codigoAdv = NULL
						SET @codigoAdv = (SELECT j.CodigoTimeA 
										  FROM Jogos AS j 
										  WHERE ((@adversario = j.CodigoTimeA OR 
												 @adversario = j.CodigoTimeB) AND
												 @dia_de_hoje = j.DataJogo))

						-- Verfica se ambos os times já jogaram um contra o outro				
						SET @codigo = NULL
						SET @codigo = (SELECT j.CodigoTimeA
									   FROM Jogos AS J 
									   WHERE (j.CodigoTimeA = @id_time AND j.CodigoTimeB = @adversario) OR 
											 (j.CodigoTimeA = @adversario AND j.CodigoTimeB = @id_time))

						-- Verifica se ambos os times estão no mesmo Grupo					
						SET @mesmoGrupo = NULL
						SET @mesmoGrupo = (SELECT g1.Codigo_Time
										   FROM Grupos g1, Grupos g2
									       WHERE g1.Grupo != g2.Grupo
											 AND g1.Codigo_Time = @id_time
											 AND g2.Codigo_Time = @adversario)
						
						-- Se alguma das condições forem Verdadeiras, ira se decidir um novo adversario.
						IF ((@codigo IS NOT NULL) OR (@codigoAdv IS NOT NULL) or (@id_time = @adversario) OR (@mesmoGrupo IS NULL))
						BEGIN 
							SET @contador = @contador + 1
						END 

						-- Senão eles irão se enfrentar 
						ELSE 
						BEGIN 
							SET @jogou = 1; 
							INSERT INTO Jogos VALUES (@id_time, @adversario, NULL, NULL, @dia_de_hoje)
						END 
					END 
				END
				SET @times_jogados = @times_jogados + 1 	
			END 
		END 

		SET @dia_de_hoje = DATEADD(DAY, 1, @dia_de_hoje)

	END 
GO


--	- Uma tela deve mostrar 4 Tabelas com os 4 grupos formados.
CREATE FUNCTION fn_gerarTabelaGrupo(@grupo AS CHAR(1))
RETURNS @table TABLE (
cod_time	INT,
nome_time	VARCHAR(100)
)
AS
BEGIN

	INSERT INTO @table 
		SELECT t.CodigoTime, t.NomeTime
		FROM Grupos g, Times t
		WHERE t.CodigoTime = g.Codigo_Time
			AND Grupo = @grupo

	RETURN 
END 
GO


--	- Uma tela deve mostrar um Campo, onde o usuário digite a data e, em caso de ser uma data com
--	rodada, mostre uma tabela com todos os jogos daquela rodada.
CREATE FUNCTION fn_consultarData (@verfData DATE)
RETURNS @table TABLE (
nome_timeA	VARCHAR(100),
nome_timeB	VARCHAR(100)
)
AS
BEGIN 
	INSERT INTO @table 
		SELECT ta.nomeTime, tb.NomeTime
		FROM Jogos j, Times ta, Times tb
		WHERE ta.CodigoTime = j.CodigoTimeA
			AND tb.CodigoTime = j.CodigoTimeB
			AND j.DataJogo = @verfData
	RETURN 
END 
GO 

-- SELECTS -- 
-- Todos os Grupos
SELECT g.Grupo, t.NomeTime
FROM Grupos g
INNER JOIN Times t
ON t.CodigoTime = g.Codigo_Time

-- Todos os Jogos (Santos na Vila Belmiro)
SELECT j.DataJogo, ta.CodigoTime AS CodigoTimeA, ta.NomeTime AS NomeTimeA, 
	   tb.CodigoTime AS CodigoTimeB, tb.NomeTime AS NomeTimeB
FROM Jogos j, Times ta, Times tb
WHERE ta.CodigoTime = j.CodigoTimeA
	AND tb.CodigoTime = j.CodigoTimeB
	ORDER BY j.DataJogo

-- Todos os Times 
SELECT * FROM Times 

-- PROCEDURES -- 
EXEC sp_gerarGrupos
EXEC sp_gerarJogos

-- FUNCTIONs -- 
SELECT * FROM fn_gerarTabelaGrupo('A')
SELECT * FROM fn_gerarTabelaGrupo('B')
SELECT * FROM fn_gerarTabelaGrupo('C')
SELECT * FROM fn_gerarTabelaGrupo('D')

SELECT * FROM fn_consultarData('2021-02-27')	

-- Truncate -- 
TRUNCATE TABLE Jogos 
TRUNCATE TABLE Grupos
