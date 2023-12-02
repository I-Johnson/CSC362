DROP DATABASE IF EXISTS robo_rest_fall_2023;
CREATE DATABASE robo_rest_fall_2023;
USE robo_rest_fall_2023;

CREATE TABLE Dishes(
    PRIMARY KEY(DishID),
    DishID                  INT AUTO_INCREMENT,
    DishName                VARCHAR(256),
    DishPrice               FLOAT,
    DishWeightGrams         INT
);

CREATE TABLE Franchises (
    PRIMARY KEY (FranchiseID),
    FranchiseID INT AUTO_INCREMENT,
    FranchiseLocationLat   FLOAT,
    FranchiseLocationLon    FLOAT,
    FranchiseStreet         VARCHAR(64),
    FranchiseCity           VARCHAR(64),
    FranchiseState          VARCHAR(64),
    FranchiseZIP            VARCHAR(5)
);

CREATE TABLE Customers (
    PRIMARY KEY             (CustomerID),
    CustomerID              INT AUTO_INCREMENT NOT NULL,
    CustomerFirstName       VARCHAR(64)        NOT NULL,
    CustomerLastName        VARCHAR(64)        NOT NULL,
    CustomerEmail           VARCHAR(64)        NOT NULL,
    CustomerDefaultLat      FLOAT              NOT NULL,
    CustomerDefaultLong     FLOAT              NOT NULL
);

CREATE TABLE Orders(
    PRIMARY KEY (OrderID), 
    FOREIGN KEY (FranchiseID) REFERENCES Franchises(FranchiseID), 
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    OrderID                 INT AUTO_INCREMENT, 
    FranchiseID             INT,
    CustomerID              INT,
    DeliveryLocationLat     FLOAT,
    DeliveryLocationLon     FLOAT,
    OrderSubmissionTime     DATETIME DEFAULT CURRENT_TIMESTAMP(),
    OrderDeliveryTime       DATETIME
);

CREATE TABLE OrderDishes (
    PRIMARY KEY (OrderDishID),
    FOREIGN KEY (DishID) REFERENCES Dishes (DishID),
    FOREIGN KEY (OrderID) REFERENCES Orders (OrderID),
    OrderDishID             INT AUTO_INCREMENT,
    DishID                  INT,
    OrderID                 INT,
    DishNotes               VARCHAR (50)
);

CREATE TABLE Drones(
    PRIMARY KEY (DroneID),
    FOREIGN KEY (FranchiseID) REFERENCES Franchises (FranchiseID),
    DroneID                 INT AUTO_INCREMENT,
    DroneCapacityGrams      INT DEFAULT 2000,
    DroneCallsign           VARCHAR(64) UNIQUE,
    PurchaseDate            DATE DEFAULT CURRENT_TIMESTAMP(),
    FranchiseID             INT
);

CREATE TABLE DroneAssignments(
    PRIMARY KEY (DroneID,OrderDishID),
    DroneID                 INT AUTO_INCREMENT,
    OrderDishID             INT,
    FOREIGN KEY (DroneID) REFERENCES Drones(DroneID),
    FOREIGN KEY (OrderDishID) REFERENCES OrderDishes(OrderDishID)
 );



-- SOURCE sample_data.sql;
-- SOURCE add_order.sql;