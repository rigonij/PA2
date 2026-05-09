<?php
$pageTitle = "SilverHappy • Signalements";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";

$reports = $reports ?? [];
$loadError = $loadError ?? "";
$flashSuccess = $flashSuccess ?? "";
$flashError = $flashError ?? "";
$activeStatus = $activeStatus ?? "pending";

$counts = ["pending" => 0, "resolved" => 0, "dismissed" => 0];
foreach ($reports as $r) {
    $s = $r["status"] ?? "pending";
    if (isset($counts[$s])) $counts[$s]++;
}

$filtered = array_values(array_filter($reports, function ($r) use ($activeStatus) {
    return ($r["status"] ?? "pending") === $activeStatus;
}));

$fmt = function ($iso) {
    if (empty($iso)) return "";
    try {
        $d = new DateTime($iso);
        $d->setTimezone(new DateTimeZone("Europe/Paris"));
        return $d->format("d/m/Y H:i");
    } catch (Exception $e) {
        return htmlspecialchars($iso);
    }
};
?>
<div class="container py-4">
    <div class="sh-card p-4 mb-3">
        <div class="d-flex justify-content-between align-items-start">
            <div>
                <h1 class="h4 fw-bold mb-1">Signalements d'utilisateurs</h1>
                <p class="text-secondary mb-0">Liste des signalements remontés par les utilisateurs. Cliquez sur "Voir le casier" pour gérer les sanctions.</p>
            </div>
            <a href="admin_dashboard.php" class="btn btn-outline-secondary btn-sm">Retour</a>
        </div>
    </div>

    <?php if (!empty($flashSuccess)): ?>
        <div class="alert alert-success"><?= htmlspecialchars($flashSuccess) ?></div>
    <?php endif; ?>
    <?php if (!empty($flashError)): ?>
        <div class="alert alert-danger"><?= htmlspecialchars($flashError) ?></div>
    <?php endif; ?>
    <?php if (!empty($loadError)): ?>
        <div class="alert alert-warning"><?= htmlspecialchars($loadError) ?></div>
    <?php endif; ?>

    <div class="sh-card p-3 mb-3">
        <ul class="nav nav-pills gap-2">
            <li class="nav-item">
                <a class="nav-link <?= $activeStatus === 'pending' ? 'active' : '' ?>" href="admin_user_reports.php?status=pending">
                    En attente <span class="badge bg-secondary ms-1"><?= $counts["pending"] ?></span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <?= $activeStatus === 'resolved' ? 'active' : '' ?>" href="admin_user_reports.php?status=resolved">
                    Traités <span class="badge bg-secondary ms-1"><?= $counts["resolved"] ?></span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <?= $activeStatus === 'dismissed' ? 'active' : '' ?>" href="admin_user_reports.php?status=dismissed">
                    Rejetés <span class="badge bg-secondary ms-1"><?= $counts["dismissed"] ?></span>
                </a>
            </li>
        </ul>
    </div>

    <div class="sh-card p-3">
        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Signalé par</th>
                        <th>Utilisateur signalé</th>
                        <th>Raison</th>
                        <th>Statut</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (empty($filtered)): ?>
                        <tr>
                            <td colspan="6" class="text-secondary text-center py-4">Aucun signalement dans cette catégorie.</td>
                        </tr>
                    <?php else: ?>
                        <?php foreach ($filtered as $r): ?>
                            <?php
                            $reporterName = trim(($r["reporter_prenom"] ?? "") . " " . ($r["reporter_nom"] ?? ""));
                            if ($reporterName === "") $reporterName = $r["reporter_email"] ?? "—";
                            $reportedName = trim(($r["reported_prenom"] ?? "") . " " . ($r["reported_nom"] ?? ""));
                            if ($reportedName === "") $reportedName = $r["reported_email"] ?? "—";
                            $status = $r["status"] ?? "pending";
                            $badgeClass = $status === "pending" ? "bg-warning text-dark" : ($status === "resolved" ? "bg-success" : "bg-secondary");
                            $badgeLabel = $status === "pending" ? "En attente" : ($status === "resolved" ? "Traité" : "Rejeté");
                            $reportedId = (int)($r["reported_id"] ?? 0);
                            ?>
                            <tr>
                                <td><?= $fmt($r["created_at"] ?? "") ?></td>
                                <td>
                                    <div class="fw-bold"><?= htmlspecialchars($reporterName) ?></div>
                                    <div class="small text-secondary"><?= htmlspecialchars($r["reporter_email"] ?? "") ?></div>
                                </td>
                                <td>
                                    <div class="fw-bold"><?= htmlspecialchars($reportedName) ?></div>
                                    <div class="small text-secondary"><?= htmlspecialchars($r["reported_email"] ?? "") ?></div>
                                </td>
                                <td style="max-width:320px;">
                                    <div class="text-truncate" title="<?= htmlspecialchars($r["reason"] ?? "") ?>"><?= htmlspecialchars($r["reason"] ?? "") ?></div>
                                </td>
                                <td><span class="badge <?= $badgeClass ?>"><?= $badgeLabel ?></span></td>
                                <td class="text-end">
                                    <?php if ($reportedId > 0): ?>
                                        <a href="admin_user_sanctions.php?id=<?= $reportedId ?>" class="btn btn-sm btn-outline-primary">Voir le casier</a>
                                    <?php else: ?>
                                        <span class="text-secondary small">—</span>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<?php
include __DIR__ . "/../common/footer-scripts.php";
?>