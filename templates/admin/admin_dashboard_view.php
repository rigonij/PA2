<?php
function renderAdminDashboard(array $stats, string $error = ''): void
{
    $pageTitle = "Tableau de bord";
?>
    <?php include __DIR__ . "/../common/head.php"; ?>
    <?php include __DIR__ . "/../common/header.php"; ?>

    <div class="container py-4">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="mb-0">Tableau de bord</h1>
            <span class="text-muted small">Silver Happy — Back office</span>
        </div>

        <?php if (!empty($error)): ?>
            <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
        <?php endif; ?>

        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="sh-card p-3 text-center">
                    <div class="text-muted small mb-1">Total utilisateurs</div>
                    <div class="fs-2 fw-bold text-primary">
                        <?= (int)($stats['total_seniors'] ?? 0) + (int)($stats['total_providers'] ?? 0) ?>
                    </div>
                    <div class="text-muted small mt-1">
                        <?= (int)($stats['total_seniors'] ?? 0) ?> seniors
                        &bull;
                        <?= (int)($stats['total_providers'] ?? 0) ?> prestataires
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="sh-card p-3 text-center">
                    <div class="text-muted small mb-1">Prestataires en attente</div>
                    <div class="fs-2 fw-bold <?= (int)($stats['pending_providers'] ?? 0) > 0 ? 'text-warning' : 'text-success' ?>">
                        <?= (int)($stats['pending_providers'] ?? 0) ?>
                    </div>
                    <a href="admin_providers.php" class="btn btn-sm btn-outline-warning mt-2">Gerer</a>
                </div>
            </div>
            <div class="col-md-3">
                <div class="sh-card p-3 text-center">
                    <div class="text-muted small mb-1">Abonnements actifs</div>
                    <div class="fs-2 fw-bold text-success">
                        <?= (int)($stats['active_subscriptions'] ?? 0) ?>
                    </div>
                    <a href="admin_paiement.php" class="btn btn-sm btn-outline-success mt-2">Voir</a>
                </div>
            </div>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="sh-card p-3 text-center">
                    <div class="text-muted small mb-1">Evenements</div>
                    <div class="fs-2 fw-bold"><?= (int)($stats['total_events'] ?? 0) ?></div>
                    <div class="text-muted small mt-1">
                        <?= (int)($stats['total_event_registrations'] ?? 0) ?> inscriptions
                    </div>
                    <a href="admin_event.php" class="btn btn-sm btn-outline-primary mt-2">Gerer</a>
                </div>
            </div>
            <div class="col-md-4">
                <div class="sh-card p-3 text-center">
                    <div class="text-muted small mb-1">Revenu boutique</div>
                    <div class="fs-2 fw-bold text-success">
                        <?= number_format((int)($stats['shop_revenue_cents'] ?? 0) / 100, 2, ',', ' ') ?> €
                    </div>
                    <div class="text-muted small mt-1">
                        <?= (int)($stats['shop_orders'] ?? 0) ?> commandes
                    </div>
                </div>
            </div>
        </div>

        <div class="sh-card p-3">
            <h5 class="fw-bold mb-3">Acces rapides</h5>
            <div class="d-flex flex-wrap gap-2">
                <a href="admin_users.php" class="btn btn-outline-secondary">Comptes</a>
                <a href="admin_providers.php" class="btn btn-outline-secondary">Prestataires</a>
                <a href="admin_validations.php" class="btn btn-outline-secondary">Validation</a>
                <a href="admin_seniors.php" class="btn btn-outline-secondary">Seniors</a>
                <a href="admin_review_reports.php" class="btn btn-outline-secondary">Signalements d'avis</a>
                <a href="admin_user_reports.php" class="btn btn-outline-secondary">Signalements d'utilisateurs</a>
                <a href="admin_provider_services.php" class="btn btn-outline-secondary">Services</a>
                <a href="admin_event.php" class="btn btn-outline-secondary">Evenements</a>
                <a href="admin_paiement.php" class="btn btn-outline-secondary">Paiements</a>
                <a href="admin_advice.php" class="btn btn-outline-secondary">Conseils</a>
                <a href="admin_stats.php" class="btn btn-outline-primary">Statistiques detaillees</a>
                <a href="admin_logout.php" class="btn btn-outline-danger ms-auto">Deconnexion</a>
            </div>
        </div>

    </div>

    <?php include __DIR__ . "/../common/footer-scripts.php"; ?>
<?php
}
