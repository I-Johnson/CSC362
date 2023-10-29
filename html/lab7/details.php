<!DOCTYPE html>
<html>
<head>
    <title>Database Details</title>
</head>
<body>
<?php
    $dbhost = 'localhost';
    $dbuser = 'johnsonsubedi'; // Hard-coding credentials directly in code is not ideal: (1) we might have to 
    $dbpass = '1689';       // change them in multiple places, and (2) this creates security concerns. 
                                // We'll fix that in the next lab.
?>
    <h1>Database Details</h1>

    <?php
    if (isset($_POST['name'])) {
        $selectedDatabase = $_POST['name'];

        // Creating a new connection to the selected database
        $conn = new mysqli($dbhost, $dbuser, $dbpass, $selectedDatabase);

        if ($conn->connect_errno) {
            echo "Error: Failed to make a MySQL connection for the selected database, here is why: " . "<br>";
            echo "Errno: " . $conn->connect_errno . "\n";
            echo "Error: " . $conn->connect_error . "\n";
        } else {
            echo "Connected: $selectedDatabase" . "<br>";
            echo  "<br>";
            
            // Retrieving information about the tables in the selected database
            $tables = $conn->query("SHOW TABLES");

            if ($tables) {
                $numTables = $tables->num_rows;
                echo "$numTables row(s) in results.<br>";
                echo "<h2>Tables in the ", $selectedDatabase, " Database:</h2>";
                while ($table = $tables->fetch_array()) {
                    echo $table[0] . "<br>";
                }
            } else {
                echo "No tables found in the selected database.";
            }
            
            // Closing the connection to the selected database
            $conn->close();
        }
    } else {
        echo "<p>No database name specified.</p>";
    }
    ?>

    <p><a href="connect.php">Back to Database List</a></p>
</body>
</html>
