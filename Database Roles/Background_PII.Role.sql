USE [HRDW]
GO
/****** Object:  DatabaseRole [Background_PII]    Script Date: 4/30/2018 1:52:00 PM ******/
CREATE ROLE [Background_PII]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [Background_PII]
GO
