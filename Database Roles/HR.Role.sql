USE [HRDW]
GO
/****** Object:  DatabaseRole [HR]    Script Date: 4/30/2018 1:52:01 PM ******/
CREATE ROLE [HR]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [HR]
GO
