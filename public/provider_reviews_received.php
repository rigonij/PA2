<?php
session_start();

$token = $_SESSION["token"] ?? "";
if (!$token) {
    http_response_code(401);
    echo json_encode(["success" => false, "message" => "Non authentifié"]);
    exit;
}

$ch = curl_init("http://backend:8080/api/provider/reviews");
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
