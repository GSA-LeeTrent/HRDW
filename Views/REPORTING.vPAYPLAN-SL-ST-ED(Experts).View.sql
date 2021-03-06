USE [HRDW]
GO
/****** Object:  View [REPORTING].[vPAYPLAN-SL-ST-ED(Experts)]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--CREATED BY RALPH SILVESTRO 1-16-2018
--Lokks at SL, ST, ED PAYPLANS AND ACCESSIONS-Conversions
--Experts and Consultants


CREATE VIEW [REPORTING].[vPAYPLAN-SL-ST-ED(Experts)]
as 

SELECT [PersonID], [EffectiveDate], [FYDESIGNATION], [NOAC_AND_DESCRIPTION],[NOAC_AND_DESCRIPTION_2],[FirstActionLACode1]
,[FirstActionLADesc1],[ToPPSeriesGrade],[ToPositionTitle],[ToPositionAgencyCodeSubelement], [ToPositionAgencyCodeSubelementDescription]
FROM [dbo].[Transactions]
WHERE LEFT([ToPPSeriesGrade],2) IN ('SL','ST','ED')
 AND [RunDate] =(SELECT MAX([RunDate]) FROM [dbo].[Transactions])
AND 
(LEFT ([NOAC_AND_DESCRIPTION],1) LIKE '1%' or LEFT ([NOAC_AND_DESCRIPTION],1) LIKE '5%')
UNION
SELECT [PersonID], [EffectiveDate], [FYDESIGNATION], [NOAC_AND_DESCRIPTION],[NOAC_AND_DESCRIPTION_2],[FirstActionLACode1]
,[FirstActionLADesc1],[ToPPSeriesGrade],[ToPositionTitle],[ToPositionAgencyCodeSubelement], [ToPositionAgencyCodeSubelementDescription]
FROM [dbo].[TransactionsHistory]
WHERE LEFT([ToPPSeriesGrade],2) IN ('SL','ST','ED')
AND 
(LEFT ([NOAC_AND_DESCRIPTION],1) LIKE '1%' or LEFT ([NOAC_AND_DESCRIPTION],1) LIKE '5%')


GO
