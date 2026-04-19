<?php
$pageTitle = "Admin • Seniors";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";
?>

<div class="container py-4">

    <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
        <div>
            <h1 class="h4 mb-1">Gestion des seniors</h1>
            <p class="text-secondary mb-0">Liste et suppression des comptes seniors</p>
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
                        <th>Prenom</th>
                        <th>Nom</th>
                        <th>Email</th>
                        <th>Telephone</th>
                        <th>Ville</th>
                        <th>Date de naissance</th>
                        <th>Age</th>
                        <th style="width:1%;" class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($seniors)): ?>
                        <?php foreach ($seniors as $senior): ?>
                            <tr>
                                <td><?= htmlspecialchars($senior['id']) ?></td>
                                <td><?= htmlspecialchars($senior['prenom'] ?? 'N/A') ?></td>
                                <td><?= htmlspecialchars($senior['nom'] ?? 'N/A') ?></td>
                                <td><?= htmlspecialchars($senior['email']) ?></td>
                                <td><?= htmlspecialchars($senior['phone_number'] ?: 'N/A') ?></td>
                                <td><?= htmlspecialchars($senior['address_city'] ?: 'N/A') ?></td>
                                <td><?= htmlspecialchars($senior['birth_date'] ?: 'N/A') ?></td>
                                <td><?= htmlspecialchars($senior['age'] ?: 'N/A') ?></td>
                                <td class="text-end">
                                    <form method="POST" action="admin_seniors.php" style="display:inline"
                                        onsubmit="return confirm('Supprimer ce senior ?')">
                                        <input type="hidden" name="delete_id" value="<?= (int)$senior['id'] ?>">
                                        <button type="submit" class="btn btn-sm btn-outline-danger">Supprimer</button>
                                    </form>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="9" class="text-secondary">Aucun senior trouve.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>

</div>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>