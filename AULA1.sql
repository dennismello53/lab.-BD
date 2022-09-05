CREATE DATABASE Cometa

USE Cometa

CREATE TABLE motorista (
	codigo INT NOT NULL,
	nome VARCHAR(20),
	naturalidade VARCHAR(15),
	PRIMARY KEY (codigo),
);

 
SELECT * FROM motorista;

CREATE TABLE onibus (
	placa VARCHAR(9),
	marca VARCHAR(8),
	ano INT,
	descriçao VARCHAR(15),
	PRIMARY KEY(placa)
);

SELECT * FROM onibus;

CREATE TABLE viagem(
	codigo INT,
	onibusPlaca VARCHAR(9),
	motoristaCodigo INT,
	hora_de_saida INT NOT NULL CHECK(hora_de_saida >= 0),
	hora_de_chegada INT NOT NULL CHECK(hora_de_chegada >= 0),
	partida VARCHAR(21),
	destino VARCHAR(21),
	PRIMARY KEY (codigo, onibusPlaca, motoristaCodigo),
	FOREIGN KEY (onibusPlaca) REFERENCES onibus (placa),
	FOREIGN KEY (motoristaCodigo) REFERENCES motorista (codigo),

);

SELECT * FROM viagem;

SELECT CAST(codigo AS VARCHAR(6)) AS id, nome AS nome FROM motorista
UNION
SELECT placa ,marca FROM onibus

CREATE VIEW v_motorista_onibus 
AS	
SELECT 
CAST(codigo AS VARCHAR(6)) AS id, nome AS nome FROM motorista
UNION
SELECT placa AS nome, marca as id FROM onibus

CREATE VIEW v_descricao_onibus
AS
SELECT v.codigo, m.nome AS nomeMotorista,
LEFT(v.onibusPlaca,3) + '-' + SUBSTRING(v.onibusPlaca, 4, 4) AS onibusPlaca,
o.marca, o.ano, o.descriçao
FROM viagem v
LEFT JOIN onibus o
ON v.onibusPlaca = o.placa 
LEFT JOIN motorista m
ON v.motoristaCodigo = m.codigo

CREATE VIEW v_descricao_viagem 
AS
SELECT viagem.codigo, 
LEFT(viagem.onibusPlaca,3) + '-' + SUBSTRING(viagem.onibusPlaca, 4, 4) AS onibusPlaca, 
CAST(viagem.hora_de_saida AS varchar) + ':' + '00' AS hora_de_saida,
CAST(viagem.hora_de_chegada AS varchar) + ':' + '00' AS hora_de_chegada,
viagem.partida, viagem.destino FROM viagem

DROP VIEW v_descricao_viagem 

SELECT *
FROM v_motorista_onibus

SELECT *
FROM v_descricao_onibus  

SELECT * 
FROM v_descricao_viagem

