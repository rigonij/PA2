<?php
$pageTitle = "Admin • Modifier utilisateur";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";

$user = $user ?? null;
$error = $error ?? "";
$success = $success ?? "";
?>
<div class="container py-4">
    <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
        <div>
            <h1 class="h4 mb-1">Modifier utilisateur <?= $user ? "#" . (int)$user['id'] : "" ?></h1>
            <p class="text-secondary mb-0">Mettre à jour les informations du compte</p>
        </div>
        <a class="btn btn-outline-secondary" href="admin_users.php">← Retour</a>
    </div>

    <?php if (!empty($error)): ?>
        <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>
    <?php if (!empty($success)): ?>
        <div class="alert alert-success"><?= htmlspecialchars($success) ?></div>
    <?php endif; ?>

    <?php if ($user): ?>
        <div class="sh-card p-4" style="max-width: 720px;">
            <form method="POST">
                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Prénom</label>
                        <input type="text" name="prenom" class="form-control"
                            value="<?= htmlspecialchars($user['prenom'] ?? '') ?>">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Nom</label>
                        <input type="text" name="nom" class="form-control"
                            value="<?= htmlspecialchars($user['nom'] ?? '') ?>">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Email <span class="text-danger">*</span></label>
                    <input type="email" name="email" class="form-control"
                        value="<?= htmlspecialchars($user['email'] ?? '') ?>" required>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Téléphone</label>
                        <input type="text" name="phone_number" class="form-control"
                            value="<?= htmlspecialchars($user['phone_number'] ?? '') ?>">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Ville</label>
                        <input type="text" name="address_city" class="form-control"
                            value="<?= htmlspecialchars($user['address_city'] ?? '') ?>">
                    </div>
                </div>

                <hr class="my-4">

                <p class="text-secondary small mb-3">Laisser vide pour ne pas changer le mot de passe.</p>
                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Nouveau mot de passe</label>
                        <input type="password" name="password" class="form-control" autocomplete="new-password">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Confirmer</label>
                        <input type="password" name="password_confirm" class="form-control" autocomplete="new-password">
                    </div>
                </div>

                <div class="d-flex gap-2 justify-content-end">
                    <a href="admin_users.php" class="btn btn-outline-secondary">Annuler</a>
                    <button type="submit" class="btn btn-sh-gold">Enregistrer</button>
                </div>
            </form>
        </div>
    <?php else: ?>
        <div class="sh-card p-4">
            <p class="text-secondary mb-0">Utilisateur introuvable.</p>
        </div>
    <?php endif; ?>
</div>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>