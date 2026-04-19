<?php
$pageTitle = "SilverHappy • Finances";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";
?>
<div class="container py-4">
    <?php include __DIR__ . "/partials/topbar.php"; ?>
    <div class="row g-3">
        <div class="col-lg-3">
            <?php include __DIR__ . "/partials/sidebar.php"; ?>
        </div>
        <div class="col-lg-9">

            <div class="sh-card p-4 mb-3">
                <h1 class="h4 mb-1">Finances • Mes factures</h1>
            </div>

            <?php if (!empty($errorMsg)): ?>
                <div class="alert alert-danger"><?= htmlspecialchars($errorMsg) ?></div>
            <?php endif; ?>

            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <div class="sh-card p-3 text-center">
                        <div class="text-secondary small mb-1">Revenus totaux</div>
                        <div class="fw-bold fs-4">
                            <?= number_format($totalRev, 2, ',', ' ') ?> €
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="sh-card p-3 text-center">
                        <div class="text-secondary small mb-1">Interventions réalisées</div>
                        <div class="fw-bold fs-4"><?= $totalCount ?></div>
                    </div>
                </div>
            </div>

            <div class="sh-card p-3">
                <h2 class="h6 mb-3">Détail des interventions</h2>

                <?php if (empty($invoices)): ?>
                    <div class="text-secondary">Aucune intervention réalisée pour le moment.</div>
                <?php else: ?>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Service</th>
                                    <th>Senior</th>
                                    <th>Date</th>
                                    <th>Statut</th>
                                    <th class="text-end">Montant</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($invoices as $inv): ?>
                                    <?php
                                    $dateLabel = date("d/m/Y H:i", strtotime($inv["date_start"] ?? ""));
                                    $seniorName = trim(($inv["senior_prenom"] ?? "") . " " . ($inv["senior_nom"] ?? ""));
                                    $price = (float)($inv["price"] ?? 0);
                                    $status = $inv["status"] ?? "";
                                    $statusLabel = match ($status) {
                                        "Accepted"  => ["Acceptée",  "text-bg-success"],
                                        "Completed" => ["Terminée",  "text-bg-primary"],
                                        "Done"      => ["Terminée",  "text-bg-primary"],
                                        default     => [$status,     "text-bg-secondary"],
                                    };
                                    ?>
                                    <tr>
                                        <td class="text-secondary small">#<?= (int)$inv["id"] ?></td>
                                        <td class="fw-bold"><?= htmlspecialchars($inv["service_name"] ?? "") ?></td>
                                        <td><?= htmlspecialchars($seniorName ?: "Senior") ?></td>
                                        <td class="text-secondary small"><?= $dateLabel ?></td>
                                        <td>
                                            <span class="badge <?= $statusLabel[1] ?>">
                                                <?= $statusLabel[0] ?>
                                            </span>
                                        </td>
                                        <td class="text-end fw-bold">
                                            <?= $price > 0
                                                ? number_format($price, 2, ',', ' ') . ' €'
                                                : '<span class="text-secondary">—</span>'
                                            ?>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                            <tfoot>
                                <tr class="table-light">
                                    <td colspan="5" class="fw-bold text-end">Total</td>
                                    <td class="text-end fw-bold">
                                        <?= number_format($totalRev, 2, ',', ' ') ?> €
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                <?php endif; ?>
            </div>

        </div>
    </div>
</div>
<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>