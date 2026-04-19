<?php
session_start();

if (empty($_SESSION["admin_token"])) {
    header("Location: admin_login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";
$error = "";
$success = "";
$items = [];

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $providerId = (int)($_POST["provider_id"] ?? 0);
    $serviceTypeId = (int)($_POST["service_type_id"] ?? 0);
    $status = (int)($_POST["status"] ?? -1);

    if ($providerId > 0 && $serviceTypeId > 0 && in_array($status, [0, 1, 2], true)) {
        $payload = [
            "provider_id" => $providerId,
            "service_type_id" => $serviceTypeId,
            "status" => $status,
        ];

        $ch = curl_init($apiBase . "/api/admin/provider-services");
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            "Content-Type: application/json",
            "X-Token: " . $_SESSION["admin_token"],
        ]);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));

        $resp = curl_exec($ch);
        curl_close($ch);

        $data = json_decode($resp ?: "", true);

        if (!empty($data["success"])) {
            if ($status === 1) $success = "Service validé.";
            else if ($status === 2) $success = "Service refusé.";
            else $success = "Service repassé en attente.";
        } else {
            $msg = $data["message"] ?? "";

            if (strpos($msg, "refusé") !== false) {
                session_destroy();
                header("Location: admin_login.php");
                exit;
            }

            $error = $msg ?: "Erreur action.";
        }
    } else {
        $error = "Paramètres invalides.";
    }
}

$ch = curl_init($apiBase . "/api/admin/provider-services");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "X-Token: " . $_SESSION["admin_token"],
]);
$resp = curl_exec($ch);
curl_close($ch);

$data = json_decode($resp ?: "", true);

if (!empty($data["success"])) {
    $items = $data["items"] ?? [];
} else {
    $msg = $data["message"] ?? "";

    if (strpos($msg, "refusé") !== false) {
        session_destroy();
        header("Location: admin_login.php");
        exit;
    }

    $error = $error ?: ($msg ?: "Erreur chargement.");
}

require __DIR__ . "/../templates/admin/admin_provider_services_view.php";
