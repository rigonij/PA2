<?php
session_start();

if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase = "http://backend:8080";
$errorMsg = "";

$action = $_GET["action"] ?? "";
$id = (int)($_GET["id"] ?? 0);

if ($id > 0 && ($action === "subscribe" || $action === "unsubscribe")) {
    $endpoint = $action === "subscribe" ? "/api/events/subscribe" : "/api/events/unsubscribe";

    $ch = curl_init($apiBase . $endpoint);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["token"],
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
        "event_id" => $id
    ]));

    $response = curl_exec($ch);
    curl_close($ch);

    $dataAction = json_decode($response, true);
    if (empty($dataAction["success"])) {
        $errorMsg = $dataAction["message"] ?? "Erreur action événement.";
    }

    header("Location: catalogue-evenements.php");
    exit;
}

if ($action === "pay_event" && $id > 0) {
    $ch = curl_init("http://backend:8080/api/events/checkout");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["token"],
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(["event_id" => $id]));
    $resp = curl_exec($ch);
    curl_close($ch);
    $data = json_decode($resp, true);
    if (!empty($data["success"]) && !empty($data["checkout_url"])) {
        header("Location: " . $data["checkout_url"]);
        exit;
    }
    header("Location: catalogue-evenements.php?status=error");
    exit;
}

$statusEvent = $_GET["status"] ?? "";

$ch = curl_init($apiBase . "/api/events");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "X-Token: " . $_SESSION["token"],
]);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);
$events = $data["events"] ?? [];

require_once __DIR__ . "/../templates/senior/catalogue-evenements_view.php";
