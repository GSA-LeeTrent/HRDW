USE [HRDW]
GO
/****** Object:  UserDefinedFunction [dbo].[Riv_fn_2CharOfficeSymbol]    Script Date: 5/1/2018 1:42:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[Riv_fn_2CharOfficeSymbol](
	@OfficeSymbol varchar(255)
) returns varchar(255)

begin 
	set @OfficeSymbol=ISNULL(@OfficeSymbol,'')
	declare @2CharCode varchar(8)
	set @2CharCode=''
	if @OfficeSymbol =''
		set @2CharCode=''
    else
    begin		
		SELECT @2CharCode =isnull(OfficeSymbol2Char,'')
		from OfficeLkup O 
		where O.OfficeSymbol = @OfficeSymbol
	end	
	return @2CharCode
end	
  
/*	select @2CharCode = case -- 2015-10-30 Rob Cornelsen Comment out all case / when logic down to same comment below
	when left(@OfficeSymbol,2)='IQ' then 'IQ' 

-- Regional exceptions for FAS & PBS
-- FAS R10, R11 & CO exceptions
    when left(@OfficeSymbol,4)='10Q0' then 'Q'
    when left(@OfficeSymbol,3)='WQ1' then 'Q'
    when left(@OfficeSymbol,3)='Q0A' then 'Q'
-- PBS R10, R11 & CO exceptions
    when @OfficeSymbol='9PH' then 'PC'
    when left(@OfficeSymbol,5)='10PPA' then 'PA'
    when left(@OfficeSymbol,5)='10PPT' then 'PT'
    when left(@OfficeSymbol,4)='10PX' then 'P'
    when left(@OfficeSymbol,3)='WP1' then 'P'
    when left(@OfficeSymbol,3)='WPB' then 'P'
    when left(@OfficeSymbol,3)='WPD' then 'PQ'
    when left(@OfficeSymbol,3)='WPH' then 'PQ'
    when left(@OfficeSymbol,5)='WPGQA' then 'PQ'
    when left(@OfficeSymbol,5)='WPGCB' then 'P'
    when left(@OfficeSymbol,3)='WPI' then 'PC'
    when @OfficeSymbol='PD' then 'P'
    when left(@OfficeSymbol,3)='PDQ' then 'PQ'
    when left(@OfficeSymbol,3)='PTZ' then 'PZ'
    when @OfficeSymbol='PH' then 'P'
-- PBS overide to convert PS office symbols to PM label
    --when int(str(left(@OfficeSymbol,1)))<10 and right(left(@OfficeSymbol,3),2)='PS' then 'PM' 
	when isNumeric(left(@OfficeSymbol,1))=1 and right(left(@OfficeSymbol,3),2)='PS' then 'PM' 
	
    when left(@OfficeSymbol,5)='9P3PS' then 'PM' 
    when left(@OfficeSymbol,4)='10PS' then 'PM' 
-- ----------------------------------------
-- Normal rules apply for R10 and R11
-- Region 10
    when len(@OfficeSymbol)=3 and left(@OfficeSymbol,2)='10' then right(@OfficeSymbol,1)
    when len(@OfficeSymbol)=4 and left(@OfficeSymbol,2)='10' then right(@OfficeSymbol,2)

    --when len(@OfficeSymbol)>4 and left(@OfficeSymbol,2)='10' and right(left(@OfficeSymbol,3),1)='P' 
    --    and int(str(right(left(@OfficeSymbol,4),1)))>=0 then right(left(@OfficeSymbol,6),2)
	  when len(@OfficeSymbol)>4 and left(@OfficeSymbol,2)='10' and right(left(@OfficeSymbol,3),1)='P' 
        and isNumeric(right(left(@OfficeSymbol,4),1))=1  then right(left(@OfficeSymbol,6),2)

    when len(@OfficeSymbol)>4 and left(@OfficeSymbol,2)='10' and right(left(@OfficeSymbol,3),1)='Q'     
        then right(left(@OfficeSymbol,4),2)

    --when len(@OfficeSymbol)>4 and left(@OfficeSymbol,2)='10' and right(left(@OfficeSymbol,3),1)='Q' 
    --    and int(str(right(left(@OfficeSymbol,4),1)))>=0 then right(left(@OfficeSymbol,3),1) + right(left(@OfficeSymbol,5),1)
	when len(@OfficeSymbol)>4 and left(@OfficeSymbol,2)='10' and right(left(@OfficeSymbol,3),1)='Q' 
    and isNumeric(right(left(@OfficeSymbol,4),1))=1 then right(left(@OfficeSymbol,3),1) + right(left(@OfficeSymbol,5),1)

    when len(@OfficeSymbol)>4 and left(@OfficeSymbol,2)='10' and right(left(@OfficeSymbol,3),1)='P' 
        then right(left(@OfficeSymbol,4),2)

-- Region 11, starts with W
    when len(@OfficeSymbol)=2 and left(@OfficeSymbol,1)='W' then right(@OfficeSymbol,1)
    when len(@OfficeSymbol)>2 and left(@OfficeSymbol,1)='W' then right(left(@OfficeSymbol,3),2)
-- ----------------------------------------
-- Business line exceptions for FAS & PBS
-- Note: unique rules apply below and require regular revew
-- FAS changes as of 5-Mar-15
    when right(left(@OfficeSymbol,3),2)='Q0' then 'Q'
    when right(left(@OfficeSymbol,3),2)='QE' then 'Q'
    when left(@OfficeSymbol,3)='6Q1' and len(@OfficeSymbol)<4 then 'Q'
    when left(@OfficeSymbol,3)<>'6Q1' and right(left(@OfficeSymbol,3),2)='Q1' then 'Q'
-- PBS changes as of 5-Mar-15
    when @OfficeSymbol='9PH' then 'PC'
    when right(left(@OfficeSymbol,5),4)='P1PG' then 'P'
    when right(left(@OfficeSymbol,5),4)='P2PG' then 'P'
    when left(@OfficeSymbol,5)='3P1PI' then 'P'
    --when len(@OfficeSymbol)=3 and int(str(left(@OfficeSymbol,1)))<10 and right(left(@OfficeSymbol,3),2)='P1' then 'P'
    --when len(@OfficeSymbol)=3 and int(str(left(@OfficeSymbol,1)))<10 and right(left(@OfficeSymbol,3),2)='P2' then 'P'
	when len(@OfficeSymbol)=3 and isNumeric(left(@OfficeSymbol,1))=1 and right(left(@OfficeSymbol,3),2)='P1' then 'P'
    when len(@OfficeSymbol)=3 and isNumeric(left(@OfficeSymbol,1))=1 and right(left(@OfficeSymbol,3),2)='P2' then 'P'
-- ----------------------------------------
-- Normal rules agency wide
-- For all offices starting with 1-9
-- Two-letter 
--    when len(@OfficeSymbol)=2 and int(str(left(@OfficeSymbol,1)))<10 and right(left(@OfficeSymbol,2),1)='P'
--        then right(@OfficeSymbol,1) 
--    when len(@OfficeSymbol)=2 and int(str(left(@OfficeSymbol,1)))<10 and right(left(@OfficeSymbol,2),1)='Q'
--        then right(@OfficeSymbol,1) 
--    when len(@OfficeSymbol)=2 and int(str(left(@OfficeSymbol,1)))<10
--        then right(@OfficeSymbol,1) 
---- Three-letter 
--    when len(@OfficeSymbol)=3 and int(str(left(@OfficeSymbol,1)))<10 and right(left(@OfficeSymbol,2),1)='P'
--        then right(@OfficeSymbol,2) 
--    when len(@OfficeSymbol)=3 and int(str(left(@OfficeSymbol,1)))<10 and right(left(@OfficeSymbol,2),1)='Q'
--        then right(@OfficeSymbol,2) 
--    when len(@OfficeSymbol)=3 and int(str(left(@OfficeSymbol,1)))<10 
--        then right(@OfficeSymbol,2) 
---- Check for digit in third spot (part one)
--    when len(@OfficeSymbol)=4 and int(str(left(@OfficeSymbol,1)))<10 and right(left(@OfficeSymbol,2),1)='P' 
--        and int(str(right(left(@OfficeSymbol,3),1)))>=0 then right(left(@OfficeSymbol,4),3)
--    when len(@OfficeSymbol)=4 and int(str(left(@OfficeSymbol,1)))<10 and right(left(@OfficeSymbol,2),1)='Q' 
--        and int(str(right(left(@OfficeSymbol,3),1)))>=0 then right(left(@OfficeSymbol,2),1) + right(left(@OfficeSymbol,4),1)
---- Check for digit in third spot (part two)
--    when len(@OfficeSymbol)>4 and int(str(left(@OfficeSymbol,1)))<10 and right(left(@OfficeSymbol,2),1)='P' 
--        and int(str(right(left(@OfficeSymbol,3),1)))>=0 then right(left(@OfficeSymbol,5),2)
--    when len(@OfficeSymbol)>4 and int(str(left(@OfficeSymbol,1)))<10 and right(left(@OfficeSymbol,4),3)='Q1Q' 
--        then right(left(@OfficeSymbol,5),2)
--    when len(@OfficeSymbol)>4 and int(str(left(@OfficeSymbol,1)))<10 and right(left(@OfficeSymbol,2),1)='Q' 
--        and int(str(right(left(@OfficeSymbol,3),1)))>=0 then right(left(@OfficeSymbol,2),1) + right(left(@OfficeSymbol,4),1)
---- All other
--when int(str(left(@OfficeSymbol,1)))<10 
--    then right(left(@OfficeSymbol,3),2)
---- ----------------------------------------
---- Check for digit in second spot (ex H1, M1)
--when int(str(right(left(@OfficeSymbol,2),1)))>0 then left(@OfficeSymbol,1) + right(left(@OfficeSymbol,3),1)
---- ----------------------------------------
-- Normal rules agency wide
-- For all offices starting with 1-9
-- Two-letter 
    when len(@OfficeSymbol)=2 and isNumeric(left(@OfficeSymbol,1))=1 and right(left(@OfficeSymbol,2),1)='P'
        then right(@OfficeSymbol,1) 
    when len(@OfficeSymbol)=2 and isNumeric(left(@OfficeSymbol,1))=1 and right(left(@OfficeSymbol,2),1)='Q'
        then right(@OfficeSymbol,1) 
    when len(@OfficeSymbol)=2 and isNumeric(left(@OfficeSymbol,1))=1
        then right(@OfficeSymbol,1) 
-- Three-letter 
    when len(@OfficeSymbol)=3 and isNumeric(left(@OfficeSymbol,1))=1 and right(left(@OfficeSymbol,2),1)='P'
        then right(@OfficeSymbol,2) 
    when len(@OfficeSymbol)=3 and isNumeric(left(@OfficeSymbol,1))=1 and right(left(@OfficeSymbol,2),1)='Q'
        then right(@OfficeSymbol,2) 
    when len(@OfficeSymbol)=3 and isNumeric(left(@OfficeSymbol,1))=1
        then right(@OfficeSymbol,2) 
-- Check for digit in third spot (part one)
    when len(@OfficeSymbol)=4 and isNumeric(left(@OfficeSymbol,1))=1 and right(left(@OfficeSymbol,2),1)='P' 
        and isNumeric(right(left(@OfficeSymbol,3),1))=1 then right(left(@OfficeSymbol,4),3)
    when len(@OfficeSymbol)=4 and isNumeric(left(@OfficeSymbol,1))=1 and right(left(@OfficeSymbol,2),1)='Q' 
        and isNumeric(right(left(@OfficeSymbol,3),1))=1 then right(left(@OfficeSymbol,2),1) + right(left(@OfficeSymbol,4),1)
-- Check for digit in third spot (part two)
    when len(@OfficeSymbol)>4 and isNumeric(left(@OfficeSymbol,1))=1 and right(left(@OfficeSymbol,2),1)='P' 
        and isNumeric(right(left(@OfficeSymbol,3),1))=1 then right(left(@OfficeSymbol,5),2)
    when len(@OfficeSymbol)>4 and isNumeric(left(@OfficeSymbol,1))=1 and right(left(@OfficeSymbol,4),3)='Q1Q' 
        then right(left(@OfficeSymbol,5),2)
    when len(@OfficeSymbol)>4 and isNumeric(left(@OfficeSymbol,1))=1 and right(left(@OfficeSymbol,2),1)='Q' 
        and isNumeric(right(left(@OfficeSymbol,3),1))=1 then right(left(@OfficeSymbol,2),1) + right(left(@OfficeSymbol,4),1)
-- All other
	when isNumeric(left(@OfficeSymbol,1))=1 
		then right(left(@OfficeSymbol,3),2)
	---- ----------------------------------------
	---- Check for digit in second spot (ex H1, M1)
	--when int(str(right(left(@OfficeSymbol,2),1)))>0 then left(@OfficeSymbol,1) + right(left(@OfficeSymbol,3),1)
	---- ----------------------------------------
	-- All other
	else left(@OfficeSymbol,2) 
	end   */ -- 2015-10-30 Rob Cornelsen Comment out all case / when logic
--	return @2CharCode
--end	

GO
