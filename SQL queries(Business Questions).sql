use fetchrewards

select * from brand;

-- When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
select 
Case 
   when (avg(a.totalSpent)) > (avg(b.totalSpent)) Then 'FINISHED'
   when (avg(b.totalSpent)) > (avg(a.totalSpent)) Then 'REJECTED'
   else 'Equal'
End AS Compare
from receipts a cross join receipts b 
where a.rewardsReceiptStatus ='FINISHED' and b.rewardsReceiptStatus ='REJECTED'
group by a.rewardsReceiptStatus,b.rewardsReceiptStatus;

-- When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
select 
Case 
   when (count(a.rewardsReceiptItemList)) > (count(b.rewardsReceiptItemList)) Then 'FINISHED'
   when (count(b.rewardsReceiptItemList)) > (count(a.rewardsReceiptItemList)) Then 'REJECTED'
   else 'Equal'
End AS Compare
from receipts a cross join receipts b 
where a.rewardsReceiptStatus ='FINISHED' and b.rewardsReceiptStatus ='REJECTED'
group by a.rewardsReceiptStatus,b.rewardsReceiptStatus;

-- What are the top 5 brands by receipts scanned for most recent month?
select brand.name as Brand, Count(receipts.Receipt_id) as Total_Receipt from brand 
left join receipts on brand.Receipt_id = receipts.Receipt_id
inner join dates on receipts.dates_ID = dates.dates_ID -- asssuming dates and receipts have common column 
group by brand.name
having datepart(mm,date.dateScanned.$date) =month(getdate())
order by Total_Receipt desc limit 5;


-- Which brand has the most spend among users who were created within the past 6 months?
select brand.idBrand as BrandID, brand.name as Brand, sum(receipts.totalSpent) as TotalSpent, date.createDate.$date as Date from brand 
inner join receipts on brand.Receipt_id = receipts.Receipt_id
inner join dates on receipts.dates_ID = dates.dates_ID -- asssuming dates and receipts have common column 
where Date > curdate() - interval (dayofmonth(curdate()) - 1) day - interval 6 month
group by BrandID, Brand
order by TotalSpent desc limit 1;

-- Which brand has the most transactions among users who were created within the past 6 months?
select brand.idBrand as BrandID, brand.name as Brand, count(date.dateScanned.$date) as No_of_Transaction from brand 
inner join receipts on brand.Receipt_id = receipts.Receipt_id
inner join dates on receipts.dates_ID = dates.dates_ID -- asssuming dates and receipts have common column 
where date.dateScanned.$date > curdate() - interval (dayofmonth(curdate()) - 1) day - interval 6 month
group by BrandID, Brand
order by No_of_Transaction desc limit 1;

-- How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?

-- This question can be solved with the help of LAG questions 

/**select*, LAG(Count(receipts.Receipt_id)) OVER (PARTITION BY brand.name ORDER BY month(getdate())
as previousmonth
FROM brand
order by name;**/





