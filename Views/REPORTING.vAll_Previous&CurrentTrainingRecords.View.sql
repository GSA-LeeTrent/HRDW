USE [HRDW]
GO
/****** Object:  View [REPORTING].[vAll_Previous&CurrentTrainingRecords]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Training View Created by Ralph Silvestro 10-18-2016 for all time periods

CREATE VIEW [REPORTING].[vAll_Previous&CurrentTrainingRecords]
AS (SELECT [PersonID]
,[CourseStartDate]
,[CourseCompletionDate]
,[FiscalYear]
,[TrainingTitle]
,[TrainingPartOfIDPDesc]
,[TrainingSourceDesc]
,[TrainingSubTypeDesc]
FROM [dbo].[TssTDS]
--WHERE [CourseCompletionDate] BETWEEN '2014-10-01' AND '2015-09-30'
UNION
SELECT [PersonID]
,[CourseStartDate]
,[CourseCompletionDate]
,[FiscalYear]
,[TrainingTitle]
,[TrainingPartOfIDPDesc]
,[TrainingSourceDesc]
,[TrainingSubTypeDesc]
FROM [dbo].[TssTDSHistory])
--WHERE [CourseCompletionDate] BETWEEN '2014-10-01' AND '2015-09-30'
--ORDER BY [PersonID] DESC , [CourseCompletionDate] DESC)
GO
