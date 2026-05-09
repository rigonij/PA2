<?php
session_start();
if (empty($_SESSION["admin_token"])) {
    header("Location: admin_login.php");
    exit;
}

$activeStatus = $_GET["status"] ?? "pending";
if (!in_array($activeStatus, ["pending", "resolved", "dismissed"], true)) {
    $activeStatus = "pending";
}

$reports = [];
$loadError = "";
$flashSuccess = $_SESSION["flash_success"] ?? "";
$flashError = $_SESSION["flash_error"] ?? "";
unset($_SESSION["flash_success"], $_SESSION["flash_error"]);

$ch = curl_init("http://127.0.0.1:8081/api/admin/user-reports");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["admin_token"]]);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);
if (!empty($data["success"]) && isset($data["reports"])) {
    $reports = $data["reports"];
} else {
    $loadError = $data["message"] ?? "Erreur de chargement";
}

include __DIR__ . "/../templates/admin/admin_user_reports_view.php";
