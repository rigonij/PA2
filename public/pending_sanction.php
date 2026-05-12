<?php
session_start();
header("Content-Type: application/json");
if (empty($_SESSION["token"])) {
    echo json_encode(["success" => true, "sanction" => null]);
    exit;
}
$token = $_SESSION["token"];

$ch = curl_init("http://backend:8080/api/me/pending-sanction");
curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HTTPHEADER => ["X-Token: " . $token],
]);
$resp = curl_exec($ch);
$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

http_response_code($code);
echo $resp;
