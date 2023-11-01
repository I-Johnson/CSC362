<?php
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Database Details</title>
</head>
<body>
<a href="connect.php">View available databases</a> &nbsp;
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
                echo "<h3>Tables in the ", $selectedDatabase, " Database:</h3>";
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
    <br>
    <h3>Field Details</h3>
    <?php
        echo $tables->field_count . " field(s) in results.<br>";
        echo $tables->num_rows . " row(s) in results.";
  ?> 
    <h2>More Details: </h2>
    <?php
        while ($field = $tables->fetch_field()) {
            echo "<h4>" . "Field Name: " . $field->name . "</h4>";
            echo "  Field Type: " . $field->type . "<br>";
            echo "Field Length: " . $field->length . " bytes";
        }
    ?>
    <p><a href="connect.php">Back to Database List</a></p>
</body>
</html>
