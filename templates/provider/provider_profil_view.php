<?php
function renderProviderProfil(array $u, string $success = '', string $error = ''): void
{
    $status = (int)($u['validation_status'] ?? 0);
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

                <div class="sh-card p-3 mb-3 d-flex justify-content-between align-items-center">
                    <div>
                        <h4 class="fw-bold mb-0">Mon profil</h4>
                        <p class="text-muted mb-0">Vos informations personnelles et professionnelles</p>
                    </div>
                    <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#modalModifier">
                        Modifier
                    </button>
                </div>

                <?php if (!empty($success)): ?>
                    <div class="alert alert-success"><?= htmlspecialchars($success) ?></div>
                <?php endif; ?>

                <!-- Lecture seule -->
                <div class="sh-card p-3 mb-3">
                    <h5 class="fw-bold mb-3">Informations personnelles</h5>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Prenom</label>
                            <input class="form-control" disabled value="<?= htmlspecialchars($u['prenom'] ?? '') ?>">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Nom</label>
                            <input class="form-control" disabled value="<?= htmlspecialchars($u['nom'] ?? '') ?>">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Email</label>
                            <input class="form-control" disabled value="<?= htmlspecialchars($u['email'] ?? '') ?>">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Telephone</label>
                            <input class="form-control" disabled value="<?= htmlspecialchars($u['phone_number'] ?? '') ?>">
                        </div>
                    </div>
                </div>

                <div class="sh-card p-3 mb-3">
                    <h5 class="fw-bold mb-3">Adresse</h5>
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label fw-semibold">Rue</label>
                            <input class="form-control" disabled value="<?= htmlspecialchars($u['address_street'] ?? '') ?>">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Code postal</label>
                            <input class="form-control" disabled value="<?= htmlspecialchars($u['address_zip'] ?? '') ?>">
                        </div>
                        <div class="col-md-8">
                            <label class="form-label fw-semibold">Ville</label>
                            <input class="form-control" disabled value="<?= htmlspecialchars($u['address_city'] ?? '') ?>">
                        </div>
                    </div>
                </div>

                <div class="sh-card p-3 mb-3">
                    <h5 class="fw-bold mb-3">Informations professionnelles</h5>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Nom de la societe</label>
                            <input class="form-control" disabled value="<?= htmlspecialchars($u['company_name'] ?? '') ?>">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">SIRET</label>
                            <input class="form-control" disabled value="<?= htmlspecialchars($u['siret'] ?? '') ?>">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Statut du compte</label>
                            <p class="mt-1">
                                <?php if ($status === 1): ?>
                                    <span class="badge text-bg-success">Valide</span>
                                <?php elseif ($status === 2): ?>
                                    <span class="badge text-bg-danger">Refuse</span>
                                <?php else: ?>
                                    <span class="badge text-bg-warning">En attente de validation</span>
                                <?php endif; ?>
                            </p>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- Modal modification -->
    <div class="modal fade" id="modalModifier" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form method="POST" action="provider_profil.php">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold">Modifier mon profil</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Prenom</label>
                            <input type="text" name="prenom" class="form-control" value="<?= htmlspecialchars($u['prenom'] ?? '') ?>">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Nom</label>
                            <input type="text" name="nom" class="form-control" value="<?= htmlspecialchars($u['nom'] ?? '') ?>">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control" value="<?= htmlspecialchars($u['email'] ?? '') ?>">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Telephone</label>
                            <input type="text" name="phone_number" class="form-control" value="<?= htmlspecialchars($u['phone_number'] ?? '') ?>">
                        </div>
                        <div class="col-12">
                            <label class="form-label">Rue</label>
                            <input type="text" name="address_street" class="form-control" value="<?= htmlspecialchars($u['address_street'] ?? '') ?>">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Code postal</label>
                            <input type="text" name="address_zip" class="form-control" value="<?= htmlspecialchars($u['address_zip'] ?? '') ?>">
                        </div>
                        <div class="col-md-8">
                            <label class="form-label">Ville</label>
                            <input type="text" name="address_city" class="form-control" value="<?= htmlspecialchars($u['address_city'] ?? '') ?>">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Nom de la societe</label>
                            <input type="text" name="company_name" class="form-control" value="<?= htmlspecialchars($u['company_name'] ?? '') ?>">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">SIRET</label>
                            <input type="text" name="siret" class="form-control" value="<?= htmlspecialchars($u['siret'] ?? '') ?>">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-primary">Enregistrer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <?php include __DIR__ . "/../common/footer.php"; ?>
    <?php include __DIR__ . "/../common/footer-scripts.php"; ?>
<?php
}
