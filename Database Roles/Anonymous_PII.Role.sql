USE [HRDW]
GO
/****** Object:  DatabaseRole [Anonymous_PII]    Script Date: 4/30/2018 1:52:00 PM ******/
CREATE ROLE [Anonymous_PII]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [Anonymous_PII]
GO
