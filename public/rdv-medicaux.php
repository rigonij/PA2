<?php
session_start();

if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";
$errorMsg = "";
$successMsg = "";

if ($_SERVER["REQUEST_METHOD"] === "POST" && ($_POST["action"] ?? "") === "create_medical") {
    $payload = [
        "start_at" => trim($_POST["start_at"] ?? ""),
        "doctor_name" => trim($_POST["doctor_name"] ?? ""),
        "location" => trim($_POST["location"] ?? ""),
        "details" => trim($_POST["details"] ?? ""),
    ];

    $ch = curl_init($apiBase . "/api/medical/create");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["token"],
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
    $response = curl_exec($ch);
    curl_close($ch);

    $data = json_decode($response, true);
    if (empty($data["success"])) {
        $errorMsg = $data["message"] ?? "Erreur création RDV.";
    } else {
        $successMsg = "RDV créé.";
    }

    header("Location: rdv-medicaux.php");
    exit;
}

if (($_GET["action"] ?? "") === "delete" && !empty($_GET["id"])) {
    $id = (int)$_GET["id"];

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

    header("Location: rdv-medicaux.php");
    exit;
}

$ch = curl_init($apiBase . "/api/medical");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "X-Token: " . $_SESSION["token"],
]);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);
$medicalItems = $data["items"] ?? [];

require_once __DIR__ . "/../templates/senior/rdv-medicaux_view.php";
