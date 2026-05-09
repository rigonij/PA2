<?php
$pageTitle = "Admin • Tous les comptes";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";
$users = $users ?? [];
$error = $error ?? "";
?>
<div class="container py-4">
    <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
        <div>
            <h1 class="h4 mb-1">Tous les comptes</h1>
            <p class="text-secondary mb-0">Gestion admin : bannir, modifier, supprimer</p>
        </div>
        <a class="btn btn-outline-secondary" href="admin_dashboard.php">← Retour</a>
    </div>

    <?php if (!empty($error)): ?>
        <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>

    <div class="sh-card p-3 mb-3">
        <div class="row g-2 align-items-end">
            <div class="col-md-7">
                <label class="form-label">Recherche (prénom, nom ou ID)</label>
                <input type="text" class="form-control" id="adminSearch" placeholder="Ex: Dupont, 42, Jean">
            </div>
            <div class="col-md-3">
                <label class="form-label">Type</label>
                <select class="form-select" id="adminTypeFilter">
                    <option value="">Tous</option>
                    <option value="Senior">Senior</option>
                    <option value="Prestataire">Prestataire</option>
                    <option value="Admin">Admin</option>
                </select>
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
                        <th>Email</th>
                        <th>Ville</th>
                        <th>Type</th>
                        <th>Statut</th>
                        <th style="width:1%;" class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($users)): ?>
                        <?php foreach ($users as $user): ?>
                            <?php
                            $uid = (int)($user['id'] ?? 0);
                            $prenom = $user['prenom'] ?? '';
                            $nom = $user['nom'] ?? '';
                            $type = $user['user_type'] ?? '';
                            $blob = strtolower($uid . ' ' . $prenom . ' ' . $nom);
                            ?>
                            <tr data-search="<?= htmlspecialchars($blob) ?>" data-type="<?= htmlspecialchars($type) ?>">
                                <td><?= htmlspecialchars($uid) ?></td>
                                <td><?= htmlspecialchars($prenom !== '' ? $prenom : 'N/A') ?></td>
                                <td><?= htmlspecialchars($nom !== '' ? $nom : 'N/A') ?></td>
                                <td><?= htmlspecialchars($user['email'] ?? '') ?></td>
                                <td><?= htmlspecialchars($user['address_city'] ?? 'N/A') ?></td>
                                <td>
                                    <span class="badge text-bg-secondary"><?= htmlspecialchars($type) ?></span>
                                </td>
                                <td>
                                    <?php if (!empty($user['is_banned'])): ?>
                                        <span class="badge text-bg-danger">Banni</span>
                                    <?php else: ?>
                                        <span class="badge text-bg-success">Actif</span>
                                    <?php endif; ?>
                                </td>
                                <td class="text-end" style="white-space:nowrap;">
                                    <?php if ($type !== 'Admin'): ?>
                                        <?php if (!empty($user['is_banned'])): ?>
                                            <form method="POST" action="admin_users.php" style="display:inline">
                                                <input type="hidden" name="unban_id" value="<?= $uid ?>">
                                                <button type="submit" class="btn btn-sm btn-outline-success">Debannir</button>
                                            </form>
                                        <?php else: ?>
                                            <form method="POST" action="admin_users.php" style="display:inline"
                                                onsubmit="return confirm('Bannir cet utilisateur ?')">
                                                <input type="hidden" name="ban_id" value="<?= $uid ?>">
                                                <button type="submit" class="btn btn-sm btn-outline-warning">Bannir</button>
                                            </form>
                                        <?php endif; ?>
                                    <?php endif; ?>
                                    <a href="admin_users_edit.php?id=<?= $uid ?>" class="btn btn-sm btn-outline-primary me-1">Modifier</a>
                                    <form method="POST" action="admin_users.php" style="display:inline"
                                        onsubmit="return confirm('Supprimer cet utilisateur ?')">
                                        <input type="hidden" name="delete_id" value="<?= $uid ?>">
                                        <button type="submit" class="btn btn-sm btn-outline-danger">Supprimer</button>
                                    </form>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="8" class="text-secondary">Aucun utilisateur trouve.</td>
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
        const typeFilter = document.getElementById('adminTypeFilter').value || '';
        const rows = document.querySelectorAll('tbody tr[data-search]');
        let visible = 0;
        rows.forEach(function(tr) {
            const blob = tr.getAttribute('data-search') || '';
            const type = tr.getAttribute('data-type') || '';
            const matchText = !query || blob.indexOf(query) !== -1;
            const matchType = !typeFilter || type === typeFilter;
            const show = matchText && matchType;
            tr.style.display = show ? '' : 'none';
            if (show) visible++;
        });
        document.getElementById('adminNoResults').style.display = (rows.length > 0 && visible === 0) ? 'block' : 'none';
    }
    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('adminSearchBtn').addEventListener('click', applyAdminFilter);
        document.getElementById('adminTypeFilter').addEventListener('change', applyAdminFilter);
        document.getElementById('adminSearch').addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                applyAdminFilter();
            }
        });
    });
</script>

<?php include __DIR__ . "/../common/footer-scripts.php"; ?>