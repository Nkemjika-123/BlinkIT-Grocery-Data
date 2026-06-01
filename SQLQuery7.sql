--check the null values
select 
SUM(case when item_fat_content is null then 1 else 0 end) as fat_content_nulls,
SUM(case when item_type is null then 1 else 0 end) as item_type_nulls,
SUM(case when item_weight is null then 1 else 0 end) as item_weight_nulls
from [BlinkIT Grocery Data]

select *
from [BlinkIT Grocery Data]

--check for inconsistency
select distinct item_fat_content
from [BlinkIT Grocery Data]

update [BlinkIT Grocery Data]
set item_fat_content = case when item_fat_content in ('LF', 'low fat') then 'Low Fat'
when item_fat_content = 'reg' then 'Regular' else item_fat_content
end

--To remove spaces
update [BlinkIT Grocery Data]
set Item_Identifier = ltrim(rtrim(item_identifier)), Outlet_Size = ltrim(rtrim(Outlet_Size))

select * from [blinkit grocery data]

--check and replace null values
select COUNT(*) as missing_weights from [blinkit grocery data]
where item_weight is null

update [blinkit grocery data]
set item_weight = (select AVG(item_weight) from [blinkit grocery data]) 
where item_weight is null


select SUM(Total_Sales) as Total_Sales
from [Blinkit Grocery Data]

select AVG(Total_Sales) as Avg_Sales
from [Blinkit Grocery Data]

select COUNT(Item_Identifier) as NumberOfItems
from [Blinkit Grocery Data]

select AVG(Rating) as Avg_Rating
from [Blinkit Grocery Data]

SELECT 
    AVG(Rating) AS Average_Rating
FROM [BlinkIT Grocery Data];



1. --Total Sales: The overall revenue generated from all items sold.
select SUM(Total_Sales) as Total_Sales
from [blinkit grocery data]

2. --Average Sales: The average revenue per sale.
select AVG(Total_Sales) as Avg_Sales 
from [blinkit grocery data]


3. --Number of Items: The total count of different items sold.
select COUNT(*) as Total_Count
from [blinkit grocery data]

select COUNT(distinct(Item_Identifier)) as Count_Unique_Items
from [blinkit grocery data]


4. --Average Rating: The average customer rating for items sold. 

select AVG(Rating) as Avg_Rating
from [blinkit grocery data]

select 
    SUM(Total_Sales) as Total_Sales,
    AVG(Total_Sales) as Average_Sales,
    COUNT(distinct Item_Identifier) AS NumberOfItems,
    AVG(Rating) as Average_Rating
from [BlinkIT Grocery Data]


WITH KPI AS (
    SELECT 
        [Total_Sales],
        [Item_Identifier],
        [Rating]
    FROM [BlinkIT Grocery Data]
)
SELECT
    SUM([Total_Sales]) AS Total_Sales,
    AVG([Total_Sales]) AS Average_Sales,
    COUNT(DISTINCT [Item_Identifier]) AS Number_of_Items,
    AVG([Rating]) AS Average_Rating
FROM KPI;

--GRANNULAR REQUIREMENTS

--1. Total Sales by Fat Content:
--	Objective: Analyze the impact of fat content on total sales.
--	Additional KPI Metrics: Assess how other KPIs (Average Sales, Number of Items, Average Rating) vary with fat content.

select Item_Fat_Content, SUM(Total_Sales) as Total_Sales, AVG(Total_Sales) as Avg_Sales, 
COUNT(distinct(Item_Identifier)) as NumberOfItems, AVG(Rating) as Avg_Rating
from [blinkit grocery data]
group by item_fat_content
order by Total_Sales desc



--2. Total Sales by Item Type:
--	Objective: Identify the performance of different item types in terms of total sales.
--	Additional KPI Metrics: Assess how other KPIs (Average Sales, Number of Items, Average Rating) vary with fat content.

select Item_Type, SUM(Total_Sales) as Total_Sales, AVG(Total_Sales) as Avg_Sales,
COUNT(distinct(Item_Identifier)) as NumberOfItems, AVG(Rating) as Avg_Rating 
from [blinkit grocery data]
group by Item_Type
order by Total_Sales desc


--3. Fat Content by Outlet for Total Sales:
--	Objective: Compare total sales across different outlets segmented by fat content.
--	Additional KPI Metrics: Assess how other KPIs (Average Sales, Number of Items, Average Rating) vary with fat content.

select Item_Fat_Content, Outlet_Type, Item_Identifier, SUM(Total_Sales) as Total_Sales, AVG(Total_Sales) as Avg_Sales,
COUNT(Distinct(Item_Identifier)) as NumberOfItems, AVG(Rating) as Avg_Rating 
from [blinkit grocery data]
group by outlet_type, item_fat_content, item_identifier
order by Total_Sales


--4. Total Sales by Outlet Establishment:
--	Objective: Evaluate how the age or type of outlet establishment influences total sales.


select Outlet_Establishment_Year, YEAR(getdate()) - Outlet_Establishment_Year as Outlet_Age, 
Item_Identifier, Outlet_Type, SUM(Total_Sales) as Total_Sales, 
AVG(Total_Sales) as Avg_Sales, COUNT(distinct(Item_Identifier)) as NumberOfItems, AVG(Rating) as Avg_Rating
from [blinkit grocery data]
group by outlet_establishment_year, item_identifier, outlet_type
order by outlet_establishment_year


SELECT 
    [Item_Identifier],
    [Item_Type],
    [Item_Fat_Content],
    [Outlet_Type],
    [Outlet_Establishment_Year],
    (YEAR(GETDATE()) - [Outlet_Establishment_Year]) AS [Outlet_Age],
    [Total_Sales],
    [Rating]
FROM [blinkit grocery data];

--5. Percentage of Sales by Outlet Size:
--	Objective: Analyze the correlation between outlet size and total sales.


select Outlet_Size, SUM(Total_Sales) as Total_Sales, CAST(sum(Total_Sales) * 100.0 / (select SUM(Total_Sales) as Total_Sales
from [blinkit grocery data]) as decimal(10,2)) as Sales_Percentage
from [blinkit grocery data]
group by Outlet_Size
order by Total_Sales desc


--6. Sales by Outlet Location:
--	Objective: Access the geographic distribution of sales across different locations.

select Outlet_Location_Type, SUM(Total_Sales) as Total_Sales, AVG(Total_Sales) as Avg_Sales, 
COUNT(Item_Identifier) as NumberOfItems, AVG(Rating) as Avg_Rating
from [Blinkit grocery data]
group by Outlet_Location_Type
order by Total_Sales desc

--7. All Metrics by Outlet Type:
--	Objective: Provide a comprehensive view of all key metrics (Total Sales, Average Sales, Number of 	Items, Average Rating) broken down by different outlet types.

select Outlet_Type, SUM(Total_Sales) as Total_Sales, CAST(AVG(Total_Sales) as decimal(10,2)) as Avg_Sales, 
COUNT(Item_Identifier) as NumberOfItems, CAST(AVG(Rating) as decimal(10,2)) as Avg_Rating
from [Blinkit grocery data]
group by Outlet_Type
order by Total_Sales desc