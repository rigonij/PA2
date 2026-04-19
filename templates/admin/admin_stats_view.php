<?php
$pageTitle = "Admin • Statistiques";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";

function renderStatCard($label, $value)
{
?>
    <div class="col-md-4 col-sm-6">
        <div class="sh-card p-3 text-center">
            <div class="text-muted small mb-1"><?= htmlspecialchars($label) ?></div>
            <div class="fw-bold fs-4"><?= htmlspecialchars((string)$value) ?></div>
        </div>
    </div>
<?php
}
?>

<div class="container py-4">

    <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
        <div>
            <h1 class="h4 mb-1">Statistiques</h1>
            <p class="text-secondary mb-0">Vue globale de l'activité SilverHappy</p>
        </div>
        <a class="btn btn-outline-secondary" href="admin_dashboard.php">← Retour</a>
    </div>

    <div class="mb-3">
        <div class="sh-card p-4">
            <div class="d-flex flex-wrap gap-2">
                <span class="badge text-bg-primary">Total Utilisateurs : <?= (int)($stats["total_users"] ?? 0) ?></span>
                <span class="badge text-bg-primary">Seniors : <?= (int)($stats["total_seniors"] ?? 0) ?></span>
                <span class="badge text-bg-success">Prestataires validés : <?= (int)($stats["total_providers"] ?? 0) ?></span>
                <span class="badge text-bg-warning">Interventions en attente : <?= (int)($stats["pending_interventions"] ?? 0) ?></span>
                <span class="badge text-bg-secondary">Services à valider : <?= (int)($stats["pending_services"] ?? 0) ?></span>
            </div>
        </div>
    </div>

    <div class="mb-4">
        <h2 class="h5 fw-bold mb-2">Utilisateurs</h2>
        <div class="sh-card p-3">
            <div class="row g-3">
                <?php renderStatCard("Seniors inscrits", (int)($stats["total_seniors"] ?? 0)); ?>
                <?php renderStatCard("Prestataires validés", (int)($stats["total_providers"] ?? 0)); ?>
                <?php renderStatCard("Abonnements actifs", (int)($stats["active_subscriptions"] ?? 0)); ?>
            </div>
        </div>
    </div>

    <div class="mb-4">
        <h2 class="h5 fw-bold mb-2">Services & Interventions</h2>
        <div class="sh-card p-3">
            <div class="row g-3">
                <?php renderStatCard("Interventions totales", (int)($stats["total_interventions"] ?? 0)); ?>
                <?php renderStatCard("En attente de confirmation", (int)($stats["pending_interventions"] ?? 0)); ?>
                <?php renderStatCard("Services à valider", (int)($stats["pending_services"] ?? 0)); ?>
            </div>
        </div>
    </div>

    <div class="mb-4">
        <h2 class="h5 fw-bold mb-2">Evenements</h2>
        <div class="sh-card p-3">
            <div class="row g-3">
                <?php renderStatCard("Evenements créés", (int)($stats["total_events"] ?? 0)); ?>
                <?php renderStatCard("Inscriptions totales", (int)($stats["total_event_registrations"] ?? 0)); ?>
            </div>
        </div>
    </div>

    <div class="sh-card p-3 mb-4">
        <h5 class="fw-bold mb-3">Revenus</h5>
        <div class="row g-3">
            <div class="col-md-4">
                <div class="text-muted small mb-1">Total general</div>
                <div class="fs-3 fw-bold text-success">
                    <?= number_format((int)($stats['total_revenue_cents'] ?? 0) / 100, 2, ',', ' ') ?> €
                </div>
            </div>
            <div class="col-md-4">
                <div class="text-muted small mb-1">Boutique</div>
                <div class="fs-3 fw-bold">
                    <?= number_format((int)($stats['shop_revenue_cents'] ?? 0) / 100, 2, ',', ' ') ?> €
                </div>
                <div class="text-muted small"><?= (int)($stats['shop_orders'] ?? 0) ?> commandes</div>
            </div>
            <div class="col-md-4">
                <div class="text-muted small mb-1">Abonnements</div>
                <div class="fs-3 fw-bold">
                    <?= number_format((int)($stats['subscription_revenue_cents'] ?? 0) / 100, 2, ',', ' ') ?> €
                </div>
                <div class="text-muted small"><?= (int)($stats['active_subscriptions'] ?? 0) ?> actifs</div>
            </div>
        </div>
    </div>

</div>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>