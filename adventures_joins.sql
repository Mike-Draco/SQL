/* SQL Assignment 3: Joins
   Due Date: Sunday 4/12 at midnight
   Please submit the completed SQL code and a spreadsheet showing the result of each SQL query */
   
-- select adventure database
use adventure;

-- 1. display a list of reservation, including reservation ID, trip ID, trip name, customer number, 
--    customer name, trip date, total cost of the trip in summer.
select r.ReservationID, r.TripID, t.TripName, r.CustomerNum, concat(c.FirstName,' ', c.LastName) as FullName,
r.TripDate, (r.TripPrice*r.NumPersons)+OtherFees as TotalCost
from reservation r
inner join trip t on t.TripID=r.TripID
inner join customer c on c.CustomerNum=r.CustomerNum
where t.Season= 'Summer';


-- 2. Find all guide and customer who live in the same city and state. Display State, city, customer name and guide name.
-- Order by state and then by city.

select g.City,g.State, concat(g.FirstName,' ',g.LastName) as GuideName, 
concat(c.FirstName,' ',c.LastName) as CustomerName
from guide g
inner join customer c on c.State=g.State and c.City=g.City
order by g.State,g.City;


-- 3. Find all guides who are not qualified for any trip. Display guide number and guide name

select g.GuideNum, concat(g.FirstName,' ',g.LastName) as Name
from guide g
left join guidequal g2 on g.GuideNum=g2.GuideNum
where g2.TripID is null;

-- 4. find all trips that have not had any guide to qualify. Display trip id and trip name. Order by trip ID

select t.TripID, t.TripName
from trip t
left outer join guidequal g on g.TripID=t.TripID
where g.GuideNum is null
order by t.TripID;

-- 5. Find all reservation that has a qualifed guide leading the trip. 
--    Display reservation ID, trip ID, trip name, guide ID, guide first name and last name.

select r.ReservationID, t.TripName, r.TripID, g.GuideNum, concat(g.FirstName,' ', g.LastName) as Name
from reservation r
inner join trip t on t.TripID=r.TripID
inner join guide g on g.GuideNum=r.GuideNum;

-- 6. revised your query to show all reservation that has a non-qualifed guide leading the trip.
--     Display reservation ID, trip ID, trip name, guide ID, guide first name and last name.

select r.ReservationID, t.TripName, r.TripID, g.GuideNum, concat(g.FirstName,' ', g.LastName) as Name
from reservation r
inner join trip t on t.TripID=r.TripID
inner join guide g on g.GuideNum=r.GuideNum
where t.TripID in (7,18,27,40);


-- 7. based on the result of query 5 and 5b, create a query showing all reservations with the first column titled Qualification 
--     showing qualifed for the reservations with a qualifed guide. Otherwise showing non-qualified.
--     Display reservation ID, trip ID, trip name, guide ID, guide first name and last name.

select
case
	when r.TripID in (7,18,27,40) then 'Non-Qualified'
    else 'Qualified'
end as Qualification,
 r.ReservationID, t.TripName, r.TripID, g.GuideNum, concat(g.FirstName,' ', g.LastName) as Name
from reservation r
left join trip t on t.TripID=r.TripID
left join guidequal g2 on t.TripID=g2.TripID
left join guide g on g.GuideNum=g2.GuideNum;


-- 8. Find all customers who have not made any reservation. Display customer number, customer name, city, state, and phone.

select c.CustomerNum, concat(c.FirstName,' ', c.LastName) as Name, c.City,c.State, c.Phone, r.ReservationID
from customer c
left  join reservation r on r.CustomerNum=c.CustomerNum
where r.ReservationID is null;


-- 9. Find top 5 reservation based on total trip cost. 
--    Display reservationID, trip ID, trip name, total trip cost, customer name, guide name

select r.ReservationID, r.TripID, t.TripName, (r.NumPersons*r.TripPrice)+r.OtherFees as TotalCost, concat(c.Firstname,' ',c.LastName) as CustomerName,
 concat(g.FirstName,' ',g.LastName) as GuideName
from reservation r
inner join trip t on t.TripID=r.TripID
inner join guide g on g.GuideNum=r.GuideNum
inner join customer c on c.CustomerNum=r.CustomerNum
order by TotalCost desc
limit 5;




-- 10. Develop a question of your own and create a query to answer your question. 
--     Please be aware that your query needs to make business sense and shoud not be an existing question. 

-- Create a query that shows the most expensive trip and display the factors like distance and max group size to try and explain why this trip is so expensive
select r.ReservationID, r.TripID, t.TripName,r.TripPrice,t.MaxGrpSize, t.Distance,t.State
from reservation r
inner join trip t on t.TripID=r.TripID
inner join guide g on g.GuideNum=r.GuideNum
inner join customer c on c.CustomerNum=r.CustomerNum
order by  r.TripPrice desc;



