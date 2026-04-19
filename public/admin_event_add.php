<?php
session_start();

if (empty($_SESSION["admin_token"])) {
    header("Location: admin_login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";
$error = "";

if ($_SERVER["REQUEST_METHOD"] === "POST" && !empty($_POST["title"])) {
    $title = $_POST["title"];
    $location = $_POST["location"];
    $eventDate = $_POST["event_date"];
    $maxParticipants = (int)$_POST["max_participants"];

    $ch = curl_init($apiBase . "/api/admin/events");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["admin_token"]
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
        "title" => $title,
        "location" => $location,
        "event_date" => $eventDate,
        "max_participants" => $maxParticipants
    ]));
    
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    $data = json_decode($response, true);

    if ($httpCode === 201 || ($httpCode === 200 && !empty($data["success"]))) {
        header("Location: admin_event.php");
        exit;
    } else {
        $error = $data["message"] ?? "Erreur lors de la création de l'événement.";
    }
}

header("Location: admin_event.php");
exit;
?>
