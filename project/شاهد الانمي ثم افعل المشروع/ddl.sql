-- drop table if exists People cascade;
-- drop table if exists PersonalTrainers cascade;
-- drop table if exists Pairs cascade;
-- drop table if exists Teams cascade;
-- drop table if exists TeamTrainers cascade;
-- drop table if exists TeamParticipants cascade;
-- drop table if exists Competitions cascade;
-- drop table if exists CompetitionStandings cascade;
-- drop table if exists PerformanceDetails cascade;
-- drop table if exists PerformanceComponents cascade;
-- drop table if exists PerformanceDeductions cascade;
-- drop table if exists ElementInformations cascade;
-- drop type if exists CompetitionType;
-- drop type if exists ComponentType;

create table People (
    PersonId    int             not null generated always as identity,
    PersonName  varchar(128)    not null,
    BirthDate   date            not null,
    Country     varchar(32)     not null,
    
    constraint People_PK primary key (PersonId)
);

create table PersonalTrainers (
    PersonId    int     not null,
    TrainerId   int     not null,
    
    constraint PersonalTrainers_PK primary key (PersonId, TrainerId),
    constraint PersonalTrainers_FK1 foreign key (PersonId) references People (PersonId),
    constraint PersonalTrainers_FK2 foreign key (TrainerId) references People (PersonId)
);

create table Pairs (
    PairId      int         not null generated always as identity,
    PersonMId   int         not null,
    PersonFId   int         not null,
    Country     varchar(32) not null,
    
    constraint Pairs_PK primary key (PairId),
    constraint Pairs_FK1 foreign key (PersonMId) references People (PersonId),
    constraint Pairs_FK2 foreign key (PersonFId) references People (PersonId)
);

create table Teams (
    TeamId      int         not null generated always as identity,
    TeamName    varchar(32) not null,
    Country     varchar(32) not null,
    
    constraint Teams_PK primary key (TeamId)
);

create table TeamTrainers (
    TeamId      int     not null,
    TrainerId   int     not null,
    
    constraint TeamTrainers_PK primary key (TeamId, TrainerId),
    constraint TeamTrainers_FK1 foreign key (TeamId) references Teams (TeamId),
    constraint TeamTrainers_FK2 foreign key (TrainerId) references People (PersonId)
);

create table TeamParticipants (
    TeamId      int     not null,
    PersonId    int     not null,

    constraint TeamParticipants_PK primary key (TeamId, PersonId),
    constraint TeamParticipants_FK1 foreign key (TeamId) references Teams (TeamId),
    constraint TeamParticipants_FK2 foreign key (PersonId) references People (PersonId)
);

create table Competitions (
    CompetitionId       int             not null generated always as identity,
    CompetitionName     varchar(64)     not null,
    DateStarts          date            not null,
    DateEnds            date            not null,
    
    constraint Competitions_PK primary key (CompetitionId),
    constraint Competitions_UQ unique (CompetitionName, DateStarts, DateEnds)
);

create type CompetitionType as enum (
    'Single',
    'Pairs',
    'Dance',
    'Synchronized'
);

create table CompetitionStandings (
    CompetitionId       int             not null,
    CompetitionType     CompetitionType not null,
    CompetitorId        int             not null,
    PerformanceId       int             not null generated always as identity,
    ShortScore          float           not null,
    FreeScroe           float           not null,
    TotalScore          float           not null,
    
    constraint CompetitionStandings_PK primary key (CompetitionId, CompetitionType, CompetitorId),
    constraint CompetitionStandings_FK foreign key (CompetitionId) references Competitions (CompetitionId),
    constraint PerformanceId_UQ unique (PerformanceId)
);

create table ElementInformations (
    ElementAbbreviation varchar(8)  not null,
    ElementDescription  varchar(64) not null,
    SOV                 float       not null,
    
    constraint ElementInformations_PK primary key (ElementAbbreviation),
    constraint ElementDescription_UQ unique (ElementDescription),
    constraint SOV_is_not_negative check ( SOV >= 0 )
);

create table PerformanceDetails (
    PerformanceId       int         not null,
    ElementId           int         not null,
    ElementAbbreviation varchar(8)  not null,
    GOE                 float       not null,
    
    constraint PerformanceDetails_PK primary key (PerformanceId, ElementId),
    constraint PerformanceDetails_FK1 foreign key (PerformanceId) references CompetitionStandings (PerformanceId),
    constraint PerformanceDetails_FK2 foreign key (ElementAbbreviation) references ElementInformations (ElementAbbreviation)
);

create type ComponentType as enum (
    'Skating skills',
    'Transitions',
    'Performance',
    'Composition',
    'Interpretation'
);

-- NOTE: Не нормализовано
create table PerformanceComponents (
    PerformanceId   int             not null,
    ComponentType   ComponentType   not null,
    -- Given Value is already meant by ISU algorithm
    Value           float           not null,
    Factor          float           not null,
    
    constraint PerformanceComponents_PK primary key (PerformanceId, ComponentType),
    constraint PerformanceComponents_FK foreign key (PerformanceId) references CompetitionStandings (PerformanceId),
    constraint Factor_is_in_range_0_2 check ( 0 <= Factor and Factor <= 2 )
);

create table PerformanceDeductions (
    PerformanceId   int     not null,
    Value           int     not null,
    
    constraint PerformanceDeductions_PK primary key (PerformanceId),
    constraint PerformanceDeductions_FK foreign key (PerformanceId) references CompetitionStandings (PerformanceId),
    constraint Value_is_in_range_0_12 check ( 0 <= Value and Value <= 12 )
);
