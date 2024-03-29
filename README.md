[NBA Hackthon 2019](https://hackathon.nba.com/) Admission Question 1  
Jet Yu, jianyuan@vt.edu  
July 2019.  

# Basketball Question
Use the [attached data](https://nba.box.com/s/r65z3wpihm1z2n34bgz04lcvvy1fc2ox) and instructions to calculate offensive rating and defensive rating for each player in each game from the 2018 Playoffs. Offensive Rating is defined as the team points scored per 100 possessions while the player is on the court. Defensive Rating is defined as the number of points per 100 possessions that the team allows while that individual player is on the court. A possession is ended by (1) made field goal attempts, (2) made final free throw attempt, (3) missed final free throw attempt that results in a defensive rebound, (4) missed field goal attempt that results in a defensive rebound, (5) turnover, or (6) end of time period. Note: When a player is substituted before or during a set of free throws but was on the court at the time of the foul that caused the free throw, he is considered to be on the court for the free throws for the purposes of offensive and defensive rating. A player substituted in before a free throw but after a foul is not considered to be on the court until after the conclusion of the free throws. Additionally, when there is a technical foul, the players marked on the court at the time of the technical foul are credited with any points resulting from the FTs. This is similar to a normal foul but can be a bit confusing as technical fouls often happen in the midst of other foul events/FTs/substitutions. Please submit a .csv file titled “Your_Team_Name_Q1_BBALL.csv” substituting in the name of your team for "Your_Team_Name". Please save as a .csv. The final product should have 4 columns. Column 1: Game_ID, Column 2: Player_ID, Column 3: OffRtg, Column 4: DefRtg. Please note that each question is permitted a maximum of two file attachments. Please submit your answer in a .csv file and save your code, spreadsheets, and all other work in a zip file.  


# How to run
execute `main.m` in matlab.   
execute `toyMain.m` in matlab for a game.   

## Input
* `Game_Lineup_Sort.csv`
* `Game_Lineup_raw.csv`
* `Play_by_Play.csv`
## Output
* `OverseaGeek_Q1_BBALL.csv`



# files
* [Play by Play](https://docs.google.com/spreadsheets/d/1pT7-stDZEQuWTjA_ViC38s3YMNm5BYuBJWMS9_ag3pw/edit#gid=1802180556)  
* [Time Lineup](https://docs.google.com/spreadsheets/d/1UQzN4eJ678RYlLn595Y3OJA31MiSyPFDcY_RwrlWaJA/edit#gid=1766905254)  
* [Event](https://docs.google.com/spreadsheets/d/12bOmqZ_bJQ-H11FrWz8Jo37RvWYtPpthjS509Vs64aE/edit#gid=1218907715)
* [mini Play by Play](https://docs.google.com/spreadsheets/d/1FmZC1w4kUfvSdmNS3R1mbCmZYtCfWzY3EOhizBQ3V8o/edit#gid=0)
* [mini Time Lineup](https://docs.google.com/spreadsheets/d/1jIr5abhdy7DWXiOrOtRb1tWOqadcqLp_M2oBf7ilvGU/edit#gid=0)