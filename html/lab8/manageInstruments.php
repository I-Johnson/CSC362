<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Function to establish a database connection
function getDatabaseConnection() {
    $config = parse_ini_file('/home/johnsonsubedi/CSC362/mysql.ini');
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

    <form action="insertInstruments.php" method="POST">
        <input type="submit" value="Insert New Records">
    </form>

    <?php
}

// Main code
$conn = getDatabaseConnection();
$query = "SELECT * FROM instruments";
$result = $conn->query($query);

resultToHtmlTable($result);
?>
