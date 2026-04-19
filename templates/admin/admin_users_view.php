<?php
$pageTitle = "Admin • Tous les comptes";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";
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

    <div class="sh-card p-3">
        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead>
                    <tr>
                        <th>ID</th>
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
                            <tr>
                                <td><?= htmlspecialchars($user['id']) ?></td>
                                <td><?= htmlspecialchars($user['email']) ?></td>
                                <td><?= htmlspecialchars($user['address_city'] ?? 'N/A') ?></td>
                                <td>
                                    <span class="badge text-bg-secondary">
                                        <?= htmlspecialchars($user['user_type']) ?>
                                    </span>
                                </td>
                                <td>
                                    <?php if (!empty($user['is_banned'])): ?>
                                        <span class="badge text-bg-danger">Banni</span>
                                    <?php else: ?>
                                        <span class="badge text-bg-success">Actif</span>
                                    <?php endif; ?>
                                </td>
                                <td class="text-end" style="white-space:nowrap;">
                                    <?php if (($user['user_type'] ?? '') !== 'Admin'): ?>
                                        <?php if (!empty($user['is_banned'])): ?>
                                            <form method="POST" action="admin_users.php" style="display:inline">
                                                <input type="hidden" name="unban_id" value="<?= (int)$user['id'] ?>">
                                                <button type="submit" class="btn btn-sm btn-outline-success">Debannir</button>
                                            </form>
                                        <?php else: ?>
                                            <form method="POST" action="admin_users.php" style="display:inline"
                                                onsubmit="return confirm('Bannir cet utilisateur ?')">
                                                <input type="hidden" name="ban_id" value="<?= (int)$user['id'] ?>">
                                                <button type="submit" class="btn btn-sm btn-outline-warning">Bannir</button>
                                            </form>
                                        <?php endif; ?>
                                    <?php endif; ?>
                                    <a href="admin_users_edit.php?id=<?= (int)($user['id'] ?? 0) ?>"
                                        class="btn btn-sm btn-outline-primary me-1">
                                        Modifier
                                    </a>
                                    <form method="POST" action="admin_users.php" style="display:inline"
                                        onsubmit="return confirm('Supprimer cet utilisateur ?')">
                                        <input type="hidden" name="delete_id" value="<?= (int)$user['id'] ?>">
                                        <button type="submit" class="btn btn-sm btn-outline-danger">Supprimer</button>
                                    </form>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="6" class="text-secondary">Aucun utilisateur trouve.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>

</div>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>