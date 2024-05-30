--Criando banco de dados
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
	[Email] VARCHAR(100) NOT NULL,
    [ValidFrom] DATETIME2 GENERATED ALWAYS AS ROW START,
    [ValidTo] DATETIME2 GENERATED ALWAYS AS ROW END,
    PERIOD FOR SYSTEM_TIME(ValidFrom, ValidTo)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeHistory),
LEDGER = ON);

--Tabela Vazia
SELECT
	* 
FROM
	Employee

--Inserindo Dados
INSERT Employee (EmployeeID,Name,Position,Department,AnnualSalary,email) VALUES 
(1,'Vitor','DBA', 'IT',1000,'vitor.fava@vitadbsolutions.com'),
(2,'Juliene','CFO', 'Finance',10000,'juliene.ramos@vitadbsolutions.com'),
(3,'Maria','CEO', 'Managemant',500000,'maria@vitadbsolutions.com')

--Atualizando dados da tabela Ledger
UPDATE Employee SET AnnualSalary = 20000 WHERE Name = 'Juliene'
UPDATE Employee SET Department = 'Data Analytics' WHERE Name = 'Vitor'

--Inserindo Dados com outro login
INSERT Employee (EmployeeID,Name,Position,Department,AnnualSalary, email) VALUES 
(4,'Helena','DBA Jr', 'IT',1000, 'helena@vitadbsolutions.com'),
(5,'Tobias','Desenvolvedor', 'IT',1000, 'tobias@vitadbsolutions.com'),
(6,'Tadeu','Desenvolvedor', 'IT',1000, 'tadeu@vitadbsolutions.com')

--Identificando quais foram as operações realizadas (INSERT/UPDATE/DELETE)
SELECT e.EmployeeID,
       e.[Name],
       e.Position,
       e.Department,
       e.AnnualSalary,
       e.email,
       dlt.transaction_id,
       dlt.commit_time,
       dlt.principal_name,
       e.ledger_operation_type_desc
FROM sys.database_ledger_transactions dlt
    INNER JOIN dbo.Employee_Ledger e
        ON e.ledger_transaction_id = dlt.transaction_id
--ORDER BY dlt.commit_time DESC;
ORDER BY e.EmployeeID ASC;
GO