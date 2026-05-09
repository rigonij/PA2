<div class="sh-card p-3 mb-3 d-flex align-items-center justify-content-between gap-3">
    <div>
        <div class="fw-bold">SilverHappy</div>
        <div class="text-secondary">Espace Prestataire</div>
    </div>

    <div class="d-flex gap-2">
        <a class="btn btn-outline-secondary btn-sm" href="provider_dashboard.php">Dashboard</a>
        <a class="btn btn-outline-danger btn-sm" href="logout.php">Déconnexion</a>
    </div>
</div>

<?php if (($_SESSION["provider_validation_status"] ?? -1) === 0): ?>
    <div class="alert alert-warning rounded-0 mb-0 text-center" role="alert">
        <strong>Compte en attente de validation.</strong>
        Téléverse ton/tes diplôme(s) et le ou les poste souhaités sur la page
        <a href="provider_document.php" class="alert-link">Document de validation</a>
        pour qu'un admin puisse valider ton compte. Tu ne pourras pas créer de services tant que ce n'est pas fait.
    </div>
<?php endif; ?>