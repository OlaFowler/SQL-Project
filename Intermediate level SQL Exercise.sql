--1 What's is the total number of rows in the customer shipment table :
select count(orderid) from [dbo].[CustomerShipment]
select count(*) from [dbo].[CustomerShipment]

--2 You wanted to know how many province are there in the database :
--Write a sql statement to extract all the province
select StateProvince from [dbo].[StateProvince]
select distinct (StateProvince) from [dbo].[PurchaseTrans]

--3 List all the employees whose Lastname is David
select * from [dbo].[Employee]
where LastName = 'david'

--4 Supplier, Vargas Garrett wanted to know how many transaction he has done since joining the business,
--Pull a report showing all transaction ID for Vargas Garrett
select count(transid), supplier from [dbo].[PurchaseTrans]
where supplier = 'Vargas Garrett'
group by Supplier

--5 & 6
--Still on Vargas Garrett matter, he wanted us to find out all the Account Numbers for his transaction. 
--Pull a list of all account numbers for all his transaction. Ensure there are no duplicate account number listed
select distinct (AccountNumber), supplier from [dbo].[PurchaseTrans]
where supplier = 'vargas Garrett'

--7 As the senior manager , you want to know all the products supplied by Vargas Garrett or Pak Jae
Select PT.supplier, P.productname from [dbo].[PurchaseTrans] PT
inner join [dbo].[Product] P 
on P.ProductID = PT.ProductID
where Supplier = 'Vargas Garrett' or Supplier = 'Pak Jae' 
--where supplier in ('Vargas Garrett', 'Pak Jae')

--8 From the Purchase Transaction table, list all transactions showing the productsID, the transaction ID, 
--the account Number, the employee that processed the transaction and that are Silver in color and list price greater than $3398
select productid, transid, employee, accountnumber, Color, ListPrice
from [dbo].[PurchaseTrans]
where Color = 'silver' and ListPrice > 3398

--9 As the business analyst, you are trying to perform a root cause analysis of why certain carrier tracking numbers 
-- are having delayed status. You observe that carrier numbers that have 4343 were most impacted. 
-- Write SQL to list all transaction that has carrier tracking number containing the “4343”.
select CarrierTrackingNumber from [dbo].[PurchaseTrans]
where CarrierTrackingNumber like '%4343%'

--10 Still on on this root cause analysis , you notice those carriertracking numbers that starts with 6C
--and those that ends with 83 are also impacted. Write a sql code to list all transactions that contains these criteria 
-- and in addition those in Exercise 9. Please list only the TransactionID, Carrier Tracking Number, 
-- Supplier Name, Color, List Price and ProductID
select transid, carriertrackingnumber, supplier, color, listprice, productid 
from [dbo].[PurchaseTrans] 
where CarrierTrackingNumber like '6c%' or carriertrackingnumber like '%83' or CarrierTrackingNumber like '%4343%'

--11 The marketing manager requested that you produce a listing that shows all the Suppliers, their city and country and
--column that shows the continent. You noticed there is no continent column in the PurchaseTrans table. Find all the unique countries 
--in the transaction table and assign them to their continent name e.g USA to North America etc. Then produce the listing as described
select distinct country, city, supplier,  
case  Country
when 'germany' then 'Europe'
when 'United States' then 'North America'
when 'Australia' then 'Oceania'
when 'United Kingdom' then 'Europe'
when 'Canada' then 'North America'
when 'France' then 'Europe' 
else 'unknown'
end as Continent 
from [dbo].[PurchaseTrans]

--OR
select distinct country, city, supplier,  
case  
when country = 'Germany' or country = 'United Kingdom' or country = 'France' then 'Europe'
when country = 'United States' or country = 'Canada' then 'North America'
when country = 'Australia' then 'Oceania'
else 'unknown'
end as Continent 
from [dbo].[PurchaseTrans]

--12 As the logistics BI analyst , you will like to assign shipment cost based on the listprice and customer class. . , 
-- List all the customer class using customershipment table. Ensure you arrange them in alphabetic order. Now for each class on your list, 
-- assign then a % charge. For the first customer class in the alphabetic order, assign a charge of 1%( i.e. 0.01) . 
--Using an incremental step of 1% i.e next class charge will be 2% i.e 0.02 . If there is no customer class , use a default value of 7% . 
-- Call this column ShippingCost Now produce a list from the customershipment table showing OrderID , City, Country, 
--ProductNumber , Customerclass and ShippingCost.

--Investigating the customerclass table to see the content
select distinct (customerclass)
from [dbo].[CustomerShipment]
order by CustomerClass asc

--Answering the question
select OrderID, city, Country, ProductNumber, CustomerClass,
case CustomerClass
when 'Black' then 0.01 * ListPrice
when 'Blue' then 0.02 * ListPrice
when 'NULL' then 0.07 * ListPrice
when 'Red' then 0.03 * ListPrice
when 'Silver' then 0.04 * ListPrice
when 'Yellow' then 0.05 * ListPrice
end as shippingcost
from [dbo].[CustomerShipment]
order by CustomerClass asc

--13 Based on the list you produced in Exercise13, you noticed shipping cost was too high for certain class of customer. In order to 
--motivate those in Silver and Yellow Class, you came up with this criteria: 
--1. Every other class will have No discount, except :
--2. If customer class is yellow and List price 1500 or less , then DiscountCLass will be YellowClassDiscount
--Else if list price is between 1501 and 2000 discountClass will be PromoDIscount , else discountClass will be called VP Discount
--3. If customer class is Silver and List price is 1400 or less then DiscountCLass will be SilverClassDiscount
--Else if list price is greater than 1500 and less than 2000 discountClass will be PromoDIscount, 
--else discountClass will be called VP Discount
select OrderID, city, Country, ProductNumber, CustomerClass,
case
when CustomerClass in ('Black', 'Blue', 'Red', 'Null') then 'No Discount'
when CustomerClass = 'Yellow' and ListPrice <= 1500 then 'YellowClassDiscount'
when CustomerClass = 'Yellow' and ListPrice between 1501 and 2000 then 'PromoDiscount'
when CustomerClass = 'Silver' and ListPrice <= 1400 then 'SilverClassDiscount'
when CustomerClass = 'Silver' and ListPrice > 1500 and ListPrice < 2000 then 'PromoDiscount'
else 'VP'
end
from [dbo].[CustomerShipment]
order by CustomerClass asc

--OR
select listprice, CustomerClass, 
	case customerclass
		when 'Yellow' then 
			case 
					when ListPrice <= 1500 then 'YellowClassDiscount'
					when ListPrice between 1501 and 2000 then 'PromoDiscount'
					else 'VPDiscount'
					end
		when 'Silver' then 
			case
					when ListPrice <= 1400 then 'SilverClassDiscount'
					when ListPrice between 1500 and 2000 then 'PromoDiscount'
					else 'VPDiscount'
					end
		else 'noDiscount'
		end as discountclass
from CustomerShipment
order by CustomerClass asc

--14 Pamela is a Marketing Analyst, she has recently come up with eye catching names for different categories of your products.
--She will like to categorize product based on their use. For every product that has mountain in their product name, 
--call them ‘High Altitude”on a separate column titled MarketAlias, Those with Road as ‘Warrior’ and those with Touring 
--call them “ Zaphyr ” . Any other not in these Categories , call them “Elite”. 
--Produce showing all Product ID, ProductName, Product Number and MarketAlias
select *, 
	case 
		when ProductName like '%mountain%' then 'High Altitude'
		when ProductName like '%road%' then 'Warrior'
		when productname like '%touring%' then 'Zaphyr'
		else 'Elite'
end as marketAlias
from [dbo].[Product]
order by marketAlias 

--15 Whats the total number of Product that contains the word Mountain in their productName
select count(productname) 
from [dbo].[Product]
where productname like '%mountain%'

--OR
select count(distinct productname) 
from [dbo].[Product]
where productname like '%mountain%'

--16 Count the number of unique supplier from the purchaseTrans Table
select count(distinct supplier) 
from [dbo].[PurchaseTrans]

--17 Count the number of transactions made by an employee called Track Glenn
select count(transid), employee 
from PurchaseTrans
where Employee = 'Track Glenn'
group by Employee

--18 What's the average order shipped tilldate
select AVG(orderqty) avgorder
from [dbo].[CustomerShipment]


--19 Whats the average list price for all order shipped till date
select avg(listprice) as AverageOrderShipped from [dbo].[CustomerShipment]

--20 What's the highest quantity of order shipped tilldate
select max([OrderQty]) as HighestOrderQty
from [dbo].[CustomerShipment]

--just validating the answer above
select orderqty from customershipment
order by orderqty desc

--21 Using the Purchase Trans Table , when was the earliest and the last shipping date for transaction
select min([ShipDate]) as EarliestShipDate, max([ShipDate]) as LastShipDate
from [dbo].[PurchaseTrans]

--22 Go back to Exercise 4, what is the sum of all quantity ordered by this supplier
select sum([OrderQty]) as SumOfOrderQty from [dbo].[PurchaseTrans]
where [Supplier] = 'Vargas Garrett'

--23 Exercise 23 what is the total quantity transaction that has carrier tracking number containing the “4343”. Refer Exercise 9
select CarrierTrackingNumber, sum([OrderQty]) as TotalQty
from [dbo].[PurchaseTrans]
where [CarrierTrackingNumber] like '%4343%'
group by CarrierTrackingNumber

-- jUst validating the answer above
select CarrierTrackingNumber, OrderQty
from [dbo].[PurchaseTrans]
where [CarrierTrackingNumber] like '%4343%'

--24 Group all suppliers by the number of transaction they have made till date in the Purchase Trans
select count([TransID]) as TransactionCount, [Supplier]
from PurchaseTrans
group by [Supplier]

--just using this to validate the answer above
select count([TransID]) as TransactionCount, [Supplier]
from PurchaseTrans
where supplier = 'Blythe Michael'
group by [Supplier]

--25 Group all suppliers by the total qty of all orders they made
select Supplier, sum([OrderQty]) as TotalOrdersBySupplier
from PurchaseTrans
group by supplier
order by Supplier asc

--26 List all the count of all transaction by supplier . Which supplier has the largest amount of transaction .
select count(TransID) as TransactionCount, [Supplier]
from PurchaseTrans
group by [Supplier]
order by TransactionCount desc

--The supplier with largest amount of transaction
select top 1 count(TransID) as TransactionCount, [Supplier]
from PurchaseTrans
group by [Supplier]
order by TransactionCount desc

--27 SELECT ProductID, ProductName, ProductNumber INTO PRODUCT_TEMP FROM Product
--What does this command do ? Can you do same for customer shipment table including all the columns
select * INTO CustomerShipment_Temp
from [dbo].[CustomerShipment]

--28 Using the table you created in Exercise 27 , List all the ordered qty, the supplier, Employees, due date, ship date
--and class color for all shipment with carriertracking Number 8551 4CDF A1. How many are they ?
select [OrderQty],[Supplier],[Employee],[DueDate],[ShipDate],[CustomerClass]
from CustomerShipment_Tmp
where  [CarrierTrackingNumber] = '8551-4CDF-A1'

select count([OrderQty]) as CountOfOrder
from CustomerShipment_Tmp
where  [CarrierTrackingNumber] = '8551-4CDF-A1'

--29 You gave the report in Exercise 28 to your boss and he was excited and wants you to do a report that summarises all 
-- the Carrrier Tracking numbers. He will like to have a report that list the tracking number, 
--the sum of all the order quantity per carrier number and the count of all the orders per each carrier tracking number
select [CarrierTrackingNumber], sum([OrderQty]) SumOfOrderQty, count([OrderID]) CountOfOrders
from [dbo].[CustomerShipment_Tmp]
group by [CarrierTrackingNumber]
order by CountOfOrders desc

--30 You came back with the report in Exercise 29 and he wanted more ––(what do you think, the reward of a good job is more work !! Lol).
--So he wanted you to give the same list for only carriers numbers with total ordered item greater than 50. 
--Now he wants to know also the suppliers and employees involved in these shipments. 
--Your report will list supplier, employee, sum of qty orders, count of quantity order
select [CarrierTrackingNumber], [Supplier], [Employee], sum([OrderQty]) as SumOfOrderQty, count([OrderID]) as CountOfOrders
from [dbo].[CustomerShipment_Tmp]
Group by [Supplier], [Employee], [CarrierTrackingNumber]
Having sum([OrderQty]) > 50
order by SumOfOrderQty asc








