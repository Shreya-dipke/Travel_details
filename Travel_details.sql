-- CREATE DATABASE
create database travel;
use travel;

-- CREATE TABLE
create table travel_details (
sr_no int primary key,
Destination varchar(20),
Transportation varchar(50),
Popular_for varchar(50),
Nearby_places varchar(50),
Duration int,
Activities_expenses int,
Total_Expected_Expenses int );

insert into travel_details(sr_no, Destination, Transportation, Popular_for, Nearby_places, Duration, Activities_expenses, Total_Expected_Expenses)
VALUES
(1, 'Goa', 'Flight, Train, Bus', 'Beaches, Nightlife', 'Dudhsagar Falls, Old Goa', 5, 15000, 30000),
(2, 'Jaipur', 'Flight, Train, Bus', 'Palaces, Forts', 'Pushkar, Ajmer', 4, 10000, 20000),
(3, 'Manali', 'Bus, Car, Bike', 'Snow, Adventure Sports', 'Solang Valley, Rohtang Pass', 6, 12000, 25000),
(4, 'Kerala', 'Flight, Train, Bus', 'Backwaters, Beaches', 'Munnar, Thekkady', 7, 14000, 28000),
(5, 'Leh', 'Flight, Bike', 'Monasteries, Trekking', 'Nubra Valley, Pangong Lake', 8, 20000, 40000),
(6, 'Rishikesh', 'Train, Bus', 'River Rafting, Yoga', 'Haridwar, Mussoorie', 3, 8000, 15000),
(7, 'Udaipur', 'Flight, Train, Bus', 'Lakes, Palaces', 'Mount Abu, Chittorgarh', 3, 9000, 18000),
(8, 'Darjeeling', 'Train, Bus', 'Tea Gardens, Toy Train', 'Gangtok, Kalimpong', 5, 10000, 20000),
(9, 'Andaman', 'Flight, Ship', 'Beaches, Scuba Diving', 'Havelock Island, Neil Island', 7, 18000, 35000),
(10, 'Varanasi', 'Train, Bus', 'Ghats, Temples', 'Sarnath, Allahabad', 4, 6000, 12000);

select * from travel_details;


-- SOLO TRIP TABLE
CREATE TABLE SoloTrips (
    trip_id INT PRIMARY KEY,
    destination VARCHAR(100),
    travel_date DATE,
    best_time_to_visit VARCHAR(50),
    expected_expenses DECIMAL(10, 2)
);

INSERT INTO SoloTrips (destination, travel_date, best_time_to_visit, expected_expenses)
VALUES 
(1,'Goa', '2024-12-20', 'November to February', 15000.00),
(2,'Jaipur', '2024-11-01', 'October to March', 8000.00),
(3,'Manali', '2024-08-10', 'October to February', 12000.00),
(4,'Kerala', '2024-01-15', 'September to March', 18000.00),
(5,'Leh', '2024-06-15', 'May to September', 20000.00),
(6,'Rishikesh', '2024-04-10', 'September to November', 7000.00),
(7,'Udaipur', '2024-10-05', 'September to March', 9000.00),
(8,'Darjeeling', '2024-09-20', 'April to June', 13000.00),
(9,'Andaman', '2024-12-01', 'October to May', 25000.00),
(10,'Varanasi', '2024-03-10', 'November to February', 6000.00);

select * from SoloTrip

-- GROUP TRIP TABLE
CREATE TABLE GroupTrips (
    trip_id INT AUTO_INCREMENT PRIMARY KEY,
    destination VARCHAR(100),
    travel_date DATE,
    best_time_to_visit VARCHAR(50),
    expected_expenses DECIMAL(10, 2)
);
INSERT INTO GroupTrip (destination, travel_date, best_time_to_visit, expected_expenses)
VALUES 
('Goa', '2024-12-20', 'November to February', 30000.00),
('Leh', '2024-06-15', 'May to September', 40000.00),
('Manali', '2024-08-10', 'October to February', 24000.00),
('Jaipur', '2024-11-01', 'October to March', 16000.00),
('Kerala', '2024-01-15', 'September to March', 36000.00),
('Rishikesh', '2024-04-10', 'September to November', 14000.00),
('Udaipur', '2024-10-05', 'September to March', 18000.00),
('Darjeeling', '2024-09-20', 'April to June', 26000.00),
('Andaman', '2024-12-01', 'October to May', 50000.00),
('Varanasi', '2024-03-10', 'November to February', 12000.00);

select * from GroupTrips;

-- VIEW TABLE
create view expenses_view as select t.Destination,t.Duration,t.Activities_expenses, s.solo_expenses, g.group_expenses
from travel_detail t
inner join SoloTrips s
on t.id = s.trip_id
inner join GroupTrips g
on t.id = g.trip_id;

select * from expenses_view;

-- STORED PROCEDURE
delimiter //
create procedure get_expenses()
begin
select * from travel_detail where activities_expenses > 12000;
end //

call get_expenses();


-- FUNCTION
delimiter //
CREATE FUNCTION Activities_budget( Duration int, Activities_expenses int)
RETURNS DECIMAL(10, 2)
deterministic
BEGIN
    DECLARE Activity_budget DECIMAL(10, 2);
    SET Activity_budget = Duration * Activities_expenses;
    RETURN Activity_budget;
END//

select duration, activities_expenses,Activities_budget(duration, activities_expenses) as Activity_budget from travel_detail;

-- CREATE TRIGGER

-- USING AFTER INSERT
CREATE TABLE travelling_detail (
    id INT PRIMARY KEY,
    destination VARCHAR(100),
    popular_for VARCHAR(100),
    nearby_places VARCHAR(100),
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

delimiter //
create trigger travel_details_after_insert
after insert on travel_detail
for each row
begin
insert into travelling_detail values(new.id,new.destination, new.popular_for, new.nearby_places,now());
end //

insert into travel_detail values(11, 'Bali', 'Flight','Cultural Experience','Ubud, Kuta',10, 4000,6000);

select * from travelling_detail;

create table update_travel(id int,destination varchar(100),duration int,datechanged datetime,action varchar(100));

-- USING BEFORE UPDATE
delimiter //
create trigger before_travel_update
before update on travel_detail
for each row
begin
insert into update_travel
set action="update",
id = old.id,
Destination = old.Destination,
Duration = old.Duration,
datechanged = now();
end//

update travel_detail 
set duration = 3
where id = 2;

select * from update_travel;