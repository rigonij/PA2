<?php
$pageTitle = "SilverHappy • Connexion";
include __DIR__ . "/../common/head.php";
?>

<div class="container py-5" style="max-width: 480px;">
    <div class="sh-card p-4">

        <div class="d-flex align-items-center gap-3 mb-4">
            <div class="sh-logo-dot"></div>
            <div>
                <div class="sh-brand fs-4">SilverHappy</div>
                <div class="text-secondary small">Connexion à votre espace</div>
            </div>
        </div>

        <?php if (!empty($error)): ?>
            <div class="alert alert-danger py-2" role="alert">
                <i class="bi bi-exclamation-circle me-2"></i>
                <?= htmlspecialchars($error) ?>
            </div>
        <?php endif; ?>

        <form method="POST" action="login.php" class="d-grid gap-3">

            <div>
                <label class="form-label fw-semibold" for="email">Email <span class="text-danger">*</span></label>
                <input
                    class="form-control"
                    id="email"
                    name="email"
                    type="email"
                    placeholder="votre@email.fr"
                    value="<?= htmlspecialchars($_POST['email'] ?? '') ?>"
                    required
                    autocomplete="email">
            </div>

            <div>
                <label class="form-label fw-semibold" for="password">Mot de passe <span class="text-danger">*</span></label>
                <input
                    class="form-control"
                    id="password"
                    name="password"
                    type="password"
                    placeholder="Votre mot de passe"
                    required
                    autocomplete="current-password">
            </div>

            <button class="btn btn-sh-primary w-100 py-2 mt-1" type="submit">
                Se connecter
            </button>

        </form>
        <hr class="my-3">
        <p class="text-center text-secondary mb-0">
            Pas encore de compte ?
            <a href="../public/register.php" class="fw-bold text-decoration-none">Créer un compte</a>
        </p>

    </div>
</div>

<?php include __DIR__ . "/../common/footer-scripts.php"; ?>