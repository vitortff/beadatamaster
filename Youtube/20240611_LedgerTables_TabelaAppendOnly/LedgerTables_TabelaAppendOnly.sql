--Criando o banco de dados
CREATE DATABASE VitaDB
GO
--Criando a tabela append-only
USE VitaDB
GO
CREATE SCHEMA [AccessControl];
GO
CREATE TABLE [AccessControl].[KeyCardEvents]
   (
      [EmployeeID] INT NOT NULL,
      [AccessOperationDescription] NVARCHAR (1024) NOT NULL,
      [Timestamp] Datetime2 NOT NULL
   )
   WITH (LEDGER = ON (APPEND_ONLY = ON));
 GO
INSERT INTO [AccessControl].[KeyCardEvents]
VALUES ('43869', 'Building42', '2020-05-02T19:58:47.1234567');
GO

--Mesmo sendo sysadmin não é possível alterar os dados da tabela append-only
UPDATE [AccessControl].[KeyCardEvents] SET [EmployeeID] = 34184;