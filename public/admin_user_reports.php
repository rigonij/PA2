<?php
session_start();
if (empty($_SESSION["admin_token"])) {
    header("Location: admin_login.php");
    exit;
}

if (isset($_GET["api"]) && $_SERVER["REQUEST_METHOD"] === "POST") {
    $body = file_get_contents("php://input");
    $ch = curl_init("http://backend:8080/api/admin/user-reports/resolve");
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => $body,
        CURLOPT_HTTPHEADER => [
            "X-Token: " . $_SESSION["admin_token"],
            "Content-Type: application/json",
        ],
    ]);
    $resp = curl_exec($ch);
    $code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    http_response_code($code ?: 500);
    header("Content-Type: application/json");
    echo $resp ?: json_encode(["success" => false, "message" => "Erreur API"]);
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

$ch = curl_init("http://backend:8080/api/admin/user-reports");
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
