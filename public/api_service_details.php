<?php
session_start();
if (empty($_SESSION["token"])) {
    http_response_code(401);
    echo json_encode(["success" => false, "message" => "Non authentifié"]);
    exit;
}

$serviceTypeId = (int)($_GET["service_type_id"] ?? 0);
$providerId = (int)($_GET["provider_id"] ?? 0);

$url = "http://127.0.0.1:8081/api/services/details?service_type_id=" . $serviceTypeId . "&provider_id=" . $providerId;

$ch = curl_init($url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "X-Token: " . $_SESSION["token"],
]);
$resp = curl_exec($ch);
$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

http_response_code($code);
header("Content-Type: application/json");
echo $resp;
