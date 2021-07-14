<?php
  echo "Start\n";
  $db = getenv("DB");
  $host = getenv("HOST");
  $username = getenv("USER");
  $password = getenv("PASSWORD");
  $sleep = getenv("TIMEOUT");

  echo "Create connection\n";
  $conn = null;
  try {
    $conn = new PDO("mysql:host=$host;dbname=$db", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  } catch (PDOException $e) {
    echo "Connection failed: ".$e->getMessage()."\n";
    exit(1);
  }

  echo "Select\n";
  $shop = $conn->prepare("SELECT * FROM shops WHERE 1");
  $shop->execute();
  while($shopDB = $shop->fetch()){

    echo "Sleep 1\n";

    usleep($sleep);

    echo "Shop: ".$shopDB['shop']."\n";

    $req = $conn->prepare("UPDATE shops SET installed=".$shopDB['installed']." WHERE shop='".$shopDB['shop']."'");
    $req->execute();

    echo "Sleep 2\n";

    usleep($sleep);
  }

  $conn = null;
?>