-- ===========================================================
-- PROJECT : Motor Insurance Policy Management System
-- DATABASE: MySQL
-- AUTHOR  : Dharanidharan G
-- DESCRIPTION:
-- This project manages customers, vehicles, brokers, policies,
-- payments, claims, endorsements and renewals.
-- It demonstrates SQL concepts including Joins, Aggregate
-- Functions, Group By, Having, Subqueries, Window Functions,
-- Stored Procedures, Functions, Triggers and Indexes.
-- ===========================================================

-- Database Creation
-- This database stores all information related to the Motor
-- Insurance Policy Management System.
-- ===========================================================

CREATE DATABASE motor_insurance_db;
USE motor_insurance_db;

-- ===========================================================
-- Region Table
-- Stores the list of geographical regions used to organize
-- states within the insurance management system.
-- ===========================================================

CREATE TABLE mi_region (
    region_id INT AUTO_INCREMENT PRIMARY KEY,
    region_name VARCHAR(50) NOT NULL UNIQUE
);

-- ===========================================================
-- State Table
-- Stores the states available in each region.
-- Each state is linked to a specific region.
-- ===========================================================

CREATE TABLE mi_state (
    state_id INT AUTO_INCREMENT PRIMARY KEY,
    region_id INT NOT NULL,
    state_name VARCHAR(50) NOT NULL UNIQUE,
    CONSTRAINT fk_state_region 
    FOREIGN KEY (region_id)
	REFERENCES mi_region (region_id)
);

-- ===========================================================
-- City Table
-- Stores city information along with the corresponding state
-- and postal code details.
-- ===========================================================

CREATE TABLE mi_city (
    city_id INT AUTO_INCREMENT PRIMARY KEY,
    state_id INT NOT NULL,
    city_name VARCHAR(50) NOT NULL,
    pincode VARCHAR(10) NOT NULL,
    CONSTRAINT fk_city_state
    FOREIGN KEY (state_id)
    REFERENCES mi_state(state_id)
);

-- ===========================================================
-- Vehicle Make Table
-- Stores different vehicle manufacturers such as Toyota,
-- Honda, Hyundai, Tata and others.
-- ===========================================================

CREATE TABLE mi_vehicle_make (
    make_id INT AUTO_INCREMENT PRIMARY KEY,
    make_name VARCHAR(50) NOT NULL UNIQUE
);

-- ===========================================================
-- Vehicle Model Table
-- Stores vehicle model names associated with each manufacturer.
-- ===========================================================

CREATE TABLE mi_vehicle_model (
    model_id INT AUTO_INCREMENT PRIMARY KEY,
    make_id INT NOT NULL,
    model_name VARCHAR(50) NOT NULL,

    CONSTRAINT fk_model_make
    FOREIGN KEY (make_id)
    REFERENCES mi_vehicle_make(make_id)
);

-- ===========================================================
-- Vehicle Color Table
-- Stores different vehicle color options available.
-- ===========================================================

CREATE TABLE mi_vehicle_color (
    color_id INT AUTO_INCREMENT PRIMARY KEY,
    color_name VARCHAR(30) NOT NULL UNIQUE
);

-- ===========================================================
-- Vehicle Body Table
-- Stores different vehicle body types such as Sedan,
-- Hatchback and SUV.
-- ===========================================================

CREATE TABLE mi_vehicle_body (
    body_id INT AUTO_INCREMENT PRIMARY KEY,
    body_name VARCHAR(50) NOT NULL UNIQUE
);

-- ===========================================================
-- Vehicle Category Table
-- Stores vehicle categories such as Private, Commercial,
-- Two-Wheeler and others.
-- ===========================================================

CREATE TABLE mi_vehicle_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

-- ===========================================================
-- Product Table
-- Stores insurance products and their coverage types.
-- ===========================================================

CREATE TABLE mi_product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    coverage_type VARCHAR(100) NOT NULL
);

-- ===========================================================
-- Premium Rate Table
-- Stores premium rates based on product, vehicle category
-- and vehicle age.
-- ===========================================================

CREATE TABLE mi_premium_rate (
    rate_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    category_id INT NOT NULL,
    vehicle_age_from INT NOT NULL,
    vehicle_age_to INT NOT NULL,
    base_premium DECIMAL(10,2) NOT NULL,
    gst_percentage DECIMAL(5,2) NOT NULL,

    CONSTRAINT fk_rate_product
    FOREIGN KEY (product_id)
    REFERENCES mi_product(product_id),

    CONSTRAINT fk_rate_category
    FOREIGN KEY (category_id)
    REFERENCES mi_vehicle_category(category_id)
);

-- ===========================================================
-- LOV Master Table
-- Stores commonly used list of values used throughout
-- the insurance system.
-- ===========================================================

CREATE TABLE mi_lov_master (
    lov_id INT AUTO_INCREMENT PRIMARY KEY,
    lov_type VARCHAR(50) NOT NULL,
    lov_value VARCHAR(100) NOT NULL
);

-- ===========================================================
-- User Table
-- Stores information about system users such as Admin,
-- Underwriter, Broker and Sales Agent.
-- ===========================================================

CREATE TABLE mi_user (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    user_type VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    gender VARCHAR(10),
    dob DATE,
    email VARCHAR(100) UNIQUE,
    marital_status VARCHAR(30),
    education VARCHAR(50),
    phone VARCHAR(15),
    mobile VARCHAR(15),
    address1 VARCHAR(100),
    address2 VARCHAR(100),
    address3 VARCHAR(100),
    street VARCHAR(100),
    city_id INT,
    state_id INT,
    country VARCHAR(50),
    national_id VARCHAR(20) UNIQUE,
    nationality VARCHAR(50),
    CONSTRAINT fk_user_city
    FOREIGN KEY (city_id)
    REFERENCES mi_city(city_id),
    CONSTRAINT fk_user_state
    FOREIGN KEY (state_id)
    REFERENCES mi_state(state_id)
);

-- ===========================================================
-- Login Table
-- Stores login credentials for authenticated users.
-- ===========================================================

CREATE TABLE mi_login (
    login_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    CONSTRAINT fk_login_user
    FOREIGN KEY (user_id)
    REFERENCES mi_user(user_id)
);

-- ===========================================================
-- Broker Table
-- Stores insurance broker information and organization details.
-- ===========================================================

CREATE TABLE mi_broker (
    broker_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    broker_name VARCHAR(100) NOT NULL,
    organization_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    prepaid_balance DECIMAL(10,2),

    CONSTRAINT fk_broker_user
    FOREIGN KEY (user_id)
    REFERENCES mi_user(user_id)
);

-- ===========================================================
-- Customer Table
-- Stores personal information of insurance customers.
-- ===========================================================

CREATE TABLE mi_customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    gender VARCHAR(10),
    dob DATE,
    mobile VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    address VARCHAR(150),
    city_id INT,
    state_id INT,
    national_id VARCHAR(20) UNIQUE,

    CONSTRAINT fk_customer_city
    FOREIGN KEY (city_id)
    REFERENCES mi_city(city_id),

    CONSTRAINT fk_customer_state
    FOREIGN KEY (state_id)
    REFERENCES mi_state(state_id)
);

-- ===========================================================
-- Vehicle Table
-- Stores customer vehicle details used for insurance policies.
-- ===========================================================

CREATE TABLE mi_vehicle (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    make_id INT NOT NULL,
    model_id INT NOT NULL,
    color_id INT NOT NULL,
    body_id INT NOT NULL,
    category_id INT NOT NULL,
    registration_number VARCHAR(20) NOT NULL UNIQUE,
    engine_number VARCHAR(30) NOT NULL UNIQUE,
    chassis_number VARCHAR(30) NOT NULL UNIQUE,
    manufacture_year YEAR,
    fuel_type VARCHAR(20),
    vehicle_value DECIMAL(12,2),
    CONSTRAINT fk_vehicle_customer
    FOREIGN KEY (customer_id)
    REFERENCES mi_customer(customer_id),
    CONSTRAINT fk_vehicle_make
    FOREIGN KEY (make_id)
    REFERENCES mi_vehicle_make(make_id),
    CONSTRAINT fk_vehicle_model
    FOREIGN KEY (model_id)
    REFERENCES mi_vehicle_model(model_id),

    CONSTRAINT fk_vehicle_color
    FOREIGN KEY (color_id)
    REFERENCES mi_vehicle_color(color_id),

    CONSTRAINT fk_vehicle_body
    FOREIGN KEY (body_id)
    REFERENCES mi_vehicle_body(body_id),

    CONSTRAINT fk_vehicle_category
    FOREIGN KEY (category_id)
    REFERENCES mi_vehicle_category(category_id)
);

-- ===========================================================
-- Quote Table
-- Stores insurance quotation details including premium,
-- tax and total amount.
-- ===========================================================

CREATE TABLE mi_quote (
    quote_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    broker_id INT NOT NULL,
    product_id INT NOT NULL,
    rate_id INT NOT NULL,
    premium_amount DECIMAL(10,2) NOT NULL,
    tax_amount DECIMAL(10,2) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    quote_date DATE,
    
    CONSTRAINT fk_quote_customer
    FOREIGN KEY (customer_id)
    REFERENCES mi_customer(customer_id),

    CONSTRAINT fk_quote_vehicle
    FOREIGN KEY (vehicle_id)
    REFERENCES mi_vehicle(vehicle_id),

    CONSTRAINT fk_quote_broker
    FOREIGN KEY (broker_id)
    REFERENCES mi_broker(broker_id),

    CONSTRAINT fk_quote_product
    FOREIGN KEY (product_id)
    REFERENCES mi_product(product_id),

    CONSTRAINT fk_quote_rate
    FOREIGN KEY (rate_id)
    REFERENCES mi_premium_rate(rate_id)
);

-- ===========================================================
-- Policy Table
-- Stores issued insurance policy information.
-- ===========================================================

CREATE TABLE mi_policy (
    policy_id INT AUTO_INCREMENT PRIMARY KEY,
    quote_id INT NOT NULL,
    policy_number VARCHAR(50) NOT NULL UNIQUE,
    issue_date DATE NOT NULL,
    start_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    policy_status VARCHAR(30) NOT NULL,

    CONSTRAINT fk_policy_quote
    FOREIGN KEY (quote_id)
    REFERENCES mi_quote(quote_id)
);

-- ===========================================================
-- Payment Table
-- Stores payment transactions made for insurance policies.
-- ===========================================================

CREATE TABLE mi_payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT NOT NULL,
    payment_date DATE NOT NULL,
    payment_mode VARCHAR(30) NOT NULL,
    currency VARCHAR(20) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    transaction_id VARCHAR(100) UNIQUE,

    CONSTRAINT fk_payment_policy
    FOREIGN KEY (policy_id)
    REFERENCES mi_policy(policy_id)
);

-- ===========================================================
-- Claim Table
-- Stores insurance claim details submitted by customers.
-- ===========================================================

CREATE TABLE mi_claim (
    claim_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT NOT NULL,
    claim_date DATE NOT NULL,
    claim_amount DECIMAL(10,2) NOT NULL,
    approved_amount DECIMAL(10,2),
    claim_status VARCHAR(30) NOT NULL,
    remarks VARCHAR(255),

    CONSTRAINT fk_claim_policy
    FOREIGN KEY (policy_id)
    REFERENCES mi_policy(policy_id)
);

-- ===========================================================
-- Endorsement Table
-- Stores policy endorsement requests and modifications.
-- ===========================================================

CREATE TABLE mi_endorsement (
    endorsement_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT NOT NULL,
    endorsement_type VARCHAR(100) NOT NULL,
    endorsement_date DATE NOT NULL,
    remarks VARCHAR(255),

    CONSTRAINT fk_endorsement_policy
    FOREIGN KEY (policy_id)
    REFERENCES mi_policy(policy_id)
);

-- ===========================================================
-- Renewal Table
-- Stores policy renewal information and renewal status.
-- ===========================================================

CREATE TABLE mi_renewal (
    renewal_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT NOT NULL,
    renewal_date DATE NOT NULL,
    premium_amount DECIMAL(10,2) NOT NULL,
    expiry_date DATE NOT NULL,
    renewal_status VARCHAR(30) NOT NULL,

    CONSTRAINT fk_renewal_policy
    FOREIGN KEY (policy_id)
    REFERENCES mi_policy(policy_id)
);

-- Insert sample region records into the Region table.
-- These regions are used for customer and user location mapping.

INSERT INTO mi_region(region_name) VALUES
('North'),
('South'),
('East'),
('West'),
('North-East'),
('Central'),
('North-West'),
('South-East'),
('South-West'),
('East-Central'),
('West-Central'),
('Upper North'),
('Lower North'),
('Upper South'),
('Lower South'),
('Hill Region'),
('Coastal Region'),
('Metro Region'),
('Rural Region'),
('Industrial Region'),
('Forest Region'),
('Border Region'),
('Island Region'),
('Union Territory'),
('Special Region');

-- Display all records from the Region table to verify the inserted data.
SELECT * FROM mi_region;


-- Insert sample state records associated with different regions.

INSERT INTO mi_state(region_id,state_name) VALUES
(2,'Tamil Nadu'),
(2,'Kerala'),
(2,'Karnataka'),
(4,'Maharashtra'),
(1,'Delhi'),
(1,'Punjab'),
(3,'West Bengal'),
(3,'Odisha'),
(4,'Gujarat'),
(1,'Haryana'),
(3,'Assam'),
(2,'Telangana'),
(2,'Andhra Pradesh'),
(2,'Goa'),
(1,'Uttar Pradesh'),
(1,'Bihar'),
(1,'Rajasthan'),
(1,'Himachal Pradesh'),
(3,'Sikkim'),
(3,'Tripura'),
(3,'Manipur'),
(3,'Mizoram'),
(3,'Nagaland'),
(4,'Madhya Pradesh'),
(4,'Chhattisgarh');

-- Display all records from the State table to verify the inserted data.
SELECT * FROM mi_state;


-- Insert sample city records used for customer and user addresses.

INSERT INTO mi_city(state_id,city_name,pincode) VALUES
(1,'Chennai','600001'),
(1,'Coimbatore','641001'),
(2,'Kochi','682001'),
(2,'Trivandrum','695001'),
(3,'Bengaluru','560001'),
(3,'Mysuru','570001'),
(4,'Mumbai','400001'),
(4,'Pune','411001'),
(5,'New Delhi','110001'),
(6,'Amritsar','143001'),
(7,'Kolkata','700001'),
(8,'Bhubaneswar','751001'),
(9,'Ahmedabad','380001'),
(10,'Gurgaon','122001'),
(11,'Guwahati','781001'),
(12,'Hyderabad','500001'),
(13,'Visakhapatnam','530001'),
(14,'Panaji','403001'),
(15,'Lucknow','226001'),
(16,'Patna','800001'),
(17,'Jaipur','302001'),
(18,'Shimla','171001'),
(19,'Gangtok','737101'),
(20,'Agartala','799001'),
(21,'Imphal','795001');

-- Display all records from the City table to verify the inserted data.
SELECT * FROM mi_city;


-- Insert sample vehicle manufacturers.

INSERT INTO mi_vehicle_make(make_name) VALUES
('Maruti Suzuki'),
('Hyundai'),
('Tata'),
('Mahindra'),
('Honda'),
('Toyota'),
('Kia'),
('Renault'),
('Nissan'),
('Skoda'),
('Volkswagen'),
('MG'),
('Ford'),
('Jeep'),
('BMW'),
('Audi'),
('Mercedes-Benz'),
('Volvo'),
('Jaguar'),
('Lexus'),
('Isuzu'),
('Force Motors'),
('Ashok Leyland'),
('Eicher'),
('Bajaj');

-- Display all records from the Vehicle Make table to verify the inserted data.
SELECT * FROM mi_vehicle_make;


-- Insert sample vehicle models for each manufacturer.

INSERT INTO mi_vehicle_model(make_id,model_name) VALUES
(1,'Swift'),
(1,'Baleno'),
(2,'i20'),
(2,'Creta'),
(3,'Nexon'),
(3,'Punch'),
(4,'Scorpio'),
(4,'XUV700'),
(5,'City'),
(6,'Innova'),
(7,'Seltos'),
(8,'Kwid'),
(9,'Magnite'),
(10,'Slavia'),
(11,'Virtus'),
(12,'Hector'),
(13,'EcoSport'),
(14,'Compass'),
(15,'X1'),
(16,'A4'),
(17,'C-Class'),
(18,'XC60'),
(19,'XF'),
(20,'ES300h'),
(21,'D-Max');

-- Display all records from the Vehicle Model table to verify the inserted data.
SELECT * FROM mi_vehicle_model;


-- Insert sample vehicle colors.

INSERT INTO mi_vehicle_color(color_name) VALUES
('White'),
('Black'),
('Silver'),
('Grey'),
('Red'),
('Blue'),
('Green'),
('Yellow'),
('Orange'),
('Brown'),
('Golden'),
('Purple'),
('Maroon'),
('Beige'),
('Pearl White'),
('Metallic Silver'),
('Dark Blue'),
('Sky Blue'),
('Wine Red'),
('Champagne'),
('Copper'),
('Ivory'),
('Matte Black'),
('Teal'),
('Olive Green');

-- Display all records from the Vehicle Color table to verify the inserted data.
SELECT * FROM mi_vehicle_color;


-- Insert sample vehicle body types.

INSERT INTO mi_vehicle_body(body_name) VALUES
('Sedan'),
('Hatchback'),
('SUV'),
('MUV'),
('Coupe'),
('Convertible'),
('Pickup'),
('Van'),
('Mini Van'),
('Truck'),
('Bus'),
('Jeep'),
('Wagon'),
('4x4'),
('Tanker'),
('Trailer'),
('Mini Truck'),
('Roadster'),
('Crossover'),
('Limousine'),
('Sports Car'),
('Electric'),
('Hybrid'),
('Luxury'),
('Compact');

-- Display all records from the Vehicle Body table to verify the inserted data.
SELECT * FROM mi_vehicle_body;


-- Insert sample vehicle categories.

INSERT INTO mi_vehicle_category(category_name) VALUES
('Private'),
('Commercial'),
('Taxi'),
('Motorcycle'),
('Sports'),
('Electric'),
('Luxury'),
('Government'),
('School Bus'),
('Ambulance'),
('Goods Carrier'),
('Passenger Vehicle'),
('Rental'),
('Agricultural'),
('Construction'),
('Delivery'),
('Tourist'),
('Police'),
('Fire Service'),
('Military'),
('Vintage'),
('Hybrid'),
('Heavy Vehicle'),
('Light Commercial'),
('Mini Commercial');

-- Display all records from the Vehicle Category table to verify the inserted data.
SELECT * FROM mi_vehicle_category;


-- Insert sample insurance products.

INSERT INTO mi_product(product_name,coverage_type) VALUES
('Comprehensive Basic','Comprehensive'),
('Comprehensive Premium','Comprehensive'),
('Third Party Basic','Third Party'),
('Third Party Premium','Third Party'),
('Zero Depreciation','Add-on'),
('Engine Protect','Add-on'),
('Roadside Assistance','Add-on'),
('Return to Invoice','Add-on'),
('NCB Protect','Add-on'),
('Passenger Cover','Personal Accident'),
('Owner Driver Cover','Personal Accident'),
('Commercial Basic','Commercial'),
('Commercial Premium','Commercial'),
('Taxi Package','Commercial'),
('Bike Basic','Motorcycle'),
('Bike Premium','Motorcycle'),
('Electric Vehicle Cover','Electric'),
('Luxury Car Cover','Luxury'),
('Fleet Insurance','Fleet'),
('Goods Carrier Cover','Commercial'),
('School Bus Cover','Commercial'),
('Tourist Vehicle Cover','Commercial'),
('Fire & Theft Cover','Standalone'),
('Natural Disaster Cover','Standalone'),
('Custom Package','Comprehensive');

-- Display all records from the Product table to verify the inserted data.
SELECT * FROM mi_product;


-- Insert sample premium rate records.

INSERT INTO mi_premium_rate
(product_id,category_id,vehicle_age_from,vehicle_age_to,base_premium,gst_percentage)
VALUES
(1,1,0,5,8000,18),
(2,1,0,5,10000,18),
(3,2,0,5,6000,18),
(4,2,0,5,7500,18),
(5,1,0,10,1200,18),
(6,1,0,10,1000,18),
(7,1,0,10,800,18),
(8,1,0,10,1500,18),
(9,1,0,10,900,18),
(10,1,0,10,1100,18),
(11,1,0,10,950,18),
(12,2,0,5,9000,18),
(13,2,0,5,11000,18),
(14,3,0,5,9500,18),
(15,4,0,5,2500,18),
(16,4,0,5,3200,18),
(17,6,0,5,7000,18),
(18,7,0,5,25000,18),
(19,2,0,5,50000,18),
(20,11,0,5,8500,18),
(21,9,0,5,9000,18),
(22,17,0,5,10000,18),
(23,1,0,10,1500,18),
(24,1,0,10,1700,18),
(25,1,0,10,2000,18);

-- Display all records from the Premium Rate table to verify the inserted data.
SELECT * FROM mi_premium_rate;


-- Insert sample List of Values (LOV).

INSERT INTO mi_lov_master(lov_type,lov_value) VALUES
('Gender','Male'),
('Gender','Female'),
('Gender','Other'),
('Marital Status','Single'),
('Marital Status','Married'),
('Education','BE'),
('Education','BTech'),
('Education','MBA'),
('Education','MCA'),
('User Role','Admin'),
('User Role','Broker'),
('User Role','Underwriter'),
('User Role','Operational User'),
('User Role','Sales Agent'),
('Policy Status','Active'),
('Policy Status','Expired'),
('Claim Status','Pending'),
('Claim Status','Approved'),
('Claim Status','Rejected'),
('Payment Mode','Cash'),
('Payment Mode','UPI'),
('Payment Mode','Credit Card'),
('Payment Mode','Debit Card'),
('Payment Mode','Net Banking'),
('Currency','INR');

SELECT * FROM mi_lov_master;

-- Insert sample user records.

INSERT INTO mi_user
(user_type,first_name,last_name,gender,dob,email,
marital_status,education,phone,mobile,address1,address2,address3,
street,city_id,state_id,country,national_id,nationality)
VALUES
('Admin','Arun','Kumar','Male','1990-01-10','arun1@gmail.com','Married','MBA','0441234561','9876500001','Anna Nagar','','','1st Street',1,1,'India','100000000001','Indian'),

('Broker','Bala','Raj','Male','1992-03-15','bala@gmail.com','Single','BE','0441234562','9876500002','T Nagar','','','2nd Street',2,1,'India','100000000002','Indian'),

('Sales Agent','Chitra','S','Female','1995-06-20','chitra@gmail.com','Single','BTech','0441234563','9876500003','Velachery','','','3rd Street',1,1,'India','100000000003','Indian'),

('Underwriter','Deepak','R','Male','1989-07-11','deepak@gmail.com','Married','MBA','0441234564','9876500004','Adyar','','','4th Street',3,2,'India','100000000004','Indian'),

('Operational User','Esha','K','Female','1994-04-18','esha@gmail.com','Married','MCA','0441234565','9876500005','Tambaram','','','5th Street',4,2,'India','100000000005','Indian'),

('Broker','Farhan','Ali','Male','1991-09-15','farhan@gmail.com','Single','BE','0441234566','9876500006','Mysuru','','','6th Street',6,3,'India','100000000006','Indian'),

('Sales Agent','Ganesh','P','Male','1989-04-05','ganesh@gmail.com','Married','MBA','0441234567','9876500007','Mumbai','','','7th Street',7,4,'India','100000000007','Indian'),

('Underwriter','Harini','V','Female','1994-06-22','harini@gmail.com','Single','MCA','0441234568','9876500008','Pune','','','8th Street',8,4,'India','100000000008','Indian'),

('Operational User','Imran','Khan','Male','1993-11-12','imran@gmail.com','Married','BE','0441234569','9876500009','Delhi','','','9th Street',9,5,'India','100000000009','Indian'),

('Broker','Jaya','Lakshmi','Female','1990-02-28','jaya@gmail.com','Married','MBA','0441234570','9876500010','Amritsar','','','10th Street',10,6,'India','100000000010','Indian'),

('Sales Agent','Karthik','M','Male','1997-07-14','karthik@gmail.com','Single','BTech','0441234571','9876500011','Kolkata','','','11th Street',11,7,'India','100000000011','Indian'),

('Underwriter','Lavanya','R','Female','1992-12-01','lavanya@gmail.com','Single','MCA','0441234572','9876500012','Bhubaneswar','','','12th Street',12,8,'India','100000000012','Indian'),

('Broker','Manoj','Kumar','Male','1987-05-18','manoj@gmail.com','Married','MBA','0441234573','9876500013','Ahmedabad','','','13th Street',13,9,'India','100000000013','Indian'),

('Sales Agent','Nisha','S','Female','1996-09-09','nisha@gmail.com','Single','BE','0441234574','9876500014','Gurgaon','','','14th Street',14,10,'India','100000000014','Indian'),

('Operational User','Prakash','R','Male','1991-03-11','prakash@gmail.com','Married','MBA','0441234575','9876500015','Guwahati','','','15th Street',15,11,'India','100000000015','Indian'),

('Broker','Queen','Mary','Female','1994-04-19','queen@gmail.com','Married','MCA','0441234576','9876500016','Hyderabad','','','16th Street',16,12,'India','100000000016','Indian'),

('Sales Agent','Ravi','Shankar','Male','1993-08-30','ravi@gmail.com','Single','BE','0441234577','9876500017','Visakhapatnam','','','17th Street',17,13,'India','100000000017','Indian'),

('Underwriter','Sneha','Reddy','Female','1995-06-08','sneha@gmail.com','Single','MBA','0441234578','9876500018','Panaji','','','18th Street',18,14,'India','100000000018','Indian'),

('Broker','Tharun','K','Male','1992-10-21','tharun@gmail.com','Married','BE','0441234579','9876500019','Lucknow','','','19th Street',19,15,'India','100000000019','Indian'),

('Sales Agent','Uma','Devi','Female','1990-12-17','uma@gmail.com','Married','MBA','0441234580','9876500020','Patna','','','20th Street',20,16,'India','100000000020','Indian'),

('Operational User','Varun','B','Male','1994-02-13','varun@gmail.com','Single','BTech','0441234581','9876500021','Jaipur','','','21st Street',21,17,'India','100000000021','Indian'),

('Broker','William','John','Male','1989-07-07','william@gmail.com','Married','MBA','0441234582','9876500022','Shimla','','','22nd Street',22,18,'India','100000000022','Indian'),

('Sales Agent','Xavier','Paul','Male','1991-01-30','xavier@gmail.com','Single','BE','0441234583','9876500023','Gangtok','','','23rd Street',23,19,'India','100000000023','Indian'),

('Underwriter','Yamini','K','Female','1996-11-11','yamini@gmail.com','Married','MCA','0441234584','9876500024','Agartala','','','24th Street',24,20,'India','100000000024','Indian'),

('Broker','Zubair','Ahmed','Male','1993-05-24','zubair@gmail.com','Single','MBA','0441234585','9876500025','Imphal','','','25th Street',25,21,'India','100000000025','Indian');


-- Display all records from the User table to verify the inserted data.
SELECT * FROM mi_user;


-- Insert login credentials for system users.

INSERT INTO mi_login (user_id, username, password) VALUES
(1,'admin01','admin@123'),
(2,'broker01','broker@123'),
(3,'agent01','agent@123'),
(4,'underwriter01','under@123'),
(5,'operator01','operator@123'),
(6,'broker02','broker@234'),
(7,'agent02','agent@234'),
(8,'broker03','broker@345'),
(9,'underwriter02','under@345'),
(10,'operator02','operator@345'),
(11,'broker04','broker@456'),
(12,'agent03','agent@456'),
(13,'broker05','broker@567'),
(14,'underwriter03','under@567'),
(15,'operator03','operator@567'),
(16,'broker06','broker@678'),
(17,'agent04','agent@678'),
(18,'broker07','broker@789'),
(19,'underwriter04','under@789'),
(20,'operator04','operator@789'),
(21,'broker08','broker@890'),
(22,'agent05','agent@890'),
(23,'broker09','broker@901'),
(24,'underwriter05','under@901'),
(25,'operator05','operator@901');

-- Display all records from the Login table to verify the inserted data.
SELECT * FROM mi_login;


-- Insert sample broker records.

INSERT INTO mi_broker
(user_id, broker_name, organization_name, email, phone, prepaid_balance)
VALUES
(2,'Ramesh Kumar','ABC Insurance Pvt Ltd','ramesh@abcinsurance.com','9876501001',50000.00),
(6,'Suresh Kumar','XYZ Insurance Pvt Ltd','suresh@xyzinsurance.com','9876501002',65000.00),
(10,'Vijay Kumar','SafeLife Insurance','vijay@safelife.com','9876501003',70000.00),
(13,'Karthik Raj','Prime Insurance','karthik@primeinsurance.com','9876501004',55000.00),
(16,'Arun Prakash','Trust Insurance','arun@trustinsurance.com','9876501005',60000.00),
(19,'Deepak Sharma','National Insurance','deepak@nationalinsurance.com','9876501006',75000.00),
(22,'Hari Krishnan','Elite Insurance','hari@eliteinsurance.com','9876501007',80000.00),
(25,'Praveen Kumar','Royal Insurance','praveen@royalinsurance.com','9876501008',90000.00),
(8,'Vinod Kumar','Secure Insurance','vinod@secureinsurance.com','9876501009',85000.00),
(4,'Anand Raj','Global Insurance','anand@globalinsurance.com','9876501010',95000.00);

-- Display all records from the Broker table to verify the inserted data.
SELECT * FROM mi_broker;


-- Insert sample customer records.

INSERT INTO mi_customer
(first_name, last_name, gender, dob, mobile, email, address, city_id, state_id, national_id)
VALUES
('Rahul','Sharma','Male','1995-06-15','9876543210','rahul@gmail.com','Anna Nagar',1,1,'123456789001'),
('Priya','R','Female','1997-02-20','9876543211','priya@gmail.com','T Nagar',2,1,'123456789002'),
('Karthik','S','Male','1994-08-10','9876543212','karthik@gmail.com','Kochi',3,2,'123456789003'),
('Anitha','M','Female','1996-04-18','9876543213','anitha@gmail.com','Trivandrum',4,2,'123456789004'),
('Vignesh','K','Male','1993-11-25','9876543214','vignesh@gmail.com','Bengaluru',5,3,'123456789005'),
('Divya','P','Female','1998-09-12','9876543215','divya@gmail.com','Mysuru',6,3,'123456789006'),
('Arun','Raj','Male','1992-03-05','9876543216','arunraj@gmail.com','Mumbai',7,4,'123456789007'),
('Meena','S','Female','1995-07-30','9876543217','meena@gmail.com','Pune',8,4,'123456789008'),
('Rakesh','Kumar','Male','1991-01-14','9876543218','rakesh@gmail.com','Delhi',9,5,'123456789009'),
('Sneha','Reddy','Female','1997-10-21','9876543219','sneha@gmail.com','Amritsar',10,6,'123456789010'),
('Manoj','P','Male','1990-12-11','9876543220','manoj@gmail.com','Kolkata',11,7,'123456789011'),
('Lakshmi','Devi','Female','1994-05-08','9876543221','lakshmi@gmail.com','Bhubaneswar',12,8,'123456789012'),
('Suresh','Babu','Male','1993-06-22','9876543222','suresh@gmail.com','Ahmedabad',13,9,'123456789013'),
('Nisha','K','Female','1998-03-17','9876543223','nisha@gmail.com','Gurgaon',14,10,'123456789014'),
('Harish','M','Male','1992-09-28','9876543224','harish@gmail.com','Hyderabad',16,12,'123456789015');

-- Display all records from the Customer table to verify the inserted data.
SELECT * FROM mi_customer;


-- Insert sample vehicle records.

INSERT INTO mi_vehicle
(customer_id, make_id, model_id, color_id, body_id, category_id,
registration_number, engine_number, chassis_number,
manufacture_year, fuel_type, vehicle_value)
VALUES
(1,1,1,1,1,1,'TN01AB1001','ENG1001','CHS1001',2022,'Petrol',850000.00),
(2,1,2,2,2,1,'TN02CD1002','ENG1002','CHS1002',2023,'Petrol',950000.00),
(3,2,3,3,3,1,'KL01EF1003','ENG1003','CHS1003',2021,'Diesel',1200000.00),
(4,2,4,4,3,1,'KL02GH1004','ENG1004','CHS1004',2024,'Petrol',1800000.00),
(5,3,5,5,3,1,'KA01IJ1005','ENG1005','CHS1005',2023,'Diesel',1400000.00),
(6,3,6,6,2,1,'KA02KL1006','ENG1006','CHS1006',2022,'Petrol',900000.00),
(7,4,7,1,12,1,'MH01MN1007','ENG1007','CHS1007',2021,'Diesel',1750000.00),
(8,4,8,2,3,1,'MH02OP1008','ENG1008','CHS1008',2024,'Petrol',2400000.00),
(9,5,9,3,1,1,'DL01QR1009','ENG1009','CHS1009',2023,'Hybrid',1600000.00),
(10,6,10,4,4,2,'PB01ST1010','ENG1010','CHS1010',2022,'Diesel',2600000.00),
(11,7,11,5,19,1,'WB01UV1011','ENG1011','CHS1011',2024,'Petrol',1850000.00),
(12,8,12,6,2,1,'OD01WX1012','ENG1012','CHS1012',2021,'Petrol',700000.00),
(13,9,13,7,3,1,'GJ01YZ1013','ENG1013','CHS1013',2023,'Petrol',850000.00),
(14,10,14,8,1,1,'HR01AA1014','ENG1014','CHS1014',2022,'Petrol',1550000.00),
(15,11,15,9,1,1,'AS01BB1015','ENG1015','CHS1015',2024,'Petrol',1700000.00);

-- Display all records from the Vehicle table to verify the inserted data.
SELECT * FROM mi_vehicle;


-- Insert sample insurance quote records.

INSERT INTO mi_quote
(customer_id, vehicle_id, broker_id, product_id, rate_id,
premium_amount, tax_amount, total_amount, quote_date)
VALUES
(1,1,1,1,1,8000.00,1440.00,9440.00,'2026-07-01'),
(2,2,2,2,2,10000.00,1800.00,11800.00,'2026-07-02'),
(3,3,3,3,3,6000.00,1080.00,7080.00,'2026-07-03'),
(4,4,4,4,4,7500.00,1350.00,8850.00,'2026-07-04'),
(5,5,5,5,5,1200.00,216.00,1416.00,'2026-07-05'),
(6,6,6,6,6,1000.00,180.00,1180.00,'2026-07-06'),
(7,7,7,7,7,800.00,144.00,944.00,'2026-07-07'),
(8,8,8,8,8,1500.00,270.00,1770.00,'2026-07-08'),
(9,9,9,9,9,900.00,162.00,1062.00,'2026-07-09'),
(10,10,10,10,10,1100.00,198.00,1298.00,'2026-07-10'),
(11,11,1,1,1,8000.00,1440.00,9440.00,'2026-07-11'),
(12,12,2,2,2,10000.00,1800.00,11800.00,'2026-07-12'),
(13,13,3,3,3,6000.00,1080.00,7080.00,'2026-07-13'),
(14,14,4,4,4,7500.00,1350.00,8850.00,'2026-07-14'),
(15,15,5,5,5,1200.00,216.00,1416.00,'2026-07-15');

-- Display all records from the Quote table to verify the inserted data.
SELECT * FROM mi_quote;


-- Insert sample insurance policy records.

INSERT INTO mi_policy
(quote_id, policy_number, issue_date, start_date, expiry_date, policy_status)
VALUES
(16,'POL2026001','2026-07-01','2026-07-01','2027-06-30','Active'),
(17,'POL2026002','2026-07-02','2026-07-02','2027-07-01','Active'),
(18,'POL2026003','2026-07-03','2026-07-03','2027-07-02','Active'),
(19,'POL2026004','2026-07-04','2026-07-04','2027-07-03','Active'),
(20,'POL2026005','2026-07-05','2026-07-05','2027-07-04','Active'),
(21,'POL2026006','2026-07-06','2026-07-06','2027-07-05','Active'),
(22,'POL2026007','2026-07-07','2026-07-07','2027-07-06','Active'),
(23,'POL2026008','2026-07-08','2026-07-08','2027-07-07','Active'),
(24,'POL2026009','2026-07-09','2026-07-09','2027-07-08','Active'),
(25,'POL2026010','2026-07-10','2026-07-10','2027-07-09','Active'),
(26,'POL2026011','2026-07-11','2026-07-11','2027-07-10','Active'),
(27,'POL2026012','2026-07-12','2026-07-12','2027-07-11','Active'),
(28,'POL2026013','2026-07-13','2026-07-13','2027-07-12','Active'),
(29,'POL2026014','2026-07-14','2026-07-14','2027-07-13','Active'),
(30,'POL2026015','2026-07-15','2026-07-15','2027-07-14','Active');

-- Display all records from the Policy table to verify the inserted data.
SELECT * FROM mi_policy;


-- Insert sample payment records.

INSERT INTO mi_payment
(policy_id, payment_date, payment_mode, currency, amount, transaction_id)
VALUES
(11,'2026-07-01','UPI','INR',9440.00,'TXN100001'),
(12,'2026-07-02','Credit Card','INR',11800.00,'TXN100002'),
(13,'2026-07-03','Debit Card','INR',7080.00,'TXN100003'),
(14,'2026-07-04','Net Banking','INR',8850.00,'TXN100004'),
(15,'2026-07-05','UPI','INR',1416.00,'TXN100005'),
(16,'2026-07-06','Cash','INR',1180.00,'TXN100006'),
(17,'2026-07-07','Credit Card','INR',944.00,'TXN100007'),
(18,'2026-07-08','UPI','INR',1770.00,'TXN100008'),
(19,'2026-07-09','Debit Card','INR',1062.00,'TXN100009'),
(20,'2026-07-10','Net Banking','INR',1298.00,'TXN100010'),
(21,'2026-07-11','UPI','INR',9440.00,'TXN100011'),
(22,'2026-07-12','Credit Card','INR',11800.00,'TXN100012'),
(23,'2026-07-13','Debit Card','INR',7080.00,'TXN100013'),
(24,'2026-07-14','Net Banking','INR',8850.00,'TXN100014'),
(25,'2026-07-15','UPI','INR',1416.00,'TXN100015');

-- Display all records from the Payment table to verify the inserted data
SELECT * FROM mi_payment;


-- Insert sample claim records.

INSERT INTO mi_claim
(policy_id, claim_date, claim_amount, approved_amount, claim_status, remarks)
VALUES
(11,'2026-08-10',15000.00,12000.00,'Approved','Front bumper damage'),
(12,'2026-08-15',8000.00,8000.00,'Approved','Windshield replacement'),
(13,'2026-08-18',5000.00,0.00,'Rejected','Policy terms not satisfied'),
(14,'2026-08-20',12000.00,10000.00,'Approved','Minor accident'),
(15,'2026-08-22',7000.00,7000.00,'Approved','Door repair'),
(16,'2026-08-25',25000.00,20000.00,'Approved','Engine damage'),
(17,'2026-08-28',6000.00,0.00,'Pending','Verification in progress'),
(18,'2026-09-01',10000.00,9000.00,'Approved','Tyre replacement'),
(19,'2026-09-05',18000.00,15000.00,'Approved','Rear collision'),
(20,'2026-09-10',4000.00,4000.00,'Approved','Mirror replacement'),
(21,'2026-09-12',22000.00,18000.00,'Approved','Flood damage'),
(22,'2026-09-15',9000.00,9000.00,'Approved','Glass damage'),
(23,'2026-09-18',30000.00,0.00,'Rejected','Insufficient documents'),
(24,'2026-09-20',11000.00,10000.00,'Approved','Side panel repair'),
(25,'2026-09-25',7500.00,7500.00,'Approved','Headlight replacement');

-- Display all records from the Claim table to verify the inserted data.
SELECT * FROM mi_claim;


-- Insert sample endorsement records.

INSERT INTO mi_endorsement
(policy_id, endorsement_type, endorsement_date, remarks)
VALUES
(11,'Address Change','2026-08-05','Customer address updated'),
(12,'Nominee Change','2026-08-08','Nominee details modified'),
(13,'Vehicle Color Change','2026-08-12','Vehicle repainted'),
(14,'Engine Update','2026-08-15','Engine number corrected'),
(15,'Registration Update','2026-08-18','Registration details updated'),
(16,'Add Driver','2026-08-20','Additional driver added'),
(17,'Remove Driver','2026-08-23','Driver removed from policy'),
(18,'Fuel Type Change','2026-08-25','Fuel type updated'),
(19,'Coverage Upgrade','2026-08-28','Comprehensive cover added'),
(20,'IDV Revision','2026-09-01','Insured value revised'),
(21,'Address Change','2026-09-04','Permanent address updated'),
(22,'Contact Update','2026-09-08','Mobile number updated'),
(23,'Policy Correction','2026-09-12','Name spelling corrected'),
(24,'Add Accessory Cover','2026-09-15','Music system insured'),
(25,'NCB Update','2026-09-20','No Claim Bonus updated');

-- Display all records from the Endorsement table to verify the inserted data.
SELECT * FROM mi_endorsement;


-- Insert sample renewal records.

INSERT INTO mi_renewal
(policy_id, renewal_date, premium_amount, expiry_date, renewal_status)
VALUES
(11,'2027-06-20',9500.00,'2028-06-30','Renewed'),
(12,'2027-06-22',11850.00,'2028-07-01','Renewed'),
(13,'2027-06-24',7200.00,'2028-07-02','Pending'),
(14,'2027-06-26',8900.00,'2028-07-03','Renewed'),
(15,'2027-06-28',1500.00,'2028-07-04','Renewed'),
(16,'2027-06-30',1250.00,'2028-07-05','Pending'),
(17,'2027-07-02',980.00,'2028-07-06','Renewed'),
(18,'2027-07-04',1850.00,'2028-07-07','Renewed'),
(19,'2027-07-06',1150.00,'2028-07-08','Renewed'),
(20,'2027-07-08',1400.00,'2028-07-09','Pending'),
(21,'2027-07-10',9600.00,'2028-07-10','Renewed'),
(22,'2027-07-12',11900.00,'2028-07-11','Renewed'),
(23,'2027-07-14',7300.00,'2028-07-12','Pending'),
(24,'2027-07-16',9050.00,'2028-07-13','Renewed'),
(25,'2027-07-18',1550.00,'2028-07-14','Renewed');

-- Display all records from the Renewal table to verify the inserted data.
SELECT * FROM mi_renewal;



-- ===========================================================
-- Scenario Query 1
-- Display complete customer details along with vehicle,
-- broker and policy information.
-- Concepts Used: INNER JOIN
-- ===========================================================

SELECT
    c.first_name,
    c.last_name,
    v.registration_number,
    b.broker_name,
    p.policy_number,
    p.policy_status
FROM mi_customer c
INNER JOIN mi_vehicle v
ON c.customer_id = v.customer_id
INNER JOIN mi_quote q
ON v.vehicle_id = q.vehicle_id
INNER JOIN mi_broker b
ON q.broker_id = b.broker_id
INNER JOIN mi_policy p
ON q.quote_id = p.quote_id;


-- ===========================================================
-- Scenario Query 2
-- Calculate the total premium collected by each broker.
-- Concepts Used: SUM(), GROUP BY
-- ===========================================================
SELECT
    b.broker_name,
    SUM(q.premium_amount) AS Total_Premium
FROM mi_broker b
INNER JOIN mi_quote q
ON b.broker_id = q.broker_id
GROUP BY b.broker_name;


-- ===========================================================
-- Scenario Query 3
-- Display brokers who have handled more than one policy.
-- Concepts Used: COUNT(), GROUP BY, HAVING
-- ===========================================================
SELECT
    b.broker_name,
    COUNT(p.policy_id) AS Total_Policies
FROM mi_broker b
INNER JOIN mi_quote q
ON b.broker_id = q.broker_id
INNER JOIN mi_policy p
ON q.quote_id = p.quote_id
GROUP BY b.broker_name
HAVING COUNT(p.policy_id) > 1;


-- ===========================================================
-- Scenario Query 4
-- Display customers whose total premium paid is greater than
-- the average premium amount.
-- Concepts Used: SUM(), GROUP BY, HAVING, Subquery
-- ===========================================================
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS Customer_Name,
    SUM(q.premium_amount) AS Total_Premium
FROM mi_customer c
INNER JOIN mi_quote q
ON c.customer_id = q.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(q.premium_amount) >
(
    SELECT AVG(premium_amount)
    FROM mi_quote
);


-- ===========================================================
-- Scenario Query 5
-- Display complete vehicle details along with owner
-- and vehicle specifications.
-- Concepts Used: INNER JOIN
-- ===========================================================
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS Customer_Name,
    v.registration_number,
    vm.make_name,
    mdl.model_name,
    clr.color_name,
    bd.body_name,
    cat.category_name,
    v.manufacture_year,
    v.fuel_type,
    v.vehicle_value
FROM mi_vehicle v
INNER JOIN mi_customer c
    ON v.customer_id = c.customer_id
INNER JOIN mi_vehicle_make vm
    ON v.make_id = vm.make_id
INNER JOIN mi_vehicle_model mdl
    ON v.model_id = mdl.model_id
INNER JOIN mi_vehicle_color clr
    ON v.color_id = clr.color_id
INNER JOIN mi_vehicle_body bd
    ON v.body_id = bd.body_id
INNER JOIN mi_vehicle_category cat
    ON v.category_id = cat.category_id;
    
    
-- ===========================================================
-- Scenario Query 6
-- Display customers whose insurance claim status is Pending.
-- Concepts Used: INNER JOIN, WHERE
-- ===========================================================
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS Customer_Name,
    p.policy_number,
    cl.claim_id,
    cl.claim_date,
    cl.claim_amount,
    cl.claim_status
FROM mi_customer c
INNER JOIN mi_vehicle v
    ON c.customer_id = v.customer_id
INNER JOIN mi_quote q
    ON v.vehicle_id = q.vehicle_id
INNER JOIN mi_policy p
    ON q.quote_id = p.quote_id
INNER JOIN mi_claim cl
    ON p.policy_id = cl.policy_id
WHERE cl.claim_status = 'Pending';


-- ===========================================================
-- Scenario Query 7
-- Display all policies that expire between 01-Jun-2027 and 31-Jul-2027..
-- Concepts Used: BETWEEN, Date Functions
-- ===========================================================
SELECT
    policy_number,
    issue_date,
    start_date,
    expiry_date,
    policy_status
FROM mi_policy
WHERE expiry_date BETWEEN '2027-06-01' AND '2027-07-31';


-- ===========================================================
-- Scenario Query 8
-- Display customers whose policy renewal status is Renewed.
-- Concepts Used: INNER JOIN, WHERE
-- ===========================================================
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS Customer_Name,
    p.policy_number,
    r.renewal_date,
    r.renewal_status
FROM mi_customer c
INNER JOIN mi_vehicle v
    ON c.customer_id = v.customer_id
INNER JOIN mi_quote q
    ON v.vehicle_id = q.vehicle_id
INNER JOIN mi_policy p
    ON q.quote_id = p.quote_id
INNER JOIN mi_renewal r
    ON p.policy_id = r.policy_id
WHERE r.renewal_status = 'Renewed';


-- ===========================================================
-- Scenario Query 9
-- Count the total number of policies handled by each broker.
-- Concepts Used: COUNT(), GROUP BY, ORDER BY
-- ===========================================================
SELECT
    b.broker_id,
    b.broker_name,
    COUNT(p.policy_id) AS Total_Policies
FROM mi_broker b
INNER JOIN mi_quote q
    ON b.broker_id = q.broker_id
INNER JOIN mi_policy p
    ON q.quote_id = p.quote_id
GROUP BY
    b.broker_id,
    b.broker_name
ORDER BY Total_Policies DESC;



-- ===========================================================
-- Scenario Query 10
-- Display customer along with their claim status.
-- Concepts Used: INNER JOIN
-- ===========================================================
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS Customer_Name,
    p.policy_number,
    cl.claim_status
FROM mi_customer c
INNER JOIN mi_vehicle v
    ON c.customer_id = v.customer_id
INNER JOIN mi_quote q
    ON v.vehicle_id = q.vehicle_id
INNER JOIN mi_policy p
    ON q.quote_id = p.quote_id
INNER JOIN mi_claim cl
    ON p.policy_id = cl.policy_id;
    

-- ===========================================================
-- Scenario Query 11
-- Rank customers based on the premium amount paid.
-- Concepts Used: RANK() Analytical Function
-- ===========================================================
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS Customer_Name,
    q.premium_amount,
    RANK() OVER (ORDER BY q.premium_amount DESC) AS Premium_Rank
FROM mi_customer c
INNER JOIN mi_quote q
ON c.customer_id = q.customer_id;



-- ===========================================================
-- Scenario Query 12
-- Display the latest policy issued for each customer.
-- Concepts Used: ROW_NUMBER(), PARTITION BY
-- ===========================================================
SELECT
    Customer_ID,
    Customer_Name,
    Policy_Number,
    Issue_Date
FROM
(
    SELECT
        c.customer_id AS Customer_ID,
        CONCAT(c.first_name,' ',c.last_name) AS Customer_Name,
        p.policy_number AS Policy_Number,
        p.issue_date AS Issue_Date,
        ROW_NUMBER() OVER
        (
            PARTITION BY c.customer_id
            ORDER BY p.issue_date DESC
        ) AS Row_Num
    FROM mi_customer c
    INNER JOIN mi_vehicle v
        ON c.customer_id = v.customer_id
    INNER JOIN mi_quote q
        ON v.vehicle_id = q.vehicle_id
    INNER JOIN mi_policy p
        ON q.quote_id = p.quote_id
) AS Latest_Policy
WHERE Row_Num = 1;



-- ===========================================================
-- Scenario Query 13
-- Display customers whose premium amount is greater than
-- the average premium amount.
-- Concepts Used: AVG(), Subquery
-- ===========================================================
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS Customer_Name,
    q.premium_amount
FROM mi_customer c
INNER JOIN mi_quote q
ON c.customer_id = q.customer_id
WHERE q.premium_amount >
(
    SELECT AVG(premium_amount)
    FROM mi_quote
)
ORDER BY q.premium_amount DESC;



-- ===========================================================
-- Scenario Query 14
-- Display payment modes whose total collection is greater
-- than ₹10,000.
-- Concepts Used: SUM(), GROUP BY, HAVING
-- ===========================================================
SELECT
    payment_mode,
    SUM(amount) AS Total_Amount_Collected
FROM mi_payment
GROUP BY payment_mode
HAVING SUM(amount) > 10000
ORDER BY Total_Amount_Collected DESC;



-- ===========================================================
-- Scenario Query 15
-- Display the total number of vehicles available in each
-- vehicle category.
-- Concepts Used: COUNT(), GROUP BY, HAVING, INNER JOIN
-- ===========================================================
SELECT
    vc.category_name,
    COUNT(v.vehicle_id) AS Total_Vehicles
FROM mi_vehicle_category vc
INNER JOIN mi_vehicle v
ON vc.category_id = v.category_id
GROUP BY vc.category_name
HAVING COUNT(v.vehicle_id) >= 1
ORDER BY Total_Vehicles DESC;



-- ===========================================================
-- Scenario Query 16
-- Create a Stored Procedure to display complete insurance details 
-- of a customer using Customer ID.
-- ===========================================================
DELIMITER $$

CREATE PROCEDURE GetCustomerInsuranceDetails(IN p_customer_id INT)
BEGIN
    SELECT
        c.customer_id,
        CONCAT(c.first_name,' ',c.last_name) AS Customer_Name,
        v.registration_number,
        b.broker_name,
        p.policy_number,
        p.policy_status
    FROM mi_customer c
    INNER JOIN mi_vehicle v
        ON c.customer_id=v.customer_id
    INNER JOIN mi_quote q
        ON v.vehicle_id=q.vehicle_id
    INNER JOIN mi_broker b
        ON q.broker_id=b.broker_id
    INNER JOIN mi_policy p
        ON q.quote_id=p.quote_id
    WHERE c.customer_id=p_customer_id;
END$$

DELIMITER ;

CALL GetCustomerInsuranceDetails(1);





-- ===========================================================
-- Scenario Query 17
-- Create a Stored Procedure to update the claim status using Claim ID.
-- ===========================================================
DELIMITER $$

CREATE PROCEDURE UpdateClaimStatus
(
    IN p_claim_id INT,
    IN p_status VARCHAR(20)
)
BEGIN
    UPDATE mi_claim
    SET claim_status = p_status
    WHERE claim_id = p_claim_id;
END$$

DELIMITER ;

CALL UpdateClaimStatus(1,'Approved');




-- ===========================================================
-- Scenario Query 18
-- Create a User Defined Function to calculate GST (18%) on 
-- the premium amount.
-- ===========================================================

DELIMITER $$

CREATE FUNCTION CalculateGST
(
    premium DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)

DETERMINISTIC

BEGIN

DECLARE gst DECIMAL(10,2);

SET gst = premium * 0.18;

RETURN gst;

END$$

DELIMITER ;

SELECT
premium_amount,
CalculateGST(premium_amount) AS GST
FROM mi_quote;



-- ===========================================================
-- Scenario Query 19
-- Create a User Defined Function to calculate the vehicle age.
-- ===========================================================

DELIMITER $$

CREATE FUNCTION VehicleAge
(
    mfg_year INT
)
RETURNS INT

DETERMINISTIC

BEGIN

RETURN YEAR(CURDATE()) - mfg_year;

END$$

DELIMITER ;

SELECT
registration_number,
manufacture_year,
VehicleAge(manufacture_year) AS Vehicle_Age
FROM mi_vehicle;


-- ===========================================================
-- Scenario Query 20
-- Create a Trigger to automatically update the renewal status 
-- to 'Renewed' whenever a new payment is inserted and create 
-- an Index on the policy number column.
-- Trigger
-- Automatically update the renewal status after
-- a payment is successfully inserted.
-- ===========================================================
DELIMITER $$

CREATE TRIGGER trg_update_renewal
AFTER INSERT
ON mi_payment
FOR EACH ROW

BEGIN

UPDATE mi_renewal
SET renewal_status='Renewed'
WHERE policy_id=NEW.policy_id;

END$$

DELIMITER ;

INSERT INTO mi_payment
(policy_id,payment_date,payment_mode,currency,amount,transaction_id)
VALUES
(11,'2027-06-25','UPI','INR',9500,'TXN200001');

-- ===========================================================
-- Index
-- Create an index on the policy_number column
-- to improve search performance.
-- ===========================================================
CREATE INDEX idx_policy_number
ON mi_policy(policy_number);

SHOW INDEX FROM mi_policy;