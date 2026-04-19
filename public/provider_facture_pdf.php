<?php
session_start();
if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";
$id = (int)($_GET["id"] ?? 0);
if ($id <= 0) {
    echo "ID invalide.";
    exit;
}

$ch = curl_init($apiBase . "/api/provider/invoice/" . $id);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$response = curl_exec($ch);
curl_close($ch);

$inv = json_decode($response, true);
if (empty($inv["success"])) {
    echo "Intervention introuvable.";
    exit;
}
?>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <title>Facture #<?= $inv['id'] ?></title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 40px;
            color: #333;
        }

        h1 {
            font-size: 24px;
            margin-bottom: 4px;
        }

        .sub {
            color: #666;
            font-size: 14px;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th {
            background: #f5f5f5;
            padding: 10px;
            text-align: left;
            border-bottom: 2px solid #ddd;
        }

        td {
            padding: 10px;
            border-bottom: 1px solid #eee;
        }

        .total {
            font-weight: bold;
            font-size: 18px;
            margin-top: 20px;
        }

        @media print {
            button {
                display: none;
            }
        }
    </style>
</head>

<body>

    <button onclick="window.print()" style="margin-bottom:20px;padding:8px 16px;cursor:pointer;">Imprimer / Enregistrer PDF</button>

    <h1>Recapitulatif intervention #<?= $inv['id'] ?></h1>
    <div class="sub">Date : <?= htmlspecialchars($inv['date_start']) ?></div>

    <table>
        <tr>
            <th>Champ</th>
            <th>Valeur</th>
        </tr>
        <tr>
            <td>Service</td>
            <td><?= htmlspecialchars($inv['service']) ?></td>
        </tr>
        <tr>
            <td>Prestataire</td>
            <td><?= htmlspecialchars($inv['company']) ?> (<?= htmlspecialchars($inv['provider_nom']) ?>)</td>
        </tr>
        <tr>
            <td>Senior</td>
            <td><?= htmlspecialchars($inv['senior_nom']) ?> — <?= htmlspecialchars($inv['senior_email']) ?></td>
        </tr>
        <tr>
            <td>Debut</td>
            <td><?= htmlspecialchars($inv['date_start']) ?></td>
        </tr>
        <tr>
            <td>Fin</td>
            <td><?= htmlspecialchars($inv['date_end']) ?></td>
        </tr>
        <tr>
            <td>Statut</td>
            <td><?= htmlspecialchars($inv['status']) ?></td>
        </tr>
        <?php if (!empty($inv['comment'])): ?>
            <tr>
                <td>Commentaire</td>
                <td><?= htmlspecialchars($inv['comment']) ?></td>
            </tr>
        <?php endif; ?>
    </table>

    <p class="total">Montant : <?= number_format((float)$inv['montant'], 2, ',', ' ') ?> €</p>

</body>

</html>