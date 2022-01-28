create extension pgcrypto;

create type EndGameType as enum (
    'WhiteWins',
    'BlackWins',
    'Draw',
    'WhiteSurrender',
    'BlackSurrender'
    );

create type MessageType as enum (
    'DirectMessage',
    'GameComment',
    'ForumMessage'
    );

create table Users
(
    UserId      int          not null generated always as identity,
    Login       varchar(32)  not null,
    PasswordSha varchar(256) not null,

    constraint Users_PK primary key (UserId),
    constraint Users_K1 unique (Login)
);

create table GameTypes
(
    InitialGameTypeTime    int         not null,
    AdditionalGameTypeTime int         not null,
    GameTypeName           varchar(64) not null,

    constraint GameTypes_PK primary key (InitialGameTypeTime, AdditionalGameTypeTime),
    constraint GameTypes_check_InitialGameTypeTime_positive check ( InitialGameTypeTime > 0 ),
    constraint GameTypes_check_AdditionalGameTypeTime_not_negative check ( AdditionalGameTypeTime >= 0 )
);

create table Ratings
(
    UserId                 int not null,
    InitialGameTypeTime    int not null,
    AdditionalGameTypeTime int not null,
    Score                  int not null,

    constraint Ratings_PK primary key (UserId, InitialGameTypeTime, AdditionalGameTypeTime),
    constraint Ratings_FK1 foreign key (UserId) references Users (UserId),
    constraint Ratings_FK2 foreign key (InitialGameTypeTime, AdditionalGameTypeTime) references GameTypes (InitialGameTypeTime, AdditionalGameTypeTime),
    constraint Ratings_check_Score_not_negative check ( Score >= 0 )
);

create table Divisions
(
    DivisionId         int         not null generated always as identity,
    DivisionName       varchar(32) not null,
    DivisionScoreBound int         not null,

    constraint Divisions_PK primary key (DivisionId),
    constraint Divisions_check_DivisionScoreBound_not_negative check ( DivisionScoreBound >= 0 )
);

create table Games
(
    GameId                 int       not null generated always as identity,
    StartGameTime          timestamp not null,
    InitialGameTypeTime    int       not null,
    AdditionalGameTypeTime int       not null,
    WhitePlayerId          int       not null,
    BlackPlayerId          int       not null,

    constraint Games_PK primary key (GameId),
    constraint Games_FK1 foreign key (InitialGameTypeTime, AdditionalGameTypeTime) references GameTypes (InitialGameTypeTime, AdditionalGameTypeTime),
    constraint Games_FK2 foreign key (WhitePlayerId) references Users (UserId),
    constraint Games_FK3 foreign key (BlackPlayerId) references Users (UserId),
    constraint Games_check_WhitePlayerId_is_not_equals_to_BlackPlayerId check ( WhitePlayerId <> BlackPlayerId )
);

create or replace function CheckGameResultEndGameTimeCorrect(
    in GameId int,
    in EndGameTime timestamp
)
    returns boolean
    security definer
as
$$
begin
    return CheckGameResultEndGameTimeCorrect.EndGameTime >=
           (select StartGameTime from Games where Games.GameId = CheckGameResultEndGameTimeCorrect.GameId);
end;
$$ language plpgsql;

create table GameResults
(
    GameId      int         not null,
    EndGameTime timestamp   not null,
    EndGameType EndGameType not null,

    constraint GameResults_PK primary key (GameId),
    constraint GameResults_FK1 foreign key (GameId) references Games (GameId),
    constraint GameResults_EndGameType_is_grater_than_StartGameTime check ( CheckGameResultEndGameTimeCorrect(GameId, EndGameTime) )
);

create or replace function CheckGameStepsStepIdSeq(
    in GameId int,
    in StepId int
)
    returns boolean
    security definer
as
$$
begin
    return exists(select GameSteps.GameId
                  from GameSteps
                  where GameSteps.GameId = CheckGameStepsStepIdSeq.GameId
                    and GameSteps.StepId = CheckGameStepsStepIdSeq.StepId - 1);
end;
$$ language plpgsql;

create or replace function CheckGameStepsBelongsToGameProcessionTimeInterval(
    in GameId int,
    in StepTime timestamp
)
    returns boolean
    security definer
as
$$
begin
    return (select StartGameTime
            from Games
            where Games.GameId = CheckGameStepsBelongsToGameProcessionTimeInterval.GameId) <=
           CheckGameStepsBelongsToGameProcessionTimeInterval.StepTime and
           (not exists(select GameResults.GameId
                       from GameResults
                       where GameResults.GameId = CheckGameStepsBelongsToGameProcessionTimeInterval.GameId) or
            CheckGameStepsBelongsToGameProcessionTimeInterval.StepTime <= (select EndGameTime
                                                                           from GameResults
                                                                           where GameResults.GameId =
                                                                                 CheckGameStepsBelongsToGameProcessionTimeInterval.GameId));
end;
$$ language plpgsql;

create table GameSteps
(
    StepId   int       not null,
    GameId   int       not null,
    FromCell char(2)   not null,
    ToCell   char(2)   not null,
    StepTime timestamp not null,

    constraint GameSteps_PK primary key (StepId, GameId),
    constraint GameSteps_FK1 foreign key (GameId) references Games (GameId),
    constraint GameSteps_check_StepNumber_is_not_negative check ( StepId >= 0 ),
    constraint GameSteps_check_StepNumber_is_next_seq_number check ( StepId = 0 or CheckGameStepsStepIdSeq(GameId, StepId) ),
    constraint GameSteps_check_game_is_in_progress check ( CheckGameStepsBelongsToGameProcessionTimeInterval(
            GameId, StepTime) )
);

create table Tournaments
(
    TournamentId           int           not null generated always as identity,
    TournamentName         varchar(256)  not null,
    TournamentDescription  varchar(4096) not null,
    StartTournamentTime    timestamp     not null,
    EndTournamentTime      timestamp     not null,
    DivisionId             int           not null,
    InitialGameTypeTime    int           not null,
    AdditionalGameTypeTime int           not null,

    constraint Tournaments_PK primary key (TournamentId),
    constraint Tournaments_FK1 foreign key (DivisionId) references Divisions (DivisionId),
    constraint Tournaments_FK2 foreign key (InitialGameTypeTime, AdditionalGameTypeTime) references GameTypes (InitialGameTypeTime, AdditionalGameTypeTime),
    constraint Tournaments_check_End_subtract_Start_grater_a_const check ( EndTournamentTime > StartTournamentTime + interval '30 minute' ),
    constraint Tournaments_check_TournamentName_not_empty check ( length(TournamentName) > 0 )
);

create or replace function IsTournamentStart(
    in TournamentId int
)
    returns boolean
    security definer
as
$$
begin
    return current_timestamp >= (select StartTournamentTime
                                 from Tournaments
                                 where Tournaments.TournamentId = IsTournamentStart.TournamentId);
end;
$$ language plpgsql;

create table TournamentParticipants
(
    TournamentId int not null,
    UserId       int not null,
    BoardScore   int not null default 0,

    constraint TournamentParticipants_PK primary key (TournamentId, UserId),
    constraint TournamentParticipants_FK1 foreign key (TournamentId) references Tournaments (TournamentId),
    constraint TournamentParticipants_FK2 foreign key (UserId) references Users (UserId),
    constraint TournamentParticipants_BoardScore_is_not_negative check ( BoardScore >= 0 ),
    constraint TournamentParticipants_check_tournament_start_positive_score check ( BoardScore = 0 or IsTournamentStart(TournamentId) )
);

create or replace function IsGameStartsWhenTournamentProcessing(
    in TournamentId int,
    in GameId int
)
    returns boolean
    security definer
as
$$
declare
    StartGameTime timestamp := (select StartGameTime
                                from Games
                                where Games.GameId = IsGameStartsWhenTournamentProcessing.GameId);
begin
    return (select StartTournamentTime
            from Tournaments
            where Tournaments.TournamentId = IsGameStartsWhenTournamentProcessing.TournamentId) <=
           StartGameTime and
           StartGameTime <= (select EndTournamentTime
                             from Tournaments
                             where Tournaments.TournamentId = IsGameStartsWhenTournamentProcessing.TournamentId);
end;
$$ language plpgsql;

create or replace function IsGameHaveSuitableForTournamentGameType(
    in TournamentId int,
    in GameId int
)
    returns boolean
    security definer
as
$$
begin
    return exists(select Tournaments.TournamentId, Games.GameId
                  from Tournaments
                           natural join Games
                  where Games.GameId = IsGameHaveSuitableForTournamentGameType.GameId
                    and Tournaments.TournamentId = IsGameHaveSuitableForTournamentGameType.TournamentId);
end;
$$ language plpgsql;

create table TournamentGames
(
    GameId       int not null,
    TournamentId int not null,

    constraint TournamentGames_PK primary key (GameId),
    constraint TournamentGames_FK1 foreign key (TournamentId) references Tournaments (TournamentId),
    constraint TournamentGames_FK2 foreign key (GameId) references Games (GameId),
    constraint TournamentGames_check_game_starts_when_tournaments_process check ( IsGameStartsWhenTournamentProcessing(TournamentId, GameId) ),
    constraint TournamentGames_check_game_has_suitable_game_type check ( IsGameHaveSuitableForTournamentGameType(TournamentId, GameId) )
);

create table Forums
(
    ForumId int          not null generated always as identity,
    Topic   varchar(256) not null,

    constraint Forums_PK primary key (ForumId)
);

create sequence if not exists MessageUniqueId minvalue 1 no maxvalue start with 1 increment by 1 cache 100;

create table ForumMessages
(
    MessageId      int           not null,
    ForumMessageId int           not null generated always as identity,
    MessageText    varchar(2048) not null,
    SendTime       timestamp     not null,
    ForumId        int           not null,
    SenderId       int           not null,

    constraint ForumMessages_PK primary key (MessageId),
    constraint ForumMessages_K1 unique (ForumMessageId),
    constraint ForumMessages_FK1 foreign key (ForumId) references Forums (ForumId),
    constraint ForumMessages_FK2 foreign key (SenderId) references Users (UserId),
    constraint ForumMessages_check_message_not_empty check ( length(MessageText) > 0 )
);

create table ReplyForumMessages
(
    FromMessageId int not null,
    ToMessageId   int not null,

    constraint ReplyForumMessages_PK primary key (FromMessageId),
    constraint ReplyForumMessages_FK1 foreign key (FromMessageId) references ForumMessages (MessageId),
    constraint ReplyForumMessages_FK2 foreign key (ToMessageId) references ForumMessages (MessageId),
    constraint ReplyForumMessages_check_different_ids check ( FromMessageId <> ToMessageId )
);

create table DirectMessages
(
    MessageId       int           not null,
    DirectMessageId int           not null generated always as identity,
    MessageText     varchar(2048) not null,
    SendTime        timestamp     not null,
    ReceiverId      int           not null,
    SenderId        int           not null,

    constraint DirectMessages_PK primary key (MessageId),
    constraint DirectMessages_K1 unique (DirectMessageId),
    constraint DirectMessages_FK1 foreign key (ReceiverId) references Users (UserId),
    constraint DirectMessages_FK2 foreign key (SenderId) references Users (UserId),
    constraint DirectMessages_check_message_not_empty check ( length(MessageText) > 0 )
);

create table ReplyDirectMessages
(
    FromMessageId int not null,
    ToMessageId   int not null,

    constraint ReplyDirectMessages_PK primary key (FromMessageId),
    constraint ReplyDirectMessages_FK1 foreign key (FromMessageId) references DirectMessages (MessageId),
    constraint ReplyDirectMessages_FK2 foreign key (ToMessageId) references DirectMessages (MessageId),
    constraint ReplyDirectMessages_check_different_ids check ( FromMessageId <> ToMessageId )
);

create table GameComments
(
    MessageId     int           not null,
    GameCommentId int           not null generated always as identity,
    MessageText   varchar(2048) not null,
    SendTime      timestamp     not null,
    GameId        int           not null,
    SenderId      int           not null,

    constraint GameComments_PK primary key (MessageId),
    constraint GameComments_K1 unique (GameCommentId),
    constraint GameComments_FK1 foreign key (GameId) references Games (GameId),
    constraint GameComments_FK2 foreign key (SenderId) references Users (UserId),
    constraint GameComments_check_message_not_empty check ( length(MessageText) > 0 )
);

create table ReplyGameComments
(
    FromMessageId int not null,
    ToMessageId   int not null,

    constraint ReplyGameComments_PK primary key (FromMessageId),
    constraint ReplyGameComments_FK1 foreign key (FromMessageId) references GameComments (MessageId),
    constraint ReplyGameComments_FK2 foreign key (ToMessageId) references GameComments (MessageId),
    constraint ReplyGameComments_check_different_ids check ( FromMessageId <> ToMessageId )
);

-- Сразу сделаем замечание: так как в документации к используемой СУБД написано, что при объявлении primary key и unique
-- constraint'ов, автоматически создаются btree индексы с соответствующими атрибутами, то такие индексы объявлять не будем
-- дабы избежать дублирования тех же данных и ненужное использование памяти.

-- Ratings
-- |================|
-- Данный индекс будет полезен, когда мы хотим узнать рейтинг конкретного пользователя по разным типам игр.
-- Так как мы хотим фиксировать UserId и искать записи по полному соответствие, то создаем hash индекс.
-- Помогает ускорить GetUserRatings, GetUserGameTypeNameRatings.
create index Ratings_UserId_Hash on Ratings using hash (UserId);

-- Данный индекс будет полезен, когда мы хотим узнать рейтинг пользователей по конкретному типу игр, который зафиксирован.
-- Данная операция может быть выполнена, например, если мы хотим узнать таблицу лидеров.
-- Индекс сделаем типа btree, так как мы хотим искать по типу игры рейтинг, причем он должен быть отсортирован.
-- Помогает ускорить GetLeaderboard.
create index Ratings_GameType_Score_BTree on Ratings using btree (InitialGameTypeTime, AdditionalGameTypeTime, Score desc, UserId);

-- Games
-- |================|
-- Эти два индекса помогают ускорить запросы вида поиска статистики игр определенного пользователя.
-- Например, хотим узнать все игры, в которых участвовал пользователь.
-- Обычно мы хотим упорядочить значения по убыванию времени, чтобы показывать сначала более актуальную информацию.
-- Для этого делаем btree индекс, чтобы при фиксированном префиксе идентификатора пользователя искать информацию о его играх.
-- Также добавим в индекс информацию о других столбцах нашей таблицы, так как обычно в запросах поиска статистики мы хотим всю
-- информацию об игре, и дабы не ходить лишний раз в таблицу, будем хранить информацию об этих столбцах в индексе.
-- Прием, заметим, что хранимые значения - это целые числа и время, поэтому сильного прироста в памяти наблюдаться не должно.
-- Помогает ускорять  GetUserTookPartGames, GetUserCurrentlyPlayingGames, GetUserWinningGames, GetUserSpecialTypeGames, GetUserSpecialTypeNameGames.
create index Games_WhitePlayerId_StartGameTime_BTree on Games using btree (WhitePlayerId,
                                                                           StartGameTime desc,
                                                                           InitialGameTypeTime,
                                                                           AdditionalGameTypeTime,
                                                                           BlackPlayerId,
                                                                           GameId);
create index Games_BlackPlayerId_StartGameTime_BTree on Games using btree (BlackPlayerId,
                                                                           StartGameTime desc,
                                                                           InitialGameTypeTime,
                                                                           AdditionalGameTypeTime,
                                                                           WhitePlayerId,
                                                                           GameId);

-- Данный индекс помогает ускорять запросы вида поиска статистики игр определенного типа.
-- Основываясь на рассуждениях предыдущего индекса, делаем btree индекс, чтобы результат возвращался отсортированным по времени начала.
-- И также добавляем остальные колонки.
-- Помогает ускорить GetUserSpecialTypeNameGames.
create index Games_GameType_StartGameTime_BTree on Games using btree (InitialGameTypeTime,
                                                                      AdditionalGameTypeTime,
                                                                      StartGameTime desc,
                                                                      WhitePlayerId,
                                                                      BlackPlayerId,
                                                                      GameId);

-- GameSteps
-- |================|
-- Данный индекс помогает ускорить запросы вида поиска по игре все сделанные в ней ходы.
-- Данный индекс стипом btree, так как мы хотим значения с порядком на ходах, а именно по GameId получать
-- отсортированные хоты. Также помимо индексов мы хотим знать, от куда, куда и когда сходили. Для этого,
-- дабы лишний раз не ходить в таблицу, храним в индексе эти дополнительные поля. Заметим, что эти поля -
-- это либо строка из ровно двух символов, либо время. Следовательно много дополнительной памяти это не займет.
-- Помогает ускорить GetGameSteps, GetPlayerSteps.
create index GameSteps_GameId_StepId_BTree on GameSteps using btree (GameId, StepId asc, FromCell, ToCell, StepTime);

-- TournamentParticipants
-- |================|
-- Данный индекс помогает ускорить запросы вида получения турнирной таблицы, а также получения максимума из рейтингов, чтобы
-- понимать, кто выиграл в турнире.
-- Данный индекс с типом btree, так как мы хотим по турниру получать данные о рейтинге в отсортированном порядке.
-- Также индекс содержит информацию о пользователе, чтобы лишний раз не ходить в таблицу за этой информацией, а она нам
-- точно нужна, чтобы понимать, кто в турнирной таблице имеет такой рейтинг.
-- Помогает ускорить GetTournamentLeaderBoard, GetTournamentWinners.
create index TournamentParticipants_TournamentId_BoardScore_BTree on TournamentParticipants using btree (TournamentId, BoardScore desc, UserId);

-- ForumMessages
-- |================|
-- Данный индекс помогает ускорить запросы вида получение всех сообщений на конкретном форуме.
-- Данный индекс с типом btree, так как мы хотим по конкретному форуму получить все сообщения определенном порядке:
-- более новые - более важные.
-- И добавляем дополнительную информацию и оставшихся столбцах таблицы, кроме самого сообщения, в индекс,
-- чтобы не ходить за ними лишний раз в таблицу. Заметим, что это можно сделать, так как все они - это int'ы, а значит
-- не сильно увеличат размер нашей ноды. Очевидно, сам текст не добавляем, так как в противном случае размер нашей ноды
-- возрастет в разы и дерево перестанет сильно ветвится, что приведет к потере эффективности.
-- На самом деле нам все равно все MessageText сразу почти никогда не будут нужны, так как обычно мы показываем пользователю
-- последние X сообщений, а чтобы посмотреть историю, он листает переписку и подгружает новые записи.
-- Помогает ускорить GetForumMessages.
create index ForumMessages_ForumId_SendTIme on ForumMessages using btree (ForumId,
                                                                          SendTime desc,
                                                                          MessageId,
                                                                          ForumMessageId,
                                                                          SenderId);

-- DirectMessages
-- |================|
-- Данные индексы помогает ускорить запросы вида, получить по отправителю или получателю все сообщения в
-- обратном хронологическом порядке. Нужен, если мы хотим посмотреть переписку с каким-то пользователем или
-- получить краткую информацию о всех наших переписках.
-- Обоснование выбора  btree и добавление дополнительных столбцов аналогично с предыдущем индексом.
-- Помогает ускорить GetUserDirects, GetUserDirectMessagesWithCompanion.
create index DirectMessages_SenderId_SendTime on DirectMessages using btree (SenderId,
                                                                             SendTime desc,
                                                                             MessageId,
                                                                             DirectMessageId,
                                                                             ReceiverId);
create index DirectMessages_ReceiverId_SendTime on DirectMessages using btree (ReceiverId,
                                                                               SendTime desc,
                                                                               MessageId,
                                                                               DirectMessageId,
                                                                               SenderId);

-- GameComments
-- |================|
-- Данный индекс помогает ускорить запросы вида, получить все комментарии под конкретной игрой.
-- Обоснование выбора  btree и добавление дополнительных столбцов аналогично с предыдущем индексом.
-- Помогает ускорить GetGameComment.
create index GameComments_GameId_SendTIme on GameComments using btree (GameId,
                                                                       SendTime desc,
                                                                       MessageId,
                                                                       GameCommentId,
                                                                       SenderId);