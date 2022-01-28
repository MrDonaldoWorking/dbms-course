-- GetUserByLoginAndPasswordSha
select UserId
from Users
where Login = :Login
  and PasswordSha = crypt(:Password, PasswordSha);

-- GetUserByLogin
select UserId
from Users
where Login = :Login;

-- GetUserRatings
select GameTypeName, avg(Score)
from Ratings
         natural join GameTypes
where UserId = :UserId
group by GameTypeName;

-- GetUserGameTypeNameRatings
select InitialGameTypeTime, AdditionalGameTypeTime, Score
from Ratings
         natural join GameTypes
where UserId = :UserId
  and GameTypeName = :GameTypeName;

-- GetLeaderboard
select UserId, Login, avg(Score) as Score
from Ratings
         natural join GameTypes
         natural join Users
where GameTypeName = :GameTypeName
group by UserId, Login
order by Score desc;

-- GetUserTookPartGames
select GameId,
       InitialGameTypeTime,
       AdditionalGameTypeTime,
       WhitePlayerId,
       BlackPlayerId,
       StartGameTime,
       EndGameTime,
       EndGameType
from Games
         left join GameResults using (GameId)
where :UserId = WhitePlayerId
   or :UserId = BlackPlayerId
order by StartGameTime desc;

-- GetUserCurrentlyPlayingGames
select GameId
from Games
         left join GameResults using (GameId)
where EndGameType is null
  and (:UserId = WhitePlayerId or :UserId = BlackPlayerId)
order by StartGameTime desc;

-- GetUserExceptedAdditionalRatingScore
-- NOTE: Надо было view
create or replace function GetUserExceptedAdditionalRatingScore(
    in UserId int,
    in OpponentId int,
    in GameId int
)
    returns table
            (
                ExceptedAdditionalRating float
            )
    security definer
as
$$
begin
    return query select 1.0 / (1.0 + power(10.0, (coalesce(cast(UserRatings.Score as float), 0.0) -
                                                  coalesce(cast(OpponentRatings.Score as float), 0.0)) /
                                                 400.0)) as ExceptedAdditionalRating
                 from (select InitialGameTypeTime,
                              AdditionalGameTypeTime,
                              GetUserExceptedAdditionalRatingScore.UserId     as UserId,
                              GetUserExceptedAdditionalRatingScore.OpponentId as OpponentId
                       from GameTypes) PlayersAndGameTypes
                          left join Ratings UserRatings on UserRatings.UserId = PlayersAndGameTypes.UserId and
                                                           UserRatings.InitialGameTypeTime =
                                                           PlayersAndGameTypes.InitialGameTypeTime and
                                                           UserRatings.AdditionalGameTypeTime =
                                                           PlayersAndGameTypes.AdditionalGameTypeTime
                          left join Ratings OpponentRatings
                                    on OpponentRatings.UserId = PlayersAndGameTypes.OpponentId and
                                       OpponentRatings.InitialGameTypeTime =
                                       PlayersAndGameTypes.InitialGameTypeTime and
                                       OpponentRatings.AdditionalGameTypeTime =
                                       PlayersAndGameTypes.AdditionalGameTypeTime
                          inner join Games on Games.InitialGameTypeTime = PlayersAndGameTypes.InitialGameTypeTime and
                                              Games.AdditionalGameTypeTime = PlayersAndGameTypes.AdditionalGameTypeTime
                 where Games.GameId = GetUserExceptedAdditionalRatingScore.GameId
                   and ((WhitePlayerId = GetUserExceptedAdditionalRatingScore.UserId and
                         BlackPlayerId = GetUserExceptedAdditionalRatingScore.OpponentId) or
                        (WhitePlayerId = GetUserExceptedAdditionalRatingScore.OpponentId and
                         BlackPlayerId = GetUserExceptedAdditionalRatingScore.UserId));
end;
$$ language plpgsql;

-- GetUserExceptedAdditionalRating
create or replace function GetUserExceptedAdditionalRating(
    in ResultScore float,
    in UserId int,
    in OpponentId int,
    in GameId int
)
    returns table
            (
                CurrentRating            int,
                AdditionalExceptedRating int
            )
    security definer
as
$$
begin
    return query select coalesce(Score, 0)                                                               as CurrentRating,
                        cast(round((case
                                        when coalesce(Score, 0) >= 2400 then 10
                                        when coalesce(Score, 0) >= 2300 then 20
                                        else 40
                                        end *
                                    (GetUserExceptedAdditionalRating.ResultScore -
                                     (select GetUserExceptedAdditionalRatingScore(
                                                     GetUserExceptedAdditionalRating.UserId,
                                                     GetUserExceptedAdditionalRating.OpponentId,
                                                     GetUserExceptedAdditionalRating.GameId))))) as int) as AdditionalExceptedRating
                 from (select InitialGameTypeTime,
                              AdditionalGameTypeTime,
                              GetUserExceptedAdditionalRating.UserId as UserId
                       from GameTypes) GameTypesAndUserId
                          left join Ratings using (InitialGameTypeTime, AdditionalGameTypeTime, UserId)
                          natural join Games
                 where Games.GameId = GetUserExceptedAdditionalRating.GameId
                   and (WhitePlayerId = GetUserExceptedAdditionalRating.UserId or
                        BlackPlayerId = GetUserExceptedAdditionalRating.UserId);
end;
$$ language plpgsql;

-- GetUserExpectedRating
select CurrentRating, WinAdditionalExceptedRating, DrawAdditionalExceptedRating, LoseAdditionalExceptedRating
from (select CurrentRating, AdditionalExceptedRating as WinAdditionalExceptedRating
      from GetUserExceptedAdditionalRating(1.0, :UserId, :OpponentId, :GameId)) Win
         natural join (select CurrentRating, AdditionalExceptedRating as DrawAdditionalExceptedRating
                       from GetUserExceptedAdditionalRating(0.5, :UserId, :OpponentId, :GameId)) Draw
         natural join (select CurrentRating, AdditionalExceptedRating as LoseAdditionalExceptedRating
                       from GetUserExceptedAdditionalRating(0.0, :UserId, :OpponentId, :GameId)) Lose;

-- GetUserWinningGames
select GameId,
       InitialGameTypeTime,
       AdditionalGameTypeTime,
       WhitePlayerId,
       BlackPlayerId,
       StartGameTime,
       EndGameTime,
       EndGameType
from GameResults
         natural join Games
where ((EndGameType = 'WhiteWins' or EndGameType = 'BlackSurrender') and WhitePlayerId = :UserId)
   or ((EndGameType = 'BlackWins' or EndGameType = 'WhiteSurrender') and BlackPlayerId = :UserId)
order by StartGameTime desc;

-- GetUserSpecialTypeGames
select GameId,
       InitialGameTypeTime,
       AdditionalGameTypeTime,
       WhitePlayerId,
       BlackPlayerId,
       StartGameTime,
       EndGameTime,
       EndGameType
from Games
         left join GameResults using (GameId)
where (WhitePlayerId = :UserId or BlackPlayerId = :UserId)
  and InitialGameTypeTime = :InitialGameTypeTime
  and AdditionalGameTypeTime = :AdditionalGameTypeTime
order by StartGameTime desc
;

-- GetUserSpecialTypeNameGames
select GameId,
       InitialGameTypeTime,
       AdditionalGameTypeTime,
       WhitePlayerId,
       BlackPlayerId,
       StartGameTime,
       EndGameTime,
       EndGameType
from GameTypes
         natural join Games
         left join GameResults using (GameId)
where (WhitePlayerId = :UserId or BlackPlayerId = :UserId)
  and GameTypeName = :GameTypeName
order by StartGameTime desc;

-- GetGameSteps
select FromCell, ToCell, StepTime
from GameSteps
where GameId = :GameId
order by StepId asc;

-- GetPlayerSteps
select FromCell, tocell
from GameSteps
         natural join Games
where GameId = :GameId
  and ((WhitePlayerId = :UserId and StepId % 2 = 0) or (BlackPlayerId = :UserId and StepId % 2 = 1));

-- GetTournamentsInfo
select TournamentId,
       TournamentName,
       TournamentDescription,
       StartTournamentTime,
       EndTournamentTime,
       DivisionId,
       DivisionName,
       InitialGameTypeTime,
       AdditionalGameTypeTime
from Tournaments
         natural join Divisions
order by StartTournamentTime asc;

-- GetPossibleToJoinTournaments
select TournamentId,
       TournamentName,
       TournamentDescription,
       StartTournamentTime,
       EndTournamentTime,
       DivisionId,
       DivisionName,
       InitialGameTypeTime,
       AdditionalGameTypeTime
from Tournaments
         natural join Ratings
         natural join Divisions
where UserId = :UserId
  and Score >= DivisionScoreBound
  and EndTournamentTime > current_timestamp
  and :UserId not in
      (select UserId from TournamentParticipants where TournamentParticipants.TournamentId = Tournaments.TournamentId)
order by StartTournamentTime asc;

-- GetPlayingTournaments
select TournamentId, TournamentName
from Tournaments
         natural join TournamentParticipants
where UserId = :UserId
  and current_timestamp between StartTournamentTime and EndTournamentTime
order by StartTournamentTime asc;

-- GetTournamentLeaderBoard
select Login, BoardScore
from Users
         natural join TournamentParticipants
         natural join Tournaments
where TournamentId = :TournamentId
order by BoardScore desc;

-- GetTournamentWinners
select UserId
from (select max(BoardScore) as MaxBoardScore
      from Tournaments
               natural join TournamentParticipants
      where TournamentId = :TournamentId
        and EndTournamentTime < current_timestamp) MaxScore
         cross join
     (select UserId, BoardScore
      from TournamentParticipants
               natural join Tournaments
      where TournamentId = :TournamentId) UsersBoardScore
where MaxBoardScore = BoardScore;

-- GetForumMessages
select MessageId, ForumMessageId, MessageText, SenderId, Login as SenderLogin, SendTime, ToMessageId as ReplyMessageId
from (ForumMessages
    inner join Users on ForumMessages.SenderId = Users.UserId) MessageInfo
         left join ReplyForumMessages on MessageInfo.MessageId = ReplyForumMessages.FromMessageId
where ForumId = :ForumId
order by SendTime desc;

-- GetUserDirects
select CompanionId, SendTime
from (select distinct CompanionId, max(MaxSendTime) as SendTime
      from (select SenderId as CompanionId, max(SendTime) as MaxSendTime
            from DirectMessages
            where ReceiverId = :UserId
            group by SenderId
            union
            select ReceiverId as CompanionId, max(SendTime) as MaxSendTime
            from DirectMessages
            where SenderId = :UserId
            group by ReceiverId) Companions
      group by CompanionId) UniqueCompanions
order by SendTime desc;

-- GetUserDirectMessagesWithCompanion
select MessageId, DirectMessageId, MessageText, SenderId, ReceiverId, SendTime, ToMessageId as ReplyMessageId
from DirectMessages
         left join ReplyDirectMessages on DirectMessages.MessageId = ReplyDirectMessages.FromMessageId
where SenderId = :UserId and ReceiverId = :CompanionId
   or SenderId = :CompanionId and ReceiverId = :UserId
order by SendTime desc;

-- GetGameComment
select MessageId, GameCommentId, MessageText, SenderId, Login as SenderLogin, SendTime, ToMessageId as ReplyMessageId
from (GameComments inner join Users on GameComments.SenderId = Users.UserId) JoinedComments
         left join ReplyGameComments on JoinedComments.MessageId = ReplyGameComments.FromMessageId
where GameId = :GameId
order by SendTime desc;

-- Messages
create or replace view Messages as
select MessageId, MessageText, SenderId, SendTime, ToMessageId as ReplyMessageId
from ForumMessages
         left join ReplyForumMessages on ForumMessages.MessageId = ReplyForumMessages.FromMessageId
union
select MessageId, MessageText, SenderId, SendTime, ToMessageId as ReplyMessageId
from DirectMessages
         left join ReplyDirectMessages on DirectMessages.MessageId = ReplyDirectMessages.FromMessageId
union
select MessageId, MessageText, SenderId, SendTime, ToMessageId as ReplyMessageId
from GameComments
         left join ReplyGameComments on GameComments.MessageId = ReplyGameComments.FromMessageId;
