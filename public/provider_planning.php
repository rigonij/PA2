<?php
session_start();

if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";
$error = "";
$items = [];

$ch = curl_init($apiBase . "/api/provider/planning");
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

    $error = $msg ?: "Erreur chargement planning.";
} else {
    $items = $data["items"] ?? [];
}

require __DIR__ . "/../templates/provider/provider_planning_view.php";
