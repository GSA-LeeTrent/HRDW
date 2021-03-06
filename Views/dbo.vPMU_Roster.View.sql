USE [HRDW]
GO
/****** Object:  View [dbo].[vPMU_Roster]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [dbo].[vPMU_Roster]    Script Date: 03/22/2016 17:51:17 ******/
-- 2016-01-29 JShay - created

Create view [dbo].[vPMU_Roster] AS -- WITH SCHEMABINDING AS 

select distinct pos.FY, pos.PersonID, pos.RecordDate, posI.PositionEncumberedType

FROM dbo.Position pos			
inner join dbo.PositionInfo posI											--28277 rows
	on posI.PositionInfoID = pos.ChrisPositionID
	and pos.RecordDate = 
		(select Max(pos.RecordDate) as MaxRecDate from dbo.Position pos)	-- select the most recent RecordDate
	and pos.PersonID is not Null

GO
