<?php
require __DIR__ . "/provider_guard.php";

$error = "";
$success = "";

$serviceTypeId = (int)($_GET["service_type_id"] ?? 0);
if ($serviceTypeId <= 0) {
    header("Location: provider_services.php");
    exit;
}

$schedules = [];
$selectedIds = [];

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $raw = $_POST["schedule_ids"] ?? [];
    if (!is_array($raw)) $raw = [];

    $scheduleIds = [];
    foreach ($raw as $v) {
        $id = (int)$v;
        if ($id > 0) $scheduleIds[] = $id;
    }

    $payload = ["schedule_ids" => $scheduleIds];

    $ch = curl_init($apiBase . "/api/provider/service-schedules/" . $serviceTypeId);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["token"],
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));

    $resp = curl_exec($ch);
    curl_close($ch);

    $data = json_decode($resp ?: "", true);

    if (!empty($data["success"])) {
        $success = $data["message"] ?? "Horaires mis à jour.";
    } else {
        $msg = $data["message"] ?? "";
        if (strpos($msg, "Non authentifié") !== false) {
            session_destroy();
            header("Location: login.php");
            exit;
        }
        $error = $msg ?: "Erreur mise à jour.";
    }
}

$ch = curl_init($apiBase . "/api/provider/service-schedules/" . $serviceTypeId);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "X-Token: " . $_SESSION["token"],
]);
$resp = curl_exec($ch);
curl_close($ch);

$data = json_decode($resp ?: "", true);

if (!empty($data["success"])) {
    $schedules = $data["schedules"] ?? [];
    $selectedIds = $data["selected_ids"] ?? [];
} else {
    $msg = $data["message"] ?? "";
    if (strpos($msg, "Non authentifié") !== false) {
        session_destroy();
        header("Location: login.php");
        exit;
    }
    $error = $error ?: ($msg ?: "Erreur chargement.");
}

require __DIR__ . "/../templates/provider/provider_service_horaires_view.php";
