<?php
function renderAdminPaiement(array $payments, string $error = ''): void
{
    $pageTitle = "Paiements";
?>
    <?php include __DIR__ . "/../common/head.php"; ?>
    <?php include __DIR__ . "/../common/header.php"; ?>

    <div class="container py-4">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h1 class="mb-0">Paiements</h1>
            <a href="admin_dashboard.php" class="btn btn-outline-secondary btn-sm">Retour</a>
        </div>

        <?php if (!empty($error)): ?>
            <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
        <?php endif; ?>

        <div class="sh-card p-3">
            <table class="table table-striped align-middle mb-0">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Date</th>
                        <th>Senior</th>
                        <th>Email</th>
                        <th>Montant</th>
                        <th>Type</th>
                        <th>Recapitulatif</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (empty($payments)): ?>
                        <tr>
                            <td colspan="7" class="text-center text-muted">Aucun paiement.</td>
                        </tr>
                    <?php else: ?>
                        <?php foreach ($payments as $p): ?>
                            <tr>
                                <td><?= (int)$p['id'] ?></td>
                                <td><?= htmlspecialchars(fmt_dt($p['date'])) ?></td>
                                <td><?= htmlspecialchars($p['nom']) ?></td>
                                <td><?= htmlspecialchars($p['email']) ?></td>
                                <td class="fw-bold">
                                    <?= number_format((int)$p['montant'] / 100, 2, ',', ' ') ?> €
                                </td>
                                <td>
                                    <?php if ($p['type'] === 'boutique'): ?>
                                        <span class="badge text-bg-primary">Boutique</span>
                                    <?php else: ?>
                                        <span class="badge text-bg-success">Abonnement</span>
                                    <?php endif; ?>
                                </td>
                                <td>
                                    <a href="admin_paiement_pdf.php?id=<?= (int)$p['ref_id'] ?>&type=<?= htmlspecialchars($p['type']) ?>"
                                        target="_blank"
                                        class="btn btn-outline-secondary btn-sm">
                                        PDF
                                    </a>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>

    </div>

    <?php include __DIR__ . "/../common/footer-scripts.php"; ?>
<?php
}
