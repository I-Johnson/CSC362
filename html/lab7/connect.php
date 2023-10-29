<?php
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);
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