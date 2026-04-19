<?php
session_start();

if (empty($_SESSION["token"])) {
	header("Location: login.php");
	exit;
}

$apiBase = "http://127.0.0.1:8081";

$errorMsg = $_SESSION["flash_error"] ?? "";
$successMsg = $_SESSION["flash_success"] ?? "";
unset($_SESSION["flash_error"], $_SESSION["flash_success"]);

if ($_SERVER["REQUEST_METHOD"] === "POST" && ($_POST["action"] ?? "") === "reserve_service") {
	$payload = [
		"service_type_id" => (int)($_POST["service_type_id"] ?? 0),
		"provider_id" => (int)($_POST["provider_id"] ?? 0),
		"start_at" => trim($_POST["start_at"] ?? ""),
		"comment" => trim($_POST["comment"] ?? ""),
	];

	if (empty($payload["start_at"])) {
		$_SESSION["flash_error"] = "Veuillez choisir un créneau.";
		header("Location: prestations.php");
		exit;
	}

	$ch = curl_init($apiBase . "/api/services/reserve");
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_POST, true);
	curl_setopt($ch, CURLOPT_HTTPHEADER, [
		"Content-Type: application/json",
		"X-Token: " . $_SESSION["token"],
	]);
	curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));

	$response = curl_exec($ch);

	$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
	curl_close($ch);

	$dataReserve = json_decode($response, true);

	if ($httpCode >= 400 || empty($dataReserve["success"])) {
		$msg = $dataReserve["message"] ?? ("Erreur réservation service (HTTP " . $httpCode . ")");
		$_SESSION["flash_error"] = $msg;
	} else {
		$_SESSION["flash_success"] = "Réservation enregistrée.";
	}

	header("Location: prestations.php");
	exit;
}

$ch = curl_init($apiBase . "/api/services");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
	"X-Token: " . $_SESSION["token"],
]);
$response = curl_exec($ch);
curl_close($ch);


$data = json_decode($response, true);
if (empty($data["success"])) {
	$errorMsg = $data["message"] ?? "Erreur chargement services.";
	$categories = [];
} else {
	$categories = $data["categories"] ?? [];
}

require_once __DIR__ . "/../templates/senior/prestations_view.php";
