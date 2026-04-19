<?php
session_start();
if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";

$ch = curl_init($apiBase . "/api/senior/invoices");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$data = json_decode(curl_exec($ch), true);
curl_close($ch);

if (empty($data["success"])) {
    session_destroy();
    header("Location: login.php");
    exit;
}

$invoices = $data["invoices"] ?? [];

require __DIR__ . "/../templates/senior/facturation_view.php";
renderFacturation($invoices);
