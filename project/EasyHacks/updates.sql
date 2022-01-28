-- RegisterUser
insert into Users (Login, PasswordSha)
values (:Login, crypt(:Password, gen_salt('md5')));

-- UpdatePlayersRating
create or replace function UpdatePlayersRating()
    returns trigger
    security definer
as
$$
declare
    WhitePlayerIdStored          int;
    BlackPlayerIdStored          int;
    InitialGameTypeTimeStored    int;
    AdditionalGameTypeTimeStored int;
    ResultScoreStored            float;
    TournamentIdStored           int;
    WhitePlayerAdditionalRating  int;
    BlackPlayerAdditionalRating  int;

begin
    set transaction isolation level read committed read write;

    select WhitePlayerId, BlackPlayerId, InitialGameTypeTime, AdditionalGameTypeTime
    from Games
    where GameId = new.GameId
    into WhitePlayerIdStored, BlackPlayerIdStored, InitialGameTypeTimeStored, AdditionalGameTypeTimeStored;

    select TournamentId from TournamentGames where GameId = new.GameId into TournamentIdStored;

    select (case
                when EndGameType in ('WhiteWins', 'BlackSurrender') then 1.0
                when EndGameType in ('BlackWins', 'WhiteSurrender') then 0.0
                when EndGameType = 'Draw' then 0.5
        end) as ResultScore
    from cast(new as GameResults)
    into ResultScoreStored;

    select AdditionalExceptedRating
    from GetUserExceptedAdditionalRating(ResultScoreStored, WhitePlayerIdStored,
                                         BlackPlayerIdStored,
                                         new.GameId)
    into WhitePlayerAdditionalRating;

    select AdditionalExceptedRating
    from GetUserExceptedAdditionalRating(1.0 - ResultScoreStored, BlackPlayerIdStored,
                                         WhitePlayerIdStored,
                                         new.GameId)
    into BlackPlayerAdditionalRating;

    if (TournamentIdStored is not null) then
        update TournamentParticipants
        set BoardScore = greatest(0, WhitePlayerAdditionalRating) + BoardScore
        where UserId = WhitePlayerIdStored
          and TournamentId = TournamentIdStored;

        update TournamentParticipants
        set BoardScore = greatest(0, BlackPlayerAdditionalRating) + BoardScore
        where UserId = BlackPlayerIdStored
          and TournamentId = TournamentIdStored;
    else
        if (not exists(select UserId, InitialGameTypeTime, AdditionalGameTypeTime
                       from Ratings
                       where UserId = WhitePlayerIdStored
                         and InitialGameTypeTime = InitialGameTypeTimeStored
                         and AdditionalGameTypeTime = AdditionalGameTypeTimeStored)) then
            insert into ratings (UserId, InitialGameTypeTime, AdditionalGameTypeTime, Score)
            values (WhitePlayerIdStored, InitialGameTypeTimeStored, AdditionalGameTypeTimeStored, 0);
        end if;

        if (not exists(select UserId, InitialGameTypeTime, AdditionalGameTypeTime
                       from Ratings
                       where UserId = BlackPlayerIdStored
                         and InitialGameTypeTime = InitialGameTypeTimeStored
                         and AdditionalGameTypeTime = AdditionalGameTypeTimeStored)) then
            insert into ratings (UserId, InitialGameTypeTime, AdditionalGameTypeTime, Score)
            values (BlackPlayerIdStored, InitialGameTypeTimeStored, AdditionalGameTypeTimeStored, 0);
        end if;

        update Ratings
-- NOTE: Что-то полшло не так: greatest(0, WhitePlayerIdStored)
        set Score = greatest(0, WhitePlayerIdStored) + Score
        where UserId = WhitePlayerIdStored
          and InitialGameTypeTime = InitialGameTypeTimeStored
          and AdditionalGameTypeTime = AdditionalGameTypeTimeStored;

        update Ratings
        set Score = greatest(0, BlackPlayerIdStored) + Score
        where UserId = BlackPlayerIdStored
          and InitialGameTypeTime = InitialGameTypeTimeStored
          and AdditionalGameTypeTime = AdditionalGameTypeTimeStored;
    end if;

    return new;
end;
$$ language plpgsql;

-- UpdatePlayersRatingTrigger
create trigger UpdatePlayersRatingTrigger
    after insert
    on GameResults
    for each row
execute function UpdatePlayersRating();

-- CreateGameStepsSequence
create or replace function CreateGameStepsSequence()
    returns trigger
    security definer
as
$$
begin
-- NOTE: Надо было делать аналог таблиц ключей
    execute 'create temp sequence GameSteps_game_' || new.GameId ||
            '_StepId_sequence minvalue 0 no maxvalue start with 0 increment by 1';
    return new;
end;
$$ language plpgsql;

-- CreateGameStepsSequenceTrigger
create trigger CreateGameStepsSequenceTrigger
    after insert
    on Games
    for each row
execute function CreateGameStepsSequence();

-- StartGame
insert into Games(StartGameTime,
                  InitialGameTypeTime,
                  AdditionalGameTypeTime,
                  WhitePlayerId,
                  BlackPlayerId)
values (current_timestamp, :InitialGameTypeTime, :AdditionalGameTypeTime, :WhitePlayerId, :BlackPlayerId);

-- DoStep
insert into GameSteps(StepId,
                      GameId,
                      FromCell,
                      ToCell,
                      StepTime)
values (nextval('GameSteps_game_' || :GameId || '_StepId_sequence'), :GameId, :FromCell, :ToCell, current_timestamp);

-- DropGameStepsSequence
create or replace function DropGameStepsSequence()
    returns trigger
    security definer
as
$$
begin
    execute 'drop sequence if exists GameSteps_game_' || new.GameId || '_StepId_sequence';
    return new;
end;
$$ language plpgsql;

-- DropGameStepsSequenceTrigger
create trigger DropGameStepsSequenceTrigger
    after insert
    on GameResults
    for each row
execute function DropGameStepsSequence();

-- EndGame
insert into GameResults(GameId, EndGameTime, EndGameType)
values (:GameId, current_timestamp, :EndGameType);

-- CreateTournament
insert into Tournaments(TournamentName,
                        TournamentDescription,
                        StartTournamentTime,
                        EndTournamentTime,
                        DivisionId,
                        InitialGameTypeTime,
                        AdditionalGameTypeTime)
values (:TournamentName,
        :TournamentDescription,
        to_timestamp(:StartTournamentTime, :TimeFormat),
        to_timestamp(:EndTournamentTime, :TimeFormat),
        :DivisionId,
        :InitialGameTypeTime,
        :AdditionalGameTypeTime);

-- JoinTournament
insert into TournamentParticipants(TournamentId, UserId, BoardScore)
values (:TournamentId, :UserId, 0);

-- LeaveTournament
delete
from TournamentParticipants
where TournamentId = :TournamentId
  and UserId = :UserId;

-- StartTournamentGame
create or replace procedure StartTournamentGame(
    in TournamentId int,
    in WhitePlayerId int,
    in BlackPlayerId int
)
    security definer
as
$$
declare
    InitialGameTypeTimeStored    int;
    AdditionalGameTypeTimeStored int;
    GameIdStored                 int;
begin
    set transaction isolation level read committed read write;

    select InitialGameTypeTime, AdditionalGameTypeTime
    from Tournaments
    where Tournaments.TournamentId = StartTournamentGame.TournamentId
    into InitialGameTypeTimeStored, AdditionalGameTypeTimeStored;

    insert into Games(StartGameTime,
                      InitialGameTypeTime,
                      AdditionalGameTypeTime,
                      WhitePlayerId,
                      BlackPlayerId)
    values (current_timestamp, InitialGameTypeTimeStored, AdditionalGameTypeTimeStored,
            StartTournamentGame.WhitePlayerId, StartTournamentGame.BlackPlayerId)
    returning GameId into GameIdStored;

    insert into TournamentGames (TournamentId, GameId)
    values (StartTournamentGame.TournamentId, GameIdStored);
end;
$$ language plpgsql;
call StartTournamentGame(:TournamentId, :WhitePlayerId, :BlackPlayerId);

-- SendForumMessage
insert into ForumMessages(MessageId,
                          MessageText,
                          SendTime,
                          ForumId,
                          SenderId)
values (nextval('MessageUniqueId'), :MessageText, current_timestamp, :ForumId, :SenderId);

-- SendReplyForumMessage
create or replace procedure SendReplyForumMessage(
    in MessageText varchar(2048),
    in ForumId int,
    in SenderId int,
    in ReplyMessageId int
)
    security definer
as
$$
declare
    NewMessageId int;
begin
    set transaction isolation level read committed read write;

    insert into ForumMessages(MessageId,
                              MessageText,
                              SendTime,
                              ForumId,
                              SenderId)
    values (nextval('MessageUniqueId'),
            SendReplyForumMessage.MessageText,
            current_timestamp,
            SendReplyForumMessage.ForumId,
            SendReplyForumMessage.SenderId)
    returning MessageId into NewMessageId;

    insert into ReplyForumMessages (FromMessageId, ToMessageId)
    values (NewMessageId, SendReplyForumMessage.ReplyMessageId);
end;
$$ language plpgsql;
call SendReplyForumMessage(:MessageText, :ForumId, :SenderId, :ReplyMessageId);

-- SendDirectMessage
insert into DirectMessages(MessageId,
                           MessageText,
                           SendTime,
                           ReceiverId,
                           SenderId)
values (nextval('MessageUniqueId'), :MessageText, current_timestamp, :ReceiverId, :SenderId);

-- SendReplyDirectMessage
create or replace procedure SendReplyDirectMessage(
    in MessageText varchar(2048),
    in ReceiverId int,
    in SenderId int,
    in ReplyMessageId int
)
    security definer
as
$$
declare
    NewMessageId int;
begin
    set transaction isolation level read committed read write;

    insert into DirectMessages(MessageId,
                               MessageText,
                               SendTime,
                               ReceiverId,
                               SenderId)
    values (nextval('MessageUniqueId'),
            SendReplyDirectMessage.MessageText,
            current_timestamp,
            SendReplyDirectMessage.ReceiverId,
            SendReplyDirectMessage.SenderId)
    returning MessageId into NewMessageId;

    insert into ReplyDirectMessages (FromMessageId, ToMessageId)
    values (NewMessageId, SendReplyDirectMessage.ReplyMessageId);
end;
$$ language plpgsql;
call SendReplyDirectMessage(:MessageText, :RecieverId, :SenderId, :ReplyMessageId);

-- SendGameComment
insert into GameComments(MessageId,
                         MessageText,
                         SendTime,
                         GameId,
                         SenderId)
values (nextval('MessageUniqueId'), :MessageText, current_timestamp, :GameId, :SenderId);

-- SendReplyGameComment
create or replace procedure SendReplyGameComment(
    in MessageText varchar(2048),
    in GameId int,
    in SenderId int,
    in ReplyMessageId int
)
    security definer
as
$$
declare
    NewMessageId int;
begin
    set transaction isolation level read committed read write;

    insert into GameComments(MessageId,
                             MessageText,
                             SendTime,
                             GameId,
                             SenderId)
    values (nextval('MessageUniqueId'),
            SendReplyGameComment.MessageText,
            current_timestamp,
            SendReplyGameComment.GameId,
            SendReplyGameComment.SenderId)
    returning MessageId into NewMessageId;

    insert into ReplyGameComments (FromMessageId, ToMessageId)
    values (NewMessageId, SendReplyGameComment.ReplyMessageId);
end;
$$ language plpgsql;
call SendReplyGameComment(:MessageText, :GameId, :SenderId, :ReplyMessageId);