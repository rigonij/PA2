<?php
session_start();
if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase  = "http://127.0.0.1:8081";
$invoices = [];
$error    = "";

$ch = curl_init($apiBase . "/api/provider/invoices");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);
if (!empty($data["success"])) {
    $invoices = $data["invoices"];
} else {
    $error = $data["message"] ?? "Erreur chargement factures.";
}

require_once __DIR__ . "/../templates/provider/provider_factures_view.php";
renderProviderFactures($invoices, $error);
