select * from health;
-- the most doctor appearanced 
select Doctor , count(Doctor) as doctor_num
from health 
group by Doctor
order by doctor_num desc;
-- how many type of medical condition we have 
select count(distinct `Medical Condition`)
from health;
-- create procedure 
DELIMITER //
CREATE PROCEDURE health()
BEGIN
    SELECT * FROM health;
END //
DELIMITER ;
call health;
-- return the null values
select count(case when `Name` is null then 0 end)as nname,
        count(case when `Age` is null then 0 end)as nage,
        count(case when `Gender` is null then 0 end)as ngender,
        count(case when `Blood Type` is null then 0 end)as nBlood_type,
        count(case when `Medical condition` is null then 0 end)as nmedical,
        count(case when `Date of Admission` is null then 0 end)as nDate_Admission,
        count(case when `Doctor` is null then 0 end)as ndoctor,
        count(case when `Hospital` is null then 0 end)as nhospital,
        count(case when `Insurance Provider` is null then 0 end)as nInsurance_Provider,
        count(case when `Billing Amount` is null then 0 end)as nBilling_Amount,
        count(case when `Room Number` is null then 0 end)as nRoom_Number,
        count(case when `Admission Type` is null then 0 end)as nAdmission_Type,
        count(case when `Discharge Date` is null then 0 end)as nDischarge_Date,
        count(case when `Medication` is null then 0 end)as nMedication,
        count(case when `Test Results` is null then 0 end)as nTest_Results
from health;
-- call 
call health;
-- blood type for the both gender
select `Gender`,`Blood Type`, count(*)
from health 
group by `Gender`, `Blood Type`
order by `Blood Type`;

-- hospitals 
select Hospital, count(*) as numb
from health 
group by Hospital
order by numb desc;
call health;
-- what's the most comman medical condition we encounter
select `Medical Condition`, count(*) as counter
from health
group by `Medical condition`
order by counter desc;

-- create age categores
select min(`Age`) as min_age ,
       max(`Age`) as max_age ,
       avg(`Age`) as avg_age ,
       (max(`Age`)- min(`Age`)) as range_age 
       from health;
 -- add column Ages for age categories       
 alter table health 
 add column `Ages` varchar(50);
 
 call health;
UPDATE health
SET Ages = CASE
    WHEN Age < 20 THEN 'teenager'
    WHEN Age >= 20 AND Age < 30 THEN 'twenties'
    WHEN Age >= 30 AND Age < 40 THEN 'thirties'
    WHEN Age >= 40 AND Age < 50 THEN 'forties'
    WHEN Age >= 50 AND Age < 60 THEN 'fifties'
    WHEN Age >= 60 AND Age < 70 THEN 'sixties'
    WHEN Age >= 70 AND Age < 80 THEN 'seventies'
    ELSE 'eighties'
END;

SET SQL_SAFE_UPDATES = 0;

-- most common condition for every Age category 
with medcon as (
select `Medical Condition`, Ages, count(*) as num 
from health 
group by `Medical condition`, Ages)
, rank_tab as (select `Medical condition`, Ages, num
                        , row_number() over(partition by Ages order by num desc) as rn
                        from medcon)
                        select * from rank_tab
                        where rn =1
                        order by `Medical Condition`;
  
 -- 
 call health;
 -- the year with most conditions
 select year(`Date of Admission`)as year , count(*) as numm
 from health
 group by year 
 order by numm desc;
-- most medication give
select `Medication`, count(*) as mn
from health 
group by `Medication`
order by mn desc
;
select `Admission Type`, count(*) as an
from health 
group by `Admission Type`
order by an
; 
-- the most prescribed medication for every condition 
select * from (
select Medication , `Medical Condition`, mmc ,
        row_number() over(partition by `Medical Condition` order by mmc desc) as posi
        from (
select Medication , `Medical Condition`, count(*) as mmc
from health
group by Medication, `Medical condition`) as ddf) dds
where posi =1
;

call health;

-- test result for every medical condition
select  `Medical Condition`, `Test Results` , count(*) as mtr
from health
group by `Medical Condition`, `Test Results` 
order by `Medical Condition`, `Test Results`, mtr desc;

call health;

-- what's the most blood type get medical condition for each 
select * 
from (select `Blood Type` , `Medical Condition` ,`dft`,
		row_number () over ( partition by `Blood Type` order by `dft` desc) as makings
	from (select `Blood Type`, `Medical Condition`, count(*) as dft
          from health 
          group by `Blood Type` , `Medical Condition` ) ssb)gbl
          where  makings = 1;

call health ;
-- medical condition for the both genders
select Gender, `Medical condition`, count(*) ert
from health
group by Gender , `Medical Condition` 
order by  ert desc;

call health






