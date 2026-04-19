<?php
session_start();

if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";
$error = "";
$provider = null;

$ch = curl_init($apiBase . "/api/provider/me");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response ?: "", true);

if (empty($data["success"])) {
    $msg = $data["message"] ?? "";

    if (
        stripos($msg, "Non authentifié") !== false ||
        stripos($msg, "prestataire requis") !== false ||
        stripos($msg, "non validé") !== false ||
        stripos($msg, "Accès refusé") !== false
    ) {
        session_destroy();
        header("Location: login.php");
        exit;
    }

    $error = $msg ?: "Erreur chargement dashboard.";
} else {
    $provider = $data["user"] ?? null;
}

require __DIR__ . "/../templates/provider/provider_dashboard_view.php";
