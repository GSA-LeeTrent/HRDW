USE [HRDW]
GO
/****** Object:  User [rwt_hr_ss_user]    Script Date: 5/1/2018 1:43:36 PM ******/
CREATE USER [rwt_hr_ss_user] FOR LOGIN [rwt_hr_ss_user] WITH DEFAULT_SCHEMA=[HRDW]
GO
ALTER ROLE [STAR] ADD MEMBER [rwt_hr_ss_user]
GO
