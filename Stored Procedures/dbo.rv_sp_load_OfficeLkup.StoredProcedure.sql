USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_OfficeLkup]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-05-13  
-- Description: Add RegionBasedOnOfficeSymbol code
-- =============================================================================
-- Author:      James McConville
-- Date:        2016-10-04  
-- Description: Add clause to CASE statement for RegionBasedOnOfficeSymbol = 'CO'
-- =============================================================================
CREATE procedure [dbo].[rv_sp_load_OfficeLkup]
with execute as owner		
as

INSERT INTO [dbo].[OfficeLkup]
           ([OfficeSymbol]
           ,[OfficeSymbol2Char]
           ,[OfficeDescription]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate]
		   ,[RegionBasedOnOfficeSymbol]
           )
SELECT distinct [OfficeSymbol]
      ,[OfficeSymbol2Char]
      ,[OfficeDescription]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate]
	  ,CASE
		 WHEN [OfficeSymbol] LIKE '10%'
		 THEN 'R10'
		 WHEN [OfficeSymbol] LIKE '1%'
		 THEN 'R01'
		 WHEN [OfficeSymbol] LIKE '2%'
		 THEN 'R02'
		 WHEN [OfficeSymbol] LIKE '3%'
		 THEN 'R03'
		 WHEN [OfficeSymbol] LIKE '4%'
		 THEN 'R04'
		 WHEN [OfficeSymbol] LIKE '5%'
		 THEN 'R05'
		 WHEN [OfficeSymbol] LIKE '6%'
		 THEN 'R06'
		 WHEN [OfficeSymbol] LIKE '7%'
		 THEN 'R07'
		 WHEN [OfficeSymbol] LIKE '8%'
		 THEN 'R08'
		 WHEN [OfficeSymbol] LIKE '9%'
		 THEN 'R09'
		 WHEN [OfficeSymbol] LIKE 'W%'
		 THEN 'R11'
		 WHEN [OfficeSymbol] LIKE 'A%'
		 THEN 'R10'
		 ELSE 'CO'
	   END AS [RegionBasedOnOfficeSymbol]
   FROM [dbo].[xxOfficeLkup]



GO
