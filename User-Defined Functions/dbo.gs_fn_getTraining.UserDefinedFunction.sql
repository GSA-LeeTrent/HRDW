USE [HRDW]
GO
/****** Object:  UserDefinedFunction [dbo].[gs_fn_getTraining]    Script Date: 5/1/2018 1:42:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;
CREATE FUNCTION [dbo].[gs_fn_getTraining] (@emailaddr varchar(255))
RETURNS @retTrainingRecs TABLE
(
	 persID	INT
	,TrainEmail VARCHAR(255)
	,TrainDt DATE
	,TrainFY VARCHAR(255)
	,TrainTitle VARCHAR(255)
)
AS
BEGIN
  DECLARE
   @persID	INT
  ,@TrainEmail VARCHAR(255)
  ,@TrainDt DATE
  ,@TrainFY VARCHAR(255)
  ,@TrainTitle VARCHAR(255)
  
  DECLARE TrainingCursor CURSOR FOR
  SELECT 
	 PER.PersonID
	,ltrim(rtrim(CONVERT(varchar(255), DecryptByKey(PER.[EmailAddress]))))
	,TDS.[CourseCompletionDate]
	,TDS.[FiscalYear]
	,TDS.[TrainingTitle]
  FROM
	 [HRDW].[dbo].[Person] PER 
		LEFT OUTER JOIN [HRDW].[dbo].[TssTDS] TDS	
			ON PER.[personID] = TDS.[PersonID]
  WHERE
	ltrim(rtrim(CONVERT(varchar(255), DecryptByKey(PER.[EmailAddress])))) = @emailaddr
	AND
	TDS.[FiscalYear] = '2015';

	IF @emailaddr IS NOT NULL
	BEGIN
	  OPEN TrainingCursor
	  FETCH NEXT FROM TrainingCursor
	  INTO 
		 @persID
		,@TrainEmail
		,@TrainDt
		,@TrainFY
		,@TrainTitle

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO @retTrainingRecs
				SELECT 
				 @persID
				,@TrainEmail
				,@TrainDt
				,@TrainFY
				,@TrainTitle;
			FETCH NEXT FROM TrainingCursor
			INTO 
				 @persID
				,@TrainEmail
				,@TrainDt
				,@TrainFY
				,@TrainTitle
		END
	END
	CLOSE TrainingCursor;
	RETURN;
END;


GO
