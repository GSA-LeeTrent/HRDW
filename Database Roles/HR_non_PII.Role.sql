USE [HRDW]
GO
/****** Object:  DatabaseRole [HR_non_PII]    Script Date: 4/30/2018 1:52:01 PM ******/
CREATE ROLE [HR_non_PII]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [HR_non_PII]
GO
