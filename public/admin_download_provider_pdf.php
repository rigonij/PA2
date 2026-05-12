<?php
session_start();

$apiBase = "http://backend:8080";

if (!isset($_SESSION["admin_token"])) {
    header("Location: admin_login.php");
    exit;
}

$token = $_SESSION["admin_token"];
$id = (int)($_GET["id"] ?? 0);

if ($id <= 0) {
    http_response_code(400);
    echo "ID invalide";
    exit;
}

$ch = curl_init($apiBase . "/api/admin/providers/document/" . $id);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $token]);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HEADER, true);

$response = curl_exec($ch);
$status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$headerSize = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
curl_close($ch);

if ($status !== 200) {
    http_response_code($status);
    echo "Document introuvable";
    exit;
}

$rawHeaders = substr($response, 0, $headerSize);
$body = substr($response, $headerSize);

$filename = "document.pdf";
foreach (explode("\r\n", $rawHeaders) as $h) {
    if (stripos($h, "Content-Disposition:") === 0) {
        if (preg_match('/filename="([^"]+)"/', $h, $m)) {
            $filename = $m[1];
        }
    }
}

header("Content-Type: application/pdf");
header('Content-Disposition: attachment; filename="' . $filename . '"');
header("Content-Length: " . strlen($body));
echo $body;
