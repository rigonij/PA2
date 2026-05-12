<?php
session_start();

if (!empty($_SESSION["admin_token"])) {
    header("Location: admin_dashboard.php");
    exit;
}

$apiBase = "http://backend:8080";
$error = "";

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $email    = trim($_POST["email"]    ?? "");
    $password = trim($_POST["password"] ?? "");

    $ch = curl_init($apiBase . "/api/admin/auth/signin");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ["Content-Type: application/json"]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
        "email"    => $email,
        "password" => $password
    ]));
    $response = curl_exec($ch);
    curl_close($ch);

    $data = json_decode($response, true);

    if (!empty($data["success"]) && !empty($data["token"])) {
        $_SESSION["admin_token"] = $data["token"];
        header("Location: admin_dashboard.php");
        exit;
    }

    $error = $data["message"] ?? "Email ou mot de passe incorrect.";
}

require_once __DIR__ . "/../templates/admin/admin_login_view.php";