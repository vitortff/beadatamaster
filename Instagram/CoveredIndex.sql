-- Consulta sem �ndice coberto
SELECT Name, ProductNumber, ListPrice, StandardCost
FROM Production.Product
WHERE Name LIKE 'Mountain%';

-- Cria��o de um Covered Index no AdventureWorks
CREATE INDEX idx_CoveredIndex_Product
ON Production.Product (Name)
INCLUDE (ProductNumber, ListPrice, StandardCost);

-- Consulta otimizada com �ndice coberto
SELECT Name, ProductNumber, ListPrice, StandardCost
FROM Production.Product
WHERE Name LIKE 'Mountain%';