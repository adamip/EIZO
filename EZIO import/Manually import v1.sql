USE DynamicsAXProd;

/* Create Table */
Create Table Eizo_SerNum (
SerNum nvarchar(30) NOT NULL,
InvNum nvarchar(50) NOT NULL,
ItemID nvarchar(50) NOT NULL, 
ItemName nvarchar(60) NOT NULL 
);
ALTER TABLE Eizo_SerNum
	ADD CONSTRAINT Eizo_SN
	PRIMARY KEY( SerNum ); 

/* Clean up before importing */	
DELETE FROM Eizo_SerNum$; 	
	
/* 	rename Excel sheet name to Eizo_SerNum
	Delete the dummy first row from Excel, if any.  The 1st row must be "Title" row
	All program -> SQL Server -> Import and Export Data (32-bit) 
	Import
	Create a temporary table	called Eizo_SerNum$
	*/
	
/*	Delete any NULL row */
SELECT * FROM Eizo_SerNum$ WHERE [Serial Number] IS NULL; 
DELETE FROM Eizo_SerNum$ WHERE [Serial Number] IS NULL; 
	
/* validate if there are any duplicate Serial Number in Eizo_SerNum$ 
   For example */	
SELECT COUNT(*), [Serial Number]  FROM Eizo_SerNum$ GROUP BY [Serial Number] HAVING COUNT(*) > 1 ;   
SELECT * FROM Eizo_SerNum$ WHERE [Serial Number] LIKE '18102500215001';

UPDATE Eizo_SerNum$ SET [Serial Number] = '18102500215001.2'
WHERE [Serial Number] = '18102500215001' AND [Sales ORDER NUMBER] LIKE 'A2010111629'

/* Validate */
SELECT * FROM [DynamicsAxProd].[dbo].[Eizo_SerNum]

/* Actual insert */
EXEC [EIZO_DE_Parts_Import];




