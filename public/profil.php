<?php
session_start();

if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";
$successMsg = "";
$errorMsg = "";

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $payload = [
        "email" => trim($_POST["email"] ?? ""),
        "nom" => trim($_POST["nom"] ?? ""),
        "prenom" => trim($_POST["prenom"] ?? ""),
        "phone_number" => trim($_POST["phone_number"] ?? ""),
        "address_street" => trim($_POST["address_street"] ?? ""),
        "address_zip" => trim($_POST["address_zip"] ?? ""),
        "address_city" => trim($_POST["address_city"] ?? "")
    ];

    $ch = curl_init($apiBase . "/api/me");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["token"]
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));

    $response = curl_exec($ch);
    if ($response === false) {
        $errorMsg = "Erreur cURL: " . curl_error($ch);
        curl_close($ch);
    } else {
        curl_close($ch);
        $dataUpdate = json_decode($response, true);

        if (!empty($dataUpdate["success"])) {
            $successMsg = "Profil mis à jour.";
        } else {
            $errorMsg = $dataUpdate["message"] ?? "Erreur lors de la mise à jour.";
        }
    }
}

$ch = curl_init($apiBase . "/api/me");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "X-Token: " . $_SESSION["token"]
]);
$response = curl_exec($ch);
curl_close($ch);


$data = json_decode($response, true);

if (empty($data["success"]) || empty($data["user"])) {
    session_destroy();
    header("Location: login.php");
    exit;
}

$userData = $data["user"];


require_once __DIR__ . "/../templates/senior/profil_view.php";
