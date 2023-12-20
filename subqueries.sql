/*Challenge
Write SQL queries to perform the following tasks using the Sakila database:

Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
List all films whose length is longer than the average length of all the films in the Sakila database.
Use a subquery to display all actors who appear in the film "Alone Trip".*/

-- Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
use sakila;
/*select film_id 
from film
where title = "Hunchback Impossible";
select count(inventory.inventory_id) as "Number of copies of the film Hunchback Impossible"
from inventory
where film_id = 439;*/

-- Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

select count(inventory.inventory_id) as "Number of copies of the film Hunchback Impossible"
from inventory
where film_id = (select film.film_id from film where film.title = "Hunchback Impossible");

-- List all films whose length is longer than the average length of all the films in the Sakila database.
select title, length
from film
where length > (select avg(length) from film);

-- Use a subquery to display all actors who appear in the film "Alone Trip"

select first_name, last_name
from actor
where actor_id in
(select actor_id
from film_actor
where film_id = (select film_id from film where title = "Alone Trip"));

/*Bonus:
Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.
*/

-- Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
select title as "Family films"
from film
where film_id in
(select film_id
from film_category
where category_id =
(select category_id
from category
where name = "Family"));

-- Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
select first_name, last_name, email
from customer
where customer.address_id in (select address_id
from address where city_id in (select city_id 
from city where country_id =
(select country_id from country where country = "Canada"))); -- canadian adress

select customer.first_name, customer.last_name, customer.email
from customer
join address
on customer.address_id = address.address_id
where address.city_id in 
(select city.city_id from city where city.country_id =
(select country_id from country where country = "Canada"));

-- Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
select film_id
from film_actor
where actor_id =
(select actor_id from film_actor group by actor_id order by count(film_id) desc limit 1); -- actor id

select title as "Films starred by the most prolific actor"
from film
where film_id in
(select film_id from film_actor where actor_id =
(select actor_id from film_actor group by actor_id order by count(film_id) desc limit 1))
; 

-- Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

select title as "films rented by the most profitable customer"
from film
where film_id in 
(select film_id from inventory where inventory_id in 
(select inventory_id from rental where customer_id = 
(select customer_id from payment group by customer_id order by sum(amount) desc limit 1)));

-- Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.

select customer_id, sum(amount) as total_amount
from payment
group by customer_id
having sum(amount) >
(select avg(total_amount) as average_amount
from (select customer_id, sum(amount) as total_amount from payment group by customer_id) as table1)
order by sum(amount) ;-- average of the total_amount spent by each client
