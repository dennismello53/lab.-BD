CREATE DATABASE revisaoSemestrePassado
GO
USE revisaoSemestrePassado

CREATE TABLE alunos(							
ra	INT NOT NULL,
nome VARCHAR(50),
idade INT NOT NULL CHECK(idade > 0)
PRIMARY KEY (ra)
)

CREATE TABLE disciplinas(		
codigoDisc INT NOT NULL,
nome VARCHAR(50),
cargaHoraria INT NOT NULL CHECK(cargaHoraria > =32)
PRIMARY KEY (codigoDisc)
)

CREATE TABLE professor(
registroProf INT NOT NULL,
nome VARCHAR(50),
titulacao INT NOT NULL
PRIMARY KEY (registroProf)
)

CREATE TABLE curso(
codigoCurso INT NOT NULL,
nome VARCHAR(50),
area VARCHAR(50)
PRIMARY KEY (codigoCurso)
)

CREATE TABLE titulacao(	
codigoTitula INT NOT NULL,
Titulo VARCHAR(50)
PRIMARY KEY (codigoTitula)
)

CREATE TABLE alunoDisciplina(
codigoDisciplina INT NOT NULL,
raAluno INT NOT NULL,
PRIMARY KEY (codigoDisciplina,raAluno),
FOREIGN KEY (codigoDisciplina) REFERENCES disciplinas (codigoDisc),
FOREIGN KEY (raAluno) REFERENCES alunos (ra)
)

CREATE TABLE professorDisciplina(
codigoDisciplina INT NOT NULL,
registroProfessor INT NOT NULL,
PRIMARY KEY (codigoDisciplina,registroProfessor),
FOREIGN KEY (codigoDisciplina) REFERENCES disciplinas (codigoDisc),
FOREIGN KEY (registroProfessor) REFERENCES professor (registroProf)
)

CREATE TABLE disciplinaCurso(
codigoDisciplina INT NOT NULL,	
codigoCurso INT NOT NULL,
PRIMARY KEY (codigoDisciplina,codigoCurso),
FOREIGN KEY (codigoDisciplina) REFERENCES disciplinas (codigoDisc),
FOREIGN KEY (codigoCurso) REFERENCES curso(codigoCurso)
)

--A coluna idade na tabela aluno não é apropriada. Alterar a tabela criando uma coluna Ano_Nascimento INT.	
ALTER TABLE alunos ADD anoNasc INT
SELECT * FROM alunos

--Atualizar a coluna Ano_Nascimento usando uma única expressão, com DATEADD e GETDATE, inserindo apenas o ano.	
UPDATE alunos
SET anoNasc = CAST(YEAR(GETDATE()) AS INT) - idade
select * from alunos

--Excluir a coluna idade	
ALTER TABLE alunos drop column idade


--Como fazer as listas de chamadas, com RA e nome por disciplina ?		
SELECT alunos.ra, alunos.nome, disciplinas.nome
FROM alunos INNER JOIN alunoDisciplina
ON alunos.ra = alunoDisciplina.raAluno
INNER JOIN disciplinas
ON disciplinas.codigoDisc = alunoDisciplina.codigoDisciplina
ORDER BY disciplinas.nome, alunos.nome

--Fazer uma pesquisa que liste o nome das disciplinas e o nome dos professores que as ministram	
SELECT disciplinas.nome, professor.nome
FROM disciplinas INNER JOIN professorDisciplina
ON disciplinas.codigoDisc = professorDisciplina.codigoDisciplina
INNER JOIN professor
ON professor.registroProf = professorDisciplina.registroProfessor

--Fazer uma pesquisa que , dado o nome de uma disciplina, retorne o nome do curso
SELECT curso.nome
FROM disciplinas INNER JOIN disciplinaCurso
ON disciplinas.codigoDisc = disciplinaCurso.codigoDisciplina
INNER JOIN curso
ON disciplinaCurso.codigoCurso = curso.codigoCurso
WHERE disciplinas.nome= 'Laboratório de Banco de Dados'

/*Fazer uma pesquisa que, dado o nome de uma disciplina, retorne o nome do professor.  Só deve 
retornar de disciplinas que tenham, no mínimo, 5 alunos matriculados*/	
SELECT disciplinas.nome, professor.nome, COUNT(professor.nome) as quantidadeAlunos
FROM disciplinas INNER JOIN professorDisciplina
ON disciplinas.codigoDisc = professorDisciplina.codigoDisciplina
INNER JOIN professor
ON professor.registroProf = professorDisciplina.registroProfessor
INNER JOIN alunoDisciplina
ON alunoDisciplina.codigoDisciplina = professorDisciplina.codigoDisciplina
WHERE disciplinas.nome = 'Gestão de Estoques'
GROUP BY professor.nome, disciplinas.nome
HAVING COUNT(professor.nome)> 4
