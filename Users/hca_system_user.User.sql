USE [HRDW]
GO
/****** Object:  User [hca_system_user]    Script Date: 5/1/2018 1:43:35 PM ******/
CREATE USER [hca_system_user] FOR LOGIN [hca_system_user] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [Maintenance] ADD MEMBER [hca_system_user]
GO
