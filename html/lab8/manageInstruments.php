<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$dark = "dark"; 
$mode = isset($_COOKIE['user_mode']) ? $_COOKIE['user_mode'] : "light";
$button_pressed = "button_pressed";
$button_label = "Toggle Dark/Light Modes";

if (!isset($_COOKIE['user_mode'])) {
    setcookie('user_mode', $mode, time() + 60 * 60 * 24 * 365, '/');
    header("Location: {$_SERVER['REQUEST_URI']}", true, 303);
    exit();
}

$button_pressed = "button_pressed";

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST[$button_pressed])) {
    $new_mode = $_COOKIE['user_mode'] === 'light' ? 'dark' : 'light';
    setcookie('user_mode', $new_mode, time() + 60 * 60 * 24 * 365, '/');
    header("Location: {$_SERVER['REQUEST_URI']}", true, 303);
    exit();
}

session_start();
$dark = "dark";

if (!isset($_SESSION['num_deleted'])) {
    $_SESSION['num_deleted'] = 0;
}

if (isset($_POST['logout'])) {
    session_unset();
    header("Location: {$_SERVER['REQUEST_URI']}", true, 303);
    exit();
}

if (isset($_POST['username'])) {
    $_SESSION['username'] = $_POST['username'];
    header("Location: {$_SERVER['REQUEST_URI']}", true, 303);
    exit();
}


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
function resultToHtmlTable($result, $mode) {
    $resultBody = $result->fetch_all();
    $numRows = $result->num_rows;
    $numCols = $result->field_count;
    $fields = $result->fetch_fields();
    ?>
<?php
$mode = isset($_COOKIE['user_mode']) ? $_COOKIE['user_mode'] : "light";
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- <title>Document</title> -->

    <?php
    if ($_COOKIE['user_mode'] == "light") {
    ?>
        <link rel="stylesheet" href="./basic.css">
    <?php
    } else {
    ?>
        <link rel="stylesheet" href="./darkmode.css">
    <?php
    } 
    ?>
</head>
<body>
    
    <a href="./">Back to Home Page</a> &nbsp;
    <p>This table has <?php echo $numRows; ?> rows and <?php echo $numCols; ?> columns.</p>
    <?php
    $dark = 'dark';
    ?>
    <h1>
        <?php echo $_COOKIE['user_mode'] == $dark? "Welcome to the Dark Mode" : "Delete Instruments";?>
    </h1>

    <!-- Toggle Button -->
    <form method=POST>
    <input type="submit" name="<?= $button_pressed ?>" value="Toggle Light/Dark Mode"/>
    </form>

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
</body>
</html>

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
    resultToHtmlTable($result, $_COOKIE[$mode] ?? "light");
} else {
    echo "No records found";
    resultToHtmlTable($result, $_COOKIE[$mode] ?? "light");
}

?>
