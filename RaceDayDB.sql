-- =============================================
-- RaceDay Database Schema
-- Project: RaceDay - Event Management System
-- Part 1 - Section C: SQL Database Script
-- Date: September 2026
-- =============================================

-- Switch to RaceDayDB database
USE RaceDayDB;

-- =============================================
-- DROP TABLES (if they exist)
-- =============================================
IF OBJECT_ID('dbo.Result', 'U') IS NOT NULL DROP TABLE dbo.Result;
IF OBJECT_ID('dbo.Enrolment', 'U') IS NOT NULL DROP TABLE dbo.Enrolment;
IF OBJECT_ID('dbo.Category', 'U') IS NOT NULL DROP TABLE dbo.Category;
IF OBJECT_ID('dbo.Event', 'U') IS NOT NULL DROP TABLE dbo.Event;
IF OBJECT_ID('dbo.ParticipantProfile', 'U') IS NOT NULL DROP TABLE dbo.ParticipantProfile;
IF OBJECT_ID('dbo.OrganiserProfile', 'U') IS NOT NULL DROP TABLE dbo.OrganiserProfile;
IF OBJECT_ID('dbo.[User]', 'U') IS NOT NULL DROP TABLE dbo.[User];

-- =============================================
-- CREATE TABLE 1: USER
-- =============================================
CREATE TABLE [User] (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    email NVARCHAR(100) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    role NVARCHAR(20) NOT NULL CHECK (role IN ('Organiser', 'Participant')),
    date_of_birth DATE,
    phone NVARCHAR(20),
    created_at DATETIME DEFAULT GETDATE()
);

-- =============================================
-- CREATE TABLE 2: ORGANISERPROFILE
-- =============================================
CREATE TABLE OrganiserProfile (
    profile_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    organisation_name NVARCHAR(100) NOT NULL,
    website NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES [User](user_id) ON DELETE CASCADE
);

-- =============================================
-- CREATE TABLE 3: PARTICIPANTPROFILE
-- =============================================
CREATE TABLE ParticipantProfile (
    profile_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    emergency_contact_name NVARCHAR(100),
    emergency_contact_phone NVARCHAR(20),
    medical_conditions NVARCHAR(500),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES [User](user_id) ON DELETE CASCADE
);

-- =============================================
-- CREATE TABLE 4: EVENT
-- =============================================
CREATE TABLE Event (
    event_id INT IDENTITY(1,1) PRIMARY KEY,
    organiser_id INT NOT NULL,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),
    event_type NVARCHAR(20) NOT NULL CHECK (event_type IN ('Running', 'Walking', 'Cycling')),
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    location NVARCHAR(200) NOT NULL,
    distance_km DECIMAL(5,2) NOT NULL,
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (organiser_id) REFERENCES OrganiserProfile(profile_id) ON DELETE CASCADE
);

-- =============================================
-- CREATE TABLE 5: CATEGORY
-- =============================================
CREATE TABLE Category (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    event_id INT NOT NULL,
    name NVARCHAR(50) NOT NULL,
    min_age INT,
    max_age INT,
    entry_fee DECIMAL(10,2) NOT NULL,
    start_time TIME,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (event_id) REFERENCES Event(event_id) ON DELETE CASCADE
);

-- =============================================
-- CREATE TABLE 6: ENROLMENT
-- =============================================
CREATE TABLE Enrolment (
    enrolment_id INT IDENTITY(1,1) PRIMARY KEY,
    participant_id INT NOT NULL,
    event_id INT NOT NULL,
    category_id INT NOT NULL,
    registration_date DATETIME DEFAULT GETDATE(),
    status NVARCHAR(20) DEFAULT 'Registered' CHECK (status IN ('Registered', 'Confirmed', 'Cancelled')),
    bib_number INT UNIQUE,
    FOREIGN KEY (participant_id) REFERENCES ParticipantProfile(profile_id),
    FOREIGN KEY (event_id) REFERENCES Event(event_id),
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

-- =============================================
-- CREATE TABLE 7: RESULT
-- =============================================
CREATE TABLE Result (
    result_id INT IDENTITY(1,1) PRIMARY KEY,
    enrolment_id INT NOT NULL UNIQUE,
    finish_time TIME NOT NULL,
    [position] INT,
    pace TIME,
    is_disqualified BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (enrolment_id) REFERENCES Enrolment(enrolment_id) ON DELETE CASCADE
);

-- =============================================
-- INSERT SAMPLE DATA
-- =============================================

-- Insert Users (2 Organisers, 2 Participants)
INSERT INTO [User] (email, password_hash, full_name, role, date_of_birth, phone)
VALUES 
('john@organiser.com', 'hashed_password_123', 'John Doe', 'Organiser', '1980-05-15', '+27123456789'),
('sarah@organiser.com', 'hashed_password_456', 'Sarah Smith', 'Organiser', '1985-08-22', '+27123456790'),
('alice@participant.com', 'hashed_password_789', 'Alice Johnson', 'Participant', '1990-03-10', '+27123456791'),
('bob@participant.com', 'hashed_password_101', 'Bob Williams', 'Participant', '1988-11-12', '+27123456792');

-- Insert Organiser Profiles
INSERT INTO OrganiserProfile (user_id, organisation_name, website)
VALUES 
(1, 'Cape Town Marathon Organisers', 'www.ctmarathon.com'),
(2, 'Durban Ultra Events', 'www.durbanultra.co.za');

-- Insert Participant Profiles
INSERT INTO ParticipantProfile (user_id, emergency_contact_name, emergency_contact_phone, medical_conditions)
VALUES 
(3, 'Jane Johnson', '+27123456793', 'Asthma (mild)'),
(4, 'Emily Williams', '+27123456794', 'None');

-- Insert Events (3 Events)
INSERT INTO Event (organiser_id, name, description, event_type, start_date, end_date, location, distance_km, is_active)
VALUES 
(1, 'Cape Town Marathon 2026', 'The iconic Cape Town Marathon event', 'Running', '2026-10-15 06:00:00', '2026-10-15 18:00:00', 'Cape Town Stadium, Cape Town', 42.2, 1),
(1, 'Cape Town 10K', 'Shorter distance run', 'Running', '2026-10-16 07:00:00', '2026-10-16 12:00:00', 'Sea Point Promenade, Cape Town', 10, 1),
(2, 'Durban Cycle Tour', 'Scenic cycling event along the coast', 'Cycling', '2026-11-20 06:30:00', '2026-11-20 17:00:00', 'Durban Beachfront, Durban', 100, 1);

-- Insert Categories (10 Categories)
INSERT INTO Category (event_id, name, min_age, max_age, entry_fee, start_time)
VALUES 
(1, 'Elite Men', 18, 40, 500.00, '06:00:00'),
(1, 'Elite Women', 18, 40, 500.00, '06:05:00'),
(1, 'Veteran Men (40+)', 40, 60, 350.00, '06:10:00'),
(1, 'Veteran Women (40+)', 40, 60, 350.00, '06:15:00'),
(2, 'Open Men', 16, 60, 200.00, '07:00:00'),
(2, 'Open Women', 16, 60, 200.00, '07:05:00'),
(2, 'Junior (Under 16)', 10, 15, 100.00, '07:10:00'),
(3, 'Elite', 18, 45, 600.00, '06:30:00'),
(3, 'Open', 18, 65, 400.00, '06:35:00'),
(3, 'Veteran (45+)', 45, 70, 350.00, '06:40:00');

-- Insert Enrolments (4 Enrolments)
INSERT INTO Enrolment (participant_id, event_id, category_id, status, bib_number)
VALUES 
(1, 1, 2, 'Confirmed', 101),
(1, 2, 5, 'Registered', 102),
(2, 1, 1, 'Confirmed', 103),
(2, 3, 8, 'Registered', 104);

-- Insert Results (2 Results)
INSERT INTO Result (enrolment_id, finish_time, [position], pace, is_disqualified)
VALUES 
(1, '03:45:30', 15, '05:20', 0),
(3, '02:45:15', 5, '04:15', 0);

-- =============================================
-- VERIFY DATA
-- =============================================
SELECT 'Users' as Table_Name, COUNT(*) as Row_Count FROM [User]
UNION ALL
SELECT 'OrganiserProfile', COUNT(*) FROM OrganiserProfile
UNION ALL
SELECT 'ParticipantProfile', COUNT(*) FROM ParticipantProfile
UNION ALL
SELECT 'Event', COUNT(*) FROM Event
UNION ALL
SELECT 'Category', COUNT(*) FROM Category
UNION ALL
SELECT 'Enrolment', COUNT(*) FROM Enrolment
UNION ALL
SELECT 'Result', COUNT(*) FROM Result;

-- =============================================
-- VIEW ALL TABLES
-- =============================================
SELECT * FROM [User];
SELECT * FROM OrganiserProfile;
SELECT * FROM ParticipantProfile;
SELECT * FROM Event;
SELECT * FROM Category;
SELECT * FROM Enrolment;
SELECT * FROM Result;