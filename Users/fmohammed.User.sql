USE [HRDW]
GO
/****** Object:  User [fmohammed]    Script Date: 5/1/2018 1:43:34 PM ******/
CREATE USER [fmohammed] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [fmohammed]
GO
