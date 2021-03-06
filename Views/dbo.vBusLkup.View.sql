USE [HRDW]
GO
/****** Object:  View [dbo].[vBusLkup]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*  No longer in use
CREATE VIEW [dbo].[vAppointmentTypeLkup] --WITH SCHEMABINDING
    AS 
    SELECT * FROM [dbo].AppointmentTypeLkup;
GO
*/

CREATE VIEW [dbo].[vBusLkup] WITH SCHEMABINDING 
-- 2016-03-08 Rob Cornelsen updated to match table structure and added WITH SCHEMABINDING
    AS 
    SELECT [BusLkupID]
      ,[BargainingUnitStatusCode]
      ,[BargainingUnitOrg]
      ,[BargainingUnitStatusCodeGroup]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate] 
    FROM [dbo].[BusLkup];

GO
