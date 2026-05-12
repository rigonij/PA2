<?php
$pageTitle = "SilverHappy • Créer un compte";
include __DIR__ . "/../common/head.php";
?>

<div class="container py-5" style="max-width: 580px;">
    <div class="sh-card p-4">

        <div class="d-flex align-items-center gap-3 mb-4">
            <div class="sh-logo-dot"></div>
            <div>
                <div class="sh-brand fs-4">SilverHappy Administrateur</div>
                <div class="text-secondary small">Créer votre compte admin</div>
            </div>
        </div>

        <?php if (!empty($error)): ?>
            <div class="alert alert-danger py-2" role="alert">
                <?= htmlspecialchars($error) ?>
            </div>
        <?php endif; ?>

        <?php if (!empty($success)): ?>
            <div class="alert alert-success py-2" role="alert">
                <?= htmlspecialchars($success) ?>
                <div class="mt-2">
                    <a href="admin_login.php" class="btn btn-sh-primary btn-sm">Se connecter maintenant</a>
                </div>
            </div>
        <?php else: ?>

            <form method="POST" action="admin_register.php" class="d-grid gap-3" id="registerForm">

                
                <div>
                    <label class="form-label fw-semibold" for="email">Email <span class="text-danger">*</span></label>
                    <input class="form-control" id="email" name="email" type="email"
                        placeholder="votre@email.fr"
                        value="<?= htmlspecialchars($_POST['email'] ?? '') ?>"
                        required autocomplete="email">
                </div>

                <div>
                    <label class="form-label fw-semibold" for="role">Type de compte <span class="text-danger">*</span></label>
                    <select class="form-select" id="role" name="role" required>
                        <option value="admin" <?= ($_POST["role"] ?? "") === "admin" ? "selected" : "" ?>>Administrateur</option>
                    </select>
                </div>

                

                <div>
                    <label class="form-label fw-semibold" for="nom">Nom</label>
                    <input class="form-control" id="nom" name="nom" type="text"
                        placeholder="Votre nom"
                        value="<?= htmlspecialchars($_POST['nom'] ?? '') ?>">
                </div>

                <div>
                    <label class="form-label fw-semibold" for="prenom">Prénom</label>
                    <input class="form-control" id="prenom" name="prenom" type="text"
                        placeholder="Votre prénom"
                        value="<?= htmlspecialchars($_POST['prenom'] ?? '') ?>">
                </div>


                <div>
                    <label class="form-label fw-semibold" for="telephone">Téléphone</label>
                    <input class="form-control" id="telephone" name="telephone" type="tel"
                        placeholder="06 00 00 00 00"
                        value="<?= htmlspecialchars($_POST['telephone'] ?? '') ?>">
                </div>

                <div>
                    <label class="form-label fw-semibold" for="birth_date">Date de naissance</label>
                    <input class="form-control" id="birth_date" name="birth_date" type="date" max="<?= date('Y-m-d') ?>"
                        value="<?= htmlspecialchars($_POST['birth_date'] ?? '') ?>">
                </div>

                <div>
                    <label class="form-label fw-semibold" for="password">Mot de passe <span class="text-danger">*</span></label>
                    <input class="form-control" id="password" name="password" type="password"
                        placeholder="8 caractères minimum"
                        required autocomplete="new-password" minlength="8">
                </div>

                <div>
                    <label class="form-label fw-semibold" for="password_confirm">Confirmer le mot de passe <span class="text-danger">*</span></label>
                    <input class="form-control" id="password_confirm" name="password_confirm" type="password"
                        placeholder="Répétez votre mot de passe"
                        required autocomplete="new-password">
                </div>

                <button class="btn btn-sh-primary w-100 py-2 mt-1" type="submit">
                    Créer mon compte
                </button>

        <?php endif; ?>

        <hr class="my-3">
        <p class="text-center text-secondary mb-0">
            Déjà un compte admin ?
            <a href="admin_login.php" class="fw-bold text-decoration-none">Se connecter</a>
        </p>

    </div>
</div>


<?php include __DIR__ . "/../common/footer-scripts.php"; ?>