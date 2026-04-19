<?php
$pageTitle = "SilverHappy • Conseils";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";
?>

<div class="container py-4">
    <?php include __DIR__ . "/../common/topbar.php"; ?>

    <div class="row g-3">
        <div class="col-lg-3"><?php include __DIR__ . "/../common/sidebar.php"; ?></div>

        <div class="col-lg-9">
            <div class="sh-card p-4 mb-3">
                <h1 class="h4 mb-1">Conseils</h1>
            </div>

            <div class="row g-3">
                <div class="col-md-6">
                    <div class="sh-card p-3">
                        <div class="fw-bold">Bien vivre après 60 ans</div>
                        <div class="text-secondary">Sommeil, activité, routine.</div>
                        <div class="mt-3">
                            <button class="btn btn-outline-secondary" type="button" data-bs-toggle="modal" data-bs-target="#advice1">Lire</button>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="sh-card p-3">
                        <div class="fw-bold">Prévention des chutes</div>
                        <div class="text-secondary">Aménagement, éclairage, exercices.</div>
                        <div class="mt-3">
                            <button class="btn btn-outline-secondary" type="button" data-bs-toggle="modal" data-bs-target="#advice2">Lire</button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="advice1" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content sh-card">
                        <div class="modal-body p-4">
                            <h2 class="h5">Bien vivre après 60 ans</h2>
                            <p class="text-secondary mb-0">
                                Hydratation, marche quotidienne, rendez-vous réguliers, sommeil de qualité.
                            </p>
                            <div class="mt-3 text-end">
                                <button class="btn btn-sh-gold" type="button" data-bs-dismiss="modal">Fermer</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="advice2" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content sh-card">
                        <div class="modal-body p-4">
                            <h2 class="h5">Prévention des chutes</h2>
                            <p class="text-secondary mb-0">
                                Retirer les tapis glissants, améliorer l’éclairage, chaussures adaptées, exercices d’équilibre.
                            </p>
                            <div class="mt-3 text-end">
                                <button class="btn btn-sh-gold" type="button" data-bs-dismiss="modal">Fermer</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>