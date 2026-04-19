<?php
session_start();
if (empty($_SESSION["admin_token"])) {
    header("Location: admin_login.php");
    exit;
}

$apiBase  = "http://127.0.0.1:8081";
$payments = [];
$error    = "";

$ch = curl_init($apiBase . "/api/admin/payments");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["admin_token"]]);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);
if (!empty($data["success"])) {
    $payments = $data["payments"];
} else {
    $error = $data["message"] ?? "Erreur lors du chargement des paiements.";
}

$pageTitle = "Paiements";
require_once __DIR__ . "/../templates/admin/admin_paiement_view.php";
renderAdminPaiement($payments, $error);
