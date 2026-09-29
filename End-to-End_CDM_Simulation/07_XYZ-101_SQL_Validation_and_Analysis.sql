-- XYZ101 Clinical Data Management Simulation
-- SQL Validation and Analysis
-- Tool: MySQL Workbench 8.0
-- Dataset: 10 simulated subjects
-- Study design: Phase III

CREATE DATABASE XYZ101_CDM;
USE XYZ101_CDM;
SELECT DATABASE();
CREATE TABLE Demographics(
Site_ID VARCHAR(20) PRIMARY KEY,
Screening_Number varchar(20),
Subject_ID varchar(20),
Date_of_Birth date,
Age int,
Sex varchar(20),
Race varchar(50),
Ethnicity varchar(50)
);
drop table demographics;
CREATE TABLE Demographics(
Site_ID VARCHAR(20),
Screening_Number varchar(20),
Subject_ID varchar(20) primary key,
Date_of_Birth date,
Age int,
Sex varchar(20),
Race varchar(50),
Ethnicity varchar(50)
);
Describe demographics;
select database();
select * From demographics;
select count(*) from demographics;
select * from demographics;
create table vitals (
subject_ID varchar(20),
Assessment_date Date,
Systolic_Blood_Pressure INT,
Diastolic_blood_pressure INT,
Pulse_Rate INT,
Temperature decimal(4,1),
Weight decimal(5,1)
);
Select * from vitals;
Create Table Labs (
Subject_ID Varchar(20),
Laboratory_Test varchar(50),
Collection_Date Date,
Laboratory_Result Decimal(5,2),
Unit varchar(20),
Reference_range varchar(30)
);
select * From labs;
create table efficacy (
Subject_ID varchar(20),
Assessment_date date,
Visit varchar(20),
HbA1c_Result Decimal(5,2),
HbA1c_Unit varchar(10),
Assessment_Status varchar(30)
);
select * from labs;
Select subject_ID, Count(*) AS Record_count
From demographics
Group by Subject_ID
Having Count(*)>1;
Select subject_ID, Age
From demographics
Where Age<18 OR Age>75;
Select subject_ID, systolic_Blood_Pressure, Diastolic_Blood_Pressure
From vitals
Where Systolic_blood_pressure<70
or Systolic_blood_pressure>250
or Diastolic_blood_pressure<40
or Diastolic_blood_pressure>150;
Select Subject_id, Systolic_blood_pressure, Diastolic_blood_pressure
From vitals
Where systolic_blood_pressure<=Diastolic_blood_pressure;
Select *
From labs
Where Laboratory_result=Null;
select *
From labs
Where Laboratory_result='HbA1c' And (Laboratory_result<3 or Laboratory_result>20);
Select e.Subject_ID
From efficacy e
Left Join demographics d
On e.subject_id=d.subject_id
Where d.subject_id is null;
Select v.subject_id
from vitals v
Left Join demographics d
ON v.subject_id=d.subject_id
where d.subject_id=null;
Select subject_id, visit, count(*) AS record_count
From efficacy
Group by Subject_id, Visit
Having Count(*)>1;
Select subject_id,
MAX(CASE when visit='baseline' then HbA1c_Result END) AS Baseline_HbA1c,
Max(case when visit='week 12' then HbA1c_Result END) AS Week12_HbA1c,
MAX(CASE when visit='baseline' then HbA1c_Result END)- Max(CASE when visit='week 12' then HbA1c_Result END) AS HbA1c_Change
From efficacy
Group by Subject_ID;
Select AVG(HbA1c_Change) AS Mean_HbA1c_Reduction
From (Select subject_id,
MAX(CASE when visit='baseline' then HbA1c_Result END) AS Baseline_HbA1c,
Max(case when visit='week 12' then HbA1c_Result END) AS Week12_HbA1c,
MAX(CASE when visit='baseline' then HbA1c_Result END)- Max(CASE when visit='week 12' then HbA1c_Result END) AS HbA1c_Change
From efficacy
Group by Subject_ID)
AS Analysis;
select Count(*) AS Subjects_with_HbA1c_reduction
From (Select subject_id,
MAX(CASE when visit='baseline' then HbA1c_Result END) AS Baseline_HbA1c,
Max(case when visit='week 12' then HbA1c_Result END) AS Week12_HbA1c,
MAX(CASE when visit='baseline' then HbA1c_Result END)- Max(CASE when visit='week 12' then HbA1c_Result END) AS HbA1c_Change
From efficacy
Group by Subject_ID)
As analysis
Where HbA1c_change>0;
select Count(*) AS Subjects_with_HbA1c_reduction,
Count(*)*100.0/(select count(distinct subject_id) From efficacy) AS percentage_with_HbA1c_Reduction
From(Select subject_id,
MAX(CASE when visit='baseline' then HbA1c_Result END) AS Baseline_HbA1c,
Max(case when visit='week 12' then HbA1c_Result END) AS Week12_HbA1c,
MAX(CASE when visit='baseline' then HbA1c_Result END)- Max(CASE when visit='week 12' then HbA1c_Result END) AS HbA1c_Change
From efficacy
Group by Subject_ID)
As analysis
Where HbA1c_change>0;