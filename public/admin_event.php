<?php
session_start();
if (empty($_SESSION["admin_token"])) {
    header("Location: admin_login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";
$error = $_SESSION["admin_event_error"] ?? "";
unset($_SESSION["admin_event_error"]);

if ($_SERVER["REQUEST_METHOD"] === "POST" && ($_POST["action"] ?? "") === "clear_history") {
    $ch = curl_init("http://127.0.0.1:8081/api/admin/events/history");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE");
    curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["admin_token"]]);
    curl_exec($ch);
    curl_close($ch);
    header("Location: admin_event.php");
    exit;
}

if ($_SERVER["REQUEST_METHOD"] === "POST" && !empty($_POST["update_id"])) {
    $id = (int)$_POST["update_id"];
    $payload = [
        "title" => trim($_POST["title"] ?? ""),
        "location" => trim($_POST["location"] ?? ""),
        "event_date" => trim($_POST["event_date"] ?? ""),
        "max_participants" => (int)($_POST["max_participants"] ?? 0),
        "price" => (float)($_POST["price"] ?? 0),
        "description" => trim($_POST["description"] ?? "")
    ];

    $ch = curl_init($apiBase . "/api/admin/events/" . $id);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["admin_token"]
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    $data = json_decode($response, true);
    if ($httpCode !== 200 || empty($data["success"])) {
        $_SESSION["admin_event_error"] = $data["message"] ?? "Erreur lors de la mise à jour.";
    }
    header("Location: admin_event.php");
    exit;
}

if ($_SERVER["REQUEST_METHOD"] === "POST" && !empty($_POST["delete_id"])) {
    $id = (int)$_POST["delete_id"];

    $ch = curl_init($apiBase . "/api/admin/events/" . $id);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE");
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "X-Token: " . $_SESSION["admin_token"]
    ]);
    curl_exec($ch);
    curl_close($ch);

    header("Location: admin_event.php");
    exit;
}

$ch = curl_init($apiBase . "/api/admin/events");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "X-Token: " . $_SESSION["admin_token"]
]);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);
$events = $data["events"] ?? [];

include __DIR__ . "/../templates/admin/admin_event_view.php";
