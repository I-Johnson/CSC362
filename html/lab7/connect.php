<?php
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);



// Toggle Dark Mode
$mode = "user_mode";
$light = "light";
$dark = "dark";
$button_pressed = "yes";
$button_label = "Toggle Dark/Light Modes";
?>

<?php
    $config = parse_ini_file('/home/johnsonsubedi/CSC362/mysqli.ini');
    // $dbname = 'instrument_rentals';

    $conn = new mysqli(
                $config['mysqli.default_host'],
                $config['mysqli.default_user'],
                $config['mysqli.default_pw']);


    if ($conn->connect_errno) {
        echo "Error: Failed to make a MySQL connection, here is why: ". "<br>";
        echo "Errno: " . $conn->connect_errno . "\n";
        echo "Error: " . $conn->connect_error . "\n";
        exit; // Quit this PHP script if the connection fails.
    } else {
        echo "Connection Established!" . "<br>";
        // echo "YAY!" . "<br>";
    }
?>
<br>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Databases</title>
</head>
<body>
<a href="../lab7">Back to File Directory <br/></a> &nbsp;
<br>
<h1>Available Databases</h1>
<?php
    $dblist = "SHOW databases";
    $result = $conn->query($dblist);
?>
<ul>
<?php
    while ($dbname = $result->fetch_array()) {
        ?>
        <li><a href="details.php?dbname=<?php echo $dbname['Database'];?>" ><?php echo $dbname['Database']; ?></a></li>
        <?php
    }
?>
</ul>
<h2>Check the database you want from above list</h2>

<form action="details.php" method="post">
            <label for="name">Database name:</label>
            <input name="name" id="name" type="text">
            <button type="submit">Submit</button>
</form>

</body>
</html>
