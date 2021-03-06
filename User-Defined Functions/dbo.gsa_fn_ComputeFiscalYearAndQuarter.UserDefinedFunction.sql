USE [HRDW]
GO
/****** Object:  UserDefinedFunction [dbo].[gsa_fn_ComputeFiscalYearAndQuarter]    Script Date: 5/1/2018 1:42:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[gsa_fn_ComputeFiscalYearAndQuarter](
	@dt_in datetime
) returns varchar(9)
begin 
	Declare @year int
	declare @Result varchar(4)
	declare @quarter varchar(2)

	set @year = datepart(yy,@dt_in)
	if datepart(mm,@dt_in) > 9
		set @year = @year+1

	set @year = datepart(yy,@dt_in)

	select @quarter =
	CASE
		WHEN datepart(mm,@dt_in) >= 9 and datepart(mm,@dt_in) <= 12
		THEN 'Q1'
		WHEN datepart(mm,@dt_in) >= 1 and datepart(mm,@dt_in) <= 3
		THEN 'Q2'
		WHEN datepart(mm,@dt_in) >= 4 and datepart(mm,@dt_in) <= 6
		THEN 'Q3'
		WHEN datepart(mm,@dt_in) >= 7 and datepart(mm,@dt_in) <= 9						 
		THEN 'Q4'
	END

	return CONCAT('FY',cast(@year as varchar(4)),'-',@quarter)
end	


GO
