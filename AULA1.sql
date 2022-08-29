CREATE DATABASE Cometa

USE Cometa

CREATE TABLE motorista (
	codigo INT NOT NULL,
	nome VARCHAR(20),
	naturalidade VARCHAR(15),
	PRIMARY KEY(codigo)
);
 
SELECT * FROM motorista;

CREATE TABLE onibus (
	placa VARCHAR(7),
	marca VARCHAR(8),
	ano INT,
	descriçao VARCHAR(15),
	PRIMARY KEY(placa)
);

SELECT * FROM onibus;

CREATE TABLE viagem(
	codigo INT,
	onibusPlaca VARCHAR(7),
	motoristaCodigo INT,
	hora_de_saida INT NOT NULL CHECK(hora_de_saida >= 0),
	hora_de_chegada INT NOT NULL CHECK(hora_de_chegada >= 0),
	partida VARCHAR(21),
	destino VARCHAR(21),
	PRIMARY KEY (codigo, onibusPlaca, motoristaCodigo),
	FOREIGN KEY (onibusPlaca) REFERENCES onibus (placa),
	FOREIGN KEY (motoristaCodigo) REFERENCES motorista (codigo)
);

SELECT * FROM viagem;

DROP TABLE viagem

SELECT CAST(codigo AS VARCHAR(6)) AS id, nome AS nome FROM motorista
UNION
SELECT placa ,marca FROM onibus

CREATE VIEW v_motorista_onibus 
AS	
SELECT 
CAST(codigo AS VARCHAR(6)) AS id, nome AS nome FROM motorista
UNION
SELECT placa AS nome, marca as id FROM onibus

SELECT id, nome
FROM v_motorista_onibus

/*CREATE VIEW v_descricao_onibus
AS
SELECT
codigo.codigo_viagem AS codigoViagem, motorista.codigo AS motorista, onibus.placa AS placa_onibus, onibus.marca AS marca, onibus.ano AS onibus_ano, onibus.descriçao AS descriçao FROM motorista INNER JOIN viage
*/


