USE [HRDW]
GO
/****** Object:  DatabaseRole [HR_PII]    Script Date: 4/30/2018 1:52:01 PM ******/
CREATE ROLE [HR_PII]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [HR_PII]
GO
