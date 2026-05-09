<?php
session_start();

$token = $_SESSION["token"] ?? "";
if (!$token) {
    http_response_code(401);
    echo json_encode(["success" => false, "message" => "Non authentifié"]);
    exit;
}

$method = $_SERVER["REQUEST_METHOD"];
$base = "http://127.0.0.1:8081/api/senior/reviews";

if ($method === "GET" || $method === "DELETE") {
    $providerId = (int)($_GET["provider_id"] ?? 0);
    $url = $base . "?provider_id=" . $providerId;
    $ch = curl_init($url);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_CUSTOMREQUEST => $method,
        CURLOPT_HTTPHEADER => ["X-Token: " . $token],
    ]);
} else {
    $body = file_get_contents("php://input");
    $ch = curl_init($base);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_CUSTOMREQUEST => "POST",
        CURLOPT_POSTFIELDS => $body,
        CURLOPT_HTTPHEADER => [
            "X-Token: " . $token,
            "Content-Type: application/json",
        ],
    ]);
}

$resp = curl_exec($ch);
$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

http_response_code($code ?: 500);
header("Content-Type: application/json");
echo $resp ?: json_encode(["success" => false, "message" => "Erreur API"]);
