clear all;

Game_Lineup = readtable('mini_Game_Lineup.csv');

% cut off period 0's 
oldHeight = height(Game_Lineup);
Game_Lineup2 = Game_Lineup(oldHeight-40+1:oldHeight,1:4);

% sort
Game_Lineup2 = sortrows(Game_Lineup2,[2 4],{'ascend','ascend'});

% duplicate, add more columns
person_id = table2array(Game_Lineup2(:,3));
Game_Lineup2 = addvars(Game_Lineup2,person_id,person_id,person_id,person_id,'Before',4);
Game_Lineup2.Properties.VariableNames([3:7]) = {'p1' 'p2' 'p3' 'p4' 'p5'};

% assign
Start5 = array2table(cell(8,8));  
for i = 1:8
    temp = Game_Lineup2( (i-1)*5+[1:5] ,3);
    Game_Lineup2( (i-1)*5+1, 3:7) =  array2table(table2array(temp)');
    Start5(i,4:8) =  array2table(table2array(temp)');
    Start5(i,1)= Game_Lineup2( (i-1)*5+1,1);
    Start5(i,2)= Game_Lineup2( (i-1)*5+1,8);
end
Start5(:,3)=[];
Start5 = addvars(Start5, table2array( Game_Lineup2(1:5:36,2)),'Before',2);

% tranpose
for i = 1: height(Start5)
    if mod(i,2)
        odd((i+1)/2,:) = Start5(i,:);
    else
        even(i/2,:) = Start5(i,:);
    end
end
even(:,[1,2]) = [];
even.Properties.VariableNames([2:6]) = {'p6' 'p7' 'p8' 'p9' 'p10'};
even.Properties.VariableNames(1) = {'team2'};
odd.Properties.VariableNames([1:8]) = {'game' 'period' 'team1' 'p1' ...
    'p2' 'p3' 'p4' 'p5' };
Start10 = [odd, even];



