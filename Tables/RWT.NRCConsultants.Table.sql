USE [HRDW]
GO
/****** Object:  Table [RWT].[NRCConsultants]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RWT].[NRCConsultants](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[HR Name] [nvarchar](255) NULL,
	[LastUptimestampstamp] [timestamp] NULL,
	[LastUpdateUser] [nvarchar](50) NULL,
	[NRCInitials] [nvarchar](3) NULL,
 CONSTRAINT [NRCConsultants_pk] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [RWT].[NRCConsultants] ADD  DEFAULT (suser_name()) FOR [LastUpdateUser]
GO
