<?php
$pageTitle = "Admin • Seniors";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";
$seniors = $seniors ?? [];
$error = $error ?? "";
?>
<div class="container py-4">
    <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
        <div>
            <h1 class="h4 mb-1">Gestion des seniors</h1>
            <p class="text-secondary mb-0">Liste et détails des comptes seniors</p>
        </div>
        <a class="btn btn-outline-secondary" href="admin_dashboard.php">← Retour</a>
    </div>

    <?php if (!empty($error)): ?>
        <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>

    <div class="sh-card p-3 mb-3">
        <div class="row g-2 align-items-end">
            <div class="col-md-10">
                <label class="form-label">Recherche (prénom, nom ou ID)</label>
                <input type="text" class="form-control" id="adminSearch" placeholder="Ex: Dupont, 42, Jean">
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
                        <th>Prenom</th>
                        <th>Nom</th>
                        <th>Email</th>
                        <th>Telephone</th>
                        <th>Ville</th>
                        <th>Date de naissance</th>
                        <th>Age</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($seniors)): ?>
                        <?php foreach ($seniors as $senior): ?>
                            <?php
                            $sid = (int)($senior['id'] ?? 0);
                            $prenom = $senior['prenom'] ?? '';
                            $nom = $senior['nom'] ?? '';
                            $blob = strtolower($sid . ' ' . $prenom . ' ' . $nom);
                            ?>
                            <tr data-search="<?= htmlspecialchars($blob) ?>">
                                <td><?= htmlspecialchars($sid) ?></td>
                                <td><?= htmlspecialchars($prenom !== '' ? $prenom : 'N/A') ?></td>
                                <td><?= htmlspecialchars($nom !== '' ? $nom : 'N/A') ?></td>
                                <td><?= htmlspecialchars($senior['email'] ?? '') ?></td>
                                <td><?= htmlspecialchars(!empty($senior['phone_number']) ? $senior['phone_number'] : 'N/A') ?></td>
                                <td><?= htmlspecialchars(!empty($senior['address_city']) ? $senior['address_city'] : 'N/A') ?></td>
                                <td><?= htmlspecialchars(!empty($senior['birth_date']) ? fmt_dt($senior['birth_date'], false) : 'N/A') ?></td>
                                <td><?= htmlspecialchars(!empty($senior['age']) ? $senior['age'] : 'N/A') ?></td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="8" class="text-secondary">Aucun senior trouvé.</td>
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