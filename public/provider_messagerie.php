<?php
require __DIR__ . "/provider_guard.php";

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
    header("Location: provider_messagerie.php?with=" . (int)$_POST["receiver_id"]);
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
$withName = "";
if ($withID > 0) {
    $ch = curl_init($apiBase . "/api/messages/" . $withID);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
    $mdata = json_decode(curl_exec($ch), true);
    curl_close($ch);
    $messages = $mdata["messages"] ?? [];
    foreach ($conversations as $c) {
        if ((int)$c["other_id"] === $withID) {
            $withName = $c["display_name"] ?? $conv['prenom'] ?? $conv['nom'] ?? 'Utilisateur';
            break;
        }
    }
}


include __DIR__ . "/../templates/provider/provider_messagerie_view.php";
