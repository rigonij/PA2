<?php
session_start();
if (empty($_SESSION["token"])) {
    http_response_code(401);
    header("Content-Type: application/json");
    echo json_encode(["success" => false, "message" => "Non authentifié"]);
    exit;
}

$id = (int)($_GET["id"] ?? 0);
if ($id <= 0) {
    http_response_code(400);
    header("Content-Type: application/json");
    echo json_encode(["success" => false, "message" => "ID invalide"]);
    exit;
}

$ch = curl_init("http://backend:8080/api/advice/" . $id);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$resp = curl_exec($ch);
$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

http_response_code($code);
header("Content-Type: application/json");
echo $resp;
