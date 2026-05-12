<?php
session_start();
if (empty($_SESSION["admin_token"])) {
    header("Location: admin_login.php");
    exit;
}

$apiBase = "http://backend:8080";
$error = "";

function apiPost($apiBase, $token, $endpoint, $payload) {
    $ch = curl_init($apiBase . $endpoint);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $token,
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
    $resp = curl_exec($ch);
    curl_close($ch);
    return json_decode($resp, true);
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $action = $_POST["action"] ?? "";

    if ($action === "create") {
        $data = apiPost($apiBase, $_SESSION["admin_token"], "/api/admin/products/create", [
            "name"     => trim($_POST["name"] ?? ""),
            "category" => trim($_POST["category"] ?? ""),
            "price"    => (float)($_POST["price"] ?? 0),
            "link_img" => trim($_POST["link_img"] ?? ""),
        ]);
        if (empty($data["success"])) {
            $error = $data["message"] ?? "Erreur création";
        } else {
            header("Location: admin_boutique.php");
            exit;
        }
    }

    if ($action === "update") {
        $data = apiPost($apiBase, $_SESSION["admin_token"], "/api/admin/products/update", [
            "id"       => (int)($_POST["id"] ?? 0),
            "name"     => trim($_POST["name"] ?? ""),
            "category" => trim($_POST["category"] ?? ""),
            "price"    => (float)($_POST["price"] ?? 0),
            "link_img" => trim($_POST["link_img"] ?? ""),
        ]);
        if (empty($data["success"])) {
            $error = $data["message"] ?? "Erreur mise à jour";
        } else {
            header("Location: admin_boutique.php");
            exit;
        }
    }

    if ($action === "delete") {
        $data = apiPost($apiBase, $_SESSION["admin_token"], "/api/admin/products/delete", [
            "id" => (int)($_POST["id"] ?? 0),
        ]);
        if (empty($data["success"])) {
            $error = $data["message"] ?? "Erreur suppression";
        } else {
            header("Location: admin_boutique.php");
            exit;
        }
    }
}

$items = [];
$ch = curl_init($apiBase . "/api/admin/products");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["admin_token"]]);
$resp = curl_exec($ch);
curl_close($ch);
$data = json_decode($resp, true);
if (!empty($data["success"])) {
    $items = $data["products"] ?? [];
}

include __DIR__ . "/../templates/admin/admin_boutique_view.php";
