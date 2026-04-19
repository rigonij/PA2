<?php
$pageTitle = "SilverHappy • Planning";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";
?>
<div class="container py-4">
    <?php include __DIR__ . "/../common/topbar.php"; ?>
    <div class="row g-3">
        <div class="col-lg-3">
            <?php include __DIR__ . "/../common/sidebar.php"; ?>
        </div>
        <div class="col-lg-9">
            <div class="sh-card p-4 mb-3">
                <h1 class="h4 mb-1">Mon planning</h1>
                <p class="text-secondary mb-0">Événements et réservations à venir.</p>
            </div>
            <div class="sh-card p-4">
                <?php if (empty($items)): ?>
                    <div class="text-secondary">
                        Aucun élément dans votre planning pour le moment.
                    </div>
                <?php else: ?>
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Type</th>
                                    <th>Titre</th>
                                    <th>Lieu</th>
                                    <th>Statut</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($items as $it): ?>
                                    <?php
                                    $type    = $it["item_type"] ?? "";
                                    $refId   = (int)($it["ref_id"] ?? 0);
                                    $startAt = $it["start_at"] ?? "";
                                    $title   = $it["title"] ?? "";
                                    $location = $it["location"] ?? "";

                                    $dateLabel = "";
                                    $startAt = $it["start_at"] ?? "";

                                    if (strlen($startAt) >= 16) {
                                        $y = substr($startAt, 0, 4);
                                        $m = substr($startAt, 5, 2);
                                        $d = substr($startAt, 8, 2);
                                        $h = substr($startAt, 11, 2);
                                        $i = substr($startAt, 14, 2);
                                        $dateLabel = "$d/$m/$y $h:$i";
                                    }

                                    $typeLabel = "Autre";
                                    $badge = "text-bg-secondary";
                                    if ($type === "event") {
                                        $typeLabel = "Événement";
                                        $badge = "text-bg-primary";
                                    } elseif ($type === "service") {
                                        $typeLabel = "Service";
                                        $badge = "text-bg-success";
                                    } elseif ($type === "medical") {
                                        $typeLabel = "RDV médical";
                                        $badge = "text-bg-warning";
                                    }

                                    $statusLabel = "";
                                    $statusBadge = "";

                                    if ($type === "event") {
                                        $statusLabel = "Inscrit";
                                        $statusBadge = "text-bg-primary";
                                    } elseif ($type === "medical") {
                                        $statusLabel = "Confirmé";
                                        $statusBadge = "text-bg-success";
                                    } elseif ($type === "service") {
                                        $status           = $it["status"] ?? "";
                                        $adminApproved    = (int)($it["admin_approved"] ?? 0);
                                        $providerApproved = (int)($it["provider_approved"] ?? 0);

                                        if ($status === "Canceled") {
                                            $statusLabel = "Annulé";
                                            $statusBadge = "text-bg-danger";
                                        } elseif ($adminApproved === 1 && $providerApproved === 1) {
                                            $statusLabel = "Confirmé";
                                            $statusBadge = "text-bg-success";
                                        } elseif ($adminApproved === 1) {
                                            $statusLabel = "En attente prestataire";
                                            $statusBadge = "text-bg-warning";
                                        } elseif ($providerApproved === 1) {
                                            $statusLabel = "En attente admin";
                                            $statusBadge = "text-bg-warning";
                                        } else {
                                            $statusLabel = "En attente";
                                            $statusBadge = "text-bg-secondary";
                                        }
                                    }

                                    $cancelUrl = "";
                                    if ($type === "event") {
                                        $cancelUrl = "planning.php?action=unsubscribe_event&id=" . $refId;
                                    } elseif ($type === "medical") {
                                        $cancelUrl = "planning.php?action=delete_medical&id=" . $refId;
                                    } elseif ($type === "service") {
                                        $status = $it["status"] ?? "";
                                        if ($status !== "Canceled") {
                                            $cancelUrl = "planning.php?action=unreserve_service&id=" . $refId;
                                        }
                                    }
                                    ?>
                                    <tr>
                                        <td><?= htmlspecialchars($dateLabel) ?></td>
                                        <td>
                                            <span class="badge <?= $badge ?>">
                                                <?= htmlspecialchars($typeLabel) ?>
                                            </span>
                                        </td>
                                        <td><?= htmlspecialchars($title) ?></td>
                                        <td><?= htmlspecialchars($location) ?></td>
                                        <td>
                                            <?php if ($statusLabel): ?>
                                                <span class="badge <?= $statusBadge ?>">
                                                    <?= htmlspecialchars($statusLabel) ?>
                                                </span>
                                            <?php else: ?>
                                                <span class="text-secondary small">—</span>
                                            <?php endif; ?>
                                        </td>
                                        <td class="text-end">
                                            <?php if ($cancelUrl): ?>
                                                <a class="btn btn-outline-danger btn-sm"
                                                    href="<?= htmlspecialchars($cancelUrl) ?>"
                                                    onclick="return confirm('Annuler cette réservation ?');">
                                                    Annuler
                                                </a>
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