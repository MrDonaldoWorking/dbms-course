create table Flights (
    FlightId int not null primary key,
    FlightTime timestamp not null,
    PlaneId int not null
);

create table Seats (
    PlaneId int not null,
    SeatNo varchar(4) not null -- 123A
);

-- View for all seats
create view AllSeats as
    select FlightId, FlightTime, PlaneId, SeatNo
        from Flights
            natural join Seats;

-- Table for users with password
create table Users (
    UserId int not null primary key,
    -- Password hash
    Passwd text not null
);

create type TicketState as enum ('reserved', 'bought');

-- Table for reserved and bought seats
create table Tickets (
    FlightId int not null,
    SeatNo varchar(4) not null,
    State TicketState not null,
    UserId int,
    Expires timestamp,
    primary key (FlightId, SeatNo),
    foreign key (FlightId) references Flights (FlightId),
    foreign key (UserId) references Users (UserId)
);
