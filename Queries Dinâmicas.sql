CREATE PROCEDURE sp_transacao(@codigo VARCHAR(5), @codigo_transacao INT, @codigo_produto INT, @quantidade INT)   

AS     

DECLARE @valor_total AS DECIMAL(7,2),    
@query VARCHAR(MAX),  
@tabela	VARCHAR(7),  
@erro	VARCHAR(MAX)  

SET @valor_total = (SELECT valor FROM produto WHERE codigo = @codigo_produto) * @quantidade  

IF (LOWER(@codigo) = 'e')  
	BEGIN  
		SET @tabela = 'entrada'  
	END

ELSE  
	BEGIN  
		IF(LOWER(@codigo) = 's')  
	BEGIN   
		SET @tabela = 'saida'  
END   
	ELSE   
		BEGIN  
			RAISERROR('Código inválido', 16, 1)  
	END   
END    

BEGIN TRY  

	SET @query = 'INSERT INTO '+@tabela+' VALUES (' + CAST(@codigo_transacao AS VARCHAR(5))  
		+','+ CAST(@codigo_produto AS VARCHAR(5)) +','+ CAST(@quantidade AS VARCHAR(5)) +','+  
			CAST(@valor_total AS VARCHAR(20))+')'  
	EXEC (@query)  

END TRY  

BEGIN CATCH  
	SET @erro = ERROR_MESSAGE()  
		IF (@erro LIKE '%primary%')  
			BEGIN  
				RAISERROR('Código de transação duplicado', 16, 1)  
			END  
		ELSE  

  

BEGIN  
RAISERROR('Erro de processamento', 16, 1)  
END  
END CATCH  