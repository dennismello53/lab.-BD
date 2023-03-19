CREATE DATABASE IRF
GO
USE IRF
GO

CREATE TABLE cliente(
    cpf             CHAR(11) NOT NULL PRIMARY KEY,
    nome            VARCHAR(100) NOT NULL,
    email           VARCHAR(200) NOT NULL,
    limite_credito  DECIMAL(7, 2) NOT NULL,
    dt_nasc             DATE
);

CREATE PROCEDURE sp_inserircliente(
    @cpf CHAR(11),
    @nome VARCHAR(100),
    @email VARCHAR(200),
    @limite_credito DECIMAL(7, 2),
    @dt_nasc DATE)
AS
BEGIN
    DECLARE @count INT,
            @f_digit INT,
            @s_digit INT,
            @aux INT,
            @y INT

    SET @count = 1
    SET @aux = 10
    SET @cpf = SUBSTRING(@cpf, 1, 9)

    SET @f_digit = 0
    WHILE @count < 10
    BEGIN
        SET @y = SUBSTRING(@cpf, @count, 1)
        SET @f_digit = @f_digit + @y * @aux
        SET @count = @count + 1
        SET @aux = @aux - 1
    END

    SET @f_digit = @f_digit % 11
    IF @f_digit = 0 OR @f_digit = 1
    BEGIN
        SET @f_digit = 0
    END
    ELSE
    BEGIN
        SET @f_digit = 11 - @f_digit
    END

    SET @cpf = @cpf + CAST(@f_digit AS char)

    SET @count = 1
    SET @aux = 11

    SET @s_digit = 0
    WHILE @count < 11
    BEGIN
        SET @y = SUBSTRING(@cpf, @count, 1)
        SET @s_digit = @s_digit + @y * @aux
        SET @count = @count + 1
        SET @aux = @aux - 1
    END

    SET @s_digit = @s_digit % 11
    IF @s_digit = 0 OR @s_digit = 1
    BEGIN
        SET @s_digit = 0
    END
    ELSE
    BEGIN
        SET @s_digit = 11 - @s_digit
    END

    SET @cpf = @cpf + CAST(@s_digit AS char)

    IF CAST(@f_digit AS VARCHAR(1)) + CAST(@s_digit AS VARCHAR(1)) = RIGHT(@cpf, 2)
    BEGIN
        INSERT INTO cliente (cpf, nome, email, limite_credito, dt_nasc)
            VALUES (@cpf, @nome, @email, @limite_credito, @dt_nasc)
    END
    ELSE
    BEGIN
        RAISERROR ('CPF não é válido', 16, 1);
    END
END;




EXEC sp_inserircliente '222333666', 'Dennis', 'dennis@example.com', 23.20, '2022-03-19';

SELECT * FROM cliente