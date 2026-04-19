<?php
$pageTitle = "SilverHappy • Créer un compte";
include __DIR__ . "/../common/head.php";
?>

<div class="container py-5" style="max-width: 580px;">
    <div class="sh-card p-4">

        <div class="d-flex align-items-center gap-3 mb-4">
            <div class="sh-logo-dot"></div>
            <div>
                <div class="sh-brand fs-4">SilverHappy</div>
                <div class="text-secondary small">Créer votre compte</div>
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
                    <a href="login.php" class="btn btn-sh-primary btn-sm">Se connecter maintenant</a>
                </div>
            </div>
        <?php else: ?>

            <form method="POST" action="register.php" class="d-grid gap-3" id="registerForm">

                <div>
                    <label class="form-label fw-semibold">Je suis <span class="text-danger">*</span></label>
                    <div class="d-flex gap-3">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="role" id="roleSenior" value="senior"
                                <?= (($_POST['role'] ?? 'senior') === 'senior') ? 'checked' : '' ?>
                                onchange="toggleRoleFields()">
                            <label class="form-check-label" for="roleSenior">Un senior</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="role" id="roleProvider" value="provider"
                                <?= (($_POST['role'] ?? '') === 'provider') ? 'checked' : '' ?>
                                onchange="toggleRoleFields()">
                            <label class="form-check-label" for="roleProvider">Un prestataire</label>
                        </div>
                    </div>
                </div>

                <div>
                    <label class="form-label fw-semibold" for="email">Email <span class="text-danger">*</span></label>
                    <input class="form-control" id="email" name="email" type="email"
                        placeholder="votre@email.fr"
                        value="<?= htmlspecialchars($_POST['email'] ?? '') ?>"
                        required autocomplete="email">
                </div>

                <div class="row g-2">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold" for="prenom">Prénom</label>
                        <input class="form-control" id="prenom" name="prenom" type="text"
                            placeholder="Votre prénom"
                            value="<?= htmlspecialchars($_POST['prenom'] ?? '') ?>">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold" for="nom">Nom</label>
                        <input class="form-control" id="nom" name="nom" type="text"
                            placeholder="Votre nom"
                            value="<?= htmlspecialchars($_POST['nom'] ?? '') ?>">
                    </div>
                </div>

                <div>
                    <label class="form-label fw-semibold" for="telephone">Téléphone</label>
                    <input class="form-control" id="telephone" name="telephone" type="tel"
                        placeholder="06 00 00 00 00"
                        value="<?= htmlspecialchars($_POST['telephone'] ?? '') ?>">
                </div>

                <div>
                    <label class="form-label fw-semibold" for="address_street">Adresse</label>
                    <input class="form-control mb-2" id="address_street" name="address_street" type="text"
                        placeholder="Numéro et rue"
                        value="<?= htmlspecialchars($_POST['address_street'] ?? '') ?>">
                    <div class="row g-2">
                        <div class="col-4">
                            <input class="form-control" name="address_zip" type="text"
                                placeholder="Code postal" maxlength="5"
                                value="<?= htmlspecialchars($_POST['address_zip'] ?? '') ?>">
                        </div>
                        <div class="col-8">
                            <input class="form-control" name="address_city" type="text"
                                placeholder="Ville"
                                value="<?= htmlspecialchars($_POST['address_city'] ?? '') ?>">
                        </div>
                    </div>
                </div>

                <div id="seniorFields">
                    <label class="form-label fw-semibold" for="birth_date">Date de naissance</label>
                    <input class="form-control" id="birth_date" name="birth_date" type="date"
                        value="<?= htmlspecialchars($_POST['birth_date'] ?? '') ?>">
                </div>

                <div id="providerFields" style="display:none;">
                    <div class="mb-3">
                        <label class="form-label fw-semibold" for="company_name">Nom de l'entreprise <span class="text-danger">*</span></label>
                        <input class="form-control" id="company_name" name="company_name" type="text"
                            placeholder="Ma société SAS"
                            value="<?= htmlspecialchars($_POST['company_name'] ?? '') ?>">
                    </div>
                    <div>
                        <label class="form-label fw-semibold" for="siret_number">Numéro SIRET</label>
                        <input class="form-control" id="siret_number" name="siret_number" type="text"
                            placeholder="14 chiffres"
                            value="<?= htmlspecialchars($_POST['siret_number'] ?? '') ?>">
                        <div class="form-text">Votre compte sera soumis à validation par un administrateur.</div>
                    </div>
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

            </form>

        <?php endif; ?>

        <hr class="my-3">
        <p class="text-center text-secondary mb-0">
            Déjà un compte ?
            <a href="login.php" class="fw-bold text-decoration-none">Se connecter</a>
        </p>

    </div>
</div>

<script>
    function toggleRoleFields() {
        const isProvider = document.getElementById('roleProvider').checked;
        document.getElementById('seniorFields').style.display = isProvider ? 'none' : 'block';
        document.getElementById('providerFields').style.display = isProvider ? 'block' : 'none';
    }
    toggleRoleFields();
</script>

<?php include __DIR__ . "/../common/footer-scripts.php"; ?>