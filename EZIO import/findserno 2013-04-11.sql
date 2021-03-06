SELECT C_SERIALNUMBERS.INVNUM as inv_no, C_SERIALNUMBERS.TRX_DT2 as inv_dt, 
	C_SERIALNUMBERS.SERNUM as ser_lot_no, C_SERIALNUMBERS.ITEMID as item_no, 
	ISNULL(INVENTTABLE.ITEMNAME,'') as item_desc_1, 
	C_CONTRACTITEMS.SupportCoverage, SupportItem.ITEMNAME, 
	/* CASE 
		WHEN SupportItem.ITEMNAME like '%Advance Replacement%' then 0 
		WHEN SupportItem.ITEMNAME like '%Advanced Replacement%' then 0 
		WHEN SupportItem.ITEMNAME like '%Depot Repair%' THEN 1 
		ELSE NULL END AS rmatype, */ 0 AS rmatype, 
	ISNULL(dbo.getdatefromdatetime([dbo].[GetExpirationDate](C_SERIALNUMBERS.SERNUM)), 'n/a') as datefinal, 
	CASE 
		WHEN [dbo].[GetExpirationDate](C_SERIALNUMBERS.SERNUM) IS NULL THEN 0 
		WHEN [dbo].[GetExpirationDate](C_SERIALNUMBERS.SERNUM) > getDate() THEN 1 
		ELSE 0 END AS InWarranty 
FROM C_SERIALNUMBERS 
	LEFT OUTER JOIN SALESTABLE ON SALESTABLE.SALESID = C_SERIALNUMBERS.SALESORDERNO 
	LEFT OUTER JOIN INVENTTABLE ON INVENTTABLE.ITEMID = C_SERIALNUMBERS.ITEMID and INVENTTABLE.DATAAREAID = 'us' 
	LEFT OUTER JOIN C_CONTRACTITEMS ON C_CONTRACTITEMS.SN = C_SERIALNUMBERS.SERNUM 
	LEFT OUTER JOIN C_CONTRACTS ON C_CONTRACTS.CONTRACTID_DISPLAY = C_CONTRACTITEMS.CONTRACTID 
	LEFT OUTER JOIN INVENTTABLE SupportItem ON SupportItem.ITEMID = C_CONTRACTITEMS.SUPPORTCOVERAGE AND SupportItem.DATAAREAID = C_CONTRACTITEMS.DATAAREAID 
WHERE C_SERIALNUMBERS.SERNUM like '%1%' AND ISNULL(C_CONTRACTITEMS.Active, 1) = 1 AND 
   (SALESTABLE.INVOICEACCOUNT = '14312' or C_SERIALNUMBERS.CUSTOMER = '14312' and c_serialnumbers.dataareaid = 'us');
	