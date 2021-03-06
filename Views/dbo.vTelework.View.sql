USE [HRDW]
GO
/****** Object:  View [dbo].[vTelework]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vTelework] WITH SCHEMABINDING 
-- 2016-03-08 Rob Cornelsen updated to match table structure
    AS 
    SELECT [TeleworkID]
      ,[PersonID]
      ,[TeleworkElgible]
      ,[InElgibleReason]
      ,[AgreementDate]
      ,[EmpStatus]
      ,[TeleworkStatus]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate]
    FROM [dbo].[Telework]

GO
