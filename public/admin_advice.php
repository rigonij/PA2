<?php
session_start();
if (empty($_SESSION["admin_token"])) {
    header("Location: admin_login.php");
    exit;
}

$apiBase = "http://backend:8080";
$error = "";

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $action = $_POST["action"] ?? "";

    if ($action === "create") {
        $payload = [
            "title" => trim($_POST["title"] ?? ""),
            "excerpt" => trim($_POST["excerpt"] ?? ""),
            "content" => trim($_POST["content"] ?? ""),
        ];
        $ch = curl_init($apiBase . "/api/admin/advice/create");
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            "Content-Type: application/json",
            "X-Token: " . $_SESSION["admin_token"],
        ]);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
        $resp = curl_exec($ch);
        curl_close($ch);
        $data = json_decode($resp, true);
        if (empty($data["success"])) {
            $error = $data["message"] ?? "Erreur création";
        } else {
            header("Location: admin_advice.php");
            exit;
        }
    }

    if ($action === "update") {
        $payload = [
            "id" => (int)($_POST["id"] ?? 0),
            "title" => trim($_POST["title"] ?? ""),
            "excerpt" => trim($_POST["excerpt"] ?? ""),
            "content" => trim($_POST["content"] ?? ""),
        ];
        $ch = curl_init($apiBase . "/api/admin/advice/update");
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            "Content-Type: application/json",
            "X-Token: " . $_SESSION["admin_token"],
        ]);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
        $resp = curl_exec($ch);
        curl_close($ch);
        $data = json_decode($resp, true);
        if (empty($data["success"])) {
            $error = $data["message"] ?? "Erreur mise à jour";
        } else {
            header("Location: admin_advice.php");
            exit;
        }
    }

    if ($action === "delete") {
        $payload = ["id" => (int)($_POST["id"] ?? 0)];
        $ch = curl_init($apiBase . "/api/admin/advice/delete");
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            "Content-Type: application/json",
            "X-Token: " . $_SESSION["admin_token"],
        ]);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
        $resp = curl_exec($ch);
        curl_close($ch);
        $data = json_decode($resp, true);
        if (empty($data["success"])) {
            $error = $data["message"] ?? "Erreur suppression";
        } else {
            header("Location: admin_advice.php");
            exit;
        }
    }
}

$items = [];
$ch = curl_init($apiBase . "/api/advice");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "X-Token: " . $_SESSION["admin_token"],
]);
$resp = curl_exec($ch);
curl_close($ch);
$data = json_decode($resp, true);
if (!empty($data["success"])) {
    $items = $data["advices"] ?? [];
}

include __DIR__ . "/../templates/admin/admin_advice_view.php";
