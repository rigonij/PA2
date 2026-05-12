<?php
session_start();

if (empty($_SESSION["admin_token"])) {
    header("Location: admin_login.php");
    exit;
}

$apiBase = "http://backend:8080";
$error   = "";
$success = "";
$user    = null;

$id = isset($_GET["id"]) ? (int)$_GET["id"] : 0;
if ($id <= 0) {
    header("Location: admin_users.php");
    exit;
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $payload = [
        "email"        => $_POST["email"] ?? "",
        "nom"          => $_POST["nom"] ?? "",
        "prenom"       => $_POST["prenom"] ?? "",
        "phone_number" => $_POST["phone_number"] ?? "",
        "address_city" => $_POST["address_city"] ?? "",
    ];

    if (!empty($_POST["password"])) {
        if ($_POST["password"] !== $_POST["password_confirm"]) {
            $error = "Les mots de passe ne correspondent pas.";
        } else {
            $payload["password"] = $_POST["password"];
        }
    }

    if (empty($error)) {
        $ch = curl_init($apiBase . "/api/admin/user/" . $id);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            "Content-Type: application/json",
            "X-Token: " . $_SESSION["admin_token"],
        ]);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
        $response = curl_exec($ch);
        curl_close($ch);

        $data = json_decode($response, true);
        if (!empty($data["success"])) {
            $success = "Utilisateur modifié avec succès.";
        } else {
            $error = $data["message"] ?? "Erreur lors de la modification.";
        }
    }
}

$ch = curl_init($apiBase . "/api/admin/user/" . $id);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["admin_token"]]);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);
if (!empty($data["success"])) {
    $user = $data["user"];
} else {
    $error = $data["message"] ?? "Utilisateur introuvable.";
}

require_once __DIR__ . "/../templates/admin/admin_users_edit_view.php";
