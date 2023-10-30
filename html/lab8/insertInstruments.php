<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
?>

<?php
    //Connect to database
    $config = parse_ini_file('/home/johnsonsubedi/CSC362/mysql.ini');
    $conn = new mysqli(
        $config['mysqli.default_host'],
        $config['mysqli.default_user'],
        $config['mysqli.default_pw']
    );

    if ($conn -> connect_errno) {
        echo "Failed to connect to MySQL: (". $conn->connect_errno . ") " .
        $conn->connect_error;
        exit();
    }

    $conn->select_db('instrument_rentals');
    $query = "INSERT INTO instruments (instrument_type)
                VALUE ('Guitar'),
                      ('Trumpet'),
                      ('Flute'),
                      ('Theremin'),
                      ('Violin'),
                      ('Tuba'), 
                      ('Melodica')
                      ('Trombone')
                      ('Keyboard')";
    $result = $conn->query($query);

    header('Location: manageInstrument.php');
    exit();
?>