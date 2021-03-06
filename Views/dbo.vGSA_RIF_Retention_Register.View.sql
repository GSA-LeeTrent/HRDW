USE [HRDW]
GO
/****** Object:  View [dbo].[vGSA_RIF_Retention_Register]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vGSA_RIF_Retention_Register]
AS
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-05-26  
-- Description: Created View

--RIF Retention Register Creation
--Initial Logic by Ralph Silvestro Commencing 4-17-2017
--PeopleSoft Doesn't Have One Yet Based on a FITGAP Meeting in Feb/March 2017
--This is from-- https://www.opm.gov/policy-data-oversight/workforce-restructuring/reductions-in-force/workforce_reshaping.pdf

/*4 Factors are used in a RIF- 
1st - Type of Appointment -3 Tenure Groups: GROUP I, GROUP II, GROUP III
2nd - Veterans Preference - 3 Tenure Sub Groups: SubGroup AD, SubGroup A, SubGroup B
3rd - Length of service - Based on SCD(Service Computation Date) in CHRISBI this means SCD_RIF
4th - Performance Ratings-Additional Service added based on Rating
 */
/*Section R: Vacancies for Assignment
Management’s Decision to Fill Vacant Positions During a RIF. An agency is not
required to fill vacant positions in a RIF, but the agency may decide to fill all, some, or
no vacant positions.*/
--Competitive S ervice Temporary Positions Are Not Available Positions.

/*Only Qualified Employees Have Assignment Rights. An employee released from a
competitive level by RIF has bump or retreat rights to another position held by an
employee with lower retention standing only if the released employee is qualified for
assignment.*/
/*Fully Trained Employees Have No Assignment Rights to a Trainee or Developmental
Position.*/

/*guidance on post-RIF actions:
  Career Transition Assistance Plan (CTAP) (Section A)
  Interagency Career Transition Assistance Plan (ICTAP (Section B)
  Reemployment Priority List (Section C)
  Retraining Options Under the Workforce Investment Act of 1998 (Section D)*/

SELECT
  'PII' AS 'SAFEGUARD'
, pos.[RecordDate]
, p.LastName + ', ' + p.FirstName + ' ' + IsNull(p.MiddleName, '') as FullName
, s.[PosOrgAgySubelementDescription]
, posI.PositionTitle
, posI.PayPlan + '-' + posI.[PositionSeries] + '-' + posI.Grade as PPSeriesGrade 
, posI.PayPlan AS 'Just PP'
, posD.[DateProbTrialPeriodBegins]
, posD.[DateProbTrialPeriodEnds] 
, posD.[DateConversionCareerDue]
, fin.[AppointmentAuthCode]
, fin.[AppointmentAuthDesc]
, pos.[TenureDescription]
, fin.[AppointmentType]
, CASE 
	  WHEN fin.[AppointmentType] = 'Competitive -- Career' 
	  THEN 'Group I Competitive'
      WHEN fin.[AppointmentType] = 'Competitive -- Career-Conditional' 
	  THEN 'Group II Competitive'
	  WHEN fin.[AppointmentType] LIKE '%Special Tenure%' 
	       AND 
		   fin.[AppointmentAuthCode] ='LPM' 
		   AND 
		   posD.[DateProbTrialPeriodEnds]  < GETDATE() 
	  THEN 'Group I Competitive'--Rare Bird Chapter 9. Career and Career-Conditional Appointments 9-31. October 18, 2012
	  WHEN fin.[AppointmentType] LIKE '%Special Tenure%' 
		   AND 
		   fin.[AppointmentAuthCode] ='LPM' 
		   AND 
		   posD.[DateProbTrialPeriodEnds]  > GETDATE() 
	  THEN 'Group II Competitive'--Rare Bird Chapter 9. Career and Career-Conditional Appointments 9-31. October 18, 2012
	  WHEN fin.[AppointmentType] IN (
									   'Temporary Appointment Pending Establishment of Register (TAPER)'
									  ,'Term Appointment -- NTE'
									  ) 
	  THEN 'Group 0 Competitive'
	  WHEN fin.[AppointmentType] ='Emergency -- Indefinite' 
	  THEN 'Group III Competitive'
	  WHEN fin.[AppointmentType] LIKE '%Provisional Appointment%' 
	  THEN 'Group III Competitive'
	  WHEN fin.[AppointmentType] LIKE '%Status%Quo%' 
	  THEN 'Group III Competitive'
	  WHEN fin.[AppointmentType] ='Excepted -- Career' 
	  THEN 'Group I Excepted'
	  WHEN fin.[AppointmentType] ='Excepted-Conditional' 
	  THEN 'Group II Excepted'
	  WHEN fin.[AppointmentType] = 'Veterans Readjustment' 
	  THEN 'Group II Excepted'
	  WHEN fin.[AppointmentType] IN (
									   'Excepted Indefinite'
									  ,'Excepted Appointment -- NTE'
									  ) 
	  THEN 'Group III Excepted'
	  ELSE '' 
  END AS 'OPM Service Tenure Groups'
--Note SES don't compete in RIF's with non-SE employees and are separate.  There is a separate data field
--called Date SES Probation Expires and you would use Date SES Appt (like or in place of Latest Hire Date)
--So if the Date SES Appt exists and Date SES Probation Expires doesn't exist then the amount of time >1 year 
--between Date SES Appt and the Current Computer System Date to determin if the SES has 1 year.
--,CASE WHEN ([Date Spvr/Mgr Prob Ends] IS NULL OR [Date SES Prob Expires] IS NULL) THEN
-- 'Dte Missing SES' ELSE 'Dte Exists SES ' END AS  'Chk SES Dte'
--,CASE WHEN ([Date Spvr/Mgr Prob Ends] IS NULL OR [Date SES Prob Expires] IS NULL) AND 
--DATEDIFF(YEAR,[Date of SES Appointment],GETDATE()) < 1 THEN 'On Probationary Period'
--ELSE 'Not On Probationary Period' END AS 'SES Probationary Period Determination'
, posD.[SCD_RIF]
, DATEADD(yy,(-1*(dbo.gsa_fn_get_SCD_RIFAdjYears (p.PersonID))),posD.SCD_RIF)
		 AS Adj_SCD_RIF
, posD.[LatestHireDate]
--Vast Amt of GSA employee records have null for datafield called:[Date Prob/Trial Period Ends] 
--Further, this data field is a key data field to determine Tenure meaning GROUP I, GROUP II, etc..
--Definition of Probationary Period- The first year of service of an employee who is given a career or career-conditional appointment
--So, for those employees at GSA having a Latest Hire Date at least 1 year or more out from the LHD(Latest Hire Date) versus the Computer System Date
--at the time of running the query will be used as a surrogate for completion of the initial probationary period.
 --**************************************************************************************************************************
  --This Portion is for RIFS OF COMPETITIVE POSITIONS--
 --Career Employees Probationary Period Served Already.
 
-------------------------------------------------------------
--This section deals with Veteran's Preference--------------
--This section deals with Veteran's Preference--------------
-------------------------------------------------------------
, p.[VeteransPreferenceDescription]
, CASE 
	WHEN  p.[VeteransPreferenceDescription] ='10-Point/Compensable/30 Percent'--Veterans with 30%
    THEN 'SubGroup AD'
    WHEN  p.[VeteransPreferenceDescription] IN ('10-Point/Compensable','10-Point/Disability',
	  '10-Point/Other', '5-Point') THEN 'SubGroup A' --Veterans not with 30%
	WHEN  p.[VeteransPreferenceDescription] ='None' THEN 'SubGroup B'--Non Veterans
	ELSE 'None' 
  END AS 'Veterans Pref'
, CASE 
    WHEN p.[VeteransPreferenceDescription] ='10-Point/Compensable/30 Percent' --'Veterans Pref' = 'SubGroup AD' 
    THEN 1 
	ELSE 2 
  END AS 'Order VPref'
--There is no authority to place an employee in retention subgroup AD on the basis of
--derivative preference.  
--Derivative Preference in RIF. Veterans’ preference also extends to four types of
--employees who are eligible for derivative preference, and who are therefore in retention
--subgroup A:
--1. The unmarried widow or widower of a veteran, as “veteran” is defined in section
--2108(1)(A) of title 5, United States Code (5 U.S.C. 2108(3)(D));
--2. The spouse of a service-connected disabled veteran, as “disabled veteran” is
--defined in section 2108(2) of title 5, United States Code, who has been unable to
--qualify for a Federal position (5 U.S.C. 2108(3)(E));
--3. The mother of a veteran (as “veteran” is defined in section 2108(1)(A) of title 5,
--United States Code) who died in a war or campaign, provided that the mother also
--meets other statutory conditions covered in section 2108(3)(F) of title 5, United
--States Code (5 U.S.C. 2108(3)(F)); or
--4. The mother of a permanently disabled veteran (as “disabled veteran” is defined in
--section 2108(2) of title 5, United States Code), provided that the mother also
--meets other statutory conditions covered in section 2108(3)(G) of title 5, United
--States Code (5 U.S.C. 2108(3)(G)).
, posI.PayPlan AS 'VPP'
, posI.PositionSeries AS 'Occ Series'
, posI.Grade AS 'VGr'
, posI.[OfficeSymbol]
, pos.[WorkScheduleDescription]
, pos.[CompetativeArea] AS CompetitiveAreaCode
 -- Employees in a competitive area compete for retention under the RIF regulations only
--with other employees in the same competitive area.Employees do not compete for
--retention with employees of the agency who are in a different competitive area.
--There is no minimum or maximum number of employees in a competitive area.
--An employee who teleworks competes in RIF on the basis of the duty station or work site
--documented for the employee’s official position of record.
--Generally, an agency must define each competitive area
--solely in terms of organizational unit(s) and geographical location(s).
--The same competitive area standard applies to both headquarters and field activities
--Inspector General Competitive Areas. An agency must establish a separate
--competitive area for an Inspector General activity established under authority of the
--Inspector General Act of 1978 (Public Law 95-452, as amended). This competitive area
--consists of only employees of the Inspector General activity.

/*Local Commuting Area. The geographic area that usually includes one area for
employment purposes, as determined by the agency. The local commuting area includes
any population center (or two or more neighboring centers) and the surrounding localities
in which people live and can reasonably be expected to travel back and forth every day to
their usual employment. Each agency has the right and the responsibility to define local
commuting areas and apply this definition. OPM has not established a mileage standard
to determine when two local duty stations would be included in the same local
commuting area.*/
/*Record of Competitive Area Definitions. When an agency establishes or changes
competitive areas, it must publish descriptions of the areas or otherwise make them
readily available for review by employees and OPM. The agency usually includes its
competitive area definition(s) in its internal personnel manual, or with similar documents
relating to the agency’s specific RIF procedures.*/

--Restriction on Changing Competitive Area Definitions Within 90 Days of the RIF
--Effective Date.
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
, pos.[CompetativeLevel] AS CompetitiveLevelCode

 --Position Descriptions are Basis for Competitive Levels.
 /*Establishing Competitive Levels. A competitive level consists of positions in the
competitive area that are:
1. In the same grade (or occupational level);
2. In the same classification series; and
3. Similar enough in duties, qualification requirements, pay schedules, and working
conditions, so that an agency may reassign the incumbent of one position to any
of the other positions in the level without causing undue interruption in the
agency’s work.*/

/*Interchangeable Positions are in the Same Competitive Level. Positions in the same
competitive level are so similar that the agency may readily assign an employee in one
position to any of the other positions in the competitive level:
1. Without changing the terms of the employee’s appointment; and
2. Without undue interruption to the agency’s work program.
There is no minimum or maximum number of positions that can be placed in a
competitive level; for example, a competitive level could potentially consist of one
unique position.*/

/*interchangeability covered above, the agency must establish separate competitive levels
for certain positions:
1. Competitive and Excepted Service: The agency must establish separate
competitive levels for positions in the competitive service, and for positions in the
excepted service. Employees who hold excepted service appointments in
competitive service positions (e.g., Veterans Recruitment Appointments (VRA))
compete for retention in the excepted service, but do not compete for retention
with employees who hold the same positions under competitive service
appointments.
2. Excepted Service Appointment Authority: The agency establishes separate
competitive levels for excepted service positions filled under different appointing
authorities. Employees who hold excepted service appointments in competitive
service positions compete for retention in the excepted service only with other
employees holding positions under the same excepted service appointing
authority. For example, employees holding excepted service VRA positions
compete for retention only with other employees who hold the same positions
under VRA appointments.
3. Pay System: The agency establishes separate competitive levels for positions
filled under different pay systems or pay schedules.
4. Work Schedule: The agency establishes separate competitive levels for positions
filled on different work schedules—
• Full-time;
• Part-time;
• Intermittent; or
• Seasonal.
An agency has no authority to establish separate competitive levels based upon
subsets of the four work schedule categories covered above (e.g., an agency may
not establish one competitive level for full-time seasonals and a second for parttime
seasonals when the positions are otherwise interchangeable).

5. Formally Designated Trainee or Developmental Positions: The agency
establishes separate competitive levels for positions filled by employees in a
formally designated trainee or developmental program that has the following
characteristics:
• Is designed to meet the agency’s needs and requirements for the
development of skilled personnel;
• Is formally designated as a trainee or developmental program, with its
provisions announced to employees and supervisors;
• Is developmental by design, offering planned growth in duties and
responsibilities and providing advancement in recognized lines of career
progression; and
• Is fully implemented, with the participants chosen for the program through
standard selection procedures.
6. Supervisory Positions and Competitive Levels: The RIF regulations no longer
have a specific requirement that an agency must establish a separate competitive
level solely because an employee holds a supervisory rather than a
nonsupervisory position. (Note: The duties and responsibilities of a supervisory
position will generally preclude placement of the position in a competitive level
that includes a nonsupervisory position.)
7. Mixed Tours Positions and Competitive Levels. An employee serving on a mixed
tour of duty is placed in an other-than-full-time competitive level consistent with
the employment agreement between the agency and the employee serving in the
mixed tour of duty position.

/******Mobility Agreements and Travel Not Considered in Competitive Levels*/

*/
FROM 
Person p
INNER JOIN dbo.Position pos
	on pos.PersonID = p.PersonID	
	AND pos.RecordDate = 
--      JJM 2016-10-03 get max RecordDate for table instead of Person so that employees with changed SSNs are excluded
		(select Max(pos1.RecordDate) as MaxRecDate from dbo.Position pos1)
		AND pos.PositionDateID = 
		(select Max(pos2.PositionDateID) as MaxPosDateId from dbo.Position pos2 
		where pos2.FY = pos.FY and pos2.PersonID = pos.PersonID and pos2.RecordDate = pos.RecordDate)  -- 28,264 records, make sure one person only contains one Position record. If for any reason, a person has two position dates, get the latest one.
	AND pos.[PosOrgAgySubelementCode] <> 'GS15'

INNER JOIN dbo.PositionDate posD
	on posD.PositionDateId = pos.PositionDateId		

	--Include the following condition if only new hires in current FY is selected. matching 460 rows for new hires in FY2016
	--and datediff(day, cast(dbo.Riv_fn_ComputeFiscalYear(posD.LatestHireDate) as datetime), cast(dbo.Riv_fn_ComputeFiscalYear(getdate()) as datetime)) = 0  

INNER JOIN dbo.PositionInfo posI
	on posI.PositionInfoId = pos.ChrisPositionId
	   -- only Perm or Temp employees are selected
	   AND 
	   (
	   posI.PositionEncumberedType = 'Employee Permanent' 
	   OR 
	   posI.PositionEncumberedType = 'Employee Temporary'
	   )	
	   AND
	   posI.PayPlan NOT IN ('ES','IG','ED','SL','EX') --These Payplans don't compete with GS/GM/Wage Grades. 

inner join dbo.Financials fin
	on fin.FinancialsID = pos.FinancialsID

left outer join [dbo].[SSOLkup] s 
        on s.[PosOrgAgySubelementCode] = pos.[PosOrgAgySubelementCode]


GO
