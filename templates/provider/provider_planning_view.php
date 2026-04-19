<?php
$pageTitle = "SilverHappy • Prestataire • Planning";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";
?>

<div class="container py-4">
    <?php include __DIR__ . "/partials/topbar.php"; ?>

    <div class="row g-3">
        <div class="col-lg-3">
            <?php include __DIR__ . "/partials/sidebar.php"; ?>
        </div>

        <div class="col-lg-9">
            <div class="sh-card p-4 mb-3">
                <h1 class="h4 mb-1">Planning • Prestataire</h1>
                <p class="text-secondary mb-0">Liste de vos interventions.</p>
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
                                <th>Début</th>
                                <th>Service</th>
                                <th>Senior</th>
                                <th>Ville</th>
                                <th>Statut</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (!empty($items)): ?>
                                <?php foreach ($items as $it): ?>
                                    <tr>
                                        <td><?= (int)($it["id"] ?? 0) ?></td>
                                        <td><?= htmlspecialchars($it["start_pretty"] ?? ($it["start_at"] ?? "")) ?></td>
                                        <td><?= htmlspecialchars($it["service_name"] ?? "N/A") ?></td>
                                        <td><?= htmlspecialchars($it["senior_email"] ?? "N/A") ?></td>
                                        <td><?= htmlspecialchars($it["city"] ?? "N/A") ?></td>
                                        <td><span class="badge badge-sh"><?= htmlspecialchars($it["status"] ?? "N/A") ?></span></td>
                                    </tr>
                                <?php endforeach; ?>
                            <?php else: ?>
                                <tr>
                                    <td colspan="6" class="text-secondary">Aucune intervention.</td>
                                </tr>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>
</div>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>