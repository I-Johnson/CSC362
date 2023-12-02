<?php
    $common_path = "../../../common/";
    $sql_path = "../../../web_sql/robotic_restaurant/";
    
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);
    // mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
    
    require $common_path . "show_link_to_source.php";
    // var_dump($_POST);
    
    
    show_link_to_source(basename(__file__));
    
    $config = parse_ini_file($common_path . 'mysql.ini');
    // $config = parse_ini_file('/home/odroid/wba_db_beta/mysql.ini');
    $dbname = 'robotic_restaurant';

    if (!$conn = new mysqli(
        $config['mysqli.default_host'],
        $config['mysqli.default_user'],
        $config['mysqli.default_pw'],
        $dbname
    )) {
        echo "Could not connect.<br>";
        echo "Error Num: $conn->connect_errno <br>";
        echo "Error Msg: $conn->connect_error <br>";
        exit;
    }

    // Prepare a deletion record for the Delivery Record.
    if (!$del_delivery_stmt = $conn->prepare("DELETE FROM Deliveries WHERE OrderID = ?")){
        echo "Error: Failed to prepare order deletion statement: " . "<br>";
        echo "ErrNo: $del_delivery_stmt->errno i.e. $del_delivery_stmt->error <br>";
        echo "Quitting.";
        exit();
    }

    // Prepare a deletion statement for the OrderDishes records.
    if (!$del_order_dishes_stmt = $conn->prepare("DELETE FROM OrderDishes WHERE OrderID = ?")){
        echo "Error: Failed to prepare order deletion statement: " . "<br>";
        echo "ErrNo: $del_order_dishes_stmt->errno i.e. $del_order_dishes_stmt->error <br>";
        echo "Quitting.";
        exit();
    }

    // Prepare a deletion statement for the order itself.
    if (!$del_order_stmt = $conn->prepare("DELETE FROM Orders WHERE OrderID = ?")){
        echo "Error: Failed to prepare order deletion statement: " . "<br>";
        echo "ErrNo: $del_order_stmt->errno i.e. $del_order_stmt->error <br>";
        echo "Quitting.";
        exit();
    } 

    if (array_key_exists("order_id", $_POST)){
        $del_delivery_stmt->bind_param('i', $_POST["order_id"]);
        $del_order_dishes_stmt->bind_param('i', $_POST["order_id"]);
        $del_order_stmt->bind_param('i', $_POST["order_id"]);

        $delivery_was_deleted = $del_delivery_stmt->execute();
        $dishes_were_deleted = $del_order_dishes_stmt->execute();
        $order_was_deleted = $del_order_stmt->execute();
        
        // echo $delivery_was_deleted;
        // echo $dishes_were_deleted;
        // echo $order_was_deleted;

        if ($delivery_was_deleted && $dishes_were_deleted && $order_was_deleted){
        ?>
            <h3>Order Deleted</h3>
            <a href="robo_rest_order.php">Return to Order Page</a>
        <?php
        } else {
            echo "ErrNo: $del_delivery_stmt->errno i.e. $del_delivery_stmt->error <br>";
            echo "ErrNo: $del_order_dishes_stmt->errno i.e. $del_order_dishes_stmt->error <br>";
            echo "ErrNo: $del_order_stmt->errno i.e. $del_order_stmt->error <br>";
        }
    
    }

?>
