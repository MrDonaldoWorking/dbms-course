create or replace procedure CompressSeats(in FId int)
    language plpgsql
    security definer
as
$$
declare currentSeat varchar(4);
declare seatCursor cursor for
    select SeatNo
        from AllSeats
        where FlightId = FId
        order by SeatNo
    for read only;
declare boughtCursor cursor for
    select SeatNo
        from Tickets
        where FlightId = FId
            and State = 'bought'
        order by SeatNo
    for update;
declare reservedCursor cursor for
    select SeatNo
        from Tickets
        where FlightId = FId
            and State = 'reserved'
        order by SeatNo
    for update;
begin
    if not exists (
        select FlightId from Flights where FlightId = FId
    ) then
        return;
    end if;
    
    open seatCursor;
--     open boughtCursor;
    for SNo in boughtCursor loop
        fetch next from seatCursor into currentSeat;
        update Tickets
            set SeatNo = currentSeat
            where current of boughtCursor;
    end loop;
--     close boughtCursor;
--     
--     open reservedCursor;
    for SNo in reservedCursor loop
        fetch next from seatCursor into currentSeat;
        update Tickets
            set SeatNo = currentSeat
            where current of reservedCursor;
    end loop;
--     close reservedCursor;
    close seatCursor;
end
$$;
