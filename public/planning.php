<?php
session_start();
if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";

$action = $_GET["action"] ?? "";
$id = (int)($_GET["id"] ?? 0);

if ($action === "unsubscribe_event" && $id > 0) {
    $ch = curl_init($apiBase . "/api/events/unsubscribe");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["token"],
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(["event_id" => $id]));
    curl_exec($ch);
    curl_close($ch);
    header("Location: planning.php");
    exit;
}

if ($action === "unreserve_service" && $id > 0) {
    $ch = curl_init($apiBase . "/api/services/unreserve");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["token"],
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(["intervention_id" => $id]));
    curl_exec($ch);
    curl_close($ch);
    header("Location: planning.php");
    exit;
}

if ($action === "delete_medical" && $id > 0) {
    $ch = curl_init($apiBase . "/api/medical/delete");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["token"],
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(["medical_id" => $id]));
    curl_exec($ch);
    curl_close($ch);
    header("Location: planning.php?scope=" . ($_GET["scope"] ?? "upcoming"));
    exit;
}

if ($action === "clear_history") {
    $ch = curl_init($apiBase . "/api/planning/clear-history");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["token"],
    ]);
    curl_exec($ch);
    curl_close($ch);
    header("Location: planning.php?scope=history");
    exit;
}

$scope = ($_GET["scope"] ?? "upcoming") === "history" ? "history" : "upcoming";

$ch = curl_init($apiBase . "/api/planning?scope=" . $scope);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "X-Token: " . $_SESSION["token"],
]);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);
$events = $data["events"] ?? [];
$services = $data["services"] ?? [];
$medicals = $data["medicals"] ?? [];

require_once __DIR__ . "/../templates/senior/planning_view.php";
