<?php
session_start();
if (empty($_SESSION["admin_token"])) {
    header("Location: admin_login.php");
    exit;
}

$apiBase = "http://backend:8080";
$id      = (int)($_GET["id"] ?? 0);
$type    = $_GET["type"] ?? "";

if ($id <= 0 || !in_array($type, ["boutique", "abonnement"])) {
    die("Parametre invalide.");
}

$detail = null;
$items  = [];

if ($type === "boutique") {
    $ch = curl_init($apiBase . "/api/admin/payment-detail?id=" . $id . "&type=boutique");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["admin_token"]]);
    $r = curl_exec($ch);
    curl_close($ch);
    $d = json_decode($r, true);
    if (!empty($d["success"])) {
        $detail = $d["payment"];
        $items = $d["items"] ?? [];
    }
} else {
    $ch = curl_init($apiBase . "/api/admin/payment-detail?id=" . $id . "&type=abonnement");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["admin_token"]]);
    $r = curl_exec($ch);
    curl_close($ch);
    $d = json_decode($r, true);
    if (!empty($d["success"])) {
        $detail = $d["payment"];
    }
}
?>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <title>Recapitulatif paiement</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        @media print {
            .no-print {
                display: none;
            }
        }

        body {
            background: white;
        }
    </style>
</head>

<body class="p-4">

    <div class="d-flex justify-content-between align-items-start mb-4">
        <div>
            <h3 class="fw-bold">Silver Happy</h3>
            <p class="text-muted mb-0">Recapitulatif de paiement</p>
        </div>
        <button onclick="window.print()" class="btn btn-outline-primary no-print">Imprimer / PDF</button>
    </div>

    <hr>

    <?php if ($detail): ?>
        <div class="row mb-4">
            <div class="col-md-6">
                <strong>Client</strong><br>
                <?= htmlspecialchars($detail['nom'] ?? '') ?><br>
                <?= htmlspecialchars($detail['email'] ?? '') ?>
            </div>
            <div class="col-md-6 text-end">
                <strong>Date</strong><br>
                <?= htmlspecialchars($detail['date'] ?? '') ?><br>
                <strong>Type :</strong>
                <?= $type === 'boutique' ? 'Commande boutique' : 'Abonnement' ?>
            </div>
        </div>

        <?php if ($type === 'boutique' && !empty($items)): ?>
            <table class="table table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Produit</th>
                        <th class="text-end">Prix unit.</th>
                        <th class="text-center">Qte</th>
                        <th class="text-end">Sous-total</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($items as $item): ?>
                        <tr>
                            <td><?= htmlspecialchars($item['name'] ?? '') ?></td>
                            <td class="text-end"><?= number_format((int)($item['price_cents'] ?? 0) / 100, 2, ',', ' ') ?> €</td>
                            <td class="text-center"><?= (int)($item['qty'] ?? 1) ?></td>
                            <td class="text-end fw-bold">
                                <?= number_format((int)($item['price_cents'] ?? 0) * (int)($item['qty'] ?? 1) / 100, 2, ',', ' ') ?> €
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="3" class="text-end fw-bold">Total</td>
                        <td class="text-end fw-bold">
                            <?= number_format((int)($detail['montant'] ?? 0) / 100, 2, ',', ' ') ?> €
                        </td>
                    </tr>
                </tfoot>
            </table>
        <?php elseif ($type === 'abonnement'): ?>
            <table class="table table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Plan</th>
                        <th>Debut</th>
                        <th>Fin</th>
                        <th class="text-end">Montant</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><?= htmlspecialchars($detail['plan'] ?? '') ?></td>
                        <td><?= htmlspecialchars($detail['start_date'] ?? '') ?></td>
                        <td><?= htmlspecialchars($detail['end_date'] ?? '') ?></td>
                        <td class="text-end fw-bold">
                            <?= number_format((int)($detail['montant'] ?? 0) / 100, 2, ',', ' ') ?> €
                        </td>
                    </tr>
                </tbody>
            </table>
        <?php endif; ?>

    <?php else: ?>
        <div class="alert alert-warning">Paiement introuvable.</div>
    <?php endif; ?>

</body>

</html>