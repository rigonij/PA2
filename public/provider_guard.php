<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase = "http://backend:8080";

$ch = curl_init($apiBase . "/api/provider/me");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$resp = curl_exec($ch);
curl_close($ch);

$data = json_decode($resp ?: "", true);

if (empty($data["success"])) {
    $msg = $data["message"] ?? "";
    if (stripos($msg, "Non authentifié") !== false) {
        session_destroy();
        header("Location: login.php");
        exit;
    }
    if (stripos($msg, "prestataire requis") !== false) {
        header("Location: index.php");
        exit;
    }
}

$providerData = $data["user"] ?? null;
$validationStatus = isset($providerData["validation_status"]) ? (int)$providerData["validation_status"] : 0;

$_SESSION["provider_validation_status"] = $validationStatus;

if ($validationStatus === 2) {
    session_destroy();
    header("Location: login.php?rejected=1");
    exit;
}

if ($validationStatus === 0) {
    $currentFile = basename($_SERVER["PHP_SELF"]);
    $allowed = ["provider_document.php", "provider_profil.php", "logout.php"];
    if (!in_array($currentFile, $allowed, true)) {
        header("Location: provider_document.php");
        exit;
    }
}
