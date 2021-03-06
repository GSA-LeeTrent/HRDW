USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[gs_sp_load_Services]    Script Date: 5/1/2018 1:37:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[gs_sp_load_Services]
with execute as owner		
as

INSERT INTO HRDW.[dbo].[services]
           ([SERVICECODE]
           ,[SERVICENAME]
           ,[SERVICEABBR]
           ,[SERVICESYMBOL]
           ,[SERVICEFUND]
           ,[SERVICEORG]
           ,[SERVICENOTES]
           ,[SERVICEBEGIN]
           ,[SERVICEEND]
           ,[SERVICEFROMPAR]
           ,[REGIONFROMPAR])
     VALUES
           ('TESTSVCCODE'
           ,'Test Service'
           ,'TESTSVCABBR'
           ,'TEST'
           ,'123'
           ,'TEST'
           ,'Test Service Notes'
           ,'01/01/2016'
           ,'01/01/2017'
           ,'%'
           ,'%')

GO
