-- The full unicorn companies table showing all details
select *
	from unicorn_companies;


-- Total number of unicorn companies in the dataset
select count(*)
	from unicorn_companies;


-- Different company industries in the table
select industry, 
	   count(*) as companies
	from unicorn_companies
	group by 1;


-- The Artificial intelligence industry is showing as two because of 'I' and 'i', we need to merge them.
update unicorn_companies
	set industry = 'Artificial intelligence'
	where industry = 'Artificial Intelligence';


-- Total number of different industries of the unicorn companies
select count(distinct industry)
	from unicorn_companies;


-- Continents and their number of unicorn companies
select continent, 
	   count(*) as companies
	from unicorn_companies
	group by 1
	order by 2 desc;


-- countries and their number of unicorn companies
select country, 
	   count(*) as companies
	from unicorn_companies
	group by 1
	order by 2 desc;


-- average number of years it takes for a company to become a unicorn
select round(avg(yrs_to_unicorn),0) as avg_yrs_to_unicorn
	from (
		  select (year_joined - year_founded) as yrs_to_unicorn
		  from unicorn_companies
		 ) company_yrs;
		 
		 
-- top 5 countries on average to easily become a unicorn company
select country,
	   round(avg(yrs_to_unicorn),0) as avg_yrs_to_unicorn
	from (
		  select country,
				 (year_joined - year_founded) as yrs_to_unicorn
		  from unicorn_companies
		 ) company_yrs
	group by 1
	order by 2 ASC
	limit 5;
	
		 
-- top 5 continent on average to easily become a unicorn company
select continent,
	   round(avg(yrs_to_unicorn),0) as avg_yrs_to_unicorn
	from (
		  select continent,
				 (year_joined - year_founded) as yrs_to_unicorn
		  from unicorn_companies
		 ) company_yrs
	group by 1
	order by 2 ASC
	limit 5;


-- average years it takes for companies in different industries to become unicorn
select industry,
	   round(avg(yrs_to_unicorn),0) avg_yrs_to_unicorn,
	   rank() over(order by avg(yrs_to_unicorn)) as rnk
	from (
		  select industry,
				 (year_joined - year_founded) as yrs_to_unicorn
		  from unicorn_companies
		 ) industry_yrs
	group by 1
	order by 2 asc;
	
	
-- top 10 years with most conpanies becoming unicorn
select year_joined,
	   count(*),
	   rank() over(order by count(*) desc)
	from unicorn_companies
	group by 1
	order by 2 desc
	limit 10;
	
	
-- 	the top 5 companies with the biggest return on investment (ROI)
with CTE_profit as
		(
			select company, 
				   industry,
				   funding,
				   (valuation-funding) as profit
			from unicorn_companies
			where funding is not null
		)
select company,
	   industry,
	   (profit/funding)*100 as "ROI",	   
	   dense_rank() over(order by (profit/funding)*100 desc) as rnk
	from CTE_profit
	order by 3 desc
	limit 5;
	   
	   
-- average return on investment of each industry
with CTE_industry_ROI as
	(
	  select industry,
			 funding,
	   		 (valuation - funding) as profit
	  from unicorn_companies
	  where funding is not null 
	)
select industry,
	   round(avg(profit/funding)*100,0) as "avg_ROI",
	   rank() over(order by avg(profit/funding)*100 desc) as rnk
	from CTE_industry_ROI
	group by 1
	order by 2 desc;


-- top 5 countries with the best average ROI for companies
with CTE_country_ROI as
	(
	  select country,
			 funding,
	   		 (valuation - funding) as profit
	  from unicorn_companies
	  where funding is not null 
	)
select country,
	   round(avg(profit/funding)*100,0) as "avg_ROI",
	   rank() over(order by avg(profit/funding)*100 desc) as rnk
	from CTE_country_ROI
	group by 1
	order by 2 desc
	limit 5;
	
	
-- top 5 continents with the best average ROI
with CTE_continent_ROI as
	(
	  select continent,
			 funding,
	   		 (valuation - funding) as profit
	  from unicorn_companies
	  where funding is not null 
	)
select continent,
	   round(avg(profit/funding)*100,0) as "avg_ROI",
	   rank() over(order by avg(profit/funding)*100 desc) as rnk
	from CTE_continent_ROI
	group by 1
	order by 2 desc
	limit 5;
	
