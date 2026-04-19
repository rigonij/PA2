<?php
function renderCataloguePrestataires(array $providers): void
{
    $pageTitle = "SilverHappy • Catalogue Prestataires";
    include __DIR__ . "/../common/head.php";
    include __DIR__ . "/../common/header.php";
?>
    <div class="container py-4">
        <?php include __DIR__ . "/../common/topbar.php"; ?>
        <div class="row g-3">
            <div class="col-lg-3">
                <?php include __DIR__ . "/../common/sidebar.php"; ?>
            </div>
            <div class="col-lg-9">

                <div class="sh-card p-4 mb-3">
                    <h1 class="h4 mb-1">Catalogue • Prestataires</h1>
                    <p class="text-secondary mb-0">Prestataires vérifiés disponibles.</p>
                </div>

                <?php if (empty($providers)): ?>
                    <div class="sh-card p-4">
                        <p class="text-secondary mb-0">Aucun prestataire disponible pour le moment.</p>
                    </div>
                <?php else: ?>
                    <div class="row g-3">
                        <?php foreach ($providers as $p):
                            $pid         = (int)($p["id"] ?? 0);
                            $companyName = htmlspecialchars($p["company_name"] ?? "Entreprise");
                            $nom         = htmlspecialchars($p["nom"] ?? "");
                            $prenom      = htmlspecialchars($p["prenom"] ?? "");
                            $email       = htmlspecialchars($p["email"] ?? "");
                            $phone       = htmlspecialchars($p["phone"] ?? "");
                            $description = htmlspecialchars($p["description"] ?? "");
                            $modalId     = "modalProfil" . $pid;
                        ?>
                            <div class="col-md-6">
                                <div class="sh-card p-4 h-100 d-flex flex-column justify-content-between">
                                    <div>
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <div>
                                                <div class="fw-bold"><?= $companyName ?></div>
                                                <div class="text-secondary small"><?= $prenom ?> <?= $nom ?></div>
                                            </div>
                                            <span class="badge text-bg-success">Vérifié</span>
                                        </div>
                                        <?php if ($description): ?>
                                            <p class="text-secondary small mb-0"><?= $description ?></p>
                                        <?php endif; ?>
                                    </div>
                                    <div class="d-flex gap-2 mt-3">
                                        <button class="btn btn-outline-secondary btn-sm"
                                            data-bs-toggle="modal"
                                            data-bs-target="#<?= $modalId ?>">
                                            Profil
                                        </button>
                                        <a class="btn btn-sh-gold btn-sm fw-bold"
                                            href="messagerie.php?open_user=<?= $pid ?>">
                                            Contacter
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <div class="modal fade" id="<?= $modalId ?>" tabindex="-1">
                                <div class="modal-dialog modal-dialog-centered">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title"><?= $companyName ?></h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <dl class="row mb-0">
                                                <dt class="col-sm-4">Entreprise</dt>
                                                <dd class="col-sm-8"><?= $companyName ?></dd>

                                                <dt class="col-sm-4">Nom</dt>
                                                <dd class="col-sm-8"><?= $prenom ?> <?= $nom ?></dd>

                                                <?php if ($email): ?>
                                                    <dt class="col-sm-4">Email</dt>
                                                    <dd class="col-sm-8"><?= $email ?></dd>
                                                <?php endif; ?>

                                                <?php if ($phone): ?>
                                                    <dt class="col-sm-4">Téléphone</dt>
                                                    <dd class="col-sm-8"><?= $phone ?></dd>
                                                <?php endif; ?>

                                                <?php if ($description): ?>
                                                    <dt class="col-sm-4">Description</dt>
                                                    <dd class="col-sm-8"><?= $description ?></dd>
                                                <?php endif; ?>
                                            </dl>
                                        </div>
                                        <div class="modal-footer">
                                            <a class="btn btn-sh-gold fw-bold"
                                                href="messagerie.php?open_user=<?= $pid ?>">
                                                Contacter
                                            </a>
                                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        <?php endforeach; ?>
                    </div>
                <?php endif; ?>

            </div>
        </div>
    </div>
<?php
    include __DIR__ . "/../common/footer.php";
    include __DIR__ . "/../common/footer-scripts.php";
}
