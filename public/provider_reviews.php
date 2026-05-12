<?php
require __DIR__ . "/provider_guard.php";

$token = $_SESSION["token"];
$reviews = [];
$loadError = "";

$ch = curl_init("http://backend:8080/api/provider/reviews");
curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HTTPHEADER => ["X-Token: " . $token],
]);
$resp = curl_exec($ch);
$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

if ($code === 200) {
    $data = json_decode($resp, true);
    if (!empty($data["success"])) {
        $reviews = $data["reviews"] ?? [];
    } else {
        $loadError = $data["message"] ?? "Erreur lors du chargement";
    }
} else {
    $loadError = "Impossible de contacter l'API (code " . $code . ")";
}

include __DIR__ . "/../templates/provider/provider_reviews_view.php";
