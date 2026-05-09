<?php
session_start();
header("Content-Type: application/json");
if (empty($_SESSION["admin_token"])) {
    http_response_code(401);
    echo json_encode(["success" => false, "message" => "Non authentifié"]);
    exit;
}
$token = $_SESSION["admin_token"];

$body = file_get_contents("php://input");

$ch = curl_init("http://127.0.0.1:8081/api/admin/user-reports/resolve");
curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_POST => true,
    CURLOPT_POSTFIELDS => $body,
    CURLOPT_HTTPHEADER => [
        "X-Token: " . $token,
        "Content-Type: application/json",
    ],
]);
$resp = curl_exec($ch);
$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

http_response_code($code);
echo $resp;
