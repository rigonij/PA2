<?php
$pageTitle = "SilverHappy • Mon Profil";
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
                <h1 class="h4 mb-1">Profil adhérent</h1>
                <?php if (!empty($successMsg)): ?>
                    <div class="alert alert-success"><?= htmlspecialchars($successMsg) ?></div>
                <?php endif; ?>
                <?php if (!empty($errorMsg)): ?>
                    <div class="alert alert-danger"><?= htmlspecialchars($errorMsg) ?></div>
                <?php endif; ?>
                <p class="text-secondary mb-0">Bonjour, <?= htmlspecialchars(($userData['prenom'] ?? '') . ' ' . ($userData['nom'] ?? '')) ?>.</p>
            </div>
            <div class="sh-card p-4">
                <div class="row g-3">
                    <div class="col-md-5">
                        <label class="form-label">Email de connexion</label>
                        <div class="form-control bg-light"><?= htmlspecialchars($userData['email'] ?? '') ?></div>
                    </div>
                    <div class="col-md-5">
                        <label class="form-label">Téléphone</label>
                        <div class="form-control bg-light"><?= htmlspecialchars($userData['phone_number'] ?? '') ?></div>
                    </div>
                    <div class="col-12 mt-4">
                        <div class="d-flex gap-2 justify-content-end">
                            <button class="btn btn-sh-primary" type="button" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                                Modifier mes informations
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="editProfileModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content sh-card">
            <form method="POST" action="profil.php">
                <div class="modal-body p-4">
                    <h2 class="h5 mb-3">Modifier mon profil</h2>

                    <div class="row g-2">
                        <div class="col-md-6">
                            <label class="form-label">Prénom</label>
                            <input class="form-control" name="prenom" value="<?= htmlspecialchars($userData['prenom'] ?? '') ?>">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Nom</label>
                            <input class="form-control" name="nom" value="<?= htmlspecialchars($userData['nom'] ?? '') ?>">
                        </div>
                    </div>

                    <div class="mt-3">
                        <label class="form-label">Téléphone</label>
                        <input class="form-control" name="phone_number" value="<?= htmlspecialchars($userData['phone_number'] ?? '') ?>">
                    </div>

                    <div class="mt-3">
                        <label class="form-label">Email</label>
                        <input class="form-control" name="email" value="<?= htmlspecialchars($userData['email'] ?? '') ?>">
                    </div>

                    <hr class="my-3">

                    <div class="mt-2">
                        <label class="form-label">Adresse</label>
                        <input class="form-control mb-2" name="address_street" placeholder="Numéro et rue"
                            value="<?= htmlspecialchars($userData['address_street'] ?? '') ?>">
                        <div class="row g-2">
                            <div class="col-4">
                                <input class="form-control" name="address_zip" placeholder="Code postal"
                                    value="<?= htmlspecialchars($userData['address_zip'] ?? '') ?>">
                            </div>
                            <div class="col-8">
                                <input class="form-control" name="address_city" placeholder="Ville"
                                    value="<?= htmlspecialchars($userData['address_city'] ?? '') ?>">
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-2 mt-4">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-sh-primary">Enregistrer</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>