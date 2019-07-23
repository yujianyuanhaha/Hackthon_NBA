Game_Lineup = readtable('Game_Lineup_Sort.csv');
Game_Lineup0 = readtable('Game_Lineup_raw.csv');
Play_by_Play = readtable('Play_by_Play.csv');


% GOAL, extract tiny table, deal with 5 period
% Start 10, each period each game
% [game id, period, team 1, play1on, ...,player5on, play1off, player5off...
%  team 2, play6on, ...,player10on, play6off, player10off]

% form is trim-switch-ranked, hand on Goolge SpreadSheet
% 1. sort by 'period', delete all zeros
% 2. delete 'state'
% 3. move 'Team id' to 2nd
% 4. duplicate 'personal id' by 4, and rename head
% 5. sort by 'game id','period','team id'  (notice could be 5 period)
% ---> get 'Game_lineup_trim' file

i = 0;
tic;

R = [];

while i < height(Game_Lineup)
    
    % ============== split large file into smaller file (per game) ===========
    if i+50+30 < height(Game_Lineup)+1
        if table2array( Game_Lineup(i+50+30,2) ) == 5
            subTab = Game_Lineup([(i+1):(i+80)],:);
            subTab0 = Game_Lineup0([(i+1):(i+80)],:);
            i = i +80;
            disp('period 5');
        else
            subTab = Game_Lineup([(i+1):(i+70)],:);
            subTab0 = Game_Lineup0([(i+1):(i+70)],:);
            i = i + 70;
        end
    else
        subTab = Game_Lineup([i+1:i+70],:);
        subTab0 = Game_Lineup0([i+1:i+70],:);
        i = i + 70;
    end
    
    gameID = subTab{1,1};
    
    v = strcmp(Play_by_Play{:,'Game_id'}, gameID);
    subPlay = Play_by_Play(v,:);
    
    
    
    % ======  INPUT:  subPlay, subTab, subTab0 ========
    % ====== OUTPUT:  Result ==========================
    
    % ====== init Score table: Result =======================
    Start10 = getStart10(subTab);
    game_Lineup0 = subTab0;
    play_by_Play = subPlay;
    start10 = Start10;
    
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
    

    
    
    % ============ iteration over  play_by_Play ===========
    for k = 1:height(play_by_Play)
        
        curPeriod = play_by_Play{k,'Period'};
        
        % ---- Event_Msg_Type 2: update points ---------
        if play_by_Play{k,'Event_Msg_Type'} == 1 ||...
                play_by_Play{k,'Event_Msg_Type'} == 3
            winTeam = play_by_Play{k,'Team_id'};
            
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
                % ---- recorrect Posseession count for free throw ---------
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
        
         % ---- update current player lists ---------
        if play_by_Play{k,'Event_Msg_Type'} == 8
            
            %          if k == 346
            %              disp('----346 ------');
            %          end
            
            outPlayer = play_by_Play{k,'Person1'};
            inPlayer = play_by_Play{k,'Person2'};
            %           if  strcmp( outPlayer ,'c5dd5b2e3b975f0849d9b74e74125cb9')
            %                 k
            %                 curPeriod
            %                 disp('here out');
            %           end
            %           if  strcmp( inPlayer ,'c5dd5b2e3b975f0849d9b74e74125cb9')
            %                 k
            %                 curPeriod
            %                  disp('here in');
            %           end
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
            
            if numel(unique(start10{curPeriod,[4:8,10:14]})) ~= 10
                disp('error');
                disp(play_by_Play{k,'Game_id'});
            end
            
        end               
        % ---------- turn over, 24s: only counts possion -----------
        if  play_by_Play{k,'Event_Msg_Type'} == 5 ||...
                play_by_Play{k,'Event_Msg_Type'} == 13
            for j = [4:8,10:14]
                u = strcmp(start10{curPeriod,j}, Result.Person_id );
                Result{u,'Pos'} = Result{u,'Pos'} + 1;
            end
        end

    end
    
    toc;    
    R = [R; Result];
 
end

% ========================== trim and save results ==========================
R{:,'OffRtg'} = round( ( R{:,'OffRtg'}'*100 ./ R{:,'Pos'}' )' *100)/100;
R{:,'DefRtg'} =  round( (R{:,'DefRtg'}'*100 ./ R{:,'Pos'}' )' *100)/100;

R.Properties.VariableNames([1]) = {'Game_ID'};
R(:,[2,4]) = [];
writetable(R,'OverseaGeek_Q1_BBALL.csv');
