<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <title>Back office Silver Happy - Modifier utilisateur</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/PA_2i2/public/assets/css/admin_style.css">
</head>

<body>
    <div class="menu-toggle">
        <div class="hamburger"><span></span><span></span><span></span></div>
    </div>
    <div class="main">
        <aside class="BarreLat">
            <div class="container">
                <h3>Menu Admin</h3>
                <nav class="menu">
                    <a href="admin_dashboard.php" class="item">Accueil</a>
                    <a href="admin_users.php" class="item actif">Comptes</a>
                    <a href="admin_providers.php" class="item">Prestataires</a>
                    <a href="admin_seniors.php" class="item">Seniors</a>
                    <a href="admin_event.php" class="item">Événements</a>
                    <a href="admin_paiement.php" class="item">Paiements</a>
                    <a href="admin_logout.php" class="item">Déconnexion</a>
                </nav>
            </div>
        </aside>
        <div class="container py-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h1>Modifier utilisateur #<?= (int)$user['id'] ?></h1>
                <a href="admin_users.php" class="btn btn-secondary">← Retour</a>
            </div>

            <?php if (!empty($error)): ?>
                <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
            <?php endif; ?>
            <?php if (!empty($success)): ?>
                <div class="alert alert-success"><?= htmlspecialchars($success) ?></div>
            <?php endif; ?>

            <?php if ($user): ?>
                <form method="POST" class="card p-4 shadow-sm" style="max-width:600px;">
                    <div class="row mb-3">
                        <div class="col">
                            <label class="form-label">Prénom</label>
                            <input type="text" name="prenom" class="form-control"
                                value="<?= htmlspecialchars($user['prenom'] ?? '') ?>">
                        </div>
                        <div class="col">
                            <label class="form-label">Nom</label>
                            <input type="text" name="nom" class="form-control"
                                value="<?= htmlspecialchars($user['nom'] ?? '') ?>">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control"
                            value="<?= htmlspecialchars($user['email'] ?? '') ?>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Téléphone</label>
                        <input type="text" name="phone_number" class="form-control"
                            value="<?= htmlspecialchars($user['phone_number'] ?? '') ?>">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Ville</label>
                        <input type="text" name="address_city" class="form-control"
                            value="<?= htmlspecialchars($user['address_city'] ?? '') ?>">
                    </div>

                    <hr>
                    <p class="text-muted">Laisser vide pour ne pas changer le mot de passe.</p>

                    <div class="row mb-3">
                        <div class="col">
                            <label class="form-label">Nouveau mot de passe</label>
                            <input type="password" name="password" class="form-control">
                        </div>
                        <div class="col">
                            <label class="form-label">Confirmer</label>
                            <input type="password" name="password_confirm" class="form-control">
                        </div>
                    </div>

                    <div class="d-flex gap-2">
                        <a href="admin_users.php" class="btn btn-outline-secondary">Annuler</a>
                        <button type="submit" class="btn btn-primary">Enregistrer</button>
                    </div>
                </form>
            <?php endif; ?>
        </div>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const toggle = document.querySelector('.menu-toggle');
            const menu = document.querySelector('.BarreLat');
            if (toggle && menu) toggle.addEventListener('click', () => menu.classList.toggle('open'));
        });
    </script>
</body>

</html>