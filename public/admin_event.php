<?php
session_start();

if (empty($_SESSION["admin_token"])) {
    header("Location: admin_login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";
$events  = [];
$error   = "";



if ($_SERVER["REQUEST_METHOD"] === "POST" && !empty($_POST["event_id"]) && !empty($_POST["action"])) {
    $eventId = (int)$_POST["event_id"];
    $status     = ($_POST["action"] === "validate") ? 1 : 2;

    $ch = curl_init($apiBase . "/api/admin/events/" . $eventId);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["admin_token"]
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(["status" => $status]));
    $response = curl_exec($ch);
    curl_close($ch);

    header("Location: admin_event.php");
    exit;
}

if ($_SERVER["REQUEST_METHOD"] === "POST" && !empty($_POST["delete_id"])) {
    $deleteId = (int)$_POST["delete_id"];

    $ch = curl_init($apiBase . "/api/admin/events/" . $deleteId);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE");
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["admin_token"]
    ]);
    $response = curl_exec($ch);
    curl_close($ch);
    header("Location: admin_event.php");
    exit;
}


$ch = curl_init($apiBase . "/api/admin/events");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["admin_token"]]);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);

if (!empty($data["success"])) {
    $events = $data["events"];
} else {
    if (isset($data["message"]) && strpos($data["message"], "refusé") !== false) {
        session_destroy();
        header("Location: admin_login.php");
        exit;
    }
    $error = $data["message"] ?? "Erreur lors du chargement des événements.";
}

require_once __DIR__ . "/../templates/admin/admin_event_view.php";
