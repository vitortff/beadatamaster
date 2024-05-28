--1) Se criar uma nova coluna, j� � automaticamente incluida no processo de auditoria?

--2) Como saber quem foi que alterou a informa��o?

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

--Listando as transa��es realizadas na tabela Ledger (INSERT)
SELECT 
	* 
FROM 
	Employee
FOR SYSTEM_TIME ALL

--Atualizando dados da tabela Ledger com outro login
UPDATE Employee SET AnnualSalary = 20000 WHERE Name = 'Juliene'
UPDATE Employee SET Department = 'Data Analytics' WHERE Name = 'Vitor'

--Listando as transa��es realizadas na tabela Ledger (UPDATE)
SELECT 
	* 
FROM 
	Employee
FOR SYSTEM_TIME ALL

--Adicionando uma nova coluna
ALTER TABLE dbo.Employee ADD email VARCHAR(100) NULL

--Inserindo Dados
INSERT Employee (EmployeeID,Name,Position,Department,AnnualSalary, email) VALUES 
(4,'Helena','DBA Jr', 'IT',1000, 'helena@vitadbsolutions.com'),
(5,'Tobias','Desenvolvedor', 'IT',1000, 'tobias@vitadbsolutions.com'),
(6,'Tadeu','Desenvolvedor', 'IT',1000, 'tadeu@vitadbsolutions.com')

--Listando as transa��es realizadas na tabela Ledger (UPDATE)
SELECT 
	* 
FROM 
	Employee
FOR SYSTEM_TIME ALL

--Identificando quem realizou a transa��o
SELECT
	t.[commit_time] AS [CommitTime], 
	E.*,
	--t.principal_name
	t.*
 FROM dbo.Employee E
 JOIN sys.database_ledger_transactions t
 ON t.transaction_id = E.ledger_start_transaction_id
 ORDER BY t.commit_time DESC;