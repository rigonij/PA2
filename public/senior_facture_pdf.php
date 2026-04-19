<?php
session_start();
if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";
$type = $_GET["type"] ?? "";
$id   = (int)($_GET["id"] ?? 0);

if (!$type || !$id) {
    http_response_code(400);
    echo "Paramètres manquants.";
    exit;
}

$ch = curl_init($apiBase . "/api/senior/invoice?type=" . urlencode($type) . "&id=" . $id);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$data = json_decode(curl_exec($ch), true);
curl_close($ch);

if (empty($data["success"])) {
    http_response_code(404);
    echo "Facture introuvable.";
    exit;
}

$inv = $data["invoice"];
$ref    = htmlspecialchars($inv["ref"]    ?? "");
$date   = htmlspecialchars($inv["date"]   ?? "");
$label  = htmlspecialchars($inv["label"]  ?? "");
$detail = htmlspecialchars($inv["detail"] ?? "");
$amount = number_format((float)($inv["amount"] ?? 0), 2, ",", " ");

header("Content-Type: text/html; charset=utf-8");
?>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <title>Facture <?= $ref ?></title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 40px;
            color: #333;
        }

        .header {
            border-bottom: 2px solid #b8860b;
            padding-bottom: 16px;
            margin-bottom: 24px;
        }

        .header h1 {
            color: #b8860b;
            margin: 0 0 4px;
        }

        .header p {
            margin: 0;
            color: #666;
            font-size: 14px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 24px;
        }

        th {
            text-align: left;
            border-bottom: 1px solid #ccc;
            padding: 8px 4px;
            font-size: 13px;
            color: #555;
        }

        td {
            padding: 10px 4px;
            border-bottom: 1px solid #eee;
        }

        .total {
            font-weight: bold;
            font-size: 16px;
            margin-top: 24px;
            text-align: right;
        }

        .footer {
            margin-top: 40px;
            font-size: 12px;
            color: #999;
            border-top: 1px solid #eee;
            padding-top: 12px;
        }

        @media print {
            .no-print {
                display: none;
            }
        }
    </style>
</head>

<body>
    <div class="header">
        <h1>SilverHappy</h1>
        <p>Facture &amp; reçu de paiement</p>
    </div>

    <p><strong>Référence :</strong> <?= $ref ?></p>
    <p><strong>Date :</strong> <?= $date ?></p>

    <table>
        <thead>
            <tr>
                <th>Objet</th>
                <th>Détail</th>
                <th>Montant</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><?= $label ?></td>
                <td><?= $detail ?></td>
                <td><?= $amount ?> €</td>
            </tr>
        </tbody>
    </table>

    <div class="total">Total : <?= $amount ?> €</div>

    <div class="footer">
        Document généré automatiquement par SilverHappy. Conservez ce reçu à titre de justificatif.
    </div>

    <div class="no-print" style="margin-top:32px;">
        <button onclick="window.print()" style="background:#b8860b;color:#fff;border:none;padding:10px 24px;font-weight:bold;cursor:pointer;border-radius:4px;">
            Imprimer / Enregistrer en PDF
        </button>
    </div>
</body>

</html>