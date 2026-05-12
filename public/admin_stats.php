<?php
session_start();
if (empty($_SESSION["admin_token"])) {
    header("Location: admin_login.php");
    exit;
}

$apiBase = "http://backend:8080";

$ch = curl_init($apiBase . "/api/admin/stats");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$response = curl_exec($ch);
curl_close($ch);

$data  = json_decode($response, true);
$stats = $data["stats"] ?? [];

include __DIR__ . "/../templates/admin/admin_stats_view.php";
