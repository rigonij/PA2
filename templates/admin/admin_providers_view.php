<?php
$pageTitle = "Admin • Prestataires";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";
?>

<div class="container py-4">

    <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
        <div>
            <h1 class="h4 mb-1">Gestion des prestataires</h1>
            <p class="text-secondary mb-0">Valider ou refuser les prestataires en attente</p>
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
                        <th>Entreprise</th>
                        <th>Email</th>
                        <th>Ville</th>
                        <th>Statut</th>
                        <th style="width:1%;" class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($providers)): ?>
                        <?php foreach ($providers as $prov): ?>
                            <tr>
                                <td><?= htmlspecialchars($prov['id']) ?></td>
                                <td class="fw-bold"><?= htmlspecialchars($prov['company_name']) ?></td>
                                <td><?= htmlspecialchars($prov['email']) ?></td>
                                <td><?= htmlspecialchars($prov['address_city'] ?? 'N/A') ?></td>
                                <td>
                                    <?php if ($prov['validation_status'] == 1): ?>
                                        <span class="badge text-bg-success">Valide</span>
                                    <?php elseif ($prov['validation_status'] == 2): ?>
                                        <span class="badge text-bg-danger">Refuse</span>
                                    <?php else: ?>
                                        <span class="badge text-bg-warning">En attente</span>
                                    <?php endif; ?>
                                </td>
                                <td class="text-end" style="white-space:nowrap;">
                                    <form method="POST" action="admin_providers.php" style="display:inline">
                                        <input type="hidden" name="provider_id" value="<?= (int)$prov['id'] ?>">
                                        <button type="submit" name="action" value="validate"
                                            class="btn btn-sm btn-outline-success">Valider</button>
                                        <button type="submit" name="action" value="refuse"
                                            class="btn btn-sm btn-outline-danger">Refuser</button>
                                    </form>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="6" class="text-secondary">Aucun prestataire trouve.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>

</div>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>