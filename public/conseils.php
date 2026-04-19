<?php
session_start();
if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}
require_once __DIR__ . "/../templates/senior/conseils_view.php";
