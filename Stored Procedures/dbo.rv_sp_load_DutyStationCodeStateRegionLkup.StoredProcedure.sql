USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_DutyStationCodeStateRegionLkup]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-05-13  
-- Description: Insert from xxOPMDutyStationLkup - then the RegionBasedOnDutyStation
--              column must be updated separately
-- =============================================================================
CREATE procedure [dbo].[rv_sp_load_DutyStationCodeStateRegionLkup]
with execute as owner		
as

INSERT INTO [dbo].[DutyStationCodeStateRegionLkup]
           ([DutyStationCode]
           ,[DutyStationStateOrCountry]
           ,[RegionBasedOnDutyStation]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate])
SELECT distinct 
			opmds.[DutyStationCode]
           ,(
			SELECT DISTINCT
				opmds2.[DutyStationName]
			FROM
				xxOPMDutyStationLkup opmds2
			WHERE	
				opmds2.[DutyStationCode] = (LEFT(opmds.[DutyStationCode],2) + '0000000')
			)
 		   ,NULL
           ,'https://apps.opm.gov/dsfls/index.cfm'
           ,'GoogleDrive'
           ,GETDATE()
  FROM [dbo].[xxOPMDutyStationLkup] opmds


GO
