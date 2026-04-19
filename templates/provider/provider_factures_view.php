<?php
function renderProviderFactures(array $invoices, string $error = ''): void
{
?>
    <?php include __DIR__ . "/../common/head.php"; ?>
    <?php include __DIR__ . "/../common/header.php"; ?>

    <div class="container py-4">
        <?php include __DIR__ . "/partials/topbar.php"; ?>
        <div class="row g-3">
            <div class="col-lg-3">
                <?php include __DIR__ . "/partials/sidebar.php"; ?>
            </div>
            <div class="col-lg-9">

                <div class="sh-card p-3 mb-3">
                    <h4 class="fw-bold mb-0">Mes factures</h4>
                    <p class="text-muted mb-0">Recapitulatif des services realises</p>
                </div>

                <?php if (!empty($error)): ?>
                    <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
                <?php endif; ?>

                <div class="sh-card p-3">
                    <?php if (empty($invoices)): ?>
                        <p class="text-muted text-center py-3">Aucune intervention enregistree.</p>
                    <?php else: ?>
                        <table class="table align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Service</th>
                                    <th>Senior</th>
                                    <th>Statut</th>
                                    <th>Montant</th>
                                    <th>PDF</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($invoices as $inv): ?>
                                    <tr>
                                        <td><?= htmlspecialchars($inv['date'] ?? '') ?></td>
                                        <td class="fw-bold"><?= htmlspecialchars($inv['service'] ?? '') ?></td>
                                        <td>
                                            <?= htmlspecialchars($inv['senior_nom'] ?? '') ?><br>
                                            <small class="text-muted"><?= htmlspecialchars($inv['senior_email'] ?? '') ?></small>
                                        </td>
                                        <td>
                                            <?php
                                            $statut = $inv['statut'] ?? '';
                                            $badge = match ($statut) {
                                                'Accepted', 'Confirmed' => 'text-bg-success',
                                                'Pending'               => 'text-bg-warning',
                                                'Canceled'              => 'text-bg-danger',
                                                default                 => 'text-bg-secondary',
                                            };
                                            ?>
                                            <span class="badge <?= $badge ?>"><?= htmlspecialchars($statut) ?></span>
                                        </td>
                                        <td class="fw-bold">
                                            <?= number_format((float)($inv['montant'] ?? 0), 2, ',', ' ') ?> €
                                        </td>
                                        <td>
                                            <a href="provider_facture_pdf.php?id=<?= (int)($inv['id'] ?? 0) ?>"
                                                target="_blank"
                                                class="btn btn-outline-secondary btn-sm">
                                                PDF
                                            </a>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    <?php endif; ?>
                </div>

            </div>
        </div>
    </div>

    <?php include __DIR__ . "/../common/footer.php"; ?>
    <?php include __DIR__ . "/../common/footer-scripts.php"; ?>
<?php
}
