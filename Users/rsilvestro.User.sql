USE [HRDW]
GO
/****** Object:  User [rsilvestro]    Script Date: 5/1/2018 1:43:36 PM ******/
CREATE USER [rsilvestro] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [rsilvestro]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [rsilvestro]
GO
