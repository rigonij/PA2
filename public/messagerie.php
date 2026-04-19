<?php
session_start();
$apiBase = "http://127.0.0.1:8081";
if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$openUserId = (int)($_GET["open_user"] ?? 0);

if ($openUserId > 0 && empty($_GET["with"])) {
    header("Location: messagerie.php?with=" . $openUserId);
    exit;
}


if ($_SERVER["REQUEST_METHOD"] === "POST" && !empty($_POST["receiver_id"]) && !empty($_POST["content"])) {
    $ch = curl_init($apiBase . "/api/messages/send");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ["Content-Type: application/json", "X-Token: " . $_SESSION["token"]]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
        "receiver_id" => (int)$_POST["receiver_id"],
        "content"     => trim($_POST["content"]),
    ]));
    curl_exec($ch);
    curl_close($ch);
    header("Location: messagerie.php?with=" . (int)$_POST["receiver_id"]);
    exit;
}

$ch = curl_init($apiBase . "/api/messages");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$data = json_decode(curl_exec($ch), true);
curl_close($ch);
$conversations = $data["conversations"] ?? [];

$withID = (int)($_GET["with"] ?? 0);
$messages = [];

if ($withID > 0) {
    $ch = curl_init($apiBase . "/api/messages/" . $withID);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
    $resp = curl_exec($ch);
    curl_close($ch);
    $data2 = json_decode($resp, true);
    $messages = $data2["messages"] ?? [];
}

$withName = "Inconnu";
if ($withID > 0) {
    foreach ($messages as $m) {
        if (!$m["is_mine"]) {
            $withName = $m["sender_name"];
            break;
        }
    }
    if ($withName === "Inconnu" && !empty($messages)) {
        $withName = $messages[0]["sender_name"] ?? "Inconnu";
    }
}

$pageTitle = "SilverHappy • Messagerie";
include __DIR__ . "/../templates/common/head.php";
include __DIR__ . "/../templates/common/header.php";
include __DIR__ . "/../templates/senior/messagerie_view.php";
include __DIR__ . "/../templates/common/footer.php";
include __DIR__ . "/../templates/common/footer-scripts.php";
