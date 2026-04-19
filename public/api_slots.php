<?php
session_start();

header("Content-Type: application/json; charset=utf-8");

if (empty($_SESSION["token"])) {
    http_response_code(401);
    echo json_encode(["success" => false, "message" => "Non authentifié"]);
    exit;
}

$apiBase = "http://127.0.0.1:8081";

$serviceTypeId = (int)($_GET["service_type_id"] ?? 0);
$providerId = (int)($_GET["provider_id"] ?? 0);
$date = trim($_GET["date"] ?? "");

if ($serviceTypeId <= 0 || $providerId <= 0 || $date === "") {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "Paramètres manquants"]);
    exit;
}

$payload = [
    "service_type_id" => $serviceTypeId,
    "provider_id" => $providerId,
    "date" => $date,
];

$ch = curl_init($apiBase . "/api/services/available-slots");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "Content-Type: application/json",
    "X-Token: " . $_SESSION["token"],
]);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));

$response = curl_exec($ch);
$curlErr = curl_error($ch);
$httpCode = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

if ($response === false) {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Erreur réseau: " . $curlErr]);
    exit;
}

if ($httpCode >= 400) {
    http_response_code($httpCode);
}

echo $response;
