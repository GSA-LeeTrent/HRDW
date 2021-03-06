USE [HRDW]
GO
/****** Object:  View [dbo].[vAllOrgsNationwide]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vAllOrgsNationwide]
    AS 
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-07-06  
-- Description: Created view of current and prior office symbols
-- =============================================================================
SELECT DISTINCT       
	   DB_NAME() AS 'Database'
     , GETDATE() AS 'System Date and Time'
	 , pos.RecordDate as 'Record Date'
	 , pos.PosOrgAgySubelementCode AS 'HSSO Code'
	 , pos.PosOrgAgySubelementDesc AS 'HSSO'
	 , posI.OfficeSymbol AS 'Ofc Sym'
	 , olkup.OfficeSymbol2Char AS '2 letter'
	 , SUM
		 (
		 CASE 
		 WHEN (posI.PositionEncumberedType = 'Employee Permanent' OR posI.PositionEncumberedType = 'Employee Temporary') 
		 THEN 1 
		 ELSE 0 
		 END 
		 ) 'Cnt Empl Per Ofc Symbol'
	 , pos.[PosAddressOrgInfoLine1]
     , pos.[PosAddressOrgInfoLine2]
     , pos.[PosAddressOrgInfoLine3]
     , pos.[PosAddressOrgInfoLine4]
     , pos.[PosAddressOrgInfoLine5]
     , pos.[PosAddressOrgInfoLine6]
	 , xxOrg.[Pos Organization Name]
	 , xxOrg.[Pos Org Date Abolished]
	 , xxOrg.[Pos Org Created By Order]
	 , xxOrg.[Pos Org Effective Start Date]
	 , xxOrg.[Pos Org Effective End Date]
	 , xxOrg.[Pos Address Org Changed By Order]
	 , xxOrg.[Pos Address Org Date Of Last Chg]
	 , xxOrg.[Pos Org Abolished By Order]
 
FROM
	dbo.PositionInfo posI
	INNER JOIN dbo.Position pos ON posI.PositionInfoId = pos.ChrisPositionId
    LEFT OUTER JOIN dbo.OfficeLkup olkup ON posI.OfficeSymbol = olkup.OfficeSymbol
	LEFT OUTER JOIN dbo.xxGSAOrganizations xxOrg ON xxOrg.[Office Symbol] = posI.OfficeSymbol
WHERE
	pos.RecordDate = (
					 SELECT max(pos2.RecordDate)
					 FROM
						 dbo.Position pos2
						 INNER JOIN dbo.PositionInfo posI2 ON pos2.ChrisPositionId = posI2.PositionInfoId
									AND
									posI2.OfficeSymbol = posI.OfficeSymbol
									AND
									posI2.PositionEncumberedType = posI.PositionEncumberedType
					 )
	 AND
	 xxOrg.[Pos Org Effective End Date] IS NULL

GROUP BY    
	  pos.RecordDate
	, pos.PosOrgAgySubelementCode
	, pos.PosOrgAgySubelementDesc
	, posI.OfficeSymbol
	, olkup.OfficeSymbol2Char
	, pos.[PosAddressOrgInfoLine1]
    , pos.[PosAddressOrgInfoLine2]
    , pos.[PosAddressOrgInfoLine3]
    , pos.[PosAddressOrgInfoLine4]
    , pos.[PosAddressOrgInfoLine5]
    , pos.[PosAddressOrgInfoLine6]
	 , xxOrg.[Pos Organization Name]
	 , xxOrg.[Pos Org Date Abolished]
	 , xxOrg.[Pos Org Created By Order]
	 , xxOrg.[Pos Org Effective Start Date]
	 , xxOrg.[Pos Org Effective End Date]
	 , xxOrg.[Pos Address Org Changed By Order]
	 , xxOrg.[Pos Address Org Date Of Last Chg]
	 , xxOrg.[Pos Org Abolished By Order]


GO
