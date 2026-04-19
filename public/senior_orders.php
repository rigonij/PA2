<?php
session_start();
if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";

$ch = curl_init($apiBase . "/api/senior/orders");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "X-Token: " . $_SESSION["token"],
]);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);
$orders = $data["orders"] ?? [];

include __DIR__ . "/../templates/senior/senior_orders_view.php";
