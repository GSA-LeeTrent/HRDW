USE [HRDW]
GO
/****** Object:  UserDefinedFunction [dbo].[Riv_fn_NOACFamilyLong]    Script Date: 5/1/2018 1:42:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[Riv_fn_NOACFamilyLong](
	@noac int
) returns varchar(255)
begin 
	
	declare @Result varchar(255), @var varchar(5)
	select @var = space(1) + cast(@noac as varchar(3))+space(1)
	select @result = dbo.Riv_fn_NOACFamily(@noac)
	set @result = 'NOAC' +@var+ 'FAMILY '+ @result
	return @result
end




GO
