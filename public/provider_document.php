<?php
session_start();

$apiBase = "http://127.0.0.1:8081";

if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$error = $_SESSION["flash_error"] ?? "";
$success = $_SESSION["flash_success"] ?? "";
unset($_SESSION["flash_error"], $_SESSION["flash_success"]);

if ($_SERVER["REQUEST_METHOD"] === "POST" && !empty($_FILES["document"])) {
    if ($_FILES["document"]["error"] !== UPLOAD_ERR_OK) {
        $_SESSION["flash_error"] = "Erreur d'upload (code " . $_FILES["document"]["error"] . ")";
        header("Location: provider_document.php");
        exit;
    }

    $cfile = new CURLFile(
        $_FILES["document"]["tmp_name"],
        $_FILES["document"]["type"] ?: "application/pdf",
        $_FILES["document"]["name"]
    );

    $ch = curl_init($apiBase . "/api/provider/document");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "X-Token: " . $_SESSION["token"],
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, ["document" => $cfile]);
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    $dataUpload = json_decode($response, true);

    if ($httpCode >= 400 || empty($dataUpload["success"])) {
        $_SESSION["flash_error"] = $dataUpload["message"] ?? ("Erreur upload (HTTP " . $httpCode . ")");
    } else {
        $_SESSION["flash_success"] = "Document envoyé. Validation en cours.";
    }

    header("Location: provider_document.php");
    exit;
}

$ch = curl_init($apiBase . "/api/provider/document/me");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "X-Token: " . $_SESSION["token"],
]);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);

$existing = [
    "has_document" => !empty($data["has_document"]),
    "filename" => $data["filename"] ?? "",
    "size" => (int)($data["size"] ?? 0),
    "uploaded_at" => $data["uploaded_at"] ?? "",
];

require_once __DIR__ . "/../templates/provider/provider_document_view.php";
