<?php
require __DIR__ . "/provider_guard.php";

$action = $_POST["action"] ?? "";
$interventionId = (int)($_POST["intervention_id"] ?? 0);

if (in_array($action, ["approve", "refuse"]) && $interventionId > 0) {
    $ch = curl_init($apiBase . "/api/provider/interventions/approve");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["token"],
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
        "intervention_id" => $interventionId,
        "approved"        => $action === "approve",
    ]));
    curl_exec($ch);
    curl_close($ch);
    header("Location: provider_interventions.php");
    exit;
}

if ($action === "clear_history") {
    $ch = curl_init($apiBase . "/api/provider/interventions/history/clear");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["token"],
    ]);
    curl_exec($ch);
    curl_close($ch);
    header("Location: provider_interventions.php");
    exit;
}

$ch = curl_init($apiBase . "/api/provider/interventions");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);
$interventions = $data["interventions"] ?? [];

include __DIR__ . "/../templates/provider/provider_interventions_view.php";
