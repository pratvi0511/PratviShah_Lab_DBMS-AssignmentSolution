#Creating the database
CREATE DATABASE E_Commerce;

#Using the database
USE E_Commerce;

#Supplier Table
CREATE TABLE IF NOT EXISTS `Supplier`(
 `SUPP_ID` INT NOT NULL,
 `SUPP_NAME` VARCHAR(20) NULL DEFAULT NULL,
 `SUPP_CITY` VARCHAR(30),
 `SUPP_PHONE` VARCHAR(10),
 PRIMARY KEY (`SUPP_ID`));
 
 INSERT INTO `Supplier` VALUES(1,"Rajesh Retails","Delhi",1234567890);
 INSERT INTO `Supplier` VALUES(2,"Appario Ltd.","Mumbai",2589631470);
 INSERT INTO `Supplier` VALUES(3,"Knome products","Banglore",9785462315);
 INSERT INTO `Supplier` VALUES(4,"Bansal Retails","Kochi",8975463285);
 INSERT INTO `Supplier` VALUES(5,"Mittal Ltd.","Lucknow",7898456532);
 #SELECT * FROM Supplier;
 
 #Customer Table
CREATE TABLE IF NOT EXISTS `Customer`(
 `CUS_ID` INT NOT NULL,
 `CUS_NAME` VARCHAR(20) NULL DEFAULT NULL,
 `CUS_PHONE` VARCHAR(10),
 `CUS_CITY` VARCHAR(30),
 `CUS_GENDER` CHAR,
 PRIMARY KEY (`CUS_ID`));
 
INSERT INTO `Customer` VALUES(1,"AAKASH",'9999999999',"DELHI",'M');
INSERT INTO `Customer` VALUES(2,"AMAN",'9785463215',"NOIDA",'M');
INSERT INTO `Customer` VALUES(3,"NEHA",'9999999999',"MUMBAI",'F');
INSERT INTO `Customer` VALUES(4,"MEGHA",'9994562399',"KOLKATA",'F');
INSERT INTO `Customer` VALUES(5,"PULKIT",'7895999999',"LUCKNOW",'M');
#SELECT * FROM Customer;

#Category Table
CREATE TABLE IF NOT EXISTS `Category`(
 `CAT_ID` INT NOT NULL,
 `CAT_NAME` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`CAT_ID`));
  
INSERT INTO `Category` VALUES(1,"BOOKS");
INSERT INTO `Category` VALUES(2,"GAMES");
INSERT INTO `Category` VALUES(3,"GROCERIES");
INSERT INTO `Category` VALUES(4,"ELECTRONICS");
INSERT INTO `Category` VALUES(5,"CLOTHES");
#SELECT * FROM Category;

#Product Table
CREATE TABLE IF NOT EXISTS `Product`(
 `PRO_ID` INT NOT NULL,
 `PRO_NAME` VARCHAR(20) NULL DEFAULT NULL,
 `PRO_DESC` VARCHAR(60) NULL DEFAULT NULL,
 `CAT_ID` INT NOT NULL,
 PRIMARY KEY (`PRO_ID`),
 FOREIGN KEY (`CAT_ID`) REFERENCES Category (`CAT_ID`));
 
INSERT INTO Product VALUES(1,"GTA V","DFJDJFDJFDJFDJFJF",2);
INSERT INTO Product VALUES(2,"TSHIRT","DFDFJDFJDKFD",5);
INSERT INTO Product VALUES(3,"ROG LAPTOP","DFNTTNTNTERND",4);
INSERT INTO Product VALUES(4,"OATS","REURENTBTOTH",3);
INSERT INTO Product VALUES(5,"HARRY POTTER","NBEMCTHTJTH",1);
#SELECT * FROM Product;

#Product_Details Table
CREATE TABLE IF NOT EXISTS `Product_Details`(
 `PROD_ID` INT NOT NULL,
 `PRO_ID` INT NOT NULL,
 `SUPP_ID` INT NOT NULL,
 `PROD_PRICE` INT NOT NULL,
 PRIMARY KEY (`PROD_ID`),
 FOREIGN KEY (`PRO_ID`) REFERENCES Product (`PRO_ID`),
 FOREIGN KEY (`SUPP_ID`) REFERENCES Supplier (`SUPP_ID`));
 
INSERT INTO `Product_Details` VALUES(1,1,2,1500);
INSERT INTO `Product_Details` VALUES(2,3,5,30000);
INSERT INTO `Product_Details` VALUES(3,5,1,3000);
INSERT INTO `Product_Details` VALUES(4,2,3,2500);
INSERT INTO `Product_Details` VALUES(5,4,1,1000);
#SELECT * FROM Product_Details;

#Order Table
CREATE TABLE IF NOT EXISTS `Order`(
 `ORD_ID` INT NOT NULL,
 `ORD_AMOUNT` INT NOT NULL,
 `ORD_DATE` DATE,
 `CUS_ID` INT NOT NULL,
 `PROD_ID` INT NOT NULL,
 PRIMARY KEY (`ORD_ID`),
 FOREIGN KEY (`PROD_ID`) REFERENCES Product_Details (`PROD_ID`),
 FOREIGN KEY (`CUS_ID`) REFERENCES Customer (`CUS_ID`));
 
INSERT INTO `Order` VALUES(20,1500,"2021-10-12",3,5);
INSERT INTO `Order` VALUES(25,30500,"2021-09-16",5,2);
INSERT INTO `Order` VALUES(26,2000,"2021-10-05",1,1);
INSERT INTO `Order` VALUES(30,3500,"2021-08-16",4,3);
INSERT INTO `Order` VALUES(50,2000,"2021-10-06",2,1);
#SELECT * FROM `Order`;

#Rating Table
CREATE TABLE IF NOT EXISTS `Rating`(
 `RAT_ID` INT NOT NULL,
 `CUS_ID` INT NOT NULL,
 `SUPP_ID` INT NOT NULL,
 `RAT_RATSTARS` INT NOT NULL,
 PRIMARY KEY (`RAT_ID`),
 FOREIGN KEY (`CUS_ID`) REFERENCES Customer (`CUS_ID`),
 FOREIGN KEY (`SUPP_ID`) REFERENCES Supplier (`SUPP_ID`));
 
INSERT INTO `Rating` VALUES(1,2,2,4);
INSERT INTO `Rating` VALUES(2,3,4,3);
INSERT INTO `Rating` VALUES(3,5,1,5);
INSERT INTO `Rating` VALUES(4,1,3,2);
INSERT INTO `Rating` VALUES(5,4,5,4);
#SELECT * FROM Rating;

#Query 3: Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.
SELECT `Customer`.CUS_GENDER, COUNT(`Customer`.CUS_GENDER) AS Count 
FROM `Customer` INNER JOIN `Order` on `Customer`.CUS_ID = `Order`.CUS_ID
WHERE `Order`.ORD_AMOUNT >= 3000
GROUP BY `Customer`.CUS_GENDER;

#Query 4: Display all the orders along with the product name ordered by a customer having Customer_Id=2.
SELECT `Order`.*, `Product`.PRO_NAME 
FROM `Order`, `Product_Details`, `Product`
WHERE `Order`.PROD_ID = `Product_Details`.PROD_ID 
AND `Product_Details`.PRO_ID = `Product`.PRO_ID 
AND `Order`.CUS_ID = 2;

#Query 5: Display the Supplier details who can supply more than one product.
SELECT `Supplier`.*
FROM `Supplier`, `Product_Details`
WHERE `Supplier`.SUPP_ID = `Product_Details`.SUPP_ID
GROUP BY `Product_Details`.SUPP_ID
HAVING COUNT(`Product_Details`.SUPP_ID) > 1;
#OR
SELECT `Supplier`.*
FROM `Supplier`, `Product_Details`
WHERE `Supplier`.SUPP_ID 
IN (
SELECT `Product_Details`.SUPP_ID
FROM `Product_Details`
GROUP BY `Product_Details`.SUPP_ID
HAVING COUNT(`Product_Details`.SUPP_ID) > 1
)
GROUP BY `Supplier`.SUPP_ID;

#Query 6: Find the category of the product whose order amount is minimum.
SELECT `Category`.*
FROM `Category`, `Product_Details`, `Product`, `Order`
WHERE `Category`.CAT_ID = `Product`.CAT_ID 
AND `Product`.PRO_ID = `Product_Details`.PRO_ID
AND `Product_Details`.PROD_ID = `Order`.PROD_ID
HAVING MIN(`Order`.ORD_AMOUNT);  
#OR
SELECT `Category`.*
FROM `Order` INNER JOIN `Product_Details` ON `Order`.PROD_ID = `Product_Details`.PROD_ID 
INNER JOIN `Product` ON `Product_Details`.PRO_ID = `Product`.PRO_ID 
INNER JOIN `Category` ON `Product`.CAT_ID = `Category`.CAT_ID 
HAVING MIN(`Order`.ORD_AMOUNT);

#Query 7: Display the Id and Name of the Product ordered after “2021-10-05”.
SELECT `Product`.PRO_ID , `Product`.PRO_NAME 
FROM `Order`, `Product_Details`, `Product`
WHERE `Order`.PROD_ID = `Product_Details`.PROD_ID 
AND `Product_Details`.PRO_ID = `Product`.PRO_ID
AND `Order`.ORD_DATE > "2021-10-05";
#OR
SELECT `Product`.PRO_ID , `Product`.PRO_NAME
FROM `Order` INNER JOIN `Product_Details` ON `Order`.PROD_ID = `Product_Details`.PROD_ID 
INNER JOIN `Product` ON `Product_Details`.PRO_ID = `Product`.PRO_ID 
WHERE `Order`.ORD_DATE > "2021-10-05";

#Query 8: Display customer name and gender whose names start or end with character 'A'.
SELECT `Customer`.CUS_NAME, `Customer`.CUS_GENDER
FROM `Customer`
WHERE `Customer`.CUS_NAME LIKE 'A%' 
OR `Customer`.CUS_NAME LIKE '%A'; 

#Query 9: Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like if rating > 4 then “Genuine Supplier” if rating > 2 “Average Supplier” else “Supplier should not be considered”.
DELIMITER $$
 CREATE PROCEDURE Proc1()
 BEGIN
  SELECT `Supplier`.SUPP_ID, `Supplier`.SUPP_NAME, `Rating`.RAT_RATSTARS,
  CASE
   WHEN `Rating`.RAT_RATSTARS > 4 THEN 'Genuine Supplier'
   WHEN `Rating`.RAT_RATSTARS > 2 THEN 'Average Supplier'
   ELSE 'Supplier should not be considered'
  END
  AS Verdict
  FROM `Supplier` INNER JOIN `Rating`
  ON`Supplier`.SUPP_ID = `Rating`.SUPP_ID;
END $$

CALL Proc1();