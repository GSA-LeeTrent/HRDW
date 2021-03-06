USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_GhrUsAppointmentTypeLkup]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rv_sp_load_GhrUsAppointmentTypeLkup]
with execute as owner		
as
INSERT INTO [dbo].[GhrUsAppointmentTypeLkup]
           ([AppointmentType]
           ,[AppointmentTypeDescription]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate])
    SELECT Distinct [AppointmentType]
           ,[AppointmentTypeDescription]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate]
    FROM [dbo].[xxGhrUsAppointmentTypeLkup]

GO
