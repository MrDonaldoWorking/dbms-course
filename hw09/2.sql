-- Help procedure for adding new users
create or replace procedure CreateNewUser(in UId int, in Pass varchar(50))
    language plpgsql
    security definer
as
$$
begin
    insert into Users
        (UserId, Passwd)
        values
        (UId, crypt(Pass, gen_salt('bf')));
end
$$;

create or replace function IsValidUser(in UId int, in Pass varchar(50))
    returns boolean
    language plpgsql
    security definer
as
$$
begin
    return exists (
        select UserId
            from Users
            where UserId = UId
                and Passwd = crypt(Pass, Passwd)
    );
end
$$;

create or replace function Reserve(in UId int, in Pass varchar(50), in FId int, in SNo varchar(4))
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
    
    -- check if Seat in this Plane actually exists
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

    -- if exist an old expired log update needed, else insert
    if exists (
        select FlightId
            from Tickets
            where FlightId = FId
                and SeatNo = SNo
                and State = 'reserved'
    ) then
        update Tickets
            set UserId = UId,
                Expires = now() + interval '3 day'
            where FlightId = FId
                and SeatNo = SNo;
    else
        insert into Tickets
            (FlightId, SeatNo, State, UserId, Expires)
            values
            (FId, SNo, 'reserved', UId, now() + interval '3 day');
    end if;

    return true;
end
$$;
