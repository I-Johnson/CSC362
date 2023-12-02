<?php
    // Show ALL PHP's errors.
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);
    $common_path = "../../../";
    $sql_path = "../labs/lab11/";

    // require $common_path . "format_result.php";
    require $common_path . "show_link_to_source.php";

    $config = parse_ini_file('/home/' . get_current_user() . '/mysqli.ini');
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

    // Prepare statements for initial order creation...
    if (!$submit_order_stmt = $conn->prepare(file_get_contents($sql_path . "submit_order.sql"))){
        echo "Error: Failed to prepare order submission statement: " . "<br>";
        echo "ErrNo: $submit_order_stmt->errno i.e. $submit_order_stmt->error <br>";
        echo "Quitting.";
        exit();
    }

    // ...and subsequent order modification.
    if (!$mod_order_stmt = $conn->prepare(file_get_contents($sql_path . "mod_existing_order.sql"))){
        echo "Error: Failed to prepare order modification statement: " . "<br>";
        echo "ErrNo: $mod_order_stmt->errno i.e. $mod_order_stmt->error <br>";
        echo "Quitting.";
        exit();
    }

    // Prepare to find Customer ID number from first and last name...
    if (!$cust_id_stmt = $conn->prepare(file_get_contents($sql_path . "find_cust_id_from_name.sql"))){
        echo "Error: Failed to prepare customer lookup statement: " . "<br>";
        echo "ErrNo: $cust_id_stmt->errno i.e. $cust_id_stmt->error <br>";
        echo "Quitting.";
        exit();
    }

    // And the Order ID number from the 
    $cust_name_parts = explode(" ", trim($_POST["cust_name"]));
    $cust_id_stmt->bind_param("ss", $cust_name_parts[0], $cust_name_parts[1]);
    $cust_id_stmt->execute();
    $cust_id_res = $cust_id_stmt->get_result();
    $cust_res_array = $cust_id_res->fetch_all(MYSQLI_BOTH);

    if (count($cust_res_array) == 0){
        // Didn't find customer. Add them.
        $add_cust_stmt = $conn->prepare("INSERT INTO Customers (FirstName, LastName) VALUES (?, ?);");
        $add_cust_stmt->bind_param("ss", $cust_name_parts[0], $cust_name_parts[1]);
        $add_cust_stmt->execute();
        // Try to fetch the Customer again.
        $cust_id_stmt->execute();
        $cust_id_res = $cust_id_stmt->get_result();
        $cust_res_array = $cust_id_res->fetch_all(MYSQLI_BOTH);
    }
    $cust_id = $cust_res_array[0][0];

    // Find the ID number of a customer's most recent order. A work-around because INSERT..RETURNING
    // is not working correctly in the current version of MariaDB:
    // ordoid@elsa:~$ mariadb --version
    // mariadb  Ver 15.1 Distrib 10.6.7-MariaDB, for debian-linux-gnueabihf (armv7l) using  EditLine wrapper
    if (!$cust_recent_order_stmt = $conn->prepare(file_get_contents($sql_path . "find_recent_order_id_from_cust_id.sql"))){
        echo "Error: Failed to prepare order lookup statement: " . "<br>";
        echo "ErrNo: $cust_recent_order_stmt->errno i.e. $cust_recent_order_stmt->error <br>";
        echo "Quitting.";
        exit();
    }

    // Order latitude and longitude for delivery.
    $ord_lat = $_POST["cust_lat"];
    $ord_lon = $_POST["cust_lon"];

    // Construct an array of the dishes, names for keys, quantities for values.
    $dishes_ordered = array();
    $menu_res = $conn->query(file_get_contents($sql_path . "select_menu_items.sql"));
    while ($menu_row = $menu_res->fetch_array()) {
        $mod_dish_name = str_replace(" ", "_", $menu_row[0]);
        if (array_key_exists($mod_dish_name, $_POST) && $_POST[$mod_dish_name]){
            $dishes_ordered[$menu_row[0]] = (int) $_POST[$mod_dish_name];
        }
    }

    // Submit the order and the first item.
    // Then modify the order with the remaining dishes.
    if (!$submit_order_stmt->bind_param("iddsi", $cust_id, $ord_lat, $ord_lon, $dish_name, $dish_qant)){
        echo "Failed to bind params for order submission.<br>";
    } else {
        // Using $cust_id
    }
    $cust_recent_order_stmt->bind_param("i", $cust_id);
    $mod_order_stmt->bind_param("isi", $order_id, $dish_name, $dish_qant);
?>
<!DOCTYPE html>
<head>
    <title>Order Submitted</title>
</head>
<body>
    <?php show_link_to_source(basename(__file__)); ?>
    <h1>Your order has been received</h1>
    <?php
    $order_exists = false;
    foreach( $dishes_ordered as $dish_name => $dish_qant){
        if(!$order_exists){
            $submit_order_stmt->execute();
            $submit_order_res = $submit_order_stmt->get_result();
            $cust_recent_order_stmt->execute();
            $cust_recent_order_res = $cust_recent_order_stmt->get_result();
            $cust_recent_order_row = $cust_recent_order_res->fetch_array();
            $order_id = $cust_recent_order_row["OrderID"];
            $order_exists = true;
            echo "Order #$order_id<br>Started with $dish_qant x $dish_name <br>";
        } else {
            echo "Added $dish_qant x $dish_name <br>";
            if ($dish_qant > 0){
                $mod_order_stmt->execute();
            }
        }
    }
    ?>
    <a href="robo_rest_order.php">Return to Order Page</a>
</body>
