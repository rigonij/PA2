<?php
session_start();
$apiBase = "http://127.0.0.1:8081";

if (empty($_SESSION["admin_token"])) {
    header("Location: admin_login.php");
    exit;
}

$token = $_SESSION["admin_token"];
$error = "";
$success = "";

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $action = $_POST["action"] ?? "";

    if ($action === "validate_with_services") {
        $providerID = (int)($_POST["provider_id"] ?? 0);
        $authorizedIDs = array_map("intval", $_POST["authorized_service_type_ids"] ?? []);

        $payload = [
            "id" => $providerID,
            "status" => 1,
            "authorized_service_type_ids" => $authorizedIDs,
        ];

        $ch = curl_init($apiBase . "/api/admin/provider-validate-with-services");
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            "Content-Type: application/json",
            "X-Token: " . $token,
        ]);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
        $resp = curl_exec($ch);
        curl_close($ch);

        $data = json_decode($resp ?: "", true);

        if (!empty($data["success"])) {
            $_SESSION["flash_success"] = "Prestataire validé.";
        } else {
            $_SESSION["flash_error"] = $data["message"] ?? "Erreur validation.";
        }

        header("Location: admin_validations.php");
        exit;
    }

    if ($action === "reject_provider") {
        $providerID = (int)($_POST["provider_id"] ?? 0);

        $payload = [
            "id" => $providerID,
            "status" => 2,
        ];

        $ch = curl_init($apiBase . "/api/admin/providers/validate");
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            "Content-Type: application/json",
            "X-Token: " . $token,
        ]);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
        $resp = curl_exec($ch);
        curl_close($ch);

        $data = json_decode($resp ?: "", true);

        if (!empty($data["success"])) {
            $_SESSION["flash_success"] = "Prestataire refusé.";
        } else {
            $_SESSION["flash_error"] = $data["message"] ?? "Erreur refus.";
        }

        header("Location: admin_validations.php");
        exit;
    }
}

$success = $_SESSION["flash_success"] ?? "";
$error = $_SESSION["flash_error"] ?? "";
unset($_SESSION["flash_success"], $_SESSION["flash_error"]);

$filter = $_GET["status"] ?? "";
$url = $apiBase . "/api/admin/providers/pending";
if ($filter !== "") {
    $url .= "?status=" . urlencode($filter);
}

$ch = curl_init($url);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $token]);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$data = json_decode(curl_exec($ch), true);
curl_close($ch);

$providers = $data["providers"] ?? [];

include __DIR__ . "/../templates/admin/admin_validations_view.php";
