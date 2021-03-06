/*
	PLT020 - Função para retornar somente número OnlyNumber - oNumber
	Create By Bitts
	(13/11/2015)
	
	UTILIZAÇÃO: SELECT dbo.oNumber(E.TELEFONE1) FROM PPESSOA
*/
CREATE FUNCTION [dbo].[oNumber](@TEXTO VARCHAR(8000)) RETURNS VARCHAR(8000) AS
BEGIN
	DECLARE
		@RESULTADO VARCHAR (8000),
		@LETRA CHAR(1),
		@NUMERO INT,
		@CONT INT,
		@ZERO INT,
		@NOVE INT
	 
	SELECT
		@RESULTADO = '',
		@CONT = 0,
		@ZERO = UNICODE(0),
		@NOVE = UNICODE(9),
		@NUMERO = LEN(@TEXTO)
	 
	WHILE @CONT < @NUMERO
	BEGIN
		SET @CONT = @CONT + 1
		SET @LETRA = SUBSTRING(@TEXTO, @CONT, 1)
	 
		IF UNICODE(@LETRA) BETWEEN @ZERO AND @NOVE
		BEGIN
			SET @RESULTADO = @RESULTADO + @LETRA
		END
	END
	SET @RESULTADO = @RESULTADO
	RETURN @RESULTADO
END;
