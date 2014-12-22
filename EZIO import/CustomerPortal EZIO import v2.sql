Use DynamicsAXProd;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO

ALTER PROCEDURE [EIZO_DE_Parts_Import]
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
DECLARE @sSupportCoverage VARCHAR(20);


DECLARE @UserName VARCHAR(5);
SET @UserName = 'Excel';
DECLARE @sDataAreaID VARCHAR(4);
SET @sDataAreaID = 'de';
SET @sSupportCoverage = 'EIZO-470969';
DECLARE @iRecID1 Bigint, @iRecID2 Bigint;

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
	SELECT @iRecID1 = MAX( RecID ) + 1 FROM [C_SERIALNUMBERS];
	
	/* Actual insert */   
	INSERT INTO [C_SERIALNUMBERS] (
	[SerNum], [ItemID], Trx_Dt, SalesOrderNo, CustomerName, Trx_Dt2, Trx_Dt2TzId, SupportCoverage, VirtualSN
	, SiteName, Solution, EndDate, EndDateTzID, PurchasePrice, Customer, ModifiedDateTime, ModifiedBy, CreatedDateTime, CreatedBy
	, DataAreaID, RecVersion, RecID, [InvNum], MfgSerialNum, [ItemName], BomID, SupDeclined )
	VALUES( @sSerialNumber, @sPartNumber, @dDeliveryDate
		, @sSalesOrderNumber, @sCustomerName, @dDeliveryDate
		, 0, @sSupportCoverage, @sDeliveryNote
		, @sWarehouseProvider, @sCustomerOrderNumber, DATEADD( YEAR, 3, CONVERT( datetime, @dDeliveryDate ))
		, 0, 0, @sCustomerNo		
		, GETDATE(), @UserName, GETDATE()
		, @UserName, @sDataAreaID, 1
		, @iRecID1, @sInvoiceNumber, ''
		, @sPartDescription, '', 0		
		); 
		
	/* Calculate RecID manually */
	SELECT @iRecID2 = MAX( RecID ) + 1 FROM [C_CONTRACTITEMS];
	/* Actual insert */
	INSERT INTO [C_CONTRACTITEMS] ( [SN], [SOLUTION], [ITEMID], [QUANTITY]
           , [VIRTUALSN], [SUPPORTCOVERAGE], [CONTRACTID], [STARTDATE]
           , [STARTDATETZID], [ENDDATE], [ENDDATETZID], [SOLDONORDERNO]
           , [PURCHASEPRICE], [SITES], [SITENAME]
		   , [ACTIVE]
           , [CUSTOMERNAME], [ENDUSERNAME], [MODIFIEDDATETIME], [MODIFIEDBY]
           , [CREATEDDATETIME], [CREATEDBY], [DATAAREAID], [RECVERSION]
           , [RECID], [DESCRIPTION], [INVNUM], [PRODID]
           , [BOMID], [PARENTITEMINFO], [SUPDECLINED], [T_PARENT]
           , [T_ORDER] )
	VALUES( @sSerialNumber, LEFT( @sCustomerOrderNumber, 30 ), @sPartNumber, 1
		, LEFT( @sDeliveryNote, 20 ), @sSupportCoverage, LEFT( @sInvoiceNumber, 11 ), @dDeliveryDate
		, 0, DATEADD( YEAR, 3, CONVERT( datetime, @dDeliveryDate )), 0, LEFT( @sCustomerOrderNumber, 10 )
		, 0, 0, LEFT( @sWarehouseProvider, 30 )
		, CASE WHEN DATEADD( YEAR, 3, CONVERT( datetime, @dDeliveryDate )) >= GETDATE() THEN 1 ELSE 0 END
		, LEFT( @sCustomerName, 30 ), '', GETDATE(), @UserName
		, GETDATE(), @UserName, @sDataAreaID, 0
		, @iRecID2, @sPartDescription, LEFT( @sInvoiceNumber, 30 ), ''
		, '', '', 0, 0
		, 0 );
		
	/* Fetch next record from cursor */	
	FETCH NEXT FROM Cur INTO @sDeliveryNote, @sSalesOrderNumber, @sCustomerOrderNumber
		, @sCustomerNo, @sCustomerName, @sPartNumber
		, @sPartDescription, @sSerialNumber, @sWarehouseProvider
		, @dDeliveryDate, @sInvoiceNumber;
	END
CLOSE Cur;
DEALLOCATE Cur; 

