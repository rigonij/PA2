<?php
$pageTitle = "Prestataire • Revenus";
include __DIR__ . "/../common/head.php";
?>
<div class="container py-4">
    <?php include __DIR__ . "/../common/topbar.php"; ?>
    <div class="row g-3">
        <div class="col-lg-3"><?php include __DIR__ . "/../common/provider_sidebar.php"; ?></div>
        <div class="col-lg-9">
            <div class="sh-card p-4 mb-3">
                <h1 class="h4 mb-1">Revenus & Facturation</h1>
                <p class="text-secondary mb-0">Suivi de vos encaissements et factures générées.</p>
            </div>
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <div class="sh-card p-4 text-center bg-light">
                        <div class="text-secondary">Solde en attente de virement</div>
                        <div class="fs-2 fw-bold text-success">150,00 €</div>
                        <button class="btn btn-sh-gold mt-2">Demander le virement</button>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="sh-card p-4 text-center bg-light">
                        <div class="text-secondary">Total généré (ce mois)</div>
                        <div class="fs-2 fw-bold">450,00 €</div>
                        <div class="text-secondary small mt-2">Commission SilverHappy déduite.</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>