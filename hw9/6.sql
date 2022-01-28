create or replace function FlightsStatistics(in UId int, in Pass varchar(50))
    returns Table (
        Reservable int,
        Buyable int,
        Free int,
        Reserved int,
        Bought int
    )
    language plpgsql
    security definer
as
$$
declare allAvailableSeats int;
declare boughtSeats int;
declare reservedSeats int;
declare freeSeats int;
declare reservedByUser int;
begin
    if not IsValidUser(UId, Pass) then
        return;
    end if;

    allAvailableSeats := (
        select count(*)
            from AllSeats
            where FlightTime > now()
    );
    boughtSeats := (
        select count(*)
            from Tickets
                natural join AllSeats
            where State = 'bought'
                and FlightTime > now()
    );
    reservedSeats := (
        select count(*)
            from Tickets
                natural join AllSeats
            where State = 'reserved'
                and Expires > now()
                and FlightTime > now()
    );
    freeSeats := allAvailableSeats - boughtSeats - reservedSeats;
    
    reservedByUser := (
        select count(*)
            from Tickets
                natural join AllSeats
            where State = 'reserved'
                and UserId = UId
                and Expires > now()
                and FlightTime > now()
    );
    
    return query
    select *
        from (values
            (freeSeats, freeSeats + reservedByUser, freeSeats, reservedSeats, boughtSeats)
        ) as t
            (Reservable, Buyable, Free, Reserved, Bought);
end
$$;
