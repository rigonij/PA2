<?php
session_start();
if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase = "http://backend:8080";

$ch = curl_init($apiBase . "/api/providers");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$response = curl_exec($ch);
curl_close($ch);



$data = json_decode($response, true);

$providers = $data["providers"] ?? [];

require __DIR__ . "/../templates/senior/catalogue_prestataires_view.php";
renderCataloguePrestataires($providers);
