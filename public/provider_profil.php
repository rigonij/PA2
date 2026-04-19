<?php
session_start();
if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";
$success = "";
$error   = "";

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $payload = [
        "email"          => trim($_POST["email"]          ?? ""),
        "nom"            => trim($_POST["nom"]             ?? ""),
        "prenom"         => trim($_POST["prenom"]          ?? ""),
        "phone_number"   => trim($_POST["phone_number"]    ?? ""),
        "address_street" => trim($_POST["address_street"]  ?? ""),
        "address_zip"    => trim($_POST["address_zip"]     ?? ""),
        "address_city"   => trim($_POST["address_city"]    ?? ""),
        "company_name"   => trim($_POST["company_name"]    ?? ""),
        "siret"          => trim($_POST["siret"]           ?? ""),
    ];
    $ch = curl_init($apiBase . "/api/provider/me");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");
    curl_setopt($ch, CURLOPT_HTTPHEADER, ["Content-Type: application/json", "X-Token: " . $_SESSION["token"]]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
    $res = json_decode(curl_exec($ch), true);
    curl_close($ch);
    $success = !empty($res["success"]) ? "Profil mis a jour." : ($res["message"] ?? "Erreur.");
}

$ch = curl_init($apiBase . "/api/provider/me");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$data = json_decode(curl_exec($ch), true);
curl_close($ch);

if (empty($data["success"])) {
    session_destroy();
    header("Location: login.php");
    exit;
}
$u = $data["user"];

require_once __DIR__ . "/../templates/provider/provider_profil_view.php";
renderProviderProfil($u, $success, $error);
