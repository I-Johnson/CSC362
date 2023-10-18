<?php
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);
?>

<?php
    $dbhost = 'localhost';
    $dbuser = 'johnsonsubedi'; // Hard-coding credentials directly in code is not ideal: (1) we might have to 
    $dbpass = '1689';       // change them in multiple places, and (2) this creates security concerns. 
                                // We'll fix that in the next lab.
?>
<?php 
    $conn = new mysqli($dbhost, $dbuser, $dbpass);
?>
<?php

    if ($conn->connect_errno) {
        echo "Error: Failed to make a MySQL connection, here is why: ". "<br>";
        echo "Errno: " . $conn->connect_errno . "\n";
        echo "Error: " . $conn->connect_error . "\n";
        exit; // Quit this PHP script if the connection fails.
    } else {
        echo "Connected Successfully!" . "<br>";
        echo "YAY!" . "<br>";
    }

?>

<?php
    $dblist = "SHOW databases";
?>

<?php
    $result = $conn->query($dblist);
?>

<?php
    $dblist = "SHOW databases";
    $result = $conn->query($dblist);
?>

<?php
    while ($dbname = $result->fetch_array()) {
        echo $dbname['Database'] . "<br>";
    }
?>

<h2>Check the database you want from above list</h2>

<form action="details.php" method="post">
            <label for="name">Database name:</label>
            <input name="name" id="name" type="text">
            <button type="submit">Submit</button>
</form>