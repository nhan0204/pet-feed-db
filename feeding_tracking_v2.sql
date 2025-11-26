-- Drop the existing columns
ALTER TABLE dbo.Devices
DROP COLUMN food_type_A, food_type_B;

-- Add the columns back as INT
ALTER TABLE dbo.Devices
ADD food_type_A INT NULL,
    food_type_B INT NULL;

-- Add foreign key constraints
ALTER TABLE dbo.Devices
ADD CONSTRAINT FK_Devices_FoodTypes_A 
FOREIGN KEY (food_type_A) REFERENCES dbo.Food_Types(food_type_id);

ALTER TABLE dbo.Devices
ADD CONSTRAINT FK_Devices_FoodTypes_B 
FOREIGN KEY (food_type_B) REFERENCES dbo.Food_Types(food_type_id);


ALTER TABLE dbo.Dispense_Logs
ADD user_id INT NULL,
    CONSTRAINT [FK_DispenseLogs_Users] FOREIGN KEY (user_id)
    REFERENCES dbo.Users (user_id) ON DELETE NO ACTION;