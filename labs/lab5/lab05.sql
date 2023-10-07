/* 
    Lab 05: Flying Carpets Gallery
    CSC 362 Database Systems
    Johnson Subedi
*/

/* Creating the database (dropping the previous versions) */

DROP DATABASE IF EXISTS flying_carpets;

-- Create database 

CREATE DATABASE flying_carpets;

USE flying_carpets;

/* Create required tables */

-- Lookup tables
CREATE TABLE RugCountries (
    PRIMARY KEY (CountryName),
    CountryName     VARCHAR(64)
);

CREATE TABLE RugStyles (
    PRIMARY KEY (RugStyleName),
    RugStyleName     VARCHAR(64)
);

CREATE TABLE RugMaterials (
    PRIMARY KEY (RugMaterialName),
    RugMaterialName   VARCHAR(64)
);

CREATE TABLE CustomerStates (
    CustomerState VARCHAR(64) PRIMARY KEY
);

/* Entity Tables */

-- Customer table to store information

CREATE TABLE Customers (
    PRIMARY KEY (CustomerID), 
    CustomerID              INT AUTO_INCREMENT,
    CustomerName            VARCHAR(64) NOT NULL, 
    CustomerStreetAddress   VARCHAR(64) NOT NULL, 
    CustomerCity            VARCHAR(64) NOT NULL, 
    CustomerState           VARCHAR(64) NOT NULL, 
    CustomerZIP             INT NOT NULL,
    CustomerPhone           VARCHAR(20) NOT NULL, 
    FOREIGN KEY (CustomerState) REFERENCES CustomerStates(CustomerState)
);

-- Rugs Table to store information of inventory

CREATE TABLE Rugs (
    PRIMARY KEY (RugID),
    RugID               INT AUTO_INCREMENT ,
    RugPurchasePrice    DECIMAL(10, 2) NOT NULL,
    RugCountryOfOrigin  VARCHAR(64) NOT NULL,
    RugDateAcquired     DATE NOT NULL, 
    RugMarkup           DECIMAL(5, 2) NOT NULL,
    RugListPrice        DECIMAL(10, 2) NOT NULL, 
    RugYearMade         INT NOT NULL,
    RugStyle            VARCHAR(256),
    RugMaterial         VARCHAR(256),
    RugLengthCM         INT NOT NULL,
    RugWidthCM          INT NOT NULL,
    FOREIGN KEY (RugCountryOfOrigin) REFERENCES RugCountries(CountryName),
    FOREIGN KEY (RugStyle)           REFERENCES RugStyles(RugStyleName),
    FOREIGN KEY (RugMaterial)        REFERENCES RugMaterials(RugMaterialName)
);

-- Trials table to track rug and customer's relation 

CREATE TABLE Trials (
    RugID           INT, 
    CustomerID      INT, 
    TrialStartDate  DATE NOT NULL, 
    TrialEndDate    DATE NOT NULL, 
    RugReturnDate   DATE,
    PRIMARY KEY (RugID, CustomerID),
    FOREIGN KEY (RugID)      REFERENCES Rugs(RugID), 
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Transaction table to track the transactions done
CREATE TABLE Transactions (
    RugID               INT, 
    CustomerID          INT, 
    TransactionDate     DATE NOT NULL,
    TransactionPrice    DECIMAL(10, 2) NOT NULL,
    ReturnDate          DATE,
    PRIMARY KEY (RugID, CustomerID),
    FOREIGN KEY (RugID)      REFERENCES Rugs(RugID), 
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Deletion rules for the rugs
CREATE VIEW DeletableRugs AS
    SELECT RugID, RugCountryOfOrigin, RugStyle, RugMaterial, RugYearMade, RugPurchasePrice, RugMarkup, RugLengthCM, RugWidthCM
    FROM   Rugs
    WHERE  RugID NOT IN (SELECT RugID FROM Transactions)
    AND    RugID NOT IN (SELECT RugID FROM Trials);





    

/* Populating Data */ 

-- Populating lookup tables:

INSERT INTO RugCountries (CountryName)
VALUES ('Turkey'), ('Iran'), ('India'), ('Afghanistan');

INSERT INTO RugMaterials (RugMaterialName)
VALUES ('Wool'), ('Silk'), ('Cotton');

INSERT INTO RugStyles (RugStyleName)
VALUES ('Ushak'), ('Tabriz'), ('Agra');

-- Populate State Lookup table: 

INSERT INTO CustomerStates (CustomerState) 
VALUES   
  ('AL'),
  ('AK'),
  ('AZ'),
  ('AR'),
  ('CA'),
  ('CO'),
  ('CT'),
  ('DE'),
  ('FL'),  
  ('GA'),
  ('HI'),
  ('ID'),
  ('IL'),
  ('IN'),
  ('IA'),    
  ('KS'),
  ('KY'),
  ('LA'),
  ('ME'),
  ('MD'),
  ('MA'),
  ('MI'),
  ('MN'),
  ('MS'),
  ('MO'),
  ('MT'),
  ('NE'),
  ('NV'),
  ('NH'),
  ('NJ'),
  ('NM'),
  ('NY'),
  ('NC'),
  ('ND'),
  ('OH'),
  ('OK'),
  ('OR'),
  ('PA'),
  ('RI'),
  ('SC'),
  ('SD'),
  ('TN'),
  ('TX'),
  ('UT'),
  ('VT'),
  ('VA'),
  ('WA'),
  ('WV'),
  ('WI'),
  ('WY');

-- Populate Rugs/Inventory table: 

INSERT INTO Rugs (RugID, RugPurchasePrice, RugDateAcquired, RugCountryOfOrigin, RugStyle, RugMaterial,
                 RugMarkup, RugListPrice, RugYearMade, RugLengthCM, RugWidthCM)
VALUES  (1214, 625.00, '2017-04-06', 'Turkey', 'Ushak', 'Wool', 1.00, 1250.00, 1925, 5, 7),
        (1219, 28000.00, '2017-04-06', 'Iran', 'Tabriz', 'Silk', 0.75, 49000.00, 1910, 10, 14),
        (1277, 1200.00, '2017-06-15', 'India', 'Agra', 'Wool', 1.00, 2400.00, 2017, 8, 10),
        (1278, 450.00, '2017-06-15', 'India', 'Agra', 'Wool', 1.20, 990.00, 2017, 4, 6);

-- Populate Customers Table:
INSERT INTO Customers (CustomerName, CustomerStreetAddress, CustomerCity, CustomerState, CustomerZIP, CustomerPhone)
VALUES ('Akira Ingram', '68 Country Drive', 'Roseville', 'MI', 48066, '(926) 252-6716'),
       ('Meredith Spencer', '9044 Piper Lane', 'North Royalton', 'OH', 44133, '(817) 530-5994'),
       ('Marco Page', '747 East Harrison Lane', 'Atlanta', 'GA', 30303, '(588) 799-6535'),
       ('Sandra Page', '47 East Harrison Lane', 'Atlanta', 'GA', 30303, '(997) 697-2666'), 
       ('Gloria Gomez', '78 Corona Rd.', 'Fullerton', 'CA', 92831, ''), 
       ('Bria Le', '386 Silver Spear Ct', 'Coraopolis', 'PA', 15108, '');

-- Insert the transaction
INSERT INTO Transactions (RugID, CustomerID, TransactionDate, TransactionPrice, ReturnDate)
SELECT
    (SELECT RugID FROM Rugs WHERE RugID = 1214), -- Rug ID
    (SELECT CustomerID FROM Customers WHERE CustomerName = 'Gloria Gomez'), -- Customer ID
    '2017-12-14', -- Sale Date
    990.00, -- Sale Price
    NULL; -- No return date

-- Insert the transaction
INSERT INTO Transactions (RugID, CustomerID, TransactionDate, TransactionPrice, ReturnDate)
SELECT
    (SELECT RugID FROM Rugs WHERE RugID = 1277), -- Rug ID
    (SELECT CustomerID FROM Customers WHERE CustomerName = 'Bria Le'), -- Customer ID
    '2017-12-24', -- Sale Date
    2400.00, -- Sale Price
    NULL; -- No return date

-- Insert the transaction
INSERT INTO Transactions (RugID, CustomerID, TransactionDate, TransactionPrice, ReturnDate)
SELECT
    (SELECT RugID FROM Rugs WHERE RugID = 1219 LIMIT 1), -- Rug ID
    (SELECT CustomerID FROM Customers WHERE CustomerName = 'Meredith Spencer' LIMIT 1), -- Customer ID
    '2017-12-24', -- Sale Date
    40000.00, -- Sale Price
    '2017-12-26'; -- Return Date