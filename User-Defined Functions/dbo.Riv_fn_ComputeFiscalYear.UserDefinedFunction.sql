USE [HRDW]
GO
/****** Object:  UserDefinedFunction [dbo].[Riv_fn_ComputeFiscalYear]    Script Date: 5/1/2018 1:42:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[Riv_fn_ComputeFiscalYear](
	@dt_in datetime
) returns varchar(4)
begin 
	Declare @year int
	declare @Result varchar(4)
	set @result = datepart(yy,@dt_in)
	if datepart(mm,@dt_in) > 9
		set @result = @result+1
	return cast(@result as varchar(4))

end	








GO
