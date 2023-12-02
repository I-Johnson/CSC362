<?php
    $common_path = "../../../";
    $sql_path = "../labs/lab11/";

    require $common_path . "format_result.php";
    require $common_path . "show_link_to_source.php";

    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);

    $config = parse_ini_file('/home/' . get_current_user() . '/mysqli.ini');
    $db_name = 'robotic_restaurant';

    //

    if (!$conn = new mysqli(
        $config['mysqli.default_host'],
        $config['mysqli.default_user'],
        $config['mysqli.default_pw'],
        $db_name
    )) {
        echo "Could not connect. <br>";
        echo "Error Num: $conn->connect_errno <br>";
        echo "Error Msg: $conn->connect_error <br>";
        exit;
    }
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>place an Order</title>
</head>
<a href="../../index.html">Back to Home Page</a> &nbsp;
<?php show_link_to_source(basename(__file__)); ?>
<h1>Welcome to Alice's </code>Robotic Restaurant</code></h1>
<!-- <p>You </p> -->
<form action="order_confirm.php" method="POST">
    <h2>Menu</h2>
    <?php
    if (!$menu_res = $conn->query(file_get_contents($sql_path . "select_menu_items.sql"))){
        echo "<i>Failed to load menu!</i>\n";
        exit();
    }
    result_to_input_table($menu_res);
    ?>

    <table>
        <thead>
            <th></th>
        </thead>
        <tbody>
            <!-- Name -->
            <tr>
                <td style="text-align: right">Name:</td>
                <td><input type="text" name="cust_name" required/></td>
            </tr>
            <!-- Location -->
            <tr>
                <td style="text-align: right">Latitude:</td>
                <td><input type="text" name="cust_lat" pattern="[0-9]+(\.[0-9])?" title="Enter a valid decimal number" required/></td>
            </tr>
            <tr>
                <td style="text-align: right">Longitude:</td>
                <td><input type="text" name="cust_lon" pattern="[0-9]+(\.[0-9])?" title="Enter a valid decimal number" required/></td>
            </tr>
        </tbody>
    </table>
    <input type="submit" value="Place Order"/>
</form>
<form action="order_delete.php" method="POST">
    <table>
        <tbody>
            <!-- Order ID -->
            <tr>
                <td style="text-align: right">Order ID:</td>
                <td><input type="text" name="order_id"/></td>
            </tr>
        </tbody>
    </table>
    <input type="submit" value="Delete Order"/>
</form>

<h2>Pending Orders</h2>
<?php
    if (!$orders_res = $conn->query(file_get_contents($sql_path . "select_pending_orders.sql"))){
        echo "<i>Failed to load orders!</i>\n";
        exit();
    }
    result_to_html_table($orders_res);
?>


<body>
    
</body>
</html>