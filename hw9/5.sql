create or replace function BuyReserved(in UId int, in Pass varchar(50), in FId int, in SNo varchar(4))
    returns boolean
    language plpgsql
    security definer
as
$$
begin
    if not exists (
        select FlightId from Flights where FlightId = FId
    ) then
        return false;
    end if;
    
    if not IsValidUser(UId, Pass) then
        return false;
    end if;
    
    if exists (
        select FlightId
            from Tickets
            where FlightId = FId
                and SeatNo = SNo
                and State = 'reserved'
                and UserId = UId
                and Expires > now()
    ) then
        update Tickets
            set State = 'bought',
                UserId = null,
                Expires = null
            where FlightId = FId
                and SeatNo = SNo;
        return true;
    end if;
    
    return false;
end
$$;
