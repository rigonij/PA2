<?php

$pageTitle = "Admin • Services prestataires";

include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";

$pending = [];
$approved = [];
$rejected = [];

foreach (($items ?? []) as $it) {
    $vs = (int)($it["validation_status"] ?? 0);
    if ($vs === 1) $approved[] = $it;
    else if ($vs === 2) $rejected[] = $it;
    else $pending[] = $it;
}

function renderServicesTable($items)
{ ?>
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
                        <th style="width:1%;">Actions</th>
                    </tr>
                </thead>

                <tbody>
                    <?php if (!empty($items)): ?>
                        <?php foreach ($items as $it): ?>
                            <?php
                            $providerId = (int)($it["provider_id"] ?? 0);
                            $serviceTypeId = (int)($it["service_type_id"] ?? 0);
                            $company = $it["company_name"] ?? "";
                            $service = $it["service_name"] ?? "";
                            $title = $it["custom_title"] ?? "";
                            $price = (float)($it["negotiated_price"] ?? 0);
                            $exp = (int)($it["experience_years"] ?? 0);
                            $active = !empty($it["is_active"]);
                            $vstatus = (int)($it["validation_status"] ?? 0);
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

                                <td style="white-space:nowrap;">
                                    <?php if ($vstatus === 1): ?>
                                        <span class="badge text-bg-success me-2">Validé</span>
                                    <?php elseif ($vstatus === 2): ?>
                                        <span class="badge text-bg-danger me-2">Refusé</span>
                                    <?php else: ?>
                                        <span class="badge text-bg-warning me-2">En attente</span>
                                    <?php endif; ?>

                                    <?php if ($vstatus === 0): ?>
                                        <form method="POST" class="d-inline">
                                            <input type="hidden" name="provider_id" value="<?= $providerId ?>">
                                            <input type="hidden" name="service_type_id" value="<?= $serviceTypeId ?>">
                                            <input type="hidden" name="status" value="1">
                                            <button class="btn btn-success btn-sm" type="submit">Valider</button>
                                        </form>

                                        <form method="POST" class="d-inline" onsubmit="return confirm('Refuser ce service ?');">
                                            <input type="hidden" name="provider_id" value="<?= $providerId ?>">
                                            <input type="hidden" name="service_type_id" value="<?= $serviceTypeId ?>">
                                            <input type="hidden" name="status" value="2">
                                            <button class="btn btn-danger btn-sm" type="submit">Refuser</button>
                                        </form>

                                    <?php elseif ($vstatus === 1): ?>
                                        <form method="POST" class="d-inline" onsubmit="return confirm('Refuser ce service validé ?');">
                                            <input type="hidden" name="provider_id" value="<?= $providerId ?>">
                                            <input type="hidden" name="service_type_id" value="<?= $serviceTypeId ?>">
                                            <input type="hidden" name="status" value="2">
                                            <button class="btn btn-danger btn-sm" type="submit">Refuser</button>
                                        </form>

                                    <?php else: ?>
                                        <form method="POST" class="d-inline">
                                            <input type="hidden" name="provider_id" value="<?= $providerId ?>">
                                            <input type="hidden" name="service_type_id" value="<?= $serviceTypeId ?>">
                                            <input type="hidden" name="status" value="1">
                                            <button class="btn btn-success btn-sm" type="submit">Valider</button>
                                        </form>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        <?php endforeach; ?>

                    <?php else: ?>
                        <tr>
                            <td colspan="7" class="text-secondary">Aucun service.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
<?php } ?>

<div class="container py-4">
    <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
        <div>
            <h1 class="h4 mb-1">Validation • Services prestataires</h1>
            <p class="text-secondary mb-0">Tout le catalogue prestataire, avec statut.</p>
        </div>
        <a class="btn btn-outline-secondary" href="admin_dashboard.php">← Retour</a>
    </div>

    <?php if (!empty($error)): ?>
        <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>

    <?php if (!empty($success)): ?>
        <div class="alert alert-success"><?= htmlspecialchars($success) ?></div>
    <?php endif; ?>

    <div class="mb-3">
        <div class="sh-card p-4">
            <div class="d-flex flex-wrap gap-2">
                <span class="badge text-bg-warning">En attente: <?= count($pending) ?></span>
                <span class="badge text-bg-success">Validés: <?= count($approved) ?></span>
                <span class="badge text-bg-danger">Refusés: <?= count($rejected) ?></span>
            </div>
        </div>
    </div>

    <div class="mb-4">
        <h2 class="h5 fw-bold mb-2">En attente</h2>
        <?php renderServicesTable($pending); ?>
    </div>

    <div class="mb-4">
        <h2 class="h5 fw-bold mb-2">Validés</h2>
        <?php renderServicesTable($approved); ?>
    </div>

    <div class="mb-4">
        <h2 class="h5 fw-bold mb-2">Refusés</h2>
        <?php renderServicesTable($rejected); ?>
    </div>
</div>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>