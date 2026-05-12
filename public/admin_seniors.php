<?php
session_start();

if (empty($_SESSION["admin_token"])) {
    header("Location: admin_login.php");
    exit;
}

$apiBase = "http://backend:8080";
$seniors = [];
$error   = "";

// Suppression via POST (bouton formulaire)
if ($_SERVER["REQUEST_METHOD"] === "POST" && !empty($_POST["delete_id"])) {
    $deleteId = (int)$_POST["delete_id"];

    $ch = curl_init($apiBase . "/api/admin/seniors/" . $deleteId);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE");
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["admin_token"]
    ]);
    $response = curl_exec($ch);
    curl_close($ch);
    // Recharge la page après suppression
    header("Location: admin_seniors.php");
    exit;
}

$ch = curl_init($apiBase . "/api/admin/seniors");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["admin_token"]]);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);

if (!empty($data["success"])) {
    $seniors = $data["seniors"];

    foreach ($seniors as &$senior) {
        if (!empty($senior['birth_date'])) {
            $birthDate = new DateTime($senior['birth_date']);
            $today = new DateTime();
            $age = $today->diff($birthDate)->y;
            $senior['age'] = $age;
        } else {
            $senior['age'] = 'N/A';
        }
    }
} else {
    if (isset($data["message"]) && strpos($data["message"], "refusé") !== false) {
        session_destroy();
        header("Location: admin_login.php");
        exit;
    }
    $error = $data["message"] ?? "Erreur lors du chargement des seniors.";
}

require_once __DIR__ . "/../templates/admin/admin_seniors_view.php";
?>