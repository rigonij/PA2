<?php
session_start();
if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";
$status  = $_GET["status"] ?? "";
$error   = "";

if ($_SERVER["REQUEST_METHOD"] === "POST" && !empty($_POST["plan"])) {
    $ch = curl_init($apiBase . "/api/stripe/subscribe");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["token"],
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(["plan" => $_POST["plan"]]));
    $response = curl_exec($ch);
    curl_close($ch);
    $data = json_decode($response, true);

    if (!empty($data["checkout_url"])) {
        header("Location: " . $data["checkout_url"]);
        exit;
    }
    $error = $data["message"] ?? "Erreur lors de la création du paiement.";
}

$subscription = null;
$ch = curl_init($apiBase . "/api/senior/subscription");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$r = json_decode(curl_exec($ch), true);
curl_close($ch);

if (!empty($r["has_subscription"])) {
    $subscription = [
        "name"       => $r["name"]       ?? "",
        "end_date"   => $r["end_date"]   ?? "",
        "status"     => $r["status"]     ?? "Inactif",
        "is_renewal" => $r["is_renewal"] ?? false,
    ];
}

$payments = [];
$ch = curl_init($apiBase . "/api/senior/payments");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$r = json_decode(curl_exec($ch), true);
curl_close($ch);
if (!empty($r["payments"])) $payments = $r["payments"];

require_once "../templates/senior/abonnement_view.php";
