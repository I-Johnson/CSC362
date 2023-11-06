<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Function to establish a database connection
function getDatabaseConnection() {
    $config = parse_ini_file('/home/johnsonsubedi/CSC362/mysqli.ini');
    $conn = new mysqli(
        $config['mysqli.default_host'],
        $config['mysqli.default_user'],
        $config['mysqli.default_pw']
    );

    if ($conn->connect_errno) {
        echo "Failed to connect to MySQL: (" . $conn->connect_errno . ") " . $conn->connect_error;
        exit();
    }

    $conn->select_db('instrument_rentals');
    return $conn;
}

// Function to generate an HTML table from MySQL result
function resultToHtmlTable($result) {
    $resultBody = $result->fetch_all();
    $numRows = $result->num_rows;
    $numCols = $result->field_count;
    $fields = $result->fetch_fields();
    ?>

    <p>This table has <?php echo $numRows; ?> rows and <?php echo $numCols; ?> columns.</p>

    <form action="deleteFromTable.php" method="POST">
        <table>
            <thead>
                <tr>
                    <th>Delete?</th>
                    <?php foreach ($fields as $field) { ?>
                        <td><b><?php echo $field->name; ?></b></td>
                    <?php } ?>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($resultBody as $row) { ?>
                    <?php $id = $row[0]; ?>
                    <tr>
                        <td><input type="checkbox" name="checkbox<?php echo $id; ?>" value="<?php echo $id; ?>"></td>
                        <?php foreach ($row as $cell) { ?>
                            <td><?php echo $cell; ?></td>
                        <?php } ?>
                    </tr>
                <?php } ?>
            </tbody>
        </table>
        <input type="submit" value="Delete Selected">
    </form>


    <form method="POST" action="insertInstruments.php">
        <input type="submit" name="insertButton" value="Insert New Records">
    </form>

    <form method="POST" action="deleteall.php">
        <input type="submit", name="delete_all", value="Delete All Records">
    </form>

    <?php

}

// Main code
$conn = getDatabaseConnection();
$query = "SELECT * FROM instruments";
$result = $conn->query($query);

if ($result === false) {
    echo "Error executing the query: " . $conn->error;
    exit();
}

if ($result->num_rows > 0) {
    resultToHtmlTable($result);
} else {
    echo "No records found";
    resultToHtmlTable($result);
}

?>


