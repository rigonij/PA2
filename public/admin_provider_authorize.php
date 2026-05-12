<?php
session_start();
header("Content-Type: application/json");
$apiBase = "http://backend:8080";

if (empty($_SESSION["admin_token"])) {
    http_response_code(401);
    echo json_encode(["success" => false, "message" => "Non authentifié"]);
    exit;
}

$providerID = (int)($_GET["id"] ?? 0);
if ($providerID <= 0) {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "id invalide"]);
    exit;
}

$ch = curl_init($apiBase . "/api/admin/provider-authorized-services/" . $providerID);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "X-Token: " . $_SESSION["admin_token"],
]);
$resp = curl_exec($ch);
$status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

http_response_code($status ?: 500);
echo $resp ?: json_encode(["success" => false, "message" => "Pas de réponse API"]);
