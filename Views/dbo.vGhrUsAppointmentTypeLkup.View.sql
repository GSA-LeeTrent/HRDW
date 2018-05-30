USE [HRDW]
GO
/****** Object:  View [dbo].[vGhrUsAppointmentTypeLkup]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE VIEW [dbo].[vGhrUsAppointmentTypeLkup] WITH SCHEMABINDING  
-- 2016-03-08 Rob Cornelsen updated table based views to match latest table structure
    AS 
    SELECT [GhrUsAppointmentTypeLkupID]
      ,[AppointmentType]
      ,[AppointmentTypeDescription]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate] 
    FROM [dbo].[GhrUsAppointmentTypeLkup]

GO
