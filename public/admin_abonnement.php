<?php
session_start();
if (empty($_SESSION["admin_token"])) {
    header("Location: admin_login.php");
    exit;
}

$apiBase = "http://backend:8080";
$error   = "";
$success = "";

if ($_SERVER["REQUEST_METHOD"] === "POST" && ($_POST["action"] ?? "") === "update") {
    $body = [
        "id"              => (int)($_POST["id"] ?? 0),
        "display_name"    => trim($_POST["display_name"] ?? ""),
        "price"           => (float)str_replace(",", ".", $_POST["price"] ?? "0"),
        "duration_months" => (int)($_POST["duration_months"] ?? 0),
    ];
    $ch = curl_init($apiBase . "/api/admin/subscription-plans/update");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["admin_token"],
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($body));
    $resp = json_decode(curl_exec($ch), true);
    curl_close($ch);
    if (!empty($resp["success"])) {
        $success = "Plan modifié.";
    } else {
        $error = $resp["message"] ?? "Erreur";
    }
}

$plans = [];
$ch = curl_init($apiBase . "/api/admin/subscription-plans");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["admin_token"]]);
$r = json_decode(curl_exec($ch), true);
curl_close($ch);
if (!empty($r["plans"])) $plans = $r["plans"];

$typeLabels = [
    "monthly_normal"  => "Abonnement mensuel",
    "yearly_normal"   => "Abonnement annuel",
    "monthly_renewal" => "Renouvellement mensuel",
    "yearly_renewal"  => "Renouvellement annuel",
];

require_once "../templates/admin/admin_abonnement_view.php";
