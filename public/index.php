<?php
session_start();

if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$userName = "Utilisateur";

$ch = curl_init("http://localhost:8081/api/me");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "X-Token: " . $_SESSION["token"]
]);

$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);

if (!empty($data["success"]) && !empty($data["user"])) {
    $prenom = $data["user"]["prenom"] ?? "";
    $nom = $data["user"]["nom"] ?? "";
    $email = $data["user"]["email"] ?? "";

    $userName = trim($prenom . " " . $nom);
    if ($userName === "") {
        $userName = $email ?: "Utilisateur";
    }
} else {
    session_destroy();
    header("Location: login.php");
    exit;
}

require_once __DIR__ . "/../templates/senior/index_view.php";
