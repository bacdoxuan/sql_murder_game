
/*
Description
 
A crime has taken place and the detective needs your help. The detective gave you the
crime scene report, but you somehow lost it. You vaguely remember that the crime
was a ​murder​ that occurred sometime on ​Jan.15, 2018​ and that it took place in ​SQL
City​. Start by retrieving the corresponding crime scene report from the police
department’s database. If you want to get the most out of this mystery, try to work
through it only using your SQL environment and refrain from using a notepad
*/ 

-- 1. First, the crime happend in SQL City, we extract information from crime_scene_report table

select * from crime_scene_report
where type = 'murder' and city like 'SQL%';

/* 
20180215	murder	REDACTED REDACTED REDACTED	SQL City
20180215	murder	Someone killed the guard! He took an arrow to the knee!	SQL City
20180115	murder	Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave".	SQL City

*/

-- 2. There were 2 witnesses, one lived at the last house on Northwestern, one named Annabel, lived on Franklin Ave. We extract information from person table

select * from person
where address_street_name = 'Northwestern Dr'
order by address_number desc
limit 1;

select * from person
where name like '%Annabel%' and address_street_name like 'Franklin Ave';

/* Query reults
id	name	license_id	address_number	address_street_name	ssn
14887	Morty Schapiro	118009	4919	Northwestern Dr	111564949
16371	Annabel Miller	490173	103	Franklin Ave	318771143

*/

-- 3. We extract information from interview table from the 2 witnesses

select p.name as Name, p.id as ID, i.transcript as Transcript
from person p
left join interview i
on p.id = i.person_id
where p.id in (14887, 16371);

/* Query reults
Name	transcript	person_id
Morty Schapiro	I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".	14887
Annabel Miller	I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.	16371

*/

-- 4. From interview detail, we can see that the murderer had some detail: 
--    membership number on the bag started with "48Z"
--    gold member at Get Fit Now Gym
--    car with a plate that included "H42W".
--    worked out on January the 9th.

select per.name, dl.plate_number, fitmember.membership_status, fitmember.id membership_number, checkin.check_in_date
from person per
join drivers_license dl
on per.license_id = dl.id
join get_fit_now_member fitmember
on per.id = fitmember.person_id
join get_fit_now_check_in checkin
on fitmember.id = checkin.membership_id
where fitmember.id like '48Z%' and dl.plate_number like '%H42W%';

/* Query reults
name	plate_number	membership_status	membership_number	check_in_date
Jeremy Bowers	0H42W2	gold	48Z55	20180109

*/

-- 5. We found the MURDERER. His name is Jeremy Bowers. Let's see what he said in the interview

select per.name, per.id, itw.transcript
from person per
join interview itw
on per.id = itw.person_id
where per.id = 67318;

/* Query reults
name	id	transcript
Jeremy Bowers	67318	"I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5"" (65"") or 5'7"" (67""). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.
"
*/

-- 6. So he was hired by a women, she's around 5'5"" (65"") or 5'7"" (67""). She has red hair and she drives a Tesla Model S. She attended the SQL Symphony Concert 3 times in December 2017. Let's check who is she 

select per.name, dl.hair_color, dl.gender, dl.height, fb.date, fb.event_name, income.annual_income, dl.car_make, dl.car_model
from person per
join drivers_license dl
on per.license_id = dl.id
join facebook_event_checkin fb
on per.id = fb.person_id
join income
on per.ssn = income.ssn
where
dl.gender = 'female'
and fb.event_name like '%Symphony%'
and car_make = 'Tesla'
and car_model like '%S%'
;

/* Query reults
name	hair_color	gender	height	date	event_name	annual_income	car_make	car_model
Miranda Priestly	red	female	66	20171206	SQL Symphony Concert	310000	Tesla	Model S
Miranda Priestly	red	female	66	20171212	SQL Symphony Concert	310000	Tesla	Model S
Miranda Priestly	red	female	66	20171229	SQL Symphony Concert	310000	Tesla	Model S

*/

-- 7. That's her. The real brain behind the scence: Miranda Priestly.

-- THE END.
