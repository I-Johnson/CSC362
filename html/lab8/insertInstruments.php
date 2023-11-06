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
        echo "Connection Established!" . "<br>";

        $conn->select_db('instrument_rentals');
        $query = "INSERT INTO instruments (instrument_type)
    VALUES ('Guitar'),
           ('Trumpet'),
           ('Flute'),
           ('Theremin'),
           ('Violin'),
           ('Tuba'), 
           ('Melodica'),
           ('Trombone'),
           ('Keyboard')";

        $result = $conn->query($query);
    
        header('Location: manageInstruments.php');
        exit();
    }
// }
?>