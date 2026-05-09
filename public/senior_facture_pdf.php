<?php
session_start();
if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$type = $_GET["type"] ?? "";
$id   = (int)($_GET["id"] ?? 0);
if (!$type || !$id) {
    http_response_code(400);
    echo "Paramètres manquants.";
    exit;
}

$ch = curl_init("http://127.0.0.1:8081/api/senior/invoice/pdf?type=" . urlencode($type) . "&id=" . $id);
curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HTTPHEADER => ["X-Token: " . $_SESSION["token"]],
    CURLOPT_HEADER => false,
]);
$body = curl_exec($ch);
$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

if ($code !== 200) {
    http_response_code($code ?: 500);
    echo "Facture introuvable.";
    exit;
}

$filename = "FAC-" . $type . "-" . $id . ".pdf";
header("Content-Type: application/pdf");
header('Content-Disposition: attachment; filename="' . $filename . '"');
header("Content-Length: " . strlen($body));
echo $body;
