<?php
session_start();
if (empty($_SESSION["admin_token"])) {
    header("Location: admin_login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";
$stats   = [];
$error   = "";

$ch = curl_init($apiBase . "/api/admin/stats");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["admin_token"]]);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);

if (!empty($data["success"])) {
    $stats = $data["stats"];
} else {
    if (isset($data["message"]) && strpos($data["message"], "refusé") !== false) {
        session_destroy();
        header("Location: admin_login.php");
        exit;
    }
    $error = $data["message"] ?? "Erreur lors du chargement des statistiques.";
}

$pageTitle = "Tableau de bord";
require_once __DIR__ . "/../templates/admin/admin_dashboard_view.php";
renderAdminDashboard($stats, $error);
