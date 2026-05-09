<?php
session_start();

if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";

$flashSuccess = "";
$flashError = "";

$action = $_GET["action"] ?? ($_POST["action"] ?? "");

if ($_SERVER["REQUEST_METHOD"] === "POST" && $action === "create") {
    $payload = [
        "start_at" => trim($_POST["start_at"] ?? ""),
        "provider_id" => (int)($_POST["provider_id"] ?? 0),
        "location" => trim($_POST["location"] ?? ""),
        "use_account_address" => !empty($_POST["use_account_address"]),
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

    if (!empty($data["success"])) {
        $flashSuccess = "RDV médical créé.";
    } else {
        $flashError = $data["message"] ?? "Erreur lors de la création du RDV.";
    }
}

if ($action === "delete") {
    $medicalID = (int)($_GET["id"] ?? ($_POST["medical_id"] ?? 0));

    if ($medicalID > 0) {
        $ch = curl_init($apiBase . "/api/medical/delete");
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            "Content-Type: application/json",
            "X-Token: " . $_SESSION["token"],
        ]);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(["medical_id" => $medicalID]));
        curl_exec($ch);
        curl_close($ch);
    }

    header("Location: rdv-medicaux.php");
    exit;
}

$medicals = [];
$ch = curl_init($apiBase . "/api/medical");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "X-Token: " . $_SESSION["token"],
]);
$response = curl_exec($ch);
curl_close($ch);
$data = json_decode($response, true);
if (!empty($data["success"]) && !empty($data["items"])) {
    $medicals = $data["items"];
}

$me = null;
$ch = curl_init($apiBase . "/api/me");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "X-Token: " . $_SESSION["token"],
]);
$response = curl_exec($ch);
curl_close($ch);
$data = json_decode($response, true);
if (!empty($data["success"]) && !empty($data["user"])) {
    $me = $data["user"];
}

$accountAddress = "";
if ($me) {
    $parts = [];
    $street = trim($me["address_street"] ?? "");
    $zip = trim($me["address_zip"] ?? "");
    $city = trim($me["address_city"] ?? "");
    if ($street !== "") {
        $parts[] = $street;
    }
    $zipCity = trim($zip . " " . $city);
    if ($zipCity !== "") {
        $parts[] = $zipCity;
    }
    $accountAddress = implode(", ", $parts);
}

include __DIR__ . "/../templates/senior/rdv-medicaux_view.php";
