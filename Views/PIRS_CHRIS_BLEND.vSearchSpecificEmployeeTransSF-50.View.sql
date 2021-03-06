USE [HRDW]
GO
/****** Object:  View [PIRS_CHRIS_BLEND].[vSearchSpecificEmployeeTransSF-50]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW  [PIRS_CHRIS_BLEND].[vSearchSpecificEmployeeTransSF-50]
AS
SELECT --Past PIRS Transactions History
[LegacyPirsChrisbo].[PIRS_CJ_Transactions(85,89,90-2000)].[PersonID]
,[LegacyPirsChrisbo].[PIRS_CJ_Transactions(85,89,90-2000)].[EffectiveDate]
,[LegacyPirsChrisbo].[PIRS_CJ_Transactions(85,89,90-2000)].[FYDESIGNATION]
,[LegacyPirsChrisbo].[PIRS_CJ_Transactions(85,89,90-2000)].[NOAC AND DESCRIPTION]
,[LegacyPirsChrisbo].[PIRS_CJ_Transactions(85,89,90-2000)].[FullName]
,[LegacyPirsChrisbo].[PIRS_CJ_Transactions(85,89,90-2000)].[FromHSSO]
,[LegacyPirsChrisbo].[PIRS_CJ_Transactions(85,89,90-2000)].[ToHSSO]
,[LegacyPirsChrisbo].[PIRS_CJ_Transactions(85,89,90-2000)].[FromOfficeSymbol]
,[LegacyPirsChrisbo].[PIRS_CJ_Transactions(85,89,90-2000)].[ToOfficeSymbol]
,[LegacyPirsChrisbo].[PIRS_CJ_Transactions(85,89,90-2000)].[FromSeriesGroupTitle] AS 'From Posn Title'
,[LegacyPirsChrisbo].[PIRS_CJ_Transactions(85,89,90-2000)].[FromPP-Series-Gr]
,[LegacyPirsChrisbo].[PIRS_CJ_Transactions(85,89,90-2000)].[ToSeriesGroupTitle]
,[LegacyPirsChrisbo].[PIRS_CJ_Transactions(85,89,90-2000)].[ToPP-Series-Gr] AS 'To Posn Title'
,[LegacyPirsChrisbo].[PIRS_CJ_Transactions(85,89,90-2000)].[What Kind of Movement?]
,[LegacyPirsChrisbo].[PIRS_CJ_Transactions(85,89,90-2000)].[FromSupervisoryStatusDesc]
,[LegacyPirsChrisbo].[PIRS_CJ_Transactions(85,89,90-2000)].[ToSupervisoryStatusDesc]
FROM [LegacyPirsChrisbo].[PIRS_CJ_Transactions(85,89,90-2000)]

UNION
SELECT [dbo].[TransactionsHistory].[PersonID]
,[dbo].[TransactionsHistory].[EffectiveDate]
,[dbo].[TransactionsHistory].[FYDESIGNATION]--In essence exisiting HRDW TransactionHistory is static
,[dbo].[TransactionsHistory].[NOAC_AND_DESCRIPTION]
,LastName + ', ' + FirstName + ' ' + IsNull(MiddleName, '') AS FullName
,[dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelementDescription]AS 'FromHSSO'
,[dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelementDescription] AS 'ToHSSO'
,[dbo].[TransactionsHistory].[FromOfficeSymbol]
,[dbo].[TransactionsHistory].[ToOfficeSymbol]
,[dbo].[TransactionsHistory].[FromPositionTitle]
,[dbo].[TransactionsHistory].[FromPPSeriesGrade] AS 'FromPP-Series-Gr'
,[dbo].[TransactionsHistory].[ToPositionTitle]
,[dbo].[TransactionsHistory].[ToPPSeriesGrade] AS 'ToPP-Series-Gr'
,[dbo].[TransactionsHistory].[WhatKindofMovement]
,[dbo].[TransactionsHistory].[FromPosSupervisorySatusDesc] AS 'FromSupervisoryStatusDesc'
,[dbo].[TransactionsHistory].[ToSupervisoryStatusDesc] AS 'ToSupervisoryStatusDesc'
FROM 
 dbo.TransactionsHistory LEFT OUTER JOIN
                  dbo.Person ON dbo.TransactionsHistory.PersonID = dbo.Person.PersonID



UNION

SELECT [dbo].[Transactions].[PersonID]
,[dbo].[Transactions].[EffectiveDate]
,[dbo].[Transactions].[FYDESIGNATION]--This is reloaded with each biweekly load causing one to have to use max run date
,[dbo].[Transactions].[NOAC_AND_DESCRIPTION]
,LastName + ', ' + FirstName + ' ' + IsNull(MiddleName, '') AS FullName
,[dbo].[Transactions].[FromPositionAgencyCodeSubelementDescription]AS 'FromHSSO'
,[dbo].[Transactions].[ToPositionAgencyCodeSubelementDescription] AS 'ToHSSO'
,[dbo].[Transactions].[FromOfficeSymbol]
,[dbo].[Transactions].[ToOfficeSymbol]
,[dbo].[Transactions].[FromPositionTitle]
,[dbo].[Transactions].[FromPPSeriesGrade] AS 'FromPP-Series-Gr'
,[dbo].[Transactions].[ToPositionTitle]
,[dbo].[Transactions].[ToPPSeriesGrade] AS 'ToPP-Series-Gr'
,[dbo].[Transactions].[WhatKindofMovement]
,[dbo].[Transactions].[FromPosSupervisorySatusDesc] AS 'FromSupervisoryStatusDesc'
,[dbo].[Transactions].[ToSupervisoryStatusDesc] AS 'ToSupervisoryStatusDesc'

FROM 
 dbo.Transactions LEFT OUTER JOIN
                  dbo.Person ON dbo.Transactions.PersonID = dbo.Person.PersonID

AND [Transactions].RUNDATE = 
 (SELECT MAX(RUNDATE) FROM dbo.Transactions)--This is how you select most current information from Transactions
        


		




GO
