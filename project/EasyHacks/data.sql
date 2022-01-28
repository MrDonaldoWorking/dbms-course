insert into Users (Login, PasswordSha)
values ('user1', crypt('password1', gen_salt('md5'))),
       ('user2', crypt('password2', gen_salt('md5'))),
       ('user3', crypt('password3', gen_salt('md5'))),
       ('user4', crypt('password4', gen_salt('md5'))),
       ('user5', crypt('password5', gen_salt('md5'))),
       ('user6', crypt('password6', gen_salt('md5'))),
       ('user7', crypt('password7', gen_salt('md5')));

insert into GameTypes (InitialGameTypeTime, AdditionalGameTypeTime, GameTypeName)
values (1, 0, 'Bullet'),
       (2, 1, 'Bullet'),
       (3, 0, 'Blitz'),
       (3, 2, 'Blitz'),
       (5, 0, 'Blitz'),
       (5, 3, 'Blitz'),
       (10, 0, 'Rapid'),
       (10, 5, 'Rapid'),
       (15, 10, 'Rapid'),
       (30, 0, 'Classic'),
       (30, 20, 'Classic');

insert into Ratings (UserId, InitialGameTypeTime, AdditionalGameTypeTime, Score)
values (1, 1, 0, 1000),

       (2, 1, 0, 0),
       (2, 5, 0, 1),
       (2, 30, 0, 1002),
       (2, 30, 20, 99),

       (4, 30, 20, 99),
       (4, 30, 0, 499),
       (4, 1, 0, 499),
       (4, 3, 2, 0),

       (5, 3, 2, 0),

       (6, 1, 0, 505),
       (6, 2, 1, 505),
       (6, 3, 0, 505),
       (6, 3, 2, 505),
       (6, 5, 0, 505),
       (6, 5, 3, 505),
       (6, 10, 0, 505),
       (6, 10, 5, 505),
       (6, 15, 10, 505),
       (6, 30, 0, 505),
       (6, 30, 20, 505),

       (7, 1, 0, 0),
       (7, 2, 1, 0),
       (7, 3, 0, 0),
       (7, 3, 2, 0),
       (7, 5, 0, 0),
       (7, 5, 3, 0),
       (7, 10, 0, 0),
       (7, 10, 5, 0),
       (7, 15, 10, 0),
       (7, 30, 0, 0),
       (7, 30, 20, 0);

insert into Divisions (DivisionName, DivisionScoreBound)
values ('beginner', 100),
       ('medium', 500),
       ('advanced', 1000);

insert into Games (StartGameTime,
                   InitialGameTypeTime,
                   AdditionalGameTypeTime,
                   WhitePlayerId,
                   BlackPlayerId)
values (current_timestamp, 1, 0, 1, 2),
       (current_timestamp - interval '10 minute', 30, 20, 2, 4),
       (current_timestamp - interval '10 minute', 30, 0, 2, 4),
       (current_timestamp - interval '60 minute', 30, 0, 2, 3),
       (current_timestamp - interval '1 minute', 3, 2, 5, 4),
       (current_timestamp - interval '1 day', 5, 0, 6, 7),
       (current_timestamp - interval '1 day', 5, 0, 7, 6),
       (current_timestamp - interval '30 minute', 30, 0, 6, 4),
       (current_timestamp - interval '20 minute', 30, 0, 4, 6),
       (current_timestamp - interval '10 minute', 30, 0, 6, 4),
       (current_timestamp - interval '5 minute', 30, 0, 6, 4),
       (current_timestamp - interval '3 minute', 30, 0, 6, 4),
       (current_timestamp - interval '2 minute', 30, 0, 6, 4),
       (current_timestamp - interval '40 minute', 30, 0, 2, 4),
       (current_timestamp - interval '7 day', 1, 0, 1, 6);

insert into GameResults (GameId, EndGameTime, EndGameType)
values (3, current_timestamp - interval '3 minute', 'WhiteWins'),
       (4, current_timestamp - interval '40 minute', 'WhiteSurrender'),
       (6, current_timestamp - interval '1 day', 'WhiteSurrender'),
       (7, current_timestamp - interval '1 day', 'BlackSurrender'),
       (8, current_timestamp - interval '21 minute', 'WhiteWins'),
       (9, current_timestamp - interval '11 minute', 'BlackWins'),
       (10, current_timestamp - interval '9 minute', 'WhiteSurrender'),
       (11, current_timestamp - interval '4 minute', 'BlackSurrender'),
       (12, current_timestamp - interval '3 minute', 'Draw'),
       (14, current_timestamp - interval '30 minute', 'Draw'),
       (15, current_timestamp - interval '7 day' + interval '30 second', 'Draw');

insert into GameSteps (GameId, StepId, FromCell, ToCell, StepTime)
values (2, 0, 'e2', 'e4', current_timestamp),

       (3, 0, 'e2', 'e4', current_timestamp - interval '9 minute'),
       (3, 1, 'e7', 'e5', current_timestamp - interval '8 minute'),
       (3, 2, 'f1', 'c4', current_timestamp - interval '8 minute'),
       (3, 3, 'f8', 'c5', current_timestamp - interval '8 minute'),
       (3, 4, 'd1', 'h5', current_timestamp - interval '8 minute'),
       (3, 5, 'g8', 'f6', current_timestamp - interval '7 minute'),
       (3, 6, 'h5', 'f7', current_timestamp - interval '6 minute'),

       (4, 0, 'e2', 'e4', current_timestamp - interval '41 minute'),

       (8, 0, 'e2', 'e4', current_timestamp - interval '30 minute'),
       (8, 1, 'e7', 'e5', current_timestamp - interval '30 minute'),
       (8, 2, 'f1', 'c4', current_timestamp - interval '30 minute'),
       (8, 3, 'f8', 'c5', current_timestamp - interval '30 minute'),
       (8, 4, 'd1', 'h5', current_timestamp - interval '30 minute'),
       (8, 5, 'g8', 'f6', current_timestamp - interval '30 minute'),
       (8, 6, 'h5', 'f7', current_timestamp - interval '22 minute'),

       (9, 0, 'b2', 'b3', current_timestamp - interval '12 minute'),
       (9, 1, 'b7', 'b6', current_timestamp - interval '12 minute'),

       (11, 0, 'e2', 'e4', current_timestamp - interval '5 minute'),

       (14, 0, 'e2', 'e4', current_timestamp - interval '35 minute');

insert into Tournaments (TournamentName,
                         TournamentDescription,
                         StartTournamentTime,
                         EndTournamentTime,
                         DivisionId,
                         InitialGameTypeTime,
                         AdditionalGameTypeTime)
values ('tournament1', '', current_timestamp + interval '1 day', current_timestamp + interval '2 day', 1, 30, 0),
       ('tournament2', 'description', current_timestamp - interval '5 day', current_timestamp + interval '5 day', 2,
        30, 0),
       ('tournament3', 'desc', current_timestamp - interval '10 day', current_timestamp - interval '5 day', 1, 1, 0),
       ('tournament4', '', current_timestamp - interval '40 minute', current_timestamp + interval '1 day', 1, 30, 0);

insert into TournamentParticipants (TournamentId, UserId, BoardScore)
values (1, 2, 0),
       (1, 4, 0),
       (1, 6, 0),

       (2, 2, 0),

       (3, 1, 50),
       (3, 6, 50),

       (4, 1, 50),
       (4, 4, 25),
       (4, 6, 200);

insert into TournamentGames (TournamentId, GameId)
values (3, 15),

       (4, 8),
       (4, 9),
       (4, 10),
       (4, 11),
       (4, 12),
       (4, 13),
       (4, 14);

insert into Forums
    (Topic)
values ('topic1'),
       ('topic2'),
       ('topic3');

insert into ForumMessages (MessageId,
                           MessageText,
                           SendTime,
                           ForumId,
                           SenderId)
values (nextval('MessageUniqueId'), 'text1', current_timestamp, 1, 1),
       (nextval('MessageUniqueId'), 'text2', current_timestamp - interval '1 day', 2, 1),
       (nextval('MessageUniqueId'), 'text3', current_timestamp - interval '30 minute', 2, 2),
       (nextval('MessageUniqueId'), 'text4', current_timestamp - interval '20 minute', 2, 1),
       (nextval('MessageUniqueId'), 'text5', current_timestamp - interval '10 minute', 2, 3);

insert into ReplyForumMessages (FromMessageId, ToMessageId)
values (3, 1),
       (4, 3),
       (5, 2);

insert into DirectMessages (MessageId,
                            MessageText,
                            SendTime,
                            ReceiverId,
                            SenderId)
values (nextval('MessageUniqueId'), 'text1', current_timestamp, 2, 1),
       (nextval('MessageUniqueId'), 'text2', current_timestamp - interval '1 day', 2, 1),
       (nextval('MessageUniqueId'), 'text3', current_timestamp - interval '30 minute', 1, 2),
       (nextval('MessageUniqueId'), 'text4', current_timestamp - interval '20 minute', 2, 1),
       (nextval('MessageUniqueId'), 'text5', current_timestamp - interval '10 minute', 2, 1),
       (nextval('MessageUniqueId'), 'text6', current_timestamp - interval '10 minute', 2, 3);

insert into ReplyDirectMessages (FromMessageId, ToMessageId)
values (9, 8),
       (10, 9);

insert into GameComments (MessageId,
                          MessageText,
                          SendTime,
                          GameId,
                          SenderId)
values (nextval('MessageUniqueId'), 'text1', current_timestamp - interval '2 minute', 6, 1),
       (nextval('MessageUniqueId'), 'text2', current_timestamp - interval '1 minute', 6, 6);

insert into ReplyGameComments (FromMessageId, ToMessageId)
values (13, 12);


