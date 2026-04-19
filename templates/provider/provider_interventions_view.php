<?php
$pageTitle = "SilverHappy • Mes interventions";
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
                <h1 class="h4 mb-1">Mes interventions</h1>
                <p class="text-secondary mb-0">Réservations faites par les seniors pour vos services.</p>
            </div>
            <div class="sh-card p-4">
                <?php if (empty($interventions)): ?>
                    <div class="text-secondary">Aucune intervention pour le moment.</div>
                <?php else: ?>
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Service</th>
                                    <th>Senior</th>
                                    <th>Commentaire</th>
                                    <th>Statut</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($interventions as $it): ?>
                                    <?php
                                    $id              = (int)($it["id"] ?? 0);
                                    $dateStart       = $it["date_start"] ?? "";
                                    $status          = $it["status"] ?? "";
                                    $adminApproved   = (int)($it["admin_approved"] ?? 0);
                                    $providerApproved = (int)($it["provider_approved"] ?? 0);
                                    $serviceName     = $it["service_name"] ?? "";
                                    $seniorName      = trim(($it["senior_prenom"] ?? "") . " " . ($it["senior_nom"] ?? ""));
                                    $comment         = $it["comment"] ?? "";

                                    if ($status === "Canceled") {
                                        $statusLabel = "Annulé par le senior";
                                        $statusBadge = "text-bg-danger";
                                    } elseif ($status === "Refused") {
                                        $statusLabel = "Refusé";
                                        $statusBadge = "text-bg-danger";
                                    } elseif ($status === "Accepted") {
                                        $statusLabel = "Confirmé";
                                        $statusBadge = "text-bg-success";
                                    } elseif ($adminApproved === 1 && $providerApproved === 0) {
                                        $statusLabel = "En attente de votre validation";
                                        $statusBadge = "text-bg-warning";
                                    } elseif ($providerApproved === 1 && $adminApproved === 0 && $status !== "Accepted") {
                                        $statusLabel = "En attente de l'admin";
                                        $statusBadge = "text-bg-warning";
                                    } elseif ($status === "Accepted" || ($adminApproved === 1 && $providerApproved === 1)) {
                                        $statusLabel = "Confirmé";
                                        $statusBadge = "text-bg-success";
                                    } else {
                                        $statusLabel = "En attente";
                                        $statusBadge = "text-bg-secondary";
                                    }

                                    $canAct = ($providerApproved === 0 && !in_array($status, ["Canceled", "Refused", "Accepted"]));
                                    ?>
                                    <tr>
                                        <td><?= htmlspecialchars($dateStart) ?></td>
                                        <td><?= htmlspecialchars($serviceName) ?></td>
                                        <td><?= htmlspecialchars($seniorName) ?></td>
                                        <td class="text-secondary small"><?= htmlspecialchars($comment) ?: "—" ?></td>
                                        <td>
                                            <span class="badge <?= $statusBadge ?>">
                                                <?= htmlspecialchars($statusLabel) ?>
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            <?php if ($canAct): ?>
                                                <form method="POST" action="provider_interventions.php"
                                                    class="d-inline"
                                                    onsubmit="return confirm('Accepter cette intervention ?');">
                                                    <input type="hidden" name="action" value="approve">
                                                    <input type="hidden" name="intervention_id" value="<?= $id ?>">
                                                    <button type="submit" class="btn btn-success btn-sm">
                                                        Accepter
                                                    </button>
                                                </form>
                                                <form method="POST" action="provider_interventions.php"
                                                    class="d-inline ms-1"
                                                    onsubmit="return confirm('Refuser cette intervention ?');">
                                                    <input type="hidden" name="action" value="refuse">
                                                    <input type="hidden" name="intervention_id" value="<?= $id ?>">
                                                    <button type="submit" class="btn btn-outline-danger btn-sm">
                                                        Refuser
                                                    </button>
                                                </form>
                                            <?php else: ?>
                                                <span class="text-secondary small">—</span>
                                            <?php endif; ?>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>
<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>