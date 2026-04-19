<?php
session_start();

if (empty($_SESSION["admin_token"])) {
    header("Location: admin_login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";
$users   = [];
$error   = "";

if ($_SERVER["REQUEST_METHOD"] === "POST" && !empty($_POST["ban_id"])) {
    $banId = (int)$_POST["ban_id"];
    $ch = curl_init($apiBase . "/api/admin/ban");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["admin_token"],
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(["user_id" => $banId]));
    $response = curl_exec($ch);
    curl_close($ch);
    header("Location: admin_users.php");
    exit;
}

if ($_SERVER["REQUEST_METHOD"] === "POST" && !empty($_POST["unban_id"])) {
    $unbanId = (int)$_POST["unban_id"];
    $ch = curl_init($apiBase . "/api/admin/unban");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["admin_token"],
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(["user_id" => $unbanId]));
    $response = curl_exec($ch);
    curl_close($ch);
    header("Location: admin_users.php");
    exit;
}

if ($_SERVER["REQUEST_METHOD"] === "POST" && !empty($_POST["delete_id"])) {
    $deleteId = (int)$_POST["delete_id"];
    $ch = curl_init($apiBase . "/api/admin/user/" . $deleteId);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE");
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["admin_token"]
    ]);
    $response = curl_exec($ch);
    curl_close($ch);
    header("Location: admin_users.php");
    exit;
}

$ch = curl_init($apiBase . "/api/admin/users");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["admin_token"]]);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);

if (!empty($data["success"])) {
    $users = $data["users"];
} else {
    if (isset($data["message"]) && strpos($data["message"], "refusé") !== false) {
        session_destroy();
        header("Location: admin_login.php");
        exit;
    }
    $error = $data["message"] ?? "Erreur lors du chargement des utilisateurs.";
}

require_once __DIR__ . "/../templates/admin/admin_users_view.php";
