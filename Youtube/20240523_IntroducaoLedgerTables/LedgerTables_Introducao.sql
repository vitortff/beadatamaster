--Podemos criar o banco de dados com todas as tabelas já criadas sendo Ledger Tables
--CREATE DATABASE VitaDB WITH LEDGER = ON;
GO
--Banco de dados "normal"
CREATE DATABASE VitaDB
GO
USE VitaDB
--Criando a tabela Ledger
CREATE TABLE dbo.Employee (
    [EmployeeID] INT NOT NULL PRIMARY KEY CLUSTERED,
    [Name] NVARCHAR(100) NOT NULL,
    [Position] VARCHAR(100) NOT NULL,
    [Department] VARCHAR(100) NOT NULL,
    [AnnualSalary] DECIMAL(10, 2) NOT NULL,
    [ValidFrom] DATETIME2 GENERATED ALWAYS AS ROW START,
    [ValidTo] DATETIME2 GENERATED ALWAYS AS ROW END,
    PERIOD FOR SYSTEM_TIME(ValidFrom, ValidTo)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeHistory),
LEDGER = ON);

--Inserindo Dados
INSERT Employee (EmployeeID,Name,Position,Department,AnnualSalary) VALUES 
(1,'Vitor','DBA', 'IT',1000),
(2,'Juliene','CFO', 'Finance',10000),
(3,'Maria','CEO', 'Managemant',500000)

--Listando as transações realizadas na tabela Ledger (INSERT)
SELECT 
	* 
FROM 
	Employee
FOR SYSTEM_TIME ALL

--Atualizando dados da tabela Ledger
UPDATE Employee SET AnnualSalary = 20000 WHERE Name = 'Juliene'
UPDATE Employee SET Department = 'Data Analytics' WHERE Name = 'Vitor'

--Listando as transações realizadas na tabela Ledger (UPDATE)
SELECT 
	* 
FROM 
	Employee
FOR SYSTEM_TIME ALL

--Adicionando uma nova coluna
ALTER TABLE dbo.Employee ADD email VARCHAR(100) NULL

--Identificando quem realizou a transação
SELECT
	t.[commit_time] AS [CommitTime], 
	E.*,
	t.principal_name
 FROM dbo.Employee E
 JOIN sys.database_ledger_transactions t
 ON t.transaction_id = E.ledger_start_transaction_id
 ORDER BY t.commit_time DESC;