<?php
session_start();

header("Content-Type: application/json");

if (empty($_SESSION["token"])) {
    http_response_code(401);
    echo json_encode(["success" => false, "message" => "Non authentifié"]);
    exit;
}

$ch = curl_init("http://backend:8080/api/medical/doctors");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "X-Token: " . $_SESSION["token"],
]);
$response = curl_exec($ch);
$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

http_response_code($code);
echo $response;
