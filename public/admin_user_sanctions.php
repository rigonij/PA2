<?php
session_start();
if (empty($_SESSION["admin_token"])) {
    header("Location: login.php");
    exit;
}
$token = $_SESSION["admin_token"];

$userId = isset($_GET["id"]) ? intval($_GET["id"]) : 0;
if ($userId <= 0) {
    header("Location: admin_user_reports.php");
    exit;
}

$sanctions = [];
$userInfo = ["nom" => "", "prenom" => "", "email" => ""];
$warningCount = 0;
$banCount = 0;
$loadError = "";

$ch = curl_init("http://127.0.0.1:8081/api/admin/user-sanctions/" . $userId);
curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HTTPHEADER => ["X-Token: " . $token],
]);
$resp = curl_exec($ch);
$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

if ($code === 200) {
    $d = json_decode($resp, true);
    if (!empty($d["success"])) {
        $sanctions = $d["sanctions"] ?? [];
        $userInfo["nom"] = $d["user_nom"] ?? "";
        $userInfo["prenom"] = $d["user_prenom"] ?? "";
        $userInfo["email"] = $d["user_email"] ?? "";
        $warningCount = $d["warning_count"] ?? 0;
        $banCount = $d["ban_count"] ?? 0;
    } else {
        $loadError = $d["message"] ?? "Erreur";
    }
} else {
    $loadError = "Impossible de contacter l'API (code " . $code . ")";
}

include __DIR__ . "/../templates/admin/admin_user_sanctions_view.php";
