function Start10 = getStart10(Game_Lineup)
% 4 X 14 or 5 X 15 

% filename = 'Game_Lineup_Sort.csv';

% Game_Lineup = readtable(filename);
numPeriod = (height(Game_Lineup)-30)/10;

Start5 = array2table(cell(numPeriod*2,8));
for i = 1:numPeriod*2
%     temp = Game_Lineup( 30+(i-1)*5+[1:5] ,4);
%     Game_Lineup( 30+(i-1)*5+1, 4:8) =  array2table(table2array(temp)');
%     Start5(i,4:8) =  array2table(table2array(temp)');
%     Start5(i,1)= Game_Lineup(30+ (i-1)*5+1,1);
%     Start5(i,3)= Game_Lineup( 30+(i-1)*5+1,3);

    temp = Game_Lineup{ 30+(i-1)*5+[1:5] ,4};
    Game_Lineup{ 30+(i-1)*5+1, 4:8} = temp';
    Start5{i,4:8} =  temp';
    Start5{i,1}= Game_Lineup{30+ (i-1)*5+1,1};
    Start5{i,3}= Game_Lineup{ 30+(i-1)*5+1,3};
end
Start5(:,2)=[];
temp =repmat([1:numPeriod],2,1);
Start5 = addvars(Start5,temp(:),'Before',2);

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


end
