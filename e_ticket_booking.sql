CREATE DATABASE e_ticket_booking;

-- Use the database
USE e_ticket_booking;

-- Create User Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create Events Table
CREATE TABLE Events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    event_name VARCHAR(100) NOT NULL,
    event_date DATETIME NOT NULL,
    venue VARCHAR(100) NOT NULL,
    total_tickets INT NOT NULL,
    available_tickets INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create Bookings Table
CREATE TABLE Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    event_id INT,
    number_of_tickets INT NOT NULL,
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);


-- Insert a new user (example)
INSERT INTO Users (username, password, email, phone) 
VALUES ('john_doe', 'hashed_password_here', 'john@example.com', '1234567890');


-- Insert a new event (example)
INSERT INTO Events (event_name, event_date, venue, total_tickets, available_tickets) 
VALUES ('Concert Night', '2024-12-01 20:00:00', 'City Hall', 100, 100);

-- Booking tickets for an event
SET @event_id = 1; -- Assuming this is the event ID
SET @user_id = 1;  -- Assuming this is the user ID
SET @number_of_tickets = 2; -- Number of tickets to book

-- Check available tickets
SELECT available_tickets INTO @available FROM Events WHERE event_id = @event_id;

IF @available >= @number_of_tickets THEN
    -- Insert booking record
    INSERT INTO Bookings (user_id, event_id, number_of_tickets) 
    VALUES (@user_id, @event_id, @number_of_tickets);

    -- Update available tickets in Events table
    UPDATE Events 
    SET available_tickets = available_tickets - @number_of_tickets 
    WHERE event_id = @event_id;

    -- Notify successful booking (You can implement a notification system)
    SELECT 'Booking successful! Your e-ticket has been generated.' AS message;
ELSE
    SELECT 'Not enough tickets available!' AS message;
END IF;




-- Get booking history for a user
SELECT b.booking_id, e.event_name, b.number_of_tickets, b.booking_date 
FROM Bookings b
JOIN Events e ON b.event_id = e.event_id
WHERE b.user_id = @user_id; -- Replace with actual user ID
