<?php
session_start();

if (empty($_SESSION["admin_token"])) {
        header("Location: admin_login.php");
        exit;
}

$apiBase   = "http://backend:8080";
$providers = [];
$error     = "";

if ($_SERVER["REQUEST_METHOD"] === "POST" && !empty($_POST["provider_id"]) && !empty($_POST["action"])) {
        $providerId = (int)$_POST["provider_id"];
        $status     = ($_POST["action"] === "validate") ? 1 : 2;

        $ch = curl_init($apiBase . "/api/admin/providers/" . $providerId . "/validate");
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
                "Content-Type: application/json",
                "X-Token: " . $_SESSION["admin_token"]
        ]);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(["status" => $status]));
        $response = curl_exec($ch);
        curl_close($ch);

        header("Location: admin_providers.php");
        exit;
}

$ch = curl_init($apiBase . "/api/admin/providers");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["admin_token"]]);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);

if (!empty($data["success"])) {
        $providers = $data["providers"];
} else {
        if (isset($data["message"]) && strpos($data["message"], "refusé") !== false) {
                session_destroy();
                header("Location: admin_login.php");
                exit;
        }
        $error = $data["message"] ?? "Erreur lors du chargement des prestataires.";
}

require_once __DIR__ . "/../templates/admin/admin_providers_view.php";
