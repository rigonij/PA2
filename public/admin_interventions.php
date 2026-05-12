<?php
session_start();
if (empty($_SESSION["admin_token"])) {
    header("Location: admin_login.php");
    exit;
}
$apiBase = "http://backend:8080";

$action         = $_GET["action"] ?? "";
$interventionId = (int)($_GET["id"] ?? 0);
$newStatus      = $_GET["status"] ?? "";

if ($action === "set_status" && $interventionId > 0 && $newStatus !== "") {
    $ch = curl_init($apiBase . "/api/admin/interventions/status");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["admin_token"],
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
        "intervention_id" => $interventionId,
        "status"          => $newStatus,
    ]));
    curl_exec($ch);
    curl_close($ch);
    header("Location: admin_interventions.php");
    exit;
}

$ch = curl_init($apiBase . "/api/admin/interventions");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "X-Token: " . $_SESSION["admin_token"],
]);
$response = curl_exec($ch);
curl_close($ch);

$data          = json_decode($response, true);
$pending   = $data["pending"]   ?? [];
$confirmed = $data["confirmed"] ?? [];
$canceled  = $data["canceled"]  ?? [];


include __DIR__ . "/../templates/admin/admin_interventions_view.php";
