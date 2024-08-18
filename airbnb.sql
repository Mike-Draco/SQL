use airbnb

/* list the properties with the most # of reviews*/
with x as (select listing_id, count(listing_id) as #_of_reviews
from reviews
group by listing_id)

select dbo.listings.id, dbo.listings.name, x.#_of_reviews
from listings
join x on dbo.listings.id = x.listing_id
order by x.#_of_reviews desc
;

/* Show the price based on month of date stayed*/
select distinct listing_id, month(date_stayed) as month_stayed,year(date_stayed) as year_stayed, price
from calendar 
order by month_stayed, year_stayed, listing_id asc
;

/* Show the average price by neighbourhood and room type*/
select neighbourhood, room_type, avg(price) as avg_price
from listings
group by neighbourhood, room_type
order by avg_price desc;

/* Show the hosts with the most number of properties*/
select host_id, host_name, count(id) as #_of_properties
from listings
group by host_id, host_name
order by #_of_properties desc;

/* show the last review writtewn for each property*/
select listing_id, date, reviewer_name, comments
from reviews
where date = (select max(date) from reviews);



