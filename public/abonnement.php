<?php
session_start();
if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase = "http://backend:8080";
$status  = $_GET["status"] ?? "";
$error   = "";

$action = $_POST["action"] ?? "";

if ($_SERVER["REQUEST_METHOD"] === "POST" && $action === "cancel") {
    $ch = curl_init($apiBase . "/api/senior/subscription/cancel");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
    curl_exec($ch);
    curl_close($ch);
    header("Location: abonnement.php?status=unsubscribed");
    exit;
}

if ($_SERVER["REQUEST_METHOD"] === "POST" && $action === "ack_notifications") {
    $ch = curl_init($apiBase . "/api/senior/subscription-notifications/ack");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
    curl_exec($ch);
    curl_close($ch);
    header("Location: abonnement.php");
    exit;
}

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
    $error = $data["message"] ?? "Erreur lors de la creation du paiement.";
}

$subscription = null;
$ch = curl_init($apiBase . "/api/senior/subscription");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$r = json_decode(curl_exec($ch), true);
curl_close($ch);
if (!empty($r["has_subscription"])) { $subscription = $r; }

$plans = [];
$ch = curl_init($apiBase . "/api/senior/subscription-plans");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$r = json_decode(curl_exec($ch), true);
curl_close($ch);
if (!empty($r["plans"])) $plans = $r["plans"];

$payments = [];
$ch = curl_init($apiBase . "/api/senior/payments");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$r = json_decode(curl_exec($ch), true);
curl_close($ch);
if (!empty($r["payments"])) $payments = $r["payments"];

$notifications = [];
$ch = curl_init($apiBase . "/api/senior/subscription-notifications");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$r = json_decode(curl_exec($ch), true);
curl_close($ch);
if (!empty($r["notifications"])) $notifications = $r["notifications"];

require_once "../templates/senior/abonnement_view.php";
