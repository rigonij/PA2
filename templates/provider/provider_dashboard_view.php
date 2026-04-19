<?php
$pageTitle = "SilverHappy • Prestataire • Dashboard";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";
?>

<div class="container py-4">
    <?php include __DIR__ . "/partials/topbar.php"; ?>

    <div class="row g-3">
        <div class="col-lg-3">
            <?php
            include __DIR__ . "/partials/sidebar.php";
            ?>
        </div>

        <div class="col-lg-9">
            <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
                <div>
                    <h1 class="h4 mb-1">Dashboard • Prestataire</h1>
                    <p class="text-secondary mb-0">Bienvenue sur votre espace prestataire.</p>
                </div>

            </div>

            <?php if (!empty($error)): ?>
                <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
            <?php endif; ?>

            <?php if (!empty($provider)): ?>
                <?php
                $status = (int)($provider["validation_status"] ?? 0);
                $label = "En attente";
                $badge = "text-bg-secondary";
                if ($status === 1) {
                    $label = "Validé";
                    $badge = "text-bg-success";
                }
                if ($status === 2) {
                    $label = "Refusé";
                    $badge = "text-bg-danger";
                }
                ?>

                <div class="sh-card p-4 mb-3">
                    <div class="d-flex justify-content-between align-items-start gap-3">
                        <div>
                            <div class="fw-bold">
                                <?= htmlspecialchars($provider["company_name"] ?? "Entreprise") ?>
                            </div>
                            <div class="text-secondary">Statut du compte</div>
                        </div>
                        <span class="badge <?= $badge ?>"><?= $label ?></span>
                    </div>
                </div>

                <div class="row g-3">
                    <div class="col-md-4">
                        <a class="sh-card p-4 d-block text-decoration-none" href="provider_planning.php">
                            <div class="fw-bold">Planning</div>
                            <div class="text-secondary">Voir mes interventions</div>
                        </a>
                    </div>

                    <div class="col-md-4">
                        <a class="sh-card p-4 d-block text-decoration-none" href="provider_services.php">
                            <div class="fw-bold">Services</div>
                            <div class="text-secondary">Gérer mon catalogue</div>
                        </a>
                    </div>

                    <div class="col-md-4">
                        <a class="sh-card p-4 d-block text-decoration-none" href="provider_finances.php">
                            <div class="fw-bold">Revenus</div>
                            <div class="text-secondary">Voir mes stats</div>
                        </a>
                    </div>
                </div>
            <?php endif; ?>
        </div>
    </div>
</div>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>