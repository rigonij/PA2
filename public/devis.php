<?php
session_start();
if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}
require_once __DIR__ . "/../templates/senior/devis_view.php";
