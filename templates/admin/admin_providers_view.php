<?php
$pageTitle = "Admin • Prestataires";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";
$providers = $providers ?? [];
$error = $error ?? "";
?>
<div class="container py-4">
    <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
        <div>
            <h1 class="h4 mb-1">Gestion des prestataires</h1>
            <p class="text-secondary mb-0">Liste et détails des comptes prestataires</p>
        </div>
        <a class="btn btn-outline-secondary" href="admin_dashboard.php">← Retour</a>
    </div>

    <?php if (!empty($error)): ?>
        <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>

    <div class="sh-card p-3 mb-3">
        <div class="row g-2 align-items-end">
            <div class="col-md-10">
                <label class="form-label">Recherche (prénom, nom, entreprise ou ID)</label>
                <input type="text" class="form-control" id="adminSearch" placeholder="Ex: Dupont, 42, Jean, ACME">
            </div>
            <div class="col-md-2">
                <button type="button" class="btn btn-sh-gold w-100" id="adminSearchBtn">Rechercher</button>
            </div>
        </div>
        <div id="adminNoResults" class="text-secondary mt-3" style="display:none;">Aucun résultat.</div>
    </div>

    <div class="sh-card p-3">
        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Prénom</th>
                        <th>Nom</th>
                        <th>Entreprise</th>
                        <th>Email</th>
                        <th>Téléphone</th>
                        <th>SIRET</th>
                        <th>Adresse</th>
                        <th>Ville</th>
                        <th>Code postal</th>
                        <th>Statut</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($providers)): ?>
                        <?php foreach ($providers as $prov): ?>
                            <?php
                            $pid = (int)($prov['id'] ?? 0);
                            $prenom = $prov['prenom'] ?? '';
                            $nom = $prov['nom'] ?? '';
                            $company = $prov['company_name'] ?? '';
                            $blob = strtolower($pid . ' ' . $prenom . ' ' . $nom . ' ' . $company);
                            ?>
                            <tr data-search="<?= htmlspecialchars($blob) ?>">
                                <td><?= htmlspecialchars($pid) ?></td>
                                <td><?= htmlspecialchars($prenom !== '' ? $prenom : 'N/A') ?></td>
                                <td><?= htmlspecialchars($nom !== '' ? $nom : 'N/A') ?></td>
                                <td class="fw-bold"><?= htmlspecialchars($company !== '' ? $company : 'N/A') ?></td>
                                <td><?= htmlspecialchars($prov['email'] ?? 'N/A') ?></td>
                                <td><?= htmlspecialchars($prov['phone_number'] ?? 'N/A') ?></td>
                                <td><?= htmlspecialchars($prov['siret'] ?? 'N/A') ?></td>
                                <td><?= htmlspecialchars($prov['address_street'] ?? 'N/A') ?></td>
                                <td><?= htmlspecialchars($prov['address_city'] ?? 'N/A') ?></td>
                                <td><?= htmlspecialchars($prov['address_zip'] ?? 'N/A') ?></td>
                                <td>
                                    <?php $vs = (int)($prov['validation_status'] ?? 0); ?>
                                    <?php if ($vs === 1): ?>
                                        <span class="badge text-bg-success">Validé</span>
                                    <?php elseif ($vs === 2): ?>
                                        <span class="badge text-bg-danger">Refusé</span>
                                    <?php else: ?>
                                        <span class="badge text-bg-warning">En attente</span>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="11" class="text-secondary">Aucun prestataire trouvé.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    function applyAdminFilter() {
        const query = (document.getElementById('adminSearch').value || '').trim().toLowerCase();
        const rows = document.querySelectorAll('tbody tr[data-search]');
        let visible = 0;
        rows.forEach(function(tr) {
            const blob = tr.getAttribute('data-search') || '';
            const match = !query || blob.indexOf(query) !== -1;
            tr.style.display = match ? '' : 'none';
            if (match) visible++;
        });
        document.getElementById('adminNoResults').style.display = (rows.length > 0 && visible === 0) ? 'block' : 'none';
    }
    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('adminSearchBtn').addEventListener('click', applyAdminFilter);
        document.getElementById('adminSearch').addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                applyAdminFilter();
            }
        });
    });
</script>

<?php include __DIR__ . "/../common/footer-scripts.php"; ?>