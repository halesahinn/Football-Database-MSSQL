
 --soru 1
update player set age = DATEDIFF(DAY,birthDate,GETDATE())/365;

select * from player
--soru 2
select pt.playerID, p.firstName, ' ', p.lastName
from player_team pt,team t,player p 
where pt.playerID=p.playerID and pt.teamID=t.teamID and t.teamID  IN (select t.teamID from team t where name='Beşiktaş')
and p.firstName NOT LIKE '%nec%'
and p.age < (select AVG(age) from player)



select * from team
select * from goals
select * from player_team



--soru 3
with updatedCityTable as (
  select  t.teamId, t.city,
  t.city + ' #p' + CONVERT(varchar(10), count(pt.playerId)) + ' g' + CONVERT(varchar(10), t2.totalgoals) updatedcity
from  team t, player_team pt, (
      select  count(*) totalgoals,
              pt.teamID 
      from    goals g , player_team pt where isOwnGoal=0 and g.playerId = pt.playerId 
      group by pt.teamID
    ) t2 where t.teamID = t2.teamID and pt.teamID = t.teamID 
group By t.teamId,t.city,t2.totalgoals
)
update t
set t.city = c.updatedcity
from team t, updatedCityTable c where t.teamID = c.teamID and t.city = c.city



select firstName, lastName from player where playerID=38

select * from team
select * from goals
select * from player_team

--soru 4
with goalPlayer as (
select Top 10 g.playerID, count(g.playerID) as goalNumber
from goals g where isOwnGoal=0 group by g.playerID order by goalNumber DESC) 
select gp.playerID, count(matchID) matchDidNotScored from goals g, goalPlayer gp 
where  gp.playerID=g.playerID and matchID NOT IN(select matchID from goals g,goalPlayer gp where gp.playerID=g.playerID)




--maç başına gol sayısı
select matchID,count(matchID) from goals  group by matchID

select MAX(matchID) from goals --> 306
--soru 5
--player goal attığı maç
with goalPlayer as (
select Top 10 g.playerID, count(g.playerID) as goalNumber
from goals g where isOwnGoal=0 group by g.playerID order by goalNumber DESC),
playerMatch as(
select gp.playerID,matchID as macID from goals g,goalPlayer gp where gp.playerID=g.playerID ),
playerMatchDistinct as(
select distinct playerID,pm.macID from playerMatch pm),
notScored as(
select pm.playerID,34-count(pm.playerID) as NotScored from playerMatchDistinct pm group by pm.playerID), --306 is from the max match number
fiveColumns as(
select firstName,lastName,p.playerID,goalNumber,ns.NotScored from player p, goalPlayer gp,notScored ns
 where p.playerID=ns.playerID and p.playerID=gp.playerID),
lastRecord as(
 select p.playerID,306-ns.NotScored as perMatch, gp.goalNumber from notScored ns,player p, goalPlayer gp 
 where p.playerID=ns.playerID and gp.playerID = p.playerID)
 select fc.firstName,fc.lastName,fc.playerID,fc.goalNumber,fc.NotScored,
 CAST(lr.goalNumber as float)/CAST(34-fc.NotScored as float) as GoalPerMatch
 from fiveColumns fc,lastRecord lr where lr.playerID=fc.playerID ORDER BY goalNumber DESC

