<?php
session_start();

if (!empty($_SESSION["token"])) {
    header("Location: index.php");
    exit;
}

$error = "";
$success = "";

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $role = ($_POST["role"] ?? "senior") === "provider" ? "provider" : "senior";

    $payload = [
        "email" => trim($_POST["email"] ?? ""),
        "password" => trim($_POST["password"] ?? ""),
        "confirmation" => trim($_POST["password_confirm"] ?? ""),
        "nom" => trim($_POST["nom"] ?? ""),
        "prenom" => trim($_POST["prenom"] ?? ""),
        "phone_number" => trim($_POST["telephone"] ?? ""),
        "role" => $role,
        "birth_date" => trim($_POST["birth_date"] ?? ""),
        "company_name" => trim($_POST["company_name"] ?? ""),
        "siret" => trim($_POST["siret_number"] ?? "")
    ];


    $ch = curl_init("http://127.0.0.1:8081/api/auth/signup");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ["Content-Type: application/json"]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));

    $response = curl_exec($ch);
    curl_close($ch);

    $data = json_decode($response, true);

    if (!empty($data["success"])) {
        $success = "Compte créé avec succès ! Vous pouvez maintenant vous connecter.";
    } else {
        $error = $data["message"] ?? "Erreur lors de la création du compte.";
    }
}

require __DIR__ . "/../templates/senior/register_view.php";
