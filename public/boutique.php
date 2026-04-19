<?php
session_start();
if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";
$action  = $_GET["action"] ?? "";
$id      = (int)($_GET["id"] ?? 0);
$status  = $_GET["status"] ?? "";

if ($action === "add" && $id > 0) {
    $ch = curl_init($apiBase . "/api/cart/add");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["token"],
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(["product_id" => $id]));
    curl_exec($ch);
    curl_close($ch);
    header("Location: boutique.php");
    exit;
}

if ($action === "dec" && $id > 0) {
    $ch = curl_init($apiBase . "/api/cart/decrement");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["token"],
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(["product_id" => $id]));
    curl_exec($ch);
    curl_close($ch);
    header("Location: boutique.php");
    exit;
}

if ($action === "clear") {
    $ch = curl_init($apiBase . "/api/cart/clear");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["token"],
    ]);
    curl_exec($ch);
    curl_close($ch);
    header("Location: boutique.php");
    exit;
}

if ($action === "checkout") {
    $ch = curl_init($apiBase . "/api/stripe/checkout/shop");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "X-Token: " . $_SESSION["token"],
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(new stdClass()));
    $response = curl_exec($ch);
    curl_close($ch);

    $data = json_decode($response, true);

    if (!empty($data["checkout_url"])) {
        header("Location: " . $data["checkout_url"]);
        exit;
    }
    $status = "error";
}

$ch = curl_init($apiBase . "/api/shop/products");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$response = curl_exec($ch);
curl_close($ch);
$dataProducts = json_decode($response, true);
$products = $dataProducts["products"] ?? [];

$ch = curl_init($apiBase . "/api/cart");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$response = curl_exec($ch);
curl_close($ch);
$dataCart = json_decode($response, true);
$cartItems      = $dataCart["items"]      ?? [];
$cartTotalQty   = (int)($dataCart["total_qty"]   ?? 0);
$cartTotalPrice = (float)($dataCart["total_price"] ?? 0.0);

$cartQtyByProductId = [];
foreach ($cartItems as $ci) {
    $pid = (int)($ci["Id_PRODUCT"] ?? 0);
    $qty = (int)($ci["Qty"] ?? 0);
    if ($pid > 0) {
        $cartQtyByProductId[$pid] = $qty;
    }
}

require_once __DIR__ . "/../templates/senior/boutique_view.php";
