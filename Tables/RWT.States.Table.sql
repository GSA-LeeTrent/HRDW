USE [HRDW]
GO
/****** Object:  Table [RWT].[States]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RWT].[States](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[State] [nvarchar](255) NULL,
	[Abbr] [nvarchar](255) NULL,
	[LastUptimestampstamp] [timestamp] NULL,
	[LastUpdateUser] [nvarchar](50) NULL,
 CONSTRAINT [States_pk] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [RWT].[States] ADD  DEFAULT (suser_name()) FOR [LastUpdateUser]
GO
