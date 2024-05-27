-- Consulta sem índice coberto
SELECT Name, ProductNumber, ListPrice, StandardCost
FROM Production.Product
WHERE Name LIKE 'Mountain%';

-- Criação de um Covered Index no AdventureWorks
CREATE INDEX idx_CoveredIndex_Product
ON Production.Product (Name)
INCLUDE (ProductNumber, ListPrice, StandardCost);

-- Consulta otimizada com índice coberto
SELECT Name, ProductNumber, ListPrice, StandardCost
FROM Production.Product
WHERE Name LIKE 'Mountain%';