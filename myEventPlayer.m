Play_by_Play = readtable('mini_Play_by_Play.csv');
Game_Lineup = readtable('mini_Game_Lineup.csv');
Event_Codes = readtable('Event_Codes.csv');

num_games = height(unique(Game_Lineup(:,1)));
num_teams = height(unique(Game_Lineup(:,4)));
num_players = height(unique(Game_Lineup(:,3)));

% ========== toy code: calculate point for each player =====
% player-points table
player = unique(Game_Lineup(:,3));
score = array2table(zeros(num_players,1));
% Player_Score = table(player,score);  % nor join()
% Player_Score = [player,score];


% init Event Player 
eventPlayer =  Play_by_Play(:,[1 2 5 8 11]);





