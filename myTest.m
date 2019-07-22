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
Player_Score = [player,score];



tic;
for i = 1:height(Play_by_Play)
    if Play_by_Play{i,8} > 0
        playerName1 = Play_by_Play{i,12};
        playerName2 = Play_by_Play{i,13};
        playerName3 = Play_by_Play{i,14};
        
        for j = 1:height(Player_Score)
            if strcmp(Player_Score{j,1}, playerName1) || strcmp(Player_Score{j,1}, playerName2) || strcmp(Player_Score{j,1}, playerName3)
                Player_Score{j,2} =  Player_Score{j,2} + Play_by_Play{i,8};
            end
        end                
    end
    
    if mod(i,1000) == 0
        disp(i);
        toc;
    end
end