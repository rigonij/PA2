<?php
session_start();

if (!empty($_SESSION["token"])) {
    header("Location: index.php");
    exit;
}

$error = "";

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $email = $_POST["email"] ?? "";
    $password = $_POST["password"] ?? "";

    $ch = curl_init("http://127.0.0.1:8081/api/auth/signin");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ["Content-Type: application/json"]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
        "email" => $email,
        "password" => $password
    ]));

    $response = curl_exec($ch);
    curl_close($ch);

    $data = json_decode($response, true);

    if (!empty($data["code"]) && ($data["code"] === "PROVIDER_PENDING" || $data["code"] === "PROVIDER_REJECTED")) {
        $error = $data["message"] ?? "Compte prestataire non validé.";
    } else if (!empty($data["success"]) && !empty($data["token"])) {
        $_SESSION["token"] = $data["token"];

        $role = $data["role"] ?? "senior";
        if ($role === "provider") {
            header("Location: provider_dashboard.php");
            exit;
        }
        header("Location: index.php");
        exit;
    } else {
        $error = $data["message"] ?? "Email ou mot de passe incorrect.";
    }
}

require __DIR__ . "/../templates/senior/login_view.php";
