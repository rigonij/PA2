<?php
session_start();

$token = $_SESSION["token"] ?? "";
if (!$token) {
    http_response_code(401);
    echo json_encode(["success" => false, "message" => "Non authentifié"]);
    exit;
}

$providerId = (int)($_GET["provider_id"] ?? 0);
if ($providerId <= 0) {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "provider_id invalide"]);
    exit;
}

$url = "http://backend:8080/api/providers/" . $providerId . "/reviews";
$ch = curl_init($url);
curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HTTPHEADER => ["X-Token: " . $token],
]);
$resp = curl_exec($ch);
$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

http_response_code($code ?: 500);
header("Content-Type: application/json");
echo $resp ?: json_encode(["success" => false, "message" => "Erreur API"]);
