--ตัวอย่างวันนี้ใช้ฐานข้อมูล Northwind
--Calculate Column คอลัมน์ที่เกิดจากการคำนวณ

--จงแสดงชื่อเต็มของพนักงานทุกคน   --Alias Name ตั้งเป็นชื่อขึ้นมาใหม่
Select EmployeeID,TitleOfCourtesy+FirstName+' '+LastName [Employee Name]
from Employees
Select EmployeeID,[Employee Name] = TitleOfCourtesy+FirstName+' '+LastName
from Employees

--จงแสดงข้อมูลสินค้าที่มีจำนวนในสต๊อก(UnitsInStock)ต่ำกว่าจำนวนที่ต้องสั่งซื้อ(ReorderLevel)
Select productID,productName,UnitsInStock, ReorderLevel, 
       UnitsInStock-ReorderLevel  Defference
from Products

--จงแสดงรหัสสินค้า ชื่อสินค้า ราคาสินค้า และ ราคาสินค้าที่ปรับขึ้น 10%
select ProductID, ProductName,UnitPrice, 
         Convert(Decimal(10,2),UnitPrice*1.1) NewPrice,
		 Convert(Decimal(10,2),round(UnitPrice*1.1,2)) NewPrice2
from products

--จงแสดงชื่อพนักงาน และจำนวนปีที่ทำงาน (นับจำนวนเป็นปีแบบเต็มปี)
Select EmployeeID,TitleOfCourtesy+FirstName+' '+LastName [Employee Name] , 
       year(getdate()) - year(hiredate) Experience, 
	   year(getdate()) - year(birthdate) Age,
	   DATEDIFF(hour,BirthDate,GETDATE())/8766 AS AgeYearsIntTrunc
from Employees

--จงแสดงชื่อสินค้าเพียง 5 ตัวอักษร และราคาสินค้า
Select productID, left(productName,5) PName, UnitPrice
from Products

--จงแสดงรหัสสินค้า จำนวน ราคา ส่วนลด ยอดเงินเต็ม ส่วนลด(ที่คำนวณแล้ว) ยอดเงินที่หักส่วนลดแล้ว
--จากตาราง [order Details]
--ต้องเอาจำนวณ*ราคาขายก่อนแล้วค่อยหักส่วนลด
select ProductID, Quantity,UnitPrice,Discount, 
       Quantity*UnitPrice TotalCashรวม, 
	   Quantity*UnitPrice*Discount DiscountCashส่วนลด,
	   (Quantity*UnitPrice)-(Quantity*UnitPrice*Discount) NetCashยอดสุดท้าย
from [Order Details]
order by 1, 7 desc
--order by ProductID, NetCashยอดสุดท้าย desc
------------------------------------------------
--Aggregate Function 
Select count(*)
from Products
Where UnitsInStock<15


Select CategoryID,Max(Unitprice), Min(UnitPrice),Avg(UnitPrice), Sum(UnitsInStock)
from Products
group by CategoryID

--ต้องการทราบจำนวนที่ขายได้ทั้งหมดของสินค้าในรายการขายตั้งแต่หมายเลข 11000 เป็นต้นไป
--เลือกมาเฉพาะมียอดขายต่ำกว่า 20 ชิ้น
Select ProductID,Sum(Quantity) จำนวนที่ขายได้
from [Order Details]
where orderID>=11000
group by productID
having Sum(quantity)<20
order by 2 desc

--ต้องการทราบราคาเฉลี่ย ราคาสูงสุด และราคาต่ำสุด ของสินค้าแต่ละหมวดหมู่
Select CategoryID, Avg(UnitPrice), Max(UnitPrice), min(UnitPrice)
from Products
group by categoryID
order by CategoryID
--ต้องการทราบจำนวนลูกค้าในแต่ละประเทศ เฉพาะลูกค้าที่เป็น owner เท่านั้น //แสดงเฉพาะรายการที่มี 1 ราย
Select country,count(*)
from customers
where ContactTitle = 'owner'
group by country
having count(*) =1   --มาเพิ่มทีหลัง
order by Country
--ต้องการทราบจำนวนใบสั่งซื้อ และยอดรวมของค่าส่ง ที่ถูกส่งไปประเทศต่างๆ เฉพาะในปี 1998 
Select ShipCountry,count(*), sum(Freight)
from orders
where year(OrderDate) = 1998
group by ShipCountry
order by 3 desc

-- ต้องการรหัสสินค้า ชื่อสินค้า ราคา รหัสหมวดหมู่ ชื่อหมวดหมู่ เฉพาะหมวดหมู่หมายเลข 2,4,6,8
select productID, ProductName, UnitPrice,p.categoryID, categoryName
from products p, categories c
where (p.CategoryID = c.CategoryID) and (p.categoryID in (2,4,6,8))
order by 4

select productID, ProductName, UnitPrice,p.categoryID, categoryName
from products p join categories c on p.CategoryID = c.CategoryID
where p.categoryID in (2,4,6,8)
order by 4

--ต้องการชื่อพนักงานที่รับคำสั่งซื้อหมายเลข 10275 (แสดงชือพนักงาน รหัสคำสั่งซื้อ วันที่รับคำสั่งซื้อ)
select FirstName, orderID, OrderDate
from orders o join Employees e on o.EmployeeID = e.EmployeeID
where orderID = 10275

--ต้องการข้อมูลสินค้า ประเทศที่มา รหัสหมวดหมู่ ชื่อหมวดหมู่ 
--เฉพาะสินค้าที่มาจากประเทศ USA, Mexico, Canada,Brazil และมีสถานะจำหน่ายสินค้า
select ProductID, ProductName, UnitPrice, s.Country, c.CategoryID , CategoryName

from products p join Categories c on p.CategoryID = c.CategoryID
                join Suppliers s on p.SupplierID = s.SupplierID

where s.Country in ('USA', 'Mexico', 'Canada','Brazil') and Discontinued = 0
order by 4, 5

--จงแสดง รหัสสินค้า ชื่อสินค้า ประเทศที่มาของสินค้า หมวดหมู่สินค้า จำนวนที่ขาย ชื่อลูกค้าผู้ซื้อ 
--ชื่อนามสกุลพนักงานผู้ขาย ชื่อบริษัทขนส่ง ประเทศที่ส่งของ เฉพาะรายการสินค้ารหัส 77 ที่อยู่ในใบสั่งซื้อหมายเลย 11077
select p.ProductID,p.ProductName, s.Country,c.CategoryName, od.Quantity, cu.CompanyName,
       FirstName+' '+LastName EmployeeName, sh.CompanyName, o.ShipCountry
from orders o join [Order Details] od on o.orderID = od.OrderID
			  join products p on p.ProductID = od.ProductID
			  join Categories c on p.CategoryID = c.CategoryID
			  join Suppliers s on p.SupplierID = s.SupplierID
			  join Shippers sh on o.ShipVia = sh.ShipperID
			  join Employees e on o.EmployeeID = e.EmployeeID
			  join customers cu on o.CustomerID = cu.CustomerID
where p.ProductID = 77 and o.OrderID=11077

