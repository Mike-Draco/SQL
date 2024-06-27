/* SQL Assignment 4: SQL summary/aggregate functions
   Due Date: Sunday 4/19 at midnight
   Please submit the completed SQL script file and a spreadsheet showing the result of each SQL query */

--  example: List total sales, total number of trips, average sales, highest sales  and lowest sales of all trips.
use adventure;

Select sum(tripprice*numPersons+OtherFees) as total_sales, 
        count(reservationID) as number_of_trips,
	    round(avg(tripprice*numPersons+OtherFees)) average_sales,
        max(tripprice*numPersons+OtherFees) as highest_sales, 
        min(tripprice*numPersons+OtherFees) as Lowest_sales
from reservation;

-- Query 1. Which state has the most guides? Display state and number of guides.
select distinct(state) ,count(*) over (partition by State) from guide; 


/* Query 2. List the customers with at least 2 reservation. 
           Display customer name, and number of reservation. 
           Order by customer with highest number of reservation first */
           
select distinct(concat(c.FirstName,' ',c.LastName)) as FullName, 
count(r.ReservationID) as NumberOfReserv 
from customer c
inner join reservation r using (CustomerNum)
group by r.CustomerNum
having NumberOfReserv>=2;



/* query 3. List all customers who have made at least 2 reservations and live at MA state.
			Display customer name, and number of reservation. 
            Order by customer name. */

select distinct(concat(c.FirstName,' ',c.LastName)) as FullName, 
count(r.ReservationID) as NumberOfReserv 
from customer c
inner join reservation r using (CustomerNum)
where c.state='MA'
group by r.CustomerNum
having NumberOfReserv>=2
order by FullName;



/* query 4. Which guide(s) give the most trips in each season?
            display season, guide's name, and number of trips. */

select distinct(t.season), concat(g.FirstName,' ',g.LastName) as FullName,
count(r.TripID) over (partition by r.GuideNum,t.season) as NumberTrips
from guide g
inner join reservation r using (GuideNum)
inner join trip t using (TripID)
order by NumberTrips desc;




/*	Query 5. What days of the week are the most trips booked for? 
    Display week day and number of trips. display week day as name of each week day such as Monday etc. */

select distinct(dayname(TripDate)) as WeekDay,
 count(TripID) over (partition by weekday(TripDate)) as NumberOfTrips
 from reservation
 order by NumberOfTrips desc;

/* query 5a challenge question (this is extra credit question. you do not need to do it). 
   Can you order the week day in logical order from Monday to Sunday. */

select distinct(dayname(TripDate)) as WeekDay,
 count(TripID) over (partition by weekday(TripDate)) as NumberOfTrips
 from reservation
 order by dayofweek(TripDate);

/* query 6. List top 5 guides based on number of trips. List guide’ name and number of trips led by each guide.
			order by number of trips with the highest value first. */

select distinct(concat(g.FirstName,' ',g.LastName)) as Name, count(r.TripID) over (partition by r.GuideNum) as NumberTrips
from guide g
inner join reservation r using (guideNum)
order by NumberTrips desc;


/* query 7. List guides who have led at least 4 trips. Display guide’ name and number of trips. */

select distinct(concat(g.FirstName,' ',g.LastName)) as Name, count(r.TripID) as NumberTrips
from guide g
inner join reservation r using (guideNum)
group by r.guideNum
having NumberTrips>=4;




/* query 8. List number of trips, total sales by season and by type.
			Display season, type, number of trips and total sales. Order by season and then by type */

select t.season, t.type, count(r.TripID) as NumberTrips, sum((r.NumPersons*r.TripPrice)+r.OtherFees) as totalSales
from reservation r
inner join trip t using (tripID)
group by t.season,t.type
order by t.season,t.type;



/* query 9.	What trip types are the most popular (based on number of trips) among customers from both MA and RI states? */

select c.state, count(r.tripID),t.type
from customer c
inner join reservation r using (CustomerNum)
inner join trip t using (TripID)
where c.state in ('MA','RI')
group by c.state,t.type; 


/* query 10. for each state a customer is in, display monthly sales, and 3 month moving average sales.
   Display state, month, total sales of each month and 3 month moving average sales.
   order by state and then month.
*/
select c.state, MONTH(r.tripDate) AS month,
       SUM((r.NumPersons*r.TripPrice)+r.OtherFees) AS total_invoices,
       ROUND(AVG(SUM((r.NumPersons*r.TripPrice)+r.OtherFees)) OVER (ORDER BY MONTH(r.tripDate) RANGE BETWEEN 1 PRECEDING AND 1 FOLLOWING ), 2)
         AS 3_month_avg
FROM reservation r
inner join customer c using (CustomerNum)
GROUP BY c.state, MONTH(tripDate)
order by c.state,month(tripDate);




/* Below is part of results for query 10.

CT	8	325.00	357.50
CT	9	390.00	265.00
CT	10	80.00	235.00
MA	5	75.00	182.50
MA	6	290.00	255.00
MA	7	400.00	345.00
MA	9	75.00	135.00
MA	10	195.00	135.00

*/