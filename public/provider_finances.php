<?php
session_start();
if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";

$ch = curl_init($apiBase . "/api/provider/finances");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "X-Token: " . $_SESSION["token"],
]);
$response = curl_exec($ch);
curl_close($ch);

$data        = json_decode($response, true);
$invoices    = $data["invoices"]      ?? [];
$totalRev    = (float)($data["total_revenue"] ?? 0);
$totalCount  = (int)($data["total_count"]     ?? 0);
$errorMsg    = empty($data["success"]) ? ($data["message"] ?? "Erreur API") : "";

include __DIR__ . "/../templates/provider/provider_finances_view.php";
