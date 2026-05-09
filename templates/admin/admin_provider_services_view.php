<?php
$pageTitle = "Admin • Services prestataires";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";

$online = $items ?? [];
?>
<div class="container py-4">
    <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
        <div>
            <h1 class="h4 mb-1">Services prestataires</h1>
            <p class="text-secondary mb-0">Catalogue des services actuellement en ligne.</p>
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
                        <th>Prestataire</th>
                        <th>Service</th>
                        <th>Titre</th>
                        <th>Prix</th>
                        <th>Exp</th>
                        <th>Actif</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($online)): ?>
                        <?php foreach ($online as $it): ?>
                            <?php
                            $providerId = (int)($it["provider_id"] ?? 0);
                            $serviceTypeId = (int)($it["service_type_id"] ?? 0);
                            $company = $it["company_name"] ?? "";
                            $service = $it["service_name"] ?? "";
                            $title = $it["custom_title"] ?? "";
                            $price = (float)($it["negotiated_price"] ?? 0);
                            $exp = (int)($it["experience_years"] ?? 0);
                            $active = !empty($it["is_active"]);
                            ?>
                            <tr>
                                <td class="fw-bold"><?= htmlspecialchars($company) ?> (<?= $providerId ?>)</td>
                                <td><?= htmlspecialchars($service) ?> (#<?= $serviceTypeId ?>)</td>
                                <td><?= htmlspecialchars($title !== "" ? $title : "—") ?></td>
                                <td><?= number_format($price, 2, ",", " ") ?> €</td>
                                <td><?= $exp ?> ans</td>
                                <td>
                                    <?php if ($active): ?>
                                        <span class="badge text-bg-success">Actif</span>
                                    <?php else: ?>
                                        <span class="badge text-bg-secondary">Inactif</span>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="6" class="text-secondary">Aucun service en ligne.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<?php include __DIR__ . "/../common/footer-scripts.php"; ?>