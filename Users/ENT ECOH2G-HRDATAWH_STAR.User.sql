USE [HRDW]
GO
/****** Object:  User [ENT\ECOH2G-HRDATAWH_STAR]    Script Date: 5/1/2018 1:43:34 PM ******/
CREATE USER [ENT\ECOH2G-HRDATAWH_STAR] WITH DEFAULT_SCHEMA=[RWT]
GO
ALTER ROLE [STAR] ADD MEMBER [ENT\ECOH2G-HRDATAWH_STAR]
GO
