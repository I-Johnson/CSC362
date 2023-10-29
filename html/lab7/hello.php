<!DOCTYPE html>
<html>
    <head>
        <title>PHP Test</title>
    </head>
    <body>
        <?php echo '<h1>Lab 7</h1>'; ?>
        <?php echo '<h2>Hello World, This is my PHP page</h2>'; ?>
        <?php echo $_SERVER['HTTP_USER_AGENT'] ;?>
        <br> </br>

        <?php
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);
?>
        <?php
            if (strpos($_SERVER['HTTP_USER_AGENT'], 'Chrome')) {
            echo 'You are using Chrome.';
            }
        ?>

        <?php

            if (strpos($_SERVER['HTTP_USER_AGENT'], 'Firefox') !== false) {
            ?>
            <h3>strpos() returned a valid index</h3>
            <p>You are using Firefox</p>
            <?php
            } else {
            ?>
            <p>You are not using Firefox</p>
            <?php
            }   
        ?>
        
        <form action="action.php" method="post">
            <label for="name">Your name:</label>
            <input name="name" id="name" type="text">

            <label for="age">Your age:</label>
            <input name="age" id="age" type="number">

            <button type="submit">Submit</button>
        </form>

        <!-- <?php echo $_SERVER['HTTP_USER_AGENT'];?> -->

        <!-- <?php phpinfo(); ?> -->







    </body>
</html>