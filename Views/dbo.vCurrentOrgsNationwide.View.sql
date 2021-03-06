USE [HRDW]
GO
/****** Object:  View [dbo].[vCurrentOrgsNationwide]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vCurrentOrgsNationwide]
    AS 
-- ============ Maintenance Log ================================================
-- Author:      Ralph Silvestro
-- Date:        2016-04-27  
-- Description: version 1  To Replicate what was upon Google Drive.
-- =============================================================================
SELECT       DB_NAME() AS 'Database'
             , GETDATE() AS 'System Date and Time'
			 , [dbo].[vAlphaOrgRoster-Regular].RecordDate AS 'Record Date'
			 , [dbo].[vAlphaOrgRoster-Regular].PosOrgAgySubelementCode AS 'HSSO Code'
			 , [dbo].[vAlphaOrgRoster-Regular].HSSO
			 , [dbo].[vAlphaOrgRoster-Regular].[OfficeSymbol] AS 'Ofc Sym'
			 , [OfficeLkup].[OfficeSymbol2Char] AS '2 letter'
			 ,SUM(CASE WHEN HSSO IS NOT NULL THEN 1 ELSE 0 END ) 'Cnt Empl Per Ofc Symbol'
			, [PosAddressOrgInfoLine1]
            ,[PosAddressOrgInfoLine2]
            ,[PosAddressOrgInfoLine3]
            ,[PosAddressOrgInfoLine4]
            ,[PosAddressOrgInfoLine5]
            ,[PosAddressOrgInfoLine6]
			 
FROM            [dbo].[vAlphaOrgRoster-Regular] Left JOIN
                         dbo.OfficeLkup ON [dbo].[vAlphaOrgRoster-Regular].OfficeSymbol = dbo.OfficeLkup.OfficeSymbol

GROUP BY    RecordDate,  PosOrgAgySubelementCode, [dbo].[vAlphaOrgRoster-Regular].[OfficeSymbol],dbo.[OfficeLkup].[OfficeSymbol2Char], HSSO,  
            [PosAddressOrgInfoLine1]
            ,[PosAddressOrgInfoLine2]
            ,[PosAddressOrgInfoLine3]
            ,[PosAddressOrgInfoLine4]
            ,[PosAddressOrgInfoLine5]
            ,[PosAddressOrgInfoLine6]




GO
