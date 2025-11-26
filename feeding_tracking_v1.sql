-- Modifications v1

-- Devices
ALTER TABLE dbo.Devices
ADD food_type_A NVARCHAR(100),
    food_type_B NVARCHAR(100),
    expiration_A DATETIME2,
    expiration_B DATETIME2,
    last_dispensed_tray char(1),
    low_threshhold_A DECIMAL,
    low_threshhold_B DECIMAL;

-- Dispense Logs
ALTER TABLE dbo.Dispense_Logs
ADD tray_dispended CHAR(1),
    was_scheduled BIT,
    time_stamp DATETIME2;

-- INTRODUCING NEW TABLES

-- Food_Types
CREATE TABLE dbo.Food_Types (
    food_type_id int IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100),
    description NVARCHAR(100),
    default_shelf_life_days INT,
)

-- Feeding_Schedules
CREATE TABLE dbo.Feeding_Schedules (
    schedule_id INT IDENTITY(1,1) PRIMARY KEY,
    device_id INT FOREIGN KEY REFERENCES dbo.Devices(device_id) ON DELETE CASCADE,
    user_id INT FOREIGN KEY REFERENCES dbo.Users(user_id),
    frequency TIME,
    start_time DATETIME2,
    next_schedule_time DATETIME2,
    default_portion_size DECIMAL,
    active BIT,
    routine_type NVARCHAR(50)
);

-- Notifications
CREATE TABLE dbo.Notifications(
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    device_id INT FOREIGN KEY REFERENCES dbo.Devices(device_id),
    time_stamp DATETIME2,
    type NVARCHAR(50),
    message NVARCHAR(255),
    acknowledgement BIT
)

-- Indexes (This help with tracking futures Dispense_Logs base on [feeding time])
CREATE INDEX idx_dispense_logs_device_timestamp ON dbo.Dispense_Logs (device_id, time_stamp);

-- Indexes (This help with tracking expiration of the food in each devices)
CREATE INDEX idx_devices_expiration ON dbo.Devices(expiration_A, expiration_B);

-- Unique constraint: ONE DEVICE COULD ONLY BE OWNED BY ONE USER. [ONE USER CAN OWN MANY DEVICES]
ALTER TABLE dbo.Devices ADD CONSTRAINT  uq_device_owner UNIQUE (device_id, owner_id);
