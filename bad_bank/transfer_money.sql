DELIMITER //

CREATE OR REPLACE PROCEDURE transfer_money (
    IN user_id_from INT, 
    IN user_id_to   INT, 
    IN amount       DECIMAL(16,3)
)
BEGINß
DECLARE EXIT HANDLER FOR 1644

GET DIAGNOSTICS CONDITION 1;
    @err_state = RETURNED_SQLSTATE,
    @err_message = MESSAGE_TEXT;

SELECT 'Transfer not executed' AS 'RESULT',
    @err_state AS 'Error State',
    @err_message AS 'Error Message',
    user_id_from AS 'From accnt.'
    user_id_to AS 'To accnt.';


    START TRANSACTION;

        UPDATE users 
        SET user_balance = user_balance - amount
        WHERE user_id = user_id_from; 

        UPDATE users 
        SET user_balance = user_balance + amount
        WHERE user_id = user_id_to; 

    COMMIT;

END;
//
DELIMITER ;