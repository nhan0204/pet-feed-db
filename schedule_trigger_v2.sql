-- Trigger Loging Logic for Dispense
CREATE TRIGGER trigger_after_dispense
ON dbo.Dispense_Logs
AFTER INSERT
AS
BEGIN
    DECLARE @device_id int, @tray char(1), @portion decimal;
    SELECT @device_id = device_id, @tray = tray_dispended, @portion = portion_size FROM INSERTED;
    
    -- Update portion and last tray
    IF @tray = 'A'
    BEGIN
        UPDATE dbo.Devices SET portion_A = portion_A - @portion, last_dispensed_tray = 'A' WHERE device_id = @device_id;
    END
    ELSE IF @tray = 'B'
    BEGIN
        UPDATE dbo.Devices SET portion_B = portion_B - @portion, last_dispensed_tray = 'B' WHERE device_id = @device_id;
    END
    
    -- Check low threshold and insert notification if needed
    DECLARE @new_portion_A decimal, @new_portion_B decimal, @thresh_A decimal, @thresh_B decimal;
    SELECT @new_portion_A = portion_A, @new_portion_B = portion_B, @thresh_A = low_threshold_A, @thresh_B = low_threshold_B FROM dbo.Devices WHERE device_id = @device_id;
    
    IF @new_portion_A < @thresh_A
    INSERT INTO dbo.Notifications (device_id, user_id, time_stamp, type, message, acknowledged)
    SELECT @device_id, owner_id, GETDATE(), 'Refill_A', 'Tray A is low—refill soon!', 0 FROM dbo.Devices WHERE device_id = @device_id;
    
    IF @new_portion_B < @thresh_B
    INSERT INTO dbo.Notifications (device_id, user_id, time_stamp, type, message, acknowledged)
    SELECT @device_id, owner_id, GETDATE(), 'Refill_B', 'Tray B is low—refill soon!', 0 FROM dbo.Devices WHERE device_id = @device_id;
END;