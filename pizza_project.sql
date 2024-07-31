--- Total number of order placed
select count(order_id) as total_orders
from orders

--- revenue generated from sales
select round(sum(revenue_order),2) as revenue_order
from(
select order_id, quantity, price, quantity*price as revenue_order
from order_details as od
join pizzas as p
on od.pizza_id = p.pizza_id) as x

--- most priced pizza
select TOP 1 name, max(price) as max_price
from pizzas as p
join pizza_types as pt
on p.pizza_type_id = pt.pizza_type_id
group by name
order by 2 desc

--- most common pizza size ordered
select size, count(size) as most_ordered
from order_details as od
join pizzas as p
on od.pizza_id = p.pizza_id
group by size
order by 2 desc


--- top 5 most ordered pizza and quantity
select top 5 name, sum(quantity) as Qty
from pizzas as p
join order_details as od
on p.pizza_id = od.pizza_id
join pizza_types as pt
on p.pizza_type_id = pt.pizza_type_id
group by name
order by 2 desc

---total quantity of each pizza category ordered
select category, sum(quantity) as QTY
from pizzas as p
join order_details as od
on p.pizza_id = od.pizza_id
join pizza_types as pt
on p.pizza_type_id = pt.pizza_type_id
group by category 
order by 2 desc

--- quantuty of each pizza size ordered by pizza name
select name, size, sum(quantity) as QTY
from pizzas as p
join order_details as od
on p.pizza_id = od.pizza_id
join pizza_types as pt
on p.pizza_type_id = pt.pizza_type_id
group by name, size
order by 3 desc

--- distribution of orders per time of the day
select convert(time, o.time) as Time, sum(quantity) as OrderPerTime
from orders as o
join order_details as od
on o.order_id = od.order_id
group by time
order by 2 desc

---Number of Pizza Categories
select category, count(category)
from pizza_types
group by category

---Average delivery per day
select round(avg(sum_quantity),2) Avg_Delivery
from(
	select convert(date, o.date) as date, sum(quantity) as sum_quantity
	from orders as o
	join order_details as od
	on o.order_id = od.order_id
	group by date) as x


---Top 3 Pizza by Revenue
select top 3 name, round(sum(quantity*price),2) as pizza_revenue
from order_details as od
join pizzas as p
on od.pizza_id = p.pizza_id
join pizza_types as pt
on p.pizza_type_id = pt.pizza_type_id
group by name
order by 2 desc


--- percentage contribution of all categories of pizza to the total revenue
select  category, round((sum(quantity*price)/(select round(sum(revenue_order),2) as revenue_order
from(
	select order_id, quantity, price, quantity*price as revenue_order
	from order_details as od
	join pizzas as p
	on od.pizza_id = p.pizza_id) as x)),4)*100 as pizza_revenue
from order_details as od
join pizzas as p
on od.pizza_id = p.pizza_id
join pizza_types as pt
on p.pizza_type_id = pt.pizza_type_id
group by category
order by 2 desc

---Sum of Revenue by month
select month, sum(revenue) as rev_month
from(
	select month(o.date) as month, round(sum(price*quantity),2) as revenue
	from order_details as od
	join pizzas as p
	on od.pizza_id = p.pizza_id
	join pizza_types as pt
	on p.pizza_type_id = pt.pizza_type_id
	join orders as o
	on o.order_id = od.order_id
	group by date) as x
group by month 
order by 1

---Percentage contribution of each pizza category to revenue
select category, round((sum(quantity*price)/(select round(sum(revenue_order),2) as revenue_order
from(
	select order_id, quantity, price, quantity*price as revenue_order
	from order_details as od
	join pizzas as p
	on od.pizza_id = p.pizza_id) as x)),4)*100 as pizza_revenue
from order_details as od
join pizzas as p
on od.pizza_id = p.pizza_id
join pizza_types as pt
on p.pizza_type_id = pt.pizza_type_id
group by category
order by 2 desc
