USE [HRDW]
GO
/****** Object:  Table [SURVEY].[SurveyResponseDate]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SURVEY].[SurveyResponseDate](
	[SurveyResponseDateID] [int] IDENTITY(1,1) NOT NULL,
	[EmailAddress] [nvarchar](255) NULL,
	[SurveyTypeDesc] [nvarchar](255) NULL,
	[SurveySendDate] [date] NULL,
	[SurveyResponseDate] [date] NULL,
 CONSTRAINT [SurveyResponseDate_pk] PRIMARY KEY NONCLUSTERED 
(
	[SurveyResponseDateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
