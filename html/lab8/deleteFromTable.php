<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$config = parse_ini_file('/home/johnsonsubedi/CSC362/mysqli.ini');
$conn = new mysqli(
    $config['mysqli.default_host'],
    $config['mysqli.default_user'],
    $config['mysqli.default_pw']
);

if ($conn->connect_errno) {
    echo "Error: Failed to make a MySQL connection, here is why: " . "<br>";
    echo "Errno: " . $conn->connect_errno . "\n";
    echo "Error: " . $conn->connect_error . "\n";
    exit; // Quit this PHP script if the connection fails.
} else {
    echo "Connection Established!" . "<br>";
}

$use_db_query = "USE instrument_rentals";
if ($conn->query($use_db_query) === TRUE) {
    echo "Database selected successfully";
} else {
    echo "Error selecting database: " . $conn->error;
}

$result = $conn->query("SELECT * FROM instruments");

if ($result === false) {
    echo "Error executing the select query: " . $conn->error;
    exit;
}

$res = $result->fetch_all();
$del_stmt = $conn->prepare("DELETE FROM instruments WHERE instrument_id = ?");
$del_stmt->bind_param('i', $id);

for ($i = 0; $i < count($res); $i++) {
    $id = $res[$i][0];
    $key = "checkbox" . $id;
    if (isset($_POST[$key])) {
        $id = $res[$i][0]; // Ensure $id is assigned correctly
        if (!$del_stmt->execute()) {
            echo "Error executing deletion: " . $del_stmt->error;
            exit;
        }
    }
}


// Redirect back to the page
header('Location: manageInstruments.php');
?>
