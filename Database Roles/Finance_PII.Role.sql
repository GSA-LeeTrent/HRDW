USE [HRDW]
GO
/****** Object:  DatabaseRole [Finance_PII]    Script Date: 4/30/2018 1:52:00 PM ******/
CREATE ROLE [Finance_PII]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [Finance_PII]
GO
