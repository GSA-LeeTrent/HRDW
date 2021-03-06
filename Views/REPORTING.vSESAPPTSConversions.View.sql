USE [HRDW]
GO
/****** Object:  View [REPORTING].[vSESAPPTSConversions]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--CREATED BY RALPH SILVESTRO 1-16-2018
--LOOKS AT SES APPOINTMENTS ONLY


CREATE VIEW [REPORTING].[vSESAPPTSConversions]
as 

SELECT 'PII' AS 'SAFEGUARD PII',[PersonID],[ToPPSeriesGrade],[ToPositionTitle],  [EffectiveDate], [FYDESIGNATION], [NOAC_AND_DESCRIPTION],[NOAC_AND_DESCRIPTION_2],[FirstActionLACode1]
,[FirstActionLADesc1],[FirstActionLACode2],[FirstActionLADesc2],[ToPositionAgencyCodeSubelement], [ToPositionAgencyCodeSubelementDescription]
,CASE WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='142' AND [FirstActionLACode1] ='V2M' THEN 'Is selected competitively for SES Career Appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='542' AND [FirstActionLACode1] ='V2M' THEN  'Is selected competitively for SES Career Appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='143' AND [FirstActionLACode1] ='VBJ' THEN 'Is selected for SES Career Appointment based on reinstatement eligibility from a previous SES Career Appointment-Is reinstated after serving under Presidential appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='543' AND [FirstActionLACode1] ='VBJ' THEN 'IS NOT Is reinstated after serving under Presidential appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='145' AND [FirstActionLACode1] ='VGM' THEN 'Moves without a break in service from an SES Career Appointment in one agency to an SES Career Appointment in another agency'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='147' AND [FirstActionLACode1] ='VAG' AND [FirstActionLACode2] ='AWM' THEN 'Is selected for SES Noncareer Appointment-Moves without a break in service from an SES Noncareer Appointment in one agency to an SES Noncareer Appointment in another agency'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='146' AND [FirstActionLACode1] ='V4L' AND [FirstActionLACode2] ='AWM' THEN 'Is selected for SES Noncareer Appointment-Moves AND a break in service from an SES Noncareer Appointment in one agency to an SES Noncareer Appointment in another agency'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='546' AND [FirstActionLACode1] ='V4L' AND [FirstActionLACode2] ='AWM' THEN 'Is selected for SES Noncareer Appointment-Moves AND  a break in service from an SES Noncareer Appointment in one agency to an SES Noncareer Appointment in another agency'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='148' AND [FirstActionLACode1] ='V4M' THEN 'Is selected for SES Limited Term Appointment of 3 years or less'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='548' AND [FirstActionLACode1] ='V4M' THEN 'Is selected for SES Limited Term Appointment of 3 years or less'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='190' AND [FirstActionLACode1] ='V4M' THEN 'Is selected for SES Limited Term Appointment of 3 years or less-Appointment is to a continuing position when the agency intends later to convert the employee to a nontemporary appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='590' AND [FirstActionLACode1] ='V4M' THEN 'Is selected for SES Limited Term Appointment of 3 years or less-Appointment is to a continuing position when the agency intends later to convert the employee to a nontemporary appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='762' AND [FirstActionLACode1] ='V4M' THEN 'Is serving on an SES Limited Term Appointment NTE'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='149' AND [FirstActionLACode1] ='V4P' AND [FirstActionLACode2] ='AWM' THEN 'Is selected for SES Limited Emergency Appointment for 18 months or less to meet a bona fide emergency need'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='549' AND [FirstActionLACode1] ='V4P' AND [FirstActionLACode2] ='AWM' THEN 'Is selected for SES Limited Emergency Appointment for 18 months or less to meet a bona fide emergency need'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='190' AND [FirstActionLACode1] ='V4P' AND [FirstActionLACode2] ='AWM' THEN 'Is selected for SES Limited Emergency Appointment for 18 months or less to meet a bona fide emergency need-Appointment is to a continuing position when the agency intends later to convert the employee to a nontemporary appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='590' AND [FirstActionLACode1] ='V4P' AND [FirstActionLACode2] ='AWM' THEN 'Is selected for SES Limited Emergency Appointment for 18 months or less to meet a bona fide emergency need-Appointment is to a continuing position when the agency intends later to convert the employee to a nontemporary appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='762' AND [FirstActionLACode1] ='V4P' AND [FirstActionLACode2] ='AWM' THEN 'Is serving on an SES Limited Emergency Appointment NTE'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='542' AND [FirstActionLACode1] ='ZLM' THEN 'Elects conversion to SES when his or her position is converted to SES'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='546' AND [FirstActionLACode1] ='ZLM' THEN 'Elects conversion to SES when his or her position is converted to SES'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='142' AND [FirstActionLACode1] ='P3M' THEN 'Senior Executive Service (SES) Career Appointment after service with an international organization'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='142' AND [FirstActionLACode1] ='P5M' THEN 'SES Career Appointment after service under sections 233(d) and 625(b) of the Foreign Assistance Act of 1961'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='142' AND [FirstActionLACode1] ='P7M' THEN 'SES Career Appointment after service with the American Institute in Taiwan'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='142' AND [FirstActionLACode1] ='P2M' THEN 'SES Career Appointment by reemployment under 5 CFR 352.405, 352.705, or 352.907'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='142' AND [FirstActionLACode1] ='QAK' THEN 'Return from uniformed service'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='146' AND [FirstActionLACode1] ='QAK' THEN 'Return from uniformed service'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='148' AND [FirstActionLACode1] ='QAK' THEN 'Return from uniformed service'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='149' AND [FirstActionLACode1] ='QAK' THEN 'Return from uniformed service'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='542' AND [FirstActionLACode1] = 'NRM' THEN 'Elects conversion to SES when his or her position is converted to SES-Is currently under a career or career- conditional appointment or similar type of appointment in the excepted service'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='542' AND [FirstActionLACode1] = 'NTM' THEN 'Requests conversion to an SES Career Appointment when his or her position is converted to the SES-Has reinstatement eligibility to a position in the competitive service or had substantial career-oriented service under a career-type appointment in the excepted service-Is currently serving under a Schedule C appointment, or in a position in the Executive Schedule excepted by law, or similar position'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='542' AND [FirstActionLACode1] = 'NXM' THEN 'Elects conversion to SES when his or her position is converted to SES-Has reinstatement eligibility to a position in the competitive service-Is currently serving under a time-limited appointment in the excepted service which followed, without a break in service, a career-type appointment in a position which has been designated as in the SES'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='546' AND [FirstActionLACode1] = 'NSM' AND [FirstActionLACode2] ='AUM' THEN 'Elects conversion to SES when his or her position is converted to SES-Is currently serving under a Schedule C appointment, or in a position in the Executive Schedule excepted by law, or in a similar position-The employees position is designated as SES general OR The position is designated as SES career reserved and the agency reassigns the employee to an SES general position '
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='546' AND [FirstActionLACode1] = 'NWM' AND [FirstActionLACode2] ='AUM' THEN 'Elects conversion to SES when his or her position is converted to SES-Is currently serving under a time limited appointment in a position which will not terminate within three years-The employees position is designated as SES general or The position is designated as SES career reserved and the agency assigns the employee to an SES general position'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='548' AND [FirstActionLACode1] = 'NVM' THEN 'Elects conversion to SES when his or her position is converted to SES-Is currently serving under a time-limited appointment in the excepted service in a position which will terminate within three years from the date of the proposed conversion action'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='146' AND [FirstActionLACode1] = 'V4L' THEN 'Is selected for SES Noncareer Appointment- AND NOT Moves without a break in service from an SES Noncareer Appointment in one agency to an SES Noncareer Appointment in another agency'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='546' AND [FirstActionLACode1] = 'V4L' THEN 'Is selected for SES Noncareer Appointment- AND NOT Moves without a break in service from an SES Noncareer Appointment in one agency to an SES Noncareer Appointment in another agency'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='147' AND [FirstActionLACode1] = 'VAG'  THEN 'Is selected for SES Noncareer Appointment-AND DOES Moves without a break in service from an SES Noncareer Appointment in one agency to an SES Noncareer Appointment in another agency'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='145' AND [FirstActionLACode1] = 'V6M'  THEN 'Moves without a break in service from an SES Career Appointment in one agency to an SES Career Appointment in another agency'
ELSE ' ' END AS 'SES APPOINTMENT TYPE'
FROM [dbo].[Transactions]
WHERE LEFT([ToPPSeriesGrade],2) IN ('ES')
 AND [RunDate] =(SELECT MAX([RunDate]) FROM [dbo].[Transactions])
AND 
(LEFT ([NOAC_AND_DESCRIPTION],1) LIKE '1%' or LEFT ([NOAC_AND_DESCRIPTION],1) LIKE '5%')


UNION
SELECT 'PII' AS 'SAFEGUARD PII',[PersonID],[ToPPSeriesGrade],[ToPositionTitle], [EffectiveDate], [FYDESIGNATION], [NOAC_AND_DESCRIPTION],[NOAC_AND_DESCRIPTION_2],[FirstActionLACode1]
,[FirstActionLADesc1],[FirstActionLACode2],[FirstActionLADesc2],[ToPositionAgencyCodeSubelement], [ToPositionAgencyCodeSubelementDescription]
,CASE WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='142' AND [FirstActionLACode1] ='V2M' THEN 'Is selected competitively for SES Career Appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='542' AND [FirstActionLACode1] ='V2M' THEN  'Is selected competitively for SES Career Appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='143' AND [FirstActionLACode1] ='VBJ' THEN 'Is selected for SES Career Appointment based on reinstatement eligibility from a previous SES Career Appointment-Is reinstated after serving under Presidential appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='543' AND [FirstActionLACode1] ='VBJ' THEN 'IS NOT Is reinstated after serving under Presidential appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='145' AND [FirstActionLACode1] ='VGM' THEN 'Moves without a break in service from an SES Career Appointment in one agency to an SES Career Appointment in another agency'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='147' AND [FirstActionLACode1] ='VAG' AND [FirstActionLACode2] ='AWM' THEN 'Is selected for SES Noncareer Appointment-Moves without a break in service from an SES Noncareer Appointment in one agency to an SES Noncareer Appointment in another agency'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='146' AND [FirstActionLACode1] ='V4L' AND [FirstActionLACode2] ='AWM' THEN 'Is selected for SES Noncareer Appointment-Moves AND a break in service from an SES Noncareer Appointment in one agency to an SES Noncareer Appointment in another agency'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='546' AND [FirstActionLACode1] ='V4L' AND [FirstActionLACode2] ='AWM' THEN 'Is selected for SES Noncareer Appointment-Moves AND  a break in service from an SES Noncareer Appointment in one agency to an SES Noncareer Appointment in another agency'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='148' AND [FirstActionLACode1] ='V4M' THEN 'Is selected for SES Limited Term Appointment of 3 years or less'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='548' AND [FirstActionLACode1] ='V4M' THEN 'Is selected for SES Limited Term Appointment of 3 years or less'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='190' AND [FirstActionLACode1] ='V4M' THEN 'Is selected for SES Limited Term Appointment of 3 years or less-Appointment is to a continuing position when the agency intends later to convert the employee to a nontemporary appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='590' AND [FirstActionLACode1] ='V4M' THEN 'Is selected for SES Limited Term Appointment of 3 years or less-Appointment is to a continuing position when the agency intends later to convert the employee to a nontemporary appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='762' AND [FirstActionLACode1] ='V4M' THEN 'Is serving on an SES Limited Term Appointment NTE'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='149' AND [FirstActionLACode1] ='V4P' AND [FirstActionLACode2] ='AWM' THEN 'Is selected for SES Limited Emergency Appointment for 18 months or less to meet a bona fide emergency need'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='549' AND [FirstActionLACode1] ='V4P' AND [FirstActionLACode2] ='AWM' THEN 'Is selected for SES Limited Emergency Appointment for 18 months or less to meet a bona fide emergency need'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='190' AND [FirstActionLACode1] ='V4P' AND [FirstActionLACode2] ='AWM' THEN 'Is selected for SES Limited Emergency Appointment for 18 months or less to meet a bona fide emergency need-Appointment is to a continuing position when the agency intends later to convert the employee to a nontemporary appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='590' AND [FirstActionLACode1] ='V4P' AND [FirstActionLACode2] ='AWM' THEN 'Is selected for SES Limited Emergency Appointment for 18 months or less to meet a bona fide emergency need-Appointment is to a continuing position when the agency intends later to convert the employee to a nontemporary appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='762' AND [FirstActionLACode1] ='V4P' AND [FirstActionLACode2] ='AWM' THEN 'Is serving on an SES Limited Emergency Appointment NTE'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='542' AND [FirstActionLACode1] ='ZLM' THEN 'Elects conversion to SES when his or her position is converted to SES'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='546' AND [FirstActionLACode1] ='ZLM' THEN 'Elects conversion to SES when his or her position is converted to SES'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='142' AND [FirstActionLACode1] ='P3M' THEN 'Senior Executive Service (SES) Career Appointment after service with an international organization'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='142' AND [FirstActionLACode1] ='P5M' THEN 'SES Career Appointment after service under sections 233(d) and 625(b) of the Foreign Assistance Act of 1961'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='142' AND [FirstActionLACode1] ='P7M' THEN 'SES Career Appointment after service with the American Institute in Taiwan'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='142' AND [FirstActionLACode1] ='P2M' THEN 'SES Career Appointment by reemployment under 5 CFR 352.405, 352.705, or 352.907'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='142' AND [FirstActionLACode1] ='QAK' THEN 'Return from uniformed service'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='146' AND [FirstActionLACode1] ='QAK' THEN 'Return from uniformed service'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='148' AND [FirstActionLACode1] ='QAK' THEN 'Return from uniformed service'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='149' AND [FirstActionLACode1] ='QAK' THEN 'Return from uniformed service'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='542' AND [FirstActionLACode1] = 'NRM' THEN 'Elects conversion to SES when his or her position is converted to SES-Is currently under a career or career- conditional appointment or similar type of appointment in the excepted service'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='542' AND [FirstActionLACode1] = 'NTM' THEN 'Requests conversion to an SES Career Appointment when his or her position is converted to the SES-Has reinstatement eligibility to a position in the competitive service or had substantial career-oriented service under a career-type appointment in the excepted service-Is currently serving under a Schedule C appointment, or in a position in the Executive Schedule excepted by law, or similar position'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='542' AND [FirstActionLACode1] = 'NXM' THEN 'Elects conversion to SES when his or her position is converted to SES-Has reinstatement eligibility to a position in the competitive service-Is currently serving under a time-limited appointment in the excepted service which followed, without a break in service, a career-type appointment in a position which has been designated as in the SES'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='546' AND [FirstActionLACode1] = 'NSM' AND [FirstActionLACode2] ='AUM' THEN 'Elects conversion to SES when his or her position is converted to SES-Is currently serving under a Schedule C appointment, or in a position in the Executive Schedule excepted by law, or in a similar position-The employees position is designated as SES general OR The position is designated as SES career reserved and the agency reassigns the employee to an SES general position '
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='546' AND [FirstActionLACode1] = 'NWM' AND [FirstActionLACode2] ='AUM' THEN 'Elects conversion to SES when his or her position is converted to SES-Is currently serving under a time limited appointment in a position which will not terminate within three years-The employees position is designated as SES general or The position is designated as SES career reserved and the agency assigns the employee to an SES general position'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='548' AND [FirstActionLACode1] = 'NVM' THEN 'Elects conversion to SES when his or her position is converted to SES-Is currently serving under a time-limited appointment in the excepted service in a position which will terminate within three years from the date of the proposed conversion action'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='146' AND [FirstActionLACode1] = 'V4L' THEN 'Is selected for SES Noncareer Appointment- AND NOT Moves without a break in service from an SES Noncareer Appointment in one agency to an SES Noncareer Appointment in another agency'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='546' AND [FirstActionLACode1] = 'V4L' THEN 'Is selected for SES Noncareer Appointment- AND NOT Moves without a break in service from an SES Noncareer Appointment in one agency to an SES Noncareer Appointment in another agency'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='147' AND [FirstActionLACode1] = 'VAG'  THEN 'Is selected for SES Noncareer Appointment-AND DOES Moves without a break in service from an SES Noncareer Appointment in one agency to an SES Noncareer Appointment in another agency'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) ='145' AND [FirstActionLACode1] = 'V6M'  THEN 'Moves without a break in service from an SES Career Appointment in one agency to an SES Career Appointment in another agency'
ELSE ' ' END AS 'SES APPOINTMENT TYPE'
FROM [dbo].[TransactionsHistory]
WHERE LEFT([ToPPSeriesGrade],2) IN ('ES')
AND 
(LEFT ([NOAC_AND_DESCRIPTION],1) LIKE '1%' or LEFT ([NOAC_AND_DESCRIPTION],1) LIKE '5%')


GO
