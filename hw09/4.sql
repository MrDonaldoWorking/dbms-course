create or replace function BuyFree(in FId int, in SNo varchar(4))
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

    if SNo not in (
        select SeatNo
            from AllSeats
            where FlightId = FId
    ) then
        return false;
    end if;
    
    if SNo in (
        select FindNotFreeSeats.SeatNo from FindNotFreeSeats(FId)
    ) then
        return false;
    end if;
    
    insert into Tickets
        (FlightId, SeatNo, State)
        values
        (FId, SNo, 'bought');
    
    return true;
end
$$;
