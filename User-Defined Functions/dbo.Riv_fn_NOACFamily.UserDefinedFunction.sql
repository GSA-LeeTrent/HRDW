USE [HRDW]
GO
/****** Object:  UserDefinedFunction [dbo].[Riv_fn_NOACFamily]    Script Date: 5/1/2018 1:42:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-06-24  
-- Description: Function Created
-- Modification  Ralph Silvestro
-- Date:         2017-04-05
-- Description:  Identified NOACS 600-699 as "Phased Retirements" Family.  
--               800 Action originally indicated Transactions but reworded Award Transactions
--               900 Action changed from Unknown to "Unknown New Possible Problem"
--               Everything else left intact.
-- =============================================================================

CREATE function [dbo].[Riv_fn_NOACFamily](
	@noac int
) returns varchar(128)
begin 
	
	declare @Result varchar(128)
	select @result= 
	Case 
		When @noac >= 100 and @noac <=199 then 'Accessions'
		When @noac >= 200 and @noac <=299 then 'Return from Non Duty Status- May Involve Movement'
		When @noac >= 300 and @noac <=399 then 'Separations'
		When @noac >= 400 and @noac <=499 then 'Placement in Non Duty Status'
		When @noac >= 500 and @noac <=599 then 'Conversions'
		When @noac >= 600 and @noac <=699 then 'Phased Retirements'--NOACs 615-616-Phased Retirement is a human resources tool that allows full-time employees to work part-time schedules while beginning to draw retirement benefits.
		--https://www.opm.gov/retirement-services/phased-retirement/
		When @noac >= 700 and @noac <=799 then 'Variety of Internal Action Types'
		When @noac >= 800 and @noac <=899 then 'Award Transactions'
		When @noac >= 900 and @noac <=999 then 'Agency Unique NOACS that may involve movement'
		Else 'Unknown New Possible Problem'	
	end	
return @result
end





GO
