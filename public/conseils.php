<?php
session_start();
if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";

$ch = curl_init($apiBase . "/api/advice");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "X-Token: " . $_SESSION["token"],
]);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);
$advices = $data["advices"] ?? [];

include __DIR__ . "/../templates/senior/conseils_view.php";
