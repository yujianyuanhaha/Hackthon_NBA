clear all;
play_by_Play = readtable('mini_Play_by_Play.csv');
game_Lineup0 = readtable('mini_Game_Lineup_raw.csv');
game_Lineup =  readtable('mini_Game_Lineup.csv');

start10 = getStart10(game_Lineup);

len1 = numel(find( cell2mat( game_Lineup0{1:15,5})=='A'));
len2 = numel(find( cell2mat( game_Lineup0{16:30,5}) =='A'));


list1 =  game_Lineup0(1:len1,'Person_id');
list2 =   game_Lineup0( (15+1):(15+len1),'Person_id');
player = [list1; list2];

list1 =  game_Lineup0(1:len1,'Team_id');
list2 =   game_Lineup0( (15+1):(15+len1),'Team_id');
team = [list1; list2];
team2 = table2cell(unique(team))';

len = numel(player);
game =  game_Lineup0{1,1};
game = cell2table ( repelem(game,len,1) );
Result.Properties.VariableNames([1]) = {'Game_ID'};


Result = [game, team, player];
Result = addvars(Result,zeros(len,1),zeros(len,1),zeros(len,1),...
    'After',3);
Result.Properties.VariableNames([4:6]) = {'Pos' 'OffRtg' 'DefRtg'};

tic;

for k = 1:height(play_by_Play)    

     curPeriod = play_by_Play{k,'Period'};
     
    % 2. update points
    if play_by_Play{k,'Event_Msg_Type'} == 1 ||...
           play_by_Play{k,'Event_Msg_Type'} == 3
        winTeam = play_by_Play{k,'Team_id'}; 
        
%         if k ==26
%             disp("here");
%         end
              
        if strcmp(winTeam{1}, team2{1})            
            curWinPlayers = start10{curPeriod,4:8} ;
            curLosPlayers = start10{curPeriod,10:14};
        else            
            curWinPlayers = start10{curPeriod,10:14};
            curLosPlayers = start10{curPeriod,4:8};     
        end
        
        for j = 1:5
            v = strcmp(curWinPlayers(j), Result.Person_id );
            Result{v,'OffRtg'} = Result{v,'OffRtg'} + play_by_Play{k,'Option1'};
            Result{v,'Pos'} = Result{v,'Pos'} + 1;
             if k > 2
                if play_by_Play{k-1,'Event_Msg_Type'} == 3 &&  play_by_Play{k,'Event_Msg_Type'} == 3
                    Result{v,'Pos'} = Result{v,'Pos'} - 1;
                end
            end

            u = strcmp(curLosPlayers(j), Result.Person_id );
            Result{u,'DefRtg'} = Result{u,'DefRtg'} + play_by_Play{k,'Option1'};
            Result{u,'Pos'} = Result{u,'Pos'} + 1;
            if k > 2
                if play_by_Play{k-1,'Event_Msg_Type'} == 3 &&  play_by_Play{k,'Event_Msg_Type'} == 3
                    Result{u,'Pos'} = Result{u,'Pos'} - 1;
                end
            end
            
        end                
    end
    
          
     if play_by_Play{k,'Event_Msg_Type'} == 8 
         
%          if k == 346
%              disp('----346 ------');
%          end
         
         outPlayer = play_by_Play{k,'Person1'};
         inPlayer = play_by_Play{k,'Person2'};         
          if  strcmp( outPlayer ,'c5dd5b2e3b975f0849d9b74e74125cb9')              
                
                k
                curPeriod
                disp('here out');
          end          
          if  strcmp( inPlayer ,'c5dd5b2e3b975f0849d9b74e74125cb9') 
               
                k
                curPeriod
                 disp('here in');
          end         
         if strcmp( play_by_Play{k,'Team_id'}, team2{1}) 
             x = start10{curPeriod,4:8};
             v = strcmp(x, outPlayer );
             ind = find(v);
             start10{curPeriod,3+ind} = inPlayer;
         else
              x = start10{curPeriod,10:14};
              v = strcmp(x, outPlayer );
             ind = find(v);
             start10{curPeriod,9+ind} = inPlayer;
         end
         
%          if numel(unique(start10{curPeriod,[4:8,10:14]})) ~= 10
%              disp('error')
%          end
         
         
     end
     
     
     % miss final shot, turn over, 24s --> only counts possion

    
     if  play_by_Play{k,'Event_Msg_Type'} == 5 ||...
             play_by_Play{k,'Event_Msg_Type'} == 13 
         for j = [4:8,10:14]
             u = strcmp(start10{curPeriod,j}, Result.Person_id );
             Result{u,'Pos'} = Result{u,'Pos'} + 1;
         end
     end
     
     
     
     
     
     
     
     
     
     
     
          
end

toc;

R = Result;



% ====================================

R{:,'OffRtg'} = round( ( R{:,'OffRtg'}'*100 ./ R{:,'Pos'}' )' *100)/100;
R{:,'DefRtg'} =  round( (R{:,'DefRtg'}'*100 ./ R{:,'Pos'}' )' *100)/100;

R.Properties.VariableNames([1]) = {'Game_ID'};
R(:,[2,4]) = [];
writetable(R,'result.csv');



    


