USE [HRDW]
GO
/****** Object:  DatabaseRole [GeneralPublic]    Script Date: 4/30/2018 1:52:01 PM ******/
CREATE ROLE [GeneralPublic]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [GeneralPublic]
GO
