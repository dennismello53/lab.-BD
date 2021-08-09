CREATE DATABASE palestra
GO
USE palestra
GO

CREATE TABLE curso(
codigo_curso INT NOT NULL,
nome VARCHAR(70) NOT NULL,
sigla VARCHAR(10) NOT NULL,
PRIMARY KEY(codigo_curso)
)

CREATE TABLE aluno(
ra CHAR(7) NOT NULL,
nome VARCHAR(250) NOT NULL,
codigo_curso INT NOT NULL,
PRIMARY KEY(ra),
FOREIGN KEY(codigo_curso) REFERENCES curso(codigo_curso)
)

CREATE TABLE palestrante(
codigo_palestrante INT IDENTITY,
nome VARCHAR(250) NOT NULL,
empresa VARCHAR(100) NOT NULL,
PRIMARY KEY(codigo_palestrante)
)

CREATE TABLE palestra(
codigo_palestra INT IDENTITY,
titulo VARCHAR(MAX) NOT NULL,
carga_horaria INT NOT NULL,
data_palestra DATETIME NOT NULL,
codigo_palestrante INT NOT NULL,
FOREIGN KEY (codigo_palestrante) REFERENCES palestrante(codigo_palestrante),
PRIMARY KEY (codigo_palestra)
)

CREATE TABLE alunos_inscritos(
ra CHAR(7) NOT NULL,
codigo_palestra INT NOT NULL,
FOREIGN KEY (ra) REFERENCES aluno(ra),
FOREIGN KEY (codigo_palestra) REFERENCES palestra(codigo_palestra),
PRIMARY KEY (ra, codigo_palestra)
)

CREATE TABLE nao_alunos(
rg VARCHAR(9) NOT NULL,
orgao_exp CHAR(5) NOT NULL,
nome VARCHAR(250) NOT NULL,
PRIMARY KEY(rg, orgao_exp)
)

CREATE TABLE nao_alunos_inscritos(
codigo_palestra INT NOT NULL,
rg VARCHAR(9) NOT NULL,
orgao_exp CHAR(5) NOT NULL,
FOREIGN KEY (codigo_palestra) REFERENCES palestra(codigo_palestra),
FOREIGN KEY (rg, orgao_exp) REFERENCES nao_alunos(rg, orgao_exp),
PRIMARY KEY(rg, orgao_exp)
)

CREATE VIEW v_palestra
AS
SELECT 
aluno.nome AS nome_pessoa,
CONCAT('RA: ', aluno.ra AS num_documento,
palestra.titulo AS titulo_palestra, 
palestrante.nome AS nome_palestrante,
palestra.carga_horaria AS carga_horaria,
palestra.data_palestra AS data_palestra
FROM aluno INNER JOIN alunos_inscritos
ON aluno.ra = alunos_inscritos.ra INNER JOIN palestra
ON alunos_inscritos.codigo_palestra = palestra.codigo_palestra INNER JOIN
palestrante ON palestrante.codigo_palestrante = palestra.codigo_palestrante
UNION
SELECT 
nao_alunos.nome AS nome_pessoa,
CONCAT(nao_alunos.orgao_exp, ' RG: ', nao_alunos.rg ) AS num_documento, 
palestra.titulo AS titulo_palestra, 
palestrante.nome AS nome_palestrante,
palestra.carga_horaria AS carga_horaria,
palestra.data_palestra AS data_palestra
FROM nao_alunos INNER JOIN nao_alunos_inscritos
ON nao_alunos.rg = nao_alunos_inscritos.rg AND nao_alunos.orgao_exp = nao_alunos_inscritos.orgao_exp INNER JOIN palestra
ON nao_alunos_inscritos.codigo_palestra = palestra.codigo_palestra INNER JOIN
palestrante ON palestrante.codigo_palestrante = palestra.codigo_palestrante

SELECT * FROM v_palestra