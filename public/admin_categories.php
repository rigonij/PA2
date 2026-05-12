<?php
session_start();
if (empty($_SESSION["admin_token"])) {
    header("Location: admin_login.php");
    exit;
}
$apiBase = "http://backend:8080";
$token = $_SESSION["admin_token"];
$error = "";
$success = "";

function api_call($method, $url, $payload, $token) {
    global $apiBase;
    $ch = curl_init($apiBase . $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $token,
    ]);
    if ($payload !== null) {
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
    }
    $resp = curl_exec($ch);
    curl_close($ch);
    return json_decode($resp ?: "", true) ?: [];
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $action = $_POST["action"] ?? "";
    $data = [];
    switch ($action) {
        case "cat_add":
            $data = api_call("POST", "/api/admin/categories", ["name" => trim($_POST["name"] ?? "")], $token);
            break;
        case "cat_edit":
            $data = api_call("PUT", "/api/admin/categories", [
                "id" => (int)($_POST["id"] ?? 0),
                "name" => trim($_POST["name"] ?? ""),
            ], $token);
            break;
        case "cat_del":
            $data = api_call("DELETE", "/api/admin/categories", ["id" => (int)($_POST["id"] ?? 0)], $token);
            break;
        case "type_add":
            $data = api_call("POST", "/api/admin/service-types", [
                "name" => trim($_POST["name"] ?? ""),
                "category_id" => (int)($_POST["category_id"] ?? 0),
                "price" => (float)($_POST["price"] ?? 0),
                "duration_min" => (int)($_POST["duration_min"] ?? 60),
            ], $token);
            break;
        case "type_edit":
            $data = api_call("PUT", "/api/admin/service-types", [
                "id" => (int)($_POST["id"] ?? 0),
                "name" => trim($_POST["name"] ?? ""),
                "category_id" => (int)($_POST["category_id"] ?? 0),
                "price" => (float)($_POST["price"] ?? 0),
                "duration_min" => (int)($_POST["duration_min"] ?? 60),
            ], $token);
            break;
        case "type_del":
            $data = api_call("DELETE", "/api/admin/service-types", ["id" => (int)($_POST["id"] ?? 0)], $token);
            break;
    }
    if (!empty($data["success"])) {
        $success = "Operation reussie.";
    } else {
        $error = $data["message"] ?? "Erreur";
    }
}

$catsResp = api_call("GET", "/api/admin/categories", null, $token);
$categories = $catsResp["items"] ?? [];
$typesResp = api_call("GET", "/api/admin/service-types", null, $token);
$serviceTypes = $typesResp["items"] ?? [];

include __DIR__ . "/../templates/admin/admin_categories_view.php";
