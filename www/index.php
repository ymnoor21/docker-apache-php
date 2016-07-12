<?php
    $mysqli = new mysqli("172.17.0.2", "root", "foobar", "sample");
    if ($mysqli->connect_errno) {
        echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
    }

    $val = rand(10, 1000);

    if (!$mysqli->query("DROP TABLE IF EXISTS test") ||
        !$mysqli->query("CREATE TABLE test(id INT)") ||
        !$mysqli->query("INSERT INTO test(id) VALUES ($val)")) {
        echo "Table creation failed: (" . $mysqli->errno . ") " . $mysqli->error;
    }
    echo "came here<br/>";
    phpinfo();
