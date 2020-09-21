CREATE DATABASE dinamica
GO
USE dinamica


CREATE TABLE tenis(
idProduto INT IDENTITY NOT NULL,
descricao VARCHAR(100),
cor VARCHAR(30),
tamanho INT)

CREATE TABLE camiseta(
idProduto INT IDENTITY NOT NULL,
descricao VARCHAR(100),
cor VARCHAR(30),
tamanho VARCHAR(3))

CREATE PROCEDURE sp_insereproduto
	(@id INT, @descricao VARCHAR(100), @cor VARCHAR(30),
		@TAMANHO VARCHAR(3), @saida VARCHAR(MAX) OUTPUT)
AS

	DECLARE @tam INT
	DECLARE @tabela VARCHAR(10)
	DECLARE @query VARCHAR(max)
	
	SET @tabela = 'tenis'

	BEGIN TRY
		SET @tam = CAST (@tamanho AS INT)
	END TRY
	BEGIN CATCH
		SET @tabela = 'camiseta'
	END CATCH

	SET @query = 'INSERT INTO '+@tabela+' VALUES'+
		'('+CAST(@id AS VARCHAR(4))+','''+@descricao+''','''+@cor+''','''+@tamanho+''')'
	
	EXEC (@query)
	SET @saida = 'Inserido com sucesso!'

DECLARE @out VARCHAR(MAX)
EXEC sp_insereproduto 1, 'Regata','Azul','GG', @out OUTPUT
PRINT @out

DECLARE @out VARCHAR(MAX)
EXEC sp_insereproduto 1, 'Casual','Roxo','42', @out OUTPUT
PRINT @out

select * from camiseta
select * from tenis


/*
Exercício:

Considere a tabela Produto com os seguintes atributos:
 Produto (Codigo | Nome | Valor)

Considere a tabela ENTRADA e a tabela SAÍDA com os seguintes atributos:
 (Codigo_Transacao | Codigo_Produto | Quantidade | Valor_Total)

Cada produto que a empresa compra, entra na tabela ENTRADA. Cada produto que a empresa vende, entra na tabela SAIDA.
Criar uma procedure que receba um código (‘e’ para ENTRADA e ‘s’ para SAIDA),  criar uma exceção de erro para código inválido, 
receba o codigo_transacao, codigo_produto e a quantidade e preencha a tabela correta, com o valor_total de cada transação de cada produto.
*/

/*CREATE PROCEDURE Trouble
 --(s.@saida, e.@entrada) 
Empresa compra > TABLE Entrada
 CREATE PROCEDURE Entrada
Empresa vende > TABLE Saída
 CREATE PROCEDURE Saida
*/

CREATE TABLE Produto
(iD INT,
 NomeProduto VARCHAR(50),
 ValorProduto FLOAT)

CREATE TABLE ENTRADA
(IDTransaçao INT IDENTITY NOT NULL,
 idProduto INT,
 Qtd INT,
 Valor_total FLOAT,
 Cod VARCHAR(1))

CREATE TABLE SAIDA
(IDTransaçao INT IDENTITY NOT NULL,
 idProduto INT,
 Qtd INT,
 Valor_Total FLOAT,
 Cod VARCHAR(1))

CREATE PROCEDURE Empresa
		(e.@entrada, s.@saida, @cod)
AS

 DECLARE @cod VARCHAR(1)

 BEGIN TRY
	@cod BETWEEN e AND s
 END TRY
 BEGIN CATCH
  ERROR_PROCEDURE() AS ErrorProc,
  ERROR_LINE() AS ErrorLine,
  ERROR_MESSAGE() AS ErrorMessage;
 END CATCH

SELECT * FROM TABLE ENTRADA WHERE @cod = e
SELECT * FROM TABLE SAIDA WHERE @cod = s

GO

EXECUTE Empresa @cod