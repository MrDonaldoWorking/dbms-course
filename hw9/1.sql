create or replace function FindNotFreeSeats(in FId int)
    returns Table (
        SeatNo varchar(4)
    )
    language plpgsql
    security definer
as
$$
begin
    return query
    select Tickets.SeatNo
        from Tickets
        where FlightId = FId
            and State = 'reserved' and Expires > now()
            or State = 'bought'
    union
    select AllSeats.SeatNo
        from AllSeats
        where FlightId = FId
            and FlightTime < now();
end
$$;

create or replace function FreeSeats(in FId int)
    returns Table (
        SeatNo varchar(4)
    )
    language plpgsql
    security definer
as
$$
declare PId int;
begin
    PId := (
        select PlaneId from Flights where FlightId = FId
    );
    return query
    select s.SeatNo
        from Seats s
        where PlaneId = PId
            and s.SeatNo not in (
                select FindNotFreeSeats.SeatNo from FindNotFreeSeats(FId)
            );
end
$$;
