<?php
$pageTitle = "Admin • Réservations services";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";


function renderInterventionsTable($title, $items, $badgeClass)
{
?>
    <div class="mb-4">
        <h2 class="h5 fw-bold mb-2"><?= htmlspecialchars($title) ?></h2>

        <div class="sh-card p-3">
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Prestataire</th>
                            <th>Service</th>
                            <th>Statut</th>
                            <th style="width:1%;" class="text-end">Actions</th>
                        </tr>
                    </thead>

                    <tbody>
                        <?php if (!empty($items)): ?>
                            <?php foreach ($items as $it): ?>
                                <?php
                                $id = (int)($it["id"] ?? 0);
                                $startAt = $it["start_at"] ?? "";
                                $endAt = $it["end_at"] ?? "";
                                $company = $it["company_name"] ?? "";
                                $service = $it["service_name"] ?? "";
                                $status = $it["status"] ?? "Pending";
                                ?>
                                <tr>
                                    <td>
                                        <?= htmlspecialchars($startAt) ?>
                                        <?php if (!empty($endAt)): ?>
                                            <br><span class="text-secondary small">→ <?= htmlspecialchars($endAt) ?></span>
                                        <?php endif; ?>
                                    </td>

                                    <td class="fw-bold"><?= htmlspecialchars($company !== "" ? $company : "—") ?></td>
                                    <td><?= htmlspecialchars($service !== "" ? $service : "—") ?></td>

                                    <td>
                                        <span class="badge <?= htmlspecialchars($badgeClass) ?>">
                                            <?= htmlspecialchars($status) ?>
                                        </span>
                                    </td>

                                    <td class="text-end" style="white-space:nowrap;">
                                        <a class="btn btn-outline-success btn-sm"
                                            href="admin_interventions.php?action=set_status&id=<?= $id ?>&status=Confirmed"
                                            onclick="return confirm('Confirmer cette réservation ?');">
                                            Confirmer
                                        </a>

                                        <a class="btn btn-outline-secondary btn-sm"
                                            href="admin_interventions.php?action=set_status&id=<?= $id ?>&status=Pending"
                                            onclick="return confirm('Remettre en attente ?');">
                                            Pending
                                        </a>

                                        <a class="btn btn-outline-danger btn-sm"
                                            href="admin_interventions.php?action=set_status&id=<?= $id ?>&status=Canceled"
                                            onclick="return confirm('Annuler cette réservation ?');">
                                            Annuler
                                        </a>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <tr>
                                <td colspan="5" class="text-secondary">Aucune réservation.</td>
                            </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
<?php
}
?>

<div class="container py-4">
    <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
        <div>
            <h1 class="h4 mb-1">Réservations services</h1>
            <p class="text-secondary mb-0">Gestion admin : Pending / Confirmed / Canceled</p>
        </div>

        <a class="btn btn-outline-secondary" href="admin_dashboard.php">← Retour</a>
    </div>

    <div class="mb-3">
        <div class="sh-card p-4">
            <div class="d-flex flex-wrap gap-2">
                <span class="badge text-bg-warning">En attente: <?= count($pending ?? []) ?></span>
                <span class="badge text-bg-success">Confirmées: <?= count($confirmed ?? []) ?></span>
                <span class="badge text-bg-secondary">Annulées: <?= count($canceled ?? []) ?></span>
            </div>
        </div>
    </div>

    <?php
    renderInterventionsTable("En attente", $pending ?? [], "text-bg-warning");
    renderInterventionsTable("Confirmées", $confirmed ?? [], "text-bg-success");
    renderInterventionsTable("Annulées", $canceled ?? [], "text-bg-secondary");
    ?>
</div>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>