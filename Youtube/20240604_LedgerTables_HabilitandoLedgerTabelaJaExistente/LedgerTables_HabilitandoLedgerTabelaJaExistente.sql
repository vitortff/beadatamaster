--Criando o banco de dados
CREATE DATABASE VitaDB
GO
USE VitaDB
GO
--Criando uma tabela "normal"
CREATE TABLE dbo.Employee (
    [EmployeeID] INT NOT NULL PRIMARY KEY CLUSTERED,
    [Name] NVARCHAR(100) NOT NULL,
    [Position] VARCHAR(100) NOT NULL,
    [Department] VARCHAR(100) NOT NULL,
    [AnnualSalary] DECIMAL(10, 2) NOT NULL,
	[Email] VARCHAR(100) NOT NULL)

--Inserindo alguns registros
INSERT Employee (EmployeeID,Name,Position,Department,AnnualSalary,email) VALUES 
(1,'Vitor','DBA', 'IT',1000,'vitor.fava@vitadbsolutions.com'),
(2,'Juliene','CFO', 'Finance',10000,'juliene.ramos@vitadbsolutions.com'),
(3,'Maria','CEO', 'Managemant',500000,'maria@vitadbsolutions.com'),
(4,'Helena','DBA Jr', 'IT',1000, 'helena@vitadbsolutions.com'),
(5,'Tobias','Desenvolvedor', 'IT',1000, 'tobias@vitadbsolutions.com'),
(6,'Tadeu','Desenvolvedor', 'IT',1000, 'tadeu@vitadbsolutions.com')

--Tabela normal populada
SELECT * FROM dbo.Employee

--Criando a nova tabela Ledger
CREATE TABLE dbo.Employee_LedgerTable (
    [EmployeeID] INT NOT NULL PRIMARY KEY CLUSTERED,
    [Name] NVARCHAR(100) NOT NULL,
    [Position] VARCHAR(100) NOT NULL,
    [Department] VARCHAR(100) NOT NULL,
    [AnnualSalary] DECIMAL(10, 2) NOT NULL,
	[Email] VARCHAR(100) NOT NULL)
    WITH 
    (
      SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Employee_LedgerTableHistory),
      LEDGER = ON
    ); 

--Tabela ledger vazia
SELECT * FROM dbo.Employee_LedgerTable

--Movimentando os dados da tabela "antiga" para a tabela "nova"
EXEC sp_copy_data_in_batches 
	@source_table_name = N'Employee' , 
	@target_table_name = N'Employee_LedgerTable'

--Comparando as tabelas
SELECT * FROM dbo.Employee
SELECT * FROM dbo.Employee_LedgerTable


--Atualizando dados da nova tabela Ledger
UPDATE Employee_LedgerTable SET AnnualSalary = 20000 WHERE Name = 'Juliene'
UPDATE Employee_LedgerTable SET Department = 'Data Analytics' WHERE Name = 'Vitor'

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
    INNER JOIN dbo.Employee_LedgerTable_Ledger e
        ON e.ledger_transaction_id = dlt.transaction_id
ORDER BY dlt.commit_time DESC;
--ORDER BY e.EmployeeID ASC;
GO
