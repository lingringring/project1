SELECT 
	*
FROM 
	Sammy_sales.customers_cleaned_d c;
    
SELECT
	*
FROM
	Sammy_sales.orders_cleaned_d;
    
DELETE FROM orders_cleaned_d WHERE order_id = '';
    
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

#EDA
#total
SELECT
	count(*) AS num_of_orders,
    round(sum(revenue),2) AS ttl_rev,
    round(sum(profit),2) AS ttl_pro
FROM 
	orders_cleaned_d;

#by sport
SELECT
	sport,
    round(sum(revenue), 2) AS total_revenue,
    round(sum(profit), 2) AS total_profit,
    round((profit/revenue), 2) AS profit_margin,
    #key is to ignore the 0 value cells
    round(avg(NULLIF(rating, 0)), 2) AS rating
FROM
	orders_cleaned_d o
GROUP BY sport
ORDER BY profit_margin DESC;

#rating
UPDATE orders_cleaned_d 
SET rating = NULLIF(rating, '');

SELECT
	count(rating) AS num_rating,
    round(avg(rating), 2) AS avg_rating
FROM 
	orders_cleaned_d;
#WHERE rating > 0;

SELECT
	rating,
    round(count(rating), 2) AS num_rating,
    round(sum(revenue), 2) AS total_rev,
    round(sum(profit), 2) AS total_pro,
    round(avg(profit/revenue), 2) AS avg_profit_margin
FROM 
	orders_cleaned_d
GROUP BY rating
ORDER BY rating;


##Question 1: Top 5 states of the most rev, profits, best profit margins
#rev
SELECT
	c.State,
    round(SUM(revenue), 2) AS total_rev
FROM 
	orders_cleaned_d o
		JOIN
	customers_cleaned_d c ON o.customer_id = c.customer_id
GROUP BY c.State
ORDER BY total_rev DESC
LIMIT 5;

#profit
SELECT
	c.State,
    round(sum(profit), 2) AS total_profit
FROM 
	orders_cleaned_d o
		JOIN
	customers_cleaned_d c ON o.customer_id = c.customer_id
GROUP BY c.State
ORDER BY total_profit DESC
LIMIT 5;

#profit_margin
SELECT
	c.State,
    round((profit/revenue), 2) AS profit_margin
FROM 
	orders_cleaned_d o
		JOIN
	customers_cleaned_d c ON o.customer_id = c.customer_id
GROUP BY c.State
ORDER BY profit_margin DESC
LIMIT 5;

##Question 2: which month is most profitable?
SELECT 
	MONTH(date) AS month,
    ROUND(SUM(profit), 2) AS total_profit
FROM 
    orders_cleaned_d o
GROUP BY month
ORDER BY total_profit DESC;

# -> what's the most popular products during these month?
SELECT
    sport,
    month(date) AS order_month,
    round(sum(revenue), 2) AS ttl_revenue
FROM
	orders_cleaned_d o
GROUP BY order_month, sport
HAVING sport = 'soccer'
ORDER BY ttl_revenue DESC;

##Question 3. What sport has the greatest profit margin?
SELECT
	sport,
    round((profit/revenue), 2) AS profit_margin
FROM
	orders_cleaned_d o
GROUP BY sport
ORDER BY profit_margin DESC;

##Question 4. Which sports should we highlight during those marketing campaigns?
SELECT
	sport,
    round(sum(revenue), 2) AS total_revenue,
    round(sum(profit), 2) AS total_profit,
    round((profit/revenue), 2) AS profit_margin,
    #key is to ignore the 0 value cells
    round(avg(NULLIF(rating, 0)), 2) AS rating
FROM
	orders_cleaned_d o
GROUP BY sport
ORDER BY profit_margin DESC;

#avg purchase amount for each sports?
SELECT 
	sport,
    round(avg(revenue), 2) AS AVG_PER_ORDER
FROM 
	orders_cleaned_d o
GROUP BY sport
ORDER BY avg_per_order DESC;
#no repeat buyers? 

##Question 5. Which areas of the country are best to launch marketing campaigns? And at what time of year?
SELECT 
	c.state,
    round(sum(o.revenue) ,2) AS ttl_revenue,
    round(sum(o.profit) ,2) AS ttl_profit,
	round((profit/revenue), 2) AS profit_margin,
    round(avg(NULLIF(rating, 0)), 2) AS rating
FROM 
	orders_cleaned_d o
		JOIN
	customers_cleaned_d c ON o.customer_id = c.customer_id
GROUP BY c.state
ORDER BY ttl_revenue DESC;

#by sports
SELECT 
	c.state,
    o.sport,
    round(sum(o.revenue) ,2) AS ttl_revenue,
    round(sum(o.profit) ,2) AS ttl_profit,
	round((profit/revenue), 2) AS profit_margin,
    round(avg(NULLIF(rating, 0)), 2) AS rating
FROM 
	orders_cleaned_d o
		JOIN
	customers_cleaned_d c ON o.customer_id = c.customer_id
GROUP BY c.state, o.sport
HAVING sport = 'basketball'
ORDER BY ttl_revenue DESC;