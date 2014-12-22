Use DynamicsAXProd;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO

ALTER PROCEDURE [EIZO_UK_Parts_Import]
AS 
DECLARE @sDeliveryNote VARCHAR(100);
DECLARE @sSalesOrderNumber VARCHAR(30);
DECLARE @sCustomerOrderNumber VARCHAR(100);
DECLARE @sCustomerNo VARCHAR(10);
DECLARE @sCustomerName VARCHAR(120);
DECLARE @sPartNumber VARCHAR(50);
DECLARE @sPartDescription VARCHAR(60);
DECLARE @sSerialNumber VARCHAR(30);
DECLARE @sWarehouseProvider VARCHAR(120);
DECLARE @dDeliveryDate datetime;
DECLARE @sInvoiceNumber VARCHAR(60);

DECLARE @UserName VARCHAR(5);
set @UserName = 'Excel';
DECLARE @DataAreaID VARCHAR(4);
set @DataAreaID = 'uk';
DECLARE @iRecID Bigint;

ALTER TABLE Eizo_SerNum$ ALTER COLUMN [Delivery Note] NVARCHAR(100);
ALTER TABLE Eizo_SerNum$ ALTER COLUMN [Sales Order Number] NVARCHAR(30);
ALTER TABLE Eizo_SerNum$ ALTER COLUMN [Customer Order Number] NVARCHAR(100);
ALTER TABLE Eizo_SerNum$ DROP COLUMN [Inter company];
ALTER TABLE Eizo_SerNum$ ALTER COLUMN [Customer No] NVARCHAR(10);
ALTER TABLE Eizo_SerNum$ ALTER COLUMN [Customer Name] NVARCHAR(120);
ALTER TABLE Eizo_SerNum$ ALTER COLUMN [Part Number] NVARCHAR(50);
ALTER TABLE Eizo_SerNum$ ALTER COLUMN [Part Description] NVARCHAR(60);
ALTER TABLE Eizo_SerNum$ ALTER COLUMN [Serial Number] NVARCHAR(30);
ALTER TABLE Eizo_SerNum$ ALTER COLUMN [Warehouse Provider] NVARCHAR(120);
ALTER TABLE Eizo_SerNum$ DROP COLUMN [EndUser Number];
ALTER TABLE Eizo_SerNum$ DROP COLUMN [EndUser Name];
ALTER TABLE Eizo_SerNum$ DROP COLUMN [EndUser Address];
ALTER TABLE Eizo_SerNum$ DROP COLUMN [EndUser Country];
ALTER TABLE Eizo_SerNum$ DROP COLUMN [EndUser ZipCode];
ALTER TABLE Eizo_SerNum$ DROP COLUMN [EndUser City];
ALTER TABLE Eizo_SerNum$ ALTER COLUMN [Invoice Number] NVARCHAR(60);

DECLARE Cur CURSOR FOR
	SELECT [Delivery Note], [Sales Order Number], [Customer Order Number]
      , [Customer No], [Customer Name], [Part Number]
      , [Part Description], [Serial Number], [Warehouse Provider]
      ,[Delivery Date], [Invoice Number]
	FROM [Eizo_SerNum$];
OPEN Cur;
FETCH NEXT FROM Cur INTO @sDeliveryNote, @sSalesOrderNumber, @sCustomerOrderNumber
	, @sCustomerNo, @sCustomerName, @sPartNumber
	, @sPartDescription, @sSerialNumber, @sWarehouseProvider
	, @dDeliveryDate, @sInvoiceNumber;

WHILE @@FETCH_STATUS = 0
	BEGIN
	/* Calculate RecID manually */
	SELECT @iRecID = MAX( RecID ) + 1 FROM [C_SERIALNUMBERS];
	
	/* Actual insert */
	INSERT INTO [C_SERIALNUMBERS] (
	[SerNum], [ItemID], Trx_Dt, SalesOrderNo, CustomerName, Trx_Dt2, Trx_Dt2TzId, SupportCoverage, VirtualSN
	, SiteName, Solution, EndDate, EndDateTzID, PurchasePrice, Customer, ModifiedDateTime, ModifiedBy, CreatedDateTime, CreatedBy
	, DataAreaID, RecVersion, RecID, [InvNum], MfgSerialNum, [ItemName], BomID, SupDeclined )
	VALUES( @sSerialNumber, @sPartNumber, @dDeliveryDate
		, @sSalesOrderNumber, @sCustomerName, @dDeliveryDate
		, 0, '', @sDeliveryNote
		, @sWarehouseProvider, @sCustomerOrderNumber, DATEADD( YEAR, 3, CONVERT( datetime, @dDeliveryDate ))
		, 0, 0, @sCustomerNo		
		, GETDATE(), @UserName, GETDATE()
		, @UserName, @DataAreaID, 1
		, @iRecID, @sInvoiceNumber, ''
		, @sPartDescription, '', 0		
		);
	/* Fetch next record from cursor */	
	FETCH NEXT FROM Cur INTO @sDeliveryNote, @sSalesOrderNumber, @sCustomerOrderNumber
		, @sCustomerNo, @sCustomerName, @sPartNumber
		, @sPartDescription, @sSerialNumber, @sWarehouseProvider
		, @dDeliveryDate, @sInvoiceNumber;
	END
CLOSE Cur;
DEALLOCATE Cur; 

